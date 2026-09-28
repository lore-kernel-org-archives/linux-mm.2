Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7BAFCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A400B6B0092; Mon, 28 Sep 2026 08:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14AC6B009E; Mon, 28 Sep 2026 08:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E6B6B0099; Mon, 28 Sep 2026 08:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60CB26B0095
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:17:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1CC91C03F2
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:17:07 +0000 (UTC)
X-FDA: 85263070494.27.B6E70BF
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0973E4000A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:17:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B6N8cKovpbIbc7g4UyEsKzj8pKQzYuxaUen5k5znKpI=;
	b=PtlsC0HI6LAzaQ9RKeLQBMnfW+Rc5RI6dn+0ZXUPFbKVZhxjVdYri6UO+kqUQvq5nPCMTG
	jzkihWKKfCTfE8ytKguY3X9aEQTCaExTOcfOBwgF7v3cy5rkt56onIlP1KheiDlfaZoIH9
	ed1f7vpNNZcGEYEvpVzw030bWyR8j8o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597826;
	b=VxgnSa+IGgk6BVkBZAMVZOo0ZSDAPjDEGuCp+vA7l5gJa9sCOQFrbwvbvO8cBJwLw+dHIG
	jYqXjTbqvAif7nbUkhqHrJ0Yu065RJdfSZSfvQD/+jjiprncbFz8u+b+vlUiZeTpRpFMOX
	mrMSJIinw4mDh9EmYOK8WBracTanRW8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4htgJp217dzKHMZ9
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:16:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 48C394085D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:17:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCHVim1WrpqTZH9Bw--.4739S5;
	Mon, 28 Sep 2026 20:17:00 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	bfoster@redhat.com,
	joannelkoong@gmail.com,
	djwong@kernel.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v5 1/4] mm/truncate: align truncation boundaries to mapping minimum folio order
Date: Mon, 28 Sep 2026 20:08:30 +0800
Message-ID: <20260928120833.3440834-2-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHVim1WrpqTZH9Bw--.4739S5
X-Coremail-Antispam: 1UD129KBjvJXoWxZr4Utr13Cw18Wr1rJr18Zrb_yoWruryDpF
	W7GwnxGrWkGrWxCr4kua1vyrs5XayDXa15CFyxG3sakrnYgF1qkr9Fk3W8tw4UG34xAF1F
	yF4jyFWvg3WqyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRMfOzDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0973E4000A
X-Stat-Signature: 7cxkumr5jz5ejg41d79nmtgj7mkxyoab
X-Rspam-User: 
X-HE-Tag: 1790597823-936514
X-HE-Meta: U2FsdGVkX19M7rEuCxoSl/7leYLhGrbnDbeFZOMUw+nyEbC2n/z8UYFa6oMp+mGxGgFvzHipMDNXZ9socYiPLjnS8l77yQbbd1BnLQef8E2qy/sRm60lH9QjQxqCEANlOeCxDIsWux1gpEc1sGc4nLPzdlneGwU3KTJp1t92wW1zST7pQSn14woqxR0ZRooB6xaR8rpfMxIJ5sskAKgw2kB7y3mLviSeg0QUoi682TBnXucSekve+TXTbXPpnTmD6t/Cun+PSTl+H85qDQCPs7V7CrWlLOKfiAjGZKmVy7etDju1BOyTmpeSNuG2JnFg2AE+zOTxoTsYxTRNHTBZNPbQeYNUpXqb10FQDKg+JW9QGklromOKWAgVoQXoUZIruGMCp1kdZhcQaCPe27fgYO90yGtCsmdSnc7u3WUunF2970bJT1R4xKngnN/Kt/8BztNFacCHDgE46YQf0I2DVShIq6QteUc1XcEmYlqNTlPnPy1lUfgiabZ3QlUMw/rn8wgbHXFdcNlXYeBYm6J3+H05JzjbzgWUlOMLBlsTaJWsWJcXe19Ex1m/s1nfPfEwYPa4pOGRKytcLeeI0+Ocz2dJBYCzxusAyqx5uel3I31aRRE9030YAfyaHnVYPGyI/L1QB2MuCU+jd0qkE1S2sd/VD3tAeGUIwd9yKUP1v73uPr0ZzNuRIC5AI+uNLVF0HDCWvEi5zmlgai5i0ivmcXohei0uxHi+Wml1UN/FDIoiRMH62Jqr6kDHn/tTdec+vZRAKE7lFeGVyW2fSOWRrd5+NLGZEEZVPZTZGvM8FzvnVn+S3T3XCw6z0rcR/xS7apmYQLDcXkWiY0gyTld++jFd2XNp3fSF8aaLz2yZHqnZbon1NWL7UMpSvNQe33oC9OlZSJBPCx7zLjVky5JgoUT8DvOSY6w1M2Fb0Bjy/cdfaIBYZ+oT75ck2/qf2GVGltpcUjR8DOovCOQ3q+s
 C6GVV7tT
 J7n06PoIT1aQ+q3rYvh5U0VjrPDMtQhuMp7dAXRDC10k8pTo8/halR5m0g+vX7YRhSn17uD5eYqLFYo/r8gU/Fr50hs9foTX0yA8WRFwuI+pj44TRJUkQZ4m4cnANfF0Uy4t4dUM7GvvGP4guXh1VMVlw8ejRSa7yDzoGg1RfrkXXixgmUDQwgI3vWlFrWioAT5eb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Yi <yi.zhang@huawei.com>

