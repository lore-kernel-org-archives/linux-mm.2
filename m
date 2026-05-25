Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EEA2CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85186B0099; Mon, 25 May 2026 07:38:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D176B009B; Mon, 25 May 2026 07:38:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73636B009D; Mon, 25 May 2026 07:38:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A61576B0099
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:38:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52BF1A013A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:38:54 +0000 (UTC)
X-FDA: 84805745388.23.2BB127A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4058140014
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:38:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dkBJOnaF;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779709132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ps0N9FhSg2WInzdVQ3glYAf7iP/rHFVJxbQNtaX3gcU=;
	b=w2/WsotL0VmyDJ1VjZvBWDmYKQDlFtQXQWTtMUBVepo7ZOlrmY6y1YLfg+X5AMRnhzZvk7
	ALsJbEF9yhNQxhMqMBbdjO0x+UfIvFZzRuEw7NaQw8kjKvXKE4LB7AW0hJA66DDxSnWQny
	anS2rvgO9W/xxENd5ektP2HB3Eu4Qq8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dkBJOnaF;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779709132; a=rsa-sha256;
	cv=none;
	b=2xKjxBdfuxYUgmbhUeiOT5CAjoRjYGgavo9rW6j3+e4dR7GfLY3KM9ARFJV4DIPYtxZoPA
	pxOITNphADylB4aMiXXG5z8lKB6y9+ZrVp4uXtaGbmlJWIuvoY/DIj84ciWsoTSRpJylii
	FiYvBJAyh57oNRQTy200rnQwP18yYGI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A93A403EC;
	Mon, 25 May 2026 11:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19971F00A3C;
	Mon, 25 May 2026 11:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779709131;
	bh=Ps0N9FhSg2WInzdVQ3glYAf7iP/rHFVJxbQNtaX3gcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkBJOnaFtPJHLE94XqDZFU860sPGU7UzqZ0m6KATTLDfn97gNkoyhMMGP3n8BUDdf
	 yStaI0Zj9oe/YyTCO46KyUf2YrQOFc+RbTr5Kscr3wEQ/ZRzGssPHhDEZqa+ikY/hV
	 O/gnXnAnHs6fDoXFFXOmzL96PSb1hAOXEjsHLnmdSZKIj6yrZ8C6wqL/Fdsh/E7g/I
	 K/SOZJbGzjeWiUYiOoUepHv+IkntOZFO3WmXkOWSqRZUNq3hTbsl1imM54fX3vSEo+
	 BELRoFfFt9w89ZbcpZYyfiqvi1dmsREfIzeLwnb1sGMjzRv+xNHudvCqctojOUahB5
	 iUFaSHNAFqfEw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2B394F40082;
	Mon, 25 May 2026 07:38:50 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 25 May 2026 07:38:50 -0400
X-ME-Sender: <xms:yjQUanH5l21ui60CT81whN-ivvEDqs95Je949U64XpoWDK_Uc6DRUg>
    <xme:yjQUaoQCJ_TDYdo-4ViE6BK6ydWzVA2P8KbA7axeOaWBw6UPCo8rwJ4qArS2eSc8d
    ItzcDEyVu3JxyzVYtKN-jG6rSZydTLrmLPwzZ_5MFu1vlqtCx8pTg>
X-ME-Received: <xmr:yjQUahrqSxOxePBbrU_ukRcNMwAY1XZBeo22zDEEfAcXDc1-W5h4kVW31KcOqA>
X-ME-Proxy-Cause: dmFkZTEfoRdVBJYWBUADV7d9kIV+Nxm/pVUcgu2VEqiWnj8eQrxuVRmWJvpc9q3Oqv2JCI
    in3fN4Zd8kb+AIzxXT1aE8XhYzXjllPczHZpsDuave1RqUEJt2aM8NK4F+1xGB1lHbYgSB
    4+lR3LF0kMycZigQtO5w6VfLN0Aex+LApk+NDe4mN/AQtgEH82UY4yLdpanr1nUEhfYRPX
    qXaeB8tr6YycPJO/GKcHBfWh4XfvSwFXkiL84UUAHkAJqW6Bc0LpWOIYef91VRiFvO85Cg
    Xd8jmXx4jYBCkCANHtSsVLhpCbXIiIojLruOFr51QxylDrx8yfg2/g0kqIsUfNxsLFZyNP
    nEjj3iDx3Pih6xK1tSzuV2TKDG9t7caUpsOxcJHSxNo/j6vMD5+xZJdixPCSN5F5VW5BpS
    CMhUff1ycXkGeotLXYjcA7XaRuiwzGRJJYP1CiWCis02P2P2D+sbk/R6Vq3YcOpvx+7NVY
    02CdvOeg4gtHAIdwNDSdP6hvITAphIltUDsfDNLu1gKBL4QkleYh63JZk6PEiUDceeiqTk
    pjg5DSe82vF51LR2ATCUKQH7BsFFjuliK5Avxdd8WLkHY6w4J3QIZyAaJgZHBy+Rd9+8bN
    1XCHyZJhWdnxFkS1nrcinn/kw+oCB9wEdzzkHbYBwGwNowh5hGHHYdqYGn2Q
