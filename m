Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F628606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I9XwZqXJ
Received: by kanga.kvack.org (Postfix)
	id CDA1C6B05B7; Thu, 26 Nov 2026 16:06:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0886B05B8; Thu, 26 Nov 2026 16:06:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA00E6B05B9; Thu, 26 Nov 2026 16:06:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47D4D6B05B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:06:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C44E7120107
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:06:33 +0000 (UTC)
X-FDA: 85478503866.28.BFBDD24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3607980007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:06:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9XwZqXJ;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795727192;
	b=TTVMDKcEwSv2rHATp/2CleyLw5yrbj/hoASt5ug6PzgJgXiyFYvoST/wlFuJG0/S17IMDK
	a4mlEYBKzn/P6x6PDUVnYTlBFYfzxaNDi9l+Nw5c6c0YEMd5UU3NalfrjB2SkBNpU9yeyS
	wDKgLTGZkoZJedEe5PVRU9DM7hkcAfg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795727192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1k7cS4T7fbvLQ9xtkf6Q3ovPqDp4JjE9Zd2xNYNrCk=;
	b=333vciSMYfsDdmalCxUDqyl8crcwcHKtHDbqlOGS8Qd8nw9tuOp1s4QKne8QiOkZm8oJsx
	cVtDG8m2REZiJGbjtvTbNOsp9kztXylGpIjBL10eE5hpAD00Kw7YmArv0vdyEUEVNjlgvD
	a1+qJWRdCzkwbwzo4qg015ZF1tRUKJE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I9XwZqXJ;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC5B960609;
	Thu, 26 Nov 2026 21:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BB81F0089A;
	Thu, 26 Nov 2026 21:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727191;
	bh=T1k7cS4T7fbvLQ9xtkf6Q3ovPqDp4JjE9Zd2xNYNrCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9XwZqXJB5scNSM1baoexzAyL2kRqrqyeYxgSzd3BnJD/TwHHykcdUGhHm6mPfabp
	 y2drQbZaEUvBLcQj43YpQS64o4k77UOjBEc8X0m0u2vhxa1K7XXkoT5F7fxyNRusJY
	 82bEwcLwly75YNd9YzvcOnEBmD1JEMDSbe6zSYX57dO5ed12EJaI4c7dRfbKT3e5Wh
	 FbneKWNbKYs6EZKlYzujpJvKlQP5TDnB8g8TzgmloZ7Y1GRuoI9XupOWKC5tpj7Nz8
	 cB5OtaH4WCRQQyeJ8asN2i+2Wk6bocTWJbTo0q9viK+mP/HzVJTTASLma3ixZq10wV
	 EdQTKBR6IZMlA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/4] mm/damon/sysfs: remove damon_sysfs_cmd_strs
Date: Thu, 26 Nov 2026 13:06:17 -0800
Message-ID: <20261126210619.97634-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126210619.97634-1-sj@kernel.org>
References: <20261126210619.97634-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3607980007
X-Stat-Signature: udzj6bcpz4c7s4jzy7zqf4ocqn4f5bxu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795727192-261982
X-HE-Meta: U2FsdGVkX1/CEElrxuzvFIYvhyHmmaWrJHqVg5LdqAT++oP1tk6NA+Vsu8GrUjSyLXlwmv9x60Ys+MMcYV3eiw3X1TBaQ1EDt3J6C7tVDK4ynog8ewW1ZyB4sBdLU1QWA/6Jkd9N33ggPts6huDYpReynf4/vwxThEUOo3GGlv/9jj21/qhQWqgHEHOefP53fd2Bzsk/hE/YzzGR3NrFashZV5+pMsl8wIHpUBGtTeKTLz1W34ZcjW6Dpw7+GZEXdqbzPrzypyBGu4etRRwSvSz7ye3YvfoJ1lQjX29XGZKjrs9Y8Mf3p55Iu3fXz9DuvITbIwnlks2bpN7WIWLl5BcdYMvNHGGaj/i+hpoHEf1Y0sBEZQ9DRj7RrdGaET7Zg9SJ03rDOh8GXPTFP2bJmvLYiJ24JJpzOZlo1RQ6IyEfJnEHDQYT/kWrzVk564lWRvIF+m8bC6GJNHK4gdE+WY3HAeVFd3kghoIoXwy36pcx9XSxKsCYthBJpYmabwZSSAwErkEJcdPFK3aw7nCnm/dTC7Z4Bem32GLwrL+Yf8JFopOWR9zC5Z5QaCBKzRbZBZQgzlxpLhy1MQXaEXKGp2F0I+Y33ej1u+tbAKgvdp2vho6j3GFOkV25dVxQQY9hFrnIM14rL6s9zI0E5+mOxiQ3NouwZF3yNt3Z0BSwNQbAJVv1a8zykQkMsKFu0RCOFmcPT0fvn4OuNki4Xm/QUSr8bitEsq5gCdiddQWX/51jwGHPiqVE3S3Zf2sJLDuWFzd8itIo8XuJMp26hn3014fp+8QlF2GJ9bcCwCoeV0WdKjkSxSakGXLdQUS90Xdg3Miau3HJdGKf+mu7GoqQ5ZEleh0epnKNHZZa541hLlE4PbUfHVL12MPjcbPKspn1zcFwB0ulvfnKg4rXYunv2zujioz6DuVRIhrWmACu+ZBDpzJagVx5qhQ1zW0IVcT/svBpIs3I7D8Cqo7hbjH
 u5DsZKsh
 2Dniqa0pEbK+6prLRU32ZOHF0MsYK/RysVj7iP15h76UPeSaNq0MswLhUh5MQriTDsAF5wMPihrQ1pe2ujApWa8LWf1l6gbduVqQATTLUTiqi6/43MwJW+VR8Zj3mfNcez0IAfgZKt3aZJYqH7VdMTnrtrnzQDkUDxp7NnY+JOt+t8psheIycVjWLJO3BWEU/Ss/dhsEaSF8RShjoKYuneSuhDfLzHFBa/53lYD3qxU/fROC3wXzZkbQVJdEwiRRoH1QP2gNDGkPGEb/JUomKO45iIqsF0aj0yOVCQPoeD/+BQoxr61lWEt4PFHWRmmwHOIrnG75WVbjEGGB6Bcs8JIAg5b3fjvczfptBTYA76TSkl2Vs5jsTWvgbVupggATmo9h7NDAsa91zsfXSnMTLr6+pYzdawljC4t8Vm32SMwSTRyIR4Huv6LDoRRyIWE97Shu51rZHy5vocilp1DfpFvFKPf76hYud803wNLhEZFUBrAwRbu9f91/uNfQ04LBF6nRZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Remove damon_sysfs_cmd_strs, which is not really being used.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5a91a1c3e4389..3e41e030ae731 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2240,20 +2240,6 @@ enum damon_sysfs_cmd {
 	NR_DAMON_SYSFS_CMDS,
 };
 
-/* Should match with enum damon_sysfs_cmd */
-static const char * const damon_sysfs_cmd_strs[] = {
-	"on",
-	"off",
-	"commit",
-	"commit_schemes_quota_goals",
-	"update_schemes_stats",
-	"update_schemes_tried_bytes",
-	"update_schemes_tried_regions",
-	"clear_schemes_tried_regions",
-	"update_schemes_effective_quotas",
-	"update_tuned_intervals",
-};
-
 struct damon_sysfs_cmd_name {
 	enum damon_sysfs_cmd cmd;
 	char *name;
-- 
2.47.3

