Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04904C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 19:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC796B008C; Wed,  9 Sep 2026 15:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E6C6B0092; Wed,  9 Sep 2026 15:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94746B0093; Wed,  9 Sep 2026 15:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5936B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:29:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5C44A454B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:29:33 +0000 (UTC)
X-FDA: 85195213026.12.9F10F24
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6770340003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:29:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=STWDOwvH;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788982172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=TuWPVdDC6KLV9X0G86DyVuhThUGHGbFifN6SO+5vHpU=;
	b=6D/G2DWeSndvHazsZEDwJVRWyxSGunFtfkfoAaK6NvXIvbNVqNYjjpKXw+4Ak6qQx+iwbn
	BlaWbGzdoy4W/3xRzo7AMjCvL2/eK/OPSjCIDNt43lZtOdLI2YiOSs3G4jLFtwmK7tx32m
	mP/b6TPJU8wdhseuQTFR2TWjcogc8o0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=STWDOwvH;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788982172;
	b=D4+iMWDu9VPXveR0CyyYTRbSbc12Lm96e5S9H8Lw0TC8cG+PUvh5xfwAXI1nt939hsGK7+
	F+gMS0s5usJv48kNYjsICkJURZnAI0LAaH11sEhk+tk86yAvAo9+KT5AbiNgg2PT5qq6X9
	Rbi8DMT5K2wMRV5ZwKgzhhyBZx+TFEI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788982171; x=1820518171;
  h=date:from:to:cc:subject:message-id;
  bh=xzfWP/TVVBxMP3dUwP2H+KfdNNLSmSz0v0xO+M2s2js=;
  b=STWDOwvHP+F67rx9Gm7lQS8D2NGpNXXHGFV6/5EK0l8lDVqDmmO4/PZu
   +L63mf1SGNiCBUW0dxG0UeFrXuXc5OGmn910jgvMB2RbvzpVCNz2QWXKT
   Bj6UU/lSgqz4AOkX5r4Z5s+n/ZHpVJDFtpbH2jqK1bC7HYLLwXTXrzp/X
   g92JvjHPGcI171TeDxnixeaK5HGaTfmcInbjKCrwC/fkfafSUxSO83Fid
   RC3lgxZXgGQ+PdVv3yxp6N6GhU3OBxAaGjO4xxCmbVfy9G9pN7PunDqFb
   O4VpSnCYOo3RN6jPq3Yf5ZxLu5fDQxtgF8v0urQfbz/3PF6Z53ZVfSm9y
   Q==;
X-CSE-ConnectionGUID: 2jkxZ5DURtKf2Ck3G0ss0Q==
X-CSE-MsgGUID: a0rnQMcXTC+lsAgKenP1Wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="100939903"
X-IronPort-AV: E=Sophos;i="6.25,270,1779174000"; 
   d="scan'208";a="100939903"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 12:29:30 -0700
X-CSE-ConnectionGUID: U2YWfNcASp6WxK6fcf/CHw==
X-CSE-MsgGUID: 4I9LEY48QpyPWbVMGDitUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,270,1779174000"; 
   d="scan'208";a="274927121"
Received: from lkp-server01.sh.intel.com (HELO a3e91e2cf319) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 09 Sep 2026 12:29:28 -0700
Received: from kbuild by a3e91e2cf319 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x4Nz3-000000000r0-3a93;
	Wed, 09 Sep 2026 19:29:25 +0000
Date: Thu, 10 Sep 2026 03:28:37 +0800
From: kernel test robot <lkp@intel.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 356/376] include/linux/mmzone.h:1692:10:
 error: call to undeclared function 'NODE_DATA'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <202609100351.ALNh2KwC-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6770340003
