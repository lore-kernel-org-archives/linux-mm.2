Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F392F532EA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015DD6B0089; Tue, 24 Mar 2026 04:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F082E6B008C; Tue, 24 Mar 2026 04:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC256B0089; Tue, 24 Mar 2026 04:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBDFE6B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:00:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D96F5F8AB
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:00:46 +0000 (UTC)
X-FDA: 84580210092.22.1C0821D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf11.hostedemail.com (Postfix) with ESMTP id BE69340012
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:00:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CutYbLr1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774339244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hO3RoDkfaX40pOPnDHKWF3PTrk31AlPWS01n3tsNc4s=;
	b=VFY9awyhlXAnQuxapdZmIhqhIi2owwqxqsD/4lek1aUnidxooB1abTFlEFXwV7TE24EUh8
	7b3Jq8KhBcQocX3N1Ka1Y0DhdFvYlTbJA12k++bTLk209gDvZ//F5SavpRCmQuisgW6OZ8
	cwj0DZZ9uQMIAoFhJlks0sGhTMwv+eA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774339244; a=rsa-sha256;
	cv=none;
	b=vYLWJmRPH3hGVU0jfO0WZXeBBU3Wqg+LeDFZaRKt/CahpbHNeujUzwi1636sT7rx0jmao6
	0PtiSIPs5q/kG/4Cs6Xoqzf4ICKN1ARgSYfCnco8TujshEthrre6bF+PGFiBuQuxeQBSto
	EFAbyFGADSMfNOPpt52ORViDo2EXwZA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CutYbLr1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774339244; x=1805875244;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ocoi7pvGmuvDZoSOfl5t4+tndabVbyrA9wr21MqUqZY=;
  b=CutYbLr1YUu0SJ9QRshYpp4CJBhtpxG/37PhFDhJRfcoav70Yy6NZ/ZN
   W10mDixiR8GdT25mccG+t4YBNCc+caqclvqDOE+OCwTh1zrjGw9sydGTN
   g7NMFVKYpPvRuNxgKysZpNGMStF8n5NkZH1UILNMANDYfQLrSU5Sqcjjf
   lKj4/PsL7I4FArVntAIWxOOm6RZiJS+3geSbpgLpGrL5BTnceknMfpWbM
   bTTrearfMM3NpZ+veBn5SbuguLG2bTFM0lA55K+P5cw0iG0SnBCq0dSUR
   W1XYLGX9TSJxKBWGcHZ3zVu94byOw39wSr5SrlCYsg9RS+v83xEh4SdBB
   w==;
X-CSE-ConnectionGUID: RRnsB8GEQiSw9Yz5DTUoTg==
X-CSE-MsgGUID: /rldCINHTo+2K4qPx7MMpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="75060891"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="75060891"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 01:00:42 -0700
X-CSE-ConnectionGUID: fFzXhO+xS3SDWPlVar7ADQ==
X-CSE-MsgGUID: Udc32wB4RE6CAt6sSsNiWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="262202678"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 24 Mar 2026 01:00:35 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w4wgh-000000004CD-2iTp;
	Tue, 24 Mar 2026 08:00:31 +0000
Date: Tue, 24 Mar 2026 16:00:13 +0800
From: kernel test robot <lkp@intel.com>
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, x86@kernel.org, rppt@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com,
	reijiw@google.com, Will Deacon <will@kernel.org>,
	rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v2 07/22] mm: KUnit tests for the mermap
Message-ID: <202603241512.3kG43FzT-lkp@intel.com>
References: <20260320-page_alloc-unmapped-v2-7-28bf1bd54f41@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320-page_alloc-unmapped-v2-7-28bf1bd54f41@google.com>
X-Rspamd-Queue-Id: BE69340012
X-Stat-Signature: hr3w8f5caog15p19bfysg15rm49o7u6r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774339243-54283
X-HE-Meta: U2FsdGVkX1+z9go5U++P5JlG9FaZPJHneM81XjAhYXKD7c9yqYx4ElOuQMpPUkGXF6D5ARQz8uK0kTXp/OPRku+9B1keMQIKLYlRG04IDH05N4tFMH8KZWlZG2NEZLA6/K6F9NdLyFpUiHp4Iu7+Mh2EdDqNQ8NJd4NYpQARomXWrZf2OBz20Kr3FQf5HdAxiuCyBm0L1KoeN1nM5OzpqWSZuBsb5uQRzEW4u6GTTPKPaJesxoD1DhTON49wEYe9HGRIwH2GxhR+2QjiQe7zlnZ3PGBF6uYQcEk48SUjpAHNemjhdk8Vi6kRLgBXB3UjS2+pC0sfs7hxtKuJP4GPiKu1lc3uUFroKb9kRmFanPJ28R2YyxBvLapcRRQTWQuARVt5d1DV/1IFk5++AND46NXfhMxor9A3QHxUkJ8BgWjUr3RGhI755vcZmbvPOZrHzkq+owABSqxJg1xsMI8Z2rkovqcbE0o5HhdUnOfmS+rbzn7DQMSTJQKJ9FKONSp3G4JpJP6jrDF5mVcHfQ8LI2RiX3toeb95WhUcsG5qMEEQ1ZwY3y2g4cB3tctRWGUIzOmQbqDMWnxvQyiOu5Igc9rCADlB9GBXSjAS/0n89zLftmDoMEVxP/G7p5fRGnPWb2U2lDzQHibBr8g1fFcJ2e6yNtpLF2a1TMQALldPFs2JyMIqcvLUcbItfZGXgMEqC4z6b+iCeDAlMpugP6Vpdnv1uqJcY9LhvCy5gLX2jfTYpt1XFExz7ng6g4oLAoWIKyaDdbq+0XDgCxQC4jalk7NYOclPQrWZILbcxY5frKZfy8eZJ4/vE4gZdLPN3hVVyBGNfihj9op7zfUYd3ONmStNDghYzMGgU7LaY/HuDZWsb+df1DARidTqpKHTxo4iGS1UlsSHkV0rt6FwDbc5CidSR6aWwwIXW2wbaWojR6Hzb04g8/MfrtYEiuAS6sOcqYeNybKwWYQpsHyXtjL
 Hi/eJ0xn
 cujT3apt85Ys2mgpeBH/UyGKe2Vt+QiukOuDzdIt7Q2QVhbFGzN3c0T228cj9cRjIj/aSr9xU97RTFutGHyooionkbyt2FGAdBsJN6+Rqicov5CMziW592pAnHOFriLMMKZRkYA8dw3nQ3Jlp3jpDIBDB7lleEBWI2uvuUDdz1Z7y278srQX6xcNJo0atvCs9sspMAvHRqZJijjbKOo+1knWNNii4+GmvOW13G+hSFiiYCZRI1itY+NsvNHlA6beHFGFdXn6pLZa+/DpIYGXEvpuJ4oPVRp0bOONrk9mvpGEZPCaxzpleysa8iz257KVgGc9urxQM/fdSSAA/CbCoBstr8WCwj4kvNrbJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on b5d083a3ed1e2798396d5e491432e887da8d4a06]

