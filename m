Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 963C6CD8CA8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 10:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00856B0005; Sat, 13 Jun 2026 06:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB12C6B008A; Sat, 13 Jun 2026 06:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6D06B008C; Sat, 13 Jun 2026 06:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C093D6B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 06:46:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65B00A0390
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:46:44 +0000 (UTC)
X-FDA: 84874561128.22.966C391
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id 01E5D80008
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 10:46:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i7t+YVmU;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781347602;
	b=1iMr/Cht+CLrH8aQmp/AmVnnQb88+HojZfD5nVSWoQozbv8Otp2ySUhKbqVviQEvbgNADo
	bYqDmMskI3FRAjfJPvVnPv1c/XONVIrk2MY+BMdDZ1pHCDYmFLjhe9EK+3VC1TXcX4RjRg
	wjYpPh8YXH5Tyzr3SITMN03ZhP5s6kw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i7t+YVmU;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781347602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Z8miH+F3csHt0WZhWh8sWEGKtulu+spuPpD7qyoJjqI=;
	b=asUQfUakeNO3tGclRFETKIAyrAc71ayjrbQBCjqp2WB2F/KV5/kHL1ADYyHxXHlQpcbzWn
	G0L1VrGx86pbEzoYciwa1hoRRqlVDAyD1AS6ZrIoQOUvjk15hfLncqVyg+VaW76WFwD/aY
	q/ZT/h4av2XocxZWGxJe9puLxEYNM0Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781347602; x=1812883602;
  h=date:from:to:cc:subject:message-id;
  bh=2QlJ0F3w4MT6Jz8HrKDZChpvFYahL7qjSK3TrMZFd5w=;
  b=i7t+YVmUVN0LB8pIDRt79mAnsssiFwvAd7z3xthpoI3WU+a8m+6bV1We
   aRMrwUgSkntZj6dgX2tVrtPhX/GbuWNqg1p69K2WlwOgcgJ2x3ZF0Gzho
   8/iolcfHAPmQCT+shlN+m5KvnHbfWE73j9nfUPXlbz1AZVqmEl6rtpCPC
   FYgdtavTvdJKglN3Z9Uj7tdBYQB6yLB4JrcfZ8lAr/aGoy4qXAXTxk8tV
   KjEGKv4Ap80IzBWJO3QQ6PJMw8i/A8wjePtSGcDeZSylfbWaEXqUynCcI
   vXYft9w061iX2cCMSu6XI7Q0FbgaMZRt1nsZEplQMAY96vf4uO2EE3Xlw
   g==;
X-CSE-ConnectionGUID: 2g9yG5YyQ4iuwzM88t8YAA==
X-CSE-MsgGUID: sYqyhARmTmKfDW58R66dVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11815"; a="93655862"
X-IronPort-AV: E=Sophos;i="6.24,202,1774335600"; 
   d="scan'208";a="93655862"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2026 03:46:41 -0700
X-CSE-ConnectionGUID: N0LEHaK5Q+GJU5Pv4iqC4A==
X-CSE-MsgGUID: /rEdlMAISz22d14P3eoN8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,202,1774335600"; 
   d="scan'208";a="251975860"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 13 Jun 2026 03:46:39 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wYLsp-00000000Prm-31Si;
	Sat, 13 Jun 2026 10:46:35 +0000
Date: Sat, 13 Jun 2026 18:46:34 +0800
From: kernel test robot <lkp@intel.com>
To: Cunlong Li <shenxiaogll@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Christoph Hellwig <hch@lst.de>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [linux-next:master 11626/13763]
 drivers/block/zram/zram_drv.c:2345:49: error: 'bio' undeclared
