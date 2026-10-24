Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C4C606A333
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z3YoQoQ4
Received: by kanga.kvack.org (Postfix)
	id 69E776B05B6; Sat, 24 Oct 2026 15:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636C26B05B4; Sat, 24 Oct 2026 15:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF1B6B05B7; Sat, 24 Oct 2026 15:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0728E6B05B4
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:34:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64BC6A04AF
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:34:02 +0000 (UTC)
X-FDA: 85358520324.06.52D8D73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B4799180004
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:34:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z3YoQoQ4;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792870440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nr+YoPGEHm8Q3JHJ6w69GvnBfQfVrjXNL0RTKjfdlF8=;
	b=pgrzofdZenRf0ONgB/6j7r4YLiBHfJSEdpYqxLtuvEfFRNVwCYQqU8nHYyCMXTfm+vTrTd
	/cFGAkHeNy5mFdpQONQeelNNok4miAczN/03psfF5HsWpPifkHLoUux97STk/MglfbSci9
	wJZ0q2+eBemr9SXxeu4b4l7MVZWt2rI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z3YoQoQ4;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792870440;
	b=8jEiiSxZTKgdM+FoXi4cqDa9w+u0TAFEcTCN1nvcIyV+mfk5Om2EThZxw/OLHuZk6Y51KO
	C2C/9BZplsSLxU+zQgkbme/Ke7IoHAHnDeA99h+HEgg7xSr62ojxWzDDC+gsE0SkOTw9pi
	wDfwBqGH2Qz9jCkGKNvWy3yl1WJqpso=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7EC740BBA;
	Sat, 24 Oct 2026 19:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FF41F031E0;
	Sat, 24 Oct 2026 19:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792870439;
	bh=nr+YoPGEHm8Q3JHJ6w69GvnBfQfVrjXNL0RTKjfdlF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3YoQoQ4gmS+/Aqq6qA74DhONxs0aqE+nSetz3bItoE39Xl1wFZRg+MRMfRW3rpBb
	 yRt5bxQPXRDXxbcR0zI7yUXJjsloteIoXQ2FNPvzM1pt+RK6RmqW/8VXOHILg2HaIM
	 syO40anvzZUAdaatr65SVify8Cb5rrzEQTy+LOJS2hXPgbadfM3srNGegGRAg8rErW
	 wnIYaAIaO9krKJlUwlEzlmIYKjano43sBfeBrVOFakXc9mGahe7TZRrFQc/7OnZY64
	 LRMyv/TWpmRDN8fsKyhiCaqru1n/OrhQzwOZsHWsIe56Kq78osz9LwLfAAkP3P7Psg
	 J4sqJ+Ks9ucIg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/3] mm/damon/core: move static variable last_nr_regions to damon_ctx
