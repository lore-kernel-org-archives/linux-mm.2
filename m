Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 244A7CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A546B0191; Fri,  8 May 2026 11:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8620C6B0193; Fri,  8 May 2026 11:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777446B0194; Fri,  8 May 2026 11:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 615646B0191
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:56:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2067416019C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:24 +0000 (UTC)
X-FDA: 84744704688.29.BDB3AC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C038E1A000C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hU0Kx4jv;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778255782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0krAFgWuO3vxxCbEiz8zc77hTL/ZCtpxhEE+SQW208g=;
	b=S8Ql0nqwYibCUAHwks8j4PLnYhnbhksMeUcoRK7JcyXqncDZmN/y69qXoPK3juizVY7pG+
	cX5VCFTiLlTI++ESZ9kW3RJ6jyvsm/XRs1YvCWUG1ZlYR4DyK0qG4+AwLY/rKLV1VhFq0k
	s++Y0pTM/OIaUdS4sMnuFRmMCF1vg1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778255782; a=rsa-sha256;
	cv=none;
	b=ijl2O1fvU5rgUq7jME3S4IVVglZafKiYIpZcjSl9521NG8e188e10ZQCBY0jJDJLuZKbZn
	gW7eOMPce3fmwBIf3HSbcr/wsnE9F9LPZU37xNZuJ0FWTSUN1tlX7zZ7C1RXXeBf/iVE7w
	st9NehaOcvkXN+osK6xz/rUUnbbFc4U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hU0Kx4jv;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C54B743870;
	Fri,  8 May 2026 15:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15015C4AF0B;
	Fri,  8 May 2026 15:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778255780;
	bh=SzqfwSiyUU02tgjSPhqUv8OOpIHzsky3BsDESvPxOA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hU0Kx4jv8opPELm/W/R0ERofPOn6z4prL6Yg0u/lllM2Y9ss/Po0kU0frDJG0l8cz
	 fFGHuT8DSi3zcM0+i02KrouCEzBIv6b+JTXu5/NpBNYVtmNH0Hg17IAKrOScaJbxaO
	 fBLHMgHRkPkioPwIH3daHDzG0sQzO/gYy6MPUgEcS/0Bkjjtuck5ycDjTRt0yoFLCE
	 vUDqHv1cUAOfsobHedCS33QY3Yiz8bHKbeW6DPjL2bmjh6+ffPPcV6I+qr57iqQ2J2
	 fYYc2ZgvXw6Sf5i/P9to+zFtHF2c5JqQYMnLv/cKNoeVZIQWexLDS9H32XbExYC7uW
	 t4uhPsF80sKuw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 647C2F4006C;
	Fri,  8 May 2026 11:56:19 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 08 May 2026 11:56:19 -0400
X-ME-Sender: <xms:owf-aX_q5-ODpLVY1DYbQsrCs7Fn3LbWVqdl7nLXpDcBG5gPf7X4Ng>
    <xme:owf-aXo5q4OuAVtwt5WYY9bHGzITT8taSaUehrdNgCuqNkMLA4ob7tQiUxH_C5mVp
    h8os32SzXr85D9z7aM6J6t_3QZQRFFZJVC7JQQPqSC6_6F5_mPy-w>
X-ME-Received: <xmr:owf-adhUwPZ4xdXLMwuo3zsOqVj5rPaRpvboz5XJehoV8EARAve1WxPpCd-XwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduuddtjeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpedfmfhirhihlhcuufhhuhhtshgvmhgruhculdfovghtrgdmfdcu
    oehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhephfdujeefvdegke
    fffedvkeehkeekueevfedtleehgeetlefgfeevveeukefhtdetnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtph
    gruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedq
    khgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtg
    hpthhtohepvdegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhi
    nhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgt
    phhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrd
    hhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughi
    rgdrtghomh
