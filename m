Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54625C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B62E6B0141; Thu, 22 Jan 2026 06:00:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8635E6B0143; Thu, 22 Jan 2026 06:00:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799AA6B0144; Thu, 22 Jan 2026 06:00:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 639666B0141
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:00:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 228EC1A028A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:00:41 +0000 (UTC)
X-FDA: 84359306682.26.7BCA95D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf11.hostedemail.com (Postfix) with ESMTP id 982154000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:00:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QRfrLnhR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769079639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=c3oN55RI91w/kJubFbrz31NiO/XmewonOi+1PWV6DuE=;
	b=ivnQRqfNG15Yym+L4aOLwvFEKlLqwGYYukvtVQMHNJ2UKQDdjZj31xyHDKVaMUP0rMDhbW
	SWnh1pPw+KpPiP7tTtUIs2KsHC0Rh6+0yAhV96zuJbaduspcYp0q0DOXHoy9MGtwX/Yvjh
	ofqYaSglUUDPTmEvYq9MaV0AxmV/8+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769079639; a=rsa-sha256;
	cv=none;
	b=nvvJY7HtiZX9kJZgwJQRqUAf22QsYoD22Cy58QnqYFgpxYGqQPDSkyHWYUZxdw0eDZmeqr
	yN1Mzir6qu3vi5IBFwEBb23jfBEJNbqVTQo3FyVIsY6Eez3+C58tFfW0UG1PGY7RsNwhCu
	I31ybIrypB57niFd1aY0qJ7Txp1D01I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QRfrLnhR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769079639; x=1800615639;
  h=date:from:to:cc:subject:message-id;
  bh=414em0JwX8mnxT6thkz4YucztIoBgef8eaAQJlCszlE=;
  b=QRfrLnhRe0Fx1ynHl25ZQSYgEMBF2++UrKgQbYFpbkXuyJYZBNkxMCj6
   A5SD+e7ZCaRssm6job44MnmjtnhVS/oqcGBYLLrb4qSzAzgZ43WmvpP1p
   YIuDRVd1K8Y1nKTtN8trkpQf+OTyRYiqkgnaomehSQ3WVeFQxlS17vIXS
   k/68DjxUFMnDeAjuwSL8yew1aWSuneGRcXadahPdXe24cf7TaF0f9xIPX
   XaD5rTeDWZyBnJ5K8zYW22rl2ux2hRL1TVQOKW5TZT9MuZ+6Ks8fpr0ZZ
   XAi87pNo/apF1eKIFK90A/m/KYlwepxAcUbyBuqS2HuczsPncgyxlLh6h
   Q==;
X-CSE-ConnectionGUID: 4rCF9Ti7SDGgHbmenkL2cw==
X-CSE-MsgGUID: A3msDjRDSXKB48+TmAydjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="87734261"
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="87734261"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 03:00:37 -0800
X-CSE-ConnectionGUID: 1KnDKlccQzuBjyj0PhtYag==
X-CSE-MsgGUID: 1hiMTBsxQiG+nr8aEyVOVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="211150202"
Received: from igk-lkp-server01.igk.intel.com (HELO afc5bfd7f602) ([10.211.93.152])
  by fmviesa005.fm.intel.com with ESMTP; 22 Jan 2026 03:00:35 -0800
Received: from kbuild by afc5bfd7f602 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1visQS-000000000UT-2Gnl;
	Thu, 22 Jan 2026 11:00:32 +0000
Date: Thu, 22 Jan 2026 12:00:08 +0100
From: kernel test robot <lkp@intel.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 279/310] memory-failure.c:275:49: warning:
 format specifies type 'unsigned long' but the argument has type '__fsword_t'
 (aka 'int')
