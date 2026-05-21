Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 933A0CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8C76B0098; Wed, 20 May 2026 23:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1346B009D; Wed, 20 May 2026 23:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DF66B0098; Wed, 20 May 2026 23:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 432D66B0099
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B12D1204E8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:05 +0000 (UTC)
X-FDA: 84790058850.24.1B9016F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6F516140005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ks9saREB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LRLg3Pzb74v2r5bZtbtebH98gpHkUBcEoBkx4Qaj+A=;
	b=5tZzH8mAn1T3OXshr9ACNxJvq9c5iWyP/vFlIBl8PdG7MwhDW/CcCTVYkir9lLyFfijz2o
	aIVt41QWPKxdT48+3XCDGMlmCeiuJqYTAMjDPcNm8BELfgz4ZhxSR1WheHlv8egHZDOgtg
	zsdMNPxIhkbFnlfV3lnkW6vPSL5Wooc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335643; a=rsa-sha256;
	cv=none;
	b=xFjsAQMnV6p8lv3F5Q3t5Q8cIk1Gueimi+NIkP3gMy7MhZLFJSURr4Yioaz5qgNAy/GwIb
	jX0kXKJUNhrZS7oDwDRQq/n21IyDhsmyRPWNh+iZOF0G/S60cjHIVZu+vwvjcAvf5i9+aC
	Oc5+pWp0rDGKfyIh2c+/1Q55zJjIhPM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ks9saREB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17D6060202;
	Thu, 21 May 2026 03:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D0F1F00A3B;
	Thu, 21 May 2026 03:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335642;
	bh=3LRLg3Pzb74v2r5bZtbtebH98gpHkUBcEoBkx4Qaj+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ks9saREBtZOWlYAPafkbYozBvHE7crHWSGnyh8/GJsZINt/3zqYHh/B9nm1pDFLf7
	 RlfFGKegD4ZcvdN4oRUK/kDitm5IAELqD+t8Cr+p3o4k3S6Wy9gda5Ri89bn7rw/x8
	 DJkg5jR8VlbwJ6m74+vKZqcS02VgM3xNQ5rTTQcjU+pZtVXiKI1LB56DGnfm+GoC7o
	 nmOahC3p80pHsHOt1jHMAXT0qtUXtPNiflbBWCavuMUPLC/FZ4ByDXBKLAmpP25VGe
	 imHWJgTgMBN1U8ga6TZm3XoCTzjmgQW/hjmqjG1SdEJW5i/YM+zfR+GAzvNCh4gEES
	 n2VBk1rVl/IPA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 08/14] mm/damon/core: add kdamond_call() debug_sanity check
