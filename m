Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273F8CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890AD6B00A2; Fri,  5 Jun 2026 12:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841B96B00A4; Fri,  5 Jun 2026 12:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2C96B00A5; Fri,  5 Jun 2026 12:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 599D06B00A2
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:16:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24B6216276B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:16:31 +0000 (UTC)
X-FDA: 84846361782.29.E544284
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B798120012
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:16:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YvsAQEec;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c41C+aUCjryZaKfFd1hJe5PThl4zuDF1MGYxzScNCi0=;
	b=HT5YV0PDT3Y47X0oDvoaE1Y9y4z269nnYk2J6n8ecSOuJJN7hMuSBw/dZo2gG4LAuQ101N
	VuiquYhAQliCuXUbHJxo8xGLl5q/7aLhkF7tI2iJBdRr50fIjZJUPvQIngsaL2VjOXg6fC
	eztswKztw75YDYBrLk5OstA9ShNWH7Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YvsAQEec;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676189;
	b=egs6aNipTSWXTW3Qexy44BpjEaEX4NmYsQ1PlBS83+mJc1UeOnNnS5zuKqYQsqA5Xp/S0a
	/PBZf3EgTzcwnkHN1MzzNQgyCv+LQ9sg4FfZUY3i3PnFhKbufNXcE234t/P7xaO8ackDnI
	7d8rDwWQZMLohVhwU2So/gwn9xsa8+I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c41C+aUCjryZaKfFd1hJe5PThl4zuDF1MGYxzScNCi0=;
	b=YvsAQEec/+/FPrNwjlEGFpGHVhGbYJ88OmVsCg3ZLTvN6Ctep5KuByEoVHGxd33AsTzK6f
	XbNIM/vvEgKx7YpETHCictnb9FnIt6+mg5Ukz8izuA7bQNpvSpskQC1vMtCltIFpMdZuGN
	JFXpnKjDhqJ4gEBFYuEMKMx1khxOnt4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-529-VUvJV_pRPzG4_wIOTd0_jQ-1; Fri,
 05 Jun 2026 12:16:24 -0400
