Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C24260A3837
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IFJkaVff
Received: by kanga.kvack.org (Postfix)
	id 6EE7D6B05D1; Mon, 26 Oct 2026 05:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6306B05D2; Mon, 26 Oct 2026 05:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602666B05D3; Mon, 26 Oct 2026 05:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 370636B05D1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:42:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF1851A06BA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:40 +0000 (UTC)
X-FDA: 85364287680.24.5C1F951
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 15A2D80006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IFJkaVff;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvZKYtjJONqhmHx9UTd6oM7xaC8eYsTGRgCqXckztow=;
	b=OXRPeRzjO0fptIZ+GiVIlT2mNlSnosH9yQ3Q2E/7VWNN/649S9Yc2Gi+5R5evKEjibnuVo
	JEPdaA85RK1NpmdbvOMWVjsvN/BaI52kH/8Gc69R57XMX7Q/dPcc4Ap4Dmv0pPNLDe+Dcn
	d1JKY/bvqoxKxYofohas5jx2tyCPcTE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IFJkaVff;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007759;
	b=BP6lkZrfQXGalg7bnvwMSewU7nZS+dZSb2Y2iWdn74GtYiBPWc0C9B8ZB+1QYE/hZ8y9iZ
	0173kDgjC6m4hsnn74YQWcZfVqieFPxUbzxGnz0s7T2V8ujPWeILHDq4oBE1d/iO49QF8B
	8jVE4tAi/FOoawhoQrh/r5edAHA4Sks=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AFB8160A8D;
	Mon, 26 Oct 2026 09:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341091F01481;
	Mon, 26 Oct 2026 09:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007758;
	bh=mvZKYtjJONqhmHx9UTd6oM7xaC8eYsTGRgCqXckztow=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IFJkaVffg8V/Tq2zsOyrwUTHkmgAN7z2UXol3hm2HOIH+aJvGLAtJfL5mybzgrPag
	 cwzykKLSUJQreiBo+xkChyPpNSqRMSoBU09oLoodEt/0FAm1uFlsAJCMxiYLbrQy8q
	 xFTZsTDXdNaLGH7oEZJSVjcXIgK8w5zLeHUJ4+6YHIlLrVBQF9l4rO6RD2G+jNz1mk
	 fhSOfrxKtfWVmAR78B+A9TOLSTP3CmMbSIuKK9kZ7A/U37wqs84++yBYhXcmfwA3qy
	 8gsstED78sS4ogHO/Z1MGSTyTHr918Gb3pRhzmbuc4lGqme8j8zZjHiilQi6H4cupy
	 Iq1M7IFP/YU+g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:48 +0100
Subject: [PATCH 15/16] mm/shmem: fix accounting of swapin-error markers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-15-703206d5fa0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4415; i=david@kernel.org;
 h=from:subject:message-id; bh=ex+R5CTudd+Uv2VS81erAcqB58oiZJKAMktJTm4l9cM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK0hMTZ2y7Hi+uvRV92XX5tr6nos2yozf4Jm/aMKz4
 PVWp8L+d5SyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRC48Y/insNBfUmnr6TcLT
 wzWSew98+/r+5OSmI63rJk6qEZ/52buekeHUqvityczrhARFvlc5Wcd9NZJ+8U0hSc792rmfk79
 cZeUGAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 15A2D80006
X-Stat-Signature: ruzgq67rxsmh5fsfxarwaim15gn8385j
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793007758-610424
X-HE-Meta: U2FsdGVkX18yXFsvlt/S9FCTiVS3XgFmz9ptXTjGnyRJ9fbFsLwiYzvmN9MNxP+iPsRUHVtCE+2IN6raSYsg93w0tY26sYpBntS4oub2VK1GELmTZXErdLrQSbJ5Fw3OucU7eeXSbz2V+Pye6k70i9EKFsKvNHHf2LOS10rb0nGCod2CGqKX/ztmjc/iRv8LscNENmXvkDtkXUaDS7cXfZvZjkgkNQ5XfzHwQ5IB7yjtX9lW1lKavs4Yqbcj2tcQ5eXUjfFhsCV4A6WVuCArHmCLR/oby3StQpfo86zngeoyt9/LvvdohfUDbikVdSR8I9k4YhlDh4xmK5W3+E/RzsyC0lClVAJJpPDaffEclE6kkZk3APxh+lr1E7o/HJYLfVuiOmtgbQwC/cvY4YXXG25HYkvkqeGCGR3ag6K2TdW5hpn4PMgxC9xlkHZcBmkkuPE+w1bBnXzapd8cja0cL4ATe57c2KBbRWCi6UhEurjGian5FtOcfmRfi10CvaE5hrRh/3ZVTyndg1ChYotI20cjcve3lrp2N/OCHFdbwOHNcbdwHhZ2BdbEaDKDo6z725EO9zsbr8oqC3o5Uz9L9F0xWNkx8Ll3gQde6X01Zh+BWb3m4ZsXqQm5sZwBi7gAraNg00vdmaPqaCkkV1kw3XBpAWsM/Frseg50zMOD+6UcvSbv840iABgfPRUGt4fZqo+L07M+DvMdBpsgJGvlEEbjIc5iv3XYqzle8UmtKXp38S6aEOzt/syd7X0g/moFLaABtFFJSNRlcmQ8F0RiENB2ZjP0MFt0tJVUj7saeZuROaZLoMOzzKV2CNsG8jYV/bWRKahG+yInHEsO8O/gfBphXTdcmfrYooTTEp9QkGEwjtlNUlJrUtwLdYjQ6grQwpYGa8ABjERtUS9wp6b6ljiaT+V6ZLskN8y+o5hseLSiGdE0K0ff4+97L1b4woSdHBORgicGtMLnjDBWTh8
 boNklT3L
 mgycCgxaF8KfZkqVW7aSaxhueRP2/JH0DgX5xWbKIjfsiV+Lf6PpBFVW1Ctoznb3kuu65Ly7Hsyi0PHalwD/bXwBBNBRnNyG0++iFnzBCfFGWcvX4E1PKA2VblP+wixBOhqzoEQR00kom7JM3qHdDUL25dRaUfvMF6eEcwo3tUG35FmJq2nWFdmtaJwtHEg3/Eub4fWhU3t4fKjqRGGCZgYnyq3T/vsUiWwokXISTHIfUCnGUcYwMqgRh5WxG5xnq91X2U/4MBQktTHXzZTInpdgwqFXAv9s7H+WkRjwIO0BT5fDfT1Xf3i2GsGwFVcdqAfm4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A failed swap read replaces the swap entry with a swapin-error marker in
