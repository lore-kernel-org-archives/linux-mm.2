Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27227C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1E26B00A1; Tue, 22 Sep 2026 07:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA40A6B009E; Tue, 22 Sep 2026 07:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B48AC6B00A0; Tue, 22 Sep 2026 07:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 867286B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:15:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 148C0C0432
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:15:25 +0000 (UTC)
X-FDA: 85241142210.14.7DC606F
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7F6ABC000D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:15:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790075723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Frms/DfRueCrGnvuoEuAgjhGmVf50ocgc0AxlroGD3Y=;
	b=3bHilUmd7heGOrTjA6KXE450bn79O0wGIE+fY2/l4FchNmieWn9JCASHiGhKxg3RzheLVT
	g8HVJVsaf63nkyB1GOinvuSrzT6e7a3jDn4VIFaBX75p/QKOPQn3sNiZYHNnrSQI8AY1SZ
	OAFSsWPVkF/qZz8usN+Y/C+kJsnnVs4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790075723;
	b=de+yMDaFfTSjyJRp1P4VESueK5cRxhYedGPkjsFeOEU7jIGBnxx7xa9TCsFih07S3A4UjD
	JudMHqJ+YYoKp4i5QFSdoWlYsN2OavrLEvNKfB6lT6ni4KsH9MZh8witUy0e+xVlCxoIJo
	oqce+Li6uEJHkYGFvI1rhyeu4PndYbo=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hpyDj4FBpzYQvh9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:15:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B44E040578
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:15:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgD3xik4Y7JqtosFBQ--.39851S5;
	Tue, 22 Sep 2026 19:15:16 +0800 (CST)
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
Subject: [PATCH v4 1/4] mm/truncate: align truncation boundaries to mapping minimum folio order
Date: Tue, 22 Sep 2026 19:07:00 +0800
Message-ID: <20260922110703.468389-2-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3xik4Y7JqtosFBQ--.39851S5
X-Coremail-Antispam: 1UD129KBjvJXoWxZr4Utr13Cw18Wr1rJr18Zrb_yoWrAF18pF
	ZrGrnxArWkGrW7Cr48ua1vvr4rXayDXa15AFyxJasayFnYgF1qkFy2v3W0vw4UGryxJF1F
	yF4jyFWqg3WqvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
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
X-Rspamd-Queue-Id: 7F6ABC000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: xopk87r46tqq7nsbazsnbo6a1xgrj969
X-HE-Tag: 1790075722-908144
X-HE-Meta: U2FsdGVkX19T86bzGFAMmgO/Q0RIc9bWj5s63eHyUpq+VV/OcDKAcK2MTsdtzVRtkyLcom9a/w0qoohdY3zjC2A/fN//vr82tefjLlYj9qf+6aeurnMrgvLnu3a4WLmrKE4aF76ulHeRxulwgKQOrJOQCs2vfjK1xPeQAUfElmjTiIEjbJjtUOjibGzpTFQpHq940sTtGYj7y8dh0hIDYVm3Hv39+eckyxNR4MyDdU2WtQ3rezEELDQSVhUeyWhU3ut6DS2KafdDk65wQYRPjpLcFCKrybrQ5B+aTPW3r+4iL75Q95IXYnsRorBmaVzgu9VwMd+oraejeeAoR6H42YZjtUA7Sn/zl8ApKPhWFYKVs6xrVk/13qZ9uR5nYlEn+iSCNWlOSzWt8QsGJbglnFDVkfUrRC7la8/a4yLWyEG5aXv389MLHvEuBXMv+/Fj/YIhxgnG9gshATG1G7Phx5qj1sr+SCKE4nPIy+2XB/+15a4O84t6hbMfQ/uaf9kuOOgyAd//9bkHv/oUFSVQKHH5hn0803xSdy7xBwYoT89xYnP7tmsQYAc6oLMgGXzP7fo0T6PlAnp7O9CrrWkrZzK+EcXRVqNbrreL1K5Rx7dSGI2UQ51ljMw+RcCYkhzySwBIDunNNjwMksyzeCG3v7sGBjrdr5P6YZuOwppUJkbTFMrJ9EFsL/kBK97E1zKHtEXdj7q7WmWZV/tweB7loTxbmdjEDxxPYOQAeOJolsrvv2XXVDrd0TUFx/QG9ypFVP+B0/ns9AVFk2Tsy45jE8lGNZyrXfOi3HUbh/sCZAjGiouVtG/EM0/ZovWd0IlzP0Ug3/j8fVEnN80+MBK/z1l7lFkvd57Aku+LFExQ1wpiRNbahq8p9JYqUJpEw0A6nzDCA5ILIgDT71rNZnd9EqZXRiAvFYIaZ3rSgq6iSu/fnWTYgApnTrXpDn+8Scei+EHE6bHJ5+5myON9IuI
 fdPjyFkm
 D5iUu0zng6w+HEpyLWbqgg2YWs/40fNiG12aXKsnqYBVMFo7SycHoWJbbw8yimF3IZ/vVm8aZ6+6ogjWMFVVJQmCWJoP0nKdyLEU49as641OsR7J/8cTLg1no6Erm+uyQgxUWakHX6FdhybKARsE/R3RikOtOiM2XyFK3
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
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/truncate.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..f9625bb4916f 100644
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
@@ -374,14 +376,14 @@ void truncate_inode_pages_range(struct address_space *mapping,
 	int		i;
 	struct folio	*folio;
 	bool		same_folio;
+	pgoff_t		min_nrpages = mapping_min_folio_nrpages(mapping);
 
 	if (mapping_empty(mapping))
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


