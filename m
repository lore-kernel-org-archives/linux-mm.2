Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F2E1CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890C98E001A; Mon,  1 Sep 2025 04:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840778E0014; Mon,  1 Sep 2025 04:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756F08E001A; Mon,  1 Sep 2025 04:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E66B8E0014
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:21:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01C7E11A18D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:21:07 +0000 (UTC)
X-FDA: 83839986216.02.E596EE4
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0CDAC160012
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:21:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf08.hostedemail.com: domain of lirongqing@baidu.com designates 111.206.215.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756714866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=3ZMDLAHIEP3phT5r/rTd+vCBfZgv58EebSfqWadqOyM=;
	b=Uv/dn3KlManvnTuV7P4L+8SRUMAm7s5VQjyLzFL+FdSj6aEI/cW+DT5wNzMZ8ojDXeDa7+
	7X75uOfZ/L3vMINFDypjQ2LQLacZvnrzKKyy2urx7RuMU/F9rDIHH9CiIY7WBQ6DqYIR4z
	BWk8UAWwSPuHzie69jne2U4cKcuqiEU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756714866; a=rsa-sha256;
	cv=none;
	b=r5CH4y8Uu4e1aM8OP+vgfLP8UH/VXS2Nx62MPX8ghybFgcfh5/0/CSB00KPWn1Ny2eHnsZ
	vzJiCpFpwaY7WtMC/KxxHKLVMo3nLKg71/T2YJCkSKBM/NAiU6CLj3k3o/OPo08fL+Wotu
	9/uPbILSgi+7FbOWujtwg2Ggw/b6IBw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf08.hostedemail.com: domain of lirongqing@baidu.com designates 111.206.215.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com
From: lirongqing <lirongqing@baidu.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <giorgitchankvetadze1997@gmail.com>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH][v4] mm/hugetlb: retry to allocate for early boot hugepage allocation
Date: Mon, 1 Sep 2025 16:20:52 +0800
Message-ID: <20250901082052.3247-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.127.73.8]
X-ClientProxiedBy: bjkjy-exc4.internal.baidu.com (172.31.50.48) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0CDAC160012
X-Stat-Signature: 7z1xbmixyz4cwtbuxz9eqyx31hyskggd
X-HE-Tag: 1756714864-493912
X-HE-Meta: U2FsdGVkX1+zeR5BzEGTXovMUxi/rPZDagsOlKjTQa4RNiaJotV0yWxJ2C9YwXioDWZT+GUjeigoNRdTPbdEiatG2lU+mVFobr3dtGw/XIJF4duZZdC/OYJ10KjAWMEmyCYmWEFzrj5a59PP3brw53SHz6fDaxadWnYbAilri0329SUOC/KOTs78G60tZ//V6iuiNCJNe/Ssz56gZm8ZPymXejumm4d8q2pEsw7S6rt/fhJGkcYTWRBUCLpTeby3yahtxyya5NYg2OaoGVLAlTdVQIb5azkvlECUWX63/iLlmp9bR1PNNpm3i86t5KvbK/9N3p2I1VsLx7h5WXQWvUSJn37mpmR5gWdpPkJtF2U9K30WtfH2Iq65wA+PdYF69fV29TryHHUKFXMiUlj765IhFHyIk1vue50nTADHirB5jb/nGwUnNAVCj260Jk+tEAsgmNNxC7AWDLjiZusBJeL68DkQ6Qn8rC/WuI5rqGquLoHJILDpAioT3iLT35kDHXo6aXH779vxNPxkOtUH4YCcMiIEj/U7fJHB+ezuVpLLJdQLo1kAVUBwOhlGA3w3kXjr9gD/+ZOm260LdexnHhvWvMorP5gDMsQCZnUyiGIedtly3H2KSgZOSwgK1QDNSrH2UvBH2rUfx6Cyo5oTQnVZJC7NGah1sPyTX/ISdJ0CnWAXha1kD4ydpVy75t5eBp7BGW2et4dB87WWvT1kETWtVYZhZ7Pd7el33UahgH3EasXoSAKR9+kUbf3Lc1uxcBso4YypRn18VDfkoC/t/yrlOyczHczpcU3TMxBnQHwz6gTCN3Wok2Numcco5/2hzddBkHdNSb+X/AMBcq3MyOU0rRGTxNhMi2m9Nds4OshJsjyOydytFHe+ztsCor4hI9nsi8uAqRfS/RCFh83GVeBlkkvcDAuP3s4J5WMpjXc3C3sNV3POsGd/bevrlnEt3C1uqQxLDJOTGZclHYa
 J7aSY8m8
 76V04Wkq9faC+LNALqLp3gGwjho/fLBBj12XUhJH8UIUBywZ2vQuag6IYScCAXzx/y+C9MY/pBjcgeHR9AvtRiibI+ljSunHhqlmms0T1lrHQIyK7Nvn1GQWyhleNCZaIO8kb7wet//LmS+8gW73joDfUtGkc+WPxRWpD5JPl+Z1k9Gs=
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
 Diff with v3: rewrite comment
 Diff with v2: auto retry mechanism
 Diff with v1: add log if two-phase hugepage allocation is triggered
 		add the knod to control split ratio


 mm/hugetlb.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b..af7c36f 100644
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
@@ -3616,10 +3615,29 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
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
+		 * Retry only if the vmemmap optimization might have been able to free
+		 * some memory back to the system.
+		 */
+		if (!hugetlb_vmemmap_optimizable(h))
+			break;
+
+		/* Continue if progress was made in last iteration */
+	} while (remaining != (h->max_huge_pages - h->nr_huge_pages));
+
 	jiffies_end = jiffies;
 
 	pr_info("HugeTLB: allocation took %dms with hugepage_allocation_threads=%ld\n",
-- 
2.9.4


