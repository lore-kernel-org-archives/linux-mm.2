Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC73F9D0FB
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 00:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1F26B0092; Tue, 14 Apr 2026 20:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372426B0093; Tue, 14 Apr 2026 20:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2612B6B0095; Tue, 14 Apr 2026 20:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F39E6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:28:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9EEEF1B51DD
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:28:31 +0000 (UTC)
X-FDA: 84658904022.16.453DFC2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id EE519A0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:28:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BYXY1q5N;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776212909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEDguHnuRGv9AHdE8EEWVJP9Dcq2OUA6BfBG51qwd5U=;
	b=jIC9jKA7j34cTxUZJF15eAakXB9l/UxusUX/Vjjur+5pzMiK5Usj99D5UrRJWD4ojcEc5e
	0vNtcKlDg1PLbd+91Lqm6yJWMGHLXRlJ9TXYS59p4qwBPynxKFjw9DQpDDsMq6ijwtd25u
	xfbxd5+VfAltG3WKEr8gH+XwcENZZLI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776212909; a=rsa-sha256;
	cv=none;
	b=IC5oLPvMG+GBuife52EU3HP4k6EWKVfWODub7Ioaqu8OuN0jyz71bXDTWyIZ5fr5iRJJj0
	nYS6aj+JZ2pzZOKG9KH0u+jRgOBdPk6GaL7DFWMbCyRoINM0/DEdxqdBWZ7UyrYE5HjSDR
	muGD4t1+wnbbsg0eAg7vmJhuyfawmiI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BYXY1q5N;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776212909; x=1807748909;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6qHIjl1O8jAt7kVac/CbZAb3DjdrN8WLJAUZQIMMWFY=;
  b=BYXY1q5NJ5IQSFWtQ1NlOHTpP2SHVHmNVgELP7W/WNy79rgBNwqas12b
   OPZYY+d8QRykQzbsLCGljrRuptklqPw6ePQ6XeCe4F9b8mFfLfPWkn0pn
   t+kKpj7yyT4DQlcYWuGo5F+IOxbFYcH56zvd76hiaucZjhbyGieD1307E
   fCa7GWij9IHMvmXwrXZa88Lo5Mfl8mq9ztbRUddqAsC53ChXisQdTzlOW
   D3tMb54WjWX3ONxtfHVEOl8tk8ydc4CT9ZVXjHDH3KM3oTe+RutVsoAue
   OuYbdsFL0CJ3qbxi8BZxxi1DGcdKEJFxkOmaWUcsAgS8G8qvJaXrhAJel
   g==;
X-CSE-ConnectionGUID: ACB4zWstQy6idPXTI7t5mg==
X-CSE-MsgGUID: NEjgPqtGSnaX2yu4vofNHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11759"; a="80779746"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="80779746"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2026 17:28:27 -0700
X-CSE-ConnectionGUID: pv1YhFHyTPi2jlKw00PuVA==
X-CSE-MsgGUID: vp30E1BLR7KBAu3RJOAVWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="230103404"
Received: from lkp-server01.sh.intel.com (HELO 7b0b59b3a0d4) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 14 Apr 2026 17:28:25 -0700
Received: from kbuild by 7b0b59b3a0d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wCo7A-00000000217-0hXH;
	Wed, 15 Apr 2026 00:28:20 +0000
