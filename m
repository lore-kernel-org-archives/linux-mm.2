Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D5BDCCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6416B0088; Thu, 15 Oct 2026 23:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866A56B008A; Thu, 15 Oct 2026 23:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757436B008C; Thu, 15 Oct 2026 23:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46EEC6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:29:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D47EBA7B4D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:29:42 +0000 (UTC)
X-FDA: 85327059804.07.CEBC9FF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf02.hostedemail.com (Postfix) with ESMTP id 09F9780008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:29:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=awD8Voqi;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792121380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5pgSEWinxan2pDZSzTPJxpPMuTDs/6THYlNwGPxDwc=;
	b=mOjIc5L1cXihr1f+r55mwu/YKX+bWUn1mtyHcGXN1JpeprehUkIniLbz+x5SaR5JUUKcHr
	c8pBrxEgmQLGa7XvURUyhRJCErOiFMhSdfY49iUwL9TtkLfhUqEFnLNwbJrvavHzMI1VZI
	IWuUt3LieZd+VjHuhsutuXuFB026tow=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792121380;
	b=f4Lx6l4A89HL4Jd7jANgfsCqQK/3tptCw5r2OwpO1WoPw9PXgE9kZygKhQNUOwFdVO8FEX
	UX4iEPqG6zHfdk1OK58tOlKN1sCf7vXVDx+xIjQvnfkiIkI7ZHEToF/j9sEy0Xw6hoJcTj
	9IY7+fyqTS0ZZ8l5jQdk5FUesGIAqUM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=awD8Voqi;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792121381; x=1823657381;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=71GSIcxEMpRjtYoSi37Nnh4/rxvAHJsP/1K6nZ0XMcw=;
  b=awD8Voqip/nhcsDNnvoV7mX3PEWPm49NdUiwzeA34NVsQL+B1BGku4xV
   D4HUoeMDDtvljk2GHIw1z+q/ARQ7Kq/5yUKA/5f/EM/KxkNKsAdqc3FLx
   RHSRCAtVCWuXUAfR5VGAKtV2n00IUeORlqfbWXv+wZkcQBdWI9h9zYPQY
   e4OkSYX8FTp1AWJHXWg5Pcet4HNc9FUWQri2q7nmoX1JikdiazAl+8McB
   B0/MaVHwJImGK2g33DECFImpF0fuiUgdo1or/HKK38dfTVBihzVzlh/r3
   ifK8IOKpShJaD1EqytefoQImjIj5TEw0fZtAV59Mbu7aAkk8NdJxp52Dy
   g==;
X-CSE-ConnectionGUID: n9gg2nqYQn2W2OmRn6WKJA==
X-CSE-MsgGUID: iMUNS3eWSxeFMf9K7SLybA==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="934434"
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="934434"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 20:29:39 -0700
X-CSE-ConnectionGUID: aMKarZ25Qi2Ha5sEpfWFpw==
X-CSE-MsgGUID: MkCdbVcdQZ2S2gywbQkQuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="1856314"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 15 Oct 2026 20:29:36 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHYdQ-00000000HWE-2Psi;
	Fri, 16 Oct 2026 03:29:32 +0000
Date: Fri, 16 Oct 2026 11:28:46 +0800
From: kernel test robot <lkp@intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kees Cook <kees@kernel.org>, Petr Mladek <pmladek@suse.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tycho Andersen <tycho@tycho.pizza>
Subject: Re: [PATCH v3 1/2] vsprintf: Don't leak pointers for %ps without
 KALLSYMS enabled
