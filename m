Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F32E8D1CDC6
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 07:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC6E6B0005; Sun,  7 Dec 2025 02:05:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C046B0006; Sun,  7 Dec 2025 02:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3206B0008; Sun,  7 Dec 2025 02:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED8306B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 02:05:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B141C075B
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 07:05:08 +0000 (UTC)
X-FDA: 84191788296.25.BF39FC0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf14.hostedemail.com (Postfix) with ESMTP id E5D7C100008
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 07:05:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cfHQ34yh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765091106; a=rsa-sha256;
	cv=none;
	b=pfO95O/K8pWQxcIw/snW0US27BhQCmOAOxNoiB7z4cwlRF0Uij8Bng/KyYHbMrcgn1rTxr
	Jn6SkQLsCoExvifqQGfS8ADUCyvshwD1hO2S0OkT18vg7OIpOIWjxOjmM1kE7uW1b5WRRF
	E5uvTNm/XF4z5NjBOTGDg5tnHIeOw44=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cfHQ34yh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765091106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jn05zc2zY2Pmhw27ta2G1jW8MetJ1Eq+iQVuiGqRRxA=;
	b=eTAyr130PSUg2R8jv0XsiCXpzeva1Kdj9ZBo7lpQjobDgf+N1L2dumSmlCeYl+skAN6Tka
	cCSvj6lmFgDYHpgQ2T0sTiB3eeRxDpQOOlH0uLARsQ+P78/EBKdr0g6hj9KEbrR4Ceifnc
	s/4Ll43i5xnuZgjX0YYEgXPlJaeP8so=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765091106; x=1796627106;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=PRjTucAU3legu1LMDX7VcmKR1w62GOp8/rZcCCwymwk=;
  b=cfHQ34yh+kuVBDN4qn9ofR1km8slQk5C4+kWCsZ4LUVtTz8chElofrLs
   rBXfQYc+yyD7wBejko0JT/DWGn0zj0cA7DUEOTT5JfpWeN6uQA61qq5Lf
   TFxE/jd0RIeNpPRnw5/thlt0QeYJRvvy9ygtCnDLeGz0Benr4g7oXgybS
   0+pTvAe9e2CsZM74ysYBGG32O4Y1a4wfHbixUuXiutXmkneum1l4/NZS5
   wX3A1cmzyzk5rLR9ng9XJp3IBloN5HxHkMtPVo9mnsHMX54gjIg+/5iOk
   e/z+KIgyswp/5BwuWaN46DvMfJo0sArGoj5i0Mjsg2J4K7s+0+x8aAvTt
   A==;
X-CSE-ConnectionGUID: gQlUN8igQyKtbP/kzDBfBg==
X-CSE-MsgGUID: aV8+UNfQTDSeePscvplv+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11634"; a="67105482"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="67105482"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 23:05:04 -0800
X-CSE-ConnectionGUID: 7W0Cza6/S/iorCviO8YbMQ==
X-CSE-MsgGUID: sEYMKIfxSh6iVzKHBkcAYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="219009840"
Received: from igk-lkp-server01.igk.intel.com (HELO 314ca7b3cca8) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 06 Dec 2025 23:05:03 -0800
Received: from kbuild by 314ca7b3cca8 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vS8pJ-000000001An-18gk;
	Sun, 07 Dec 2025 07:05:01 +0000
Date: Sun, 7 Dec 2025 08:04:21 +0100
From: kernel test robot <lkp@intel.com>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 52/72] mm/kasan/common.c:601:14: error: use of
 undeclared identifier 'KASAN_VMALLOC_KEEP_TAG'
