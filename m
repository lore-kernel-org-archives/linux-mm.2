Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF8D8F4368A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 10:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72DF6B00D4; Fri, 17 Apr 2026 06:25:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B238C6B00D5; Fri, 17 Apr 2026 06:25:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39446B00D6; Fri, 17 Apr 2026 06:25:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9077F6B00D4
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:25:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C5EB1B9132
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:25:35 +0000 (UTC)
X-FDA: 84667666230.19.57BFB93
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id E537AC0008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:25:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hJpP1blX;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776421533; a=rsa-sha256;
	cv=none;
	b=eY+cZeIso+VjjvRjSeI7CH1ymorAdQzEgGWwr+7MVFZFl+W4K8t5YaNCzju8ibNqjEWK2P
	TZiunFMViTLxuMGZ6WGtMQV0MhnkrAWudPau+OiQtXhSz8XJ+k60Y1NbKXqEOqGBVp0ZOg
	NRDJfUDV3+l6MtfR6jqwITU02jpVnUc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hJpP1blX;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776421533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=87MVvPKOI+YJ3QT5+EMh0+MGdi0+VWfPJaQNSy0Zh1M=;
	b=4ylWZHq0GqK81mfIGCxs06lNK7s8bKdpQOtk26oTjoZEAHRBYvxYiJKModSm68cvG6IvGf
	8RhOv0C0Bm8tgQcGyNvY95McOuqMtExC5Arm9vU2J36V37ljd2o5syM1BNjo2TyQC+eJXB
	493U911v/XVEWCzkqBDJuSleBNEwmfE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776421532; x=1807957532;
  h=date:from:to:cc:subject:message-id;
  bh=KbwQMBkqcryg36MuPaxvPGHLpmUDJgvPWNaTzRjjV38=;
  b=hJpP1blXSWeDJiiYoUd+ope4eqtmvZsj4ChXYnCaPSyLJUZ25ojIxIxx
   2I53DRysL+kz8KJKD23irJ6g9UHWyLNB7u/jWmTghaS6/RB0EimTNP0or
   Y/rYgH2iswUVbdueoIUW6pa7bq9ZUtBDOFFQ/m1y1XWn53kiW+6LgUJX8
   p4K+atMRetUZUxcz9XIV1V25iowJ2wj40s289bOMNcGgs+3U2OMhHeRJ5
   kXlcxoEtU5m7fUJS0v4blEdxPNAEF/AMUdwIlc8C/IPJ36xbvk/HWl48b
   cNxLtJbcZjulZNG8EFPPdIwG9mmOra2HIdCGb8U9VXWMCDbKrfYF755WO
   w==;
X-CSE-ConnectionGUID: aa73PJkVQXSVKsW0hudrvg==
X-CSE-MsgGUID: SuLBtwxWQBy9fkXXWSJfcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11761"; a="77556058"
X-IronPort-AV: E=Sophos;i="6.23,184,1770624000"; 
   d="scan'208";a="77556058"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 03:25:30 -0700
X-CSE-ConnectionGUID: hJIxlttCSkOXi545/F70AA==
X-CSE-MsgGUID: 9ig81UChRhCF6ekPr94EJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,184,1770624000"; 
   d="scan'208";a="230137833"
Received: from lkp-server01.sh.intel.com (HELO 7e48d0ff8e22) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 17 Apr 2026 03:25:29 -0700
Received: from kbuild by 7e48d0ff8e22 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wDgO5-000000000EX-2uCs;
	Fri, 17 Apr 2026 10:25:25 +0000
Date: Fri, 17 Apr 2026 18:24:44 +0800
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 163/164] mm/bootmem_info.c:58:15: sparse:
 sparse: incorrect type in assignment (different address spaces)
