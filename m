Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43CB3CCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 11:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F00C8E000B; Tue, 30 Sep 2025 07:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1188E0002; Tue, 30 Sep 2025 07:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6858E000B; Tue, 30 Sep 2025 07:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 551A28E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:07:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03F1A13B912
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:07:12 +0000 (UTC)
X-FDA: 83945639946.08.90376AB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id 29CA518000C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:07:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IT+FFGI1;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759230431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1N3Nl/gjvjuLHpamSuOor7c8Ws/+l+3fmOuCnsL69X0=;
	b=IO6IAh+zymZnkEoRFf7VugmPQjBZHPQ0Q2gUbkR84oGvdb/aBWcsEqhWr/slB90ThD1fxD
	mOCzMx6gk/Qd7SQktML93PAoB5VfZtTgfumFxaA2IddyUfWvPA3ZrA+ly2o/xSs4wJpJFi
	SmyqQYI+WL2X+PqNW/xwHX4wLiaMNIk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IT+FFGI1;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759230431; a=rsa-sha256;
	cv=none;
	b=jSjZ2qPR4C7KRscY41rieTHS0u9EBq7ot29UXcVgiZ9stW60ewss61CggKbVQmJrZBnPfk
	k4Fh5408BDfWwmhZpk2zcXbUvqS1davyfEbfjwzAhSWujE34vnM+DW6ib7wXKWku6Umwk7
	k1+MmmIkee7ZI8qgxb3P6BZ641QsKXw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759230430; x=1790766430;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=JkEgfrFobUvPs9WUhYazXemTzj5bNBhLW05gn5e7dd8=;
  b=IT+FFGI1KLnMQvn4oITorRYxZ4jYEvSvqr7r55FAfh3t81BawpZWXU28
   w61XhVDxefT3LAi1tDV+6ZccaUYDe45fdGPjReCT+xdP5ZeiSw60acU0K
   9EX8ZEobopYQM8T74XKTduL57MDf5CiowO7rkHPNP1CaCF/VDck7n+dnW
   4dgcoxWdd1xV2L2jfQyj+N1cr/Rl1kN6W4Yi+VzW4/OaOlEs1B3ZaDvS/
   IWq0Q+7AASwnNNih395NA6q1kv6VpAe30daelXw0gWRsgYEPKqEMbYVDc
   lBJI21dNd2fm6BH5DdeDRq+aXBIft+py6oE6LtuUssGZAUM+D57HY4GDo
   g==;
X-CSE-ConnectionGUID: sNP/egWwS4ClvsTJBLppeA==
X-CSE-MsgGUID: uY5D3rBPQ56I3oZOOaPjEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="72907813"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="72907813"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 04:07:09 -0700
X-CSE-ConnectionGUID: MY9ov9QwQ5GXH8kC6Jesqg==
X-CSE-MsgGUID: HZtVzlPZRheexbv1wLS3bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="177763539"
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 30 Sep 2025 04:07:01 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v3YCB-0001CR-16;
	Tue, 30 Sep 2025 11:06:59 +0000
