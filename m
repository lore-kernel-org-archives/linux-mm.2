Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D78C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 16:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF9C8E0006; Tue, 22 Jul 2025 12:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F658E0001; Tue, 22 Jul 2025 12:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64EEA8E0006; Tue, 22 Jul 2025 12:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 50F638E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:53:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0BAF1125F0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:53:18 +0000 (UTC)
X-FDA: 83692496076.05.D9E1263
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf18.hostedemail.com (Postfix) with ESMTP id 92B041C000D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:53:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WZaZ1ktn;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753203196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+6VTMCDBJz0mScxFKIuuHQKsHtF5822AZVnXnkb78JE=;
	b=qdKUIuPaFFP/VGEqemUTEsNu8HiOt0CtuCHRm/cDtPsEjodOuk0t0+2FjHWc9NgcP3yb6f
	9s3suSdFViRHDFLlI1f5/8LhFBTzs0eLz+0QsnDBbNPKf7Nb3tT5tAKJVXGihEAKZ/vrFl
	tDhPJY5pqgSaMa1kUtXlKIicKEAPz6M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753203196; a=rsa-sha256;
	cv=none;
	b=dvYWcCnPVG9OeCfD7OiW7qDf3QuXTT1Lt7GAAOOX1ZiCYq2x4bGI3v6++4LUukpYa4CW3D
	kpZGVCh2Olk5IM9IUgLl4mkCIL9QXE/Y9WaMp737nsw0RRq+TBQMiMnLLMLkH9N/Ka/SsP
	iw/O9191KPRWPiLqCxdCEPBwKk53+r8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WZaZ1ktn;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753203196; x=1784739196;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CkaSBlwzzYaGcAnLPWY/P+SSy1fbLBWJPLy6c9IYQlI=;
  b=WZaZ1ktn6+Mlg2rPPRF3f4GyKZTDs6Tj65iL1Cx3A2ArdFpMoyq5NtdX
   +Cphgb+CAGXYXefI7MoFfTeQaZe2kwFu1QkMB1NZtIw6PQHHG/qCiZh8D
   Dw0Y5q5b+dVg88KlSKz8ti8aP5ooRJAN9LwYUVvJ4wxWxo7XmEMFvZfMw
   soBMlufHSm/LN+uKP2bAFoySFEApnAsKCdeVRQHprEDp/EEBFHDAHm5f5
   4nJqkpCIdzaPIeNFvuWt3Vk6fG+A3wqteX4NmTmyUc2KqXPc/7PCrzuO7
   wK7obptL9k7HTOKbnj8itmVlbtRhxzxbbTjtvfJU0GKVf/cOoCiItVIVn
   g==;
X-CSE-ConnectionGUID: YBKRmrHiRJmyxLR+2amWtA==
X-CSE-MsgGUID: xdCJb2LGQb+FOORDR9BDSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55316296"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="55316296"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 09:53:15 -0700
X-CSE-ConnectionGUID: HEoKRkggRsaAZDKRCtkP8w==
X-CSE-MsgGUID: sm7HFahMQHucoTbGEEvprw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="158495843"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 22 Jul 2025 09:53:12 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ueGEo-000IYZ-14;
	Tue, 22 Jul 2025 16:53:10 +0000
Date: Wed, 23 Jul 2025 00:52:21 +0800
From: kernel test robot <lkp@intel.com>
To: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: oe-kbuild-all@lists.linux.dev, Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH 15/15] ttm: add support for a module option to disable
 memcg integration
