Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C5D5FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 22:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C576B008A; Wed, 29 Apr 2026 18:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17F026B008C; Wed, 29 Apr 2026 18:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9DD76B0092; Wed, 29 Apr 2026 18:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D39556B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:40:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CBF3120438
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:40:11 +0000 (UTC)
X-FDA: 84713063022.08.C853F21
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id 46542160012
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:40:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bUj8gcfj;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777502409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYihVQxFn4Q15m34pJ5D2Cxeq3ogwFt6cRqdCY/o5j0=;
	b=HjSme5yGpFuqeG5sjb+5F76td8/yVyr3Qw3HkQi3iJt+59LcX6XPp/A3PYmJyfd9ebCCno
	yG3+fpjh5oQDSj2uQtsv3WiyjKd77WmeaG3V1jMZcKyU8BKrcD2htXY6OlVlIdQB1xALQg
	N3ct+M1/AjM3sRCkQDWcIxnQYQGW81k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bUj8gcfj;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777502409; a=rsa-sha256;
	cv=none;
	b=fIkecO2226avZ2tUiTcNqharjekB9bnJQJlBvnlf0sU7+LBMPtJPgxN/PKNWF9OZP+bqVy
	KT7iotL1MW7Yw473G3d2ExiZnlZWU6Dew6Y9UX0YeG+ZoRbbwdWx+8Pa229MoyQTRvHdru
	6xO/eF4kHf0/CCDgFMcSEwJ/LPtKGSQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777502409; x=1809038409;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3BI/lWhI9SxVb1m3Bl2sciMIf9SP9rj77wH4xuxgpwI=;
  b=bUj8gcfjIkJJuKytWHRhAmUUdbT5XyKt3OhKMo6uOh5+mirR97I0q9ic
   IMrsRC9jEL/BIP1Kj2Dba+eY+ts9kfSAKim4stnBeyN1TEBo4JZdqiVzd
   3YZ569XHMIh9sqQGASM2nZ4w6bdoeDtJTQ9KPc+AjKjHFaj3HnG/43OFE
   8Numz1vN24oAPrc+Nv7TECg7I/fTMeTpCRXGoeDKfWqmGsqhtRd2ac9rj
   m4ODo6Yw4HWdw/TWZxfiDlcamaYFtsUn0Ac0isVA+PQ+LAYHe7f/3jTmm
   j+89V4/Nv8yd615p2PFCOUTvpFcu5e2coch/hDL6JniJCcIu0CQEF95Y0
   w==;
X-CSE-ConnectionGUID: Gm4EhDcxTpunPubouVL1Fw==
X-CSE-MsgGUID: lM2kDvKKTWmm7wx9RdURCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="82300137"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="82300137"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 15:40:08 -0700
X-CSE-ConnectionGUID: cKRv9UeZRVqfpGgESPXCPQ==
X-CSE-MsgGUID: BB03DqG1SqW9U5MiCPmFgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="238731195"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 29 Apr 2026 15:40:04 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIDZY-00000000BbO-3PIY;
	Wed, 29 Apr 2026 22:40:00 +0000
Date: Thu, 30 Apr 2026 06:39:35 +0800
From: kernel test robot <lkp@intel.com>
To: Guangshuo Li <lgs201920130244@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stas Sergeev <stsp@aknet.ru>, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/rtc: fix failed fallback RTC device registration
 handling
