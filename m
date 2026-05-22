Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A4E4CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0BBB6B00C5; Fri, 22 May 2026 11:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB616B00C6; Fri, 22 May 2026 11:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1A46B00C8; Fri, 22 May 2026 11:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5676B00C5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:47:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D3D5A0AAC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:47:57 +0000 (UTC)
X-FDA: 84795486594.07.6ACD13E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7556F2000C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:47:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXmJ8xxE;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LRLg3Pzb74v2r5bZtbtebH98gpHkUBcEoBkx4Qaj+A=;
	b=8Pq7y1u9kd2lDVNnaIAsl73m1gG4FEb/7Vz5qNCv/nfGwFweOONwcbR3nWBP8B0dYQlWYi
	bugEhqIMEbb0hWbdP8dTwgM+nrXWHUhQRQn9H8se0niBRc5KP7MNhPdyDm3bVDn19vUPVa
	nkWdx3b61mwqFZq4iGPESzKjBGJA4WU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXmJ8xxE;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464875; a=rsa-sha256;
	cv=none;
	b=ZcXXAPVVZiMl2ARis/afoB1RJehbGIs/iy/2xexxgUKKA1JRplV5rWkcH91h5NWL6RG+VG
	XbmfgNbT4VH1Jcj54f6wlj+xa+jpWLm3MRZc5Ihmk+uYtyQANIQGMwxMsVGxSRu+pGSmgh
	414/rlQW5nM2yrCn+wdkhMD1C9S7L0Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83108404CC;
	Fri, 22 May 2026 15:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394341F00ADF;
	Fri, 22 May 2026 15:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464437;
	bh=3LRLg3Pzb74v2r5bZtbtebH98gpHkUBcEoBkx4Qaj+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXmJ8xxEVqJk8EwZs4vGzDSg1N5AXkYdEkpuEWmtsQp7DLw+TPHCX+YCjo0I33iWY
	 pq8Z2RcNU4qVdSnOLniVP/FwzKcj4QHyrkE6SNuzzfaOOpcrAj/fpn+1UTGEOaEq5R
	 5yJcY24guNKOe056G/Nftj4aoaKnzy4b/iCP8dgJJmRV7UC6o/TUttzOTiggHwqksU
	 uJ8abn6uskjg9VQTcyxRZUie7hcK/JHO0yp17dsbOiX72BI+1CJKiwmzBby3s2Qihw
	 HTxw0ogANEdaHkwi4cFAwq8fFwm/X7w1VntDpkdzCNHnfcbHFDaqPYA+mHwFRJGq8l
	 SjEbA8op0i8tQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/14] mm/damon/core: add kdamond_call() debug_sanity check
Date: Fri, 22 May 2026 08:40:19 -0700
Message-ID: <20260522154026.80546-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7556F2000C
X-Stat-Signature: oghqnczaokuxpn8xqb5asreysbd5grxh
X-HE-Tag: 1779464875-804142
X-HE-Meta: U2FsdGVkX19FaHSDwL5TR4GbkAJ8AnB0jb9uZaej2ZoGReZhjCYuf/5bV3mf1etVY4eVH1rjbAksdLt96PHlannILXrLocfkn2kjZ2ajpnBtkdv6Yu6RJ3wpq6LX4G0Ly4Vq1j4xfgb4FYy+Fd6xgMpMT64EeGPFNyVdgdHocShI6qX+qL8YhJ1vykQtmR+5PW2AC79O+ihr24zAAB7Y8ZG8oa9RHaB87wYi3CbqVYsdJSQ80nnyexcHU23tCKMd8lD+gKri5MV3TlcOmAVhsz3ngu1oX7T50lhGiKZKqB5AucU+U3c6GLV5RlCCc4dK6H2KjrJQBu6TZkii4tDmpGrmuu4wiLsFGBGN92LfhHpqStH/OsnrPGHsXLQ55gtQCBI8pWzro2j5lKiNyOLJDSH++f91pNDNgObpLDGj/G8+f/LSNMspNMjPzh9FxaCcJnb+2lRI7SEI8Sskvl9goLSK1xMMIvLQe6cuwkDL8CTfnIfYJzW1gVJ8nZxYZCW1op82IRH4q8JaeKAiw4wDFw1OB1bSuj4AgpqCvcuiM8DnemHM15XlJnD0REyTWsqe6I651yv2SDhIEYMsButOQQUpnKeX9OJJwrqkqMBUdeoCdNz+sLMPu8Ll+OIgP3Gn2jI+gQ4CP4PO5vOYaedh9yfSbHmv4MfXLvNHeXLPESGIqeneykmo6MVu7QT4PoXn3KcThp7DCyOM3z9timXl7NurTCjDiOz+fWNMmxbN/KrasGTriddlLu9ETjlQUPH4TqIWpHwwyRUNlV6DTWVf2yzZbpFEC9FUaT+CXjZoOcWvbYoju5KLTP+DMRQEBJ3MePqE0G2GnkYEczIyziEDhlmc7Kehkl1iYVW9s1WlGS7+tTalfgVg3ufqpqOdGe2tvg4froFrL2D2BzjWGbOTSUxOeJ5uW2ylv3CiyzesBmjcBH56MryyKDd0kf9FAPPKJfB4ax8rp+VbllekJvM
 mO19oP1X
 5ryoibbL+fib7RhODhCWEO5pSgW6y3bxsOqdMWvNhmslzN06nZQQMsAq3T6xWKuZrftN5j99Jh5sScnfRV0xoQwYLNPsVyJ0BUSVrrmF/xeLY5lUAWQcDOMqcDXHwuJi0a3C4L/mkYIpUKIbE1qnYgzrZh6FmC36ThunZUvcpp9CavQTJRn7lc5lSkCxb6xRzVDsVoyNsDoW9WBJ8IyXqb2QK2LkQrPKUR+iX9vzkfY9D9UaEmiQRQq8Vc0Ztnyyw0dSLB8wl4KHGGLOGQjWvYFenLQ==
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

