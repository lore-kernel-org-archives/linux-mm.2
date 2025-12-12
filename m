Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 791ACD44176
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 11:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50426B0005; Fri, 12 Dec 2025 06:19:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C280F6B0006; Fri, 12 Dec 2025 06:19:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B170D6B0008; Fri, 12 Dec 2025 06:19:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B41B6B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 06:19:58 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50B3816050B
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 11:19:58 +0000 (UTC)
X-FDA: 84210574476.10.162C13F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3BA8A180008
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 11:19:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Wf0yl3Ys;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765538396; a=rsa-sha256;
	cv=none;
	b=wOBaLJ0skRmjkoffX6Gy9ZHuFIcLyLELWLjF4H1gQ3E7+vmMwYjK9lQPTFhIvhvkeWzkJt
	yvdTcVnch1Y6qU+1WIu9zv15tA6sZ9LNv5XYh+staSrscofI6DXCu4yFe6KaCaP9VmW8Un
	4J1yRPZzwGqhySA8p7dYYEhf9P9smkc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Wf0yl3Ys;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765538396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbS0wKftZYGHZ3l7SxoxhgnOgup7gcpPusiz8Hz1XNw=;
	b=J2QTgRmoTn0fJytoRe2Ak1ojmbzpsgCHz2e6aSDaJ1gx2S1rh4PcGSQKfpE5UCXo6+nPtY
	qs/I3bm92vwjw6xaZx+VND/c3kuYqpjCeFpqx4ImM/YmofIIdOYw2BJu0RwPz7WG9X3IvQ
	Arzglowi5dfpLR2tpPg6ksAQTgkU0K0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765538395; x=1797074395;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CzkX7/2sczqJ1sgcOtvNNN48WRCDW89fEac9ZCuUoB8=;
  b=Wf0yl3YsR1+BUE2T1wPPKb24PcJBL8ESkh0tRyNwAePNTls+nH52TvZb
   hfQYLY2U/SxNRg+sedlnFN0fSvYk/IlafV89hrWtq9RMUb14HdJUJCTeD
   ceE6ijvMAYj01vP80rpgadwiBkJXFdqZXrMsLUf4LKgf3h1kix6OVq8nj
   YhtK9Ot0cjPzMMOdatWT7jLdqF9pxHchRJHHSTmRPqqu6QY6kSTnuR/o9
   8jKBSYCNxkdgixWkB7/7rr11DPP9nziWGVtRNl2E/OxaPsyxEOIq1sitR
   nQxzXYJpUEla5wn6B2En90e1jf8uRXaOBfEeINdGvyIfKWvFxfkvwa+EO
   g==;
X-CSE-ConnectionGUID: 917004NuQ8mDBOu790dOPQ==
X-CSE-MsgGUID: ycokuHa3Tp6tMQ38h2e7Xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="67610628"
X-IronPort-AV: E=Sophos;i="6.21,143,1763452800"; 
   d="scan'208";a="67610628"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 03:19:53 -0800
X-CSE-ConnectionGUID: mT+4uXErRRq1FjpMxirWOg==
X-CSE-MsgGUID: dnNHcK4HQSWzUsqgeHM2rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,143,1763452800"; 
   d="scan'208";a="196969288"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 12 Dec 2025 03:19:49 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vU1Bb-000000005yX-13Y4;
	Fri, 12 Dec 2025 11:19:47 +0000
Date: Fri, 12 Dec 2025 19:19:08 +0800
From: kernel test robot <lkp@intel.com>
To: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
	robh@kernel.org, m.szyprowski@samsung.com, ye.li@oss.nxp.com
Cc: oe-kbuild-all@lists.linux.dev, oreoluwa.babatunde@oss.qualcomm.com,
	kernel@oss.qualcomm.com, saravanak@google.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	robin.murphy@arm.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, quic_c_gdjako@quicinc.com
Subject: Re: [PATCH] of: reserved_mem: Allow reserved_mem framework detect
 "cma=" kernel param
