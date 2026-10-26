Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EAE606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FuknI81y
Received: by kanga.kvack.org (Postfix)
	id EA7066B05B0; Mon, 26 Oct 2026 09:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E581E6B05B1; Mon, 26 Oct 2026 09:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D966D6B05B4; Mon, 26 Oct 2026 09:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B62DB6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:47:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5D251607A3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:47:50 +0000 (UTC)
X-FDA: 85364905500.09.3588B97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2649D140007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:47:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FuknI81y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793022469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aXB9q+SjCodJprte8ZqvjzyulFgl828dew1/IFtc6cc=;
	b=Gzy/Gl7Ztp3nUCSZG0ncRXE3N1omCpdRlpuznXPSNBDRHpQ2trT1S/Kd/luet7M0XSf4NP
	hBbSsF4fM6zGiyDGQztMJCidvYIdajAqiR42aj6Uo9AA35lkMlTOFKow19qarcCEyqseHO
	rrOD83jLwElVAqmJ4hw/rCtFHaR0//E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FuknI81y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793022469;
	b=oKXc2SWvtbFSKCSCXvkq/D5ijW1c/+vHlzOxQ0kA+JLCUZ8K5gB5CPh3zUsKHHPAgCa0d+
	V+rbK1pp+krbEpjU9hGBZZ72ccPLKqs8MdBsX3AJZRN5Fs1szwWiF8cAfPwiT167wBEHsX
	cdbM4bt5lFSB2j02EybLq7ql5zTmBXU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 40C164075F;
	Mon, 26 Oct 2026 13:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19021F01825;
	Mon, 26 Oct 2026 13:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793022468;
	bh=aXB9q+SjCodJprte8ZqvjzyulFgl828dew1/IFtc6cc=;
	h=From:To:Cc:Subject:Date;
	b=FuknI81ysijUZpiN3I8AI1drSsxf4I4W+69dTEHZKpuflQISUwVDqE39PD3fIJYCw
	 lhJUtaM9OZMr4yWHWyglUOxl003BdzsrZFGsMysr63GezpUhcuCEdMmGkkyLI/luFq
	 OakdRhMcb/Fo2hOJeqL6PNUgBaj1IPUQX6IUmZ2LlU09PqoAPms4rObvneHX3GY8zH
	 VETwiEnGGb++JIFUc5a6iKPBjfqnUWKPmpnun4abliYzyJk5A3Sy3LNBMKHuSRz3U2
	 HfTOIQRGc1e1n5T0cz1tSraKe9M6VEgAOX2K9DetLQzZjHp0l4qHJqm4/zyZtbVImM
	 Gb6ezA3sehgfw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [RFC PATCH 6.18.y v2] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Mon, 26 Oct 2026 06:47:39 -0700
