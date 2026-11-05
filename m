Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40EB1606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SLA7DNSp
Received: by kanga.kvack.org (Postfix)
	id 5AC336B05B0; Wed,  4 Nov 2026 23:44:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535456B05B1; Wed,  4 Nov 2026 23:44:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FCE06B05B3; Wed,  4 Nov 2026 23:44:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19F0F6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:44:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9BC3FA86B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:44:45 +0000 (UTC)
X-FDA: 85399824930.22.4361E3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0F8B0180006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:44:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SLA7DNSp;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793853884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0E1yY97q/pydVP7NezmXD+YUjsSoHVSYEsMffIc/xZM=;
	b=VAlAzw/je002LmHiCr8NBpsd4Y7j/gt/eR8wFwGArZGNhDk7Sd2qdu4zRHfOPAspqF55Sy
	wNSe+e8gvRiBkAkz/5ziDvqQmtO99N8lB/WPiQxvNCQGUedE82e6wEkOlt6qJ0sRpNn4RD
	3/b4ngOiFNP8UWv7Z57v/ajSBQEuzHg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793853884;
	b=UMRysVUwir/dIb2OHqsTBmtdVbbgLQPy0T4WbC8oAvhCRqa2xGAdYtR1i7wNuksELIy5pN
	NHavjeze29P1csK61TbjlNG6xw+yyS8Y8r5GrPU+8VvILyWokHAadA3a9GXEEvR4MWChjV
	xaDqTATya1K1Zt86kMwGBtOpWaPNQfI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SLA7DNSp;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8945660267;
	Thu,  5 Nov 2026 04:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9CA1F0093A;
	Thu,  5 Nov 2026 04:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793853883;
	bh=0E1yY97q/pydVP7NezmXD+YUjsSoHVSYEsMffIc/xZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLA7DNSpQtaLkg6G/4UXy4ihZNO1i84EybNVBIO3rvMBbbx2XTwHwflUN49ZgIUbr
	 13GwnTmSTD1yn7U7qDg8NUULnqTJ+MrtyqyA7X8HZlWE+SwhH6wIpNu52uQ9A9W/N0
	 AYp/XrQ9Ndza/H2F85YWVoKYRGCYa+5ttpniRmJGUHDBkfqTHBmKWFN93PyW1Acphq
	 o9WmgspkQeFKzF4SkWdTf0BXQkPk9nT0hXQECwRB17qCGTH6TwqIlDC5eSqU2Zgqfe
	 UmYO+cYSIZ63iIcdFtgy1g08ypYEB8L2pQ+2Ol1SmwSit3qMriKafdTB49d3IzPO1H
	 WS/zywksWuT5w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/4] mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
Date: Wed,  4 Nov 2026 20:44:21 -0800
Message-ID: <20261105044425.87142-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105044425.87142-1-sj@kernel.org>
References: <20261105044425.87142-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tznem1xn1n68kncz1oqto5b5ju9d3sgd
X-Rspamd-Queue-Id: 0F8B0180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793853883-699833
X-HE-Meta: U2FsdGVkX18j5GdN22g4sE5NyrPGw2Puh6Gz16laqnycLA2ssNAcLl71qeeglr+axgFuyPKATW99GIbjnosKGWrpsSvGjNjFizDv6v+sbOq4THcL6taJG6Jo23lbzbGQTTaHLtxpFWK79PtIJOCsCJMX9xCUVciCUi5Ha9mpNgVCdpWdSmQWxkn/Bv83jpbgJaShzaoJK4QJQWWpT7CoeVgOciAExL/AYEJEtPi/Vfu2SD65jaqTA367FX3w7k+JMgwAxWVUtWjznX/gyr+thuWFg0NLFlciCjvEj2oqKnME/cseLPbvu+FR87z6rUJwjTt2RufW/kR7Ie/VEXqL1Myi90oTEw07bLihzxjuB9+1pA9Og7+dC7JYETa2w0LVz9Fpcz5bXfTnxIoG/49ZYrqs+hiryLpIE8Uiwd9y7RfFz86p7M0ECYkvs6wTIOVJcUFbTSpj/QKordltzryXjqCGreDhSXiFkuIjUz0eq7L/r3lZkX4ZrFr4biaW6Ur4JNsHTZyW5zp6tnI+kuTNH7nT4QtLM7pzwgnkn19jLAv4/Xt/VjMsz79IUD2EdTeYWQ3y12gVqb0GaVaAWyKw8wibPprotfU6pyhwKCxCXk3wIN3RBKtYO9jY3XX37SCfjuQL2/+UXzi2m/UmvZ6KHbC3DeHGeFI9VgUEZnzfrMdYo0jlWD6UffVq3oMSJAvO0OxxhxEgcXhip+4Otlg6KFGjdX9MD/ISCqSzFIBmMYzqLLFws3CxO0202bP2VQOXflqnKJw5dXdVWmHq9jL4BruVLB4+bESdFC/bWTGQ2vt1bOdo09bppA7+wFPbvUGyTbh5EJ9VXyWZjEP34FY+5k9sMzifUYnD7l/WiGTacdzGaSLaZQ8nF8TEvM8CT1YVyGnqldI9lHSfcDs2ZPKhQz6A0tzM1wUFSGJ5GB0qn1cUtG5a9+h5EKu44ooXL/0rh6uiNAjzSKfyT8g/te7
 3B+0hs5B
 obuxT3GRDsQs3Xym1/GiIUpe0EqSuqRS0Gg1WWNawrxpUdp1g2npcoix/86JRc0sZjb1tFPGxcRUKY2LlovXUUk2nK4IJAeRSu8gtHXrDJfvc6mmd1f8KLaKGuwgkeAlxCHOQH6vyrgs7j2jR6hEFdUKqYLsd4HKEeGea6Rum80X9Oqt1iKrDzJb/Nv0eOPG7OtzcBHRObISfmecKrwHYcQ3OudUdonKGbULsI/WNUykONLZxgDVn5pBn0o5lUPFqkd4YcanxcvhqJ6KwFIkro3zj9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There is no way to specify DAMOS target regions with a deterministic
