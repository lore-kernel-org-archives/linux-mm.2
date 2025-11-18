Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6547ECEBF61
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 00:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C9908E0015; Mon, 17 Nov 2025 19:54:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A108E0002; Mon, 17 Nov 2025 19:54:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868AB8E0015; Mon, 17 Nov 2025 19:54:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7046D8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:54:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14E0613A8BC
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:54:18 +0000 (UTC)
X-FDA: 84121906596.18.B479FC4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1B41080017
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:54:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kwvdGA6x;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763427256; a=rsa-sha256;
	cv=none;
	b=6PP51qw47o6OrPxmHnnKuw6CkhIHFzGFwlt0u0+7Ej0dyF5aIV2ibRFfROf54p8eZpf+OG
	w1DIonuG+hTQ0jA2wNi4X3bFjQyzDOqoXTBITkx8TQ1ppp63/ZIMxUWxK7LX6cwnEzyvSV
	NtPHxrkt7x5a69HeBsMCV+hnH0F4lVI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kwvdGA6x;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763427256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oovfNkjmAihVdDYgRDYf/o1nr/AU/sYXFeJRDw0+kto=;
	b=em+vx5nbvhIlTCBjlR3cGKvfW0O9wuAwo6KfxAIKhRpn5bVlfVGmBe5cOeNnJ9XMVSDh2g
	wu1mniiX5cOJI+gaLqO9LiCgExfJGE/bxhmL4Aeeq/4iPUQJ723JnIRP3fzd5pclYLet2r
	Oa9nJbr8Tz5O5kjuAqzkpbs9B4Y+Kq4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763427255; x=1794963255;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eGWvO7D5EM7ECyIrHX4ktygWBzTzotYEXHtgcB10f5k=;
  b=kwvdGA6xAeSAY72ZWueYKqE7hJCLGevQWkU6xqZ0Xk03q9ZF9WCheIj7
   NiLb7H9eYTbuMLBqAktUBMPF4+RIBgrVgNnqVVz5rYT/Xi7gRtQ4KzZwC
   sylsPoWAubVmO/AqCHO5QG/SmqWuBIhHLMGDuYFhmCyV04L1G5bXRlGyP
   4vZuirhDpk5yUCX0qYrmUua04i4ICACq/3FA1lqfp4whM/wHR/sWg3vPe
   YhQpozEDw2csJ/3xnSScx8iFtKthdfi58aO2XULi8OYZwJvoPlj5ARhuj
   k1OpgJ5Pnm5fvok98zljUMG+VK283t1objsGDWPV+jp1hQiQt5YAX8QnY
   Q==;
X-CSE-ConnectionGUID: xb5xVnhYSdqzJz5y11r3yA==
X-CSE-MsgGUID: kRWBVyL9RlC36BNrnHpsPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65470804"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="65470804"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 16:54:14 -0800
X-CSE-ConnectionGUID: OfzuSc/sTqagsxQEJnRKhA==
X-CSE-MsgGUID: ZRBnWoAVTR28HjN0L0qnsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="213994704"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 17 Nov 2025 16:54:10 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vL9yy-0001CF-2d;
	Tue, 18 Nov 2025 00:54:08 +0000
Date: Tue, 18 Nov 2025 08:53:58 +0800
From: kernel test robot <lkp@intel.com>
To: David Heidelberg via B4 Relay <devnull+david.ixit.cz@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
	David Heidelberg <david@ixit.cz>
Subject: Re: [PATCH] mm/vmalloc: warn only once when vmalloc detect invalid
 gfp flags
