Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB91CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6F28E004A; Tue, 19 Aug 2025 09:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBE2C8E0007; Tue, 19 Aug 2025 09:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACD18E004A; Tue, 19 Aug 2025 09:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6E698E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:46:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9273F139064
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:46:31 +0000 (UTC)
X-FDA: 83793631782.05.A9F6EB0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id CA730140010
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:46:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jw5ZsdQr;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nTgdfYjH9mbf6+JVSypR+R05kCmlws5kd8OCk6LcGFs=;
	b=eCIJeClv+drjAydSWaLaJgA7vtl69S4C5Tr6fweBnfzYj9TbZgceeWqBWr7sRL671p2iPP
	JA835YFg3tVrCgzSHuS4rNyjg+50pdBPTZkXoAY47rTmGyNbCN4ftp5C0RhYjJ+GlmApe2
	v2Z6hsScAtxrWqsRhzN90qYkizqE01s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jw5ZsdQr;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611189; a=rsa-sha256;
	cv=none;
	b=O3hVJG5WSWbGqKnGXxB+bSzgKeM5RFQiplS8SL+eB0FUVAtxTayHI/XkWGIx7fnT9/BUo/
	X560VA2MU7Gg17eACLuRvh71Os96pV8FXxYnSNBGh1w0NZSuthf7O66VkgR7oQ0GOBk9Eo
	iI6Q3lbtPovpdGBBMY98vll8YTB3W2k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nTgdfYjH9mbf6+JVSypR+R05kCmlws5kd8OCk6LcGFs=;
	b=Jw5ZsdQrWIn6tnCNT7LRp2uYGsobJGUvBdndwb11r5lXkKgQQWUUlHbeK2TvyD3GWMie/z
	XVfMzPUqegqjgskj6RPC1SsoY/FQ9Wg1bYaxPBu9sunR217lgXSLVaDPIV3iqTDrZD7p83
	jOGS5O4jIE1Jj2tU63OQat2/hwwRmG4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-578-q1pcZ4KyN4G2YDVS6oxUJA-1; Tue,
 19 Aug 2025 09:46:26 -0400
X-MC-Unique: q1pcZ4KyN4G2YDVS6oxUJA-1
X-Mimecast-MFC-AGG-ID: q1pcZ4KyN4G2YDVS6oxUJA_1755611182
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD6D31954194;
	Tue, 19 Aug 2025 13:46:21 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05F3C19560AB;
	Tue, 19 Aug 2025 13:46:03 +0000 (UTC)
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
	kirill.shutemov@linux.intel.com,
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
	hughd@google.com
