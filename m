Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39453C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674E56B00A6; Thu, 23 Jul 2026 21:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625AC6B00A7; Thu, 23 Jul 2026 21:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E606B00A9; Thu, 23 Jul 2026 21:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6B56B00A6
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:58:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58E0EC024A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:58:09 +0000 (UTC)
X-FDA: 85022009898.06.4608236
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf17.hostedemail.com (Postfix) with ESMTP id C107A4000A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:58:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dZnQ8DHW;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784858287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=E/y6a+jdDJvppYt+jx2v9YMz0hljpdHIa7V1fF3S0+M=;
	b=e7CoXYePHMS89Qw9YMIJ1wtqQAlkeaQH9a4KcKPTacw9RGpyAkYR1MUGq7/rLm9BHNKODL
	AOAmTVR/JBCJowguHqqWZZVGe8y31Q+L9tr+/G94XylBo9bvJgY9pFmecBPe5hdqr67Q/r
	PPEy0dlAZi0aBNWmdHIkMqkd9B+tlww=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dZnQ8DHW;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784858287;
	b=jbF6HkKFP4cBSU4HApkdK/blRomqnaa0MyLsdmOQG//7QA8ftxg0Kz038TU4y3yaxMmaIA
	7YgsL0CG5q/3NJdP8kHgNI+NLlngsbwGIZOt+EAgrJQ2zlIp91B7dthPK8IxqpBPd2z82J
	uN8x6eTJpj6MAWZAugLHNaF7bd9P5e0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784858287; x=1816394287;
  h=date:from:to:cc:subject:message-id;
  bh=MCPfWbWDu/fx2Z+J5DBf0rF3V3snUtzBU/nJYQmOLm8=;
  b=dZnQ8DHWasE+fXbAeH+0/hOR9o5yHn0sTA38JWPjRm5fB0CpVqLTic0z
   Lns4GewIEgfECZtIxGP6bOGv3KhgEWTINeTh1RR7Yi2vMeLfWypyVhdvQ
   k16gbdIOeqfNotP/LXpjq0Zf1fx7/jOuLcnLd8rdLdj1cLS9xGgjm0FGs
   LCobiUHLh5zTa1qm1E+219+maXgWmwb9AQzV/grpI6e7gvD7UIU1DeUCd
   L9zW5DaXVnoRY2BzbkZ6jxx/mlNJtB1dpNu++qtyj0VIRWNpwrAJEAGHn
   VDggWqWJvn5iiVA5090Aun6CqPfFH3tQRYJD3lG/srDGYsuCzlI6j3T79
   w==;
X-CSE-ConnectionGUID: 4aZc6W/ESZ+GeDpGqEDRCQ==
X-CSE-MsgGUID: ImDSPcyWQSWb5zzl/2RrrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="85716903"
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="85716903"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 18:58:06 -0700
X-CSE-ConnectionGUID: 3F7aKxWCSF+i7J1AEkGlxg==
X-CSE-MsgGUID: xYQl2M74TmiekoHcXr6+bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="263553960"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 23 Jul 2026 18:58:03 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wn5An-00000000aN2-2ZNq;
	Fri, 24 Jul 2026 01:58:01 +0000
