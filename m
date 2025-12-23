Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C84B7E6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 00:09:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639286B0005; Mon, 22 Dec 2025 19:09:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC936B0089; Mon, 22 Dec 2025 19:09:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8E06B008A; Mon, 22 Dec 2025 19:09:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3804D6B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 19:09:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94540160184
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:09:55 +0000 (UTC)
X-FDA: 84248802750.23.3207D33
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf10.hostedemail.com (Postfix) with ESMTP id C8C43C0013
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:09:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="DG44K/oM";
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766448593; a=rsa-sha256;
	cv=none;
	b=dCY6WRajHS+dxzP/DWntwgrAT8G4YUH7KdfgDviCaVpG0/czvZPcO/L2aN6ZK+zqiuRnCN
	e8mQA+yBnmzMl9GbgcDMa8FvhesmDs0Xi+vh+LupIwQ/avv4Nu/QwV0H8RSPAGvr+0cPGo
	cwY2CBKDJm3hAX9ASuKjRFREfuFkraw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="DG44K/oM";
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766448593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFSHPt5PhzEBaMh9wM6klcjIsrE8YqFknDQ4Kj89pZU=;
	b=Hw0MVHARyZ0iTVm0XY/+sQPXegXfBBFZgFv4F1RSZH2BIMAnpjAQcRAuCZObtuH5nFWUNE
	lohrrZU34I46BYbUYL3zJIcODg93DmhBWl2tQG81fRAmZ3+EkWrSst8Mmx43U7mnUipC6w
	VXxlErOfpvBJNjRClFa3Wz9zAH7maak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766448592; x=1797984592;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=scb8dq1HBfysrB12FXHWH+apjzmHxbCBklwomg04vvQ=;
  b=DG44K/oMR8Z8wdEhz+gDrX46bKm5razEVcXQousNZ1xg5f9w9OtIWk26
   WlU3/rEEG1lw7KzTWP8MugsiUwOH0ZgI0nbAlcFkPqzGKaQPpi6bkv1oN
   iJYEn8LSfju6p7w6kTavyQbAWrn08EAPZYD5oKTngUcl3pIEYXhF9erbJ
   gHW8RFc4AjT4GEYnkF9BOAd0pcZHFukA8qwrz594hl8PCfTZ2VgYWKpF4
   oKtcMZ5zl43FAc3pBFMm/O2XMuilPGRH6dYNz9zm99TLeCOGEe1wrDmou
   axzrN43jwGP+cSVmPcfacRkdu1TfB59ynNhAncP3j7QEs2dH3+1PrXGkQ
   w==;
X-CSE-ConnectionGUID: TcpQ8wSWQ2aWMhEtQYmCKg==
X-CSE-MsgGUID: ded9Fj59QSGwasY3tYOv7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="68058073"
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="68058073"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 16:09:51 -0800
X-CSE-ConnectionGUID: zNGOi2JSQ5GX20sFnuD9QQ==
X-CSE-MsgGUID: 6sBPvKYiRGuXkiAxOW5low==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="199634082"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 22 Dec 2025 16:09:45 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXpyB-000000001FR-0Qwm;
	Tue, 23 Dec 2025 00:09:43 +0000
Date: Tue, 23 Dec 2025 08:08:54 +0800
From: kernel test robot <lkp@intel.com>
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org,
	vbabka@suse.cz
Cc: oe-kbuild-all@lists.linux.dev, andreyknvl@gmail.com, cl@gentwo.org,
	dvyukov@google.com, glider@google.com, hannes@cmpxchg.org,
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
	rientjes@google.com, roman.gushchin@linux.dev,
	ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
	vincenzo.frascino@arm.com, yeoreum.yun@arm.com,
	harry.yoo@oracle.com, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, hao.li@linux.dev
Subject: Re: [PATCH V4 4/8] mm/slab: abstract slabobj_ext access via new
 slab_obj_ext() helper
