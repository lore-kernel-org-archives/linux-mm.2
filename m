Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47EDDCD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C81DA6B0196; Fri,  8 May 2026 11:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F8F6B0197; Fri,  8 May 2026 11:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9EF6B0198; Fri,  8 May 2026 11:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9203E6B0196
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:56:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2CEF116019C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:27 +0000 (UTC)
X-FDA: 84744704814.30.D0B558C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E006D160004
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LmBW8ntg;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778255785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVxDpO3C24Xoxf7gic3UNkVZn7Rq4FyWxyLDl5v6NUM=;
	b=nSHa/PsZy0ngAbOxZ8WcUC7NwvP8fihkWMn4V0PmXvsBPmFiciSq4OawhO6rtlC4Swv3Sx
	DoqMJBJ8POHt+cnO9YctEtGD6OpqGoGo7Xfs6v1MBPvvjLQkwoS1uOgl8g0P+ClRmAhDV4
	P7LO0chIGSYHeOFmXHzgtBbRZn8svoM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LmBW8ntg;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778255785; a=rsa-sha256;
	cv=none;
	b=1U70JDgGjeec8Mer9Ld6XIMo1lKWDmDAyKaLyWZ7rdZhc17KWP6Z+4MxuUMcqUqOsoIOgK
	8fqBqplhKvUILuYpOEmI/eRgir2gy8JNFr7PIcyBEBGtXh4f0tCjeL6LYZyg8d+Ybl6Ip8
	0uuVEA0ARnwRY9naLJ2KHMWzzlRCNw4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 134C5444E2;
	Fri,  8 May 2026 15:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A370C2BCC9;
	Fri,  8 May 2026 15:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778255784;
	bh=6KqTjREg/f3OEz7aTNTkTQsj2SxH2HMauSfeIrq1M7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmBW8ntgbzW7ZqJjeTFsWtiMF26JIqkm05QO3Hl6ujSqV7iEDeUl9savS86BW0+/8
	 yADfJAw1AnYb8358USdI31kbxjK6NuxEJEGIiB6dhABGR9vFLIjGkvpVv7OQDsHkwn
	 9Fh5QDYDKyHNwteZZdNsDyJtZ6veMd0tM1ICAGBLlTv9HsgM/frRjxQSHOXSgzg9Wv
	 hhAXr44NqBO7BYpzISxcM+6q6Z1OyTVwN7zXhLDvleSs0HtEeuiT/HqaQOuTLCYc2g
	 UFrdzIczAhscg2amIXjcDVRx3UdVIwLX5zBCgWgcTqY1JqQBJKQekXsPdgxgM7RIsP
	 jQzUayW1KR31A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 998A3F4006B;
	Fri,  8 May 2026 11:56:22 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 08 May 2026 11:56:22 -0400
X-ME-Sender: <xms:pgf-aRgHrQQko-378y0Ec2Qm8PKo_owtGpXIMP_K4iuOoNt5mC10LQ>
    <xme:pgf-aZ_cVZr06qmrgqf3Dl1X7SW9wYKrXCvtBHve5gSHBwty4WZO0AFFU0UoMb-QQ
    9UPTk7rRTiD6xJjtHXCmWnezNI-TttHfQDWzagVBYGqHOyHWS_hECM>
X-ME-Received: <xmr:pgf-aZkJF2jBcxrd4gQw-9Yx4P9CIRyAFkv70Op6jD88EhjfrKhemBfihXTdtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduuddtjeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfgggtgfesthekre
    dtredtjeenucfhrhhomhepfdfmihhrhihlucfuhhhuthhsvghmrghuucdlofgvthgrmddf
    uceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpefhvdefvdevje
    evhefhhfevudefudejfeduvdekheeludfhiefhhedujeffffeigfenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmth
    hprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdek
    qdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprh
    gtphhtthhopedvgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehl
    ihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehrphhptheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgt
    phhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhr
    tghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmh
    drhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihgu
    ihgrrdgtohhm
