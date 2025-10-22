Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B900CCD1A5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 03:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0118E0009; Tue, 21 Oct 2025 23:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788068E0002; Tue, 21 Oct 2025 23:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69DC38E0009; Tue, 21 Oct 2025 23:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 584C28E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:27:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BEB948901
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:27:18 +0000 (UTC)
X-FDA: 84024314556.02.E37F3E2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3D6EA4000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:27:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MFHqnYTB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761103635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZdfXWSZhef5WqLXCBdbu964pFLqYb1NG4mazyJho74=;
	b=IooJtGRiadv8wlD53xwwJmqTjJm29zFfqSMO28jXt4TFYHZirKW1mJZfrPGzmoNZH5cz/v
	nJqkXkFn1MNBZIkvgeoM13k9ufkhE1IuCPJl+N45ESqtTx951bgGQ49/nbp41sjUKmOh8+
	QyBbNvH4xnzx+JX32c9+DtNX02dKyCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761103635; a=rsa-sha256;
	cv=none;
	b=jWW6Z1lEnkF5E75ueV6UunEEZxSaEpOm3wdS/pr0VphA+cQl0ArBDPyXhVtJvVHXd7j/zF
	ZV0UfvseqXoy74VoTMCXotJjInt2IC8UYl7ZeTVwecie+tRM3Om3RX1Ewc/nVXrm/59uzN
	Qg6rBfHsZFnCIci4qs4JQtS/ucCUnO8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MFHqnYTB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761103635; x=1792639635;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=8070DwsbZV3/pdL9u+Z6F5R9lIi4i2kvgareiNlnUV0=;
  b=MFHqnYTB2NXqMLHMaqmm3JVOU3FJ0+j0ordGK+5QwAqCTV4YwCsRiAJz
   se5L11kuglKgDHTEbBH9l3ctOLbNSw9Fcu3tBjyimICzJ1bRsxtB1SMHE
   HOwYQjbblJG+KJdwkS4c2JHbMh9qdYkt57+RabKtw/qe3NJjIM8kMsVBc
   aj0TGLMqzQ18aTzaBMn2kW242hcZOxF2bL20u6HFDjfNh4RQ2xna4d+ns
   9iiQrerbUoZwWBpbbgA0bos5VPfjPu65KAQl27CDpvWFlEK5m1rMw81KX
   mrP2EZfYgzch6eOG6nCkpntHRhK7VCrc97Cc9XIXRSLoW1b6nBAtPj1CU
   w==;
X-CSE-ConnectionGUID: LoUfNLB9T2ON0BIB4VQ+cQ==
X-CSE-MsgGUID: 5wdnoD8BTCScCBhQ4RP+ew==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80865879"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="80865879"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 20:27:13 -0700
X-CSE-ConnectionGUID: Qw31trbgTLWbZLnZdXZCBw==
X-CSE-MsgGUID: dPYj7/ylReC8zLJtllPJGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="187797373"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 21 Oct 2025 20:27:07 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vBPV2-000Bxh-1F;
	Wed, 22 Oct 2025 03:26:58 +0000
Date: Wed, 22 Oct 2025 11:25:10 +0800
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
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 06/12] drm/i915: Use huge tmpfs mountpoint helpers
Message-ID: <202510221301.wU3TSqMg-lkp@intel.com>
References: <20251021113049.17242-7-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251021113049.17242-7-loic.molinari@collabora.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D6EA4000A
X-Rspamd-Server: rspam02
X-Stat-Signature: h68zj88t88nhrkiqb19o6dcswpfcpwao
X-HE-Tag: 1761103635-252555
X-HE-Meta: U2FsdGVkX18Hb73N8WJrydWjZVTXCNmEWPc6yCgU66maERT44VMBvkwTRtP+MrkASj1CJk01ZCNNLyErHw0Mvj9vht5CrxDRt0uY0X+zyOe1Li0drt8IP33BR3bzzlHPXgmn8EgIE711iQDlQublnGH9pLr8lFrL8/GtltiFaxIryQ8AJoaGZUmUDvxBp0XOwFCTFQO18O4U+FJrr2T+1YiO8L8iQnZCTQAIpbDcxoGxhOHtIO9AYqMC8yZ4YS1jVSFnAUt0GdNKaHMTcMgeG/el++P58J1bImVbiTn5uuWKsjbDsEkC6y1GpP6BHsjlw6HvBsAdIon+oCRQByIAcvemf+IzKFMT8GzgPF/AzbR7Jnk0/zCTgkEMvhTq6+yuCRdyPQLNrfsXVqle+4G7N8rUpC7twHQJmJ24/AwrcGnLBA/fSAncVtOJehk+IxcZgSFzzseLpFYlYG8c6oOkXUbpOvaG0RCdOQF/JAAibr1R0Y+M6mJ2+E3MBGUIDBzLRHMyymkLH1luxARDSnr2DG2U93um/tA+5MYQiVNGu65GXiJ3JsAJLEvB7W0i+vFh30LXu4w7oHSmWCUzpe3N/OBquhcTjg+2Lq4J9LJuajg+TcA9bjGNp9kyQtzmg7JkjHQ/umCemedS1/zIdmk9jcAMjbNMcn8lk0eppxXVTIsmyQLe1wWm1gfMyFDmZ5h78ghDzQZosV1D/dcTsg08phEITBfT8g5QhbJgwEonUAOT173Gt6WaGOhOVaPSV2yRDHEGsQAcsDRwfTCrAqupCGmrfMkbpAKX9E40HH9aoJWCE7gAjU3B9U8n+WKxUM1pGtWxjQe+PlT+oswXze+oKwQEm0Y/6IUjDPIUIrzB8XbJihiUts4eb8C+3hqM1nFnjuvFQIYAx4NYVbcOdUL5c2SljCGrO0VhGpaXg6l68QaGFkXQNGICXgkFn3WvXjmZJZtlusSsJxKW7AbSAZJ
 r9039S2F
 h3GTn4GrNqqQZGWkHVBFeFI4tVtCr8DwcTVyhNA62iBtDZXt5RZysfj832cRET7PYqFIwKozh2yCSHSci5nCS24IvqwYB09d9WW9AkA9vvetF2bRF8wpOJFQJE212QEJD1MSAAtRgt6ZvKxGSb5nj8O6ABarjiE4t/6U8V9iJ0kasENVRfl7CheL0kNlvN1ALogNzhnwOvylQMPNJmKjmlybXtZnj0W8s7lg3sObcrTdJTJ15oFpehYKnkfAf3dLC7/g+2EGc4e++h0I7NDL8f8DDM/zYQ8DWBV3gxwPCaAHn4OWdkICNvlKX5tYewIR/63aVuaB4uflaHFJ4Sezy8ou/gqo8pINVOCueYMCYs/xp1WCY0WFKucMoEQV4md6vGkY06/DqopfEl7XntC+TAcisC7iaWJgM9H26hSr6oU/WBa39Pz4VKIkTzQ==
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
config: x86_64-randconfig-003-20251022 (https://download.01.org/0day-ci/archive/20251022/202510221301.wU3TSqMg-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251022/202510221301.wU3TSqMg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510221301.wU3TSqMg-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/gpu/drm/i915/gem/i915_gem_shmem.c: In function '__create_shmem':
>> drivers/gpu/drm/i915/gem/i915_gem_shmem.c:511:59: error: 'struct drm_device' has no member named 'huge_mnt'
     511 |                 filp = shmem_file_setup_with_mnt(i915->drm.huge_mnt, "i915",
         |                                                           ^


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

