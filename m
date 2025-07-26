Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B97EC83F17
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 10:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BBD96B0088; Sat, 26 Jul 2025 06:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D4C6B0089; Sat, 26 Jul 2025 06:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5036B008A; Sat, 26 Jul 2025 06:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBD6C6B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 06:37:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57E7210FD17
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 10:37:35 +0000 (UTC)
X-FDA: 83706064470.07.C13A799
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf09.hostedemail.com (Postfix) with ESMTP id 353F4140006
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 10:37:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SCqPe9SH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753526253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShOeB0UPDCpG30uBLpR1w9nT6QrvcHdo0zHmKnl4XsM=;
	b=ZNSqQ4J7RMKA2QqRIYTfxOpfyhj/rIAP4lEcH772DNn4OnpWlsCdoh09o5bdqiDyKtzxzv
	ZsA6vGAwg9GICYQgibvjy2s+wBmGScNVBWN1CxqBp1wJ+YE5GZVm90Ti3t+dQswXS2gSkA
	REoXJDoZPtOo/ar7FQBiqUKrkJcv8Vw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753526253; a=rsa-sha256;
	cv=none;
	b=5Ny9R52Pkywauh8lRJ9AsmLPVhFWBat70YKI6LvNtGg51NHO9Mo2yjyNaMhW/y2hS8MXM7
	BQtPtAzt35vBWcVOK3xtI1Ke51f7DNiSwaGClDqOsHb0JHngLlPvzEcZCHTDhUb2a18ol4
	mSS9rzYwMLZgPKIDV0GlBzS/ytIa4io=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SCqPe9SH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753526253; x=1785062253;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vo5MJkjAfYI/OCY1QVvQzWRjvyqTgOOz6i7fhoJvwB8=;
  b=SCqPe9SH3m2I38LKLqotDY04cUz2YF1uCvBZbQitU46nvUDfZo+Pb9MO
   Rz3A/xjl+fnF1/pTCEdKbxeMPOKUasfPWSBl5rOAvfw/Y74ZQmO/KSPdH
   mZ4z8gniUjqid1M1Cq0AB1w3KGLdYYhRKEG43SJhdIoeIs9yoEsM05/kN
   chjsiH5exsAB9NfRHcII0IsVUvltXlbc+tbS+nXK6gK9d7eAj7V6x/ZTF
   kDGea9yLkxSrgrN6TKL9Wj8K1dTd6LXcMVG1r6dZyaEhuUDBDLZA0IF7P
   NdA26Iy2EjHT+wtbmQFkLuGhwGluDQMotfJq2i4IYCm4MySaaQORqfEyN
   A==;
X-CSE-ConnectionGUID: fUYrScIER4WUIuMwvoQCEg==
X-CSE-MsgGUID: +4zGZ6OeQHazLlMnNgvNrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55704404"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55704404"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2025 03:37:31 -0700
X-CSE-ConnectionGUID: ncmExNasR5e06hxL51eTVw==
X-CSE-MsgGUID: qct0OuocQruFVFyGmStVVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="161413943"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 26 Jul 2025 03:37:27 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ufcHM-000Lsr-31;
	Sat, 26 Jul 2025 10:37:24 +0000
Date: Sat, 26 Jul 2025 18:36:58 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	llvm@lists.linux.dev
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
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v5 2/3] tracing: Add a tracepoint verification check at
 build time
