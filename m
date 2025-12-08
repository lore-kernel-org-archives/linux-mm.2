Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30BFED3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 16:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148A96B0005; Mon,  8 Dec 2025 11:43:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA426B0007; Mon,  8 Dec 2025 11:43:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F656B0008; Mon,  8 Dec 2025 11:43:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E3E206B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:43:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C56B1336A8
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 16:43:52 +0000 (UTC)
X-FDA: 84196875504.03.3E7604D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf09.hostedemail.com (Postfix) with ESMTP id B5F1414000F
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 16:43:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iUeJlDLP;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765212230; a=rsa-sha256;
	cv=none;
	b=cl4WoTUYwtFWN+Kv0mTHqQtroWp8drKs66ddghn3ooJt5pc528nMZhgQemTuXgTxkzW973
	jpWfBaqb0ttsr4SySfxMFqvz4psDE3BkS+a8zjmmTMKsU9dbY8pZSIHx1nowg1XG7gMhn5
	UhT8MiDN0rg864syIrI8Hs+o2qPQMiQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765212230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=b+u4Z9EL2V41trPHpuKoyNzxvjxwi9pAnA+txPH3eyk=;
	b=DYSz/Ef6Fz/N1pJvmRfJIQ3KrfqP/8gn64SBq1xNY2WmbS0bD/o/Qlm3RI03F2PeJOHbID
	l+kvfeufm33kG/7Vv5bnfgES5e9IEW8qjUDXtn5M9wkXRFAcv6via3o7kvOkC7hj2oupLj
	2WgCN/Lr2XZOcGVCv/8N4mcVZ1DLVAI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iUeJlDLP;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765212230; x=1796748230;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=fDIfH5VzOObG9C1cWrRRlXqKLUX9jJjG7BTtQ+x/xf4=;
  b=iUeJlDLPCjiD8arGF9WZze5Cd8PZSc5y07TzqBKcv69y/X1FuZfxbL4J
   gdF1HQhOC1FgLESyvgMYhSMyqvcQ+Jn+OqKq0gFGEWAm/l6mr7Ubn83S7
   Zue74Qp2P6pMPxxaRqePAYv/7Pr0GEt5uC5pRi3tg9qBzaWJH91u12Wc5
   giKJgDsJ2lTno2JVjap3Nxbr+xzrkPAf9hRQQFK3eh7L/+KgHRIDAy6o+
   /N7Zl12yg81ffnSYP0R1UYi5Reo1stJeZH6fpuVK/5/hF9IarCUKqqQgz
   /9n0NRZVTX3MX/vRnBY7W0CPRdb+EipS0OexmmlSY5lgbLKjnsB+CrYQF
   g==;
X-CSE-ConnectionGUID: NVUMxT3+TS65x/pmY9hC/Q==
X-CSE-MsgGUID: 1lSSXAHIRBOfknAbOga0sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="78622242"
X-IronPort-AV: E=Sophos;i="6.20,259,1758610800"; 
   d="scan'208";a="78622242"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 08:43:48 -0800
X-CSE-ConnectionGUID: dfE0v1i4R06Pktm/aSVx1A==
X-CSE-MsgGUID: iQbeCRBvRnCWoK+s7H9Rjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,259,1758610800"; 
   d="scan'208";a="226640408"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 08 Dec 2025 08:43:47 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSeKu-000000000dF-1smZ;
	Mon, 08 Dec 2025 16:43:44 +0000
Date: Tue, 9 Dec 2025 00:43:18 +0800
From: kernel test robot <lkp@intel.com>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 13538/13721] mm/kasan/common.c:601:21: error:
 'KASAN_VMALLOC_KEEP_TAG' undeclared; did you mean
 'KASAN_VMALLOC_PAGE_RANGE'?
