Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A024606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Jlz9ITnA
Received: by kanga.kvack.org (Postfix)
	id 24D006B05C5; Sun, 22 Nov 2026 10:46:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE166B05C6; Sun, 22 Nov 2026 10:46:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF676B05C7; Sun, 22 Nov 2026 10:46:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D55B36B05C5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:46:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44CF9406FF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:46:40 +0000 (UTC)
X-FDA: 85463182560.08.D20D069
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf29.hostedemail.com (Postfix) with ESMTP id B3CA4120005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:46:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Jlz9ITnA;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362398;
	b=B6xKXllHCAAIaqNQjWT0et9xJ5VQE817uKuwAeYmx9I9QaFHTBXeUY4fol6Xq4m0NTwhz9
	AnkoJCgmFBYo4p1TtjXT7F3YJr8If7KCqr//0ljvcOS4HFh/C7axvJTwmFGKj42ljBnxHv
	I54yxMWOEwJnGNWiL6HshXqMAL0GtvE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=woUNk2YuGniTEz3myhrSfu5rXqxDi0FyBvM5hcfcBhY=;
	b=G9f2glKlp+kxCn+te2u3iFa2mcZ5aPggo06h8s/xsKT4IwXy0Nhhsa5XO6lbA6mhMh/4bF
	V2H8jzrLqiY75k7BIXr/u3xWOUm9kd+n+9oZHUU4qnIkrH2gLuA1vyRW1Dxg/eAeyiYPa7
	37Ux6c/0wHpqtbKGL+KiJ+4QY5bqVWc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Jlz9ITnA;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795362398; x=1826898398;
  h=date:from:to:cc:subject:message-id;
  bh=CCMlXnc2NGHqMouotOUfe3Nk1BGULNcmIwNV3dfolbg=;
  b=Jlz9ITnAFc2s13waF81jigicQxyrEzpH/WqP6kUkuUh5cGDPQ8hiRxy+
   SEQ26t5QYoCxZKlUMeDlZdKt90qcu0FuUlxyNisYT+3jx/MkWMr6/qfw3
   upB8MmZv6SHscnrXnGiJognpzTa6cbU4crNpvyunx+0wvlfXsU1J7tntE
   bW8Ba+A7ZcUIGtVyMTqrTQ85pzjNkYLo6+krErRO2fPBSDm3PhX0e8pmB
   njTTBzfAtK5Z0yECep0TPoEjIdU4axssACC8zmQaH9SDeASUtS1qM07EB
   +sOkV3WUZKL53w9+NTtkcpmhhhGWnTENZOliMRYozxK2/6HhcmwcfXaT+
   g==;
X-CSE-ConnectionGUID: kPZFJ8ZRQDefIOhq2cAHzQ==
X-CSE-MsgGUID: Ojp7Dxb/T9y4qx4TvfYswA==
X-IronPort-AV: E=McAfee;i="6800,10657,11974"; a="4165143"
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="4165143"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2026 07:46:36 -0800
X-CSE-ConnectionGUID: afGcXC5qRKKdWwMMQgeRNA==
X-CSE-MsgGUID: t4k4lGWjQCaavXUAMtVg/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="11434619"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 22 Nov 2026 07:46:35 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xV9lw-00000001Lg6-07GW;
	Sun, 22 Nov 2026 15:46:32 +0000
Date: Sun, 22 Nov 2026 23:45:49 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new] BUILD SUCCESS
 7d1a16abe4cc5dccd21e3d6262e44433a5885d27
