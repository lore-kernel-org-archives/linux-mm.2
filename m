Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB5BD2502F
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 04:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5898D6B0088; Sun, 11 Jan 2026 23:15:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538626B0089; Sun, 11 Jan 2026 23:15:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4195F6B008A; Sun, 11 Jan 2026 23:15:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 302C66B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 23:15:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A28B1402E9
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:15:04 +0000 (UTC)
X-FDA: 84321996528.19.569E819
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6403E100003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:15:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WxlskozS;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768191302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUM7NNngR8cI4wzlVHRkd7OXhaaQP9ZRsjOD/eGBtF0=;
	b=IEtBjjskB2ZltOr9/2PafTLzhzzH8BsaWprNd8IqToM45PMlDKYjlsJC+U79Dzyvw7PR+G
	dNxuec1wRVbFt0iKWedfzh763gwr4pv9lzY/0DCvDIYgUwcXL1Uvk71XCYE791wRQUcBrx
	676ajmFx8tIv1w3x6dWef1eUQu4FTJI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WxlskozS;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768191302; a=rsa-sha256;
	cv=none;
	b=sRjZAiygOSgJm6QkNEYRiE5bOmqMbcP9rBCUrID+21BQBVXIuc7tdQjlLD+17HPIu23mAX
	KzfSM27KQuUOooOrOXx3Ytx6Z7q+4Rg5POLpMo0aDsPFyNmz37AO0PY4uqtOCh3lkWQA9y
	pGta2ItNk0qVKTZ4yBmHoSLi/AoNlkc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768191301; x=1799727301;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lu1CRJQHNLT2lEZm8W8z6eDoycBU4B0tgxfCG2tr0rk=;
  b=WxlskozSI6PnyK36FlU5MlFxP98LuglkN9RMftxQYItH8x2WS7LiGa4w
   mwRrQrGbB7nGgpOpJNcGF/+B5FQRiyVLMZ31rVY81ZHRq7KTM0F9ZFhfO
   kIKZIDB5P4fNHqFk5eOeGL0f4+DWWXy0LP1xYpGAj08iV2bhldnXXJ0IM
   BOJJnDs1VCc1FZsZ8PCoKtCvHiiu8FowtGb0sp1CT8zakqvYhDepVgl45
   LC0iG0/8V0Jx2MxPz5U9fAFg7+if9Kj8ZfcePzp/QJ1uwQBxfk672z48A
   y34LFcBWka1zcUHenmqV6LdyT0pLzOcN31a8FZhyvGoBH9SAOJXRet2u6
   g==;
X-CSE-ConnectionGUID: R1lJ3UVbRkaZneolroKdmA==
X-CSE-MsgGUID: 6KjpBrLsSFy33p2fvrZIHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="69514396"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="69514396"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 20:14:59 -0800
X-CSE-ConnectionGUID: 6VfZfiHYQOK0o9Ts92d6mQ==
X-CSE-MsgGUID: anpd0ddSQlea4YLXWjlPyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="241518095"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 11 Jan 2026 20:14:54 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vf9KN-00000000CyG-2KZV;
	Mon, 12 Jan 2026 04:14:51 +0000
Date: Mon, 12 Jan 2026 12:14:26 +0800
From: kernel test robot <lkp@intel.com>
To: Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH v4 3/7] fs/dax: Use free_zone_device_folio_prepare()
 helper
