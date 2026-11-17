Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A295606A88C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 18:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XTEwdev8
Received: by kanga.kvack.org (Postfix)
	id 7807B6B05B8; Tue, 17 Nov 2026 13:32:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730CB6B05B9; Tue, 17 Nov 2026 13:32:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6460C6B05BA; Tue, 17 Nov 2026 13:32:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F70C6B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:32:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F702C054B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:32:08 +0000 (UTC)
X-FDA: 85445455536.27.52016D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4806980006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:32:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XTEwdev8;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794940326;
	b=4JwIGb6zOYYpjCzi7RIL5FSUxevyrdZZ1tGBZvM/VUVPodDS+6oUwq6GW7eY7rX902EavZ
	qBQhNJpLW2ShotoljSffuf5vyPv+RnKHD1jWDY2xazuFlf5eOotNwjhnye7Ziw34iYTFno
	gc9ijSOhywaX6ua9/uvVxRJ+JD6pu9A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XTEwdev8;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794940326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmYgXS2j+OqkL61e2BRHprYvo+imW1RdtkRAOJY6dIQ=;
	b=m6eBKSOgxGasGWAZigyGfJvhXPc2tDzPgIW7Op0XbUpGweea/S16rJG5rF41xMtxuDBOML
	0q+YczATTVG955OLkl5zy0EozHSwMz605AYJfS1grk59yME8AgrMdmPvkHKL+kfE6a7YhV
	gZiB0yIhOfWTla3rQnPi18RKtCFeA+o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 814F543ADA;
	Tue, 17 Nov 2026 18:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF171F000CA;
	Tue, 17 Nov 2026 18:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794940325;
	bh=LmYgXS2j+OqkL61e2BRHprYvo+imW1RdtkRAOJY6dIQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XTEwdev8zMecd1RUlqSDNXj6cLrBVe7Q8pv7AG5q6/uv2UObUSAcjfVAYFJu6sHX6
	 xZSmgL+rE4hTBnAakpe4EQPiXvZjzYREZwIko2MYEPFRkTHU8FfOnpe1Eha++Yi3Xs
	 Pp5V9+jiQzXlX/nStK+N3ciDtH6uUY2G4mz6hqXmwmINJeY83Q00Lm7l3Irlmg/glQ
	 Epoen3m3u6GpT5NuK4iQGy32Bis/Vn94E+2qFVJVHmeRwbRCpc/WeLxS7+Xc7z5iZC
	 PAjafjplhsp5njWM1Act4+W3cKZ8nPm72rAhhN4wUxBph7Ox90JbA3QHxSxEzDYvM+
	 WURzJPwPRS/5g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 17 Nov 2026 18:31:34 +0000
Subject: [PATCH v2 3/4] mm/memory: do not report OOM if insert_pfn() races
 a huge fault
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-huge-pfnmap-fault-races-v2-3-276007e73bcb@kernel.org>
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
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
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4406; i=ljs@kernel.org;
 h=from:subject:message-id; bh=gqH7juwzoon3ftwWqkG3rZSx+Xcu56JBKdW0c7DDkP8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLL+zO3esO2KcZdcQo/q8aRf385++su83HzxLd0v0+8uM
 928PyqhpKOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATWZ7E8E9Z5gHT6yNNRRLp
 H/6wrVc78+1eidutteHbVGLfXzdK+v2a4Z+RdDXHcuZI96odK69OK+qTYXs65aFqdupGl5YXjn9
 S7zACAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4806980006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kmx59mo4ukts5xqdipe8njanet816mir
