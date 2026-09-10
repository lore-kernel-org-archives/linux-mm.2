Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96293C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F1A6B0093; Thu, 10 Sep 2026 11:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A191F6B0095; Thu, 10 Sep 2026 11:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BB3B6B009D; Thu, 10 Sep 2026 11:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59D7E6B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:43:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8EA6A4054B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:43:37 +0000 (UTC)
X-FDA: 85198272474.03.36BF24E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id 017371A0008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:43:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VBh8Kpvs;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789055015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=VDOVVB5CNr+xg15Na5MO4618UEr9cHEAoszSeH02DBA=;
	b=k9Mm5U4iLYFfUq0yFkGjOqOUovuUQAo2YJQ6LyP22K0kTkKYATwaEd9y4Xd61p75pWCg+6
	GZTKwA4q97fWQlhUcjSXkzCkrA+HjzUbV+kbmsTDlH/esO4eEFAmBUmE/lxzILxh4YYjfW
	uhXuFk0MjfFOYSJbin/BiY/xLC8u5mc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VBh8Kpvs;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789055015;
	b=wrk4BtQtq3cvqgpSKY15ja2f6zvUemHnDWqVqmFS6k4OPSp3laF3KF0O2XWwoNjMnT4JKZ
	5fgXIC7CZVUUQNpP/l26NKqu2YkaUstzNhQcI51vER3ufytOv51VfIo1P8ZZ5LDujHkG6Y
	Y0pXDePygMRkRatljVWsJ9k097Iw6U8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789055015; x=1820591015;
  h=date:from:to:cc:subject:message-id;
  bh=6GIudFi2xB6F7F625x6Q63Mq2VADyI7amV8nbpSxR5U=;
  b=VBh8Kpvsahl8j34QCQr8SMj1rokb7TP0JbnARGTgEkXtNr7mufpAuk0P
   H/i/3OEec238LSWtU5gec7Z1gY97SHdbAR3Rd0wQSv5U3K9bVd2KfiAQJ
   q2DBSkDUS6MYlw+emC0bIzKBB+o/kSiPVU/kJFEWQ7yed0eF/DgqQ6tK/
   YhHZstDmEXE8I7i5uEmqT49yDynCe9vPDxwcKJ80b+mpdyFkynVDDYBbm
   APJuhrm4trLt4BQT2cln9G+XF8O6wT/tnz6W9nIhf61U2QVBTW9mPFNv6
   wICoKCzQ4ib9jf49fzOLxX5pN/xL9WH33R92CgJprRAWqVD/n9M8MAB+N
   A==;
X-CSE-ConnectionGUID: w9mm0tWxQg2U+9L6o6nqlw==
X-CSE-MsgGUID: j7Djjbe8QYuT73DBXim62A==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="93200689"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="93200689"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 08:43:34 -0700
X-CSE-ConnectionGUID: kYXD/zrRSxKD/vvnb7n25Q==
X-CSE-MsgGUID: Y6oTUiczTF+oLhwURJ6dgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="301572128"
Received: from igk-lkp-server01.igk.intel.com (HELO 2232cf45ba3c) ([10.211.93.152])
  by orviesa002.jf.intel.com with ESMTP; 10 Sep 2026 08:43:31 -0700
Received: from kbuild by 2232cf45ba3c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4gvx-000000000RF-38b6;
	Thu, 10 Sep 2026 15:43:29 +0000
Date: Thu, 10 Sep 2026 17:42:34 +0200
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 360/388]
 arch/powerpc/mm/book3s64/radix_pgtable.c:1274:53: error: implicit declaration
 of function 'device_zone'; did you mean 'device_move'?
