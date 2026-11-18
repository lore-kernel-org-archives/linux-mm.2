Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51346606B56D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=XkAbxRuI
Received: by kanga.kvack.org (Postfix)
	id 129576B05B1; Wed, 18 Nov 2026 11:30:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DBA96B05B2; Wed, 18 Nov 2026 11:30:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34686B05B5; Wed, 18 Nov 2026 11:30:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A51246B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:30:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC80BA0819
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:30:45 +0000 (UTC)
X-FDA: 85448778450.19.574C54D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id CCF6280002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:30:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XkAbxRuI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795019444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=L/Svui1qVLq5GafgKOc9LGyC6Wf42oJCCy5o0NvmvQg=;
	b=15urZRQiNhMCYOh+pMqz3qKYBUsDXr0KNn7eJk5+MbseQ8m1+B4d1dk/NPN1cFAtd6PVU+
	oUHmoLppU/Ro+K48qY+qYI9DYtExqwSZDFMNeypEvQetOdkV0v5qDIE3w/ZCL7VSVjw97I
	xefXZB0y4oqoj74eu6JqpbDeo+QsyWE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795019444;
	b=PvFbnSPsXaPycp4qtLcjsXiVKCmv2Z+hs4W0fBxGxL8z9iYIwaLlRYk5AqKvRVje41btZ0
	jDWSWYONaOVNCWZuFzEZT7I3+XJthjCo5hP3h4Ag2cuo4hvY+pVd7vwvoG+ZFQJh/vsuuG
	4TZKBmeRyK/H3uMnwbc4vpnw7JVqUJU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XkAbxRuI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795019443; x=1826555443;
  h=date:from:to:cc:subject:message-id;
  bh=wPGQiFmq9LUhG+61u9LboJAEyCif1cmHjg1bNs4rHtU=;
  b=XkAbxRuI+23mNeoRZccyeZHX193dENpyk9/2jyUQskXvD69bFgw3o1+p
   FYkmEdroHQqjYskI/R7hFTeYm17Ju/gPv326ektwgkT3p/Y7cc2BtrAVa
   WPbPfkI3a/oPv5coh5rwwpYnVXvrO1J8jMUKwUjHAdERFVtZ0UYjb/ojR
   /EGHIHL/y7hjNm4SBHs/dOMHKFM7HXqCHVVp90fJeL454wQcIN7ZEKshd
   u+8iHNc2wbzea1wfvWYHy6PMKiFb+h0T5yeF5Gf7qyoB9ipip+pLxEOje
   31mGLM4sDk5GEqv6xUYoGLqAY+Ynnn2gzemHas0niO69pguFQoTGR4Nie
   w==;
X-CSE-ConnectionGUID: lZa+E4XIR8WDlnWzPuvbEA==
X-CSE-MsgGUID: Jf7QezSeTx2jRK1U62ma+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11970"; a="3731454"
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="3731454"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 08:30:41 -0800
X-CSE-ConnectionGUID: NsPa0Th7QVi3sjM0CEQCcw==
X-CSE-MsgGUID: GzNZpRtIR3ewdp9X7jKnyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="10091886"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 18 Nov 2026 08:30:40 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xTiYP-00000001DrQ-1u1n;
	Wed, 18 Nov 2026 16:30:37 +0000
