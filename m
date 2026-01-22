Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A09F0C44508
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 01:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB87B6B0095; Wed, 21 Jan 2026 20:12:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A903A6B0096; Wed, 21 Jan 2026 20:12:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9926B0098; Wed, 21 Jan 2026 20:12:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88A6F6B0095
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:12:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 283A9D4C98
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:12:32 +0000 (UTC)
X-FDA: 84357824544.18.B3A42F9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8F0A6140006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:12:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IcAuBCJc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769044350; a=rsa-sha256;
	cv=none;
	b=GggYb42z/yJ+BYMnScd8gcLkfq9eDxXaW0TK9xmjWWRtmN6SdMqPC9XccpJ8cVI60XQk1H
	lMqb+WKlM+nGXYkHGEcLNdRbNHaqM50LsBLBXD/GH2loWo4iTIeLkRB0cmU0vznMicwHpv
	wnNYpekb7SNeWAp6HH0dORgMNwvi9Wc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IcAuBCJc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769044350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7nDrfcQ9gATIAi+aqBLubgyvh7XxFjt7RQuHsrn51Q=;
	b=hPej1wAvQII/GxbKiYZjMHNODmP87hdA6qrmTAdrn2hNdj2SJ0sXBSsqGffeHVfCPmbZmK
	Tfk1yfz8hDLWTGxcDniqchkoPr49ONJViAA/O1mRFM4zjl/nXHkQZ7AIPdp9H6bUMju+l8
	Jn5iYCW1LJY90VbN6mWMHdai+m30Uo8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769044350; x=1800580350;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QVMUWucKVUo5Jl2bgmDp5wlChrNcG2VDFMqtEXavpPo=;
  b=IcAuBCJckfPmnz/MBI3ynYeTHIvknn5pEFCpV88oDEkhM4mOAVQOYsVP
   B1+w/K96tExRUkyGoNiG5zc3S+6AjOtmMiPsZQya/YKyYP/TCRiweVqkg
   vORrRaMkTP5UW/f/BSH4pXl5I4laFLCzwfLgUitqpbsiY0wcvWoGhyiUx
   s7WMzJkEF62XvZ2+CfILj8cUH/PzOhZ9BS1UberFQC4GdxB8ebrerdzbg
   ciU87qFXramtO4SCJvHbHDrmIxWbdNbBXn05Wn7gMWRgzhaW0F4+eDCuG
   UW9cn/M+PEzJqtzC/Y5oYIefW4MYfrcdIJsjF/n/79AHB7wuozrEPuwke
   A==;
X-CSE-ConnectionGUID: F/G6miMtTL2gQQlkeUj+1g==
X-CSE-MsgGUID: tvga9FkoRmOz67dYshZ/cA==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="80904732"
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="80904732"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 17:12:28 -0800
X-CSE-ConnectionGUID: TQFW317MQY2Hv0HZmg/W7A==
X-CSE-MsgGUID: L9x4vIJVRNaJJpOZZj8zOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="211106979"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 21 Jan 2026 17:12:23 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vijFE-00000000SET-1IMD;
	Thu, 22 Jan 2026 01:12:20 +0000
Date: Thu, 22 Jan 2026 09:11:53 +0800
From: kernel test robot <lkp@intel.com>
To: david.laight.linux@gmail.com, Nathan Chancellor <nathan@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: Re: [PATCH next 11/14] bit: Strengthen compile-time tests in
 GENMASK() and BIT()