Subject: [PATCH v10 11/13] khugepaged: improve tracepoints for mTHP orders
Date: Tue, 19 Aug 2025 07:42:03 -0600
Message-ID: <20250819134205.622806-12-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: 9cw79314zjrwodp5kz44rajn447aetdj
X-Rspam-User: 
X-Rspamd-Queue-Id: CA730140010
X-Rspamd-Server: rspam05
X-HE-Tag: 1755611189-250151
X-HE-Meta: U2FsdGVkX1/I+u86aFsaA5fkn9cXe5ge7MaREqim1PmBlc+dqYFBKFh6XmD22t8+PuZYt2vTbZZIczPVLxuuQMjj/3aAXBIl9bQIM2bIHaCilBLFkhhTsUmNRzSNO/xX0utiKI/N4Chwaw4D2fJW8wkEeRFA1/eZG1TwnCCz6qquynvMeb2ysPEa/JG+W7Ow7V/WnQ0yrEZ7fVcUtN9PLKDs/o7gItPTGrRyJ4O1hUTZqqK+rVRexvPhYfrSwIM1xpK9iweY6UQDZotfx/fTNqp0D+ksd26PNIspH4rYuXFv1CkxAWHmc0IG3FP14vQRSbx2DEj/7NbpeJiWvKC9X9b1l6/R8oxC67kqdPPXbm66//YYmYAv+z8NCGQkFpysp3EjBB85auyPNCYuT+/T1/HhyBHWotbM03z8tDkbp2j4xsQJKQE/LgJZjCLbA0zFox4J4GdpUs3yvIjXAcrDSqCo6Kmp+VQ979oH8WSh/Xii2MLC5bATouvWLYss75J3Qk7yGfnxtg0E6HgtBp+vlML4nuYpO/KaHgqrs/qO40v66VuDXYJe2hXCBnU093yncFxyFEB2Wsz+WCsGOSASzpkXoBHrxZHSGaw2qAJ6pyoPdVWtPw1v4svxDC1+P9vaQMiUxwIl2f3E4fXkoEF/RXUxH7EKxtphGozFkNnr7ijrwMFtqG+SjncEB8V3IPFTHVB8739NeZ5PSSSG5kTvc9aa/GHeXuXHDhKznjd/11PuDVQEI8B5+bbivBShDly8zCDsXLJ3q7iRPU5VZ650OqX6QWP2v1PA3PJhXbaLIsRjuJTNnsTNqKL6sFr2dGDK1v/VhEoWuROqdz70ptF+PEYVh0sa69RWVzZBWclh6H6YkYBJPI0/AJOn7k5bGgiZcRiTXi9P8lXuCMsACl2sb1wy+zSLDNtrjAtBL5SUmgzmR97L4oUa4aVVsiVmgeGPYPta0X3VCwUTUZHsX51
 5P47UrsB
 RcI7GuJyTW/0/ecLZMKHXv3pwslQEl+m+l1bgXc4gea/K1SMaXkgq2YLf0MM401fbskFNb0Riq7T6MZaURcuTNyEFb6U4GkkeATEYGJ8Wr9RKZdfZHbxrEFERYk0gTjRi30EDKg1PBLfpGmnoEfXGllgNLpn6Cnxwm7FH5KaBZzqTZ7Q9fnRhGdqilPGcYKQLfYy0+bA5X/rkRFFUUf+0TPLkHJ2ODoUD9GEl6/ofYpAlFrQi+BfsuKg0bfRxl02I+aJZRd1wQnWpAhSlvFzhZxKkzvFaMu+omxsTfvj1RwS5W2j/UMXiRxIcn+hXOBT2rXwi0ZYfmsj1TBWMKA1tvAmHCnuc+300J7qrjEYxNvS12rgIIo7YxqZ+OT4xp7Mn9bhDlHx5nfWwVVeppxNHaK4KHtvAK/mJ3wXbB8B50h5oDCI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the order to the tracepoints to give better insight into what order
is being operated at for khugepaged.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/trace/events/huge_memory.h | 34 +++++++++++++++++++-----------
 mm/khugepaged.c                    | 10 +++++----
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 2305df6cb485..56aa8c3b011b 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -92,34 +92,37 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
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
-		 int referenced, bool  writable, int status),
+		 int referenced, bool  writable, int status, unsigned int order),
 
-	TP_ARGS(folio, none_or_zero, referenced, writable, status),
+	TP_ARGS(folio, none_or_zero, referenced, writable, status, order),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, pfn)
@@ -127,6 +130,7 @@ TRACE_EVENT(mm_collapse_huge_page_isolate,
 		__field(int, referenced)
 		__field(bool, writable)
 		__field(int, status)
+		__field(unsigned int, order)
 	),
 
 	TP_fast_assign(
@@ -135,27 +139,31 @@ TRACE_EVENT(mm_collapse_huge_page_isolate,
 		__entry->referenced = referenced;
 		__entry->writable = writable;
 		__entry->status = status;
+		__entry->order = order;
 	),
 
-	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, writable=%d, status=%s",
+	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, writable=%d, status=%s order=%u",
 		__entry->pfn,
 		__entry->none_or_zero,
 		__entry->referenced,
 		__entry->writable,
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
@@ -163,13 +171,15 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
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
index 81d2ffd56ab9..c13bc583a368 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -721,13 +721,14 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	} else {
 		result = SCAN_SUCCEED;
 		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
-						    referenced, writable, result);
+						    referenced, writable, result,
+						    order);
 		return result;
 	}
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
 	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
-					    referenced, writable, result);
+					    referenced, writable, result, order);
 	return result;
 }
 
@@ -1123,7 +1124,8 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 
 	result = SCAN_SUCCEED;
 out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
+					   order);
 	return result;
 }
 
@@ -1348,7 +1350,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	*mmap_locked = false;
 	if (folio)
 		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
+	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
 	return result;
 }
 
-- 
2.50.1


