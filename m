Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 901ACC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 04:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCA46B00D4; Wed, 21 Jan 2026 23:41:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA626B00D5; Wed, 21 Jan 2026 23:41:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97ECC6B00D6; Wed, 21 Jan 2026 23:41:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7CBF76B00D4
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 23:41:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD77616013D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:41:45 +0000 (UTC)
X-FDA: 84358351770.10.5564E01
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD1CB40007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:41:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M6AIGO0e;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769056903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sS81AtEXJnJ9u2/EVCRnHGNXhq7h63VIbv7BFGvdwK4=;
	b=o6qRNFkOZO2bNHcQBBu3DKsgxkEBgWKW/8kuvuS8tVWtzHbzzagsk8GrEiWO3ZenGKPUyI
	QxMUKO47nYw8T0CV70Gxrt1GoL9mYKGYcagTyx3dI2fdkFhScv5Y43LaZLc1+sGH69gDDb
	kuAcQJRlfJsV0ps3IKxjFRB4lojwAE0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M6AIGO0e;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769056903; a=rsa-sha256;
	cv=none;
	b=SN277Q4lPnHGtbtF823plYew6em4VqD3z7OHTX/+qLSgyZCWe1qaOqksaEqErZPgOvvQut
	o8UfmfZOREb6HINYzpO/g7YkPCIw8vbxPP2H1BCnpHgANQYqRy5N2UiSxtTuSb4NhD+aH/
	de5+oDUYcN2FQKOR1TptIfRurcEOw8M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769056904; x=1800592904;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XDjJ+i/6OhmiyMhnzKwblycjAoTYUTnYXm/k+YWRXrY=;
  b=M6AIGO0eF5QXcCDnLZtSxTYZhL3ppRROR5IrCVKh/lCpiXTvYaHSsIGZ
   PhbR+4C2Y2q90ihl5LX2wQzMfodJ9q03D9ejlgKXSH2qqPoft8GlRv8iO
   QDghm9EoqvojdNjC7K3GqTwhipdbfIszFhqCu/y9yj3JB0VHdlRBfJsh7
   cLBYQ7TeA6CwKUWakcqxHEgf69jpfy+5LwVhmysrCW8kVGZCMz33dPHD9
   xbH+FCCWgH1kP/nARuw+NgR9zbVP/O2C7cCSdfhhBFLGira1PBYkDgG/h
   cx1L2awhrwXbgBbvbjuK+VMvTi9mU9C/cDAKrXOzfcxW3WeirwN32E/ZX
   A==;
X-CSE-ConnectionGUID: acpZW55FRzaJcOsip73BVw==
X-CSE-MsgGUID: waZjEomNSFKAN7LeHoKo4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="92958133"
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="92958133"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 20:41:42 -0800
X-CSE-ConnectionGUID: 2tBuXIbfTgm/f3DnnFvNtg==
X-CSE-MsgGUID: ktYzPGfESaG7x2rmUBIAhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="206692855"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 21 Jan 2026 20:41:36 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vimVh-00000000SR9-2RdG;
	Thu, 22 Jan 2026 04:41:33 +0000
Date: Thu, 22 Jan 2026 12:41:22 +0800
From: kernel test robot <lkp@intel.com>
To: david.laight.linux@gmail.com, Nathan Chancellor <nathan@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: Re: [PATCH next 11/14] bit: Strengthen compile-time tests in
 GENMASK() and BIT()
Message-ID: <202601221237.soiAkwkN-lkp@intel.com>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121145731.3623-12-david.laight.linux@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CD1CB40007
X-Stat-Signature: 6mm9bx5eq45yf15dufz3autn8x3tq5fk
X-Rspam-User: 
X-HE-Tag: 1769056902-7893
X-HE-Meta: U2FsdGVkX19Sgh3wZ0lb9U0AEmnzCavdbODgjRUASTytel5BnSiCQnCP04smLvFImkF2oQckP9OEU+dOfGqBVgIuQajDJfGHqLzNmqBNXuogWUHFK/I71Zu/sifNvcMwO+GW2pUxzEGvB5q6EE1lxRCWYDfroX2Rlgss71fasWPXcruzINng7j2NS6h9eHneHs+gkt+d2NiqGpVPp6H1SOwedOhBjIWaHbwEoefl5+dQcK/udORaJ3BjywCEyDQHPSrXbHnaQx7dvJ2KEwSctijiVuA+P4Lri5Qc7sdvvXos5TpYrQa7gJ3gBHKKRI2johe15ebznwZPFLi8LyyBVAxFxQyrtflcaFMm/kAxc45FGP9P4V25o6zau171vGcgMRr+4Hpd+PuMvCIDg8uZHT4ZI+i7ocEpCv4m6Brn+FgdCkpQuNraZbULNJd0ji/pCv1aadr3+0o1jqwOzTxRg31g1tMM6FGIXWTva/M1j5jLgIrIAmDQHR14WvdWfBQT32dirSaKCW52uBDXL0EUYLNupDNmSNONDOtBrJSDxYZv3i0+jTa7L2UlCShgrf0SZyVJLsj0pRFqmPQQrDCMBMVENkxVtcOVYRXpxWEahahsjv4Jq0jdOtaTg7SV52NRi3OQxPv4OkRntIuTJPdkd4SyHkLyg/nDyRF+s7oKyUuErc5sCaSIeQQF1QXG4C6nqo4PrPvN+9eoJNoSJ8K53T7w6IbnpIyayP4sii9pM7sue8xFaJcojP/v1DzByiNy0O1HnQPleVX6Ak00gzNYH5wfUQLdNYvZ4ZJJld+o5vsBxhGvzA50g3mTIAWQ0Cu1dyREUqwaCzowQ7UGaA8qXx7CAEvYk+HVcJ8cs44hWBu/Rhzql6wyCPS4bwtNNUgnMhNt3NjOAlmk9xbGYbBz6yglQg00wslfPpGf4EHkwTNmSmPxesmfoE0SDndKrWTqPtCaPGKHZlgSHPMRbqN
 v5DGy8oo
 UIbQCBkDgTI58AlqB9nHnqZM6xUk1dViC1N6bMxBb/R34jNGzbqJvtL6hFpB1enTW6GwSmQOex1JSKDjfteP4BClut1b0CYvRoWzpVnTujIHFBrGHNT0lPH2ntYlEBPBy1AB+ujvMuMcSXWM6XaNw/Er3tqm4YN9ElNlHwhtoyhoBE0OqcUnpIQzB46NUnYguZKvLTUouJ4OjUgGpUsEfA7KVMTyxhIWopcdnhtgshqR+9Dsv4r43+kpJnsiEpXFUyyDkP9G7sYUhNRGALJy1ETi+ZuF/QC5vjiCjYaPf0uEku2ra8qL5WR1EYJgPvgQgx1RkGCZKVJYchPGtwEtHFG6Ml3u1QfCnucfp7wXiXWkJF4+WPzHqpYYAbcCUj9wwa/El9iubEhDG2OtV+VF4d+VA2SxK1zSpB8fxnm0i1ZxY38B6H0Z770qfmxDNq6tYw8hFiDdaZMMF/W5FBkF/M5tZ0SsV+aZmscHLmfJpCpsYlCc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20260120]

