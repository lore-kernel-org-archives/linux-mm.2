Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50FACA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 02:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635A990002D; Tue, 12 Aug 2025 22:25:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C358E019E; Tue, 12 Aug 2025 22:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5497290002D; Tue, 12 Aug 2025 22:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 459DB8E019E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:25:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E935160212
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:25:05 +0000 (UTC)
X-FDA: 83770141770.09.931F3C7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf04.hostedemail.com (Postfix) with ESMTP id 30DA940008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:25:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KJFToEM0;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755051903; a=rsa-sha256;
	cv=none;
	b=5mo60OJIgGfd/4Nv/2oelSUaxrkyNWze7/fHwbrJ8rFJdKqgIyL6FhveSopEkpQWslp2Yk
	B7DEkv8LBzTQMBUtFd4sfxKzCTy6EhQO2fcEsFsFdCLYgHwyvagFnlpVAxRCXey5XGKf+8
	QhsoUHp2yLGICIsWTO5FcBtMsqpYBi0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KJFToEM0;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755051903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKbU9RXkwqDsNDWtehedXJy8w/i36YSqUEDNOcUclKI=;
	b=T4HWJmZUiiiAnn1Rr7ZNi31Q/xRy/NiUgPMaCQXhtf4eqtY4ib9ohe9sZhj7YmFRvEioNf
	bARm6PnkUHtSj6eBbeVb1V8bF0EFSX1MVPS/dW0nEQxyI7+QDW/A+tsvvaLa44rurt1PoZ
	tHWC2HT/JVTGmwsKjMkCLGbnpYzYjmA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755051904; x=1786587904;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TO08Bxdjs6CXgwQaNnTK3VsCDBnZs98H7CvXOF1PSiw=;
  b=KJFToEM0U7I1BwWm42ygwn7SKlLXOfvAY4S1QIrLUw0/Zx28JQsSla8F
   xCLaAJnDhEgVpv3BqPnMkhkSaBoYn1xNafe4n6AwGWf5A8V0U2E6Hz1ug
   /XVxOSTAeijR1LW3fuBoNhZDsEz0+sZQGLKNAFbl1ySZrtrxTkfRi3e5Y
   GT5cut4SDDvpvaJnTmZP1+Yn7dGDwRa5dxcwWq4OxLv9CZhFE3dawvt9e
   y+4LtPGU3aRVrgvU07NRyQPGNnvTB0elQXYFVCEz7WUSrDdm55BizwX7k
   MZYY3eDZ4jt6kRsRAA2oU5riDaEMixkaPknSdUa73ngjGaOBzSS6H6+tS
   A==;
X-CSE-ConnectionGUID: NCvH+stARKK8F1rILntFlw==
X-CSE-MsgGUID: rH5OANEpTLSmCGoveeUjUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57416212"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="57416212"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 19:25:02 -0700
X-CSE-ConnectionGUID: R7Jgn4tkRgOyjuOYDP9Yvw==
X-CSE-MsgGUID: 3weZF238QHG4vGIuMOZAOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="165571477"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 12 Aug 2025 19:24:55 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1um1Aa-0009T2-1I;
	Wed, 13 Aug 2025 02:24:52 +0000
