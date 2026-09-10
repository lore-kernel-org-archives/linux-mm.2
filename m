Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E803CC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB146B009D; Thu, 10 Sep 2026 13:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B406B009E; Thu, 10 Sep 2026 13:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2C36B009F; Thu, 10 Sep 2026 13:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C796B6B009D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:16:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E1151205B7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:44 +0000 (UTC)
X-FDA: 85198507128.28.3CEA5C8
Received: from mail-yx2-f9.google.com (mail-yx2-f9.google.com [74.125.224.137])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4950440004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cBFTvyiG;
	spf=pass (imf01.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.137 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789060602;
	b=oJlW24fggr3CTdSKcFyBkzAgZg4L/QY4TyR9HgbhkfpixCEs6KPtpwb775VrW3n1/bssGL
	dTuFAGxHFY2YqYCz7U49rVlrIOS+/z0jKColSgK9xCH/zDIFuP+Lz8eWQ2licSP5N9Ionv
	5zHXCSrY23MtY1Gi3kjby/5kZnINVqU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cBFTvyiG;
	spf=pass (imf01.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.137 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789060602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58wdEMpjvnsgClzUj13f3cAStl17GU2Ynr7IJ0GHfaE=;
	b=kyizHgyBt4+7G59QpflhNzH7uzzIjf/0mbfXfyYgeDGwJhgzxJnMaHj1n8h2lmqMHhG/T0
	r9QpAGllidtH7Nn9UXo9H0FKaCFOOxbWLQ8qHWqh+4pU62WZEFDelC8XVTttLzuLM0+v14
	7Q4jeHjKpNFhexkx4MJrb3Q75mlkPac=
Received: by mail-yx2-f9.google.com with SMTP id 00721157ae682-85b8fbb56ceso3164217b3.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789060601; x=1789665401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=58wdEMpjvnsgClzUj13f3cAStl17GU2Ynr7IJ0GHfaE=;
        b=cBFTvyiGeUf10x6AaMSTbCQLLlSkuNHx1EezMIWxzT8MwAQHTFtpQKLEfkjTtUwasF
         OV/j/tj+nq5UgxYV52SumtzjccMaMasPo0cYbye7PbS2fvV8Eyb6njX8Mrvj6IjTkWQz
         qMnZGwz8BtWgZ5veQCAuOsJIlE8ds3ppsW9OCtldvcUEFZRHaGMBxu4+RMTAiNpNKqu9
         P2I+ICsXtA+B6iTVwXaxBdj1YtpnFs7KAZ2+bpGvkhWU86+qxRUFxG2j95n3/m0NTlP3
         GhXEct8LJDgY6GJX7Fh/BvZkPk1j/V6bfwXmtUz1EHGYuLZbKKqN8DrvlmHnRb9cep57
         R8qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789060601; x=1789665401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=58wdEMpjvnsgClzUj13f3cAStl17GU2Ynr7IJ0GHfaE=;
        b=lHNfcjJUiUOIip1v74rJYcYQUS1meV/EpHuKfEMpTMY0EcFj2l6pI6nFIYRpTGyHrs
         oVq2oEEZN8BBp94Wwmf4IsySW9vCXGEklxgrrUSxj7FmhQxP0FlGB8GD9jIVtwL1vTe7
         p2XRHvHGeSnTGqibcNEA3Co7jegKs79PzYFdgOki7dVR2cjm37rzMsP4HnQOLqWpQ7wj
         SbtkhPpoSRwh9PBjAcYKMwNqNnObv8s4XPsx+oEAfC+w/4rk5O+AaOdCA84FF29ebYNP
         SpiDYq6miozp2VeTaFFtwWhBuJE5paVJ2Bm4UHht++M0XT8HjiDHJJr+21XonRJ8DqDD
         fOuw==
X-Forwarded-Encrypted: i=1; AKwUvBycQcM9okhtLz9Q0f3hUYAGMXBuYK3jBJGs9xS40pOdOncAwxe8aO4rf8o8aPqYPm3QLOBFWTipQQ==@kvack.org
X-Gm-Message-State: AFuF++k9M6+5tNon8VCeVp3X+D/dW6iWxhUjFhK0XOvW5hXipGBdrLE9
	5DWr4NxB6Pg0PvkFjRlwExWxw6GtU45sKKe0IiVvTgWDwVIfu2zQmC8=
X-Gm-Gg: AYBFou0egPuSAJV3FbRR74QGnJjiaaylHPoUNper6BDlbwqI4/PEso0PP5OMxJU1JEl
	JiYVrY+VI2yvegI3tgPAdXlAknat/ZeAMprOpgRF/dINiDWmitTOHMUYqD7TgW876XIo6zJRoqn
	74lDsYWu5teL41OfRyX9uJPDnJMK4ziOr3/4dAmKRo9LJfFcAY4JSn17fCS1E8reNGSpuXcGRuG
	Q2mZ2wu1zhFrdqmAW/SJ9bdHk4tyJsJ1D8/lnbR++31ZcAfixh/Z6i7hGwcq5uyi1rxcSZxfX/v
	0QeHzxhWs67T9zA8Vgl6XBwPDFW3v5GrmpfSdM0sWRUolB5hLgs1BbXPHuAfTrXkcKd3Gv6rtU8
	sxhkhEF/uW/vaYSxAy+tWmTVabnYZo+n20fJrcqcgMIlO9u30KygxtZVSE3tAy1Vl4ePsnl8aDn
	0enMKEJYcj/Q1larK8+uSno9WT0iEW0VXRXDeOQ5y5NQkqUnzxkD5+qk3lWgP1j0NpP4afnLLJV
	PCLRR4dvG0UD+Fl/myJSPlpTUZPxtrR1ssIXk8k4YgmAsffOA==
X-Received: by 2002:a05:690c:c505:b0:873:5c6b:a31e with SMTP id 00721157ae682-884a1163a16mr1213737b3.24.1789060601165;
        Thu, 10 Sep 2026 10:16:41 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-88487ea6026sm2285967b3.32.2026.09.10.10.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 10:16:40 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net
Subject: [RFC PATCH v2 7/9] mm/damon/ops-common: use probe-weighted score when probe weights are set
Date: Thu, 10 Sep 2026 10:16:21 -0700
Message-ID: <20260910171623.6638-8-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910171623.6638-1-ravis.opensrc@gmail.com>
References: <20260910171623.6638-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4950440004
X-Rspam-User: 
X-Stat-Signature: n5c7ytdjxjz3p6cygc3i39hfmb3ustkq
X-HE-Tag: 1789060602-609613
X-HE-Meta: U2FsdGVkX191KAThUkdOI5DJgFiT1SxsPO8Cne2tdke69I/exRoun6J1ue7LDUVKNi5cCqTB+4xFEGFcr10yawUIoq0QIuZZIQ0gldxuGw+9ac/Ly4lpae28bRugQe01/7lhstgMQfgNCFt07kyn6g6OgFPQDo2i0/S88hKUcmMOTVbAKvESe5bx/+1i1tbIcdodIJOQeaxzvYyOTEmkOo3vv94VxuWTgCpiUn0auyxye3uSdNELKoWIDEl8Z1X4Dzgb2VDqjdNMi1DtxuU9Kiun03y1wz8afKzqfvDvCZ/VU1dWAAhPsUKJ1Ri5rqQqR28PTy8eKgFOl6IJwt86/UI+Mstdk8EbJ95JqzwqUguvEbSUZIz5rnHeQvmf8dX28yr4V7p2wo8TkExPkGux1n3c88eynSXU/4+9wDcKBqRhLLll3rLFw+jS0/XtN8QBCx55WPe26lHEU5yHDOoI3ZK3TCSIDUQ3vDAry0kQPEciGVhNKiMsuwM7Sl+Fw6p1HB2g1Rfy10xvr4symk85KM++zhq/VelAPnRF7bSu0vGmU+1ktrwjM8hhihULsylxP2IjEmRJFtzXiAlnqOL1fcRkQ3LP0I5DIcSF6JOqgoE6Q4stvDPen1NBIQzaQAKQJrSMbBRru1b41nGz6vd09NTGjZBCPLfKksu/67l5Kw1zy4eP9YY/swhUg2aiT1vO4pxtTidWZYEzOeGajsporll64udrq+jmVw6H7xKzyp0Uz0cLpetKOcisMYwX78a68XM42dCzQb/F5S3xXHwOpbe4uxDwzpv0uJORZv0PHIV6Pwun0Xb9XVp4BVz1pesdSJAFkeqFyhQh4X184d0JVQXFnxfPbVDFQzybs98rd/cpvtRJUrc1fDGJ/UbjPIf9iKEehQEQHCkYmWm8MSCWnR2+xI8snec/1Qd9XSXGZ52m0SutJ8AKPRzQ/r3v67p2+ts68Smo/uMrn4AVgtO
 RO67Hq2f
 7dxtP4UCZpj3E8NyVRG3D+gJoF5jlUDQ5oSkuzlySolHdYj3VlyA/qXcWlchEe8hju7Iyu5SuVGx7RySp7AH5AiUDBiIcl5ZTSN3k3VJsOQU4ZbT67XcCj9hKKCnuWRTl9NgUoIyOOobuMHhF7GnI3sxSgOpx9ILcZ29NhIfxyTL3+hbvoeqJEP59QP6N0WRZ4vsYlhgcSx4czDQZlolg66mrHtCPHQN2yP+apoR23+3lt4ClfA+N01YQtgHODx99V1RFZnRN1HV2eyadKnPUqwJi+0E+uhDOLkgWgSIvtN4Axx3GF4cWeaxvsLfxd87f7aSJ94O413Vx+ehusxi9VDkPf04b8HpeBZYdYK53l70pxtcJQaTWCEIP+ybqYDegSFxfEeOI/B+5uk8QcLzOE0MNbxLUK4aJllLRmeMg++hZHZ7f7r7HfN4bFVFlKamvWgT+uQjF2OH2WcmDYT8GN7aVlnmxdD9vP+pB/Z59ZRQZYBjxDtvyNKFggqgq1k4DqZ0QDrziBHHTXO74cdHZw/DYpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are configured (damon_has_probe_weights()), use
damon_probe_hits_wsum() for the frequency subscore in damon_hot_score()
instead of damon_nr_accesses_mvsum().  This routes hardware event counts
from a perf-event probe into the tiering decision.

When no probe weights are set the frequency subscore comes from
nr_accesses_mvsum, so page-table-only monitoring scores from the
page-table access rate.

Export damon_has_probe_weights() so ops-common.c can call it without a
static dependency on core.c internals.

Guard against integer overflow: clamp the probe-weighted subscore to
DAMON_MAX_SUBSCORE via min_t after the mult_frac scaling so a large
weighted-hit sum cannot overflow the subscore range.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       |  2 +-
 mm/damon/ops-common.c | 21 ++++++++++++++++++---
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 88a459a60b296..3147ce30951f5 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1307,6 +1307,7 @@ unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
 unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx);
+bool damon_has_probe_weights(struct damon_ctx *c);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 850880f791c9e..6b3aa86386b76 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -391,7 +391,7 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
 	return NULL;
 }
 
