Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 870DB606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i5kZ8cZO
Received: by kanga.kvack.org (Postfix)
	id 8D97A6B0A5D; Wed, 25 Nov 2026 10:49:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8897A6B0A5F; Wed, 25 Nov 2026 10:49:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7780B6B0A60; Wed, 25 Nov 2026 10:49:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53AEB6B0A5D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:49:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2C5BC0F8A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:49:30 +0000 (UTC)
X-FDA: 85474076100.19.96FF95D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A7FEE40005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:49:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5kZ8cZO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795621768;
	b=iCCp2M3mFu9bxReEdHJxk/D+WjfR++1E17KUf0kSqr6vg3IhZ4IKtUv8h7zLY51vraAItu
	ixxLqIcwkA6XiFqrb4plH+M9+Zu1DdE8MHlRYITFScC3HBg2L/dNbZ5FohVAhVeqGBbJJr
	jV7oF82xs+hQF9WFAR22mJ2g+ARm46k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795621768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxE1/+fib+yfqKL7hQTdhQN4mMmRO0JPMa9EfCUn0qo=;
	b=1rG2hlsbeN/9SMMhYzAjF9D9fjXyUAWLKulXlLvNfV0SK6xKJLvNvuwgPl3nq9MqIOMIOw
	6yKZAskZ1GQpeB6nOYFd/qOLUmB+t90j4g89OTf8I19MjtChREQsqaFIrVv4A/ot4nS43n
	/s/4niz3UioErEgRZT9pdxgIc3wWiik=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5kZ8cZO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 94C2443619;
	Wed, 25 Nov 2026 15:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE83B1F0089F;
	Wed, 25 Nov 2026 15:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795621767;
	bh=jxE1/+fib+yfqKL7hQTdhQN4mMmRO0JPMa9EfCUn0qo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i5kZ8cZOJdNawYlTRVZPrmVOMxIFTkM0kiZawV34piEHw6o69PTf6ibI0YHGXLjIR
	 P65Ri51slfGoIgKk5Ve9nairo6xIQsrrh01Ptt/hhs5y0g5NtFJbpG3OO2cBS6TBtf
	 aYTAB+MIPqEgvPa+x5VNhZWW2zIJEMvtSJ2lZjgggIRw0hcIYXCFQhxM4+lJcEh77u
	 V+W0ozXT1ZBt6IqK8umIJVhykebDfasoq3/vc7lamO+xxVwrBnAo9j+zXr/jonRJu+
	 baZF0ZA0WFg+IK6tH3wN4BdqYZk3PHdWxmY6cG0eL2nSELpffitOOZNB0yHLB/q5IP
	 Lc5rVueipSK0Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 25 Nov 2026 15:48:51 +0000
