Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 660ECE67808
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 23:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C076B0005; Mon, 22 Dec 2025 18:37:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9904B6B0089; Mon, 22 Dec 2025 18:37:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89BFC6B008A; Mon, 22 Dec 2025 18:37:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 742B36B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 18:37:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CFD3C0995
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:37:55 +0000 (UTC)
X-FDA: 84248722110.01.FF80B9C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf08.hostedemail.com (Postfix) with ESMTP id C9BAF160006
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:37:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YmZw4dXh;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766446673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxklbWQkP9ydrv6toctHx6DE8kD/as112wt70h0E6DI=;
	b=j+/g/Su9vEicGzmO9kuNKceGjojkdIS/3hlGrqzuLJBE1GcrYCun+i3m1TVXeOkFkiDqHH
	z3zqaQ+9OsBJQGHRZGOS8gGGeFuw99kQa/+lmLTmy8tZDqYiDxLFGgfBL5lFHe3SlxIP4a
	n676BF7TEDrVyZRkBm24rSeQqEtuXR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766446673; a=rsa-sha256;
	cv=none;
	b=DWQ7sd3ezvjZqUxl3ywGhIODw1stzUg3oxg2kib1xOHwiyNsYHoZ3YCVc1DnGWltSbSDlm
	ag1lhTgF1LINJrZhF9LbbtWr8iUyMJGTqVkJ+2EjgspBLkXoIfgmAhHMzRgCZPLZhwc9c7
	m+z7HpefkmzgPRokOTGfTIH9NttaKKw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YmZw4dXh;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766446673; x=1797982673;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FnuE/O9HxUgy9+sc5bMXa0KAmbMJC+TFTgxYzciborU=;
  b=YmZw4dXhtmbKzpDfEh38EYrMqiqMkpklMDxDXR2lUZ1bLzf0fpH6kUTa
   JXeWy/G4OfJx5KTdRuFkeBmgGnJgUGjXSWMFqbf60OTuKZooI9Aszc8Wm
   n7N19Dqvx6m4g/L2tRi1WC/24L5XJyffXHvkwIQpTdRakbrXey7qmjLSc
   cvKrmMinuxZzDd7e//Xhv4Nkei73JrpWTWiDVo+dYMHH/TKwm0d2avD8R
   z5qSUHLMU5+urpgWptRkzpK9/5WkcMxWnObu7v7uVVu2V7KGHMN13FG9j
   SK095ClzVVTGO0BO0CYLpV7iEz4ZP7WqzUei3ZVhFqQLm+upNX+UN/1+K
   A==;
X-CSE-ConnectionGUID: cXmV9tRxShaKPTMO05KQRA==
X-CSE-MsgGUID: r+KJaBK9QOy3gffWNZaKjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="68285681"
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="68285681"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 15:37:50 -0800
X-CSE-ConnectionGUID: /7rmrmvcQjykLlDXEdLJnQ==
X-CSE-MsgGUID: KqFvZ5MLSmaJFSgmmnDnWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="199945998"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 22 Dec 2025 15:37:43 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXpTB-000000001Dx-40xf;
	Mon, 22 Dec 2025 23:37:41 +0000
Date: Tue, 23 Dec 2025 07:36:46 +0800
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
Subject: Re: [PATCH V4 4/8] mm/slab: abstract slabobj_ext access via new
 slab_obj_ext() helper
