Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9CBCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6CC6B00C7; Tue, 26 May 2026 07:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86F56B00C8; Tue, 26 May 2026 07:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC42E6B00C9; Tue, 26 May 2026 07:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BADCD6B00C7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:23:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BF6BA03E7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:23:33 +0000 (UTC)
X-FDA: 84809335506.09.A0A984D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf17.hostedemail.com (Postfix) with ESMTP id DE5024000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:23:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YzJBJyBw;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=KyosWlodfNQHN6ccit70KkAt68fFrb3wjKRox0HcqMM=;
	b=YndmGOyOC+pfih8jXgPpnNJya471t63kA0bUc59RV9lru8DetkBwmLdiMSHvrfUvX01Kfk
	GhNw5JCV4YmYD44tCaK4C1GNX38kcxdaWXNklQz0nd9lHtUwBFrBsqGIOJ2FzTc+3gFB+O
	D4CbThg0pCTjSRiluXc/OhE5ukWVrxU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YzJBJyBw;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794611; a=rsa-sha256;
	cv=none;
	b=OFYSsxx8X5iYYE+Hg8TzXZc6in7hJp78cus090W1zFL0ri2FY9wonBHTzCRgNUZC2pCSAz
	MVkREu9ux74Kl3wkolq/7HKi1gh3sKnVsMvDp6KP7QHIqXKuDNwzn/ck1dLbbiU71gbYBv
	yTh9998lSwvhVh8AWqrF2BYhjrUMq10=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779794611; x=1811330611;
  h=date:from:to:cc:subject:message-id;
  bh=K9Osn4iISJQHvAJm9leJyi7xO1byDz8UkbkHttyiD4Y=;
  b=YzJBJyBwjV1iDSpxjHFmB20lguQh7HjbQkGT0y/zUyni3vYGyHAIuMHL
   Gk61zW/oT4miNi68b3LPE+WHFfV6/oe0lyi9kW4KwV1VRM/Nv/xeq2mw+
   DgqcFFB6ySbCAy7v4lul4kvD4WloAG69a/TpVv3SfpsrecU00h1o+084h
   dSaThfxuOrK4WiA9Lhvtqhgg2fEwJ/LFVG8xfZnc2ZJZ25RXRbWzRL24M
   BDE99CjwRpWEK/TlvBoNE/2DRH9tXIQE2a4YDHm0nFAGtM+hmJuv9dbOM
   HIoiakEgjgAYNR+h9/xL7vZCmT5+q91aJ9Hg/H3MELaa+jS+Q2i38HJH1
   g==;
X-CSE-ConnectionGUID: C3CC3dSsRXyUJvXQOV/RgQ==
X-CSE-MsgGUID: fL+148q7T0WfK2q5ag+sCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11797"; a="80576118"
X-IronPort-AV: E=Sophos;i="6.24,169,1774335600"; 
   d="scan'208";a="80576118"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 04:22:26 -0700
X-CSE-ConnectionGUID: coUxllWBRS2h/JhpxO9+jg==
X-CSE-MsgGUID: YC+tGu+WQsquNAtvR1OkSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,169,1774335600"; 
   d="scan'208";a="265510402"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 26 May 2026 04:22:25 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wRprb-000000002P8-094C;
	Tue, 26 May 2026 11:22:23 +0000
Date: Tue, 26 May 2026 19:21:53 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [rppt-memblock:fixes] BUILD SUCCESS
 8623045aa5d24de177c23c86f01d1249ecf2dc10
