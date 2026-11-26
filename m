Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B523B606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FcF5APXv
Received: by kanga.kvack.org (Postfix)
	id CFD816B05CF; Thu, 26 Nov 2026 06:29:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5626B05D0; Thu, 26 Nov 2026 06:29:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBC16B05D6; Thu, 26 Nov 2026 06:29:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 983E66B05CF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:29:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14CE68045C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:29:30 +0000 (UTC)
X-FDA: 85477049700.24.09EB112
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3CA7B1C0004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:29:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FcF5APXv;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692568;
	b=rKuJ3pDewxVhIlBCmskFZu7vCxoaya5MPfl6E1aumtSRGaQ0qTFrCrn8f+GYQAp1EE9akl
	9mEy74xDfEzrAPCQHgxGgHVnid4GzzazUMT3PBxdL8PYa6pllmdFRDMDhcpsU0aCwG+quO
	WVqS/EAiMVXN34nwOrSb5VGMbUyfmWE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=s52DroxGqOQhpRP8SYDGc8O1LwIPlya0glLaPaa0hQk=;
	b=TF8MPJkYG9LfVXFv1PhGjPoxJTLecQmatqQ3tLYddEncAX9ZEtSSKXB0ceFozQZymESemi
	oCoaf/P3BikOiq52j928cg5FWecFDaxII6hzYeaPSCNOMrwzVngIp9L6vh9H+EZXPRQmvv
	SUrMPuapBqGkL5ttc4ZeSmM1YsNdvZ8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FcF5APXv;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795692568; x=1827228568;
  h=date:from:to:cc:subject:message-id;
  bh=XbusFM5EkQvyLljvouhCfjXUTvlmJNetYAu4VaDG0sk=;
  b=FcF5APXvTBL7QL7RpqnPOn56KAbMdSI8ZfhwSP0R91Jd9le/Yj2I8wjv
   2zof8C1Xtq5ghe1ZlcAuu/zRFezgC5WuNn24Qq0mxMVoua3YtAa1fyb5i
   c6yBsiXWfP5hGvTncewvZkdX809UBB3wbCY/CfjFX3QVETRdTI9D9gHk7
   w6HHuWhPzcFN7CgDX1BJbm+3nkjI25IQ5EB9p6emXSsO1PMODkxjdD6+z
   2weoBS2bikjLaqpz+bMld6bmOv70xi6kMVAy7Ar0Ct1QvZUJ4vDrAiKUl
   e17egOC6j0eB2SnXZLVBby1jvwAsWFbREjcQVC4sDFWPKfXzhKEMq0d1s
   w==;
X-CSE-ConnectionGUID: Ht8LZOEhQfGvaDkHVxaYXw==
X-CSE-MsgGUID: 33g49VPlRYqAw6c/mhA/1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4613677"
X-IronPort-AV: E=Sophos;i="6.27,234,1787036400"; 
   d="scan'208";a="4613677"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2026 03:29:27 -0800
X-CSE-ConnectionGUID: KqoJtZ37QA+ZyQQcYRdeCA==
X-CSE-MsgGUID: 9igQv9bWRQul025iY+Im8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,234,1787036400"; 
   d="scan'208";a="12369222"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 26 Nov 2026 03:29:24 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWXfF-00000001Ty2-3CqS;
	Thu, 26 Nov 2026 11:29:21 +0000
Date: Thu, 26 Nov 2026 19:29:11 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD REGRESSION
 9437046953b2fb3bf55b36582450ea0267df82a7
