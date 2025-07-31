Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FCCC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 22:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94AF96B007B; Thu, 31 Jul 2025 18:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC796B0089; Thu, 31 Jul 2025 18:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8129D6B008A; Thu, 31 Jul 2025 18:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD1C6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:29:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E23341A09EC
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:29:44 +0000 (UTC)
X-FDA: 83726003088.11.BDDA8D3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf08.hostedemail.com (Postfix) with ESMTP id 37BFB16000C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:29:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DP52w5ZJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754000982; a=rsa-sha256;
	cv=none;
	b=6Ht8zHZCAOpkLOJOxZARq0kqkjgKh//Y8Yr5rmoR3yPe5utOHML1mfhDB0uUIPudmqjyVO
	DxNxVDj2Q79Gv4USrlIcvufyUpLsv8oRolHM6z4Y46tYSWPs5bhrfFv8/LIujvmpo7Sddf
	WossE+OkG5JHXgTyHzhdxHCJI76rYOM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DP52w5ZJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754000982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOfEKxajTzEaY0fIBNWyv7Sg6LR/+Bymi8m56lMhKvM=;
	b=7GJGs5sS+/y6Bsp2XB/kbkMTaRePk6lBfZvgUr3KcYzLlZLAtChMATAQuo/AqqLedWFgHc
	eXuJggZOcOxsiyEdBxq9/H4hXd/rTgpM7utdC196hWn1urbCcMUf894puBV413TGPlFRIw
	28DZMdHk7j+WdEZyOfSx74d/Q+s1Gxw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754000983; x=1785536983;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=utLiTKFwFNvt0LPbZ5j7WJ6DQ8YhBygzc4b6NSruN0g=;
  b=DP52w5ZJphkppuqXhIp/RttRMtr3xUEh4JEH2WGFkQq0tec/n78PclSg
   CJJsInf1FkXJcx2P5SLUXHsl3gTNdqbA1KeKzV/LwkJx166MOWBIx9cWS
   9A34+pEUDJmim/6ZnGnuhF0kE/hJGeNsPAS+8f1iUlQ0Wuey3Os0Q4kot
   lcUGcqJGdRuJw2Jwc38uYjfOUGNPRI75GGIa9k2z7U5cutiiPHj+6k1Fg
   M/TqZ/uA2OFjikCn2WKd+96uSUTWP4s40qoNm38j94uFILNpWU+BxApXT
   ZCTXdRYelqzGOQ+qbNRrmcOAFLAnyK/xNo7eyLmUgF+5dRkEc3cfiSWzl
   g==;
X-CSE-ConnectionGUID: +fXwHM4FQnqcEovIOnFwuQ==
X-CSE-MsgGUID: 7RzQ20+HQFeAofTKAii+PA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="56489723"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="56489723"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 15:29:41 -0700
X-CSE-ConnectionGUID: VMgyfpdwReuW5r6HWejsmA==
X-CSE-MsgGUID: 3BUqWPAiSTe/o/e5TL22oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="167864293"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 31 Jul 2025 15:29:38 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhbmJ-00049E-2k;
	Thu, 31 Jul 2025 22:29:35 +0000
Date: Fri, 1 Aug 2025 06:28:46 +0800
From: kernel test robot <lkp@intel.com>
To: zhongjinji@honor.com, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev,
	npache@redhat.com, liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH] mm: delay oom_reaper only for the process using
 robust-futex
