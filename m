Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DCBBC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 10:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0416B00A5; Wed,  5 Aug 2026 06:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270566B00A6; Wed,  5 Aug 2026 06:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186F86B00A7; Wed,  5 Aug 2026 06:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E14886B00A5
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:07:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76A56A1D33
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:07:49 +0000 (UTC)
X-FDA: 85066789458.05.CA2A210
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BF1A8140009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:07:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fUJU4mD7;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785924467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpH6sf3viGP25/XL26BruqgaIkBu5ms7EKOCOM53Zpg=;
	b=sae1DcGI4OJrkykZOUCAh22H+nAiRkfpxvTtMooaEC7SksKUStwSZBWALeo2Y/6euerGSC
	CskM/W2VpY6+C+v3aB7MJ9g4HGNcWLaoo6DYjUUtQ1wH43o2eLyx4/D9dwfO9svuacpHyR
	Co50CyHRwtvZfJYj87uKDSG+AlDS0aA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785924467;
	b=i3K0EZqGxjXlxrSfUnD5nC5U/Q1drBaH4nSRt5bLbHyqXUF40hw7sMuZJjmj2xumhv2cXk
	VZAhdduA8j+1FPBBpoJQnOkxCBT97LOGsPHhFsnq0ehCHtu0+mOc2UOgkfyuo6Sz7v4Zwa
	svY/v8ipRvKOfEo7mlffkz92Tpp1rc4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fUJU4mD7;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 319D5401EA;
	Wed,  5 Aug 2026 10:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFB21F000E9;
	Wed,  5 Aug 2026 10:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785924466;
	bh=OpH6sf3viGP25/XL26BruqgaIkBu5ms7EKOCOM53Zpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUJU4mD7++zKSDGatk7iEqLYxdXukaLXAPfjZMSqC3EDLxbHjL6fOn7KHWUu0/6O0
	 a5JgRjL2pxH68NptmLbnQgkzBnyW9OPJD9cHmXRUVbi4iVHDRJKd5TgPTuLgf+aBxN
	 DQzxJ+6wYNPmOf5xDpBBAYOdz7qEPGeEW2DFv8IShsI3S817lVGYMAMCsQs+EEyvRA
	 4w3d9djLloGwuWXm45G6lv5KQqKpi8fygivQVwa8cJlG3yZuOQERmWGbfsst+X97vw
	 8IqCpw99smpx7MkNGOgPuCMqpyfUbNdhp1ogNOVgXi7MGuF6kzyjbiC13nfPcyP3cA
	 0XSKVs7p6RtrA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: baohua@kernel.org,
	senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	bigeasy@linutronix.de,
	hdanton@sina.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	ryncsn@gmail.com,
	suleiman@google.com,
	surenb@google.com,
	yosry.ahmed@linux.dev,
	zhangdongdong5@xiaomi.com
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression backends
Date: Wed,  5 Aug 2026 18:07:40 +0800
Message-Id: <20260805100740.71994-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CAGsJ_4xU5VN3abCPzACZoS92MqaUrMHn9EQ1FCJD+wy=upbbMA@mail.gmail.com>
References: <CAGsJ_4xU5VN3abCPzACZoS92MqaUrMHn9EQ1FCJD+wy=upbbMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BF1A8140009
X-Rspam-User: 
X-Stat-Signature: kfr8qmdju3ywz1y55c487mmb5sc841u4
X-HE-Tag: 1785924467-555847
X-HE-Meta: U2FsdGVkX1/B/mlocUzfScaShJhr/SqTABczyaKcE1rFjgAvnVpPedLZ8if9z7Dn0KzthJBRcAGGT6+oHcyk0fEUZ3D6qm18NUYTHKGKs6GzqUNCEJ97y39nkNzQiLeosQRdyzJcuV9JBG5vsMYp9vn90iOl1Y373f8fJrpemPVXi79S9pexquMTEe1pPBUlGQ2AaDz8SUNNW5yMbKsOYI9wRKX3PHtzT27RmsSm2l4GwJfH0Xv5o0a4cFYFEZgdx9eK6lP+xyuSKGTEkXRIfuV5k3R/bvouwGuh2ZtTf3yyJ3av+lhrmbZHADaCM2z8MiVb4+Pw4PZfzwj808J8nAFn7Cq85+94ZoVsaYWTc6p58bxMAADMoqBT8lvUEJwupVRPF4mPdhaE1xrwsjhS/wyGR/CcqOX/1SHeBBqB08DiZEzYvRCI+cFJsFuXlkrKvB/fHTfOYXfS64Nof/EhYNHCufW4rGjoKlX5gefZPLeKcC0S3WCA0Q9Pc6k7+QlYM7s1OoqHkyrEGg7kzg0viq1aj7Sue3kT8MY/ZcyAKY6RYtvW82TUcz3ubE0xGlWoYxoJ0wo7hRkBROs0H5RBULKlHULcccYxI6K1YrUdRGPwHIvHd2Ncij6kx86/CfYX324me3Jxdo5WRC6diNWQNRERYrf5/Fv/70SUhEbxhFla6WZ6aiREW2WcLOBNfmV2rf20TtYllYy7UW5HB93HI9EuUI4dsiQGfInoYTJOLu+2v7Ggb2xbp1hsCiYG3qf0vu4QvRdiSRqGvyCnZUtXkoWFY+XemZTpIo9vNMTdjgtXfunalZSXESdakrLDXdSY2vyznVuSPRiSjcN2QZA2Yxv323n8sOAJ37keH2lVsAJk7SVkNHO4I6PIYRymjB3bV/GWLu8kTK4LftuCGvAUWOfIDOpBwTYjD3rhW9yPmvtmSm2VrohTzyaUEPbPAsVrnzQDRmVWpaJ16EjTxhS
 Bb2uEUFv
 v1x6NteQ6qobKd/Dm/lYcxcasuF2PqTSbOOnvSgeVjn5vaGOEFlG6V71UXC2++jLHBTEngRjRzO/HlNGbjfHAo05rYzRG46mnc0RhpWNiVktZ+JHWzatsbf5yX0Rf7oWChyN3moYqkcYtA95Yd/FQe4+bG2u1UaGM+hXIB3FkfWW3yG6h5omnoBNLSEpEdg+HdNCWsJvtUQhn18lbHvLgAbt6LAau6zO8vAsuoC/ySrHnK3JPKeqObj/atRcjkW/tJoGr8mIOF4jIhldFtze/DK+9q9aoxZ1xiAKl7Xku0ctRmJBBnuvkyCuw6BtEFxYh7yMVa0tcPiMEYfm4QFCUKq4kqdlW3Amit0Dw3MZ4nW+LmqyMz4LYPAWWbw+IMzKGFPdYJEegQrDXnrpUvckg7alFdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 3:50 PM Barry Song <baohua@kernel.org> wrote:
>
> On Wed, Aug 5, 2026 at 1:21 PM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> >
> > Hi Barry,
> >
> > On (26/08/05 17:09), Barry Song wrote:
> > > > > This report shows that the zram mutex has become the top lock
> > > > > contributing to UI frame drops, even surpassing mmap_lock, which we
> > > > > are also addressing in multiple threads. :-)
> > > >
> > > > Any chance you can share more details?  Are there perhaps RT tasks
> > > > in the mix, priority inversion, starvations and so on?  Can proxy
> > > > execution address any of those (if it has relevance to the report
> > > > you are looking at)?
> > >
> > > Hi Sergey,
> > >
> > > talked with our engineers reporting the issue. i believe it is all
> > > about priority inversion.
> > > proxy execution wont resolve it as we have a sleepable zs-malloc
> > > within the mutex.
> > >  i believe i need v2 to release the mutex before doing the 2nd stage
> > > zs_malloc with
> > > direct reclaim.
> >
> > Well, we cannot just drop the stream mutex and do sleepable zsmalloc
> > allocation, because this will invalidate compression buffer.  So we
> > then will need to do re-compression.  Something that I was really
> > happy to drop [1].
>
> We used to do that by an temp GFP_ATOMIC buffer and memcpy:
> https://lore.kernel.org/all/1611035683-12732-2-git-send-email-tiantao6@hisilicon.com/
>
> As long as we copy `zstrm->buffer` to a temporary buffer, we are
> free to go anywhere afterwards.
>

