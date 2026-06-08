Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA75DCD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 03:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1886B0088; Sun,  7 Jun 2026 23:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B7A6B008A; Sun,  7 Jun 2026 23:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB16C6B008C; Sun,  7 Jun 2026 23:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5876B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 23:19:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB45B1649F4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:19:03 +0000 (UTC)
X-FDA: 84855288966.18.C5E6B8C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id C0CE2160007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:19:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BS5nQx00;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780888741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++MjK/A42HbDKHPOJGo5UVU7C6oGVWhJkis01RJZOto=;
	b=UWJIWpTAS9Lh+fCfOZPX7r5av154EreLQ2grj1P2D21X8tFCdYxh8+Ubk/jcKJgYE0BDKb
	J4pJPEolsYTTi7t58PoYjnc+3NQ8/5e1RbdAg3GxmQyNlR+7U8+emJufpfdzsY+1FVjrCY
	pegBsF+c1bzFxPMCZiWB9TZbhP35xkA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BS5nQx00;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780888741;
	b=uASgCW2jckRO0688xTU6+/4xsySM2jNrchLuDUQG2Q+vA6zbu5LdZpXBrqBCSz6sUIE4iV
	vPHaK7Q1MQBWZRB7nT7bh0SNp2kMQyiFG3U9XHBaF/Amfq/NW/CHExx6OaAca6ZE+2Q7xV
	1D9QPTnrruOjgsLKxjxQ+2sjkfx5Cds=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780888740; x=1812424740;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RUUJTtyCni/ePuv33E/2tFZWOXkpAKWHxZNEE7bWTAU=;
  b=BS5nQx00yIITkcH0NiS3DlKcCMvtYyvsui9mnlthUJCNizBJTKKa9Wng
   lOI4PNJWd/elT9W3SnKsWT3AljjbarHgcIlxFomKKxFrro0P9IEqFnn5F
   +p39QBgZHtsGOHIYMISf2ImeXsGf+r3xYLjEV6hBPpjGn0fwfVUizt2xd
   vQamtUjdSXOrFRfTSdzYWi5RjGQnobEhcC/cvl55WGq+HwXuB8aRC1/T0
   fRT1rSPmGENiJQWI/Gv8lyQN/I6MSgsoaD7bNlUYK0x+y34oEFczrmU0G
   +cc0jGhku385qohAuo826ef6iL9AAbjQHh8epDC/3dmebX9rNEOkfjoOF
   g==;
X-CSE-ConnectionGUID: /6qkANHDTbuWbe1jUpyOMA==
X-CSE-MsgGUID: JkYU1wqGRV6GcZomvjpS1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11810"; a="93105357"
X-IronPort-AV: E=Sophos;i="6.24,193,1774335600"; 
   d="scan'208";a="93105357"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2026 20:18:58 -0700
X-CSE-ConnectionGUID: NJdzsv5HSw2ham0VD0FZzA==
X-CSE-MsgGUID: eM+0rSJER/ezEhuRhUZw7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,193,1774335600"; 
   d="scan'208";a="240971516"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 07 Jun 2026 20:18:56 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wWQVq-000000003B3-2yEM;
	Mon, 08 Jun 2026 03:18:54 +0000
