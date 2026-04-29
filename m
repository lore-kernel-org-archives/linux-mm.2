Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 606BBFF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33EF6B0088; Wed, 29 Apr 2026 17:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5446B008A; Wed, 29 Apr 2026 17:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB7A6B008C; Wed, 29 Apr 2026 17:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC146B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:00:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28EF34013D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:00:59 +0000 (UTC)
X-FDA: 84712813038.19.E589E2E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D6EBA0012
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:00:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="S/gIDKVO";
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777496456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=jK0S7IxBxl8qnMKzIc9YB4WIRlbHiHUWgrQM1lm4Lfs=;
	b=qlyr4GTNJj2SX+TSE/JHUVlpz2kdZdrZo2RYb03sWCnEFcZy3U/nGiYcRpc/cnL4cPsq2o
	OilgvxG+AmnBlYsc/P8dVEoVHiHFan9ft07XcKZyRaduXbZ5AGyJ2P+hR8lN4DPQc6qFJY
	xXWhaHManZIQTIkyNNzccSIWT5tgyBY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="S/gIDKVO";
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777496456; a=rsa-sha256;
	cv=none;
	b=r/MUB5dW8X3I/GUjDCeHbr8exCLcq5SpMEajN6F1UQAVmBEBkTOpNEf08Zjt+L5CFH7B5D
	n8rT1jxw7Y1HuDIcZEGwR79VCMQ5qCXbIpvhXywvzP3LW68lHTCkWAZ83Zy9K+GOLAWHgw
	Igri5CNI9zbTqybjFPooZLc8EfxBRRg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777496456; x=1809032456;
  h=date:from:to:cc:subject:message-id;
  bh=Tw1tjOKi0uEKgc0t9U8SNyE74PngO/1q9Aghuv15gOk=;
  b=S/gIDKVOHo3Wj4CsQBLRrWZLLdDE4f5ZG7rWIBOOdp1+rLzcO3QHm173
   oUHuUn78E/4iPb+CSZXyIAgrW+obH4u0+mJrl8ySYzIUxCzeVQm3oFAfF
   wicUMo+DJVVR12Sf1uHaSdzWCjYlLpnvvBJFtxbeFGnlMoEFt5DOs/Jrd
   mGcnk5EmZGQyftCJ2PZftZUfdmlJnZiMyW9lEptmyPGxJSZq0kwSQg+5a
   OLYpAKFo1k0ESOIHzU5SwmWX+v2GduFdtU+3LXUjzkmhb8lNXPnvlA94t
   WDFCyki+av6VDaOcUtecSQBXqLktcnzrQZxNBin7tbpqXV9Dcfn9e77Jh
   Q==;
X-CSE-ConnectionGUID: yoADdct7SMidaWX/ztbKrQ==
X-CSE-MsgGUID: /qUScSDESteuS1PORQ07Zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="82301078"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="82301078"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 14:00:54 -0700
X-CSE-ConnectionGUID: uAz0o5e+Tq26Lt4eyR9i/w==
X-CSE-MsgGUID: +PQz5pgZTtaRbUJK04fh9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="229779638"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 29 Apr 2026 14:00:52 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIC1Z-00000000BXU-0BDb;
	Wed, 29 Apr 2026 21:00:49 +0000
Date: Thu, 30 Apr 2026 05:00:15 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>
Subject: [akpm-mm:mm-new 122/169] include/asm-generic/fixmap.h:77:9:
 error: implicit declaration of function '__set_fixmap'; did you mean
 'set_fixmap'?
