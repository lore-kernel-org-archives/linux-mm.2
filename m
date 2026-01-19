Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 195A0CA6005
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 08:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D8D6B0138; Mon, 19 Jan 2026 03:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E58C6B0139; Mon, 19 Jan 2026 03:34:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60EA26B013A; Mon, 19 Jan 2026 03:34:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1586B0138
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:34:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8D8CC2484
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:34:26 +0000 (UTC)
X-FDA: 84348051732.03.E0B74D2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf11.hostedemail.com (Postfix) with ESMTP id B15154000E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:34:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="i97U+/kU";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768811664; a=rsa-sha256;
	cv=none;
	b=FzOedrmYtuASOU0Kn9fHbutepHTnBl1dMT3fezyHbpPiDMKHvmmJwOKFyHN650/oeRcIsL
	jTGCyftzMcdgmFkerJcMFMDZLli/gEdbHTR5EUQkclqikRQG4vL9G3wgXBedAP0644jRiP
	HuAnrLs6c1kRRvQIq7syo5yq7jPeT0k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="i97U+/kU";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768811664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWhkdiXRO0/Fx86G5efHprikVNZihkATIYhh1bjby7U=;
	b=HPJpGKzN7OOJKSAAG93fGRPCwPcxyaP0G8G3DGhg8CgGU6YyxzkHTyjvkXvxHLcP1NLbFo
	cU8rCD1vE68toe3i2PRr8Yw4e740T+OMlRZJsuqN3JYrIWJDl1zSXPPJEoe23s56fTPokn
	PtTDiadQY6O9z1CPDB2J3xiuS7df/Dg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768811664; x=1800347664;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1iX0MIpEFQnW8doHsm/UYrnHu9wSPq01dIkazAmz0n4=;
  b=i97U+/kU6j7J368Jmhwnd3pGh3CycTuqsn2KePd74ayFCw7u1frEkqZG
   I3WnMGGZ5R6jSEOH52woVCkBFrXhSlcZ21rISMlRgrx4O5LJbQXEFgozC
   pFiLbq79SYoN5jUlno+I1ZpUyQno9nP1IJ1kMwVoYIg4UUgCKVPrO/wV9
   Upa/r8Ww3vPijDC9DkLfgnR4LbPM7WKgimOGfawxMgSlPX9ir7atyFrLm
   bxXXgSplu+SnQlaw/qnv8sjXBGRk7n3l4X/gu8tu4BXGrSqX8LWsQxnWf
   IG+fFATaPBn04oNvEoP3InrMzIy7+0WD8eyumdE/FOF9qGtVGapCIGvCq
   g==;
X-CSE-ConnectionGUID: VdkVVMv5RSK3B9zWPSnMmA==
X-CSE-MsgGUID: vTDQdWEQQ3Cy4HAbijjemg==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="69929926"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="69929926"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 00:34:23 -0800
X-CSE-ConnectionGUID: jasbcX8aT52Rzex+I+0oIg==
X-CSE-MsgGUID: X3yUOlNfSG+8qKEaHou0EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="210665756"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 19 Jan 2026 00:34:19 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vhkiG-00000000NbZ-2plC;
	Mon, 19 Jan 2026 08:34:16 +0000
Date: Mon, 19 Jan 2026 16:34:05 +0800
From: kernel test robot <lkp@intel.com>
To: Zhiguo Zhou <zhiguo.zhou@intel.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, willy@infradead.org,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	muchun.song@linux.dev, osalvador@suse.de,
	linux-kernel@vger.kernel.org, tianyou.li@intel.com,
	tim.c.chen@linux.intel.com, gang.deng@intel.com,
	Zhiguo Zhou <zhiguo.zhou@intel.com>
Subject: Re: [PATCH 1/2] mm/filemap: refactor __filemap_add_folio to separate
 critical section
