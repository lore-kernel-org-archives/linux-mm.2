Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 384C5C88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 19:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F0C6B0095; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508F46B0098; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333F36B0095; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 116076B0096
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E3D7A1C26BF
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:18 +0000 (UTC)
X-FDA: 85206071076.26.2A90EC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4AB1C1C0004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ToRA9W2S;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789240697;
	b=q5Gq7w94zvdO/CPgjqdi/yOpjDQg96T0NjRG+MHtnOMhFRdJhfZc4yfqc3wPIYGsuL/Uxi
	elsMwyy7zwK73S3kEpLnXGyF2fnARccjF2VdBKVZZh58G3+LIpVbkKZlGmSOLGBQJuus6L
	lc58I8ES9dqp7fLgSgW2s/C6Ej23ja0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ToRA9W2S;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789240697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCy1mpgnGFNfwJbYRh4cYXVMRxk5ZkvS/1Omzx6vs3g=;
	b=tMRJKrDo+7DgDyDIUuH5lcsus1J5lOpnWgeY+xEaA65shb47eNGqyqN1vOXIdQ7DLg5N4X
	VZ5sxV9wGiFAH75M2NjnmE0bbP24dzoyPDo2LzRcqJ29lJuIRfzvsFduyQpSeizodmXw96
	xPJhb4IruDsqLHIUOsUhL9gJg2Lch3o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F4DF40AE1;
	Sat, 12 Sep 2026 19:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BACE1F0089A;
	Sat, 12 Sep 2026 19:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789240696;
	bh=RCy1mpgnGFNfwJbYRh4cYXVMRxk5ZkvS/1Omzx6vs3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ToRA9W2SK4fhF4Qsb8Q/v0HI8l5gMOI8Rx9/MdPJY20eeTc/Vf3G+V5giJolzRLdi
	 nDAeXesvRJa0J1Y5D+HV+iqKc4Wm/UMi1bkinZTAkfS5cbdYbw5EHoyXPBfLkYLorb
	 Qd0u6kqCp7em6DBSJ/7ZmAorUZkAvj2eF6mLcgjSiZ31hHtxMAQN/45JthcbAMBf74
	 jyftB5XC8zvcSy8HUds3z2r6xnOBpQjRp/Amg3HRnGtwnN4E/+ZFNgeNS3FM1OLgVN
	 SoGuDnC+35BjXPhBhmGVLMvDr2NXAaD7z9yIfFbjaLU9mTpzHgOvEZWehyZlkqE+Xa
	 ZP/Xu/Zfw/JUA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/8] mm/damon/core: return an error from damos_commit_filter_arg()
Date: Sat, 12 Sep 2026 12:18:01 -0700
Message-ID: <20260912191807.138502-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912191807.138502-1-sj@kernel.org>
References: <20260912191807.138502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4AB1C1C0004
X-Stat-Signature: ydw59fscmzd4hade1jssyi1r9qg5cpno
X-HE-Tag: 1789240697-34412
X-HE-Meta: U2FsdGVkX19o4Aod+e/+JmkMFq29nB4hX3c1pu1zA6GGyD+TASNr7PtM2owtVfPWOfg9BjUSm9FY5jHyQUJukmOswFr0DmCd0rMvWp/8qibe8VBsmD7b5KF6YYQ5+LHXnw6YB18KWqIDalmn3PR2Qwal8dumHPjSh7OmQUj21q25VBwjFHUD+HBM8bUqLufCF9hl69I8YpxqQJwf501LBU6uWVrw1gaTz+N7OPD66+ldDD3Ub4rTpaE6DlFKK4Aupxl7cnnpvhG6wpiG37Rl/PimFTppdPngOY5Z4eA4nplf7htyudTux/tpOMgLcjFGnp1N+NI/Y4YHWndAbnTrUvkC/aUVu9rgD8ECIrPNTiVknB5CtKSy61nVQH7+Y3ck9uNdLhagKa64tjEQPMSxi9+EU3d7gtTJUxLIrU4FCrnPCPBBcepZAmksW4JN2rfQPzV1jQbSqTwFWeO/EA85nnVlXUFRZyJcMtUf5/E8C0/PhdOX4sKFTsb7LyRKbNlBMSpTCe8n+kdzYkN+K3s/g7NGt87YvId36N5DBkUm9cIFm8SUF7771iKIXXaRgLhdOTY7W+S+n3mAPEARZeszkeBEgTh9b0SNU+O16uqEei9FVA/54/KSeAOtEELUQaO1ovHAOac/iGxYNV26lwAOMr5bTG54OkfevIFQC78wDboLxADxq19rnAZDlimpQI1EUUlkCe7qvVztKE0+y/93WckXCq4EB3YTyHHnyVMkyoy0bR0qyPDYwm8RLE7Enhctl8Eneop11kZou/8Yh8iFRFBiZM3Dbx7ed9rps+p4vptHBiFE2xEVvE/LmxDP6F4hIKKOCThI1gqWCQkzPggbqGRZlc1DUItTgJtQ5xBZg81U1PIvXg9abyFSFyruDDXM2a43wcNgsgw8470CXjyIrozrW5vpXBKj2ZfwnwovZu5m375ESl9Z8Za5mnWBh7tKWUWPS0nR1WyD6up4cob
 xQ5D84/T
 QhydFNnI0YrAewSxgXaZj4jU6/l1cVZeRNBhPhNUG8wmxu2Z6c0z9LFwQdhwHW07axdIgguUrslbYcduBlVMAvU+T4kHjwewZbwtbou2PPmo76ixrqgqeUC/cxEeZyLvw34Nv9vJmEZm0suJ8cdlXz+pFRRAdJcWoQrkAahZcsLtwfCCClY1sXyY2weycPP8p+KJuwre4/1N6soSrqRuJzSehiXU+UbQRf0oKXeoJMVR47mdZ1CKcHgxftgLFjKGiMN6tja2DdWVnDKbjILOupTcTYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_filter_arg() is supposed to always succeed.  It may not in
future, for example, if the given filter is invalid.  Prepare the case
by modifying its signature to return an error when it failed.  Also pipe
the return value to its callers and let them handle the error.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0c98f7e267d07..3ad1fb2f21f3f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1317,7 +1317,7 @@ static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
 	return NULL;
 }
 
-static void damos_commit_filter_arg(
+static int damos_commit_filter_arg(
 		struct damos_filter *dst, struct damos_filter *src)
 {
 	switch (dst->type) {
@@ -1340,28 +1340,32 @@ static void damos_commit_filter_arg(
 	default:
 		break;
 	}
+	return 0;
 }
 
-static void damos_commit_filter(
+static int damos_commit_filter(
 		struct damos_filter *dst, struct damos_filter *src)
 {
 	dst->type = src->type;
 	dst->matching = src->matching;
 	dst->allow = src->allow;
-	damos_commit_filter_arg(dst, src);
+	return damos_commit_filter_arg(dst, src);
 }
 
 static int damos_commit_core_filters(struct damos *dst, struct damos *src)
 {
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damos_for_each_core_filter_safe(dst_filter, next, dst) {
 		src_filter = damos_nth_core_filter(i++, src);
-		if (src_filter)
-			damos_commit_filter(dst_filter, src_filter);
-		else
+		if (src_filter) {
+			err = damos_commit_filter(dst_filter, src_filter);
+			if (err)
+				return err;
+		} else {
 			damos_destroy_filter(dst_filter);
+		}
 	}
 
 	damos_for_each_core_filter_safe(src_filter, next, src) {
-- 
2.47.3

