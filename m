Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB492CCF9FF
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B388E00F6; Fri, 31 Oct 2025 05:36:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2229A8E0042; Fri, 31 Oct 2025 05:36:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138B38E00F6; Fri, 31 Oct 2025 05:36:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F03228E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:36:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCF0D1A0430
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:36:12 +0000 (UTC)
X-FDA: 84057903384.22.C0E75E4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 27D6C2000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:36:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cR8gyRvi;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf03.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761903371; a=rsa-sha256;
	cv=none;
	b=jT5IgV6vNBGhhONTcoNiDz+7yjqcsOI1RZ8SxYl8c8KN1XxatJJDMoDEdYf3cAHFRLPnnU
	2vU7t17XVo+lhmg8CI7jqUNDtCb+oROmddqw+IQYvQrUqjL4/FWeZOxiXT+kC7A3cK4QUL
	dXSAKfAxtRKF4Eyg1hPpxEGJIQF1TJw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cR8gyRvi;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf03.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761903371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wAylb0D6cMRFiTtOtljfzXlqGrVPob/jf/2jDFIsOSQ=;
	b=Lz1wB1sirb5UUm+LUXAtldSs1zZLEw5b260U5f/FyMHh8ymiw84XG/YHJG0TCXRHDhadpw
	Af6Q6OE1+AHhsvSbWAcjDeDWRRRcDb+Hxy1wZJGuhPVfQsqWPIFNFK3Zt2p5Zx2Pwyp17D
	f053FgcZBw1L8l0BBf0k6ncIfCvYo/g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wAylb0D6cMRFiTtOtljfzXlqGrVPob/jf/2jDFIsOSQ=; b=cR8gyRvic/ui/DEy2j6JZJjgqb
	koZlP+rhGEHVJw278pizwXCpDr0qxKxM/N+B2BWiChuTizldoR4I7iaqaN2pPpGphC0il3ZekmM4e
	WjZMM/GJad4al3Vxmi6ou6JDhPqXiJqEK/15u6LOyxrepYe36kQzWikRTVCKlE17fb7SwsZvwE9Ua
	wBQ9oBOwOQ/ym95wjQd+KV5yVF3BRww1k9+GwcqtL6Jx8VCZomqWz7e2wVsKi453wCrKay9zxWdoF
	6z4ywdyIkdg/sNTO62addxh0ClAirhABJALDs1JPnx2xUComewurIVbR1OAcijTlIjiNVVncnrr1B
	GWwfQI4A==;
