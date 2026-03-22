Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25C15D58CA3
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 23:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68D846B0005; Sun, 22 Mar 2026 19:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617416B0088; Sun, 22 Mar 2026 19:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507176B0089; Sun, 22 Mar 2026 19:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FEDE6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:15:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6E101B8C36
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 23:15:30 +0000 (UTC)
X-FDA: 84575257620.02.6BA4D84
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 26E0A80010
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 23:15:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bFYkdh59;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774221329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=As5XgDr7xQm/xLgUgi0Yg0ks7rPFLaYaanrZmVlDo8c=;
	b=Kv6406IIrtcX5LiV8ov/EMAuX4t9DvGKaZpgYqdw0yG0FTTiPl8rh23AawUvUomcxvPrSy
	bPyhXiTy47taNWLm4xqBG18ZUJ0+VjhFXVCaC6pa1wofkZfsOHEDrVpVAs9r8tRIlEUMpg
	aXmYL5hoKiMrY7jhb8aHSfwL97LK4Qw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bFYkdh59;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774221329; a=rsa-sha256;
	cv=none;
	b=xo7WnT9DSAWpKx3iu1zhn6UWZhGasx0il4oBstkLpScTGrtQ2RVVKzduxWZ0ihNE5AyZki
	gEW47+mgLWHZLJv2BzzY02HXCHoxIn9mkpBzJ+RNB/Xd6WSWSXUOVxbdMMdTocyoS14ZtL
	NsDrGHbOS7NJa23VZnAdyva9sr5D5DE=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35b905a05a8so1987251a91.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774221328; x=1774826128; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=As5XgDr7xQm/xLgUgi0Yg0ks7rPFLaYaanrZmVlDo8c=;
        b=bFYkdh59w3hBkGyoFmE3IbMOh9hoOm6G9Tz/bVjNSDwxD6QAkg1wIaiWe++iZWPlsk
         eKZXe0U+yWAVcn7ZlFtfjwayYKPi7L6GX6MGHp0SjlPe4L+w3ZYsCofyTGYw9nMbNTsS
         owjyoduQWVXTdXKjyo2f8Rbxef7U131SlCM8e+lr8GR+vD9lZS1gNBWJeAJ4a4xcqlkP
         kUpZzfgrB1IPksJKGpalC42i/pVHC062bEWIXZJ1FQp4Ts+0YVhjC4C9im2RGr5s+Du6
         ZkYrzhCOJVTsS79vu6qhgqxtFg9p7A1bVNECopwMNWvo/llvOem5D1hulc++Wx1+n7Dd
         OAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774221328; x=1774826128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=As5XgDr7xQm/xLgUgi0Yg0ks7rPFLaYaanrZmVlDo8c=;
        b=Oo8X3M07AA4JFLz3hbSJ5X8pynjWfisXsYA5yNzIvOLVypEkSjfnG4lxzNPUL/sxEp
         vstLQKm/f63pbFrwHyiyiLzfnBa61ZqZrH1Z2qnRWDhds7z1uYYGIwoEPjckXcrFgW6d
         XhPCGhez5+xwua7TN/FrWe1ieFJPQly3/0eY5CVoJqiNTbDX8nZ0yXCKuEc+Gy15QfLE
         F+flNHTrPzDtD264RycZzP/WfCcAAR1CV9MOpasyAENNPsGaxvLVtJ4ahXUQgHNezw+n
         Xr8hS1H2VyVqtvN+JKcN5XLWx5ETpDlY/RslIviI74ZRlVAkH2i1V3tlzZFqVcLSQKiN
         tq/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXJtXRrf0+IwaaUTF4bGMEEaIHZDf39xUFwTQbn7eA5LUUDkJpv+H79LX5orjI7/b466tL0tqXEkQ==@kvack.org
