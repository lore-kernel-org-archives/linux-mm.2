Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B6D1CD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113386B0098; Mon, 25 May 2026 07:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB506B0099; Mon, 25 May 2026 07:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0017E6B009B; Mon, 25 May 2026 07:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E157D6B0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:38:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADAE51A01A3
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:38:36 +0000 (UTC)
X-FDA: 84805744632.19.46B299B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C3B1F140011
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:38:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B4TI8cud;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779709114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaYAA4LDLxQSQ00+eYpFUK2Ea0ShPnS1Md5Dkd+3h9c=;
	b=f2w0psL1G1kNuOIu3rIrL4H35OiDXyE7pgzgktczprWppZ9jOp24PrB/W1VdPShTmE3AUp
	3ArQkvzDVJaDnvnqJMAHcd1ctI5nnrgLmBRsGYyLiO4ez6AgnjTXrXHH8GEjkvvvY+McT9
	ytrTKz5H8G5ETuwAUJ66N5p/Di0YSMA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B4TI8cud;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779709114; a=rsa-sha256;
	cv=none;
	b=qpsinVLqw9u/9VuaU9WcJpefSpXNxRVfu5dv4nZefYabfCZQeOTpDHPstchiIxQGoCEWO8
	JTrJLUjsLSBEeTZ6FlOERvrW45CI/0kUBC3cSFMmGOBSg3hc3oojBzFQbmgTRPjOtbpdfx
	NOeZ/x2nCozHiUbM7ChF8G36JvpCT+Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 40150601F3;
	Mon, 25 May 2026 11:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579161F00A3C;
	Mon, 25 May 2026 11:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779709114;
	bh=YaYAA4LDLxQSQ00+eYpFUK2Ea0ShPnS1Md5Dkd+3h9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4TI8cudOEvvDk93negGtfyvd5qJ9xp3iSk3lMQKduCGEW8fFGLdp9vptusOSMcby
	 j4BgXNnfKvRApU1ah7inTu7JyU9HfPmlfwkNA51ATJIHh7Kc2VUotCuzOSSyd8NnSK
	 xRH9LureLXAPaj7KeWKOGJeESVprFuMBuwi+LtxKgbwuaJlzQqsDzLh8J2j5XHIWic
	 WbkEt1ScXUw4BKbb4Eb6gA9rZeKfyI+91hcl2kwqLR027iRKmj2l+s3JJ5LagozIdu
	 ghGzyer4o1DghJ28vcIvSIWz6VC56J1DRwEOdQojrvmnAKKaue6GCZhvwumFsmQLme
	 EQBiMsiAs9D9Q==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id B6979F40082;
	Mon, 25 May 2026 07:38:32 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 25 May 2026 07:38:32 -0400
X-ME-Sender: <xms:uDQUanCDmppCKeiz2qrA5JZErSd-O7vrl1e2mVJ4FpuY_q_33mAx1w>
    <xme:uDQUahfeSr95wETKWsj0ApKSHvTAl3WyHJE3tHe-JqYKaVbmPYIji_e5puuxYhlB5
    ACTKD3V56SoGM2WODqfToo6GxqTBwkrKEp1S2Yypu01eV-hIKBKfQ>
X-ME-Received: <xmr:uDQUarF5Wq4xaQM9bNiNGLqTDviEC46ij7aEDFociQZ5yqGninlkru8jY_r2Ow>
X-ME-Proxy-Cause: dmFkZTE8BdsnOcJoKEIc8nWENdzZ3IJcc78XaZb937JZptTbBfsj35uOLLco64YanRFUy/
    vxRRXxJncUkkFhQ6Fw9JoTXNpIBZaIk7PJKSogIAKlou1fnKpK60SVEE9wIdCSKeJSiEmd
    jMYcCTSecv2wdbvACcZ3jQHh2R35wiBKAXeBalxbQ8obtaPzZg26qqKn3eo1ycSESHvZEY
    8vksW44pxFuJVzxfC4xrmaM24Xz/fIt3AP98RkQGIoAMYfpB8FzSca86T9jBGlmKI9r1LK
    Ip3BvhMbIznxq4KZmZ20/tINtDmxtvyOkjCcERfRzx2DQnK/TIBWkODYKxc/0O8u9p7eJa
    T6hUf/mJ+nZsoYTOiz1Cb2+KAyyLn0R/R3r0RXsTw92y0vMFHqj4tuch0BcWUJnAgHF7i/
    +IlIGXUBbqz9Bx7N+IqZu0eIRx/QKzC+NGbTOHcutWN62zk4j/RMaPb+JSnw6d6T93R7WZ
    EVhNnroNs/TZuBT1WuQkCYX+SZ2FzCIAie68u4T2p1kMzTZgpZz1ffVrOpTkSTeM9TTw7J
    5PoA0rJUHkWCHnmr3yBrOogvJhpyOE0hIjyRmOMgfWE1IzSRJqTy2GvZ5LPWm3UqHW07RR
    ozbHcuNNmRTa7lzT7rTHgZPmXovuzFqMR7wOx+AlXANnURdOGf+6g5b4XZtQ
