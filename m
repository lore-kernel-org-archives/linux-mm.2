Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C560B606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d5qY2gz4
Received: by kanga.kvack.org (Postfix)
	id EDCB56B05CE; Mon, 26 Oct 2026 05:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3D86B05CF; Mon, 26 Oct 2026 05:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9FA6B05D0; Mon, 26 Oct 2026 05:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAA066B05CE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:42:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49B6F1606FF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:17 +0000 (UTC)
X-FDA: 85364286714.17.0E7289E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7C63A100006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d5qY2gz4;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6C5eWK0lANuvr0EbYmUrr+WQ85r8KV1PLsSlbPppSE=;
	b=SP95LSXdpXiMeG9C11rv3Ae0GhNapkAAa8c/lVbJjyitidMIEk87GarsDudwkzFh+b38aO
	6FK2wU3UBZE5egfWui1JLy71Htem9URilH46zQjvFeqr2e8e4+OT1Dys5+4i1vF8p1cxo/
	oWecPS8MS7iA1X7bEY8X3VyK7Tb1saM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d5qY2gz4;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007735;
	b=xy5ofxT4kqehrCBF/iqKaXtOAz8bobLUT5lRTI0F0GsgAQCoC6fIJ2/yKAjBBdFQk6HSNd
	7WDrlpk6eS4wztwILcCK7zn4zLnvv6xZzsyIOlbUZM835GgABq9xSuqNBXH7TWvRo/fsU/
	I6Vn6x8ksLOdOUBehY5RZv3GO6eCOcM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B51B7431CD;
	Mon, 26 Oct 2026 09:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548E31F01480;
	Mon, 26 Oct 2026 09:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007734;
	bh=L6C5eWK0lANuvr0EbYmUrr+WQ85r8KV1PLsSlbPppSE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d5qY2gz4kf/qdhezW8wIdRJgyLiqOQPOwp4YDgPCnbHZN2q7+2ltPfhwWvtlCc74F
	 SUWN+jcLGZqbmMx4mxIBGZLa7AfJgjoBmLGVFO16TA00qPlV+WN3klic45/9BBCBas
	 LyyFH5A7Jex9QJFh1sK0GXbUoJKR627MxcTnjhZD8e+HXoygOdj5TzFyvwDskQ2svv
	 3MPeuxPGmylLdLY4cKpa98sO/YvGu/uGiZbkW3sUQE2k6DbDO451Ne+CDWnXosDoSR
	 +4HVN2AcpSmSsuxjLx5DWq16RsRfnNcXEEmcw/hQDIGQKKDKemCiO4YHfZ5WKFRB3o
	 AsvqMCGU7rzGg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:45 +0100
Subject: [PATCH 12/16] mm/shmem: fix truncate hang in large swap entry
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-12-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3755; i=david@kernel.org;
 h=from:subject:message-id; bh=M9M4ZQas3jhOKYrqmhXuc+90i9n2F8rbl9qLqL19hpc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4iffzXvQ2D0Qx3vZIvqawxij52UcysvPb9g3FYl5
 H6Xsai0o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIlEfWb4ZxqlEvO6Knendur3
 8jf+vddVXUyXnp14RipFqVPHvnSWDsP/JIUHVzLer0uuMjs2+cvXLPbUzC4VxzV/HloYXQ7Nf6j
 OBQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C63A100006
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ss7g8gse7f5u9oajcrxnmdggwx7ipaqt
X-HE-Tag: 1793007735-902040
X-HE-Meta: U2FsdGVkX1/ATbUxsGk7iGSmX5bfUqe1ALWGua84JFOl9FRddF9N4thhUlxKjX8thkEpU7ycfgYMBftVM9zMzW4FXh9FMZn68+2cJcgW5kDGxTidgs8I1ESva+iYkQ4RaCJp8Ji+fz/QFuSbfYM1DLVZKxD0TU/z46VlMl4poR8F3zn9d8+JGqaFJ5eU3FiMku0IngZV80/mK/tAMj0GvIG4ba1jQZSJ3rIuE9tM2D8O5vfartGXfavvYLVwxaNUurCeUtYYm82pxtc9gUuX3AsAJ+Lcf2kYqpkUGyef14G/DiYC9QWURGgTSofW5VHcc1wei3mionirBpr5euxoi+y8jKq9h6xmu5ZvhvpzWlVTDvVtsBT7S8YglO18XMcNyUanz4WQVtOW2hStiNmg6ZTJLkFrydecfhfjeI4Vwi3L9pBYVB57PZ7hM68C2y7seLelsclRQ7q8LNW29nX0+AVVRt6P86+BBPJ494ba5X2puEc/I7cQNkNqzNO1wRDKiD2x7Nk4n75QE7ioMXhwPJpnnSwR25/1GMfYcNbb/ph2Ptehkxxrd/FX6VnNT8rF/vuNixvA3QVx1VPPp47ZcXOpZXkkYoWMaZnm3lDrfGgWt+3thMUmXVlb56yJ1MGjruwinQgjqujvOkFWcUH7wwWKRgPXRijT3Vu3FWQoGGiPWjC6yMXDfbffo93TmeKW+t3VO6lf7aCXNtGzdlIw1GzJsb2CnopHIFNu4WOcbZnvx0n80vHQS96xMdoqpMCKUh4APe1yNxynf9FQsll8NH8HnNFT5YkXDe4+EREovwQeumJmJnHpyR9UInKmePPr54Ke84BT0OVL9IqxfQV3M4uhD1s9aNgWT9NN2XhhZvUKij9DpOtU/iAdR10CdTLqwlCyW4htjNFhLTWJKK/TNbvMVFVaYPddBRIics9fvDK7zu9+nhGscx1jaZC3KGdpbuW0rcU4WE4mEszUue3
 1TAdZqO1
 lpewiPEGkGqAvFGEcA4zgcN9mvpdsM7CUam//0ziQ9u2Zr3XCE+GaXW0NH44WFl+qVm73xVReUrRaT/dYjBZ1ccCnywdveqtN3o6ZxKSE9t3QjM/chnVsWBYFNn5zdEW87PLx98JJRfzHDlS7/X0yp748Ref6DLnyWJknnr2DVZ6mogZjldhmRdkeGqA5p1psA1o+fdI/QLfQiDgbxTOSJ4QNlh81aJqt9V3kBFL2RaCnlJJMZeBXjJHf+uLSLK3T3Qpl/OLGImW2+chZP/WiA4Utw29PbU9aBjvQ+NqsN+yQJbIfw8CcUAG+6Q4xdowQelow
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
swap-in returns a smaller folio, it also splits the swap entry so the final
scan can free the entries beyond EOF. Retry the lookup if the entry
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

Original fix generated by LLM and sent by Chris Mason in private.

Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fcec40a2dd707..9e0034a424908 100644
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


