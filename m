Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B71C9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 21:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D77D6B00D4; Sun, 18 Jan 2026 16:05:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6851C6B00D5; Sun, 18 Jan 2026 16:05:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ADE56B00D6; Sun, 18 Jan 2026 16:05:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4743E6B00D4
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 16:05:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF7908C0FA
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 21:05:28 +0000 (UTC)
X-FDA: 84346315536.06.443D3EF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F2F8140006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 21:05:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L1kGlcJg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768770326; a=rsa-sha256;
	cv=none;
	b=Ol7RXNgtCNKLdozmiJquFj6H9mDjbWZmknyz48kAeDyp4sIEhVQ4XUQRYDpB9Onh/CIUBJ
	ngW5ULwU2TJqT8sg8iAJGl4pdXKRyXuure9EvTF7IkBaTaDFcSOO6EKTR9hNWBOiLKbcvG
	SbdVTmvHj9V+x1KlscqWyVxcfGnY22I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L1kGlcJg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768770326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+Gh5dGpj/bDc5jPev6JZe5dYnpGnV2Gem7G5YUBd2A=;
	b=pZy52byAzm3Dn+PwzMapPWSUMh96G1l8vHv6JtVHknmqTlLK7U++8Jh2youn3TLqI6tBe/
	wpK2k1Gr0X02W0Po4bq0hPXAAJm68boSPujuCV8b9vNAI9N/BJ7+tFGZeLejcB0vn2m3pb
	i79B8VuEVAYaPUXayDVA72Cg6qB76m8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768770326; x=1800306326;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OE1AoHB1Y79/Fx3YUFsM512vLtvo5xjas7jk/6O9aqg=;
  b=L1kGlcJgq6dicwMy0iNXsAyFueO/aQxq2D9s8GCpE5ddlXdY0EzbfRaF
   fSLiuoJQhrAKJm6dUOuGd0JDtSVK42X69fcomrvQGZ7Uqa15pu2+sJE73
   eDbU1avVCGv8mXU1PAA+x9fMVwscGIawuvx+VH+n06f0+Y4md+R0WHDI4
   Tg5hJcsElUHijFbn//abZuAj688bn7KKIRaWOROMZ+aR732Uu4AYoUeah
   6pU1LFV/yJZLDY/bF+qhnhnFNOpzEX6g3IGIEj9kuhQmHtp7pFGo3eUri
   MML8en4PKpqIX5ApU1zeOYRha9u+CVhrZx+IQShK47KghIwZBFYFK6xZT
   w==;
X-CSE-ConnectionGUID: t3kb+K7ATvSFwR7PS/3F1w==
X-CSE-MsgGUID: VTpridkYS1uUel1NDR5s+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="73620379"
X-IronPort-AV: E=Sophos;i="6.21,236,1763452800"; 
   d="scan'208";a="73620379"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 13:05:24 -0800
X-CSE-ConnectionGUID: ma6M8gC5TueFYLQs1mg2Rw==
X-CSE-MsgGUID: 2d+5Z5+6QeuDEfRp4e4DxQ==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 18 Jan 2026 13:05:22 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vhZxX-00000000NDp-3IGw;
	Sun, 18 Jan 2026 21:05:19 +0000
