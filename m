Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB9BCD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7B3A6B00E7; Fri, 29 May 2026 13:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2D736B00E6; Fri, 29 May 2026 13:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A302E6B00E5; Fri, 29 May 2026 13:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D28C6B00DF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:27:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4730940273
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:27:59 +0000 (UTC)
X-FDA: 84821140278.30.AEE8A02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 39F434000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:27:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dn4CaQqd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8S90nK/A4Vz9oa36BZRAUi/Se+DtN4O4febKrT+1aM=;
	b=OaRmACO70g1JzdPOWSz5ujjMl41H6wQGBxvoHdV8PrV7wIPV5Y4ZKZ8yIhoh3G2pU0aGcI
	q4SCT4KZszVPFK2/WmfX5WX8iOGWI2sZKybpbmkYTQXP07DWSIu1NKEz9NmwunJ9gHAVdu
	V/QsFHieUQTPB1Jl8jnkm8qNuLcau5Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dn4CaQqd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075677; a=rsa-sha256;
	cv=none;
	b=Rnh/B1F0bsPacHoRGlWXeZJ93iEMbgEnMZxk7TGt4phw1R1VNpSdlCqT4e1Hp7F+C9fCjD
	UTBSsjYXZ5ZkdyFN3t2yVuW0GIN96BmZ7bF6/IKHwpZLTDJllwm1YDWAVFK96knVsofbTx
	JjKquAxxPP8VDBmlCqKYC176RDpmYX8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6C94605DC;
	Fri, 29 May 2026 17:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23CB1F008A0;
	Fri, 29 May 2026 17:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075676;
	bh=/8S90nK/A4Vz9oa36BZRAUi/Se+DtN4O4febKrT+1aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dn4CaQqdkZD775XxdG51F4sjVc940OusAs5NiTRX8xiBqWs/kGZfeyW8+5iPBGDz4
	 ACDnQVH7oeqmMKbPlEpTpMTdVriuui6xEyBnbsRKY/huJOf3bsgsuZ4MKrJ+YUvJqs
	 GR8gWsHT87hn+Zis+MdNLFFUFezeCaDrhClCKFpHWnHc8Qs4MlWX7CT8feBI18JvLV
	 Xd3RwD6kLgN+r93N3TsogycwWlqnRFzIkEM8TkD0qNvOlC/PJa9Lgj94bTSrMFFKsr
	 jvDxHPyNCsFLAsH8pB6RPozXn+jZl3mQbsbkYYtrGVhFlfRo8JJHat+IW5S9dtH28f
	 vftWnOfO19ivw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4C033F4006F;
	Fri, 29 May 2026 13:27:55 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 29 May 2026 13:27:55 -0400
X-ME-Sender: <xms:m8wZajKwgzusB7jgUxTZx5J7ZRVjY6ifL2yOsSTWOdcg1SxW2Z0KAA>
    <xme:m8wZarE4oT8SZMV1JFvAO_02MXRSWkoo2Rb6hTUF881MjAp6GQjPIIeWGQoh_FQPx
    _YMbWaGEzfnatTIGIAPfekjVqs2t_hQfZcrtJ-Fbi6YeuiyDWpKRRE>
X-ME-Received: <xmr:m8wZakNpfforUpOIztMPYBOiPD9P22aVAOTBYeirg1nOOZBe52yv3-HhZZDF4g>
X-ME-Proxy-Cause: dmFkZTGahW8s3xjZ3arjCZYsPeROx1tHGGIOxZ4ZTborx5JIY1xfx8o+3Ks6DBHpwKdcBc
    M0LV7UYzyw5BBW/MLyCvRpPXH4b3j/O36w1UIutGmjGoZPWXllz5NGLuWKcGXqDNqja7AN
    LjyibA8JUH8LlxNww+LolPBmmXeffckfCMyZ3ofUE4q+w091KUDN+vWzLN57aJjrFHnLmA
    DJhoBTsevLB+L7lFnUlwKPgFqlT5AUPgwhCfp483ir0podeZjRFOwVO5acGk8d/hTIZjyE
    iTtkTrHlenKgPfeJb7TkHTrSkVle7vVdqqUtJoKJ+Cofq6CG9ZD2U9nUSpGxcnBPWB+GAj
    aAfyt/5KZZPh3PyKNocvyfWJANIOS1qhXy7PHxTWZP532uY7I4vrLb37xDzrgFPmETTkB1
    Yj6QgVJm7pwed8rj3p1ZQfPpJKIDRz7yQpIaWUs5LdB5aIcQcbS+JbFalUsynopvq5VLLt
    D/Zxwxc8ZxqYv991RdEnMr/WS61TyGhBdUudUq+b5dOCTbA2AUb3iZuW7+eUpIjoBF/r6Z
    +Q93xl4ifihWXGuKRDuddGaBrWKT4WIDzJ7IFQ/w77b0pV8eF9LcQcjrwrVdAlkI8GjP0t
    b11T8rdfQLFOjB/xx8fR6UfWZlKIanEIBeSL4c9W9U0lOXpVKX94BD7qOOVA