Message-ID: <202512121907.gdTOodx3-lkp@intel.com>
References: <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3BA8A180008
X-Stat-Signature: tan1ay5o5b8dnwbn43qruahw7kbnuujg
X-Rspam-User: 
X-HE-Tag: 1765538395-832917
X-HE-Meta: U2FsdGVkX19np0xBFlXJpH1GsrXnKAfwG44CP3PVxLBRt5jBhc3LroPqL87YFSfigI3jtSBEAY1t6z8hXOsN4jA4f6bO0TLWI3ogjVeKfprGdZCICJQh4oM2YMo9qHbQcDwDq5S/rrN3AMlQ8TIVNt0cMgxPJa1hlCf84gnWIRoxHa72vgGWpSiFgC4sHQcuHwAEEnPPuVypNWYsR1F/DksCDIRuxiTMcPx/Qdv8M+fXRUwAUB674d5NQ3UEpUxRzwn+ahSGNhon+7mFMpFhhNsc1Jj2WtIRgMoAqOs7CBxTQ58GmFFRUQK+zfHE/Dnj0YRcOz+i880Y7hHJVSdbtTAFNS+fmsKzFpMswZYeulQppyhiNcJqXtNsFlvP5bNLBuYQup797GfObk4nxspSWuaNtbiEIhVCmhPXZGu2JMptFiAr6PaTeMj17/HSWKFwnmrHbzvgZ5KCHurwmnOyxJ/1oGFJLbIHkMQjkWPHHbIM6kz9f41HTbl5vnSzvYzkLmE837Q+67WnZXWm7g8pZ2c60HMD1ic0/i6uAqMsCYzwGUZsZSWuI4VEPfOAO/yjk1R53O3TApR3TvYxSJEwTvDxqnAY+SodQKW2vUMPWdlFxW2rs/HZZ+TgMWwEPgZOHhrcs7ZpumWh/PT6EMsyoNz9DyXjvrRpQWTXjkQgoEoro4xbNh7YhijwijDzMtGkZ3XTzWDt6OGdvlsOpemwP/mra2sZ7nCYcQ/WZzlpsxAV2g1PDSDtvmFz3TL64i4WxnFKeXG5mmlsAiVWcXP4+7PIG06sB7o3heVgWOhvH0/WOaAnrM9KeXsdh5qkUD3U3LQ7N+zq4UazRqZ+4RlMCyfcG10wfBlwx4kXzgrfmSv4PcAjf/etWNuimaUgBYjXwOIkL2g76Gjs2WYSiamU0dhuwChBTwcDcHPcniwtEjDm++yhaKSUIpj5p6GJs4YFiUBHwYf69d/d7+5BrfJ
 sLR7MfRD
 gl5v41YgZK7iVBsxXKpoiqAL/TZypGhZDore6bZMyRQ8WK5D5Pf3sxxKpJVYsXcP+yJ9qAmCfPuMq8rAX9UUyxmt2rYle0tU6YIdtlSs1JCOjyKMOBK2NjvPm707UykISNO4cqQqfsnQi1kawD1NhJfy1/8EHIJ5JESINGYavjrAokLmr2PNuxxRI1qVpqMFEbgbnzY+WjXxYnntgmWsF3Zyf6jWg3LKcbhHE1hVdUHy8h4i2tJh/D8+DpFdH7M6joDkG6EKJwiBxtkm58TTk29n6vBbjKoyr/gMTyILRT10X3eNCcJxMcnYb/dXSTaFP2jbMst2tjoKfLk/ckNMryw+eslHGsatDRV8scxq4XYO5t54yTsQBGhjTpjFsz9yEnE93SBhMorNZt8xUaG0UKq3KAjlAok5+5DfswNAdI78Z1h8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oreoluwa,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on v6.18]
[cannot apply to robh/for-next linus/master next-20251212]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Oreoluwa-Babatunde/of-reserved_mem-Allow-reserved_mem-framework-detect-cma-kernel-param/20251210-082127
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251210002027.1171519-1-oreoluwa.babatunde%40oss.qualcomm.com
patch subject: [PATCH] of: reserved_mem: Allow reserved_mem framework detect "cma=" kernel param
config: arc-randconfig-001-20251212 (https://download.01.org/0day-ci/archive/20251212/202512121907.gdTOodx3-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251212/202512121907.gdTOodx3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512121907.gdTOodx3-lkp@intel.com/

All errors (new ones prefixed by >>):

   arc-linux-ld: drivers/of/of_reserved_mem.o: in function `fdt_scan_reserved_mem_reg_nodes':
>> of_reserved_mem.c:(.init.text+0x46e): undefined reference to `cma_skip_dt_default_reserved_mem'
>> arc-linux-ld: of_reserved_mem.c:(.init.text+0x46e): undefined reference to `cma_skip_dt_default_reserved_mem'
   arc-linux-ld: drivers/of/of_reserved_mem.o: in function `fdt_scan_reserved_mem':
   of_reserved_mem.c:(.init.text+0x618): undefined reference to `cma_skip_dt_default_reserved_mem'
   arc-linux-ld: of_reserved_mem.c:(.init.text+0x618): undefined reference to `cma_skip_dt_default_reserved_mem'
   arc-linux-ld: of_reserved_mem.c:(.init.text+0x77c): undefined reference to `cma_skip_dt_default_reserved_mem'
   arc-linux-ld: drivers/of/of_reserved_mem.o:of_reserved_mem.c:(.init.text+0x77c): more undefined references to `cma_skip_dt_default_reserved_mem' follow

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

