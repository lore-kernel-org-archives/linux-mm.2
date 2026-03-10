Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C0BBFCC9A6
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE85A6B0096; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC69E6B0095; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744876B0005; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 486A26B008C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC0D71B7EEE
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:41 +0000 (UTC)
X-FDA: 84528360882.09.A6059AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4C39080004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QbK4s+oK;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOFAFBz42dgHvyUlx2iVVkYKH5UzTZVziSK62qPkapw=;
	b=YjYRw1z3JqkDOmiSgxEiLyLU+kMuIiwfB9tM4nldO63cGDW5c1tLBLJSXzwcofSpFo54K0
	yc+5LH/NPVT68cSmtFWmOlzdwzLHsVP9iLRYeHNp9s5xKT7K0C49o0dkUwMKOZvjDgvgX3
	jOl64n366GiMdkglkNUVVZR9PBsUJN4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QbK4s+oK;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104740; a=rsa-sha256;
	cv=none;
	b=c6u4ZgkhgmHY9Bag21JPUsr8ODRBn0Hx6B9x8ZWXYTaNeCox+hZG/0YeR4CDD2vcVUy67S
	SEqhUbwtTOVJaFcus1N2O4F/qsIxuKmyCR4UHRJFKAtBhHClDGfYjQjYIZK0/Tx47MXdUr
	DHJ1NdmCyA/SpdRU75zpuscTBBtq/BE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76A4F40DB2;
	Tue, 10 Mar 2026 01:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417DCC2BCB0;
	Tue, 10 Mar 2026 01:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104739;
	bh=/BXc7B9uaztn0WoEaxSSPUefWVgQvngZEj+kk1cUbBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbK4s+oKLNIyPuQAWDZFRszKHp83zgpPaGRUIYSdF6Yjxaq+GyJS1uLyyU2pYTpvJ
	 wz0x6oiqUiAzYFtlNzwuIXQIM+3mb6DKuNw2T5d0PqPvPjTZqjBfaH86sft56Bh/29
	 QnWdSq8DEFAYop8n2nf+Zw8GzJCfZQ9UCuc/J6d5fn+XiCN4QAMW4d5E6vK4OkaHj+
	 jSwnr4r+ZUisnFx/JoaTdG9f9etLyb2prTa71xkhNzEGeg1guZf9wKW8X2pCg8Q7Fa
	 Sbm3vVcby6kJPuEwi+FDOXXdgR+mY3J8VsBCczLs4Dd9VnlMImFOAiMf4TgS8nL7i+
	 nqstMJjSWvhjg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/11] mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
