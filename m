Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 453E5CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6469C6B008C; Thu,  4 Jun 2026 10:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7856B0092; Thu,  4 Jun 2026 10:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DD36B0093; Thu,  4 Jun 2026 10:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE3F6B008C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:35:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED0271C0C83
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:35:31 +0000 (UTC)
X-FDA: 84842478462.25.682B2C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CEB47100010
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:35:22 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780583722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vgLl/p3qkGVQ4J0lmKFNqcECALdu6p7bDPIjji6x+rw=;
	b=fVu0yEGNiMf2kZ5umi0gvPxD9FAXXqS+oiCXSNYTFh6m0z8mixtPTgqXA5M0qhSmX7edNS
	1po+DHbGMmHXlpSkN4O/keAwAqbSuOgmPTnsiSjDDuX/levsEpr1JC9CPqDb1xkPfvUqg+
	1hnMT66Nv0hemKd7BcBRkupX5VRi7xQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ElwbEHai;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780583722;
	b=BQ7DGX60N1zUwVVJOntUlmeZ7W19ggu1frOkdZWPLtjHMx1vG9XrDiOc6SH4QUM/iHjSzQ
	QlgbYhjj2AXqORr8Kg+Mcp2ZfDcaWdTiVGgimoQ7+rKE6kBbtjSFOOUr9t2L+yHstLZPEW
	DjOl5XSoWTN1ZjI4/EbA652yYbUG3vY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 44F46600B0;
	Thu,  4 Jun 2026 14:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56451F00893;
	Thu,  4 Jun 2026 14:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780583722;
	bh=vgLl/p3qkGVQ4J0lmKFNqcECALdu6p7bDPIjji6x+rw=;
	h=From:To:Cc:Subject:Date;
	b=ElwbEHaiF9IANaaSytaLz7EQlu4/Ut/lrGHBqHUmDI9GqM32kqROX2k3s6R9oZ7HO
	 CmFNXNc0tCreViLwZ1EdrWC3D015+uxhUrLiO6o2N3iVQmMduj0A9lILeInKuNAScc
	 TArZZ0o463TVLgqlK5TyivceCRd8CIN+6YhOurHJSSdn1eR5pmqUV9XdkJSTnpTQlF
	 9FQxxclMfLLMtP+ub6Sg+x6B8UJCcwqpK+w8wNYNMn2y+dNwgaPq4caZHJK3WAhPNN
	 hTMKViaQXzV5jQjjDG+Ltjy3udAOEvOXzyity8vnqeCRDkuvmzN4BKu5WemCBhTMGB
	 i+W1jgcaDdg+g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 11 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1] mm/damon/core: always put unsuccessfully committed target pids
Date: Thu,  4 Jun 2026 07:35:08 -0700
Message-ID: <20260604143514.84310-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HE-Tag: 1780583722-990827
X-HE-Meta: U2FsdGVkX1+na7HeTfBxunXqdj4AYnXRxjrdLWLMyAhIptVUYdiYhWERo46GNU7zq1zkUfurhWXNQDXj/Js2Rh9uzHUhkSwSm/Q3Ld//SjTkK4YdPce5YEp/e7QAhlxJtIcmF+ksrHA1fwoCwtT/PSBdsGQaTbIUNtZxkCFCc/Y2569Q2ehXLIAYbjg8dqjxc4DM0eCtOXJztv8AfxD723F3LyhrFzyhQAL9DCj6EXbz9FfjDjWdTiXefj4ttyjtZ4cb4EN1d2bH2mFkmBSwXc6A0LK1kKvjs8iCwg9tlPfdeNQK0GhO8qQRnNRe0xqxnXWh4V+tFs5+gTmt9VkLwdn0Bh4faMyPMwoFq+Bk3d41kjRO6sDH+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_target() puts and gets the destination and the source
target pids.  It puts the destination target pid because it will be
overwritten by the source target pid.  It gets the source pid because
the caller is supposed to eventually put the pids.  In more detail, the
caller will call damon_destroy_ctx() after damon_commit_ctx() to destroy
the entire source context.  And in this case, [f]vaddr operation set's
cleanup_target() callback will put the pids.

The commit operation is made at the context level.  The operation can
fail in multiple places including in the middle and after the targets
commit operations.  For any such failures, immediately the error is
returned to the damon_commit_ctx() caller.  If some or all of the source
target pids were committed to the destination during the unsuccessful
context commit attempt, those pids should be put twice.

