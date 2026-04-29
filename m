Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FEE8FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 22:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5366B0088; Wed, 29 Apr 2026 18:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C551E6B0092; Wed, 29 Apr 2026 18:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44D76B0093; Wed, 29 Apr 2026 18:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A02436B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:41:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 463FB1A0163
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:41:13 +0000 (UTC)
X-FDA: 84713065626.21.DC02D2C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf01.hostedemail.com (Postfix) with ESMTP id 10BAE4000A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:41:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GbbWo0zZ;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777502471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypHerxQqNasxBtXZBrCbGcW4GkflBG4wCAh4RWlS6WA=;
	b=YM4UTdAOBomRTkjmtYJgncHD8O8v9uSj9Qr8D3Z8C/C6bLmIkm79Ju2szhmJVkOUIZCtQA
	mVPVkmOpLT5yNJS9YK3cPlcO1PE93sJaH+Ge9w9wiMljgm1O1rSwBFflS/PpSH0+IvbTdd
	8HDVhW9g15HAC0HjqcfHzhh2ymqWMEk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GbbWo0zZ;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777502471; a=rsa-sha256;
	cv=none;
	b=hDmz8BCnDB/KhyxmWp1thnccXo+vAT0PWFsNdEBhaVqj7Jy6y+PDd50xNnAyQ130+gEDxJ
	z7jxqiXeB1NYL08pAk6qG+q+EEigf5I4djBxcziwc4c8iTqaDEiPC2SuHs4WZkrEIXjwwG
	vzB9nDUKq6OLMtYXQx6WkxhbNsueiLI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777502471; x=1809038471;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Prs6WtnNQmxMJPLEGqnYoBUwbZxxTKXGSO/uuDGHo4k=;
  b=GbbWo0zZ4X9ncIV8OQHsoMf6twUSsGMRErDHIGryI1NYkS4Rq6jJB434
   TS1+kWmKaI6scXy9tOdxRqHU1e0cLTAHW/cA4cBUpFwgB1617uWGF7gKR
   9UWr55bPnunITXHoVvOMHe9ye4ytCKXWIfz5h56gyxoNJzl2jw0AXZUX9
   +Ptd1H6uJ5KKv5axcdyZ1VcIKrLLpJ73HOiW5+y5MoWpGM8wIz7R2eWys
   Tu+LvpcInJKyNhEEHygkjHBpHbQXp4ne9PdvfCu40COVEEEuFw8MjojR0
   6k6wxA5YsNc9ntc3aHNU5dOx3PiKLqm8LTtkR8cBpYA5x8ugIcFKXjNUI
   A==;
X-CSE-ConnectionGUID: XFozgxSZR5uqlqCoPLb00A==
X-CSE-MsgGUID: RHgLEdl8Rnyp72FDEYVpFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89818796"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="89818796"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 15:41:09 -0700
X-CSE-ConnectionGUID: 0GI/G0AOTSGrk3HfWQUQBQ==
X-CSE-MsgGUID: N6JkXaW7RJ+Ys3viU5xhYA==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 29 Apr 2026 15:41:06 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIDaX-00000000Bbi-05kg;
	Wed, 29 Apr 2026 22:41:01 +0000
Date: Thu, 30 Apr 2026 06:40:41 +0800
From: kernel test robot <lkp@intel.com>
To: Guangshuo Li <lgs201920130244@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stas Sergeev <stsp@aknet.ru>, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/rtc: fix failed fallback RTC device registration
 handling
