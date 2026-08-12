Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A26C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 23:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723D56B0183; Wed, 12 Aug 2026 19:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB976B0184; Wed, 12 Aug 2026 19:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6150A6B0185; Wed, 12 Aug 2026 19:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 191C86B0183
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:34:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECC521A04D9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:34:10 +0000 (UTC)
X-FDA: 85094223060.27.7E11B3A
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 164A280002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:34:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iyFopiBB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786577649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thS6W+fao1nFVWmRcc04F9UA6vYDU4/A39G2jwslH5c=;
	b=jkV7xayXQU5gc32txDaovsSzzsJGJSjsC6QQ/ROLFm0uJFGZcI1wx+Ff19OQeZOBzshsqK
	CiINRi1ycbasqRd6xaZ/q2Wq8cw78VBHkElgiKqKls25fUNhy7hj4bBFkf9lOE7157wkqP
	i8J9nWPC4LwGz9SbQceNp2F+ssgGRWE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iyFopiBB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786577649;
	b=h27sqZ5EB+dwaR5h+fyoCC267ff0cUDEDSh76Zu4EaYszDhEYxLMJxh45SjNNNrMHJ9IpR
	IUT3cqwVYt12VCStQkjpmmZrMVObuaXhmuoPRWnveQhpG/ghDZwPhe0OXFBP2m1GiGFb8n
	3j6NEqJwrHdWX7YqViQP0GP2JXoubwY=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c10ed63c0so48151cf.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:34:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786577648; cv=none;
        d=google.com; s=arc-20260327;
        b=XZKOLdON5EwdzE7iT0LQQv5oZtI22ggbZhp52KpreMTr9ea67XhZyDiFiJboL2dKgi
         M2cf75BdSJNAUTMz3Ymp+NfWnbGHSa0bdF/pQU8cqgXmMiWkDuQhTYzf3pBuWU6FSYxE
         jcvXg4EDH1gR/LfwJ4T2aiQFd3bFIvi3v1QJI4I9rpjjaH2CZNE0iZ4yAQw9a8E0Y5iU
         XeUiMXprwfzdAOazVPzgdNvwPqWWn0sHZcR2o6R51XQ4ZGdj8zuX37+3IIKUnVj6gZvq
         aAeUv7H/ccFlcg5fYjcvm9/eB5iHTUcII17/1wFmDAQZD8n6pCgIkdmKI49bzdJdXm2w
         /zyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=thS6W+fao1nFVWmRcc04F9UA6vYDU4/A39G2jwslH5c=;
        fh=+5Ty1yjXw0mr8DA4Zjji3Mx6ndeEbpvjiNdRF/fGIhU=;
        b=jp6eI4eUlMKzRP4Jwwy76rzG7qlJ6JxQ2uBe1A3ISIogd3ODH89IAGNlfPJW1gPRc6
         LfVY61pCs7zNPf3Uu2VaKggKtUSI3NMAx1Ys7rrMt15bs6FCQiIt+9zPER5L8yhe3eNn
         ZC0ofis6Pc3t9O58CZ8k88hNJmQbEDEjsX3ViMuEcAyNdcEURjV2E1bWDhRuqrOq1JBD
         chwmLsocWinYNteP1ek7PUWnfUxIH6EExmgY2Ti9fMUJ8RfUVra2X+psvcBB58YTi08E
         uuc2AZrKzIHMnnZaMgwpoqtl1bXJG0basJYuZB56aT7yWmoOA2XopJD1RzBrP49gEscd
         tsEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786577648; x=1787182448; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=thS6W+fao1nFVWmRcc04F9UA6vYDU4/A39G2jwslH5c=;
        b=iyFopiBBTQtmoGKnCVFD3TyBiimBdgGEZMtf69gdbpTiLfFmbM6HDYFP5CvHgAUjbF
         EQl+hv5vuLOxIN/Ys91YbMNx/ldJ4OKnsImJXRue0j9J2LOBUWNEQ9SrQ/48pEQAmABK
         lxhuZvqhqcpaFhX4HZQKu8KnNQUDwWsK6LsKOaucb1KSEws1BduA1eLHPRkpCMA+2MLS
         72/XQoRMraZFkMI6r4uCWmoCUc3ba0F3GRJjaCDBDGruweaD1S6K7EiwTBK9P0C8gCnc
         Xgi9emX/7yebS9vm6oPQeSOS232JHYbb8jkzBM+N+/D+8GfAy+zhdUG4hOhZKtww9Q0Q
         arEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786577648; x=1787182448;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=thS6W+fao1nFVWmRcc04F9UA6vYDU4/A39G2jwslH5c=;
        b=fe9KVsKQPW7YesfCZ1frEow4qqx8dzDQsPed331q4sx/TYn/mvNdnSw1vDHPpmnFBw
         tPDXysshzpX5vOQFXIjpIA0s+1jxtvT0OyaP0Kj+VBj/IhkMWJz7WNEY6twa3LKAMpgk
         IkaV1stZNKbJ14m9SCo0JIQjQwRUgjuPPrNAyfCtBVI0SQoFlHcO4jKcCBjXkwOm8L0o
         mZq4GC4k0J+336MbLGqUZV13esW/bPgjKutnno6fmdFG91ixkCv84BZ30UHVjAsHwP/3
         jztFghpHM0YF2WkaNMliUv/FzpfTjHaKClnqFwmzW/5W24Ur+ooTKXQ9Ib78SbWfwSH5
         b/Vg==