url:    https://github.com/intel-lab-lkp/linux/commits/david-laight-linux-gmail-com/overflow-Reduce-expansion-of-__type_max/20260122-013456
base:   next-20260120
patch link:    https://lore.kernel.org/r/20260121145731.3623-12-david.laight.linux%40gmail.com
patch subject: [PATCH next 11/14] bit: Strengthen compile-time tests in GENMASK() and BIT()
config: mips-randconfig-r132-20260122 (https://download.01.org/0day-ci/archive/20260122/202601221237.soiAkwkN-lkp@intel.com/config)
compiler: mips64-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221237.soiAkwkN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601221237.soiAkwkN-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   kernel/kthread.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
   kernel/reboot.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
   lib/idr.c: note: in included file (through include/linux/bitmap.h):
   include/linux/find.h:188:32: sparse: sparse: Variable length array is used.
   include/linux/find.h:388:46: sparse: sparse: Variable length array is used.
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
   lib/xarray.c: note: in included file (through include/linux/bitmap.h):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
   lib/xarray.c: note: in included file:
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
   lib/xarray.c: note: in included file (through include/linux/bitmap.h):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
   lib/find_bit.c: note: in included file (through include/linux/bitmap.h):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
   include/linux/find.h:238:46: sparse: sparse: Variable length array is used.
--
   lib/bitmap-str.c: note: in included file:
   include/linux/bitmap.h:488:25: sparse: sparse: Variable length array is used.
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
   lib/bitmap-str.c: note: in included file (through include/linux/bitmap.h):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
--
   lib/genalloc.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
--
   mm/oom_kill.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
   mm/vmscan.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
   mm/shmem.c: note: in included file (through include/linux/cpumask.h, include/linux/smp.h, arch/mips/include/asm/cpu-type.h, ...):
   include/linux/bitmap.h:488:25: sparse: sparse: Variable length array is used.
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
--
   mm/percpu.c: note: in included file (through include/linux/bitmap.h):
   include/linux/find.h:409:45: sparse: sparse: Variable length array is used.
   include/linux/find.h:188:32: sparse: sparse: Variable length array is used.
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
   mm/percpu.c: note: in included file:
   include/linux/bitmap.h:488:25: sparse: sparse: Variable length array is used.
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
--
   mm/vmalloc.c: note: in included file (through arch/mips/include/asm/page.h, include/linux/shm.h, include/linux/sched.h, ...):
   include/asm-generic/memory_model.h:30:23: sparse: sparse: unsigned value that used to be signed checked against zero?
   mm/vmalloc.c:554:21: sparse: signed value source
   mm/vmalloc.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
   mm/vmalloc.c: note: in included file (through include/linux/cpumask.h, arch/mips/include/asm/processor.h, arch/mips/include/asm/thread_info.h, ...):
   include/linux/bitmap.h:488:25: sparse: sparse: Variable length array is used.
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
   mm/vmalloc.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
   include/linux/find.h:188:32: sparse: sparse: Variable length array is used.
--
   mm/slub.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
   mm/hugetlb.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
   mm/huge_memory.c: note: in included file (through include/linux/cpumask.h, arch/mips/include/asm/processor.h, arch/mips/include/asm/thread_info.h, ...):
   include/linux/bitmap.h:488:25: sparse: sparse: Variable length array is used.
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
--
>> arch/mips/kernel/cmpxchg.c:20:16: sparse: sparse: Variable length array is used.
   arch/mips/kernel/cmpxchg.c:61:16: sparse: sparse: Variable length array is used.
--
>> arch/mips/kernel/cpu-probe.c:709:41: sparse: sparse: Variable length array is used.
   arch/mips/kernel/cpu-probe.c:712:45: sparse: sparse: Variable length array is used.
   arch/mips/kernel/cpu-probe.c:214:9: sparse: sparse: cast truncates bits from constant value (3fffffffffffe000 becomes ffffe000)
   arch/mips/kernel/cpu-probe.c:214:9: sparse: sparse: cast truncates bits from constant value (3fffffffffffe000 becomes ffffe000)
--
>> arch/mips/mm/tlb-r4k.c:536:20: sparse: sparse: Variable length array is used.
--
   net/ethtool/ioctl.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, include/linux/smp.h, ...):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
   net/ethtool/bitset.c: note: in included file (through include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, include/linux/ethtool_netlink.h):
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
--
   net/ethtool/linkmodes.c: note: in included file (through include/linux/bitmap.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
   net/ethtool/fec.c: note: in included file (through include/linux/bitmap.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
>> drivers/clk/clk-multiplier.c:48:16: sparse: sparse: Variable length array is used.
   drivers/clk/clk-multiplier.c:141:17: sparse: sparse: Variable length array is used.
--
>> drivers/clk/clk-fractional-divider.c:89:17: sparse: sparse: Variable length array is used.
   drivers/clk/clk-fractional-divider.c:90:17: sparse: sparse: Variable length array is used.
   drivers/clk/clk-fractional-divider.c:146:25: sparse: sparse: Variable length array is used.
   drivers/clk/clk-fractional-divider.c:147:25: sparse: sparse: Variable length array is used.
   drivers/clk/clk-fractional-divider.c:195:25: sparse: sparse: Variable length array is used.
   drivers/clk/clk-fractional-divider.c:196:25: sparse: sparse: Variable length array is used.
   drivers/clk/clk-fractional-divider.c:205:17: sparse: sparse: Variable length array is used.
   drivers/clk/clk-fractional-divider.c:206:17: sparse: sparse: Variable length array is used.
--
>> drivers/clocksource/mmio.c:66:27: sparse: sparse: Variable length array is used.
--
>> drivers/clocksource/timer-cadence-ttc.c:364:26: sparse: sparse: Variable length array is used.
--
>> drivers/clocksource/ingenic-timer.c:298:34: sparse: sparse: Variable length array is used.
   drivers/clocksource/ingenic-timer.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
   include/linux/find.h:188:32: sparse: sparse: Variable length array is used.
--
>> drivers/base/regmap/regmap.c:1221:26: sparse: sparse: Variable length array is used.
--
   drivers/base/regmap/regcache-rbtree.c: note: in included file (through include/linux/cpumask.h, include/linux/smp.h, arch/mips/include/asm/cpu-type.h, ...):
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
--
   drivers/base/regmap/regcache-flat.c: note: in included file:
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
--
   drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
   drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c: note: in included file (through include/linux/cpumask.h, arch/mips/include/asm/processor.h, arch/mips/include/asm/thread_info.h, ...):
   include/linux/bitmap.h:488:25: sparse: sparse: Variable length array is used.
   drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
   drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c: note: in included file (through include/linux/cpumask.h, arch/mips/include/asm/processor.h, arch/mips/include/asm/thread_info.h, ...):
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
--
>> drivers/clk/actions/owl-mux.c:42:17: sparse: sparse: Variable length array is used.
--
>> drivers/clk/actions/owl-divider.c:76:17: sparse: sparse: Variable length array is used.
--
   drivers/gpio/gpiolib.c: note: in included file (through include/linux/cpumask.h, arch/mips/include/asm/processor.h, arch/mips/include/asm/thread_info.h, ...):
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
   drivers/gpio/gpiolib.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
   include/linux/find.h:388:46: sparse: sparse: Variable length array is used.
   include/linux/find.h:188:32: sparse: sparse: Variable length array is used.
   drivers/gpio/gpiolib.c: note: in included file (through include/linux/cpumask.h, arch/mips/include/asm/processor.h, arch/mips/include/asm/thread_info.h, ...):
   include/linux/bitmap.h:488:25: sparse: sparse: Variable length array is used.
--
>> drivers/gpio/gpio-nomadik.c:285:30: sparse: sparse: Variable length array is used.
   drivers/gpio/gpio-nomadik.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
--
   kernel/sched/build_utility.c: note: in included file:
   kernel/sched/debug.c:624:17: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/debug.c:624:17: sparse:     expected struct sched_domain *[assigned] sd
   kernel/sched/debug.c:624:17: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/debug.c:952:9: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *tsk @@     got struct task_struct [noderef] __rcu *curr @@
   kernel/sched/debug.c:952:9: sparse:     expected struct task_struct *tsk
   kernel/sched/debug.c:952:9: sparse:     got struct task_struct [noderef] __rcu *curr
   kernel/sched/debug.c:952:9: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *tsk @@     got struct task_struct [noderef] __rcu *curr @@
   kernel/sched/debug.c:952:9: sparse:     expected struct task_struct *tsk
   kernel/sched/debug.c:952:9: sparse:     got struct task_struct [noderef] __rcu *curr
   kernel/sched/build_utility.c: note: in included file:
   kernel/sched/topology.c:115:56: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sched_domain *sd @@     got struct sched_domain [noderef] __rcu *child @@
   kernel/sched/topology.c:115:56: sparse:     expected struct sched_domain *sd
   kernel/sched/topology.c:115:56: sparse:     got struct sched_domain [noderef] __rcu *child
   kernel/sched/topology.c:134:60: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sched_domain *sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/topology.c:134:60: sparse:     expected struct sched_domain *sd
   kernel/sched/topology.c:134:60: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/topology.c:157:20: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/topology.c:157:20: sparse:     expected struct sched_domain *sd
   kernel/sched/topology.c:157:20: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/topology.c:468:19: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct perf_domain *pd @@     got struct perf_domain [noderef] __rcu *pd @@
   kernel/sched/topology.c:468:19: sparse:     expected struct perf_domain *pd
   kernel/sched/topology.c:468:19: sparse:     got struct perf_domain [noderef] __rcu *pd
   kernel/sched/topology.c:638:49: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sched_domain *parent @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/topology.c:638:49: sparse:     expected struct sched_domain *parent
   kernel/sched/topology.c:638:49: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/topology.c:723:50: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sched_domain *parent @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/topology.c:723:50: sparse:     expected struct sched_domain *parent
   kernel/sched/topology.c:723:50: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/topology.c:731:55: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain [noderef] __rcu *[noderef] __rcu child @@     got struct sched_domain *[assigned] tmp @@
   kernel/sched/topology.c:731:55: sparse:     expected struct sched_domain [noderef] __rcu *[noderef] __rcu child
   kernel/sched/topology.c:731:55: sparse:     got struct sched_domain *[assigned] tmp
   kernel/sched/topology.c:744:29: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] tmp @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/topology.c:744:29: sparse:     expected struct sched_domain *[assigned] tmp
   kernel/sched/topology.c:744:29: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/topology.c:749:20: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/topology.c:749:20: sparse:     expected struct sched_domain *sd
   kernel/sched/topology.c:749:20: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/topology.c:770:13: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] tmp @@     got struct sched_domain [noderef] __rcu *sd @@
   kernel/sched/topology.c:770:13: sparse:     expected struct sched_domain *[assigned] tmp
   kernel/sched/topology.c:770:13: sparse:     got struct sched_domain [noderef] __rcu *sd
   kernel/sched/topology.c:932:70: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sched_domain *sd @@     got struct sched_domain [noderef] __rcu *child @@
   kernel/sched/topology.c:932:70: sparse:     expected struct sched_domain *sd
   kernel/sched/topology.c:932:70: sparse:     got struct sched_domain [noderef] __rcu *child
   kernel/sched/topology.c:961:59: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sched_domain *sd @@     got struct sched_domain [noderef] __rcu *child @@
   kernel/sched/topology.c:961:59: sparse:     expected struct sched_domain *sd
   kernel/sched/topology.c:961:59: sparse:     got struct sched_domain [noderef] __rcu *child
   kernel/sched/topology.c:1007:57: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sched_domain *sd @@     got struct sched_domain [noderef] __rcu *child @@
   kernel/sched/topology.c:1007:57: sparse:     expected struct sched_domain *sd
   kernel/sched/topology.c:1007:57: sparse:     got struct sched_domain [noderef] __rcu *child
   kernel/sched/topology.c:1009:25: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *sibling @@     got struct sched_domain [noderef] __rcu *child @@
   kernel/sched/topology.c:1009:25: sparse:     expected struct sched_domain *sibling
   kernel/sched/topology.c:1009:25: sparse:     got struct sched_domain [noderef] __rcu *child
   kernel/sched/topology.c:1017:55: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sched_domain *sd @@     got struct sched_domain [noderef] __rcu *child @@
   kernel/sched/topology.c:1017:55: sparse:     expected struct sched_domain *sd
   kernel/sched/topology.c:1017:55: sparse:     got struct sched_domain [noderef] __rcu *child
   kernel/sched/topology.c:1019:25: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *sibling @@     got struct sched_domain [noderef] __rcu *child @@
   kernel/sched/topology.c:1019:25: sparse:     expected struct sched_domain *sibling
   kernel/sched/topology.c:1019:25: sparse:     got struct sched_domain [noderef] __rcu *child
   kernel/sched/topology.c:1089:62: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sched_domain *sd @@     got struct sched_domain [noderef] __rcu *child @@
   kernel/sched/topology.c:1089:62: sparse:     expected struct sched_domain *sd
   kernel/sched/topology.c:1089:62: sparse:     got struct sched_domain [noderef] __rcu *child
   kernel/sched/topology.c:1193:40: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sched_domain *child @@     got struct sched_domain [noderef] __rcu *child @@
   kernel/sched/topology.c:1193:40: sparse:     expected struct sched_domain *child
   kernel/sched/topology.c:1193:40: sparse:     got struct sched_domain [noderef] __rcu *child
   kernel/sched/topology.c:1331:9: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/topology.c:1331:9: sparse:     expected struct sched_domain *[assigned] sd
   kernel/sched/topology.c:1331:9: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/topology.c:1680:43: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sched_domain [noderef] __rcu *child @@     got struct sched_domain *child @@
   kernel/sched/topology.c:1680:43: sparse:     expected struct sched_domain [noderef] __rcu *child
   kernel/sched/topology.c:1680:43: sparse:     got struct sched_domain *child
   kernel/sched/topology.c:2470:31: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain [noderef] __rcu *parent @@     got struct sched_domain *sd @@
   kernel/sched/topology.c:2470:31: sparse:     expected struct sched_domain [noderef] __rcu *parent
   kernel/sched/topology.c:2470:31: sparse:     got struct sched_domain *sd
   kernel/sched/topology.c:2591:57: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/topology.c:2591:57: sparse:     expected struct sched_domain *[assigned] sd
   kernel/sched/topology.c:2591:57: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/topology.c:2612:56: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sched_domain *child @@     got struct sched_domain [noderef] __rcu *child @@
   kernel/sched/topology.c:2612:56: sparse:     expected struct sched_domain *child
   kernel/sched/topology.c:2612:56: sparse:     got struct sched_domain [noderef] __rcu *child
   kernel/sched/topology.c:2611:57: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/topology.c:2611:57: sparse:     expected struct sched_domain *[assigned] sd
   kernel/sched/topology.c:2611:57: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/topology.c:2666:57: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/topology.c:2666:57: sparse:     expected struct sched_domain *[assigned] sd
   kernel/sched/topology.c:2666:57: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/build_utility.c: note: in included file:
   kernel/sched/build_utility.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, include/linux/smp.h, ...):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
   kernel/sched/build_utility.c: note: in included file:
   kernel/sched/sched.h:2360:25: sparse: sparse: incompatible types in comparison expression (different address spaces):
   kernel/sched/sched.h:2360:25: sparse:    struct task_struct [noderef] __rcu *
   kernel/sched/sched.h:2360:25: sparse:    struct task_struct *
