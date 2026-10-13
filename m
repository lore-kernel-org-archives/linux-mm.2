Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBCDCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7A46B0088; Tue, 13 Oct 2026 08:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188496B008A; Tue, 13 Oct 2026 08:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E206B008C; Tue, 13 Oct 2026 08:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1A676B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:18:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D142B40C10
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:18:52 +0000 (UTC)
X-FDA: 85317506904.08.1ADE093
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1FED880005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:18:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="kG/tHQvm";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791893931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ALm7soh/JTUkJUHpmt2o8VqD7+cGOY4OrpGT93h70/s=;
	b=IXyKHI0FdQBT9k9p95Dk/duW8p5jqQjHL2kOacMNNModNg5PcHMx1PkWlNFgVQuCra+5D+
	7EJwq27qOxcIxxayvDf1RmZFTfmaSeN1vLAEjMCTnz+uKx3aCf8C5wEJyIlkBjpE16Jhld
	TPc9zDs4KyvaeZ28HpbXVVNFUPRYTLY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="kG/tHQvm";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791893931;
	b=rlUSDtUJ/KDB/B3ZPrzseW+y/1XXspv/mDnm8K64Y3bM3iCs0Lu+DFP454B2Xj9iXkYAKK
	HdgfzNeem2YBzqbDXYsRZ+INLDgHRYv+1eWvPgEQJwpGZ8Mo0UyCyJ/bYqT9SKrhH7f1Cd
	pJXpj/jEPo06V9N8JQ/TeZMuu7ARt+M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791893930; x=1823429930;
  h=date:from:to:cc:subject:message-id;
  bh=R5qQrym39cHyGlBkeTRcjgJWXjS1CQRn4cl0zb0rtCQ=;
  b=kG/tHQvmuv3UZQAEotTJIYlKnQxzdrxBtD3jiohW0Yiio/FA3pSexv1L
   a2barP7xFzrrJH5QWgLeApAD8woUMHZPgJDJEmVim633Ze1/43J9VlOr5
   pZNLbX4ckj0MKkcXWymTeDCE+gnoxEiDyB1JmcwfeM5200CiVEJq7jgSR
   XLSJEeGr7ts0DrTVG5u37xsuTrXrLL56ManFDX4LyM2qvQeMJ2isOriZU
   DR5SFDOh5nN3w19jEtVaiabkwaYWuRuoMwRa+69DO1kj1E/BjFTKiO2ZC
   9oP1B1a8z00WyGm44VCZY9KKuKlSDLw2GSrG7TEQVf0PEQs7pBy/I/CUb
   g==;
X-CSE-ConnectionGUID: yyu3WmXBSDOr0pH7iVv0vQ==
X-CSE-MsgGUID: u1r/jI3kR9ulKP62bvkNEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="620203"
X-IronPort-AV: E=Sophos;i="6.27,155,1787036400"; 
   d="scan'208";a="620203"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 05:18:49 -0700
X-CSE-ConnectionGUID: 8ahP6q1lQJ+ch0B98VnhsA==
X-CSE-MsgGUID: n7a/zTXrTZCeK5M1hrexaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,155,1787036400"; 
   d="scan'208";a="1262157"
Received: from igk-lkp-server01.igk.intel.com (HELO d0de6c2a75a7) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 13 Oct 2026 05:18:47 -0700
Received: from kbuild by d0de6c2a75a7 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xGbSu-00000000AUx-20is;
	Tue, 13 Oct 2026 12:18:44 +0000
Date: Tue, 13 Oct 2026 14:18:21 +0200
From: kernel test robot <lkp@intel.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 183/193] arch/riscv/mm/init.c:1544:2:
 error: implicit declaration of function 'free_pgtable_page'; did you mean
 'pmd_pgtable_page'?
