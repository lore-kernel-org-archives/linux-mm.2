Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE013CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 16:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6083C90025C; Fri, 15 Aug 2025 12:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E03B900256; Fri, 15 Aug 2025 12:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E2990025C; Fri, 15 Aug 2025 12:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF8F900256
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:51:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E65701A0215
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:51:19 +0000 (UTC)
X-FDA: 83779582278.17.B552B42
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id A73F580009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:51:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YeD2g1yb;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755276678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iZHrHiuqQeD6+PZiIYH7jOWULczdLFN1tp692+CFSi4=;
	b=3e0yP6cRtqzffQtuRfWYig8HydAclKnrxquR+efPpJKM8j9VB6H/bSn/2sSfz88VLLKV18
	fBczfPlFq2DxWqZJd0vlfSk6FUqJKmXLHgW/vhZYvTG6WaQgg6yuMLQMpuCevqC0AqWH8V
	DQ2vfhHgfCvvzKQ0x7lTIoucGYBzDYc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YeD2g1yb;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755276678; a=rsa-sha256;
	cv=none;
	b=cN8cFO3u4cqnqIVuFpGCPLTXFrm9txyQTikwuw+KKujCeRiLHMg6fePSUUzBkdevLMCOQI
	sAUkQerfFD5vlfecbYP5Jz/LQ4I7bHPMLde3UZLwXYFhCx3QNA8NeXWegbua8eGZ2YG0Xf
	8zqNdlwSQIM+lX2HXZFd0+xhhz4sn0c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755276678; x=1786812678;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=7NTaViNVxaMYuQr9mTPMGMMhBcYakL9cKYcXpQrkLF8=;
  b=YeD2g1ybuG5de1a3FTlGvVKBQNBWd5FR0NRh5KsOGrLB3NVY/ngTNsv7
   qjei+zXuuee9IhZwICTjcSauijQVd4NHpl1tXMyi7YeAixUYqmnNVPxkG
   yYYbQd/DJqat7XtGZyhP02+Ue9MUjhfOCwuVNlF3a33bdyBQPth7nYpmZ
   rWnCxkyoiGbcXAPCwB305wB9/3g50uZg98vCSyWuSQqfPIIN9M5f8UpQx
   1FIp8ETUGbUMjYhgTqHrvGZ5r3zTrxdfb61cq1y3GED/OPUvLf9ibKMAz
   8dinYb3qup+WOsB3SuJJ2zWu+1it8YnMhuOtaeqt8itHKdlkM1kQL/xrn
   g==;
X-CSE-ConnectionGUID: LDchbIjdR12GZYB0XEuaXg==
X-CSE-MsgGUID: /gN3mUt5RtCYd4FjGzzadA==
X-IronPort-AV: E=McAfee;i="6800,10657,11523"; a="61410966"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="61410966"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 09:51:16 -0700
X-CSE-ConnectionGUID: 6CrZOOFpQpacTi1bb2gudg==
X-CSE-MsgGUID: f2Oz+VuMTO6WqnQkxAeCbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="166543218"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 15 Aug 2025 09:51:14 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umxdM-000C8S-06;
	Fri, 15 Aug 2025 16:50:53 +0000
Date: Sat, 16 Aug 2025 00:50:02 +0800
From: kernel test robot <lkp@intel.com>
To: Rohan McLure <rmclure@linux.ibm.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: [akpm-mm:mm-new 136/142] include/linux/compiler_types.h:572:38:
 error: call to '__compiletime_assert_352' declared with attribute error:
 BUILD_BUG failed
