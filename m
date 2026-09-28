Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFFF6C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EE146B008A; Mon, 28 Sep 2026 04:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59EDD6B009B; Mon, 28 Sep 2026 04:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DBBE6B009E; Mon, 28 Sep 2026 04:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0877C6B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:58:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4676CA38DD
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:58:46 +0000 (UTC)
X-FDA: 85262570652.03.0F1BE73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 98F921A0003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:58:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oZFF4oHJ;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUod8Zb0jA5oad7shZhRX8ELyKjWyy4MCAFtzmUTND8=;
	b=VwUU0JQoVpvpp3ftLtgfp6GsJ+DIXRhFocyH9dG6dmhlP01d3TX5JDqGN4Esw4vym5jyd0
	3e66qVCzHpiHoRq7qVnq0xqkjkTkyLb79aKOQfBh9L36BVNI8IVOzQ0IfympRrLaJFMU1d
	1lW6EIV8HwuMMBTGHVLXhL5sm3oBkgE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oZFF4oHJ;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585924;
	b=7CKEEAzYBX7MkxR5ebr4a1CIL3i/TVGpBJFQ/aLV6D4QseAusetd4URElzdeAhE6FrrPkF
	M2RFHyOjU6aa9Y3GNKgxMnKP+ZuIjbfW36vHXknAL/8hhhyPTts5zJQ8u7xUdnay6emiAZ
	+IhqVO0mzs1gQLahWE7oL7xFNPZH8NE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDA3F43C73;
	Mon, 28 Sep 2026 08:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E791F00893;
	Mon, 28 Sep 2026 08:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585923;
	bh=DUod8Zb0jA5oad7shZhRX8ELyKjWyy4MCAFtzmUTND8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZFF4oHJ1PNjSC8za8bNh22VNairImK4OlJfe9gDdRNsdNqV5ZeXSVVhTNZaZLf1X
	 WEDxb5ODYod3+m4aONo5mt0HOOG//POe0mj4CQlT03tW5lGUDwRJj2+ldCXimZTIMc
	 K0Q7nFx8IVgnXbmV54/fDXhaIKp89QQYtS8kAzfCmuwuCw7vQTaQd8uDZAzfJ6+Lw1
	 mpcA5vxlbEAjTbFxYLg6R3fbopaSspfe1zSK3K7V4bET43TutvoJUCshtpXlcOYq3w
	 tBkXcTHCEi439qea/+ERveasnoTb6aaxZ0F/TESENgG7c5CkF1iWULk55CuecosbXA
	 8iN0M1MmmW20w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	Bijan Tabatabai <bijan311@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/2] mm/damon/core: preserve the quota passed to damon_new_scheme()
Date: Mon, 28 Sep 2026 01:58:33 -0700
Message-ID: <20260928085835.7675-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928085835.7675-1-sj@kernel.org>
References: <20260928085835.7675-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 98F921A0003
X-Stat-Signature: oct1cajqh3pygkg3hyieckiki8bbq87t
X-Rspam-User: 
X-HE-Tag: 1790585924-273178
X-HE-Meta: U2FsdGVkX1/OeyHODBwKqkl29WdyhyHPh314RmNBsoZbBBiVnTLLD++EbkJbZivlXERh5yv3cdA+EnHumRuPKE5C5BHmTTu8YRpNcqBY2sBOurDq3RLois7FmBZM8r2kaOgJmjKzkcfPTRj9TQIsBCGFISy/AiCUH1OdCg3whyCAF0eYS8vtqWFzuk3yE457BK29JaK7bliZme+uESNfvaTriI/xJGbZE29ILn4CTxELEqCnlY/QREa2saefpP8cZyrNGxowpZ16YR4yPmjUZGClrrH5RhlaeHm75E1sp35zm3O8ASzqOL8soa5I12fqb5VF9getrr5OmiWQNUen9/qi95807cMzk1buvcvs+ffnCy1PwG8PJ8BtB4hmw8l/JQVd229qEgeJBcOnqbhHmPyn/Nb5QAVZ09hSS/DPV7usOlyQkWlV9/+p7W5+PFgmMLj/0i6a0qMn1oEQFlhyVz88i7NZx4sfKaZHuyolR1SeBU3+mAkLT6nIhoi2OdKD2tH2eDCGeLv+jWFtV065BUzd0F+7ynGY51fB91F5cqdH4xRmlL5N3LxCB8qHkWlk4RiLP7Hioxf7axXmajuEOq9OSd25uHG32IFD3NgcK3GFI8bDPF2GTs1b1DRpCS78i0SPupeuzoYKluknT4wCrgmbO49rods2PhpgL6pBxc5jZY0LddmZtAFPbog/O289tCJNiiZhjll/+MnKUeff/+Sdu1IHzs3C3ixN20gk28GlV35+3THWrE47AmokLfJ9OtBYoMAcbnTw7BQ5SUMcTveJJ+nGsJM52FspGWi1SKhiLeyl+HKpFe0SRY59xfSQ0G7NFPUQsi45Rb9RTXimpRsa11y04Z3r+vkSrQAcwoY1HLKgOcAxz2gKXZcELA2bSH462JONbm+ZSybRsgupjdj2JQfbKdB02g9pB9te05MfAvY4TSVHfGLcaIkHHh9tA5WskgzZNND0W5qBO5M
 OAAyBOgU
 m6AzAnS2vCBiorAD2kfowCalpq7BTbAkwurYekX7vIN5TSB1GWCoLS3eY2qITod+htmPvZe6XCd2Hfs8+pHj9wopkZnW98XawQeJCue23005LeXzJZYRWyGZfrltWQTOen7MXycuKCn9RgCclQa2pHljarkKFixeZuFuxn5454WkO/WjyB+hHmacYTxuRy7MB2JYUHA0HdnlIaG3f/F0cAp8YVqeqxA5br+eSAUldIPVS0j+iGy8T1Zkz244IVIi1LrDR3u+rgdFjE6b5PRo6R85vEonoBFebjtsGT4DbdY2XFfw9hDJhHEpK+PAkReAuLU3M/Hk/KAg2e5E3FbEU7YZ7paupJ6asc6uNdjked08EOt3hb2hnkgzN4UaibJ4naqUq+nbb6usLH2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Karl Mehltretter <kmehltretter@gmail.com>