Date: Mon,  9 Mar 2026 18:05:19 -0700
Message-ID: <20260310010529.91162-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310010529.91162-1-sj@kernel.org>
References: <20260310010529.91162-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C39080004
X-Rspamd-Server: rspam07
X-Stat-Signature: iixn1fkx6jate1rbwdta17x8w167iemd
X-Rspam-User: 
X-HE-Tag: 1773104740-371736
X-HE-Meta: U2FsdGVkX1+JrOV1hdXtuSfMpTEKdPlu9F7ryev+u8tHvdgnjENsMjS/UV7pwpfj0YJby6eOM0k5wi8cF6961gj07bavT8YcfQsu45+IiqNfUZnsqwpe1R9foh058vk/8mqSRp93jIahIGsX02ke8fFNF+QzOCbLTbWEtQPprK/2iG/8D55Hl2jwOxau83XhSUm3HL8LSy3oatJFiDmpA149/gtQJLea9ZowR2wWQSnvrSx4/52sZKOcel3R9DvXtYWn/B5wotP5Caa4Lkn6xAP2ot2Xk7KBVf6781KQcodQXMid712Bwqj0sRFzufN+smHCRNUQQFUrYTTLl9h6M8/aJHXgl4gxY5G9o5u0TqgNjd3L3imndP5hMW8QmYuWK/cOvKSmzYL0EWY2BLTJzi80PZL5KlnaBdX/6iU3YMAcMl6ky/OObBzZUBNsMmnXWP+Eae1xURIiIiqw97XqKhDzS2zQ+KBHCceSg/cm0cTPDkA2DSbkWqg1lvk70eAPtbxAFb2P0Yufh39X237jP5JgHbbI/hr48CinbX4zBbPAeQ+h7qkOMDspPn9hDfXeHStb2b8ZOl2TgttCA8n/OaZD7IOGQg22E8hCmCCj+uEC0/ltkFSdYpLfsK7UWttXME3Epezd3n6iL2ZQcm0dkKi1wl0m1fv+r862/HE6R+PzOiw01Zn7GNwFeHoNCmKSLB5msZuaxh8+XW/CAh1hvIFeBmWdpWMeFKXuYnTL/j/tCPUlvkGfb2CVik6CGUgaFnmQ/8IBmy4VDcyJZZ90CQ/mLrueqB+PY8MOU6tQCjoLUWtWY3Nn65bCn9EHekW4uUl2nU0Fiv/jyEi/3dV6XyP/vyQycN6PEfC2YOCdTEp33/XnN7nJTKdJuQ6q4K/ZKuK6M+NuZw7K3k+n+Rwfp9E9LUfylhtNRzNtLQJTZtIxY2fF5MrilCTVKghtmvReB8Z/Sh6RC4lOetbhpI6
 NFsH26N1
 F6ozgC3+b5Lo0ybVAqzd7puPuge4uOMdHjydI0qAFQHtDiVUq7UzjgevHmNwOh6E5Syl/akBnutDfHPoad+ojKAf3yBdppseNzdnMkLaMgblZe4qw1Hh013d4BI01YGdjoyFdsxZpmg/+ZRIgRDxHRJS+CdKYRhdSPpYSRmnTv/J56XJr5zPXjex1E1FyZgE8jhMi2JrpcXRrvjnOQqjR4u25XPR/cjzq7yOSkxcH0550oEW76TdfzJuUIe6Nvt6e5YbusVgRGxYsbv4SoT3ytavMLluhYazE9UQTkTkE0eOsp6wJuKgSsbo1FJrjxHCYkkfT1su1uB9auMf2NfNHsKflj3Ax6FqpMYZnHV80726AmwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new goal-based DAMOS quota auto-tuning algorithm, namely
DAMOS_QUOTA_GOAL_TUNER_TEMPORAL (temporal in short).  The algorithm aims
to trigger the DAMOS action only for a temporal time, to achieve the
goal as soon as possible.  For the temporal period, it uses as much
quota as allowed.  Once the goal is achieved, it sets the quota zero, so
effectively makes the scheme be deactivated.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 29 ++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0824b953492e8..1130c2f9a92f4 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -218,9 +218,11 @@ struct damos_quota_goal {
 /**
  * enum damos_quota_goal_tuner - Goal-based quota tuning logic.
  * @DAMOS_QUOTA_GOAL_TUNER_CONSIST:	Aim long term consistent quota.
+ * @DAMOS_QUOTA_GOAL_TUNER_TEMPORAL:	Aim zero quota asap.
  */
 enum damos_quota_goal_tuner {
 	DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+	DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index d351ef3bcf4e9..2e36024d99506 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2345,6 +2345,26 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
 	return highest_score;
 }
 
+static void damos_goal_tune_esz_bp_consist(struct damos_quota *quota)
+{
+	unsigned long score = damos_quota_score(quota);
+
+	quota->esz_bp = damon_feed_loop_next_input(
+			max(quota->esz_bp, 10000UL), score);
+}
+
+static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
+{
+	unsigned long score = damos_quota_score(quota);
+
+	if (score >= 10000)
+		quota->esz_bp = 0;
+	else if (quota->sz)
+		quota->esz_bp = quota->sz * 10000;
+	else
+		quota->esz_bp = ULONG_MAX;
+}
+
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
@@ -2359,11 +2379,10 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	}
 
 	if (!list_empty(&quota->goals)) {
-		unsigned long score = damos_quota_score(quota);
-
-		quota->esz_bp = damon_feed_loop_next_input(
-				max(quota->esz_bp, 10000UL),
-				score);
+		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
+			damos_goal_tune_esz_bp_consist(quota);
+		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
+			damos_goal_tune_esz_bp_temporal(quota);
 		esz = quota->esz_bp / 10000;
 	}
 
-- 
2.47.3

