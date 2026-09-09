Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D51C3C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 07:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8AD86B008A; Wed,  9 Sep 2026 03:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CCF6B008C; Wed,  9 Sep 2026 03:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B836B0092; Wed,  9 Sep 2026 03:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73D096B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:07:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C3251C00CB
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:07:28 +0000 (UTC)
X-FDA: 85193342976.04.076991A
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id B265CC0008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:07:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P9R7ogbA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788937646;
	b=cyswgOjJV4qX+BjEPotnLp7o1/jkRh5c6KtPD5xKmUkTbxZ8A4U/ivdzrTGPpeNmckcdof
	oywifYqhLRqD4txmOx8VoF2/2j3TAaol6m/GwfbdfhffXJu4ld+2vyyDgG8NuE82xnaC0L
	6eNnTsTNJWlk7l1Pb/aXv13ECTqzgLc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P9R7ogbA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788937646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4zwWptEuC/b5qmaSqXScFrcDGg6WicaoLVMMEs633Yk=;
	b=hHhvc5/xRx0KBrdXLmFvq5EqNPa5idw0fjHINXMck1KrlzYOYlDsyI17JEKo1ZfmdxJwjf
	Cup8fnAtG38ra4owrI6BxJ7QmIeEguZ7wjlwficSmesfep61ifGZdxz9QykihIqZsK8LD9
	0nLser2pvHy00BGMHan61NsqArFrBwA=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc1c8d4a959so3782167a12.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 00:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788937645; x=1789542445; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4zwWptEuC/b5qmaSqXScFrcDGg6WicaoLVMMEs633Yk=;
        b=P9R7ogbAKyQnkt9YXsDFVadsNSh+Vtwjj2zjGBISj5b1K/vUoaiagv0TkpMI37vC0w
         /EdXaDZuf9mdmqJpuiKkmd+EQv2Y5V9TKxMqqd/GvLZLEi+hzUlnrx1zmLJuE7stJHXV
         wGY3No5PCOkxJuIpAUlEMJVaA7av/z/FXuytguTn8LAdcMUXT3DX2eWcb0Lb7hwXgkhW
         mI7kkUxldRviHrIOvVHxg6dXYwAUYrsQRQAhQOxTWu/MXLz604Z9O4ISQ/RW/9Vw1FzQ
         djA6Np751yGfzBxWjovUFt6KcP/UyF/UnZjsIUm1+W6XJWMWAxrcE5OKj90yh9/o5ZHd
         E0tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788937645; x=1789542445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4zwWptEuC/b5qmaSqXScFrcDGg6WicaoLVMMEs633Yk=;
        b=mv3Oey+JtV+XqvmwC2Y+PXpk8sTioumyrXea4Zmih4QELzAvZByp7wIw95AT6VdKbX
         FvldZWzGX7MWoFuxdyhIyfWWQZxR8qi/+mbBCxMsFYf2nS1pfJM234lu+HGViPTnRut5
         yPJD/82h+Kx1NUrorVNcbzkwvkZzGzuVajOQufONKyUi8LSo65pRrwc+c9GV8GyehyTG
         MtxAEIdzCVD8Iuqnt5nHIFNDcwgAPWvqvWKCodKR65+PhfI5gzCIFCWLNDgBwAbqWb4C
         F2eyEZ/Z9IuQXIsRFS6FTuBPBOfsZdYsxAlvMZ+L3X8ybQg2K8E12SCCZimhQQfzc6BW
         rNOg==
X-Forwarded-Encrypted: i=1; AKwUvBzxrZhh8u1c4ld2T3QgM5qZHZtaG8J9jNeU0V6bHS6zTSIu8SzFXYP73SxIP/PAgPPn86IxWjQPZw==@kvack.org
X-Gm-Message-State: AFuF++n1UEBBGfLgjgpQQBU/1f0BMXQkuvP0AE6dOGRXBFtBahO0YcQq
	uBlotRgN32KhjXmF1o2HS1t65M1sYs/Or2YFGDhnMT5moSNCOwLve22T