Date: Mon, 19 Jan 2026 05:04:27 +0800
From: kernel test robot <lkp@intel.com>
To: Eric Dumazet <edumazet@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Nicolas Pitre <npitre@baylibre.com>
Subject: Re: [PATCH] compiler_types: Introduce inline_for_performance
Message-ID: <202601190420.RlBoZSGm-lkp@intel.com>
References: <20260118152448.2560414-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118152448.2560414-1-edumazet@google.com>
X-Rspam-User: 
X-Stat-Signature: tpf7bm5axcsu6ywhkynm4u954a1za76s
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1F2F8140006
X-HE-Tag: 1768770325-474868
X-HE-Meta: U2FsdGVkX190TBVMVAYwm2AaJ2Ap/EBmBarMqe1vvJ6XJSB9lVigG4YlLq8XaQzS6g9wfcgfGUd2jVNalvlBz0WuwXxcr8uzHtLndA+H9ZOL/yZazPq6C+4j5I7A/O/dYJBmICGY6TfVmPGIm2M/ojntXqb50MSF8tMJzqAzyuwUnrdHReyyVV2BbYyDKp9wrov/mrLaZmjLauVHsWXejfiSZ1qTAhiJWrSFsOvdtU66Zzr6WlxFIv5FSZhBLs6rkxS5cyytxS0/02jzRVnRmfhAOmAFRj6LvtqKzOqJg7vxN97Mr2MyPJm1vb+EYGHzd+HyFkx/tFdOJv1fAw/hed+SZbU2pQ24rbnSXU++3/MKX1dosREMN4MfTiAGXCtSr/SwmSxsGdICNdMLP3g0xRGl07QwDmxWbuKGXF/CM2AE71IgMsLmIDiof45BLA3uIpIgmN544f05CiIU93N4nXa3u6+rc5YwNN3aqm/tPx0fZrawxq80wEmfYxgSSwvJZFIxEWAiD8FtmqGHr129brWPEoYv21JsEFjqECxVT+P2Na/nzHbz+eYWFgnZKV25b/vn/cpAd2Z6FvaYOWsILRujVd1w1r9BikCLvV8PWFMW2ds5zwbUkbTD988WKAdKHxQ6ckMSbbNPhfjbSsZ3sVDaQHP6UL8gPYmqYron4H+eB+8Myzb4550bjmOneu3WDiBBVDOlB7nWP3m9Xd2CJqUm0AC/TJ5l7Lfj0G1wjqN/4Iw5RzpHxCStgmsMLkj7jIp/hFrrNJaekMmwJ72epyGeqLM3R1KetDMQFkd1MD4GXmOfCq2jKYw7wup70RrqrizFzCkqClbZQLGCbsLWPTColkNimsqH0QoDTrSjB53x6BJy+5MILPMMUpW8RQoF6Tfa9VsFWmsqMvVubNz8sjmCcb9aqFipxZPTyATpOfDwMkT6SzMGnHSmDuk13z/188c/U5gcWJ/BjGUrA1T
 WUSQks80
 fmYWvF4/bhZllCFHZR7k52Zz4SkA5L9AcKp54NErPRl9DJmDzrL1YFIPDZjboXyUh4iE2xn7aK7/BJea01Puv0vWb6vOLS3BiWYNcDfdLHP5NGCDTMDOTv75ktGkYWGSAKrueW6SqZhgSjDh988FLDJLhLhnvf996KEyVNThrmS4S3ZhREAcRPIOTiMjOD07RLUOsfH7sxYbK5nE3Hy7Ep5NUYYE8/bPvjXYTyyMKL9D8BmmC9VmqYAm+2w2ue5hxBrLrIa5/k1vNSOvW92EN1Y0Zwdt93IJPuLbl62ORouOUrEoc23WAwHQrjDikO48j2C3AClkEsIgezgT4XInlf7HDHgwA7FDsKz+mLSG+y4S2H113Kdro/mNDYZONKebZBWgPGqDeQnHWEh+KJRwY4DR0eILTUsGxamRubVc2NDQ5b8xZy3W1oWasyeEgCmqtIsQH1h0y9sSlKqViXnFLRUeADA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eric,

kernel test robot noticed the following build warnings:

