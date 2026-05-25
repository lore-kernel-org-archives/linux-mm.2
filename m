Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17F3ECD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30B46B008A; Mon, 25 May 2026 15:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1C3E6B008C; Mon, 25 May 2026 15:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932CC6B0093; Mon, 25 May 2026 15:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 845696B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:05:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48AEE1201C4
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:04 +0000 (UTC)
X-FDA: 84806869728.17.34C92DC
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6E96C1C0008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dBNswrP7;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779735902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ieNLELksxQ12VWfSTE2wcDumq9qPO5WfoZYKitlIUko=;
	b=qBkdvdqdxDfchHyyabS4qBlX2Jd1AMggB9oW0bPcsFQREfOhCbGsUQCC2oN4U5nJjs9j7h
	+HAJY1tsvzx2jjIuv9tgW3HzM7uHRswgsqhTQZ1w9XTi6XtxRbl/HwN5wDnnVjwvGx2r3b
	VT2LyY5q2eDVhmJeS08I7bQeEOX5iQA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dBNswrP7;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779735902; a=rsa-sha256;
	cv=none;
	b=Gca4R4W8KBNbqb+si0dIv/Wmz5YcA/dHGi4r0w1f1S4AWGlKN+B7V4pTOLg6fGQrlWvZgu
	lphIoPTQVybJ5zRHX5QAp74nfv4Kgz5QxJwL4BghI3yhVKp7waL0Bla+nsLc/rHwnP4SzJ
	JXHvDYXBJQFKS4lfWyrh6Fk/O3xTjyI=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7e634c4b74dso1186915a34.1
        for <linux-mm@kvack.org>; Mon, 25 May 2026 12:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779735901; x=1780340701; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ieNLELksxQ12VWfSTE2wcDumq9qPO5WfoZYKitlIUko=;
        b=dBNswrP7gwPRl1lyf7a+ywv8IbAxK+09XLEcyHESVvqA8NH3Gcs9EEaYnf7mzs2GMH
         4G9FVxnCcBhBh5+l3m+QT1lOVR5qXTQLmLipZAZ6H7kIQdCMvN6GDxAIWipetYhx0+Nf
         XX5n8C5OcyqZsiYhCPrW1eKCUJe93Y3UjhqjpcQRRJ3fuIzxeslCNRWiBxu2x9+X8uUm
         LBKsm7yf2OrG36LDfACqanfSNjcnjWT+KRli1sJjmqqs2RV4OpXqcPgqwT4XrvJu6Yik
         Abu1EWLiCUsd+MO22ZNDrpK9tKx13lOofjHuyO39iiki6IUViWPRbZ911T9wM3NF5o3t
         UuEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779735901; x=1780340701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ieNLELksxQ12VWfSTE2wcDumq9qPO5WfoZYKitlIUko=;
        b=Mc69+HtuyOHLgN5LMpqJy3/nndl3GonmWE7Qe8DNIbSVnm3PDrTN69RNoMSel7aH63
         p9b5dSCKbGn0CIXzogQwQElCjTuuduJIVPZpoXxulixffnsz2Fe8cafUaV3TNxlrISl6
         1UDXsoybuhqK0VO17484mQlLU988KIPNTVwPz62ddWj6snrQhGwPQ7+ipVJA2NHK4+6m
         VOZj3LELOr1gjT0gVOAPIVYbR9E+kKumhMwXcukKXv+g3tY7vTkRx2ekpDgIzz5ZbLFh
         ZvYQaQFkue+HwMKdb37fHRBe9dR5KlDFDXfPxp6qSYlvSHmuDtG/W+2bE+Ht4QOE93qw
         5T9w==
X-Forwarded-Encrypted: i=1; AFNElJ/P0BFgxCclx3lZ4e2oRM01lHFxlCw2mWoH33Y7axZ77TqGLrnrmVUHJAuVBth3P/BSyd7hQFXk4g==@kvack.org
X-Gm-Message-State: AOJu0YzorvUFksl9awsak9MCEE/vfOz3GzT8douypvUI/jGrN+OhcpZ4
	cmszWtaMfhxt7yBwK5OWYOpvPOTSTn53PoVhpPjFUEjCYI/YFk/NNxu1
