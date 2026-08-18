Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 815FFC5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE206B077E; Tue, 18 Aug 2026 04:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87DD96B08D4; Tue, 18 Aug 2026 04:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796976B08D7; Tue, 18 Aug 2026 04:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 461D66B077E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:27:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D288F1A0B9D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:27:20 +0000 (UTC)
X-FDA: 85113710640.12.452DE15
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf07.hostedemail.com (Postfix) with ESMTP id 891F540007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:27:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ArWmXA8i;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787041639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=/leoaV/gUderK7z/l7n8UgRGRF2ZDpTy5JseOtFZpjE=;
	b=uexjNbbrzZSrgo/IbZo5GbTpehMVZqk5HtGbPZn3RJ+QU+JVcftH9QMuIOQCf+O3adFoDa
	sueIyVwHfxpeTfHW5rd1jHcPO9a2jN9i7QpimPsPh0GdWCHUkpflofFAZCQOeEOGkwyyKR
	h9B4fwo+FWtg/sFrLqc2tmnk/HSXfDA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787041639;
	b=huDS9E6RF/GKWF5AU2wdxcIDllEiYAz8Pqt3Twav08aBgr1xUSQv/ieFWYIabPIKsIaVoV
	a6Gdtv1hbr0IiurTZSCyepnbJ4KNGwzRuYJejuDWA9S9p8tkkleep4FxOy7vABz+UeVCYp
	B/5BU4Fo4QysCm31q6en5l+4dnsUmpY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ArWmXA8i;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787041639; x=1818577639;
  h=date:from:to:cc:subject:message-id;
  bh=A7bHR/MU2a/w9t33VhwbAkGq7WGqDUPnqK8mB45tsFk=;
  b=ArWmXA8iDqEF4vJVAWYSClArHfzQHvnJQgR/ojPWWABtGENbhH3ZCcwS
   AJ14hN8fZzA1kGVuM16LCTI3i2IzPB4/KZvS6hZ/h2+VyzbiXyxKZ98Mc
   Ax8w5IkTGygX7mCxCbrkOIlvJg02gd5yhsJiq7Ojv9OijIMWpFfbgyq6w
   elRXGezf8DwAmhx7bXMOb5IXT6hrOgCv75mbEqYesjPxAApZjC3sXPKxn
   zp86MCqGICzCZe9hWERxVLKHWM6FAlsnBr3nkU8ZdOOIg+VZYmnzaces4
   97FebuRjFU5fSyNtPjh6tzMI6pFDftSvtLbMGSrfZtJwSLMZU1gyXWzhV
   g==;
X-CSE-ConnectionGUID: rseK7Xb2QoyKbff6OYvvdg==
X-CSE-MsgGUID: HEjkT8toRamFJ4mOGaQvyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="90039566"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="90039566"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 01:27:18 -0700
X-CSE-ConnectionGUID: rngQQo1GQeOisUjcundRGw==
X-CSE-MsgGUID: DgnysbozQGullXJVZsco9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="263836334"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 18 Aug 2026 01:27:16 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wwFA8-00000000eCM-3pns;
	Tue, 18 Aug 2026 08:27:12 +0000
