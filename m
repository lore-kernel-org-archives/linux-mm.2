Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EEB1D1268B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 01:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6433A6B000E; Tue,  2 Dec 2025 20:06:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61AB46B0010; Tue,  2 Dec 2025 20:06:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 530C86B0011; Tue,  2 Dec 2025 20:06:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41A406B000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:06:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A917B884E8
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:06:03 +0000 (UTC)
X-FDA: 84176368206.30.432A0B6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf03.hostedemail.com (Postfix) with ESMTP id 19FC820014
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:06:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=l8W8Yoow;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764723961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NrJKVXlfCl5lzRpYaUDoWQXgM22mAK8dxwpXLItrGvk=;
	b=zt72abaeIwFs4ckuahLiIQU0S4OFPmaKEysi7x8zfRO2uoZUpyyT6swmG9SnIvKqR9Wf2+
	gQjK+tVFwSi6Id6SKfIyDbQd2s+0MRsiVKRk8yooiRmHTOEPcNYMBDsuBOBLgZT1iaUbpb
	/slPKq6OXKb8QxT+VnBqUZH8oz+sAUs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764723961; a=rsa-sha256;
	cv=none;
	b=dhH9Ome4kXUS0OwLkTWsAn/doqriNmhcSP9nm5OAws0vH4mX7+hIFI0v5ob9W3JqwvcIko
	cR9vnj8yzE3YF4dGzh/IY2pD59r2nTa2UtEYGZNlDF0OlCf1BBVLCNaj5ZE1zicNbbY3tX
	Sfp5LO8i9HrPl7ho86uhjruDD6mZREk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=l8W8Yoow;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764723961; x=1796259961;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Q7FgzPiTQVCOcOXhyBadv3BfwwB0RDeQjqgHUDVrIKM=;
  b=l8W8YoowkTNyjyuJy6naOQABqeRNuowp9eksE9IEaOndZfeQH/giZy5r
   iVLDkFI/hynId8ID3+HtaMd+Tc/+TxESjoS469aT1wCIdUDMqo3FydCuD
   tvu/Gu60YQiHiJUv+hoVcYF5sDa32ahjbqx+lTrbR6CrQxTacODuISuqp
   QSs7bl/XIdkJ2sGlYOC9MUoyEcL2b+0MNPJlhnpw1v767VC7RTNq6XwjZ
   Y0BhhPDix8N5kX851p12B8jEXlHEzcqvX/285OBdBKb8Tms6Qjj/VBJvt
   jIZAD7ILoLp4Imcxf5ncNWxCdaUMyMW+bPhfE76MaZNQXvIDKsGPiB9nK
   w==;
X-CSE-ConnectionGUID: kJqWiOi7SuylXcw21Ot/Kw==
X-CSE-MsgGUID: FOl9nxtvQYelITQY9pCLqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66874818"
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="66874818"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 17:06:00 -0800
X-CSE-ConnectionGUID: ikaxBdF/Qz6F9KNkEFjHtg==
X-CSE-MsgGUID: ZTMQpqADR++TPqbwIDXyJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="195320631"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 02 Dec 2025 17:05:58 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vQbJb-00000000ALf-3rV0;
	Wed, 03 Dec 2025 01:05:55 +0000
Date: Wed, 3 Dec 2025 09:05:30 +0800
From: kernel test robot <lkp@intel.com>
To: Feng Tang <feng.tang@linux.alibaba.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Petr Mladek <pmladek@suse.com>
Subject: [linux-next:master 9966/13055] kernel/watchdog.c:74:22: warning:
 unused variable 'hardlockup_si_mask'
