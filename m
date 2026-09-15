Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 816ACC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFD46B00BB; Mon, 14 Sep 2026 23:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A0F56B00BD; Mon, 14 Sep 2026 23:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 142A16B00BC; Mon, 14 Sep 2026 23:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E27CB6B00BA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:17:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6342E40303
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:12 +0000 (UTC)
X-FDA: 85214535504.15.8EE4C82
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3C5E080004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789442230;
	b=eOipPMRkHxpw1KlpzOwOppHOgZckp3WNC4aG0ZuqAvCMc0A9JlHdqp+oeiuz6+aX9BEfB3
	CAxuI6y/fwYyyjLYQCRYFMmFT5qagB677OXmpAjhl0fzz+OJGtPCubRokRdlmoe2NpDipz
	n5FPeVca8JJ73YqGz+CD25BLHZk0/QU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xxDB36eQPxu5rXW/6NBuZC327pUVFJde3XyAJVGyZEU=;
	b=HnXtkQn6lwHyqcYGGHyEjM98JQAToz5Cc0OHDdv0QWm92y1iqLbzuoB4jWTQjK2bAO/Dp4
	A0w75b6zSp17pfzgZmOLHprB1ZA3h6LHazBtgQynhSorAuvbsGoJidlg3sHrriJ69UGIu7
	NTkiIVH4eo2Nrl+/B2OW3+0AjM9gYuU=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 15 Sep 2026 12:17:07 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	her0gyugyu@gmail.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH 07/10] PM: hibernate: build one bio per contiguous run of the image
Date: Tue, 15 Sep 2026 12:16:55 +0900
Message-Id: <20260915031658.1505680-8-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915031658.1505680-1-youngjun.park@lge.com>
References: <20260915031658.1505680-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3C5E080004
X-Stat-Signature: se535qqzprfjthzj4h7oz4ofixot6473
X-Rspam-User: 
X-HE-Tag: 1789442229-106025
X-HE-Meta: U2FsdGVkX1+OKV1nn/Mq2SAw/gCCsR3O0Pt/4xKlW3K4c536F5zvAJwB4iW7tLqIzHxBYeUkPwfEIf+1khoukM0IjwsUM8klYQXQD/L++5YO/HDP9i6zSI6JToHl+aqQMTX6Cz26oWwu0YWIK8yPvP+JcqXe5JBCaotxEkTuEUK5Ou+idwbQSyBjP9A9+FNVKQQbiC0/ggiQsKmWdkT1OEKi1z1s+JPqZdL8wE9F9h3+WMJ3NEzI7F9K1WE2ZBy6dHmqnAxl8Y30V9zDYEhsjR3hIuFD3ZlUIAw86Su+hmx0pVs2qfjwQghb1U2oPbT4WJwPbNUhiKjdMiA2UT0do8lL6UnpYBY5P4WQTKKbhRz0UcBKLkyXLroSdjocTdDT6bsxDzizr64/aHrtFD43miD1J34GMBNTXXxb2FtxdD94mmJymxheXhzB1nKu9EU/9jjjY5dX6BZhC6fyw00zPeDR7+TGbTJzR4VEopRW99GiE4fdG7NFZsO4UhSY4J4siBCu6VoJp1Frb1yJSqeJbIKksz9/G8Z2l/1XAY5e60vCVGRg1hrBKxOqm632G0WQkgczkzIrAkx0oNHHxdXBaQqHJHfntLQA9XY1qYbE8TDuiuXLBfOi4uPKfjFdALUOQSBJ0zhL4IexJnHzWKCX23LyOdTQQaBTNuQRj+IQlbcftRsmBvYuUzjQWOQZcq/gtZ80Vjs1xBzw+VwT07DmzqS42Xb02jJsA63zOy96nZBp5+C3mi9RBBTy/3WOlX8gwqtcnFILAFiepwoFquFuTD0k2f5tsnKo4LWBj3/72tDIlDVQf7e3mTf0/B09X18sGoQRbQbhfbm/4qT4RRdv9rXR+F9aPNe9KJC4++rpbUoRR26qIDgMCiBLUfVdpVOqbGetHkkBBsLQwbpxANy9+LHMM3n15FHOpHqUhd2ODVmuAt0J81WOtQ3+9sbk+Po39RrCXKfF5NrfXli4yu6
 DfqoDaVs
 EbTUl8HB/4Frw+cFfpj0RHtVprWqMi3cUBhFY/r4QnUf/KuqP6xxgJH22ItXEbio9kmLi0W6fOjYAdxNjOp1gC8ijK2FDsJDDyrqy8GDwgFtR6iC1e/7Z1I1SjPla5sW+Aw0T6E7aHERcEMPv90bXA5P3Yo65i3a7jD/1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The image is written with a bio per page, and the block layer merges
