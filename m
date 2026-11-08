Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09C28606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BSFwVe6I
Received: by kanga.kvack.org (Postfix)
	id 149956B05B0; Sun,  8 Nov 2026 03:14:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FC4F6B05B1; Sun,  8 Nov 2026 03:14:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010096B05B2; Sun,  8 Nov 2026 03:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE9806B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:14:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AD18C02A5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:14:41 +0000 (UTC)
X-FDA: 85411240362.25.ECB1B22
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf10.hostedemail.com (Postfix) with ESMTP id CA802C0006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:14:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BSFwVe6I;
	spf=pass (imf10.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794125679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bfz9+h0yf44yXspz+aihsE+ejM490QZWdZkmfUuMTDA=;
	b=xWbU2s6Ub6o0Gw4+n3fB/6cQ2l3lEzMjpdnRq7L8H+Pz/MkmjWyFhoUOKAM+H4e5Denac3
	ehaqHPgwirKAlXvJSXorJrW01r1BR1w1uBdNdw5sLDSLly1M9G3N7NsdcnznTA1xuDglM5
	c7pFwZN3SgJhRILOX9YLRWDIQHaQaJ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794125679;
	b=SeLBJAewkzeythQgSTyG/5uUqwHtStLe1Wp2ETzon654mS8n3EUbxMh6FWTMqQqnZzP8Y9
	FzdU1o+Wf11wO2xNUUd/NmJ2B43Lc74MJT1AS47lQ+nTg4uvdRd/ABsrVU7OQ8kPBDCkEe
	LxIy5i/NhVCQM0oIaRgMVALLX4OZVT0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BSFwVe6I;
	spf=pass (imf10.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794125679; x=1825661679;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=rsyIzfhuguUrGhsHYiFFB6SqcWKFh1kR+agy5Bl+Riw=;
  b=BSFwVe6IoIUQACnmurLjFiYLcy975VIsduGvuJ9zrzno7Mdm+gtIWYpi
   lfAZxNBpi/O7xjF6qMOWFzHeDYAU+irAoP7V+SCt3muSB4Jss/iErJool
   f+gX3X90DdzkcOg6Q/VTLJBiFxsHUk/M2pRzbiQWNZmm6vWbCOdraBRsm
   cXbnRTO22b6+00bRVfuxFDubHkaAnungCx9MK7bIZ2QO2D+SkOdVNGvFL
   MMX9FEeq7L/QcLoXi9SySoNclA8qckKUXKrqP2HlrnR+8a/5PTjFPvkZ+
   NyxHv3Lb/4knW6KjHIHIRqUR0Loog4tloYo4nM2B2KQNU0BkJ/5CzhqMD
   w==;
X-CSE-ConnectionGUID: pI4anJcCRSWNi98SvBiNzg==
X-CSE-MsgGUID: rDJfBfOWRGyJR3xvuZd3Ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11959"; a="2925930"
X-IronPort-AV: E=Sophos;i="6.27,200,1787036400"; 
   d="scan'208";a="2925930"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2026 00:14:15 -0800
X-CSE-ConnectionGUID: pxtqn/MhS12FhTRPkvGUMg==
X-CSE-MsgGUID: JEP1GETWSSid0Ip0b//Hrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,200,1787036400"; 
   d="scan'208";a="7489387"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2026 00:14:11 -0800
Date: Sun, 8 Nov 2026 16:14:08 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
	yi1.lai@intel.com
Subject: [linus:master] [mm]  e97d7c5165: trinity.invoked oom-killer
Message-ID: <202611081559.ec60e6e4-lkp@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CA802C0006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kfm5pr18smj4m6ygrpwgmeb1acw3sefe
X-Rspam-User: 
X-HE-Tag: 1794125678-829936
X-HE-Meta: U2FsdGVkX182z0r9eVUwIRkpqWVaTxAmmmIT1piCqWpBbU7ISyGWNMo0IG/8ymjrf6uzmYEdfRbgnRQbZo5InLxvp06SBxiDIco52h2/uFP8VhjB//B7ruc1Hbtkosn3NIhXf4EhgZGtzQw9z4LLpE0zVYw39z6PSnWADEgsuydyPMbbA3j1wso1sxU5XTRqdkSGSPFm5jWBknEzmGmBxyuTHSBHhzpGcMrSxaOyHv8txLHdIo6gi3TJhD18OaxRTRAJDvvXMM2SDgF9v5Ru2thoVSymQw97m9E8jjuGc0DiSjEYZqfxTkCTbZkZ+dquvyhhKTnJbfBIjBb/NN4U56gTTE+q5qJwiZ+2zljzD6a2xj1TF2Ai3fno6L1vuSjkZ144Lg6Qm89Sp97dPzKR5h60ibsQo03lKgX6d3ojag5wZulpkYqWYR8WQo6xoyG7bxh8dY7xGv8UisQz4RKgzJtsmtnVKLV4G/nuFcYL0WOQBKA11gB9XC39ahuAoK1Iwcy+9EDh3/gSZZf20IFXE+LrO9JxN+HfPqDFH7VJtN3vUJ7yH8pOHEK7IulafWj6pLhupS4kSkFe+nh/k+oRyzi8CY9T2zwMI+8M6rmgkw+4K2Z8mYsiVF7OhczL+OMeVltbyt4tlwX+//F3OnKNPIoJa6iXGfjfxf05KZjpr0vV0y564JL9IbGydyL+idStHOxRZR8ZQgnm3kxIaN7eqwEE7VE5O7jCEmFlLos+4Gfg2XpuWTucya+yoUd8ILh6bAhS52l+Uun28puEzT2cw6A8SussDvkkxDklwCQCR0n/j/zFH6Y1EmwbNu1o6CvHfEGiC5/6zcaIdrSGkS6qNOORA6+ec/QDIcyksBBZ8YbS7LShSwCDcUeMCBE6+i/hSHiQiBAw65W5jT9Mp9QrzHenENrfKuKdDq6ZfjvcY7VqPqfCZ4UV4zanuANTXntXCUmpHOfnoXedQPFtMYF
 zxQtArNT
 locYiKh3S3K1hvXbnLZinDYW6Fp0z5I9v7gmbsX21IzO34QyXPjNmOdEYKcKvT2rZwHbB5rDO0zr90FuXxoxOSaxxWo0fAnQS3ei+TZ7I1YlZQea4TXruDlia+2fv1//pAig9zUGtwTg2oAIFxC0fVGyQ3Fm8odKpH/qFbAAsObXIkN7Xe0DqD9C1WgjBhoufUFMxG7VTJcTm/meQ9F40Brapq2CSZpq3yQSmcjimjJ2zYdZbATu3V1wXNmUXe+iYTfmcirteUWsI0GvfEnJwE8CJ88b1StI8of0Zo2TsNd4IAeqF5maG2q/g15GPLr60uTLQ9hsCYnZ/PK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



Hello,

kernel test robot noticed "trinity.invoked oom-killer" on:

commit: e97d7c5165227e6e4423b4a869d7805b01706392 ("mm: shmem/tmpfs hugepage defaults config choice") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linux-next/master ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b]

in testcase: trinity
version: trinity-i386-abe9de86-1_20230429 with following parameters:

  runtime: 300s
  group: group-01
  nr_groups: 5


config: x86_64-randconfig-1008-20261105
compiler: clang-22
test machine: qemu-system-x86_64 -enable-kvm -cpu Icelake-Server-noTSX,enforce -smp 4 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202611081559.ec60e6e4-lkp@intel.com


[  147.803560][ T3738] trinity-c3 invoked oom-killer: gfp_mask=0x440dc0(GFP_KERNEL_ACCOUNT|__GFP_ZERO|__GFP_COMP), order=0, oom_score_adj=500
[  147.808170][ T3738] CPU: 0 UID: 65534 PID: 3738 Comm: trinity-c3 Not tainted 6.18.0-rc5-00155-ge97d7c516522 #1 PREEMPT(lazy)
[  147.808179][ T3738] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  147.808182][ T3738] Call Trace:
[  147.808186][ T3738]  <TASK>
[  147.808190][ T3738]  dump_stack_lvl+0xc0/0x138
[  147.808212][ T3738]  dump_header+0xd3/0x440
[  147.808225][ T3738]  oom_kill_process+0x107/0xf00
[  147.808240][ T3738]  ? out_of_memory+0x897/0x12f0
[  147.808252][ T3738]  out_of_memory+0xeaa/0x12f0
[  147.808265][ T3738]  ? out_of_memory+0x897/0x12f0
[  147.808278][ T3738]  __alloc_pages_may_oom+0x1a5/0x2c0
[  147.808295][ T3738]  __alloc_pages_slowpath+0x6d7/0xe00
[  147.808316][ T3738]  __alloc_frozen_pages_noprof+0x1fb/0x270
[  147.808330][ T3738]  alloc_pages_mpol+0x16f/0x340
[  147.808340][ T3738]  alloc_pages_noprof+0x95/0x1b0
[  147.808349][ T3738]  pte_alloc_one+0x23/0x2f0
[  147.808357][ T3738]  ? __pte_alloc+0x1a/0x170
[  147.808367][ T3738]  __pte_alloc+0x22/0x170
[  147.808378][ T3738]  do_pte_missing+0x2500/0x3180
[  147.808401][ T3738]  handle_mm_fault+0x1061/0x36b0
[  147.808409][ T3738]  ? handle_mm_fault+0x41/0x36b0
[  147.808435][ T3738]  do_user_addr_fault+0xa18/0x1030
[  147.808447][ T3738]  ? rcu_is_watching+0x15/0xb0
[  147.808459][ T3738]  exc_page_fault+0x6d/0xf0
[  147.808474][ T3738]  asm_exc_page_fault+0x26/0x30
[  147.808480][ T3738] RIP: 0023:0xf7e1d80e
[  147.808486][ T3738] Code: c6 44 24 28 00 8b 7c 24 14 89 bd 4c 01 00 00 e9 ca fe ff ff 8d b4 26 00 00 00 00 90 ba 10 00 00 00 29 ca 8d 3c 10 89 f0 29 d0 <89> 17 83 c7 08 83 c8 02 89 47 fc e9 b9 fd ff ff 66 90 89 4c 24 14
[  147.808490][ T3738] RSP: 002b:00000000ffe58f80 EFLAGS: 00010212
[  147.808497][ T3738] RAX: 0000000000200ff8 RBX: 00000000f7f84740 RCX: 0000000000000008
[  147.808501][ T3738] RDX: 0000000000000008 RSI: 0000000000201000 RDI: 00000000f58b3008
[  147.808505][ T3738] RBP: 00000000f7f84000 R08: 0000000000000000 R09: 0000000000000000
[  147.808508][ T3738] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  147.808511][ T3738] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  147.808529][ T3738]  </TASK>


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261108/202611081559.ec60e6e4-lkp@intel.com


--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


