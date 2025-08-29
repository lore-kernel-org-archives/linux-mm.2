Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D09CA0FF7
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 09:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B8D6B007B; Fri, 29 Aug 2025 05:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C606B0088; Fri, 29 Aug 2025 05:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E944E6B0089; Fri, 29 Aug 2025 05:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D18496B007B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:53:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 80CBB1A062B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:53:09 +0000 (UTC)
X-FDA: 83829331698.11.43BBFE2
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf16.hostedemail.com (Postfix) with ESMTP id CB91C180006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:53:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756461188; a=rsa-sha256;
	cv=none;
	b=VPbIbP56P3/tGsOyDVTf7ljs5yS8WYdH9yrorRZeftnECtC6BulY5Hzgat0ab34PffnMcN
	8w1UwtR6j+fu1Qd/WqLQVRNLJ844OnEQ2fxaFZWBAsExv5Rl6YNE/sLDaK2Fp9SLFQSlhm
	r1S5V9t5mf18aL2bB/0FxCKh27HllFc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756461188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=wrA0N0mucu4ZRD/87m0A3WlRa5xF/jVwnY+tO4B/3cA=;
	b=PsCHWX5V8d2i0RWsBg+x4T827pN/mw2sYQvOmNKl2rLW3Zv0o17j/m+pOn3qMHDlRrurXX
	C2Q5Rrn2NcQswlLCVWe1+O628cTHnFBR7fCZJVO7ZrA16/sQ3rYBoPXb2fo9j7iUQDp0pd
	6DX3qxWlkMzI9ziYncjDCt9dF1PM9KA=
From: lirongqing <lirongqing@baidu.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <giorgitchankvetadze1997@gmail.com>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH][v3] mm/hugetlb: Retry to allocate for early boot hugepage allocation
Date: Fri, 29 Aug 2025 17:52:41 +0800
Message-ID: <20250829095241.2651-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.127.73.8]
X-ClientProxiedBy: bjkjy-exc11.internal.baidu.com (172.31.51.11) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CB91C180006
X-Stat-Signature: 8e55qusxcx9r3jt6tza7gt4nn8y4nb5s
X-Rspam-User: 
X-HE-Tag: 1756461186-595465
X-HE-Meta: U2FsdGVkX1/d47al4MtJAt2n6BOW99cZMuuK/s8p0dLrVoCAxyxaptY0Fe1yho7x2Bo7mqji3z5iW7vFhCSkcF9IEYzHQOQkfYiV1JAsx5D5PvuZT7rT1iSkQrWREXfGRuKu1N1anAOYG2e0nAoYm0rdkwNN2jlpxYkyT6vWRGkQ/zl9gKbOz9qzUy1/eXPV7NddSB4kvtpREbnD181wXE8Tj6a5GVfGamn8LaqCYAsluspC28qfIfeo0vY0iNvtENGhCEVtUGa4fNNPzkmhsXYHDkrE/5h7FVXMwl1w57mlz0gZmvNSIn0Hng9AvL8Jf8suTiD0MSeI4RtvZvbQSkVe7L5u4i7sw5iNgLQEWqrddUDozyf2RrFeRasIvzADYwODPgvOnl1ZY3Bf1B6Cv3Tw0Jls0BWbYJ10NHKRC67ez+kQIC0vJ0ZWXfbJyD4VuJfx5FSPkJU/Jp8JHcxtERgDkmHI/Yo34+xBD24kS+EnTt00TJ9eSeAw+hoQ5HaNLndlz3OTIMW8AjZZBBMeMSFV8edJuEPtVDssCQBIMw8cK5iRAkz/cbYIiVnYYOhcl/XA9KkVOObLmaVk8QaDPmPc4QQ/muMeKa+Wl0FVBEhMc4cT3fZqkNmyOS/+pVB5vTB7KTMief/wBe2eYS4BaoXSV3wzdJYJCrrFKIKVs8rBuF+04vbjfK8nThuK6ZWTHuxoLtyMcKcnsG+M4x6s6nzepCW/uMHpCz9g+cE1riEIm5AGjOU+WjiK64gqQdWCR7W3pTq+ap4GkrZobxMgYHgvulaM1Z8kXRuPV8fmBeu4h/UJbBx9JV+/VYhFhZx/6wDw0/9XdTjZJ5ACWguqhc8AUpfDlRnBXf3sNc0F07SGbWljMEuNVx5eOixRc17KOCLHDhh+FqeLO0FQxM7IUr3IywJplDwCqGKXbM+/desDaGCVWAOSgQnaLmuA3S/zhaC/1sA15q3hlXiitYK
 bZpt8+vV
 4JB2/rgec0thB+SdSD84hXh9JJstgHeC9yAsm1dhI8fO6hP9i37bfPr7EstISrcUq44VawQrMlhUiaBiCP8RSYVqkp0d4NeiJRFJS0WntTubSeAPbd3WDJsJxXtleom204Fh69QbNTsSYiYE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

In cloud environments with massive hugepage reservations (95%+ of system
RAM), single-attempt allocation during early boot often fails due to
memory pressure.

Commit 91f386bf0772 ("hugetlb: batch freeing of vmemmap pages") intensified
this by deferring page frees, increase peak memory usage during allocation.

Introduce a retry mechanism that leverages vmemmap optimization reclaim
(~1.6% memory) when available. Upon initial allocation failure, the system
retries until successful or no further progress is made, ensuring reliable
hugepage allocation while preserving batched vmemmap freeing benefits.

Testing on a 256G machine allocating 252G of hugepages:
Before: 128056/129024 hugepages allocated
After:  Successfully allocated all 129024 hugepages

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
Diff with v2: auto retry mechanism
Diff with v1: add log if two-phase hugepage allocation is triggered
		add the knod to control split ratio

 mm/hugetlb.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b..18e54ea 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3589,10 +3589,9 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
 
 	unsigned long jiffies_start;
 	unsigned long jiffies_end;
+	unsigned long remaining;
 
 	job.thread_fn	= hugetlb_pages_alloc_boot_node;
-	job.start	= 0;
-	job.size	= h->max_huge_pages;
 
 	/*
 	 * job.max_threads is 25% of the available cpu threads by default.
@@ -3616,10 +3615,30 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
 	}
 
 	job.max_threads	= hugepage_allocation_threads;
-	job.min_chunk	= h->max_huge_pages / hugepage_allocation_threads;
 
 	jiffies_start = jiffies;
-	padata_do_multithreaded(&job);
+	do {
+		remaining = h->max_huge_pages - h->nr_huge_pages;
+
+		job.start     = h->nr_huge_pages;
+		job.size      = remaining;
+		job.min_chunk = remaining / hugepage_allocation_threads;
+		padata_do_multithreaded(&job);
+
+		if (h->nr_huge_pages == h->max_huge_pages)
+			break;
+
+		/*
+		 * Retry allocation if vmemmap optimization is available, the
+		 * optimization frees ~1.6% of memory of hugepages, this reclaimed
+		 * memory enables additional hugepage allocations
+		 */
+		if (!hugetlb_vmemmap_optimizable(h))
+			break;
+
+	/* Continue if progress was made in last iteration */
+	} while (remaining != (h->max_huge_pages - h->nr_huge_pages));
+
 	jiffies_end = jiffies;
 
 	pr_info("HugeTLB: allocation took %dms with hugepage_allocation_threads=%ld\n",
-- 
2.9.4


