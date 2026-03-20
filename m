Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70AF01099B2D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A72D76B00C5; Fri, 20 Mar 2026 14:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B046B00C7; Fri, 20 Mar 2026 14:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D2E6B00C9; Fri, 20 Mar 2026 14:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA106B00C5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:08:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B8171DB42
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:08:11 +0000 (UTC)
X-FDA: 84567225582.20.F6A4E2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A4D52100003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:08:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BSV5/vCW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsZoRQP9nM4DOZvvG9cMW986F8E7Fitl7fra3vMz+GA=;
	b=hWVsRitHEnmA0hUgNtBIkjzd2suQxA2HVaicDaLQrCIdTNgb30ykmEGiRk0xTbpdj4NOt/
	Jq1ddsQCfKVCTSsrBm7IGRwyoznAwaVhyD9PbpzQSfcWuGSArLSuhMLXy+Fwp7+9vzYI9t
	7XHgleSwjfWRqKxeDQrPgEVO2TeAH0I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030089; a=rsa-sha256;
	cv=none;
	b=V1dVcWVnjoYaq5xn3MYTyZmkfmvvFDTGUlWYfXSPF9XmffMZGAJi09MUMyl34GfifKLQCS
	atQYL44ukra0rJeomlOnwM/q5BoSj7tcw9QR7ota3T6178lA2OQDmthRIcmaiIEIHluqUM
	vKU0/sezgwTn+R3dug5XdQ1SvSnIxww=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BSV5/vCW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E99D6013A;
	Fri, 20 Mar 2026 18:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77550C4CEF7;
	Fri, 20 Mar 2026 18:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030088;
	bh=ZH1v5KSbOjRMJis+xJElreGFGOfOHidqWPb9vPCbzbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSV5/vCWpCXSfa/ioXFIBAG+8nmeyr8ybamFgx0mpr5ZmqwisIsdb3aEZBNi0F0o+
	 sGA10+dmUWnY5UX/tWHlm72wgpiy2Td/BOcN5XBp7aY9m00c5lkmOQxQUN3TW6gYb5
	 YQVe3AGplKLmnPblpxiJosa6yq5UrC3AipQAYJVGNNh9VxQFHU89SkFP7ffARlhKs3
	 ORqPY9j+ElmMXhFwC+deQ7fmB7bUWwHXT7AINRSTRYakxvpSAcaswPVTYCNhGbpj9i
	 QAmYjJQTVok8cYh+lXAnA4qW1VjNa42VKuSwx953WFANuANj1iP7K5YhTxIoBa4gMz
	 eyBy2+z8eVA3A==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 13/13] mm/huge_memory: add and use has_deposited_pgtable()