X-Gm-Gg: AYBFou1RidPK2ukAJM10JPcIAA5VI0lxNbzPtc79SNFc8GeTOOpPZjri1b0BX1juT3g
	SEp4cG/J6CDQlDy8S7YwfnDInPMoA9y7BG/1qkqzQrU9Wup25ixc2zgu14OchH1XSI5rqFgPCYy
	o04MbTWMC3+uUHxGxRZThsYZaED/+9wJi7eXoYOGWVqFl/DroSJ8vzQ7GQJnsqAy9JcI4JYOrYB
	YnVTg0RSiMMe7d6rLdXcmqhb3sZKDHyF3zUsmqeKD6DiISUNBu2dvyEc8GQ4lVNgZZp+oO2WfZP
	CY1f5QnVx2eg0sQNgdw0K8HdmDcQLFjtB06pXNozVnUQFF9/iqSr+ZjFH40o9L8IzkhJqTTPkIi
	rzZ6fikNAnXh2MKgq3IrlHhFc+PfpolCiZaLnLm3ASFLKfRpbeX9/LFX+aHQqL8WrSJybxEKavq
	M3FN0mo2h+sKqnVxWXnMVKQ8vAnrGhHykq+dQkTG6HCwrorVtFLFRu1v2snhOWCiYsG+UCiqisS
	tREG6AoE+FTrWnwNYud0QOKvURU
X-Received: by 2002:a17:90b:1a88:b0:38f:efed:5448 with SMTP id 98e67ed59e1d1-39b2619138bmr47894514a91.8.1788937640108;
        Wed, 09 Sep 2026 00:07:20 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08d0d7e8sm38243802a91.16.2026.09.09.00.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 00:07:19 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2] mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation
Date: Wed,  9 Sep 2026 15:07:11 +0800
Message-ID: <20260909070711.2448346-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B265CC0008
X-Stat-Signature: gqjpeanys8dqzx447wykhtga388b7o89
X-HE-Tag: 1788937646-540482
X-HE-Meta: U2FsdGVkX18gU1dI6BML8EF6e6Q+oGwUED3CVrVNMTebmC+z7Xi/isEA/RvAq1H5XB01Z/dIKYjYS9PblSxzvX9dzOuNjj7d6Qt/08D0v/91NbxCHxKpDt0APDOd0tFXKZAV0D2RnW/GoQuYJ4hHhwRAKOZ+UrttMrtd+D30eHcL8Vc8VdSXz4qiERsxNkex/jeUsNExNGOn5Nthj8MVekI3nharyFzDuZQcRYWfvaY5il9CBonj8avlpAlrSb43sgprtxGWJt8gx5iTj6UhWBGulirVmKicBHTPRePfH5p8KARZyZjVwN+MwPP8FAdD6Gf1fdhNr0tT5ptP0fA+uyjDVbGyqolQ25QcXUkBE47OtAbLP2H2CN01sxNOVqA2pYu5x48YhvXZ+Y4VwgCKSZ3lJ0T6+yTy555ouh3qFTbPXqKFMrhRdmXQdsxwt9a3nFBmxcMb4GJegnBCI5KIPiU+papDZcxDWRplK6Q1zPjUZo0n/JSrgiqJILdHpiQ71fOOI75H6WDIja5drhKPcWmGQiGj19cjsO2+7Ne5uJGdybK6k7ZpymZHHhD5gFReZ2EQMLZk8/MlC0XGna17qLa4XoHv2PbYJhqy+ttt6KhpFraIel2p/rvXPSrKlB1ZRelVICCsasPS1PWQAItVUMK0yUT1lZvMyxSGeD12bpjPUZexi4OnBDbZQU+tRvqFtJjsKyWvmhRyrPkNVvZB3YkZi6qP6FamrEqwzVsATb6TC0M0E6Zi62+YGXSD2R7wMy23Mv2LZC3pGaL86pvJTYvTxc0m+rehqL7OiOwhE3ItrSfAto3G7HEz2jkptG3ON+yJuOtjwQX9+48JmvIBfeeqxHaIo3IRQCgU2PeZTsw7ia67WID8tJdKnWKNYvKlefJfxwuT914dx4vaxMYwg1JuZH48PwAankgwQrxs3ow5CTXpG5YI1tm5eOpcBu1Oz4IsuXssQTdNdxMXo1c
 4hnfhM7a
 Q38+ETb2+Hy+6oSMHaHcvk6JFXAv4d2PyapUzUi7J13zWA0/5WqQ9eFu3MRd8Y+nVYjJCh+hXrmDY76Lq9/wrr5EG3xF5fzdZkOlpoChgRb8FB9dJd1wzics9K88UVcP6qJbpRE8TAMZxjaeJ+x45ptUd/KkU36uOwi4yRWBccXXOlcS8AAdwlZqlrOCt8XiEcIS3OYb9HeYOQFiIHWM47GDQVnXTgFlU7Hmz8e18DznKJNtK0bQqBTaRnxGLi2w8SkWJ06ghkgBULOpol003zw+TfPZ4BlYO9Bg0etzJeVrpURpHw1sJqVWB7srLTcX741vkb4KFRPdBb3crfjppUQFomVNagatljATb3Agc+Qy2XrRsYqmDRYt8sxDWKc6MbihHXLF6yrj+zqSbnvK5DB/9UELthmS23mYMpxf7ypnsm/iVkibtYXGSogntqHehiz8vLsOJ/uEKZzfwYwiSN21tKJGCkeK4OsrMBXZKNQbOB5rv6lFlweoRL717UTnWOsIyjEOYM+VoInng5inxQahkDs4k3gwCHpzJPRLM+eBieY3cjpOMMoFwIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test the zero sample interval case with a non-zero aggregation
