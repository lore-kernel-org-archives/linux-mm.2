Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7152D606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H+LOYwYD
Received: by kanga.kvack.org (Postfix)
	id 932A26B05C6; Wed, 28 Oct 2026 05:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909556B05C7; Wed, 28 Oct 2026 05:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FD76B05C8; Wed, 28 Oct 2026 05:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6163E6B05C6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:56:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D32E160C20
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:13 +0000 (UTC)
X-FDA: 85371579426.12.29CFA4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9313520008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+LOYwYD;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9j3nRPXAYyZeyCseSaJF4UAcNQcHHRM87quWK0Zl5E=;
	b=7MaKrHzC59PP6hlRS2HxCcZ4V3CGjRTTj+me8Q5SKwpM2yKxDUvDXsVpZ5vXva0Jfz8fc+
	IKSHYwDFgEIx4FzNOS7SYmSUFqQequKG1Tp6qqHzhRz2y//ya+Zusb6u4NGaD4qI+hWttP
	1voPrNbO3/QygHO7kFGaRhWbkShqs/8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181371;
	b=yLs+y66ij6WDmwZYcWWce4WzckoPOm7Qx0JRxwucWm/ezdLQ1DpxSerEglxFqio9vdbbl5
	QkjKifDtbqvqKj57ZWNgvu8ibjOT5E/0upODjsSImNoS64uYJdNBkcVQL715KDXRSFZ6az
	UY75l+9S4wgmaoTevl45NVC0bitvzCk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+LOYwYD;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6CAB43EF2;
	Wed, 28 Oct 2026 09:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626B31F01825;
	Wed, 28 Oct 2026 09:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181370;
	bh=p9j3nRPXAYyZeyCseSaJF4UAcNQcHHRM87quWK0Zl5E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=H+LOYwYD68mgaDcU1XuGGCbEvC2jziJLo6mDaI2/lqJvoI/K7k5xh2HaET6OQf8UJ
	 zuxOtfH5V9+r+h9zC3gYL7+kTwjYLfQD9BGwQwx3TmfJsKi/bJnSW64SM90w8SZR8w
	 8GPG+BszKgBo+IflOgBS6ox0Phsd6d6nlffU4kPstFuSlORrvYwuO27TSvVEv3FZk/
	 5yB7i4KEBaMKPoE67Xxu62sMmlm6JTmQT4wexklFTg3UlQMNacEQDIc3ZYM/NYTEFq
	 7LTOEobWWyDMtFWiDeh9+lihoT3/dSjTJNyc8iFKF64LedHq/xibuWHSBLSyCuwNHV
	 trUixsDor0PeQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:04 +0100
Subject: [PATCH v3 06/15] mm/shmem: hold off eviction in shmem_writeout()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-6-4ce3baf2db4b@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5605; i=david@kernel.org;
 h=from:subject:message-id; bh=zzh9IGJps/yyCZLRquCkr7f7izRh7fedg/TKI2tiALY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHms845jhvnFy8V6DTPGX1RO2hW8tWhko8cwpdub3Z
 AmxN/vaO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZhIoTsjw3Qn9oXHThR7TVh4
 Yc36/Edt7T0zEncs4Y6crvuwnu9LiRcjw9tDDofr3xXr2CtxbrVbMp9tVkZxXeXMa1eETpRu1Qy
 TYwAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9313520008