X-ME-Proxy: <xmx:pgf-af2cVv1YDLY0wYSuJEG7PjzYgcouZVaTCfOdqLWKx2GXKXvddg>
    <xmx:pgf-aWR48JyQ5uYqVH0VqoiAO4x-djJMf5bLZAyz3iVhDE_E6Klnjw>
    <xmx:pgf-aXMsBpJJlF4fCyePGvrYT2CPkCxaTaY6sH7Lq7-LTZE1fC9hng>
    <xmx:pgf-aShlhbx0iwB3sJB7cn9jiGyxu_ewa23B-NUaqkqioKTyzjSO1w>
    <xmx:pgf-afIwMGd5pR5wygvD5TL1mzyWJnUd44cs5vKZxbnIbgjs_xr3uMTj>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 May 2026 11:56:22 -0400 (EDT)
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
Subject: [PATCH v2 07/14] mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
Date: Fri,  8 May 2026 16:55:19 +0100
Message-ID: <c88e78ffb2cc5ca81f5a6319b7e3c4ffd8baefe1.1778254670.git.kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1778254670.git.kas@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ehs6dpa1k9oi4nprcn9a5s5qougknt1j
X-Rspamd-Queue-Id: E006D160004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778255784-83491
X-HE-Meta: U2FsdGVkX1+jSWHs9+0kUOpoDApC61DqGR1weqpnqSqdkibIItKUzSp2vyw+Horz27mR1JHcU24pzbcGgpufk8mXFBPcE9IW7MH1qDZZazafClAdjxrKGjKanbsSnZXH1inHKtGOqBg96cMH17VZa7QjR8qPRmK53m8osvrTqnw01LOptFSDAqKQb47NHXs4N2WIiuJdt2noNlIFumLrqbGXPQNyhKXEjzsp2yMR/zTznvdNrDKey9uCFFZnG7CGqSs6HtB89zhWUGt5WLJ/d2viZhuJ14rqUm8//b6XapVhFHl+oMD1FB5UfwWEew1gPzLlPzBapo9Dw+db++HGNPEtjKfSLnbqb0gByzToSy1pGC3i4GS8vcH7XChxPCjMMNp1QlitIQEgRIyKmf8vYkULaM5nAzvYcMBqrvM0PUUcG4I0eoiQFbdkPrEgBmKFKORgAeCdbMu+rDoNHZcOfj7TCtCfNxQ5OUnN70vEc14NLtCipjPHsyjzL9UulCNUEaIi8qwv5Z3T72t/dZ7NgwHYsiuB513vSBY7Qa9/AlfcwrXkxHcbmqPBFpAm2vxnpNmhwCHO1wJRjJ3iD8nAupKNRrKGlcWyOvO9f0sEZcE9SE6l+1J7GvMgiQ74XjrXPeYAFee3SIojJhYwPEqhzGTzVSp+SC/Afs6PzpcvqDMvnAWtr9uOGInmc3rUS3sOFAv44VfEPrlEKYa8up9dRbKKe9fnENWHd/WkUa2IXpfm62WYNXz3Cc327DvWW9/txV3ImlnZYsdPK4/u4FTIFNMaCk+y8Du12VLxkljWGUsx4NC48S6ZnwbOCcLwjQXIPCE9Xo8HHfec6kE3Y1afdKDfij1TBrjNBmjA3fJfIwaFTCvdraUWp3iAaIU8k0XhzBnj3plgCsH+J99K2FgnyCE8h4Yt24YKSJbtxHf/F0DmzE+S2CFNwRkIBEFt5AAK8XnsBfKhtNqJJyuzypS
 fd1INqjp
 vX4vX6edV+0OWg6XuiUEfeAzrdL9qkBuT5WWjpf88AMhJ0rqswXl54KkbJs/cHGAjktQ/9q2IQA3oe4wgoNd/EY4Bcbsg1KR+ljrLi787coDv6FxdhBak8STmPJt5SZ6O6J22ims3v1dBoeln9hOolvJMt+xJ3Ya5qply9F0IRUjT8rrhlCNeArqufx5cLvZ53gRS9zw5Vc+QwcJck9J+NT+9teP1XC/bFSd81zstZB1Y4nECURDq52MGOW4XGeVFWP/TcZtTAAG319p5j+WEG7cqK//kkQGOHC517VjriOLhBdDRuS3TIxi9JS0i1u66nTRtkQQgwBZxazumhJEC5rufX1M+39DHeJFlKKrripBgx34jPYzEihyN0nbE1NVVA/IW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three mm paths outside the fault handler gate on the uffd PTE bit
