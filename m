Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E7E5E7C71E
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 13:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31F8C6B0005; Sun,  1 Feb 2026 08:04:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD4C6B0089; Sun,  1 Feb 2026 08:04:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8F06B008A; Sun,  1 Feb 2026 08:04:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC066B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 08:04:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC56913BE68
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 13:04:02 +0000 (UTC)
X-FDA: 84395905524.01.A5ABFB6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf13.hostedemail.com (Postfix) with ESMTP id 03A6120002
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 13:03:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="lsd28/01";
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769951040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1PWc9/54O7DPE1urxqdZHaylpF5xEjc39oqRVstw+I=;
	b=36OteNcjzV15n/bBiC+0F8q/gL/mMNnIM3/IAlcWxkV/0nJhV+Yzot+b4TTVg7BMz+B2wf
	ZAgwbsIOWSZAd97tmtG4gWj4LeDxU9Uv72h8xpU/nR6pB5qN7eWUl7Pz7WKJwaJsdYtIVT
	Do0ewpmWXRlUJm3B/1ygFgSvPVNQHw4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="lsd28/01";
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769951040; a=rsa-sha256;
	cv=none;
	b=JAeP9CVjbUs0rG+3GQYDPPbXckWIpQ3w0U9iwTEAM9ahTyIHGm0wk9FaA48KRi/En5THuH
	sFODSzeqvlgU0ny97Xq4GJIP0XgnZaqH07B22/tBR3tpfGpf8dPhkkSjhoFB/Nq4GUBztw
	uBOxU7azyejJ8t6g4KkGrVgKCRVK2+w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769951040; x=1801487040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JxRbL3UiA7chywZx7s/1NhqsSsDE4+0tIBI21pQzhp8=;
  b=lsd28/01GUkLQxwaU1QyfEiFFdTNclCyENPb/09+Eeh3spWvMIXBfPSD
   hpvbNq99F+/8zPgk/+rBlqg/HrRrCDHjkKC/LtJLGifAUkLt8xR6AB2TE
   +UgiQ0XqsTxa1bWZhzVmHuNi5ckkCbmJ3p1nnDwc0efCm9VF45e8WYR34
   zmirikPUIE3DABtAqMvzaWFjc2UXdB8A1mkSy9x257HwoDxWqihhQCXIp
   vF5kbGiL9hXLBNC0N/gGfCHgOQoellAkQrzoAFf+kl9i3UQ9efeAgdl8f
   ce6O4Dj7HvtUUCoWq4WNGMl7LHAj47KbT6fkOeUq0yotWdeK9hPgrUW89
   A==;
X-CSE-ConnectionGUID: VyKcKuV+TlqKadpXfjVtzQ==
X-CSE-MsgGUID: 2J5Vn24wSa+3PRFNfcRbqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11688"; a="70149722"
X-IronPort-AV: E=Sophos;i="6.21,266,1763452800"; 
   d="scan'208";a="70149722"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2026 05:03:58 -0800
X-CSE-ConnectionGUID: 3kWg8PvUTxuKPPw4OIctOQ==
X-CSE-MsgGUID: TrdnJnaNRvGEGGazG0k4kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,266,1763452800"; 
   d="scan'208";a="209048462"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 01 Feb 2026 05:03:52 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vmX7F-00000000elw-1KtL;
	Sun, 01 Feb 2026 13:03:49 +0000
Date: Sun, 1 Feb 2026 21:03:02 +0800
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
	jgg@ziepe.ca, Felix.Kuehling@amd.com, jniethe@nvidia.com,
	jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au
Subject: Re: [PATCH v5 13/13] mm: Remove device private pages from the
 physical address space