X-MC-Unique: VUvJV_pRPzG4_wIOTd0_jQ-1
X-Mimecast-MFC-AGG-ID: VUvJV_pRPzG4_wIOTd0_jQ_1780676176
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41A751956089;
	Fri,  5 Jun 2026 16:16:16 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CD408180049F;
	Fri,  5 Jun 2026 16:15:57 +0000 (UTC)
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
Subject: [PATCH mm-unstable v19 08/14] mm/khugepaged: add per-order mTHP collapse failure statistics
Date: Fri,  5 Jun 2026 10:14:15 -0600
Message-ID: <20260605161422.213817-9-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Hy6k1vGWLgghUvRaCJQXmVVMBZs4RUWRy1CGpRoD858_1780676176
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0B798120012
X-Stat-Signature: jd7n4qhr7kyusz1haz8dsjmsdbf3b8ri
X-Rspam-User: 
X-HE-Tag: 1780676188-680398
X-HE-Meta: U2FsdGVkX1/5803Go4yARbDoB209YuCENGbrgUCHkRqwpQCJkTK2UjPoD+wFBDg0SfYB2Y3O29x1eii8X0Ah49Jfn3URRomsYOV94SE0i+lh8Buc+AngfaO9YEzNdDvJ9f2i7Xt4f9qi9eTeVRNdN4Ga4oPKP4oVUUb1n8FrPAUWL9IRPJ2Gnf+x0LRp9AE+FuwmDzzOvfDisIKSGX+cFqgxbMDVp6u/paWtSlFOg/DkfdNjilYqTv1AnNHaTHC3LK9jjfKBTLPF3CRPJCWu1M9Q2iw7ocQK/vnjKeDjTA6OSsTe0EPTK+Q4/LsKxlvWbFYVoMIM0t91IjA4RZ9JI++KIkeMBFWEVWVySEkxpYRL5T9WD9MBLvKI5u3OXsJE0J4ehWFkb/udBTtU6U7kwxVWKniqdoQj3X+DKTAU8d4BhHjlC2wi/vzH22qNB1kQEEXignfQ5HSj9Sh62u4XhGmr5gXfUsOxm98Qb4av/MW2MLeJZU7ETflppnoA20MQtf3aNniGvSTvY0MB7I03a/ZBqFWpJ5MyXgnKjZwjyTI90krZjA33rt+U8cBXY7ASrbJg228NxbfwKZDv4+pDND+vH0RjWS0eJzLx1qWEjTSaHIQJRO/V8xeNADOz6gFQaXs0zVv4lyBAMp2H5wnvdCD/wBk1rboyAScRBfWheUvS+D8dM+DwVmgUYxdjPOmOv+V92ausS9Lf73SBs549REWK6OyTUyrO6A9AtYi2YM2EDo1gXPLqhOgL3PE+fKDgz7BP5j9DzfpayDquHmZLMUGH0qjMyFALama9HVExauQVYvXyKeDbFNabBtq9STMnZQw3tWYv6WocNQ/UdxkJ38UE96xRzE8MBBGr0aiuEaSHsMsTXM00WQuNW4Gn1K2ttrbiMkZWjzU6gzBPOoaEn3xLk+EczABJZCFRUBtBJoekEq36rwtCvcaUV5xN93rF4GV7ZBjsUF7ttWJsrZ1
 2Zn9OEE4
 1D36fyX84EVobOwU8ge65SohjrNkh7LtdsWR/4weOTc/XWT7JKpyyj7ejeuEtzlTGdTKFsGRFxKuJU6JaGhgeHZZwnStovhiLaoZHBe2MkN/fuojZ64JSQ6zZRHebTzJzZuH18L8gIUPTqJAJrl6FlFBu46ILFoaCxycjEuG9f+IT5rDhQ/YYeC6nb0um0TRk06kY0qBDQQNdHwd1+WFwaGiyfml0mLd3ShAIYWrnUwkSBL0PP2Xv+SUWbF0dFJIDz1Q1bhvqpLaN2lXy3+qene6ifoGYF5QfCdJj2N6unQdyGzhAc6AmHbUL5Utgc3I1Q8QDpPJ4JEXkZZ8W3IbB1TloCNbUHztBmkwufUmwVf5GoIcqFVP4FPMegRBSf7aMjiWo0wzzc97AXtMJzT9RGkY4It6cJGzjkHcKeLalYoJG+mDMTq1+Ux2n8A==
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

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 14 ++++++++++++++
 include/linux/huge_mm.h                    |  3 +++
 mm/huge_memory.c                           |  7 +++++++
 mm/khugepaged.c                            | 15 +++++++++++++--
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index a74844e01f1e..b98e18c80185 100644
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
index 443852423790..148109ebd08a 100644
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
index eea83da9114a..222e421d9e8e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -717,6 +717,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
 DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
 DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
+DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+
 
 static struct attribute *anon_stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
@@ -733,6 +737,9 @@ static struct attribute *anon_stats_attrs[] = {
 	&split_deferred_attr.attr,
 	&nr_anon_attr.attr,
 	&nr_anon_partially_mapped_attr.attr,
+	&collapse_exceed_swap_pte_attr.attr,
+	&collapse_exceed_none_pte_attr.attr,
+	&collapse_exceed_shared_pte_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 191e529c185c..ac4731addafa 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -651,7 +651,9 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -693,7 +695,9 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			 */
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
-				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				if (is_pmd_order(order))
+					count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out;
 			}
 		}
@@ -1152,6 +1156,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 		 * range.
 		 */
 		if (!is_pmd_order(order)) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
@@ -1459,6 +1464,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out_unmap;
 			}
 			continue;
@@ -1467,6 +1474,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 				goto out_unmap;
 			}
 			/*
@@ -1524,6 +1533,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
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