today: khugepaged (skip collapse on ranges carrying markers), rmap
(cap unmap batching), and GUP (force a fault through
gup_can_follow_protnone). Extend each to treat VM_UFFD_RWP the same
as VM_UFFD_WP; otherwise per-PTE RWP state is silently destroyed or
bypassed.

khugepaged: try_collapse_pte_mapped_thp() and
file_backed_vma_is_retractable() already refuse to collapse or
retract page tables on ranges carrying the uffd PTE bit. Broaden the
VMA predicate from userfaultfd_wp() to userfaultfd_protected() so
VM_UFFD_RWP ranges get the same protection. hpage_collapse_scan_pmd()
needs no change — its existing pte_uffd() check already catches an
RWP PTE because it carries the uffd bit.

rmap: folio_unmap_pte_batch() caps batching at 1 for VM_UFFD_RWP so
the restore path handles each PTE with its own marker.

GUP: gup_can_follow_protnone() forces a fault on VM_UFFD_RWP VMAs
regardless of FOLL_HONOR_NUMA_FAULT. RWP uses protnone as an
access-tracking marker, not for NUMA hinting, so any GUP — read or
write — must go through the userfaultfd fault path.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/mm.h | 10 +++++++++-
 mm/khugepaged.c    | 18 +++++++++++-------
 mm/rmap.c          |  2 +-
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1f2b6c6cc572..675480c760a7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4605,11 +4605,19 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
 
 /*
  * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
- * a (NUMA hinting) fault is required.
+ * a (NUMA hinting or userfaultfd RWP) fault is required.
  */
 static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
 					   unsigned int flags)
 {
+	/*
+	 * VM_UFFD_RWP uses protnone as an access-tracking marker, not for
+	 * NUMA hinting. GUP must always take a fault so the access is
+	 * delivered to userfaultfd, regardless of FOLL_HONOR_NUMA_FAULT.
+	 */
+	if (vma->vm_flags & VM_UFFD_RWP)
+		return false;
+
 	/*
 	 * If callers don't want to honor NUMA hinting faults, no need to
 	 * determine if we would actually have to trigger a NUMA hinting fault.
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index de0644bde400..a798c542c849 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1532,8 +1532,11 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
-	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
-	if (userfaultfd_wp(vma))
+	/*
+	 * Keep pmd pgtable while the uffd bit is in use; see comment in
+	 * retract_page_tables().
+	 */
+	if (userfaultfd_protected(vma))
 		return SCAN_PTE_UFFD;
 
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
@@ -1746,13 +1749,14 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
 		return false;
 
 	/*
-	 * When a vma is registered with uffd-wp, we cannot recycle
+	 * When a vma is registered with uffd-wp or RWP, we cannot recycle
 	 * the page table because there may be pte markers installed.
-	 * Other vmas can still have the same file mapped hugely, but
-	 * skip this one: it will always be mapped in small page size
-	 * for uffd-wp registered ranges.
+	 * VM_UFFD_RWP ranges similarly rely on per-PTE uffd state
+	 * and cannot be recycled to a shared PMD. Other vmas can still
+	 * have the same file mapped hugely, but skip this one: it will
+	 * always be mapped in small page size for these registrations.
 	 */
-	if (userfaultfd_wp(vma))
+	if (userfaultfd_protected(vma))
 		return false;
 
 	/*
diff --git a/mm/rmap.c b/mm/rmap.c
index 05056c213203..1426d1ece917 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1965,7 +1965,7 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	if (pte_unused(pte))
 		return 1;
 
-	if (userfaultfd_wp(vma))
+	if (userfaultfd_protected(vma))
 		return 1;
 
 	/*
-- 
2.51.2