Message-ID: <20261126192911.NE6xCAFt-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User:
X-Stat-Signature: pb95gmcpxs4mphrfgxnr9btizrk37ra6
X-Rspamd-Queue-Id: 3CA7B1C0004
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795692567-594620
X-HE-Meta: U2FsdGVkX1+/adbKBw7GvpZM+E0IH+VDDw0WgHd8HRPjyjffkcWRIBlaVHScNFuOhRA2Jn0lbhke6ny6mObIsZ8PQt/zHyus36NaU9IPkxw7hMm1mn6ZrAXN9DO1UFSK9d9Y0OnFVzZxiOvJmGkML5gQJEDM4yaSdMWdY2LHmKa6u605sAayVG5JaoxFzWTYFv88UzsKYWrhPRgv8SvCx1PCwrdxjyM/7p/YTspqE0qjTYkmA5r3WTRpYgFVhDUs5N5m5qGEODktpRmYTN5aWyFdJw16g+5xsw6GaTv6aWGf/HDETddkz5fNTKM9C9jFDroBDix8qMKXsGniT0633HrgbuVlrh5ZZDWCyy4RpgvC01oi4upx28ET/HpsEjnzLu09QUllwkW5cbwXwnEJs17iOmzaiwLiaNAIqtRJ37R/VsUbZK17dIOkiEtOXGyonJc4Pm2HR8BRCJJNwfljIB2KIDX8mFC/EAye/lMsrlH30S8xYZWCfBiw4zv4dwjkbEPveMt+TZZmilByedZU5C65Gpq6YGDNgpMfHn86DTgq+Ocunk/xxr7yxsHK0WM7fYrrj4HBNFycLsNbRK/+3r3JuBr27AoTZBzBxiCtQ6vNiD7ejMZfK5vVKJGQLFMXmZ3NTEWjoyXqWyphf22tdTlx6T+vh4Qiej7X6E89Mq5pmOu8d907teRpSpNKalVydsB9iL7dyEkLPxf6FnJDbEz45yvZGpQUoqLQmF0hpxjt2198Gu+QvsPAeh0m6rpTuNj39fGxn+nFk+orH6aesZfZtCDNav6fcanjXuYy/ESMOZdF3e0QO/uRzjVv/QpyY6iV+4UX7bLdkk7mE7bbL5YYKbGCmXnc2oQWIZZiKSrgbkDTGwk/GN5q1syD9EozMCi7T0T/5Hn57PUYixZwIQPtIPPNYxzzb0qdjGUQ0Qel296Z7LM8ujJrmPOSoF5YTEATbpg38/CCTXgcALU
 B0QM7lpm
 FGQtNVieFmvyS4bsE0N25G+HRwuM2i2Kcv5Gxyq4CH1xphZYV/cD6wT4ikPuEuNrCfIneE4Sy+Imjd/s+b3cJk9UbASswbTXyfjkwF5nQ1t8iIH26vsy9N+o1vlv9pkSVNmuNBKK1LxKeXu0OCY3SD9Qv2cDgbJLh+tiNbVGGy7YfWiud0HBPZqgO91B8aYVp4mE+B/u9vRDx/R/E+FHO1IkJVr9hYJh8o6N3toXXIYKwh4hkW3yXo5cqAu9Uxh9TMbS+GArkHAvJ6oA/X7hje/PDwXiM9J6+rUKe8UsM3Z5Z4gF1N991VxgFr5AnB29LWSkAP+BWLC2I1H/BD2/+3SbEd24Zw94QwLoYhOUBoPZhT1q3j5ubQ3zWIPUj+Jb7AZYmFGgLrNHytlOZ6nDcb9sTUXzYmE0hEO6e6Jn/VFhurGlem4Z+FOky5fwabEvLbjS28u5tlFjcl8+k2jADUZqerHeVQqh6De7A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 9437046953b2fb3bf55b36582450ea0267df82a7  Add linux-next specific files for 20261125

Error/Warning (recently discovered and may have been fixed):

    arch/openrisc/include/asm/page.h:54:18: error: incompatible types when initializing type 'int' using type 'pgd_t' {aka 'struct <anonymous>'}

Error/Warning ids grouped by kconfigs:

recent_errors
`-- openrisc-randconfig-2200-20261126
    `-- arch-openrisc-include-asm-page.h:error:incompatible-types-when-initializing-type-int-using-type-pgd_t-aka-struct-anonymous

elapsed time: 978m

