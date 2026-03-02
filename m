Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50108EB3644
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 23:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75DC16B00FE; Mon,  2 Mar 2026 18:58:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7158A6B0100; Mon,  2 Mar 2026 18:58:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614606B0101; Mon,  2 Mar 2026 18:58:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF116B00FE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 18:58:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6D7EB8924
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 23:58:36 +0000 (UTC)
X-FDA: 84502790232.07.5B204A4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf18.hostedemail.com (Postfix) with ESMTP id E66621C000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 23:58:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MT+Id71O;
	spf=temperror (imf18.hostedemail.com: error in processing during lookup of lkp@intel.com: DNS error) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772495915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=KGAT9q+QuTDt3o2J/leIBfmNoi0ZcIn7WiOPRFy98RE=;
	b=L26QYCyEDsIncHOHXssyjjKHm9ooG6oep7EOE4nwgK7POnMbBJpYCLqyrCzmR4PYyK9LJO
	UaMwdYHxcD01SS/17Q7DcZnN3x1aTBE71ahpxseZSawjJhGzJ4PEKn3ZJXNnTwk8B6Xb4a
	3fdCNycoxZTIjbx+huQU99Hz93uMUak=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MT+Id71O;
	spf=temperror (imf18.hostedemail.com: error in processing during lookup of lkp@intel.com: DNS error) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772495915; a=rsa-sha256;
	cv=none;
	b=26XSrddvzqXoIaEeLuPoPIo51MFpc7+BT6uovy4PyG1bDvIniwcSa0GB2xtOBi0qyr+i3C
	RXvGqSuZfBulmoBOY3ufuUU04RJyCCxI3icR6lgp/7is7GLqnF4ezqCPuO8lWHZ+JQmB49
	y0QPKtWUO7rS7nXN0xeMOZF0jLdV1CU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772495910; x=1804031910;
  h=date:from:to:cc:subject:message-id;
  bh=koyzbirrC6lzDW8hEJh/FRkKUFYgp0uyt/Dbpy1ooe8=;
  b=MT+Id71O9dephlQk2S7YwTB52UX4UBIRUBLUuhppTkMwsC2ksEyzM0td
   HWiinSHNGxDH2JPB3UKTtDf/DwLOgOFk5fnyxlzaLhDsTcS9YtSFjox3n
   7xBc+i48H0l4pZstP26GcmsxKM5YEL2fXAEAr0oIlDmhcdhBMucWsl3tI
   AvcsUkwOZEgLsRUrCRm/6o8fOMkf42TbyqPUYJj9QyXM67OFUHc98ujw8
   kQkFZAKMXda0J3TSn+ELXvi/DpLUVWV07BFy0uK8GxlO98JD8sDjitS3b
   tAVeoLXdRJPUxp1CA8WUZBG2RKCHeog8ZmPkE1smmkw6pnXWb5le/Whxa
   Q==;
X-CSE-ConnectionGUID: suEfty+sQGiWk/7kDbwxlA==
X-CSE-MsgGUID: NMVQrYmLSGmsGV+eOu7wcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73387132"
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="73387132"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 15:58:28 -0800
X-CSE-ConnectionGUID: 21tX4vP/SZCjQxwFAY9zEA==
X-CSE-MsgGUID: pTa/K8d5ROa8XOMIKd59sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="217048389"
Received: from lkp-server01.sh.intel.com (HELO f27a57aa7a36) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 02 Mar 2026 15:58:26 -0800
Received: from kbuild by f27a57aa7a36 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vxD9b-000000001Wj-28RH;
	Mon, 02 Mar 2026 23:58:23 +0000
Date: Tue, 03 Mar 2026 07:58:20 +0800
From: kernel test robot <lkp@intel.com>
To: Finn Thain <fthain@linux-m68k.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Arnd Bergmann <arnd@arndb.de>
Subject: include/linux/compiler_types.h:631:38: error: call to
 '__compiletime_assert_431' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
