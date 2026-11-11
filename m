Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E3AE60A3821
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lXqDEgFQ
Received: by kanga.kvack.org (Postfix)
	id 696466B05CA; Wed, 11 Nov 2026 10:36:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66E096B05CB; Wed, 11 Nov 2026 10:36:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D176B05CC; Wed, 11 Nov 2026 10:36:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33D016B05CA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:36:01 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C887DA0327
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:36:00 +0000 (UTC)
X-FDA: 85423238880.16.5E43B3C
Received: from mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	by imf28.hostedemail.com (Postfix) with ESMTP id C9163C0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:35:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXqDEgFQ;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794411359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fj67uJIexCq/nLllAUwirpRaTK68JNnZnw90fZ+XBzg=;
	b=YWZqtNXpZrcbnUq1nk7DO/jiaeHDPZktIx00cbjdkmxm87risxNN24R24THMzi8wK54s30
	oLbej894XWHOzgAKWqEnr4x6NTI6Wlgoc7P1cVYHs+BPYPKmkluIM2/yHXO2tydUHHSXbY
	LkGGx2e7xAc71wU8HRsqT2mceEt7xm4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794411359;
	b=ETRCvBrPX6QAfsqwuKHVVTmW+fIySiODEYUjzSNSd+igWzVhuE8s9aom/1dAcpoLbF8E+t
	0M+DXvT+oWBupEOM7OBLv1gNYK1wwU2KTbkkg02pyQdgRiQebKxbzsfLhk6aHcFOq1Ieii
	zMdFm/MfhfOxElDGuiOxcVGqxxjY03E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXqDEgFQ;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cW3e6v6S8n5JercVte195CK4nR9zZ28vbmPV4+LMgoQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794411357; v=1; x=1795016157;
 b=lXqDEgFQs69ZIepWDgXjCTUbjhRebCFqTIyg6OfAeio52PM7KbzGOs/Pi0QGQZVL9e9q7AvC
 mQA1KvSgaj9bQc7FvHfUlBEc4KUpphQ1Y+/zzG4twzU12HWkhm/EqNdNJ04+K6q7MIN2LbWeygU
 neof1gSc+H7sy0KbubsK62rE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 57900353a63a43d2;
	Wed, 11 Nov 2026 15:35:56 +0000
X-Mizu-Trace-ID: 57900353a63a43d2
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	terrelln@fb.com,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 1/2] crypto: zstd - use vmalloc() for stream workspaces
Date: Wed, 11 Nov 2026 07:07:39 -0800
Message-ID: <20261111153532.1036709-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111153532.1036709-1-usama.arif@linux.dev>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C9163C0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kfr5kofkuhp9td9tonkwijxsiatjdigm
X-Rspam-User: 
X-HE-Tag: 1794411358-933620
X-HE-Meta: U2FsdGVkX19edZrNYyaisGikJt92vCcvp244B/zsFXNvK4RkaiPW5W1gJW4Rpkh1b2+WUcFoGfhfNz3u+bet5NUYPEuJoi989cfVyLh/D3Z2qNBbxKRr2yWY2/M8zv6F5iwkzSt3NKKXovbdkEcVqO3SkNgNH8VmBV4EQCRMcIcL9Igfj3iTCVyyc2h3Fq5Fcv7I5VBtiXPg+EbbbDB0J18CQ3a1kgFexCIEneDSoxBzftZFsqI+HyxeMQfwW+437kLj6fKtCFSPcdXpUDNR/tKV2Gn2VnjeEOixCMAm3PSNlfu2xi8Ghph7WeoVgqj07xyDyYttp7ININ5ccNuw4IrqFJfZxVVlK1HXEQv87Aq/pSJQMO59O39wGO4t8UDOgAsficfdfLiF7XEtlhqGLJPgGYCo9qg3R+wQwy6bqMguaMjZ5wjkmNCi2y23JUYP12RHVegh7qpcgweyc91zn3CjJlNe4ynQEOudPrWLJvKIT8G9kLEuJim7SlhRY6TtHsY9uJk+FA8BYnx1/KYqVv3+byw1P3eKI6aodgGEeDuYevbRVdDkIHIzDzqqkXju+lCiOzIGtNRfOFyL/KtZo0JRG3HtHhBNnCDkjBciRL5c7U+/5+xSO80WxBfrmH5TsWgCC8Ya2tStuohl7fvH3zacJ3Zu1eWLx2mTnj3KPn1LAFY6TKN9o3ZIPLJBiS45XeNM9NAieuZl8n4IMPQVFXytRRxeYNl0FejdkzhF7FPhSS23Csx32bHZCAhA7rrn/qaAnG1TvFfINbFICBqBl+C26PqprUdq5HKC/a6/QlPE1l+OCDlOh5iji53s32y8h42/Gjk0syDUgOjX8VrtXrRsEMCbE3uaH5yT/nPkZuYUyWxJ5yAbN+gH7j5MrtBPx46cebqlyEE0RFywX2xoecRO/3J58Pa2PX1CAPHsTqXDGfgUORO8MKrmpRny6x499k5Nhbm/fcQPSdX2EI3
 m5KOAMN6
 jVQb7u365HZtG+1vgBDdDTNRvgibVjGxSTlHS1wlpwfjg0WDaP3aWyyR20d1Zs9phrByrNU5UYeYXqY6Xe51vvpogwfHnckS69yZ7dUqEb+49lV3PwHT1LJPtuB/nVxCocn872To+4qBNYdF3sOvSM55wRrOMf+ZmtxH0X+QPHo2Ozy4KhW4R1egxOFWu9Wy42poQhPbWY9fh5sMqG4chxZnqvTTm35QWdycB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The zstd acomp streams retain their workspaces after the last transform
has been freed. The first is allocated during transform initialization;
additional per-CPU streams are allocated on demand. They are released
when the algorithm is unregistered.

In a 4 KiB-page x86-64 build, each stream requests 1,566,281 bytes.
If kvmalloc() succeeds via kmalloc(), it occupies an order-9 block
(2 MiB). vmalloc() needs 383 backing pages (1,532 KiB), 516 KiB fewer
per stream. Across 384 populated streams, that is 193.5 MiB less
workspace backing if all would have used kmalloc(). There is no such
gain when kvmalloc() already falls back to vmalloc().

Use vmalloc() and vfree() directly to avoid the high-order allocation.
This uses vmalloc address space, page tables and bookkeeping; the
figures above compare workspace backing only.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 crypto/zstd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index 76bdaca327330..f012293919368 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -44,7 +44,7 @@ static void *zstd_alloc_stream(void)
 	if (!wksp_size)
 		return ERR_PTR(-EINVAL);
 
-	ctx = kvmalloc_flex(*ctx, wksp, wksp_size);
+	ctx = vmalloc(struct_size(ctx, wksp, wksp_size));
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
@@ -56,7 +56,7 @@ static void *zstd_alloc_stream(void)
 
 static void zstd_free_stream(void *ctx)
 {
-	kvfree(ctx);
+	vfree(ctx);
 }
 
 static struct crypto_acomp_streams zstd_streams = {
-- 
2.53.0-Meta