X-Rspam-User: 
X-HE-Tag: 1794940326-976912
X-HE-Meta: U2FsdGVkX1/VcQsGfJ4RTldU1YKmntqyFEC8V4qNjamCVQoHooBV5xG6+eeNa+iQhZJth2HEwjzY5sTGDNodtFf7fot5XRx1bOyZgda30wPYo9dBCLegMy+b/lgTkoKtr34lVf5+Ni3z2LK2riDgFO2dJ2M4uW0C9QBjYAm+JTm1bSVikTfJtqQCeFFZH3vaGLqHZBVY8Wz6rJ6yjy0hnlFGxZfbe14x61lFzgAKrM0IJjX1A0GnTj5cyvSBHve3sSdoiOvY/STEZBNjSIrqo4xiJXfrOBcOOPDAd/zTQ8H2FMQOz9FB311bpFSTHkJdGpzkr1U3xfqzI9LM9z6SxnJp/bKBkBzCotc2VZ9t0KaP3L4IccGKpAxlLnOZ7QjAh3azH9aV+1rGSGPmw44bXc3PVNkhoNwod18kOW6NPw/tAWOZ7D+JRHC6Sb2nFr8VO3okK5Jce7deHYjXSpturBVbhlP1fXEOhgUWUSoEJzkU5ug31zXVTp7O8go9yG/ll6E2MNCbkvahM+zP7AUhKEmmpC4BFWXqKX7rBP9IHWWFz8+aCq7UcUQT+LqS7MwBsqOFoO5RDWOpxOnn6GlfTWgQxatgeyymNDjr9/QPd7oLT9vlbGCkhP/B19JBMIfgL8YSk7wy4R85gffC/xaRTkuyk4rwN1ZNKAMlQvJK41Z5gflLX3nCAQeMmqI+NmRwH8Azw0lpeFW9blA/jFUWjJlFsdatokQHe3UkaH45bl15duov2k5IW3b/lvc96tJkhKLM/+c6MaoOmzOBHbinBTDLTy0EwBN0ZvzKsW2pAm9RriKeoFQEAoKIRszQ5t8nZnN9RG3zlwBIucd6tm+7z2sOi6ghEsto4cpuNxag7jTjEUCPeEppJWLu2eWGiUV9GAYldjzFxLb3uTZ6entFdAGvftw+ujO6sUp7Cm7v0+HRBWkpl9rWIiLla3yok3/WdwQzuyXkp0HU5spNcDx
 YWmIM6Or
 EzM6JlBwEbA6I4a3gJe9+T1YGiSLKHAPp9kqzvzxTupN60QBvzF7c0SFco/oo09Qv5REkW927UKCxRvB/GKNFxj/mSJ2LMk3EJ4+MKm66vspnwNYYgGiKi1VvROL+0q9j4PYNz7CCHfZRSmB+mbOxHhnw7GE10NW8XQgdhwEHrCMB/NyC4hUHSxxvg1U44lGRLtXEBYyRoQjpXWylcGjMEgkayXwl+9EzvZ0Yl/5ff+3eETPhMsQKJSq4AVHyhTOFirAKy6/UzaN7+9a+0Lf7CQ4j304syaVqUfFPMLuztUBu49jijTQ5G+fudqE3cCAcQ8eXA1B8XTtQEOCc6T1Cz93wzQ==
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
if a page table allocation fails or -EFAULT if raced.

This allows insert_pfn() to return VM_FAULT_OOM only when an allocation
fails and VM_FAULT_NOPAGE otherwise so the fault is retried.

The same change is applied to insert_page(), which only impacts DAX (which
has its own locking).

This means that insert_page() now propagates the returned error, so -EFAULT
in the case of a race. It's not possible currently, but guards against that
changing in future.

Similarly, update walk_to_pmd() to return -EFAULT if it encounters a huge
PUD leaf.

Target the commit introducing the first driver able to do this.

Reported-by: Eliav Farber <farbere@amazon.com>
Closes: https://lore.kernel.org/all/20261112051440.16140-3-farbere@amazon.com/
Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 20b818bcdfbc..04a518d6059f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2383,19 +2383,48 @@ static int walk_to_pmd(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
 	pmd = pmd_alloc(mm, pud, addr);
 	if (!pmd)
 		return -ENOMEM;
+	/* We may have raced a huge PUD fault. */
+	if (pud_trans_unstable(pud))
+		return -EFAULT;
 
 	*pmdp = pmd;
 	return 0;
 }
 
+/*
+ * Map and lock the PTE entry for addr, allocating page tables as necessary.
+ *
+ * Returns 0 on success, -ENOMEM if a page table could not be allocated, or
+ * -EFAULT if we raced and found something other than a page table.
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
+		return -EFAULT;
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
2.56.0


