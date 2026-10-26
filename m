Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9911560A2626
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z+//AggR
Received: by kanga.kvack.org (Postfix)
	id 961E36B05B1; Mon, 26 Oct 2026 09:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9384D6B05B2; Mon, 26 Oct 2026 09:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DF56B05B3; Mon, 26 Oct 2026 09:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51ED06B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:56:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D555F1C40DC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:56:05 +0000 (UTC)
X-FDA: 85364926290.12.A38C1E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 30B634000C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:56:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z+//AggR";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793022964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ApIVjv3bZLy29G33wA2rchv8AUBiRy3NOnkFuRpzOv0=;
	b=1s0AE/bR7Rp517V8IxYC7Lmm0cYEQLO3GzgBODEB+N5FAahOLiI0+FoK258uX85syik9a8
	ovgY2fkozEne0qW7BqbMgzd6UrXpFJaYwLBag5byCC+LHc/4JRP01tmqIpVndWmidQf+bI
	K6IS4kXLjN5fR8Yygcm4x4j65J9327o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z+//AggR";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793022964;
	b=8avQPd/P+ev5sHkEC02beh/fRkMdoeWCf8QNp0Be9G58a0r8OW7kETIYgaVcY+cC/5mlJU
	BnSUi2ieMXVVScgJpyXlRduufnMZbHz/GqQ+0TyFgxQK/XAdCa11ftdacwMrP6CBXIjbfO
	eRvl6HV0hJZHclowDh4VDlMIcoxM+XA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 674C743A76;
	Mon, 26 Oct 2026 13:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C221F031E5;
	Mon, 26 Oct 2026 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793022963;
	bh=ApIVjv3bZLy29G33wA2rchv8AUBiRy3NOnkFuRpzOv0=;
	h=From:To:Cc:Subject:Date;
	b=Z+//AggRycuLUwJtXn3WFQrI4+5O7MmeSBPhMBfT/7P0pLodCnj+GiiXBPSAPSF6r
	 pYOOoaaVH3rcF7qkmAewqWWvmwx6gpynahvpjt1YK5JypFXjlCwIzFQIba69KPpkO+
	 rv/MafsgNUm79g6YYqwc8rGnGkjGN+OX8Y17u7aDwQ2PK+hfQRkb1JBPxaYZr5IsMS
	 RyTNtDL6XgHqr2HmU/j+bwhT4oMjsdOhuFzloVat3sj8cna5p/qttDYrXH+9ZvObEh
	 GoYKfP4zPDN46OwmRPVPLQYXV2esm81roRZegfF0vRrk57q3z0AY9/4wd5xqs0fk6+
	 fqNe36EDu+hgA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [RFC PATCH 6.12.y v2] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Mon, 26 Oct 2026 06:55:54 -0700
