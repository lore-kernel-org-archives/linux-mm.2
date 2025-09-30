Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB17CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F178E0025; Tue, 30 Sep 2025 06:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846D68E0002; Tue, 30 Sep 2025 06:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735CE8E0025; Tue, 30 Sep 2025 06:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5308E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:37:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22E16879ED
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:37:05 +0000 (UTC)
X-FDA: 83945564010.05.2A1D4C6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6EA894000E
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:37:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Tt8KGQZP;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759228623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88Kx28TzCUc5Ni0dMQZ4CP3x1DDoyN7yYAFLq8SMfs4=;
	b=NMSAOQhjdMCb0Ic9EuU9k3H1VW91SR9rCe9398H+3GVs8zR1KZz8/+l7r+/AcIrnCaRmwj
	q9bBoMuyNmzgaOQ3Pbew/6j9CGqEA/dLktN0m4/KEyXzjc1Syb8DXCow97wemOkCMnc2Wt
	PcoY78IQLYWcsLApIn2DTjvUAvb/tBI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759228623; a=rsa-sha256;
	cv=none;
	b=RsnotY9hWlnqHP0YJbQnYEi02ysRrFIe7Ezg3rFHv9f2VEcTgNtvylN/L1ivNacMrjvOBV
	jElystA10dSBkkwg6Tijv1GnDb2jUGUHhKmYxOVrIJpKduhgO/Er4XnnJCaaOQykli/qKk
	nqgy4+gpHuxYxnOU8UW2prFBjsm/rpg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Tt8KGQZP;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759228622; x=1790764622;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=sbz5AL1wVvoPI4VgrY33BmNwLhxdJAx+xAgmOKchchs=;
  b=Tt8KGQZP32wYuccDgiyd0v0DG2zWTtb8UMHw4vmkx72hWk51u+H94Sah
   XU/b96rBD0W0Z0nx56w7ncYFlXDFqB2aorQNd3yj1uUiOkhBTK7SYc26j
   qKGEzJt9ePat6qc1V3jGXOXKxsSi8XgNHKB3SStcDewNX+tAMspwfVl+9
   oqkfR6JFD5cOtMoY3+uVSl5LaJHF2241yY39OInRar+GSqyECjStpwQ3a
   cYH1M6yw2mcwvlQRGV6s8QOwqODqxFwDsNER4eyWqs+9E8F/tb2pDIDhM
   jgQXSAzQrMSeUtqchsBFdjqlLXKX8vX2vFqUsqtyzeBRr0DD97yaTrPMr
   A==;
X-CSE-ConnectionGUID: qkCujV9tR5izRy5c7tyGXQ==
X-CSE-MsgGUID: JsJhgTyTSIG8c2vBky4fBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="61589873"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="61589873"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 03:37:00 -0700
X-CSE-ConnectionGUID: 1JEwtSrhQpaqBfQvrOYe3A==
X-CSE-MsgGUID: ORJaRpGvQfCsMc7rucxYXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="178283490"
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 30 Sep 2025 03:36:52 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v3Xj0-0001Ax-0s;
	Tue, 30 Sep 2025 10:36:50 +0000
Date: Tue, 30 Sep 2025 18:36:07 +0800
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
	=?utf-8?Q?Miko=C5=82aj?= Wasiak <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, kernel@collabora.com
