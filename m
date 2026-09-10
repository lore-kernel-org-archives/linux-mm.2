Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59276C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 470166B00A1; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FCB46B00A2; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A6D6B00A4; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E33F46B00A2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:19:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53657804B5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:03 +0000 (UTC)
X-FDA: 85198059366.12.5C5DA09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id BD46240006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nyak9dtw;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//P9EELBAWJiTTEfH8OFzItA8Z77D6zhflq7gYb2N2k=;
	b=fKEITfh/GIKRrxIWnPXVu+JlivkLixkFxN5S/CBa3yivCvLdSgtcWMgTL7Syj5J3SM5lzl
	1ogoCEXbJLqlxz/m5ZQlqTafnNDVyZmfbvY7+4cowRVEY+3DbBimtt21BhFVWV5cPb5VAN
	1P5WtsQY50sjDj4M3zUml6ZVpdnYnKU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049941;
	b=1aTMk2gUENIkzXumo8e8yCPu2hmC3erAlqUWMaClONwytn5tvOl6sprbCyypH8dxfUptOT
	u3MSNOKUUszMWn4L5AvCujq+0MWfJVXMF680kFuNTWB7qaCxsX2qZz7pU+l6r2NR0Y3e8p
	c547cjp7OjCWe5B4/BCOXpK2BDLRcfQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nyak9dtw;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4108760204;
	Thu, 10 Sep 2026 14:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34221F00898;
	Thu, 10 Sep 2026 14:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049941;
	bh=//P9EELBAWJiTTEfH8OFzItA8Z77D6zhflq7gYb2N2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nyak9dtwBifrw34nlqILyA/okiRc91+DBtJ39xCKbVV14Yiq1/h0WzuiJ/iF9rc7Z
	 mBV9wMUXZtC2N5cwd7avFdF9dFnaF9fSWuT6gGDGu1dTNP063p/i59JMEcJpQ++sKZ
	 ML4tOd79iQ8xe2jM1UWbXBHNQohMBsCjS3bBKOXj7WGmNDFfvyRbKQWTJIWADOWOfW
	 /zdXWQiZ6xhXwJznqX0nrp/pTs+x76fKp0vkfsu5lKyhcYYgvm0ocS5OSRey6yUb2H
	 OdBeoSeqQoYEQSRGIxV0NHDIOOhSx/BPN+SXwo2FfbYghBZp3MbH3RZQVup37QmB3L
	 sGgYqXx+6MRJw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/7] mm/damon/core: extend probe_hits_wsum() for moving sum based calculation
Date: Thu, 10 Sep 2026 07:18:42 -0700
Message-ID: <20260910141849.170896-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910141849.170896-1-sj@kernel.org>
References: <20260910141849.170896-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD46240006
X-Stat-Signature: ykmh3sykkdxwsu5jxsc6y6433pkxqgfj
X-Rspam-User: 
X-HE-Tag: 1789049941-624504
X-HE-Meta: U2FsdGVkX18HD+7fqtkISTzaqBNMBkRgzCzYu7a2CgjjzXlIMDqfm9N3VXrIzC94Hwt5SqAAZ9gsgRc6ngW6Dd4did+w1w+VFiRnS/I1rypgf6zQJgSEz4S9A97TDrkryxcs6QU75tDlsJgr0JABsOAlzrLXbxcfbQ5eyXlJ23mazjmrQwDMpWqnKHjSaI7ytPLxyT3h/WgS+78L2XlXKUBFgj/fBmaI+Lbdx6Fj+f/2HzhcUjyLTg1RVwPQMaW3ERZkwnBjvzr+R7UVj84W6iF2GzCnkTYVK8aw7sYlS4tG3w6WcceaSTPTCwwolCXg90ZNbfFi7VpfJ9DkJNUYRHRLVYZywe7ZDjxH0V8FDMS/h54LuxLgMPL4pARG5j5WD8obb+M4J0HQRTxfEuFHwOSE+JgQdJALAWto1wZuqvlf2/x0UvuS9JkmRTSVCmfM6sG3YypMzshTDX8z8CgMYY9qt/NmeuUBYIEjNmYUIhW2KIc6rNIrd3HniYz+kFJ9cvRqydfIsLtMnGu8R9NAjJQU/WDhIlZkI+mfCI9ECVIY7v5DWZVodwwCk9f4lfAqBveQXjkIdwco9ecf7ISs6XsJUEVU7StsSl5GLn10rISmGm5Eh3klgg8x5IDKf6DVb4L7Ri7ZxG+BsrzVwf/5Sx9XZw6GiOU4nWVVOP+SZ+8xtRy4JyGsw8Uo8lx8XS9K3aFen1gmL6+SwTzJ2UBaqbCajzNpdXF0CWwCA4xDpOZlYpW4swcKnj+/833HEI1aLgA5gc0oMJA+ZD4d2PTfi5sELmk+cSeMKYexwWkGCLEUj0ntLAsY8dfI2dce5HBlT9WdQXqnu7Fy3XpHYLdH0+LUVtzLhcvYHKhQ5/vJ9K5Vjpago9QKrrnVClOCE0IYGggdAoNLKeYjUn8mIhpFCU3LH4Hhka+LwpWam8ynPJSbzvVZ0o1hn4OKW7Apmjfh0drt13Cw+sBzdCCpazJ
 1DY40qE1
 yR95nuhcjIZ/T3JcrYawm+wJ0DQkpfzeeVxCTnQMdWyk5KZRMT60HF9lUtRfJClkCXZppuxxGmtEj+BXQblop8+AlOJ7Km1jRiD6TfbnvQAet8b91qV4TVonIMIBm7Iq0YEMOGejPOtZrX4WXuB7YKbGjTqqiIy+W4RFwQRbBto6XarDyUnBFi3qY2JxkMMHyIhkDKrxdBGEIj12c3/3CU+PnuB/dQ98jh/oYppIKzwA2gyiaGOwnsFKDp6ERlD3OnKg6UX2ZsZ5ZcWF85cWkhuNhFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_probe_hits_wsum() is being called only in aggregation time.  In
