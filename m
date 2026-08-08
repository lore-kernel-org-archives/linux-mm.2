Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6B2DC5AC67
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 05:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359376B0093; Sat,  8 Aug 2026 01:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3376B0095; Sat,  8 Aug 2026 01:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185566B0096; Sat,  8 Aug 2026 01:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4A5A6B0093
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:04:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF5441402F7
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:04:25 +0000 (UTC)
X-FDA: 85076911290.16.9A32BCD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7496FC000A
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 05:04:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j+L8vNOM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786165464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=P10j+n3hx7RShUGNWFctbA4iKMnCmDnY3ckSYdokncc=;
	b=dRHZudOQJbag3NrPwGFpQULmR/mIcKYjC74xHwfNUP+HbkW6r3vWy3ob1SQrpC7QP93q0L
	FW/bJ2Nmz5ianal3yPM85IgajwM7f/Vd+ZdilTDJzOsqywcfK39d9M/CjUD4ZbRoXwTUJj
	LcW0oXxEi75Z7OSYXoj1x8Kq2PHf1eQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j+L8vNOM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786165464;
	b=08ruLSY0xrEx8QJTX+KECNura0k+HeIpYOMSmbj7HK0BmYNwpqwdAxog32816Kt6QotIlD
	/obg6wcrYALp5fKof4mosezbnxMO9VMlSa8R2DpET4XSeQkAXwupkCh2QdnJhNysxwY41e
	PC/ZYIG1RTIvBZ61AgWLX8ijZmMlYdk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786165464; x=1817701464;
  h=date:from:to:cc:subject:message-id;
  bh=9tRZmoXJxYe6Thfb2Bv9njkdr7pV7qlqXKjqzc0Ok1s=;
  b=j+L8vNOM7JCndIYw4Bwmvu2dO7YIfGoMomeyoTtus0M25nMMzanPCt02
   RpEc6ZI5NTK8REFUBKXNMCJRhiaeeW3hw57nPAypV5E8dgsw1lB92Ivrz
   QDhP85z881QAIFSq8tIPrbCbV8nGEbeXou3z27Ss5GqcAphVD0cwnQ47E
   wVfEQivZZfvkabK+pFAoijK+O9IL2vSzyE13zau3XxNZWyC9tV6Zph7lO
   NMwkFPbvNWX3g3Gxg89mO/su8UL4cBHzz9R4WA+TuHG0qRS2d7SZS/6NZ
   OdoABEn4Fqdf5pE4XCLQYEHfZbSODLkAfUP6ipBDY0QtSrZBAjLPb11c0
   A==;
X-CSE-ConnectionGUID: RTS0+2kfSJKBPubkHGjGUw==
X-CSE-MsgGUID: bAW7tJrDT5uYDnjqh7Ea/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11868"; a="109562730"
X-IronPort-AV: E=Sophos;i="6.25,211,1779174000"; 
   d="scan'208";a="109562730"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 22:04:22 -0700
X-CSE-ConnectionGUID: guBmxrz6R5yRkYPbFAIyDA==
X-CSE-MsgGUID: tOkKyR8mQBOPmlfMOlH7oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,211,1779174000"; 
   d="scan'208";a="260828581"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 07 Aug 2026 22:04:21 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wsZEI-00000000Jld-2TUC;
	Sat, 08 Aug 2026 05:04:18 +0000
Date: Sat, 08 Aug 2026 13:04:15 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 97090500d776c3f6d08e857e3a0a7cf092999094
Message-ID: <202608081358.ibzc1b1a-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7496FC000A
X-Stat-Signature: hr4yohzcx3pwckhemfoqqbwnmq67hsjs
X-Rspam-User: 
X-HE-Tag: 1786165463-51563
X-HE-Meta: U2FsdGVkX1/xnUr+0g4aThUMdTlgAv8i5yUtNjFXiubCc2nUM5AIgttioTZ39O5GyGnoqHv+GNX0b0Rlfr3NI2wVuGuumOftldTCb4SP1Xlz+3/2pKxiY8uZmWtQ7MfoT7KaykcNMgE5umDeK4cChaKY8p6V/7rq5RiVLrtdFqh1Vh+UfUDnUH3/cquITsaZ+Ie14rHwoOPJ6+TH5u7FNmU0cEqmt7wzHLMWx1IUeOhqUOwJFcJ+mvgNOQbwaObbYbxriI+tLW0gs2KeAzVwl69sr2E597UnTsK7khstLD89peN5jGpscaE8g0wJA3WIaZfa+2IAvIKhquF+C/ja0/dHtJz/fJItn5NNAHFsm90ql1ef+ESAIWndv+X3fgiHZJqghiC1FqFi0ZFUm1Dk4akZgG3oc48JXBLnP/xrOEKc7lVc513uEHv44/oTha9l/n+47DMlzXk4eyOcAkLwiBcwBVFPDe2uppyz0Ew8mcQmjYvCawjhoYTeksIm328mE7RSJ6SL/jJnHbdzllaFn2YbVofb7GU8+wh4pmzrmrqEKu9AGoVGfeqdA/LSW8YK4wSnVz2/AmKym/sSuIXphr5BoaGMet2OTObEbis1PmjKcnjZxi9aMPlZm/Iw2X6KMZc/H8+kzoPHwPNP8WUY7w1bYwP+CfGsbhrYWv04tKEkwFhTubaOIZwS/ZL6LAp3iWzq80WIbpyMcOd/7FEKEUQH5KmPWu2woUZ/QnA6iYMg7JggslJioyfzFUifY+jpEsiUZTp6Xrbn0Jgsidp/DXjYXS6Jg18oeiVZq4Kh8JP5TgVI1NSfWrDiglmzLtJhLixxEKdZ9tU6Vp0uqcj6OCSy0cIYkTIxkfq8UJ7k4/3mU4gS53DINxIWo9GeR6nqoLdeJRe+OLSqAZHBruki3pqyyBnkf6EpuPXr4pvVPid2yZUAQuu6UYlhopUVcYGp3yShS2o8fp3yyFpkPPK
 GsIIahTU
 eOR3Ct3U+U7PeeFxNo9YnpqtNP2A2iEwnckzz8kuTA5i9qqe+qThcLV5fDnp+WWNLdnJh2f1Nn4m+IPtdK4k41vbsGgK/LS0Wun5A+pYqhe2ZWT3c+RrtdRSh65LTpPgk21bGkHh3dYpzeS2cVPXJ/9v8zaADrdfDJ6YWc4EEhBD4Klqj9g0VB0VJSEv+TD+AHO/wMtyI7ntnhQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: 97090500d776c3f6d08e857e3a0a7cf092999094  mm/mm_init: deferred_grow_zone(): fix out-of-range first_deferred_pfn

elapsed time: 815m

configs tested: 15
configs skipped: 1

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-16.1.0
alpha        allyesconfig    gcc-16.1.0
alpha           defconfig    gcc-16.1.0
arc          allmodconfig    gcc-16.1.0
arc          allyesconfig    gcc-16.1.0
csky         allmodconfig    gcc-16.1.0
i386         allmodconfig    gcc-14
loongarch       defconfig    clang-24
mips       ip30_defconfig    gcc-16.1.0
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    gcc-11.5.0
parisc       allmodconfig    gcc-16.1.0
parisc       allyesconfig    gcc-16.1.0
parisc          defconfig    gcc-16.1.0
sh              defconfig    gcc-16.1.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

