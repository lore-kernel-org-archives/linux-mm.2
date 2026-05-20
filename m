Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417C6CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FFB26B00EB; Wed, 20 May 2026 11:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0686B00EC; Wed, 20 May 2026 11:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89ED96B00ED; Wed, 20 May 2026 11:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2C26B00EB
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:03:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FF16C1868
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:03:26 +0000 (UTC)
X-FDA: 84788116812.12.3BE2E20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8A4981A001D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:03:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ccwhAOED;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cKMYreO0fJ6K2NQBHB0YB/VMVoRVOkqTPgCMvuDnzSM=;
	b=hAAbVuFbRznuQ+z5RqmHUSE6b7wLZls3M29uiXY10WM2163lnLQIXtqwepae/5O3w3bUFj
	JEUs07BLrvkk8Rowcxc5aNyr1F208xyArgILoj5U3AHvuX7IxjsP/I5Uzh/aGhUsjNJv+p
	nhF6R/vH8PM/0RwE0fpbAfrZbci6TVM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ccwhAOED;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289404; a=rsa-sha256;
	cv=none;
	b=GJsZq9UuI4ooy18W8rC1Ffa6CXRmQ9T7C7iMGJkLqp4ZtAfjxlQscgebBPd5fHVtwgGcq+
	8V6+aA5N316MvGHMQVcoio+Np1dgLNpTr9xBx92kOCqnq36dFo7XMih+0mEwNqt0RNN91z
	Sm8vVdg/BNEZ6Viii9Hn9WSQfFBycj0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6980443841;
	Wed, 20 May 2026 15:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AF01F000E9;
	Wed, 20 May 2026 15:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779289403;
	bh=cKMYreO0fJ6K2NQBHB0YB/VMVoRVOkqTPgCMvuDnzSM=;
	h=From:To:Cc:Subject:Date;
	b=ccwhAOED6qKyLpnVxZpflqp6L40gksi+/8sUEO3OLyFkxb+iOeJTXbu9ukTTsvYT6
	 2hQuCN99rprN7msTZSIE9UpQNeo7Vsp+UdkFvWZelZFcgCwYltbDnsTybV/5KKe7/q
	 p8cZh/NYjOS2ZmapWiH9md00CwlyX1n/X9nkZRHcrMT1Djc7gAWZZuHgRVJUutxs3H
	 ZblNbPNlbij1AQ9GlpF6TCwjFhctmQJn4pl56JY5SmYx7I4lU7wtqd+A1DOdppO2yM
	 vddqZxhGgG/0Pql6W4RJT7obhP5PT6aK875fCjfVgu1TEeQotKt6Eqe8P/XGMe/dac
	 yWLduVnLK+k/A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: trace esz at first setup
Date: Wed, 20 May 2026 08:03:10 -0700
Message-ID: <20260520150311.80925-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gas69ia4445nawh566t311b5ny7zeuaj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8A4981A001D
X-Rspam-User: 
X-HE-Tag: 1779289404-780604
X-HE-Meta: U2FsdGVkX1/DayaFjv0ooU9qDbx7MIXYHlduegwBtSVe2HzoiUYxdCiaxW3RELN4v34ndfUzVG2GJ9x6IiGSHUuDQLYhmGRvHKYlLzSWmu0BKusNxsM2YXPzDNEDEytd5V0zgtpG3IPylyeEfGSEQkKo1uFXJsOY9IsSn4M7lOrMZoUgH23VLNuueX+MH55bGSA72cof9qPhgzPEsCS/FK52NzUdnGOffYyvdIYvGcc4FbSj1QrCCnfcqR/Uyjr1ME51bSLicmVQzXqde7luGZGdJ7pH9JVpa66pWAehaa7+6q3T5d5xKLJLLzCVAZRpP3SyKeREJTEPsk34AYkmoEwRo+HHsb4eqbcbQfICJ3JfpP9FHpO8/97RVVytsxaGtZKtvWq7O8SvJbc3L1fuahweEOUbL54G5zfXj/NhV+WBT9bXy0anEYjsuWkTIJ8XaN2zek533wlRJx3hyuYFL1hI/R81J2Kex1qStsRwtMTZZ8Jyg2hZje3Hpt/fjy3elK1vEEMx4jt6WBpoTOt0y5AH4tv7ezBzX993hrrBQFzuyJPhtQgOWIeCK32Pt4gINy71AybnKYLGLl30WPmCuh0x/YNagBUGsxmWJ6e//fVH6C8VrzF/Sb3aoY0yg5yYMnaYtHhEofeOJA4Pyz4gKwvUMANPqEQOkDRNNIz+/pm0fcSPCZMH87IdkBRO/gvLntDPMzJEuZBOLgeOnslEvPsyZkkMEs3sc31ViH5HIox2ZatTP7OE3Q6CAA2ICLSB1AP2tza82R6uZCsywuPuvEy8rNDWnwOadCSkUS4/10QKRA68gMNOEJoQZO7PIOcFg0HlH++YSeVvd625SctqsVCLHn9munOB+OoXZUB44fFBfa5gzqtO+onzGp0Ved7X7CvorrWr0EvmycpW70Tt1SdqLf95fkLMssZUFNaXNa82veSXKwtzxQdvjMicepP9AHhX/agdZ8wMWQ3YNdd
 WmSJ4Fzl
 XxXgFg+B4uzr3Rn/gZegxJEenE9uxx9Xv9mgv56Fb5bOxZXNg/uzxIo6XayaAxzBrEusSNkUsytndTsrZhRAGovkjRxK78/0W6swV7Hl8LfwWjnpzW42UvsCc5Mouv9qF8op3oQYMpEzvcuHwW/EZ/HsEe7CC5wGVcEDxNI2TWsOXWg9G66QVvgxJkpDIWH/ulxZRXVq3dmYjfSxeaMBHhGV/Hf1wj5siqz5Ry7QM+h/QSFA=
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
Changes from RFC
- RFC: https://lore.kernel.org/20260520005940.92003-1-sj@kernel.org
- Drop RFC tag.

 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4e223857a0f99..0db6530825d1d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2883,6 +2883,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
 		damos_set_effective_quota(c, s);
+		if (trace_damos_esz_enabled())
+			damos_trace_esz(c, s, quota);
 	}
 
 	/* New charge window starts */

base-commit: 796dd9092b9c9d93dd48213582d45c43e93fa187
-- 
2.47.3

