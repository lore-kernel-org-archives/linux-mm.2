Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D537D606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QxOSrDWR
Received: by kanga.kvack.org (Postfix)
	id 39AAF6B05C2; Tue, 17 Nov 2026 00:09:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34B6F6B05C4; Tue, 17 Nov 2026 00:09:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8F56B05C2; Tue, 17 Nov 2026 00:09:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA1326B05C2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:09:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AD23140264
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:22 +0000 (UTC)
X-FDA: 85443432564.14.3BC77A4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8EE49180005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QxOSrDWR;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892160;
	b=F59pStFFHGEVSMjRd9Ccmyu9TAcxlxaJ4LmwC86YiTJNzIU+uySl7vwBIoeY5oi46zDRNA
	hwxuieowEmgldb7Sxz375xdg0yLZdn48E4NY1J019ZbIn1WregRJjEacAItjrcee9gLf+W
	gQK9Lmz74/1mih+YllAjaotCouaugFY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QxOSrDWR;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=bw0B8O/izMaFbypZNOx2iISZEOiKmDVzVJNpn/vJqOE=;
	b=AMY2RSUCGv8Q15iJtqwOqsmwhb+vrIaJ8pg5zsCoJkcV5e+aL36swcQ2rUS59ZUq5fUGfV
	HHK2dKkvlDzX9PcBkXaJZH+jOnR2KZcgDQcEeqwnF575+O9/teyi/jxM2fHSNYKsR9LIHS
	UtNj1fkvVQPrlXyXYd6CElq4FzUjXUM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794892160; x=1826428160;
  h=date:from:to:cc:subject:message-id;
  bh=Cyu159afovMzAFU1x+w745Gx1w/sjSK4hlc1jbXidO4=;
  b=QxOSrDWRW5ZdkwJuPPU9VlTKbzIKYQ4RqpJC4VR0DB37PZF7HNBCIT+f
   OzX82MPl8sOvGvQ4Qr47pzcT546ogQbdOyCwGQ+wiaRB1VA4Nts5tTm9m
   aR+AoUH8C0QTe93mfXfMr/l7nY+B6wTg2+a+BcgjmnYkj4+ooeFyk8QF8
   pxE/PRNv68mnDTXA+WBRtiTvH0tGMYewUjUQLn9cLhIELy1zgK11T+288
   5zL2TvGu5KSxlweBt3Gplor04l9etGeH2me8qU+s4Pu5a06gQBOr7XMt+
   ymIGUGH91F2F6yUNYB6Qjk0zVzK3ItJNogHqlSu2wpt9CIsXWwcZOs7Du
   Q==;
X-CSE-ConnectionGUID: yrLQc/FVR3eMWWKniK1Cfw==
X-CSE-MsgGUID: NRrir6SmRQKgAaZy1IXYDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11968"; a="3688521"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3688521"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 21:09:19 -0800
X-CSE-ConnectionGUID: jnQlZXGDRke2h5eo65QlwQ==
X-CSE-MsgGUID: QNv2xjCGQVW6ucsUpOxJoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="9979293"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 16 Nov 2026 21:09:16 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xTBRR-00000001A48-3Eof;
	Tue, 17 Nov 2026 05:09:13 +0000
