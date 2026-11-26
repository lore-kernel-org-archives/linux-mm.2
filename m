Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28281606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZ+QMJSl
Received: by kanga.kvack.org (Postfix)
	id F41FA6B05B6; Thu, 26 Nov 2026 09:36:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18CF6B05B7; Thu, 26 Nov 2026 09:36:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E776B05B8; Thu, 26 Nov 2026 09:36:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C52796B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:36:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4448B120486
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:36:56 +0000 (UTC)
X-FDA: 85477522032.09.A72BFF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C51A180006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:36:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IZ+QMJSl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795703814;
	b=6mugaQC2bLVFpUFR1mnOMFrxeJHBCrqABYtfQTKjLaK0194UwgWvfSgADcq+SGWioT6QdJ
	7jVhZKLkw8HgbF6jZHD3sgAyfzHTJb/0yWbUoXXAM39ytd0Mze7DwSVZZ33mzU5yLEGfGP
	Y9UbN7WCFZ0u0NFHIqFaJ4gHdvX91Ps=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795703814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plPWFpfqGx7yQM3ExTUPYJV4MkE+gTXad3DC+CagbLs=;
	b=tczJwzZGHr+Oy+HlgaqscYctfiwJzg4X++p2q31BmyQ4Yt0x6/RL3D695aMM7dTHt9Ustl
	IzILsO/zc2qS34O1nM2KsDNQVXDo1Xpd1SZ6ySw12ATsgSjNX2at53F5z11P6LHY0Qa9Wp
	w17C86MDqXNhwNCc72m5fdtb8yqPRIY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IZ+QMJSl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24153635AC;
	Thu, 26 Nov 2026 14:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4741F01566;
	Thu, 26 Nov 2026 14:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795703813;
	bh=plPWFpfqGx7yQM3ExTUPYJV4MkE+gTXad3DC+CagbLs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IZ+QMJSlW/ChnEEa61TEH6TVlSIkBjGzbdE+VlPU3v8gFeHBEpzdU7Bt4MAyerw1A
	 ymumvfoDm+7czXZvuvK+WxFgNwl3CAAitX/7c8AS/qm+roU7adVG8XzObX62erXYt5
	 E76K+O7EjvixvncnCfdQY2EdN68j7yMeXraGrXU3HnVBIQZZEE5s676OXkl6pyMjNS
	 /zLf4Dop0dnDOYZt937sxoIE6Va+/fIVmOKbUmn3W+4Jx9sLt6TrRgLesKf4+kyXGd
	 5tmxnDo4sIILGM8/yorTS600cD0VsbG1td2gzPfQPS/lDo/n1kIN1Qgp/IlgTjeu4I
	 GQPqNAJtNs79A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 26 Nov 2026 14:36:21 +0000
Subject: [PATCH v4 3/4] mm/memory: do not report OOM if insert_pfn() races
 a huge fault
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-huge-pfnmap-fault-races-v4-3-feecd58bb14f@kernel.org>
References: <20261126-huge-pfnmap-fault-races-v4-0-feecd58bb14f@kernel.org>
In-Reply-To: <20261126-huge-pfnmap-fault-races-v4-0-feecd58bb14f@kernel.org>
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
 h=from:subject:message-id; bh=9n3K4eqh9JyPtTUrjpIO8YkXNto62bbbJ++HU6wLJK8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI5nF9MfniZ/9Au5rRfig96BI/XZBy3zQ7sPjDriMmC+
 bPmXuY43VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJbJ7C8L/UrGGfR9/+5dM2
 2SfmT+ssVLW75rCMwUf01efVJzZmxV1gZDiYc/GrxbHNC7cV7b9TUNjz8e9HxgjFY6sZH8u+EG+
 4I8AIAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C51A180006
