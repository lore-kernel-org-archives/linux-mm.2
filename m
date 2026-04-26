Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8579AFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 23:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E726B008A; Sun, 26 Apr 2026 19:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A81E6B008C; Sun, 26 Apr 2026 19:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8B826B0092; Sun, 26 Apr 2026 19:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA6C66B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:16:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A10721C07C3
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:16:32 +0000 (UTC)
X-FDA: 84702268224.19.92C0267
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 18C8BC0009
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:16:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJu28CUl;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777245391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7f5guP4RRpalKMA6snPM1jqmJJUQ+1ewSqJog8K9+c=;
	b=Ey4jO+B9djC6Xb1zgG0H38Yu1zzIby/ITEOp233y+QzEOh67KjLykjXpZPlyJkfZmSN/Q6
	pwvNDb/MAbr3lZ2inv6tifEYyYouQwxon+ovQVkZjeEeInibI5ods2dqk+HoTUmiRpVry0
	7dPqT5xSOi6YPx7SkuWBd/AponXzr0Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJu28CUl;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777245391; a=rsa-sha256;
	cv=none;
	b=NnsKqPpEWotdGtA2G44KF3slv/7/MRH9Z8N07tGTWF4BJ5aIoJbmIjp6/BBdsMO5O+5gdV
	vpMDr5lPI8tCTLokY6MDSw4QiCVp2wEX0T50GweU7oTvD1F/E4QNlWPXZ8wj4V3FUfWPdp
	esJToKXq9YcnHoLJ8AjcWrvjesIsu14=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E4DB6057A;
	Sun, 26 Apr 2026 23:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3625C2BCB8;
	Sun, 26 Apr 2026 23:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777245390;
	bh=eMKRxQtjjInDnVOx2h98jzHWtRL2G5g4LN0n0AbX9jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJu28CUlO2hOmn+bHTdHQcqVxSlrGMAd4XKXqIG4p7S2zsN30kD757khd4oSNekN2
	 uI6IiF669T6xUMroAQckUtoeg1ohFrnvkENTNAAbuH0N5UXAhcfWOW0kREAK0hrd4h
	 CzUZvaGI66MXqtiK5/LbP914J26SjRDUXgcpDAnSz7UUM3tJWx/B5uBTsN0f9UMJHc
	 5S5iEFMyYmKxb1o4JLa1k/fttfdZKUyw9bQ+189loLxyixkuwi1xhbp1fd4G9JnhWD
	 idZ5yiWHlwlsxoHfT6yRdJl76evMIS6AQki3xYxC2yNdLWuJHlKfbKTKtjVMVRr6L2
	 DBZtIKm9U5dbA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 3/4] mm/damon: add synchronous commit for commit_inputs
