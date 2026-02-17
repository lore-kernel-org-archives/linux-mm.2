Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6810E6817B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 12:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2976B0005; Tue, 17 Feb 2026 07:18:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D566D6B0089; Tue, 17 Feb 2026 07:18:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62186B008A; Tue, 17 Feb 2026 07:18:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B12B06B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:18:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 355A9C032C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:18:47 +0000 (UTC)
X-FDA: 84453852294.19.978FEBD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf20.hostedemail.com (Postfix) with ESMTP id 610B71C0008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:18:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="FZkc/6GH";
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771330725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WW3aylxN+UKG1rxk+Fl+cCO/RKI4Ii/abuk6emVJ3BE=;
	b=ilmJ0yPTUAvZco04ctHwZAFzbWZXe2ICBVpqrtuzwwLHkgv1usB6D7VbzvptRT45X05SUb
	YE95rkSbFl5GGBaqYDyR0kUfM2loj0BXCT4Wwy9gTU3wAqSxE+m9xOSB0GZx8zWy2eSs0E
	HzhDHO71ltwUQuzgov/THJrQoA7qoVE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="FZkc/6GH";
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771330725; a=rsa-sha256;
	cv=none;
	b=zyL5ytmSMqSrIQTkJRoNrVhpN5g8xN/H2MpWUqYqSrOhTTRWCfJm3TTYU9i9tXoW0DW5DM
	Z0pLyAt/6tNOqz4EpwweGLkzdjwSs9dKTG48PflW5gFTu0YOgAvcN8j8YcmY91bgOd/HPU
	46aX5Se6L4CBBoxJ1v36OlgCC0f67E4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771330724; x=1802866724;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gxv6GPfvEdt3I88BAhetX4DcIa295ymdfyKLNpySCfo=;
  b=FZkc/6GHDcMfj5yIFITrpOAWDSo9Wg7VeqeHCIVeu5S7eWnLy1RHRTQW
   VdV/PWMT4erIsVJFBIlLQA+Oz05tUHunEvthLZ9dee6V6sm0mCNYPLgyk
   KY6MZ13ZqliJMyQ3KVWkdAMh0pRV80ddKPK/OmZFtlCPsksxTOfKA7OE5
   nCWMj0isT63vYK+C86wH7sFdKd1emuxmnLPxpYdga0QIw3YH5TyN5MJ+X
   he0w+9RUo24tN4S08NiLcN0fEix0eediLQFcBgeSUHespfGr6vCCP9dQw
   N4nmuwpA4jz+/WJTAuAbQs7Pkri8J0yVxLOkrn2tWr1uAIBf4orobxs/w
   w==;
X-CSE-ConnectionGUID: /nakB6yNRLiGQPwLLVFPMg==
X-CSE-MsgGUID: kfsXZoSUQRCvkfP/soSjew==
X-IronPort-AV: E=McAfee;i="6800,10657,11703"; a="72108205"
X-IronPort-AV: E=Sophos;i="6.21,296,1763452800"; 
   d="scan'208";a="72108205"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 04:18:43 -0800
X-CSE-ConnectionGUID: 5+Zoq9ohSqijtT9PXHlpFA==
X-CSE-MsgGUID: NyOLsov8S4adFFzo9eyCoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,296,1763452800"; 
   d="scan'208";a="213127162"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 17 Feb 2026 04:18:39 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vsK2G-000000010vk-3Fth;
	Tue, 17 Feb 2026 12:18:36 +0000
Date: Tue, 17 Feb 2026 20:18:02 +0800
From: kernel test robot <lkp@intel.com>
To: Youngjun Park <youngjun.park@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	gunho.lee@lge.com, taejoon.song@lge.com, austin.kim@lge.com,
	youngjun.park@lge.com
Subject: Re: [PATCH v4 3/4] mm: memcontrol: add interfaces for swap tier
 selection