--
>> drivers/clk/ingenic/cgu.c:95:42: sparse: sparse: Variable length array is used.
   drivers/clk/ingenic/cgu.c:97:42: sparse: sparse: Variable length array is used.
   drivers/clk/ingenic/cgu.c:102:27: sparse: sparse: Variable length array is used.
   drivers/clk/ingenic/cgu.c:224:18: sparse: sparse: Variable length array is used.
   drivers/clk/ingenic/cgu.c:227:18: sparse: sparse: Variable length array is used.
   drivers/clk/ingenic/cgu.c:231:26: sparse: sparse: Variable length array is used.
   drivers/clk/ingenic/cgu.c:345:26: sparse: sparse: Variable length array is used.
   drivers/clk/ingenic/cgu.c:389:24: sparse: sparse: Variable length array is used.
   drivers/clk/ingenic/cgu.c:423:31: sparse: sparse: Variable length array is used.
   drivers/clk/ingenic/cgu.c:553:24: sparse: sparse: Variable length array is used.
--
   kernel/irq/chip.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
   kernel/irq/irq_sim.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
--
   drivers/input/rmi4/rmi_driver.c: note: in included file (through include/linux/bitmap.h):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
   drivers/input/rmi4/rmi_driver.c: note: in included file:
   include/linux/bitmap.h:488:25: sparse: sparse: Variable length array is used.
   drivers/input/rmi4/rmi_driver.c: note: in included file (through include/linux/bitmap.h):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
