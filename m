Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DDD7CEBF61
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 22:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E372E6B000A; Sun, 16 Nov 2025 17:39:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0EE86B000D; Sun, 16 Nov 2025 17:39:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B416B000E; Sun, 16 Nov 2025 17:39:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C10636B000A
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 17:39:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 696E5160B32
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 22:39:17 +0000 (UTC)
X-FDA: 84117937554.18.6C1312A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf27.hostedemail.com (Postfix) with ESMTP id B80BA40009
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 22:39:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gJxym1fc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763332755; a=rsa-sha256;
	cv=none;
	b=E/X9fddoQ+gI7bRqTZpqnHbS1C/6mJ28plvmvkPwlVNrP5et2YedLhO44p0vg3za0JQWBM
	2XoLWi+oLRzs0TOkH1T9YxRDMThcfIYAUdzycMFznT6R4GFXPZ5uEwO4eInkFlZkKXOoj0
	i6WcTg5SGAcr4h3Cs4UVFkc7R22YiYM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gJxym1fc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763332755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RGXiJpaTbMJFy0eModCfemSRsQw9LW89vY7sycmvHo=;
	b=nLViMx/fSRz8kCVwT5lUOZrNZpn9Gg3/QOCliiy3m6JueXUtOCs/vz29sfksgVkKeLrbC8
	tr1TTKvabV5QAvm3yKa1+P4zSKJEzVnY+wVVZpmpQKkYqw8McSRFR9YCUdg1xchTJNxrlk
	iOzaNjL3tRVKZzcxBVD8v+Sz7JWFg/w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763332755; x=1794868755;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=axivBqRhfsA8y2ZQJpQxZddTtACDe6CgCnQ3nRedy3c=;
  b=gJxym1fciCVLdygerBgsxnWQB1vyYbCMM+SGK9SxAsfyxz1hs7gbUYr6
   605ZLfmVYNJEI7rsPox70lloeCCrs0kC6oo5+I8JXI7ygZ44d4pxoJa8m
   dOXgk+VV5RDSy5pdTF4GYyOoHiw4VwLyxh4xxaRqNL87HkXbQl54vuMrb
   SIYAxP8GRCI3bfphqw30WJwD/cHjhNmM+3iqWdx5fPqtcFcmqPNSbjDO7
   wS/wuiKjVM7rqSLvyJeziCT6JO3xvjfhLX2fI8cOJaCl0tzeEeGSZ3Z08
   gJaeEDmhmyvFzzC0ydAqNCjabTV+6wJP49pagv0fqJjS6Rg9g/SeG3AOG
   w==;
X-CSE-ConnectionGUID: KiwdvGUuSGWMo4Czwzz3Kw==
X-CSE-MsgGUID: 7+ei1VbOSNCJBqvnmk8GFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="75654069"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="75654069"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 14:39:13 -0800
X-CSE-ConnectionGUID: nPGUdiYcQvOTOddza7SVMA==
X-CSE-MsgGUID: JCCZNBKkRAaEd7ykp321+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="195434281"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 16 Nov 2025 14:39:09 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vKlOk-00097p-1a;
	Sun, 16 Nov 2025 22:39:06 +0000
Date: Mon, 17 Nov 2025 06:38:23 +0800
From: kernel test robot <lkp@intel.com>
To: Jiaqi Yan <jiaqiyan@google.com>, nao.horiguchi@gmail.com,
	linmiaohe@huawei.com, ziy@nvidia.com
Cc: oe-kbuild-all@lists.linux.dev, david@redhat.com,
	lorenzo.stoakes@oracle.com, william.roche@oracle.com,
	harry.yoo@oracle.com, tony.luck@intel.com,
	wangkefeng.wang@huawei.com, willy@infradead.org,
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v1 1/2] mm/huge_memory: introduce
 uniform_split_unmapped_folio_to_zero_order