X-ME-Proxy: <xmx:uDQUajXn4qQ3K61z3CpXCtLQejXcNISjC6Tyl8u5iOFMKLl_Ng26RQ>
    <xmx:uDQUajxi-vnQVGvWfI47QSP10nHyUHVrhDTDUFgF-mRe4F3WuDUstQ>
    <xmx:uDQUamvNdvoYmbtDkdkQPUFHDEPcbn_5obXorbfGg5v4iSdpAiaSVA>
    <xmx:uDQUasC-uNmtWQg3pxy50VbCuyO6k4Lkf3GR2Yff7-Hx7WxK6CRuHg>
    <xmx:uDQUaqrmq2CvtAzTAJZ49o5e3QjS91Uvf72In6N5nBGjuLYMRVOgIvci>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 07:38:30 -0400 (EDT)
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
Subject: [PATCH v4 05/14] mm: add MM_CP_UFFD_RWP change_protection() flag
Date: Mon, 25 May 2026 12:37:19 +0100
Message-ID: <20260525113737.1942478-6-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525113737.1942478-1-kas@kernel.org>
References: <20260525113737.1942478-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C3B1F140011
X-Stat-Signature: xe4ph14jgdgwwmd883k386jg8b75q3eh
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779709114-417307
X-HE-Meta: U2FsdGVkX1+C7ln/i/GIZ0+mX5n7WsEV1Nsl04ux+ZF34HWX7Crcwkxb8EcV62UZonOVZPZ7dq+DGOzYNaNPY0dRKu3eYFXM02FZJxTphbq4VcFvpqjegz2dFzBQBTI0tVI9VQzu/SR5izXm/9cCgjO53uYbfQzDKd4xGw22lTfwoUDAewzmfUOvCYHzoJ5ILlHHXWzFvOS5h8SoGWcnKsBItAx9UuCk8UX6Q0eb3vvED5Hz9n7uTAliFSXs96I2VEMkXkO+ofvb098V2y8LQYPzWRYb6w6AiuPtVl319ONPOpRXxpc4qIIfKgGCJQ+3fz8/r259Lta1IESuV/Nyw6dmtT4iKFsdWfJrvMnOj1MLt/Z8ysOXgXBD72xAPNV+Eu1CcFZX1Fj45K0hAWKglAdGs3IwX/H5cnjpu4C2cAiRoMTRl6VEw7dWD/Z0XxzHGubNauA1RoOJ7M3XrV4ejoEg42coPxiDaka9ssX94lH6cyiLlnz3Fe6MUo4bmHt4ROjrq9J6ye9GvUiYB8SDi2UAyNyGcIGQDBTbkZ9pNB/UnAqe5V1vaHJLPXjtHBcGkTphT0tnAdPpDCXMhRc5lqrBJ7n31odKxgp1FUlRuv6Sfo8T6/jW2EqNzNKEE9MVFzgtxASJKBzu+FGdRtZrruH1bOVrV5RCcgKYgT5YDbQhrThdRu7vQ4j1rJiBMYh0dxRLJ4EYzB+JLoHSnbh1cfANVHU5jCxy/cE7ONoULVaZQCCr/6fGL4G6g1AEK61F7mxDEJlGqvmw8w/37MJhxG1RJu6Qq1LvWunA0U1RerGnCRhnngk9VK8XxVSB3GClWxy+mosZUoQSlQXmuee1GxuZeD9NZ05jbMcJ30vUGnT3eo3+VIdoiL3nNc70U472JQUPW8GorDdAxY06Ms+GZOU2qlTGCsNZ0eU+u/znDU3SIivl7kXmRz9vuOkrlw3ygBI1GBYXsKpuP7Wv1vj
 fcTZRlg5
 RKrAEGjIfYqShyYM+i7iy53dkO+U9dVgFXAHw1J3PawPBf0TztNCq+jPiLq1QIeJ+CGzMZUceWMEgySC4V8JYYsJRhUjsDtp1SmJWjsGreiJiC5mfsTH6/QMWPggDMEIpZ8A+ndC7adRsDfQuSr8PC0WkZ5MBMwsDqjkHCGFfqzD2D8HamT9NoE9JXtV+LbwTgLqnyIbHP5KJ6sjAplgFACxpGQJgFVjvIqod3kbBQCE50a2n/jKo4qVSw2KSF7SeLpOM7VBgQv0bJjUScs7AGfWNoEy+VP++VfmrwFjOzyGtCOxZ76w8j8XaEvZCBDfEWzmx324LU+P429BPVIvlzlUyDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Preparatory patch. Add the change_protection() primitive that
