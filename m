Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA9A2CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 14:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 167C08E014C; Tue,  4 Nov 2025 09:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1187F8E0124; Tue,  4 Nov 2025 09:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0558F8E014C; Tue,  4 Nov 2025 09:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E77438E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:51:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 973EB140538
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:51:57 +0000 (UTC)
X-FDA: 84073214274.22.37DCD98
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf09.hostedemail.com (Postfix) with ESMTP id B06A0140003
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:51:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dVr6ATZE;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762267915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BHyeBfxdc6JRXDqgZ+1/A4rOE0EHFP7qyekP+VuH0RM=;
	b=XSkKp/J5fisVjLBApLFkMsPvO5RGVRr6A/jnpZ+SlLdjgOnsdOLAM+N4EU5/UCyMbFAefi
	7UH5vHlKI3ofZfbzcT2/JejXodIwOAfpBn1RCu6SDlJfFrc+8o6J8W5VzKCFQ+0qS/RJ+o
	zc7Mi2u7VBG02vtXIiPQryC7hKpKZ9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762267915; a=rsa-sha256;
	cv=none;
	b=Zm2ALobPT5X8VZC+bFlvOxPr0xroIABTPMs9lC2KWhdfXT7CBySJqGTt4TJ4bDhiSsAruF
	Ph73yQcuYwhqEDThkEei+7I71tLiLtc1N6ZvP3Y2b1YcQHvTNZ08241sRotO4gYZoeo5HE
	pec55PtEGC8wXgVYfihC2dSbUZ58wRs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dVr6ATZE;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762267915; x=1793803915;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=P/HlHjCiyP8djl/YsJTrzZ+Ot6NggdaEPCcyndLWpOY=;
  b=dVr6ATZEeYWt1p08FbULO8bOy5UiW0Ke8v0T25PQsh14RwO4fvB0nTHt
   OETz2SDk0NCIEFqc0ze2uicvwa4kk+incggrA1ypj7hpMBlolsRYo5Vwl
   nnQaphQhqCf3nNyS0dg4Yu0RFTxPknhD9moqluMTm26J5DT3uuKk+jn1T
   P4PD7v5TYIi324Rtxs3HNRWX78rsKi1PEiTZzA3GECeXWbsMzd8C7NLgB
   OslX5XUtYUeQCqh3Q4LNhHBT3/LgvbadHVF0anZMS44xLdzk52el/ITf6
   HCAT+XZDHh3iPScvAK2/Xe/xqmA+5tVbaOHEM7cNnC+PFH/AWS5C8wHA2
   Q==;
X-CSE-ConnectionGUID: ZFxPqBBORSuETfIuMfgqjQ==
X-CSE-MsgGUID: YRGVc4yfQnuJ7AoD831+NQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="51933342"
X-IronPort-AV: E=Sophos;i="6.19,279,1754982000"; 
   d="scan'208";a="51933342"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 06:51:54 -0800
X-CSE-ConnectionGUID: tnqYtCWNTsOF1XeIP41pWQ==
X-CSE-MsgGUID: ekfRqJRhQZKEz6/up32sYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,279,1754982000"; 
   d="scan'208";a="186416255"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 04 Nov 2025 06:51:52 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vGIN9-000RVX-21;
	Tue, 04 Nov 2025 14:51:17 +0000
Date: Tue, 4 Nov 2025 22:48:31 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 4972/5926] kernel/kexec_handover_debug.c:16:18:
 error: use of undeclared identifier 'kho_scratch_cnt'