time based age range.  Extend DAMOS core filter to specify target
regions with age in milliseconds.  Introduce new damos_filter_type,
DAMOS_FILTER_TYPE_AGE_MS in DAMON API, and implement support of the type
in the core layer.

Convert the age in aggregation intervals to milliseconds and use it when
the filter is evaluated.  Reuse damos_filter->range_{min,max} to save
the age range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 16 ++++++++++------
 mm/damon/core.c       | 10 +++++++++-
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 380f9cf6ddd82..1302ffb6f0bcb 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -394,13 +394,16 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
+ * @DAMOS_FILTER_TYPE_AGE_MS:	Region age range in milliseconds.
  *
- * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
- * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
- * damon_operations as a part of scheme action trying, and therefore accounted
- * as 'tried'.  In contrast, &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET
- * and &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM filters are handled by the core layer
- * before trying of the action, and therefore not accounted as 'tried'.
+ * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET,
+ * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM and &DAMOS_FILTER_TYPE_AGE_MS are handled
+ * by the underlying &struct damon_operations as a part of scheme action
+ * trying, and therefore accounted as 'tried'.  In contrast,
+ * &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET,
+ * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM and &DAMOS_FILTER_TYPE_AGE_MS filters are
+ * handled by the core layer before trying of the action, and therefore not
+ * accounted as 'tried'.
  *
  * Support for the operations-handled filters depends on the running
  * &struct damon_operations.
@@ -415,6 +418,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+	DAMOS_FILTER_TYPE_AGE_MS,
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index d36823f4d0928..0a056949604f9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -659,6 +659,7 @@ bool damos_filter_for_ops(enum damos_filter_type type)
 	case DAMOS_FILTER_TYPE_ADDR:
 	case DAMOS_FILTER_TYPE_TARGET:
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+	case DAMOS_FILTER_TYPE_AGE_MS:
 		return false;
 	default:
 		break;
@@ -1336,6 +1337,7 @@ static int damos_commit_filter_arg(
 		dst->sz_range = src->sz_range;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+	case DAMOS_FILTER_TYPE_AGE_MS:
 		if (src->range_max < src->range_min)
 			return -EINVAL;
 		dst->range_min = src->range_min;
@@ -2552,7 +2554,7 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
-	unsigned long start, end, wsum;
+	unsigned long start, end, wsum, age_ms;
 
 	*err = 0;
 	switch (filter->type) {
@@ -2594,6 +2596,12 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		matched = filter->range_min <= wsum &&
 			wsum <= filter->range_max;
 		break;
+	case DAMOS_FILTER_TYPE_AGE_MS:
+		age_ms = div_u64((u64)r->age * ctx->attrs.aggr_interval,
+				USEC_PER_MSEC);
+		matched = filter->range_min <= age_ms &&
+			age_ms <= filter->range_max;
+		break;
 	default:
 		return false;
 	}
-- 
2.47.3