configs tested: 417
configs skipped: 8

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261125    gcc-12.5.0
alpha                 randconfig-2000-20261126    gcc-15.3.0
alpha                 randconfig-2001-20261125    gcc-8.5.0
alpha                 randconfig-2001-20261126    gcc-13.5.0
alpha                 randconfig-2200-20261125    gcc-10.5.0 smatch
arc                               allmodconfig    clang-24
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261126    gcc-16.2.0
arc                   randconfig-1001-20261126    gcc-16.2.0
arc                   randconfig-2000-20261125    gcc-8.5.0
arc                   randconfig-2000-20261126    gcc-11.5.0
arc                   randconfig-2001-20261125    gcc-10.5.0
arc                   randconfig-2001-20261126    gcc-8.5.0
arc                   randconfig-2002-20261125    gcc-16.2.0
arc                   randconfig-2002-20261126    gcc-8.5.0
arc                   randconfig-2003-20261125    gcc-10.5.0
arc                   randconfig-2003-20261126    gcc-9.5.0
arc                   randconfig-2004-20261125    gcc-12.5.0
arc                   randconfig-2004-20261126    gcc-15.3.0
arc                   randconfig-2005-20261125    gcc-10.5.0
arc                   randconfig-2005-20261126    gcc-9.5.0
arc                   randconfig-2200-20261125    gcc-14.4.0 smatch
arc                   randconfig-2200-20261126    gcc-8.5.0  smatch
arc                  randconfig-r2103-20261125    gcc-13.5.0 cocci
arc                  randconfig-r2109-20261125    gcc-9.5.0  cocci
arc                  randconfig-r2301-20261125    gcc-15.3.0 sparse
arm                               alldefconfig    gcc-16.2.0
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                                  defconfig    gcc-16.2.0
arm                             dove_defconfig    gcc-16.2.0
arm                            omap1_defconfig    gcc-16.2.0
arm                   randconfig-1000-20261126    gcc-16.2.0
arm                   randconfig-1001-20261126    gcc-16.2.0
arm                   randconfig-1002-20261126    gcc-16.2.0
arm                   randconfig-1003-20261126    gcc-16.2.0
arm                   randconfig-2000-20261125    clang-17
arm                   randconfig-2000-20261126    gcc-8.5.0
arm                   randconfig-2001-20261125    clang-22
arm                   randconfig-2001-20261126    gcc-11.5.0
arm                   randconfig-2002-20261125    clang-17
arm                   randconfig-2002-20261126    gcc-13.5.0
arm                   randconfig-2200-20261125    clang-21   smatch
arm                   randconfig-2200-20261126    gcc-8.5.0  smatch
arm                  randconfig-r2101-20261125    clang-24   cocci
arm                  randconfig-r2311-20261126    clang-24   sparse
arm                            u8500_defconfig    gcc-16.2.0
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261126    gcc-8.5.0
arm64                 randconfig-1001-20261126    gcc-8.5.0
arm64                 randconfig-1002-20261126    gcc-8.5.0
arm64                 randconfig-1003-20261126    gcc-8.5.0
arm64                 randconfig-2000-20261125    clang-24
arm64                 randconfig-2000-20261126    clang-24
arm64                 randconfig-2001-20261125    gcc-8.5.0
arm64                 randconfig-2001-20261126    clang-20
arm64                 randconfig-2002-20261125    clang-17
arm64                 randconfig-2002-20261126    clang-24
arm64                 randconfig-2200-20261125    gcc-13.5.0 smatch
arm64                 randconfig-2200-20261126    clang-24   smatch
arm64                randconfig-r2101-20261126    clang-24   cocci
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261126    gcc-8.5.0
csky                  randconfig-1001-20261126    gcc-8.5.0
csky                  randconfig-2000-20261125    gcc-16.2.0
csky                  randconfig-2000-20261126    gcc-16.2.0
csky                  randconfig-2001-20261125    gcc-14.4.0
csky                  randconfig-2001-20261126    gcc-13.5.0
csky                  randconfig-2200-20261125    gcc-16.2.0 smatch
csky                  randconfig-2200-20261126    gcc-13.5.0 smatch
csky                 randconfig-r2105-20261125    gcc-11.5.0 cocci
csky                 randconfig-r2109-20261125    gcc-11.5.0 cocci
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261126    gcc-11.5.0
hexagon               randconfig-1001-20261126    gcc-11.5.0
hexagon               randconfig-2000-20261125    clang-17
hexagon               randconfig-2000-20261126    clang-24
hexagon               randconfig-2001-20261125    clang-24
hexagon               randconfig-2001-20261126    clang-17
hexagon               randconfig-2200-20261125    clang-17   smatch
hexagon               randconfig-2200-20261126    clang-17   smatch
hexagon              randconfig-r2104-20261125    clang-20   cocci
hexagon              randconfig-r2303-20261125    clang-24   sparse
hexagon              randconfig-r2308-20261125    clang-17   sparse
i386                              allmodconfig    clang-22
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386        buildonly-randconfig-1000-20261126    gcc-14
i386        buildonly-randconfig-1001-20261126    gcc-14
i386        buildonly-randconfig-1002-20261126    gcc-14
i386        buildonly-randconfig-1003-20261126    gcc-14
i386        buildonly-randconfig-1004-20261126    gcc-14
i386        buildonly-randconfig-1005-20261126    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261126    clang-22
i386                  randconfig-1001-20261126    clang-22
i386                  randconfig-1002-20261126    clang-22
i386                  randconfig-1003-20261126    clang-22
i386                  randconfig-1004-20261126    clang-22
i386                  randconfig-1005-20261126    clang-22
i386                  randconfig-1006-20261126    clang-22
i386                  randconfig-2000-20261125    clang-22
i386                  randconfig-2000-20261126    clang-22
i386                  randconfig-2001-20261125    gcc-14
i386                  randconfig-2001-20261126    clang-22
i386                  randconfig-2002-20261125    gcc-14
i386                  randconfig-2002-20261126    clang-22
i386                  randconfig-2003-20261125    gcc-14
i386                  randconfig-2003-20261126    gcc-14
i386                  randconfig-2004-20261125    clang-22
i386                  randconfig-2004-20261126    clang-22
i386                  randconfig-2005-20261125    clang-22
i386                  randconfig-2005-20261126    clang-22
i386                  randconfig-2100-20261125    clang-22   cocci
i386                  randconfig-2101-20261125    clang-22   cocci
i386                  randconfig-2102-20261125    clang-22   cocci
i386                  randconfig-2103-20261125    clang-22   cocci
i386                  randconfig-2104-20261125    gcc-14     cocci
i386                  randconfig-2105-20261125    clang-22   cocci
i386                  randconfig-2200-20261125    clang-22   smatch
i386                  randconfig-2300-20261125    clang-22   sparse
i386                  randconfig-2301-20261125    clang-22   sparse
i386                  randconfig-2302-20261125    clang-22   sparse
i386                 randconfig-r2107-20261125    clang-22   cocci
i386                 randconfig-r2306-20261126    clang-22   sparse
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    gcc-16.2.0
loongarch             randconfig-1000-20261126    gcc-11.5.0
loongarch             randconfig-1001-20261126    gcc-11.5.0
loongarch             randconfig-2000-20261125    clang-19
loongarch             randconfig-2000-20261126    gcc-12.5.0
loongarch             randconfig-2001-20261125    gcc-16.2.0
loongarch             randconfig-2001-20261126    clang-18
loongarch             randconfig-2200-20261125    clang-18   smatch
loongarch             randconfig-2200-20261126    gcc-14.4.0 smatch
loongarch            randconfig-r2106-20261125    gcc-16.2.0 cocci
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                  randconfig-2000-20261125    gcc-8.5.0
m68k                  randconfig-2000-20261126    gcc-8.5.0
m68k                  randconfig-2001-20261125    gcc-11.5.0
m68k                  randconfig-2001-20261126    gcc-8.5.0
m68k                  randconfig-2200-20261125    gcc-15.3.0 smatch
m68k                 randconfig-r2100-20261125    gcc-16.2.0 cocci
m68k                 randconfig-r2307-20261125    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze            randconfig-2000-20261125    gcc-12.5.0
microblaze            randconfig-2000-20261126    gcc-15.3.0
microblaze            randconfig-2001-20261125    gcc-10.5.0
microblaze            randconfig-2001-20261126    gcc-8.5.0
microblaze            randconfig-2200-20261125    gcc-8.5.0  smatch
microblaze            randconfig-2200-20261126    gcc-9.5.0  smatch
microblaze           randconfig-r2307-20261126    gcc-8.5.0  sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                         maltaup_defconfig    clang-20
mips                  randconfig-2000-20261125    gcc-14.4.0
mips                  randconfig-2001-20261125    clang-17
mips                  randconfig-2002-20261125    clang-24
mips                  randconfig-2200-20261125    clang-24   smatch
mips                 randconfig-r2110-20261125    clang-24   cocci
mips                    sb1250_swarm_defconfig    clang-20
nios2                             allmodconfig    clang-20
nios2                              allnoconfig    clang-24
nios2                 randconfig-1000-20261126    gcc-11.5.0
nios2                 randconfig-1001-20261126    gcc-11.5.0
nios2                 randconfig-2000-20261125    gcc-8.5.0
nios2                 randconfig-2000-20261126    gcc-11.5.0
nios2                 randconfig-2001-20261125    gcc-8.5.0
nios2                 randconfig-2001-20261126    gcc-9.5.0
nios2                 randconfig-2200-20261125    gcc-8.5.0  smatch
nios2                 randconfig-2200-20261126    gcc-9.5.0  smatch
nios2                randconfig-r2309-20261126    gcc-11.5.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                           allnoconfig    clang-24
openrisc                    de0_nano_defconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261125    gcc-12.5.0
openrisc              randconfig-2001-20261125    gcc-10.5.0
openrisc              randconfig-2002-20261125    gcc-16.2.0
openrisc              randconfig-2200-20261125    gcc-10.5.0 smatch
openrisc              randconfig-2200-20261126    gcc-9.5.0  smatch
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                            allyesconfig    clang-17
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261126    gcc-13.5.0
parisc                randconfig-1001-20261126    gcc-13.5.0
parisc                randconfig-2000-20261125    gcc-10.5.0
parisc                randconfig-2000-20261126    gcc-8.5.0
parisc                randconfig-2001-20261125    gcc-8.5.0
parisc                randconfig-2001-20261126    gcc-8.5.0
parisc                randconfig-2200-20261125    gcc-12.5.0 smatch
parisc                randconfig-2200-20261126    gcc-15.3.0 smatch
parisc               randconfig-r2111-20261125    gcc-16.2.0 cocci
parisc               randconfig-r2300-20261125    gcc-15.3.0 sparse
parisc               randconfig-r2304-20261125    gcc-15.3.0 sparse
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                       arches_defconfig    gcc-16.2.0
powerpc                      asp8347_defconfig    gcc-16.2.0
powerpc                    currituck_defconfig    gcc-16.2.0
powerpc                   iss476-smp_defconfig    clang-20
powerpc                    motionpro_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261126    gcc-13.5.0
powerpc               randconfig-1001-20261126    gcc-13.5.0
powerpc               randconfig-2000-20261125    clang-17
powerpc               randconfig-2001-20261125    gcc-11.5.0
powerpc               randconfig-2002-20261125    gcc-9.5.0
powerpc               randconfig-2200-20261125    gcc-11.5.0 smatch
powerpc              randconfig-r2100-20261126    clang-24   cocci
powerpc              randconfig-r2302-20261125    gcc-13.5.0 sparse
powerpc              randconfig-r2310-20261125    gcc-8.5.0  sparse
powerpc                      stx_gp3_defconfig    gcc-16.2.0
powerpc                      tqm5200_defconfig    clang-20
powerpc                       tqm8xx_defconfig    clang-20
powerpc                  xes_mpc85xx_defconfig    gcc-16.2.0
powerpc64             randconfig-1000-20261126    gcc-13.5.0
powerpc64             randconfig-1001-20261126    gcc-13.5.0
powerpc64             randconfig-2000-20261125    gcc-15.3.0
powerpc64             randconfig-2001-20261125    clang-17
powerpc64             randconfig-2002-20261125    clang-17
powerpc64             randconfig-2200-20261125    gcc-13.5.0 smatch
powerpc64             randconfig-2200-20261126    clang-24   smatch
powerpc64            randconfig-r2105-20261126    gcc-16.2.0 cocci
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                     nommu_virt_defconfig    gcc-16.2.0
riscv                 randconfig-1001-20261126    clang-20
riscv                 randconfig-2000-20261125    gcc-13.5.0
riscv                 randconfig-2000-20261126    gcc-10.5.0
riscv                 randconfig-2001-20261125    gcc-8.5.0
riscv                 randconfig-2001-20261126    clang-24
riscv                 randconfig-2002-20261125    gcc-8.5.0
riscv                 randconfig-2002-20261126    clang-20
riscv                 randconfig-2003-20261125    gcc-11.5.0
riscv                 randconfig-2003-20261126    gcc-16.2.0
riscv                 randconfig-2004-20261125    gcc-8.5.0
riscv                 randconfig-2004-20261126    gcc-10.5.0
riscv                 randconfig-2005-20261125    clang-24
riscv                 randconfig-2005-20261126    clang-24
riscv                 randconfig-2200-20261125    gcc-8.5.0  smatch
riscv                 randconfig-2200-20261126    gcc-8.5.0  smatch
riscv                randconfig-r2108-20261125    clang-19   cocci
s390                              allmodconfig    clang-17
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261126    clang-20
s390                  randconfig-1001-20261126    clang-20
s390                  randconfig-2000-20261125    gcc-8.5.0
s390                  randconfig-2000-20261126    clang-18
s390                  randconfig-2001-20261125    gcc-11.5.0
s390                  randconfig-2001-20261126    gcc-8.5.0
s390                  randconfig-2002-20261125    clang-24
s390                  randconfig-2002-20261126    clang-24
s390                  randconfig-2003-20261125    gcc-8.5.0
s390                  randconfig-2003-20261126    clang-18
s390                  randconfig-2004-20261125    clang-24
s390                  randconfig-2004-20261126    gcc-10.5.0
s390                  randconfig-2005-20261125    clang-20
s390                  randconfig-2005-20261126    clang-21
s390                  randconfig-2200-20261125    gcc-15.3.0 smatch
s390                  randconfig-2200-20261126    gcc-16.2.0 smatch
s390                 randconfig-r2102-20261125    gcc-8.5.0  cocci
s390                 randconfig-r2107-20261125    gcc-8.5.0  cocci
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                allyesconfig    clang-17
sh                          apsh4a3a_defconfig    clang-20
sh                                   defconfig    gcc-14
sh                         dreamcast_defconfig    gcc-16.2.0
sh                    randconfig-1000-20261126    clang-20
sh                    randconfig-1001-20261126    clang-20
sh                    randconfig-2000-20261125    gcc-16.2.0
sh                    randconfig-2000-20261126    gcc-16.2.0
sh                    randconfig-2001-20261125    gcc-14.4.0
sh                    randconfig-2001-20261126    gcc-13.5.0
sh                    randconfig-2002-20261125    gcc-16.2.0
sh                    randconfig-2002-20261126    gcc-11.5.0
sh                    randconfig-2003-20261125    gcc-14.4.0
sh                    randconfig-2003-20261126    gcc-9.5.0
sh                    randconfig-2004-20261125    gcc-16.2.0
sh                    randconfig-2004-20261126    gcc-16.2.0
sh                    randconfig-2005-20261125    gcc-10.5.0
sh                    randconfig-2005-20261126    gcc-16.2.0
sh                    randconfig-2200-20261125    gcc-14.4.0 smatch
sh                    randconfig-2200-20261126    gcc-16.2.0 smatch
sh                   randconfig-r2108-20261125    gcc-12.5.0 cocci
sh                    rts7751r2dplus_defconfig    clang-20
sh                            se7619_defconfig    gcc-16.2.0
sh                            se7712_defconfig    gcc-16.2.0
sparc                              allnoconfig    clang-24
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261126    clang-17
sparc                 randconfig-1001-20261126    clang-17
sparc                 randconfig-2000-20261125    gcc-16.2.0
sparc                 randconfig-2000-20261126    gcc-8.5.0
sparc                 randconfig-2001-20261125    gcc-16.2.0
sparc                 randconfig-2001-20261126    gcc-13.5.0
sparc                 randconfig-2200-20261125    gcc-14.4.0 smatch
sparc                 randconfig-2200-20261126    gcc-13.5.0 smatch
sparc                randconfig-r2104-20261126    gcc-8.5.0  cocci
sparc                randconfig-r2111-20261125    gcc-8.5.0  cocci
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261126    clang-17
sparc64               randconfig-1001-20261126    clang-17
sparc64               randconfig-2000-20261125    clang-24
sparc64               randconfig-2000-20261126    clang-24
sparc64               randconfig-2001-20261125    gcc-8.5.0
sparc64               randconfig-2001-20261126    gcc-8.5.0
sparc64               randconfig-2200-20261125    gcc-15.3.0 smatch
sparc64               randconfig-2200-20261126    gcc-12.5.0 smatch
sparc64              randconfig-r2306-20261125    gcc-8.5.0  sparse
sparc64              randconfig-r2310-20261126    clang-22   sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261126    clang-17
um                    randconfig-1001-20261126    clang-17
um                    randconfig-2000-20261125    clang-17
um                    randconfig-2000-20261126    clang-17
um                    randconfig-2001-20261125    clang-22
um                    randconfig-2001-20261126    clang-17
um                    randconfig-2200-20261125    clang-17   smatch
um                    randconfig-2200-20261126    gcc-12     smatch
um                   randconfig-r2103-20261126    clang-24   cocci
um                   randconfig-r2309-20261125    gcc-14     sparse
um                            x86_64_defconfig    gcc-14
x86_64                            alldefconfig    clang-20
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261126    clang-22
x86_64      buildonly-randconfig-1001-20261126    clang-22
x86_64      buildonly-randconfig-1002-20261126    clang-22
x86_64      buildonly-randconfig-1003-20261126    clang-22
x86_64      buildonly-randconfig-1004-20261126    clang-22
x86_64      buildonly-randconfig-1005-20261126    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261126    clang-22
x86_64                randconfig-1001-20261126    clang-22
x86_64                randconfig-1002-20261126    clang-22
x86_64                randconfig-1003-20261126    clang-22
x86_64                randconfig-1004-20261126    clang-22
x86_64                randconfig-1005-20261126    clang-22
x86_64                randconfig-2000-20261125    gcc-14
x86_64                randconfig-2001-20261125    gcc-14
x86_64                randconfig-2002-20261125    gcc-14
x86_64                randconfig-2003-20261125    gcc-14
x86_64                randconfig-2004-20261125    gcc-14
x86_64                randconfig-2005-20261125    gcc-14
x86_64                randconfig-2100-20261125    gcc-13     cocci
x86_64                randconfig-2100-20261126    clang-22   cocci
x86_64                randconfig-2101-20261125    clang-22   cocci
x86_64                randconfig-2101-20261126    clang-22   cocci
x86_64                randconfig-2102-20261125    clang-22   cocci
x86_64                randconfig-2102-20261126    gcc-14     cocci
x86_64                randconfig-2103-20261125    clang-22   cocci
x86_64                randconfig-2103-20261126    clang-22   cocci
x86_64                randconfig-2104-20261125    gcc-14     cocci
x86_64                randconfig-2104-20261126    gcc-14     cocci
x86_64                randconfig-2105-20261125    gcc-14     cocci
x86_64                randconfig-2105-20261126    gcc-14     cocci
x86_64                randconfig-2200-20261125    gcc-14     smatch
x86_64                randconfig-2200-20261126    clang-22   smatch
x86_64                randconfig-2300-20261125    clang-22   sparse
x86_64                randconfig-2301-20261125    clang-22   sparse
x86_64                randconfig-2302-20261125    clang-22   sparse
x86_64               randconfig-r2106-20261125    gcc-14     cocci
x86_64                                rhel-9.4    clang-22
x86_64                                rhel-9.4    gcc-14
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                           rhel-9.4-func    gcc-14
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                     rhel-9.4-kselftests    gcc-14
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                            allyesconfig    clang-20
xtensa                 generic_kc705_defconfig    gcc-16.2.0
xtensa                randconfig-1000-20261126    clang-17
xtensa                randconfig-1001-20261126    clang-17
xtensa                randconfig-2000-20261125    gcc-10.5.0
xtensa                randconfig-2000-20261126    gcc-13.5.0
xtensa                randconfig-2001-20261125    gcc-12.5.0
xtensa                randconfig-2001-20261126    gcc-15.3.0
xtensa                randconfig-2200-20261125    gcc-16.2.0 smatch
xtensa                randconfig-2200-20261126    gcc-11.5.0 smatch
xtensa               randconfig-r2102-20261126    gcc-8.5.0  cocci
xtensa               randconfig-r2110-20261125    gcc-8.5.0  cocci
xtensa               randconfig-r2305-20261125    gcc-11.5.0 sparse
xtensa               randconfig-r2311-20261125    gcc-8.5.0  sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

