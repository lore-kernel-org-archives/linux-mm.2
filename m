Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B08CCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 17:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747CA8E0012; Fri,  5 Sep 2025 13:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F80B8E0001; Fri,  5 Sep 2025 13:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E83F8E0012; Fri,  5 Sep 2025 13:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49FCC8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:32:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A913160329
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:32:53 +0000 (UTC)
X-FDA: 83855891826.07.D06DDD5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5E1BAC000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:32:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LzZjwWuP;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757093571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+vAmicF6nVTXZrjOseCElfITQkNT86x7/OYXZUR/Bg=;
	b=djr+XhtlqE3xemDp8eRtBy1XlrROffdLjGys0ofeKiSVsyzRQNZeoQ4QGipQU+XR2n+Avj
	7J0g2o3P2IkC/+cZF3lp2foCRcMBV/7STmgRFCTOikg/rG4Oa8UFWEiEokdqM4UnhMliwr
	ArJlPDbb5g4EpPTF9DYMp8OEdCA9y5E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LzZjwWuP;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757093571; a=rsa-sha256;
	cv=none;
	b=IqO2xh4VOCPohhTr9/CXdjNyvUoDW/X8l3PvsWk4co2ZCsl4BCI2LldJh1sECS4A0pUTEF
	rgdJ7R71xEWNHkSXCPgMgEPrub6l0+rXhXtdq+Fh4/fqqE5hGyaA5W/A5QccAu8BPbVMHw
	fU/NBML10GgrRAkqJcoaKyNMC2fRMFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757093570; x=1788629570;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PEGsZAepDbJ1MMax+RK70rvBZZ7cEtrPsxDd14XsltE=;
  b=LzZjwWuPgxs88LrPASaOb/Yap+DukdyTJYK1o4liSqaNUVJtCyfKozYX
   9hSH0xJOVHjNptHxulLiLLKN/rUCIuxT8dRjZM+gcaRJXSdRiYc4UamsD
   F0D39Lg+A5C9vbBxGUqqCcA0BAGQdfE5/bPzwRbe4nI16FnQ0WmA4kfq9
   L2zIJtyniBJMtQ7YX5BLWrz0uCuLlFhptaf8OfYXs4b5MAdQJgYBW7yWo
   Zpa2OC4rR6iLbOmiRWilUEHDbM0KcIEBnMJbMBvzyAZ1uWWdVMuoUb7Sw
   WltTsjJLmfma3VhuXVBjW3UZEPmJANMK2mpH7BGmxfhRIWrLuk8zsLzdJ
   Q==;
X-CSE-ConnectionGUID: CH7hSbDeR06hMojk7+gdwQ==
X-CSE-MsgGUID: 7XcdXC0fQauh30E9y3EcSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59372216"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59372216"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 10:32:49 -0700
X-CSE-ConnectionGUID: 7ITtwuiVSci+xRNqVxN1Bg==
X-CSE-MsgGUID: uE+JJ4AMSi69pWm/gpDqMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,241,1751266800"; 
   d="scan'208";a="172327495"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 05 Sep 2025 10:32:42 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uuaIi-0000fj-0O;
	Fri, 05 Sep 2025 17:32:40 +0000
Date: Sat, 6 Sep 2025 01:31:47 +0800
From: kernel test robot <lkp@intel.com>
To: Jinchao Wang <wangjinchao600@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: Re: [PATCH v2 06/18] perf/hw_breakpoint: add arch-independent
 hw_breakpoint_modify_local()
