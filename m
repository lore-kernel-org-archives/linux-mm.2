Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC944CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246B66B008C; Fri, 29 May 2026 08:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E646B0092; Fri, 29 May 2026 08:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134D36B0095; Fri, 29 May 2026 08:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 049216B008C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:48:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C95D687871
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:48:22 +0000 (UTC)
X-FDA: 84820435686.04.185B258
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5D879A0009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:48:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DXlwZEPm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780058901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mkYD/Al3N8PtfGcjNcdeq1qN9B7ZvocgPMR3slOBtZE=;
	b=wpkyRR13X8ts9/Lq6abYRJLqInYpTTdeUn/BaVBZIzmrbMX09EXopaGkeMGabAbXWnVMxd
	KOzm+Bk8IRHdSAg8ImEZWHe+nFjKSy5fEykMX9p3B7WUrphufppt6tEkpLqKhI+w5hVyyL
	SCG2ZAUKz2oxZUKYhW7gLznMu1nk8eg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DXlwZEPm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780058901; a=rsa-sha256;
	cv=none;
	b=ifX5bITX+dreO+FX49ktSwNEREZ/FQ/r0Yhs8c61Rf4qyr9we+mzt0AXp2tP8vwCQccsg2
	lqZxeEoE3sH+0r9HqVOL2eaAEjZTUVHBB/X2H2kuHj7BYwb61ZHo1uiTZPiVxI9zaMCwAI
	QzUmCv3igOvtKKdUZ+PT+A50T6Y6E4c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780058902; x=1811594902;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HO1WR6twZag3h0xFdgAKX/czudAafCz+VLFaYqj8tHY=;
  b=DXlwZEPmwzPJCFfI4nt20EIlnbY8kP872ZCEwEdzVslEgsGPEc4rIc9Z
   EAifT+cfOeO0ZCgryt70vQ1vg6EWrg+DGACWT9DDlhYGYzl7rGbRhnryp
   zrJscOR1JGmXyU3rsX3DsGuxtSE2G1IY9vFx7xBQwuRUwd1cTdhH5acMQ
   WRWHTL59bflzOXIhVaWMNEgdP9Po0NxuSaK+uJep6Vj2y+Kg7l6uTtwMd
   QPFXMRo+OhiCAi7bio93CDXMdagMJOdZ+LNnAkHzWcfyHiT4mKKQL+1tY
   w2e3scZ9eRu8iu7Hg1vScsVGnzyE8sFxHnsX4udM4kjfN9HaWZCvrV5Ar
   g==;
X-CSE-ConnectionGUID: FZAfD08PS06xGi1+crVKVg==
X-CSE-MsgGUID: RQIH54XeSkKRtSZgz8ieuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="81092968"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="81092968"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 05:48:20 -0700
X-CSE-ConnectionGUID: U45MxQSeSeayqC7nDdmzOw==
X-CSE-MsgGUID: lttKo//4TxeWrxIwEzQrzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="240294353"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 29 May 2026 05:48:16 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSwdI-000000007EM-3wbN;
	Fri, 29 May 2026 12:48:12 +0000