X-Stat-Signature: iu8p1wpdwackf3t3ukg9ctpedk6w66iz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793181371-665016
X-HE-Meta: U2FsdGVkX1/WNE1u83J8U0Cyb/7kohM9OBMCrlxVUuvytBGo2vQiOtnprqVx7Biqc9aEbqu0LFJZux+x3FD0NZXMvLnVlfOanLJhHMs5uK4bqXN2BZkYlaPEui7jNrDQm5ju/0VqoTdq5st6FoxBn615JD+h2Mif+XWxUccvib684Ds7hyao2mGPczsi1UrHXrNoeWwR/AZ8SJaHfhN+2oJaw/E2niiw14OARb1J31ZvlHp2kFTfYcRcnb10JEcoq3fHka6WVpGiqt2GImIX1xD1hzR63GvyYheg7LkC0K2zZhaYCBN17MCtv1+fLI9UWT3A2ljyukM6yLprxOlHHLnSBJCL/gDuPnD/IwAiIrLedge8l9pnE5wof72ir2GUmVTCn+MMSBpvI2vPCE9E2/bE+Cn3r8qGQQe3RFSxuHsLe9gqT2cb8I1epwKf3SIqZydFZ82mmpOK+1FpbveLiqsV4Opxtz4eZhlf2+XHS+85IrE8Y1jtUgNR4DhMHPuUBP6W6R9Me+Ihg4MCXX1PG7qRsLurNJ1kjY8ywe419bbLx8m5yca6Kg73C4xvTzz2pFYpe+9/p26xnsaVWZU48jk0ZBM6yeZRAkYT2jAeFctwI+cEJwFSoWl8NGxmEGa93yo2v1bKy8Lhw5UM6hDwPOZ53/7VneCfr7uYM/MZhZgTfIKeI8mbUGH3RZ8vmtlkPCJmhQqtxQVd/5hV/S7+iRCsU7v+fVSmMtX8EY8xPARybm+yP0CEpsG0duDOqjFAiHcZcrHrRDTisbyLh+CSRazGlrdr7jn36s73hrDls3GgwC2USKSd/pCLB2ClnxfsRi/SfKYvF9Dwak0ICBhPX9f/er3qpXzA8LilceYMUBpQ020IxirLcomiL1DGiGKd1FCejrpHZ93xtaiY7cxbIvil0Pg/18kNrSjvcRY1bK0tju9ZqSw+8ozDzHc0UhMlNy93vYFohtY9Vs1yNZf
 1unNpPei
 MI3+2kr8zJFOZz/WxslzQebP3yPxpOzw72cMexSbzC1eQ/8I7sixotG1BThMDyRV9V3pT/3e/Yl8K08k1nDSkH0qh7UJtbcRD35O60VBpgjYkkGMLCsBori+0L+jQIJB2yL1guXu/Vvbna2ivY7rIyfOSm80WJYgo+Obm5JnfHHtUCq4Zziw4PYGhsZ+xft6MRKZQbiH0fE8xBKEOJ+y5dS17zevI9MIB8Fxr9mstq+f69aMnxHmGLsgoMVuUjnNL1oLCT830Yu8OTt0LGZL0j2+R9K2/Zl2Rx5ROAKkIACKZO4cV/jTMGxNG8Ffi3aaucIGftqiORvSvUGVQ2NSkPXi7b9GxYXowjyG6IXyDAkD/3RuD2CD0kJfn4CuRiTsp6VxL03zEDLOW+tVvkAwnOEM+ZYprtJMDz1M8frX/bdFsMdjcKS1ju7xheupMRv4uvst4zyFJKo6ycWYfGSZpF4YrcKDI9F6nblnJOs7X5LygQkYViEIbvIqSFJl2Yh0Yex42Hg+uiGicHhz9nqbqXjfYvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

Once shmem_writeout() has moved the folio from the page cache to the
swap cache, the folio lock no longer keeps the inode alive: truncation
and eviction find a swap entry, free it and do not wait for anybody.
That did not matter as long as swap_writeout() was the last thing the
function did.  But since it puts the folio back when swap_writeout()
returns AOP_WRITEPAGE_ACTIVATE, it uses the mapping and the inode
afterwards:

  reclaim                               last close of an unlinked file
  shmem_writeout()
    shmem_delete_from_page_cache()
    swap_writeout()
      zswap_store() fails               shmem_evict_inode()
      writeback is disabled               shmem_truncate_range()
      return AOP_WRITEPAGE_ACTIVATE         shmem_free_swap()
                                        destroy_inode()
                                        ... RCU grace period, freed
    shmem_add_to_page_cache(mapping)
      xas_lock_irq()            <- use after free

