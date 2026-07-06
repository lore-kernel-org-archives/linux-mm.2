Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44570C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9F86B0117; Mon,  6 Jul 2026 04:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1C76B0119; Mon,  6 Jul 2026 04:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B524E6B011A; Mon,  6 Jul 2026 04:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 894F56B0117
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13294C1B8C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:40 +0000 (UTC)
X-FDA: 84957726000.14.B7F531D
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf09.hostedemail.com (Postfix) with ESMTP id 15EC0140005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=WdpiueGX;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="m t/s75s";
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327718;
	b=uOV/xIVO78pYxmBggdXTU7fEKlQ7yLfmN7x+obV+IG3bfBpSz12R5qP7yD7x9yC9zy7srP
	SBEwnZuoKl8cfEUaL6X1OIH9O9NH+2sD2HkcrbmCvr2+DW7xSb0Tx78Pbae132q4Z/UGU1
	mogs81OQEASfFQpMI5q+QoN1EEuUrR8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=WdpiueGX;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="m t/s75s";
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yzGBb/4a/CFulJsZ3rwe1vKYz23uD3iCaRZns479Nk=;
	b=hp80gqkdklkkGMpmcwtYw5b7bpZriykHMA+Gr6Ml+hlodW5FCduKKOnrwMgnJPHoFicXHJ
	B2Es/mzHgy0hHc8xeS0mNgJi59poNPpniaWH8qGMIsoKSDWy2QRS6JuXEGm3kHqcQwKA/i
	I6pq2ct+Jkl6HMmiyVloA45/dzvVlbY=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E1A5E7A00F5;
	Mon,  6 Jul 2026 04:48:36 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 06 Jul 2026 04:48:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783327716; x=1783414116; bh=1yzGBb/4a/CFulJsZ3rwe1vKYz23uD3i
	CaRZns479Nk=; b=WdpiueGXl5/E/R1wXxa3tT4Lle4o6dbidDsDqty5yGXsOQeF
	XxVkgBWO7tAmKrOIAFpUTlS/bxuyrI+RFRBnSa117Vzfr3K4o42fUYZFgKnc4Zeg
	vaaBpxt6qDNM61BehUCWnfMOPGoZctoYa51UL92NugE39UP+fWe2Ub/hbIRvGo+t
	ogKweNPb29s12tbFszwtuWzLTQ0ceGBjODLmL7M2mwS2jUSxRKYCrk/5tFO7ZEh2
	mbrChICBgcEPMTB3DEXy6fvj2Li3lOMq0OCN9J3qIiTiofu1Hxr5bA8xzqujM0s7
	62YAM/aWQ0QQmPTI48ZlcZbcykvajvbp7sB7Ow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783327716; x=
	1783414116; bh=1yzGBb/4a/CFulJsZ3rwe1vKYz23uD3iCaRZns479Nk=; b=m
	t/s75sIqm333gSbFcvfsIaPwszr8O28hgO04+e5PeNFTPlOUvdr8Jgh3vU5lIWaw
	u4dyNyGTuIG1VcrQKxXa/xllZM7+foy8bq15XAapW8UsY5gt57TxX4QV1Yp7YfWK
	JP6YPHm1s8G42BRt2UBStBYQ101WzLyxpeyOBoNjv8XLsOV9wQQ5K5ss1VcQg7eR
	RjhKtIqQ8isSW26N2AW8i3chTAKP+aHCzBwJD5tgCeVlvwp+uFCShXyP4cbjx/oX
	oGD5oG2o0PHJDTDKM8ydRUiZ6Qdpsb6Lk/AE4F+U9zEbTXG3f/bBAQAmEPXFR9K5
	2Faesoauv1NCTsfcj0GAg==
X-ME-Sender: <xms:5GtLanfRhonYcZNKV_dKc3hWQYZRdyKQbDt-kiQzqP1M9bpzz0G8Xg>
    <xme:5GtLahJhdshD3jHzxhxBOd-fcnb2cF38QXqVVVHcMSh1Dv5eDz3lBM2gvO1aJ5qyU
    5Qun8au-cuRi4vtntry5R7eyzlFaXfB_3qa8gkIqVLellbuQ-naKao>
