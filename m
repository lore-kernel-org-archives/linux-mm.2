Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B598FCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 19:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1BB8E0002; Tue,  2 Sep 2025 15:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199A28E0001; Tue,  2 Sep 2025 15:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D67B8E0002; Tue,  2 Sep 2025 15:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0C2D8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:46:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97BBD119B14
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:46:47 +0000 (UTC)
X-FDA: 83845342854.02.35E0E9D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf15.hostedemail.com (Postfix) with ESMTP id E8A53A0011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:46:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lNm9jhsv;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756842405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AQ5yJClbuKfV93WPS80foT//e5+KSFiPXEjeJa7IOU=;
	b=G40sg7b13LYO1INGgWImtRuN0+O6P7km0Ub+20ot/57K0B3BLJ+Y86fo1tnVGsXVEqsbJz
	UCADenhiAc0B4Fv5hTNG3Nsold1r+hc5pgvitkSOITKUQuE5O8kIlyKbTJPbU/vETnacAh
	KnXDJDzjCei1erdHBQbQHQ0e7bLYOks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756842405; a=rsa-sha256;
	cv=none;
	b=5vQqFbbNW5Dx4s69BqzGRTnB67F+oEKESSZ8dsKWc9756RzPUsk3Z/qH4ms7CTUvGXEiDA
	DtiGTqXh0mx95jDo6HPfmMqP5FSO6GX/nASocABPJnHpzBy70FbKggcbbXVlQBp6aWtPDQ
	KEvXg1LzOxhUFcqWTtKeKkZEhgxCLuw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lNm9jhsv;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756842405; x=1788378405;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zRy0DAZFgMiP7GYmxbyjuD/eGzMInt5FBbU+Nye7QrI=;
  b=lNm9jhsv8NiH9at40q/3ReJoZxl8vwr/tsl53mnXxLGfe21qqD5iri7v
   dcnOOuqi3IklwFRaAwqBYSnNysX7kIsmVtak3Rx6Tj2aKKwq1ovaJ53Uz
   e0YhyHmnJabpkjzIZ61H1reYs6zzOK8L1K9bp/O5z+1ZPulRfoOuBhhfS
   MRZWtzzKBDIuKvqWG9plKjKNWHJNAmxme6HqCZ2dRah3UPG4UUWeBp0lE
   GEpPU5TxAxtg0pVci2R+eAbPeHqK/tjGtlg433Pj9UY38bVt8SB4C8MB5
   AWuulzjx3vq1/4LO+BmeNe42EF0LQrwQO8uokZkZdCfCnCTZi5rlPEvTI
   g==;
X-CSE-ConnectionGUID: B9IoAvpjTJ230hde9pWWMA==
X-CSE-MsgGUID: 1hBd6cHhTDqrKNLqCO9frQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62966117"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62966117"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 12:46:43 -0700
X-CSE-ConnectionGUID: x2st/9FlRMSZvdRndu6cOw==
X-CSE-MsgGUID: uZoPtHYqQOGE70FRtVBomA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="170645854"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 02 Sep 2025 12:46:39 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utWxf-0002yb-2t;
	Tue, 02 Sep 2025 19:46:35 +0000
Date: Wed, 3 Sep 2025 03:46:23 +0800
From: kernel test robot <lkp@intel.com>
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, x86@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	david@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
	peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
	tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
	ankur.a.arora@oracle.com
