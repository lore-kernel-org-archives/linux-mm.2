Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F8010F2865
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 19:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 837B16B008C; Fri, 27 Mar 2026 15:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80EE36B0095; Fri, 27 Mar 2026 15:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724D56B0096; Fri, 27 Mar 2026 15:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0EA6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:07:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E64513AB68
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:07:04 +0000 (UTC)
X-FDA: 84592775568.25.A25C645
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CC1D40011
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:07:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UfXZG6rj;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774638422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmS+edh1qp65YWTEvc6IhgJSZLlTCjrxwgs6O8yvkVI=;
	b=3dKqYDmo/WBxHwdNgVZKf9lUN5lgSatRu5787cExJqWe3TtE7gIDnnTUJIXy4NL80J1m/8
	Z/9Ih1NQVpObQj9y7hmewejrDFS3LfCNua/vWQCTBRNYWJiq9rYKNt0YqIUc6S2yQd2+d9
	7inB78OD0n+Vn0ESkiI7ylCTonsYpx8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774638422; a=rsa-sha256;
	cv=none;
	b=34HHIh5a7Dw7EPcjbQ1xatMgIqHWZz1KM4yvbgNp7jCDnvkTfFzYBvVfgVvxrhMpJyeggu
	WIc0wmFul/UJ25K4dVKPnrukORgn9LBEPBsgtLb2FqH6gF1JpdlLH0K8DGvCFt5J5VFhNC
	v9CttPOO8E08ad/Hrnzsq9BTWjhYobU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UfXZG6rj;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774638421; x=1806174421;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8LZlpASHsA/Y6GOiRodaZwiHzKtI3/rlF/snT/eGlms=;
  b=UfXZG6rjLc4BQCFFkRyN7hr35kU+dgsgO3d5M0ot9Lsl/HD2mjluqamH
   5+akA8dRqDNbDt3orTQDOJBgXCC35lHpeZUpKU29KFK0/+Y+MYj7tQCrR
   hXKYPGDqJzC/qUtBhVTB+TcaAa++sf2tKiwre3YOScRzMVZNAzNuvaiYn
   gXF2w/BBwNcUKqj5MHRmXZFZUDYpSwrpzVFd7LqeCkU1uyjXVjMP7UbOz
   NgelPEAS2GiHx4QruwSIV8DHnREi24DdZzdKnonJs5lMNhtoeeUu9ibym
   j8SW6nvaat5Ja4bEbiXxfyIjYto/FvS/aimwDgd9Az0wNfTdlLpwToQZj
   A==;
X-CSE-ConnectionGUID: SToCm7ihTyCC/DTWD2FgsA==
X-CSE-MsgGUID: sm6lhLGrTqCKpnuf4Dk8kQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="87106858"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="87106858"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 12:07:00 -0700
X-CSE-ConnectionGUID: Z5niJQO1RvmVh1ZvWMioiw==
X-CSE-MsgGUID: 9x50k4KTT0Ox7iyJ5PzXxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="222529332"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa008.fm.intel.com with ESMTP; 27 Mar 2026 12:06:56 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6CWD-000000007Xh-48qU;
	Fri, 27 Mar 2026 19:06:53 +0000
