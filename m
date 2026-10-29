Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD06606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mnHzwDpJ
Received: by kanga.kvack.org (Postfix)
	id DAEC76B05C9; Thu, 29 Oct 2026 06:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85856B05CA; Thu, 29 Oct 2026 06:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C816B05CB; Thu, 29 Oct 2026 06:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96C756B05C9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:45:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21A421C354F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:30 +0000 (UTC)
X-FDA: 85375332420.26.4C35534
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 62A0CC0004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mnHzwDpJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtiqQ6mgNUmco+qazPoILLniPuDRWOn9KFRt0uj6Dkk=;
	b=futL1PNHiI8pqaNl4HrTAykH2R7srdt5ceF7VbW2JaD3DhLJOIOmrw8HdMvkI0u+mWDy5V
	wS32SUyhVXXcHVqhy0FzPCIyD2y7HLfxCgxmFM3arnHbyrwKHhFm2nmiGYnXQ+L9hbbZ6t
	kSUtoty6ouewmWuDnvKiT8iCaVtHA4A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mnHzwDpJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270728;
	b=fi7ARg8kKO/MB9Qk2IQtphq1TwNz9sOp2bCuYpWKSiSHNW4rB9AliJySXkBzH1bTtz5t3Z
	qkLH7Gdemj9ORm5/YSvGG3Syrpf5WlhXzA2Erp6Xi6cQfZQfqb15Lgel/sC1yBXYfTvySl
	eb65+iUQSb8ChqsOWy5hqyyuftKbsHw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08CF160214;
	Thu, 29 Oct 2026 10:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C084B1F01828;
	Thu, 29 Oct 2026 10:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270727;
	bh=WtiqQ6mgNUmco+qazPoILLniPuDRWOn9KFRt0uj6Dkk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mnHzwDpJlycNAPBXDqupQKEHQtoa5a1SRTgFumF7QI1vKnWAloBp0UyoWv4EV12ej
	 /ZIk7mdQhNL5EIx634OvxLw8A0uGNa/rBLQkCL2WvKNzoLGefvVBXnMvEv01EtgAND
	 4mnurpSDUZJFTxtiGlDlQS1I6KKW3wYtYjANajlB7nJa1XvIVOtx/nK/fEiD88YZMI
	 QfeWRWUbQ4L/Wr/TPdNCid7iRid05tHMjuEejhfS+2fWHMISJVrkpCXGm+l96V4MT9
	 TImeTrFlkBJaIgFqqDwwyW4M1x8ONzlMgplEUzEt0mFcS0YehHadcKCSkMgFaty7BX
	 PBUC6ZtqXioYw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:32 +0100
Subject: [PATCH v4 11/15] mm/shmem: fix truncate hang in large swap entry
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-11-392fc715d8f6@kernel.org>
References: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
In-Reply-To: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3891; i=david@kernel.org;
 h=from:subject:message-id; bh=613Vl4NTTalBRyxJuidD0xGKjT0hH85ba2S5eQweaQU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4fzObh2zToQe+/nhbi7+h3Vuzo/5n/i4J5+I+Nfh
 9Udg9AzHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzk4GtGhjuySxa9/BnEeUri
 phfrnfOyqY5cl51PepnPUWEsS1S9uJSRYWbtBuUpdopKt595H8jlvvrj2W9xt5Svul+flkfYnH0
 ryQoA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 62A0CC0004