Date: Tue, 18 Aug 2026 16:26:21 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 "Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: arch/riscv/include/asm/syscall_wrapper.h:35:14: warning:
 '__se_sys_userfaultfd' alias between functions of incompatible types 'long
 int(ulong,  ulong,  ulong,  ulong,  ulong,  ulong,  ulong)' {aka 'long
 int(long unsigned int,  long unsigned int,  long uns...
Message-ID: <202608181601.lxsFodJY-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: jn6iyjahjf33saqzoms3m68bjds56sn1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 891F540007
X-HE-Tag: 1787041638-816313
X-HE-Meta: U2FsdGVkX19xNiWacAi+M+nKO4UjMmWViE0OevnSG9euQwJBznrB/nlzOmDhwZHPPWXUoKu/7rrLtBtJyVBmAhmur9o0tM22bbjhtOa3ZHS6CZbGcwjrEmueM6VQB4+6ZT/ZBWhZTYB2FdB0/2nllwYdNqiV7XtRE4ip1wNN/uoC4ikTJ7XULjBmQYdKivFqThdBl25vhH53UbZz8j0gK36aUMGoIh4s/tS1urCPRjCYfNUBlA+p/rcLCD58unR6V9v4W5SXrnb4dTi5V2DT7oczclwx3D4UeAmJvZCG8YHjoBXLrOAfnjGYQlvIyQ3awmNOl8oJjXCwOZgWi4pvWZcz+j2htyUM33zX2QIsiPfnseFR3PYRxSvn9MYtM584RrcpKETUli+aR1KEAe7Qhwq2W7gnn/6aIJMeBeFxyOatkADKMAzGSGkyrduR/khQkX402cc+EHDATtjn3PiAzJZPoCuUfsjD1MAQfj+IuDYuNIoE7F6R7ws8Gsa8yjoaogSTTMifJ1K0VA4XKpx465lVt4rYs9VUXLIJeiS/lZ5bv5h3v2SrcyR12dA7SYrA7AS3DPSrl23RGwWtDVKBA2JhrIYaVaj7aFVDuuEA2wbz3mA/pIziucR0QEEH3Wg47TZRU0TMstX1+Y2GG8CBYjoO4yj6OMm4ipFZZSCiilnT7Ovx923ci+StxbwZr595E1fxT29vWfK7cMvnAz+8pvlv+yow/Tkj6H5lARHgo+jZeloRVml+Ta1CBEFD/ag0eYWyxiAcU8f5chlnL9o/cwzswChSFE1+mkrVIHhK+6wj0gCtUKnZzDxWiOlI2Pbp4RzOziFT8SFB6HJY7rWwB2JVGVFqzdwLgrhKOuSred5XZ3qJukwywqU9Er6N4qJFq7ejOcRSbLyamqA+NDWwfBer+rePbPs8dPLy38KvFjnDgwjcPe7Yzqa7S5u5AwAxY33Bkz/9c2clM0ZQCC1
 8cynnUWP
 SqtwlPlUXV0vuypHGxO4CtSCMeaPJzrK7RKGWZZZcJtV2zSYDdQu/OEqp0rCGwjMUNuJx4ACaNHbY7vwXNk8sXhjGkGFrpR9FbrS2p59rpPBNTfxse84l4GT/wuUN+vqH5q+jlQDdDTWWAIrVhfCXa3dQNUwJR2y9qMmPlN2mD0Oeve+u97nq1iROX1VNnQ6kbZbUf/mQTe+W6CoHOykchUxx39ZumRYNR42IJ76Emf+wamhihJOY902i+Ln+3j3VNfLaI+u8iIsBGcUzYQUNwPUWMc6liEkyxaI0ZF73sZ1BuCEeovTQpybZF9qhRu4FFXWY8C4UBlYp5+g/aU2ENlFJQBBYtf9oTQ5zJFtAjxkQw8VNDtuIZXG/BbSno++s3i6s9piLQIFSQc+6WknGWooFCAXnHg4yPCRTBiPGRjNyiyPsMucWw1BPXA9AQoCAK9TgHKur5LkBw1z2zeZFMzoq/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   8d3ae59288f1e7d58d76558a6ee96d533bc5019f
commit: 7bc5e747bba29d5b77b2278e8c696eea0c796706 userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
date:   2 months ago
config: riscv-randconfig-r062-20260818 (https://download.01.org/0day-ci/archive/20260818/202608181601.lxsFodJY-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260818/202608181601.lxsFodJY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 7bc5e747bba2 ("userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608181601.lxsFodJY-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/compat.h:34,
                    from arch/riscv/include/asm/elf.h:12,
                    from include/linux/elf.h:6,
                    from include/linux/module.h:20,
                    from include/linux/device/driver.h:21,
                    from include/linux/device.h:32,
                    from include/linux/blk_types.h:11,
                    from include/linux/writeback.h:13,
                    from include/linux/memcontrol.h:23,
                    from include/linux/rmap.h:12,
                    from mm/userfaultfd.c:16:
>> arch/riscv/include/asm/syscall_wrapper.h:35:14: warning: '__se_sys_userfaultfd' alias between functions of incompatible types 'long int(ulong,  ulong,  ulong,  ulong,  ulong,  ulong,  ulong)' {aka 'long int(long unsigned int,  long unsigned int,  long unsigned int,  long unsigned int,  long unsigned int,  long unsigned int,  long unsigned int)'} and 'long int(long int)' [-Wattribute-alias]
     static long __se_##prefix##name(ulong, ulong, ulong, ulong, ulong, ulong,  \
                 ^~~~~
   arch/riscv/include/asm/syscall_wrapper.h:82:2: note: in expansion of macro '__SYSCALL_SE_DEFINEx'
     __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)    \
     ^~~~~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:236:2: note: in expansion of macro '__SYSCALL_DEFINEx'
     __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
     ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:225:36: note: in expansion of macro 'SYSCALL_DEFINEx'
    #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                       ^~~~~~~~~~~~~~~
   mm/userfaultfd.c:4475:1: note: in expansion of macro 'SYSCALL_DEFINE1'
    SYSCALL_DEFINE1(userfaultfd, int, flags)
    ^~~~~~~~~~~~~~~
   arch/riscv/include/asm/syscall_wrapper.h:41:14: note: aliased declaration here
     static long ___se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))
                 ^~~~~~
   arch/riscv/include/asm/syscall_wrapper.h:82:2: note: in expansion of macro '__SYSCALL_SE_DEFINEx'
     __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)    \
     ^~~~~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:236:2: note: in expansion of macro '__SYSCALL_DEFINEx'
     __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
     ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:225:36: note: in expansion of macro 'SYSCALL_DEFINEx'
    #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                       ^~~~~~~~~~~~~~~
   mm/userfaultfd.c:4475:1: note: in expansion of macro 'SYSCALL_DEFINE1'
    SYSCALL_DEFINE1(userfaultfd, int, flags)
    ^~~~~~~~~~~~~~~


