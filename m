Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E71BCA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94C48E0003; Fri,  5 Sep 2025 10:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C966B0007; Fri,  5 Sep 2025 10:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A829D8E0003; Fri,  5 Sep 2025 10:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 98B796B0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:23:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39FDC1A0236
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:23:30 +0000 (UTC)
X-FDA: 83855414580.20.411D366
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf28.hostedemail.com (Postfix) with ESMTP id 263BDC000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:23:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nyK5zd5I;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757082208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zKIawRGkQ1oNY6imJm2+Vz4bfWaTD1iiGqCi5EFkJ4c=;
	b=v/aBNYCGKpywOMIfwXrtgbPsV1IHgIqLE/l+XXr5jCc0UNVppCZ4P2K0dyqT0hq7Igp+wL
	9qdYTUs5DQcrTJ0m00cWPWJzuSTC83W+xnMxvdXkMsQfY6eAZQ802ft9FvHu3/qiG01LpZ
	bUOIdS3i1mjNuUANqX3+lJJiQ5fiwac=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nyK5zd5I;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757082208; a=rsa-sha256;
	cv=none;
	b=hG0D6wGETzmzSfj4g4+gxY5rOdlKg1F3jqcP2zZA89J8Iw39bOKBPscmCzRpgR1UBXw3bH
	sAwTGVvpmuEXq9TYPqpC8HusAF8b7uBjp/Gizaejq1g2cH5/e7NWJIGJbs//xNV1KdZBEe
	IOInedgMERx/nWqGynMOAKcc62cahMM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757082207; x=1788618207;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Ly1A1t8zkl1UDjDmh1rwf+3iMany95fQ+o+inhdQpTM=;
  b=nyK5zd5IIyth8i8QLmi5yVxcnoc0QVCbGKBVVsdFkR7nk41py6xfbEO0
   oRE+ieIkXSm6rtAw79Fv+UiNrq0o1hyMhaGieGKPZo23LBO0N+laohEWZ
   zU0743bqzKvmclF7Dt/u80cDceSfoGvEIai1Lwt7RpXPBkTUH0n1xexTb
   AsDgFNjr0quSyVMSaR0sl3raYr07CWLNdkMwIBByvL5lZBKG3w8UGIGT8
   9anDJNSRmAmVohhaH2OgmTWEYIZc9oRnekhE3iq1MCw9XZL1ohrkrdnNp
   NNtc3AZhlMyG3OUX5xeSi847wTVvmBMzx1ZM2cdkZNsVAMIVJxaQiIxBy
   A==;
X-CSE-ConnectionGUID: bxdon4ulRtiEGqsfE3QeMQ==
X-CSE-MsgGUID: 1JdCIdiySs2bA2xvpAR4tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11544"; a="84870608"
X-IronPort-AV: E=Sophos;i="6.18,241,1751266800"; 
   d="scan'208";a="84870608"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 07:23:25 -0700
X-CSE-ConnectionGUID: 96JjQF4cQleGatjBOlysKg==
X-CSE-MsgGUID: /CWSAJoIT8a9uzcDYukCJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,241,1751266800"; 
   d="scan'208";a="172050926"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 05 Sep 2025 07:23:24 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uuXLV-0000VD-21;
	Fri, 05 Sep 2025 14:23:21 +0000
Date: Fri, 5 Sep 2025 22:22:34 +0800
From: kernel test robot <lkp@intel.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 332/339] include/linux/huge_mm.h:591:16: error:
 unused variable 'folio'