X-Gm-Message-State: AOJu0YygHZnYD2NhUWiuOznMYyQ3qAXJBQnsgzn0TJsPT0rwJSqFA/gv
	wwWuB6dLeebiYclGA00gSxPzCx7TpVwqhFFMv34BSZRtOZhq09sZOP0P9uXQig==
X-Gm-Gg: ATEYQzz+A/7fP4/i3RDsAgRRtdPzk/+qZWRajjF8TgyfbDilpp1z7UbKWnfeqtI+ydi
	1i2nIARNBcfMvXyKrs4QFC/YvlYRVe/tnSZUpU0pNW2tiuZnmpVKywNPvAVIXBcFdO0nFSSe7Ae
	EMkqFgGSWsL/jMd6CUSBQXgDS7t2RK+pt+pCFM3f4/mcnW4VKNCYxfQeUxV3mommEJjWQqeaRWE
	l7ZppxFOkRPHzkGpdlOTWadCUMEH/WsJnRGl7k/X8z+8WwbGYNpWzFbOy9FhskYbosDjFfNjra3
	VY7MQJtJdyIjUzegXctSMiaPc8DRY2YE6x1DXZ5o/ScbkzQH9ovnVwWAcZhosl3LocKG0JVSvOR
	27Mbw8eLbN+HsoAnL6iqvtng4XwrL4wDlXiiuF4fo2R9sw6M+3WTuj3wsAJkT+kTKJD+EYtFYnv
	XsB6B90ADKPHPIthTmBdnkV3GlebM=
X-Received: by 2002:a17:90b:5108:b0:35b:9cd5:232e with SMTP id 98e67ed59e1d1-35bd2ce4493mr9099147a91.29.1774221327912;
        Sun, 22 Mar 2026 16:15:27 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd3eb467fsm7529611a91.3.2026.03.22.16.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 16:15:27 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC v3] mm/damon: add synchronous commit for commit_inputs
Date: Mon, 23 Mar 2026 07:15:22 +0800
Message-ID: <20260322231522.32700-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wzmfqd48w347jemhukxuxhp1r74mgujh
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 26E0A80010
X-HE-Tag: 1774221328-939044
X-HE-Meta: U2FsdGVkX1/UAhLmmIeqQ36TQi8W/57HcVcdL3zSFNXxUAbpdCUI21MokBrPu61Z1plNIPIiHglCoNiT6yyQM0G3mhqqPEsOF70o37sOHMFyockIxFRgrSdWBLDeN9hMBmvJPUxm+lahknwIHYi8ImjChvoPgoRzZGdZ0gdw+OB4/PEqLp080L6+FkYffUpJcHZKDdrY7wkE2DeOaiGHlwE9LO0+4SshvAfXXEtu9uwygbKKE7WRPai9HwazVeWFBY2VT2hVwF6B0er3nRsvdLHZb0q1w5hgvP+MHA3a6aqeHUVjCS0GSltfbSfDMpgfzPDW0DmANXTldEXhaxP5UNpQX+FzsC5TpOmrki/NjQByuXYfRVgYDraQgbm36liGvRxk2iwij0hx6E1JVQ9PVDgWxQ9Ryk0sISH93L0BaDqZ5uchsnItjvxk8HyOhCtE1Ms9GlpgEtyrlqO1oDAdN7Vn308X3mvqM+MZiJdZ/o5htd2BMojybBuvWAm9Xe7VAN8TNJcdI7V8jd+3NQtpnHzVnVRFrvS8wl+VQX2PGBJ9kzZBHA9DTqqc4Ix2GOhe9QdTkvM9BJ0EvuAwhXL8n0kZb4CwOPy9sTLMFZGtq/3xbtx2UN/+JGlizYSC9XiXCnskXvM0mI2EdBHf4VffQmczc3bmvDcbByi1eQ7GpkEDkxZAuiCTb4dEYoLcjAM7734OvIxhwi40jgqB39rr/8qoW8pSWqHjRy9BCWy7r7VFURKpzfAt/IGbBDgjxiAPbqU1liRgpAf3kfaj3gjJF1yS1yRhmroW23Zp5LhuVyL7DQZHwASrgAotja8D/2bE22HuAHwtL8hYNCT/J8BQDWnESwZVNG9R7knANMzohNZ2YBu2OGvrdix1PszTeFE22LZzvbR26CXHELF1/BXYTcVplak3G3U7fxymKIHGdlbPtSmSETWnF/861e7IjAw4xnkTOkw32HJBeDkzXsH
 H9qp63Hz
 p+K0kCHDoVt3ROiw5aACmNtc8oxRonx51uGEvtSEqDECUMKXaFa/EnQsJ9/U/TRtDepA4fRKUdwJa7OadPlMfJ2ld4QOGf8Ok+CT4/PrYu+e1QsrtmWpAsCoNNyfK7LKqo0MIGAiy1k9f39xa1gaQIA3/ajb+RNyAIQF7CCmZM4zYm7vLP4J+ymCo3rg/gwWlTjqVyDeih4WmspJk+XAL5ouYJ9Hi3SlxGUEJ2OwElX3Yk91AAEd6zWClpidXjYUHAno6tPFoYi8ktMPJkht4qUeeqAWFRyGZtOlvjlFyJmf6hgnCK+Yn9GHgFMvgP3P4+o4VCl2xRI7WIZoVujdzq7HIavEIqF7WZBRAreDAU2wkrvDsfO2gFGy5NmTE8fvfkAfuTe4YzT4c2LCTXZNuKGu97Q8CRkrDZfJtr58zeqMopiWwEjtFl3310n+c0bbS8a7ufO4TvYsEi33Gix9z9fqGmW1ZCZNN94sVM156fiwGcKg=
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

