Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8280CCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 18:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F66D9000C3; Wed, 13 Aug 2025 14:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A752900088; Wed, 13 Aug 2025 14:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED88E9000C3; Wed, 13 Aug 2025 14:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6A54900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:30:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78CE61DD0CD
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:30:54 +0000 (UTC)
X-FDA: 83772575628.10.C30F484
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf08.hostedemail.com (Postfix) with ESMTP id A861316000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:30:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lJPYFq0e;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755109852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rpzjyhVXETjw2NjSpn3wdhmeomhVC9bQF8B1fNetYew=;
	b=x54KUGhOUuYmKIFNgNhG6vd7az232T/pvxiv/1dOMyfvNxGX1VpyOi17oz4RfCuUGZz/Dk
	RH0sRV3tIZDJLsxHDEZwWgNSCaT+2UwTntggEIevFddji2EPrJZlPW2IeFOniX1/XFEa9o
	TGz2jM6+txZ4HzR62CAegyBI5/Ayhe8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lJPYFq0e;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755109852; a=rsa-sha256;
	cv=none;
	b=8l5aQvmFBtDtPxiNKIADk+wqWUgPTM3Arunt3py9rcXedO8RlV6zSd5jT/vOZqU9qm/S26
	OX6lsEyt46hgDxh0Yjvjn/ENmO+uzx50AA5lbxiy8U7ILqjlmQzQlj7pEewVYojmeZjntn
	zwk16bqJ/os6CtD+byZ79Wz5AL+a9Wo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755109852; x=1786645852;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=B2MTJJiGzyaO+z+/8AKwk9NEx40iP0hNgNls3qkVc9U=;
  b=lJPYFq0eo+Ox3buXLVAk6k/WfRkyd+XeH/IXe5fkXaoHXLaAoEY72R5f
   q5BMsxGZMmTuY/yxVQqHl5iI+382KwBaMiYPGD78XUbYJ30bPG7RcHkbp
   Jy/L+3fYpvIDGr5z+2Rl6aEianqr8lo7wyYc5TRrka04v4D05lsv7ZDTX
   is6MDhliOLhDcGB6aCnOnMd7k/W7liPSmqbuIMDwIcvoS250FED2jb2Ua
   NZx+/5dbph9ep8ytQCs5g1T05qMIyxSWd5jrv2FFg1McH4VGQvJ00cISU
   902ITxHnM/9MXwxPNZhl4/vG6oFnH7evmKQSNE+oI+YMs/OegftLyE/fd
   Q==;
X-CSE-ConnectionGUID: WVhcy3uOR4au3f9/PbLDGA==
X-CSE-MsgGUID: YPXqgd+fTdeBwLhTfazlHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="79989594"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="79989594"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 11:30:51 -0700
X-CSE-ConnectionGUID: 20xNIuIlTJiCTCgTW77P9Q==
X-CSE-MsgGUID: qpKQ4966Q3WH2JhxKzl79A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="203715306"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 13 Aug 2025 11:30:49 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umGFF-000ADo-2h;
	Wed, 13 Aug 2025 18:30:42 +0000
Date: Thu, 14 Aug 2025 02:29:47 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [akpm-mm:mm-new 125/137] include/linux/sched/coredump.h:23:33:
 sparse: sparse: incorrect type in initializer (different modifiers)
