Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3054EFD88DD
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 02:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1B66B0089; Tue, 10 Mar 2026 22:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370B76B008A; Tue, 10 Mar 2026 22:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E796B008C; Tue, 10 Mar 2026 22:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 01F5E6B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:07:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BE3C140448
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:07:36 +0000 (UTC)
X-FDA: 84532145712.16.F175B2C
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 505E040006
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:07:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QZr8rYdW;
	spf=pass (imf07.hostedemail.com: domain of wenst@chromium.org designates 209.85.167.50 as permitted sender) smtp.mailfrom=wenst@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773194854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
	b=ezABNRZ47GnT2IGKIK4ClkaefE8XG+8EDi9GD3li3mBgqcAmwKN5P+o+5iTFLRVQhKVCyl
	s4abm6KqohKoFuRJWVsj9qkYSKeFHG6Al1Z+9MsBRyM8ChnuK/cApYDCvhNBK/FIQON3Zn
	t7oZAKQXLGKtlxYPMvIPU5MOmJgLEis=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=QZr8rYdW;
	spf=pass (imf07.hostedemail.com: domain of wenst@chromium.org designates 209.85.167.50 as permitted sender) smtp.mailfrom=wenst@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773194854; a=rsa-sha256;
	cv=pass;
	b=n2TZQUqfe+hZXfpUKve/QdqRebr47B25R9IPokGVRlwrhkceAaPitNb+sCezQbLjZglFMR
	YdjE5Kh6uKqRbajRQiqdTzXWVXGtgMiDhEWUZC18bDQLhPBfiql1lOYgNaLZPAdvhNj7/i
	XpsDHok0Vgv/XG35a/JXyXbvs1Ut3oc=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a1362c9a3cso5630113e87.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:07:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773194852; cv=none;
        d=google.com; s=arc-20240605;
        b=aRDFfj6kjD6UIqGEmVBfjSJm0ZR7+SNyzVIH7/HNgiHSA+1geepbAy6syRufY52bEq
         1g5TjTDt8XUjEXMRnAqwzCoBHX8lcPH1N5t9kPjsAl6fEqY1eMarysTz66vLPbo0dGcV
         vJ8qttlwDkj9dND+64qcAYtzKEoc138mjGqQh/+QngE4w5S0a6Jui4/jlWUtTmtBKLqt
         NfLCTYWq05l9VNRBeqbVxNoNFagjh454pt6LPErQjEm2R0iOu4n1JPMLSCakGRrZHOUQ
         qsz6ltdYs6p3FnVERVEZBiqzgJ6WIRMV/PDQBH9HoqcOtCvn5TybriKQftFvtzzI4tsF
         ox7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
        fh=mrMe4DJKCQFa1l9OTUiy4/yTrEnmxZ5/XPdDeyt3KV4=;
        b=VwOYARA+iheO+YKtSFrbfg6KJra2DKQAj0K/j9EKaGd3Fa8plU6jqXxGpXRa/BPM5p
         G8WT9VfYtQY5i/GmzURwokvZq6kpVAqL0VW4kdGHTNLzix1sYa6839ZOjGhlAcPl+sgg
         4jH0yYdLsdK50t8zdAAvpKMvsh+Eu5qYPrx1AOhHWCb/0b3quMcQVYPxY+wcku3DtJmM
         NXebu+rgAsDiX7JCzgqWiTvphlnsNIR/Yyof3HlYwcNJYgMNqm0ZNp9j5PCC+F/kp+CV
         22uoZtsJMJDBIQsZEIv1DGqHmLtcFJQuvpf6jnGvg3rpML6/9uNAak7aIFMUE6x9OaUJ
         UB7g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773194852; x=1773799652; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
        b=QZr8rYdWuAucNs0X6kjIOcaJw7efh3pxBiou7MoBDFXSU9hCiDr/t0+rukydc10qjF
         juUPl140ZnNtNzOfecaePJHNRMFOJ5Re4GraQi+HGPUWL9pqYZY/6mXIH/5PB2XLzRya
         VwEFYzUn8Y6apDFWBlyvPP8voEOBEmF8pWYUU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773194852; x=1773799652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
        b=n8IuyEp9RSkpHg9kW+PZieoI8msWCsIZ9irtIxTBO9g4AwoJRKixJoPOKJBHCZefp6
         ZeL2nR3FNf3sAbLy8e9g+nala5Mx1YEcOo0iFAUFhWlq+/DayxusGINCfrtqILhBBf6z
         DTtJLPLtDej97KTGglbl3bTEZlzXGVpLhIIA5r+bNVWySsc4dfLv1qQLrGCI/nQ5/+dD
         ejlMNrprgoOXZneTvbqXS0tsLMFL2AvGueoMvk7WVb490qc1grXjzIIgja47qvdYswdT
         kT5N7Pw5R5N4zxWaWUaXvzG6hP3IHO366byl1iXKuQ3sowrXwCmo/X+EH4f0gaBAdZ+B
         2OPw==
