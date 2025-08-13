Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBDBC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 20:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8C829000D0; Wed, 13 Aug 2025 16:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6493900088; Wed, 13 Aug 2025 16:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0F19000D0; Wed, 13 Aug 2025 16:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C61CB900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:15:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A2CBC04C2
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:15:07 +0000 (UTC)
X-FDA: 83772838254.24.F9213BF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8B7844000E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:15:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hBxyDbks;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755116105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QKhywQcm6kbHPPBID67c8gBuwmqEekTSk6zpb+qFNac=;
	b=VFa61tOxnUEY/TzJpIvXfobf4E/nY8PZMTz3rUn1tlIJGB3dPcRzWrDjEKWBpt4LIZzCOW
	YYTgp7JICt18DEntttN0Tt9CM9kCwlDLRUH+SL6uz9aB7h7PQibjdMr8Yz+446NTXRRIXD
	+kJV29yu6nUCqcpTlIOiFil/18fNoyw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hBxyDbks;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755116105; a=rsa-sha256;
	cv=none;
	b=LSMgYD+P+RWasq/vnwVhLJxDjLEpObfQZ9lvS5KBKyW8YO7m2Fmxe9WkyvLXbV7TXmZNhu
	MYJ27f8JxIgNC+TRXbpW/iU/PIUXMyiSzgVIm6hVUxfQVygYhO7UQaDz0IUYAWwxl/RWpO
	leFlZTPzNfI+YiLpfnfADlhlxo9SCzA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755116105; x=1786652105;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=LZrTawuyAxoCi3sunafl5DYLrYFuXSMQtkSuKXK3J0E=;
  b=hBxyDbksPsXXhpXGAcHaKyda4HAF2Egq/DO8sVMzQ+LQIvSz0drUF5rk
   iXuiMMHVwUIzgLlie9LdDkPmMfltcoYRTnm2uIW5d6BbyW3u0ADu2rGYf
   mrF1dDZBLPQZS5gA2FpcKfRhSP42Ki9LQiBBQTucICOgVEL2Sb0cR0VeT
   DQLPbI6C68kSps6BkoUN1deKRHe+lHARX8OtAO2CLS6gNsGhvjA7cHdXk
   nl9AerFtPZPN17teeAcgByhGce6REvHJ3budHKIxrSTB+iWTRFZC1ly7C
   nNjHGPLwhdJDUHOTfCUD4iwUXRoCQDxsA0AXJrZ+TUV6LKj0I1Xzw3FE9
   w==;
X-CSE-ConnectionGUID: FVLM+O9RS7q0uJv5pFqTDw==
X-CSE-MsgGUID: 50gaRh9xQdiKIZtGk5xdmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="61229375"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="61229375"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 13:15:03 -0700
X-CSE-ConnectionGUID: aA/KHlyVSZyI1IVPOy/MkQ==
X-CSE-MsgGUID: V5U8Y83UQmm423ODEWHPLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="197553698"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 13 Aug 2025 13:15:01 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umHsA-000AI4-1o;
	Wed, 13 Aug 2025 20:14:58 +0000
Date: Thu, 14 Aug 2025 04:14:00 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [akpm-mm:mm-new 127/137] include/linux/mm.h:752:21: sparse: sparse:
 incorrect type in argument 1 (different modifiers)
