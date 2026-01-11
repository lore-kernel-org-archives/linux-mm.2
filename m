Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6188DD25031
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 23:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2B66B0088; Sun, 11 Jan 2026 18:21:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78CB36B008A; Sun, 11 Jan 2026 18:21:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF2A6B0088; Sun, 11 Jan 2026 18:21:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 591396B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 18:21:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0573D21F9
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 23:21:18 +0000 (UTC)
X-FDA: 84321256236.23.C669096
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4D8B24000E
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 23:21:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ipclPm1x;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768173677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=S0es1EVMOOx+Cxhw4LdpG+YzO0Oxbgl8UJ22ItYEu4E=;
	b=Po0j2tRMbcVmxD8Cc7dcSLo9YrWrQep9L/2tFF7jegvaPeskvZIOATlfN4GKrNPAo2wNV7
	Mvk6xZSU32/VHHvYEgFkcc/K/x9/cMeif5ZD4AiTodapkYc1A+DipbzxY2IWm2AlOIEfD/
	DEIvBIaxwPVxt2vq7R85qdpoEZS1t+c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ipclPm1x;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768173677; a=rsa-sha256;
	cv=none;
	b=KtUnkC+YEBPxKQmg3hM+VzRF2ngKAuRFWvV+3iGK7CIXAi94amjCdoY3tZcX20MyGjX6td
	eBuYoPg/v7G5mEPgVJAXcYxPut83U3xOjnEgUfqZMIBXzmivNZMHed9hg2JlbgfzTGv3vW
	O+H8NvsJMXneST+BegCj3ngLtxRpmeo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768173676; x=1799709676;
  h=date:from:to:cc:subject:message-id;
  bh=rmg9khLx+bVFsxKuQfDqFDH5if1gqst1PadqBIEWdl8=;
  b=ipclPm1xtBKufpXubh6SWDZiTdtnQXgMMZranekXV8kVV5UsuQ3Xy4FS
   c+HxPsyrPR0gHNJuRHj1T5gAf7O/jeAuLUNtdNAfrA+X+Xe1lHKrZlkwu
   2XpFsI89uDXHb8PbwvSQiT9TdpTCrArW9FQPm2AmkS8hnuPEiSyeuLZSC
   NRZOzQiwDMbqx30FE04itebqVm6fhBa1sFfPdPNPBnJ+Bx3PDLjWAoGoX
   gyEFdqP83w0yRAKRqYlHVJcNSPzDjTqEEN4HkgbM+ynXyrB6c4HXJ+UwG
   Why8HFsH67e82Cvp4dzhaG4AI7b89g4udeaLBKAo2RLpTmEh50JCQY8Sq
   g==;
X-CSE-ConnectionGUID: B4aBbI0cRwyJwnxpUmNIXg==
X-CSE-MsgGUID: yTyZvh11SCW0Xfl6NsVF6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="69503224"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="69503224"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 15:21:15 -0800
X-CSE-ConnectionGUID: +QN/Lz2eRp+i4oFFr7EQ2g==
X-CSE-MsgGUID: gNF3/ucTQd+zYIHbIhf25A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203097807"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 11 Jan 2026 15:21:13 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vf4kA-00000000Cla-2l99;
	Sun, 11 Jan 2026 23:21:10 +0000
Date: Mon, 12 Jan 2026 07:20:37 +0800
From: kernel test robot <lkp@intel.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [akpm-mm:mm-unstable 47/164] ERROR: modpost:
 "arch_enter_lazy_mmu_mode" [mm/tests/lazy_mmu_mode_kunit.ko] undefined!