Message-ID: <202609100959.X16FvH9R-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 017371A0008
X-Stat-Signature: cdktqy1sh4f5ijx5pgpyieeniix6ycph
X-Rspam-User: 
X-HE-Tag: 1789055014-27868
X-HE-Meta: U2FsdGVkX1/+IoInqwC+MTUyWd0iL4unnbvJjJ5bDIHNB37gyz1bJas33P8Y8NXHmVMe3EWmRUYVCId6jh39RPCY/Rh18ANv97JfY28g4eH30wcSM8mc9mAcwNvLWUY+TXKCTCzP6k5o6hFchmHFnQUoSwl2ZqqtnFZtKg84GTPlyNtHCjX+3X6yo/JV+2laBMKnsZ9kt/OhU93XjqNvP8lRl8Sr3BAK5mI2MMw3JG2Rr+MhevqhZCM3bSS4V4TX3fqChIWGDf0epZpq1u74tAJS4wiMzwtbYIvsPvBGwxAj8o1mNzR/+1a+t8eljdIV+FvsqhNOsZByGLRKzM+cUxAA8SU1ihYbaBjE3a3qvQWeL0DIgCGBr6Yk7eRXLOnEnazv7Se4pvRmz1nLy7xlP4XEkpoHhrZ9pKweZmQA6KdAMzUxL0qofIs0ezcEm93kt3EnubNBUm2ax9OhbX8TpwY+kxJyHHL0HLpXdMcdOfejjtbkEf/GkHBEgae27edLMUroCbsjFsQb38+a8xz0ipZWEGfe1CnrOxjJbOzRU5RIux7jZ0PKnp5Epi+wAZJcGe+DszrFB2zurtMISRV4/tpKmeHsRy65l2AbKPchFWW5no4Zl2JlO4ZsoWTozmiu2Wjtrlwhi7EzMdskwQrn7N8caBkRUNZenVl/4p1BYUPgF0z4cfub127WmRSf+Ci7qhx3m0C8quSI8RN6p5YT5XWJiPaUhW5qatua3tlnJZTBOV4UyOvCcdaHH7UytTppmv4uGlD2RV+t3xUZYMGnpkwoiinE3WddAEvB7/vaDX/G8KEmaEoc203oHfUKTedsqG/igm3BvQmVwVJjfOLphSvgoanirj/kHIn0DrA6eNFNTgc2vdtsbd7u0HchMyhFTpGFTSR8EE+SWJoQrkAswaeIOekIbt5Uq3GhgC6AKw46MzaoDjurY5/SL/cBR5lxJ4YSTH704i5DkRREkO4
 iRs03Gxw
 834c/ei7pfe7lRD13WK3nTjy7eMlt9+2VrJEW6scgKz2B2HizT9Gl9WlTVV4/ScXXfeBsFzsJfVeAiOBIhE1CF0C0kiSDfAzQb4HLrFkUEX+CJlMItJIzoJ2nXklA321iP9gs8kgnhXjJKC7p1xoTtUZAm2skU0nMD3fbQ1x70usCzVijZuTYfV1y2WA3pCsUvteoU9b88K4tsQte4hoe3JMRIXlF3ewxNghCUgmdHBb5b3U2Q86keV1zlVgDdPMYiIFdu8/RcBRpXvHZtMvivGXvKbItJ5CQdBfmyooZ4RZ4KzrrEUvx9cjbPhl/EmW/YwNkVXsxWOFmbS2nYQYgV4gxj0vB7tbSw1BRKIujukEFBTGNixsyXXgCjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   cf558a250cf4475a8936902b8978fbb6c61016f8
commit: 88ef4ca76f70778f2f51c9e749dc9bcc607a2424 [360/388] powerpc/mm: switch device DAX to shared tail vmemmap pages
config: powerpc64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260910/202609100959.X16FvH9R-lkp@intel.com/config)
compiler: powerpc64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260910/202609100959.X16FvH9R-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609100959.X16FvH9R-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/powerpc/mm/book3s64/radix_pgtable.c: In function 'vmemmap_populate_compound_pages':
>> arch/powerpc/mm/book3s64/radix_pgtable.c:1274:53: error: implicit declaration of function 'device_zone'; did you mean 'device_move'? [-Wimplicit-function-declaration]
    1274 |         tail_page = vmemmap_shared_tail_page(order, device_zone(node));
         |                                                     ^~~~~~~~~~~
         |                                                     device_move
