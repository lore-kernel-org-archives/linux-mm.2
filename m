Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3DF606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hza8FH4y
Received: by kanga.kvack.org (Postfix)
	id A2BF36B05B1; Thu, 29 Oct 2026 06:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05436B05CD; Thu, 29 Oct 2026 06:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919806B05CE; Thu, 29 Oct 2026 06:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 711E76B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:45:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EADEAA7930
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:55 +0000 (UTC)
X-FDA: 85375333470.26.C525609
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3915E20003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:45:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hza8FH4y;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270754;
	b=S2dlfIb/ZMsK4jABJChjysOwND/GGXRmLSl+SW07nIVNcxsw5iVb2Ew+uBMVjnKAwuao23
	yrFmqhzk3PEOjMJFxOJXvUHAXtaRnLkQe9NxfIdplANQi7fbludeDo6wZlcqd2l5mV6ZC+
	tVVlSba5AUxExiZI1HLPCy2dgNlG+9M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hza8FH4y;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOpicr4/nVjUTFq+nOkoNBNjJy8NdOt38t8q45tot68=;
	b=RVbdEFtxGtndWS/DyXMMa4DwCdEkYlS+7GU/ZcpWWRtXNfMNjUFiEyRyoG30szB0ZqMqs1
	oZQldjpops5TAlRiDt4jZ0DsqVGlDia7+kgl4xdRSH68HMamJSfLGsP0yHA2UnL1sFH+Au
	hG4vDGaKRwo7lrvWEdhjWc6COhjdRC0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB08A600DA;
	Thu, 29 Oct 2026 10:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B29B1F01828;
	Thu, 29 Oct 2026 10:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270753;
	bh=EOpicr4/nVjUTFq+nOkoNBNjJy8NdOt38t8q45tot68=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Hza8FH4ycQzhLwxvTbwUuEXu5jbFA7/R/t9H0LYZ2vUY+SI3PYzU/CxvePMOA9uOH
	 gAR9ulTJxITjo0Fy5FxcM0bGyJhE5BAHu92aOhRRc+MXctqaMdwvvaiSqBA5mQxrCX
	 LMNAEHJs/TCxtz9saDDG0S5I3i/Y/LYSQJ8IrbYDc1R70PF6GnHDQ5nOD42ET+WdpQ
	 fF45dr/ZJ4Fe5d0Ow4A8nZ/TCz+fVS5g5Qvo7lcAxrurkyA58/Y4h6clUb9ZhI5HIZ
	 UL9T88lUN9jbf/3XsV48+zptozyTg/DP/NSvUNzbNeOse0I26Zk22E1je2DVB4qbBo
	 W5ayb6gNLa/cg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:35 +0100
Subject: [PATCH v4 14/15] mm/shmem: fix accounting of swapin-error markers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-14-392fc715d8f6@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4524; i=david@kernel.org;
 h=from:subject:message-id; bh=wKlzTfzpZMnScXA1kPIqFAuac+52qIb/BdE1mQIaJKQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4f/Vmc9s+2FzUwhPRZTuULuxIAQre6vNZ33l56dv
 J5l4QexjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbyXJqR4XvIt/+ZATE/o/uW
 /RVv68q787LjXP/PY2dzj/K2ix1c2M3I0ODUIm08qyrlI5eqRXaO1Fyjsofvby9R9sjyfDEh7cg
 JXgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: ymtf47w9i4x1srk3j96yybg5utzck4dj
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3915E20003
X-Rspam-User: 
X-HE-Tag: 1793270754-658096
X-HE-Meta: U2FsdGVkX1++3D4MROsACcLT9+MZTapqg9BmhCY76mQ8TSzROxGMrsjoStLUejekChvKZLGtP9+DattxCIOplHARzJyxhQb7HqVC1yoACyBcFgnawHhL6dbC5KWFLFgGT6uUq0GBlzDN0rd2zJn6sqM/ftnTHSHK/IykXORg9JKrfg/voyIiM6UguAnVUR80lw6Q8Xp/FZaAyTp2WyKH1l9ajMTJoetZkNDk4UqAC1Hj0z/wz83p+TXksYz4E1rkXnrKt3R9QFgbIynBliVWqogtPsP/ODwq8R55bahr9neLuWBb/4uVtg7PgpKSMzryjTN47SuHK/LXxx8YZGrJrHZQHkK9+Bcf3wgfrn1b9I6ieMRkty41InDDZd50E0YsNv2xzOZ9wnEQoDIJwo6V9DDpObxEhFslMq4QYP2nm/3Ihav0K9Bwk259Y9AZRq2AVx4vt1TRNDMgbZ++oi28DYU3LzNaHeEign5aq5YcW/6dyhcCZsX2HhVdn8ojPm5hjgbG/dYTd+gFNFT4HtyOLLn63stICPyb36jRlHoMz/g6hAXLD6fp8EuU+T+sXo3+uWjgR9Oy+YhxIQymEOg+UJxMI29ZlDGVn4Vtw5By8Esnhbf227dPBJY+5hpGkCCcF5CyHLLlOYFKCX/BV+aAgKn9qYuoE8KUAjHoojurZemgq8m8Ps9ISmCSGcXv3ELU5jBGlQsY9KtxcGoR+VWRIJe1uMMvtL3hTn9MXA9YO/JaTUU3aSiB5dznN5M16X1NxpHlfsdko1DDcdBdk2wAZ7jhB4h8Gg2U4kaNB61aSnxsz3B7w4Xncl9SUrNx96mj+xAbRvzz+UnfuEJFO/9j7FY1cL9LGENkBh4aTBy43fnTuQur2q+Wwpy/hwhZvCYZBsrJ/b1GcUu+KD9WiV3afjXNW0STpNMQ1gZekwq+4GEpIIAAdX+HWcaoVKxCRXKG/1lw+WKvGWbRCEZJjSC
 mw22HwDa
 erqtDFsAjLWnnRuVPIxJ/OIVdd/ZquQswl2qvQ3l6hqmRM4ThITABkSrJK9WVkdBaa3AsTW8hp9aUHqeTkZK2V8RAhR8zf/3Zqaj0q3UVRGlsvtlY295GjWTKvW/QTvYKyROYE29i9IHTAmhvUCOq0zsobIVRL0iab02RnvUJFecytWDzXeq2QGED1DYS7ljsvmPBix0CbfruAv9FHQm6zZmL3nF9u5FZgyiv5dc/LjqnNig64hjsu+M/+5WlXUpwrc7En6+TT/1ueAIIQO81eb7P8Q7t3fIQCjKO4TVZhMKyHKcJlOt5/1qAcopVyve+/viqxz4bH2q+GOmGi3btg7tVOAASE5WinkDIoQY2z10ee0whhn6Ay7PhtE7s5SxEq175mXD/jH8P8H9jN7UB2nfVbA==
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
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index eb2e6e50630c..897f19ed0fe3 100644
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
 
@@ -1422,13 +1423,11 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 
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
@@ -1449,7 +1448,6 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 					index = base;
 					break;
 				}
-				nr_swaps_freed += swaps_freed;
 				continue;
 			}
 
@@ -2409,11 +2407,10 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
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


