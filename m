Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C5DCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 04:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E178E0005; Tue,  4 Nov 2025 23:20:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE1C8E0002; Tue,  4 Nov 2025 23:20:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01A8C8E0005; Tue,  4 Nov 2025 23:20:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E20458E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 23:20:57 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E6E9160187
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:20:57 +0000 (UTC)
X-FDA: 84075252954.08.F140BF1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf04.hostedemail.com (Postfix) with ESMTP id BB16E4000A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:20:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ImwROvuq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762316455; a=rsa-sha256;
	cv=none;
	b=SZvNtuVnKEtQrsdTTBgOHVMNOHUJso1fWeJbEztlTJ1XWXUsX200DHLNdOtg2RK32JygPy
	mCg4J5AZgvHAJcSkSN6ApkCHX/dLILFtk1CMvyGUCBjbCM+q0QgyVmVpU3NnUAi9Rvvbz4
	FrHKVH0Wyu0tOhbAynZLu108PPcFqz8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ImwROvuq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762316455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zq4W7y+PxrZhypoQbEZTZrrBUkflx9ODl5ddzOQLhBk=;
	b=YKHbuflOXQbeJ+flTubRJhZniALvIogKLcBbvApRQIumbWK42rUhEIi/exWp4sVAsEBi2/
	QMnq39QquDZHVuxPiwm9EqNkTxdEhKTTqvsAXU5dwfL5gYWuorAmiWhb+z+Tx5DLrLee1J
	sGUBv5IfuenErLd6ezE85ldeEkdfcH8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762316455; x=1793852455;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TZ/iCpQhqI2k8DgkkaFJpNQayv4Ws2h8B/Abzdxr+K8=;
  b=ImwROvuq4MfeYEI44RQj3I6rm1yKPYzl90bqsExsd7KtRc60c8K+Ns9p
   JbrS9g2hImKmO3nMpb2Ipsukmz7TdsMG7gv9dxCxAi5Pc/U1ao0Rg/wDq
   LuCt0KJUZK3LmzxmwFWPyEu4cJFdIIIo+MkelTABOXhwqwwoKC5Z+DFw3
   hW5c3EGullp6De1kRgfrsz/vWQ7c3ALxGF8Ozt4YwBBhm2Q+6RUxUg2Hn
   7H6Cvkr/idC7kYJWtQmUoHZS+OxrdvUCo0z4vEMLwww9IHsF0Al1/7eEM
   jNTdHNzye2SCccdlh0DdZG1Kc226a4DnS4RFBbuk4xhdYfooR73fT2BUe
   Q==;
X-CSE-ConnectionGUID: F38YOWsGTJOxPI0sBDMhfw==
X-CSE-MsgGUID: jejOy4buRh6ka8Z5ASvgSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="51992994"
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="51992994"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 20:20:53 -0800
X-CSE-ConnectionGUID: QYLtRUMnQEeRSfVzBGxQ5A==
X-CSE-MsgGUID: FzSmdCbGRSq8R4gHd8Yy8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="191698524"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 04 Nov 2025 20:20:48 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vGV0e-000S9y-33;
	Wed, 05 Nov 2025 04:20:38 +0000