Message-ID: <202601121151.afcnEvLk-lkp@intel.com>
References: <20260111205820.830410-4-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260111205820.830410-4-francois.dugast@intel.com>
X-Rspamd-Queue-Id: 6403E100003
X-Stat-Signature: sbbn58e5ig5njtb1qan3xerog5rs5y5b
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768191301-292868
X-HE-Meta: U2FsdGVkX19R/RNZDMw3NGkM8BXSZ5w7/A2ZGt71HOS0MKP7prH7Lw7r9xkkLRnXbgoWIq3UD1EGXrtEv0/ROkxnibVN5tqkE2nmQkFpeVzX2O8Fw0xw1QCc2AY02Ka7eRr5wgovCstNfyeKjsLPZLP/r02fhV6cdlrb0fOzdoWpQ7ddeSbKpUtiSLPSY91uliesjcgb+6hb2sAaZ+lIJzTcrFwGWQw4GtlUW3fE/oyDecd2fKit5sQYDnHNx+2OZTA4jCi9ZVHJM5vbDTs5UWHcSJKRJS/ovuP27YdtP2Z3f7UeDfS/J/3XHt9igfoadlUXnv0I/OCwck/B8C99Bbzu+kzV6wjcdYvEHX9I7wVRvtrH+A7DQysgdCSKnu+pm/Bx1D9YuPiApBP4UbWt0y3+80CxZugEg7PotKMKDGeq3NIh1TsTDom55fSHnLR4M9K2hFTz0F9u13zJdF09CCa4P7Q4QJfDneQT52z/FKxF3Bc83rOcrApW9vLBo83pOSry6KycFVbs8nyKdKl2K5OxT7//UoWdDDZw2sw5eHiYUc38uxeqpzxW8mmc8t0Eyql7taQ+AO6vowAE8Hy9mfCwXpFaPtq+4cwZg//iySrhIywodvI+7Abxle/cPxtEqTfN5jzGaLzUnzHIk1DvxMg4X9vdtzg5z27apdtOZQXIIieYxpmCW4C9EKh7GnBI8xo81l4RkGpKmX2D1CkdUGvyJClxEJD3McztVcFNkyWwy1loixAbFi8VF/GY2/Zw35+mHeyIq3bbSN4Fe+WNY1bNBU0vSljDyyK0G97POroeZ7d+CpSxGDfaMDQ/2L0Sx28oJZJ2Wn51MxuhUYoB2GFTMFnQccehb7UErBCH+lCtMUVaRyhzgwTHkoj2LlhoGv5Gq1o2r6zyZeDacmkR+Yz/ZOmLwidCU+3NbtoL0e2H/dCoVOLA64llNNlaLdA4Mcw0roH471IVaYZEZdE
 KxLIn6V6
 z17lwmLbqFQHr9NPnuZkHhs3b+MDHKUP0TuQH0kFBHRTasJBzAPlEta/K02DNJT7QwWu+MRlig1hGJx7AJm76jOOHrg59DybWRjDqguRVez9NfrY5lmPVjEsmWDdWFtyFCR/0xLscEQuvX/FyZ3Vpp8+KPUPQ7G+YtKoOscCZNOBRcgfLVqttsHSZT8CZpzEu0XVL+4vk/HYL4cAKn41nlt+4CrIU4wSoSl2th2G6SohYbxjdKe4rEPx2P8asJ+hOnh+ufVOXH5c2mjMRZQwdm9uMKg8nbE8faXhJDsMZlPd/xWaWAVSFbQ+KmRZ+sZfRoIMLAcXOF4mNz46FXY+vwPog3G0BcwfmGgidrl5BxSCH6g20QI8YMh3U/6FYmi1P8xF00YrZz4YWtV60oB1Al7mPNwSdGxTHfgOZHhP6w9twJE4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Francois,

kernel test robot noticed the following build warnings:

[auto build test WARNING on drm-tip/drm-tip]
[also build test WARNING on linus/master v6.19-rc4 next-20260109]
[cannot apply to drm-misc/drm-misc-next akpm-mm/mm-everything powerpc/topic/ppc-kvm pci/next pci/for-linus akpm-mm/mm-nonmm-unstable brauner-vfs/vfs.all daeinki-drm-exynos/exynos-drm-next drm/drm-next drm-i915/for-linux-next drm-i915/for-linux-next-fixes]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Francois-Dugast/mm-zone_device-Add-order-argument-to-folio_free-callback/20260112-050347
base:   https://gitlab.freedesktop.org/drm/tip.git drm-tip
patch link:    https://lore.kernel.org/r/20260111205820.830410-4-francois.dugast%40intel.com
patch subject: [PATCH v4 3/7] fs/dax: Use free_zone_device_folio_prepare() helper
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260112/202601121151.afcnEvLk-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260112/202601121151.afcnEvLk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601121151.afcnEvLk-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/dax.c:384:6: warning: unused variable 'order' [-Wunused-variable]
     384 |         int order, i;
         |             ^~~~~
>> fs/dax.c:384:13: warning: unused variable 'i' [-Wunused-variable]
     384 |         int order, i;
         |                    ^
   2 warnings generated.


vim +/order +384 fs/dax.c

38607c62b34b46 Alistair Popple 2025-02-28  380  
38607c62b34b46 Alistair Popple 2025-02-28  381  static inline unsigned long dax_folio_put(struct folio *folio)
6061b69b9a550a Shiyang Ruan    2022-06-03  382  {
38607c62b34b46 Alistair Popple 2025-02-28  383  	unsigned long ref;
38607c62b34b46 Alistair Popple 2025-02-28 @384  	int order, i;
38607c62b34b46 Alistair Popple 2025-02-28  385  
38607c62b34b46 Alistair Popple 2025-02-28  386  	if (!dax_folio_is_shared(folio))
38607c62b34b46 Alistair Popple 2025-02-28  387  		ref = 0;
38607c62b34b46 Alistair Popple 2025-02-28  388  	else
38607c62b34b46 Alistair Popple 2025-02-28  389  		ref = --folio->share;
38607c62b34b46 Alistair Popple 2025-02-28  390  
38607c62b34b46 Alistair Popple 2025-02-28  391  	if (ref)
38607c62b34b46 Alistair Popple 2025-02-28  392  		return ref;
38607c62b34b46 Alistair Popple 2025-02-28  393  
ae869c69ed0719 Matthew Brost   2026-01-11  394  	free_zone_device_folio_prepare(folio);
16900426586032 Shiyang Ruan    2022-12-01  395  
38607c62b34b46 Alistair Popple 2025-02-28  396  	return ref;
16900426586032 Shiyang Ruan    2022-12-01  397  }
16900426586032 Shiyang Ruan    2022-12-01  398  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

