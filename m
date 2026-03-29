Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B57F6F3D5FE
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 10:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF79B6B0095; Sun, 29 Mar 2026 06:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81276B0096; Sun, 29 Mar 2026 06:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48B26B0098; Sun, 29 Mar 2026 06:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B44686B0095
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 06:49:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73E651B7E6D
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 10:49:52 +0000 (UTC)
X-FDA: 84598780224.27.64C7DD3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4A371180004
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 10:49:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m8qqIuQp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774781390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jnXcLyhGWeyeGV3IYWA5WUZ8OYwiyddkwnwDkjteBLg=;
	b=Tf5+aYzu/hg6BYVmoi+T2v7h5jmfuhBJ/YERXAeQn+IKye58mBoyi2AuD88VQEj6p1llFB
	GX9wLe1QtqBUN0klTiNEv+kKMkQcUU2WmhWtivNFoJEGlPIOhPAkfkpBg7y79G6pId380t
	mg3m+u30fURYERBYNJfAnrhqewyOFOs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774781390; a=rsa-sha256;
	cv=none;
	b=4XnQd2xwFbZQxh24nf738EnBX0FfVdAIYuyjEMsxB5XXLl7c9ByV+LArQuAfhsnwUl00yN
	ta2MQ6Faw07rJC/Rcbt/qFIg1AWLrVwCOKGgNWJFs5eBp69pTUpVShylXso50bQpv1JJ0k
	sjxKSWT6MpxvLYBAta28JbO5gUkv0nE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m8qqIuQp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774781390; x=1806317390;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Wo9L+4YxAfzYxpX8JuNszX9GlkiF3V/LfsPNcswQzMA=;
  b=m8qqIuQpNF6RsHFM1gurim7VeK1u0NUulQ19ltSVR5mOxZPd6yyN0ZNo
   nfs+yBKVNUO+GkxRQDOClSktZMb8FrvOw2iX3fCed875KhOwMIe7gO/EZ
   Ux8/gqdEd072xFnXYDkvv8i4n3Qk/J5lkDIJ9O4EJ1vxXgNG5zP4Uxj1Y
   /g3XbLeRWV2Bhs2V1HfASZzyPsmmO7H+s9y5uwPvh93WLJubzYOiHdN3C
   m469AX9ajtsNRxU/kiT5qFuk8nhCUluknGIUnbavF03gVKMDHFnhQ8UDU
   9DE7c2HnNZAVl4U8bRc2g/eX9L9WD+WlNebc+z6+1/2raYqPhxpUDtXIU
   w==;
X-CSE-ConnectionGUID: /pG1CDUQTCChUB/brYKZ5A==
X-CSE-MsgGUID: C/GapzSLSju6sQ6QS02Hyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="93374055"
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="93374055"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 03:49:48 -0700
X-CSE-ConnectionGUID: 4DZ0cFH/QmyjtdyajyTJuQ==
X-CSE-MsgGUID: UnsA4Ta0QEe71fYcLSvvPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="225782046"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 29 Mar 2026 03:49:43 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6ni8-00000000CIF-0opa;
	Sun, 29 Mar 2026 10:49:40 +0000
