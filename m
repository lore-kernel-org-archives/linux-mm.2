Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB034606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 12:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Wi1uDYB3
Received: by kanga.kvack.org (Postfix)
	id B8B716B00EF; Sat, 21 Nov 2026 07:35:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CC96B05B0; Sat, 21 Nov 2026 07:35:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54D36B05B1; Sat, 21 Nov 2026 07:35:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 813656B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:35:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6335F160406
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:35:08 +0000 (UTC)
X-FDA: 85459071096.25.FE2DA56
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9399F100007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:35:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Wi1uDYB3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795264506;
	b=MOB677O2MzjdglxQHMVoDJGk2694U2mgCND/F+IeFYvZTYjRX4RFWX0B6w2l0Nst/vyVJG
	MyqGz7wefC1ZNPhvkHDwhApWiBB9SwkzvhcHXjnVwJbEaDX7/QDkXVK0L8cALYx4DFqvqC
	Hc7UbCwXsK1LPAx/ozAZU28TMH+VkG0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795264506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=fBkwQlFl2vWM+gdG/eBluNIppBZvQ8GGyv7pbzEeyOY=;
	b=hm5SZ6RTrmUxV2UDqUmjbPcKAhXFKFYaxbHCBK1GvGcgWOKq7fsMoA+/iG2MXjAu4m+bJT
	N5HoT3w5suwhtGET8Pn4euYcaxNcllQpk6ZiJ/suB0xqB2T9kd8ssJoUcgMxmbqroq+kbf
	rHC03CooJfhEDX5KIOwxzzpdlT1MhMA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Wi1uDYB3;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795264505; x=1826800505;
  h=date:from:to:cc:subject:message-id;
  bh=3pHWHaGiu8L/HiFUut6PAs/7MP/O64YwN1hV5D8+o5k=;
  b=Wi1uDYB3QvYVR/10HP6FTYiHVGz8+EUQqbo5D2DAVjZ19tAC06Xjb4Q/
   FanYA9+Ri2PeubzIML448yt9+4yUi8x1Dnc0hFqEwm2W9x1AYr9ewMGtI
   54IpND1Vdxl4fNsWIlcT3N/+awHthw3H0JoX6WgDWQ7mVp+FUc3hhdoI+
   E/6XCHFCzxzG96h1OoeRNEHnw0Sn8eA8M3aGijq315LuGheCnj6qvyzpV
   jo+h15OkfY8hCi6Nvbp8n0vxbyaZ7ZEkmtL3Nu4CK8o0vyVUWzZAyH8hd
   Pwcx7ht1zYAVCO36UD6JNnZfJczfMy+BsJUKfgwskMNeloVnMMO4wbcaY
   w==;
X-CSE-ConnectionGUID: 8iEhjzGGQhyHcMCWiS1iMw==
X-CSE-MsgGUID: TBWgc7lNRYWOjKwKa/Ps0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11973"; a="4126474"
X-IronPort-AV: E=Sophos;i="6.27,225,1787036400"; 
   d="scan'208";a="4126474"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2026 04:35:04 -0800
X-CSE-ConnectionGUID: fZrGbwE3T5iY5fSQ0mtxUQ==
X-CSE-MsgGUID: 4dc95Z7DS0upIXG/FeJUDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,225,1787036400"; 
   d="scan'208";a="11485324"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 21 Nov 2026 04:35:02 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUkJ2-000000004Jp-1HUz;
	Sat, 21 Nov 2026 12:35:00 +0000
Date: Sat, 21 Nov 2026 13:34:45 +0100
From: kernel test robot <lkp@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: [akpm-mm:mm-unstable 327/327]
 arch/arm64/include/asm/percpu.h:261:1: sparse: sparse: cast truncates bits
 from constant value (ffffffffffffd8f0 becomes f0)
