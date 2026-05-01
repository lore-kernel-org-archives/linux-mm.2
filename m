Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA6DCD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 10:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5696B0088; Fri,  1 May 2026 06:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6ECB6B008A; Fri,  1 May 2026 06:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936B26B008C; Fri,  1 May 2026 06:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD2D6B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:56:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 149AB1A0101
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:56:04 +0000 (UTC)
X-FDA: 84718546248.10.57A4574
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 547244000A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:56:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HUxzWgEu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777632962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=vchm9FMZukqnS9ZBdrQ6UrfHIO33TZ+bMfSaxxtCd5w=;
	b=8iADA7+xxg2UoEQuJFMGst5XKY50shZ2cT7x+DlbAWsXd32o/Iwb1Rp/Lcd/Feeu8nbWgt
	6sUdqYM5gaDTUrD0/gos22o839srjcyrKhpvJoXPATC4KYV/y3TNplaOBBvQEppsFjM/Ih
	7efQl8vb43fClAx9T6QZYI3s80oBe2Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777632962; a=rsa-sha256;
	cv=none;
	b=6WtufZalmJ+nJR3s1ctwLJszCwFNcJKgfatSEIfQND1uufsF4rrO9fRC77ZY4Pgc7G+gcQ
	eraBlSbxcsd+Kmiv8DHebUAl9ntbgBsvNv6IaqXzAxyi21rlBd1lMrn7qZn6nsnOjLuMEr
	tyIDj/eO05bh4b9NUd7+fVvXcQBg2+Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HUxzWgEu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777632962; x=1809168962;
  h=date:from:to:cc:subject:message-id;
  bh=B9k2W1qnkspUZ8629bLo3NyhJcXoi3Rhb1p2KXB5fCw=;
  b=HUxzWgEuz4essnKTNT75jHtb0uGPqBEzx7wz2aXSOSYc2FbRdEvvUWfq
   V2jCCql0ksdA4e2jN4dbmARRh3bnzmSaNIT7qM4ql91nJGGmgmQf6TUby
   nCUX2mLXXVmlcfVsfv6SdjSRfToGuw8fUyCZA/plgS26CHOAS3P6S3nEA
   onDdC2zgVKEgMkQdpNHPUTT/i12nrZOCgmH62I+px9cBamkv8GHXyAowM
   tc7QTz+wIufzRt2I3dev34D2lF0Oqu2YhoiJtDfM208BEWJFW/K77H/i7
   4c2qpd+OAAdfZhBMqmBU2GHZRCvC82zsWOaBlHI1NcSgonD85dYNU6aQX
   A==;
X-CSE-ConnectionGUID: QODVvMfjRsiuI2p7aq3m2A==
X-CSE-MsgGUID: tGfv9NDHRXOCFG3QaYowQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="96012001"
X-IronPort-AV: E=Sophos;i="6.23,209,1770624000"; 
   d="scan'208";a="96012001"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 03:56:01 -0700
X-CSE-ConnectionGUID: lZiLYv9GSrO5MuIeNeUxOQ==
X-CSE-MsgGUID: U44ytumAR3Wv5faYDqEXow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,209,1770624000"; 
   d="scan'208";a="233794452"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 01 May 2026 03:55:59 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIlXH-000000000Tn-1bNi;
	Fri, 01 May 2026 10:55:55 +0000
Date: Fri, 01 May 2026 18:55:07 +0800
From: kernel test robot <lkp@intel.com>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: mm/vmscan.c:6585:66: sparse: sparse: Using plain integer as
 NULL pointer
