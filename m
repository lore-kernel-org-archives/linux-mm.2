Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B0FACD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90FB6B00E8; Fri, 29 May 2026 13:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41366B00EB; Fri, 29 May 2026 13:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09096B00ED; Fri, 29 May 2026 13:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85C066B00E8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:28:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C0741C0FCD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:03 +0000 (UTC)
X-FDA: 84821140446.25.50AA6CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3DAB4C0006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RT0+kBSu;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A8QQJfS2QfTr6HNQ3SpcUaLaL+91VUPkySopvF24IIY=;
	b=fnc57yYkFElVy4+ouzJSGSJM3vKSWIV2fA7njZK+cnob1mzRl7dSko9XYAEROkYv8Y3Jub
	K5ayrPWusml+8iatG2ptcZnrOzQe25GMdEkwwB8Gql1FHxuLMCsLIcbFRe7Rm+WwZlo9GO
	sd9URfgxyj1j2m8c9ht4RRYPlFagJHE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075681; a=rsa-sha256;
	cv=none;
	b=FI0oCeNAFe3n7dFIetr6JPejvyGpAdHNCV62ymTa0zSa1JCkrUo7nJobAGN7PY269p8qDr
	38c2QTV0bwYY6TgG0M7KtBbfc/jRJjQifc2GlwoNDVKBPW1SR2bAdrb1bg+jaOQuNb4AiF
	kJV1wlSTDpjwGEe6jmNJo0gMKDTONX4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RT0+kBSu;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5686643CE0;
	Fri, 29 May 2026 17:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694B81F0089C;
	Fri, 29 May 2026 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075680;
	bh=A8QQJfS2QfTr6HNQ3SpcUaLaL+91VUPkySopvF24IIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RT0+kBSu3uWNREBJOkj4vAnq274j3wWz1YPp3PrJg2bPUEof291rzZmYp3Y8RYOHP
	 WjoHxznwNMuvus2lzqGdNm9z2PcJoC83j/3VsQ6DnfOZGBMLLphk+i/wdg6OmjhNpe
	 AQxINYgS13DiQdvOmh0JJC67ZI5LsYL5s3h8b8WQtP/fH/odzNoa8JOql3GZf1Bn7b
	 6Wb0trMzouhdukHk+OaaX5XbURNNM9K+1n2fIMIy1QndlSxuIgb4sk9mEvn89ZxDnX
	 eJdKdKEW87IYLeOVzU3lJakcocky8v16GCGUjm1G5JDkZ+T+gq6j691SmBhFB++yRz
	 +f4NF01vixvVA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id C8ACCF4006F;
	Fri, 29 May 2026 13:27:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 29 May 2026 13:27:58 -0400
X-ME-Sender: <xms:nswZaii7wXXQ_O6vm8H9tRtlNAdsD0sbjGaGV6fxe96cEjT9OC5xMw>
    <xme:nswZau7fP7Ozf-Y3C14H18zfnj78meOqqy0OAYsL5_NsBscgPDkcZjp2X0vcnO5iP
    7yCWMutBjbAP6CevQITHjPMkYBf4Jf8BUmyF_OS0rt_qaVadvm-mlo>
X-ME-Received: <xmr:nswZai49pvqhfkqgRC1Nd6714shHHSlLCfwSUSE2p-B73tVpHF-TApgb0szBUg>
X-ME-Proxy-Cause: dmFkZTEHS1Z+n1S80q4BaszFx9bNnHLQ6sgL6J9HpxOFXRfFtKsh6le5cKxaCZzZ/qH/SJ
    zONNCxWzVoPiQhYsD9dliy9AdrB2UY/Bhb82egQk/l96x3r4UUhrX92dr53s7Ptki96Mx4
    DvJi8H/xrcKSa4upwFZAuWyRsvkJtw5DUL41fEdJBQDb5TWXZV3TgknVzb3pm5Cw5eabt3
    ZKinBz9XCIvsS/RAa3Cb6hoIPIA7Rb0ceUklQcqu2F89W2umMVSE8bbF5HocBMl20u4Nxk
    92MelAoY5r8qDI90ESLS21z7KfMewjRnztTxCHQfAtq0f2Qz4D8wiVPs5MI39B39+ARIHa
    4eHCBMOP2+kYi8t5TfwCrqkfAB8edMdtMWBLymx0Sb+U3MH1XCob0Q6hsed86Ynyp4kIb2
    qXTBszFbdd2fiEhAouFzhcL9vJCiVU2O+27R/ACg8CtYfcSLaYSfQ9rUYf4JXpg49vCjgm
    aioJx3kzA6pENDC5SqOv/Jpm2/qBeFr3q7e92hFrjAoiYIrGPCZaxVKCRL5qhRYfvX9tnv
    0x6tRZ7bc6/ll43B9jjIgdK3MwoYJfjUpF+GubErEr4fQUAtFWb8SydJebj1GeY6CZlBDe
    Jc1ugqShldy4SWNio9we7yD2GRZBe3fJQu3zIDQKBYG/E+97zdRhPrflRzdA
