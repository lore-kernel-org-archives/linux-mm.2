Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CCD0CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A226B008A; Fri, 29 May 2026 04:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B746B008C; Fri, 29 May 2026 04:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968D36B0092; Fri, 29 May 2026 04:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 872B86B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:48:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D2CD1A0F87
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:48:08 +0000 (UTC)
X-FDA: 84819830256.16.B86E3B3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf25.hostedemail.com (Postfix) with ESMTP id 309B7A0009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:48:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fHUb1N4h;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780044486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Wya9UPIcmPAPl5XVBvF2WHQdh2/f2rYVl+3awRgb3I=;
	b=NX88rd6zPXU0ZtzpsaozvkzlAKabVz9qb5NcAT+Dc1w5DaYr2vgO4v1pGHZMIkJQIKqyTQ
	BD9O+ga5gcYl10ZdnP/pBpGgVLsY4UxZwtWqXQ5C2CmmRiLp8ATXZ5n6utEkMjNHsEiSY9
	FBTc1+smXSMwjXN+gWeXwzVTOqoylr0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fHUb1N4h;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780044486; a=rsa-sha256;
	cv=none;
	b=OS9gYfyMEi4vlZh3YDP0mxqlLPGKA0ni8waFO2YuNpqbx3IzvYSp4y3M0inDbWt8ajov2/
	eBBrJJG2XnjdOjNKJlU0UMM8+Vq3Si9S2rRD1xXPWmlK5mBPpoHnKNhtMXISFjZKdlJwQJ
	6gg3G0s14D3fp5dneKE2mKf9gPkaTaQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780044486; x=1811580486;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6AWLmlUtfnCHN56YA869w6PKgs0+gUIV71eS29nK1aI=;
  b=fHUb1N4hLJG75g8Id3oNwrUcbt76RuNef/ZA/0ZaFMCOsWwzAE8NRPkn
   y+dTWkWjWIfVOobGLJLUwJoXvJ5+3GZexDYG4yffBVziRmQPo7rUDHBk4
   GA1Ye90Na/sLgf1Dry9HKDWlu87k6CECF99KXSYGk2DfKLx5EjwjdEbMQ
   A9aPx+m19t4tBaopTr0LzW1+0E9QPhrSlVAuAUD7Lyco64TG+cQgxrJJS
   rIr77ytauGiV+s5VXt445JtQuZ6C69ynqM5iuezV+/+Ku80TpQ4FgIzaj
   IItJjopeWI4sDW7ZWHB/fFzHokSPZmj/IEFndEr44zHOidDeqk2GSw7oU
   A==;
X-CSE-ConnectionGUID: szAg/ruGQACTRZqAuLMFnA==
X-CSE-MsgGUID: 55pVKi0cTSOY66HPovWTLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="98310084"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="98310084"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 01:48:04 -0700
X-CSE-ConnectionGUID: FfDdqrpOQKCTSLgvgbJbPg==
X-CSE-MsgGUID: cm7/T7dEQP+9c9ico/Is8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="280915197"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 29 May 2026 01:47:59 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSssm-00000000702-1IAn;
	Fri, 29 May 2026 08:47:56 +0000