Message-ID: <20261026134740.149027-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2649D140007
X-Stat-Signature: 43eptukbw3z8974qs91pzcbhc1c3hk7d
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793022468-116778
X-HE-Meta: U2FsdGVkX18LHWoQ8B0pXAuYEmayhivGzOQMWj2lET/wyvPBHItRr9XVcQoEtqzDh9Y+fRbTTPUoYbJiDNQisz5jG0KkDhvY0q4v22lIxq25J5/3lTuWgRk1HQnTksDpzYKzw2ySOLh1bZ0PkGrWZcU2LUcD4+TjSJauBPTK1QIRtcoL226b4YtDniQcQZ+OHtv/WBCaHZWDuC7+/GPI/wemy6n2T9z4FDYzdxRtLgKI7ysqIBDVam15Fp61tIAXwQPOTt9GENdywY+59X24s7lr0MMGp5xwN5IifNva4N7o+Cv2Wfz8mI9wCrmlvY9dtfLz6uNMwuZZo1BCJYxOGCE44bc59tHOl9SjvWlvlhWUWnMTNM1O4kKff6Dl1wSjiBlJevOnmIpj0B1wX6yD6zByjvcbCLBLhk9Rb/QLUXZuoezxie4T1Ih9fFUCQdP3ukb0qI/+ZhBOGr77ix+p3vEkSKfD1fQXe2NdE3QBT4r5Q7JpMv3wVfai3w/1FxB+UndJEdxTB1bAnNyd3uBE4JQJIAN5Y7EdYk5AhTAXBDBZrP3/OYqvVtCNOn0i4p3c3fLYsa6s6RSo4Vk5X30X6W2ARxVRmarGzkV2QT5n+1Uwx3dgVBLGQ49qbjBN+vyqZTWrGmKMrHslwwUewoATFDWKUGupErZ/Zd2y/zmJTDVmPtGcxe98ducbxhQ3aaQK0TaA0JIJBoYpKJ7Fl7gXVX6cRd+7z+LsaF7w5YeNvl27FdJpeP4MtUS402xjZ+h3VypoIWYX70f+i7zbSIaxdZ49WaVuF2tIA4JdodC5BiASQ0NA+197XNb7xrhqDzjX1WdaTzcrHDvlfInO89NFAavxEXuFAXOLpdPwUmruhMaKhCT8MSpiTL1YRkWoIHMAHCPVhxI9wUNHwiqtUGNxN3NR0bJcVSKLLVFaYCJ71ZaTvt1vTMLIX/OF9PNZU1/20jhYuig6v9CvkfqavN3
 oJaSJYOM
 b20n3LtcTziwAQIScMahF0+9mizbfd+O6RIXOACDQS0U2L4cVU+lFj6B9lxnKH0r4lFf96vT2wQjozbkLIjN3Qrn426K3rArc0H3y9kbhQUDRcjBbIcR6ZMdVzUQcGTIDgRhGtUnK8ZXHUkqToREZQvuWO+1WjXPZZEKwWp5zUuiAWzauWjkeb6hSc29yZ5NnuteiczuwENajDbDehGZI4YM7GFO6lSiU5emr7tM7g/nuK6w0PY+4e/9JUuOkXs3sOY/UGKmW55ix40/KiYIa3uHXt9el965vOJrh/QALyIA8ujdpAjE5o3DBOCI0yL55+m4igyC7IpBPPHOAYdms7askoyzjLMzdV/ky0j+d8HOVIXdy+nMdYjHLSLZax2B9bwQhE8fGJYu6bYs=
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
- RFC: https://lore.kernel.org/20261025172712.164385-1-sj@kernel.org
- Add a validation for damon_start() path.

 mm/damon/core.c  | 22 ++++++++++++++++------
 mm/damon/sysfs.c | 19 +++++++++++++++++++
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4e6e3d7d0a5c0..8fa788b0d709c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -807,15 +807,18 @@ static void damos_commit_quota_goal_union(
 	}
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
 	damos_commit_quota_goal_union(dst, src);
+	return 0;
 }
 
 /**
@@ -833,14 +836,17 @@ static void damos_commit_quota_goal(
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
@@ -849,7 +855,11 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
 				src_goal->metric, src_goal->target_value);
 		if (!new_goal)
 			return -ENOMEM;
-		damos_commit_quota_goal(new_goal, src_goal);
+		err = damos_commit_quota_goal(new_goal, src_goal);
+		if (err) {
+			damos_free_quota_goal(new_goal);
+			return err;
+		}
 		damos_add_quota_goal(dst, new_goal);
 	}
 	return 0;
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 7f52470be36e3..3a79d8c89b5bb 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1592,6 +1592,20 @@ static int damon_sysfs_repeat_call_fn(void *data)
 	return 0;
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
@@ -1618,6 +1632,11 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 		kfree(repeat_call_control);
 		return PTR_ERR(ctx);
 	}
+	if (!damon_sysfs_valid_start_ctx(ctx)) {
+		kfree(repeat_call_control);
+		damon_destroy_ctx(ctx);
+		return -EINVAL;
+	}
 	err = damon_start(&ctx, 1, false);
 	if (err) {
 		kfree(repeat_call_control);

base-commit: 2926d88bb7fc4608fd942453d929c39e4e5ec006
-- 
2.47.3

