Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CFABCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 01:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0EE8E000B; Tue, 21 Oct 2025 21:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C988F8E0002; Tue, 21 Oct 2025 21:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87CB8E000B; Tue, 21 Oct 2025 21:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A62CA8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:47:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4318D1A06DD
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:47:48 +0000 (UTC)
X-FDA: 84024063816.07.16CE446
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id 29A7C40002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:47:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="M/GX7j8T";
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761097666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXxCjv2nm0Rd7fDR77w/LRlzeIE5FgrNghMqiGOeWD0=;
	b=IqE8aihr9h3VjlwiIKD/ztat0p0hYcv9MkC3RUyx0O818GA8EBd8ZTJfaCjL7nwU5x0YGe
	Mufj0lppsBamLoB/H9NPNAKMZ+8VUVGBjGQV+pSdU7BQY1vgHE6LM33wlwCpAxP4ABjoZs
	juZh3BNIxP2iDQquw3W5XyfqAODtIa4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="M/GX7j8T";
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761097666; a=rsa-sha256;
	cv=none;
	b=FWMglr4sd67m5EgI/lCozBv7tRibPPJs+G/z+xiJTkFxYeXcWLlkhUtvL6YWwHLZFg+r/x
	XNnVcxdTKNk7/4SWbpzUSmg6II5sdXGJUORZzKgnnGEIS+2SbYcR5DE0sEo5Kr+QrJna/K
	s+5RdYERyKcb9jH3eHqCDIsYBJNpVq4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761097665; x=1792633665;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=SYrjklv5yaqTa9b2Mz801w7XycbmljMb3/5NvgufkhA=;
  b=M/GX7j8Tcvo52Uiu/+Y4FDvLJOtMm9mL76nvFwn8utCTvzeaq9Q5WiXq
   9BZ4bl/YeYE8Io+fJyJox3WYBcCAQAzvqnmG8ZGjuvlHvLWhEytTOofj7
   EdZ4pHaZt2m2n6gaq+2b4LLgwiPt3uDw9zr5Sfvi9E7YyFSNBW/V0PrSw
   60t+sXeAql1ooIOl9thvcScVe4yIHr8cDlknVoHnsMTFOM1o2TXwMSMn2
   BA2+cjP1DIr6shO3nb8BH+RkTf6rUdT1aaCcm/oS0Kj2ii0g/V7PczvKK
   m1Guc68FyVTKUXt7z+1DaqFS2I2HIDMsUebZWub9YrP/3za2Gszkor8zI
   g==;
X-CSE-ConnectionGUID: Szna7kLuSi2s7H3RNwbi+w==
X-CSE-MsgGUID: E6iLKcmWQGutS8BApu8QbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63274735"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="63274735"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 18:47:44 -0700
X-CSE-ConnectionGUID: 64Y6jRp/QL6Aq2MJZAFxRg==
X-CSE-MsgGUID: fNuSc6gfQGOh7smNgfyucQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="182947416"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 21 Oct 2025 18:47:37 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vBNws-000BuR-28;
	Wed, 22 Oct 2025 01:47:34 +0000
Date: Wed, 22 Oct 2025 09:47:33 +0800
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Lo=EFc?= Molinari <loic.molinari@collabora.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
	=?iso-8859-1?Q?Ma=EDra?= Canal <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Christopher Healy <healych@amazon.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 06/12] drm/i915: Use huge tmpfs mountpoint helpers
