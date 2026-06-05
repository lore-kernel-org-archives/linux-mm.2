Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA3B1CD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1386B00A6; Fri,  5 Jun 2026 12:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471F96B00A8; Fri,  5 Jun 2026 12:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339596B00A9; Fri,  5 Jun 2026 12:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8FB6B00A6
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:16:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB6BE1C0ACC
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:16:51 +0000 (UTC)
X-FDA: 84846362622.16.AE1F2A9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id CBEE218000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:16:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iDT1UEjc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6L9066owL61TKgEjmCW2MU6W4Dj6LYvPAJCJjXhicQ=;
	b=DxdSBuxcwt+Qkpx6SnJWtWn6FqvByDcoOLRx1sPjaG4CA8OLFUVENNNRNvIJca575/fQmb
	pyurdwv119xXxLdTVwfK2yrpDiKyf7TplnpELL9OgQ8YfQfX0k4wYus961OjbgAovFbhSE
	8mMUWhL6iT7Bk7VhDbO6qtgzOz46M8E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iDT1UEjc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676210;
	b=spYX3sUyTdf0GxOKSzXN3owa12syz/1eOYD8qCob1vTZLFL/uyC4RmdfwSx5yVyWbd0J2S
	micaCqyx8vzvcUB/+Zw1MqY1mdiAB8SFeo8Z0FwgimKomajapQEDR8whFAbKY1PRRMAkPq
	KrsZgpTrAcLeVhtSvt1f50GQnFgRIxQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P6L9066owL61TKgEjmCW2MU6W4Dj6LYvPAJCJjXhicQ=;
	b=iDT1UEjc9B4Fu9c4fB7E5AmnyHROBfONYh0hAkkw6d/j3MUPhRDHrJMvS1Gbd8hLZOZXQ8
	mGFAoYJJ3zz1zUVOUtqfiqrQAkI2sexrWG2+00re/9cILcSSJp3tWeE3zPTBwqyErqAc1h
	UYSpuzIVR+H6Xnp7FH/tp+7jdwPzduE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-481-JkGAjqXhMneK8f8om2cDJg-1; Fri,
 05 Jun 2026 12:16:43 -0400
X-MC-Unique: JkGAjqXhMneK8f8om2cDJg-1
X-Mimecast-MFC-AGG-ID: JkGAjqXhMneK8f8om2cDJg_1780676195
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D61DC195605C;
	Fri,  5 Jun 2026 16:16:34 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F0CC0180049F;
	Fri,  5 Jun 2026 16:16:16 +0000 (UTC)
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
Subject: [PATCH mm-unstable v19 09/14] mm/khugepaged: improve tracepoints for mTHP orders
Date: Fri,  5 Jun 2026 10:14:16 -0600
Message-ID: <20260605161422.213817-10-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AShXnJmJ2unVgVlGxT2GJIvVroEaOwm_u5gGuwuIav0_1780676195
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: y4x8n6b47xqw6nb7cb57eb4zjwiyt93w
X-Rspamd-Queue-Id: CBEE218000A
X-HE-Tag: 1780676209-107923
X-HE-Meta: U2FsdGVkX18/RF/6KqMjHAqqv60rQ8fc8pnp8W8YYmGzzTXdiS1yKPmXP8N4Q37viucQ+zTXaD56n1nGncFnpVsOsjfX7iTkaMtCbS5KESomoHZwedVIDN2zFp8L5EjYbLf0B3Me7Os54CEL7nh0dE+lXGy12iAVWonW2Ttqg3HfdOYy+DgtI97HEbOjAkEDsSXPhlXkecixDrOW/xCGeTQrHb++0a+CQT3JzeJoXePfpuF1XZ/tTr/U6DjVgGfSl8w/A6B310/xiijz+9YcG/0jXZwQicod+zmHgDDIF8A29ZkHxlmWli1UR44Bsx/LZdMDZ0Kjp+tmnWyXhvXrLLVb5xZXHRpDLBf7AKpnjVZT7Ul4oloKgUONZ04LvhMO64jIFsybJFqDtHwegPdm33Q+/x6VNVySfjgTyzOjV/3oKMegea72nBMqG39uGVI+9jSq5iDu6f5UqniZSo521xFgIEzu+lxE76znn/2chTmZZDUdlkfkzxfIproXvNSZOtdUxQifhFYDjv4B1sULhNrs4JRsrHWlem01quS9YvZkPYnHfhjZLvXvoV7/kNLDYe6zKP9EVbG0WUazy6PM/r+xbJobuVX12T4U18emtc4+MeF9r9SRoJNOYnT8oeQMWiFIgjwzwrlDjxk3zHE8itjXo5DyVusyUgIfOqxr8ZABqnAzJFbRUGdnNnEvOU7YXizPbhc9KZi3XZI/ss1stGot89PDxHZQLZ8cL7pX6kqvjTYI5ag2KbmiqvvQ3l3RTz/2s7P+zFTVdfQslXTSCUX1SbS5g9JjOVXYluFOblLv17GK0rLMltlX+h0fOAlDEIoXR8NAavoBYpLEZxHnDFPB0QVy9sh8akd1RxN2w/p0Ql2jhvVEewe1n8kg04eVhzqOIsyYoGWaacSq6ieUxXJwbsdqRv9xt0xM9sERwRsJn3BMShCtVTHB4zbI9g/JL+ZCDHkvlQM9ulNDFWV
 Gt/ThFTS
 u0kcYppHpex+qUmlVVPNLUXTyDgND3+Khed4ieXxnm9uYx1h1IbDmZZ4t7TcJ80HM71bTvurb9hElNclkZk6NsaYJwgtgtxhdh0YY1/j3afhC8aB2Cd3k3C9evBGADHOGIDTKVlHbmtcGc4CJXZJsdzt/bocuZRGqG6H54Zg4WNx0ChQ64z/2x+SwWgrVOzfje/twAFSt4R9I2gL79XDZj7EPh6ckQCw2AGWSVvuujuxZp0ALXQJhIuOjl8KxhBFhQFrH1geDUj+7PEj+4o/rxL68eMxYPzzCvREEzFItCpnrPauVJ5kLdGHu+owyM7GtUDSNgcsKBW003ZJt9ggsiF7CicGcXgHq/CwzflHQb2qRikme/c9isqiPB0y4bJizTJZqLVq0jZFuhmHwUmIjgbD66DxiBv2j4NAlteocHONhWdHZQ/Gj/BmDKdafvgIfhnJ1glG4Tej+yuG8+9Ksud149w==
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
index ac4731addafa..26c343a6fa3d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -785,13 +785,13 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
 
@@ -1197,7 +1197,8 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 
 	result = SCAN_SUCCEED;
 out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
+					   order);
 	return result;
 }
 
@@ -1417,7 +1418,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 out_nolock:
 	if (folio)
 		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
+	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
 	return result;
 }
 
-- 
2.54.0


