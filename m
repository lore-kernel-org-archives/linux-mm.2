Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D82C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 02:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76BD6B0099; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00906B009F; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF916B00A0; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 622F46B0099
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B34F1120672
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:06 +0000 (UTC)
X-FDA: 84964077492.14.E8FE889
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 10CE940007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PiUnSXjT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783478945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTeI5Dbt+ALLrinCjjWwHybLZIRmQonrPoimOF6qJBY=;
	b=sGBgpHgOEC8MJjD6+uso/gD/OzM/GUefKqEy9jhxDz9kXxLG78w6J2k9PZrOVRy5tLByFg
	jbmeaodpAp+wjFC1iXLrAJjeHRqkY1mbn3mwsXaq18s3KXQ62BwbCUuBc7O0RYjzuiripx
	fckRQhZQ8nVONK7VqGnvcUx7l0VyVq8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PiUnSXjT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783478945;
	b=eP8aPB4wvMjclfarXw2dngl8UNxMvTnbtCx1v53Sxn9Jjlsk7uA79MI0gkeQETXFN2ssCt
	PheUO/SjaB29+/EWBG2t3QbNuD8RRiIQG3meAPzW9RzAwQ6kOxV9nGK35+3yHlfAF7GtDD
	Kv4sIfo1yLGm+wlZEH1VMoq16UbkYrg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A935A601D9;
	Wed,  8 Jul 2026 02:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543191F00A3A;
	Wed,  8 Jul 2026 02:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783478944;
	bh=mTeI5Dbt+ALLrinCjjWwHybLZIRmQonrPoimOF6qJBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiUnSXjTwIfxjIy86c7MyQH6nD0+t5BAxC9Fhc8TZxDjbICpxFbMgCwigh20FopmT
	 KZqu0LWJvCFRGu/EqfzVUpmvjhUXvZBjLSubgfSlJyzSFRxInFtMLxQjT5DPm/KJeR
	 WUdCzSHiNUCE/j403Erhf/mGYAyZc7X2FABC9ZT6imOnf+nxvgSEWgoDnjaT3Etlsw
	 ALuJlfFTFLadIPlyAcOAdicmcnYsV5fzaGDimBHlA5MAjbq1jgmHqTNkgVRjDu4exi
	 DQQAIo3/405PNBtov5iNZzhbP2oDedYkTOcV3mdDhTUOO85/YPOdg9lydS1eNM0Cf0
	 UljpG86xHr+vg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 2/7] mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
