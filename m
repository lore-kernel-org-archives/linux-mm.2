Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A258AD6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1002C6B0326; Thu, 22 Jan 2026 14:31:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CC76B0328; Thu, 22 Jan 2026 14:31:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5296B0329; Thu, 22 Jan 2026 14:31:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE8736B0326
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:31:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83FB5C331F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:06 +0000 (UTC)
X-FDA: 84360592932.20.D197335
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id A561820010
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Za6vXLk7;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLKonnUCqMUW2WXJfKUH+sR9gM8uHvA+k1Mb+7rfrGo=;
	b=Mnl/m5NZxLPJ+DTkOJLru9eS3a9LgFwYuYSBN1Hv83oZG7nJMsKPgBW+ntqX6sGBkSE3yu
	d5tHYdDKM4O6/L4NnBtEAdSDdCpnnpwtLeeaGYNcRoLc6a6JdSO7AEHgJay3z9yvoyNeGn
	4TrPTC5o9fp5G2GuN8OsGqKhoiBuuwo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Za6vXLk7;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110264; a=rsa-sha256;
	cv=none;
	b=8FnbQDcjGmUEmkOaC1N2m8imxOt6jXYMjPAvysrMo1DXJr9W9ia8TK8HDsPYOu+hjedhCa
	HK6fOvXG+FZ1KY5//5Fu3eppymGVpNklU9+1abWNNA3V5HnZ+85Az4MQ89M5uNzbJ3e0Yu
	8AHBhH+3O33oG+JLt0XkJM3EUWSLiTE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TLKonnUCqMUW2WXJfKUH+sR9gM8uHvA+k1Mb+7rfrGo=;
	b=Za6vXLk7vUXVR00nFT/PFOZ2VwBRjCbcILjsY+r8AA0r+4YRyU6HOioSvmcwISWB9Vn2UX
	Ot2CglN59TjcUn+5k0Iyt6qDd4FuQtuI47H3mSQvrFobCN07a2xbsHq6iPMUxsZjfFgb42
	Id1a4iNgUicnkKWzXxsWyBxbeSw1/dc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-TF9fLQ6NNDq-_3YzsvEDkA-1; Thu,
 22 Jan 2026 14:31:00 -0500
X-MC-Unique: TF9fLQ6NNDq-_3YzsvEDkA-1
X-Mimecast-MFC-AGG-ID: TF9fLQ6NNDq-_3YzsvEDkA_1769110253
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E71C1944DFF;
	Thu, 22 Jan 2026 19:30:53 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 173ED1958DC1;
	Thu, 22 Jan 2026 19:30:43 +0000 (UTC)
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
Subject: [PATCH mm-unstable v14 05/16] khugepaged: generalize alloc_charge_folio()
Date: Thu, 22 Jan 2026 12:28:30 -0700
Message-ID: <20260122192841.128719-6-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qr--1eflYCA72HXfT6cDug89v5JfcmMd6dGTtIZcJL8_1769110253
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Stat-Signature: hdtwpmuoq9smcer89m4snwk5inr7egyo
X-Rspamd-Queue-Id: A561820010
X-Rspam-User: 
X-HE-Tag: 1769110264-889660
X-HE-Meta: U2FsdGVkX19aMN2fZfvuYvyPyKnFxVm8075nJ/pSlNWkMO7gXWVQimZWzv35WLl8QNibxBo2bMG8OpzoIG9W6e6sqlFrKmCrf5naZ+YinY4uIypiFjpkjTT3SueUUAKjaXzOHCCawhAcsQCm4psYvucbNj1z5apVjo8eZNximImwf488RCxSxRgX/ZbArG5uIWhkH9IzmYAFekEhv4OLn045PLNvUVY3h8+RtI+T8DEeFOqjqJU15sEc+dFCnwEqzcLQSNIGhXOQFY6SfniocPGg1Hg/hMC09Rh/a6FB2VAfZqz38bT5U6AXqGIZo93b/cifUOgyVBROT47FebM591W4R3k43/PjMtSazzOC+ePJjIV7AbuoLsxZUt9sPTw0TE3kRB8IxnLLto8DCQ9PEeGuyWiS8b4T6aZiAyV4SdHABrichDKcOO3cgU8FZ9JlQ32FrLnPY2yCtxDTKGCuChrt+cNbKEH9k1mzGSIYUFPM8OIAntxopNrQB6k2MLqxigx2pY2y9Ns0IYETGh5R/Y1yucnUFwuGqKakmu5qa4bPy0Dz/2hkePyEhxjxBZtleZJVSLatamYZ716fYVL3K64LoXp8NBwoJNHxh80eAsH1RYNDQBxlyI+/gWgKIPvkDZ6Dh9MhZ0KjIoRiGQtoMcj2fELvIO27NioK46pYR+/sG7DHUcvOVYFXvMfPZrZLOjvb7n0hOsjEk9aRVLPZCudMhblhsa9HtB6XFyLmw7ESJyCvIbc3APQSCtlJeNI3V9qojekTi6kD9a8mO/J2IeTqphyC6t53X46EL85JwHYHwVZnJQ64eIzvanMZ+2G9pyZUhO1jO+v/rQ7a8L//FY6kgMiRCN1lZ76PD45T/Qkuc8G3hJX6k94OcIGxbM5xOedjABkCKH9nKWX6tRwi/wkCZP8l/HjFx2elqTSQlZs5mF83Ov7SBI9NzqVyTRJRsrP2/4iH8lAjEuxVZyi
 hTR57R4L
 yDT73XwhTQsmZk1O6UYwA6lGmOwy9DiFUOgIh4rQPSdTx7JTV6MXXJb98QcG+CJCoHSsClBhTw75qmFY/5LDOSmjEfBZyIPplcF2dudCQiUI9Y5KCgdZ1ws3Sx6jGRc9PCvay2B31mp7Y4z0ObpkmXESi2E8ZAO0PJ8S2VjlwheTrH1T4701iRiKj/ufTAlrWKM9LQrLuE2oJanNqA6bfD3zC/2QFPkQr/cKIFg/T5L4Yl0cknCHZnO7geepXzWVGk3p0P2QIwN3YE+tFBkROiYHBizY+82haLexUwbgvIdqBWfN68t7gyp38uw2slFl7Kq38fDu6f2RJ2r9yPt6+kPedaZMmBDO1TSqcQKvoHCt1zUBfi1JxVLMMvhafStdbwbaejorAtc+vV/Z+Pmnbq/lG+KAXe+hxAcWWVN+MR1WbqcnvYgp2MorrVX3Y9xKnDiktt7Ixn7TvDXY+lInFilncXgB34QUCzSaVhqYWe2lfSbR+hLTGKi2005fKeYX4LFgYzdwT6qQO20xUq70pAQ/6s3rYGxQxpNs8Y20C//LArmR5dUX7rDMvs8HiU0tcKIF7ITmxHtqo7RqYpyJbXuSisb2SNpmvvEZBjq5se2r1YNw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dev Jain <dev.jain@arm.com>

