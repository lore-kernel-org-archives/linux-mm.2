Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27728C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A686B00CF; Tue,  4 Aug 2026 16:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A1A6B00D3; Tue,  4 Aug 2026 16:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45CE6B00D5; Tue,  4 Aug 2026 16:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A76216B00CF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:34:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45A8016027F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:34:20 +0000 (UTC)
X-FDA: 85064739480.30.A932F68
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5A683C0009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:34:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uCHa6FUw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785875658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2GdzhqENSucI1DjCkcPXwFLmRUs/MsFB0Hm6NilxhU=;
	b=ZrbYhxbFcXhInUi8ytL4G13raooW76WVS2UL6e6ogxVfZ2E5pImUOgF+/5JEflTGETw6zb
	RHzDwqoc7404DohcQambYCutQlXl5tZZt+S7GRC8bcGkowzdgDRsP8FzvikbDJNGSNrE8B
	qpfvatvtd6Pg+k15g1CWpHA2N3TjGrQ=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uCHa6FUw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785875658;
	b=lME4Ru1R50vsEqzPH8iKv5jgImSTciZI/x8K/1p03pudenJGzPeW3aHQ3GlEjD6bZilKHu
	h1slR2cUzfnkbcR3pGCTpS8n56H4VIeWLiyX46vt08M/FrA33Am80ufwAt4797XLCE1o7j
	bDhyY4q+GVSAOa0NkZFTWhRwDi1JeZE=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c15a5b265so76991cf.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 13:34:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785875657; cv=none;
        d=google.com; s=arc-20260327;
        b=Xt8/ovT/nO5tC8Pd/o60YxI3lx76HKUu20y3U2/fs89Sxisdd922iO89EHaOE1JOYP
         iLYJV/Ua00BdtmYfLbZtY3NuNaBhEGbLz5N0Y/nSNwcRjeOrplppIshLeaMpZnVmfXs7
         3IUjY40fplVhQZ9Z7A9NMx2cKtcofcWQrkizW4FDDPdSv9gbqXPmvyHfPhEzNxKI94E3
         J3GqJcM+Zq1BHa1YHd6QX5LPgcSjL0qeRZUGmbHsboXf8iZglsdxBBTtaOvgZZ3sCXin
         V8ds64XOD1sVZm68rgt5QEOlxxFQvG3WNKRbZdX+32ElneZtfla4em02V9bYIdS5EEeW
         WI1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u2GdzhqENSucI1DjCkcPXwFLmRUs/MsFB0Hm6NilxhU=;
        fh=Qc1Wm8EtDv2K5L+KpHv8rfdUzOYvDS9yIwqNdQiJ3NE=;
        b=ckVUujthdTUPZ5wisWxwQmp9sWk4mJlTgY8R94kvkHZwndTb655NPODGlih9i9qa9Y
         h2G6tKddbZWPf05Unk0PGoq46T4t3jtpfQYNRHgL4Qkrd96evqeuw8SiIIPFjG/Q5vNF
         cJ5jZCWhnddzs139WVPf+g193ffhC+yosWb62gyY9ttLcWLCEkUyhYLfcfgzFxZrTcVk
         qng11vYNCPK7Hos8Z3x6RsugS6ERevWoxCzav8ndPCJ+RHo1MExZqixmN9liPu93UNjf
         D3H4LPvjTxZ7IJzJ/hIwNFZZ9p0DlIhQKjT210GcIwqF12iTtwYyZULPk67aJXicth6l
         HGVQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785875657; x=1786480457; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u2GdzhqENSucI1DjCkcPXwFLmRUs/MsFB0Hm6NilxhU=;
        b=uCHa6FUwFQytJ61cl4sx9xNPle504XV4PhgRKA2yV+NJVA1MzBovhDRO3YIVfnfe/c
         af00iC5vbFGeJTHN7FK4t8Ws0N6mbAYORH1XvJsq/3/F3lXsbwB+Ppnb1C2NP6l7J4QR
         L8Vs9/1QenrmvBgh7beYv6UURDVVteA1/GTxZikpJipnYIO1/EQ7glXJ/P1SyhOtM/XM
         tXspIyIIvupjoPtB+P8OdgpNAI/pa6UodAfAC+ZcrJkWdq0YLcAxH6ezPCHpV/3JSav4
         9tlcfVJSkk0xjFYdsREz/rzRZAeMLY++Qd1R1nmwzMiUtmGQg+6tZkf3dHU0OWSOGfCz
         SKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785875657; x=1786480457;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u2GdzhqENSucI1DjCkcPXwFLmRUs/MsFB0Hm6NilxhU=;
        b=dVSY4hTjCupxnUhBFX14u50U8xZQ/0x/pCF/43JvWtpuLJkeOIACBssq2Q+XMyJ/9X
         EtnTg5vFlYbe7RpUpE6elYpE8mXbIm1OdjrHc9nr2QSqfcNkp7MvN94BZ9DV7j+CZn2J
         3ljqgHR8dqdCYM/yoHsqmL04momoYJTHrpQDD5MmVY/obXKiC3LmfrkJWUqsY8E3XjjC
         sxzgDvR1LC15v+XYsMk0gVeexpHDOD+iVh4/XXXSBtUUzuPtBWYis5hUfhupIR+bIAgz
         2hbAv3CxlmhfgOBzg2XLEa1PIusTHpTH0+NOXzr84FdEbyavrKxRwgtrvxxkkmUGBGtx
         uY0w==
