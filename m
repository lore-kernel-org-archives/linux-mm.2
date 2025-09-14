Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80AF8CAC587
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 13:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5C0A8E0007; Sun, 14 Sep 2025 09:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34448E0001; Sun, 14 Sep 2025 09:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70A38E0007; Sun, 14 Sep 2025 09:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B61BD8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 09:55:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DD741DCFE5
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 13:55:16 +0000 (UTC)
X-FDA: 83888002632.30.5C22718
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf16.hostedemail.com (Postfix) with ESMTP id 683A1180006
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 13:55:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lGh3vpR6;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757858114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39sYhmUjXM85XEA1urNdAsqDuvHH0nawtYDD4ElEZhI=;
	b=jRJOE3a6LhLiYQHrLn9nRMYP4Pkiu/cMBHbR44U5H/2ax292RDSVYo+krr8kh39pIWiYpf
	8fLt0X5p50N231HUt2zGAwN1J6vV1PXRV0nAC/aYpHdBMEnwg/R4TSoQ6L2HZdPuBnikOJ
	TUNcx3I3B0ydJiBmDcBn0ujYK8eAD20=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lGh3vpR6;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757858114; a=rsa-sha256;
	cv=none;
	b=TAncePlc6gd7NF7DpiocfUn50QYm6v486UMDgh/F+4k+KGdDVmqlsdfn+maEr7rC4khAvC
	UIKrmAjp6OXghvW3jJBWcKaDq1PP0grFjBU4zCLNWPxqTkhkEMxFfKatFz4mzTnaa1NX2p
	BAu5QTElaDm2H2ovxlzJXtrA39Rh0ng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757858114; x=1789394114;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yAOoUPFw9dHD3qqCEAFNjt0DzdHHTrnt3LHkQ2Jj9wU=;
  b=lGh3vpR6D+slNMX0Cr7w8rjiTZF6iwgTAizJtVrdidse6gu9jVJQwOj5
   lDanWZrE4uHHgGvisuAs3hTyc9ZE4E+1LTuOPkdDLjCUMc9oIalVLqFa8
   4mrMgg5gAx3m0KCG0zOBRaopZtnxgtBZuxTiSUNVEB7RBLUnSzaNFIXnY
   ztFSsCVBqd8zdSfCu6xrxSjQJUgxDbYQHo5N6muwF4/H/NcwEQYqT+Q7O
   S9GBVjTfL+s7iUV7uwvp/WjDX1mX+iUff6CFZB4wge2cIPa2fpw6OpFa6
   1pidmwp5YdUUiocqhagJbD37yuGk3J6Ez0HXXSdh81N0YapKX0xVohmeH
   A==;
X-CSE-ConnectionGUID: E4Ehff3hRoGbYvVk1/ujZQ==
X-CSE-MsgGUID: j9bTkYaeRNChdNmHAmC9kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60048151"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60048151"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 06:55:13 -0700
X-CSE-ConnectionGUID: wIPbWldqRJqDW6vPQtA66Q==
X-CSE-MsgGUID: ErIUcXNcSKe45ZSx3eHwwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,264,1751266800"; 
   d="scan'208";a="175200651"
Received: from lkp-server02.sh.intel.com (HELO eb5fdfb2a9b7) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 14 Sep 2025 06:55:09 -0700
Received: from kbuild by eb5fdfb2a9b7 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uxnC6-0002Rw-27;
	Sun, 14 Sep 2025 13:55:06 +0000
