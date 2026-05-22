Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7271CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4681C6B009E; Fri, 22 May 2026 09:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419D76B009F; Fri, 22 May 2026 09:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF9C6B00A0; Fri, 22 May 2026 09:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19DCD6B009E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:39:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2DDDC05DF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:27 +0000 (UTC)
X-FDA: 84795162774.27.A1B874A
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf06.hostedemail.com (Postfix) with ESMTP id E08D118000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="q zP/NMz";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DWpJZoir;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779457165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AEyMHg1oOHsuwGIljLpw3KfnAjCT3KTeRYSFg2+miss=;
	b=rTLbLUHxu360HV+MEfK1x1fkaDd/6/ZJE/i1Dj3IlkjJ9SVkYkY/hMYgK3DyuG0imnIApd
	XXlhC+95z+gZRhTuZ1L8Ub8lMc9UBL5S92/ot4UyKmw6qiQg+Aduhai5KT3Q1CBf4urkFI
	TI8aqXvbNEPI/nAOiQScrtbc1XpGeX8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="q zP/NMz";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DWpJZoir;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779457165; a=rsa-sha256;
	cv=none;
	b=TKo5JBZ9vDTFdDHX0E+b27ox+cTOKVpL6hSk6o0eBat1vV5Pufp1HA1K7BAkItbjouD4qt
	sI9Hwk5q1ooKoyL2E29DMtjj9nGxxVtsd0u3ZxF057lGohoTO2OD4woDBGrd9v6ZPiIJmq
	yvX33df2L0uGPM7wItypxpHHTCZgQBY=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 8D2CA1D000E7;
	Fri, 22 May 2026 09:39:24 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 22 May 2026 09:39:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779457164; x=
	1779543564; bh=AEyMHg1oOHsuwGIljLpw3KfnAjCT3KTeRYSFg2+miss=; b=q
	zP/NMzVXVKgSNlFJSft4zW/bChML7pyvZaAJ/F56xdIj9LPatzAWQyOpxeCP0b/C
	gIbNg1XXiKd4ibxnDnDd7GNYOx9RPG8kQRlAcGSSNRJK066nJeTKEY9ilxWubtP8
	3VeFOgGg5KQ8+u83EDjlWjtHsJNd8/3geRl2pSitb7xEXBDYU3w6eZS6GN8l5kYA
	myUwXFb+V2ZmS1qR0eyX5qJE3AxW4WxFetrCUP3OoX0TPDbqPK9Mfnf7gnjJSHel
	UK1MlopP4dD+Tk4XbbSvjEB7xq2XfJUnc/wk01g6c23Pe2LrDlyjDGoSUimEIKs8
	yIGAsB3KXvbUpCZv7gFqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779457164; x=1779543564; bh=A
	EyMHg1oOHsuwGIljLpw3KfnAjCT3KTeRYSFg2+miss=; b=DWpJZoiry50QG/vQk
	OfR9VgpMdrpdZiIMQsW9ZVBxu/qRVRu+R/f1kvdLIZqUHLV8z3anuie2fe250zwv
	7AyLVT1ai82ET05wrkWT4q2iEUuaUB6G+kmViEHwgYhzhqpi7EyRrZ0Rrr32TdjO
	T9clD4TyejXsfjdo0Rv19mtnxPDrA/OAHew98F/K07HMFyeyX5JWACjEgzYGsdDi
	4TliQe/8EjM2xiIliH25RQMeSUogofHgwHNTjYwqgJhcm+6bzigzH8a2QGw1tKZm
	r82rq8tGL4YggAs9KEiLfQeuXxgBEMRjbFct8J5Q+rFoFgGTTp3MIzQuZ+R0GelW
	nRHEw==
X-ME-Sender: <xms:jFwQarFJxOB3tnPLBlcfYq4wv6EovEsma0Q-2w6YIYNyr4QUFlIncA>
    <xme:jFwQaoA7fLGVVwtyxEzwAHpOOrOhdeyMAY8iuXfl005YnfsYfNbrnMEPWlpYuHghL
    JRweDN90mvMuFwqoidpRDamvl7tMDLiqSpYW_q2f2CYJBBUbSYG3A>