X-ME-Proxy: <xmx:nswZakGz7yxmCR5V47K_HnrbOzRpvNGefclBuRckX_N-e4GxCh3FpQ>
    <xmx:nswZaozKUBp6xC2C_g77SuyIqRs4EMftZUnQK0tUo71hxI2RbwSSiQ>
    <xmx:nswZas0rYTtRb6LnievX-M4rM3dVEKOGpN3vI-_7DH1oK_rp8RSz0A>
    <xmx:nswZajMDWBXqQHZmC09qbEkwyFMntkJid9ddBWHCpI1p-bgSC9ck6A>
    <xmx:nswZagt7p34Xx46RXVb6dn-35S2hFJWKmcCWrFBiEBSWVWf9-K9ALOWx>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:27:58 -0400 (EDT)
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
Subject: [PATCH v6 08/15] mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
Date: Fri, 29 May 2026 18:26:37 +0100
Message-ID: <20260529172716.357179-9-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172716.357179-1-kas@kernel.org>
References: <20260529172716.357179-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DAB4C0006
X-Stat-Signature: xwb5dqfzyugqrdufuhhutikghksdm7n1
X-Rspamd-Server: rspam06
X-HE-Tag: 1780075681-730533
X-HE-Meta: U2FsdGVkX1/guseFVO+cFFVn9dEnGN9TKTzo1htAtVZj8exTNNQvUWcmWa1q/FB0+MJjebx2AroJamKDfgip2sZ/KSxjc3uJjaEp47IUzRNFZWs7iWiA5j/zqjDFj0/JtCQLCsJK9EAYSjTM1xOYVYudu066lruhpRPSoUgGa7Fniu1djTA9Y7k/Z8UyMgG5dmbr7Fe5QDTZgjo8niaaMc9jGWpiI59uxzMr1t0nTZEwy00PNVDzDRihPA9tdrfpC4z2SCsVY2r9OFy24t1xj1Eb9k3n+VbIgNj5od86Bt1pn9gstRJqh4vl+OWSo2r6VxbwmSx/+KjSaarOKyVUQNsjyln4Dgbn/gQKusahBsoo25o3K/3c0kbOETq2o0d1VwNImYdM/pbtzdH5LxH3g3zsp2eP3aog1GBNqZa/Aa/03xavjfGdOTL9sOftwEoRnLD057yDTVWbBWfAjMewu7k0FCTXoseBfVHSixSMV55yTMAGulRtL84hoH/khqf79cPs1OJNnaC/qqV1couD2Gn7xSnp8z4CwG9O50z8VtHuqzcLchtoxEScXRd+1u/upGLe3FxDpn8lhWy2/Ugcxciw1/4GYe/jBINjNIshAufT1VGLBIITfKrhuLu4ITkexYTJZFzMBKn/yiCWG0t1/YVwrzZdqmapKvl45NaGQGTwQTwsoXmaJt7k1cigVcCflFpAuhHYFIwwxlrg8h+8oEmKLNJNtWWxGaHMJffQiInWvg5vy5WPAt3uL5gZaRs7uLfWjevhWxK/EdRndPx4qfVp+bY4knpBM6L8Jt9KGRIPDdK0PsJWC0KXYwJjEnUE3JE/wScTFi/SNH84dhI59qXzmOCUmfMFrhldk2sq9yI0dDh7y5ZDH3+StePRtfpBz84M2E8NIxcGqKQt6RKe/bq395D6K/CY0Jv7ImTndTOZenjq4QNvqiuHGXaXsnmw/61CrxcMJMlENxZKNTa
 zFOwleHy
 +eJbpTB5bhfJssFukIY9Ff9uwaDfeb3HIi6/Dv9MMTI3Gp6RRhtgO4n/HRpVo3f3JUjPXEtGSCgmli+f1KZ8geaQzOovlAJduKAeGOPK+Uu1ieQ33lGJyph128yn6XEY3hZ8IFQVwl65PxN5yP5JOY1e8L+O8V3adfLj+0cdfNhKrp4f7n7QO/hS3kgQBjS92dxr5TQcGyAm97Pc63/qRFDE5wrnWScGrEIB2GwWD0SMuVPZ1IlzLs6PdR6KmUQOH/72zCTs+DRYcY0OfJlHxqmrN6ZAnc481H1KsAQBb3FGRix2K+YGS+lfdhaR0pDwzCxCMjHYdjZG3CoghQ+yT5Rl7tObg6D+0vDqcosEGx/ybLq5jiisN3ZDUxw==
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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h | 16 +++++++++++++++-
 mm/khugepaged.c    | 18 +++++++++++-------
 mm/rmap.c          |  2 +-
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3d4d5f9a6f1b..2b04f690b516 100644
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
+	if ((vma->vm_flags & VM_UFFD_RWP) && vma_is_accessible(vma))
+		return false;
+
 	/*
 	 * If callers don't want to honor NUMA hinting faults, no need to
 	 * determine if we would actually have to trigger a NUMA hinting fault.
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index afa218be15de..4f3fedcd75cf 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1895,8 +1895,11 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
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
@@ -2109,13 +2112,14 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
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


