Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C66C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 00:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ED396B0092; Thu, 10 Sep 2026 20:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C43B6B0093; Thu, 10 Sep 2026 20:38:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F726B0095; Thu, 10 Sep 2026 20:38:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 106ED6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:38:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BC57A55CF
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:38:49 +0000 (UTC)
X-FDA: 85199621178.01.35433E3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf23.hostedemail.com (Postfix) with ESMTP id E127814000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:38:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CpVZ6zAK;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789087127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=3bUaTLxzz5x1RQjpxkWb1y7u96/kjrHlQfmxQ8X+TOI=;
	b=S+N0n8SWsNd4yCuTRRpP5EC5WLFAWrvGYgIHZl6sbbBIL0ajV6ND8bh6kpBfRtC0fRsYiH
	VgvuqwRxtYhg+pXetsk/Rx/EH54l+GGrjGhhhEs15ZktTugPE5kYk2hIc1amPkmTkxefPP
	n99GnQ7ebwXtIhr1DKi5WXf+fX8FNTU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CpVZ6zAK;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789087127;
	b=q+g60k2bcScyOkVF4nLSkQDCrGT43Q02uUnCfal0Rh+XdEXyxWKQ1505vbyE/gn2SIi0Py
	PdyIGnrxB7AwjLck42eMlSkFC4h1t7zhVq/jNAtMLeRKABasx2JisjhNXIH2z5PPV8ZVAM
	63+6NqOcT+FmkdI+n866EbSdNUdx+7w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789087127; x=1820623127;
  h=date:from:to:cc:subject:message-id;
  bh=NeXt/VQR55oQWvrZNtGzLa5p1Y9eazGeFFKk5W/tI6k=;
  b=CpVZ6zAKFRaLRhI55T/vmdOT9sB9qwZPWKRvzZcfGoribz5q6vj0r8TP
   IqMKNfnw3r+/7LiE8E2f8uoow9iOxXIZ98N2mXHM5S6WVQQ9e+BEUGhe8
   7ZlbDlmPvbnjYk3EHVwnF9VsY1nOj2YjVtHG03QOnKnXyAZFsM0ZT4gY5
   S2gtzjglO7i7M9ld4FtGBkajzXboD1s65hmQ2ufEDZ3FvKusCbS05v4nO
   6Jo+EjiCL59rfJuicGgrBxt969MT0avtKDYn5TIhHM8i3/6PKIOwCZj3P
   ytUDzEczWD1gTHdM40Aml50+LwYuxApra5VLGR8JVImlnSDPzxArRUVij
   A==;
X-CSE-ConnectionGUID: RLK1AIpcSOOkumGVemP4Xw==
X-CSE-MsgGUID: Fn5qzWKaQD6H1pfHW/2Ihw==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="89482940"
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="89482940"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 17:38:46 -0700
X-CSE-ConnectionGUID: bu7mjKC3Q1Gz6iUNBsHMsg==
X-CSE-MsgGUID: M6AjY437SZiM4AWYaVGBtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,96,1787036400"; 
   d="scan'208";a="273720633"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 10 Sep 2026 17:38:40 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4pGu-000000000iQ-2XxP;
	Fri, 11 Sep 2026 00:37:58 +0000
Date: Fri, 11 Sep 2026 08:37:16 +0800
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new /391]
 arch/powerpc/mm/book3s64/radix_pgtable.c:1274:46: error: call to undeclared
 function 'device_zone'; ISO C99 and later do not support implicit function
 declarations
