Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D56151099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ACEE6B00F4; Fri, 20 Mar 2026 14:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45D9E6B00F5; Fri, 20 Mar 2026 14:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39A916B00F8; Fri, 20 Mar 2026 14:12:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29DA96B00F4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:12:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEA671A02AF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:12:27 +0000 (UTC)
X-FDA: 84567236334.11.C29636D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48CB9C000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:12:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gGwTdQ66;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=UazR68XOuLecnGtfc2ve+iiIocfq1tzn2+f0XGQx8z0=;
	b=5YvOyUBzrFhjEWvVITGadOVjP11ildSssJKacpPEyV9JQ2NvUpvKUJb/k2c70IsBDVWT7P
	UscjH/VZMxN8arYX/kGDGOUWTaktft882oe8JHbrL+dtqmanBHbEvCfUq4dJSRil7W/QXY
	RRhwC4jBwKwZ0ZaJgEVd2tnRHF90BmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030346; a=rsa-sha256;
	cv=none;
	b=xpOYVfvWBilNB2KaHD/i2mOyG/q4eKA6Bgqr3icEjzwcSNPvKdcRKN8DRrchsczifFhAtV
	c3s1hl6wsWlfJp/2inSNA3qopYSrUBhGzDTmRzsyi+rcR3bXeqK/L6xQCM3UmDlyfHbqHZ
	r+LGuamExGqIRe1AT373da3kPtaOckQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gGwTdQ66;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774030345; x=1805566345;
  h=date:from:to:cc:subject:message-id;
  bh=yVcj7mj+ZqayH04d1YOsOFjcXHIueBawLUDy4CtHBJc=;
  b=gGwTdQ66S6RSKIjwD2OB3vkfJFOvG/R0bJsOxvWk/2zE8sbYas+tgsDM
   ypws925jXseU0VKxiWF2d1HWSU0Ku/3r/u8cFb3oyGB2yRf9NXOtUzbY1
   IRDXBzd+nVGt9IIR5bJatXws0Q95WYD+WK6cylDUzE5u/oQ48csrc5is6
   nuS5cEGilZC5ctST/qPfqLlN+52Lt7Mp+J0m89pvbLLzlrz8HScFiEE9r
   WuvOJVepKUnHPCBB+NFjJveNstSEQPn4ktepbbh3cBVZWIOr+4Je/hRgf
   7LYLbZoh4B74j2QEm/zOWEahscRDpHlN2yR9lLIEoYHCce2TRBbwO/hDZ
   A==;
X-CSE-ConnectionGUID: 3xEduf4jRviQ4UG+3O2Edw==
X-CSE-MsgGUID: aa2fax7rSc6/9Pz4e/rcJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="86196666"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="86196666"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 11:12:24 -0700
X-CSE-ConnectionGUID: j1vkBHouTA+lwYCEoURdqA==
X-CSE-MsgGUID: u2vTkQFxSwaA7AWh0Y5Trw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="228298019"
Received: from lkp-server02.sh.intel.com (HELO ef9b23065726) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 20 Mar 2026 11:12:19 -0700
Received: from kbuild by ef9b23065726 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3eK6-0000000004b-0hUB;
	Fri, 20 Mar 2026 18:11:55 +0000
Date: Sat, 21 Mar 2026 02:11:39 +0800
From: kernel test robot <lkp@intel.com>
To: Sasha Levin <sashal@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 7602/7971] clang: error: optimization
 flag '-fno-inline-functions-called-once' is not supported
Message-ID: <202603210208.5TW7E8WX-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 48CB9C000A
X-Stat-Signature: h8z9zjdq59r3j9u4r9acgs96kyyrppkp
X-HE-Tag: 1774030345-108207
X-HE-Meta: U2FsdGVkX19KzO8HeL/Y7HS2zPvnaiDD1E1ivbflhquWDvOL8h0U0Qbyg1B15aE0flW5Y5opB16F9wphTzk/Y8k1yzQUVA6OsIJ0RyNOJaUtzILOQ9mN7kx5nK9+NnvYLbSfveBMJdsIMxaeAfgMoWDgi4jXw5nSaLD3r6VsQOrNIobCRfLJZNc47CXpzmZMGZubjjnb2uLNZI2dKgSqcO/29BuvYW7fwtOy352FsK8HECUAoDLUvf3EPZkPlBkhru0Id7YFO/Aalmy/7rUNkxMld8nEpBhcjb6dyppM/xpbvCQY+DSL0YhT15QvPGp0fiCBukr1Vs1EH0MEixstq7mb9Hs5cFJVfhxW6OANMXbB5rcNaduOXwx9ATjy6btMF/MGYmpNa0NrOZ6k6HSMiP5U0lOhUECrlFD5rBMWD5hJ5hJVqUIVkH5v1a5mP3TAUW6DF73HGvIGeERRJD+4CXSmXwIaZxeToT2aKLqfg9MXBrPUYpaNqUtOPW490JbHy53Y5mLAACbIf/Hmc/jadW9DUi+AeLzkZyw7CqNw4sT6B5eiq3S45KoxO5wDagJzrVMV7rWcVkw4AcuUBc+Gx23kyXPwI59SfMnEHw7LarS0NzdO1yaYFc4XGmI5Bsg6/OF2dzBXk+/Apk7bTtLZzxjiQoQ9FNNnNM54p/mxSb0ZsS7x1Yho2D8+sI/uR2L3iAO1ivGV84z/3manGCLHAXhQPbvyPcZoz7fJv4DjcQFOSMSq2Op9PZf4X5Ls8Y8VlbqWFE6/hfRGiVBv7/jZs5jRE+FixKwfBMlDlo+vBjcvOg44/g1jZV8gfCJwhe/T9tnbR2FSF7ASfrGPfhka5SJRJNmlWzwNb+GECbqwXkYINj46mWbooy5fRFHF+Uges0QAILg9QSE1sGE61Oky82uByI76nGcKrm02E/BZeMScoYR6n23KnpjRX2jdB57yUkQV1SuZoJ57DdzDZ9V
 ICsE/zUD
 bwfMXcUE/eRKr5sA0VlMVsxP1gyT1vpAdN4KdyK8kkj+4CnNOM8xNaLvgqS+MCXXJvWDtxbms4Gg3+DPb7x8QOGg562df+DaBPrw7FsVHmsWMgs0P+V/RcZ0T97srbSLVIpsZuv+UzW7jCBhuHt1LuNXtKkGFamz47nPRp/x+SyRoEGzcll02mvbjjkT/f2suwKCcCfA7axMnuYB6HmX27pjBIrgyEmL6jW8fPPmBk0rIj3IsyavP/9jSlDdG6VaYTmkjq6JUMRxTPW+mFMfjEl9ZOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   785f0eb2f85decbe7c1ef9ae922931f0194ffc2e
commit: ed597c460186e314ddf85c37634f260eec4a3879 [7602/7971] kallsyms: add KUnit tests for lineinfo feature
config: sparc64-randconfig-r072-20260320 (https://download.01.org/0day-ci/archive/20260321/202603210208.5TW7E8WX-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 4abb927bacf37f18f6359a41639a6d1b3bffffb5)
smatch: v0.5.0-9004-gb810ac53
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603210208.5TW7E8WX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603210208.5TW7E8WX-lkp@intel.com/

All errors (new ones prefixed by >>):

>> clang: error: optimization flag '-fno-inline-functions-called-once' is not supported [-Werror,-Wignored-optimization-argument]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

