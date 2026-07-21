Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED80C4452D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 10:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7792C6B00A0; Tue, 21 Jul 2026 06:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751446B00A3; Tue, 21 Jul 2026 06:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4756B00A4; Tue, 21 Jul 2026 06:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 250006B00A0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:20:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99D3B120435
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:20:12 +0000 (UTC)
X-FDA: 85012388664.15.3458B8F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3D2D0100002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:20:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BX/CmwCw";
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784629210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQFogWxs5hhydWW2qUcXDwN4yoIad3ADeAAxVDd9Mvg=;
	b=obnzUPHLKRQ4w7Oygmvw+ABI7TrkyXM01l+TehvCLI4tFgf4Ya5dG4geSlLurGVESpUoCV
	ZU5qXYLpxZXioyDPiT3E2DlK7CNECLYDdUZH8cetdj0vsdXMc0nPhgBDOaiOQTbSjq228H
	OREiZeoz4rFYmU7CQABM/7y1Dry72lg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784629210;
	b=D80vuX6h2HKIESjx2vm1rSmR1ztfcb5g/b86zbjsjwjZ8F7VVOcv/dEm7vjpCc8Qo1dw33
	vQ4pTAmOoO6NdE8vndxobpqrx4M4xn1camMsHGPP2XMQxnp2shqveNV0ufbM3JwtQHazbf
	k24puMXERcQl5GTS/os3XlLZGs1EHns=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BX/CmwCw";
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784629209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YQFogWxs5hhydWW2qUcXDwN4yoIad3ADeAAxVDd9Mvg=;
	b=BX/CmwCwvWHktj6H/3PqslTtmIAXKrCDxnHhWy9MpNd1281j+00Wa2FTJNcKDEM2XiX/w9
	TvLcTP+KhKPG9e7e/AODlHrkn+TYVsOlZUJol2y1uK92+iM8RWDc8BzxLeK9gAHy5MFWo8
	7RH0gFDymbspStEZ06wF4Z0Pz5p2uIY=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-Sqwh4utvMUq7e93k9v33ig-1; Tue, 21 Jul 2026 06:20:08 -0400
X-MC-Unique: Sqwh4utvMUq7e93k9v33ig-1
X-Mimecast-MFC-AGG-ID: Sqwh4utvMUq7e93k9v33ig_1784629207
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-39ada0874c0so45357231fa.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784629207; x=1785234007;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YQFogWxs5hhydWW2qUcXDwN4yoIad3ADeAAxVDd9Mvg=;
        b=ORqMj4qcUR5YI0/DfnWCYxk1ILzvWWZ/U/KEzJMaOiM1dY+Pyl7zUMnul+0hTw1MDN
         TtaonuvHHHZD0yMIGBn0215kngm9H8AMrJzVIiKYQevtG+yZzWFxBOwWnhB3FvdD7gFu
         03zk+QMuYdfmL86pGLFPx8DFVw8LiGvFz0j/+R3K5k2Tx2GXJAXAy4U6JPLQtVpwM/hH
         yFvVAzeT2y+MjcUyGNL3qNkIE17CxLhfu1/a0h8mrjDaASU8Crdp1YN7RANXCQYNM5y6
         ZMgvVE09zbEksBw5ZsYehQhHi6a0MsFIZe60almU6bTWTrhyD7gNRz1Fd08KnLma9Gwn
         OWCg==
X-Gm-Message-State: AOJu0YzqcLzEQBA6aE7zAD9j0Z52vdkshBe5WiRk+XvXE7retiN9sAYP
	iUUnJcW/OlpsTrXJtSRmMD/OYZtQJEemXrM9z/R86rtPnFvxJVJV3sJDInWhhgjAxUmq2aOH0lH
	AEDYjbqE0XwZh02doSPl7kq0/PnhKlQm8KH6YrSXUI5T5ddYjmtcDVamwSyqAky5DRwWMP8bw3l
	RqIGUMUmJnB09YiTpW/CosumYoUWg=
