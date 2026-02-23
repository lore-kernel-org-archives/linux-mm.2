Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2177EC1109
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAFC76B0005; Mon, 23 Feb 2026 11:42:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A917F6B0088; Mon, 23 Feb 2026 11:42:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993EB6B008A; Mon, 23 Feb 2026 11:42:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88DA46B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:42:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 367D3B61DA
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:42:10 +0000 (UTC)
X-FDA: 84476288820.28.A08EB7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B10201C0004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:42:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLHfNXig;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771864928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IQlEyFeS7mQPu3mtkCE7tCcJ7fcl6nNXV+8pqsgrVkk=;
	b=hgLWFJ8EyjQT5BCoTy5bG4xNqW2OGRK6rOnepWgo0B+yUBzMvFcQvF5hDLasyqSLoPhePJ
	5+aQ93idyrp2xpBtFPvZe59EkqsqNpOfaBkZak5z+yJEvTAGsROHtJNZkxW4PwIga5ZMNK
	VqW5EZWd4Qp4ORGpbHGjO86rP51iNeU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLHfNXig;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771864928; a=rsa-sha256;
	cv=none;
	b=YlXtsfNMHTlnUoDE2aGYVHrAsCjjdhZm52eZNGrw0wZbTz4KWBSwjcR+W9TfMN+8oqKCAC
	H3ODSghjPlntDemCahHcrGZyC/6dpQHe9NOWjw/icShqaHkek9cYNEUiHD0o4eb9bYs/b+
	NRl2XCODB9Dvmlc/JP3LtUXYMGdz7l8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF4D76013A;
	Mon, 23 Feb 2026 16:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27663C116C6;
	Mon, 23 Feb 2026 16:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771864927;
	bh=AmIef53ET5UNsIt0ynl/BhGBHCMTtv/CuWlgjEBgi58=;
	h=From:To:Cc:Subject:Date:From;
	b=NLHfNXigO+VeoRtLpSAQ4qS+vR0aga2R6gXWVYEYm71fWRfYJ6+kFaVXFNxXgm8Bs
	 jd6Zr1ijCryiiOHfMqUyvHBufHtarhbpO8/lzm3khYezPELSvyPgHD6RB6EKHKA1+g
	 wF20HGvWYSHusCkffngqv4zhr7HkB2yJlZWsDTuT4tWyMMKKP+KVV+bnrNro1gDC2U
	 56ze33Z+CL7qaEYENwGJTZ9lNy4HU2CoksBjHQmFbqyN3cfEXbKqzZpGVrAOVXPca2
	 qKLRoK4J0p6OibyHk0FUksWphP9jfILomVlP+o6cIMonKCAhji3ofK6Iu9CRQ3SUlc
	 5O0NDXxWwDi6Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v1] mm: centralize+fix comments about compound_mapcount() in new sync_with_folio_pmd_zap()
Date: Mon, 23 Feb 2026 17:39:20 +0100
Message-ID: <20260223163920.287720-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B10201C0004
X-Stat-Signature: burpe71ot57zfoxkbw65m699zmmk768o
X-HE-Tag: 1771864928-39161
X-HE-Meta: U2FsdGVkX180lrWqUTmg7Tx1f2HCXYw7Ipr5g56roMEf6hPrp92MHPBfHuwSHPobzv8KYFgpVxgiVY1AfpiBBUMmqdBLZMk+U4/cCAeg3WzPDOvGQlCjHrnCpkEQV3Q2Pz/u6sV3B7Mnw8coLWsnjRfouXtH3oZL/ZdW3ydtJY29FAFSXQ7LXcDu/jXIQEN4FgAWodSIriun+neKCCS3oie0QJX83yrggognNMdgxFVZZdNRcg1Ev/Q+6/o2rXWphBAtNZtwZsiMMJd23mSrAntPxfO9VT1BF2Ysz8XnkxQFcBC2DoB33gYNeh4o8JIcVLrP+jxUUSNVvXvtbcgCgeHuex+jFf3DeUhlGePSHQkE1Nfeh9JxXYpp408y0oNXXT2k4cS/fu3xDg7u/x3TR8awoGT4PmqzOR8GkgEM/h013DVRoPK4RYKsXVINns1NBnSC0rICzproy01nRrb/t9nU8h0UhvjCAOuvmX/yn/A+LNSMTkSBxkR7ogOFCZHHnbAhCEg/ncAIIzwiAyFP7zw3NkxQ4HEa5xCyLgrV++RdbHeQ+wDHmDpBrgHDC1ZQh+hweE83DIQJY+xggziKb1vVQFXyTEaelJROixYuVngTeKnH9u8K2VCp2DAhujplZirc5qxNPCmHKLQBXszu+d1T6ZUIPv9P+PYS7WVixSKCApoxQNfT/MCafVAF9vYwsEwYh7qHKJ+M/dSuKEi45IxLAsgRAOjQfuhikGy25IHBxLuuL7BNi22yutVKgcZuVT+Rdz32ViWa1PxHfmwYOksVyiT8dxPuyL0l934s8NYNyku/IJX9orjtoL69cyXBT9Emqi39/IribBsC1J1Vs6lYR1OdzUcFKG/wEYBLOFBeGc+10M5N27pD/FC+IMN8Z3nWYpdvn89ZVshfuqOQFdOP8IELXei9QDy59bI07cJLjVMjQwN7QOhMDIczq+lzfY4BaHBUquHhGx+UWJP
 yYjteJRs
 /Y+Djgdfua/gvjNoMKqoJTRpcSgmp0TdIEiPd672bn7211eQEVGccA/jPpW+xU0LUsk7WrTzpaKldoGjnget1CJN9aTo12QXIl1TLVxv3oV9q3SrDPz7NJFKgeQa2O3ZFHwHrZmnNcT9X6szNOn8NTuVjbLV3buDu0fW/Y9iLjSC9pI4DwrwqjVWNvDDWbJ+U5fGGG3vVeaMCzcl5h7Lnf9/VqIr7uLZVtSGRNZ/ycHafZz3wEVVqda+JUm3WVxtGjbbTTd+RqO+3IrLnqtLljm3yW8n6x6nVFNaJ9q/Dv8hZZTctxrDyyTVHIKdk/mLbP65hRe0IgGyh6RS73IHELNWz27oHG/A5r3hOuZRit57gpxY20oFk2sdLXCxUntSgpl2nwY5Grv9J+o+T/lpp6VImekqBFrv8vTPzcAHqB4ePkO2KmwgZaugTD5dI45p9tn1OWLe49Oqb1V/PiWHsvyZzvwGRe0tifXCQsbtuxhxVmZAMb4iwpvX65C+qO2BQaTGge1mnu1X2KyTEdenwL5DveROKdM6g17D6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We still mention compound_mapcount() in two comments.

