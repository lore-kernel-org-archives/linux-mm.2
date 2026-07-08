Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D20C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30F76B00A0; Wed,  8 Jul 2026 07:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08BB6B00A1; Wed,  8 Jul 2026 07:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9206B00A2; Wed,  8 Jul 2026 07:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 61CA66B00A0
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:14:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C36C5C416D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:42 +0000 (UTC)
X-FDA: 84965351604.05.E55768D
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf01.hostedemail.com (Postfix) with ESMTP id CDE3C40009
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=CQwaAHuS;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="L bGmPZj";
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgEQDNZMG8LOJs71RlvC9k9z+2y//F67c9j+0IEQFTk=;
	b=RUiQe9H0GU6fNxPe81HuM6l+W01JqSr5SM7qBxU0CH3QKkkMIxkVPd738AuVgCvzC6n2n/
	Z20xgkVsksiiP3DphayHpHgfBHdr5cBvju/lwqC5OhZmVkV6DteqCfCl065crhwsQ9aLO7
	pnrmq2XfTaw63rnn8fEDnoU73HxazsM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=CQwaAHuS;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="L bGmPZj";
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509280;
	b=8ODpuKHwJHkumdGbp9HOmkT5xUvJwA96FA/LXHQQ1NEmpAD++0+ygsKOMJO9306erynjbn
	4eVTmK+R/N5sPTKmyTjQdYcRlGONdXFVB7X26v+fdfJOVzQn3ShekVi99H+P1Np+9ePYv9
	qjH4FUdik4YphY6+KkrYwHs8Bk+VbYI=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B488F7A0136;
	Wed,  8 Jul 2026 07:14:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 08 Jul 2026 07:14:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783509279; x=1783595679; bh=sgEQDNZMG8LOJs71RlvC9k9z+2y//F67
	c9j+0IEQFTk=; b=CQwaAHuSTBQGHUTATnFRu8i0nA7v++EzLF31DwjFOUDyBEFI
	kWGM8NtlCwYYv//2FZgrucEH3/gcnHAnBsRaIp8QqDDbQzl3eNnFRhCCK2Skg/6H
	yhkf/p0aaagKq6U2DCd3XAyfj0N0z3SHU4TvpD6FxE/6KCaFkF26M9K+2uqcv+jU
	NKR0612lUoceuFOG9ogi04Z3rJFI5UpIo06hcq8ctGc1yz0RPWGQdeaZOA/jH/e4
	LZ+7McM3eFdElWqPMfISz2Yb6x1zkhi7093/rQe8y+UqNuE04Xd3wUK+ketxXd+m
	eX+xhRc1HHugbJLVOm874vZv/G7QdgrBG8n99A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783509279; x=
	1783595679; bh=sgEQDNZMG8LOJs71RlvC9k9z+2y//F67c9j+0IEQFTk=; b=L
	bGmPZjhMpVpnYMGtyHi2lqD2Ipt3HFE04s8wOhYyhwJvo+tpTrbspNbQx+tXWtx1
	9maRK3ZzuRTefEhfBZXDivtc+X5WHTJlLWVA3gntlQ75lms/PiC1nDeufwyk2yJl
	pquEkVGFl2DpCoLwXMUJxQj/tjZ5fiTkqfwnTlK+6Dycw7khZ+y/NhXntJ+u1SLC
	TQnNaxtoDhm8L2HLb/3iq3QVaOoHs02buvff+MZcWrNzQmoeHJ9r8i3xgI9QC/11
	4WdzKZL59Z9d8sc0Icgm4DOptWASNXbkdRjhoiiPAisXVJwbrnupdrKC0yj8kgom
	G2GwnWb+gQhoKvckoDbZA==
X-ME-Sender: <xms:HzFOalEtY84ArZnB1TiCDOFZZh9QNOz3AEwLXR0us7COZ2GC2nRiOg>
    <xme:HzFOauRYx80oytOBYfrVThrLcWNIvNsa7I0jiXd4ot0vKXm0nZHR8ozO1gIUFuGdG
    bG0FmGEjpV6xWMbJPmO_VfMfhP8xPDoQqKajscXGL_ds9hL4_8xWAg>
X-ME-Received: <xmr:HzFOavrwqqpOXl0X0uriwLT62wAWmwPQuJyIzXKASY6SscVKhwtbfIWE3IFdmA>
X-ME-Proxy-Cause: dmFkZTFUNIYXC0Q5t8iqxsk5x/ZZMsEDxIoZnWAQZPTQe2TvhnM3yGqaiQbzxnqs+7JIiR
    Yq5XhJlRG8HRcn4TzRiv2EKww24qGo2vzTE+dwYEALdjzUu9fkyEySz6S/StK8W84OHvkq
    W9bJFACiywJM+FHRWARKJSxsj/OIv5i/+BUkO9YHMo8DRu+y4pegyGixo+73/KOUD27j6H
    5pOE/wzQGFm6/nPC8g/bDVffg3JUC2YP/n7l/I6zXixgasab/b3ztmwGVl8QyMOBshJvPS
    ED/XZSrmnCYJ6UGjCdjgdYCVYCbIESChWLzOeM4GIrKC6PPK50eSw/FV+ttn4eLfWIUOCa
    reRCximkGMFlBGm4weZjQetcVAsjOt8FNdvwVErFunVSPGvfV+vhgUWKfURCh0nQDWgdyF
    4swX1iI1Bq4Lp8sYYh9nSrtbpAw5syb2yeyWWqEad3Ssb3bvH+1rQcV0GTJ8ymqS3awAro
    juTLspFyAVkEuy0CiRai8zjHduuh23IXs9FpmLnKuxw4ihzIua2iaUdNPHKkpYSyTAQNZT
    znVbu0mQW6RiWukl2Xhvenp09lcdm/H6aGYoTu6LUIVyRVsonsAKLSD4tgsbS9wPg8YiZ9
    rOVyQz7kGSw6l9Fad7BynDc/iO4+H9p1dF/e36E0S4bvdyyfLn8dwgWLqOzg
