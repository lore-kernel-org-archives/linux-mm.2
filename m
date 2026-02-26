Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0799FD45FE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:31:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429516B0088; Wed, 25 Feb 2026 20:31:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDC06B008A; Wed, 25 Feb 2026 20:31:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D68E6B008C; Wed, 25 Feb 2026 20:31:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0CC6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:31:12 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D22B113AD6F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:31:11 +0000 (UTC)
X-FDA: 84484879542.09.97B5520
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id B8425C0006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:31:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KtnMfELr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772069469; a=rsa-sha256;
	cv=none;
	b=OSba0yus1hjf9Lj2GaPtdp1f0W+S9MNHl/rvoJXMeD9Wo54pB+cP6Zo/RcCky67fMqSBKL
	33xyXsPxp1esYF/Qp3QC/d2Dc3qa6c9PoECssDaPfbcg+xp3pGOB4SPUkAWFtpskzl0CX2
	dwyen+w4tj6RdvFbhBwTo1HTeAZYjTI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KtnMfELr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772069469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFM5ACWvZzUBi8NGbn5Vs1lsLXddFcAE8fhUo7LqxxQ=;
	b=ncM1is+h0zLUoxdoHrzDnp61qycqoNVpAl2+K4cRrbzsG+L6wP+iCP6Z9Z0qbfT2aV7BUe
	oq8IOf1RuD6Fbs+2DKL32h1msjrff1mMzO/+w2ZdP7P8hBO+5EZ7IpJNzq+kuMLbCRPky6
	kgiQ7ZJMolYlpjWSx+quuO8HPk2kKUw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772069468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MFM5ACWvZzUBi8NGbn5Vs1lsLXddFcAE8fhUo7LqxxQ=;
	b=KtnMfELrSA7ORJ0HUytr+MUPquAdTxuqrFcLhVtViijlf/syDXD788lg1MuamUtFt4wq/t
	B5L7VPIHXaiZNPdlq3ZQZM65O6U/TNyHAHxF8s/GQSpE0Crt6eqsThoMvwlcp8T8GfQgn7
	ZEfeBQxHXhzyDCMFgGFCM6ayLLNZn2U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-515--67Cj5ImOwuOffmixlpEDA-1; Wed,
 25 Feb 2026 20:31:04 -0500