Message-ID: <202605261944.9evU9yMN-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 9x7wtyi6xxpbe4ju34a8dyb8c5jrj56x
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE5024000A
X-HE-Tag: 1779794610-744158
X-HE-Meta: U2FsdGVkX19I0EbiNPFr2kjybuVdolXoAmuMYVKutq1OHDNQyyJjO1Hdvke8hTYMQqUQsgl03q5T3Ccdw0885Y2HFRDIQx38RLBIsnWEmC2l66ciJgHrcL8+vlarwVRHBmsblYOCrg2udDE/3NX3Z6lA4DpckaRYNZcTc4xNn0UQz186ctuVTd4SM3HdfLkaPF0mcd/vI6ZDm0fEkBlC0l+Ixmvd3rSSij1SMXyVErDsx27VixyKfH++cfmPhV/wIkl4OKUBCGnDQjYOMQf+hZjFxOJXzf3LpR/gQVgr3I88Jew6vgdnf+G9zWDXmfykezb4Rz8uOg8AQ/Dtoz0LS6owMj1UeZ/kQ4L+RSRfRB+VMaUpYK02I4YChkKPPew3tOehEmdz1ctYsz6hnMMiQfI3nMhYlSgNqflebW9+clUaqJIlkoPhzsCjihzNvPdYNdqCGlZXX9wTJAWUG6fgsbiqKfJRpekg0n3ugLqCJHmjhNk9emNYPExg7FXiAPDEoi0G8GUIdmAlIB9QkzBjiFfg0uBu/291fUUCu4JMtS00tTtTm+wYNN+6cKU7OSztywtcVEJH2CBdA66AClKI6OG+q2VHi211WmR92cdKSj0E6LHaCN/Dj931CeYAFbmaiF0TCaiU+aHDw8NQIfRWdtxQMImZx2V6X20bxK6dSpMPvNG9PXJKQPCNrpTzLL5nOZggyJ9y3W8niKtETVkzHv6d6M5hZSRZ/wYd/yAkw3YZEhjzzqWwVkk7Ex0Z8OegHr866ZSARWfRU+gxZMR9ERJVaWILGzt/jcsrGhq5t3QyeFfqvkCHvuUgY+kSxjKCyUFSzzLUy/s7UBQ261RN3G2GUYOT7nXkS7T4XdUYdUoYDbGrHJg5knsaT6jpiRAkaqbGzxJWfLgQNZi3ICHyM5BoTiNrr/jv3CR52+oncUQ20sxRHBu4a1nQBp3Zp3IaSYZp/W+hLTxuV3iR4xx
 q2cqUDEU
 njQkuqb0dc7oea8Na0rYZhiydtxPSZMVjZ6Okp1Aprj9L1skkTcrqrusjRqhKAn645ZlbYyOGE+RwsFCqX/M6Km7qv/a90H/hIKNlBNBqLrzG47h83gWsN1C7JufbsZzCGUy2ogdB8f2ktLaMd0mGQJ/aXiFy3McaVvlC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
branch HEAD: 8623045aa5d24de177c23c86f01d1249ecf2dc10  tools/testing/memblock: fix stale NUMA reservation tests

elapsed time: 1051m

configs tested: 51
configs skipped: 4

The following configs have been built successfully.
More configs may be tested in the coming days.

tested configs:
alpha         allnoconfig    gcc-15.2.0
alpha        allyesconfig    gcc-15.2.0
arc          allmodconfig    gcc-15.2.0
arc           allnoconfig    gcc-15.2.0
arc          allyesconfig    gcc-15.2.0
arm           allnoconfig    clang-23
arm          allyesconfig    gcc-15.2.0
arm64        allmodconfig    clang-19
arm64         allnoconfig    gcc-15.2.0
csky         allmodconfig    gcc-15.2.0
csky          allnoconfig    gcc-15.2.0
hexagon      allmodconfig    clang-17
hexagon       allnoconfig    clang-23
i386         allmodconfig    gcc-14
i386          allnoconfig    gcc-14
i386         allyesconfig    gcc-14
loongarch    allmodconfig    clang-19
loongarch     allnoconfig    clang-23
m68k         allmodconfig    gcc-15.2.0
m68k          allnoconfig    gcc-15.2.0
m68k         allyesconfig    gcc-15.2.0
microblaze    allnoconfig    gcc-15.2.0
microblaze   allyesconfig    gcc-15.2.0
mips         allmodconfig    gcc-15.2.0
mips          allnoconfig    gcc-15.2.0
mips         allyesconfig    gcc-15.2.0
nios2        allmodconfig    gcc-11.5.0
nios2         allnoconfig    gcc-11.5.0
openrisc      allnoconfig    gcc-15.2.0
parisc       allmodconfig    gcc-15.2.0
parisc        allnoconfig    gcc-15.2.0
parisc       allyesconfig    gcc-15.2.0
powerpc      allmodconfig    gcc-15.2.0
powerpc       allnoconfig    gcc-15.2.0
riscv        allmodconfig    clang-23
riscv         allnoconfig    gcc-15.2.0
s390         allmodconfig    clang-18
s390          allnoconfig    clang-23
s390         allyesconfig    gcc-15.2.0
sh           allmodconfig    gcc-15.2.0
sh            allnoconfig    gcc-15.2.0
sh           allyesconfig    gcc-15.2.0
sparc         allnoconfig    gcc-15.2.0
sparc64      allmodconfig    clang-23
um            allnoconfig    clang-23
um           allyesconfig    gcc-14
x86_64       allmodconfig    clang-20
x86_64        allnoconfig    clang-20
x86_64       allyesconfig    clang-20
x86_64      rhel-9.4-rust    clang-20
xtensa        allnoconfig    gcc-15.2.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

