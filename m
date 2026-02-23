Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 654D9EA4FB7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 12:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97FB6B008C; Mon, 23 Feb 2026 07:33:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B452F6B0092; Mon, 23 Feb 2026 07:33:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E2E6B0093; Mon, 23 Feb 2026 07:33:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 923E86B008C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:33:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5295614015C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:33:01 +0000 (UTC)
X-FDA: 84475660962.11.DFCB05F
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com [209.85.215.193])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C23820008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:32:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LpMgsz4f;
	spf=pass (imf03.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.215.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771849979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m9zxhRiY07QYTGDQv6Cv2204Go1scw2vYwkAtxLUmkI=;
	b=BjMAxWHjL1ZoLiXWGoDD9CniKmXOp2qwfaVA608QabzXdkN7AQeh5sDLBV1XT/kaJUVG4L
	/sB8X0DAiC0oVKnNC0thuYhhDnnb1Vt+OEeESKiGgf1Ir2jpj9F62kQ9ttocxn5MLlVxF3
	BJ7dSPp1rTaZynqooZL3VHxdRh9VZBE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771849979; a=rsa-sha256;
	cv=none;
	b=u/H6TNQgD25kL8DZekSHUTLeCNJUNOh4mEdwnqX3La9H8eT7veC6m+QhTjSQIuhVftXP6J
	s7ehpwErqGvWCgkEaFOeOIK1nTq23QKbjA7nNqzB8QbAESZ02talauNX0qnnL6s0t/thEE
	V+mpFfQqUTYV5YbfnIfnenbueHvfIqw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LpMgsz4f;
	spf=pass (imf03.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.215.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f193.google.com with SMTP id 41be03b00d2f7-c6dd5b01e14so1439141a12.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771849978; x=1772454778; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m9zxhRiY07QYTGDQv6Cv2204Go1scw2vYwkAtxLUmkI=;
        b=LpMgsz4fwH4zgacCwfRD/rKOlTihQVpl/J+BEpSKGe+8d7GB54XB55vhH6wTNzsjCu
         /G0a6Ez+3qeSnYoePr+mknaULzBa42Oorwj7HBXy+qY8lSU1cZP1v3wTomlBEzLGvFVL
         3J8unz1fRLVp/NHaER2CDkye38vwFzXFKjB6ItcJy7UCLnJqx0ciPxZT9g0zTFSKO3WS
         O/Ie8LOh3CAy17v/S8dhqCwpV+bqhzY7cCh+GEJRiFBNTL5PBWLuW6PedoQYPONWisQk
         zhlcZvIJ1sVYC2YNXc20JFtGEsgu/P1tzIaIhEXeZn78hmDmMHLJExQnp2TF2M8fILn4
         meYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771849978; x=1772454778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m9zxhRiY07QYTGDQv6Cv2204Go1scw2vYwkAtxLUmkI=;
        b=f3DhducgClA0oBXtjpQJH4Z2q6IYEqsOTMs94wsuwyNr5XXv8H5Day8eKsGG1QwxpT
         9E+4x0EEecNcszekz8iNvU6FrAa3KViR3jKCBhr4LRQj+hGCAWSWFcEYHMXZDj/5M77a
         DzHCSBGPFWarHp53ApofvAOsECsZvCIxzXnqhRZ4bE22NoyHsjLnhQpgv2NPuGut2H1z
         S2H8B50OqQPhc2fJySyGY4+5M9/hUqchLId2wGTrv12pnwiwe4ueg9ii8BkqDhuNKBZg
         MwkpdZyOpiY0wDI92SbHkgTZDy4386ifzgY4D0KrycNP8FKbMH9IXzKbwaOvPKPjiu97
         +JbA==
X-Forwarded-Encrypted: i=1; AJvYcCXI6skRXrcSdx1uN1F8Ks2Sec3KaCno1vs53UyKLyHYgmtG6otuhdE/CBQO3B3hOqAh9yeBLDo0VQ==@kvack.org
X-Gm-Message-State: AOJu0YyNGpXRqxT6CM6+dfxFvqwDKxvO3kbtmR+rAni6iNhNGhubHdrr
	nq5sJNqX8ZCOJWK7bmenEwNHLUneSPtbYCYprBVbb0qt9GCciu5x5Ng=
X-Gm-Gg: AZuq6aKDhpXhztUm7DiUQQep4TWaCx9AQeeCWnnWqKkrDfgAeDDSCHLPY4ABwP5qZZT
	ybbOmPYxfENzOUJ4Y8INNDqA4WsijpByf9orydGQTQuW/Zz3gHW88G8YQU7fuSQmiIOaonJ2EER
	oLjqekVOjAW0mPdvBJh8z6FDg5ydv8vHTkrrMYxN6o0skc9D1ETpz4LP104IsCm2wedG318+Bjm
	1liDPM0PgNUVmNUBb0hgLokrhSh1zt80UHu71FrRlUZvXnW6HtEqmqOyCfi+aaRWpHmxupmFh8K
	SzFr0Q+FrFAvyurindINeanINKLIWdtRysVypGPT8sxlBguy4s3tAcztVOa191xlfBG5JMjYqSP
	WK+F52EIyXYF7g4bQq9DFYm+eFNmjxzhQKOhdrfjN1SJCdTTWEWwBKCQglLkVNsSYrRai5U9npb
	gxF9iYkj4UBFXxQsqlf36twyYChaW/jiNr4SE+GmjwTj/I
X-Received: by 2002:a05:6a20:439e:b0:394:6023:a0fd with SMTP id adf61e73a8af0-39545ed05cfmr7352911637.29.1771849978382;
        Mon, 23 Feb 2026 04:32:58 -0800 (PST)
Received: from LAPTOP-FDBL0TVI.localdomain ([49.37.157.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70b71a73e1sm7454739a12.13.2026.02.23.04.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 04:32:57 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [RFC PATCH v3 2/4] mm/damon: fix esz=0 quota bypass allowing unlimited migration
Date: Mon, 23 Feb 2026 12:32:30 +0000
Message-ID: <20260223123232.12851-3-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260223123232.12851-1-ravis.opensrc@gmail.com>
References: <20260223123232.12851-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8C23820008
X-Stat-Signature: 59o7uqsd5ngapp96skxzszhy39rzc6w7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771849979-835420
X-HE-Meta: U2FsdGVkX1+njJ5WNdJ4AK0DsyBcKKlZ9naeSRwwfdMMNcaFhAkfggqUZWIlE8CVZED78dFDcWwxyl6UbuDqlDz228lySuXp1Dhl4VIQYeQ0W5lOLDIym//xjpjT9yVLsDvXE+IVa3T/sB3YjPMbpya0MjuDYCdwy/fqSuihg7bzuk4O3CbTjyNl7sg1qXEafnCL+1yvgLeY7UrTys8nrb8Ps1YBicDurMbx/lKV2vxB3K+T4DTfMMOnFdOmQBrHub4i8SEiXWBd0C+VQJDIE7PZuRiU6CJ6w7Rt5C57OIH2+0BBSP2HTk9ak28a8zFAF8046tx6fLMqp+Etv8RgvjRfH6iDm1DRkizJuDmbsYrHaFRt1MaOFlc9IYmy5HyNd1wvnYpBeq15ovYqVymLWKIzhQDstWcpobpjt8FwVKE/LjDsWolPV0sEk4lmfJ8mH0GeAbCcE9N/lfE7gFyoubVDeEgwwmoc4ijd6W994qpBA/Zty9ocxmgOXgFYgvRyaXNFJ+NZuYH1ZDIaTl9Whh2hNQ4xSy86VmylR3mkU1mStCGlSOvFQy7NLyOB7/JOXkZNhldHCa5TLufDCQeLAN5tdVyuygPymDT4yJ4NulQ2KybgCexkSoVFXe8mCYjVOJXpX/CqIDI1zQoyB3eiMV3N1W5KLhUopVZIFxHADnFbJfCYhUklyK1ezaGiKfjzJ9W2+6QjAg06l8Q9Bh15dz/OPH5y2gbn0NoKKFUM+RC2eWyU2XNdwrGBuZeT1bjG5NRHnzPiRH1G8zezsoBu1gN8eLHaNH3Xx3tyYpvPzezfggAwFczUyIXYtJGKEw2CXlXeKrl0p6VWwXar4PFbKYsScuzoJTml/JW7HOQucdi0oZp0gD0dioXygs0GwQfpUUpyilrDMvZnA8ogjKWwhwvFIJ5onu9Bqda7DNoFN14nR0JopBCdVw4id+ikMuNfhLJtdc1ABkDburdZ7J5
 uRDfkQVv
 dhJZjzGgHIFirG1C4hnaqcla7bRh5WP9EZKJGub+d0ZLxeEnaolbZbknKC7ePJYBk9hrKq/eNaX8L/no3ocejYWYxO9uLNj2K0pOfTv+FT40aEpEP9Z1FRBw6PmNuG0YjRbFV9D0CXNZVoxY7oV7IsWxoM/y116PEh+AAlOFVA09NBb+ZM3lOtHAgXGM5ThTs034OU0zcS/NBX8cKPh8fqXqw7KBA29s+AIauyxJlDCOmgXdggsZL9qD7yPI2JSnPMqkA03KuHDhaQaG8Xor2kPJkG44TDcMaZb2OUtrQrcZ4KCAEjjR/6/W7r6PUcYdJ4fSJVFCocig/R2Af+IB81sdiDtskYbME++gt6KfnlZt8PQiNqv52KPk3PlqPhjXMQXTxIi2Cd/qsLGAvy1jCanZ7c5c9TJt1ik2UN0b/QDOYdC+hgcOwbfvuLcdZgDiNpIFaz4ZHndFKjLiJhO6c+weR37GOmDiSIZPKCVzBe4eyXy9HhqLyOyQJzd8AEnDBHyiIzG52+WQ9DBk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000011, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the TEMPORAL goal tuner sets esz_bp=0 to signal that a goal has
been achieved, the quota check was not actually stopping migration.

The condition:
    if (quota->esz && quota->charged_sz >= quota->esz)

When esz=0, this evaluates to (false && ...) = false, so the continue
is never executed and migration proceeds without limit.

Change the logic to:
    if (!quota->esz || quota->charged_sz >= quota->esz)

Now when esz=0, (!0 = true) causes the continue to execute, properly
stopping migration when the goal is achieved.

This is critical for the TEMPORAL tuner to work correctly - without
this fix, setting esz=0 has no effect and migration continues until
all hot memory is moved, overshooting the target goal.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 614f1f08eee9..b438355ab54a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2394,8 +2394,8 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (!s->wmarks.activated)
 			continue;
 
-		/* Check the quota */
-		if (quota->esz && quota->charged_sz >= quota->esz)
+		/* Check the quota: skip if esz=0 (goal achieved) or exhausted */
+		if (!quota->esz || quota->charged_sz >= quota->esz)
 			continue;
 
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
-- 
2.43.0


