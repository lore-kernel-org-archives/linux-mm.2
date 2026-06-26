Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C91CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 06:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B17A6B00F4; Fri, 26 Jun 2026 02:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588896B00F6; Fri, 26 Jun 2026 02:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49EF96B00F7; Fri, 26 Jun 2026 02:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 042C76B00F4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:05:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B6A0140345
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:05:37 +0000 (UTC)
X-FDA: 84921027114.27.AEA302C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf31.hostedemail.com (Postfix) with ESMTP id B673520002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:05:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A76i4hkm;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782453935;
	b=LXOLKBAPONupg8RfjUVfKQRnS8KmTIYTEwpCDauZDp/w23CHiBxbac+J07u2RiPkhPsMzS
	fhEYPKAof9XN70MSWG7TDuxoSfdKJ2II/JpW46caLsaXyiH98cI9Lv+7yC4e5VAabuYXyw
	w0Q/HEHh97IQAbDVNQaVALE+WMuIAt4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782453935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbM1HHmmYerBY+cGwv1Gk+qbUJl0B1Ap5juKKvEHCO0=;
	b=3ayqclVWvB1Hm2BZYD+Os9eN2vd1P3v/CQipz9n5ujwlF+Isj5LHCgXhn9QLQCg3cD++Q9
	viB29fbje3GO/Hx5As/ceqRQ+lWrkXXeond+XqAFqd2+lhTrHC17asymYOzEbWUF6vP+x8
	a9SQR1+WyMhzylOlMhdj0Ox6ID9s71w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A76i4hkm;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782453935; x=1813989935;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dT7MX0WfXC++oDnyN+rwSBLVEdZXSKQeW57y85ZLgfQ=;
  b=A76i4hkm5+e17WWlaVlhLOsxWsJTDxzNdaEn4wA39mikbYfIIfPUGWX6
   0Q3JYqmLN6Ist/jhd4xIg49wyF8ql79+wmkiSkPeLDf+nEX9X9srP1qQw
   fRDc/q3Xh2oIAoNS0IAYHO09KQ7Wi4P7Amyh7T3Z5vwFiLqkXD3AvqJyI
   fJA2R0frjVWw0EQhXUZZdsuUv07YoEA89FR77esk2NxTB2/eYNjrANFlK
   a4jlec8p+umo5PEy96DB73HsTWfVtQu/oyJBZf7SP6AUiSsPdy/W+Fplt
   Nw/69QhkUDzerO/odi+3YeL/rGXW/MBJTgfw8gkGw8kUytlSD7JtwNZjR
   w==;
X-CSE-ConnectionGUID: BS0Y7p62TLaAGYaBFKqE/Q==
X-CSE-MsgGUID: DQS+4dd1TFuSQWxcNrAD6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11828"; a="82362247"
X-IronPort-AV: E=Sophos;i="6.24,225,1774335600"; 
   d="scan'208";a="82362247"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2026 23:05:33 -0700
X-CSE-ConnectionGUID: 8O85bc2USKWYU4tHFPl8Cw==
X-CSE-MsgGUID: k5CiFcU2SQqlFNeUo0Gzpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,225,1774335600"; 
   d="scan'208";a="289346606"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by orviesa001.jf.intel.com with ESMTP; 25 Jun 2026 23:05:29 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wczgs-000000006f3-41Nw;
	Fri, 26 Jun 2026 06:05:26 +0000
