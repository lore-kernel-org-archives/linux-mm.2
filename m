Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4F0ECAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 21:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B038E0003; Thu, 11 Sep 2025 17:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33BB48E0001; Thu, 11 Sep 2025 17:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251D78E0003; Thu, 11 Sep 2025 17:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 162D48E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:32:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE1B65985D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:32:31 +0000 (UTC)
X-FDA: 83878268502.12.D3F5472
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id BA907180003
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:32:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gx6dZDMv;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757626349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bue2z43hj/EI6OSryiZymP3PGJWQVHs/nVNTgMZbeHw=;
	b=GGoWBkhuPjisf+hpIwoTXxasa7gtMmPlmQV9ckYUvwyTdRl7yshK2RCrwOja4bOel3KlWK
	QkBleJ4JevgV4RsedPT25DPQxzvuVyGhd5k0P7JcIK0+l7yY5hziybZ3UUHKWESXIszOK8
	WpxNV4BlUA4Zf7fzphQBOvyRTjibyNc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gx6dZDMv;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757626349; a=rsa-sha256;
	cv=none;
	b=3rUvD4IYwkGNj96UgCWC/5JIE+XehzWoRhvB7AQqc30+XARhGWR9H9h0aCr2TjS1WY+3NY
	SIyLam5csF8smeV4omXSS725HcpAEWf0xGg0S/yqaICqzJlPV2u76eaBYC0t9305KfO1Wt
	7ZrIhkzaa60yLiGbAqUITy0HGdx0ti0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757626349; x=1789162349;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=zXy1HEH2uPFS4s3SbrF8IGtm5jPewK8JqClz/oEsfLA=;
  b=gx6dZDMvn1O33qJhdB1uOHM1a4tYC1Se+RMy9WcvWJgrGDcOMtdkOhNp
   jmKNDeFXfJo301jq1h4JNWoeiMj7Ut3tW+7okYwcZtGNwIne26T3qu3I6
   C6Qho1F63NTMr+rJzh87iQHPLSjMxnnxQrRUaq5SZLXmDH3qPWP4wMMYN
   /DgpFLkZkyjgInMzRUfJ5UMn5e/j9EHpQnG6EeCkrpnrSoSm4mogWnGjM
   bgLXy9f/tINvOFz7bf7ZiwJYonJrUwd5BVT3Akfl8ECEu5M4XT3i9wubf
   d6SQISCzJK+1U+v3wTJl57jyMwitEK+pt2f1WnJkpaajTRmzlOJ+st0Lb
   g==;
X-CSE-ConnectionGUID: jAHHKvc5RLC/MiMSIG9HzA==
X-CSE-MsgGUID: Plmfobq1QoSqAl+xh0Q1WA==
X-IronPort-AV: E=McAfee;i="6800,10657,11550"; a="70590226"
X-IronPort-AV: E=Sophos;i="6.18,258,1751266800"; 
   d="scan'208";a="70590226"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 14:32:27 -0700
X-CSE-ConnectionGUID: kQENUW1kSM++OhHMGoS49w==
X-CSE-MsgGUID: 4wZherGfQ7eKmCfVr0MtQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,258,1751266800"; 
   d="scan'208";a="179015372"
Received: from lkp-server02.sh.intel.com (HELO eb5fdfb2a9b7) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 11 Sep 2025 14:31:34 -0700
Received: from kbuild by eb5fdfb2a9b7 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uwotA-0000eG-1G;
	Thu, 11 Sep 2025 21:31:32 +0000
