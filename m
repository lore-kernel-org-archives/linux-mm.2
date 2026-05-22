Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5353CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499EC6B00B3; Fri, 22 May 2026 11:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470116B00B5; Fri, 22 May 2026 11:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387056B00B6; Fri, 22 May 2026 11:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 261326B00B3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:02:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7A711A0A8F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:02:58 +0000 (UTC)
X-FDA: 84795373236.20.81E62B8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id C2F7518000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:02:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="UZo/qb/y";
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5uJd7Vm+0Ig6lxKq2F3frPNIhbJuk4ku4jIdDu1JcM=;
	b=MObYknn8lA5rK8kHxctdAIUcBBTH8ZM0nlLgkT1Rc8sSyTyvSovQ+jCk2IWmKJBhfC6lF0
	Fk3YRpwMoX2ozUIb18TPXFTM5ZvqfU5zgUglszfRGnP3M2AIldW8VXctPKb5HVLAeMspAv
	BPebzfmWkhmQeqUoMxUbSe70mOcsl6Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="UZo/qb/y";
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462176; a=rsa-sha256;
	cv=none;
	b=hKzEXmgWNHw/tWKtf/vgBpjNUlMza7URW5IIWBMnBTMr+gJJhDkKAWN/nuAFWurzJ2/1G5
	66Tm92JI7/SXfLvT/RsoOJJNZs3i2hvdBYH3TA5tobzSa0qDLyuG4/mnFJinG0vsU4zEWb
	+8FGSeEzH+McS+pnx5T46nYgLHhu66g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5uJd7Vm+0Ig6lxKq2F3frPNIhbJuk4ku4jIdDu1JcM=;
	b=UZo/qb/ybdbV7Y4A2wzMDAx0YGczHFXDbIN5F7cFH+mc8QalJE2Bp74QeIx1cyHilyUdsS
	ztY5UQr/XSpinqPfjWRZGT71RR5WiP0x2MA9uvCe7XrCuNQHRYjWWChH0ULY3pT6Fg9Hfa
	qyamBmznGf4w8PSKMlg1aUP0Yapg764=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-99-D3qUQhG2OrKwIriyaZ6IOg-1; Fri,
 22 May 2026 11:02:53 -0400
X-MC-Unique: D3qUQhG2OrKwIriyaZ6IOg-1
X-Mimecast-MFC-AGG-ID: D3qUQhG2OrKwIriyaZ6IOg_1779462168
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA9D41956055;
	Fri, 22 May 2026 15:02:47 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 994831800576;
	Fri, 22 May 2026 15:02:28 +0000 (UTC)
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
	liam@infradead.org,
	ljs@kernel.org,
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
Subject: [PATCH mm-unstable v18 09/14] mm/khugepaged: improve tracepoints for mTHP orders
Date: Fri, 22 May 2026 09:00:04 -0600
Message-ID: <20260522150009.121603-10-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jrwsXbH-CHzoplbpvuox8HyCqgyG7DrKjElvh28Znmw_1779462168
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C2F7518000B
X-Stat-Signature: pc9jk8i8zfz4gd5u8pp9we4aafo3f7d5
X-HE-Tag: 1779462176-85705
X-HE-Meta: U2FsdGVkX1+m/QPimGZt1/Fg/MMN5YYoL4Ra4m+6qvlL62EPmOAuL0HtDeigG/H4maGr0iTl350nzPLSk4+Z3dcR4CJNJS/ojS72LEGi/VSpnSXJVpcfj6d5VZ2Y1N1J8sW2pEALFIjZMjeUZOM4YKyl5va1nhKhxgVEkppxFgis61I0WikunNZIb3cNFAHY6z0/O9KOxfwYNTWndJT8iMYi6+tGY3FkvnHFBhmoyUWqpsGlwgPqI4OQ/+HExM8rS7st0aEj5wrfIps+2csZqko8X0jDZZVOpZ+9P6V1/mREPMrrdrz32iop/wALd09vUBHrWrSbHqkUlcwaEOf36tu9T9rDT3R0/ea7adf89tINhvRkjyHk4cj2MkO5T/Z0W+SuWJViZ7bzUi8TeRJHZKolQWH9b//hmjovsnB9F7Mfw/Y0YVEDcopQOo/R/VEWICiaQQyOLPdUZuQaPzwWQFVfehUvW68oD6MCx0XdfEYGxK0wLhWreuvYdBu1Kpk+Rtwu2dMxJ+p2l71QMMIMKTop4yOBa2B6s278p7Vz/Ur7k0X+HnGmYZ/Xbg5GhMMKsbnOw6GFn/+DOdyCMWq+qCoZ4RyCKovrAsUIaHLP93UG+tHcal19hbB9VeravzXjWc0eBSxIolun4kxaqAFO0X3qc8hx5qP2u/XQ7tl3+r4DMhwLUHz9I4DE6IpNnW0sjDsRh9IAfpVqxZKigcmWoZxSCBOOUkKnkOafAbEkcUFa+YVnFRKZO1PqtiaaDLJqwhe2UFauSySJdYcsl8vZBUnYO04ws3Jv7wAA9QrLB993y2vCbC8xr+ktJbTNAo+xtprt7aPpKi2cvAUAEL/nK6Hv3JDXg14pgI809eP4vCmX0BFWMrgYZF/NeBgRQW3eGmDx1RPDAjk54yXHoAKeRv4UrUdeNLKU1DpxdO90XF4DShZrCrqG3UYo6b1uCdnv2gHjYWQPWIFYOYK0vo6
 v87u9WPX
 nwCqr+XoB0WWYm0UmbdKQpFzKAn6JZCpjRs77v+FPNziO4QlxxCQLX5Sh3odUaAIFZOTQoiXnh4XjGpaX/Aelww8eCBt0rT0AY7A/2kNeS6Kkp0aLis9EBYpy5A4ajOIubOm/7PxpzrLIzLjwKhC1MzZHjbhv9wcybXA5o20UKAi6SvvTer4bBCcSfBpMn+PvGPN4CUd25Y9h6sK6OUQNQlLrhUu9ALfPjTbeB5EIeaXCvfDWdEB6LzgL7Oh4k7fGKlQwioilReL0Ped2uwPSpatphX6LINnMiPeeMPOlDfTjq2hzQgEaqDt9Oe92VDPZunjLtSUpyzrdpzcttGdIzgt9w8bUzEpRa3aBZFWUnzUnQe911f+lD2Jpy2papr8DMuEyqyNZljERtl9f73qlXUbIKDHuc6w2TCDSSFYd2fWNKtrKCTMHv94jt2nEJiEmwvMy/7WFHrZB6tU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the order to the mm_collapse_huge_page<_swapin,_isolate> tracepoints to
give better insight into what order is being operated at for.

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/trace/events/huge_memory.h | 34 +++++++++++++++++++-----------
 mm/khugepaged.c                    |  9 ++++----
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index bcdc57eea270..291fae364c62 100644
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
+	TP_printk("mm=%p, isolated=%d, status=%s, order=%u",
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
+	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, status=%s, order=%u",
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
index fff6a8fbf1d4..4534025bc81d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -783,13 +783,13 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
 
@@ -1189,7 +1189,8 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 
 	result = SCAN_SUCCEED;
 out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
+					   order);
 	return result;
 }
 
@@ -1397,7 +1398,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 out_nolock:
 	if (folio)
 		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
+	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
 	return result;
 }
 
-- 
2.54.0


