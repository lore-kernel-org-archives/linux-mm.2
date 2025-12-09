Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5377BD3B7E2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87A726B0005; Mon,  8 Dec 2025 20:10:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82AA76B0007; Mon,  8 Dec 2025 20:10:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740116B0008; Mon,  8 Dec 2025 20:10:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6282B6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:10:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2DC9160347
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:10:56 +0000 (UTC)
X-FDA: 84198153312.24.3185962
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5A03D12000C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:10:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="V59VH1/l";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765242655; a=rsa-sha256;
	cv=none;
	b=4Ui8KJULrr+HYb0ZMn6ToZEJUP0cGF7Xm006vDXI4GQdRe3KL9xRLfrB3IvATVGdbDiUxt
	zBc5N4AE44jvz2CrVqdDVvoEFh1yKJzuyQ6wAnpFUod5NJQupJY44GtjsRx/WNJzTTDk4u
	TmZa5IyA0v7cPaYes4xSuJ2y2o8wsbs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="V59VH1/l";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765242655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7kEoT3OXFDBtQpIjlKhgqBDkSYryRQU8lvQ/Zrvns4=;
	b=iBhHKcc2joR5LXNxalkT2gLVSl++YMK82F+jdMDtJ4Lxs10noFqOBsjkQaGZ986NbtYqCY
	ycaOCbqEDdogVyugoYAVebAkaSLMFNPoMJR0jMqFqYq/ue09ltNEFu2K+EPy38rZ7+jjmw
	SqAaFdGbH6TswSM8nNLeJD2OMJ9FlQI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765242655; x=1796778655;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/EbTB2VpFhTczeUk+QQoWbLB5Re1Ql5lmWm28tpOWNM=;
  b=V59VH1/lUTYO/HjO36BoZTvsnNBTr0wmsv8vpeGf83y0hLyBKHxWLLUH
   ygR452WDD+rANQkNybX0df8B7B7hb2SsPlVBuDE1ENyYNWCY5DtGdzCcA
   FcemMW4afJt1haL8C6pcFrEcCqGgVbWWgn+QUWeW9vD0lfVKptuQrBMoh
   oFQmFeJFp7uhLnyqMCn0yvU62HO5TqBaqFR1wQw+c+PiIedNbIxp6pRAP
   ZHqG/yhNxWEPoIQG7yLqrUEA9bPa2tyxM+iOaja7hQ+aI8pQLmQcV5jB6
   bcUAYTxRu4KdPweb9PS9SfGo19XIzKI7JgVukI5sLMhlW8iUl97pxcfH+
   Q==;
X-CSE-ConnectionGUID: BNs0f3q2Qx231vLFKAYzYA==
X-CSE-MsgGUID: qX3E8vO0TymOW+mhhWXcGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="92669363"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="92669363"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 17:10:53 -0800
X-CSE-ConnectionGUID: iU7rIwTtT9yciBOprGY+Sw==
X-CSE-MsgGUID: 3CbqSVE0TaKwTC+/XtMQCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="195368149"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 08 Dec 2025 17:10:52 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSmFc-0000000017W-2zkh;
	Tue, 09 Dec 2025 01:10:48 +0000
