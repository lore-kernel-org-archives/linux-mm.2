Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1227CAC58E
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 23:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96B98E0005; Wed, 10 Sep 2025 19:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47368E0001; Wed, 10 Sep 2025 19:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5D4E8E0005; Wed, 10 Sep 2025 19:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 93CCC8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:48:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 213BB160346
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:48:24 +0000 (UTC)
X-FDA: 83874982128.13.9C16510
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8051340008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:48:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="OFe61/jJ";
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757548102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hTCbJp50CDuGepwoZgN1x22gWTHU/qw68Fa77nH3sbY=;
	b=DRCFWaHXA/wmG/HsJvZ69qEN1cMgg7Yo5onSyunhQdoAyrIReeFuQIrMs/yf7LrVvZ9Lo/
	JyMZDBPNoeaFOrxWzL7FXqMmOjNgZz/wSw2BSCgjkikKuJnwIFrtrFkN6GyM1iwlVQ+mFR
	ZHm1UJjhdDIVaidU1ZNQj2Vr96GNJhs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757548102; a=rsa-sha256;
	cv=none;
	b=YkBzSumsIEf0jxz0a8uhsDcVr/m8SCDubC2LR+cmsDQ4Kpt+4N0Pp0BQQhuScD5M6wAzfM
	O3ynngnHfL7NqT6jGh4u3INNV1iw1Hx50+He02vWA2yHIF9j0zCCet1ECPxyO3PXXpyuA9
	r0UEym3+lWw+4NRk8V16BYfH4zlI1+s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="OFe61/jJ";
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757548102; x=1789084102;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=QevkYdBoBhU9h0Su1WTXFTCspLRf/nkZqd0Hz2v7PTQ=;
  b=OFe61/jJ8WvhIZzPoZan8GiFWS/+Jbl9CuSZ2ciish8eg9/iFRXhg5g/
   yGgag3vYE2V62UrSFjAmv1dh1Bo8lIZsTHlcMHhoGPwjOYyhDonKfjGjP
   79mjIGvvPhbjaBMhT35nkh79DPFPOXXk68lAD/833V0b8u+pXLLBjAsbR
   tS+c452ei2ItkXQc2dlJnaig5vunHnqyHBCgS11BTkb7MSdme0Y9m5cuK
   cyv+Y42yn/tokG4k3F1Gi3xH1wfDYvwbYv/c6WRfcTZyHzXAi2i2J0Fdz
   /IaBvXg5zYmPQpejxfAZiZcGaLwBBq864x34cQjzsN+OdIvmvNIW+2akQ
   w==;
X-CSE-ConnectionGUID: ksGepAGAQ2Ktn5ZE4kPiSg==
X-CSE-MsgGUID: rAB3YW/LQ7OZ34hB2JA+Dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="59096119"
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="59096119"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 16:48:20 -0700
X-CSE-ConnectionGUID: Br/0NSeFQvyA2Rjiu9jDGQ==
X-CSE-MsgGUID: HJMU+u4lRtuHLlj7DC1skQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="173602472"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 10 Sep 2025 16:48:18 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uwUXv-0006Mp-1F;
	Wed, 10 Sep 2025 23:48:15 +0000
Date: Thu, 11 Sep 2025 07:47:30 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 400/411] include/linux/compiler_types.h:572:38:
 error: call to '__compiletime_assert_486' declared with attribute error:
 BUILD_BUG failed
