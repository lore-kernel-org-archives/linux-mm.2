Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2370FCE7B12
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 14:13:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CFBF8E000D; Fri, 14 Nov 2025 09:13:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7809C8E0002; Fri, 14 Nov 2025 09:13:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66FAF8E000D; Fri, 14 Nov 2025 09:13:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 524DD8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:13:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA99B13AC04
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:13:41 +0000 (UTC)
X-FDA: 84109405842.24.69F8D0F
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 021FC1C0013
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:13:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="DD9KX/wL";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763129620; a=rsa-sha256;
	cv=none;
	b=4ozkIPT8StkSmXzjVN8R41XVo80LHYfY+dRuGxkfvBazEbLoc5HhG+ODzS9iO4csZUfxDf
	AUdhHjkR5k2ArUb6te04st9KAo7Y+YspbYpe6xcHxXTGpN6UjikyMqTOgzGZVCV6/z00K5
	TVgU0ZAVP9CiZH/yKuArD5p7TCDXSCs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="DD9KX/wL";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763129620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1GWVk4qjCFFs45/WyYJujSVk3cU8UHP9J9lavaWKGo=;
	b=brRkfWRYZgpZQ94ES7QW34opn5LQ0FnZOAXmufTpq2FWVGf1yq50/V9uMO8mKv48pfV939
	0z65neLWMM4N08hFltX0L7/tx2zEjdfeLvB//m1zy3rYhDhcRpQ7AfbwU/6LcU6Ij05zTP
	lXyYbMY5yPgr4YrA9eBBfex6fZmYDJc=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6419b7b4b80so2946483a12.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763129618; x=1763734418; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1GWVk4qjCFFs45/WyYJujSVk3cU8UHP9J9lavaWKGo=;
        b=DD9KX/wLt1UOYHozHxRJL4fvUs1AEICwSpaEbisAkapqp5aN7QxIyb1YmERVLui7Qz
         lrvbmTc9wluM/3LT52Hj5OyNiZ1ZOzMXlGmWWY/BJJpTF+PePcuEitYtptWh88ftQeDj
         mq895KmdU13McSije1zpdnhGXfWVJoSOdngcF6Su6BmBAFf7r5H5fzqlazcbn6Ms/ULV
         qrXzNWGJTmlqWcPVdzHSJ6e22hM+AnNT6rH9btqqvZiF+IZW5Mzn4anI/WJOx/gbGD/U
         6bP715y/Jk7iDYRKh/qrPJzV3oq9KHNNsdOkZghuZLLS3WuR18+MrunP96hws6KRtUz2
         NdrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763129618; x=1763734418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V1GWVk4qjCFFs45/WyYJujSVk3cU8UHP9J9lavaWKGo=;
        b=CWbfJIzApN4odi8ymBmy+Ja/gI2II+g5Vie3r+WRr+G+msp81P2uBaRJ4dSMt+XNnu
         kbc10PSeZOn0gZi+vTJUwI5/coIKKu7G7vAWUPfUps/zmL3ZSPbpYJlKHIX3HFXwWsEX
         coif0UJINLudEOTnvmg62z0csZPf/h7w4QxTurBEp3PIlDSHFMQvrtuc5i5dLt4vvLOF
         qdgIb9RkE0xvCSSGcl/IHsGwdhe0AGqqekALLJmCbGf72Dg1Ag3LL42Ij77mobqa0QPw
         aPcXYJTdTyzL5JIGIX9wbiwmOZxfFCuUgq3pfOA6LCZhU5EemBkX8N6AL3YgSx08Q8KN
         rduQ==
X-Forwarded-Encrypted: i=1; AJvYcCUI72xEdoQMTljhZJWSAYDP59XNS0VUdObB9NYj/4WPNztaUJayt/uODLSzuisaRq3LpDnn6Zk9wQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3xvytYjnHu+eW6fnLCHVkqPIvDER6ElRscmTnUrR1ZJXBxjza
	B9H7NLIMxcR0NZF1kr1R16Ce2EkVi25wsERv585/nKqrpCwsZ+Eu6CLQM0/cVtWVGTVSOwwLx0f
	A3njLMw0kfLu7N4vMzfO2Fbi37N5bSDL10Dmc6/xc1A==
