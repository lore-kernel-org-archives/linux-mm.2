Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D397CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37B06B0092; Mon, 11 May 2026 15:01:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FC96B0093; Mon, 11 May 2026 15:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926316B0095; Mon, 11 May 2026 15:01:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80B6A6B0092
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:01:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B6528B8AA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:01:21 +0000 (UTC)
X-FDA: 84756057162.10.1A48AE0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1ECA580012
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:01:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O3S8mX4K;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778526079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKalnTJU5FPuLj6iiEUKCdnXzBUcvwu0YQrUwlp5/tY=;
	b=uYEU1Aoh1/O71y3XnmnggcL2hP0IHfiTyX/eblQcpz+TSKHFmi1SJver9sftOF0xFey6Ob
	XN6oHVQxahVG2wSkX6ZpSVI7r5M9FGB9tYbwo2KwUnQcE/710u1hRS1QZyn/qIjf0G0JS+
	z2tSM2hOFWWa//qfbDkd5rGu92xOyAg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O3S8mX4K;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778526079; a=rsa-sha256;
	cv=none;
	b=ThOX5SADfbIgb7ffW2KBKKf0Wrt7e9rjfPxU6lGSoY6F3VhsSn61B6yQ/Q6MilSsv3hgAt
	DlNuguXhRmtmTmh7KJu5m2nGRKjjb8mCJu6NGFhfUeuqcHKtoBkMlYoqAQrGAO5sk/ZaRV
	5LjD8p38pP5SB+mZzUhY3k90uKeOBlk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778526078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uKalnTJU5FPuLj6iiEUKCdnXzBUcvwu0YQrUwlp5/tY=;
	b=O3S8mX4KOHU0xiBcD+MFxi3KFuugnhPDA1z6Gp39SpqrBCHNJiP0ezzC1iZGAaS8/ah6Up
	qKelLUFXM7E/gGWUft9HFOuA0TjMjnKuCJblBgC+RwbQZVMQHZPgukl99Uq/8lUrbnvSNX
	5sl54uVqOSVIkD2lPbYmMZVdVXm+N7Q=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-240-1A6AaRPINtyukBqZ0e5xVg-1; Mon,
 11 May 2026 15:01:16 -0400
X-MC-Unique: 1A6AaRPINtyukBqZ0e5xVg-1
X-Mimecast-MFC-AGG-ID: 1A6AaRPINtyukBqZ0e5xVg_1778526068
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0F5C18002C8;
	Mon, 11 May 2026 19:01:07 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 96A8F3002D30;
	Mon, 11 May 2026 19:00:49 +0000 (UTC)
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
Subject: [PATCH mm-unstable v17 09/14] mm/khugepaged: improve tracepoints for mTHP orders
Date: Mon, 11 May 2026 12:58:09 -0600
Message-ID: <20260511185817.686831-10-npache@redhat.com>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AyieRaIh9h376ShroyC7CRfgl7fzVfG6ZgQ7hl2HNAw_1778526068
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1ECA580012
X-Rspam-User: 
X-Stat-Signature: 5i4d19hf7ab16xrhdd4onbudaxj9ucsf
X-HE-Tag: 1778526078-480449
X-HE-Meta: U2FsdGVkX18d2jCm3WWPkjnWqrGTjgZi4fqw3YTCH128EatLMzNLZCdWor9qZKPXKN4MHTBposa3JhgkskoXWRcsSFVGcV07pOcGCc1hWx0bbEZlFg5AtNji7I4JLL0O5acHy8NQzDQzJZHqw+I7nq2GzIudSxd0aX24ENu1bMMl61AfUMrCHSWW2vrAncD/zhe2KE4MWEBrzHc80m2P/bbGgIDurSPkjkE2epllQhqBBKuY3abSUPnuuU+Lfm6v7dNdvOo2zvBttIkLFQGuVlFGISAiiiSGs4DZRFWV8I62wWOy/DlSwUqrOgSw3KFDjSep03Y+pp/qlJ377/Di678PRKJ8xPoTN+cROl61z5cKHpW0nDs+wbGF+cpNLcj6SBKmZgZxEwP0BgS7i+Kn0t5bu3fb/LCUodA2vo5Yvaigt2RDLX+/fgLoCw/nKxnLhQ8smSNAwamzk4GiG7EWg06onizFR3bShS55N9CsFtTBgZikuAsKPEgX8FYjkn6E0zvobavT6Y8a6YhV4i/tzaNeC0GugSTirtS3llFKeDqlNB0X1TC7ZFy07+Nmbq0dJ1WEVexuVwXorVWV8mBWKZQ3M4foFLOHHRmCY0CmxzoIKYGn239bxjHn6t372avnXTRTJTciqQ5Z/UT5BXrHaYNuFDKH2uttTIZM1ZhoEv54EW3Df25IXSFHspN1KyJ20M44t1MrwohX9jGQdo0x++I7Vqh2RD5GQxcuVvntdQZju7hsNkrUavvn4JBRrogLTtOSD4hvZV/jRQuNpSC9+b0Aj+evHp+y0QwS7H/bQVHkTgt0NB+zYOW6PJgYP+DFYlFXCdQhpkmfVXo+6/XYzAMI4D/7mPyrLeZ5HuMqTIdAfoLZlvyaIkmVRHAKSulZMgMMIj8p4023gYeBfVx3wOrDuLVMHJLwY3bwevPKK0teGd3AiRNbJKefLaN9sPsMcMQK6CgJEgZrrZs7naa
 ggkG/mWQ
 q1UMYYa/+axAerFFuRro7MOVzIkCYRNglyOtbxCKpyERKuwUqW9endc3SrDYLX3FBt2BDzyp/vbJfiXh0yF2PC/KRKG6MM6+conXhL/48hWWhUvna/MJc3GKB4HdfPMptajVrubFbPPh0gnK6n8XQMERIXl+IWwnc9K0M5kNHklRjfzuopBkb4+TRItabORVV2UPPWRynlNEvPIe1pDBpaWEShQKzxxvaGDq934rRnpd96iflZ7Djuk8LglgEDzHHfPliL/RW5iZCwZw2TXaIDUll0SzndJrzRfs6Itj5WFFV+DuXWH6bXJ58DGg14T/tDkfzroi8q0e4ZMl6FGPuOZnmk6Go8A/KSZZCSlss4n7HAj8VdPadPqLEq9NZSWFLDReWark862ocM/CIaM/DX4GJ745dS3zO67Fs87t4qbj/1IIih4Nyq/+0qX61L6FYRw3fyUkQK9BLip0=
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
index 443e0bd13fdb..70c25136e7e8 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -90,40 +90,44 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
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
@@ -131,26 +135,30 @@ TRACE_EVENT(mm_collapse_huge_page_isolate,
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
@@ -158,13 +166,15 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
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
index 27654ea3f5ca..f28066069437 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -779,13 +779,13 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
 
@@ -1181,7 +1181,8 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 
 	result = SCAN_SUCCEED;
 out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
+					   order);
 	return result;
 }
 
@@ -1390,7 +1391,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 out_nolock:
 	if (folio)
 		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
+	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
 	return result;
 }
 
-- 
2.54.0


