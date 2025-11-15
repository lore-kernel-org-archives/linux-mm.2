Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38675CEBF73
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 19:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76A108E000A; Sat, 15 Nov 2025 14:17:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742548E0005; Sat, 15 Nov 2025 14:17:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67EBB8E000A; Sat, 15 Nov 2025 14:17:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57FF08E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 14:17:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14C6189B11
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 19:17:50 +0000 (UTC)
X-FDA: 84113801100.19.41EEA52
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf09.hostedemail.com (Postfix) with ESMTP id 08019140002
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 19:17:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FEMpDJc8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763234268; a=rsa-sha256;
	cv=none;
	b=173MdUh6ckUCpEoNTqoFSd1TvvcgEcsMdi0eyJQEz9+1U7kHwR+HfHdV9Vf1ncmplQ1jRa
	n4O6hOxTMfiDZXodlyMswAcwidZgsLyjLtZ7pW/hiwQ6hES7Fmm4jQzc79Rihn4eqV9oLS
	ygXMy+FwQGisG1BLSoX8oRcGBIpDeO8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FEMpDJc8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763234268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iVJifTA1QW4FZQH2ZGslWugBrrBOGanafO4Q56qrwk8=;
	b=O6LlPmAVRuauK9LOJ3abzXL3D/8o715w1HhFUDXlxyqR9PhilSoq0X1v8ZMHDUoEl3SeML
	ZDLlhn6ScfJpsaJKMLcXtUOC7BaLxe3OqTZBD8ecT9DCBFbiA4HHsGwxnd+TdoiMMK2sym
	3aTemjkcaLfebRhDudv4oatHqb2+ne8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763234268; x=1794770268;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=5EG307VFCtyUrsbD42l2t63TXPg+JaL+ztkM4EIoaCs=;
  b=FEMpDJc87PBkv5qipwQcsblRhVR3MHK/XTEMe1+HyV6dPbjcswYFRhZ3
   XNAJIzIXDHYbibqZW6luOqBXCjk068TChTK/360vKiJ3T4iKs6ukhfIWI
   EDLzqFGJz6PDVVi8upbbQWeF1xaIQ/g2ZfR/KT1vmwu/kBDrP+CLvCGQX
   SYK8aZzseWAiPW8guo5aKzzW1ESBVzUQEzmbZh54somUfTOhJukrT7+2t
   9gJHbYpvZ9ik8lpvqKJhrNX+u8hYYpAAiGgM3tEWLG88CfD3xbTmhnuDv
   Ck0dVo3jVZpoefb3dgDTVxr6oR6Tt5rQDPAQaMmuD8PKSX437A3PjhYbO
   A==;
X-CSE-ConnectionGUID: SX0kVxh8QGWKirYznfLfCw==
X-CSE-MsgGUID: +MtBFH9/TBOOXmLsqM9wwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11614"; a="67901336"
X-IronPort-AV: E=Sophos;i="6.19,307,1754982000"; 
   d="scan'208";a="67901336"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2025 11:17:44 -0800
X-CSE-ConnectionGUID: Nz5tmqhLQceFpalXTUx3ew==
X-CSE-MsgGUID: AfoY6s4fTD2IVdZNa6L21w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,307,1754982000"; 
   d="scan'208";a="194194211"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 15 Nov 2025 11:17:42 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vKLmG-0008CT-17;
	Sat, 15 Nov 2025 19:17:40 +0000
