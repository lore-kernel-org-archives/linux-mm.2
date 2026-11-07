Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F4B606A339
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 01:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=HhPUsSs7
Received: by kanga.kvack.org (Postfix)
	id 376706B05B0; Fri,  6 Nov 2026 20:41:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E136B05B1; Fri,  6 Nov 2026 20:41:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264546B05B2; Fri,  6 Nov 2026 20:41:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E48206B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:41:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AAEDC025E
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 01:41:18 +0000 (UTC)
X-FDA: 85406620236.19.8AAD872
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id D9F121C0006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 01:41:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HhPUsSs7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794015676;
	b=dhP/d4OJ6xXQ9e5DWvDgY42kCqJ7D+xuIsvNYUYRLYiIxmmL8/uAeGDtzPxOHqQyjbzYed
	OkKYUoamwpoDiDg5HomofUvGCnCi9EuUC0KWnvn0wmE5w+rEqohVSFGXuA+OFQ1Gi2Ehzy
	3YvTbAYbJ86h+/4fx+e8supV28GAdUk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794015676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbyGC7nA73pUh7TjmjuuNPaVYbK+A9mHJCPy/Ni7H2c=;
	b=KwSX2OFRo2Z4bpFn1CTZjAcS5m2Nrz+Z1K+uPhpZq+umaaC4YLKOBuOfzNgkjBOO+I91dj
	/uIPrhR6ndWpk4/zDsH9XVUFva9jWb7fwcIJXdL34gqDGL3wIyseapsbVZ+evApk3yR/5N
	mqCebPz8l1YKHt5w9fINCEDtc4PfwdU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HhPUsSs7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794015675; x=1825551675;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aTkvPzAbJN4jNBu0r57eQZHavSgwUMEEjEAJtxIPKcM=;
  b=HhPUsSs7skLtvLAqVaTnY2N+lzE6m90VEo9hzZn1s5fEltHHm/vWCBsc
   VgvoMJrRRT7dewF6D972uvTob8DC+QDRHzgcJls5VbXcN0IKEuIkrscmC
   Uq0ybEuknmbpc9RDrA6c8/srvJNR5tZ1jP6a02mrLheGiURgcODYS51vv
   JwCQpvXPiTKWR6Hp+Q98PQXe1xE1RlyU9g0GLeqy9NwMmj9Ml2vQegU0u
   xXxtQxmHbFLikvKPwFZrioFWRhMFQH0hT0OBHEeO8YpM+U8cdEQU5U2Gn
   Jimd0vGbQibmERN+fodjoAhnho1LCFl5tCLwzl8vuv6ekX7fqn8s+hZ4+
   A==;
X-CSE-ConnectionGUID: Pm9oNLRJQbaMKtUbF2UY2Q==
X-CSE-MsgGUID: ti9x0c5TQ2SN5mT0jc63LQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11958"; a="2751744"
X-IronPort-AV: E=Sophos;i="6.27,199,1787036400"; 
   d="scan'208";a="2751744"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 17:41:13 -0800
X-CSE-ConnectionGUID: S7ZRecPUTOGgMLkqtEZAag==
X-CSE-MsgGUID: 4WSfGiz3TyO7e25/Mxp73g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,199,1787036400"; 
   d="scan'208";a="7567877"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 06 Nov 2026 17:41:06 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xPVQV-00000000qCZ-0KhF;
	Sat, 07 Nov 2026 01:41:03 +0000
Date: Sat, 7 Nov 2026 09:40:35 +0800
From: kernel test robot <lkp@intel.com>
To: Michal Wilczynski <m.wilczynski@samsung.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org
Subject: Re: [PATCH v2 10/15] lib/lz4: switch the compressor to the vendored
 sources