Date: Mon, 8 Jun 2026 05:18:03 +0200
From: kernel test robot <lkp@intel.com>
To: yahia <yahia.a.abdrabou@gmail.com>, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, david@kernel.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	yahia <yahia.a.abdrabou@gmail.com>
Subject: Re: [PATCH] mm/migrate: Add native folio functions
Message-ID: <202606080542.ER5s80Rl-lkp@intel.com>
References: <20260608001251.66847-1-yahia.a.abdrabou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608001251.66847-1-yahia.a.abdrabou@gmail.com>
X-Rspamd-Queue-Id: C0CE2160007
X-Rspam-User: 
X-Stat-Signature: igcnhguwunpqiejfc45njetsytz5e4zb
X-Rspamd-Server: rspam09
X-HE-Tag: 1780888740-621526
X-HE-Meta: U2FsdGVkX1/a7sHVctclXQD7gTFBSz1Ukb2mG9ne/g1Rbo50waTs+qhc2On/lJHxUBLgvbWIqyg/SJDMjLr91BftWQRw8NydF9k2uDe+BzQa2XT7l/q/hUMAsZbT5VvXg1VfePnqdy4tNw7p8T/l41WfLplTh5zvFtR6PZ5h0sWPyWvOFs+hpF4/Tr4749zCLkRfQEfX/G0alZ69Z8zVCA/mvsyENY8+2wX+/mP1jNdLzVqH9IiNOqTAilGM12k4zkYMF9MBsDEiE33m+9ZgaY6xcCJ2j1w/C40Fk0Thoi51SfIGxJaBHGSPd7rswk2SQ9jEkLo0Bms9KS7vFSyxlQ7aSLgwk6ouKI/OjabDbRQiDiltXdi5Vng21UJXBr59ROedpCjlY9DE23SNomyx+u/Z/StHT7iNYQwvACieqgct4+s4zphlPTzkYgxuIoelBNqdH9iH82dZFyc5SMrsfCpG54wsageUGMs/K1EdZwem1bFdcj1Lji4eF3/nriFx0nzFiw4HNohl4/5d/vkKZTz2RnfhTGPxrSbfz5sXEQMTL6e0gKhell+LBO9hq2ZOCPKX3HNx4n26Qv4rl+XvwXoNRT6I3vhL5hvJ4t5tGJxSGKI2SmewMat4Lwhkv0b4+1S8WkUcah8rDksQH2cc+Oc4KCc2H0EOQhMHRH1j9zWTJvUum6Ud7aIO2EA98JiMJTujcI0JgyL1J8D1FHjTGGvDEsblCFqbGAb5GVsvElo2coFpbAaEvc7PHqBmObwBqzfhQm7d02TQrA6LsqSYjAvCDu9mcuZXw9ENMyV959KQP9Lg6S+UN3/eNqoGUJ2XG9kgPdd6VZu0INBoOiN2ZuWjMldc4dYcHv77LnmIKzDdDjykZxMLcNtV9u0oeFfrxjoaQg2bOtnReBLfY80/g5+3cCuHzZdCYu2xjht5QJxH/j2kdbSChxsyEB6TTHrOso/pomifWXn497hu5Tg
 EzRExtXH
 pqUxjscdQHGhgMJLjmBUfpcBg6k/ONXkDMAuPed0xczOKVSbU35nrNL3P01oUWGl9wy9VKieTW/zK0wlmyolVMIrXsoHnmaRYQuCi75JeUg7cXhJ/FZ04gxV40Hs2Q+7wGiEAhVThFzm+sVsbMBzfMEa9CfvtLhWxfkbW98Xp6nhFF702p7p09/endj4EXsw06bydDLbv/C1LNCoaskXd7T8E+rh9RD57g+BYozId8PMKN8ziY9XVy2QcRMbwe6YXYIfG89xYSxO/lrNQDZhLYPySxE4Liu2D7VB32jkoY3u+ydVDca9LEUWTWnR1RlMrdjO9w+LfuThEC5ppWHgegkNs7qfxooJGCXvlaVEfKGHu5Q2UPCVuUieuouoiuTa5/anU8KHEv/7eyHzk/RlcXiPP5XMITGePYQhhhgQlAaCzlF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi yahia,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/yahia/mm-migrate-Add-native-folio-functions/20260608-081741
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260608001251.66847-1-yahia.a.abdrabou%40gmail.com
patch subject: [PATCH] mm/migrate: Add native folio functions
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260608/202606080542.ER5s80Rl-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project f43d6834093b19baf79beda8c0337ab020ac5f17)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260608/202606080542.ER5s80Rl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606080542.ER5s80Rl-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:9:
   In file included from include/linux/crypto.h:18:
   In file included from include/linux/slab.h:17:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:23:
>> include/linux/page-flags.h:1113:1: error: use of undeclared identifier 'PG_MovableOpsIsolated'; did you mean 'PG_movable_ops_isolated'?
    1113 | FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/page-flags.h:412:19: note: expanded from macro 'FOLIO_TEST_FLAG'
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |                   ^~~~~~~~~
   <scratch space>:185:1: note: expanded from here
     185 | PG_MovableOpsIsolated
         | ^~~~~~~~~~~~~~~~~~~~~
   include/linux/page-flags.h:172:2: note: 'PG_movable_ops_isolated' declared here
     172 |         PG_movable_ops_isolated = PG_reclaim,
         |         ^