Subject: [PATCH v3 3/4] mm/memory: do not report OOM if insert_pfn() races
 a huge fault
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-huge-pfnmap-fault-races-v3-3-bbc44489341b@kernel.org>
References: <20261125-huge-pfnmap-fault-races-v3-0-bbc44489341b@kernel.org>
In-Reply-To: <20261125-huge-pfnmap-fault-races-v3-0-bbc44489341b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, 
 "T.J. Mercier" <tjmercier@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5213; i=ljs@kernel.org;
 h=from:subject:message-id; bh=lulZtlCT/rNCjAjKCr+HKwrQyF0d8uLYpS1OwrjQtF0=;
 b=kA0DAAoWz53NioHifxQByyZiAGsHA2mhDlQLMwrVll+T6x3OJmlGz+sUf7yA+uhcY1XxtA7OJ
 oh1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmsHA2kACgkQz53NioHifxTFnAD/dwjG
 uETKFncRNcYNGPcRyVQtP1yTsTyK13o4QO3NZLAA/1enaaGEuUE5n3YP+4M1KOg2Is7jcC8f3lV
 U5IwR48oF
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: cdsme4n57skaq771cnhzy5kxwwkhiuoo
X-Rspamd-Queue-Id: A7FEE40005
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795621768-928168
X-HE-Meta: U2FsdGVkX1/XdBbbDy15Ere14C4iJ6EHAMu64zSfZIGoTYaoF0TEakYSAD7FkO3cICUJqDAz+Lt9rArqsSdIegQGCOxkMPPNorF2ZJKQa2llvXBHYQ/HmvXydWkooihJwEH+4fzlI826Msl8XukLaCPanOEPAt3EHnPVIebIT7R4uhxJoE1teCFpS/EZdRYU4jHCqwv8ScLOpL2QVDE1KA4TgefQ/HKscT5Dk0ViJklFZQRSauFFxba19Mh7dy65F0qpRRN3fGKbFxx4DlT0FuRDNYjG4+DpgYcFdFv2GdJbdjL+eCADkVBsx7TNJ+sYtNU2oIwyW3yVjUIokAPVPNmWf2k4GS+MKi8gKkABQ9aHsX6BtsPJdyb/ng1kdi5mZNykY1ydALSan658je/mhKfWVeAfi+TTvuvsmdHz+jOj5iXsva1X+r244YnW5V6iGh5JYPsQ+uvor+SUVuoN2UnNOTp8TrI+plqy2l2XIB55JbARvja6QmOsQxHPSiqmYUKy0qfr1/rEjHYX6K8ocDg3iAicmatomQKxNQbxaq7mXLXZ8hr+G4WRSUSI4wWYaKD6VYqAMkzNIxq4heHNHx5Ed/H+laEzm2RB2y9nWLMNU29msh8NAtTMnlXo3V5vhc8zHdAOOk51td77AoDOUANjZUR/pfjkiJ3V9zIIdrenZPKaREwbDaJnfcU0jmF/PYQlKCGiMLlnc0p0nTRpbAcHMzWcPtuWtVdFbfwQJS/yRNYm18QG8UGt+tIwxmvrDGVj2WxjeW/nyycN9wtiTZO/MNI8BF33wDHi5k9mwuvNsg18fq2cr1JBEJR1s4GCQhoDIVpZysoKmdnhMeBoHbd43at4BWXUXlNuBmuJUt9kfWSjPgNbNwXT5ygKlw3HyD/WNxLpRgQU7FSUxu+dQYBBHxcW+rJV/CRGaRy0TjGj5NRlL91JrLGZAunS2Bz3nmu+CFMLrpzZong1v3z
 qUk9Rm+k
 ++EV7jKSUn+9ZJICmakxdBWV4eYI+MzTJvFqZz4nJ+LRf/gyTtpveCkkuRCl50KW1c8rAN4950bGY3X9Al1DZhUX98jVsIaPh1mQQcODcg59tKvB0kbGxSfWhOScgwlJeSnE5zhP3hSiWS8gooz8ZLI+R09a2lQtlJkAHRk1tpt/0PN1kkbt25N5SWpIe+2MzRNC7XEomaxHmGr1JNXwji3nF140fqnq4/CCbDGv0EREzni4wGdzctz6Uvb8ieaqbvk7wvZtpMm2Vj6mBLjUIzy4HywF7l6q1KjwtRiFYxi7yKQ7MTuDqkGctcAjz1XCwobkv0RQapo9GBzHF/oD9bvd5SoHydGoB1LGooNVDUIGLTQO85Gkrsx0/SHODApweeyzxvfgbGBzStwEuSWvnJklBuy/xQUCNBXQCDvCv+tRr2bHCnZjmNyjzVgeGLgq+8f+RHUNau8g6iykd2IgvSAJ0vmq3+az8jFQ75c2B1FiBarIPgGKSzrky+1/C/sC/sNzh+3R3jYatCht6GZnem9uZ/3dzlW1ZKGPF0SDNGojrvGzJLcxOLXYGmPV+qy8UTZcXfZL8YGibjfCAH3TmndmawnknhQSoW7Ons4drHo+yQftlrpHQmZHtVZOgNBfGXtWcRb5wCEmbOvUByCiyMGS+6sUovJtCZZbG4Ty7dBiixIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A driver that implements both ->fault and ->huge_fault must anticipate
concurrent use of both.

This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
concurrent with faulting, as that only holds the mmap write lock and thus
does not exclude faulting threads stabilised by VMA lock.

This is not currently safely handled by insert_pfn(), however, which
obtains its PTE entry via get_locked_pte(), and treats a NULL return value
as an allocation failure, returning VM_FAULT_OOM.

