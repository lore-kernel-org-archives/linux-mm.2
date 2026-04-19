Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C0BEEA7197
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 19:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740D66B033E; Sun, 19 Apr 2026 15:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718F36B0343; Sun, 19 Apr 2026 15:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F406B0344; Sun, 19 Apr 2026 15:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 52DD36B033E
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:00:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0531C5A43F
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:00:52 +0000 (UTC)
X-FDA: 84676222344.05.4F0E225
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0254B4000F
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:00:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LS8BbeHb;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5y8r7AkwzRx/e6vsiKDBu5x8M1bLOvW6Rbo+RlaDBGg=;
	b=XGJ1rOkMMvnSFry5m1Dc/Hyws1K9I/QnjLP7H4zjtEjdi4PtrhGLWpZPGejLBuB1mAHQe1
	VWdM9CmTHzO1wCx+47Gy/vBE2cFH2DVgPrLqa/cPdrKYyIlDmwJFZUPCwjVyGBr/gk/mHv
	eWIx89nrGI+0Yseed1W4sZZmEoYwRwA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625250; a=rsa-sha256;
	cv=none;
	b=71Rs703J9cKa4i0CERwPEFTk4AMldyKw/IskPViRc6OQ7t7ckU87DKzAbz5mlGD2FAkg/+
	A20Q5RBT+sf3gTxwGqw2sFL3Bqyzq45SI1QuyTwGV94rdgX+b0QfT8n423+/3YMizONsDe
	5Gle5L4zbTKU4JpkdVMwCILLwLdUkNU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LS8BbeHb;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776625249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5y8r7AkwzRx/e6vsiKDBu5x8M1bLOvW6Rbo+RlaDBGg=;
	b=LS8BbeHbsLKU9VAUfrW2fcO0Q+rUwmfzWoG9ESlMK8KdZz7WMOR/GnqiNtpy8IOsf5+SJl
	C6m8LTn3rmGzV7apv604fBq0AFl707EupOkvblwxxmiWrvqpwoRSKrnwPqbgD4mRQrLe4S
	ceKcAG9X1q5SvaobH1fipbqfme0zJYY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-191-i8D0uq5eM9KGKhRNoSsvJg-1; Sun,
 19 Apr 2026 15:00:47 -0400
X-MC-Unique: i8D0uq5eM9KGKhRNoSsvJg-1
X-Mimecast-MFC-AGG-ID: i8D0uq5eM9KGKhRNoSsvJg_1776625242
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ECFE1195608D;
	Sun, 19 Apr 2026 19:00:41 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E2286195608E;
	Sun, 19 Apr 2026 19:00:24 +0000 (UTC)
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
Subject: [PATCH 7.2 v16 07/13] mm/khugepaged: add per-order mTHP collapse failure statistics
Date: Sun, 19 Apr 2026 12:57:44 -0600
Message-ID: <20260419185750.260784-8-npache@redhat.com>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bRFm6dgZbqXhG_y0olUeLeYbKXcZ_KyxHygO3qhcPeY_1776625242
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 0254B4000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 6ogurpx1mxzwc3owcu6km91rcbxfntzi
X-Rspam-User: 
X-HE-Tag: 1776625249-247009
X-HE-Meta: U2FsdGVkX1+kIJ8xbVB2AYn4mK84bfSPynGt0Y3df90n3OMs60hZpyleqYSKzbwyeeOgNetP39kQqflLXl87K7hj23iPTj5QqIKk9UsN+Hmoibe6VGTELxV73zrZJ8Knb5BcOw7KrplQS2f7d0GiQdkhxKjNZq0IvBV9KPEJPxr3VNcaYeq2thz7D2r4k2LaP3euR33yk3katircSZf6vTbExP8acBnpLK88NKveKnwIERzjcBFB+/e7Hk9qWPWVxTBoLeAe2XXqQ+HANogRD18k+YPfhb1i40NSpa+XhmdxDJjQP7Rf+UCTtOQaAyZ2vOp+rQlvD3ztovU2/6THIKRObXaanbqpcT2Tljt59svuQ8zz6qBucsQM8AA6VCQX4rmBrnG0cLVxK86bIWXMmqofqIEefFNsV6BBuOasIoNneuNsjRsPC/fbC5Tih7FgnJInwfhY6/sZx082RpL3BgXtKfQA3PxlYcXHCAizwtZf3OPYXuLBnDCS4IyTtQxakvTTzMw+ZyftCaNE91R9dNb7iHNhoxOx4BlSXInuSh7B8oBLCIGa3TksD5x62Ct0pBo7U41baZ0vHBcuMuetrf1hqAuuZgq6nR5og0Hs7jkCeEJsNL4Ty8VPMoLV8pE+PBfAqldZXocdnkVBWrR5hpUyStvoqag8xYcM5hJ+sMhIFitXY6Sz70IM2rbI6WZt7KmZFHiIuzRofbJj0BP5clJrklALsbk4Joz+k1V03lOx3F/647yfJsQHw6rXnhZL3RtzBvmcGx2948Io6dXDif2MIKyImerwj05Kw4evtx6OZ6znluNrrvxSIQfCRlUO1TWK8DCz0MbE/hQ8TGKJZDuJISXggk6OvzSlvVDX0XNy6qQO0bW/+Dm8D4/o70iM633NelAup7N4+UC8p+zJbvwoRqNwnT+RotM87DsTQuJgOXzARktnX/BJg3vhvYOlMzpr7lfB0D6YxOjrSsg
 CUgw7S4S
 pNWrgpQbbDKKnbiDQ2Bf7tzd2pb0AqngnyUsWmHxJAYkgf9z9VAkOknOBeefmojmLE/IgyvXncZDIAaXI4pJbRodXO7EWoOss+z8fq2XS7CPzuywoDdz3qwJoP49DoBEWiUvNuSLgqXKbzQaXWtAv7I/Z94N7LjPCg0i8o4FqxW+pZFZcDzpjznZXjt43V19wWSw5hYle1GBEl3/FrtXyOkwsfUMwNrJJgtAviglL3F9Np8/KTMSM0CPTD3yOBXABMGWX96VMgK7ZKHfCG4e1hKAUN0395Ylnbsgqj2Q+lfgIYFJeUtTFjm2lkyoe7jaSdWLG15K9z42yFLTF9Jc5E3mCP2dN7s+DPW2BJl0qghaEh5bUOF7qHn47uN3JDkWLvCtbkjVvGAIrsTjspiitFFpwZsnBzcZz4Pv/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add three new mTHP statistics to track collapse failures for different
