Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A50EE909BA
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 15:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68CCE6B0005; Tue, 17 Feb 2026 10:27:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6646E6B008A; Tue, 17 Feb 2026 10:27:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59AE66B008C; Tue, 17 Feb 2026 10:27:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48D7F6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:27:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D21121A0200
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:27:58 +0000 (UTC)
X-FDA: 84454329036.28.3B73B8B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9FDC7C000A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:27:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ffmYRJM8;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771342076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZrUvAlSi93l78LQiQZbipqnY3r/ZG3qjFD6S/BDxNjI=;
	b=tGJPRWwzxssDm8dyU+SCRtGD3bpImTpUjUmbY+twJaKUmm+xgJ2C8tqoxOFtDX3557tX4D
	K1XrL+D69bRgEgwJp4HkY+8FHJ/8aEmuH7s4O7oNjJv+REFzmKmXyi7LAE4tmg3NtyqYJV
	EYR1+3P8Btp32tGKV4CBxUzTzM2fKrU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771342076; a=rsa-sha256;
	cv=none;
	b=wb4PSisfddp2ckdz0G+ZMhA/4UMQLgYTv/DdtICPPv2lNmW3zCN1hcrhqly8CQeLR/wNi8
	WEIs1gEdTEADun0ss1CSZFnCc+MArIe8zrKeq4qWdlibJgyBbE+UaPcOKodWPBVsFOe3qH
	xOzFnCrqU+6SF7CphYVZ0VtzD0Xiquc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ffmYRJM8;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771342076; x=1802878076;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=camCf+hMhDCMoC/dJnwKFdEJluxi3duXst4BvOZyGNk=;
  b=ffmYRJM8Fp5hidwEYw5Dw1pUBPzz6zCQJBjfMKX/14P9l829Zwls80+i
   U1V3grOLde8jwivK0XKJnvLEV4YFraD3UfT4MjapCgdcXr5Rh4eG3PTh4
   NUJm0asveM1w6Q/1PIEfJcggHPgXUmBri3cI61go1TFAmM9smX2yI2QlI
   aMr2geiRLHzvgCBHwYICAA43WS/4CnzbayAwGEn7E8rZkhJtWw+r5gkjt
   2RbZWRQHumERiL2p4oHqJnmb8vdjuM4R9Q5DS5LvtFuahDhUiBPUjG8L8
   Lkrt+0MASiepWiFfXd/v1QYPzeziaXHxGCFaMCw3xha3fT46frhUwCVyy
   A==;
X-CSE-ConnectionGUID: Q+RpwujPQc2efx0dJ2AB5w==
X-CSE-MsgGUID: KlIZ1sszQqWBdND83cfrFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="72125699"
X-IronPort-AV: E=Sophos;i="6.21,296,1763452800"; 
   d="scan'208";a="72125699"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 07:27:54 -0800
X-CSE-ConnectionGUID: 0xAn4PJMRCqyOVKaDo5Keg==
X-CSE-MsgGUID: iDkey0zJTbC4GUUgB5IS0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,296,1763452800"; 
   d="scan'208";a="218043448"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 17 Feb 2026 07:27:50 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vsMzL-0000000115k-15b4;
	Tue, 17 Feb 2026 15:27:47 +0000
