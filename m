Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 702C3CA1002
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 02:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5EF8E0005; Thu,  4 Sep 2025 22:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8DDC8E0001; Thu,  4 Sep 2025 22:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4158E0005; Thu,  4 Sep 2025 22:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 883EA8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 22:22:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B1601404A6
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 02:22:33 +0000 (UTC)
X-FDA: 83853597786.02.A2AC668
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf09.hostedemail.com (Postfix) with ESMTP id 56AF9140004
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 02:22:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Cke/BzB9";
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757038951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OPrrVsueTLpt0k+H7bqaM9FI1neB/9AuTcgEjSaXjQk=;
	b=Pi2TeJ4W5SBLy2c58RNiScvWEAmkEifbGBJqlAnG1wSkNxFOUfQuZiAPsf4LA1lq1H/6vt
	rzYnPX5Vk3Xhoto0aI9rLJ7hxPPP0OS3PkdZpx4UUdp6rZ3741kDxkOaSRPfsa4k78S+L5
	PuaqP2BOXUvuXOCA/dK4WTrviU+1SaY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Cke/BzB9";
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757038951; a=rsa-sha256;
	cv=none;
	b=abDHpaIzS7BzVb7WymTjJMtlH8wYa73wyKUOaa6UtWHFKBuXI3VFWfR1ZNAXBYTytUduqK
	u7GJWXgQOhEFc2ecDSJCagpyZzbkzaImgH+l4U4Uv5iSb5USEfgzHOGSMmCPqHa69joNBG
	lRRMVQDlqWTyiyHnUyy02olQglgn4/0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757038950; x=1788574950;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=knywOHehCDlqFUogdERVd6NewBksJlhHBTn2QlOem8M=;
  b=Cke/BzB9433n1vDqW4Xis/4gDivpLk81Mwu21k+EWe8hcqvYPwtNcidL
   28FSwupIvOtdPOiMhKFqdyXFqlPbKtBnJlSXn62NgJSyiYE7TMbTd6P6C
   tj52675HcNO3krZDgM+O8oO1lGsFYrecm1n0JIEc8A+fJwLNoV/SVBe74
   sofLFKuwzfJhOXdvP5e1dGVMD0XVZsly2YVHH9JxzLlfGnLZr7Ov05okg
   qYIuCMtvHtzpKRZSrNdv/3usiiJx2WbYIgsT3z7jmVGLSsU93BanEDqnV
   eHM8LWZg3oWdq/ZEGGpc2uCSWTSYmMI+zKBuq/Dw7NeKhM2vavp2XA4Xh
   A==;
X-CSE-ConnectionGUID: 0cQ6T/I3QlW2W6NK3QcJzg==
X-CSE-MsgGUID: Boi9LL9VTlOr81iHe7kUcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11543"; a="46963306"
X-IronPort-AV: E=Sophos;i="6.18,240,1751266800"; 
   d="scan'208";a="46963306"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 19:22:29 -0700
X-CSE-ConnectionGUID: 0Rn253ScSgGj44TT3Nko8Q==
X-CSE-MsgGUID: RDlGAhGKTQKFQYOoztrlPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,240,1751266800"; 
   d="scan'208";a="171941816"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 04 Sep 2025 19:22:27 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uuM5C-00067b-26;
	Fri, 05 Sep 2025 02:21:56 +0000
Date: Fri, 5 Sep 2025 10:21:31 +0800
From: kernel test robot <lkp@intel.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [linux-next:master 6089/6355]
 include/linux/highmem-internal.h:86:39: error: passing 'const struct folio
 *' to parameter of type 'struct folio *' discards qualifiers
