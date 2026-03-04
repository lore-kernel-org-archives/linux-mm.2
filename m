Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 293CEEF8FE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 14:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831286B0093; Wed,  4 Mar 2026 09:13:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DED26B00C2; Wed,  4 Mar 2026 09:13:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708776B00C3; Wed,  4 Mar 2026 09:13:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AAE46B0093
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:13:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0156813665C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:13:04 +0000 (UTC)
X-FDA: 84508572330.20.1A99DE7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6231440013
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:13:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RwOP91x3;
	spf=pass (imf04.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772633583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAHe3WAoIuqLOq6eueaUBAKfGxOZn1t3o/Hh0tgypm0=;
	b=4SzJdzw9vQSP3ddek5Pr85awsA6s0uloO1o8ouK9WEeqNP3CyGFhTwD4ZbY5PrOLyY2qmf
	taIi8pqgkI2kH78ZCdFVGApptFdncFYu3DytY/M6WCgG8rZL/76bpl2L445kozG4lLZ7wJ
	LrSdhjWCsDY9Cpsu8xkvbKNAa90LVkY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772633583; a=rsa-sha256;
	cv=none;
	b=Bj0+Plmx/v/c+z44LmlliQEcK+YoN1c9Unoj/A7NrvvrPmeStM8hquTB7ebfnbyPxSoJOd
	t7FMgTYKl3bEaRcG4bnEkd2urgEn3Rkc99q9E3fMw4dEGu7Mr2i84Sr+VymzjwrnCccoVh
	LzQ1WpljNXp61QX8nbWL9EgFOCpgGCw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RwOP91x3;
	spf=pass (imf04.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772633580; x=1804169580;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sM7fQqG2KPN15dzc8Tbct9/JwiGDaACbwfLB9ADXbrc=;
  b=RwOP91x3clQ1/srPTlRkDITDnVJSH2wJZfE8b8fTYMQ3C0kKiS9e5DmJ
   /wk9riJDPV32AeC5w5kg5J5IGDCNgAPrMy65jco9cHaO2+/f4GNdVa3Ca
   DpJPFTRd+Pdvcj9dxpPrm9mplnxJv/RHMRfOn5Exk+JPJlUaOwEZoeDx4
   eiAkRHO1ThpywaUZzWlRqS6kj5q/qYr+9vqNd8JtidWrGbe/ZyZ1CIAOu
   WtRvAfeEsVlK5sPrtGQYR8rZgWU5OlKPHr+VvrBavaMkd4k6BMmrZp9r7
   Nw8sY4NvVjLh/Ud2Rl99toecj1EOwVwo9ClPBiIkhFxT3kpCicCPe1zAk
   w==;
X-CSE-ConnectionGUID: Yx6S/wkITwqYlDGDUWWQMQ==
X-CSE-MsgGUID: dcK63pazSt2TlOynMb7WEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="77298113"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="77298113"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 06:12:57 -0800
X-CSE-ConnectionGUID: Hf6RaoTRSHiCAc5Zftt/fQ==
X-CSE-MsgGUID: scQ7NbMmRMykH/N4AHiTpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="222516334"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost) ([10.245.245.127])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 06:12:55 -0800
Date: Wed, 4 Mar 2026 16:12:53 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: kernel test robot <lkp@intel.com>, Kees Cook <kees@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-nonmm-unstable 49/110] __efistub_cmdline.c:undefined
 reference to `__efistub___lshrdi3'
Message-ID: <aag95SSwClx4IzJU@ashevche-desk.local>
References: <202603041925.KLKqpK6N-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202603041925.KLKqpK6N-lkp@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspam-User: 
X-Stat-Signature: b156sshmz6n3d3pikuukzajqqc5ykcij
X-Rspamd-Queue-Id: 6231440013
X-Rspamd-Server: rspam03
X-HE-Tag: 1772633580-586048
X-HE-Meta: U2FsdGVkX18CrXCBvWDBBj7lKGBaxq8biAKQHGL56wvcK70sJ/J0qe8LCGELoKJkS85M9FpUX/TJA8+dWB2Yhsu1SIoJwJUgC25cbFZCNtd/N5AzjASRgaAhld4w0O+1+9o8FVlF3o6KnA0iTFhQGDdwMui8mCo9uJXxu4kOvkEFOeNsBTV77caCAjQ5zsEY163IW8afl/Are4NfaEZwm7urYQGcewB8YPN8wND3G10za3BBlrKGsbsTxOd8yQ6JYybcHuBYxjyNdBAQ6GcZ+Pe8/Ty25GHDndXeGOMSnTqprTPa2iM6Uh6YnEYiXx3axn4fe5v7U2RSMWuH3btKAwnPSePuaSdtk4iYoElNdbKS3jv5A84IF08qmIxxvHEeCXhux41wpu//Kyd1X4b0eyif2teutzl1X038M0671A543R1R7dgDKmbFWZcosEUeOgFUE4yxW1canDuSJxyYM5VwKvXyYRu5YhgQQS1iJGnX6oYba5P8TAP1Wgf+eoDEO1h+STfXfq9IriAiby2Jf0Csde7mGzw4bUvzTN4IaevD/LkNeO6jRFY9RBIeTX4mEn/hLiMcSmJzNamu/lroKB8nitC5UdgKJj5e1tcbFKgQxSbOEf+IKEFbxa7FpFrivbDy4lBC6oI58KblXsCM76WqWLnFWHOJQwXih7JvkJbfi4ogZ+qO83wr3G5L/WjGGwHZIRa2qr9c5sgjP747BklvPb1sdoV+9PIZ2+mYe8DaXhEnhzVPS5b/DCSTou1O6U86Df7Zs/KvkHBu100Jaqhi/hv6LNMJ8h+l8kPe5KzTzvLnNtBuzOBUPqYr6j2dZEb9zyPhLPVhPmEwaJv+Y/IPp0E6VwcBVHXlYnZU2vvc3cN2LaCLU0JAjgvj0HjPorNE56RXFn4ZxgNNBE/jO9zTU/SLXKZv/1fJeYu6Vvrq5/bvzS5vdyWDWk+yvzAaZEf25tfzRHrnahX5deo
 S8zKw7i3
 nHtmZyirCWJOyqd8Rcq0T/BX4Nww617N5TT4axYQ1LXIvt/gRhChcJbR+REDvrt33mMjn3tUX0QxJ7ZkpR89vwZewct3IuOTu64cdCviih9/L3oS6tFdhgdUXOpbZf+JhEnoa388h9p9UuquQTNgulNPE711ASCTaTVTHYMWwhJ53Xx4XLWNt+JeDUyXxCH6VPUWN2W3UsNPBUNRCgbo1z69s8sxw8wjLeQ6cnfApewwkOaBIP6IJC2+epnvlRvpL1aiO1+oaCGSC1na7hcJaaluCc6Mg7+f9MF7GqnCrxBwUKS4sYzHRK+/o+TrxVdl+DyEj1l1oUVaMYdgpTK/2OV0d+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 07:29:09PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> head:   09c4ad73ba08ac959a6afb5e019826743837e0aa
> commit: 7c5bff091374a7980431237af80e6da21dce74fe [49/110] lib: fix memparse() to handle overflow
> config: riscv-randconfig-001-20260304 (https://download.01.org/0day-ci/archive/20260304/202603041925.KLKqpK6N-lkp@intel.com/config)
> compiler: riscv32-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260304/202603041925.KLKqpK6N-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603041925.KLKqpK6N-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    riscv32-linux-ld: drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L38':
> >> __efistub_cmdline.c:(.init.text+0x1d4): undefined reference to `__efistub___lshrdi3'

Wow! It seems compiler tries to use some intrinsics here?
Cc'ed to more people who may be stakeholders of the efistub and overflow.

-- 
With Best Regards,
Andy Shevchenko



