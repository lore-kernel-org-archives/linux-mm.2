Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A48E4CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 04:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035636B0005; Thu,  4 Jun 2026 00:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28716B0088; Thu,  4 Jun 2026 00:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E650B6B008A; Thu,  4 Jun 2026 00:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4A936B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:24:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7976E4039C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:24:01 +0000 (UTC)
X-FDA: 84840937482.29.E1B0D23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E2E81180004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:23:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bUcq6X5F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780547039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/1RezQzgRSB7zj/4EhFJr37swnApDsHs6S9D9sB2K0A=;
	b=0uU7Km/HjRDclk2FNKgRITUDD6IE7vfai6D+K1lMzWRksBTOfATYxWk0NlKxji7pOPaI+3
	uZIxNjPL/dHWXYEmCCBcSgGw+CwIKLYW1A8gUcQxsMR1kRGZL9gnl7vRdz4sWUISJK/NRJ
	yq8yZhColb3wxnuzkMZ0HExalz6/mIg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bUcq6X5F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780547039;
	b=a33e3WOmW/w00TDG/fH5JFTqQfAoitth6Sqvj3BMAs3uRaPlpMTsM4IgvQqPwk+vtKJMSb
	QdujL0mVogVBf3EOUyRXqzv23E3EctKfXS9b4LaU6aUGJD02GZy6eaMz/di856Qv4ln6ct
	t8FPsRGEN2FIvL1fcrJaInnu516+ciU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49C30601DD;
	Thu,  4 Jun 2026 04:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2081F00893;
	Thu,  4 Jun 2026 04:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780547039;
	bh=/1RezQzgRSB7zj/4EhFJr37swnApDsHs6S9D9sB2K0A=;
	h=From:To:Cc:Subject:Date;
	b=bUcq6X5FM6uC+R2h/RF5skFbUugvDuep9NyDnDnFc9asmMR1PhAxHWsvdBxbgqMrS
	 5kOeWLC/TwIg1yUJ8L7LYRXPsCgdpCyrMf6Uj/xXFRxS6NQkwF1nUhxEPSJGd2/0U7
	 CmCPn8i8Dzu2yDfs/4bOVZio2zfsveljB2TCBm3aUBQSriC3Wj/aLIg/Zv34Q0XWXm
	 TjHA/EvZdFPix3mmijFcsZurLs4NdEM2iynTdpS8g8NWd9GjfNJQllD8UYEPNFI1fA
	 21tms+1YcitR1EH8gyVEvpl1u3qfjScEVJP+p1KaP6cxfnsMckQimblp74Te/0vC2S
	 dywA3GxaFPbRQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/core: always put commit-failed target's pids
Date: Wed,  3 Jun 2026 21:23:47 -0700
Message-ID: <20260604042349.67720-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E2E81180004
X-Stat-Signature: o3st8ykyt9r4dqx4r7qkg45ei3yj77d6
X-Rspam-User: 
X-HE-Tag: 1780547039-399599
X-HE-Meta: U2FsdGVkX19T1PDnCvdQxBsHkR2MMuixCs6YOn1v2zLJ3Jl4HyFq/CF1lktx8sdCVRGWos1Dcn3MzJOYkfHAg+YJkANq8FDthOIdgiu8latbtt/a7ZrVcZpkQh2eMUTwTU/R/FAtAZKqPWV+xlhXQvRwkFBh3W0xtMMVPK+oLoJ2o2lfUg7iSIDdxw7IFVKPS7EWmc1OfdgRe5qpEXqXBpr4O16Uz0w4sRxjfI3o8iLJejEwS4KdbZXf17aBBc6ncXD+9Yt3Y/8vHbD420DTjf3U1w0v9NjLkslHt1IHHHokvEx4cL5yJfDDkrFS3qva4m8Pj++P22QtQiRlWVtYXrFKvwsYbVp4fs3HZ0iBshnCUCb+Gfi/OoXfCFX2jtUNQfkSDW5b6gNwhtwvEdeNl8c7IL+2bzZnJZk+RJW6pE6ELu2Qjv2RCon/Kv7egd1HKyqxCZUWvkRF2v1zdgy2w6E3m/bNr0T7jHHX+W0zqIwaDHPvZmlHAI2SXkWps7U3sxGUA7Gi8pqGyFmlhfM/MzUSClwoSwO9PLzbZU2bRgZqayEYii7NwUQlIdu6DmCdY4GmGSLSc4XaD57a9qW3x1ycF3WChw2+WsKkW9TTQ3pdF098aA8Gz6VjZz8HbicxENvHRt+PXPO/daPdClg3I1Sso39yCkLLYMZXV2au1CEGSC9/X93qetXlqJG+ZNNmR6AkD4JEsHrry27dUCH4J+l15jhj3VyPl5/iD48KKZspkAVQJS+d5dNPRSvhGcPAZJs/DP8l3HdFtksniGbOLfd/txvRu8BKaDOV9IFp7J3GA7G1zRnK1S0SWqfb019eiYM69+dSAzskbapAfHbdVuwchVRXdRdJd6D8vVv+mlqyeOE6jRl6YFVz+lZI103l/jjJ+Gf1mfDmakZOCy1c2gVs6b1pXMI2/dbOj580oLhGNclbR2vPNdqXHNckMSUoGasfIlkpzAKxFj3qT32
 DUa/FMpV
 IScPcNW4GhLMq6AC1OI0A4LJUnk7ZS44hBGX1FJfnUNOl6/YQYZfZfTUvcB+28L4o6m/+7bOMhPIM1+b3nenGujn0Po+DAJ7UgezVK2KxYaudXdfHMBahIv9koJKI6/Uh1NmXiGmo2z3ee6ARQUV7pkDn5rEe8X+pR6EfL4IhZePBobj/OFaGo1QD2aI8YYLiBrxT7k+m9TEUu/O+ONQN4fjTbL5S2svcuukZkKNu6PHqVtA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_target() puts and gets the destination and the source