X-Gm-Gg: AR+sD13IB5wFHTMM8P6usRirHe53kQgovdV2wIJyELKX39A2tSVlcoRnWEoz4Hyssmb
	mX2jOxXQUbOPM07Jqa0ThYdVpGx4IR0klM5vj6fHaLF1Q/NwUd+3ti+gdROg9cjc6fC4R2yiAxv
	w42s2yaCQ1CDO6xw9YTSsVw7NqN4REKNypJdZFjG4vvCPqUifbWRB9lA==
X-Received: by 2002:a05:6512:3baa:b0:5b0:12cf:ae27 with SMTP id 2adb3069b0e04-5b28f9b7c2fmr3951285e87.34.1784629206790;
        Tue, 21 Jul 2026 03:20:06 -0700 (PDT)
X-Received: by 2002:a05:6512:3baa:b0:5b0:12cf:ae27 with SMTP id
 2adb3069b0e04-5b28f9b7c2fmr3951276e87.34.1784629206353; Tue, 21 Jul 2026
 03:20:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260721101811.115954-1-nico.pache@linux.dev>
In-Reply-To: <20260721101811.115954-1-nico.pache@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Tue, 21 Jul 2026 04:21:31 -0600
X-Gm-Features: AUfX_mxSafXk43IafvtsLcsil_jwbEbCXr5XiO-OAGeEF2dfI1qg6TKUlB3T5Ww
Message-ID: <CAA1CXcBDNk7nFP8nRxea0D9rmYdmuiZuWW9zvPQPoWkxzOb_Nw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update Nico Pache's email address
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _BHaGsGuUq_vPHM1vkMIZMwvNazGLn3yaV2xj_iGauc_1784629207
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3D2D0100002
X-Stat-Signature: s7f4tpmzxyobybd9eeytqrus7pngdmdo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784629210-293731
X-HE-Meta: U2FsdGVkX19bKhiLBsAliAzY6usBg/BWFopnioWOgLL69pYQcTnP15rjYX8T3CnDt3SES3/rEGWLYM9D7QvwimeKl60tsJf6R5TkYZccG03gDbi8GOfT/NQlD3mt5FIlURxd6Qu2aYsrJOaNuuqwJaUJPuNKj7zeDIyvbkRZdws5bLK2nqplulQREfv6iA/D7Ks/SEgD8PRvmZjqYtwkAZe6twzuWl4i064YNB8xclqdLj9pyf1wGp3GPn8HkvoOz/HV7/1OcvuFu7W1sYZTLKg4hT4/Xu/woeph/Q0nSo5ECEdEgbke5wXoVspffTBISvPukx9kHtifunmRVvfjU+oUoaHvlUju9ZFRoV8jE2iITVadEi5ii7k+ZHoVjlxQDQbsxSdIGnM9Zx+N00FhD4mp4/E7D+1YL03pMuV17dc/50sJe47N1333P66xam4ILU7spijoJbtJX1uEtW1Cd9G7oIq5p+rv2lWOvUlftlmT78EkT8oQY/16meLykKQusoludExk6mIAgqyD/P/ES3Diul1Eoam7YNh8aSaciqRhpC9/TX0rNYGc86WWdbU3o+ipjdL3AaOxN3lV3TLNHekynuVuGiF9W56s4WIAH+6yyGV5BJ/5bj1Oe4mm32o/DoAoR+/3rdAcaeJ5f6entjqTKEkv8uUICdDFyOU0vbm9hmX+x8rofx6TbxVkIQk5Svr9LK+Ctq6uGkVqES9bZ4DIYxRLJG7Va/Q19O8AgctYaEBjFBn4lAmtXTbb65BsLCyTJnoncvpJMt1f47GGU4VsgkmZKfdq2fyJKFxX1B4gneijTnUSxpDl3MU3XgJq+p6jD6BIaWlYNPoKO5b9USxhVBXYQ2SjrKokfaClq7g+rwm5KyopSj75tpyDvQVynBs73I9kr8ElhkdE9Y00AoNzxc+smxlicAKMHnCP+30h6rUgk5HVHffVejUwqrM2kBMbyd3SDL401tCWsau
 JPgJo5u5
 oIIuRZv46CrP/oDM7/jl16ncU/Hq6lzcEb1HVKttSvKo2ntz71PvqmTbFwaTh0iYg/NqOjo5hHueewybXHgXKFFPFZ1bhFLpBSBbQyYPZh9u1VtyH2wuNf16T5YIotNAJsRgqQLEUSr01oBGgkkEaHoXcYSFt+mToah7WMzOn3uDUwou4SSJR/NdaOy9Cn55rs8icP6ED/CEtC7ylDSW+igu4M0lPXHskm/hSQsX4z/VomqVJSRWr8DOesXT/ZGSH9D5EUCoH0nOUGV0pjQEqeFZwwwq8Lgz3HwV00FGHTp/14uauoDJYz643yO5tibiFr+TL5gYqW32bJ6WqzDOR5jXhaqERbZNWZo52py/vDdeXZ2KjNgnbDqoGLh/S5jLDF8pzshY0YLCUyPOxFjp+s4B1e0YDOe0bIHATcyr/W7Ni9oqmcCMkmyTFDNpWo91HKvTErcS3NQ9XS77FimDqcFumRVb6tJJw2oujWoZObhq5dOX6xiRE38synDAxvbpSBDIhD3N1/WYWjf3oXRI8l8sDeoSLiHl0+l4VVv7yj9cU66GXer+zoOrJUnMqNo+GdxBhuUMBSx8UR/uYKNR6vAjOCHv0VthirLkzZbMk1SBkiq4rexmI5u5fFcAP8mUNZVPlGPWl+hNtU3Q3jOYRAmsJki9lrE4s2dR41aUESJwVGLtApr7eHl88RLkJs5PrM8C5/KphcVTvAZ+UZ3l+Et2kJpDIHUboM+/rc2a4bMKpIhHcZWG66hEA0eTifBVdAiQE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 4:17=E2=80=AFAM Nico Pache (Red Hat)