--
>> drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c:338:31: sparse: sparse: Variable length array is used.
--
>> drivers/mfd/atmel-smc.c:56:32: sparse: sparse: Variable length array is used.
   drivers/mfd/atmel-smc.c:57:32: sparse: sparse: Variable length array is used.
   drivers/mfd/atmel-smc.c:120:27: sparse: sparse: Variable length array is used.
   drivers/mfd/atmel-smc.c:159:25: sparse: sparse: Variable length array is used.
   drivers/mfd/atmel-smc.c:198:25: sparse: sparse: Variable length array is used.
   drivers/mfd/atmel-smc.c:236:25: sparse: sparse: Variable length array is used.
--
>> kernel/time/sched_clock.c:194:20: sparse: sparse: Variable length array is used.
--
>> drivers/mtd/nand/bbt.c:87:25: sparse: sparse: Variable length array is used.
   drivers/mtd/nand/bbt.c:111:38: sparse: sparse: Variable length array is used.
   drivers/mtd/nand/bbt.c:116:20: sparse: sparse: Variable length array is used.
   drivers/mtd/nand/bbt.c:122:28: sparse: sparse: Variable length array is used.
--
   drivers/opp/cpu.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
--
   drivers/pci/pci.c:1157:36: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted pci_power_t [usertype] current_state @@     got int @@
   drivers/pci/pci.c:1157:36: sparse:     expected restricted pci_power_t [usertype] current_state
   drivers/pci/pci.c:1157:36: sparse:     got int
   drivers/pci/pci.c:1336:15: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted pci_power_t [assigned] [usertype] state @@     got int @@
   drivers/pci/pci.c:1336:15: sparse:     expected restricted pci_power_t [assigned] [usertype] state
   drivers/pci/pci.c:1336:15: sparse:     got int
   drivers/pci/pci.c:1338:50: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:1338:69: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:1391:28: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted pci_power_t [usertype] current_state @@     got int @@
   drivers/pci/pci.c:1391:28: sparse:     expected restricted pci_power_t [usertype] current_state
   drivers/pci/pci.c:1391:28: sparse:     got int
   drivers/pci/pci.c:1481:16: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:1481:35: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:1481:52: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:1481:70: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:1506:15: sparse: sparse: invalid assignment: |=
   drivers/pci/pci.c:1506:15: sparse:    left side has type unsigned short
   drivers/pci/pci.c:1506:15: sparse:    right side has type restricted pci_power_t
   drivers/pci/pci.c:1518:28: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted pci_power_t [usertype] current_state @@     got int @@
   drivers/pci/pci.c:1518:28: sparse:     expected restricted pci_power_t [usertype] current_state
   drivers/pci/pci.c:1518:28: sparse:     got int
   drivers/pci/pci.c:1535:13: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:1535:21: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:1537:18: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:1537:26: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:1560:13: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:1560:22: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:1865:38: sparse: sparse: array of flexible structures
   drivers/pci/pci.c:2343:44: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:2662:60: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:2663:30: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:2834:20: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:2834:38: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:2857:49: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:2857:67: sparse: sparse: restricted pci_power_t degrades to integer
   drivers/pci/pci.c:4486:13: sparse: sparse: invalid assignment: |=
   drivers/pci/pci.c:4486:13: sparse:    left side has type unsigned short
   drivers/pci/pci.c:4486:13: sparse:    right side has type restricted pci_power_t
   drivers/pci/pci.c:4491:13: sparse: sparse: invalid assignment: |=
   drivers/pci/pci.c:4491:13: sparse:    left side has type unsigned short
   drivers/pci/pci.c:4491:13: sparse:    right side has type restricted pci_power_t
