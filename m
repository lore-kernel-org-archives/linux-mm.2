Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2302CC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 14:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C7B6B0088; Fri, 31 Jul 2026 10:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83CA66B008A; Fri, 31 Jul 2026 10:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BA96B008C; Fri, 31 Jul 2026 10:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA036B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:08:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BEF6D4045F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:08:45 +0000 (UTC)
X-FDA: 85049252610.24.0557B83
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6DB7A4000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:08:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZJYdhYpx;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785506923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=6F5c35f/twB/wCPwCdM0dAfAlbiIpUdV8HMIL+K3meo=;
	b=75lMprKlGFyk9yx5TFfOrkkxPbxAZe0hjD5QK/YMozxe60ZqHOZyaCs1wK1dVqIyAAbADK
	20Uw4ppL9iQGHYu2fDR7bbWKfS4uxyqXuElIYUGLR2UmpLwd7jG/Iq1qJDP3+CWFY9iuOZ
	ePwTi3g1tk6UEMI6+sKNL/wfh/G3RtM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785506924;
	b=xKq6BiOQ4Tt46G0YXddyhXPvoj8KxooO6icFhru0Oe61SUWBgCh9uVt7poazaDSjkbXrFu
	wCDu2C2JH3AXph6tUE4OmUwjoj2T4d1VcBlcx5HLeNHxdfLJkr5zU7kLFrZvDrtmJg1bqb
	Lz72QxGsGr6wRzfF2sv/3F7dJ8CFDsQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZJYdhYpx;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785506922; x=1817042922;
  h=date:from:to:cc:subject:message-id;
  bh=/9zvXbM4BV3YpV9QucQ5QLh7yV/cqMU06MmDocSG9DU=;
  b=ZJYdhYpxLoNP4cAyiQwS87XieyXyfCejBY+eDPHRPQGwoBdaO983u6hP
   W39OCLaGmT1rixPlKQ2/s0Q/grc7t8l0Wpezu+9d/4H85XvGU6lBNWw5y
   s+2Y87nBsi7dCThKH4BIcgEwAdOUCmhV74HdtqG4YXW7u8CJJ2MJf4jLq
   OBhl7h90AbBXCBp+nWsINqNriSCeg7g+Aj99q5Q0tMr8iKNvze/OvjxlT
   pWZq5ZdBCJYfUdR48WvKqFiIliAAN3xeHH4+7q4IXMjcgMvRYw7ICFRaJ
   juCYQjuuEV43ALgTPLiqQ2wE9tQRqKqwjDZSCMJSK5GvNN70U1MCQMHwf
   Q==;
X-CSE-ConnectionGUID: n93sxL7dRWKM+aE9GCMgQA==
X-CSE-MsgGUID: 4OsNoAYzS7qf1Ud3+zrZPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11861"; a="85260787"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="85260787"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 07:08:40 -0700
X-CSE-ConnectionGUID: ZPo5wZ/VSxyV/+V73Wo0oA==
X-CSE-MsgGUID: Vz2W3wk3RQe5LaBdTNUD6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="259340808"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 31 Jul 2026 07:08:40 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wpnud-0000000017m-2WxD;
	Fri, 31 Jul 2026 14:08:35 +0000
Date: Fri, 31 Jul 2026 22:07:25 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:for-next] BUILD SUCCESS
 9dd84d7c630b7c8688bc0e7e42c0e2d634f46830
