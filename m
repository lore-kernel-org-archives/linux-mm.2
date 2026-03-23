Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB29D58CBE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 02:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0246A6B0005; Sun, 22 Mar 2026 22:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17BC6B0088; Sun, 22 Mar 2026 22:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06146B0089; Sun, 22 Mar 2026 22:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBDCD6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:16:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C68E5B9B1
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:16:56 +0000 (UTC)
X-FDA: 84575714832.16.6FF24C0
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 75C3720004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:16:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jgS7oDoC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774232214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aD2K9zVwkcG/aoV5QlS2HrGagpzh6CFCZ3rQ7wiRaPA=;
	b=zKU+ew3+Ub/ZOzZHP1Pq/urKbD4P9et6kkw09sG8HogcWLHin+SL426Wm55DmCy8Fb2zQd
	sqaUcR7ASYrvNNyTm0FdjJjpk6dlDfYOIHhmVNjsUjdeyIaGpvIs21Zp9DvfCuV9+2lUAj
	g16zlKwkkKOTx+l3VVpuC/yg267d2Ek=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jgS7oDoC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774232214; a=rsa-sha256;
	cv=none;
	b=Dd9P0NpZoakbnG5oFUUFaWAQyaeLxfvQsAJ08HZx+l8sBxTMtGDhbt0VtZygQ0nBkHUb7B
	zf238oIBOwlyypViyoLtvWIgMZD+h6fD09JcNyWp+NsT79HMhFqm8lnhQXh6XgI08jGn87
	e6OCaY55rrHevXJnw6ZfIcyF3PLBtFA=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c757a9251faso815148a12.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774232213; x=1774837013; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aD2K9zVwkcG/aoV5QlS2HrGagpzh6CFCZ3rQ7wiRaPA=;
        b=jgS7oDoCaA1ZPSBtEN487tB+KN3AZCgsAOiD3pXW76AHE3/jGwHvTwLPQRmMRggRmw
         JX5FnWLtCUiZnaIW735u9te0lSTZpcEgifaOF777Bv++odFy5BQA8nd8+GhHEVrrYj/4
         hyahNTNs/PzDEDkMedbs3qnZEb1LQoBX10VOMhZn+CVremOtFkKeJtrcMu+emVXpAMEr
         xH3IdN1Ph8O2jsDNAawd2u+ME0wG714a1WxOzF9uiQNaiENoGjvhDZj/ZhAmXHD95uBq
         FbReTBanS5BtpEg/cr7asdPHrXkka866HKe4dWt6IlrSu/VHhn9AgOgfx9+AaYpJy7Go
         P/nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774232213; x=1774837013;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aD2K9zVwkcG/aoV5QlS2HrGagpzh6CFCZ3rQ7wiRaPA=;
        b=iNXLtEmJ7yNzcFvN/ACpufVpjbMb8M3JV1Qz6AsBM0maTqPjJQZP7hW3reqS30F3KF
         CCBDANFUqXncXNuhsn6z53acjkldN2ztDByYc6KTcCPz9VofLvbIltcgmUTQotVkBzHB
         fXximmFjkNQgypXcry5DawcGp7nA1hwgBS5ANvMflyUMdWs5yHrirRI/2DVntQWKJl9V
         4VduTcaghXSzTnACEq4iCeB4nSFiZnVETneR08GfP8jQFOTngTjHPF74icswHwGAoNji
         A/FpCCoAbF3jE3Zrwxp2Q1C1KhFbuDogqI0VEOj56pv8C+V6vIfL18A7j8uHUmCL3qdG
         qdmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVI0BHPEbTc9S2yGl1rGGnJ8DaksVwklTM7l4jvH6iWR8QJUTYzPE4MOERA9LlxkQTFLrtYtzojgQ==@kvack.org
X-Gm-Message-State: AOJu0YyimOUqBkNwv5HGijYwqgTjsYp305JaFoUbtAh1Hbn+UhkFeEvf
	c1uy3KbVS61MCNXfvxZy6tTv6Tdkpk4Gl3zLdAg7H4OsbfSq2QDqsAkT