the page-cache and subtracts its pages from "alloced" and "swapped";
however, it leaves their block charge in place.

Removing the marker during truncate then subtracts from "swapped" again.
This can underflow the counters or make swapped reach zero while other
pages remain swapped out, causing swapoff to loop without finding them.

When installing the marker, subtract only from "swapped" and let
shmem_recalc_inode() reduce "alloced" and release the block charge.

Make shmem_free_swap() report successful removal separately from the
number of swap pages freed, so removing a swapin-error marker does not
subtract from "swapped" again.

It's a bit confusing, but replacing a swapped out page by a swapin-error
marker in shmem_set_folio_swapin_error() behaves as follows:

Initially:
	alloced=1, swapped=1, nrpages=0
Calling shmem_recalc_inode(inode, 0, -1)
	-> swapped = 0
	-> freed =  1 - 0 - 0 = 1
	-> alloced -= freed
	-> alloced=0, swapped=0, block charge released

Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6b24b9d6db26e..f5b5c9a312c53 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1177,12 +1177,11 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
 }
 
 /*
- * Remove swap entry from page cache, free the swap and its page cache. Returns
- * the number of pages being freed. 0 means entry not found in XArray (0 pages
- * being freed).
+ * Remove a swap entry or swapin-error marker wholly within [index, end].
+ * Return whether it was removed, counting freed swap pages in nr_swaps_freed.
  */
-static long shmem_free_swap(struct address_space *mapping,
-			    pgoff_t index, pgoff_t end, void *radswap)
+static bool shmem_free_swap(struct address_space *mapping,
+		pgoff_t index, pgoff_t end, void *radswap, long *nr_swaps_freed)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	const softleaf_t swp = radix_to_swp_entry(radswap);
@@ -1203,8 +1202,10 @@ static long shmem_free_swap(struct address_space *mapping,
 	xas_unlock_irq(&xas);
 
 	/* A swapin-error marker holds no swap slot, so just drop it. */
-	if (nr_pages && softleaf_is_swap(swp))
+	if (nr_pages && softleaf_is_swap(swp)) {
 		swap_put_entries_direct(swp, nr_pages);
+		*nr_swaps_freed += nr_pages;
+	}
 
 	return nr_pages;
 }
@@ -1358,8 +1359,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += shmem_free_swap(mapping, indices[i],
-								  end - 1, folio);
+				shmem_free_swap(mapping, indices[i], end - 1,
+						folio, &nr_swaps_freed);
 				continue;
 			}
 
@@ -1432,13 +1433,11 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 
 			if (xa_is_value(folio)) {
 				int order;
-				long swaps_freed;
 
 				if (unfalloc)
 					continue;
-				swaps_freed = shmem_free_swap(mapping, indices[i],
-							      end - 1, folio);
-				if (!swaps_freed) {
+				if (!shmem_free_swap(mapping, indices[i], end - 1,
+						     folio, &nr_swaps_freed)) {
 					pgoff_t base = indices[i];
 
 					order = shmem_confirm_swap(mapping, indices[i],
@@ -1459,7 +1458,6 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 					index = base;
 					break;
 				}
-				nr_swaps_freed += swaps_freed;
 				continue;
 			}
 
@@ -2420,11 +2418,10 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 	folio_put_swap(folio, NULL);
 	swap_cache_del_folio(folio);
 	/*
-	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
-	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
-	 * in shmem_evict_inode().
+	 * Let shmem_recalc_inode() reduce alloced and release the block charge
+	 * for the freed swap pages.
 	 */
-	shmem_recalc_inode(inode, -nr_pages, -nr_pages);
+	shmem_recalc_inode(inode, 0, -nr_pages);
 }
 
 static int shmem_split_large_entry(struct inode *inode, pgoff_t index,

-- 
2.43.0


