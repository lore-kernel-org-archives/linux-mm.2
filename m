Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D69606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IgdedSCQ
Received: by kanga.kvack.org (Postfix)
	id BB40C6B05B3; Tue, 17 Nov 2026 10:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65066B05B4; Tue, 17 Nov 2026 10:58:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05926B05B5; Tue, 17 Nov 2026 10:58:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77AC16B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:58:46 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06D101A04C0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:58:46 +0000 (UTC)
X-FDA: 85445069052.21.3D2B98E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4F35120007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:58:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IgdedSCQ;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794931124;
	b=bsjki8Bex/usDKn8moZyHmT+pjYUh5Cp1J+AAN2YDvOQSwZsykub1WU0W2dP2XFkeQbt+S
	nSTC4tjYZSV1aZNHv/lRN/XKbAIR/ttFDY6qMGaZ4ee86uIJPDhCc0GEUI58yYZY7ra8JX
	4M1Oh6vpVpTKJNilyFNdtQhqQg7/pzA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IgdedSCQ;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794931124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJChRhdyIRPbnT3aRE1AL5b+XTb/DT038/sueecHEmA=;
	b=s07q4JeO8Mt42KtvFeIvgCN0LaaXDqYhNAhVrr3dSvMdvO7fNru88bzFYMNh9iixjyQ4rn
	f5M8gCYytV+FRaxbrQAaHwTi8y5ZeOfVut90iFHav2uZZTv6TKZdBVYGzKbbVDv0ZHisk9
	w5HkugG9kbWJWxkR1C6u2YeDDjENRdQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C642C6119E;
	Tue, 17 Nov 2026 15:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CE11F000C6;
	Tue, 17 Nov 2026 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931123;
	bh=zJChRhdyIRPbnT3aRE1AL5b+XTb/DT038/sueecHEmA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IgdedSCQIFwyT6QEMQg1ZeujbhFtYtn+6n20Gx6YaDlh1frHhXoz871lHHiY44SSg
	 iUiTCRBRH7V/2bKia5VWGDlVNRIY0kwCqrF7tep3IUoeMFLxqmfn0+tUezaMEFi1nI
	 p3zOfGpF/LzTY+Zj4zPAFBB9tWSUEyReiciLjgm2CZqUg2RJ0kAELIGDdMN8acTsZ3
	 SkubIs+c4WJ5TDl3Cdneb8V9HFxuAMr+8OvAGNOIKrnpf0tMuMK8IiBUOg0Iq4fTP1
	 pn7Ug6i45H9Q4qJLHXsbzDWMYriJSVruXkzn8GlVJHW20l3Wxg+pnWU/q56X6FwZDf
	 jln7BeV6awk7Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 17 Nov 2026 17:58:32 +0200
Subject: [PATCH 1/3] mm/memory: install new PTEs first in
 insert_page_into_pte_locked()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-dax-async-wp-fix-v1-1-c9a30f27f452@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, nvdimm@lists.linux.dev
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F35120007
X-Stat-Signature: mhn9pf5f1atwb78d6cadhcqb81p399ps
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794931124-248529
X-HE-Meta: U2FsdGVkX1+F6PxOYrceLFcIDmlUsoX7siCuLKd2yPDXnek5sBn8za18ZE7sCaaFYGTecC5TvTazsjrSuaP+pwC6/4x2MoFAEqwSEtixr0L/v49dXQ9M2nWyzy23u8YHcNKVFUzF1w7v5/2UhONVEdXgZmWmuGyIGTGVt2JsjcT0540cMvhJPYNO52TtZGrNWCmSweBE3iYh81M32AOtY8pDBfbamSVHAv1+9clN/ga2cdNcTzXjo+onZiZi0/K2/5pIgU0iJpHIQe8QgrNle7XHBIyZw0mPca2p9sSCk1sE9TgA8JN1iQGOkVgh6tJL6YxQey8Q92T/617a9WucBEXgwbYwGS8eJSexujJx5a2Lot/f6Ir4PK/9L09HsjaQqehan9BGEBdjzqSgQNZA+5PnlKyKpknc3iuAmarObNaKuEHcF34GiuKG0ByKHgnfTEVo7oY32UphTZRWfd3uHeHZqPMv/2N/Nx+tVsTe7bh7EqACkqCk1kuSxVpETul7LxUhb7mEV+Qp2zgRn1JNsJnibMRj3ocd9lc3UfDjgJ5fgsURsx5FIv2ja4afmvfZKFbR3XPGLS+nRSVU2rv846PqAQ9jBvKhH9T5CdDyO+lDv02XR29eCAspb8ZsqxUm8exsigssi+oNA6iUZTS8gJ5OHbxQIIE+QRohfHcrMWxRbaH52JuV/Man8sr+nLMxKsbqlE0tPEO0+zs0tIX8dlxKXFbgZjXnIvBOnJYjk0kpJ6CM3d3p9tJ/9jvX1e2lFxnR46EebT7STerrYffr+caQOGneaLka12IV4MIVTegLUk8ZkTeVUetZUx7Gjy5/b4jOXugIvgj/INkc/RtNLp26GGPcxniRzEuA4oqDjpVNsc4N+UuzUu+QttGv/GCLtnO4p7vJvSWM7uRyaAgxdSDDF1GQ0/MPoni7LuJwyWG821EdeER2+S2BroH/d0Xx08Jzof+246V00okm2kq
 GBrJ6Tmu
 lN4fXzKn/gPjjdPZzbfuNl51TEOtCGnzM3+zUmI9uMeSQQj4/uY/vZ4mzf7F9ucLB4gyUHfSVTKpoGuzV0o03s4Bi2zdJYjtZ7fk9qQR6T6FhdtWSpuoICQCNm64DfmukdjKNLFKUqBRib90ntRKGjFu7QJmWE+3jFmiA4ZziQQA3354sgYg1Rw3A+b2C9+3wffoCW3xgcirOVAlxezIUj+QyGJWAOJ04T28TqkjMA3cse2B08QeZK7+kW/N89pdPmS6RhtJs18u8I0iwLoQL6hvfUlXZg9snf5fY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

