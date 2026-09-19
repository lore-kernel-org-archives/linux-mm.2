Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BEEC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 14:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E59F6B0092; Sat, 19 Sep 2026 10:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6965B6B0093; Sat, 19 Sep 2026 10:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585106B0095; Sat, 19 Sep 2026 10:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27D5E6B0092
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:15:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0EB814027B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:15:50 +0000 (UTC)
X-FDA: 85230710460.27.2B56A89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3B924C0006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:15:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G23z1QDz;
	spf=pass (imf10.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789827348;
	b=cSho0jvrwpRQwk3Yr1Xcd9jJ3CXRO2oTg0ePrJqUcKAXLgqDiFuUvPhqB1nphRW1ZAL+ZM
	sNhVvvA92Bq9oZOHq9n097KmTN4DhFOLl4TlFH3iWMWoZK+aEdgmILZShcoH/0U7g90fix
	QH8Q7zrADVqxzdpAwvjT1P633kPFTAs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G23z1QDz;
	spf=pass (imf10.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789827348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHQNt2F7ph//QKd/Dcx1X0C3z22bcWkHaUtkyigDYBI=;
	b=j6yr2Ny5qu68npW8CJoNOTGwXfsl7ExezHeCif8onvtIXebrwQbjjuGvoFR3mtzXKcz6te
	27qZ+gm2P2TkxGT5sSlfTmy6h0hnWqrowBSCmdn2PdPfw0EOsgtU2JyVV3MppLnzJk0kxG
	h1MoFwL2KwWWtOUtcRODAb0i3wvG1yw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73BD741186
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588A71F0089F
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789827347;
	bh=ZHQNt2F7ph//QKd/Dcx1X0C3z22bcWkHaUtkyigDYBI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G23z1QDzc3fsSxuhTrLJIpBQgKbxieWQRWlzynMgFWSINgiqaTqh+lYvFgxMKLhJl
	 P5g+IxmxBWkqE9KttwTeaIyQdPkFB5m29YiCCQOHIJtEETSDKv1uBvcpedPCfMOt9l
	 IZYJlQnO4sDaZSCuqa5UxFM+hTJMX3cChIrtb8bGYu/VaXfyTKknqX5r6AlmwJep0x
	 No90WJ3vojX8xw+Bn4YSUwzZV6oOuAkdi7JoEprJS2ZBTP28ByKCvHmTl1gD5olAjb
	 CeRnCsNOqOPiucci/V+AnzxFD4ZDK3DhPntFhf84SooweR4VOloAZlq07NKzVY4eWf
	 a8R9WHhLJ3ndA==
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a60590a85cso3140336a12.0
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:15:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBykkluHMHGC4fOZfmrWTi8ebQ0Te0NOGh53gf2/Nm1arcH5Vimzfmh/FXgPiEVd81MmwWsNB7P1vw==@kvack.org
X-Gm-Message-State: AFuF++lUdhEV6ghOQSb5h7aUHorpuCFKsaNSjrL502l1+lEabtGu6JXH
	7pf2VQTYSXS7N1IdZwbHmVTk8KJ1cMu4qz4hPhuGKRMjXj3aKP3tP9f1UqRohNBrJTCh1/vXNmw
	odmF4lmwiW8QxNvhzo88FB/TzUTMPMSo=
X-Received: by 2002:a05:6402:21d3:b0:6a9:a5d6:622d with SMTP id
 4fb4d7f45d1cf-6aa577f53cdmr3570046a12.3.1789827345998; Sat, 19 Sep 2026
 07:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260904100852.26006-1-dongtai.guo@linux.dev> <20260904100852.26006-3-dongtai.guo@linux.dev>
In-Reply-To: <20260904100852.26006-3-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 19 Sep 2026 22:15:37 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6uKKzXgrb8YK+VAdW55ODWtXp0bEju=dcmm7=MVxcc-A@mail.gmail.com>
X-Gm-Features: AcwNN1UTKroSTs8ThQILzapvRn9O7BvQxeeOOihMqsFr5wFvKBxjbfZvuj-g5Cw
Message-ID: <CAAhV-H6uKKzXgrb8YK+VAdW55ODWtXp0bEju=dcmm7=MVxcc-A@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] liveupdate: synchronize EFI KHO channel at execution
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, ruirui.yang@linux.dev, 
	guodongtai@kylinos.cn, kernel@xen0n.name, graf@amazon.com, 
	liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3B924C0006
X-Stat-Signature: bn1zs3we8ejdpuoi695oojmwgs3d5euq
X-HE-Tag: 1789827348-667902
X-HE-Meta: U2FsdGVkX1+Hi9SOHlbVk+xgLG4t9617ztdMo/guyoHt3l016RwQDn+fKgLs9tauo4L+LvcIX6aRNgD7Zwl0Xb3naY0wChPpmUzK58A3HWcUERVWHD4bb4x+fOO0MIsEHd5jWHYpNQF1WN2bA6bq1BHLhOdmZNfiWjNFCMd5pebo9LivUHAi1vWQBe06FVC9ikQMeHPetNlCHrY1RtyC5B8BgEW8a7ZW0suzmV0bchZxNBdGacQPM6xde01tInFgJ8p+x4s7vg7UkShIcU2nMgXxf0vMWgE1m6fRInAk4u3F+hZbmIHWL9YG5YgnoZGxP1KuCoGQxXSaHFcK6mAEjdRm8kqfZCsFncA9pGcEFM/jjm78xlSY/ami8+dR+LT8WjtQwtxQDxSRqFRgAargwz8/ZcLxLZZSsslJVVpg8rRYp2V2JDGqQXt3YQ4staAbSBdu51zWzYiCxAthsMLXnZYHQ59yPCOHloMzQtOd44dgKhsa/UFn7FvaaCihXLewXEQ9r7EilE3iiXvWoMDz9H4iWn/o3Osvl+ZvwiopmXyE9LeIPLbzo+Yut9NNUtTFbLOhEtvbaV9Kw3IAa/+eF1G1ueVBXH1Qe1SNulusw71+TXy+2aeAErE9vbxfciOp4bq3Z97VQpnp+/hpeY5sEYSgdtE+muyNDb/jKdqW7EWU/VRLi+hdxO8NgwRYD+417PlvuauyQAkDpoLY2myt8pE1g0sGt9lexsaBlnMyiiSXiCfAK0W8CYVGWNfVIbqmzEwKwKSxhNmlihU2AME4OPJqLt7ja7i6WZGI1EwFjOhe0h34acDhz1IjCVHzXPPEhhHjCAzvqiH+G8Db4EkTqjOCvUEL9WQwU3yz9l5FGjSMp07Jt1Kxio7lfY7JEqygpJZhQjpVRJDJy2yKnM9YRIoeSxpoPiqrf283hjLzywwMH6GhOjgdz9ToDfkhgBqIqovwdyEQNXn1FqQ7cZx
 5GQjr7F1
 GdR/0KAh2nJj6SDPuXnK+UWt+1BaYa3jwyhXiS1pnvTnR4gn6LPRchBfF172pEQgvEai2h8E5JCZ3S5PL9p/bPk/0cUQ466BwiRpJYaW4kzzb4+ffu4euO/Aw5P7HMvlXmtn782lfbl54T3Pf3YwVFd1ts5LDF74OkcdijKa2YtSX41qPB5gBuZ5J1V1X6onFgyUKMnKZtEZ0JSGJW1lBLn2WUFQYNTMEIH4l14EWimtjLT6FC0AsQTogjBQ5M/Wm+HxxetlcjfdjP3cl8XDcNfli6CgPEB3rnZHVRBbj/f4BmePP4Lxm/6m+hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, George,

On Fri, Sep 4, 2026 at 6:10=E2=80=AFPM George Guo <dongtai.guo@linux.dev> w=
rote:
>
> From: George Guo <guodongtai@kylinos.cn>
>
> The EFI KHO configuration table is a global channel. Updating it while
> a candidate kexec image is still being loaded can leave the channel
> pointing at the failed candidate even though the previous image remains
> installed. Synchronize it instead from the image selected for execution.
>
> Use the actual scratch payload size rather than its page-aligned segment
> size, and propagate update failures before live-update serialization.
> Keep clearing the channel for cold and crash images best-effort.
>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  kernel/crash_core.c                |  7 +++++++
>  kernel/kexec_core.c                |  5 +++++
>  kernel/kexec_internal.h            |  3 +++
>  kernel/liveupdate/kexec_handover.c | 33 ++++++++++++++++++++++++++++++
>  4 files changed, 48 insertions(+)
>
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index 2b36aa9fade0..6166ce4203d3 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -138,6 +138,13 @@ void __noclone __crash_kexec(struct pt_regs *regs)
>                 if (kexec_crash_image) {
>                         struct pt_regs fixed_regs;
>
> +                       /*
> +                        * A crash image carries no KHO state: clear the
> +                        * transport so the crash kernel boots cold inste=
ad
> +                        * of reviving from stale state.
> +                        */
> +                       (void)kho_sync_channel(kexec_crash_image);
> +
>                         crash_setup_regs(&fixed_regs, regs);
>                         crash_save_vmcoreinfo();
>                         machine_crash_shutdown(&fixed_regs);
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index dc770b9a6d05..147f5b5b23d4 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -1146,6 +1146,11 @@ int kernel_kexec(void)
>                 goto Unlock;
>         }
>
> +       /* Synchronize the handover transport with the image being execut=
ed. */
> +       error =3D kho_sync_channel(kexec_image);
> +       if (error)
> +               goto Unlock;
> +
>         if (!kexec_image->preserve_context) {
>                 error =3D liveupdate_reboot();
>                 if (error)
> diff --git a/kernel/kexec_internal.h b/kernel/kexec_internal.h
> index 228bb88c018b..4d4c2290e85c 100644
> --- a/kernel/kexec_internal.h
> +++ b/kernel/kexec_internal.h
> @@ -46,6 +46,7 @@ struct kexec_buf;
>  int kho_locate_mem_hole(struct kexec_buf *kbuf,
>                         int (*func)(struct resource *, void *));
>  int kho_fill_kimage(struct kimage *image);
> +int kho_sync_channel(struct kimage *image);
>  #else
>  static inline int kho_locate_mem_hole(struct kexec_buf *kbuf,
>                                       int (*func)(struct resource *, void=
 *))
> @@ -54,5 +55,7 @@ static inline int kho_locate_mem_hole(struct kexec_buf =
*kbuf,
>  }
>
>  static inline int kho_fill_kimage(struct kimage *image) { return 0; }
> +
> +static inline int kho_sync_channel(struct kimage *image) { return 0; }
>  #endif /* CONFIG_KEXEC_HANDOVER */
>  #endif /* LINUX_KEXEC_INTERNAL_H */
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 39f489a258d9..3aa5c66dfc6d 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -14,6 +14,7 @@
>  #include <linux/cma.h>
>  #include <linux/kmemleak.h>
>  #include <linux/count_zeros.h>
> +#include <linux/efi.h>
>  #include <linux/kasan.h>
>  #include <linux/kexec.h>
>  #include <linux/kexec_handover.h>
> @@ -2074,6 +2075,38 @@ int kho_fill_kimage(struct kimage *image)
>         return 0;
>  }
>
> +/*
> + * Synchronize the handover transport with the image that is about to be
> + * executed.  The EFI config table channel is global, while kexec keeps
> + * separate images for a normal reboot and for crash.  Write the state o=
f the
> + * selected image immediately before it is executed, rather than while a
> + * candidate image is being loaded, so a failed replacement cannot leave=
 the
> + * channel pointing at that failed image.
> + *
> + * An image loaded through the legacy kexec_load() syscall, a crash imag=
e, or
> + * an image loaded while KHO is disabled carries no handover state.  Cle=
ar the
> + * channel for those images so the next kernel boots cold instead of rev=
iving
> + * from stale state.  Clearing is best-effort because an absent channel =
cannot
> + * affect a cold boot.
> + */
> +int kho_sync_channel(struct kimage *image)
> +{
> +       int err;
> +
> +       if (!image->kho.fdt || !image->kho.scratch) {
> +               efi_kho_update(0, 0, 0, 0);
> +               return 0;
> +       }
> +
> +       err =3D efi_kho_update(image->kho.fdt, PAGE_SIZE,
> +                            image->kho.scratch->mem,
> +                            image->kho.scratch->bufsz);
You can combine the last two lines.


Huacai

> +       if (err)
> +               pr_warn("failed to update EFI config table: %d\n", err);
> +
> +       return err;
> +}
> +
>  static int kho_walk_scratch(struct kexec_buf *kbuf,
>                             int (*func)(struct resource *, void *))
>  {
> --
> 2.53.0
>