X-Gm-Gg: ATEYQzw1E8zdB1jf3A4XfgzfPcGqrAnU9Pden6QD/pSnA6alNCaWfoni7b/phtaG9ex
	rLzPcEPYnrgj2MSpmdSwjYqZdBTmFmOM9ocvdTxcWXC/YA1rvh9OO2Q7QyAsErSPX1/J5VwqtVv
	Rn54dbcgMDS56fMjrNbrCBxsC43013AneAin6ghRSwUY6zFW4ghPcMUS/GRVH9kmptY/7Vqw2AI
	cnr9ODaOx2r78wVlGWfVgtJIAcVIgJkwQIXNHrWF7QDix9ggB38fEyZ8hVw1XB9WcXJxqo8fzCH
	YjLf4/lXrBxDrm3trZwRXZtdrA1mrGUG35bx7qm7Ki5DhAUx6M5fxlmua8Ekkv3Dx30I9ou9LEe
	LYi0hnv9a5lgXYS2mh0Y0Y9Nq/FXSjUtO57uhW22lCleg1nYtirHr219QPDk2vK81ALSp3FAmf+
	BQXCVevhi6HY/K3MQddxDGXnbStuOCCnnuWIdTe5aPqwRFtx/gaApCQl2lsbeHdA==
X-Received: by 2002:a17:902:f60a:b0:2b0:9a61:9e9 with SMTP id d9443c01a7336-2b09a611475mr19378405ad.32.1774232213156;
        Sun, 22 Mar 2026 19:16:53 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083655474sm114373405ad.48.2026.03.22.19.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 19:16:52 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC v4] mm/damon: add synchronous commit for commit_inputs
Date: Mon, 23 Mar 2026 10:16:48 +0800
Message-ID: <20260323021648.6590-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 75C3720004
X-Stat-Signature: 19uxja3ked5s7thwusqmgbnsrxd675gc
X-Rspam-User: 
X-HE-Tag: 1774232214-878184
X-HE-Meta: U2FsdGVkX1+gchs76EgUI4EFjFGqBycxQcOgrFbXML3blkbIGXYc3jZrRJJrs7mrq43CH2EVSbFA2G525LCdtdFw9CX7DN3tfBHDmAm4QhQrJ1NphYkvPkxmBQS8P0Vxuu1HcQ1swqkUCau8ZoxwfwIB9k7SDsOq/jBXFIS+DN6dWATC9hWu/ucdXRGwuQt08PO+HafmJAochlBgZ7/fC/tskMQjxYmKFUJXoz96Gj/i2GiXSyAPG0L6z0pvXsPRdgohWHJ+4emeyKH4up27WoUrd8CAErlcW01xAQTjln6TdLqFxiao4MBnlkUEqIlziiJkTTUbjJZbLAt3IJzDUr+Zb0HlLZW8kR3bPljehXMvrAU4+Iho0eGRXMMH4iEe+iQvCVaZLjFCiBgDWZdrRtVNLvcvp1q3bMWdJw6Q6vAO2qMiYMMytsFbPpopOq3eGXopvj4E2usroPX9ywOJSgzB8U8MW+kLMlgaY4kIURZtcx9mYwIuZFkgYGS0HCz5G9mdrT92j6HADZOuYyE7cNM3NBcZXrfb9vq418LXn0pab6t/j3Io0PqqY294DvOKHQViO1mhHSmlNw7eDCQqsrjJ3jyHDTdk1BEEUuGG6iXQ/sREEV6XtECyuz1xo5VBURvMMsRP3GNvgNl7G3mV6AlRTY8f+pOdW2D/3m/t3pA4JcBnRD1JcPgZCCvGI+3OnTYuOWYmsvb80bII23Bchy1JyTbuMK/DqWTq8xAEtHOMjFS+QyObjVPTRyFqI5UXB+OwkLcWqJvzI/BCyDYJPEDYThZ9e86/CsCrY2kHy+NzZ0g15ZpZh+wLlPCe5E2rHnYwkH4RY4mjmvRXdHZFExMiyR/7m7ZLmMyDcg4TO5QLXz3aoHYhZH6kw3iv5d/7xRye8rqjc7ifmCjGTZxCuUyDyOFPpidG+iF4/IVv70nU8Ku/Tl8HfKyS8UU/T7YN+5nkRrKtdtjucDOrdA/
 +qMmbPqI
 AVmyOm/hBaN47UOrHrpPOCJrfzkoNkby1hxgLnQNxC+SpJ5q0X+CmA7aGljUD/o5/lrc2+Ysdqa55a/8S8MpnfnOaChKd0ZoGbI8LIdyA2EA1oyGEQip/qD+fgtZm7F6DPhSk1xpV77hC8ebzfna0mHK3Ui6THb9DbA54VH9A3L5GfnNO6WMGvy8jFKjMamE/DFKXS1JIEg+IdSU0v9/Cp7Jro+ro2BWK8q2HmtDbTMASkLqTCFmoQdmVsjfW3aH4zdWNFMQpdnxs7TtjKmUyZ1RJJU55AcJsK7t1jfVpB/V1awF4g/dYmyJMZ/OrVRUzB4nR9wMEFEeZbfMXg6MLllPnc13C8fyxXh1OkiNU+kAYFdVyciaFAk/OiOh4xjkNpPOYMhSkVubFD2BkYeiOGRxkFc13fCnyv0V3A5qldqtL+oNxX00CS3VbwBoK8tPQismtAKFdFON2IiS+6kWuwRN4cqz4qBf178ciFQNaebCkewc=
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

 mm/damon/lru_sort.c | 49 +++++++++++++++++++++++++++++++++++++++------
 mm/damon/reclaim.c  | 49 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 86 insertions(+), 12 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..37b3c897e822 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Desired active to [in]active memory ratio in bp (1/10,000).
