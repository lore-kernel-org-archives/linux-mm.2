Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7EEAD5E146
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 13:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0C856B0005; Tue, 16 Dec 2025 08:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA4D6B0089; Tue, 16 Dec 2025 08:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C66A6B008A; Tue, 16 Dec 2025 08:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88E7C6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:09:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53523BA653
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:09:24 +0000 (UTC)
X-FDA: 84225365448.16.E014070
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1CC1CC000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:09:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="bcvpdA/F";
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765890562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/BZlwuFU3rmAqfKhIC1DmOqf27favnSgigEiLRvsG0=;
	b=kDCL+5q2ZGlL8hrfY/ea3/k97mVrxo6p9c9sEF0voK+RfsRDL+CWXjCB2jeIb4CvxtcMEk
	42wf7Ta+rZ91LiiCuRlgUE7oL9nrLwWm9iMM/KCtMirrW3ZB25QJw/Eb1+aUH5SndeHUoS
	IiAtaCQdbUIZ9dbu22jAwqaoKimbaTY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="bcvpdA/F";
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765890562; a=rsa-sha256;
	cv=none;
	b=lyt36Q0cUE/uAN7s3mjkqXC/UKuFvO0ONqct9/tM4Dm15NtotK+TyvwGC0a5zY0wn745J4
	vOtsDBtOeG93ErohqNPF72T2TApYU6X4aSiqE2lbhENYumqri+2WVr8IRdLwtFWH+muZpj
	A0paZPyKkTiB06lMayY6/LVA3OvtdUs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765890562; x=1797426562;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Xka8vrzXmYsDRtLKcs4D29NutCopasc9PuNbIBmzGKE=;
  b=bcvpdA/FFomGfQtmQNkEs6oHRe+BXyuyA7q9zvyuH/h5g6ygedKksIJH
   62mQP1BiOjNUdnQyI7eIRD0+/+ggTy90dKvGaZX+1hKtB+D8jkPh/1j2V
   5lj4UBtnqqz4ddaTVpJakxjBynKdWg7Ke/cuqIipw0FyZU6LBjAbXswaT
   t/43XaovUhuE1bAZRq5CXmaywZ+7JCAVQ8ALkYqynQHMhW8ebshfU0Vpf
   aEX5Gofjspe1OYralsqviq02y3xAjZnkHFTCrOB9XC6Za8ujEn3n3nm+E
   H6BKvzsiGEMM/Wn59NEW3MTFYdcGOXRBhQ1srJKf01L5Np7bxkBX2JAQN
   Q==;
X-CSE-ConnectionGUID: s6Dv9X8QTmG363/hweJOuQ==
X-CSE-MsgGUID: FHXhIiTiTWWquQ8MWNYzfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="79263706"
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="79263706"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 05:09:20 -0800
X-CSE-ConnectionGUID: 15HNIl5oQ0q6wU2ch0cjvQ==
X-CSE-MsgGUID: qZQU74X1T1S8vd3lHo0D9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="197636027"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa007.fm.intel.com with ESMTP; 16 Dec 2025 05:09:16 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVUni-00000000364-0DGy;
	Tue, 16 Dec 2025 13:09:14 +0000
Date: Tue, 16 Dec 2025 14:08:14 +0100
From: kernel test robot <lkp@intel.com>
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, ziy@nvidia.com,
	npache@redhat.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