Message-ID: <202509060154.f5xlnJ2n-lkp@intel.com>
References: <20250904002126.1514566-7-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904002126.1514566-7-wangjinchao600@gmail.com>
X-Stat-Signature: rwnfiige7mc9gdiunjqiobbt3bxxzw1u
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E1BAC000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1757093570-836021
X-HE-Meta: U2FsdGVkX18Ele5Ed89OV8rPOinuUGyMsu8A8sWm9O+961SGlPKkehAR9Kuw4OsZZexjMkPl7p2CFDc8RDAhiYJ1NUGRcXBOt1dytBWgIpAz3a2lQS+W69naeb/0pLAGpQRTx3/MgkSeLC2jDSjhdPfNXCl5JYgfrX2Sa0Ypj6q9xejU/CahFT+ZGiwNQyZyTEYgYOm1vO4udMRpXXWQNwdqS484aOI8Nb09w19DowpAA38M09bPEEZ2Wz/8sYMQ8noKiDxHKF8ivYBqpPkDKhdz65eDyTx2VWeaSGtVFaFnbHS/b3tqxy4hwefvUYpfxMaoEPrrPb6Lyjn5T7/W9LPnqaZmdXLjY6BjcJEhyuiut4q75zOfwmpUYnzXiFn4e93St+WSoFxoabhNe1HUgyqnfmlW3cTxDMuVeCCnUCscz11ue0zhfzMCAzYrln3g7GZmfbtTjVesGOY5gQUFDWwJOm79zN7lHHVpFRnopzpzARcg6k+ir5hqhfiuXFOsRIFu7UgNcSGmusOwKQss3th8ee+yy4O5nkoj0vBwCPBt1eufr8tIMnNL5WAaf5jLHSFNSBK3/ICKL4kNZk5vhWpv+F6cefUEEddvZSDNpyn1jk855jOn7/AgQeX/P1dzLTFh7W3fI5yCI+ophTCXyeysob7U0BnPLa0QjeU0ZKDaaYsaK7ZtAs01atvFgXDzKo5xGmHmCgx6se2ZVJrsoS95/neLLu+HzY1wfLQRv2Y/Fsac/3XriMriD7mfRlJzpLog1BXYegoDKE+f9S6cU7MI0TnNgqv4YSI/H3BM1R7PnSHkvQmOG7VTuHQzZZ557MgNafPQLJkOgWGMHGlbt7qBcWvupQIwHlEJuximdmgA6BvKhKMZXDMp++6bduTQ/CM4GrrVbjsfZfIiaHIXKLrYpMYyoOmbiFfDp99QaOKbCwOVQxZ/zYqp+yLf6zqaz217dIxMfFRtZSE6No9
 AlD3d6tz
 rP4q7x3IVaSi3L6ga7NKymlyPwioj255WfcyXEczgMug+0rM0l9LV5QGfPxLn44EaBDo66ip4+Z78mKmNEWGBzO3BnmAwgu8wxUHzlKya0UDuhy/P2/YS/4PHJeuXtmcGicYHalXUyWJNZLNqiXwJPDb2hxW+r41QdeBfWNs/Un90LMCuxHnZK2qJINdiNEpsKRYyvnkMyJJv8hFaFuSNVc6MmvcjJF/lTmrUtw9Iz2N6XwMW6vhiQhhS8cq50wAOpvZxQF6/622Z4F27qeYTSqzhVCxGlKhBdECLIzwF/hEK9+KDxxSkZjn0NkmhdEwrtDbGjfFal6KwriNOuK1+s6e2MLK94F8zs7N33hT4080v/Reb5udxnzXMwyCQVfWHHbPnGt2Ipi/xXlc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jinchao,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Jinchao-Wang/mm-ksw-add-build-system-support/20250904-082544
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250904002126.1514566-7-wangjinchao600%40gmail.com
patch subject: [PATCH v2 06/18] perf/hw_breakpoint: add arch-independent hw_breakpoint_modify_local()
config: sh-randconfig-001-20250905 (https://download.01.org/0day-ci/archive/20250906/202509060154.f5xlnJ2n-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250906/202509060154.f5xlnJ2n-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509060154.f5xlnJ2n-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/events/hw_breakpoint.c: In function 'hw_breakpoint_modify_local':
>> kernel/events/hw_breakpoint.c:994:16: error: implicit declaration of function 'arch_reinstall_hw_breakpoint'; did you mean 'arch_uninstall_hw_breakpoint'? [-Wimplicit-function-declaration]
     994 |         return arch_reinstall_hw_breakpoint(bp);
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                arch_uninstall_hw_breakpoint
   kernel/events/hw_breakpoint.c: At top level:
   kernel/events/hw_breakpoint.c:999:12: warning: no previous prototype for 'arch_reinstall_hw_breakpoint' [-Wmissing-prototypes]
     999 | __weak int arch_reinstall_hw_breakpoint(struct perf_event *bp)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +994 kernel/events/hw_breakpoint.c

   985	
   986	int hw_breakpoint_modify_local(struct perf_event *bp, struct perf_event_attr *attr)
   987	{
   988		int err;
   989	
   990		err = hw_breakpoint_arch_parse(bp, attr, counter_arch_bp(bp));
   991		if (err)
   992			return err;
   993	
 > 994		return arch_reinstall_hw_breakpoint(bp);
   995	}
   996	EXPORT_SYMBOL(hw_breakpoint_modify_local);
   997	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