future, it could also be used by DAMOS.  In this case, since DAMOS uses
its own apply_interval, it could be called in sampling time.  Then using
the not yet fully aggregated probe_hits could result in suboptimum
outcomes.  Extend damon_probe_hits_wsum() to get the weighted sum based
on moving sum to prepare the DAMOS usage.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 +-
 mm/damon/core.c       | 8 ++++++--
 mm/damon/paddr.c      | 2 +-
 mm/damon/vaddr.c      | 2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index ef99ff778ae10..4a36f344bbc7c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1073,7 +1073,7 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 		struct damon_ctx *ctx);
 unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
-unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 645cb367019ae..e9630f41e51fe 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -469,11 +469,12 @@ static bool damon_is_last_region(struct damon_region *r,
  * damon_probe_hits_wsum() - Returns probe hits weighted sum of a region.
  * @r:		region to get the weighted sum of.
  * @last:	if the request is for last-window aggregated probe hits.
+ * @mv:		use moving sum.
  * @ctx:	context of &r.
  *
  * Return: the weighted sum of probe hits of the region.
  */
-unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx)
 {
 	struct damon_probe *probe;
@@ -483,6 +484,9 @@ unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
 	damon_for_each_probe(probe, ctx) {
 		if (last)
 			sum += r->last_probe_hits[i++] * probe->weight;
+		else if (mv)
+			sum += damon_probe_hits_mvsum(i++, r, ctx) *
+				probe->weight;
 		else
 			sum += r->probe_hits[i++] * probe->weight;
 	}
@@ -3449,7 +3453,7 @@ static unsigned int damon_merge_score(struct damon_region *r, bool last,
 		struct damon_ctx *ctx, bool use_probe_hits)
 {
 	if (use_probe_hits)
-		return damon_probe_hits_wsum(r, last, ctx);
+		return damon_probe_hits_wsum(r, last, false, ctx);
 	if (last)
 		return r->last_nr_accesses;
 	return r->nr_accesses;
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index d7c81829445ba..b8f4d28165dd7 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -202,7 +202,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 				folio_put(folio);
 			if (return_max_wsum)
 				max_wsum = max(damon_probe_hits_wsum(r, false,
-							ctx), max_wsum);
+							false, ctx), max_wsum);
 		}
 	}
 	return max_wsum;
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 9a38dc89a156e..4aecf34e39be2 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -704,7 +704,7 @@ static unsigned int damon_va_apply_probes(struct damon_ctx *ctx,
 			__damon_va_apply_probes(ctx, mm, r);
 			if (return_max_wsum)
 				max_wsum = max(damon_probe_hits_wsum(r, false,
-							ctx), max_wsum);
+							false, ctx), max_wsum);
 		}
 		if (mm)
 			mmput(mm);
-- 
2.47.3