Message-ID: <202508140415.9qC6aHiR-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 8B7844000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dqij5ebbxry65ys8tft5gbu68gbcs44e
X-HE-Tag: 1755116104-172816
X-HE-Meta: U2FsdGVkX18cm241j2yJaUNbJAk5JfSTvQ37EESaGKuOpcH1Yitj+ouIuCSAaYT2+DBqMViDnCLOpzAdlFy95juCZxi2nlTSQy6tNqfpnUb0c2IfiBgo2FPBvZpVrFxT5KH/WCmRPCAdBze2B5I/kVrkLhmG0W7yEhEidwrBvU+ki7G+pY9B+Cu6WOcsakLhd+hBlEeed20fkFUqMMNFmW+r4W9VpQQKQRuwmXsy8YMftrsCi9tQXr/3HnXT4nBN8iCtGazr9mKooUyMRX5YVfjQFyACb0PME+7PDMtOqWr/FPtPFWNUO498wgcAmFiYy5t0MYRtUzKGd1jLCMiRLaWY2Ni6AOSFHa79i+bmls9HJIjZANP/wCjZT2E8xachXqfV33dvsrzECmBbL5Y38StcCKNsvk0AgebIEJzd5TSPNKdAFpKqRwV1qe0BcSrAtvbO1utCU89y1/zbhwsoMyJExO+bIfiiQLeJ6+lLaLbzRUTAmmfN6PsBuSkgrr4Dki8HG1Oxw7Kpl0uLrnFUbk14Pl2M2Uzpc3eTbG6Bu6q4yM8wutWsQK9R+KVo6AWwn3oPK6Ffa8zDri1/34QpJ5VxYSEr7B/USoxQkUmXbq2hecy82/ZEBMvSgrMh/FHLrYWj4DCCMhVeYHrk+QDoBQiroqv2ug/10fEeuaLmiy+3OhzEsVFpTV1MQNECMgJjDChVLUEk4APioM6ZqVvdP1o8giGJJMbuZuztqHSsWUL5Qx0C8plt0wSVo4UVySCQHNO3e4PRWynCJn+ABhNnfZ7eBKj/qxeDbCPA5OhOFaME4WiAjWFMHtf6iIuBIZcCaI3ojDee3rzDYJECziuRgBA/yeEFQqF6bH4mVf8YANzWyiwedfbc/XfWM0kzc+QwWCLAVRN6cDeckhuUra7GwGio0UXlWb24PZB7AA5Hpn6zkl4d9G2+Mn55mnk/OAnej6PkgrOfQnWnWy+v47/
 jjdJcaX3
 vPCRf9uUHAGP8xQO6LlNqfrYkJWf74aEGEWRMR1vG5Ht0Cju2DtOQEzvuSheV2jSvHpliFDl5OhjHRq/bI2iobuppYJ2xpHcEvpz+YjUFWzEaEXZOQfR2g8aDdnZBri36YJOvTGXocDObVLeYNLTcUYhbG2XayNrKFdtahfoWIT8Kiq4YN5sS6fVWJkfVPbO3zhTZ0tfbAtuFyw/6aTnUiR3mJ8LOLo05lzvuArAxEdxOYwa2vFrNTCB+OpyaewfQ4V+HljTUsqP2RD4/vRxANMgvmyVTGpb4RToVeNdK9VuYDtjLyiyJoEroPc5NghQPuuYmlRDMET38NSaJqPtCN/KV/mcLhtmG7g7/95DUZoduEgiQxOc9FUPgceoOg46GcBOIfnEtPc1X1b/dRrxEsTpRQx17qk09SyD9kghbeI5zRbSZdkzo016wLXRvSVqonPsu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   694c8e78f486b09137ee3efadae044d01aba971b