Message-ID: <202609110857.T3uVHRo8-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: 9zsm6txu913ku5o9dcikfgoku6bn17wi
X-Rspamd-Queue-Id: E127814000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1789087126-543882
X-HE-Meta: U2FsdGVkX19u83Vk4BI2OLJBmTbA9jGl0IP/yAaISPLjkoAfhhieig5LlaAHVr79myxq2Mccp5AabXvRirINzJWjTcJdQOaLlnQIU0mK+VGBaxRRSu/HYvrDnHI6aZiygbK1o6pZCxtKO3rbcICzGH+NftlX3DvIrUUK9iez7gygslb5A4Ah/N/nI+CbS77TMjnf8hplYrXlNTRRI4jBYXZH5Ns2hl2D/H5o9nnDq+wMzFgMXKicHtLrkxODaQTFGkszT5Jmfjnvspbw0Dtns4glrmqXsyi8o2ipe9bUUawa/RuNbpuDeqX4bNK4w54uUp18GF8CE1TrRzdpfWn1AP6spbkjJdC2Rb7SUXCZQ+k3f41uZsS4P6DADp3iz6nM2Trc3eOPXYVtp0t91WnfquSNA5tt8SJBE8rEkEtUdM/Zp/W4E2PJ3mKLjnD6b2ZqCQPt36m+d1WGoirTChf2o2bRwWAwJ4qEV+DAQq1EaOwaYJdtw/j2sPjdFZI88fayMjMMYXAQA/LgEz/lvikTU4SR1yixqCkJIUFqXmfLGDwNf7cbdaWoQJ3DfSMakdSo+MuQ4TI0cK+n2IanrmhozyZU85KeasKhx4DOKl+F6nHo0pVQ4cpdKHgjNTor+3f/fSvt0IpgEBl4VwwFLC4N9t/qoCaiD9GMxHPxy5dCpXAxaeHqBi9TqPlGHtWnRxnlg7d4YkGU6Gpf7kwmCH4zygjZlUUNFLrsDzu2bnVz9LTRq4tC885N1TMa9GpdPGdPVaTzU+AD+CMe7O5VJMceFQqTuKUqlAQeLAVrVWX4zUffF6AcVFmPgV4uE1ZTnxEXzcO1XAfaEuOl6D6Qm6rV5B0g7oyHo6km4FQd5Ex1/8DWa7yFRDfF48g+kt5zcp+J7I1f6q0VvcsXOgmRHckAqR3UGLtrN5MVJnmrRNTI2CWGMEo3wT6ggkRQwA9uDFLcfz7C2NbilUVEKgH+woY
 AutZO32G
 5yELcKUMOXyx7HYn7fzI6yNN5MVJU2Zb9U+bV7+ZShGclnaahrRqMcz1ACZOYl9UfXdCjpqlvjHBbfI2rtDywzs5BiHHLNgw/AaBPNxf4ieSr/teCCTYYBndN0m71mPzUERdcCpjaQxOQDLLGx+CNO2pj1NIScnYNcWMQPrJx7nmbynV6Ef3g4xDvHLnL/y9uXoMO6qvmvkBlO6IdVuVV3ZujWtgUgQJNzFUgjgDtVlPej5s/F5+4Z1Qnstf3MWi+kz+ZZJFrCY5KKVVt4PFW8q5jNqIN05cq5SM8XGAIvr9y3Nz+yZX9ttLpjVnlIi3YnzHt5lCFZ+X/4SramFIkKxZd5yFx6/5pHl0pXM4eP/OINiY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   1f78f28a2945f9e856b4ea8428ac41a6788e4b67
commit: 88ef4ca76f70778f2f51c9e749dc9bcc607a2424 [/391] powerpc/mm: switch device DAX to shared tail vmemmap pages
config: powerpc64-randconfig-002-20260911 (https://download.01.org/0day-ci/archive/20260911/202609110857.T3uVHRo8-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 96295a1412f9afbee9d4a3c2701e83f5a529a9cc)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260911/202609110857.T3uVHRo8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609110857.T3uVHRo8-lkp@intel.com/

Note: the akpm-mm/mm-new HEAD 1f78f28a2945f9e856b4ea8428ac41a6788e4b67 builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

>> arch/powerpc/mm/book3s64/radix_pgtable.c:1274:46: error: call to undeclared function 'device_zone'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1274 |         tail_page = vmemmap_shared_tail_page(order, device_zone(node));
         |                                                     ^
   arch/powerpc/mm/book3s64/radix_pgtable.c:1274:46: note: did you mean 'device_move'?
   include/linux/device.h:1209:5: note: 'device_move' declared here
    1209 | int device_move(struct device *dev, struct device *new_parent,
         |     ^
>> arch/powerpc/mm/book3s64/radix_pgtable.c:1274:46: error: incompatible integer to pointer conversion passing 'int' to parameter of type 'struct zone *' [-Wint-conversion]
    1274 |         tail_page = vmemmap_shared_tail_page(order, device_zone(node));
         |                                                     ^~~~~~~~~~~~~~~~~
   include/linux/vmemmap-optimization.h:89:72: note: passing argument to parameter 'zone' here
      89 | struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
         |                                                                        ^
   2 errors generated.


vim +/device_zone +1274 arch/powerpc/mm/book3s64/radix_pgtable.c

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

