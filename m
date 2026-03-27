Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E3B10BA426
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9AFF6B008A; Fri, 27 Mar 2026 02:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4BC66B0098; Fri, 27 Mar 2026 02:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61916B009B; Fri, 27 Mar 2026 02:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C97206B008A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:26:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6579513C2ED
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:26:21 +0000 (UTC)
X-FDA: 84590858562.09.44ABC9A
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id A881FC000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:26:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ozE6aMoY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NWkXo7TpBrVMMy5Kx55dRavZnN42vKfpS/87hXsaheU=;
	b=oR1QZpQGx73O5TlHNSDrBKYkL8QPJLQoONCcsRsKvZuq2m6UzO85RPBxEO4z6z+ll2vgp6
	O6giJFVE8b5jSQORXhngwkhzN0d28D8SHijx14ACZRnhfvFrtH/SaCwkINH2fdtW/AIOmf
	dq4DtbpV2ZiJvttIRekPU1j9EQQglcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592779; a=rsa-sha256;
	cv=none;
	b=5j3u0yzTKBsBXE+1TnqPa6XbO5jPx3FZ0vDXCkPdOetw5LPHHc8wpZd6F5Z4ORGHd//Jj1
	qJRh0hKCGIr3amJtpp/zAKhm1c2H48H4HvuR8/LgX45hDdhKpalgM58Cyzsdz9sCJtV/qR
	TK4LynzSuUBRUnGu7O3te7ftS1PHtGE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ozE6aMoY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82c70e4654eso775974b3a.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774592778; x=1775197578; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NWkXo7TpBrVMMy5Kx55dRavZnN42vKfpS/87hXsaheU=;
        b=ozE6aMoY15MbNoY1Yuybx9b1KvrF6mIN+yuKPDdgW/T+xVrS14kr2alsvvoRaej8Ca
         cHpWXl4AVdevmZ8SdO0bXNxZ3XjkooaTQYb9cKT/w53Z3OVc46upLWPv08Vd4YXiFk5D
         o9sAA5Gj1ZnDk1SbU6WqZuFiK0t1frtpKqFCC7l2Z8kpGNp4T4wqZMabRLCTTWKE31Z6
         c+Xk71Wy2U6TGeSL2E9Mk5S5CxKcVJM95jpe5/Axp7V8mbuMPSiSsC+FEzFEQc44BbCy
         lDm1xDz69JdfiAboz2YfxlK2DR9A3i6IU5t5dMbBrDr3QsHfz0gDM7qpskACiSSoET9a
         FDkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774592778; x=1775197578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NWkXo7TpBrVMMy5Kx55dRavZnN42vKfpS/87hXsaheU=;
        b=XCmXcZ8vFdrcj+/W17fZZayLUwQJkP3Og6eWQ/0fJxiujiukXMKtJogvOl/euYhmRV
         CJL1fJUCnrSQLtISO29GU9GR/clMYpX2jjmuVEPLnrmtdeHpxZeqBlbFwzqP4nPB6wE2
         6++zcyfH/Zjz6GOxRLbASUtDuVwr/NhDY0icaWuC2Vez0ShLJ2Vmnbr/hdfLsCBrFF9f
         CHaR1Z0CpWtUBPqwfgzWaC5hSUMlN1S2RepVislJQVA7zehb2oDtrgSx/sQiM6t5lB1Z
         BZllQ16Dg9+QQGIKwD/3miSDPXtE1JVLMeUv5nTCLv1Q/mBjpWHh4Fq71mfWwNn8EP8y
         HlEQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0RpwveNkxghPrFE4Tne9e1XOVZHx4hF3s6X4RGtpVO8HdI+3IsAOu5iS11xKsnKZAc2SgfB+SIw==@kvack.org
X-Gm-Message-State: AOJu0Yy7QeVDCX529h7ldvHgpCuhTbs5OoM+xf+xeHwVXL4veXNGzVGF
	Bd7ADUt7iZ6SJNUooFnQ4fOzn0+pRz/X9Ym3iEkW3RGPTZ0arqnLPxZI