Message-ID: <202511042251.paO6f5BZ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B06A0140003
X-Stat-Signature: fmhm89b7xui6xjnpstc6b164fx74rq4i
X-Rspam-User: 
X-HE-Tag: 1762267914-142942
X-HE-Meta: U2FsdGVkX1//3t4NYOaTE6Gecl3HlD9AnjX5UD+7EocLrcITGNH3+gH4+cUMk2bFB9syBd4Q5fpf1ZI/FGMXRcEdsa+qOUX8NsIYg2U9Ogx1l9uBgckpxRu94asI9y2aI+TADOm2hJ0QgsLyqVIUHK+oAf6YTbBy/4OGEwfs6gGoZfIggprTXWbZ2sQ3P3UhIbTixSXyXZhYzmbH0F50gVdtgd7xqa71yBEb92/VK8/0K/peOzi7SlOaeJar6BDt/3RPkzxz81nDahR4LPjYuq9BypArhe/EX3eYHtnMxIlLxadQdbuSmsk+gJSRd2hs8NJ/RITLN/hqwSpGmnhi9x260RRzuCmRo31pqZo1QdTNMZvRxdCvkdY7dzX8s/4JFn1BFF3NOQE6pPyqWjDEjIqS+G7younKM1Qt37uagvJ+GZP1m0QcSRJBkBF6+f5ZdGyf6yWYw83dbiQVHl3xTdazrqq0xXousRGdOEG7S+l1AGIGY8VVlNjeisnxz8JWElDXoNH7+iFFk2e9A2L6GYttv9mDn+zC4FwRCDrfxBm2NlbI697GLs4BAMjR0XXqM+19GLmwJLV9yQosFYGUFCauISIrG6iwZSj6LCsdiPgvcgj4nnzD6x3ezX4HR6lda8NrMEv95uaObzuBkGh26uPuzHdyiM5Lc0ZNhlQ3b7dWQWqXB2IMqi4m1dJ41xX43QsRwEDES9MgbyeGJOUEpZbd0Td8T5d7UT3mLqBk04sLyULcQIItkeC/huT++Q1DHVlxxQIRRqOuqj6Zmvh/ffKQC50JtuMrCMLmg9NOFHD60IWn8u6O6Wu7yJ8wLY72DaSUoyzqlpopjrVOgk0/ZidleMNeftjq8+6wb9hnmWxGwkcukD+ucHd7B2eJb51JlqwdSFbORrb4AiqR9WFMF/HogAecGIgI7FcfswkXfPSkc7SJgOiJpeFfj64YqMJXqObhbNsvZqj9In6Bz++
 8PWegEZY
 11cCLTHib+0pRleDBQlIlDVXhm/re8uMlIux5PFlL8zejmfyfVM71+UPfFXOCG9wc6WMvZ6N3IhZi0juhNaOeG0RLj4rB9K2RfvfBPoGuBYDgP9kV8V9sZELtghabR8BfdBkGMp+UZ4ZJpyZrhAVmJDT+c9fSyvNzguRsPuVtY7n4C2sj1LO6OgQsbUnMlARzExozqsQbQYMBE5+frRGXqXV3CWmv06jGl0YP7Cgc25+a2DAViPA/mYdxA6u71raVgPCZpRkwITl+KBPf0NUSZrCZmL7RS0ESlkADq0KH/n68yjGyfhwV859AnNK2m7Vs7CN4ACitITxEIg9djaAAIgeJupnSu3XdfU2D03O+5/K8iOAgMV7VkP9sWpMU03pZh35EjpXfCvSjYrn5fPQvS0X4SL7dLLXRKEK4rproGhGHg5zXj3CdZ1nUOt50rewZnDMg4OZpyloJioQW42fwFZdx5a6ZnHDKmu8YweyVMfzFk311nwUjnXA+dA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

First bad commit (maybe != root cause):

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   17490bd0527f59d841168457b245581f314b5fa0
commit: 8c211175c3abcebb8bffce8095d78d193e482105 [4972/5926] liveupdate-kho-warn-and-fail-on-metadata-or-preserved-memory-in-scratch-area-fix
config: x86_64-randconfig-071-20251104 (https://download.01.org/0day-ci/archive/20251104/202511042251.paO6f5BZ-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251104/202511042251.paO6f5BZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511042251.paO6f5BZ-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/kexec_handover_debug.c:16:18: error: use of undeclared identifier 'kho_scratch_cnt'
      16 |         for (i = 0; i < kho_scratch_cnt; i++) {
         |                         ^
>> kernel/kexec_handover_debug.c:17:19: error: use of undeclared identifier 'kho_scratch'
      17 |                 scratch_start = kho_scratch[i].addr;
         |                                 ^
   kernel/kexec_handover_debug.c:18:17: error: use of undeclared identifier 'kho_scratch'
      18 |                 scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
         |                               ^
   kernel/kexec_handover_debug.c:18:39: error: use of undeclared identifier 'kho_scratch'
      18 |                 scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
         |                                                     ^
   4 errors generated.


vim +/kho_scratch_cnt +16 kernel/kexec_handover_debug.c

4039a00022d42a Pasha Tatashin 2025-10-20  10  
4039a00022d42a Pasha Tatashin 2025-10-20  11  bool kho_scratch_overlap(phys_addr_t phys, size_t size)
4039a00022d42a Pasha Tatashin 2025-10-20  12  {
4039a00022d42a Pasha Tatashin 2025-10-20  13  	phys_addr_t scratch_start, scratch_end;
4039a00022d42a Pasha Tatashin 2025-10-20  14  	unsigned int i;
4039a00022d42a Pasha Tatashin 2025-10-20  15  
4039a00022d42a Pasha Tatashin 2025-10-20 @16  	for (i = 0; i < kho_scratch_cnt; i++) {
4039a00022d42a Pasha Tatashin 2025-10-20 @17  		scratch_start = kho_scratch[i].addr;

:::::: The code at line 16 was first introduced by commit
:::::: 4039a00022d42ac3d68b2eea63066bc9f7ef89ce kho: warn and fail on metadata or preserved memory in scratch area

:::::: TO: Pasha Tatashin <pasha.tatashin@soleen.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

