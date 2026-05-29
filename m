Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 840AFCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8E2F6B0088; Fri, 29 May 2026 08:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F086B008C; Fri, 29 May 2026 08:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54EB6B0092; Fri, 29 May 2026 08:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B56486B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:46:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F8BD1C0018
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:46:45 +0000 (UTC)
X-FDA: 84820431570.13.CC39DB0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6A88E120003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:46:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YrCLDGFd;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780058803; a=rsa-sha256;
	cv=none;
	b=rrozY1VaCEDPuyvxNI/QvewNg3dEJrybVNClyIWMeLIIMA6uAIW0EU3Gs8oJ4juhzHtY9c
	PqgIOgiwIOJSLw75nW3gUuoe86nTFUKU9npcyI1XwqgIBhO7VMVgjCaMPBWGVt2K3xS8FQ
	LWjBRcoa9y6Dlxfi+7uPaZOWe2+kR8o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YrCLDGFd;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780058803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIkNmoOTxjHmsn141sqDUB75iJaAZ+9O/abve+I9Bew=;
	b=42iNxJDZOlZ8d/vMyojK1XKxrfV02C7uSlW8rnjjAkkivyPT/vKz2s33MWSxe6umACjg+G
	8lEmbHp67xGQ7FkJA3qhZG8ZwHCzj+H/lsy9foLRo0nbJBN8KynSq5LyAxE1jJcTmdoPzr
	Se/4G3X0GbbBEu+gRPBWmAfyn7WcI4A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780058802; x=1811594802;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n4uZhdK6XzpQGNzverimKltVRsJ+TnUC5WxnmXwitTA=;
  b=YrCLDGFdwJt3khJh4u9fk+xfCbxNAkXprL9Zuz5NfJyOAmH0bpu/Jj9j
   MEP6kTbJK3R//Rr3ispJFp3JmJihHjbW77iinclHF0v6GYuWnRU1fmsHm
   PJYucwJVYDkxnfi/q7XoEEQcQ4GgQbrEgr4ReUcHGxr3+EaC8we2D+NB2
   o3cbzXl1DpBtoAvklaRAyyqYTgfxuD9LKA0+R1VMRYsMDfn4LGb4eTiVR
   RJqdHaL9pZmPElujq52BFG6KzvtbemxREwnwWpOpQR/ZbHxXu/pxBfAV7
   V82ngnpzThytrzUWmpaw/DCbCiH+EP4DP9UrvXS5gP3gPhSuRJxxvqpTn
   g==;
X-CSE-ConnectionGUID: S9GZJAcUQXOodUrd+8Reag==
X-CSE-MsgGUID: 29wCI+lJStyl4SMbn5Uarg==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="98481773"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="98481773"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 05:46:41 -0700
X-CSE-ConnectionGUID: 7Q0VXFu1S5OXyxwepwhv/A==
X-CSE-MsgGUID: Tmn/iAW3QhuifguaSATNwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="242940030"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by orviesa009.jf.intel.com with ESMTP; 29 May 2026 05:46:36 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSwbi-000000000tV-1M5I;
	Fri, 29 May 2026 12:46:34 +0000
Date: Fri, 29 May 2026 14:45:47 +0200
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
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Yury Norov <ynorov@nvidia.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
Message-ID: <202605291432.MbAf9EG6-lkp@intel.com>
References: <20260528190337.878027-1-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528190337.878027-1-ynorov@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6A88E120003
X-Stat-Signature: sqosb4c1ed755bfy48rp1i8si8cjri8s
X-HE-Tag: 1780058802-995353
X-HE-Meta: U2FsdGVkX1+VNlwbxeEIdpJChNvpDSK6iCVHHQ9rCs/D0UkF+xNT/xFnmr1rfXH0yOH+7GOfWi9EuUJ5j6UvY4tUEWlftqt2XFutMbzKHb+ltkBa9Ie3iJQoJvfTxHC/si8hPCV+XOIrh0nQcPBB2daA7B8ZdBaA97FDs6QA+8aI1dALf24srP/ungIXIgiTv9SW4lEfEgAFoPgHkqQjD62ykBbU/vHmu7BdD7fEay7fU7AxdPq9zk4AXCSCIRZJGeFOaJbdCggkQ+baeNYYIgiYQjhpSHkh8EmXCCTechh+QWo4tzCwXdJXFx7CSnMQBwypKLgXNiHJrsCZnhP5DpApeHCJr1Iygixgb0k4MP4mFEqIjZ0GTKaLeMwr0uXulGtjj2yS9JmEUALCK8NsBdIOHzZ2SFduigddQvXWdFdKTuW+F37gCCPiDmHMk21aXWJDCfESCsoM6jVATIAvLps+4czbq2G0qLcoA4Q6T38ymJHHVg2CoGwy5IwpPRb9Uji/xW/t3BAzUoP1C7rD7GYyCE059paEQCdjAt3sSxvUg0UJ8NnZSURC+ljL73VqmVzDKEUGRzNqp6og/8EB/eiX7Uv1OpjhTvsojNrMiiC5MXBF2NquJz6JQ0D85e0nFQoWay/kESjmJpTQNwd/OTBfceKGCml5qwyU6WhiUThUS1DvyB5CDXRMjenSHbndgkAY0DUo8GEPXhS1IroqeHb5eNJetr6SXAIimFHnJqZwFgJb7JBZAAl/psVjkue4lUPV7zfjM3TERuWDf9mgDxJyPrRBzmJ74ncxc3IgNPcdP58GZ33DLkDBit5VU2kT6FaeC1kxez7szg2W1tV+0DDN/GqDliWOr8C9+QWBm5NZ0aOBfB0+rmxQBz9nyi6tL6E/4Wvi5fL7B2ai00zaUMgvttQFYNX14f1/6HVR9vYon6FAsT3RM+yNP39udak6c8jt1MWRAiaX2TyrVps
 NaJGscut
 4Pa/OXRqnU91zR7nQAiouHsAFTmtjOJ+ZHq0Q3d1wEQdYHuCJbUFUuR/ZcTJvesV+raVJmhFMKPmBXLGOaRAgbYobuyy/5dPCohIMiEwroKiImIYnhaq66BdZl/yBR/r1gjJP+bSoaUQS+xHHjT633WDw+s/zGOaL5QSRWYjL3I1LUMQOnLOXndKdy6SFbQZVrMQgHjM9Fz/TlpjzAOSmu94/gdsz7QN0nuRVfxBQnjHl86UNgCRxBZvqQ3lPCE8Mx89kAynL4n2uh1k0pbSjsb0Kmyuuikl6DfqD8F5xCfEMX5tX2YwHvQ4N4d6r1qZupkpNlS+vPowFoc2gHipAHHGsEjzcI6tvB3IHYEYSKgeENVrxdobNgX0COjM+vTGRIDNXWd5+wxwfhp1awjf7zaTX2eCoW+JSe9pVGlRjNlkEWRiUFMlnM6F16ZSIPk/T+q5R9PUc8YXjbHRoyrgKJoXU9yhx1wQP6097hXOYGUm0z/LAXcwrpajEYQ==
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260529/202605291432.MbAf9EG6-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260529/202605291432.MbAf9EG6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605291432.MbAf9EG6-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/mempolicy.c:377:3: warning: void function 'mpol_relative_nodemask' should not return a value [-Wreturn-mismatch]
     377 |                 return -EINVAL;
         |                 ^      ~~~~~~~
   1 warning generated.


vim +/mpol_relative_nodemask +377 mm/mempolicy.c

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

