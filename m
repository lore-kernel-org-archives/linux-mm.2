Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C81DB606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZlkUj1KF
Received: by kanga.kvack.org (Postfix)
	id B50986B05B2; Wed, 28 Oct 2026 23:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01606B05B3; Wed, 28 Oct 2026 23:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17DC6B05B4; Wed, 28 Oct 2026 23:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74C246B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:40:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F199CA02B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:40:22 +0000 (UTC)
X-FDA: 85374261084.22.A355BE1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id 35EDA160003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:40:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZlkUj1KF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793245221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2wJHvvfHh5stRmUDRprT6CqvsTMqTsUp6BRdeqqGCI=;
	b=VnMud7D/huvuksTaPAlMPAdneIoj7HfryB3LPJp5OkWalakv2xXsfCGFQ0pLmGtZ0lQC8m
	BDB8cnfhvNiKFudgpheJ7FQURfb2yAWWteG8qzb5w+ZAkPq+r+jeLk9E7C9aOP0l2ztQeK
	8QTzZcGwCTh1I1ygtykTwxrd/opcLMA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZlkUj1KF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793245221;
	b=eZyS2BGUxRaQacREV1O+ANYC+AX+yiJ25f4PxFrmNYhDXuJTYIHeNJdwKNNA7qCYD/ZSlu
	5Sg20NY0roMbPG2vvd8yQuIkx/TZ0eUsOYIIihNXrCLuDSPxjY2ke+ps+5XekkIPxqMXlM
	QheROmojtId9N2jnaqbnYXIOG68jwKE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793245220; x=1824781220;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6He+g3AusxeH/gTF4BqtGi6Idfhj/4/mur9we+ezF4w=;
  b=ZlkUj1KFGQ0CHAoMAKsPK0CsiEEJJu+7ttpobi5UK2lPdaAT+O1PMlTM
   K2BqOfjvEShSFtntSauhZ7eBboCwEaA6/ympxV5bLlNG+NDfkztyiAPeM
   +kcJQPKow9IIIDe2zbCTW5xcIpAPPC4T5jUkhJ3S5W6oVtbC+RBIN0jiX
   B432Qqn8QM2qxd4DghKIHiA4X/AFyY7SpZvKhUuTE8u9sTje84V6znlLw
   ZN6YYFdWJImZN5Qs50Jk2OoImkOZpv07Lk3f3ZRdDSimLiQWBuYSL53Em
   JwnCJFG9sLGwamlIKjpuru3ZEWb3opFqJFlyVdvz3/1+/vSLARbMflo7r
   Q==;
X-CSE-ConnectionGUID: CbPObJIqRUaaq4KwPaTzhw==
X-CSE-MsgGUID: GQ6w6o95QCC0ipoIkchGuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="2012087"
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="2012087"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 20:40:19 -0700
X-CSE-ConnectionGUID: ksy7pyXKTUmlIOtfUgQwJw==
X-CSE-MsgGUID: Xn2yZ/ccSASehaLbTgTq5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="5143393"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 28 Oct 2026 20:40:15 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMGzs-00000000ZYe-0jbr;
	Thu, 29 Oct 2026 03:40:12 +0000
Date: Thu, 29 Oct 2026 11:39:39 +0800
From: kernel test robot <lkp@intel.com>
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, catalin.marinas@arm.com,
	will@kernel.org, mark.rutland@arm.com, ryan.roberts@arm.com,
	peterx@redhat.com, dave.jiang@intel.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, wangkefeng.wang@huawei.com,
	sunnanyong@huawei.com, tujinjiang@huawei.com
