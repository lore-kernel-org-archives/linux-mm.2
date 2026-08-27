Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08C93C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 04:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0B4C6B008A; Thu, 27 Aug 2026 00:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94446B008C; Thu, 27 Aug 2026 00:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC4186B0095; Thu, 27 Aug 2026 00:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A44746B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:29:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ABE1B8030E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:29:31 +0000 (UTC)
X-FDA: 85145770542.02.CA53203
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 20F6980003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:29:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2Hocz03;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787804970;
	b=ONgaWCcUjT6jzCLBD9bqJd6sdGoKCj348fbAPVSFM3osVFmxIZV/1QFTXks6Ve9ZgsYHfM
	h2UrN7+9Hos0f7cJsmD9rQzUS6ksm6kPY7wnxRKADOJcKWTYQUNlvqhY3RUt2NjssyjnCj
	l1V7WkkmOJXScRUxQqRGSBGFt4CVSWw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2Hocz03;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787804970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8OhKNZlcbIRJFXZB0BB5LWgKdrRUKnRyLDo/v7ocG2I=;
	b=uD304KCkc+OISpUnUGYtxGbc8+5WwFeNhRRv5zv90pVOdKg0ESTrb7fB40PM49j0Tg62cj
	rK6n3JVmq49lgsLMiRIP5jM3CJYXodru4ErmIrvlrndrBnJ64R6a6jAF0bysduK6SMh5eu
	Gf6cgT86/PZEd7y9rBTcvAgYMsGTf9k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B2E7F600D2;
	Thu, 27 Aug 2026 04:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8A41F00A3A;
	Thu, 27 Aug 2026 04:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787804969;
	bh=8OhKNZlcbIRJFXZB0BB5LWgKdrRUKnRyLDo/v7ocG2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2Hocz03j8gNlThKs7aOx21XiilaMgxNp5HiTEagJ2jw0S1YA31Qu0dnzA5e0wM0Q
	 6cszBKjC5flBpySgaW+OX/GVYik/CWO8K7n3x9JfiEVVKsWyay0PmeR9Ry8aS2qWtM
	 j6pvS/EwqMjgPkBxa3FxCMRSLaFWwARxLtHQnB19qRnHimv9mEk2cNlDELapYEG912
	 sxuP8M6I+tcwvP9q+nJ5plp+Ha/WRDSNCvW2z8ibZIV8noyp+3TnObKsGwb9CsX/zo
	 LDj0+Bl2L4yAgBH7isgbQPx6so87RibHJywVlLPHJyXc9F+1e8fiPLTI2e+6Hm/8rO
	 40mx2wW3AKMog==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/core: initialize damos_quota_goal->last_psi_total
