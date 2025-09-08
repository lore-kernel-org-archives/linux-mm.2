Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C6D5CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 21:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82FB8E000C; Mon,  8 Sep 2025 17:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A6A8E0001; Mon,  8 Sep 2025 17:25:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97B08E000C; Mon,  8 Sep 2025 17:25:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A54E78E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:25:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56780138B8F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:25:57 +0000 (UTC)
X-FDA: 83867365554.29.9171E27
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf25.hostedemail.com (Postfix) with ESMTP id CCAD4A0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:25:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iF+NJUta;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757366755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZnvajWuIphnkOKjBnp0sF7qUJwZiX+WZVB1irJu2mI=;
	b=eknTV/xQqsXWJhXgEm0+cldBWFWnL3jtSF/byubkJUl1baFjreU9HURFiaOoTHn+Xz3zKf
	hbi6Wys0ZWWAxY2zWNwIInwy8HJfOHd3XRimi578/V0Nl8TciCM/V0doBUyFQhYoOMmElr
	H1GQ+UO5wGXc7663rxZewUBDcr+i5uQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iF+NJUta;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757366755; a=rsa-sha256;
	cv=none;
	b=RsTkQWYa/LrZ5lUsfJvVbQ8QoXkIKzK3kg44PXoU7RxApPt0tPpdXde3Pe14I+jk9TiFSR
	8hzfbuC4X1vyZZnq+ZJ8kzqDktCgPCo2FFDj4dt4xsIP+gn19TAMolDSaec326knAgUr/M
	a/9EQaRVIPx3GDXPuI12fW7iHIDabD8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757366755; x=1788902755;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fu8+aayxVNZCT/oRSmjlPZbESme4v7nIzu2hac/jq2E=;
  b=iF+NJUtadMVvOZ356nUD1Ppsj7y4ndObEAX/j2XvZzLNGrGzFF6TrjKe
   jq7naXbBaLnJpSKNFVldBqMQzT/I8mt38HKiBx0vsvjYB7De312JO8ZlZ
   ua+L8iDbR7XGkJk+HqRbL9WgfO4rcuGHVN9UsRrc3e8PnanBVzeLbdrK+
   p4iTgP+ASqQN4D6Zfsl/Ql3KFvMu8Ygd4z1kFPi9zJOlgVSbsz6pI9HwJ
   URVl7yaB7bejIJNNWEbCbEaGjVs70szo07Wo2wqH+fH3mojTYd1s0B93o
   cKYTPz56z0uNpkZrZP8rqZ2WFLbbBrEzVQm++kBNummWXPhJYjLmh1nW7
   g==;
X-CSE-ConnectionGUID: UAD2EMFzR+K5e5wF6ycapA==
X-CSE-MsgGUID: QWG4p1QSQyyfrPkcRnnWoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70337126"
X-IronPort-AV: E=Sophos;i="6.18,249,1751266800"; 
   d="scan'208";a="70337126"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 14:25:53 -0700
X-CSE-ConnectionGUID: HtjZveYrRG2X2LOIsBwwEg==
X-CSE-MsgGUID: 2TFM5I92RN2w0wCE+oqhEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,249,1751266800"; 
   d="scan'208";a="203884073"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 08 Sep 2025 14:25:51 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uvjMy-0004Ad-30;
	Mon, 08 Sep 2025 21:25:48 +0000
