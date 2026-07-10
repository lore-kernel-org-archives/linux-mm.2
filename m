Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06825C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363FC6B009D; Thu,  9 Jul 2026 20:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341196B009E; Thu,  9 Jul 2026 20:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2019F6B009E; Thu,  9 Jul 2026 20:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E017A6B009E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 570E0120320
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:04 +0000 (UTC)
X-FDA: 84970969608.07.67EE546
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BE2121C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kKOBvkbG;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MmLe9bOPXvyR7OHttIBw8WieSr9mwuKyL25YGhL6QA=;
	b=gjbGHWCHjqBmQB7jlbkllyVvIa1+x5SDqvL2TtzFtMDJJwNBnsTZlGIPUSZG+/xagbZIDk
	eAzytS7AfCScAoXc6+mdxNdyyZl5I9We14/63WtIcBKT2xS+VEwfpRxK5iLk8mFqRTNMkJ
	sq8KSrtQusbufW3WUTHZfXdyit1a2pM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643042;
	b=uc+TQ+X++XT+TbE1bkOKPo5X6sUOru8R9ro+8aYLjrG9AcqcXIi8eL72e9RTKw5nwlYccc
	rfD5rCLjUaNPQ6vqMt5A7+zfqUrpMJu/l1RIxXFmJKlGcK0z5HPjHSgLwzYtoocHuDyJ7x
	gRBbGCBUThRL2BWwtngkDcZ4YD9aPPM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kKOBvkbG;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C89345105;
	Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE29C1F00ACA;
	Fri, 10 Jul 2026 00:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643042;
	bh=0MmLe9bOPXvyR7OHttIBw8WieSr9mwuKyL25YGhL6QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKOBvkbG22NmxC7UPOccxoriSL0VUQIQYkTewjDOrhdRIvTWyVVkjNK3GWDkK5XiL
	 VVImSLAOHgsrZMLpmjAMNyW7unBdfm+AIa8oF1bgc+rnx2q3Y6Do1WmLr+mflQ1+l+
	 mjBffm0sxtUEtnPupq19BD86BTtgmSkwGZh3wjLVKxEPPQJfTiuvrTh//xtqiYpD6x
	 jWrdd14B5pnyDHGilGrvswWe1ogwlBmY1YfjlAAJ2o0OmBLK5qljYGbEu0SfEqeJqq
	 zDJP5qIZpoB7jY7ZC5qegmO4lULqiVxoagAAVXFxgZKx0Na5Cy+meOLFemccAAWfdr
	 GyvsnzUmSQNxQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 10/19] mm/damon/core: validate params for probe hits weighted sum overflow