insert_page_into_pte_locked() first handles non-empty PTEs and only then
deals with installing a new PTE.

Upcoming fixes need to handle non-empty but non-present entries, like PTE
markers, differently from present mappings and this requires restructuring
of insert_page_into_pte_locked() to avoid extra branching and nesting.

Install a new PTE first and return early, and then handle the existing
mappings.

No functional change.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memory.c | 65 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index fe72e66c9c2e..f927f2241e40 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2453,44 +2453,43 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 	struct folio *folio = page_folio(page);
 	pte_t pteval = ptep_get(pte);
 
-	if (!pte_none(pteval)) {
-		if (!mkwrite)
-			return -EBUSY;
-
-		/*
-		 * For read faults on private mappings the PFN passed in may
-		 * not match the PFN we have mapped if the mapped PFN is a
-		 * writeable COW page.  In the mkwrite case we are creating a
-		 * writable PTE for a shared mapping and we expect the PFNs to
-		 * match. If they don't match, we are likely racing with block
-		 * allocation and mapping invalidation.
-		 */
-		if (pte_pfn(pteval) != page_to_pfn(page)) {
-			WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
-			return -EFAULT;
+	if (pte_none(pteval)) {
+		pteval = mk_pte(page, prot);
+		if (unlikely(is_zero_folio(folio))) {
+			pteval = pte_mkspecial(pteval);
+		} else {
+			folio_get(folio);
+			pteval = mk_pte(page, prot);
+			if (mkwrite) {
+				pteval = pte_mkyoung(pteval);
+				pteval = maybe_mkwrite(pte_mkdirty(pteval), vma);
+			}
+			inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
+			folio_add_file_rmap_pte(folio, page, vma);
 		}
-		pteval = maybe_mkwrite(pteval, vma);
-		pteval = pte_mkyoung(pteval);
-		if (ptep_set_access_flags(vma, addr, pte, pteval, 1))
-			update_mmu_cache(vma, addr, pte);
+		set_pte_at(vma->vm_mm, addr, pte, pteval);
 		return 0;
 	}
 
-	/* Ok, finally just insert the thing.. */
-	pteval = mk_pte(page, prot);
-	if (unlikely(is_zero_folio(folio))) {
-		pteval = pte_mkspecial(pteval);
-	} else {
-		folio_get(folio);
-		pteval = mk_pte(page, prot);
-		if (mkwrite) {
-			pteval = pte_mkyoung(pteval);
-			pteval = maybe_mkwrite(pte_mkdirty(pteval), vma);
-		}
-		inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
-		folio_add_file_rmap_pte(folio, page, vma);
+	if (!mkwrite)
+		return -EBUSY;
+
+	/*
+	 * For read faults on private mappings the PFN passed in may
+	 * not match the PFN we have mapped if the mapped PFN is a
+	 * writeable COW page.  In the mkwrite case we are creating a
+	 * writable PTE for a shared mapping and we expect the PFNs to
+	 * match. If they don't match, we are likely racing with block
+	 * allocation and mapping invalidation.
+	 */
+	if (pte_pfn(pteval) != page_to_pfn(page)) {
+		WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
+		return -EFAULT;
 	}
-	set_pte_at(vma->vm_mm, addr, pte, pteval);
+	pteval = maybe_mkwrite(pteval, vma);
+	pteval = pte_mkyoung(pteval);
+	if (ptep_set_access_flags(vma, addr, pte, pteval, 1))
+		update_mmu_cache(vma, addr, pte);
 	return 0;
 }
 

-- 
2.53.0


