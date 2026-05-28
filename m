Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3ED8CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 15:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0BE26B0005; Thu, 28 May 2026 11:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BCC36B0088; Thu, 28 May 2026 11:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2686B008A; Thu, 28 May 2026 11:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE256B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:28:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DE831C20FE
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:28:42 +0000 (UTC)
X-FDA: 84817210884.12.A5D9BF9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf06.hostedemail.com (Postfix) with ESMTP id D6DD718000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:28:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=egu3aqoO;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779982120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=rEw+oL4OikCxxpDwITHG5QBUjQO1B+ycQwdJay689VI=;
	b=sXJkiqsudPZsxT4rjVgqKQBSh7I0ecmTBsOyrOLnVrrbBsQd3QsrUesSpLa19emEaPzFrC
	xinZX0V+zTSNO3J9IO7R6fTA7U2O2ZeXPvuxCElYXzWr00oXaDbhn5YYIMRtcDAWmydGEa
	B5y+UYH6RcLHJZyQgQQKhu2mQdzHeiA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=egu3aqoO;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779982120; a=rsa-sha256;
	cv=none;
	b=PiufTYHt+Ee6Mdwymznl8JNZFrLnNsDFTuff86jevu2GCkmNmDJMKcNpYpRr1xpJRIsU09
	ky12QOgxEtiJX6+NXhnqWjnLkoh2KRl96MKmIkJy71LRXuT8PwKaZpEtkA2zo2pZHFM2mu
	e13119XyFB/H7FoyPbUyl2Ja+DqQBCI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779982119; x=1811518119;
  h=date:from:to:cc:subject:message-id;
  bh=h6gIQSh7EnSLP0hziwCdjn4VeCMknpf+zkhPz4Yk5XQ=;
  b=egu3aqoOwUDUTN2FRk48vpNory6XIO0Jy2zRzJCcFxqilsPzDCNL+iuf
   Iq46PUaMWULjZ53wmjQnScdQF4oCk0dJNfmjeTkF/k3QKUoGomIfJvdAa
   aLT+XaTCP9GNzBBYQ5lWxy51rr0p5GJaszQD5IjW45WQgyBeKXYEc6ea2
   vqNYVbSfVW8gMU1PbXsa2MXG8KOUHusLfpx/qDhgKkMv5uIN0nPUW+vLJ
   dOlBcvEmwgzIPr+bmqXHSx7vuF+fz5bB9sEP21lLvHRnolXBqOogJt1C2
   Kr57n53yYgll51V4zim0IVrGfoaUA5GmjCRy/v5ZnbExQ4yBVQxTNC089
   A==;
X-CSE-ConnectionGUID: o+izjlfpSu+HycSWOetNlw==
X-CSE-MsgGUID: 9q2D2oZMRw2fk8uP/mogxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="79975584"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="79975584"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 08:28:37 -0700
X-CSE-ConnectionGUID: DMwmCKApSv+F9qWfLRbzpA==
X-CSE-MsgGUID: e7+FBSsnRKK8gBnb32NJVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="238399635"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 28 May 2026 08:28:35 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSceu-0000000064g-0QZ5;
	Thu, 28 May 2026 15:28:32 +0000
Date: Thu, 28 May 2026 23:28:25 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 273/420] mm/userfaultfd.c:4475:1:
 warning: alias and aliasee have different types 'long (int)' and 'long
 (typeof (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0),
 typeof (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof
 (0ULL))), 0...
