Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD5FEA7197
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 19:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98696B0345; Sun, 19 Apr 2026 15:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6FE46B0346; Sun, 19 Apr 2026 15:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86856B0347; Sun, 19 Apr 2026 15:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7A5A6B0345
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:01:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A276160823
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:01:11 +0000 (UTC)
X-FDA: 84676223142.16.1582EAC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6E8642000A
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:01:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BgpKO/7J";
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEs7awys4SM85pNXSkVo8hUKY9UhlhVsZXLsWffnxw4=;
	b=hP5dszejYIhD0v6r6Qswlm321AQ6+y685n0jGDz/8C0zSaZyJWb3ZIwPHAO5kVrjsPgFV1
	+qF8FvpIctm6RBw1Cshaovj5vOjgdIUMVDivKcGwWWhkutgyyvFGa05jfmoyPqfFM66wWL
	v5nwgDNa9Pt+jaSHWhyGQbu48QJBHso=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625269; a=rsa-sha256;
	cv=none;
	b=tMtFL0qwrVCZJNVeUSRtgWk5VF5KiO7mXrWkSmlTsgFIYjNe5qLlEXBICj7JxRGlcisN9Q
	ov0oTZdVgaFFa6/Pi6YpVOr5glzE093hCL/WPlEoZnw3ITLujUyxI/2qHPS/qkkHwSms6r
	4TKiHdPSMqHmcLdFEoLaiPcE3rFEmVc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BgpKO/7J";
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776625268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eEs7awys4SM85pNXSkVo8hUKY9UhlhVsZXLsWffnxw4=;
	b=BgpKO/7J17XEdChdZ26AoiwQbMDiVfs9gLamxnLZZrG3KUcgTFJIKv6QNPuQLRDuhTp1AW
	Dz4K98lU9i93GulpwCBb54xQn4pUA6tYdQlvyrK7ljs7YuESHp/Xaw7fQ069g6+rpUKJT8
	foVmaYvE3tfYpO8mnkortR62f2bH3rE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-417-MsFwoVOvO_qV49C7R9TG9g-1; Sun,
 19 Apr 2026 15:01:04 -0400
X-MC-Unique: MsFwoVOvO_qV49C7R9TG9g-1
X-Mimecast-MFC-AGG-ID: MsFwoVOvO_qV49C7R9TG9g_1776625258
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A72D3195608D;
	Sun, 19 Apr 2026 19:00:57 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 74D60195608E;
	Sun, 19 Apr 2026 19:00:42 +0000 (UTC)
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
Subject: [PATCH 7.2 v16 08/13] mm/khugepaged: improve tracepoints for mTHP orders
Date: Sun, 19 Apr 2026 12:57:45 -0600
Message-ID: <20260419185750.260784-9-npache@redhat.com>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CkcQMAazK-bLcK_HJcSU9OTeuS3oKck3I_0YH2ACV3g_1776625258
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 1m4m5ewm3o8ejzb8q6pe5cneyqzgctoh
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E8642000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1776625269-92704
X-HE-Meta: U2FsdGVkX1/RY5MshpkNyVo4KC0FPFZjCUdSKMdOo2rFhTdCGNS7m9z3c45M0+Kzz2YqOaZuFkUHepq9ev177C53zkJ+xpKPgpdZLWeGky7Frkdx3Nl6NRwgZK6r5+9DxqZDqNZKo7ryhi0JaTTo1asaYU+5/ll/OZozkj0WYmLX/ieaenPtrqCCDX8EY0wJkgLY0sBE2AwWIx77c/OgrJ4JmM5NSDr3Eoj8JezEg0GrSPUn8gUoUhcxzKEWTkrQYvZ0S9FR30zj7upOCjHvEhsUHAD0piF/Ib/kZqtDAJwuJGtQW+tBZV2VXGQ0Yorv7cLTacLXCuVGS5msxQd7Pu5KdTEW+JJCXgvxg4mBXIF3p52NECzpkhrHYgsvA6RqQbxdPpvJNVICvLh9zBG1+s1j3ZeA+zNVb2McbUrkA5Xxi5VmE/doc5eeE3lDjv3eypAoLpzA6cxM/IICOZ131xnN79GX0JOckjyhVLMSBY58RcmlujFFUz4IQeskypTR7oFud/Ta58x8BOmYGQH3Qe6DhMqka/TvL7N6Apkpmm1FTmAXOd9naRF3Vcaq2oqdmERDGI/T9UR1UfNqGKSjcoPiC4Dhy3bgfSBcJf9v0Ax67VbkYS7qV9Zxrnx38YtJXHa7gWYBDNiZNnW47aqiqDOTBMR8Eg0siIR5mb+hQQ3YC08SdnFkKIAwU6ZboAcL4nQOE5ghKMJkjv3L866uzTsJIXKTFBP0BDQ3peQh8rxVvKR17wshwJZIlBAzTUV/dCeORGRaWavCXep7jWLJO14PauctKRY+U2aSHPjMK1BLCWHUfdeMWlkxDcP96cdOz1WKPgsbUXhFLhpTCNYu1hOOUOkQeqpznN90ZEkumCGodEU1RM42iJpFfZJCEzarrhxF/8sSZnkqWH67Q/LKCIcTLjFOz+vrUpjfchMVZmikkoZTPnVUc29pb4XrmT8nJYlFuifZnfkui+xmMHr
 HDM9rHm5
 /Q7ApJhXT4I5nIslwnRAdP2TnKvRKoyLM/p04Vol5uYBTfuwHsZD/Cx52ml89UZBKGMjzNs5VK8C7FsyAjaPxRqOxE7MbZyF2NtSJR54pxApaII04ozMu/ngdrmVCqvzjgCESRtQsm/WvnCPxRRQOMvcfKcBnU83p36XA0BJB3ImrYKrwlw6uczOE3miGHaIaiXxDt30N4Zq86i8Y9hgM+ayjMAtdf26hMifhjzNZTuxHrtfqF1M4X8wFhm2w3hZxISlfwFRLQiFM4sWa/PLo3cjIUF7wDgT+E02SOCphMUAPS7uFZKMXmLHQ/EJ18slOkEboiEZt2J7+KJ8JeAaquPdhgjZWp6HrEN2G3XD9K1F6gonygZlXIAoIHHv9xjcJKuzQSqA07aCeoTJH786yk2z5Tjkqq0/vHr17GKejmwNGhqxfSa8+8JZ3ahEo6pK+i/NVhgj2EK3IHvk=
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
index 0a1c7cc20c0e..a4f1c570b69b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -780,13 +780,13 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
 
@@ -1180,7 +1180,8 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 
 	result = SCAN_SUCCEED;
 out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
+					   order);
 	return result;
 }
 
@@ -1376,7 +1377,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 out_nolock:
 	if (folio)
 		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
+	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
 	return result;
 }
 
-- 
2.53.0


