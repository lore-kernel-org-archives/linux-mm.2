Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B160CD8CB9
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC466B0096; Thu, 11 Jun 2026 02:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4806B0099; Thu, 11 Jun 2026 02:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EEEB6B0098; Thu, 11 Jun 2026 02:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7EA6B0096
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:21:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 216DCC0976
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:21:52 +0000 (UTC)
X-FDA: 84866636064.07.DD3F959
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf26.hostedemail.com (Postfix) with ESMTP id 05585140005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:21:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf26.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781158910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=CU8613RlYmnkdZDHeZnsOukBHa8J6Mb7aXq0IUHVgHw=;
	b=1lRivg1l4MaLn5FZUlrASPxVa8yLa29KP7n5p/H6wVHLm25xVikWr2CGJ6O4ueNWs8Oor6
	SzHdHUGtBs53RhYVZP3uSxqi9QR8iwVvr//QYbUEPLCdJZZ0cM8u72DUYgJ6lcsK3bb6Sv
	rdQmpMlJRHLwi1bbngQ56F5OInFNXwE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf26.hostedemail.com: domain of huangsj@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=huangsj@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781158910;
	b=N10zSOgdrnE+rxN1/8VWpkgQWzSk87okpx//CbmVXUEygzAbBYvG2U3fSho8GHuXqPqReW
	qgL3DA1ql7NDUvuGyTG/S62H68ziNblUL1RF08H/PPX4ykfCFSuLLcNJ4O6mqPBj0yv6ay
	5rFd2xp8mwEnrQ+uxiwIuW88UZ//14A=
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXbk745pz1dd8Y;
	Thu, 11 Jun 2026 14:21:38 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gbXbh5hZnz1dd8Y;
	Thu, 11 Jun 2026 14:21:36 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 7FE3430004DB;
	Thu, 11 Jun 2026 14:20:11 +0800 (CST)
Received: from hsj-2U-Workstation.hygon.cn (172.19.20.61) by
 cncheex04.Hygon.cn (172.23.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 11 Jun 2026 14:21:31 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>
CC: <surenb@google.com>, <mjguzik@gmail.com>, <liam@infradead.org>,
	<ljs@kernel.org>, <vbabka@kernel.org>, <shakeel.butt@linux.dev>,
	<rppt@kernel.org>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux@armlinux.org.uk>, <dinguyen@kernel.org>,
	<schuster.simon@siemens-energy.com>, <James.Bottomley@HansenPartnership.com>,
	<deller@gmx.de>, <djbw@kernel.org>, <willy@infradead.org>,
	<peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
	<namhyung@kernel.org>, <mark.rutland@arm.com>,
	<alexander.shishkin@linux.intel.com>, <jolsa@kernel.org>,
	<irogers@google.com>, <adrian.hunter@intel.com>, <james.clark@linaro.org>,
	<mhiramat@kernel.org>, <oleg@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <riel@surriel.com>, <harry@kernel.org>,
	<will@kernel.org>, <brian.ruley@gehealthcare.com>,
	<rmk+kernel@armlinux.org.uk>, <dave.anglin@bell.net>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>, Huang
 Shijie <huangsj@hygon.cn>
Subject: [PATCH v2 0/4] mm: split the file's i_mmap tree for NUMA
Date: Thu, 11 Jun 2026 14:18:56 +0800
Message-ID: <20260611061915.2354307-1-huangsj@hygon.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.61]
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 05585140005
X-Stat-Signature: mwmagapehn4xjkx53s1dkxu37fb385kn
X-HE-Tag: 1781158906-682958
X-HE-Meta: U2FsdGVkX192XQAA2OYKVLYhyvSEfrjgeadsc8uL8jKbNBRn9lY0ZXsbo3HwITkudL5V2ub8YJbdq6o1se/iBMoHJowfCOZWVDHQVf5nnnUq3oG2NdicxrzLilWsdCy8K/W+rxBIP4QwW9bPaBeNeC17ZZyY8++lYyUPKddC78uF/38peq0R2o9a7B7gtvPMNQzkFoasrEFHjBRUD4WvU4PaiKSaPP3gIafHf+LiuAfxROP7SGezX2W4K2C+nNWk33uMjwByAuOgOTpjcvV3S8sG3xduJvlC3hf+70Q4P1FGAWmuAM/e/1qocqnbiiJRujg3vyJkhQFLrasTPVRQvL7DOrvjzKWA0nfO3Qpe8N0mfKgEu2g2wMqeMNMbWAYF/az0sFvvo1Jmog+LkHViGlX8cYBO2Nrb21Y86GFwwZl3kakUVoUmgyc61AjVSmd0IQaWiqywJPct0jndgx7jUSQWNEXQWAf8uh7ozV6M2HUxKDvNwVsQZp/vCvACbxEY+6CMhAnzl/s71PsD4HJbQOcRzQMINhpSx/qe65Rzo+W3FlGhoSoaXuCt4jWSpJYRpYQjz+L3hsjG90y4aIkyXujMGODkxHk5J4dBtDMUt7VZLQxxyzZFlhdQOScauWOmYsD+XFQ5MzlyVdXAvG0eWn41LbrJ/nvRr9PTcR94ZndfESvuD8yBDu/0taSd21b9MJQrS2dtzVN6hJC1wCDnk71c5YD8bHAh8yzQBFuulSZGPFp8ZVh2Y+j9AIC0BhoTGnIRfi/AeObaRliTPCI2bCLJ5LJW7FKpRvzmekG4QlxPRv1UY/5XflTiWgNnwMdR8kLIgtRiA9TSm7CJVzzsNKdEWqxWLK0zFRUsaZYffXI0oPDZQ5d7mgRW4mas4jvwhO9BhFOwLADBIvQr0cvhZHC9pGrjRmxmTq042aVDXQo1qB9iebDytQLgpQqw4/pc9Dh0Nz/V6VigjpyBANf
 8our/rEL
 G8m8fIGnwd10t1V6ndDz40c6l/3NtDZm5RA4fQTUSO9SNsS6tZ3SAbM2jW1xjuWjPo8oBxPLlu0ntXpiPGw0gekYRAj64px11p5Ao+OpY4mgo2xV5DGBsZWM+WcAnk2z7UKVkEu16dKBqMIV4swCMoAest1W3uje5qggm9XILHijIBn0LCkiFTAvKk8cCQkLlJEKT0MBD8OAYiogSma4X13xIwkfHmlAK3LzyVhABfSQHJyxfvdWFTmzperPfGhMvq0pWzlJjgcen8wWur4I/SUbAuVfYjJ44d15nBvb/KJfkVPzxcUOj9YNNvrgEDCi0caBcl4pNlVX7CDtIGldyXZru1dAeMLP+6HowMsvjd3fSlCIfXqV93U6SpjQOeUdcM6i/kNgdGUl3Zg0CH0Z6rc85FL+4BcQjSjxNnWOnONGu6xWhqDh23SB4EykjqWSpzcEvuipxCIx0i3kOZdtKKv0ZhZJHzPYIEqQh3d2fnixSMpE0Mf8Nk/Tl6gXx0QIe3B08
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  In NUMA, there are maybe many NUMA nodes and many CPUs.
For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
In the UnixBench tests, there is a test "execl" which tests
the execve system call.

  When we test our server with "./Run -c 384 execl",