Message-ID: <202508140219.D4jGTlbP-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: e3iutg6f6mjzm579q8rgpfyuhf4aswqr
X-Rspam-User: 
X-Rspamd-Queue-Id: A861316000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1755109851-750981
X-HE-Meta: U2FsdGVkX1/ROP1vzTsPKvARZ6rgqef1juIiw7wkPgq5DoM/boPBcGLPeiVGQxOZLswVA9pGdrIHYBYYHapwlwnuaXbYRXMC/jsf63kSuzdrlQzfDWkXytcXODTXEQhQ389C+KnFUDIYfJdEBKI6ynN7KkwwdoqJYP+FfFzYqXwTLnyrgGx6rct21kFzqua4rxwJrXHRIam7EsVcjI3IeaCsQgrV00d8MgyS4nq7jIltc7Vam07BlJVr+MSs+RCYXvoGWEhdDGxY7qrvNqoU5O0T+zBg2gB8XyXak20wIY2qP8rB0HV/FI/0Q61xUxFYKyaRkl23vuCUP7Kllmni+0DlCky1xZJxdgjUe8jZkn7BWMlqTg4NhwdATPV7w2x4LYXWoQMlYiA4LAeHgzHf+wwycDCmsYTURnBmAPZLSJuoqJo24kyFni51nohUMUqNT70n2w6fgQJi5zxmrnAf5dEskoeiPmmTJUHvdQnmjBMos5j0SDmULK1oiGCp/yBOEyAy+s57161OqzjbkWcjrA9S4lJVPNw3LMmVCjNaNnPzEXJKyhm/BCoB4GDjEpdzZnPmoMTgdUGQYS0iENba8hoMNdm88wyVntNtbIBrWlqnNa2DBbziXLe8IoDJynoksuUW666IA7KKLMHmFFnthDc39vABfYPqEWojgYlWkh5/2hs/k/HuJ6juySvD/YhzwMnHRxf2AwHX82m695EJw5FmA184UnkLyErGz5+pPJJGm4o4Np5DyqNa/xubFiu9HAwzqRD60eWZnAQtSOaFdl1EeBAC+v2LKInNccgnQv7Ka4hffCOnLduf58EXgCcs340Bia1+M8I2CxAxPhqoU+Xx0DfxB6XyDqvJygnJGJ6To+guoGApfp1J+FviKjC5QcN30LbHNNnyQIHGs5JJkkjsFxs4WdE2yg0z/l7cdeB9HiaPyd0o7j+k5z4m8ejdfW3IczND/iL0y71jtRu
 wqTAK6jB
 C3yVoi1peqiWIet8C9UDqZ1J+d+8vJxF7XSiQDZ0r+4ddaJRLw3tCZ+tLUHHR8B8Snm0j3JOdV0vShaTBC9xKu88USLTRgA+swchHf7TXL9C4Gh+PSA+2Guj3/B2yo+wyfsuN6DusecOAY5AsZjYH1q7XAULpz6lv77KYpohFj60KvLZVb7UyINgax77MPqoKZlJVp6Zb8y/iSd1KkJxwwqb69/CClnkiR1IendOwpqFOqw+er3a2VNOqUY8WMLKZn9S2g/d+YajLEu75WjKx3695Pj7goaixWtN3IHb5g+Zr4AaekvZvO27LPA5Aj94b22PWeZmj9sJeO9Z55Nx97917LIVBq56eLe5cFt+R/hxB00NHV0AWIgzQHfRhFhmaxXDPyArDiJYL1Rc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   694c8e78f486b09137ee3efadae044d01aba971b