Hi Sergey,

Just as a proof of concept, I changed one path and it seems to work.
We release the mutex before calling zs_malloc(), which may enter
direct reclaim, and we no longer need the mutex afterwards.
also, we can avoid re-compression:

From d1a4cbe63fc2f7336c23bc268b1dffe15b0e7444 Mon Sep 17 00:00:00 2001
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Date: Wed, 5 Aug 2026 17:53:49 +0800
Subject: [PATCH] zram: avoid doing zs_malloc() with direct reclaim within
 mutex

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 drivers/block/zram/zram_drv.c | 43 ++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index cfa98846ac48..e00d896a101f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2218,6 +2218,35 @@ static int write_same_filled_page(struct zram *zram, unsigned long fill,
 	return 0;
 }
 
+/*
+ * try non-sleepable allocation for !async backend, then try
+ * sleepable allocation; for async backend, we always begin
+ * from sleepable allocation
+ */
+static unsigned long zram_zs_malloc(struct zram *zram, struct zcomp_strm *zstrm,
+		size_t comp_len, const int nid, void **bounce)
+{
+	unsigned long handle;
+
+	handle = zs_malloc(zram->mem_pool, comp_len,
+			__GFP_KSWAPD_RECLAIM | __GFP_NOWARN |
+			__GFP_HIGHMEM | __GFP_MOVABLE, nid);
+	if (!IS_ERR_VALUE(handle))
+		return handle;
+
+	*bounce = kmalloc(comp_len, GFP_ATOMIC);
+	if (!*bounce)
+		return (unsigned long)ERR_PTR(-ENOMEM);
+	memcpy(*bounce, zstrm->buffer, comp_len);
+
+	/* Don't hold mutex to do a sleepable allocation */
+	zcomp_stream_put(zstrm);
+	handle = zs_malloc(zram->mem_pool, comp_len,
+			GFP_NOIO | __GFP_NOWARN |
+			__GFP_HIGHMEM | __GFP_MOVABLE, nid);
+	return handle;
+}
+
 static int write_incompressible_page(struct zram *zram, struct page *page,
 				     u32 index)
 {
@@ -2264,7 +2293,7 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 	int ret = 0;
 	unsigned long handle;
 	unsigned int comp_len;
-	void *mem;
+	void *mem, *bounce = NULL;
 	struct zcomp_strm *zstrm;
 	unsigned long element;
 	bool same_filled;
@@ -2292,22 +2321,20 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 		return write_incompressible_page(zram, page, index);
 	}
 
-	handle = zs_malloc(zram->mem_pool, comp_len,
-			   GFP_NOIO | __GFP_NOWARN |
-			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	handle = zram_zs_malloc(zram, zstrm, comp_len, page_to_nid(page), &bounce);
 	if (IS_ERR_VALUE(handle)) {
-		zcomp_stream_put(zstrm);
+		bounce ? kfree(bounce) : zcomp_stream_put(zstrm);
 		return PTR_ERR((void *)handle);
 	}
 
 	if (!zram_can_store_page(zram)) {
-		zcomp_stream_put(zstrm);
+		bounce ? kfree(bounce) : zcomp_stream_put(zstrm);
 		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
 	}
 
-	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
-	zcomp_stream_put(zstrm);
+	zs_obj_write(zram->mem_pool, handle, bounce ? : zstrm->buffer, comp_len);
+	bounce ? kfree(bounce) : zcomp_stream_put(zstrm);
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
-- 
2.39.3 (Apple Git-146)