Date: Tue, 9 Sep 2025 05:25:17 +0800
From: kernel test robot <lkp@intel.com>
To: Coiby Xu <coxu@redhat.com>, kexec@lists.infradead.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	fuqiang wang <fuqiang.wang@easystack.cn>, x86@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] crash: Add KUnit tests for crash_exclude_mem_range
Message-ID: <202509090415.cOytgte4-lkp@intel.com>
References: <20250904093855.1180154-2-coxu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904093855.1180154-2-coxu@redhat.com>
X-Stat-Signature: qjdqyoc15393zqtf5gpmpbyyqqnnfaat
X-Rspam-User: 
X-Rspamd-Queue-Id: CCAD4A0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1757366754-286809
X-HE-Meta: U2FsdGVkX19FL3zDWnUbwb+Yfe6sENcUHPX30myEipmRP611GXVdb9JFqPeVovxEQw9ve7Ii6hj4Tg5nHx1ahJyXs7kAHbgGPvHdvom0b9KmiubOi36H6M4mBenq/LUW2oAGd3urzMVD/JmIpexsDZBbcb5SXoujPsyBHElKOLXmnyZ75XLHPHMAdxAlRZAO5gX3MrJKBbAtZeGws8iXYT1TSvVEx5FfbczBsM8g6rn4Jg+VlnVPtmrjZjPWPtMyvUWzw19NEoQbeaGsCV2Idclyyz+3tgt90SjJP7TdDa4QS1wl85vd6CphwwMaHc7abHMKEyCHizQur3hmVoISu4+/N+4759b2TndcQ6ucyJF+RsiUjYgv44/h9Jss0Mie8rHogUD4eVq8W/6g3uhyiFtiIzAwVNU+SGiG+w7kv/FXS0yob4AAZLhCzwxN9P3bc5OX0P5o3s6a1fnZKMQFM0srblxbASMMqNZAMzF41ThB0r6NGluoG9kFa7STpU3gsrv1M8fbHCey99VqkW72z8rKAsPMX7JKAnKWn2Je4ds7PIy9QT4aLu7hQrZsznb9cVjzHBDsEoa/XpdgZ0g9O4gN+qEEwCOkSvs1B9EOSHjlOPPgEfDjm9UpWtdtEYyrXAk6VjMXijk7ZmCtkeG6ij7NrT6CUaJqi/rWjaMgyEPthJUq10MmjC34MleFfx3xFAw/0krzHg8mMWcEwCqFk+fFY+LK233wfa7olXvSBp+Z3cSdcEt74OTS2UkufHPmOuwwQ53rLl1iqn0sEyuWcU7ZV4YJOjnst6Dds82OPVnf9zKgVZSK1wJXTMULYcxdGWrXePguCqfYXtcpumjBiMyKxPpEnVA5p2kv6uSxACXQHxmefNaVDOvpYStgrf/jbt9kogi5PVih+FFrKWwvdD4N7gkKj4KJGsHnGsR/x6lFrfscWDgCoiuldPIqKnxoPzrMZ9YYccAwALMR1Lg
 fNy5td8D
 0xCjEr4QdE3VX5u8r7WA+YyFkVSlQw7tuqJN9vlT7iHFsMh5roeJnaHDEW4hPqoNNDh3hXUSDZtk5kwNTt3/W0XdJFM7j/HH7pQTc27eD1kcBD9wh/ejiHsHyiAP3YyaofPTFmZyMI9fvADeOB4R2oQW50AS9DPCzLxNjpKLUJiCOSOL8A0PeWE0ATBn8UXFfxN39ObCKz9BKR6KUO4aH1d7+YHFYF/lw8KO/W3f6H/67NPBx4iVNU8AdoX3pxv2HDbGT9Q0HMMSyCystdsvA5lw/ddtCJfcURN08o1wl6zoe7/Nw/9DORv9rOSVoS/KA/rXdgy7Fn2XbSWJC8Ow5wzBSZzZBriQprlcgb9CUTWjWyHWMSywF5ER5RzZHs4WwC9W9D5biNJL4tuVSsjpp2iE0sQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Coiby,

kernel test robot noticed the following build errors:

[auto build test ERROR on b320789d6883cc00ac78ce83bccbfe7ed58afcf0]

url:    https://github.com/intel-lab-lkp/linux/commits/Coiby-Xu/crash-Add-KUnit-tests-for-crash_exclude_mem_range/20250904-174105
base:   b320789d6883cc00ac78ce83bccbfe7ed58afcf0
patch link:    https://lore.kernel.org/r/20250904093855.1180154-2-coxu%40redhat.com
patch subject: [PATCH v6 2/2] crash: Add KUnit tests for crash_exclude_mem_range
config: x86_64-randconfig-073-20250908 (https://download.01.org/0day-ci/archive/20250909/202509090415.cOytgte4-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250909/202509090415.cOytgte4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509090415.cOytgte4-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "crash_exclude_mem_range" [kernel/crash_core_test.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