them back into requests.  A 5G image takes about 1.3M bio allocations
and nearly as many merges.

One page per bio dates from when the page lock was the completion
signal.  Commit 343df3c79c62 ("suspend: simplify block I/O handling")
removed that constraint, but the bio per page stayed.

Keep filling one bio while the next page follows the last one, and
submit it when the run breaks or the bio is full.  Size the bio from
the device limits.  Reads are unchanged.

The compressed path writes the image in rounds and waits for its
threads between them.  Submit the bio at the end of each round, so the
last pages of a round do not wait for the next one.

Without compression, a 5G image now takes about 12.7K bios, and writing
it on a VM took 12 to 15% less time.

Assisted-by: Claude:claude-fable-5
Assisted-by: Claude:claude-opus-5
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 kernel/power/swap.c | 96 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 88 insertions(+), 8 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 09c6c50bf837..34e47c662798 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -252,25 +252,55 @@ struct hib_bio_batch {
 	wait_queue_head_t	wait;
 	blk_status_t		error;
 	struct blk_plug		plug;
+	struct bio		*cur;		/* write bio still being filled */
+	unsigned int		max_pages;	/* what the device takes at once */
+	unsigned int		nr_pages;	/* what the next bio is sized for */
 };
 
+/* How much of the image the device is willing to take as one request. */
+static unsigned int hib_bio_max_pages(struct block_device *bdev)
+{
+	unsigned int pages = queue_max_bytes(bdev_get_queue(bdev)) >> PAGE_SHIFT;
+
+	pages = min_t(unsigned int, pages, bdev_max_segments(bdev));
+	return bio_max_segs(max(pages, 1U));
+}
+
 static void hib_init_batch(struct hib_bio_batch *hb)
 {
 	atomic_set(&hb->count, 0);
 	init_waitqueue_head(&hb->wait);
 	hb->error = BLK_STS_OK;
+	hb->cur = NULL;
+	hb->max_pages = hib_bio_max_pages(file_bdev(hib_resume_bdev_file));
+	hb->nr_pages = 1;
 	blk_start_plug(&hb->plug);
 }
 
+/* Hand over the bio being filled, if there is one. */
+static void hib_submit_cur(struct hib_bio_batch *hb)
+{
+	struct bio *bio = hb->cur;
+
+	if (!bio)
+		return;
+
+	hb->cur = NULL;
+	atomic_inc(&hb->count);
+	submit_bio(bio);
+}
+
 static void hib_finish_batch(struct hib_bio_batch *hb)
 {
+	hib_submit_cur(hb);
 	blk_finish_plug(&hb->plug);
 }
 
 static void hib_end_io(struct bio *bio)
 {
 	struct hib_bio_batch *hb = bio->bi_private;
-	struct page *page = bio_first_page_all(bio);
+	struct bvec_iter_all iter_all;
+	struct bio_vec *bv;
 
 	if (bio->bi_status) {
 		pr_alert("Read-error on swap-device (%u:%u:%Lu)\n",
@@ -278,11 +308,16 @@ static void hib_end_io(struct bio *bio)
 			 (unsigned long long)bio->bi_iter.bi_sector);
 	}
 
-	if (bio_data_dir(bio) == WRITE)
-		put_page(page);
-	else if (clean_pages_on_read)
-		flush_icache_range((unsigned long)page_address(page),
-				   (unsigned long)page_address(page) + PAGE_SIZE);
+	/* A write bio carries as many pages as the image was contiguous for. */
+	bio_for_each_segment_all(bv, bio, iter_all) {
+		struct page *page = bv->bv_page;
+
+		if (bio_data_dir(bio) == WRITE)
+			put_page(page);
+		else if (clean_pages_on_read)
+			flush_icache_range((unsigned long)page_address(page),
+					   (unsigned long)page_address(page) + PAGE_SIZE);
+	}
 
 	if (bio->bi_status && !hb->error)
 		hb->error = bio->bi_status;
@@ -298,17 +333,53 @@ static int hib_submit_io_sync(blk_opf_t opf, pgoff_t page_off, void *addr)
 			page_off * (PAGE_SIZE >> 9), addr, PAGE_SIZE, opf);
 }
 