Message-ID: <202605282311.BlbuvsRF-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: wte8dw1y7i7rbigquj87q5atmmyarcom
X-Rspamd-Queue-Id: D6DD718000B
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779982118-108993
X-HE-Meta: U2FsdGVkX18QvLU1DuC+qbLTuRVoGIuBO+1EoWc6IufKsoA//9oxrjv2ecxVTo5VGHFHGIsRjNtLlrGl1VlEyEXcrQdmKAJ01Z27Ly8KLolPSFBVghmKtqkM5fT8nPuW+gxC7E+hL+J9JaFyk8Ud1QsIfuMPLiA4eVYuIfJJ07arigYIK7C3zaJlcScXTBUXqp6JrzhcjZvBlK5F1ULwjp2j7yg/twuXTQs4rsUTKPLEe9gZe/dftFhkCgqYh/V84CV7RPDmu1NXnWsvPcubAPTzTM7AdHFoSNaIpS9GAKOFt7Im6zUfv914WjeAltXYtbzS6Rf6DINj2iVXQ9FKjqLHUEWc6ek9yQp7IxOP2RtFSs+v2Uu+tC4TEWTrKn3RyPPCJq14CKDrNuczCqdSbEc1duXnLTJMKwmmCKvDNaxonfb6fuvruNwzLOZowj2qvVslNDcL9wHQVpgZorRlNXUOVXtzYl6biqPrQ6FlqYdcxEkGNv43Av4GEuZkXbX69QFt7mOHhIhgPt4DxmaNcuWN/EUCJyWFehBvxOrdHGq4Ed0t+QNRM9ZnAwyscA8Uj2GyUe6LCSjs6pCtI1C8gs0hg4etNh5eS7/BkRFvc89p+37G0rk1BAXMUMJ6kZoR8F5/jmJBuViyxWue7QOhpl0LYw4jlcrNBr4umJth7kG/ONO9Rw6OCN7RInHh3NsXvF3zbyeiAm5a0x2EryosK3KHK6MeTYLCxBax7NJJgW6zuiHOMWU9AD0GgcMF0WaZTrAMv4OvOTAUHbBhyBdIR5VIdiQoP626EjvfPhSAPjn96MWT91WggV30Knyafaf+MHm9oqM4O2ErZxHRAaeHHg0jJy9c4avDmZQ2TLTicbCPdhPeYubBve6WXFzPKCoreUYrK1Vj7PJa1vt4vqrl9PHNR0awF+wWXLsca18jfEnzuzCZiX0PPeeYA2CBZ2tYCcTsP9qPVofl0/hP8/M
 5Ii4kbtt
 EIAujZFhfsVTHXcinVJsyvXtijbol8pav+TnyIt7ImeFczW8oojzmEORxQ9huoXWv3QHoJTCFdF1ocOZOCz5ZtdJiwwWQNYW6UwT3B8Lqj+KtJ979FCot/mBkepuhfZA5YFMEFZADfkdXrwIUTlHayw/t8Aoz3kXx8pxBV3EbmWGrMJFD9mbu/QirIiXGi5cXi1GyXyztQuPMLfn1gaVc5mfuzS81sF/VLLVsYVqUYPmhMvrc9lNRGaN2V9/EHkxXxIQkR76OQUF9x6F+wuxtbVQUv2OQHcNh+KvKnN2SP25ofK9ADg+houhp6h6R/91eedlemmqden+2dEEJPon1Pk/+9bb/3Uo1rbMHFmyZpy/06QQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   8a74e22643189e0ae339afc91110ddb4cab1941b
commit: 688eee218159283140c8c4b48429cfe400cb64e4 [273/420] userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
config: arm-randconfig-003-20260528 (https://download.01.org/0day-ci/archive/20260528/202605282311.BlbuvsRF-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605282311.BlbuvsRF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605282311.BlbuvsRF-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/userfaultfd.c:4475:1: warning: alias and aliasee have different types 'long (int)' and 'long (typeof (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0), typeof (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof (0ULL))), 0LL, 0L)))' (aka 'long (long)') [-Wattribute-alias]
    4475 | SYSCALL_DEFINE1(userfaultfd, int, flags)
         | ^
   include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^
   include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^
   include/linux/syscalls.h:251:18: note: expanded from macro '__SYSCALL_DEFINEx'
     251 |                 __attribute__((alias(__stringify(__se_sys##name))));    \
         |                                ^
   mm/userfaultfd.c:4475:1: note: aliasee is declared here
   include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^
   include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^
   include/linux/syscalls.h:255:18: note: expanded from macro '__SYSCALL_DEFINEx'
     255 |         asmlinkage long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))  \
         |                         ^
   <scratch space>:46:1: note: expanded from here
      46 | __se_sys_userfaultfd
         | ^
   1 warning generated.


vim +4475 mm/userfaultfd.c

  4474	
> 4475	SYSCALL_DEFINE1(userfaultfd, int, flags)
  4476	{
  4477		if (!userfaultfd_syscall_allowed(flags))
  4478			return -EPERM;
  4479	
  4480		return new_userfaultfd(flags);
  4481	}
  4482	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