X-Stat-Signature: yberouwazht6cikxfkqkzyj9c3x9k8an
X-Rspam-User: 
X-HE-Tag: 1788982171-13189
X-HE-Meta: U2FsdGVkX1/CnfoWW4x/eWF+CSgD1M+6C2fXQS/pRzz3WDfGyNoCoZoVuykA7U9WKSQz/4abOe/ci7rbkfRpR1ptBtJsEl3gQ4HZTx1Mg4zZL9l4j8wF94s/zaKuJCKaQ5co+ovSSSuiym8YUO5GcRqGfVDmKOBIGB21jdZIiZVVh6rmzV+xz5wnw3UhNw/7fpfOTAFspAwWuQHd2FVlI+r7cE+hOVi7fbe+F+na6/CMRsr6whiT7mIymFfHX6yuknGRnc00jX/QoKr9rj486FozcoI0aMe4lL6Sas8eFu0bQ/Y9xzxGoyQlWHNPnGi1rhZWSsOXYpHAgnxiKopRZCCPHK3HsDfEnF4r0yAOwfmfmyPPBOc9yrOzDA8hNyI7ESgpHENnov6JCfwQ/yRVSRP6TMfvagih41ri7laBffsPSBv/9m5pRtndyST8xvpcVOZLh0p2Xzab+av34r2jThEKs5B2OShzSJjM5JIxKu9UVHEHmw6yPFJq3c9Wi+QyS2ttZTdaXzvCH5WQYatmL4vAVpufbVemkL9XKVOMfGEgw/WORvLkLAMhOxg51SIIwKUdbvLlJEe3K7a1j3v62W2us0DrbSoy+hsoM7TR+MYokS1aK/4/PFrRZJyKkVJLdG1em7dbKEF2RXsA7lUOPcw1L9QlJ2na8R9r+nsxclAHBlpmTfXuOXBUFy1iOHLykaxu4ubJyWt85s9o6n3d/IK8NwByYAQuy1ksbW9d8LGzmcmenA/Dwaz8ZooBCGHTrQnp8asqvv+ShiHFLxyJrGUtuNI2msX9OKiB7ckTdsuRDrR6U2WgkNsAzjPsJTmc2QVrBxDc1kF5ikg0YXAc+EgXT9uf9EyBxUPnPjaaycJ0JFbiXvsUisS2bF3SPmqnd0KbqpJPXWKjhvYeFhOTS5gc7IKgRKPY3GrjwD4J4pr3dlfd2ipEMBejxSXPdSwjyDO4JcxfafraRcuU8Km
 98WMzNwL
 1Gf7hack177ekOfuDsqLzYO/1WZImn2zDwREaX9C/ds+S6aOYCOUWuPJxaPgJO2OSzTce5LDXKvpYitNX4ACIvTUWRFO3sy7ir3yAXt6W+ssr6hZoD5Yi2eYUnpMgFGCUywwenPs0iiF1FbPOVjNgU6QdrcskqEgnHwconkHS0lbjpKPvy48ON1oZ6QRofGE0Yq2paCfQdrwQdYgVCPrHLn8z0WSbUsjJbD6Ss3C4OASZ/X2kvoG2PS/2QwYz07JpEEdszIju35Brybms2RUaWE6zL3D4zDM3Qi8lR8Q5vKr41mWbsLdHA537W6G+pu33TTvhxKxd/+Pwo9NzWMdCZIsXn5kR68hRWKRWBdDkdObYQZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   0bffe67ab8a72b3725cc31c4b525709bd3a3e223
