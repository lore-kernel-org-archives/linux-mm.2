Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BDCCCAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997088E0002; Sat, 20 Sep 2025 03:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96DF88E0001; Sat, 20 Sep 2025 03:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884978E0002; Sat, 20 Sep 2025 03:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 764668E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:43:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 156035BC7F
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:43:37 +0000 (UTC)
X-FDA: 83908838874.26.DA18F65
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf07.hostedemail.com (Postfix) with ESMTP id C047740002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:43:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IlPScb61;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBObrCn4XZx1/P0m1jdTJfM2Yl13rGR4Nq+3JtF4MAg=;
	b=BbPaYvEusvu5iX5GVraezbGGtOaKr8m+hhVfoEpoRoQfe3fhvboDqgec9CfT/MOB1lp6Cz
	VWN1y6Rl85mmmoOM3xKh9eFVYfWjmCsL9ywcjkeuy+z+78+Z0tugitf2uPS4q14+pUISOH
	aCf+Af4zJ8BEpKG+Fc4xEqdpGW2GOWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354215; a=rsa-sha256;
	cv=none;
	b=KNfWlbYPNGYxmkTBvUjBLphkMxLo/wxQKE+iGjuCaV5vD5FF44tTgXvDgfGKje4nK8PCq/
	W38U86iKbvlCGJGuafwr/WnJoQmWMMV+6dq/h28j6SIFRpDFGWSYtFFv+sDVUKAdOSAVsy
	YaktNpYV2n71VlQJsFaDOYThUghFGzg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IlPScb61;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758354214; x=1789890214;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kEwh/ekCl/otnpe61Q+7M++Qui9Q62NvcImp583uS/s=;
  b=IlPScb619/2aJVxApqringmc70KsGi8z/2TIqY57A1+Vil/qCXJ+K0Lt
   7AXX5HHEMou3RzzFLb41pja0ACJPLOiuK6e8Ds0sm3UXzCjf17PtolqvU
   kSPG0SzYCD12wh+mISDc39SNMa5ln0JCeidQaa4svhr/ZhlKPJiRgXNuQ
   b/iFeVssdsOj6txABc5vEnF6Eujau0P7vqprEEE/H5IHEIQEbrXHZ4MhI
   2FgQilo5rnjmEBOntazY8/vYbJi42TVmJoloY+wlF81VhMPAaA39WfZfc
   oaTQitaZi8Zor1j8y+QGG0MlIRmKfNf3dEU9g50n3xaeCnaLJ5m9OXwEQ
   w==;
X-CSE-ConnectionGUID: H+eV5hg2SguSvlNaztTvoQ==
X-CSE-MsgGUID: Rv8kNLUHQl+Iher5VUVTTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="71798365"
X-IronPort-AV: E=Sophos;i="6.18,280,1751266800"; 
   d="scan'208";a="71798365"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2025 00:43:33 -0700
X-CSE-ConnectionGUID: XhG2d+HRTmeSVCMqd9nXog==
X-CSE-MsgGUID: YTridhCOTma5012IF8a9Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,280,1751266800"; 
   d="scan'208";a="206968748"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 20 Sep 2025 00:43:27 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uzsFh-00058h-0d;
	Sat, 20 Sep 2025 07:43:25 +0000
Date: Sat, 20 Sep 2025 15:43:18 +0800
From: kernel test robot <lkp@intel.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>, hannes@cmpxchg.org,
	hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@redhat.com,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 4/4] mm: thp: reparent the split queue during memcg
 offline