commit: 63e795236094c47c4030f1203c798c511f9ac6f0 [125/137] mm: update coredump logic to correctly use bitmap mm flags
config: microblaze-randconfig-r131-20250813 (https://download.01.org/0day-ci/archive/20250814/202508140219.D4jGTlbP-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 12.5.0
reproduce: (https://download.01.org/0day-ci/archive/20250814/202508140219.D4jGTlbP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508140219.D4jGTlbP-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   fs/exec.c:318:31: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected char const [noderef] __user * @@     got void * @@
   fs/exec.c:318:31: sparse:     expected char const [noderef] __user *
   fs/exec.c:318:31: sparse:     got void *
   fs/exec.c:911:48: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sighand_struct *oldsighand @@     got struct sighand_struct [noderef] __rcu *sighand @@
   fs/exec.c:911:48: sparse:     expected struct sighand_struct *oldsighand
   fs/exec.c:911:48: sparse:     got struct sighand_struct [noderef] __rcu *sighand
   fs/exec.c:1017:56: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct task_struct *parent @@     got struct task_struct [noderef] __rcu *parent @@
   fs/exec.c:1017:56: sparse:     expected struct task_struct *parent
   fs/exec.c:1017:56: sparse:     got struct task_struct [noderef] __rcu *parent
   fs/exec.c:1052:47: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sighand_struct *oldsighand @@     got struct sighand_struct [noderef] __rcu *sighand @@
   fs/exec.c:1052:47: sparse:     expected struct sighand_struct *oldsighand
   fs/exec.c:1052:47: sparse:     got struct sighand_struct [noderef] __rcu *sighand
   fs/exec.c:1167:26: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/exec.c:1167:26: sparse:     expected struct spinlock [usertype] *lock
   fs/exec.c:1167:26: sparse:     got struct spinlock [noderef] __rcu *
   fs/exec.c:1169:28: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/exec.c:1169:28: sparse:     expected struct spinlock [usertype] *lock
   fs/exec.c:1169:28: sparse:     got struct spinlock [noderef] __rcu *
   fs/exec.c:1693:70: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *tsk @@     got struct task_struct [noderef] __rcu *parent @@
   fs/exec.c:1693:70: sparse:     expected struct task_struct *tsk
   fs/exec.c:1693:70: sparse:     got struct task_struct [noderef] __rcu *parent
   fs/exec.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/slab.h):
>> include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
   include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
   include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
   fs/exec.c: note: in included file (through include/linux/sched/mm.h, include/linux/xarray.h, include/linux/list_lru.h, ...):
>> include/linux/sched/coredump.h:23:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
   include/linux/sched/coredump.h:23:33: sparse:     expected unsigned long *bitmap
   include/linux/sched/coredump.h:23:33: sparse:     got unsigned long [noderef] *
--
   fs/coredump.c:508:27: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/coredump.c:508:27: sparse:     expected struct spinlock [usertype] *lock
   fs/coredump.c:508:27: sparse:     got struct spinlock [noderef] __rcu *
   fs/coredump.c:517:29: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/coredump.c:517:29: sparse:     expected struct spinlock [usertype] *lock
   fs/coredump.c:517:29: sparse:     got struct spinlock [noderef] __rcu *
   fs/coredump.c:556:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/coredump.c:556:31: sparse:     expected struct spinlock [usertype] *lock
   fs/coredump.c:556:31: sparse:     got struct spinlock [noderef] __rcu *
   fs/coredump.c:561:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/coredump.c:561:33: sparse:     expected struct spinlock [usertype] *lock
   fs/coredump.c:561:33: sparse:     got struct spinlock [noderef] __rcu *
   fs/coredump.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/slab.h):
>> include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
   include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
   include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