Message-ID: <202512161406.RfF1dIYB-lkp@intel.com>
References: <20251215090419.174418-4-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215090419.174418-4-yanglincheng@kylinos.cn>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1CC1CC000A
X-Stat-Signature: aissaozt3196e1qqxknqy3gppwhzcq5x
X-Rspam-User: 
X-HE-Tag: 1765890560-882223
X-HE-Meta: U2FsdGVkX18xrpmryj+HdUJOSPdnMy3Wtrc3mzzyYyuPBuulqGtY8x/y9mjNTwMsWT3/BQFAITMCg62SRq7zXLQICbWgVdr51EVMeDxPoKoEiuauAql6K0N+0uQ/F+rmH6BvG9fyCZkoz2r0xQObEo5NVHUDDnR0J2hZAJOowgmJBy1Nzm/WO74GmFkCay7gyqwAamXFEbZhwj8JGx808i+CA3NYSR0JSh5G6Tt4qfCg7hqg2dc8wAKB3DWwrz6dJsqq6QYZ8UweUqd1WKGxvKj1N8imHVypoQIa16jABXHpVkY65QJM+PdYKonXMGF8wI9eeKfIo/JMk9Tf1KYiQ2v9VRNT0oQQI7ajffpMONQsuAr/ersjku5q6MXxbGfsCwR2LK6oaw8vLkg4DC5EnRBOyTPMo4e/8rm4/pMODxHu7IvR63e06duJ1/rc+/AKocpWuVtnIVnxpW6D8T90iAiic3/yRer+Aeq0HyTM8YyuQp5tqVjYekcow1ktXUVphbHsppng7SDuQe7UvFg+DNyE4Rbn/ZLMoXTAh1EfPob6A3j87BJLL1GaH0qwLmQNsBVBgRb4/qvRdg/cQ2xreiMVjC2wn1oIRAp9P6POijkJ09axkwFGFtwBGYV01IhlwWPeMPJuxNx81n2xQam9aDQUyest616E/yiDzxIXoDQSExTa6Ob1n3r7A+WdHX4YzmjhSnuolO/v1yFalOV37kCu+on+2UuPgIVDtUwfk1um8nUdor0IxyM97B57L+BHVCfJoMg9Uw/9SNFrcA+nAa61avxS1eReYbMNKDSZylFsnYWOLoHWxOaPgRGQvim54w9XsN3Hh0zZ4iBonGntEvQC3PyePMR0TsI7z90dyaawsoUs9nbSf02nGeWlxRRR/3jzlM53JjTp1N7SyFP7fRUUg5KSiIXS02p+puAehfHMWwffLmqDL/X82SYIoezdzxDCMmlCzwrGoaXe1j5
 vLgsRLFp
 kvq6QSI6Xz83jLgTQaUs/OM988OrT/jbqwd7Re196NsutP1ZUwWre8wNsB197Td8IJEdJ+f998H+/cyDs+frUZkxXJ4gsPlCfUFaltWZXp4L+6XURn6wxFWocEMzSZyLznv2RM7I8eRziLjwHIpfYetb6jiUT9UP9NFTSlrfLvHieW2E+dzzt3Cy0OhrQExsiu6eBn1DmDhEehpKFfGYV7SQKWFm9hLC02B7z/tDRppxrvxZYPlKT4Abu4gemB9dwQRFhOwWuPr/aH0jGdlOBqaqKPgvItsaN7E/PD9TunsRIClD8GrZF1JCa63hg+cozWEzs8oWch8bqUaoNu60aNEWqemW7OiQQ5wGc+frm+rDWdHN4MmSmBdr7h/TtdjdO5wnCbrmrb6o0H7Qad8RnfxptHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vernon,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.19-rc1 next-20251216]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vernon-Yang/mm-khugepaged-add-trace_mm_khugepaged_scan-event/20251215-171046
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251215090419.174418-4-yanglincheng%40kylinos.cn
patch subject: [PATCH 3/4] mm: khugepaged: move mm to list tail when MADV_COLD/MADV_FREE
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251216/202512161406.RfF1dIYB-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512161406.RfF1dIYB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512161406.RfF1dIYB-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/madvise.c:609:2: error: call to undeclared function 'khugepaged_move_tail'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     609 |         khugepaged_move_tail(vma->vm_mm);
         |         ^
   mm/madvise.c:837:2: error: call to undeclared function 'khugepaged_move_tail'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     837 |         khugepaged_move_tail(mm);
         |         ^
   2 errors generated.


vim +/khugepaged_move_tail +609 mm/madvise.c

   595	
   596	static long madvise_cold(struct madvise_behavior *madv_behavior)
   597	{
   598		struct vm_area_struct *vma = madv_behavior->vma;
   599		struct mmu_gather tlb;
   600	
   601		if (!can_madv_lru_vma(vma))
   602			return -EINVAL;
   603	
   604		lru_add_drain();
   605		tlb_gather_mmu(&tlb, madv_behavior->mm);
   606		madvise_cold_page_range(&tlb, madv_behavior);
   607		tlb_finish_mmu(&tlb);
   608	
 > 609		khugepaged_move_tail(vma->vm_mm);
   610	
   611		return 0;
   612	}
   613	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

