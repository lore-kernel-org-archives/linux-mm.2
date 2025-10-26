Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 161F7CCD1BF
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 00:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8B5A8E0155; Sat, 25 Oct 2025 20:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3BF78E0150; Sat, 25 Oct 2025 20:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52128E0155; Sat, 25 Oct 2025 20:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF61F8E0150
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 20:03:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50656129765
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 00:03:40 +0000 (UTC)
X-FDA: 84038316600.13.5F28664
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id AB33012000A
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 00:03:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZftjGyc5;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761437018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZnSMw7nXjXzMHenaC0WdXyvdVNAqoqEVjgZmZOhfao=;
	b=wDEdl2GTDKPTkFVp0nDyXeTGyAydUuOHYXZddRuF5PVWqoimaJ+OJRbXSvuVJzodyeXlLK
	lOLhs7XdaUQE5D8GmY3dJmDf2bclPAFFkEALlNgBLxRcw4m1Uk+Frdx95OJUV1usPdwXzC
	m1IiJ0MnFjAem5AkfWHLClNyUF1X+FU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZftjGyc5;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761437018; a=rsa-sha256;
	cv=none;
	b=EOjDw8K8khMPAlqmtvXwPXQwcCKyVrLlqAFwj/VtzaC6SpyDuSc3rG7cFr/fppLJyiA37R
	sClzTN+TChd0M9WbotG01K28DU/2u8jpJxYWkw0L342jDLYgBMPsRr8ZMIvmlkJ1AqpNuC
	/sx61XFE1ztKCRYXQAgfWMk4b5iOxrA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B820060194;
	Sun, 26 Oct 2025 00:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4814BC4CEFF;
	Sun, 26 Oct 2025 00:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761437017;
	bh=qjil+McBNRBHW+rdqa2Qf2obUOow2o73ABEpawIdCfA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZftjGyc5odtP0LBCbfeSJaCAejLYaDXvXvS8tjaQj9xywRPs4q/0c/GdiOV/pbcFD
	 XOTTvoqP0N/CyxCXZ3nOYbySCbI3fAoIarjIjZon+GG4zMoRGpyu4fUqYLia2JRjQa
	 k4BRa0LR2A12REokbNGlxx260I6QYeoxRAsJ7UFE=
Date: Sat, 25 Oct 2025 17:03:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Nico Pache <npache@redhat.com>, oe-kbuild-all@lists.linux.dev, Linux
 Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 173/182] mm/khugepaged.c:113:25: error:
 variably modified 'mthp_bitmap' at file scope
Message-Id: <20251025170336.f0c72983aa63f58c66e2aa2e@linux-foundation.org>
In-Reply-To: <202510251530.eJulmicR-lkp@intel.com>
References: <202510251530.eJulmicR-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AB33012000A
X-Stat-Signature: jmio1ftk8qi5hcmrn33zd5bfqcambet4
X-Rspam-User: 
X-HE-Tag: 1761437018-550387
X-HE-Meta: U2FsdGVkX19gF9gyXqbJl+wf1KLVLsshTisA0397QOpOp5Bu+bFgmvzVGwZ89J2aISXQhyP2ZfWBMaq/QG6cJw+9BQAX3XE3SHjFZkiTPC5lcvTOxJbtH5pDAFZziZWZA0EBGDo/nZsZXKJcG8Pt1EITRLZkXL4OUYqfubFlXEZFX2ZHyIb6+KBx8YXBdfa7rLj7mEDYmml3vLsDZ5qw9YRb+W83bAtifAub4lqsAb7Jh3qbmOTX4tcVhFgOcl0s0NS36IBrvLju3jKg5HVE3O4ntXbZ+2wJHr3Ss3LBgNwfp7IZGAEgSDX5o76PP2Lmo7aVxOwz7AiweQ+PvUjzZ/RLkxRUPuGGVw3ncRPBjpUeQmuFjzHJ/fTSk1qT9Wnhhk+54vS4gXndQtP52OGiIzT2v+FsC4I/EB7rsoCk2zLs/TV1ZoaW3ryuLqWZ7TKOJmrx1U/Lq8rLm7wfiP9iyLVSwEipSSCCmUF/rlnWm5Of8nox7/CKZG92cEawMnlNM2Zp9IIndpKDGZTAJ3vX7aMpRdak7VyI4P2D/eS7UiDIWyXHx+e8tPrPpu3Fl4lB5SuZc5XQ92SVYDX87wEbh2VPrpnLURsKSNOBiMztswSNh4o9Os9zX48DyZ72uoThXU9V8xqtqGM2XuokzpRAMI8wN0bXOE3VTYOO52uDxIJ0lv7jqZG3EgGRhjqDvp480bCtIZn6CmzVO2jjc2wfJ+V0L8VBGfLpRAB0xIPGppQ/WpH7/v0rSmTbzV2EL5sQ4skD2rQWuRsQeGibtZc213viHvYrbJHs91NUxZ3EhWR/6BJ9d+KZXlIgvYlzE3EDUo457B9GYHQ8esavBhqxLN9nX9G2BE1XTTu8SdbM+/ZYL/DIbtgSzxiKzxXpOPnSY9jFDXVfPx5uccZEm9KTJX+dBncjUDZ6l+nZq6njKZvo0mpvpA9e7GO04un3sCBvgWSL8td19U/STF/tyzy
 NhHIeddQ
 PQqenIAnxYFrJmNcUgeYbTKM3kfWzZfgYEPOOV59QrR4PnApjNpZXx8eNF//TriF88wIlTkwTTmufrs3TVnurjuZ0F1L8pnaRwtDpEIXabL2A+Q6hUycK0yiO2tDoj3TwHlA0gj+DEN60/03EcVWjK0Q5Tpg2BsfsYY3qQEwGzJWdX4QY+VwqWK/1PwnlP2x5jNBXxTvURj51AC8G4mu7KfOhNekPoJKPC26xl0jlAxn2HVvqvG8Gxm3mqoFy9pmHXBuvwM8JgTqxfCvcVG82QO56LrZSnR2W+01c7cJacPi7BU1YrzB9zc2TE68fwg86DfWx1hRCePwRv0GJvOoNLeebXuD0KMoRwHvB3ZMrvrpnF7cTg0vYtTef8JRZ4aS63CYe3B8KIcDINCke5m6u7kPRzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Oct 2025 15:14:10 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   752c460b5865d87117095c915addcce7a68296f2