Date: Fri, 29 May 2026 20:47:17 +0800
From: kernel test robot <lkp@intel.com>
To: Yury Norov <ynorov@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Yury Norov <ynorov@nvidia.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
Message-ID: <202605292049.eaIv99hr-lkp@intel.com>
References: <20260528190337.878027-1-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528190337.878027-1-ynorov@nvidia.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5D879A0009
X-Stat-Signature: 131ho9beh8nktgxsy3zetwxk5eppm1z8
X-Rspam-User: 
X-HE-Tag: 1780058901-324926
X-HE-Meta: U2FsdGVkX18jvZYUZLBskfTemyYRtpa72hznSHFtu8o4RTvmZHDGo0PMnb+TnNhsfsTaOlGJRXXMeAL/idwfmkMxz/K4uGB2uftn9Ge2GUBZzIk8b9MCdEcPQZGHXnQc7pO56i20xRyaZnQGg6yb/AVsl5lKo+KLhZFRk5exE8Bit2DsDUhFJZftBqv4H4y2RR0HLKfYXBtYMhWUy7yDdIQ/d6FVKYxuvbyP2N2H0lFlTwvRbYhPDSWOHXPaO3h+Tr5haKsTupm9GBHUGqt7m5PlBYtn+F6xWJWcNJp0g/mqs0CUKJ6lVlR7pMGEHNGuDlgvIMY00IfemiRlugg3SE0zoBtAGsVgBvGsGP05f3sV3F0S/aYOIyDd7nyhCjwgRUqNlWExI39jxI+qMAiIM3UHiKK43lfjN45wGKHOj3ldq8eZ8zYKgvOt1a1qg75KG8O8MvMKnMOmTQ5PI3tXzI4IaI8OfGHLekHhAPkLu6yL8qUqjJAdcZNtNvjMxeiKxD9rJ5sy0E6K7Q8qto11qQinucc/h7uZGb3xWMOMthhfNQlQW8k+odqdD0zgYQa4w943YdvFhuLBeed68IFqPFifckWuxOg+h8OekzOIvt4yQ9Y7vzkB5x5jvd9MxGqxfYt8PTmidiOYLoY4cRVGqzHkfxSP0gAQtY37mzy7Ld5W+ID38fGr/huSaD1qQHMm0zk1virFUBpN+do6ylB9fGZiE2rZGAF2cZRNMl/iEnk8bJhB5cw0joqOQ0rkD+TSOmPsB0PeIosRgOQFCM3GGFttal9dBjNOEVhXIWhFmOXtY+ReOfEi1UtosAjgOSW5e4hDQ5NVUW35zd6qxP4/1aEqTLstsnFyg4AbKt8dviXNLZh8yZW8pcDwpxn/zWXIe3wuu2Z6u4RCl9y7JLExCsjOFkGhndiLbP3c0oczsQPtOubx6i2oo2Mfie+XdPkrWEicn93BN4VEpPUhJ0t
 PmhdI0/t
 xgr8xTjp96VOgiDSw3R4Php0zAwFGRCwFCLyo8/fN7LwkF+66+xDA4qwNNbqtSmXwr43hx83dmlaJ4Px+sVWkNm3z7LStka2Kj4G5ap4ovKd3CXyIhrmiVKRZPcUcU7EViQ1WDYguUTSAnFH2AXd11sZiRaeL0/ohPRR9vBpx5ZTOnRtRR9EZ47D9WU/P7Q6tcetA+kcPtPp01vu+GHg7X2s9vk4J/2x8M/Hd2oWFKt4KOTWMsI53oeuv8sSqvR3p0KgIeod3xyLQ2MLYI2DtWVV2IP4epFA9ibkNovQ6wqDq6iTdC/uMpijF0VkaQwoIMZCS6pwzr004qzSzLlkUzPi2jSgvls0NOI+jUEAPd5b6Edjq5X8GrrT904II7U5siQTtCQn//Mdcw4nzlcVaBix2A20wWpj/ck79zvrKuDnS+3SVf5eCYkZ4q6xpfy2Is6Mb1VpFYd4YBpZe+kyEwuknVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yury,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Yury-Norov/mm-don-t-allow-empty-relative-nodemask-in-mpol_relative_nodemask/20260529-030835
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260528190337.878027-1-ynorov%40nvidia.com
patch subject: [PATCH] mm: don't allow empty relative nodemask in mpol_relative_nodemask()
config: sparc64-randconfig-002-20260529 (https://download.01.org/0day-ci/archive/20260529/202605292049.eaIv99hr-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260529/202605292049.eaIv99hr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605292049.eaIv99hr-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/mempolicy.c: In function 'mpol_relative_nodemask':
>> mm/mempolicy.c:377:10: warning: 'return' with a value, in function returning void
      return -EINVAL;
             ^
   mm/mempolicy.c:370:13: note: declared here
    static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
                ^~~~~~~~~~~~~~~~~~~~~~


vim +/return +377 mm/mempolicy.c

   369	
   370	static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
   371					   const nodemask_t *rel)
   372	{
   373		unsigned int w = nodes_weight(*rel);
   374		nodemask_t tmp;
   375	
   376		if (w == 0)
 > 377			return -EINVAL;
   378	
   379		nodes_fold(tmp, *orig, w);
   380		nodes_onto(*ret, tmp, *rel);
   381	}
   382	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