Message-ID: <202606131800.eF9ahCdY-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 01E5D80008
X-Stat-Signature: e58mhohop9gwfmirdzz7uqoiwqgxt635
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781347601-925544
X-HE-Meta: U2FsdGVkX19qQsuXBbOH0RoaLcfmi94AhDFOCXOCb8jzYOjit004qR+pR7TrX8XjeE3zDC7oJanGz8B+6jCVto8zdc9dha6ES3KAC4thK9bs27Lj7PkOPDTdb9zX0C5B8lFOxjuKAaWbabjNTtcfbAz+4pyX2p1VAJcuW9TP3TMB2V8mMekyi2je1LRd/pwUR/r5q6W9PzJDi59qzfSyiDYltVWpBrcj6i3yoOnDjK3guiMuOyQteoGnThq8xRJYp0K48uC4skws9aaNWmrewvQ3KioXiK51F+0IKWwolBM2cX8w33G3ptiBDNISXG4I0CMjV+1SoK31MLEBlBzWsZeMybodcyZI67GEbI25d9yt9AcMzlXAq8YmcW/E7HU+sp2bIJjl3zBG9142vwsgk827YFj30EHt/ERNrDU2VDEtHXHNXmzNVU5d69JS+0oJv6DOKM3JJ2PLVoY6vHv8n7L9KubgsbwJxfcYABZyXMZxUBXER82bpUcE2daWMFPSvad4NwTbDLzetG+adOea4k6Fm0prmZa42/1PzId380rU7RF/+JO0nPX9YnCWETpKlXk6IyySDJXZpIlUgf0MhmGwN9solfcVnCxvzgpvZsTJBMIRQaE5X3cmSa0dsLHLJ7XT04u5P8u6lfnK8byne12ibFQTG+PXNcQapwOiAJTFe10pw2SVQBmro9yEjCEKOQ8PwPA5J9vYQKvbSbYjJPKLYHWHS8hDZ8XDc9uzwGy4fJx0KRMvTHWScz6wsTjIkdS+IgofhQRJ154l/GDMZlEcMU3NjcJTy+h+tw+ApqB7EfvUy7923Tm+Zh6gdp+tc9rOkIjBHDZ61XIuWD0NAcL2cfCJKnQFVT3ZfPR7efi0kMorj1cBavRSb1tZFlFD9bGT5oustEfSMXx6dLW1Q8FSi6W3gLE5YtdxlK5WnL8dm4ujFzXCfSTTztEPvKz6ic8nKbLONFekgQ8aM3a
 R2bwnzKJ
 H3wpKZCMuHseeCUR9Hhr9chy2QWT4vAbqoLDTVlnueWFTbxTqqBPMhhOFCvkvUM0zejViLMUV+nTruTHG8qFB6GKSyhsbkCgq4zo9P8oM1ReIIgJwCvdUUsmeEuTfklBLVur+CNBwfDf3WyEGU54/XAm8oLZKCjY6nrZzloo1v/ly2sX9mEdiMNjNwRvY8jFyemhuVPUj3KnxW5Jftd3knm51F7dHquZ9TzSZchdrWvYK6/jEzsfdYTc2DwG+afRNmDdzZNeUzcpyvupf00yREzJzLlJ7zpc7+tZxcoprt4C1UXVomJMqP51YokwSFmabFpkD7bbPb5oXCKMpQWQBbayPl7vyXoiY62adzClBEPQ7NrP5Ep8Li7swZJlPY6R/SwlWGgV5rETJ+9cnAamlVknyiXAjC0XlFCulm8WQiEVziWK51c7Ij6m1Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Cunlong,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   c425609d6ac4012c8bbf01ec2e10e801b1923a7b
commit: d1aba985984781947ad67c1b44ac64bd498c8f27 [11626/13763] zram: drop unused bio parameter from write helpers
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260613/202606131800.eF9ahCdY-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260613/202606131800.eF9ahCdY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606131800.eF9ahCdY-lkp@intel.com/

Note: the linux-next/master HEAD c425609d6ac4012c8bbf01ec2e10e801b1923a7b builds fine.
      It may have been fixed somewhere.

