Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3438606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 17:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QYcGXX65
Received: by kanga.kvack.org (Postfix)
	id ECD756B0A8A; Wed, 25 Nov 2026 12:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7DE86B0A8B; Wed, 25 Nov 2026 12:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6C6A6B0A8C; Wed, 25 Nov 2026 12:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD5A16B0A8A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:16:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 324CA140FBF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:16:25 +0000 (UTC)
X-FDA: 85474295130.08.02653DD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf04.hostedemail.com (Postfix) with ESMTP id A01F940015
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:16:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QYcGXX65;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795626983;
	b=OV69BlghFtpNSWHs5eyT388V6XhYie9eLPbko+FIdCwpFwYf0DXzaaikI1//QeGFv/db1M
	PnHiqYQARsJ/b2Z3NtUvN10aIgmlTpjm1huPjcuxOJpnQK1n+0QF56LinzEWwLwavykqq8
	zZ9Bw++pZ/pEoaeMq6HYQLsAF2pwtS0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795626983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nv3AVi2ii8sDqpBUYLroZbzyYAj1uyi+9hphR1p4z60=;
	b=YbYzM4B5fEOBwk9Wlg/zwB5qERaWaPmxmu4FQiM8KsQsQN+ozZ75PntlpokrQ0NMoj+09O
	VNMUf+nLCj5pNsRGEj8fyURp8jTYYzrErUnwR9Qj8NqSF59hlH39IRshrmyVjwUuMhlV05
	J1rcTEVVYyrx7S4cat4+upz2mmd6mFc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QYcGXX65;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795626982; x=1827162982;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+k9uvO9rNhYlF7PPTcvzGNkwTo+8Re6JcWEKubDKrlc=;
  b=QYcGXX65fAXwEactlQ9XCKmDNxVGfgGeVYtew2UyLGef70jEYvin5HA4
   D8lPJp4IOusZQT/c9t+53cjV6V434sJAULqKUz4QCiOxK7KMhKi07odOh
   j/nrDZUmg1XDgU6/ByBCA5qLEpCG6tR9ayC91cNxFBpKR8RVwR+xA+jW/
   2GwfoyCuWWMng1eKPOBt6h4krKDDitztEfYb6QR22h1i72BAXCPQdGLfP
   TtXzrpIK8t+v1NHAhGcQFmYVa3Y5wh3KpFcfJfq6qdJyGLcV4yhXvwUQ1
   FBU3QX0J77NB6R5cGp6nNHbChGlMOwJ0UxNEC5bqJ2cvE96OgUIQhgTcv
   g==;
X-CSE-ConnectionGUID: j+pqBmyKReuYfZC1Aj9Uyw==
X-CSE-MsgGUID: 3uTI9jlySCKvtryrC1gofw==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4504418"
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="4504418"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 08:45:12 -0800
X-CSE-ConnectionGUID: UMC9+qpYRaONe4cUeA5ZZg==
X-CSE-MsgGUID: PgM3kGfERdagckdYk/vZsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="11802729"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 25 Nov 2026 08:45:06 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWG7C-00000001S7E-06jJ;
	Wed, 25 Nov 2026 16:45:02 +0000
Date: Thu, 26 Nov 2026 00:44:35 +0800
From: kernel test robot <lkp@intel.com>
To: Shivank Garg <shivankg@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <emmir@google.com>,
	Andrei Vagin <avagin@gmail.com>,
	Paul Gofman <pgofman@codeweavers.com>,
	Bharata B Rao <bharata@amd.com>, Daniel Wade <danjwade95@gmail.com>,
	Yin Tirui <yintirui@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shivank Garg <shivankg@amd.com>