X-ME-Received: <xmr:5GtLapDA8hZRuRXklTC4s1_QGoDSytjNBXrqqhnMFz7BwHUK-OQcjDrGV29n4Q>
X-ME-Proxy-Cause: dmFkZTEdicl3dVcL9amANwuNwQ4B/LJ3AGF1IsDGz3aHorST7YhCfwWdaoJhyFHnoWYf2z
    91HVmiSdMMHUBIp4DD88nbW8shxrcjtAZdfXT6m9vc2Tcww7aeCMA9Pb6AAq1YaCWmAxgi
    ArVIEIXgIinNiSvhXTjw+kvcHF73HamoSly6f2up0otjPkEsXMk2c6+qcLC+kg/EfYu9ll
    NC++3n7OIxXkJRlDO8fi1mHoFiMP7TF8KdSUZCebtKSLPWyVmZPfwelqwDaz0Kv1dWgagF
    Ckmrl0e7yag/Y6YlOJb9G2EtlAUAhQvoJLw6xbBcQqHVWMSCgJsGTVd3gdpaGhlRuslVMQ
    gLWrezcbY0fpKrQRqqOPhKho1xJCvSycz8c4HwDSfISa6z/QBlLf3CErp6AnAJEEI0IpMc
    u2fo/XrzKHueAM74EkUTk7u6gJorla37aQKVmVStRYyLgz3d3NbEIwJJYZJNWETB1RC1jp
    odqZoZqI9JK9FQQWL8trL43wrLbzk0bLRCfRhdTtVRl9dhwjDOzVLJqb0C7mLZEeHkyiFh
    1JY0Moj3aJrj8+y1Ml3omyS0lpfZ4ILBFGta4qdOpvBATOnUYEsZ3cD6cGqwfLkCxU7M9I
    QWswNaDyn8ijKswk82zC/CTHff0hMT7i1gOTqlZBNKGOcqyHV/b+bGhBrcbA
X-ME-Proxy: <xmx:5GtLaihu-bThCaRObj5ki2mm6HcYnREmLfk5znXrJF8e15IimrcFMw>
    <xmx:5GtLarMp1DKa9-QKV_M8llPmhUMc86kiKoLQS1X100697TNtef3G3g>
    <xmx:5GtLahalGezQU2NLu4bmK6aMabyAwGHWCB8aHgtKCMzAa0qBvn3Liw>
    <xmx:5GtLao80diXFbzWPXxv4kzgIB5zswx3IwXo69fGBW41-AJ3NWRG6YQ>
    <xmx:5GtLat8s8_72_JdeVZ7_LLpbWbJsyouVN_fQjGYurHyMCHktvcwiONf6>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:36 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH v9 12/15] userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