Subject: Re: [PATCH v6 13/15] mm: memory: support clearing page ranges
Message-ID: <202509030344.SZCI0AIf-lkp@intel.com>
References: <20250902080816.3715913-14-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902080816.3715913-14-ankur.a.arora@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E8A53A0011
X-Stat-Signature: atcjunpifhyhi9nh5rr1rahbqm8wdgry
X-HE-Tag: 1756842404-822384
X-HE-Meta: U2FsdGVkX19YrRAg0pMiCiuEpDQYDIR1Yjfcybhpb+UjI2FYBq38YSpAnwKIi5YGBmmzmiHbtJZrAyidQdfhRAao1IlGj2zqsCqRLkC0mwMrQmWWrRUTgq1/KsPhoHKCoMaGoUtyZcQ9QjYMYoELLv6w4YZYB2iZ+GtkajXGzdIEUVvCyeO3VL5H+Zn/4einadjHrNjbh1+n4pdP1Xc8jjoesmnUQxAymgHKfDOD7wfI1SxtRnoNCDieEkLAyVcPqdXA++oqsMCdUye1C5XU1UIdY6xcKvlRA/7MUI1GgJ9Kt05lhH/u7g2AdAkC2KO8/fDrg317ewNuU3LMgPC9tB5vj7TwAkG9rN44As5kFZdn8AsvgkFzZ34P3YbPA63kzveTOcyaQdugcHyDnK4I/p80moiFm6iB5wGg7CEnLvsPaHKRCfVmKyVav3RmIG9gRDHyEcJn+ohMy6VvGZDN9EIvf+qcyQ4ciqOvkEOItN+qiG3E+yoYwh7DGO2lskPkLH2oLSAbK8hro885tiNQH6FVTthRMe457pnabnaHTZtt4tEWv7w5DKWRtbBS3HLRp1tRmC7501uEKRa9pIHPYSst3MEsOtcZ44adyk12/n3X3bT/ssE5wJjkDmL2CCVBsmrQcXA/DDiT6NzSaxjH4EzWOTJ+tom/ANL+NzCgSxx1tU6er4K8isMzL9WvNMLUlgwtFxOSV+JAsKqHPwx2g1CTcqFGm4Qy52cLWmBkLYQ5xnblg5YS9u3u6ga9HIsSIjGFZZSqkIHFWAcxUj2G+4QgGlGzLoGdA+MMQ7rUBq5azJo3Snx89nUx09glUBXMovKUsoexilXM0BVNMJQZ5WSVF9HXMTrj9jJJP4OYuXOcSARDxy68V+YtrzJbuJpn02tBaxKYrBAvI042UlQ3C2f2r/YERZwDmj+Q3k992I2sVAhHOyMEtkzzy4hn5VyorES//fS01EfGyRq3oue
 ik7J/Ybw
 shnwz6TVoynESpyjkaOEUGIpJ+tWMGIbW8x80wTZAdS4c5iXbwyTAmVLSc3d7ImLnxPTUiOoXm8GSgEBv0qpzAlT0+kObA9kF/Ukb+zrgU9JGIBIUF2c9c6Dw1PkyEejPykJUdzoy21bhOq0FgkeiFDfv5vUbaArEwgmD+K5H8aEz6PsbyAHCrbi4Ce4nxx9xMP5H2/gqir19YGulrfDTEQYH4sbMvOUe9vYmLq1eyzefy3FfbCg3Qul0ILAQKH1KtFD4ovP4ZUUISoyfUoh2/m3rVzIQKqFB+hQ6dcFcBGOnlJ36rPqUTgE1whKapTmcbtlfoSuvScTVCEj5zZgCccYtqOySddhcNhkUVGrfGhOBbcLTplepQpYPJc6Sq0DvjaVc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ankur,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Ankur-Arora/perf-bench-mem-Remove-repetition-around-time-measurement/20250902-161417
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250902080816.3715913-14-ankur.a.arora%40oracle.com
patch subject: [PATCH v6 13/15] mm: memory: support clearing page ranges
config: i386-randconfig-014-20250903 (https://download.01.org/0day-ci/archive/20250903/202509030344.SZCI0AIf-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250903/202509030344.SZCI0AIf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509030344.SZCI0AIf-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/memory.c: In function 'clear_contig_highpages':
   mm/memory.c:7165:38: error: implicit declaration of function 'nth_page'; did you mean 'pte_page'? [-Werror=implicit-function-declaration]
    7165 |                 clear_user_highpages(nth_page(page, i),
         |                                      ^~~~~~~~
         |                                      pte_page
>> mm/memory.c:7165:38: warning: passing argument 1 of 'clear_user_highpages' makes pointer from integer without a cast [-Wint-conversion]
    7165 |                 clear_user_highpages(nth_page(page, i),
         |                                      ^~~~~~~~~~~~~~~~~
         |                                      |
         |                                      int
   In file included from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/writeback.h:13,
                    from include/linux/memcontrol.h:23,
                    from include/linux/swap.h:9,
                    from include/linux/mm_inline.h:8,
                    from mm/memory.c:44:
   include/linux/highmem.h:211:54: note: expected 'struct page *' but argument is of type 'int'
     211 | static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
         |                                         ~~~~~~~~~~~~~^~~~
   cc1: some warnings being treated as errors


vim +/clear_user_highpages +7165 mm/memory.c

  7151	
  7152	/*
  7153	 * Clear contiguous pages chunking them up when running under
  7154	 * non-preemptible models.
  7155	 */
  7156	static void clear_contig_highpages(struct page *page, unsigned long addr,
  7157					   unsigned int npages)
  7158	{
  7159		unsigned int i, count, unit;
  7160	
  7161		unit = preempt_model_preemptible() ? npages : PAGE_CONTIG_NR;
  7162	
  7163		for (i = 0; i < npages; ) {
  7164			count = min(unit, npages - i);
> 7165			clear_user_highpages(nth_page(page, i),
  7166					     addr + i * PAGE_SIZE, count);
  7167			i += count;
  7168			cond_resched();
  7169		}
  7170	}
  7171	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