Date: Fri, 20 Mar 2026 18:07:30 +0000
Message-ID: <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A4D52100003
X-Stat-Signature: wqt3mjpyiz87rkfumrbhuoiwnrtptfqr
X-Rspam-User: 
X-HE-Tag: 1774030089-603892
X-HE-Meta: U2FsdGVkX1/969yihd/da+IntgyOSkw3Ex6DjZO8JE9uBvTVGNVsTAtym0HJ2+v0R0nTW7Y6rZYYracdxk2X9/1Ckg2lwvVmTQJjnlMwJ/gjreDQAg4f7VcROBErAOjxHEFrXt9SHCjKtkJfJLJNG+fURG4+7/p8xhVoaVTubt04g4fMElVoS6lJGtETTGO4/v9bv/eBq+pkq0CKl43x6a9vSNAnvQ9nXjhX7VdBTH6jebp2zpKfCsG9Xw36npH9M6uDXoIAUoo8nrjA+k7UxaPDplClR8e4f/diiuqQVwIly3GcHCo0omUhCKRKpfzvZLpkDplNE1rBxdgpaKZ4PsK9ehVOMyZQWrbrQFgT8U0OlNYgdL7W41ADEwqqNDrgAFG8he9grVouOJ4pniVm0XlRcJdNCKMvg8qCbVR6mBIVGPDBihfvG4tUfSx8u90oWBKQwhs/knzr3ff3/amZZkO688IQ5jV5YJQO34mE2WPfxBn4v3G6GpDnTFDLnjgOsf4c1+Oje/wjib9jrYdSmtEJ48GXQ5EboS8K+zOU6l037sdDA3moce4fkJQ4fbPSloA7tNZ71cFw7Q8jQtdgJ7M6IuNH9vosMuNYW3+ZXDp9nZrHVfi3Yax+LgulEHW2A2oB1K14YyoCnk13Obr8xfKIrFHpwqAis4OZdGkXu70vJED4JHN7h/NHzJL6PQnRAepg0P7Q7maIRpelVfyKCRiTObIRQLaZ79BWRvyVozJFFMR8ei13vxm6uVg2PKtnp++b/v6ndH/+3+MkjTuc0x/iuUdSpSXhHx/uj8XEvzY7pHJ03ZNgngaQSfARQht38Bi6Y7QOnwugnzzhjqhNHA8m6/NyGSXIfPVMAgM2uTQyalD/D9+7rC19VVg8HfZ/9+seMFMOKZBZr/ACksJKPhZEWbpHJY60c6QGcYHatAaZy/oquUPB6ciLEELHPyLTXnZuwDmiVk3hIsq9THi
 gEFsQzRY
 SYO+CkRJtBhSfCg2UkrxH8N44gioi1+CJJFv1fzurKr7yG0xx3SbCG6OQO+XtoRH+D5nFHthZPpdZSW4TqWlGawW81mUsO5jorn8dksB9JYwDNKLdjkEIvTHYfkyGP07a96Sew2R2CE8TdrHd62Qs9QW9Dyz9iisMC2MNlhEJNn7DwY6OYOFvaOJ/S+bsc+ZzU+DBtVPeYFSW58cG0OOLT8U1mdyt1AgCaJazE42ArtQ4gIVIL9aeBAO/iyscFMQpIA5uWoLnZ6dL/H+xnzZS9hkXKWG4Wi67MFltU5xtfmuPk3e9IlQdCdqGYeYVDL4BbMsf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than thread has_deposited through zap_huge_pmd(), make things
clearer by adding has_deposited_pgtable() with comments describing why in
each case.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5831966391bd..610a6184e92c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2326,8 +2326,7 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 }
 
 static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
-		pmd_t pmdval, struct folio *folio, bool is_present,
-		bool *has_deposit)
+		pmd_t pmdval, struct folio *folio, bool is_present)
 {
 	const bool is_device_private = folio_is_device_private(folio);
 
@@ -2336,7 +2335,6 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		folio_remove_rmap_pmd(folio, &folio->page, vma);
 
 	if (folio_test_anon(folio)) {
-		*has_deposit = true;
 		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	} else {
 		add_mm_counter(mm, mm_counter_file(folio),
@@ -2363,6 +2361,27 @@ static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
 	return pmd_to_softleaf_folio(pmdval);
 }
 
+static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
+		struct folio *folio)
+{
+	/* Some architectures require unconditional depositing. */
+	if (arch_needs_pgtable_deposit())
+		return true;
+
+	/*
+	 * Huge zero always deposited except for DAX which handles itself, see
+	 * set_huge_zero_folio().
+	 */
+	if (is_huge_zero_pmd(pmdval))
+		return !vma_is_dax(vma);
+
+	/*
+	 * Otherwise, only anonymous folios are deposited, see
+	 * __do_huge_pmd_anonymous_page().
+	 */
+	return folio && folio_test_anon(folio);
+}
+
 /**
  * zap_huge_pmd - Zap a huge THP which is of PMD size.
  * @tlb: The MMU gather TLB state associated with the operation.
@@ -2375,7 +2394,6 @@ static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
 bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
-	bool has_deposit = arch_needs_pgtable_deposit();
 	struct mm_struct *mm = tlb->mm;
 	struct folio *folio = NULL;
 	bool is_present = false;
@@ -2401,12 +2419,9 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	is_present = pmd_present(orig_pmd);
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
 	if (folio)
-		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present,
-				   &has_deposit);
-	else if (is_huge_zero_pmd(orig_pmd))
-		has_deposit = !vma_is_dax(vma);
+		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
 
-	if (has_deposit)
+	if (has_deposited_pgtable(vma, orig_pmd, folio))
 		zap_deposited_table(mm, pmd);
 
 	spin_unlock(ptl);
-- 
2.53.0


