Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3417CCFC509
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 22:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B446B0008; Fri, 21 Nov 2025 17:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB856B0029; Fri, 21 Nov 2025 17:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EABC6B002A; Fri, 21 Nov 2025 17:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45BCB6B0008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:17:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4F6289A7E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 22:16:58 +0000 (UTC)
X-FDA: 84136025316.14.C292670
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9678440007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 22:16:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cGOKcdcl;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763763416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZTTs6Mh9QHJWEgknccDFZ8tvGhlrxxXkdvw28mO5CvI=;
	b=PGl5bDjqiqmixeYzLWlfy87wRnBGkqCcGwm0x75+N1qui5NaSVwHiXJ6fE4aymnEZmZ5Ic
	xttFB26vUGdRBR25aLdr2rCMxAhmCjSLn6eH28rNm4w0C27Mxhv5nkl/qi/q+N5yZy3zz0
	su6YEL7vaXgdt6d0v/mWsDSSgleOmSI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cGOKcdcl;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763763416; a=rsa-sha256;
	cv=none;
	b=7+SHdpNorf30gEPLFhNF4tb546YM/RWnCG7n2/rMnAooF9Z6b6wPlWz/oHh8bE7y5NKZ+k
	x9TOKjg1UKY50zcgw36nTEERyMhRm2qYprMMs0F08ddXKIjCK4En8e/yeMG+Tpp9c+t/HK
	5ntG9mTFsGZy/V/9U6e27uH2ONhDZhc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763763416; x=1795299416;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IZWfBJDaHCe7l541lCMHfRRvdDcJ9cS7vOHixV9h5tc=;
  b=cGOKcdcl1fINBPXtRNWJgmOgmvIKEzbEJqHFJ7j1wxJdJ5GKS4Nu8w4l
   cXosAIjUkYQKyQy+kiGPFlAxSXW4qCztbqbYHsPgHuwbn326L3RENMDks
   Q8VLWJSy/kyfqXKNqD9eCHg5LSLWOJPy0W4ezN4U/xOxo+15/Us80d+CP
   WCuxG/s25rX2VyZ894/H+2wiJqk8esaHCghfXOsEPt9viiXaztmQ3TpuI
   MxTCv4ONwnG6W+p/NKfgsB8X2nF2NWtLQi65HnYjZtb3UHDm9SqTuOkv0
   XDf7UmhawXIZn0971iVglxGeqzyAwBGaN8UWjwAscVuOezF/X/xJCxYot
   w==;
X-CSE-ConnectionGUID: 3WoJmWBcS2yqK9o23qa5wg==
X-CSE-MsgGUID: IfVz2sUKSxGj09yIoPyWsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="88515019"
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="88515019"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 14:16:55 -0800
X-CSE-ConnectionGUID: TOehty9pSyCfviE3bYiNSw==
X-CSE-MsgGUID: BIxr2Fa8QbCS5hbxVrvkJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,216,1758610800"; 
   d="scan'208";a="192265938"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 21 Nov 2025 14:16:49 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vMZQs-0006vH-32;
	Fri, 21 Nov 2025 22:16:46 +0000
Date: Sat, 22 Nov 2025 06:16:25 +0800
From: kernel test robot <lkp@intel.com>
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	tglx@linutronix.de, andersson@kernel.org, pmladek@suse.com,
	rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
	mhocko@suse.com
Cc: oe-kbuild-all@lists.linux.dev, tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: Re: [PATCH 12/26] kernel/configs: Register dynamic information into
 meminspect
