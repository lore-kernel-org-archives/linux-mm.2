Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0552CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 21:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE906B008A; Mon, 22 Jun 2026 17:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29EA36B008C; Mon, 22 Jun 2026 17:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5B66B0092; Mon, 22 Jun 2026 17:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A365D6B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:21:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E9198D004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:21:49 +0000 (UTC)
X-FDA: 84908820738.21.158F5B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A92CB4000F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:21:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oDGq302Y;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782163305;
	b=Bj5RPYYXGvLr8r8cjmIEunPUmwWTSmLaiEJe4X/VEUH2IHijMcwCDvtK9tvAhJgi9UZiGS
	e1021o5qI2JnOn69p7wqe0++zRSPAvVp3zguulUSczCsaUUAkuj+s2yaMEetpyCsq6fvSi
	ioHVlrAh8dGwe7tEKINIJXQL3rjmmhw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782163305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7bf6olGmt7hkBO5KYr6/vTauRJAu4wZdDeislSzf3I=;
	b=Kev9j/x+ir+uU5muakHolScdHgDLwgXT7czAylRmFNwW/P5O7lhKCOWfsyF24emDSztD2X
	BHT1RakcdKd5bfqQfxUXOZ8TyD7skh4FK/rOFyRUIcA8UEak4v0Zsuml+LOfo3VBC1sCLF
	9zXOisAMHmp2hlQR0wzKgVrrqwtcQ+I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oDGq302Y;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F35D560209
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45CE1F00ADE
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782163304;
	bh=K7bf6olGmt7hkBO5KYr6/vTauRJAu4wZdDeislSzf3I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oDGq302YSkRLLuy53C/krBtehhIgbEsZSUmSNWyOIC2T7z4LjIPKRO5+7mJ731nM5
	 9tmasjHJq6H/neqSlK/SIudeCAux1cuT3QN/HtQBlHk99V5rk3zpAyD3oXKaaBcsjD
	 bQTeQ38HfNocTUgAI9akHEr1SY5CeUkiJf0F0jn+bqaLxCIuu/KMsxPQtWMq9ddfsI
	 SEa46R3prf6YD6If5ZY9/X51ovFGDpAE49chaDD6rblVMBaJUH7WEIJCviMD3P1xTf
	 GIs2+D3Da0gi+JKUdFIIn9hPc8c/qIOtTrHUYaNWOm9yTjWA1y0LKDRhovhdWJWMyh
	 F1r1G0Su/mjkg==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c0c41ff84a6so384966166b.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9gJQA2h92eBf6Te7wbUrzGM+4+UlCk/RfeqXEt1VgWntT1FJLtptaYEMGbpPJ+7keHmt+H6NBg4Q==@kvack.org
X-Gm-Message-State: AOJu0YyihAXl7W7G8AFgb227k/sCWmpoAWcAo27DOnHoCAS+JiKifocL
	ckm33cywCr2hi3fCUgFUt+M2WE/A4H2dvMalgf8toGEPPOKiCzZ4WaHM6ShheAzBw2qJ6wOACuM
	9VVizLZN9+0B4o1b8Vb3j3fUxaroN+eM=
X-Received: by 2002:a17:907:3e0b:b0:c06:c347:e7c7 with SMTP id
 a640c23a62f3a-c097ade1ea5mr842249166b.12.1782163303421; Mon, 22 Jun 2026
 14:21:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260620181635.299364-1-youngjun.park@lge.com> <20260620181635.299364-4-youngjun.park@lge.com>
In-Reply-To: <20260620181635.299364-4-youngjun.park@lge.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 22 Jun 2026 14:21:30 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNjyW1rh26vv2vavCM_2-r70EuynU+-7XdEmrBdLL=TkQ@mail.gmail.com>
X-Gm-Features: AVVi8CcxAayH4paap-iXDXhqMrthHES3wd454M-yl11XJLm7VTcI9H0HymmZ1dk
Message-ID: <CAO9r8zNjyW1rh26vv2vavCM_2-r70EuynU+-7XdEmrBdLL=TkQ@mail.gmail.com>
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier selection
To: Youngjun Park <her0gyugyu@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, youngjun.park@lge.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, 
	baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jxzayd1qogfp7stkbz9or7yd9ndormdy