Message-ID: <202604300401.oBmk76Q3-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 1x7i4onwijob5p5rfxqoiq7q6o3umody
X-Rspamd-Queue-Id: 9D6EBA0012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777496455-489720
X-HE-Meta: U2FsdGVkX197zl2RqKHjD2cg3m5wT4RWCcl1dVdAmYinTwQji5KBfnHvR3Hu3+vvdTQZ3DJevyfHd1CG4QTDZI8520eu/bNmI13q5KHYgAhu1xuD89TGfhnVl00V72i3/cdA+DMAeiSMQ+h3GgAR5/38iZE7Qj90Q522agyawpcyHmULylVOYnSls/LWxtAu0CpLmiUmJcqRra4ZLYwUx45kYk2dF+0rFBSj1cl/Rc8MLJvPHwiEJIGN4T9y39EQV4gdlZxoVsR3afiqVT1wj5oiIRCjnXV3R4AZzFjM4um3T9Skx57bIngO91PzwU31NOiNVfhfnKYSoAKeDSZX3zVrOfH4oodY2h7X3uMLBqUawi14Xj0P5X0qXnNersXFDAQF9UwVTg4+ohU9byJzOu+ObQybNHqfrguDacQHn6C/JFz4+SjwWSX6sPp7yG05MblctGSv+3Fom2iAZj/tIWVUPV2HzjQkG2w0oc+27eaXCaqn5SENN7V4l+2epYwFJ3Otrl4z0TTjZAw2UOqvbAbg1KEUdQHbz/vQ4ZmHkHXmBPlZhfIBocrAczEeYlTJn5RkM4tY1VD92tkpyRX6aT868SF7jLciibnIsxxDF8JEBiHVTh4OKdNWXmavAENwnQd8rp9TD3fEofqe2iRX1E70UrafFJ/dfqWANjHMFnZhQ+hyeat/Mo/HxQe1SZPSS/iS/eUdoPgGOvjEWwXdc9Ylp109NgeFcSFjJzcLVhpJAooTUg1Oleg4LAK/2EXkxc4JVSz84oN/mIbL74zfxH0zHxdQpc0bVVWDpUCCBJosmoCRjrVDYOWP52bUCxfd63bRH9p4VgxisDMx3WcDzdXzujd+ULiaDRkVJunED8px4F0M+iBzEnWxIjIaAR2YvJ8tfbFIO1HolW0dXkBpzn1TBEEkgVlDhbDOnSjrcsvMHlgw7LYbN3ltt5fHNsFShAvhGinLnhLVc+fi5zi
 t63ccUSq
 W2Qeu6l1xBl7pg904gFZnQ26Whi6yTLwqjWgDRO7r3YA3lPJ8LR9PmAIijRxQAMxfnIrPcoMbEw8ZO4rOUhKze88+lmtqPDaEfL5Gsb5GFql56kdgNlKseX3nK3rPP+AiwEjOzbbeCakIP/reHkWR6outPYuUFNwj8gX+8A5cn6E6HyXWNft4KG5oJaQ6TF+Arxl86HE0NArR4Wg4x+GUlvBqJBJv00fKiWVzKFrVD+88SMyYpAzCckjwU2FoV86pinzKmmLw7Dfszy0w57Pj1glLki0iOJ6/WJvfYRCOs8hHvQRkN7zMGRYI/hGZKPvNFeQyBk936QW3asOPgYQisGPFGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   0587fb0c820d86e5b77a975680d79b5176d09abb
commit: 4fee62a8f7a8a78b1e36d2b5a7a2030b18cccd56 [122/169] include/asm-generic/fixmap.h: reimplement nasty macros in C
config: csky-allmodconfig (https://download.01.org/0day-ci/archive/20260430/202604300401.oBmk76Q3-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604300401.oBmk76Q3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604300401.oBmk76Q3-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/csky/include/asm/fixmap.h:27,
                    from arch/csky/include/asm/pgtable.h:6,
                    from include/linux/pgtable.h:6,
                    from arch/csky/include/asm/io.h:6,
                    from include/linux/io.h:12,
                    from include/linux/irq.h:20,
                    from include/asm-generic/hardirq.h:17,
                    from ./arch/csky/include/generated/asm/hardirq.h:1,
                    from include/linux/hardirq.h:11,
                    from include/linux/interrupt.h:11,
                    from include/linux/kernel_stat.h:8,
                    from arch/csky/kernel/asm-offsets.c:6:
   include/asm-generic/fixmap.h: In function '__set_fixmap_offset':
>> include/asm-generic/fixmap.h:77:9: error: implicit declaration of function '__set_fixmap'; did you mean 'set_fixmap'? [-Wimplicit-function-declaration]
      77 |         __set_fixmap(idx, phys, flags);
         |         ^~~~~~~~~~~~
         |         set_fixmap
   include/asm-generic/fixmap.h: In function 'set_fixmap_offset':
   include/asm-generic/fixmap.h:48:28: error: 'PAGE_KERNEL' undeclared (first use in this function); did you mean 'SI_KERNEL'?
      48 | #define FIXMAP_PAGE_NORMAL PAGE_KERNEL
         |                            ^~~~~~~~~~~
   include/asm-generic/fixmap.h:84:47: note: in expansion of macro 'FIXMAP_PAGE_NORMAL'
      84 |         return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
         |                                               ^~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:48:28: note: each undeclared identifier is reported only once for each function it appears in
      48 | #define FIXMAP_PAGE_NORMAL PAGE_KERNEL
         |                            ^~~~~~~~~~~
   include/asm-generic/fixmap.h:84:47: note: in expansion of macro 'FIXMAP_PAGE_NORMAL'
      84 |         return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
         |                                               ^~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h: In function 'set_fixmap_nocache':
   include/asm-generic/fixmap.h:54:29: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
      54 | #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
         |                             ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:93:33: note: in expansion of macro 'FIXMAP_PAGE_NOCACHE'
      93 |         __set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
         |                                 ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h: In function 'set_fixmap_offset_nocache':
   include/asm-generic/fixmap.h:54:29: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
      54 | #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
         |                             ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:99:40: note: in expansion of macro 'FIXMAP_PAGE_NOCACHE'
      99 |         __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE);
         |                                        ^~~~~~~~~~~~~~~~~~~
   make[3]: *** [scripts/Makefile.build:184: arch/csky/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1373: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +77 include/asm-generic/fixmap.h

    72	
    73	/* Return a pointer with offset calculated */
    74	static inline unsigned long
    75	__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
    76	{
  > 77		__set_fixmap(idx, phys, flags);
    78		return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
    79	}
    80	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