Date: Fri, 27 Mar 2026 20:06:53 +0100
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
Subject: Re: [PATCH v5 2/4] mm: swap: associate swap devices with tiers
Message-ID: <202603271922.UNxxB12b-lkp@intel.com>
References: <20260325175453.2523280-3-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325175453.2523280-3-youngjun.park@lge.com>
X-Rspamd-Queue-Id: 5CC1D40011
X-Stat-Signature: zj4e6nz9xossuu16ud554o3gjt3wgm93
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774638421-779275
X-HE-Meta: U2FsdGVkX1+IyjqBSSE3aKGgvU5FbCn+HscXhE4siCJGOrnTh98aN9AHYjdoCDJBEAbGlu9DZeg05ZnF7nyic57CxahDxZiup6LnfmY2mewaCx3uugtC9KXJ8xReHLf7Nl2Mcqo6WTbyYyZxgC9q7KNThtygvawfORUQRJFj+c0+msY0AVC7v3YrYT7+OV+D+rio968ln3QM8mjBsCBCFJ7zfqrwYciN9aB4aIb7aloAQL71cw7UUUfpLvlzlJ1rt6yoa9w0keM84OzUSLRSuMBFea+KSXcTH5GaFnN70PT59Os9NP+RTdc2uA6N4rintpYaoaPY2TAKxgRp2CxW92xwNUAawjqb3nJrmpjaF+KbAlTAsXhe4ANih23p4LRoGRntc9Tui3FjURo/jN2G++cAI54QFOTC2ZvEJfiPvWN9OJej0i1LTbK8IGxd4BxEIf9XuaGc0Pq7B5/cvMc73WJPFesBIuVUqvpUwQPDecTlJIEW+jOMs49D2tHJm7cAcjsmNU/BStu51ifBrb8oTYqa8GZyfrpf/awzJ0n/X7r9A13omDSnyySI9qMvb5hyIVvktp8MaZf+6mD+TSkzqEDaK0YEOY1/r6Mn9uUVrekwt8NR3XNo888g9N0rf/PTRx5H1lBABwSPZ6e+is7U86oyjR8riRE7kanxaT6y+r4qOybYM/wpKBTmBuYDPmFLCO/kumV5GHBoQ6qOEVgvCVv44QRaNEeSZX2Appq9HJb5kPinY4rjfxvNvi9KybXaeWOD6bzIqeJCChqW/20ZhKFSnMWckJer6ytyxwwzZWpFQk1qumHNQvjMraG213hkvHMYjpmG4gLRZYJ+O+7NwZjBPetUht0osKtWBtHoIugmGX+3CX06AQSmqUF157/DzO9uTP2iBrbk1F8zPkjY/S2S1I6RssDyvaYhdcLoWZBD4KZi2tnOuX4UOMucIa72JW7FAUOMqs472EHrrEE
 b3PDdyJ5
 ot/RMjKwEzy71fSP9vkv1xE5dARAB+xcAGHmsZA262Jm+hTh81VjSbrfPK3uI2MxCxoMxdCJIE3QWgvi0JrWp07UnlHW5rjl3q0SXqit6Drw6OgI3HNbtU8hdyxYXB2nQJCwZgIDRvH0V3aWk2zwfdIYaIFOWjhQQakUojAFoJVBEN7XlED7RKeAbRo+5b5/w53Us2xSY7w5XLEO/REvbo4FwCnbTLvAGM5N7GqEmJBGNSKO1utnGj+OgTY1zXeeSphygyq8mtuCfUvtD3qrCbhFNofY+FIWtFlp/zIotuBzNw6vC0Sjj+DHy75b6+q8uTafO8OGbL1ZOqC92iBBQRnlTjHOrUSgz8rc8
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
patch link:    https://lore.kernel.org/r/20260325175453.2523280-3-youngjun.park%40lge.com
patch subject: [PATCH v5 2/4] mm: swap: associate swap devices with tiers
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
docutils: docutils (Docutils 0.21.2, Python 3.13.5, on linux)
reproduce: (https://download.01.org/0day-ci/archive/20260327/202603271922.UNxxB12b-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603271922.UNxxB12b-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Non-Preserved Properties
   ======================== [docutils]
>> Documentation/mm/swap-tier.rst:19: WARNING: Title underline too short.
--
   Documentation/userspace-api/landlock:526: ./include/uapi/linux/landlock.h:45: ERROR: Unknown target name: "network flags". [docutils]
   Documentation/userspace-api/landlock:526: ./include/uapi/linux/landlock.h:50: ERROR: Unknown target name: "scope flags". [docutils]
   Documentation/userspace-api/landlock:526: ./include/uapi/linux/landlock.h:24: ERROR: Unknown target name: "filesystem flags". [docutils]
   Documentation/userspace-api/landlock:535: ./include/uapi/linux/landlock.h:166: ERROR: Unknown target name: "filesystem flags". [docutils]
   Documentation/userspace-api/landlock:535: ./include/uapi/linux/landlock.h:189: ERROR: Unknown target name: "network flags". [docutils]
>> Documentation/mm/swap-tier.rst: WARNING: document isn't included in any toctree [toc.not_included]
   Documentation/networking/skbuff:36: ./include/linux/skbuff.h:181: WARNING: Failed to create a cross reference. A title or caption not found: 'crc' [ref.ref]


vim +19 Documentation/mm/swap-tier.rst

    17	
    18	Use case
  > 19	-------
    20	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

