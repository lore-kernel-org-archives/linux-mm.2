Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A897CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 08:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25608E0010; Thu, 23 Oct 2025 04:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86E68E0002; Thu, 23 Oct 2025 04:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4D38E0010; Thu, 23 Oct 2025 04:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98DA68E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:09:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A6E71A0A6F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:09:44 +0000 (UTC)
X-FDA: 84028655088.17.9C9457A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id BC148140007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:09:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="Mb0vr/j0";
	spf=none (imf23.hostedemail.com: domain of BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761206982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpc0/oTbiT2STaKCBvQviFlMlMp15zKW554qjP8LCbs=;
	b=k9gftAB/vuiOSsu0z+tZ6kUs42MOavjZHphy3MqwGnUfKp1jDa0GXCe04a4JJZvpy8xHTa
	x150/OIdfdAcDpn8nJpAzkkWmOEY/wn69siOoWOYJfn7BtZtF+zf0sQ42vUOD/uY+RAGol
	7QF10+A5bIt8PlHCWRc+jKZrV+2jrT0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="Mb0vr/j0";
	spf=none (imf23.hostedemail.com: domain of BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761206982; a=rsa-sha256;
	cv=none;
	b=qAhZWMF1dMFVhV6HDK2tBUKLh6XKdqO4d8sL0rZM6PJsuiNamqQdT36cxuw2yR1OpSu24R
	T25mWZEv0+Fgl1Be7vEH6xTonAH85pVxhje3CwN6RTgq9JhxK5w8HBGS4Qk78WDwejP5q9
	RlmyjOTSx0UgnUwpKuDg864CRkIv0uQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jpc0/oTbiT2STaKCBvQviFlMlMp15zKW554qjP8LCbs=; b=Mb0vr/j0mfksZzhiNRJoLi8Tk4
	IbuACWZgF1iT89BN4e+PXSzC8HZAo1CkKIIjwpBoxT3lhOvNf/8x8j0eCU5TStqgoXba3UseUDuOk
	R386CGnk3RYycYu2FzmhRAhLUV7Js+vd/ZcpuacrgYysnRRtPvrTtuvhOP5jVU/IX0mfecjKH+1kz
	tNQwv2tsi+noicg0NCOSJZzhmibOEDcQth4CKGC/tGWoZOMvY6Uax7Jj0/JL6q0n7aaxayx2bVU5k
	Uppn0cGYNSxfxrtbO/ixPFf1+jgnSM9NPZvgY6233UQuOQQg4jgBrP1pMTeYrRs6zz6RtEjZZ5ENG
	sNU0p1nQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBqOA-00000005Tor-2jc3;
	Thu, 23 Oct 2025 08:09:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] block: make bio auto-integrity deadlock safe
Date: Thu, 23 Oct 2025 10:08:56 +0200
Message-ID: <20251023080919.9209-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023080919.9209-1-hch@lst.de>
References: <20251023080919.9209-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: mdgxp8ze9abgkgtaj5jcnwnoyw4pp9ub
X-Rspamd-Queue-Id: BC148140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761206982-58357
X-HE-Meta: U2FsdGVkX19A1rtrTAAOHAK0BT+YEB0wxHqwAz6UqXyvIm+8G/IiTJdL7rGIv+dfonLLLtYds0Cloftg5Y1pnF+UuXmqPgxdGxTN0DRLMT8BD1cfkIn3T1gPL/ILIjBdbIhtFTQEzxvjq1EsqZl3Tm5fqQ7ZIRT2Y6yD9iiIGD+Zq/asCjDbqLDiyuv3c5ACTTHLqlwba9o4RdRy9TZGvjqPNpbNEeNEJCszJz8SANMoe6t8FCFUWbkCSDJa7z62AAPUDIrVMVBM8H3cs5g61GB1bTxulbGlVaI7I0iFGs8CDavUUnVv86U+cZUASPb+cD8AzfSLxm6yIKhxnI4xmQicivDBwq3WqpDfdWcIrCRsR+e0cHl78urNaoC7Fhk8TBDaqdQMfHWIgXfKCx06X80LkKchWU40B6b66qSrzxcmg+5qkX6BXofmJuF5Tzbh5CpZfpj6qjy9SUPQXkERKMmQrgwO19YFgFmOZ6NXfw3n9Ub5j00K400sHrk4fs0g1pTV9rAUTsk1odIUdixrew6MsbQO6ongC+6GyHSYkJeseQPzWgAxleJ6YAuytUWG4CwyJYGYv7wNbqRVu2faK5V+nmXKz7UP+HB/7OC6Hmj6IICdsFNgmcR4Emjzims4i9oBAF8YpeWEByQCDBMUuRFDDnh0202ROiSyzxSnn2eDB631ADNmkyS+0+wAUEJnP2D2jVJNMHeZr3FznLHMVgtI35xMo3zkWFJPbuHz9Umj8M7DwpgPB3qQDR8nBFYgSg4p/vmXkQ/K2jabq+O6s+ZfrtIH0Ov/qT9UYe10qHHzpz49SpwQplnliFlW5Jv6rd14Femx8/tmdmLgN9mZvrKC7jkKvxJjylJBZqkaZQHkKeAEdWHxtYnL9n1eSHslg23VwVAgVS90lZn95NWr3e8GPm7baPH2g9JMP2Zp0G6bnCLa0/u8IvSG3b5OpvgrWe3eCbrPCxarhh6DCKc
 sqH6MAKW
 MSC3/5eGkZSrJIeEZHHJAabFUVXN43kGcyXIkB0VlPDlwiJQGkfeix4/xzScqbE46X2lVSemAeb/XDtWfQo4zzWTIEvjMIlRhPjwgXOLvlxmc0oJNyo4B8irBjfsTjc4MltqkqzKMw2JK7c4PlY2cVN5ApBaMyYzr5awD+VxLA8wp/OOPgj8KtQAVMi1/o17MT6mqekt0Cdqce1s1tNCZLhbiharmlsKdwe7RPHOZBph361hAQIWBNrkUHGFOk2Brzge2SqHYHRreM0puOq6buJ4lYBLuwIwl2vXPiPHqdq2NccVuBl2qXK8c784N5TqghGNVsjERgirqDt/8M7Ge/sCeHj6LCxz6uzej5BK2lU4Iy3QB2g3lYa7EL0B4rZLWAnkL1AFv/9F1MeU8wcN/OzKs+UJdg4M32GQnwChDNSwwqE2G0k+jryDfJAimA9NSxJw3vQn05D/+ZimpUbE+ctXl+3tNYVvhiiGnfnY2VVB+4zuznDeNOw+NopuMXtJE2w7OL6umW1OZfic3HryPTu2HCp0GcXyVMajAaceQb5pYM0Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current block layer automatic integrity protection allocates the
actual integrity buffer, which has three problems:

 - because it happens at the bottom of the I/O stack and doesn't use a
   mempool it can deadlock under load
 - because the data size in a bio is almost unbounded when using lage
   folios it can relatively easily exceed the maximum kmalloc size
 - even when it does not exceed the maximum kmalloc size, it could
   exceed the maximum segment size of the device

Fix this by limiting the I/O size so that we can allocated at least a
2MiB integrity buffer, i.e. 128MiB for 8 byte PI and 512 byte integrity
internals, and create a mempool as a last resort for this maximum size,
mirroring the scheme used for bvecs.  As a nice upside none of this
can fail now, so we remove the error handling and open code the
trivial addition of the bip vec.

The new allocation helpers sit outside of bio-integrity-auto.c because
I plan to reuse them for file system based PI in the near future.

Fixes: 7ba1ba12eeef ("block: Block layer data integrity support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity-auto.c    | 22 +++-------------
 block/bio-integrity.c         | 47 +++++++++++++++++++++++++++++++++++
 block/blk-settings.c          | 11 ++++++++
 include/linux/bio-integrity.h |  6 +++++
 include/linux/blk-integrity.h |  5 ++++
 5 files changed, 72 insertions(+), 19 deletions(-)

diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
index 2f4a244749ac..9850c338548d 100644
--- a/block/bio-integrity-auto.c
+++ b/block/bio-integrity-auto.c
@@ -29,7 +29,7 @@ static void bio_integrity_finish(struct bio_integrity_data *bid)
 {
 	bid->bio->bi_integrity = NULL;
 	bid->bio->bi_opf &= ~REQ_INTEGRITY;
-	kfree(bvec_virt(bid->bip.bip_vec));
+	bio_integrity_free_buf(&bid->bip);
 	mempool_free(bid, &bid_pool);
 }
 
@@ -110,8 +110,6 @@ bool bio_integrity_prep(struct bio *bio)
 	struct bio_integrity_data *bid;
 	bool set_flags = true;
 	gfp_t gfp = GFP_NOIO;
-	unsigned int len;
-	void *buf;
 
 	if (!bi)
 		return true;
@@ -152,17 +150,12 @@ bool bio_integrity_prep(struct bio *bio)
 	if (WARN_ON_ONCE(bio_has_crypt_ctx(bio)))
 		return true;
 
-	/* Allocate kernel buffer for protection data */
-	len = bio_integrity_bytes(bi, bio_sectors(bio));
-	buf = kmalloc(len, gfp);
-	if (!buf)
-		goto err_end_io;
 	bid = mempool_alloc(&bid_pool, GFP_NOIO);
 	bio_integrity_init(bio, &bid->bip, &bid->bvec, 1);
-
 	bid->bio = bio;
-
 	bid->bip.bip_flags |= BIP_BLOCK_INTEGRITY;
+	bio_integrity_alloc_buf(bio, gfp & __GFP_ZERO);
+
 	bip_set_seed(&bid->bip, bio->bi_iter.bi_sector);
 
 	if (set_flags) {
@@ -174,21 +167,12 @@ bool bio_integrity_prep(struct bio *bio)
 			bid->bip.bip_flags |= BIP_CHECK_REFTAG;
 	}
 
-	if (bio_integrity_add_page(bio, virt_to_page(buf), len,
-			offset_in_page(buf)) < len)
-		goto err_end_io;
-
 	/* Auto-generate integrity metadata if this is a write */
 	if (bio_data_dir(bio) == WRITE && bip_should_check(&bid->bip))
 		blk_integrity_generate(bio);
 	else
 		bid->saved_bio_iter = bio->bi_iter;
 	return true;
-
-err_end_io:
-	bio->bi_status = BLK_STS_RESOURCE;
-	bio_endio(bio);
-	return false;
 }
 EXPORT_SYMBOL(bio_integrity_prep);
 
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index bed26f1ec869..a9896d563c1c 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -14,6 +14,44 @@ struct bio_integrity_alloc {
 	struct bio_vec			bvecs[];
 };
 
+static mempool_t integrity_buf_pool;
+
+void bio_integrity_alloc_buf(struct bio *bio, bool zero_buffer)
+{
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+	unsigned int len = bio_integrity_bytes(bi, bio_sectors(bio));
+	gfp_t gfp = GFP_NOIO | (zero_buffer ? __GFP_ZERO : 0);
+	void *buf;
+
+	buf = kmalloc(len, try_alloc_gfp(gfp));
+	if (unlikely(!buf)) {
+		struct page *page;
+
+		page = mempool_alloc(&integrity_buf_pool, GFP_NOFS);
+		if (zero_buffer)
+			memset(page_address(page), 0, len);
+		bvec_set_page(&bip->bip_vec[0], page, len, 0);
+		bip->bip_flags |= BIP_MEMPOOL;
+	} else {
+		bvec_set_page(&bip->bip_vec[0], virt_to_page(buf), len,
+				offset_in_page(buf));
+	}
+
+	bip->bip_vcnt = 1;
+	bip->bip_iter.bi_size = len;
+}
+
+void bio_integrity_free_buf(struct bio_integrity_payload *bip)
+{
+	struct bio_vec *bv = &bip->bip_vec[0];
+
+	if (bip->bip_flags & BIP_MEMPOOL)
+		mempool_free(bv->bv_page, &integrity_buf_pool);
+	else
+		kfree(bvec_virt(bv));
+}
+
 /**
  * bio_integrity_free - Free bio integrity payload
  * @bio:	bio containing bip to be freed
@@ -438,3 +476,12 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	return 0;
 }
+
+static int __init bio_integrity_initfn(void)
+{
+	if (mempool_init_page_pool(&integrity_buf_pool, BIO_POOL_SIZE,
+			get_order(BLK_INTEGRITY_MAX_SIZE)))
+		panic("bio: can't create integrity buf pool\n");
+	return 0;
+}
+subsys_initcall(bio_integrity_initfn);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index d74b13ec8e54..04e88615032a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -194,6 +194,17 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 					(1U << bi->interval_exp) - 1);
 	}
 
+	/*
+	 * The block layer automatically adds integrity data for bios that don't
+	 * already have it.  It allocates a single segment. Limit the I/O size
+	 * so that a single maximum size metadata segment can cover the
+	 * integrity data for the entire I/O.
+	 */
+	lim->max_sectors = min3(lim->max_sectors,
+		BLK_INTEGRITY_MAX_SIZE /
+			bi->pi_tuple_size * lim->logical_block_size,
+		lim->max_segment_size >> SECTOR_SHIFT);
+
 	return 0;
 }
 
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 851254f36eb3..3d05296a5afe 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -14,6 +14,8 @@ enum bip_flags {
 	BIP_CHECK_REFTAG	= 1 << 6, /* reftag check */
 	BIP_CHECK_APPTAG	= 1 << 7, /* apptag check */
 	BIP_P2P_DMA		= 1 << 8, /* using P2P address */
+
+	BIP_MEMPOOL		= 1 << 15, /* buffer backed by mempool */
 };
 
 struct bio_integrity_payload {
@@ -140,4 +142,8 @@ static inline int bio_integrity_add_page(struct bio *bio, struct page *page,
 	return 0;
 }
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
+
+void bio_integrity_alloc_buf(struct bio *bio, bool zero_buffer);
+void bio_integrity_free_buf(struct bio_integrity_payload *bip);
+
 #endif /* _LINUX_BIO_INTEGRITY_H */
diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index b659373788f6..c2030fd8ba0a 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -8,6 +8,11 @@
 
 struct request;
 
+/*
+ * Maximum contiguous integrity buffer allocation.
+ */
+#define BLK_INTEGRITY_MAX_SIZE		SZ_2M
+
 enum blk_integrity_flags {
 	BLK_INTEGRITY_NOVERIFY		= 1 << 0,
 	BLK_INTEGRITY_NOGENERATE	= 1 << 1,
-- 
2.47.3


