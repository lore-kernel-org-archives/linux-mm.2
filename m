Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 374C7CEBF72
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 19:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5168E0005; Sat, 15 Nov 2025 14:17:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19CEE8E000B; Sat, 15 Nov 2025 14:17:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E9A8E0005; Sat, 15 Nov 2025 14:17:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E63758E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 14:17:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A83454DC68
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 19:17:50 +0000 (UTC)
X-FDA: 84113801100.11.65021C5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9551F160009
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 19:17:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FVYuO2mY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763234268; a=rsa-sha256;
	cv=none;
	b=G3K4wdBH9nd2OX4nl9c0RaTPCrvXXtmUWxQMtR8iXobotCxMPNOl/+UIV9ROr2XaNns6Sn
	NrgoSqIum2RZYw3D5bW4PTUfO26/3CveafMBx5RWO9HwZcrX9yrpClYb5+2KrEz0PRsZsP
	zTmPun9Evi7r6wvyUgehM/aCOJ1fRh0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FVYuO2mY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763234268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/hkFVHB5LET9PwmQ1y1X1x00oNjyWU6smlRjXH3oD2c=;
	b=ySpzxanS2frMX4evPb0vBJQdcWSgHe/hPgeIR1xEOYM56+VBRWYrSJ50AP05DcMzz1Z/y4
	QJzMHQODA+15+kokY+INcbW6DEGxzX8tvvaTndIo2ebS5A7OkyP0YbRZt8nswiAoKwi3Oe
	AHlw1Nh6fPWStaO6riGf2EIW2S/p8hs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763234269; x=1794770269;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ueBIAissdbE2rNylSIiqjPFYNkDgZ+wha6Yk6wSsQUo=;
  b=FVYuO2mY3oF6K/KzRnMrAX9MKJSzZx4sNIqyIoLBPhKoYsGBoHdPVAnK
   ODbNfR/N41oyB6KaaskTc/Zzp9Hk/No8D6dN4T9FaBEK7Xj+LpVr5g/kO
   BQuX8q9msA5XjYIJmB9NWU8YFEv7fis5on4Qux9OVyU4DQasvA1EhDChl
   2PYyoixB8VG/vQowBOIlws7G1+A1tZ0OnWeL00BwPvtTwJJOqSrlEyufb
   4b5qVUltCUtJyW92RURka7O6qOMpbUla5TO5q9XmjhxLlAd51+XtSjE6R
   6d7Np6jSkqpwxXshgtlY4RmtVWXyNrP8D/3CaHBFSVG6N1TGddBQRgawA
   g==;
X-CSE-ConnectionGUID: J7G5naI9QGOs1dWhIohe3Q==
X-CSE-MsgGUID: zzRNmxZtSKyaU/smW+DTUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11614"; a="67901340"
X-IronPort-AV: E=Sophos;i="6.19,307,1754982000"; 
   d="scan'208";a="67901340"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2025 11:17:45 -0800
X-CSE-ConnectionGUID: IXKnlsu4QUGcwimd1zdiZg==
X-CSE-MsgGUID: /pnF3jRCT/S4DUOTIlg3xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,307,1754982000"; 
   d="scan'208";a="194194210"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 15 Nov 2025 11:17:42 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vKLmG-0008CV-1B;
	Sat, 15 Nov 2025 19:17:40 +0000
