Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21ED9FD4609
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8620B6B009B; Wed, 25 Feb 2026 22:25:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80EEC6B009D; Wed, 25 Feb 2026 22:25:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704606B009E; Wed, 25 Feb 2026 22:25:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7CB6B009B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:25:45 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBACAC280E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:25:44 +0000 (UTC)
X-FDA: 84485168208.06.7D19F4B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2DDA1C0002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:25:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hmMRacPL;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nk2XtUOV6PFnkTSuVWhr9ZIgPDglh2gCD7J5e05Jg4k=;
	b=cEZclCCeeeenY46jQvf8RTC2dVlQcFSVGSUzR3yEBL47KLCeplxRQFrDI7k+QI6qMAw8i4
	/J2qLwVEOvhm0OcqIFSzNLbD++iaZYRnwVZ0NOisezC6+sZmxwiDd9sXJlW4E1pR4bG9Y/
	J0MX9eCDjmYZfCeEzJ6xbpYlPfNBMJs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hmMRacPL;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076343; a=rsa-sha256;
	cv=none;
	b=BOnGtVQ/ZCDsvOxYCyTWXy3pqix26XkXh2A4GVCgabUjHn7C3gvShASB/Xfmmz7fYx2k6e
	md22rNVf3cKpZKRMKGvwnv5HgeFwN0eB8JSKAYkE2/lS+a5peCeMHQxaJmQFmaPaNcrn8c
	Wk4/eUfbnadi05Rtph/UVvi/y/EFkuQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772076342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nk2XtUOV6PFnkTSuVWhr9ZIgPDglh2gCD7J5e05Jg4k=;
	b=hmMRacPLXd95/MvcYL8/ryagvPjR3DejhbqyGEd/Dg4ONhilyc7z7MRCYpsyOamifr5hNx
	khVoatAvYwPZUjhJcb2lLcPgUeIbbYXHCuYcwTJT+wS3WfLiucCdghFrPsIvHq/Hr6Pa3l
	BGN3qjgzwQ6KBW4diPtY1ne62xihWW8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-UeypEm6VPoiJb6gsLjIwhA-1; Wed,
 25 Feb 2026 22:25:38 -0500
X-MC-Unique: UeypEm6VPoiJb6gsLjIwhA-1
X-Mimecast-MFC-AGG-ID: UeypEm6VPoiJb6gsLjIwhA_1772076333
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70089195605A;
	Thu, 26 Feb 2026 03:25:33 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AC0EF1800465;
	Thu, 26 Feb 2026 03:25:23 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: [PATCH mm-unstable v15 08/13] mm/khugepaged: improve tracepoints for mTHP orders
Date: Wed, 25 Feb 2026 20:25:22 -0700
Message-ID: <20260226032522.233735-1-npache@redhat.com>
In-Reply-To: <20260226031741.230674-1-npache@redhat.com>
References: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LH7lTGZzDlzvoDylwHB3MU4jjEDqd52KV_Um5AoLD8M_1772076333
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: ar6z9xn7jzwb19dod869thn8obugeiqk
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DDA1C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1772076342-72143
X-HE-Meta: U2FsdGVkX1+LdvFQc5fzP98EyJJSO4ti7o9i4I2xvtTVkMP1wwAiu3w2/sleYo/IGskvNb0NJAL8wXmr5UwLCByVz7DLPKwiccbrWWR3mgOOWYcoCkW+QdmyU/rB//ZKhfnLegVeYPBQX05FcmbXYbCpERKKeA5PTfihrw4m1mgCUYl1mT+oYDKWtwCF6itQYRwoHULSTMJOtcY4LJEZufm6Jai4ekb1pkkOFqigYKI854SaBnN5eZzj/1UfUpv74oAleK3McIfI/Iq/huNmDN7but2Qo5ixJZtNVA4+tVtNE2cney0jtC4aDQy9xy+Gf9+hJcfsstGnJYq+1WwGaH4BOMwXiC9A9zzsA44hdAyUrsN7H3ViF6H7konwMa86ywecJysBElMcpBFB+XIIgJ+FQUcDoibFG+l1xtSfdSb9hvHfKiY6FLD7GSkcqfd/PGKcX8e88lmQn7gJuQd5Je8wuZLCHhPvODHqr8Ot8a+/E/NaBrz71r/B8jQj/bTluhoMKi/gtDJmvRuenWyW2mN7+Ev40aDVDzrZirBqF5ESrmb6HNioDmpxMvvjJCI6WNqPu3OvjtO/iml4R4OO6AuntRrNop/zuMl7s6p0r6ELcaAIR7Mi2WU4hPyslvJkw7e9L2pXozYsIild1cdNwJkeA617QkVBlDhb6gaHk62vFMsCY9Qgd5FiCgi3kEazCENSDE4QrZv90XR5LKTcScLyPKQP6Sl47lOeabJr2erItQMk6ClU1oc3NFY+4X1w5tuJRGua5ldrA78Wr4EzDnKlXKgJr7DLewbnAyUkXGGqDCGk8t1HobnngDOOs59uCd2F+F7sPxyV8CK+hqeV3Jl6cCqCDSCDjMhRZ43SX//BIxpJh+7Sp6q9WAq0osjMqIdTv9sg/F4OxU20Bvs5/vhB8LWmLULBsxojf7v1g0GOaliq9nzy96T2ZcrjqzJz8m9tUpjy0iTOg2p+cxP
 nQdsA99m
 Gfjr/QQduXuGsIGFiKc6qMOt0p6M6rkSn7lE/cypmPdgn+Ghi8vm6M1AkvrsNLHChySfsNQr1u1PBnpoC07JbwtHIsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the order to the mm_collapse_huge_page<_swapin,_isolate> tracepoints to
give better insight into what order is being operated at for.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/trace/events/huge_memory.h | 34 +++++++++++++++++++-----------
 mm/khugepaged.c                    |  9 ++++----
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index bcdc57eea270..c79dbcd60bdf 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -89,40 +89,44 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
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
@@ -130,26 +134,30 @@ TRACE_EVENT(mm_collapse_huge_page_isolate,
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
@@ -157,13 +165,15 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
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
index a6cf90e09e4a..2e66d660ee8e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -731,13 +731,13 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
 
@@ -1131,7 +1131,8 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 
 	result = SCAN_SUCCEED;
 out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
+					   order);
 	return result;
 }
 
@@ -1346,7 +1347,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	WARN_ON_ONCE(*mmap_locked);
 	if (folio)
 		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
+	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
 	return result;
 }
 
-- 
2.53.0


