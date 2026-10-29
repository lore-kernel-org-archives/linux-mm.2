Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7C5606A320
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jRBTHA0Y
Received: by kanga.kvack.org (Postfix)
	id 65AA56B05BF; Thu, 29 Oct 2026 06:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6329F6B05C0; Thu, 29 Oct 2026 06:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520676B05C1; Thu, 29 Oct 2026 06:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC8B6B05BF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:44:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6CB114034E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:46 +0000 (UTC)
X-FDA: 85375330572.05.A7B9EE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E286640009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRBTHA0Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogc5g2DbOVRsIRSN2sEJBqCeAyv1h3vNItmdoJK+73w=;
	b=DLtbvxr8i4it27G592tFLsRg0SH6lWNhQOV/pyRpIY6XOuVr1rgvG5WWYKWAKICiTg48xh
	MYA3d4b8BRvM+mbuBwqibqJ/sxRxQ/KPvm3rgDrXvIy84LdGDVcfle9QrfnF7hJrHoV6cI
	Yfv/joCGE7/CzivOfKMiouD40V7ujWQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRBTHA0Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270685;
	b=XwhG9o7hMmyhkMTygviIslcFwxQw/WPrxyzE9MP7kp9OsI1B4LeaA2TniNb9halmjxJfW+
	+zAEBVLdTVBvjCuO+0ETufp1WC7TzeyfgLmcHs7U57bgoQIZ8XncqbrwX/cwzurLDdtGCC
	t38JmQOC6L31z1BPceF+4qFCmqhZ/Ic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 396F84177F;
	Thu, 29 Oct 2026 10:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD371F01828;
	Thu, 29 Oct 2026 10:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270684;
	bh=ogc5g2DbOVRsIRSN2sEJBqCeAyv1h3vNItmdoJK+73w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jRBTHA0Ydgyd5HdUnj9mVTbUSXB8/j72t0rcA89afuwVEbsgCfE/IdoPE3pE5erzB
	 VnEUXsXeiZOoZ0iuRM6QSO6LkX857TE0pCpeDO86NOq4eLe0Hs0jTgYPU50c1iZDKe
	 1FUMtMQNM8t4JJwaM0jU1Lxx15mzmE7g70MWfWb3hwHGSncxAM9vrvou9FssSbIucr
	 6ZDtpoSiAgwD29LL74aKYc1dBM4p644tbEGm93Vu98QA2RuOCh5lv7vpUqvSl73FD/
	 pkXiTFJWmnQCdGGweTpN6d6VlBg55HNa/bjBaKRbp2KGSUxNH3Jprf00RTbUFa9NlU
	 Kdy6T5KY3KWkA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:27 +0100
Subject: [PATCH v4 06/15] mm/shmem: hold off eviction in shmem_writeout()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-6-392fc715d8f6@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5771; i=david@kernel.org;
 h=from:subject:message-id; bh=rlVfOwdBZ9cOTWL2PYhkeURitXGy+X/4r5BveDLAWvc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4c1Fdi7yEyfybBXImfdmZBZMv222tcrNyb8PJy97
 LeKdJZCRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABOZHs7IMMFRxWKLzbN170/W
 aO/bU2Uo+1e1JUZr851f294d6XmetpHhv0d/8j6Zt9M59ebMNwhg5KhWZZhoPU0jdLd1YpupvM9
 lLgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E286640009
X-Stat-Signature: ap8453r7paiign7gke75dtsab6usf317
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793270684-85996
X-HE-Meta: U2FsdGVkX18EMbqhK9NEVgbZMQn3Sg+jwCxMtE++J5sZIuXztEoyn6fRSEjVu8iS53iKwGEa4NcpQr532wQeBbRuQuS4ZQ59BrTgBz2Pzu0BOZV4wGtmu3+8kKdWdnsE3vwmiqI6/7+7VNsTdGzA3DuYkk5Eq49xpbPwDEJdQu+9viGSOiTQIgfD2Gg4QiYQmsS+6fHnzn1/WuVhhy9NoMTuz8rAsqpbn+2j2mpmfc/KAm8p17xN6PllsD5IVUcYPsuPfXPfEheAxLqvhHo8j2uz2Bu/IwEX08+frPgpwaHW4a74cXh/PfqRHrYIXSwJRhJlI56Sv8TaFZlYKICZyXnV4n8/FdQtSEiPoXpaZlkYQEyUfephEQZza7i4v5PTHPh66rC78SbWsf9fy8cAzAGy/Hh9s/vff7Q8TgqgCavqcuJt/QVs5uXmtDKjc9hg7Xy9jm+73xL4HDUmxpOay7gYzZefBC01uhPALyiuJjCc+rNH/i/jKvMnFwPwegCGrKZUjszlFbrDIQaG5jNmqsIU7Y8OKBd/ydt3VNrohPoSqTo3+7D85CiPo9L6rrIG0xFGHdG0xAO2O0JlQzqdkGCafP2VPfbMpMEHYAGBXBF89bOdAU2Y8Bnr2BS5dvRZM0CvTghNNyH9C6g9tzRu+T3BbbVwxuYWooqEOWO6bl6hcT/eji4ko8RH7mA6XRVvLu7sz3LgUhrTRkurUwgns3YJOECp7DYcp+R9IXo2FDl4fWkGkLiFp/oQU8qMAc2Y0o9fOPWKECQF1CkOlYZNj5QTCQ1m5kfyYkTVRwYYr9vaSRYePCKcUeSL7kZIsVGsHcdqOH7myOO9JC8pnBm7fzRQ5dnCcY9BbZpltQoBlKGjUQbNQ3X8ZcBnqKdwBHRRjOIVEkNnUbbMUE/3A8WfbfyULsxZpPL0buJK2ocHCLOdr6pQxmuvisEc3EsaX8aIxVwNEL2c8wHjsyrbwrG
 CmfcAu/Z
 8W2VPheICKWnBR+kvJeksb4ClL7egZP6HEe9L10on+vbZeYUJl7Xd8BLbhIUP40itQ0bHJyhnATcsnpBAXVnyp2XEh9fNfIqtGw5GUkBn8Kk4dW1bShWIZVZVAe/Ar4zCxo5qAF18+LRf7J+SP0YOQjZUOxMy43gNBr/KV2SsPjMrj8dOQ4t/zkEWYPApPx2AC5pnzsJ3lc6JiTasyrb7wnf9fCfqU4zDZy3kOaklEbnzNF3V+ZGZMfAW5LbaKCZDVtWkLsuqMCrn22GlH3Q2DQx7Yctgm95to37xr4sFghVS+E71dVv+6o6Ywnw30aXEG070a9yXv/LrnBWYqn0a1mPXgeWe6CZ68pkl+ym2UUlGQ3i8gGlnHgBb/vQkDzi7LpL8Ke2b4UknvvdBTQ+NPMaMNe4zA8EMWBf8pGD7UbADCNvFfoobXHMgt7o5dDg5Pwsa8VsZyBF1ArgL6EBgKcJ12zztTAIKcQyHhJzbGF4Dfjwx78GeCp43sF0oc3a9g+dG13YgDk+D6/mNCn8V/pvvLg==
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

There is a known remaining issue with two swapoffs racing, and the empty
list check not being able to detect that race. That will be addressed
separately later.

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
index 6df0237832c0..c44d2dd71c89 100644
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


