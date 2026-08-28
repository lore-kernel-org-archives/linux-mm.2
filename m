Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9421EC61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA646B0088; Thu, 27 Aug 2026 21:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2341F6B008A; Thu, 27 Aug 2026 21:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FBE76B008C; Thu, 27 Aug 2026 21:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8F206B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:47:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F4E8C0264
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:47:10 +0000 (UTC)
X-FDA: 85148990220.08.1FB8BFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC90740004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:47:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xuo+8fAJ;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787881628;
	b=hB63YS50S/NH8Bpettm9SA733i+YkT7YzizVFXxZG6Ou4hX0qZFisCk/sEvIXm+7sptQ70
	aCNFLTIZwTADljEgY1IbYOOyodE+z/4X+TRC8fEK8f70OM/uoSclGNPm7qV8zwPCkfuFG9
	qAO8TWs4KQ0JdR+oCtXyZDbatPX9vC8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787881628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+fW2+xE2H0LI68hS7+oEWra7KzRlcB7nNxeFxWmibVg=;
	b=t0TOmlEz6d7M6aRM494Hs3qWVTWBzxo7S+hQgnNhy7umCQGgHxJps7TEFT+yJ6fobbC2xG
	0gQhXGYf/RZ9OKtgeBpV79NGy3n3N4IDpoTvTiFp4jUsh2+TZAgbkAHsfncqFgEPpb83ta
	VsfNJNtbjudG8wZXznApTmx4cIMQo2E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xuo+8fAJ;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C88343B04;
	Fri, 28 Aug 2026 01:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B031F00A3A;
	Fri, 28 Aug 2026 01:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787881627;
	bh=+fW2+xE2H0LI68hS7+oEWra7KzRlcB7nNxeFxWmibVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xuo+8fAJDcKr1s7ptBMW97qvPXuQTQ65OajmrPGEFKN623syOp6xjrvpubpt0jmc1
	 jdvV00hac6IQW6Byo/XvHu9tX4NVxv280ZtBgWUEPuvcpqipr0iYGaP3SKWE8wAPlD
	 o1SOjcUA46v9x1Zz9O7fZGzkdF/M5nRTZtVPY0eZ+yZF/ezYBNY7hhaPvYUL2ES9W3
	 XhXIm6QNPHU/riWefABzT80ZfFpJLn97V2emD1UN77lPARQ63gYzwdCvR5aCVJR4vK
	 cHdZGlguq4hteRUTjG0oNaQlqR5V+OYItH8WewHHH3IHo7Jc+E7cDl2ULk482q8N7I
	 LYyQxo0baIP0Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 1/4] mm/damon/tests/core-kunit: test committing psi goal to psi goal
Date: Thu, 27 Aug 2026 18:46:55 -0700
Message-ID: <20260828014659.121058-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260828014659.121058-1-sj@kernel.org>
References: <20260828014659.121058-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC90740004
X-Stat-Signature: swmrcb9f8tcjia9e6kan7nac9tumjjxt
X-HE-Tag: 1787881628-109082
X-HE-Meta: U2FsdGVkX19hVzzlJwhkjVigKnPgXBWzSBXZbwXPz/yvsTJsgg1842IJqTKJJHAtPFEEhqgTg4j8DxZx3wqf3HDcADeKY/iPhDUy/DSOY9+cneQu6yiVV1g0LtuSzPt54WmUm8miDTUBLmIePb6sR0+lK2mrBGXHPes1PbYy0la2fu8lJor5OwkBSsRynpNRHc/vDiya86SyvVqtIAKYesM3aXc5W4OLzoTT60xwO+3H4Rtt9vUm/T4Ei62ZIrBV4Of/SjZRXsVnPUZ7amie+IIuu9l2iPsDHzoTsnqSmZDf/tU6aVnj4oqB7You4+R5OOrvet/VJEHsn7UQnzWZKL60sSNYxuRbp1Q+gHTIWGAvvi//QPama0kRvyj3r2cpBlC4tUf9fL2wmymllUU6FHXziXJ42Io8CX/AuHoq4u4fpqfeBPhPa0+6v+lSXak4KGeBk1aXhFEmV8Zrp9ww2pK6g/fgbvMUjjwk8W800oUCurMnp/SiDbpHOHYl+TjxN2RipN9Zcd1DzfyvSXA4H4hoXT865td60cZDk76phR9Wc/v9ie+bYYhyKvaQFuhw1IfuahwY5E4OVlXdHsgGMN/Ij9yAbgx2ZEeAVAdV2W4NP6yLCL9gvNMyHu2sLBKhRU2pR2TncqWl49MSM6aNTgoItfhEA6sCQpwhpJl9W8xgVlMJgCbIiz0DIwL41P/GfFyvBL8qsCRjGPGnqPTVFIbNf1+erHAhuhmAYK1BbMrW6OMnDkRufWVpuVF5P/NShMwInOxYCDGXqoqJf6GmxmWocTC90QI/n0WR/EMDaoCj6LSWj1acF3JvIiMykgPGiGv/xZoRIlPo5omqihXwM/UUSfBP8oXhp5+kRxvjTtvxHDqbh7bInI5hgObGra71/SP2nF9zPalr7aA6z2CSkJ63QGd0x+j9L7XmKxY/nV3q60iw2KfZDLzOIMgLphsfMZ5HW353DgY6bzOXgOS
 OZhlGcUa
 5zpV/hseqsSizv0W3bq8U53BQv+/lwjY5ZTHB72XJ+5m6xZqWbG5PkkwvS5aVwAyE5r/9TTD2YZLuA+Y8i30mtfwoAlXZO6LiGmYy9ENAckcRFi0cg5iRUQkaSR7DsddDW1b8+3Nj+2vMCtZGtE0zNc4e+SJxdrnuopZkxKagBCtoMJxpOuZcKa8CExZyhZbFTn0ZuSZOTLYTtFRBb+oAfco6KvrScWAY6p6FN6xSW13EFnk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_commit_quota_goal_for() is set to test committing a new psi
goal on an existing psi goal.  However, damon_test_commit_quota_goal()
is mistakenly not covering the test case.  Add the test case.

Fixes: 99f89debafc5 ("mm/damon/tests/core-kunit: add damos_commit_quota_goal() test")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4a536d41cdb2d..b643f9a83f14a 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -787,6 +787,13 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 		.last_psi_total = 456,
 	};
 
+	damos_test_commit_quota_goal_for(test, &dst,
+			&(struct damos_quota_goal) {
+			.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+			.target_value = 234,
+			.current_value = 345,
+			.last_psi_total = 567,
+			});
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal){
 			.metric = DAMOS_QUOTA_USER_INPUT,
-- 
2.47.3