X-Forwarded-Encrypted: i=1; AHgh+RpqKKLqnESfSSXxWvEEJD/4wrlCwIxxwkkXgW3rM/shx1eHjJb4GY62ZfCyHkv2O94fmG7cGZ6y4A==@kvack.org
X-Gm-Message-State: AOJu0YwUAB9LycWlFrIGmg0wxRLoWOFGFR73BjmeCwIyfaFZjza98KO1
	o/xh1UMt15g0jMke29tzg3pkaIbFsgErbQM6jmryhFsX7deutA+jm8shCiv1sHmlABGhTrP9t2q
	j/U4FM+G9kbBjXcI9UhCisnoMSPNTeMrX8nRXOeGU
X-Gm-Gg: AR+sD10zD8axj7nCUzgGUx78cwF9oY0b3ZfZ3zQVcKsyTpLJ58NBncrbd3+9ZdR5utg
	FbTnCO9nGpVAYGuA3jvJbtNAOUCN1h7K2cWhSU+FiRfNpTLLkhlg70eM1dEn/E7WTWfkAn73VHz
	plsVKAm5X28zm99704V6pfAYkwE+Z89ILswYzM2tcr66Z+2wfLojXUQQYrVLrYeiiiTw3avsT+p
	jXYr94gCkszB9h4EkEckPRTd/xJpxKy0UTFSLJcR/LVGG1H/XzSaBwigG2fqr3PoMHYeEG6aYi8
	q4c33wi7/zMkb2ApwR1OZvgeYapS2L9zlIY2+ZPKsj408XM9Fg9SccQhu4Cr+C1zW7mmfBWaYPr
	912AYYKmxzA==
X-Received: by 2002:a05:622a:6d13:20b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-52ce66f2b98mr3989971cf.0.1785875656796; Tue, 04 Aug 2026
 13:34:16 -0700 (PDT)
MIME-Version: 1.0
References: <d779f2cf4105448e0fb04eeab82acb20dd05d6ed.1785873902.git.abhishekbapat@google.com>
In-Reply-To: <d779f2cf4105448e0fb04eeab82acb20dd05d6ed.1785873902.git.abhishekbapat@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 4 Aug 2026 13:34:04 -0700
X-Gm-Features: AUfX_mzmafCd6VIc_CPe4Aw_YNNNBxWfwo6zWJHpDBEeFz7tKno1HX-jRBLIzXs
Message-ID: <CAJuCfpGCHFhAwCkd8JX7fd1fee0JkJbS_SO8Q00ZM9dgi2TDjA@mail.gmail.com>
Subject: Re: [PATCH v4] alloc_tag: expose boot-time compression configuration
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Ge <hao.ge@linux.dev>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5A683C0009
X-Stat-Signature: 6wees1umjpha8j9ne9nh3owe8ps9uxpm
X-Rspam-User: 
X-HE-Tag: 1785875658-73686
X-HE-Meta: U2FsdGVkX1+b+zW3G+p3iznY2n0Hls2yDyJlnAiY7Ig6LeXLcpfIUlHgWq3pZexOZ1aib5HawZJnnM/958hIstlndo8mmniWc3i8x7Khu9Yt1I/ZxECmnaNa3CYZwOsdiI8O6I0VItU7+9iXNZyc9W/btsOe8qlAYBH/lheMux2h6cdZPc6Cp6QMAqW3yFapZ3+UrvTQqUrvCM+8Y1CSBzI3vM37w52j8sH94BJEMXkFJ56gszRmIXKOODGRIouM0TctE0KIbYfogvPZGfk4afDPaK5qsRw4iS0DhsBwXSCauReVoQiB8qr7TCwjY28KMjfXe+ET/lrUOn6+scEtt6sEzq7ttlo/9o9ql/FMe68pkkhCvj/Q8ePJP706PsfXqBB/c+Ro0j3fiNBvGALiqI1tpV0EAdZisHfRWazAOXiYJ06CYrrvcia3g7d09PDRdLiajGw3VX4ILWdePeVNE6MXx9zwwouoEFFzwhYRTNg1pF+3BvL/1zf8gvbA3pVnswHMcNIroclRGjqpqpCHW7BcU4i/2Y0KDKgyB9h5/myjFfyNc8A4SSRr5+7nvK/Hs1HNBcPuy5O2VBJVuU5Z1N1kAfu+VeLxfmyi4T2SZ/SYECnicZGq/co/mmzprWRyuXPjNTxF9w41lfGJ9/dPoIoNIbzpPIX4NnAJBbDDB6WReXkLsOoSW2oBzhXRrPuHQcDrIZa3C0crKWihP/n2WGda0igUK1RZifjXsYRsJbitaAg+XeXTC+xUc2VPM0r9kARnh6B8bh//D8C7m1SUIJlnAbcnFdFzXxrL+QvYJLIaGsuiwZ5U+zuQKgNVsrcroxikf6mYa5GpiZdJmn97DJyfdfWCerQdRzjUxfDiaHYA4yb5pRnYrxbM5Qko3/69hgyFoEMWvUTIzDtksT2B6WYVae9g80JC/1liKxRcPiqmg4dGXgPV2895+z7ZSFEr3wJ9AAU+fRUJDz/EKbf
 tZVze4Pi
 tQmEX6eukZP+sI414V2ezEKxqlIwCIaYe3yrF4lTHvwwzDfrg6/QAsHgWoYlwbxz0rhLJf0qloJWFsBuXPp8xB2ys/o+m3qyzNLduXD3iiIC38XA/3OLUJJgXGbEPWIT56SSZ7w3CPImbGTUpb2kz7SXvfh5dFhBhg9DURii/EHDbeuSknCgRBh2IgagVDz9ajdHoBOQkRGxtNpFxQSAJ23WVlDRZOZRJWaObnPvA/9+7vAzF3T9fowMIP7x0b21y903mjgn5ATVSXDnFKOuCyzq6hwrRkOu103lb8nUeFI/csHoI3hIuFMzo+fxjv94lC3nmo2Tm1Updv6n9c20OmHZNDFVEIZ37Nva2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 1:06=E2=80=AFPM Abhishek Bapat <abhishekbapat@google=