When the mapping has a non-zero minimum folio order (min_order),
folio_split() in truncate_inode_partial_folio() stops at min_order
instead of order 0, so the sub-folio containing a split point stays
aligned to 1 << min_order rather than to a single page. The original
boundaries in truncate_inode_pages_range() were based on page
granularity, so either boundary could land inside the min_order chunk at
its edge, and the truncation loop would drop that whole chunk, valid
out-of-range tail included.

For example, a 64K (order-4) folio with min_order = 2 (16K) punched from
offset 0 to 36K:

  split @p0 -> [p0-p3, p4-p7, p8-p15]         # non-uniform, min_order
  folio2 = p8-p15           # straddles: p8 in range, p9-p15 tail valid
  2nd split of folio2 -> [p8-p11, p12-p15]    # success
  end(old) = p9                               # BUG: p9 inside [p8-p11]
  loop truncates ... p8-p11               # p9-p11's valid tail is lost

It has gone unnoticed so far for two reasons. A non-zero min_order is
only used by filesystems with a block or sector size larger than the
page size, and those either always write back the affected range before
punching a hole or truncating, or they carry filesystem private data on
dirty folios (e.g. buffer_head), which makes filemap_release_folio()
fail and folio_split() abort with -EBUSY, so the folio is never split
and the old start/end boundaries remain valid. The bug only becomes
reachable on paths that truncate dirty large folios without prior
writeback and without filesystem private data, such as the upcoming ext4
iomap buffered I/O path.

Align both start (rounded up) and end (rounded down) to the mapping
minimum folio order so they always fall on a folio boundary.

Reported-by: Joanne Koong <joannelkoong@gmail.com>
Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com/
Fixes: e220917fa5077 ("mm: split a folio in minimum folio order chunks")
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/truncate.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..8a28f4a21267 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -345,9 +345,11 @@ long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
  * @lstart: offset from which to truncate
  * @lend: offset to which to truncate (inclusive)
  *
- * Truncate the page cache, removing the pages that are between
- * specified offsets (and zeroing out partial pages
- * if lstart or lend + 1 is not page aligned).
+ * Truncate the page cache, removing the folios that are between specified
+ * offsets (and zeroing out partial folios if lstart or lend + 1 is not
+ * folio aligned).  For mappings with a non-zero minimum folio order, the
+ * boundaries are aligned inwards to 1 << min_order so the edge sub-folio
+ * straddling the range is kept.
  *
  * Truncate takes two passes - the first pass is nonblocking.  It will not
  * block on page locks and it will not block on writeback.  The second pass
@@ -366,6 +368,7 @@ long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
 void truncate_inode_pages_range(struct address_space *mapping,
 				loff_t lstart, uoff_t lend)
 {
+	pgoff_t		min_nrpages = mapping_min_folio_nrpages(mapping);
 	pgoff_t		start;		/* inclusive */
 	pgoff_t		end;		/* exclusive */
 	struct folio_batch fbatch;
@@ -379,9 +382,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
 		return;
 
 	/*
-	 * 'start' and 'end' always covers the range of pages to be fully
-	 * truncated. Partial pages are covered with 'partial_start' at the
-	 * start of the range and 'partial_end' at the end of the range.
+	 * 'start' and 'end' always covers the range of folios to be fully
+	 * truncated, with both boundaries aligned inwards to 1 << min_order.
 	 * Note that 'end' is exclusive while 'lend' is inclusive.
 	 */
 	start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -395,6 +397,10 @@ void truncate_inode_pages_range(struct address_space *mapping,
 	else
 		end = (lend + 1) >> PAGE_SHIFT;
 
+	start = round_up(start, min_nrpages);
+	if (end != (pgoff_t)-1)
+		end = round_down(end, min_nrpages);
+
 	folio_batch_init(&fbatch);
 	index = start;
 	while (index < end && find_lock_entries(mapping, &index, end - 1,
-- 
2.52.0