Message-ID: <202512090010.3nvGK9yw-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: B5F1414000F
X-Stat-Signature: 6etpegxsu77fqjqiies17tg9tfiefk3e
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765212229-895587
X-HE-Meta: U2FsdGVkX1+N7V3NylcPN9H63cnqaHaP861TPMoBh2Pa9hdVDtTrvARtgO5VrK9P9SCUyo70uD8l3rFe6u0zbvmDB4wZGgH9VihmvYy2X91OcjFOcZmTDTLYauPXnyjQ6zDUHwsmD6GUk5b20O/FEF4rvBUAhZN+B4/1V8uql4FeDwirS8U+l4BtAuX61gDLjaAvbDr7utLqGxxS1yYdO6d0w9ap+8yOGeocTCKyxrze72rjzXzebpPqhn26fVq68/OkWxhlfrQcx8+AOemooANDM5Hc1L+9MOKqqk9Puau6m1jT5rgFErfzfYL3Ebk7/1cp2Ro0cV4szuONq2IpGeK/IzubreWgspC+AOKngVPGNvY7SexRB+IoHmk8StJfyR/AaJXXxEHWmCH7QR/UlRnzhtkvhqmGD4EDNe1bNS5IP2DYvdUZiWTMeNjEbWIZ6bwdczaFlfvJzxrWn+txbDpQnOD895hPw8yk26scUMBJSqWJ8hTRwRMFeD8aq/CnJ3UCC+/MerVqJc1AXyO1ZUkvGxoHTOQkkYIOpHfeCEzV70PJxwnOIcOCV/8xyYRFgB/Lz12T4QmGFDOGCLYEvA9o9kyb9sgJUtzsZARBA0A1qQKlCHYKhOYmZzHwfUsVBIeyJTvcQStUZQtRG2h7/VtABMryVs6t+MeLL+aHyeXcd72JUf9QOA8xZgG/nPe3FvCKpRl7WNiDQvWC1PBZtXYSZmInsUE37mYN5icVWVOGq4A7zg3kcl5MlT2aF1AS7Yr8drhp+65+CGGkDOn2MtqUfFkOaAjhDaqjgIT2vip09hkPL7Rhn+U0yfn/GqvvcvdIgx7cCw1Ce8kYlqyKz59leJ8tmxMyF4Cnrr5vPp+P0NS08fhlH2GtMAlcDRT2Nu2p21rUO/8RMnOlKtRUUCIk12v4+gDUKPhI6rKDI1dz5nXpqTyw7VyijMZilXkbM9TmVyRUFdN7PPFQyIT
 69RkEfAB
 5zRZVzsWEL7/To/Pp83xdfNB31aJggMRZ1kxbBvUWtzgTutQW2VX8LSXjFwJI5yfkDDOvy4Fwi86XprSLAtUClUiMpfWkjURXcoair5IRQ0QhlScebgRFfq9uuTt12fMsLQMNyu7c9yktG5VtwZWxD/LKHSiblXDcvCiRTYX4QTi1cMEdjf65FHJa4SydomRzgFHPQzk/2W0oX2SHb30qVqtodOEs8CjP+I7o7amZdwxKN+V0qauudMlJlMk+seV5tByrphXJej/uzsvkq+LKyXa+IM9xoYHn2qH/IBG1IhLz8CJekfhBQftMu9WabUL17bx29ZjpcOzbv60gDLcMkyfoexZT/lifI7pZRoIcPNDNiBoa/sgeiC2b3QsIGn5QetBW0Xj1TKRMahj2p7bls2JCHE6z0s3dKas8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   82bcd04d124a4d84580ea4a8ba6b120db5f512e7
commit: 6b83afdcfa935db4f836906ca7f0fcafdca8d229 [13538/13721] kasan: unpoison vms[area] addresses with a common tag
config: um-allyesconfig (https://download.01.org/0day-ci/archive/20251209/202512090010.3nvGK9yw-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251209/202512090010.3nvGK9yw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512090010.3nvGK9yw-lkp@intel.com/

Note: the linux-next/master HEAD 82bcd04d124a4d84580ea4a8ba6b120db5f512e7 builds fine.
      It may have been fixed somewhere.

All errors (new ones prefixed by >>):

   mm/kasan/common.c: In function '__kasan_unpoison_vmap_areas':
>> mm/kasan/common.c:601:21: error: 'KASAN_VMALLOC_KEEP_TAG' undeclared (first use in this function); did you mean 'KASAN_VMALLOC_PAGE_RANGE'?
     601 |         if (flags & KASAN_VMALLOC_KEEP_TAG) {
         |                     ^~~~~~~~~~~~~~~~~~~~~~
         |                     KASAN_VMALLOC_PAGE_RANGE
   mm/kasan/common.c:601:21: note: each undeclared identifier is reported only once for each function it appears in


vim +601 mm/kasan/common.c

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