Message-ID: <20261121133112.48w1QOqw-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9399F100007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fi598jgbnftkjr4tzjddo4a4h5wz3p1o
X-Rspam-User:
X-HE-Tag: 1795264505-612007
X-HE-Meta: U2FsdGVkX19o3SB20ovY943bAPM6j51uKNSH55dqIK4By11/ZWAcxgJgHcoJhF+b1JTlBx9E1Xn5Joc/U00imtC29HnoBlMOvFt3udahHFEQ9dlDDhEq2S8g2Ujp4bRhBTD1NFze9qQQMRxoxP4FO6DOAw2+spd/dK+Xqf6Qq8AtAuzMbXLe6GPYyREoUaqsu/07566/qrgryR5CFcYwhvDws7RCOG5ElaHmtn9nPZV3YXfC7lUavKjca0ul9JMd0Kj6lwD9sBZ5qNMYb5ixqpujAah+ZbZerBSsP7TlsqyG/HCX7onSRyiy3LDy/awiLmpeLAh/+6mGZXK/p/Sk7/kje4uj2Sx0UfggC6taqqutkUBaBbrvVFf1WG7BL9vzt51tbnOKOyDTjEfn6z52t5bPe1SA5tEY+ulSoyCmW1wlj/wUvmSvTm1l3InsTMR0XomUYMyLnTsWoWxVnh1iWKQ9/0nobZ1L/2TxvGc+JKBMPKyFzEtQHAuPPE0OaHb7pFrr9D15aieUbqLfMPfNnnHN+Up29snaOB70nEJ9VygPtaH3d8bl5G3XSLCd3sbTtNVB+N9TGjUZEalXlTgUF3Q9RXY2H441wiVJfzG0/TZ2Ba9og0/v/v3tz5rD6VGHKvYnptzHUUcoaZIcYQZEwLvk9r0gkGFD7jYGeknZp3ZNCXf/A5i4wF2rnPHDEwjEHstNcJ81nSJ+p5oaZ47SYqhy2Fps4XNclGv5nqn8ItKe6bjLqw5csTyU8bdFqkAA5gnhL9831lKxWxhf/+tBGSFavsBBg48Z1QuxolugxBgYZeG/nu1+4na+V6fqn33+9urn5/a4Q0pZd5APe6Ak/hv5pvTyRRUuVVcLUiRDfWB0FeprCOjg1cJBRuwAA253BO0B+ZKUXm1Isr2NMQ2yvoRSse6Cw9unzQ2Y4Q/pYCGi5Oq8BEpHtCACS8OdD6VzRiJXO6pwspQL7IwlmwE
 afCGgaB8
 SIKrMgU0YZxNLUpg2bK15LudDVPL+QWdC4spcZo35zE18HkMK+Dnajh12OEi4Is0spLU/JECDU0KmFlaeyKRPnk8Cp7ICmnVlRKcnnsDNfIFV+9UhaIed9YAA0Rh0aZ4xpLt2aG9RpGjlmsZQ2onEX1vyL8+2xbmSBF/XuOuvaFXcFhhz4yglUvloeRxigbb7B7ONABUXxnU27/JbJiLKP8LVoJjxvBH/xDUAZDgWqabDZ1BwXLLB9BlEwIOpeHaBgSYKX3S1awjuQS19Trhce+YQHy/Nsv3jPMDA6Ay7TAQ5KDh8nYceATiUNyB6Kf3//DEOaH9txTdkUjv6g/qjinGZigJR00AnDPHrm+zF2k0Jw7314yRdVtCAguFCw/24T4uHdEdunxmB997tVDoAa90mot8otmzwM5viHW7KdMefZjtAZKoabHrpRNZA7/MXYGmXVKO4mzZngBh5GJplLTsbZh0aSaEMTF7QgvOVuQWCwCh2kjNbv4fcQeQO8KUSKyGYetSaTD55JQBD3V8YIR8bMM8ZZe+slfkATkTffJgxGunWYFySu7veqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   7d1a16abe4cc5dccd21e3d6262e44433a5885d27
commit: 7d1a16abe4cc5dccd21e3d6262e44433a5885d27 [327/327] mm: vmstat_kunit: add synthetic benchmark for mm stats
config: arm64-randconfig-r2305-20261121 (https://download.01.org/0day-ci/archive/20261121/20261121133112.48w1QOqw-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 15.3.0
sparse: v0.6.5-rc1-21-g84ec0658
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/20261121133112.48w1QOqw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261121133112.48w1QOqw-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/tests/vmstat_kunit.c: note: in included file (through include/linux/irqflags.h, include/linux/spinlock.h, include/linux/kref.h, include/kunit/test.h):
>> arch/arm64/include/asm/percpu.h:261:1: sparse: sparse: cast truncates bits from constant value (ffffffffffffd8f0 becomes f0)

vim +261 arch/arm64/include/asm/percpu.h

535fdfc5a22852 Catalin Marinas 2025-11-06  254  
535fdfc5a22852 Catalin Marinas 2025-11-06  255  /*
535fdfc5a22852 Catalin Marinas 2025-11-06  256   * Use value-returning atomics for CPU-local ops as they are more likely
535fdfc5a22852 Catalin Marinas 2025-11-06  257   * to execute "near" to the CPU (e.g. in L1$).
535fdfc5a22852 Catalin Marinas 2025-11-06  258   *
535fdfc5a22852 Catalin Marinas 2025-11-06  259   * https://lore.kernel.org/r/e7d539ed-ced0-4b96-8ecd-048a5b803b85@paulmck-laptop
535fdfc5a22852 Catalin Marinas 2025-11-06  260   */
535fdfc5a22852 Catalin Marinas 2025-11-06 @261  PERCPU_OP(add, add, ldadd)
535fdfc5a22852 Catalin Marinas 2025-11-06  262  PERCPU_OP(andnot, bic, ldclr)
535fdfc5a22852 Catalin Marinas 2025-11-06  263  PERCPU_OP(or, orr, ldset)
959bf2fd03b59f Will Deacon     2018-09-13  264  PERCPU_RET_OP(add, add, ldadd)
959bf2fd03b59f Will Deacon     2018-09-13  265  

:::::: The code at line 261 was first introduced by commit
:::::: 535fdfc5a228524552ee8810c9175e877e127c27 arm64: Use load LSE atomics for the non-return per-CPU atomic operations

:::::: TO: Catalin Marinas <catalin.marinas@arm.com>
:::::: CC: Will Deacon <will@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