Date: Tue, 9 Dec 2025 09:10:40 +0800
From: kernel test robot <lkp@intel.com>
To: Brendan Jackman <jackmanb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH] mm/vmalloc: clarify why vmap_range_noflush() might sleep
Message-ID: <202512090844.OmozcWcI-lkp@intel.com>
References: <20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5A03D12000C
X-Stat-Signature: 8obqfk7edtzw6qnswtpc819e6wefy5gu
X-Rspam-User: 
X-HE-Tag: 1765242654-710641
X-HE-Meta: U2FsdGVkX1/QVP8xos+Dy3QvZMkFKbjrPOvxkN06SGtokNjmXFc5ivQb4R6DEKmaFTAjtg16Th6fW98cEHbo5kYtUgd5wK4075cYTiAAEplsD4QMnChnAU+fM85mSO2Kbfe2btd18leiR5c6EVVuxQC8YegYpTg/4Cn8IfjRmz842rZjWqzNoS3ZHjQ5ldtBM8oYHYD3y4HfgdwV+LQZuSE+iFU0Eb0IklQdEMB39ch+Xeq0Veca02aPQ6AZYDP5H3fhkDH2lLiiOZURkbR/mX+NLFn/is3ZEyeMrZ+MhDCb9EG/xOo+DSbjAoeHBrHW4Ok/6f6+wRdqbSqtd8UMr6ZcGbF0IQcdyuqo8a7wi4FJZqQGVjyHPdZDSI8JacAirYmDd0aFVmxPhVTHBwal8Y9BrQmdytg5fi1vfzi+F9x8RosLCY9WxmgngUInjUrqPY5kUHn/R9QbweH9h15n/B6hVhhKjK6us9nRqgyv7+kEFLzdGeL2qzFN11jS0NG2CwNJb7ZrYZPPhhfmUfy3KF7r24npwjKfBJnrOlztz5Dpzo7nhz0jJaKed831XZDhDvz0dD3jL/fNxA4hlGR9VALV/WId4c3yt4bkzXsc7stK4YBkjAOTbPKxMD0x3UTFvvp+KpUVFPtTnFAymJJYVGbxs8nGQk4goHCgu+iVM57vWY7x8bQcvmWp1YWkZCIvyi2ogGnNoQQaS6Y07C4uwp1ru9o/iV9ynR74kiLFgNClzNEzA1v2M1Nff/IvnV5XcFoYHAnN6DNAyQtlqz1+Viz4/PqmmvI/vfJbN96n4DnhevwwLoQCbs615/SYzlv3wy1TwupFCXgVSWNyx94JdkBQQbFRFoDlHo/6c79Z+cEyoXwtYfQnw8c0Xjel3v5Wb4BbbEXPXv39GoDcaf56rvqgNMZvL2FMBXd92CGod5Hq0kZHuChJg0DTNV5UKcxFpwpfqibaLXjwTretzNk
 jI0i67M1
 Rd9pRveR6/6+P17912by62zEhcwjqiUS8o/SueStcdWqfOkvISWuutujQaQQn2T2+r13678UYi1bLyZeMXM4jpiQccF3m7+pDgEucnPP3juWyx7n4a8Dgyhhbd5vFgvdmoDEAcvP5WkAyPaGNHfzaj58b0gOlL+fOOLfNuc8M8YmlGURippCMQisKnoZz0sgqRYo0yoBjon/fybo6+Axbct5KUUZ/wvxHUOMPmCZsfU5wdgAkXXcfnLDjGHksOIWPi8iFGvu4RhWtiO5xUyu72VlBul6y1+XpSFcwEHVPFu1e8mu6DYNRjBPdzJMOucAwMm2WoCuyIZUULv1VcSNrZrJXEjQuCrzwEZgt+8nz0bVlCJah44ZpeMuDLNUiWcvTGRkpnYtuDoXsl2tEcP9a6X2e4QWS2cLzTSV2UPjG0Jfn48JLMcVYIiFzXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan,

kernel test robot noticed the following build errors:

[auto build test ERROR on ecc46e02e0abe025a6e840cba2d647f23fd1d721]

url:    https://github.com/intel-lab-lkp/linux/commits/Brendan-Jackman/mm-vmalloc-clarify-why-vmap_range_noflush-might-sleep/20251208-132202
base:   ecc46e02e0abe025a6e840cba2d647f23fd1d721
patch link:    https://lore.kernel.org/r/20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08%40google.com
patch subject: [PATCH] mm/vmalloc: clarify why vmap_range_noflush() might sleep
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20251209/202512090844.OmozcWcI-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251209/202512090844.OmozcWcI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512090844.OmozcWcI-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/vmalloc.c: In function 'vmap_range_noflush':
>> mm/vmalloc.c:308:21: error: 'GFP_PGTABLE_KERNEL' undeclared (first use in this function)
     308 |         might_alloc(GFP_PGTABLE_KERNEL);
         |                     ^~~~~~~~~~~~~~~~~~
   mm/vmalloc.c:308:21: note: each undeclared identifier is reported only once for each function it appears in


vim +/GFP_PGTABLE_KERNEL +308 mm/vmalloc.c

   297	
   298	static int vmap_range_noflush(unsigned long addr, unsigned long end,
   299				phys_addr_t phys_addr, pgprot_t prot,
   300				unsigned int max_page_shift)
   301	{
   302		pgd_t *pgd;
   303		unsigned long start;
   304		unsigned long next;
   305		int err;
   306		pgtbl_mod_mask mask = 0;
   307	
 > 308		might_alloc(GFP_PGTABLE_KERNEL);
   309		BUG_ON(addr >= end);
   310	
   311		start = addr;
   312		pgd = pgd_offset_k(addr);
   313		do {
   314			next = pgd_addr_end(addr, end);
   315			err = vmap_p4d_range(pgd, addr, next, phys_addr, prot,
   316						max_page_shift, &mask);
   317			if (err)
   318				break;
   319		} while (pgd++, phys_addr += (next - addr), addr = next, addr != end);
   320	
   321		if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
   322			arch_sync_kernel_mappings(start, end);
   323	
   324		return err;
   325	}
   326	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

