Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4D98CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421F88E000A; Mon, 17 Nov 2025 06:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F93A8E0002; Mon, 17 Nov 2025 06:01:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336BF8E000A; Mon, 17 Nov 2025 06:01:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6A68E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:01:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB857BE127
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:01:55 +0000 (UTC)
X-FDA: 84119808990.23.9687496
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id 059F84000E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:01:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gIDgbCRh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763377313; a=rsa-sha256;
	cv=none;
	b=k5vr6S1ObH7COLPiZ2SJNNl67VFpPPHNw+KjJWCQCcqpZk/FIDH9reJPVO1xw/LlN7LY0Q
	vxUFl9J2+BDVywZGEKXCw1w2ze9Ti6p3p0degJEAo0PCY4soVu5chdsSTV9NbdYZFqxtdO
	B9UTeiwtR3vFwITUu/VUp+tcMRgwtdg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gIDgbCRh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763377313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AR3gErWbfXCqQxOcuTHqws+XO+JpvZ9sbbfqPnc4MSU=;
	b=Ey/FdS4h/EsUyBIl7WBf1HaDDOIvvteK/p/3T04K6q0wMXnn5vpDBTFuCZAOsHE7PEmTWx
	5iUY8FAo3v3ksF+dncTrQrTpOF3EeAPVX0jNT9Tvsv5lA8tinxAaAfSNNzZBYKa1KC2VQO
	L2/BWaryf0NbC9EjXEJ+UpN9w+ZXYqE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763377313; x=1794913313;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Hse3M8/Q1jRBh46fLERzOoI/+sJzlRixdpYMCfIrUH8=;
  b=gIDgbCRhriBFmDjrY5hFU3f2mb1E6srU+ABAV0Xkf8zypMUuFStsHmaG
   Wo4C2/g7rb48wN0jYXbmGUSGbRjKX4KtRda8FqHfqR3a5fSOo8uVAm5+q
   iywVTzkMDae+1st47IsoQNMgWlYH6wCFS/YBox804bNCb5CyHym6O9BC0
   u37fRCXLj9vUX4WEl4iHQAZRb+5W/oJYI2GStdt61cHhniM7sz3Frf/1m
   QkhB8WJBYv0bZYcBPgklQyZAN44TyapwaSUDkZCINXa8LbhEi/SPhtq7z
   a6l0P+5kea23hPkL/KgKqKEMfb/dfa1zzQN5C5fX1AIlY8DsgoTSiIMcb
   Q==;
X-CSE-ConnectionGUID: I5vLmWxGS2eJ5iMcf3SN5A==
X-CSE-MsgGUID: KL2YqKhCSwSFKLiOMLHAGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="88020571"
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="88020571"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 03:01:52 -0800
X-CSE-ConnectionGUID: tD8AmtJ6T9aHdAMOJW8g2A==
X-CSE-MsgGUID: XtPIvVhUSHCY0MXVijdj4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="194528106"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 17 Nov 2025 03:01:47 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vKwzQ-0000SR-1w;
	Mon, 17 Nov 2025 11:01:44 +0000
