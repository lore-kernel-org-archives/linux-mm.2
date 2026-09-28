Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3328CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8FF6B0098; Mon, 28 Sep 2026 04:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9834C6B0099; Mon, 28 Sep 2026 04:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899056B009B; Mon, 28 Sep 2026 04:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4AD6B0098
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:48:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 07C1A1A00DF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:48:26 +0000 (UTC)
X-FDA: 85262544612.18.C3D6B92
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 654681A0003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:48:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wy0Ja1Gl;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+XUTYe6hm3kxfI8yuA6zaaLnG2sroAqD2TflRvrQMQ=;
	b=oZ1J0J5QrcDzJGnck1axFasvCiFKrRptXEmX9B4Y20KnUAek6zD9zDcXTjZpp0BWdTiDrR
	ApcpTo8P1dxdPRGcn1XDeV3XVvYnxqlU7XO7yLeL2Cb8qGPf5ZP9IM3AQ7CVA0QRjZYkYo
	z/pR0I49jrgdnRBsYiRxO5sPXYcryMA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585304;
	b=zrywQO7x7i5eSOCwwt/2EYv5HXDyZ2Z6NrfrmOpihT6F3mRz7WdE0sJACJ185Uxql9jg1R
	eshe5zFQZqfysnnkzFReqrWQzgD+PoygKABmqk9ggTN3eTTFBQVqETq7y1m4qBOQIOKJsQ
	YFw1cObeCc3bkvmpAHC46FSnZx5VTWA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wy0Ja1Gl;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B174843AB3;
	Mon, 28 Sep 2026 08:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61B01F0089B;
	Mon, 28 Sep 2026 08:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585303;
	bh=l+XUTYe6hm3kxfI8yuA6zaaLnG2sroAqD2TflRvrQMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wy0Ja1Gl5W57VgNDPaWrMrZoejn3vl/3qftaheyYiODpvqNaNAyn/ZXtL5SEFz40g
	 mjir+nu2FumbFHeOBwM4Z3mvJrN56x0y8T1TiiWU3/KEOqmkKXfeIgoT99g5Rzoe/S
	 Jsa/fLtMR0kJJ/WN9j8RbtBtVL7xvKqIM3hPQQgR629aqS7JH6tFF1mJPGM8ai1sBu
	 b6nw5Q7+e+qZYuod6NSBeMvS8lpl7y45XI9zx8jSupmSPE2l+EStLCMcxYTLF6Iewx
	 wUvi2v1wDWW8wBomt19BfInZ0Vlg6+19cD+Zv2ltxdwklnC2E43qCH8XFwPGwwubve
	 j3yZ01TwQNmgw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	stable@vger.kernel.org,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 1/2] mm/damon/core: prevent size quota overflow in the temporal goal tuner
