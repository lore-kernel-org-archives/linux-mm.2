Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D73C7CCFA1E
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 10:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A754A8E000C; Sun,  9 Nov 2025 05:44:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D2E8E0003; Sun,  9 Nov 2025 05:44:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989808E000C; Sun,  9 Nov 2025 05:44:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EF228E0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 05:44:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 147B34C2AA
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 10:44:41 +0000 (UTC)
X-FDA: 84090735162.25.9EB9F85
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id 72D24120006
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 10:44:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U6rhPjUD;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762685079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AionL5C4jT4daZRi14QwWboLcCEtSd8XHLL3AjbQHA0=;
	b=YvuS4RQRX4X4qobmiN5/x4tAHKChyDA5inu9OI1OF97+RR5A7Q1wX/91x5Uxni/BHboShz
	w42a/M1T+X04QgMEnAccj74Narfc4jnSrCq0hUMlF6rK5MTbxjlylp+fu13E44U+OTbZGw
	m/F/XpNydzNw5Gs8O+ldmS+37+uAIXQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U6rhPjUD;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762685079; a=rsa-sha256;
	cv=none;
	b=WcwskaNA69kW421OWSk9mFyO8E8+Y7KWw5zywgDi+8oAC5XnSeIo1e1zRYwsVQvWHmJ2T9
	kFhww18SkCxgKnYkA8E0cs4W9p1qiGGq7nyuiNwG3Wcb+AMBoRo5I/7iiFWQyFKW1/Q+We
	OUqP6ML43hAwJ/tbGDr/hlgyAeZDWnc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762685078; x=1794221078;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=44MHQPu5x73Mpyie/3cjmT1gjLe/2NVED6ahHMZiY0E=;
  b=U6rhPjUD/syGTY89Q/YGiAH+fv+C+VUna7ZreHIlLl2skU8i7/Ay3Vaz
   72aUqp2w19kTZf3Aq5AzjdM7PiiYub2zgySbfuy8zmJJ9xlQHhyZr0gbz
   f9UO4ioVM2/NJ29S3sNP3oVT5vLIoyksf25RUH5k4yFmShvZ4Tsj4MBBK
   CEfwFgEpDnRyiyRXa07hZWhlyUoNoDEVWY+wZ//IEfA0h6hZcTHhwLzXE
   r90ulU7+uwzpJ+KFcpJD6n+V1IxND44Tylwhdkce7uY94102dlWL6ip3L
   ntvYrUh2Ep7s+72Hok5SE8k/DX+U4i7VCpC2MBSFdxgqeZ/5l8tYmYiR7
   A==;
X-CSE-ConnectionGUID: NfwL1voORhWUKEWtCdoDZQ==
X-CSE-MsgGUID: lsPDLz69SpWMJ4DyqoVqxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11607"; a="67370306"
X-IronPort-AV: E=Sophos;i="6.19,291,1754982000"; 
   d="scan'208";a="67370306"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 02:44:36 -0800
X-CSE-ConnectionGUID: CE3LIVPBR7e/xN0LEEcy/g==
X-CSE-MsgGUID: I0kkBDkwT5qwGH5mPL0TUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,291,1754982000"; 
   d="scan'208";a="192547074"
Received: from lkp-server01.sh.intel.com (HELO 6ef82f2de774) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 09 Nov 2025 02:44:34 -0800
Received: from kbuild by 6ef82f2de774 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vI2uN-0001w7-0B;
	Sun, 09 Nov 2025 10:44:31 +0000
