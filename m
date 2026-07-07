Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A48D4C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 04:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC7176B009E; Tue,  7 Jul 2026 00:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9DBD6B009F; Tue,  7 Jul 2026 00:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5056B00A0; Tue,  7 Jul 2026 00:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84DCF6B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:39:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D66391202C1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:38:59 +0000 (UTC)
X-FDA: 84960725598.29.00C1E6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 38DCD14000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:38:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QbYLM8YI;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783399138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kmRJdh4Z8VN1Ohuf74eNOA0x8KVycvYKKr9s4i1Pxk=;
	b=Dgdv2A4i6BcTS/gSxHRfA5qlrL8PcIm4Df8gql05EQWQGpmdd48JKpyh+Z8OwoiIGjdiXi
	fxUGJUr2DhNFpZES9QkO+A4TrNfdQouvgt/L8yzYcwfp3xrPRGbz/JogaY9Z5o1Wwj98lD
	OK2txDwJqJbiZVsZACagwrsY2EpbFVY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QbYLM8YI;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783399138;
	b=zhyXJg2BILoYpB9VVpqEJbjJFd8mdJAfMuoUc6B1I97I35gM+D2r7pgC6f20sM9Jnw9B8W
	a8C9YMPV430XC49A4Ci07IQfTCLdLECH0N7MW4r6ugwuG++jkw2M4PyAEqEowfTG5tmnF4
	AeesjMaZafKrzmVQsV5HSsIk7zNG9v4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E284409D1;
	Tue,  7 Jul 2026 04:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9311F00A3A;
	Tue,  7 Jul 2026 04:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783399137;
	bh=1kmRJdh4Z8VN1Ohuf74eNOA0x8KVycvYKKr9s4i1Pxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QbYLM8YIak3lVTyAlz1SXClscTCpBsAbBbde1sCuXdTW9B7RSFS+/e5cNoPVG9dmO
	 E9CyVTVsmcb8jb22qPhMKvWVwzIBKSYzUfI4B2xVHFNfqMvI8c9ivouS3YFyWKAs0A
	 aM1i5MeVj4aY5ywgQol/dQhrUXWI8O47BCuaXocCFBb3c5S+kfRCixeAepO8LFf1xF
	 4sDjomyXkeGLuD6FgKtkmZ+2csj0JinW8agHPH0vHpTGZzdIfIeKKelgROtqPf+L8B
	 3RaE2dYQ0EK1gb3dyPcBekpbE7/juPJBgolnqOo8qBr0qiP8Q9K7ZywMcOZz3bP7wv
	 a+35tBqMegBkA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/6] mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
Date: Mon,  6 Jul 2026 21:38:21 -0700
Message-ID: <20260707043828.97900-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707043828.97900-1-sj@kernel.org>
References: <20260707043828.97900-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 38DCD14000B
X-Stat-Signature: ty5zhths4gwan7jk97je7jgc8i58wit9
X-HE-Tag: 1783399138-113965
X-HE-Meta: U2FsdGVkX19hjZueDNdSvgxMgrDzggKJ2zqaHMtwmGoCoAm94hE3bSZtVbotkj7kwr0LX3kV3c7caPwZjvQ/1rI8zCPEvoiMEAciJotQt/ToVq0+rVVjGz4AXBbxbLZlTIosByZeLoF6cB3tflBgKDWWVwNwTlktQeZAAcYYJA8idp3iwx0rdGG6Ip2iuRVRFr2p52iP2SQuIxKSjHm/lYa7oXeSYgqnn/YG8jw1ZTFlC33Ib4HHbTsp9WrZ2TDyVFFlkm+dMEDoaRPUcemto1/yk6tCVuEr4ulWDZ3eHrIWAWqnLeZ64zW/ofkLIWC3rOo9wang5Rkb8Ikm+uZF+SvuHry9uwsjEuKDBi6pGecTAGiHCopaBIcAXTbarhOuEN5oqeirGuaSMNb8G4X4HcoQqMVL5jEvhQN2kb/KLaDLcrZ/NvWrOeqMN4YC3xCAQ41p6/WMwqnGbPZXWjeBBBWY9r3f1FEJufZkLdkb71TeRgFOD4EakUFeQx/KTpTcrl5IzB5pKqVtroPMc6ukPgUGkzkHQsc31+/p8S7gXkSfNaElMgedoDkSH+LurSmcwyqs6+F8/eeLJiSDNSgOwfNPF7HKmzMVTAHUKZzRlonX4A6v3VrWUpKab8aQel/Az4BzfmKpIcceJBY+Ka5RQIXB1J6uQNAsHgWxTMNHibR7DV0Ikh1SPalmQN/THSI6Ix1n3yaeHlHrpUnbxut4fDaGUope+bqXiKEVWxR8Wjsi4bgOkluRpP/zvHbhOg9MAORvMEZbcD7yjb6mdUeZ3kL8Jd2Mutj9OU/Q1Pr6S/TF1C2512Sg44SB+QQiPzf2PFZbYB92JNLcyoa8C1Eh0Zo7CTwyZW/G2Suv6yC+B3ShjRQBar++aH6SBK3U2feVJUnL0+9cclOWKhv7qGFxLwINPeZ8WF7Rq/UF8PAmzRQjyizjVWL7yH3Ao/6YB/+KMDHrWp1mEXo0lgidweA
 4go6Cm1i
 7qSszJEe3eeV0zecWhoUqXMngYDH+KejXLDLNTU0N11v2b4M6VcxaT8Ec8+3CjQetv/UU6ZI7uH+F9riNhd2srXxu18IuxAi5ayhzgkESrD5lZcobUobDyniS5NSTeHSibzJ/M3a7yH7GIGxiusheaiJc+l8KFALvac5ME1ftQ7P2W+TIMwopgqvSEDZhNCgJ2npDjieVfS5zsNbVssYgFMJ1+FnpjsQYEUg9+hFKzodoqpr4ir2Tyk5XAzuGNIOmLsA528NnkF0cQmTuAYmIz/sSIA==
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
index 390e00b3685ef..e710e2789085e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -880,7 +880,7 @@ static unsigned int damon_age_for_new_attrs(unsigned int age,
 static unsigned int damon_accesses_bp_to_nr_accesses(
 		unsigned int accesses_bp, struct damon_attrs *attrs)
 {
-	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
+	return accesses_bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
 /*
@@ -893,7 +893,7 @@ static unsigned int damon_accesses_bp_to_nr_accesses(
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