X-Gm-Gg: Acq92OFAXL6j+exxYM1rpcrFS9vKK2pp8FGbR2y7qU4XBFl0tvSmjFgvKf4CXoFA3Sj
	074I0g+SlHLhKlMEIb2JBEzxNHvzOB9mz3zKGkGomiqSdaRUI11kKXPvN0CHz2tMb6SVaeTw+r0
	52v4g0nrq5lbzSRGlkO7EpjDiY1XBgMFWv3hUOggddmA4lXDo++qeN7Y7Vr8DWGjL9TUKapwo1q
	hmvHzGzIuliexrYBiMxXG5yanMDvO9d4MZcTsOECZMsq9XriRAlN2ok9hOkNiv5s8Rk/pqPy+0k
	u6/zrYlB7qwba8f8AgyFRc287htO+Pz1WKdrbc5ZxDE2D7QuGxUAPnvG+aFTnY3tdYsP8vjOZpl
	+IjStc8PBy1NGZdkp0zW1W1i2JPjVfTjV+xaDMjP6bLs0d2keMfaHi7s1+mTMrCQXDnl2tRMvER
	TKirFuGR3kXaoqO71Iir8AwJldl9HJabdw2n1oxJdiPX1aXBKNnP7DPg==
X-Received: by 2002:a05:6830:6a91:b0:7d7:d510:4bf9 with SMTP id 46e09a7af769-7e5fedd5083mr9959038a34.12.1779735901451;
        Mon, 25 May 2026 12:05:01 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:50::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6065e7cb6sm7850039a34.16.2026.05.25.12.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 12:05:01 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/7 v3] mm/page_counter: use page_counter_stock in page_counter_try_charge
Date: Mon, 25 May 2026 12:04:49 -0700
Message-ID: <20260525190455.2843786-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
References: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6E96C1C0008
X-Stat-Signature: 7q18hz9cpwei345oxcqe4x4udr4r1i5q
X-HE-Tag: 1779735902-354387
X-HE-Meta: U2FsdGVkX1+oimsGnr0rd84zyHlTm17/h5M+ORTCw4OZ42bw4TU7+oZ8xyoLtJGsUoy86x7wz8QUelphYKc5w1mYa6Y4m+K75ZHuEoWuqC2dleAfjc5N/YPg3MnxdCsZl+ohOGlcxUilwif1MSz22l3QdjEVYJbIwUWCM9KkoR47Rzmc/B6xrnr9x0WrnrmpKdbGs6Zo4h5ugB1eP/vKPrxO35JDX/wZM5RflHcagPKGsL6GPLmZkEEqt28QFKIjSOc2SWvuHSebl6Ug8vp4ERre1zGP+FYQYf0MCvLJB1MfWeXs9Ih+jgx77y9Juqc93+dbl2E9mhESjzvVmR/iw/l0iI1wfz3YhbLQZAXfuVQpiIAZUKWNAFmN5Oj6euapwEQszmemqdZCSaqgOW9LP80uhkclQ3T3MhIRZe2wahIJoa2cq0MAaSeSXgkGVPSCzy+/iuRFthGRpbpwHvUoM26iias5OSWIc1qSApZHI984T40a/sbH99la31CSIL8ZzPeTPrRC/J9Cj8BfASs7sOLVeRWIrDfZlxn9aJ1gTwIRKbBOPTxULdIt1WN1gqICOYb4eOksI2spOdHay7CeOjsqQjN2mvfybzFCWL0uZIId0w0SJ+rwYbtBOq3dk4JIOepNubpB3vAXbyR7fkSezv4gerXn5Be0LPq80fVZBgRNxyEqQ2V2yKmB0BZvSurKs5o0ta5TrnJC0mP9FQEV+dAr7WF38TY81DgspSsU1N2lq+tfpcKmRGAJ3e5XlUTuehnSBb4BKkluT9fQlZD0SFbXrBdhQqr2dG1fNvvPRwMfVzw9EutrAhYIvUe+eO2QTqkcVXA0lBv+DHR+V6Ln+uB5jVfMiq4cx/1MuD55xDnJQlNU5RCXRJsgNvs+teIz5yOQUmmFJIE/IYj337Jb7uH2DVD8xaZwx8kbvnZmbLcSPq/MRsDkWS1NF9Q1AiIDMrg5/acx8/ZskzMDLZm
 G9WTzXrc
 fkXthyD9uqW4uMDo7kDPt9bXOAAieuA44K7jbhqELR3Udti6BV2nRTRH5kVu9AYWD0Eyb3Em8i9WZ4cHJmdHhJxrxs8Y4mjxSEeg3JwYrGG4pW0MmvH6Nm76fGeBlDkDwduLpTlAl9jWgRD3WjsK53XpYiOq6UCJRq+CxRRfH/vKUm5LLFUiKcffuqnJ17LRaFwSxxEUrmJua+IEiX8/BOm2LpPYS9H+d4RWaeiHWw75C4r3ZaAAufxVG94DQGR341CnmVsSUVRg/XRdIg3oQ+JpcF8AcOcEzcGk5+6l53RYrjHpCh2kI0oTj479hQUjXcRyq3XriUeovonM+I2q+TI+5r9CC61Rg8ghl0A94X8JQ6zeEtj2jJ5+GcS8jyI9l3iJEB/A7tn6ORDuCvJW4VJjDDaEsZrnkttj3WNgbOBoeT1mMc+m3dE21+5XEXJN3zyc3y8YGjjIy4BzZce9pEVrCZs1K+9cBfmV/mZSa+h/sZ1p/mp+xTIYmSWnv2iT8cL34W2JXnlaSPCJCw3djH4dJ+ZwR4ZAN71DR0IR1V16a4aIm/W7bRlnbJdbtVnXdqmsgtL4jFG/j8tePFk3GuXEbZZL3VZxqo4aa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make page_counter_try_charge() stock-aware. We preserve the same
