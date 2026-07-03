Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 296FBC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B9EC6B00D2; Fri,  3 Jul 2026 09:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE0A6B00D4; Fri,  3 Jul 2026 09:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2706B00D7; Fri,  3 Jul 2026 09:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E66976B00D2
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81E4B1A0117
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:40 +0000 (UTC)
X-FDA: 84947565360.26.13B95DE
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf26.hostedemail.com (Postfix) with ESMTP id 888B8140006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=ejslr1Hb;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="e lGJQbF";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085798;
	b=CR5BgJI4ez7TBpcchf3rl+lPguOZf/7QoN/31HON9MPexkD9XyH2RHm1XbbXM1gjns4oId
	waMFXc8aAIcdlPwAMHoUBoM0FPS5fwze/BRK63h/WEfX3hSZoUMUil+X9SCw0fqs/lOrX4
	5YbvFj0ncydejQohZhpBPEGOuHWChkg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85dlYldMrNgF2zIT9pjGLNO/irueGh3B4Qs719th2NU=;
	b=qgscKKFH2lanUTkyCg1s4ZYN5md0V+B7hFQ6rC1l+EODScWc9DtjkDALbUBK8LlJEN0pou
	gVp7qC37v81Go43FTr/zlKNhvgwvVrb4qutFUC7CGUF4MCpc2MFcWoESWE3Oru+OfrM+bo
	hXQOKCTjH0uXX+UiehL5oB2UutlsR/o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=ejslr1Hb;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="e lGJQbF";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 59D417A00BC;
	Fri,  3 Jul 2026 09:36:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 03 Jul 2026 09:36:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783085797; x=1783172197; bh=85dlYldMrNgF2zIT9pjGLNO/irueGh3B
	4Qs719th2NU=; b=ejslr1Hb1TanYaBqdN7/UCzmY5igA1r0UcJLJ3SPzTA7LIyU
	uIxU2cOKkBVszgdsRFS6m7m/akyDve5GKiWPpUsG3Pfq5qD3ohvcISH9iyOeEqTN
	IC2wl1yMYmIxx6XSsywU07e5H0tQLnAdpMsvZIU4Nx2B0oM3R5LjRd1iMWxzb+1j
	iRXnz8lcqgoASlJTpAm8tuCb6Vrppei+4GSrYhhit8GZqHM++BUWbfJFiAJJ7RId
	f6kuWmRi/uM52hQCXUSfuolALWo+UqznD+DEVgI2CCfavSsjvzQH07eYEA1nIX0z
	7WHfvM9xYgi6g/3T7iKNQDZtRMNA7WuHKKmNZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783085797; x=
	1783172197; bh=85dlYldMrNgF2zIT9pjGLNO/irueGh3B4Qs719th2NU=; b=e
	lGJQbFsyDuD8W/3HDbQPjWJsY+gMsEUcvJDAXY0nFu6Qx8NnSaH3GyyD78N8KBCD
	Z6ffubSOVErLwD1MZl6K2cJ5P0skZyOIsahJ1kE0ZEirGe3L0x5m/DlDZerbTYCZ
	xxcAUUpvpEr16XV4sPicZijNcU+ugkpqfbYUPIH9kcYy1XvmpBJjpbwztEcDh+OC
	o1cbe8WcztGJAxSJ2f1dN1LBbDdONqL4/PdBimIOZKGHRVA1rNR2k9b3z32Y+drH
	Fjkd354sS7SvYE3rXLSRyKYZ7offfiZCrIGPowSHwMqSN5qyf3jfVCZqBprYtyZ7
	zoHVgiGRRF9ZcpkaRtpvg==
X-ME-Sender: <xms:5LpHarN3E7hRq3pPQTnXBL34-ukKJX_korzISCY1S-86zYd0xRk6EQ>
    <xme:5LpHah0JlrmO81c5zYCJlFX3QlkyAxitSY0rnmmylmr3j2K0ZrC58t-Syhc7fzRji
    DXTgQFWAEHxh6tgwLnLwBC7Y-1vCYUuvD7sGwi9fGW5I052J_ixOKg>
