Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DECDDC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB2F6B00CB; Mon, 20 Jul 2026 10:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2ED6B00CD; Mon, 20 Jul 2026 10:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2AF6B00CE; Mon, 20 Jul 2026 10:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC5C46B00CB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:40:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D7061401CB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:05 +0000 (UTC)
X-FDA: 85009414770.25.A745BCF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6DC0C80004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihkKAuBs;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558403;
	b=SOg5VVlYCk+d3CxfOuf+X7sfYH4TGgXrAN6bItRDyTtAZ9qNgysMYlemMewjkijxsomh74
	fgV/KkWRKup09JPhLvd0GnpDLtbsyC2hdw+OZ/0cGkt7l8MpXDir3XUmFxAbjcOxJWW8x5
	q1RQxNQqh2yOU71FWyrH0oZ01Fjnld4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihkKAuBs;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPRgGgD5Et0gA2LrEPYq7BEyOk+lst4YqtYhmYPtoNM=;
	b=jdyvtHR1kshzzX8E7EgMjIRbXNPIHrRZmlRaiISTqII4Y799cfdc1rJ07tveuSI69R5H9P
	PIw5YomJFy7ZTaVFAer7r5bb5UIBvIVSL7h26CVxi3sSWu68BfWBwpIBBiNFfCPg2rZRic
	32JaXuit292l8cmsCgB5KIEq7xZGH/o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01D2160A60;
	Mon, 20 Jul 2026 14:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D781F000E9;
	Mon, 20 Jul 2026 14:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558402;
	bh=vPRgGgD5Et0gA2LrEPYq7BEyOk+lst4YqtYhmYPtoNM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ihkKAuBsHS90mOQuGgSPwHFNdRwKJ74q8U3c/CMWBE2s7tVdfeNThLJI3CIWj9xG8
	 MuecEx7awVv57WZ0cr0OJC7lBeS3VhQnhbZP3bnQeB53Z0N58cAQGQL1DDynQaeDRt
	 zm2yIiuFyZHtYcPVhR84l6Gmi1/ve5WrxvU8pF90NFnC3By3dMRIYKsJwM4k5zS9X+
	 lDmNmaA+fejnRImm1m7lte/QNcQMcRXhElPF8/PUVrZ5N84weywzuIki9kqlUznLQo
	 vlXaEGgCVlTmTioqZ/22/Eev5tF+sMzA0WMwFaH4G33LmnIhEnQWSR6HxsBjMVv9kj
	 dUUQe+q23Rq9g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:33 +0100
Subject: [PATCH v2 07/15] mm/rmap: track whether the page VMA mapped walk
 is anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-7-2d549757a76f@kernel.org>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3158; i=ljs@kernel.org;
 h=from:subject:message-id; bh=6oAdoFocXqlHeZgV/qOxR/hLOIfpXC9mc/vlgufhmIg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijN7MlVZTvFEV9FD4T7j9bE93wWt67FlMDXFW6zebc
 f6P+JjbUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgInETGH4K/HdNCly34tnPbvu
 F7wNkver8spem5J6dMn1qTr3lpWL2TIyXPDf6vJ3WsUZ5Q2JZ6XCl24PS9DrPaHYwtE0K3Zr8+N
 1HAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6DC0C80004
