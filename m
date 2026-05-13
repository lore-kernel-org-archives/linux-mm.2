Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94F52CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C12B6B0005; Wed, 13 May 2026 06:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079356B008A; Wed, 13 May 2026 06:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1376B008C; Wed, 13 May 2026 06:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDCB66B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:30:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9A991A0826
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:30:15 +0000 (UTC)
X-FDA: 84762026790.27.BEAE0DA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf13.hostedemail.com (Postfix) with ESMTP id 900BA2000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:30:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IfaDKRlf;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778668213; a=rsa-sha256;
	cv=none;
	b=435g+x0XinyegcgO3ccoHj3EGDBVnehQr57hcpbayjDjOflGd78AJ3rRWt+bAc2o9vK12V
	sV8i6PO9KOapVLgyKFG5yU56EVq7jPnjeHFeExmZZ92EWNWrLieDx+pU8T9dRen1YfBjA8
	5uwskvq+0Sm6dvDf4q1Nt//tg/RXAKI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IfaDKRlf;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778668213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StY47vJI1ORU9hA/EF+pwuPQ7RIVCQUXzo6/cjZEL+w=;
	b=5LT04ROFR7D845Z0rdOcvI8C+RRKD5diaZ+Ku1rVEEuAKS5Wk9YbhraCr2BMDzMVMS/mgE
	N55JRJtawXB4i1Y6e89KrQeEj46BeenN60xYYPZp1cy4RNv2xjihN2vodmjWvXy46ovgn4
	Qy2PIbxhl1mw8A/PXW6H6OSV6yUCE0Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778668213; x=1810204213;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r7VOXrb+MC9C3wXK/vHt6NTi4VZSu4e1OKqUyO5uQc0=;
  b=IfaDKRlfzfyoki9Ax7YWuhMdLgDcC30LPcneLXCE2+xCfCa8Byz02oCz
   GesASEtjLeK3bD/bd8vDbuPAqTXQnktlSqvaTigTmWD6LP5pEHVRsm4TA
   8Ze0rImFwMEadJAEVf5IKmeF740b1OqaUIObScg9p3oHAazXJPqofQVws
   8XnDvDYQSgZwPQGpp8OK74S7tEwj+qUHiFKNOFpsHpNjup6LjMlK1/JoT
   PNz/aP6eMtfdFKHdv5E4rLGCbzCEMl5XCHXSGpM0wCAZj1sXLh8G9M7gK
   suUIUBF5N5Qaa0p9ZtRhgZV9K6u83y/YpgknDfwRGgEHjGjSoCe+PjVWJ
   A==;