X-ME-Received: <xmr:5LpHajEAqs8HxdMOHmbOUWWi8gZqc_qXXqGu3y6CcNJTmkhwTDwrFMQp9RR1ow>
X-ME-Proxy-Cause: dmFkZTEvpT7VPI/TDUGEnnIrVlILKwXgeXt+foeC++RMQKPZsPpb69BYeN94A6l/J4m8GR
    j7cxKNSW+PCS7l0cP9ewYlNjp3o4SRzo0q9x8boy+qMv6IPQeEYIg3N09NNUL1YwXh4Yrh
    l/VK9KxOHmvITqsfYi7VnRs0zn+zCS3v2T7VSdeEEdSIb4snV1El6VtdknOa4IcxGosKQh
    b50hZlM8u2LRvSc9TWKyrKm8vDP+A/+u7lOr+AQwZAIydhhZxADZY4tnbcibEwn1oxgg5G
    tZcbEgM6HqFuHN1XrVgTaj9QN8QlhWjwEBL1Bk9WTH3MhpwrPTlQlB4jwdEhPAmIPHL5rB
    E+BR9L7ZGxpnTAOuykqSafcdbeYuAsisWNnkdE+kvpb0P+kOLNwRrKcLheiS+dMO8Uyp1u
    sZ8HqVCYvyxfJ2R85y53+7iOv61EAZTx0JzwcLPiyFDWQh3aFfxBNVmsPYCMkCVH60Rk+v
    xmCwbshEupPTOOP2rTDoDz0hR9v2tMi54+3VM4uWMF+Mv4PZuvyAZzAuzYzIyOW3y2MkTi
    rSA4FtkX8nEGQ7KEkYYqkZh8Jngaze2+JGKgDCnkq0ZO802pm4sNrGb1qth/VeCsEYexN3
    qMmaE/QuvVOo1TUReaRvM5mps2457yQfuFa1id/TjU/zAxvm2aXpU06gybBg