X-ME-Proxy: <xmx:m8wZal8UmOkCAWYIv0MKcy-V14xxKaDjoxYWd194UTKzTMDoPeYwyA>
    <xmx:m8wZah5ZahDycL-XhByjHc7qqNZ8xRis1vhYq4nVMPWrhP-7SelggQ>
    <xmx:m8wZaqX3SbTIjPPG-TwpvNDKo-gpaXLyVhUCd2MspHB8D12Nbnq2tg>
    <xmx:m8wZanLVCeobmyreJWINqP6hny70VQ3rc5vXkGh9reuA9LtHeEivcQ>
    <xmx:m8wZanR8rnV_YSTwEyUTA8gi8azAg_DAjQeoKnj7jRIWLH_yPxWkCgAh>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:27:54 -0400 (EDT)
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
Subject: [PATCH v6 06/15] mm: add MM_CP_UFFD_RWP change_protection() flag
Date: Fri, 29 May 2026 18:26:35 +0100
Message-ID: <20260529172716.357179-7-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172716.357179-1-kas@kernel.org>
References: <20260529172716.357179-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 14yojxzw9yzb98tz5rpggeugsu4bdmer
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 39F434000F
X-Rspam-User: 
X-HE-Tag: 1780075677-241878
X-HE-Meta: U2FsdGVkX19df+I7BNPomAu/2frJmdq1Ek6xGhcaE9tt7hXcEp9Iddg2xxEPYKq/q8ire8FLIG4EbU8g8PLCix3F+Z5jFmoEGPPNvAzJGJusGFv22k7yC/U9QaLh6X8KKhScjK6zWKt+lTLf74jbPc54DvMqI8FBY2FX75i7lnaHA9E/6zVY1FxjZSNxgDpchG/DFh3RxaEI5s5ZNKoY2ejCyCFOiDZ6xVzJo+AJ8nsSXc8AqOb18ldUIBQT40Rj8V1OB+Phm8EKmR0CyoMREHe1Pri3KGhp8qAEFpIlfEtti7GPDGl/Z8EiLkKQOuFmpfKz4MUFF37gdMFsB0pnkW1Ori70CKRolfUbGEVTpDOOYDwvP7TEebK/30/DKxrc7RCMhPBqHv/Xvon7q01z6Q9eb6gJMooZGNajZAEeivfHUwSK19SKEzJhLYBGpsfouguUmWSf67yOz2GWLH2LOc6mkLJiMI2NBLumk9xjWIn/GpMW5OitaXVhPSHmuM8SIJDyYLmz0/+Xiq8BQAo1LnjvrOYeUNSZ9+Y5iShrOgW+cAKybaahg8h1XbIg802dVHm8Ezsm+pIsCFXa3WT+fuRvOCV3JFraiFYsVe1/5uYeYIW8rUz5yscj3Rbs0pRReQicwJBwCeomoHtv81Ebu3QTwkAfVEzGQzaNsxbPmq8Lf/EqEJL/PNHEd9xAGu7i5eZHSHwNRA464eoPUXeC8yvxGH98VG8EzM7c42hjyMPj31NAoRjIg4+NjBw2mbKY7A0ltHttNwdx5JANIqeXMA3cXrJMvQf4ylkA3sA8urbrfoiLDWBJH8ULrrGwoKzRsjicebz5yVkuXudLJ7YzhiuPus4oiN6gYN4E2quHUbcdMPN50ChjIm9YFoyLVAMyjrjd+OGrDuOFbsF1O2MPUWg2hGkpRdUCtonkTJGX3Pwttv/Neo9TZKhTakoCSXa8sRxy8aB1NsfyMltPz12
 CZeEDRTR
 vJeM8eg2u4ogXhILxtk0BLpfXO23VsIyF41mVVi1vJDHU15VfcuxIsPdz7EJXjPGd/ou94QDWAk8Ls94AcfuoaYdGJaytUuAKaZ9q3gvZAy/xM/xXftyhdwicIteMVgCXdRGQKA/LhKbYX3mu5Tk2kbRJfz5disyAVGrdqEsdEongI1o6n0Fz6/JRJeMRiCLLZh3qQehahKHyEohvd68vZ4mJgc8BtmVR54JdjRAWxRLKk6UNCVEMHU7ABX8owDeYVq4EitaM+MiIPKvJztjUE+8oj+BhaQ3xHE0SMBvwZknpG8VQ+OwxEBl7petFGEkGqgLGSJT54WiJ2rC/CVvOK7vWrg==
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

Reviewed-by: SeongJae Park <sj@kernel.org>
---
 include/linux/mm.h            |  5 ++++
 include/linux/userfaultfd_k.h |  1 -
 mm/huge_memory.c              | 30 ++++++++++++----------
 mm/hugetlb.c                  | 25 +++++++++++++-----
 mm/mprotect.c                 | 48 +++++++++++++++++++++++++++--------
 5 files changed, 78 insertions(+), 31 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5ac31fbadeef..87b2fb1e3f23 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3330,6 +3330,11 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
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
index f3b2db27989b..5115827981a2 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -364,7 +364,6 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return false;
 }
 
-
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d43c2255f47d..40c65bf2d6dc 100644
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
@@ -2669,9 +2669,9 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
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
@@ -2692,8 +2692,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2706,11 +2707,17 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2721,9 +2728,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (is_huge_zero_pmd(*pmd))
 			goto unlock;
 
-		if (pmd_protnone(*pmd))
-			goto unlock;
-
 		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
 					     vma_is_single_threaded_private(vma)))
 			goto unlock;
@@ -2752,9 +2756,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
index 8340c8b228c6..7dcc94e7bfd6 100644
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
@@ -428,7 +441,7 @@ pgtable_split_needed(struct vm_area_struct *vma, unsigned long cp_flags)
 	 * (e.g. 2M shmem) because file thp is handled differently when
 	 * split by erasing the pmd so far.
 	 */
-	return (cp_flags & MM_CP_UFFD_WP) && !vma_is_anonymous(vma);
+	return (cp_flags & (MM_CP_UFFD_WP | MM_CP_UFFD_RWP)) && !vma_is_anonymous(vma);
 }
 
 /*
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