Date: Sat, 24 Oct 2026 12:33:48 -0700
Message-ID: <20261024193351.87130-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261024193351.87130-1-sj@kernel.org>
References: <20261024193351.87130-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4799180004
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jrdnpidaxq6uyt98c5nnxfk5ei7p696c
X-HE-Tag: 1792870440-503893
X-HE-Meta: U2FsdGVkX1/I6ZhYg4Sd4mTctpO+f0QWxjSHHwqGNF7YxLgo4Qfs9ACZ7wRdpjwsgBR55tM/ud4PTEped23iJPJN+q2RUzvL8Xa0FrA9GFibBjUdz104znqFYA10bKhhJbq14+i7irpbZMly556aiZCf6l9x3Yc22XqlFRQLd5G10vxHdiFtpg+fwcFg1LYLUBsMzk1b6Csoi8h0V5IPj4wYvTCmox0xaf7ZEXM9qiEfFmXYiwUrfF//R1GC+wI1ZgbChSu7+lTIrHIA4HAC51Rvv21WiHCsP4SN+RiyDAdXA1TO3srAKgRwjfo1K4phoXKlW0kknW79Q0dFg5dKF1q9nks6KtagWmiSETTOnWHiMTKRa+sYqeYB1eh/S5MMR1OrKIIlFlrZpXfoajSDIJ8n4eOJp9qzKusK5231Z7fTJlkLHf1JYMJ7VtRS7qPijKwENUfeQSL/IKema7aMDj9UthqXJkxDT4POgEXP8VVD/6jTPigJaOWWWxwsTNvuwtpfVljC+LTBeRdY0Lda+p9TmX3d5oC0PKiU19g7fyts2UflaIgz3iW8cgBVc7af2zYFq7n7ge320/AxkBL/7mhYcAUKpQG0yvfx825NwJM1v7JXMsAGYC7BAlYqf8HB8LTX4Pdb+jSkpVFUcch5lBCuBukqshq/F5wGqXkVi/S5EjPGTCxxJx62q9wGu7dstj/hSSEvHI3nnzP7BE2ZCygK6KIttQumiDTGdRtHd4wDIRrHud87yIieCKbvAwDIyWJb3OdkMYbA/o7NvGaWv/tsR7zHcwMQj1NmkqC1FZkz72mfk4yskGaFrRxfCa2Z8vdtmGWL3TR8eYIhix3bU7kXstot3UpszQBEHczcpO8lmoRJ5jhEYg0//7JCmaoJ5hwwKokrGeXLzSLaGAe9Pbxg5Q4RI4ivFgLDpeXykuBRpNwJye5Xa6TCgwdmrcbj4IKneZP5u+UJdiKql0o
 SpRDRwi1
 gV+Jl7PfDo9tMHWyjbGse24q6lsMqJWxFfXtfIbAqkFcevBlEN8kgsSD3CB/zjzc6HmcS2Oiryle9LS/VCrWZdt7MTKnbvXTZmwreXpsluwwzJuKlekhUjatFrCYRhPOkdZmzuq/a+YKH25uLCw4vH1BWkq/pX4haUjzcT3WVQ94lhvTQJqvzzoYA0hOgFeiF9JHrBm+85iq5f7EdGafkVQhIiLMJ8mBSh5OoidSnZ0d9twbI7z3JJVxaxRjQD9LSv66165GPK25+yXk7eBF1izCjzdp92FHyXwGq+M/1b/uUYr2ni4XADP/mP5ogHrrrOMTocJZdd0MmFe+XsXimXpAFtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kdamond_split_regions() uses a static variable last_nr_regions, to infer
if the region boundaries are too stable.  If it looks too stable, it
does a more aggressive region split because it might be a fake stability
coming from non-aggressive split.  Because the variable is static, the
inference can be racy and wrong when multiple kdamonds are running in
parallel.

The user impact is not critical.  No crash, no leak.  DAMON's
best-effort monitoring accuracy can be degraded when multiple kdamonds
are used in parallel and the workload has certain access patterns. Still
it is a bug that is better to fix.

Move the variable into the damon_ctx struct to fix the problem.

Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Cc: <stable@vger.kernel.org> # 5.15.x
Closes: https://sashiko.dev/#/bug/linux-eebfcdde-2881-48ef-8df1-e2019d2a47f2
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 5 +++++
 mm/damon/core.c       | 5 ++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 63050eb2206a0..cb6a50032a1eb 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -958,6 +958,11 @@ struct damon_ctx {
 
 	/* @rnd_state:	Per-ctx PRNG state for damon_rand(). */
 	struct rnd_state rnd_state;
+	/*
+	 * number of regions after last merge.  Read kdamond_split_regions()
+	 * for more details.
+	 */
+	unsigned long last_nr_regions;
 };
 
 /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index eb1fcdabc0075..09722257ce736 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3795,7 +3795,6 @@ static noinline_for_stack void kdamond_split_regions(struct damon_ctx *ctx)
 	struct damon_target *t;
 	unsigned long nr_regions = 0;
 	unsigned long max_nr_regions = ctx->attrs.max_nr_regions;
-	static unsigned long last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
@@ -3811,7 +3810,7 @@ static noinline_for_stack void kdamond_split_regions(struct damon_ctx *ctx)
 	}
 
 	/* Maybe the middle of the region has different access frequency */
-	if (last_nr_regions == nr_regions &&
+	if (ctx->last_nr_regions == nr_regions &&
 			nr_regions < max_nr_regions / 3)
 		nr_subregions = 3;
 
@@ -3820,7 +3819,7 @@ static noinline_for_stack void kdamond_split_regions(struct damon_ctx *ctx)
 				       ctx->min_region_sz);
 
 done:
-	last_nr_regions = nr_regions;
+	ctx->last_nr_regions = nr_regions;
 }
 
 /*
-- 
2.47.3