Date: Mon,  6 Jul 2026 09:48:01 +0100
Message-ID: <20260706084805.8400-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 15EC0140005
X-Stat-Signature: r579zewtfxkurqxsy9tximmdwum8z837
X-HE-Tag: 1783327717-161748
X-HE-Meta: U2FsdGVkX18p7/x9q3radqSmbtpWpmqbno9wKvNfhFnTCRfQNUhXB5bHfNKuu1pgLjSNEtRnHScf7DbzlPuyGkqr3lerUKbnRH3W+uEjgDKn2nPctqZ+QbnhgpkYHPWHRz2qz0LNIiQSV1kQsHlpLlEDR6FcBgKpJmLMwZPzq/hCNHb0Ac6jpW5UJoouBCUM4w4pAw1ikFabe014Nf/nEgMDfmFkjhwCHsXkChDzk9Z4AX9wSUrrv+kyc/JD4D2Z69fxGO43u5a8IxSIbG+EeeOubUscoXdhVk1za098aMKBleQU0KmBxdGUvtWHcVpJc2RmK2qcpnsmkkqBkGIuY9QiToxp8ColN3Y/pHtni2AAMKQlJ2TyoAG8s8xtZfgik4U+UEPDVutP/Sz/SDRCNHgopsq52SU0y2sEf6rLR/IHHEsgeSF1IGPJXf9pPVjYQ1X452nXrVJcEArhuW57eUhTY034mgSZywjL+mHN4Wux1xLO4ojcNXfXy/qpNXpW+qUZQFrnVf1VlN4Adqlhm3IU+BKy1uhVRycvMT1RN1AUYj6r2tYj7EsD7jONx5Uj7wG6M4kNY6c8WUoYOhNwVOahVC90mUURJorwQGm20deWHRQCU67eqDaalt/TNFHT8x3AIk20WWEDH6r4BMzxmJQYRpLGyHy8uY2vdpBgmqBaG3eQWFNrwc7s35nJ1JcgYHujof7LpKnjtYZdrQe6YEQHM5OzOfoSqml4F6eoK565We+9IQqlyokVr/qsuL8IuS9J9wjG9r2znJJimwFxHT5pY14uzkFyjADqo3czcvCv8+Z0Ci8HuT8xmGWcEL6VgPhQO4mu28mdF0wCJgFZs/oNwdTxN91aDU72NFLzC1h4/xao2Ftf3tvrj0hgNJsSHORnZIJErvVxJWH96pn9uUK1N9eq/tA2odM+y5UKSav0n0+cUqX2C2XCOG5zF9elEQIBlU+wqg0RzBvNuBU
 osjozmx8
 CSCHI27/BVwMZ36MxuUYviUVsFgXMOCjkBm3wBssloBsxPA/LXIjdesO5c7YFID5U60W6iNsjNC6aOWbt1PpAMh9QaBlBGarcggnVNS1cTTuFTta/eQ7VsRK1F60pW/ap6CNk3WiIIzVb9pKdjuUb7nJltm5b0kgFoqFXuA73oDZiU5ua8ObkNhNPlVMKhd3zWB1NCn92dmG817KEwFGlqLicCAoRMAmHH2a/uuKAcWQJtC2MoyrR2adZ3FPiHk5FOmwd7tJFj1RLGTZQK0XhLJdBAg51gmf0SEnmoTxvocZnq0HET037k5zD5kuubu7scNkzuVTWyvoseedLWeAQaxhvoXJazZAM1LL3IvGBEWipXGstfeGcOuVibgUFU8zMpDhtsctuJh392m6elFTx2qTR4PhGJSEyQaGVOBMjD8arF0bot2HQyA9iHSSGfqBHTss6hRzvcERqEKE2yGe0wes9psvYJ8YxxEiBvKP4xRY7lDjs5DNmS56zXF7D8PYwnrhjIIo1TuEAr/si43caiEblnW/sa2nJJ/aERB7ndvTbpzlQNoJejDwHx/RCfY2XPVyhLVbSAWpPcFGROPJF7erCRwJU3AhLvzGW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Sync RWP delivers a message and blocks the faulting thread until the
handler resolves the fault. For working-set tracking the VMM does not
need the message: it just needs to know, at scan time, which pages
were touched. Async RWP serves that use case — the kernel restores
access in-place and the faulting thread continues without blocking.

The VMM reconstructs the access pattern after the fact via
PAGEMAP_SCAN: pages whose uffd bit is still set (inverted
PAGE_IS_ACCESSED) were not re-accessed since the last RWP cycle.

Worth calling out: async resolution upgrades writable private anon
PTEs via pte_mkwrite() when can_change_pte_writable() allows, mirroring
do_numa_page(). Without it, every re-access of an RWP'd writable page
would COW-fault a second time.

UFFD_FEATURE_RWP_ASYNC requires UFFD_FEATURE_RWP.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h    |  6 ++++++
 include/uapi/linux/userfaultfd.h | 11 ++++++++++-
 mm/huge_memory.c                 | 25 ++++++++++++++++++++++++-
 mm/hugetlb.c                     | 32 +++++++++++++++++++++++++++++++-
 mm/memory.c                      | 27 +++++++++++++++++++++++++--
 mm/userfaultfd.c                 | 19 ++++++++++++++++++-
 6 files changed, 114 insertions(+), 6 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 6f7245609bd4..bfbd6a59909f 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -286,6 +286,7 @@ extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
 extern bool userfaultfd_wp_async(struct vm_area_struct *vma);