Message-ID: <202611070943.EDg3udaH-lkp@intel.com>
References: <20261106-lz4-vendor-upstream-v2-10-ee04c3f0d7dc@samsung.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106-lz4-vendor-upstream-v2-10-ee04c3f0d7dc@samsung.com>
X-Rspamd-Queue-Id: D9F121C0006
X-Stat-Signature: ftdisk64nnxkwzw1mgpzu7uyuwmnayeb
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794015674-353980
X-HE-Meta: U2FsdGVkX1+/1pkQ/23S3UxT2dnCjFRHPhFNIbOLrgfmVyX0a5LHrFzQTs4EovXaTE4la5nMiFGWMu+lLrZGRwlpMpYC5BhipkswY6cu32dOsS7BVJ0NbhuzOlEulyshNlwynsqE3ChU2glz9Xy94hcuUYGnacAvjBqjaT0JmxEdd6z4fO5X7yu94fL3E5HWcSjk+exZ7vOubgPeOm5WM/m0ESxawuCTtulTAsylUAOKmKRxXC9Sf5/BJdjTEFqZX84arYTzdpr796H/lCAKJa71yM9NVea42xCZmn10ffIYo7Uddw3K/LW9l3YVUaKcNJE5doFdDzuUzcpI1Sbo/u6FGxdAOSTJ5+10QwYWed+BupOzXcbwXENdi6QCuN0HYWzTyalvKYWQAyWAZQovcre/fyJrk6linJEr/fm6PCIN0tdRPHdvIUF1IAhqUBq2ebk0U6Wr4KAKCW9tHQn+wNAs78iAtlPaEoxkqH8HtkUms94FVbdGQb9enOd6ABWIHtVRcICUieJQAPq/jiojEEKg7i5VXj3pi6Dd5YBU0DI3cNyGr2q4oR8y3jQi249cSuRYGdNdBlGPLCPBC6bmfZLC+wxS1cWwJ8p+2EZ0LToM0RL7y2Ud5i99LiDD7RsS7XAjP1iBpIv9noyiiJmpbB4Iy6TkQ/Z40QEHJeCdLeb/k0wdrv9kLueXqcKW53itnB+NqF2xq+SXx9I3gU8hD3SJccd2L/b9H/XO/r9wQJuO3qToZM4ArcxNhiYOpwLWbA2JTfFzWotwypZKY0SOVki2Jh7mKgpSfxuzhlQ3pJhbU6WeH6uGekXd6NRo8oWJpvWmieRX7qqN2eyUDRY6mXQVrFWg8N7O29KfXXMTy3msPg1nLgBpnhubf3UP5xyfaz57OB55iBVQCDUrJctPwSgkEj/3L14+UAqgTKgOkCTNx8ks5nwieHXb9sM3TbY+Fc2jLFVIy8rsAk8dJ6L
 bFwohltH
 2NDqg5Hh1wERlQICWHJUS1Q3fEWHNDMmaEtTx8yc/dS254IQDTa2uylJiQamAxn5uqWQ9LPLMM8kV1hkR7CWP8iYeyN5smkE1Az8c2S2O2ne9lRdstTHy/V4cbWI7PGBVdRt2hQJBbN2uBHm4JAa9gGneyt4qcFXckrdIGCIglIX9a1+Cn2R3oyXlOQsr9Glw14LBdkabCi2bdJZnVja6W04ac/CKuFIZbrQ2J8Nype4XMtVJ/2vJ2c84y3C3LSOH+H5hoKrGIoRLV59tTcnBvCkwnSST3G3Zu9McRxp1uQdnKm8W3fVKlC5cDETemcub0s49kiJsdPYPaFGwrKEccQZCu8GIqVrXt1wHG7khNFgdVus7WymIbuoiG//tAC+qtqvGAJPWdUmf07ZphXYIAjgzcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Michal,

kernel test robot noticed the following build errors:

[auto build test ERROR on 93f51579e7df248780214094418f205253383cc5]

