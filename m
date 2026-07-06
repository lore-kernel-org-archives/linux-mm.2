Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EF1DC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27296B010C; Mon,  6 Jul 2026 04:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF136B010F; Mon,  6 Jul 2026 04:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7A146B0110; Mon,  6 Jul 2026 04:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3F56B010C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01D7D1A033F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:30 +0000 (UTC)
X-FDA: 84957725622.13.19635A8
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf08.hostedemail.com (Postfix) with ESMTP id 088F3160002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=EAxH9UAh;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Q jPN+cI";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85dlYldMrNgF2zIT9pjGLNO/irueGh3B4Qs719th2NU=;
	b=W0fsU5ec6WvfS+DDsgPnrAbIjcorEcmUAAjKjAtKFuiwTInei7Nr3PhFgrI3eEERwFiYtW
	zsMwr3o7hNNLilSYlLUGBe5TvOp3pTCLJs+O11TYDpf/gr8WDNheia/g6xA0XYDWaw9DnS
	vmWkcMa/3xQvyzEdjDEgZGteBdungVw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=EAxH9UAh;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Q jPN+cI";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327709;
	b=GH9MX4R3tBG2Mo8PYWgo4nja9UrpIRQMYn9U2TDAlXtExmzn60rqP0EQkPt7W8y1YyHwpM
	OH2lHxt5uZpjenMupI1won5uoidYR3VJF/a8w+g7xtj3dWZlD3+DLZtSJ1uSEoUw+hlbHt
	ajuoao221G2uwQGUOJR250YZqvAZcQs=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 943687A00F8;
	Mon,  6 Jul 2026 04:48:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 06 Jul 2026 04:48:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783327707; x=1783414107; bh=85dlYldMrNgF2zIT9pjGLNO/irueGh3B
	4Qs719th2NU=; b=EAxH9UAhWvZq8KUi4Yf0+Yoczs39dHDOXTPfGTjT8eftHFAa
	0QA5+O+DH5AojbtJSsUFAor0FSGfVkrMFTQaH6M/JE0dAjWwGQEqR91LGWv6SEkN
	tDdcLj1OrsKz53gk3s0RpheMZdy77wQWL5mmInyIz+ol+jnQkSmVHSfEacHQ1Mp0
	+J+R3zvSLk1sTc9CWt2L1JdC9MIvdEtGX5K6YjivGlq+QAUr1ieVVPXu/8ImYsmq
	X3ECJHHZ3b8iYckvaxMQa0wt3AN9TOPcm5xzLR6Z58WkJddnlzo+Rcu0E1G1F8n1
	F9e9HMoTiux1MCg1oNp/DjOJU4WGEA1GkUNliQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783327707; x=
	1783414107; bh=85dlYldMrNgF2zIT9pjGLNO/irueGh3B4Qs719th2NU=; b=Q
	jPN+cIKx5PiypT2ARRNRT572tOK3HxHoH3V8Aa/oI8rGu2d4c8xKEdAP/Li32uoj
	SqL19CC/+IlhX9sQ8bWsftd03XYyktcHIj0bLc68HYaINWUOUnTlElbeC+6oQjhS
	c3LPNp3y2pAEva3e4y8MPgQzy4+EYEZzLh6Ma7vKB2r6eErCJXKl/8Ef1BsoO1E1
	/3iyeOeFlOxdpMND66BkZ7IFl8KNbOL1eH4VY8yJ+DAGE00m7W6VSM6nDjyZT1tS
	lkIEt2t+VgtMxhPACEAHpr2OMCRQMoPfMQUJWM8Y+E/ynbqFXKnJocoAXFB7zDEy
	JfXZq0/eTqWuIJxcb833A==
X-ME-Sender: <xms:22tLarXMt9oYOESL3PNAEhjI27GcUN4cGpW5-pvBNLbE05DsQGsZwA>
    <xme:22tLangOM72Pi4-_hA1kPT5MfBT6Gh2M9qgA4lk_0TF-nVTDgF02-P4FQ-GolaD_R
    7qCRlEx8J6tjqD5RF1THAPyToVVRgBQAOEwwmxzOP_Jgee8W-4zMCE>
X-ME-Received: <xmr:22tLav44Gh0vUjO34Svy5DzAATeg4hTrSp0ImF_aTyGvwf1-vzQ-5lPdzw5Bgg>
X-ME-Proxy-Cause: dmFkZTE1HAxrDWJcKyWNBJ73THul+Pni1RTBd9xrf0khQ62auo02SuQ5gbJLxkQ3Qk71Rt
    f+PGPpiBaizNM2SZ8IrfQsHK3gYtMHoaCLmDTUWsgKKZPvRJtANNe6dp0pRFbSzpZ7Ir68
    3/In0zA3QiBz7VSIJWGJB30Gj5LF7PccEnLnCBfRMAcd0Ruq/WMP2imG8KXscpScOVRs3e
    Q/wFiWTRlZPXmNZzwwnPakhtvrKLPp/eIv/XhxcMzd3pTWLxn9+uixyv/f65anc6A7PACd
    VPXopYse7MIZNJLH0eIKl8RFUktrN1v664xHjciMcFFYVrJqWrPU6fblfiG0/eGu1JYQGe
    +M8lQEJeeJ8BJ3AExmyP5xXBwUmaZmEf1QCUaqg+BaDDLl80kw85fqxz6/DSb2Kr4crD21
    c/s6VUMPwHlxxi6RmfxSpKDUA2ZktaWBzZ9iwh6vPoGVCaDbFwH0vzlYaXwJEp2zelyR9y
    AH56uliHL46u6RsfJ8pkY8NHrOXmftqQ4ha20Z+bQK18Gvsftrf1KgSYyHRabXAhJUYiLs
    OEPqQcwGCxq5vFO9fhjJHFg0CP/cHT0ENivoxsepozBOTPrQfbbGUPIFwiiUT3vsZp8eDV
    Q5klYrgBgDMF9w+pnkkmavOidghARGVqQQnQvm9H9xm+Sa0oldv5n3WgirMA