Date: Thu,  9 Jul 2026 17:23:36 -0700
Message-ID: <20260710002349.111414-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BE2121C0003
X-Stat-Signature: d13zowzo3ccyn5g7m8tfhqw3f8jmbm59
X-HE-Tag: 1783643042-788180
X-HE-Meta: U2FsdGVkX19uHhgK4Iurhd1Fc/3vQKQSI9wb9zA5xHNwfJr2X9ost8bR6eAD6IUAk2OL7Ezn2ALDrLK0QrTIopuzQOoszTaYaFTa/SjRuzLABwOAPYpufu05gNf7L1L4DlEt4xn+McYOayv6n8Y20L1gUzHX/A77ucq0IVCWGBDf1RH1mJjrCRdoMbZbmTFer8gVg4K0yxvEtjBo9zAE0RNRIWNx1q44U+mfWxpvMbR1B+N/B9ev+l3Iq0Ub5x3uVWxZV44Jzp1mZsGmRAUE+5Rc+j04cOaSaMQTa9pJe2YnW8FmfjMU12B2o4iBSHKllq+9NjFTTpc4DJeCDzBgd1pF37kQQJwQPFKWlVhths5q8xS8DExWPzSWQqGpikzAXGsZIaR0J0j2kANL7lZbqVhCT67jyINPQUpI1j+5KRIsNjkuuPTPtL5H+y+36e4gHa+5cZWxBfZjLuUn2xk5z64WUCQ+Oi6eF0bwKwG187vRdGChlHAX0VISylabRKoZfmzI93jqItb0g4ydDzamUmQIpVq1meZDsbGsBnu0zyUcyzWp0om3HYF8oKnJD+AYYUHRC4XbxZOuX2u9Vaq7i7Fe7HRS+aZIkLSfeDwIjAfOyqmzrOKmwOdQJEoFUpGsW+Y4YFf4/4DDsOcT2woTZHvdl2U5uzF6fsw4lCtZ4+n5D/0fzC0eJEaxxsywDfC6UQ+Vxcs8rplgDoiaJynxq9vHzZaeqFr4rGYVZX1Gzc2ekd55dh8Xygr5GJIspbYPSmWnP5mj7LHNrp4gy2wiWMwBFMCmuDtiewZHcGL8yRaMb7mdlGAfclwaAwh+3UfSTv5vcmhiuM8jfKnOeJIzYlw5ZKtScVdfBWwjqgDbiyj5RLGzUPFpCnfuQZz9T7uSaqLmF4eTwAJYpT5VpHtl+fmEYar1xgHayng0ByvsgMnhFu1wqWn8VAS/g7FXIEPcvGfIGtnIedEWQivUPLq
 jIDZiat2
 esHAqdnIGmWP4QvmKp0JXa+hIpvZVPtD/Tkh6WQpotAggswKSgNImoFps3FbWjesKWKpChHOidOCuncIYMypXvm1RmhF1ydnH4SkQIOAUXSXfM/dvmars5bgAWKvfQWMBlzvH5pCtXa2vNwsimT0EIYgbn1ouIsADClSEcUkg7gDrXSFoNeQx9qHoxm9AvB3uSKIjxDlEfQr1m2J9JVXFFb9FAzQ42BacPxXPpkJ97+G/wWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_probe_hits_wsum() could overflow in weird setups.  Users could set
the weight unreasonably high.  They could also set the aggregation
interval unreasonably high compared to the sampling interval.  Such user
setup is unlikely.  Even if such setup is used,
damon_has_probe_weights() always returns false, so the overflow cannot
happen.  The function may be completed in future, though.  Even if the
overflow happens, the consequence is degraded monitoring results for the
unreasonable setup. It is just a trivial user experience issue.

It is still better to be prevented unless the cost is expensive.  Avoid
the overflow by adding the parameter validation in the core layer
parameters validation function.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4f1425e56950b..a0e6a5129fbf3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1335,6 +1335,9 @@ static void damos_set_filters_default_reject(struct damos *s)
 static bool damon_valid_probe_params(struct damon_ctx *ctx)
 {
 	unsigned long sample_interval;
+	unsigned char max_probe_hits;
+	struct damon_probe *probe;
+	unsigned int wsum, wsum_to_add;
 
 	if (!damon_has_probe_weights(ctx))
 		return true;
@@ -1342,6 +1345,18 @@ static bool damon_valid_probe_params(struct damon_ctx *ctx)
 	sample_interval = ctx->attrs.sample_interval ? : 1;
 	if (ctx->attrs.aggr_interval / sample_interval > U8_MAX)
 		return false;
+
+	/* invalid if probe hits weighted sum can overflow */
+	max_probe_hits = damon_nr_samples_per_aggr(&ctx->attrs);
+	wsum = 0;
+	damon_for_each_probe(probe, ctx) {
+		if (probe->weight > UINT_MAX / max_probe_hits)
+			return false;
+		wsum_to_add = probe->weight * max_probe_hits;
+		if (UINT_MAX - wsum < wsum_to_add)
+			return false;
+		wsum += wsum_to_add;
+	}
 	return true;
 }
 
-- 
2.47.3

