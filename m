Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77097606A322
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iD8B2bWH
Received: by kanga.kvack.org (Postfix)
	id 644E86B05B7; Sun, 25 Oct 2026 12:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6426B05B8; Sun, 25 Oct 2026 12:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509A66B05B9; Sun, 25 Oct 2026 12:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8C16B05B7
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 12:48:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF682140569
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:48:24 +0000 (UTC)
X-FDA: 85361731728.20.CCA57B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 39A6080004
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 16:48:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iD8B2bWH;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792946903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjEsKHyDFKj7HHX5WZLrUS4CLP7wbTWvbErAlhp6Z7k=;
	b=DTtwwkeRzflo5UdAxGZ+/DuCv5uTbc0KdgYeQla3Y8KKpLfQA6iExsEyXnLITqoRoTo/8B
	fA+YGR+xCuRpi5aBLg8VU+8VunKHEr8hpK88HByVWs4pwLkU32xWn0P9XgWGtDtJhsy/7/
	5cmeKmYjHLmAI3w3t8tAJIpQraOUZao=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iD8B2bWH;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792946903;
	b=nsCDtu2/qKM+Isb3ejICiWYaLc/KccoBXUiNkC82M+hew1SHrGDM38MZlf6/gM4gNNzXay
	cb/tZUXCw2D+ZajmpUQJwwfyu+KrNOAG4a6TZ75Rwlgun1pkyQfaXom3rdw+odpB7wPXr1
	+beVRS4oa+9pT0kScOeY3z53Fg5VDGU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93C1443E8A;
	Sun, 25 Oct 2026 16:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14711F01829;
	Sun, 25 Oct 2026 16:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792946902;
	bh=HjEsKHyDFKj7HHX5WZLrUS4CLP7wbTWvbErAlhp6Z7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iD8B2bWHqgzjI/FQKlqUb/8hW2GaTV5hN/GUwnLZ3KLp1erPD0njJHPkCkyN297ny
	 zW2XJC+SMYZO2ojUSZ6bCd1dToZAJ0EpeuAECGZVh5jgaAt/XkfseZtVkpZ/w7hdPc
	 PCJWnva3sBiqz2Unh2MVFhliRQ8r+T/14pScXimM7+yq7L1gYHuAhknT07LrmUl5pe
	 0LSfP98oYntPL0DoZM5Vy0jZALZGdjOphx51lhSGHMoq3dGQH7nFmfdO9nGGmDmaFa
	 jyc14QAtpnPF24hh2R8nbM2kFxdMxE/DyIH5x8Jcv9m1ucgXN/IeCLec4M/FevsF1b
	 vuA7SPvhkOgrw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] mm/damon/core: move static variable rotation to damon_ctx
