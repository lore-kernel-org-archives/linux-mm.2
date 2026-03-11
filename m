Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE34103E2E6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 21:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DCC36B008A; Wed, 11 Mar 2026 17:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5426B008C; Wed, 11 Mar 2026 17:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 296126B0092; Wed, 11 Mar 2026 17:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9436B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:16:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1B47B9710
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:16:02 +0000 (UTC)
X-FDA: 84535039764.11.C363959
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id D7B7F1C000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:16:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HrUOpDGd;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773263760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VobxFUODDilxqzzhNxjHEs6f+gcQRP+GrHXHQvd38Ug=;
	b=FUb6jqA/vInV7jnM+m/7g9elNOREetg0EnOfHa09rBF95RNRHNyG+wDq9yV6+WjBuK/+ZR
	AUIhqBZHoN3t6e6aX5PhDF2o1B3mJFnxMIu0B+HDOiyLWobKHCkn8t7ahMr2JAEIDbTW6d
	/WnQwFFJMwHjFxuUhrbwBD9FvSNkZPA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HrUOpDGd;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773263760; a=rsa-sha256;
	cv=none;
	b=5040OwUgnSg+wYcTp+XSk3g6w/2masndN3N3MsbVcT1xa0XKk3Nx+qWQ3MmvsEvHYJJT5a
	++aBvt6uxooRGqgAqAKudieCnMooW1LEbN/amZmHjLHHWSswQCk0VcTnnOf8wVznjeZAx9
	fgsZ2blJxGbYEdCqmai4soObr3pqlHs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773263760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VobxFUODDilxqzzhNxjHEs6f+gcQRP+GrHXHQvd38Ug=;
	b=HrUOpDGd/MIorJqzU4OfK4fPvL53pJbXihFDaWVjbFaRZ0+ImZouzfytR7hRjHH/mo5vx1
	dZv+LUb87RZcvklcTK5Uoqr29P/VadRNZaAzOMfOTfZMevmKLnobtRaWFSgQ4TIMT1YZZx
	8UF7OTtnMxw20m1Rec07JjUl4K9T8Fw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-S12-pZosO-mSuBSYHI5DZg-1; Wed,
 11 Mar 2026 17:15:55 -0400
X-MC-Unique: S12-pZosO-mSuBSYHI5DZg-1
X-Mimecast-MFC-AGG-ID: S12-pZosO-mSuBSYHI5DZg_1773263750
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0A5F19560AD;
	Wed, 11 Mar 2026 21:15:49 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.89.69])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 280AA30002D2;
	Wed, 11 Mar 2026 21:15:36 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
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
	jackmanb@google.com,
	jack@suse.cz,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
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
Subject: [PATCH mm-unstable v3 2/5] mm: introduce is_pmd_order helper
Date: Wed, 11 Mar 2026 15:13:12 -0600
Message-ID: <20260311211315.450947-3-npache@redhat.com>
In-Reply-To: <20260311211315.450947-1-npache@redhat.com>
References: <20260311211315.450947-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WjVfILfFyv9w7EQ2F2VnZhG8Z8Bb34bdcfjzFK-5krI_1773263750
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: D7B7F1C000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 9ifrjwebch8rt4rzka1mfe49hrzesfg3
X-Rspam-User: 
X-HE-Tag: 1773263760-704782
X-HE-Meta: U2FsdGVkX19vk2DTGr7Kl8XNvHcCR1ZqQb+BJDsSXX/sei2C77fv2DWt8DGlK4z7ryR5zGujnsOtdMqxrHh88+gv5U3WpjWsG39T6fft1NaRMfOlZvjrNjFLG1j988Snsv1PIQvCWDcznHXknJZ91DJ/5Rlu7Fg6mXXYH6h/BoPJ65GAB94O2knCsEptIBscB/4zBge3e0k6zJyUntlrSllLvAsiCmOxWfgFoyizRscSs/JI7tSD9+9VwCQVB5xNVhqpG4bHV8OBJHuLyIiZU+ml08BuovVCo0Tbfj8qPg8J1xHojfB4biVz+6cQPJe4czMK3aJVOO1kYq7WR6V0tpluxeWpEudHJe/Zmc52QdFHZ4uP43UE3t0e7hSCqqo/6vaoWAaTV0Wz324MU9Wx9kFP9LvD7V2sjxyK95UEwuSH4aTLcY1XW1dtLxLZRLie/l+hxDScEFjiluuGIGaCMfumcZWusK+EPbgYxAP9QTjp3PEdNPewXz1bO8zRx4+shfh2k1RYKtBrPnaioLDcpOoaAn4SSNabFn1IJUYh5DgUYk1+kYHQ/P9ASAeeYJc5ydJYOhvOuSQ8PHHKigBQ9p+gEMbX/MzMtbHTTxkTth39L0kw1Bqe1REsdylWdAg4Pzf/VdgQ+LBg2s5IcxE8+gmZGGxMsDyq1yQOeuBa9P7sartdTdmgySWixWNjY2WMR0jSOWhvzUa8v/HrU3XLDCGmzgK6NEPQKGs+vH6Q6QTq7uA6R4C1X865G2MuxBalL7O0qq9fX3jepwzXgXRBDW52GcQvEzJ7x50wx+OD0UQeGKCMPy1OzfZ0bgdFXUWZPNOit3bkRhpOWyOTVxntI/9vBj5b0kOkku06xdXR0WLJJ8pNv5z+orapMH3b2qHPEp6TYtKI9yNPfdCW+Fb3BK8+VJNCk5gqKRVUdNmAxDUgT73hoM+1pJBjie1B2yr2E9TZwTSeelT2dPI56vt
 kwcHg5/o
 q5TAAsnBtAlmKxhJR/bMQvqeDhGXD0C1CXRY4jlN782+JdVFRNhkpu41DUoofWC6v5XKaFEqFhQ4S0LFMuMdTJoOiGGKl4c/BlkIDjmToP4HqE1T3miDn2doqrZKeLPf9zt0+AIQ+aAg1qB6+lqETfHSxst7crh+six7082jJMN03S2PRrY8ua0otr5qms9kiWd/HQAZb/bXHs4/W5g5o+NoNSwL/XZJfCQI2+E4B7AFjOo/lhK+QrTWNdfwp+TStQUSvur4Qkso+ic4aBcgVcD7yZkbLW3by510r39fwYTKp72uk2G+5UzZJKMmApu/oIROBTRVIQyPotZElMmGTEKiTYW+9WjwDm8E9O3qtqV9MaT2QahJSWwB+giu9sRf8G5VA4HAmA0gu3nMIhY1qgGA35j5UIL1KH+WdDcUEJvvc02UDaGNdNdPAW1lX8c9uU0u4g8BF3psFALaj6h1CxpvxOgKFWMWO2dVoxXhJjjWYmyIvanW6HetoCYWSG/Saato5/79LwkE3s99mpfhJR44rky1m35nBvQXwngHwtdxhOjst8sSR6dH9w97kVD8tria4BNyIYAKY5SKF08Kc33X8lfRMNGLBgW+Dk84PmoBeZ4I6Vofh0T5ID7g6WjDs3Ltd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to add mTHP support to khugepaged, we will often be checking if a