Subject: Re: [PATCH 6/8] drm/panthor: Introduce huge tmpfs mount point option
Message-ID: <202509301834.aoEcLO0C-lkp@intel.com>
References: <20250929200316.18417-7-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250929200316.18417-7-loic.molinari@collabora.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6EA894000E
X-Stat-Signature: 17s3umxgyxaaqzdcm8pjez1rat3tt96w
X-Rspam-User: 
X-HE-Tag: 1759228622-859289
X-HE-Meta: U2FsdGVkX1+rAS60hE2tseR73TPwIiMhGt5TlkozO1HH3G8Ykr7RWsfE6efCNhYWBx3OfFB2cYFreWZUTxzyEZIPJIGWp1yyHLS4DVx1x5lgjdKPF7uwbqqL4a30HJaCXbLKhBqjMx2scybKJJWbJcU06jpgws480Zk7RoTKbkyE/lphrX9AoQtQkIKyqReIqAS8YmcOkUhEVdLCITZsH3inj4OkIi1RAgXcUL2axht+G3DHPCu12YY0V2R/6K2IEhLuh4ZBFX/kLwZ8v2G9zxc4AB2+xEhnTErsaNeuT6VNaeRhAbTsm21rGvt0p9dYGfVfif9kCf5SXnTbAbx2O1U5rsUctDkvrE0sBdW6ZNjMPK69hj+P+tx/yTjdiWf3XuqGDCqIRJggu978jVGR9oXAtxUU3XozwLiP0uB2eW6DzRLkwQFAexhrTFQKwQDrkQGBsTO7NwvIojVQWOaBNzPeYHJTnudFTRCDa6xfx5zK8TJdvu89wnd9TtvxTiJwTBt3Ys25Xe0oxq3rARGEB5ajJkVBN52x0e+Q1+Y4BA7MY3NQpBzFf0nmeDnoonUkfP0IUoLhcImLCtsvXXCu0e2HlThaznXtzna8+z+L7WwYvAzRi871FCcVpLUASjCCgi7mhGOxwCTmn6VAT+LxwI9rax8uTRHfUXD9v7n/w0spFQlS5YS9YSrffB8AcdckKHb/N3bM+mGAAb8SV7cOqYyLByBN76gIJOCx8i2Pyeg3SuTrZZmX404wWCE/G8NgjkVc0dcxbNQmZiefcepqbM0+Pa3xJnRZJyCAd9iBcmw/dJa2/cY/I0XdABbzbnKjrrMpM2oLfJ3nvUVuOQ21YcLN6i9iQMPQkN1RrGx5JOKIg403hYSoQDcBSJavFTHc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Loïc,

kernel test robot noticed the following build errors:

[auto build test ERROR on drm-misc/drm-misc-next]
[cannot apply to akpm-mm/mm-everything linus/master v6.17 next-20250929]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lo-c-Molinari/drm-shmem-helper-Add-huge-page-fault-handler/20250930-040600
base:   git://anongit.freedesktop.org/drm/drm-misc drm-misc-next
patch link:    https://lore.kernel.org/r/20250929200316.18417-7-loic.molinari%40collabora.com
patch subject: [PATCH 6/8] drm/panthor: Introduce huge tmpfs mount point option
config: i386-buildonly-randconfig-004-20250930 (https://download.01.org/0day-ci/archive/20250930/202509301834.aoEcLO0C-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250930/202509301834.aoEcLO0C-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509301834.aoEcLO0C-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/gpu/drm/panthor/panthor_gem.c: In function 'panthor_gem_init':
>> drivers/gpu/drm/panthor/panthor_gem.c:24:14: error: 'panthor_transparent_hugepage' undeclared (first use in this function); did you mean 'has_transparent_hugepage'?
      24 |         if (!panthor_transparent_hugepage)
         |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |              has_transparent_hugepage
   drivers/gpu/drm/panthor/panthor_gem.c:24:14: note: each undeclared identifier is reported only once for each function it appears in


vim +24 drivers/gpu/drm/panthor/panthor_gem.c

    19	
    20	void panthor_gem_init(struct panthor_device *ptdev)
    21	{
    22		struct vfsmount *huge_mnt;
    23	
  > 24		if (!panthor_transparent_hugepage)
    25			return;
    26	
    27		huge_mnt = drm_gem_shmem_huge_mnt_create("within_size");
    28		if (IS_ERR(huge_mnt)) {
    29			drm_warn(&ptdev->base, "Can't use Transparent Hugepage (%ld)\n",
    30				 PTR_ERR(huge_mnt));
    31			return;
    32		}
    33	
    34		ptdev->huge_mnt = huge_mnt;
    35	
    36		drm_info(&ptdev->base, "Using Transparent Hugepage\n");
    37	}
    38	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