Message-ID: <202512230727.ktAJv4eA-lkp@intel.com>
References: <20251222110843.980347-5-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251222110843.980347-5-harry.yoo@oracle.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C8C43C0013
X-Rspamd-Server: rspam04
X-Stat-Signature: u3fyfyz1km9fi63whisqx8sexuraojzk
X-HE-Tag: 1766448592-21749
X-HE-Meta: U2FsdGVkX1+Wzjq8u9j8FBWsuawe2fe/ctehQ6grNa6nPhkPiZqUs8AoAaodtIZ8/BXGuuc9O03yXIGeqGLo2IvQ6HqkXtzSE9eGXHlGK+thA4i4YQjSbSjzGOwcq0qJZyCGO7xETy2EY5eqqoVPpbU17kDF9qicJaP4wqVDLifvn42q1W6jCnXJa5Hml5KkJY0Xhf4UVxQl5BDFuBKm6nPHLUfFK1iaSxtPCUT7s83GV5ktI8SMgZg4pEi62zxmJTlDE0aIJbDcYr1NXFQ4W06Vczv8C5ljtb5qPidGbuNvuzk7s/BX2KJAe6smvJo0l016MlEtYB0t1bG1Stokc1TTixOD5d6jV0IkRF1pDnx5yWhps44jFjrBMtqCE4rAkV+tWjFl4qic2didfq+0A0tNvQyVJscks15wIxo6KdI8GOZYN45eZIiFLbmHEYHLAzw78Od5xuV++fRuu4oxcQg1A1YHKsKDHASRVwTNGOyb3tCpNVRWwWQfVbWwmD7Q7qZN0X7HtdhriTURFMTHJ/P0J1jlgIfx6jcsk5+5YHWM0k7ap2vbtTBrc8mjuBrYszOD3tgae4GSvQWNFdQVa12qyXctw3LUrrFamE6HUgOyvkuRMhd1xvH9/q8blTEpo6uZ9jQctV3Pv9Hjrw66XleV0u633fZfhLHCJ6s9mnHYWpSkfphQQVq0XFvAeBtMjQXNCYJXcQIW2v0SWv6nSIkgNwz72rs/Z/MGa/QBxMxbOtR3owFdYzzCCqGXXtlwtBgTdQtY06aFkuVhe1HwBCMYlMXLEMlt1cpFB/pgX5sKtCftf0eiEwHan7lzitafQ/anNOOCmzg2MBsSj2pogwzq27necO/EDHdw8B+TPMglgpeW794OMucihuGuf338FHwz1EMT1VsDcHr9nNFAXc43Y2gLg0CqXET2Df65VmoieurtmX9SL3ULjKA+s6PRmLcVGUdMebGMTbxfpL0
 rShevceK
 g0cpcA7XPUXXaYEnyFEi759GV7Mn25SZ2Y02mXuBlBcFk88Oe2AdU6G8/5Kgd3QDT82O7hmcCnsp+w0wI7cZhJH+IICj3dR+MKWVQjefgkxC/3Z1uXZNP7Ovj5DW2t9WyiL4I7/tfvNEj2P4Yege+PRNuAh6Nxds8LCdwLEO1ftC8iLqJZGg2slPfueNCBhEuGD/YiN6+L2miOTE+kBgsmXZMu45+/g3drTNIZM7Ow2FqEt2NdTuWhhUeuqp6g/VqY5cMtS5fNt18kVbD/4EXwoumGrK83lcb1V8ob8kSzK2fH5UFB0MdNYJNNLV1exr/OzkQufKSOFel7IoWDDqVLRi73iOUAD+KeMgveO1aRqp2wlO3wpFOYVh2o6PATVGvK4Zdsn7qVUWjqZ5dKC7t38pw/kACDZXoVQu5TjxQOA1r2bufAJn1h2Q8e1DNcT8yZD+k2t99GiFsxrQWEnu0EIVSTiTjGjqE0/KsqNSJi9VD3WMPsdNUS9jSrw==
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
config: parisc-randconfig-002-20251223 (https://download.01.org/0day-ci/archive/20251223/202512230727.ktAJv4eA-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251223/202512230727.ktAJv4eA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512230727.ktAJv4eA-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:5,
                    from arch/parisc/include/asm/bug.h:97,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:6,
                    from mm/slub.c:13:
   mm/slub.c: In function 'mark_objexts_empty':
>> mm/slub.c:2056:36: error: incompatible type for argument 1 of 'is_codetag_empty'
      if (unlikely(is_codetag_empty(ext->ref)))
                                    ~~~^~~~~
   include/linux/compiler.h:77:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   In file included from include/linux/workqueue.h:9,
                    from include/linux/mm_types.h:19,
                    from include/linux/mmzone.h:22,
                    from include/linux/gfp.h:7,
                    from include/linux/mm.h:7,
                    from mm/slub.c:13:
   include/linux/alloc_tag.h:52:56: note: expected 'union codetag_ref *' but argument is of type 'union codetag_ref'
    static inline bool is_codetag_empty(union codetag_ref *ref)
                                        ~~~~~~~~~~~~~~~~~~~^~~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for CAN_DEV
   Depends on [n]: NETDEVICES [=n] && CAN [=y]
   Selected by [y]:
   - CAN [=y] && NET [=y]


vim +/is_codetag_empty +2056 mm/slub.c

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