[auto build test WARNING on e84d960149e71e8d5e4db69775ce31305898ed0c]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/compiler_types-Introduce-inline_for_performance/20260118-232653
base:   e84d960149e71e8d5e4db69775ce31305898ed0c
patch link:    https://lore.kernel.org/r/20260118152448.2560414-1-edumazet%40google.com
patch subject: [PATCH] compiler_types: Introduce inline_for_performance
config: arm-randconfig-004-20260119 (https://download.01.org/0day-ci/archive/20260119/202601190420.RlBoZSGm-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260119/202601190420.RlBoZSGm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601190420.RlBoZSGm-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/math.h:6,
                    from include/linux/kernel.h:27,
                    from include/linux/random.h:7,
                    from include/linux/nodemask.h:94,
                    from include/linux/numa.h:6,
                    from include/linux/cpumask.h:15,
                    from include/linux/smp.h:13,
                    from include/linux/lockdep.h:14,
                    from include/linux/spinlock.h:63,
                    from lib/dec_and_lock.c:3:
>> arch/arm/include/asm/div64.h:56:10: warning: '__arch_xprod_64' defined but not used [-Wunused-function]
      56 | uint64_t __arch_xprod_64(uint64_t m, uint64_t n, bool bias)
         |          ^~~~~~~~~~~~~~~


vim +/__arch_xprod_64 +56 arch/arm/include/asm/div64.h

fa4adc614922c2 include/asm-arm/div64.h      Nicolas Pitre 2006-12-06   54  
5f712d70e20a46 arch/arm/include/asm/div64.h Eric Dumazet  2026-01-18   55  static inline_for_performance
d533cb2d2af400 arch/arm/include/asm/div64.h Nicolas Pitre 2024-10-03  @56  uint64_t __arch_xprod_64(uint64_t m, uint64_t n, bool bias)
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   57  {
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   58  	unsigned long long res;
73e592f3bc2cdc arch/arm/include/asm/div64.h Nicolas Pitre 2016-01-27   59  	register unsigned int tmp asm("ip") = 0;
06508533d51a1d arch/arm/include/asm/div64.h Nicolas Pitre 2024-10-03   60  	bool no_ovf = __builtin_constant_p(m) &&
06508533d51a1d arch/arm/include/asm/div64.h Nicolas Pitre 2024-10-03   61  		      ((m >> 32) + (m & 0xffffffff) < 0x100000000);
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   62  
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   63  	if (!bias) {
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   64  		asm (	"umull	%Q0, %R0, %Q1, %Q2\n\t"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   65  			"mov	%Q0, #0"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   66  			: "=&r" (res)
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   67  			: "r" (m), "r" (n)
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   68  			: "cc");
06508533d51a1d arch/arm/include/asm/div64.h Nicolas Pitre 2024-10-03   69  	} else if (no_ovf) {
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   70  		res = m;
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   71  		asm (	"umlal	%Q0, %R0, %Q1, %Q2\n\t"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   72  			"mov	%Q0, #0"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   73  			: "+&r" (res)
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   74  			: "r" (m), "r" (n)
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   75  			: "cc");
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   76  	} else {
73e592f3bc2cdc arch/arm/include/asm/div64.h Nicolas Pitre 2016-01-27   77  		asm (	"umull	%Q0, %R0, %Q2, %Q3\n\t"
73e592f3bc2cdc arch/arm/include/asm/div64.h Nicolas Pitre 2016-01-27   78  			"cmn	%Q0, %Q2\n\t"
73e592f3bc2cdc arch/arm/include/asm/div64.h Nicolas Pitre 2016-01-27   79  			"adcs	%R0, %R0, %R2\n\t"
73e592f3bc2cdc arch/arm/include/asm/div64.h Nicolas Pitre 2016-01-27   80  			"adc	%Q0, %1, #0"
73e592f3bc2cdc arch/arm/include/asm/div64.h Nicolas Pitre 2016-01-27   81  			: "=&r" (res), "+&r" (tmp)
73e592f3bc2cdc arch/arm/include/asm/div64.h Nicolas Pitre 2016-01-27   82  			: "r" (m), "r" (n)
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   83  			: "cc");
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   84  	}
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   85  
06508533d51a1d arch/arm/include/asm/div64.h Nicolas Pitre 2024-10-03   86  	if (no_ovf) {
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   87  		asm (	"umlal	%R0, %Q0, %R1, %Q2\n\t"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   88  			"umlal	%R0, %Q0, %Q1, %R2\n\t"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   89  			"mov	%R0, #0\n\t"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   90  			"umlal	%Q0, %R0, %R1, %R2"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   91  			: "+&r" (res)
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   92  			: "r" (m), "r" (n)
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   93  			: "cc");
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   94  	} else {
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   95  		asm (	"umlal	%R0, %Q0, %R2, %Q3\n\t"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   96  			"umlal	%R0, %1, %Q2, %R3\n\t"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   97  			"mov	%R0, #0\n\t"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   98  			"adds	%Q0, %1, %Q0\n\t"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02   99  			"adc	%R0, %R0, #0\n\t"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02  100  			"umlal	%Q0, %R0, %R2, %R3"
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02  101  			: "+&r" (res), "+&r" (tmp)
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02  102  			: "r" (m), "r" (n)
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02  103  			: "cc");
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02  104  	}
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02  105  
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02  106  	return res;
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02  107  }
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02  108  #define __arch_xprod_64 __arch_xprod_64
040b323b5012b5 arch/arm/include/asm/div64.h Nicolas Pitre 2015-11-02  109  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