Message-ID: <202604171841.MGvqbmu8-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Stat-Signature: dgrmh4ejb73u7jrpbhwcm4ootquaexge
X-Rspam-User: 
X-Rspamd-Queue-Id: E537AC0008
X-HE-Tag: 1776421531-455350
X-HE-Meta: U2FsdGVkX1/nqroCpAMBrhhLZdE4fG8zZOxT50pLGncoVn9FLSygzm1rYd2/oxFe4+26TlvecoPBy8VMspoLc+bObO8dJJfsgNOnhbL7Cqr2P4zdKNDO9+VTUaguKk1rg9AV+s+m4X2gO9qOqoCKS6LHrLwQkBZ7dEK9Xz2chVptN7MUqEHsK8a3KJ5G/C2z0OfXas8gF5rLLtkL1kmtMh+YMx/DdXzjvlEW4rCPGu3ndTVlvfE7NsLgYhZV9+jEGQQ/iKE7k9cACNDAVxSxIdS8tzAs0WwDJLPIQtwXKyZdRUf+M1n81WigoinJfkuXlOOdMCKQMbxi0AuzF2STRYO5bVJomgY8THFAhjYVd/eg6TRgIwEcCAydJwaAsKFmoYOSFx4fD4whAIdEyvOSN82Y21o08vdGAR4XV/y7Ufbg9Y8oryYH8O9vMiX2rXvWq6UypdnKDC7TYOjlUptnUK+KdWHFHwdt6NLFcwbpBE7loDWCQG/0UIMSD6rj0AguOQ0FUxOllEM0xYcgqpkwy020GnVaEwTTR9FIgBT9zkenqM0A/6RsWu3img28JBxHnS+tbM5vgwNVRsqFyBAxelNiBQsoy/0D+BuVoLJtrAa7UJ08D0Xebq3lPDcQUzGCSWxJwpipy9adZzKPIa7adWOQ4EpBVVBzSiQC+eSU0yj38wy7j4A/3IkzTt0s3pSc1+L2xo92xHwnuNK6QW6v+LoRUYxEfYxafjzE4AJlnVLSzdLJbfhUNzUEC8jDEj0h2OlNsGUa4ZAQqLRYpSI6vECr9sC3ml+k0RICnPkD2NUgiqv55BDGGpud+nfX3C3dR0YbzuuhW/LX14qSUTX4jCNUma9bizinSmizGoCTQ8MhtEdYaR4tiDC7VLVH057Bb/5uD3slydyC3tjUxgZ4t4sW9emRCKpGnOmpU9nfyS0YcPlyPnjPeuCp/htuLVrgIwDva+kPMaf/nYJtyx1
 j7fcSLEN
 XzJYSOBclq2aEj2kfcXYi5HgzEcxn55ynw2xeW8RIVMVYDQbrUz1hNp4/wwXOy/r7tVGEQ4hxO+tD5MQE6lrYIvG8dNnwIe4q4VtUIxQ45+QDXrGkuYNB3QPzr7InVR7vb/LFHp1u2QmLMR69g2XWpYFBkosc80zM9gy+6JVsq0lWW8CV2tBCygazimV18VxV1N1DfSxE6147AxmMW4R7vsJeWnJTytXSB5CTud+LSfFpOQBYh9EOODF3mUzKvon6ZfCu+dvkjU7ucI1MRXXEQvCiyynHRM5SZYjt6v2354E+yKyfARM1RcN6myRs/Rp8V862irXna44ZL/bmwgB8l5ocXpWVtSF6hr+k515TtaMLVcUs1mGeyuoBsmV8zKwnCHJqY3NWl/Aua6jO+f9sKGQAhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   ee03ca7d1cb1223d0e14dfd3b48478545af75253
commit: 8568f268a5183e0fd5fbd33569b6513038b62f27 [163/164] mm/sparse: fix race on mem_section->usage in pfn walkers
config: x86_64-randconfig-r131-20260417 (https://download.01.org/0day-ci/archive/20260417/202604171841.MGvqbmu8-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260417/202604171841.MGvqbmu8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604171841.MGvqbmu8-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/bootmem_info.c:58:15: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct mem_section_usage *usage @@     got struct mem_section_usage [noderef] __rcu *usage @@
   mm/bootmem_info.c:58:15: sparse:     expected struct mem_section_usage *usage
   mm/bootmem_info.c:58:15: sparse:     got struct mem_section_usage [noderef] __rcu *usage

vim +58 mm/bootmem_info.c

426e5c429d16e4c Muchun Song             2021-06-30  42  
cdcfc631c80e716 Muchun Song             2021-09-02  43  static void __init register_page_bootmem_info_section(unsigned long start_pfn)
426e5c429d16e4c Muchun Song             2021-06-30  44  {
426e5c429d16e4c Muchun Song             2021-06-30  45  	unsigned long mapsize, section_nr, i;
426e5c429d16e4c Muchun Song             2021-06-30  46  	struct mem_section *ms;
426e5c429d16e4c Muchun Song             2021-06-30  47  	struct mem_section_usage *usage;
7f8e592bb3271ea David Hildenbrand (Arm  2026-03-20  48) 	struct page *page;
426e5c429d16e4c Muchun Song             2021-06-30  49  
7f8e592bb3271ea David Hildenbrand (Arm  2026-03-20  50) 	start_pfn = SECTION_ALIGN_DOWN(start_pfn);
426e5c429d16e4c Muchun Song             2021-06-30  51  	section_nr = pfn_to_section_nr(start_pfn);
426e5c429d16e4c Muchun Song             2021-06-30  52  	ms = __nr_to_section(section_nr);
426e5c429d16e4c Muchun Song             2021-06-30  53  
d65917c42373f70 Frank van der Linden    2025-02-28  54  	if (!preinited_vmemmap_section(ms))
7f8e592bb3271ea David Hildenbrand (Arm  2026-03-20  55) 		register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
d65917c42373f70 Frank van der Linden    2025-02-28  56  					     PAGES_PER_SECTION);
426e5c429d16e4c Muchun Song             2021-06-30  57  
426e5c429d16e4c Muchun Song             2021-06-30 @58  	usage = ms->usage;
426e5c429d16e4c Muchun Song             2021-06-30  59  	page = virt_to_page(usage);
426e5c429d16e4c Muchun Song             2021-06-30  60  
426e5c429d16e4c Muchun Song             2021-06-30  61  	mapsize = PAGE_ALIGN(mem_section_usage_size()) >> PAGE_SHIFT;
426e5c429d16e4c Muchun Song             2021-06-30  62  
426e5c429d16e4c Muchun Song             2021-06-30  63  	for (i = 0; i < mapsize; i++, page++)
426e5c429d16e4c Muchun Song             2021-06-30  64  		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
426e5c429d16e4c Muchun Song             2021-06-30  65  }
426e5c429d16e4c Muchun Song             2021-06-30  66  

:::::: The code at line 58 was first introduced by commit
:::::: 426e5c429d16e4cd5ded46e21ff8e939bf8abd0f mm: memory_hotplug: factor out bootmem core functions to bootmem_info.c

:::::: TO: Muchun Song <songmuchun@bytedance.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

