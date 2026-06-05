Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4814CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425CE6B00A8; Fri,  5 Jun 2026 12:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5FD6B00AA; Fri,  5 Jun 2026 12:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29DD26B00AB; Fri,  5 Jun 2026 12:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14B4E6B00A8
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:17:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8BC9401F3
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:17:12 +0000 (UTC)
X-FDA: 84846363504.22.F53FA18
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id CBDE52000E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:17:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WrXiafjf;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfNLaMiKvOW75JhtX0mzA+ezODy491wa3o3Fr06jBN8=;
	b=k9b8NFR6j+Tr2O+kLXMaAY9Dnh9USCB1DeoDX5W807awNLuP7depOro3CfwXpZv1+rUieg
	3b0FfCxze0P9UQn9jRvPpNLsRSRqMXxxqJ1nF6j3jEKb3swQW7mVrDthdqw0xItWPVOAxN
	Ooz7jWSXwCA+zKvgVYzmTK+Ix2QOl8E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WrXiafjf;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676230;
	b=XZHBQQDN+EvakviCCJhqS+pLqNF27E8Py54r3QX+X5LBDGf7Zel09ATa2N/AmQe9DWtD7d
	+F8Tk8cu6bHBkxmruBgFBYu92AGbBTZvlI6bmAg175DyN9Cwg7TdgH9Ef3kqLz54k0u9Au
	MgOjg7vo643JnEyGBnmtVpYogpbxZtc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UfNLaMiKvOW75JhtX0mzA+ezODy491wa3o3Fr06jBN8=;
	b=WrXiafjfNoNR88covFNMks16Rl+CbWgOw6zoLHpr4xLJvn1heM+YwHKRJmsvTQO8b4GQUs
	ABZ6xK+RUs1blBxEYh2hCvzaaLaVNSI6/Rc+GbLC5YM0YeQuHCy1G/9tLTGFZpcE5nAPzL
	aoseQpOBKzzKpCGSZj38az1f2QEQtqo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-122-Vg64kF0jOaO3qzZ6cigHUA-1; Fri,
 05 Jun 2026 12:17:05 -0400