X-ME-Proxy: <xmx:22tLav6IYjNa83ayTsrwAUwzMd_psGoRALYNRc_MDJ-XVcT8YU-BAw>
    <xmx:22tLatHa-MQnqWfmpCtQZQDtpIEFdcjvRSMAl86WjRloLfS5yQPxQg>
    <xmx:22tLatwCgmi5NiMTIb-i9p37IgNoBGtrY31nECD7PV-YdPzzHXxqpA>
    <xmx:22tLat0Frghtj5KVdnfUgsryMYbQVdcHKqf0IekCvbetQQzxlxtjWg>
    <xmx:22tLai34a4weoVbdtfkHz1Y0zPvvPig0QlTCap_TkblsyYiGpQU_tYyG>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:26 -0400 (EDT)
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
Subject: [PATCH v9 08/15] mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
Date: Mon,  6 Jul 2026 09:47:57 +0100
Message-ID: <20260706084805.8400-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 088F3160002
X-Stat-Signature: wng89su3usq4fnhrzunm8d19wug6sd8d
X-HE-Tag: 1783327708-506611
X-HE-Meta: U2FsdGVkX19Gr7FsYpQS5crzqQfYgMiEXxooDcfQ+7l7NGxH5S1jveoKaNe4bMFoz7tTI04LrbnKbLgCp6skn9VQ+xWStyk+9tvxoXr7Dic4h6uMAjIHIseNcoO1dkxhbFvVO2sV65hE2h5gzG8z8T9LqG6+bUcYl6yPLE5I6izeuCa6snuULJdseDcmsZmGHHhDFnIRa1bHs0n7RMjmY8lTCEN7LqmqMm6HZIZvQDHGooRUy0pfAQUJOn0xIZle05562rJvyBi5dLU181F+XgSgHcAoVjwca2EoMBCOqDy38+YqqiS0+GXyYPsLntE//n6i0WvoR+GpHWnZo5GO3Iu/1tdGDJelg1uQf/aFhKV/wJSg4DlNZdTq4loEjJoAAE1PcjLr0V50UCk1nOpa2k7qDE6QC549ve6ZaiZjqZj1vfROvu65vqRfCsdMjDSyYmTOlEdvfh8/yWpz07tTtWRUFEFn0iEI5C3hWTgIBTeJ4SHvPcr9+Hbfr00geNC3qL8TRxHaOgPDhVIiS1G5aQPz5mK/jHNTRLGMQxvKI4MTl18Drv+ltUUzmcPf7YIKLqUt+J+d1F5Xdo/xyKc6RN20oRejMgf5I9c0hEjzQFoNJi6QqlAaubgRf3JBrgnvXzN1/X8rGwiwCKKnJCSbGLzxiJ+Yd9JCzoUQZAUL+Qb3zzZz7QmN2tQlznjfZ72BLKuDuoQFyp7lgxhV+Sj9ksRrla2B9dW6q9BBwi4BqItUc4MiJT6ZmCniHO8lcHLHda/o0MJhzKwva58VsLO2QG9uM4hMQX5EUJlTkZM8YcTHmfFZrrGC5yKzaEiFgAap1cF3Lua9AlW/Rj/pqPVWBnkFxt/ENSO0Ufn6qshR/On5lyeDk7ZTslT06c6nE2Zn8ddXZ8rf8BFxEuQSjBDmeMGvLMLqijRwhsBGBHn77FqjivaMLEdUWl7VjBjtx4EYJs333JphO94DkOH46FC
 ENIcqlN0
 FH1nBAkNIEyKG6of4dfGEr4oGt1mZ/K36cZr1qAqNn488TIXXw1h/71zQn/iA48xItwFEwejlkwhDRvTKLaS1xkSJg+NBOEQhiHWcmHTAuqGkaOgmDhW+Rka7FBNa/9quFq/c5nFvWfTz01VYBx5Yea1nZN1KJU/dG5s9WoxHJH2Qi8vAyh1kMqNu0kt5UbTSl6D9GM6BiXOAOgZMUczKjfBUHeViyEEHenHGihiEPc/tX6k69s4O6ZHzoLWal+ai1hB9kB9cAk4UaLR6GV9CWvzBrOMxwbbRx0n42xCcIk88edcGl51CGijrh8VvqPvqJeNlatS1MCboYXTOVCEQdOL3bafv031mUh6hOWihX7qRPTEt59gVV1pDYk8eJjy0p1A/Yt5PA+kY95EcqNNa/iqzXmphqAbJ7+NoxqDA7S2RmIobOsDjqwCe1JADxbr/bfMnOEREaHsYmfFv+C/P2+L/JstNZp2TLeDdpQtlumTTz9kF2XBzG7pqVvUMsY85A1h59YdM99eNn7X/h02PfXvVKPBGvhxsQsj8rbQ0Np5G/rV3EFU0DBzKDrGFfoV9ULpa1fRXNQFaXD1RWv4PukBH7NlEjmeYWGNS
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


