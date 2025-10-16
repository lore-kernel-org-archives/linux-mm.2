Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE2CCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 10:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2388E001B; Thu, 16 Oct 2025 06:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62C58E0003; Thu, 16 Oct 2025 06:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51D58E001B; Thu, 16 Oct 2025 06:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C542A8E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:55:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B4B01602A7
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:55:26 +0000 (UTC)
X-FDA: 84003671052.25.0325738
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9D96CC000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:55:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CYZEB6xB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760612124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onSbeOmoNnOUhQFdTYMo4opVD5xdl68I1+VoP8OXoBM=;
	b=EbElXQ9IMr+FlqyEbZjknmDWRMwK1o9Mw5sqh+Od2vLasbXEJK83/kEyk6/PAqUTpVNRME
	NBXYOC3uE9DjIu2kO6+TYVIGMeMBlsVqc6exdUWmQtw0BmCv4IHJoTg4yb6KLqOZ6YkR/S
	dqrY26y/e0jISUjLUQxgYPV+BDzfhcI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760612124; a=rsa-sha256;
	cv=none;
	b=0CZjZ1xrYfgu+/GPGCqbPR14YPrwgoauYxX8utEW7pArmoeBhGhztvPpKVCYCrBDhmxoNN
	eks8nTt8jl1yWJtRGqZQAVxQ7h/YgU9yBbaf2bkINuf8rdAjpNEntUtVSOH0VjWi3g+3/W
	qm0gGhhXw4hy9xBwl9w2ipTzR6Kw9JI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CYZEB6xB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760612124; x=1792148124;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+kiiKROK28TM5gnwbZCyi+ykIDPugSZOQFkBToxu0jo=;
  b=CYZEB6xBm19T2gkWKfahdTCQNhbu59nMuvToccLHnRDIoorESaxxVlLJ
   96ddZhdwDysVGQ4Khr733gNumUIVeOMnopyWFfAwa+/ciE+zY+XVy2mNl
   ++MOSlKdhP9u+zhKixYAw9QM1E8HrRduipVLoAXsFTnCaDc9LrtvaS8fs
   uXSACoSJWopJQMjyxoXKb1YtB5S38MMdzY2hU69XOeHcxmAwDmJ0ABjfg
   v2okIDne8twJt6y4O74AlFcpMO6IT0yfS/CgxEdM/Ay2txn09eO3apr+q
   xH1FdVThQpXh8BBs075qKJ3gj+TytwpOxNISiIHPsGcmEY7GGWzNZMRah
   A==;
X-CSE-ConnectionGUID: v3aOFRZOQACkTZOH33qNlA==
X-CSE-MsgGUID: Ieys9iPySBuPsYNu0w6IDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="88270171"
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="88270171"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 03:55:22 -0700
X-CSE-ConnectionGUID: 6Pwt631hROa6t2dloMedSQ==
X-CSE-MsgGUID: nVF/XZuOTxaj+SsEOmyH0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="182406928"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 16 Oct 2025 03:55:18 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9Ldb-0004il-1P;
	Thu, 16 Oct 2025 10:55:15 +0000
Date: Thu, 16 Oct 2025 18:54:59 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v9 4/4] tracing: Add warnings for unused tracepoints for
 modules
Message-ID: <202510161811.9iIH3K15-lkp@intel.com>
References: <20251015203924.731213165@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015203924.731213165@kernel.org>
X-Rspamd-Server: rspam01
X-Stat-Signature: 7ucib7aj8fkp6hak6xa9wmd973i9msps
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D96CC000A
X-HE-Tag: 1760612123-383754
X-HE-Meta: U2FsdGVkX194gRen+KsqzT8lPrIOJX4o/ZiKoOl1x7BOTOLvCXFoWNLj5u2okVcDr3vzuvUEAScT8AXHZ4z6sOciXBp1yiUu8WHHONghyQgZlLhD4P209q5Wwg7fMBrSqWo+BcQvnX2U/k99dPAvgNoJe2oX/uUG/GXWt/m/W4jt8J1yxREs5s1Ft9wrbW/eZjCyEWSBLhaspv/fA2k8YaRjt1bDY+fwZgbsYK8C22PA4SHBz+v9LBFyEkaHQ25RQGtxtja0AXZ7s3wrUbAeHfIZr8mAvgOgasH94cGpjep74ZiFepNx0cCmR5zphAliR91OSaBxTq0Fv1azMc4IFK2NK5I3y+o2g+UMjDZoFZBWMMBUPxhVsNXc6/CaxfGmpM9U6GNun+rhh2apEI3eqXyRmLAgc2KwTOH2wp1L62O63K532qMJzcKU4P/cPq3394qsoEczcTYrpVyZhFAFr2bjpc2dSclG8C3HrkYLbeGYJ0Y7yTCyxfgxSM9E7bZmOMMtCgnAcsr+ug3r8MwCkMNKMyTaqESwJ/YmbodY6w45avmM8cBHezi/vab6LhJRv1eMf5Odpm5F3lUVHasRvOPtoanAt7xr8MTyiDfPIkLYIfhEJZ2udpe6YDUMyJ1fIK9UkrOT9/F++AHR7tM7wRCOwkAHSe0Cj0Gtcv2ZQGsnOTVcK21awv5Uq3Jcipc08y4wUWUVY6KBuq9myqFRewQNxiB9onmqp4mYMWQM5Forl/Wv35PKLjaosO81t766f8fF2AyluMH2ZKnLJwUDu2tlGd053oHt029T6i4RH0mSvD1cVjR7RVwX5v5U4geYW2aMbfNYlNJQrggTIUR/TVPhJUodZNfjF3R69W+2zxV2aC9XMB4mTaUNtVdrN0uP9X3JUNQgVIbeZFGYFs7I1pBGLTzdNw7OsTBaMe5phGLp+J+VmA5OGJbzpiwEXOWdyx03TO0qyM1sSkjgVzk
 NMYm32k+
 PFXzNETdlIAGhkkPAvZTVvUUaRJIvoAz5gPj/uZXMVPzPpWMbWAZKybUjweGVewQ2n0J3dnwreyftxjrfBZ4/ymasNbN0IFwuoK4pSpMiby5kRvFgJzL9MuJF7Y0VGYCiVdjS7sLtxMSiEJnODK9qMLAVtyEAD/X4q3m3VwjC/l7s0n8xe+tzh5y5uedNIntSm86GlyQDtaurGaRWkO0qIXeBGZIxDJNoa84Q8oMeiTedulYPjGlsDuC/FVyhLg6m6fdmoBbHjngHcXOl98aXAH/oYSTLOW8ouCJLGKfTQ6i0ayJal61GA+DQPc5ldKi1vwG7rfTQBQoUAmMGkx5DDWiBoadaU4HOc5NJB58aT9IUjpsj3z+oGCGoRgerLcUogxIxtCzJIMC8qoI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.18-rc1 next-20251015]
[cannot apply to trace/for-next arnd-asm-generic/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/sorttable-Move-ELF-parsing-into-scripts-elf-parse-ch/20251016-044008
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251015203924.731213165%40kernel.org
patch subject: [PATCH v9 4/4] tracing: Add warnings for unused tracepoints for modules
config: microblaze-defconfig (https://download.01.org/0day-ci/archive/20251016/202510161811.9iIH3K15-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251016/202510161811.9iIH3K15-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510161811.9iIH3K15-lkp@intel.com/

All errors (new ones prefixed by >>):

>> /bin/bash: line 1: ./scripts/tracepoint-update: No such file or directory

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