Date: Tue, 30 Sep 2025 19:06:41 +0800
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
Subject: Re: [PATCH 4/8] drm/i915: Use huge tmpfs mount point helpers
Message-ID: <202509301837.pQ2TiJkx-lkp@intel.com>
References: <20250929200316.18417-5-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250929200316.18417-5-loic.molinari@collabora.com>
X-Rspamd-Queue-Id: 29CA518000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wtfqsfot4t8cmaunr3zethix3euftzjd
X-HE-Tag: 1759230429-196998
X-HE-Meta: U2FsdGVkX19HGrNqyAc2mNenXghQtKSGyvjQ0l8KNmVTmAxayeBbIs5yZGlYcMmqvB2t4GrGgIsCnESIKyVdJbl4/C47n8ylTMiPZfI8qjyIXf74GFp2BWK0ryEfj5gEyspXB2QisH4xTwazhhjp1IAI/JR3GpuDc2WsEN08isfH5c9MUl+0Rr4q3755lm/vlxezO5JhFXuDQcFcDAknuWxPjFRO2jrV1EEyYIbKxEUW3l/41TEjNShTL/5mT57afk5/0bULZYCzbzro3P63AW7Ig44pWlGwfNe7RQtpok8ZylSjduxyCoB0A1qXRdUnDUNy7Djp3L1+JzdGIgNRj8JsCJLvj0XAxZa9DCkNqlKifqGV5ZQiQvvmN7cVM28GmqdaMuQVwMV5l7igpChMWwlzeKgmHPbO2eJwsT+MxPZLZnvX5mEWNBUBNgNOLd/7Tg0SttFgsMGh1cw5iFOEg+yOm0mpZCFG2nmmQTZwK2bBTrSADjY/Ty8EcVpajZfn/mI1sICW/h3EMNRLv/Cln1nbixTRyu0W9fiGUE7vFbuCm2POvEWyeUaOUyy06YS2jruivsTjov4AsuqyqkJahzYLkx6/Q0ZPFk9vZRhv1GX3SSbEuX8kU613x4Xjp3iqcCOQzdrBZu+MFdvxp+IiDFQov9agM4gEhGSJ1BPCeW9I/td8CWtulO4hFIasa+hEIlGm+gJziah2yyw7K1nqoZhZEI2xGg19qDg/NI2nyW1ivk52TYj8Ik5UGeL1W7YDgYhgePaoizJA86ACQac6ThFvaFL5W9ZPwYPiXi3ogF2jrttlRPkNGwGCNqk2dNvaQakLzolJh6wPChTkXhlnzdJZo/Tu3Jo5AiwhADQJt+NFM7mM7ezSkt5S3tPf63ehCtkn9IgO10A0A4u9WDoBre6AHG89v2t69m6OKuzF4xtw1Q45qgt7MojAQ9MJH8GICmnFvr7TpWpC2O8rRx6
 aefxZQo6
 hYfFnrdbZKVuVf1Em6jz5zu59nC8/Lt7xop7NKvXwpTU3p6mLqlHuvEpYmuQjZ235LJzuRYJKu/Y8HcKrKP2imXdu7pCJxzvbjd1iUVdWuj5IkC5laoLuT9HblOy5M/lSVk3rvP0VGSdhHEnGzHDAhZFvLSdvp3WDB6uJf4SGVgmbI3OzMS9fFubzKO5vzZFPy/T+bBxMPoVo8KyLQS7Tu4DrBu+q3TOo+hZcEhERq3hshz5GzKxAujny/oYZ5Dc6rcDyq2SFlMM62fHb3SPUCbqbwuPPAmAl8byvmf+x9ABl4IYPGBVEsJ7s0nWofQgpwaW8m0A19wVz9fx92TdW4EkU0bU/w+vtMAsW6lpuys2utF6Tk+WpqDPKWmFxlxTIUt8o8APPztDMdwukvJI7+/PnAiEE7CBmXmPu3Y8ak4z5MQWSrrq3ybpU4DiAMdEehD3YtnP1tXNvORRXZwwoqmEA5WRMLiUTQsTg0oACgThzY6s0Ha6LZssvfQ==
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
patch link:    https://lore.kernel.org/r/20250929200316.18417-5-loic.molinari%40collabora.com
patch subject: [PATCH 4/8] drm/i915: Use huge tmpfs mount point helpers
config: i386-randconfig-013-20250930 (https://download.01.org/0day-ci/archive/20250930/202509301837.pQ2TiJkx-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250930/202509301837.pQ2TiJkx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509301837.pQ2TiJkx-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/gpu/drm/i915/gem/i915_gemfs.c: In function 'i915_gemfs_init':
>> drivers/gpu/drm/i915/gem/i915_gemfs.c:29:17: error: implicit declaration of function 'drm_gem_shmem_huge_mnt_create' [-Wimplicit-function-declaration]
      29 |         gemfs = drm_gem_shmem_huge_mnt_create("within_size");
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/gpu/drm/i915/gem/i915_gemfs.c:29:15: error: assignment to 'struct vfsmount *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
      29 |         gemfs = drm_gem_shmem_huge_mnt_create("within_size");
         |               ^
   drivers/gpu/drm/i915/gem/i915_gemfs.c: In function 'i915_gemfs_fini':
>> drivers/gpu/drm/i915/gem/i915_gemfs.c:46:9: error: implicit declaration of function 'drm_gem_shmem_huge_mnt_free' [-Wimplicit-function-declaration]
      46 |         drm_gem_shmem_huge_mnt_free(i915->mm.gemfs);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/drm_gem_shmem_huge_mnt_create +29 drivers/gpu/drm/i915/gem/i915_gemfs.c

     9	
    10	void i915_gemfs_init(struct drm_i915_private *i915)
    11	{
    12		struct vfsmount *gemfs;
    13	
    14		/*
    15		 * By creating our own shmemfs mountpoint, we can pass in
    16		 * mount flags that better match our usecase.
    17		 *
    18		 * One example, although it is probably better with a per-file
    19		 * control, is selecting huge page allocations ("huge=within_size").
    20		 * However, we only do so on platforms which benefit from it, or to
    21		 * offset the overhead of iommu lookups, where with latter it is a net
    22		 * win even on platforms which would otherwise see some performance
    23		 * regressions such a slow reads issue on Broadwell and Skylake.
    24		 */
    25	
    26		if (GRAPHICS_VER(i915) < 11 && !i915_vtd_active(i915))
    27			return;
    28	
  > 29		gemfs = drm_gem_shmem_huge_mnt_create("within_size");
    30		if (IS_ERR(gemfs))
    31			goto err;
    32	
    33		i915->mm.gemfs = gemfs;
    34		drm_info(&i915->drm, "Using Transparent Hugepages\n");
    35		return;
    36	
    37	err:
    38		drm_notice(&i915->drm,
    39			   "Transparent Hugepage support is recommended for optimal performance%s\n",
    40			   GRAPHICS_VER(i915) >= 11 ? " on this platform!" :
    41						      " when IOMMU is enabled!");
    42	}
    43	
    44	void i915_gemfs_fini(struct drm_i915_private *i915)
    45	{
  > 46		drm_gem_shmem_huge_mnt_free(i915->mm.gemfs);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

