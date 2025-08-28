Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C36C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64A36B0099; Thu, 28 Aug 2025 12:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3AC46B009B; Thu, 28 Aug 2025 12:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9511A6B00A0; Thu, 28 Aug 2025 12:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4246B0099
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:39:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3364213990B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:39:19 +0000 (UTC)
X-FDA: 83826726438.20.BD048C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4320F40017
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:39:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=baOz2Z00;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756399157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FMXcrdBWUMv2sKOqWG46n/m1Dw9lkuVWd7s5hpTzGk=;
	b=zK1oYSmaM7bFOKa5p6vaZFeC9CFYSll067jy/9BzDjIOtcHVnEO7c7RcicrWMX488+xnGx
	zqFq9AHH2ZeqGwCoWSAgfZX2+W7KO/6OtPWOduY26aY3Jbidu9fuD3ymGDocD5mIBmRXt0
	OATDd/g2Mm/81nEoBbDu1JFtAsAOPjY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756399157; a=rsa-sha256;
	cv=none;
	b=ja0HzgetTDgWMQZr6rb7Qi0pWa8zm945GF5ip+XVjqnqP9tdGR7wwT6abD5asEERyE+i40
	ohupvd94B2SeUIYjQIgyFxF9n6ZLfbVmtr5j8U9hEvJ+XbtGJqdwUo44FH6ZoE/kllv50w
	3Q6gRQHtj3N7pxSz2PGAXVcGZD89SsY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=baOz2Z00;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E9AF444A5A;
	Thu, 28 Aug 2025 16:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6481C4CEEB;
	Thu, 28 Aug 2025 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756399155;
	bh=0bIrfHHvdndRjxfSe82hZYDrXd8C517S0JeqnePV9n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baOz2Z00VcExfEIm8pFmHSW/W54UqYkfu7WwDgA8MZJ7mHYql6x8p/aw875eZ6a3z
	 HSZiDfm8Y4qWlsTVji6/oYcVodVlnmusXpzJAzYCvkrhZrjEpQYlrw1hQUI8sLSQB1
	 e+IYpCouV432ekjDknSZmqjWmYBMXVtvENipdi1iGFgXBgg4FoAXzjxuET6a+iKJiA
	 yB5ZFFDC5/bsxHPGD18DPidUfJX+AEHo5iXOi1x8MMypZ2a7mC+pMtIVyOd6wsUIeI
	 UD5+U6b0L4WGkJnAfui35HVyUSbapyhCLeFuoJL3/4N6OjMFXHvoSALUZeKy+zo6vR
	 E4ODLC18G/JEQ==
From: SeongJae Park <sj@kernel.org>
To: Chris Li <chrisl@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v5] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Thu, 28 Aug 2025 09:39:13 -0700
Message-Id: <20250828163913.57957-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CACePvbXnaWZh61aH=BHoGDqbKvBSE52Me+PpE-WMXcGpRy0FFw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4320F40017
X-Stat-Signature: 8ceup6gw6i9c5hzuzshss93xnzsgu8xp
X-HE-Tag: 1756399157-120701
X-HE-Meta: U2FsdGVkX18W9FAqZC19dGTGGz133mcpEJOPqjbDhya3zUMrhd37GSKRN0O1fIrkXDHUle1gU1ufSrtkOwplLn8fGSU51Wpu/Mpao0/X2yvjKmdX4/e+vATIDNvjAfsGAMj4MY8H451uewZnO96ftJvjx94L0Vf7kQ9gmtBrXO9Hrp0Aqwfx3pNSNy8CM7ra3qUuFxAwqDCDdixx0dRDGBoOxCsnsjUNeLiDOMXPY1tT/sa46BXMGcvib7sb6+r7osX8NPkdiWcsuCUfqYLRNT3Q/R1u8DdhcF0mut3kD9ZKn33K85bSWlyWZ5R7Jut7a0E+vNGgHjOn/fgCc4Wy35gakNLBWOHFqRJYjT4cwynKYoIWVGLECRLFsfqcL6yZmCpngTipet9BAD3h1LmoBUb3sRydaC+/nd+ugxOVDBKuLQHBe1Au1MOb0bt1RsH12JMd4s0dqMd6wSyPVIKZwCcOckVqA4XSNABWROIxa7fz9PWICpdeDuoIAqZLFEs8VTDwOYBhZwn0AXh7Ba5i6qAD1p3HOZfhEmUVlkP1jBYnTO3J3D+4WCmQpVcO7E5uPD2jgpUVqw6aqR2Y7i2Yi83lNWyIMNZnIbxVwefhjklrReMvz/PUS6eRJM7p/qa4Jv32lh9aBHfl3Y9Jpr2uI32/GE9ij670s18qtsNcvwpgOHCPW3YqkoLP1UwjAHfrbdBuz8HYcN+rdtNULQrBcsCLEe17x8H/VCHH7qEJW48/7FFX+k42q8WpIOQLUao4PIaXtPw70vfxpifDU3ADQF6Lto678hcCGIrKsVTHflWj0crBvkbQAJiVYfegUUPmrNaseKqvCIE05AHuSW4PaN5QRXWmq7/kq2gPFmhfKFLjNqWc3il/mKq27Jzd8PjcvFF6+CjHNJRV1bWlaibPcqrUiPhvqdHJBxnJXWtO2EBHN3X7pHWTOVt4osirrKH9oCQjmR1Q9UjTQB75fQ9
 Pg/HPE26
 nqbUW10kh+NQdls02cWCFFkl7T3ca7r+93HK5wWne+xJT0g0btCqbUqxrm6qVvXSSW050Bm0K7xN2JbyVv/SjxLpj65ycJaRaTCp8yYbuGjkiIs7GtjoIWfEtRestLXelffpD1F+bpkdEZOyZq9YuU4z1VJKbsCx71XRKq+/Ur9HtFOt0q5oZPj2TpWpSqJsPxQvmFdUJicY0G0cQRK15KXOG1wxHlNJFn6N5bfmD4Ud3ITWwnrLx4BVK9IxjxAh+JVrZL0DrAsd2p2MNkleuQtdH2Q8itUlA42pxsDuW9tmQQCHxZJ1WTKbhKgvdl3LfoJ4Otc7X738DxaRw0yENYapvcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 14:16:37 -0700 Chris Li <chrisl@kernel.org> wrote:

> On Wed, Aug 27, 2025 at 10:45 AM SeongJae Park <sj@kernel.org> wrote:
[...]
> Anyway, I just opened the editor to check again. Yes, if we goto the
> read_done, the if condition using dlen can introduce a new incoming
> edge that has len uninitialized value to be used. Yes, need to
> initialize dlen = PAGE_SIZE or you initialize it at the memcpy of
> page.

Thank you for confirming.

> 
> > I will post the fixup by tomorrow morning (Pacific time) unless I
> > hear other opinions or find my mistakes on the above plan by tonight.
> 
> You are too humble, that is the normal reviewing process. You can take
> your time.

No worry, I just wanted to give you an expectation of the time line :)

Andrew, could you please pick the below attached cleanup patch as a fixup of
the original patch?  Please feel free to let me know if you prefer posting a
new version of the patch instead or any other approach.


Thanks,
SJ

[...]

==== Attachment 0 (0001-mm-zswap-cleanup-incompressible-pages-handling-code.patch) ====
From 867c3789fa80ac163427f1d7804bf2c8667684ca Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 27 Aug 2025 13:18:38 -0700
Subject: [PATCH] mm/zswap: cleanup incompressible pages handling code

Following Chris Li's suggestions[1], make the code easier to read and
manage.

[1] https://lore.kernel.org/CACePvbWGPApYr7G29FzbmWzRw-BJE39WH7kUHSaHs+Lnw8=-qQ@mail.gmail.com

Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
---
 mm/zswap.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index f865a930dc88..e5e1f5687f5e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -952,6 +952,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	struct zpool *zpool;
 	gfp_t gfp;
 	u8 *dst;
+	bool mapped = false;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
 	dst = acomp_ctx->buffer;
@@ -983,9 +984,8 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * only adds metadata overhead.  swap_writeout() will put the page back
 	 * to the active LRU list in the case.
 	 */
-	if (comp_ret || !dlen)
+	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
 		dlen = PAGE_SIZE;
-	if (dlen >= PAGE_SIZE) {
 		if (!mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
@@ -994,6 +994,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
 		dst = kmap_local_page(page);
+		mapped = true;
 	}
 
 	zpool = pool->zpool;
@@ -1007,7 +1008,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	entry->length = dlen;
 
 unlock:
-	if (dst != acomp_ctx->buffer)
+	if (mapped)
 		kunmap_local(dst);
 	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
 		zswap_reject_compress_poor++;
@@ -1025,7 +1026,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	struct zpool *zpool = entry->pool->zpool;
 	struct scatterlist input, output;
 	struct crypto_acomp_ctx *acomp_ctx;
-	int decomp_ret, dlen;
+	int decomp_ret = 0, dlen = PAGE_SIZE;
 	u8 *src, *obj;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
@@ -1034,9 +1035,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
 		memcpy_to_folio(folio, 0, obj, entry->length);
-		zpool_obj_read_end(zpool, entry->handle, obj);
-		acomp_ctx_put_unlock(acomp_ctx);
-		return true;
+		goto read_done;
 	}
 
 	/*
@@ -1059,6 +1058,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	decomp_ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
 	dlen = acomp_ctx->req->dlen;
 
+read_done:
 	zpool_obj_read_end(zpool, entry->handle, obj);
 	acomp_ctx_put_unlock(acomp_ctx);
 
-- 
2.39.5