target pids.  It puts the destination target pid because it will be
overwritten by the source target pid.  It gets the source pid because
the caller is supposed to put the pid after the entire
damon_commit_ctx() is finished.  In more detail, the caller will call
damon_destroy_ctx() to destroy the entire source context.  And in this
case, vaddr operation set's cleanup_target() callback will put the pids.

damon_commit_target() can fail from damon_commit_target_regions().  In
the case, its direct caller, damon_commit_targets(), directly return
error to abort the entire commit.  Both source and destination contexts
are cleaned up using damon_destroy_ctx().  The source target pids are
completely put using the above explained routine.  The destination
target pids could be leaked if the source context was using vaddr while
the destination context was using paddr, though.

If the damon_commit_target() calls from damon_commit_targets() failed in
the middle of the targets list, the targets that successfully committed
already have the target pids that have the reference count incremented.
However the destination context is still using paddr ops.  So after
damon_commit_ctx() returns the error, the caller or the cleaner
(kdamond_fn()) will invoke damon_destroy_ctx(), but it doesn't put the
pids because paddr ops doesn't  have a cleanup_target() callback that
puts the pids.

As a result, in the scenario, the pids can be leaked.  The issue in the
real world should be not very common because it is difficult to imagine
common and realistic use cases that convert a DAMON context from the
paddr to vaddr mode.  Nonetheless, it is a supported DAMON control. And
the damon_commit_target() failure due to memory allocation is relatively
realistic if there are a huge number of target regions.

Fix by putting the already-committed reference count incremented pids in
the case of failure.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260320020056.835-1-sj@kernel.org

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 265d51ade25bf..b6e1ab1992030 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1387,6 +1387,31 @@ static int damon_commit_target(
 	return 0;
 }
 
+/*
+ * damon_commit_target_fail() - handle damon_commit_target() failure.
+ * @dst:	Commit destination context
+ * @failed:	Commit failed destination target
+ * @src:	Commit source context
+ *
+ * This function is called by damon_commit_targets() for dammon_commit_target()
+ * failure for immediate states cleanups.
+ */
+static void damon_commit_target_fail(struct damon_ctx *dst,
+		struct damon_target *failed, struct damon_ctx *src)
+{
+	struct damon_target *target;
+
+	if (!damon_target_has_pid(src))
+		return;
+	if (damon_target_has_pid(dst))
+		return;
+	damon_for_each_target(target, dst) {
+		if (target == failed)
+			return;
+		put_pid(target->pid);
+	}
+}
+
 static int damon_commit_targets(
 		struct damon_ctx *dst, struct damon_ctx *src)
 {
@@ -1404,8 +1429,10 @@ static int damon_commit_targets(
 					dst_target, damon_target_has_pid(dst),
 					src_target, damon_target_has_pid(src),
 					src->min_region_sz);
-			if (err)
+			if (err) {
+				damon_commit_target_fail(dst, dst_target, src);
 				return err;
+			}
 		} else {
 			struct damos *s;
 
@@ -1432,6 +1459,7 @@ static int damon_commit_targets(
 				src_target, damon_target_has_pid(src),
 				src->min_region_sz);
 		if (err) {
+			damon_commit_target_fail(dst, NULL, src);
 			damon_destroy_target(new_target, NULL);
 			return err;
 		}

base-commit: eeac72cb1b86b53f95c1596ec43db17827a8355e
-- 
2.47.3