Message-ID: <202610161107.ckH3ptvE-lkp@intel.com>
References: <20261015-vsprintf_kallsym-v3-1-c175c27f38b7@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-vsprintf_kallsym-v3-1-c175c27f38b7@linutronix.de>
X-Rspamd-Queue-Id: 09F9780008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: x3c7gu334oc3hs4dmhsgcwgaq7bjeu48
X-HE-Tag: 1792121379-973177
X-HE-Meta: U2FsdGVkX182upc7TfvunBi6YEEKlzTcWGPCz5+9cNzndOwZqxIohWGJbwguxNqseK9Z4CdVzBxJw9mFhf3olGZZrJWvYNprjV+ad0C3zNRPf+h7Pgr3bZLV5OxfVmBJ1rTHqxERfygZG+HhfvNZ2zQexicHCaNeOwcJkVUqY/WmTZIPbRTK+9OtdmGa/HqlzDuNw4lNN+joQ9hLIVqTqur1PObo+E4DAAeV70gQcjX+ertwx3bz9yE3VBMQ/333W5U2Ncc5OA1EsFT8TgaAPXzSg7MOEfZXDiKVX+d77slUb3mHr8Zq80prizGdLMSxfISMrVCSgCUFou+MDUtF7QiP4eojr02/zeUZk6hope07K+LrUuUbCP8oXpInZgvrQyirDPVbYK3Gp9MbnXFGrIlT4n1X2XO55YlkXqajw5pt62lLWvLtB+IAHyzELuAefkg7fshuNS5sTw7CPxgAONZXTsPuGWNxmhKV/B+n+ey2HAX+dI+ogugRhOIzQo8jiMAkBB7EoLrJqDVrCoy5to7KRQtd55n3Jo6urv4WX0ym0Q0FXniH6BQH8n5X5uIb5a9YXocb4OYWyrr28nAZEtgMEvsk5ivZo4sY2kiCItSRodzN3TTFTLLIjpCWzLReicCNu5oNrcpIgkM953wa3FVzjjdhxe7tejjmIMOPR1xzfv62RxfzlBxuSrM20TcMV+UugRIFXrlZR89k0kT0gME5l4VhWglYO7Lp6KyiLIS5t03rcHOuB/YBH7Vtry9i3jd0IOc2mawuABTAcPmbi8EzDpb/7HNi4L0bkSGHN09DOjIOhPLf/jwUGnjIwl4VjX+baN1MIJOn9y0e0zxs1wuDf38XM480s5gNA5hVppHRFoSyYTB5n9aVeaPmnGa9E8jrHvgMG8I3s1HhvuuRJ3SJ9h3KD0x3KeEn/Odvh/fhpLeUWYK9E5f6OuKzB2kd96QUJXMigmatIE0l7v9
 2vH5JAyr
 GO8AMLUxduJ4XA/ndSZUdDjgZ5J7r4GrP/gOZ1Pkj3vxphHxQwbZwNzWWaKuJi276fqF3BALGg2puLvhxbO9G75FXRqT75TRPvW2oN6zsq1A3eFeE3LNbb3DF0eqwEHr9FtLH/aLnRAgpDGwJUJ6sH2phDzjCNorTLag4ArSSqHSxfLaDqQUzPzugkjqzNNLKiUaYHGZVUpauLsJvjJVOvN/EBHYqcIt+Z0lC1Zr9bNMCDPsfjeBHEEiWG5Yirp/sXjlw+0jMyt3K15Yg1Pw+Y+vf9YW0dsVDSv7g4AB6stuS7lksWW2aw0Gph8lV34DYnU6itJATlzszewQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sebastian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ec8bf8280261294a9b9b4520414b42704c7f9f6b]

url:    https://github.com/intel-lab-lkp/linux/commits/Sebastian-Andrzej-Siewior/vsprintf-Don-t-leak-pointers-for-ps-without-KALLSYMS-enabled/20261015-180648
base:   ec8bf8280261294a9b9b4520414b42704c7f9f6b
patch link:    https://lore.kernel.org/r/20261015-vsprintf_kallsym-v3-1-c175c27f38b7%40linutronix.de
patch subject: [PATCH v3 1/2] vsprintf: Don't leak pointers for %ps without KALLSYMS enabled
config: openrisc-defconfig (https://download.01.org/0day-ci/archive/20261016/202610161107.ckH3ptvE-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261016/202610161107.ckH3ptvE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610161107.ckH3ptvE-lkp@intel.com/

All warnings (new ones prefixed by >>):

   lib/vsprintf.c: In function 'symbol_string':
>> lib/vsprintf.c:988:23: warning: variable 'value' set but not used [-Wunused-but-set-variable=]
     988 |         unsigned long value;
         |                       ^~~~~


vim +/value +988 lib/vsprintf.c

1031bc589228ca3 Dmitry Monakhov 2015-04-13  983  
cf3b429b03e827c Joe Perches     2010-05-24  984  static noinline_for_stack
cf3b429b03e827c Joe Perches     2010-05-24  985  char *symbol_string(char *buf, char *end, void *ptr,
b0d33c2bd77bcf2 Joe Perches     2012-12-12  986  		    struct printf_spec spec, const char *fmt)
0fe1ef24f7bd002 Linus Torvalds  2008-07-06  987  {
b0d33c2bd77bcf2 Joe Perches     2012-12-12 @988  	unsigned long value;
0fe1ef24f7bd002 Linus Torvalds  2008-07-06  989  #ifdef CONFIG_KALLSYMS
0fe1ef24f7bd002 Linus Torvalds  2008-07-06  990  	char sym[KSYM_SYMBOL_LEN];
b0d33c2bd77bcf2 Joe Perches     2012-12-12  991  #endif
b0d33c2bd77bcf2 Joe Perches     2012-12-12  992  
b0d33c2bd77bcf2 Joe Perches     2012-12-12  993  	if (fmt[1] == 'R')
b0d33c2bd77bcf2 Joe Perches     2012-12-12  994  		ptr = __builtin_extract_return_addr(ptr);
b0d33c2bd77bcf2 Joe Perches     2012-12-12  995  	value = (unsigned long)ptr;
b0d33c2bd77bcf2 Joe Perches     2012-12-12  996  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

