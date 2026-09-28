Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1190FC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299BD6B0096; Mon, 28 Sep 2026 04:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A356B00A0; Mon, 28 Sep 2026 04:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1886C6B00A1; Mon, 28 Sep 2026 04:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F09EC6B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:22:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75637C0137
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:22:29 +0000 (UTC)
X-FDA: 85262479218.30.1A1D7FC
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9995A100002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:22:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790583747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X2uriLCFGZy1QHkhY/Zdw6QMPSEHoHlOXHAMrv3yb+Y=;
	b=YaZ+6Yqu2Rds1qhEcJZ8StDO0ADpoMkqa7QeJ3NXDuVlcfdG9ir7oONSjlAAzx8m89M7TE
	AbMl5OjTjsu7qO6S2zh2CUfwJDIJiN1+bm5xnrApY8uxhXDBQ0rIgvs5stJGVfdmEugwlB
	/h7enubbsn7H7MP+udBy6zIX35eC1tI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790583747;
	b=ON05DNBYILuNQhwOei7sNFnDHgJG6Au2h4s/EVLco0P8CL2hhWVVexyvc4lsZ9J3Az4rHl
	b+LQCwLZaxJSf3HXP6pxzJCgZFtIwbGw4c38njF1S0KHzhaQZHfRgvSHpJLZbIiAE5bNU8
	lC5FMVK7Z+Yaxr+f2k1cxH7SEN6KAYg=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 1C93F3EBA1;
	Mon, 28 Sep 2026 08:22:23 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH 3/4] mm/zswap: allow writeback to be throttled by the cgroup IO controllers
Date: Mon, 28 Sep 2026 10:18:38 +0200
Message-ID: <20260928081900.4187482-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928081900.4187482-1-alex@ghiti.fr>
References: <20260928081900.4187482-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEW6N0v/qhbP15hg7rOtVRroKWhPIQwcq/TVt0qEZDhT+eUHNB5EQJEYoFuoBx9qmMf9D2NwLWxd+d/fibAsDoF8JQVfAcRijfNdurquHJPescUKhuoiULW+oLv+b1vYSyAI916kdOv/Q1kOdPYUQv5Y6Y2UnOafceg2u84CLd8giuFKsAY6iUfyh1IilMhqnUHFuHdNUeqpGxAfL0MQv0xA3bdtFYg3UkeqvM+hh6FGR35z7hxyf2k/2W1TpUTyr9yKMGdnlHJysoSILZdKapVYfY4huAkx9McOMFIJNffUjSUU1FqF8CNOP4hpapHQzU35sos8POl5KBYenunmngIoa3Zq0hQ3IavtSZxCqnU4f5J/ImKy3j5SLbeDTywKsP96a6D9RVNBVEbSzPOxcc/JxQ4cTrQisYytX+kcF+fehOw9Nb6VTh4h25eh9vgujk7J8FA5OWo3oFmiCn1DETgJCE3kM8zxbbhoIrzJLnGLD1L3p2Ra1hmXqMS2QLyI5GNzYV7VMR8cIVE39umIrLNxLfDp9I71MuX7FYnEKwL/bM5QIZzzxkyJixOIscQTZRuraPIPreFOl5ATqrpEAcje1d2fM2RrwDFBMYuRheyF0JvUoFicil7eMbQT4oLDrJbcPtPUN+be7QFP5ttyzuwSlSpNDINMBFzDO+R2eJRXA
X-Stat-Signature: 7oi4fen5ocddythno6pqicz9bexjbdmz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9995A100002
X-HE-Tag: 1790583747-141116
X-HE-Meta: U2FsdGVkX1+yNhhp2TgHi4I/CWjocutZI0v4md0Rd/K7E+59LZZI6uS1YxdT3CYfyvjWXXK2CWtaTYef/72ibBKKchD1On+ArdoyPDprpkZygY9+tITKHXjC4+XZDrH6kXjNPJ7AQLG1TiTp634R0eobLUS81Wj0sNgv1BkPC4q0jHEaZ5aZNIClNxf3F+fXg+nADkPnToIbRYNnjFjPfn9TyT6Q1G3Se5Uo1nuMcOWkvuzVTKe+PAK4ioAUjssj4D85rCKWFlta5IXidvGKZ/J2tQhgKneAkh6yzhHF7CHqFqLh9MWHSwYjXfh6KGY2COn/9E7zBB/YX8Z5PsqUW2RGt35zBW1rqlWpn255T39OlS8eYHWgU9BDQy9yjmF//o804W1JkNk9AFN/8J/1oqV0qWxx6661IRUYZG2tUvKisqpWJpNlmaxbyrMGYUQBTxleml1rN5UgexfzcE4cit4ltWpoqX1R5ZylFBUGIu15N/z2XK3fcjCk3h9gKshOR+vA8W6uaVI5VenopoeGh6hKMNN+huvdPGRbdll1OcKOFE3Y1bJJGRRFIABGoRSY3xy2SUWo3Tu/r6TqZ/0itoJo0Ai9sxutY2awu80p7d9VKbhyHhG1EkL+ei1FNqqEJQ8OaYDKLrCyN8SNT0jeVA1qLFiOMwQtf+ctcXpwAVNbmGeW8+Pl/eGU1KflSjGA7KiN6krh8k6Kf1p6QvoLxghYWGwPeuncAHfMg3Tw46D9+fFpv+MHjNIRNjlMtkHqneFPwC85xvfPhMq2ueEQYFlA8QZiIJoodhAYqPsy9XOxftRtFO9BwybEqEpPgNv5rMOKSdwFLgV134Nd51oywblDbNxNLdvf3Wjd8J83ZtZ7SmLc4yMpzjqACMiP9IPKmR0uJpi5Ak7R6bM/JOqIoTHnotn2nKn+8LVJX+BeSDEpGMDMg8m2hNXQMrg+ImPqq2plhal2B5qiECyQz1e
 mTQx5Jt5
 /6tUX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bio_issue_as_root_blkg() exempts REQ_SWAP bios from the cgroup IO
