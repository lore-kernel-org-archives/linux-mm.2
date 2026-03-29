Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89919F3D5F5
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 07:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F08D36B008C; Sun, 29 Mar 2026 03:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E922F6B0095; Sun, 29 Mar 2026 03:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A446B0096; Sun, 29 Mar 2026 03:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C139A6B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 03:54:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 582AF160417
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 07:54:22 +0000 (UTC)
X-FDA: 84598337964.27.03C4025
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 982D54000B
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 07:54:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mSm/I8/X";
	spf=pass (imf27.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774770860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Q5O5VqXLb1ZUzBeNeL2huf0mC4t2aOi14GMpW6fANEw=;
	b=PY2hw6kc/isW0GvLnAMgIVr58s/5iJAEkpP/I1B8s/EWD3IzynHA2UnovN4VK5S9dB4hQg
	/unX+5cY3pdWN3fPYDhP8Av7hUuquS8FeSwluU29vFyKqKXtcGno/mAm0Kli9oKXJwkqqc
	Sb3Ol3zDapLxIdzLnEv8IIY1KtACuww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774770860; a=rsa-sha256;
	cv=none;
	b=quQghEZjAYDfyaFFvk8crPJs0aXO9nl97vmWGfxoWv7P6pYKxFq6jBcPZb7r1OaEKyXWqP
	NDPz6qmEKUhvAynbTB5sRAuvUBoVTYSzx+6Xun+j6CuAF8Fe6u9TbRYQU37TaZCdODvpr2
	iLcjxSZQyPkWXXMxk1hfokij1Kgiiug=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mSm/I8/X";
	spf=pass (imf27.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ab077e3f32so14803015ad.3
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 00:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774770859; x=1775375659; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5O5VqXLb1ZUzBeNeL2huf0mC4t2aOi14GMpW6fANEw=;
        b=mSm/I8/XfsBIQFYEvnbyFf9vksNR+B0lM1xnV2q4TGMZaq860L23/h/Uh3danzHwxT
         NzLsvpYj0N/2W5h2KVJfdo+p+uht7zY5GR5XulXtfmwvDGK8OOgIn7U+hYUe5jTT+057
         6tV5l1QIUrWsaQfOVifmVjACIE9tCwbV09JCGzBzwZIJJtAGefs2sZedfCNVBy8TYeVB
         SYtCZwD3OYJ1Yw3BkKIHSNxJ3t1Wm/PTRJmSv1Rb1MzLeMeJeRP1SrsIjJITg+c8vXGE
         f3qx3H3mTvzEl7dTQ9ecgEJXrLdEu0W2bwJow3MdUW2YnzA2R/LxLQeVENXzCGT9/4c6
         Iy2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774770859; x=1775375659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q5O5VqXLb1ZUzBeNeL2huf0mC4t2aOi14GMpW6fANEw=;
        b=pQ8weiVlDCH1xUrFfa7Ojbibb6UCEp4S+xzCjEmLVFsvv79YiRVPl7EkLWmuhoKh0x
         3NPZzlZyO4QCa5MQCvfIfRcUvxTnJKoZBkJSm71NJvI83jQtcFRnQytvFf/KGIvDI4yk
         h+cAyaRQ1G6A1rEDzBdmADABJC7C5C96H2TMPWm+ohbmgHY4swtiGnoaMeuR441ayCAO
         dIyAHG6kzVlWrUefzNF/r4cjhcCwNOCElANfBW+EP1HHS439qg67EWAVKz5bA7er0W6n
         WJuC4zJphW2/ICjwsJYBlu5UABYHjz10Als4bzIx86NBENTrZv4UmvdNWddaTI0nyel6
         z+eQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNoVyFpwM4g54fUDlAYC6z/65wUUFqeuR/73PqXjicKpisVQrrq4gV/X3GnJW+Tqx/BWYYrGAHxQ==@kvack.org
X-Gm-Message-State: AOJu0Yy362HITtD98p2El1/SK2ftLQAclvNFRM2TZwZkpEv3wZEzE4Pi
	UE0zpd+e1P5iJ3Pq+E4JBQ2+QNzxXqcMRdUjNOnFS6/BJrQkXm4cOV6p
X-Gm-Gg: ATEYQzyI0vLQz3tNklFQa16J1+oCbiIM773og8I7G0Ok1+szIzMXtFQti1mX1uLYFbD
	Gh796cEMCDifvBO59PvrMjJYRFf0q6B/4/sKE13VMlreFECI3pFR4wpLbSllocfpECSfAa71OFF
	ErOM5zcUu5vJ68Fgph1GQ9ZqEsIQNVUdVrb9D2lJtuilt6Z7IfSmA4dhdUW4ZmmKHhw6Id/8A5o
	LGzyFOkRFX2ivG0OpPBXnrjPdp4zyYOwqRQMDjODpLW5qFcL90v9pl+K5a/v/CrLyjD5BbALTC9
	Yevp3AgPQ6YxytguzS9xGO4f5q8vn44QwCrzNA1R7jR/qGFXTI34i0GvZzEU8aJJHF051apfLlK
	Kz4vx1Auetra5qEpWLFMCr69fiIsQZo0KAg0B3J37rl1pdv99EL16sm24cwPJNLYdiUsvT7JWiI
	AEIt1mEVqN+wA7KHUdY08oVAtuttv9s9M5iFtuxJAsEtZkVeRZbWU=
X-Received: by 2002:a17:903:2f87:b0:2ae:5a55:3ded with SMTP id d9443c01a7336-2b0cdd037c9mr83556355ad.45.1774770859281;
        Sun, 29 Mar 2026 00:54:19 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242643381sm45565725ad.5.2026.03.29.00.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 00:54:18 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v2] mm/damon: add synchronous commit for commit_inputs
Date: Sun, 29 Mar 2026 15:54:15 +0800
Message-ID: <20260329075415.36775-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 982D54000B
X-Stat-Signature: ubuw3kwtqd5zqe6bcey8x5pt78mj75sh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774770860-770043
X-HE-Meta: U2FsdGVkX19vQM/R4e2pxIj/+Xl3n3KAuyJBDC4lVvSUxbE8UDlSRn2OhlTxVn8GEc/jgOmjQVCyjcuGoBOJgwp22rp2xVFQ7/9Cw1WPBRgNpB6mNHlZZhkn/rd7FgW88dOqsHxEtZAFtDvEArH0Nz3BgYALeHUWfUmyrOzxNoEjQfVZpSMLykS+DtLGEFK1nFV+DsjVJnrkd4ViQnYLlAqsF39y/8vkLVPZl4nca5JPBzw8GV9yZwi30/weYgOWkkDoOhOT7Lq7l1dfg7T8Vl62NUiBoMK19cVaqodoBy9VZsFJpJCahbkcGDTmath5Ubpeqglbe6nNPEwmCOHrrqn72wdzH4xuI9dtr5Kg8Ts13V3bFW2EctjXbsZUnY41f1UEFDrjCRzslctz6ZnCEBU4aFbtljeHdfMSPkK+GaRAwJVbrZiZkbM7JV3co5VRW5U0zUxSKOHaVvUQhpOQrfllJZFDV8KyyEuJXz5sAkiuc+w8rg0O4QD8uCIOd3f2Z3GDGzpJ0Zf6O/crAqmsr2Md8wwEqrgcBHkLCCAzeu2M3pxua8J6mneBAf9grZqliQJoivtLEQiziW2e6IqKeVVz3ocZQpvrdxFXqgwOvfmtfKGAspvcx/bKyatdGa24ZO2DVNMw+IgRbgP2rbi83FhatbyHzvvmElPeT51/t2EPusSJOfuDlACCd+q5Br8HOTe+m8ooEsNadQmrRC5E3FnvlR5Q1V3lJ2kTdCWW3cgtyY3EnAFAKV1wauwN7aGxp4ikCfRHN6s6JDHP/R3oHE3qOdY5xAnGlubGzM/nfZwfm4YPudZZ50q2QV0O13r1RwbfsIPxNt1MVh3l3s9QsmOqk77ce73P0gqrtdIuznYqO9hJJv3vpbvARDeuIl3ghYakb/TrjIhZGbA58tO67mCOAhDPvBNICvc9oywQJ8osgvif+qicmTswYVNUNdJdf39Zh86/7bZB9Vr1Y3w
 PCwWBJ8C
 40wV9pgYzZtue1qaC/WVTb3THTQ7jc4o26Fsqf6c+3K7KITZO20Wb/tzInEz43iPP1MkdAOZQXc84wf/FAbMQSVPVMCqPPaOQHsSzXxCyWYRbbqtHCwy6UB8mpnrFmMbazhFsSNaWECplxR6EYHb3bBkTGu4MUMxi08Cy3FGizCdySgqlXSqmcSYjBL/qLKVGJLuojeDJH3mKa0cY4Ff75YTzvLvqfV1RjxSZMYcA7o/SXPgRXv7pNfz7eFDa6dCOyvXDS0GISCrL1Zt19msBHfboXpePwmL5+iP0dxlxRUKqx2PEyWCOXpJ+WiZ0On4GvFahliBK+tn8VdAiFrGBjADvYRvJkDDkYMYZrprsP0rl2PtSw9U5j8kqvizeWt1muBxT+fJmrZnJiWIKwz7Y53sc5T5FNujoX6nwUHU56vLaULJOUPHd4C0EeeuO03hlcqxgtpx/Opq8yf/czZkCFooVyO41QOUpwwqvR6OVIWg1s/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
Changes from v1:
- Restore the KERNEL_PARAM_OPS_FL_NOARG flag to keep the compatibility.
- Link to V1: https://lore.kernel.org/20260328084524.5451-1-aethernet65535@gmail.com

Changes from RFC-v6:
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
index 554559d72976..641af42cc2d1 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Desired active to [in]active memory ratio in bp (1/10,000).
@@ -349,18 +348,51 @@ static int damon_lru_sort_apply_parameters(void)
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
@@ -374,7 +406,7 @@ static int damon_lru_sort_damon_call_fn(void *arg)
 			damon_lru_sort_cold_stat = s->stat;
 	}
 
-	return damon_lru_sort_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..31cf3c45dc72 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Time threshold for cold memory regions identification in microseconds.
@@ -255,18 +254,51 @@ static int damon_reclaim_apply_parameters(void)
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
@@ -276,7 +308,7 @@ static int damon_reclaim_damon_call_fn(void *arg)
 	damon_for_each_scheme(s, c)
 		damon_reclaim_stat = s->stat;
 
-	return damon_reclaim_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
-- 
2.53.0