Message-ID: <202601220829.MgTMeqqN-lkp@intel.com>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121145731.3623-12-david.laight.linux@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8F0A6140006
X-Stat-Signature: sn9wkxrxksibj1phsmfpqw7jf5ymgdc1
X-HE-Tag: 1769044349-700587
X-HE-Meta: U2FsdGVkX1+bnWEAvc9kLoB5j+vJZ0pzRtvwX0pDffm6tz6hJRxF2cJAC22V7Jk4j4s7RDRu+c6Mrq8AigLlh/uzzXB6pMU8am23eHMwY3Rs45/MjxjAAPb6owM+m3H0IpsZFldZHUhePfqoyEHk8CJYVF9RtpUP5vvnyli6NasBvOqa53dRLYXvkmAgLZNmh6xm67T3MuWQ7JsLbB2fqwX5X+PDzn5DxoCdBs4Bv4H6VB0N1pWuYFaBaUTWnC5AJMtr/J0O4BxcCihRdmCLLcbKwr3vcbM66BQhQGRHB3ie+HVGRGF8mZTcOYNJe5zUY0nmZg5PvZ0QkJBb84+4iePYToPn3KXlGnjztJFy5/JIF13aitSWwzQhL1S3r9aWHpg5/9utkanKWIAUeBL4SVFHq3627rfzY8G1MR1HCHLk38D0VM4kSZUJ+OkIiRbmFqcK0YB9KstNjvPah9nFEhh/wrRbRIBnZT3oqDBmiRTaaDHG/NFy/TSDTUCLya4hy8X1dPuw2bzmwduWhrytA2RNtPbCmj0s4Wp6XDdky4EGntF2U99ytiucHD01cIQxWdpN8NWDsJWFRzKv3k/opbM2thLIz3ShMWjBFrRkoUJsxjiPfJ5bkfUJBwuESH2WgcBYbaVy8owjr/ExXf4JafDRJUM2t2B51eU7UzAGuqEQs50f3v8xW8TRzL7J+wOAm2NJ+Vrx6Mh7aMraNMiHUEouTWVPv03UXJZ9OlydOjgNwOko6eeoeKGbJjbwVFiSTIvqRu9kMX22zBkK2l+E3h+vcw/GsB4vtjL5qaqbIx8XhKlj0AHFKVMyBUUjio0X8taPiQqaT4kxsr2Gz8IxL1MR5rypDwkvKvuVg6ANNh+vqfIM25dhRSrZRqDHH24FsP0Xc+hsTxfiW4Dl2RwTfXirzyHYwLB3hG1YUunn5FUnOEey5ofi1qpMF4cOSPstfWRxz4DFGfj0bjkFebm
 CLozlldA
 dZOTCKwD9Cp71hLw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20260120]

