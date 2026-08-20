Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79AACC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422366B00A0; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6A76B00A2; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295AA6B00A0; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAB856B0092
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F67A8020A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:31 +0000 (UTC)
X-FDA: 85122551262.28.B5C8B76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 10EE440005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E0L9KID7;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252129;
	b=kytHyRutLthZgjfem8cUx9W0/q5Kv2lpZ4zKme8LKJQ5gP8n6mw7s/BlYB/m9vsmmaXsDM
	lkeS+VVAhb437IBf0ZxxrsWZfhAU6fYAcclcAuYwv5G8+7OdBZfKTMaNmBDHhimpVWJVQ/
	rtmmMfWbEQpDQ8fYWn2mn+5Mes3KlM4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E0L9KID7;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252129;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0o6rCEavSxshXR4yUHe0t4eylWueKOPWAWQXsV1nh90=;
	b=UCu+v04oLP/TO+/5i1dtHEh0ZVYczOGEGLL7tmFoqpCK7MCwF6vQFHLMzHF80iUSI3zJcK
	bde8RrkNFfVBzObmijSDVRBoBQyGLqzq8X4kIBw8Nhe/ZoNdygCl09LMQB3ATFRalBCZu7
	B4aYZEyvTBjVB3fRrWG3hT2kdg609yM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E281D44226;
	Thu, 20 Aug 2026 18:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C22EDC2BCFB;
	Thu, 20 Aug 2026 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252127;
	bh=ZIOx7u5+j5YnV0RDhkMv9qnsb5igOw0DW4GkSQInsKE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=E0L9KID7NlgM1pvWIdQrCWVQasdTTmDK/f+TDRorWQBCr1omRl7XbsFJMXAdkc+fX
	 vx55lxGlOOxd4U3hqCGdjFmCQePcBLStCc0h8oa8C+Zws++JTFzXROYjrRDvoaNUFO
	 zdCrsRMvdcJ21UPrAz531iFroX2dkRh0KMViniPEi+dBGvAEvMfdtzYcCFZ+I5oA8z
	 7s56ofVSCg+6OZz2MFCo30TRhXLXaEJbYtOTgsZfMBscvp5z8Fdu02cUy5NAPMLkJj
	 58LnaQoKwSRwjSnwlYlEgSmMxvJXao587jNkBqjoic1PEYaNdz6laY+wgrHaurH7YG
	 OxS++UTmImfXg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F81C5DF82;
	Thu, 20 Aug 2026 18:55:27 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:15 +0800