Message-ID: <202509052234.q4rNraUm-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: eufrkf8r86ouy4e4hwdjsth3odfju9ws
X-Rspam-User: 
X-Rspamd-Queue-Id: 263BDC000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1757082206-161257
X-HE-Meta: U2FsdGVkX1//NOhyrPtQ3vZyKKn8ooJRyodpUQgWXIO4SYVosTSjpFXKK0XEdIKzWaejqDye5TEEW5OL7VgYeRP3KBnfjoXV3y4kaStsu8CQREnP7+ziOZTlnjP/jSWmIAzzTUEDgBTXMBtmgLYDCi1BysoBLVMr4O63Zku+gB0821rI7/1o/m2EI8z8+zRS8Pq+UCDA3UMMfY5RkVcTiYTZofQrbbA8MNqbOoYn1kY3VPIvofMrl91xSKV6mpbGJmDfh7mwrmUpOr0MkJLWmTIi7ZbSMBXAQ+dLaGRBMomAZLBk1tNi/AVezg2tUgmuehE8tW/zna0BKfqEziJuq/pXG5gKlmTY31+UaUxczbo67v9u9iB8Tgbnsf3aUtjDE7IfdGhueWKHWGvL9bGPLWua0x5PSQoJ+wCqclwNabtN2GIRAsw4b5PjUVzQMX8J0SJGfbYajEYVLRx/9AF2OdRuxOZFjzcCo33H0GRnEhZ38awWbYkLkRDb3zgT14t+XwhO0rY8vmDGZjhes2B4pxE8AC5DsveS1JSm9IVvwZJLVmJgaTq1Qb17WLnfOomxrMU3EBckvd41/6TNVHfK6I1lFta6LqYvCfEcJDdcZQJWk6a1RzOAIZFqHW0TWc49Iz5PDYhMNkXPLoBkREcvInYO5siBZXj1ZbAlsbuzdrqPnzA2n98uCL0Srio1jf5n5wvhA7gydG++yWCPRUVgmolp20h+1TgiOmu1qVOpAAz6xLFV3ur3uig+gD2O0GGUI+rFGyNv4VniOZsJGx29V0QnoDgyZEhN754zyQQP78oDpnYdBc26mV5U4b3ma6jTju0TNsz9GTEYRGrjIEQBlr6CkRbOvLMkH+90WKrKfxJNZtvG4yA0onljwmwD+W9H9imxa+Q4Nvqy/JdOZ74N/2ubmApsh3111CMzo6ycC+oTRZzr2RWo1vicOg07CftuX97JpRIs69X8laOFx/L
 PsKI+LZT
 Ib9OGf5rbZPg8rLzf8uuAGF1U2S4LtZAzegubfuScrhxMPX8BxE9e4iZwFmy/EP2dU/t+nycjLBdlovNuijoK3PBBULbCFmtFv80Sf8rgYystM2HCwd5GmezrKN9QU3W1S89ybGkOdqml0QIO90MnlWWw9v09RLWy8Bh2NyZdp9KqaIE4zseJNlbiTPsaWvlDeajDGrjoPs2TAu15MP5UHnMIW8mVD59LdTwGbMDdiobkKExqRXrZnITuDFOAagV+fOPIAGdNa4orvl14K9Yxn5D0zY+FSrp/yS4z7O2Rr2wyNtTD8TOO8O27Ho0a08YFU59joxNEQPSF69cmAg2ntmADoUZ4bO1CtQq61KOjhoY3f2/QCxVnXK7WJt6AA3/E8GuWNjwXR+WEP0ipNnkowBCGTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   0d1fe06d55b12fa3b8907412d97541b2b7eff16e
commit: c0b55300a1dec35aa8bad62ba520e368c9b1f041 [332/339] huge_memory: return -EINVAL in folio split functions when THP is disabled
config: nios2-randconfig-001-20250905 (https://download.01.org/0day-ci/archive/20250905/202509052234.q4rNraUm-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250905/202509052234.q4rNraUm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509052234.q4rNraUm-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/mm.h:1081,
                    from include/linux/pid_namespace.h:7,
                    from include/linux/ptrace.h:10,
                    from arch/nios2/include/uapi/asm/elf.h:24,
                    from arch/nios2/include/asm/elf.h:9,
                    from include/linux/elf.h:6,
                    from include/linux/module.h:20,
                    from lib/test_bitops.c:10:
   include/linux/huge_mm.h: In function 'split_huge_page_to_list_to_order':
>> include/linux/huge_mm.h:591:16: error: unused variable 'folio' [-Werror=unused-variable]
     591 |  struct folio *folio = page_folio(page);
         |                ^~~~~
   include/linux/huge_mm.h: In function 'split_huge_page':
   include/linux/huge_mm.h:598:16: error: unused variable 'folio' [-Werror=unused-variable]
     598 |  struct folio *folio = page_folio(page);
         |                ^~~~~
   cc1: all warnings being treated as errors


vim +/folio +591 include/linux/huge_mm.h

   581	
   582	static inline bool
   583	can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
   584	{
   585		return false;
   586	}
   587	static inline int
   588	split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
   589			unsigned int new_order)
   590	{
 > 591		struct folio *folio = page_folio(page);
   592	
   593		VM_WARN_ON_ONCE_FOLIO(1, folio);
   594		return -EINVAL;
   595	}
   596	static inline int split_huge_page(struct page *page)
   597	{
   598		struct folio *folio = page_folio(page);
   599	
   600		VM_WARN_ON_ONCE_FOLIO(1, folio);
   601		return -EINVAL;
   602	}
   603	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

