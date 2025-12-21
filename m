Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53173E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 23:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A397C6B0088; Sun, 21 Dec 2025 18:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BCD76B0089; Sun, 21 Dec 2025 18:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9306B008A; Sun, 21 Dec 2025 18:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 795326B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:42:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A1021A0989
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:42:30 +0000 (UTC)
X-FDA: 84245104860.19.1C97EDF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf17.hostedemail.com (Postfix) with ESMTP id 64FBA4000B
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:42:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zsk4KVzh;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766360548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXV/4YXkIuBowvca7hFWsL0aDHJ+pblILf22L+sGA+M=;
	b=GOMzg3CLnrVTOOdTUOHrHk7JYR+oGGmbCDMenNRoZ3DzDK2GVWI+U5v31GP49D89L+KUT1
	lz4dEiOb+4cdNok4r5B1vRLtZ2IgKIovneGHrPKN60lonvR63zXH8UzU2UcjZ4ccA3sNcH
	T48gx0Cr/DFAZhx4p/fvfeFjvNi4U9c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zsk4KVzh;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766360548; a=rsa-sha256;
	cv=none;
	b=QpVvt4Mkm1EKLbdmx15/NjS175drF/Q506w+do4ychjMMtdQifQ1lL7PcA8bIyLCMytnLm
	QwG+o1jlF7SRXW8chJNHdM/hUNgmCSLUojmiSsumFv/ymldRHaFoGg47T4AfyBDZ/wqBfi
	hCAENtOMGnB6GtNxDManHMh75XTtzpM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766360547; x=1797896547;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gGxGbnasspaVRRI7by5dOPE84jKe4QonzMZG00rj0ik=;
  b=Zsk4KVzhrJ22uKxgGB/U5pz3GMpTZex1My9Q97G7t3LtM6RvmV9zEOzP
   vA9OCY8DBnELCdDPJIAU2581jjlKCiJQNfGze1UUygLJE4SUmzks7hFqh
   ZoFbR0z+YfpIJmFAsuQnHfHiKjEpcg67YLU3SNALyYtmZ8CNOXtWWhaNM
   V8ChzBsATtQU4zIMCFQHHViO6FpocBqZwlDytHJudHAyBnjTNkMx2kpjL
   3DPI2L2AahvTWcKUz/TnDbKOGVzq666ofnYKsZuwSEpbdngHdfqluXi8T
   A0kO/jpTIhAWS91m4xwmz1HLdk7/+Y0rynuifzrLnKcyXYcZGomhl3BWQ
   A==;
X-CSE-ConnectionGUID: GFoHkqYZTgaXi/gL+NHq9g==
X-CSE-MsgGUID: lcc7N9S/RGSlZlkgjC9FCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11649"; a="79588026"
X-IronPort-AV: E=Sophos;i="6.21,167,1763452800"; 
   d="scan'208";a="79588026"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2025 15:42:26 -0800
X-CSE-ConnectionGUID: r93/8ivDRxKA/B+8tTPRGA==
X-CSE-MsgGUID: 0Kw/AbA4S4SkWxcQYJvWJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,167,1763452800"; 
   d="scan'208";a="199403859"
Received: from lkp-server01.sh.intel.com (HELO 0713df988ca2) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 21 Dec 2025 15:42:24 -0800
Received: from kbuild by 0713df988ca2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXT49-000000000It-2tdX;
	Sun, 21 Dec 2025 23:42:21 +0000