Message-ID: <202511180838.vEBLp7Hm-lkp@intel.com>
References: <20251118-only-one-vmalloc-v1-1-29f8eacb4605@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118-only-one-vmalloc-v1-1-29f8eacb4605@ixit.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1B41080017
X-Stat-Signature: 1jd98pxsbgcutmnke9esg7kp9zx8t9ad
X-HE-Tag: 1763427254-556314
X-HE-Meta: U2FsdGVkX18Qx1bhEKy7Ikr5OHnolASe41u+D1rXtj70/sBJKvc5coV8QhmNwBFZ1x34of4zy7roH/rOf/5Ch7n5KrkzHOMJr9TQIwYz2CwL+vNx/LS+NMd47XhIiCeh3XnWhzt3HBF6k4K5KWRDIY1hOr8muXvezjj9UDX4bo6WQoccM7Y8GuGrzeUvhaltbBHGGaWEbmB859r4BhlKUKWytBbMTbMg3v1RKs1blKoC4KPjV/sPMYY4oAbiB34DVe0JuoqQgwf1v43nS1ZPri/zZePzsB2wQqxMKtpJgxoCAjUjZD7EjgXu/KoP/YLs1igN4SvIWr3UUUafjcnZN/WPJ5T6XIiatl+3D7V/CLZO2m6QME8GkGKMWFhMwU7P4cexSq4m2DRN9PAXgpXkT11mMFQ1LqWcSfpjf8YBukTevBOuuqXOJJrvCj+3BIOYYmqlXN4dvcwTIL1d/ZfyQXXR8if/M3e57yVlPrrGK9yz7mIrG30hv0EZvy/x3IvTPMdgICp9jFHo90OQFeG2bwUgXke26MyB3NV/UuvUXgWYiNwM3eVJZgJmlU/QldXDLK/XUGWhtBemIP41tX8tGnymW/Og6lglHAWYMUc+uNj0FJWod2FLHBlECguBQQpCQ47WD6s2a138adbze2NsuUgspj++C5q6itBd+HtBwJDNmsP6D/kK/H3hjKMhF0BEIDkiZrR9piopWosuVR5RDNQn58gIbJjEi7an+FwkFZGGVW6ab40p3I+aPs+Bvn9SC3boekDbXCcEryeIls/5N15QcAO+yJoP/zdpEyjsDV/ZdvoSM/MPUXYVkdhv/AqQHW5ZiTuK+3L/CdS3CHSDjcvzAES2edj8DzctPcB0I4IUreblPn31JHCI1+5Tt2m75p8IscVKThFV8gLcvQ6X2LocBRi4x0p1oUxjGM0cEyRPS0eyq+1bejeJfOB3NduTssShAJ90H6R/GnbkR6Q
 b5VwB2x2
 JEOYRGDBh+NhC82EsLtpkDRrYQnasjNwJ8NVgfgJim/L8qIUWtxJ6qk4HeU5INYncmHeeT6sObdQdmnRnH/Aa2E5UK83YpAzOHbZk01ZwdAkMe1m8YfbEk2zEp+te0YU2FSeDjlbdu4kptVUfU4ZxUepln5qd5FuqzUlKBuNKaw/1XY0DaemZrq/lF00B3dzdxd5jV8TcRP4liaCXw5xWkDkTEhljkvpDjmlt97TZFxpDPQyLMD8pK7fv3eKauJhjHIyi+LEz4DHcyQR7WtN9uXYHrgp9rPEIuhF+e/9H6iaYcW0IU8vdvMGZvmxunQDWNYYzrC2rRGTxUBoY+EqEvSWGR2KWqwk/IrXEjCNOFYATMslQyLZsZ1TtsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

kernel test robot noticed the following build errors:

[auto build test ERROR on 0c1c7a6a83feaf2cf182c52983ffe330ffb50280]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Heidelberg-via-B4-Relay/mm-vmalloc-warn-only-once-when-vmalloc-detect-invalid-gfp-flags/20251118-080722
base:   0c1c7a6a83feaf2cf182c52983ffe330ffb50280
patch link:    https://lore.kernel.org/r/20251118-only-one-vmalloc-v1-1-29f8eacb4605%40ixit.cz
patch subject: [PATCH] mm/vmalloc: warn only once when vmalloc detect invalid gfp flags
config: alpha-allnoconfig (https://download.01.org/0day-ci/archive/20251118/202511180838.vEBLp7Hm-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251118/202511180838.vEBLp7Hm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511180838.vEBLp7Hm-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from arch/alpha/include/asm/bug.h:23,
                    from include/linux/bug.h:5,
                    from include/linux/alloc_tag.h:8,
                    from include/linux/vmalloc.h:5,
                    from mm/vmalloc.c:11:
   mm/vmalloc.c: In function 'vmalloc_fix_flags':
>> mm/vmalloc.c:3938:19: error: expected ')' before 'invalid_mask'
    3938 |                   invalid_mask, &invalid_mask, flags, &flags);
         |                   ^~~~~~~~~~~~
   include/asm-generic/bug.h:105:62: note: in definition of macro '__WARN_printf'
     105 |                 warn_slowpath_fmt(__FILE__, __LINE__, taint, arg);      \
         |                                                              ^~~
   include/linux/once_lite.h:31:25: note: in expansion of macro 'WARN'
      31 |                         func(__VA_ARGS__);                              \
         |                         ^~~~
   include/asm-generic/bug.h:159:9: note: in expansion of macro 'DO_ONCE_LITE_IF'
     159 |         DO_ONCE_LITE_IF(condition, WARN, 1, format)
         |         ^~~~~~~~~~~~~~~
   mm/vmalloc.c:3937:9: note: in expansion of macro 'WARN_ONCE'
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |         ^~~~~~~~~
   include/asm-generic/bug.h:105:34: note: to match this '('
     105 |                 warn_slowpath_fmt(__FILE__, __LINE__, taint, arg);      \
         |                                  ^
   include/asm-generic/bug.h:141:17: note: in expansion of macro '__WARN_printf'
     141 |                 __WARN_printf(TAINT_WARN, format);                      \
         |                 ^~~~~~~~~~~~~
   include/linux/once_lite.h:31:25: note: in expansion of macro 'WARN'
      31 |                         func(__VA_ARGS__);                              \
         |                         ^~~~
   include/asm-generic/bug.h:159:9: note: in expansion of macro 'DO_ONCE_LITE_IF'
     159 |         DO_ONCE_LITE_IF(condition, WARN, 1, format)
         |         ^~~~~~~~~~~~~~~
   mm/vmalloc.c:3937:9: note: in expansion of macro 'WARN_ONCE'
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |         ^~~~~~~~~
>> mm/vmalloc.c:3937:22: warning: format '%x' expects a matching 'unsigned int' argument [-Wformat=]
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/bug.h:105:62: note: in definition of macro '__WARN_printf'
     105 |                 warn_slowpath_fmt(__FILE__, __LINE__, taint, arg);      \
         |                                                              ^~~
   include/linux/once_lite.h:31:25: note: in expansion of macro 'WARN'
      31 |                         func(__VA_ARGS__);                              \
         |                         ^~~~
   include/asm-generic/bug.h:159:9: note: in expansion of macro 'DO_ONCE_LITE_IF'
     159 |         DO_ONCE_LITE_IF(condition, WARN, 1, format)
         |         ^~~~~~~~~~~~~~~
   mm/vmalloc.c:3937:9: note: in expansion of macro 'WARN_ONCE'
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |         ^~~~~~~~~
   mm/vmalloc.c:3937:41: note: format string is defined here
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |                                       ~~^
         |                                         |
         |                                         unsigned int
>> mm/vmalloc.c:3937:22: warning: format '%p' expects a matching 'void *' argument [-Wformat=]
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/bug.h:105:62: note: in definition of macro '__WARN_printf'
     105 |                 warn_slowpath_fmt(__FILE__, __LINE__, taint, arg);      \
         |                                                              ^~~
   include/linux/once_lite.h:31:25: note: in expansion of macro 'WARN'
      31 |                         func(__VA_ARGS__);                              \
         |                         ^~~~
   include/asm-generic/bug.h:159:9: note: in expansion of macro 'DO_ONCE_LITE_IF'
     159 |         DO_ONCE_LITE_IF(condition, WARN, 1, format)
         |         ^~~~~~~~~~~~~~~
   mm/vmalloc.c:3937:9: note: in expansion of macro 'WARN_ONCE'
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |         ^~~~~~~~~
   mm/vmalloc.c:3937:45: note: format string is defined here
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |                                            ~^
         |                                             |
         |                                             void *
