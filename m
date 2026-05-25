Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ABB2CD5BD2
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A14886B00A6; Mon, 25 May 2026 07:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC806B00A9; Mon, 25 May 2026 07:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7366B00A6; Mon, 25 May 2026 07:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68B176B00A6
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:39:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39616161717
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:39:17 +0000 (UTC)
X-FDA: 84805746354.30.F2702E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2A793140010
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:39:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZE7sTR3;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779709155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCGr5XWCC6+imV6TUBSzXRf560ZlDCIsQjlB2eChBBs=;
	b=DQIq5nm+dN+12TEGIxjK1hYbbp4QRnaocpIe7bTWRh4570Q++dEq9mTWUywfKdH+gLO8z3
	9T3pV8TzmzyMB341CrEKjivxXrYAJsoXfyNov4GM+xVHGQ2dcaTfu02Oua8kbm3Nz3HhYI
	Dm2PnroeXkCfj4Err0jKnQd9DeLhAYQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZE7sTR3;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779709155; a=rsa-sha256;
	cv=none;
	b=OfC9Yb/R9lCVKX9ozE7kFJU2JbnYSEzO3mXt8ZB/pf/ZZmxkndhFeM3nAdykTV0JqtZIlp
	LoR7s556BOxLLk66a9rhwcVKRyJTW0AA/EpF53WU+C0/217LiEODCwkpoU6p6nXRiOr5nl
	WzTT55ZSXSEy54GdQBdc+3JiSFciss0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FBCF4064A;
	Mon, 25 May 2026 11:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C591F00A3A;
	Mon, 25 May 2026 11:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779709154;
	bh=lCGr5XWCC6+imV6TUBSzXRf560ZlDCIsQjlB2eChBBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZE7sTR3XSOWaYUezwS97BOjQy86emLDG7x2Ipc/x0Z5MPoMa4zlH4HahEpI92yw7
	 6XxJ9AjDowozm1C3bLydbuGauzWwJaHDUtB6iEDyNE95QLU2W8spWIfMexB5A/chJo
	 RLbc6i5el5/S7xzErYApeeLWwdhPqwL54QZCzUCoF5Eb5DkIT0Y9EaSWHYosr8PI0J
	 cX3FNyUrKigscRyrnMSg/uMWL2wQ3T3XfSQzqfKVQerCdBhhDCSJru3CvdJzek1rBS
	 J+NvO2Bm3Thl8rc91+6gj9Xcv54mzYsr+Rp6aSSPowTMDanoO/a4ZgZixWd56gmyYi
	 DbxQvAh4dMSVA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 35549F40085;
	Mon, 25 May 2026 07:39:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 25 May 2026 07:39:13 -0400
X-ME-Sender: <xms:4TQUav_KeIpLQOfBfalIpLFhrt2WEFDXr2gzdELrqIg8_vmIh9ipew>
    <xme:4TQUavrPDY8VJXuX3-pVxmTVqSGGoPbdV02QDYQZKuBCvus_KTMQ2uYVH8tgOrr6B
    ofDZse3CD21Wn33EA1hdqFaW__7A7qL-Cd5_apZ2kLtP1y10RuPx5Q>
X-ME-Received: <xmr:4TQUalhp8SBADvvzmR1K-FoUboQGd2uMC6A-IFb7cA_WNKe83msKqKQ7U-Wsag>
X-ME-Proxy-Cause: dmFkZTE63z7Xr862URFTA+sRkbbWHzxlgalCSEhhNVgHzskp81KGOwvsn/jXJEp/u3k61f
    TFIEBvaujjjH3eJ6mZELD7tk9E825mNMYD8C27DqqXF/qXnX+dpUrYKsw7bOabDmRE2JNk
    w+koB9Xvv465LvXG0jkirzGdghO6WF8fUKxXa7niMd2i8oC4DUvZusWovo9fww0ymMbY+w
    EpmEfSpqgCkzsSYUrzkxgBYKe5HluhaWQMPb6+nZGJhjp54N25KObppup8JOiNuoOM8NuA
    CGqxQDUSfVDoRQ0zg7DBJlZixuBLr2HprGw2v6vMJ7mH4XRXAQQ+vMdrlMih3UVuJzuxhT
    qt36uCXSlhzvec3+yrUwK460fzuWZZPD9cb8bGvqiveuoD09MfMTVmsi3gz/Pu09IHnRk6
    M9akhwulE0Yl9TMpln8orCLIihNiSHqyC72Oo22IRQyZtKBsE/eEBvt5b6rwazh5A5iV8+
    0ZzQ+S/xwzbcmhv4ITkSnla2595Hvg8KaTRqZjeiR6h6KT1pBjT8JV9lylApH4gOQDo1D0
    ASOgRulwXfyHS5ieGrZ3j8W5LmNOgHDLVTGX3QbBUuQ/IbWf7se82SdFaQRemTAend0kYD
    pjHsW1ACAdnMjGYMK5ojEL54kAheeMAJSxpnxUHPuZjut+8TClNORA7o+WkA
