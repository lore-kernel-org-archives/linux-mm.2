Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C50FC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 03:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BBF86B008A; Fri, 24 Jul 2026 23:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D156B008C; Fri, 24 Jul 2026 23:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CA86B0092; Fri, 24 Jul 2026 23:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF6206B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 23:57:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7DDEE140243
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:57:41 +0000 (UTC)
X-FDA: 85025939922.14.224E01A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id CAFD440005
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 03:57:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VawCDvWX;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784951859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k27M1ifd+dlCcvlTjTpk5IYjKpC55yJlcfhppDsrzdk=;
	b=Z9vSfVXixBQP1Xk8WEqSuiA7O8uCOh/y2ZnFaTf2AAnJLLOdfaSx2JRl9H2jTRCGKYiSP+
	PZ6HDKNQYZv9cOYED+Rvv7XIfr8cM4e+gcFWECrtIQrAh9Veck5P+0HF8u9vwbQDyXFeOh
	ESqep3rLwTIXnqL+By7kZRxrcegnPoQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VawCDvWX;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784951859;
	b=fKQwntYdLUY7+3a/559ieNWhTSdTPUuNUK1LHkFUr8FBPNtY2o3xJ6tPalB4zqiPqsyBGH
	71LmlvqhtzwWISZ/fPva4AfLr0G/+WY5TkGbHRZhyvO4xN2GlrHUaKLOk+sdwJI4fPoRdF
	Wpe2P0sDqhxEsZ9NEUXGASr3mmG3ghE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BD0A40110;
	Sat, 25 Jul 2026 03:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E8A1F000E9;
	Sat, 25 Jul 2026 03:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784951858;
	bh=k27M1ifd+dlCcvlTjTpk5IYjKpC55yJlcfhppDsrzdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VawCDvWXILXVBYEk9LeoNq5jQOG6vtTu0/IQgEP0y9WMso66ndvfswCLyjgJngG5Q
	 sn983AGJTIMjEZNI9lpv10NOkD1ViTHdqcuHAAsEm92HOA7LYvJLnx0419ZwcFOqBY
	 JD/JGsjtob3YZp7lciyvTBIYj4Ro16V18ToWdK8Xyewl9B5lMjWYIJd1de8FfX8/p7
	 3UlnFfR5Cmjp16IuMUKQqL7Z8ARJe2oAeduCyZWB4VWKAvCeoP3vJnWDLfC2IYrBEL
	 a5/nryA4cusXJ81RnvR9y7i0UFEMwMVJbpnqZ+KMpUC06/O+qyZHIabU5mGaLoktzR
	 BeQ5VpQhAwhxg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	haowenchao22@gmail.com,
	haowenchao@xiaomi.com,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	nphamcs@gmail.com
Subject: Re: [PATCH v6 0/4] mm/zsmalloc: reduce lock contention in zs_free()
Date: Sat, 25 Jul 2026 11:57:33 +0800
Message-Id: <20260725035733.53241-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <akynv_js-5G88rGd@google.com>
References: <akynv_js-5G88rGd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CAFD440005
X-Stat-Signature: qxwtakw76urd3ekizo3twamg3qochmm4
X-HE-Tag: 1784951859-569867
X-HE-Meta: U2FsdGVkX1+imLE91Y/R358zTtFtKbr2zicWLXryASOvCnwtRAiLXlvM6AkUBBV2su7BJyax+wHEQzt9eOJPUGjWuM+inwzYKQN3/tRD86v+pYUrUrNaF1M/ZaXKrrpqqW/JGOZDU0Qmee5qWewzsPck7XwMLZJE3wrqKi08573z8bfpNT4omct084W3zkkL9AunRIPAGNB9V9qOMEKF/c+bBPMk3iS/CE/3WwD5uCUkxwCK9OAJEjUcx/7SD1dO938z1unJyS65edpZv9EEQmSqvIefpX7zGX1q0cjoaLm9wOdNiyxnpwnjfg1eKT/Mc8mg3dr9d60r2JJTySOW/B6Pg9/VsIThlui+QagUVhsgXwhLYmDI0RD1MUnEIkqpcCP9KDPo18ukpaw2P2DrwqW1/EVX+IK55TYla59t38a6yjP9EElAaFFdR8aBK0lKgCWV+SMJJaO3nO0UApnPtOVuj+019HqRfw8lww47wFE54YtR1MjTeJ+mXcUNgUzQqFR2d1xHpanZ4xXxIgpE2byImCAC5pOaIpU/NocCdTYn1gqNcP3eo35a+ghm6X2DdebFYv6CNkIdZtPc6gJtql6D78YmigkCrOoToWZOVbU+/WenRAD1QTkF3S6428bzmLInNTv9SXvwcXMx44HUjMzf++bMeNrlHq2kBatpFn4LyJGFpVoRHD3K83LD22M/Mcn8BJAFMYlkxjHMngIzcXKnnrwjBDEYn+IWh/BoRNp5T+nI17pkLFW/gnHUKMFE01fwCfMUfGDswVg5DgQOSnC7h1e5N5DHPPCl1Ab4guW11xOm1vocpMis/bvx5J7drVnwVF/dVQzfjEGalUVUxHQMsqFEFyeke773DlLwxKXZ3L6UOCOMsDfwiAouvkkffSVvM9KX5CW67ISikweqpCqMTnVTDDaeqV+2dGppp4+Gp2RYdq4/G12OuxPG+LPn/cq3ZUHRu21Pd8qOmsN
 fN66km3N
 aDq66JJrAPeyRLn/cS8k9NqWfTy9dF/tDrrKg82IFNmLjSBrIzjAlPC6ti31RDkiVDfZZzmJCM6qdJAuGd5yB/NPUCg2mN2TvWqToYe6lL5MbbXAVksPGR/B8AuEddnfbRsDsOASPZhn+IwwH5bY0SkCr7JB6iHDn6EZ2pqLybnH1TAxSbzVqidFc7tvAyP4bkLVCjb9JUtCfxRopCHqQpLizmN4XsopBMZ0FoFiCsc4t8/VZN2YcXCYuMjYCMNym5EGte5Zq1NdjjgAQbMrIZZvTTxLndZ2vYTMO1zm1ZLIaDgS/DqBFztOmyMYObzAN3UuIF9mT/xtqtfuV7C/74gT5HB01aOUhbDuJe+pxJ3wvEbS8gdBkjhRNEXJGvK6HYmtqwvTqvqmcY2Do2UqjU21WqbJbiqC1gcUM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 12:55 PM Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
