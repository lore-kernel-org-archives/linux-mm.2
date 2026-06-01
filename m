Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C6E2CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E036B046E; Mon,  1 Jun 2026 12:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF696B046F; Mon,  1 Jun 2026 12:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6816B0470; Mon,  1 Jun 2026 12:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 707EA6B046E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:34:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 261C41C1A82
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:34:50 +0000 (UTC)
X-FDA: 84831892740.30.DF3A36A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf06.hostedemail.com (Postfix) with ESMTP id 65DD7180005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:34:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=baGKUH2m;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780331688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=GvRWE2F6Kmj2JO/VhYzyDIuf7eJ6FjL7CjNR/ZQ+jKk=;
	b=IOKJhjgVH6j3SN1MaJMrYa5/swziwQ2mJjWznQNwjfrhW+sy3fra3wvb+XL7AhfPySBIM9
	1DwDizYWBauyTEyN3YoJg5L8eDaJNNYgseJIVp/1dig133brxgczohav80mSijv7lMeSVv
	x+vQSRW4GEVarYiMoNWO9oOYCWLO1yY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=baGKUH2m;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780331688;
	b=l2s4eDs07nyMJmpA9nFGFnXXkDHajst8T1/E2YrURA7lRExp0HtTYD852Nvhc62wXz7zTs
	dqKx1ISJV0wLIxs3/dGA0l0VI9XswL3P9O6IPskiJ52Rnvy9HjZT3FKBdjGLOFAur/vnNq
	HiDgR7df14sx8nokzZoH0v2tATNW9yg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780331688; x=1811867688;
  h=date:from:to:cc:subject:message-id;
  bh=2H1DY9K3cwezU2kGbNUZ/1sCCWUbpdwrcvsfR1A4PTE=;
  b=baGKUH2mCKjjBZ7Y5rTUo6Zj4vA0Tns6pH/3vexCh1YIMmU5F9PvT8q2
   0rjya/wqkp8hV+j9dZKQpPzHyzcKwkOfBkYWeoUyYp1Na6D4Heu/5+dZa
   pZEWHG8QH1pCh4y8EeE36v5JWluwFCw0b1iJFTWoxICyFbPjWTXFyU8DI
   6jk/iNxrtdkFvAINVMRUEAvGXB4/chVfOkkjlm+AHvLO2n4W7L5bJ/b2v
   k8oxB48LsEpk6Z/hoNelygJa0UUIGzgUOKh4y4HLX/ig77Ny8409fY4j3
   TSRZqentD+L+HCEgfrM+sA2lY2SRVQ6u5Yp3DjS/gH4AGtdZHSKFLRdS6
   A==;
X-CSE-ConnectionGUID: mSSNNYmLTkW3nVQZVnU08g==
X-CSE-MsgGUID: I9QcOY3yTAmFtTdU5BhVKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="106543562"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="106543562"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 09:34:46 -0700
X-CSE-ConnectionGUID: pDOr7+UYSOWGM0VbsdpfOQ==
X-CSE-MsgGUID: odw9bFdXS/GyOwGgzeuMrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="242573666"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 01 Jun 2026 09:34:43 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wU5b6-00000000AoX-21Xf;
	Mon, 01 Jun 2026 16:34:40 +0000
Date: Tue, 02 Jun 2026 00:34:05 +0800
From: kernel test robot <lkp@intel.com>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: mm/vmscan.c:6585:66: sparse: sparse: Using plain integer as
 NULL pointer
Message-ID: <202606020025.ZBQ7ncEa-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 65DD7180005
X-Stat-Signature: 71euj65zxw3z1tkrpeowhxuntmkogpcp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780331687-36717
X-HE-Meta: U2FsdGVkX19r/Rir8DU9hZfPjsV7JSdtCvU5SbKfJHd/rrKqAhaXr3p4m+TH09eumS6IOT+7Ta5kdGXEXw78qUj5+cs6dh0hJtiGyN3gim6vMDQ4+kEZOaFfKeg1mfpjxhxt6utwWH/74wGdNapAMattvMPZsm7sK+mJAMHk+XaaHuh6zLc1Mm+PYMbu8618t7q6q3Wmbrr3JYSBpw368rqhR1cQAkNelykTRlw4rmEK/Ev9vXNc0UUKO/Y3Vp9dIEVGcKS5bSOVNkeU5ZFu49VBAhRryYuecC4C82DhnjYIR+EWUJbdgNPnsNAzwDN9Uh3Alc87RiSZ3s0l/SUp5x069VnuL8IbQGqNJqFxerz0soLzUMqfTHQKJ07cYYMu0avZoP5OJ7i+DFIzsFZBRfFyumioTPvLJH+tv0w6lxJv+CZnwgQ1YPiyZ0X84v0BMU3JmrWnvAPtMhdQKBgWmcukPdhvbaYj1VXMEW1opb1WZll1DwZqBVYph4R+WDD7odrx0x0bOvr0dz/Au3mLUTwRgmG6yXiQ1addEyowDlMd5VVqqsxM07z+zERDCL/42eDo4C1V60MT9UmlZTlts5WaBzj5onJ4P3lBvs6BTGnejapIvrvzqukwlNQPasVqWi2VRh2oZAp9XLtqUIYCWoAB6WjBkOHk93rqkqVGf8Og74atYy5KfPS8VmIwchODrpevKASvkXyOzY+5YdDGmRNMg3JaZVj7Kwv3oisLrxDn65Sqqw7A1bZ0WbofqnYs7pxfqNUjIhyOiIGr+Md83JtHm2SJI2dDx9r9VyJcFWCmZNI22QA2zc0QDrSInc1hQkdSrS+Vmf+y5xsch8jDr60rVqj+z4jL98WEhUcEz68TFBrxhvDJVAUL8kIg0ezDMk4pOdp5eWYtq87b/FP2obXIlBYcbyXJ3/GSwqlW0SCWTqjrqVm9josd8kffzplVqUaXfCslEMko5ILlj8u
 YcRMG5pJ
 2C+GIdvoOGOnC6XxrAx7pGiI8HUX+4dCRfRYLkZ0TyFScD+Gsts/nMyzNnbxIAPnle9rge/Kei/Y5W+/y3x5x+YwsxhOkcxhdQ1D3HHCuGpNRMAxJf9UIIeKUwihSTZJeICm6IfNS634wkVa6WptHlSJmkdjprMs83CmBCfJzHLb0/BF+4WWrwWmuo4EylM8Ocrz3gzn0995TpHeQ0JaCkB1d1RMyiXayOGdYIH0tHWR9rPeuy5o9sAg+lMjcdrkXWsCwcGkDK3J5aMmiEhksMAKX8/Sqik6pHKMh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   e43ffb69e0438cddd72aaa30898b4dc446f664f8
commit: 874a0a566ede40f3d6062cae8fe1022e616edd1a mm: vmscan: add cgroup IDs to vmscan tracepoints
date:   8 weeks ago
config: alpha-randconfig-r122-20260601 (https://download.01.org/0day-ci/archive/20260602/202606020025.ZBQ7ncEa-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 12.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260602/202606020025.ZBQ7ncEa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 874a0a566ede ("mm: vmscan: add cgroup IDs to vmscan tracepoints")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606020025.ZBQ7ncEa-lkp@intel.com/

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