Message-ID: <202512030920.NFKtekA7-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19FC820014
X-Stat-Signature: jmkmdaenq3eax5hzrq3tbrfukj5nqs18
X-Rspam-User: 
X-HE-Tag: 1764723960-764635
X-HE-Meta: U2FsdGVkX1+h1o9f00qc1I3Fodpe8iKm7wVxgAedGPtx/FHkb8ObETwdEp6bZ8zDrKrIN77vz0Tdg4UIb+EN1dI2WBxmPzGxALpop4f7JWtk2BEY/gUBVcdSzd1U/pO6XwN/niuLq27zvjKCu1HZvbv58KjcnLDQbDs/pq1rWx7jPoY28nnvTgfJ3lfyqsGUFfEzAlOeu1z9Q/5qWZ+CTRe1TDinOVllNJ9iGo3IPKYJiAM3S2qIyjkM20nG7XuQrgsPa24/6ekAcaPLKh0G2T2hXrUrPle8f06si8QlC+NK/FCOwsCoYDcRfRq2uJjM337baeHE+GGCNDNHl5x0jBIxNZC48rPcogaqYTTz1vGsooV1VoWyznieVyETD985W/6u2af6cF7gaVN1vDXzIGg+cWGuaClB407WSzuzXB1Uya92Qcdv9+8w4HT7z/YCA8AKACX/v9VSpY1Jjms3xZI+Gvm5HslWXsL/SoRhW7trC9o8C2IM6amnqCW/GY80Owf2HRFG7GPgKVn4AaGeMq/Ku6JWwcmA7B43X9i1oWVpmKVbYcNU+zGefMjSGdRvV8kgdG6zy09lC5rIeekrLcDS4hA2Vadw3QIeZ/rjAUxtpX6/HNkeA8owWBtIWWu2Q+WBjHhtumwoiv4FPLZ/rW+Zdhfb08azznx5f/gdIzhGOI98C5Ad4KipZq95kMt/8Aij2z7xTtz7GYNwVh0Nr2cFcHh5sjejXNkPZknztc6w0V18vxgXQ5/po7zjB9cub5TkeikOhHlbJkVnYkyOXShn4aUn9paE/KeVN8D24B+gx3bdMMe/v7onYC/Ee7cosPFYI11jcOxly92LxBVCv15N9A4KzjOGFNCu4qAuqooeU4ov7r1K+B1gfGXiu9dqbueg/w7uKPtj42RtcbZSmFZWd8XuwGJtDJZ4VfyfFRdY06HFvHU7jYu9x8puVOcmrEgfeAifWmnK9munG13
 6lgPZ1GG
 kPKnPNeTgNgzBShIg3ksFht67c9WifjHzgwFQPGA+iXBE5I4sdEN57aqzA5hOjZ3j2VKAYT+LDmGxamiWCvbWp/HlrLrbkLIR5Hh52t0tGdWtMZHMV+DcBKDzSPeN7DwLgFtY8CGMiCeE40lvfg0O/Zn8nbCMcQiX5acThlFi2WwVBDxJHhpNXBWmLNFydDPaab7V29UYCRFUCT0GpD1b52mw0gtqx7Ft+mQgHBptSSmWr+iUHLE3PNCyTLSFYN0cpl/RKVld8k0XYPiqb8CEXupt+k5oJ79lgCerw9+fRAOUAcoHtjmgCTvnKc9DlzO3Vqx3FYByZ1QYVWpdsSEhTWsZPWx952G0Fe8TZkzab+rR8aVzpQ64Boj0Bg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   47b7b5e32bb7264b51b89186043e1ada4090b558
commit: a9af76a78760717361cccc884dc649e30db61c8b [9966/13055] watchdog: add sys_info sysctls to dump sys info on system lockup
config: powerpc64-randconfig-002-20251203 (https://download.01.org/0day-ci/archive/20251203/202512030920.NFKtekA7-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 734a912d0f025559fcf76bde9aaaeb0383c1625a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251203/202512030920.NFKtekA7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512030920.NFKtekA7-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/watchdog.c:74:22: warning: unused variable 'hardlockup_si_mask' [-Wunused-variable]
      74 | static unsigned long hardlockup_si_mask;
         |                      ^~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +/hardlockup_si_mask +74 kernel/watchdog.c

    62	
    63	/*
    64	 * Should we panic when a soft-lockup or hard-lockup occurs:
    65	 */
    66	unsigned int __read_mostly hardlockup_panic =
    67				IS_ENABLED(CONFIG_BOOTPARAM_HARDLOCKUP_PANIC);
    68	
    69	/*
    70	 * bitmasks to control what kinds of system info to be printed when
    71	 * hard lockup is detected, it could be task, memory, lock etc.
    72	 * Refer include/linux/sys_info.h for detailed bit definition.
    73	 */
  > 74	static unsigned long hardlockup_si_mask;
    75	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

