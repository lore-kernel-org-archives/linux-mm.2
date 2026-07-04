Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B3DC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 08:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A3E6B00B5; Sat,  4 Jul 2026 04:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272A36B00B6; Sat,  4 Jul 2026 04:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B0916B00B7; Sat,  4 Jul 2026 04:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5F246B00B5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 04:30:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EDA81C7D7D
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 08:30:36 +0000 (UTC)
X-FDA: 84950422872.27.E281100
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf31.hostedemail.com (Postfix) with ESMTP id B1AC220003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 08:30:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="El4IYi/X";
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783153834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFcCiPPhlX/U5Kvgge+HW4l+OyQlp34Fd15hWjGywEE=;
	b=ef2Skb0GJVQ7MGN87mHV5AgxiR6FEOzxn4r+vwymQi+NgU94f9Pae7aYNhl6IAcV+lRK2b
	Kkxm9pCNva+k0Fjb72ou23rrTFkONdlH6F/be8KxGLjbOAWY2lVta+R8GeEwIGr7GEQJq0
	A7J20qt010OmgMldWbLUys3Zzbzg9Po=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783153834;
	b=PIpGwOj8IyhMGJfqpKitYLPige7+sUwFViYrpAibOFPbopGhhcFbSLp7Ov8Gb/bHuaehxs
	0FjaeUvDOHmh/E1Wjdh4by4eJqy1QEs539Eqv/hxGD76yyOd4bQiMu6dHqE/sOFP0h8JlA
	KgsacFBp9PYAp9yIayB6Q8L87FbZWlw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="El4IYi/X";
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783153834; x=1814689834;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t8Wve+zCGKQ9qOCHG69zYigboHkp3m6KJ8RSx4VkhPE=;
  b=El4IYi/XWHYB3YlGWPPEKqNlfxBeCPjc6YDFkcJy0qloj9eRUjCcFnq2
   7izzLx3QV77BZr07s4WcHz/8MgdbSspjOR/fPGefSS2XdtSNYJHWy7b4X
   DWhLum8tEQWNOvTbU6sVYwPTFLP9eL6BjRKEHD5S7Fy2cG1KNnl0b9ZtD
   Kh1to+O4Ff0FwN6yyW9wd6xwQ7qUBPabA1ONI+K4jplqsbhVYZa05SxgO
   la/1vQige9/F/QGBrc5ZZTnVi7djz6SMSOt0OhxHYUbtLyMixH/XtNOks
   OtxoSt9ySSQM606EL5MZ4QW6DPoqR7EGmVyaji32WfZQhpeX6CpHx6yfL
   Q==;
X-CSE-ConnectionGUID: vay1lJu2TzmtR05lQ6gk9Q==
X-CSE-MsgGUID: 5kE8ZQFtTG2F7h3SqvPJCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11836"; a="83857664"
X-IronPort-AV: E=Sophos;i="6.25,147,1779174000"; 
   d="scan'208";a="83857664"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2026 01:30:31 -0700
X-CSE-ConnectionGUID: bReUGsfpSlSm2vOZCAt6Tw==
X-CSE-MsgGUID: WP+DAjrSSTG+XLB+CbU9rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,147,1779174000"; 
   d="scan'208";a="246889760"
Received: from igk-lkp-server01.igk.intel.com (HELO e5a8ed462067) ([10.211.93.152])
  by fmviesa009.fm.intel.com with ESMTP; 04 Jul 2026 01:30:26 -0700
Received: from kbuild by e5a8ed462067 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfvlX-000000001iZ-3y0d;
	Sat, 04 Jul 2026 08:30:23 +0000
Date: Sat, 4 Jul 2026 10:30:05 +0200
From: kernel test robot <lkp@intel.com>
To: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
	ziy@nvidia.com
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
	riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr,
	kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
	linux-kernel@vger.kernel.org, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH v3 11/11] selftests/mm: add PMD swap entry tests
