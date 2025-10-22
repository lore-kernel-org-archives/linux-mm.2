Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09D34CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1148E001C; Wed, 22 Oct 2025 14:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1408E0010; Wed, 22 Oct 2025 14:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4690F8E001C; Wed, 22 Oct 2025 14:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32D548E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:40:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E987213BECF
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:11 +0000 (UTC)
X-FDA: 84026615022.28.DD69B8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0EF63A000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SHtFyOIG;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkILLb4dsWnONTRAp4/MwofWNyQLx87p3YYpCdyq0mw=;
	b=RBW6Umx6xWBUyOq7TTImhsLifivphAd2NF8OJoIz4ZFA1/ZFDpm3UfByfYL73rNscCK9Yp
	15w4iNSN4W29s4AgM1+7MF6OvgAXZEMEZ48OP7dc8bqof/uSdp+XSUkFXQE32rWK1slekr
	ST8OARwVAVHUA3IhG+nKKkEx3ZYsGNM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SHtFyOIG;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158410; a=rsa-sha256;
	cv=none;
	b=5ZdY4zBSM2KfBXyiA7T0PIoSTrCEB6y3/jUd8OHhRsugerBazUBXMJG2QhcVSU1yd2Mv8c
	ZnbESH+9E+to2lNaEorlClBps/rCjGPNiZlcCpRYrRXIWMc8PxjX50gILwXUHHnZAZL86M
	e1seD8xIH93kj2G7F5nI+8itCyqo5ho=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hkILLb4dsWnONTRAp4/MwofWNyQLx87p3YYpCdyq0mw=;
	b=SHtFyOIGeh3yICj5sHyheBqXoOA3kQARhD6KInuCiMx8E3CDlINQdK+cUfmkFxfkNN/cyQ
	yGi+AthPWRrr5g+TOlXpHbDNxmWcdzLrRqSIJGpynQC0IuJJiVX+5X49S+xmXUO1+CXgow
	5gJ2/5i/QDCVNKafNPVS6q7nnKIRVQI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-uO334en6PGCjUSC-6pZBxQ-1; Wed,
 22 Oct 2025 14:40:06 -0400
X-MC-Unique: uO334en6PGCjUSC-6pZBxQ-1
X-Mimecast-MFC-AGG-ID: uO334en6PGCjUSC-6pZBxQ_1761158401
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5AC1B180035D;
	Wed, 22 Oct 2025 18:40:01 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CC38C19560A2;
	Wed, 22 Oct 2025 18:39:51 +0000 (UTC)
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
Subject: [PATCH v12 mm-new 10/15] khugepaged: improve tracepoints for mTHP orders
Date: Wed, 22 Oct 2025 12:37:12 -0600
Message-ID: <20251022183717.70829-11-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 0EF63A000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: msqfi76cnmfb4s383qxh7bcy1tmohx79
X-HE-Tag: 1761158409-199427
X-HE-Meta: U2FsdGVkX19G+lNZ39SQUytXBobUw04L9mk7k2NHH3pYK5PjLNr0dhEdqHRXE7fY/RsCHDRrL37lLqVdgMYjvMNlnks3cw2e44N/fzol6A0A9Ey96J25L8CiUcdcBg2yOLHgdOuRIK5MR3RPgZPBUwrIkWnkVSOhytvzNmUYzFJxBqsnerWu3y6U6WFxFmFnNmyl8WNxm4cl2owwcfmFSOQAc1vrMYgA8arlTqIwPsScZJEebNp2awuUysl67lzB6JjL8drnU//E8fQpq9zf6SHbOZZqLCXQZV1jD7nf1ge5pWj303V9XKF8ZrKl6yp5x2MSub5DhynNBLog6UAV3O1Wl/3qCCcesJZUd1d5k1Kd9nD1EJnGvjiNazFPlt4Y16aSX0vhyvpZcnLJ3OQjQeAU6gbTG7ZpR3YD434AsUS6eUi56Yo6bC8hv9LV6CoHk2GhwOWlSGHwkG/A/Gf5byu3TYk73wYrlYG/dwYCpN3e5o2tSLZvGiYjlaMKtqnLXLC+W0bo3SX3Z2jBidiOPGFpBhKuGHjic7PuG/QxQH2aTiQA0Nbg1RHGJqX4+7e1w9z+9b4x9LM0YRQKZM6OEG5/Vf9n/qj87iL9UeF35wd1327kn3KIPmDwywDwb0ZYeieHJabHjaKMMEAPeWTEhw7Rh0u2UCgnkrJTul7QYTSZbnrSoZmLDd4CV5lFRMCgvBlXW2MoyF8DTENSGPk4yR+zjSskwXAcAlEGlmYhicceyYVPxU+X78MNh/rou3bqPtEEQBznngQcl7Ix7kM6ThEAiAYemsIuJBI8bzwMG6gwKmABx7AK1XpbwM+hpb0ki3Xu0E9bBfOwaiXwVGw68XHO4vqs/ml7B/oFdNom+Veh0/AcVSfpgqg/1AmtCx0gBsQWXXpAPExXoHAxghJcOBRoUEDF9JDqvbMQhSrFShXO12v9jf7sn+MndZaxJcNsVVVthS9qp7wuqoUPm3x
 jo3DsSmN
 gVZiSrEKk+lRDyILA9JvLQwFVoJkcNlYf2gBtIsHsy8VfbQeevkQEzDRFhY8yKbEGYYQ5mMx+tpsHf79uUwZkmkzOrolkzJ1o3EnvMcUCPWd47lS+7UqqkUTTFcGTnor6/ESvyP5Q21N/KlvhC1HLHbmFSEl01Wql9GHmrp9yWHq6EwHW7sduwWBWJyJedpS9dHVEiJCa2U86SsihJYDu/ZmUTiYJi4+fnOc6D2+X/eRdC4/m09ss2zmnMMuqzRJiIjcVmZ+7ugZeOqOd9oq2/ejB5Y7XLygui0soviaEm/LY87aWnoUI6wbylg8gYYZBMGQ1S6TzD9km9zm2UGX8woqGOCVTFQX7qLlrdYvaOfiTjtp9tx8cZKC7I40ei//3aA/g1Ap/LGHWRu0o09nSyAABkJV2wUZDaQIz0eDh7qd8HEHIW/Iwgpj6tVi7gbc1aMaZ
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
index 053202141ea3..0dbbe04c31fe 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -722,13 +722,13 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
 
@@ -1123,7 +1123,8 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 
 	result = SCAN_SUCCEED;
 out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
+					   order);
 	return result;
 }
 
@@ -1343,7 +1344,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long pmd_address,
 	*mmap_locked = false;
 	if (folio)
 		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
+	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
 	return result;
 }
 
-- 
2.51.0


