Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17837D6CFBB
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77F7D6B02E8; Thu, 22 Jan 2026 23:02:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD826B038A; Thu, 22 Jan 2026 23:02:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552176B038B; Thu, 22 Jan 2026 23:02:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3FC46B0389
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:02:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9C071B32A0
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:44:38 +0000 (UTC)
X-FDA: 84361685436.04.21001AC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf01.hostedemail.com (Postfix) with ESMTP id 46FBC40003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:44:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="YMybbAM/";
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769136276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1x2TAliqbAAIyc7FSM7yYyirZiPp9rXXlej+4BglAo=;
	b=lsrzk2emr+ONw7V2TMugYxJUrhzR/h5qOnjR8DkXMDE3zKdSEl42deNlwu0tohPvZfjIgM
	1qOhQh3iolnFrJICp7l6TMrfoScBHKbvra5TpOwAmK3XhZBv20y9KYwZ6X5Z4isv8mRCwo
	6ZAKJQfn2xc5FwfxIO6ppJXXwYpfQfg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="YMybbAM/";
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769136276; a=rsa-sha256;
	cv=none;
	b=VlxSlQFlIlFZcgMgAOZMjuza6dqOwpDZb1ZfXa5EeCrKkZc9GvNrUFk1Qrmbwtvd7vB1rB
	bAUfHF2Rp5mLcezi50fRHpPBhx3rgoHzUokZrmw6EGYYZvia8NrENBY25BQPonRXzzPDqc
	tRkAZUcMxfVAgIpOdN0N8/wbsGP86CU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769136276; x=1800672276;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8ndyNJikJsEpVSc9dj51nBXSlOB/gf6TZifRUHaN9w0=;
  b=YMybbAM/ZuJZTECgxU4wwcfQK2ygZhYgRZxDDsY5WjXGSZ5coyacBJvP
   suX14rgX9ADFDss5HdTcXx+i9Dp52XoMdsJ/HFbPsPWCTz0DlHtSUBl9I
   49h1OLYyn+bDTerEf2+6mArnUf7nI2nLBIfWPZ67gIt+Miv+nqu1Aitmv
   Rin7Vm6+mc6y5H1X8316NIqnF1dbxQDt54zJQPhZ062+dxDFJ1DpY9+fq
   vrinXPVFDBwASNtmfFH2mJIjTTUJ8pV2fxNJXdbf757b7AxMoWXN4/+ef
   LLncyz9GYQ0tuq7sPcDC1gwfS9vpz0g/H7mtFlgF+wT73Yx2kQJmpcT9V
   w==;
X-CSE-ConnectionGUID: djwxbGitRfy8Otoxzv0dKQ==
X-CSE-MsgGUID: V7yiewg1RQCIhrDAzKD/Ig==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="70440023"
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="70440023"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 18:44:34 -0800
X-CSE-ConnectionGUID: /cURpc/CT/q72pVQuMgWrw==
X-CSE-MsgGUID: VLZI25VOQ0uqjgYyO5JaEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="211361570"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 22 Jan 2026 18:44:30 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vj79v-00000000TS2-33aC;
	Fri, 23 Jan 2026 02:44:27 +0000
Date: Fri, 23 Jan 2026 10:43:31 +0800
From: kernel test robot <lkp@intel.com>
To: Thierry Reding <thierry.reding@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: oe-kbuild-all@lists.linux.dev, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>, Sumit Garg <sumit.garg@kernel.org>,
	dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v2 04/10] mm/cma: Allow dynamically creating CMA areas
