Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81978C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 15:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29216B007B; Fri,  1 Aug 2025 11:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED9BF6B0089; Fri,  1 Aug 2025 11:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC87A6B008A; Fri,  1 Aug 2025 11:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4DB76B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:24:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E7A01A01C5
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:24:03 +0000 (UTC)
X-FDA: 83728559166.07.1A89086
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0416C0012
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:24:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ybhceot0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kbusch@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=kbusch@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754061841; a=rsa-sha256;
	cv=none;
	b=C86fV3GnEqRchpisPkMkiW7cRU7yByCFqCipfh/S0QIJ5b1b8GTkCIpRW1dZ2FlLyzWcML
	qmw0/2kzm1eOmYKeTa0OTPHFeovm2cSOXnBawTnG5fSVUx/gcwE/jnj/nUuYw8oJLkX3f1
	8mZt9kVMhg2iLfw4dxKuHuZGZdGKgyY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ybhceot0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of kbusch@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=kbusch@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754061841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1UFtN9NtY5FawUY5cUaVLl/Cv3X6ygngKZaP/vZlQgg=;
	b=s3pSUdaqU2WKKRy8Ijr8eV5q9j3rbwvNoPi/2p2ROF7csCoxV5jUlSeZg9iGbaqStf/Mon
	x1RygUewMNZt4QvwoIbAcAFNZJIdUflaYr1mV3WF5ociqT6I5He8LGslWjRTtsHNHzo+Hr
	Lq5wutfunS8CdrTIyqg8IBBgpQB3kyI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 0DB61A555B0;
	Fri,  1 Aug 2025 15:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58FAC4CEE7;
	Fri,  1 Aug 2025 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754061840;
	bh=V7o+bgdIVb3UeWT9T9ZBWSzxBOn3tlnld7jHt8D6nY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ybhceot0jd3NpcVE68V3hffEIFciXXEDBhjIaKXz332hFSSfx0AqiPsjCqVZy83nx
	 lAfuvilvWGyzU2IfQAHDzIKP1ti3QEeYv9itO2ZrlaCYbS1VGE3W59SyeBmQUg/atc
	 8eo6qeiX5fSw65opeVQ9s7aw/ZnheG5MN6Tpn6oa/bB13+7Xd5kv7/wkAc8P2lnjZM
	 O/rETg1ptKlD8rBYCZ92dDr+IQGRdOLRYcmujdb8wNNnoYVMdi5/vtSIT8yuE6WfRo
	 3+DYHooEua8tiPh/rKkJ35XmULNgY9ZsHPw9cwf/+2nBW5sxgI+Tmdb9sp41+JBR/t
	 s8Zar1Rc2DFMg==
Date: Fri, 1 Aug 2025 09:23:57 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	hch@infradead.org, linux-block@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/8] lib/iov_iter: remove piecewise bvec length
 checking in iov_iter_aligned_bvec
Message-ID: <aIzcDWJyft7kzGi3@kbusch-mbp>
References: <20250708160619.64800-1-snitzer@kernel.org>
 <20250708160619.64800-5-snitzer@kernel.org>
 <5819d6c5bb194613a14d2dcf05605e701683ba49.camel@kernel.org>
 <aG_SpLuUv4EH7fAb@kbusch-mbp>
 <aG_mbURjwxk3vZlX@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aG_mbURjwxk3vZlX@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0416C0012
X-Stat-Signature: gxmcnypnfedk4y5ckoeguj4ib7sh3qw7
X-Rspam-User: 
X-HE-Tag: 1754061841-697639
X-HE-Meta: U2FsdGVkX18lBJ5VhJQ8rxi8ZDkLbv232pHxnREVRlTq3ASrzZi1BN6UfImAapZxmpkwnfxdsFd55taKC+f40vfXr/1Vw9m9CrJuhZLWWpIAQzFGAVHv5dcv8m3nF6uUZAkLPeyyepz4gl+KLiAtqebjc35lMR5ElITkqUUosp8wuRDqLsp31dtLSFkxT733ZBCVH+9CUYu/xxS5luFr5YxdwfvpQrQlnT42ID3uiuFnJroPs+F/T5igwa2WzeATvvYUltRoiRk1kbj1TzOkZo3L3PttqPaFmzzmSV4NLsNGwj2/OKA89VAFG8wA+mLCAvDekgR0BN0xwgxw9oudkCd6z/ZwCKnxyqwb2UbB+vIT7b0TPxPuo7eMYuymXljvdARvrEZVRZLJdK2zK2KrjPurpuRzG4dTwYZe/b/gShB11qL8FFbOxkyOxJvQ2s9FQ938sTDTdR+LfQ1d6ANKXUL5jKCtzx9FlZxryk4qP5jN5+By30Xo/yZCNdYWC0bP+GL2O7Dz//gvAtHTm84hJoER939l84J6rP+pVk5MPaShNF1c1HD+y2JrMIvH0DmCafFp18DBrsqVUlgq1GGtv5JNi/OUw2ttJWlbuLDnOPCwYldAFI8SlYw3nt6GQKxZcP7gNXkwGqcIor4QfQoTMxLyx2fR/Tb4I7IC8E81d2g1Wm1tbi65T31hrVksv4qh3OsmRtywDDmiEOTC+Jw5ljYtutRSAiArNWuabqaGGWa7kESh7Zt124HeZpXu3TxvWJNgmPdGkjXNZv8I9f2+F3hdbeBLo5c6dtLtjK/oGkPL2Jf34Fwgvop1XWkpLuTe7s3z2hNVqTIFM4Uuq8z00lO7DcCXrviPvvJvES6eqI3LcVOQvEVILLCurA8fJHByvm9cgOeuIHvD5Y0w/lPEvDHcMOwWkTcqxFRRXeAXxzOLUteKyfbKoeqgR6ANGq/0sw6HRs4pT5kJZX2dXWY
 V7Z8OIGD
 6S1V5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 10, 2025 at 12:12:29PM -0400, Mike Snitzer wrote:
> All said, in practice I haven't had any issues with this patch.  But
> it could just be I don't have the stars aligned to test the case that
> might have problems.  If you know of such a case I'd welcome
> suggestions.

This is something I threw together that appears to be successful with
NVMe through raw block direct-io. This will defer catching an invalid io
vector to much later in the block stack, which should be okay, and
removes one of the vector walks in the fast path, so that's a bonus.

While this is testing okay with NVMe so far, I haven't tested any more
complicated setups yet, and I probably need to get filesystems using
this relaxed limit too.

---
diff --git a/block/bio.c b/block/bio.c
index 92c512e876c8d..634b2031c4829 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1227,13 +1227,6 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	if (bio->bi_bdev && blk_queue_pci_p2pdma(bio->bi_bdev->bd_disk->queue))
 		extraction_flags |= ITER_ALLOW_P2PDMA;
 
-	/*
-	 * Each segment in the iov is required to be a block size multiple.
-	 * However, we may not be able to get the entire segment if it spans
-	 * more pages than bi_max_vecs allows, so we have to ALIGN_DOWN the
-	 * result to ensure the bio's total size is correct. The remainder of
-	 * the iov data will be picked up in the next bio iteration.
-	 */
 	size = iov_iter_extract_pages(iter, &pages,
 				      UINT_MAX - bio->bi_iter.bi_size,
 				      nr_pages, extraction_flags, &offset);
@@ -1241,18 +1234,6 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 		return size ? size : -EFAULT;
 
 	nr_pages = DIV_ROUND_UP(offset + size, PAGE_SIZE);
-
-	if (bio->bi_bdev) {
-		size_t trim = size & (bdev_logical_block_size(bio->bi_bdev) - 1);
-		iov_iter_revert(iter, trim);
-		size -= trim;
-	}
-
-	if (unlikely(!size)) {
-		ret = -EFAULT;
-		goto out;
-	}
-
 	for (left = size, i = 0; left > 0; left -= len, i += num_pages) {
 		struct page *page = pages[i];
 		struct folio *folio = page_folio(page);
@@ -1297,6 +1278,23 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	return ret;
 }
 
+static int bio_align_to_bs(struct bio *bio, struct iov_iter *iter)
+{
+	unsigned int mask = bdev_logical_block_size(bio->bi_bdev) - 1;
+	unsigned int total = bio->bi_iter.bi_size;
+	size_t trim = total & mask;
+
+	if (!trim)
+	        return 0;
+
+	/* FIXME: might be leaking pages */
+	bio_revert(bio, trim);
+	iov_iter_revert(iter, trim);
+	if (total == trim)
+	        return -EFAULT;
+	return 0;
+}
+
 /**
  * bio_iov_iter_get_pages - add user or kernel pages to a bio
  * @bio: bio to add pages to
@@ -1327,7 +1325,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	if (iov_iter_is_bvec(iter)) {
 		bio_iov_bvec_set(bio, iter);
 		iov_iter_advance(iter, bio->bi_iter.bi_size);
-		return 0;
+		return bio_align_to_bs(bio, iter);
 	}
 
 	if (iov_iter_extract_will_pin(iter))
@@ -1336,6 +1334,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 		ret = __bio_iov_iter_get_pages(bio, iter);
 	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
 
+	ret = bio_align_to_bs(bio, iter);
 	return bio->bi_vcnt ? 0 : ret;
 }
 EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 70d704615be52..a3acfef8eb81d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -298,6 +298,9 @@ int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
 	unsigned nsegs = 0, bytes = 0;
 
 	bio_for_each_bvec(bv, bio, iter) {
+		if (bv.bv_offset & lim->dma_alignment)
+			return -EFAULT;
+
 		/*
 		 * If the queue doesn't support SG gaps and adding this
 		 * offset would create a gap, disallow it.
@@ -341,6 +344,8 @@ int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
 	 * we do not use the full hardware limits.
 	 */
 	bytes = ALIGN_DOWN(bytes, bio_split_alignment(bio, lim));
+	if (!bytes)
+		return -EFAULT;
 
 	/*
 	 * Bio splitting may cause subtle trouble such as hang when doing sync
diff --git a/block/fops.c b/block/fops.c
index 82451ac8ff25d..820902cf10730 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -38,8 +38,8 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
 static bool blkdev_dio_invalid(struct block_device *bdev, struct kiocb *iocb,
 				struct iov_iter *iter)
 {
-	return iocb->ki_pos & (bdev_logical_block_size(bdev) - 1) ||
-		!bdev_iter_is_aligned(bdev, iter);
+	return (iocb->ki_pos | iov_iter_count(iter)) &
+			(bdev_logical_block_size(bdev) - 1);
 }
 
 #define DIO_INLINE_BIO_VECS 4
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 46ffac5caab78..d3ddf78d1f35e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -169,6 +169,22 @@ static inline void bio_advance(struct bio *bio, unsigned int nbytes)
 
 #define bio_iter_last(bvec, iter) ((iter).bi_size == (bvec).bv_len)
 
+static inline void bio_revert(struct bio *bio, unsigned int nbytes)
+{
+	bio->bi_iter.bi_size -= nbytes;
+
+	while (nbytes) {
+		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
+
+		if (nbytes < bv->bv_len) {
+			bv->bv_len -= nbytes;
+			return;
+		}
+		bio->bi_vcnt--;
+		nbytes -= bv->bv_len;
+       }
+}
+
 static inline unsigned bio_segments(struct bio *bio)
 {
 	unsigned segs = 0;
--

