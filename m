Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B89FFC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA1E6B00E9; Mon,  6 Jul 2026 10:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73BB6B00EA; Mon,  6 Jul 2026 10:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914FB6B00EC; Mon,  6 Jul 2026 10:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62BFC6B00E9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F52E1C2B61
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:26 +0000 (UTC)
X-FDA: 84958559532.02.A38FB45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E6AE2C000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=moIFmpYd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347564;
	b=vbJ0vHpyb8Shek7ORebxyk0zst4isWnZBtL1YvR5BXI03Tt5N/WPH7ENvRkXLVONo/B8qu
	2hDfc9d3MHNAloN3Do9+aK05cFX+++UfR1ra1bGDbPvwCmREEmoqcjtbyitkh5/AvTcu0d
	fK+3wxKNEoEoO5taJGU3Xpg1JjscM5w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=moIFmpYd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QnL6i0mbNzGqk7F6gIjbd/KMt9GZkHBDgTWFw34qqes=;
	b=xWctLPvtCdmlROPuzNUOkVWPZL51AfW74m+MnRfZFPZXtNxBEaIxCpghrKCUm3RqzkMls/
	rPVDeL7CKGOxvSkZPgOEVT/i9sj/Wo2vaQXhEe6/MCEL6Qc16p84KTZd2hLqHrA9VALhrH
	Afz8/PLjPRGF/sTms/Ad9UaVF51/itI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 821DA6138B;
	Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1359C1F00A3A;
	Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347564;
	bh=QnL6i0mbNzGqk7F6gIjbd/KMt9GZkHBDgTWFw34qqes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=moIFmpYdQxfGaHn7OLF+odDWAil4cqjkGlolP/WaQfkDAAFeUu1vic/Pr+zQ7SiMb
	 e+Tb4J5t3+lzG6F3Y4QA16qqQbWvTjGbUklFGo6Ms/wg982uJkSjo8Knu7yK3f8v05
	 uhjriyuzLPE80k5n+di14XMWJy3n69BY0WeoxmZSyCx6yXtrBaaEleh13QQ8Czc1yC
	 ml6FzkJzAuKo81R9volwUck1ODMOOOpgRHzSMD8CPl1+sAkAfMuHk0tzO67kIr5XRR
	 aEyyFxLFahmfvfcborl4yuEs6uPHxlofgUFNrd728kuKroWKbeP4qWZgwWsF4oaQOw
	 Pmrel2utWF4Gw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 12/16] mm/damon/core: implement damon_has_probe_weight()
Date: Mon,  6 Jul 2026 07:19:06 -0700
Message-ID: <20260706141912.88445-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E6AE2C000D
X-Rspam-User: 
X-Stat-Signature: pj1xwf89j1cjop7o6ia4xwdrq8e6j59c
X-Rspamd-Server: rspam03
X-HE-Tag: 1783347564-285723
X-HE-Meta: U2FsdGVkX1/NcxQoIPd7BtLu39mEa98rOOm+K4FcRkLpbdlJcQYKNKUWyXpBibZDdfYzORdArxUzl6OWuDjo2J3f4jwwm7JXIGViyTrIAh7Jixx8eXD7Birndv1wesV/tuxr+viEX+C8TINat8pSJKi0yTaWIii8zI9W2gBFnyuBPRtjJLyv6Bw0qp6vwnuW/BgN15inUia2QFVLKm/G81pmu9ycT9Xw0Cfrga24lZ1fBQxJerhK0Vz86L6EIMCFJFJnd9njQwmH4bYBlpz9qVHqJBT0kfawi15FxlH1LjjRxd9w+oJ6GOPly3tgXDiIGoGCKK+qmMlSRA46PG+pDBjw8s4YTwlCms4JnTVCCLXQouKYDcZFY60Z75EPtfUew2jPWhzfwQ8nf4ZbrrpeUHHMxbz5Dc7Xh5egar4ilkYrXtFaW8SOxoIk5TK3HmiMKtWxUEV2dDLCRRAJMfxQLzIWz9nv72LDl7jQIjo/T7Gw56oUCBPTZfOLUhTdtwFvk6zWcJLK1N1o6JycVKq1RMgE6bqyltuEsjYjIr8ERXZ5lMChayLo+oTIIGapFIoaSmoj4dQowRdTVXihLEg7ah09VIHMe9A/YvS+hv29U+RiopJRIRAXUCmfelJkmyRHcxW9r50j5WuX0uh5YCcw2ZscQgSDXLAeNDzHCllh2dXRBcLLKMdntet4MUmSlBil/wVwm+B58AmVykyK4twXCesB32YMbooIbBCO7hmEW9+b6j1e3vyfoU6xS44yUCybXjBtUuYAV3fB/I7zLrlk/VetFlIXhy98Aux+pMqhZzHtiP3Q0v2F7qXqunraMhBqRclqrjHk9r7NN/CjhAoyHMsAlwWVelalwAS+YjM/BLx2ExO2x2S5EH9bT127AEG8PwaneG6dLtdmVwo1pwvvntDkhuE970pqaGnMIUwW6SfLrpCNf1ko0vTIi08pHfnDFVMepO+rQ7aGadwCGoc
 tgrOXAzh
 SdTucX1DsbABALsMb3GIjk7epmmRQcVGB8SGJzkTzRxWMmfUbDOwxsKZ6n2XNTKvLKmyYJe4eQPaJbmQL/WnNxmx5quUMPBrCUvlvgPBou9bf/1ZGtqDnYYwbd9qrrY7jTAa3rJ5kIMgbsFsc+V9XueHKa4om+r7w50JvXwbhhC8PwhmyOLsggiJ08Wd6h1nr2plMZIkYtbKxuPP1Am6z2TcSZL8l+2JmGtkYiYxlasIkwFxqPgJ3V2Td+wVYCKdU7c49ED8tM0MjgqTiHFUIAaTz8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON monitors only data attributes when probe weights are set.
However, the function for detecting it is intentionally returning false
always.  The intention was to make changes for complete support of the
mode in a safe and incremental way.  Now all the building blocks are
made.  Complete the mode detection function so that the mode can really
start working.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 83db073c74e2b..b44393ccaf6b1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -211,6 +211,12 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
 
 static bool damon_has_probe_weights(struct damon_ctx *c)
 {
+	struct damon_probe *p;
+
+	damon_for_each_probe(p, c) {
+		if (p->weight)
+			return true;
+	}
 	return false;
 }
 
-- 
2.47.3

