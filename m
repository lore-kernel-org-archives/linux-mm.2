Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC4ECA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 21:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC006B0005; Sat, 23 Aug 2025 17:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C9C6B009D; Sat, 23 Aug 2025 17:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2786B009E; Sat, 23 Aug 2025 17:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 289FE6B0005
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 17:33:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B02A6C06E1
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 21:33:29 +0000 (UTC)
X-FDA: 83809323738.10.D3EBBFD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8632040005
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 21:33:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fvX0i9Xi;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755984807; a=rsa-sha256;
	cv=none;
	b=Wp/Q241DBdzHFz8d588SRUAs8hK9EX4HRUSYRZGPeEoOyO6rxdg5b7aeoN+v4J93gg5MU9
	TeDkb12xZ/7V89Fqzg02hacrg8SjSoME4VFmcM+C/Z4EII7HbhR87FY4NFRx9Ls+ELZOON
	eX0Vme7coHQ04jnGBGefeF2y+E6wN1M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fvX0i9Xi;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755984807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=k82w1bTDUun2DRH1pU1dwZxZm9kMAK7N3Gi9DEtJK0c=;
	b=Dv1GtlNNjJQ0Xb5m8Xuhw0Pa4CKzaxbJrtVpPM/iO+o8qfJNfOPbVqsSs86m3Idp5iM/bV
	pE/ZpmUvxjnn71alqatZuqUJfg9EEWThnpXN/TbJDBj/HBP6EWNDZl6P9aYfPnS5N+imp6
	wFNruRKyqfEr3+5ROJBbZFJ2akURCLI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755984806; x=1787520806;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=4lB4ZWaoUpsKCSctqo4glCE+ZiQrCUp31zuWaHp4ozQ=;
  b=fvX0i9XiaubOpe3JSvR8Iq72jTw/uLAtIkNmkLajAJboBRdVF3sWmNVK
   r3cbj0rk6OwowhQxjT3RThbK/bOKQmvphMIdC/2xg1gmyVBCbg7qumLn2
   K154uFfAA8vtBZc1NEaFmvklpxyEtkmkFSt6pEA1AaNsKo7WY76aVpS2c
   r5GkxTEcyyI5PXtHzLbocVOdRHBrkoSkQm2pte0TfxgZ927/4RGpEJ/Td
   g2Kg8846p/CZ9X6AzM0xsbHSWF02FPOEV6+VLxxDP+K7svXDE/Hxbo4KG
   RI1brziW+ugAK14Zgihfm51wDrWfUyJadAp2BEp2c84CbI3jxZpt0CnEA
   w==;
X-CSE-ConnectionGUID: KsWmjCiORTyB0ga3ryhtxg==
X-CSE-MsgGUID: srGvRr3oQCWDLqTEaF49GQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="83662447"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="83662447"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2025 14:33:24 -0700
X-CSE-ConnectionGUID: spER6Wy7RNST0PVKB7e+jA==
X-CSE-MsgGUID: bl+Bir3uQbqoTISMVL7BfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="174252594"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 23 Aug 2025 14:33:22 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1upvr4-000Mbz-1i;
	Sat, 23 Aug 2025 21:33:04 +0000
Date: Sun, 24 Aug 2025 05:32:49 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [akpm-mm:mm-unstable 125/221] include/linux/compiler.h:166:45:
 warning: unused variable '__UNIQUE_ID_guard255'