the test result is not good enough. The i_mmap locks contended heavily on
"libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have 
over 6000 VMAs, all the VMAs can be in different NUMA mode.
The insert/remove operations do not run quickly enough.

patch 1 & patch 2 are try to hide the direct access of i_mmap.
patch 3 splits the i_mmap into sibling trees, each tree has separate lock,
and we can get better performance with this patch set in our NUMA server:
    we can get over 400% performance improvement.

I did not test the non-NUMA case, since I do not have such server.    
    
v1 --> v2:
	Not only split the immap tree, but also split the lock.
	v1 : https://lkml.org/lkml/2026/4/13/199

Huang Shijie (4):
  mm: use mapping_mapped to simplify the code
  mm: use get_i_mmap_root to access the file's i_mmap
  mm/fs: split the file's i_mmap tree
  docs/mm: update document for split i_mmap tree

 Documentation/mm/process_addrs.rst |  63 +++++++---
 arch/arm/mm/fault-armv.c           |   3 +-
 arch/arm/mm/flush.c                |   3 +-
 arch/nios2/mm/cacheflush.c         |   3 +-
 arch/parisc/kernel/cache.c         |   4 +-
 fs/Kconfig                         |   8 ++
 fs/dax.c                           |   3 +-
 fs/hugetlbfs/inode.c               |  30 +++--
 fs/inode.c                         |  75 +++++++++++-
 include/linux/fs.h                 | 179 ++++++++++++++++++++++++++++-
 include/linux/mm.h                 |  81 +++++++++++++
 include/linux/mm_types.h           |   3 +
 kernel/events/uprobes.c            |   3 +-
 mm/hugetlb.c                       |   7 +-
 mm/internal.h                      |   3 +-
 mm/khugepaged.c                    |   6 +-
 mm/memory-failure.c                |   8 +-
 mm/memory.c                        |   8 +-
 mm/mmap.c                          |  11 +-
 mm/nommu.c                         |  28 +++--
 mm/pagewalk.c                      |   4 +-
 mm/rmap.c                          |   2 +-
 mm/vma.c                           |  74 +++++++++---
 mm/vma_init.c                      |   3 +
 24 files changed, 534 insertions(+), 78 deletions(-)

-- 
2.53.0