given order is (or is not) a PMD order. Some places in the kernel already
use this check, so lets create a simple helper function to keep the code
clean and readable.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/huge_mm.h | 5 +++++
 mm/huge_memory.c        | 2 +-
 mm/khugepaged.c         | 6 +++---
 mm/memory.c             | 2 +-
 mm/mempolicy.c          | 2 +-
 mm/page_alloc.c         | 4 ++--
 mm/shmem.c              | 3 +--
 7 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..bd7f0e1d8094 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -771,6 +771,11 @@ static inline bool pmd_is_huge(pmd_t pmd)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static inline bool is_pmd_order(unsigned int order)
+{
+	return order == HPAGE_PMD_ORDER;
+}
+
 static inline int split_folio_to_list_to_order(struct folio *folio,
 		struct list_head *list, int new_order)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7d0a64033b18..9968cde6f820 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4122,7 +4122,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (old_order == HPAGE_PMD_ORDER)
+	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b7b4680d27ab..d3bdec4ec61b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1532,7 +1532,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	if (IS_ERR(folio))
 		return SCAN_PAGE_NULL;
 
-	if (folio_order(folio) != HPAGE_PMD_ORDER) {
+	if (!is_pmd_order(folio_order(folio))) {
 		result = SCAN_PAGE_COMPOUND;
 		goto drop_folio;
 	}
@@ -2015,7 +2015,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		 * we locked the first folio, then a THP might be there already.
 		 * This will be discovered on the first iteration.
 		 */
-		if (folio_order(folio) == HPAGE_PMD_ORDER) {
+		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			goto out_unlock;
 		}
@@ -2343,7 +2343,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 			continue;
 		}
 
-		if (folio_order(folio) == HPAGE_PMD_ORDER) {
+		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			/*
 			 * PMD-sized THP implies that we can only try
diff --git a/mm/memory.c b/mm/memory.c
index 5c8bf1eb55f5..9ede3a31aa4e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5479,7 +5479,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
-	if (folio_order(folio) != HPAGE_PMD_ORDER)
+	if (!is_pmd_order(folio_order(folio)))
 		return ret;
 	page = &folio->page;
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0e5175f1c767..e5528c35bbb8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2449,7 +2449,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
-	    order == HPAGE_PMD_ORDER && ilx != NO_INTERLEAVE_INDEX) {
+	    is_pmd_order(order) && ilx != NO_INTERLEAVE_INDEX) {
 		/*
 		 * For hugepage allocation and non-interleave policy which
 		 * allows the current node (or other explicitly preferred
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 75ee81445640..c500def16cc7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -652,7 +652,7 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	bool movable;
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(order != HPAGE_PMD_ORDER);
+		VM_BUG_ON(!is_pmd_order(order));
 
 		movable = migratetype == MIGRATE_MOVABLE;
 
@@ -684,7 +684,7 @@ static inline bool pcp_allowed_order(unsigned int order)
 	if (order <= PAGE_ALLOC_COSTLY_ORDER)
 		return true;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (order == HPAGE_PMD_ORDER)
+	if (is_pmd_order(order))
 		return true;
 #endif
 	return false;
diff --git a/mm/shmem.c b/mm/shmem.c
index d00044257401..4ecefe02881d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5532,8 +5532,7 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
 		spin_unlock(&huge_shmem_orders_lock);
 	} else if (sysfs_streq(buf, "inherit")) {
 		/* Do not override huge allocation policy with non-PMD sized mTHP */
-		if (shmem_huge == SHMEM_HUGE_FORCE &&
-		    order != HPAGE_PMD_ORDER)
+		if (shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
 			return -EINVAL;
 
 		spin_lock(&huge_shmem_orders_lock);
-- 
2.53.0