Message-ID: <202508240502.frw1Krzo-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 8632040005
X-Stat-Signature: 69bpio3r519d945q9uaidum6wxgfsxsn
X-HE-Tag: 1755984806-535281
X-HE-Meta: U2FsdGVkX19z2tuKuP7XzVIYYA0UL1iRsKjonholIOkkejzOVEFCJYUb3KF5+oVtXl0DKSXMj1DBWtrXbbcq4yxW3ZAOvd7zRhhES0VCunK9uvWJBCppaEGaRqqgwTEv4E9FZr+6i6xLTd+g1WmFBPvrsh4j5EHMe0zwovsAOlDqkeflzOLGrxJhIToAa/fO/0z1cxEbR67hzyQkcK34DgCzTZG34f+lW1MgWi6LvyPEzufso9mTyOUJ8vJ87FEaEmC0hHmnj0+X2kQYexD5DT/6ne7libgm4WCVgAt9rUNFoVDqdNOFJZHact84xfLDApzgycAyfjzHepwYl0cEn8iGk/u0BeLlFt30IdWGIxR1xn9w/qefLN7uimJHIEiZ1pIfu0QNp9Yf0Su76WRgwPZ3yz4sx5DzjWNyvcRjLBPGuYnic4yL9Q5BncwCGpAlpP7iQ0KYTNj8ne30neGCscBWzCK3J1kwm18drKJ9mMNq7MLDe8zxuvhS4LI1rFBpJqNVbpxQcdM4WNfq8N5iKR4Azy3HIgMJQ80rHL9hVs2uoKzsuhyMGvQbkKOWLbgJSRwKne4oXPVPDeV3194+FrA++ARmzzfnnsfyNX30OCTfJHQ9as/mRGcL2C34R1mNR1Vfu55lNsODcLphn4QupfZYc2Eys9+rzrAIAaCWihimyOXQ3S3WSxsJqGXvFvSgmfwdJmJlkKR333zXBzaovUfzX6poBUBFNNIME3f51Cjc1dNftDAkX0Ct3tN3848LJPpS5E5xRxjb6aVE+aC3cW4iqopJzrMaKu/ZM/j1FNyfEKbDyQrCQivqxoD17eoQR0WWfLr6hFyfyx3CPXK91mV5ubfIF7nA4w/eIFX4sXZDX6bwiRuuWa3UcouhnLeK5N8qXT9sYeVCBAoDicBtSu6YdpKQCSW59iViiXw1kseKVrzWlVMcrnBF/vo9wv/w8BukA1PJpYjm2y/pCbw
 OQmYCYir
 LjfbPN5qnlMBbr37yeb5ii8sqFr+U1dgJwg1Q8WJR6/7GBu9JPe/pc9zfQKJkFg4HAD5/3XB8Xf42Y6ghGknGf4VwZb+LvTsjAOaOt5So131p0dVG/kLOqO9kzC9GI5XkzzdIlrXY7NLQGlNIsiaTi1RhbFRGTy1tW8jLg+3GKGr6s5ZkQ6iBUmrOhztmvtA+z3NCYEBjmgMcrTAZ6LLGZG/ssTwTmf27IuFj70CM91xQEPhksOy/297S5KP2mnTrCtKashpLpR8KrSg4FvNrRG67yK4JEeTyI3OKNHPtJDPZoIXjCf97UiURo+VRTNfeBp3WxP70YJ4nTuG2WWZ5xgzTV1Mgkj5M790XtU8ny4lWpfL4m8bCkpD5OZ0SKQO/P6a1j0PZ3GO05D10huzY0/PXXpHQTdj3pGfU5pD4QDJ57mrc07Ri+qZrC3XgWLFo2Vg0cZpuKLtkYn3K/wiM/8TTwrLmzpWY/0wcY+WtKIB73AA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   3c3393d4b766eebdc475ea5bd6bbd3a221e2526e