X-MC-Unique: -67Cj5ImOwuOffmixlpEDA-1
X-Mimecast-MFC-AGG-ID: -67Cj5ImOwuOffmixlpEDA_1772069459
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE8BB19560A1;
	Thu, 26 Feb 2026 01:30:57 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 29A8C3003D88;
	Thu, 26 Feb 2026 01:30:39 +0000 (UTC)
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
Subject: [PATCH mm-unstable v2 2/5] mm: introduce is_pmd_order helper
Date: Wed, 25 Feb 2026 18:29:26 -0700
Message-ID: <20260226012929.169479-3-npache@redhat.com>
In-Reply-To: <20260226012929.169479-1-npache@redhat.com>
References: <20260226012929.169479-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Jq_0WpoVirjWlc4V00cr7AE7GWnzswPu91SkxhnpBNg_1772069459
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: g9te4ucbzqmct8y4gqpazcz4kg78n4f9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B8425C0006
X-HE-Tag: 1772069469-324383
X-HE-Meta: U2FsdGVkX19nLlCTQjRtrE0/Y7uLJrRaECLxzVY0IqifI/Povko4tJAjRPiZeuA0ak6yUv1no9EN2e+ng8eQjAaL7Hxnt5VLmQhX9jJ9XBYukzKWlWf7feZkooyUnstYEgsu/aeBQVQZgh54rk7zvxI3eOmzOgBRR9C69UTMpzBg/0DiHadKQlN+d2cTtbZdW/jIZ3D5MqlB15C5zrPKbmQ5k0Yh9eONWMRhmNQmAps0HtZVn9M4HWU/fzzqi/1+YLjsj6NpCxAAxsFN9NI53IpR5nGLXbXaje//tVWjkaOs7Q8WSInL01a0GfaeOzC2KxTpKj9K8g0MX+dmQpTmhF1ojjLhmDgrQnQWCEtZkhPBO+RXWGg3tzq2ZQbdNPhumi1nAUrpexgco6AGyW0vjJ8JpUZmSxZv2YShHO6NL/gSK3aN7o75k03c3L2BRbmB2+nPE5ph1VtajRVyy+oFO89VvgiVL8GFlV4qduzZ3lfxpXVllEu3JSI1Nl448NDT3Pht7nwgmqxYIfPl7nlSrlWe7IEXLM7aAHEm6odmMlM+/rgjO4PHsZxNZ3M4qlbbXId3Xc2SczRhcYwBGWErTOTNVq8N6oE2AGF7V3dEP4hD37EfFmnqAdqSVCsnpRsg38XNcFr0lRNxdm3V+gXzIp/oJTNJAGDV1ueSZKruzCypSKVp+GufFnT+P9LhyNEnDQtW8fGl7kTPasuujQLiyDukS/T/CFoBVPmzaiZ3LJfwUBkV//u7gIJCwZyCVoCvJ27nkwu0hFqqaJTv5OZ/TyARiZeEHKlMqPL0RcbEht7C2VZGOSCEtf/9tsMNhRP+5Upn8rvrRlKw50UAIqTD1td3sXJNiED8sy6SApK6woKltD/bTTNqAf/RwKmuYCBDCPm7VlTQZ1DI2Y3aiSBwMAQEneH2YVM5Otk+KRgeOTMbUkR9fZLmnPdlswZPgh4C8zp+r/s80PLs0EkdjeE
 frB98iL6
 cueOa4G4bppUiVA/vmAE19DXVMtej4G4WsLdYwmec0KMbFoDiRa2AkBj7uGf6eYbabEoKrNGLr8XXtNFQnOX6KbZrj1GwkcKR/f/L6YMrRvuhLTGEMbOvwdmpDFZYO59Ri/SnV8Ud+udwGe0qN8FvDpd6fr6SbKzKN9SfnYWjG7vPcAv3+DWpJyoRvK3QWU9XIoh7gEuGdoFZjvf+HyRbFSLWcCSOULKMQ/Eh8my+XVdCdMQKGTB/ENjwUvu26Ap2IrckYKhYfVMF22gsYDGJwv+T60QzdwofCvHs46hr6Jg9r4wvOrYd3PHx2pAPrchsiKD+A2k1JIc4Rdlw50PCsbTa6bYIN4B78tPoabxTf93kCnsfBG6w64liaDWqWQT5FuXlPXs/QpXJdEMjahjV4TUmiwjyOfin91B1LPoLH5QX7SiOdEaD79EXGT4pysNOKr8zW4W7+Yzpfs0Xz9hcvUQPv7xMWxJNJvYLubNpWASEGLH1hpslzEc3IWXWXiuoHriWlXak6WprHOz1uQwCyG+kZ8WMc7eCC+gFNzR7EuPRA6A=
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
index 8003d3a49822..a688d5ff806e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4100,7 +4100,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (old_order == HPAGE_PMD_ORDER)
+	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c85d7381adb5..2ef4b972470b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1533,7 +1533,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	if (IS_ERR(folio))
 		return SCAN_PAGE_NULL;
 
-	if (folio_order(folio) != HPAGE_PMD_ORDER) {
+	if (!is_pmd_order(folio_order(folio))) {
 		result = SCAN_PAGE_COMPOUND;
 		goto drop_folio;
 	}
@@ -2016,7 +2016,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		 * we locked the first folio, then a THP might be there already.
 		 * This will be discovered on the first iteration.
 		 */
-		if (folio_order(folio) == HPAGE_PMD_ORDER &&
+		if (is_pmd_order(folio_order(folio)) &&
 		    folio->index == start) {
 			/* Maybe PMD-mapped */
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
@@ -2346,7 +2346,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 			continue;
 		}
 
-		if (folio_order(folio) == HPAGE_PMD_ORDER &&
+		if (is_pmd_order(folio_order(folio)) &&
 		    folio->index == start) {
 			/* Maybe PMD-mapped */
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
diff --git a/mm/memory.c b/mm/memory.c
index a1a364e1fdcd..cb76fa182eab 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5427,7 +5427,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
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
index d88c8c67ac0b..96ffb47bcfee 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -687,7 +687,7 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	bool movable;
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(order != HPAGE_PMD_ORDER);
+		VM_BUG_ON(!is_pmd_order(order));
 
 		movable = migratetype == MIGRATE_MOVABLE;
 
@@ -719,7 +719,7 @@ static inline bool pcp_allowed_order(unsigned int order)
 	if (order <= PAGE_ALLOC_COSTLY_ORDER)
 		return true;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (order == HPAGE_PMD_ORDER)
+	if (is_pmd_order(order))
 		return true;
 #endif
 	return false;
diff --git a/mm/shmem.c b/mm/shmem.c
index cfed6c3ff853..ba74803c7518 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5558,8 +5558,7 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
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


