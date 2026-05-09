Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8874ECD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 12:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3376B0318; Sat,  9 May 2026 08:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2940D6B0319; Sat,  9 May 2026 08:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9FC6B031A; Sat,  9 May 2026 08:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB3D6B0318
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:45:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 973441A0657
	for <linux-mm@kvack.org>; Sat,  9 May 2026 12:45:11 +0000 (UTC)
X-FDA: 84747851622.26.36BB408
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf08.hostedemail.com (Postfix) with ESMTP id 00AC7160003
	for <linux-mm@kvack.org>; Sat,  9 May 2026 12:45:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jO18HT6e;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778330709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=GnWKMWpRBOapIsyAW3wJ7TXK/RHjbYeTFRp+2whl/L8=;
	b=q9gNwXf4eY6dJwbAJ+m4hqVvLnrDWJ68tliNNmM+GvkaAyj4LWLgXum9Xj5rrbfuvM3mox
	CuS4bxsfEnM6E5/6T2mbgC/+r5TEqQnMVqq9WbMaiUGM3Ija1bZkVDK3pIXqzUpGpMSXm8
	izfN3gSoHO4safDRNpNScoMwds9MFlE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jO18HT6e;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778330709; a=rsa-sha256;
	cv=none;
	b=WbjVRGnSjeLkAhN35HCQFAInkWm431EeafNSQb1imEpEeAxJT8zAYXMWo/ubT5jGMvsxSI
	4UYX3LvOeH5k//D//rm8Lk0d7MG/zrG9doxISis0gUp4BJEBIruW4jF5VuCB+zagMAFlFU
	BsmuJ00Lvfb/khYKkrCnsFKEW9R5toI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778330709; x=1809866709;
  h=date:from:to:cc:subject:message-id;
  bh=PZUmvWKfk7e0sy8zXMC5sqRs+3lIo/RPX7h8rdfkXr0=;
  b=jO18HT6eW4r5KHIDFR60AF1WJNfv3u6PcsfDJmx9pxDAs1sd2sexCi1F
   kT/z6rGQ6pI0WJY0J7iyhS0Fr9w0Zyi9hLn5fyRm+zLpOJPxBaSuokMjB
   hxZ/r/X7F858LOBItwLt6nBg02bV/rKEH8sMH00ZMkczfB5hXc98ddo/p
   ApELTKoWMuY8KTuwdCMXk/mV+uRcXkEbvFhyUiZri4vcLWKiBgJIoSrCC
   e3xynAhZY8SpvbVQwyJ7xpZT2ojcF5VFLucBXuPGfJyJKsChYDwAvxygX
   mo4i6DoMqdu9ikgCg+/xAw63hrL7hzUcRzbbcN3kG61qgapCnAC1THuLh
   A==;
X-CSE-ConnectionGUID: ITbM0KhsSle2tzF4p0x4aw==
X-CSE-MsgGUID: zQKXx3+uRwmInnLVVqXVjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="79472648"
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="79472648"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2026 05:45:07 -0700
X-CSE-ConnectionGUID: P6lBYFujSIqbxLGDDIJAWA==
X-CSE-MsgGUID: VWT1n90qRQ2srTMb+CoJPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="242015322"
Received: from lkp-server01.sh.intel.com (HELO 82327192134e) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 09 May 2026 05:45:05 -0700
Received: from kbuild by 82327192134e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wLh3G-000000000zN-1riu;
	Sat, 09 May 2026 12:45:02 +0000
Date: Sat, 09 May 2026 20:44:33 +0800
From: kernel test robot <lkp@intel.com>
To: Jiayuan Chen <jiayuan.chen@shopee.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, SeongJae Park <sj@kernel.org>
Subject: [akpm-mm:mm-new 222/223] include/linux/damon.h:869
 damon_rand() warn: always true condition '(span <= (~0)) => (0-u32max <=
 u32max)'