Message-ID: <20261026135555.149244-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 30B634000C
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: j435c9cp5esc7jg56wks6pt5y9fx13bj
X-HE-Tag: 1793022964-885855
X-HE-Meta: U2FsdGVkX1/o+ol9gX/nLem542Rdg5x5uv3MZpdhjK0GsT/A1tqTDWNHFRH1mYuilrw5dqaCnTsBFwYycC+qt0R01q1dschr+HUU3MEcaPQDb9E7kvyhhBeAy1W+Y+6ngFwfDYA5necPQ/ZS8gQmmejN6j9BwJcCuy+aI1Wvp1eWbOKpaP3nQ3+ETaXm6t5L+/O9RVT6OTjNlQgGOiL/07SZAJWM60dWYYlLZGKY7Fok4Wa54n7YTzvOhIWmRdQp0Wb1oRusn3MjbR56wI2/9+MJQ3DSqgmQ+dWfa82ISTI3Gou1Y93E0YUXNKgOh53KhrMxOS8oUmtR4hAMvNnHLkYUUBz7B0RLiP9nISIv+lnLdx92c8Psr/ZP0eX1yJDxelB5L9PgRxGH2MzohIMl+i1PAPrKkua7/E68Kx4j/Azn12MOGDu/24yI/yEpuDIHb4y9K8bqrLdkBK/nWBx5LhKwuNm3DP9USflpt6vZ0ih03SFCOO5Nw0hdIdcQ8OluSWr19m1EfGyJdGoDE3PeMLvVukX36vSAU0Cm7cdZ3Qt8qw/k5JMuRg7hzLA1iFzKXlH1lrM30yRIn8RZT+QR0iVHl5MA1oZbaSWlj7d/F7NtZfLbDBG02zRCi+PVw7Kh3j9yAjk4vhdSfkh/Fq7TErpAC0Uecm/zo5JaZJ6XN6orP30rhiUZgLiAmsUfFzo9kt9QbjmHwFvib9iXRCUNtLE28Cwndp6v1QCT3Bagu4bv0oDxAnYIBLg7B6Yr0NCOeY5yhzXNfZM4xOZP/4Uv2PLXzRZbLW5VV7MvOborovJbPk87pnB9McQ3mpVOMux9AlcN1E3bsRUBXrsh6+S1rBnyB/EFgdEwJLyHWO47rZ4mWxHPfPnKhEi/6lp2ceICpVqMA74GXfkhdgeJG+NdKRnNm04PAgj96O9Qt008wUQ5lw1aIFPDlocfmQkwtSHJewRh+wH4O9VPTy3k5Tp
 97ai7jIq
 O8bxfVWUblHVhtTiUQcFjBj8fn4NXQF3Ukbw9GPKDfjuwJHzYjdxdxNlevGzjvN3LD030g+kx+nmzrbzfZtjYV7wvZN+RReN0CsuW/DOrWNxzGbalESxvWouNDddaqnfi0v6Qk0OqzAhMJw4Va8EHipiIPMlffAgiTE1XaIgR8+g5v3v6jgbm5eOztkIEsxUZ1z0OfOzLtMiek+T+O8f3DaxPsVCBNK5VKH462avTg+H8b6tCOMWorJR4P9BngtH/Sy3P7SzcGUN9PIAKfu60OvuPk78eKnoP4AEepRy5ZNwy3GSHnLPqM5nMg5RBr1DFofH9MToZ0O3YebE0TJy1oCeB+O5eLAOoTH9sceZHIkIqN4C74d+ZRr10OkPuMMEPw4Hxrg/4s08Y1Fi6fAIEBA6BgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Patch series "mm/damon: move zero damos quota target_value handling to the
core layer".

Having zero DAMOS quota target value can cause division by zero.  DAMON
API callers are checking the target value parameters to avoid that.  It is
easy to make mistakes in some of the multiple API callers.  Move that to
the core layer.

Patch 1 adds the corner case handling into the core layer DAMON parameters
validation logic.  Patches 2 and 3 remove no more needed DAMON API callers
side handling of the corner case in DAMON_LRU_SORT and DMON_SAMPLIE_MTIER,
respectively.

This patch (of 3):

If a DAMOS scheme has a damos_quota_goal of zero target_value,
damos_quota_goal() could trigger division-by-zero error.  Hence each DAMON
API callers should do the zero target_value validation.  It is easy to
make mistakes.  Actually such bugs in DAMON_LRU_SORT and
DAMON_SAMPLE_MTIER were found and fixed [1].

It is better to handle the corner case only once in the core layer,
instead of multiple places in all DAMON API callers.  One straightforward
option is using an alternative denominator for the corner case in the
damos_quota_goal().  However, the zero target_value is meaningless.  In
this case, the quota goal is always evaluated as achieved or
over-achieved.  The quota will only keep being reduced.

Simply avoid using zero target_value by adding a check in the core layer
DAMOS quota goal parameters validation/commit path,
damos_commit_quota_goal().  Update it to return an error in the case.
Also update its caller to propagate the error.