Date: Sun, 16 Nov 2025 03:17:17 +0800
From: kernel test robot <lkp@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [akpm-mm:mm-nonmm-unstable 82/133] (.text+0xc00): multiple
 definition of `kho_alloc_preserve'; mm/mm_init.o:(.text+0x0): first defined
 here
Message-ID: <202511160306.rrgfQf5w-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 08019140002
X-Stat-Signature: 1acjos4g59y83i5meeay6eh37xpad4ug
X-HE-Tag: 1763234267-710508
X-HE-Meta: U2FsdGVkX19NRschZTF6LkcVO66/Ba/sBmPsn/T6ksRqlT//Eg0WC87lRYkHFdnGz9n1K+SbJ2hwVzBSl1v+x4U231q119pMzU0CUbRjnnu0XmlnBiSTEmtp/mknxsWRq72IblXEhvwKJ7kLzaNmG1y7VMTskl6Yk0dmSpvddz0PB2BUPVcaqxDOUor3XbHgTJ6lZMz1dl2ss+EeyLrJ8N5XQpYjkPyCGOAjL04ft9y5ZpapLGxEJK3jOqdX6gsYFskhjqn+t2LLZ1e/E0knqDKsBrK7OHhvNmawK9vq34yah+olHPYkQX7GhXmOUz6BbMpJCxV2y2V15QQTllK0vvZemcQfd2B6OGLkVdw/uLZSIVSFeDnzrq5kF9ljQhzu1GPbO7c/FPYnkk5ETBY21llZOhYmumuKCBLX6P8gGfDSrAhm/DtdjL9o+L2x0hBGXuFZ20IsBGjYhKnOp2SwLar51QTGJLS5sjvV2vieouD348GEWDhx23vhVjTS6TVbVa0FkX+mfFbBX6RPVDZb00dzjcB8jAWq+MLTmAx2Nh19k81CoapRSS7Lpjg4HnvTtPB6kxqRfVlYx3PFya+tjY8+tBKWEaVwDREP/UoG8Z+baI5bWVvBgx2tZspY/EvEd70u5mkt/FkDEES1/EMRF+WQW2eMjAWa4v4FtWvavJzfNki0m4JKAEyixTpoY6CMV5JMKABQyTe1IC+pY3XwJCOvijI3AryLpC7s9Z/xIDRaRwz5kIEtkCyokl0s0zxLouSyysbHtvBp7F4HLv887kfa9HHV6YlNibSsVdzDl7pahAAU0YKgf+ievEyGk7ZaRMvku1hXfinLLBGO21AQ/yKCARWjohc6gX56/0RX5PhfRdRS8rBMOJ749+PewO+Iu9yo0/J6T/7oPmVZcntDPLg+417ArlqTTKW9FtKCQHNWwhHXXiJZw0eEsqU4i/aFXTSx+N+qAVA5NFHjug4
 HJljtxMu
 /x7cQVI8sN9OPOWVeG7dO92xr5yX7LsseN2tZWpm5kVXgJa2UN3y6YONreD3PDPhCfyoYcBPOvXFgc7+p9BYcVMzVkrKk43xGm9NPk391eibYxVoBQmtYeGnGSXzwFQ/n2p+zZwKrvYyDG9Gjgvl0RecLBxtX+52t4sm+Ny2TEgkpWCdIuORO51btExXOroc8sA8Aqqsz1nEgyYnzcNaTEgV3faN63ZpBcSQtW6QC8e4DJ4kDY4lOfahLKD2/9kid/3NmXvcS4bpboouGmXv1hIeXDnY4mpiwDWErsNS8s6MxP2vkX0c7PIM7YWEf/3kdzuj6l8+mFKOzYmRGCxz5a5kMlS2xywORjzIWyvunUehEHR93yxWUDi9/vXEqzwj1dOuVt7c5JACc5Mj2QChMpU0zPh4fe5zcXP06
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   4fc88c237bfe11bde443e104428aac56e63a997f
commit: 88316955b5b1b4cb0cb2fad416f7e8dde9b246a0 [82/133] kho: introduce high-level memory allocation API
config: microblaze-allnoconfig (https://download.01.org/0day-ci/archive/20251116/202511160306.rrgfQf5w-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251116/202511160306.rrgfQf5w-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511160306.rrgfQf5w-lkp@intel.com/

All errors (new ones prefixed by >>):

   microblaze-linux-ld: drivers/of/fdt.o: in function `kho_alloc_preserve':
>> (.text+0xc00): multiple definition of `kho_alloc_preserve'; mm/mm_init.o:(.text+0x0): first defined here
   microblaze-linux-ld: drivers/of/fdt.o: in function `kho_unpreserve_free':
>> (.text+0xc08): multiple definition of `kho_unpreserve_free'; mm/mm_init.o:(.text+0x8): first defined here
   microblaze-linux-ld: drivers/of/fdt.o: in function `kho_restore_free':
>> (.text+0xc10): multiple definition of `kho_restore_free'; mm/mm_init.o:(.text+0x10): first defined here

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