userfaultfd RWP will use.

An RWP-protected PTE is PAGE_NONE with the uffd PTE bit set. The
PROT_NONE half makes the CPU fault on any access; the uffd bit
distinguishes an RWP fault from a plain mprotect(PROT_NONE) or NUMA
hinting fault. MM_CP_UFFD_WP and MM_CP_UFFD_RWP share the same PTE
bit, so the two cannot be used together on the same range.

Two new change_protection() flags:

  MM_CP_UFFD_RWP            install PAGE_NONE and set the uffd bit
  MM_CP_UFFD_RWP_RESOLVE    restore vma->vm_page_prot, clear the uffd bit

Both are wired through change_pte_range(), change_huge_pmd(), and
hugetlb_change_protection() so anon, shmem, THP, and hugetlb all
share the same semantics.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h            |  5 ++++
 include/linux/userfaultfd_k.h |  1 -
 mm/huge_memory.c              | 30 +++++++++++++----------
 mm/hugetlb.c                  | 25 ++++++++++++++-----
 mm/mprotect.c                 | 46 +++++++++++++++++++++++++++--------
 5 files changed, 77 insertions(+), 30 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3d0a5ac3c717..ecbf3e83a892 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3286,6 +3286,11 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 #define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
+/* Whether this change is for uffd RWP */
+#define  MM_CP_UFFD_RWP                    (1UL << 4) /* do rwp */
+#define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
+#define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
+					    MM_CP_UFFD_RWP_RESOLVE)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 87a8cebd5938..16fbe11c0c55 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -361,7 +361,6 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return false;
 }
 
-
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6017c73c92a0..0d05abb0cd81 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2640,8 +2640,8 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 }
 
 static void change_non_present_huge_pmd(struct mm_struct *mm,
-		unsigned long addr, pmd_t *pmd, bool uffd_wp,
-		bool uffd_wp_resolve)
+		unsigned long addr, pmd_t *pmd, bool uffd_prot,
+		bool uffd_prot_resolve)
 {
 	softleaf_t entry = softleaf_from_pmd(*pmd);
 	const struct folio *folio = softleaf_to_folio(entry);
@@ -2667,9 +2667,9 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
 		newpmd = *pmd;
 	}
 
-	if (uffd_wp)
+	if (uffd_prot)
 		newpmd = pmd_swp_mkuffd(newpmd);
-	else if (uffd_wp_resolve)
+	else if (uffd_prot_resolve)
 		newpmd = pmd_swp_clear_uffd(newpmd);
 	if (!pmd_same(*pmd, newpmd))
 		set_pmd_at(mm, addr, pmd, newpmd);
@@ -2690,8 +2690,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pmd_t oldpmd, entry;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
-	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
-	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	bool uffd_prot = cp_flags & (MM_CP_UFFD_WP | MM_CP_UFFD_RWP);
+	bool uffd_prot_resolve = cp_flags &
+		(MM_CP_UFFD_WP_RESOLVE | MM_CP_UFFD_RWP_RESOLVE);
 	int ret = 1;
 
 	tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
@@ -2704,11 +2705,17 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		return 0;
 
 	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
-		change_non_present_huge_pmd(mm, addr, pmd, uffd_wp,
-					    uffd_wp_resolve);
+		change_non_present_huge_pmd(mm, addr, pmd, uffd_prot,
+					    uffd_prot_resolve);
 		goto unlock;
 	}
 