Date: Fri, 26 Jun 2026 08:05:09 +0200
From: kernel test robot <lkp@intel.com>
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v7] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
Message-ID: <202606260757.WdVU9G1N-lkp@intel.com>
References: <20260626032012.1049667-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626032012.1049667-1-hui.zhu@linux.dev>
X-Stat-Signature: hoory69h778dnrjjbee7jrusctftffsh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B673520002
X-HE-Tag: 1782453934-56104
X-HE-Meta: U2FsdGVkX1/GEqfHpv+mBRpMX14AwfLIlmFArZxufkxUvjaVsCGgAjTfb/QS9YQ/wJRY49fm+wXaguMr6z0bnMElzJh1Zz2MpWy67nAsu8iQ68DbMu9huptvq3RUc/6n26UkFl9ctk1hS4vF0cOygHubfgiNcS71XMF4aWV6fUH3mFE0ZR2I56Ek0HPb/rtUJgMMjIs3voxdnZkVt7tN2/EO0WOdRskzfEX1LpECJdnL2FDXvYkvwl1cAqg7VN2b4KysD5EH4IyTItVcpRWN+nPD8uKG/yRg1woyVe5CjB1zzCNByivsrofGnH6awI4G6wi5Fg1f/u7dwG9rbZTo5WLSqKB8zz3KRKwJY3ZnI8sZQ/remstVCMkUdWiS0RWmImlZu6yyKYYLOxOJWZOAz4IUgwoYZrZ356mWIDKPsR0rRsC9/e0pmInqMUnjlk9BhsOEeCbUZE5AMqQih+TBo4CM6gjxNcD6WgsWax76+QhY0hKgNPZ1+EDSag1XBOSu7cP/bGLdgiDeMRG6pmbVIN0Td2+wpw/dif74V6WdpKszUFyLS9wgVVxLfUeQkyqL+pUPD6n4YCKplF0ObBBsdJ8TD7cUz6xL3B/RfrXJ3LSMdraErSL6u+8OEApiMrEAk/w1P08ti1736FimJVVfiCCFy2dmr44TECYuCFR86BQV/P9+qvUGBUQORzoEz9aS/T72QEZtPv3baYLOHHMSoLvIeN1oVORkoiAfVg/J9COBRIHCWbPYbPX/lsh8LbRW5bCxsoIc0TxL9w3Uuojxa1ECn5t4/lqEwzyinZxxw2mCdB7OSlJG1sWpYe4PBAPZjtd0efmKCEAt3x81YJvECFw4pEvC8UIYbVQID9m7bHZAB3YqzKtMnacjKs55H1B4D6yrq77vnWkvfeBxvosJr7RpFjzyiI0Nler9rEO4elCySMuOH+KiGO7Pv/NV2Qsky8U7nm3Rth6E/+HR4tw
 4NAAAgBj
 WXcCwWa/h7CA5yHfp47vty2IMF3MqsndHjg5ZcV0mOZKu0UMy4aYYQhvWsHbOEoXL26jhVvw+DVTsR5GBQBicUHOjesJ5/tsBUNA7YwfAVRCxVP4BK6LhiqI3n/wO15gk6Fc9mnbATqpEjjxPf/TsLEWmHd3S0nHD87NiibUDWzX5Nq3iu6IhUNOt9h8S+pxty7XKzEB+mpf42+VTdpAPSF0SjZcOPeMMkMmZ3B2xjw4UUJMBtdUD4Lqovem74iy7ZDu6v976nlY/i5P6i7JYUR1QCiGLwSFZ1mjG6m5Zmtvk4hILRNKgjNQveMRXBaIGIRVY3UaELhMN3N4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hui,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Hui-Zhu/mm-assert-exclusive-nid-zonenum-bits-at-the-page-folio-access-sites/20260626-112119
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260626032012.1049667-1-hui.zhu%40linux.dev
patch subject: [PATCH v7] mm: assert exclusive nid/zonenum bits at the page/folio access sites
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260626/202606260757.WdVU9G1N-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260626/202606260757.WdVU9G1N-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606260757.WdVU9G1N-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:21:
>> include/linux/mm.h:2:2: error: unterminated conditional directive
       2 | #ifndef _LINUX_MM_H
         |  ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:23:
   In file included from include/linux/writeback.h:13:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/x86/include/asm/cacheflush.h:5:
>> include/linux/mm.h:2:2: error: unterminated conditional directive
       2 | #ifndef _LINUX_MM_H
         |  ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:23:
   In file included from include/linux/writeback.h:13:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:10:
>> include/linux/mm.h:2:2: error: unterminated conditional directive
       2 | #ifndef _LINUX_MM_H
         |  ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:13:
   In file included from include/linux/pagemap.h:8:
>> include/linux/mm.h:2:2: error: unterminated conditional directive
       2 | #ifndef _LINUX_MM_H
         |  ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:13:
   In file included from include/linux/pagemap.h:17:
   In file included from include/linux/hugetlb_inline.h:5:
>> include/linux/mm.h:2:2: error: unterminated conditional directive
       2 | #ifndef _LINUX_MM_H
         |  ^
   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:9:
>> include/linux/mm.h:2:2: error: unterminated conditional directive
       2 | #ifndef _LINUX_MM_H
         |  ^
   6 errors generated.


vim +2 include/linux/mm.h

^1da177e4c3f415 Linus Torvalds 2005-04-16 @2  #ifndef _LINUX_MM_H
^1da177e4c3f415 Linus Torvalds 2005-04-16  3  #define _LINUX_MM_H
^1da177e4c3f415 Linus Torvalds 2005-04-16  4  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