Message-ID: <202607312214.DTeQwI5q-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6DB7A4000B
X-Stat-Signature: exibnewqpsfdzcepsf5qjuf6hxr46mdo
X-Rspam-User: 
X-HE-Tag: 1785506922-918932
X-HE-Meta: U2FsdGVkX1/e3/JZcDMW8lWEhDSsp7BpqRs5z8lPcGldgL+L5BAe1CLF9peQnk13iJ30vP3o2u8jW5NPL1/puYvAgVJy6T3sihzwwFGxafUpQeHztQaI1UkAEaDfOhLJUKjPakuPDOseEQobhyto5ecd3SYuhcBLFi3+KoXEBEUUqAlw8TKdUi+7m3t1ucYN4oBhvLsHLWQmo45sZIvxEm5Q4OYXKPtvjh5r+b3ZQdYRUNey4bDoGeJr5v88KWUSNFs45yD+1tlfemq9JEErjVfgyHnaySqoEQmGdRvUqBcKvw0zWCOy14EVCGkSqEBLdnQjVVMa3DzFXwF54nwz3WqNxEgSZR/4iWzbFNwbCwEz9vhkm22NQ8SB6V1nH2cuix9WI/Zavu0EgtsJjWK1br5K98rrBTKoegwFSEYbk/mtJldFgcjg6cxpS+lXGA8m48hPANfEiltmoL1g0Wi+rOHEi+cugY9ZbHQrMO7endWdJV1cNJm1DkTSj4cGgDraV+zOk/q0MOl4GX9XlEu6RbeEpv1WTjbqOQIr/3/KCl/OkbSCY6QxIyeRo0EflmwMnLfZ9Zo8hdSF+lz7LNrMUgKvNXzDwPe7JV+8K5YnYk9b4JtLcR44zumrjO0kWrJCpCRgjXg7MP2xkIrK68DNOdMWGFKwJq9XNlAE9Tdwkbk5r+rX0TBj53Ti0PczJXlb63UiIimOBjZoPNChzyxUSOvY8ZPn5BJVGksWPvPeGzeAfCxHLHEH7rIUxQ450T/c+yiu3VmtQYEaKe8YfWCylncE+ELqSjzq0QZXByCOxvum9qaGMZe86W4oBM6voWzXnHhqJqSs+8gtiVdy9gYzFvYOq+Q1brYgrTWOJXFYWDhbTrDEq2Z+ihlErEw8nbIlA96DQds/h5Tobu73EANMt+hbyZtdympKXuSPby8xpRRESA2EcPCG97DuXwqxOIROL3ElUZ4IQEzqNkjA75o
 xggWwtT4
 16gmqjiEC40h2IJp5ie711GHVyVugvPQzpYmt+yLkxKY7w2GDQ/O4T4a+T4TBYtdl2QohMO0RrfckZc1ytlTX7bA2kGphOzkVUHvAt9mU3l5w6XUuQLe3ak5nGE1Kr/iJJAUZ03IjQ8nnbl+EAGIxfEU1/os0wfdw+SS2PwJUdmy4WCGX8lOmJTeRrxt78PF+Imxn29xssRED3hk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
branch HEAD: 9dd84d7c630b7c8688bc0e7e42c0e2d634f46830  Merge branch 'misc' into for-next

elapsed time: 793m