+	/* Already in the desired state */
+	if (prot_numa && pmd_protnone(*pmd))
+		goto unlock;
+	if ((cp_flags & MM_CP_UFFD_RWP) && pmd_protnone(*pmd) && pmd_uffd(*pmd))
+		goto unlock;
+
 	if (prot_numa) {
 
 		/*
@@ -2719,9 +2726,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (is_huge_zero_pmd(*pmd))
 			goto unlock;
 
-		if (pmd_protnone(*pmd))
-			goto unlock;
-
 		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
 					     vma_is_single_threaded_private(vma)))
 			goto unlock;
@@ -2750,9 +2754,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	oldpmd = pmdp_invalidate_ad(vma, addr, pmd);
 
 	entry = pmd_modify(oldpmd, newprot);
-	if (uffd_wp)
+	if (uffd_prot)
 		entry = pmd_mkuffd(entry);
-	else if (uffd_wp_resolve)
+	else if (uffd_prot_resolve)
 		/*
 		 * Leave the write bit to be handled by PF interrupt
 		 * handler, then things like COW could be properly
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d0c81a056ae2..4d75b69d4272 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6395,6 +6395,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 	unsigned long last_addr_mask;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
+	bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
 	struct mmu_gather tlb;
 
 	/*
@@ -6420,6 +6422,11 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 
 		ptep = hugetlb_walk(vma, address, psize);
 		if (!ptep) {
+			/*
+			 * uffd_wp installs a pte marker on the unpopulated
+			 * entry; uffd_rwp does not install markers so the
+			 * allocation is unnecessary for it.
+			 */
 			if (!uffd_wp) {
 				address |= last_addr_mask;
 				continue;
@@ -6441,7 +6448,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			 * shouldn't happen at all.  Warn about it if it
 			 * happened due to some reason.
 			 */
-			WARN_ON_ONCE(uffd_wp || uffd_wp_resolve);
+			WARN_ON_ONCE(uffd_wp || uffd_wp_resolve ||
+				     uffd_rwp || uffd_rwp_resolve);
 			pages++;
 			spin_unlock(ptl);
 			address |= last_addr_mask;
@@ -6475,9 +6483,9 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 				pages++;
 			}
 
-			if (uffd_wp)
+			if (uffd_wp || uffd_rwp)
 				newpte = pte_swp_mkuffd(newpte);
-			else if (uffd_wp_resolve)
+			else if (uffd_wp_resolve || uffd_rwp_resolve)
 				newpte = pte_swp_clear_uffd(newpte);
 			if (!pte_same(pte, newpte))
 				set_huge_pte_at(mm, address, ptep, newpte, psize);
@@ -6488,19 +6496,24 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			 * pte_marker_uffd_wp()==true implies !poison
 			 * because they're mutual exclusive.
 			 */
-			if (pte_is_uffd_wp_marker(pte) && uffd_wp_resolve)
+			if (pte_is_uffd_wp_marker(pte) &&
+			    (uffd_wp_resolve || uffd_rwp_resolve))
 				/* Safe to modify directly (non-present->none). */
 				huge_pte_clear(mm, address, ptep, psize);
 		} else {
 			pte_t old_pte;
 			unsigned int shift = huge_page_shift(hstate_vma(vma));
 
+			/* Already protnone with uffd bit set? Nothing to do. */
+			if (uffd_rwp && pte_protnone(pte) && huge_pte_uffd(pte))
+				goto next;
+
 			old_pte = huge_ptep_modify_prot_start(vma, address, ptep);
 			pte = huge_pte_modify(old_pte, newprot);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
-			if (uffd_wp)
+			if (uffd_wp || uffd_rwp)
 				pte = huge_pte_mkuffd(pte);
-			else if (uffd_wp_resolve)
+			else if (uffd_wp_resolve || uffd_rwp_resolve)
 				pte = huge_pte_clear_uffd(pte);
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 8340c8b228c6..4a6b35482aee 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -214,8 +214,9 @@ static __always_inline void set_write_prot_commit_flush_ptes(struct vm_area_stru
 static long change_softleaf_pte(struct vm_area_struct *vma,
 	unsigned long addr, pte_t *pte, pte_t oldpte, unsigned long cp_flags)
 {
-	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
-	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	const bool uffd_prot = cp_flags & (MM_CP_UFFD_WP | MM_CP_UFFD_RWP);
+	const bool uffd_prot_resolve = cp_flags &
+		(MM_CP_UFFD_WP_RESOLVE | MM_CP_UFFD_RWP_RESOLVE);
 	softleaf_t entry = softleaf_from_pte(oldpte);
 	pte_t newpte;
 
@@ -256,7 +257,7 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 		 * to unprotect it, drop it; the next page
 		 * fault will trigger without uffd trapping.
 		 */
-		if (uffd_wp_resolve) {
+		if (uffd_prot_resolve) {
 			pte_clear(vma->vm_mm, addr, pte);
 			return 1;
 		}
@@ -265,9 +266,9 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 		newpte = oldpte;
 	}
 
-	if (uffd_wp)
+	if (uffd_prot)
 		newpte = pte_swp_mkuffd(newpte);
-	else if (uffd_wp_resolve)
+	else if (uffd_prot_resolve)
 		newpte = pte_swp_clear_uffd(newpte);
 
 	if (!pte_same(oldpte, newpte)) {
@@ -282,16 +283,17 @@ static __always_inline void change_present_ptes(struct mmu_gather *tlb,
 		int nr_ptes, unsigned long end, pgprot_t newprot,
 		struct folio *folio, struct page *page, unsigned long cp_flags)
 {
-	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
-	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	const bool uffd_prot = cp_flags & (MM_CP_UFFD_WP | MM_CP_UFFD_RWP);
+	const bool uffd_prot_resolve = cp_flags &
+		(MM_CP_UFFD_WP_RESOLVE | MM_CP_UFFD_RWP_RESOLVE);
 	pte_t ptent, oldpte;
 
 	oldpte = modify_prot_start_ptes(vma, addr, ptep, nr_ptes);
 	ptent = pte_modify(oldpte, newprot);
 
-	if (uffd_wp)
+	if (uffd_prot)
 		ptent = pte_mkuffd(ptent);
-	else if (uffd_wp_resolve)
+	else if (uffd_prot_resolve)
 		ptent = pte_clear_uffd(ptent);
 
 	/*
@@ -325,6 +327,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 	long pages = 0;
 	bool is_private_single_threaded;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
+	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	int nr_ptes;
 
@@ -350,6 +353,14 @@ static long change_pte_range(struct mmu_gather *tlb,
 			/* Already in the desired state. */
 			if (prot_numa && pte_protnone(oldpte))
 				continue;
+			/*
+			 * RWP-protected PTEs carry _PAGE_UFFD as a marker on
+			 * top of PROT_NONE. Skip only entries already in that
+			 * exact state; plain PROT_NONE from mprotect() still needs
+			 * to be promoted so future faults can be distinguished.
+			 */
+			if (uffd_rwp && pte_protnone(oldpte) && pte_uffd(oldpte))
+				continue;
 
 			page = vm_normal_page(vma, addr, oldpte);
 			if (page)
@@ -358,6 +369,8 @@ static long change_pte_range(struct mmu_gather *tlb,
 			/*
 			 * Avoid trapping faults against the zero or KSM
 			 * pages. See similar comment in change_huge_pmd.
+			 * Skip this filter for uffd RWP which
+			 * must set protnone regardless of NUMA placement.
 			 */
 			if (prot_numa &&
 			    !folio_can_map_prot_numa(folio, vma,
@@ -667,7 +680,16 @@ long change_protection(struct mmu_gather *tlb,
 	pgprot_t newprot = vma->vm_page_prot;
 	long pages;
 
-	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
+	/*
+	 * MM_CP_UFFD_{WP,RWP} and _RESOLVE are mutually exclusive within one
+	 * change, and WP and RWP cannot mix. Miswired callers get a warn and
+	 * a no-op; userspace cannot reach this state.
+	 */
+	if (WARN_ON_ONCE((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL ||
+			 (cp_flags & MM_CP_UFFD_RWP_ALL) == MM_CP_UFFD_RWP_ALL ||
+			 ((cp_flags & MM_CP_UFFD_WP_ALL) &&
+			  (cp_flags & MM_CP_UFFD_RWP_ALL))))
+		return 0;
 
 #ifdef CONFIG_NUMA_BALANCING
 	/*
@@ -681,6 +703,10 @@ long change_protection(struct mmu_gather *tlb,
 	WARN_ON_ONCE(cp_flags & MM_CP_PROT_NUMA);
 #endif
 
+	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE) &&
+	    (cp_flags & MM_CP_UFFD_RWP))
+		newprot = PAGE_NONE;
+
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot,
 						  cp_flags);
-- 
2.54.0