Date: Wed, 5 Nov 2025 12:20:07 +0800
From: kernel test robot <lkp@intel.com>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	m.wieczorretman@pm.me, stable@vger.kernel.org,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Baoquan He <bhe@redhat.com>, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] kasan: Unpoison pcpu chunks with base address tag
Message-ID: <202511051219.fmeaqcaq-lkp@intel.com>
References: <821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman@pm.me>
X-Rspamd-Queue-Id: BB16E4000A
X-Rspamd-Server: rspam07
X-Stat-Signature: et53496ywbgtey1sy9uoga8nuot8x1bw
X-Rspam-User: 
X-HE-Tag: 1762316454-578214
X-HE-Meta: U2FsdGVkX19Z5VhmvUA32+Ktp+PluahDd2ja1DWQPp2F/WND4yTAjtir/Uz8+frid+RRvG53l1Wyp1UYyKv5U0zX8D8f2OMLPXVcvE/jdgFe7PENDrO7/MLXn0Tp5Ra0CaDpuOagXiM+TfbQakhnykB/DRQKtOkRbVMuEekiKA3VbaVLJP8t+eHgoOE8WTbng/lG/5kd4dorW8SC5csYj9/2O2euBHsokyvGHd09NFJ50SOFb4TTnmEYXsUwleiQSlyVXW5zjHjQ3WXVhMQfbxNcWsLMPWM/hlknM5cF5D8iIjLluexEV4/LyNFh4JkQX6i346mmpzgokLX3ziCuK44X8keCXLatBiK9Bq3kHW1KAqWL+9rFMOGYwdSFqdWBE+mFj6jJfkzFJr/iw/kqEESI55HwlZB5XYqHRJkCY2t5d5ZquXt2UCndM5lQvMDrUMwIFtQVihFHSkbUOqB/D/jqsQvGAbm9UYzPn1U/l25Pyf8C3n2HKCvFmGnSufGZx45CPw4aatXmymYt+GHEkrzWNQgJzgsA6hVyvNfMbtjpjn8n/H56RfrSNUe4ds/E0SNWX0EjCi15Q5E06XhUGDdHKTVhziRA0qWYSVlMWJdq3LF3olSTgVeypWn2lPSiG5As3yUC5Bwc9fk8uOhyEmIS3I4g0/vFvsez5kvp7z/+nZPUlElBhF1u55giQUYZ5zwR8t8gxntrepSo2ndlyK5ENuxV50BvQ1UwCx+TwlCfvY6G5b4066eWUFyB1SKcs5KkOViKisiUGokjLpHk/AZ2b5kUL1miZBW+5a9ogpscOkH0Pi1IzE6W+awHbDto1JFM5+mK/YlckZKiZWJBBA0+j1gop+I2dSCH6KsXBOLWmtd7VKo3amAkx9C2y7DMXuFrXy9qVkId8KhOTyRUNePtjBoHNiYIE1xpQIiYE5dO9ANrmEPr5PsfBFDC0gtJLl42kI7oXjwH7RX5/yC
 oDtoHsgN
 lGuL2+P4wNlmQPEYapDUTQpf3bTz8eNTyj+suUYqEteKRpRs2UYlDfHmDmXqLnV3P22c0Zq07PXA5FCTz/p/DyJjnTf5R+qPcc7mmY4a4D96Ru1qJAgunpCttUA9IYRc2Kypr3oZaWwOrD/gjCnlEdckApm3GHoGvVsUkFobmjNoEQQoj8F/nLtAvnCiTQAkL8Tf/SMVlVUjcM9hMhvi5JZyWZbTvjba4WTCDxc13ToAGPVeMP30CJFPs3TiBDQKlA37mIlq7Kowi+nNJYVah7HdzsDeAyS368p4C2Q7C3pF/uWcsxnKTLEbmLGnrgPHIPNsVnqElN3m349uv2HYbUcO2wV5FnV6GYDTJ23hjbmZ2hk85opckzx6I3e25hhjxjBi70T/6IbyO3fBeqoppORoGKwxWjFCPaczwFk7z/JZ8MJk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Maciej,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v6.18-rc4 next-20251104]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Maciej-Wieczor-Retman/kasan-Unpoison-pcpu-chunks-with-base-address-tag/20251104-225204
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman%40pm.me
patch subject: [PATCH v1 1/2] kasan: Unpoison pcpu chunks with base address tag
config: x86_64-buildonly-randconfig-003-20251105 (https://download.01.org/0day-ci/archive/20251105/202511051219.fmeaqcaq-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251105/202511051219.fmeaqcaq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511051219.fmeaqcaq-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/kasan/common.c:584:6: warning: no previous prototype for '__kasan_unpoison_vmap_areas' [-Wmissing-prototypes]
     584 | void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/__kasan_unpoison_vmap_areas +584 mm/kasan/common.c

   583	
 > 584	void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