Message-ID: <202509110742.wWjLDz1Q-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 3jdttoe9ubthwpum449n8x31d4rypa3c
X-Rspamd-Queue-Id: 8051340008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757548101-152677
X-HE-Meta: U2FsdGVkX1/ECfPRugJ2ylgXu1H4VGOmOQC0GIJQ6JSHhPtqQ6QJtSNYufrcGGC2bRCgKyNAAdYarcMthzT0YSBbF4lp6RXASaprcLknbetHF+HWoO3L+ir3ZlkumX/kSFDpl17Qt58kz0aP58F2PLD7iRBo0ovayrmq0njIMH2/IcC4aCUX3BMmdyVTe3W0ckGUw2SorSlu03VJ81sHMpm9/yKTPaUhViUUwHcV2RnyPxCcVYPlyOM4tAm7G5zQl4p0J3FMVbmKvVuo8hu6qdSwo2vOLH86XtHo+aUO3nrxOsVc2rewVlc3a1SdeVCkNF4RxNogAkQvH3AWcq1szPWZGKL7WBSUE7HphXrn7RoSMS3o3Dwa5d2iSKorqCUox+Io1Jy7b+G13VktMAJWaIeSG96H/4cNNHf44ybyfo7fmBILNIri53cr0irSigg/44eV3aG7lQvdgpFvuCG6aAN2rROrMvPDYB+MjZTYNQRljreyI7nMcOD6mWiBxkhJm4ItqukxH8UCxtCGF0hBDJjDHvPGCZ0ySgqPgiPT0NbZ8VIEqpBmbWSsfASv61oj1UYOo6ki6xCpqfJxIBgfV200cE82Ma42R3+qN4gR/00VU3oadSFYAFoVZlj92EOPEdYJihWWWXcOKa8Bs7y+orLE+G6W0OtL2MWGsdZ2f+LxURIXgOGZCYu2IW5gqDdI+HVhlCN7mhqmjMzwGoykaGaWGYj8qTem72vRPNTTF/qMXd+FrWzzSy/aCzANoHRnaDP+sgetOk+xI1ndoP56g6vp5STPXK9qRProPjx8M3pUODmZuFLofmFRutxNT2cKGHYvymq1M4n8VZqbdxCduep1e0O9mQ8mjGYhB73L5X/06XkQiLU6nxr556kmt34cOC426Ung8Ld7w3rLs69gvFTqu6P3ynjMjr+lZk2EMmADCGB1V5Sto10aoZzWSgnMa3z48LWhIeEeBAYtBET
 q5e/Zh5C
 6iNDQ4a9LDaEbucncVjuQkxe4X+pHrtCBAeCJS665Jmaf3Z8dpDNSHxlF9bpP9/sJokmzYgw1wfhL8DMFdkB9crSLZ6q7sxq2+pJjkpTCUDZvY3KNN0sF8qyGcQtHbcsAlRrtZaaxl4nV/3pS7VyAVuIg3tzVB1uJZ+tyiu8yaFebiWCcynvtZz2v6idwfGCNQqxYn6CbwGQQ+qyt09ebwuCBQsUjemHEdgzSUaJ1PDPLV3AX44z749oi7PGkSybj73uxJP/UxCP5K5v4x9/h8n+jA+sK7+DOi2as/+q+ibxuj96A7SL4uZOw8LX7gQWlu+9ryNEYqit0HegBFGdLTcRa3RrefzpYi5fLJ3ZvvubH9+LRhbV6wkq7zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   3a0afa6640282ff559b6f4ff432cffc3ecc2bc77
commit: 5e59d4de7ff923ce84158f3357c4e964d2ec46af [400/411] mm/migrate_device: implement THP migration of zone device pages
config: powerpc64-randconfig-003-20250911 (https://download.01.org/0day-ci/archive/20250911/202509110742.wWjLDz1Q-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250911/202509110742.wWjLDz1Q-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509110742.wWjLDz1Q-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   mm/migrate_device.c: In function '__migrate_device_pages':
>> include/linux/compiler_types.h:572:38: error: call to '__compiletime_assert_486' declared with attribute error: BUILD_BUG failed
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/compiler_types.h:553:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler_types.h:572:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:59:21: note: in expansion of macro 'BUILD_BUG_ON_MSG'
    #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
                        ^~~~~~~~~~~~~~~~
   include/linux/huge_mm.h:113:28: note: in expansion of macro 'BUILD_BUG'
    #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
                               ^~~~~~~~~
   include/linux/huge_mm.h:117:26: note: in expansion of macro 'HPAGE_PMD_SHIFT'
    #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
                             ^~~~~~~~~~~~~~~
   include/linux/huge_mm.h:118:26: note: in expansion of macro 'HPAGE_PMD_ORDER'
    #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
                             ^~~~~~~~~~~~~~~
   mm/migrate_device.c:1101:10: note: in expansion of macro 'HPAGE_PMD_NR'
        nr = HPAGE_PMD_NR;
             ^~~~~~~~~~~~


vim +/__compiletime_assert_486 +572 include/linux/compiler_types.h

eb5c2d4b45e3d2d Will Deacon 2020-07-21  558  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  559  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21  560  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  561  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  562  /**
eb5c2d4b45e3d2d Will Deacon 2020-07-21  563   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  564   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2d Will Deacon 2020-07-21  565   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  566   *
eb5c2d4b45e3d2d Will Deacon 2020-07-21  567   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  568   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  569   * compiler has support to do so.
eb5c2d4b45e3d2d Will Deacon 2020-07-21  570   */
eb5c2d4b45e3d2d Will Deacon 2020-07-21  571  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21 @572  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  573  

:::::: The code at line 572 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