Notes for stable kernel porting.  The upstream commit doesn't have
Fixes: and therefore not ported to stable kernels.  It turned out it
fixes commit 8b549a4fd3c5 ("mm/damon/sysfs-schemes: commit damos quota
goals user input to DAMOS") which was merged into v6.8.  The user impact
is a race condition that can result in divide-by-zero.  Hence backport.
Reproducing the issue requires sysfs write permission, certain DAMON ABI
usages that are supposed to be uncommon, and a rare race timing, though.
The issue was discovered [2] by Sashiko as a part [3] of its bug report.

Also, the upstream commit on this stable kernel can fix the issue for
parameters commit paths but DAMON start path.  That's because DAMON
start path does not invoke damon_commit_quota_goals().  To fix the path
with minimum change, add a new small validation of quota goal target
value before damon_start() call.

[2] https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b
[3] https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org

Link: https://lore.kernel.org/20260903010722.94244-1-sj@kernel.org
Link: https://lore.kernel.org/20260903010722.94244-2-sj@kernel.org
Link: https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org [1]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 610c4438fb66e06d9e693c0ad3b2c1be54c0d61f)
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC
- RFC: https://lore.kernel.org/20261025182326.178326-1-sj@kernel.org
- Fix a typo and macro expansion build error for quota goal iteration.
- Destroy ctx in the before-damon_start() error path.

 mm/damon/core.c  | 18 +++++++++++++-----
 mm/damon/sysfs.c | 18 ++++++++++++++++++
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 81d44e41de210..ed32855c16ed8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -698,14 +698,17 @@ static struct damos_quota_goal *damos_nth_quota_goal(
 	return NULL;
 }
 
-static void damos_commit_quota_goal(
+static int damos_commit_quota_goal(
 		struct damos_quota_goal *dst, struct damos_quota_goal *src)
 {
+	if (!src->target_value)
+		return  -EINVAL;
 	dst->metric = src->metric;
 	dst->target_value = src->target_value;
 	if (dst->metric == DAMOS_QUOTA_USER_INPUT)
 		dst->current_value = src->current_value;
 	/* keep last_psi_total as is, since it will be updated in next cycle */
+	return 0;
 }
 
 /**
@@ -723,18 +726,23 @@ static void damos_commit_quota_goal(
 int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
 {
 	struct damos_quota_goal *dst_goal, *next, *src_goal, *new_goal;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damos_for_each_quota_goal_safe(dst_goal, next, dst) {
 		src_goal = damos_nth_quota_goal(i++, src);
-		if (src_goal)
-			damos_commit_quota_goal(dst_goal, src_goal);
-		else
+		if (src_goal) {
+			err = damos_commit_quota_goal(dst_goal, src_goal);
+			if (err)
+				return err;
+		} else {
 			damos_destroy_quota_goal(dst_goal);
+		}
 	}
 	damos_for_each_quota_goal_safe(src_goal, next, src) {
 		if (j++ < i)
 			continue;
+		if (!src_goal->target_value)
+			return -EINVAL;
 		new_goal = damos_new_quota_goal(
 				src_goal->metric, src_goal->target_value);
 		if (!new_goal)
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5aa23c6545cb8..2c8749b62c621 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1497,6 +1497,20 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 	return ctx;
 }
 
+static bool damon_sysfs_valid_start_ctx(struct damon_ctx *ctx)
+{
+	struct damos *s;
+	struct damos_quota_goal *g;
+
+	damon_for_each_scheme(s, ctx) {
+		damos_for_each_quota_goal(g, (&s->quota)) {
+			if (!g->target_value)
+				return false;
+		}
+	}
+	return true;
+}
+
 static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 {
 	struct damon_ctx *ctx;
@@ -1517,6 +1531,10 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
+	if (!damon_sysfs_valid_start_ctx(ctx)) {
+		damon_destroy_ctx(ctx);
+		return -EINVAL;
+	}
 	err = damon_start(&ctx, 1, false);
 	if (err) {
 		damon_destroy_ctx(ctx);

base-commit: 85d82e0d7c2dfd3e75d34f35b7ebbf41f45c9c4e
-- 
2.47.3