Message-ID: <202511170614.JnCyqo45-lkp@intel.com>
References: <20251116014721.1561456-2-jiaqiyan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251116014721.1561456-2-jiaqiyan@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B80BA40009
X-Stat-Signature: xmd6ypdwqxwgc3mp4nobpsyg4gjt9ejp
X-HE-Tag: 1763332754-459110
X-HE-Meta: U2FsdGVkX1+qiAShsuXYiVapiassS+9RC43uyAYu2qfT43vChUVh44tEHCmH7+ePN+YAa3JJDuhc89BE4fRf+WCW/9ehZf4grRzRcGx3FI3a2YmRjoza+pmNTdKz8EKhBK2yk5ynRgjxPgd3atS1/EsUv1gvrF/LLusZ3ICpfN1vABMk15t196kNwwDPDmeqcSeaRiZvzdhM/6B92NA9aEypASPl1dMVj6HMY8bUWnUEPqOsoKegoVFWa5j7q1k7jGgGI7QHySnUEo6itI5wH75EEqfKPFp8dT2bzszlYlvGD/v5etAlz0oQniUWoIzenw1pveHgMEY3Cri8r3G5xB+bGIk9eFLkCmxzYdCFK3nFF+QasObQQIikkhG3kSXINtVW/mIEMrNAH6uAhXH40BwnImYltBhtBY1SKgMIo09bWtvAhDoYaB5WqPDRbJUkAunAKSJL3b8wzeeYCAqF/vyoliB2tOJC9ukNHWXHz6bOZkz16kW4r9LfiODF3ZRb4YEdT3GJRClq5Iitj5tGbLvlHyma1HhJww/AlQlvutQFBct21CHw0b1LSu1fbXe3lvgduJ45aSJzIykqealDYvoSBRYo+gxBjz2Xt8Yodq3Vst0i6Oi2BGyOug9QFhqzrPRMq8Sdxw/pCMgt/DHRZpWvsg1LlzBhPdC2rwByHCstuWgC8E0/ZcXbL82a9GnuVFEBL+PtITtlVcKUKqDMB07pTdRUA4oMEy+8UBLICMEFBOp/Bm4p8Xa17kWfmX+SjOhkqYkNqywU+dTTws2q0rtRdpYHZ7c2k6ivQwKxrcZdwBiwgnn/L4TYiSACuYFk9rQ9MQAtQWfRU/yuWP39jR/ZzTjdyp6nXHE9T+4veq0A+qL7maG+Do0oE841b3ETLKzb4KFGv2Fl1yy646L5EzfAU1jJU/l0PC8tlN0OwJZId9CvasthIrMQBGWjN53sFB4OcVgircnZnwDDwPk
 rYM3kcMW
 99KhGi7nVBbGulL1kQZDbYJXNW/oFjOjqPYHHtBWdHETwLrf/9eB24ltI7mLI9uZmqeCmgoR2pQEt3Ge+xro0caTJq7Ldc7qsGtfQONG9mC7V8IdIJAYpF+HzjNsdridlj3tebxbxr91q/jTAk1xqZDkJ9//COB+oQ+k4xKhZm3xc0ToVjS9v8YAwFiHrjqku2jGdkE5fwffYm46PXxNeCy8L3IQoLlqRbUl0qpwAVXLYKl0TLRWtFF2o3v3wdbyfzWlokwA/prPt3KF96MJQZB7tnW83ZBux5I4UfVKWdT+0IQme+n26ewV6VOBCaA1voUNbkD3O0mHBiuUJ6C7duNjuGyEw9684MJuEYJ7XJS/2sYu5DKmon2gzU5XnJhwewIsN1CKbnAehPATjtVvXptUmOyzR+1bKcWrbVLPO7JGtoC4rvdSuC7ZUuY0J6XyU9hU55pKlSYLwNMYRvXC+aqqn7DQu1eyTejOHluxMsPoaPVYO6kimyB172A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jiaqi,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.18-rc5]
[cannot apply to akpm-mm/mm-everything next-20251114]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiaqi-Yan/mm-huge_memory-introduce-uniform_split_unmapped_folio_to_zero_order/20251116-094846
base:   linus/master
patch link:    https://lore.kernel.org/r/20251116014721.1561456-2-jiaqiyan%40google.com
patch subject: [PATCH v1 1/2] mm/huge_memory: introduce uniform_split_unmapped_folio_to_zero_order
config: arc-randconfig-001-20251117 (https://download.01.org/0day-ci/archive/20251117/202511170614.JnCyqo45-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251117/202511170614.JnCyqo45-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511170614.JnCyqo45-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/mm.h:6,
                    from arch/arc/kernel/asm-offsets.c:8:
   include/linux/huge_mm.h: In function 'uniform_split_unmapped_folio_to_zero_order':
>> include/linux/huge_mm.h:575:33: error: 'page' undeclared (first use in this function)
     575 |         VM_WARN_ON_ONCE_PAGE(1, page);
         |                                 ^~~~
   include/linux/mmdebug.h:55:27: note: in definition of macro 'VM_WARN_ON_ONCE_PAGE'
      55 |                 dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
         |                           ^~~~
   include/linux/huge_mm.h:575:33: note: each undeclared identifier is reported only once for each function it appears in
     575 |         VM_WARN_ON_ONCE_PAGE(1, page);
         |                                 ^~~~
   include/linux/mmdebug.h:55:27: note: in definition of macro 'VM_WARN_ON_ONCE_PAGE'
      55 |                 dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
         |                           ^~~~
   make[3]: *** [scripts/Makefile.build:182: arch/arc/kernel/asm-offsets.s] Error 1 shuffle=3849756084
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1280: prepare0] Error 2 shuffle=3849756084
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2 shuffle=3849756084
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2 shuffle=3849756084
   make: Target 'prepare' not remade because of errors.


vim +/page +575 include/linux/huge_mm.h

   567	
   568	static inline bool
   569	can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
   570	{
   571		return false;
   572	}
   573	static inline int uniform_split_unmapped_folio_to_zero_order(struct folio *folio)
   574	{
 > 575		VM_WARN_ON_ONCE_PAGE(1, page);
   576		return -EINVAL;
   577	}
   578	static inline int
   579	split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
   580			unsigned int new_order)
   581	{
   582		VM_WARN_ON_ONCE_PAGE(1, page);
   583		return -EINVAL;
   584	}
   585	static inline int split_huge_page(struct page *page)
   586	{
   587		VM_WARN_ON_ONCE_PAGE(1, page);
   588		return -EINVAL;
   589	}
   590	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