X-Gm-Gg: ATEYQzwQbtvZ3brgvEHo9Ke6Vl2g+d0W61Tw5Fe1kRQHk8IoPncgpVg5u81Ym4I61gQ
	3dFq3K/yUOPkrOZNUg1Gy9yg3ShHOpaWGwiQcjPk/P8EZqspZ/7hkTzkKNvDY7ZEhbii2Sj2x4o
	9JyUqR1zcSpevrZHsmZ+GDwlcQCzYm2CDlXJ3tSBmFPre+77ZnAbcfbee17XroiWB9Vpte4Ey2R
	lbDH1usGb0s+gtQG+SshPGHw9SSfcHpq7cO6dx4duITb49cz0mwSgBcOUsbbFuc7+JY59dmBbMK
	pHAnAON5Z34tUYjw2PYAG+MfADoy1qkRrnse181qrDQGEmsy2eUm1ZNCmytUC3F9BW2O5rI/Vhs
	fYyTgFNW7aSdLEKWtlfU+FXc5GOcFqUzXLb2AZt/i/2US+utpkonL9/N916qD3sh//wgEBSjvRu
	ph0mbPkUIYv/mV0MSdoGhxKVi5JsI=
X-Received: by 2002:a05:6a00:bc0b:b0:82a:6f69:7f7b with SMTP id d2e1a72fcca58-82c9600448fmr1313550b3a.37.1774592778348;
        Thu, 26 Mar 2026 23:26:18 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d216a8csm4548702b3a.16.2026.03.26.23.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 23:26:17 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC PATCH v6] mm/damon: add synchronous commit for commit_inputs
Date: Fri, 27 Mar 2026 14:25:58 +0800
Message-ID: <20260327062558.66392-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A881FC000A
X-Stat-Signature: 5fi76ue4m8zi6wpmwcec4cnbsk97cyx3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774592779-195838
X-HE-Meta: U2FsdGVkX1/6xxG44I8gE7L0yysv5k3zR4190skoNKu8erFXjwh7UCmy+LJZvbZqVZjFzUWmosTZLTrJKcq7bXDo+5bBL3cUQjAPhphUcGd98cg46Hc1dm4zPDqQ5oba8UT5BM5BoeDkBj+CysuGQlcKBjJhZlcRTRmqgjT+1YjXim4oWDWFhkH2iyzhcpTLGX5bUrBj+k1VnNC6g4yAbDe5+GAZqtfyvWmvg9L/BEqIYvSwZZuV6FfwxYkIuTjPdNNv0lGJlOdDiGAH5U+f2G/yqoUmCut/KrNGAfzrS2K51WNL7DBWaLYjvVdiXpoNma/sY9Znl1e4o+ECk/Lgxm/n3cY0eDDJtsO9O3NojFB7CpvlkVY0NCBK9mqgeYyMG0af/NRiFIpaSg+g/NV5BdXEc/1DrnwtX3OWiPB9YhXWebtjbNPrJuxpXkyBskRAL9D09xFp0ufyczIfjUXkwYlWrYzCCs7ZRzCjVBQGoI6yhwttKtKMkp+FkYyJ/1IXEsps6ngXxVnex8+X0788SdMEU55164LQgLvhGJbE7F+1SjTBNGZUXve57yRUrI9N83uXKBN6/LcV8EjPcFZZcvkp/S8h2wqdwSJN0lzaP3QlKLb07cA6BDuhcqw48SqBB4C4iZpjVx43TIb0QKTvETZFGIn5w7X3tc9Yo8JMADaEk8wVZ7fvDdekx1x7sebPsPBrGmv2KjUKjdO36i8037yy7YhgFruAdIayOGKVUV/O5p2a7o/kIPvCvz3bI9/2IZpCJjgCEgCc+428j+E4XlxoNH5zK20m2tRSBQC4RfFtUOKoeSOx+GJqe3iCWxyFyndbBq1ANYBixcVJuWlDxFERNuSZI0bPA6TWzSa2M3H2axbSTHQe2HEdopJRz9hq8NgNg4eegxwbb94oGiIdsV32Ko1VmF/58peym69ns9OJa8XHRrjQQO9upKTwYbai7IHLToIRfT4HDvgV7Ud
 zmIBev3s
 22KxLrEpH69FtRMhpjgFDLr4WAb1ThzucsjgSvpaezbQS5kdIBoP3wJLpKcmr3afHtXGBOaJWf+KOqlMhsti/oxqlAlTfXyKHIZFvTH9WStmMRRsR7laEGNwWUZudFRr2loZ4KvJA95NOAQRwXIpRowqZ958VO7tVDnQf4UXvWhTvg2Yb9F8KwU6E9q9Vw9caQUQqgLcVkLb47Vh2RxEguQgjRxu4hLNOYPYFLNiNT/FrgA/EBZHEQH2SQn8MZeUG54L06wL3OapACuunjcyYWWbcq4Jo09rEaS04cLWI0Andt6kGJhl+I/pN2PWG3stpVgUmX5acExA9qVXtVxTACF9PYGtox/1PonNQUPx4fBtgNYlQ40zEfX2yAE1HpLC9bPF4oPHMjiB6sr0mGSCFHl+z60w6OST9n0kPj4SzPBb7svTXC9TUXS8lALFay5jhWinafRhjTHvjjcnYhjCtYwenW/xgZZ8xlr7q0pNZ0UVUDUY=
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
Changes from RFC-v5:
- Removed unnecessary assignment in commit_inputs_store().
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

 mm/damon/lru_sort.c | 42 +++++++++++++++++++++++++++++++++++-------
 mm/damon/reclaim.c  | 42 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 70 insertions(+), 14 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..453033f3cb3e 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Desired active to [in]active memory ratio in bp (1/10,000).