>> include/linux/page-flags.h:1113:37: error: use of undeclared identifier 'movable_ops_isolated'; did you mean 'PG_movable_ops_isolated'?
    1113 | FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
         |                                     ^~~~~~~~~~~~~~~~~~~~
         |                                     PG_movable_ops_isolated
   include/linux/page-flags.h:412:55: note: expanded from macro 'FOLIO_TEST_FLAG'
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |                                                       ^~~~
   include/linux/bitops.h:60:50: note: expanded from macro 'test_bit'
      60 | #define test_bit(nr, addr)              bitop(_test_bit, nr, addr)
         |                                                              ^~~~
   include/linux/bitops.h:44:37: note: expanded from macro 'bitop'
      44 |           __builtin_constant_p((uintptr_t)(addr) != (uintptr_t)NULL) && \
         |                                            ^~~~
   include/linux/page-flags.h:172:2: note: 'PG_movable_ops_isolated' declared here
     172 |         PG_movable_ops_isolated = PG_reclaim,
         |         ^
>> include/linux/page-flags.h:1113:37: error: use of undeclared identifier 'movable_ops_isolated'; did you mean 'PG_movable_ops_isolated'?
    1113 | FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
         |                                     ^~~~~~~~~~~~~~~~~~~~
         |                                     PG_movable_ops_isolated
   include/linux/page-flags.h:412:55: note: expanded from macro 'FOLIO_TEST_FLAG'
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |                                                       ^~~~
   include/linux/bitops.h:60:50: note: expanded from macro 'test_bit'
      60 | #define test_bit(nr, addr)              bitop(_test_bit, nr, addr)
         |                                                              ^~~~
   include/linux/bitops.h:45:16: note: expanded from macro 'bitop'
      45 |           (uintptr_t)(addr) != (uintptr_t)NULL &&                       \
         |                       ^~~~
   include/linux/page-flags.h:172:2: note: 'PG_movable_ops_isolated' declared here
     172 |         PG_movable_ops_isolated = PG_reclaim,
         |         ^
>> include/linux/page-flags.h:1113:37: error: use of undeclared identifier 'movable_ops_isolated'; did you mean 'PG_movable_ops_isolated'?
    1113 | FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
         |                                     ^~~~~~~~~~~~~~~~~~~~
         |                                     PG_movable_ops_isolated
   include/linux/page-flags.h:412:55: note: expanded from macro 'FOLIO_TEST_FLAG'
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |                                                       ^~~~
   include/linux/bitops.h:60:50: note: expanded from macro 'test_bit'
      60 | #define test_bit(nr, addr)              bitop(_test_bit, nr, addr)
         |                                                              ^~~~
   include/linux/bitops.h:46:50: note: expanded from macro 'bitop'
      46 |           __builtin_constant_p(*(const unsigned long *)(addr))) ?       \
         |                                                         ^~~~
   include/linux/page-flags.h:172:2: note: 'PG_movable_ops_isolated' declared here
     172 |         PG_movable_ops_isolated = PG_reclaim,
         |         ^
>> include/linux/page-flags.h:1113:1: error: use of undeclared identifier 'PG_MovableOpsIsolated'; did you mean 'PG_movable_ops_isolated'?
    1113 | FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/page-flags.h:412:19: note: expanded from macro 'FOLIO_TEST_FLAG'
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |                   ^~~~~~~~~
   <scratch space>:185:1: note: expanded from here
     185 | PG_MovableOpsIsolated
         | ^~~~~~~~~~~~~~~~~~~~~
   include/linux/page-flags.h:172:2: note: 'PG_movable_ops_isolated' declared here
     172 |         PG_movable_ops_isolated = PG_reclaim,
         |         ^