Date: Sun, 29 Mar 2026 18:49:03 +0800
From: kernel test robot <lkp@intel.com>
To: Youngjun Park <youngjun.park@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Chris Li <chrisl@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com
Subject: Re: [PATCH v5 1/4] mm: swap: introduce swap tier infrastructure
Message-ID: <202603291831.wZLe8bqg-lkp@intel.com>
References: <20260325175453.2523280-2-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325175453.2523280-2-youngjun.park@lge.com>
X-Rspamd-Queue-Id: 4A371180004
X-Stat-Signature: ggxetroskxiuuui57yf67ewsta9nkx44
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774781390-780324
X-HE-Meta: U2FsdGVkX1+Y/n3q0u9ruBk1RPiAtkRhEedQm3x29Lti1cf/LQA6qzq4JpiM/Wujjj4T2JsRQaStO65PBjRNX8t2/+hkzT0g50IfX92hKRu4W8OIqD2DGnJ0fUO90eSZJ5gP6wHYuEi0O2hvHXLFl3RHd2b/WoL4bnEav436gUeHn83PMOTwVWahKq7S9S+xGJdRpsDXStI9XN5dMNoZM9IB+aGK+qKJlVTp+6b9BTlV2BtfL1Xe01+JkmlpK2B41NWP296rJ+ZFoCDOma1k2EQJkzL343huIZHZyhHZXt5A1DHS5F3ZX4FSKq9wFlCt8QzJ9djjOCcOk36F+AEgMjGDtwzMHmyHUiIWobQE3PmpcxEj7UvXxSwmWNDBRcjE2ngYHY4GdwwPnTT8yayqn4K6Svvb+bImfwRhwvDzcwc0NX1XUurdvviLWYf27bzq1CC3RK92xwIVDwXCGqPmXsLmt0wyNLTMRXwaO9cgZTruwWUl4jloa0oiaZktnXQKSOocf0TZeJExJV/JtIFInh5cLSQMmZ/T9rbn7N5BTY7WyLqsRLC3ym9yeLVBSIyvP5y4qqLAD7r+S/q0rXG1138LEbednHlHL1lv7cXtxrlmJ1wcUgGAY4dJAOJmQ+ohmiLZ9Z+jhbkAZtDAxnuTPQX5tBpXVm2jPi2EtoZ0rCjwRYwjaS0oYF3XggAI2Xg3Yd2MJtWdvd4/AM/R87c94OwGpDCehAuCVL6iu+stC9cUUKkB52BdB+FvGGInyzFErCY6C4CkDK6dTBodBwWyR3aOW/+WAA0mkCljTz8qoPFLnBQ+ObmHY1Glk9UqOoO3tT6C+oexqu70/fv4154JIgxGSMkcX3SLavQTbQE0lw6eo/qU/shMHW/L+/ZiW3n9apOHf5rblSGqZ0qy4/QBpokqdP5L2KvPXfJ8CbQPjkYLszbAzY91UmTkjPvhkthZUU9hDglXzI0jZAiaF1X
 Upj/5fS0
 rjDBQv3+DgxyNzQ0DH1X/1gKW8JsPIiTpVN8iFjUFeVUMoytVZsOLZIsV8LTUyEzPJ59ug07gRtCqY5iwnE45cq2PhjK/+gBH820/uLjYS7aU/thBTkyddTBFk/zHAB5XmHuk62IIpxx0Mf2Uq87sSNMF710Hw9GOj9q4eAiVIMyu0PSjJOo3RDo94VTKu9UcHfljx9BcHxhXavomu+CQpRow1cXxL7ldKnHC6LryhckSDC988PGrFiPPTkQoVIIIVr4/rtDWf1wgUojvpFBbQ+bsFfvdcePXDhpR+iARwvKGx3Jad8Kln0ZndQjdh3zLKQkGyLfPLbAP5osQrqjHpfQRMiSGauq4ZCdT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youngjun,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 6381a729fa7dda43574d93ab9c61cec516dd885b]

url:    https://github.com/intel-lab-lkp/linux/commits/Youngjun-Park/mm-swap-introduce-swap-tier-infrastructure/20260327-203639
base:   6381a729fa7dda43574d93ab9c61cec516dd885b
patch link:    https://lore.kernel.org/r/20260325175453.2523280-2-youngjun.park%40lge.com
patch subject: [PATCH v5 1/4] mm: swap: introduce swap tier infrastructure
config: hexagon-randconfig-002-20260329 (https://download.01.org/0day-ci/archive/20260329/202603291831.wZLe8bqg-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 054e11d1a17e5ba88bb1a8ef32fad3346e80b186)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260329/202603291831.wZLe8bqg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603291831.wZLe8bqg-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/swap_tier.c:118:10: warning: format specifies type 'long' but the argument has type '__ptrdiff_t' (aka 'int') [-Wformat]
     116 |                 len += sysfs_emit_at(buf, len, "%-16s %-5ld %-11d %-11d\n",
         |                                                       ~~~~~
         |                                                       %-5td
     117 |                                      tier->name,
     118 |                                      TIER_IDX(tier),
         |                                      ^~~~~~~~~~~~~~
   mm/swap_tier.c:33:24: note: expanded from macro 'TIER_IDX'
      33 | #define TIER_IDX(tier)  ((tier) - swap_tiers)
         |                         ^~~~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +118 mm/swap_tier.c

   105	
   106	ssize_t swap_tiers_sysfs_show(char *buf)
   107	{
   108		struct swap_tier *tier;
   109		ssize_t len = 0;
   110	
   111		len += sysfs_emit_at(buf, len, "%-16s %-5s %-11s %-11s\n",
   112				 "Name", "Idx", "PrioStart", "PrioEnd");
   113	
   114		spin_lock(&swap_tier_lock);
   115		for_each_active_tier(tier) {
   116			len += sysfs_emit_at(buf, len, "%-16s %-5ld %-11d %-11d\n",
   117					     tier->name,
 > 118					     TIER_IDX(tier),
   119					     tier->prio,
   120					     TIER_END_PRIO(tier));
   121		}
   122		spin_unlock(&swap_tier_lock);
   123	
   124		return len;
   125	}
   126	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

