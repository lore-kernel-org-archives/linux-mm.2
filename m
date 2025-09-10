Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC897CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10FE58E0011; Wed, 10 Sep 2025 01:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C17F8E0001; Wed, 10 Sep 2025 01:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9E68E0011; Wed, 10 Sep 2025 01:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DADF28E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:37:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8602F1DEC69
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:37:40 +0000 (UTC)
X-FDA: 83872233480.27.5DBEC49
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf06.hostedemail.com (Postfix) with ESMTP id DE046180003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:37:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g7fg1F6i;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77vy1X0DCHLYJOwirXuKI/eP7oE0tOpOs8w6ZtbzOgc=;
	b=NvLe/JrWM+mAd8AVzqParM4543OYdH9syuBwPBrH+fyaJpALvD4lFnGRZTgDS0Zn0GYndA
	9whwMGR1uFHrwcupMQaZnT5TpI8awCTuuFResmCYnKMiBQ5sXYRqr6QdDHnSiCel2EbLn3
	qcY/66d8/HdUUmKDSJWzwlggP70y7EU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482658; a=rsa-sha256;
	cv=none;
	b=0CQ4clrEyGya+ePopO6I+bV8QdBrCyiaQ9ApAZli3eyAubYCooGMpbPP8ItuwWtScZtA/S
	X12eMo53IdxP9zRvOB9S16zDeBgQ6RFMbRgTDZkLfmCwoq+57oIu5M6LS4DRID/chQMl/K
	y8RuuVRPnwN9GCirRV+XGs11MPPscm8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g7fg1F6i;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757482658; x=1789018658;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iHHgcPaCsFLf8MyTZq941AN7FvV+U2MejTzrTRhAuCs=;
  b=g7fg1F6iunuk9dHvLCQgpMtKQUAUpiVl8H8dx5Oy+fNRZgxHz+B7B3w0
   6IkNvpe2i6QSbSOig3m1PBbmdlMamfGTu53T0tL/NbqzTlzq/UGLf7KlD
   Ae5O/URCO7JfrNH8CwkWyI+bPKrjB5r6t/OwJwfrNeU+EwcKpVg68RpEt
   NjpadrhH56czyku+SeIPSim0ySK7PmB4rJG8XZwgU5TUlljD3RleiJAUu
   xWPTCdfyhBpgjJ4KuukM/YhS0Q4i6iAM2igsoluibcbKQnGR7W+1rWvi1
   W4ZV4fs1p/mIN+Ugw0RHp4Zch0IUSTIgLBY5QGTUHEryMV4o+61P8L/Mw
   g==;
X-CSE-ConnectionGUID: zTkA9C6KTDO/f0BidcPPcA==
X-CSE-MsgGUID: /9CF8xbqREma/0EWDZEgzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="59926027"
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="59926027"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 22:37:36 -0700
X-CSE-ConnectionGUID: 7HL6zpH3ToKbH420jadKEw==
X-CSE-MsgGUID: cRjqMZyxSg2zhulDnKc0qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="173677850"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 09 Sep 2025 22:37:32 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uwDWM-0005Yx-27;
	Wed, 10 Sep 2025 05:37:30 +0000
Date: Wed, 10 Sep 2025 13:36:34 +0800
From: kernel test robot <lkp@intel.com>
To: Lei Liu <liulei.rjpt@vivo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	open list <linux-kernel@vger.kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Lei Liu <liulei.rjpt@vivo.com>
Subject: Re: [PATCH v0 2/2] mm: swap: Forced swap entries release under
 memory pressure
