Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD508CAC587
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 04:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB93C8E0003; Sat, 13 Sep 2025 00:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E68D38E0001; Sat, 13 Sep 2025 00:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5988E0003; Sat, 13 Sep 2025 00:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB80A8E0001
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:54:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C8CA1A0A55
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 04:54:32 +0000 (UTC)
X-FDA: 83883011184.23.AFE590D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf01.hostedemail.com (Postfix) with ESMTP id E31B140003
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 04:54:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FuWjdRA3;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757739270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GCaiZqVBhhBiGreDrxp/HTJvLmYdvREUwnSsfve/ZH4=;
	b=oT2ApRR51C9iEOD12tPkqBuEGRKfB0YaOYxYpdoBuYlkjCRVFsKOMPrPgoEbuKxJygjeRo
	V4jSygKFsX52IZ2eTAA23UZlJ4K2C+Deh0Mq3WVVZGC2m6Mc3O1pWw2C8UC1B9b6uCSpNN
	MY472mUExGlTsgcZXEV+oWrlv/kFFgM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757739270; a=rsa-sha256;
	cv=none;
	b=Cl6/shAqTfKYtWTyIKtGXLmI9cI5rFERfAsKFB5StmjXXmqB3CbNK6wOYw80cptcLimRk9
	OprLMHrDouz+QBnn1Jj65SB56CA9kuz3JjubKmQ4kwN3G6I8fcLTv62SMf6oltptdU4dtF
	28MI7HIFMXCtAIG9OaziFpsInHFHBaA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FuWjdRA3;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757739270; x=1789275270;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=vf17++RMcUm1uTKoA7SlmMgh6YPFEz2iKCiWctknxnQ=;
  b=FuWjdRA3vt7fChcgqgjIsZMTRofon7tASJZrEkiFEVUqKV5J/JMK107B
   HFIQsEApnAbMbakMEMzjIDhRWYEPfwfUuFKAmjfOHXgOv0IOuwNxIMzjV
   IkiEnhg4lkvl2Mmwni53D1xDZrvQ0NyNpWL5X2sjSl4tRBDeZyh/OMtqn
   3V6brk+qyACSpxO92VVUjkTFlWduUP2eAmvTeeQmfRZ6SJXAyKyI2EUXd
   UnRRBydlNEyd3UsWtbk3MKvEqEEtRW6ceYNvdRjv3InNH1dMPI6sCuuAm
   Mo3J1Qqtk70ga9MFt8afdL7dP8M/75XgIMGsOnDGbLeovFD/ifE1wMGMY
   Q==;
X-CSE-ConnectionGUID: 6AZYXtjCRYa/Nj/UXWP+zg==
X-CSE-MsgGUID: EXzYwOkDTWyBZ4UL9bjWwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60151366"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60151366"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 21:54:28 -0700
X-CSE-ConnectionGUID: dl5LpduZQZerRsKIL84RQQ==
X-CSE-MsgGUID: HCSkTh/JRZSJmYTWN0jrog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="197872578"
Received: from lkp-server02.sh.intel.com (HELO eb5fdfb2a9b7) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 12 Sep 2025 21:54:27 -0700
Received: from kbuild by eb5fdfb2a9b7 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uxIHJ-0001Mo-05;
	Sat, 13 Sep 2025 04:54:25 +0000
Date: Sat, 13 Sep 2025 12:53:27 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 39/428] include/linux/pgtable.h:235:36: error:
 expected expression before 'do'
Message-ID: <202509131255.x9EfvIGt-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E31B140003
X-Stat-Signature: gfef3fmwapnhsp6dh64wjdbjfqunpj4x
X-Rspam-User: 
X-HE-Tag: 1757739269-826569
X-HE-Meta: U2FsdGVkX19x7iQTxBls2jj4i4kwHPKugHNgzA1gKCV5SgixrWb3B+tBmqv1pRZHiBKq3+jCvcKoHC1VqEtV18f0jn/4tYqWw0vMAdMRQ0c4d0bKWfmg0b9OsuV4f1tVZ91EbojQPAUwDkzEyR8nyb0qWw8Ai+apKjZFFdcfhpQe0Yoa4rO9An4/phW/bBB7p0fNiAagrOQ1nt7AwrcE0crSkZcGvBnpsdH7lVAIWP1L6Gt5u7wSx0pcxorQk8xT13qEmTUi6yiF0j6ho4wUHK1LkAKfI9MMYhRp/WiptfdXZebLiooofSHMIpO4N+AN6Abq8q1XuOa1YeX44kyPnQ6XuSVRSzIt0oWknRzicRid67wx9fJEYxA8w2EsUa2FpLfPBROi/pGTG8KV9UjYafBOqMxv9CWAFK6LKd5EMD4YZeL0tw7WI6Cu2J4tf5TAqy0tIzjmU45l5wBl3hTKx5oUJyyuJSmJSuzZO/fy97XucSwwpDSI6MeslK53flyvPrG9Rjog9DmQr/GlK9CC0JwTS0uqS91eV1YW6v9jaTU7/Y2/KtPXj7Z5m/c0L8Q2+zaa7Wy3CeFQ1qEvnZoLZU7kvu+lAhvBgyk82tHEK/n9xpskpm2gaMlxxo7Fvd3qn7FTGhdtiYJ9hwsTpJIAlDvlSPusPtpPpTQek8wJSdJigUOGWRoWggEVaZ4PkC/SbZqlFEoQVlSyvvsWDXF8Rrksc+018RAsxnpBkijTb1p+0nbvaXjObH8/YpMxlaFXv1+/urcvgXsS18P4jfyQko33w7cl11tsHk+FcL0IREacO3sLoIMgteLgD4l9m61uKg01NKCv3gF4U8qRYFclY/OpjJ78LvhDf6LA9XL824CNJKW2kPyTw++MI8gn5x2Whs1AkAu2SPJBfI/1M77brXe4sN0xuSRYTgfQKtxmpfKQrpSC9evQQXB1nWnA7H3vPXtdYYPZRV+nEsXvHWT
 JPYmSi3R
 TcEd8xqKF9jx1YHEs7OQjYwxKcuqEncBq09JAIXTkUX7+QkhG2lWEGPxKtjLeAMU5JXUE5avnP7c6a+4ePosudByUNX9SxkQ9nKATVXOdbTt7gWsMyvdwaVDd3BGmgmnnUAgWPvSexggCykgPKoy7poBePfLT3ce/sUS/EgbD1Sc21l0NfE9lI0O6wNbryNxkjlG8GoFw1jD4Te9ebYrDr0nMmarLedP9tj15Uad16dViTz5tPJep8lG7PgQHpbtTdmLV1AYwitVs0c/ax7lJisI2T2y03ytwH2lfEZdjpez1hNo+fWyAxcoFiPgswjmP4vx0fv0Jo7iGYMY/SE3LHFT3XoEZXRm20X7zFjO0nqvVHBMXPZcbdIKBceu0AeZWIM6LCH24HUUj5rhM3Od/RUiylBUJIaSzfEW6DCPLSaxq2k48KNb3sxo0gzszz7Z7MdUWYdvL5f9+35DNo9hwiy6PTAHyb6fALqsy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   8ded915c4409a5190b1c9c57c172d62ab5534274
