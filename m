Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E06FF6E9A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 23:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2FCE6B00B3; Tue, 17 Mar 2026 19:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07D06B00B5; Tue, 17 Mar 2026 19:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944956B00B6; Tue, 17 Mar 2026 19:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83F436B00B3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:46:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1514E8B5CA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:46:59 +0000 (UTC)
X-FDA: 84557192958.30.BBF28CF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8E951180007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:46:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d46bW03z;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773791217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=rZJnb0cnQU2CY8UK+acYYes8tFEAzRSDCdNvXGDfHxo=;
	b=pIIcqrK1c3bIztXN3wqwLX+G5E3EvtRgyXO64Ied6q7Ux3ce47VhJx6ybDWXrJc1hXq35s
	fJ0gsn/rkHbNvjbbOOoRwG+90Bl/aqJ8vcEZsO+Zel8vOB86IMX+StRmr1R920ewCN0xV5
	01xSZZJkQc8ihX1Hyj36BaO0OjXqFdc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773791217; a=rsa-sha256;
	cv=none;
	b=xxCd9AKRYFR+sAGz+6OnBY+YAJm5NdxiaF+S3DDNkLv2knqXjUe6N9kDJz24vZxx+E++2N
	H9s4eyPrx3Vsiz7GXn5KgdF5nvXdNoarc62cwrSi6lxvtHo9kHPaR2x31RIu9NyqhkeqYk
	cR8nt+1Uk17MBpYz1VC6uXRyb8AkhdI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d46bW03z;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773791216; x=1805327216;
  h=date:from:to:cc:subject:message-id;
  bh=q/nkSMbLjr9unDc1UgUFaSb3IkiB4iY04e/hfsMmMEQ=;
  b=d46bW03zg7GjtvJ+o6j82vxVpqpy+IvaaL9gNBZcwTsRSYsUnJrip23w
   RhdmWavCFXy67JNjBmG9VEiyxc8xGFq/zNVSUBA2vSqJ0QJjsYsgGbGqR
   bDx2iQKY3I2YDCJxSYiZZGRYmu+DX0pfBLL0a9jVW8stct3silPjMzOPA
   B4fKUwD7gqLSCyvdSufLRLCDwrfQOtvLrOaW2mC3ScwhW+dO+5DR3Fda7
   dETbgmHc1CE6jOxyD3SLyHr0D34OvG0YLwPsY2Rd4U8NfVm+N8GYZbJlu
   9kKud1is6qOM5y3kcDauXijt61GwUfXn8QUAIN2jxytVOOFAp8iLoi3pp
   Q==;
X-CSE-ConnectionGUID: DQp5pFiETvymJg0JLwdGwg==
X-CSE-MsgGUID: w8rCq+/yQxuvBzsBUMILKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11732"; a="73857992"
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="73857992"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 16:46:55 -0700
X-CSE-ConnectionGUID: WKcel/76RLCOgCX1FrDI9w==
X-CSE-MsgGUID: oKp71fguQsm2PXOk1SX30w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="227103863"
Received: from lkp-server01.sh.intel.com (HELO 63737dd503cb) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 17 Mar 2026 16:46:54 -0700
Received: from kbuild by 63737dd503cb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w2e7f-000000002BL-0MNV;
	Tue, 17 Mar 2026 23:46:51 +0000
Date: Wed, 18 Mar 2026 07:46:40 +0800
From: kernel test robot <lkp@intel.com>
To: Michal Clapinski <mclapinski@google.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new /419] mm/page_alloc.c:557:31: error:
 'MIGRATE_CMA' undeclared; did you mean 'MIGRATE_SYNC'?
