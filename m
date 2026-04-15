Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D2EF9D0CE
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 03:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35A56B0092; Tue, 14 Apr 2026 23:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D466B0093; Tue, 14 Apr 2026 23:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22796B0095; Tue, 14 Apr 2026 23:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0EE36B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:18:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 664F913A799
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:18:33 +0000 (UTC)
X-FDA: 84659332506.23.6ECC601
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf02.hostedemail.com (Postfix) with ESMTP id A69CC80008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:18:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AmsbWIcL;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776223111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tZtfPotxl8kfqhlcellANwp2kwmi1pimXdRirEPd8U=;
	b=aOd5IXLnTQCNcDrOvk+m09bm8UOWW68c2eY56hx6Ue792pwf+FC92S+c4kGJXkOZQAoveb
	+l5vHhT4F8OYO50R5GTBVR5g5ovTO5VV8LF+MQnynCD3e43X6Ckttfz+3eznPji7Tl9kDn
	eE71Yf+WJPWUR8OaBP8JAQDqZF6EWYk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AmsbWIcL;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776223111; a=rsa-sha256;
	cv=none;
	b=MI8a5Pdx0AOfRp+00qzRE+o03jD4kJOmBonW/od9zv7pnEIXu9CBEJzp0W07ZhRcccSXRW
	/p0pCxIbtjZpvFYiCkmUo3RCfYA8GXX9IUBZPR23jxcPFr6Sk9oeB/0zJEG1ll+URkD++O
	dpMnV+XZEx5p4FRXyN1FH/HxARVVTps=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776223111; x=1807759111;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pN4vBEp6nfcqXNrQLkmLldYUzKj2XXj7ZHPiuukhJLg=;
  b=AmsbWIcLz5riUkLdscBozmShIzp5v/qmzfMGl1XEDOw0MALX13jvQsYP
   KebVYl9uJVNBFAIOP2OxqUFiKMo/kmz344TSWkm5ENnb+oGEPOWozqdKV
   VZ1LZ8rtAlqXGlkbEerwtfVhkPKw4SpK/i32QgumvGcRt07lCf2uDxcEH
   ihqq8IMSPQ81E+fo2I4qYjNz8p2wiwfaRYiy03jhxZU4p8j8ZCsjiqEfS
   DvS+lYcu1OgTucS4az8YN1scvrpLl8Z1QRFeroKl8Pk+Hsf/2Z9oiUiQ7
   8wgC4c0qXCk99J/iorqscCuEKH1dHCQqoVbLZSLYsVZXVec88wx+Z9Kt7
   g==;
X-CSE-ConnectionGUID: 4vtcSXx3QDaLijFwAVsiRQ==
X-CSE-MsgGUID: kUIcatmLQnyCUKdGIGpfjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11759"; a="76224287"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="76224287"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2026 20:18:29 -0700
X-CSE-ConnectionGUID: hRHIx42nTce3zJplxlFpbg==
X-CSE-MsgGUID: 36SwFOnOTKqLOuqoFusQfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="223780958"
Received: from lkp-server01.sh.intel.com (HELO 7f3b36e5d6a5) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 14 Apr 2026 20:18:26 -0700
Received: from kbuild by 7f3b36e5d6a5 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wCqlj-0000000005h-0rLu;
	Wed, 15 Apr 2026 03:18:23 +0000