Date: Fri, 24 Jul 2026 09:57:17 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 a000f52cffe0e577ff4519cc2c23e073278b9c7f
Message-ID: <202607240906.fJo4Pv0G-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: C107A4000A
X-Rspamd-Server: rspam01
X-Stat-Signature: 76xopcfk44w8ia98eo5iw8qp3mtqgge9
X-HE-Tag: 1784858286-531060
X-HE-Meta: U2FsdGVkX18RhYr7LnEHiW4M9/aT9lgkc4YRviPxCoEQG2BGVW3RiduuHa1CQC/uF3fVoR0y0JyAbtaN9kqOrb2rzDgoQsB27uMn5oDqu3qcHsv11b8toyJua4o/QD7SWfLU3Qcw14DHKBijqjLR7JH+VA5qKL3XGqoM+UxJDcZJ5Afzbo6uMZ1eX8vh0guQg5JHAJo7oHN31hTpe85rLZ5n8uH8Cw3p/rCFeAhSBnv4wDt6MqIzcRuB2B/Cv4SVy9IV4fCvJjSd2VEjDnvlrqt9n4epH8bIM7d/hVOAwaly+If2WOuNSTfP4kzCjCPyJ//UTt7uyLl/Hj3U0K1YEqAvLezlqlZvMWp8ADNC/+win6hKxdIGKF6ZSNZT/9gvggd8QGOKA6PeJoWnZuMD5x7T4zik+hXQmhvU7PGDtni7GDMB7nVnXEhO2dDLHRAtBmcuHAjbsBYjfpaLcskhSagjiDrpGxo+BMQQWrdSKe09tOuALmaPCMhjlXK5sQjVEySqsazrlBzITIYFejgpwwnUZvRbLKWPayuZnlE7v2F3MfWylp7hajcO4zYhvNlZGlmtRGmC5YI7He2mgnlTt3IHAN8Msjo4WcxWl7wzBTLslOS+Os6s3g3j8as+rIIs01q5qzqGL0zb7T4cBehBzvrtv44YVD4IDhqE3/3gam9sjo2tjgx3lDVNRpV5DQWbHZQxLd0z0kGEJgE9RXEyvGMKXMhWOGPrqpXI15KwyBBxlSRTBzPqz9Q9dqM6gweVM8kqWNfxxWdNLsrNdoHsr4iAIVLlwrvNp7niYU6oLXIhJ5oRPltuGwzFwPHvKoDW9TA/9qmbVg/18Q1Kl+pva+wYXIdPdT83Eml5mEVTsTZrBMCFOYlKV4tmK61mx0ViQMUa6r9ltzobeRbn97wo7tSs9CDKJecIn/vLUdKttozpuxnxLxjSSNYMmlLDwYVIT9U6QsA3gykp24b7I1h
 E+xDGzYT
 0YtN5ToVRVhbFq0osvH3MT2oTgQIY/28FyugHDwxeMuOU6rkteR4Dte3uNEUO6EdUxQ0YjFK0d9RAQV36dfkekNz24eqdHBxKAWLO+j5tGXqPpUtew5TbnTXbAtXVHIoqYbWA4nUedstLVv+6gLAtphZhHXWy6sJzioNu+5m9/edx1MTlhMP6EWid8Z4uEvqMPqIuA9foPWN2EpY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: a000f52cffe0e577ff4519cc2c23e073278b9c7f  Merge branch 'misc' into for-next

elapsed time: 1061m

configs tested: 41
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260724    gcc-10.5.0
arc                  randconfig-002-20260724    gcc-8.5.0
arm                        vf610m4_defconfig    gcc-16.1.0
arm64                randconfig-001-20260724    gcc-8.5.0
arm64                randconfig-002-20260724    gcc-16.1.0
arm64                randconfig-003-20260724    clang-24
arm64                randconfig-004-20260724    clang-24
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260724    gcc-12.5.0
csky                 randconfig-002-20260724    gcc-16.1.0
hexagon              randconfig-001-20260724    clang-24
hexagon              randconfig-002-20260724    clang-24
i386                            allmodconfig    gcc-14
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260724    gcc-16.1.0
loongarch            randconfig-002-20260724    gcc-16.1.0
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260724    gcc-8.5.0
nios2                randconfig-002-20260724    gcc-8.5.0
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc               randconfig-002-20260724    gcc-9.5.0
s390                 randconfig-002-20260724    gcc-13.4.0
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260724    gcc-16.1.0
sh                   randconfig-002-20260724    gcc-16.1.0
sparc                randconfig-002-20260724    gcc-15.2.0
x86_64     buildonly-randconfig-003-20260724    gcc-14
x86_64               randconfig-001-20260724    gcc-14
x86_64               randconfig-002-20260724    gcc-14
x86_64               randconfig-003-20260724    clang-22
x86_64               randconfig-004-20260724    gcc-14
x86_64               randconfig-005-20260724    clang-22
x86_64               randconfig-006-20260724    clang-22

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