--
   kernel/ptrace.c:55:22: sparse: sparse: incompatible types in comparison expression (different address spaces):
   kernel/ptrace.c:55:22: sparse:    struct task_struct *
   kernel/ptrace.c:55:22: sparse:    struct task_struct [noderef] __rcu *
   kernel/ptrace.c:74:23: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct task_struct [noderef] __rcu *parent @@     got struct task_struct *new_parent @@
   kernel/ptrace.c:74:23: sparse:     expected struct task_struct [noderef] __rcu *parent
   kernel/ptrace.c:74:23: sparse:     got struct task_struct *new_parent
   kernel/ptrace.c:75:29: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct cred const [noderef] __rcu *ptracer_cred @@     got struct cred const * @@
   kernel/ptrace.c:75:29: sparse:     expected struct cred const [noderef] __rcu *ptracer_cred
   kernel/ptrace.c:75:29: sparse:     got struct cred const *
   kernel/ptrace.c:129:18: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct cred const *old_cred @@     got struct cred const [noderef] __rcu *ptracer_cred @@
   kernel/ptrace.c:129:18: sparse:     expected struct cred const *old_cred
   kernel/ptrace.c:129:18: sparse:     got struct cred const [noderef] __rcu *ptracer_cred
   kernel/ptrace.c:133:25: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/ptrace.c:133:25: sparse:     expected struct spinlock [usertype] *lock
   kernel/ptrace.c:133:25: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:160:27: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/ptrace.c:160:27: sparse:     expected struct spinlock [usertype] *lock
   kernel/ptrace.c:160:27: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:192:28: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/ptrace.c:192:28: sparse:     expected struct spinlock [usertype] *lock
   kernel/ptrace.c:192:28: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:198:30: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/ptrace.c:198:30: sparse:     expected struct spinlock [usertype] *lock
   kernel/ptrace.c:198:30: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:251:44: sparse: sparse: incompatible types in comparison expression (different address spaces):
   kernel/ptrace.c:251:44: sparse:    struct task_struct [noderef] __rcu *
   kernel/ptrace.c:251:44: sparse:    struct task_struct *
   kernel/ptrace.c:494:54: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *parent @@     got struct task_struct [noderef] __rcu *parent @@
   kernel/ptrace.c:494:54: sparse:     expected struct task_struct *parent
   kernel/ptrace.c:494:54: sparse:     got struct task_struct [noderef] __rcu *parent
   kernel/ptrace.c:502:53: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct task_struct *new_parent @@     got struct task_struct [noderef] __rcu *real_parent @@
   kernel/ptrace.c:502:53: sparse:     expected struct task_struct *new_parent
   kernel/ptrace.c:502:53: sparse:     got struct task_struct [noderef] __rcu *real_parent
   kernel/ptrace.c:550:41: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *p1 @@     got struct task_struct [noderef] __rcu *real_parent @@
   kernel/ptrace.c:550:41: sparse:     expected struct task_struct *p1
   kernel/ptrace.c:550:41: sparse:     got struct task_struct [noderef] __rcu *real_parent
   kernel/ptrace.c:552:50: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sighand_struct *sigh @@     got struct sighand_struct [noderef] __rcu *sighand @@
   kernel/ptrace.c:552:50: sparse:     expected struct sighand_struct *sigh
   kernel/ptrace.c:552:50: sparse:     got struct sighand_struct [noderef] __rcu *sighand
   kernel/ptrace.c:743:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/ptrace.c:743:37: sparse:     expected struct spinlock [usertype] *lock
   kernel/ptrace.c:743:37: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:751:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/ptrace.c:751:39: sparse:     expected struct spinlock [usertype] *lock
   kernel/ptrace.c:751:39: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:862:29: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/ptrace.c:862:29: sparse:     expected struct spinlock [usertype] *lock
   kernel/ptrace.c:862:29: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:866:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/ptrace.c:866:31: sparse:     expected struct spinlock [usertype] *lock
   kernel/ptrace.c:866:31: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:1221:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/ptrace.c:1221:37: sparse:     expected struct spinlock [usertype] *lock
   kernel/ptrace.c:1221:37: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:1223:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/ptrace.c:1223:39: sparse:     expected struct spinlock [usertype] *lock
   kernel/ptrace.c:1223:39: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c: note: in included file (through include/linux/rcuwait.h, include/linux/mm.h):
   include/linux/sched/signal.h:752:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   include/linux/sched/signal.h:752:37: sparse:     expected struct spinlock [usertype] *lock
   include/linux/sched/signal.h:752:37: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c: note: in included file (through include/linux/sched/mm.h):
>> include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
   include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
   include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
   kernel/ptrace.c:380:30: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *l @@     got struct spinlock [noderef] __rcu * @@
   kernel/ptrace.c:380:30: sparse:     expected struct spinlock [usertype] *l
   kernel/ptrace.c:380:30: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:409:12: sparse: sparse: context imbalance in 'ptrace_attach' - different lock contexts for basic block
   kernel/ptrace.c:500:38: sparse: sparse: dereference of noderef expression
   kernel/ptrace.c: note: in included file (through include/linux/rcuwait.h, include/linux/mm.h):
   include/linux/sched/signal.h:752:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   include/linux/sched/signal.h:752:37: sparse:     expected struct spinlock [usertype] *lock
   include/linux/sched/signal.h:752:37: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:690:9: sparse: sparse: context imbalance in 'ptrace_getsiginfo' - different lock contexts for basic block
   include/linux/sched/signal.h:752:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   include/linux/sched/signal.h:752:37: sparse:     expected struct spinlock [usertype] *lock
   include/linux/sched/signal.h:752:37: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:706:9: sparse: sparse: context imbalance in 'ptrace_setsiginfo' - different lock contexts for basic block
   include/linux/sched/signal.h:752:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   include/linux/sched/signal.h:752:37: sparse:     expected struct spinlock [usertype] *lock
   include/linux/sched/signal.h:752:37: sparse:     got struct spinlock [noderef] __rcu *
   include/linux/sched/signal.h:752:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   include/linux/sched/signal.h:752:37: sparse:     expected struct spinlock [usertype] *lock
   include/linux/sched/signal.h:752:37: sparse:     got struct spinlock [noderef] __rcu *
   kernel/ptrace.c:1384:9: sparse: sparse: context imbalance in 'ptrace_request' - different lock contexts for basic block