commit: 6ebb1b77696e9870a9621c0cedee2508357cb480 [356/376] mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
config: x86_64-randconfig-123-20260910 (https://download.01.org/0day-ci/archive/20260910/202609100351.ALNh2KwC-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260910/202609100351.ALNh2KwC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609100351.ALNh2KwC-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:9:
   In file included from include/linux/crypto.h:18:
   In file included from include/linux/slab.h:17:
   In file included from include/linux/gfp.h:7:
>> include/linux/mmzone.h:1692:10: error: call to undeclared function 'NODE_DATA'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1692 |         return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
         |                 ^
>> include/linux/mmzone.h:1692:26: error: member reference type 'int' is not a pointer
    1692 |         return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
         |                 ~~~~~~~~~~~~~~  ^
>> include/linux/mmzone.h:1780:35: error: conflicting types for 'NODE_DATA'
    1780 | static inline struct pglist_data *NODE_DATA(int nid)
         |                                   ^
   include/linux/mmzone.h:1692:10: note: previous implicit declaration is here
    1692 |         return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
         |                 ^
   In file included from arch/x86/kernel/asm-offsets.c:10:
   In file included from include/crypto/aria.h:22:
   In file included from include/linux/module.h:20:
   In file included from include/linux/elf.h:6:
   In file included from arch/x86/include/asm/elf.h:10:
   In file included from arch/x86/include/asm/ia32.h:7:
   In file included from include/linux/compat.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:10:
   In file included from include/crypto/aria.h:22:
   In file included from include/linux/module.h:20:
   In file included from include/linux/elf.h:6:
   In file included from arch/x86/include/asm/elf.h:10:
   In file included from arch/x86/include/asm/ia32.h:7:
   In file included from include/linux/compat.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:10:
   In file included from include/crypto/aria.h:22:
   In file included from include/linux/module.h:20:
   In file included from include/linux/elf.h:6:
   In file included from arch/x86/include/asm/elf.h:10:
   In file included from arch/x86/include/asm/ia32.h:7:
   In file included from include/linux/compat.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:99:4: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      99 |                         set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:10:
   In file included from include/crypto/aria.h:22:
   In file included from include/linux/module.h:20:
   In file included from include/linux/elf.h:6:
   In file included from arch/x86/include/asm/elf.h:10:
   In file included from arch/x86/include/asm/ia32.h:7:
   In file included from include/linux/compat.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:101:11: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
     101 |                 return (set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:10:
   In file included from include/crypto/aria.h:22:
   In file included from include/linux/module.h:20:
   In file included from include/linux/elf.h:6:
   In file included from arch/x86/include/asm/elf.h:10:
   In file included from arch/x86/include/asm/ia32.h:7:
   In file included from include/linux/compat.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^


vim +/NODE_DATA +1692 include/linux/mmzone.h

  1689	
  1690	static inline struct zone *device_zone(int nid)
  1691	{
> 1692		return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
  1693	}
  1694	#else
  1695	static inline bool zone_is_zone_device(const struct zone *zone)
  1696	{
  1697		return false;
  1698	}
  1699	
  1700	static inline struct zone *device_zone(int nid)
  1701	{
  1702		return NULL;
  1703	}
  1704	#endif
  1705	
  1706	/*
  1707	 * Returns true if a zone has pages managed by the buddy allocator.
  1708	 * All the reclaim decisions have to use this function rather than
  1709	 * populated_zone(). If the whole zone is reserved then we can easily
  1710	 * end up with populated_zone() && !managed_zone().
  1711	 */
  1712	static inline bool managed_zone(const struct zone *zone)
  1713	{
  1714		return zone_managed_pages(zone);
  1715	}
  1716	
  1717	/* Returns true if a zone has memory */
  1718	static inline bool populated_zone(const struct zone *zone)
  1719	{
  1720		return zone->present_pages;
  1721	}
  1722	
  1723	#ifdef CONFIG_NUMA
  1724	static inline int zone_to_nid(const struct zone *zone)
  1725	{
  1726		return zone->node;
  1727	}
  1728	
  1729	static inline void zone_set_nid(struct zone *zone, int nid)
  1730	{
  1731		zone->node = nid;
  1732	}
  1733	#else
  1734	static inline int zone_to_nid(const struct zone *zone)
  1735	{
  1736		return 0;
  1737	}
  1738	
  1739	static inline void zone_set_nid(struct zone *zone, int nid) {}
  1740	#endif
  1741	
  1742	extern int movable_zone;
  1743	
  1744	static inline int is_highmem_idx(enum zone_type idx)
  1745	{
  1746	#ifdef CONFIG_HIGHMEM
  1747		return (idx == ZONE_HIGHMEM ||
  1748			(idx == ZONE_MOVABLE && movable_zone == ZONE_HIGHMEM));
  1749	#else
  1750		return 0;
  1751	#endif
  1752	}
  1753	
  1754	/**
  1755	 * is_highmem - helper function to quickly check if a struct zone is a
  1756	 *              highmem zone or not.  This is an attempt to keep references
  1757	 *              to ZONE_{DMA/NORMAL/HIGHMEM/etc} in general code to a minimum.
  1758	 * @zone: pointer to struct zone variable
  1759	 * Return: 1 for a highmem zone, 0 otherwise
  1760	 */
  1761	static inline int is_highmem(const struct zone *zone)
  1762	{
  1763		return is_highmem_idx(zone_idx(zone));
  1764	}
  1765	
  1766	bool has_managed_zone(enum zone_type zone);
  1767	static inline bool has_managed_dma(void)
  1768	{
  1769	#ifdef CONFIG_ZONE_DMA
  1770		return has_managed_zone(ZONE_DMA);
  1771	#else
  1772		return false;
  1773	#endif
  1774	}
  1775	
  1776	
  1777	#ifndef CONFIG_NUMA
  1778	
  1779	extern struct pglist_data contig_page_data;
> 1780	static inline struct pglist_data *NODE_DATA(int nid)
  1781	{
  1782		return &contig_page_data;
  1783	}
  1784	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