The source context will do the put operations using the above explained
routine.  However, let's suppose the destination context was not
originally using [f]vaddr operation set and the commit failed before the
ops of the source context is committed.  The destination does not have
the cleanup_target() ops callback, so it cannot put the pids via the
damon_destroy_ctx().

As a result, the pids are leaked.  The issue in the real world would be
not very common.  The commit feature is for changing parameters of
running DAMON context while inheriting internal status like the
monitoring results.  The monitoring results of a physical address range
ain't have things that are beneficial to be inherited to a virtual
address ranges monitoring.  So the problem-causing DAMON control would
be not very common in the real world.  That said, it is a supported
feature. And damon_commit_target() failure due to memory allocation is
relatively realistic [1] if there are a huge number of target regions.

Fix by putting the pids in the commit operation in case of the failures.

The issue was discovered [2] by Sashiko.

[1] https://lore.kernel.org/20260603112306.58490-1-akinobu.mita@gmail.com
[2] https://lore.kernel.org/20260320020056.835-1-sj@kernel.org

Fixes: 83dc7bbaecae ("mm/damon/sysfs: use damon_commit_ctx()")
Cc: <stable@vger.kernel.org> # 6.11.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC
- rfc: https://lore.kernel.org/20260604042349.67720-1-sj@kernel.org
- Check destination cleaanup availability using the cleanup callback.
- Do the cleanup for all commit failure points in
  [targets commit, ops commit] scope.
- Wordsmith the commit message.
- Add 'Fixes:' and Cc: stable@.

 mm/damon/core.c | 55 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 265d51ade25bf..7e4b9affc5b06 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1387,10 +1387,36 @@ static int damon_commit_target(
 	return 0;
 }
 
+/*
+ * damon_revert_target_commits() - revert unsuccessful target commits.
+ * @dst:	Commit destination context
+ * @failed:	Commit failed destination target
+ * @src:	Commit source context
+ *
+ * Revert target states that changed by damon_commit_target(), and cannot be
+ * cleaned up by the destination context's ops.cleanup_target().
+ */
+static void damon_revert_target_commits(struct damon_ctx *dst,
+		struct damon_target *failed, struct damon_ctx *src)
+{
+	struct damon_target *target;
+
+	if (!damon_target_has_pid(src))
+		return;
+	if (dst->ops.cleanup_target)
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
 	struct damon_target *dst_target, *next, *src_target, *new_target;
+	struct damon_target *failed;
 	int i = 0, j = 0, err;
 
 	damon_for_each_target_safe(dst_target, next, dst) {
@@ -1404,8 +1430,10 @@ static int damon_commit_targets(
 					dst_target, damon_target_has_pid(dst),
 					src_target, damon_target_has_pid(src),
 					src->min_region_sz);
-			if (err)
-				return err;
+			if (err) {
+				failed = dst_target;
+				goto out;
+			}
 		} else {
 			struct damos *s;
 
@@ -1419,25 +1447,34 @@ static int damon_commit_targets(
 		}
 	}
 
+	failed = NULL;
 	damon_for_each_target_safe(src_target, next, src) {
 		if (j++ < i)
 			continue;
 		/* target to remove has no matching dst */
-		if (src_target->obsolete)
-			return -EINVAL;
+		if (src_target->obsolete) {
+			err = -EINVAL;
+			goto out;
+		}
 		new_target = damon_new_target();
-		if (!new_target)
-			return -ENOMEM;
+		if (!new_target) {
+			err = -ENOMEM;
+			goto out;
+		}
 		err = damon_commit_target(new_target, false,
 				src_target, damon_target_has_pid(src),
 				src->min_region_sz);
 		if (err) {
 			damon_destroy_target(new_target, NULL);
-			return err;
+			goto out;
 		}
 		damon_add_target(dst, new_target);
 	}
 	return 0;
+
+out:
+	damon_revert_target_commits(dst, failed, src);
+	return err;
 }
 
 static void damon_commit_filter(struct damon_filter *dst,
@@ -1571,8 +1608,10 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	 */
 	if (!damon_attrs_equals(&dst->attrs, &src->attrs)) {
 		err = damon_set_attrs(dst, &src->attrs);
-		if (err)
+		if (err) {
+			damon_revert_target_commits(dst, NULL, src);
 			return err;
+		}
 	}
 	dst->pause = src->pause;
 	dst->ops = src->ops;

base-commit: eeac72cb1b86b53f95c1596ec43db17827a8355e
-- 
2.47.3