Date: Mon, 17 Nov 2025 19:01:23 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v2 18/19] mm, swap: drop the SWAP_HAS_CACHE flag
Message-ID: <202511171848.KXjpAtyR-lkp@intel.com>
References: <20251117-swap-table-p2-v2-18-37730e6ea6d5@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117-swap-table-p2-v2-18-37730e6ea6d5@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 059F84000E
X-Stat-Signature: 3c4uptco9dsmc41b6agt93ron885dws3
X-HE-Tag: 1763377312-453856
X-HE-Meta: U2FsdGVkX1+nfRL/91/tnKBtN0BQlAirHSzVPD3USg8ZyverSOyysrOfF9CN9HPUZIK8VPji08MPhGtbcgIrtmDwrp4s5ECwg2zkQqpSphqwGjx32xCMrkSDyQ2goJEpbIRgE1x9JgvyPYjdmxN4/wfVwoAmUDuOSzKLnscmVtuUtdU954CeGjl9PR0VeeVlEwl1WyO47AxA+gJXhXv6Hn0FQ20S+N20aM2+8dZ0nObbDAusP9WkeULOJ2WOanZv0BJi8txg80XjuJocPJI4jxde7PemkuBXcLCZ2uL0KCnW8gAdZZgpXtCqsUfXCTLZa34u1jIvz0uQuNV5LEH5tQhONjb7ImlGxkBN3T4xdJdkT43o0wGjZDtWSOW87CguqjmTXl6s9X1YOaOhMf4L4qidy+E6effiLlc33M6P2HIzrG1Z+SC6mPC3CiCufTjro+U7toCiWnhudkHaPN7CNn2MPdskF0RNt6h9IIYtaAO3/5krN657T/1NL178WLyBs9PBXYM9jkLU563+0X7M9loTn9kU6HCq6l/UYoSn1+lAFNTd7xZn6Kau/tib96ytSKX0ZIjHAcWP7ZuJ7c2WTtS71+dRRjEPCrXZT8YFPtRoNvFH5sqzNHK876JFjy/cuE0N0EICYRB14siToWqj/gVqjTT4u/X7z1odLMHpBpbogmj5HEPAaQo1Rjb6lpXHhJsHFmoYxZACEZf+ITc+mbn0d+a6WZ3g9lM3DTHNIlBmRItysvpZTnUa1Zh7W0Uo9AH/bWdiOYavrCOA5ioHhMTrYaaOUoHTHTAAJaxVkqDn9iuxeE6gxKJrvB8qzQAFqsjuDpWwgHco9UmqlgvU7fBEnO2ZBX3/OiXMyvKtPwiFiJD4ytJvKfzdIuVSr3pM3mQTfRsD2xXuCZ2QpWhikURb26T9iaZmZKLFu5oz3DZ/lZkjAfWpGROMSPMJJNIPyzZShdQk9Hj73USvs4r
 6ZdOJYQK
 3qct3a85+iTdA8auU1JjP9f1Cap32isM5tMStx5IRcIIUD6jC5SJyKYzOqhDMolYsA9HHOpzgT85tPHVsKFfQpWCnyClzxX5fJ5I9d2vCQxEMDE8J33U+TnM9ZxcuDx/3twnAaNQa0U+hpoTJTHBSzjKSVlmb9tNTnqJbYx9UKPIc/kJRYPGJPK12EzWDjQzQEJrbcvLiLyb+2FanuWQKBHe4lm+2uewtsT4M3Rcbp2gBHLKtYQ/tjeCw2Q5eqamPDBXMWjrkf57mdOcgO1TRy+o7jcFYjGSujYbL6Ltxjh2K6nysmJtQ4JCexxLWRgJpXlF1XMrdd4EjNu7jjjttGRhL18B7QjcDYX+q3ixsfqmro6vZg6ciscKufss6aLqohN+G1VkiuMOGS50=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 41218ede767f6b218185af65ce919d0cade75f6b]

url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song/mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio/20251117-021532
base:   41218ede767f6b218185af65ce919d0cade75f6b
patch link:    https://lore.kernel.org/r/20251117-swap-table-p2-v2-18-37730e6ea6d5%40tencent.com
patch subject: [PATCH v2 18/19] mm, swap: drop the SWAP_HAS_CACHE flag
config: alpha-defconfig (https://download.01.org/0day-ci/archive/20251117/202511171848.KXjpAtyR-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251117/202511171848.KXjpAtyR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511171848.KXjpAtyR-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/swapfile.c:88:19: warning: 'Unused_offset' defined but not used [-Wunused-const-variable=]
      88 | static const char Unused_offset[] = "Unused swap offset entry ";
         |                   ^~~~~~~~~~~~~


vim +/Unused_offset +88 mm/swapfile.c

^1da177e4c3f415 Linus Torvalds 2005-04-16  84  
^1da177e4c3f415 Linus Torvalds 2005-04-16  85  static const char Bad_file[] = "Bad swap file entry ";
^1da177e4c3f415 Linus Torvalds 2005-04-16  86  static const char Unused_file[] = "Unused swap file entry ";
^1da177e4c3f415 Linus Torvalds 2005-04-16  87  static const char Bad_offset[] = "Bad swap offset entry ";
^1da177e4c3f415 Linus Torvalds 2005-04-16 @88  static const char Unused_offset[] = "Unused swap offset entry ";
^1da177e4c3f415 Linus Torvalds 2005-04-16  89  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