Date: Wed, 20 May 2026 20:53:42 -0700
Message-ID: <20260521035349.87565-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F516140005
X-Rspamd-Server: rspam04
X-Stat-Signature: kogt4d99wmktt1r1owqjfzu34fk513wr
X-HE-Tag: 1779335643-402213
X-HE-Meta: U2FsdGVkX1/nR4Q3q6zwzrDjwaRRsp7ideLIwDiIEPyVpy33Almkz+Bv7romBQFGfiKbSS/sYvouag1UaCEjoq0KG02SjtV2n7aWOAZ33hEfan1kBMAZoTokRKdulme3RLeG5ihcn/Lt0NCaeBATyrPP9/LhhBawGCu/qKWdyq+uijrc6XQILLqQdrNxkaBSas+zAVHcISBHaqfh8r43FTkjo5RAfIPEoxc8t06EDtv/O1u+FKtocQf2J3DxDk6DWe/lPLLWRuIWwI6NBs2GF45gDxAMxi+YL8NKG/2Si+fBHe3j7Dqi3Btb/GRiFCTB9ju5Gy4i8DcZV8P8cSNJQAs4Rvt9SmKd9OmlVTvZSL83H3FwjjS7dZ+0VCJeQEdMxUoDDokAYSBUE4gfwrZ2KjzXKbQEKpCg1s1lz6v6o4PNodrvh5rjzKEuVPdvhvNhn3ZuKV3Kh7hb4nlapXwxIUM+cR0NL5b0XCF0DbLQT3hxcAfoCc4I6wX3QouJr1anALDW24r5+v/BrWH09ApmkQwE0zeK/8Eo5X8cBbS9b8FQWXeRjcyoxaIMkMDTjTDs7K8DcGaEitlauC30AMzmjzxb+gjGLqAjdS5J/k3S9Uv7w5L8aOZbikR7tfD2g4NppOz0jC3Wita86AQpVJKt8aDEtgU4zoBLfubMWhD8l5YSJp93KL0+NdtY08iQpw5z+3yBONNNHCYctnusiluYij6tB5YoCNghmYkhYYZEmIGZFBUeOW169zh05B7Bj1BTfMfy9QQK7ezczL68ulFI1qV7dYhM+eNfbJayrQSLeP42nTRe9Nd7Inb1zLoBDlVvjMO3E2scDXPanwuXQ8z3L2pi9wn9NlHT1QHiikPctPNpsnQycHHvvQP7hs+WKDcuW8dyCQ0nqTvaTVERRepNcW2iAlayjQ/5+gdGSTN0c6254NJ3j5uaCvFuLpxtqC28Wy5Hq128Nk09ST5+f9z
 MeIv+A0x
 CewkbPc6vHvUkKnQcDvCFCxZwxFWiUQKmNCp2rQur2pBD2LyHlPDwxfoyVkZ/lZj8BuKWxzil+gCalmZvsTaKMefIsSHXNa2SHiEjHtEP7QPOJXDnZl5R/AaBUEHceU95CjW8zcR1B0UPJKcecdByn1bPIlfRm2lfeYEjaKvgoKyira+Oxigk9UO+L4uvBAQJJ+BxSZ5F52MOm7JHtZ+9NKhWSe4BdLHCcxozRoNkVQ8SOak0DpDq5kvK3GrAR6/3Z5gg2pqh+LTgpxuS1r7ZClRlpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_call() is the place where DAMON API callers are allowed to
access the DAMON context's public internal state including the
monitoring results. Hence it is important to ensure it is called with
the expected DAMON context state.  Do the check under
DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8a9202937781c..9cde5b47b9585 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3331,6 +3331,37 @@ static void kdamond_usleep(unsigned long usecs)
 		usleep_range_idle(usecs, usecs + 1);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_ctx(struct damon_ctx *c)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+
+	damon_for_each_target(t, c) {
+		struct damon_region *prev_r = NULL;
+		unsigned int nr_regions = 0;
+
+		damon_for_each_region(r, t) {
+			WARN_ONCE(r->ar.start >= r->ar.end,
+					"region start (%lu) >= end (%lu)\n",
+					r->ar.start, r->ar.end);
+			WARN_ONCE(prev_r && prev_r->ar.end > r->ar.start,
+					"region overlap (%lu > %lu)\n",
+					prev_r->ar.end, r->ar.start);
+			prev_r = r;
+			nr_regions++;
+		}
+		WARN_ONCE(damon_nr_regions(t) != nr_regions,
+				"nr_regions mismatch: %u != %u\n",
+				damon_nr_regions(t), nr_regions);
+	}
+}
+#else
+static void damon_verify_ctx(struct damon_ctx *c)
+{
+}
+#endif
+
 /*
  * kdamond_call() - handle damon_call_control objects.
  * @ctx:	The &struct damon_ctx of the kdamond.
@@ -3346,6 +3377,8 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 	struct damon_call_control *control, *next;
 	LIST_HEAD(controls);
 
+	damon_verify_ctx(ctx);
+
 	mutex_lock(&ctx->call_controls_lock);
 	list_splice_tail_init(&ctx->call_controls, &controls);
 	mutex_unlock(&ctx->call_controls_lock);
-- 
2.47.3