+extern bool userfaultfd_rwp_async(struct vm_area_struct *vma);
 
 static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 {
@@ -464,6 +465,11 @@ static inline bool userfaultfd_wp_async(struct vm_area_struct *vma)
 	return false;
 }
 
+static inline bool userfaultfd_rwp_async(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index d803e76d47ad..c10f08f8a618 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -44,7 +44,8 @@
 			   UFFD_FEATURE_POISON |		\
 			   UFFD_FEATURE_WP_ASYNC |		\
 			   UFFD_FEATURE_MOVE |			\
-			   UFFD_FEATURE_RWP)
+			   UFFD_FEATURE_RWP |			\
+			   UFFD_FEATURE_RWP_ASYNC)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -243,6 +244,13 @@ struct uffdio_api {
 	 * UFFDIO_REGISTER_MODE_RWP for read-write protection tracking.
 	 * Pages are made inaccessible via UFFDIO_RWPROTECT and faults
 	 * are delivered when the pages are re-accessed.
+	 *
+	 * UFFD_FEATURE_RWP_ASYNC indicates asynchronous mode for
+	 * UFFDIO_REGISTER_MODE_RWP.  When set, faults on read-write
+	 * protected pages are auto-resolved by the kernel (PTE
+	 * permissions restored immediately) without delivering a message
+	 * to the userfaultfd handler.  Use PAGEMAP_SCAN with inverted
+	 * PAGE_IS_ACCESSED to find pages that were not re-accessed.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -262,6 +270,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_WP_ASYNC			(1<<15)
 #define UFFD_FEATURE_MOVE			(1<<16)
 #define UFFD_FEATURE_RWP			(1<<17)
+#define UFFD_FEATURE_RWP_ASYNC			(1<<18)
 	__u64 features;
 
 	__u64 ioctls;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 02ee8abed198..4150f1bdea0c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2204,7 +2204,30 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 
 vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
 {
-	return handle_userfault(vmf, VM_UFFD_RWP);
+	struct vm_area_struct *vma = vmf->vma;
+	pmd_t pmd;
+
+	if (!userfaultfd_rwp_async(vma))
+		return handle_userfault(vmf, VM_UFFD_RWP);
+
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(pmdp_get(vmf->pmd), vmf->orig_pmd))) {
+		spin_unlock(vmf->ptl);
+		return 0;
+	}
+	pmd = pmd_modify(vmf->orig_pmd, vma->vm_page_prot);
+	/* pmd_modify() preserves _PAGE_UFFD; drop it on resolution */
+	pmd = pmd_clear_uffd(pmd);
+	pmd = pmd_mkyoung(pmd);
+	if (!pmd_write(pmd) &&
+	    vma_wants_manual_pte_write_upgrade(vma) &&
+	    can_change_pmd_writable(vma, vmf->address, pmd))
+		pmd = pmd_mkwrite(pmd, vma);
+	set_pmd_at(vma->vm_mm, vmf->address & HPAGE_PMD_MASK,
+		   vmf->pmd, pmd);
+	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
+	spin_unlock(vmf->ptl);
+	return 0;
 }
 
 /* NUMA hinting page fault entry point for trans huge pmds */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f0ce2e9d4ba2..a82f77b61e29 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6071,7 +6071,37 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 */
 	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
 	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