Message-ID: <202509101302.pptHT8X8-lkp@intel.com>
References: <20250909065349.574894-3-liulei.rjpt@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909065349.574894-3-liulei.rjpt@vivo.com>
X-Rspamd-Queue-Id: DE046180003
X-Stat-Signature: ra5f3bikdbbw8quzagq5kc5uxhyh1ru7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757482657-486184
X-HE-Meta: U2FsdGVkX18QAEmUaKWm21+uwU+/qqsew92Ve5A3/5RfmqEfdCpgpKX/HM7tfqcEiN7wSD9fd/iANSRo+e+NnoTIjGR+O07ndEFk3WISlj35Vds7d8gXE7a1GU+wC6aeF37L6wOMQqIOxTFZURvXWzp2wmmE0HU1yBcAIdkOXV4UpiQfJxo/66l5ouVF1y9e6LSgOAezGr4TzvugC2OZumdKwYfbqv22cDcxY0yEPe4A/ojNwEHs8hWItXkkyn7vo01dtf9qhGb1CGUIppM/sR1UXkaRQ7MkGRV8Gdu02Wx5ROdDBQOpyzJWQ/RavK9fh9ES9SR3Rf3omiy151qF5+QuK7iiYwwnM3CIp62d3kgd5CmDALwfky4CxFsDHd2ew+hAoxa5+ON2XDw+rRe65pIZJsqGlHw0UnoxEZ0tu7MeSGSDG7jg/wNTfv5DcNMppja4brH490tXUonJUdeIztJI9/j0OlgfT0oO9FCLuK3wh1bdB31h58s+fjaFMt0xop8Y7/gCATweprXw8d4kh9ijPFDOxMEQ38YJrH/BAnoOD+kcdhNAIj4m9n4fD/8OmCllQSpWIOF+KI7j/FC4F3wh/bqwK2g5ZAs1scvJtvc+ji4rMfj3NCUJu5lWjxbkvvf8+aTr5zkxUz9tt11T3IwIebp5t9QhahJsmTp9hhHcunxgopKrfSkymK5MaIifJpMF+UdMjdFu738KDQx/Z2cr/7LyrcYqIbCYMl6wGuVRcYuLMlayT4rEUW1FYm8xxJWXGpE5ftoHfP5qVf6WmyHO3EifDOEFmyz9gIuIMACGIf2Y0fL/mZY9zhSZQ9TWWLShuYEzvKdTREyvNRr7HAmhB7wPwOamuEfRdwztQ2pKy8zCOe60zSP4lHNL81LgUfhZqEZDl3NVmiRCzjuoHGvbrYSrMDbBoI5Cykzp5F0cZVbUS5zKZb+taaOyvLzqo537Mes9lVHKTdSrhwT
 XKhEWsM/
 KkCHMqg1xHOnA9+BHvsl8ZDwo3ySl8IRQkdfk99U8PsWpRui5+0Y2apDB2l2bUCK37P6SnjLEgX9x/UUCYCi5QeiiwsL1mfUBaMg18636ZuNloEfwen3dGWAREUOyKKM+miUq4vlwMjL6obmeE2AT/R6sVGc+CviLL854I6dxkaF5wgAfkYJ/1ofErE/9muVkO4LYq+whkBwBT7Qvd0oyO3aJX6ZA2AXMsTd0W1rGD4WHX9GpR2nYJjAIzTTxZ/SnIO/GRPGb6yqEik6aqftri4cqFOd0fU7G7Yrgjjwm8Xrg47rRREAvP9pqYI81BcrDLueK5Tl1KkWGAArS5+DLpxHkiMtOKNQf9v9U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lei,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Lei-Liu/mm-swap-Gather-swap-entries-and-batch-async-release-core/20250909-145620
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250909065349.574894-3-liulei.rjpt%40vivo.com
patch subject: [PATCH v0 2/2] mm: swap: Forced swap entries release under memory pressure
config: sparc-randconfig-002-20250910 (https://download.01.org/0day-ci/archive/20250910/202509101302.pptHT8X8-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250910/202509101302.pptHT8X8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509101302.pptHT8X8-lkp@intel.com/

All errors (new ones prefixed by >>):

   sparc64-linux-ld: kernel/exit.o: in function `do_exit':
   exit.c:(.text+0x19f0): undefined reference to `exiting_task_count'
   sparc64-linux-ld: exit.c:(.text+0x1a14): undefined reference to `exiting_task_count'
   sparc64-linux-ld: exit.c:(.text+0x2124): undefined reference to `exiting_task_count'
   sparc64-linux-ld: mm/memory.o: in function `unmap_page_range':
   memory.c:(.text+0x46a4): undefined reference to `add_to_swap_gather_cache'
   sparc64-linux-ld: mm/page_alloc.o: in function `__alloc_pages_slowpath.constprop.124':
>> page_alloc.c:(.text+0xb44c): undefined reference to `flush_cache_if_needed'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