Date: Sun, 26 Apr 2026 16:16:16 -0700
Message-ID: <20260426231619.107231-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426231619.107231-1-sj@kernel.org>
References: <20260426231619.107231-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 18C8BC0009
X-Rspamd-Server: rspam06
X-Stat-Signature: 6nfu6ob6t61oxwwggq93b7fa4sgfiy45
X-HE-Tag: 1777245390-285662
X-HE-Meta: U2FsdGVkX19l3K158K3OkAmjJwREf0DaAKaMwzw6eCZ5NPv0pcyJEY4yMYqybYzEoX2cEP+HVBAZS2oeg257o3VnVnDMBgxS8t/dNbBXAU+fdcAMbjA2TnPerYkb9lVPNKVgEBfi6bfxtNHjPLdri2VMN3Q8PAJKptvqinvI31d3EkHQIrDQKerCaAIOFIldjr3KGTb7+toN8mMd56bzEhqej/3TJ0LyGyu7L8Rt/yGIPhn5ptm0ly65SRzo6pa2X6/iCrQosRVBsxJt/T8XpmZPdcKKUVM/mEcofWThwPexpqHMhYdC/e2BPfBP3vWcV/55RxQ4B+zNMQNrYPY1aTqjhZgNmnwAAl9fncGx3XUQTJ4ABq7Do+RJDzT2aurssZroAmfYmNAbEqBMn/t/8cdY2rxR+JZnBNstyk3pj+ezleelx8OmkbKadjselMGoUVvD0KzkLq2GDpTp6LvPnf+qfzBHS15TNIOC6+Mw9ArdUtTtZcFxy72VHzxN9V37c/1iniw8wKJSNhA8o70xEgvNn5RXzyuJ9G8KJS3A7AsmehnbOYENSpK0aMskGYKO7F3YBOao28KTrwwuGIyTW1TQq91Fu5eky0ENMQnBxy2llBAv+rNGiFP9aVYt6zBGTfRqAQHEapNRxw42J6YZEpFLyXWg1trjLm+3faPQOrs5NvcVXEr0XI9HSDxcnVFtjpxNKGxJTCRGH+i7/AGJZkmXW5Wcin23Xz+3+kS/ULC/RDu7i1jrGPeDMenSguMIXrbEJGuTi0oDIdWhwqbParP+VIuiwycrKXgnadS082Fi/9PaOY7+/um1ey1FOY84OmA+ZSgutjJOdv8GtsIJoj2egNIveWRonkCSGUEv0hCmjLwygsy+xTLMrnnrZQDR2s4cAl+PYrbW/5WzcBOmYtXxY1NO2qAsmKzMp99dBEK+zl2oKWopl1ACLwvn6T26IbTRpgKpO4IZTpK4BQj
 3KMvJ0nW
 jH/gV4JuC3dZnGrGz66ivNXSVIENedGeL5VEd9iUUsgo+NfG6Om73OWZIc9Lv3jY10gXbu7ANeIgr7xHJFhM+Bx6x8uoyWspZixwXsSEiCsf0/B9mNvJ0P2Wo186pXLN99xf8wpTiv/GtvGD4wIm2sy5jiCe1Gg1G3zfhkop0iCngw9ER5HCnaNuBpSnBUDpWgciqywC/W5CadzNtG2zwW0ENIw7FcclJyCQ6VFEUx3ZPdFQprPWNKxGKgQ7C+8cO3hwclFeXCSdkrQUjV82VGMgYyAD9OFYIJ48pU6gbzyPtFWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

Problem
=======
Writing invalid parameters to sysfs followed by 'commit_inputs=Y' fails
silently (no error returned to shell), because the validation happens
asynchronously in the kdamond.

Solution
========
To fix this, the commit_inputs_store() callback now uses damon_call() to
synchronously commit parameters in the kdamond thread's safe context.
This ensures that validation errors are returned immediately to
userspace, following the pattern used by DAMON_SYSFS.

Changes
=======
1. Added commit_inputs_store() and commit_inputs_fn() to commit
   synchronously.
2. Removed handle_commit_inputs().

This change is motivated from another discussion [1].

[1] https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v2
(https://lore.kernelorg/20260329075415.36775-1-aethernet65535@gmail.com)
- Rebase to latest mm-new.
Changes from v1:
- Restore the KERNEL_PARAM_OPS_FL_NOARG flag to keep the compatibility.
- Link to V1: https://lore.kernel.org/20260328084524.5451-1-aethernet65535@gmail.com
Changes from RFC-v6
- Removed unnecessary assignment (repeat) in commit_inputs_store().
- Change the return value; if an error occurs, return the error code.
- Removed the RFC tag.
- Link to RFC-v6: https://lore.kernel.org/20260327062558.66392-1-aethernet65535@gmail.com
Changes from RFC-v5:
- Removed unnecessary assignment (data) in commit_inputs_store().
- Return -EINVAL instead of -EBUSY when 'commit_inputs' is triggered
  while kdamond is not running.
- Link to RFC-v5: https://lore.kernel.org/20260325013939.18167-1-aethernet65535@gmail.com
Changes from RFC-v4:
- Rename the 'yes' variable in commit_inputs_store() to the more
  understandable 'commit_inputs_request'.
- Return -EBUSY instead of -EINVAL when 'commit_inputs' is triggered
  while kdamond is not running.
- Link to RFC-v4: https://lore.kernel.org/20260323021648.6590-1-aethernet65535@gmail.com
Changes from RFC-v3:
- Added checks for 'ctx' and 'damon_is_running()' to prevent NULL
  pointer dereference during early boot. (Found by Sashiko.dev)
- Removed handle_commit_inputs() and its associated polling logic as
  they have become dead code after moving to the synchronous damon_call()
  approach.
- Ensure the 'commit_inputs' is properly updated.
Link to RFC-v3: https://lore.kernel.org/20260322231522.32700-1-aethernet65535@gmail.com
Changes from RFC-v2:
- Removed damon_validate_attrs(), now using damon_commit_ctx() for
  synchronous validation in the kdamond context.
- Following DAMON_SYSFS pattern for synchronous commit via damon_call().
- Link to RFC-v2: https://lore.kernel.org/20260321140926.22163-1-aethernet65535@gmail.com
Changes from RFC-v1:
- Remove question from commit message area.
- Added synchronous validation for DAMON_RECLAIM.
- Rename damon_valid_attrs() -> damon_validate_attrs().
- Exported a new function damon_validate_attrs() and declared it in
  damon.h.
- Link to RFC-v1: https://lore.kernel.org/20260321002642.22712-1-aethernet65535@gmail.com

 mm/damon/lru_sort.c | 46 ++++++++++++++++++++++++++++++++++++++-------
 mm/damon/reclaim.c  | 46 ++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 8494040b1ee48..7569e471160a0 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Desired active to [in]active memory ratio in bp (1/10,000).
@@ -340,18 +339,51 @@ static int damon_lru_sort_apply_parameters(void)
 	return err;
 }
 
