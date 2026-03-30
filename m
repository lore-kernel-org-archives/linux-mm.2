Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1CDD1061B1F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FC446B008C; Mon, 30 Mar 2026 15:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ACD06B0095; Mon, 30 Mar 2026 15:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19B5A6B0096; Mon, 30 Mar 2026 15:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0601D6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:53:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 86A5B13BC05
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:53:44 +0000 (UTC)
X-FDA: 84603779568.28.3A57F3F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf07.hostedemail.com (Postfix) with ESMTP id C5C8F4000E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:53:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NNpxDpN7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774900422; a=rsa-sha256;
	cv=none;
	b=QQiGLwihRJS83D0RROXdI/GJD8sIe5fuX36VJmkeYWFlEUftluAxVKnNNG9UiuQ5vMGZui
	e3208RWU3xZ05tqTIqFHnaF9i6vPsDt2Th9DbmwwMsysBn4qEZrz8UVBa63BqZGo7yXv8w
	BXNqobLmnMn173p5fMD/ovWt1vZI9OU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NNpxDpN7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774900422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=TIoZph5MHsYhslfKZkL3xB2sIo+kyZD6Al4DUSP3hmE=;
	b=5ellqBXcvHPFfGV6Y6MKTB8or1mayOtuDRapOwMJnAOcwOH66LV6dB0sekH/a6cRUCcPZP
	pqSXD3R8ztKHf6Vq53LUGU0mviSyYD0fJ2BNpQlIMvgI6hWBv1TVXdxvBimGaiOPzxi/uw
	f0nGNzb9KAwjDO9uVRcFfkEbON4yRcY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774900422; x=1806436422;
  h=date:from:to:cc:subject:message-id;
  bh=nKoXvKBQuOTM4cYfkdF4CuA+2oWWAQe9LIraoay0Sxg=;
  b=NNpxDpN76gg3Wwc6SDBK5sFdTuBVF4H4mnfOFjXf7HKd6/YtlMIOMr4B
   SDsR5NIfTzkcyr3GfNgIPJSsy5Wy9hSIvWANCDM/nTyduesEd0FmPVL1m
   qBIYP+MoOdBdmnMHOZZRQBdft9Pd+VPeJsagYMOwrRGYyT8kY+Qy/HfGp
   5OVBbKsOchvmQShyP118qz/kS8u4aUpjKwITtB/byyaq5BscaK25onTZN
   mr33BJw8dGu6x703KnirCd2KFu6FYfI8mR19CjuAqxLzOG6KFeu+E3upa
   TbRFw0Pvegf7BLuOS6FU6m5PNAqNrDsL8J0n9ZJXVBBv5rHPyNc29EgXh
   Q==;
X-CSE-ConnectionGUID: qhEdaZbrTSiknf55vnXUyg==
X-CSE-MsgGUID: m5q1ikpRRl2ylKC1XfPWXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="76094696"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="76094696"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 12:53:40 -0700
X-CSE-ConnectionGUID: XZu//cFaRkKDBIm4FmWhFA==
X-CSE-MsgGUID: V51kk7GfTTq6soRmxdEGvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="249366647"
Received: from lkp-server01.sh.intel.com (HELO 283bf2e1b94a) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 30 Mar 2026 12:53:39 -0700
Received: from kbuild by 283bf2e1b94a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w7Ig3-000000001cP-3xPj;
	Mon, 30 Mar 2026 19:53:35 +0000
Date: Tue, 31 Mar 2026 03:52:49 +0800
From: kernel test robot <lkp@intel.com>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-stable 86/300] mm/vmscan.c:6585:66: sparse:
 sparse: Using plain integer as NULL pointer
Message-ID: <202603310305.xSA9Y9fh-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: mgj883dpwkgh5wjpcg4sjanaxkncfscz
X-Rspamd-Queue-Id: C5C8F4000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774900421-853393
X-HE-Meta: U2FsdGVkX18pM4oqU0H5f/SFHfm/4JCLo/Uqde3N+6AVYcpQJVmYAG/LLhhKk/L9KnX2e4s5gNSnm1gN3AYPLQbfAyLxip3OEW2RqK+2gTU0zv1GZcjcp4FySdtHwo0nAUnwDTmW310/CVqcfHvUwsptIDp54d8oOHg2bo9BICOJxRESVF8M+rnM7sSwov7SiAZk/9TILdAM6ljlDrmc7SrfTojx7eUhnWpGeQyYuwwYeXBVZMog1jeI8SX1o66dHbUtz/Gfv3J9CvPlIINUGnDRDUERdAtgXPaW6NSpMfhhvnmtHqimjU+Qnw8AODe4J8VcAaJVEfc7qmzk+3YgPsJkyQBhYhnov7Kg85S9SX0GN5Qhs4j7wNCM2LYTQW8hq/wpNI7QW3Lj9OgIyqe3Of+Skiad8xS6osYQUK9GaIWng/Ou4Hvpbm5TQWCcavLVUCmhuEQPEEnIX5WcFD+VXs7PYTa0iHGSK2VhUZRUBG14/0YnLb82EyJKnA7k5dmvP+HN4woUOYP57WhUJbP0yG65bAt0GvaI8jzu3Mg8BdLTHzrUvG0XVu3ZmAisrS0JxYfdQySYQOOIKZdxFRLmtbc7unJcrLpy4iKEJ0e9YqB3mHvmtNDUmioGimJKFLKgPtJZUhMsUMThKGhkhg7oiScLGzWbLu8Q0hQegHGbIu3bTeN3J3+sRDLHVlJqeJnjKGiJSk5mqwkwnzUiVEhFoDqSMphOcK01uKaVEE+ltaEfoxLnNKD7wTjwIbUJ8XuIkJPhQwUbZYXPu6Yx40sOHshNTcqxQp6OfPloA0j/HxlzB1Lz3B4rOobAmjLQAti6AY1GYXSE+pGnDVxZ5GADl3+Z5GOl015Rfz+mF5VvHCbi2VtbzWiorAltQ+2bMLSj2thnUMOr38NDDiKFBpGY6pJ0twOGJbgvMcWxkzpmL4+UM/TdFncToEMpXDFEaraSyunk/DyWa6OOT4cPf/H
 9btockH/
 YjnyQVAtDIXRRzZAJ8deeSAaVvJpNLqARu/HPhvq4+zbLNiR0IkFmPMOVd5IOPS3daNLjBe5mWko56nqUOwaePL0dFpnE4zODxDSxIbJ3XxD/idgeDg2WzFpEcMNQY3C/xgFx/llM26twt30nMt5/JNtMgEpamKgmVNLyD4tIRgoHJRuKU8RrgL7PMNFOwKb8eMp3cXWMoVavK1v9opL7D8UP7DXDUv5NPaPzYtqzhclRfr820brZSM/xyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-stable
head:   bc2e0d3bf965b1ee6c09b104447158725b831d84
commit: f9504d82d9d52bf557e87dab204fac4d93d53360 [86/300] mm: vmscan: add cgroup IDs to vmscan tracepoints
config: alpha-randconfig-r122-20260330 (https://download.01.org/0day-ci/archive/20260331/202603310305.xSA9Y9fh-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 10.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260331/202603310305.xSA9Y9fh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603310305.xSA9Y9fh-lkp@intel.com/

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

