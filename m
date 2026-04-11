Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8798F3ED44
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 11:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36896B0089; Sat, 11 Apr 2026 07:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7C06B008A; Sat, 11 Apr 2026 07:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4786B0092; Sat, 11 Apr 2026 07:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 964426B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 07:08:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17A791A081E
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 11:08:30 +0000 (UTC)
X-FDA: 84646001580.22.D9B327B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4287D140002
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 11:08:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="cq4j/J5r";
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775905708; a=rsa-sha256;
	cv=none;
	b=CWKleh96JXBdgHl/e2FZF/4spLvaPDAPz3phyQmhhDxOs1opVBKozJ7noZfCNOrUo7Yluz
	SlKc9ToHF6etFhjJDfk3+8Ae3BlhiEGGk7ayaVGeN/PUYtro7vqd/dAWUAZBK0bkErcRX2
	TJov0KZIDOxnv0nmdbeuKLwfJyxYmDY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775905708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJqSPKXzkGPPdqrNgdZYz7ydI3KVkZMqLuVTUx1Mv8w=;
	b=PwSTrwsFWtUnj6xVuC5xrRNJtwLhYVF/dO5JydCfmT8VTpLXFquaXKrRAgU7oAm991dN2d
	xDBJ5SbXvnN9pIFr9kpxh1JKFswu2LSWx5N1L+yttzTf3N83fmnE1PqHqyVyM0nYs0EvkK
	yw2/Zlmw/px6nefBfWlwOQ4p0Jcg0yo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="cq4j/J5r";
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775905707; x=1807441707;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n4jCbvoXHQzLUfxIsK52UWT/ZiXsVp9w9lmDCQOl8PU=;
  b=cq4j/J5rzFF5K5W+uTGtudrY6teWaZAxI9S295BmnoL2EfChgkTG0m12
   Dq9dHQP3aSFrzzk/TTiBJM9a9+y1TYvxRlx08SmhyM2xQSYkrno2MkDLT
   8ggneisH9atmSJgnTUxNRC1YrVzTBF918oE+y9sV4x9G87SRNRLhQeU+u
   gAFrFscIqHLsY+Z3RTHPybP3rqHfuAs1JtQ4kc2Rnr7ukNaKuLfa+Awe1
   qMYIVCOc4YY/Vl1rWDKvQ1IEXVgS7rV/uf74jHOQ3SjONZC02qj21IB6D
   tUQt1/o8fyEvu47ZyfkDCVvk+CHCWXYgzlsjS8LSjvYaZzSyMCVtYfJoU
   w==;
X-CSE-ConnectionGUID: ZpP4GEgGQfG9Hb7HM4j65A==
X-CSE-MsgGUID: 0qNHO58tSUuqkIBab80znA==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="79497578"
X-IronPort-AV: E=Sophos;i="6.23,173,1770624000"; 
   d="scan'208";a="79497578"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2026 04:08:25 -0700
X-CSE-ConnectionGUID: mO4RSQk1QveiwXCLDsf7pg==
X-CSE-MsgGUID: ij0+y2IPSXy2yQ9but4jCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,173,1770624000"; 
   d="scan'208";a="228477001"
Received: from lkp-server01.sh.intel.com (HELO 3eaaf1a74b89) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 11 Apr 2026 04:08:23 -0700
Received: from kbuild by 3eaaf1a74b89 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wBWCJ-00000000169-1p3K;
	Sat, 11 Apr 2026 11:08:19 +0000
