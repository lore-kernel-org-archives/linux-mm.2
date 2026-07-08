Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82905C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 840A26B0093; Wed,  8 Jul 2026 09:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C846B0095; Wed,  8 Jul 2026 09:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558B76B0096; Wed,  8 Jul 2026 09:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 256996B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:54:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BE43892F7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:07 +0000 (UTC)
X-FDA: 84965753334.22.3949556
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E7711C0006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lf6kEsmS;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783518845;
	b=Zbmw8t+T4JzhdAwIsL1GtSvbaZZ4YjAuAQ7O5+tZ0mW1Uh2q4U4iv0OFyTZVHww9/iWQ8R
	Hl/8d73pfZ4+N3H66ggX678IsEllubJkc7dPqla21Nua0/PksVPG1jmN4SuBZrdkAkyweF
	q6L6Eyr1DEHUdBH6c3M4clZTZT9C4jA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lf6kEsmS;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783518845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTeI5Dbt+ALLrinCjjWwHybLZIRmQonrPoimOF6qJBY=;
	b=wgfGgVbWN/ij3agguiC51FZR2nZgEs3G3lMdKQx5IO/OJ5JDVP8LLjPuSVwkt55EnERgss
	9Dournsij/lk/sd9V4d2y48O5BIqlB1xEdgq86hvaAldTn8naT2SCCphIX1oLYQCkqEOzg
	lMGL51FyPsN+CAXXOTyiFfDh/t8xKe8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 820266001A;
	Wed,  8 Jul 2026 13:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAE51F00A3A;
	Wed,  8 Jul 2026 13:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783518845;
	bh=mTeI5Dbt+ALLrinCjjWwHybLZIRmQonrPoimOF6qJBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lf6kEsmSr9mS1Ao8BNaCRDvYa6F1wSAzUqgTOv7PcASjgzndRIU0GWHqXzIxoygok
	 aOMZQ/L12Dm1dHUUSy1cGqIZ0Ul066NCOfbBdTPs5WquYn/VJ1XugiDoC+EZRjkA3P
	 ToJrv1DwMGpwe7R+PL9nsewFk4BPXGSZJdDrb7GwVZuBuvlZbsKFZ5WJjcsF75lMsP
	 P+u90EuH8WD9hPOEtUBZ2xRl6kSR6ysd9g4XuKCyxoZutuw4W21PDNsJ2hThMXq01t
	 Ol5y+ZJTrl7EGsBT+IA2JIy5/dvsXFXtfPyb5rxXkzYZ+GJNWEd2SusSONpvqqql8N
	 oh6txPeeLXVSA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/7] mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
Date: Wed,  8 Jul 2026 06:53:52 -0700
Message-ID: <20260708135359.122587-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708135359.122587-1-sj@kernel.org>
References: <20260708135359.122587-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7711C0006
X-Stat-Signature: bpfenec18fwmkewhq9n15dgkknohrprh
X-HE-Tag: 1783518845-234758
X-HE-Meta: U2FsdGVkX1+BJVI+nauInCk0ob7zN7WzYwO42jim4Rvp1Hrk6LqxqTeDQFnQdeVvXWArSNedR9I4l6MHsC5QiTpX23HSlA6RvhWg9qk6yqIu0OUq2iXO5vY1xyf0Z/x9oLuulhxKTOBdI2Wvq4zlJbPA7ynhXfMyPFOc396aMkJQ+Lv841q7ouvmnVA0+1yCx0zw+6g6pGskmqceFRE+R9kB/kVzcnCJEno2TFD1ADIi7ENqSXPskAWn+BN9I/xkCbZvid+FYxeEkd3Ze398yJFQEGmTPIJrbT+0qLBBGnKYguXkPwkf0RGvSMsEG9Hxgg5y3RHG/1Jt6TjmCl5GXKSJmq8cELfjBerHAQkbAk9J/KnZ+7p38PuOHfnr/e1kR+Vjy4B+cxlzk/9vtjbrkCaBR67M5Ap7P1L0tLEreI3cCLCzHnR7rNW7dH2RbrYBIwkqE6DEEWGeNrJWi2S9HBfYVdaQMbxdnupueSDXh6DeaKAeveepnwnp5eRCnYcu217Yd5iOiGNIiEpaLefAPDgy3bXPfWFGNQgQ35weQE0n8NLE26mY1vM4KS9LhmFnLI5e7cCjkw7mfXmam1vGSFIaHQMsGUn8sGfEhriWwVrimxINWDOgdh/ccnVvEQtmhMItuwOKrsK72J54TZ+R1QCxocxPN512Tn8W3vJAfk4QPwpGrr6ki+mKhP1CobIcp49cSVPpXK0vcV04GVbA83Pyh8TtGMMqqT0csbaqJNU0vJCYtadfDH9h3nxtn6hzzjX9ecMrdDIOYx3cBFo1lZr8sbeSEPZsXmFD1ER9oObgPGgidO9fqGunOk/x2WogRM7DmIfLz78BjkVY8RCc0EZrQ2EuTZcocb1ARizJBtuHTaAsAZQmLpRfTF6WNcF3xehr4FGWwdYqpWp4VtiBWGgiO/VKsNhD+b+zWK8eBoB4q45LecfaIrGFnJP9CpRq9bYZ5exirYgNQLRBOAO
 n35xhu3/
 Q1sEmuB05qihjdCH+qaavod4NV29TK++4dzk5+7Lvsgt7FyyKYasej0TbfN1GeVuoPoePF73tS+CPb62cCciXFqBo7LaSPLMJPIcm+tss0nqRDE8kI77hGzmSQeZAgVeTZ3o5zWBz9R8t2GBNwGb/cxEjoWJ8+wb+9I4gzCWswGeO7U20xD6ZJslxPkQSlrJPb37HDWfyW5tB7L7kO3k4NGYinjDURUlMaCyLdF39TMnjIm0Qjm2Go3M2zUTzm4jrGB86cVqKaKauHOerimX6DLzZPistuWQnsvXqhylN8nvT+CnVfims8UO084Pdr6mjkVLkvnJZVnFT+MgUhfEPk3ENRM8y2mU/LeGN6kAGF5BLqp0=
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

