Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCBEFD46623
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166ED6B008C; Thu, 15 Jan 2026 15:52:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13E606B0092; Thu, 15 Jan 2026 15:52:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068A56B0095; Thu, 15 Jan 2026 15:52:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8B326B008C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:52:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A56401AE426
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:52:20 +0000 (UTC)
X-FDA: 84335396040.17.4807249
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf23.hostedemail.com (Postfix) with ESMTP id 771A714000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:52:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZFFDRDEV;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768510338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oHjxBQsKtnmSQ9OMQYI1eP2IcRpu4R6MpuB5jtMt4Rg=;
	b=4MnZWosBNImVK/VguHuKWBrlc4C37TTeuWuDUdp+DtTCgI+jqdnv8TCTA5nkVTeqCBfeLa
	FxmjNyTBAfRwVQ3d/1WkODilEILMrlD10e4Z+Z8FaaiXNh6Lf2ZZvqC4HueHFNog+DzzE+
	6fEwQrgSx7dJQwqNE2l1beDRmSjAWfk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZFFDRDEV;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768510338; a=rsa-sha256;
	cv=none;
	b=xon7Box08Wtt7m5jEmh8fvvTQq+cojrp61Hj9iL3c+mhDDHufgMo5NY+EfxE15Sg6nSyyI
	K9ZPEuvEj9v6fsmVPwoiYtliZjR8RyOZLeY+rr0iCe8V5IKiTW+yXozx1ga9ayvktdkwbD
	GnaT0n2+50N3lS/6rM5H6zcLniilZIQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768510338; x=1800046338;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pQQGVRG/NDVNSldCrMgbQd2NvjFlVVpwVNlrxeOnPug=;
  b=ZFFDRDEVRfDYC/q9mXpMHzD3KAEUQ+llA7NOrZdLuKzW0J4MS/2cssXb
   PLkA1p9RmYecJXewkzZzKpo6WSBnkYd1SLIMvfBqCVOTWwb2I8xTxxlP1
   iHNmZHV98paH7eq54vOxDLUR+FR/pxYiv/zplhczR317kd3Wo2vk19iuD
   UctlQSVder7fU+3FBQYGEGOZHFDXm+V8a/R0QQ7OzQ9bAQyHJKaQF4IaW
   RQtopDrhzaNZVw74GZJim59KJv1VCar2I7jXcIqIwMHZGjZEIsak8NWNv
   YXomK51dGyy08JtpDfdVPN0QChCIUbopujftitJsYt6lysPmvRzfqTkqQ
   Q==;
X-CSE-ConnectionGUID: xCIOJS27QzK0Adl+MeL4pg==
X-CSE-MsgGUID: +GmCjrIzSZ+CEe2Wxd4nSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="72411546"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="72411546"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 12:52:17 -0800
X-CSE-ConnectionGUID: tDozUA/lQe+FKS9fq9cx3g==
X-CSE-MsgGUID: KmJ1BYAsT/GswGHVSqYj+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="204939722"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 15 Jan 2026 12:52:14 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgUKC-00000000Jya-08M7;
	Thu, 15 Jan 2026 20:52:12 +0000
Date: Fri, 16 Jan 2026 04:52:05 +0800
From: kernel test robot <lkp@intel.com>
To: Luigi Rizzo <lrizzo@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Bjorn Helgaas <helgaas@kernel.org>,
	Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v4 2/3] genirq: Fixed-delay Global Software Interrupt
 Moderation (GSIM)