X-MC-Unique: Vg64kF0jOaO3qzZ6cigHUA-1
X-Mimecast-MFC-AGG-ID: Vg64kF0jOaO3qzZ6cigHUA_1780676213
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01FA1180035C;
	Fri,  5 Jun 2026 16:16:53 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 79A13180049F;
	Fri,  5 Jun 2026 16:16:35 +0000 (UTC)
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
Subject: [PATCH mm-unstable v19 10/14] mm/khugepaged: introduce collapse_possible_orders helper functions
Date: Fri,  5 Jun 2026 10:14:17 -0600
Message-ID: <20260605161422.213817-11-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Eyi4-uUOHKlrTNlwQbpDdlGXm3hqBD5Lh131ZgoNXgE_1780676213
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CBDE52000E
X-Stat-Signature: ic99fkx86op18z79d49xq9q7sc5rcpys
X-Rspam-User: 
X-HE-Tag: 1780676230-477054
X-HE-Meta: U2FsdGVkX19MdcqFHZ5LivOlBLXLOl2f3yOrHFDRgDi2R1laQ7pI/SlIexdwIYQ/MZeoFKE/FUMeY2AGV6p4Pp8OeLil9MhhVRs+IRNGDT7qjHo85Gj0ggZR2WrRLFjm2SWpqcMoDgFWavA4g/CtN+XEBKjQ5E1UbanFxHrnOjfmNavYlB/uECEsVOLCoWh6xcwue/HhVRX5YQZHJ8X22CukEMMuDx9sW6OLlo56cRpCna+7cg4EdqrMBcbZRygtU+/qgxXEIm37bldWxS6ielvlGjs+IL4jJT66V1ebZvRsv/kn5fJH9ziMXPaNQ89Oe389BVmpJYm2nbEf9kgJgLQmwugahc8b7qKOGQ6dVhyVYMLeqwc64wfHlhNiM4O4lmicf6czloST5bAqtruU2Kz+p8pPJH8FKonBEEVNbDJbcxijnahmVfwc7Et1pDx4OD/n6X3sBObBR8Ovb7QHvNaHvF0a2VsUMsV60n/UTJ647Uz9SEESaEuMZbcofV4g0Jl03e+uU6rzU6D0brUjLdHcFs99czht5G6hJ6zKx+dlRQ7ty/4Qm1u9uyVRAsoFHHN4LkfsU6ikaLpFW7nW96MqIcunP9N5zdtp41Kqk6NOAFzjcoyK44oFyCsEhiPgNxoRWJrZhZ1cMVmcPBPM0I5FyNO8qIhc1hHvGJhDkTmmib9O7j1aIHw11acCoM395q11DIGX+hY6vGHLV+UtL52MKL6UY+ebjRdMpYcMYcPWV8xeyPU+mtcey1g6T8qq0pNoUu67YhAETJ/HLE+B8IJbFxQdNmgkGAF2Fcvbh/u6l4B6QANQECLzATZOOp+nvTmHDpion37ZccjGHzt1AVxAAXwcRwgE+hNtK/o/GyllTEJr/bnFt79Jx+CMjvFhL3Mo3fS/2hBLfMTuV343IN3Z0BCzOUG0uLZ2PyNmIkkb/dCjgSqA/3ZcDYyfgqyUVEVzjqiFe2EDVO7VSiq
 ZjTdfAmq
 6EBK+dzMNP6KjKcZZrkok1bAc5/SZLomZKj5K2kA/WckfkktPV6e6IJcFAxHCJyXW6/qhHBmeuR5E4xLSbw4+LfIF2Z5jYMyoljEjYaSbJBpWqVhcB3dBxWXfxkQMTlJRNYJGWozFZmLpUCkXsziPRq4p7JiktyB226ik9ie5/jPQTpAQOprqDkx2+LLNPl+3W9r2avZ4GweUAj/GcfyQQ8OC27ohUjQouw5ho8Cof3M++JbPU2U+STuFtxkGIHiIwvup9IWSeYo1VRm5Xlxw4lD4tqCnNRoacs7nSqaVW8/ROUFrPWoufJmc2xSOrHKYK0P2yFvnGowGwXrLzHcZCnxHFNXfqSaj5bZ6X+2QZdCKGGytv5OpLa55sSpiIpi0qGjYP8WDHdJzrAQqP/04PTYE4t/WSYr+bsxI0ecP5Zu6aljVvZ+dIZrFGSYHqdSFLSzMwnexpJTcCtTPhnsA6EuOjcNWiVRtyKsqkDHJ7bTzpEOcfGKVcVBkb/LQaCi/pl2K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add collapse_possible_orders() to generalize THP order eligibility. The
function determines which THP orders are permitted based on collapse
context (khugepaged vs madv_collapse). We also add collapse_possible()
as a thin wrapper around collapse_possible_orders() that returns a bool
rather than the whole bitmap.

This consolidates collapse configuration logic and provides a clean
interface for future mTHP collapse support where the orders may be
different.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 26c343a6fa3d..ec886a031952 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -554,12 +554,30 @@ void __khugepaged_enter(struct mm_struct *mm)
 		wake_up_interruptible(&khugepaged_wait);
 }
 
+/*
+ * Check what orders are possible based on the vma and collapse type.
+ * This is used to determine if mTHP collapse is a viable option.
+ */
+static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type tva_flags)
+{
+	const unsigned long orders = BIT(HPAGE_PMD_ORDER);
+
+	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
+}
+
+static bool collapse_possible(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type tva_flags)
+{
+	return collapse_possible_orders(vma, vm_flags, tva_flags);
+}
+
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+		if (collapse_possible(vma, vm_flags, TVA_KHUGEPAGED))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -2700,7 +2718,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			cc->progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -3010,7 +3028,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	cc = kmalloc_obj(*cc);
-- 
2.54.0


