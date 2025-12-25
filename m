Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D231E7AD6C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 21:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0EB46B0088; Thu, 25 Dec 2025 16:20:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC8A6B0089; Thu, 25 Dec 2025 16:20:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB0F6B008A; Thu, 25 Dec 2025 16:20:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A848E6B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 16:20:18 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53EDD134D4
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 21:20:18 +0000 (UTC)
X-FDA: 84259261716.06.D702827
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf17.hostedemail.com (Postfix) with ESMTP id CF8A440004
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 21:20:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bu+KqdXR;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766697616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=+nbSVUcoCP1a1bMcl9oQvtHsR3R/BuJCtR83gWRL4Ps=;
	b=8ickqHvkr48OIutks4WVQjB8UiDywlYajylX6mTGTb95xRWKGeF3Q53jIAihRsbZeeSCoO
	k9XW3S/WPgJ2X3gbA7x1FkaFo7eJKmcXSUzsUhnRzqnvd8YPtaDTqXq33a7MRUe/WPUpqz
	g6uoLc7mu4z3UocibtJHo6HtACtGB98=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Bu+KqdXR;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766697616; a=rsa-sha256;
	cv=none;
	b=QqWzEZ5Z601PUQMgtaXzr4Q+yMbPrEQo5mLJf+/M1GvqUQU+BSDYNWyf7FKlZzmb0XfXJX
	CfYBJJ0q4bIK+9RPXu4xahl83KQ8XUHOWZ1rrml+5K1fw0pYs7Fmn5tN+Zmd6WWVn/p+8y
	clvXgn/2fcl9HmNKnO4/EfNts9XBlzU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766697616; x=1798233616;
  h=date:from:to:cc:subject:message-id;
  bh=XaLM7os6e5UXE+tpZnDkhWR1TqzpCT/i5KWbI59rm8s=;
  b=Bu+KqdXRUPbGfOZVlhEE6ciRSxBOvt7uYbwwvqeaEjkPdVnt8PEWb5AN
   WD8k1WkcIQiKLWlkXL2fbLr54I8V5zk063+b3GbdHODz5+FyYiQEtvID2
   ewlmft2G7LeUwfmr5Y1J2iWnzQQzWow91Qua5o4MshWMGA08dCVDu487j
   i2smNbUUms+bBfCOZaavDfmvGKJFtx6WNXIuPonDCSznyYdqOpy0r9Hz+
   itpuC0bZckHXBIvMq8l3H4XNVZEg6GMdi/R3AYE8l+jitJl2THaUWx3VM
   uhpYIGFuwW/Poh5+TPn23NL0Pn6oFpxIzQv6UA8LpFVeLk7D/5uT0Ziuq
   g==;
X-CSE-ConnectionGUID: Obwplrf2QcirV+N/0BtEQA==
X-CSE-MsgGUID: G9JvuuawTm6nIx6o+Q952g==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="68555807"
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="68555807"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 13:20:14 -0800
X-CSE-ConnectionGUID: 5kqHLiiYSoCwfFkG7l7pog==
X-CSE-MsgGUID: J8krOrRnTOmqkU33RcSirQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="200759224"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 25 Dec 2025 13:20:13 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vYske-000000004TB-1Te3;
	Thu, 25 Dec 2025 21:20:06 +0000
