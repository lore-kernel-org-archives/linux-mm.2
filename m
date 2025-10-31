Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 137D2CCF9FA
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72C2D8E00E9; Fri, 31 Oct 2025 05:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7039C8E0042; Fri, 31 Oct 2025 05:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2B78E00E9; Fri, 31 Oct 2025 05:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5398E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:35:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12E6DB946E
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:35:52 +0000 (UTC)
X-FDA: 84057902544.09.D58876E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 52B67A000F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:35:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TzEFMIl8;
	spf=none (imf15.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761903350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/eGr74zsRzAU6OL6XbDU9Oe1mu1cYgCgFsZlvySTvhg=;
	b=SN3b4erifDHZ3LqDcPTnD0kAt2VzP3rKgMYx+b1v/zBPhbFM0mtsyum6DgbLhManEatsBq
	VWY54APzc6slj/EYfIsFlc/FrkzJBV+OPSs61URpYFBSs1AkF3Mac7vCDhD0w+EFylJ9yx
	az6APcnWeFDgH7ij8ZakCoBkYUDN4hM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TzEFMIl8;
	spf=none (imf15.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761903350; a=rsa-sha256;
	cv=none;
	b=Wi8PpsBEh7IoQ++gLJxUpJmfbfsEmMS9DTqbwtxD3JKlDT7MDxxsNHHFK7zzLbl4kXdh26
	CZyQVfDoICzE996C/A9Pc6CNK+s6Ht2p6B0FCbfyDwqn67csHn5KMFB0XqcvOkS9WAlbfg
	aYVjH9KZU9/P9NCUV1Y1dBRihbTBvZg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/eGr74zsRzAU6OL6XbDU9Oe1mu1cYgCgFsZlvySTvhg=; b=TzEFMIl8e7H9NR/1Vsg72X/oAk
	SMQswToabwncR98vtmyq7E5R+2eeB5n+b+ye5aIzQZHS4MPW63XYTRI61lj6eUbOUjE1P66GDJVS6
	Q3gZD3BmZcVkAtdbV6ENbbaxVYh7jqnXJXjuKnfQJKlPlppxNTF3Ieken9KjBBnplH7kQOew7t/NZ
	W30LDuIqAvbFjB+EeOMIf6II+08jJcIZj0Ud4pQFa9kSzUgYsYES3bvbegwTgKQlRO9e7ARdvAM5k
	7YYNVJleH9Mr1jFvcBswK7HvuBCZx9+17Dy9z73EqHWCpms87hqDqJyLppxoMUaAZAurwQjyEnNpX
	DksVzK5Q==;
Received: from [2001:4bb8:2dc:1001:a959:25cf:98e9:329b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vElXv-00000005or6-2pZf;
	Fri, 31 Oct 2025 09:35:48 +0000
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
Subject: [PATCH 5/9] fscrypt: keep multiple bios in flight in fscrypt_zeroout_range_inline_crypt
Date: Fri, 31 Oct 2025 10:34:35 +0100
Message-ID: <20251031093517.1603379-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251031093517.1603379-1-hch@lst.de>
References: <20251031093517.1603379-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 4syz8d4y4muz5wo5yz7qjjamobrcyakm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 52B67A000F
X-HE-Tag: 1761903350-857890
X-HE-Meta: U2FsdGVkX1+F7GL4WUY7irTqz3lTN+A+tuNQvxzKMPS9v20Jjn55v69fzAXuK3FrJetCjobtjvL8eMIIvbsP10W1lsJLir84/MIXuvBwyzxBKSSodSZFw6Sk+sgK0PNEtyTfDeyVf7oBSh7TgGFN+TWmzd1LPBI02Oli/U9NchKs8KafQZJbeKXTqMxObumDU6sJKhG6YjA8SE9OTQu9nc55FiAaFHjEr+tj3oKTiuDnP8L23qoAJVFa/R80TQcHesq9i9G9oDV8wsVGbsAgBHwoauUAszUcoI5D1eC+XvjwfMG2Xx+Z+jc/x0P/v2CoHyz9T0U5ICdKsPJNg2+bXKnnreKS3/xUYxF+6/0l/I8o9OOka2YHg+cXkPHx6jpBITipQ8TOHrugQAFr1Hx2WFEOJfDdIE5HAKNhgAgdSI+vVFnXO3t59SebteARQdWOGaKdcMRsQ1d0E5jOsRB9xPQMmQ5OOzFzDiYFv2cIcFBbcKveGUlYxib1TrYYIovsyZm4LP6EEKaqDogcry0x7gDh+MTcjGqiJ7u+kzzUNloqRoTmCRUB2ZQ4pi7IuWwaf9wSqZ0TtsKEkGWILzlSj/GyNiJCyKjs6Ffac9uI/gUuNDYXArSPetudC/pWIwDDh83d5/UICL+KBF51FMSGkZJ9x6HS67nk1AznaadQAYaJ1q5VgywvRNQL/Qpiz1mESxUTyw1lLPpoq7KVXpHubjBIBUGjc5xAxcKPWdTIHCNIMG6sxziZf72w6oRhdM3Gszs66GXnxm3Ov1f37qdWzOo7vHTTco+ZaQcSrxuCe3rLbq9detj62CgAwZ17qLKiGuXizQ2tAwvN/6E7v1mSOEubU12ze6MfyYSBEEt4uSL8hELODnJBYkshTm5bXym+N2eI52h3CvIi1z0AGzWiiQ6UHwkhegkiFfs74DgUTpKLViNiWMZsFNREWlfSN3gqZp9IvTLZlC/jWhQmBEA
 z7nmDJ7w
 1OTXnvQMluRVF8nHRZzTxHgev6fFMS4nGPtw09sn7i6xmOSF9580pVecY2aI7mJaYTAXNq4i7R+3SvzswVx11BYaAUmc5JzIekVJrUKN9PHaJ/QIM25vf9KWEgp3A6qu0hs0Mo/8ZPpNqJEdHp4+0M2DyjebvVwQuRZHTz+ITOz/oD2zsOc0nk+31LpxbGcniJ7bQ+sLaAf8vaw055o4+nzL/ctQUhkNDGQcjs80W1byKdJ0bxNk3QfThDJfCB4/wqaN687DANGvWY3VP+dJrk3qkl8NHcJw08upAsPhKKw62hj61EKkRKFAq+B+mKoYJ4nKhQMJMO6Cy3X9/9a1kxxaN8/IHYlAJ+00siaanso84UMLqrxjRAhH2cTDGxyszT8nCqVogDAB5Le0JghNg8X6nzwFfRFxfsiAgeHnsLHhrtASC8KNgxIJ+0bYcKZdYIxMazS3hTHyhCn1aPKTDm/kdSkEKxJEnzMhWxshqHJG9IR4655QCr+ojlVTEMLM55X0BphBAB7yzScwBN6FKH5TAVF7+JOEQxVUoxIAgdNUE+E8XTOM1sTrZ9Zsc/nEyWNCk5mOiq6kPAFmTvWsr+8LflRP+tCrSu7bp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This should slightly improve performance for large zeroing operations,
but more importantly prepares for blk-crypto refactoring that requires
all fscrypt users to call submit_bio directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/crypto/bio.c | 84 +++++++++++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 31 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 68b0424d879a..e59d342b4240 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -47,49 +47,71 @@ bool fscrypt_decrypt_bio(struct bio *bio)
 }
 EXPORT_SYMBOL(fscrypt_decrypt_bio);
 
+struct fscrypt_zero_done {
+	atomic_t		pending;
+	blk_status_t		status;
+	struct completion	done;
+};
+
+static void fscrypt_zeroout_range_done(struct fscrypt_zero_done *done)
+{
+	if (atomic_dec_and_test(&done->pending))
+		complete(&done->done);
+}
+
+static void fscrypt_zeroout_range_end_io(struct bio *bio)
+{
+	struct fscrypt_zero_done *done = bio->bi_private;
+
+	if (bio->bi_status)
+		cmpxchg(&done->status, 0, bio->bi_status);
+	fscrypt_zeroout_range_done(done);
+	bio_put(bio);
+}
+
 static int fscrypt_zeroout_range_inline_crypt(const struct inode *inode,
 					      pgoff_t lblk, sector_t sector,
 					      unsigned int len)
 {
 	const unsigned int blockbits = inode->i_blkbits;
 	const unsigned int blocks_per_page = 1 << (PAGE_SHIFT - blockbits);
-	struct bio *bio;
-	int ret, err = 0;
-	int num_pages = 0;
+	struct fscrypt_zero_done done = {};
 
-	/* This always succeeds since __GFP_DIRECT_RECLAIM is set. */
-	bio = bio_alloc(inode->i_sb->s_bdev, BIO_MAX_VECS, REQ_OP_WRITE,
-			GFP_NOFS);
+	atomic_set(&done.pending, 1);
+	init_completion(&done.done);
 
 	while (len) {
-		unsigned int blocks_this_page = min(len, blocks_per_page);
-		unsigned int bytes_this_page = blocks_this_page << blockbits;
+		struct bio *bio;
+		unsigned int n;
 
-		if (num_pages == 0) {
-			fscrypt_set_bio_crypt_ctx(bio, inode, lblk, GFP_NOFS);
-			bio->bi_iter.bi_sector = sector;
-		}
-		ret = bio_add_page(bio, ZERO_PAGE(0), bytes_this_page, 0);
-		if (WARN_ON_ONCE(ret != bytes_this_page)) {
-			err = -EIO;
-			goto out;
-		}
-		num_pages++;
-		len -= blocks_this_page;
-		lblk += blocks_this_page;
-		sector += (bytes_this_page >> SECTOR_SHIFT);
-		if (num_pages == BIO_MAX_VECS || !len ||
-		    !fscrypt_mergeable_bio(bio, inode, lblk)) {
-			err = submit_bio_wait(bio);
-			if (err)
-				goto out;
-			bio_reset(bio, inode->i_sb->s_bdev, REQ_OP_WRITE);
-			num_pages = 0;
+		bio = bio_alloc(inode->i_sb->s_bdev, BIO_MAX_VECS, REQ_OP_WRITE,
+				GFP_NOFS);
+		bio->bi_iter.bi_sector = sector;
+		bio->bi_private = &done;
+		bio->bi_end_io = fscrypt_zeroout_range_end_io;
+		fscrypt_set_bio_crypt_ctx(bio, inode, lblk, GFP_NOFS);
+
+		for (n = 0; n < BIO_MAX_VECS; n++) {
+			unsigned int blocks_this_page =
+				min(len, blocks_per_page);
+			unsigned int bytes_this_page = blocks_this_page << blockbits;
+
+			__bio_add_page(bio, ZERO_PAGE(0), bytes_this_page, 0);
+			len -= blocks_this_page;
+			lblk += blocks_this_page;
+			sector += (bytes_this_page >> SECTOR_SHIFT);
+			if (!len || !fscrypt_mergeable_bio(bio, inode, lblk))
+				break;
 		}
+
+		atomic_inc(&done.pending);
+		submit_bio(bio);
 	}
-out:
-	bio_put(bio);
-	return err;
+
+	fscrypt_zeroout_range_done(&done);
+
+	wait_for_completion(&done.done);
+	return blk_status_to_errno(done.status);
 }
 
 /**
-- 
2.47.3


