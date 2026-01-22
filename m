Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D74D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659226B0335; Thu, 22 Jan 2026 14:32:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5973E6B0336; Thu, 22 Jan 2026 14:32:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381326B0337; Thu, 22 Jan 2026 14:32:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D31116B0335
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:32:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74214160B1B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:01 +0000 (UTC)
X-FDA: 84360595242.21.200FEFE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id B38A040011
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OOhU09KP;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYYlse+kS0J3Xm+psz9vJ/SdkHQSC+eVDJpTvkyTwMM=;
	b=N1dUTJ7syIURrKOebvc229YzFRHBBC556KNzmCNnYU9wwqp8yvTPmiJqFs4+swwIk3Etog
	gYrl2Iqe2FgnM07Tc8wG6TsBorSrIoNFPHLDmNhJVawkDFevx1pgPwSg4ZqeBWI4AT2LGm
	uoMLGLOSA5karyTcw7K2bAno0N9gND4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OOhU09KP;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110319; a=rsa-sha256;
	cv=none;
	b=e/hWb9yMnxILuSHZE8sAOAEOOuhmLTgL6MdfbbulTtBLW5o4Dn+wtyxTRAKL/RcUTp0FHj
	mSfxFGm94yqJoZ+EjFJfDDgATexk+tSab12AKCzVIQfFrjkUHPdvSmGxN6noYk7hK9TwE9
	Yp5ZeOIb+UWHjsDto7pw75ZoGFfjxPA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FYYlse+kS0J3Xm+psz9vJ/SdkHQSC+eVDJpTvkyTwMM=;
	b=OOhU09KPrYOuKKjgcsF2J0YYw6VGHGBk1jEmjgkfq3XOS6z4Z5OFdEkwZ4tpvNQ5NFWWCe
	Q/Rc9pfjpH1TBzASJkzIPLg1qr6jd4B+qt8Frer0Rj65lKggv0PZ926sPVSBEnDBN+jZEM
	+77EUUZxR02P/2c5PjSzYr/skVdCoag=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-696--xw-4wmMP-GgmM0Zbyrc2g-1; Thu,
 22 Jan 2026 14:31:56 -0500
X-MC-Unique: -xw-4wmMP-GgmM0Zbyrc2g-1
X-Mimecast-MFC-AGG-ID: -xw-4wmMP-GgmM0Zbyrc2g_1769110311
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4240D180047F;
	Thu, 22 Jan 2026 19:31:51 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E4D601958DC1;
	Thu, 22 Jan 2026 19:31:41 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: npache@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
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
	zokeefe@google.com,
	rientjes@google.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH mm-unstable v14 11/16] khugepaged: improve tracepoints for mTHP orders
Date: Thu, 22 Jan 2026 12:28:36 -0700
Message-ID: <20260122192841.128719-12-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tAluKzZVSR9cgWPYvsnKhGZ5kqzicgUWFYI_QvFu_Go_1769110311
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B38A040011
X-Stat-Signature: w3aix9mr9f55gjt9un9wur9f7p6zkkix
X-Rspam-User: 
X-HE-Tag: 1769110319-77051
X-HE-Meta: U2FsdGVkX19up256++Vsj08VQuFfpSPH+NCsdux2hFuEJ88V3j3kmTpLvUSEU1w/bWzwf+0X2vWIwDfLE/6Son7jNoi4tJ2H1HpEbeiwpAU2I1wvwx2CvejCUwutOBuJAsCTaXD1VEc8z/YqVaUudWk9CL5haX+qe1XVje0eZpfOP0uTZ0JOO1yi0ciO6Szs6MANalzG5t2ShvhhjWMr7T2tKURqo9QKBvexH5sfNs8NwJTDsJND2OSqeICaViObSTjlLojU5rRy748pDIsnCSaWwZhFTBxCvEJGTed5IwWjAFemrrZfYqBClqgAsnosXXVSXuKLlP4q2Ji15ozcpKIkjvxqDWdsT7IAFvCqFOEEJN46oUpNBrmNYnm1tEu5lzboTkJZ87/mzPnmExjf7nq8TzOWtAXTDDOAsX5u14MY8SFRD+pBAdanI7qKCzJOcNHFyJ7MJ7ZznzEeoXG7v+8a3Q9vujivU/4v90iWlipmXUpsaOZGIpiSw3Wzyg1e1SfV71pGRZZxMlPLHKoE7N6QnvozvVhJf3rJxSvcxOtpXueEjSuEWhBC6HaLf9aKjYv8+R3sJsV8Jf326sdKSrKOjZBBS3DGBgzsGtb+aqQlX6oUU/NcCAYoi/I8K2ohZ2mvYdqCOCM4EYMMla0/SPJx+n9t7qU88mzTTifJUppEFd59WdiK3+OAmvu9SGywGqvyvk+cvkBt+yo28gXCMeajhSLlGh/U+kYpm0TsuADSrU7ycTx5vovh5r5Mc2eCmuXshOocPH1/C8qELPVt3hBntKZP3V0jYwmlg5QiFQmSUJc3PUBkM8urE9yZ+AiQMPQ/gcKHDf9yWwlN7T/niAJNuf3KVMkk9ESJkNYlJd/Lz24P2qvRLn7psykvxBQAxqneIEQJViHGDFJl/m4+kN2YcrqneVhlRcCDYNMwv/3S7tthhQ1MeFxhdcrm4FVvWUq2FNlFi/CY/XIoow4
 CB7ZvP0I
 vHHXCdsYb8w2oLUdsYxNVJxHuRkR+482/A4QCWom2zX7M+68qEmWyupwc45f3/PYCWDO4smI2yzv1DI52JNwbGtw2SA==
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
index 4e41bff31888..942c82f2d0a4 100644
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
index 96f1c28646ba..e33b2594949d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -732,13 +732,13 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
 
@@ -1132,7 +1132,8 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 
 	result = SCAN_SUCCEED;
 out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
+					   order);
 	return result;
 }
 
@@ -1356,7 +1357,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	WARN_ON_ONCE(*mmap_locked);
 	if (folio)
 		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
+	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
 	return result;
 }
 
-- 
2.52.0


