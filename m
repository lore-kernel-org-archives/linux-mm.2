Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11CCE606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 21:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=lqobUCvn
Received: by kanga.kvack.org (Postfix)
	id 2460A6B05E4; Thu, 12 Nov 2026 16:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CFCC6B05E9; Thu, 12 Nov 2026 16:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BED16B05EB; Thu, 12 Nov 2026 16:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD5F66B05E4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:22:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23D72161AD3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:22:36 +0000 (UTC)
X-FDA: 85427741112.24.9F14F9F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id D1C441C0008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:22:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lqobUCvn;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794518554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HVBKWLoxC9/1W1W5w7gmLSMLK1As+f5lAQoq1+LwefM=;
	b=4uKV1S5G8s31FLnB0Iz9KOVFk4Qq18xf8nIl+msiS58PaG8fuKweMnrZb801C9yuvIqJcg
	1KaTLAMtvdXTg9swJ8d47LzBAxkayLHDG/Xg6JVlMUjOkR67ziDmLJqvSU4vHsYubt005U
	lSJN+YkDhfTasI3ZJXt99BmxQhDuPso=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794518554;
	b=zYaDCy0kwyU5BIAXI8eDG750B7wLPrzCv8Ccj4TrnEuIvzbWf8gJKfUpcyWGAxEk0x9wgs
	q3l0hdRIVheByEdpnmODqezHltz9bWNB+8bu9NKTBMds6wq4FZ4FF44VvjNFJ3wlikFGx7
	AuCBuM8YsxaUNp2M0gGuPj7HsbEujVg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lqobUCvn;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=HVBKWLoxC9/1W1W5w7gmLSMLK1As+f5lAQoq1+LwefM=; b=lqobUCvnddLWgTJwsw1+oBnHbX
	i39h+4+H20U+gIijvTob+2EMiigqM5gtGG5APHZa2C5Yd2wRBygRUBscP7vQI8aKpJIjO9xMho3di
	UlGV9gP6iqofp0vpqKIRQgu8+1ecxddwUE1bS2PB72oe7OOimg/M/d4Czv+7moX9g5hiZMBd/8o+c
	z5lul9buYS9j2Hf9iFFekAWWsGBblZB5Jv3SiujDJS0S6gsYqcbdfRAdfuffbsC3mqrWCnm/UjAE2
	VhhV2Nq/yMOD4nDNM8R1JNp0bLKXcV69SLCsvQ3akIkxotzVpHsQ2EEUq03Ax5k0cmOU+NVgptNAE
	VczVLOYw==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRcFc-0000000Blw8-2HWI;
	Thu, 12 Nov 2026 21:22:32 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: David Hildenbrand <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH] mm: Add IRC channel to MAINTAINERS
