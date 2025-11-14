Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C76D1CE8D77
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 18:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93088E0007; Fri, 14 Nov 2025 13:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D435E8E0006; Fri, 14 Nov 2025 13:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32B08E0007; Fri, 14 Nov 2025 13:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B00618E0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 13:30:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66CAC12DB74
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:30:04 +0000 (UTC)
X-FDA: 84110051928.17.0542B2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D666480016
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:30:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XUbzaX8m;
	spf=pass (imf02.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763145002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60HYXH6bByFI92d3pGZh5EfxTOesIAaHrVoMastvzas=;
	b=MJO7LKaSjIQyqi6fl39YkxPKJ8nJFyAbcYQwFQieCQ8WaaEn++8Ba5AQ62335vjmDch+LF
	vdRfXsIDF0iFwU/l7hWMumTbpuObtSahMh6H1tvtjw6myzatscW4z0bm2c/VZGVXnU+aZt
	oIFSWpLTlivu/oZ3IgAnv50ov2Idkg4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XUbzaX8m;
	spf=pass (imf02.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763145002; a=rsa-sha256;
	cv=none;
	b=vtlw2UTn4pWfTSDQ3xPzE1mbKl0ZieUOJc4GkFPo2LaIx5VyUBWODgBeTTzT9oTO+Mby8A
	GIhCqRRV3xWMzyG1kgm3bE/w7aX8K6QO2z7Mj/QA2tnfLJR1gyqmmkBVCphMHuZzrFkJLs
	/xZ4yCx09bA24c//yEsyFp++4nmW2pE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BEAB6018A;
	Fri, 14 Nov 2025 18:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20FCC2BCB0;
	Fri, 14 Nov 2025 18:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763145001;
	bh=TIbxS6C7c5fCvewEBNrOfoVYvU8etxkoLMi7WDCMwqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XUbzaX8m+OtqpsLPNs4j9vqpnhAj756anYr+ws9QRRC/gShZkuLDg58Le5LCNNOa1
	 n4jCOkbVMhKaWWj9qU7dXy8wpVeGFYJXtbXNwZhfk6xIjcSVkxK2uZLHKkagIMWu0R
	 OMypIBkw2zA6BlG3lCYRBGXmbSiqfBXaddUbPs0bWSJeo0n3xu8WXwrRYAzVeAKxc8
	 WQVM1aaDL5blFOtwVV8vVjP/MpfoZD7Yb3sa1NWV/vE6DjJG3Ut2+QvuIlLSJ1dzWT
	 uvqKSARrhe+FRNDJeD8NbrWcQyUVxLtQuXe+qEniZEsZRtwYU4X34TtqyJxUYbXwH9
	 w49/0qdtqNGeA==
Date: Fri, 14 Nov 2025 11:29:56 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-unstable 36/283] mm/hugetlb.c:4753:18: warning:
 implicit conversion from 'unsigned long long' to 'unsigned long' changes
 value from 17179869184 to 0
Message-ID: <20251114182956.GD2566209@ax162>
References: <202511141140.LrrRrtIv-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511141140.LrrRrtIv-lkp@intel.com>
X-Rspamd-Queue-Id: D666480016
X-Stat-Signature: 1m95x38kzswwbs1s453jhf9n33ty3z6s
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763145002-134156
X-HE-Meta: U2FsdGVkX1/npcJKvECiECVIz3EiyzfIAtS7730JIESK/81hXOn+7ERs6TkM+7IOUgrUTf3/ufKyS/WeuC9X8lE3emC3cSXcavG0bn3T/FvKqMFVAMGc4wVwQXnD49AUR6Xt3p4zqp5h6dbWnXKSSKbF/ipzLoF8V9X40HAsHB6FVz6V9VbHKuKlUybTUZnLJqO0iI6WDisY3kx6Ed+YXhNMsq0NS6bEy1NrqsxghSv843FkkJpDeoV0TV82ikWgFxyE4qVfZ9IAP7NLz0li8hwlFiNdKY4yOsr6c2e/SiLVy3WrkZBI0NUexO2d2v1xS6r4WZcTUsuxLws0D0Pw8yp5XArrdCmI72K+qV4n8McdMXE+jVlb3ugrjdEG0wI2K3CuzfCjkPIkWMaVIUrpdovlVUkOgGTRm7RhIiB+9CKqWnUlKqXHPOw+1X7TVGvSVYaR1pRM4vzXaclCZA+tXtvs54asJx5cUrkvq4QfqYF8aKbJxjnuKOBFS4lJGYOsoLowAIvs6t1SzSm9JBp3piFU5jCLnMwCO9a2VF8uYxR3W02Oa0A0meEBepaLq4XNKvgJ6Bf9pAeUI3JiHIwQW4rwQjyxJl5qS/JlN2/LlRqbIGPKBMtnrnxT62r/4OooIhFd+NBuHhfNT5LkyWPzzc01cdicfoej9/fEMhRIuf4+5ctl3dFzcMdJYWqBmhX33yhxWdoCDJ1ulWRf5NHrS9XNIp8vQb8VMWoDCgXC/gpFt1yhZjoZPL9pOG1edcUYfbHFHyaY25qM0lnDE9B9QmyoYLGQzGRUxKb+jGdVzO5BvAR+KhMrabXE5EM/i0ByZtVsykzv0BoSWYAIzrHRmTHErCuQ/4me3UqtRkvazupbEz4AnsbIsIGrSUdyZ+HS5KEuRsciJnuxaWLyar8cXyT/0tmHWSvVGCliovjZVbt/N9KSgpfyuP2ba8BHN2KFZX4B6x0Dh6P73hViHPQ
 9kPwkK2n
 rYSimgk2xfI5n50nEw5PuBcsBj+hA/FSXf/8BwYQPY3CHYjW+kY7bUXTMKTp2HdR+D2lplReq6rDqj4c792O4Eymgg5W2JpqD3wq+tT6K+itmdLyU49JX6WbO9yvGKHvr2JdiTxENXpqscSHIhO1ZeMAY/y7UlAe6AG7SeO/w9mWOu5Eyjv0bqcS9Dq7pFNWyrWkLOPMThRk8LRnqb/a5Igl1rny2kFL45utD+Yva64li5ALgTwJK44lRcViToxbri6dvgsQBxOPI/q7gNuLbIrRkwNHGszQZ6Vnfq08h1v3AwUpxVt+6Yg3cAmEv3oeFRvt28jNiQHMl3hfIRolRFdVLwBA7spmtzSqJMZGJ5Tv+FR10ccAbuSTovA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 02:46:06PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   1c571d1c4c7e042c3c313d1a2058a17848ccebac
> commit: 2f6ff71280ffddb27ad7174d24f573e2683870cd [36/283] mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
> config: powerpc-randconfig-002-20251114 (https://download.01.org/0day-ci/archive/20251114/202511141140.LrrRrtIv-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511141140.LrrRrtIv-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511141140.LrrRrtIv-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
...
> >> mm/util.c:1263:16: warning: implicit conversion from 'unsigned long long' to 'unsigned long' changes value from 17179869184 to 0 [-Wconstant-conversion]
>     1263 |         if (ps->idx < MAX_FOLIO_NR_PAGES) {
>          |                       ^~~~~~~~~~~~~~~~~~
>    include/linux/mm.h:2104:36: note: expanded from macro 'MAX_FOLIO_NR_PAGES'
>     2104 | #define MAX_FOLIO_NR_PAGES      (1UL << MAX_FOLIO_ORDER)
>          |                                         ^~~~~~~~~~~~~~~
>    include/linux/mm.h:2095:36: note: expanded from macro 'MAX_FOLIO_ORDER'
>     2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
>          |                                 ~~~~~~~~~ ^~~~~~
>    include/linux/sizes.h:56:19: note: expanded from macro 'SZ_16G'
>       56 | #define SZ_16G                          _AC(0x400000000, ULL)
>          |                                         ^~~~~~~~~~~~~~~~~~~~~
>    include/uapi/linux/const.h:21:18: note: expanded from macro '_AC'
>       21 | #define _AC(X,Y)        __AC(X,Y)
>          |                         ^~~~~~~~~
>    include/uapi/linux/const.h:20:20: note: expanded from macro '__AC'
>       20 | #define __AC(X,Y)       (X##Y)
>          |                          ^~~~
>    <scratch space>:39:1: note: expanded from here
>       39 | 0x400000000ULL
>          | ^~~~~~~~~~~~~~
>    1 warning generated.

For the record, this is not a clang specific warning, as it happens when
building the same configuration with GCC:

  In file included from include/vdso/const.h:5,
                   from include/vdso/bits.h:5,
                   from include/linux/bits.h:5,
                   from include/linux/ratelimit_types.h:5,
                   from include/linux/printk.h:9,
                   from include/asm-generic/bug.h:28,
                   from arch/powerpc/include/asm/bug.h:116,
                   from include/linux/bug.h:5,
                   from include/linux/mmdebug.h:5,
                   from include/linux/mm.h:6,
                   from mm/util.c:2:
  mm/util.c: In function 'snapshot_page':
  include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
     20 | #define __AC(X,Y)       (X##Y)
        |                         ^~~~~~
  include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
     21 | #define _AC(X,Y)        __AC(X,Y)
        |                         ^~~~
  include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
     56 | #define SZ_16G                          _AC(0x400000000, ULL)
        |                                         ^~~
  include/linux/mm.h:2214:43: note: in expansion of macro 'SZ_16G'
   2214 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
        |                                           ^~~~~~
  include/linux/mm.h:2223:41: note: in expansion of macro 'MAX_FOLIO_ORDER'
   2223 | #define MAX_FOLIO_NR_PAGES      (1UL << MAX_FOLIO_ORDER)
        |                                         ^~~~~~~~~~~~~~~
  mm/util.c:1266:23: note: in expansion of macro 'MAX_FOLIO_NR_PAGES'
   1266 |         if (ps->idx < MAX_FOLIO_NR_PAGES) {
        |                       ^~~~~~~~~~~~~~~~~~

Cheers,
Nathan

