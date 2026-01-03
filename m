Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C98B6FC6167
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 02:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4F96B0005; Fri,  2 Jan 2026 21:20:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682BB6B0089; Fri,  2 Jan 2026 21:20:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5816D6B008A; Fri,  2 Jan 2026 21:20:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 473AC6B0005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 21:20:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E79A1AB711
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 02:20:36 +0000 (UTC)
X-FDA: 84289048872.06.E618DC4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf06.hostedemail.com (Postfix) with ESMTP id C0FD818000E
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 02:20:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jhB6SX3h;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767406834; a=rsa-sha256;
	cv=none;
	b=8YQ/L3jIrY9trSJNXCAXQH37OYyAczeKyRidCeEkPIGizl0DaaXusZZ80HC6t3E+eEdoT9
	mtpzgwZYwpsGvH00YPnqKAdFnRVAZgbgWLEYvpOMDXD6vJjgFuT/RvDMSzwNJNR0N6THyR
	eRWBVmHqGi+/hQI7Y1kHt/w2VrsIMjc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jhB6SX3h;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767406834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wSbwW0RnlgdvzoJ5Y3X5/CCt2YoP1gq3trPPBi9V/FY=;
	b=K2OAzR6WkoHh2/mK87Q4s4Mi/QWLwG/6JkeP3M58GIIkqHg3625BdMrLnZJF94qp0QDque
	MKpWMWNosdd9ZOqP5Twvwb59n7CP6AO9OgbSHAJ/pvEOCY+6alp1FX6f9/SwuDnUWVOhrc
	dD1niB1uCmOvgJSu5DrdT0NSYlBgl/0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767406834; x=1798942834;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=GAz6lVW9pP3EQThoU4Z64Wm4ELMF1S0wejso0L8U92Y=;
  b=jhB6SX3hkONNf+YnA4sVkUijY+5Rf/GanLxuJDfDqQqCVDWPjm6THJj/
   47MXGsEnIo5u/onnMKJZr8tmxFpEXJVDZwh5/p3LcnKBrmo5ITFLJ29dk
   RR7b+DCEzdNXMYdTB5baAF3Tcl6KKhHfKu/MaddXjwK480Y0adbsRObXT
   bEz3WgRSHFvkaM9qphQKOlFKP/18H48fT421h9r6RxbHCc7Fwc506Vj/6
   Qnsq8ykYOmifxu6EWilQ/Y2HjUxVNvDbvCWcUcgwU9W6p0gTMOj7KwnLT
   S4XKimqvTA+HfMUgSCU7S7KgdXHtiRs2I63ZZeOYaNXsQBWhJS4UDJFRG
   g==;
X-CSE-ConnectionGUID: DTtyGGZeRYm/yJx3fN80FQ==
X-CSE-MsgGUID: lXw3QRApRISQ7QNIlY7lSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11659"; a="68788107"
X-IronPort-AV: E=Sophos;i="6.21,198,1763452800"; 
   d="scan'208";a="68788107"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2026 18:20:32 -0800
X-CSE-ConnectionGUID: cYzilF2MT8G/+TeZ4kaVtw==
X-CSE-MsgGUID: R9/AmzffTsaCv10Cn1bAHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,198,1763452800"; 
   d="scan'208";a="201556561"
Received: from lkp-server01.sh.intel.com (HELO c9aa31daaa89) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 02 Jan 2026 18:20:17 -0800
Received: from kbuild by c9aa31daaa89 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vbrFX-000000002Xt-23O6;
	Sat, 03 Jan 2026 02:20:15 +0000
Date: Sat, 3 Jan 2026 10:19:47 +0800
From: kernel test robot <lkp@intel.com>
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, balbirs@nvidia.com,
	matthew.brost@intel.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
	lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
	airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
	mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca, Felix.Kuehling@amd.com
Subject: Re: [PATCH v1 8/8] mm: Remove device private pages from the physical
 address space