>> mm/vmalloc.c:3937:22: warning: format '%x' expects a matching 'unsigned int' argument [-Wformat=]
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/bug.h:105:62: note: in definition of macro '__WARN_printf'
     105 |                 warn_slowpath_fmt(__FILE__, __LINE__, taint, arg);      \
         |                                                              ^~~
   include/linux/once_lite.h:31:25: note: in expansion of macro 'WARN'
      31 |                         func(__VA_ARGS__);                              \
         |                         ^~~~
   include/asm-generic/bug.h:159:9: note: in expansion of macro 'DO_ONCE_LITE_IF'
     159 |         DO_ONCE_LITE_IF(condition, WARN, 1, format)
         |         ^~~~~~~~~~~~~~~
   mm/vmalloc.c:3937:9: note: in expansion of macro 'WARN_ONCE'
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |         ^~~~~~~~~
   mm/vmalloc.c:3937:71: note: format string is defined here
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |                                                                     ~~^
         |                                                                       |
         |                                                                       unsigned int
>> mm/vmalloc.c:3937:22: warning: format '%p' expects a matching 'void *' argument [-Wformat=]
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/bug.h:105:62: note: in definition of macro '__WARN_printf'
     105 |                 warn_slowpath_fmt(__FILE__, __LINE__, taint, arg);      \
         |                                                              ^~~
   include/linux/once_lite.h:31:25: note: in expansion of macro 'WARN'
      31 |                         func(__VA_ARGS__);                              \
         |                         ^~~~
   include/asm-generic/bug.h:159:9: note: in expansion of macro 'DO_ONCE_LITE_IF'
     159 |         DO_ONCE_LITE_IF(condition, WARN, 1, format)
         |         ^~~~~~~~~~~~~~~
   mm/vmalloc.c:3937:9: note: in expansion of macro 'WARN_ONCE'
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |         ^~~~~~~~~
   mm/vmalloc.c:3937:75: note: format string is defined here
    3937 |         WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
         |                                                                          ~^
         |                                                                           |
         |                                                                           void *
>> mm/vmalloc.c:3934:15: warning: unused variable 'invalid_mask' [-Wunused-variable]
    3934 |         gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
         |               ^~~~~~~~~~~~


vim +3938 mm/vmalloc.c

^1da177e4c3f41 Linus Torvalds        2005-04-16  3921  
7179b225631532 Vishal Moola (Oracle  2025-11-12  3922) /*
7179b225631532 Vishal Moola (Oracle  2025-11-12  3923)  * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
7179b225631532 Vishal Moola (Oracle  2025-11-12  3924)  * This gfp lists all flags currently passed through vmalloc. Currently,
7179b225631532 Vishal Moola (Oracle  2025-11-12  3925)  * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
7179b225631532 Vishal Moola (Oracle  2025-11-12  3926)  * and BPF also use GFP_USER, which is GFP_KERNEL | __GFP_HARDWALL.
7179b225631532 Vishal Moola (Oracle  2025-11-12  3927)  */
7179b225631532 Vishal Moola (Oracle  2025-11-12  3928) #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
7179b225631532 Vishal Moola (Oracle  2025-11-12  3929) 				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
7179b225631532 Vishal Moola (Oracle  2025-11-12  3930) 				__GFP_HARDWALL)
7179b225631532 Vishal Moola (Oracle  2025-11-12  3931) 
7179b225631532 Vishal Moola (Oracle  2025-11-12  3932) static gfp_t vmalloc_fix_flags(gfp_t flags)
7179b225631532 Vishal Moola (Oracle  2025-11-12  3933) {
7179b225631532 Vishal Moola (Oracle  2025-11-12 @3934) 	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
7179b225631532 Vishal Moola (Oracle  2025-11-12  3935) 
7179b225631532 Vishal Moola (Oracle  2025-11-12  3936) 	flags &= GFP_VMALLOC_SUPPORTED;
bf791000a32caf David Heidelberg      2025-11-18 @3937  	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
7179b225631532 Vishal Moola (Oracle  2025-11-12 @3938) 		  invalid_mask, &invalid_mask, flags, &flags);
7179b225631532 Vishal Moola (Oracle  2025-11-12  3939) 	return flags;
7179b225631532 Vishal Moola (Oracle  2025-11-12  3940) }
7179b225631532 Vishal Moola (Oracle  2025-11-12  3941) 

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