semantics as the existing stock handling logic in try_charge_memcg:

1. Limit-check against the stock. If there is enough, charge to the
   stock (non-hierarchical) and return immediately.
2. Greedily attempt to fulfill the charge request and fill the stock up
   at the same time via a hierarchical charge.
3. If we fail with this charge, retry again (once) with the exact number
   of pages requested.
4. If we succeed with the greedy attempt, then try to add those extra
   pages to the stock. If that fails (trylock), then uncharge those
   surplus pages hierarchically.

As of this patch, the page_counter_stock is unused, as it has not been
enabled on any memcg yet. No functional changes intended.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_counter.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index a1a871a9d5c49..e002688bf7f1a 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -121,9 +121,25 @@ bool page_counter_try_charge(struct page_counter *counter,
 			     struct page_counter **fail)
 {
 	struct page_counter *c;
+	unsigned long charge = nr_pages;
+	unsigned long batch = READ_ONCE(counter->batch);
 	bool protection = track_protection(counter);
 	bool track_failcnt = counter->track_failcnt;
 
+	if (counter->stock && local_trylock(&counter->stock->lock)) {
+		struct page_counter_stock *stock = this_cpu_ptr(counter->stock);
+
+		if (stock->nr_pages >= charge) {
+			stock->nr_pages -= charge;
+			local_unlock(&counter->stock->lock);
+			return true;
+		}
+		local_unlock(&counter->stock->lock);
+	}
+
+	charge = max_t(unsigned long, batch, nr_pages);
+
+retry:
 	for (c = counter; c; c = c->parent) {
 		long new;
 		/*
@@ -140,9 +156,9 @@ bool page_counter_try_charge(struct page_counter *counter,
 		 * we either see the new limit or the setter sees the
 		 * counter has changed and retries.
 		 */
-		new = atomic_long_add_return(nr_pages, &c->usage);
+		new = atomic_long_add_return(charge, &c->usage);
 		if (new > c->max) {
-			atomic_long_sub(nr_pages, &c->usage);
+			atomic_long_sub(charge, &c->usage);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt which is only used
@@ -163,11 +179,31 @@ bool page_counter_try_charge(struct page_counter *counter,
 				WRITE_ONCE(c->watermark, new);
 		}
 	}
+
+	/* charge > nr_pages implies this page_counter has stock enabled */
+	if (charge > nr_pages) {
+		if (local_trylock(&counter->stock->lock)) {
+			struct page_counter_stock *stock;
+
+			stock = this_cpu_ptr(counter->stock);
+			stock->nr_pages += charge - nr_pages;
+			local_unlock(&counter->stock->lock);
+		} else {
+			page_counter_uncharge(counter, charge - nr_pages);
+		}
+	}
+
 	return true;
 
 failed:
 	for (c = counter; c != *fail; c = c->parent)
-		page_counter_cancel(c, nr_pages);
+		page_counter_cancel(c, charge);
+
+	if (charge > nr_pages) {
+		/* Retry without trying to grab extra pages to refill stock */
+		charge = nr_pages;
+		goto retry;
+	}
 
 	return false;
 }
-- 
2.53.0-Meta