Message-ID: <202510220918.LOLA5KIF-lkp@intel.com>
References: <20251021113049.17242-7-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251021113049.17242-7-loic.molinari@collabora.com>
X-Rspamd-Queue-Id: 29A7C40002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: c7oeb84axqnt4odurxtwb6h6rzxtk98t
X-HE-Tag: 1761097664-65603
X-HE-Meta: U2FsdGVkX1/w9smYBVrU521owtieNdYMIrLOQljZORuH/cU1OATBQjLamn+/9HUlgJvAfGM/ThSec78PQ6NTwPUPHNi300QtsnrdSI+erJs83ImUGeZsKfhcbQIMqqXE9v6Shwv2vuybZXOPkEfFACb94I6T1bB8E0Eowjs8JxJjtU26bNwtc0pHEuRjX6vPd1phYZYOkj5/2RAbYvHhxXWirJUddm5enZlyHfZM1RZALROJawNMKWjGT5+xUj3TdwtGxecEJANr42vXpOEqOLhXTvqNdOGWUW+4Po2gp2ISi2PpzAd6aqFP4bRXzoAqLsMxaeLSdH93lH6zHOSpibEhcRYCZClo2WPUe9yYdRXB7OmaHAxQJimAgGv3xDwA39CCH0kFKw7Ra/Vb/DF2byYZPmDYSre4siJQAiczFHHXxviuw7NMkqmw9Ks523Ev6b973XhvC+vgCEpBWNRwJaIeo7oh6lFqVD2z3dGUiBWGaSXGFQ1YNGQJC2fSxgcunv8HY4BjM1jM+KwoiBkJ5pwuXQO/sYycOD65xeWSOvOz5DjNLOaEL7CHb/BK1A3NK1oERDR/ASAPK3sASGAeGNGwXIqblg0ai9aoE9ZDGRVQmjxgfBTcguiC/ogspdLt3fucWIPSdPGnD1YZJEejW6xzeDSdE9sg/udBO02ulsS9WJlEaMfvdVQOqmv97q1g3lf95lpds3UGkgjN2c4eQWBEnXdBG5gUrXY7JCBadhrEYnZ2ofwgOf4k4UYo+hcfdYeZOR8tpjRGmJO/9pL9fntML1LGxhgIB65liFvJH443FOATHzTQccEw0sTXMLnI8xDv1Xc7vy2udA4QWOYY14WD238twzxvQ6jJoY+Eu+RjVbQLo0dqBGXrqETmgDy8pJu61X2mkWrcELFi5zgXnsdZXKV9eI/N2EdFPBKai3pJRze2pdDd/iRy0nOm86CjB6HExyuAdCsLlceY6pH
 yGU1vCxI
 PrxKUd0O80gIGp64CCfDgPPVcLk1VP7OWw1rghxa3cBu7IXifsJIC2ko1ddYkeKhB2XsnjMux3hjiRp5Qe4LfzqWml7QC5Y1e8/v2sacIPJxFzt/thIwpDAMtVUl1/Zi+tYj3pPy7LTdbAUxM0RVPN+nndq+HVj8zyzOef+N+3wCOiuu2DWu2j/28r4WD0oMVo9gtTlgloEC8CXJldaDcBt3BFW4Tza3fYuOppdTsuxObR3jbsN6ZVcFuzXdiM/fqvLydhv8qgkt1A1JjN2JLoOd1nDL9XIRU+NgQMF3ooGL8+QZhmeNUf1yst6VMeMcbD8Z2dndwfXsWvgW8BH1SLHZJnb4G3hglV2q1YztdvmGv5H6akuC6Ojyx8+2uTPW6g0FqVWZmkzPuNqTwyMsLkMbMRXjlHkwz1S+wuU+Oh/60d9ULw31j/g0uZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Loïc,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20251021]
[also build test ERROR on v6.18-rc2]
[cannot apply to akpm-mm/mm-everything drm-misc/drm-misc-next linus/master v6.18-rc2 v6.18-rc1 v6.17]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lo-c-Molinari/drm-shmem-helper-Simplify-page-offset-calculation-in-fault-handler/20251021-193355
base:   next-20251021
patch link:    https://lore.kernel.org/r/20251021113049.17242-7-loic.molinari%40collabora.com
patch subject: [PATCH v5 06/12] drm/i915: Use huge tmpfs mountpoint helpers
config: x86_64-buildonly-randconfig-001-20251022 (https://download.01.org/0day-ci/archive/20251022/202510220918.LOLA5KIF-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251022/202510220918.LOLA5KIF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510220918.LOLA5KIF-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/gpu/drm/i915/gem/i915_gem_shmem.c:511:46: error: no member named 'huge_mnt' in 'struct drm_device'
     511 |                 filp = shmem_file_setup_with_mnt(i915->drm.huge_mnt, "i915",
         |                                                  ~~~~~~~~~ ^
   1 error generated.


vim +511 drivers/gpu/drm/i915/gem/i915_gem_shmem.c

   486	
   487	static int __create_shmem(struct drm_i915_private *i915,
   488				  struct drm_gem_object *obj,
   489				  resource_size_t size)
   490	{
   491		unsigned long flags = VM_NORESERVE;
   492		struct file *filp;
   493	
   494		drm_gem_private_object_init(&i915->drm, obj, size);
   495	
   496		/* XXX: The __shmem_file_setup() function returns -EINVAL if size is
   497		 * greater than MAX_LFS_FILESIZE.
   498		 * To handle the same error as other code that returns -E2BIG when
   499		 * the size is too large, we add a code that returns -E2BIG when the
   500		 * size is larger than the size that can be handled.
   501		 * If BITS_PER_LONG is 32, size > MAX_LFS_FILESIZE is always false,
   502		 * so we only needs to check when BITS_PER_LONG is 64.
   503		 * If BITS_PER_LONG is 32, E2BIG checks are processed when
   504		 * i915_gem_object_size_2big() is called before init_object() callback
   505		 * is called.
   506		 */
   507		if (BITS_PER_LONG == 64 && size > MAX_LFS_FILESIZE)
   508			return -E2BIG;
   509	
   510		if (drm_gem_has_huge_mnt(&i915->drm))
 > 511			filp = shmem_file_setup_with_mnt(i915->drm.huge_mnt, "i915",
   512							 size, flags);
   513		else
   514			filp = shmem_file_setup("i915", size, flags);
   515		if (IS_ERR(filp))
   516			return PTR_ERR(filp);
   517	
   518		/*
   519		 * Prevent -EFBIG by allowing large writes beyond MAX_NON_LFS on shmem
   520		 * objects by setting O_LARGEFILE.
   521		 */
   522		if (force_o_largefile())
   523			filp->f_flags |= O_LARGEFILE;
   524	
   525		obj->filp = filp;
   526		return 0;
   527	}
   528	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

