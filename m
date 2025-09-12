Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82938CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26408E000D; Thu, 11 Sep 2025 23:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFCFE8E0001; Thu, 11 Sep 2025 23:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13688E000D; Thu, 11 Sep 2025 23:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC6A68E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:31:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DBDAC067A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:22 +0000 (UTC)
X-FDA: 83879172804.23.232CE93
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id C2D61C0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=igcy3AXn;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpCf0X6KApE3Nxwemh/YTyo0WnmYkSshuYDdaCzSaMA=;
	b=gbRV3p1xMPgZERuXrsutGFJ0iAhSHyfE2Hvw6LfX/37Bq0NrxARL2bRe0DuAtHFi044UPW
	IAI8D0TGxBFujsO9kFBEQJemDddclSzRMEVUHqq2dNdwDx52H+kWhEi6uD0Ew5j2ohvn98
	OMQTEhk8GqPIoZcmV7EcZ0MSMInir1o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=igcy3AXn;
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647880; a=rsa-sha256;
	cv=none;
	b=n0EFSe/UmQh53c16EaQ2yxhYdV+NOYf4reXdp7dEY0FBSj4czXTitmfmb87dbZ8im5Ay5/
	NoNVERGCx6JXo1Tr1zY7JGDjlZa2AxCq+J3sNugYCi1d5ifbO9nfNBSz62YbRE9u40NYsr
	znn3DBjp6WoNBte3oqpfMhXf4qshZN8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZpCf0X6KApE3Nxwemh/YTyo0WnmYkSshuYDdaCzSaMA=;
	b=igcy3AXnUoeP72GxE/t+jEbcqP/5O6aRCgsv7gwtimieo4/5MmCL72COC6SiT9SwcWBFRi
	sXmtec1n/CxLp3yXNOQmwR0Y5X67mJmSva0UY6OABYk9qY5TFUZtl55DQD4Atyph848aco
	D2oQc+wVq8T9kSKdeqh8XVzYjBvIIFE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-C_W9vkk9M-mFjBmhEYVg1g-1; Thu,
 11 Sep 2025 23:31:16 -0400
X-MC-Unique: C_W9vkk9M-mFjBmhEYVg1g-1
X-Mimecast-MFC-AGG-ID: C_W9vkk9M-mFjBmhEYVg1g_1757647859
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 292711800452;
	Fri, 12 Sep 2025 03:30:59 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D9090180035E;
	Fri, 12 Sep 2025 03:30:49 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
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
Subject: [PATCH v11 10/15] khugepaged: improve tracepoints for mTHP orders
Date: Thu, 11 Sep 2025 21:28:05 -0600
Message-ID: <20250912032810.197475-11-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: C2D61C0006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4joimim1x6ugppfmi7gkf7xr4fhq8f1o
X-HE-Tag: 1757647880-980338
X-HE-Meta: U2FsdGVkX19+Ov+qIwPXltPUT0mZEghjamo/TgGcMQN3s5a+mV15VCTQF54XyUdROI1hSDQlhyZPlOliXfwiqN/v0Yv4hjnUqc89E92lx022/rCg4EFZk5Gdhf0OWuMRBlDWkeqQv0FQ8ZEEJ4gXDiallKbGNToPFdI3oQ+bKI6RUAltVvnfkLnQfgN614bGqOzTiGMB21g8wwMpSuhWiS9bDEBWIc0ONhma4gCeeOAuyq1l6m1pKU0m35UdsiRwMbR4rhL8N9hBRY0sjMbAQFUemjT0HIXbsAm6dpldKeu7j47qEeXpRHob2LXU3B3XYWPwLsNPRpDsNolGGcArqPNOiB5NMD1jBdvfG+mFfDQOsJ+l+lKv6crU6vzlXP8kHpP/3ZnA6YAU5Y5wozR7/FViN+47PHOK7ME2U3OUK9ec6m8FLg4Yne28wQ5F/L0QRtHQXrMBaLkepnmigqnH7EZ/qS43zibqYPwH3+2AkE+lKonazti1/03HztbqKZ2L8tVfs4gG9h6pGye2HpL90WUcWm3jJTK//8auapT/NeWWPO4LC/Fe6woUSai75kTV67taPon4KO5WceSGWhYIl7pnPciRjcZYuztsPaUMB7ssCOM2giv2Rq+CyEqa95oJYJStLvSfQGnXrxhZ4fZhvM45gPZ2sy/hvuKMIMA/wXkMdZ1dsuAFzCQBc44raIXNacxjBQqqT1fVsaiGeNi63LANQ5fTdcwjG0/x/EmbICFJj2qUMtJH0YsrFilOQT7bGXZx35oev5AVgUrarSuF7yAUpV/kpeODqt70Mi+yI9dbqq78l9jJpAR3lcctwyoQsTTlTGD3f1JibYd5SHXqdO+8JN4OsDLWPW7WXAExom0p4kY2OrCxSkR0dMUYc5kFMnEQVTSYeDpAFk02EJTk8KLqVz+zF/O29L87OouEp5XZiKFbhbPgEZhK8y2OXEZRmo3fxLmHS9mYsvqaYbD
 fg0BBIIB
 RviH69JLD2o+WXpdrZ3tgWSwqOQfvh7g7EYK5JscHeoUEQ3eUKcaOGbc2JGpYxNx1dyaky6D5+Zzuc/zDlK/zJHbg1b2/rVvoNJ1K+6aRWoZUonCrYvuIaAWlNAlJVt6KQrWizimLxkdshOP+d0MerKpz9U+1EDvb/rHYSMw0Rt7/rtwyJGOlrAnkYHGKwydb6ve2CpTUdKNSkSoc2qEPLRq9GYWn3RstOeTCi5cY/l006fBOKoez0coF6TbPX+yDOdzfgLdg6MC5dKCnT/DY3LpF1gaccryOejle9XKY6siH6VoHBcu8RSoIRZ/ZeYh0k7XarVkfBJ3jfaGUAFQOuk5sYBlUigQ8yJOLouY3pJ6ZGgoeVE8kw+WrYlX7/y1yDXZHADBzgwC8K2TYP7ufH1uVQHMDTk7K1H7X3qmhaIAOvbd7tylBhQ2A/ED0UiYtPftj
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
index dd94d14a2427..19d99b2549e6 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -88,40 +88,44 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
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
@@ -129,26 +133,30 @@ TRACE_EVENT(mm_collapse_huge_page_isolate,
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
@@ -156,13 +164,15 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
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
index 8abbe6e4317a..5b45ef575446 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -720,13 +720,13 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
 
@@ -1121,7 +1121,8 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 
 	result = SCAN_SUCCEED;
 out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
+					   order);
 	return result;
 }
 
@@ -1347,7 +1348,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long pmd_address,
 	*mmap_locked = false;
 	if (folio)
 		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
+	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
 	return result;
 }
 
-- 
2.51.0


