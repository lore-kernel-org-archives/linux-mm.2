Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC53AD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA7E6B00A9; Mon,  1 Dec 2025 12:49:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552B96B00AB; Mon,  1 Dec 2025 12:49:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E5B6B00AC; Mon,  1 Dec 2025 12:49:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1322A6B00A9
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:49:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52D81131C2A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:49:36 +0000 (UTC)
X-FDA: 84171639552.02.9FA44C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4E64C40008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:49:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DBvJyL4R;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3dqpImZxAWv82rLZkP0y3q2yDoqy7qLJPCZxEhpa80=;
	b=1YvN38KnMj7i3TNnYqOs5PA4oADUjQOiNhdlQhbnlcO25Bn95BiJ+sG9iorUPeCRWsSPm2
	HNbsgSejrwxk4C2LvdR0FsBRsIJlomy6k2CmWoH79sgSxZ/vrMR4MjM52kbVx2WMbMgstg
	tHonzxuhbuAf7cik8BNcLxMX1Uuc5vQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DBvJyL4R;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611374; a=rsa-sha256;
	cv=none;
	b=c4Eh8LJsJEGJnXfe1+rByaYdEmaDxc21fiyToq1IkHUbxeASXbI2hxBSxFZNC/GuiX6kKU
	srKw7euqkfM38R/uOhPvjDxZm1K0z9hr0f6OzXw2IRKZx8pyehpjcF/oE2dE59KRVuLSzx
	q51y3r2H+nW3DLpL7X0MZwt+h6N101M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d3dqpImZxAWv82rLZkP0y3q2yDoqy7qLJPCZxEhpa80=;
	b=DBvJyL4RZJeKIOudDa6+Rzt2trdPwiD5AS1jBL3rP7eejosdJQyP5mkoo1btQkZF4F0MWV
	a7UUb1l5oM7zLxfH9RFS9Ow+MjSS0IzaZpR8Ip+LqStFpVLrg8DKs0KR7pO2zvxTE34TCl
	EpT2aeVnVKwey1L4C5zN+7lil+IlszU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-217-0WCje9dVNWyF84IMg-_8nA-1; Mon,
 01 Dec 2025 12:49:20 -0500
X-MC-Unique: 0WCje9dVNWyF84IMg-_8nA-1
X-Mimecast-MFC-AGG-ID: 0WCje9dVNWyF84IMg-_8nA_1764611354
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 704F218001FE;
	Mon,  1 Dec 2025 17:49:14 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3C0CD1800361;
	Mon,  1 Dec 2025 17:49:05 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kas@kernel.org,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v13 mm-new 11/16] khugepaged: improve tracepoints for mTHP orders
Date: Mon,  1 Dec 2025 10:46:22 -0700
Message-ID: <20251201174627.23295-12-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 4E64C40008
X-Rspamd-Server: rspam02
X-Stat-Signature: 7r5wmef19ijb576irifr3fo88ip3876m
X-Rspam-User: 
X-HE-Tag: 1764611374-651763
X-HE-Meta: U2FsdGVkX1+nClJyeu0Jirn5PW0YOvalwUA4/fMnMpsrGF9ca99yxoZxxqCNbN3RH3i4ApaDE6c1UjMftUb9AL373wZJ9nG5Lj6G6T1sLFogOVxNXxIRPfcE+BvElKyOSRxTFQ0m9lEpohCnGR3GifdZy+iCQJcWhFbheIL4XEgnONSUh++3EnQW4Dfs56Rh5NUEHuj/WqxPrstYDGsT5o3u3MWaX64qux/B5fYv894/lq2PnPIoR/ZetjMJkI7Mu8UI/uyTeIKHsUJr5fpkqduDjmXanNEW3t9DUSsUYb/mK2Y+64IvkW3PowrcNISqfzPAf2JguQV6i0eKJk5aZGCTK8v5SbDyKsgUUTB3glIFrILeT2LxU+yLB75iBB95Bk1K2NgnxqWYTUg1ZthWWVtvqrJuo66MTqR4mmek5fPZvgClGlpkEDYL+GIiWCVRKUx9myk5Jzs6mDqHSvdAVbYlDVu1CpVAEQkkMSFSvjuJYkqBy3EZV6IZ8DV+8IVnox5zZWidNmhd/3EZnzBugLiAN0w2jehkWmf3GFexKtLL3uYA9zRHGLTs5k114jzeX1iPG/Ds1yxbxUVW6PYNJFMNg1sH7mJf4hJVO3G5PlybahWXOsinSLwdkui6Sia2rqqBvNQOL3BWWSaI1FifpwdFU55wYZr6mlDSnwKOHuNVfAaf3eurkSJFUUYjU8EcuTRRHRYjl6jZ6M32ev+rOl5jj9L2ZivTM2OG8vvFqWJZJ2zUAmZczbUDHgSM63+v7w4QF7jPGiO716uOeGHHCHqbAjtXUb6XBR4duEwdAyUI4PPNmcwv055/tPoI5qAaUzk6eFgZ3OE7XO1zsxu+rhrKVyf8CzAulcOpRUpVgnsosPcDDSnbYhBtdAdwSx0JI6bIOYnYvrd2QZVpfnRQ8sAXAgkR3tfrwcCWFeCY3h2S1fCCO+Pgey46wNFcnas45MuyTPax2lEwYnsUvyJ
 WzYj8Gxz
 2cvVFYZxGrRDwK3VDMxITA1iW1StQ9slLKctI0SdJQg1MySImisRu/hBrJ2DI2UVZUZ3XJ0m0Wv62/HDOOiyirS6x3buBk8FjaAJHKKCuzE32PCboQx44x0ERFhHejQrk5SMinJQWkyZOS2ExlhxKkj1hVqub8BfYDMMS6SW9Zyb8oyVFljHm5RYXsg3tucKRxG4G0rebgTQ7W93kS9s9LqCcAkUKF+YTRNhGpQcmCUc5JXM41++nF67kCJN60lwAxTso6TOAAZtkRqOlz+UhWSLkXa2Qbe1+WoV/DCPcXA0tx82UdRbRB7FvnAuJhk8gzR9wWzzYa0OHMQmVz6Kg8I+0Y8qGRhtVnAwBRCjQQn71qwENbhNOm7VDwW5Eoltv7MBoRDUWfhmDxsLSNy0fviPyHMqEqQf5SZUYxppR2FrBBTq3C6/sKoJogLoVju05Tkq5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the order to the mm_collapse_huge_page<_swapin,_isolate> tracepoints to