Date: Tue, 17 Nov 2026 13:09:02 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 67f3b04b277373438f17300e056306adbd9edf7b
Message-ID: <20261117130902.V3S0gJ7v-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 8EE49180005
X-Stat-Signature: 1nyemqunmou9yhrjeyycshcfx9ue4x5n
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794892159-511041
X-HE-Meta: U2FsdGVkX1+94RzqRW6bFSXHN3PwOSdZaNeXjnb5NEDvBPHU+9FW4VZKkBuR8kJo0eOAK9XdXokkzObzZ98FRThVwMLJGFNsBo+q80zY+8HeVvIEfNH2M2HIDd7EGny753GhGomWyfLbF1gTziJdqTYT10ONZHwZkjnYvTD9AX/KiOfBwhYsu+mBQj2+cDnKSZFMSWXVorwEK5gzlizra39exmbC1ArE2V2lKOeNJinILwspFs7bJ5GLhgXIbDIAXtzKynFB2gTMu/lvZrJm4wDT4rZwefoV32jTlNYu9c//OxH+9AtSA84YMw3gRwoj8m4jnefPzXdec0kQXaPPmDM8eZ5TnlCwsDRznkfQkLIfvmnDU7XHRVxVuGXyR/+obSZjq/5prdWXRfjTFjg+JQPQJLcbQENc2nBUcJqVZd0B2gR1TdgZwvWwfungk1W6qFbU9V7dq/E9LwOz/k8RmbfGN6/tGv+huA6Z28wRkkE7HOrKkp/XBmnnpB5fLdA81taysh1y7W8tZORurjMXNlJFRQJqzBsHnSrZgxhrWxNBfVBAn4yZvMxiQHqSGU1+Qs8yoTjR4ONxIPwCi555EcQ6rUMxvCR2DtbJebVorlokOLlOYNtnt/g4B0sKYQUflyZSfSFxshe4WKxj//nKpyIwCJB2gloenTgzUG+bVtfO0m3j2kvZN2Tzaz6WVCiKjsLXLoJFIfSlwzwJEQ9n7NEoHxG6HZGHmk4Xtel+rvnrBWrc/GIXm0hWe7fz6mWaiJ7CiHl7CHAAZAn2s9n2nmJlDqW1fyWBDJuwKepzobC8Z9aj2P1GjiWHu8YI7pJLvkD4M9HX7c2jOY41vyrgWFS5KLZewLeNinfEbbfhpz6NZUokE44L8/eU3u4U9WsakWBvDz5UvgrPMy0ds76qbgGa2LDVMuULil/gzZYSJDUFnIOtZi/mp5nBK047VMu8CoNqGNkL8GXcU4vpjz6
 MsgFMdl0
 sQ1Bz4XSLOnwvCRdyXN+jXlDk72sxQ+mhl134Xy6sVaT70QQkrh+rq65ndSm1saqjhi7OO8FLyewmatzKdJrgFyvMpcq8g36bSGLSt9NlEwLUuE9+BE11YR5+GJekMZgN6Xz8YJmo7+S+i8Bri2Ezu2vTuqmgNg8Y6L6t/WFgBlilQXpS1DAzWyJ5uwO/6kf1XLbD/Jxr5C5ZAXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 67f3b04b277373438f17300e056306adbd9edf7b  lib/test_xarray: check unused spare node after range creation

elapsed time: 855m