Message-ID: <20261122234549.X7lDSIjS-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B3CA4120005
X-Stat-Signature: gtf9wnsb4j3oatgri53kdd1xekbxbx4b
X-Rspam-User:
X-HE-Tag: 1795362397-805135
X-HE-Meta: U2FsdGVkX19e10Lx8GCq251ErpIxrZsLpAX99Th8pLv7ZevC64DK/J17VqmDJYm0I2PzesCdDCnk4xA4knPRQMmIDQRsxr9ivsTjWOv1nGGieUexu8NxYoR5mu8s2sTYhZEZnyqUe6lz2R0WJRpb8ontvQ5Y1sbqdpHMQQHzbOUed+LC1jNrPS9EvGZYq0bvNGXU7B6y+p3D9pqSmOrTa/xtZ/vQa09UG+UYppIRyN0Pzd4TBXPG3k+92GecsGA5q1+g2/oiHGqUEnZErSbSSlPckI4ITQpXrn/FIJYTAHfiNCqx/6DCrjWbciILO1wc3PNNSVqIkTe+DOBPRm1n+28HiDGahGVG0TTCWPpNITG18zg7JuxjO8yDhKCP3ewzL9ALtR6G8zK8wpM5wrtaqT64yPueORlv0zpuWZQZp7c8TGYcECV5FMxJS0EkhAtIdcy0nvaWh1dmck0lwygm6VBJhAuHJQwMjobNk5LxocD6tEvs0pWNbMiUkYWKGmiMagl6WlOA45e0sHCDAKZUIzQoQTrZaGUZ34l9jLwafpt17da+XYEexeSzvjKdHwR0Dt/lUCDANagALOzM4nrfdlzy4GUYXiG5w4UJm5sZJdQ81i0VNwnhXtcj79+cqUGuOdIj0ZLjSdPpPbjcEesDu/qiGR98eWURQeEeWUP5qUjwyJoMvVCbTyejAfD47gtiffFKZ+OSzcntGl7WP87epPwIsfAxbtsxuwJ2U+TdUPJMQuAz3uBVs+dRzf1a4a+w3bjhOJ8OWURMeCuF1/ulJzcopCcx4ykWZJUj2VWOKtl9z7xY9HpRRVXmUOxA/3floqZwZ8oY+67g/jkJOYW9T0wMLXllY6vTzXDFOpDftdf1i47aNFSCqj8cW4eawryi2v5yWPOdiR7Yc25TX1fKGgRAdVOu7XGQ6vH9jwFcFg9FXmlQ7K3XKs6hEIBTa9jkHcRGx6n3ZQxJakFPB1c
 7bFd16xG
 GHRjR6UT1ufN5oCdI5bASH1sc3Gd3R+gE5ym/OVIziVzmfQATSdsrRQf5YrRQjpFZacVV8cYPRgN9nPpwYl1qG0VL1vLmqFWtG1uh/zGtof9Gdwtlo+oEPZVnqBTG5tqokmkdpKsodz+lEmpWnQGUSY8Isp5NbgK2vh2ReQObFgZ1s4pY3YIPDHLNHMDhqXUlwB64UhrTCid8+v7tfGW+P9RFmnRKKNlzyO4L31bzZlcqK+2YeAsBQQQa/9rs78f35anmsLQV6+Ug9/Ytl/fPWOfBzV83AkHUzo93YdQ9H7CmHjCQtTquvel2R9Iss7CxWyYtFleuLPjNQyYSId0US7QmwuwaEl8kj/1FhTrcJ5r709mqGklseZBn7HV9jEVDiVK8SkhRJ41uP88y4WVRGZc3sIb/0g54C/dT8L7LUTtLM3yUafvC9lXh5JAqDxkZv7Rrr93dgDAVpqL+CE8N8b9wVufYKs7LuFSi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
branch HEAD: 7d1a16abe4cc5dccd21e3d6262e44433a5885d27  mm: vmstat_kunit: add synthetic benchmark for mm stats

elapsed time: 1128m