vim +35 arch/riscv/include/asm/syscall_wrapper.h

a9ad73295cc1e3 Sami Tolvanen 2024-03-11  16  
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  17  #define __SYSCALL_SE_DEFINEx(x, prefix, name, ...)					\
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  18  	static long __se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__));		\
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  19  	static long __se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  20  
08d0ce30e0e4fc Sami Tolvanen 2023-07-10  21  #define SC_RISCV_REGS_TO_ARGS(x, ...)							\
08d0ce30e0e4fc Sami Tolvanen 2023-07-10  22  	__MAP(x,__SC_ARGS								\
08d0ce30e0e4fc Sami Tolvanen 2023-07-10  23  	      ,,regs->orig_a0,,regs->a1,,regs->a2					\
08d0ce30e0e4fc Sami Tolvanen 2023-07-10  24  	      ,,regs->a3,,regs->a4,,regs->a5,,regs->a6)
08d0ce30e0e4fc Sami Tolvanen 2023-07-10  25  
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  26  #else
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  27  /*
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  28   * Use type aliasing to ensure registers a0-a6 are correctly passed to the syscall
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  29   * implementation when >word-size arguments are used.
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  30   */
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  31  #define __SYSCALL_SE_DEFINEx(x, prefix, name, ...)					\
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  32  	__diag_push();									\
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  33  	__diag_ignore(GCC, 8, "-Wattribute-alias",					\
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  34  			"Type aliasing is used to sanitize syscall arguments");		\
a9ad73295cc1e3 Sami Tolvanen 2024-03-11 @35  	static long __se_##prefix##name(ulong, ulong, ulong, ulong, ulong, ulong, 	\
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  36  					ulong)						\
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  37  			__attribute__((alias(__stringify(___se_##prefix##name))));	\
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  38  	__diag_pop();									\
653650c468be21 Sami Tolvanen 2024-03-26  39  	static long noinline ___se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
653650c468be21 Sami Tolvanen 2024-03-26  40  			__used;								\
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  41  	static long ___se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))
a9ad73295cc1e3 Sami Tolvanen 2024-03-11  42  

:::::: The code at line 35 was first introduced by commit
:::::: a9ad73295cc1e3af0253eee7d08943b2419444c4 riscv: Fix syscall wrapper for >word-size arguments

:::::: TO: Sami Tolvanen <samitolvanen@google.com>
:::::: CC: Palmer Dabbelt <palmer@rivosinc.com>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