Date: Sun, 25 Oct 2026 09:48:06 -0700
Message-ID: <20261025164808.152048-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025164808.152048-1-sj@kernel.org>
References: <20261025164808.152048-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 39A6080004
X-Stat-Signature: 3isttseecyt3hko8zm9r1e1yjcbyy6ay
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792946903-115256
X-HE-Meta: U2FsdGVkX18HIbSRA0bx5w4M3uSSThdoshFxNNNeCG5/orQJEFfiPjjEr+UrxjSVkjGHCljX4vVxrpqlTOM+UP+e3gASybWii7soubHK6oEbKZhXK4HPqxHpKa9apIhYB2N9NoN6oQffSsqj9uZK8yjOB4aYul66xSpFoZpjYqfTq/LI056CmvuCmY+D0JM7kDwfkv8ipK6kp47hg3jABvNqYfRaqqaI8p+DC85fP0Ji/LLfcSUxYesG+k5YtGMAdU2pXVMtXUg1JjkwGJTT7Q/8I14jB16YIKcfp1h3Knw2vxbZ2lBpBSOE9DewGjbQ1oIjqU6o5KrJni+JH7xS3f/nm2bGxWQ1r5vF6wE5msyIg2wW4/XAMWAyzMm4a7SSL42r43Kbe0jjFo/ymUOroR46sSTZ5Wn7w6Fps3oIVSxUoOKfF4RHTaTgFFBd1We/+Tx8hhvrQd3vIT5Oc/RW5GfL+WXMh8g5/9+uzExCgsYOpxrHWVthRBY/PT7ULi75BD2HBstEgxp63r+kU8ico5ZUFJyHDrALjTuKIG4ppOB+8Y7UlSETUY8/L+OwH6+v2XioUNwRlAd1hfVy/T4eRaYzKCW8cWAM1H9zBxiSiVV6ZeonX/g2oUV0NxOqMjgiUWemfl/1YrGaFOSTVOsZpMHQqpSuMEsZQr9lq4YcvisIJIQ64y0HRxiZeLghnAEf39AlBJj8/KPTvPZGah5e9MpbM43XwTaxAyuX162aKgr6wl1y2XtxKyt+/y6gcc7vwZVCpn8xYlZh0R7NcsRVJa7uBD6gR53Y9EE8gk+PadpBM35WFKQ7P0uc+l2jSqrXUNNhOK6O+mG3hCyChWfcsLrJAGtK/gQ3uUKZNuQ8Wns0R9MvFDKphuAeYa/3fooeztam+YI89gKe1rAhAdx06t9c/cii+GSOF+mH+bDhkOBSsLBDVGQquvtOj1DJ9u0HGjvYmtO4P8v0h5VCExr
 ICsqF6R5
 sYB5qYmzF33xYMcg1lWTyHBO7B9cl+uH6OgwadiKNSIbkvBPjxN4ajgbsXwk3m1Wu7N2cJ1rJLmnVhWjDaXcazeUrpfpkw+ClWo8Tkkyv9a2GRi147LymmkGQsgi0gawcPmAEM7o1lFBAmDSaETlx5FeeSHOSwKAEVpQ1yzPoSZW4qnzzji0zDhX1ZyHmepSqReEpy1lx1iSjF4/E2rfyeu7Chii5nqYb25u+2HdnczAWbvNmwe1YSUmqK4EqCn3oJPKxzobTYPtjp1Pw7WRlP3bakekWLHbItTa5qZZsNTelczJImyaPDD/clEDro82BRrNuwYjG5bhFOp6JGxJHBt3AKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_split_some_reigons() uses a static variable, rotation, to remember
how many times it was called.  It is again used to determine fair
selection of regions to split.  Since it is a static variable, it can be
indeterministic and therefore less fair.

The user impact is not critical.  No crash, no leak.  DAMON's
best-effort and indeterministic monitoring accuracy could be slightly
more indeterministic when multiple kdamonds are used in parallel.

Fix the problem by moving the static variable into the damon_ctx struct.

Fixes: 1a582e6e0174 ("mm/damon/core: split a fraction of regions when nr_regions exceeds max/2")
Cc: <stable@vger.kernel.org> # 7.3.x
Closes: https://sashiko.dev/#/bug/linux-eebfcdde-2881-48ef-8df1-e2019d2a47f2
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 5 +++++
 mm/damon/core.c       | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index cb6a50032a1eb..380f9cf6ddd82 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -963,6 +963,11 @@ struct damon_ctx {
 	 * for more details.
 	 */
 	unsigned long last_nr_regions;
+	/*
+	 * number of damon_split_some_regions() invocations for this context.
+	 * Read damon_split_some_regions() for more details.
+	 */
+	unsigned long region_split_rotation;
 };
 
 /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 09722257ce736..73b571b429cb3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3753,12 +3753,13 @@ static void damon_split_regions_of(struct damon_ctx *ctx,
 static void damon_split_some_regions(struct damon_ctx *ctx,
 				     unsigned long split_step)
 {
-	static unsigned long rotation;
 	struct damon_target *t;
 	struct damon_region *r, *next;
-	unsigned long offset = rotation++ % split_step;
+	unsigned long offset;
 	unsigned long idx = 0;
 
+	offset = ctx->region_split_rotation++ % split_step;
+
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t) {
 			unsigned long sz_region, sz_sub;
-- 
2.47.3