--
   kernel/sys.c:1144:32: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *p1 @@     got struct task_struct [noderef] __rcu *real_parent @@
   kernel/sys.c:1144:32: sparse:     expected struct task_struct *p1
   kernel/sys.c:1144:32: sparse:     got struct task_struct [noderef] __rcu *real_parent
   kernel/sys.c:1894:33: sparse: sparse: context imbalance in 'getrusage' - different lock contexts for basic block
   kernel/sys.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/mm.h):
>> include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
   include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
   include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
   kernel/sys.c: note: in included file:
   include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
   include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
   include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
   include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
   include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
   include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
   include/linux/mm.h:742:23: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
   include/linux/mm.h:742:23: sparse:     expected unsigned long volatile *addr
   include/linux/mm.h:742:23: sparse:     got unsigned long [noderef] *
   include/linux/mm.h:747:25: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
   include/linux/mm.h:747:25: sparse:     expected unsigned long volatile *addr
   include/linux/mm.h:747:25: sparse:     got unsigned long [noderef] *
   include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
   include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
   include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
   include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
   include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
   include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
   include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
   include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
   include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
   include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
   include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
   include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
   include/linux/mm.h:742:23: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
   include/linux/mm.h:742:23: sparse:     expected unsigned long volatile *addr
   include/linux/mm.h:742:23: sparse:     got unsigned long [noderef] *
   include/linux/mm.h:742:23: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
   include/linux/mm.h:742:23: sparse:     expected unsigned long volatile *addr
   include/linux/mm.h:742:23: sparse:     got unsigned long [noderef] *
   include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
   include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
   include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
   include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
   include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
   include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
   include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
   include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
   include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
   include/linux/mm.h:727:16: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long const [noderef] * @@
   include/linux/mm.h:727:16: sparse:     expected unsigned long const volatile *addr
   include/linux/mm.h:727:16: sparse:     got unsigned long const [noderef] *
--
   fs/proc/base.c:890:65: sparse: sparse: incompatible types in comparison expression (different address spaces):
   fs/proc/base.c:890:65: sparse:    struct task_struct [noderef] __rcu *
   fs/proc/base.c:890:65: sparse:    struct task_struct *
   fs/proc/base.c:2326:25: sparse: sparse: cast to restricted fmode_t
   fs/proc/base.c:2383:42: sparse: sparse: cast from restricted fmode_t
   fs/proc/base.c:2483:48: sparse: sparse: cast from restricted fmode_t
   fs/proc/base.c: note: in included file (through include/linux/rcuwait.h, include/linux/percpu-rwsem.h, include/linux/fs.h, ...):
   include/linux/sched/signal.h:752:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   include/linux/sched/signal.h:752:37: sparse:     expected struct spinlock [usertype] *lock
   include/linux/sched/signal.h:752:37: sparse:     got struct spinlock [noderef] __rcu *
   fs/proc/base.c:1170:36: sparse: sparse: context imbalance in '__set_oom_adj' - unexpected unlock
   fs/proc/base.c: note: in included file (through include/linux/pgtable.h, arch/microblaze/include/asm/uaccess.h, include/linux/uaccess.h):
>> include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
   include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
   include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
>> include/linux/mm_types.h:1239:33: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected unsigned long *bitmap @@     got unsigned long [noderef] * @@
   include/linux/mm_types.h:1239:33: sparse:     expected unsigned long *bitmap
   include/linux/mm_types.h:1239:33: sparse:     got unsigned long [noderef] *
   fs/proc/base.c: note: in included file:
   include/linux/mm.h:742:23: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
   include/linux/mm.h:742:23: sparse:     expected unsigned long volatile *addr
   include/linux/mm.h:742:23: sparse:     got unsigned long [noderef] *
   include/linux/mm.h:747:25: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long volatile *addr @@     got unsigned long [noderef] * @@
   include/linux/mm.h:747:25: sparse:     expected unsigned long volatile *addr
   include/linux/mm.h:747:25: sparse:     got unsigned long [noderef] *

vim +23 include/linux/sched/coredump.h

    20	
    21	static inline void __mm_flags_set_mask_dumpable(struct mm_struct *mm, int value)
    22	{
  > 23		unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
    24	
    25		set_mask_bits(bitmap, MMF_DUMPABLE_MASK, value);
    26	}
    27	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

