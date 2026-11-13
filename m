Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F7760740C0
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 13:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=b8qN5aZ/
Received: by kanga.kvack.org (Postfix)
	id 09EC96B05F0; Fri, 13 Nov 2026 08:30:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28D46B05FB; Fri, 13 Nov 2026 08:30:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16976B05FC; Fri, 13 Nov 2026 08:30:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5ACA6B05F0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:30:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA626A01BA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:30:04 +0000 (UTC)
X-FDA: 85430179128.19.33B0F66
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2022E140009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:30:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="b8qN5aZ/";
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794576603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=rG04TwV+aXkJ3tlNjFerWDM4B3GSxAC0ACNVgfYbO7k=;
	b=7pgTDKbQhJentiB+xb13MpDb+9ZKtxpQdSGAAd1mNfCK+Z9lN2B0CjgBYMlzIp7b106syE
	XLZxRpsdIweqVvPA7Ku7y1FOM3stC1NEyrrd1xKZ5nD7G5XgdzJz+sxy5bF5u+yeXzepy2
	kKPX172TvG7dgp51t7bogpcUxqPRCfc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794576603;
	b=BHY99qioP/0PYYWNpi5UJ4J6to6cgVyVoej0kC/2J67tR+4LOOjwdJQDlVKd4sTUezFIgR
	BZEYfTu4PulX0+q4rWB5HQ34ua0R4S9Ai7cl/ZSaIA7siizYl9ZD6dZdQsRSnfrCJqLlGe
	B+UJ024CaIk+HxNKx4lSbV121gejNck=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="b8qN5aZ/";
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794576602; x=1826112602;
  h=date:from:to:cc:subject:message-id;
  bh=l/tnBcaBNGJcgq4kYFCcHdlZTAOqbmLwHFmG/eNT78A=;
  b=b8qN5aZ/J6Ljxu9S0Yjc4uo1pgrnWxbdwnTy1rIqhsqHxSWrM9ypswuG
   iBGgepUyiKdUDsP2ekRH6NHvsQUg0psAq1EBDa6k0RjoDgCyatUXDF970
   q+a4lvSBXIQYV2SiGFDjK/Ah9VFOcKB49gC+R47Nb1ihWxWpoi8ePPQTD
   i2q045naIQkwTUNKnA038vyJaFw6+zr+IjQ39F73k0PzCA1fqgoHyi8dK
   Q83Zq8+Jy+b4BrZ+ePg7l5IRWuYpuobPgA7vygbPjGT9vm7XgL1nXnD91
   37nRoBGFyEFMQDhQnOQCMJ7/BiFzQjYhOsSlFd5CZEt1HG4Vo0d7XPYso
   A==;
X-CSE-ConnectionGUID: BkFRf0DXQXmpe55JHyK0ew==
X-CSE-MsgGUID: 9NlTLT2JS+ai/oKadgdYdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3285193"
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="3285193"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 05:30:00 -0800
X-CSE-ConnectionGUID: dl4b/IjPSqyTM3G8ujv+Nw==
X-CSE-MsgGUID: gEAAOc6NRYqsnqHSswrDbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,211,1787036400"; 
   d="scan'208";a="9103122"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by orviesa009.jf.intel.com with ESMTP; 13 Nov 2026 05:29:58 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRrLn-000000001HH-3HhY;
	Fri, 13 Nov 2026 13:29:55 +0000
Date: Fri, 13 Nov 2026 14:29:18 +0100
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org,
 "Liam R. Howlett (Google)" <liam@infradead.org>,
 "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Subject: [akpm-mm:mm-new 307/308] mm/cma.c:493 cma_find_free_range()
 warn: always true condition '(start < (4294967296)) => (0-u32max <
 4294967296)'