Message-ID: <202512070851.mejaH1Ql-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: E5D7C100008
X-Rspamd-Server: rspam10
X-Stat-Signature: 87di1b445ge8ecmtzeh6fjj1by63ip6f
X-HE-Tag: 1765091105-69637
X-HE-Meta: U2FsdGVkX1+JywSbc8H3KKlHmKdTMaVayGNbJWDSr61pQuoIT4/BjiduN/H6feskD5LaNxPCx7hKNMDDb61IYrcG0ANazWCI7MqqGeLELYEHgnI5BAIaPiTllJTiMKAbd5liiqwShqB9Hul4nOk7AqSHDlX7IJtds3i+Zn+0COh3LjgKd0yiJYKEZcMRE5gST4u0h03gA5BD4EeYjoWx/8i9zDxBHuVlEUc4qvUCvUik6/bmD9vLWwEwIVOIzZV7n3K2FJ0ZProoXsnI47mxlWBFTlw7rE/CtK9KYC6X9DXMB6tz1x1RTVbVXcAEoecSGprKpdltzH1uoGdSansXrmUxFna6xouRhcYYXvZQy0KrlAjz8/DWJHUnzNXevaIYYYwwo6hP8TuEQ+2FsMeo+oOBi2QpA/Mb1hZkGPKa2EsDzrqweyvZWH0RIhWxHy+XUU+CeRc8tyJguie3FZP5iFanWPJ34hgoDQZMWP26DQFNKLPmcyOG4pO37dKoEz77UX6xqmrjeu6SsqtVte1CxlNHWVVIYP8Ts4jHJrXDuhjAqBJpk48ubQrqZz4t6ES1BznWUsCvzFgV7Eg2aaBellwQ/rUP+8WR6SgNYSshHCbMIYsO4SEtfncnmgniI225GeYlzCj3GBsbm/BOS5k57CmCQwHOB6s//xVDTIwwvtERYCvelfhkHb6gSfqtEPxiEZ/4aps0UTQvMamkz36/1hz3QCPuZ95ZIY4D6gxXGdt7x7ldb98CuiDNjGfL4GycoxOrNQ/ANwx6Q6aahPdrUDnmR/HWkwZbL8hu5Cv/zJSw6+AlOYawuczD1l/Rh89yme7xLIjtzwiioSHBqdnAasitl5V080MwEIC/mJT59pjOdgMnV69L3K76HsYIITv8EUX3Fi5uK7iswjjcN8d1u3Jr1qRUn9ZLW/J8xjNwDvsUDZwUvdr0ItE5QSD9PQj2PJ4ewMBMLr76A+CdFDd
 8ojqNErL
 CcwbYRwbzTstY3TJvyzKFy1ZFlVn+6HPoqDOIscjVUYEz2c9aWoCja9KFKpA3VOIyn2QNsxIvaNgN6o7PNuuEZAXVFFXGOQlwZTsdUWhdRBQ5Gbk9nJnetcPIL7ftvrPgXfdFg6SChrXz4cRH0kTe6jf4DhBwmZpuGoMDIwTInoA4FnCgTKIczTZW3D22CN2GdunN+4ztKM7NIxqy/Sux5QanhTDAQSMEIZeiAHWbYoBXKBYk5A8g6DR20aaqnmO2lQPu9NQF6PhSM+E5vkkSxNzaije0+qGv4lSC/wpZMWcXyjB8g7rLr6in5aPIQzUo6FZAoaLA3LlhKaDEJAeloj+5tfB8GpKOvWKNmloxRN6eCAbLBk4TAhxFBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   ecc46e02e0abe025a6e840cba2d647f23fd1d721
commit: 6b83afdcfa935db4f836906ca7f0fcafdca8d229 [52/72] kasan: unpoison vms[area] addresses with a common tag
config: arm64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20251207/202512070851.mejaH1Ql-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 2222cfe7e11ff3e0434bc696856629199ef0da7c)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251207/202512070851.mejaH1Ql-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512070851.mejaH1Ql-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/kasan/common.c:601:14: error: use of undeclared identifier 'KASAN_VMALLOC_KEEP_TAG'
     601 |         if (flags & KASAN_VMALLOC_KEEP_TAG) {
         |                     ^~~~~~~~~~~~~~~~~~~~~~
   mm/kasan/common.c:615:49: error: use of undeclared identifier 'KASAN_VMALLOC_KEEP_TAG'
     615 |                         __kasan_unpoison_vmalloc(addr, size, flags | KASAN_VMALLOC_KEEP_TAG);
         |                                                                      ^~~~~~~~~~~~~~~~~~~~~~
   2 errors generated.


vim +/KASAN_VMALLOC_KEEP_TAG +601 mm/kasan/common.c

   586	
   587	#ifdef CONFIG_KASAN_VMALLOC
   588	void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
   589					 kasan_vmalloc_flags_t flags)
   590	{
   591		unsigned long size;
   592		void *addr;
   593		int area;
   594		u8 tag;
   595	
   596		/*
   597		 * If KASAN_VMALLOC_KEEP_TAG was set at this point, all vms[] pointers
   598		 * would be unpoisoned with the KASAN_TAG_KERNEL which would disable
   599		 * KASAN checks down the line.
   600		 */
 > 601		if (flags & KASAN_VMALLOC_KEEP_TAG) {

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