X-ME-Proxy: <xmx:yjQUauoZejke7cUDVFyqgSWZtEJZbPrMgza4v4f7qzWHAYDMkXiV-A>
    <xmx:yjQUak2XxcoFHFheX56Q5ui38MoWnc6tTGZiO2v5F2n__ZX6M1cjUw>
    <xmx:yjQUaqirVRwOz3EsiwQF5w4KM26OzLChgdT_NJk2fqhpyu0a3RsyLg>
    <xmx:yjQUarkshEdqK5I_GJo0hLKmU3u_XucSeTX6F2p06ds4TKl8WaPwTg>
    <xmx:yjQUaq9vozRPkAE8dAOEcF9hZTm7Uah3DKosBWDbC5e4wMOjpCS1SlQr>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 07:38:48 -0400 (EDT)
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
Subject: [PATCH v4 07/14] mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
Date: Mon, 25 May 2026 12:37:21 +0100
Message-ID: <20260525113737.1942478-8-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525113737.1942478-1-kas@kernel.org>
References: <20260525113737.1942478-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4058140014
X-Stat-Signature: jkig4sxuqyt3d6hq4uwaxktp5ptqdwam
X-HE-Tag: 1779709132-851299
X-HE-Meta: U2FsdGVkX19Mk2hOPYaJclP/Rcyso0CZakXnW35AnscSCLlILOGuF+JGkbFULW6vgnhnKihdtSAcr8+RdZU/R32sYk1T2oQ26jfvhwXHxe3aN5rTpL63WrDUXIVo26hzUoM9T641cXBAkOdhOProKhxG2FZoV3qwXA0VXAYY5wm1jIBoUISUicXfIAdoyvkDSX5e8QKEo9o7IN/YGalbF2MQSFzhlmnCiQSEUdgNaDq0WipQHb1+vvEjtxySKdzPmBD574JVcyphSXbizovvhcWe189Ay28/K6X4YQKKFgPEs16L3hcFF+XGnDruEZeeswa3BCZy541cYsSpdzuI3Y/vjehFbZ/7c0N4nyNNKVTxIrS0UqjfqktlJK0SBzg+StX+Y2T1OKFW3B0YReYHMuDuVgsAvJvLG5i51yYlnX9wnO2CdoMs+FySOcE7hY7IkMn5sHiRiYskX3KPSN33jFo0uTtwXHkeYGAfFthf1JBh3GFoFNhAJIU6/puZQ3iP0W0WFukfGNOwnYJX57cq/NEsBUg6QjykkbZEg87naIgiTGg9UEGcjfqrA6MAq4Bnb8T6GlPA95Fb6qrnQipnATrF2so63JZ45Ai/l7SO2wGXNB9QTqbKWs/lDTjHazu9ywDOxjTD4sK/cbdU/TglWxAgYGhJff7vKrwHvMyfej2PQ2MK9Cq5PGotL1a/zB9bO9reICzhsjywFlkj7qPg5gQCUIHn7Y7VhO6LHh8lqR04j+mGxa+rTX0bzpS9rHjXtq0AqIllm8gvLudn581mn93wOjRhKZNOa4XCPmrUv77QNMd+Ktd2L+ft7Kr7Sm5dp0xXV6Wk8viF34qnCutatxfpwFtyiBQzs1rlr9MJahPub9uzZCdN0l2lqLkCIE0o53vIluBS0fA7NglGnVb3a8FPWs1hpD7mxqvIYVz9FAD6Oq2Jjjf1Se1zFeQwezUYGp29fWt/U5sBnVHJF3j
 LCMI8TRr
 zH6h2Ts61OjkRubxjlRKAW+IyCec8KVoonJRTCw4nW9HOk4S/RmZ7mo3Qh5fKVXDmjAU0Lt+Su+5pgpD0dYWg0JNSlQjJHjlcH0m4YkQKDF1MmVk8ZaxboCEvk2YDSXMqZOB0SBdybhT2+UerrfyVUFR2AgpQr1FMQBHpYEUZmGFETJxyTc2rSrjJGQHh//E3H4VCWZ03vJQ81Wy7/iPlWRkk/dFhpCatWeKbmTrWEgt+0FMcxynfDNLmjDBkN2jyKCjzhmPXEhyu0xxD1qWi4qbL8DyWtx0FOXlAH3ysoCe9Vfg9zYR4VHXcPS8jYgLojPAbbqthCyrdq8cdT1YkH3IT5M2NY+sBoNp92kofXaWP/vsHM5gVdhwu3g==
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
 include/linux/mm.h | 10 +++++++++-
 mm/khugepaged.c    | 18 +++++++++++-------
 mm/rmap.c          |  2 +-
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5953106758fa..f72bf5ccf72c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4600,11 +4600,19 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
 
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


