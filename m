Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F9C7CCFA02
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 19:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8084E8E001C; Sat,  1 Nov 2025 15:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BA008E0015; Sat,  1 Nov 2025 15:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8A18E001C; Sat,  1 Nov 2025 15:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 561568E0015
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 15:36:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10FFCBA6E8
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 19:36:55 +0000 (UTC)
X-FDA: 84063045990.18.E6B6776
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id 408091A000E
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 19:36:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KRRXb0UU;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762025813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYqGa9RORLVyXblVOECesyP+TuX/E6+QTJ1nBrAec7E=;
	b=5giashKCmR2cUXcnnM6EdTD+JVt72y/DpGjLrShBsYSArUklBVjyxO/tIMnT9dplfV6zfd
	ZEqe2qJJKQBvNO3FFqHtU4rDDKG6/otOmWLIWEdF2dJP2oQVvDhIEdx72izinZzeQnRELB
	XMid5Myo4Cwg/t4JskAoM80YzN0A7EE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KRRXb0UU;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762025813; a=rsa-sha256;
	cv=none;
	b=inwYZCAVgFAeUibKQ3nFlBUE5NIrIW1sHZXrMJsFua5QmPmdlcVkzyL6SQ/GExVul4xsnv
	gS1ZhStaXnqmnY5uD/67qIAK0XGiu392RBvof9SyKdn2FrarJBtD2cUk8eb9Y+4ooN9x4v
	/Ux1gxavVvGeik7piVZKGo0huIIazLg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762025812; x=1793561812;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UNLgUNEbuilYnhoztX92QSHI2QpWIAoqAV+6Dwad9Fg=;
  b=KRRXb0UUw/nmJzI5RcZp0KL/+UsUZzN2SArqOPpMj5uxD9hitomKsfB4
   4DrR+GZMTsrJFm5zVBbNAK6q08ntgOevLbwZxRhugJye+NsEZ2ZBZT/LJ
   8gXeXHddefWEySiTvZRnMHhQ2nye7sQadV2rwV8kLa8WJU+hpxCRnmp67
   /o3e0xfY6YxAdDyRhvyLEXb82lYlvMuNOLAzWCz652LYKWaiMalI8dmKl
   fvlO7Da0fqPtLinn2Sfyy7A3h3uWED1UNQuSu73NlAJJ9+FV8bOLUjOJN
   zUPIrH4SMP3u1hdBED6iC7LIziNt4by/L+QSzjdpOegELU0akhXEn0wzP
   Q==;
X-CSE-ConnectionGUID: qjy3IcCCSKG1WuO9Kz4mBA==
X-CSE-MsgGUID: EZLQlxUfRxKiCimYO3driw==
X-IronPort-AV: E=McAfee;i="6800,10657,11600"; a="74452049"
X-IronPort-AV: E=Sophos;i="6.19,272,1754982000"; 
   d="scan'208";a="74452049"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2025 12:36:50 -0700
X-CSE-ConnectionGUID: /AXIaqu7T1CsP3LWinhpbA==
X-CSE-MsgGUID: xzImgq6JSjeWc0g6fZo9+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,272,1754982000"; 
   d="scan'208";a="186393320"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 01 Nov 2025 12:36:46 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vFHON-000Odw-2x;
	Sat, 01 Nov 2025 19:36:10 +0000
Date: Sun, 2 Nov 2025 03:35:20 +0800
From: kernel test robot <lkp@intel.com>
To: David Laight <david.laight.linux@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Laight <david.laight.linux@gmail.com>,
	u.kleine-koenig@baylibre.com, Nicolas Pitre <npitre@baylibre.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Li RongQing <lirongqing@baidu.com>, Yu Kuai <yukuai3@huawei.com>,
	Khazhismel Kumykov <khazhy@chromium.org>,
	Jens Axboe <axboe@kernel.dk>, x86@kernel.org
Subject: Re: [PATCH v4 next 6/9] lib: test_mul_u64_u64_div_u64: Test both
 generic and arch versions
