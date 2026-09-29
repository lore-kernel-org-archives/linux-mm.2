Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D199FCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEEDC6B00C7; Tue, 29 Sep 2026 04:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9EDA6B00C8; Tue, 29 Sep 2026 04:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40726B00C9; Tue, 29 Sep 2026 04:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 919796B00C7
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:02:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FC51A0431
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:02:07 +0000 (UTC)
X-FDA: 85266056694.03.754302E
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4CA7780009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:02:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=QYy5HBab;
	spf=pass (imf02.hostedemail.com: domain of leizongkun@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=leizongkun@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJRpKPhpV1OOSdwe9cyXP2twLeNJ0BTNjXqinmOMxO4=;
	b=ydj0Pq/1xrXWNFwI3x/Dl8BI+V1xnbdy6OIcN0eCj+COWBMpfBWXM6bey1SfNkht2WUSPu
	r7fGVdRtYN7+M5XLYwQujWD52G4sp7tUzRkOOrgt8fORUTJg10wGb66xQvCEqWO00xNM8H
	/YKY2vpEFUHtobry+B7yl6yOQvvm1Ls=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=QYy5HBab;
	spf=pass (imf02.hostedemail.com: domain of leizongkun@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=leizongkun@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668925;
	b=NaZAtkKj4Yx83IWWjrFDjRRRg3DDd7GIYav/YJQPXDm4oUZ5FhYG9rsxBxbl+db5/3cmgl
	nPxp68LKOxuUrFgoL609hLuV5MOwTvwxoypubjPjO2hVeT2Y968WTJ+y8UVnaxuZh4XUTN
	yFsIOvRE8Dq1ohhv/UStkuYhZ0BYcEM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790668899; bh=vJRpKPhpV1OOSdwe9cyXP2twLeNJ0BTNjXqinmOMxO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYy5HBaboqdz+4hktc51muYTCMNlxhoirS4L77rfSzNZGTfa6hztGIAdC7nwMVaEB
	 Spw8sIdnzueQx8cz91nRe0a8F/lgK+l28wB6yRruU7DzP+j9MpEH4p1w9+2JsAqdUz
	 XqKPCvW1sjRqisige9bG13ly+PpUMmz1DnPNrEto=
Received: from lzk-B860M-AORUS-PRO-WIFI7 ([2409:8a28:a83:5ba1:514f:5353:e14b:594e])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 612C849; Tue, 29 Sep 2026 16:01:33 +0800
X-QQ-mid: xmsmtpt1790668893tnhwz9esy
Message-ID: <tencent_56BBB21A463DE962EBD364FAC3A9D45E6205@qq.com>
X-QQ-XMAILINFO: OAVUgo6XLCCR4tBa+qmjHYkKRyRae2pJk9FYANyxbCl2fXPb9AMqjMVCNquX6n
	 WoR/NhpPe99L/7qIQwGOEl6OjtvJfQ/fRbM83Wfr+BkJnT+va4CZA2sVGGfVGXrah/wByVhELbqf
	 g91IxEN8zfty4c7xYBHTs7pOyWacO46C8K/cCMLtM+v33QbO3gnA30oSc7CBgJew8hhBTrrZFt7o
	 2c5kccErVQv4w7aToNfRqmxvVVS1sO9i30G6LnUgUqoEScQQRdwgvo3oJIOXjZjSnLnqui2a9llE
	 1bRHAJfk+76A3neA0Na9a8t7JRJr4bB28vfZUxG+xKP7M8ApFcYbQwSQ3sL11I4l0YzFYxlZrLe1
	 Vgwcaa9trOB9Ywg1kUIG8O/yPDApfUiFERFfuX8DtogqLqzuXNuKHoYjlOS6haXdwlqYqMLS01B8
	 /Z7/eSIb2TNC9yTddXvZu+zgNTFYY0gV8XQvFEj0TsM6TE7yt7NEeXh0VBf/AVHugDSxxZeEKoS+
	 vwHIKx2H/ycAKVDNYaM53lEmkmDH7sshJr32TN02lie7adjsCa2b6zEAAxIqOYkKAe0cTemf56/t
	 8EuIJm1z6kk0Ro2yR8Ek/UbpPbGx5S6lBsjZkyEdQ8WOrzNeJRjWefDsuWtkFqp2JeTpxs0XDcpZ
	 OTq2JiD3z32tIjstH0mNJFTTH2xhy7EKNCTaXh66J14Deq0Q4tyboulWKkvVoOhOt3lCZiJmvnWu
	 hp4mOWM3WwreTr4tNmhblvczsxVVnFLWdqy9VJCoKEwtAUeSdzMnfbmft7rMdsmIEVgmPFzJyBCf
	 Lphl13rHhzF91iEyIQMK3E3F9e3qVemxDhVaJoqMsK0sEoA0KH9VYGU3aYAVyYWDnQgPEInp/kHT
	 IXvOfaXFnSBg8FhSGJqambcFadlc/YABLuyBtp0Gg/Dmf29d+WZIHa21+Zc+WCHP9T6i8PTNwGbY
	 CK551jal2k9uRKLy7awSsHiOY/iKwHHCwvmO88OBczyqKet9lchj2AP+R+oGYTWrWdnDZcjywXzg
	 deNL2eLBVaNNb7Od2W6R7Om1aCw6sdM/7Rj7A0otJFnSbbw5BHLTxS6gYYdzAxJ4L5Izyw2M4pq2
	 BOAfLyPRkxjHFbVKaiJ8yco/eJWFyfXB+JVN4HD6A+LujN6spGygkmnHZb6rfWbLSPBTLK22RfVE
	 a81GVqBWFijSr6cA==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: Zongkun Lei <leizongkun@qq.com>
To: linux-mm@kvack.org
Cc: Zongkun Lei <leizongkun@qq.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 5/6] mm/hugetlb: swap support for file-backed hugetlb folios
Date: Tue, 29 Sep 2026 16:01:29 +0800
X-OQ-MSGID: <77da9b052b7fc81c0819008569188cdaf78a35fb.1790663399.git.leizongkun@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790663399.git.leizongkun@qq.com>
References: <cover.1790663399.git.leizongkun@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4CA7780009
X-Stat-Signature: e1oh4ci9eipc1xutaydufoenqnqxg6f8
X-Rspam-User: 
X-HE-Tag: 1790668923-576297
X-HE-Meta: U2FsdGVkX1+TVvlw4ByVchU3+U0dx8Im5Epi8yb8VvxzqihzkVHDJPjNYuzI9AO0I/CavN757qCZt8NPqEttGrbIASj388elyIqol5+9RIg69MWdOV1VrahEk9JQsk2UA7WMu34NEl2twv3DKQUr2Sj8AbZIyAbhSmDWTR1K0ukQU3GnvIm4YdATUFKw046Tr6gq+vRhcneqIjS07io9IwGDtSAcmODdr+ite+Yg0EoM7rgXjihwgNzuXom2uRWNUY6/XpbX/nPgb8NHwrOAtD54kT9bWP+itCQYbtxkeABk+63RJNAP8x88CnD4grhxPmjtP5Lu46thpTzFzbI82aT2LY7+QFVqSfMynzkhO6UNEZmnPcRY6t8Ob9OBOD4ASxt1NHJy4YVWvTPftaiDQjS8gEAiCfueMJoGZ3qgjKi45glWSCGnPZa5/Iee6gPKDZGVKPIV3QtUu7XoLE8tpali1GNQqUUkIxFg8+p8Xepd1TopCJyd0V4849kF8eSRTmAfun9ptc+EWpg4W+tfRPhm31ViaJW5dSRU2BE8Vzt1iJmVL49HaW/ChF7In6RnUY2ErB/dh8ggl15YxcmSg/0iptcWXuoo4W5R4iQu4QJggYpjkrkDcVniyHWMmI/6cSJn6YwegN8H29mV2Cf+YXdMO0DO3t46kvRmFUgQ0e1mxqaVVRuAdOz0WTUDZw6VezrPVjzT707W4+ZDK7noBkPItvLX+MeWbM0xdGbpNtimg8jGN63Ykuj8+JT3lCzkEuMszcspVaB9L480mhzTFuYCQcFo0cG8AwwE/vuxINq4z9PbM4oJncA+yxlFDznzxcWk+FIms62+sgS1hc0LijDScauzfEvHd4R2UCCStI5diuKc9ef0u2Lp7N6Ybb0d5t9vfDz1bnNQ/hZFtekBPzBdwSCzLXmgodTNMPEyMye1Ug67WH18aHb7lQDJD76VU4E72hsSrFGuehk/Tjo
 28+t7cny
 Ie3FFRt+EBo1yDr9ypcCYGQsMNpwwsXZAD9s85haUfA1S18pmdOnXC9WRpUxkQhhlmGrcKmazGXMA1+hOOkTpstLu09gyY8ozErjPll99kM0L/+k+s3qc3bvSypeKHooSy6RVhVyFcaObzT9Uw0kmTzRifBpfDifzZx842RNa/GZzk4xmdImgACb+UzIzo7X1gkYchmY5FfPR5r9zSp8eyK6wad9CLcUbB2aMrKs/pQ9p2TtAHiKqcD6PBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend hugetlb swap-out to shared file-backed mappings, using the
shmem model: swap-out only clears the PTEs -- no swap entry is ever
installed for a file folio -- and the anchor (a swap value entry,
swp_to_radix_entry()) is left in the hugetlbfs page cache, holding a
swap count reference on the slots.  Without this, instantiated shared
huge pages pin the pool absolutely until truncate/unlink: QEMU guests
backed by MAP_SHARED hugetlbfs files (-mem-path) are the canonical
victim.  It also fixes an ABI asymmetry userspace can trip over:
MADV_PAGEOUT succeeds on private hugetlb and every 4K/THP mapping
including shmem, but used to fail with EINVAL on shared hugetlb.

The pieces, each mirroring its shmem counterpart:

- Swap-out: hugetlbfs_writeout() allocates the folio-sized slot range,
  links the inode on the swapoff traversal list, moves the anchor into
  the page cache in place of the folio (holding a dup'ed swap count),
  and writes out.  The reclaim loop drops its anonymous-only gate and
  MADV_PAGEOUT drops the VM_MAYSHARE rejection.

- Refault swap-in: hugetlb_no_page() recognizes the anchor (the page
  cache lookup reports it as a hole) and swaps the folio back in via
  hugetlbfs_do_swapin(), reinstalling it in place of the anchor --
  indistinguishable from a page-cache hit afterwards.  This consumer
  must never lag the producer: the base fault path treats value
  entries as holes and would silently zero-fill over swapped data.

- read(2) swap-in: hugetlbfs_read_iter() resolves anchors through
  hugetlbfs_swapin_read() instead of zero-filling; swapin failures
  surface as -EIO/-EFAULT, never stale data.

- Lifecycle: truncate/hole-punch/evict free anchors and their slots
  via hugetlbfs_free_swap(), with UAF guards (cache entry removed
  before the anchor's swap count is dropped; a concurrent reclaim
  holding the folio is waited out).  Inode eviction drains the
  swapoff traversal list.

- swapoff: try_to_unuse() calls hugetlbfs_unuse() right after
  shmem_unuse(); since file folios install no swap PTEs, the mm walk
  cannot reach their slots -- the per-inode swaplist traversal can.

Accounting stays symmetric with free_huge_folio() on every path
(hugetlb_cgroup, memcg swap/hugetlb charge, global reserve,
NR_HUGETLB); the vma-less read/swapoff swapin charges the current
context, mirroring shmem swapoff.

Signed-off-by: Zongkun Lei <leizongkun@qq.com>
---
 fs/hugetlbfs/inode.c    | 128 ++++++-
 include/linux/hugetlb.h |  20 ++
 include/linux/pagemap.h |   7 +
 mm/hugetlb.c            | 733 ++++++++++++++++++++++++++++++++++++++--
 mm/internal.h           |  19 +-
 mm/madvise.c            |  14 +-
 mm/swapfile.c           |   7 +
 7 files changed, 882 insertions(+), 46 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7611a8470ea2..70fd4a0692eb 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -250,6 +250,42 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 		/* Find the folio */
 		folio = filemap_lock_hugetlb_folio(h, mapping, index);
+		if (IS_ERR(folio)) {
+			/*
+			 * The lookup reports a swapped-out page (swap anchor
+			 * value entry) as a hole; try to swap it back in
+			 * before falling back to zero-fill.
+			 */
+			if (PTR_ERR(folio) == -ENOENT) {
+				folio = hugetlbfs_swapin_read(inode, index);
+				if (IS_ERR(folio)) {
+					int err = PTR_ERR(folio);
+
+					/* Raced with a concurrent swapin. */
+					if (err == -EAGAIN)
+						continue;
+					/*
+					 * -ENOENT is a genuine hole: fall
+					 * through and zero-fill.  Anything
+					 * else is a swapin failure that must
+					 * surface as a read error, never
+					 * stale/zeroed data.
+					 */
+					if (err != -ENOENT) {
+						/* A corrupt page or bad swap
+						 * entry reads as -EIO. */
+						if (err == -EHWPOISON ||
+						    err == -EINVAL)
+							retval = -EIO;
+						/* POSIX: only report if nothing
+						 * was copied yet. */
+						if (!retval)
+							retval = -EFAULT;
+						break;
+					}
+				}
+			}
+		}
 		if (IS_ERR(folio)) {
 			/*
 			 * We have a HOLE, zero out the user-buffer for the
@@ -494,8 +530,9 @@ hugetlb_vmdelete_list(struct address_space *mapping, pgoff_t start,
 
 /*
  * Called with hugetlb fault mutex held.
+ * Returns true if the folio was actually removed, false otherwise.
  */
-static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
+static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
 		struct address_space *mapping, struct folio *folio,
 		pgoff_t index, bool truncate_op)
 {
@@ -508,6 +545,20 @@ static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	 * lock to guarantee no concurrent migration.
 	 */
 	folio_lock(folio);
+
+	/*
+	 * Re-check the mapping under the folio lock: a concurrent
+	 * hugetlbfs_writeout() may have replaced this folio with a
+	 * swap anchor in the page cache and cleared folio->mapping
+	 * before we acquired the lock.  In that case the folio is no
+	 * longer ours to remove; the anchor will be handled when
+	 * remove_inode_hugepages() iterates the page cache again.
+	 */
+	if (unlikely(folio_mapping(folio) != mapping)) {
+		folio_unlock(folio);
+		return false;
+	}
+
 	if (unlikely(folio_mapped(folio)))
 		hugetlb_unmap_file_folio(h, mapping, folio, index);
 
@@ -527,6 +578,7 @@ static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	}
 
 	folio_unlock(folio);
+	return true;
 }
 
 /*
@@ -556,30 +608,72 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 	struct address_space *mapping = &inode->i_data;
 	const pgoff_t end = lend >> PAGE_SHIFT;
 	struct folio_batch fbatch;
+	pgoff_t indices[FOLIO_BATCH_SIZE];
 	pgoff_t next, index;
 	int i, freed = 0;
 	bool truncate_op = (lend == LLONG_MAX);
 
 	folio_batch_init(&fbatch);
 	next = lstart >> PAGE_SHIFT;
-	while (filemap_get_folios(mapping, &next, end - 1, &fbatch)) {
+	while (find_get_entries(mapping, &next, end - 1, &fbatch, indices)) {
 		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
 			struct folio *folio = fbatch.folios[i];
 			u32 hash = 0;
 
-			index = folio->index >> huge_page_order(h);
+			index = indices[i] >> huge_page_order(h);
 			hash = hugetlb_fault_mutex_hash(mapping, index);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
+			if (xa_is_value(folio)) {
+				/*
+				 * Swap anchor of a swapped-out file page.
+				 * hugetlbfs page caches carry no other
+				 * value entries.
+				 */
+				if (!hugetlbfs_free_swap(mapping, indices[i],
+							 folio, h)) {
+					/* Entry changed; rescan from here. */
+					next = indices[i];
+					mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+					break;
+				}
+
+				/*
+				 * Account anchors like folios: unreserve
+				 * per page for hole punch, count and
+				 * unreserve once at the end for truncate.
+				 */
+				if (!truncate_op) {
+					if (unlikely(hugetlb_unreserve_pages(inode,
+							    index, index + 1, 1)))
+						hugetlb_fix_reserve_counts(inode);
+				} else {
+					freed++;
+				}
+
+				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+				continue;
+			}
+
 			/*
 			 * Remove folio that was part of folio_batch.
 			 */
