Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E188C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E75A6B0367; Sun, 16 Aug 2026 18:46:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF6A6B0369; Sun, 16 Aug 2026 18:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4877B6B036B; Sun, 16 Aug 2026 18:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F319E6B0367
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6450614063B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:22 +0000 (UTC)
X-FDA: 85108617804.02.44DE4D3
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7D1D2160008
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R ILNZ87";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=G7qFUhb6;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sX7WB2eZz/VvYH3aSWITi7MLh+xZLicHniz1/7X+rUM=;
	b=c3jI4PnxZduhzWUobfoUFPKhC57EJTy5u5419eWD+Tm+uQX4L/a8ATNgQDhz/2jdYFxPSA
	hFX8DV7opL8rowOIbeihtmySM30ZH9iO/HM5enMbZUDGl/dxXVtepOpvPDQ5WxnN1R5UWx
	vaiKww0jjYGlzV256rBW6vCNAi30fjM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R ILNZ87";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=G7qFUhb6;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920380;
	b=eJm7+gUoPGyFPuW9s+z+1w/ENc6HGTwXxvRZFhm2c9ekryaU1sRTlfd88a2AlqABEVu0eL
	g1aAfzUREjgV+uamtG0Zzpm7WViXax6s81Jn6rzCnjgue5o1pkYw+9ncdyBVzzLv4RyhVe
	sl4Ek1cmIMAOdNHPNuYrO+BduhoQd44=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 06489EC023D;
	Sun, 16 Aug 2026 18:46:20 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:46:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920380; x=
	1787006780; bh=sX7WB2eZz/VvYH3aSWITi7MLh+xZLicHniz1/7X+rUM=; b=R
	ILNZ87d+g1/9s1nbp82zB0mI4PrI+aktWEf19zi+pWENoo504d2e67BbgSEUH6Nh
	+NBa4zJFPaG12uZGaPW4XrJXO0eEX+8Lg1Cy9Bp7+wV1/07dGfmCj0S6ipGlpApy
	WybuVu60UGDbCSiUplMpZNqy45VWbEVnD25wsuy2KT2CPoA4pQLtwRU8X78rsSoe
	mP7YNcx4NV5pgX4otjGJ4Y7EICNj2IZ2LvoTvZFbifmEKIC5cZJ43SVA5j6zcvGD
	4Jpj5kdf8Gc09S3GmC921A5yjLuKYtydZ6Jfu3OarGHGS8GVsV3ZmWLCGYyExUns
	0oWdnpQgbBMs8cBIiGIIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920380; x=1787006780; bh=s
	X7WB2eZz/VvYH3aSWITi7MLh+xZLicHniz1/7X+rUM=; b=G7qFUhb6XtMIDY+Dr
	IW8SlbfgnPxQU0iMmKxXfLrX3fjUTufNyA8tSPbN91rcCuLXb6JNRrJYcpPkPWtL
	1v8r3662BieAIRUlD+PHAssmKR5pI3lmKJ0ejf+o89hwRyeor/7twEGVyjgLMshP
	5QoEHyPKeI+EMWyxu7ycHjmChYeh87Sa4/AvY84Ha5aKqo5xWjd0NXz/FWQBKQv9
	vG/jdqKR74QwZkCE5PDm/ciExeiC5xlO3XWDa3Qk3wj9vaMIQQpA2Lai3fihj7Aw
	5DeKbhWSC6fJBYTBZZp/cfRYSiDMlb1qpjq9OuGRiT32njRrgWFU9EaHpLqdjCQu
	orl5g==
X-ME-Sender: <xms:uz2CakEmzNk2CPTbiE2p1Byv4N8090nhPr7d_YuApe2SgB8knly4yg>
    <xme:uz2CairlqZLTTBJYJ4VrQauedIABhYQaIRNCO62bCUIV0LgYMQy2vOz1HC8o1Re9r
    bmqltBJD1n7_6Yrt7TXcaf-XC9h-4BezSbSUM9vn4_q9DssgnBW-mu9>