Date: Thu, 12 Nov 2026 21:22:29 +0000
Message-ID: <20261112212230.2805832-1-willy@infradead.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w9acxbx5myb85um3uzh6rowy9bz4zppj
X-Rspamd-Queue-Id: D1C441C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-21.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794518553-515275
X-HE-Meta: U2FsdGVkX18x3s9TPcaCnZMtOGw2cOOafPqQFbnP7SRfoLqKDdDTLHFEXt5V4aGjteooCEg3pRkohdTzoO11/P0lsySLpBSbAsE0QykrzRwSTSUBGB8lBoPy60AaMgCctktMIUnlLo11IoJq6zY16b4DQDULDaDLLESzSo/06TStxATjHItPls30FGQHarL6Bu3oUz5lIqEvgbm6JsJ3neb2drs8BqtkZgYci6AwNrwozOtS0VyKeaa6H6j5lpAbrSt1whVgGY1n2mh9lg5rSdYvVjILimykc3I6MdD+1ajdowLYyjUOqDCAsNQoo9IZRswa+esMiugr1h+Y0CoYfnAgYZ7VTJ9Oj+C1etAKlwLBuYIIK7DvN+BH4qeOnt8Hirwio+ZekxZekRbRQxXtc8E3FlSSBhzbWcXxzfrGvXQUsx9Q7PFeNq2eNGdMPO7wiETH6l3bfICvEmwup7CUkaDCqK3tOc+9sk+yCeRUVZnsL+A2m4Zbv5mq/fKLThFpb4NR/LniuIWs9I4ZnEf+P39GPPVcdrsX2e4zQ1+OY2VimsCSor46izwBHVloL0WehpEryCSEpoL107qd/YIRighswi0IjpWrhDJC69EG8KIRlToQ9+XcQn6kyMCHCYaqyUU4fknvgeWz3Ile57cPje0mn4zpIGq+13MmpZq/1he14lgcl2zom+g/UeuuALR8TTysjLT41xSXkN/XoyVzMSvA1a2sBz2ivgVRziP1cQQals02AmZnfjT3Hne2Juvi9arsPZYSQMKQeWETF8XmYzGdTAx5YOZ/WPu2MItQlnlbQAQSc51E7kbLEZVc9ykOSCUAzqJG+zUh0b7S6JMWELr6SFYUYuvR6cKTB/nSxrNqxLRN+YxJ+1i4wuuuHM/zIwRYP7YPSg7Vq/VhoILRQRuglGHEOt7ICsyjbRE8QC1A83V6MpToPs8jWUSEt0q5ixedutS+vhcJZa6S0Zm
 ZQbbvkEt
 qYoHNzpriWcc0qUBlCgbNt1eMc9+2qpPdTwTCnES+lOSmw8uftMtLFKnBMlPaiOwFtE8ViDNlZDEZbIK5GqhVAyCrc+8BqLlPewGkmWVmPBUQ4pCc3Mm72fp+MoBHDib9g6PHnwWlblhQdV11QzCoS8ArCGxreiEV5XkR3ovAGu8EbHxWOYzAqlkhrq4utGmT4sc1rr3v5kRz4aJtCozHnNmYxA5E77Uh/hyCCEgJk7L8Hy7A6kiMtYhs4oK+0tkN8xd9iSWHn48U3UAgra3F4i9//9dNX60r1KAJOS2HbApt3zokWzIDX0CcpJjjl6FUgT252MQrDHl25g0KBZ2Y3MxWNXzbPSJ13f/wuYwU6QAvzMjOt7zKvjP+nSqzgSG9b77fFfyR90ug2oweZxCxzKeSTkpep3AgQd1KXcJaDHa2XpR2oH2pfXmFTuSS+EcCqEsOaMoOPEuVkoMLLkS0IDQRONJCPCWo6BmvkRdNTmVyS+CO25iZog8E3UPit7DhGdww6s7nAhhNsYlnZxff3UOegI1r2q39TYLReimPwBMGrBUDTDWRCkDVdF1dplMlLFCQKUx11unREN1qeE89i9rE8XnM+QbuQC3oSUBB+HH6aELVIft3N2PE5IAdbPRmNH9fXCi7r4w01uWhVhMNBCboMYtACAaIq2GvjFAc7D0ccYeZDYwi9oTon5iiOqv+xglM7R2nfoZqcFvayNmT3USGiyJaP41NjOCERGagS68rozMCz8cCXvJgMBjCRD60Nk2e78DGGzyqRQuj+h8SzgFuVzdmIe2s2vBp9pELTt2ykxyPDhZjuS5LRtqCW6XLLulq+KIc8ZxdPILadNr9guHfWdSxisR0RSdQpluofUMy6Cl44ozSUQMWhTb0+ewCvN4krPpFkVObrSxLtVrnkg7yOxvFAUDg9qM3hSMTYO4AXTMEow/B7qJZefCnb4AbeP10gfABxHBmCBGRhAaJiWZQcyeR
 9/XbbisP
 B6H1vfij8n9Xx06OADuqnU4xWCfdfiRbqtovpUytjfe7dvX4Rai6rSZBPJAJmvmaVMO+8YgFFUruthAvTvic06g/QgE2wYNb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The IRC channel has been under-publicised for some time now.  Add it
to most of the entries which use the linux-mm@ mailing list.  The only
exceptions are those where I think that none of the listed maintainers
(or other knowledgable people) are regularly available on the channel.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 MAINTAINERS | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 222b7fc2c3aa..d1582d4788ff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5177,6 +5177,7 @@ M:	JP Kobryn <jp.kobryn@linux.dev>
 M:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	bpf@vger.kernel.org
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	mm/bpf_memcontrol.c
 
@@ -5918,6 +5919,7 @@ CACHESTAT: PAGE CACHE STATS FOR A FILE
 M:	Nhat Pham <nphamcs@gmail.com>
 M:	Johannes Weiner <hannes@cmpxchg.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	tools/testing/selftests/cachestat/test_cachestat.c
 
@@ -6868,6 +6870,7 @@ M:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Muchun Song <muchun.song@linux.dev>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	Documentation/admin-guide/cgroup-v1/memory.rst
 F:	include/linux/memcontrol.h