Subject: Re: [PATCH 1/3] mm: move the soft-dirty fallbacks up in pgtable.h
Message-ID: <20261126003419.x9qXgaij-lkp@intel.com>
References: <20261125-b4-mm-soft-dirty-fixes-v1-1-538e3cdb618c@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-b4-mm-soft-dirty-fixes-v1-1-538e3cdb618c@amd.com>
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A01F940015
X-Stat-Signature: at9teic6fh4d8ycq3uyo19raxgrcjta9
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795626981-42133
X-HE-Meta: U2FsdGVkX1/DEJ7KE3jr020f7Hm/VuzqDk0Gd1hW4Ryo/fPmb3/1bumtY9o4E595qhN/muxDlVBYIB+ap7Y+ZLWfknTAiLyFqA6tf2xpNP8pucLwjHzew20zxyGTzq+Jh+KcuPC9XyQFX+ihoE24bqZTi//1annqnm+G2gONWSST4mMQ3/64jpC/MfAIUiKlOgYI8CQ26AncSWHHWeA+3iS51o5VeX2KdUrp1MAyq4e29vp6g/voZLeKnp8Lyr+loCse8mhSznMeoRGEqtMKdMzqH6KTTW4WrcptgKVIVHUJkwN+D4GXf81w70/E62Ag8MPkU0pjYPdT0eyBAGBJL2J51SfZeL0I1D6krDHGPqboChMa1LSEipBDhT32Zu/dbd0LIq6KauryPR+nDdnuygLSPg1JpG3G9xo5bRvIL9e2dCm+HTVg2oAWvWAbdgcoHBZ/gwEtVv5ocM63JsZ+QycIyk73TCfjAQJA5YwP3D40fv9ce1XlUIKoxEAja2XtZ3PK9ij4C49359bTbysFwA22LuKhklAJtV7DzKSLThfbaX/PvGpwklq82mjwUvMy09OIoIagK5FWFNDF6rYYuecVO3uTh/K+PjV+h5ZOr86rlczKfpVaOiPLk0HZuKIk+6AJcuindLZB9fF6G/mM6962Hz5WFkrim6dymG2HVgyz2AxlJ3+YH1Ik4XoHp6xUP5/QiWrITy61LehvB6jfMugz4J/ZQG12PRsQqBzCCbemub/QvMLzKWwoSea1tNGnuuFk6oZ2TWeEsH4T/fHfMauocVjnrxMDDYeUUdF3BrJvUPrpsh4OTkOyNgBmoxKQMl2fz9CWnWOwogFNKqQN70rSPsv2COFMB79alDeNa93duKqJW8RuG1ptPeE7kyZtvD4r8zOQZ8HQrUZNBxWFp/RbXHDYDiD9wlS3AFuFs5SfePq/Bs6sw28oNa3eDzlM1S/FJ5rLLcVLIMjD6Gf
 H0/mKsn4
 IEhfHWo2mUe8V8oArWAELRwyqz4RkYCSPgXaLbqNJq71AEBHWkPw1w3N4jnyWsZLW/sEvTVa8ycOuWXTimoOVPL82Mnkd9r+MHJgmmzBo5eMv8wCjS2xgqLcFGoQQ/Etoqg5QEf3pKqPIOvclfpwUE1jilKWdPJeyhCqlRAMv1OaoPpJSfFVTeA9a1T3hoazR2aWGgvZlmze2yloABntS2EHtRqXs7GKglZFwzESU3xQKLT3jmgAmNDau3lenmDezi2IrsVfCy4zwD3vGPVxus1tXbAERmDK6pedVcnhXLe0LXqQJa8SP/67Dm7yBHTjvEKa4DWE4KhV3xRvF9FN/wqg5Xy479YbKkw7Prum19mgTYxlJQD7dx0j03SjLyeseVLbsuXhVY9O5JsG34Pmf1+5TF/rLXXXgeMWlGyY7hOw3MKuYt04loLfhKYtil3irRLU4Cj/Wsw5yhBLTxzjbfZ3L6l5q8bB4+lh4ygzqdXs22Gxp3dzk+/Ow796ubY7JgytpYcOGYhs7MxhfWYMz130XbTNC8XSX7IMgFzF+0E3GRt9meGmJq+r8vgBMQ0J2Fx6U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Shivank,

kernel test robot noticed the following build errors:

[auto build test ERROR on 98f6b507621822477db7ec7cef8519de0dd243c4]

url:    https://github.com/intel-lab-lkp/linux/commits/Shivank-Garg/mm-move-the-soft-dirty-fallbacks-up-in-pgtable-h/20261125-133227
base:   98f6b507621822477db7ec7cef8519de0dd243c4
patch link:    https://lore.kernel.org/r/20261125-b4-mm-soft-dirty-fixes-v1-1-538e3cdb618c%40amd.com
patch subject: [PATCH 1/3] mm: move the soft-dirty fallbacks up in pgtable.h
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20261126/20261126003419.x9qXgaij-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261126/20261126003419.x9qXgaij-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261126003419.x9qXgaij-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/init.h:5,
                    from include/linux/printk.h:6,
                    from include/asm-generic/bug.h:31,
                    from arch/m68k/include/asm/bug.h:32,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/m68k/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:107,
                    from arch/m68k/include/asm/irqflags.h:6,
                    from include/linux/irqflags.h:18,
                    from arch/m68k/include/asm/atomic.h:6,
                    from include/linux/atomic.h:7,
                    from include/linux/jump_label.h:243,
                    from include/linux/once.h:6,
                    from include/linux/prandom.h:12,
                    from kernel/sched/sched.h:8,
                    from kernel/sched/rq-offsets.c:5:
   include/linux/mm.h: In function 'vm_flags_init':
>> include/linux/mm.h:972:26: error: implicit declaration of function 'pgtable_supports_soft_dirty' [-Wimplicit-function-declaration]
     972 |         VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:30:63: note: in definition of macro 'BUILD_BUG_ON_INVALID'
      30 | #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
         |                                                               ^
   include/linux/mm.h:972:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
     972 |         VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
         |         ^~~~~~~~~~~~~~~
   make[3]: *** [scripts/Makefile.build:185: kernel/sched/rq-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1417: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/pgtable_supports_soft_dirty +972 include/linux/mm.h

027232da7c7c1c7 Kiryl Shutsemau    2018-07-26  967  
bc292ab00f6c7a6 Suren Baghdasaryan 2023-01-26  968  /* Use when VMA is not part of the VMA tree and needs no locking */
bc292ab00f6c7a6 Suren Baghdasaryan 2023-01-26  969  static inline void vm_flags_init(struct vm_area_struct *vma,
bc292ab00f6c7a6 Suren Baghdasaryan 2023-01-26  970  				 vm_flags_t flags)
bc292ab00f6c7a6 Suren Baghdasaryan 2023-01-26  971  {
277a1ae3879a82a Chunyan Zhang      2025-11-13 @972  	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
9ea35a25d51b130 Lorenzo Stoakes    2025-11-25  973  	vma_flags_clear_all(&vma->flags);
9ea35a25d51b130 Lorenzo Stoakes    2025-11-25  974  	vma_flags_overwrite_word(&vma->flags, flags);
bc292ab00f6c7a6 Suren Baghdasaryan 2023-01-26  975  }
bc292ab00f6c7a6 Suren Baghdasaryan 2023-01-26  976  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