Message-ID: <202610131439.F2KDdzRA-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 1FED880005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 4uan19t5fexqbf9s8c6xtrdw3k3nytp8
X-HE-Tag: 1791893929-794528
X-HE-Meta: U2FsdGVkX1+XvkERZmQOqIp7W5QKELQWVLyWnUBfYwtuR/Mmcvk+5axoMMycESjyM0CX/oNwd/ZDFNC3/auvfS6O0TC4fUkAzqyDT02v7NBYgLtSM2X/E6L9TUZM+JYYeL8jGevXUnPqsbuERc7CFBKLwqZlJuGG9n3i7nwe8MMsOlH60nauLA+BGoQx2D9YGcaVB33sjZeo99ERVt9naldDtsHt5I9+IwUGuLF++FQcPMIBCTKFT/KpGxO5n5vre06fuCubiu2AO3CwsH3VYtquD0UKhUasFs7jhTjFqa8bcv7deOV8tfaT7kwTTZd5Rnfm6dNRA/Piu73ntVM7tnWJ8OmzSiJdvyL/ZsdUVgOG2UTLTjvcLMtKr+OaB9j0bxIoYc1BCvhgv610L1gTaT66VFe/PodUfk5SW95GnAQpdsq7P8NJSFhtM2lbO6X7wojM/O5eW8ZWbz6CUTu2CJugR/WJPZINZq3fvubX9kmD/S35N5HiE8vlRzmHWETLvjMKZMW9Bs3oeOTVElEUHxjGgiSunAf5YrOqnki+mXtoArFsixK7OPeGN/EXF3qYWdxFdVDNyVOl/euN+exhDgBMkqdFpaca+6P1alGQuZ/4mRCojjLOo/YQ+6YRvBGa2GsVqhwtA5LLpc7Aj0C253mvxEaSFsrzroGImc3qEh5xsjvrsL2xwZFYsfzLqiV7xD8kYdLPd0hWF6qlqhvZ0W+hqOoisd68XT2vljnY7A+/cNXugGJnuUXDTRKUbQVJ8HGMc1QL9gijM3/cl7Un2yp+V8FpPWdTbr8/yTuaHXXi5CEMtKdM65BNnApG17vHPETayHbgyul6WnUFXIIw/Xqu/o3DXZbM7zWsnC+Sqf+oZQNO4WrMoH+sgSM/+PNnQWQlzwi/bE08mXHgHA3uZ1fFCeNXSQSJ/nXSvLTFwUrr0xqjC15ujMdZVsJB0WXJFRnCzYxi5+5piNIjy0U
 yFHczWbJ
 21NBd+ZaoDRHpP827M0F0Ug3J8X/oin6hcAH7+m7E/BntVhj7VwZE3n8sv02YHlaThC5GNd7iIadgTkd5/6OOr0wsVHVFPbTZs6/BcQvRzMXJqrYcfAfPqZ3obItPFl1LYGQJiJ9sG1IJuMC/j1s6DIZJkjJydt7ZE/JXC4mZ3bgA/N49APnPPYhmq4GmRIZbqVusEsnJNd6bH/7iIDoeEfyyJ4HZ+AQSbgQjhOfqjQXDv5jW7kJtSc3okJjcPYCsRxDjwJcD/4wnntKDssHk2UeSJaq0JxiTnh2s9RaxfGDmcPe8i+2ITL+Mgd2lG2yBomt8HUsEBmZsdOh9WBc9lD+2aVPhkg4TkGThsvgkt4xL72oYEOCdVYyPkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   7186f1bd21b9094cc063c10f8492fd135522d3cb
commit: cf6402c085736133c835e1f815f79e7e1faf97a0 [183/193] riscv/mm: fix missing destructor for hotplug PUD tables
config: riscv-randconfig-r2109-20261013 (https://download.01.org/0day-ci/archive/20261013/202610131439.F2KDdzRA-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261013/202610131439.F2KDdzRA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610131439.F2KDdzRA-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/riscv/mm/init.c: In function 'free_pud_table':
>> arch/riscv/mm/init.c:1544:2: error: implicit declaration of function 'free_pgtable_page'; did you mean 'pmd_pgtable_page'? [-Werror=implicit-function-declaration]
    1544 |  free_pgtable_page(page);
         |  ^~~~~~~~~~~~~~~~~
         |  pmd_pgtable_page
   cc1: some warnings being treated as errors


vim +1544 arch/riscv/mm/init.c

  1531	
  1532	static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
  1533	{
  1534		struct page *page = p4d_page(*p4d);
  1535		pud_t *pud;
  1536		int i;
  1537	
  1538		for (i = 0; i < PTRS_PER_PUD; i++) {
  1539			pud = pud_start + i;
  1540			if (!pud_none(*pud))
  1541				return;
  1542		}
  1543	
> 1544		free_pgtable_page(page);
  1545		p4d_clear(p4d);
  1546	}
  1547	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

