Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8102C54FCD
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 21:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D1B6B0088; Wed, 29 Jul 2026 17:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE5B6B008A; Wed, 29 Jul 2026 17:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6F66B008C; Wed, 29 Jul 2026 17:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE6776B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:39:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4003AC0700
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:39:42 +0000 (UTC)
X-FDA: 85043131404.20.2C3457F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf31.hostedemail.com (Postfix) with ESMTP id 949FD20009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:39:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HzJ+EPHE;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785361180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=pOg0MAMj9ptcSEbmspL3dz8VUlSdQGVedtVVuIz1t4U=;
	b=XSfb3oykgF+exacaKhC8ALtI3JQhFZ9/1TBrKm2HPT43mw8bJfh3xNYDR9nkCQbesBF0p3
	Q61julBQ33o0dEc3CIrtC4REzMeHClKORZb/TZP1IWQrPowE9uTfeJA4e4yYbTAa03X1zG
	6VfcnJR+/no7OEu2O6YNRMS3WLYLAMc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785361180;
	b=GaazQZM7n0tKfV1dEFLaoyoOJSklnBnq8QZUA8UhZLLOC7Rv/ARrUGxznHeRe/fa4Jt2zu
	x14bH84GhKUeldy9xYzJGEIysz24ShSGV/sC+eienwClvuUkJdvwNXTRoxZZk7ZVBDMSkH
	a8x0DA0YuDTAIwUaCfgISk2gp/8/ov4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HzJ+EPHE;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785361180; x=1816897180;
  h=date:from:to:cc:subject:message-id;
  bh=3lfQKZ7lIENqEhlnApCsfj+2fW7E7cOARBXPZKJ32vE=;
  b=HzJ+EPHE2xZAgmupLS0tC/QGEc7tZrkghJ2jIPN6ZOdGHXNDgMtJJTnt
   6H4Yh9mN7cTfm9RkMEJfTXCvp8lu9bKp1ipjK/0nwQacfIxL30OA7xQKI
   BNLyjG9biPM6ip3XNCuQX9TBUrKNLNt5W7TnBHcu6KC9spsJ60W5WkoFu
   tbr9P8y4JVs/QvgptW5rnZx+RmU5XxdgDTRz5SA4CN8BdGOcrHsWhgrsu
   Vni4djv07pnkoBFZ9rfUhj6SbErettBzkuiLtjEXqvsYFhA3ErVOFCgrC
   nBgLmnbdaWTh1cn2OnHg6Q0jDhudFm29/I4B4xHi9NsBlaDsO8vM2y/Ul
   Q==;
X-CSE-ConnectionGUID: TlswkndlS6a+ii1J+HAWCQ==
X-CSE-MsgGUID: 0+Ypz6jRTlauPPaJK8oyrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97133425"
X-IronPort-AV: E=Sophos;i="6.25,193,1779174000"; 
   d="scan'208";a="97133425"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 14:39:38 -0700
X-CSE-ConnectionGUID: f4dLZXwISxuXVnhUBAkc8g==
X-CSE-MsgGUID: 8/KrBO/6Qp6YKV2YusBobA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,193,1779174000"; 
   d="scan'208";a="262076200"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 29 Jul 2026 14:39:33 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wpBzu-00000000fh8-42Ye;
	Wed, 29 Jul 2026 21:39:30 +0000
Date: Thu, 30 Jul 2026 05:38:45 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master] BUILD SUCCESS
 78bc8af4affb9a732504eb22eeac7d1e50883853
Message-ID: <202607300507.Mvkdse2k-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 949FD20009
X-Stat-Signature: d7njsj95newtctn3qr7o9bzcaekgjny3
X-Rspam-User: 
X-HE-Tag: 1785361179-795179
X-HE-Meta: U2FsdGVkX19pzOhNClZhPlaV4FOBn5UDs5p42O8EugUThzZwKi6NA37uXmRz9/ustz7mitQkECukd6wdq7cSTH/Kp1TtHjasFCaUwrfTW7u+E6OJR29RSjJmD32q8Xuq9bASLZDYXuru3eoBlEOZGGMYNOLdbDxMXMG0WURfOooJnTzPcMeDfVnIzbwebSCKrcmMOpvKussP/10GuurEupXGpTWABqi8iTEO/7jkNEgrAMqSU2TezKkEAPflB10AjtoXxLvu0AHdbln85jWj7VUv3t/RAljbxeBQdvnxC9KOX38255wdN5fsUW6cxq9/XGkHKHkLK+NXhUTm7BpUqECPBHN5EhioOZrtL1Io5LOdqt5q0wA4F2IZt78OadJGIovgMWrbHdCZcGU8RfBuHXkbg7DsaozZJjRljgv/LK/TL68vBLUM0+huGnKnBCYRtJEkcet5pzC8A2CfWvn6vazbE/hzvjgqZy9iQDUHr/Wd1o7Xnwo5em7ypAZoi9siG1Z64Ae5vdUrod5Yu/B2vTP706fo4bMApcAmavsAYmlxhLNpMAbTespf+HAohUm1CRy5APdW/T75spCQIrPb0EKVsAGQ2I+btQYNVckHTacC339DsDS+7HKX6QGcN61bMD0qxet3LuHd8kvDRh8Gh5u12BBLYubTN3uC0HvxoaecKU/8bntz+pUWxjW6IXjf/oRYPyhvR0NgT7pzbJ3e+bVh9wN2/tuJ4glxb0ZHfGrNHTOwAAHIpBw0ECRp1lk/tspXntf4045HTtKjefKhd0bq1LlN5eZA76RWYn3gQW4Wjaz7jctuQ++eb9Wr7PjkZfzn/0joklGTXJrV0agHrSJJu1Q73ZTpKExo+5JYkAaMr28EyNvAqsH3EwT80X1bNGFvtKeAQcOjVnzns0sikDjHm+Q/uZODJXXa61s3f47dEPTnNZj1mutr6wNiUsUksoyxbcgOGzB/ohom6yk
 vby9Ucl0
 d+6N7XJIhUibdqMYfahh7TrkCqk40i3Bo0sgGEw6HCLkFQf+h+thGAafKtL69Fi3s21DoQI7OyZjsrw5tHcfvqzF/nb386zaGHVdFd6aK1sksspwbw37EIoZ+rpKwFvhhV60Ql/uCidYruM5rbKW1mI3fQlH53USw0IeWGJto6PaXKav8nHzfLFQNwdNLCrAjucugpBw5ClNmTSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 78bc8af4affb9a732504eb22eeac7d1e50883853  Add linux-next specific files for 20260729

elapsed time: 329m

configs tested: 29
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
csky                            allmodconfig    gcc-16.1.0
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260730    clang-22
i386       buildonly-randconfig-002-20260730    clang-22
i386       buildonly-randconfig-003-20260730    gcc-14
i386       buildonly-randconfig-004-20260730    clang-22
i386       buildonly-randconfig-005-20260730    gcc-14
i386       buildonly-randconfig-006-20260730    gcc-14
loongarch                          defconfig    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
powerpc                mpc836x_rdk_defconfig    clang-24
sh                                 defconfig    gcc-16.1.0
x86_64     buildonly-randconfig-001-20260730    clang-22
x86_64     buildonly-randconfig-002-20260730    clang-22
x86_64     buildonly-randconfig-003-20260730    clang-22
x86_64     buildonly-randconfig-004-20260730    gcc-14
x86_64     buildonly-randconfig-005-20260730    gcc-14
x86_64     buildonly-randconfig-006-20260730    gcc-14
x86_64                                 kexec    clang-22
x86_64                          rhel-9.4-bpf    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

