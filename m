Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A96DCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 487E76B0088; Tue,  2 Jun 2026 22:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438C46B008A; Tue,  2 Jun 2026 22:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F1D6B008C; Tue,  2 Jun 2026 22:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 271AC6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:29:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC1731C0DE2
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:29:58 +0000 (UTC)
X-FDA: 84837021276.06.8B6F991
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf20.hostedemail.com (Postfix) with ESMTP id C05FD1C000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:29:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=au5eL3J7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780453797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=h6ht079cAiqKQgydVIxEZzggn9DJAqZXof34oIAleAU=;
	b=665EJc+fghPWznklYFY4xWXDwtzKFokYxsi8+fYksB9MZiHi/6v43XgxWhD5DQF9SZuuoj
	xpHHAmQgKmxchVEXwg8WnPUhUA0ByvD/TUPQwBA9AZyrIgaxycva6fq71L9XgH14F6iwLl
	Lfj5pUwmVatxpMS+AvcGtdQSAO77e3U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=au5eL3J7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780453797;
	b=YhxgIKczKZznYq5AoYLH+WrIQKfW66zSQCYC7XErEV5va+zDsZAtgaXCMitZxNGbtJyCfo
	SID+0r2uEBAVFRTrj1k3to9rlXW5VIYVb0HmztFhDSn8yViPGti34OvqkAOp0h4nB1KtC3
	44YNXY0LRtaLdy7XOgG89M/x3iDVgeU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780453795; x=1811989795;
  h=date:from:to:cc:subject:message-id;
  bh=0hpiZUig1nwVDn3JUe8JPcPCOSz4i0rXxP9ntSiqqzQ=;
  b=au5eL3J7JIdHLsxKzFzZEgUhhaEBIzJryevEH4lvNSGsvUlpf3OU4AbS
   A/J0gCx3X4z3qpLHEyC7WrRloZ1RUewz4eI6b7I26+/UPcPiOlzFwnOaT
   dFwnF3P8tKZxTRKD5djupXEtC8Mb+2OYfbZMYgAK4Eb3omLgP5Qz7f0QX
   X7cl+N5rsezjhCgMCfobWwXheYU9A1VUfC2w79D30PeWWReBsDCvMSlVj
   u9P0mJ1Z5qCxr37AbfnVIaPpkzlKVDx++9DiXpZAXu+dt0TcnVj9bFJwg
   GCg9qmGH78It7HQEPa1mDFG6qoOzBH7xt4Nt944zJACDJfMy1XwZKdm4a
   Q==;
X-CSE-ConnectionGUID: n0VJuzIsR6GhakaLml7kFQ==
X-CSE-MsgGUID: pzE78h1iTNSuuAo8FI1FEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="80281799"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="80281799"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 19:29:54 -0700
X-CSE-ConnectionGUID: LW+6TSgwSSC01zF7ZPdyWQ==
X-CSE-MsgGUID: LmfBN84/T2qtUe0hh1hVXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="241597280"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 02 Jun 2026 19:29:52 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wUbMb-00000000Cpm-3I7o;
	Wed, 03 Jun 2026 02:29:49 +0000
Date: Wed, 03 Jun 2026 10:29:32 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org,
 "Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [akpm-mm:mm-unstable 274/423] mm/userfaultfd.c:4475:1:
 warning: alias and aliasee have different types 'long (ulong, ulong, ulong,
 ulong, ulong, ulong, ulong)' (aka 'long (unsigned long, unsigned long,
 unsigned long, unsigned long, unsigned long, unsigned long, unsigned long)')
 and 'l...
