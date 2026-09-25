Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 669E6C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 13:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7849C6B0095; Fri, 25 Sep 2026 09:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735F16B0096; Fri, 25 Sep 2026 09:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64AC36B0098; Fri, 25 Sep 2026 09:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40AFB6B0095
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:03:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C561EA0665
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:03:01 +0000 (UTC)
X-FDA: 85252299762.22.AEF0976
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 42DE01C0006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:03:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WNlscdXN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790341380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BSVHtbgr7nZGd5dozOxzx685KlCmq8P9tbgu4h3dnZU=;
	b=yGQWw+49UtA8idC1xgqkOuZyFhqOZRHL0fC7loIh1Ls447zhDE9rPGkaRSSzB+bkAFB9yi
	NtfdQA7FiYmAHlmXAcM1I9YWrbr/LnkJ0yH2lyTu3Xom3n0Y/J4ieKiB4L88Bal2UF0twZ
	RWJ3lax0fDjNFnZQ+ZApundlMOOb8v8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WNlscdXN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790341380;
	b=1RNH54Nan4P8eyBQA7T47aH5ofuiimYRxzvWYtHFUHAuo6H6FgSZkf6XTFhcFXJlW5GIrQ
	gYIwT313qRBtkYGdHWclc7IBoJ/K8TWoWWWw4StPq02x4042NNl6gijrVUkxsZHc/3OhBm
	wpX2EYlBsbBhD6mueA0ccJKragcvZo4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B67746022F;
	Fri, 25 Sep 2026 13:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2101F00898;
	Fri, 25 Sep 2026 13:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790341379;
	bh=BSVHtbgr7nZGd5dozOxzx685KlCmq8P9tbgu4h3dnZU=;
	h=From:To:Cc:Subject:Date;
	b=WNlscdXN90cGNUO5qLV+qUylIQXV1twQZcwaPEvgzo893O5zSrhulbVIZMPPD3tSc
	 CIE1Zo+FPehfA5Tz9xtSJibZ4mI27225gJrdT3ACPUOw4CB+eb5bVuf0Gsh/BKTbVT
	 0p22ZY1mRW6pROBFRQYRQ0YvgnLT+Tzv9OqMSvHOSM6+5UpG7kgICT1jt42opK5SB8
	 hCsYDjXM0k7isT/nMvumZP84dZe24nNRwy0nTcUCUBoiCPNW5AKIJ8pXMv46aqpHxk
	 o9BRP3KxWIl/cyCBa3kZTurtFeRUOtzJOkMq1UOb0CptJiBb4ujOI/ItL+mUzq5d7Z
	 DBy7OymJdGuZQ==
