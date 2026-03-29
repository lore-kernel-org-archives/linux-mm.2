Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7135F3D603
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 13:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26416B0092; Sun, 29 Mar 2026 09:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7056B0095; Sun, 29 Mar 2026 09:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5A46B0096; Sun, 29 Mar 2026 09:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7B276B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:47:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 474291AF5C7
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 13:47:30 +0000 (UTC)
X-FDA: 84599227860.06.7463D51
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id E58AA4000F
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 13:47:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hvYAsQt2;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774792048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3SP4xM7YZbvuy6lJA/m9QOCLsbu+qkchYcys/aU6v8=;
	b=BpUHGCR0pWLoWgyclPg6MgIldcFYBC7h+bo0g66p8lfvvpTpFRQjRcToJLc70vDVk+ZBWV
	lCinFWqAAhSF29ri+zAyCWOO6va9GDYRTq+255ODaNCB+umnF4FLmQKGtnR+ZrMxIoXpuj
	254NjSN/FgHCP1J7Z/3+de61k5KJ75U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774792048; a=rsa-sha256;
	cv=none;
	b=tIgYc/2goP+T/c6KqTc0Q62gPazkz/nqd1UqQLXCR/xrxDwVR2cUQ2T/1KL5MwV2rDjgtL
	psSo7cXMmNSSLbsu3qJ8cj613iAe49Mg/ICvKGlv0ZtQ1az41LIvJa2tq+IExU95UxLN9J
	KnUvRtfQkgYIAgsTVbScBz4bcULKM2k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hvYAsQt2;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774792047; x=1806328047;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HxHwSqIXKIalnHUH4THevqlWy1d+jJeZ91RpHBQZutI=;
  b=hvYAsQt2DgPcP4BmOkAHOLieA0mAmFQSIH2QHBoFUrAX92lisrol2Den
   wyHwAMDiUGETe5nhufFHHBoVl6Q4J4CsXkv2yT2ZLXlNrTQODZ36dsSxL
   df4oWmAFLGRjwsaBIHMd2s32WDaXxL/zriUYdt9npw55r12xPzNk4clIS
   nlQ+mZwzO2hPB0IJqBaxdhB7ApI7ocV53GpTRLCeQv1ilAvHbLH01yoZu
   7ps+D9k9OziYklvjcKY74GOsOO4hEhZ60hIOxPI8W3jyRaBb6aoJgmhvT
   FVeWyh/P9AOQh9OcTXF/sVJ7J72E3fQqUlyX2ggX/u2KV1x47qUZezSOd
   Q==;
X-CSE-ConnectionGUID: gdF2jcNFSXGmLHkNgd5Sug==
X-CSE-MsgGUID: OMKLX670SZiPIYtazz1Bow==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75818119"
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="75818119"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 06:47:25 -0700
X-CSE-ConnectionGUID: JmQ1czEGRdGH7uHasW2MIg==
X-CSE-MsgGUID: vgLPKTFjTu2hGP5+E8WFmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="219170287"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 29 Mar 2026 06:47:21 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6qU1-00000000CPN-2Lmn;
	Sun, 29 Mar 2026 13:47:17 +0000