Message-ID: <202605011838.0NbkvDxs-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 547244000A
X-Rspamd-Server: rspam04
X-Stat-Signature: aeafeeh3k3uepuswc498mkrxkzdpih3t
X-HE-Tag: 1777632961-165931
X-HE-Meta: U2FsdGVkX1+itk4G6Ugywh1uRaaZvW5tZK6hcs1q6tyPZ+raE1C6DJcmh3fWm7kDaOPFl2v6NpvVsA5NOC7XpWSeRFXVHSPl29tqGsp8bYF1aprX3y5UwRcZXJKNnNxJRSRC9AqW/fvkJr+CtX3XkvL6UmwA8JRWP+0/1DzYqdvHPtGvLZEQ79e+W9y9oiBVmhygOqyWEoNdwCcDprXwzKEOzP6ZgCtcw16zKlbDVQ6AAVOhQvvIrIwZQw8nSacVdo206TZH114piDUP1ofA0UU6DGHJdtsVvb6w4pLbvvFrAIKMolTZEJHyeb/oK3d85dZd2w6SoF6VNW52cHIRlGnoMid6NS6iw4ys26b0r3yhhJ04TG7UNuhDY2SzW1+Eboiqee1gQFiYZinuQBBnKq4CYtuuml5FZ+SEQEzOEjhw4+8bWUHhCv7DvmOgRjmGMVlzbzlg/UXrFfH8dH6mKcAwYX8Bkkl4u6in7WxF5AH0J73U+7WH1U+l/l4n+mkooV8CeR4GRERnC62nLKwXVTJtRGgSWPldwSwVvI49SlwGe+8bz2mxCz1nMlCrvADsxOJGxF1dr/M+TbhUB6Rz8vHMI434lUftlI9juAzJn7gn3tZQb/q86OFmAM8dkTBHbNPiqlTRLBtmM3HMXwQAtkGluqJY/8PZAcI3Z34Lvm00Veiffd8O2YY1Ea7SyNzjzRIH49anzQHjnwa5o/zH9RfaNvPsQDYVNlrWfQAWEJs26qT4FfMLx33Z+Kb0t4V5sTvFstbxFE4qEaOwtlMEVNtzN1VYgcgPu1AAeBG+sIlRyOm+ERneNejlClbli+QMIUJyIAHas/b2fz2Ci2EYIHb4JMjJ6KH62PYC16rVTYFr3xtzQkGFImGg2BYJ7UoR6vWbnrMafc0CBgAFhdw6sYFAiYn/D4/06FHwjW9m/a6CtL3fx9kDfWzpCrD/2eSOoxuBmkfMzRi+KkusO7m
 6iNUi+jD
 uuRK5ljn04+YRjOVSJZ/7KLM3HkWXT1u2NPLBL5mxc3kTlXWHbHBDkMj3Zjg23S7uwuo2YRqd998S9sMXIbP1uRazkYvvStzrTnyhL4HtzYJn/TM4vMEw7PlwO1ql9SyI68J8y6/fCIZo3lG6s0F7z4hLjH7NI9zDh09u9sue1lC3YPJ/khW1iVo8Xz4cZoAcco4BIBPsRVR1EhAb3gZD7dLwLxEmAWnbdG90ZU+nGe1gEtSO7yUMA4wI5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   26fd6bff2c050196005312d1d306889220952a99
commit: 874a0a566ede40f3d6062cae8fe1022e616edd1a mm: vmscan: add cgroup IDs to vmscan tracepoints
date:   4 weeks ago
config: m68k-randconfig-r113-20260501 (https://download.01.org/0day-ci/archive/20260501/202605011838.0NbkvDxs-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260501/202605011838.0NbkvDxs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 874a0a566ede ("mm: vmscan: add cgroup IDs to vmscan tracepoints")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605011838.0NbkvDxs-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/vmscan.c:6585:66: sparse: sparse: Using plain integer as NULL pointer
   mm/vmscan.c:6589:58: sparse: sparse: Using plain integer as NULL pointer

vim +6585 mm/vmscan.c

  6551	
  6552	unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
  6553					gfp_t gfp_mask, nodemask_t *nodemask)
  6554	{
  6555		unsigned long nr_reclaimed;
  6556		struct scan_control sc = {
  6557			.nr_to_reclaim = SWAP_CLUSTER_MAX,
  6558			.gfp_mask = current_gfp_context(gfp_mask),
  6559			.reclaim_idx = gfp_zone(gfp_mask),
  6560			.order = order,
  6561			.nodemask = nodemask,
  6562			.priority = DEF_PRIORITY,
  6563			.may_writepage = 1,
  6564			.may_unmap = 1,
  6565			.may_swap = 1,
  6566		};
  6567	
  6568		/*
  6569		 * scan_control uses s8 fields for order, priority, and reclaim_idx.
  6570		 * Confirm they are large enough for max values.
  6571		 */
  6572		BUILD_BUG_ON(MAX_PAGE_ORDER >= S8_MAX);
  6573		BUILD_BUG_ON(DEF_PRIORITY > S8_MAX);
  6574		BUILD_BUG_ON(MAX_NR_ZONES > S8_MAX);
  6575	
  6576		/*
  6577		 * Do not enter reclaim if fatal signal was delivered while throttled.
  6578		 * 1 is returned so that the page allocator does not OOM kill at this
  6579		 * point.
  6580		 */
  6581		if (throttle_direct_reclaim(sc.gfp_mask, zonelist, nodemask))
  6582			return 1;
  6583	
  6584		set_task_reclaim_state(current, &sc.reclaim_state);
> 6585		trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, 0);
  6586	
  6587		nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
  6588	
  6589		trace_mm_vmscan_direct_reclaim_end(nr_reclaimed, 0);
  6590		set_task_reclaim_state(current, NULL);
  6591	
  6592		return nr_reclaimed;
  6593	}
  6594	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