Instead of simply referring to the folio mapcount in both places, let's
factor out the odd-looking PTL sync into sync_with_folio_pmd_zap(), and
add centralized documentation why this is required.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/internal.h        | 19 +++++++++++++++++++
 mm/memory.c          |  8 +-------
 mm/page_vma_mapped.c | 11 ++---------
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..e0ef192b0be3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -516,6 +516,25 @@ void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
 
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
+/**
+ * sync_with_folio_pmd_zap - sync with concurrent zapping of a folio PMD
+ * @mm: The mm_struct.
+ * @pmdp: Pointer to the pmd that was found to be pmd_none().
+ *
+ * When we stumble over a pmd_none() without holding the PTL while unmapping a
+ * folio that could have been mapped at that PMD, it could be that concurrent
+ * zapping of the PMD is not complete yet. While the PMD might be pmd_none()
+ * already, the folio might still appear to be mapped (folio_mapped()).
+ *
+ * Wait for concurrent zapping to complete by grabbing the PTL.
+ */
+static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
+{
+	spinlock_t *ptl = pmd_lock(mm, pmdp);
+
+	spin_unlock(ptl);
+}
+
 struct zap_details;
 void unmap_page_range(struct mmu_gather *tlb,
 			     struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index 876bf73959c6..c87d796050ba 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2006,13 +2006,7 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 		} else if (details && details->single_folio &&
 			   folio_test_pmd_mappable(details->single_folio) &&
 			   next - addr == HPAGE_PMD_SIZE && pmd_none(*pmd)) {
-			spinlock_t *ptl = pmd_lock(tlb->mm, pmd);
-			/*
-			 * Take and drop THP pmd lock so that we cannot return
-			 * prematurely, while zap_huge_pmd() has cleared *pmd,
-			 * but not yet decremented compound_mapcount().
-			 */
-			spin_unlock(ptl);
+			sync_with_folio_pmd_zap(tlb->mm, pmd);
 		}
 		if (pmd_none(*pmd)) {
 			addr = next;
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index b38a1d00c971..a4d52fdb3056 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -269,11 +269,6 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
-			/*
-			 * If PVMW_SYNC, take and drop THP pmd lock so that we
-			 * cannot return prematurely, while zap_huge_pmd() has
-			 * cleared *pmd but not decremented compound_mapcount().
-			 */
 			const softleaf_t entry = softleaf_from_pmd(pmde);
 
 			if (softleaf_is_device_private(entry)) {
@@ -284,11 +279,9 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
-			    (pvmw->nr_pages >= HPAGE_PMD_NR)) {
-				spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
+			    (pvmw->nr_pages >= HPAGE_PMD_NR))
+				sync_with_folio_pmd_zap(mm, pvmw->pmd);
 
-				spin_unlock(ptl);
-			}
 			step_forward(pvmw, PMD_SIZE);
 			continue;
 		}
-- 
2.43.0


