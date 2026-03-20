Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 004611099B2D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB746B00C2; Fri, 20 Mar 2026 14:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3452B6B00C5; Fri, 20 Mar 2026 14:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5806B00C6; Fri, 20 Mar 2026 14:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E55A46B00C2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:08:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89D0A58355
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:08:08 +0000 (UTC)
X-FDA: 84567225456.22.3FDEA5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0AD5420014
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:08:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a68hAJ1i;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Gky14Lctfh8onFzTbtEY4RfZnax2wdsQ0IMxXFatfM=;
	b=0aeSfuGUClTIS/WxGoF09oUsSr3Pc0Yd24Dc0DsgbP4zVw+diNtfal+v/i59rf3GgdmPk0
	P0kMUzIkmwuDt2aMJBHCtYt66mJ1RHQI1gTwy+cwHjIBMguO6OdeDsJWwUuJVx6vB6pZWy
	28B3y4yyuukAgcppfJDmjUvoXf8/y1E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a68hAJ1i;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030087; a=rsa-sha256;
	cv=none;
	b=QhjRuHnh6p8xK5tJ8jG7tgK5CwuqvXzJ+Qn3yueeP8GR6IZK3es4g1o92DE+VMkb40Oc9Q
	m9UaSSz2kF8upP/ZHXwFZsHNWfIM7MWtFuQMqYew9x7NmZTB6NN6NWAPRkRTTUenGVByy6
	Hihe62cEXthfQyS+hEbJd86El8Z2/F8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A97360128;
	Fri, 20 Mar 2026 18:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E3AC19425;
	Fri, 20 Mar 2026 18:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030086;
	bh=6P2QVEZVXVar1bmzgldHuZ7a+MnKysvamdRBwGT7peM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a68hAJ1iGqH/rdOm9hYDiCHCh8oHUxOEaobz/g6HDcmOJMC9tpFKDjNUCaxMvitz7
	 Y3InS9H/twbtaW9AREXURS2pEjKmH6WK5wJWsDJoNGS0cEtgT1kctX9T5aQWZC/pjO
	 KaYXQ2KePnvfxMjBmRvx2Llacg4PJVRnhYcrGXzkq9exheni6GiTG8Dcbc7pEDlk9R
	 Lqmr2Kifo7s4iB28ELQwP3m2RggAkrl01KOON70VqbrVm+QKdnTcVzIEKUVsg/Dei2
	 DTPSHnMVPx0Smc7arXu8ioY6C46nFk6ONrS6/O41gw4kLvmMl/0yQHPFUhRAWKh4l4
	 E6fXVkX9r/Rkg==
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
Subject: [PATCH v3 12/13] mm/huge_memory: add and use normal_or_softleaf_folio_pmd()
Date: Fri, 20 Mar 2026 18:07:29 +0000
Message-ID: <c2be872d64ef9573b80727d9ab5446cf002f17b5.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0AD5420014
X-Rspamd-Server: rspam07
X-Stat-Signature: ex563pszqm6yqbugxtrxkbjpr5e6oxnk
X-Rspam-User: 
X-HE-Tag: 1774030086-729618
X-HE-Meta: U2FsdGVkX1+6ij8mCe5rqNhgbs3+h/LPQMvlCoH7zH8OPKlDiT/gjqTK41pUaXF7Fk0WhR3Uv0iPPBml+ydR2D5zPhivIbKpDSf7xfj2pQFNuv8D75REr6uvHGjwy7gfnStJpVEgm0srza/BPxzqjnWd+/2trHz2ethc7D+IWe5c/OYHPTmnRdeaKrbzpCktqFm9J9F36V4KiXPuZAohJczCqlimvZHafgcYC6VZSMS3S8jV2WD5u2Tj8TEta2Cs0p7/JA29ZEYq3CBiBFBCogwF2qrX2f4JR4JMBmzM/F7LsfmfYcFeqq+Vbk9V099ou0fN/XQgPUk7/q6spBRQX+eG0PVIdxjHai+ioQGhv6XSKn386+DXIQuYW9sodU1d3blNsqkkLbv/1DafSM2yvxa0/a5zqOYoRVi5INjY0WnRsYYvjXU/cLemhLlUxk9ycVYNHliZavMNU9/6G60lIZ74tKz68x5hzqII0xg7NqYhpEe6kRNrdXysjZvixqbfjKhrFjm8vg4uOsgtHH0y+rc3z6q2OSuN4KLGS6DSy5HmVRIZAPUZxZPCnmTo4Qf/LDyigP8Hxodw1g4aVl3Q/3r9LGSIbARYOQ+w4TJeOqenhMcLXmlsj21CGNv5/6r5gijIWMDWpy3r971XXIfCWeK9kq0KRAQcZdK23WAEIlPOpmnT0VlRtBWPML9VsmZNQv5pDUsu3fgMepgqgblNH7De5UBhgo8CULcuLHPwnfrMQZKoCLU31MeTKzw8C+JPcvYfq6jofnBxsix5q5vi9U6ux35C9/C0KluXGAOUyR5YtBBkx39/jae9fBgPKXCZIeJwr7JiKhpJRj/Xf7u6XyRfdOEy+Y+AhM9WhjDBG2ITQsIOacPEhucBA9l9rhEqqsSlcwDcS3YGMYPS2GY9ekSyHw5gz75SCkb6PGi+9bQ3jxuH50xh/9Ib6QmhlH5+tpnwLTeT0B1C6J9xfc4
 H05wPfqX
 2kunBJOi/AijJtU30hNAVVS9+Sk5Mm3isaihP/yoZZPd9dwSwkBKCcR3fzM8G05ERvHJ/jODfK44rIkRAbEyQo+pymrxmIwTD+Bz25I9So1Ddw3bRqCdh+So4ViJZeV3+NfY1ZJQCwmmN7XbvYIA8jAHwSdOKoK+u6F/RTFkDYTIUTuLTXN7x3PIRV5M1u/2k44vtBQRwvJoX8KNN20NV8kmM3IvS8L3Am+vWQQvw8BN7zV5S1kxGEup090DGtSz74ysSBeHyMqJx8PKycu+g20/7asVEO4o0/Qbo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have pmd_to_softleaf_folio() available to us which also raises a
