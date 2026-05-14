Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF95CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F64A6B00AC; Thu, 14 May 2026 10:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67FA66B00AD; Thu, 14 May 2026 10:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB5A6B00AF; Thu, 14 May 2026 10:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34ACC6B00AC
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05E26160993
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:28 +0000 (UTC)
X-FDA: 84766208058.26.3BA0BB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4F74620018
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IXaOZZ20;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQE7mm6qSY7ktUE2mQNlJ8oG9D+viz+iFWiL8q/YNsU=;
	b=UM+9CqXr5MeDa2lfXhYGUEiD2lB+8ElG0Io4qUMz9kmJbLl8WAd/gIjZrr+YEzODL3UK47
	pXymzHZz795Ok8r5+xnhNwRuz8RP5YU6iJU1Yen3eUnfJFLPOPjWctAMFeZSJpB09LAHTO
	jMjHTuup6esxvV4+DMSqDgmWuEPnrFw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IXaOZZ20;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767767; a=rsa-sha256;
	cv=none;
	b=cnBF8raZVnP5vo28RyseLNlta07i4gFmS37Yoil74g+fvYgNJmdEMjgXmXAMSa2l1NiHuN
	6w4U/Qw/H6AV2IlgAUZ3zmXE8kr/aJAbTK5QIEdT1uUercwX5NZqYw23umOOKdsz2wNrDy
	BYyQQEI13Qsgr/Gub/6VkFEC9vXVNV8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CBBFB60132;
	Thu, 14 May 2026 14:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582DFC4AF1A;
	Thu, 14 May 2026 14:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767766;
	bh=qOqEZ4mTyQqrPd9Hvgo3jTPU9OytMKPgxXbnEmzq+80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXaOZZ20m4kL030F4QGEu84jVPcoDQ68yJ0/+Z/IzdoJiB6mlp9V4pz4lteFWXLWp
	 l2PQD/b+lKKRcSKi6zc61bHv8alSdZJlMO3HRWVla1E3GKH62USjlEdkWdlTARCnkE
	 Ry+fM3RoJK6Vgf7obfF1PetBp4De6Mfgmt3GkYL4amOsVPJZAghKlbVA1kLpn6SLd2
	 AAPeVPNrhf5HaOvbA3IyOU1BMfzDbSKk2WDmovg7d+mlOJ9pdJPSY4CRT4iG9h8qls
	 auhga034IPjE5yjUC8vz23FVusN+LLiKo+eqzObch59E6VvBT1yCXFXd+DEbuxCizz
	 3I+mEBiJ3UfDw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 22/28] mm/damon/core: introduce DAMON_FILTER_TYPE_MEMCG
Date: Thu, 14 May 2026 07:08:55 -0700
Message-ID: <20260514140904.119781-23-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F74620018
X-Stat-Signature: 4sfxrznfyzonus18647bunpjdzid4bse
X-HE-Tag: 1778767767-67565
X-HE-Meta: U2FsdGVkX18NCcppxPLfpvD381xumLe0B3ek4IE9icI7OZKa35FjC8KfNZIruKLjgfhT7nnJe+hB2YGprYmQOQOel7jff/WEPL4IjYTnFhrESDH4eVrbLXNs6jUoLKjlQwwrd2tqIA6ugA2poFZCcM6YHtSDnK0J0Iz1RQEBTvLPyVhoGzkfiVrm0KeX2bmdE4P6HpF08OL0/84ke/zkQ9H6/rUKRD5zvAh38i76Xs5EnMP+h7QQWqfEraWWu8UlPC4rK9kETWDd3flGM32hWvUJvxKOoEaVMekksFlYeywPy86mdfBSW4yGsy7h+uQmOKuvYt3w7wbHkm96dW3iLIca4ZWKc/n9t7mmhpbaw4me8DTb14M9wYkjG85xF1ztf7KwrwQV7/UUurQoJbOTRyQ6yYtATnXmQzcnZ6lS9ckgFEjx350QG7WGknYeCtAk3ZGx39WkEaj4rJsGpAcD5u5cHIYMLEZy5/5SMDPONcDsCKe8hl+AC8lkSGaeOz9bFfM/W2suPKybQ1OfiH0cyc3a3LHGA6xfYCajEZfNlts0wamZna8H2mFCac8FYj6nqui7vY7bq1y0+sk9a3CDXLbP7RVjbkJU4UEwk9b6k5YKoxhLuyEgd/wyhXjp7ZwHz2VuLesQmVlUSCPKrHl4sZ7DyzJVkEGr4Ik+0VtOFo00DYuyS5APQ71t7s9Y5VvBgIDTfatzX8OAj2X0/VLmD9kBxC0akTzeVYgl2J/VvhsvfMCKTVFGr8mYp1oiF2v/JlI5mwNs5b71ncMe5qcUbChHXRrdlU7BfKvhwsDtnGosZk0cP3gnuaYPzd74A2tsj6tCmvd9htj6C8uAEgv9FcXBRtDtbyAS5TULUvUT6q+JFou8nD7ndWwZpGSAZ/fcRo+eg0qxDCKBLZ1WQ0ojoVHCkBGDNmiYxqHPcorYE7tCGiUK3IUfWyFIVmqHrZduVpQb9eAJFVZJCvg0+Vp
 JJZUglng
 fWuAJOf4TMN1/ZiRGDdfcWk5cmOjolCmJ4KmwLZg+HdXGmEl4/jIOT3kBxty8fAtkdHO6Q70IVorzFaeOWhwkln0ZfrFGk7fPAFqXW/MuooTpcP8n4hggbI57RDHB3uXb1SmjTi7ZMQ3tQ4eUzTl5yCrC7wF7oCSO7kBPXLcwZSdUIX8rwHlrIQDnbcju+D1xPjylgBBMlhErYjbI48Z1eaZA0WKcizpY/UevUMDJkz1UnEgwwMtGLGPXNoVf8ui4aIbqgASgOp8OGYopP99hHD+spw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Belonging memory cgoup is another data attribute that can be useful to
monitor.  Introduce a new DAMON filter type, namely
DAMON_FILTER_TYPE_MEMCG, for monitoring of this attribute.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 6 ++++++
 mm/damon/core.c       | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index e9ca40cdd9102..3dec0947b93f0 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -740,9 +740,11 @@ struct damon_intervals_goal {
  * enum damon_filter_type - Type of &struct damon_filter
  *
  * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
+	DAMON_FILTER_TYPE_MEMCG,
 };
 
 /**
@@ -751,12 +753,16 @@ enum damon_filter_type {
  * @type:	Type of the region.
  * @matcing:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
+ * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
  * @list:	Siblings list.
  */
 struct damon_filter {
 	enum damon_filter_type type;
 	bool matching;
 	bool allow;
+	union {
+		u64 memcg_id;
+	};
 	struct list_head list;
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0ad1a0af06893..32c371c98a884 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1430,6 +1430,13 @@ static void damon_commit_filter(struct damon_filter *dst,
 	dst->type = src->type;
 	dst->matching = src->matching;
 	dst->allow = src->allow;
+	switch (dst->type) {
+	case DAMON_FILTER_TYPE_MEMCG:
+		dst->memcg_id = src->memcg_id;
+		break;
+	default:
+		break;
+	}
 }
 
 static int damon_commit_filters(struct damon_probe *dst,
-- 
2.47.3

