Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7982E6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B4F6B0088; Mon, 22 Dec 2025 20:41:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208F06B0089; Mon, 22 Dec 2025 20:41:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115F66B008A; Mon, 22 Dec 2025 20:41:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F22166B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:41:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 905EBB9803
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:41:00 +0000 (UTC)
X-FDA: 84249032280.22.04FB9D5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf18.hostedemail.com (Postfix) with ESMTP id C5FBE1C0003
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:40:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lXGcddiG;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766454058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RFRh+wvD+Lc39oHsvnn+Lo9YDyd9nHvG3BTp0xqQdFw=;
	b=TjcDsht67DKCIJF4fJSa7UIM6Ug4GR4kfjikOfhK6MvKmmpuPXu5NcYny29vQs4aPuNcz8
	jTgEtM/jSIHa40McQUCmQdBFkvqhAuXnSaxSyi2r82kdpH1eg01dCk5MS9ud23pu4n/G6h
	yD2hDP008DcZfoMU1y/fugHU4PzflVw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766454058; a=rsa-sha256;
	cv=none;
	b=EypxoCeAd4WhjVNUB8I1poNkdpsDujjgHkjugcufDXR0rWfD9mITrCb+xnSYrbzhGB6bPx
	YvKGeyrdOtxBcUnr55JH/sJ4O9NF1NYQXyVn6eVVljMd7jd6cxjudkawvmsFfenjj8CUND
	CLVLGSTAkovI7zProsmVIoAUD9Uufnk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lXGcddiG;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766454058; x=1797990058;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p8QndN5AyrEGYCocKeThKwfhP7p3sqHksByq85sFU24=;
  b=lXGcddiGxBFjvASm2m64or1zHaEK+jlYnN57j95LBAeaBEHp4bvw5Yos
   hkl7NRyQTTRz53J1YTbfw3iTk2/Cbpu3TfCdTjAhbAnPTRuvR5vwkYw6F
   u+NBd0RPIObbPY+4b+aEN6FEq0hysj8Ze1BemKnYV0lZin7Y5cpI3hJNr
   yq/wQ+0ORaLCxOlZBXaHNg0AFo5q3Jk/zTV3r33gZeSPdkdAKpBlXSk62
   zHGEwfGzU1TtmYINjUQjHFSoiJNEyLeYvTlK+dDEqf7P6kgM/yTeXTwR5
   RC+LWITUSQPfKksNyLBKIgECYIUrPfhmwy+QyxSbuxKB6C9pduGWvv7+u
   Q==;
X-CSE-ConnectionGUID: 7siLyYbDRgWGiJ0BcyArBw==
X-CSE-MsgGUID: Br+7KSzzTTCOqx9fIrFT7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="90966473"
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="90966473"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 17:40:56 -0800
X-CSE-ConnectionGUID: HH3KO3ruSFaqe8T5HyubLA==
X-CSE-MsgGUID: zy40TVviR8+wEyDh/5xXGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="199966668"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 22 Dec 2025 17:40:50 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXrOK-000000001Ij-25Ic;
	Tue, 23 Dec 2025 01:40:48 +0000
Date: Tue, 23 Dec 2025 09:40:39 +0800
From: kernel test robot <lkp@intel.com>
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org,
	vbabka@suse.cz
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	andreyknvl@gmail.com, cl@gentwo.org, dvyukov@google.com,
	glider@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
	mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com,
	roman.gushchin@linux.dev, ryabinin.a.a@gmail.com,
	shakeel.butt@linux.dev, surenb@google.com,
	vincenzo.frascino@arm.com, yeoreum.yun@arm.com,
	harry.yoo@oracle.com, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, hao.li@linux.dev
Subject: Re: [PATCH V4 7/8] mm/slab: save memory by allocating slabobj_ext
 array from leftover