> commit: 8387af7962dd62a2a2cdb741e702b476da440ff0 [173/182] khugepaged: introduce mTHP collapse support
> config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20251025/202510251530.eJulmicR-lkp@intel.com/config)

Yes, this config is troublesome.

> compiler: powerpc64-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251025/202510251530.eJulmicR-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202510251530.eJulmicR-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from include/linux/kasan-checks.h:5,
>                     from include/asm-generic/rwonce.h:26,
>                     from ./arch/powerpc/include/generated/asm/rwonce.h:1,
>                     from include/linux/compiler.h:382,
>                     from include/asm-generic/bug.h:5,
>                     from arch/powerpc/include/asm/bug.h:116,
>                     from include/linux/bug.h:5,
>                     from include/linux/mmdebug.h:5,
>                     from include/linux/mm.h:6,
>                     from mm/khugepaged.c:4:
> >> mm/khugepaged.c:113:25: error: variably modified 'mthp_bitmap' at file scope
>      113 |          DECLARE_BITMAP(mthp_bitmap, HPAGE_PMD_NR);

And "khugepaged: introduce collapse_max_ptes_none helper function"
causes this:

: In file included from <command-line>:
: In function 'collapse_max_ptes_none',
:     inlined from '__collapse_huge_page_isolate' at mm/khugepaged.c:582:22:
: ././include/linux/compiler_types.h:597:45: error: call to '__compiletime_assert_784' declared with attribute error: min(khugepaged_max_ptes_none, (1<<((16 + __pte_index_size)-16))/2 - 1) signedness error
:   597 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
:       |                                             ^
: ././include/linux/compiler_types.h:578:25: note: in definition of macro '__compiletime_assert'
:   578 |                         prefix ## suffix();                             \
:       |                         ^~~~~~
: ././include/linux/compiler_types.h:597:9: note: in expansion of macro '_compiletime_assert'
:   597 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
:       |         ^~~~~~~~~~~~~~~~~~~
: ./include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
:    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
:       |                                     ^~~~~~~~~~~~~~~~~~
: ./include/linux/minmax.h:93:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
:    93 |         BUILD_BUG_ON_MSG(!__types_ok(ux, uy),           \
:       |         ^~~~~~~~~~~~~~~~
: ./include/linux/minmax.h:98:9: note: in expansion of macro '__careful_cmp_once'
:    98 |         __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
:       |         ^~~~~~~~~~~~~~~~~~
: ./include/linux/minmax.h:105:25: note: in expansion of macro '__careful_cmp'
:   105 | #define min(x, y)       __careful_cmp(min, x, y)
:       |                         ^~~~~~~~~~~~~
: mm/khugepaged.c:489:25: note: in expansion of macro 'min'
:   489 |         max_ptes_none = min(khugepaged_max_ptes_none, HPAGE_PMD_NR/2 - 1);
:       |                         ^~~

I'll remove the v12 series from mm-new.  Nico, TODOs for v13 please.

