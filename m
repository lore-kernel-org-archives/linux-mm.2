Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24173CFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75EFD6B0096; Fri, 21 Nov 2025 14:14:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F5E6B009D; Fri, 21 Nov 2025 14:14:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FDDB6B009E; Fri, 21 Nov 2025 14:14:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 493DE6B0096
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:14:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13AF1BADD4
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:14:39 +0000 (UTC)
X-FDA: 84135565878.19.9561983
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7135314000A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:14:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CKqEaJ7m;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763752477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/O9Eii6dat9eCp/ibDvYWvyJXa+g5foPa3ruMXQLMzo=;
	b=5ZDhG3z+ez82igCB8LtHa4FXW4Td0U1TixJaOK6La9O/l8JoLoJM0cvun8GpzfltVzU6kd
	3S2EaebRfPxm4+rrigH25Sm41w8rFiHBGKyz5VTbf8BfHLhNaQibzV+R6KQbYytFw2rI49
	5IV7sR74XPHTuZxUmUERbSXyhdLIB5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763752477; a=rsa-sha256;
	cv=none;
	b=GRWprP5vZ7neh14yMWsEqTPA+GhcBLS/01j+D9p6hKgNmNyv35z5mCc0EVs5j+GEj2Iw0x
	wh9lyelPSv730wMCYryhdH7kaJrhvG0zyuAIFY9EvSSsff8j9YByuv4GS0r31UnlLMyuEc
	1OsUr4u8XlXZNv+RVajTd4aho2Uty0A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CKqEaJ7m;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763752477; x=1795288477;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fGWNibXFUGAhDYfqhQTSp+K9Mm1aNTTr8crCL6BSz6s=;
  b=CKqEaJ7m+Util47zKTvqYfABDTgN/de324F/q1iCwMtB4ONat0RZwmjN
   EDLkH5cIibuWVmwiDS7PdhNOvpY0qM5Nw8LumH3u0YUCy5qqsNTQ6dMHx
   bmFvRHCRxJGXZ7kVhasbzdVvzz0pJl/Fd2PjFKxBRgc7lAyWmPnDUdgz5
   +iSi0pqQsiCbovnUbGiYLqlxLzdDnfpjhKNIM4f+8NqkOIhFo6k6GgvPI
   8b8fwO64SlPvlPPzB6WCTPCJW/CMrxMuDFCdMg8wynmpMGhx5m/Vzqd8H
   jBrF0/LZLSUUTYZo/BgJPeSpzSrRo+kFOypUJyQuEkzU3BzGdbSkFePVx
   Q==;
X-CSE-ConnectionGUID: eGMXslY4Qb+LO7wW2JNkgw==
X-CSE-MsgGUID: oZmwMckhRciM3tevJrfYfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="68454995"
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="68454995"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 11:14:35 -0800
X-CSE-ConnectionGUID: 2Ijzr5YBT3aA7bLtsNb2Hw==
X-CSE-MsgGUID: PUXp5Oq0QOCwVdGLd9G5ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="195936493"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 21 Nov 2025 11:14:28 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vMWaP-0006m3-1U;
	Fri, 21 Nov 2025 19:14:25 +0000
Date: Sat, 22 Nov 2025 03:13:48 +0800
From: kernel test robot <lkp@intel.com>
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	tglx@linutronix.de, andersson@kernel.org, pmladek@suse.com,
	rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
	mhocko@suse.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: Re: [PATCH 03/26] mm/percpu: Annotate static information into
 meminspect
Message-ID: <202511220241.7y7acdEZ-lkp@intel.com>
References: <20251119154427.1033475-4-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119154427.1033475-4-eugen.hristev@linaro.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7135314000A
X-Stat-Signature: y7ngwqigosnmtns9fi85z57i54qxwezk
X-Rspam-User: 
X-HE-Tag: 1763752475-863078
X-HE-Meta: U2FsdGVkX19IL2eqASHy1LqwC3Kxa7A1im6gc+RQIf4d3/mr0AAGzD+wfc+vj4SPQQ3f4ydteIHsarqjXT/25/zwsU9CxcJTTjEUZhdVyPbxQIwpAnPS6QnCI5BsSZ9nyNS4CYqt8vNK4LRfMLKGhLXJwvm2n4Cs1bPHK7AzTrjJrabhWVpIsnvlrMfif+qlXkytsQmV/KH9YieWX/+4NA2B2gFHBh0tAQ6SpXWI+0bVKcI1PX2pptxbQbNY1/mdFZTTfOO2OCDkywi/NEX1SGDLiW0UGljaN1zcpUAjQpRCET40/87sNe3+xAr+BY/CKlJRlvyZshQNV0I9d6CdHJk/HfiWBUh6UVqrsqn2qLQfLMEtIW1a1QH6Y4noqLLFXaaWdqtwb1uF1NpEdUSnioQBotBSgakIXfrvwjpH0epG5fCl7VDrVH2mHurF/LcN5KdE4Hdaq/gTIotQ9Rm4ddXlDe/eCMgNyRggdbrB+OUp9dkDZfCYlrZBe8Evl4vdYUmGO3BkFWGUGNR+UBMAvWQ42BgTvPIGmMkZcQ9+MrTetzZWJkFBzRtBkZ4x/lwu2IpC5KwQpNptvFNJH/E9VTx1yN66y7kG2QPSgCcYA4l145vythEJ9rVmdG8k4zDZ6Ob/oNR+JRFYVdJ1Y043XEKp0MfoAZoNnOQx6oJzqKijunmPMDg37Hn+XXvTZIDz5mJ5+/HYdKqKhQREYvv8y+LCXWaFtDL84BzPZ+ssCctqzFSFQ3FijlHPUVO4YJcWQB+ntBGhcF1suKfh+uGDWL0yekTz6DE8j5SO/+mdonmmVXyP5lGFAAE/fohHeGPZGgN30pjba/QxrJvRH2b3bZSbbbYxky6sU7+ipKBP0ZWysIUxiry6tNrqBu8PY9sgRQepktkd6toI/3lxRpU86Y7vDatb7QpNownzQ5sooJgy/uV6hCLSvgZ//jfs1wFmD3Cp5y5L2clAyF7u/D9
 9WJ9fogX
 rRWMqMY5RoNmTAG+7M9jS5A8zVMbECvg3OS+fAQdF121cDiGFw+RZNRsXeddZVUvoAkMB5fWEVDgDNmGzDZmL+lTIIKJbr31yEcoE5UeT4tNt8fm8jXCRHZ6b5p0xcPNOtaty8pVaoQi9V03udZ/5rHoMb4k2XHImACi9xbukPgVRIkSsMc9qBZufvu2YP7jXQTINywz679OJysHg3fwwEPop+wZmQil3/jCoeN9x67JbSyvw5Gao/7JFj9UupAMZNEktBF3G7jO2I3r6628WCJjVZOa0OKTcfEG2RcHX5vSgm4NMfW/LGKhePQve+pmXFKJ6mS8f1r65q9NP35iVGd7MTxAJkEhLmH3DmZH5hHNBnuV121k0ee+oPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eugen,