configs tested: 527
configs skipped: 10

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    clang-24
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261116    gcc-10.5.0
alpha                 randconfig-2001-20261116    gcc-10.5.0
alpha                 randconfig-2200-20261116    gcc-15.3.0 smatch
alpha                randconfig-r2102-20261116    gcc-9.5.0  cocci
alpha                randconfig-r2103-20261116    gcc-15.3.0 cocci
alpha                randconfig-r2105-20261116    clang-22   cocci
alpha                randconfig-r2107-20261116    clang-24   cocci
alpha                randconfig-r2307-20261116    gcc-8.5.0  sparse
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261117    gcc-13.5.0
arc                   randconfig-1001-20261117    gcc-13.5.0
arc                   randconfig-2000-20261116    gcc-13.5.0
arc                   randconfig-2001-20261116    gcc-13.5.0
arc                   randconfig-2002-20261116    gcc-13.5.0
arc                   randconfig-2003-20261116    gcc-13.5.0
arc                   randconfig-2004-20261116    gcc-13.5.0
arc                   randconfig-2005-20261116    gcc-13.5.0
arc                   randconfig-2200-20261116    gcc-15.3.0 smatch
arc                  randconfig-r2101-20261116    gcc-9.5.0  cocci
arc                  randconfig-r2108-20261116    clang-24   cocci
arc                  randconfig-r2303-20261116    gcc-14.4.0 sparse
arc                  randconfig-r2306-20261116    gcc-16.2.0 sparse
arc                  randconfig-r2307-20261116    gcc-14.4.0 sparse
arc                  randconfig-r2308-20261116    gcc-16.2.0 sparse
arc                  randconfig-r2310-20261116    clang-20   sparse
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                          nhk8815_defconfig    clang-24
arm                   randconfig-1000-20261117    gcc-13.5.0
arm                   randconfig-1001-20261117    gcc-13.5.0
arm                   randconfig-1002-20261117    gcc-13.5.0
arm                   randconfig-1003-20261117    gcc-13.5.0
arm                   randconfig-2000-20261116    gcc-15.3.0
arm                   randconfig-2001-20261116    clang-24
arm                   randconfig-2001-20261116    gcc-15.3.0
arm                   randconfig-2002-20261116    gcc-15.3.0
arm                   randconfig-2002-20261116    gcc-8.5.0
arm                   randconfig-2200-20261116    gcc-13.5.0 smatch
arm                  randconfig-r2106-20261116    gcc-8.5.0  cocci
arm                  randconfig-r2108-20261116    clang-24   cocci
arm                  randconfig-r2110-20261116    clang-24   cocci
arm                  randconfig-r2110-20261116    gcc-14     cocci
arm                  randconfig-r2303-20261116    gcc-16.2.0 sparse
arm                  randconfig-r2310-20261116    gcc-8.5.0  sparse
arm                            spitz_defconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261117    gcc-16.2.0
arm64                 randconfig-1001-20261117    gcc-16.2.0
arm64                 randconfig-1002-20261117    gcc-16.2.0
arm64                 randconfig-1003-20261117    gcc-16.2.0
arm64                 randconfig-2000-20261116    gcc-15.3.0
arm64                 randconfig-2000-20261116    gcc-8.5.0
arm64                 randconfig-2001-20261116    clang-18
arm64                 randconfig-2001-20261116    gcc-15.3.0
arm64                 randconfig-2002-20261116    gcc-14.4.0
arm64                 randconfig-2002-20261116    gcc-15.3.0
arm64                 randconfig-2200-20261116    gcc-8.5.0  smatch
arm64                randconfig-r2100-20261116    clang-22   cocci
arm64                randconfig-r2107-20261116    clang-24   cocci
arm64                randconfig-r2309-20261116    clang-20   sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261117    gcc-16.2.0
csky                  randconfig-1001-20261117    gcc-16.2.0
csky                  randconfig-2000-20261116    gcc-16.2.0
csky                  randconfig-2001-20261116    gcc-15.3.0
csky                  randconfig-2001-20261116    gcc-16.2.0
csky                  randconfig-2200-20261116    gcc-16.2.0 smatch
csky                 randconfig-r2105-20261116    gcc-9.5.0  cocci
csky                 randconfig-r2107-20261116    clang-24   cocci
csky                 randconfig-r2109-20261116    clang-24   cocci
csky                 randconfig-r2300-20261116    gcc-16.2.0 sparse
csky                 randconfig-r2305-20261116    gcc-16.2.0 sparse
csky                 randconfig-r2308-20261116    gcc-14.4.0 sparse
csky                 randconfig-r2311-20261116    clang-20   sparse
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261117    clang-17
hexagon               randconfig-1001-20261117    clang-17
hexagon               randconfig-2000-20261116    clang-24
hexagon               randconfig-2000-20261116    gcc-16.2.0
hexagon               randconfig-2001-20261116    clang-21
hexagon               randconfig-2001-20261116    gcc-16.2.0
hexagon               randconfig-2200-20261116    clang-17   smatch
hexagon              randconfig-r2101-20261116    clang-21   cocci
hexagon              randconfig-r2104-20261116    clang-22   cocci
hexagon              randconfig-r2108-20261116    gcc-14     cocci
hexagon              randconfig-r2111-20261116    clang-24   cocci
hexagon              randconfig-r2303-20261116    gcc-11.5.0 sparse
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386        buildonly-randconfig-1000-20261117    clang-22
i386        buildonly-randconfig-1001-20261117    clang-22
i386        buildonly-randconfig-1002-20261117    clang-22
i386        buildonly-randconfig-1003-20261117    clang-22
i386        buildonly-randconfig-1004-20261117    clang-22
i386        buildonly-randconfig-1005-20261117    clang-22
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261117    gcc-14
i386                  randconfig-1001-20261117    gcc-14
i386                  randconfig-1002-20261117    gcc-14
i386                  randconfig-1003-20261117    gcc-14
i386                  randconfig-1004-20261117    gcc-14
i386                  randconfig-1005-20261117    gcc-14
i386                  randconfig-1006-20261117    gcc-14
i386                  randconfig-1007-20261117    clang-22
i386                  randconfig-1008-20261117    clang-22
i386                  randconfig-1009-20261117    clang-22
i386                  randconfig-1010-20261117    clang-22
i386                  randconfig-1011-20261117    clang-22
i386                  randconfig-1012-20261117    clang-22
i386                  randconfig-1013-20261117    clang-22
i386                  randconfig-2000-20261116    clang-22
i386                  randconfig-2000-20261116    gcc-14
i386                  randconfig-2001-20261116    gcc-14
i386                  randconfig-2002-20261116    clang-22
i386                  randconfig-2002-20261116    gcc-14
i386                  randconfig-2003-20261116    gcc-13
i386                  randconfig-2003-20261116    gcc-14
i386                  randconfig-2004-20261116    clang-22
i386                  randconfig-2004-20261116    gcc-14
i386                  randconfig-2005-20261116    gcc-13
i386                  randconfig-2005-20261116    gcc-14
i386                  randconfig-2100-20261116    gcc-14     cocci
i386                  randconfig-2101-20261116    clang-22   cocci
i386                  randconfig-2101-20261116    gcc-14     cocci
i386                  randconfig-2102-20261116    clang-22   cocci
i386                  randconfig-2102-20261116    gcc-14     cocci
i386                  randconfig-2103-20261116    gcc-14     cocci
i386                  randconfig-2104-20261116    gcc-14     cocci
i386                  randconfig-2105-20261116    gcc-14     cocci
i386                  randconfig-2200-20261116    gcc-14     smatch
i386                  randconfig-2300-20261116    gcc-14     sparse
i386                  randconfig-2301-20261116    gcc-14     sparse
i386                  randconfig-2302-20261116    gcc-14     sparse
i386                 randconfig-r2100-20261116    clang-22   cocci
i386                 randconfig-r2102-20261116    clang-22   cocci
i386                 randconfig-r2106-20261116    clang-24   cocci
i386                 randconfig-r2107-20261116    gcc-14     cocci
i386                 randconfig-r2110-20261116    clang-24   cocci
i386                 randconfig-r2307-20261116    gcc-15.3.0 sparse
i386                 randconfig-r2311-20261116    clang-20   sparse
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch                 loongson32_defconfig    clang-24
loongarch             randconfig-1000-20261117    clang-17
loongarch             randconfig-1001-20261117    clang-17
loongarch             randconfig-2000-20261116    clang-24
loongarch             randconfig-2000-20261116    gcc-11.5.0
loongarch             randconfig-2000-20261117    gcc-8.5.0
loongarch             randconfig-2001-20261116    clang-24
loongarch             randconfig-2001-20261116    gcc-11.5.0
loongarch             randconfig-2001-20261117    gcc-8.5.0
loongarch            randconfig-r2101-20261116    clang-22   cocci
loongarch            randconfig-r2109-20261116    clang-24   cocci
loongarch            randconfig-r2300-20261116    gcc-16.2.0 sparse
loongarch            randconfig-r2304-20261116    gcc-16.2.0 sparse
loongarch            randconfig-r2309-20261116    clang-19   sparse
loongarch            randconfig-r2311-20261116    gcc-12.5.0 sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                           amiga_defconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                  randconfig-2000-20261116    gcc-10.5.0
m68k                  randconfig-2001-20261116    gcc-10.5.0
m68k                  randconfig-2200-20261116    gcc-14.4.0 smatch
m68k                 randconfig-r2105-20261116    gcc-15.3.0 cocci
m68k                 randconfig-r2107-20261116    clang-24   cocci
m68k                 randconfig-r2108-20261116    clang-24   cocci
m68k                 randconfig-r2300-20261116    gcc-11.5.0 sparse
m68k                 randconfig-r2302-20261116    gcc-16.2.0 sparse
m68k                 randconfig-r2305-20261116    gcc-16.2.0 sparse
m68k                 randconfig-r2311-20261116    gcc-8.5.0  sparse
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261116    gcc-10.5.0
microblaze            randconfig-2001-20261116    gcc-10.5.0
microblaze            randconfig-2200-20261116    gcc-11.5.0 smatch
microblaze           randconfig-r2102-20261116    gcc-9.5.0  cocci
microblaze           randconfig-r2107-20261116    gcc-11.5.0 cocci
microblaze           randconfig-r2302-20261116    gcc-11.5.0 sparse
microblaze           randconfig-r2309-20261116    gcc-8.5.0  sparse
microblaze           randconfig-r2310-20261116    gcc-15.3.0 sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                           eyeq6_defconfig    clang-24
mips                      loongson2k_defconfig    gcc-16.2.0
mips                       maltaaprp_defconfig    clang-24
mips                  randconfig-2000-20261116    gcc-11.5.0
mips                  randconfig-2000-20261116    gcc-13.5.0
mips                  randconfig-2001-20261116    clang-24
mips                  randconfig-2001-20261116    gcc-13.5.0
mips                  randconfig-2002-20261116    clang-17
mips                  randconfig-2002-20261116    gcc-13.5.0
mips                  randconfig-2200-20261116    gcc-8.5.0  smatch
mips                 randconfig-r2103-20261116    gcc-9.5.0  cocci
mips                 randconfig-r2301-20261116    gcc-11.5.0 sparse
mips                 randconfig-r2309-20261116    gcc-12.5.0 sparse
mips                          rt305x_defconfig    clang-24
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261117    clang-17
nios2                 randconfig-1001-20261117    clang-17
nios2                 randconfig-2000-20261116    gcc-11.5.0
nios2                 randconfig-2000-20261117    gcc-8.5.0
nios2                 randconfig-2001-20261116    gcc-11.5.0
nios2                 randconfig-2001-20261117    gcc-8.5.0
nios2                 randconfig-2200-20261116    gcc-11.5.0 smatch
nios2                randconfig-r2104-20261116    gcc-9.5.0  cocci
nios2                randconfig-r2108-20261116    gcc-11.5.0 cocci
nios2                randconfig-r2111-20261116    clang-24   cocci
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261116    gcc-13.5.0
openrisc              randconfig-2001-20261116    gcc-13.5.0
openrisc              randconfig-2001-20261116    gcc-15.3.0
openrisc              randconfig-2002-20261116    gcc-13.5.0
openrisc              randconfig-2002-20261116    gcc-9.5.0
openrisc              randconfig-2200-20261116    gcc-15.3.0 smatch
openrisc             randconfig-r2106-20261116    clang-24   cocci
openrisc             randconfig-r2108-20261116    clang-24   cocci
openrisc             randconfig-r2302-20261116    gcc-12.5.0 sparse
openrisc             randconfig-r2302-20261116    gcc-16.2.0 sparse
openrisc             randconfig-r2306-20261116    gcc-12.5.0 sparse
openrisc             randconfig-r2308-20261116    clang-20   sparse
openrisc             randconfig-r2309-20261116    gcc-14.4.0 sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261117    gcc-9.5.0
parisc                randconfig-1001-20261117    gcc-9.5.0
parisc                randconfig-2000-20261116    gcc-11.5.0
parisc                randconfig-2000-20261116    gcc-15.3.0
parisc                randconfig-2000-20261117    gcc-8.5.0
parisc                randconfig-2001-20261116    gcc-11.5.0
parisc                randconfig-2001-20261116    gcc-9.5.0
parisc                randconfig-2001-20261117    gcc-8.5.0
parisc                randconfig-2200-20261116    gcc-8.5.0  smatch
parisc               randconfig-r2103-20261116    gcc-9.5.0  cocci
parisc               randconfig-r2109-20261116    clang-24   cocci
parisc               randconfig-r2301-20261116    gcc-16.2.0 sparse
parisc               randconfig-r2302-20261116    gcc-16.2.0 sparse
parisc               randconfig-r2303-20261116    gcc-16.2.0 sparse
parisc               randconfig-r2306-20261116    clang-20   sparse
parisc64                             defconfig    clang-24
powerpc                     adder875_defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc                       bamboo_defconfig    clang-24
powerpc                       cm5200_defconfig    clang-24
powerpc                       ep88xc_defconfig    clang-24
powerpc                        holly_defconfig    clang-24
powerpc                  mpc8313_rdb_defconfig    gcc-16.2.0
powerpc                  mpc836x_rdk_defconfig    clang-24
powerpc                        ppc64_defconfig    gcc-16.2.0
powerpc               randconfig-1000-20261117    gcc-9.5.0
powerpc               randconfig-1001-20261117    gcc-9.5.0
powerpc               randconfig-2000-20261116    clang-17
powerpc               randconfig-2000-20261116    clang-24
powerpc               randconfig-2001-20261116    clang-17
powerpc               randconfig-2001-20261116    clang-24
powerpc               randconfig-2002-20261116    clang-17
powerpc               randconfig-2002-20261116    gcc-8.5.0
powerpc               randconfig-2200-20261116    clang-22   smatch
powerpc              randconfig-r2102-20261116    clang-24   cocci
powerpc              randconfig-r2304-20261116    gcc-16.2.0 sparse
powerpc              randconfig-r2305-20261116    gcc-10.5.0 sparse
powerpc              randconfig-r2309-20261116    gcc-15.3.0 sparse
powerpc64             randconfig-1000-20261117    gcc-9.5.0
powerpc64             randconfig-1001-20261117    gcc-9.5.0
powerpc64             randconfig-2000-20261116    clang-17
powerpc64             randconfig-2000-20261116    gcc-10.5.0
powerpc64             randconfig-2001-20261116    clang-17
powerpc64             randconfig-2002-20261116    clang-17
powerpc64             randconfig-2002-20261116    gcc-14.4.0
powerpc64             randconfig-2200-20261116    clang-19   smatch
powerpc64            randconfig-r2100-20261116    gcc-9.5.0  cocci
powerpc64            randconfig-r2104-20261116    gcc-15.3.0 cocci
powerpc64            randconfig-r2106-20261116    gcc-14     cocci
powerpc64            randconfig-r2109-20261116    clang-24   cocci
powerpc64            randconfig-r2110-20261116    clang-24   cocci
powerpc64            randconfig-r2111-20261116    gcc-14     cocci
powerpc64            randconfig-r2111-20261116    gcc-8.5.0  cocci
powerpc64            randconfig-r2303-20261116    gcc-16.2.0 sparse
powerpc64            randconfig-r2305-20261116    gcc-11.5.0 sparse
powerpc64            randconfig-r2308-20261116    gcc-12.5.0 sparse
powerpc64            randconfig-r2308-20261116    gcc-8.5.0  sparse
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261117    clang-24
riscv                 randconfig-1001-20261117    clang-24
riscv                 randconfig-2000-20261116    clang-20
riscv                 randconfig-2000-20261116    gcc-8.5.0
riscv                 randconfig-2001-20261116    clang-20
riscv                 randconfig-2001-20261116    clang-24
riscv                 randconfig-2002-20261116    clang-20
riscv                 randconfig-2002-20261116    gcc-16.2.0
riscv                 randconfig-2003-20261116    clang-20
riscv                 randconfig-2004-20261116    clang-20
riscv                 randconfig-2004-20261116    clang-24
riscv                 randconfig-2005-20261116    clang-18
riscv                 randconfig-2005-20261116    clang-20
riscv                 randconfig-2200-20261116    clang-24   smatch
riscv                randconfig-r2106-20261116    clang-24   cocci
riscv                randconfig-r2304-20261116    gcc-16.2.0 sparse
riscv                randconfig-r2306-20261116    gcc-14.4.0 sparse
riscv                randconfig-r2311-20261116    clang-18   sparse
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261117    clang-24
s390                  randconfig-1001-20261117    clang-24
s390                  randconfig-2000-20261116    clang-17
s390                  randconfig-2001-20261116    clang-17
s390                  randconfig-2001-20261116    clang-24
s390                  randconfig-2002-20261116    clang-17
s390                  randconfig-2002-20261116    gcc-12.5.0
s390                  randconfig-2003-20261116    clang-17
s390                  randconfig-2003-20261116    gcc-8.5.0
s390                  randconfig-2004-20261116    clang-17
s390                  randconfig-2004-20261116    gcc-12.5.0
s390                  randconfig-2005-20261116    clang-17
s390                  randconfig-2200-20261116    gcc-10.5.0 smatch
s390                 randconfig-r2100-20261116    gcc-9.5.0  cocci
s390                 randconfig-r2101-20261116    gcc-9.5.0  cocci
s390                 randconfig-r2103-20261116    clang-24   cocci
s390                 randconfig-r2109-20261116    clang-24   cocci
s390                 randconfig-r2301-20261116    clang-24   sparse
s390                 randconfig-r2304-20261116    gcc-11.5.0 sparse
s390                 randconfig-r2310-20261116    gcc-12.5.0 sparse
s390                 randconfig-r2310-20261116    gcc-13.5.0 sparse
s390                 randconfig-r2311-20261116    gcc-14.4.0 sparse
s390                        zfcpdump_defconfig    gcc-16.2.0
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261117    clang-24
sh                    randconfig-1001-20261117    clang-24
sh                    randconfig-2000-20261116    gcc-15.3.0
sh                    randconfig-2000-20261116    gcc-9.5.0
sh                    randconfig-2001-20261116    gcc-11.5.0
sh                    randconfig-2001-20261116    gcc-15.3.0
sh                    randconfig-2002-20261116    gcc-13.5.0
sh                    randconfig-2002-20261116    gcc-15.3.0
sh                    randconfig-2003-20261116    gcc-15.3.0
sh                    randconfig-2004-20261116    gcc-15.3.0
sh                    randconfig-2004-20261116    gcc-16.2.0
sh                    randconfig-2005-20261116    gcc-15.3.0
sh                    randconfig-2200-20261116    gcc-15.3.0 smatch
sh                   randconfig-r2101-20261116    gcc-15.3.0 cocci
sh                   randconfig-r2300-20261116    gcc-15.3.0 sparse
sh                   randconfig-r2306-20261116    gcc-15.3.0 sparse
sh                   randconfig-r2309-20261116    clang-20   sparse
sh                   randconfig-r2311-20261116    gcc-15.3.0 sparse
sh                            sh2007_defconfig    clang-24
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261117    gcc-15.3.0
sparc                 randconfig-1001-20261117    gcc-15.3.0
sparc                 randconfig-2000-20261116    gcc-14
sparc                 randconfig-2001-20261116    gcc-14
sparc                 randconfig-2200-20261116    gcc-15.3.0 smatch
sparc                randconfig-r2100-20261116    gcc-15.3.0 cocci
sparc                randconfig-r2104-20261116    gcc-9.5.0  cocci
sparc                randconfig-r2304-20261116    gcc-16.2.0 sparse
sparc                randconfig-r2305-20261116    gcc-16.2.0 sparse
sparc                        sparc32_defconfig    gcc-16.2.0
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261117    gcc-15.3.0
sparc64               randconfig-1001-20261117    gcc-15.3.0
sparc64               randconfig-2000-20261116    gcc-14
sparc64               randconfig-2001-20261116    gcc-14
sparc64               randconfig-2200-20261116    gcc-8.5.0  smatch
sparc64              randconfig-r2102-20261116    gcc-15.3.0 cocci
sparc64              randconfig-r2103-20261116    clang-22   cocci
sparc64              randconfig-r2106-20261116    clang-24   cocci
sparc64              randconfig-r2300-20261116    gcc-16.2.0 sparse
sparc64              randconfig-r2301-20261116    gcc-16.2.0 sparse
sparc64              randconfig-r2306-20261116    clang-20   sparse
sparc64              randconfig-r2306-20261116    gcc-8.5.0  sparse
sparc64              randconfig-r2307-20261116    clang-20   sparse
um                                alldefconfig    clang-24
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    clang-24
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261117    gcc-15.3.0
um                    randconfig-1001-20261117    gcc-15.3.0
um                    randconfig-2000-20261116    gcc-14
um                    randconfig-2001-20261116    gcc-14
um                    randconfig-2200-20261116    gcc-14     smatch
um                   randconfig-r2105-20261116    gcc-15.3.0 cocci
um                   randconfig-r2110-20261116    clang-24   cocci
um                   randconfig-r2111-20261116    clang-24   cocci
um                   randconfig-r2301-20261116    gcc-16.2.0 sparse
um                   randconfig-r2307-20261116    clang-17   sparse
um                   randconfig-r2308-20261116    gcc-15.3.0 sparse
um                   randconfig-r2310-20261116    gcc-14.4.0 sparse
um                            x86_64_defconfig    gcc-14
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64      buildonly-randconfig-1000-20261117    gcc-14
x86_64      buildonly-randconfig-1001-20261117    clang-22
x86_64      buildonly-randconfig-1002-20261117    clang-22
x86_64      buildonly-randconfig-1003-20261117    clang-22
x86_64      buildonly-randconfig-1004-20261117    clang-22
x86_64      buildonly-randconfig-1005-20261117    gcc-13
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261117    clang-22
x86_64                randconfig-1001-20261117    clang-22
x86_64                randconfig-1002-20261117    clang-22
x86_64                randconfig-1002-20261117    gcc-14
x86_64                randconfig-1003-20261117    clang-22
x86_64                randconfig-1004-20261117    clang-22
x86_64                randconfig-1004-20261117    gcc-14
x86_64                randconfig-1005-20261117    clang-22
x86_64                randconfig-1005-20261117    gcc-14
x86_64                randconfig-1006-20261117    gcc-14
x86_64                randconfig-1007-20261117    gcc-14
x86_64                randconfig-1008-20261117    gcc-14
x86_64                randconfig-1009-20261117    gcc-14
x86_64                randconfig-1010-20261117    gcc-14
x86_64                randconfig-1011-20261117    gcc-14
x86_64                randconfig-1012-20261117    gcc-14
x86_64                randconfig-1013-20261117    gcc-14
x86_64                randconfig-1014-20261117    gcc-14
x86_64                randconfig-1015-20261117    gcc-14
x86_64                randconfig-1016-20261117    gcc-14
x86_64                randconfig-1017-20261117    gcc-14
x86_64                randconfig-2000-20261116    gcc-13
x86_64                randconfig-2000-20261116    gcc-14
x86_64                randconfig-2001-20261116    gcc-14
x86_64                randconfig-2002-20261116    clang-22
x86_64                randconfig-2002-20261116    gcc-14
x86_64                randconfig-2003-20261116    clang-22
x86_64                randconfig-2003-20261116    gcc-14
x86_64                randconfig-2004-20261116    gcc-14
x86_64                randconfig-2005-20261116    clang-22
x86_64                randconfig-2005-20261116    gcc-14
x86_64                randconfig-2100-20261116    gcc-14     cocci
x86_64                randconfig-2101-20261116    clang-22   cocci
x86_64                randconfig-2101-20261116    gcc-14     cocci
x86_64                randconfig-2102-20261116    gcc-14     cocci
x86_64                randconfig-2103-20261116    gcc-14     cocci
x86_64                randconfig-2104-20261116    gcc-14     cocci
x86_64                randconfig-2105-20261116    clang-22   cocci
x86_64                randconfig-2105-20261116    gcc-14     cocci
x86_64                randconfig-2200-20261116    clang-22   smatch
x86_64                randconfig-2300-20261116    gcc-14     sparse
x86_64                randconfig-2301-20261116    gcc-14     sparse
x86_64                randconfig-2302-20261116    gcc-14     sparse
x86_64               randconfig-r2105-20261116    gcc-9.5.0  cocci
x86_64               randconfig-r2109-20261116    gcc-14     cocci
x86_64               randconfig-r2308-20261116    clang-20   sparse
x86_64                                rhel-9.4    clang-22
x86_64                            rhel-9.4-bpf    clang-22
x86_64                            rhel-9.4-bpf    gcc-14
x86_64                           rhel-9.4-func    clang-22
x86_64                     rhel-9.4-kselftests    clang-22
x86_64                          rhel-9.4-kunit    clang-22
x86_64                          rhel-9.4-kunit    gcc-14
x86_64                            rhel-9.4-ltp    clang-22
x86_64                            rhel-9.4-ltp    gcc-14
x86_64                           rhel-9.4-rust    clang-22
x86_64                           rhel-9.4-rust    clang-22
xtensa                             allnoconfig    clang-24
xtensa                             allnoconfig    gcc-16.2.0
xtensa                            allyesconfig    clang-20
xtensa                            allyesconfig    gcc-16.2.0
xtensa                randconfig-1000-20261117    gcc-15.3.0
xtensa                randconfig-1001-20261117    gcc-15.3.0
xtensa                randconfig-2000-20261116    gcc-15.3.0
xtensa                randconfig-2000-20261116    gcc-16.2.0
xtensa                randconfig-2001-20261116    gcc-16.2.0
xtensa                randconfig-2001-20261116    gcc-8.5.0
xtensa                randconfig-2200-20261116    gcc-9.5.0  smatch
xtensa               randconfig-r2104-20261116    gcc-10.5.0 cocci
xtensa               randconfig-r2110-20261116    gcc-13.5.0 cocci
xtensa               randconfig-r2307-20261116    gcc-12.5.0 sparse
xtensa                          virt_defconfig    gcc-16.2.0
xtensa                     xip_kc705_defconfig    gcc-16.2.0

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