Date: Fri, 26 Dec 2025 05:19:07 +0800
From: kernel test robot <lkp@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Finn Thain <fthain@linux-m68k.org>
Subject: [akpm-mm:mm-nonmm-unstable 71/99]
 include/linux/instrumented.h:86:(.text.efi_stub_common+0x198): undefined
 reference to `warn_slowpath_fmt'
Message-ID: <202512260552.mJWvYIYi-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CF8A440004
X-Stat-Signature: uhbjf5qweq8mb3dkriz1rxt15gmx1m3j
X-Rspam-User: 
X-HE-Tag: 1766697615-36805
X-HE-Meta: U2FsdGVkX184QDUDM2oPiynhgYw7F+LprGGYWyY7dY2BrAJYq9WVqC4s39e0qZA4smhU6qGrnNNAhVB1I315L5NN8sOHrctWcaS/QExZKOy6L0H+9Q959jDDmZdFYTGaXH7R1ZaV9p2ukTVKtjIMll1wx24lv3trzSzL4m/lRSh4U8b86KZr4ND5NPx/GSYc3Fb28GQAc+F+Tlk29T1TyrHETCgjBDp5vIdyJWgJJdFGuFDz2VWQKMPUp5RwMRLPW3HG1ebvwXgrIqd/yL+2IKFvYckvT4yGioz2u12LD+6ef9Uqn3fOvf497RwCUP6gXTIwzNyazzxJtD2S0gp0XkoI1AAiyF7mjR9mSE8vBGXkfAQ8pV+8Oo+APz8AM/vuFr5MNn8sGEqXvmQ32CMOwpI2eYGkzlZHiZ7pXuM/VbCsne1gJyy0d8NTIcvAwcnWkPaNtrBlkktDpii5V/FwI2n3mCBeGzqTbUy1ayUa4dyp6tbNUltIsB8jfa0JbRGCVuseOTJMXTLKQATQEsVvr2DFcCnCBJdHvRLmgM6qr6g5ipj+ULRWR19LmGflIm75HlfQd4fkL+KXtdsLLe0+4mxEBjz2K8dI1EDKoxUSCbcdu43tVxXCGbh1ylNGDcrI08RMN4hISTQwHjeqXfb3LVIrX72JUovxftyjNDYAghO1E55EDcI0/hCTF26pozGQkLEEIsLukE0PAak2jQBSkr18MGVP8ZIxJO2z/meppT8DFjyganXLdRFtXRFdBCNHOHCK7C2f7QkERKWHfNqnI0mrjdhH3bqH5SPVRwbOI7ftC1IpSfID8D2ATyyysDNMxprBZVWYipDNMmXR9EC8yOBrtl0PlG5R7/CXNQjUhx/A8NhcByTBDGD/n+xbH467aNiUaRpC8l7X6YfgpuGBM7a4L098IybiVOMW3cygS1fZodauZQdYbMWqhXcKvEgMQ+3aIur0+6iIGD6Jtkc
 Vir3kbZk
 QBjWqJLa+nCd14dI70+53AdHWV9kOhP2M5hXJJgmKi3WYCO3G0303jTtRPYdt0qmbcEJOaiBrSbcBKzIC3H3k6QE8f6VvfOzjgN7ku4TVNpVHAed/N8uUSv4bb/KIUV4/iAvngt6cspil6cR48o5iHqjhrDyFAZ89GWVSzp9iBOV+FF6/2pQ2emiresJQoRhTBoxmYNjb1qj5z7oOgsWC/d5Jt6u3EgQ5wTu0QlcuLdFf+m0J43q5AFo/w4S2cBEvXyLhNXyJ1UpY9vRTHYkfToTXDuRnEZ1hVaRw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   c40f0b9f72a08d208c7793090ae98faaf6a58719
commit: 472d1f40d1f7db592e9fef39a813c7e8cf95359d [71/99] atomic: add alignment check to instrumented atomic operations
config: arm-randconfig-r072-20251225 (https://download.01.org/0day-ci/archive/20251226/202512260552.mJWvYIYi-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251226/202512260552.mJWvYIYi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512260552.mJWvYIYi-lkp@intel.com/

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: warning: orphan section `.data..once' from `drivers/firmware/efi/libstub/efi-stub.stub.o' being placed in section `.data..once'
   arm-linux-gnueabi-ld: error: zImage file size is incorrect
   arm-linux-gnueabi-ld: drivers/firmware/efi/libstub/efi-stub.stub.o: in function `instrument_atomic_write':
>> include/linux/instrumented.h:86:(.text.efi_stub_common+0x198): undefined reference to `warn_slowpath_fmt'
   arm-linux-gnueabi-ld: arch/arm/boot/compressed/vmlinux: hidden symbol `warn_slowpath_fmt' isn't defined
   arm-linux-gnueabi-ld: final link failed: bad value


vim +86 include/linux/instrumented.h

    73	
    74	/**
    75	 * instrument_atomic_write - instrument atomic write access
    76	 * @v: address of access
    77	 * @size: size of access
    78	 *
    79	 * Instrument an atomic write access. The instrumentation should be inserted
    80	 * before the actual write happens.
    81	 */
    82	static __always_inline void instrument_atomic_write(const volatile void *v, size_t size)
    83	{
    84		kasan_check_write(v, size);
    85		kcsan_check_atomic_write(v, size);
  > 86		WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ATOMIC) && ((unsigned long)v & (size - 1)));
    87	}
    88	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

