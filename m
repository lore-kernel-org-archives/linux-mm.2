Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7ACDD3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49DB56B0005; Mon,  8 Dec 2025 20:53:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F326B0007; Mon,  8 Dec 2025 20:53:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3644E6B0008; Mon,  8 Dec 2025 20:53:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 239256B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:53:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4394C036C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:53:01 +0000 (UTC)
X-FDA: 84198259362.11.1AEC88F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf13.hostedemail.com (Postfix) with ESMTP id A2E0D2000D
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:52:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="R/r7HFlI";
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765245179; a=rsa-sha256;
	cv=none;
	b=ymVUyiFokhc+Qf+DHA/eX5t8CBjJZJ3Opwk15V35EtmQTxhuWScN+6k0qrm6d7ETio+Ppd
	uWBNzqkbc4/ix+SqhCzq08wC8qg7QHvUgC1Xuxwg76MMUDxu67WyLmSwea1acnHTqAYV6v
	tBfJkNJhLTyu1vGz+NH9d9y9y6k264Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="R/r7HFlI";
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765245179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tuDPPlix0docxJrP7gni/PZtpUQNQMtVDouizGPh/Qk=;
	b=3YL3dZltLEvJQAipvrilrwRrDrJKNCt/ccr5XLTz4/X8iKo49n2AStyU0M+XKf2zQwtZ5j
	Xgpar5pFkJo0p5/NVguEgTgOpbgY36/RFn3RNznSzyA3lyL7FjZFNJMYhr846hYGWweles
	VSHHtLLj1O0pDI3dFeWvbLXzo1UycVE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765245179; x=1796781179;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ey9K4onyQ6f8kRj6L7zyp5HQ9JpLyn+tNZX7DiZPVB4=;
  b=R/r7HFlIdMTVU4gMZnNNGd3lItS3EZEzOpp4Va6e31sa2hLJetbIn9tJ
   Oym9iXuM6VrG70KTwdHkDuyqNuXqPIoQoazozBn7lD7MPIe5TgxHAQ7Dd
   1xxeaD+iNtOFCA7uR07yai8VRSceFaI6ZYUnrubd1B6ezXYFwzfSdmGvV
   L/G+UUGiRN3RFz1/hxE3dwAPRPq/0Lw9GpBFUJ7uLQxI5PJlnm1TH5mUV
   FRXWJ3OcsxWzo1vbK75pci+DoBOj4mvVIQRnFq3QyHBF9dPtTIzrcP1Tn
   DTAALdt1NsUblzWGt1oeTgN0P857Znk4FSj6NbGCc11N/dKgxkeuFsDuG
   A==;
X-CSE-ConnectionGUID: CtaiVSFGSGCK+XoNOb3tvw==
X-CSE-MsgGUID: nT8DvJ7iRoqLEBGRBU3X8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="67081859"
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="67081859"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 17:52:57 -0800
X-CSE-ConnectionGUID: NmFLdEa4RSSSF9mDwljs4w==
X-CSE-MsgGUID: 3LPMO/wqQvKJ5OnTwt0Fog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,260,1758610800"; 
   d="scan'208";a="200537413"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 08 Dec 2025 17:52:55 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSmuL-000000001AQ-09RK;
	Tue, 09 Dec 2025 01:52:53 +0000
Date: Tue, 9 Dec 2025 09:52:11 +0800
From: kernel test robot <lkp@intel.com>
To: Brendan Jackman <jackmanb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH] mm/vmalloc: clarify why vmap_range_noflush() might sleep
Message-ID: <202512090959.BWqYaOOg-lkp@intel.com>
References: <20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com>
X-Rspamd-Queue-Id: A2E0D2000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 4z97145hkz5xtgmkixm379homjokc6u9
X-HE-Tag: 1765245178-398168
X-HE-Meta: U2FsdGVkX1/38aQt0l03a1FWdONNVPkTuzcgRfbv9NlLqcwSmKSrF1qAnNzmO0jHBmwoPyNzOqSAL17QA3pcnuinuxfJTgWmJAcho2daoLS8WMdFTFodgD1LJAiuagNYXwrUTLmzFpBBtedM7d3PFBRfE050hF82PNlwQRoWDAcDdxo5wYGcDzMnLmb/DlyuPfZJGqwA9jDQXu8TCrT3I8/Y5b0B1XBHWO7yN9Hz96/2qzvtITHosNh56PJ21tCM9Y5VrDujBhWwghLMKeOvsDV6Q8bUTYuTN6EIp86y6zEdlx5al1QTnuG2a/Y4z9mYM9qby+kVVmpHA89SUAkJ+ceVa37TwzFRW+ZDY5nERS0z0bvUSSkUeBsporCy7L8KOBee1yJdV2wxGdg4KJAmgSQsr0DnYDXFSxzDB8Q7uiPR/AoctJFwqdsSLtBm+MvZH51eYuKc4rfdDK2OipDnD4k2ItJSxTs2WhQjSqco6mCoHfpKhCrhoVCIQ4NF95gF8Xu6giCYjVrwk14jljTiB6iNnuhJKgufPKYOo/f6P3m2y8AjOS/WKjazzBeBrpDJPB310BQTFv7L8ahdSgRsektiO0Rp0GlaJFGPUkqr7cKTDVZngFlCZGlmVrrcc/P9EBTvic5+/osxe+CLoA7rFffbANoyG3H/GLEqNpACdI6RjqYZO4gZf9oP29S48yQ7GewdDLWWHv9SrLIX337wcJLNKkl/3rdii74PHPGH33mUTQod8Lr4LwPQbkAdOlNYcqNkW2L6v0nzwlYTcv5kOqbTwi2x1xkb3gb0YQeiLgFfLVsfoTCInR0RJC39jpxOhQf8sCA/A/I2414AEVhxTkac5Rbuot3Tl3OGVMbRT6CVwsYDHJ6+ohdJu8p0w5yel2bw4rhJ0UF4dGIyUz1tj6n/WbKM/b/ZNuvX1LPqEyrY6yPVHTrq1T8hr1rUoeYOrvyugPCCNQ+Ygk8OE4V
 9TxvC4aA
 kSIeL7S0gyW0MsdpltcVbjWitNUZvfRMa/PRoMaz0aSQOwkuqqYydsodm2/psXbR6cV46ytw3vi0+4YS9iklKtd2pLZi6/So1MAuA3lsvFBN8SNTApeqM5Izxt1neiQEUVtAJsPfIJfnRBd9k/ZDSm6jb0gyL5fGOw2363m2ASDTlA0AEa+pIIFHsQ1mZegrHufJCQJTh9c1DF8FoClomE2DGAbjGw5AmM9ERdv7+3ypJqsYw4p4q5ISukLdEH3bGGg2mEwgbrffjkxgd/bnEJyWHG01Yh7gcJ8JiH/D/eQ4Ji0l9u+kJHxcRLGtvY/M07jR7yfikhXxjOrKDm1zKfapPpw8wZNS4FTWrEOnZEH5SzdfHc1qRItrEEKyVZe6Whwppb6rqm5mcYiA=
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
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20251209/202512090959.BWqYaOOg-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251209/202512090959.BWqYaOOg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512090959.BWqYaOOg-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/vmalloc.c:308:14: error: use of undeclared identifier 'GFP_PGTABLE_KERNEL'
     308 |         might_alloc(GFP_PGTABLE_KERNEL);
         |                     ^
   1 error generated.


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