Message-ID: <202601120711.6hvwP9kh-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: ep1t5wbeeoozzqacwtnzse6m4oygx6c4
X-Rspamd-Queue-Id: 4D8B24000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1768173676-621122
X-HE-Meta: U2FsdGVkX19/JLR4kHG8HTE+qgYQ0hXhGzJweg6VcSMF2L4MQal5bDAeJeBPvpU8sh5BLpPfiuned1m9pv84dDpP22LOLrLahpFHrfsRykoIqtP83JHJ15p/6o+B3LDp850q/1v5mvwBhWKE0dOj5M0UJ/WO02vaY0OnxIOI3n01gee/FuyCHhnkV3QYPewwq4kZx9N5IN3OmoERvD78c2Dy3EKLmlncO3CGuwDGqcCbBF9w1a83d251pkvOStyS63K433WjAtsUO9s1nKtSirRU9fq8IS2P8/LPq1dBEqLdO6q30i5B/Nmr2aZNvSwcMhK8ipN7v5S00LAmJKgb4rExwOmsVazJsyrjiJ1VITPVLxnnDpapZ24KNn/xeSrO/ywje1LJzK2+zyhNcxrZ60LxXAoVWO3SckHnzV/dCz5StGCPQ/r+rhLCWM1bGCbWac1UJTGdkCGW3qWZz7dL0VzQ8axCmu1wv8Ob5CnJNefZ7kPbQc5NMmnPSjzC91tieDtEJ/Blnmb6zNDlxbgEiE4k5o1gH+obn6xWhrG6N/Xo8p7fpVexxxcX7HxyqEAeTfwwSeBKJmEa912PZu5snzhIOZYMSachjW5JpIIG2tWhuABq+9dXVCDGQKlO9RPMwb+sbLuhi9FKNoSvJyRaXnzrZD3xxEXd1keggnJTyKrGot4bXcrONY/53IRsbpN0GdfPy3wON62T6EMfHdw/rdeGpVgmFzTWhc5VvD9JuOHfrZJ+l9APAmdHTDwmtgMLsWq2n7hUYLkrnQnEg/SbfMXoizLtiBQnwnPVE2pTHEyTD/sCMEdySRbmTekj+0ozvdpT/XJHV7NUcBNTERldJTgds3+P+dgFNTVTCcoeUboVUS1Iel0TqtyQSy1upNTXhEmZZu0fJ4jMTi37AqMkGxE7Z/H8JvGF7wZVl8h7pdCmkMzlfGs5KUKMXi7GD0TviLb1MXpTXkTqLvmYvjs
 DeYVoV0B
 j24/mYeIsqeyQIcnWBJlbtljxb4Q2lIVNTRKdoZ49d62bcnq8upL4Etjij0gjK2VRPJEEM8dj6y+caJGYWjpy+IcpbChhMGgMUNt9dqLM4/ByOORWp8iE9CY2BY5pkfNrG5VtG/qdRnYZRtHC+Yw3SYYavkgYyyLpv6x5TtvnR6nNfF59FVZBmuvNNcEtNlEK07/8bGyb4+qRBkJv3aF244MX3vmUYYTDL9L/WN3D+ARtdf5eFM4d30RWbdF8je+es4vQGR095aU6XHLeqVra/m6MMEgUZUa+xCWCkSJRYAKHIzf9FQPDx/EnPxZOJ2w/hDDQaz8iGxB/QnSdjx4VCP582IWXp0+phgdfo2HtvS/4U9otD+jRhXgDqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   4d2d0ad5d6a267cb4473e5f50e1b363e8a9fac3d
commit: 5c2d9373a742480bdf4d679da96fef6bbaf4db75 [47/164] mm: add basic tests for lazy_mmu
config: sparc-randconfig-r072-20260112 (https://download.01.org/0day-ci/archive/20260112/202601120711.6hvwP9kh-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 14.3.0
smatch version: v0.5.0-8985-g2614ff1a
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260112/202601120711.6hvwP9kh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601120711.6hvwP9kh-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "arch_enter_lazy_mmu_mode" [mm/tests/lazy_mmu_mode_kunit.ko] undefined!
>> ERROR: modpost: "arch_leave_lazy_mmu_mode" [mm/tests/lazy_mmu_mode_kunit.ko] undefined!
>> ERROR: modpost: "arch_flush_lazy_mmu_mode" [mm/tests/lazy_mmu_mode_kunit.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