Message-ID: <202511220511.nMJSuw8H-lkp@intel.com>
References: <20251119154427.1033475-13-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119154427.1033475-13-eugen.hristev@linaro.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9678440007
X-Stat-Signature: wqdghhct5yttq35r4cukzrkundzbtaqo
X-Rspam-User: 
X-HE-Tag: 1763763415-854109
X-HE-Meta: U2FsdGVkX1/M6DoHsOgrPdvB/+GTVbBFNGcBY9u9HijpO2CwcBeVsAwuQIiJwRQQba+iI1MQG9/Yu3VVi1zZUO928k6CsHlLDaiAG1RUOteXgMpu+846v8vQH0FyeBy3zX48r1mil52ODVHz13dYX7JIu6fQtDWIZWFbHDgEcDu6nVubhZ4AB/vJA/PZiLEsh46GLiTwFxKVNWhtgZwNYvZF465j2JgdB2xKOXBFN0a1fv6p8e3CR9X5WhX0S5ZMeKDhRDFnZYYQAs4iJ/0NLldDK9LveQwGtyU6YM9GIaMmdE8OLADKxeOYMd0q2wOK1uFEJyxLH8yuqUH2WDAYug2WMS9n1SvLknGkbNWKckX8ESrswQ4XvRRYwir6EelOpC46Hod0LQ9HvIvgvmNOWoEkLHWSTcidjm5wgqunIqgoZZwzCEqmSj5seG1cati7lubIMrzIDA19xQXUcHSWgKXxKGF5cYbWWF0klcJ/6HB8VK36oT8mvvzLdpmJbimwcBlS6hi44IzDDkQ6NTiQQyq4xBeY18NSGa70V3Y8ZXooNrRJyKlIrkmpVC2uUdI+edkdd9apzHRe2z3920vZf4PP/CczOnB4Ge98Uhas42QF3eXGbk0n7qVlqKXqI8stui7zK+gyXqtEkjMyuYGEA1OT1oZCJaN3Ay6H+G3RHx6f2rfQA+qimqAfPfTpBijpM5bKKimep4dER7z9k2As6o6mzAD3SwrXX1/8IAY59SrGfGtI5yU6jYvP8paRvqpwufS7bu6pZHwbwGO17VwcastdqGR9yOr7kVE8nzrTd2W1Ni6Me5UZEXAHkGbOBcYSdBO/3LAWYS8Dyu6rarMBqYIsKdv/l9xX36YDXZJZAttfEp4X0picSA==
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
patch link:    https://lore.kernel.org/r/20251119154427.1033475-13-eugen.hristev%40linaro.org
patch subject: [PATCH 12/26] kernel/configs: Register dynamic information into meminspect
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20251122/202511220511.nMJSuw8H-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251122/202511220511.nMJSuw8H-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511220511.nMJSuw8H-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from kernel/configs.c:18:
   kernel/configs.c: In function 'ikconfig_init':
>> include/linux/meminspect.h:144:39: error: implicit declaration of function 'virt_to_phys'; did you mean 'virt_to_page'? [-Wimplicit-function-declaration]
     144 |         meminspect_register_id_pa(id, virt_to_phys(va), size, MEMINSPECT_TYPE_REGULAR)
         |                                       ^~~~~~~~~~~~
   include/linux/meminspect.h:170:17: note: in expansion of macro 'meminspect_register_id_va'
     170 |                 meminspect_register_id_va(__VA_ARGS__); \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/configs.c:69:9: note: in expansion of macro 'meminspect_lock_register_id_va'
      69 |         meminspect_lock_register_id_va(MEMINSPECT_ID_CONFIG,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +144 include/linux/meminspect.h

184ddf27f54a0b Eugen Hristev 2025-11-19  139  
184ddf27f54a0b Eugen Hristev 2025-11-19  140  #define meminspect_register_pa(...) \
184ddf27f54a0b Eugen Hristev 2025-11-19  141  	meminspect_register_id_pa(MEMINSPECT_ID_DYNAMIC, __VA_ARGS__, MEMINSPECT_TYPE_REGULAR)
184ddf27f54a0b Eugen Hristev 2025-11-19  142  
184ddf27f54a0b Eugen Hristev 2025-11-19  143  #define meminspect_register_id_va(id, va, size) \
184ddf27f54a0b Eugen Hristev 2025-11-19 @144  	meminspect_register_id_pa(id, virt_to_phys(va), size, MEMINSPECT_TYPE_REGULAR)
184ddf27f54a0b Eugen Hristev 2025-11-19  145  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

