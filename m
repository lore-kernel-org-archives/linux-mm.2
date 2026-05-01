Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9ABCD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C8466B009F; Fri,  1 May 2026 15:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E126B00A0; Fri,  1 May 2026 15:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE63C6B00A1; Fri,  1 May 2026 15:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D40DD6B00A0
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:20:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FA2FA01F5
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:35 +0000 (UTC)
X-FDA: 84719817630.17.DA67C5E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id C2E71140005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PYZyTE0K;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8y7DwT1Mvod+Su8a9kqNPeVGjZgNT6OWk7sX0RRnCo=;
	b=ut1YneFTGrmvkSGaIRzP1fPC+B7VtDV18e/zsDOf34R/U4id83aeoQlCH5aYoYGpLl20Bk
	+z6ZNeTcqFzL/sI+vUwv12Ph4pEE6zrCuM58HO19m+b2MbKnO/pb7TyzWtfhv1uIDbD87S
	D/NP2zAcS0cHEV0GhCbz5UqBGYMPc9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777663233; a=rsa-sha256;
	cv=none;
	b=eYe+Q5VfMRdZvewG9zkgh0jUo+sttQVnE0AabVLR7WL3RGh9OSCTpzhdCGIBCFLYL52ak5
	CjlqcEx+CmbFwh2hzd9zg9U/edmUJpQqn8RzxQc24GLGPAzP8WOR7lj14PWjqpZmKJo9Ve
	LAPcMb4pZ9yZbufxL9IDyOGk7jV1zjk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PYZyTE0K;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777663233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+8y7DwT1Mvod+Su8a9kqNPeVGjZgNT6OWk7sX0RRnCo=;
	b=PYZyTE0KfRvzLEMD7S7BASw1tq9iStJiPt3IaXk+uba845tbhaBlm1YZkrsAIfbEav4dWe
	NQOlskMyi6npUar3pgpuopfRaGd9H9/mZmMLXppYVRvvSC94QXy82AtHca+nF5KrA/xY2V
	KfxiFjQHAsdbp/h3EhfqSrq6tEe+dGU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-102-xmOm1cvmMIS1ApbmwSCO1w-1; Fri,
 01 May 2026 15:20:29 -0400
X-MC-Unique: xmOm1cvmMIS1ApbmwSCO1w-1
X-Mimecast-MFC-AGG-ID: xmOm1cvmMIS1ApbmwSCO1w_1777663227
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BBEC5195608B;
	Fri,  1 May 2026 19:20:26 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EECEF1800480;
	Fri,  1 May 2026 19:20:23 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v4 9/9] mm: thp: always enable mTHP support
Date: Fri,  1 May 2026 15:18:51 -0400
Message-ID: <f67da00a825da9097b5faf2f390ad344450b88be.1777663129.git.luizcap@redhat.com>
In-Reply-To: <cover.1777663129.git.luizcap@redhat.com>
References: <cover.1777663129.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: wlhwLMJcysbfYGzN0DIB4wsAqBLkvR1_C29C2yslclE_1777663227
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C2E71140005
X-Stat-Signature: 34fxqeiihsieppj7fpe3ezur34ikeins
X-Rspam-User: 
X-HE-Tag: 1777663233-673046
X-HE-Meta: U2FsdGVkX1/fOAY+kq4goiBcAq3EXgIWZlDzqjRLyX5Xq31fsUVLGQoA4ICNnqs/QaubeauY1RTbElmDl0jUqX0xMZwxJ8M89gRZaHX5kN/aBo5wQTBDRiA0CZxmUyPqKwe8A5tidjGB3naEfDd7miP6IhInHkgBWFUrmUvkXGDXYt0FKgYI1TYeY/AEB0Vtf4dytGTm+CoyLPPMMPX6S7Rh+G0IvZyG6BuFcI/kI1ypVtt7gssEHXZEJB0lA0hNoTadqHE9ViyciS3cxyKKQb1G1J1XrBAOWI+EqTAjYq7TYRf1kaw1xkhvb7GcCmfHakeAICALluFLF8c4MXqbt2LM/a3+hmzdzeRXd/VIwQkSdQLsY5J48hl9Qy+N2FcTV1gK//6HIiB8ek6h7+kJ6ySmb5jm9bxenUJqSNy7Llz7FauX+jHOtYZ2nmUTXUeqI4MDzNEsbGG07oFnLnDfONaARNpzunmLVvDy4NJmyZNv6HedwkTjtsH05KyzyujQ3vIkrQVRhInUJj1ONkQkqCc5RhC1Vrq4kGbxMDscfHX8DjUMPsxWn/OCmgdKIwJ6+E/kNVqhFHCRYYazDI5HjzHuSvTqCNukyiCmfkVW6IuJorG8x16gYsXomiKp8LbIdvek5raU75e5yOy1PX7rlS2L2FO6OrgClKcN9JR4+OR8sHFHfIetUNuIhEdXagoQN2gFRMdUsb9sbHwtsLWFxh+upZ4/dX5fJQmOWf7rHo2WxBIae8maybwlvSqyEzE+WXJvzUQ9hAAqcKgmii0NEmSxjGLFIzdS6Beoc3HvFcHL9HS5Nx2OzDIN4lPtttGeAQFvOcCfwTJDxXTulXw/WHVOzBGFUYs6nTDJ5nyBFwSB/a5Kg+ywXeDvwf30Ji09U9eVUmvWN9yzN88tK+ajOBqBzhXEUbd5e7zsv1r1q15tzZCxI6adO7Pmoe2yoYxeN86uP+5RYIUFHlQKxHJ
 112Jgmjv
 3JmrdeEar14nkCX3oc7s5k/Jrjs0F1E1dDJd3SF3GijXF+S75MGdMn3gVfZr5dq5x4nalWIOYBiq0eSxnJVAv5xUsQjx8lRJG/Y2BuYi9+XX7p7fHi/M44WNC0RasI8JaBJRFEFtoTZhFYUN/me3djgbtd5uRxNZkOaeXzIhujJVMHFxB0lneN1pZqU+yLZa8gbu5jQx6ALLaKMcD+BPlVmeW7c8RrX+hRIC8qnubMRebb64KV4/Fze16P233sxiv5H693CA4PV7o/6q7ATLxLY/VDvZGINcK2ZbIH2WgoK5ObnhnZtMyRVuYwvPGlPiXh5plKrbuQZqHt1m4cei3BQnbHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If PMD-sized pages are not supported on an architecture (ie. the
arch implements arch_has_pmd_leaves() and it returns false) then the
current code disables all THP, including mTHP.

