Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BCFEC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42EB76B00BA; Wed, 16 Sep 2026 05:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3805C6B00BF; Wed, 16 Sep 2026 05:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E136B00C0; Wed, 16 Sep 2026 05:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D35376B00B9
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 696A2140525
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:54 +0000 (UTC)
X-FDA: 85219111068.04.DF09536
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 914E920003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551172;
	b=bEybmYvM6RyUNMrLJfNhcZfE9m4DNCBJx4wL9dz+c2XVtl0xTTRyfErEmykOBEsn+YCAn7
	IzMsNa8jgBj8s0fXlrAWQPbK0MSv+TajRnI7g12BfY3+N3qNMZPOn4r484Uu8w+mCfwmxH
	SYBid0E/rpEGvelQ4Pu4e+r6iSE63XI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PgKKjF/s3aVRR/spnhI+Cru/GGWi8BeOXIFDqcFKKC8=;
	b=AVin75hd0Gqzivq4sQW0+WxHW0hBEXZCmEiyGdkoWRVlx2TGKXOYWjcr4SelJykpx5oCG7
	y8nqvMt7z/RfV7KbOMESojv5S3QROI5wo5oi1iCTDfjNLL5ukwIQSDezCe4z3OfqFeLojE
	isDl3x2q3rEGkD4CzStcN3ptQlUN+Og=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hlDFQ03QkzYQv1J
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:32:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B21F340561
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:32:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCHVikvYqpq8i0GAg--.65015S6;
	Wed, 16 Sep 2026 17:32:46 +0800 (CST)
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
Subject: [PATCH v3 2/3] mm/truncate: align truncation boundaries to mapping minimum folio order
Date: Wed, 16 Sep 2026 17:24:49 +0800
Message-ID: <20260916092450.654408-3-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHVikvYqpq8i0GAg--.65015S6
X-Coremail-Antispam: 1UD129KBjvJXoWxWr15ZFyfXryUWryUJFykGrg_yoWrXr45pF
	W2g3ZxArWUXr12kr4Dua1DZr45X39xX3WUAFWxGF93C3Z0q3WqkFyjg3W8Zw48GryxAryr
	ZF1jyasrWF1DAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
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
	Ja73UjIFyTuYvjTRNiSHDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Rspamd-Queue-Id: 914E920003
X-Stat-Signature: xoyqfxzdsxt7penqx3de3yq7ywwdf5g6
X-Rspamd-Server: rspam01
X-HE-Tag: 1789551170-179592
X-HE-Meta: U2FsdGVkX18r0jX4vm/ypAEA7hwzmfZb3esJOMWqHlXWXAdQmuwXMuoqzeQXWdC7ZEZxBhRYsG1ZKM7iFC9dmpcOFR0AIa0NIy+uPIxPUXAGSpN6Tfs0i33iwfsJl5dvNq0GmnA3fQsM+3ysz9hsDKPb1KxbX1Uik89vkppf4QD676AJhDllc6jLYHmFvYsO++35mwSllaL+LIWL+xYXgQg1cMuY6mOuzRQmE6h3j0TZZPA5SGqMOAOOIfn0UPQTSVP0veyAIR0OCtYZ/uUEYOqhr9BeEHG+w4Suj+UJllJRO/4xMhvzYvDlNBiuVAiARAXEPJRjfgT++E/hCKwavN1W2LlCRTbhOMUuhz9YY4F8mouBannC8a2xzCVntRUR1D7d19r67ILKy0Rx8Wkhb8tlakSqO+DtMh3WlBpBJ1Nw9vD6BKxJVcmbut83CFQZJrn9Q0BCctLT+L3gfLrA+dibQrnKxmgzvFYUDpR+LO9sYTIRl8gZ8KqWicj+YjiYFzfOSIXWIq6k+s1aOvd8s1vMkl7839PniLFY52xVvzsvJqXkBD4CYTTZCuBu9805FRpCPfbFyQM+MsGr8zDpgxYSuFIJa06TetBehSuESn1oTlYNiOzLYyRlIHXLweAYZ6RPTK8IRgA3o6wgVhpBkHINfnNiGdBX7xLUi/rGZEc15MdN8Q64TstkB60Up3IGPNESWP0bzUvz1aRnu68uaQAUSXOy5q+MQhy8k40WS+DcwE90eIBTSOtYZHb52iZySQ6ujixe98XiiZnC9vPyrH3sXInaisUPErqtqkbiGl+8IExvtvkh4wTQ4qZr5c6thAfJ0IXHpKPVtCxD5+MGi6bjxl/PjjybqDa3vU6hYMkXDq9bAbu9pDxUd5LrCWQAu1jkVOtGTePN5yONFGvNnVON3IpcCOVnI8plWiHCqHqcVyEe1jsRdXoXxYbHU7Z1jUhqRhrGUk0L3e8V9aT
 WKcZNqAF
 DjXtK9ZzlCiULdo6dWCkKQV1Y4shYSqNFZyfKAYZg4JGgTK8x8fbqQIfV4k7jXhiG9IITpLutaVLAXko+HyQA8OdeBWclk88/oZ/F0PrLm/su4YJPdfzGClcQSIB4Vw1zPJC4ADChN5ujQB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Yi <yi.zhang@huawei.com>

When the mapping has a non-zero minimum folio order (min_order),
folio_split() stops at min_order instead of order 0, so the sub-folio
containing a split point stays aligned to 1 << min_order rather than to
a single page. The original boundaries were based on page granularity,
so either boundary could land inside the min_order chunk at its edge,
and the truncation loop would drop that whole chunk, valid out-of-range
tail included.

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
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/truncate.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index bec6d881d022..5ab7a40b1e25 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -213,8 +213,8 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
  *
  * When @pstart and/or @pend are non-NULL they receive the indexes of the
  * page range fully covered by [lstart, lend] after any split (or none),
- * i.e. the range of pages wholly within [lstart, lend] and so safe to
- * discard.
+ * aligned inwards to min_order, i.e. the range of folios wholly within
+ * [lstart, lend] and so safe to discard.
  *
  * Returns false if splitting failed so the caller can avoid
  * discarding the entire folio which is stubbornly unsplit.
@@ -226,6 +226,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 	size_t size = folio_size(folio);
 	unsigned int offset, length;
 	struct page *split_at, *split_at2;
+	unsigned long min_nrbytes;
 	unsigned int min_order;
 
 	if (pos < lstart)
@@ -263,6 +264,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 		return true;
 
 	min_order = mapping_min_folio_order(folio->mapping);
+	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
 	if (!folio_split_or_unmap(folio, split_at, min_order)) {
 		/*
@@ -271,12 +273,12 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
-		pgoff_t end, aligned_end = (pos + offset + length) >>
-					   PAGE_SHIFT;
+		pgoff_t end, aligned_end = round_down(pos + offset + length,
+						min_nrbytes) >> PAGE_SHIFT;
 
 		if (pstart)
-			*pstart = round_up(pos + offset, PAGE_SIZE) >>
-				  PAGE_SHIFT;
+			*pstart = round_up(pos + offset,
+					   min_nrbytes) >> PAGE_SHIFT;
 
 		if (offset + length == size) {
 			end = aligned_end;
-- 
2.52.0


