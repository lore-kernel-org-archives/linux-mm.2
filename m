Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D408FC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B056B0092; Tue,  8 Sep 2026 02:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3E206B0093; Tue,  8 Sep 2026 02:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54EA6B00C0; Tue,  8 Sep 2026 02:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA2FB6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:37:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E0ED1A03B6
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:37:00 +0000 (UTC)
X-FDA: 85189637400.11.E0AB1DF
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id C04391A0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:36:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rzpYKvAq;
	spf=pass (imf19.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849418;
	b=PoA95s3+/G24DJhnwFP+hLM3rMCfEZISnJsvbps0jPmAt4LQAenlYALUTdzPpyr5tJQJiC
	bX++OPlNoUZUpRkD1pq4/VPbGrF3YFJ614G9SN08pCh/inLjaKkPssKEQDEvEGrYqWsbYW
	I3JdUz7tk5hG7Ove8eCHX0bwCJhiNF4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rzpYKvAq;
	spf=pass (imf19.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xm1rxSc0BVfymKk4bSWdt2MAj/JI/30d2pnBXYKFQig=;
	b=sc7isBGkpW/EpQTJSOla/11gdIvnP3/zUDQU0JgVVFtlSWFErfSBxO2A99rRcl6msP5jwM
	k3L8UBd+mX1KOZZnVMei2Dcp6CuxHeS1v2QWIVmfNiYL0c8LpwmCNZuFJqi4iBsX8m2CAj
	sxaLdsMLV1QqlPUpSAbTqFAxyNzwR8U=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-39b35105ba4so3736461a91.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 23:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788849417; x=1789454217; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xm1rxSc0BVfymKk4bSWdt2MAj/JI/30d2pnBXYKFQig=;
        b=rzpYKvAqn0WbOQSJIulhP7Y3wrGEQaDeQK/E2XSR7gZPb50MFOZbBu4tRX0TVuqGBc
         SF8pXNykgm+OiuVjxAz1QFfny8pOZJLUMGKwlTZUfrfeaebL51VvuwHxufjpWxhrrZPk
         0Q4dJDCJG9W1vOcJ8dmUs2Ul674Qmc5rsIF4CckNxCjDlvHgfF+XIe8UbZtnKc2fUIt5
         vXbmjaN5+c1el6Iq7xP9ZpoBXTZVoT4UD8LhtxuExpAzCirtgPqqLhAgG3HOM9r/Q7Vw
         alSQlUNYpv+fsMxGxqnzCzJ0C4kyfltBRs+qu8+7cEui7Lfjuj+nNzVK5OuuKJkU0/9W
         yDQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788849418; x=1789454218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xm1rxSc0BVfymKk4bSWdt2MAj/JI/30d2pnBXYKFQig=;
        b=jEfQFnWdP64lIhpkNPMLCSm1p/4ukjcGd3Kxx8QLqTmEGbHDwMIEEKwYjnVsf0Ep+S
         n9k1lvSvnRIK+z2SQtmcv2fBpdNxFJhV4r4bPqeKfv5NWvJA30WDks/eZvRvHxb2pAy+
         l0whPcfsCnlpSEgTmUc84Bah0wHBEL/HXwzWN0qlYrF01SvlkMOW6u3ondJEBkGCFmXE
         pcPza9b9ZctFdeEPjTX/xf+x0IwkDXWfam2cb9Qca7pz27+feR8SO17HTwZLc1jsfuYj
         OJUs5YBjRJoK9PyEBwmaQI0i6O7O7RN4juQOWdme1tNfuAZFMSpvcNwrRDE0y6lxggPT
         kKDg==
X-Forwarded-Encrypted: i=1; AKwUvBz220rsDNitJ8vYq2mfd6i01gidD6Q1epfZl23mYSr5wQR5oHA/WJR+t2XypGokCj78xr/3H88S8A==@kvack.org
X-Gm-Message-State: AFuF++kFV/j2eT4vDZAcMCOJamzUUatUAiMuvrkycMzL5UBSYiR6C3cp
	Li7ZsfFZ+YZ4CMs8tJaH5QpApsblrN25xIfBKmSX1h7rrSwtDNJ175bV
X-Gm-Gg: AYBFou2p6ZkE26j7s6eEUNT02tItp/C+ZuuwU6UWR3GvUvZPpc3pZSKpAg/yfO3L3ji
	90CbekP+QfBMEkKG8uHPnKBqTBaEJ+/Vsnjn1U1t/IPBgyuS3SO1ZvSgpT7dTsXBsV00q9hY9vX
	5y/6fiZ/Z7VodHytpgkzdhd4enspMG0SFQsC9m2UukoWRzx6MwO60UzC59NL1Lq3v+hj0raPelN
	CVbxy9obdLxDVl3rPc1jto3jn51V5SVLNGfiW7xN2IuzG+GE14bXorDBzZGDIjSKj3k0XcYfb5S
	zHGC/5gW+BGHJFAgcX8s1v1q4gpmo4lCSS7BO8FvNLxxAosIi9e9avyjBPW4hMncI5GLPmBUHK0
	m1x+Dg4r0lh/kUOOOyUiXh8XpDcUd3IF9KbnKvEcNcNporV1M2EgiRlDqOrntD+QQ0G430akWi3
	cHAEw2AYf81hwXBioIStuWTGhk1rqWBKiEadZu1DN4sGafobMxC2yUEOLJ7Pn8MnqR8PKbHDxrs
	MDAmLw=
X-Received: by 2002:a17:90b:1a8f:b0:398:d2a0:87ff with SMTP id 98e67ed59e1d1-39b26101029mr40740639a91.1.1788849416965;
        Mon, 07 Sep 2026 23:36:56 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b4b72f62esm18814349a91.5.2026.09.07.23.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 23:36:56 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: lianux.mm@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [PATCH] mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation
Date: Tue,  8 Sep 2026 14:36:35 +0800
Message-ID: <20260908063635.2208922-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ph3w4pgsif6djsydshjnzadeaghohuk8
X-Rspamd-Queue-Id: C04391A0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788849418-800149
X-HE-Meta: U2FsdGVkX195nKULEuqruLnjrKrduebvPwUIO/QzYHIER6s0VIa0HQfx20tXYTT48H692uEDQDM+QdidaHMnRO0K2098Uj9f3SKpwlvn2S7DBkLiDngji+lgILBdzCGZhEmVLjREoTywrkmp7TVe4+XwM8aZbhnnSXVlocB3RH/+EngLAlFFIv7zmyqXT9m8CHqyBIGHXlXChdQOpbNjDQsFOMZE2wQwqHzM5J5RYzPfjixpWhB5ZMeADM/+AMO2gn1Rm460quq1x0A9SFrZZKbmkxBc5jubWndWJCEkr4EFcVheGbk4WdDNqq46scKiNXkx6gxcVuKOs7veaP7DKO7bo6nFJ4IXfwnMY/YoOOFXqQKZZqvAddxmyJiwAousQds+Op0Eja6En3XLlod0iofmVpsHUI72sLaueCWcbEirvHKBcStTmhJemQVBzH6HYEioFYFdhg2rTgSuTnaSReNRr5izMOlPiAsLOr3Tk6NVb7QTyUkuVllKZadaHSuGfDESHF6vE2ONpbVEplMseZIlNoMZ2sZvILeSj4VocWFP02hS/ARgdwfo0oBsSY5k/cyGTNpbeLboi7v/UysitdUOdx1D79/0kEQUk+JYReJFKv3g81bZz7YeABHc+8UGcG8VE9BCJXfNcBOTjY3iJql/hVPYADHyXnGfI6JL8+fo79Dzf1a0UQ4z2CI/oLEQkcjNELFr8F50DQlPwwcfqE8OHTbjxKdvt3JLZTiIw9omQs/dyIGAcjgutxdqV3UgoiYbDNUzASiSrSrxNsMNY7z7lITRNTA38FFEKWvk5QudEa433M5e0vuRb4mChb+4e/ozRcjscjG+oc46V3EyUFWKH0HvLoYbHTSrjr+x7X0Xr8SCQXir0V1UfKoUTauMAfM0myAmLZht3973MuBP4IFtgZJq7y1SbU2YSxir4jdJVzJOjn7zFVn5Ml+/jxdTLWUPEwmkv9wFv+ljrEs
 dcCuEnxd
 voP73FP6hv/c/OCWkxEiAQ1XT2qUrgPZVmdBrfRWarpNL0HienY6QIVupgAaqF7ZavrH3y45Hfb4idUtYdiZhxm5EbhZENAaC5bJZUWMZAC+3VfHeJQXcpP5M/WtuJc9UOMOl9xSjUNSV7CXQKAqoi1c+C+9UTtGSRc194qD1do7tfGyoALpFM0KFC7PnXXn38/zuwOisNjslLXfrb5eSR85WZxr7G3twHxHamiqFVbKgNpNV6N5Dom2XwLZC3AzKQUGRXBdvczOWPOR8mqQgXV8yx3y+8fq6G3mlgIg+ab0w6QeW6hD7n44rY5akx5IC/ZgEnNCHA+6ecUMutR5dmm/O5G5GsJVFzugiF6LYTMsmadRnXpwUuKhr4qB9x/gpTGvKrOunnIIMUsTGRo/4dgbWukxl9aD8lsvO3niG8oaB2kcedrv4ExfhbIHZ0lDlx4LCzpjzAsMKlN7DN8K8OSeDy0pyjozXWi+dlckwbXDgYM3nQWyjZXy60Tzf5vh4wrA9lDrHaOoYDEx4pEHDXJ90+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The damon_nr_samples_per_aggr() test sets both intervals to zero,
which exercises two different fallback paths at once.

Use separate compound initializers for each case so that each case
tests one fallback path independently. Also make the overflow case
use an explicit non-zero sample interval so that it does not depend
on the zero sample interval fallback.

Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/damon/tests/core-kunit.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index c01e6a75cad..ff23208c181 100644
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
+	/* Zero samples per aggregation is treated as one. */
+	attrs = (struct damon_attrs){
+		.sample_interval = 5000,
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


