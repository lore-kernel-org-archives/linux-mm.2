Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A71AEFD0070
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD886B00A5; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7CA46B00A7; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B169C6B00A6; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AAFA6B00A5
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:43:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63D251C963
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:36 +0000 (UTC)
X-FDA: 84498216432.10.3CCF621
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DDD7220002
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KNGnR+3F;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772387015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c732e8XaL3VPaykAXs7+eIum9q0sFTSfxWtm5rJcikk=;
	b=5Amz4CdgMaaTn/FtcUL9Hpp3LW2oukJRgBEcHB6J+sIKAGSOQzHRgZa2Rku8OGyDqMuSOa
	SfhYVCBm7nYN1fe6ygbSfTlXvsma1Fmunb685v8sGH5VuHw7226Lfy0+8mQxYnAWJkzlCs
	/c/USd7xGgkTJ9RQsmAnU9O8YbdHN1M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KNGnR+3F;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772387015; a=rsa-sha256;
	cv=none;
	b=dy2qDsSGsiAKy3p3K5PI9oIFGDqJ8AAMQV+teK7x81j4EC0M+oEr5N82jPby0Aqs02NAGQ
	rYIDN5rNgvRqjGYd7UNXXJ30NFooo5GPnwzAkd5iqxNiLcyCvh8xrV49GqGHkGcn/YPnZQ
	aJsHy/yRPJ8SDqrV5Q7jbnhHfTVUgxo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 042C544564;
	Sun,  1 Mar 2026 17:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C115DC2BCB3;
	Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772387012;
	bh=DbZTn4AVN3XfN74TG8oRW8P+LKBDP3hbPLRg+ZDBhJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNGnR+3FH8t7f/g/HbzsZJ1b+HxQSNxrNdNk5f9Ui7Ge2IAItZ5wh/tea1t/N3JBp
	 TEQVVevvzupSjNXtNyFfcwJRQ3aV74r5SIXBO4J6Jo4OGuTV1+N5F+zm7VfL2JHsQ/
	 9BoSHUCJ9+weUZp3mWKkDk5CRbTUgpWyndLY5XGsUvvUftRbgK2FNREvnRmqcPrHpI
	 4eX4OjYPgt1eMRwykzNZsJ9saOMxKhN8+RRhsMU6/4G1UiUVMTeMBEWKkLtmB5j3Gk
	 RMPUoZsLdM0Tr/MDLlLCUCOrxIHZskf4+I9mvm7iPmEvnjouzcDYG0WJcrvZzRzvKP
	 sXyYx+rXCIONQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 07/10] mm/damon/core: add damon_split_region_at() debug_sanity check
Date: Sun,  1 Mar 2026 09:43:22 -0800
Message-ID: <20260301174327.76849-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260301174327.76849-1-sj@kernel.org>
References: <20260301174327.76849-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DDD7220002
X-Stat-Signature: dmjau9neknhbyhiccgtghkjy7a8ucxwn
X-Rspam-User: 
X-HE-Tag: 1772387014-871314
X-HE-Meta: U2FsdGVkX1+oL1O8N7rLyrPzRx2UM4cWbwGy8xf6y1oG9vxRJa2brN3fq3cru0/YfC//CqOF2CCrShrShkyQT0AGCoQKlIUCsqGAt58oaCc64TNuuTCyaU2ZHISWY4b7nvhdFauush+qJP1nYo+cV4kbj5HScHBrTob8rUPOmZ+ULlVrTdM2Tq+hpoOLqd9245uucaXz8trAGaBtLhZbIQW7IGSmxTGd8D30k1ayCAKAEjN1O3JXhxZLr59x0+yhUPEtiAuEEhO3azABZFbQ0E98+qLg0eOCj0o4UrQBPceXL6hTy5z/b1GYqXGlxpSvZf3mve6xjaOK2GrhkdaddPzEVBJt+/tOILMLC/z1c0PUOaIfSENlCk1HcKqiux2LezagwtAxICtncoAhBdbEcNBKB8QsaVffT4tDDEwokV0JJPhwvrhxuZjHzRS3nO/qZmOX4sMoPqcCwUQ341fgFE0xZl53h0Wo4HAP+5IyU6pSGggZsIgg2J1m+NODI5F73IEEGgf6CU/UL4tNrXo5d+K5n3JFE6+rYwOPJsoP2JhjPAMgwzW1NNYvLHe0C9xxj+Ey0bvjF/4HUpt28jYebedis8rRAkBXukD8yppv3NEMRRaPpgXIVx00lYywZIeUr6h44mfBHRwdfCYMsnJYar43ws0At5H9LdutAF9R/wXPqZ8z9gz9R5n73YIjHy7Cyk+5uJyILFpARNId0haZpNVjmvuYIUNPXvkkpawDo02TlLpjPKawMGvWb257+eSEmPX6E2JQAYpZLbM5OhS2TCVT7aE5Hh/cINE4hLHXAx+VWckcr7lExDyVs+2R5dKdhse9fxuPS1H84r4enuUq7nxg7+B9uwJCl6oLXxlr/7NowDZQPaNhYMlwDrMBaR4QB7FRVdOQ6eT/vREea5CO80hXLCliB66xZ0IbM75KL5BJgiD13y1IHu9SWF2H/zxreu/wchQjIZdDsT7+Fw5
 uTT9isEy
 16qZI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_split_region_at() should be called with the correct address to
split on.  Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 93d1577b1ae07..be2300cf3aeae 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2586,6 +2586,21 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 			threshold / 2 < max_thres);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_split_region_at(struct damon_region *r,
+		unsigned long sz_r)
+{
+	WARN_ONCE(sz_r == 0 || sz_r >= damon_sz_region(r),
+			"sz_r: %lu r: %lu-%lu (%lu)\n",
+			sz_r, r->ar.start, r->ar.end, damon_sz_region(r));
+}
+#else
+static void damon_verify_split_region_at(struct damon_region *r,
+		unsigned long sz_r)
+{
+}
+#endif
+
 /*
  * Split a region in two
  *
@@ -2597,6 +2612,7 @@ static void damon_split_region_at(struct damon_target *t,
 {
 	struct damon_region *new;
 
+	damon_verify_split_region_at(r, sz_r);
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
 	if (!new)
 		return;
-- 
2.47.3