All errors (new ones prefixed by >>):

   drivers/block/zram/zram_drv.c: In function 'zram_bvec_write_partial':
>> drivers/block/zram/zram_drv.c:2345:49: error: 'bio' undeclared (first use in this function)
    2345 |         ret = zram_read_page(zram, page, index, bio);
         |                                                 ^~~
   drivers/block/zram/zram_drv.c:2345:49: note: each undeclared identifier is reported only once for each function it appears in


vim +/bio +2345 drivers/block/zram/zram_drv.c

1f7319c7427503a drivers/block/zram/zram_drv.c   Minchan Kim       2017-05-03  2332  
a0b81ae7a4ff8a7 drivers/block/zram/zram_drv.c   Christoph Hellwig 2023-04-11  2333  /*
a0b81ae7a4ff8a7 drivers/block/zram/zram_drv.c   Christoph Hellwig 2023-04-11  2334   * This is a partial IO. Read the full page before writing the changes.
a0b81ae7a4ff8a7 drivers/block/zram/zram_drv.c   Christoph Hellwig 2023-04-11  2335   */
a0b81ae7a4ff8a7 drivers/block/zram/zram_drv.c   Christoph Hellwig 2023-04-11  2336  static int zram_bvec_write_partial(struct zram *zram, struct bio_vec *bvec,
d1aba9859847819 drivers/block/zram/zram_drv.c   Cunlong Li        2026-05-28  2337  				   u32 index, int offset)
1f7319c7427503a drivers/block/zram/zram_drv.c   Minchan Kim       2017-05-03  2338  {
a0b81ae7a4ff8a7 drivers/block/zram/zram_drv.c   Christoph Hellwig 2023-04-11  2339  	struct page *page = alloc_page(GFP_NOIO);
1f7319c7427503a drivers/block/zram/zram_drv.c   Minchan Kim       2017-05-03  2340  	int ret;
1f7319c7427503a drivers/block/zram/zram_drv.c   Minchan Kim       2017-05-03  2341  
1f7319c7427503a drivers/block/zram/zram_drv.c   Minchan Kim       2017-05-03  2342  	if (!page)
1f7319c7427503a drivers/block/zram/zram_drv.c   Minchan Kim       2017-05-03  2343  		return -ENOMEM;
1f7319c7427503a drivers/block/zram/zram_drv.c   Minchan Kim       2017-05-03  2344  
4e3c87b9421df49 drivers/block/zram/zram_drv.c   Christoph Hellwig 2023-04-11 @2345  	ret = zram_read_page(zram, page, index, bio);
a0b81ae7a4ff8a7 drivers/block/zram/zram_drv.c   Christoph Hellwig 2023-04-11  2346  	if (!ret) {
f575a5add8a9a3c drivers/block/zram/zram_drv.c   Christoph Hellwig 2023-04-11  2347  		memcpy_from_bvec(page_address(page) + offset, bvec);
6aa4b839e7a481c drivers/block/zram/zram_drv.c   Christoph Hellwig 2023-04-11  2348  		ret = zram_write_page(zram, page, index);
1f7319c7427503a drivers/block/zram/zram_drv.c   Minchan Kim       2017-05-03  2349  	}
1f7319c7427503a drivers/block/zram/zram_drv.c   Minchan Kim       2017-05-03  2350  	__free_page(page);
924bd88d703e53d drivers/staging/zram/zram_drv.c Jerome Marchand   2011-06-10  2351  	return ret;
8c921b2b43d47fa drivers/staging/zram/zram_drv.c Jerome Marchand   2011-06-10  2352  }
8c921b2b43d47fa drivers/staging/zram/zram_drv.c Jerome Marchand   2011-06-10  2353  

:::::: The code at line 2345 was first introduced by commit
:::::: 4e3c87b9421df497d849ae61aab9762de7f66afb zram: fix synchronous reads

:::::: TO: Christoph Hellwig <hch@lst.de>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