-			remove_inode_single_folio(h, inode, mapping, folio,
-						  index, truncate_op);
+			if (!remove_inode_single_folio(h, inode, mapping, folio,
+						       index, truncate_op)) {
+				/*
+				 * Raced with swapout: the folio was
+				 * replaced by a swap anchor.  Rescan
+				 * from this index to find it.
+				 */
+				next = indices[i];
+				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+				break;
+			}
 			freed++;
 
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
+		folio_batch_remove_exceptionals(&fbatch);
 		folio_batch_release(&fbatch);
 		cond_resched();
 	}
@@ -596,6 +690,7 @@ static void hugetlbfs_evict_inode(struct inode *inode)
 
 	trace_hugetlbfs_evict_inode(inode);
 	remove_inode_hugepages(inode, 0, LLONG_MAX);
+	hugetlbfs_evict_drain_swaplist(inode);
 
 	resv_map = HUGETLBFS_I(inode)->resv_map;
 	/* Only regular and link inodes have associated reserve maps */
@@ -782,6 +877,25 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 			continue;
 		}
 
+		/*
+		 * A swap anchor means the page is swapped out: it is
+		 * already backed (on swap), so there is nothing to
+		 * preallocate.  filemap_get_folio() reports anchors as
+		 * holes, so check explicitly.  The fault mutex held here
+		 * keeps the anchor stable.
+		 */
+		{
+			void *entry = filemap_get_entry(mapping,
+						index << huge_page_order(h));
+
+			if (entry) {
+				if (!xa_is_value(entry))
+					folio_put(entry);
+				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+				continue;
+			}
+		}
+
 		/*
 		 * Allocate folio without setting the avoid_reserve argument.
 		 * There certainly are no reserves associated with the
@@ -921,6 +1035,10 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 		simple_inode_init_ts(inode);
 		info->resv_map = resv_map;
 		info->seals = F_SEAL_SEAL;
+		/* Initialize swapoff support fields */
+		INIT_LIST_HEAD(&info->swaplist);
+		atomic_set(&info->swapped, 0);
+		atomic_set(&info->stop_eviction, 0);
 		switch (mode & S_IFMT) {
 		default:
 			init_special_inode(inode, mode, dev);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 282185646fff..4c74323e4b01 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -508,6 +508,9 @@ struct hugetlbfs_inode_info {
 	struct inode vfs_inode;
 	struct resv_map *resv_map;
 	unsigned int seals;
+	struct list_head swaplist;	/* Link to hugetlbfs_swaplist */
+	atomic_t swapped;		/* Count of swapped pages */
+	atomic_t stop_eviction;		/* Prevent eviction during swapoff */
 };
 
 static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
@@ -890,6 +893,23 @@ static inline bool hugetlb_folio_swap_supported(const struct folio *folio)
 	return true;
 }
 