commit: f6748cc302fdca7c486c6098f315bd4174f5c614 [39/428] kasan: Fix warnings caused by use of arch_enter_lazy_mmu_mode()
config: s390-randconfig-002-20250913 (https://download.01.org/0day-ci/archive/20250913/202509131255.x9EfvIGt-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250913/202509131255.x9EfvIGt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509131255.x9EfvIGt-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/kasan.h:37,
                    from mm/kasan/shadow.c:14:
   mm/kasan/shadow.c: In function 'kasan_populate_vmalloc_pte':
>> include/linux/pgtable.h:235:36: error: expected expression before 'do'
    #define arch_enter_lazy_mmu_mode() do {} while (0)
                                       ^~
   mm/kasan/shadow.c:322:8: note: in expansion of macro 'arch_enter_lazy_mmu_mode'
     (void)arch_enter_lazy_mmu_mode();
           ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/kasan/shadow.c: In function 'kasan_depopulate_vmalloc_pte':
>> include/linux/pgtable.h:235:36: error: expected expression before 'do'
    #define arch_enter_lazy_mmu_mode() do {} while (0)
                                       ^~
   mm/kasan/shadow.c:497:8: note: in expansion of macro 'arch_enter_lazy_mmu_mode'
     (void)arch_enter_lazy_mmu_mode();
           ^~~~~~~~~~~~~~~~~~~~~~~~


vim +/do +235 include/linux/pgtable.h

533c67e63584067 Kinsey Ho               2023-12-27  214  
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  215) /*
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  216)  * A facility to provide lazy MMU batching.  This allows PTE updates and
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  217)  * page invalidations to be delayed until a call to leave lazy MMU mode
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  218)  * is issued.  Some architectures may benefit from doing this, and it is
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  219)  * beneficial for both shadow and direct mode hypervisors, which may batch
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  220)  * the PTE updates which happen during this window.  Note that using this
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  221)  * interface requires that read hazards be removed from the code.  A read
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  222)  * hazard could result in the direct mode hypervisor case, since the actual
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  223)  * write to the page tables may not yet have taken place, so reads though
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  224)  * a raw PTE pointer after it has been modified are not guaranteed to be
691ee97e1a9de0c Ryan Roberts            2025-03-03  225   * up to date.
691ee97e1a9de0c Ryan Roberts            2025-03-03  226   *
691ee97e1a9de0c Ryan Roberts            2025-03-03  227   * In the general case, no lock is guaranteed to be held between entry and exit
691ee97e1a9de0c Ryan Roberts            2025-03-03  228   * of the lazy mode. So the implementation must assume preemption may be enabled
691ee97e1a9de0c Ryan Roberts            2025-03-03  229   * and cpu migration is possible; it must take steps to be robust against this.
691ee97e1a9de0c Ryan Roberts            2025-03-03  230   * (In practice, for user PTE updates, the appropriate page table lock(s) are
691ee97e1a9de0c Ryan Roberts            2025-03-03  231   * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
691ee97e1a9de0c Ryan Roberts            2025-03-03  232   * and the mode cannot be used in interrupt context.
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  233)  */
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  234) #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02 @235) #define arch_enter_lazy_mmu_mode()	do {} while (0)
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  236) #define arch_leave_lazy_mmu_mode()	do {} while (0)
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  237) #define arch_flush_lazy_mmu_mode()	do {} while (0)
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  238) #endif
bcc6cc832573a99 Matthew Wilcox (Oracle  2023-08-02  239) 

:::::: The code at line 235 was first introduced by commit
:::::: bcc6cc832573a99d1f935c89a28e2c71fd1aaf0c mm: add default definition of set_ptes()

:::::: TO: Matthew Wilcox (Oracle) <willy@infradead.org>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