X-Forwarded-Encrypted: i=1; AHgh+RrmdHrT9LZXJE8DSaSpKf90i0pEDapjhUOl4zIZ1lCldj4XjOwdjRdyg9WPEgEEEarvIBmvRKlaYg==@kvack.org
X-Gm-Message-State: AOJu0YwXPs8Y6PlU9zGO74zW2BLgXw2tEhTXMcpadSdjENlWhKJFpiou
	sgqEwA71FNEhohJIimLxR15ut+79UziayS4Dd/iryI6JL642s18h/9LBSg849sHfy4NyUXWlAE8
	DGoldA+weMX/pBOUW5e7Yv4cIyXo2p5aUgNXrPPHG
X-Gm-Gg: AR+sD1351tU92K50fJ2M1A0lrEhh+N2BBnNY9qfdPo6+XRzrVUcdugfb+b0af94tWYL
	ncR8PE90qwVD6B7DpTnx+6Dp+4GIEtUMUFu6QSe/2FkBXCHjgirbDil5mVRaVfrbX8TnlsHUnxx
	ZzO7FyzobSFeaq11aKao2vFlGDW8PcRdO1OSz828zt8AkOu5GU5Dxcpv2QbAfbCEW+Q3d010nCu
	I701q8NUQDqVPpWA6dJMtTkA8OSa1bLJfYtH+MuSyvWqRRSjM4+dGoKkMY8+7nTyru1TNy0EDL2
	46ms/MY5l/FT+fl2g8qzhGZ20VcasfvUWd99ucyWHfI=
X-Received: by 2002:a05:622a:1818:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-52d76908a9dmr2273101cf.10.1786577647658; Wed, 12 Aug 2026
 16:34:07 -0700 (PDT)
MIME-Version: 1.0
References: <178656406317.2437052.7257990869957704195@slm.duckdns.org>
In-Reply-To: <178656406317.2437052.7257990869957704195@slm.duckdns.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 12 Aug 2026 16:33:55 -0700
X-Gm-Features: AUfX_mxczg7oTc2X7HTyQR0Stgtoe03j6Jl-M6qjMNje4w6VW78_BUeDVB4GCoo
Message-ID: <CAJuCfpGidP8p16aacUDpox4UiROdQDrwMTEXmZmb+hXWNhi+zg@mail.gmail.com>
Subject: Re: [PATCH] percpu: Drop CONFIG_DEBUG_FORCE_WEAK_PER_CPU
To: Tejun Heo <tj@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Gabriele Monaco <gmonaco@redhat.com>, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: aco59r7bs1hkmwukspndds6fqq1h981b
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 164A280002
X-HE-Tag: 1786577648-81228
X-HE-Meta: U2FsdGVkX18s8epBF/FE74CaI1PY5sXAP8D3c8cpLv57s3RMde+m7GajbM1AH1vigKCckBVNd8DCFFygXtaLn/RMRMOKVRjSP1YCd30WYM+nt0r4rIeXkDCgRJ5ej+xD11fuFuIHHW1dzJIqNFmOnOw0Qqm0X6aV1hY+8l+o0PG86cB3DUm+/I4N9mVubLqF9/aeESpa1yGC/BoewE8irrt5Mlx1Ky6ku/CamIZa3jdeeScR5p7CuFxpnOfSZyeuC9liUK7pPv0D0x6IdXfBP2kljRsGt9S4jleZPA9+TaBvKKtUerPc0UBMMLFNzUAJo+A+g2h0zCe67Ueany4Kpj9qd9N0bqz6LJ/y2tA7kbTNUdXMpOGWtSF4pX0wsQLN0VacItTswuzZO09zYzm6lXm8mPHiI6ISweqUGktdrllAq8zK4HzpJ5mLExf247O7uki5YVaMOqpd4SUocHh4VzpZUfKYfFXxIx5JFrS5gfjZx3zCf/bupXmHLyobEKwGvllS6MyPbvlJXEr8itlMT6OUULjLD8EyeK70Hx/NiAJldn01SDBIeD9wGbntJcpicNQQ1eQzPgpINohf+/sOhLUdqN8Bh4Nw0lmAGR1JIbZiRHX6oh2pH+2EcUjAsVHV4vTeKX99TG4uv+v/VOocbZJBLm0umO0OgRxBVGSrWyFxN+1/0SAHINbuQgtss0lnVnA+PCoY++Hl0cLapae9u/8m0PVb7diHG/60FLpo5OtIXAM+7skU19h3PamuP10Wxs9X06+dC1e2J/MuesIf9XwP5GpoFCVLgNtAzrli291mkyl/OYZKPuQQryGBMLyNtSEsu8GBwMP0P0Yu+00qlrmgQTqljofUH21ROnX0k3M45IeWWQkOBFeAp0FNXles1X22OdkBzvLLXGcZRJ+PzZdEcfYYB7DC/FISnVIROeoSVBsCdIeHicUXo+FTfVLAMs3i5J7RiRnktFH2Wdi
 xwTP6E88
 ylCa6nRdoV4CERfmnh7pWHB9AE7h44nYLPXpEtjFl0vTUZkx5OtExKNMhmNEBwE1LJb8UjteDmfr5Y8GUhqpMYJ9xUNXlQmUi9na1F91gp/J0b+TQb77sGWNBGPvbvxMkJdDdTY3knCJbDTxFz4YZmKyLcZ7lFgQsxOPBn2ZuNL7FrGWdgWgmI436z1NrSZpgiKFmuzMasf5rIA6fnWw1sOG/Vv2TQwjyqeZfGGtJtuS/E2ASKmcFMm4011ZmLQJ8ZZ1T+ob29P8bBtubFTj6cJ0D1Jz6Pc37prm0RnoudoFlHhufHiivKsGPasFewaqOPoCtbU0j9dyK9ePrrxLhdliFNaB/bvGFROKZTa28G1m0Agb3pX4wJ1kOuDTZes6bDVXZVYyDwhgVxkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 12:55=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> alpha requires percpu variables in modules to be defined as weak so that =