Message-ID: <202604300638.5ysk7jy1-lkp@intel.com>
References: <20260415193455.3869807-1-lgs201920130244@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415193455.3869807-1-lgs201920130244@gmail.com>
X-Stat-Signature: ohj9oia48b1m9sz1mddb7ytaeju5iw8t
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 10BAE4000A
X-Rspam-User: 
X-HE-Tag: 1777502470-43422
X-HE-Meta: U2FsdGVkX188qnanjsEFfYWBMuGeUTzjEXIODrkXWZdpImqgO+01QGOF+lCw2O+vX6a2slfk+MVQTvoDGH/W2FvzkF90zizV7ML9UrUP5W6fikHLq2GF5ioH7KuVrwTjeIGViq/22njStNOIu/s74gGW7FIYxtD0BixHZQZqzkqs5uNmrQRH33CQi/sgaBa7VeYhTIGvJsRMjEF8ulurEDF52e5rvVDnqoc3CoqR2C+CyunmJIUlaL1R+0qpVeQJRAaR/HLYVMdsN4XVvfP9bjt53/fiQYA2xNiVqQ9w3WFbxO84TMbCpYmEm9StCOT34l+pefb9sYvzVCGlF2eKyP/qKNX4XghozECsVR/JVNwo/SYV1CURs/P/fwN14OnzVy0jYk+AV8nz7wSBMA+1fL/JOLRCJoIN9nhJL9CvKLf7JqGE0ifvj4WwMTSKT/l1zg0Naq/K3xl+sarJfGqnq1ldhSZuWIVuuRELHtz8MOul48H/2hVR+qKSUHhRZ6b/bTKB5izotVuJcS9Es/ETz5nK8YzKjBmi6EMI1X+0D4e5BPMccVgmebhe4TbFe6P/bPwDejciqO8caQ1DI5L1WVHhDW2p2OtZQ26SVPxv+vEVqXoG7iEeXfv44VBHmfyq2WjtWt0cSR30/jzA95jIvL7dZO9lmWQN3IQqqjncj6P1tNolpCtsr12W0n91bxxMQ7ezXYITJ7bPIvtXeJOT24na8rZUsikuKWOWYullhMLnaLQ0FLHo8i3Ed5JvXqNSxxYZrnSr8fZXixKYWfhv0OShk5uF0IA5egUO0HZtQYkgtz1WKPx2d5p3luhnssCNJoMSPyMeQ8uuyXx8bSYDuBTRRcW6jX4QSe823C1/XjTFthHO0VWB/V/7m5tF8LeqQsiY+2nvBC1Q97PGun6RpNnfBZBPNgbQ/VRSsbAtdj75ciKCYYxc3fxWo81rK2eu4LK73Y69exLhwUueMon
 9XQgC0mL
 JDl6EMnyHjG51Qb21/fdYeKx4Vhyt4ogNNRNFudfc/kvk/ddxBXaCuQCxRAu9lbiM6hltsZkSKG578JvGEAag5oVuh/7+j+6qUjDP1xXey/0rs5+Z8ydmo+QO17z51Ji8pEDwbMHEoChA4JiP2su+t3NXyds95p26dTAGniZPoJvWFxFpxpAPXIdkDmAutAa33XYX9CUa1Vt1/flZ/VhcBIrPxT7rJVP8w3XbPuljFzzvlYyunyFrZ1RVqy+gj1MTBmRGAxBYWgztaXalUpQ5TqTGTvIopG16r96ZBAo6Byr4NHP3rJN/JrZCaj/cg95IApJy+PSPQuqWTSJu0fokletTkZX6pC+sh/UqWzCbF6sYEfTEEMv9+IBp4FQ9NEtIj2r8
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
config: i386-allnoconfig (https://download.01.org/0day-ci/archive/20260430/202604300638.5ysk7jy1-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604300638.5ysk7jy1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604300638.5ysk7jy1-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kernel/rtc.c: In function 'add_rtc_cmos':
>> arch/x86/kernel/rtc.c:142:9: error: 'ret' undeclared (first use in this function); did you mean 'net'?
     142 |         ret = platform_device_register(&rtc_device);
         |         ^~~
         |         net
   arch/x86/kernel/rtc.c:142:9: note: each undeclared identifier is reported only once for each function it appears in


vim +142 arch/x86/kernel/rtc.c

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