Message-ID: <202611131415.4Nn1yaIf-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2022E140009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 55w8p543xwxap56f9fmohjgto11dpk4t
X-Rspam-User: 
X-HE-Tag: 1794576601-907581
X-HE-Meta: U2FsdGVkX1/wF/HW6UWID+hk9j4Wq364UziWLZnm6X5NnNjo6em9NE8kYfwORthfjThipyh2Qgs0qdxlXI2eCO572xZ9ZOFMjYwPgeR4sLN5F787dQhnbELXVO0d2xAN5Ufkupxx+1+DsheJo/tcNkvOOKvCGGJYxH2Dj7F3esNsKbzJ9/QK05IlnuTGK83I/JPeD52RAJCV6UeN4KDmJ+mBZMQQmVeHcrTRFVNDLSvzw3K2rxIDN/dfDkwkBWMDJtMwoziru8tOdd0iCoHS5FZGh2g5u77BUPIiNMM+9yOsVqD1ZS0BSYqYpho7/QAph18TFcl1ne51zNLDdg7/Kt1ZqFtYLqrBfauoDu8CGEJ+raQVu4V0LeAduZM6ou2MCe4eMz8W+stn8qRvyDpUS0mtQAGYjfTqKYul6zbYmBaKK5b/GWzWSbi07nROuC76OAqwwuz/CZ5Fz5wP5uwmNzPfv9GBJGm+7gNq07NhkS1dtdxCCYBQJuNEH3HAAIS6QarB58M/iTJeQRjuOj2pnq1YgLu3V6CKDo6Ya7qovp1FBBoc7upwWvBRaer1NvRoxbnQ+39V/D2k5nCCU7PMs8T6WDahQPQQVz+QmHqzjeDdKx3n83C80nvHXABB8i3gTTYy0RCwyM2aJY3uq4DxPnYcrAlLjGO1GXeluL7X8TMKsrk44dLz/ZE8awBNCUnHi2/hMPIPjZB4qauxkNjKqmWjd4UUa+MXOEgH6x6t8wS80lRqHnkSPluKkWKUN/1HWVDh0ZsPCbGulLGHoD5vri/dJ+7Hsw2YtVcliiGZ1t4fm/DzSbnhw7CWFOQvQMUUxVQPsyL2d2I5FHNL+M7UOIsWSSuKKqUiXM/EoMFlElQi9FZnioBevxOTZb3+2yZR3037oML+NjflNV7Lpc72Ut7jdnHgSCbSaJXrPzosaiddNsWaBQP6QMD5wcAetkMBHuME+pC89rcb1Z8Z3IL
 ROlI4t5J
 uqnlvTumH2OA7r+64rdH8wKzrrLdDg6DjSjOsJj6itIE4PZvD11V656HpD4PEtO5REGMUGZ7db+BIfAbacHyyCrhc2m1RjHmz4EpYTqQUpjp1NeRRoqyXOFCAnz2+pC2328UhNElLP7qCl1GPy7FkFItk6BdQiYxlW29Nx30nx0qR4vMmuYMRlBGd2+RSnbtGXOQBbIdjoGaGHOzQkGQK9ctcy+V13Dcy8LQlv3Cmu+/6msbB8RbVv/uPVHLRXv9ML/oJ1axiqvV4XmBTTnGLIxanzab/7PnyxUYEddfkMrxsjPtZf8QzwYEP0rd5vSh2x4YeSnD4q+lIDhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   31a696f9c37defab0f28f774e00ac7f135889ec3
commit: 4cbc68cde0e185ae7cefed74c1b56e61cfe13277 [307/308] mm/cma: simplify cma_declare_contiguous_multi()
config: um-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131415.4Nn1yaIf-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
smatch: v0.5.0-9187-g5189e3fb

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611131415.4Nn1yaIf-lkp@intel.com/

smatch warnings:
mm/cma.c:493 cma_find_free_range() warn: always true condition '(start < (4294967296)) => (0-u32max < 4294967296)'

vim +493 mm/cma.c

   476	
   477	/*
   478	 * Find the largest free range above 4G that can hold a part of a multi-range
   479	 * CMA area.
   480	 */
   481	static phys_addr_t __init cma_find_free_range(phys_addr_t align,
   482			phys_addr_t size_align, int nid, phys_addr_t *basep)
   483	{
   484		phys_addr_t start, end, size;
   485		phys_addr_t max = 0;
   486		u64 i;
   487	
   488		/* no point searching if the system can't addres above 4G */
   489		if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
   490			return 0;
   491	
   492		for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
 > 493			if (start < SZ_4G)
   494				continue;
   495	
   496			start = ALIGN(start, align);
   497			if (start >= end)
   498				continue;
   499	
   500			size = ALIGN_DOWN(end - start, size_align);
   501			if (size > max) {
   502				max = size;
   503				*basep = start;
   504			}
   505		}
   506	
   507		return max;
   508	}
   509	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