Message-ID: <202601231051.5GWCp3mt-lkp@intel.com>
References: <20260122161009.3865888-5-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122161009.3865888-5-thierry.reding@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 46FBC40003
X-Stat-Signature: tc4itafagdohtsqdkhdm3w5f8ohrcn3e
X-Rspam-User: 
X-HE-Tag: 1769136276-407402
X-HE-Meta: U2FsdGVkX1+vd5cEHzcwccss9LdFwyxEtF5fJFNmMRvrzw6oUrYzoCXSSNLg9kFXUdvdWsME8cEXugrfNR//WFaLQHzPxqVksaI5inxpk30ShkVbGnUmC21MNdab/bnIBVsBRM7SWTjbz/rn9l1/WJMSuSByrLKE2fR/TIGF80rQ+rJCuVV3XpJ8ccpmFpxCyRGDDbVasBP7CqAcGOJOITPx1JTzktHFxN74i8fMl6cRGqgY56D6DpPfTyyOPt4O8Azg1DvOTpzp3sX8HBwby1mZkjomV8fJjUxuzNdTXxHkvxYTmPwbfJy9JJkKNPfSYcWkLw3i0NFN7KG/OH3jCkjrSEChVwgfsUQxx9RHUDaOYSzKCjRAfrzHPdMHaP/sGkpKc1xXpvkQ7KytspO81Iwz+zl5rCdmVwsI/vrFk+wwzFL5y3qo9ibZvlnp/i8r709xcWAfKFt77srTrQ9/uSTtKoYb3xsGe8wGHyxAUWVhnYfww7KNyonqFuC9AgFlGv31rXkz2ospMIahDQUXH2OhmxNBP5SLrk/wn+0C6X2TVTwlxV6m4aNmpagiLYczgiyLxWoA3BB0GzzZ4Nd0uUpRbcRIzfyCNkxUoAL+PJXoim+nb4Rlj6zuNGHRT7T0eonhStG6GE+kCzR5yCDnuHAw5t5I+c6KE7mgRI9PXS7wooCo0y9T6Gy5+k4N80FuHxKTe/LUr7o6Y/4KA82LS2ksesYztbtTfE5OAbz3BOVpXsey+v+wTzUYHtFzwBGk2IIwYXzdJ5Gw5Eaeo8NP9w/LtGNHHlL38anlmUtF+p4XvGCdueBJrGhgF0s3TywouBqBfYGUAo20ZuSRmO1/XhG7mb00PfVf7mnpe5yaLBdRAozsYeOhm/2nVvJ62QbNXHjkbo2KQzD4EcI1HtkSPc7Xh8A2XK3ZmebLrXyYq03O/sE1EBV6L57UB5sRuKePrteAPQihC3Gcn/u1iuQ
 r2R8VaoP
 0J56SrhxP3kMkCbBS2pZyDD+5MEOTJJJQR+2othIEgSjxGW0hYV0JYo+odwbcD62CLxHOWH+quJyOv8L8o2yrU/jW5715VAu+GJOZWBE+FH7gUz2AGF4Ufzv9WieQyu4gjobvK/eslveM/MOR96yhnuMYsdBaEwLZgj4azc+RFABews+uFCzANMgKFe4ICzk22iUxYTxSiGyoG6rB8+oILRmSDdU9MAfr9k4P01u/DRtHT/hkruwgc4zaioCDqQ9Ha6sn5e8Y+g70SNAi8d4t0nI8hhvvuz02sDsqPKLfnX2TCIOU+8HgQ2q/y07uIy41zqY/VjTdbxMOy1ZGzWznhOLA4yfItsc5nn87qFf3sLsVJkO9vt/K25794u+il4lh7hFr/C/hp/Ul7Cq7SUkdJ7R7iPVRtvUz6ToVUZjRbk1pJWE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thierry,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on next-20260122]
[cannot apply to drm-misc/drm-misc-next robh/for-next linus/master v6.19-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thierry-Reding/dt-bindings-reserved-memory-Document-Tegra-VPR/20260123-001244
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260122161009.3865888-5-thierry.reding%40kernel.org
patch subject: [PATCH v2 04/10] mm/cma: Allow dynamically creating CMA areas
config: i386-buildonly-randconfig-003-20260123 (https://download.01.org/0day-ci/archive/20260123/202601231051.5GWCp3mt-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260123/202601231051.5GWCp3mt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601231051.5GWCp3mt-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/cma_debug.c: In function 'cma_debugfs_init':
>> mm/cma_debug.c:207:25: error: 'cma_area_count' undeclared (first use in this function)
     207 |         for (i = 0; i < cma_area_count; i++)
         |                         ^~~~~~~~~~~~~~
   mm/cma_debug.c:207:25: note: each undeclared identifier is reported only once for each function it appears in
>> mm/cma_debug.c:208:38: error: 'cma_areas' undeclared (first use in this function); did you mean 'cma_free'?
     208 |                 cma_debugfs_add_one(&cma_areas[i], cma_debugfs_root);
         |                                      ^~~~~~~~~
         |                                      cma_free


vim +/cma_area_count +207 mm/cma_debug.c

28b24c1fc8c22c Sasha Levin 2015-04-14  199  
28b24c1fc8c22c Sasha Levin 2015-04-14  200  static int __init cma_debugfs_init(void)
28b24c1fc8c22c Sasha Levin 2015-04-14  201  {
5a7f1b2f2fbeb4 Yue Hu      2019-03-05  202  	struct dentry *cma_debugfs_root;
28b24c1fc8c22c Sasha Levin 2015-04-14  203  	int i;
28b24c1fc8c22c Sasha Levin 2015-04-14  204  
28b24c1fc8c22c Sasha Levin 2015-04-14  205  	cma_debugfs_root = debugfs_create_dir("cma", NULL);
28b24c1fc8c22c Sasha Levin 2015-04-14  206  
28b24c1fc8c22c Sasha Levin 2015-04-14 @207  	for (i = 0; i < cma_area_count; i++)
5a7f1b2f2fbeb4 Yue Hu      2019-03-05 @208  		cma_debugfs_add_one(&cma_areas[i], cma_debugfs_root);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