Message-ID: <202603030747.VX0v4otS-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: E66621C000A
X-Rspamd-Server: rspam08
X-Stat-Signature: eng3uxx9qdkxuonc76g88xgcr4eiyzu4
X-HE-Tag: 1772495909-670549
X-HE-Meta: U2FsdGVkX19V+YYe0w8/emZLZxITHhwic1s9n5WBY2UzeNrusI3X+MS84I9zMQELn4xTrgmcv9iAb+ARxoa69vuZM4qiJcVV8iDactm83jbbCl7MUVpS1DWWSQmg3xuW5JLafMYYYVOB71XvBBZA5VTDB7y7wf0vD6vgsYW4hev1Sx3QhU89fECHIRPvskHv+8K/5sa+buYSe7fsCt86HhG+lSFbeAOU1Ed3qeAhFZRdMOegpxdKHkuj4hbOLMSLn4hKk3+2NnOGxKjxOZ3oUq66d3ra0oAuvLhNL+QlVE4y5ntxM8zrdP6a/sFJ0oGFqE8aiIw9uezItr+dpMEnWgwuaD4IKgsxDDJgjLkqNfFyE5Zk7JyaTivzTDkr7LTYuzFvRXLJwpv+B+k74aEQmljcEfptKL9Pevzv8Zxeir+jVrOanLl4twweRzEDVIXz9B2B7+Je43jeUM/SX2nPWE4jpYZWsbXyA3UCGAhoBX6mQt5WAk3kHqQgSMlcAsz7XdtLERg8e3vucktAEQDWUv8ylF1UL3Fjxehh+GikGPgXfL0a9hNSpDRC8+eWJ63UH4690byNAOmNul4bZsZZn2BNw76StaFa13LfGhPlQwIBk656IrZFBZocPmEWS3bf9UP9wLaArtpw5vNHnq73VExfZjtUBAXMinLcOUH1gLUVOInM+IJTP3x8hsgcweijEiKZOiUuggTao0Nant55UDhXJspgtAt3nYsV3XMuVxVdYFO09LnnlvaYEgZNTtOXRE9aNO+9u03OQ8XoNud0v5z38bVOoGM6uCaokxYV8TG4rwLCs9LuCwbD+Uw9sECMHAhuURqhwl1NYMvwuXVxITWJ6/JuS6w6dfYt1RSwUjE/bphzcZgAbBu7i5c25SER3rIloNw8+Xv0RXeSX05BcSJCEtozTzWpS5tnxIEUMKjZmRWUivJhy1TM/YTk3AU9du0b/NvDEw8yRaNHzr8
 tHl0Oaka
 TCW3B3w4A9ZKF5BPDP5Pk4SwXivSsH2zgp/t8NPJCx72cVewdK9uj5MmWmJkgJeiJU77sM1xXy+BbLohpPSugVqJOTB/RE8unIhxf28D6hizHXqJDG0nc5+WGCLrQLJRdT63sAdf4niq7XEx7F/dKyt2pw3GFYoew/dtAd4T0PRW59pJx41JiMQBtpscxWQDelcmAn6SxBbKcUuVxJgGh7fnP14YAEb1gtdDZHN5VfVEA7NExb5FfWcBln3uEhjpem6qo7e3OQ6MrqJZrWtb24Uh6py597kxWEWs0lcQX/sjlkY0kbX4qa1p5m3aHcdO0KUPbplesjzEJplpr+vvUcbRUaC8vKfQN7N3j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   af4e9ef3d78420feb8fe58cd9a1ab80c501b3c08
commit: e428b013d9dff30f7a65509e33047ba975cce8ba atomic: specify alignment for atomic_t and atomic64_t
date:   5 weeks ago
config: m68k-randconfig-r133-20260303 (https://download.01.org/0day-ci/archive/20260303/202603030747.VX0v4otS-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260303/202603030747.VX0v4otS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603030747.VX0v4otS-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'qlt_queue_unknown_atio',
       inlined from 'qlt_24xx_atio_pkt_all_vps' at drivers/scsi/qla2xxx/qla_target.c:331:4,
       inlined from 'qlt_24xx_process_atio_queue' at drivers/scsi/qla2xxx/qla_target.c:7903:4:
>> include/linux/compiler_types.h:631:38: error: call to '__compiletime_assert_431' declared with attribute error: BUILD_BUG_ON failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u)
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/compiler_types.h:612:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler_types.h:631:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
     ^~~~~~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_target.c:216:2: note: in expansion of macro 'BUILD_BUG_ON'
     BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u));
     ^~~~~~~~~~~~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for NET_SELFTESTS
   Depends on [n]: NET [=y] && PHYLIB [=y] && INET [=n]
   Selected by [y]:
   - AMD_XGBE [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_AMD [=y] && (OF_ADDRESS [=y] || ACPI || PCI [=y]) && HAS_IOMEM [=y] && (X86 || ARM64 || COMPILE_TEST [=y]) && PTP_1588_CLOCK_OPTIONAL [=y]


vim +/__compiletime_assert_431 +631 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  617  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  618  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  619  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  620  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  621  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  622   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  623   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  624   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  625   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  626   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  627   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  628   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  629   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  630  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @631  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  632  

:::::: The code at line 631 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

