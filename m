Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2894ECA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 10:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70E5B8E00C4; Tue, 26 Aug 2025 06:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6848E00A8; Tue, 26 Aug 2025 06:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623188E00C4; Tue, 26 Aug 2025 06:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6D08E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:18:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F03CDB9B60
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:18:58 +0000 (UTC)
X-FDA: 83818510356.28.6C1A89C
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4A0CDC0009
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:18:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756203537; a=rsa-sha256;
	cv=none;
	b=mzpyfkwnwddXFCy0D00uL2Dsv8WrZE1skTBDUb6rFmMkCwllvVdl2FSlolb8SW/wUxxbMx
	/ohfofkFC3KNSVCirMhbihJ7DSRAWRPPw1FokWOl3ZGutCHmNx64dbr+urR/08fMaBXm0S
	kEyU4C3FFSy0iJqzdyD5EEjQ3+Q8aCI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756203537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=jHtVNmi4jYoIfEjED4MEh6K/B3zOoazcA9BCPAPcABc=;
	b=FVBLe5WyD7K82fO/vNjX5ARfDTkZDWLgD9hoP3RZTkq3zPm3cDasJTZA0VL+UpcjjygaCP
	ASa/0AonKnAjze4U+2CjlKhMw95EHQejGWZlMmGnO/CyFtI1kZGTxxQlHWZ1QcSZBvaseF
	gL+phjPLbPtNnu1IXJ2kNEvwz95BHHM=
From: lirongqing <lirongqing@baidu.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <giorgitchankvetadze1997@gmail.com>
CC: Li RongQing <lirongqing@baidu.com>, Wenjie Xu <xuwenjie04@baidu.com>
Subject: [PATCH] mm/hugetlb: two-phase hugepage allocation when reservation is high
Date: Tue, 26 Aug 2025 18:18:40 +0800
Message-ID: <20250826101840.3954-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.127.73.8]
X-ClientProxiedBy: bjhj-exc4.internal.baidu.com (172.31.3.14) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A0CDC0009
X-Stat-Signature: eh6uxzh6ndxd9648nqcprzhbm4oyo935
X-Rspam-User: 
X-HE-Tag: 1756203535-415131
X-HE-Meta: U2FsdGVkX18ZRy5aR1wOLFzd6jetY2BE7K7tBQLVY0IsI1XVqbAPIWAE9NgQ1IngJK1+/IbmsvV7SBN1zZobYXuv7Q8nKUna9dUcQ8AEnJv0m0foGUU0jcHktVXPwtpZVc3VZRG+IrJOY03yA6kaxk9SkkrOnKCiUg/Q9Wf2f9ldas13guduijVSR830Ga2ca5ekYe/zxTok5X7nOlfKprzBrJrmmH/Yhq2E3rhVpOABaCMkA/DD1mDvdbuq27BCtdV42ffsQpFxjOdsOnC69xtyI87DuSDKNuDxa/RmL3iTSm6D1bbgabggfD1OYmqFm8TxGvlcqs7iESTOuDYtIjMguGmPExjVmIRhTDddT6wuYq660svQgZ7zzYmIY18xnXWe6RxT1OwlpC7ZJ7Nr3ONcGzlkw8a6ry3Nz/hflPi6h3In5LDWRN4N5Q/ueXnymvIgjLUG3el32uiDAQ7K+umAlKgn7w2BAskvOVhrPaw/swmqdmU1rjwyhXm0J1hK61oqM760Yd+mh9ENXy1dhrCV0lci9h8v36141CVQKEsbNImg0MEWsX1LkG4i9ZgRR2IoOllX8kH8Owh9kFLWiF/Asa2NXdnNCv+oFIkq70x5zHopeAdrQTV9qIINSywqWs9cdOF8eTVNG47wBdTNNrZbAXaPXJbE1ydU9By6bO2FFJz1YotA5zhEQBinHAXQYSlXcsj7jzdEZ6kjjMAkVIpfrd9Nx6LLlOecHrUhtII2aYduJChFIEC0SfdwYmsnsf4bcHlF//IkNJB+BfzqXWED/C/GNuO5tAzau+0SXf7QA7uiAmC12rFZyTotizOs5qRhSc8eZk2tMUJTToEW2cjWZAux/0kSj3ykOsKOdG6lIUNzUPyZXsyBdMC6Qnqe6Jd54tZc5sc58ZkELh2RfFj3dlSNH4QNjxHARePZVIcBRyqnEO2DzTwdYG7PXcww9n0LfwFdKLCyokeldXP
 BvFTHS81
 5FLabJm7Px1sw5mNLijhJeZ+hTf2UdpaA48kK8+wfG8jpmY6R9AU2W3GIiR05un96zZHKd9QmPOgvvVc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

When the total reserved hugepages account for 95% or more of system RAM
(common in cloud computing on physical servers), allocating them all in one
go can lead to OOM or fail to allocate huge page during early boot.

The commit 91f386bf0772 ("hugetlb: batch freeing of vmemmap pages") can
worsen peak memory pressure under these conditions by deferring page frees,
exacerbating allocation failures. To prevent this, split the allocation
into two equal batches whenever
	huge_reserved_pages >= totalram_pages() * 90 / 100.