X-Forwarded-Encrypted: i=1; AJvYcCXSL1yNBNcGJW+MIIUC1uV7AO+Fj24q0Haj0NjBPsLePlVHa9FxU3b6mJn/JUu2PvtjF6e2hX0IhA==@kvack.org
X-Gm-Message-State: AOJu0YwcDVp962kTvKV0x2R1kXr75H//tFHkh0ipFkT1hpFg0u08kY3d
	Eds4ECqJCz4nFkUqcoInUpb/N6j7MPbLNWcZ5yR3tsUM3P9nNi+UYDTrtX4Gq1wTqJC5fpapDnD
	bO3O687f2jxDluLB0EARWLSD+y1T4j/kCgnOtkGXC
X-Gm-Gg: ATEYQzz5l8Zaf4cgICuYOSXB2mg4MqWn1y/fQBNAXwGSZg6uwXVx7QDqE1LtPXhSgw0
	rsBUh5kFHyThgnZWRWhvlDCZnPSxLNZQmeRncvj3+3ktkyrIGhODjzG6TzdRdyDMYSuxzZ6lE/A
	qh9u5zBssTZ8H6/0jeaU71RiBfog0/tCDY2ynnfRVJ52WsIBSPKClKYV5vm+L0TPLiflYQvAIMU
	BAmYG6OAujIkmqTPAjaP54rITHy1V1z1662wRbRIb/2aFSJDAv/8ahSz4bnqP+nTiVt+2arkBun
	8y6VGw10YA==
X-Received: by 2002:ac2:4427:0:b0:5a1:3134:9bac with SMTP id
 2adb3069b0e04-5a156cbd1bbmr169453e87.28.1773194852284; Tue, 10 Mar 2026
 19:07:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Wed, 11 Mar 2026 11:07:21 +0900
X-Gm-Features: AaiRm5028PWt8n-JnveiRgn8oYMksdR_-_nk4JOkvxMfplWs-GDr7RRk-OxICyw
Message-ID: <CAGXv+5FQAVaJjqhv+Xq-ysOc4SHQn2mCNTgCAp8XocmWBWGGoA@mail.gmail.com>
Subject: Re: [PATCH 56/61] clk: Prefer IS_ERR_OR_NULL over manual NULL check
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Michael Turquette <mturquette@baylibre.com>, 
	Stephen Boyd <sboyd@kernel.org>, Daniel Lezcano <daniel.lezcano@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 505E040006