swap_writeout() behaves that way if zswap is enabled, cannot take the
folio and the memcg or one of its ancestors has memory.zswap.writeback
set to 0.

shmem_unuse() already added infrastructure to deal with that.
Reuse info->stop_eviction to protect the inode during writeout. Increment
it before removing the folio from the page cache, and decrement it after
swap_writeout() and any attempted reinsertion and inode accounting.
In shmem_evict_inode(), wait for the counter to reach zero even if
swapoff has already removed the inode from the swap list. Add some helpers
to make the code easier to digest.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 6344a6d9ce13 ("mm/shmem: writeout free swap if swap_writeout() reactivates")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
[ david: code cleanups; improve description ]
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e3e4bbbe1d80..eddd5870be07 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1616,6 +1616,17 @@ static int shmem_setattr(const struct mnt_idmap *idmap,
 	return error;
 }
 
+static void shmem_disallow_eviction(struct shmem_inode_info *info)
+{
+	atomic_inc(&info->stop_eviction);
+}
+
+static void shmem_allow_eviction(struct shmem_inode_info *info)
+{
+	if (atomic_dec_and_test(&info->stop_eviction))
+		wake_up_var(&info->stop_eviction);
+}
+
 static void shmem_evict_inode(struct inode *inode)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -1628,16 +1639,21 @@ static void shmem_evict_inode(struct inode *inode)
 		mapping_set_exiting(inode->i_mapping);
 		shmem_truncate_range(inode, 0, (loff_t)-1);
 		shmem_unused_huge_del(inode);
-		while (!list_empty(&info->swaplist)) {
-			/* Wait while shmem_unuse() is scanning this inode... */
+		/*
+		 * Writeout may still use the inode after swapoff has removed it
+		 * from the swaplist, so always wait at least once.
+		 */
+		do {
 			wait_var_event(&info->stop_eviction,
 				       !atomic_read(&info->stop_eviction));
+			if (list_empty(&info->swaplist))
+				break;
 			spin_lock(&shmem_swaplist_lock);
 			/* ...but beware of the race if we peeked too early */
 			if (!atomic_read(&info->stop_eviction))
 				list_del_init(&info->swaplist);
 			spin_unlock(&shmem_swaplist_lock);
-		}
+		} while (!list_empty(&info->swaplist));
 	}
 
 	simple_xattrs_free(&sbinfo->xa_cache, &info->xattrs, sbinfo->max_inodes ? &freed : NULL);
@@ -1776,15 +1792,14 @@ int shmem_unuse(unsigned int type)
 		 * remove placeholder inode from swaplist, nor let it be freed
 		 * (igrab() would protect from unlink, but not from unmount).
 		 */
-		atomic_inc(&info->stop_eviction);
+		shmem_disallow_eviction(info);
 		spin_unlock(&shmem_swaplist_lock);
 
 		error = shmem_unuse_inode(&info->vfs_inode, type);
 		cond_resched();
 
 		spin_lock(&shmem_swaplist_lock);
-		if (atomic_dec_and_test(&info->stop_eviction))
-			wake_up_var(&info->stop_eviction);
+		shmem_allow_eviction(info);
 		if (error)
 			break;
 		if (list_empty(&info->swaplist))
@@ -1915,6 +1930,13 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
+		/*
+		 * Once the folio has left the page cache, its lock no longer
+		 * keeps the inode from being evicted and freed: hold eviction
+		 * off, in case the folio has to be put back below.
+		 */
+		shmem_disallow_eviction(info);
+
 		folio_dup_swap(folio, NULL);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
@@ -1922,6 +1944,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		error = swap_writeout(ctx, folio);
 		if (error != AOP_WRITEPAGE_ACTIVATE) {
 			/* folio has been unlocked */
+			shmem_allow_eviction(info);
 			return error;
 		}
 
@@ -1938,6 +1961,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			shmem_recalc_inode(inode, 0, -nr_pages);
 			folio_put_swap(folio, NULL);
 		}
+		shmem_allow_eviction(info);
 
 		/*
 		 * The swap_cache_del_folio() below could be left for

-- 
2.43.0