Date: Sun, 29 Mar 2026 21:46:55 +0800
From: kernel test robot <lkp@intel.com>
To: Youngjun Park <youngjun.park@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Chris Li <chrisl@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com
Subject: Re: [PATCH v5 1/4] mm: swap: introduce swap tier infrastructure
Message-ID: <202603292156.2V2nVz19-lkp@intel.com>
References: <20260325175453.2523280-2-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325175453.2523280-2-youngjun.park@lge.com>
X-Rspamd-Queue-Id: E58AA4000F
X-Stat-Signature: izsakb6mcyuj51deiwai8wj1ik4o9dih
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774792046-691858
X-HE-Meta: U2FsdGVkX1/Yzm6VXa859wSItX8SYuzfs8aObltHk0ACojgH8OEdWjiH8bH+1WyxgWANiF/eLFXym8TUrnMp/ZV4ppysaLy3/SHnwDUnqqtgnS+VBEWC7oAfd4MwiRkvkKiVliVbeXvXiady1qefntNiVQ/82KzPDdx8Mo1h5PXzDcJpNXEesqpFPhNmnTdJE4JtKv6e8eMDAEY0MTptitw4GmFmfVB0H756IsD/1w1YVmHBEvGfetDmgbUp33uUQQeFPh1iFV5OcymR87ojOpdDrBqPAql7NvAkkn2l3P6iAzP6sdCe8dI14Wq2Pc8tV1vhcIQPyfb90gn5FZ04Df86SV/fCF5ovNhFn0LVCgFKTf0iGsufCsgVbzguxKVpSYD/Ju8CFGKLXL3+wyMoRexulpJz1WAEX2yOpKLHPvHlR/u3IDmrf1OUXiJT32BbfufwiDsnZW3y96V4RBwNyqfpfRmq7Y79vlrxN244EfksHuWMI5V2AIAwH9PBORkSDq0KxBcYhmP540oqJ8QN28DqQ0Oq1+uTp4n4fKM8fdvvBCu1TNGr3Mu5wQRY6+mkSX/RWFnY/dPa7ARlFif+SkJ/0Jjy0EMP2LZu4JDLO5LjDu0Rxq6T2yj9/Siwq23hnGk1ZALtohXYVkqEJidwRmiT4xBT0hoY0XYpDwZtiV4p05TDbspkWejo61y9/KTCnpSrZVqiH9VkfSb2VsCakeBjQ+a6ujz5koD8kJhc27pDDsEtgu9g3lyxBMj3jtQZSkQGfgMJd/W5kYptP9sxo5zRuxIAnD/YqMGy+yJVrhtD5/ev0jfThfm5zOSR9q7s6ZDILGEQHx+Gd68r8hGD1a/UeDY/Vc5P1cNuzf0rhRakgoERI1O/j1+Te5jTj1jlW+84Aworfhts9g+5pNtr5T07O4JL+GKUhKvhqqxlFCUiAnKxVq3DJTifSYB29TCHGG9zpdYsHBPaEr2FQ4E
 XrLDR2o5
 T+QyTK5PpMIo0Kw8j3Q4hQI+lrCvewL83x1CBf57gymlKNkWKmW5rhIThGXlYyjRe7cYhTwpZFAk3n8+9f2GXdwqpz06Bb1WXH/DOKKsbmki6qkKGuiRMq2Ov7EGaU13pAgvu1HrU/UNsvEbk9p3xb4N5oLK5ycZaocgMpjyUEz8INFUVlDt7LiloWMOM/Lnj/3lMZN2GrfQ3Q1/vOEv6SeUQVWF2kQQIbY4IR1RjK2NFOdEZqAhmGiCo9uRVoW3lauzTzabcRjH4y3k6J3i4NmFcp+T79NVukPOYZhsbQuBM1udQV/xQkIbk3K0re4Kh8JxW+RiP1i/oih+b1TM1lT8ggmvw07JeZpHJ
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
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20260329/202603292156.2V2nVz19-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260329/202603292156.2V2nVz19-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603292156.2V2nVz19-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/swap_tier.c: In function 'swap_tiers_sysfs_show':
>> mm/swap_tier.c:116:59: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'int' [-Wformat=]
     116 |                 len += sysfs_emit_at(buf, len, "%-16s %-5ld %-11d %-11d\n",
         |                                                       ~~~~^
         |                                                           |
         |                                                           long int
         |                                                       %-5d


vim +116 mm/swap_tier.c

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
 > 116			len += sysfs_emit_at(buf, len, "%-16s %-5ld %-11d %-11d\n",
   117					     tier->name,
   118					     TIER_IDX(tier),
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