kernel test robot noticed the following build errors:

[auto build test ERROR on rppt-memblock/fixes]
[also build test ERROR on linus/master v6.18-rc6]
[cannot apply to akpm-mm/mm-everything rppt-memblock/for-next next-20251121]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Eugen-Hristev/kernel-Introduce-meminspect/20251119-235912
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
patch link:    https://lore.kernel.org/r/20251119154427.1033475-4-eugen.hristev%40linaro.org
patch subject: [PATCH 03/26] mm/percpu: Annotate static information into meminspect
config: sparc64-allmodconfig (https://download.01.org/0day-ci/archive/20251122/202511220241.7y7acdEZ-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9e9fe08b16ea2c4d9867fb4974edf2a3776d6ece)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251122/202511220241.7y7acdEZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511220241.7y7acdEZ-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/percpu.c:3350:25: error: use of undeclared identifier '__per_cpu_offset'; did you mean '__per_cpu_start'?
    3350 | MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
         |                         ^~~~~~~~~~~~~~~~
         |                         __per_cpu_start
   include/linux/meminspect.h:101:40: note: expanded from macro 'MEMINSPECT_SIMPLE_ENTRY'
     101 |         MEMINSPECT_ENTRY(MEMINSPECT_ID_##sym, sym, sizeof(sym))
         |                                               ^~~
   include/linux/meminspect.h:92:29: note: expanded from macro 'MEMINSPECT_ENTRY'
      92 |                                                .va = (void *)&(sym),            \
         |                                                                ^~~
   include/asm-generic/sections.h:42:13: note: '__per_cpu_start' declared here
      42 | extern char __per_cpu_start[], __per_cpu_end[];
         |             ^
>> mm/percpu.c:3350:25: error: use of undeclared identifier '__per_cpu_offset'; did you mean '__per_cpu_start'?
    3350 | MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
         |                         ^~~~~~~~~~~~~~~~
         |                         __per_cpu_start
   include/linux/meminspect.h:101:52: note: expanded from macro 'MEMINSPECT_SIMPLE_ENTRY'
     101 |         MEMINSPECT_ENTRY(MEMINSPECT_ID_##sym, sym, sizeof(sym))
         |                                                           ^~~
   include/linux/meminspect.h:93:22: note: expanded from macro 'MEMINSPECT_ENTRY'
      93 |                                                .size = (sz),                    \
         |                                                         ^~
   include/asm-generic/sections.h:42:13: note: '__per_cpu_start' declared here
      42 | extern char __per_cpu_start[], __per_cpu_end[];
         |             ^
>> mm/percpu.c:3350:1: error: invalid application of 'sizeof' to an incomplete type 'char[]'
    3350 | MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/meminspect.h:101:51: note: expanded from macro 'MEMINSPECT_SIMPLE_ENTRY'
     101 |         MEMINSPECT_ENTRY(MEMINSPECT_ID_##sym, sym, sizeof(sym))
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/linux/meminspect.h:93:22: note: expanded from macro 'MEMINSPECT_ENTRY'
      93 |                                                .size = (sz),                    \
         |                                                         ^~
   3 errors generated.


vim +3350 mm/percpu.c

  3349	
> 3350	MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
  3351	/*
  3352	 * pcpu_nr_pages - calculate total number of populated backing pages
  3353	 *
  3354	 * This reflects the number of pages populated to back chunks.  Metadata is
  3355	 * excluded in the number exposed in meminfo as the number of backing pages
  3356	 * scales with the number of cpus and can quickly outweigh the memory used for
  3357	 * metadata.  It also keeps this calculation nice and simple.
  3358	 *
  3359	 * RETURNS:
  3360	 * Total number of populated backing pages in use by the allocator.
  3361	 */
  3362	unsigned long pcpu_nr_pages(void)
  3363	{
  3364		return data_race(READ_ONCE(pcpu_nr_populated)) * pcpu_nr_units;
  3365	}
  3366	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