>
> Apologies for the delay.
>
> On (26/06/27 21:36), Andrew Morton wrote:
> [..]
> > > Raspberry Pi 4B (4-core ARM64 Cortex-A72):
> > >
> > >   mode        Base       Patched     Speedup
> > >   single      59.0ms     56.0ms      1.05x
> > >   multi 2p    94.6ms     66.7ms      1.42x
> > >   multi 4p    202.9ms    110.6ms     1.83x
> > >
> > > x86 (20-core Intel i7-12700, 16 concurrent processes):
> > >
> > >   mode        Base       Patched     Speedup
> > >   single      11.7ms     9.8ms       1.19x
> > >   multi 2p    24.1ms     17.2ms      1.40x
> > >   multi 4p    63.0ms     45.3ms      1.39x
> >
> > Well that's a nice result.
>
> Indeed.
>
> > Sashiko AI review said ....  nothing.  I don't recall seeing that
> > before ;)
>
> grep-ing the code, I wonder if we maybe want to tweak some comments.
> Namely, zs_page_migrate() says:
>
>         The pool migrate_lock protects the race between zpage migration
>         and zs_free
>
> which is not entirely true anymore, as zs_free() has a lockless path
> that doesn't take pool look (when ZS_OBJ_CLASS_BITS permit).
>
> Likewise, __zs_compact() says the following about pool migrate_lock:
>
>         protect the race between zpage migration and zs_free
>
> None of these are critical, very minor.

Does it look good to you if we squash the below change into patch2/4:

From 49091bd19445c8927ae063042bc7394e7cc359c0 Mon Sep 17 00:00:00 2001
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Date: Sat, 25 Jul 2026 11:45:09 +0800
Subject: [PATCH] mm: zsmalloc: update the comment about pool lock

Update the comment to reflect that `zs_free()` can be lockless when
`ZS_OBJ_CLASS_BITS` applies.

Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/zsmalloc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 3d566a3ee96f..b5eadee0e8f0 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1865,8 +1865,8 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 	pool = zspage->pool;
 
 	/*
-	 * The pool migrate_lock protects the race between zpage migration
-	 * and zs_free.
+	 * The pool migrate_lock protects against races between zpage migration
+	 * and zs_free(), but only when ZS_OBJ_CLASS_BITS does not apply.
 	 */
 	write_lock(&pool->lock);
 	class = zspage_class(pool, zspage);
@@ -2045,8 +2045,9 @@ static unsigned long __zs_compact(struct zs_pool *pool,
 	unsigned long pages_freed = 0;
 
 	/*
-	 * protect the race between zpage migration and zs_free
-	 * as well as zpage allocation/free
+	 * Protect against races between zpage migration and zs_free()
+	 * (only when ZS_OBJ_CLASS_BITS does not apply), as well as
+	 * zpage allocation and free.
 	 */
 	write_lock(&pool->lock);
 	spin_lock(&class->lock);
-- 
2.39.3 (Apple Git-146)