Date: Sun, 16 Nov 2025 03:17:18 +0800
From: kernel test robot <lkp@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [akpm-mm:mm-nonmm-unstable 82/133] fdt.c:(.text+0x6ac): multiple
 definition of `kho_alloc_preserve'; mm/mm_init.o:mm_init.c:(.text+0x0):
 first defined here
Message-ID: <202511160302.QiMsgMfT-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 9551F160009
X-Rspamd-Server: rspam07
X-Stat-Signature: juyddzyurb9r65kthm7gm3mz7zceqsgc
X-Rspam-User: 
X-HE-Tag: 1763234268-805946
X-HE-Meta: U2FsdGVkX1+6HPjfsGRDw3fqdndYawJKL77+IHOJv4Z8ISfXgV4diFeoUPJA9DDBD65VKU8De4yF2VED/CjaizInJgjc8Hvtfsez3yWFDD5gzef4yYFzQfbGPJ1wxAM8nHXTBAh/oQaopAwjnUkgHOXSCdmNqZ3Jf1lolEQlwsBuC3I3V2ixFJaWA9SHCqhWI3ek+Q2QpqH5J9wglRNeWj2miR9X3JUkIoWPwM5CgVg3kST9o2Bm9qMVki9AEk39cqKv9K9w5zONS9CvAzuJ66xta9haYJvxbiB+zv9CU0hZGRIMdizZQhboqht+xvInpNArnH/5ZXnnL+aO/C3pBQ58J2jj397cQ/KqTO2r2mBtCPVfVDXc3MEpL/KVOW6m9B+rQ6hn1RpSFGoHxRCFr+4v/J5JDEZkudr57wHG5tzFr1qfNU6xyFyXwpUi5vGtF5Ew1Ad4rJorWgussF1QgelJbOc+MXaadR8fT01meE0UpYX+AO63BbcIk1GcWwL1Z884IHT3R09C8Q+aDLka9SyeaYRs9zF9VP/yIS99Y1EGae9Ds7n60YlV7xcvJX9Kv/nFvIE2S4OdEPiQUlUUAgyHIl4HH2RMwptOwcKZCaMsR2wG5OWOaUWwHxCbwzyKzfuNI4V5VOE5n7z0xSjIkid5ztEQtTwxWfE7v1hzNB8KzbAwmbNnUZ89ayErw/FbJRRCRGow1oVZkFDujSmK2ecLypudi4He0WghAozIOXXCuky6DPsesHX5IpKPx5OqBD8o/8eZW8H9r8Nwd6eHL6hROEhrXt+z/zYU698n8Jpa+qsxVEhWPgtO1UcdLnMkMub0GnRLyGmNlYLcLaT/5JxCUxua3vigbAT2gctvb9CBj0qPBZglrjnA/pXEUKAvyKIuk4a2hXcx0xOnAZrIvlJ7DjGtT+uxTTrVyzghJg04RZBm9WrOcp8vizfuAoK+KWxFx9VWf20Cx8OLirT
 n9k2Wv1t
 pcnI8jckXHhMeN28HUrgRWephQARGzMHePDP6MINbUlOei5siH9NplVdhkoHAtvH/4LYdgYd9guh7BlFrynKjBXSidi5+AdI6pgK7Lg2LwLf5DQXYOK3n0YRfGqT+247k82/3Bxh+xNkibMGMVyLXcksEUv8s9eI5rMQi/E/gV+/TGUH5Ld5BgW5ZejTgntU2LJpYWA77QnWZdcvkFCTiQjxWa8sdGg+i314IAdKonLxMlzBPU4PxoXwNom81Cf8VssDXdzLz6kBcAYC6wDQxCwj5InVYehiJpizXxlnMTtaTPdwdylRz/lyTpRgpNpHhCRmJaYiI5ancD2U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   4fc88c237bfe11bde443e104428aac56e63a997f
commit: 88316955b5b1b4cb0cb2fad416f7e8dde9b246a0 [82/133] kho: introduce high-level memory allocation API
config: arc-allnoconfig (https://download.01.org/0day-ci/archive/20251116/202511160302.QiMsgMfT-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251116/202511160302.QiMsgMfT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511160302.QiMsgMfT-lkp@intel.com/

All errors (new ones prefixed by >>):

   arc-linux-ld: drivers/of/fdt.o: in function `kho_alloc_preserve':
>> fdt.c:(.text+0x6ac): multiple definition of `kho_alloc_preserve'; mm/mm_init.o:mm_init.c:(.text+0x0): first defined here
   arc-linux-ld: drivers/of/fdt.o: in function `kho_unpreserve_free':
>> fdt.c:(.text+0x6b4): multiple definition of `kho_unpreserve_free'; mm/mm_init.o:mm_init.c:(.text+0x8): first defined here
   arc-linux-ld: drivers/of/fdt.o: in function `kho_restore_free':
>> fdt.c:(.text+0x6b8): multiple definition of `kho_restore_free'; mm/mm_init.o:mm_init.c:(.text+0xc): first defined here

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

