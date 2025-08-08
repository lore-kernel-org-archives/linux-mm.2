Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6DDC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 03:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D8A6B00AC; Thu,  7 Aug 2025 23:01:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9755D6B00AF; Thu,  7 Aug 2025 23:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B6D6B00B1; Thu,  7 Aug 2025 23:01:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75BAF6B00AC
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 23:01:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1861C12D3
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:01:20 +0000 (UTC)
X-FDA: 83752089120.07.A0EA2DB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2FBA31C000F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:01:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bCkDShTQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754622079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UHBoru6Eh9uQ2F6XVi6aENoMsAY6+l7pWimlOmxSUYs=;
	b=J1JWZIIklrxf3wbM6R+9e0iy1xOGUQsrssxMBMZYBA+5tgzE3ztAU2sCcn+6mOovQJTuMP
	XjIU4dWpnjqgRK/r70DShNhR3Cyz9u9RDynCFe6tEdWSP464l+JdDYKFrUFqTsyLKWD23X
	fb/FMBLmfRqXLRpv48mcxLSb6q4L8qw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754622079; a=rsa-sha256;
	cv=none;
	b=LwJGV/aNCtugoUWVC6R1NDyIMq42e+okwBOO8saZUS5CcCezyiw8oeKYtTFvaiqn57xJU3
	TzItE75Y8RWnxJD9OGkysG4SUiZZHVoOqxIZQRAaH25M6X0oVzCQFKapQCXVKx0iCWU9ST
	uFlK0C3tG9JNvtiGhNwqiukGVuL67QE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bCkDShTQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754622078; x=1786158078;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=b60/CoOL//mj++mvID67AOHok8MDp5SiHTET4znBFlQ=;
  b=bCkDShTQPvOyyK5KhCWZnKxsXEpuZ1Ou+sOxH9Y0VlQy+6/muduKKY/P
   VDm5Mpoc7WLGOga7aV456TaQIv6uNYv5eqg8ztTapO4q9+UJeT84MfqvQ
   e6fEzSXG69+qxgXzKOs3FI3VVNF85MRvwPB7FLPFQeBXhfY4NSDvhCuQG
   HENXJrmGouzQwOBEx9S7pyva2rYpQYno4BG+6czxTOUF3Ud+eOcwcWHGD
   4Tmk0l2ZypuBT3ZiSnQJp/Pz/q3ov8/xj+OXSzsf6gVGUR5OUpY+Qb7E1
   Yn767jZvHbKbCdRVW3rwE/bqzaAU/ArvgMpUhn4Ghi0CTWsWfnvkLm+rQ
   g==;
X-CSE-ConnectionGUID: Kn5v1qTCTX24bbOw/QjQ7A==
X-CSE-MsgGUID: u28YxHp5RIiNzEm6Ngv1gQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="74545074"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="74545074"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 20:01:16 -0700
X-CSE-ConnectionGUID: 8l5QFiXcS/iBs62m/c0nzw==
X-CSE-MsgGUID: BC6AixRRQHOEHG5ddz0DWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="170474024"
Received: from unknown (HELO b3b7d4258b7c) ([10.91.175.65])
  by fmviesa004.fm.intel.com with ESMTP; 07 Aug 2025 20:01:15 -0700
Received: from kbuild by b3b7d4258b7c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ukDM0-0002Zz-2x;
	Fri, 08 Aug 2025 03:01:12 +0000
