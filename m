Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44BEACCF9FA
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A87FE8E00F5; Fri, 31 Oct 2025 05:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5F258E0042; Fri, 31 Oct 2025 05:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927908E00F5; Fri, 31 Oct 2025 05:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E79F8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:36:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B2931A0430
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:36:08 +0000 (UTC)
X-FDA: 84057903216.11.E2A1B35
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id A769E40002
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:36:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yWkOZnV2;
	spf=none (imf04.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761903366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qmGTgW6afJ0vFRkby/75JyZyQGwop0nHFOHEgGPVxKU=;
	b=x7RTRUhekC2e04vMc3OJ2NtHrj0ffc6g9c02vd3oyfzsHDR6ZtBScxr7VqyS2jnUXu1nq8
	qsrmoWdVfjwtQG66zk/CPncmtVUCW6IzJ67wsyK5L2Bw6e8hYrHKQ98APTo7X2r5t/TmBM
	QlxaofoK3g4f1QFVxDOi7WH9lj/DKmI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=yWkOZnV2;
	spf=none (imf04.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761903366; a=rsa-sha256;
	cv=none;
	b=kXCVoamObXJtP6PIgf6loCBf7dqhaR9kIsX2022zb+YyoSU5iUcjvUyvGsnIKZW/WeYpC6
	cI8RuKk8DrEUaVsd6IUCHiCtm75UyEzQy1zK91mYppU1tQI+ehBHJInu+Bfi6mOHb/Hm3h
	9nBmGXt1+ahneB25gvEs+8GHl0xlZaU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qmGTgW6afJ0vFRkby/75JyZyQGwop0nHFOHEgGPVxKU=; b=yWkOZnV2bEuSbAIehLiPLmhkPK
	GjNEKIFCvxWDjwumscvvswqQFBSHuG5QTDS7dNM8H37vxG2W2S3GOYOAxdyqNM9/bPaHYw0Huq6yo
	mJFyCL4Fq50xFDidQL3pkWcd2FCV5kOxyoMCof/wFBHEM8VHc3oja7T0M6JtQBd1t03HFFStlINXN
	SUK9D+WtRKnpPoCgEmL2LivCVml+I4o39InWHigt81MM/gXoC5yUs97sHc8JgwuxMIXGIi44m8tF1
	MFsvruFP6eykpn4bd+ggguWwJjYCnGM9/pacIEDnSstwJRSlQGKxNwPVQwjofxAbvUGAMj++u73VI
	eS1CZN1g==;
Received: from [2001:4bb8:2dc:1001:a959:25cf:98e9:329b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vElYA-00000005otI-3gOH;
	Fri, 31 Oct 2025 09:36:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/9] blk-crypto: use on-stack skciphers for fallback en/decryption
Date: Fri, 31 Oct 2025 10:34:38 +0100
Message-ID: <20251031093517.1603379-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251031093517.1603379-1-hch@lst.de>
References: <20251031093517.1603379-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A769E40002
X-Stat-Signature: db6tghr88fuij3opkjahc85gfzffusyw
X-Rspam-User: 
X-HE-Tag: 1761903366-972886
X-HE-Meta: U2FsdGVkX1+17jWu+Iw8QlLIIsUOg6o6JQ5WDk81qPLhYZoMNyIhqOKiWrvd+cZBPmcGq2sCcrsc7a+ZZqpvfXh+KlSLwPOc9ZbxEw/lfW8sbBjwVoUT3kQeTkzC2H3D8cwzUVKFSEqRGO6SypCDkt52UPF8w8TwL9WUEz3qbrjbvvcriyH+4PUNjpAuX85ryel4OYa+LorhgzYuCwssOnK2+bpglldigtmXnbgchI4RTl1HzuLG2C74FjrfQtboTsF6VlAxR4F3FmVaA9Q2hXmuaAHq/jCVZzcqRbozJWP3fTd0KC//V1p/opuaAQd1c4n+I9MDvmrMZ5Q7Z0Dse2XnejAeDcyCjKXFxJkozR9WXJ/NmBdrgW5oGjvd01w91i3nKlh1GOtQsDl9EVoWnZ0ELGT+YThkA2BlAosia9+auUkdB8xW260ti44enMLa/fWTM5YW1fVb+KqZpRBYwO2Yke3sOZ9UTCcCKqcJ6mTTm3AHJaduJm9daAHGz+Xrq+kABEu9k8k7X8j/NVLgfJCjXruYf+Rp30ugX7mU6FwEQ55ko4rJ6JIGvODASldZYU0XVZRdIvDOKTkQ2kq4FZO3UPR2SfjaTwH8Ke9gSJdeg0FzWT0+ZpDYcLWWRbCG5gQuMtslprshaNJwv/tQ5h3MODdb4nrjFelOQhIWolwlY1GtdlCV19TfKHsQNeodT4V+/uOwjwWRmeLWcEyC7Eysn5Fvu3K0n0iCs2KqiZsXcvi5wS0UM0wS+wAWoCBRVs2OgGlrBiH9vlyEOwgMk+Q5KRyV7W0z27cYQQ6tPTZ9WDdu/JS38bC9cW8VA3o6wxgm9GKFjT2scBIpDZwCE/dpaA7ZN3tp/b1IE554DWo72DQvKkLhAHMFPfDgjtKaB/2lXD8wZPkoLXmZzTcjVWnHEHtqWi0PA2ugIqaG0yQjgkD8NWY9aqMQnEgb0rXqG3j2iuVNrrk14a+2rpb
 G+3bzfhf
 o4nbbj7v1cATWhQVJcgOeL5GdUnUUOXgd1v7YwoHTE+N1hFm2a+j77glJRHL8T2IoGqkg7WTxx664Xl5ezVpHpuHlQt5xKzjhXpK/gkKa0PfOKw4SyCD1v1CzC+sgv0H2+GjJZJUr3jY9S2352kyFoojGayUcYEOap5KOzhhwC/8n5EaC+PSGyI2n+CcfUGyxdLPdw/bJcxgy2lgMJz10MfhuWrwoO7NU9ziWsrXT4fmBjhucpmpYQF/bm3twJqRzAIWtRgJ9yy8cDsznuLMLsOcfwb1So2EDaIu2xOvn613fA4nyHAzcktjLeEGLAWELpIQC7546pr3+XSi/HKx3chfikHbl7GJs8SWvpog0OxBGVV53eLm3XyzE3+qnv/SWbX0jHJhJ2tIUbZc5i5HtUdlMh7W9U3cLfTyAFQJ6HtMuQ8FPJPt/JlbTgX02Qh6yw98OncEMXm8la0K/Su15UoT4jPE9DZo3VZNh+q2NQj3hQerxWp4WZD9QmH8oVdE1NzydXXQtSjP3xbVP896C8X7eMcfRHwSZD37mNIeb+hQd4g0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allocating a skcipher dynamically can deadlock or cause unexpected
I/O failures when called from writeback context.  Sidestep the
allocation by using on-stack skciphers, similar to what the non
blk-crypto fscrypt already does.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-crypto-fallback.c | 170 +++++++++++++++++-------------------
 1 file changed, 78 insertions(+), 92 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 16a1809e2667..33aa7b26ed37 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -75,7 +75,7 @@ static bool tfms_inited[BLK_ENCRYPTION_MODE_MAX];
 
 static struct blk_crypto_fallback_keyslot {
 	enum blk_crypto_mode_num crypto_mode;
-	struct crypto_skcipher *tfms[BLK_ENCRYPTION_MODE_MAX];
+	struct crypto_sync_skcipher *tfms[BLK_ENCRYPTION_MODE_MAX];
 } *blk_crypto_keyslots;
 
 static struct blk_crypto_profile *blk_crypto_fallback_profile;
@@ -98,7 +98,7 @@ static void blk_crypto_fallback_evict_keyslot(unsigned int slot)
 	WARN_ON(slotp->crypto_mode == BLK_ENCRYPTION_MODE_INVALID);
 
 	/* Clear the key in the skcipher */
-	err = crypto_skcipher_setkey(slotp->tfms[crypto_mode], blank_key,
+	err = crypto_sync_skcipher_setkey(slotp->tfms[crypto_mode], blank_key,
 				     blk_crypto_modes[crypto_mode].keysize);
 	WARN_ON(err);
 	slotp->crypto_mode = BLK_ENCRYPTION_MODE_INVALID;
@@ -119,7 +119,7 @@ blk_crypto_fallback_keyslot_program(struct blk_crypto_profile *profile,
 		blk_crypto_fallback_evict_keyslot(slot);
 
 	slotp->crypto_mode = crypto_mode;
-	err = crypto_skcipher_setkey(slotp->tfms[crypto_mode], key->bytes,
+	err = crypto_sync_skcipher_setkey(slotp->tfms[crypto_mode], key->bytes,
 				     key->size);
 	if (err) {
 		blk_crypto_fallback_evict_keyslot(slot);
@@ -195,28 +195,13 @@ static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
 	return bio;
 }
 
-static bool
-blk_crypto_fallback_alloc_cipher_req(struct blk_crypto_keyslot *slot,
-				     struct skcipher_request **ciph_req_ret,
-				     struct crypto_wait *wait)
+static struct crypto_sync_skcipher *
+blk_crypto_fallback_tfm(struct blk_crypto_keyslot *slot)
 {
-	struct skcipher_request *ciph_req;
-	const struct blk_crypto_fallback_keyslot *slotp;
-	int keyslot_idx = blk_crypto_keyslot_index(slot);
-
-	slotp = &blk_crypto_keyslots[keyslot_idx];
-	ciph_req = skcipher_request_alloc(slotp->tfms[slotp->crypto_mode],
-					  GFP_NOIO);
-	if (!ciph_req)
-		return false;
-
-	skcipher_request_set_callback(ciph_req,
-				      CRYPTO_TFM_REQ_MAY_BACKLOG |
-				      CRYPTO_TFM_REQ_MAY_SLEEP,
-				      crypto_req_done, wait);
-	*ciph_req_ret = ciph_req;
+	const struct blk_crypto_fallback_keyslot *slotp =
+		&blk_crypto_keyslots[blk_crypto_keyslot_index(slot)];
 
-	return true;
+	return slotp->tfms[slotp->crypto_mode];
 }
 
 union blk_crypto_iv {
@@ -238,12 +223,12 @@ static void blk_crypto_dun_to_iv(const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
  * encryption, encrypts the input bio using crypto API and submits the bounce
  * bio.
  */
-void blk_crypto_fallback_encrypt_bio(struct bio *src_bio)
+static blk_status_t __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
+		struct crypto_sync_skcipher *tfm)
 {
 	struct bio_crypt_ctx *bc = src_bio->bi_crypt_context;
 	int data_unit_size = bc->bc_key->crypto_cfg.data_unit_size;
-	struct skcipher_request *ciph_req = NULL;
-	struct blk_crypto_keyslot *slot;
+	SYNC_SKCIPHER_REQUEST_ON_STACK(ciph_req, tfm);
 	DECLARE_CRYPTO_WAIT(wait);
 	u64 curr_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 	struct scatterlist src, dst;
@@ -252,27 +237,11 @@ void blk_crypto_fallback_encrypt_bio(struct bio *src_bio)
 	unsigned int nr_segs;
 	unsigned int enc_idx = 0;
 	unsigned int j;
-	blk_status_t blk_st;
 
-	if (!blk_crypto_fallback_bio_valid(src_bio))
-		return;
-
-	/*
-	 * Get a blk-crypto-fallback keyslot that contains a crypto_skcipher for
-	 * this bio's algorithm and key.
-	 */
-	blk_st = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
-					bc->bc_key, &slot);
-	if (blk_st != BLK_STS_OK) {
-		src_bio->bi_status = blk_st;
-		goto endio;
-	}
-
-	/* and then allocate an skcipher_request for it */
-	if (!blk_crypto_fallback_alloc_cipher_req(slot, &ciph_req, &wait)) {
-		src_bio->bi_status = BLK_STS_RESOURCE;
-		goto out_release_keyslot;
-	}
+	skcipher_request_set_callback(ciph_req,
+				      CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP,
+				      crypto_req_done, &wait);
 
 	memcpy(curr_dun, bc->bc_dun, sizeof(curr_dun));
 	sg_init_table(&src, 1);
@@ -332,62 +301,61 @@ void blk_crypto_fallback_encrypt_bio(struct bio *src_bio)
 		nr_segs--;
 	}
 
-	skcipher_request_free(ciph_req);
-	blk_crypto_put_keyslot(slot);
 	submit_bio(enc_bio);
-	return;
+	return BLK_STS_OK;
 
 out_ioerror:
 	while (enc_idx > 0)
 		mempool_free(enc_bio->bi_io_vec[enc_idx--].bv_page,
 			     blk_crypto_bounce_page_pool);
 	bio_put(enc_bio);
-	src_bio->bi_status = BLK_STS_IOERR;
-	skcipher_request_free(ciph_req);
-out_release_keyslot:
-	blk_crypto_put_keyslot(slot);
-endio:
-	bio_endio(src_bio);
+	return BLK_STS_IOERR;
+}
+
+void blk_crypto_fallback_encrypt_bio(struct bio *src_bio)
+{
+	struct bio_crypt_ctx *bc = src_bio->bi_crypt_context;
+	struct blk_crypto_keyslot *slot;
+	blk_status_t status;
+
+	if (!blk_crypto_fallback_bio_valid(src_bio))
+		return;
+
+	status = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
+					bc->bc_key, &slot);
+	if (status == BLK_STS_OK) {
+		status = __blk_crypto_fallback_encrypt_bio(src_bio,
+			blk_crypto_fallback_tfm(slot));
+		blk_crypto_put_keyslot(slot);
+	}
+	if (status != BLK_STS_OK) {
+		src_bio->bi_status = status;
+		bio_endio(src_bio);
+		return;
+	}
 }
 
 /*
  * The crypto API fallback's main decryption routine.
  * Decrypts input bio in place, and calls bio_endio on the bio.
  */
-static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
+static blk_status_t __blk_crypto_fallback_decrypt_bio(struct bio *bio,
+		struct bio_crypt_ctx *bc, struct bvec_iter iter,
+		struct crypto_sync_skcipher *tfm)
 {
-	struct bio_fallback_crypt_ctx *f_ctx =
-		container_of(work, struct bio_fallback_crypt_ctx, work);
-	struct bio *bio = f_ctx->bio;
-	struct bio_crypt_ctx *bc = &f_ctx->crypt_ctx;
-	struct blk_crypto_keyslot *slot;
-	struct skcipher_request *ciph_req = NULL;
+	SYNC_SKCIPHER_REQUEST_ON_STACK(ciph_req, tfm);
 	DECLARE_CRYPTO_WAIT(wait);
 	u64 curr_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 	union blk_crypto_iv iv;
 	struct scatterlist sg;
 	struct bio_vec bv;
-	struct bvec_iter iter;
 	const int data_unit_size = bc->bc_key->crypto_cfg.data_unit_size;
 	unsigned int i;
-	blk_status_t blk_st;
 
-	/*
-	 * Get a blk-crypto-fallback keyslot that contains a crypto_skcipher for
-	 * this bio's algorithm and key.
-	 */
-	blk_st = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
-					bc->bc_key, &slot);
-	if (blk_st != BLK_STS_OK) {
-		bio->bi_status = blk_st;
-		goto out_no_keyslot;
-	}
-
-	/* and then allocate an skcipher_request for it */
-	if (!blk_crypto_fallback_alloc_cipher_req(slot, &ciph_req, &wait)) {
-		bio->bi_status = BLK_STS_RESOURCE;
-		goto out;
-	}
+	skcipher_request_set_callback(ciph_req,
+				      CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP,
+				      crypto_req_done, &wait);
 
 	memcpy(curr_dun, bc->bc_dun, sizeof(curr_dun));
 	sg_init_table(&sg, 1);
@@ -395,7 +363,7 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 				   iv.bytes);
 
 	/* Decrypt each segment in the bio */
-	__bio_for_each_segment(bv, bio, iter, f_ctx->crypt_iter) {
+	__bio_for_each_segment(bv, bio, iter, iter) {
 		struct page *page = bv.bv_page;
 
 		sg_set_page(&sg, page, data_unit_size, bv.bv_offset);
@@ -404,19 +372,36 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 		for (i = 0; i < bv.bv_len; i += data_unit_size) {
 			blk_crypto_dun_to_iv(curr_dun, &iv);
 			if (crypto_wait_req(crypto_skcipher_decrypt(ciph_req),
-					    &wait)) {
-				bio->bi_status = BLK_STS_IOERR;
-				goto out;
-			}
+					    &wait))
+				return BLK_STS_IOERR;
 			bio_crypt_dun_increment(curr_dun, 1);
 			sg.offset += data_unit_size;
 		}
 	}
 
-out:
-	skcipher_request_free(ciph_req);
-	blk_crypto_put_keyslot(slot);
-out_no_keyslot:
+	return BLK_STS_OK;
+}
+
+static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
+{
+	struct bio_fallback_crypt_ctx *f_ctx =
+		container_of(work, struct bio_fallback_crypt_ctx, work);
+	struct bio *bio = f_ctx->bio;
+	struct bio_crypt_ctx *bc = &f_ctx->crypt_ctx;
+	struct blk_crypto_keyslot *slot;
+	blk_status_t status;
+
+	status = blk_crypto_get_keyslot(blk_crypto_fallback_profile,
+					bc->bc_key, &slot);
+	if (status == BLK_STS_OK) {
+		status = __blk_crypto_fallback_decrypt_bio(f_ctx->bio,
+				&f_ctx->crypt_ctx, f_ctx->crypt_iter,
+				blk_crypto_fallback_tfm(slot));
+		blk_crypto_put_keyslot(slot);
+	}
+
+	if (status != BLK_STS_OK)
+		bio->bi_status = status;
 	mempool_free(f_ctx, bio_fallback_crypt_ctx_pool);
 	bio_endio(bio);
 }
