Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A8C2CCF9FF
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B558E00E3; Fri, 31 Oct 2025 05:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862EA8E0042; Fri, 31 Oct 2025 05:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A0178E00E3; Fri, 31 Oct 2025 05:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66D8E8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:35:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AD2949C3E
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:35:47 +0000 (UTC)
X-FDA: 84057902334.26.B7837DA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9A36D4000F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:35:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wfBXma2O;
	spf=none (imf17.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761903345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqWWMzp18VGGcYecVDBfzI6fZq+XM3nnYzuWuwwCLew=;
	b=aZ7L2sS2xaTZsT605Lefo+a5TQmc+SsYc97rA+5jkGEzO0jlmBlGdUdHxmLXbB6dKt/dOe
	J545mYdiNrpvw/MpmIN3E4AW5g+Q0iwgttaUHZy98yGSfkjszslQEK5Dneje5MDmRuwMJP
	LHtcuPCVCCq9GmRS2kVq9tqIlH4agTA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wfBXma2O;
	spf=none (imf17.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761903345; a=rsa-sha256;
	cv=none;
	b=VWJN/l2YGa+D+fQ68Qc0sEm+r8zQ5KuU1+o/mIXpPOv1J9BLeFWWdA8l81CNxPx/5PrXcA
	ck6/du48lrZiVxG6gd4N2oRZB/IrndFO41+yxBsDepflGdxfrkUrn9QawvNe0MATDNOYrZ
	W/QZY2Eh4yvhUTQQwq+Cvmg9jCSVaMU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HqWWMzp18VGGcYecVDBfzI6fZq+XM3nnYzuWuwwCLew=; b=wfBXma2O4xSHPIf78YwepIbpt8
	Fft5OS73hC4UWITZzqL1ZF6K42cJXgur5fTz9B1Oa5Z11NJxIIyYiDAgexqs5HQgCBemm04Ap4QE+
	bVoQ/dMvTVrIcjYFGOuDu1bWrQjfYgFpHICSC3BDmXjqJiFpLIaqoZGClY1KGw14eg3/sS8QvolFP
	+a4Oxfzd7ayE7o3Du05WVGBg4qRZHInN/U4Zyc2YIozg5taZw1Q3QwGI1bP6TA7M5z0SrxYbqLNEZ
	rkBKYvFAT4u7pgJOsYtafDjmfKLZXhURoyBrEo/gmHapPZ7tsQRDF080LRyqRJEub43ZFOdyJfBx+
	6TcFJRDQ==;
Received: from [2001:4bb8:2dc:1001:a959:25cf:98e9:329b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vElXq-00000005oqc-3nBe;
	Fri, 31 Oct 2025 09:35:43 +0000
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
Subject: [PATCH 4/9] fscrypt: pass a real sector_t to fscrypt_zeroout_range_inline_crypt
Date: Fri, 31 Oct 2025 10:34:34 +0100
Message-ID: <20251031093517.1603379-5-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251031093517.1603379-1-hch@lst.de>
References: <20251031093517.1603379-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: zy67ec3daho9kxp86mtqjgqjt586iope
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A36D4000F
X-HE-Tag: 1761903345-952863
X-HE-Meta: U2FsdGVkX1+EAMxxrJmhSPWXzY4fz/c0Rg4b+1jhxfMH8xvP4MRKW+lzUkqwjAR13TuLOpaYyf0CLHwPnKCdHqyHsLNTliH5VEL5Ant5L4DraELifIyp3OBApXGEoC/V03O2QfUUOTYIIdiSR4jTkitHYoh7f+B9Qi2py9vQQIFRglTuDerLLVOeqP7AYNhlOla52p0Rx/P3jMSQ94uzy2a4zO0aPOGHbqc6NsEKEDCky/iQt29Vy1Mtx/7CjPI8sV2MEBRA1J6+E82WAcYwOGe/7/uUp4SE//AqwvmWMC6B4dcXXV/bHjZRqTey8myAuykYBDhU1I11Bvwip0EPhKTsrHXpeKR3GCqbIJIY0NU4bd9esRVoFRvLuweyh0i5O4vXoHWVLTND0LF3QR7fniLFMMAxX393aMhfIeWLuJPLXOSaCMVcuFrUZNACIauStaR2WpSUIlTMfnL3BY234afOMlLLjIxjiCWGCQ+EsLiUtCVEls2hGqUikJZtzFPjMadGDbvlZ9moszdTrrx+ceruqgJTs1eQlK8vrCDmBRq+Bc+3lzQOD9+iRcSU9rTkasDSe6+4AOK0DoProiy/BJ2kEopvwGexoqfrQsV7L5sqMR6C0sj/WBURyVH+gSGfeoZA3EOWBrTcLB1C4zq2xSjjDc0B8oy+nEJQkSXSvrg3Fe8xqQ9W8cqTlhyxrTn1XWInYlQWnY/WXNQqjDWpQUD7fdiTIHyVKMIl8w0bK5q4lgl5NX42KEvQHqqAE9FJzyeO5t7hK0BLzqj3nAnTMNaQqvBwaKYzCpPtjC9SCR9q0JGbj5OlcZY2R0MjKoQS9mkjfIKT7YH/IQIe67kFRNCA2qo9w5CTf+nFluSAavMcXHbmVtRZ7o0TmKWfnmP2Ok/aCp4bwfFU64aFMxnsiEvN2Q/QWQ3fOibAMHXSIwpTT+TCFPaWT6wyc6lPiyG9tRo/B2POwoybmlYZAXt
 NIYVqrWy
 6ANaNSucUG9E0QOJurvRuus67rPZ3z/G4ROhKBno4ZaHmUSzRDfQZKH/vGCetYJ7rjZ+xDotDbpyRZfuqcq1oXfMQew17kDE3/egI5cjflQx2blrN8mZ+SY722WVtxvRlEriDApGga/fUUyNGvuDroY6h22uoqU0cGnyr7cTEwsENZPu/e7sUUoz1ePiAUnAMPYbX9ZgFXECtCe5qeHWrBKFYoNKa+T68Top8rfFgFrLT9HBPT4EMwmF5HW19zeH56AvK4lz5bHwduZhXpZEGU+p1WmfhdbR8TTw7iRnIYDOiS6uxjQFVKfeh70y28BTp/1enc2+A5SX5u+5MZ8/z8C4PQNNUdXqaOcgQwXxn/emJZocA5rCX4p3qOOrIC+hYeNzw+T5hHxariHQj+gjJWNpbZEeHLczwL4woH8zekX8zDnhIach1XnDdFM4OzxDuNYzkHeAuOSK8l8oJDwZVUx4jweh3B64wfri7TROif2KpsTdltjQnSbvDJ62oshJ/Z14PXDSDFCmK44NVDf6qNlvWSuEVe4IEkdO1ZF+JTPkESv4Wf7fu+vOwTYoRdrRtQdAqWgSgGGd3Dc77slPqHZP8k7HhuT6uQmCt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While the pblk argument to fscrypt_zeroout_range_inline_crypt is
declared as a sector_t it actually is interpreted as a logical block
size unit, which is highly unusual.  Switch to passing the 512 byte
units that sector_t is defined for.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/crypto/bio.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 5f5599020e94..68b0424d879a 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -48,7 +48,7 @@ bool fscrypt_decrypt_bio(struct bio *bio)
 EXPORT_SYMBOL(fscrypt_decrypt_bio);
 
 static int fscrypt_zeroout_range_inline_crypt(const struct inode *inode,
-					      pgoff_t lblk, sector_t pblk,
+					      pgoff_t lblk, sector_t sector,
 					      unsigned int len)
 {
 	const unsigned int blockbits = inode->i_blkbits;
@@ -67,8 +67,7 @@ static int fscrypt_zeroout_range_inline_crypt(const struct inode *inode,
 
 		if (num_pages == 0) {
 			fscrypt_set_bio_crypt_ctx(bio, inode, lblk, GFP_NOFS);
-			bio->bi_iter.bi_sector =
-					pblk << (blockbits - SECTOR_SHIFT);
+			bio->bi_iter.bi_sector = sector;
 		}
 		ret = bio_add_page(bio, ZERO_PAGE(0), bytes_this_page, 0);
 		if (WARN_ON_ONCE(ret != bytes_this_page)) {
@@ -78,7 +77,7 @@ static int fscrypt_zeroout_range_inline_crypt(const struct inode *inode,
 		num_pages++;
 		len -= blocks_this_page;
 		lblk += blocks_this_page;
-		pblk += blocks_this_page;
+		sector += (bytes_this_page >> SECTOR_SHIFT);
 		if (num_pages == BIO_MAX_VECS || !len ||
 		    !fscrypt_mergeable_bio(bio, inode, lblk)) {
 			err = submit_bio_wait(bio);
@@ -132,7 +131,7 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
 		return 0;
 
 	if (fscrypt_inode_uses_inline_crypto(inode))
-		return fscrypt_zeroout_range_inline_crypt(inode, lblk, pblk,
+		return fscrypt_zeroout_range_inline_crypt(inode, lblk, sector,
 							  len);
 
 	BUILD_BUG_ON(ARRAY_SIZE(pages) > BIO_MAX_VECS);
-- 
2.47.3