X-Gm-Gg: ASbGncs4ypA9U4beq1cwUHG2HR77dkq1RGjaXCseHD8v4uo7t4yZV9LmO3GjseUWVSw
	t0XA72H1Rbz7umCxuzA+RI4owgS2Ft3vPXfLe03GjCLYOZea6iwKQ/qZo5r4Tjldt8r7ROvzGdi
	ZRlWAJqrZRs+0cXlJvKtKrymAmP33Wi9NGDtBKM7IWF+HiiDGk7lY/xtMSnRcVaLnJ+m39zOhOX
	00SZYLgTVzBGg5QW/ZsCB7Azl0SuEwVOH2NZn6v+xRym44HwvEBU+hFKg==
X-Google-Smtp-Source: AGHT+IE6NyLe9C9FZki5iqhbn7SPAhloGhmZAVL7TcGQzvAGxu+qhhe6/PYG3PIh8YJQedsoxrgsfW8jKdq98CqxiHg=
X-Received: by 2002:a05:6402:21d2:b0:641:7a6b:c84b with SMTP id
 4fb4d7f45d1cf-64350eaa120mr2487306a12.27.1763129617993; Fri, 14 Nov 2025
 06:13:37 -0800 (PST)
MIME-Version: 1.0
References: <20251110180715.602807-1-pasha.tatashin@soleen.com> <aRbag7qR9OVNAQXN@kernel.org>
In-Reply-To: <aRbag7qR9OVNAQXN@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 09:13:01 -0500
X-Gm-Features: AWmQ_bn2JTVcrMalLvDrtUy-789mrdL8UQfu0H53fSt1tKQevbBhJ-8H6gadkbQ
Message-ID: <CA+CK2bD+ZseJ_6GUMV7d=8xpUcWW6jzJBdJRy7kQmez_2sMYUQ@mail.gmail.com>
Subject: Re: [PATCH] liveupdate: kho: Enable KHO by default
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, graf@amazon.com, pratyush@kernel.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 021FC1C0013
X-Stat-Signature: 1mpgctt6ks1ujxdzdr6y77yqbafqq7rk
X-HE-Tag: 1763129619-795712
X-HE-Meta: U2FsdGVkX1/dgTiap4460sC0MOhnmMiPK8V4zhFrP/W98G4tWObR10tSbMNUqaOc2r6jBik6yhzNxwoU1MhD+C8vSEqzpUX51Q2FZs0aLvDn9bKLj81g0Ez6XYJ2BbJjCFyKff8bLr5XQFt6353dF3U9UBcZganB28WaPzrWzW71xEE9LlIfk8Bzysp7MizqsgSSOLCb8KzyXUfZ2qVF0VAsUMXUBNJ/yzMGD1SGB4ctleV+8GlfegMHecTn+G9gcBgmpBsqLV2uf6HCOoTYOTpEvjYXU/zvT5TKDwN/W9CHL6Ra6ke4YTkCKQFtQHD7dbI7tK6c19XMixsIrUK38SIxJZUbpQbuQiWa67acL1ERWFp76yeLXQ+DXcxNnmi34sVkqgguaFp68++KPTWqWu7ktxK3x7Esofq6V2nnk8Qsc3Fuo6agjwY1qT33JeNpoh5P3pYKcPc8i6on1d84vkyHjaXhv52XqT2EbwSKl/KaXvo41QEQwWVUO4TsyKPUBy/PqbpJPKYLWY42dDs/IkeeTvT8aUuKAqW4xu809vxgI6jTlwvgvNuJca3YD1ddtlL7t6liQvTmWgNwz3JhqqoIhW4vDpiIWKwIc15Ii+lI8Hu0+jbpmMt2YPQzwI4R6TaQQzu2aMgLxNinsIi+zTItURN9fm7onbHl2QwqgY0QfooK8b1RM6fJVuDOlEWbFZQUr/Tqznz5tL587K6LMVkJ0iTKF0s1j6khfi+8lihorNnWzDPWTlJXfxi71cAd/sg7luPA7In+Y6AmUqCkGXHHMMwDH8gQYDPw4kl+G+eVqEUdhbYELlvB2+lJ4Fa226tI9GFKViGGhsOOoKcGxrkhgctTyceAEyszv5RF47E/J2hPi7cHURcPjxTXTbT26oLkTWlNcQo/Ny5dzhbeop7KDEoKIbLMkRlIUbBIWaZZ9Ofs9PpfAvdNGWSjRJCeYTho6cXmMA8XYPMPUqw
 CVmlZa4t
 zumLNdjYeCCu/ds1we0Cq5Xm47sq7alyd993suo5uqrPw8XFcLoyosAP9T0mGl1xg6eGE4PyCGDXxmVjBnbzDuRLmyXIqKNUhYhugHsGUs+KkxAE6P+QI7fxPFWc58Juj44MgZ5FCWtegI/wLUX9U/Ah6Vvkgf/Bze/iwncR9oyWxXXHYgAe4w6KEEjMJBtUEL78dNG3iYbC6lUpa3BnbmAL8/sbjYytdJ6S2v73wXOA00lCu5H1ZnOt1Vb+/WmZy/EIQKXo9tAnnOLQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 2:30=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Mon, Nov 10, 2025 at 01:07:15PM -0500, Pasha Tatashin wrote:
> > Upcoming LUO requires KHO for its operations, the requirement to place
> > both KHO=3Don and liveupdate=3Don becomes redundant. Set KHO to be enab=
led
> > by default.
>
> I though more about this and it seems too much of a change. kho=3D1 enabl=
es
> scratch areas and that significantly changes how free pages are distribut=
ed
> in the free lists.
>
> Let's go with a Kconfig option we discussed of-list:
> (this is on top of the current mmotm/mm-nonmm-unstable)

I will include this into the KHO simplification series

>
> From 823299d80aa4f7c16ef6cfd798a19e1dfe1a91ab Mon Sep 17 00:00:00 2001
> From: Pasha Tatashin <pasha.tatashin@soleen.com>
> Date: Fri, 14 Nov 2025 09:27:47 +0200
> Subject: [PATCH] kho: Allow KHO to be enabled by default
>
> Upcoming LUO requires KHO for its operations, the requirement to place
> both KHO=3Don and liveupdate=3Don becomes reduntant. Let's allow KHO to b=
e
> enabled by default, and CONFIG_LIVEUPDATE can select this CONFIG.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/Kconfig          | 8 ++++++++
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> index d7344d347f69..25c9a4d7781f 100644
> --- a/kernel/liveupdate/Kconfig
> +++ b/kernel/liveupdate/Kconfig
> @@ -63,4 +63,12 @@ config KEXEC_HANDOVER_DEBUGFS
>           Also, enables inspecting the KHO fdt trees with the debugfs bin=
ary
>           blobs.
>
> +config KEXEC_HANDOVER_ENABLE_DEFAULT
> +       bool "Enable kexec handover by default"
> +       depends on KEXEC_HANDOVER
> +       help
> +         Enable the kexec handover by default. It is equivalent of passi=
ng
> +         kho=3Don via kernel parameter, and can be overwritten to off vi=
a
> +         kho=3Doff.
> +
>  endmenu
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 568cd9fe9aca..23a3df297bb3 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -51,7 +51,7 @@ union kho_page_info {
>
>  static_assert(sizeof(union kho_page_info) =3D=3D sizeof(((struct page *)=
0)->private));
>
> -static bool kho_enable __ro_after_init =3D true;
> +static bool kho_enable __ro_after_init =3D IS_ENABLED(CONFIG_KEXEC_HANDO=
VER_ENABLE_DEFAULT);
>
>  bool kho_is_enabled(void)
>  {
> --
> 2.50.1
>
>
>
> --
> Sincerely yours,
> Mike.