Message-ID: <202606031038.1aPfmoCm-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C05FD1C000D
X-Stat-Signature: kwyta1hygthyx6xgchw781e3ufwuos7g
X-Rspam-User: 
X-HE-Tag: 1780453795-785733
X-HE-Meta: U2FsdGVkX18ElqLS8Lv7D2yDk3rOUh7KKJESe2MuMXEJ6X27hXzktmeMPA6Grjnzf/0yxc/dTn1+M0JY0gnAIsHdH0RdGNYhUadFFjy8kl9Z512Cxm8rw/x/UJXrOXAW3nUsKUzPCLeSEvSG/9vCWmUDTXIVN62KqGVq03EwLGd8Kr6x6/tlcH11s/EFU7yqoOOX4Sr89FeB/6ntKBz7rPrFnZaEIONlCoguBquw4qz3OxvNL6Nw3Mp/62RZ5GW1krRqHMFp/ebnjl0/sHpuBtNNsxnqdjvu26B5OI2UWLiE0aTc7l9acqP7E/drkaezYHyykyHEnvk25W7sOusiJBpD0AGCiYfXm3stV0/xAXk5UGGpsvIacEnHP2Hwx71lA04Ciw5ZS8RlPVPPgJudnCBCyiiPPlVTZJigCaCA0buCeu7a2ZaF1CNiujstDZayea/c1XhrlKSDSyAP7Hhzzqc8jJEINCwtQpSkd1kqTfb2qAazcHqH2zqpaC5ExK5jwH6OgDTCkU3gQyuAO45TMYVxElXTZn5rbJEovItya9t0Ehv7917ZfaPok6bkr89fNkEBpjDJI3WcdAC6NtJFILfR60b8Oz/5HG1zJbvux8Cp7wXfX8LWsc9HfFOQz0kUhsZqJHgXbL7R+dyZrlilPwY+CqUmrauyjPC6Cdf5FqLNiHnS8FiNWY3xl70D1PDbXDnJAEGrGILxGQRSLDEhlOzKPG8SL/W9eAhcr1jl1W8iTvV4ANP0Em2ZxyFlUnpd4JuJWL1fNYyQLDK9chMCEvjj0Cul2el8FpKx4KRQS+0WWst8uBwLx/qndb+63WoNFfxbeoQYf4QU+0gkooYKSdPqrg363s3l2yk9X1d6x21brUTiVVpy0llu/ZsbBj9q4LpMPnUZmuqDNkQrUGRIhcC9922WCDpveA9FnCyGE+ezP04SHMnwrJTZqCqEoCU1kE+9VFyhztqv6IE2weD
 nCQ0EdMW
 jS//lZASKw4KcuvF9+asYw360TYcxUWVc4dDNu37E1PqWMZRx0CVtPui2ybKWHTfNniaRG4B5pgWDF3QtY2rw7cIXgCdmtnHafC9r2lnssfCYVE8C3XUFe7GLcUu1FM07XKZSEdWIvPCyQM3THQ2WgaDImlA6vHCzWW37ZV3IZme9JcTzIBhnt0FwycEqFl9ZxQAbHs4IzLTHGZ/IuJGEOaTwQQus1i/R9emH7qm6YkgzqdyfkHSnTBP4WdlsGFPgMXkUKQjM3kQBnENYUpa9CUISe+CfwkYzJJ88mFS2CrbS3Cs02k9lRj/BQqOf7sicFYu0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   6bb9014e347a15dfa837cbc52451035466d86ddf
commit: 53313230f720eaaf9f1f6d20faafd7e01a9e09b7 [274/423] userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
config: riscv-randconfig-r122-20260529 (https://download.01.org/0day-ci/archive/20260603/202606031038.1aPfmoCm-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260603/202606031038.1aPfmoCm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606031038.1aPfmoCm-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/userfaultfd.c:4475:1: warning: alias and aliasee have different types 'long (ulong, ulong, ulong, ulong, ulong, ulong, ulong)' (aka 'long (unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long)') and 'long (typeof (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0), typeof (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof (0ULL))), 0LL, 0L)))' (aka 'long (long)') [-Wattribute-alias]
    4475 | SYSCALL_DEFINE1(userfaultfd, int, flags)
         | ^
   include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^
   include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^
   arch/riscv/include/asm/syscall_wrapper.h:82:2: note: expanded from macro '__SYSCALL_DEFINEx'
      82 |         __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)                         \
         |         ^
   arch/riscv/include/asm/syscall_wrapper.h:37:19: note: expanded from macro '__SYSCALL_SE_DEFINEx'
      37 |                         __attribute__((alias(__stringify(___se_##prefix##name))));      \
         |                                        ^
   mm/userfaultfd.c:4475:1: note: aliasee is declared here
   include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^
   include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^
   arch/riscv/include/asm/syscall_wrapper.h:82:2: note: expanded from macro '__SYSCALL_DEFINEx'
      82 |         __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)                         \
         |         ^
   arch/riscv/include/asm/syscall_wrapper.h:41:14: note: expanded from macro '__SYSCALL_SE_DEFINEx'
      41 |         static long ___se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))
         |                     ^
   <scratch space>:148:1: note: expanded from here
     148 | ___se_sys_userfaultfd
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