Date: Sat, 11 Apr 2026 19:07:33 +0800
From: kernel test robot <lkp@intel.com>
To: Cao Ruichuang <create0818@163.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	Cao Ruichuang <create0818@163.com>
Subject: Re: [PATCH] mm/vmstat: reject invalid stat_interval values
Message-ID: <202604111816.CsqTatIh-lkp@intel.com>
References: <20260410112554.23165-1-create0818@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410112554.23165-1-create0818@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4287D140002
X-Stat-Signature: 1nasub8ns3ms4zfouink1fdbdbfpkt3n
X-HE-Tag: 1775905707-495987
X-HE-Meta: U2FsdGVkX18bURaVs9mkdEogO2wVD+XCKub4NeU3CvN8oJp5WO5gTDDkO9eV3kYogJ3/F3WWfC8Uqy2J8KaEl69Mk8tmqHHfxKUVHDLOMMRjn26escEaHrNPceMYBrvtcVQMBWt+GDljRWYncTwekHK4RLPIq1dQQ/Y2y1Hm+oKssTMXNal1pt7DOyQzAa0HHgAi0SqifvNK9vVyJOYw9HjYUqtyvqv0oTA7Nmh7X8EYpQW0nAaWVlAumg7/WQtdo9YyMyTUgipA5E6CqoJtyk9dlbfYVc3B2NrKlWWTnb7BfoTT2ag938YnntwBrjFAf91kgUriRNxDn0UwHU4zXzhEq2nLQBiN72oHx9Kfh1boKta7HOmOwZvViFxR1kX2xenjI1iq9rLkgJdPH1sVG1HEq39cBRGbOKc8SuYx9HrrF9WvUA/T+KDSEcq3Y1gTw3GElcP/OJRdw+FLS1v1TWqlTutYC57eTN2mAtTxxZ4irBDnxLivP6tM/IpJ0EOHorBMF7w6DLg0nhcf48q/gX5jtuFKqD1o3NrYukPbixTSxGbiVypAgIjfRCHQFuNBcE1MfYDZ91fgD6dmgW2o5In0VNkeWGIaoMgHawfBanGEDeG1Xoedm+5QxrtUBWoM4yYqbWeZi1RS/uZC/WJFZzDTkEDTan80O9d+0Gnk4odZnudv/j8tl2DsXJX1M50eaXAUKW4SvEKyqYfrgIbY0encXf66qqYJHNMvgi9jShGwBqrcaTHACZNKoBNRv01lbTUnJU48BSC37YXIn1fx31elcitHg7LVboR6mDVo0v0cQj3GKg6jSU522QZmcNg+tTYbi/Q9DGyChZLayRRJ2ebJjS9aePMmwmz6EYuyNhtet/xkY20tVTKOO7KqpeKYxBSY34dSnyB+wj9lUGqcOwWz2S9DcQeldWOEkhQ1wP9aaLQWHX4fU/8eUlASExankZd8um/7qnPjiqNJIq/
 FEn2Q6cX
 botGSifjjdJwxROS+2bA18IwZEB3u/zRZWV2J4/6oFIBMXdKQVw8js090W6gpsjtFRaMEUlmLnMmysUgiUdLIIKOO3evmfwB/baBGMZxGaQRxDfTyOxtu8I71qgoiidtpDAZR6RtSQ+RKBOhylVZ5kAXci1Swr+Z04v4zRQfB/KzeDlIBzP63IqVyWlDBSJHLqbAOOJo1aOrG2Dnkk7TYTn9/EdgMhbs7Iiz0dNsgpImE6F+QfoNlvayWy/dzKDgvJqgee5n+6n8M1clo4Rz8jXTP/tmPx+NmiTDTbpL9kUr/ygszAMnrCD7eqC8u8N8Lbi9LU/J0+B9LsP5JP1uIlFT0YcqDSBC0HXaGBgpa+sXwaM/J0SI1vAky42AYjZDYEOTOP5J/sSDp6EYO3Z87Vm9FIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Cao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Cao-Ruichuang/mm-vmstat-reject-invalid-stat_interval-values/20260411-085547
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260410112554.23165-1-create0818%40163.com
patch subject: [PATCH] mm/vmstat: reject invalid stat_interval values
config: arm-randconfig-004-20260411 (https://download.01.org/0day-ci/archive/20260411/202604111816.CsqTatIh-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project ae825cb8cea7f3ac8e5e4096f22713845cf5e501)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260411/202604111816.CsqTatIh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604111816.CsqTatIh-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/vmstat.c:1968:18: warning: unused variable 'sysctl_stat_interval_max' [-Wunused-const-variable]
    1968 | static const int sysctl_stat_interval_max = INT_MAX / HZ;
         |                  ^~~~~~~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +/sysctl_stat_interval_max +1968 mm/vmstat.c

  1964	
  1965	#ifdef CONFIG_SMP
  1966	static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
  1967	static int sysctl_stat_interval __read_mostly = HZ;
> 1968	static const int sysctl_stat_interval_max = INT_MAX / HZ;
  1969	static int vmstat_late_init_done;
  1970	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