@@ -590,7 +575,8 @@ int blk_crypto_fallback_start_using_mode(enum blk_crypto_mode_num mode_num)
 
 	for (i = 0; i < blk_crypto_num_keyslots; i++) {
 		slotp = &blk_crypto_keyslots[i];
-		slotp->tfms[mode_num] = crypto_alloc_skcipher(cipher_str, 0, 0);
+		slotp->tfms[mode_num] = crypto_alloc_sync_skcipher(cipher_str,
+				0, 0);
 		if (IS_ERR(slotp->tfms[mode_num])) {
 			err = PTR_ERR(slotp->tfms[mode_num]);
 			if (err == -ENOENT) {
@@ -602,7 +588,7 @@ int blk_crypto_fallback_start_using_mode(enum blk_crypto_mode_num mode_num)
 			goto out_free_tfms;
 		}
 
-		crypto_skcipher_set_flags(slotp->tfms[mode_num],
+		crypto_sync_skcipher_set_flags(slotp->tfms[mode_num],
 					  CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	}
 
@@ -616,7 +602,7 @@ int blk_crypto_fallback_start_using_mode(enum blk_crypto_mode_num mode_num)
 out_free_tfms:
 	for (i = 0; i < blk_crypto_num_keyslots; i++) {
 		slotp = &blk_crypto_keyslots[i];
-		crypto_free_skcipher(slotp->tfms[mode_num]);
+		crypto_free_sync_skcipher(slotp->tfms[mode_num]);
 		slotp->tfms[mode_num] = NULL;
 	}
 out:
-- 
2.47.3