From: Arnd Bergmann <arnd@kernel.org>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH] damon: reduce stack usage further
Date: Fri, 25 Sep 2026 15:02:46 +0200
Message-ID: <20260925130254.4022227-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hor8ek4o7ao9hqerumsrqk4hj6jb31z9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42DE01C0006
X-HE-Tag: 1790341380-730143
X-HE-Meta: U2FsdGVkX19G6WtTuQmDivvTyAmdaOvfSZUOPPStRlPJan9n1VgU431q/ZI1FPJfo6vcSdqYIpsu/nCyeZksQlx32K+Ml/wT+qlgGsq+qa2WQ7oG8DUnNlGV6Wo2L2WxBD1ip8RdJdgANG1rhovTEZmzKf7des8Bq4CZrwJYqA6uMaDTXWtVw69sCC38gWsiV8YcbR+gKROxQ6Wu7etigaAAERPgjQnI/OLlwJ9piOe/RStXFA/vtCpExco6SQ5OfyuHWItaZjc98mAkaKIUO0Zk5j2Ud1Z1dDfgX2BjLtn91zn5/n365YmeNMT52ZI7CorI1xdJVyTNIqIrhu1Wo/84s12V/pKw0HS5/MHJ054qRioIkHgyWFdq5Y7IUXWs7K9cvT0oPq0vvK4ncOos2szjcRP2C+b+jcSgl/5BZxjW7MpaWjfK7DEKYbMYNZ1+hz/UHVNxOvyUNy7REGdHr1VuiaF9Y066gAlDgAzH/j+YvBKteQlFqmZIMdGgoIK1qBACN9LpiqXaFM6KHj8qv3nhqx54NwJVchigo2AUwHkivQgl3+8iDvogHg/8BgF5uHwq72AwZDtHeDwvQS/MpL0IWCRRf5ESJnpUy1/tdb08BrFu5pD3nRKaJg+/0UVZPeUhIVDH8Fh4xKOvBFAfvBRKKlR6CyaIAEAvvd5vP8hGyfIneu9Y85byHKyB7sc02ZW6N3iM5DcRAoujNlY2pUJu0TKJY449YZNBCuM89uFYKdcsK6i4MxT/A6uE3xB7FMhp/xDJPa308nIH0FRp9qe1g7V7PXRdkDL35ymU/XZhD+64Mszpf23IbpCZW1KULgUMBk4ZDqBUFulJbIrdMzH6PTssZ+seV0lWcBYRhZ7lDYdX1X+eaOCGsKmR05nPZXL7FwvJj6hFLomTrM48gCWELeRH9s2SgvXp41+py83gyUwc5TyMlYGP16TkitOeU7dunV8xDwb2SpT3cm4
 VkcKjzMO
 Pptq9ZXXZLEsIMltQYaoZCJatJRtcuGWKRkieo3ito1JPqfUchF4TwoQsMBMsqIS3VdgM+hEWqMZa1gSK4HqwYptaKTRTf1FRHRmE4gLmSKMJ8VLaOnp7NOfmk0xlWCWeBnA8IQXTq3iE8XMLcfJtd+KhXn9kB0yZi+OsjBtkLsOuVNz4ryMFYa3Wh3y7oOFBd8ZMpDCU5yyTxhLghQLpTlwd11upMj2Ak6HXBatpeEwomGX5MCFp3mdWqmFhNhU3bSd3inmE+MH4QmfuQ6LTL9pwcj6/kpal+0BI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

In a previous patch, I had annotated kdamond_tune_intervals() as
noinline_for_stack in order to not exceed the stack frame warning
limit. Unfortunately, my current linux-next randconfig builds show
a similar problem again with clang-21:

mm/damon/core.c:3953:12: error: stack frame size (1288) exceeds limit (1280) in 'kdamond_fn' [-Werror,-Wframe-larger-than]
 3953 | static int kdamond_fn(void *data)

Do the same thing with kdamond_apply_schemes(), kdamond_merge_regions(),
and kdamond_split_regions(), which also have individually large stacks.
This should work to keep the deepest total stack depth down much more
as well as avoid the warning.

I also tried to reduce the complexity of kdamond_fn() itself by splitting
out the while() loop into a separate function. While this arguably led
to slightly more readable code, it had no effect on the total stack
usage and just made the new function the largest stack user and had
a nonzero risk of me getting the conversion wrong.

Fixes: 5a00cae64de1 ("mm/damon/core: reduce kernel stack usage")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 mm/damon/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4687b909d42c..9803b459a0a4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3417,7 +3417,7 @@ static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
 	trace_call__damos_stat_after_apply_interval(cidx, sidx, &s->stat);
 }
 
-static void kdamond_apply_schemes(struct damon_ctx *c)
+static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
 	struct damos *s;
@@ -3573,8 +3573,9 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
  * while DAMON is running.  For such a case, repeat merging until the limit is
  * met while increasing @threshold up to possible maximum level.
  */
-static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
-				  unsigned long sz_limit)
+static noinline_for_stack void kdamond_merge_regions(struct damon_ctx *c,
+						     unsigned int threshold,
+						     unsigned long sz_limit)
 {
 	struct damon_target *t;
 	unsigned int nr_regions;
@@ -3718,7 +3719,7 @@ static void damon_split_some_regions(struct damon_ctx *ctx,
  * split was unnecessarily made, later 'kdamond_merge_regions()' will revert
  * it.
  */
-static void kdamond_split_regions(struct damon_ctx *ctx)
+static noinline_for_stack void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	unsigned long nr_regions = 0;
-- 
2.53.0