Message-ID: <202601030906.9lgtN5Gq-lkp@intel.com>
References: <20251231043154.42931-9-jniethe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251231043154.42931-9-jniethe@nvidia.com>
X-Rspamd-Queue-Id: C0FD818000E
X-Rspamd-Server: rspam03
X-Stat-Signature: bpn16gzmjbh6bry9wopugo9b7e11e8dk
X-Rspam-User: 
X-HE-Tag: 1767406833-760734
X-HE-Meta: U2FsdGVkX1/hlgidIiBvufLWez5l2tzVrazLwnCAyfvGBwdRBvU0GaCJgHsQ7cq/zj+EUVUhUOn1yfFr9AX7b856e/tXl8KU3RhyI7vW9D/Htd1Gkq4hpxmVicpegFiym4rQOjnKGfFMHOm3yNNY4nnYqqggxvdgFsBtutZNvopS0dRGSV0+UiiukWnV/zMkqZOekVpQ2Ja8hDppVZvFNXxYKTmyT+MCJxuMH3PNx1IxFfl5Mj1SK1VxfGm5EuiWMlaxMawT3R6qEsRNf2P27JQYIfdAs+gTa8x4F4mj97DiTuaJrdmJE7zHCnkqt6PpJToNc/uanHy+PUwqFaT32oePaP3DUYTTf8LQJX18146hDQl9XVQNcwX/tiY566NS8SVhw48Tms9VdgND3X0AHdsJaVowaylhCnqufbsb1O30C0o40kRjvH9zgfU+5PLNWlJ2av6HGPxc8Hz1htaD1UkL31M1xSCuGPlDjgSoQV70JeM3+eWyeMyJPcyY4GmDo2e3A88ngODpQb6SCKlA3T7YylByJ06czqGA8EUZrZ1ZKsGMy3d/j2gwxhxHdETmuGd2KvPJHvhe1ZKJrJaXiIaSLL/iEpEcKW1LWgdejtzvEEmmk6yEPQT9ggGwAKo5fWXo1WMFxeWYVQ3XV458jQNrWOw4NWpn06UPCAbcT7ic3clpwscfdGBt2l+iS30pH+XqD+aSm7Ex9KJEGy784OdU5zNQAG17MJ11dExQ2mG32Orcj+0k4W6fpVZFzfAAPxjbWXB2dTZ5+BB7vTvoCbscG5hfEUbJWX7WZXq9YOZugXkba1GV42zj14Zxkt7wdD1w83Eb10INZmw8DzKVbWjt1OpfxaxxsbwqRtLAxIMrLlmpFJZ91k/mBI1xSVZDjN7+5IO37/D4ig54DB0SlwarQ1C2fJ3g1NXDYZtrWb9uiiITPUcshQZ1eCXFRjJmhqcL9XzVk46cuHl3G0S
 Qy0W6yXl
 uftkrqayAoK+VJLMXdrqZmKAli3k/6nrcVwIoGJDpEXb8wtS8bgAJektJ5am6QpSXNwJnMrmEVLmnV8HGlkqPPDhXM0xsvzl38fAnMXAqKjHr4ls6dMxcAlCRpk/8qh2XiyVDHXvHfsesvHXY2uXP7ftj82hFCgnmlki1s31GtArkAEnLVv4x99WTyilH3UrYLLdg+F1SLGx+OuvVT+34ZBSyqrAljWAWBcm4fRzcKO9b1eqa1ORVIC66aulb12yD5MlaXpNzSKHqNjppqR1xcUrjtoY4QL+WUpRocOI7aLd4fVbZmc1MJIjphe6YgX4zqAgjPJtWVX3afmuX8+FLYVpwkFuw1R0WrKNCH0svFfZG2hSXClE9IT6k2HkwW/ATlb82
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jordan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da]