X-ME-Proxy: <xmx:owf-adBAGtXYh3l3TBHYl3mZRBsO4yKB64r7_9BY7pizGpgqwwQyBg>
    <xmx:owf-aTvL8EC8h-cEJyGgxu2JK_lp36GQRyy3rwELjk-6ypuUypPx-w>
    <xmx:owf-af6byoBtE-o9afAy4SXX0-wyfswBfNwtqncxRsLnqUA4M7qbnw>
    <xmx:owf-aVfFg0CBAcqvV7dcy06choe1uXV95ZPgjz071xPAYDiFybA_sA>
    <xmx:owf-afVePZKqXZHxjtwm0_n40kYq_3l-frhoTguURXTUM3F3ZeV22jVM>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 May 2026 11:56:18 -0400 (EDT)
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
Subject: [PATCH v2 05/14] mm: add MM_CP_UFFD_RWP change_protection() flag
Date: Fri,  8 May 2026 16:55:17 +0100
Message-ID: <ff3420fdd75f58d56827ff3d2eaffc0d74154627.1778254670.git.kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1778254670.git.kas@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C038E1A000C
X-Rspam-User: 
X-Stat-Signature: 7zwhkqxmf3pg9pqjapjbrgtinntdn673
X-HE-Tag: 1778255781-640335
X-HE-Meta: U2FsdGVkX18Jfqry84OKAd3c6lAptH4gklgiiBhjWtNtcbdQY4d6OESKz8IkQUk3amnUnLb97FrcGy8CAJFV75eh5UoU7p53ErTM5FzR8PG/5f/nqhYTwctvtblMd08DSaSTpXbIS18G1xkuE0qH19+x5xAyd7LxyoWmiJZO0XD8kgDRgQYxWvYdEv5FzJhJUYQfSkTnwGq3PmZBJwt3vk/LXjWg4CDm/aOr4zdtuA2sZmT3nuwbbxKwd60Doa/wgc0dakeY1w1t2ZNt75ZMMVLZB30DpTFYpLpqaCHvCIbFWPDJ7r96r1ra8HOQa/K+BNlUWdKpmFvF7Ptm41nNboCA8c3o6l3QF1Y/D89fINSi8AzfEeNdnHzN+3F1CdUC3OX4ePLrxD340M82bgGpT3nMWWt9vRiaww/Z+jdU89HpscMYY+uO9/n3OOu/UuRgh2gPHfThLQ/2sdCpivEtKK01lZBLoX+H2+TdcRLIQChHSxfdXoFNilBNF2HOoOLEVp18zHkqzmKB3FgDbzd8mtEO55Vh6Jja7jq/uCxydI2ZLwVbvzeQhOAB4vtLe3fVph+VWIC6riOVo9UWpY8GuZdUsCJ3FQWMrph6qGc1wB/9+0WkfRGJpkXefh6O1coOKEzJqm+M5YuQ3FqcHk4+2r+akj05LMiHW8Z9JzeTkaXopKduptjhNvlhK47KoYhKsVzVTVMUAr6NWTjscQ3jm5N/MEaYO/IC9tNQLBt4YxKPMg/98sFzukFxtmiFAhxVjgC1/2c8+EwgTQAjQ5mdecL8xhbMi5mkx+Dpj6ad1dId5THCBnGLYRloOJblzOTE9Vs7EoMitNmVgwRso+8WTe6fV/GKwfql8Z1UrsJiMEEbzQht9Ol1VT+Gp/mCJUaqGlJKcMXcW/wFKx2rOAYUTwQEG5yt16O8lWJC+Xc0vnBdRB8LuqWtlhxxsLGz+609fVV452md8sn+AwWb/Yk
 iao4iaXJ
 0s9RPgSiRvWLsAbnXvFBTAUXAYuUOap76ONSJVKIR/LtY7/RwHJqHRcRmsy72NGKPM7rfZrzYtHAMYO7FG2Xk2yA4SkmSagm9vrK74Erwc2WDgDeKRWWrayhA+znTblvfiiGD+JSwZDOmImh2RxaBxgEtDxnRcdmdJJtkUWV0JA5J6ak3VqJaxN90EL2RRkqKoZ3AuJFoevtUwTBuMS/gPieEtzCcdbh758K2VM9QkLP5XnvmqpNGibD9YVY36SlouYm2nhiDxhvu88DGCMwsR99U164Too+6It22dkO24Iwstu/ZGm3OE/1+U5CY+3reDSYxaHKXuEaq6kClGOEMq5VdaA==
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
---
 include/linux/mm.h            |  5 +++++
 include/linux/userfaultfd_k.h |  1 -
 mm/huge_memory.c              | 20 ++++++++++++------
 mm/hugetlb.c                  | 25 ++++++++++++++++------
 mm/mprotect.c                 | 40 +++++++++++++++++++++++++++++------
 5 files changed, 71 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3f53d1e978c0..2b65416bb760 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3291,6 +3291,11 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 #define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
