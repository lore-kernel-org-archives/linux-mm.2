Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3486D606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=K+RvC28D
Received: by kanga.kvack.org (Postfix)
	id 426426B05B8; Sun,  8 Nov 2026 22:07:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D72D6B05B9; Sun,  8 Nov 2026 22:07:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C4FE6B05BA; Sun,  8 Nov 2026 22:07:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 043A66B05B8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:07:57 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 840EF14059B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:07:57 +0000 (UTC)
X-FDA: 85414096194.02.FDA2D19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf25.hostedemail.com (Postfix) with ESMTP id A98D7A0005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:07:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=K+RvC28D;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794193675;
	b=1pMG61fO6SK6bf1wcSN6IKIMN3lS+XsxLSr+4GBTbCIQNJUZq0yGwiu2UhKLlTDZTmoXWV
	XAn5jhzQkj5Dd74Cz/xzX5AlmabRA/+vcbgU4CBOs863/oR04c3OF8lhD0H73uW8VvHOyw
	CdHCPxV6E40Y78cOS54Yzkv7fq+6E1s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794193675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7gH5bT2Vxt0gNrCEsgfTETROJ7GF5H5tMV5hP0235n4=;
	b=Yv68BlPQFxkKDcP4RVz5fIMgBEBYjobxMxdG3/nBjOmpA8VIA+l2myYLKyRBuJs2dik1qK
	r/LjtSjFE+2KYrmLq2Nv1G1lSlCFfBpqhQNJwm9iHjw6aNHetSQs2pHpDhmZtCHwywMOI3
	ZXHkatp+tyNMmhdSEBoCu8nqtjtODPw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=K+RvC28D;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794193674; x=1825729674;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=qjDMRVpVkMF74tWTNfZVyzHe4W8bMwXwRyqoOCBYirM=;
  b=K+RvC28D42ZrzN4Zb9oxQS9E+WRicsX67EOo6cLizBkSAnbkui0cpWS8
   zMpv8uCsMDCLvYNAFxVlYO18FkBMoLesbmxBrvb1widvEF0WPL/c2yti/
   0wpat6qsLREwcP2PbikCjgXdz5AuZoec9ZTI2+tD4c4+OwtggdpTfZEIP
   NkwFQ5cMYd2iWQXpjf4sfyNL3+v5rQaaRgaxQ8cvvhbdpSiGDhPiuMbl7
   NAoBAKg/kMUR6w76JYn3K5hTFzc0EvwT3bXwjA136BKdpTbI3iRI9Y7pa
   AcFacdztQk4JrCu9/mUVwf4T2jGkbtVbJ4Ne0e+hlwB1pQfwgBRiZ5NuK
   w==;
X-CSE-ConnectionGUID: lrdI+Z0JTL6CwerQEpKRpQ==
X-CSE-MsgGUID: 8sQTeo18T3Wf0IkuZO+yGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11960"; a="3006326"
X-IronPort-AV: E=Sophos;i="6.27,203,1787036400"; 
   d="scan'208";a="3006326"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2026 19:07:53 -0800
X-CSE-ConnectionGUID: UlLbedElT1KnOpMa1ixC7w==
X-CSE-MsgGUID: i90PE10rQzWi5EpYC7Vy/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,203,1787036400"; 
   d="scan'208";a="7653164"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2026 19:07:49 -0800
Date: Mon, 9 Nov 2026 11:07:45 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org,
	yi1.lai@intel.com
Subject: [linux-next:master] [mm]  1e61c0bd82:  will-it-scale.per_process_ops
 6.2% improvement