CONFIG_DEBUG_VM warning if unexpectedly an invalid softleaf entry, we can
now abstract folio handling altogether.

vm_normal_folio() deals with the huge zero page (which is present), as well
as PFN map/mixed map mappings in both cases returning NULL.

Otherwise, we try to obtain the softleaf folio.

This makes the logic far easier to comprehend and has it use the standard
vm_normal_folio_pmd() path for decoding of present entries.

Finally, we have to update the flushing logic to only do so if a folio is
established.

This patch also makes the 'is_present' value more accurate - because PFN
map, mixed map and zero huge pages are present, just not present and
'normal'.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 47 +++++++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9ddf38d68406..5831966391bd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2342,10 +2342,6 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		add_mm_counter(mm, mm_counter_file(folio),
 			       -HPAGE_PMD_NR);
 
-		/*
-		 * Use flush_needed to indicate whether the PMD entry
-		 * is present, instead of checking pmd_present() again.
-		 */
 		if (is_present && pmd_young(pmdval) &&
 		    likely(vma_has_recency(vma)))
 			folio_mark_accessed(folio);
@@ -2356,6 +2352,17 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		folio_put(folio);
 }
 
+static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t pmdval, bool is_present)
+{
+	if (is_present)
+		return vm_normal_folio_pmd(vma, addr, pmdval);
+
+	if (!thp_migration_supported())
+		WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+	return pmd_to_softleaf_folio(pmdval);
+}
+
 /**
  * zap_huge_pmd - Zap a huge THP which is of PMD size.
  * @tlb: The MMU gather TLB state associated with the operation.
@@ -2390,36 +2397,20 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 						tlb->fullmm);
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-	if (vma_is_special_huge(vma))
-		goto out;
-	if (is_huge_zero_pmd(orig_pmd)) {
-		if (!vma_is_dax(vma))
-			has_deposit = true;
-		goto out;
-	}
 
-	if (pmd_present(orig_pmd)) {
-		folio = pmd_folio(orig_pmd);
-		is_present = true;
-	} else if (pmd_is_valid_softleaf(orig_pmd)) {
-		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
+	is_present = pmd_present(orig_pmd);
+	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
+	if (folio)
+		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present,
+				   &has_deposit);
+	else if (is_huge_zero_pmd(orig_pmd))
+		has_deposit = !vma_is_dax(vma);
 
-		folio = softleaf_to_folio(entry);
-		if (!thp_migration_supported())
-			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
-	} else {
-		WARN_ON_ONCE(true);
-		goto out;
-	}
-
-	zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present, &has_deposit);
-
-out:
 	if (has_deposit)
 		zap_deposited_table(mm, pmd);
 
 	spin_unlock(ptl);
-	if (is_present)
+	if (is_present && folio)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
 	return true;
 }
-- 
2.53.0