Message-ID: <202508010627.P8Xrr4xy-lkp@intel.com>
References: <20250731102904.8615-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731102904.8615-1-zhongjinji@honor.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37BFB16000C
X-Stat-Signature: 1pytfrniesdd9jitbj8c5bq4ndodoedi
X-HE-Tag: 1754000982-568301
X-HE-Meta: U2FsdGVkX19NfceianQVycnx6G7EZjw/O/4ieaqw8bfkAOmqiSSQGA6OMolSqQlgB06o93o40Gyl5e+eY7akz2kSsgpNdkV+h0uSSHzZm3mPz2NWIwccLrDkT87hhbK87MvPnoko3O0+eqqQ+fG3ZkP0mQpJ8gNTGmA6NG6bS49Dj56ELaQSZfHBiXC508+jVU/cqhHghMDl5c6W8Bvpim7eAXhNcEOTjFrSJNaowjpV/bvb941pqhc83argsBHP3uwl+NdRAH4bdAqpwBFBPIPC6si5gSz8tRfugLyokm2e0N3w4/XwOL7PodgDKM4rQq9WAt3BpzFsAnc6HvwBFnq/JtJzwzjoeQGBk4EIuFpmnhbkt3qw0ZeMh+vmmEDDX5S0EHPXNt/4fwz7YdNg6+hYaHwbNTQKObwPWSaRvC0rgE4HhWBsoB0JHQF0opFWuHZEcpvFyhatb87MgGZtRdmnUuCkuUh93bHvfDiziHucabbnHVO9mxxDZoqSCjfcYh4Fa54LO6dbVpfH5VLLtTTA15PPiai3NbG33fvuoOSN5fqS2K1JWJojkUxtJNSnHo7ACjtEt5Wkk3xOydb5UvmVAxrLtUnAjBh4lYAuaS/93HQGVoNTWQbpXsITK9exJZjAx/a8B0mlLGfdvuvIKS6S7Cxu/poo0xosMO+AOnWrgfwRWnXtD5G1It6Ntk9mgXVzaNaEEbsWJ0odtMfFX/W2rRZIEIYhfVIJhH3J5+U4gElapRZMFkRFnhVBN2jL+HxGGMz2WViIrP6q8x09kwsf4XQ+Ja3Z2OZyOgDGqEgonA5Vs51WaugxIF5eY52RJkm5IrBHS6tVsflr5x/mqPqztkY3kReO2nsqU/FfI6mqO6WqnkHdZvQYp0fpaysODzUI4tRvonr7nl6d6W3eaq14XH73alVnuX14VAd3PA+zf3tkg1gtDyCMMAkesxIYF0o54giLfqgd5yRyjss
 dPHGcmhQ
 8uxaQNEw1Ny4UTYhfnw7ZHYSTPiUaYYsdd3Hi7SkLi8riK/SiNPng3LmeTiHpUvshX9w+L8uCw/80I12G6Z+bLHRGIb7Rtu2pcV1I5XkH4KtT6GjpXbtiqMd1BuI3eedAZWeuif6R7uAHNyMEG6JWQ8vgqoX9JqRADxPADAjIsB/SvPcB3glQbrsiUYBJgQY58WLyYCM5iN7/J5RjjDv4Wzg7FFJqs8m10yUBIaojC+Q89dfxH1WUrN1mTGdsw1EcpFKSQ7C5qVCkqHlMTqOhP2aE0oizmi+Isx4ceTLoAYm7sRR9Cn/2LRfsLpKhu/pBU2PKnTiMsdYL/TpFNXX2rCk+coNXsZHK0/ZvPAtH+1M1vce03JLrZ3TDEhOYH20/Xm1k2lH3sK7rbSCAWy5s3mUdHvd+qHMF/H3ZTq8MceW5McOfpAWu+bwU/Q==
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

url:    https://github.com/intel-lab-lkp/linux/commits/zhongjinji-honor-com/mm-delay-oom_reaper-only-for-the-process-using-robust-futex/20250731-183058
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250731102904.8615-1-zhongjinji%40honor.com
patch subject: [PATCH] mm: delay oom_reaper only for the process using robust-futex
config: i386-buildonly-randconfig-002-20250801 (https://download.01.org/0day-ci/archive/20250801/202508010627.P8Xrr4xy-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250801/202508010627.P8Xrr4xy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508010627.P8Xrr4xy-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   mm/oom_kill.c: In function 'exit_may_access_user':
>> mm/oom_kill.c:872:20: error: 'struct task_struct' has no member named 'robust_list'
     872 |         return task->robust_list || task->compat_robust_list;
         |                    ^~
>> mm/oom_kill.c:872:41: error: 'struct task_struct' has no member named 'compat_robust_list'
     872 |         return task->robust_list || task->compat_robust_list;
         |                                         ^~
>> mm/oom_kill.c:873:1: warning: control reaches end of non-void function [-Wreturn-type]
     873 | }
         | ^


vim +872 mm/oom_kill.c

   869	
   870	static inline bool exit_may_access_user(struct task_struct *task)
   871	{
 > 872		return task->robust_list || task->compat_robust_list;
 > 873	}
   874	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