@@ -349,18 +348,56 @@ static int damon_lru_sort_apply_parameters(void)
 	return err;
 }
 
-static int damon_lru_sort_handle_commit_inputs(void)
+static int damon_lru_sort_commit_inputs_fn(void *arg)
 {
+	return damon_lru_sort_apply_parameters();
+}
+
+static int damon_lru_sort_commit_inputs_store(const char *val,
+		const struct kernel_param *kp)
+{
+	bool yes;
 	int err;
+	struct damon_call_control control = {
+		.fn = damon_lru_sort_commit_inputs_fn,
+		.data = ctx,
+		.repeat = false,
+	};
 
-	if (!commit_inputs)
+	err = kstrtobool(val, &yes);
+	if (err)
+		return err;
+
+	if (commit_inputs == yes)
 		return 0;
 
-	err = damon_lru_sort_apply_parameters();
+	if (!yes) {
+		commit_inputs = false;
+		return 0;
+	}
+
+	commit_inputs = yes;
+
+	/*
+	 * Skip damon_call() during early boot or when kdamond is idle
+	 * to avoid NULL pointer dereference or unexpected -EINVAL.
+	 */
+	if (!ctx || !damon_is_running(ctx))
+		return 0;
+
+	err = damon_call(ctx, &control);
 	commit_inputs = false;
-	return err;
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
@@ -374,7 +411,7 @@ static int damon_lru_sort_damon_call_fn(void *arg)
 			damon_lru_sort_cold_stat = s->stat;
 	}
 
-	return damon_lru_sort_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..441d5d9f9eab 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Time threshold for cold memory regions identification in microseconds.
@@ -255,18 +254,56 @@ static int damon_reclaim_apply_parameters(void)
 	return err;
 }
 
-static int damon_reclaim_handle_commit_inputs(void)
+static int damon_reclaim_commit_inputs_fn(void *arg)
 {
+	return damon_reclaim_apply_parameters();
+}
+
+static int damon_reclaim_commit_inputs_store(const char *val,
+		const struct kernel_param *kp)
+{
+	bool yes;
 	int err;
+	struct damon_call_control control = {
+		.fn = damon_reclaim_commit_inputs_fn,
+		.data = ctx,
+		.repeat = false,
+	};
 
-	if (!commit_inputs)
+	err = kstrtobool(val, &yes);
+	if (err)
+		return err;
+
+	if (commit_inputs == yes)
 		return 0;
 
-	err = damon_reclaim_apply_parameters();
+	if (!yes) {
+		commit_inputs = false;
+		return 0;
+	}
+
+	commit_inputs = yes;
+
+	/*
+	 * Skip damon_call() during early boot or when kdamond is idle
+	 * to avoid NULL pointer dereference or unexpected -EINVAL.
+	 */
+	if (!ctx || !damon_is_running(ctx))
+		return 0;
+
+	err = damon_call(ctx, &control);
 	commit_inputs = false;
-	return err;
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
@@ -276,7 +313,7 @@ static int damon_reclaim_damon_call_fn(void *arg)
 	damon_for_each_scheme(s, c)
 		damon_reclaim_stat = s->stat;
 
-	return damon_reclaim_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
-- 
2.53.0