Message-ID: <202601191644.IqmJBjDM-lkp@intel.com>
References: <20260119065027.918085-2-zhiguo.zhou@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119065027.918085-2-zhiguo.zhou@intel.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B15154000E
X-Stat-Signature: ie44euqz8iuypm96ani13ieuoyau77m7
X-Rspam-User: 
X-HE-Tag: 1768811664-516862
X-HE-Meta: U2FsdGVkX1+s27qGX911jtpvqKYGQuYTbUR5eMcFgdmszYTQhX3SKVbQq+3/BHpTwW69pPmvsvwfC+JS33wg/9V7/lYQZUDd37aZvKw3yxAsDjassB5/1EggQI6HYOTJOn+1qPCWPsDyEtHeX1dLvZ6eArBpfR4Md/+hvjf67r1+Dl/bT4SCJHau0tbU70YLQQVNLTfYmaRDlxqiy16yZ3wTdRTxFZ5l8xAVbi4ShfxyDox5pSA6FLkAJZ59/blm2N7sW+y7H/QoxidzuzoHMfVYhAE/WFAoUw9OUhP9Tn0jJhZxFjfFkceCX1mHGIzeo1NmqLbxi6Z6ZS94JqQWwPJRfC5kdb7BvuPTwyky8744Qud6IiNkBD1FcnEs8O4aYpprmUCXW/0NiPeX99lvtbH1sUaL37mFC78fyi2ZnMq+GKz1LfMqPysZYxRQi/pJ+CNlGiM9J42DfE7TFZKcz+KsC5TrbrayfI15zu+IfIJ+lcsjkRa3rVew/HHWcjKlVM62zNpvLtlW1G2BXMxTKKZpQCKP0kgzRYiKN/XCpW0YbTBrTWQGhvQzJFrLuwXd7CUDHKKNy8T44LTRJhX6UGlNslIcsKbJfcjkEv7Eu+bfzuKBjmyXTvUqChXD/EyUIUv/iASc9tjPlofg3ydjQJYYog9079tekPZ+VdlNPjaIUfvyPYZnrYpRe4IITwAG7IgJXKf5VkC1HHsP7RSQigWjy9HzGigLdLoKtnqgMJMDW/tXHnUymUQLJ8zbr1+Xh1Sr5hWpRGPUrwEjXoAYtxv3IbZjz0YOl6TF3TAFhtxujhLmWtWz/Eqo8OfBsrGPWaeHHK5xeOWPEchnvoGIH/1GWlVF8/QBvNEtnvTFXxOmu8I+fY/tYzaLHqw983C94VDz1835SdpDxueFqQEnHLB232H54WXYtbfNwmYy3OncF7Dqgx7k3Vk2n/aw7Aa0VCpqeJpej5ZkI6PmYso
 4n5ohLmj
 6fRld3bi/RG6yu5gNMrI/tZv/KmE+71j6ii45PEmV6RJjx8v1YxfEgwv3TXMGnBXgWbg1d5vCSUJP6b22YcZG7wxnXjER2lSY19d/1X+o9aWuiNiKQxVJzTBDeu1HJ/3M5LlfnOdM4UPvWzMLtBfr2a048gnQ7ZO0lykMq2K0eHTlO1Lb9D1xFtlYCTrVg2TWDjxj4ug1DQS8/MZt3BOuzDtPS7DLQKEfwtmz8zuJ5+v/dTA7xPe8frvgfHXlIt7mDU3qcpjNxUcD94jYtw2nMUO6EBkR2mRFqOwp+74w9Xkj63/Iv6CgD6DT3xuWnepvsitPkcM/cKSiWD7LGHo/Pdx1x0FUnzfXGiZHdqe8h/iDbBE7KA4hrEB0Jg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zhiguo,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Zhiguo-Zhou/mm-filemap-refactor-__filemap_add_folio-to-separate-critical-section/20260119-143737
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260119065027.918085-2-zhiguo.zhou%40intel.com
patch subject: [PATCH 1/2] mm/filemap: refactor __filemap_add_folio to separate critical section
config: i386-randconfig-002-20260119 (https://download.01.org/0day-ci/archive/20260119/202601191644.IqmJBjDM-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260119/202601191644.IqmJBjDM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601191644.IqmJBjDM-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/include/asm/bug.h:193,
                    from arch/x86/include/asm/alternative.h:9,
                    from arch/x86/include/asm/barrier.h:5,
                    from include/asm-generic/bitops/generic-non-atomic.h:7,
                    from include/linux/bitops.h:28,
                    from include/linux/log2.h:12,
                    from arch/x86/include/asm/div64.h:8,
                    from include/linux/math.h:6,
                    from include/linux/math64.h:6,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/fs_dirent.h:5,
                    from include/linux/fs/super_types.h:5,
                    from include/linux/fs/super.h:5,
                    from include/linux/fs.h:5,
                    from include/linux/dax.h:5,
                    from mm/filemap.c:15:
   mm/filemap.c: In function '__filemap_add_folio_xa_locked':
>> include/linux/lockdep.h:252:61: error: invalid type argument of '->' (have 'spinlock_t' {aka 'struct spinlock'})
     252 | #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
         |                                                             ^~
   include/asm-generic/bug.h:110:32: note: in definition of macro 'WARN_ON'
     110 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   include/linux/lockdep.h:285:9: note: in expansion of macro 'lockdep_assert'
     285 |         lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |         ^~~~~~~~~~~~~~
   include/linux/lockdep.h:285:24: note: in expansion of macro 'lockdep_is_held'
     285 |         lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |                        ^~~~~~~~~~~~~~~
   mm/filemap.c:861:9: note: in expansion of macro 'lockdep_assert_held'
     861 |         lockdep_assert_held(xas->xa->xa_lock);
         |         ^~~~~~~~~~~~~~~~~~~
   mm/filemap.c: In function '__filemap_add_folio':
>> include/linux/lockdep.h:252:61: error: invalid type argument of '->' (have 'spinlock_t' {aka 'struct spinlock'})
     252 | #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
         |                                                             ^~
   include/asm-generic/bug.h:110:32: note: in definition of macro 'WARN_ON'
     110 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   include/linux/lockdep.h:285:9: note: in expansion of macro 'lockdep_assert'
     285 |         lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |         ^~~~~~~~~~~~~~
   include/linux/lockdep.h:285:24: note: in expansion of macro 'lockdep_is_held'
     285 |         lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
         |                        ^~~~~~~~~~~~~~~
   mm/filemap.c:941:17: note: in expansion of macro 'lockdep_assert_held'
     941 |                 lockdep_assert_held(xas->xa->xa_lock);
         |                 ^~~~~~~~~~~~~~~~~~~
>> include/linux/lockdep.h:252:61: error: invalid type argument of '->' (have 'spinlock_t' {aka 'struct spinlock'})
     252 | #define lockdep_is_held(lock)           lock_is_held(&(lock)->dep_map)
         |                                                             ^~
   include/asm-generic/bug.h:110:32: note: in definition of macro 'WARN_ON'
     110 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   include/linux/lockdep.h:288:9: note: in expansion of macro 'lockdep_assert'
     288 |         lockdep_assert(lockdep_is_held(l) != LOCK_STATE_HELD)
         |         ^~~~~~~~~~~~~~
   include/linux/lockdep.h:288:24: note: in expansion of macro 'lockdep_is_held'
     288 |         lockdep_assert(lockdep_is_held(l) != LOCK_STATE_HELD)
         |                        ^~~~~~~~~~~~~~~
   mm/filemap.c:944:17: note: in expansion of macro 'lockdep_assert_not_held'
     944 |                 lockdep_assert_not_held(xas->xa->xa_lock);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~


vim +252 include/linux/lockdep.h

f607c668577481 Peter Zijlstra 2009-07-20  251  
f8319483f57f1c Peter Zijlstra 2016-11-30 @252  #define lockdep_is_held(lock)		lock_is_held(&(lock)->dep_map)
f8319483f57f1c Peter Zijlstra 2016-11-30  253  #define lockdep_is_held_type(lock, r)	lock_is_held_type(&(lock)->dep_map, (r))
f607c668577481 Peter Zijlstra 2009-07-20  254  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