Message-ID: <202509201556.QAvYX4v3-lkp@intel.com>
References: <bbe3bf8bfce081fdf0815481b2a0c83b89b095b8.1758253018.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbe3bf8bfce081fdf0815481b2a0c83b89b095b8.1758253018.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: C047740002
X-Stat-Signature: zd4naywj5r18x6qd3hiez7me6xo5cpn6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758354213-381001
X-HE-Meta: U2FsdGVkX1/KcqBkxHFQLhKeASZF+An6zeTbKbyY6SgdljjELGtLppFXouYJEg6CHZgz/6UYmRqKq6ThENxSCH/UuuDJ6oHPY1ux8RdON1dyDPxeXIOArgFMDKuW37i7GuwFvSqBaGz86RvkarLhdusSZWg62u7WxKw0GOP45sjQj9hkDjb4bLkFfpdEpcQezjMA0W6Ho02cEk/ZY23X4HyEOyxYfs0+LOLyHqcmN7i9rkcMRj8Xk88jq3Yd8IJphuwgFDRmRA+ItJbVBw5hVyqLNuVIK+09IefuG/Lej2mv1xM33SgDxz5f0C0790SuvPofEnAXfksFs+piIITkoX9yoZX1L1lvYiyCEzsHNpGuy0v1u2yQCm7YqpnAMa9nCzmhOc7djO86qM3Fy0TG6EXS0pPrdeLnYO4AvQwRdQIqjVDAKo4wE/VhwP1xTTOLTJc7GX22oBfmn4D/f17sbBZHAreOj6OfxkxBevy+Jk3FBcUsE5h3VXuRxA3UXU7v8iRmOoSspdUZ+BeAKJw7lrv93C/KKxyHGZtGyAyw+B7AbwONDL8jvSD/92Exo1oux2PszruwKAxNFhlvlVbpBIXTX+gwlHEMnP5VNWL8tjj3r0jI8Hv06HRu0chFN3TNcWvZXXgWYgK+bZvyQL51/VbwokwUg39s9vZpP36VxZNUgiqAOYnc11wZxUmp17lIrDxE5QQ+H8EvKwHl//eRI0C0ZTLtKK7w5VshwhTKA9Bd0QC5sJv7zhDbabsQ78qi5VCOqu3P3JZKVG2pb8zLmyKBs80VXsO0MY8Uv2UeqtdyP1dUomqRgb7++o2eyXTRH0swDeUU4grXLn+yc8Sr/JvuUCmFTc2wVraIGyradkIowPDjA68MbSnLFcNseTQifwWaIO+093zlh17swO0rfUcFZE7Qv0TH/8dGWHoUc9tN0QfZPfQA4IYowwG7BhJpXVCwWL4PL2N0Ei90kXT
 ToEz+kdW
 DODEWgkmzM8hbb1qEtCKbAZrQhEqioyo/S/tXd2+Nw2DAzRPMVdViUJI/A5wDtchpF1Z/MeCSX5z9kFK4PEly3USsaoM2fuxHARAklusUNzTK4lc2WHkF4WDn8mJAWYIAwgKNs1u1/X3bTl4lMGuOm0WSyFVjegGor51rAj+uAarmh2fbikUhrdYNja9gNyeEhlY1sXe2igt8iPSje8MKjGsy/V8pRaghBsbJP2PrNknyuMEudHng1jwPPWvZYZ7Y1CCMmMorYkrF2LkmBLT7t4R22Hz39GX7aMYZbKFjhdDD1fI1nvxuzzJgkA6MdIAEEnLdauB6FF7N1Nm/uzHcbc3G4V3HfQEGzrfpbkZivUsAAJ9FYS1Kbey30wdVMYqCfgMw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20250918]
[also build test ERROR on v6.17-rc6]
[cannot apply to akpm-mm/mm-everything rppt-memblock/for-next rppt-memblock/fixes linus/master v6.17-rc6 v6.17-rc5 v6.17-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Qi-Zheng/mm-thp-replace-folio_memcg-with-folio_memcg_charged/20250919-115219
base:   next-20250918
patch link:    https://lore.kernel.org/r/bbe3bf8bfce081fdf0815481b2a0c83b89b095b8.1758253018.git.zhengqi.arch%40bytedance.com
patch subject: [PATCH 4/4] mm: thp: reparent the split queue during memcg offline
config: x86_64-randconfig-004-20250920 (https://download.01.org/0day-ci/archive/20250920/202509201556.QAvYX4v3-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250920/202509201556.QAvYX4v3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509201556.QAvYX4v3-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/memcontrol.c:3890:2: error: call to undeclared function 'reparent_deferred_split_queue'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    3890 |         reparent_deferred_split_queue(memcg);
         |         ^
   1 error generated.


vim +/reparent_deferred_split_queue +3890 mm/memcontrol.c

  3877	
  3878	static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
  3879	{
  3880		struct mem_cgroup *memcg = mem_cgroup_from_css(css);
  3881	
  3882		memcg1_css_offline(memcg);
  3883	
  3884		page_counter_set_min(&memcg->memory, 0);
  3885		page_counter_set_low(&memcg->memory, 0);
  3886	
  3887		zswap_memcg_offline_cleanup(memcg);
  3888	
  3889		memcg_offline_kmem(memcg);
> 3890		reparent_deferred_split_queue(memcg);
  3891		reparent_shrinker_deferred(memcg);
  3892		wb_memcg_offline(memcg);
  3893		lru_gen_offline_memcg(memcg);
  3894	
  3895		drain_all_stock(memcg);
  3896	
  3897		mem_cgroup_id_put(memcg);
  3898	}
  3899	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