Date: Mon, 22 Dec 2025 07:42:21 +0800
From: kernel test robot <lkp@intel.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Ryan Roberts <ryan.roberts@arm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Kevin Brodsky <kevin.brodsky@arm.com>
Subject: Re: [PATCH] powerpc/mm: export symbols for lazy_mmu_mode KUnit tests
Message-ID: <202512220735.UL4ukFLo-lkp@intel.com>
References: <20251217163812.2633648-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217163812.2633648-1-kevin.brodsky@arm.com>
X-Stat-Signature: zaad4arxekom97og78wrfme75wknt99h
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 64FBA4000B
X-HE-Tag: 1766360547-696874
X-HE-Meta: U2FsdGVkX1/rOHUAzrMT6TDQXBmL0WvKAQBQWDQTJntJBjA03i4qD3i5SI4kpFuDtTUBK0WdyqBmybyA1EF0rkAbvP3DbtDw5Hn3tsFElmcyWCba5Zcwj9IegyrZKG4l9hc/uKRkpSsjO8OiZonNFCiG82mbEFGO5di/vO1c2NSQeNj4kePQSMsv/PmKWLroZUS0WwFhe0SaZO5HMCEh9lxHRZfhN8WITRG65tvRjzgvYIvWj4kLGML0mjCoYvCr7g7HbwenqZkdIrjCLARwkNEwwxSpVrgKrb12+ndnNW3+3DPU+jMzQVbbFksyZ6/fc6/zHA5Ly+JqXkCGrZsCmzAU7fDu6VSJrj/Jv8PFQE6jaDAI3eZv0nEccuMLjVc1KVFvt4twxHwznA5SXPedXIfOYnJe6rgX0vYVsyzbIcyQk+xNXHOOMYxwPAO7iQiOVkkudF9zpluiVTKN6UfbpdMXGa0CL5DhXGv28SeK8T7JzIwqw7F+Kw4kpsPlgENIUAXPo2RUtRFOLqfL3fFoKgDlsQ9RLuUdc1bCjKpkp69wjBY6J96Aa4ES8d2Ze6xM5czUhHEnoELXAvSvK+LAk5FJ88kD8ZSbCIGWY1NDgpF48cF+Lt4T25j0lOLh/OFdaVpAprzO3ZeKeEQemo5HXwnYtO2v0Of1Nhn/VRQ2zBpsY6t8Bxg2igFAVnYcyMLQOdpj0+m5mg6wHZZYuI+FzPEITnhwEs5j5FdQcmXgtC6PdILvKSOHAfOP4jzaiD+hDyf5I4p3ePad6Ji/hMqYgbG1I4F8D3gbFaLF6GyAf5FnGxTbwcywG0M2je7/4GLsm1Kfldm+fA2dLOXsYNWNfXzSYNfl4eanCR4dQNX+JsBcJujbd6nFzG2FQz8bQ1kwpl+d1zu288bd1drlOYAHpxlxqo9PG3aO+OllpFZywEeLyhc7nEjZnKM/U0XfbuTh/Ar7Fj6gVGAY1jl8hsz
 2mMoC288
 igLzxG3MiWic/bkuYDu8DhJiO1wlPPE2wmJRz8VHXRsNC6vsboKeHNuL/F+oJU14vimkq6s//3j9z0oc9B3FhNYKJvPwfrp398foKUE73MuWgU6HJQcHxsecL2/ZbLbe3qUH7uUIZGoEv5I0ERTRdCTRyEIgtvHpUxLSAcCcnKgvlcncq5dr3ISkEeYRYOlcdE8UFNWcbD7sMx7I01NQ5lLsAZ9Z56oCllhqWhkX2a5cUGgpEDeDb7qzgiHiIdcio8kg1KjP8fcPu3oLUw6KTio/q1XaGvra7iqYoHmUP0tvi0zWlZzsv616hTtGgZeJKacZJTlYwUHArOl69zL9A83hxYOBjNGmt1zoTpNgoEFK9Til/F0VHiB157iQS9KWOooaCJqnL2eglKjMaHSjT0AOYmnEzK9VwD2fUtnymoqiI58vGf1WtBZ/Yik/kBMLB3jVJjugguwPOfSGQOqTLSympAN7+lUsgLtBDUu7MJHoGTQAnEDSTdUSEqQp3ad88+qnI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kevin,

kernel test robot noticed the following build warnings:



url:    https://github.com/intel-lab-lkp/linux/commits/UPDATE-20251218-003955/Kevin-Brodsky/powerpc-64s-Do-not-re-activate-batched-TLB-flush/20251215-230757
base:   the 14th patch of https://lore.kernel.org/r/20251215150323.2218608-15-kevin.brodsky%40arm.com
patch link:    https://lore.kernel.org/r/20251217163812.2633648-1-kevin.brodsky%40arm.com
patch subject: [PATCH] powerpc/mm: export symbols for lazy_mmu_mode KUnit tests
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20251222/202512220735.UL4ukFLo-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251222/202512220735.UL4ukFLo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512220735.UL4ukFLo-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/powerpc/mm/book3s64/hash_tlb.c:33:1: warning: data definition has no type or storage class
      33 | EXPORT_SYMBOL_IF_KUNIT(ppc64_tlb_batch); /* For lazy_mmu_mode KUnit tests */
         | ^~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/mm/book3s64/hash_tlb.c:33:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_IF_KUNIT' [-Wimplicit-int]
   arch/powerpc/mm/book3s64/hash_tlb.c:33:1: error: parameter names (without types) in function declaration [-Wdeclaration-missing-parameter-type]
   arch/powerpc/mm/book3s64/hash_tlb.c:158:1: warning: data definition has no type or storage class
     158 | EXPORT_SYMBOL_IF_KUNIT(__flush_tlb_pending); /* For lazy_mmu_mode KUnit tests */
         | ^~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/mm/book3s64/hash_tlb.c:158:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_IF_KUNIT' [-Wimplicit-int]
   arch/powerpc/mm/book3s64/hash_tlb.c:158:1: error: parameter names (without types) in function declaration [-Wdeclaration-missing-parameter-type]


vim +33 arch/powerpc/mm/book3s64/hash_tlb.c

    31	
    32	DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
  > 33	EXPORT_SYMBOL_IF_KUNIT(ppc64_tlb_batch); /* For lazy_mmu_mode KUnit tests */
    34	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