Date: Wed, 13 Aug 2025 10:23:39 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [v3 10/11] gpu/drm/nouveau: add THP migration support
Message-ID: <202508130923.0VGA41Zv-lkp@intel.com>
References: <20250812024036.690064-11-balbirs@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812024036.690064-11-balbirs@nvidia.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 30DA940008
X-Stat-Signature: sqteocgy6ouecb5bm9j73jzpwfxfktzk
X-HE-Tag: 1755051902-663638
X-HE-Meta: U2FsdGVkX1/AV2xb3V6gD1HVrcd7Ce5n4rKyOSk0gEbT3m1KDwkPSnLwI+9utUZZpG74COhkrxYxg4Bq/KWGHmUIexBwEPnmk+hnWHzqC0WZLhdEQBVNgv/ZYWKgmg4cujBRc1r9y7EIs9U7PjocQ5RsRemqUbqopoI8DilFTy3oHGhhr/dSzfyNZiUYMw1h2YHU9hCf166ips0ntBSIquOZSz1lhQe4ynoDRNneMLS3IWiwT3vb+2RgE4Jeqf2VfqKnMhaNqBjrSnKVAaqZ6F0AErdfbYkrqiM2wg7dBvdxg07j+MseLPC5KF7MhAOJMdUe7KxlN0eI7Vibm+tjLvRUxIDOmmR+7y2DkTk4GMzINHOE0fuCyI5c2GWHc9WviMnIb+HX4fN8x+2thGYne6UjPAKIAnhjYtx0QbwP3krEYAEZHzJaTlnH6dJJ/Pj8AEYDzB59CgLFDw0mqoEcfq/1RVz6nhuvWoh2q3HPSuWj7Ep9MF/JcANZUDedpDC6+CQNOGrsxfjL6Wi8aBL797XsucPQthlR6rLouI5NYOX8+8uxmUnJB15lGqtmFep3hl9tq+c9ruMsp4oTfSme6MvZUjWIGD7A6O0PlTAsqaro4cbvmPGrKJaXyHS9VeyFcs3fPdD3owdHdGttzNBr/v/IV0ASfYvPNMEx3OtQ2ZdkeSFxM1omuirL7cAkmebjig63nn6y+iuyVdUHRFvhwYEwN1VOt7t1kHFnPlxwNBOdkdgQiWvd5GcWS9S2V4KDm6lkmJDxRTgoOXLzlrE1lhF1GvSK8RBh6f0zb1siZx0lt1KwSISqLa3uAaUuaL9H443R0s1Ro2n3taAYaY4X3vVQb9Jx/qCiEd8sidH0raLK99e5AWOfYJhriHRda9OwdpJQ/Ew80/w21CyD7KZo3Caq+bkjQo97dpy5HB3TN4UN4PkOPWpiTfoduGOhkSmlu83oPZcoxT+JIBGz8B/
 3tvyNe80
 J3ERhsF+UER1W8snP+LfcGtVztLIWs/bhY4XfOSlfCst0WNbk1q63zs14qg5IAA/vbC6i8Iw9jN4iVVSDnktjF2Y+IQIYK+D/u4RtJCnzowpcDueUw+Lh9SnrS5iNaVzzZ7Ki+Bykz5QdGGN2WdoGPfvhvPziOnTazJR0+QKq5LuIMFUtt5Nrf38Rvz3LwISakJqL32BopfH/kCCcHoc+ESiLBjBYV9x0ZxYBk7dfMX+gXcsJqoVyzNgApkUzLGHHLit8pbOQMYgPibym7RGZrASQUEQgAdylXkLQheemByaKMYCo2yHPNSQbVmFCTzhbQ5RaBYEFVVf5kVdGgREd5SlVvoJd4/AYPv1K/XrgandaDrDyKq+dcWZcSBab7fZPWenqkpWbTcHCou2zAwyfY1jjg0z8e3+IWJCysTA8BfB5LRQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Balbir,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Balbir-Singh/mm-zone_device-support-large-zone-device-private-folios/20250812-105145
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250812024036.690064-11-balbirs%40nvidia.com
patch subject: [v3 10/11] gpu/drm/nouveau: add THP migration support
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20250813/202508130923.0VGA41Zv-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250813/202508130923.0VGA41Zv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508130923.0VGA41Zv-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   drivers/gpu/drm/nouveau/nouveau_dmem.c: In function 'nouveau_dmem_migrate_vma':
>> include/linux/compiler_types.h:572:45: error: call to '__compiletime_assert_706' declared with attribute error: max((1<<((16 + __pte_index_size)-16)), max) signedness error
     572 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:553:25: note: in definition of macro '__compiletime_assert'
     553 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:572:9: note: in expansion of macro '_compiletime_assert'
     572 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:93:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      93 |         BUILD_BUG_ON_MSG(!__types_ok(ux, uy),           \
         |         ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:98:9: note: in expansion of macro '__careful_cmp_once'
      98 |         __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:112:25: note: in expansion of macro '__careful_cmp'
     112 | #define max(x, y)       __careful_cmp(max, x, y)
         |                         ^~~~~~~~~~~~~
   drivers/gpu/drm/nouveau/nouveau_dmem.c:811:23: note: in expansion of macro 'max'
     811 |                 max = max(HPAGE_PMD_NR, max);
         |                       ^~~
--
   In file included from <command-line>:
   nouveau/nouveau_dmem.c: In function 'nouveau_dmem_migrate_vma':
>> include/linux/compiler_types.h:572:45: error: call to '__compiletime_assert_706' declared with attribute error: max((1<<((16 + __pte_index_size)-16)), max) signedness error
     572 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:553:25: note: in definition of macro '__compiletime_assert'
     553 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:572:9: note: in expansion of macro '_compiletime_assert'
     572 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:93:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      93 |         BUILD_BUG_ON_MSG(!__types_ok(ux, uy),           \
         |         ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:98:9: note: in expansion of macro '__careful_cmp_once'
      98 |         __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:112:25: note: in expansion of macro '__careful_cmp'
     112 | #define max(x, y)       __careful_cmp(max, x, y)
         |                         ^~~~~~~~~~~~~
   nouveau/nouveau_dmem.c:811:23: note: in expansion of macro 'max'
     811 |                 max = max(HPAGE_PMD_NR, max);
         |                       ^~~


vim +/__compiletime_assert_706 +572 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  558  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  559  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  560  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  561  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  562  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  563   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  564   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  565   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  566   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  567   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  568   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  569   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  570   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  571  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @572  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  573  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