Message-ID: <202611091011.f4668ccc-lkp@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: A98D7A0005
X-Rspamd-Server: rspam12
X-Stat-Signature: qi33rimsdanixz57o1bw51td6dxwzpu3
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794193674-564016
X-HE-Meta: U2FsdGVkX18XXNnVimb9y05c20/Rs2YatGKYrFIqjs7sfbCXqa5eS+czmuO786sAeRzCZZeKKgoi7UPCRJh6HlXiYZN0Z1ItEAaHtTNoPZwdIHsFmiFQ/LBckPP5Rmpaw+g3hbC4QpLznXy0V+wqDXQt6NvDqjYUN+1Wbf3QImOKjvMCHkY00XATrQiRHlc7S/N5wbCtug5iqux/KLmrw6j7NwvW2tgRr0QlwjAvOpk91KauqsfMxlBgz9ZjgA4u5/lDL6rf2giMyOoXwgrLa3uFuQ9UmvKgP1vgpfPq0QCk8ZY1dmwGY2pq45N5hcp/XkoFXG3zhaf/t+cXQfDFh5RzkYkxsg4TkHszEaBs6lHd8c14Ih3ZZmgZ4ZqB8PL5xhbI0jTTEQxAmifXPuYuqIukxvXmXZNJwHdwPdFcqUyvSxVUs1IqhkAkXXouSpUsjevpf3H1ddLXcYhM9IZBTGTiIFBtEepmQrNrdUCvw5ojNgyqZjgbZ2Yt145UNSYLg0N/0In4ivNNQ+2B1AzSqmgMpEOb8rQGBFQdkblqxI8W4ZwEaM2aaCVFhsLo0Ib8BUqo3Lh3uE2UJuCC63av7Cwkd7DZHsX9Du7MOBP9auXoKlMivspzylBdwPPFmr7GsSnFBgVl7I6ZvX/Fc5v7HspiBdL0Kvu2LaE3/1AKpvzqJV3MUt3Xnly/vszaSSXjmPIL/48yDr9mOqCvYO8hD6mHjmvLOEUsIwV47qEymNx0vti8AhUwIDtC1pOb6yFvQheyNidYpIlu+nc67GDmhJchndF6/34xQZyaOIf95tu4LxsnQXf5x7H7aHOKoPbBZjYR4z8Za3+QCe35CAtf1dpQUjduMZnFLe49clDpd0FPGzyg9WUEFEoDq5vM8WEDiGgv6gFsRFsk5IBG8zFxPuKflhBFGmAAdkDvnA4sOzUpOYxkRySN6+4nVBIercxJKrxo0Veo4NvbpXcJyrd
 F+hWsHz3
 IDOYzqlpFrqwMGfS9wukGrl1W/RrgTJxi0YWW+CQ8NO2JX8/7b89ZlXXVklNC8UHlCisEKiDsJpbjDP1YYO4msrv9SoFPnNGruBw/DXCuRqjEIzbgxKS8sdLkTlmYd1R7x2yt1rLf5UcZKNDpgGQtDTTPE/NRRP2V9468TVwgHVmYg5fVxVd9pqDb0umBmq9DlPvCsZ2QsB/eLJXLWlyUh/FBvZLhF6c6LQZUVq6hkxSMfX+ar37QaZNrPj2Wq4rdebJwnLHs2sfqLrtmTIS56YXiGcP9oH/k1Qz4oi83QLM5CRXYrVmxE989EMotxgQRZbvravfdUx0Ukx9BJY1+X8ihL5Kp9HIyJo69qqkeZD8YjbTbpevdPjoqNPNRWcBFvRRiNPHeMUFiXSMfEd3O13ZaqVfHu+3C3TArZL18Fzz6BRAHffYhY96tYU0fTjCdJliLQ6uTvUH8875oodQMsSAhURuAijq3semgaeTAxM84R5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



Hello,

kernel test robot noticed a 6.2% improvement of will-it-scale.per_process_ops on:


commit: 1e61c0bd822af6f9026c048d53fe8824881df8d7 ("mm: move LRU size stat updates out of lru_lock in folio batches") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 512G memory
parameters:

	nr_task: 100%
	mode: process
	test: fallocate2
	cpufreq_governor: performance

Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261109/202611091011.f4668ccc-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-spr-2sp5/fallocate2/will-it-scale

commit: 
  25e9342d48 ("tools/mm/thpmaps: fix missing mapping names")
  1e61c0bd82 ("mm: move LRU size stat updates out of lru_lock in folio batches")

25e9342d487fcfaa 1e61c0bd822af6f9026c048d53f
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   5750918            +6.2%    6109659        will-it-scale.224.processes
     25673            +6.2%      27274        will-it-scale.per_process_ops
   5750918            +6.2%    6109659        will-it-scale.workload
  

Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