>> drivers/pci/pci.c:5983:19: sparse: sparse: Variable length array is used.
   drivers/pci/pci.c:1112:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted pci_power_t [usertype] @@
   drivers/pci/pci.c:1112:24: sparse:     expected int
   drivers/pci/pci.c:1112:24: sparse:     got restricted pci_power_t [usertype]
   drivers/pci/pci.c:1112:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted pci_power_t [usertype] @@
   drivers/pci/pci.c:1112:24: sparse:     expected int
   drivers/pci/pci.c:1112:24: sparse:     got restricted pci_power_t [usertype]
   drivers/pci/pci.c: note: in included file (through include/linux/cpumask.h, arch/mips/include/asm/processor.h, arch/mips/include/asm/thread_info.h, ...):
   include/linux/bitmap.h:488:25: sparse: sparse: Variable length array is used.
--
   drivers/perf/xgene_pmu.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
   include/linux/find.h:388:46: sparse: sparse: Variable length array is used.
>> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
--
>> drivers/clk/renesas/rcar-gen3-cpg.c:287:22: sparse: sparse: Variable length array is used.
--
>> drivers/clk/renesas/rcar-gen4-cpg.c:400:22: sparse: sparse: Variable length array is used.
--
   drivers/mtd/nand/raw/nand_macronix.c: note: in included file (through include/linux/cpumask.h, arch/mips/include/asm/processor.h, arch/mips/include/asm/thread_info.h, ...):
   include/linux/bitmap.h:488:25: sparse: sparse: Variable length array is used.
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
--
>> drivers/clk/spacemit/ccu_mix.c:168:16: sparse: sparse: Variable length array is used.
   drivers/clk/spacemit/ccu_mix.c:193:16: sparse: sparse: Variable length array is used.