+/*
+ * The image goes out a page at a time.  Keep filling one bio for as long as
+ * the next page lands right after the last, so that pages that are
+ * consecutive on the device reach it as one request rather than as many that
+ * the block layer then has to merge.
+ */
 static int hib_submit_io_async(blk_opf_t opf, pgoff_t page_off, void *addr,
 			 struct hib_bio_batch *hb)
 {
+	sector_t sector = page_off * (PAGE_SIZE >> 9);
+	bool write = op_is_write(opf);
 	struct bio *bio;
 
-	bio = bio_alloc(file_bdev(hib_resume_bdev_file), 1, opf,
+	if (write && hb->cur) {
+		bool contiguous = bio_end_sector(hb->cur) == sector;
+
+		if (contiguous && hb->cur->bi_vcnt < hb->cur->bi_max_vecs) {
+			bio_add_virt_nofail(hb->cur, addr, PAGE_SIZE);
+			return 0;
+		}
+
+		/*
+		 * Size the next bio for what the image has just shown.  A run
+		 * that carried on past this bio, or a bio that took more than
+		 * one page, says there are runs here worth the room.  Anything
+		 * else is an image in pieces, and a single page is all it can
+		 * use.
+		 */
+		hb->nr_pages = contiguous || hb->cur->bi_vcnt > 1 ?
+			       hb->max_pages : 1;
+
+		hib_submit_cur(hb);
+	}
+
+	bio = bio_alloc(file_bdev(hib_resume_bdev_file),
+			write ? hb->nr_pages : 1, opf,
 			GFP_NOIO | __GFP_HIGH);
-	bio->bi_iter.bi_sector = page_off * (PAGE_SIZE >> 9);
+	bio->bi_iter.bi_sector = sector;
 	bio_add_virt_nofail(bio, addr, PAGE_SIZE);
 	bio->bi_end_io = hib_end_io;
 	bio->bi_private = hb;
+
+	if (write) {
+		hb->cur = bio;
+		return 0;
+	}
+
 	atomic_inc(&hb->count);
 	submit_bio(bio);
 	return 0;
@@ -316,6 +387,9 @@ static int hib_submit_io_async(blk_opf_t opf, pgoff_t page_off, void *addr,
 
 static int hib_wait_io(struct hib_bio_batch *hb)
 {
+	/* Nothing will complete a bio that was never handed over. */
+	hib_submit_cur(hb);
+
 	/*
 	 * We are relying on the behavior of blk_plug that a thread with
 	 * a plug will flush the plug list before sleeping.
@@ -917,6 +991,12 @@ static int save_compressed_image(struct swap_map_handle *handle,
 			}
 		}
 
+		/*
+		 * Submit the rest of the round now.  Otherwise it can wait in
+		 * the bio until the next round fills it.
+		 */
+		hib_submit_cur(&hb);
+
 		wait_event(crc->done, atomic_read_acquire(&crc->stop));
 		atomic_set(&crc->stop, 0);
 	}
-- 
2.48.1