configs tested: 106
configs skipped: 0

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha                            allnoconfig    gcc-16.1.0
alpha                           allyesconfig    gcc-16.1.0
alpha                              defconfig    gcc-16.1.0
arc                             allmodconfig    gcc-16.1.0
arc                             allyesconfig    gcc-16.1.0
arc                  randconfig-001-20260731    clang-17
arc                  randconfig-002-20260731    clang-17
arm                           mmp2_defconfig    gcc-16.1.0
arm                  randconfig-001-20260731    clang-17
arm                  randconfig-002-20260731    clang-17
arm                  randconfig-003-20260731    clang-17
arm                  randconfig-004-20260731    clang-17
arm64                randconfig-001-20260731    gcc-8.5.0
arm64                randconfig-002-20260731    gcc-8.5.0
arm64                randconfig-003-20260731    gcc-8.5.0
arm64                randconfig-004-20260731    gcc-8.5.0
csky                            allmodconfig    gcc-16.1.0
csky                 randconfig-001-20260731    gcc-8.5.0
csky                 randconfig-002-20260731    gcc-8.5.0
hexagon                       randconfig-001    clang-24
hexagon              randconfig-001-20260731    clang-24
hexagon              randconfig-002-20260731    clang-24
i386                            allmodconfig    gcc-14
i386       buildonly-randconfig-001-20260731    clang-22
i386       buildonly-randconfig-002-20260731    clang-22
i386       buildonly-randconfig-003-20260731    clang-22
i386       buildonly-randconfig-004-20260731    clang-22
i386       buildonly-randconfig-005-20260731    clang-22
i386       buildonly-randconfig-006-20260731    clang-22
i386                 randconfig-001-20260731    gcc-14
i386                 randconfig-002-20260731    gcc-14
i386                 randconfig-003-20260731    gcc-14
i386                 randconfig-004-20260731    gcc-14
i386                 randconfig-005-20260731    gcc-14
i386                 randconfig-006-20260731    gcc-14
i386                 randconfig-007-20260731    gcc-14
i386                 randconfig-011-20260731    clang-22
i386                 randconfig-012-20260731    clang-22
i386                 randconfig-013-20260731    clang-22
i386                 randconfig-014-20260731    clang-22
i386                 randconfig-015-20260731    clang-22
i386                 randconfig-016-20260731    clang-22
i386                 randconfig-017-20260731    clang-22
loongarch                          defconfig    clang-24
loongarch            randconfig-001-20260731    clang-24
loongarch            randconfig-002-20260731    clang-24
nios2                           allmodconfig    gcc-11.5.0
nios2                            allnoconfig    gcc-11.5.0
nios2                randconfig-001-20260731    clang-24
nios2                randconfig-002-20260731    clang-24
parisc                          allmodconfig    gcc-16.1.0
parisc                          allyesconfig    gcc-16.1.0
parisc                             defconfig    gcc-16.1.0
parisc                        randconfig-001    gcc-8.5.0
parisc               randconfig-001-20260731    gcc-8.5.0
parisc               randconfig-002-20260731    gcc-8.5.0
powerpc                mpc834x_itx_defconfig    clang-24
powerpc              randconfig-001-20260731    gcc-8.5.0
powerpc              randconfig-002-20260731    gcc-8.5.0
powerpc64            randconfig-001-20260731    gcc-8.5.0
powerpc64            randconfig-002-20260731    gcc-8.5.0
riscv                   nommu_k210_defconfig    clang-24
riscv                         randconfig-001    clang-19
riscv                randconfig-001-20260731    clang-19
riscv                randconfig-002-20260731    clang-19
s390                 randconfig-001-20260731    clang-19
s390                 randconfig-002-20260731    clang-19
sh                                 defconfig    gcc-16.1.0
sh                   randconfig-001-20260731    clang-19
sh                   randconfig-002-20260731    clang-19
sparc                         randconfig-001    gcc-14
sparc                randconfig-001-20260731    gcc-14
sparc                randconfig-002-20260731    gcc-14
sparc64              randconfig-001-20260731    gcc-14
sparc64              randconfig-002-20260731    gcc-14
um                   randconfig-001-20260731    gcc-14
um                   randconfig-002-20260731    gcc-14
x86_64     buildonly-randconfig-001-20260731    gcc-14
x86_64     buildonly-randconfig-002-20260731    gcc-14
x86_64     buildonly-randconfig-003-20260731    gcc-14
x86_64     buildonly-randconfig-004-20260731    gcc-14
x86_64     buildonly-randconfig-005-20260731    gcc-14
x86_64     buildonly-randconfig-006-20260731    gcc-14
x86_64                                 kexec    clang-22
x86_64                        randconfig-001    gcc-14
x86_64               randconfig-001-20260731    gcc-14
x86_64               randconfig-002-20260731    gcc-14
x86_64               randconfig-003-20260731    gcc-14
x86_64               randconfig-004-20260731    gcc-14
x86_64               randconfig-005-20260731    gcc-14
x86_64               randconfig-006-20260731    gcc-14
x86_64               randconfig-011-20260731    gcc-14
x86_64               randconfig-012-20260731    gcc-14
x86_64               randconfig-013-20260731    gcc-14
x86_64               randconfig-014-20260731    gcc-14
x86_64               randconfig-015-20260731    gcc-14
x86_64               randconfig-016-20260731    gcc-14
x86_64               randconfig-071-20260731    clang-22
x86_64               randconfig-072-20260731    clang-22
x86_64               randconfig-073-20260731    clang-22
x86_64               randconfig-074-20260731    clang-22
x86_64               randconfig-075-20260731    clang-22
x86_64               randconfig-076-20260731    clang-22
x86_64                          rhel-9.4-bpf    gcc-14
xtensa               randconfig-001-20260731    gcc-14
xtensa               randconfig-002-20260731    gcc-14

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