url:    https://github.com/intel-lab-lkp/linux/commits/Brendan-Jackman/x86-mm-split-out-preallocate_sub_pgd/20260321-042521
base:   b5d083a3ed1e2798396d5e491432e887da8d4a06
patch link:    https://lore.kernel.org/r/20260320-page_alloc-unmapped-v2-7-28bf1bd54f41%40google.com
patch subject: [PATCH v2 07/22] mm: KUnit tests for the mermap
config: x86_64-randconfig-101-20260324 (https://download.01.org/0day-ci/archive/20260324/202603241512.3kG43FzT-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603241512.3kG43FzT-lkp@intel.com/

cocci warnings: (new ones prefixed by >>)
>> mm/tests/mermap_kunit.c:156:2-3: Unneeded semicolon

vim +156 mm/tests/mermap_kunit.c

   131	
   132	static void test_multiple_allocs(struct kunit *test)
   133	{
   134		struct __mermap_put_args *argss[NR_NORMAL_ALLOCS] = { };
   135		struct page *pages[NR_NORMAL_ALLOCS + 1];
   136		struct mermap_alloc *reserved_alloc;
   137		struct mm_struct *mm = get_mm(test);
   138		int magic = 0xE4A4;
   139	
   140		for (int i = 0; i < ARRAY_SIZE(pages); i++) {
   141			pages[i] = alloc_page_wrapper(test, GFP_KERNEL);
   142			WRITE_ONCE(*(int *)page_to_virt(pages[i]), magic + i);
   143		}
   144	
   145		for (int i = 0; i < ARRAY_SIZE(argss); i++) {
   146			unsigned long base = mermap_cpu_base(raw_smp_processor_id());
   147			unsigned long end = mermap_cpu_end(raw_smp_processor_id());
   148			unsigned long addr;
   149	
   150			argss[i] = __mermap_get_wrapper(test, mm, pages[i], PAGE_SIZE, PAGE_KERNEL);
   151			KUNIT_ASSERT_NOT_NULL_MSG(test, argss[i], "alloc %d failed", i);
   152	
   153			addr = (unsigned long) mermap_addr(argss[i]->alloc);
   154			KUNIT_EXPECT_GE_MSG(test, addr, base, "alloc %d out of range", i);
   155			KUNIT_EXPECT_LT_MSG(test, addr, end, "alloc %d out of range", i);
 > 156		};
   157	
   158		/*
   159		 * Read through the mappings to try and detect if they point to the
   160		 * pages we wrote earlier.
   161		 */
   162		kthread_use_mm(mm);
   163		for (int i = 0; i < ARRAY_SIZE(pages) - 1; i++) {
   164			int *ptr  = (int *)mermap_addr(argss[i]->alloc);
   165	
   166			KUNIT_EXPECT_EQ(test, *ptr, magic + i);
   167		}
   168	
   169		/* Run out of alloc structures, only reserved allocs should succeed now. */
   170		KUNIT_ASSERT_NULL(test, __mermap_get(mm, pages[NR_NORMAL_ALLOCS],
   171						     PAGE_SIZE, PAGE_KERNEL, false));
   172		preempt_disable();
   173		reserved_alloc = __mermap_get(mm, pages[NR_NORMAL_ALLOCS],
   174					      PAGE_SIZE, PAGE_KERNEL, true);
   175		KUNIT_EXPECT_NOT_NULL(test, reserved_alloc);
   176		/* Also check if this mapping seems correct*/
   177		if (reserved_alloc) {
   178			int *ptr  = (int *)mermap_addr(reserved_alloc);
   179	
   180			KUNIT_EXPECT_EQ(test, *ptr, magic + NR_NORMAL_ALLOCS);
   181	
   182			mermap_put(reserved_alloc);
   183		}
   184		preempt_enable();
   185	
   186		kthread_unuse_mm(mm);
   187	}
   188	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