This commit fixes this by allowing mTHP to be always enabled for all
archs. When PMD-sized pages are not supported, its sysfs entry won't be
created and their mapping will be disallowed at page-fault time.

Similarly, this commit implements the following changes for shmem in
shmem_allowable_huge_orders():

 - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
   considered
 - Filter out PMD and PUD orders from allowable orders when
   PMD-sized pages are not supported by the CPU

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/huge_memory.c | 23 ++++++++++++++++++-----
 mm/shmem.c       | 14 +++++++++-----
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 32254febe097..c1765c8e3dc6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -126,6 +126,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
+	if (!pgtable_has_pmd_leaves()) {
+		/*
+		 * The CPU doesn't support PMD-sized pages, assume it
+		 * doesn't support PUD-sized pages either.
+		 */
+		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
+	}
+
 	orders &= supported_orders;
 	if (!orders)
 		return 0;
@@ -133,7 +141,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -848,7 +856,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
 	 * constant so we have to do this here.
 	 */
-	if (!anon_orders_configured)
+	if (!anon_orders_configured && pgtable_has_pmd_leaves())
 		huge_anon_orders_inherit = BIT(PMD_ORDER);
 
 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
@@ -870,6 +878,14 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	}
 
 	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
+	if (!pgtable_has_pmd_leaves()) {
+		/*
+		 * The CPU doesn't support PMD-sized pages, assume it
+		 * doesn't support PUD-sized pages either.
+		 */
+		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
+	}
+
 	order = highest_order(orders);
 	while (orders) {
 		thpsize = thpsize_create(order, *hugepage_kobj);
@@ -969,9 +985,6 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!pgtable_has_pmd_leaves())
-		return -EINVAL;
-
 	/*
 	 * hugepages can't be allocated by the buddy allocator
 	 */
diff --git a/mm/shmem.c b/mm/shmem.c
index a48f034830cd..23893c2bc2dd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1840,16 +1840,19 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
-	unsigned int global_orders;
+	unsigned int global_orders, filter_orders = 0;
 
-	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
 		return 0;
 
+	if (!pgtable_has_pmd_leaves())
+		filter_orders = BIT(PMD_ORDER) | BIT(PUD_ORDER);
+
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
 						  shmem_huge_force, vma, vm_flags);
 	/* Tmpfs huge pages allocation */
 	if (!vma || !vma_is_anon_shmem(vma))
-		return global_orders;
+		return global_orders & ~filter_orders;
 
 	/*
 	 * Following the 'deny' semantics of the top level, force the huge
@@ -1863,7 +1866,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	 * means non-PMD sized THP can not override 'huge' mount option now.
 	 */
 	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return READ_ONCE(huge_shmem_orders_inherit);
+		return READ_ONCE(huge_shmem_orders_inherit) & ~filter_orders;
 
 	/* Allow mTHP that will be fully within i_size. */
 	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
@@ -1874,6 +1877,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	if (global_orders > 0)
 		mask |= READ_ONCE(huge_shmem_orders_inherit);
 
+	mask &= ~filter_orders;
 	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
 }
 
@@ -5457,7 +5461,7 @@ void __init shmem_init(void)
 	 * Default to setting PMD-sized THP to inherit the global setting and
 	 * disable all other multi-size THPs.
 	 */
-	if (!shmem_orders_configured)
+	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
 #endif
 	return;
-- 
2.53.0