Message-ID: <202602012037.jpAjBFBa-lkp@intel.com>
References: <20260130111050.53670-14-jniethe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130111050.53670-14-jniethe@nvidia.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 03A6120002
X-Stat-Signature: 37duk5n9amn4pbafr7n8fremkgzhsjzg
X-Rspam-User: 
X-HE-Tag: 1769951039-516634
X-HE-Meta: U2FsdGVkX188d0nDnJwfJkC6QOJwnYZAP35FDG0OnhRBWqXcpRfuC7n6TccZmt/yVGwMN0EGGz2v+l7BPCjVM3McX6SJUIvcRMYr8bW46L1eMc0fPU1n286XIrGOpgNX431oi235tZL5IZPF3a7uScxCkue1rVOWQKRFId9ttWaTToi2XLUk+TsZ43pScKJrDD2k8Xbb0oCAD70fVNL9XmCasq9ueFNAjiYCLG7rP88ONZDZGt2yTEsn253IPyY1A2r4Gg5MTY+qirOxYcKUYsoWkyKzR9OLH2huZJ1pE3L8RrYiAYI6Cf/l3XG3+M3K9DbBkECxcw8unqG7eVFB4RuZs9L+jOvENFtAGtVE4Qog+I6lns6vQJ9c1WqkSA+69871XYJCTuKKe5gi5Ga2+fWPxGB+s4fNrOzKG9sD1oGPhCn9kVuMwYpUqlosWkfWXA+K9G0De346hhAQbm5tMHrOe39ewK1uN0gOqWLAKPFIl2vo7+bslDU3CCL/+rFhnaX1XPR3tzKgPzx1/809ugt8jsooRctqMpmqkJygErkFIiTZkJGg/q5SHrphCAFh5ZQhWKByGph1JyTRpMJEh0Glpuo4vJKzkdrZq69aa/V5Qrks5oh69nH5GGBVEtjNh3WzG5dZA+zr+5Iz1UbdMIi3XsAVf0i0er66kWIchiQgawUODd4E4BBV2r0l6stcv+czgvDSDq053wfldFqzpw87zzXBz5D8nlpHxYPyEWae7r2K1TImcBV7BSX9DzyegdYNwPufBkrD0NengRX4yHA7l/dtL8gZtPFpQbow/WNyADlL05hTQk0oCMS5/OnNL5KtG58g1VqiekxeY6FdrzXJhqL32aqydGpM5WGyS2ew8Ieqdl8HaO6R4cZGRVwS6J1r/fE2gMkh1Tp/D35o7zO5HbhR2MS307NPY0+9CxupLj3+cvMUOMybBHFjMG8xY2K4+famwiF5ThUgQnC
 lpoDAw+4
 ULknMtk1MyvRPh05NBqXF3w8pNYkoC8QVCEvbZ2h6lfAB3t2LFjM/EQcOZtSrOMJ+WfpX4Gtx23ywrreBJ/swTIziMGAnqEQ+IozxwwyZFGupr2bbUbX9/pw2jeeb6f5pycqr26EUvyz4WD/ZUgAGMpH6nFgJNk1LsJUWrpEKgPCXo6le2JSM85YLHn4aonn0HJn1gY+t8lxMaKONUnEjMjRLVbZZdqQAKAjjLXRgYUsbwHZ+8fxRvJe/GuTNyQrclr2KJlUxmz9kDypMpz5oIYUE2pZOfAq0UgJmBCE/3sG2sGq2TjztuLHHjrN1RlbThqD9td2/djn3L6Z+5yzybL7Z2iJihbqVT3B2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jordan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 344db0fba38920be64a429c64a8ca0531572896c]

url:    https://github.com/intel-lab-lkp/linux/commits/Jordan-Niethe/mm-migrate_device-Introduce-migrate_pfn_from_page-helper/20260130-191416
base:   344db0fba38920be64a429c64a8ca0531572896c
patch link:    https://lore.kernel.org/r/20260130111050.53670-14-jniethe%40nvidia.com
patch subject: [PATCH v5 13/13] mm: Remove device private pages from the physical address space
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20260201/202602012037.jpAjBFBa-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260201/202602012037.jpAjBFBa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602012037.jpAjBFBa-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_migrate.c:1071:7: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
    1071 |                 if (IS_ERR(r))
         |                     ^~~~~~~~~
   drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_migrate.c:1075:6: note: uninitialized use occurs here
    1075 |         if (ret) {
         |             ^~~
   drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_migrate.c:1071:3: note: remove the 'if' if its condition is always true
    1071 |                 if (IS_ERR(r))
         |                 ^~~~~~~~~~~~~~
    1072 |                         ret = PTR_ERR(r);
   drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_migrate.c:1035:9: note: initialize the variable 'ret' to silence this warning
    1035 |         int ret;
         |                ^
         |                 = 0
   1 warning generated.


vim +1071 drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_migrate.c

  1028	
  1029	int kgd2kfd_init_zone_device(struct amdgpu_device *adev)
  1030	{
  1031		struct amdgpu_kfd_dev *kfddev = &adev->kfd;
  1032		struct dev_pagemap *pgmap;
  1033		unsigned long size;
  1034		void *r;
  1035		int ret;
  1036	
  1037		/* Page migration works on gfx9 or newer */
  1038		if (amdgpu_ip_version(adev, GC_HWIP, 0) < IP_VERSION(9, 0, 1))
  1039			return -EINVAL;
  1040	
  1041		if (adev->apu_prefer_gtt)
  1042			return 0;
  1043	
  1044		pgmap = &kfddev->pgmap;
  1045		memset(pgmap, 0, sizeof(*pgmap));
  1046	
  1047		/* TODO: register all vram to HMM for now.
  1048		 * should remove reserved size
  1049		 */
  1050		size = ALIGN(adev->gmc.real_vram_size, 2ULL << 20);
  1051		if (adev->gmc.xgmi.connected_to_cpu) {
  1052			pgmap->range.start = adev->gmc.aper_base;
  1053			pgmap->range.end = adev->gmc.aper_base + adev->gmc.aper_size - 1;
  1054			pgmap->type = MEMORY_DEVICE_COHERENT;
  1055		} else {
  1056			pgmap->nr_pages = size / PAGE_SIZE;
  1057			pgmap->type = MEMORY_DEVICE_PRIVATE;
  1058		}
  1059	
  1060		pgmap->nr_range = 1;
  1061		pgmap->ops = &svm_migrate_pgmap_ops;
  1062		pgmap->owner = SVM_ADEV_PGMAP_OWNER(adev);
  1063		pgmap->flags = 0;
  1064		/* Device manager releases device-specific resources, memory region and
  1065		 * pgmap when driver disconnects from device.
  1066		 */
  1067		if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
  1068			ret = devm_memremap_device_private_pagemap(adev->dev, pgmap);
  1069		} else {
  1070			r = devm_memremap_pages(adev->dev, pgmap);
> 1071			if (IS_ERR(r))

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