Date: Fri, 12 Sep 2025 05:31:31 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 423/440] util.c:undefined reference to
 `vmf_insert_mixed'
Message-ID: <202509120557.Fjb2Px63-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA907180003
X-Stat-Signature: 6wqqz8knnfi9nwg8z9ygktbe3if9f696
X-HE-Tag: 1757626348-845257
X-HE-Meta: U2FsdGVkX1+PP9w/3pg1QjrvKWvVO1BxYfcQUFSQa2qrZNhl5nn1uEU09IVT5cjexg7klIybiRbN2ZA3r4ex9/Lu+IzG7iIoWUa6zlIh5GZX2VfWZ4AdxNexvnr/oubcmbO0u3NcJVqua/UDOJ2FwWxj5Gvl10eB5ZmaE9YvX/iXUo19a1ddc/cWM4YU9kGu/MSdmjkAAi+KJLkUTfdX5NugrJlrPHkZb6ncfkMoT6s4YdJe1k+bVpPTUwShSZ9l7v0vq3qNYmfIIQ/lPIqWjYWVI0l2B0771byVdaoyTFIxaQ5j+v2jbD+w0t7PW+xFNuu3EzDk8ZW7162f1z4ZCWZEedN+fhwpkXlOQ/9hqzA0MIpBm8tRXAfDMsVxffCphYcCEyJ3sWct+Ics5v63j4Zgq+KmpPmRBimQr6jzoNKhXU1ROuVkvQxD52RoBGcRnL+Ksl0aKXX0sa3jnFoMq/uFg3+uv7pr78iaNGu/Yku1GoprbGALLeZfcAglIB+6C3qp93HWegqHpJVsPu2mq/c9G1X2V7/C4s6CME3OL4j1iuEfxPGf6aFIPP2eMa8zdjht3lE+FvupdfIv/pv6sfncfaBzDmDf1Vqwb4+6F5r8Ws4LKnyKumCx1/n9C/RCaN3dNLmKJhTQOlGUEzPJhfyDU1bAoiVCHwwPqtAvt8uXlH0ZhVSbAOHqIyzR6gauhANL7ll3jpmYBN2eNnakdYsT7U7QNRiQUN1K+XV0p6ZBQBQ7p8gUQRKWCCXbmOJJO0AiNTXj9P2Dxp6B5OrQY1DkceX8bjJSIMT/NuTvxRXHzo+OL2/RSqV9yKDx6BjQqw/YO5JVvCspoSwOwLfxdUvjZWV2dk4q5pLKpIEEmQ1iJI88GUHftPvSg5gdsKZGjXHUOYXzHrSfuaFG4mDWzoGPXOxeWldh15JZ99qwlu8Lx81Gwqnf1WDXCxwkEVbMkclP8i20hjhcM+C2OTZ
 wfPO7qeU
 z4n8Q4MQTywBKr47D3K8oe/C3qMaR5aUjt0n7yhb+I2CoAGegl/tuSmNn0stk0sri9r71XeW3AnRKXBzJR6gdkqflVZe8k7kvxEFhqVwHxkArG706XNz8GKbebOxDPs1QuzBoX85VIBiy0oUG+Y0RkwvokMAUFwAkKYTmoYJqIsI12oN3JVMFDQSWpKpN8sEKSgaVKniHyJW8X0vP5HFG/WwrChevS/AjYsXy8UcVkKGSOlddelxZsOwObIhk+/qG1hDVqDRVD+69thpiX4NMfj5ldY8R9vqAreQgYoc2c5v9Xvc8BcBGeORlo+ghIILQ3i5Vj2RCrSud/iUFkMFwkf8CXRfZs4am12+SmIjS0UGdgRQe5zXNpXVZMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   31690ac95cb30fd036eeda36844c6e2820685e7c
commit: 52b3813194a48b5dd38cc3d76686e0b060171b0f [423/440] mm: add ability to take further action in vm_area_desc
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20250912/202509120557.Fjb2Px63-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250912/202509120557.Fjb2Px63-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509120557.Fjb2Px63-lkp@intel.com/

All errors (new ones prefixed by >>):

   m68k-linux-ld: mm/util.o: in function `mmap_action_complete':
>> util.c:(.text+0x92c): undefined reference to `vmf_insert_mixed'
>> m68k-linux-ld: util.c:(.text+0xa2a): undefined reference to `remap_pfn_range_complete'
   m68k-linux-ld: mm/util.o: in function `mmap_action_prepare':
>> util.c:(.text+0xbe0): undefined reference to `remap_pfn_range_prepare'
   m68k-linux-ld: mm/util.o: in function `__compat_vma_mmap_prepare':
   util.c:(.text+0x10f6): undefined reference to `remap_pfn_range_prepare'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

