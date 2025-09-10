Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C820CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 10:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C8F58E0009; Wed, 10 Sep 2025 06:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0BB8E0003; Wed, 10 Sep 2025 06:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD8E8E0009; Wed, 10 Sep 2025 06:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25FAA8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:55:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBE82838BD
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:55:09 +0000 (UTC)
X-FDA: 83873033538.04.B117456
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf16.hostedemail.com (Postfix) with ESMTP id 37661180009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:55:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Jc8DqEcw;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757501707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QljVbXmAQ2Gt0Dn3FMIHkGHh2KvhTeaqJJz3AE5sVD4=;
	b=vAy5xF3HyFYo35GJgCp9suBGGt3Os4OO2FOxUFprupvByHYnhYbriA/Rc7p/vRPI1C0sGE
	7mHiKDcXtyqxak0YMmy3yH9SiQe1DUeia90NFYv5r0DSVurE16wkUsZTrwQ6u8sCACa/NC
	llUmNRNel/EtHfadSJyhum0yyx5Zw/A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Jc8DqEcw;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757501707; a=rsa-sha256;
	cv=none;
	b=vT6Oaf2KhpPvUT/DCtWMihFx22As/+I/h5ZHz3hDjW8qMUJKlyczSk9FH4ftQVJ189GLtg
	hCQHmWhoLInXPiyaw5OtqNtthMyjiiOuaYciNrtwJQTrNqSXOuA6q3I4UpQX03y06c4pqs
	cla3r+xl5o1OhvCuABUsl9IOXtZxRgQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757501707; x=1789037707;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=uAx299JcDZjCWTYD0f5NpEfnfmt5i9TOZB4kjp25Zro=;
  b=Jc8DqEcwLeRza34Sf1Yjmm6abhdLo70Dyuu4LmbIMqFyBAQHI5v+xR15
   tqQ9RhIo0+0zDCdmKwtoAyR5l0Ja7+XJxI2b7bwsRL6JzCdhLaC5bwE5T
   H0vilKFr0RgvVP/9fgLK7QHMpQKsBiLB4YhkTEIAfqT3SaI1x5VQ8dhUI
   sraWWjhL1A7Sy2CTjobqTRCsfpEI2PqH4+zbSEADApv25Q3j/06A418Cs
   8HbEwYLJoBdWTAr1MWeGt/4wgDkuysK05PGz+lhfW0t+tZbPheSZMqeyB
   m3RfcqRHOD6x7bwa7xidR29hLVllt8KRRshscFNH8ezecfwy1DYNdxLXr
   g==;
X-CSE-ConnectionGUID: B6Pf2xfAQvmYw8gNYjPF2Q==
X-CSE-MsgGUID: 5hewlvLiThiEUuSAANAd2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="59746558"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="59746558"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 03:55:05 -0700
X-CSE-ConnectionGUID: NAL9cNw9RSmtKDncuokfJw==
X-CSE-MsgGUID: mApGe61WReiRAT9ZePhUWg==
X-ExtLoop1: 1
Received: from igk-lkp-server01.igk.intel.com (HELO ca260db0ef79) ([10.91.175.65])
  by fmviesa003.fm.intel.com with ESMTP; 10 Sep 2025 03:55:04 -0700
Received: from kbuild by ca260db0ef79 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uwITe-0005DT-0C;
	Wed, 10 Sep 2025 10:55:02 +0000
Date: Wed, 10 Sep 2025 12:54:34 +0200
From: kernel test robot <lkp@intel.com>
To: Chris Li <chrisl@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Kairui Song <kasong@tencent.com>, linux-doc@vger.kernel.org
Subject: [akpm-mm:mm-new 348/411] htmldocs:
 Documentation/mm/swap-table.rst:39: WARNING: duplicate label
 mm/swap-table:swap table, other instance in Documentation/mm/swap-table.rst
 [autosectionlabel.mm/swap-table]
