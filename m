Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2016CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55B726B00AF; Fri, 22 May 2026 11:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532D16B00B1; Fri, 22 May 2026 11:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4499F6B00B2; Fri, 22 May 2026 11:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 341356B00AF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:02:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6AC81C1FFC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:02:41 +0000 (UTC)
X-FDA: 84795372522.23.DC01DD9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 75FBF1C000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:02:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F23UPrlp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/C8PY94GSpJ6xmfMZMGQDwcUgEw3YhE561RWk3Turdw=;
	b=LrTgCz+PTQhJP4cmlNQezNapszuCr7tONpVMu2w1YzUTBupybKffD/NguPD2pf6jGZhVh1
	NxomSkLVQqJmtqcLUIXasmfG4EhJ81UhGyTkwEUJESp/AuQtBfaVMHviC2xrOl6b0ttmEB
	ZEAkaeWdGH+bBCwwlHB6R2iJQyOFzAs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462159; a=rsa-sha256;
	cv=none;
	b=Pm9JzSW/4ehaM65BEtqlfNXmzsq5beyg6dDXHK+1BozOV6q+xucYXw5EwNRSNbBYsjCtUr
	SiPflG4sjitmLa9Be1OatdeRuDtIW6k6LeIsXT7ebX5n7aMvv+iOpsY9BItkQ5BG0KIAl3
	HyL+WivMLo70OmoBslR8lX2ZcCnNmB0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F23UPrlp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/C8PY94GSpJ6xmfMZMGQDwcUgEw3YhE561RWk3Turdw=;
	b=F23UPrlpKQyVD2akpz0VBrl694YLf+2haLEJH+HiOenaIxcM0a+Q8vsXaziCVHfQ9v3fL8
	37LLg0MINtX2+B8Dr8E2dmnxBx8NgzkBtdbxEpt6fIAnlvB2daTEDov9SQ9YA6MlvSVmNt
	Ems1vE8LnxM2R+T4rqgHodfqK57BuaQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-416-qrCwiN4gM4eipS4Bf-aj7g-1; Fri,
 22 May 2026 11:02:35 -0400
X-MC-Unique: qrCwiN4gM4eipS4Bf-aj7g-1
X-Mimecast-MFC-AGG-ID: qrCwiN4gM4eipS4Bf-aj7g_1779462148
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E60891956095;
	Fri, 22 May 2026 15:02:27 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 11C75180034E;
	Fri, 22 May 2026 15:02:08 +0000 (UTC)
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
Subject: [PATCH mm-unstable v18 08/14] mm/khugepaged: add per-order mTHP collapse failure statistics
Date: Fri, 22 May 2026 09:00:03 -0600
Message-ID: <20260522150009.121603-9-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7B489bwAGeSZmCRseeIsQvGFF0QzI6vBT9oyMhG4AIQ_1779462148
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 75FBF1C000D
X-Stat-Signature: um6uxkmd6rm41ursz965tetu7sb9ti9m
X-Rspam-User: 
X-HE-Tag: 1779462159-820463
X-HE-Meta: U2FsdGVkX1/b/I9t1gwCRU9T6TOuZUNhTAmfxzVD/RyKsyAdcLGWuLxnltZdURNTobipchidQCBKwfdBBWR9iAzqbvku2H8pyf8E0TNEd9NOkrQDKeAx00P/3qcOKnlVlW+ItmAw3T9Dc/aoOTZYd9oz3eyZCpdPfkxJx6UnhfzJzZW17OpRwvLOvmzTAtUStSQaKsixXOa/w3R+T+Rtwg6yOEtwDNKbyjNze5lzUNkGrWogquavDSpGiZ8N06CsAyNlLxN5le493bLqcYO9sMy8ygricxEYbSSGNRHWcDXhrdk6s/AFhgs9ILT9Olrvi11l2jZoOqvJ31ihLhTGEs9j+d/TQ8R0cvV/l8bvpYTcipeABbgLHaQLfDgkrY5QQHRSxaYbqS+fR+VUDR1gtqPlyWlxE/xXGkpI24sRAh2Mksq+OGUc6nwVX329RWnfvm38OJBTveXdlIvDQ21Yg+iyotclFJc4R+u5YIvvH7xtfCAkenczULh1YcX3TJkS7E2cMzeoKXBKEfWFPJdaUxJKqCJyjjGt89OGiG0RhjGSH+cPmk5+k+ygCYeIfuxLhI4r8RvkiWlVjoeDTIYxPCm9RDipboIt3dpV3jIX/rprecpEZkKBbw+VbXgwV/vyWus7Wur9P4lbTtz+gRoI4OngiiV2QENyiqaH212dsgKmL4aBoQIm0zdSZ3xhv4LUTbv7MbG36Yq+0A52fp8Dt4A2TlWZvXE93EBhN/Df6W5Q0h5oNrbsN3Trga8lfs05zk9BngoTg2qwtCaYmWLgH9PyedzCqAHYT5JoWGxrY+D3XyWrfYuHJjEMvUyN8Sgo9UXF9xGg44oAB1ELEseOyPCFiFxVbbVohKCP+zj0nv9fOzVrwGVJet8P2eLtqNMHGOU3WkdIJ+lh3uPAvua9k3i0RQMWYBuWvfiwrJRCggAoQvCOaGWFejjuCEksbL6xAS9rsbno7a7+kiXgA1C
 BrJmN+Km
 5qf+jPHwSLgPea/94iIQMT/7/Dq4Hv8PxtM5zxC5OoGbX9Pk489pgwLVIAW4/3bu/5bWDmtMSdHuRNH6pLD+UaKT2kDQY1DeZTFEtZ5QTgbdISJxmhVSELNBDLbwpqEEQ593af5GVys47CGyaxO1JW7cfKc9WO4rXdk4Teo8MjH/uV8M5IodXyJbMLLY1szpmWTZMLWBnhYk4LsEmVH3vwTzF5P6axj9ZudyXIcSqMZ4JDCHnj5p6ursnXKxfENBag6xl9m2Q6saLoFRAGyAG1P0DoCj5AE5K7HOzN7KLeEWaVYF0/CTs/Vy2afHEan9KkS+tVtM/6h6A72CUXSx+wM123pvPqWlTHciBLgKknZgHReKr0CLQD2mtoAzE0DhiGnaPtKoEDZ0VZF6MaOTEok5rS17+xbZzyniU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add three new mTHP statistics to track collapse failures for different
orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:

- collapse_exceed_swap_pte: Increment when mTHP collapse fails due to
	encountering a swap PTE.

- collapse_exceed_none_pte: Counts when mTHP collapse fails due to
  	exceeding the none PTE threshold for the given order

- collapse_exceed_shared_pte: Counts when mTHP collapse fails due to
	encountering a shared PTE.

These statistics complement the existing THP_SCAN_EXCEED_* events by
providing per-order granularity for mTHP collapse attempts. The stats are
exposed via sysfs under
`/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
supported hugepage size.

As we currently do not support collapsing mTHPs that contain a swap or
shared entry, those statistics keep track of how often we are
encountering failed mTHP collapses due to these restrictions.

We will add support for mTHP collapse for anonymous pages next; lets also
track when this happens at the PMD level within the per-mTHP stats.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 14 ++++++++++++++
 include/linux/huge_mm.h                    |  3 +++
 mm/huge_memory.c                           |  7 +++++++
 mm/khugepaged.c                            | 21 +++++++++++++++++++--
 4 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index c51932e6275d..80a4d0bed70b 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -714,6 +714,20 @@ nr_anon_partially_mapped
        an anonymous THP as "partially mapped" and count it here, even though it
        is not actually partially mapped anymore.
 
+collapse_exceed_none_pte
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_none threshold.
+
+collapse_exceed_swap_pte
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_swap threshold. For non-PMD orders this occurs if a mTHP range
+       contains at least one swap PTE.
+
+collapse_exceed_shared_pte
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_shared threshold. For non-PMD orders this occurs if a mTHP range
+       contains at least one shared PTE.
+
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
 huge page for use. There are some counters in ``/proc/vmstat`` to help
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ba7ae6808544..48496f09909b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -144,6 +144,9 @@ enum mthp_stat_item {
 	MTHP_STAT_SPLIT_DEFERRED,
 	MTHP_STAT_NR_ANON,
 	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
+	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
+	MTHP_STAT_COLLAPSE_EXCEED_NONE,
+	MTHP_STAT_COLLAPSE_EXCEED_SHARED,
 	__MTHP_STAT_COUNT
 };
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 345c54133c83..5c128cdec810 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -703,6 +703,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
 DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
 DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+
 
 static struct attribute *anon_stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -719,6 +723,9 @@ static struct attribute *anon_stats_attrs[] = {
 	&split_deferred_attr.attr,
 	&nr_anon_attr.attr,
 	&nr_anon_partially_mapped_attr.attr,
+	&collapse_exceed_swap_pte_attr.attr,
+	&collapse_exceed_none_pte_attr.attr,
+	&collapse_exceed_shared_pte_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 928e32a0d4d7..fff6a8fbf1d4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -649,7 +649,9 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		if (pte_none_or_zero(pteval)) {
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				if (is_pmd_order(order))
+					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out;
 			}
 			continue;
@@ -683,9 +685,17 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
+			/*
+			 * TODO: Support shared pages without leading to further
+			 * mTHP collapses. Currently bringing in new pages via
+			 * shared may cause a future higher order collapse on a
+			 * rescan of the same range.
+			 */
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				if (is_pmd_order(order))
+					count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out;
 			}
 		}
@@ -1138,6 +1148,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 		 * range.
 		 */
 		if (!is_pmd_order(order)) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
@@ -1433,6 +1444,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out_unmap;
 			}
 			continue;
@@ -1441,6 +1454,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 				goto out_unmap;
 			}
 			/*
@@ -1498,6 +1513,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out_unmap;
 			}
 		}
-- 
2.54.0


