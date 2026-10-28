Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52387606A321
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 08:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CUMEGqhf
Received: by kanga.kvack.org (Postfix)
	id 560906B05B9; Wed, 28 Oct 2026 04:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538D06B05BA; Wed, 28 Oct 2026 04:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475F96B05BB; Wed, 28 Oct 2026 04:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4306B05B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:10:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BD8E1A0C06
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:10:26 +0000 (UTC)
X-FDA: 85371312852.10.B03E615
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf24.hostedemail.com (Postfix) with ESMTP id F028D180003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:10:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CUMEGqhf;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793175024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hh9Wy8tH9gzZyVJFsxaKrroJrhTewzeV20OzhsXne4w=;
	b=diCbzRLzWxE3RJw2rhAMBsq/6hR9WVXRSS42dt79NHuU/XCZ3Re64qr38CJde5BGh64/rd
	PMd2UuaRQzjLggwoI/S4d60FFqc0d7DpocVyt2V8k8d4ikL6aiOHDMJPkWAood2gibzGF0
	yug7U2/yv+/qwCHXKVyU7WUBqrly+do=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CUMEGqhf;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793175024;
	b=BS+V1cUviw7LQIqTU0jFVId0t8O6V4dtgY1XcxLCd2ONh9VmGrglINc5TfPPdyHXZ4QnzU
	g4iZUkCeu7pX3ekUtCf38CI1qRGFA/UD5pyEM58BCa1qViIZUHAoVaPBpqfly0JnuG1z0b
	nMM/ZkD1IaTieSsM2nchJ0pIoM/XLj8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793175024; x=1824711024;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CmkPjiWVepHL9kFgDxbSfsyXmjZF0FkTAus6SfUIF+A=;
  b=CUMEGqhfN3KK5yqC9BBejFYt4KYyVIla6ddPgLoccOX4/Ei2zPs8PPD+
   rrgeXdcKH5Jel907n9nRaFUT87thhg5VAwUHoiA6s/qJzrte7d7dPKKnB
   mkvD43MOCIn8cH2+CnX7B9Djr1lakHZht2F60QVjzVyuH3GYRn0yPlQlK
   dPwvOM2FECF5yOQ7wI/JSVyaU+sioo2C+d8njFG6ci07oT5saZcTFrvNJ
   rUwfjP0GtDZrN3Iz1tnSWGH7Wlu014IW6rfGRf/RthTaFgWwudYnlgO3l
   /ZDwtfPSk9czLttJccx0cg8VsHC5DDh0ftpTpT7FucX2RyLYak0q6TywA
   Q==;
X-CSE-ConnectionGUID: Nkvjp2N3TcG6Hno6fqN2Gg==
X-CSE-MsgGUID: 4lbjZfQeRGO2Zb1pljK3jA==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1770619"
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="1770619"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 01:10:22 -0700
X-CSE-ConnectionGUID: IjFGHawIQFCCNwWZd8te5w==
X-CSE-MsgGUID: wPg+660ES2WXtLNAsYWuBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="4717188"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 28 Oct 2026 01:10:13 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xLyjZ-00000000YTo-1Q2G;
	Wed, 28 Oct 2026 08:10:09 +0000
Date: Wed, 28 Oct 2026 16:10:01 +0800
From: kernel test robot <lkp@intel.com>
To: Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, ryan.roberts@arm.com,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	dipietro.salvatore@gmail.com, rvvandan@amazon.com,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com,
	miklos@szeredi.hu, agruenba@redhat.com, djwong@kernel.org,
	hyc.lee@gmail.com, almaz.alexandrovich@paragon-software.com,
	cem@kernel.org, dlemoal@kernel.org, naohiro.aota@wdc.com,
	jth@kernel.org, willy@infradead.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 1/2] mm: add infrastructure for per-dirty-page accounting