Message-ID: <202602172046.jWVum2TN-lkp@intel.com>
References: <20260217000950.4015880-4-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217000950.4015880-4-youngjun.park@lge.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 610B71C0008
X-Stat-Signature: act94z3jkjzaiisoz94p8qjif4ooahaj
X-Rspam-User: 
X-HE-Tag: 1771330724-447404
X-HE-Meta: U2FsdGVkX19OPEZyPGBYpyhsUq6m0SQlVly7+cxsx/BHhvmKcr40G5qwBaTcba6Vt/gfTdX/xNjo0LNa8i267szIA+l5pueWNibpYzYN9j7kMSADnc5memcx0DhfBa6DZC9NL+cghkPD/grEdwtlaa5XiBa4GoMOuLvp8jOURccLA/ikkarfViMzWtkgvlRgwr30vcfEeZuYlss7rZSVK5BbttpdIRpzpZVtA3+XwDNFfABlFSt9YfVzhZ+4dC73KZq7VpvkSfosbKC/1BxtL6cAP/teYyvk6VR8P7wYXF3O5yTU3zJj+LRY7jgYj+nzhDK5gYVdMxtJAWduv4DpMyF88lulbcM5qP4YsT2Oa7C5WYj0Iu/BMNtB5Ip9/p+9zA1d9gKJZI7Z1lYvXMI9GnHLDVlNos3hDmSVbxn14vmMlmgQX16LHNZqUBBtblTno4JWLTWZa838eubcgoxpXktm4Iz+L5u8Y7sCR6aKo6W9XB4Q3nZPvzjsw9Z4SeNEaTN65tEBQI9N+83Mzji4TrlfgWGM4T86jk7ecH8Wu1D757gyVia5cieC0BJWRe/0giOO0P8tp8yOX0u/r3Nnn0ChZSbbhyEfz3VcB+BKduRgUPrkTjGBxkRoK9WX7uakQHWOYoS5WAdaOQw7l1mwIQGKGN0Sj0vlTreWs2xjgDIoRraeDvKHpHOhua2PsIfpzTWOifLlRX/tOhvNIeKuX4bL8xHIIWC+5PUY/fru7wLKsTJtQBrTMJbQ80oGh08CEnCxFFsB2R8cLVKw9AUhz9PbDt5khYxuZNIZUpvAL5bV/xT9k/HBA0egLx9OikBaSYuJHJtiFG1zrmnOmY4hRHQqspBEi0zz0wCSUSsUCc0aiUXf7UjAZTgpXz04XHlLKQ+ONYgqzw0cMN0Stmx6cWR88mUCqEFx+CsE2Q7Ot5EN2srh4ONCMrov/wMaf8/UMldUw8Opx9nQlgUA5He
 Lj+gaffw
 dyUKdaxQpK2tw3j+BK3dGIF7dnXXgXv1dPUrtvaoEUhVCNxTNv98ZAH3p1+aHCLBXZBGJhDRVCaoIkRc4AtQvHsWGtuqnvNJb15Zdd3Z9vW3ISyrKO4UYUr00vsBmz1a2ivPVlB5/xEV3kIg9CrUvb7G1b3HsAEl42KgjxRDq0qeajeJNGFJryzjNf17SvBLF0+NAaGtXHbWta3I8SZnPvfyqaBds+Oh+gJDTmrsfH1sRRdb83Ku6M3X/ERn8Nlzrbd01kTNphthMQoBBep3dolQOFbcJjmZKzeDCKA+HDFO4StZD81W/q74sk7U93OrHoioILs1zOBXv2EHBRVRazuspDzU00FmBiI8I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youngjun,

kernel test robot noticed the following build errors:

[auto build test ERROR on 776250964cbaa49ebe6b8bb2870765cc89cece59]

url:    https://github.com/intel-lab-lkp/linux/commits/Youngjun-Park/mm-swap-introduce-swap-tier-infrastructure/20260217-121406
base:   776250964cbaa49ebe6b8bb2870765cc89cece59
patch link:    https://lore.kernel.org/r/20260217000950.4015880-4-youngjun.park%40lge.com
patch subject: [PATCH v4 3/4] mm: memcontrol: add interfaces for swap tier selection
config: powerpc64-randconfig-001-20260217 (https://download.01.org/0day-ci/archive/20260217/202602172046.jWVum2TN-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260217/202602172046.jWVum2TN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602172046.jWVum2TN-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/swap_tier.c: In function 'swap_tier_memcg_propagate':
>> mm/swap_tier.c:342:8: error: dereferencing pointer to incomplete type 'struct mem_cgroup'
      child->tier_mask |= mask;
           ^~


vim +342 mm/swap_tier.c

   330	
   331	/*
   332	 * When a tier is removed, set its bit in every memcg's tier_mask and
   333	 * tier_effective_mask. This prevents stale tier indices from being
   334	 * silently filtered out if the same index is reused later.
   335	 */
   336	static void swap_tier_memcg_propagate(int mask)
   337	{
   338		struct mem_cgroup *child;
   339	
   340		rcu_read_lock();
   341		for_each_mem_cgroup_tree(child, root_mem_cgroup) {
 > 342			child->tier_mask |= mask;
   343			child->tier_effective_mask |= mask;
   344		}
   345		rcu_read_unlock();
   346	}
   347	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