damon_commit_ctx() first commits the running context's parameters to a
temporary context for validating proposed updates. When
damon_commit_schemes() creates the temporary schemes, it passes the
running scheme's quota as the quota parameter of damon_new_scheme().

damon_new_scheme() calls damos_quota_init() on that quota before copying
it to the new scheme. This clears the running scheme's effective quota,
feedback input and charging state. Even an update rejected with -EINVAL
loses the running quota state.

For a size quota, this discards the bytes already charged and allows the
scheme to use a fresh quota before the reset interval has elapsed. For a
goal-driven quota, the consist tuner loses its accumulated input and
restarts from its minimum input. A time quota loses its throughput
estimate and falls back to the initial estimate.

The end users will show DAMOS works more or less aggressively than
expected for online-commit updates of quotas.  DAMON provides best
efforts by default.  DAMON parameters online commit is supposed to be
executed only occasionally.  Hence, the issue wouldn't be critical on
sane setups.  For user_input type quota goals, online commit of the user
input score is expected to be frequent.  But, for the case
commit_schemes_quota_goals command is recommended for optimal execution,
and it doesn't have this bug.

Commit 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic
destination") introduced this problem in v6.19 when sysfs validation
began committing the running context's parameters to a temporary context.
Commit b90408ef1163 ("mm/damon/core: safely validate src on
damon_commit_ctx()") later moved that validation into the core API,
exposing other callers including DAMON_RECLAIM and DAMON_LRU_SORT.

Sashiko reported the same side effect [1] on the RFC of the core API
change.

Copy the quota to the new scheme first, then initialize that copy. Make
damos_quota_init() return void, since its return value is no longer needed.

Link: https://lore.kernel.org/r/20260702212143.0CB6D1F00A3D@smtp.kernel.org/ [1]
Fixes: 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic destination")
Cc: <stable@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Bijan Tabatabai <bijan311@gmail.com>
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 60e4233ed23c..5ecbea5d71e1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -734,7 +734,7 @@ static bool damos_quota_goals_empty(struct damos_quota *q)
 }
 
 /* initialize fields of @quota that normally API users wouldn't set */
-static struct damos_quota *damos_quota_init(struct damos_quota *quota)
+static void damos_quota_init(struct damos_quota *quota)
 {
 	quota->esz = 0;
 	quota->total_charged_sz = 0;
@@ -744,7 +744,6 @@ static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 	quota->charge_target_from = NULL;
 	quota->charge_addr_from = 0;
 	quota->esz_bp = 0;
-	return quota;
 }
 
 struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
@@ -776,7 +775,8 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	scheme->last_applied = NULL;
 	INIT_LIST_HEAD(&scheme->list);
 
-	scheme->quota = *(damos_quota_init(quota));
+	scheme->quota = *quota;
+	damos_quota_init(&scheme->quota);
 	/* quota.goals should be separately set by caller */
 	INIT_LIST_HEAD(&scheme->quota.goals);
 
-- 
2.47.3

