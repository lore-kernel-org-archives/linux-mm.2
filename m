Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA86A606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JCXjI8iU
Received: by kanga.kvack.org (Postfix)
	id DBA846B0A58; Wed, 25 Nov 2026 10:49:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69FF6B0A5B; Wed, 25 Nov 2026 10:49:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31E76B0A5C; Wed, 25 Nov 2026 10:49:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9679D6B0A58
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:49:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18EA1C0F72
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:49:15 +0000 (UTC)
X-FDA: 85474075470.27.F597228
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4180020015
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:49:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCXjI8iU;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795621753;
	b=7lKZzC9+wnx64v59ASSKg1//6rCh+YyV4iRp7ETn9rjNjNQbsFBh3TCxHdwmnPHlQxXzq6
	9Gzd33r2ZUx6cTnKykFSwB3epgSgvNxbfNJ2ManhFLRsTykV8hSeGKnbjeUgHi+XjeJJOP
	qBKxZ9EEL15ktIwRjGb0sbMOLQCTjOw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795621753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JArOqiEtRII0TMVgOdCRi3ObeS3HL32v+b04cIgxYZ4=;
	b=mJKHVek99ULxnZ/lgQhoDTQHAScO6OGf10CeIT69Ny4IE5YRYA6A+789kgxqNzWdnJYkdL
	Bl6XcWF+aQLP5D4x0tfKmakGBKKrIa8zKmbE2BLgPQDKWqDvAaZLb3khp6Qgf826dsjxbU
	T8WmIZAb+XrUfXYLE/wPmdfUGhlhm2I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCXjI8iU;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1448632C8;
	Wed, 25 Nov 2026 15:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5651F000C4;
	Wed, 25 Nov 2026 15:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795621752;
	bh=JArOqiEtRII0TMVgOdCRi3ObeS3HL32v+b04cIgxYZ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JCXjI8iUjpAWK4zdPu337qhqC8H0f1ZqfPxpKJAww3W9ULkEdWevSJvhB4YrxDqCe
	 8U+EHBXpSmg6dLunr3QAg5QtzO0c0EuVatpy+jSO8OINH3YCRpJ4yS9slTUhvepcZH
	 gWmNL/VAjraWgkh+mD4nzzR/G6XzIyNd1+sYKWzcMHASMY098ACTkAk1LHL5q4vfPe
	 X9E0Fxd7Op5bjVd3fiUZL1ZzQmalxdExbOlTJz/nM4vi6pEP4c5fNTLSt96KJBi4d6
	 qAI7JZ3jei2yDg/VgVm9JomO6MhH3uVK35nOGqsoakAQVm25RBMSHFSUgh6CtAgouL
	 nsfGzoujbUOjg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 25 Nov 2026 15:48:49 +0000
Subject: [PATCH v3 1/4] mm: update walk_to_pmd() to explicitly return an
 error
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-huge-pfnmap-fault-races-v3-1-bbc44489341b@kernel.org>
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
 stable@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 "T.J. Mercier" <tjmercier@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2608; i=ljs@kernel.org;
 h=from:subject:message-id; bh=exnJ13XewIuI40LjK8x5qure1OWqXB+8p5QwkZysSkk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLZmTMjjj10T2n+lPzMc0r8Xt8HC2OP9Nv7nTncPu+ry
 gWTbn+NjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEykq5fhnzlrfKPVimen8q9u
 P6Xwpne1bVSz7gnleU4nel7uf1wgbcHwv46PudxmwvVDT1tql7sIRdx6FL53Z0vGUUHhHz4T1l7
 dxAQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User:
X-Rspamd-Queue-Id: 4180020015
X-Stat-Signature: e5k97ppgx3m11483thcdfakf3one66qr
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795621753-853276
X-HE-Meta: U2FsdGVkX19m19Eis6T62wP8d+lAPUCyfW3PvRd8QeqzAsIUz8HVKfgd6DVRFHXhLj3VIjk74CXfnr9UzIhEv98Qn3crnhFyOfg0SzAgu6zi9XjJGcBWR51NQ7wd/NwaCI8N8lMi1B3VsHlKQiPQoMU0SAsb/nIs5IQqXLuWElXFxnXmIFeHH7WItqv3rzwVErHFN5MyNTrYwa31kVaIIs4ZYNIwyHnGCVhqQXonVqGmsGF0SD5DjDUguXEpzFrIC47+EwZ/Tu4/zVco4iNfz86tF1tK9DYfpJOvo9d43raBV3hit2KrE40PwpUxe8vNB38ox81Pg6UAkDqvHWVrG/gBIgm9AutowldH3y9UTw/4KUBKJio+jqTQj0x2ANO3jQLwUXTrz6CD/gnRoyT+/3Pkd0FC+1UuTBd8YVglnxv23oMttRdvAZCYiMJXonBEgfq+LVzXflAJlemc2tZokne4ef2NtgGDeJeLuPzLU2q60UX/YOLbW/NUbPJZDPnng57irAIXumVWdSEuZrSJWJWe77UlDS1IoaEVmOL74EdYxoD2W4az3z+Mc0nMShW10s89MAofgbWWxJCVzGwciyQ53varnV32iyeisC55tkf6PphVPLFKKXGA7TMF/9/rGR7WfaG3eP6laZq5cXPVHxXA8ji2qQLioFL3OXlYU65TEd5q55qa7W0pem6Vw/foLkiwotfo+H4yP2kTDeFcuZHVmUdwSpKc7ZAzWHyMGnjHwbMxTbqhVDsH7Y+ivYOEkz/UlDuGp2vgM0C2XwbWMrdiIzf507zm+MAFI/wg9DR3yfMYqqD98botL8hvw6b9ji+9x/ml+xCsHGNZh4WDQmvei8c2bnnE10T3fzdp3ALzygpbdJMG2uaktC4Ld0cG6hroUI+QtCiAqazVdEiG+iOuJkqaepYUK/L7gYp8WaSyYjeVWkRQanrHrYHfEPieNsnzekooKSgEVuq2zxp
 FRF2bvxP
 5pIYjvV7OPLRsaiX9Osq4lXRvRnuUcHBfxuVtm7LZN+mLS6mMeO0cq3apxHCDnXw6Twnzu6fDr6rwUZuiVomsTBU+jCsy5dc7VpsbpJ+r3IKqm1YVJCKn0+y4OG5EHAdiZqyWIEsy1kO7cBFM000y8lSNPnEIpYvW3URAqlUWi7l64PdroaUiYhe9lGE7wKwUwLUGP2NxH09mb6bPnADjT4+lFsJp74JCt6jWkF9q3oi+yLvVzidkraWCUjwRb9SlC7cA/VY9DXCW8kOqyR1TjWY4YHnfKsoenGzArLQR/6Ds/iMPWMyayJwtaqjDJZQ8QPj5B4TLHPTTBNT1+KzzNRzRGLxl18FOBGY+SRUebvL8k18GICa9wzvHpQAtu5XdsCqVB5SOjDmhP2pR8Nk1LzMcTXHzHQAwMc3QsBWE6TrfNcEvPrQ719SEqxnaK6nEQlPEZTGHWVM7xTRO7hGDhfy6jeqEw6ImJP1nfLUHg1vULyIWdCGqaiwb1CEhQj6WVULVQ2K2oNF/KRaa62eY2RcDko42Btz6Zaj8JCIwcG1ykuqP1u1kp02AdByz692tlB2t0PgeEERd0RUY7CG5tEGCMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Rather than callers inferring an error from a NULL pmd return, explicitly
return error codes.

This allows different error codes to be returned for different failure
conditions.

No functional change intended.

This is a prerequisite for the fix to insert_pfn() which follows, as that
needs to be able to tell a failure to allocate a page table apart from a
race with a huge fault, so mark it for stable alongside that fix.

Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3a20d64fd276..67ee25215ca5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2366,7 +2366,7 @@ void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 }
 EXPORT_SYMBOL_GPL(zap_special_vma_range);
 
-static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
+static int walk_to_pmd(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -2376,24 +2376,25 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 	pgd = pgd_offset(mm, addr);
 	p4d = p4d_alloc(mm, pgd, addr);
 	if (!p4d)
-		return NULL;
+		return -ENOMEM;
 	pud = pud_alloc(mm, p4d, addr);
 	if (!pud)
-		return NULL;
+		return -ENOMEM;
 	pmd = pmd_alloc(mm, pud, addr);
 	if (!pmd)
-		return NULL;
+		return -ENOMEM;
 
 	VM_BUG_ON(pmd_trans_huge(*pmd));
-	return pmd;
+	*pmdp = pmd;
+	return 0;
 }
 
 pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
 		      spinlock_t **ptl)
 {
-	pmd_t *pmd = walk_to_pmd(mm, addr);
+	pmd_t *pmd;
 
-	if (!pmd)
+	if (walk_to_pmd(mm, addr, &pmd))
 		return NULL;
 	return pte_alloc_map_lock(mm, pmd, addr, ptl);
 }
@@ -2532,13 +2533,11 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 	unsigned long curr_page_idx = 0;
 	unsigned long remaining_pages_total = *num;
 	unsigned long pages_to_write_in_pmd;
-	int err = 0;
+	int err;
 more:
-	pmd = walk_to_pmd(mm, addr);
-	if (!pmd) {
-		err = -ENOMEM;
+	err = walk_to_pmd(mm, addr, &pmd);
+	if (err)
 		goto out;
-	}
 
 	pages_to_write_in_pmd = min_t(unsigned long,
 		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));

-- 
2.56.1