Message-ID: <202610281551.QJBalzYT-lkp@intel.com>
References: <20261027112702.3747009-2-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027112702.3747009-2-dipiets@amazon.it>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F028D180003
X-Stat-Signature: s4xiequhnhpaxjm439majubid8iybhnd
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793175023-831580
X-HE-Meta: U2FsdGVkX18gMp+qs7ZuKZyjxy3frPVfWR9Jw1x7Qhuzv3V5Jb4OdjHRcA0eDLGMNhPaDn1Ct16WivhDw6xpffXRfqUZ8m1Q+5rQTZgnHKkxLsNhcifeAKWWph61tCZdoAl24MebQ9UlSP/sL0PpZu+wCxAXPfBSSsiEHxCWjSG6P+979XJUOgena6QGe8p0Ixa9YVQPaXaGI+tKflmmbmasBxlhl2PYOnPUuXDEKwaD9lGzYb+BR5yxi4Wp8gcONDvbESXOPF6nQaEMBLgX3w59glwUDjercd3vQg+QLFdYjfV1KGLo1l4prta2HgmGiQuERSQhyvBOd6far9DGdYkMrZTCTsrKqTldWy4ndtEDgeYLtLYdhEmOjtzyo/p8kglvpIaq/wTCTxh6GQLcOriD2wNXQRHUEnA5MA1L69m3pROHoSALiI8gTP5IMhTBWwyvGv9FFf6KHtQc15ja23OB0ZJkFi4W4b74EfQMqMK1nTNzgJT3b53m24V6HFA7Xamc07sAC02jGSbuh8lptJpvfcncvmOBBQjIOqvxBWj5IVyPH/nQsF6MgD7Jh5toBBz+CuhDKQeZv291OiEj95yR9Iybp9qp6OaD2sTvdWRvL2jDE+Z1qvvZePeGyDf+TicRgkf48FFneWLrM1MRwrHCSqkc0xzDw3sXqT85/9vDjGCuuQpzAyhrIp1QOS7E0CVTHJ31fbS0MsnuB/EtFXuXJO3KncPnvzhKz8fOyoZhJk8d0g6YYXyK4/ZCIIqrnk8uA5/qVNzXXwireU47vFjFPbTxjS/iWcfmEBPyG+P57Z4xE/kN86+DCybL1r3Gu5o0N7DuVZzJc0hBYLTAFPXIt7jyzI84P7eAyObMjHpbDMQYPtRAqw6X+Z+b5XLqWTjbkzsmjHYzzaW1SipxeWJ5XE52c7+WRUIiZokkMXPdoE+QQdCmjlxZvgP5vJ8riBY5VC8rGbLuXzLq3r5
 8mj54Cdq
 cz5pkKHQpmKeU83xb/YXt18l40t7wvkyJ/2sOpiAo8NkBvHs4pgDd7RqPUc3ydwQShbtBUyFHsKBDwxELmc9XLrox5ZBX6B4eEUjAyTzY6TDPOpNclE4pe9S1WkZ/y4V2zaO1M5GQJ07d2Zo1cXMs4FZ5sbXXFAAvFTIEZ+hpM7/4D/JhPPYIugSieKHQWjeDzrJo3KupqNQMk0WZHsy9w4V2hSSe/J5jcVmnHNNEvReHAXidMd7sbnAJLV5NvjVRrdAKMgtfxYAWncDSM7Cu0Zc3QUN6+TdNgbANaJakxcxPHWOPomUppEQC3tY+5iJc/TqJty8l4AN2F0Mc1PY7LJP4bi8C82Y7CPLduHHVFYpf3pjZ2xD6SF/M8mEvYK6FwaTMY+EX5P9D/LRAEdEY9XuvJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Salvatore,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907]

url:    https://github.com/intel-lab-lkp/linux/commits/Salvatore-Dipietro/mm-add-infrastructure-for-per-dirty-page-accounting/20261027-112701
base:   24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
patch link:    https://lore.kernel.org/r/20261027112702.3747009-2-dipiets%40amazon.it
patch subject: [PATCH 1/2] mm: add infrastructure for per-dirty-page accounting
config: parisc-allnoconfig (https://download.01.org/0day-ci/archive/20261028/202610281551.QJBalzYT-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261028/202610281551.QJBalzYT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610281551.QJBalzYT-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: mm/page-writeback.c:2739 function parameter 'accounted' not described in '__filemap_dirty_folio'
>> Warning: mm/page-writeback.c:2739 expecting prototype for filemap_dirty_folio(). Prototype was for __filemap_dirty_folio() instead

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