Message-ID: <202604300652.WxTbaLDu-lkp@intel.com>
References: <20260415193455.3869807-1-lgs201920130244@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415193455.3869807-1-lgs201920130244@gmail.com>
X-Stat-Signature: u1z47jgd5ackpnqm8wc918xh8wi5c9x1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 46542160012
X-Rspam-User: 
X-HE-Tag: 1777502409-291408
X-HE-Meta: U2FsdGVkX18RXGq/ni1P1m++Qnz7QvHNHrnizBtM/MxhNEZoBXXvpY+UTgPFab7j2VY/VAhRZZgX3kf3Lb+VQHw7t3q7t/wVGIOfDBR+fSSsJoKuS+UxRV5Dg7v7kathr5liaC9tf/xcVhsyIbB68uwSfkEpAlUwKOH4uqUP1rl6ICSmIaqEUexwet84riCGTY8H6UIgrvpphBSiH07OcJMg38s5+VOn+316j4WoM2nzfCZ4ojFdVkOjd4DkClHGQbPhFslVgRMiwx7Krffy9X2OXYLj7zCosRZUJm66a721EgSURlPNpavoeR0lwvbxbw79/lM9018oD5A5dqHMgmzd0YBpdD5b6zeiJi7GHK6LAcwLXsac+tbVt/O0kvEPEX4hkOx9afN+c5vDnewBJNzW0bbKUPR5yEifPfAlym924wLnNam4k78OC4NqykvDXyB7wCXM5zFmhLVOrG7agJO2Fl+QLmgSbLCGVVS64Z+PFnjJ7kBP5MlihD6dU0DarRu9b9x1/ZPxg0OI/U3uejrIwHzKpub/F3OhcCcpz6qZKgIkDICNU/CDGulWRpmyGKh7Z461Lc1KZOyLrStyI8Le3IBKhC1eLEIM3jBAfDOoK7/y/CiQfvNFiZN2uZilTe404HLYm2UQQ1u3+aeZV2d4e3BYff/4tFiRvmoS39S1Qmz/fF5nW8rEOUY/OvxrURtWytR41Zny0Xfm/eYLbrytghQ9Rt6vW3LI4WWQYbwmiUcMkGklTsW/nyz924FoFMxiFmiv/4o+S37f7qmprpr3MOohUIpgGAHDDZUH/TbqAil7Csk0kqfq8LhmjfkClFkhrOx/uM+OUFuQ7AQFFJNb8dVvLEfgTfIY4QIZO/XEYbpvRk4w2KZ3BR50wRyRWbvy32ZoUlGYPmWSnKyKzysFeEtbdmUfIk7h4eIk2HQVf+jnYvJolEJx1vQ7SLcqbXdwsa0GIdg9vpspSXh
 gVce7iYr
 sNJ0GzO7WEuuAHegc7MX+A8DE53n+W7+OZVTaQ12wXfU2o8UrQqgeeVmSzXDYvpTDuZEsGyDb224K9cTzYpYJ+ALuT6nEqzb+LDH9IH3Wyh2bDbQHoUL9iwsB3zn6FBFFRa75ttYw485mcQl1YBwKVgyySnYcqh5iJB/Wrft2U8i7u4jqCHOSmP+s8T4MoQS/UU84bg3QoZAfru/9rpEWEcVt3kvn95s1jbx8hxHbfaBam7pLngcZAGPd/WIjlouoruCa0N+yO9n4mpKxRcHcl8RKr6IrTFKLXe/Reg8VP5gYK3CXyKWXHGwFpViq+vSFg271jyev0YzfllFb0BGwPC6BDs7i5hd4VvADglyBhGAhBWSPwRf1En1EIpMv/zhYtzKG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Guangshuo,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/master]
[also build test ERROR on linus/master v7.1-rc1 next-20260429]
[cannot apply to tip/auto-latest tip/x86/core bp/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Guangshuo-Li/x86-rtc-fix-failed-fallback-RTC-device-registration-handling/20260416-130623
base:   tip/master
patch link:    https://lore.kernel.org/r/20260415193455.3869807-1-lgs201920130244%40gmail.com
patch subject: [PATCH] x86/rtc: fix failed fallback RTC device registration handling
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260430/202604300652.WxTbaLDu-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604300652.WxTbaLDu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604300652.WxTbaLDu-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/kernel/rtc.c:142:2: error: use of undeclared identifier 'ret'
     142 |         ret = platform_device_register(&rtc_device);
         |         ^
   arch/x86/kernel/rtc.c:143:6: error: use of undeclared identifier 'ret'
     143 |         if (ret) {
         |             ^
   arch/x86/kernel/rtc.c:145:10: error: use of undeclared identifier 'ret'
     145 |                 return ret;
         |                        ^
   3 errors generated.


vim +/ret +142 arch/x86/kernel/rtc.c

   133	
   134	static __init int add_rtc_cmos(void)
   135	{
   136		if (cmos_rtc_platform_device_present)
   137			return 0;
   138	
   139		if (!x86_platform.legacy.rtc)
   140			return -ENODEV;
   141	
 > 142		ret = platform_device_register(&rtc_device);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