commit: ead30cde4eab3fd4d3b40cd0a303d0dd2388556c [127/137] mm: update fork mm->flags initialisation to use bitmap
config: microblaze-randconfig-r131-20250813 (https://download.01.org/0day-ci/archive/20250814/202508140415.9qC6aHiR-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 12.5.0
reproduce: (https://download.01.org/0day-ci/archive/20250814/202508140415.9qC6aHiR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508140415.9qC6aHiR-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   kernel/fork.c:1607:38: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct refcount_struct [usertype] *r @@     got struct refcount_struct [noderef] __rcu * @@
   kernel/fork.c:1607:38: sparse:     expected struct refcount_struct [usertype] *r
   kernel/fork.c:1607:38: sparse:     got struct refcount_struct [noderef] __rcu *
   kernel/fork.c:1616:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/fork.c:1616:31: sparse:     expected struct spinlock [usertype] *lock
   kernel/fork.c:1616:31: sparse:     got struct spinlock [noderef] __rcu *
   kernel/fork.c:1617:36: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void const * @@     got struct k_sigaction [noderef] __rcu * @@
   kernel/fork.c:1617:36: sparse:     expected void const *
   kernel/fork.c:1617:36: sparse:     got struct k_sigaction [noderef] __rcu *
   kernel/fork.c:1618:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/fork.c:1618:33: sparse:     expected struct spinlock [usertype] *lock
   kernel/fork.c:1618:33: sparse:     got struct spinlock [noderef] __rcu *
   kernel/fork.c:1997:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/fork.c:1997:31: sparse:     expected struct spinlock [usertype] *lock
   kernel/fork.c:1997:31: sparse:     got struct spinlock [noderef] __rcu *
   kernel/fork.c:2001:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/fork.c:2001:33: sparse:     expected struct spinlock [usertype] *lock
   kernel/fork.c:2001:33: sparse:     got struct spinlock [noderef] __rcu *
   kernel/fork.c:2335:32: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct task_struct [noderef] __rcu *real_parent @@     got struct task_struct *register [addressable] [toplevel] current @@
   kernel/fork.c:2335:32: sparse:     expected struct task_struct [noderef] __rcu *real_parent
   kernel/fork.c:2335:32: sparse:     got struct task_struct *register [addressable] [toplevel] current
   kernel/fork.c:2344:27: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/fork.c:2344:27: sparse:     expected struct spinlock [usertype] *lock
   kernel/fork.c:2344:27: sparse:     got struct spinlock [noderef] __rcu *
   kernel/fork.c:2393:54: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct list_head *head @@     got struct list_head [noderef] __rcu * @@
   kernel/fork.c:2393:54: sparse:     expected struct list_head *head
   kernel/fork.c:2393:54: sparse:     got struct list_head [noderef] __rcu *
   kernel/fork.c:2413:29: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/fork.c:2413:29: sparse:     expected struct spinlock [usertype] *lock
   kernel/fork.c:2413:29: sparse:     got struct spinlock [noderef] __rcu *
   kernel/fork.c:2435:29: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/fork.c:2435:29: sparse:     expected struct spinlock [usertype] *lock
   kernel/fork.c:2435:29: sparse:     got struct spinlock [noderef] __rcu *
   kernel/fork.c:2463:28: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sighand_struct *sighand @@     got struct sighand_struct [noderef] __rcu *sighand @@
   kernel/fork.c:2463:28: sparse:     expected struct sighand_struct *sighand
   kernel/fork.c:2463:28: sparse:     got struct sighand_struct [noderef] __rcu *sighand
   kernel/fork.c:2494:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/fork.c:2494:31: sparse:     expected struct spinlock [usertype] *lock
   kernel/fork.c:2494:31: sparse:     got struct spinlock [noderef] __rcu *
   kernel/fork.c:2496:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/fork.c:2496:33: sparse:     expected struct spinlock [usertype] *lock
   kernel/fork.c:2496:33: sparse:     got struct spinlock [noderef] __rcu *
   kernel/fork.c:2939:24: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct task_struct *[assigned] parent @@     got struct task_struct [noderef] __rcu *real_parent @@
   kernel/fork.c:2939:24: sparse:     expected struct task_struct *[assigned] parent
   kernel/fork.c:2939:24: sparse:     got struct task_struct [noderef] __rcu *real_parent
   kernel/fork.c:3022:43: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct refcount_struct const [usertype] *r @@     got struct refcount_struct [noderef] __rcu * @@
   kernel/fork.c:3022:43: sparse:     expected struct refcount_struct const [usertype] *r
   kernel/fork.c:3022:43: sparse:     got struct refcount_struct [noderef] __rcu *
   kernel/fork.c: note: in included file (through include/linux/pagemap.h, include/linux/mempolicy.h):
>> include/linux/mm.h:752:21: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected unsigned long *dst @@     got unsigned long [noderef] * @@
   include/linux/mm.h:752:21: sparse:     expected unsigned long *dst
   include/linux/mm.h:752:21: sparse:     got unsigned long [noderef] *
   kernel/fork.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/slab.h):
   include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
   include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
   include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
   include/linux/mm_types.h:1248:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
   include/linux/mm_types.h:1248:33: sparse:     expected unsigned long *bitmap
   include/linux/mm_types.h:1248:33: sparse:     got unsigned long [noderef] *
   include/linux/mm_types.h:1248:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
   include/linux/mm_types.h:1248:33: sparse:     expected unsigned long *bitmap
   include/linux/mm_types.h:1248:33: sparse:     got unsigned long [noderef] *
   kernel/fork.c:1712:9: sparse: sparse: dereference of noderef expression
   kernel/fork.c:1851:36: sparse: sparse: context imbalance in 'pidfd_prepare' - different lock contexts for basic block
   kernel/fork.c:2047:22: sparse: sparse: dereference of noderef expression
   kernel/fork.c: note: in included file (through include/uapi/asm-generic/bpf_perf_event.h, arch/microblaze/include/generated/uapi/asm/bpf_perf_event.h, ...):
   include/linux/ptrace.h:210:45: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct task_struct *new_parent @@     got struct task_struct [noderef] __rcu *parent @@
   include/linux/ptrace.h:210:45: sparse:     expected struct task_struct *new_parent
   include/linux/ptrace.h:210:45: sparse:     got struct task_struct [noderef] __rcu *parent
   include/linux/ptrace.h:210:62: sparse: sparse: incorrect type in argument 3 (different address spaces) @@     expected struct cred const *ptracer_cred @@     got struct cred const [noderef] __rcu *ptracer_cred @@
   include/linux/ptrace.h:210:62: sparse:     expected struct cred const *ptracer_cred
   include/linux/ptrace.h:210:62: sparse:     got struct cred const [noderef] __rcu *ptracer_cred
   kernel/fork.c:2391:59: sparse: sparse: dereference of noderef expression
   kernel/fork.c:2392:59: sparse: sparse: dereference of noderef expression

vim +752 include/linux/mm.h

34e1a4ccaed274 Lorenzo Stoakes 2025-08-12  749  
34e1a4ccaed274 Lorenzo Stoakes 2025-08-12  750  static inline void mm_flags_clear_all(struct mm_struct *mm)
34e1a4ccaed274 Lorenzo Stoakes 2025-08-12  751  {
34e1a4ccaed274 Lorenzo Stoakes 2025-08-12 @752  	bitmap_zero(ACCESS_PRIVATE(&mm->_flags, __mm_flags), NUM_MM_FLAG_BITS);
34e1a4ccaed274 Lorenzo Stoakes 2025-08-12  753  }
34e1a4ccaed274 Lorenzo Stoakes 2025-08-12  754  

:::::: The code at line 752 was first introduced by commit
:::::: 34e1a4ccaed27416e7c6cd5ec43d9f3f41bf107b mm: add bitmap mm->flags field

:::::: TO: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