url:    https://github.com/intel-lab-lkp/linux/commits/Michal-Wilczynski/lib-decompress_unlz4-use-LZ4_decompress_safe_partial-before-boot/20261106-154241
base:   93f51579e7df248780214094418f205253383cc5
patch link:    https://lore.kernel.org/r/20261106-lz4-vendor-upstream-v2-10-ee04c3f0d7dc%40samsung.com
patch subject: [PATCH v2 10/15] lib/lz4: switch the compressor to the vendored sources
config: arc-allmodconfig (https://download.01.org/0day-ci/archive/20261107/202611070943.EDg3udaH-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261107/202611070943.EDg3udaH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611070943.EDg3udaH-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/rcupdate.h:27,
                    from include/linux/rbtree.h:24,
                    from include/linux/mm_types.h:11,
                    from include/linux/mmzone.h:22,
                    from include/linux/gfp.h:7,
                    from include/linux/umh.h:4,
                    from include/linux/kmod.h:9,
                    from include/linux/module.h:18,
                    from lib/lz4/lz4_compress.c:29:
   include/linux/sched.h: In function 'is_percpu_thread':
>> include/linux/sched.h:1860:17: error: 'current' undeclared (first use in this function)
    1860 |         return (current->flags & PF_NO_SETAFFINITY) &&
         |                 ^~~~~~~
   include/linux/sched.h:1860:17: note: each undeclared identifier is reported only once for each function it appears in
   include/linux/sched.h: In function 'current_restore_flags':
   include/linux/sched.h:1918:9: error: 'current' undeclared (first use in this function)
    1918 |         current->flags &= ~flags;
         |         ^~~~~~~
   include/linux/sched.h: In function 'set_need_resched_current':
   include/linux/sched.h:2127:30: error: 'current' undeclared (first use in this function)
    2127 |         set_tsk_need_resched(current);
         |                              ^~~~~~~
   In file included from include/asm-generic/bug.h:7,
                    from arch/arc/include/asm/bug.h:30,
                    from include/linux/bug.h:5,
                    from lib/lz4/lz4_compress.c:27:
   include/linux/sched.h: In function '__set_task_blocked_on':
   include/linux/sched.h:2231:27: error: 'current' undeclared (first use in this function)
    2231 |         WARN_ON_ONCE(p != current);
         |                           ^~~~~~~
   include/linux/once_lite.h:28:41: note: in definition of macro 'DO_ONCE_LITE_IF'
      28 |                 bool __ret_do_once = !!(condition);                     \
         |                                         ^~~~~~~~~
   include/linux/sched.h:2231:9: note: in expansion of macro 'WARN_ON_ONCE'
    2231 |         WARN_ON_ONCE(p != current);
         |         ^~~~~~~~~~~~
   In file included from include/linux/nodemask.h:92,
                    from include/linux/numa.h:6,
                    from include/linux/cpumask.h:15,
                    from include/linux/smp.h:13,
                    from include/linux/interrupt_rc.h:17,
                    from include/linux/spinlock.h:60,
                    from include/linux/mmzone.h:8:
   include/linux/sched.h: In function 'alloc_tag_save':
   include/linux/sched.h:2361:14: error: 'current' undeclared (first use in this function)
    2361 |         swap(current->alloc_tag, tag);
         |              ^~~~~~~
   include/linux/minmax.h:308:21: note: in definition of macro 'swap'
     308 |         do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
         |                     ^
>> include/linux/minmax.h:308:52: error: assignment to 'struct alloc_tag *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     308 |         do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
         |                                                    ^
   include/linux/sched.h:2361:9: note: in expansion of macro 'swap'
    2361 |         swap(current->alloc_tag, tag);
         |         ^~~~
   include/linux/sched.h: In function 'alloc_tag_restore':
   include/linux/sched.h:2368:14: error: 'current' undeclared (first use in this function)
    2368 |         WARN(current->alloc_tag != tag, "current->alloc_tag was changed:\n");
         |              ^~~~~~~
   include/asm-generic/bug.h:164:32: note: in definition of macro 'WARN'
     164 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   In file included from <command-line>:
   include/linux/rcupdate.h: In function 'cond_resched_tasks_rcu_qs':
>> include/linux/rcupdate.h:226:22: error: 'current' undeclared (first use in this function)
     226 |         rcu_tasks_qs(current, false);
         |                      ^~~~~~~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/rcupdate.h:185:35: note: in expansion of macro 'READ_ONCE'
     185 |                 if (!(preempt) && READ_ONCE((t)->rcu_tasks_holdout))    \
         |                                   ^~~~~~~~~
   include/linux/rcupdate.h:197:34: note: in expansion of macro 'rcu_tasks_classic_qs'
     197 | #define rcu_tasks_qs(t, preempt) rcu_tasks_classic_qs((t), (preempt))
         |                                  ^~~~~~~~~~~~~~~~~~~~
   include/linux/rcupdate.h:226:9: note: in expansion of macro 'rcu_tasks_qs'
     226 |         rcu_tasks_qs(current, false);
         |         ^~~~~~~~~~~~
   In file included from include/linux/local_lock.h:5,
                    from include/linux/mmzone.h:24:
   include/linux/local_lock_internal.h: In function 'local_lock_acquire':
>> include/linux/local_lock_internal.h:48:20: error: 'current' undeclared (first use in this function)
      48 |         l->owner = current;
         |                    ^~~~~~~
   include/linux/local_lock_internal.h: In function 'local_trylock_acquire':
   include/linux/local_lock_internal.h:55:20: error: 'current' undeclared (first use in this function)
      55 |         l->owner = current;
         |                    ^~~~~~~
   In file included from include/linux/build_bug.h:5,
                    from lib/lz4/lz4_deps.h:18,
                    from lib/lz4/lz4_compress.c:16:
   include/linux/local_lock_internal.h: In function 'local_lock_release':
   include/linux/local_lock_internal.h:60:41: error: 'current' undeclared (first use in this function)
      60 |         DEBUG_LOCKS_WARN_ON(l->owner != current);
         |                                         ^~~~~~~
   include/linux/compiler.h:77:45: note: in definition of macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   include/linux/local_lock_internal.h:60:9: note: in expansion of macro 'DEBUG_LOCKS_WARN_ON'
      60 |         DEBUG_LOCKS_WARN_ON(l->owner != current);
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/sched/mm.h: In function 'current_gfp_context':
>> include/linux/sched/mm.h:250:41: error: 'current' undeclared (first use in this function)
     250 |         unsigned int pflags = READ_ONCE(current->flags);
         |                                         ^~~~~~~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/sched/mm.h:250:31: note: in expansion of macro 'READ_ONCE'
     250 |         unsigned int pflags = READ_ONCE(current->flags);
         |                               ^~~~~~~~~
   include/linux/sched/mm.h: In function 'memalloc_retry_wait':
   include/linux/sched.h:170:17: error: 'current' undeclared (first use in this function)
     170 |                 current->task_state_change = _THIS_IP_;                 \
         |                 ^~~~~~~
   include/linux/sched.h:242:17: note: in expansion of macro 'debug_normal_state_change'
     242 |                 debug_normal_state_change((state_value));               \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/sched/mm.h:293:9: note: in expansion of macro '__set_current_state'
     293 |         __set_current_state(TASK_UNINTERRUPTIBLE);
         |         ^~~~~~~~~~~~~~~~~~~
   In file included from include/linux/xarray.h:21,
                    from include/linux/radix-tree.h:21,
                    from include/linux/idr.h:15,
                    from include/linux/kernfs.h:12,
                    from include/linux/sysfs.h:16,
                    from include/linux/kobject.h:20,
                    from include/linux/module.h:22:
   include/linux/sched/mm.h: In function 'might_alloc':
   include/linux/sched/mm.h:319:13: error: 'current' undeclared (first use in this function)
     319 |         if (current->flags & PF_MEMALLOC)
         |             ^~~~~~~
   include/linux/sched/mm.h: In function 'memalloc_flags_save':
   include/linux/sched/mm.h:334:30: error: 'current' undeclared (first use in this function)
     334 |         unsigned oldflags = ~current->flags & flags;
         |                              ^~~~~~~
   include/linux/sched/mm.h: In function 'memalloc_flags_restore':
   include/linux/sched/mm.h:341:9: error: 'current' undeclared (first use in this function)
     341 |         current->flags &= ~flags;
         |         ^~~~~~~
   include/linux/sched/mm.h: In function 'set_active_memcg':
   include/linux/sched/mm.h:499:23: error: 'current' undeclared (first use in this function)
     499 |                 old = current->active_memcg;
         |                       ^~~~~~~
   include/linux/sched/mm.h: In function 'membarrier_mm_sync_core_before_usermode':
   include/linux/sched/mm.h:543:13: error: 'current' undeclared (first use in this function)
     543 |         if (current->mm != mm)
         |             ^~~~~~~


vim +308 include/linux/minmax.h

f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  285) 
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  286) /**
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  287)  * in_range - Determine if a value lies within a range.
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  288)  * @val: Value to test.
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  289)  * @start: First value in range.
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  290)  * @len: Number of values in range.
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  291)  *
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  292)  * This is more efficient than "if (start <= val && val < (start + len))".
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  293)  * It also gives a different answer if @start + @len overflows the size of
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  294)  * the type by a sufficient amount to encompass @val.  Decide for yourself
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  295)  * which behaviour you want, or prove that start + len never overflow.
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  296)  * Do not blindly replace one form with the other.
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  297)  */
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  298) #define in_range(val, start, len)					\
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  299) 	((sizeof(start) | sizeof(len) | sizeof(val)) <= sizeof(u32) ?	\
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  300) 		in_range32(val, start, len) : in_range64(val, start, len))
f9bff0e31881d03 Matthew Wilcox (Oracle  2023-08-02  301) 
b296a6d53339a79 Andy Shevchenko         2020-10-15  302  /**
b296a6d53339a79 Andy Shevchenko         2020-10-15  303   * swap - swap values of @a and @b
b296a6d53339a79 Andy Shevchenko         2020-10-15  304   * @a: first value
b296a6d53339a79 Andy Shevchenko         2020-10-15  305   * @b: second value
b296a6d53339a79 Andy Shevchenko         2020-10-15  306   */
b296a6d53339a79 Andy Shevchenko         2020-10-15  307  #define swap(a, b) \
b296a6d53339a79 Andy Shevchenko         2020-10-15 @308  	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
b296a6d53339a79 Andy Shevchenko         2020-10-15  309  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

