Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E678CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 00:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6D36B0005; Tue, 19 May 2026 20:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277206B0088; Tue, 19 May 2026 20:59:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18D126B008A; Tue, 19 May 2026 20:59:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06BCB6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:59:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65AD01C0C04
	for <linux-mm@kvack.org>; Wed, 20 May 2026 00:59:54 +0000 (UTC)
X-FDA: 84785991108.30.52E03D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CF729100005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 00:59:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ega+ZfpQ;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779238792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W+4vFlL4g0qhHATf1HFjGQrVj6nKXRbt1c5SFAqy/QQ=;
	b=HnFoGB4lYVczmxhqG3Yhi0Fn/7AQeCp+hfzhORVNrVMU1AaCrxFHl/KYnpSQw3TNh5I7QI
	jgNdydqnYMK7j06NgqF5CYb1gESkODhzUQ3hWRUj3eG2XwBbim9El9Vg6bAvusHRfcuqJn
	7s7K1GBgSRO0h6SU2RmhbdSKRfhaYMw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ega+ZfpQ;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779238792; a=rsa-sha256;
	cv=none;
	b=yM7vayGYfNHf2jrSjC8Zj7xSPgMMlc6Qw9G2JaT+QKxLBRrv8w6wTauE4ru1aI1tujRFmf
	t0jSdVuVb63xHH8RWerYx6/foorACZqM7kg/tu/0JYtT/cUp1tZ/x7fUycdRJYH1pYSf5/
	zQMYeigQesDV8/cQoi1XO3bmTO/WPJo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1FFA40278;
	Wed, 20 May 2026 00:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827371F000E9;
	Wed, 20 May 2026 00:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779238791;
	bh=W+4vFlL4g0qhHATf1HFjGQrVj6nKXRbt1c5SFAqy/QQ=;
	h=From:To:Cc:Subject:Date;
	b=ega+ZfpQ4LhyPbpOUZx7SWPWfcdiT84ClE8sciQGPWYEH0lNt+E1xgwAEX9m1DpS9
	 tJrAUjxmUn0/NOPeoP1zihiB6chH4SAxl0Bj57rIQayVHMOITsgq+BGaUB/s/MGGfj
	 5JkPujhA9dksFfPu4hZ2q5BOExwHLQR6Xzcl9t5xHdUdjBdxMxt/exedy+iILvMxTz
	 WftBCoHQK60Pebt1NFgmCUEb+WNf63bh4LXty3ngjyFraQkTASsl/4e9zpAcHZPukH
	 hJzx+y0iqcpqQq5iuO3iv2/MnQ55HvoGCfNheK/I2nEWMIfAU9GObaVOz38UX2U3pn
	 dZolO+NeT+mkA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/core: trace esz at first setup
Date: Tue, 19 May 2026 17:59:38 -0700
Message-ID: <20260520005940.92003-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF729100005
X-Stat-Signature: c8uwpbbpp3p5876ai73h3a7gpbeswuou
X-HE-Tag: 1779238792-811934
X-HE-Meta: U2FsdGVkX18SdzeL0w7v08hNjlwOxe3h7Y06SSC4uMWKyjyKAkMEeKjpFvenc4fnzwGbSOH+5wwpMYLWz+HyCMUZefCVHllcpP6BVL+jpbTbYOQDerImHEtcS86GuwWklo4oVDbGcN2Iyjmh4NkTDxcElsjtfGYu82z42eTRd8AfwXKokvOWs/ADKfPwW4pk+PNdwSyrET5kMiSG88WXGisyIb2KrFQlGZs2yP5J60kda2cwqxcrstawTkf7Zya/Ssak1cuG+wo8+ncBzjzAonfiZCQp9ViDzJoBheUOAEJ8zqAS/+ni3d0//njUfdX/estPuTqweZV6tPmRxyDm6CM+4MW64emR2rRhKgXNZTVC0wnf6gM6Q6XyotqjYex5TvvDVADApiNIu9DuXVtfXCjepVmHvpOKA2IFzAUI2NMBEVgiOJDuczvJkXta/Qut9k1ch697OMssyebwGhU2WYO/y+bbbMtNhavEwSIq+AZ+EARMy3x0GP0ZfujrBGZXXnKY28Pr4YxLo84AdWZnmL2hfy5wICJUdEP39M6DfQ57V7B+us272WazG7rnjcdFEmroGqwI+pcUVwaPOE6FNr2Cxl6diOeSWFQgG480/1VAhyKhXZAfp5gDWlXE6dj5yL1aDabiua8Su3saU8CD4igxcli2e6xV2Pay5hv9WJreBQFz4LHvdRf0M9F6gbAwnKRsDGJyypw5+tgGAciPHedYyvyqUib0eHY/biR3v2D8NsUeg4X0EsFyufvhI2hDYL9q5XV4sxF0/SfLo47B9Gta2BPSdRekkVavlufAo7U6efElHqq90w+nZBdnwKH3cAJ5xDi3D3m7m4kBSxCMkzztBOGM44lTU6sDlr55xxj4m6gxyfY/8Ir4zVit5SVaU10hcUEzowcOtWQCziejrt3y9TGFGmiG7Yo35a/okVd3qtkH/y9GSGJVt/UhqERUm0IYtyVFF6KoAFKLU0g
 8qDHWMvO
 ODZbwBDRjHpKPSQOGc4oRMf8fhR86eNpnI1xW0Nlke5a6iX/G7SWD1ADB3yXA7l8Sm5Z5eTmOCxr8xVZFv8fAIjdI3OpQb3+eaWvJqLCDpafxk78GUnDy8DyzP1dYAXCy0N+QoDd1OIe8rxGEvWdluZxn6ekxwpNcZrSOrPKX5x+Zt0efvRHp8rr5mTUullDNOCsMwnFomVvLeMfv6yTPm9WrucqYoYwNonhU5rj1DVzthFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON traces effective size quota from the second update, only if a
change has been made by the update.  Tracing only changed updates was an
intentional decision to avoid unnecessary same value tracing.  Always
skipping the first value is just an unintended mistake.

The mistake makes the tracepoint based investigation incomplete, because
the first effective size quota is never traced.  It is not a big issue
when the 'consist' quota tuner is used, because it keeps changing the
quota in the usual setup.

However, when the 'temporal' tuner is used, the quota value is not
changed before the goal achievement status is completely changed.  For
example, if the DAMOS scheme is started with an under-achieved goal, the
quota is set to the maximum value, and kept the same value until the
goal is achieved.  Because DAMON skips the first value, the user cannot
know what effective quota the current scheme is using.  Only after the
goal is achieved, the effective quota is changed to zero, and traced.

Unconditionally trace the initial quota value to fix this problem.

Note that the 'temporal' quota tuner was introduced by commit
af738a6a00c1 ("mm/damon/core: introduce
DAMOS_QUOTA_GOAL_TUNER_TEMPORAL"), which was added to 7.1-rc1.  But even
with the 'consist' quota tuner, the tracing is unintentionally
incomplete. Hence this commit marks the introduction of the trace event
as the broken commit.

Fixes: a86d695193bf ("mm/damon: add trace event for effective size quota")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 68b3b4bbc8fc9..0267faf216b95 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2886,6 +2886,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
 		damos_set_effective_quota(c, s);
+		if (trace_damos_esz_enabled())
+			damos_trace_esz(c, s, quota);
 	}
 
 	/* New charge window starts */

base-commit: abe8c076ff4a1283d77c1c5cb7b975723314aec9
-- 
2.47.3