Message-ID: <202603180720.1BYScGIj-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: sxx8b4zfg3u6wo84oqu1cumeq46assdm
X-Rspamd-Queue-Id: 8E951180007
X-Rspamd-Server: rspam03
X-HE-Tag: 1773791216-444515
X-HE-Meta: U2FsdGVkX1/zylVOPuAf4aqMMal3nnc7xcNmY+4KOeQlWGnWdbvbFSpLG/DV6NBrTaUhz4zayjTu7yjwg05jqZZjpa3EJoWXuU7Bbd/08CRlKSTMl2Y4ImQSoryynyV8AhXVHuYSLiUO7W2pIdx3j4w4JdRg1PVHTujDjcR3v7Bf1ooYp4Eon82qBbIi1p9j2xNBrEt9EgY264FwOeca8BrkFE+SzKW1RqIKPi6T7fRQYqv/LNCj7Qb5hykCuIkoGSTvBqd9+Ca6yzd6WazZm3LVzz1eN4ZkRF973EqMTEeTcL8A9QuL9lRxyn4UtZDCnuYsdkMdj7nWfursz1Lg+seyiq9lfXNwib0gZ8RBDnVzALOYGGPPQe3CHSp4uwmlEB2BsIRujZTTByOIdV5m9RqCDPIlH22Cy5Pcw421smK29THcB7InPzsJx2mkHsrBW0dCyp1tRsunbfXCDac64/t0/sJ0WGU0PfXbVIJyaRyxMpGthXtokV8Lunwx4+LY1njpXjg9Wt+5Ze2nte9lKGyRQX0tjQaYtZbwhqsr0ssZ8cTydfDA8dKNTkAZeOAkg4lQ4ISYSMoso7AvnJ0aGCzq+FhDGpeKILyTu9+8HKiQRBIfYZs5BVBIVDQcHEvdY1iTSpXYHWr/4/c7v+1Wwto2Ueor8leuhBu/Ur6pVdu1tzz1imNthjSgWXVv39C59MhC05BwKSS9eJGODZPnGDymB+AjsxtnCZ1325Jkhk47pVsyvrTVPpY3n9ecboTK1LYF/Biu32oV70pXouZdpPkRwuTefJx+d1Q62SunVmEIvIy6F6pPNfDWn4kYY01Fc/9qU0IcyEhgFVVgNAavd10Z9GjA5e3wrkOYnOYWxJ0/WtXbzLOwZesrQvtnj1Ue04iE6vGDaVg2P+TTAykgD4ZwTF23jTf5v5qNIafA2uIsjHUY+I3OSS6nczcypBJwHJwHIZ46QVMDcRTD/Ob
 zbRSaPiA
 KquP/Jy1Mo4xud9eI+k6eXc18CCL01fAl0umqGs9skf51a09xHlL8945oH84wNBDt5/ak55t86YJBBBEC9Q/66LLWZlSC69bVh6/zoCL9RjNHtV0A01kjLcERp6e2nzwq6d0wlk1qQ1oNjdJWdKDsJ6VBsiAfj3lfOQwz8pvUkoxDM5zXBikyE8bsoqo7vtaXY8JejRmkv0LCiP6XYZqxUVFSJo4uB8aqcp2TCrHx2MC9u0hQegzKrQakPOeCLjaNleoTB9K0eFWT143LQE3Oqg2bVfrRmnwABLFYaYujZ3CFFVY9dZiLI0E9A820WVHgP0GOMcjXXo103sue1fPChUnrGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   c31e58126afa2665dc5b7f78c60e5fb25218d7e5
commit: 1e1dab36a7f3e06700a97696f62e7691ce4ea85a [/419] kho: fix deferred init of kho scratch
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260318/202603180720.1BYScGIj-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260318/202603180720.1BYScGIj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603180720.1BYScGIj-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/page_alloc.c: In function 'init_pageblock_migratetype':
>> mm/page_alloc.c:557:31: error: 'MIGRATE_CMA' undeclared (first use in this function); did you mean 'MIGRATE_SYNC'?
     557 |                 migratetype = MIGRATE_CMA;
         |                               ^~~~~~~~~~~
         |                               MIGRATE_SYNC
   mm/page_alloc.c:557:31: note: each undeclared identifier is reported only once for each function it appears in


vim +557 mm/page_alloc.c

   542	
   543	void __meminit init_pageblock_migratetype(struct page *page,
   544						  enum migratetype migratetype,
   545						  bool isolate)
   546	{
   547		unsigned long flags;
   548	
   549		if (unlikely(page_group_by_mobility_disabled &&
   550			     migratetype < MIGRATE_PCPTYPES))
   551			migratetype = MIGRATE_UNMOVABLE;
   552	
   553		/*
   554		 * Mark KHO scratch as CMA so no unmovable allocations are made there.
   555		 */
   556		if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
 > 557			migratetype = MIGRATE_CMA;
   558	
   559		flags = migratetype;
   560	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

