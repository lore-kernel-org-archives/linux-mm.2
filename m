Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4BECC61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E855F6B0095; Thu, 27 Aug 2026 23:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5AF26B0096; Thu, 27 Aug 2026 23:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72C96B0098; Thu, 27 Aug 2026 23:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0BB86B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:23:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 312F4160328
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:23:02 +0000 (UTC)
X-FDA: 85149231804.02.99CFF5D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5270F100003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:22:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W20GYDEL;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787887380;
	b=jQlR4d7+Y0qQMUwpPqyrN1Ki0+YPRJ7bH8M51Ibrl4J1il4y0KrHcq4MQo0gUPb1lAuOaO
	SXRnzgwspNOTUKLsGx8dvP62H5XPiyrejjX6GfOEFJdpUqrnYSyLgDp6rE0W1sQcaXZzdM
	SkN5WsVWhMTTO3dvlRgS3ynKGkoqNCc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W20GYDEL;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787887380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYGG/qn1bkT7jeUc1EAHG25neqV4ZE4YIPkAqOb42Rs=;
	b=eDk2uxvPjNLKnGS+jKNlvXvWTqDxs2V9LBtkdcEQwNdHAmQcDmTF7RvpGxBGChOZ+wkvEf
	SwTc2Wb5WKoHOQhgrv5YMVrJ4dXm2dQJOI9RUzvuY4dBVRCp9C+KDez7PTZXymj8PjxkXU
	tgTqLKv/2hehQp54qReebmyAWSOB6dA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787887379; x=1819423379;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e9hRHQ6aFzR5cn+38V4JJ8FVmkjRNBrpiy92HLnfLew=;
  b=W20GYDELMC0Ois0dZjpGq9cAf+ZPjawInxGqOp5IiaZ0k5wkDaNHLQGx
   oRIP1d+wRMgkcYoBu9p439P/QiVELu+6AijrdGNISrBy2qKE3HfPcOxkb
   al+tzt2000ZvRQdBxDCIsbVd9301B/OcKOMxoFGbOpd6DzpOdJeTzRla2
   NahbgEZihUgOpKzTnIHfmT2uLRNHf2PYeclwyxTIJMU6RaNt7sUNgANA1
   gwM+sIJ+cK40ERZDEebAXk709UPFpLCNILXR1KliE5JPFbdOowt+jjCzm
   3UizpL+QfknDZ3/gC/usYq7GGCZ220+Y+peP3iZjHlHF+I2vsQtoH/NPN
   w==;
X-CSE-ConnectionGUID: to74gWemSp24r8j4aIO9Ww==
X-CSE-MsgGUID: wAcitDbdS6WPERk0uq0WTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="88518145"
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="88518145"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 20:22:57 -0700
X-CSE-ConnectionGUID: bIY3IgiKTmi14/iipIiR9A==
X-CSE-MsgGUID: Q1F7nL41TcmvXhXm5pucxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="266231271"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 27 Aug 2026 20:22:55 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wznB6-00000000AIb-2U06;
	Fri, 28 Aug 2026 03:22:52 +0000
Date: Fri, 28 Aug 2026 11:22:03 +0800
From: kernel test robot <lkp@intel.com>
To: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: oe-kbuild-all@lists.linux.dev, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during
 offline