-static int damon_lru_sort_handle_commit_inputs(void)
+static int damon_lru_sort_commit_inputs_fn(void *arg)
 {
+	return damon_lru_sort_apply_parameters();
+}
+
+static int damon_lru_sort_commit_inputs_store(const char *val,
+					      const struct kernel_param *kp)
+{
+	bool commit_inputs_request;
 	int err;
+	struct damon_call_control control = {
+		.fn = damon_lru_sort_commit_inputs_fn,
+	};
+
+	if (!val) {
+		commit_inputs_request = true;
+	} else {
+		err = kstrtobool(val, &commit_inputs_request);
+		if (err)
+			return err;
+	}
 
-	if (!commit_inputs)
+	if (!commit_inputs_request)
 		return 0;
 
-	err = damon_lru_sort_apply_parameters();
-	commit_inputs = false;
-	return err;
+	/*
+	 * Skip damon_call() if ctx is not initialized to avoid
+	 * NULL pointer dereference.
+	 */
+	if (!ctx)
+		return -EINVAL;
+
+	err = damon_call(ctx, &control);
+
+	return err ? err : control.return_code;
 }
 
+static const struct kernel_param_ops commit_inputs_param_ops = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = damon_lru_sort_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_lru_sort_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
@@ -365,7 +397,7 @@ static int damon_lru_sort_damon_call_fn(void *arg)
 			damon_lru_sort_cold_stat = s->stat;
 	}
 
-	return damon_lru_sort_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index fe7fce26cf6ce..b330ff1695907 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Time threshold for cold memory regions identification in microseconds.
@@ -246,18 +245,51 @@ static int damon_reclaim_apply_parameters(void)
 	return err;
 }
 
-static int damon_reclaim_handle_commit_inputs(void)
+static int damon_reclaim_commit_inputs_fn(void *arg)
 {
+	return damon_reclaim_apply_parameters();
+}
+
+static int damon_reclaim_commit_inputs_store(const char *val,
+					     const struct kernel_param *kp)
+{
+	bool commit_inputs_request;
 	int err;
+	struct damon_call_control control = {
+		.fn = damon_reclaim_commit_inputs_fn,
+	};
 
-	if (!commit_inputs)
+	if (!val) {
+		commit_inputs_request = true;
+	} else {
+		err = kstrtobool(val, &commit_inputs_request);
+		if (err)
+			return err;
+	}
+
+	if (!commit_inputs_request)
 		return 0;
 
-	err = damon_reclaim_apply_parameters();
-	commit_inputs = false;
-	return err;
+	/*
+	 * Skip damon_call() if ctx is not initialized to avoid
+	 * NULL pointer dereference.
+	 */
+	if (!ctx)
+		return -EINVAL;
+
+	err = damon_call(ctx, &control);
+
+	return err ? err : control.return_code;
 }
 
+static const struct kernel_param_ops commit_inputs_param_ops = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = damon_reclaim_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_reclaim_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
@@ -267,7 +299,7 @@ static int damon_reclaim_damon_call_fn(void *arg)
 	damon_for_each_scheme(s, c)
 		damon_reclaim_stat = s->stat;
 
-	return damon_reclaim_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
-- 
2.47.3