configs tested: 517
configs skipped: 13

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                              allnoconfig    gcc-16.2.0
alpha                             allyesconfig    gcc-16.2.0
alpha                                defconfig    gcc-16.2.0
alpha                 randconfig-2000-20261121    gcc-14.4.0
alpha                 randconfig-2000-20261121    gcc-16.2.0
alpha                 randconfig-2001-20261121    gcc-14.4.0
alpha                 randconfig-2200-20261121    gcc-10.5.0 smatch
alpha                randconfig-r2100-20261121    gcc-16.2.0 cocci
alpha                randconfig-r2100-20261121    gcc-8.5.0  cocci
alpha                randconfig-r2110-20261121    gcc-11.5.0 cocci
alpha                randconfig-r2111-20261121    gcc-13.5.0 cocci
alpha                randconfig-r2302-20261121    gcc-8.5.0  sparse
alpha                randconfig-r2309-20261121    gcc-11.5.0 sparse
arc                               allmodconfig    clang-24
arc                               allmodconfig    gcc-16.2.0
arc                                allnoconfig    gcc-16.2.0
arc                               allyesconfig    clang-24
arc                               allyesconfig    gcc-16.2.0
arc                                  defconfig    gcc-16.2.0
arc                   randconfig-1000-20261122    clang-17
arc                   randconfig-1001-20261122    clang-17
arc                   randconfig-2000-20261121    gcc-8.5.0
arc                   randconfig-2001-20261121    gcc-10.5.0
arc                   randconfig-2001-20261121    gcc-8.5.0
arc                   randconfig-2002-20261121    gcc-16.2.0
arc                   randconfig-2002-20261121    gcc-8.5.0
arc                   randconfig-2003-20261121    gcc-14.4.0
arc                   randconfig-2003-20261121    gcc-8.5.0
arc                   randconfig-2004-20261121    gcc-12.5.0
arc                   randconfig-2004-20261121    gcc-8.5.0
arc                   randconfig-2005-20261121    gcc-8.5.0
arc                   randconfig-2200-20261121    gcc-14.4.0 smatch
arc                  randconfig-r2102-20261121    gcc-11.5.0 cocci
arc                  randconfig-r2302-20261121    gcc-13.5.0 sparse
arc                  randconfig-r2303-20261121    gcc-13.5.0 sparse
arc                  randconfig-r2310-20261121    gcc-10.5.0 sparse
arm                                allnoconfig    clang-17
arm                                allnoconfig    gcc-16.2.0
arm                               allyesconfig    clang-24
arm                               allyesconfig    gcc-16.2.0
arm                                  defconfig    gcc-16.2.0
arm                   randconfig-1000-20261122    clang-17
arm                   randconfig-1001-20261122    clang-17
arm                   randconfig-1002-20261122    clang-17
arm                   randconfig-1003-20261122    clang-17
arm                   randconfig-2000-20261121    clang-17
arm                   randconfig-2000-20261121    clang-24
arm                   randconfig-2001-20261121    clang-24
arm                   randconfig-2002-20261121    clang-24
arm                   randconfig-2200-20261121    clang-19   smatch
arm                  randconfig-r2103-20261121    gcc-8.5.0  cocci
arm                  randconfig-r2106-20261121    clang-24   cocci
arm                  randconfig-r2106-20261121    gcc-11.5.0 cocci
arm                  randconfig-r2108-20261121    clang-18   cocci
arm                  randconfig-r2108-20261121    clang-20   cocci
arm                  randconfig-r2304-20261121    gcc-8.5.0  sparse
arm                  randconfig-r2305-20261121    gcc-8.5.0  sparse
arm64                             allmodconfig    clang-24
arm64                              allnoconfig    gcc-16.2.0
arm64                                defconfig    gcc-16.2.0
arm64                 randconfig-1000-20261122    gcc-8.5.0
arm64                 randconfig-1001-20261122    gcc-8.5.0
arm64                 randconfig-1002-20261122    gcc-8.5.0
arm64                 randconfig-1003-20261122    gcc-8.5.0
arm64                 randconfig-2000-20261121    clang-24
arm64                 randconfig-2000-20261121    gcc-15.3.0
arm64                 randconfig-2001-20261121    clang-24
arm64                 randconfig-2001-20261121    gcc-13.5.0
arm64                 randconfig-2002-20261121    clang-24
arm64                 randconfig-2200-20261121    clang-22   smatch
arm64                randconfig-r2100-20261121    gcc-15.3.0 cocci
arm64                randconfig-r2104-20261121    gcc-15.3.0 cocci
arm64                randconfig-r2105-20261121    gcc-16.2.0 cocci
arm64                randconfig-r2105-20261121    gcc-8.5.0  cocci
arm64                randconfig-r2111-20261121    clang-24   cocci
arm64                randconfig-r2301-20261121    gcc-11.5.0 sparse
arm64                randconfig-r2302-20261121    clang-24   sparse
arm64                randconfig-r2305-20261121    clang-24   sparse
arm64                randconfig-r2307-20261121    gcc-10.5.0 sparse
arm64                randconfig-r2308-20261121    gcc-11.5.0 sparse
arm64                randconfig-r2310-20261121    clang-22   sparse
arm64                randconfig-r2310-20261121    gcc-14     sparse
arm64                randconfig-r2311-20261121    clang-24   sparse
csky                              allmodconfig    gcc-16.2.0
csky                               allnoconfig    gcc-16.2.0
csky                                 defconfig    gcc-16.2.0
csky                  randconfig-1000-20261122    gcc-8.5.0
csky                  randconfig-1001-20261122    gcc-8.5.0
csky                  randconfig-2000-20261121    gcc-16.2.0
csky                  randconfig-2001-20261121    gcc-16.2.0
csky                  randconfig-2200-20261121    gcc-16.2.0 smatch
csky                 randconfig-r2101-20261121    gcc-16.2.0 cocci
csky                 randconfig-r2105-20261121    gcc-16.2.0 cocci
csky                 randconfig-r2107-20261121    gcc-16.2.0 cocci
csky                 randconfig-r2109-20261121    gcc-13.5.0 cocci
csky                 randconfig-r2300-20261121    clang-24   sparse
csky                 randconfig-r2306-20261121    clang-22   sparse
csky                 randconfig-r2306-20261121    gcc-10.5.0 sparse
csky                 randconfig-r2310-20261121    gcc-12.5.0 sparse
hexagon                           allmodconfig    clang-24
hexagon                           allmodconfig    gcc-16.2.0
hexagon                            allnoconfig    clang-24
hexagon                            allnoconfig    gcc-16.2.0
hexagon                              defconfig    gcc-16.2.0
hexagon               randconfig-1000-20261122    gcc-8.5.0
hexagon               randconfig-1001-20261122    gcc-8.5.0
hexagon               randconfig-2000-20261121    gcc-16.2.0
hexagon               randconfig-2001-20261121    gcc-16.2.0
hexagon               randconfig-2200-20261121    clang-24   smatch
hexagon              randconfig-r2102-20261121    gcc-15.3.0 cocci
hexagon              randconfig-r2102-20261121    gcc-16.2.0 cocci
hexagon              randconfig-r2103-20261121    gcc-15.3.0 cocci
hexagon              randconfig-r2104-20261121    gcc-16.2.0 cocci
hexagon              randconfig-r2303-20261121    clang-24   sparse
hexagon              randconfig-r2304-20261121    clang-24   sparse
hexagon              randconfig-r2306-20261121    clang-24   sparse
hexagon              randconfig-r2309-20261121    clang-20   sparse
i386                              allmodconfig    clang-22
i386                              allmodconfig    gcc-14
i386                               allnoconfig    gcc-14
i386                               allnoconfig    gcc-16.2.0
i386                              allyesconfig    clang-22
i386                              allyesconfig    gcc-14
i386        buildonly-randconfig-1000-20261122    gcc-14
i386        buildonly-randconfig-1001-20261122    gcc-14
i386        buildonly-randconfig-1002-20261122    gcc-14
i386        buildonly-randconfig-1003-20261122    gcc-14
i386        buildonly-randconfig-1004-20261122    gcc-14
i386        buildonly-randconfig-1005-20261122    gcc-14
i386                                 defconfig    gcc-16.2.0
i386                  randconfig-1000-20261122    gcc-14
i386                  randconfig-1001-20261122    gcc-14
i386                  randconfig-1002-20261122    gcc-14
i386                  randconfig-1003-20261122    gcc-14
i386                  randconfig-1004-20261122    gcc-14
i386                  randconfig-1005-20261122    gcc-14
i386                  randconfig-1006-20261122    gcc-14
i386                  randconfig-1007-20261122    gcc-14
i386                  randconfig-1008-20261122    gcc-14
i386                  randconfig-1009-20261122    gcc-14
i386                  randconfig-1010-20261122    gcc-14
i386                  randconfig-1011-20261122    gcc-14
i386                  randconfig-1012-20261122    gcc-14
i386                  randconfig-1013-20261122    gcc-14
i386                  randconfig-2000-20261121    gcc-14
i386                  randconfig-2001-20261121    gcc-14
i386                  randconfig-2002-20261121    gcc-14
i386                  randconfig-2003-20261121    clang-22
i386                  randconfig-2003-20261121    gcc-14
i386                  randconfig-2004-20261121    gcc-14
i386                  randconfig-2005-20261121    gcc-14
i386                  randconfig-2100-20261121    clang-22   cocci
i386                  randconfig-2101-20261121    clang-22   cocci
i386                  randconfig-2102-20261121    clang-22   cocci
i386                  randconfig-2103-20261121    clang-22   cocci
i386                  randconfig-2104-20261121    clang-22   cocci
i386                  randconfig-2105-20261121    clang-22   cocci
i386                  randconfig-2200-20261121    clang-22   smatch
i386                  randconfig-2300-20261121    clang-22   sparse
i386                  randconfig-2300-20261121    gcc-14     sparse
i386                  randconfig-2301-20261121    gcc-14     sparse
i386                  randconfig-2302-20261121    gcc-13     sparse
i386                  randconfig-2302-20261121    gcc-14     sparse
i386                 randconfig-r2111-20261121    clang-20   cocci
i386                 randconfig-r2300-20261121    gcc-8.5.0  sparse
i386                 randconfig-r2311-20261121    gcc-10.5.0 sparse
i386                 randconfig-r2311-20261121    gcc-11.5.0 sparse
loongarch                         allmodconfig    clang-19
loongarch                         allmodconfig    clang-24
loongarch                          allnoconfig    clang-20
loongarch                          allnoconfig    gcc-16.2.0
loongarch                            defconfig    clang-24
loongarch             randconfig-1000-20261122    gcc-8.5.0
loongarch             randconfig-1001-20261122    gcc-8.5.0
loongarch             randconfig-2000-20261121    clang-22
loongarch             randconfig-2001-20261121    clang-22
loongarch             randconfig-2001-20261121    gcc-16.2.0
loongarch             randconfig-2200-20261121    gcc-16.2.0 smatch
loongarch            randconfig-r2100-20261121    gcc-8.5.0  cocci
loongarch            randconfig-r2102-20261121    gcc-16.2.0 cocci
loongarch            randconfig-r2302-20261121    clang-24   sparse
loongarch            randconfig-r2306-20261121    clang-20   sparse
loongarch            randconfig-r2311-20261121    clang-22   sparse
m68k                              allmodconfig    gcc-16.2.0
m68k                               allnoconfig    gcc-16.2.0
m68k                              allyesconfig    clang-24
m68k                              allyesconfig    gcc-16.2.0
m68k                                 defconfig    clang-24
m68k                  randconfig-2000-20261121    gcc-13.5.0
m68k                  randconfig-2000-20261121    gcc-14.4.0
m68k                  randconfig-2001-20261121    gcc-14.4.0
m68k                  randconfig-2001-20261121    gcc-8.5.0
m68k                  randconfig-2200-20261121    gcc-8.5.0  smatch
m68k                 randconfig-r2106-20261121    gcc-8.5.0  cocci
m68k                 randconfig-r2107-20261121    clang-24   cocci
m68k                 randconfig-r2107-20261121    gcc-8.5.0  cocci
m68k                 randconfig-r2111-20261121    gcc-11.5.0 cocci
microblaze                         allnoconfig    gcc-16.2.0
microblaze                        allyesconfig    gcc-16.2.0
microblaze                           defconfig    clang-24
microblaze            randconfig-2000-20261121    gcc-14.4.0
microblaze            randconfig-2000-20261121    gcc-8.5.0
microblaze            randconfig-2001-20261121    gcc-10.5.0
microblaze            randconfig-2001-20261121    gcc-14.4.0
microblaze            randconfig-2200-20261121    gcc-8.5.0  smatch
microblaze           randconfig-r2101-20261121    gcc-16.2.0 cocci
microblaze           randconfig-r2105-20261121    gcc-15.3.0 cocci
microblaze           randconfig-r2106-20261121    clang-20   cocci
microblaze           randconfig-r2109-20261121    gcc-11.5.0 cocci
microblaze           randconfig-r2304-20261121    gcc-13.5.0 sparse
microblaze           randconfig-r2308-20261121    gcc-10.5.0 sparse
microblaze           randconfig-r2311-20261121    clang-20   sparse
mips                              allmodconfig    gcc-16.2.0
mips                               allnoconfig    gcc-16.2.0
mips                              allyesconfig    gcc-16.2.0
mips                  randconfig-2000-20261121    clang-24
mips                  randconfig-2000-20261121    gcc-16.2.0
mips                  randconfig-2001-20261121    gcc-16.2.0
mips                  randconfig-2001-20261121    gcc-8.5.0
mips                  randconfig-2002-20261121    clang-24
mips                  randconfig-2002-20261121    gcc-16.2.0
mips                  randconfig-2200-20261121    clang-21   smatch
mips                 randconfig-r2109-20261121    clang-18   cocci
mips                 randconfig-r2109-20261121    clang-24   cocci
mips                 randconfig-r2111-20261121    gcc-8.5.0  cocci
mips                 randconfig-r2308-20261121    clang-20   sparse
mips                 randconfig-r2310-20261121    gcc-8.5.0  sparse
nios2                             allmodconfig    clang-20
nios2                             allmodconfig    gcc-11.5.0
nios2                              allnoconfig    clang-24
nios2                              allnoconfig    gcc-11.5.0
nios2                                defconfig    clang-24
nios2                 randconfig-1000-20261122    gcc-8.5.0
nios2                 randconfig-1001-20261122    gcc-8.5.0
nios2                 randconfig-2000-20261121    clang-22
nios2                 randconfig-2000-20261121    gcc-11.5.0
nios2                 randconfig-2001-20261121    clang-22
nios2                 randconfig-2001-20261121    gcc-8.5.0
nios2                 randconfig-2200-20261121    gcc-10.5.0 smatch
nios2                randconfig-r2101-20261121    gcc-8.5.0  cocci
nios2                randconfig-r2105-20261121    gcc-11.5.0 cocci
nios2                randconfig-r2106-20261121    gcc-13.5.0 cocci
nios2                randconfig-r2108-20261121    gcc-11.5.0 cocci
nios2                randconfig-r2303-20261121    gcc-11.5.0 sparse
openrisc                          allmodconfig    clang-20
openrisc                          allmodconfig    gcc-16.2.0
openrisc                           allnoconfig    clang-24
openrisc                           allnoconfig    gcc-16.2.0
openrisc                             defconfig    gcc-16.2.0
openrisc              randconfig-2000-20261121    gcc-12.5.0
openrisc              randconfig-2000-20261121    gcc-16.2.0
openrisc              randconfig-2001-20261121    gcc-14.4.0
openrisc              randconfig-2001-20261121    gcc-16.2.0
openrisc              randconfig-2002-20261121    gcc-16.2.0
openrisc              randconfig-2200-20261121    gcc-14.4.0 smatch
openrisc             randconfig-r2102-20261121    gcc-8.5.0  cocci
openrisc             randconfig-r2104-20261121    gcc-8.5.0  cocci
openrisc             randconfig-r2106-20261121    clang-18   cocci
openrisc             randconfig-r2106-20261121    gcc-8.5.0  cocci
openrisc             randconfig-r2111-20261121    clang-18   cocci
openrisc             randconfig-r2302-20261121    gcc-11.5.0 sparse
openrisc             randconfig-r2303-20261121    gcc-11.5.0 sparse
openrisc             randconfig-r2308-20261121    gcc-10.5.0 sparse
openrisc             randconfig-r2309-20261121    gcc-14     sparse
parisc                            allmodconfig    gcc-16.2.0
parisc                             allnoconfig    clang-24
parisc                             allnoconfig    gcc-16.2.0
parisc                            allyesconfig    clang-17
parisc                            allyesconfig    gcc-16.2.0
parisc                               defconfig    gcc-16.2.0
parisc                randconfig-1000-20261122    clang-24
parisc                randconfig-1001-20261122    clang-24
parisc                randconfig-2000-20261121    clang-22
parisc                randconfig-2000-20261121    gcc-10.5.0
parisc                randconfig-2001-20261121    clang-22
parisc                randconfig-2001-20261121    gcc-16.2.0
parisc                randconfig-2200-20261121    gcc-16.2.0 smatch
parisc               randconfig-r2103-20261121    gcc-16.2.0 cocci
parisc               randconfig-r2103-20261121    gcc-8.5.0  cocci
parisc               randconfig-r2107-20261121    clang-18   cocci
parisc               randconfig-r2107-20261121    gcc-13.5.0 cocci
parisc               randconfig-r2300-20261121    gcc-11.5.0 sparse
parisc               randconfig-r2308-20261121    gcc-12.5.0 sparse
parisc               randconfig-r2311-20261121    gcc-14     sparse
parisc64                             defconfig    clang-24
powerpc                           allmodconfig    gcc-16.2.0
powerpc                            allnoconfig    clang-24
powerpc                            allnoconfig    gcc-16.2.0
powerpc               randconfig-1000-20261122    clang-24
powerpc               randconfig-1001-20261122    clang-24
powerpc               randconfig-2000-20261121    clang-24
powerpc               randconfig-2001-20261121    clang-24
powerpc               randconfig-2001-20261121    gcc-15.3.0
powerpc               randconfig-2002-20261121    clang-24
powerpc               randconfig-2200-20261121    gcc-11.5.0 smatch
powerpc              randconfig-r2107-20261121    gcc-11.5.0 cocci
powerpc              randconfig-r2301-20261121    clang-24   sparse
powerpc              randconfig-r2305-20261121    gcc-11.5.0 sparse
powerpc              randconfig-r2309-20261121    gcc-10.5.0 sparse
powerpc              randconfig-r2310-20261121    gcc-11.5.0 sparse
powerpc64             randconfig-1000-20261122    clang-24
powerpc64             randconfig-1001-20261122    clang-24
powerpc64             randconfig-2000-20261121    clang-24
powerpc64             randconfig-2001-20261121    clang-24
powerpc64             randconfig-2001-20261121    gcc-10.5.0
powerpc64             randconfig-2002-20261121    clang-24
powerpc64             randconfig-2002-20261121    gcc-8.5.0
powerpc64             randconfig-2200-20261121    gcc-10.5.0 smatch
powerpc64            randconfig-r2102-20261121    gcc-8.5.0  cocci
powerpc64            randconfig-r2300-20261121    gcc-8.5.0  sparse
powerpc64            randconfig-r2303-20261121    gcc-8.5.0  sparse
powerpc64            randconfig-r2304-20261121    gcc-11.5.0 sparse
powerpc64            randconfig-r2307-20261121    gcc-12.5.0 sparse
riscv                             allmodconfig    clang-24
riscv                              allnoconfig    clang-24
riscv                              allnoconfig    gcc-16.2.0
riscv                             allyesconfig    clang-24
riscv                                defconfig    gcc-16.2.0
riscv                 randconfig-1000-20261122    gcc-9.5.0
riscv                 randconfig-1001-20261122    gcc-9.5.0
riscv                 randconfig-2000-20261121    gcc-9.5.0
riscv                 randconfig-2001-20261121    gcc-11.5.0
riscv                 randconfig-2001-20261121    gcc-9.5.0
riscv                 randconfig-2002-20261121    clang-17
riscv                 randconfig-2002-20261121    gcc-9.5.0
riscv                 randconfig-2003-20261121    gcc-11.5.0
riscv                 randconfig-2003-20261121    gcc-9.5.0
riscv                 randconfig-2004-20261121    gcc-8.5.0
riscv                 randconfig-2004-20261121    gcc-9.5.0
riscv                 randconfig-2005-20261121    clang-17
riscv                 randconfig-2005-20261121    gcc-9.5.0
riscv                 randconfig-2200-20261121    clang-24   smatch
riscv                randconfig-r2108-20261121    clang-24   cocci
riscv                randconfig-r2301-20261121    gcc-15.3.0 sparse
s390                              allmodconfig    clang-17
s390                              allmodconfig    clang-24
s390                               allnoconfig    clang-24
s390                              allyesconfig    gcc-16.2.0
s390                                 defconfig    gcc-16.2.0
s390                  randconfig-1000-20261122    gcc-9.5.0
s390                  randconfig-1001-20261122    gcc-9.5.0
s390                  randconfig-2000-20261121    clang-22
s390                  randconfig-2000-20261121    clang-24
s390                  randconfig-2001-20261121    clang-22
s390                  randconfig-2001-20261121    clang-24
s390                  randconfig-2002-20261121    clang-22
s390                  randconfig-2003-20261121    clang-20
s390                  randconfig-2003-20261121    clang-22
s390                  randconfig-2004-20261121    clang-22
s390                  randconfig-2004-20261121    gcc-9.5.0
s390                  randconfig-2005-20261121    clang-22
s390                  randconfig-2005-20261121    gcc-15.3.0
s390                  randconfig-2200-20261121    gcc-8.5.0  smatch
s390                 randconfig-r2101-20261121    gcc-15.3.0 cocci
s390                 randconfig-r2107-20261121    clang-20   cocci
s390                 randconfig-r2110-20261121    clang-20   cocci
s390                 randconfig-r2110-20261121    gcc-13.5.0 cocci
s390                 randconfig-r2303-20261121    clang-24   sparse
s390                 randconfig-r2305-20261121    gcc-9.5.0  sparse
s390                 randconfig-r2306-20261121    gcc-11.5.0 sparse
sh                                allmodconfig    gcc-16.2.0
sh                                 allnoconfig    clang-24
sh                                 allnoconfig    gcc-16.2.0
sh                                allyesconfig    clang-17
sh                                allyesconfig    gcc-16.2.0
sh                                   defconfig    gcc-14
sh                    randconfig-1000-20261122    gcc-9.5.0
sh                    randconfig-1001-20261122    gcc-9.5.0
sh                    randconfig-2000-20261121    gcc-12.5.0
sh                    randconfig-2000-20261121    gcc-16.2.0
sh                    randconfig-2001-20261121    gcc-10.5.0
sh                    randconfig-2001-20261121    gcc-16.2.0
sh                    randconfig-2002-20261121    gcc-16.2.0
sh                    randconfig-2003-20261121    gcc-16.2.0
sh                    randconfig-2004-20261121    gcc-16.2.0
sh                    randconfig-2005-20261121    gcc-10.5.0
sh                    randconfig-2005-20261121    gcc-16.2.0
sh                    randconfig-2200-20261121    gcc-10.5.0 smatch
sh                   randconfig-r2100-20261121    gcc-16.2.0 cocci
sh                   randconfig-r2101-20261121    gcc-8.5.0  cocci
sh                   randconfig-r2104-20261121    gcc-8.5.0  cocci
sh                   randconfig-r2108-20261121    gcc-16.2.0 cocci
sh                   randconfig-r2110-20261121    clang-24   cocci
sh                   randconfig-r2306-20261121    gcc-14     sparse
sh                   randconfig-r2307-20261121    gcc-11.5.0 sparse
sh                   randconfig-r2308-20261121    clang-22   sparse
sparc                              allnoconfig    clang-24
sparc                              allnoconfig    gcc-16.2.0
sparc                                defconfig    gcc-16.2.0
sparc                 randconfig-1000-20261122    clang-24
sparc                 randconfig-1001-20261122    clang-24
sparc                 randconfig-2000-20261121    gcc-16.2.0
sparc                 randconfig-2000-20261121    gcc-8.5.0
sparc                 randconfig-2001-20261121    gcc-14.4.0
sparc                 randconfig-2001-20261121    gcc-8.5.0
sparc                 randconfig-2200-20261121    gcc-8.5.0  smatch
sparc                randconfig-r2100-20261121    gcc-16.2.0 cocci
sparc                randconfig-r2103-20261121    gcc-14.4.0 cocci
sparc                randconfig-r2105-20261121    gcc-8.5.0  cocci
sparc                randconfig-r2109-20261121    gcc-8.5.0  cocci
sparc                randconfig-r2110-20261121    clang-18   cocci
sparc                randconfig-r2301-20261121    gcc-11.5.0 sparse
sparc                randconfig-r2304-20261121    clang-24   sparse
sparc                randconfig-r2305-20261121    gcc-13.5.0 sparse
sparc                randconfig-r2310-20261121    clang-20   sparse
sparc                randconfig-r2311-20261121    gcc-12.5.0 sparse
sparc64                           allmodconfig    clang-20
sparc64                              defconfig    gcc-14
sparc64               randconfig-1000-20261122    clang-24
sparc64               randconfig-1001-20261122    clang-24
sparc64               randconfig-2000-20261121    gcc-8.5.0
sparc64               randconfig-2000-20261121    gcc-9.5.0
sparc64               randconfig-2001-20261121    gcc-8.5.0
sparc64               randconfig-2200-20261121    clang-20   smatch
sparc64              randconfig-r2108-20261121    gcc-8.5.0  cocci
sparc64              randconfig-r2109-20261121    clang-20   cocci
sparc64              randconfig-r2301-20261121    gcc-8.5.0  sparse
sparc64              randconfig-r2302-20261121    gcc-11.5.0 sparse
sparc64              randconfig-r2309-20261121    gcc-9.5.0  sparse
um                                allmodconfig    clang-17
um                                 allnoconfig    clang-17
um                                 allnoconfig    clang-24
um                                allyesconfig    gcc-14
um                                allyesconfig    gcc-16.2.0
um                                   defconfig    gcc-14
um                              i386_defconfig    gcc-14
um                    randconfig-1000-20261122    clang-24
um                    randconfig-1001-20261122    clang-24
um                    randconfig-2000-20261121    clang-17
um                    randconfig-2000-20261121    gcc-8.5.0
um                    randconfig-2001-20261121    clang-24
um                    randconfig-2001-20261121    gcc-8.5.0
um                    randconfig-2200-20261121    gcc-14     smatch
um                   randconfig-r2104-20261121    gcc-14     cocci
um                   randconfig-r2108-20261121    gcc-13.5.0 cocci
um                   randconfig-r2307-20261121    clang-22   sparse
um                   randconfig-r2307-20261121    gcc-14     sparse
um                   randconfig-r2309-20261121    gcc-12.5.0 sparse
um                            x86_64_defconfig    gcc-14
x86_64                            allmodconfig    clang-22
x86_64                             allnoconfig    clang-22
x86_64                             allnoconfig    clang-24
x86_64                            allyesconfig    clang-22
x86_64                               defconfig    gcc-14
x86_64                                   kexec    clang-22
x86_64                randconfig-1000-20261122    gcc-14
x86_64                randconfig-1001-20261122    gcc-14
x86_64                randconfig-1002-20261122    gcc-14
x86_64                randconfig-1003-20261122    gcc-14
x86_64                randconfig-1004-20261122    gcc-14
x86_64                randconfig-1005-20261122    gcc-14
x86_64                randconfig-1012-20261122    clang-22
x86_64                randconfig-1013-20261122    clang-22
x86_64                randconfig-1014-20261122    clang-22
x86_64                randconfig-1015-20261122    clang-22
x86_64                randconfig-1016-20261122    clang-22
x86_64                randconfig-1017-20261122    clang-22
x86_64                randconfig-2000-20261121    clang-22
x86_64                randconfig-2000-20261121    gcc-14
x86_64                randconfig-2001-20261121    clang-22
x86_64                randconfig-2001-20261121    gcc-14
x86_64                randconfig-2002-20261121    clang-22
x86_64                randconfig-2002-20261121    gcc-14
x86_64                randconfig-2003-20261121    gcc-14
x86_64                randconfig-2004-20261121    gcc-14
x86_64                randconfig-2005-20261121    clang-22
x86_64                randconfig-2005-20261121    gcc-14
x86_64                randconfig-2100-20261121    clang-22   cocci
x86_64                randconfig-2100-20261121    gcc-14     cocci
x86_64                randconfig-2101-20261121    gcc-14     cocci
x86_64                randconfig-2102-20261121    gcc-14     cocci
x86_64                randconfig-2103-20261121    clang-22   cocci
x86_64                randconfig-2103-20261121    gcc-14     cocci
x86_64                randconfig-2104-20261121    clang-22   cocci
x86_64                randconfig-2104-20261121    gcc-14     cocci
x86_64                randconfig-2105-20261121    gcc-14     cocci
x86_64                randconfig-2200-20261121    gcc-14     smatch
x86_64                randconfig-2300-20261121    clang-22   sparse
x86_64                randconfig-2300-20261121    gcc-14     sparse
x86_64                randconfig-2301-20261121    gcc-14     sparse
x86_64                randconfig-2302-20261121    gcc-13     sparse
x86_64                randconfig-2302-20261121    gcc-14     sparse
x86_64               randconfig-r2103-20261121    gcc-16.2.0 cocci
x86_64               randconfig-r2109-20261121    clang-22   cocci
x86_64               randconfig-r2110-20261121    gcc-8.5.0  cocci
x86_64               randconfig-r2111-20261121    clang-22   cocci
x86_64               randconfig-r2300-20261121    gcc-11.5.0 sparse
x86_64               randconfig-r2306-20261121    gcc-12.5.0 sparse
x86_64               randconfig-r2307-20261121    clang-20   sparse
x86_64               randconfig-r2307-20261121    gcc-14     sparse
x86_64               randconfig-r2308-20261121    gcc-14     sparse
x86_64               randconfig-r2309-20261121    clang-22   sparse
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
xtensa                randconfig-1000-20261122    clang-24
xtensa                randconfig-1001-20261122    clang-24
xtensa                randconfig-2000-20261121    gcc-16.2.0
xtensa                randconfig-2001-20261121    gcc-16.2.0
xtensa                randconfig-2200-20261121    gcc-12.5.0 smatch
xtensa               randconfig-r2110-20261121    gcc-12.5.0 cocci
xtensa               randconfig-r2300-20261121    gcc-13.5.0 sparse
xtensa               randconfig-r2301-20261121    gcc-13.5.0 sparse
xtensa               randconfig-r2304-20261121    gcc-11.5.0 sparse
xtensa               randconfig-r2305-20261121    gcc-11.5.0 sparse

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