This change does not alter the number of padata worker threads per batch;
it merely introduces a second round of padata_do_multithreaded(). The added
overhead of restarting the worker threads is minimal.

The result on a 256G memory machine as below:
Before:
[    4.350400] HugeTLB: allocation took 706ms with hugepage_allocation_threads=32
[    4.351577] HugeTLB: allocating 128512 of page size 2.00 MiB failed.  Only allocated 128074 hugepages.
[    4.355608] HugeTLB: registered 2.00 MiB page size, pre-allocated 128074 pages
After:
[    3.561088] HugeTLB: two-phase hugepage allocation is used
[    4.280300] HugeTLB: allocation took 712ms with hugepage_allocation_threads=32
[    4.281054] HugeTLB: registered 2.00 MiB page size, pre-allocated 128512 pages

Fixes: 91f386bf0772 ("hugetlb: batch freeing of vmemmap pages")

Co-developed-by: Wenjie Xu <xuwenjie04@baidu.com>
Signed-off-by: Wenjie Xu <xuwenjie04@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
Diff with v1: add log if two-phase hugepage allocation is triggered
              add the knod to control split ratio

 Documentation/admin-guide/mm/hugetlbpage.rst | 12 +++++++++
 mm/hugetlb.c                                 | 39 ++++++++++++++++++++++++++--
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation/admin-guide/mm/hugetlbpage.rst
index 67a9419..5cfb6e3 100644
--- a/Documentation/admin-guide/mm/hugetlbpage.rst
+++ b/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -156,6 +156,18 @@ hugepage_alloc_threads
 		hugepage_alloc_threads=8
 
 	Note that this parameter only applies to non-gigantic huge pages.
+
+hugepage_split_ratio
+    Controls the threshold for two-phase hugepage allocation.
+    When the total number of reserved hugepages (huge_reserved_pages) exceeds
+    (totalram_pages * hugepage_split_ratio / 100), the hugepage allocation process
+    during boot is split into two batches.
+
+    Default value is 90, meaning the two-phase allocation is triggered when
+    reserved hugepages exceed 90% of total system RAM.
+    The value can be adjusted via the kernel command line parameter
+    "hugepage_split_ratio=". Valid range is 1 to 99.
+
 default_hugepagesz
 	Specify the default huge page size.  This parameter can
 	only be specified once on the command line.  default_hugepagesz can
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b..576f402 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -88,6 +88,7 @@ static bool __initdata parsed_valid_hugepagesz = true;
 static bool __initdata parsed_default_hugepagesz;
 static unsigned int default_hugepages_in_node[MAX_NUMNODES] __initdata;
 static unsigned long hugepage_allocation_threads __initdata;
+static int hugepage_split_ratio __initdata = 90;
 
 static char hstate_cmdline_buf[COMMAND_LINE_SIZE] __initdata;
 static int hstate_cmdline_index __initdata;
@@ -3587,12 +3588,24 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
 		.numa_aware	= true
 	};
 
+	unsigned long huge_reserved_pages = h->max_huge_pages << h->order;
+	unsigned long huge_pages, remaining, total_pages;
 	unsigned long jiffies_start;
 	unsigned long jiffies_end;
 
+	total_pages = totalram_pages() * hugepage_split_ratio / 100;
+	if (huge_reserved_pages > total_pages) {
+		huge_pages =  h->max_huge_pages * hugepage_split_ratio / 100;
+		remaining = h->max_huge_pages - huge_pages;
+		pr_info("HugeTLB: two-phase hugepage allocation is used\n");
+	} else {
+		huge_pages =  h->max_huge_pages;
+		remaining = 0;
+	}
+
 	job.thread_fn	= hugetlb_pages_alloc_boot_node;
 	job.start	= 0;
-	job.size	= h->max_huge_pages;
+	job.size	= huge_pages;
 
 	/*
 	 * job.max_threads is 25% of the available cpu threads by default.
@@ -3616,10 +3629,16 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
 	}
 
 	job.max_threads	= hugepage_allocation_threads;
-	job.min_chunk	= h->max_huge_pages / hugepage_allocation_threads;
+	job.min_chunk	= huge_pages / hugepage_allocation_threads;
 
 	jiffies_start = jiffies;
 	padata_do_multithreaded(&job);
+	if (remaining) {
+		job.start   = huge_pages;
+		job.size    = remaining;
+		job.min_chunk   = remaining / hugepage_allocation_threads;
+		padata_do_multithreaded(&job);
+	}
 	jiffies_end = jiffies;
 
 	pr_info("HugeTLB: allocation took %dms with hugepage_allocation_threads=%ld\n",
@@ -5061,6 +5080,22 @@ static int __init hugepage_alloc_threads_setup(char *s)
 }
 __setup("hugepage_alloc_threads=", hugepage_alloc_threads_setup);
 
+static int __init hugepage_split_ratio_setup(char *s)
+{
+	int ratio;
+
+	if (kstrtoint(s, 0, &ratio) != 0)
+		return 1;
+
+	if (ratio > 99 || ratio < 0)
+		return 1;
+
+	hugepage_split_ratio = ratio;
+
+	return 1;
+}
+__setup("hugepage_split_ratio=", hugepage_split_ratio_setup);
+
 static unsigned int allowed_mems_nr(struct hstate *h)
 {
 	int node;
-- 
2.9.4