Date: Sun, 14 Sep 2025 21:54:25 +0800
From: kernel test robot <lkp@intel.com>
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, shakeel.butt@linux.dev,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	david@redhat.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, xu.xin16@zte.com.cn
Subject: Re: [PATCH v2 1/5] memcg: add per-memcg ksm_rmap_items stat
Message-ID: <202509142147.WQI0impC-lkp@intel.com>
References: <20250914180351288rcLuZnPAMUej48nuTc7KV@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250914180351288rcLuZnPAMUej48nuTc7KV@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 683A1180006
X-Stat-Signature: j346umhx1mdiwpfdwhkainrnejambcze
X-HE-Tag: 1757858113-442193
X-HE-Meta: U2FsdGVkX1+1MNMVqitGH7YdHke+C6+RQqkudY0ZFeWdXFugLzx4ySqnydPcYuKPpqXwXq89YZfznfiN/3B6AzmOImtMDe4K18VAjLYtlphzjp/bYwU6cNJmTbBT0oBHtFB6nsRbmZ9B1eZxCFmZ0Z6VRJvBO6BMxF/0eJk7qw6TFzd5GBXcalYyhXPx8SIXfi7lcXoPYRTaP9uCJ4ngnRnhHUjNVEcoQHfdqR+UZ5Np13YjuMChehgUQY+6wrm08sftrsR8rQJmjOff0X2GYI3T3QLDYt6IL04wqNUnXvBAm0ZX9d9OKiGOmyTHEC707ieqPIjREvDbns8fFkPTAJx1lhpMgeh0D6WwwwU9C0iehBOf0+NgGujNFXrcPt8enTwa9ddp3QeGdpWQsJp/ZcZiurhXKAHAjmzQi45pDPdMBZQUkHpHjnF5CjAD1aFgcKjQ6zFL+vau2UVwSqGOdaZyZRJF6W4GMr4beVdmcmfAqm0zQ2Mklid8kn5WHGtbGDDn839NdKKzaHLfxHo42bR60UpgzI7Cs9n+cRMFEmPLb3+45taiMFC3PRinr+0mBzC0AfwnGUSWT/2etlxhOc8C1rB/N5o1tS0VvuUxZJ+gP6Y9Erjnkzw/amNtT8uucYUgovdbhbo+q5Kt28xtRE7qPSayX0IPRi/Sv4ZsUPo/uEpf40p0k4oTubJ+ct3Pw5JWwtAjlYEKXdTXapfKFH3lDeWHa3l3UM22irpeYvIWPymVl/237fJ//RbM7sYW8GEDggbt0h2TbOwQKDW7s8YynZlW5zMaz36RHxFFcRE0ARuWARH+i33JGSF2bB8aL8J5LPSe5+899jHN4W9O7Z9kHg7nF2c64LRWLZPf1PnGtxIbJC90t2TeWLIKuxRpdoyAfomDmddMSPyu42Km5CDlcSxp7cxbyinrgpujEtx1e8LT9ktWpGzgenFBAOUeBqcyDktkUHr4q4fOSgM
 eaAjxZZF
 MFFQkH24UEX3gW+ixNnIvaaRwC+VxH/WWHhf/KWVQA0Rd29osgPZe7tzN4Ii/GqzGFdXYppb1Q7Pd8GyYQTwhPSm7ZTBuCfILLWjc2ymhr/ChuPC2y3tfTU3wWlKXSVRIPLO9JxZCReXcPIPEa7/+EUDcN8mn3YM6nPWb7pJG0G77PWI9Sjlj5sNHTqmo5DKGkoDHXSowNr1lw+XqsQuYLJDqlC+pAhNakk+TFBIm5u3v6Ga/xDvpS6WtcDC/9v0Ahaz5qxnfEvVTTX/UiE+Vi+Otf7aKeqWrbkxxafVWNCzqdSRmLD5bKSHC4gzoKkriqsDA8lR3XoypLOQU6KQpytye+GFknMEC+VZ+HWxB5fu5zRVBb6GAUmI4xb5mEye0BUMTPzflxuaSftl07ZoOqSD1hY9tOWGfvKMQww5hIMmp49A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on tj-cgroup/for-next linus/master v6.17-rc5 next-20250912]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/xu-xin16-zte-com-cn/memcg-add-per-memcg-ksm_rmap_items-stat/20250914-181132
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250914180351288rcLuZnPAMUej48nuTc7KV%40zte.com.cn
patch subject: [PATCH v2 1/5] memcg: add per-memcg ksm_rmap_items stat
config: parisc-randconfig-001-20250914 (https://download.01.org/0day-ci/archive/20250914/202509142147.WQI0impC-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250914/202509142147.WQI0impC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509142147.WQI0impC-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/ksm.c: In function 'memcg_stat_ksm_show':
>> mm/ksm.c:3345:2: error: implicit declaration of function 'seq_buf_printf'; did you mean 'seq_bprintf'? [-Werror=implicit-function-declaration]
     seq_buf_printf(s, "ksm_rmap_items %lu\n", ksm_stat.ksm_rmap_items);
     ^~~~~~~~~~~~~~
     seq_bprintf
   cc1: some warnings being treated as errors


vim +3345 mm/ksm.c

  3329	
  3330	/* Show the ksm statistic count at memory.stat under cgroup mountpoint */
  3331	void memcg_stat_ksm_show(struct mem_cgroup *memcg, struct seq_buf *s)
  3332	{
  3333		struct memcg_ksm_stat ksm_stat;
  3334	
  3335		if (mem_cgroup_is_root(memcg)) {
  3336			/* Just use the global counters when root memcg */
  3337			ksm_stat.ksm_rmap_items = ksm_rmap_items;
  3338		} else {
  3339			/* Initialization */
  3340			ksm_stat.ksm_rmap_items = 0;
  3341			/* Summing all processes'ksm statistic items */
  3342			mem_cgroup_scan_tasks(memcg, evaluate_memcg_ksm_stat, &ksm_stat);
  3343		}
  3344		/* Print memcg ksm statistic items */
> 3345		seq_buf_printf(s, "ksm_rmap_items %lu\n", ksm_stat.ksm_rmap_items);
  3346	}
  3347	#endif
  3348	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