Message-ID: <202607041039.WHXO0OYv-lkp@intel.com>
References: <20260703173903.3789516-12-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703173903.3789516-12-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B1AC220003
X-Stat-Signature: 4ekeemot44t78sprey4h4hi89aozfh3z
X-HE-Tag: 1783153833-578766
X-HE-Meta: U2FsdGVkX186RC0Q7n6RGK17iQE6R5nPc5/WG5PGarmID00rl7MgVlpqpaIou3kxCOaa2WyZeNJYopnlhxPNibFbseiw1Z2apgJUiItKcLWpNyEDIBZxQVVKSD7AilA307BVSxYD/llExnBxJ3DmFr6E88wZZ33+eFuTNl5KhH8zDpyuICbvOqwETQ1hBNa+bE5FHTcApX1aekh+OiqeD00g3VEURMz3uW7fQMpm6gkQKe8NeHGdl6aYQRD6A17fXDySnXzjHeDJQbFFeglfz07BiYzU5d5UxiePWBriqn+nO4eibjOJnd6V+14EoueQM0OosDEEdVZu5S+kEO2sEnMjTFcCGMiCAO4gfrhPeU4dHlU0i/9LudAaqusK6CTg3lv0lQd+2onJz0s5tJZGfsqlhcLnzRxmsVyXt4Zftxu/4BT1XDFs2z7Zniwu9kuQd8pBlhom47lcHHT/ftwpNXKcSsv/1XJH/wbctNfcAAKOb+tb+5YKSOJfASezQfRf3AqzsFi+rcZ4cj4aB00mP1bclVuvPJikeL6QDVSJ14P+S8+U2Qodt8WnyyIlxRG9cGqsrjZXWIyACA7dbCC0c62In5DJgwSbC2n2mS4yltSYPdvgwpW0uqgCS3wcceyGH6I+SLrvdvvLUt4UMcpSI+mZcqTeBxdIkU5rcbXq8xQtwznTujaux9WqRpNL4OeeTBApdDkh6W9jN9SRMDNb4X25DVjnFlZdIzq0Z+X2n+vVha1Ib2YiDwaCkKQ8PleksOfa4myIbbEvX8cM+pepYW6n0QC+r0k3lkzqqbJy86C5N/MobUQMY2T0cj67D5cuwaWPlJ8cd2BfVQd8zCvJ2ftAlyiW4xS1WX0tIxHnmdGY1jGCwNEt65IMiRh4nrm27bKFzsqML7sB4LW+CaFiY2ncbUUDRu82tpW8d3cVYTYHHoddFt6qsKfnT0oS9riwDiAa6xpMVZBmmsZjMz+
 r+D3FmpE
 4yIE1dGwxZfzsvEQbBFEzGgdAqoyMVtUVaOgctk73yOywm595AZZA1DT2VwRyMdwM0foj/ofhcXfoCAY3iKcc9iktyIAmbKdLrl9G7G06Yo/CbvJ9WQdCP4ftr26QW6i6kKzT+VhNMVR2nGrf3V5GVNtRg7s2VnBDtW+VVLxSQ1VtKPgL4CP0SdHdDXE2CGbCYuDeqkUzXTUtac45smypcdxJjJL+R791DuwCMFvhIh7ucOfHIiXMPkoOZfCf5CZl0LJWgGg3mbyB0glQQfLiiosWyeFt12txwUto/DZ2Ip4upXvIZybHNLpbZ0eJgw4N8dQ0hTi4erNSwyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Usama-Arif/mm-add-PMD-swap-entry-detection-support/20260704-014151
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260703173903.3789516-12-usama.arif%40linux.dev
patch subject: [PATCH v3 11/11] selftests/mm: add PMD swap entry tests
config: i386-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260704/202607041039.WHXO0OYv-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260704/202607041039.WHXO0OYv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607041039.WHXO0OYv-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from ./include/linux/mm.h:31,
                    from ./include/linux/memcontrol.h:21,
                    from ./include/linux/swap.h:9,
                    from ./include/linux/suspend.h:5,
                    from arch/x86/kernel/asm-offsets.c:14:
>> ./include/linux/pgtable.h:1921:21: error: redefinition of 'pmd_swp_mkexclusive'
    1921 | static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
         |                     ^~~~~~~~~~~~~~~~~~~
   In file included from ./arch/x86/include/asm/tlbflush.h:17,
                    from ./arch/x86/include/asm/uaccess.h:17,
                    from ./include/linux/uaccess.h:13,
                    from ./include/linux/sched/task.h:13,
                    from ./include/linux/sched/signal.h:9,
                    from ./include/linux/rcuwait.h:6,
                    from ./include/linux/percpu-rwsem.h:7,
                    from ./include/linux/fs/super_types.h:13,
                    from ./include/linux/fs/super.h:5,
                    from ./include/linux/fs.h:5,
                    from ./include/linux/cgroup.h:17,
                    from ./include/linux/memcontrol.h:13:
   ./arch/x86/include/asm/pgtable.h:1532:21: note: previous definition of 'pmd_swp_mkexclusive' with type 'pmd_t(pmd_t)'
    1532 | static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
         |                     ^~~~~~~~~~~~~~~~~~~
>> ./include/linux/pgtable.h:1926:20: error: conflicting types for 'pmd_swp_exclusive'; have 'bool(pmd_t)' {aka '_Bool(pmd_t)'}
    1926 | static inline bool pmd_swp_exclusive(pmd_t pmd)
         |                    ^~~~~~~~~~~~~~~~~
   ./arch/x86/include/asm/pgtable.h:1537:19: note: previous definition of 'pmd_swp_exclusive' with type 'int(pmd_t)'
    1537 | static inline int pmd_swp_exclusive(pmd_t pmd)
         |                   ^~~~~~~~~~~~~~~~~
>> ./include/linux/pgtable.h:1931:21: error: redefinition of 'pmd_swp_clear_exclusive'
    1931 | static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
         |                     ^~~~~~~~~~~~~~~~~~~~~~~
   ./arch/x86/include/asm/pgtable.h:1542:21: note: previous definition of 'pmd_swp_clear_exclusive' with type 'pmd_t(pmd_t)'
    1542 | static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
         |                     ^~~~~~~~~~~~~~~~~~~~~~~


vim +/pmd_swp_mkexclusive +1921 ./include/linux/pgtable.h

  1919	
  1920	#ifndef CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF
> 1921	static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
  1922	{
  1923		return pmd;
  1924	}
  1925	
> 1926	static inline bool pmd_swp_exclusive(pmd_t pmd)
  1927	{
  1928		return false;
  1929	}
  1930	
> 1931	static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
  1932	{
  1933		return pmd;
  1934	}
  1935	#endif
  1936	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