Date: Wed, 15 Apr 2026 11:17:53 +0800
From: kernel test robot <lkp@intel.com>
To: Youling Tang <youling.tang@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] crash: Support high memory reservation for range syntax
Message-ID: <202604151100.7wbci6vo-lkp@intel.com>
References: <20260404074103.506793-1-youling.tang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404074103.506793-1-youling.tang@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: A69CC80008
X-Stat-Signature: nssyji7uy8tmsjwxph1irgrahm77cjd1
X-Rspamd-Server: rspam06
X-HE-Tag: 1776223110-396165
X-HE-Meta: U2FsdGVkX19pmsFySPKmuD14yt+xLJFCFyv2os+V0XVJ+/SpqpW4t2rx21lg/rQ9GIu9PH/ogXHHuX+EL6t+9Qtt+T+BffPhIeWnmjQeTGy0ek7oOe2fR1urm5JdRE628rtDHjO/Ic+VoOjK9mlJOZkOj5OP1R7KhxE47VRXX2E24s8kmCzLchtejyjmnADDgeTQi0b+NMY1DFsNuaa2y+6qjeSRzc+hkfJCkNpDhDhAE0oJ2xf1w/o9roHv6XP31rNmHZcfCH9LOYKkRXYuu3+BIkoUOxJaKFdsjSdXf6mwEOjiGjFWE07BXKZNpH5fZ4Ww01RE0f+JzDBML7/b5DIQxXmRaSwGh6AZiVQCloh/wHOkNFurOHnYK+D93HnOpuHXazzWq7kvPCNkPgx4/3CwKaZRu0qmJwrFIi+fHy4Aj1+UuHbRR5CknSAJPlUJDPHYaXL2aaadSLygakcn/rpXPGMSiAa8yMlkxk9gczgcvDLljwLN8hQ9uGTm+LmTlrUiRuZnwtIHlU7IMqvk6joh+rO9xw+/zLPIty7CgvZZg5L/T8/m9W7m02GCRq9P1xLxIC+wI65GYnzsffYqVqohOtip7J18Gt6BNjYvRwbA2G5Htb1GrJ85wRlDTUcLtxE3vAe4sjr8SA5G9Xv3oPwHMekkots3LWvfL8vw4tlo+DRoYOhByzfbCUJl5dyuFNFuOPECqiDxtCmK6f3zEK8vc24PnFq99C5tCoT/J3SAuUq6JbhvLxNwfFn7zrdzaQklPdwzbBsDvChkd4r7dCLmNauYP7S7jod94JcVmNxoF056ErZBkKu1H8OKUwtXvQUUK+v09OiYSilSO4O5Ed4jC6912AijC3OZ50xp29HWcoIknsP171lvUWkyWwhzidyMUabpPiumR3Eq/J3TBBBR47unxG/04ShFhk6nj9lCvyCjdV7naOF3m/6cD0sxJZ8zC+JUtvO3DSWy8qs
 z5NYLgXl
 teQHK+LmLMNCTgknMc1leKrUp5/8W9Mmlyj8bID7qyUkplNEPQAK59i3fVRQUEHULL0+XPuUf7OaWDSwVqyr0UD0WnhPjDgPNikPPIgoq9u9P6CecQ1Li/SuGHVtPNH8omhSkHPIqZYyMrF34wUBOeLfDWEJiyw+9Sjbew4aFjhh4EooH3dhSUHnqSHS6tUZfTBH2SsFyX3wAl9/EheBlnEI/hWi1vX8xZ9nxuHfBd1wm5aHUdIN8VTlmxAL7W7jvDK4WlJeJpJxztJhpvGsUl8numwDSZ11wuFVxdnLrZyYWQpPfxikzIgu4d4MWIx199voEXN8J1jzK+GwCzHpGh6mEOtx7Ycp5vA0H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youling,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v7.0 next-20260414]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Youling-Tang/crash-Support-high-memory-reservation-for-range-syntax/20260414-205035
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260404074103.506793-1-youling.tang%40linux.dev
patch subject: [PATCH] crash: Support high memory reservation for range syntax
config: mips-randconfig-r061-20260415 (https://download.01.org/0day-ci/archive/20260415/202604151100.7wbci6vo-lkp@intel.com/config)
compiler: mips64-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260415/202604151100.7wbci6vo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604151100.7wbci6vo-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/crash_reserve.c: In function '__parse_crashkernel':
>> kernel/crash_reserve.c:324:37: error: 'DEFAULT_CRASH_KERNEL_LOW_SIZE' undeclared (first use in this function)
     324 |                         *low_size = DEFAULT_CRASH_KERNEL_LOW_SIZE;
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/crash_reserve.c:324:37: note: each undeclared identifier is reported only once for each function it appears in


vim +/DEFAULT_CRASH_KERNEL_LOW_SIZE +324 kernel/crash_reserve.c

   282	
   283	static int __init __parse_crashkernel(char *cmdline,
   284				     unsigned long long system_ram,
   285				     unsigned long long *crash_size,
   286				     unsigned long long *crash_base,
   287				     const char *suffix,
   288				     bool *high,
   289				     unsigned long long *low_size)
   290	{
   291		char *first_colon, *first_space;
   292		char *ck_cmdline;
   293		char *name = "crashkernel=";
   294		unsigned long long boundary = 0;
   295		int ret;
   296	
   297		BUG_ON(!crash_size || !crash_base);
   298		*crash_size = 0;
   299		*crash_base = 0;
   300	
   301		ck_cmdline = get_last_crashkernel(cmdline, name, suffix);
   302		if (!ck_cmdline)
   303			return -ENOENT;
   304	
   305		ck_cmdline += strlen(name);
   306	
   307		if (suffix)
   308			return parse_crashkernel_suffix(ck_cmdline, crash_size,
   309					suffix);
   310		/*
   311		 * if the commandline contains a ':', then that's the extended
   312		 * syntax -- if not, it must be the classic syntax
   313		 */
   314		first_colon = strchr(ck_cmdline, ':');
   315		first_space = strchr(ck_cmdline, ' ');
   316		if (first_colon && (!first_space || first_colon < first_space)) {
   317			ret = parse_crashkernel_mem(ck_cmdline, system_ram,
   318					crash_size, crash_base);
   319	
   320			/* Handle optional ',>boundary' condition for range ':' syntax only. */
   321			parse_crashkernel_boundary(ck_cmdline, &boundary);
   322			if (!ret && *crash_size > boundary) {
   323				*high = true;
 > 324				*low_size = DEFAULT_CRASH_KERNEL_LOW_SIZE;
   325			}
   326	
   327			return ret;
   328		}
   329	
   330		return parse_crashkernel_simple(ck_cmdline, crash_size, crash_base);
   331	}
   332	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