url:    https://github.com/intel-lab-lkp/linux/commits/david-laight-linux-gmail-com/overflow-Reduce-expansion-of-__type_max/20260122-013456
base:   next-20260120
patch link:    https://lore.kernel.org/r/20260121145731.3623-12-david.laight.linux%40gmail.com
patch subject: [PATCH next 11/14] bit: Strengthen compile-time tests in GENMASK() and BIT()
config: s390-randconfig-001-20260122 (https://download.01.org/0day-ci/archive/20260122/202601220829.MgTMeqqN-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601220829.MgTMeqqN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601220829.MgTMeqqN-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/s390/include/asm/bug.h:60,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from arch/s390/include/asm/cmpxchg.h:11,
                    from arch/s390/include/asm/atomic.h:16,
                    from include/linux/atomic.h:7,
                    from include/asm-generic/bitops/atomic.h:5,
                    from arch/s390/include/asm/bitops.h:75,
                    from include/linux/bitops.h:67,
                    from include/linux/kernel.h:23,
                    from net/core/page_pool.c:10:
   In function 'netmem_clear_pp_magic',
       inlined from 'page_pool_clear_pp_info' at net/core/page_pool.c:721:2:
>> include/linux/bits.h:35:4: error: call to 'GENMASK_INPUT_CHECK_FAIL' declared with attribute error: Invalid bit numbers
       GENMASK_INPUT_CHECK_FAIL()))
       ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/bug.h:120:25: note: in definition of macro 'WARN_ON_ONCE'
     int __ret_warn_on = !!(condition);    \
                            ^~~~~~~~~
   include/linux/bits.h:54:17: note: in expansion of macro 'GENMASK_INPUT_CHECK'
     ((unsigned int)GENMASK_INPUT_CHECK(h, l, BITS_PER_TYPE(t)) + \
                    ^~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:58:24: note: in expansion of macro 'GENMASK_TYPE'
    #define GENMASK(h, l)  GENMASK_TYPE(unsigned long, h, l)
                           ^~~~~~~~~~~~
   include/linux/mm.h:4641:27: note: in expansion of macro 'GENMASK'
    #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
                              ^~~~~~~
   net/core/netmem_priv.h:18:52: note: in expansion of macro 'PP_DMA_INDEX_MASK'
     WARN_ON_ONCE(netmem_to_nmdesc(netmem)->pp_magic & PP_DMA_INDEX_MASK);
                                                       ^~~~~~~~~~~~~~~~~
--
   In file included from include/linux/bitops.h:6,
                    from arch/s390/include/asm/machine.h:25,
                    from arch/s390/include/asm/lowcore.h:13,
                    from arch/s390/include/asm/current.h:13,
                    from arch/s390/include/asm/preempt.h:5,
                    from include/linux/preempt.h:79,
                    from arch/s390/include/asm/timex.h:13,
                    from include/linux/timex.h:67,
                    from include/linux/time32.h:13,
                    from include/linux/time.h:60,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from net/core/skbuff.c:37:
   In function 'netmem_get_pp_magic',
       inlined from 'netmem_is_pp' at net/core/netmem_priv.h:25:10,
       inlined from 'napi_pp_put_page' at net/core/skbuff.c:1027:6:
>> include/linux/bits.h:35:4: error: call to 'GENMASK_INPUT_CHECK_FAIL' declared with attribute error: Invalid bit numbers
       GENMASK_INPUT_CHECK_FAIL()))
       ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:54:17: note: in expansion of macro 'GENMASK_INPUT_CHECK'
     ((unsigned int)GENMASK_INPUT_CHECK(h, l, BITS_PER_TYPE(t)) + \
                    ^~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:58:24: note: in expansion of macro 'GENMASK_TYPE'
    #define GENMASK(h, l)  GENMASK_TYPE(unsigned long, h, l)
                           ^~~~~~~~~~~~
   include/linux/mm.h:4641:27: note: in expansion of macro 'GENMASK'
    #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
                              ^~~~~~~
   net/core/netmem_priv.h:8:47: note: in expansion of macro 'PP_DMA_INDEX_MASK'
     return netmem_to_nmdesc(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
                                                  ^~~~~~~~~~~~~~~~~
   In function 'netmem_is_pp',
       inlined from 'napi_pp_put_page' at net/core/skbuff.c:1027:6:
>> include/linux/bits.h:35:4: error: call to 'GENMASK_INPUT_CHECK_FAIL' declared with attribute error: Invalid bit numbers
       GENMASK_INPUT_CHECK_FAIL()))
       ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:54:17: note: in expansion of macro 'GENMASK_INPUT_CHECK'
     ((unsigned int)GENMASK_INPUT_CHECK(h, l, BITS_PER_TYPE(t)) + \
                    ^~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:58:24: note: in expansion of macro 'GENMASK_TYPE'
    #define GENMASK(h, l)  GENMASK_TYPE(unsigned long, h, l)
                           ^~~~~~~~~~~~
   include/linux/mm.h:4641:27: note: in expansion of macro 'GENMASK'
    #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
                              ^~~~~~~
   include/linux/mm.h:4650:25: note: in expansion of macro 'PP_DMA_INDEX_MASK'
    #define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
                            ^~~~~~~~~~~~~~~~~
   net/core/netmem_priv.h:25:40: note: in expansion of macro 'PP_MAGIC_MASK'
     return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
                                           ^~~~~~~~~~~~~
   In function 'netmem_get_pp_magic',
       inlined from 'netmem_is_pp' at net/core/netmem_priv.h:25:10,
       inlined from 'napi_pp_put_page' at net/core/skbuff.c:1027:6:
>> include/linux/bits.h:35:4: error: call to 'GENMASK_INPUT_CHECK_FAIL' declared with attribute error: Invalid bit numbers
       GENMASK_INPUT_CHECK_FAIL()))
       ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:54:17: note: in expansion of macro 'GENMASK_INPUT_CHECK'
     ((unsigned int)GENMASK_INPUT_CHECK(h, l, BITS_PER_TYPE(t)) + \
                    ^~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:58:24: note: in expansion of macro 'GENMASK_TYPE'
    #define GENMASK(h, l)  GENMASK_TYPE(unsigned long, h, l)
                           ^~~~~~~~~~~~
   include/linux/mm.h:4641:27: note: in expansion of macro 'GENMASK'
    #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
                              ^~~~~~~
   net/core/netmem_priv.h:8:47: note: in expansion of macro 'PP_DMA_INDEX_MASK'
     return netmem_to_nmdesc(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
                                                  ^~~~~~~~~~~~~~~~~
   In function 'netmem_is_pp',
       inlined from 'napi_pp_put_page' at net/core/skbuff.c:1027:6:
>> include/linux/bits.h:35:4: error: call to 'GENMASK_INPUT_CHECK_FAIL' declared with attribute error: Invalid bit numbers
       GENMASK_INPUT_CHECK_FAIL()))
       ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:54:17: note: in expansion of macro 'GENMASK_INPUT_CHECK'
     ((unsigned int)GENMASK_INPUT_CHECK(h, l, BITS_PER_TYPE(t)) + \
                    ^~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:58:24: note: in expansion of macro 'GENMASK_TYPE'
    #define GENMASK(h, l)  GENMASK_TYPE(unsigned long, h, l)
                           ^~~~~~~~~~~~
   include/linux/mm.h:4641:27: note: in expansion of macro 'GENMASK'
    #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
                              ^~~~~~~
   include/linux/mm.h:4650:25: note: in expansion of macro 'PP_DMA_INDEX_MASK'
    #define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
                            ^~~~~~~~~~~~~~~~~
   net/core/netmem_priv.h:25:40: note: in expansion of macro 'PP_MAGIC_MASK'
     return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
                                           ^~~~~~~~~~~~~
   In function 'netmem_get_pp_magic',
       inlined from 'netmem_is_pp' at net/core/netmem_priv.h:25:10,
       inlined from 'skb_pp_frag_ref' at net/core/skbuff.c:1067:7,
       inlined from 'skb_try_coalesce' at net/core/skbuff.c:6203:6:
>> include/linux/bits.h:35:4: error: call to 'GENMASK_INPUT_CHECK_FAIL' declared with attribute error: Invalid bit numbers
       GENMASK_INPUT_CHECK_FAIL()))
       ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:54:17: note: in expansion of macro 'GENMASK_INPUT_CHECK'
     ((unsigned int)GENMASK_INPUT_CHECK(h, l, BITS_PER_TYPE(t)) + \
                    ^~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:58:24: note: in expansion of macro 'GENMASK_TYPE'
    #define GENMASK(h, l)  GENMASK_TYPE(unsigned long, h, l)
                           ^~~~~~~~~~~~
   include/linux/mm.h:4641:27: note: in expansion of macro 'GENMASK'
    #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
                              ^~~~~~~
   net/core/netmem_priv.h:8:47: note: in expansion of macro 'PP_DMA_INDEX_MASK'
     return netmem_to_nmdesc(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
                                                  ^~~~~~~~~~~~~~~~~
   In function 'netmem_is_pp',
       inlined from 'skb_pp_frag_ref' at net/core/skbuff.c:1067:7,
       inlined from 'skb_try_coalesce' at net/core/skbuff.c:6203:6:
>> include/linux/bits.h:35:4: error: call to 'GENMASK_INPUT_CHECK_FAIL' declared with attribute error: Invalid bit numbers
       GENMASK_INPUT_CHECK_FAIL()))
       ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:54:17: note: in expansion of macro 'GENMASK_INPUT_CHECK'
     ((unsigned int)GENMASK_INPUT_CHECK(h, l, BITS_PER_TYPE(t)) + \
                    ^~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:58:24: note: in expansion of macro 'GENMASK_TYPE'
    #define GENMASK(h, l)  GENMASK_TYPE(unsigned long, h, l)
                           ^~~~~~~~~~~~
   include/linux/mm.h:4641:27: note: in expansion of macro 'GENMASK'
    #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
                              ^~~~~~~
   include/linux/mm.h:4650:25: note: in expansion of macro 'PP_DMA_INDEX_MASK'
    #define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
                            ^~~~~~~~~~~~~~~~~
   net/core/netmem_priv.h:25:40: note: in expansion of macro 'PP_MAGIC_MASK'
     return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
                                           ^~~~~~~~~~~~~
   In function 'netmem_get_pp_magic',
       inlined from 'netmem_is_pp' at net/core/netmem_priv.h:25:10,
       inlined from 'skb_pp_frag_ref' at net/core/skbuff.c:1067:7,
       inlined from 'skb_try_coalesce' at net/core/skbuff.c:6203:6:
>> include/linux/bits.h:35:4: error: call to 'GENMASK_INPUT_CHECK_FAIL' declared with attribute error: Invalid bit numbers
       GENMASK_INPUT_CHECK_FAIL()))
       ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:54:17: note: in expansion of macro 'GENMASK_INPUT_CHECK'
     ((unsigned int)GENMASK_INPUT_CHECK(h, l, BITS_PER_TYPE(t)) + \
                    ^~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:58:24: note: in expansion of macro 'GENMASK_TYPE'
    #define GENMASK(h, l)  GENMASK_TYPE(unsigned long, h, l)
                           ^~~~~~~~~~~~
   include/linux/mm.h:4641:27: note: in expansion of macro 'GENMASK'
    #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
                              ^~~~~~~
   net/core/netmem_priv.h:8:47: note: in expansion of macro 'PP_DMA_INDEX_MASK'
     return netmem_to_nmdesc(netmem)->pp_magic & ~PP_DMA_INDEX_MASK;
                                                  ^~~~~~~~~~~~~~~~~
   In function 'netmem_is_pp',
       inlined from 'skb_pp_frag_ref' at net/core/skbuff.c:1067:7,
       inlined from 'skb_try_coalesce' at net/core/skbuff.c:6203:6:
>> include/linux/bits.h:35:4: error: call to 'GENMASK_INPUT_CHECK_FAIL' declared with attribute error: Invalid bit numbers
       GENMASK_INPUT_CHECK_FAIL()))
       ^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:54:17: note: in expansion of macro 'GENMASK_INPUT_CHECK'
     ((unsigned int)GENMASK_INPUT_CHECK(h, l, BITS_PER_TYPE(t)) + \
                    ^~~~~~~~~~~~~~~~~~~
   include/linux/bits.h:58:24: note: in expansion of macro 'GENMASK_TYPE'
    #define GENMASK(h, l)  GENMASK_TYPE(unsigned long, h, l)
                           ^~~~~~~~~~~~
   include/linux/mm.h:4641:27: note: in expansion of macro 'GENMASK'
    #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SHIFT - 1, \
                              ^~~~~~~
   include/linux/mm.h:4650:25: note: in expansion of macro 'PP_DMA_INDEX_MASK'
    #define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
                            ^~~~~~~~~~~~~~~~~
   net/core/netmem_priv.h:25:40: note: in expansion of macro 'PP_MAGIC_MASK'
     return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
                                           ^~~~~~~~~~~~~


vim +/GENMASK_INPUT_CHECK_FAIL +35 include/linux/bits.h

    25	
    26	#ifndef KBUILD_EXTRA_WARNc
    27	#define GENMASK_INPUT_CHECK(h, l, width) 0
    28	#else
    29	int GENMASK_INPUT_CHECK_FAIL(void) __compiletime_error("Invalid bit numbers");
    30	#define GENMASK_INPUT_CHECK(h, l, width)				\
    31		(__builtin_choose_expr(__is_constexpr((l) > (h)),		\
    32			sizeof(struct { char low_bit_greater_than_high[-((l) > (h))];}), \
    33			__builtin_constant_p((l) | (h)) &&			\
    34				((l) < 0 || (l) > (h) || (h) >= width) &&	\
  > 35				GENMASK_INPUT_CHECK_FAIL()))
    36	#endif
    37	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