+/*
+ * File-page swap anchor removal for truncate/hole-punch/evict, and the
+ * evict-time drain of the swapoff traversal list.  Defined in mm/hugetlb.c,
+ * called from fs/hugetlbfs/inode.c.
+ */
+long hugetlbfs_free_swap(struct address_space *mapping, pgoff_t index,
+			 void *radswap, struct hstate *h);
+void hugetlbfs_evict_drain_swaplist(struct inode *inode);
+
+/*
+ * Read-path swapin of a swapped-out hugetlbfs page (mm/hugetlb.c,
+ * called from fs/hugetlbfs/inode.c), and the swapoff traversal of all
+ * hugetlbfs swap anchors (called from try_to_unuse()).
+ */
+struct folio *hugetlbfs_swapin_read(struct inode *inode, pgoff_t index);
+int hugetlbfs_unuse(unsigned int type);
+
 static inline unsigned hstate_index_to_shift(unsigned index)
 {
 	return hstates[index].order + PAGE_SHIFT;
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..85b98e5ee4e3 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -987,6 +987,13 @@ static inline bool folio_contains(const struct folio *folio, pgoff_t index)
 
 unsigned filemap_get_folios(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch);
+/*
+ * find_get_entries() also returns swap/shadow value entries (unlike
+ * filemap_get_folios()); hugetlbfs needs it to enumerate the swap
+ * anchors left in its page cache by hugetlb file-page swap-out.
+ */
+unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
+		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 unsigned filemap_get_folios_contig(struct address_space *mapping,
 		pgoff_t *start, pgoff_t end, struct folio_batch *fbatch);
 unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c7af58399e5b..89b066379586 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5831,6 +5831,9 @@ static bool hugetlb_pte_stable(struct hstate *h, struct mm_struct *mm, unsigned
 	return same;
 }
 
+static struct folio *hugetlb_no_page_swapin(struct address_space *mapping,
+					    struct vm_fault *vmf);
+
 static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 			struct vm_fault *vmf)
 {
@@ -5864,6 +5867,26 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 	new_folio = false;
 	folio = filemap_lock_hugetlb_folio(h, mapping, vmf->pgoff);
 	if (IS_ERR(folio)) {
+		/*
+		 * A swapped-out file page leaves a swap anchor value entry
+		 * in the page cache, which filemap_lock_hugetlb_folio()
+		 * reports as -ENOENT just like a real hole.  Check for the
+		 * anchor first and swap the page back in if it is there.
+		 */
+		folio = hugetlb_no_page_swapin(mapping, vmf);
+		if (!IS_ERR(folio))
+			goto swapped_in;
+		if (PTR_ERR(folio) != -ENOENT) {
+			if (PTR_ERR(folio) == -EAGAIN)
+				ret = 0;	/* raced, retry the fault */
+			else if (PTR_ERR(folio) == -EHWPOISON)
+				ret = VM_FAULT_HWPOISON_LARGE |
+					VM_FAULT_SET_HINDEX(hstate_index(h));
+			else
+				ret = vmf_error(PTR_ERR(folio));
+			goto out;
+		}
+
 		size = i_size_read(mapping->host) >> huge_page_shift(h);
 		if (vmf->pgoff >= size)
 			goto out;
@@ -5972,6 +5995,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 		}
 	}
 