+/* Whether this change is for uffd RWP */
+#define  MM_CP_UFFD_RWP                    (1UL << 4) /* do rwp */
+#define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* Resolve rwp */
+#define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
+					    MM_CP_UFFD_RWP_RESOLVE)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index fcf308dba311..3725e61a7041 100644
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
index d88fcccd386d..2537dca63c6c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2665,6 +2665,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pmd_t oldpmd, entry;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
+	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
+	bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 	int ret = 1;
@@ -2679,11 +2681,18 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		return 0;
 
 	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
-		change_non_present_huge_pmd(mm, addr, pmd, uffd_wp,
-					    uffd_wp_resolve);
+		change_non_present_huge_pmd(mm, addr, pmd,
+					    uffd_wp || uffd_rwp,
+					    uffd_wp_resolve || uffd_rwp_resolve);
 		goto unlock;
 	}
 
+	/* Already in the desired state */
+	if (prot_numa && pmd_protnone(*pmd))
+		goto unlock;
+	if (uffd_rwp && pmd_protnone(*pmd) && pmd_uffd(*pmd))
+		goto unlock;
+
 	if (prot_numa) {
 
 		/*
@@ -2694,9 +2703,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (is_huge_zero_pmd(*pmd))
 			goto unlock;
 
-		if (pmd_protnone(*pmd))
-			goto unlock;
-
 		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
 					     vma_is_single_threaded_private(vma)))
 			goto unlock;
@@ -2725,9 +2731,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	oldpmd = pmdp_invalidate_ad(vma, addr, pmd);
 
 	entry = pmd_modify(oldpmd, newprot);
-	if (uffd_wp)
+	if (uffd_wp || uffd_rwp)
 		entry = pmd_mkuffd(entry);
-	else if (uffd_wp_resolve)
+	else if (uffd_wp_resolve || uffd_rwp_resolve)
 		/*
 		 * Leave the write bit to be handled by PF interrupt
 		 * handler, then things like COW could be properly
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 61cda9992043..63f6b19418b9 100644
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
+			 * entry; RWP does not install markers so the
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
index 8340c8b228c6..23e71f68cf7a 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -216,6 +216,8 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 {
 	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	const bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
+	const bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
 	softleaf_t entry = softleaf_from_pte(oldpte);
 	pte_t newpte;
 
@@ -256,7 +258,7 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 		 * to unprotect it, drop it; the next page
 		 * fault will trigger without uffd trapping.
 		 */
-		if (uffd_wp_resolve) {
+		if (uffd_wp_resolve || uffd_rwp_resolve) {
 			pte_clear(vma->vm_mm, addr, pte);
 			return 1;
 		}
@@ -265,9 +267,9 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 		newpte = oldpte;
 	}
 
-	if (uffd_wp)
+	if (uffd_wp || uffd_rwp)
 		newpte = pte_swp_mkuffd(newpte);
-	else if (uffd_wp_resolve)
+	else if (uffd_wp_resolve || uffd_rwp_resolve)
 		newpte = pte_swp_clear_uffd(newpte);
 
 	if (!pte_same(oldpte, newpte)) {
@@ -284,14 +286,16 @@ static __always_inline void change_present_ptes(struct mmu_gather *tlb,
 {
 	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	const bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
+	const bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
 	pte_t ptent, oldpte;
 
 	oldpte = modify_prot_start_ptes(vma, addr, ptep, nr_ptes);
 	ptent = pte_modify(oldpte, newprot);
 
-	if (uffd_wp)
+	if (uffd_wp || uffd_rwp)
 		ptent = pte_mkuffd(ptent);
-	else if (uffd_wp_resolve)
+	else if (uffd_wp_resolve || uffd_rwp_resolve)
 		ptent = pte_clear_uffd(ptent);
 
 	/*
@@ -325,6 +329,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 	long pages = 0;
 	bool is_private_single_threaded;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
+	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	int nr_ptes;
 
@@ -350,6 +355,14 @@ static long change_pte_range(struct mmu_gather *tlb,
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
@@ -358,6 +371,8 @@ static long change_pte_range(struct mmu_gather *tlb,
 			/*
 			 * Avoid trapping faults against the zero or KSM
 			 * pages. See similar comment in change_huge_pmd.
+			 * Skip this filter for uffd RWP which
+			 * must set protnone regardless of NUMA placement.
 			 */
 			if (prot_numa &&
 			    !folio_can_map_prot_numa(folio, vma,
@@ -667,7 +682,16 @@ long change_protection(struct mmu_gather *tlb,
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
@@ -681,6 +705,10 @@ long change_protection(struct mmu_gather *tlb,
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


