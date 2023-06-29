const canvas = document.querySelector('#canvas');
const ctx = canvas.getContext('2d');
let WindowResolution = {
    width: window.innerWidth,
    height: window.innerHeight
}
let Translation = {}
let Colours = {}

function draw(players) {
    ctx.reset()
    for (const [index, obj] of Object.entries(players)) {
        const { crds } = obj
        if (!crds)
            continue;
        const _x = crds.x * WindowResolution.width
        const _y = crds.y * WindowResolution.height
        ctx.font = "bold 20px Casper";
        ctx.textAlign = "center";
        ctx.fillStyle = `rgb(${Colours.LeftGame.r}, ${Colours.LeftGame.g}, ${Colours.LeftGame.b})`;
        ctx.shadowColor = "black";
        ctx.shadowBlur = 7;
        ctx.lineWidth = 5;
        const textX = _x;
        ctx.fillText(Translation.left_game_text, textX, _y);
        ctx.fillStyle = `rgb(${Colours.PlayerInfo.r}, ${Colours.PlayerInfo.g}, ${Colours.PlayerInfo.b})`;
        ctx.fillText("ID: " + index + " (" + obj.identifier + ")", textX, _y+40);
        ctx.fillText(`${Translation.reason_text}:  ${obj.reason}`, textX, _y+70);
    }
}

function ClearCanvas() {
    ctx.reset()
}

window.addEventListener('message', function(event) {
    var item = event.data;

    switch(item.type) {
        case "translation":
            Translation = item.translation
            break;
        case "colours":
            Colours = item.colours
            break;
        case "dropped_coords":
            draw(item.players);
            break;
        case "clear_canvas":
            ClearCanvas();
            break;
        case "resolution":
            const width = window.innerWidth;
            const height = window.innerHeight;
            if (width == 1920 && height == 1080)
                if (item.screen.w != width && item.screen.h != height) {
                    WindowResolution.width = 1920
                    WindowResolution.height = 1080
                    $.post(`http://${GetParentResourceName()}/fixed_nui_size`);
                    break;
                }
            WindowResolution.width = item.screen.w;
            WindowResolution.height = item.screen.h
            ctx.canvas.width = item.screen.w;
            ctx.canvas.height = item.screen.h;
            break;
    }
})

window.addEventListener("resize", function() {
    const width = window.innerWidth;
    const height = window.innerHeight;
    WindowResolution.width = width
    WindowResolution.height = height
});