give better insight into what order is being operated at for.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/trace/events/huge_memory.h | 34 +++++++++++++++++++-----------
 mm/khugepaged.c                    |  9 ++++----
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 4cde53b45a85..0b8c26035aea 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -87,40 +87,44 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
 TRACE_EVENT(mm_collapse_huge_page,
 
-	TP_PROTO(struct mm_struct *mm, int isolated, int status),
+	TP_PROTO(struct mm_struct *mm, int isolated, int status, unsigned int order),
 
-	TP_ARGS(mm, isolated, status),
+	TP_ARGS(mm, isolated, status, order),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(int, isolated)
 		__field(int, status)
+		__field(unsigned int, order)
 	),
 
 	TP_fast_assign(
 		__entry->mm = mm;
 		__entry->isolated = isolated;
 		__entry->status = status;
+		__entry->order = order;
 	),
 
-	TP_printk("mm=%p, isolated=%d, status=%s",
+	TP_printk("mm=%p, isolated=%d, status=%s order=%u",
 		__entry->mm,
 		__entry->isolated,
-		__print_symbolic(__entry->status, SCAN_STATUS))
+		__print_symbolic(__entry->status, SCAN_STATUS),
+		__entry->order)
 );
 
 TRACE_EVENT(mm_collapse_huge_page_isolate,
 
 	TP_PROTO(struct folio *folio, int none_or_zero,
-		 int referenced, int status),
+		 int referenced, int status, unsigned int order),
 
-	TP_ARGS(folio, none_or_zero, referenced, status),
+	TP_ARGS(folio, none_or_zero, referenced, status, order),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, pfn)
 		__field(int, none_or_zero)
 		__field(int, referenced)
 		__field(int, status)
+		__field(unsigned int, order)
 	),
 
 	TP_fast_assign(
@@ -128,26 +132,30 @@ TRACE_EVENT(mm_collapse_huge_page_isolate,
 		__entry->none_or_zero = none_or_zero;
 		__entry->referenced = referenced;
 		__entry->status = status;
+		__entry->order = order;
 	),
 
-	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, status=%s",
+	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, status=%s order=%u",
 		__entry->pfn,
 		__entry->none_or_zero,
 		__entry->referenced,
-		__print_symbolic(__entry->status, SCAN_STATUS))
+		__print_symbolic(__entry->status, SCAN_STATUS),
+		__entry->order)
 );
 
 TRACE_EVENT(mm_collapse_huge_page_swapin,
 
-	TP_PROTO(struct mm_struct *mm, int swapped_in, int referenced, int ret),
+	TP_PROTO(struct mm_struct *mm, int swapped_in, int referenced, int ret,
+		 unsigned int order),
 
-	TP_ARGS(mm, swapped_in, referenced, ret),
+	TP_ARGS(mm, swapped_in, referenced, ret, order),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(int, swapped_in)
 		__field(int, referenced)
 		__field(int, ret)
+		__field(unsigned int, order)
 	),
 
 	TP_fast_assign(
@@ -155,13 +163,15 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
 		__entry->swapped_in = swapped_in;
 		__entry->referenced = referenced;
 		__entry->ret = ret;
+		__entry->order = order;
 	),
 
-	TP_printk("mm=%p, swapped_in=%d, referenced=%d, ret=%d",
+	TP_printk("mm=%p, swapped_in=%d, referenced=%d, ret=%d, order=%u",
 		__entry->mm,
 		__entry->swapped_in,
 		__entry->referenced,
-		__entry->ret)
+		__entry->ret,
+		__entry->order)
 );
 
 TRACE_EVENT(mm_khugepaged_scan_file,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index efb8a47af65a..049da0305440 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -734,13 +734,13 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	} else {
 		result = SCAN_SUCCEED;
 		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
-						    referenced, result);
+						    referenced, result, order);
 		return result;
 	}
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
 	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
-					    referenced, result);
+					    referenced, result, order);
 	return result;
 }
 
@@ -1136,7 +1136,8 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 
 	result = SCAN_SUCCEED;
 out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
+					   order);
 	return result;
 }
 
@@ -1360,7 +1361,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
 	WARN_ON_ONCE(*mmap_locked);
 	if (folio)
 		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
+	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
 	return result;
 }
 
-- 
2.51.1


