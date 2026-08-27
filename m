Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A86CC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB4F6B0099; Thu, 27 Aug 2026 19:47:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65BAC6B009B; Thu, 27 Aug 2026 19:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598CE6B009D; Thu, 27 Aug 2026 19:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39B136B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:47:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFACCC022A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:17 +0000 (UTC)
X-FDA: 85148688114.11.32F9372
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3F4AC180006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=INwDxHpo;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787874436;
	b=rJUw4QD8RgnqQ19RoOPLNmQEb6mnI2cCCi7TTSPWLw/LxN4J6c10su8QlYpF+aYFkLr/2x
	C0KVcfoXYDRUF5OZiyhxmbfh/fVlqv+TBgunWW5fjuUrXFFZwXog9AqDgbx7xZjnwdUibZ
	0vWY4cCiIendOJ8CrhXe49t3hXoki2c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787874436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENEA/CG+RwJeijNigZCVNh2GWKHCE7Bxn/GSW/9uiZQ=;
	b=2dzgfjIGXIGFZy+g9eD8y3lk/SLO7uckyO5uBNp66jIQvHIi9spZNn6s4cVvog8m9eEbPQ
	mBqilxP2gV065b0vkc2I1u1fuczH9ZiKlXWI0W060WpcXqqlLigwTUod2wP82HNiCAUZQo
	EuzsSiVMLZGdLBy1IRj25i163C4YZN0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=INwDxHpo;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82D9641830;
	Thu, 27 Aug 2026 23:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6021F00A3A;
	Thu, 27 Aug 2026 23:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787874435;
	bh=ENEA/CG+RwJeijNigZCVNh2GWKHCE7Bxn/GSW/9uiZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=INwDxHpoZfJUz25nZdJH2zfsSzwfFzAyCq2FqmEWlBP/GIKCFg/m2jHIsLx3VwVxS
	 xh/43XUdKqF5D4nTevs3HGd144LxVkFnODKo4C95dPRhqb4SpHum2Y3vEJbEsw1NAp
	 V77++kFgREKKbbAmEs+92hhZhKGorzALq19VoZmMIkIVt/JihqdY5X30FXuDwllrFN
	 Nth4Umk8k030Ui9vMATIdgnPOCR1RUN+snvhn/XI/JLehg/Fb2/eLr/G4g72q6viLE
	 4faxZXpglvH1nlx5TQlL951jrYNTDKOgBVmextsDHvp/YuLtcUOc4BjXaOWHBPM5dk
	 DWuu0pYhXa/kg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	lianux.mm@gmail.com
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 1/7] mm/mglru: separate folio generation update from LRU accounting
Date: Fri, 28 Aug 2026 07:46:58 +0800
Message-Id: <20260827234704.63163-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260827234704.63163-1-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3F4AC180006
X-Stat-Signature: b7cwsujba3yaknye6tsa8d887npsdcwf
X-HE-Tag: 1787874436-195869
X-HE-Meta: U2FsdGVkX1/61qn9jj1olV54SrtBhLmprdihghL0HtmaRVI0tTI8X6AlKP+uvijZAVPphHnOR42K/0a8aWAlJHUrKsoB6hwJ0GwoKgjDYwEQOSmChPxIv57jxwA23xn0Fd/PJ3J9SmcMWjXeO8ZwAvdomD2pZjrsDjmqbr4xaIxJWxM7/dEqGwDZ0L5oIJj7C0+azJd81BR7Zo6bt4pSGj/Tru1KSbekoVZUBJC7LbtJbNECWGp0LY+YKXfrhU/vV0APjRsVay+yrMNA8g4ctVyOrT4tswS2Aizw0goOgOGyqnWykCBkwmDJpctAkhZJ2wte6Nn+p7L4IvsUVy5bn3GuE62Z0TMzKMAAng9uNAkmGotZhmNZuNCSwP1NNynzBP5Hs7e8zd00jkCSGAT/VovgeXZdfkJC1cI7qh2DhkLRS/LpiSRBqBYro8CmauGN1bZl7xhBug828Rz7qc51A+eX5qokLcYvIp097dnYV7p5zy42k+p3HNNBcpdb/iJI9ey8eqkefi0cH1LXmK81Azrwx2QkN4Vpx9HSEmfBGuY6YorpZ4qaLEiMNY8OybMj97BC6asq8vpymmXSau2J7bKSNuWOreJaFykDIzJaiz/oBH++LbwfYb1WmE6S/mpElMQU85H3tbO6lzh2AkjD3UFR9bmvnEZS2v6UWdZm8dh7v7293qFdtCgpvSrKnC/h5jxW6mJrlWrgjFgrck2b9h/x1asDDzpDBUsf4ktwT/jgSVMHmwEsnKndeTmgToZHowUHXau85cpkDBGwysZ6ub1t2/IydK0vic5rQnA+jLpr3mzAdg3/BjcR4dZk1rkrddEBFaszou6OUw4hOoxYtHTYAUsMazSng/qhMLOAQJveGRR6faBG7wN89jYkl6S3jsLMgurLAwU9qjEYt7vUNwsiqJ1PtxelGrU+KorM78UqBH1PWtUxSuxDnwnfHqIGZ58ntA0MwuvuW/gPzAu
 l//20VS2
 81CZ0p+Uj++yUIBWE4gqEuBwMv1lYIjB5s0LFiR8pSssNjef0Fh0v+LkQS2PZ7wCk0OD13pkv61qYTCSyAhVQWnVd7OS8ekiJ1qq5N5dUXVVTRTIIEueqzI9H05xsuIbBnFjP7N+V9jzoiTuoijaGf2N/41OEW44fMRnMcoTAyBYHA+rEW5F+lk58gzgMRE6KNqFeIxjJ54Uluu05YEiT6mAz4eZrLZp5QtXpxnxxnYziQY/tCRgokSv2UGzLGc5PJnfjP5T3mxtjOG+VEGRXrJ7yK/50hRf4iHxynmpPAoUEIjH/w1tPc5F+eNJhwz1CDg6FIMw4X4eaFns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_inc_gen() currently updates both the folio's generation and the
LRU size accounting. This makes it difficult to batch the LRU size updates
when moving multiple folios.

Extract the generation update into __folio_inc_gen(), which only updates
the folio's generation and reports whether the generation was actually
increased. Keep folio_inc_gen() as the wrapper that performs the LRU size
accounting when needed.

This separates the per-folio generation update from LRU accounting and
allows the latter to be batched by subsequent changes.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmscan.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fdd13299a04a..8f187d296b8e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3296,20 +3296,21 @@ static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma
 }
 
 /* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
 {
-	int type = folio_is_file_lru(folio);
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
+	int new_gen;
 
 	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
 
 	do {
 		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 		/* folio_update_gen() has promoted this page? */
-		if (new_gen >= 0 && new_gen != old_gen)
+		if (new_gen >= 0 && new_gen != old_gen) {
+			if (increased)
+				*increased = false;
 			return new_gen;
+		}
 
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
 
@@ -3317,8 +3318,21 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
 	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 
-	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
+	if (increased)
+		*increased = true;
+	return new_gen;
+}
+
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+{
+	int type = folio_is_file_lru(folio);
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	bool gen_increased;
 
+	new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
+	if (gen_increased)
+		lru_gen_update_size(lruvec, folio, old_gen, new_gen);
 	return new_gen;
 }
 
-- 
2.34.1


