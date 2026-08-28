Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC4CEC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 10:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE546B0088; Fri, 28 Aug 2026 06:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7136B008A; Fri, 28 Aug 2026 06:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02D46B008C; Fri, 28 Aug 2026 06:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80EA36B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:25:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B16D1C1AC0
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:25:58 +0000 (UTC)
X-FDA: 85150297596.09.7FA9426
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1D0C940003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:25:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mvaIq11x;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787912756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6VGjoXbQ2cLJcxsPY6sgHuhsBN/VrRinMPTYaSAwow=;
	b=cC8JP2HKbtiwEJ0X5m0XdAequUh8bLJKwy2lGMmWrDWKl5jdG/YAuRuR9ogKXYzwLz5k5Q
	Rx/tFIIeLCnjIq0ZrJlTONUWXaUAaeNgMdEfHs3pSykwFdgHwXfw1nDCENxJkSOf80gaSi
	Buk4JXnL3B2Gu5Y5ilVVaIMczWOFd2A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mvaIq11x;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787912756;
	b=2lDGw8IswCA/LMKuMUA8XQzXor6Jf6crSi2iCmtwz8zEQ1z136bUQoVOwRzJvzX6NlgKiA
	BOvpcReOxj2LBHw3sEdWiJf5Hz0swZmao1PB7SrO02DZfENUxhAiA2JYVYAy4D6HpyKwg7
	47Tzxa9wsJ+lRNn9CoqCM0zrSUvPla4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787912755; x=1819448755;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y2hbqMERCbiubt7BDkFMXl1dBTo5MssDHay4qoq9wxA=;
  b=mvaIq11x+Tzfn8ou43KXzk6E0tAw1gYelewT5qq8XFq5eNA1hx0HKcf1
   xPsP/8dlttbaRh/egmZtlKPDcPVPhLMtCSpuPLeMlho7j2ujRc2cEr8aY
   AjG7UMavGEN4brkjPR9QkNBzKnQvQeu8jnKgPQfA2MV6ISc7QxrQNIc7V
   tHTiNApwjIreT+OzIueX30SorgCBv1cEvSlSUYucBOFiQ0prkIlaEkT/m
   vsv2hovQjltgmpji0y1fISFRtdp5NCzxNWwsMESICtjDfM2jxOc8Hj/pr
   GZdJn9cb1pdHn8twbuKabY2JCL9cOShhLS7h02wcrwHNp8CpAwP4j1kTZ
   Q==;
X-CSE-ConnectionGUID: grwg9X5RQt6MYwLlVsV6kg==
X-CSE-MsgGUID: BYnahvzVQZuiBP3+8SX33g==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="99580839"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="99580839"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 03:25:54 -0700
X-CSE-ConnectionGUID: 6SUyTDvTToGtt1YkFVWwbw==
X-CSE-MsgGUID: xaSfKNblR3SZYeLPnQSyQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="273380978"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 28 Aug 2026 03:25:51 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wztmO-00000000Ar3-0FNM;
	Fri, 28 Aug 2026 10:25:48 +0000
Date: Fri, 28 Aug 2026 18:25:01 +0800
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
Message-ID: <202608281724.4MTLH1h2-lkp@intel.com>
References: <20260827124211.3b94b103@fangorn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827124211.3b94b103@fangorn>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1D0C940003
X-Stat-Signature: rfdqfac9jb39bg5bybdfa1i3db1fw68d
X-Rspam-User: 
X-HE-Tag: 1787912754-341845
X-HE-Meta: U2FsdGVkX1/eDA7ZlyI9BFR41A7lSHAkO4S04OuVdPh6iLHtVkWIW6cWry9nt4bnPAhIkaNwKGS1X1hxjDseg1uYvfRaEyEBDEYaLQdbXA/g7Xd5Th4qaOc7ia252HcwxVDsw+emAGtCAYW/ypM04Dm6qf9rcKHUjt3bcZM7yCTo/K75Yndq4ZXuC3peB+4ittm8lZ3OGaTuApIPScF9sfTFGPbaCC3S4cqQAhBc15f8sLG956CziGYNJGwUyUkLJdvP7mPr2TzzvXNKlbIlJl56UcYeSJOsGuFsFT35EZT2bIrD+wbYBKkYIsaTiW57NY1lkuHUgsqiNfu4J89t4mp6gQKf4WH8RZp0s8S2jYhmaQq3uRmh6zkpefnc941xA8hNOegvBvfoOJVRdo/ny/inU+rKbN6MqG905+gLaiyy/uHF8kSjX5/eIJQ9WZAg/g9LUzmqwHkr16b7lF+7slXeDR0zLP9lbTcw59X/RGUtpC/JrDAeL9G4gpSkhPqqSn4pW4At2fazkNw4eEwYCNh8fDewuoYAgJ43B9d57qnAbpmlhLmI2X0zfINZVuIcJiYhZ4iLItWANDpma0WMYXwzBlaTaI8EfZwWpP/yrFRvc+t/tR27o/J3s+Gjv8gebS3cu6uEmMZgNIFInDt3YDXV6X8N4utl5/b7hdTDV9R4v39lnK4HxsgdMjfIpfbQzRZ7bzAeStKM1KlmrMPVfUTs5tsCCMs38S4ZR7n9txj63+gBA/LGgiq0N1m1/UEWhNTaHulPPdEkPc4wI1dkIM/OLpo/4MkSXIvnWLrPjq1uDknACPQRRvX9EF8DfLPWWcMQYCu6+lWzUgwOICbA7ysB8mrsP/S1f3F5hw1YtD4l62sQaQiXBkv32Az+i8nZRFQzwNES9FE439+ZUwdZx5kEw9rCFuswZKVsr7C9mAm9i2LEFkOB63wXmGR+fux7CKOai/yU6hDfCwgR5Es
 qd+cPpCt
 JHUiMAnKXJAyFZ0rX/JP1hjGZKFNXuUjSTqLalTPjtOhjEN95f67S2YAu5OkPw2jBw4pP1BSe0WHZGMUkpITjnfNDp5St+Om1jwWgIpwyCE1OKeY+RHPInT68ufF44f//9gvmo5l5B3NJ1j7hGF/A9nkx+T18vB/E8+FJ0jvpVveFMxbyTyHKYthwCdDzQ8MGQg5YsekU5hlmijCVSgOITBCmEfM6VRBYCWbJ86VqbFuNRN+HZBD56l6xBYsDpYXPtDESquh45XjxQcQdyTTMtNL/YSPDQK+u0cVPrLhmB0LgvYq4cX40RjzPj6J1bPruGrOsuIQvWJ9tgxJ3nKuQ1a2EzLwFNwT1K1GWvA/huTQOgtPEEfMTC5Wa3g==
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
config: nios2-randconfig-r121-20260828 (https://download.01.org/0day-ci/archive/20260828/202608281724.4MTLH1h2-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260828/202608281724.4MTLH1h2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608281724.4MTLH1h2-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/memcontrol.c:2380:6: sparse: sparse: symbol 'drain_all_stock_sync' was not declared. Should it be static?
   mm/memcontrol.c:4678:52: sparse: sparse: incompatible types in comparison expression (different address spaces):
   mm/memcontrol.c:4678:52: sparse:    struct task_struct [noderef] __rcu *
   mm/memcontrol.c:4678:52: sparse:    struct task_struct *

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