>> include/linux/page-flags.h:1113:37: error: use of undeclared identifier 'movable_ops_isolated'; did you mean 'PG_movable_ops_isolated'?
    1113 | FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
         |                                     ^~~~~~~~~~~~~~~~~~~~
         |                                     PG_movable_ops_isolated
   include/linux/page-flags.h:412:55: note: expanded from macro 'FOLIO_TEST_FLAG'
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |                                                       ^~~~
   include/linux/bitops.h:60:50: note: expanded from macro 'test_bit'
      60 | #define test_bit(nr, addr)              bitop(_test_bit, nr, addr)
         |                                                              ^~~~
   include/linux/bitops.h:47:17: note: expanded from macro 'bitop'
      47 |          const##op(nr, addr) : op(nr, addr))
         |                        ^~~~
   include/linux/page-flags.h:172:2: note: 'PG_movable_ops_isolated' declared here
     172 |         PG_movable_ops_isolated = PG_reclaim,
         |         ^
>> include/linux/page-flags.h:1113:1: error: use of undeclared identifier 'PG_MovableOpsIsolated'; did you mean 'PG_movable_ops_isolated'?
    1113 | FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/page-flags.h:412:19: note: expanded from macro 'FOLIO_TEST_FLAG'
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |                   ^~~~~~~~~
   <scratch space>:185:1: note: expanded from here
     185 | PG_MovableOpsIsolated
         | ^~~~~~~~~~~~~~~~~~~~~
   include/linux/page-flags.h:172:2: note: 'PG_movable_ops_isolated' declared here
     172 |         PG_movable_ops_isolated = PG_reclaim,
         |         ^
>> include/linux/page-flags.h:1113:37: error: use of undeclared identifier 'movable_ops_isolated'; did you mean 'PG_movable_ops_isolated'?
    1113 | FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
         |                                     ^~~~~~~~~~~~~~~~~~~~
         |                                     PG_movable_ops_isolated
   include/linux/page-flags.h:412:55: note: expanded from macro 'FOLIO_TEST_FLAG'
     412 | { return test_bit(PG_##name, const_folio_flags(folio, page)); }
         |                                                       ^~~~
   include/linux/bitops.h:60:50: note: expanded from macro 'test_bit'
      60 | #define test_bit(nr, addr)              bitop(_test_bit, nr, addr)
         |                                                              ^~~~
   include/linux/bitops.h:47:32: note: expanded from macro 'bitop'
      47 |          const##op(nr, addr) : op(nr, addr))
         |                                       ^~~~
   include/linux/page-flags.h:172:2: note: 'PG_movable_ops_isolated' declared here
     172 |         PG_movable_ops_isolated = PG_reclaim,
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:99:4: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      99 |                         set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:101:11: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
     101 |                 return (set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:17:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:13:
   In file included from include/linux/percpu-rwsem.h:7:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^


vim +1113 include/linux/page-flags.h

  1093	
  1094	#ifdef CONFIG_MIGRATION
  1095	/*
  1096	 * This page is migratable through movable_ops (for selected typed pages
  1097	 * only).
  1098	 *
  1099	 * Page migration of such pages might fail, for example, if the page is
  1100	 * already isolated by somebody else, or if the page is about to get freed.
  1101	 *
  1102	 * While a subsystem might set selected typed pages that support page migration
  1103	 * as being movable through movable_ops, it must never clear this flag.
  1104	 *
  1105	 * This flag is only cleared when the page is freed back to the buddy.
  1106	 *
  1107	 * Only selected page types support this flag (see page_movable_ops()) and
  1108	 * the flag might be used in other context for other pages. Always use
  1109	 * page_has_movable_ops() instead.
  1110	 */
  1111	TESTPAGEFLAG(MovableOps, movable_ops, PF_NO_TAIL);
  1112	SETPAGEFLAG(MovableOps, movable_ops, PF_NO_TAIL);
> 1113	FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
  1114	/*
  1115	 * A movable_ops page has this flag set while it is isolated for migration.
  1116	 * This flag primarily protects against concurrent migration attempts.
  1117	 *
  1118	 * Once migration ended (success or failure), the flag is cleared. The
  1119	 * flag is managed by the migration core.
  1120	 */
  1121	PAGEFLAG(MovableOpsIsolated, movable_ops_isolated, PF_NO_TAIL);
  1122	#else /* !CONFIG_MIGRATION */
  1123	TESTPAGEFLAG_FALSE(MovableOps, movable_ops);
  1124	SETPAGEFLAG_NOOP(MovableOps, movable_ops);
  1125	PAGEFLAG_FALSE(MovableOpsIsolated, movable_ops_isolated);
  1126	#endif /* CONFIG_MIGRATION */
  1127	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