X-Stat-Signature: 73h5f3s1t6tozdbehfs4kz1n8ufxz35q
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793270728-209231
X-HE-Meta: U2FsdGVkX18NH4tak7YYa2tlenH5ChPH02Bgy1F2UGKli+iVGDOWidy+WJIcyytx0WU3ax5ELxuEVHjhU/yENeZ6kCM08M7TyWwa6HCaFCJkFzXxPbBZBO4+eoTBWSAlUXsNTISGDeWkJ+p60TACGc8JjUMuk5lbfXnvAuttEwDjVv3pn+AO5mhUgWFo8PfMNwDPsI/hJXUR2dm5XGE7dL6j5Z8h43HDy8tZXaLLlBnksxAPZH2onydg2z/BT1QV+//Xc3mjDeIIpOXEZ46DZ+VpJHlR2ODKaG3NUae0C/0W7sfgdZEq3Q2ZynW8sZnSQIVVvZKjQ6WgAPm4KCxOoNmcFS2tHRR0EeX0z6scy470SknxepkprImoV2BKzjSK3640Fia3JQXN3rX7z4CboSKiQp25b6XO/Ydvuv6lhxcKIILwnZreISawKKHCQNAdLPXmhpD+J1ThmDwc252crGP21BF2bNHUUXX47YIti60pXaq9DPfjRiUd6CB6lKsqk5H3R3n6UrGM/kflYnSi/fP668WdCzz1iMzqC7yL6P6ujjyP0QLvZBf2u1TGN1w+2wGhfdxZLlHVXEejJ+tffqynPfGP0lLvbKwdw2EeAtE20QqgtoIKPJWiCvL9VWLeEAE+XRsQvUbylfOAv/WWs6Yy/y/YMyvsrWLTC0tVAfzW/ZN0r6ViZVL6Rsyp5++eWIPhMUQBoeeaYJ1vlK42DMfgOQOQd+pPKThVTj3HWMxlo7jW8jaOxQTp/CUW9LOs4vPqeTxz5JWWsnGeieVF+JNxIQd+CuIHpRkO1FGsBsJ392VnOa0xeLGhNlyCKvFfAovSz0bkoP1HB4ZA1/wUy4Kbaxmz+8aWO/8OGvhHNCXO/DZ4OgE+0VaK390ODrmXmUJSHtuN0mzTP1fLRc5XaHZyLJ+KCYD51GdVcf2Dqfhj75kPw0cdIWdb5xWWBGFczwm07+uBk2+ooRZGugW
 pUEvQqTF
 p22KV8c8CAtZBUAyXclSEeHHEvkHC83NSsHZVv8Ko3+XT2MU/YDPmz6EamVcxW2flUhOfwUmZxEzNyRdFdwEpgb3tTh8hv1FCbnzA2Flk5iLBiWUUc65wG2OaQ6WzUEX1w/VeDeLk45cstfGM3Lgw/o8eUZeI8+ixBm1/c9YxgQLZzmcSMms7jSk4IEruShvXFIC4WwjlCDGww3V4hzgVUzGN5Tqs3itUx73Xq4YMwiKk03Pa/8ju0uGPV5SGJcBKWb35LoLKqFhCIb98ZcdQi1q7oyDBKeSzES84Vo/Ho6x/w1CLmNqai3vakrXlhOf6lmp2A1nD7YSUxGdoXnUciKiFjK6qAbaYK7saJ/arrx77Vu7bSWWM6V19JWP9YR+/Vf2mI9JEN3Ey3V+pCvkSXvewfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Truncating a tmpfs file or memfd to a page-aligned size inside a large
swap entry can loop indefinitely in shmem_undo_range(). The task holds
the inode lock and cannot be killed.

A large swap entry represents a whole swapped-out folio. For example,
truncate a file whose pages 0-7 share one swap entry to four pages:

    [ 0  1  2  3 | 4  5  6  7 ]
         keep    |   discard
                 ^
            new EOF, start = 4

i_size has already been updated when boundary handling asks
shmem_get_partial_folio() for page 4. Since it is swapped out, the helper
calls shmem_get_folio() with SGP_READ. That rejects page 4 with -EINVAL
because its starting offset equals i_size. Nothing is read back.

The final scan cannot free the entry without losing pages 0-3. It skips
it, restarts from start = 4, and finds it again indefinitely. An unaligned
truncate avoids this particular failure because the requested page starts
below i_size. Folios already in the page-cache cannot trigger it as the
direct lookup will return them beyond EOF.

Fix it by letting shmem_get_partial_folio() call shmem_swapin_folio()
directly for swap entries. This bypasses the read path's i_size check,
allowing the existing boundary handling to zero and split the folio. If
swap-in returns a smaller folio, it also splits the swap entry so the
final scan can free the entries beyond EOF. Retry the lookup if the entry
changes during swap-in.

Handling swap-in allocation failures remains broken and is unchanged by
this commit. Even when shmem_swapin_folio() correctly returns -ENOMEM
instead of -EEXIST, shmem_get_partial_folio() returns NULL and
shmem_undo_range() skips boundary handling. If the large swap entry
remains intact, truncation can still loop in the final scan, while hole
punching can return without zeroing the boundary.

This may read an entire large folio back from swap while holding
i_rwsem, only to discard part of it. Avoiding that I/O would require
splitting both the swap entry and any large folio still in the swap
cache. That, however, is much bigger work.

Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e96dc3beac95..e1b7cf4b5280 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1298,12 +1298,10 @@ void shmem_unlock_mapping(struct address_space *mapping)
 
 static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
 {
+	const gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 	struct folio *folio;
 
-	/*
-	 * At first avoid shmem_get_folio(,,,SGP_READ): that fails
-	 * beyond i_size, and reports fallocated folios as holes.
-	 */
+retry:
 	folio = filemap_get_entry(inode->i_mapping, index);
 	if (!folio)
 		return folio;
@@ -1314,13 +1312,14 @@ static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
 		/* The folio has been swapped out */
 		folio_unlock(folio);
 		folio_put(folio);
+		goto retry;
 	}
 	/*
-	 * But read a folio back from swap if any of it is within i_size
-	 * (although in some cases this is just a waste of time).
+	 * Truncation can look up a large swap entry at or beyond i_size.
+	 * Swap it in directly to bypass the size check in shmem_get_folio().
 	 */
-	folio = NULL;
-	shmem_get_folio(inode, index, 0, &folio, SGP_READ);
+	if (shmem_swapin_folio(inode, index, &folio, SGP_READ, gfp, NULL, NULL) == -EEXIST)
+		goto retry;
 	return folio;
 }
 

-- 
2.43.0