Date: Tue, 17 Feb 2026 23:27:04 +0800
From: kernel test robot <lkp@intel.com>
To: Youngjun Park <youngjun.park@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
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
Subject: Re: [PATCH v4 1/4] mm: swap: introduce swap tier infrastructure
Message-ID: <202602172319.SHQ7btgd-lkp@intel.com>
References: <20260217000950.4015880-2-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217000950.4015880-2-youngjun.park@lge.com>
X-Rspam-User: 
X-Stat-Signature: n4hf4euf5hrp1ryncjemehkymcqx1z1s
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9FDC7C000A
X-HE-Tag: 1771342075-560938
X-HE-Meta: U2FsdGVkX18jr77AJiFXAzDUqrt1ZMlCfjpaWrsqI+YI5pWEAWvfT9mtq1oR5ekDun3NgDjgdZl2fBzZkcTSH7F0uzUYksfvSb0axHL0VSOFL14XxrMas7LTyMTdVH+C4yPhTN+iUV3gDBYdz1BEpCTC7br7gN3pqE4FPsItyYnDanj0F9DRSmLsPd9byy/r3hHTs62mmmQof8d9LU6bql5BUGSlU1b9VYbZBbVBmqSgvqVxxN6s4kjw+LG+dJYutAkHrnPj+PTFMiUiSmVncgcJ1O9KRb639Mt6V/sL70sf3zklSEoHH28zjjN4rl3oOYstgKc1cVd8V3hF/1USpw8R/Io//V0UqvSZK9BQsfXEYrri2tQg0d3iiJuXL0OreEBW/WJga0PU4VGvd07BiWY6vl8/ubhHnMzjU7LhXKIj8kkJUTuVBsGSUMK8yZWGW3C+eYXdKRmcfn2TYVNTb808WhnhH3sBV0qgAicfb/sXjxYd+6TTbrATx8KMxK+7xQ9ashjoXnazjhkwfcqkG+SdGkDbkmcXpPg/L/LT9oUdSvM7HipZW01Jom/uEQa1Wtf9jmXBtzbgVyACSPly+jQq+/FPA2qVR8DEoL4tsnbd4ugeahjEVtEzzCOAO/BHjLKbBhmgiR7rSDCRYJvHDIyCx7RFI8pVubeJ8+heP5iLWjYLy76IPMAmJW1ZwlWKO345J4PRH/uUXGxr+65/yH8lZbeST8drPgJeuzTCR2bykcQ//elqlxsCaW6rHLh8YuGAFvkDxh4aZ0F1KBZKJ24rrtAzrXdp6hdowfaPz1lM/063jcGZAehh2rewlUAodtkkKNRSqASHhok6QfzjeKlSKYIj/RqkjrfXYaD1biiKGAFDVrFCBKnc4OVSxoszv/Km1oGc80ph77t3/qLQUYx3csadFrzGzUvhyZm3IB9nJ80zPnyGj7yVKaVyl8Pdp79NHmjguUkr1AY0E9D
 /3JTR3dX
 7DGaqavj/qWvHPYWtMJgWUv7Ez1abQDnDTCxzIQtdvRkb0xGBNLfqdAYLAuFYHpqXwO4w+OIEugI0HQ+QNvKq4cDhgJs4UFNrNqZOV+NX83QGhghnLTRtAPvtKOsvWIjHs96D4tEPOnVbwI43wXgbEcz8Igeq7SOadaYHTMaQwcBPcmI/nlW4NRUEYEeSg7ovV3wJ/gLqlKHzVZmLodr8usJ9pmR1AP9tPyLVAfjpE2+KyZN5qWnNK7gJWlD0c8Lp8SpK3Rp2aIKbI4qcLEUjH1cjNxtP0AuX5GgZYE1BJCaTAcBBdl3AcG/5LEYXjBA3KRoRh3obMm7glIgMVOwzVy4BNK7muKkWV8en
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youngjun,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 776250964cbaa49ebe6b8bb2870765cc89cece59]

url:    https://github.com/intel-lab-lkp/linux/commits/Youngjun-Park/mm-swap-introduce-swap-tier-infrastructure/20260217-121406
base:   776250964cbaa49ebe6b8bb2870765cc89cece59
patch link:    https://lore.kernel.org/r/20260217000950.4015880-2-youngjun.park%40lge.com
patch subject: [PATCH v4 1/4] mm: swap: introduce swap tier infrastructure
config: hexagon-randconfig-002-20260217 (https://download.01.org/0day-ci/archive/20260217/202602172319.SHQ7btgd-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project e86750b29fa0ff207cd43213d66dabe565417638)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260217/202602172319.SHQ7btgd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602172319.SHQ7btgd-lkp@intel.com/

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