X-Stat-Signature: nd6aq1ea8x6p9st5wqdthi5x4kj44etq
X-Rspam-User: 
X-HE-Tag: 1784558403-31670
X-HE-Meta: U2FsdGVkX1++dk5iZpKL3/GiBapncNzqtB99Ss4DmFSz9sttnLPG1qxunTX3k0U83DMXnNdBKBjwtCV9uLQ7C+JoQZaaG6A+WT7AmjjgBotHikThc4MYj4H5iDvmkibdUoYNOKgXqKG2gTL+UMj0ZRjIJfVbyU21//WNpkG3owUC8RhT3/hTTy4hVjFaIzx7mnXezZYNcrGVDZ2X4/nX+72J+fanFffHXVwiVJZjRyVnnV7ptxIQS7SWic0pBG9xT4jp1F3wm8D8StdqFGJI/18/l85RgpKqrG/4ukdVPaLhiVmAZIxc8y92+FgRrBzIUsBiqDg0Lp/CM21Q0fCWRVBdjuzsLVYDxcsUhQCrada5uIjwVkBKF4eT5x37Wq4LOvnGsP7LdBK3KY47QwtSOLHKxvDdTmckxcSGpgjHTFYdAOjo0Ox7hyzbbPRfOG4lcxAY8O2iJnPEmjfkCn14YHi/HofS/mpfWiEVs1P4Csj277YN6BI9OvGl3iTdiHag1njvyGylWkcmc57hp3ylIuKmtnjo8fNw83INUNmX+Mul91gSWU4P3836XDly0ci1GRKQJPuxZSIB1egBiDmmXefItxaLyVDZKknpXjD9kozg/q9PHcZmea9x5Gk8/R9nAb+9xFD3jordSIbuK1kO4ROcVWRC6UxGpubqgujfaJ9MVEQYwQ23DoQTJ+BBRdmgEG+ueGQYfoZx7olvPQ3ThxXCo4iwO0l8fvKhgIj3gntfxiDZr+VR3WkruDIe7h3Tfmm3VMtQp3fzxZ9gd5agSRvQKuVifYcyCy2FDK9B/9NUo2t55pQBPtAHhgICw/6VfMzZGC1h4AcH5gL0bFO7tLyKB3X0JlK4TTxQs4Hh4HEyFipAJemdPFE0tPl3zn241HHw6eVRbTV3J2NsADkkYqKthbCdLSM+Ucx3JBgyJtKPzlhx5gYxwlRr9NrTgUej9bcrEOhSTc5Qt0TLn6Y
 XPwTUa61
 d5M+psD/zc49NKwq4jsNPii4dr8vgd5UGhV8jePx52UJsA0r9mdmrC07P17R7TPGqPftdOqVQSmaQ7xoT4WGlGxlwLMUNkFXXkidaBuw6/vqbZyJmQ9cF3RkjFntn112pt76ONQMLAGwKb08ggWbZXgVdpk8FjhkxvMDf+ZsTGv1h3NVW+/Wucf5YuPDvhY6ShLcsokeSfaJoek4FyR6LFlTTZeQzJruXRkJW5guxgOVpjdW88DcA4AZY2YS9GpjCQbNNPV4nufxn4tK20LGt0+SCKurNEkly5cKf8XCJFq3gbL32LbUGZmFER7Vtpy7mqTgq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the page_vma_mapped_walk structure to track whether the walk is over
an anonymous folio or not.

This is necessary in order to determine the correct VMA page
offset (virtual or not) in vma_address_end() ready for a subsequent change
which adjusts which page offset to use depending on this parameter, and
update the comment slightly.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/rmap.h |  2 ++
 mm/internal.h        | 13 ++++++++-----
 mm/rmap.c            |  2 ++
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..a48ae9575bd2 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -871,6 +871,7 @@ struct page_vma_mapped_walk {
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned int flags;
+	bool is_anon_walk;
 };
 
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
@@ -881,6 +882,7 @@ struct page_vma_mapped_walk {
 		.vma = _vma,						\
 		.address = _address,					\
 		.flags = _flags,					\
+		.is_anon_walk = folio_test_anon(_folio),		\
 	}
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
diff --git a/mm/internal.h b/mm/internal.h
index 73f90aaa979d..7ed8bde7890d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1079,22 +1079,25 @@ static inline unsigned long vma_anon_address(const struct vm_area_struct *vma,
 }
 
 /*
- * Then at what user virtual address will none of the range be found in vma?
+ * At what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.
  */
 static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
 {
-	struct vm_area_struct *vma = pvmw->vma;
-	pgoff_t pgoff;
+	const struct vm_area_struct *vma = pvmw->vma;
+	const pgoff_t pgoff = pvmw->pgoff;
+	pgoff_t pgoff_vma_start;
 	unsigned long address;
+	pgoff_t pgoff_end;
 
 	/* Common case, plus ->pgoff is invalid for KSM */
 	if (pvmw->nr_pages == 1)
 		return pvmw->address + PAGE_SIZE;
 
-	pgoff = pvmw->pgoff + pvmw->nr_pages;
+	pgoff_vma_start = vma_start_pgoff(vma);
+	pgoff_end = pgoff + pvmw->nr_pages;
 	address = vma->vm_start +
-		((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
+		((pgoff_end - pgoff_vma_start) << PAGE_SHIFT);
 	/* Check for address beyond vma (or wrapped through 0?) */
 	if (address < vma->vm_start || address > vma->vm_end)
 		address = vma->vm_end;
diff --git a/mm/rmap.c b/mm/rmap.c
index 5798427d007f..04b657eefb3c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1240,6 +1240,7 @@ static bool mapping_wrprotect_range_one(struct folio *folio,
 		.vma		= vma,
 		.address	= address,
 		.flags		= PVMW_SYNC,
+		.is_anon_walk   = false,
 	};
 
 	state->cleaned += page_vma_mkclean_one(&pvmw);
@@ -1317,6 +1318,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		.pgoff		= pgoff,
 		.vma		= vma,
 		.flags		= PVMW_SYNC,
+		.is_anon_walk   = false,
 	};
 
 	if (invalid_mkclean_vma(vma, NULL))

-- 
2.55.0