X-CSE-ConnectionGUID: 7rPEWZvqTxeGzJfBh4lvjg==
X-CSE-MsgGUID: xwwXFJCDRcOgHwXuT58R3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="102258214"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="102258214"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 03:30:11 -0700
X-CSE-ConnectionGUID: nbqaXS0WTLScSDpK8bMLWQ==
X-CSE-MsgGUID: 2iH+YVimQAKXHgyast7s5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="235373179"
Received: from slindbla-desk.ger.corp.intel.com (HELO localhost) ([10.245.244.106])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 03:30:10 -0700
Date: Wed, 13 May 2026 13:30:07 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Dmitry Antipov <dmantipov@yandex.ru>,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [linux-next:master 14086/14440] lib/cmdline.c:188: undefined
 reference to `__efistub___lshrdi3'
Message-ID: <agRSr3EqFmPkBZ1e@ashevche-desk.local>
References: <202605041353.nsZSMiIC-lkp@intel.com>
 <20260512205908.7817ac71eb93427b17518ca7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512205908.7817ac71eb93427b17518ca7@linux-foundation.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Stat-Signature: zyiwkrfdz47wrpxk67ittrc5ioqraa61
X-Rspam-User: 
X-Rspamd-Queue-Id: 900BA2000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1778668212-765016
X-HE-Meta: U2FsdGVkX198PUzooISix/1irDEAYE6RpqmcJhZJscHOPUknR+pbmcUA6JvyPwY/E7YxNfUET4lA5ndRPS8y6dQAvuY0sV3Xj4m3jxuRMTjBmetaRSYfSrGKD7K8EBYh0tdcdGu/+BgiBz3w4GjHvV7p4u6EFIOnVK8eZU69UTINEDT9RvHxSEBnNQJiv0054w3G682YNV5yMlp8o3y3TW5yLhh6zxopA461y9BTNJVI5QsDyAI/jzc32nRkHeCQVXicFBN2aHYZDbAnUtAZWl6uyN+V7UALvIpC1dFeN/nKTHEnU/leTRLxSPUjEYAKpc8ysvYHaW1EcZVRyT1QfrI/N3vETHU0Oa6JNbp0AS8Ecp73WDU4vHZU8vBYyvqTNoE3hJVX626m+iwAwXJE1dCLOainWzF7QkaVlN25NoYpmOrQcd/5a3miIx+2KdSji32LHVS8uotMPT4X+m5IUF27x8kNYhu1kbWS7VNyl9wNDV4WP7rgT2oWhbGGBOLcQqXo6ERuUXrLc4w5P0YeeZkCUcfQyUcO+8lggJEcRHQJsFUBlxJUYi6gmgXQR0UapFHjFEJIR692TpjPSYUMYQv6SETGguq+bBb4agoQtYJOljFvEWwzyCFVhR+HcPVb/vpcRGX/2W7oYd0ZHbVt4JNtxtFKK4uglzU+/6lOGGhVsSEA29hpdVKqZYWSbKbSdd7UT6WVxKDrRh1F3oyiqQf2V/ZK2MTSDlYTLkku1hRi9SfZzH52YAYv5NsHpHMcGh0ZtvyfWT133Nd58cJHFwS08KS2IM+abqNq3PAS60DNqnAklDTQLvkBN/kwA10QZ2YIR1A4wFASyoILtFL2H/rLIPTQ5MwQDLCz4eV+PCGTfd8dutSLZR2X2jVV6NddlNsoNrS4fS/F8cmSV1JDp9BWNoSwAqzHqOI3rpH2ffUnJf0VW4brJH32gBJUw7Mv3LL5131PG4ptUmTMJs2
 ySF35ptb
 DmANscCUQovP695YxHMXfcYr95ZLNeiWzxBYYqpd4VEaA4MbAi5e7v/McX54JqOzU79itgU+duuQ8A1YJZ/3CiNJHx/DVdiBc2xJnolARyL4ikgwNQA1mKyhfZxgBZG1nzGJZKscLZexEg8fOt8yk/FKtlze+cXTY5whUy7FvZgPpyGGtw/1J+JefAQj4PJCCDn5KJw77Yb3B1lLt+9Y0p+/3puL0LUg/Bl95QKqDBQv3H7+xBaPBqVQJ1eH6Eb7VgBmgXFPgqBuTmz22QS0I2s1RtILtF7jmvxh2JRslj0fsElyUnkAB8i1qJsvwsldXepSw1QgSf8bt+VGBMtXSy83cqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 08:59:08PM -0700, Andrew Morton wrote:
> On Mon, 04 May 2026 13:22:00 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > head:   b9303e6bff706758c167af686b5315ad00233bf8
> > commit: 7f448f913d6f048e448df40a877be6f5afb5249d [14086/14440] lib: fix memparse() to handle overflow
> > config: riscv-randconfig-001-20260504 (https://download.01.org/0day-ci/archive/20260504/202605041353.nsZSMiIC-lkp@intel.com/config)
> > compiler: riscv32-linux-gcc (GCC) 8.5.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260504/202605041353.nsZSMiIC-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202605041353.nsZSMiIC-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    riscv32-linux-ld: ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `memparse':
> > >> lib/cmdline.c:188: undefined reference to `__efistub___lshrdi3'
> 
> Still there.  
> 
> Thanks.  I've forgotten what's happening here, and I'm probably not the
> only one!  I'll remove the "lib and lib/cmdline enhancements, v9"
> series from mm.git - Dmitry, please let's start again?

Yes, please. The consensus (almost?) was to get a v10 that incorporates /
combines the two:
- the v7 for risc-v fixes (available in ML)
- the v9 rebased on top of the above

-- 
With Best Regards,
Andy Shevchenko