X-ME-Received: <xmr:jFwQan-bNFwkTCMGdkxRy7wvDt4w48a40jfrb-KlloCJ1hwvkWuNax6IefYClg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtfeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefmihhrhihlucfuhhhuthhsvghmrghuuceokhhirhhilhhlsehs
    hhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeegveehtdfgvdfhudegff
    euuddvgeevjefhveevgefhvdevieevteeivdehjefhjeenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:jFwQargKfx-kXBGZg9nh1gTlWXDtDSBuwMgTpABMq3T9r--v7gn_rg>
    <xmx:jFwQagZ5nWj0AGPrdVs1T9ig1z3ve2WARH3q3NhHHzYrhfAiwWt8TQ>
    <xmx:jFwQatRDFPbQuENsxsm8IvGmPl7Qmxn2eu4FIsdEQ9gKyhC2yFDt8A>
    <xmx:jFwQagGLX0yp8HgT_vA0Tp7kH4UlotRBq8XyCNjVC9V31YMiKzAVxQ>
    <xmx:jFwQajaokjT4q_zMErRUHsBwrzh_YnBx_HEyx5sP3hEisbN6b8J6Ms4H>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 09:39:23 -0400 (EDT)
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
	linux-man@vger.kernel.org,
	alx@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v3 05/16] mm: add MM_CP_UFFD_RWP change_protection() flag
Date: Fri, 22 May 2026 14:38:46 +0100
Message-ID: <20260522133857.552279-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522133857.552279-1-kirill@shutemov.name>
References: <20260522133857.552279-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ne9dc9bamxf9k9cim1f8jopx9jfkao4r
X-Rspamd-Queue-Id: E08D118000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779457165-193614
X-HE-Meta: U2FsdGVkX19ajGjqaRKoRjmdQjdm5/sKuJm9QD8QkFjI1CLDAWwimq/H2iCrtihUd7/1AqScKLGs8dV2wQRv+pxaKopPISIHV0MXCvx4gG99EL/11KlKftE8+tVsAtCcXO7YDoC9GLIp362wkMikVSPufKsbFXHYlNqmWzKxoq6Y93hivSEpT75KzUVCQ11RoqDG6bAaIbPBv350277N8tIbPSAvxQFKFydLl8qwlpa6/1YdeRW1yJaHJCb4gD7N+0g8TIJn1uTx22jdGcnwB7n1Umj6jDfJEXg6YTKXjUXI5K9RVqNoh9VtNvCDAyCBU+wD0ByP3eFGeybrR5h9jOQk9ga/eCkPY9Nb4MA/2xqHMTHA8HqtfAqgFYfU/8Il4DBsXHohVqJEQ1+lLpSfJGPKvmdt/zOFTYC6AIuwgAemQIhLaOWLcub9WRfUAtZ2imT+5j5DDPCs+ZKqK0QdGky2uTJYy2mrhNEIEIkpRGS2DrLXL+Iqcr1MDbZzDI3aCFDEDblWS61Xz0tSj90AV5Oj6soVHpzNcM744YDat34C4EtsbXj7aerM9D9WbMxfPEGShfnEynonFYf4MVLC8PMGXFKmyOP2ety+Uy3gZurOJz+Wc7E8koNCxkVxUfqSiAI0BHU+QdWvTcDoJqMB3hx0rg0n1QZiYjrLebdgjRQLJaLzOjUG5spRpA4N2JPqwuG6VFwqsk7vTdWquivHlQ+52zrs4Ih97o/hYONaICajGDsD3wQ07flPbrVQMdk72fAKxUkn69n5fiNO2tEoPjv95o0v5BrUqc2LkxNijWoRigO/1+DCO3MXib03GnOE/pSCmyDv0BH5zOtEL8VvV4xCOwCJo7KLi+OkY49QTlAh8NC+dtiHDv4NbENe0qkpRHhScRDR/QQpb4a4E9UNlQMsYxUOysDNtq+bdcR+wtHYUI+QlzLb0NE805xyJbEm+dSwjWTl9+5Bok5CJwx
 zCitFyWi
 LnychPdSTx38JDVuz3m7afiBscpcqGP+UAwj3wwhMomAVSWrk8sWciPc1/nAhsVZGj2O7BhNfyxeZ6Idu9g0U7u3s1LN7Wxnmy+b8r0zD1kLZE5oNFtdojlJG3sLvJx4IEHZ6DNy4VndIsw1pKYSvxu4fZKrKhk8PwE/pDMPCZN7sCD7cD5GjfhFbsmMsfs9nGQwEd4I/ob3bCtTIb9xeG7Y6Xjz4vYV5ycDQlPPSekFFh8GdiMKdYPjmfDijTq6ntWV/EOE9RvTrQ0iUYmw0+DTN5TC3SozrLYl5VZHVjxJJTKtiBcYT7yLb4kyg+tPGF9EYnppYZVWUcU7eAiNKIS5xU92mBuS0vStyKMk51yQO8KGcOou1+QUO6JA8qNKt4sMoNAVucBeuHJumFtqbc3hdkjiuOGfO9lVd6E5x290BkTtEfClaWOiKsEbAus/zI1wULSDpvvnnsxVuaiXYNZJvZNulmwK54Pm00XtlDRdltPdL42x22q+C5/wi/IXY7sQtpjCqd+CNjxnQadlXfyrVGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

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
---
 include/linux/mm.h            |  5 ++++
 include/linux/userfaultfd_k.h |  1 -
 mm/huge_memory.c              | 30 +++++++++++++----------
 mm/hugetlb.c                  | 25 ++++++++++++++-----
 mm/mprotect.c                 | 46 +++++++++++++++++++++++++++--------
 5 files changed, 77 insertions(+), 30 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3f53d1e978c0..9054468774b5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3291,6 +3291,11 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
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
index 889c7b45fec8..07766398d592 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -397,7 +397,6 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return false;
 }
 