Message-ID: <202512231042.EEBUajQY-lkp@intel.com>
References: <20251222110843.980347-8-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251222110843.980347-8-harry.yoo@oracle.com>
X-Stat-Signature: qg4yntgpk9694gki5c3zgr14ryegk3gi
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5FBE1C0003
X-Rspam-User: 
X-HE-Tag: 1766454057-32225
X-HE-Meta: U2FsdGVkX18VZBbXHBmPTI2NIbxhFJ7UKL2J+WsBmocz4keqEbHVg4U/3dCC/0t/8RAWWicydOTRnBYI3Nrm4bbt59byFAIOychang7y3h16UUNhQP555W7tL4uzm0kxXzgizODf0wB44m0xs04Ecc3AvArl9H7nDpLDBKaLGWe5LIUOWzjFiO0hsQOXnmqSj4dImqTt1HlqJ1NywHjssNw2G/Fv56MC1OlE9exh1hrrTb3iPFAb0OesdOsBd2nrbpuYjkgTTsadBdJWKq9/Fw24nXTl6JgRrs4upGYmKFjcIZAp/rswzmLhYGNq3v5s4zGxYt/KZXUg/12iC2GGGi00idhu7hvqaokzM8v0N0WwVSHjr0lCiExqaefjCPoxXHMIdeSCxvqElNozIenP8WFppdGgwiKw8YG8/3kIxJk417uCMndFvNFGVa9P3jLrOUYhHTkMF0CQkD1lVJkafbMMeXNUkVTjRLJsEadRYYSaD5yTihVb0qJn6zpthlbnUvBBp4wsAT2NKJvvJyERgeCpLj2oYca4Y37nzBDd4V8Ncfh7P1TilloXO3fg0UZeU4TCSW4yhFVWvC/lSw6+pYyyscOhH8nvlATtf0yxar1FZ6PiunX7vP5jP/6+eFs+ilhIrV9F7fB84H/OmGCE5FrZlEzlw2UHGKBtP8fly1oywVYnYiouLDcCujP2GT1kArLV3/SkzISwxW1bexOzvh2KQflmNCMb58RvAEITq8GExit+KEp5ItTXx0AT5cB55GnyHwv5Ze1vELODfUTfyUD7Zs0epH9vBr/quqiGIk8rTi48BeMAtrhcyMQTAtUUPROrmxCLXBV3mRbIyu4K+LzT6u4U3/3JunsAedsI4Tg9D/t6fGqo1ADuF18Jdf+ZNURGHPhKq4wJFOPa2xtwN8cqkCnxh/tJHiTu1dIlWTCcLv5Zz7a4FMu/q2/ew0SEbFIZG31JRmVJLBzzRP/
 dnG2dR2p
 xmRIEWUyimJ+pE28QMnSOvge2nnOAUc8cLc3W4rZBQph8fLbQ0hu5v5c0Sh+tlMehy26XeImm2PtBh7w13EF/v+qkda8LxDXYnB3La371JMXHbY0B2Lflb5YVqivBNjd0dB2gP+9fUR6XDE705A47Cn+shauRtItUwU/JFcs8QTIUnQtmGbI6zJ3X3ahcTzQjVhquKZLSUa+DdKdtA2Bj6jafhFDrATQmUzmg+4urOcxfE6oslekFEiYQp3DKdWlyDN/bIpFx2cF5AtpYoyi0ssd2osVh6cpHE0/VnwAjGotlUfPvb/P8o7IbvTxfC3fDhbf0nX19776J5q9q04UuJLblMsFsyQ5UdPk2HBeGP7rqu9t95FJIIvw+UQREluZbRbtlvXIdjV+ApMJIUNaKzeABIEK8RkLst+ttl9GvRlmAKUnjlFrY2n5FgNpg3SXL2LRl57wdZWhUCtvSoe7fFrq5fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Harry-Yoo/mm-slab-use-unsigned-long-for-orig_size-to-ensure-proper-metadata-align/20251222-191144
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251222110843.980347-8-harry.yoo%40oracle.com
patch subject: [PATCH V4 7/8] mm/slab: save memory by allocating slabobj_ext array from leftover
config: x86_64-buildonly-randconfig-001-20251223 (https://download.01.org/0day-ci/archive/20251223/202512231042.EEBUajQY-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251223/202512231042.EEBUajQY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512231042.EEBUajQY-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/slub.c:2140:33: error: passing 'union codetag_ref' to parameter of incompatible type 'union codetag_ref *'; take the address with &
    2140 |                 if (unlikely(is_codetag_empty(ext->ref))) {
         |                                               ^~~~~~~~
         |                                               &
   include/linux/compiler.h:47:41: note: expanded from macro 'unlikely'
      47 | #  define unlikely(x)   (__branch_check__(x, 0, __builtin_constant_p(x)))
         |                                           ^
   include/linux/compiler.h:32:34: note: expanded from macro '__branch_check__'
      32 |                         ______r = __builtin_expect(!!(x), expect);      \
         |                                                       ^
   include/linux/alloc_tag.h:52:56: note: passing argument to parameter 'ref' here
      52 | static inline bool is_codetag_empty(union codetag_ref *ref)
         |                                                        ^
   mm/slub.c:2140:33: error: passing 'union codetag_ref' to parameter of incompatible type 'union codetag_ref *'; take the address with &
    2140 |                 if (unlikely(is_codetag_empty(ext->ref))) {
         |                                               ^~~~~~~~
         |                                               &
   include/linux/compiler.h:47:68: note: expanded from macro 'unlikely'
      47 | #  define unlikely(x)   (__branch_check__(x, 0, __builtin_constant_p(x)))
         |                                                                      ^
   include/linux/compiler.h:34:19: note: expanded from macro '__branch_check__'
      34 |                                              expect, is_constant);      \
         |                                                      ^~~~~~~~~~~
   include/linux/alloc_tag.h:52:56: note: passing argument to parameter 'ref' here
      52 | static inline bool is_codetag_empty(union codetag_ref *ref)
         |                                                        ^
>> mm/slub.c:2326:16: error: use of undeclared identifier 'MEMCG_DATA_OBJEXTS'
    2326 |                         obj_exts |= MEMCG_DATA_OBJEXTS;
         |                                     ^
   3 errors generated.


vim +/MEMCG_DATA_OBJEXTS +2326 mm/slub.c

  2302	
  2303	/*
  2304	 * Try to allocate slabobj_ext array from unused space.
  2305	 * This function must be called on a freshly allocated slab to prevent
  2306	 * concurrency problems.
  2307	 */
  2308	static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
  2309	{
  2310		void *addr;
  2311		unsigned long obj_exts;
  2312	
  2313		if (!need_slab_obj_exts(s))
  2314			return;
  2315	
  2316		if (obj_exts_fit_within_slab_leftover(s, slab)) {
  2317			addr = slab_address(slab) + obj_exts_offset_in_slab(s, slab);
  2318			addr = kasan_reset_tag(addr);
  2319			obj_exts = (unsigned long)addr;
  2320	
  2321			get_slab_obj_exts(obj_exts);
  2322			memset(addr, 0, obj_exts_size_in_slab(slab));
  2323			put_slab_obj_exts(obj_exts);
  2324	
  2325			if (IS_ENABLED(CONFIG_MEMCG))
> 2326				obj_exts |= MEMCG_DATA_OBJEXTS;
  2327			slab->obj_exts = obj_exts;
  2328			slab_set_stride(slab, sizeof(struct slabobj_ext));
  2329		}
  2330	}
  2331	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