X-ME-Received: <xmr:uz2CaqNGwCHeKc0NxfFeDto6tdodDKr0FXnF96HvYGPhfJWx52jkqadUNy0>
X-ME-Proxy-Cause: dmFkZTGQiHMMNOd1xnoN6lXQSIrGAe7MwYo75Qud3VSOh3aIjL1T4IX+wE1i/v23Y8aWnG
    m9SHT5inuXsr6fNeLF7q+XcMZ+pkZJxjpb2XQQyKrFdYKaLz7QDFEiegvQaT+Y5rGxRgjF
    euipinLXiFMtCpFgMqQP9Dwn4SHq3YG285QsMU4KB7YfRQHYWKIG6dJTmdP/7bPKv1qUNe
    3LkhBXaaROXWrLGafj+UVrogU8Abxo2OvgWTBKIlLl3SY5Eb27sggkfdoaZJgpjY1+W5mK
    IYgTH3bmg7umgeRjJmx+WAhyhWPmGn2xLzWKHa3nzXVCTdFk2+6Uh9D41+s+1+4ThvFtH3
    TF5+acMZn3V2kyzNvRs++91DDKXew9DYXOyEQix+jcX2Yij4aOpcXX1d7+cQnG8rqBXUZ5
    POE9MfSwpz6o4uAqku2Fk/mui8mjbSq4sgrrfJ+vkfJ6Gp+5/Bhn9p5+re7C/IRKkDU64g
    4gbmTiwk8a0UUO+c+nDCpdr//c0KoiHipv/SLkGJBqgqUoywz38yFC3hmxePXhxAL6C77x
    TfWIxre0e4oICcETnXmhzjHmjO1hlQKMhyWrsIDHJfM6eV52F0dmFRugg7H7QTaq+6wnvn
    8Y57Fn2WiXpOTE/0ip6GJbvB75qJpCu/Yb2+Z3gdqHLrT5wlQqTjYKWRTCaQ
X-ME-Proxy: <xmx:uz2CaipoJXTFDXkuwZj1uFSh_9I8eKDcSGKqWeJVNjG4Zp5KvZcvjA>
    <xmx:uz2CaglXnIGPtxRjsFxz_y64AByVYWGM-8laWgS0qj7avM6dVLVhLQ>
    <xmx:uz2CaixDEMCJHpVoUJYDlSK9ZevANwVMf4Jp2VlOgzMQR1C00x_bsQ>
    <xmx:uz2Cam12ntRCaV_TLfAUU_2XLugHy7igBSV4aGax3mpurH9pfZyxLA>
    <xmx:vD2CaqFjDp0eRK0GWALfB12xcqHeQP7NPeZjtgLVwFOlVzq_CJ3sL7pj>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:18 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 01/57] mm: add pte_folio()
Date: Sun, 16 Aug 2026 23:45:13 +0100
Message-ID: <20260816224609.308019-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D1D2160008
X-Rspamd-Server: rspam07
X-Stat-Signature: jjgbayiwr74cws4pyzpyzytfm1ewd4ey
X-HE-Tag: 1786920380-135694
X-HE-Meta: U2FsdGVkX19cS3E8RBHOMTMnTH4P0TmnUsF0SV7R48wGhee0qczC+E2R0cjmvA4fq2VmRWwrBEQK35p+ZVIOZdelPeaj69TukqtFDVaBoS+oBkQeV5bDhskipm790XfG3yzM3Ndsb5UPnnLTPbZ7gjHausF5Cl2ave6D52aW7LnwcGU+FRCXiJ64FgVudFFNhAdr+WrHQ2xdIJ2tGCffy1C7R1kecY+njYaJtb+vMrxRew5V//rfTmm6jPADtN3gm+R9S9vhT4mFGJ9ZmqGaodOUYScDFuD3UruzbJ8za3a1g+70BWktiWMeDr3UecKA0RltkFgpmfVi0OkEx+XCSLt/Hf63fK+76+U6AnclLbAQbx6d7hAXqiXr7WgDllcjAu8EstWykus0FumBYK89nqhr01+OTDmrYa22m+IZQhYjS2SJHi47V8R+1hLRHJ+WvjifNeTZMj728rWTcqRpKLtGSaeCKyE33VEYAbCAxNfjsgM9owB32Pbs6GGlEuf148EoglJdQzaQYL2qjqLugYr/2lUzpxw3QJV/0y2WSWkzrtIn+xfqLXp2yxnWs8WBXURzYqxD+MyNRL1b7S5+Z1waX8/4rA6NDPJ1Lx/OAqCYEzlVdpUb5c4K1iAWRlRecgp96Fh6SlCbPYw9+iHKgb6CTGyiuyh0TOWMjev7DddE4dHhV8Ufc1grtXrIee8av79FI5VgwVxOES416UL8BH+N5H3OngFZ/WVZJJYf4vAUA6MQnQZ23mVe2+rIMIKS87yRRVnOUZ87ggsvgafuolIAAh8TQHX8/1SecVIP8FAo9UE5MFSE79NpaAPp/CkRNS2lezu3oIeYjQpYNxCMdVoNVugb1HutsGCdACUqSrEJe88bpiJQPVgtEULdLG6HBxE0HEYg7h4ps5F8nQUznJ5XGb0eGaOZD+wAkz0utiBS84jRiFdJccJrJCalDoV655Y4ub3mngKwS/MvQfC
 KBnjTEer
 RD6/c3/NvtrdOmmS6lZhR3jCu2m6aeirhMmOTl5H4x1i+QaWXO2gkQaDbS3TewwPVUIXsVIyVnjklNBPb//ee7WN6tJfbnD+lgRyUjOkkHN2ih5PVdgFxbZGiNM3902vGBwTfG7hacBQevuJSqK38sxKZEAoLHiakwTsb8dDiQu1Hq8qGh+hbGV1lFOWFXYZGX/qdITTIpiqJb5UhIIpr8l/GOHhJbfRkye1WS4V5nQooO5kOyLHqRcwsGu4QEr6Mq0w85bWchMUZxNebJqxHr6ZH/zBo4GsmMiSqMUY16khjDKqzSnyrINz+Iy9pc/D4dqX6dObz7Ysugn2pR4pPlLWCtFIyRLkrsF4Co6thmX+SraQx5v07Gjd2A/7jLp1+a2H6V2TAlmYVYj+ufQoEgbELiUW7686C/QXPkmyTESp5hojNACm6QosLSxUyrtdIXdJkAg7+QPzkdePWYtSvTd/Nst+z0xVeER5WnDg/daoNJpejYw9XbOKC1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Callers that want the folio behind a present PTE spell it out as