-
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d88fcccd386d..befc919de69e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2615,8 +2615,8 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 }
 
 static void change_non_present_huge_pmd(struct mm_struct *mm,
-		unsigned long addr, pmd_t *pmd, bool uffd_wp,
-		bool uffd_wp_resolve)
+		unsigned long addr, pmd_t *pmd, bool uffd_prot,
+		bool uffd_prot_resolve)
 {
 	softleaf_t entry = softleaf_from_pmd(*pmd);
 	const struct folio *folio = softleaf_to_folio(entry);
@@ -2642,9 +2642,9 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
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
@@ -2665,8 +2665,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2679,11 +2680,17 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2694,9 +2701,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (is_huge_zero_pmd(*pmd))
 			goto unlock;
 
-		if (pmd_protnone(*pmd))
-			goto unlock;
-
 		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
 					     vma_is_single_threaded_private(vma)))
 			goto unlock;
@@ -2725,9 +2729,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
index f770c6504e26..3cdbf0057dce 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6409,6 +6409,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 	unsigned long last_addr_mask;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
+	bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
 	struct mmu_gather tlb;
 
 	/*
@@ -6434,6 +6436,11 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 
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
@@ -6455,7 +6462,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 			 * shouldn't happen at all.  Warn about it if it
 			 * happened due to some reason.
 			 */
-			WARN_ON_ONCE(uffd_wp || uffd_wp_resolve);
+			WARN_ON_ONCE(uffd_wp || uffd_wp_resolve ||
+				     uffd_rwp || uffd_rwp_resolve);
 			pages++;
 			spin_unlock(ptl);
 			address |= last_addr_mask;
@@ -6489,9 +6497,9 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
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
@@ -6502,19 +6510,24 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
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
2.51.2