Message-ID: <202601160402.Z1oBJhge-lkp@intel.com>
References: <20260115155942.482137-3-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115155942.482137-3-lrizzo@google.com>
X-Stat-Signature: 59udec4hb5tjn81ppgd58yej8nnyqkjp
X-Rspam-User: 
X-Rspamd-Queue-Id: 771A714000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768510338-253412
X-HE-Meta: U2FsdGVkX1/g4lc+7hkB7zavbPOvDk0aIhIhjmgcr2J9d6hMwOm4MTriGCOWykISI99hNmqGtfuet7FCBQcs7xgKv9miUCTbT45fd2QoLLjSDWYvw5bolAsTWnnTO61oonZ2Ztkt+2D6QSHSLOFqLGTkNj8HwnvaOPGimDqW0lL++K5Q5WY9or6w1Q0ozUn0OHUP2ix3yzoFGTtxRXJ1GoCM8d55Py0c42Oze2kd1tiHi5tMLu3pb0G/uftePgHWJ8iGblBP2v7lenLitgxUJIy3j9ztDdMG95Bm74cZrzzKDNrktfVVrtHxJ/uwJfqqTnvYzLHTcdalbHVVHOZFZTV7UnogtOc0y6JNdQSza6jcHBnFPBdzCkx6og0/rUxvv/XWjZnNvch9hIakQgWekrXMwy6R3gScBfVGfqm27nFnEVgXNrbFY4Ztv2zZuG5k7bqcyRAd1mZoHzvcCegwh2S58omGDrWZ8+DqxYmQiYKA3i+UH6bUHCzyHtrIs+S8flQXL2C0XQDTabpso5oQYxJlkDsiJupVsBrwNkv8B2Hyaw5yMwBC+9Pd56ibBSxjPPCh/6WVaF3ebLghHM+WSy6LJO71N/RmZae/gaJVLFEZLG86aT0G7qcFqiiSnVHLmKdiVeppZpfZCbG/otXCZKB4FvJukX2SDflmdWi+d8H9UwRfvaPIT5t3G/mi1lZWJSoEhUF8/vLYs1H6oTuXS2h7Ai7akZtW/z4J1cVKsKIiLKu/gAv+2Zr97chMput/vqndMhh/6CqIazvMgc6+xEF302IbhvQiUSZ4egOGUDS5T+2uUf5njdckWLgJ9mvlQ4m2m9YCDHHP3Rq8u10R8vD4AdZ7UPK8i/wYnCN/JSeNIwhUx3DBj06nEpkhaCwGaxnYn8MmE3X8v7Wi8C4CopDdL9/HEYOUPWhRkvW6tDhTjz7w6K8Sjsi3lcyJ2S1Q1Ot7wzExN0lxfcrwh4Q
 nEsha+2B
 zqDYXGzmu5FgD7lWI86NYCaqfqSvEKl14hReZrKZlgzZBvXmz7ybNEHhNQCzfxKEm2A5VIbZF57ztaLeLvDtkWvVcQ7D+ozDgf0CXVzJlVe4BBAxBuAn7Z8ufpFSv6KXnI4K8v0b8LklGa42I9HUMhUHqOxhyqlMaZWaXhdoV/Hs584QiEvLg/TyldCDwyR8OwqDY1HnOAqzbnDgTRAkHSMPtH8ZixZ5VOEjrEODRXm2NBUnBJu3DDzylgSvYnnHI2E1h/8SvUiy9ZeCbOs9QqGT5NfUy7YvxH/UiNnoKbQ2eRmUs1DkDGfu4j30z8squXt/g7pvrtsWUKUi+mys3RMwathWelX5S1Mk5QzO/6FDLb+Uo8dsCsH4MyWDg/tmd05rY5RfSOUw3CzKE8neGinedgjdt8dJKu3PDtRHz1MZarXLo+wA9wvPafHD/kcWClUrO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luigi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.19-rc5]
[cannot apply to tip/irq/core next-20260115]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Luigi-Rizzo/genirq-Add-flags-for-software-interrupt-moderation/20260116-000808
base:   linus/master
patch link:    https://lore.kernel.org/r/20260115155942.482137-3-lrizzo%40google.com
patch subject: [PATCH v4 2/3] genirq: Fixed-delay Global Software Interrupt Moderation (GSIM)
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20260116/202601160402.Z1oBJhge-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160402.Z1oBJhge-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601160402.Z1oBJhge-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/irq/irq_moderation.c:217: warning: ignoring '#pragma clang diagnostic' [-Wunknown-pragmas]
     217 | #pragma clang diagnostic error "-Wformat"


vim +217 kernel/irq/irq_moderation.c

   216	
 > 217	#pragma clang diagnostic error "-Wformat"
   218	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