controllers. The exemption avoids priority inversion: reclaim issues
swap writes on behalf of the whole system, so making them wait on one
cgroup's IO budget stalls memory reclaim for everyone.

For zswap writeback the exemption does harm: the write is charged to the
cgroup's IO budget anyway, afterwards, but is issued ahead of the
synchronous swapin and page cache reads that the workload blocks on.

Let zswap writeback opt out of it with REQ_BACKGROUND.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/swap_ops.h |  1 +
 mm/page_io.c             |  7 +++++--
 mm/zswap.c               | 20 ++++++++++++++++----
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
index 57ac6c703f68..152598ce6c4f 100644
--- a/include/linux/swap_ops.h
+++ b/include/linux/swap_ops.h
@@ -17,6 +17,7 @@ struct swap_iocb {
 struct swap_io_ctx {
 	struct swap_iocb	*sio;
 	struct swap_info_struct	*sis;
+	bool			throttled;
 };
 
 /*
diff --git a/mm/page_io.c b/mm/page_io.c
index 88962571cb93..14dd54ae6d65 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -591,9 +591,12 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 {
 	struct swap_iocb *sio = ctx->sio;
 	struct bio *bio = &sio->bio;
+	blk_opf_t opf = REQ_OP_WRITE | REQ_SWAP;
 
-	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs),
-			REQ_OP_WRITE | REQ_SWAP);
+	if (ctx->throttled)
+		opf |= REQ_BACKGROUND;
+
+	bio_init(bio, ctx->sis->bdev, sio->bvecs, ARRAY_SIZE(sio->bvecs), opf);
 	bio->bi_iter.bi_size = sio->len;
 	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
 	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
diff --git a/mm/zswap.c b/mm/zswap.c
index 8925b6100402..3b902f29ed4c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -983,16 +983,21 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
  * in the first place.  After the folio has been decompressed into
  * the swap cache, the compressed version stored by zswap can be
  * freed.
+ *
+ * @throttled lets the cgroup IO controllers throttle the write rather than
+ * issue it as root.
  */
 static int zswap_writeback_entry(struct zswap_entry *entry,
-				 swp_entry_t swpentry)
+				 swp_entry_t swpentry, bool throttled)
 {
 	struct xarray *tree;
 	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
-	struct swap_io_ctx ctx = {};
+	struct swap_io_ctx ctx = {
+		.throttled = throttled,
+	};
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1070,8 +1075,14 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
  *
  * ZSWAP_SHRINK_SWAPCACHE (out) is set when the walk stopped at an entry whose
  * folio is already in the swap cache.
+ *
+ * ZSWAP_SHRINK_THROTTLED (in) lets the cgroup IO controllers throttle the
+ * writeback rather than issue it as root. Only the memory pressure shrinker
+ * sets it. The pool limit path must not: once the pool is full zswap_store()
+ * rejects everything until this writeback drains it.
  */
 #define ZSWAP_SHRINK_SWAPCACHE	BIT(0)
+#define ZSWAP_SHRINK_THROTTLED	BIT(1)
 
 /*
  * The dynamic shrinker is modulated by the following factors:
@@ -1154,7 +1165,8 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	 */
 	spin_unlock(&l->lock);
 
-	writeback_result = zswap_writeback_entry(entry, swpentry);
+	writeback_result = zswap_writeback_entry(entry, swpentry, flags &&
+						 (*flags & ZSWAP_SHRINK_THROTTLED));
 
 	if (writeback_result) {
 		zswap_reject_reclaim_fail++;
@@ -1180,7 +1192,7 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
 	unsigned long shrink_ret;
-	unsigned int flags = 0;
+	unsigned int flags = ZSWAP_SHRINK_THROTTLED;
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
-- 
2.53.0-Meta