Message-ID: <202509101218.97pfd0jg-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 37661180009
X-Rspamd-Server: rspam05
X-Stat-Signature: qofpbr1tfdxahya4fscxkskua98ndhh7
X-Rspam-User: 
X-HE-Tag: 1757501707-16470
X-HE-Meta: U2FsdGVkX1+WKPxOmY1tzeEd+YYUnAg8bSFT/c06kNozXE5YTdJJBRDhBfGBY05JCjsLfOn0xIb9bz+1YUm9stK8eXwVm/PkpjDxfHKVrUrb7KbPlFn4mAq2wF9wOxQinwyjSNnBrmLlW0KIEoY1dvRDCA0kUmRwZ8SlGYvmiwRgFzVtniqj4c2DpyUWPNxAd78TrXGhQvTERVa89mAFC2uIiUvYFmqHhgvqbyFG7pJiwFujDfmpPyuHyQIrnIfSo7QdESELOcL9Mv+KFxXeyKK8P4IeHBTrdlXncNHRE4w5VzSyK9RpwdrNdQyM9bjWy1/S8Khs8deUkj9czBguZzdOUbzxknitAnjc+EMb45KPY+SHCyBXl9cdgfnkFMSp4uLYgk7Gk+Xlw+3r2fCKqVWaI5iQqGTLuPJfE5qcRGji1IF8Np43x7i5DNuUanPufSZfbp2TiNZPOn/moCe6rYYJBNDL4G3Sq/2lnIG5IMXaBWUCeqLYulMu35Z7i8yl9cBoFbnhUtisuN9jt2zNSlIJ14rqaeP7SyuuFacZwqeJxtcBGtjcph66WLBOts0Q/sv0a0Y+keIGMeM9h5E/UnBNCCqsiVYiFhOT89CAUu4ylzwHdRwuKAOVNCKm9zYgxQUB2LU4vigNGn1G+bsw+Ilv/jTNIRv/U1yzqW9uQxsOiLwCj/U9l6oekOU3gjki3kowqhSEGIpYEA075Tca9TY2Lsp285a5iYRWXfDbZ7/hCwJBALHv+dGSW1tVTLYstNX7SW/Zs6yXp2ZCJJDeS0uTi+65Wv68iK9VgGxbs3h8Ry+9kKF1rvP71p6jqwVHVy7hKqW3nd29OZsZU/CgpGoDfl448KTgy8Gg3FdDao4eBT7ng7POTKw83uFc2iGNAl+ICXeflO72N4BkPphQPLWQFV0SgbAcfwV2SE5lwH7T5oXOCuUYtk/Ddbh1FTcfW19LFDNPaFno95wlvdm
 U9P0VWgw
 z9iGgHerDdWQoSzSBinsxDlTSXxLrZTjDhHNXCggZkkSHcZ3TL0kj+X0lfW2n0M2omJ7MsgxKm0gIxEnvwnti0FCFj3qrKTvQaMkMEhQ4mnOuWzGuAjLeRKQsqOaCsG2sdGXljzmjTpIR1Bsgc4N5+Dc0bEQ9mxCR+paScgDMyPDHwUf2c0T5BUgy0N8JtF1TvpqGK1V2urfi/aBVlan/Sbb0sZVNqkhG9j3QpMRuq9sBU1iquw+6CTgzKSgbhCaFntjp8TOdUcU5AKRTTiYA11GHUg1zJZvShz1H3P3ZmpIqkr1Jg54uXxo1lihZXOS7XSoh91qTA7/iCk5ziXlcc27vCD0vP+EdEqMQJKs86i0X2zM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   3a0afa6640282ff559b6f4ff432cffc3ecc2bc77
commit: ec9b9250f31f1560443efd2b4831e6d3404a135e [348/411] docs/mm: add document for swap table
reproduce: (https://download.01.org/0day-ci/archive/20250910/202509101218.97pfd0jg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509101218.97pfd0jg-lkp@intel.com/

All warnings (new ones prefixed by >>):

   WARNING: No kernel-doc for file ./include/linux/highmem.h
   ERROR: Cannot find file ./include/linux/highmem-internal.h
   WARNING: No kernel-doc for file ./include/linux/highmem-internal.h
   ERROR: Cannot find file ./include/linux/migrate.h
   WARNING: No kernel-doc for file ./include/linux/migrate.h
>> Documentation/mm/swap-table.rst:39: WARNING: duplicate label mm/swap-table:swap table, other instance in Documentation/mm/swap-table.rst [autosectionlabel.mm/swap-table]
   ERROR: Cannot find file ./include/linux/ethtool.h
   WARNING: No kernel-doc for file ./include/linux/ethtool.h
   ERROR: Cannot find file ./include/linux/ethtool.h
   WARNING: No kernel-doc for file ./include/linux/ethtool.h
   ERROR: Cannot find file ./include/linux/ethtool.h
--
   ERROR: Cannot find file ./include/linux/mutex.h
   ERROR: Cannot find file ./include/linux/mutex.h
   WARNING: No kernel-doc for file ./include/linux/mutex.h
   ERROR: Cannot find file ./include/linux/fwctl.h
   WARNING: No kernel-doc for file ./include/linux/fwctl.h
>> Documentation/mm/swap-table.rst: WARNING: document isn't included in any toctree [toc.not_included]


vim +39 Documentation/mm/swap-table.rst

    30	
    31	2. folio: A folio has been allocated and bound to this swap entry. This is
    32	   the transient state of swap out or swap in. The folio data can be in
    33	   the folio or swap file, or both.
    34	
    35	3. shadow: The shadow contains the working set information of the swap
    36	   outed folio. This is the normal state for a swap outed page.
    37	
    38	Swap Table
  > 39	----------
    40	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