X-ME-Proxy: <xmx:HzFOakpHnaOL3GONKx9lDQ9Y4cGO0Mn35Q9EGzYKGKT-ZeM2xZy0ZA>
    <xmx:HzFOai0pBKsnUuHX7w16ZcbMqJzwqnCMd4fBzBPTDJ74t-0LPwcFDA>
    <xmx:HzFOaggIiYgdxyZlb3HvGLhEXIoVrVw6Ai75Te2V-O5wRMoonqP9xw>
    <xmx:HzFOapnB4OZ4tb6J3Zy-3UhODOp_lbtjMh8Nd__tk-rrSXk-4MryFA>
    <xmx:HzFOahiLBlsby5NQwbbY0M9eJ5Y_XQ3dQpVyxRxheLlJZBF2hzwW2CIe>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 07:14:38 -0400 (EDT)
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
Subject: [PATCH v10 08/15] mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
Date: Wed,  8 Jul 2026 12:14:09 +0100
Message-ID: <20260708111417.173443-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CDE3C40009
X-Stat-Signature: y8hsn8h7sxmb4ofieix6a43ysgowios6
X-HE-Tag: 1783509280-874182
X-HE-Meta: U2FsdGVkX18CZ52WH8okEVjPE0HGZGjX16a5eCSw1v+Kf/Hs3asxslrfnjoIkE7nNBfkWHb4Y/v15lB9p+Rbom/mpobVnJCmzNf96W4XQwGTrfK+fvU1Oncu73IVwJnF//ak7YB0v+UFd429/k0dPcMj/3jrvR+5+p4yKqC4kkw7REW1JsNZQIS3nExyLs/d+3cceVePcWRifveWGklm2rbTsOqSe1LblBqXeokIMGTbh3BnLhD4iPcfLEAf6Ar1CFWXvqJHoIrpYydQ874GPNx7rvg31LbCD8VGIGUoGcRgc2BdNvdRE4hH0/Jx1PnZqK/Kpz6qbKLIoQdc+sWlU3MDwz/SgOfUvnvmP3/2Gz0tlBzvLip39cS9JOPgvOVc7i4H723zymOQOtaG8KPGdi/hQVvD9aHOYyZSgPY70u9ABa23hOcE17qM55l51Rs2A+UBL1bp67jUmZLMTCSarHXxIPHeu3HbVuDZ6/eTVSpggchBoUb4bYmWLtpqBcJIZQTpdGFXyYlBsFaLGrlgmsqxcYzb+22cL73HbDh5qmpT57e5X8yeNO8l731gQbu7RJ/tw4nv9JgNinpVTNNoO+Ea7P793nLc76HMbH/oI+j7CSDtvkcsapnSH3X7mx4X4RsEV9VeumHYouEQ/XA08NX10P22b4thAKYeDMxGrO4MAqtWZA5cIxwLZMlID24FVqxrHO59yobTgtRQCz4DaVIg71tA7DPlqWvma7WQzMj9k8NOHSm2ieg+H/V32q59piUYag+E1dLTKY5MOa0UYU4jMAtREdUOCozAZj4A6mS1yQs85heviW8/P6zSb37nvSk6ncQEd5pcrnzQbEE0EHp2A/aXIDALjvcawOTCYts4DZmvcj28IIXJb1ijonEUTCukYPfRNHnyTI+VtHL5XTD35xH/Rro8DCTvP1LFzS5th7mZ+8LVaNOrdIyNtA7YBKTRo0KTn5VylGaqRK3
 SBAAFr0Z
 luZSuBpskjJc4JLD45E14+WZWND3vF+gKC/zAEg8flNTXRFjLloaJOwTke22xFr+BynPj9FvfBCyGZi9dIXk2v4fwC6tgsxENTq9AXtiINnHfvZ72h/OwVdqC/wNuIQHssiedQDdm04cUkplJHMe60tvx4ZW6zCTFZKLoHegX++C2Ip5Ynfbt5BvnVr/6G3nWfQONTk/CGILR+sIC+M/fqeQaXW6uh0sLdk/QXlSIVkMJ460IFx/Bd9u31JkDWv06XQ1md2Zmn9+Vz1gsgfr/a/TZ0NP5kNTe7xno4VmPECjIW0VhJXmCKrVO6Jsm2QS3E0K0VybJtQNZFJ4m6pc/J8YPJRtym+iSp3TXYHzIdOZGEQq7G0Y5B5xRpwKw8dZH2m1B9UDpNTYTSP/4P6IIEsgoZz88rVg3sYevmUm/shroDAsJned6m1OZSDapNOXZHDhiITWY4gkV6VR4/idKCv7irYfvLfKQjbBbOpL0lZgbjxq19mES8XVTrlRdi+YzHdfJHsidRa3n28yxOQClKtBqHgpRB1VZkzd34vQEERV8IP3Vo6yzwUhio7Z42A+ZKrZU10N7OUk2+4wEL5am8K74nZHQwp4A0piO
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
index 012dbb7f4ef0..f62def4fcca9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4670,11 +4670,25 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
 
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
index 0b5fb0d0a0c1..55157567dc4c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1893,8 +1893,11 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
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
@@ -2107,13 +2110,14 @@ static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
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
index 50f973b63f1c..26166a6b8cb9 100644
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