Message-ID: <202512230850.bBE4pAZ5-lkp@intel.com>
References: <20251222110843.980347-5-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251222110843.980347-5-harry.yoo@oracle.com>
X-Stat-Signature: x3a97kbzbnfz3qr6ch6yd318jfukqjcp
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C9BAF160006
X-Rspam-User: 
X-HE-Tag: 1766446672-53811
X-HE-Meta: U2FsdGVkX19cTXHFB/Y9yc/DH3qsMe4JxdfavBgn867ohrE+3CnFqeInncL6YvVHuKP5v78/V0RZcAezZT0wvaF/VIkbJSyoZZ6KchP8Olq1z+JB60ozvPMYCnXzScEAGZWk8k8MpGzMb6xwbbWHRnXiJBHqbJt5lMRw5ryfrSNsNahMjZiZKjMFAc+kMhc8w/a50adwR6rSMIBCUxh/AgGMboOsWtPxkIVXxWMPjeioiRbY3TFgNNrmnlmENZM1ln/q5LFuijIzdZ572RMY7ZFBMgcCwsp1MkTRhiYjd6HRZc0v6+Do5FlFcR7HtBSNpOz31lOO2tTI+qaG4HRqKL+Vzp2oPay3R6+lfvjAbY01zMVM/P3xKKm37TOffXmbeQUXFtzHMvILlGmRzN+MlILzlVX4C5vGiGsYNKq3Xm82VlRx6JWNnh/tNG04SOKLUbglDLHrRYenkRkdFeBU8FloJsjGkXfECer2aZZEjDEzg73d69WGQ5jvWfVRfXAXmWYb1AF2XAI71pdS9CLujYeNkwUH/+1//Be5WUxbwBGYNQxq0/tSFU60m8ZvuUrQS0xH+wKexapX9eSvhg8GCKOqHY2DetYoQkWjJ0Cq9UMYNphKYbBs/ZmsnjRLOVeawgIhsq1j95WR4X0bBoBCLCZQVy7efsziuj4ls3iaWg80bQs8hrgvsS+NtlsoNJ/M5gGmtQHA528CMbxpO4EC3QTRkHYtWmImstfbaeTCwWy7v9dUPFK3gq7HmzxX8RvQhmWIRNxHP3Uwdnz5Mk7sBspGkGFDSNr/2s4JqkFMX9CjB8SbNbx8SryumiyvIMkmAuGA7Y0IVDRq7vjIJjuZMep6dU54n2MZo+AodSAN/MqPetdm9roopv5IK4VLp+yOl69Sro7Vcq9D8/TjTERVPpqqLDvNgwHA33MkK1b/czK1bN9rKIvQp2ytenCPW0R8HxvRZYwt+7ma2jZWjfF
 Jx1AH4Yd
 x4QDkluzNMtl/JfyQOVAiiB3MTLisYWzPVNLmyawx/ht7Apv8xnshuzpOgBW2vBxnb5qz5rsViKw0P9ondf+N8jzuMC4o7/cOBOCDWidB6pfH9zF0/AUQVajO5dzcYIzk2fuaJq5yJ1GrBA994uQRtOAsUpyjWJsulhfbXwGVMora7+daUQV8IjbCt14YptJiM2kjLPbsLRUK6GRgisWTVl3OwaayVSVIXTUmCzPcDWuXg3QJ9bAeF48Sy8OGTvi/KfIoDfE7cKd9OUhTRJCr8IaBk6mq7BSdCaiXo/TjPan1fEUmygnnb0gFJTFMaOyTBO+JRpdtDvxO/OU8MOJfUHloYuCAoZ7XNnza5CFzC+idoaJx4gII5gBzYh2mPb2KWf2MG1BWHLJbXGCktM0BHsgREsHQO2TQb/T7rSaD8j9ht95pqnoJv0DYubVqD7xlji/nrX3MxV45e/rsvoOAdfjY3g==
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
patch link:    https://lore.kernel.org/r/20251222110843.980347-5-harry.yoo%40oracle.com
patch subject: [PATCH V4 4/8] mm/slab: abstract slabobj_ext access via new slab_obj_ext() helper
config: x86_64-buildonly-randconfig-001-20251223 (https://download.01.org/0day-ci/archive/20251223/202512230850.bBE4pAZ5-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251223/202512230850.bBE4pAZ5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512230850.bBE4pAZ5-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/slub.c:2056:33: error: passing 'union codetag_ref' to parameter of incompatible type 'union codetag_ref *'; take the address with &
    2056 |                 if (unlikely(is_codetag_empty(ext->ref)))
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
>> mm/slub.c:2056:33: error: passing 'union codetag_ref' to parameter of incompatible type 'union codetag_ref *'; take the address with &
    2056 |                 if (unlikely(is_codetag_empty(ext->ref)))
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
   2 errors generated.


vim +2056 mm/slub.c

  2042	
  2043	static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
  2044	{
  2045		unsigned long slab_exts;
  2046		struct slab *obj_exts_slab;
  2047	
  2048		obj_exts_slab = virt_to_slab(obj_exts);
  2049		slab_exts = slab_obj_exts(obj_exts_slab);
  2050		if (slab_exts) {
  2051			unsigned int offs = obj_to_index(obj_exts_slab->slab_cache,
  2052							 obj_exts_slab, obj_exts);
  2053			struct slabobj_ext *ext = slab_obj_ext(obj_exts_slab,
  2054							       slab_exts, offs);
  2055	
> 2056			if (unlikely(is_codetag_empty(ext->ref)))
  2057				return;
  2058	
  2059			/* codetag should be NULL here */
  2060			WARN_ON(ext->ref.ct);
  2061			set_codetag_empty(&ext->ref);
  2062		}
  2063	}
  2064	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