Message-ID: <202511020341.TEhkaR65-lkp@intel.com>
References: <20251029173828.3682-7-david.laight.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029173828.3682-7-david.laight.linux@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 408091A000E
X-Stat-Signature: tgwm8a4xrg98o185jic5qfnr6e1yn9rm
X-Rspam-User: 
X-HE-Tag: 1762025811-557065
X-HE-Meta: U2FsdGVkX1/a+kxMBkcnFzRQdaEtVLpfvXx7YE482pFfRiO7vlCeuZTvr0ebv9YXr2Z4dde6rvouLAzg6RZfiZe2Vvr9zurJW2zFGgs/6pne0gxY6ACvr9wdL2UK2hIQC0UzZFNCZkA9OhKTK1knaWvBPl2k+CE+0l9Pv8CmBKXPyKAz3psCa8GotNuWITeZQBeQlkf2SyHn7sDPiMYKed9D22/K1lsB7TfrQ2V6y2FLuotdpEhwz8VGYj1KHYaFodYCPaihvsKDx8pwraL7msJdb/DxaN8B6IHkSohtMXf3OSZCZf5deeJqP0cK48LuNYm43Uj0QCBsyHhK+c837+DhFJT3kXWItsIRJeOaeSgZVBrGfQK2kXj1+NKidtIWxeMFx0n6CzDh4w60Cp1br6Ggc03hjXUXJQ7sY1uH/+Zo9cU4klcpA9aNCWwuEm+Nt57p2q47MDyo7O5walFY+fr9j/3KqVEtBSRA5tfB7xvJya8I7Wptu5Xqmhvf40J8YclSVvI73i2OlhphlHLW3o6fLu2E6rfgklRq/Yd8XWLwC63sTAf44zppJg1rlailWtewHFJ0Mo1BpOqIdCMbOVhLVOtf9Hgo0pP60rynM0s2Cdrp9UfQmKCckEMw9DeCcA8JRaUobShZVKXFKaCWKvA8QVNKoIxXWGxyEVkpt+ZW4FPhmVOM123oMfRs8e/Z1sUmO0qyywVIAR7PUQhpqdz1pLHqBSvxUuJo+8g5XgYExrXvpZHiNeW8I0RdyXFSNQ+DQk8rEsoVKoBonGaHetbx7YWUbocs/11m1LCv73UPPfjZJetzwBFrINQ9q7qF9vd8hmvCxQ3yuMx4r6tSzywdwpmltUkE9XTlw06wEYh85d+a7QQz+IKpyVC14pf+C3LkesOHkVnIyzGNyh3GHSpUfKOBWuWX/qMB2KCijj87lrDRFEIWYKEi5c5XXRihGGZKFopxSXdqPue73v+
 IoGO4Z8T
 oyU8ooI0aVGmZYDPmtRu9bOZA4istjXNTk6MBJm1Ofh5UtdlhoMS1RsZ70XSSEe6zf0NCwE9uQUJ7L26FfeWqq+yWMr+oa90wuKwK2kcfH+z3AfH2jZe3hm1MHG18+N7JlKwLxwhyaF9+M8s3rTm5tDiUG7jin5WbHgFcS1syaHIvnS54jXnN8787h7OGT7779j6tSupEUd82XNM6biadrIrW3c2zQNOSlwp76acHugPCGMCmC4M0RV6dh3b+8QGJDy+YgUH579CDYQoNttV7PjzDnRweOlAumML3Jc2MlL7bVp2reVwP5kk6MrRieU1kTNxcXMOy9xniLMwwg5+M/UtMdD3yKTFG9wRw6NR9NNXb3yaMoI1Odp5exbOeh1kvs3yvyW7NcY066brG0RoqMIDuz0SdhY426R/s/ydNkYsvYj7Y9twMzc7CJe/AV78mztgXGX9qzqM/oFPlmJy1zNeoPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20251029]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Laight/lib-mul_u64_u64_div_u64-rename-parameter-c-to-d/20251030-025633
base:   next-20251029
patch link:    https://lore.kernel.org/r/20251029173828.3682-7-david.laight.linux%40gmail.com
patch subject: [PATCH v4 next 6/9] lib: test_mul_u64_u64_div_u64: Test both generic and arch versions
config: i386-randconfig-052-20251102 (https://download.01.org/0day-ci/archive/20251102/202511020341.TEhkaR65-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251102/202511020341.TEhkaR65-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511020341.TEhkaR65-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/math/test_mul_u64_u64_div_u64.c:142:9: warning: "__div64_32" redefined
     142 | #define __div64_32 __div64_32
         |         ^~~~~~~~~~
   In file included from include/linux/math.h:6,
                    from include/linux/math64.h:6,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:13,
                    from lib/math/test_mul_u64_u64_div_u64.c:9:
   arch/x86/include/asm/div64.h:78:9: note: this is the location of the previous definition
      78 | #define __div64_32
         |         ^~~~~~~~~~


vim +/__div64_32 +142 lib/math/test_mul_u64_u64_div_u64.c

   140	
   141	/* Compile the generic mul_u64_add_u64_div_u64() code */
 > 142	#define __div64_32 __div64_32
   143	#define div_s64_rem div_s64_rem
   144	#define div64_u64_rem div64_u64_rem
   145	#define div64_u64 div64_u64
   146	#define div64_s64 div64_s64
   147	#define iter_div_u64_rem iter_div_u64_rem
   148	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