interval, and keep the zero/zero case to cover the zero-result
fallback.

Also make the overflow case use an explicit sample interval so that
it does not depend on the zero sample interval fallback.

Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
---
Changes in v2:
- Use 0/0 for the zero-result case, consistent with damon_set_attrs().
- Update commit msg and add Reviewed-by tag.
- Link to v1: https://lore.kernel.org/damon/20260908063635.2208922-1-kunwu.chan@gmail.com/
---
 mm/damon/tests/core-kunit.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index c01e6a75cad..a47a5cdf285 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -627,12 +627,20 @@ static void damon_test_set_regions(struct kunit *test)
 
 static void damon_test_nr_samples_per_aggr(struct kunit *test)
 {
-	struct damon_attrs attrs = {
+	struct damon_attrs attrs;
+
+	/* Zero sample interval is treated as one. */
+	attrs = (struct damon_attrs){
 		.sample_interval = 0,
-		.aggr_interval = 0,
+		.aggr_interval = 5000,
 	};
+	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 5000);
 
-	/* Zero aggregation interval doesn't cause division by zero */
+	/* Zero sample and aggregation intervals cover the zero-result fallback. */
+	attrs = (struct damon_attrs){
+		.sample_interval = 0,
+		.aggr_interval = 0,
+	};
 	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 1);
 
 	/*
@@ -640,7 +648,10 @@ static void damon_test_nr_samples_per_aggr(struct kunit *test)
 	 * overflow
 	 */
 	if (ULONG_MAX > UINT_MAX) {
-		attrs.aggr_interval = (unsigned long)UINT_MAX + 1;
+		attrs = (struct damon_attrs){
+			.sample_interval = 1,
+			.aggr_interval = (unsigned long)UINT_MAX + 1,
+		};
 		KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs),
 				UINT_MAX);
 	}

base-commit: d118502628f8b673be9023db8bdf878f64a7ed45
-- 
2.43.0


