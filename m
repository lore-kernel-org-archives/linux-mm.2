Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8666F10F2878
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 08:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962086B008C; Sat, 28 Mar 2026 04:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939A66B0095; Sat, 28 Mar 2026 04:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876A16B0096; Sat, 28 Mar 2026 04:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 765816B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:45:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4B8613C7F9
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 08:45:31 +0000 (UTC)
X-FDA: 84594838062.17.7EE92A8
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 06B4E4000C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 08:45:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OpkZs/Me";
	spf=pass (imf27.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774687530; a=rsa-sha256;
	cv=none;
	b=qszM3RUjx8gwSqnBVn/FTIVZ59Mt9fy0DalYTwMTN6BahYU+AJyH3TH7Qc9ybPGKdn6pBX
	yPGVUxRy7+tHku3KfZojpDoKle5KBq2PaTFoz7nbYwsewVSU0VHXQ38/A9jjxEbycbw3k3
	h58W/8S8q6UKjkStU4qpHBwb/hV+xAc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774687530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ni1twoNTLjGzercFouj5YOFeuaTQAAHlu1t1B6ZMur8=;
	b=Yg4b5KtFu3UKW4EmzD4a+k2v3aFvt3oKD32VUHgot585nOWjMktXi4PUX+lDH7tbGIu+nZ
	SAwYY70nFgZZPU9xX0QaI5IrbeogZ1FSZpZALikWm73qCya02J442sRkz7GdvydXkbQMPx
	wJgh1OPd/hAMT6cdbhyQc/VphkFcqfY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OpkZs/Me";
	spf=pass (imf27.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8298fad2063so1691695b3a.3
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 01:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774687529; x=1775292329; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ni1twoNTLjGzercFouj5YOFeuaTQAAHlu1t1B6ZMur8=;
        b=OpkZs/MeUqL+rCMkr1F+6uWD/qUa2LBqTcrpLfzoZoyRjwGu4Wz3pXw9ZHV+7rV+b6
         +28oc9aq7VUG7wExDlc4khmUreOp7CVm5Qul5YhLfsUu5K6AfA7ahsEUSDTSdctwDA0g
         JhnI64VVWERh6C00vnY3iD9V7QoyUQS6gUDPQTN0sd9NREPbNigux75EJc7nqEcPu5nu
         X4CCg92M3ea7Kk0HTC+E11LxcvYS9L312HD+FntFi22EeByWKKWng9e1IaFRPVDPI0AW
         hOtgVCltjcT+kptHjYHBK6RvQ0M99KGTAgazRbxzW/+9Dhu/Ha3x/9fYdcGU69ZBzr1P
         46Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774687529; x=1775292329;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ni1twoNTLjGzercFouj5YOFeuaTQAAHlu1t1B6ZMur8=;
        b=DWwkC7DbVVy+4saXJqRk/vy1Y2RuC1IjLP6C3PaUvUEUryfvRHJDA4kzTbsWncbbJ0
         w1l4YwBDW47mIr35JAaosuRaLDIC30ol53pXCT5URroxa0wTmU2lYSdijEXV7wk13ORx
         raNZ3jlz8XJEEQzOrI+GJRHZS+sox6xgNdL5dETN3wyhyFkGtJvpC3V0uHia+VIB81+z
         h7b+s6s7VoJauZaHNqiXgdwdiNLF0FgFls0m3cmouZFSUQ+cOmcSzP1V8c6iYEp8ro97
         C/Nvz3P+XGu8zP2m9hxoJ8BnW+eUQcTDrFsHZ7QX30q40mLXea50l1UMHjslEt4EPLdx
         fM2w==
X-Forwarded-Encrypted: i=1; AJvYcCWSZXacX9qC8zQ4g/BZw31DZotzGWCvBuZjpVLMT2CLXRQuEov6yZSrTKZEz6zQ93gm8tDjl6mAtQ==@kvack.org
X-Gm-Message-State: AOJu0YydhcfizqSlW0s7EEy12j3G+8MxaO5oDRfuxua2W/Fgzq+Urf9c
	Usz9e3cO0ezSolfaRZAPPapkTCCxhYIepTtqS/MF/QBqj41qcE0gvryv
X-Gm-Gg: ATEYQzzXdamXlbzQcClgW1DfyORZo/b4tzE2d0W7wAOxi04k6+KrWOJ6SAZTjGTXHXy
	BhzEincHZ6fDWmkc2JEmE45Em8zEZdH0GxhkofA7iesDhTP9woCzW/Yj1+SU71WRB+6/d0SGx19
	svE/yW9TkXlIDxBDDZdqPvdUYh87o+nA9PF/VE94XZZ9UatBL59+rPtJaZ4H7heg8BgxiGhwmtx
	NYFrlcNmxCUAZ65Dl2dM548txLwMCttydJ7IzY2eIZpJlQDloSP2AAEL8Dy7Ob2J77RfYJGe0lQ
	i5i/orV7ppVmHvxNTjzx9upMw8EsCKCVeLguhBepmQogl3HohQReXQMMQiln7GcHa07k3m25/Iq
	F/eJa7c2OjTa4mf7FwHGTsXKaGPlxM9yZox92SPkdH+hBCDd7AgEVIyh8i/Qo7CVE7FSQfnwY7x
	2sfRCqtwp/kxHarWZCNkQWod8UZAuNzOPe03Er0vGCd1DIyqdOntrgafnXTjeNvA==
X-Received: by 2002:a05:6a00:aa03:b0:82c:75df:10ab with SMTP id d2e1a72fcca58-82c960d66a6mr5138693b3a.58.1774687528624;
        Sat, 28 Mar 2026 01:45:28 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca8628f39sm1464054b3a.58.2026.03.28.01.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 01:45:28 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH] mm/damon: add synchronous commit for commit_inputs
Date: Sat, 28 Mar 2026 16:45:24 +0800
Message-ID: <20260328084524.5451-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 06B4E4000C
X-Stat-Signature: apqc436mfjoaap3b33q4bicny4zxcrrt
X-HE-Tag: 1774687529-186843
X-HE-Meta: U2FsdGVkX18QMKli7nWyTK+AFxLsejQ9G3U37Xb21297uDa0olqfyVEKZtT51qugTB/Oo7Y6ehjzll0WgKP2FFhRlOdlAFPYflWACdrReACKtcVl0RDeNAkbj8GD6QKAXc6f+xnVCJ6rN3d86/mEk7n/dTAyRMZoAD2bKL1rShSjgb2AVAGQlu8KtQATKocKEJXPIF0ay07TOL3azXy9qwA3MSNTg6zgCdpfVCssKGQbQPU2EFd+5QK1mmh01Nn44yP50FoXB1kUJqMIIRPBgzP3B700KvXfCH362VtCkrIs+5nCRi+epJ6dcm3O3DER6Ths0OG86WCyDE99zg4WYICx/vIfZkMgKWoc+eUrgQlkBSS2Q3A18KoIzFOSP9xRPS7ihmqi3mTpTUxD52aVWeWXvSI/U71SlwOa2m9LeUD6f256i/T/g78+d8/hl4CnNjsDE3/e+Fsxlbm57sG4NLP/2IOvBdTZrhLgRkp7hCUw1/DpYvArxdU6nTikK/Y2yIAM97UEcIbDjEP52tNaFSy8Z2Un3c6zCSYZzmWLX2E9obe13WLhwuVhfk19GXk54nAAmppioKfBJZ8j2aLEB7rTkAbQ1+9G/s8cU2im73hQFRDwiw3Mr5rqPJOPHQCSFU3vxhlZ3EUfsv1WLpOu9pzqTQhPwgzu5kirXFGDw069iIQukhr6JgXN5gizckGBgNj84qlZ7WtItEaAKXkPUgOUIz4NgQDdRd/aKLuDlMEVfcqo4v6j3ZxZrPSl+t2UbQEnYrK7kMpBF9CCMmVcTx+52uDhyYZS3nV9ZWAcIFPTeLKoqu1Zy9m1c+CJfM9O2rbfqe6y8FeZtPGazPuMKKd5gI3cm68rX/SIOHNlZm6Q06x/UuMYvN33eTmJSRb9OalUokKkgijgtiw/RV2Eq4iuFsYyvNr79poRBfofE7tJ3tIslSeYXHmQqNgTibm6HB6w8XjOJfHEPaDo8Ko
 1lEB17Si
 Nn5kXIGESE/ASPdF4IsgjvseTqmgFgWHSARXSrPySKOvNWe8nStjzFpq4Nq0tve7HFQ7/yPnj6NcGGZSE83UfLQlw4pCK+OeK3mBbTr7yxn0PXg9sTYMJw4VyLFIykgtK7ftwQqCFTF5GhXIAr3DxO+RsM+M1EOgzkQo6k2XEYK4OmXGxT7Pr0dVmEZffXje+DAzvjFFt4dJqqBKqef0VrLIJqDRpbjWpUKPaaU/zdN7ZVqaUPsmYW49vOKEAPWr/P4N+g/lN0syY6C/+EBNRY7ZfJj1X3DyNTTTUy8KBk90Db7l/nnNIymsPVqNhQV3s1BDh7eJDaMfqrfO4fuOj34pi+rLeDaW11LJlu9igQKDkj1W62+VPqxymIuBa3iGekkG5ZzV1KUWYrYGyDpM+E1dht0rInrZPwpN0R1repCdFfcsm1RVrGm/YNWcQBwaPDk+3oyKYq6G497ksZx5+orONDCFGMVXPgUI6FWEF64dsAJE=
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

 mm/damon/lru_sort.c | 41 ++++++++++++++++++++++++++++++++++-------
 mm/damon/reclaim.c  | 41 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 68 insertions(+), 14 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..3af6854ba3da 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Desired active to [in]active memory ratio in bp (1/10,000).
@@ -349,18 +348,46 @@ static int damon_lru_sort_apply_parameters(void)
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
+	err = kstrtobool(val, &commit_inputs_request);
+	if (err)
+		return err;
 
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
+	.set = damon_lru_sort_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_lru_sort_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
@@ -374,7 +401,7 @@ static int damon_lru_sort_damon_call_fn(void *arg)
 			damon_lru_sort_cold_stat = s->stat;
 	}
 
-	return damon_lru_sort_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..d8398161f091 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Time threshold for cold memory regions identification in microseconds.
@@ -255,18 +254,46 @@ static int damon_reclaim_apply_parameters(void)
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
+	err = kstrtobool(val, &commit_inputs_request);
+	if (err)
+		return err;
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
+	.set = damon_reclaim_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_reclaim_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
@@ -276,7 +303,7 @@ static int damon_reclaim_damon_call_fn(void *arg)
 	damon_for_each_scheme(s, c)
 		damon_reclaim_stat = s->stat;
 
-	return damon_reclaim_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
-- 
2.53.0