@@ -12212,6 +12215,7 @@ HMM - Heterogeneous Memory Management
 M:	Jason Gunthorpe <jgg@nvidia.com>
 M:	Leon Romanovsky <leonro@nvidia.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	Documentation/mm/hmm.rst
 F:	include/linux/hmm*
@@ -12377,6 +12381,7 @@ M:	Muchun Song <muchun.song@linux.dev>
 M:	Oscar Salvador <osalvador@suse.de>
 R:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
 F:	Documentation/admin-guide/cgroup-v1/hugetlb.rst
@@ -12410,6 +12415,7 @@ HWPOISON MEMORY FAILURE HANDLING
 M:	Miaohe Lin <linmiaohe@huawei.com>
 R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-memory-page-offline
 F:	include/linux/memory-failure.h
@@ -14792,6 +14798,7 @@ M:	Pratyush Yadav <pratyush@kernel.org>
 R:	Alexander Graf <graf@amazon.com>
 L:	kexec@lists.infradead.org
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	Documentation/admin-guide/mm/kho.rst
@@ -16098,6 +16105,7 @@ R:	Alice Ryhl <aliceryhl@google.com>
 R:	Andrew Ballance <andrewjballance@gmail.com>
 L:	maple-tree@lists.infradead.org
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Supported
 F:	Documentation/core-api/maple_tree.rst
 F:	include/linux/maple_tree.h
@@ -17439,6 +17447,7 @@ F:	kernel/sched/membarrier.c
 MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git for-next
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git fixes
@@ -17475,6 +17484,7 @@ F:	drivers/devfreq/tegra30-devfreq.c
 MEMORY MANAGEMENT
 M:	Andrew Morton <akpm@linux-foundation.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
@@ -17486,6 +17496,7 @@ MEMORY MANAGEMENT - ALLOCATION PROFILING (ALLOC TAG)
 M:	Suren Baghdasaryan <surenb@google.com>
 R:	Hao Ge <hao.ge@linux.dev>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	Documentation/mm/allocation-profiling.rst
 F:	include/linux/alloc_tag.h
@@ -17497,6 +17508,7 @@ F:	tools/testing/selftests/alloc_tag/
 MEMORY MANAGEMENT - BALLOON
 M:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 L:	virtualization@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
@@ -17512,6 +17524,7 @@ R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/admin-guide/sysctl/vm.rst
@@ -17566,6 +17579,7 @@ MEMORY MANAGEMENT - EXECMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	include/linux/execmem.h
 F:	mm/execmem.c
@@ -17576,6 +17590,7 @@ R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	John Hubbard <jhubbard@nvidia.com>
 R:	Peter Xu <peterx@redhat.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/core-api/pin_user_pages.rst
@@ -17591,6 +17606,7 @@ M:	David Hildenbrand <david@kernel.org>
 R:	Xu Xin <xu.xin@linux.dev>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/ABI/testing/sysfs-kernel-mm-ksm
@@ -17606,6 +17622,7 @@ M:	David Hildenbrand <david@kernel.org>
 M:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
 L:	linux-cxl@vger.kernel.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/ABI/testing/sysfs-devices-memory
@@ -17623,6 +17640,7 @@ M:	Muchun Song <muchun.song@linux.dev>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/mm/memory-model.rst
@@ -17645,6 +17663,7 @@ R:	Wei Xu <weixugc@google.com>
 R:	Baoquan He <baoquan.he@linux.dev>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
@@ -17665,6 +17684,7 @@ R:	Gregory Price <gourry@gourry.net>
 R:	Ying Huang <ying.huang@linux.alibaba.com>
 R:	Alistair Popple <apopple@nvidia.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	include/linux/migrate.h
@@ -17683,6 +17703,7 @@ R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
@@ -17729,6 +17750,7 @@ MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
 F:	include/linux/numa.h
@@ -17745,6 +17767,7 @@ R:	Joshua Hahn <joshua.hahnjy@gmail.com>
 R:	Rakie Kim <rakie.kim@sk.com>
 R:	Ying Huang <ying.huang@linux.alibaba.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
@@ -17762,6 +17785,7 @@ M:	Michal Hocko <mhocko@suse.com>
 R:	David Rientjes <rientjes@google.com>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	include/linux/oom.h
 F:	include/trace/events/oom.h
@@ -17776,6 +17800,7 @@ R:	Michal Hocko <mhocko@suse.com>
 R:	Brendan Jackman <brendan.jackman@linux.dev>
 R:	Zi Yan <ziy@nvidia.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/page_alloc.git page_alloc/for-next
 F:	include/linux/compaction.h