Message-ID: <202601221142.mDWA1ucw-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 982154000A
X-Stat-Signature: 7s788dep4uyym79zgy6w5zqyope5j78p
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769079638-610514
X-HE-Meta: U2FsdGVkX1+S7flZJpH/hkUN2SqbRDZ0uIULjsTe8Pnb/A/n4u7vmCXeaAaMOWjTfWN5mzKFfVNL0czLRVrHrfTymaoRZkx2k9YQEfnLaNi2khT28DAXDHhwXrar/vQi6rU03KirK7jn010Wsuaql3md+ICQwcfVTlq/BXok7ZCKtFFldxuFkVv3Cew3o9l6kUJoGpBmRIBvL68BPjpvVB0F0ItBsT00p0MwI7lIYu4HQknWnlzTdmwzat/F2L+2Z1Zrdy/9mF7vYaG08eX6fbBV8fCIEfg3QTtdSYsu6FwPkvp8MwomTlM1aum0ldvnbD4UJl2e/UjFEGce3ZaQ4NIgAPOCeFsZ2NEY7JsHf0iB6imXri7LxeCCdNC14XusCSwf8XUN3y/aANmybQdG6CNj32C+AwkTXBu7q36bD7rV+2+87g4xBif+V5kOBuCtUY4p5f8e8jmgcdz5BgeEgktdtIaeUOfEWlVSLfFp051NtTOwae+ymMAOUbjMsJdSgiF8fMw17xYZQvEfgJKeA8KTbMbKhzXITExNFJIztUTKopCuJCIyAj+jRQj8EMjbEKplsrbVEu8wDz6Z9YSZvRgrkDuJMeY3VFPDz80ch7RRbNc1CWtGpeLX1js+x9iWrKtNaszA6WPRv7xzIz+G/kFKeUD64ZG9YDr66RapQ11KvtKyWykxk1ruVW+yiTWnSlmEh6P4UdYFCFFS2CM8VnW9YC7Iq5rwKjfYiZW8SYWTJzfY6oLE5RJocu+Z9yPiE7LqbXfORbbmQ7v6my/Ml5IhQPdtkkT6oJp/wBIV2ucOhDPAgDwfjNqIdsPJ6W2bRBTCpCEzk5H71gOcXDxiHfSCK4F1TbJCu0sQf6zyg6zCONHskLh8s1Yl6oej9g5HFSdfRGL12dLBWUSN6TfU+HR8DbAZ7uZJimzk9h50l3Y7bOrXz0OPYIMRpi0PfX8axBkPA+QyW/QR9NxpT/V
 ArxeZlnk
 rm/+UMlNh6rpAMSenEymWCr9D2Q9yNw6PPhK38QQO4BpFwrxVPy8blKJUC3dHc5tWSl5AlfVW6itkKcCF/pf3fbUUkq/0+MNtiII7Ots/xi/yzW2EQ2iBrgODzS7mHXClKHG7Z7UYYKABkONr2r9wE/UJeZTMNPM3b3b4vzRKOYvT6/42+IVD0TlyP5yn3LcbvTml7B2BU5KmFMbBhCUQExNW23fjgxr5LN78qD+GaeGHh1a6COBawzg/JbniZoit9mu6/tsvQEItX+vAQvKljCmTt9r16mXrI6le
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   dc4fe40a11269aead253fa0beb098b00417b8694
commit: ce9b369feafe8c65aa134b0c8791bf7f19e463e2 [279/310] selftests/mm: add memory failure clean pagecache test
config: i386-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260122/202601221142.mDWA1ucw-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221142.mDWA1ucw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601221142.mDWA1ucw-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> memory-failure.c:275:49: warning: format specifies type 'unsigned long' but the argument has type '__fsword_t' (aka 'int') [-Wformat]
     275 |                 SKIP(return, "unsupported filesystem :%lx\n", fs_type);
         |                                                       ~~~     ^~~~~~~
         |                                                       %x
   ./../kselftest_harness.h:132:47: note: expanded from macro 'SKIP'
     132 |                  sizeof(_metadata->results->reason), fmt, ##__VA_ARGS__); \
         |                                                      ~~~    ^~~~~~~~~~~
   1 warning generated.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

