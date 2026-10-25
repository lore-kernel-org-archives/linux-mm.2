Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23168606A323
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 16:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ij1vhXas
Received: by kanga.kvack.org (Postfix)
	id 1B1676B05B5; Sun, 25 Oct 2026 12:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1623C6B05B6; Sun, 25 Oct 2026 12:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051CA6B05B7; Sun, 25 Oct 2026 12:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0C506B05B5
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 12:48:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9316BC058F
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:48:23 +0000 (UTC)
X-FDA: 85361731686.22.C2B86C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 00EDB40009
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:48:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ij1vhXas;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792946902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nr+YoPGEHm8Q3JHJ6w69GvnBfQfVrjXNL0RTKjfdlF8=;
	b=h6C9biWnP9vweQV0s7ERy2Zx6trqJJPWpKrN6m9C4hJY0t9VFSS0m7Y1l8yC0ak2jLFD0K
	5mc9i1A7pUxcUimaiHoESly+mXlumAChmbaxQdHKpG/NJWlvSy3jB8HsziLBrcNa3GE8/Y
	ADTtTHhfOc5lxnZorst0zEYYuzxDSQk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ij1vhXas;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792946902;
	b=Kg007mPZJ192xHYbGjZrAdABtTS+tNaH2Oq6afl9RZqYOjqUmDcDQJMulPGqNdj3OWokLZ
	ngQ8JRZamE1A6QwgEWUxQL3YBA3QhLBxvOq/wEtsdotAerUOcFnFLia5tBE+OH1hFEup7w
	hGgeDrN20iQiNCpC0YQ8gDakFwXXTnY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 597DC41191;
	Sun, 25 Oct 2026 16:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30A31F031E0;
	Sun, 25 Oct 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792946901;
	bh=nr+YoPGEHm8Q3JHJ6w69GvnBfQfVrjXNL0RTKjfdlF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ij1vhXasNxw5M3NroJhpbMcVS7tHPfS6CrxKjKAo4XXYhO7PkpF2dmMn0QDbVWBZ7
	 uHUszc3RYcsfQtZGco6SJ9gr93j9Ca4ktIDU9y5OeRyQQUWlVJ3uTTuKWFbMsejqsW
	 XWIbH72CDPWzKvy9woIo4kb1zxavklgubYljz/VvJ0ckxOuNnl2+UFNFBzMQtreqpK
	 kqStRonGrVO1PDERbzM4cLLs2jsKnHNl77X4gW6zXYO7CPlEUs+2HJnIrqp2svKG7Q
	 F3DAULHZlQguqaqijUKSh4cZVFtpUl0v2eDVKlyvmMBn6OH9hb80dEFKeijKiIWyyx
	 VKJSly+gW2KGA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Fernand Sieber <sieberf@amazon.com>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] mm/damon/core: move static variable last_nr_regions to damon_ctx
Date: Sun, 25 Oct 2026 09:48:05 -0700
Message-ID: <20261025164808.152048-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025164808.152048-1-sj@kernel.org>
References: <20261025164808.152048-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 00EDB40009
X-Stat-Signature: mtzoonp49n4mgkgzjkgjxsph8yjydc1k
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	T_SPF_TEMPERROR,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792946901-432969
X-HE-Meta: U2FsdGVkX1++6x8R7j5KQ5X+CvjYFaNb6osqi6+FBLclI3QpVRELCHCvX8Tc6gWbgr37ZBEfiiM42UXkM9DiKCyZbiPmIol0Zj6rISBPjtpJv5+bWirub1F5tlVmEyZXXR2QYai5i/fSudbd2o/Mf6iIy2ccTU5BzEonb738sAehD71NQ7fpoi3u2DQLJg8XWJUG7i5iH4OTzD5EXSC1a7ZGq5FByVj8fDeCgbtueCI0kdk7JMJkpewdtFncijQAR0B/n7OjYIP/ujGbrPKaKo6zeihMjiqc3yTQzlngam1lbj5Mixx+brb5dvng18kiQsg0vqV5mLQJ9eV/KBQUgwoPXeIJrq7UIR9ax83JgSNdpMTjXXzAh/0EbWrYl2hMhh2ezHpUdytOEEeIupIveQoFiWYRm5rKVb56pwZLuS5gfhUftLZYs0M40Anqd5SFyHbnvaBqdgjAgX6SfAREtYDUX7ANigiMd2tT9pUjJCmYbLq+3Wv+xOOvp0D2wMhVhwa5g573p4G+JcfCSb6BOoIsXqT5dmAUume4NzrV0YSE35o81cIroqYPNiu38kzewmHOoCdIK2DCFRDV0RKOQRl63KCXDl5mP5g7eNkwapxPkZi5Un2/p6eJGRwKu9F32Etk0ayta8rDSNNnt1MEQdDz5bMLxeVPpreJ2aVRt8dXA8q1xWK+I6wRNKi1mEzwneHk3TuWjOZP2WumlFf3P2kkg7QB9RSt2Vm4LqV2gM9e/GW0vdP4eLB3JH2qGe0aU4tJ6ss5rJSgU4wLIXLWZRAmEpw9fV7xxfBd2/I1n4R5y5h55lhv69WedNoMAODfsE0xMFLHMcGiKN3FpHoG7YucTNbsAtHnE3TPQPwEQshLn5+CuDd/RsbhBw09CrAm5DCYsVCCrMcnVCVFc9tAv1wJGUcK4Y8qKEzUEfBi7qbzT0EPQecMrdk28DTloIl/ZUUkuMit0p6/5XK1uWi
 xOppYkeq
 C72m7SYlc33FYf+9sM9TK03FINdwjDOaQq3mBb//kFcuxQvj+pyU7uqupjYi8VwTwA14ZuEtKP4k7ad1Vgi0jskZzt2WOgolWZg8FC5j4yK+twmIppQTPni+Xln+eu+4M9FlnJyvzrsuhnjK5q7w141vu4jmz9pSZXh1rpOB8Y1JrsRXwWQvrRISF9WHLgqaxG3sJst8l2xX4pFr3081FpxrI0HQp6WlM7Csbp4guMRIKARGqRGVPnfa6aZR/nUBcrnuENGLkwo3A27X1sVG7ljqvGlf0Qp6kRr+9nmZp50X81q/g16gj521ItyQZQtvasu2NSZe16tx6i9cGVahQ+S7HEg==
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