@@ -17814,6 +17839,7 @@ R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	include/trace/events/vmscan.h
 F:	mm/vmscan.c
@@ -17829,6 +17855,7 @@ R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
 R:	Lance Yang <lance.yang@linux.dev>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	include/linux/rmap.h
@@ -17841,6 +17868,7 @@ MEMORY MANAGEMENT - SECRETMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	include/linux/secretmem.h
 F:	mm/secretmem.c
@@ -17850,6 +17878,7 @@ M:	Hugh Dickins <hughd@google.com>
 M:	David Hildenbrand <david@kernel.org>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/filesystems/tmpfs.rst
@@ -17872,6 +17901,7 @@ R:	Christoph Lameter <cl@gentwo.org>
 R:	David Rientjes <rientjes@google.com>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git slab/for-next
 F:	Documentation/ABI/testing/sysfs-kernel-slab
@@ -17903,6 +17933,7 @@ R:	Baoquan He <baoquan.he@linux.dev>
 R:	Barry Song <baohua@kernel.org>
 R:	Youngjun Park <youngjun.park@lge.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-swap
 F:	Documentation/mm/swap-table.rst
@@ -17929,6 +17960,7 @@ R:	Lance Yang <lance.yang@linux.dev>
 R:	Usama Arif <usama.arif@linux.dev>
 R:	Kiryl Shutsemau <kas@kernel.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
 F:	Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
@@ -17951,6 +17983,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
 R:	Peter Xu <peterx@redhat.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	Documentation/admin-guide/mm/userfaultfd.rst
 F:	include/asm-generic/pgtable_uffd.h
@@ -17964,6 +17997,7 @@ M:	Alice Ryhl <aliceryhl@google.com>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 L:	rust-for-linux@vger.kernel.org
 S:	Maintained
 W:	http://www.linux-mm.org
@@ -17982,6 +18016,7 @@ R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
 R:	Pedro Falcato <pfalcato@suse.de>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
@@ -18019,6 +18054,7 @@ M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
@@ -18035,6 +18071,7 @@ M:	David Hildenbrand <david@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
@@ -18831,6 +18868,7 @@ M:	Nick Piggin <npiggin@gmail.com>
 M:	Peter Zijlstra <peterz@infradead.org>
 L:	linux-arch@vger.kernel.org
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	Documentation/core-api/cachetlb.rst
 F:	arch/*/include/asm/tlb.h
@@ -21223,6 +21261,7 @@ M:	Matthew Wilcox (Oracle) <willy@infradead.org>
 M:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Supported
 T:	git git://git.infradead.org/users/willy/pagecache.git
 F:	Documentation/filesystems/locking.rst
@@ -21251,6 +21290,7 @@ PAGE TABLE CHECK
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	Documentation/mm/page_table_check.rst
 F:	include/linux/page_table_check.h
@@ -21939,6 +21979,7 @@ M:	Dennis Zhou <dennis@kernel.org>
 M:	Tejun Heo <tj@kernel.org>
 M:	Christoph Lameter <cl@gentwo.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dennis/percpu.git
 F:	arch/*/include/asm/percpu.h
@@ -25667,6 +25708,7 @@ R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
 R:	Muchun Song <muchun.song@linux.dev>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	Documentation/admin-guide/mm/shrinker_debugfs.rst
 F:	include/linux/list_lru.h
@@ -29936,6 +29978,7 @@ VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Uladzislau Rezki <urezki@gmail.com>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
@@ -30479,6 +30522,7 @@ XARRAY
 M:	Matthew Wilcox <willy@infradead.org>
 L:	linux-fsdevel@vger.kernel.org
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Supported
 F:	Documentation/core-api/idr.rst
 F:	Documentation/core-api/xarray.rst
@@ -30979,6 +31023,7 @@ ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
 M:	Minchan Kim <minchan@kernel.org>
 M:	Sergey Senozhatsky <senozhatsky@chromium.org>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	Documentation/mm/zsmalloc.rst
 F:	include/linux/zsmalloc.h
@@ -31004,6 +31049,7 @@ M:	Yosry Ahmed <yosry@kernel.org>
 M:	Nhat Pham <nphamcs@gmail.com>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
+C:	irc://irc.oftc.net/mm
 S:	Maintained
 F:	Documentation/admin-guide/mm/zswap.rst
 F:	include/linux/zswap.h
-- 
2.53.0