Received: from [2001:4bb8:2dc:1001:a959:25cf:98e9:329b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vElYG-00000005ou9-1GlQ;
	Fri, 31 Oct 2025 09:36:08 +0000
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
Subject: [PATCH 9/9] blk-crypto: use mempool_alloc_bulk for encrypted bio page allocation
Date: Fri, 31 Oct 2025 10:34:39 +0100
Message-ID: <20251031093517.1603379-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251031093517.1603379-1-hch@lst.de>
References: <20251031093517.1603379-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27D6C2000C
X-Stat-Signature: p98aik9r1n8z35w3bupmu38wa7ko4mm5
X-HE-Tag: 1761903370-106163
X-HE-Meta: U2FsdGVkX1/xZNZ1EnxB+s5E0hcgG4eQnNfPe+ApQPzetHO3GXHQ3rNIL+Fu/I9fD4tu2k1K2pbtFVubD3Xe/t0iR5Q02+J/cyijyYB9ZzwMZDyKatD20TLc8kKXH/YwkT64EqWF7+cm8+Yw7reweo7nTTQhCLFVAWT5BJ6l7BzxI/kVXIBClxjo5wjy0rqWXAbnHN8U07bz7RjMfdLCJTy/x7L41prqIHWp8tEOZiPCsq5k4D1/xbGBCnvve0dofsWJlSPxUMTUql2U+SQNEznFWZUsapuwQTLJwzgXu7IzHdiZWUlRMgoLPLHMQGPE/k/hbvELSb6M1YjQv6q0q7xxSqBMfHnjYwcIioLJ31nGR+Vzp4PBJ6VFHUJrNo4gliiOAcV3+pqUG+DlfR4K+YAC/3Q6KVZym1+beLnpqyahZfm79FTKiI9QhVGmB3iChsx0KU5SKyo1yTeoZoiPJ5fD7NiEbJUtymiWMcF5X1FIImzgSUd2PBF7gp16/sNhUhRiHoh04UmJxMoAjfL+dr64dYnKwRtFkaPA+c5SmpNHrAsNlEhToweJ3QOkrXO/l7pCXyVdKnJ7Pe27xnA7jCj+LaP2Yy313xz2xpxYWDxpwa64thfg1eBgfrqKoXBbivCIInOZ5BEtc0eexY257j/bXDG5hwI4hQCmMXDnKGJ0z/ZVRrD+uJM3Z28uRhJKGePslYa2qy1ZjYPLCk1JBfl6WFuPHCWKqggRvpu4JopMeZdU2/+kkl/3ktX1z5izTeChh/SdzHIKHL6qG8LLvo9sjc3TDXkoSXY1pm51+f3ibcbxNN3a0EHuF6D7mhPOU4ysgksfaCNiE1gKPgReanIUNtqs3HFJ8mam98ztbIWyabnkLhXAaRYx3vqd4A6hHXRVndbG3L3m8r43nnpU4nWNv+9BGDd6BzmS7Mw0VrY12o6Br02m8BBTFnTHYdT7itnr2uLFoLl4JUFOakg
 PziRcs2X
 1VebgR/odxaXv6XqPWmA+nj2wXyBx3xAegsycsub7nscFwbIC6519SnZwmyW4B8eD18Wr0Zq7Np0M/Q6kZCSM0AnXlyrFvuUnfvfXWrilr3PDtbRLg+GOwA9DXu8CTzTGfC+bA8QsdNlhabTv/ZbMZnk1oM5g/HrIb5tvIPCE1uCukAcmh5vfBuxvcX+dpI/I3oR4HuWfSU/NPKhgdoF7pshsK+Y7HBkP2JR20z96nCWRIvUDE9pmd38HkrVW+jNoh/5g4wIlYT2UVrjgExtDeM23d4jWB9EoNFthqpqQveENReDH1Oyx6Aqqhe5tREPaldoF3J0NMi2n/1Wei356TtYOBmMHu7MUcxvH5DUbrzfJqglraiL6ZxKKGGCf6troZfkIsygrf2Y5gwxFa6kHLAnUWTvR5sE7+LLELd7Wx9hMrdy1JXc8b2Q4pKb9XqtoJ2o6ooihRLaFYIhozRAzv2l7vTInMGAmHTI2GP0zEYCwBRqknMBhQpSIPkYHND/tBTk3hKEwlNzOgKk+hYr+L882mlxdos1DWjOuKrQIsy2HbJ04fa/QDZ0DYSCSZfFK0AvrjWm3JdN9cf5H9s+kNfFA1pa4tN6CMG28
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Calling mempool_alloc in a lot is not safe unless the maximum allocation
size times the maximum number of threads using it is less than the
minimum pool size.  Use the new mempool_alloc_bulk helper to allocate
all missing elements in one pass to remove this deadlock risk.  This
also means that non-pool allocations now use alloc_pages_bulk which can
be significantly faster than a loop over individual page allocations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-crypto-fallback.c | 54 ++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 33aa7b26ed37..2f78027f0cce 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -22,7 +22,7 @@
 #include "blk-cgroup.h"
 #include "blk-crypto-internal.h"
 
-static unsigned int num_prealloc_bounce_pg = 32;
+static unsigned int num_prealloc_bounce_pg = BIO_MAX_VECS;
 module_param(num_prealloc_bounce_pg, uint, 0);
 MODULE_PARM_DESC(num_prealloc_bounce_pg,
 		 "Number of preallocated bounce pages for the blk-crypto crypto API fallback");
@@ -164,11 +164,21 @@ static bool blk_crypto_fallback_bio_valid(struct bio *bio)
 static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
 {
 	struct bio *src_bio = enc_bio->bi_private;
-	int i;
+	struct page **pages = (struct page **)enc_bio->bi_io_vec;
+	struct bio_vec *bv;
+	unsigned int i;
 
-	for (i = 0; i < enc_bio->bi_vcnt; i++)
-		mempool_free(enc_bio->bi_io_vec[i].bv_page,
-			     blk_crypto_bounce_page_pool);
+	/*
+	 * Use the same trick as the alloc side to avoid the need for an extra
+	 * pages array.
+	 */
+	bio_for_each_bvec_all(bv, enc_bio, i)
+		pages[i] = bv->bv_page;
+
+	i = mempool_free_bulk(blk_crypto_bounce_page_pool, (void **)pages,
+			enc_bio->bi_vcnt);
+	if (i < enc_bio->bi_vcnt)
+		release_pages(pages + i, enc_bio->bi_vcnt - i);
 
 	src_bio->bi_status = enc_bio->bi_status;
 
@@ -176,9 +186,12 @@ static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
 	bio_endio(src_bio);
 }
 
+#define PAGE_PTRS_PER_BVEC     (sizeof(struct bio_vec) / sizeof(struct page *))
+
 static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
-		unsigned int nr_segs)
+		unsigned int nr_segs, struct page ***pages_ret)
 {
+	struct page **pages;
 	struct bio *bio;
 
 	bio = bio_alloc_bioset(bio_src->bi_bdev, nr_segs, bio_src->bi_opf,
@@ -192,6 +205,29 @@ static struct bio *blk_crypto_alloc_enc_bio(struct bio *bio_src,
 	bio->bi_write_stream	= bio_src->bi_write_stream;
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
 	bio_clone_blkg_association(bio, bio_src);
+
+	/*
+	 * Move page array up in the allocated memory for the bio vecs as far as
+	 * possible so that we can start filling biovecs from the beginning
+	 * without overwriting the temporary page array.
+	 */
+	static_assert(PAGE_PTRS_PER_BVEC > 1);
+	pages = (struct page **)bio->bi_io_vec;
+	pages += nr_segs * (PAGE_PTRS_PER_BVEC - 1);
+
+	/*
+	 * Try a bulk allocation first.  This could leave random pages in the
+	 * array unallocated, but we'll fix that up later in mempool_alloc_bulk.
+	 *
+	 * Note: alloc_pages_bulk needs the array to be zeroed, as it assumes
+	 * any non-zero slot already contains a valid allocation.
+	 */
+	memset(pages, 0, sizeof(struct page *) * nr_segs);
+	if (alloc_pages_bulk(GFP_NOFS, nr_segs, pages) < nr_segs) {
+		mempool_alloc_bulk(blk_crypto_bounce_page_pool, (void **)pages,
+				nr_segs, GFP_NOIO);
+	}
+	*pages_ret = pages;
 	return bio;
 }
 
@@ -234,6 +270,7 @@ static blk_status_t __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
 	struct scatterlist src, dst;
 	union blk_crypto_iv iv;
 	struct bio *enc_bio = NULL;
+	struct page **enc_pages;
 	unsigned int nr_segs;
 	unsigned int enc_idx = 0;
 	unsigned int j;
@@ -259,11 +296,10 @@ static blk_status_t __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
 
 		if (!enc_bio) {
 			enc_bio = blk_crypto_alloc_enc_bio(src_bio,
-					min(nr_segs, BIO_MAX_VECS));
+					min(nr_segs, BIO_MAX_VECS), &enc_pages);
 		}
 
-		enc_page = mempool_alloc(blk_crypto_bounce_page_pool,
-				GFP_NOIO);
+		enc_page = enc_pages[enc_idx];
 		__bio_add_page(enc_bio, enc_page, src_bv.bv_len,
 				src_bv.bv_offset);
 
-- 
2.47.3