@@ -349,18 +348,47 @@ static int damon_lru_sort_apply_parameters(void)
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
+	bool commit_inputs_request;
 	int err;
+	struct damon_call_control control = {
+		.fn = damon_lru_sort_commit_inputs_fn,
+		.repeat = false,
+	};
 
-	if (!commit_inputs)
+	err = kstrtobool(val, &commit_inputs_request);
+	if (err)
+		return err;
+
+	if (!commit_inputs_request)
 		return 0;
 
-	err = damon_lru_sort_apply_parameters();
-	commit_inputs = false;
-	return err;
+	/*
+	 * Skip damon_call() during early boot or when kdamond is
+	 * not running to avoid NULL pointer dereference.
+	 */
+	if (!ctx)
+		return -EINVAL;
+
+	err = damon_call(ctx, &control);
+
+	return control.return_code;
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
@@ -374,7 +402,7 @@ static int damon_lru_sort_damon_call_fn(void *arg)
 			damon_lru_sort_cold_stat = s->stat;
 	}
 
-	return damon_lru_sort_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..03e3300ce607 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Time threshold for cold memory regions identification in microseconds.
@@ -255,18 +254,47 @@ static int damon_reclaim_apply_parameters(void)
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
+	bool commit_inputs_request;
 	int err;
+	struct damon_call_control control = {
+		.fn = damon_reclaim_commit_inputs_fn,
+		.repeat = false,
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
+	 * Skip damon_call() during early boot or when kdamond is
+	 * not running to avoid NULL pointer dereference.
+	 */
+	if (!ctx)
+		return -EINVAL;
+
+	err = damon_call(ctx, &control);
+
+	return control.return_code;
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
@@ -276,7 +304,7 @@ static int damon_reclaim_damon_call_fn(void *arg)
 	damon_for_each_scheme(s, c)
 		damon_reclaim_stat = s->stat;
 
-	return damon_reclaim_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
-- 
2.53.0