Message-ID: <202608281149.3OqBLtQa-lkp@intel.com>
References: <20260827124211.3b94b103@fangorn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827124211.3b94b103@fangorn>
X-Rspam-User: 
X-Stat-Signature: tczg5um8nyi7tjxhoyim1i9enpc9odf6
X-Rspamd-Queue-Id: 5270F100003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787887379-313090
X-HE-Meta: U2FsdGVkX18C2uNNkCZIqmzwFxmkgOyR+66649jHPVmB8tX7ysP+PJnskpHoMMFw3jkCys8nHdqGCyoLWBIkZSMapZhUWjHI5230dT+iSnnBQGzodMIcDwoVVMBP23D6GG/JnITj9LAt9zrV8wN27SJHDuRUCVpNCfwBSZmIS2neYCgJRH/WLsnHlhaELdjIoFIFm5OpN7XLgleQCIYuObmYnC4bEty7niyREwWpCTuENpsOaY/0KiD3t82Y6ntYblTdF7/F/y6hGEUiHwkFWbo8ex0CFrgn18lld+KWZtVh+mw4IAxn1myH/wjaJAXq1qGbUUG+4j0Hljhh/sLFtwyy6M3Q/RcAa0kZTVdZjdTn7nspQcrFilP7s5v0Kp6yYONKt0lQoCNzMYu+bX4Dg1iou8sUGsq44+jDpmo4l9AUDaUncbjPZXzm+b3z79SP5MOKEDstekruAs9CQ7qijJQJTX/eDBVkm4o2zGtzFaI4/94DpVv8lTlYrMhhSH1AavHPrZjnhwr0mvFZdLvn1cZEMttXpu6DUwmid2cVa6AhZMlqFgEOhnmdzLAj0z84bO8gVhYJCyECNvWJUOgydN7Vk7ckgTyayb78mkpajPWxkUB4i24WRZ5mDDc0Oq+rlWj0EUR4fRnshSByXOCqqr3pyii+57fadKt52JiF4y3Kkv7SeLLC4CUn2MWtJTUVaKSZM7JwBG+F1G7s/FZ5aO7DKnqVaosGDz6Nzws/DXTWsE54oPumiAAgDGBc6uU79C4Lt7p/JR/bTino5qoEjpTcDlwZbAi6S6gfNNFj6h7Dyh1e3VHaFRIrvjVziJRuyaJ4ILFoMMU8XSDZlQ9EjXHeQuiZxNTh3Phqf0l18xQkgqrjEKvJEhK9gTkU8q+k3HHnWMts1m+A9IATpRYYALTQmLQ0xhvgbRbbWfpzOIuxtjkkK+Mw26gABTNRFyW2z+y8AuVjCkHd3zM4fQj
 f0IW71HX
 gjgGe4itdBBn26IshQZKYRjBN68bgsvDyovJmeFRxRpmev8LjWYFsGizeYptktd7Mo4wEwUlgWZ3cOQgFoFQUihBMx1r5D6oDK37x05oM/ZGw7SKvzhiI5iCH15yOHuug5WgQKAPQSq/Uz6AFzZG9VR3lN0Ntw3Yn1LDNlsHNmzU1A1GhSWD69yzQitM/PzFo18aEy+zwxOlyJIoC3B6gAyvTg2+eD5UDcBr+ID2mEWV1cCzni5xy7T/AbqwQJRzOlQfRuOIVjCKZSXzZTlRUmd56SE/AtdHZCEbMCkNiWS/VQGAfxV5vGjo4Q5WcilUbyO1T6zz0WDYRTIp9FpoucxqNXQ5EwPpVIT1MiVOBsPYISWSpl1bO/1fkC8hfE7JEeUXj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Rik,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Rik-van-Riel/mm-memcg-fix-UAF-in-drain_all_stock-async-work-during-offline/20260827-124211
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260827124211.3b94b103%40fangorn
patch subject: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during offline
config: xtensa-randconfig-r073-20260828 (https://download.01.org/0day-ci/archive/20260828/202608281149.3OqBLtQa-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 16.1.0
smatch: v0.5.0-9187-g5189e3fb
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260828/202608281149.3OqBLtQa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608281149.3OqBLtQa-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/memcontrol.c:2380:6: warning: no previous prototype for 'drain_all_stock_sync' [-Wmissing-prototypes]
    2380 | void drain_all_stock_sync(struct mem_cgroup *root_memcg)
         |      ^~~~~~~~~~~~~~~~~~~~


vim +/drain_all_stock_sync +2380 mm/memcontrol.c

  2379	
> 2380	void drain_all_stock_sync(struct mem_cgroup *root_memcg)
  2381	{
  2382		/*
  2383		 * Make sure the workqueue is done with this memcg
  2384		 * before freeing it.
  2385		 */
  2386		__drain_all_stock(root_memcg, true);
  2387		flush_workqueue(memcg_wq);
  2388	}
  2389	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

