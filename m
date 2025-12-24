Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46833E7544B
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 10:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7B86B0005; Wed, 24 Dec 2025 05:22:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165AB6B0088; Wed, 24 Dec 2025 05:22:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071476B008A; Wed, 24 Dec 2025 05:22:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E776B6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:22:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CDB81389B6
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:22:02 +0000 (UTC)
X-FDA: 84253974084.27.266D5E5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 80787140007
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:21:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gt+7oyLH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766571720; a=rsa-sha256;
	cv=none;
	b=4St04hwQ+ARGzYUHRLeqPNh/6aOJxNXQkV0V+1Uk4lj/3a5vJ+zI6KkTJ3G+67kCokf0lq
	imK85mziICaQ1WC3PBaFJq6mAUTqHk0jpPS2zMl3na+BO89mwFLJ2WMmY+65FNxg+htJ6t
	LB8tJ0W5vjxC1uBw1s7BMFr9QJLSXl0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gt+7oyLH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766571720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=mydm9aDCCBXzQGPPvLBwG6ycJG7DXcMhqs1UrS6Ieyk=;
	b=xVaR51cJ/Y6yzS7Rz5x4UkmvkS4YiciecrXOklRP38efz86D0JgHB6oBtcaoOfKKIiM6Jl
	nMcyzBOdh0BJMlSw6t8Ol8j0Co8Lxix/EEmyYbeWVMY1ifZbkQw2UARdMmMf2SSTVrE0KY
	RUnwLZ5VK473hGokL2W9O/iaR9UuxY0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766571719; x=1798107719;
  h=date:from:to:cc:subject:message-id;
  bh=GUmPP+i4gbDuwKV6OVd/GwRcsoCn1Dc/Qzaoh4/Llhg=;
  b=gt+7oyLHwMztnTprZ3AwIO4d/L/tR/NMC41dUjrReQqUKRvfsQAbOe/B
   DKpwRUWNN8y5cG7ViTJStXaIDeIzDzGR3e6x1eUI1cnOkDB5e3CpUPxHE
   nLFX8SLTK8Z04I1IaLFqjSN2O6LLZRMNEMbb4oVLhCJs5KZzKTwb6FmVF
   oh5m8A9eUgg+sSXZN66wgf7wAAusj/eTuHDLRgF3dvJj1cuS2agMZT6Ed
   Cdbj7TpIjo2S3dXTHT/MO0fJ4St3id+c/InC5IHncGyVe1hb647aEkMaF
   HXBSeUHmG7sbOH838oNLcgBCt8a+/ZCj/6TLkSCTNNBk7n/PzwIwoluvE
   g==;
X-CSE-ConnectionGUID: zkekVc1jQZuo5MO7Yr22og==
X-CSE-MsgGUID: dbredXKqRpqcaFXNXNzqLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11651"; a="79773871"
X-IronPort-AV: E=Sophos;i="6.21,173,1763452800"; 
   d="scan'208";a="79773871"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2025 02:21:57 -0800
X-CSE-ConnectionGUID: vuUvwK19TuS2O50AXNh9EA==
X-CSE-MsgGUID: FMG680irQxuxG8hLe1qelg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,173,1763452800"; 
   d="scan'208";a="223478064"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 24 Dec 2025 02:21:56 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vYM09-000000002w1-3MiG;
	Wed, 24 Dec 2025 10:21:53 +0000
Date: Wed, 24 Dec 2025 18:21:50 +0800
From: kernel test robot <lkp@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Finn Thain <fthain@linux-m68k.org>
Subject: [akpm-mm:mm-nonmm-unstable 68/96] arm-linux-gnueabi-ld:
 error: zImage file size is incorrect