X-Rspamd-Server: rspam08
X-Stat-Signature: 4c7kso13yer541597x8epmwe1y4y7761
X-HE-Tag: 1773194854-759115
X-HE-Meta: U2FsdGVkX1/Gzip0My1pnSNrtGF52e0AKkOejUQlgfX4u4ZbjhyS7SNf/xsOzCWi7mNEXS/qqV9A3E5WIwGE4sfZyXld71iouh34E8SLcPF1mi+/XgfVxIhnrF9y4hoToU4Q25COD18oZse/IpAXZuGkbtVlOj2VYejSw4APjVi5ExsnwCAlJs41rSsAH3u327pCzuFgHZTXwb7fjcgeSyYbUroAHyNmVGyKoRY0V6gESEJ4bJ/MMXi7FofHMWYxC1DxBK07+n69rMhBPK589lydSL/sByLzaP6DqtOQnyVKxUNH3NhtvQalff3nfwFNIlG51VBH3mdcMfZTfgqBNz31Y3uSXgtp59hFqk0e+EtIyZzXa0tsIXvpz5bw2Avjiu48EkikYqd96IinWzHg54snjvAK5eHIUKhmo4EXbZ1EJXPlsRQ3m/FlGqr4Q2RpXbc4t/ugamP+MTl+5z6U7l9+/jk7o9bLd5CnGkquTepr/C2IE5K5jOJhsMfwdErpg/Ez0La8s6Yxv3kIrzF0ousfqh84mFB+BXYL3R7NfzC2AoDV1c9koOGU5wUwzXYvQDvVibZcbKD/MvbOky/XkjhWziOA7MNfp2GDlWoytvx+9fmEv8C6F/7g+StP+1J4ld8QfsCc0JVoCoWM24T43qDJ2D4VFsFtASCBaIjG2PTaSNekJ3wk13OkY/jQ950zxVyMwsaHQlrZf5LZBhmlIj2lh3ebp734QDz0gxHmlvDoF+d8lM+Bua1mzxDFSBLc12CzBU2d8ene6KYuB84nYeH1SgHsEUADYt3sBeIRPebLpv0lz+50ZY4FnxCeLzJaxwFfcoyzWXV3bPNlE97OesHM0tqYEELgfGAdQnIC7LIkChiOF7gL3e2S/ZVK0uZsvhTvQTBb33Xjs394zUZETDqKnyq/tzy73W1E1I5Y6hcBmFuvHnF8NRJELXX/gJo9ZEJJHxqSXPJ8UNO88Ug
 fCnzc15m
 u5lUssvr1j+p2ffQUjEuwaoep3fOV+wsnl1AH74DLVBGu8ML1ohsUtfEC5FXx9Ab+k0spGO6qAz2rHLguuaadmFl3svN3jjicWlQLMrhyYMKFBthIdKTMGhOqmk2E4X6zjUH0Z3t1JOKJB/aVT+215LU8zMuZ21W1ngHo4Oc7pEgRNkMjLmOcNVx6TZZzgyzIRDGriRymCc2nesjOUNyHa9gfAVsXvlhQsvCpdswA4TaeuV8AoLiy7UxZFXMQsxeMFoSd8tPag29hKxpPKw6Cq+ap+KRs3UvdCaDKPH9n/+LDlBHd7ucw7n/t/6l7t584YWOEYEBQdCzuL0KxI/POmBry+SO0N3Aqnw0SCk/e01uoo65DE5UPsdvccxZUI4QuB1n3GKLoHEg2tl7EI1eXZ5538g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 9:57=E2=80=AFPM Philipp Hahn <phahn-oss@avm.de> wro=
te:
>
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Semantich change: Previously the code only printed the warning on error,
> but not when the pointer was NULL. Now the warning is printed in both
> cases!
>
> Change found with coccinelle.
>
> To: Michael Turquette <mturquette@baylibre.com>
> To: Stephen Boyd <sboyd@kernel.org>
> To: Daniel Lezcano <daniel.lezcano@kernel.org>
> To: Thomas Gleixner <tglx@kernel.org>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  drivers/clk/clk.c               | 4 ++--
>  drivers/clocksource/timer-pxa.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 47093cda9df32223c1120c3710261296027c4cd3..35146e3869a7dd93741d10b72=
23d4488a9216ed1 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -4558,7 +4558,7 @@ void clk_unregister(struct clk *clk)
>         unsigned long flags;
>         const struct clk_ops *ops;
>
> -       if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
> +       if (WARN_ON_ONCE(IS_ERR_OR_NULL(clk)))
>                 return;
>
>         clk_debug_unregister(clk->core);
> @@ -4744,7 +4744,7 @@ void __clk_put(struct clk *clk)
>  {
>         struct module *owner;
>
> -       if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
> +       if (WARN_ON_ONCE(IS_ERR_OR_NULL(clk)))

clk_get_optional() returns NULL if the clk isn't present.

Drivers would just pass this to clk_put(). Your change here would cause
this pattern to emit a very big warning.

I don't think this change should be landed.


ChenYu

>                 return;
>
>         clk_prepare_lock();
> diff --git a/drivers/clocksource/timer-pxa.c b/drivers/clocksource/timer-=
pxa.c
> index 7ad0e5adb2ffac4125c34710fc67f4b45f30331d..f65fb0b7fc318b766227e5e7a=
4c0fb08ba11c8f9 100644
> --- a/drivers/clocksource/timer-pxa.c
> +++ b/drivers/clocksource/timer-pxa.c
> @@ -218,7 +218,7 @@ void __init pxa_timer_nodt_init(int irq, void __iomem=
 *base)
>
>         timer_base =3D base;
>         clk =3D clk_get(NULL, "OSTIMER0");
> -       if (clk && !IS_ERR(clk)) {
> +       if (!IS_ERR_OR_NULL(clk)) {
>                 clk_prepare_enable(clk);
>                 pxa_timer_common_init(irq, clk_get_rate(clk));
>         } else {
>
> --
> 2.43.0
>
>