Message-ID: <202605092036.9mdDJbEZ-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: djdrfptswbmp5iqy7tfdc9si4fb89uhw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 00AC7160003
X-Rspam-User: 
X-HE-Tag: 1778330708-808388
X-HE-Meta: U2FsdGVkX1+5KTnYMxVhY+GOIIeGufj+vRcmhAfll8PIdv3v5q7NADSpJeU0RAnLC6lP1TEpNZLhwk+tMP7EqPiWYHwusWY4fArzgu96au79kw2S94pfxeKRgJELuCt8xd6cN9taV/jlZlpNPlZHXkU7c+Djo2y79Oc3wsXofiXaWanu7AKzIehsb3N8dzvPBY4G6NC5BzYhLGt4rvdMJUE6uOS5J2z5u3ReocALwOTrCxIlpdhGXUcvRDIpY3XKQIZlIjNcjlqORcgSEbBksairySMD2+IwxgQdzQEndk6xvqoPUOU1sNGlILu+tnfabjAwUtWKY9upLuylh0C5rikMy8L05UthMdMdD6t38nAQQ2GfFFJpsmUhCl9I+f/K+IGcBxGe7CveqYDyf6F0DxnIL35v7ihaio39WZvmHXtBuX5eWT/l23eKTvHRqbmtuwDQD84X/2U45I1QDKMcF/jrIEjiSezEDPDiuyzNwwRYpZA/UO8owfyML8i5P9dyQQkaNlDm+4NPpi21UEmB5dWh3Jcn10ZsFeQVXxd6sHsZL0ofakC18pdOOy9yBg+1IDfrK9xahP2+VsiIhHIm1W9Ghnq/w0mLKiOvQAYboezSuyFiOXBkAcWc8Moy+BcgRRYxiFRvRkaGcMi24CONZGwB/uaCR6AyDTbZnIHe1x8Zv8h+Q+DvLlRaZCAl1A6Ol2lU/UO/ppJk/RE9r4R1Re30S4PSXH3OI0zyv3bjXWuMWFgzfWYlTxXIpsxH3kTe/J4IwWjS0r+TXietQbDnXygQJM+qwWdxg5CFGPsyrsZbpNJKfp+t1xK3un4p6m6gWY4YfJsmVSaIL+/NhWw6C+dgL2tbmXqGl1diLO8WdHP2Obi1jEjHRoC6dN3ikI00ywGYLstYanJea+ksMny64rch7P0XvAD41XudoHiYNF2SXhd427wMNZwD/Q4uHYFkKq1HosClm2bjeAwZpn8
 dZVyhWLM
 rKwOvO/fZnJNAuyMLr47tOUJ06HFoKRGWbLtHElgFvZ61YHpURyprXPYz0OqOf5PwgVoF5HFMbLZPXw8dp5zPvCvdLJcVs9+3CCIbz6BIAxAVeLvlxfAODI5tChJNE9XbLizYK7owswlvws+G6/WjAtItEGtPnzQcA9eo/jEkXKAtT4UOaaPfC2Cz5ZblNCN7KYXwyZgqD7hr4tgchmBTOCGMYQeHSti/utsL52/P953Vshz7pPtXHHMSUutDarexe4yOJtTeZAXM4Br0O8hLeFybiql/Ndqg5jmnieOKKfAynWHnVv+dNEaz2wnNKllxwFw5lOaQVWMj1AE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   7505bb13a9bb1f214310915ccc06643119fdafc9
commit: 8b7c38eb9621c71d288eca45c8dd4dc92357dc07 [222/223] mm/damon: replace damon_rand() with a per-ctx lockless PRNG
config: riscv-randconfig-r071-20260509 (https://download.01.org/0day-ci/archive/20260509/202605092036.9mdDJbEZ-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 8.5.0
smatch: v0.5.0-9065-ge9cc34fd

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605092036.9mdDJbEZ-lkp@intel.com/

smatch warnings:
include/linux/damon.h:869 damon_rand() warn: always true condition '(span <= (~0)) => (0-u32max <= u32max)'

vim +869 include/linux/damon.h

   861	
   862	/* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
   863	static inline unsigned long damon_rand(struct damon_ctx *ctx,
   864					       unsigned long l, unsigned long r)
   865	{
   866		unsigned long span = r - l;
   867		u64 rnd;
   868	
 > 869		if (span <= U32_MAX) {
   870			rnd = prandom_u32_state(&ctx->rnd_state);
   871			return l + (unsigned long)((rnd * span) >> 32);
   872		}
   873		rnd = ((u64)prandom_u32_state(&ctx->rnd_state) << 32) |
   874		      prandom_u32_state(&ctx->rnd_state);
   875		return l + mul_u64_u64_shr(rnd, span, 64);
   876	}
   877	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