.com> wrote:
>
> Currently, userspace has limited visibility into the exact active
> runtime state of memory allocation profiling and its page extension
> compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]').
>
> While reading the sysctl provides basic on/off status, it is currently
> impossible for userspace to natively determine whether page-tag
> compression was successfully enabled without scraping dmesg boot logs.
>
> Resolve this ambiguity by exposing the active compression state by
> adding a new read-only sysctl `vm.mem_profiling_compressed` to output the
> state.

I guess you missed my first comment at
https://lore.kernel.org/all/CAJuCfpGA7F80yW1=3DbSXsZre4=3DTx=3DpeqNbkWvKF0u=
p8xJdSvrgA@mail.gmail.com/.
Anyway, that's not super critical but would be nice to fix.

>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
> v4 change:
> - Documentation and commit message refactor.
>
> v3 change:
> - Added documentation about the behaviour details of the new sysctl.
>
> v2 change:
> - Moved from displaying the state in /proc/allocinfo to a new read-only
> sysctl.
>
>  Documentation/mm/allocation-profiling.rst | 11 +++++++++++
>  mm/alloc_tag.c                            |  6 ++++++
>  2 files changed, 17 insertions(+)
>
> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm=
/allocation-profiling.rst
> index c3a28467955f..f28358af927a 100644
> --- a/Documentation/mm/allocation-profiling.rst
> +++ b/Documentation/mm/allocation-profiling.rst
> @@ -43,6 +43,17 @@ sysctl:
>    warnings produced by allocations made while profiling is disabled and =
freed
>    when it's enabled.
>
> +  /proc/sys/vm/mem_profiling_compressed
> +
> +  1: Page alloc tag compression is enabled.
> +
> +  0: Page alloc tag compression is disabled.
> +
> +  This reflects a static boot-time configuration of how page allocation =
tags are
> +  stored (in page flags when compression is enabled and in page_ext when=
 disabled).
> +  Toggling `mem_profiling` at runtime does not change the state of
> +  `mem_profiling_compressed`.

I'm not a documentation expert but Google tells me: single backticks
(`) act as interpreted text for semantic cross-references or links,
while double backticks (``) act as inline literals for raw code
formatting. I think double backticks would be more appropriate here.
You should also CC linux-doc@vger.kernel.org to get their input.

> +
>  Runtime info:
>    /proc/allocinfo
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 52aece27b00e..877068241f06 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -1303,6 +1303,12 @@ static const struct ctl_table memory_allocation_pr=
ofiling_sysctls[] =3D {
>                 .mode           =3D 0644,
>                 .proc_handler   =3D proc_mem_profiling_handler,
>         },
> +       {
> +               .procname       =3D "mem_profiling_compressed",
> +               .data           =3D &mem_profiling_compressed,
> +               .mode           =3D 0444,
> +               .proc_handler   =3D proc_do_static_key,
> +       },
>  };
>
>  static void __init sysctl_init(void)
>
> base-commit: 486855239e38a91d3eae26618ccb7845c1764625
> --
> 2.55.0.508.g3f0d502094-goog
>