Message-ID: <202508160059.Aj29DucC-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A73F580009
X-Stat-Signature: 7gyp79fmmazx9wnjfgg1sg3587hwqpem
X-Rspam-User: 
X-HE-Tag: 1755276677-375660
X-HE-Meta: U2FsdGVkX18BdcWxbUSeS3rHrpd6zPhG5m9FyyN6PVW9ho3gkTzyqfJovFq7ynCOwdsuxZz1214kNoi9OqHdwy2fjBbTVB9kM4nCDHaqGwahZS/zg/z0b+IHPzMwOKihX1Yog+XOiWaTh9XMB+G0KZ8iUN3YkG+ruPbu//4qBbpWdKD7c0dqZ1Aj7Hqxf4sh3CNI04wiAp6SzoWXXyyIWxnBPr4egvoSvDGjU5RYt4NIfVRONSZpfnc9mTx38+XIweCMYCTSWqpbgieznTTchI1rIfkC54pdhIfuIpAUkRj1qqaTv5ewXEfxaz5rfgJnZ3vez1kXZ9FBHdJEfGr2l5Duf4qYKnP0fFQSIiFciJ3+WY5fiVW9MMY8mBmnaRqoJTUzATG4JvS6Slwq5hqnGF3S1EAe74k5JJjJXKMX0dwXw9S74C4mgrAQS4Cn0nOne3XrWmAjrkPLWjQIKS5xF0sTXGLfZEQei6bYvvmNN/7PlI0cHDtruwcveEFdZisC8/6VOPK8ebdr7TfymcJ2V+LRdJG3DX8jna9w08Tz+1fd53ZVEbWDOn6bdo96z9i6vKmizlR5dvtNAQ2bgUKy3HUl/ggxnADkjHel1M3Cos/QKikdJ3QuTR+ssHITwrxmL0QsYvpwjGfq+k8etKAwVn08FnJ5qA0vFJdxoUSa5mSGJ6Mfto/tfLE5InSNZMT/d8ei1TKLRmS3G1nz06/sLFm1LSDh3PG+Bp4Nh4qio0LmgkpseJrL3UNPZ3P3KwpSyoZdt1+BkXI+uSrNbHLNFbTtj2WVala+Le5l9l+jwuztyQ4uVFQjFhFdNo0UMWSF58BTDwCIXsOxQkO/EZY/PPCmmHHbzBv8J9JxJtwBiTN+TAPyW3QX6l9L1r/nu17otEpt0B91+dMc3rlH31/QWaq8veiuvIRMD/wBHt9Kdz1mVnmUcEXe15s4XOJO/KoFfRzCc2TrTME5o7Bet5t
 bS31qSwX
 2yq3Gg/fBlfnE0d5DoEFq36yo8h2l0MDXpli1Pp7M864e5Xl1DPfkx/kfmylOlJ8O5aMOrfIGmcNmKDZ7cU53S7PQYRhLElerx8Td3/QDNJnLsfBWqpVN1pAQiJ8F1NoswNWbO9f6HwoklHaFL18SRd5QJpPcrvfFWHXqPFhdkp1Lt0sMibN0g4KHssgFZWNA35P214T1EbHP8HvbHPBsvCcnNJUtbetqD08AT5SWAs79CJP+jK7jQs75Ye4NzrguQWEbT5sdhIiyXp/thocRylMTt9TGnqzpHGW1eH9x1U91CUBwKjLIB7aWZ/sh8Q6Xtv+PLnS17SzPOafssiDd/JcgLZS0KRIz/agqfZoZLaC+ZzFxor7yDa0q1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   916e1f0416709c79737776abd5283cb27a5da908
commit: 119a909df9ee611b1656fa9cbdefa9ea68032048 [136/142] powerpc: mm: add pud_pfn() stub
config: powerpc64-randconfig-002-20250815 (https://download.01.org/0day-ci/archive/20250816/202508160059.Aj29DucC-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250816/202508160059.Aj29DucC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508160059.Aj29DucC-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'pud_pfn',
       inlined from 'follow_pfnmap_start' at mm/memory.c:6695:7:
>> include/linux/compiler_types.h:572:38: error: call to '__compiletime_assert_352' declared with attribute error: BUILD_BUG failed
     572 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                      ^
   include/linux/compiler_types.h:553:4: note: in definition of macro '__compiletime_assert'
     553 |    prefix ## suffix();    \
         |    ^~~~~~
   include/linux/compiler_types.h:572:2: note: in expansion of macro '_compiletime_assert'
     572 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:59:21: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      59 | #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
         |                     ^~~~~~~~~~~~~~~~
   arch/powerpc/include/asm/pgtable.h:221:2: note: in expansion of macro 'BUILD_BUG'
     221 |  BUILD_BUG();
         |  ^~~~~~~~~


vim +/__compiletime_assert_352 +572 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  558  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  559  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  560  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  561  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  562  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  563   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  564   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  565   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  566   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  567   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  568   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  569   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  570   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  571  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @572  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  573  

:::::: The code at line 572 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

