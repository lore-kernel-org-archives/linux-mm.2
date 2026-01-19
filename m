Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32258D2ECE0
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 20:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF9A6B02BE; Mon, 19 Jan 2026 15:32:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8730E6B02C0; Mon, 19 Jan 2026 15:32:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7920A6B02C1; Mon, 19 Jan 2026 15:32:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66FB36B02BE
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:32:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1240657A81
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 20:32:22 +0000 (UTC)
X-FDA: 84349860924.01.E33E8A2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5D13040006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 20:32:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Lu5RpLO/";
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768854740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBFg6u2TCvhpDDtVuJEWPHJ/ZjLpVVvwR+Jf5/FfuE0=;
	b=MIhFMpCXC+WvcIqJ4DlhwJBjYJkLxD9u0VGOtTPbPTA2qc0FXNQmGvqxm98K+fHz9EH/Gs
	x0sj4IvnQxIzBacEgYcHnvw01e6GE7yr4V5SniQyp8doOkVq/8oj0W+wsaLOQgNbdrzwwS
	aadeae6aySEucmFq43Akn/iKZD3felU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768854740; a=rsa-sha256;
	cv=none;
	b=PN75GYPlQuAWlimWAtPDf5i0hPezde74Iu4fbfl+6fN5aGb8DY4VMkHsFDqeBqVBwkMLdV
	OviZ/lK+uGmJB+pln3bqjqNJbumRNQD3CMXBqedwlE5sRBxVwYIwnwPZK/BCshgVBtJXuw
	vKWJECTwQ13yJD3B4BJKwXSYRIrq0OE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Lu5RpLO/";
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768854740; x=1800390740;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0kSyxZkV6VvJmJlenpWogDJfu5GTq7YVZxtQIvgk4YQ=;
  b=Lu5RpLO/i9N0VQNkuANg4p0OU6zm/+tQEuKSbJw9fpK/NRZ6l8v6gt+b
   M9qzmhoanEuR+HZ+UBZNWdVuXz3ZmQqtqQ8bf5iVM8gRXiWRU+KUBzIyl
   KhyMsJe2REQsN36L9M5yEZCaeKeujFVUbvFo5A48ga/NCn3jJ0CAhYP6j
   KOETDvxil7rTSTWwKehwHbR2t6QaK52qJ8Vz9Iser9Ml5MSp9ir7VlYCh
   11Y0fIvSBMCAg5I+/iTPp8Vf5yOnsh0Hlz84ydQjWxWyjErUv4PvqH9k2
   weu5XUkL4O26sORu446YPUHkgbNCHjjNpi+m64E2JRkPEZjhG7YOzxFpX
   w==;
X-CSE-ConnectionGUID: Ib436mb3TJq0eRcV1nyveQ==
X-CSE-MsgGUID: So8eMuWRR3ujL8mjPLYW7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="95539203"
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="95539203"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 12:32:18 -0800
X-CSE-ConnectionGUID: svZBSJU6RoOD5C+BtsURAg==
X-CSE-MsgGUID: K8kb2n/uQyWqWjoRgkzGvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="228877536"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 19 Jan 2026 12:32:15 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vhvv3-00000000OHf-07LS;
	Mon, 19 Jan 2026 20:32:13 +0000
Date: Tue, 20 Jan 2026 04:31:26 +0800
From: kernel test robot <lkp@intel.com>
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH v2 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
Message-ID: <202601200418.y3IajnfX-lkp@intel.com>
References: <20260119112502.645059-2-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119112502.645059-2-mpenttil@redhat.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D13040006
X-Rspam-User: 
X-Stat-Signature: 3tp1n3xjnq41rcqhkrex7tsd1km1u19f
X-HE-Tag: 1768854739-453439
X-HE-Meta: U2FsdGVkX1+gn3FaHliMqgEJcHNGzT0ac3B0mKDE83CMWBapuPDipR51DpGS9DtLejdoU4LI+Pf60TXaG7fRIprz1q0zs/aHzu2Mp2KlFkvLK9jWed1wGCM2zP5BypbzPfaq5W6kifDctCZRUThI6oE7iPpUh0xgkP9UpniMpwc9zaeaIn63ke7BcdBZd/ipPQLhMStCHuQf8s5jmRJITvBEBs0lP+Fv1YHaHhiZkxUe4uEWzm+JtdkkAWkv+hkXhmH8OdM53wBSCjtozfzao07uVH9cYrtJVFOyVOeBvEFECz46p7PujO/GTDCgppJ4+zF6cKbgpuNYUaxt6EtSRDmvv200zGKHQ6DpqU2PCswmSQSkN/f7FHYftiNsIzmWY/I+ovj4EeO3U8vMTcptMxJCBuNyUi7VTocgZ9HifA0ReTvWO9XrY4Xwn41MpNxcTWZ/o7kutj1d8DZyXRwE+W9LksOpAir1GJVeBddxACZyFvUeCqxyGl440WWmYPNpBXmpq4a5E99sRV5CfHMCKMRkQPgbhtweQtmrtDMxvFENjZmVzmw8Kb5AZ0KTr9/G+NsNqZVQuCAKcDx4QhQSq4nEibL977tBQw76cy6D94bwZtD1jxCGMulL3YllhUXBdo7asyrj1QLx472CBYMmcH6M0gDFkc8Zl/h8DxMDXhs+RiX8u2NKCGcWobpVW8ZKYwm/i8o+w2qBh/eB6BSiosZ8Adt9IM2I2C0HCqXYo+JUXqUTFgCm0bmSktsWLSeceQEqTt22NpTd+5WjrAEPmuDwTMWlI88exVW8EIlpTfF7aJdKMhlmL+dhtTweMO8Hzo+vYfTC2cid/TrPO1F+phNoc1huTjBmGDXuxt/jZttgV6fy8ewmMtIUBTZVSOwHcVqpIcm+evSc46wJa8p0OuhpWRsKbzNAkvCq8KmH6jDJlpA1LTDpfyv3yugkEq6yKN0jz8+du1nGvZPCmou
 8ay+mYu0
 CxjxK00ZBGIf/XHkvG0BUepMSiOmjdCAyxVhZ1Ab1fpNTUZ45ahXTrOF+Fm8NemY9psEBj5HL0QgPHt0/7ldL9xwFsIL63X/iL+Q0Y8d2IeC5mWsSnhiKA+ZmMjQDaFQdPWtb8HRUn7osL/WNNdyDcCzc0mkc6OMOBOiV/81AzYQSu82GX+nIsGrmUrSvkEx4j9PKrDgtG3gDH/n3HWFvona4DssTn66FcfKdIcbGr5yXp2qvYVmt4K+BIUezbTKo2bcUnSRG3tILG2EtIjcBlWUUNkMT9i40KKHlpgbfDnJL2Px1Ovc7J1b5vvkncYZ5aNx802SG6PuL8UaPUF6sY1/MKx3AK3Cwc3NT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7]

url:    https://github.com/intel-lab-lkp/linux/commits/mpenttil-redhat-com/mm-unified-hmm-fault-and-migrate-device-pagewalk-paths/20260119-193100
base:   24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
patch link:    https://lore.kernel.org/r/20260119112502.645059-2-mpenttil%40redhat.com
patch subject: [PATCH v2 1/3] mm: unified hmm fault and migrate device pagewalk paths
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260120/202601200418.y3IajnfX-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260120/202601200418.y3IajnfX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601200418.y3IajnfX-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: hmm_range_fault
   >>> referenced by migrate_device.c:774 (mm/migrate_device.c:774)
   >>>               vmlinux.o:(migrate_vma_setup)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