-		return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+		spinlock_t *ptl;
+		pte_t pte;
+
+		/* Sync: drop hugetlb locks before blocking in handle_userfault() */
+		if (!userfaultfd_rwp_async(vma))
+			return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+
+		ptl = huge_pte_lock(h, mm, vmf.pte);
+		pte = huge_ptep_get(mm, vmf.address, vmf.pte);
+		if (pte_protnone(pte) && huge_pte_uffd(pte)) {
+			unsigned int shift = huge_page_shift(h);
+
+			pte = huge_pte_modify(pte, vma->vm_page_prot);
+			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
+			/* huge_pte_modify() preserves _PAGE_UFFD; drop it on resolution */
+			pte = huge_pte_clear_uffd(pte);
+			pte = pte_mkyoung(pte);
+			/*
+			 * Unlike do_uffd_rwp(), do not upgrade to writable
+			 * here. Hugetlb lacks a can_change_huge_pte_writable()
+			 * equivalent, so a write access will take a separate
+			 * COW fault — acceptable for the rare private hugetlb
+			 * case.
+			 */
+			set_huge_pte_at(mm, vmf.address, vmf.pte, pte,
+					huge_page_size(h));
+			update_mmu_cache(vma, vmf.address, vmf.pte);
+		}
+		spin_unlock(ptl);
+		ret = 0;
+		goto out_mutex;
 	}
 
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index fe1d605a4d66..5b7e2ec8ae02 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6166,8 +6166,31 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 
 static vm_fault_t do_uffd_rwp(struct vm_fault *vmf)
 {
-	pte_unmap(vmf->pte);
-	return handle_userfault(vmf, VM_UFFD_RWP);
+	pte_t pte;
+
+	if (!userfaultfd_rwp_async(vmf->vma)) {
+		/* Sync mode: unmap PTE and deliver to userfaultfd handler */
+		pte_unmap(vmf->pte);
+		return handle_userfault(vmf, VM_UFFD_RWP);
+	}
+
+	spin_lock(vmf->ptl);
+	if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return 0;
+	}
+	pte = pte_modify(vmf->orig_pte, vmf->vma->vm_page_prot);
+	/* pte_modify() preserves _PAGE_UFFD; drop it on resolution */
+	pte = pte_clear_uffd(pte);
+	pte = pte_mkyoung(pte);
+	if (!pte_write(pte) &&
+	    vma_wants_manual_pte_write_upgrade(vmf->vma) &&
+	    can_change_pte_writable(vmf->vma, vmf->address, pte))
+		pte = pte_mkwrite(pte, vmf->vma);
+	set_pte_at(vmf->vma->vm_mm, vmf->address, vmf->pte, pte);
+	update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	return 0;
 }
 
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index df3cbbc3cf52..763897f59678 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2485,6 +2485,11 @@ static bool userfaultfd_wp_async_ctx(struct userfaultfd_ctx *ctx)
 	return ctx && (ctx->features & UFFD_FEATURE_WP_ASYNC);
 }
 
+static bool userfaultfd_rwp_async_ctx(struct userfaultfd_ctx *ctx)
+{
+	return ctx && (ctx->features & UFFD_FEATURE_RWP_ASYNC);
+}
+
 /*
  * Whether WP_UNPOPULATED is enabled on the uffd context.  It is only
  * meaningful when userfaultfd_wp()==true on the vma and when it's
@@ -4417,6 +4422,11 @@ bool userfaultfd_wp_async(struct vm_area_struct *vma)
 	return userfaultfd_wp_async_ctx(vma->vm_userfaultfd_ctx.ctx);
 }
 
+bool userfaultfd_rwp_async(struct vm_area_struct *vma)
+{
+	return userfaultfd_rwp_async_ctx(vma->vm_userfaultfd_ctx.ctx);
+}
+
 static inline unsigned int uffd_ctx_features(__u64 user_features)
 {
 	/*
@@ -4520,6 +4530,12 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	if (features & UFFD_FEATURE_WP_ASYNC)
 		features |= UFFD_FEATURE_WP_UNPOPULATED;
 
+	ret = -EINVAL;
+	/* RWP_ASYNC requires RWP */
+	if ((features & UFFD_FEATURE_RWP_ASYNC) &&
+	    !(features & UFFD_FEATURE_RWP))
+		goto err_out;
+
 	/* report all available features and ioctls to userland */
 	uffdio_api.features = UFFD_API_FEATURES;
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
@@ -4542,7 +4558,8 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	 * but not actually usable.
 	 */
 	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
-		uffdio_api.features &= ~UFFD_FEATURE_RWP;
+		uffdio_api.features &=
+			~(UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC);
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
-- 
2.54.0