Message-ID: <202509051023.d6AUXYH1-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: j9hh6zeek3xaierbm4nuu8zp7txu1yeu
X-Rspam-User: 
X-Rspamd-Queue-Id: 56AF9140004
X-Rspamd-Server: rspam01
X-HE-Tag: 1757038950-472517
X-HE-Meta: U2FsdGVkX1/pVvSLmyHW6FpaoH+f+tNM1fGcXQNhnBHr370FBewutNaBz1oBbliTUCN72MMZsQQoEVtSz1LealF3nq4lYJlluLVRKEO5iQKZpCv0GiF3OGVnpQ3GQW3ve3Nca/fnN/zMT+YBcyK5/HR4obO1WtZIpqbdWUQJV5J++HtyfqTiCy2QIVCVddOFMFJlawlvoT0d3wQb4M2UXV32bebhda8Taenky8DbItKBWN7uX0qahhDA/sZslG1fe0FUPXxyNj8av3RJMh4e/P91Q1rBTzFq7YNUCDx9thjTO+U8gBziZVWwmyR2Uu1102V+te9e2D5oi5SAOaXELbgqvcC9pxNam0x4cwKuPhsouqe3yyZ7XjFIIczdkatl4Y5xBhohKiXCm4rytEW0+syIpB/6CJnsG3cJFsLj3hajNngm3TBWr5fkfU4MC38fvCrwpgVPRfMqoE/2HlZcBwO0nN5ruFQSkRCmP9wySjaOSD9hUuUfHkK/oHBz3I7yvsFecF9XG+bxmIM+wE/9u/kuq/3xNbvgqBFrp5SjOXHSA8RsmPAJrkPsaUM7upmkDPDD6OFnFnGhXxnLyIbPFEbZDdWM6h+n1JtXC9hblKvKQJIZPoaVcnNoNNyjE5X86Iea3iuXSdfuwhUUSSpUlI5/ne7nV2XNaJrmXuzujBMMltOHmBKAwRMk/R+bx2N2k13GohNSxwZp6B1+ImRKk9GS3DiAuVBIGCvHE++yqNjEXTg78CKNxiWEG+hnMbA/GEXBfS4JahW2N6+ruV+AJMGhwKCoRQdV4+ANWn3JyjiHYYd2bo0aiKmbdkSn6G0LQWMIaQN+C2u6RUDCxKQIKAYmtBdnqtH1zM7/zPi7jpC5u2GjCa/EgW5LXDsK45VIO0c0VSNGT4NO2Nw5kQUUxSgph9XgQaByKkxSHaTRgW6SxCsJPM9KewJGdxKDoYXc8bHa7qTK5AoJlgIEwlw
 YWHqhW0P
 L7KWLasurBY1PVEvuYrYEP46EV5Fo0vpSM3jgAkYFbOzBJx2n2YWBbeZGt+xDpScsY9hx/bBA5pnjQvHjwlUfH8bC+HPVIWbKeU7NpnrtTLtI88HSZyq1YcSw5DbzjhQTGVho4RetjlQ/MaAzmB4vpTdM+N7AC6sp638dKUiiJGbXF+8hdPcvw/tUVMMLmd1DRVFfNt1Gjtya2oytKxu1w6cgu0b2sAl21yyg675JyA2ssZybKivejUJ6ncMn8WU83wlEkozAnCUTrqN1CIytjrRzcbj0TJzn2ZsPwOgVTHqP5atE/PmczwlPyUTZm6eaBLAH00pjT9b+YLka+qB/l4EFVQUZL5IoT0UdrFtTjBAbzVo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   4ac65880ebca1b68495bd8704263b26c050ac010
commit: 598ad57d4b4687c7cbb9fc8af954143d250b03ae [6089/6355] mm: constify highmem related functions for improved const-correctness
config: i386-buildonly-randconfig-002-20250905 (https://download.01.org/0day-ci/archive/20250905/202509051023.d6AUXYH1-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250905/202509051023.d6AUXYH1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509051023.d6AUXYH1-lkp@intel.com/

Note: the linux-next/master HEAD 4ac65880ebca1b68495bd8704263b26c050ac010 builds fine.
      It may have been fixed somewhere.

All errors (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:23:
   In file included from include/linux/writeback.h:13:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:14:
>> include/linux/highmem-internal.h:86:39: error: passing 'const struct folio *' to parameter of type 'struct folio *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
      86 |         const struct page *page = folio_page(folio, offset / PAGE_SIZE);
         |                                              ^~~~~
   include/linux/page-flags.h:319:53: note: passing argument to parameter 'folio' here
     319 | static inline struct page *folio_page(struct folio *folio, unsigned long n)
         |                                                     ^
   1 error generated.
   make[3]: *** [scripts/Makefile.build:182: arch/x86/kernel/asm-offsets.s] Error 1 shuffle=2013769869
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1282: prepare0] Error 2 shuffle=2013769869
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2 shuffle=2013769869
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2 shuffle=2013769869
   make: Target 'prepare' not remade because of errors.


vim +86 include/linux/highmem-internal.h

    83	
    84	static inline void *kmap_local_folio(const struct folio *folio, size_t offset)
    85	{
  > 86		const struct page *page = folio_page(folio, offset / PAGE_SIZE);
    87		return __kmap_local_page_prot(page, kmap_prot) + offset % PAGE_SIZE;
    88	}
    89	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

