Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65EFACD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F05A6B00F2; Fri, 29 May 2026 13:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C7D16B00F4; Fri, 29 May 2026 13:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DDEA6B00F5; Fri, 29 May 2026 13:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1801C6B00F2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:28:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6AC9120279
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:10 +0000 (UTC)
X-FDA: 84821140740.24.514AFB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id CB611180005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ep3Oo6tH;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADbKc85LrkLZOvS7Y1h7hpN699pGMwcdOp6g8DvIwlY=;
	b=6KIuP92T9AOqkusMpggLC5YaeooEXbgHCZDZo2xej+2eEmLvQfFeyo5vGW7vtAUSwBUuCl
	WnEqKGfGlfzSrhXxjnkS9NPzwHVOeCglBk/fTELYac/DrJtUwz++mv/1EMKMsrenQw+tcP
	7LJ3W2ZUn0ZOWe4wDVcCuSqN6th3jSs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ep3Oo6tH;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075688; a=rsa-sha256;
	cv=none;
	b=KJ+1RxrUWZU3k1iTb19YQRYxcY/tdfs2GhJ2AK/vpA6/6/xYSwbYmBcSINQ933ouPcsAHq
	3s0GHNBbWdsZttdvSHKyZK68VM/S0KVaYWQWcUfX7ZIvzoLZ0Y1GdY45H7pKUop1v3xV7Z
	kke8OF8CarCQsZgwAPpdPbXZmmeXuWo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5027C605EB;
	Fri, 29 May 2026 17:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE391F0089F;
	Fri, 29 May 2026 17:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075687;
	bh=ADbKc85LrkLZOvS7Y1h7hpN699pGMwcdOp6g8DvIwlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ep3Oo6tHkMoIgwdtS6TGkN8h1ZDSj1ni9gwcrUG035y75r2UcblO+qp1U/MemKOQV
	 zncTrX58O40J2lgeK2h94r8zDrVdv5dj+Ew5jGCxO/0qnLlygtueuUYSMzrwP2NYtL
	 cABSN/fe/pNSEfYhglQkFbSs8nGALleTn1PpJ3VS5J50qUX+R5GHUItcvVAjVwTWSN
	 1f2ajJWX6fUggAp2vvCSbaR1VSphC2BwP8R3qP5p8ioDnumuDLX4dByXaxB6oE9gr1
	 EEG1BkiPjidmCi77Gz102y57QtIS3IhdSX6/Z8WX+rShRCoAzP4UmT1S/XLt2GWhDT
	 UnkLDIzM5/cIg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 995A4F40070;
	Fri, 29 May 2026 13:28:06 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 29 May 2026 13:28:06 -0400
X-ME-Sender: <xms:pswZaqpfUMXGVx4-wAvADl_E6xPhLxgbn12BZ7EobLuZGMurVOwmOw>
    <xme:pswZaki3oB6uIZtcvMRP1biwMsQ_WzxQgw8lWwcQoNIn-OercRQvm7sEENX3tc3E6
    HAMT8Ar6-uj-QL6Pm5L5WNJA68o2YbzZrXw7-9UsHvoUAy33yDyroI>
X-ME-Received: <xmr:pswZaoDKVEdAo5KC3966E00rlqrkPHubqzuuToVmlsF4MniMPOZIX0nhtvzXjg>
X-ME-Proxy-Cause: dmFkZTEHS1Z+n1S80q4BaszFx9bNnHLQ6sgL6J9HpxOFXRfFtKsh6le5cKxaCZzZ/qH/SJ
    zONNCxWzVoPiQhYsD9dliy9AdrB2UY/Bhb82egQk/l96x3r4UUhrX92dr53s7Ptki96Mx4
    DvJi8H/xrcKSa4upwFZAuWyRsvkJtw5DUL41fEdJBQDb5TWXZV3TgknVzb3pm5Cw5eabt3
    ZKinBz9XCIvsS/RAa3Cb6hoIPIA7Rb0ceUklQcqu2F89W2umMVSE8bbF5HocBMl20u4Nxk
    92MelAoY5r8qDI90ESLS21z7KfMewjRnztTxCHQfAtq0f2Qz4D8wiVPs5MI39B39+ARICH
    MVi1tFYcSFTEJer+zf9qinKOoAsOjaND8wl8K0S5vkiW33iZad0dBlcZDkxEIguT72vf0X
    MVWUtcQfczwY+/fVQeMpWlbM18InrmcXh9HcOOib3I/iKiinojE4Jss27qHdDmcOOYoxwu
    d173aOKqwBRaXDgrFr3LuzM1b+mIZOnNncS6dF7On6VBZzXU7KUEEP367JjIsmH1Xxl9O4
    znCS+QbyWONBH8kPzt8ijPXL81CcRSbaXM+5QbynXJ7aQguQlR2JxXT6/XzIn5nrgE/dhn
    yY6/7Z/GoLR3zeTOkswjcQW1XF4VdBx45NFgHo5KqY2WHMXCg9bihS+/Fh1A