the
> compiler generates GOT based external references for them. This puts two
> extra restrictions on percpu variable definitions. The symbol must be
> globally unique even when static and a static percpu variable can't be
> defined inside a function. DEBUG_FORCE_WEAK_PER_CPU exists to give generi=
c
> code build coverage for these restrictions without building for alpha.
>
> MEM_ALLOC_PROFILING defines a static percpu counter at each allocation ca=
ll
> site and thus can't be built with weak percpu definitions, so it depends =
on
> !DEBUG_FORCE_WEAK_PER_CPU. As allmodconfig enables DEBUG_FORCE_WEAK_PER_C=
PU,
> this knocks MEM_ALLOC_PROFILING out of allmodconfig build coverage.
>
> allmodconfig coverage for MEM_ALLOC_PROFILING is worth more than build
> coverage for restrictions which only matter to alpha module builds. Drop
> DEBUG_FORCE_WEAK_PER_CPU. Restriction violations will now show up only on
> alpha builds.
>
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks Tejun and Andrew!

> ---
>  include/linux/percpu-defs.h |    7 +------
>  include/rv/da_monitor.h     |    2 +-
>  lib/Kconfig.debug           |   16 ----------------
>  3 files changed, 2 insertions(+), 23 deletions(-)
>
> --- a/include/linux/percpu-defs.h
> +++ b/include/linux/percpu-defs.h
> @@ -65,13 +65,8 @@
>   *
>   * Archs which need weak percpu definitions should set
>   * CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU when necessary.
> - *
> - * To ensure that the generic code observes the above two
> - * restrictions, if CONFIG_DEBUG_FORCE_WEAK_PER_CPU is set weak
> - * definition is used for all cases.
>   */
> -#if (defined(CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU) && defined(MODULE)) =
|| \
> -       defined(CONFIG_DEBUG_FORCE_WEAK_PER_CPU)
> +#if defined(CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU) && defined(MODULE)
>  /*
>   * __pcpu_scope_* dummy variable is used to enforce scope.  It
>   * receives the static modifier when it's used in front of
> --- a/include/rv/da_monitor.h
> +++ b/include/rv/da_monitor.h
> @@ -24,7 +24,7 @@
>
>  /*
>   * Per-cpu variables require a unique name although static in some
> - * configurations (e.g. CONFIG_DEBUG_FORCE_WEAK_PER_CPU or alpha modules=
).
> + * configurations (e.g. alpha modules).
>   */
>  #define DA_MON_NAME CONCATENATE(da_mon_, MONITOR_NAME)
>
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -613,21 +613,6 @@ config BUILTIN_MODULE_RANGES
>          It also records an anchor symbol to determine the load address o=
f the
>          section.
>
> -config DEBUG_FORCE_WEAK_PER_CPU
> -       bool "Force weak per-cpu definitions"
> -       depends on DEBUG_KERNEL
> -       help
> -         s390 and alpha require percpu variables in modules to be
> -         defined weak to work around addressing range issue which
> -         puts the following two restrictions on percpu variable
> -         definitions.
> -
> -         1. percpu symbols must be unique whether static or not
> -         2. percpu variables can't be defined inside a function
> -
> -         To ensure that generic code follows the above rules, this
> -         option forces all percpu variables to be defined as weak.
> -
>  config WARN_CONTEXT_ANALYSIS
>         bool "Compiler context-analysis warnings"
>         depends on CC_IS_CLANG && CLANG_VERSION >=3D 230000
> @@ -1053,7 +1038,6 @@ config MEM_ALLOC_PROFILING
>         default n
>         depends on MMU
>         depends on PROC_FS
> -       depends on !DEBUG_FORCE_WEAK_PER_CPU
>         select CODE_TAGGING
>         select PAGE_EXTENSION
>         select SLAB_OBJ_EXT