Date: Fri, 29 May 2026 16:47:12 +0800
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
Message-ID: <202605291631.6MATSv6v-lkp@intel.com>
References: <20260528190337.878027-1-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528190337.878027-1-ynorov@nvidia.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 309B7A0009
X-Stat-Signature: rnt5i9ogcnuhtge9swsossbhkmrbjup5
X-Rspam-User: 
X-HE-Tag: 1780044484-82007
X-HE-Meta: U2FsdGVkX19Nb0ts24qlh7qz9+1l4wfri5rG4MiJRPmNNyzgYlendLYhXcNENsdw+uxzzcNiy6evu7UvGWOHfgG3PBLcseCejoHfSQy7xGPJP3iIF2ul2JT0RPR0bvJhKpyR8MdEGCGUqacSu2lk/4VFg5heQXfa9fN0ODeBucMWjOrD5v3fNYiTUHOaV7iMiZSlh23vM7b7pqkMundZPN/CCrbeStLxjYnfoEArM0wZ4kyLywQK+ctMhWVzxdPrYH0W5ipr94q6KHFHfyO6CStdIgsiW3PnKEFAT2Ee+XmOB/5dWGwbmHpjFo8WKxu3drUk8g4OeX/XxvD+1CMKl2T6kqBthz3okM4usd9jmgFZ4QgC4HPgmszw+aYrtBIFr+HuPUL3FP8XzvVlF8gXM4OvKEBjzLLeic72L4Bj/Isyll+3teULaOWl7Q1/KjQIIp7L8tkv30w5KEyBgC9e3iQsI1K4DUC57iVtetnrksIzkfUn4gZL9sliivjM2anlA/P2iyS7gUYPsdw1DlAvIrpVuu6+dWIa6C1EKuwkXe081eybIbG27dVAsjsuTekZu+P2D1exkaMvQdnbCGfqtEr47ONWL00JV1uXbmZ9fZQuyJFRBpP841ZRfOOLv7DGIJ8WKWJBe5W7dmvm2ZKoy6xhr8hXzyUYs1LfHGXm9jJ8FouAET3/AOI0Xf8zdrKxUUBkiopG4Lp3cLB01hbTmIaehD5bxho64cWGxnVRWS69FBHZZa6sTBZLy6pE0K9KigVDQuBTOrmBQqFJS4HviUbWJo8Pg9TnS5qb9E85esW6m3WtRcL2jELQbKhOWtyzynApv2OsHzdrdXgz/4j2ITqdy7bubj9dWYqoaYUN4yzaUeNZxKncT9MJOiTDXZNKzpMrzchbnnqpGH6p8gxPPKtMP1UTyrWHUK808fiZbvRM7xBkxF832uI/s4Kv14mDYO+Vgcm8RDCiURBolx0
 +2Y4+32j
 1Zeur8y92kw6/8kT2LIop8sYW13ByqfVpaeSmNt3hRBnIaG+l2Ey+aDQeJz5AfJeWwxJtl1050tlka06rFbZTTdWr2fArMqzhK5bWaCHx5Y19mYdesZZQwwji2oQTIhakSFMgHl7R01d2AF1XmGVVGVhdCjB+qSxg2BiSBowlhPKpMOY/wqpn4fGqPc0wwFwHb5SuEVVwpRM24LRmdtuzsV3oqeihFpvR8QOlOeX8ltInFQlRI+W9PSqrqfWYBwDyb/vgGIbm8DgZ57NOPj32onjEzG3JEcauKQPl3c8p72+/rpmU7RtRgOIMGGlVkSF1QeRLg2haC6BKMlI8bqdmOTON+sQ0aubOKkOWGDI1AZlybM8rgzn65OJNWmiYcLOgylrTJzIqXesNTzUj1jLM3vD2o+2V3b8xxHyW3OYrPxn2Dv5JRD7R+8eZRfWbpPuil7Fv6lt4dDHcXUWfaj1bWdY8JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yury,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Yury-Norov/mm-don-t-allow-empty-relative-nodemask-in-mpol_relative_nodemask/20260529-030835
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260528190337.878027-1-ynorov%40nvidia.com
patch subject: [PATCH] mm: don't allow empty relative nodemask in mpol_relative_nodemask()
config: x86_64-buildonly-randconfig-003-20260529 (https://download.01.org/0day-ci/archive/20260529/202605291631.6MATSv6v-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260529/202605291631.6MATSv6v-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605291631.6MATSv6v-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/mempolicy.c: In function 'mpol_relative_nodemask':
>> mm/mempolicy.c:377:24: error: 'return' with a value, in function returning void [-Wreturn-mismatch]
     377 |                 return -EINVAL;
         |                        ^
   mm/mempolicy.c:370:13: note: declared here
     370 | static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
         |             ^~~~~~~~~~~~~~~~~~~~~~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for MFD_STMFX
   Depends on [n]: HAS_IOMEM [=y] && I2C [=y] && OF [=n]
   Selected by [y]:
   - PINCTRL_STMFX [=y] && PINCTRL [=y] && I2C [=y] && HAS_IOMEM [=y]


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