commit: 98a7f4a3d2b1655e323e6943cf0203d0bd5a64eb [125/221] mm: update coredump logic to correctly use bitmap mm flags
config: arc-randconfig-r071-20250824 (https://download.01.org/0day-ci/archive/20250824/202508240502.frw1Krzo-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250824/202508240502.frw1Krzo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508240502.frw1Krzo-lkp@intel.com/

All warnings (new ones prefixed by >>):

   include/linux/sched/task.h: At top level:
   include/linux/sched/task.h:99:41: warning: 'struct pid' declared inside parameter list will not be visible outside of this definition or declaration
      99 | struct task_struct *copy_process(struct pid *pid, int trace, int node,
         |                                         ^~~
   include/linux/sched/task.h: In function 'arch_thread_struct_whitelist':
   include/linux/sched/task.h:178:40: error: invalid application of 'sizeof' to incomplete type 'struct task_struct'
     178 | # define arch_task_struct_size (sizeof(struct task_struct))
         |                                        ^~~~~~
   include/linux/sched/task.h:191:10: note: in expansion of macro 'arch_task_struct_size'
     191 |  *size = arch_task_struct_size - offsetof(struct task_struct, thread);
         |          ^~~~~~~~~~~~~~~~~~~~~
   In file included from include/uapi/linux/posix_types.h:5,
                    from include/uapi/linux/types.h:14,
                    from include/linux/types.h:6,
                    from include/uapi/linux/sched.h:5,
                    from include/linux/sched.h:10,
                    from arch/arc/kernel/asm-offsets.c:6:
   include/linux/stddef.h:16:32: error: invalid use of undefined type 'struct task_struct'
      16 | #define offsetof(TYPE, MEMBER) __builtin_offsetof(TYPE, MEMBER)
         |                                ^~~~~~~~~~~~~~~~~~
   include/linux/sched/task.h:191:34: note: in expansion of macro 'offsetof'
     191 |  *size = arch_task_struct_size - offsetof(struct task_struct, thread);
         |                                  ^~~~~~~~
   In file included from include/linux/sched/user.h:9,
                    from include/linux/cred.h:18,
                    from include/linux/sched/signal.h:10,
                    from include/linux/rcuwait.h:6,
                    from include/linux/mm.h:36,
                    from arch/arc/include/asm/arcregs.h:149,
                    from arch/arc/include/asm/irqflags-compact.h:16,
                    from arch/arc/include/asm/irqflags.h:11,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/sched.h:37,
                    from arch/arc/kernel/asm-offsets.c:6:
   include/linux/ratelimit.h: In function 'ratelimit_state_init':
   include/linux/ratelimit.h:14:2: error: implicit declaration of function 'raw_spin_lock_init' [-Werror=implicit-function-declaration]
      14 |  raw_spin_lock_init(&rs->lock);
         |  ^~~~~~~~~~~~~~~~~~
   include/linux/ratelimit.h: In function 'ratelimit_state_reset_interval':
   include/linux/ratelimit.h:44:2: error: implicit declaration of function 'raw_spin_lock_irqsave'; did you mean 'read_seqbegin_or_lock_irqsave'? [-Werror=implicit-function-declaration]
      44 |  raw_spin_lock_irqsave(&rs->lock, flags);
         |  ^~~~~~~~~~~~~~~~~~~~~
         |  read_seqbegin_or_lock_irqsave
   include/linux/ratelimit.h:49:2: error: implicit declaration of function 'raw_spin_unlock_irqrestore'; did you mean 'write_sequnlock_irqrestore'? [-Werror=implicit-function-declaration]
      49 |  raw_spin_unlock_irqrestore(&rs->lock, flags);
         |  ^~~~~~~~~~~~~~~~~~~~~~~~~~
         |  write_sequnlock_irqrestore
   In file included from include/linux/sched/signal.h:12,
                    from include/linux/rcuwait.h:6,
                    from include/linux/mm.h:36,
                    from arch/arc/include/asm/arcregs.h:149,
                    from arch/arc/include/asm/irqflags-compact.h:16,
                    from arch/arc/include/asm/irqflags.h:11,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/sched.h:37,
                    from arch/arc/kernel/asm-offsets.c:6:
   include/linux/pid.h: In function 'pid_alive':
   include/linux/pid.h:267:10: error: dereferencing pointer to incomplete type 'const struct task_struct'
     267 |  return p->thread_pid != NULL;
         |          ^~
   In file included from include/linux/preempt.h:11,
                    from include/linux/sched.h:15,
                    from arch/arc/kernel/asm-offsets.c:6:
   include/linux/hrtimer.h: In function 'hrtimer_update_function':
   include/linux/cleanup.h:290:2: error: unknown type name 'class_raw_spinlock_irqsave_t'; did you mean 'class_local_lock_irqsave_t'?
     290 |  class_##_name##_t var __cleanup(class_##_name##_destructor) = \
         |  ^~~~~~
   include/linux/cleanup.h:401:2: note: in expansion of macro 'CLASS'
     401 |  CLASS(_name, __UNIQUE_ID(guard))
         |  ^~~~~
   include/linux/hrtimer.h:340:2: note: in expansion of macro 'guard'
     340 |  guard(raw_spinlock_irqsave)(&timer->base->cpu_base->lock);
         |  ^~~~~
   In file included from include/linux/alarmtimer.h:6,
                    from include/linux/posix-timers.h:5,
                    from include/linux/sched/signal.h:13,
                    from include/linux/rcuwait.h:6,
                    from include/linux/mm.h:36,
                    from arch/arc/include/asm/arcregs.h:149,
                    from arch/arc/include/asm/irqflags-compact.h:16,
                    from arch/arc/include/asm/irqflags.h:11,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/sched.h:37,
                    from arch/arc/kernel/asm-offsets.c:6:
   include/linux/hrtimer.h:340:2: error: cleanup argument not a function
   In file included from include/linux/preempt.h:11,
                    from include/linux/sched.h:15,
                    from arch/arc/kernel/asm-offsets.c:6:
   include/linux/cleanup.h:291:3: error: implicit declaration of function 'class_raw_spinlock_irqsave_constructor'; did you mean 'class_local_lock_irqsave_constructor'? [-Werror=implicit-function-declaration]
     291 |   class_##_name##_constructor
         |   ^~~~~~
   include/linux/cleanup.h:401:2: note: in expansion of macro 'CLASS'
     401 |  CLASS(_name, __UNIQUE_ID(guard))
         |  ^~~~~
   include/linux/hrtimer.h:340:2: note: in expansion of macro 'guard'
     340 |  guard(raw_spinlock_irqsave)(&timer->base->cpu_base->lock);
         |  ^~~~~
>> include/linux/compiler.h:166:45: warning: unused variable '__UNIQUE_ID_guard255' [-Wunused-variable]
     166 | #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
         |                                             ^~~~~~~~~~~~
   include/linux/cleanup.h:290:20: note: in definition of macro 'CLASS'
     290 |  class_##_name##_t var __cleanup(class_##_name##_destructor) = \
         |                    ^~~
   include/linux/compiler_types.h:84:22: note: in expansion of macro '___PASTE'
      84 | #define __PASTE(a,b) ___PASTE(a,b)
         |                      ^~~~~~~~
   include/linux/compiler.h:166:29: note: in expansion of macro '__PASTE'
     166 | #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
         |                             ^~~~~~~
   include/linux/compiler_types.h:84:22: note: in expansion of macro '___PASTE'
      84 | #define __PASTE(a,b) ___PASTE(a,b)
         |                      ^~~~~~~~
   include/linux/compiler.h:166:37: note: in expansion of macro '__PASTE'
     166 | #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
         |                                     ^~~~~~~
   include/linux/cleanup.h:401:15: note: in expansion of macro '__UNIQUE_ID'
     401 |  CLASS(_name, __UNIQUE_ID(guard))
         |               ^~~~~~~~~~~
   include/linux/hrtimer.h:340:2: note: in expansion of macro 'guard'
     340 |  guard(raw_spinlock_irqsave)(&timer->base->cpu_base->lock);
         |  ^~~~~
   In file included from include/linux/rbtree.h:24,
                    from include/linux/mm_types.h:11,
                    from include/linux/mmzone.h:22,
                    from include/linux/gfp.h:7,
                    from include/linux/mm.h:7,
                    from arch/arc/include/asm/arcregs.h:149,
                    from arch/arc/include/asm/irqflags-compact.h:16,
                    from arch/arc/include/asm/irqflags.h:11,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/sched.h:37,
                    from arch/arc/kernel/asm-offsets.c:6:
   include/linux/rcuref.h: In function '__rcuref_put':
   include/linux/preempt.h:227:49: error: implicit declaration of function 'irqs_disabled' [-Werror=implicit-function-declaration]
     227 | #define preemptible() (preempt_count() == 0 && !irqs_disabled())
         |                                                 ^~~~~~~~~~~~~
   include/linux/rcupdate.h:399:39: note: in definition of macro 'RCU_LOCKDEP_WARN'
     399 |   if (debug_lockdep_rcu_enabled() && (c) &&  \
         |                                       ^
   include/linux/rcuref.h:103:44: note: in expansion of macro 'preemptible'
     103 |  RCU_LOCKDEP_WARN(!rcu_read_lock_held() && preemptible(),
         |                                            ^~~~~~~~~~~
   In file included from include/linux/rcuwait.h:6,
                    from include/linux/mm.h:36,
                    from arch/arc/include/asm/arcregs.h:149,
                    from arch/arc/include/asm/irqflags-compact.h:16,
                    from arch/arc/include/asm/irqflags.h:11,
                    from include/linux/irqflags.h:18,
                    from include/linux/spinlock.h:59,
                    from include/linux/sched.h:37,
                    from arch/arc/kernel/asm-offsets.c:6:
   include/linux/sched/signal.h: At top level:
   include/linux/sched/signal.h:192:22: error: field 'prev_cputime' has incomplete type
     192 |  struct prev_cputime prev_cputime;
         |                      ^~~~~~~~~~~~
   include/linux/sched/signal.h:197:28: error: field 'ioac' has incomplete type
     197 |  struct task_io_accounting ioac;
         |                            ^~~~
   include/linux/sched/signal.h: In function 'kernel_signal_stop':
   include/linux/sched/signal.h:302:3: error: implicit declaration of function 'set_special_state' [-Werror=implicit-function-declaration]
     302 |   set_special_state(TASK_STOPPED);
         |   ^~~~~~~~~~~~~~~~~
   include/linux/sched/signal.h:302:21: error: 'TASK_STOPPED' undeclared (first use in this function); did you mean 'CLD_STOPPED'?
     302 |   set_special_state(TASK_STOPPED);
         |                     ^~~~~~~~~~~~
         |                     CLD_STOPPED
   include/linux/sched/signal.h:306:2: error: implicit declaration of function 'schedule'; did you mean 'sched_exec'? [-Werror=implicit-function-declaration]
     306 |  schedule();
         |  ^~~~~~~~
         |  sched_exec
   include/linux/sched/signal.h: In function '__set_notify_signal':
   include/linux/sched/signal.h:357:10: error: implicit declaration of function 'test_and_set_tsk_thread_flag'; did you mean 'test_and_set_ti_thread_flag'? [-Werror=implicit-function-declaration]
     357 |  return !test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
         |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |          test_and_set_ti_thread_flag
   include/linux/sched/signal.h:358:10: error: implicit declaration of function 'wake_up_state'; did you mean 'wake_up_sync'? [-Werror=implicit-function-declaration]
     358 |         !wake_up_state(task, TASK_INTERRUPTIBLE);
         |          ^~~~~~~~~~~~~
         |          wake_up_sync
   include/linux/sched/signal.h:358:30: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function); did you mean 'FOLL_INTERRUPTIBLE'?
     358 |         !wake_up_state(task, TASK_INTERRUPTIBLE);
         |                              ^~~~~~~~~~~~~~~~~~
         |                              FOLL_INTERRUPTIBLE
   include/linux/sched/signal.h: In function 'set_notify_signal':
   include/linux/sched/signal.h:368:3: error: implicit declaration of function 'kick_process'; did you mean 'copy_process'? [-Werror=implicit-function-declaration]
     368 |   kick_process(task);
         |   ^~~~~~~~~~~~
         |   copy_process
   include/linux/sched/signal.h: In function 'restart_syscall':
   include/linux/sched/signal.h:373:2: error: implicit declaration of function 'set_tsk_thread_flag'; did you mean 'set_ti_thread_flag'? [-Werror=implicit-function-declaration]
     373 |  set_tsk_thread_flag(current, TIF_SIGPENDING);
         |  ^~~~~~~~~~~~~~~~~~~
         |  set_ti_thread_flag
   In file included from arch/arc/include/asm/ptrace.h:11,
                    from arch/arc/include/asm/processor.h:16,
                    from include/linux/sched.h:13,
                    from arch/arc/kernel/asm-offsets.c:6:


vim +/__UNIQUE_ID_guard255 +166 include/linux/compiler.h

fe8c8a126806fe Cesar Eduardo Barros 2013-11-25  165  
a8306f2d4dcea0 Nick Desaulniers     2023-08-31 @166  #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
6f33d58794ef4c Rusty Russell        2012-11-22  167  

:::::: The code at line 166 was first introduced by commit
:::::: a8306f2d4dcea03538c70c26d2948483f70254ff compiler.h: unify __UNIQUE_ID

:::::: TO: Nick Desaulniers <ndesaulniers@google.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