This change is motivated from another discussion [1].

[1] https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
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

 mm/damon/lru_sort.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 mm/damon/reclaim.c  | 42 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..445e7aa19366 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Desired active to [in]active memory ratio in bp (1/10,000).
@@ -361,6 +360,47 @@ static int damon_lru_sort_handle_commit_inputs(void)
 	return err;
 }
 
+static int damon_lru_sort_commit_inputs_fn(void *arg)
+{
+	return damon_lru_sort_apply_parameters();
+}
+
+static int damon_lru_sort_commit_inputs_store(const char *val,
+		const struct kernel_param *kp)
+{
+	bool yes;
+	int err;
+	struct damon_call_control control = {
+		.fn = damon_lru_sort_commit_inputs_fn,
+		.data = ctx,
+		.repeat = false,
+	};
+
+	err = kstrtobool(val, &yes);
+	if (err)
+		return err;
+
+	if (commit_inputs == yes)
+		return 0;
+
+	if (!yes) {
+		commit_inputs = false;
+		return 0;
+	}
+
+	err = damon_call(ctx, &control);
+	if (err)
+		return err;
+	return control.return_code;
+}
+
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
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..5d0c02d4ff74 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Time threshold for cold memory regions identification in microseconds.
@@ -267,6 +266,47 @@ static int damon_reclaim_handle_commit_inputs(void)
 	return err;
 }
 
+static int damon_reclaim_commit_inputs_fn(void *arg)
+{
+	return damon_reclaim_apply_parameters();
+}
+
+static int damon_reclaim_commit_inputs_store(const char *val,
+		const struct kernel_param *kp)
+{
+	bool yes;
+	int err;
+	struct damon_call_control control = {
+		.fn = damon_reclaim_commit_inputs_fn,
+		.data = ctx,
+		.repeat = false,
+	};
+
+	err = kstrtobool(val, &yes);
+	if (err)
+		return err;
+
+	if (commit_inputs == yes)
+		return 0;
+
+	if (!yes) {
+		commit_inputs = false;
+		return 0;
+	}
+
+	err = damon_call(ctx, &control);
+	if (err)
+		return err;
+	return control.return_code;
+}
+
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
-- 
2.53.0