Date: Thu, 19 Nov 2026 00:30:16 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 25fee5b1762b8799dd8b72c2f6d666eb01680cc7
Message-ID: <20261119003016.UVcJ2gnE-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CCF6280002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3k7bewih9b3873s1euby411emqppsswt
X-Rspam-User: 
X-HE-Tag: 1795019442-94022
X-HE-Meta: U2FsdGVkX1+wYg1FaojntUZT21a07RBeIO+eSo3CchhHl/arLyTWHXZJdvUbQQWWpWC6G6lcpWhLDnWJBlvKhrZx19f2Zq7O+nevdUkRIOhgdPSk7pj1vn4GlDUFLuaYnxdUeUi6uoBW9arJfJG5W1IiTk/dlSbS27t9FpIbA305wj7j7j3raj0DKKzCz7NHFJKwrWp2RXvKl+8zArMIWTQXEo3P9FWvqg25yzoraT2wk1MbJS0RCBROYEpCsEp6KPsdgLENvNkSK7y6YrFy6F0sb18nrAcE6GPGAoo/Ge/n07GWrz6N0zyGLCM9IJxRgkhPzavy77TUN2QCXNrehpmkg7AMtAPjXcQnx3BmydT8YvA7cN70ZUgCowDsA8I2+Er2tARkVW8NjC/P1nu613gI07p+cMTTke/M+D2AgiBEhsGanrctNg/IkR+/Oq0P8SbYQuHGYmPzr/dm3ZIeOQjsNWVK3mT0AGv188NU7j4xhJzupCVR4wB2lPJt+++AJiOftycjMyfpD5tScaZ6lLnlGrMd0tVf9G73ZtCxtkMt34cz38ieCNc68++tyYTsm3NpUDJGskWUkhg/wlPNoK2+YJlDBcbfh6gaSgDz5L0aeMt2vu8fdfS0GgDsivl4w+wE8WzUsYUJCUhgZAK4HQRI/Rd/LhTMqI5Zf6rX5HiP9nlGTdS+JbBjyD4e6R8Fc/wL1Lm6lVbUOVs3eyts2jxkr+iM7sH1p8x2AdJBCnz1qC+bOOGjsw4J6E/BdG4rRbol08kUb/oz6kg5QEZECs5r9u5UiQ8XgR8v4xrAMl/GrtAd5x0qT6BPgwpAStb9ElelbsVse+VnGW23GqasgUIfVhruX6FNfy0PBpGgVE18r8b8Ee8B9uL9nfYNHVhGkrkdDWNnR4sBjTQIEQ9nNk1hcpV7H/oBo+h6sbjQWgSDlmNFAdoSeD/JvCQjqQAfJungbGoXd3lKdiVk/mR
 1D4rb+i5
 fmda68bcqtqUIsfuOV6oBs636BElxdAbW+OjRkjpFvMp+1bgMVpp2/BO2OZa/7dhJ5WkgN0lzZx7EGWH/y7uA1gr1lwE9zOruMz/OaUSg81q6ef2Ba0fn0TvmrMajzjho6iukIiwKJD5RDawdt2SWjEQZYbJOo4MPH/SImBxUdHyqb4yjsBPkS1Z3imfy3dVl4H4trxFbg1/Z/Uw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 25fee5b1762b8799dd8b72c2f6d666eb01680cc7  mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT

elapsed time: 1141m