--
>> drivers/clk/sprd/mux.c:56:17: sparse: sparse: Variable length array is used.
--
>> drivers/clk/sprd/div.c:60:17: sparse: sparse: Variable length array is used.
--
>> drivers/clk/sprd/pll.c:77:24: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:116:13: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:120:34: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:121:31: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:124:14: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:125:32: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:127:24: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:128:21: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:129:32: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:131:24: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:164:16: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:170:16: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:181:16: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:186:16: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:192:16: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:198:16: sparse: sparse: Variable length array is used.
   drivers/clk/sprd/pll.c:210:16: sparse: sparse: Variable length array is used.
--
>> drivers/pci/pcie/bwctrl.c:94:26: sparse: sparse: Variable length array is used.
--
>> drivers/pinctrl/renesas/core.c:884:26: sparse: sparse: Variable length array is used.
   drivers/pinctrl/renesas/core.c:942:34: sparse: sparse: Variable length array is used.
   drivers/pinctrl/renesas/core.c:1241:34: sparse: sparse: Variable length array is used.
--
>> drivers/pinctrl/renesas/pinctrl.c:492:51: sparse: sparse: Variable length array is used.
   drivers/pinctrl/renesas/pinctrl.c:527:17: sparse: sparse: Variable length array is used.
--
   drivers/pci/controller/pcie-xilinx-dma-pl.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
   drivers/pci/controller/pcie-xilinx-dma-pl.c: note: in included file (through include/linux/cpumask.h, arch/mips/include/asm/processor.h, arch/mips/include/asm/thread_info.h, ...):
   include/linux/bitmap.h:488:25: sparse: sparse: Variable length array is used.
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.
--
   drivers/pci/controller/dwc/pcie-designware-host.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, include/linux/smp.h, ...):
   include/linux/find.h:69:31: sparse: sparse: Variable length array is used.
   drivers/pci/controller/dwc/pcie-designware-host.c: note: in included file (through include/linux/cpumask.h, include/linux/smp.h, arch/mips/include/asm/cpu-type.h, ...):
   include/linux/bitmap.h:488:25: sparse: sparse: Variable length array is used.
>> include/linux/bitmap.h:504:26: sparse: sparse: Variable length array is used.

vim +209 include/linux/find.h