Date: Tue,  7 Jul 2026 19:48:48 -0700
Message-ID: <20260708024855.116614-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708024855.116614-1-sj@kernel.org>
References: <20260708024855.116614-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 10CE940007
X-Stat-Signature: wwc7kidway41ps69pzpqtbzyyrse3c4j
X-Rspam-User: 
X-HE-Tag: 1783478944-281258
X-HE-Meta: U2FsdGVkX1+wuSdeIytzuD43ORtsZzO76sAvYmhRtlMlkYlpV6z9ba/USh7s6Y2YsZerIzixr0x+uLr33fqehxrPamnHVIZ9/nSO/O7oCOwd9YS49eygyw3148sRUWSWBIqexmJJ0Va3qAi9COroSM1wL//imPAW/ar7+689LBjGE3A/BjylS57U53MfJfq5mXD9A6EUGo+zCi+LpH5uilyJghRn4dkeM51bqKIe0JBh3Twol3FhDgC12fmjeTbEFO50DSdTKl5272Oi1TtpIQJN0B2hi0jJzPk7rRAdNTTkwjLEMf0wvX8zVdG02vq8wEBRpafVnNfbT2h1+MwT18YoC415nBxl6dWlQod7iiO6UIVeqBuM/PqL91Tmtgbar9YpSJsTEPKZS4RLLUkwsEv3GYQTFIsDbFc+4nac7e1EL5VUCcxIk3rILj4cdvOK2zjMdWU1BDRqLzgRZK0NYu6x/t9AcrjSO4FmV0LH0Ywam7dBnn1LjAc5rvTx8ICGR8z098RzdqUY7AdzpO+8eIhFTPtPPzHNysruvUAkRyYSA7B8swQX3b3CcjXK1fY/c7+WtwSoFK+AlxxyNhqIGVlzu8ZBOLAdMSJlYgKhkl9ok8DidCuiQ7dPfVuFKT03B5tGYx/SVZuvWvhrp5Ty8gMN/xDenxZ6GiBaINAyD/qXTXnVJkGI7B07BXUJCqj/GPa2+XgoEnTNxzB9OvlHVM8o5tnfoWixJxi0blbqxB9+eQVGlRlajDYWFiniaheMzdmjopEp2W9FaPZ7NAUsZFuOyzyEKTwvDFqJh+ahoxG7vtJnPg5m9EaQqtG451VR3r3lmKy0xnXfNXxihnBkeZGZxL5llRjvKTM4RBmk78+rtmLEXW/IbJ6lWfBqDkXmyf8OCCUc8/Zm4kbiuje6bZ+Ca6qGLfmB4JmqrNnJsImmzb0n36a+hn9lDy0aYZbRByPKHQ7H/S6SpAASnLq
 u8757/Yd
 lnHfMSh30zkymrOR3yxNhnl6szI/OHzSHn+OcOVb9Ya4qxYdr7f5fuQmbXmEZCxPu6tLi6VQ49FqrN5+O03qnuz1ccyGDm34FZH4VdFWxMjLxWpR1fCpmcMlSK5/maF5XS3lKWtlOru+YTU7mqiop2TUf89Ljd3j0e5TDCo2S7ndsk0JVwzOJbqRtP5JJ1fGmrgQaEzHAwFCRELP6UkE2dY3tcid92+DPFSTkTWFC3Ipfwemnca2U+9dHzWX+uTvDuf5gvVxP7jF2aQ1HNqBZXVkRAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_max_nr_accesses() actually returns the number of samples DAMON
checks for each region per each aggregation interval.  Rename it to
better describe what it really does and not confusing for more general
uses.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 10 ++++++----
 mm/damon/core.c       |  4 ++--
 mm/damon/lru_sort.c   |  2 +-
 mm/damon/ops-common.c |  2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 19b7e839bde0b..63f596957c1f1 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1056,15 +1056,17 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
 	return ctx->ops.id == DAMON_OPS_VADDR || ctx->ops.id == DAMON_OPS_FVADDR;
 }
 
-static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
+/* Returns number of samples per aggregation interval */
+static inline unsigned int damon_nr_samples_per_aggr(
+		const struct damon_attrs *attrs)
 {
 	unsigned long sample_interval;
-	unsigned long max_nr_accesses;
+	unsigned long nr_samples;
 
 	sample_interval = attrs->sample_interval ? : 1;
-	max_nr_accesses = min(attrs->aggr_interval / sample_interval,
+	nr_samples = min(attrs->aggr_interval / sample_interval,
 			(unsigned long)UINT_MAX);
-	return max_nr_accesses ? : 1;
+	return nr_samples ? : 1;
 }
 
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index a15005db82899..177e5abc981ef 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -880,14 +880,14 @@ static unsigned int damon_age_for_new_attrs(unsigned int age,
 static unsigned int damon_accesses_bp_to_nr_accesses(
 		unsigned int accesses_bp, struct damon_attrs *attrs)
 {
-	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
+	return accesses_bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
 /* Convert nr_accesses to access ratio in bp (per 10,000) */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
-	return mult_frac(nr_accesses, 10000, damon_max_nr_accesses(attrs));
+	return mult_frac(nr_accesses, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index e8c389ad3226f..7e077084cb03a 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -303,7 +303,7 @@ static int damon_lru_sort_apply_parameters(void)
 		goto out;
 
 	err = -ENOMEM;
-	hot_thres = damon_max_nr_accesses(&attrs) *
+	hot_thres = damon_nr_samples_per_aggr(&attrs) *
 		hot_thres_access_freq / 1000;
 	hot_scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!hot_scheme)
diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 6bdd1cfd3863a..89c694f6e4fa8 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -112,7 +112,7 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	int hotness;
 
 	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE /
-		damon_max_nr_accesses(&c->attrs);
+		damon_nr_samples_per_aggr(&c->attrs);
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	if (age_in_sec)
-- 
2.47.3