X-Rspam-User: 
X-Rspamd-Queue-Id: A92CB4000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1782163305-886365
X-HE-Meta: U2FsdGVkX195LS2sSvhJXuBAlTO35gfsAHVGKvlVfgj2fpmKJWtuys42rLPrPSUQbSXW4sx59Z3iv3VREiWxSyb0EPFgKMIzf4A9zGeBq/UIHTsqSHhl1uQDxNunxsaKsT3EPn1HrdZ5lVTOA/jmJyKeBrdbLJy4d0ymo66byvE6xvYHM96urOQdF3E0wiX0jQBWflJyBjGqyh0ptSBQQ3y5Zt/CLEcsZjThdwR1G8cRZX8Vg5hhV9NXjQyGpYzRascMUzNDFt1kwkKweED/7p9BZvz2RuA2OA7Sz28bH9N2oMYquU9a4ybOVYCF9bAN2MriSAVImtaLKAfzXi2REEaGS1rd2b2f2ipqVfE3hxdn4WYUy9UzOONTGe0/dvxLRYK/HYFwE0xLhO2r3KstiOnGriL15/TwjbaUTPtBJDsacr0HujUwORg/ukix/dQa2PKUg71GeMXvkU+wXFwBEvUlGfCdUbmgbL6mkc0YKHGceS1kqdaFr5O4zs6T2K9PGSiO0TEXw+2+8MTUL9la71SOJ20Sa0itybIFdBhDN32YlP/LTTOwNqMjxjay4Mc9jSrUhCAMg8qnE8LhKqaCesGPannLLowlolgLGI9qywcfCgwL+k2h7iQpt9p50Odern/GI+EVzhGUuTJm7irilKCAxwIWrVT9TZcrNaC3k9hMmiXbR75wWrzxNSm1iVGttTuzs6WSiVesXq/DpKoqtMo+DHCh2CHkq5f6VofyPLnKjqXT1alRsFYiaSbq28H1KcjY8aB0pkevjNcXkkhKZbxTwy1IE4d8EUIBASOzIghSsk/Yron+SBgfyvFZcSp2uEZi0KEG3Lnu6BA7DDWVM514mprzWMe+Eu01hYbHV5qpOkuJyCmt0A3C+iERL5Q68+9462lDULk8RX8kxLkrVd6QrTOXkqJKt6tQnpjQSomZaoX99AVd3B46/9P7k65LbAVpnla8PT2qSrg6Gcq
 yRKp54Gs
 aYPfwHo4iAuvFNyQw8r9DjVQR++wLR1/G40X073WmL9FWsltTbEGzMfsInO2pcs7Z+d8VSQ5Ndnh5Ao9b48Ox2yCGltLTUKkbsFRnf2O3T8TCet3511fPqaEe08SrfhXXaGt/PHCi2jhuj09z8PxOS720frc2YsQ5fbNhd5Jk4PLAOVnPzpHGXtn0gkZvwW3PzcNM1KWLGLqj80qwMFovZXitIe7/0Up/2DcSKiZH2TzaSdinIe0+ajxNlc7e0XH4IV031snZvxis1SNe789OZ6bzuGKOFAYc5j0FTLmIGmN2FbBSXpypDXopX3wfvJw35zm7kePY/AN49LLittbSazJntEIMUznyLyARQBFinmjdpk3GrzYTa3qWHuEGh9ATFkZquV8eI3vcwht00vUfMtCWcRK1kDD+i06XlEDITgJwqxdhEPWk73KREw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 20, 2026 at 11:17=E2=80=AFAM Youngjun Park <her0gyugyu@gmail.co=
m> wrote:
>
> Introduce memory.swap.tiers.max, a flat-keyed file listing each
> tier defined in /sys/kernel/mm/swap/tiers with its state, "max"
> (allowed, the default) or "0" (disabled).  A tier is one bit in the
> cgroup's tier mask, so writing "<tier> max" or "<tier> 0" sets or
> clears that bit.
>
> Since the current use case lacks amount control, it only supports
> "max" (on) and "0" (off). Therefore, it does not track per-tier swap
> usage, relying instead on a fast runtime bitmask check.
>
> We maintain both `mask` and `effective_mask`. The `effective_mask` is
> strictly bounded by the parent (e.g., if a parent is "0", the child's
> effective state is "0" even if its `mask` is "max"). Maintaining this
> separately avoids costly cgroup tree traversals to check ancestors at
> runtime.
>
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst |  20 +++++
>  Documentation/mm/swap-tier.rst          |   9 +++
>  include/linux/memcontrol.h              |   5 ++
>  mm/memcontrol.c                         |  67 ++++++++++++++++
>  mm/swap_state.c                         |   5 +-
>  mm/swap_tier.c                          | 102 +++++++++++++++++++++++-
>  mm/swap_tier.h                          |  57 +++++++++++--
>  7 files changed, 255 insertions(+), 10 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admi=
n-guide/cgroup-v2.rst
> index 6efd0095ed99..4843ffcfd110 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1850,6 +1850,26 @@ The following nested keys are defined.
>         Swap usage hard limit.  If a cgroup's swap usage reaches this
>         limit, anonymous memory of the cgroup will not be swapped out.
>
> +  memory.swap.tiers.max
> +       A read-write flat-keyed file which exists on non-root
> +       cgroups.  The default is "max" for every tier.

I wonder what should the default behavior be if memory.swap.max is set
to a value other than "max". Should the limits in
memory.swap.tiers.max auto-scale or remain as "max"? We probably want
to keep the behavior consistent with memory tiering.

Shakeel/Joshua, WDYT?