configs tested: 429
configs skipped: 12

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261118    gcc-16.2.0
alpha                 randconfig-2001-20261118    gcc-16.2.0
alpha                 randconfig-2200-20261117    gcc-8.5.0  smatch
alpha                 randconfig-2200-20261118    gcc-13.5.0 smatch
alpha                randconfig-r2100-20261118    gcc-13.5.0 cocci
alpha                randconfig-r2101-20261118    clang-22   cocci
alpha                randconfig-r2101-20261118    gcc-13.5.0 cocci
alpha                randconfig-r2103-20261118    gcc-13.5.0 cocci
alpha                randconfig-r2104-20261118    gcc-13.5.0 cocci
alpha                randconfig-r2109-20261117    gcc-14.4.0 cocci
alpha                randconfig-r2303-20261118    gcc-16.2.0 sparse
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261118    gcc-16.2.0
arc                   randconfig-1001-20261118    gcc-8.5.0
arc                   randconfig-2000-20261117    gcc-12.5.0
arc                   randconfig-2000-20261118    gcc-11.5.0
arc                   randconfig-2001-20261117    gcc-14.4.0
arc                   randconfig-2001-20261118    gcc-11.5.0
arc                   randconfig-2002-20261117    gcc-16.2.0
arc                   randconfig-2002-20261118    gcc-11.5.0
arc                   randconfig-2003-20261117    gcc-8.5.0
arc                   randconfig-2003-20261118    gcc-11.5.0
arc                   randconfig-2004-20261117    gcc-16.2.0
arc                   randconfig-2004-20261118    gcc-11.5.0
arc                   randconfig-2005-20261117    gcc-10.5.0
arc                   randconfig-2005-20261118    gcc-11.5.0
arc                   randconfig-2200-20261117    gcc-8.5.0  smatch
arc                   randconfig-2200-20261118    gcc-9.5.0  smatch
arc                  randconfig-r2107-20261117    gcc-8.5.0  cocci
arc                  randconfig-r2302-20261117    gcc-16.2.0 sparse
arm                                allnoconfig    clang-17
arm                               allyesconfig    gcc-16.2.0
arm                          assabet_defconfig    clang-22
arm                                  defconfig    clang-24
arm                   randconfig-1000-20261118    gcc-8.5.0
arm                   randconfig-1001-20261118    gcc-8.5.0
arm                   randconfig-1002-20261118    gcc-10.5.0
arm                   randconfig-1003-20261118    gcc-8.5.0
arm                   randconfig-2000-20261117    gcc-10.5.0
arm                   randconfig-2000-20261118    gcc-13.5.0
arm                   randconfig-2001-20261117    gcc-10.5.0
arm                   randconfig-2001-20261117    gcc-12.5.0
arm                   randconfig-2001-20261118    gcc-13.5.0
arm                   randconfig-2002-20261117    gcc-10.5.0
arm                   randconfig-2002-20261118    gcc-13.5.0
arm                   randconfig-2200-20261118    gcc-8.5.0  smatch
arm                  randconfig-r2105-20261118    clang-24   cocci
arm                  randconfig-r2309-20261117    gcc-11.5.0 sparse
arm                            sunxi_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261118    clang-17
arm64                 randconfig-1001-20261118    gcc-13.5.0
arm64                 randconfig-1002-20261118    clang-18
arm64                 randconfig-1003-20261118    gcc-13.5.0
arm64                 randconfig-2000-20261117    gcc-10.5.0
arm64                 randconfig-2000-20261117    gcc-15.3.0
arm64                 randconfig-2000-20261118    gcc-13.5.0
arm64                 randconfig-2001-20261117    clang-21
arm64                 randconfig-2001-20261117    gcc-10.5.0
arm64                 randconfig-2001-20261118    gcc-13.5.0
arm64                 randconfig-2002-20261117    gcc-10.5.0
arm64                 randconfig-2002-20261117    gcc-15.3.0
arm64                 randconfig-2002-20261118    gcc-13.5.0
arm64                 randconfig-2200-20261118    clang-24   smatch
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261118    gcc-16.2.0
csky                  randconfig-1001-20261118    gcc-16.2.0
csky                  randconfig-2000-20261117    gcc-16.2.0
csky                  randconfig-2000-20261118    gcc-16.2.0
csky                  randconfig-2001-20261117    gcc-16.2.0
csky                  randconfig-2001-20261118    gcc-16.2.0
csky                  randconfig-2200-20261117    gcc-14.4.0 smatch
csky                  randconfig-2200-20261118    gcc-16.2.0 smatch
csky                 randconfig-r2101-20261118    clang-24   cocci
csky                 randconfig-r2104-20261118    clang-24   cocci
csky                 randconfig-r2300-20261118    gcc-16.2.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                            allnoconfig    clang-24
hexagon                              defconfig    clang-24
hexagon               randconfig-1000-20261118    clang-24
hexagon               randconfig-1001-20261118    clang-22
hexagon               randconfig-2000-20261117    gcc-16.2.0
hexagon               randconfig-2000-20261118    gcc-16.2.0
hexagon               randconfig-2001-20261117    gcc-16.2.0
hexagon               randconfig-2001-20261118    gcc-16.2.0
hexagon               randconfig-2200-20261117    clang-17   smatch
hexagon               randconfig-2200-20261118    clang-20   smatch
hexagon              randconfig-r2105-20261118    clang-22   cocci
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386        buildonly-randconfig-1000-20261118    gcc-12
i386        buildonly-randconfig-1001-20261118    gcc-14
i386        buildonly-randconfig-1002-20261118    clang-22
i386        buildonly-randconfig-1003-20261118    gcc-14
i386        buildonly-randconfig-1004-20261118    clang-22
i386        buildonly-randconfig-1005-20261118    gcc-14
i386                                 defconfig    clang-22
i386                  randconfig-1007-20261118    clang-22
i386                  randconfig-1008-20261118    clang-22
i386                  randconfig-1009-20261118    gcc-14
i386                  randconfig-1010-20261118    clang-22
i386                  randconfig-1011-20261118    gcc-14
i386                  randconfig-1012-20261118    clang-22
i386                  randconfig-1013-20261118    clang-22
i386                  randconfig-2000-20261117    clang-22
i386                  randconfig-2000-20261118    gcc-14
i386                  randconfig-2001-20261117    clang-22
i386                  randconfig-2001-20261118    gcc-14
i386                  randconfig-2002-20261117    clang-22
i386                  randconfig-2002-20261118    gcc-14
i386                  randconfig-2003-20261117    clang-22
i386                  randconfig-2003-20261118    gcc-14
i386                  randconfig-2004-20261117    clang-22
i386                  randconfig-2004-20261118    gcc-14
i386                  randconfig-2005-20261117    clang-22
i386                  randconfig-2005-20261118    gcc-14
i386                  randconfig-2100-20261117    clang-22   cocci
i386                  randconfig-2100-20261118    gcc-14     cocci
i386                  randconfig-2101-20261117    clang-22   cocci
i386                  randconfig-2101-20261118    gcc-14     cocci
i386                  randconfig-2102-20261117    clang-22   cocci
i386                  randconfig-2102-20261118    gcc-14     cocci
i386                  randconfig-2103-20261117    clang-22   cocci
i386                  randconfig-2103-20261118    gcc-14     cocci
i386                  randconfig-2104-20261117    clang-22   cocci
i386                  randconfig-2104-20261118    gcc-14     cocci
i386                  randconfig-2105-20261117    clang-22   cocci
i386                  randconfig-2105-20261118    gcc-14     cocci
i386                  randconfig-2200-20261118    gcc-13     smatch
i386                  randconfig-2300-20261117    clang-22   sparse
i386                  randconfig-2301-20261117    clang-22   sparse
i386                  randconfig-2302-20261117    clang-22   sparse
i386                 randconfig-r2110-20261118    clang-24   cocci
i386                 randconfig-r2311-20261117    clang-22   sparse
loongarch                         allmodconfig    clang-19
loongarch                          allnoconfig    clang-20
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261118    gcc-16.2.0
loongarch             randconfig-1001-20261118    clang-20
loongarch             randconfig-2000-20261117    gcc-8.5.0
loongarch             randconfig-2000-20261118    gcc-11.5.0
loongarch             randconfig-2001-20261117    gcc-8.5.0
loongarch             randconfig-2001-20261118    gcc-11.5.0
loongarch             randconfig-2200-20261117    gcc-13.5.0 smatch
loongarch             randconfig-2200-20261118    gcc-16.2.0 smatch
loongarch            randconfig-r2304-20261117    gcc-16.2.0 sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    gcc-16.2.0
m68k                         m5407c3_defconfig    gcc-16.2.0
m68k                          nettel_defconfig    gcc-16.2.0
m68k                  randconfig-2000-20261118    gcc-16.2.0
m68k                  randconfig-2001-20261118    gcc-16.2.0
m68k                  randconfig-2200-20261118    gcc-12.5.0 smatch
m68k                 randconfig-r2105-20261118    gcc-13.5.0 cocci
m68k                 randconfig-r2301-20261117    gcc-16.2.0 sparse
m68k                 randconfig-r2307-20261117    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    gcc-16.2.0
microblaze            randconfig-2000-20261118    gcc-16.2.0
microblaze            randconfig-2001-20261118    gcc-16.2.0
microblaze            randconfig-2200-20261117    gcc-14.4.0 smatch
microblaze            randconfig-2200-20261118    gcc-13.5.0 smatch
microblaze           randconfig-r2106-20261118    clang-24   cocci
microblaze           randconfig-r2107-20261117    gcc-8.5.0  cocci
microblaze           randconfig-r2109-20261118    clang-24   cocci
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                  randconfig-2000-20261118    gcc-15.3.0
mips                  randconfig-2001-20261118    gcc-15.3.0
mips                  randconfig-2002-20261118    gcc-15.3.0
mips                  randconfig-2200-20261117    clang-24   smatch
mips                  randconfig-2200-20261118    clang-24   smatch
mips                 randconfig-r2100-20261118    clang-24   cocci
mips                 randconfig-r2102-20261118    clang-24   cocci
mips                 randconfig-r2108-20261117    clang-17   cocci
mips                 randconfig-r2109-20261117    gcc-8.5.0  cocci
mips                 randconfig-r2111-20261117    clang-24   cocci
mips                          rt305x_defconfig    clang-17
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    gcc-11.5.0
nios2                 randconfig-1000-20261118    gcc-11.5.0
nios2                 randconfig-1001-20261118    gcc-8.5.0
nios2                 randconfig-2000-20261117    gcc-8.5.0
nios2                 randconfig-2000-20261118    gcc-11.5.0
nios2                 randconfig-2001-20261117    gcc-8.5.0
nios2                 randconfig-2001-20261118    gcc-11.5.0
nios2                 randconfig-2200-20261117    gcc-11.5.0 smatch
nios2                 randconfig-2200-20261118    gcc-8.5.0  smatch
nios2                randconfig-r2107-20261118    clang-24   cocci
nios2                randconfig-r2304-20261118    gcc-16.2.0 sparse
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    gcc-16.2.0
openrisc          de0_nano_multicore_defconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261118    gcc-15.3.0
openrisc              randconfig-2001-20261118    gcc-15.3.0
openrisc              randconfig-2002-20261118    gcc-15.3.0
openrisc              randconfig-2200-20261117    gcc-16.2.0 smatch
openrisc             randconfig-r2310-20261117    gcc-10.5.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261118    gcc-8.5.0
parisc                randconfig-1001-20261118    gcc-12.5.0
parisc                randconfig-2000-20261117    gcc-8.5.0
parisc                randconfig-2000-20261118    gcc-11.5.0
parisc                randconfig-2001-20261117    gcc-8.5.0
parisc                randconfig-2001-20261118    gcc-11.5.0
parisc                randconfig-2200-20261117    gcc-8.5.0  smatch
parisc                randconfig-2200-20261118    gcc-11.5.0 smatch
parisc               randconfig-r2110-20261117    gcc-8.5.0  cocci
parisc               randconfig-r2308-20261117    gcc-8.5.0  sparse
parisc64                             defconfig    gcc-16.2.0
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261118    clang-24
powerpc               randconfig-1001-20261118    clang-24
powerpc               randconfig-2000-20261117    gcc-8.5.0
powerpc               randconfig-2000-20261118    clang-21
powerpc               randconfig-2001-20261117    gcc-8.5.0
powerpc               randconfig-2001-20261118    clang-21
powerpc               randconfig-2002-20261117    gcc-8.5.0
powerpc               randconfig-2002-20261118    clang-21
powerpc               randconfig-2200-20261117    gcc-8.5.0  smatch
powerpc               randconfig-2200-20261118    clang-24   smatch
powerpc              randconfig-r2102-20261118    clang-22   cocci
powerpc              randconfig-r2108-20261118    clang-24   cocci
powerpc                      redwood_defconfig    clang-24
powerpc64             randconfig-1000-20261118    gcc-11.5.0
powerpc64             randconfig-1001-20261118    clang-24
powerpc64             randconfig-2000-20261117    gcc-8.5.0
powerpc64             randconfig-2000-20261118    clang-21
powerpc64             randconfig-2001-20261117    gcc-8.5.0
powerpc64             randconfig-2001-20261118    clang-21
powerpc64             randconfig-2002-20261117    gcc-8.5.0
powerpc64             randconfig-2002-20261118    clang-21
powerpc64             randconfig-2200-20261117    gcc-8.5.0  smatch
powerpc64             randconfig-2200-20261118    clang-24   smatch
powerpc64            randconfig-r2306-20261117    clang-24   sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    clang-24
riscv                     nommu_k210_defconfig    clang-24
riscv                 randconfig-1000-20261118    gcc-13.5.0
riscv                 randconfig-1001-20261118    gcc-11.5.0
riscv                 randconfig-2000-20261117    gcc-11.5.0
riscv                 randconfig-2000-20261118    gcc-8.5.0
riscv                 randconfig-2001-20261117    gcc-11.5.0
riscv                 randconfig-2001-20261118    gcc-8.5.0
riscv                 randconfig-2002-20261117    gcc-11.5.0
riscv                 randconfig-2002-20261118    gcc-8.5.0
riscv                 randconfig-2003-20261117    gcc-11.5.0
riscv                 randconfig-2003-20261118    gcc-8.5.0
riscv                 randconfig-2004-20261117    gcc-11.5.0
riscv                 randconfig-2004-20261118    gcc-8.5.0
riscv                 randconfig-2005-20261117    gcc-11.5.0
riscv                 randconfig-2005-20261118    gcc-8.5.0
riscv                 randconfig-2200-20261117    clang-24   smatch
riscv                 randconfig-2200-20261118    clang-24   smatch
riscv                randconfig-r2108-20261117    gcc-8.5.0  cocci
riscv                randconfig-r2300-20261117    gcc-16.2.0 sparse
riscv                randconfig-r2302-20261118    gcc-16.2.0 sparse
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    clang-18
s390                  randconfig-1000-20261118    clang-24
s390                  randconfig-1001-20261118    gcc-11.5.0
s390                  randconfig-2000-20261117    gcc-13.5.0
s390                  randconfig-2000-20261117    gcc-15.3.0
s390                  randconfig-2000-20261118    clang-24
s390                  randconfig-2001-20261117    clang-24
s390                  randconfig-2001-20261117    gcc-15.3.0
s390                  randconfig-2001-20261118    clang-24
s390                  randconfig-2002-20261117    clang-17
s390                  randconfig-2002-20261117    gcc-15.3.0
s390                  randconfig-2002-20261118    clang-24
s390                  randconfig-2003-20261117    clang-24
s390                  randconfig-2003-20261117    gcc-15.3.0
s390                  randconfig-2003-20261118    clang-24
s390                  randconfig-2004-20261117    gcc-15.3.0
s390                  randconfig-2004-20261117    gcc-8.5.0
s390                  randconfig-2004-20261118    clang-24
s390                  randconfig-2005-20261117    gcc-15.3.0
s390                  randconfig-2005-20261118    clang-24
s390                  randconfig-2200-20261117    gcc-11.5.0 smatch
s390                  randconfig-2200-20261118    gcc-8.5.0  smatch
s390                 randconfig-r2111-20261118    clang-24   cocci
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-16.2.0
sh                    randconfig-1000-20261118    gcc-16.2.0
sh                    randconfig-1001-20261118    gcc-16.2.0
sh                    randconfig-2000-20261117    gcc-14.4.0
sh                    randconfig-2000-20261117    gcc-16.2.0
sh                    randconfig-2000-20261118    gcc-9.5.0
sh                    randconfig-2001-20261117    gcc-14.4.0
sh                    randconfig-2001-20261117    gcc-16.2.0
sh                    randconfig-2001-20261118    gcc-9.5.0
sh                    randconfig-2002-20261117    gcc-14.4.0
sh                    randconfig-2002-20261117    gcc-16.2.0
sh                    randconfig-2002-20261118    gcc-9.5.0
sh                    randconfig-2003-20261117    gcc-10.5.0
sh                    randconfig-2003-20261117    gcc-14.4.0
sh                    randconfig-2003-20261118    gcc-9.5.0
sh                    randconfig-2004-20261117    gcc-12.5.0
sh                    randconfig-2004-20261117    gcc-14.4.0
sh                    randconfig-2004-20261118    gcc-9.5.0
sh                    randconfig-2005-20261117    gcc-14.4.0
sh                    randconfig-2005-20261118    gcc-9.5.0
sh                    randconfig-2200-20261117    gcc-16.2.0 smatch
sh                    randconfig-2200-20261118    gcc-13.5.0 smatch
sh                   randconfig-r2100-20261118    clang-22   cocci
sh                   randconfig-r2110-20261117    gcc-16.2.0 cocci
sh                   randconfig-r2303-20261117    gcc-16.2.0 sparse
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-2000-20261117    gcc-14
sparc                 randconfig-2000-20261118    clang-24
sparc                 randconfig-2001-20261117    gcc-14
sparc                 randconfig-2001-20261118    clang-24
sparc                 randconfig-2200-20261118    gcc-13.5.0 smatch
sparc                randconfig-r2102-20261118    gcc-13.5.0 cocci
sparc                randconfig-r2106-20261117    gcc-8.5.0  cocci
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    clang-24
sparc64               randconfig-2000-20261117    gcc-14
sparc64               randconfig-2000-20261118    clang-24
sparc64               randconfig-2001-20261117    gcc-14
sparc64               randconfig-2001-20261118    clang-24
sparc64               randconfig-2200-20261117    gcc-8.5.0  smatch
sparc64               randconfig-2200-20261118    clang-22   smatch
sparc64              randconfig-r2103-20261118    clang-24   cocci
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                allyesconfig    gcc-14
um                                   defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-2000-20261117    gcc-14
um                    randconfig-2000-20261118    clang-24
um                    randconfig-2001-20261117    gcc-14
um                    randconfig-2001-20261118    clang-24
um                    randconfig-2200-20261117    clang-21   smatch
um                    randconfig-2200-20261118    clang-24   smatch
um                   randconfig-r2106-20261117    clang-24   cocci
um                   randconfig-r2301-20261118    gcc-16.2.0 sparse
um                   randconfig-r2305-20261118    gcc-16.2.0 sparse
um                            x86_64_defconfig    clang-24
x86_64                             allnoconfig    clang-22
x86_64      buildonly-randconfig-1000-20261118    gcc-14
x86_64      buildonly-randconfig-1001-20261118    gcc-12
x86_64      buildonly-randconfig-1002-20261118    gcc-12
x86_64      buildonly-randconfig-1003-20261118    clang-22
x86_64      buildonly-randconfig-1004-20261118    gcc-14
x86_64      buildonly-randconfig-1005-20261118    gcc-14
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1012-20261118    gcc-14
x86_64                randconfig-1013-20261118    clang-22
x86_64                randconfig-1014-20261118    gcc-14
x86_64                randconfig-1015-20261118    gcc-13
x86_64                randconfig-1016-20261118    clang-22
x86_64                randconfig-1017-20261118    gcc-14
x86_64                randconfig-2000-20261117    clang-22
x86_64                randconfig-2000-20261117    gcc-14
x86_64                randconfig-2000-20261118    gcc-13
x86_64                randconfig-2001-20261117    gcc-14
x86_64                randconfig-2001-20261118    gcc-13
x86_64                randconfig-2002-20261117    gcc-14
x86_64                randconfig-2002-20261118    gcc-13
x86_64                randconfig-2003-20261117    clang-22
x86_64                randconfig-2003-20261117    gcc-14
x86_64                randconfig-2003-20261118    gcc-13
x86_64                randconfig-2004-20261117    gcc-14
x86_64                randconfig-2004-20261118    gcc-13
x86_64                randconfig-2005-20261117    gcc-14
x86_64                randconfig-2005-20261118    gcc-13
x86_64                randconfig-2100-20261117    gcc-14     cocci
x86_64                randconfig-2101-20261117    gcc-14     cocci
x86_64                randconfig-2102-20261117    clang-22   cocci
x86_64                randconfig-2102-20261117    gcc-14     cocci
x86_64                randconfig-2103-20261117    clang-22   cocci
x86_64                randconfig-2103-20261117    gcc-14     cocci
x86_64                randconfig-2104-20261117    clang-22   cocci
x86_64                randconfig-2104-20261117    gcc-14     cocci
x86_64                randconfig-2105-20261117    clang-22   cocci
x86_64                randconfig-2105-20261117    gcc-14     cocci
x86_64                randconfig-2200-20261117    gcc-14     smatch
x86_64                randconfig-2200-20261118    clang-22   smatch
x86_64                randconfig-2300-20261117    clang-22   sparse
x86_64                randconfig-2301-20261117    clang-22   sparse
x86_64                randconfig-2302-20261117    clang-22   sparse
x86_64               randconfig-r2104-20261118    clang-22   cocci
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                            rhel-9.4-ltp    clang-22
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-2000-20261117    gcc-16.2.0
xtensa                randconfig-2000-20261118    gcc-16.2.0
xtensa                randconfig-2001-20261117    gcc-16.2.0
xtensa                randconfig-2001-20261118    gcc-16.2.0
xtensa                randconfig-2200-20261117    gcc-8.5.0  smatch
xtensa               randconfig-r2103-20261118    clang-22   cocci
xtensa               randconfig-r2111-20261117    gcc-8.5.0  cocci
xtensa               randconfig-r2305-20261117    gcc-16.2.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