<nico.pache@linux.dev> wrote:
>
> Switch my entry in MAINTAINERS and .mailmap to my @linux.dev email addres=
s
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

Not sure it's required, but just for the record I did initiate this
change. I'm transitioning over to linux.dev for my upstream work.

Cheers,
-- Nico

> ---
>  .mailmap    | 1 +
>  MAINTAINERS | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/.mailmap b/.mailmap
> index 501d858cb432..e36a76e2800a 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -644,6 +644,7 @@ Nicholas Piggin <npiggin@gmail.com> <npiggin@suse.de>
>  Nicholas Piggin <npiggin@gmail.com> <nickpiggin@yahoo.com.au>
>  Nicholas Piggin <npiggin@gmail.com> <piggin@cyberone.com.au>
>  Nicolas Ferre <nicolas.ferre@microchip.com> <nicolas.ferre@atmel.com>
> +Nico Pache <nico.pache@linux.dev> <npache@redhat.com>
>  Nicolas Pitre <nico@fluxnic.net> <nicolas.pitre@linaro.org>
>  Nicolas Pitre <nico@fluxnic.net> <nico@linaro.org>
>  Nicolas Saenz Julienne <nsaenz@kernel.org> <nsaenzjulienne@suse.de>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1ab8736850ea..22d38e288227 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17252,7 +17252,7 @@ M:      Lorenzo Stoakes <ljs@kernel.org>
>  R:     Zi Yan <ziy@nvidia.com>
>  R:     Baolin Wang <baolin.wang@linux.alibaba.com>
>  R:     Liam R. Howlett <liam@infradead.org>
> -R:     Nico Pache <npache@redhat.com>
> +R:     Nico Pache <nico.pache@linux.dev>
>  R:     Ryan Roberts <ryan.roberts@arm.com>
>  R:     Dev Jain <dev.jain@arm.com>
>  R:     Barry Song <baohua@kernel.org>
> --
> 2.55.0
>