X-Stat-Signature: 8eqtyup6x1uhwifj6dowj6obu7w6jxdx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795703814-493458
X-HE-Meta: U2FsdGVkX19eF2KNBbJwUtDnjttn3ImufJlKaiUY1+mPZxIN5xewAuOX78KDmFNbwrtVesORq+hCVAcwIDp6ZxrYSueFETBBGWaSMhlHaPo/b3xwiUm1kTa4xzZiXJX2uTpXQ8n+656LCPwqdfVe6BgYz0u+92kpGCRW1zDqucBsN8zh0iziCoKuXWziCI7IZs6MdWx08KbxznP6tk/Kl0etftAWjb0cGxYzt0CYFD3Mnz20WNQvBS6QqSZAIKi3dLKas5KlPw5mQGTThpneozD5gyi+qXmK3oCzwLyhYHm0g9wpqJvLknMpDIKyW8v+UkTcm7wMDHzkiM8rFic/4DvhDcaZWLucdez84pBfY2Idk/cW1zn337oNrXlNx4Omcgw/GstAhCbOGj9kOOVwsmJeFfr/mzjiGOt9X0hbaMGXbtiaFPjsTp77GIMJOKXU6PlCJ4QzYDUbULUF4GFIRlSizD4k4Fgyexd49MnVd/SrF4XxeSki0KZyGwLV/nGK+Mht/K6y4R8D0YRfw6/0hIsp6tapLPxwLdqX/eqvO/KNxRiyMPF2ayRDLC40zy+d2KH4jGEzmxkyI0L5/v4NoXhTExC5elb10QgXapOd3B6jqy7NvVG8CeeeYy27IoeHeRuu8kPSQkfF8T05wa4ZzeCkBLusIWvdTN2rTsvMn3k66spq5mJbXn2pyNoApb3O4CswLYb2hDwJh5xszyaWlvbUJ531P/wbcqfwNGLvNtTexSV9w1KWcYAzUU4Q+A8elSogTN5IwfJ5guFEQgdb0pzHim9PogdsbsCfaBGyLxo7E8gX9eHigu4Qnw6f5bQB2Irp1VLqdjjihq4fBr/mq+rgQc1AZkBZTlJOlVdb42JybIWaqR61lZII1cD7uoFmzbJnWh2DeRgHVMPyyFkqo65mOcvW7F10DqeD5KXQ7Nb0m/HrRSYtUGxI73JVu2w+1kz1fOP0wxziT6tRfTn
 AnO1YWMp
 2nl/SBW6oxGuqucSvun02FNwMxBt4zmpFjywc7cidac7xzahiOW7N9rD7+KKpKnn9TbFF9T9s39r39go1LuA8JPnL+K7Yfm4Q4SVRcw+56V9w2nV8XqSG/JCRc1vPrZWNi9TRdCQfIy1Y2KYnvJ7/I+ipfpEst86G6Eip+khoW6uYSo9V/cPzz/l/QaZbvZwuNIMX1DqR5lzQVfxzYVCYgbrv1N98CtS9imyaR59OVOA4wCDOLCkt0VU6NdEo6KqUEvt/HmTsiGIUfynMmS02jjKJfdpMoqdMM1ceRqOmQm9tuVhCdk1HcZ7n0iS+KW2kvXU4XenFB5jmuoDQAy8eX6eWWzkI+hqDPwnvswJScgOmSiRrVXvTIQgMDOYp6Pk7MBukQnB66YJHhd2povriLLgnMWqyDw/KyFC6IlXQr6tHWjEUYY8eg9oH4f7t2a0bNtqiuoQ1L4VrBZWqDZSZcsAwc0JEEh6vQo3o8ojUOEQQTHpbY0hQ6HyY2FV4Dm4qVkde2cBjgqAerOBclPX2CHi2Q7p8QMQLlEkx8c80+TAtOsUcZCEBcaIT/+97hl8RZ/A6UvwzrDALIOOSeHShE7WBSJxpOgD7slyhkDhYD8VbX3bGAMMF8Eo0q7G0q+KoLWhQS+DGdlG2iTIaYgHJoAqMz0gjzbMOa2T6
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
index c07e1de63043..dfa307a9228c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2400,19 +2400,48 @@ static int walk_to_pmd(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
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
@@ -2523,9 +2552,8 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
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
@@ -2579,7 +2607,7 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 
 		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
 		if (!start_pte) {
-			err = -EFAULT;
+			err = -EBUSY;
 			goto out;
 		}
 		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
@@ -2891,10 +2919,14 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
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
 	if (!pte_none(entry))
 		goto out_unlock;

-- 
2.56.1


