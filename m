Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34B55CA0EFC
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 12:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A1DB8E00A7; Fri, 22 Aug 2025 08:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5269C8E009D; Fri, 22 Aug 2025 08:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43B2B8E00A7; Fri, 22 Aug 2025 08:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 28F228E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:07:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5D57515DB
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:07:28 +0000 (UTC)
X-FDA: 83804268576.30.48F55EB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2783C8000F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:07:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hRmMoedk;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755864446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9SKE2YCpPBuV/DJdNfkz/fypcTSlXXBZR/7J7NTKCNM=;
	b=Wm5EfJcdnnKl1LWqPQFT4vCjmbTn0yEG2ht5F1RCnvc5rwoQxyUjLPXT7uTs+WQrwCeZV6
	o6+kYfc+ow7q6J+rdmp6jKL6PwiC/nlS1JaElQizeLhAhLe9z8Enspu6W47sB5rzKJD4PN
	XybQ96hNWjeTohFIZD/jIZy6fucOoTE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755864446; a=rsa-sha256;
	cv=none;
	b=TWPgh2/NCNvxFu8RT0s8crSWbbIaTLoftk83/fh0VXEh16Hh91bXe+mIJXCwby6NtxRHLd
	j+04kthks6sQc5ELQeO6FCeb/eB7AGZoApv/xaWNVBPUalaoSZ4hNVs9iQtRyUIFazqnTI
	WJd45aNpz9brqxU44sRitoMD3JgiV6c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hRmMoedk;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755864446; x=1787400446;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=WQiqjvLi5dQUrym9drEPqy9hqT19tYPDN2U5c3gA+rc=;
  b=hRmMoedkyzoEyMPcLT7QQVMUEUHi2o479GX9Z89M5i/X+doP+Np7yEPq
   jVgO8bPCE9TnVTIDg1xg0YPkJDxVG+1kXVml2LdExlVKujfGNa4rtzkzo
   uspHvav5G2R7KpMKnlXUarCegj+Rlnei74OhPNyDgsPDS8Wfr5XnnS1mk
   PC6jpLSfSekNeBQBapB4XuN6ECKpi9Z0GHhlniFCjmf7ZPZLcA2xkt0kM
   UjOz/PUYjLA9i+izZLzDeI8KqH+9RfGZ19dOeHKdTFLRAessNuQd/Y6rM
   TR2TT1ooxxR1O3F1o0FXe3GgxSneDJzPsxBmfSeRG/KZH/3fPzu4+fGw9
   w==;
X-CSE-ConnectionGUID: dSi+9o4HQleLdEqB/d1rtA==
X-CSE-MsgGUID: rLOv/+OFQmCKKvj2NAb3Dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="68769045"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="68769045"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 05:07:25 -0700
X-CSE-ConnectionGUID: GiMn3YLTTD6hVTxOD490OA==
X-CSE-MsgGUID: zf2We+8TRYOxHMDkkrmyyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="168199261"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 22 Aug 2025 05:07:23 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1upQYD-000LEI-0n;
	Fri, 22 Aug 2025 12:07:21 +0000
Date: Fri, 22 Aug 2025 20:07:06 +0800
From: kernel test robot <lkp@intel.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Paul Gazzillo <paul@pgazz.com>,
	Necip Fazil Yildiran <fazilyildiran@gmail.com>,
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: kismet: WARNING: unmet direct dependencies detected for HUGETLBFS
 when selected by PPC_8xx
Message-ID: <202508222032.bwJsQPZ1-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2783C8000F
X-Stat-Signature: ecrts9zxp38oq4dqkmyqje6cn4y3uxti
X-Rspam-User: 
X-HE-Tag: 1755864445-476734
X-HE-Meta: U2FsdGVkX18R49yVUvfHCJgOtTpzF0i3OMGR3zvY05BSNuDQS7O7PCgEJf6FiDEoXpdqP5QnOQlijnSoW22o9zs7l3L88n23X9oRhhDlGxYbwTlHStnrhxaGzrxzbpHtFpDUBeJG0BzsKU7VDK10aWGAZrqTCDzh5wWMLAlJ7Mfi0mcp/4pPgK8yIx4YJUO41REyyWreOacM0UISFtUcbU9wAWNeIP1p2cB5CtvJ9rWHaAOjEC+B0FFkIf8pD/I025JT5jx3xaci5fOroE5RrEX6+J5kyqDXb8dZacSBWC938tNVZDmUcx/lCHzJ7ioAFjUEbE5dyhibGoa1B5hU+fxmAWm76yB13GrF2CVuAInzqbt0LgylOOM+yWJ+FyBDOoTb/NCwawT2G0yJP2cZickA8RVKoVnzZeN+45bTZxXbwybCfy5HxKZC6tyeDG/65cyGxrXUDY3qoRRQZmR/wQQeiuYKH76cVRjN3/lvQ+XRN9tSqNWrE6YVgiSP5ppEpjr78yZwfAovlHah5ZBMTBHTcxpgZ5KwfIVtPl5eWdnK2ARwUgN0XCJNssC3vaVpldhWH6SSM0ltQLAbb2+L/iP1Lu+7Cn+f0OsYU9FMkUhFkYBg9kdUZVnLynq+N9KPZEU1CTRDBD0EHyhkOFDIGVfBhSBq4S9b+smFQGZvclJ5VNW3LmoZ64WB3oLAZuQGptqOUfVmXJgWjzP9OQvwyQpntMVs5K8sFXpfDsHZZjXnlYcG8OlZMFBRxlGVIS9nRWgXNl2AKqBxvko8SHxUB3u+OA30eE/hzhAdr1caVetuCXFkxS5gpMISPtenYnLAQEV0qP0D71U0IR2jhyWIztyxQNOCws9vX4DvunpAOa0prw/+A1HoXSCND/8PXAYyZAc7hDBQ2boI/za6xckOh8HuoWBaCu2jRXULRZ0KMoM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   3957a5720157264dcc41415fbec7c51c4000fc2d
commit: f8142cf94d4737ea0c3baffb3b9bad8addcb9b6b hugetlb: make hugetlb depends on SYSFS or SYSCTL
date:   2 years, 11 months ago
config: powerpc-kismet-CONFIG_HUGETLBFS-CONFIG_PPC_8xx-0-0 (https://download.01.org/0day-ci/archive/20250822/202508222032.bwJsQPZ1-lkp@intel.com/config)
reproduce: (https://download.01.org/0day-ci/archive/20250822/202508222032.bwJsQPZ1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508222032.bwJsQPZ1-lkp@intel.com/

kismet warnings: (new ones prefixed by >>)
>> kismet: WARNING: unmet direct dependencies detected for HUGETLBFS when selected by PPC_8xx
   WARNING: unmet direct dependencies detected for HUGETLBFS
     Depends on [n]: (X86 || IA64 || SPARC64 || ARCH_SUPPORTS_HUGETLBFS [=y] || BROKEN [=n]) && (SYSFS [=n] || SYSCTL [=n])
     Selected by [y]:
     - PPC_8xx [=y] && <choice>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