c56f97c5c71f17 include/linux/find.h              Yury Norov [NVIDIA] 2025-06-19   48  
19de85ef574c3a include/asm-generic/bitops/find.h Akinobu Mita        2011-05-26   49  #ifndef find_next_bit
d852a6afd91fc9 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29   50  /**
d852a6afd91fc9 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29   51   * find_next_bit - find the next set bit in a memory region
d852a6afd91fc9 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29   52   * @addr: The address to base the search on
d852a6afd91fc9 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29   53   * @size: The bitmap size in bits
6d7131bd52b3e0 include/linux/find.h              Anna-Maria Behnsen  2022-04-11   54   * @offset: The bitnumber to start searching at
ec778edf97dcaa include/asm-generic/bitops/find.h Cody P Schafer      2013-11-12   55   *
ec778edf97dcaa include/asm-generic/bitops/find.h Cody P Schafer      2013-11-12   56   * Returns the bit number for the next set bit
ec778edf97dcaa include/asm-generic/bitops/find.h Cody P Schafer      2013-11-12   57   * If no bits are set, returns @size.
d852a6afd91fc9 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29   58   */
fda1dd3c54ef3c include/linux/find.h              Yury Norov          2024-07-18   59  static __always_inline
5c88af59f9abc2 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   60  unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
5c88af59f9abc2 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   61  			    unsigned long offset)
5c88af59f9abc2 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   62  {
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   63  	if (small_const_nbits(size)) {
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   64  		unsigned long val;
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   65  
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   66  		if (unlikely(offset >= size))
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   67  			return size;
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   68  
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  @69  		val = *addr & GENMASK(size - 1, offset);
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   70  		return val ? __ffs(val) : size;
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   71  	}
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   72  
e79864f3164c57 include/linux/find.h              Yury Norov          2022-09-14   73  	return _find_next_bit(addr, size, offset);
5c88af59f9abc2 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   74  }
19de85ef574c3a include/asm-generic/bitops/find.h Akinobu Mita        2011-05-26   75  #endif
c7f612cdf091de include/asm-generic/bitops/find.h Akinobu Mita        2006-03-26   76  
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06   77  #ifndef find_next_and_bit
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06   78  /**
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06   79   * find_next_and_bit - find the next set bit in both memory regions
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06   80   * @addr1: The first address to base the search on
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06   81   * @addr2: The second address to base the search on
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06   82   * @size: The bitmap size in bits
6d7131bd52b3e0 include/linux/find.h              Anna-Maria Behnsen  2022-04-11   83   * @offset: The bitnumber to start searching at
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06   84   *
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06   85   * Returns the bit number for the next set bit
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06   86   * If no bits are set, returns @size.
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06   87   */
fda1dd3c54ef3c include/linux/find.h              Yury Norov          2024-07-18   88  static __always_inline
5c88af59f9abc2 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   89  unsigned long find_next_and_bit(const unsigned long *addr1,
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06   90  		const unsigned long *addr2, unsigned long size,
5c88af59f9abc2 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   91  		unsigned long offset)
5c88af59f9abc2 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   92  {
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   93  	if (small_const_nbits(size)) {
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   94  		unsigned long val;
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   95  
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   96  		if (unlikely(offset >= size))
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   97  			return size;
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   98  
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06   99  		val = *addr1 & *addr2 & GENMASK(size - 1, offset);
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  100  		return val ? __ffs(val) : size;
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  101  	}
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  102  
e79864f3164c57 include/linux/find.h              Yury Norov          2022-09-14  103  	return _find_next_and_bit(addr1, addr2, size, offset);
5c88af59f9abc2 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  104  }
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06  105  #endif
0ade34c37012ea include/asm-generic/bitops/find.h Clement Courbet     2018-02-06  106  
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  107  #ifndef find_next_andnot_bit
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  108  /**
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  109   * find_next_andnot_bit - find the next set bit in *addr1 excluding all the bits
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  110   *                        in *addr2
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  111   * @addr1: The first address to base the search on
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  112   * @addr2: The second address to base the search on
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  113   * @size: The bitmap size in bits
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  114   * @offset: The bitnumber to start searching at
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  115   *
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  116   * Returns the bit number for the next set bit
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  117   * If no bits are set, returns @size.
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  118   */
fda1dd3c54ef3c include/linux/find.h              Yury Norov          2024-07-18  119  static __always_inline
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  120  unsigned long find_next_andnot_bit(const unsigned long *addr1,
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  121  		const unsigned long *addr2, unsigned long size,
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  122  		unsigned long offset)
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  123  {
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  124  	if (small_const_nbits(size)) {
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  125  		unsigned long val;
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  126  
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  127  		if (unlikely(offset >= size))
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  128  			return size;
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  129  
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  130  		val = *addr1 & ~*addr2 & GENMASK(size - 1, offset);
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  131  		return val ? __ffs(val) : size;
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  132  	}
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  133  
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  134  	return _find_next_andnot_bit(addr1, addr2, size, offset);
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  135  }
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  136  #endif
90d482908eedd5 include/linux/find.h              Valentin Schneider  2022-10-03  137  
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  138  #ifndef find_next_or_bit
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  139  /**
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  140   * find_next_or_bit - find the next set bit in either memory regions
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  141   * @addr1: The first address to base the search on
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  142   * @addr2: The second address to base the search on
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  143   * @size: The bitmap size in bits
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  144   * @offset: The bitnumber to start searching at
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  145   *
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  146   * Returns the bit number for the next set bit
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  147   * If no bits are set, returns @size.
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  148   */
fda1dd3c54ef3c include/linux/find.h              Yury Norov          2024-07-18  149  static __always_inline
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  150  unsigned long find_next_or_bit(const unsigned long *addr1,
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  151  		const unsigned long *addr2, unsigned long size,
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  152  		unsigned long offset)
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  153  {
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  154  	if (small_const_nbits(size)) {
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  155  		unsigned long val;
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  156  
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  157  		if (unlikely(offset >= size))
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  158  			return size;
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  159  
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  160  		val = (*addr1 | *addr2) & GENMASK(size - 1, offset);
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  161  		return val ? __ffs(val) : size;
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  162  	}
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  163  
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  164  	return _find_next_or_bit(addr1, addr2, size, offset);
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  165  }
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  166  #endif
1470afefc3c42d include/linux/find.h              Dave Chinner        2023-03-15  167  
19de85ef574c3a include/asm-generic/bitops/find.h Akinobu Mita        2011-05-26  168  #ifndef find_next_zero_bit
d852a6afd91fc9 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29  169  /**
d852a6afd91fc9 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29  170   * find_next_zero_bit - find the next cleared bit in a memory region
d852a6afd91fc9 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29  171   * @addr: The address to base the search on
d852a6afd91fc9 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29  172   * @size: The bitmap size in bits
6d7131bd52b3e0 include/linux/find.h              Anna-Maria Behnsen  2022-04-11  173   * @offset: The bitnumber to start searching at
ec778edf97dcaa include/asm-generic/bitops/find.h Cody P Schafer      2013-11-12  174   *
ec778edf97dcaa include/asm-generic/bitops/find.h Cody P Schafer      2013-11-12  175   * Returns the bit number of the next zero bit
ec778edf97dcaa include/asm-generic/bitops/find.h Cody P Schafer      2013-11-12  176   * If no bits are zero, returns @size.
d852a6afd91fc9 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29  177   */
fda1dd3c54ef3c include/linux/find.h              Yury Norov          2024-07-18  178  static __always_inline
5c88af59f9abc2 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  179  unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
5c88af59f9abc2 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  180  				 unsigned long offset)
5c88af59f9abc2 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  181  {
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  182  	if (small_const_nbits(size)) {
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  183  		unsigned long val;
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  184  
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  185  		if (unlikely(offset >= size))
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  186  			return size;
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  187  
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  188  		val = *addr | ~GENMASK(size - 1, offset);
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  189  		return val == ~0UL ? size : ffz(val);
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  190  	}
277a20a498d307 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  191  
e79864f3164c57 include/linux/find.h              Yury Norov          2022-09-14  192  	return _find_next_zero_bit(addr, size, offset);
5c88af59f9abc2 include/asm-generic/bitops/find.h Yury Norov          2021-05-06  193  }
19de85ef574c3a include/asm-generic/bitops/find.h Akinobu Mita        2011-05-26  194  #endif
c7f612cdf091de include/asm-generic/bitops/find.h Akinobu Mita        2006-03-26  195  
b7ec62d7ee0f0b include/asm-generic/bitops/find.h Yury Norov          2021-08-14  196  #ifndef find_first_bit
708ff2a0097b02 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29  197  /**
708ff2a0097b02 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29  198   * find_first_bit - find the first set bit in a memory region
708ff2a0097b02 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29  199   * @addr: The address to start the search at
ec778edf97dcaa include/asm-generic/bitops/find.h Cody P Schafer      2013-11-12  200   * @size: The maximum number of bits to search
708ff2a0097b02 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29  201   *
708ff2a0097b02 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29  202   * Returns the bit number of the first set bit.
ec778edf97dcaa include/asm-generic/bitops/find.h Cody P Schafer      2013-11-12  203   * If no bits are set, returns @size.
708ff2a0097b02 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29  204   */
fda1dd3c54ef3c include/linux/find.h              Yury Norov          2024-07-18  205  static __always_inline
2cc7b6a44ac21d include/asm-generic/bitops/find.h Yury Norov          2021-05-06  206  unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
2cc7b6a44ac21d include/asm-generic/bitops/find.h Yury Norov          2021-05-06  207  {
2cc7b6a44ac21d include/asm-generic/bitops/find.h Yury Norov          2021-05-06  208  	if (small_const_nbits(size)) {
2cc7b6a44ac21d include/asm-generic/bitops/find.h Yury Norov          2021-05-06 @209  		unsigned long val = *addr & GENMASK(size - 1, 0);
2cc7b6a44ac21d include/asm-generic/bitops/find.h Yury Norov          2021-05-06  210  
2cc7b6a44ac21d include/asm-generic/bitops/find.h Yury Norov          2021-05-06  211  		return val ? __ffs(val) : size;
2cc7b6a44ac21d include/asm-generic/bitops/find.h Yury Norov          2021-05-06  212  	}
2cc7b6a44ac21d include/asm-generic/bitops/find.h Yury Norov          2021-05-06  213  
2cc7b6a44ac21d include/asm-generic/bitops/find.h Yury Norov          2021-05-06  214  	return _find_first_bit(addr, size);
2cc7b6a44ac21d include/asm-generic/bitops/find.h Yury Norov          2021-05-06  215  }
b7ec62d7ee0f0b include/asm-generic/bitops/find.h Yury Norov          2021-08-14  216  #endif
708ff2a0097b02 include/asm-generic/bitops/find.h Akinobu Mita        2010-09-29  217  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

