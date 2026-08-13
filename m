Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44BC4C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 05:44:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F826B03AA; Thu, 13 Aug 2026 01:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5EB56B03AC; Thu, 13 Aug 2026 01:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D486B03AB; Thu, 13 Aug 2026 01:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 930EC6B0191
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:44:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6FFBA2AAF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:44:44 +0000 (UTC)
X-FDA: 85095156888.23.5A510B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 56C4420005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:44:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nvZ4nl92;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786599883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXLkVAHbgjaWy56zhYvF1vnHi1V0hiXRFOM3tY/zcKk=;
	b=ST95JzrNe1Y3IXL5jmsFsIdMsgkDjAEbwoBjK+CDakwo/Sq+vydOB9CrrKobsOKk7a65XS
	WduRLoLe/J3TX6mGXQrxAMhc2qgPwkern8zfwo0eS3uHVaQWKy/yU7BRhHxSSPpi8Bkd3Y
	DLZh86L2+zkjghu+IF4j8udRA36CrYU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nvZ4nl92;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786599883;
	b=1dfNoVVRAvtCeLOkZDl56qqwd2da8rbu4SxPxEAyMPJi8BeodgvDFgpUllz5G2w0MWGzyf
	yMS+/kG9Z5g9xRv+R67hPtubRBY17VHuhAUXcMBJsjgw05gub2pnwgAVWK+u4pk0R+edD9
	aguhoIGbqDk2nA8DwitlNcfyg74AjXo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52C1043312;
	Thu, 13 Aug 2026 05:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C141F00A3A;
	Thu, 13 Aug 2026 05:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786599882;
	bh=fXLkVAHbgjaWy56zhYvF1vnHi1V0hiXRFOM3tY/zcKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nvZ4nl92JoDuDADgB+BpCGre4XpGPaT+GvKTadtgGwJmhVp055oVE4Q6/YPCaeON1
	 EcNwwIKapv2jGvsBMANiDwhPdbUznOMpJhbrbEcJQUKoSSIbm8ZAlljPm9u4/miSD3
	 J3BGXWa5sz9cIYQCmRfF9wwQcZ64GANcp70Yz92DRahvDwaH+SswDKfHBX2JhyiPDc
	 x60IDkf7P2XQS04sG0HD09gFIVkZFxteITGAlVkQUOmNMOYgQujVlENXlF8XLXdV6f
	 u+aP7olg/Vv+o1DTWruYlk7q7V96NWvk1UZfp/GwUCOJbg7cSfzjAbuNVwvfPj4wSN
	 03yY6NmvtWysQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/3] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Wed, 12 Aug 2026 22:44:28 -0700
Message-ID: <20260813054432.101197-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813054432.101197-1-sj@kernel.org>
References: <20260813054432.101197-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 56C4420005
X-Rspamd-Server: rspam07
X-Stat-Signature: z4hssc4b83yfrrtexhf6k4j46krmcpk6
X-HE-Tag: 1786599883-411931
X-HE-Meta: U2FsdGVkX1+HGCQYxiaqKemq2MGKJuzGOTAYLOJjTWQUHlEPPU+awv/YkW9z7Dho2NuFQy7owv1gZo/6mCU4RW8/CiBKKiN3QnLAUjYq40Wxf5OMae9lnpHrOjnzLFbEvJZqB3IOTxZJPGEzm5JH7+zNUCts2Iye3hu4lSH7s94MA/uybXLjGFF35VTqfAuWQErZvgEp1qtk9rUXAe7cKJlRwjaUEGzt0jlXZURyxxO/HRbsNmHg2NS0wssB9UuIfK7lcUmhDiFNarbhqVfDgWqVqpJbwq//SnlkfapiXv9c9s608exHQ0Jbsv3GT6VEJmt4LOMFdtxCswxQAEd/ckWpc2IPX66SLbBQEEbq5HaCBm5E0iosUFyFEka9P8QPx7/Xm2n4XoZYG8+4eF2ot06jcUJd2wqgNxlvJDYt6RAOgJ16Ktot6f7hqJxT8t/dyKmULA1mcJPsgnBO93uosCWKiIBuzXkivLPA7p6jnGe96UPN8XX9fpkoMnAe/rbLsZHiHO39SDKQfYgIC0LGNlTQCVeZMG9bX7Y67FH2KNvtdiELkUrdXrywZO8sd8yPet5wOJc/gWKVxMc+FZkMdRF+EgLcxAK0YH2AGbdITU9XRHHMIlPUjhQVGuPGzUCnT+c37f5vnNhQDn0eLC8n2xzeTh38szqmUsKtnTU00+wyf+xoIet5Z1v5zBv4OWImQEURlgXAC+bo2LPY4LvB22HSH8htfuKD5pniKfrniOmOEsuOep515lTS7fa283l+1qlDLj54xS6nx30tC9b2m5aRPdHRdX9SOP4KR0u9jqUQZncX4lrULQdRY+x/ebU72vX+4Qtv/lpFpvZxb6g/Ok0ZNpCIyLmsvIyNsBQKnRYq1QTN/x8Zg52qgSmCUlBQ2scGOrobU6a+FR89bvqY7eOVndayDL1r/MncygS47FCnB8TOUxTUvoRnxNHYIbKxtiw23uJKzqxTMbcAkbf
 bpXNzI/o
 Zjy4sH9bIB+az2MdVmD9wrSY+Ynz3KvjY0A+LyeO6d6nvI71OEuFtwR44wJvoN3khJWL4EY4IEC1OwyR3GXKnP/XT/81Acbnwu9rq0KQCr+WITOnixkk3/hwnkJEX/Y+N8Dd2CHboGxg7MtBjelJwi3zFLkJqoQTamZYGT+neYnC+fFx0K/bmjjtvQCllx6mNxqUNozqjYdw9R8nyhTxAhwa0kBMoHihFr+im4ThVriJuYB/sauM+P7OJIC1niSEO4BSYsRwgwcSjT84q9hCHpf5HkDVWGz5g14q8ICwdH4euptm+OWwJDv0rVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If a DAMOS scheme has a damos_quota_goal of zero target_value,
damos_quota_goal() could trigger division-by-zero error.  Hence each
DAMON API callers should do the zero target_value validation.  It is
easy to make mistakes.  Actually such bugs in DAMON_LRU_SORT and
DAMON_SAMPLE_MTIER were found and fixed [1].

It is better to handle the corner case only once in the core layer,
instead of multiple places in all DAMON API callers.  One
straightforward option is using an alternative denominator for the
corner case in the damos_quota_goal().  However, the zero target_value
is meaningless.  In this case, the quota goal is always evaluated as
achieved or over-achieved.  The quota will only keep being reduced.

Simply avoid using zero target_value by adding a check in the core layer
DAMOS quota goal parameters validation/commit path,
damos_commit_quota_goal().  Update it to return an error in the case.
Also update its caller to propagate the error.

[1] https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5a92e4fac6d92..183d505c08e4e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1193,15 +1193,18 @@ static void damos_commit_quota_goal_union(
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
@@ -1219,14 +1222,17 @@ static void damos_commit_quota_goal(
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
@@ -1235,7 +1241,11 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
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
-- 
2.47.3