X-ME-Proxy: <xmx:pswZaiuL0QknoTyHRKtdxZX8feidyCmFZJuS-xsO58VfnG4QkFZ8Pg>
    <xmx:pswZai71LQavU-ZMNicn56ji1kRDtDWNQBRQ0jtBGzt_zURt8LC65A>
    <xmx:pswZasfeMSbrTz2V5fizNaU0L94skFjzME411Cj-Q6XY9tIOGyPZjw>
    <xmx:pswZaqXTeFskphZO3qsho1la0ajGcXA_vRkSsRMUg6MJT8hhrDpmOw>
    <xmx:pswZapWn_trvbFGsCExG-60xbpLgVDcmThf722ZP4pgWyJgKqwSk010S>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:28:06 -0400 (EDT)
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
	kas@kernel.org
Subject: [PATCH v6 12/15] userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
Date: Fri, 29 May 2026 18:26:41 +0100
Message-ID: <20260529172716.357179-13-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172716.357179-1-kas@kernel.org>
References: <20260529172716.357179-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kymejnnn84ky36kcqu1tm3x4tabi7jih
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CB611180005
X-HE-Tag: 1780075688-261426
X-HE-Meta: U2FsdGVkX1+5DYrC9GQ8s6mNYJiTxw5eCLN0xYPf7ZHRp6KkdiAG4MjUc7zbjq3Gx4VjTdqtu/oQoIETfbBn6kDlhKs6gQa71FuxLn5WBQwioi7Q9SXd9EHumAUtCwvTTPPHBId/oCr6ZfvlR6UgUbZfsRJFD0qikTQXXm/YMh5KqnCuUufatlRTLW4n25EeZuusKthvEk3C8b1KaRoH07wh9Tuy+lEpikhzAscxYkcteo1ujo3nY41lI/QruYj67cxP42hohfOAZnnVGioZ3G9q/YugjCMQchxxfLTghdojXuGhIv5tTeQF+AHf2V3JkBTD0lq5LnxhuSu7CohaUnh7HCL7rPsGBHXyvdP0mhO3x6eW3nGjxfthEnaVMbCCrfdVfyssMcqlndrS0i78UQTO10z9p1P65tnanL4tZdJBvET/0iZLMkBCT/TSWwPylVh19noriFaMFWdMYkQdRvV88rO6JpqnB9HWaYBKwR2qDbfL1NUxPR6zpEJuEnuWWdvY5SvKmpaRbjULOBELAEzG8DXtFLsvcfPw1Cxd1/MfIYDI1QhlwkmFn2eC/VGp3Y3o35ZSD+v1CrF9jwMKDKztJnAKYOEzpx8p4iEg+FMXxkDKBFyAHP6bQhl8Mr4W8eqDP1BJ5Jhs9AsNedYEpu5zy5KUN40QAePwTZCddJl0phDeX6rX8q+IVqjZPzOWJTSv7ZFmCGPQ/YZb+qtyi9M3EhNaYrFs6y07IjNIi6YcYU/72f4ULzCrdMGJnBP0ZP+e/4SQKGxTnDCkt3GmSgQf7buPFzpCS0ODv0TLXsjs6bxY0sc0EMpQjQ1OmSed/Feyj1HKWaQD10o+lQkUMguPe0ZjCUwatuo+FUjCSp/rUxNYbzhFVWlb10NoSQ4CTaM1wd54rJVA4ItL8teRefTG9n9bB7x/2dH2juVB3L3FDoucpmZ6y0+qPANJtxtNEhJkU+usmgAtcYBt9sy
 fSX7ojOv
 dvqsPr/bIYyyF8rkhvyrEFQsDLFYOZZ5qfYYnKm2i5Ji16Kb+HVY5tBJvmM9+N/FjXU4qe5RmyaNL/VdiTEb5Gelwh1+SemcB+cAXYsv5rCJ7TZSRhpjJ1uJ8azmCwDEY7pEVkunF9ztEDvK0MuvGEsFYTB4QtdE3yc6k5nxGntEbYYRj92pKeDKxCSJ8X4m5svzhTh18JgfjzXFlXerw0P2Ra1BCYvzXf25KU/1Z4FkpTRBcUd6jN+mK6/08RH9qjBzgGvmYHhgt+vUy/+jV/iYh1+WoC/b7lUE0vaymwqDggxtxMB70Ul45TIUemL5HsQr8s6RNuNP3W9PTFoXW8lAUQ3EVRlyTUc0AE1XRYawbovL+D3YaSEG0QuvoC7kNHRNk
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
index 6b633ec694e1..dd3c8ba97296 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -281,6 +281,7 @@ extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
 extern bool userfaultfd_wp_async(struct vm_area_struct *vma);
+extern bool userfaultfd_rwp_async(struct vm_area_struct *vma);
 
 static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 {
@@ -459,6 +460,11 @@ static inline bool userfaultfd_wp_async(struct vm_area_struct *vma)
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
index 72cb44332004..8f120452d995 100644
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
index d4da39d698b8..9da52d95b3fb 100644
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
index 4f8b8dff0b7f..43b5e63c368b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6149,8 +6149,31 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 
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
index db3707b9d977..f40bf473a6f6 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2487,6 +2487,11 @@ static bool userfaultfd_wp_async_ctx(struct userfaultfd_ctx *ctx)
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
@@ -4408,6 +4413,11 @@ bool userfaultfd_wp_async(struct vm_area_struct *vma)
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
@@ -4511,6 +4521,12 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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
@@ -4533,7 +4549,8 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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