Message-ID: <202507261823.mtwUpXNM-lkp@intel.com>
References: <20250725025213.342188378@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250725025213.342188378@kernel.org>
X-Rspamd-Queue-Id: 353F4140006
X-Stat-Signature: giuqy5ir9w193is4xut7p5durwptamuo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753526251-444087
X-HE-Meta: U2FsdGVkX1/O8ifrJeMuoEdq4oJcWX6tdAw6KLfDbPc+gqhwhd6ZTSnaEs9tqkm9qkmoCtKzjP4imqpkziZ4e6bUtN9jR7m9OQ2dWE+M+LpXpR+DcMoRHj+QE1WY2AB8lFEv+YjPHIZaICvp8kBPhDfLtQAVEGV6v97xewtjKiFCtXyibrSWYcB5Bh3wmFI5MOXtkkCj8C6cjk+e/byr5pQb0Os4RShdiX9Paj8cwl4qYvueD7mBkMud6qu1hJge07NnwIach3Kz78SCrwHWSxuyYd1nJFKwzVczaS2jL9A1U2l0QH7q/qR6Xr+v+evya7V/O3EO/lgx51lNg40qBF6844oE4l+rdTWiBedSSLSXrdlpEDxfnj2nVc02QYHezHSY+40pe/j0RaCRAqCmI0kXSHRIQAHK6y0xt5Yx3YOngS2/EQj3s9wzCN4IW43bsz/xpBx9wK6ISWOdZ3f1c/6PWIRgV7hGlJONSCtxHL/KM1FIZq9P5bD7wRytsJhSQYTB05m4HHO/3lo9ceGws2m+pYMuibCuU2QACMs9ss0QsqXj65TOFo6qmX6qwOWApCjzN4iXIaVOqRtY6mC3SrX3FqzEqfoleIoeY7x35cJbk/QGjO+RkMBA3nrCMM1wQjzv/m9UUdUPfLdEK/fOGldnDU8weYnrvqM6NRXN83lVtyb3VU16mQrtdP5YjONirM2zUUjc/+d7WZ0woChLgMeLkCg3PBGSmDoCnHQYnzbjUg443CNtKx+Cx0jMrejp9bVYA0zqcobuWyhXOOfFyFz8JDRiGbd1zC07XQixmOXtc/YVoMfwwu2f998e0Cgl3Y+1/q/pxn7YjN/Zdr+914DP2JuXvXWC12sX+8DU6XIjIptQHcb5yzg4gCyV7cuScszybnPLU7JxxH8PJJb7PacoLMDptZVsunToE+XWP6amN13pp8wIW0SvkGd+YSSf2CpNppV3tl+OwJyHSI+
 9+ZcUDLY
 VqhgUbPrBfgvn2nOWFEK9iAM7m3LU2jHTT6qrb+k4TYsOpV+Jb4aMMNgxtZOxaFThQZhfbE5pfJjt8L9X+MlYtpn+eScyaEJN/V/AAPSPssPyKyOoTPf28UORSNlcslq/C7dUQWGqdHpIraW9PQ9esjycW6ldpnLvgLTgvGznmxJfhVuZgdgQbgMRStZEiRLaA1iUyT/LEoqs5oMpLig8oRd/rB85kMk7lJiLRdDpUPjfm8gP0id0A29VkAIAXNN0yT/13MJhFWdqOi24LROJKoEQov/x7xaG/F7K8rkcFXDkK8t7gDc5hpSpGQ34uHwkz23kubqsKsoksutcJkJ1rlIyKrLHd4eFTTbSafKCCBgDhDL9NfiyKH4JFtj1mBruNNXg/AAWayoi5EhiwPE94XeZVZoV9COo3xHrK33+hM73aik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build warnings:

[auto build test WARNING on masahiroy-kbuild/for-next]
[also build test WARNING on masahiroy-kbuild/fixes trace/for-next arnd-asm-generic/master linus/master v6.16-rc7 next-20250725]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/sorttable-Move-ELF-parsing-into-scripts-elf-parse-ch/20250725-105526
base:   https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git for-next
patch link:    https://lore.kernel.org/r/20250725025213.342188378%40kernel.org
patch subject: [PATCH v5 2/3] tracing: Add a tracepoint verification check at build time
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20250726/202507261823.mtwUpXNM-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250726/202507261823.mtwUpXNM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507261823.mtwUpXNM-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> scripts/tracepoint-update.c:106:6: warning: variable 'count' set but not used [-Wunused-but-set-variable]
     106 |         int count = 0;
         |             ^
   1 warning generated.
--
>> scripts/tracepoint-update.c:106:6: warning: variable 'count' set but not used [-Wunused-but-set-variable]
     106 |         int count = 0;
         |             ^
   1 warning generated.


vim +/count +106 scripts/tracepoint-update.c

   102	
   103	static void check_tracepoints(struct elf_tracepoint *etrace)
   104	{
   105		Elf_Ehdr *ehdr = etrace->ehdr;
 > 106		int count = 0;
   107		int len;
   108	
   109		if (!etrace->array)
   110			return;
   111	
   112		for_each_shdr_str(len, ehdr, tracepoint_data_sec) {
   113			if (!len)
   114				continue;
   115			if (!find_event(str, etrace->array, etrace->count)) {
   116				fprintf(stderr, "warning: tracepoint '%s' is unused.\n", str);
   117			}
   118			count++;
   119		}
   120	
   121		free(etrace->array);
   122	}
   123	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