Date: Wed, 15 Apr 2026 08:28:15 +0800
From: kernel test robot <lkp@intel.com>
To: Youling Tang <youling.tang@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] crash: Support high memory reservation for range syntax
Message-ID: <202604150808.7HxFp5b4-lkp@intel.com>
References: <20260404074103.506793-1-youling.tang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404074103.506793-1-youling.tang@linux.dev>
X-Rspamd-Queue-Id: EE519A0005
X-Stat-Signature: guyuawg76do4btyw56nkzmpg3nhomfc7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776212908-797441
X-HE-Meta: U2FsdGVkX19XCp64u2l6MGpsy8hFLPnt3J+9K64ycjG0JSaj2vHpfDGRVi7PpKVakfdUycFkFo88ssigzGs9OukyBm7PRFoaaD50TWlMn/TvJeNvDiU4gweJQeuXiq4o0FnjaKckiY05fLoYeUptLSHp1oZx19ygdPYtfyOVE+rlY7F3x+3hcCSnKzeUx1dMx8LxnThIdGORZ+DJHs8iKE2xJoq10no+A3+yEwnBzkM9HWPHAQSC/wzGF5EECpr28LQ57gQjgvZ5YFdFLw+PE9Sfd0OCAADOgiHNQJJAqoToTq9On/04PD2dnBLnwxkOZ6PRiyvjygeUl72U/mj6GIQDQmvj002a17I5dvZvflJ8gHddp9g+0fpV4147gUFj11XSAFUHCIkQb2G6Mq9eCPvhbOdDOaiSt8kbkG7n4cx0K9O7uM4Zftv56e3MYOIHuh7KgAXidFP8N0VALsCGippFvir8dx3CGcQzX5zhD3rkmGrXZZqOFs5dLBebx+1DUOJPI0PaCBUFUbgj1M/6p5sAi06pTowmIb9sNrks5I98KX7WwJ6FnqrwOe0YxMSWPT4+6Rf0bbpy8x2dgQhxnkhkWVYGgYYHMu+sLJtaugpqlVR+F8vbyyUxEwrPiID6laMsdyYGbB+hfp5JxbYZZCG5P0pjPrQPOn28ipF7KXnpce5YuIdgjKG/RrYCS8IcXOSwzvRB37fmoHxiuXMVKnEKx9m6g30BXG6iPacEadMywLCEjfeRldJPluGgfxstfEkWC2ACPthV4dyEOhnkwFymhQlTNWA01+G+TGQpT4diJaAlprzPYB4Bgm1qGhxqiHin+y08Mz0kML2mvy4Rgb8GrfXN3S5R4D/Bc9Mqa/sNqRar53h6+LRjwQe7Kz8BeiWa0MYzrgj3Oyq3EMM1lewCQu8LMG/gNobbz0aOFsK+CkIsyhAdzrhogdJMkjXh28r9isRCCqpGuqdDgLV
 X/VJU9mu
 Ph/utp9GzWr4ZC7fKwyYXjVhAURYoQ49Ec4k9kXOZEHRoaVpT8EL64aIhGiAz2tB2ugpV09CPCiIO8WlZyaG0SxaLfF//vvm3BXdQlALJptmBM/ZKP/n+Pmeufo89Nl4tDX5RbhEFU4L59t19+A6Rtt1rKd1J/bS36NurCkx0Q1ATHX2HxFV6rHB9OcXRD7m+FVPV4dBbyQMybcPwmzc8QMclROAsHwhN6GRtzSqmf8uP/q70tib9TlRqb/S17JHAc8IEwR6G6/d/6jug3SptVlQ2Fx4gw8IQQUyfqg2iza2vHDNdx8JFUEyOGgByNBEM4GhiSxknrZuwiBUVaUCfkFU3MZj3Czx46G+t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youling,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v7.0 next-20260414]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Youling-Tang/crash-Support-high-memory-reservation-for-range-syntax/20260414-205035
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260404074103.506793-1-youling.tang%40linux.dev
patch subject: [PATCH] crash: Support high memory reservation for range syntax
config: loongarch-randconfig-001-20260415 (https://download.01.org/0day-ci/archive/20260415/202604150808.7HxFp5b4-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260415/202604150808.7HxFp5b4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604150808.7HxFp5b4-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/crash_reserve.c:264:19: warning: expression which evaluates to zero treated as a null pointer constant of type 'char *' [-Wnon-literal-null-conversion]
     264 |         char *first_gt = false;
         |                          ^~~~~
   1 warning generated.


vim +264 kernel/crash_reserve.c

   254	
   255	/*
   256	 * This function parses command lines in the format
   257	 *
   258	 *   crashkernel=ramsize-range:size[,...][@offset],>boundary
   259	 */
   260	static void __init parse_crashkernel_boundary(char *ck_cmdline,
   261						unsigned long long *boundary)
   262	{
   263		char *cur = ck_cmdline, *next;
 > 264		char *first_gt = false;
   265	
   266		first_gt = strchr(cur, '>');
   267		if (!first_gt)
   268			return;
   269	
   270		cur = first_gt + 1;
   271		if (*cur == '\0' || *cur == ' ' || *cur == ',') {
   272			pr_warn("crashkernel: '>' specified without boundary size, ignoring\n");
   273			return;
   274		}
   275	
   276		*boundary = memparse(cur, &next);
   277		if (cur == next) {
   278			pr_warn("crashkernel: invalid boundary size after '>'\n");
   279			return;
   280		}
   281	}
   282	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