-static bool damon_has_probe_weights(struct damon_ctx *c)
+bool damon_has_probe_weights(struct damon_ctx *c)
 {
 	struct damon_probe *p;
 
diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index c36cc39cd2c70..3033a5c0ba690 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -170,9 +170,24 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	unsigned int age_weight = s->quota.weight_age;
 	int hotness;
 
-	freq_subscore = mult_frac(damon_nr_accesses_mvsum(r, c),
-			DAMON_MAX_SUBSCORE,
-			damon_nr_samples_per_aggr(&c->attrs));
+	if (damon_has_probe_weights(c)) {
+		unsigned int wsum = damon_probe_hits_wsum(r, false, true, c);
+
+		/*
+		 * Route perf-event hardware event counts into the score.
+		 * Clamp to DAMON_MAX_SUBSCORE so a large weighted-hit sum
+		 * cannot overflow the subscore range.
+		 */
+		freq_subscore = min_t(int,
+				mult_frac(wsum, DAMON_MAX_SUBSCORE,
+					/* +1 guards divide-by-zero: samples-per-aggr can be 0 */
+					damon_nr_samples_per_aggr(&c->attrs) + 1),
+				DAMON_MAX_SUBSCORE);
+	} else {
+		freq_subscore = mult_frac(damon_nr_accesses_mvsum(r, c),
+				DAMON_MAX_SUBSCORE,
+				damon_nr_samples_per_aggr(&c->attrs));
+	}
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	if (age_in_sec)
-- 
2.43.0


