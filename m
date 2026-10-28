Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9CE606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oTbgfszp
Received: by kanga.kvack.org (Postfix)
	id E63B86B05D2; Wed, 28 Oct 2026 05:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3B426B05D3; Wed, 28 Oct 2026 05:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78756B05D4; Wed, 28 Oct 2026 05:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAF0C6B05D2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:57:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 996CD80BD1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:57:13 +0000 (UTC)
X-FDA: 85371581946.06.DC982F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D8740140002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:57:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oTbgfszp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8v9MIEOd3AnLceYk8FQlKtEZ1PFUaFhFBv8xZI6BIQ=;
	b=4MtvtCJ9RInSGWlE9ZWurVd3BssvZsJHT2Q/yRjO9DcKKIEgPNemUnWBq5kGtiZYqhmueb
	KQaEagOvMaLlox4qhRCZb5l1kWbT4MAP8u71jixuHTSIgr39GYkON1izWKEH7u85S/wF2g
	7wjktnC9Zry27zNtBCVPn4kKtmla9eg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oTbgfszp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181431;
	b=RoouUG26q2IfHJh9GoReMTxb1esd7Jyzs+MN6+E1VYvLjru7vPZqxH8sltmKLIeEmiolYA
	0wYrmXZNnp61DvtVunSXB/+/nm2Zagc9Qv/w2a8r2jUKTJsYvynVQYrOuBzAK8W07ibp51
	6vThq1vKfhB+bzU3Z3bTfzjlawMfmeM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 533716022E;
	Wed, 28 Oct 2026 09:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF851F01829;
	Wed, 28 Oct 2026 09:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181431;
	bh=u8v9MIEOd3AnLceYk8FQlKtEZ1PFUaFhFBv8xZI6BIQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oTbgfszppvM36lsf8lUjCiMv1vsa70dGrRu8OM7bDYQ6wcCUzbal4gTUW83Am4Rql
	 bGXR2SdcuBjnhG4/z8cjriW/svQpXLJH3Zik5y0yyjXGH2j6jhE2MsS22JBS3BvE57
	 svpE4qka0BdvgfliwIkhdvWrSHAdy1Z8mBNIMpTAL8Co/nHh2BflN+SKGAO5hcJU7e
	 FbsWFNTfzBA8ar+11+ZnO8ZM4vApyaRL8JQhiaurUgiVYN2wAUKHYvyVLTArAjstEF
	 luY/fud/PGPk8yfhcqkn0OOsgUaPfUmcpT9tqmwdvFBNkpGHlp3jUuWQbNk0EomX8Q
	 6KbvBvcooJ7fg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:12 +0100
Subject: [PATCH v3 14/15] mm/shmem: fix accounting of swapin-error markers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-14-4ce3baf2db4b@kernel.org>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
In-Reply-To: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
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
 h=from:subject:message-id; bh=vZEz5P/rE8xLS5ut4sSBd9imyLTo+szC/Mtl6/SGSUc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmv+VDTntNSp/d84t1fc7lzZyJ+sXKuxscqn88KhZ
 7Vyxf2eHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEyk5DLDP00r01mxTBZ1627q
 zNTdNz28Sjq31s7Gfd1mJhPrwHjuQwx/pdcvyr5aLeHlu/VbzMT/9YqPEv+lSOWIGqksvHbJWYu
 bGwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D8740140002
X-Stat-Signature: 5foa9xfjj1cgatobihz78ougbcop5et7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793181431-3095
X-HE-Meta: U2FsdGVkX1/rNzmCmLp1+/a8cBam2G04MN0dMGGk0kppQpQUYgSvXkQDT/v+mCcICceBm8lipviYemmqrojKka/a2J+c02o1IWWkSMzUFjAnw3eVQSSICdHrR3z4lwBD1FiCpWTSUMNLrSTfFwywbcOWen3GQLDfEfK7sru5vS3/hMwmFpy45cK+BqdSuwxVwRscIlW+taUrYeJ65SfKXdQbKqJt4OmgjUHvHNsP/NsqoBlEdGz5LwDh5yfH5yfOuHvccH5hRfpAUrs0hpWRHR8dkv1SXsJQF6v+Bo1wwVRADgT3zonnDxQmVrwBsXBEQW+yb+JKah6KXYn37o1isQfm6TviYlnt+jOkai5Xt9zYyyXDcMvFbvcI9G9qRr9nClMJV6MzsOb0N9sLP595CrKLc7HYvkNKdUzjj4eGwQVVBEaXO3IB8i40fjUSuQZfZ4kAcockcJbE3kyRuA3c7AlCqDchPEtXTdXpJbhFpMvvIvSyoMg+frdE64K2Z6SWr3X4tL2dzpjhkRpGeIUAtvv2s3WLIkju4gZDtUkUdrUI/vHAVLd9GAyD0gV5P40TeEcQBv92y7VC0W4j2J7oMSYTjP4EDzR/ZwuwJnh6yNK6HbghhmzroJE5s7SeKRwVRwRetuKTcgsoHomHhXqwX6gSEtmdkPpXVPCzr0+W1uwZ2GMmzKyDIMtTTHsM4gteWgYNgCgzo4yMCzAVs/jsmXHs+zWucGIb8hyT3+HxmmuOTNBKjb3pZq6nY/VFpgd+HT5OmAJAuyLDPxkB1gRqbzubMRW02KAQbU2euKmG89EBcvH6eUIJQM8auIh7dpNqNKgAe9oeBae/4s0SNUfNfXAmcNFxZhDJSYiKU37Lm4MaAk/ckkSppablVbTbH8TrfJSRg+Ff66NCbzulETb1UhNpwbm5YFhz7XI/zBrfRiEaYlGSrjsFkiAipy1EiqUUunaobeDKVt+N2H9klj2
 eBkNdpRS
 5ZrxnfzuT7f4u5tAoXftZFSGlWPSfhk7e7f2BTD2lEMt4dsAkVueQRVJB0wnvo+uFZJAebdd8lsbHRQaQAlcXqcg51GapPCZCtmMNs+ZkJ3uVOuBmOU2qGqcZBIbb+cpnPuo0QksIr9wMV6yM2azYmmvSzJRviQYZ9MqdPhFM6OprBlQA03nFgtCZun3OX2l/MQCbDZBrnizYPQ6t+o9kntPT9eh9zrGOcxjf4aHunG2LhQgVJf6bxg5Qb8wEQh+5nKxMyYri4shpr88IJrAkx6TtH74+yQ1ram7GWvn2cKjATbxTBr3Bn3A1y29Do1SxI6FOAmHp3/kaVdyen/MNssxMYnOpYu5TvLNpeYjBvujTfnIrT9qxaDR8vYxOuEWcqiB887zCljSPZcnWq/S/WTQL9A==
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
index 63f7fccf2ff5..11c3ac313c55 100644
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