>> arch/powerpc/mm/book3s64/radix_pgtable.c:1274:53: error: passing argument 2 of 'vmemmap_shared_tail_page' makes pointer from integer without a cast [-Wint-conversion]
    1274 |         tail_page = vmemmap_shared_tail_page(order, device_zone(node));
         |                                                     ^~~~~~~~~~~~~~~~~
         |                                                     |
         |                                                     int
   In file included from arch/powerpc/mm/book3s64/radix_pgtable.c:22:
   ./include/linux/vmemmap-optimization.h:89:72: note: expected 'struct zone *' but argument is of type 'int'
      89 | struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
         |                                                           ~~~~~~~~~~~~~^~~~


vim +1274 arch/powerpc/mm/book3s64/radix_pgtable.c

  1253	
  1254	int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
  1255						      unsigned long start,
  1256						      unsigned long end, int node,
  1257						      struct dev_pagemap *pgmap)
  1258	{
  1259		/*
  1260		 * we want to map things as base page size mapping so that
  1261		 * we can save space in vmemmap. We could have huge mapping
  1262		 * covering out both edges.
  1263		 */
  1264		unsigned long addr;
  1265		unsigned long next;
  1266		pgd_t *pgd;
  1267		p4d_t *p4d;
  1268		pud_t *pud;
  1269		pmd_t *pmd;
  1270		pte_t *pte;
  1271		struct page *tail_page;
  1272		unsigned int order = pfn_to_section_order(start_pfn);
  1273	
> 1274		tail_page = vmemmap_shared_tail_page(order, device_zone(node));
  1275		if (!tail_page)
  1276			return -ENOMEM;
  1277	
  1278		for (addr = start; addr < end; addr = next) {
  1279	
  1280			pgd = pgd_offset_k(addr);
  1281			p4d = p4d_offset(pgd, addr);
  1282			pud = vmemmap_pud_alloc(p4d, node, addr);
  1283			if (!pud)
  1284				return -ENOMEM;
  1285			pmd = vmemmap_pmd_alloc(pud, node, addr);
  1286			if (!pmd)
  1287				return -ENOMEM;
  1288	
  1289			if (pmd_leaf(READ_ONCE(*pmd))) {
  1290				/* existing huge mapping. Skip the range */
  1291				next = pmd_addr_end(addr, end);
  1292				continue;
  1293			}
  1294			pte = vmemmap_pte_alloc(pmd, node, addr);
  1295			if (!pte)
  1296				return -ENOMEM;
  1297			if (!pte_none(*pte)) {
  1298				/*
  1299				 * This could be because we already have a compound
  1300				 * page whose VMEMMAP_RESERVE_NR pages were mapped and
  1301				 * this request fall in those pages.
  1302				 */
  1303				next = addr + PAGE_SIZE;
  1304				continue;
  1305			} else {
  1306				unsigned long nr_pages = 1UL << order;
  1307				unsigned long addr_pfn = page_to_pfn((struct page *)addr);
  1308				unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
  1309	
  1310				/*
  1311				 * if the address is aligned to huge page size it is the
  1312				 * head mapping.
  1313				 */
  1314				if (pfn_offset == 0) {
  1315					/* Populate the head page vmemmap page */
  1316					pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
  1317					if (!pte)
  1318						return -ENOMEM;
  1319					vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
  1320	
  1321					/*
  1322					 * Populate the tail pages vmemmap page
  1323					 * It can fall in different pmd, hence
  1324					 * vmemmap_populate_address()
  1325					 */
  1326					pte = radix__vmemmap_populate_address(addr + PAGE_SIZE, node, NULL, NULL);
  1327					if (!pte)
  1328						return -ENOMEM;
  1329	
  1330					next = addr + 2 * PAGE_SIZE;
  1331					continue;
  1332				}
  1333	
  1334				pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, tail_page);
  1335				if (!pte)
  1336					return -ENOMEM;
  1337				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
  1338	
  1339				next = addr + PAGE_SIZE;
  1340				continue;
  1341			}
  1342		}
  1343		return 0;
  1344	}
  1345	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