X-ME-Proxy: <xmx:4TQUalD7aspiPbds3gsbAJmGHXjPmvAlzj9tJjH_UlGWrNPZuWkvlQ>
    <xmx:4TQUarsz3ymUEP7C9qObV3hm1dhV1JoMGdXEWjDONo01gvB58d1AbA>
    <xmx:4TQUan4aMDaYFEiM26kIXivtd0KRDsiddYwRnCTIgcyMglLqqN5sjg>
    <xmx:4TQUatehYUrr0NW2OEKucUTUr4lZbUrkgNX-pm-RKW9cb98GrXdrsg>
    <xmx:4TQUanVBz18MBvPBTvWHaz2w0JCtnFsabGonOao0sw_j52zzL9BtBD_f>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 07:39:12 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v4 11/14] userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
Date: Mon, 25 May 2026 12:37:25 +0100
Message-ID: <20260525113737.1942478-12-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525113737.1942478-1-kas@kernel.org>
References: <20260525113737.1942478-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4gc3kbwp7u4i1cdx6n6rjwdi4ciu56wu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2A793140010
X-HE-Tag: 1779709155-451875
X-HE-Meta: U2FsdGVkX18grZLDhXDmqv1mEq04wmCvrSExH55KhohLTcY/YnzAk+k2TNEGcELkUjOeeRgeQq69L0EF8ysan7co+i08z34dPnqnh5LSrh/QhxsjB970K27mild/7UbeS1OVdo45JgGCkmAferamQtfB7GdunwuPZn1Ixtp6Md5ERuNNbPfaX4ReO1E8Bl8ZCog5QTtydwiKYeWsXqXtlcU5CXSCn77POs/m/wgDTnLMz8z2TXm4yZq5k3cNRo5xuc+yhDnKoRPvsCXz6KOUfu2jXfimLPCo7ME2WpRPvYIQFP0V54XLuMmSCy/9hCnv1iOkRirIrBzMKA+x3WntDsARtHvAHqmCFGC3SuIjTO6HK7cT4aRMGBJzOwu8pI0rbN2t5OE7Z2sw0w+evwdHzmvIvArgHK5DfyM6rqGgIkT5rHOEZD29y3D7HuNIAW2sE+gK1aooSgf5Y5A76XrIfcU51TKQoVK1N9TXm9LG14OCZnJBnatQSmyJ62s6P5K3K/qoiI0pBd2SCX/9UccrQkv5qhey0MPgiufQ+Q6PNGwdSV4PSwA+KXmuTmSrD0JpUiB0JYXcCU1cXpE8N7bgk8c4T0yUhWXd364xYtYdPrG9QM6TPQGA09QDrEhXKpw0dbHH42h820ftKiIh84UKG6EhqNnausW7yy7PlPXR7JF9GQCF02VOP5nEYZsyz7FY+LkOPim6wacjDdix8WcQbII8Ea1Cp5W063HKGa8ZKI8ioiJLxEz9GkNl4vHALKq8mPMKjrgvwyv8CBxiSBfBN31t2tJZakNWZmPLzyDIw8OohX/D0P7DzzmiRtlDcHpo3ZRWcgosWwhlwynWT3rCYK1WVpqsrujgMXwg4zy3shbojASByUolZfFNjRvCt8JKr43YvYAi69G3L4FoUOxUHbhv9pXCm+A3M8e1bxPfeJl9sYVFfLGI9qi6nxcOBRBzKlvpsPIkF50DmJ1qjP4
 C12IsyFC
 0qii+LHfJFp6kXVogbANtIctpgCNezlA3+8tJHp7S+2qqNwWHdw1YRCuf4NWpkRB6b+Kxi5h3DFT/xgT7hPb6d2I8QXX3gFd3HUe2ES6GDV4NQZdMagVFUjTS9vafLUTGObzksGsELlrPQwHPHbhLsHMUpjodIPESpROe17s5YGVyJJGqFBZj5NJTbHCO6ub/sNqc7A7oEXQEJt8j2xHEhv6E15aDO1eg9qzqRjgo+JSX/tmq9hYTh/gZa3xBbUHR7BL6ipA4g0VkqlkAZKsSbWRYW4GTQZo7GbpGuyFkRpJK432SJ1CaSw6OvJ+nK4lcPgGBJxdnafT77KUGlY3sPq4bqtv/udrjP1HRMznYKwRX1TD30uxxoE7/Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index d8f5f400c8ef..43b2fb587ce3 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -278,6 +278,7 @@ extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
 extern bool userfaultfd_wp_async(struct vm_area_struct *vma);
+extern bool userfaultfd_rwp_async(struct vm_area_struct *vma);
 
 static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 {
@@ -456,6 +457,11 @@ static inline bool userfaultfd_wp_async(struct vm_area_struct *vma)
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
index cd32bd51e311..803fbc41e501 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2291,7 +2291,30 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 
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
index f63718296cc2..a5ff9018af06 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6070,7 +6070,37 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
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
index 3e393881031d..89c9a44d07ce 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6137,8 +6137,31 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 
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
index b966df47800c..20478bb37311 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2478,6 +2478,11 @@ static bool userfaultfd_wp_async_ctx(struct userfaultfd_ctx *ctx)
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
@@ -4379,6 +4384,11 @@ bool userfaultfd_wp_async(struct vm_area_struct *vma)
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
@@ -4482,6 +4492,12 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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
@@ -4504,7 +4520,8 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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


