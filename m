Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08380CD6E6E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 01:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674586B0005; Thu,  4 Jun 2026 21:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE216B0088; Thu,  4 Jun 2026 21:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5866B008A; Thu,  4 Jun 2026 21:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 381C56B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 21:39:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0265F1C21C6
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:38:59 +0000 (UTC)
X-FDA: 84844150440.28.5B0BA35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7B992120008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:38:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IszDWLyF;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780623538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3FMzbu3u71nQTcvhV84Inp+2khcRaSZTlpCYSxQCCNM=;
	b=EYAoC0fg/4rN32TttzE7kkscFm304E4d7AVbWjfDkUx3gkbj+m6BIM02umC9K6+5Tfhd7C
	qmt2j3KNG5kQnk8EHHe7EuLdFZeGTIouKIesDl2iBu3PXW3XJ47OnGpMKZFitK35e02BqI
	Ms9dNo9JtK+r+Cs8nJwNIoxK+jlHDnM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780623538;
	b=RTEnX3iU1GxTQoYn+pUwD6lSjFq0tSF8ZsFZ68lW6jxfDAIbwT32UnX1WNi1PwjCT+arvZ
	UGSNPh3RHZ9YebbxBpurdGq2I3a38pa7Ki7iFUX2eniWvxOKMJjiCylHrB2bZTLSC1HC82
	XzLx+hqsUmQP58D/YKJ4nDAgS14XugM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IszDWLyF;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2F976001A;
	Fri,  5 Jun 2026 01:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4288E1F00893;
	Fri,  5 Jun 2026 01:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780623537;
	bh=3FMzbu3u71nQTcvhV84Inp+2khcRaSZTlpCYSxQCCNM=;
	h=From:To:Cc:Subject:Date;
	b=IszDWLyFitkjiWmwl+Kee4Ar/yCCt+rr2vPxubON5Sn5HOqlMHCIUrqBfjdR0v+TI
	 S1nvsmhv6yxqw7JSKXKNx26PulPRAU2/+sRVyNVePkQdxFb/yHdL6yvTZjmeKrB/jw
	 tEC57196PqU+PM5l4g4iAtO4uaJUcITvtuF76B3M/fNt4U5ZA88WHatwJWQ06vcYoi
	 KgUa5ObeT1M0LTVK37OUko46qiJbqdUrKj63jVzY/BTxIakQVHNetitOxwJnM5Ryqo
	 8+IFVvW6INjYGSyo85+h9YLAsm525Fj9em3MXZE1P3uyPmsplPhmUs6h+CIslCzKDB
	 zRLqtJGVFfySw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 11 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: always put unsuccessfully committed target pids
Date: Thu,  4 Jun 2026 18:38:48 -0700
Message-ID: <20260605013849.83750-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7B992120008
X-Rspam-User: 
X-Stat-Signature: z44f688cys7ipwmrykfy6gczyr1fkrjn
X-Rspamd-Server: rspam08
X-HE-Tag: 1780623538-792979
X-HE-Meta: U2FsdGVkX1+GpHyKWJUIm2I5goMjg6p/fpi7AlgB4L/sn/uDmyP75B44OiypyLr3Vl5YzQUCqWXTEjYU2WZq6qKDjNHhzinxWOGzFw9Mx4iENzJifmBog3DyvEtgSZn1x59U0FDGZDPa7eVsLDCCrnphvtBHYqPNYb2hfzxw+oSs7CwpYpByfGic/qGhqIatlqhq9IvObqplHE2XeGP6Ng8Cj2GKkU9+gFDwDM57Dx5wlFyHW9mJ9BdQEZmi1kHYrVuAcP08ND8W15CZwYHN//D+jDb0ftyFj3r+OpR9loNFA6TxRGLZrEEd88+cdewhi/U38b5PoKaRaHaN/6KYQV0VrF7ejpDbZo5aY/PYGG+hnMaXn9X0zN8nKf5ifWbIxAOzTMl8u5Rm6bFzMeFdGLTsdIkHe0TXnUt24c2g1XJuZATRF4KzY3nnHvfH1IEUsimszKAHOH2ZYxWFjKOaZk8RMkM/gvv6qwYsorj9kaaSvrdwqpNDNvmu3XB6PYJjh3owH/+itEhv4zcxCYFJZsaat+q1xCVadLEPBpbYPIbqnmUmEAb30maBnA73nj0L79Z8Waali6mpuk9sWa8RYPuxJt8KJunXNjY/RwbAj2VQ4qltvlE0U+Pth62C2oVIKyTNpUlYTi3bkuRBNMpsn1FNA6kh8MqFhpV6CmXPbiRLr8M09r1bE84JjIyAGKSocqvTQh2xL64vTdS2mM9A/qjE4BFYS/BdYcw+vK++++T5L4ndeoQ9WZNb3lQXxJ2vuFtNGkuNnfn2n3vPX4Y4ZbAstNPBk0XLDfFe9hIYF2FUUCRvSsesiPbxhhcu9mQ/dFAV2S0LfRPQW9OlV5SV7jET9pCssdNtZDS+pQIe4RTI+lxiZO41Y9sXyPSvNd0ROijfXi/TAn4Dm//z19u18V32dQrck/3+m+tedDwIo/cqsA0VBPts5RCJ+BWUYeo6nCINeQGEas+umePqUUZ
 bjqZetx1
 5DbjBnmNuRqQkfO0Gn1CQTregI90i/LSgJnvUQmJx29BZ3ZUDNkPLbhpPdrLKnUiPUOoQcCtXZ4FkbeqnIKWyuFZOUXhxDP0EykzmHyxuDoyvMMcHen9TywvVSCagMlwajAP/vK6uynwbJelq334QdOl2WyM12QRkQgTGgMT+eneIZgHLPhL/Z8eIwaLQI5yKq2pfsZEbqgBrTnpajHSkvQpMIqd2XhhGQ9fyvlU+O/cIlej7V25pEZRWcLST7L+9w14y
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
Changes from RFC v1.1
- rfc v1.1: https://lore.kernel.org/20260604143514.84310-1-sj@kernel.org
- Rebase to latest mm-new.
- Drop RFC tag.
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

base-commit: f499b8d2253d32f4ea1e16198f348e6259cc14ca
-- 
2.47.3