Date: Fri, 8 Aug 2025 05:00:27 +0200
From: kernel test robot <lkp@intel.com>
To: Baoquan He <bhe@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [sj:mm-new 39/45]
 include/linux/atomic/atomic-arch-fallback.h:457:undefined reference to
 `kasan_flag_enabled'
Message-ID: <202508080510.f1wPsKSS-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 2FBA31C000F
X-Stat-Signature: pgxs445xijz1579kotoi49eecgqabo77
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754622077-787751
X-HE-Meta: U2FsdGVkX1+kDX+SZFyaDw0mtoVjQNVtpL27E1G3SIkLJUEs+jYrA6VTBNauR2SFaJzfVGaIDWcOdd7oqt2VECCwpOwlUQa5IGCDQbyUNAM6AKdtbHtYKFDzqK/88xGKJ2jYoaYHFEvZdt5T7ifOm5V0LJ+2I73Uxuca2+7n6Sz0n8F8LgGfPp9EIHAF9XVfIX12jzqZ+6B/T/uKU37xjVtf6mqmD1vB8NvMqGott99TGvlky30En9OMjhIpUtPgE1je0UMmn/Jw6kGPvpEkEFlBmcjHPm1Gn+Q5iQCOUAc3K1hK2ZPG52z25HWUHKhEqIij/StXbNWsJJRKaPoE+TlbglB9IrA5q4/S6pyplmvFUo0BnB/zEL92UTnzWuDHfWAEPa9xhbpVXdZB9k/wYATvOONqxJAi+fY54IghVSCkdqlPBBTXzepL7fvdCVMc+IPMRMo/lzuLE4xgD4q9mIYm+lMPrRipN2KN9Gf+OeL4iAkbq7G8NvtHXMJFa4tPK7A2MPAknzGSSJInpqaF0sgbT2WWstGTsJ/hu5rywKVUM8AhJBbrPcmBzDR8GW70uqA1wK7z3ykzCS0fIXwUG1hU6L53vSJZn3Igl5YdD/G7VCbwGgLfSB4qk2hxLcDSE7whZTkZ7CctSQt0HiEKBoXdpYAJL9Jq52OB/TQyyUPsfr0TMr4Pe75FoqkZLhDl1YsDLFBQiWzgL5GoVVMWbABWHyouz2UYP0lIAfO8oxj/hEuO3sJWZSFAeB0C/FhSyiXgbpAxu/SRR34Mvdw9qdLNDWWJA1HUWJmrQcPRcrM94qoBI8jP9G3EBgxvF2yWCLhriV3YuGDMBWxltA0vjDCF9tyLT5dusb3yffbVMfS9wLiz6TjVTuPJT2uEX6PL8uIc1JpuwGOEfKizXfMDGAaut0bH7s5JBs6qj56b5aHO90Ns4uojIEV3tz/ckeBoA1hxaqRwtDF2xa7Gjnj
 /eGN4ERM
 vIpTDieIDJejaJzljH+G7WSlk0LMSVX2uN0OFOes7Eqm51SFZ4emWinUU3YohUvJPwWr8py7M17+iC5e+NXoD7z7h5l+dGj/ZIrsQbye1fMO4HkR91ToJbfCUo2k4mL4c4xgUXSakcfaDuBXlVcxV58hNxje3nMFuCDlLwmbSO4AjKu4wJZwofroQHWXOxkgqrbv9gd6/lBYWFNMIwOKiSNtojVnEkMEo7Km2sGgynIWF9QrC+hcBPSVFnaUNtSU3KZLlZTkt6Ek+edl4+7O4BGIgUsOHDn6RfGpwEWcCla2BmNfNXG4lXspMCED8/G+1OtRkDqs6KoO/ewMA1EflD34Ce0UQhwz/MmnUSs/uD0hf92MV3zSDnBSunZvbLoevzxDurmIYMEFYQ2j6J+rlVq08m512tTW5Rd377mW5gKHY/vR4h0D4vPMjm6purBdiox2rFdrR14Y53rCHBkV+9Z+knHvh/iIAmkV5qoTVL0AcfZQ8TokLJjo7WC2FG+eMwt6JpxqoSLrxP63tigKPYE1fHFxTV4QUH77af/hbwL7QABF1teyLh5Z3In20Szl9Lddz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git mm-new
head:   b2a4beca30ba51331a16d7bb84387a70b692a66d
commit: 825af80daf827d439c7dd3e24ef5648cc338bc98 [39/45] mm/kasan: make kasan=on|off take effect for all three modes
config: alpha-randconfig-2003-20250808 (https://download.01.org/0day-ci/archive/20250808/202508080510.f1wPsKSS-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250808/202508080510.f1wPsKSS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508080510.f1wPsKSS-lkp@intel.com/

All errors (new ones prefixed by >>):

   alpha-linux-ld: mm/mempool.o: in function `raw_atomic_read':
>> include/linux/atomic/atomic-arch-fallback.h:457:(.text+0x544): undefined reference to `kasan_flag_enabled'
>> alpha-linux-ld: include/linux/atomic/atomic-arch-fallback.h:457:(.text+0x9a8): undefined reference to `kasan_flag_enabled'


vim +457 include/linux/atomic/atomic-arch-fallback.h

e01cc1e8c2ad73 Uros Bizjak  2023-09-25  443  
ad8110706f3811 Mark Rutland 2023-06-05  444  /**
ad8110706f3811 Mark Rutland 2023-06-05  445   * raw_atomic_read() - atomic load with relaxed ordering
ad8110706f3811 Mark Rutland 2023-06-05  446   * @v: pointer to atomic_t
ad8110706f3811 Mark Rutland 2023-06-05  447   *
ad8110706f3811 Mark Rutland 2023-06-05  448   * Atomically loads the value of @v with relaxed ordering.
ad8110706f3811 Mark Rutland 2023-06-05  449   *
ad8110706f3811 Mark Rutland 2023-06-05  450   * Safe to use in noinstr code; prefer atomic_read() elsewhere.
ad8110706f3811 Mark Rutland 2023-06-05  451   *
ad8110706f3811 Mark Rutland 2023-06-05  452   * Return: The value loaded from @v.
ad8110706f3811 Mark Rutland 2023-06-05  453   */
1d78814d41701c Mark Rutland 2023-06-05  454  static __always_inline int
1d78814d41701c Mark Rutland 2023-06-05  455  raw_atomic_read(const atomic_t *v)
1d78814d41701c Mark Rutland 2023-06-05  456  {
1d78814d41701c Mark Rutland 2023-06-05 @457  	return arch_atomic_read(v);
1d78814d41701c Mark Rutland 2023-06-05  458  }
9257959a6e5b4f Mark Rutland 2023-06-05  459  

:::::: The code at line 457 was first introduced by commit
:::::: 1d78814d41701c216e28fcf2656526146dec4a1a locking/atomic: scripts: simplify raw_atomic*() definitions

:::::: TO: Mark Rutland <mark.rutland@arm.com>
:::::: CC: Peter Zijlstra <peterz@infradead.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