Message-ID: <202512241835.avmTEP6X-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 80787140007
X-Rspamd-Server: rspam03
X-Stat-Signature: 6dtxub9tx7m1bxk9eya1h6ef4chhc171
X-Rspam-User: 
X-HE-Tag: 1766571719-306834
X-HE-Meta: U2FsdGVkX1+XUcAk6g1XFeRjhd0QotmYOQhX0jpUTyA6KxxPwGkT9GamC7HDYs1vSpH5ndQ+xVWP+lbDsl5XGGcJI+z9RGyAkk0WUpEv9WjryJ7cN+DnTxJ46JM0rpyPPLJFTeNMbstbXBcv82eR1SLvRIzAj574dxKGZmAt6R53WIVDsBIDzl3jMrK4ZQMcF4JznUXBAhlo1SJ+lrmzl83LZjxBG0rGeXrhCsFUlQcIGt+HywhI+Uwwf40q7Dnlg5dyahOgjJB/QNgRGViKsMyXT7hvyYdnVJlKwJuATCkpd8Knz3VAj5N2GLmfpOFTjZxw3ReIAEVh/TZoiuCv8WWE+f5tbr0WeEv1VPtiqxbHxykFh53g375d/o1d1P49Kz1yfWdN2k99IyT4kxPloSci7JfQp0XMy380Kh47fnl0SbCozNEh5CeqQD6sfxUOk8yv0YqYtr2DWcZ3+DuJS02Wb9o3j7p5w0ihqlxk4+U5atJiI8xx3hOKXTsYHo2RSBjlUJ1k/YUP8J+zGQtCjGSKqr5fMYyPFTXJ43TTIPF4VgEGWZXqMYukOlMkIBUmLgGtHGVL7oPK3qAkqHbapQsVSwQkVK3ku/g+7D/J4YUaBaWgd6ktL6liwo2uXGoo9yCRrP/9UoBxx84RJAEVmCMwgfhnMe152Mlm3DjuNgY2GUPjglDD4HaUJuiZR8oi/vwjmfEKIufEaJT+aSUsGy6i0SQhKBsVIMjIOeZJTThnSMQWuAGSLYzP2ElB5DVF6zJpUHDr0hO4XIguNETmIeGW/XkosLPnqzOF3aV4EkKhGqiW1VsisRwmx1zc6w7ZEtZVMPqDJPlMduifU4uws/1RJ6vF/bSr7+/lHtG7h5XIeJ7syZQJ30vXqsCfaiAUhZF8g+JsHEC7xWuRleBcBSidJQZ0xMURaQelEvq8w0p4Ys42zFpGgREKlAWrb5JwiWUCpGgcS/IIyUYEbMs
 zC11NxLM
 Aeym2Yp0I10AlrcWgH8L2y3X6gU45ZDmQ8K7NgNymAPTKDWamPMGq3y7xgSJruRh1IxorcvjvCBsNXUEcwUvXkbpHWTB8mzfvSK0yarQzEC232tpB6hKMesNaabp0h8v9XzukQ7t1n+aBS+C+2A8IFRk3WFlgdQwgTjAMSXr7M4Wx/6p1ckOUvlcXFDBv4Tq/6CifhCvmxKSBYiq8ynez3w9nAEX+Z5GUvHeEYTr441Jkw2mOrl7fGvumfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   c40f0b9f72a08d208c7793090ae98faaf6a58719
commit: 613bf373e660523dbb3f2567fceb6cbd8bc2a469 [68/96] atomic: add alignment check to instrumented atomic operations
config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20251224/202512241835.avmTEP6X-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251224/202512241835.avmTEP6X-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512241835.avmTEP6X-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

>> arm-linux-gnueabi-ld: warning: orphan section `.data..once' from `drivers/firmware/efi/libstub/efi-stub.stub.o' being placed in section `.data..once'
>> arm-linux-gnueabi-ld: error: zImage file size is incorrect
   arm-linux-gnueabi-ld: drivers/firmware/efi/libstub/efi-stub.stub.o: in function `efi_stub_common':
>> efi-stub.c:(.text.efi_stub_common+0x190): undefined reference to `warn_slowpath_fmt'
   arm-linux-gnueabi-ld: arch/arm/boot/compressed/vmlinux: hidden symbol `warn_slowpath_fmt' isn't defined
   arm-linux-gnueabi-ld: final link failed: bad value

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