url:    https://github.com/intel-lab-lkp/linux/commits/Jordan-Niethe/mm-migrate_device-Add-migrate-PFN-flag-to-track-device-private-pages/20251231-123453
base:   f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
patch link:    https://lore.kernel.org/r/20251231043154.42931-9-jniethe%40nvidia.com
patch subject: [PATCH v1 8/8] mm: Remove device private pages from the physical address space
config: s390-allnoconfig (https://download.01.org/0day-ci/archive/20260103/202601030906.9lgtN5Gq-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project f43d6834093b19baf79beda8c0337ab020ac5f17)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260103/202601030906.9lgtN5Gq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601030906.9lgtN5Gq-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/s390/purgatory/purgatory.c:10:
   In file included from include/linux/kexec.h:18:
   In file included from include/linux/vmcore_info.h:6:
   In file included from include/linux/elfcore.h:11:
   In file included from include/linux/ptrace.h:10:
   In file included from include/linux/pid_namespace.h:7:
   In file included from include/linux/mm.h:33:
>> include/linux/memremap.h:148:2: warning: field '' with variable sized type 'union dev_pagemap::(anonymous at include/linux/memremap.h:148:2)' not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
     148 |         union {
         |         ^
   1 warning generated.


vim +148 include/linux/memremap.h

514caf23a70fd6 Christoph Hellwig   2019-06-26  113  
9476df7d80dfc4 Dan Williams        2016-01-15  114  /**
9476df7d80dfc4 Dan Williams        2016-01-15  115   * struct dev_pagemap - metadata for ZONE_DEVICE mappings
4b94ffdc4163ba Dan Williams        2016-01-15  116   * @altmap: pre-allocated/reserved memory for vmemmap allocations
5c2c2587b13235 Dan Williams        2016-01-15  117   * @ref: reference count that pins the devm_memremap_pages() mapping
b80892ca022e9e Christoph Hellwig   2021-10-28  118   * @done: completion for @ref
0c32c9f7a58e77 John Groves         2024-02-05  119   * @type: memory type: see MEMORY_* above in memremap.h
514caf23a70fd6 Christoph Hellwig   2019-06-26  120   * @flags: PGMAP_* flags to specify defailed behavior
c4386bd8ee3a92 Joao Martins        2022-01-14  121   * @vmemmap_shift: structural definition of how the vmemmap page metadata
c4386bd8ee3a92 Joao Martins        2022-01-14  122   *      is populated, specifically the metadata page order.
c4386bd8ee3a92 Joao Martins        2022-01-14  123   *	A zero value (default) uses base pages as the vmemmap metadata
c4386bd8ee3a92 Joao Martins        2022-01-14  124   *	representation. A bigger value will set up compound struct pages
c4386bd8ee3a92 Joao Martins        2022-01-14  125   *	of the requested order value.
1e240e8d4a7d92 Christoph Hellwig   2019-06-26  126   * @ops: method table
f894ddd5ff01d3 Christoph Hellwig   2020-03-16  127   * @owner: an opaque pointer identifying the entity that manages this
f894ddd5ff01d3 Christoph Hellwig   2020-03-16  128   *	instance.  Used by various helpers to make sure that no
f894ddd5ff01d3 Christoph Hellwig   2020-03-16  129   *	foreign ZONE_DEVICE memory is accessed.
0386df765967ce Jordan Niethe       2025-12-31  130   * @nr_range: number of ranges to be mapped. Always == 1 for
0386df765967ce Jordan Niethe       2025-12-31  131   *	MEMORY_DEVICE_PRIVATE.
0386df765967ce Jordan Niethe       2025-12-31  132   * @range: range to be mapped when nr_range == 1. Used as an output param for
0386df765967ce Jordan Niethe       2025-12-31  133   *	MEMORY_DEVICE_PRIVATE.
b7b3c01b191596 Dan Williams        2020-10-13  134   * @ranges: array of ranges to be mapped when nr_range > 1
0386df765967ce Jordan Niethe       2025-12-31  135   * @nr_pages: number of pages requested to be mapped for MEMORY_DEVICE_PRIVATE.
0386df765967ce Jordan Niethe       2025-12-31  136   * @pages: array of nr_pages initialized for MEMORY_DEVICE_PRIVATE.
9476df7d80dfc4 Dan Williams        2016-01-15  137   */
9476df7d80dfc4 Dan Williams        2016-01-15  138  struct dev_pagemap {
e7744aa25cffe2 Logan Gunthorpe     2017-12-29  139  	struct vmem_altmap altmap;
b80892ca022e9e Christoph Hellwig   2021-10-28  140  	struct percpu_ref ref;
24917f6b1041a7 Christoph Hellwig   2019-06-26  141  	struct completion done;
5042db43cc26f5 Jérôme Glisse       2017-09-08  142  	enum memory_type type;
514caf23a70fd6 Christoph Hellwig   2019-06-26  143  	unsigned int flags;
c4386bd8ee3a92 Joao Martins        2022-01-14  144  	unsigned long vmemmap_shift;
1e240e8d4a7d92 Christoph Hellwig   2019-06-26  145  	const struct dev_pagemap_ops *ops;
f894ddd5ff01d3 Christoph Hellwig   2020-03-16  146  	void *owner;
b7b3c01b191596 Dan Williams        2020-10-13  147  	int nr_range;
b7b3c01b191596 Dan Williams        2020-10-13 @148  	union {
b7b3c01b191596 Dan Williams        2020-10-13  149  		struct range range;
06919d226d0113 Gustavo A. R. Silva 2022-09-03  150  		DECLARE_FLEX_ARRAY(struct range, ranges);
b7b3c01b191596 Dan Williams        2020-10-13  151  	};
0386df765967ce Jordan Niethe       2025-12-31  152  	unsigned long nr_pages;
0386df765967ce Jordan Niethe       2025-12-31  153  	struct page *pages;
9476df7d80dfc4 Dan Williams        2016-01-15  154  };
9476df7d80dfc4 Dan Williams        2016-01-15  155  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