Message-ID: <202507230039.EESybnUE-lkp@intel.com>
References: <20250722014942.1878844-16-airlied@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722014942.1878844-16-airlied@gmail.com>
X-Rspamd-Queue-Id: 92B041C000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: fr9hjt3d4xsojx481ojxsmnyae97nzh8
X-HE-Tag: 1753203196-967215
X-HE-Meta: U2FsdGVkX1/l+NiTdURpHsaA/5ekcBGQIEMz5KACENeJ0yabWzd7a7lxa90HSCNN4KWqhBTk+os5v/T5PKSFjhSI9S9KszDmlhMwmGlg7JrRqZ6tz9sbDVS02Jcm9KSwtAav1rPpwCTthkRoaNJt7tkWaU6dA7vkJNHvo8NRP96xizD4/i41d8iP+uB0mTbGe4nPx5ITZSLmiKgBVcyGTd3iqZ9jnohRatiNjHM0tkfpry6QU/de9OoVrHM0bnABOcZLDPJV513kxG8VmNJPWBX0Wc/BMjTEtHQZS79J4vgngkL5hdVvmls1kmiuQnXOszBLwWy3LD3fYBpHsEeb0HF7kNwx4sOV0+cj5YT9O4C4kiIesPlZsJwOiPh9AUJJdADFUvvEyenpoaVnnqIZ38jCeZzu33Am8tCqnmJstHoswtw3uvrYlWd/Z+dfiZEr2j089PreVQdUsOOMhMtx75LAeg6jkBXUIWh5BPF12s6Nfo5fxUsBeGv3w6ZhRFXETzAYeWpz+pPerCerH5cK2i/w1arzULg4AsND8yiNtWziPL+6b69OGt+VKzk3tO0GaAeTRktmOZUAjelpOalVj9MHir/B2mfXmSpdzZ0AWDw55PiefemE3sOMcdDu8g82v2yA5I76+zeE1FFWbA+68KhYXu7kBdovxmH77dhuQOaVvlYDRVL0GQ5CWQeH77f1QUyt0WqFXAXR3+REvsLewPMfXwKVaTldvQ+rzil2qNzGGuetNdhs4K1SowJj1BlhURTEORKCcPX2v5gdyZtCV/wItFSJ2/4ls4xBkYEZP9hzScpCrBvGIqkLtwzjoY3wBZ/sOaYQU0yhxlfOQdDw6c9LVyfjFXjdmuZDdnE5pBlYWSG/ZStyXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dave,

kernel test robot noticed the following build errors:

[auto build test ERROR on drm/drm-next]
[cannot apply to akpm-mm/mm-everything linus/master v6.16-rc7 next-20250722]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Airlie/drm-ttm-use-gpu-mm-stats-to-track-gpu-memory-allocations-v4/20250722-104402
base:   git://anongit.freedesktop.org/drm/drm drm-next
patch link:    https://lore.kernel.org/r/20250722014942.1878844-16-airlied%40gmail.com
patch subject: [PATCH 15/15] ttm: add support for a module option to disable memcg integration
config: x86_64-buildonly-randconfig-001-20250722 (https://download.01.org/0day-ci/archive/20250723/202507230039.EESybnUE-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250723/202507230039.EESybnUE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507230039.EESybnUE-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/gpu/drm/ttm/ttm_pool.c:132:27: error: 'CONFIG_DRM_TTM_MEMCG' undeclared here (not in a function); did you mean 'CONFIG_DRM_TTM_HELPER'?
     132 | #define DEFAULT_TTM_MEMCG CONFIG_DRM_TTM_MEMCG
         |                           ^~~~~~~~~~~~~~~~~~~~
   drivers/gpu/drm/ttm/ttm_pool.c:133:25: note: in expansion of macro 'DEFAULT_TTM_MEMCG'
     133 | static bool ttm_memcg = DEFAULT_TTM_MEMCG;
         |                         ^~~~~~~~~~~~~~~~~


vim +132 drivers/gpu/drm/ttm/ttm_pool.c

   120	
   121	/*
   122	 * Don't use the memcg aware lru for pooled pages.
   123	 *
   124	 * There are use-cases where for example one application in a cgroup will preallocate 1GB
   125	 * of uncached pages, and immediately release them into the pool, for other consumers
   126	 * to use. This use-case could be handled with a proper cgroup hierarchy, but to allow
   127	 * that use case to continue to operate as-is, add a module option.
   128	 *
   129	 * This still stores the pages in the list_lru, it just doesn't use the memcg when
   130	 * adding/removing them.
   131	 */
 > 132	#define DEFAULT_TTM_MEMCG CONFIG_DRM_TTM_MEMCG
   133	static bool ttm_memcg = DEFAULT_TTM_MEMCG;
   134	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