Subject: Re: [PATCH RESEND 3/3] arm64: Add PUD THP support for DAX and pfnmap
Message-ID: <202610291125.dNGHD2Vr-lkp@intel.com>
References: <20261028121404.853944-4-tujinjiang@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028121404.853944-4-tujinjiang@huawei.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 35EDA160003
X-Stat-Signature: wbcpscwoo7188dzzxdfsajzaee5wze3d
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793245220-438201
X-HE-Meta: U2FsdGVkX19pmu4jNB7T94dnPWaOL1NbTc+rQAwX1ae/fLxSt+O1B1e9AsuatdBG6cEDwzR2u94mwOv9EaJGneU80DRrW1TZCZuGxYvb5Q/aL980jYhptqOgDdHU7LOQQOqaPhW9ByqY819bIzvI7OpnQoD5MUk2IbCxa+Pn/tDvOnZMH7aEwsTDVROCtiE8OdvTb2L9fZPOO7oCcCOSoqMT2XRd0CKR6tRViiAW1XUIZI3MuwM5yKMsj4ykQXVk5zDyjxiCDXa8QMcj3sJea3eyJ8KMwmVz5BuwYjeRiGwI6MqAVEYZbcoNNhpcLME/Tc9ZqOWRpdiaXGl1ahY8Q12oQNu5Ln6c03eQeWoRjQrkhajqHZ9Rnb1EUUiMI10Ef8HT8P1m31+D14vU3sKhpIyUhpfEkL1sU2/3NAAci8oGmGDgdt7uEaUp0kv0/gr+rQcxAEt79Lq6YsE0Hh29IM/p20myWg7OuJb7YxDawOIcZJulk9esJduIwzJsfwGpTOF60ww0r/fpC+O6Bidj/6QueEhCPF/ULFjTXIebI0yuoDRcMSJsS7KrESIsVAs5gjBmRS743rUJDQ8NIhFvpNTB69ptuxDrKIMvV76QdcHBXMI737BKK3FB4GgF03gNVGRm+tkLnVs4GDDHJEFt6FeFeNy7/DVRrTCeUB+nIghhsfRN4juoVY6RVNlfbNJh7h9TnKE9+3TkDafEfnSbBaKZYdIJCzegxhNJzwHSQRiXrLUcfOBOeXMIXX4JJoKXdRiroJUExGn02ZnODSaxQJ07qSuljMvtYuX3ofxUFuYAxhwKwl3nRzLmA6oE3H1dABbvW8WiDO0Iko5Slr0nggtDZ059nLhhHTcX1XoU6N5/SS3PTojKp9Zt9F6bP3vNnJ6VF3zMyUobGP+jEAFNi1K4Z8RHpHEJJW9vl/s+WGKhL2smAPCujsggEY3Tww4IdHsMbGx/v1WiPKvZt4F
 n0oF99Mi
 eLmq1SrPfUAQI4Hm5T+kvHt3UVsVfVB1GTKZy5HwIxmEs6W7yjKuggKI1uKBBqcJaftEU9iv2SnRrhDTXFDvy7toCt6U0EVw34OWD26t1Wcj26rC+mJWLJE2RwV5A8PXvaBsE5+K5unNgafw50dhJYZ4n5o7uB3amuWbVKJRd+jkZitpekf/Yes2PnvTbMJoFWnX2y8rq/78CHy5s8VJvEzyHZBgpSvpFN4Khqb/7YYFhLP+mT6s96mjRec36i/xgVTyld58g5lIh52ey4f6DlfIRAFGH+iFq1F0omJrVSncNllVrWUTVhNznPVg/xzq5d62lQUEH0Tmu0MNehMGmXhJM5Cs4seWoRiFE07gXc+Tob0mH5BSmWQYp58zX5wfY/Yts
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jinjiang,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on arm64/for-next/core powerpc/next powerpc/fixes tip/x86/core tip/x86/mm linus/master v7.3 next-20261027]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jinjiang-Tu/mm-define-generic-pudp_invalidate-implementation/20261028-201402
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20261028121404.853944-4-tujinjiang%40huawei.com
patch subject: [PATCH RESEND 3/3] arm64: Add PUD THP support for DAX and pfnmap
config: arm64-allnoconfig (https://download.01.org/0day-ci/archive/20261029/202610291125.dNGHD2Vr-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261029/202610291125.dNGHD2Vr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610291125.dNGHD2Vr-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/arm64/include/asm/io.h:13,
                    from include/linux/io.h:12,
                    from include/linux/irq.h:20,
                    from include/asm-generic/hardirq.h:17,
                    from arch/arm64/include/asm/hardirq.h:17,
                    from include/linux/hardirq.h:11,
                    from include/linux/interrupt.h:11,
                    from include/linux/trace_recursion.h:5,
                    from include/linux/ftrace.h:10,
                    from arch/arm64/kernel/asm-offsets.c:13:
>> include/linux/pgtable.h:2098:19: error: redefinition of 'pud_trans_huge'
    2098 | static inline int pud_trans_huge(pud_t pud)
         |                   ^~~~~~~~~~~~~~
   In file included from include/linux/pgtable.h:6:
   arch/arm64/include/asm/pgtable.h:842:19: note: previous definition of 'pud_trans_huge' with type 'int(pud_t)'
     842 | static inline int pud_trans_huge(pud_t pud)
         |                   ^~~~~~~~~~~~~~
   make[3]: *** [scripts/Makefile.build:185: arch/arm64/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1416: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/pud_trans_huge +2098 include/linux/pgtable.h

1501899a898dfb5 include/asm-generic/pgtable.h Dan Williams   2017-11-29  2095  
a00cc7d9dd93d66 include/asm-generic/pgtable.h Matthew Wilcox 2017-02-24  2096  #if !defined(CONFIG_TRANSPARENT_HUGEPAGE) || \
bcd0dea5f4fb3d0 include/linux/pgtable.h       Liu Shixin     2022-08-29  2097  	!defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
a00cc7d9dd93d66 include/asm-generic/pgtable.h Matthew Wilcox 2017-02-24 @2098  static inline int pud_trans_huge(pud_t pud)
a00cc7d9dd93d66 include/asm-generic/pgtable.h Matthew Wilcox 2017-02-24  2099  {
a00cc7d9dd93d66 include/asm-generic/pgtable.h Matthew Wilcox 2017-02-24  2100  	return 0;
a00cc7d9dd93d66 include/asm-generic/pgtable.h Matthew Wilcox 2017-02-24  2101  }
a00cc7d9dd93d66 include/asm-generic/pgtable.h Matthew Wilcox 2017-02-24  2102  #endif
a00cc7d9dd93d66 include/asm-generic/pgtable.h Matthew Wilcox 2017-02-24  2103  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