Date: Wed, 26 Aug 2026 21:29:18 -0700
Message-ID: <20260827042920.93580-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827042920.93580-1-sj@kernel.org>
References: <20260827042920.93580-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4drqafk8dxe8z6unxbwhps7b5azntbum
X-Rspamd-Queue-Id: 20F6980003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787804969-481254
X-HE-Meta: U2FsdGVkX1+5rr6sLCU20CgvDXuuW5m1W/kbTM1TNP2gkS0qCK808/4VccGpncINhfLuTNl7nsJVe6utnIFdb6Q7qzf+jIUYh0XIHA1GHsHPMGkoZ9rQ0Nq3CzQultzXeeJaRTNLYqVrUNIVDBAWAJX2Famlmq20YGbxiN5JzGyZBP0txmQd1i/AwyMuWL60TmDcpVhYb/bVbJhd1ZKfWX0c0LyQlnV1Cqlhknpf6C2n2craT4KaNlDb0PNWzgp8qOuFWkWEwDnzj3MjNY6noeo2LkTf0b0g7AF/WGUUXvvNXyU0P7jn9JZfYdfc+DlRfNtDa2ksLY8RYzeKHcyQYMuR2/Vbuu2gMSTolpp8uL99jM31EOmXSELggs/qYMZU2zREk+Gcy3UdwJa1pmUHBmC47gJJEVHpSIZ7eIgzzsPl+GSqHctoDziLl0TDnLOoYV18THY4VcNAO2Dal4qSwJx6k1TMZT5NvwvJ0nVByJxko6BFaMUaZktkuiystYRASnEZKA/6c2iYoyThfEXH+JExbZub56WoG65M55R6Vp/4MnHMPkCc/3FoWnYB/sVObDV6BBjeHJCBh+ovCylHWZm7dNG8LPYlKHEfROg+wRKw1ta2NxTtMJZYfUpknkzRQMcu+6vQcXbqXUnVikQrdzjDjG9pvCwd2q7Atj/ZNSczM6TTDb13BNzne6g6ycUoxZg/MrGojtiHW5moIf5So7CLyNHughacbDQjpD21qGS3IrmjQjHJfozQWSZsq/M5dy8aqZusnqRDHzTU61lR53YogjtJaYFRjSNbYTzSMmCVMBIw47YyyRPhsewv6hKsAgAVfFp8Is60v2JGJkLkv17bZseAGfRpYlv3HuDUOB8oZpRlrWpyoO17FmfA3PcJTPbcSOdmOpPCPjBkr2mi3z44EUbXD/UrAI/dr2qK0+siHt3+uhYMeU4P3sNczItkw0xOKnCIcK6sybSkWG/
 8kOktZjl
 WyVuFQiJ8gHM17dPe7WYuKX5tZ5eyJ1/nMcXxGuhPISfpzroDoX1cajDBDgiKAtYNNLRh9/Xu1cezSdzMkX74ML2V9SvMC3JuhnVMqgpdsfMOGRajrZPsnTPRdHqcgebNRUjyqYwsbLdq/IjrJ4jY2CEfPjOFgMzyJKoS3CPyWrZDv0d9jo+5Ps2FLIxnLwbu+RZ/fhh/jsniHhKldpfKP7CZgSLBHAFPoZyhf6OBUM0Iw3aE2WXrZOCnMZdLh5IVpLrq2zkLrxrESnCVz1rsl5T75Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
delta for the feedback loop is calculated using
damos_quota_goal->last_psi_total.  However, it is initialized only after
the first feedback loop.  The first iteration of the loop uses the
uninitialized value.  As a result, the feedback loop can change the
effective quota in an unexpected way at the first iteration.

The user impact of the issue is not big, because the issue impacts only
the first iteration of the feedback loop.  The feedback loop also has an
internal cap of the quota adjustment.  The wrong adjustment will soon be
corrected over a few iterations.  For this reason, doing no
initialization at commit time was intentional.  It is also explicitly
commented.  That said, nobody likes behaviors that are unexpected or
difficult to be expected.  Fixing it is also simple and not expensive.

Initialize the field at the beginning of kdamond and each commit of
SOME_MEM_PSI_US type quota goals.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org

Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Cc: <stable@vger.kernel.org> # 6.9.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f8dddbff74a77..0d4a571482fb9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1122,6 +1122,9 @@ static void damos_commit_quota_goal_union(
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
 	switch (dst->metric) {
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		dst->last_psi_total = damos_get_some_mem_psi_total();
+		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
 		dst->nid = src->nid;
@@ -1143,7 +1146,6 @@ static void damos_commit_quota_goal(
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
-	/* keep last_psi_total as is, since it will be updated in next cycle */
 	damos_commit_quota_goal_union(dst, src);
 }
 
@@ -3741,6 +3743,17 @@ static int kdamond_wait_activation(struct damon_ctx *ctx)
 	return -EBUSY;
 }
 
+static void damos_init_quota_goal_last_psi(struct damos *s)
+{
+	struct damos_quota_goal *goal;
+
+	damos_for_each_quota_goal(goal, &s->quota) {
+		if (goal->metric != DAMOS_QUOTA_SOME_MEM_PSI_US)
+			continue;
+		goal->last_psi_total = damos_get_some_mem_psi_total();
+	}
+}
+
 static void kdamond_init_ctx(struct damon_ctx *ctx)
 {
 	unsigned long sample_interval = ctx->attrs.sample_interval ?
@@ -3757,6 +3770,7 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 	damon_for_each_scheme(scheme, ctx) {
 		damos_set_next_apply_sis(scheme, ctx);
 		damos_set_filters_default_reject(scheme);
+		damos_init_quota_goal_last_psi(scheme);
 	}
 }
 
-- 
2.47.3