+swapped_in:
 	/*
 	 * If we are going to COW a private mapping later, we examine the
 	 * pending reservations for this page now. This will ensure that
@@ -7551,19 +7575,667 @@ void fixup_hugetlb_reservations(struct vm_area_struct *vma)
 		clear_vma_resv_huge_pages(vma);
 }
 
+/*
+ * hugetlbfs inodes with at least one swapped-out file page; traversed by
+ * swapoff (hugetlbfs_unuse) to bring them back in.  Mirrored on
+ * shmem_swaplist.
+ */
+static LIST_HEAD(hugetlbfs_swaplist);
+static DEFINE_MUTEX(hugetlbfs_swaplist_mutex);
+
+/*
+ * Somewhat like shmem_replace_entry(), but replacing the whole huge page
+ * range in a hugetlbfs page cache.
+ */
+static int hugetlb_replace_entry(struct address_space *mapping,
+				 pgoff_t index, void *expected,
+				 void *replacement, unsigned int order)
+{
+	XA_STATE_ORDER(xas, &mapping->i_pages, index, order);
+	void *item;
+
+	VM_BUG_ON(!expected);
+	VM_BUG_ON(!replacement);
+	item = xas_load(&xas);
+	if (item != expected)
+		return -ENOENT;
+	xas_store(&xas, replacement);
+	if (WARN_ON_ONCE(xas_error(&xas)))
+		return xas_error(&xas);
+	return 0;
+}
+
+/*
+ * Somewhat like shmem_delete_from_page_cache(), but for a hugetlb folio:
+ * substitutes the swap anchor for @folio in the page cache.  After this
+ * the folio is only referenced by the swap cache.
+ */
+static void hugetlb_delete_from_page_cache(struct folio *folio, void *radswap)
+{
+	struct address_space *mapping = folio->mapping;
+	long nr = folio_nr_pages(folio);
+	int error;
+
+	xa_lock_irq(&mapping->i_pages);
+	error = hugetlb_replace_entry(mapping, folio->index, folio, radswap,
+				      folio_order(folio));
+	folio->mapping = NULL;
+	mapping->nrpages -= nr;
+	xa_unlock_irq(&mapping->i_pages);
+	folio_put_refs(folio, nr);
+	BUG_ON(error);
+}
+
+/*
+ * Swap out a file-backed hugetlb folio, shmem-style: the folio is moved
+ * into the swap cache and its place in the hugetlbfs page cache is taken
+ * by a swap anchor value entry, which holds a swap count reference on the
+ * slots and is what refault (hugetlb_no_page) and swapoff look up later.
+ * No swap PTE is ever installed for file folios.
+ *
+ * Return: the swap_writeout() result with the folio unlocked, or
+ * AOP_WRITEPAGE_ACTIVATE with the folio still locked and redirtied if it
+ * could not be swapped out.
+ */
+static int hugetlbfs_writeout(struct swap_io_ctx *ctx, struct folio *folio)
+{
+	struct address_space *mapping;
+	struct hugetlbfs_inode_info *info;
+	long nr_pages = folio_nr_pages(folio);
+
+	/* Retry of an already-anchored folio: just drive the write. */
+	if (folio_test_swapcache(folio))
+		return swap_writeout(ctx, folio);
+
+	mapping = folio->mapping;
+	info = HUGETLBFS_I(mapping->host);
+
+	/*
+	 * Move the folio into the swap cache; the slots come pinned at
+	 * count == 0.  The swap cache add requires the folio to be marked
+	 * swapbacked first.
+	 */
+	folio_set_swapbacked(folio);
+	if (folio_alloc_swap(folio))
+		goto redirty;
+
+	/*
+	 * Add the inode to the swapoff traversal list before the anchor
+	 * replaces the folio in the page cache, while the folio lock is
+	 * still serialization against a racing inode eviction.
+	 */
+	mutex_lock(&hugetlbfs_swaplist_mutex);
+	if (list_empty(&info->swaplist))
+		list_add(&info->swaplist, &hugetlbfs_swaplist);
+	atomic_add(nr_pages, &info->swapped);
+	mutex_unlock(&hugetlbfs_swaplist_mutex);
+
+	/* The anchor holds a swap count reference on the slots. */
+	folio_dup_swap(folio, NULL);
+	hugetlb_delete_from_page_cache(folio,
+			swp_to_radix_entry(folio_swap_entry(folio)));
+
+	return swap_writeout(ctx, folio);
+
+redirty:
+	folio_mark_dirty(folio);
+	return AOP_WRITEPAGE_ACTIVATE;	/* Return with folio locked */
+}
+
+/*
+ * Somewhat like shmem_add_to_page_cache(), but for a hugetlb folio:
+ * swap the folio back into the page cache in place of the swap anchor
+ * left behind by hugetlbfs_writeout().  The anchor is re-validated
+ * under the xarray lock; if it is gone (a racing swapin already
+ * installed its folio, or truncation removed it), -EEXIST is returned
+ * and the caller retries or drops the swapin.  The folio is still
+ * swap-backed here; the caller drops the swap cache membership
+ * afterwards, mirroring shmem_swapin_folio().
+ */
+static int hugetlbfs_add_to_page_cache(struct folio *folio,
+		struct address_space *mapping, pgoff_t index,
+		void *expected, gfp_t gfp)
+{
+	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
+	long nr = folio_nr_pages(folio);
+
+	VM_BUG_ON_FOLIO(index != round_down(index, nr), folio);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
+
+	folio_ref_add(folio, nr);
+	folio->mapping = mapping;
+	folio->index = index;
+
+	do {
+		xas_lock_irq(&xas);
+		if (xas_load(&xas) != expected)
+			xas_set_err(&xas, -EEXIST);
+		else
+			xas_store(&xas, folio);
+		if (!xas_error(&xas))
+			mapping->nrpages += nr;
+		xas_unlock_irq(&xas);
+	} while (xas_nomem(&xas, gfp));
+
+	if (xas_error(&xas)) {
+		folio->mapping = NULL;
+		folio_put_refs(folio, nr);
+		return xas_error(&xas);
+	}
+
+	return 0;
+}
+
+/*
+ * Swap in a hugetlbfs file page whose swap anchor sits at @index in the
+ * page cache.  Shared between the fault path (hugetlb_no_page_swapin(),
+ * @vma != NULL) and the swapoff/read paths (@vma == NULL).
+ *
+ * On success returns the folio locked, with a reference, reinstalled in
+ * the page cache in place of the anchor.  On failure returns an ERR_PTR:
+ *
+ *	-EAGAIN		raced with a concurrent swapin/swapout; retry
+ *	-EEXIST		a racing swapin already installed its folio
+ *	-EHWPOISON	the swapcache copy is poisoned; kill the accessor
+ *	-ENOMEM		could not allocate a hugepage from the pool
+ *	-EIO		the swap read failed
+ */
+static struct folio *hugetlbfs_do_swapin(struct address_space *mapping,
+			pgoff_t index, swp_entry_t entry,
+			struct vm_area_struct *vma, struct hstate *h,
+			unsigned long haddr)
+{
+	struct inode *inode = mapping->host;
+	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
+	long nr_pages = pages_per_huge_page(h);
+	struct swap_info_struct *si;
+	struct swap_io_ctx ctx = {};
+	struct folio *folio;
+	bool new_folio = false;
+	int error;
+
+	/* Prevent swapoff from happening to us, and reject a bad entry. */
+	si = get_swap_device(entry);
+	if (IS_ERR_OR_NULL(si))
+		return ERR_PTR(-EINVAL);
+
+	folio = swap_cache_get_folio(entry);
+	if (!folio) {
+		/*
+		 * Swapping out releases the huge page back to the pool, so
+		 * swapin has to compete for pool memory again; the caller
+		 * turns an allocation failure into SIGBUS, matching the
+		 * reservation-exhaustion contract of the no-page fault path.
+		 */
+		if (vma) {
+			folio = alloc_hugetlb_folio(vma, haddr, 1);
+		} else {
+			/*
+			 * The read/swapoff path has no vma.  Route through
+			 * the same charged allocator as the fault path so
+			 * that hugetlb_cgroup/memcg charges, the global
+			 * reservation consumed by the original fault, and
+			 * NR_HUGETLB all stay paired with free_huge_folio();
+			 * the charges go to the current context, mirroring
+			 * what shmem does for swapoff-triggered swapins.
+			 */
+			struct mempolicy_interpreted mpoli = {
+				.nid = numa_node_id(),
+				.mode = MPOL_DEFAULT,
+				.nodemask = NULL,
+			};
+
+			folio = hugetlb_alloc_folio(h, &mpoli,
+					HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS |
+					HUGETLB_ALLOC_CHARG_CGROUP_RSVD);
+		}
+		if (IS_ERR(folio)) {
+			error = PTR_ERR(folio);
+			goto out_put_si;
+		}
+		new_folio = true;
+		__folio_set_locked(folio);
+		__folio_set_swapbacked(folio);
+
+		/*
+		 * If the slot got cached or freed concurrently, just drop
+		 * the fault and let it retry.
+		 */
+		if (swap_cache_add_folio(folio, entry)) {
+			error = -EAGAIN;
+			goto out_new_folio;
+		}
+
+		swap_read_folio(&ctx, folio);
+		swap_read_submit(&ctx);
+	} else if (folio_test_hwpoison(folio)) {
+		/*
+		 * hwpoisoned dirty swapcache pages are kept for killing
+		 * owner processes (which may be unknown at hwpoison time)
+		 */
+		error = -EHWPOISON;
+		goto out_put_folio;
+	}
+
+	/* The read completion (or the current writer) drops the lock. */
+	folio_lock(folio);
+	if (unlikely(!folio_matches_swap_entry(folio, entry))) {
+		/* Raced with a swapin that already finished: retry. */
+		error = -EAGAIN;
+		goto out_unlock;
+	}
+	folio_wait_writeback(folio);
+	if (!folio_test_uptodate(folio)) {
+		error = -EIO;
+		goto out_unlock;
+	}
+
+	arch_swap_restore(folio_swap(entry, folio), folio);
+
+	/*
+	 * Replace the anchor with the folio, validated against @entry
+	 * under the xarray lock; a racing swapin that already installed
+	 * its folio (or a truncation that removed the anchor) is
+	 * reported as -EEXIST.
+	 */
+	error = hugetlbfs_add_to_page_cache(folio, mapping,
+			index << huge_page_order(h),
+			swp_to_radix_entry(entry), GFP_KERNEL);
+	if (error)
+		goto out_unlock;
+
+	mutex_lock(&hugetlbfs_swaplist_mutex);
+	if (atomic_sub_return(nr_pages, &info->swapped) == 0)
+		list_del_init(&info->swaplist);
+	mutex_unlock(&hugetlbfs_swaplist_mutex);
+
+	/*
+	 * Drop the anchor's swap count reference and the swap cache
+	 * membership, mirroring shmem_swapin_folio(); the slots are freed
+	 * once both are gone.
+	 */
+	folio_put_swap(folio, NULL);
+	swap_cache_del_folio(folio);
+	folio_mark_dirty(folio);
+	put_swap_device(si);
+
+	if (new_folio)
+		folio_set_hugetlb_migratable(folio);
+
+	return folio;
+
+out_unlock:
+	if (new_folio) {
+		/*
+		 * Never leave a fresh folio orphaned in the swap cache:
+		 * its pins would pin the slots after the anchor is gone.
+		 */
+		swap_cache_del_folio(folio);
+	}
+	folio_unlock(folio);
+out_put_folio:
+	folio_put(folio);
+out_put_si:
+	put_swap_device(si);
+	return ERR_PTR(error);
+out_new_folio:
+	folio_unlock(folio);
+	folio_put(folio);
+	put_swap_device(si);
+	return ERR_PTR(error);
+}
+
+/*
+ * Swap in the hugetlbfs page at @index for the read(2) and swapoff
+ * paths.  Takes the fault mutex, which both stabilizes the anchor and
+ * serializes against fault-path swapins of the same index.
+ *
+ * On success returns the folio locked with an elevated refcount; the
+ * caller is responsible for folio_unlock() + folio_put().  On failure
+ * returns an ERR_PTR that the caller must distinguish carefully:
+ *	-ENOENT		the slot is genuinely absent (a real hole);
+ *			zero-fill is correct
+ *	-EAGAIN		raced with a concurrent swapin (slot now holds a
+ *			folio, or the swapin itself returned -EEXIST);
+ *			the caller should re-lookup
+ *	other		-ENOMEM/-EIO/-EHWPOISON/-EINVAL propagated from
+ *			the swapin; the caller must turn these into a
+ *			read error, never zero-fill
+ */
+struct folio *hugetlbfs_swapin_read(struct inode *inode, pgoff_t index)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct hstate *h = hstate_inode(inode);
+	struct folio *folio;
+	swp_entry_t entry;
+	void *xa_val;
+	u32 hash;
+
+	hash = hugetlb_fault_mutex_hash(mapping, index);
+	mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
+	xa_val = filemap_get_entry(mapping, index << huge_page_order(h));
+	if (!xa_is_value(xa_val)) {
+		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+		/*
+		 * NULL means a genuine hole.  A folio means a concurrent
+		 * swapin already completed - filemap_get_entry() took a
+		 * reference we must drop, then ask the caller to re-lookup.
+		 */
+		if (xa_val) {
+			folio_put(xa_val);
+			return ERR_PTR(-EAGAIN);
+		}
+		return ERR_PTR(-ENOENT);
+	}
+
+	entry = radix_to_swp_entry(xa_val);
+	folio = hugetlbfs_do_swapin(mapping, index, entry, NULL, h, 0);
+	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+
+	if (IS_ERR(folio) && PTR_ERR(folio) == -EEXIST)
+		return ERR_PTR(-EAGAIN);	/* concurrent swapin race */
+	return folio;
+}
+
+/*
+ * Collect the xarray indices of swap anchors of swap area @type in the
+ * hugetlbfs page cache, starting from @start.  Returns the count.
+ */
+static unsigned int hugetlbfs_find_swap_entries(struct address_space *mapping,
+				pgoff_t start, pgoff_t *indices,
+				unsigned int type)
+{
+	XA_STATE(xas, &mapping->i_pages, start);
+	unsigned int nr = 0;
+	swp_entry_t entry;
+	void *xa_val;
+
+	rcu_read_lock();
+	xas_for_each(&xas, xa_val, ULONG_MAX) {
+		if (xas_retry(&xas, xa_val))
+			continue;
+		if (!xa_is_value(xa_val))
+			continue;
+		entry = radix_to_swp_entry(xa_val);
+		if (swp_type(entry) != type)
+			continue;
+		indices[nr] = xas.xa_index;
+		if (++nr == FOLIO_BATCH_SIZE)
+			break;
+	}
+	rcu_read_unlock();
+
+	return nr;
+}
+
+/*
+ * Process one inode for swapoff: swap in all its anchors belonging to
+ * swap area @type.  Similar to shmem_unuse().
+ */
+static int hugetlbfs_unuse_inode(struct inode *inode, unsigned int type)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct hstate *h = hstate_inode(inode);
+	pgoff_t indices[FOLIO_BATCH_SIZE];
+	pgoff_t start = 0;
+	unsigned int nr, i;
+	int ret = 0;
+
+	for (;;) {
+		nr = hugetlbfs_find_swap_entries(mapping, start, indices,
+						 type);
+		if (!nr)
+			break;
+
+		/* For each swap anchor found, swap it in. */
+		for (i = 0; i < nr; i++) {
+			struct folio *folio;
+
+			/*
+			 * hugetlbfs_swapin_read() takes the fault mutex,
+			 * re-validates that the slot still holds a swap
+			 * anchor and swaps the folio in.  swapoff only
+			 * needs the anchor gone, so drop the folio it
+			 * hands back.  The scan returns raw xarray
+			 * positions; shift back to hugetlb page indices.
+			 */
+			folio = hugetlbfs_swapin_read(inode,
+					indices[i] >> huge_page_order(h));
+			if (IS_ERR(folio)) {
+				ret = PTR_ERR(folio);
+				/*
+				 * -ENOENT: slot already a hole/removed.
+				 * -EAGAIN: raced with a concurrent swapin.
+				 * Either way the anchor is gone - skip it.
+				 */
+				if (ret == -ENOENT || ret == -EAGAIN) {
+					ret = 0;
+					continue;
+				}
+				break;
+			}
+
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		if (ret < 0)
+			break;
+
+		cond_resched();
+		start = indices[nr - 1] + pages_per_huge_page(h);
+	}
+
+	return ret;
+}
+
+/*
+ * Swap in all hugetlbfs pages from swap area @type.  Called from
+ * try_to_unuse() during swapoff.  Similar to shmem_unuse().
+ */
+int hugetlbfs_unuse(unsigned int type)
+{
+	struct hugetlbfs_inode_info *info, *next;
+	int error = 0;
+
+	if (list_empty(&hugetlbfs_swaplist))
+		return 0;
+
+	mutex_lock(&hugetlbfs_swaplist_mutex);
+start_over:
+	list_for_each_entry_safe(info, next, &hugetlbfs_swaplist, swaplist) {
+		if (!atomic_read(&info->swapped)) {
+			list_del_init(&info->swaplist);
+			continue;
+		}
+
+		/*
+		 * Drop the swaplist mutex while swapping in pages.
+		 * Set stop_eviction to prevent inode eviction.
+		 */
+		atomic_inc(&info->stop_eviction);
+		mutex_unlock(&hugetlbfs_swaplist_mutex);
+
+		error = hugetlbfs_unuse_inode(&info->vfs_inode, type);
+		cond_resched();
+
+		mutex_lock(&hugetlbfs_swaplist_mutex);
+		if (atomic_dec_and_test(&info->stop_eviction))
+			wake_up_var(&info->stop_eviction);
+		if (error)
+			break;
+		if (list_empty(&info->swaplist))
+			goto start_over;
+		next = list_next_entry(info, swaplist);
+		if (!atomic_read(&info->swapped))
+			list_del_init(&info->swaplist);
+	}
+	mutex_unlock(&hugetlbfs_swaplist_mutex);
+	return error;
+}
+
+/*
+ * File-backed swapin for the fault path, called from hugetlb_no_page()
+ * when the page cache lookup came back empty: a swapped-out hugetlbfs
+ * page leaves a swap anchor value entry behind, which the page cache
+ * lookup reports as a hole.
+ *
+ * Returns the swapped-in folio (locked, with a reference) on success, or
+ * an ERR_PTR: -ENOENT when there is no anchor (a genuine hole), -EAGAIN
+ * when the fault should be retried, -EHWPOISON when the swapcache copy
+ * is poisoned, or a propagated allocation/IO error.
+ */
+static struct folio *hugetlb_no_page_swapin(struct address_space *mapping,
+					    struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct hstate *h = hstate_vma(vma);
+	struct folio *folio;
+	swp_entry_t entry;
+	void *xa_val;
+
+	xa_val = xa_load(&mapping->i_pages,
+			 vmf->pgoff << huge_page_order(h));
+	if (!xa_is_value(xa_val))
+		return ERR_PTR(-ENOENT);
+	entry = radix_to_swp_entry(xa_val);
+
+	/*
+	 * The pte was examined without the page table lock; if it changed
+	 * since, this fault is stale and the swapin would be wasted work.
+	 */
+	if (!hugetlb_pte_stable(h, vma->vm_mm, vmf->address, vmf->pte,
+				vmf->orig_pte))
+		return ERR_PTR(-EAGAIN);
+
+	folio = hugetlbfs_do_swapin(mapping, vmf->pgoff, entry, vma, h,
+				    vmf->address);
+	if (IS_ERR(folio) && PTR_ERR(folio) == -EEXIST)
+		return ERR_PTR(-EAGAIN);	/* concurrent swapin race */
+	return folio;
+}
+
+/*
+ * Remove a swap anchor at @index from the hugetlbfs page cache and free
+ * the swap slots behind it, together with a cached copy if one is
+ * around.  Returns 1 if the anchor was removed, 0 if the entry at
+ * @index changed under us (the caller should rescan from @index).
+ *
+ * Called with the hugetlb fault mutex held, which serializes against
+ * the fault swapin path.
+ */
+long hugetlbfs_free_swap(struct address_space *mapping, pgoff_t index,
+			 void *radswap, struct hstate *h)
+{
+	XA_STATE_ORDER(xas, &mapping->i_pages, index, huge_page_order(h));
+	struct hugetlbfs_inode_info *info = HUGETLBFS_I(mapping->host);
+	swp_entry_t entry = radix_to_swp_entry(radswap);
+	struct swap_info_struct *si;
+	struct folio *folio;
+	void *old;
+
+	xas_lock_irq(&xas);
+	old = xas_load(&xas);
+	if (old != radswap) {
+		xas_unlock_irq(&xas);
+		return 0;
+	}
+	xas_store(&xas, NULL);
+	xas_unlock_irq(&xas);
+
+	/*
+	 * Evict a cached copy first, while the anchor's count reference
+	 * still pins the slots: this cannot race with a reallocation of
+	 * the slots, which a put-then-lookup order would allow.  A
+	 * hwpoisoned folio is safe to free here: the hugetlb free path
+	 * moves the poison marker to the raw error pages.
+	 *
+	 * Only evict when the folio is referenced by nothing but the
+	 * swap cache (and our lookup).  An extra reference means a
+	 * concurrent reclaim pass has the folio isolated; in that case
+	 * leave it cached, and keep the folio lock held across
+	 * swap_put_entries_direct() so that its __try_to_reclaim_swap()
+	 * cannot evict the folio either -- reclaim's own free path then
+	 * removes it (and frees the count-0 slots) once it resumes.
+	 */
+	si = get_swap_device(entry);
+	if (si) {
+		folio = swap_cache_get_folio(entry);
+		if (folio) {
+			folio_lock(folio);
+			folio_wait_writeback(folio);
+			if (unlikely(!folio_matches_swap_entry(folio, entry))) {
+				folio_unlock(folio);
+				folio_put(folio);
+				folio = NULL;
+			}
+		}
+		if (folio && folio_ref_count(folio) == folio_nr_pages(folio) + 1)
+			swap_cache_del_folio(folio);
+		/* Drop the anchor's swap count reference, freeing the slots. */
+		swap_put_entries_direct(entry, pages_per_huge_page(h));
+		if (folio) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		put_swap_device(si);
+	}
+	/*
+	 * Else the swap area is already torn down by swapoff, which has
+	 * freed the slots; there is nothing to put.
+	 */
+
+	mutex_lock(&hugetlbfs_swaplist_mutex);
+	if (atomic_sub_return(pages_per_huge_page(h), &info->swapped) == 0)
+		list_del_init(&info->swaplist);
+	mutex_unlock(&hugetlbfs_swaplist_mutex);
+
+	return 1;
+}
+
+/*
+ * Drain this inode from the swapoff traversal list and wait for any
+ * concurrent hugetlbfs_unuse() scan of it to finish.  Called from
+ * hugetlbfs_evict_inode() after remove_inode_hugepages() has removed
+ * all pages and swap anchors, so the swapped count is already 0.
+ */
+void hugetlbfs_evict_drain_swaplist(struct inode *inode)
+{
+	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
+
+	/*
+	 * Check list_empty under the mutex to prevent a concurrent
+	 * writeout from re-adding the inode between the check and the
+	 * wait.  Beware of the race if we peeked too early.
+	 */
+	mutex_lock(&hugetlbfs_swaplist_mutex);
+	while (!list_empty(&info->swaplist)) {
+		mutex_unlock(&hugetlbfs_swaplist_mutex);
+		wait_var_event(&info->stop_eviction,
+			       !atomic_read(&info->stop_eviction));
+		mutex_lock(&hugetlbfs_swaplist_mutex);
+		if (!atomic_read(&info->stop_eviction))
+			list_del_init(&info->swaplist);
+	}
+	mutex_unlock(&hugetlbfs_swaplist_mutex);
+}
+
 /*
  * Reclaim a list of isolated hugetlb folios by swapping them out.
  *
  * This is a deliberate mirror of shrink_folio_list(), not a reuse:
  * hugetlb folios live on hstate activelists instead of LRUs, are
- * unmapped through hugetlb rmap walks (whole-folio swap entries), and
- * go back to the hstate pool on free instead of the buddy allocator.
- * None of those hooks exist in the generic reclaim path, and shrinking
- * that path's folio-size assumptions to fit hugetlb would complicate
- * both sides, so the hugetlb-specific steps are reimplemented here next
- * to the machinery they depend on (demotion and pool management live in
- * this file for the same reason).
- * Caller: proactive reclaim via MADV_PAGEOUT.
+ * unmapped through hugetlb rmap walks (whole-folio swap entries), are
+ * written out via hugetlbfs_writeout()/the anon swap-PTE install path,
+ * and go back to the hstate pool on free instead of the buddy
+ * allocator.  None of those hooks exist in the generic reclaim path,
+ * and shrinking that path's folio-size assumptions to fit hugetlb
+ * would complicate both sides, so the hugetlb-specific steps are
+ * reimplemented here next to the machinery they depend on (demotion
+ * and pool management live in this file for the same reason).
+ * Caller: proactive reclaim via MADV_PAGEOUT; the kernel never reclaims
+ * hugetlb folios on its own.
  */
 static unsigned int hugetlb_reclaim_folio_list(struct list_head *folio_list)
 {
@@ -7612,14 +8284,6 @@ static unsigned int hugetlb_reclaim_folio_list(struct list_head *folio_list)
 		if (unlikely(!folio_evictable(folio)))
 			goto activate_locked;
 
-		/*
-		 * Only anonymous folios (MAP_PRIVATE mappings after COW)
-		 * are swapped out so far; file-backed hugetlbfs folios
-		 * gain swap support later in this series.
-		 */
-		if (!folio_test_anon(folio))
-			goto keep_locked;
-
 		/*
 		 * If the folio's swap write is still in flight, the bio holds a
 		 * writeback reference that end_swap_bio_write() drops
@@ -7640,21 +8304,28 @@ static unsigned int hugetlb_reclaim_folio_list(struct list_head *folio_list)
 		}
 
 		/*
-		 * Anonymous folios enter the swap cache here, before the
-		 * unmap below installs swap PTEs that reference the slots.
-		 * Hugetlb folios are not swap backed by default.
+		 * Both anonymous folios (MAP_PRIVATE mappings after COW) and
+		 * file-backed hugetlbfs folios can be swapped out.  Anonymous
+		 * folios enter the swap cache here, before unmap installs
+		 * swap PTEs that reference the slots.  File folios enter it
+		 * later, inside hugetlbfs_writeout(): their unmap only
+		 * clears the PTEs and installs nothing, so no slots are
+		 * needed yet.
 		 */
-		folio_set_swapbacked(folio);
-		if (!folio_test_swapcache(folio)) {
-			if (folio_alloc_swap(folio))
-				goto activate_locked;
+		if (folio_test_anon(folio)) {
+			/* Hugetlb folios are not swap backed by default. */
+			folio_set_swapbacked(folio);
+			if (!folio_test_swapcache(folio)) {
+				if (folio_alloc_swap(folio))
+					goto activate_locked;
 
-			folio_mark_dirty(folio);
+				folio_mark_dirty(folio);
+			}
 		}
 
 		/*
-		 * Unmap from every process, installing swap PTEs that
-		 * reference the slots allocated above.
+		 * Unmap from every process: installs swap PTEs for anonymous
+		 * folios, just clears the PTEs for file folios.
 		 */
 		if (folio_mapped(folio)) {
 			try_to_unmap_swap_hugetlb(folio);
@@ -7685,7 +8356,10 @@ static unsigned int hugetlb_reclaim_folio_list(struct list_head *folio_list)
 
 			if (folio_clear_dirty_for_io(folio)) {
 				folio_set_reclaim(folio);
-				res = swap_writeout(&ctx, folio);
+				if (folio_test_anon(folio))
+					res = swap_writeout(&ctx, folio);
+				else
+					res = hugetlbfs_writeout(&ctx, folio);
 				if (res < 0) {
 					folio_lock(folio);
 					if (folio_mapping(folio) == mapping)
@@ -7780,7 +8454,9 @@ static unsigned int hugetlb_reclaim_folio_list(struct list_head *folio_list)
 activate_locked:
 		/*
 		 * Not swapped out: drop any swap slots we reserved.  Only
-		 * anonymous folios can hold reserved-but-unused slots here.
+		 * anonymous folios can hold reserved-but-unused slots here;
+		 * a file folio in the swap cache is already anchored in the
+		 * page cache and must keep its slots for the anchor.
 		 */
 		if (folio_test_anon(folio) && folio_test_swapcache(folio) &&
 		    (folio_test_mlocked(folio) || mem_cgroup_swap_full(folio)))
@@ -7867,6 +8543,7 @@ unsigned long hugetlb_reclaim_pages(struct list_head *folio_list)
 
 	return nr_reclaimed;
 }
+
 /*
  * Mirror of should_try_to_free_swap() in mm/memory.c for the hugetlb
  * swapin path; keep in sync.  The exclusive test differs: hugetlb
diff --git a/mm/internal.h b/mm/internal.h
index e16f1250b25c..523472225a8b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -605,8 +605,6 @@ static inline void force_page_cache_readahead(struct address_space *mapping,
 
 unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
-unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
-		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
@@ -1469,8 +1467,23 @@ static inline void shrinker_debugfs_remove(struct dentry *debugfs_entry,
 /* Only track the nodes of mappings with shadow entries */
 void workingset_update_node(struct xa_node *node);
 extern struct list_lru shadow_nodes;
+
+#ifdef CONFIG_HUGETLBFS
+static inline bool hugetlbfs_mapping(struct address_space *mapping)
+{
+	return mapping->host &&
+	       mapping->host->i_sb->s_magic == HUGETLBFS_MAGIC;
+}
+#else
+static inline bool hugetlbfs_mapping(struct address_space *mapping)
+{
+	return false;
+}
+#endif /* CONFIG_HUGETLBFS */
+
 #define mapping_set_update(xas, mapping) do {			\
-	if (!dax_mapping(mapping) && !shmem_mapping(mapping)) {	\
+	if (!dax_mapping(mapping) && !shmem_mapping(mapping) &&	\
+	    !hugetlbfs_mapping(mapping)) {			\
 		xas_set_update(xas, workingset_update_node);	\
 		xas_set_lru(xas, &shadow_nodes);		\
 	}							\
diff --git a/mm/madvise.c b/mm/madvise.c
index a46306cd1d49..5f7584e42c37 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -636,9 +636,10 @@ static void madvise_pageout_page_range(struct mmu_gather *tlb,
 }
 
 /*
- * Page out private anonymous hugetlb folios in the range: isolate each
- * present hugepage, hand the batch to hugetlb_reclaim_pages() and let it
- * unmap, write out and free the folios synchronously.
+ * Page out hugetlb folios in the range: isolate each present hugepage,
+ * hand the batch to hugetlb_reclaim_pages() and let it unmap, write out
+ * and free the folios synchronously.  Both private (anonymous) folios
+ * and shared (hugetlbfs page-cache) folios are supported.
  */
 static long madvise_pageout_hugetlb(struct madvise_behavior *madv_behavior)
 {
@@ -654,13 +655,6 @@ static long madvise_pageout_hugetlb(struct madvise_behavior *madv_behavior)
 		return -EINVAL;
 	if (vma->vm_flags & (VM_LOCKED | VM_PFNMAP))
 		return -EINVAL;
-	/*
-	 * Swap PTEs are only installed for anonymous folios (MAP_PRIVATE
-	 * after COW); shared hugetlbfs mappings gain swap-out support
-	 * later in this series.
-	 */
-	if (vma->vm_flags & VM_MAYSHARE)
-		return -EINVAL;
 	/* A huge page must fit in a single swap cluster to be swappable. */
 	if (hstate_is_gigantic(h) || huge_page_order(h) > HPAGE_PMD_ORDER)
 		return -EINVAL;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 280a31c43c81..97e744aa6916 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2763,6 +2763,13 @@ static int try_to_unuse(unsigned int type)
 	if (retval)
 		return retval;
 
+#ifdef CONFIG_HUGETLB_PAGE
+	/* Swap in any swapped-out hugetlbfs file pages (swap anchors). */
+	retval = hugetlbfs_unuse(type);
+	if (retval)
+		return retval;
+#endif
+
 	prev_mm = &init_mm;
 	mmget(prev_mm);
 
-- 
2.53.0