The issue is that get_locked_pte() also returns NULL if the PMD entry is
not a page table which can happen if a concurrent huge fault installs a
huge PMD entry between __handle_mm_fault() observing the PMD entry to be
empty and insert_pfn() being invoked.

This can result in VM_FAULT_OOM being reported incorrectly.

Fix this by introducing and using __get_locked_pte() which returns -ENOMEM
if a page table allocation fails or -EBUSY if raced.

This allows insert_pfn() to return VM_FAULT_OOM only when an allocation
fails and VM_FAULT_NOPAGE otherwise so the fault is retried.

The same change is applied to insert_page(), which only impacts DAX (which
has its own locking), however even in this case DAX can be impacted the
page table can be freed by madvise(..., MADV_DONTNEED) if CONFIG_PT_RECLAIM
is set.

This means that insert_page() now propagates the returned error, so -EBUSY
in the case of a race, resulting in the fault being retried.

Similarly, update walk_to_pmd() to return -EBUSY if it encounters a huge
PUD leaf.

And finally, update insert_pages() to return -EBUSY under the same
circumstances for consistency.

Target the commit introducing the first driver able to do this.

Reported-by: Eliav Farber <farbere@amazon.com>
Closes: https://lore.kernel.org/all/20261112051440.16140-3-farbere@amazon.com/
Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 50 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 20b818bcdfbc..2230c2079c9a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2383,19 +2383,48 @@ static int walk_to_pmd(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
 	pmd = pmd_alloc(mm, pud, addr);
 	if (!pmd)
 		return -ENOMEM;
+	/* We may have raced a huge PUD fault. */
+	if (pud_trans_unstable(pud))
+		return -EBUSY;
 
 	*pmdp = pmd;
 	return 0;
 }
 
+/*
+ * Map and lock the PTE entry for addr, allocating page tables as necessary.
+ *
+ * Returns 0 on success, -ENOMEM if a page table could not be allocated, or
+ * -EBUSY if we raced and didn't find a page table.
+ */
+static int __get_locked_pte(struct mm_struct *mm, unsigned long addr,
+			    pte_t **ptep, spinlock_t **ptl)
+{
+	pmd_t *pmd;
+	pte_t *pte;
+	int err;
+
+	err = walk_to_pmd(mm, addr, &pmd);
+	if (err)
+		return err;
+	if (pte_alloc(mm, pmd))
+		return -ENOMEM;
+	pte = pte_offset_map_lock(mm, pmd, addr, ptl);
+	if (!pte)
+		return -EBUSY;
+
+	*ptep = pte;
+	return 0;
+}
+
 pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
 		      spinlock_t **ptl)
 {
-	pmd_t *pmd;
+	pte_t *pte;
 
-	if (walk_to_pmd(mm, addr, &pmd))
+	if (__get_locked_pte(mm, addr, &pte, ptl))
 		return NULL;
-	return pte_alloc_map_lock(mm, pmd, addr, ptl);
+	return pte;
 }
 
 static bool vm_mixed_zeropage_allowed(struct vm_area_struct *vma)
@@ -2497,9 +2526,8 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 	retval = validate_page_before_insert(vma, page);
 	if (retval)
 		goto out;
-	retval = -ENOMEM;
-	pte = get_locked_pte(vma->vm_mm, addr, &ptl);
-	if (!pte)
+	retval = __get_locked_pte(vma->vm_mm, addr, &pte, &ptl);
+	if (retval)
 		goto out;
 	retval = insert_page_into_pte_locked(vma, pte, addr, page, prot,
 					mkwrite);
@@ -2553,7 +2581,7 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 
 		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
 		if (!start_pte) {
-			err = -EFAULT;
+			err = -EBUSY;
 			goto out;
 		}
 		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
@@ -2865,10 +2893,14 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte, entry;
 	spinlock_t *ptl;
+	int err;
 
-	pte = get_locked_pte(mm, addr, &ptl);
-	if (!pte)
+	err = __get_locked_pte(mm, addr, &pte, &ptl);
+	if (err == -ENOMEM)
 		return VM_FAULT_OOM;
+	/* We may have raced a huge fault, if so, retry the fault. */
+	if (err)
+		return VM_FAULT_NOPAGE;
 	entry = ptep_get(pte);
 	if (!pte_none(entry)) {
 		if (mkwrite) {

-- 
2.56.1