orders when encountering swap PTEs, excessive none PTEs, and shared PTEs:

- collapse_exceed_swap_pte: Increment when mTHP collapse fails due to swap
	PTEs

- collapse_exceed_none_pte: Counts when mTHP collapse fails due to
  	exceeding the none PTE threshold for the given order

- collapse_exceed_shared_pte: Counts when mTHP collapse fails due to shared
  	PTEs

These statistics complement the existing THP_SCAN_EXCEED_* events by
providing per-order granularity for mTHP collapse attempts. The stats are
exposed via sysfs under
`/sys/kernel/mm/transparent_hugepage/hugepages-*/stats/` for each
supported hugepage size.

As we currently dont support collapsing mTHPs that contain a swap or
shared entry, those statistics keep track of how often we are
encountering failed mTHP collapses due to these restrictions.

Now that we plan to support mTHP collapse for anon pages, lets also track
when this happens at the PMD level within the per-mTHP stats.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 24 ++++++++++++++++++++++
 include/linux/huge_mm.h                    |  3 +++
 mm/huge_memory.c                           |  7 +++++++
 mm/khugepaged.c                            | 21 +++++++++++++++++--
 4 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index c51932e6275d..eebb1f6bbc6c 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -714,6 +714,30 @@ nr_anon_partially_mapped
        an anonymous THP as "partially mapped" and count it here, even though it
        is not actually partially mapped anymore.
 
+collapse_exceed_none_pte
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_none threshold. For mTHP collapse, Currently only max_ptes_none
+       values of 0 and (HPAGE_PMD_NR - 1) are supported. Any other value will
+       emit a warning and no mTHP collapse will be attempted. khugepaged will
+       try to collapse to the largest enabled (m)THP size; if it fails, it will
+       try the next lower enabled mTHP size. This counter records the number of
+       times a collapse attempt was skipped for exceeding the max_ptes_none
+       threshold, and khugepaged will move on to the next available mTHP size.
+
+collapse_exceed_swap_pte
+       The number of anonymous mTHP PTE ranges which were unable to collapse due
+       to containing at least one swap PTE. Currently khugepaged does not
+       support collapsing mTHP regions that contain a swap PTE. This counter can
+       be used to monitor the number of khugepaged mTHP collapses that failed
+       due to the presence of a swap PTE.
+
+collapse_exceed_shared_pte
+       The number of anonymous mTHP PTE ranges which were unable to collapse due
+       to containing at least one shared PTE. Currently khugepaged does not
+       support collapsing mTHP PTE ranges that contain a shared PTE. This
+       counter can be used to monitor the number of khugepaged mTHP collapses
+       that failed due to the presence of a shared PTE.
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
index 8740d379882e..0a1c7cc20c0e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -646,7 +646,9 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
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
@@ -680,9 +682,17 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
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
@@ -1129,6 +1139,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 		 * range.
 		 */
 		if (!is_pmd_order(order)) {
+			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 			pte_unmap(pte);
 			mmap_read_unlock(mm);
 			result = SCAN_EXCEED_SWAP_PTE;
@@ -1412,6 +1423,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			if (++none_or_zero > max_ptes_none) {
 				result = SCAN_EXCEED_NONE_PTE;
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_NONE);
 				goto out_unmap;
 			}
 			continue;
@@ -1420,6 +1433,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			if (++unmapped > max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 				goto out_unmap;
 			}
 			/*
@@ -1477,6 +1492,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
+				count_mthp_stat(HPAGE_PMD_ORDER,
+						MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out_unmap;
 			}
 		}
-- 
2.53.0