X-ME-Proxy: <xmx:5bpHaohtgqHXtlKqKfwL8GkcsAO-2dZCGwXvA5aiBTf8yOL15wOXzw>
    <xmx:5bpHasfkmdvtGnz5-bvO59mUfTeC7pRHkc5JRw1zLHPft3j06qc9rw>
    <xmx:5bpHauxYdo0fJRZ5Um7Q0tJpqP2QBMhpupTYELPDbuRA247p3hwrag>
    <xmx:5bpHamYTeomuNbePsEXi4dCD8DbCeloWI7msfwjdrDTFIFZ95iS7Ng>
    <xmx:5bpHam-YZmcsTZJHozUf5xIVlOxBUS5lYKj-Ja8sIZ1lvAs9V4dfxCAj>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:36 -0400 (EDT)
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
Subject: [PATCH v8 08/15] mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
Date: Fri,  3 Jul 2026 14:36:07 +0100
Message-ID: <20260703133615.1039465-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 888B8140006
X-Stat-Signature: aano5gyddf9pq1mm3n4c4hpy635br9xa
X-Rspam-User: 
X-HE-Tag: 1783085798-673099
X-HE-Meta: U2FsdGVkX1/yZC8xK/DvyWR04/MJyWIX42RvZ9IERro7UA0jhTDdR4pFHSPYzuXIy79C53vDB0UvsYEajm3y9CkNgcdmsgKZCKQQMcWa4zGhuF2BoduysnnYkzNSRTKbfbMb8x2YV1szvL9jGtUek5FgSxlu/5NCCQkM3cb5H4TycvBvGgrLDFSvcemhHqFmaKvhNWAb1mvT61A1kItOXxtRI/ySMEbx5itxfJBfmk5boFuPZ6VxNlTbdOnvBjM7GshvdhfZjQbnJ4ZZpSe+edm8W5IuzGiD33MN6l/mQu5iKzeSMaGqET5JKcNQJ92FZ3rb2S8HOTWRMRTjqHN3K6jPh92Y96JiNtcsdHeA8RJzAqf8kJy94raD4UjmEeqxNkLzJ4PvwgKQOZTfmbR7OFvbUoPNTgasJJL2bMfwvPy3R95DScoGZ39cbJLYWY4M4Etbdi0/gWVChzowt5WF24RWp+subOBd8YWHdjkNZ09YxafEMcsGyeeNyqaSIm5VkaDAJSqMaiukcba7jgWSJoMfnnW6q6PsskVP6j0Sko6XsvH+opfNNufZhPOoPlSIXV2x49zaTuoIcYC8Ct9uFfPJq1lg8600sliHoAkE6dK6Zl525iMDGc2JO2P+4qU4yhqg8VvCJW9Q6YfeZiHguA1i9vFowKGi8YO0bjKXfXXPfdcQwN9iFHFJgJ+pJmtDTcc3Fv8mZuTtNdhifDFKQ2MtgEdqwZHQX3bL66t04QcbERDIaOvQEtw2DqUMrUWInvEJeaZ86pGW06q4nF5uYmH/jTaIi0JIgacXXcK0c7gzZdqjRwKDYeZ4uFSQRw2nlxkNTqo3FNylT5tvSzV/KntavLNnPkryIc4ZIapSdCFZEwjdmazs5JGHgh7wnKUZWlcr1b0OshFd2xiVkWMNcouxPejNHrGcmV6/Ub0hxOwJkRrfOOZEvQUbnNQJGz2UFxSWqWc/3Ggxm6oZynT
 UGpD7jwl
 fEcNTQxIStpyRGvB3i+ABBSRbAJ4rMejX2LKeVFnTxzoII2uE7/8lblqsEHif8GVyhpcMLMJ2C+QcH4ZDwcdmI1F/bGcr2fjTX7EJEJdvX7O1u+iNxrny2GUoFxL1FpgGM9/VED34NNmLt8iKs1k8rR3b0w1FsMnHJpAy+UwhGeX4q8ydHHB8ZQFCT83zo5LekJLDg2nLyjLgUXNyKv9kF0gXHypNTno84CNNEUTkzErjsA1ayaipiEKZtMZlJSOTm5jyIcFpcsxcXyb72yyzgYadvjrqy5xv4YAea5nZzUTdeXhvAs2KY/6pp4GkDyiov1WgCFGKPSeaFiLFJCC+XjHL8Q03N2w8otrRDTrXIMWjNJ3rFNiBss4K4HvV4pUkg8uKo6dVvm9x9/j3k3AdCfTVE0VcoHwwLQbSTU3roI6wjt8P6hyHHlhEiXoRj14ZGzu1gnX/p3eJIj3+Px7vpJQ/lxeA10hXR0DK6bX1Tfx54PgZhqOgt6SbfTFAqPNTK4SN5A5942u4Q03nN5QDi3ALZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h | 16 +++++++++++++++-
 mm/khugepaged.c    | 18 +++++++++++-------
 mm/rmap.c          |  2 +-
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3d4d5f9a6f1b..da8a07cd49a1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4644,11 +4644,25 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
 
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
+	 *
+	 * Only do so while the VMA is accessible. If it has been made
+	 * inaccessible (e.g. mprotect(PROT_NONE)), fall through to the guard
+	 * below: forcing a fault there would loop, as handle_mm_fault() makes
+	 * no progress on protnone in an inaccessible VMA, and the access is
+	 * denied regardless of RWP anyway.
+	 */
+	if (vma_test_single_mask(vma, VMA_UFFD_RWP) && vma_is_accessible(vma))
+		return false;
+
 	/*
 	 * If callers don't want to honor NUMA hinting faults, no need to
 	 * determine if we would actually have to trigger a NUMA hinting fault.
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9eb03f1d1f1d..483bcebd6977 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1892,8 +1892,11 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
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
@@ -2106,13 +2109,14 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
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
index 546bc1cf9391..9fb733489898 100644
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
2.54.0


