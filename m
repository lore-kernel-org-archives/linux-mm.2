Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84683EE6B73
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845986B0005; Mon,  9 Feb 2026 23:31:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9106B0088; Mon,  9 Feb 2026 23:31:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4AF6B0089; Mon,  9 Feb 2026 23:31:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA046B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:31:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E04061C2A8
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:31:31 +0000 (UTC)
X-FDA: 84427273182.16.B565686
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf26.hostedemail.com (Postfix) with ESMTP id E76C4140004
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:31:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QpuBD2OL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770697890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSkv8QEJMN3M22rkC9RyW7ogMYxuWDel14kATDMaHyQ=;
	b=F3M5giAt98l9DzYi3MPqnBtYwOEfNN4mMNV378MIQ3crTRKwOB6JZDkds/qsgPVty6vr2k
	2IXc4v56FkeDHVgatIuzM3XUPkveWu9pkL3AxzJATFCiiTlZuHIhByZTIdk3DITgjOGs6o
	O625robkqW+GbqzBJAIezvJhSMaOdqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770697890; a=rsa-sha256;
	cv=none;
	b=IoicTsHyZKH0PoMfeiN0O5umUSlh9YB4J/+UrploZONCQ+uhLE7NtdVTEDdGp5Nh+nWR02
	UbKb7N99siCo62riQZyHf9tAqwIkkxR9ET8xYKx10G98knzzRqncNz95DL2EeeqFexbWBE
	FBtj1as55RS51fyVvq/Ff0Ys2F/KSF8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QpuBD2OL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770697889; x=1802233889;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Me/7VaLko0TzZv6bW0CujcwPJzAN2FTuE8aRgepOsL0=;
  b=QpuBD2OL7qrsXMlgk5ybRYBjuDPYayNc+N5dYf8FlaXtEfMXjlf1QUIN
   46M07smQ+8APkU0/Dn/dBnY7HrnxqvxtVkKLNNAjtpKEQsIgOTDraDYTO
   EmbcO/Zaj7o+wI1kRSLTCVsh+dIIHTaaEcixKcpfxivbZdgf9mypxouXO
   R40cAMr9PqeIF72qEFYhGcgZjldDUSeZL5rTw0B2FQB5beK6WHPYU8UG2
   Sw7OrH26ERS/75Ar2R+kfoWPAl+BOlqoU/OCMKDixQfZA7PkARl/iNFAo
   sPLuGwBGCaux8f+7oZeNfIzp2rcBkIWAD8mUDtRHqwKGrn+95DoT5+/Vl
   A==;
X-CSE-ConnectionGUID: CWDg4njsQV2jEEuNQeWKbg==
X-CSE-MsgGUID: z2mjlf+xRfKqpAHsQcGakA==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="75666154"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="75666154"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 20:31:27 -0800
X-CSE-ConnectionGUID: opAGqwogQuK4/Nh8z+UYSQ==
X-CSE-MsgGUID: n17DR2xjTCi7iCEwIuQxpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211872597"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 09 Feb 2026 20:31:21 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpfPC-00000000odk-0nEk;
	Tue, 10 Feb 2026 04:31:18 +0000
Date: Tue, 10 Feb 2026 12:30:47 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, willy@infradead.org, david@kernel.org,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	vbabka@suse.cz, jannh@google.com, rppt@kernel.org, mhocko@suse.com,
	pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/1] mm: replace vma_start_write() with
 vma_start_write_killable()
Message-ID: <202602101205.7QyEq3MD-lkp@intel.com>
References: <20260209220849.2126486-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209220849.2126486-1-surenb@google.com>
X-Rspamd-Queue-Id: E76C4140004
X-Stat-Signature: q6hthga73xumc8kjyzod8aji9jgsaomu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770697888-73729
X-HE-Meta: U2FsdGVkX18dKi7bQqC0j622vSf82evNOYQwwGPMtJi/rUjigfxwRtvxvd6FPVFP+DaMwnndYlc4p4jlzd5boR2owewkiPdpOQjL2tVlq9AFCSvZ3/+cmaYrhsm1mfHOXSD1VKre42gtJw9+aJcn7v/8eKTMRCbc+8mFSgEOcEvuEFh5ylGSxoQrNAf/cutGP9kxGx/TL7Zm2LGfZ8D1yzKKgvgDk1a+MJLotWB9xs90/gWLM7WoiYSyyKqc29NOXko6DTDUBMCNdGvZAEx3YuHsfPtePn50DFewBaYNAKN06QBzwuD6wpjRUyz0olKjn8fGW+Rw9VRjWSErbG75nsaSYc7UWGvL8sO9cV836bmb4p6lww/N3Gq3hO//jfEab5FgYHjMlHIg4sZN8vK8rZ9aSgdHtQY2R/2Wz3uGtjjDn2t83wjwm4cb8tnvjKP/gSQuEUb4BTqcJ2gaZpZLGdeDRmKGRtMFCaaF0iDml5JMQW/tBHTIUR3WjYl2w4wLGV5X+xhFw5RlXzx6nClhp/GR1xQAaUXnpRDc7kH1T0Y3WFOw8FcHwLcemRpcZ/evYgYaTu6rtKoh0c0pQv7CdYaQfU4SKsnZOnNwjlBi6pFl7n5BTtVOAc2mzl58rYV5SsXgykyUrUz7+cNhkzGla2JmiZn3D3+yNup2MPoftp9OeJhzIBtI1V6W5b1BfRigxXpYMfdbdHMN8GiwQ3hLo+8awVjLMnNAC8VMCIkV6YXRyG+aWrTL1Om7Z843DSIM78VYu7pIjdXF+/z59Q+NY6RPrsGoymfRsLNRPU9B3VwuRySgEmZacdg22WwSoMzk2NjrKk5R4ooLWrjApSW17/49ZVw2I69K9XSFxevd7wi/X/Qm1PGLKOxgxtJUg0qoZOVdyB28lVEwFIBSBJeTC0T/aqAqsVmJiOZSuLDct0ub+q41X24jfmu/GLq5Mvbn/HNX+La/5dsA8BoFMfL
 EX0cvdV2
 xLKyLqrtgiz05ly/lCj2n3l+d8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren,

kernel test robot noticed the following build warnings:

[auto build test WARNING on a1a876489abcc1e75b03bd3b2f6739ceeaaec8c5]

url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasaryan/mm-replace-vma_start_write-with-vma_start_write_killable/20260210-061104
base:   a1a876489abcc1e75b03bd3b2f6739ceeaaec8c5
patch link:    https://lore.kernel.org/r/20260209220849.2126486-1-surenb%40google.com
patch subject: [PATCH 1/1] mm: replace vma_start_write() with vma_start_write_killable()
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260210/202602101205.7QyEq3MD-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602101205.7QyEq3MD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602101205.7QyEq3MD-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: mm/memory.c:381 duplicate section name 'Note'
>> Warning: mm/memory.c:381 duplicate section name 'Note'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