Subject: [PATCH v3 02/18] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=3656;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=sKRHOoJ3KjkPT6/oC1u2CVtXhFAq341fQZtAgnnTY3A=;
 b=3zwvvtcfXVg5C8pq5HfEixAwFpKfWp0hrW/JYJS4MCzZ1dJ2W08HHgEf7dbSN7ZQmgWIXj+2l
 QpM+O2g0stgC+SMPtNGHt7Gg4qZuyont6+VUtuo3edQXKDC09M/ePV4
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10EE440005
X-Stat-Signature: fqyhdnua4gdqzqgn93f7hfuadtsthdqr
X-HE-Tag: 1787252128-298460
X-HE-Meta: U2FsdGVkX1+60AwX8nViuF+PwZ9GffCEizQqAFTc255pfgO7A+dM3BVEUSJAL7ZMM/ukjRPRtgB87lWQUANuP8qLu16VZFqFmLT1tCXGR3T54aQxY5+1sRIPKFeqg9HiHTQOMtDJ5QFp62nAHqHwPGZ+iDq8H+j8a3PGQkZsoMeYiXghC0CtP4wqzxT60ehGA8ZDW9LFcBrX7F5Jv+UHvcqtahjc84eSz4Ngm60J0GeY/VkbeGt8JiWsLt9LmYgW5zIY87k3ZfP8cDSxQPF3perxjbY7NajCvUDMmFVZI1aCO4md7e8gCYwelsNUTaBcOjqhu+lbMhPMCfhWZe7PtYBwEq4OBMfzbfCpxIsH55X+Km/jDT9G5cB1iD9sQUXLusWLcw7JLHTaS+eapzZDJfNC5CZaWzQCDKgAitKXPMQdoQnJ5p2W5EwClagzmlnlU9BtxHKQtswt49keuRlg6DLGPUAw0nEUm2NuwO9EW2nEdRl/Qd/12daY/1VAkM7TpoYzUhRuLdgTHbqvKOyjd3fJSbZlyHDINfMkQti90Oc5VSTJ7lFaUHhDioyutA1JxjKALKTgxrL5sqddP+YeTDzAIQY230XMG0c/FjZxms5Hdk/pCuWViTYbiMPdsYF70mwrI4E4x+WDUBOiJCuw7LC3b793vJ90s3wrtYqsC1tWXfAoF6f6CEy46Ttd05jxrV75zA1ky3Fe/0VuAlatnSljY2vAH052spF3LS0P/uF9B0FnIzLanKyIsY6DCAos1T232yZK1NdJCSQWQg3z/ro0ZE8XeGkXsmPWEjngYwZ2favqiuEAvNJzVtxHnJRtq9Vli6pfD1Owzvs5Qz9pE779wMtEaMBj/W/s1tNUkqqUFXdcVIhpp5RKrADRZ4TfLt4diH0FHzKirWBoI4LLGhZP9uI5tU4kzKMd0F6+wAGKqhnC2SXcht5kywyI7jQswxnbB9ML6YeG1Sz2+Kr
 dfHn2v2Z
 fQ2C/8x8vMCkQH37NAcFZ126FuCTMiQ5bfPJJ/zqrAPAiJqjwnEnrOg8TyjT/sZp+4qPo3iJyMYo/kvshgLQp2tm1GSPkdMk7cne+/jR64c0s0O1Y37pWuAbzQzgzekTxwRpMzDDDEhZib+uDUMT264y5J5wkgqu6bTgd1QLB721IXX9NxUGsKW10fIHMAAyIUQ24tdebVg8nxYJ1Ud7UyHrqRmzoghhC5imBqq7go5DpKTOFQWAAoXYuUrzMDijv+HLuuM5pUFbHNedKzSj9YSmrIfzcp9fl0N1M+EyT+sflS95/mhIBs4opb7sT53NOTp9NM4ukAReaoN7TgQ25k1uDSGpPnlXXIOxUSFS1QFEleyMIHCKEuqutAh31TZlk3CaL4B20AuKOPmF39ZzOBfU7F0CMwN1wDGOp+vODXZGUOXc/RQMH8Q1cysjth1gkDLhPgtLzJoPzTfgn4QQlIgZydwnCMqXlw5h6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

A folio in the swap cache cannot be split if it has a mapping (shmem).
The split code does a defensive check for this in
__folio_freeze_and_split_unmapped, after the folio ref has been frozen
and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
rejects the split and returns -EINVAL without unfreezing the folio or
restoring the counters. That error path is buggy: if it is ever taken,
it leaves the folio frozen and stuck, skews the counters, and fires
the VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.

Check for this case up front in folio_check_splittable and return
-EBUSY before any state is modified, so the split routine always backs
out cleanly.

Also fix a bracket style issue that checkpatch.pl keeps complaining
about.

Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43..a6759a14e057 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3878,6 +3878,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type)
 {
+	bool is_anon = folio_test_anon(folio);
+	bool is_swapcache = folio_test_swapcache(folio);
+
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	/*
 	 * Folios that just got truncated cannot get split. Signal to the
@@ -3886,11 +3889,11 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * TODO: this will also currently refuse folios without a mapping in the
 	 * swapcache (shmem or to-be-anon folios).
 	 */
-	if (!folio->mapping && !folio_test_anon(folio))
+	if (!folio->mapping && !is_anon)
 		return -EBUSY;
 
 	/* order-1 is not supported for anonymous THP. */
-	if (folio_test_anon(folio) && new_order == 1)
+	if (is_anon && new_order == 1)
 		return -EINVAL;
 
 	/*
@@ -3901,9 +3904,8 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * swapcache folio split. Only uniform split to order-0 can be used
 	 * here.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && is_swapcache)
 		return -EINVAL;
-	}
 
 	if (is_huge_zero_folio(folio))
 		return -EINVAL;
@@ -3911,6 +3913,15 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	if (folio_test_writeback(folio))
 		return -EBUSY;
 
+	/*
+	 * A non-anon swapcache folio that still has a mapping can only be a
+	 * shmem folio under SWAP IO, it's removed from either swap cache or
+	 * shmem mapping afterward. There is little benefit in splitting them
+	 * hence reject it here up front before touching anything.
+	 */
+	if (!is_anon && is_swapcache && folio->mapping)
+		return -EBUSY;
+
 	return 0;
 }
 
@@ -3983,14 +3994,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			}
 		}
 
-		if (folio_test_swapcache(folio)) {
-			if (mapping) {
-				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
-				return -EINVAL;
-			}
-
+		if (folio_test_swapcache(folio))
 			ci = swap_cluster_get_and_lock(folio);
-		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 		if (do_lru)

-- 
2.55.0