page_folio(pte_page(pte)).

Add pte_folio() as the folio companion to pte_page(), and convert the
callers in fs/proc/task_mmu.c and mm/hugetlb.c.

Preparation for the anonymous collapse engine, which reads the folio
behind a PTE in several places.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/proc/task_mmu.c |  4 ++--
 include/linux/mm.h | 14 ++++++++++++++
 mm/hugetlb.c       |  8 ++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5c54aebe2118..459c779b8141 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1277,7 +1277,7 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, pte);
 	ptent = huge_ptep_get(walk->mm, addr, pte);
 	if (pte_present(ptent)) {
-		folio = page_folio(pte_page(ptent));
+		folio = pte_folio(ptent);
 		present = true;
 	} else {
 		const softleaf_t entry = softleaf_from_pte(ptent);
@@ -2227,7 +2227,7 @@ static int pagemap_hugetlb_range(pte_t *ptep, unsigned long hmask,
 	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, ptep);
 	pte = huge_ptep_get(walk->mm, addr, ptep);
 	if (pte_present(pte)) {
-		struct folio *folio = page_folio(pte_page(pte));
+		struct folio *folio = pte_folio(pte);
 
 		if (!folio_test_anon(folio))
 			flags |= PM_FILE;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0829e0d3b2d1..eb44e3dfee09 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2681,6 +2681,20 @@ static inline pte_t mk_pte(const struct page *page, pgprot_t pgprot)
 	return pfn_pte(page_to_pfn(page), pgprot);
 }
 
+/**
+ * pte_folio - Return the folio mapped by a present PTE.
+ * @pte: A present page table entry.
+ *
+ * The folio companion to pte_page(); only meaningful for a present PTE
+ * that maps a struct-page-backed folio.
+ *
+ * Return: The folio containing the page @pte maps.
+ */
+static inline struct folio *pte_folio(pte_t pte)
+{
+	return page_folio(pte_page(pte));
+}
+
 /**
  * folio_mk_pte - Create a PTE for this folio
  * @folio: The folio to create a PTE for
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dded1768193a..bceab8e14118 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5280,7 +5280,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 * are about to unmap is the actual folio of interest.
 		 */
 		if (folio_provided) {
-			if (folio != page_folio(pte_page(pte))) {
+			if (folio != pte_folio(pte)) {
 				spin_unlock(ptl);
 				continue;
 			}
@@ -5291,7 +5291,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			 */
 			set_vma_resv_flags(vma, HPAGE_RESV_UNMAPPED);
 		} else {
-			folio = page_folio(pte_page(pte));
+			folio = pte_folio(pte);
 		}
 
 		pte = huge_ptep_get_and_clear(mm, address, ptep, sz);
@@ -5514,7 +5514,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 		return 0;
 	}
 
-	old_folio = page_folio(pte_page(pte));
+	old_folio = pte_folio(pte);
 
 	delayacct_wpcopy_start();
 
@@ -6189,7 +6189,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			 * checks whether we can re-use the folio exclusively
 			 * for us in case we are the only user of it.
 			 */
-			folio = page_folio(pte_page(vmf.orig_pte));
+			folio = pte_folio(vmf.orig_pte);
 			if (folio_test_anon(folio) && !folio_trylock(folio)) {
 				need_wait_lock = true;
 				goto out_ptl;
-- 
2.54.0