Pass order to alloc_charge_folio() and update mTHP statistics.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Nico Pache <npache@redhat.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 Documentation/admin-guide/mm/transhuge.rst |  8 ++++++++
 include/linux/huge_mm.h                    |  2 ++
 mm/huge_memory.c                           |  4 ++++
 mm/khugepaged.c                            | 17 +++++++++++------
 4 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 5fbc3d89bb07..c51932e6275d 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -639,6 +639,14 @@ anon_fault_fallback_charge
 	instead falls back to using huge pages with lower orders or
 	small pages even though the allocation was successful.
 
+collapse_alloc
+	is incremented every time a huge page is successfully allocated for a
+	khugepaged collapse.
+
+collapse_alloc_failed
+	is incremented every time a huge page allocation fails during a
+	khugepaged collapse.
+
 zswpout
 	is incremented every time a huge page is swapped out to zswap in one
 	piece without splitting.
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bd7f0e1d8094..9941fc6d7bd8 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -128,6 +128,8 @@ enum mthp_stat_item {
 	MTHP_STAT_ANON_FAULT_ALLOC,
 	MTHP_STAT_ANON_FAULT_FALLBACK,
 	MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE,
+	MTHP_STAT_COLLAPSE_ALLOC,
+	MTHP_STAT_COLLAPSE_ALLOC_FAILED,
 	MTHP_STAT_ZSWPOUT,
 	MTHP_STAT_SWPIN,
 	MTHP_STAT_SWPIN_FALLBACK,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5eae85818635..00fc92062d70 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -621,6 +621,8 @@ static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 DEFINE_MTHP_STAT_ATTR(anon_fault_alloc, MTHP_STAT_ANON_FAULT_ALLOC);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback, MTHP_STAT_ANON_FAULT_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+DEFINE_MTHP_STAT_ATTR(collapse_alloc, MTHP_STAT_COLLAPSE_ALLOC);
+DEFINE_MTHP_STAT_ATTR(collapse_alloc_failed, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 DEFINE_MTHP_STAT_ATTR(zswpout, MTHP_STAT_ZSWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpin, MTHP_STAT_SWPIN);
 DEFINE_MTHP_STAT_ATTR(swpin_fallback, MTHP_STAT_SWPIN_FALLBACK);
@@ -686,6 +688,8 @@ static struct attribute *any_stats_attrs[] = {
 #endif
 	&split_attr.attr,
 	&split_failed_attr.attr,
+	&collapse_alloc_attr.attr,
+	&collapse_alloc_failed_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 59b6b89394a8..384d30b6bdd3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1059,21 +1059,26 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 }
 
 static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
-		struct collapse_control *cc)
+		struct collapse_control *cc, unsigned int order)
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
 	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
-	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
+	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
 	if (!folio) {
 		*foliop = NULL;
-		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
+		if (is_pmd_order(order))
+			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
+		count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
 
-	count_vm_event(THP_COLLAPSE_ALLOC);
+	if (is_pmd_order(order))
+		count_vm_event(THP_COLLAPSE_ALLOC);
+	count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
+
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
 		*foliop = NULL;
@@ -1109,7 +1114,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 */
 	mmap_read_unlock(mm);
 
-	result = alloc_charge_folio(&folio, mm, cc);
+	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
@@ -1876,7 +1881,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
-	result = alloc_charge_folio(&new_folio, mm, cc);
+	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
-- 
2.52.0