Date: Sun, 9 Nov 2025 18:43:46 +0800
From: kernel test robot <lkp@intel.com>
To: Alejandro Colomar <alx@kernel.org>, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Alejandro Colomar <alx@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Christopher Bazley <chris.bazley.wg14@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/4] array_size.h: Add ARRAY_END()
Message-ID: <202511091804.XUQA4dOK-lkp@intel.com>
References: <35255c1ceb54518779a45351dcd79a3c1910818a.1762637046.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35255c1ceb54518779a45351dcd79a3c1910818a.1762637046.git.alx@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 72D24120006
X-Stat-Signature: xp5tut9syautzn1p4ie7q45riybaeapf
X-Rspam-User: 
X-HE-Tag: 1762685078-318132
X-HE-Meta: U2FsdGVkX1/ASm+XFfqss4zbn6Xhv3bMRCQGuKinp2wD15Ev30tmVi4i4eKHrlrsnGtwMnfLQVgvOkQjFIibqhQrAY5GsqIsYZffH20RrFoXOiZFesdFWjFa9u7L4Ym7MV8IIjb9kygAte/x3Lz2yCAowkr/dVcD2iLfmHst+5z2a8Hya62c86JImZpMehGunmlo6H7vOUNcOIGT3Rv8cDA4SZCpWqSp/4r1794hzxKKYF+EewaoeaOMoTsnMokngjAqbm1tPHMhF2g/+4fEjXFnz8Rnbi4fuPeln8DaC5HfZAdVH1ZRIiwS1yWHYMrKZjyikuGcfH+1oe667lPGXgo4G+IY+l7FSIv7ST+xgHz+eaEQ2C4wbSYJzDyr0yN6ovPamB0jp1YcOz3x0k5fojzU9apEU4JNBKgNS98BClR3a/jab+9vMHKnVb8Hsmk9twShCNoWja0UmNxMmVvVRQ7HeW33SdxK8EEEXJvo73w43Xun3g9R29ZGkUxbUmMzN3iwg0G+SagVe58OVXhz5qsUtoxvSMpQvet7pRf92Fmk2tKmFscxTDAdrzs5pC/kipZSwMFEPtnV0UWO+8MQz83rsj9szTTMrrTUMh7eq6hXC3PZ2xh8MpaFU2NAtLyVxssa8A0QdWVR1lFYDbKnRHoGz3U/pd0G5L4vP0qrXvvBlFFrxCuaI0gSyDioDLplJ8UB8hybuNlBbiWZ6LIcuvDchDssH63cIod9oK/F3OiDgSza6Pw4E8qpBhKSbDjKnNkHH4ESMvToopZj9K3tobz85RtPswSoXwuHx2B7SonvjDJOWq8gsIqhawhrgZohYFkk3U4iTyg7LyUm24sUPMWoqftBD3A4x/HKHskm8nVrm251RvhforY8tdzlNGTDK319XlZFT4Bx4qyZEPkDR/8JRU0ll1DE0LRYX2C5GWVGuKQv7rV7/PoX5+qqtRTXcwl4lzKI/ZQ7zqLc7QX
 pOQOYGrg
 mgPc2syrc+Xzr3RQhUtAacHJcUpNda21YqbFimYJRH5dtXN207zUzC2aELhBE7FptbhEgmjOzIuMN9MSwXmOKiEn5B4jjEO1QKwAk0MldoKNnWi4tEoOgdd0ytp++cl/K/e/YGQDmERi5VXdRpuoB6nO81jsUoBBghG4HcKnormiKhKdce8bt0Agg6Zy440tBJEZdAzILU3RdxUg4YJDKcfSbraJJ1s1RqjRdOOcMDpC+S28CL1sXIKveyCh7V3ayAUeWyBoj8AQVpR9f6l1luiKptTVww2oojilqBertKnbV9gLwCnNU+oRQyk1569+qOleu/Gp9Kl8TWtQSoZVE9on3pHv47G50NG5+EPWRTyoLmChBeeBR9cTFIjSfm505vG6Ov7HWY2IjGUpK2Y4Q96BU1kkJtVySXdAhgkxp2v1tMPpPkT5eGjXLwFCGvoiRh7Iz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alejandro,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 6146a0f1dfae5d37442a9ddcba012add260bceb0]

url:    https://github.com/intel-lab-lkp/linux/commits/Alejandro-Colomar/array_size-h-Add-ARRAY_END/20251109-062234
base:   6146a0f1dfae5d37442a9ddcba012add260bceb0
patch link:    https://lore.kernel.org/r/35255c1ceb54518779a45351dcd79a3c1910818a.1762637046.git.alx%40kernel.org
patch subject: [PATCH v2 1/4] array_size.h: Add ARRAY_END()
config: alpha-defconfig (https://download.01.org/0day-ci/archive/20251109/202511091804.XUQA4dOK-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251109/202511091804.XUQA4dOK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511091804.XUQA4dOK-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/block/floppy.c:4805:9: warning: 'ARRAY_END' redefined
    4805 | #define ARRAY_END(X) (&((X)[ARRAY_SIZE(X)]))
         |         ^~~~~~~~~
   In file included from include/linux/string.h:6,
                    from include/linux/bitmap.h:13,
                    from include/linux/nodemask.h:91,
                    from include/linux/numa.h:6,
                    from include/linux/async.h:13,
                    from drivers/block/floppy.c:166:
   include/linux/array_size.h:17:9: note: this is the location of the previous definition
      17 | #define ARRAY_END(a)  (a + ARRAY_SIZE(a))
         |         ^~~~~~~~~


vim +/ARRAY_END +4805 drivers/block/floppy.c

5a74db06cc8d36 Philippe De Muyter 2009-02-18  4804  
5a74db06cc8d36 Philippe De Muyter 2009-02-18 @4805  #define ARRAY_END(X) (&((X)[ARRAY_SIZE(X)]))
5a74db06cc8d36 Philippe De Muyter 2009-02-18  4806  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