Date: Mon, 28 Sep 2026 01:48:14 -0700
Message-ID: <20260928084816.5575-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928084816.5575-1-sj@kernel.org>
References: <20260928084816.5575-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 654681A0003
X-Stat-Signature: zuiasn5ntfxmb8p3zi68hq7yiyex3z8h
X-Rspam-User: 
X-HE-Tag: 1790585304-5255
X-HE-Meta: U2FsdGVkX1/z8YjR4t4AY+Wf5ltwCc8+pN8Indz1BtQdsvR5Aauao3gsnu2Iq1zqONf3JBrjmjdUrK1K7lOXgJn5RdG1D4yaszjBiA7+qfJ/bJpHVXtl7Mhj2tcutdVH9XCfv9jqb4r42xpm2R2UfxlAtzRin590mqiMUjg/Va69HhQqhwkb8kJyqxAHHLI84uwpZpaxDHvAiMqApF5b2UJOhGIIiP9Q70srIigvXRn3gy3SMNRcJoEhiQ6g/5AaaL49o2g3cA9TQFcz/E1ahU/YQg2cuCD0obU2yh+63qshnRen/0i1E2zDvL6RRT/CHrh9B4Oj4SQD91trs2V0fgE/TFX7ydH5N69XnfH2BvTQ6HcKkuCWZA71QgOhZbHpsErRUug3AQCXgRymdFMEy71welMebwkVcmw4QOuAO2fjBlt5XiyU+Ee0LDHHtnARAAYZuf9t6vRr4/8vaVU763VMeuVugr7Tl+VC507GcN91o5Y4Iq4Ufscf0lnU3Sc/aKqbRZog8GJw8Jv4gzMF7qmYGJXRMBUDGgPR0YgZ4kSGB3fKubQj3wVnoYc+NUZ2GhXGGU84BB6BzweFYjHkDGp5Z2xsfPuDvUFslmgrnZxSP1CkhJh4gwP81t78SlHk5dmUxfrf/8qtlPFbF3lsHLYNCMN5mP1UJaC0mkdOKVSnk+g6GL2ikO7dgDl+FEYl9gpT/OoOdubffEhpHi37Fhg1mf+iUgYyuAt2pZcQjrCiZ/G80wyZmnKih4l8CTeZC5XrjoEnllTYaQN8pzzgx90E/6km5ILqRL/LxVmJmvpoouI5j24AtZen2CRylRvSIZKyrCm5oYY3R/QBaLhULUOQu4pPWi+AVH06Qq+DqIg8MuP7XxB+p0ifb9ipaxz4vbi6RwtymMRmfk1NOptlgMO2ZEfNP9O7ZvM75pV8N7pwMgVHRHZwaaKPLmTS4cJadkr6d4PvnX88rUCV/cg
 4+SKkxnW
 ZD238t+59DKsd0Pi5HnbiQfqVZ5vEyLw+5tcqpP97E1yE58b9hhUf/6vHrgF669MzAnC7eZ0IdVLIl95p+Q1VU7YZjer15vhyepe28YdafC8OOAQpMNBbGHirytZbioNo0ARr6vvojzgR9oP8SDHKOrmkne1HXvHyYSu2ljNUzN4YHfWbURTkJw0Hylp96HMS4Brjs9rPewQFUWReUIK4OUE9XoSz3CjYfkbZccDKbDBP/XLjvujqgxSRomYkiqjtMri8Asl8LUVfdqeCWFyrMxel/5KHnyYIzgynSF+IjQ3ISG7v8/vt0XMLpbXxKgbgp9YVb4ftFZUZJKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

damos_goal_tune_esz_bp_temporal() converts the scheme's size quota
into basis points with "quota->esz_bp = quota->sz * 10000", both
unsigned long, and damos_set_effective_quota() divides the result
back by 10000.  quotas/bytes is unbounded; bytes_store() hands it to
kstrtoul() as is.

On 32-bit the product wraps for any size quota above ULONG_MAX /
10000, that is 429496 bytes.  A wrapped product below 10000 divides
to a zero effective quota: 429497 gives 0.  damos_quota_is_full() is
then true on the first test of every charge window.  Other wrapped
values are wrong without being zero: 500000 gives 70503.

Triggering this needs a scheme with a quota goal, the temporal goal
tuner, and a size quota above ULONG_MAX / 10000 -- 429496 bytes on
32-bit, 1844674407370955 on 64-bit.  The scheme then makes no
progress for as long as the goal is unachieved, which is easy to
notice, and writing a smaller size quota restores it.  Nothing is
corrupted and nothing leaks.  This is unlikely to be hit on a tested
setup.

addr_unit does not cover this.  It only scales the numbers a paddr
context writes to quotas/bytes, so a large enough scaled value wraps
just the same, and vaddr and fvaddr contexts take raw byte values.

Bound the multiply.

Fixes: af738a6a00c1 ("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL")
Cc: <stable@vger.kernel.org> # 7.1.x
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0e375f4445fd..60e4233ed23c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3291,7 +3291,7 @@ static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c,
 
 	if (score >= 10000)
 		quota->esz_bp = 0;
-	else if (quota->sz)
+	else if (quota->sz && quota->sz <= ULONG_MAX / 10000)
 		quota->esz_bp = quota->sz * 10000;
 	else
 		quota->esz_bp = ULONG_MAX;
-- 
2.47.3

