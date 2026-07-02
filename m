Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4511C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87276B011F; Thu,  2 Jul 2026 20:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5FEB6B0120; Thu,  2 Jul 2026 20:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76AA6B0121; Thu,  2 Jul 2026 20:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FCA56B011F
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:44:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C34A1402BE
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:13 +0000 (UTC)
X-FDA: 84945069426.25.7D87DD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8DCC640008
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MLqHNiG4;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783026371;
	b=GEmPnKznOoTl7QyNGJxEwdkRskQrf0bAo8g9236lUIQpFFSJcM8vrcL3AZEW/Tye+YgR2W
	cc1htCyhnjjOANduizYNoQrrsMZTXAjmJnX1FkMqmNMNyNQEDxWkbnkAwqBV9A1APVJaLK
	izgiC7UKbm1wP6WQghlOrTC66/j4u3U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783026371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLtPouv7eTzT2uQvAh/J7SZwGEEh8mUIs2EK62lyYMI=;
	b=OIQIzkhC2TBNpm5N5fV0ZFkIN35LPOvtln0P04j/seJxf+DvuIkyoMc8kMLNUf7mMpz9eL
	RTGNqQgcU0AyTeDFhc6fsSeL5fl8bj5X0nHE1siMGslWUKBpjbGhPauZXxH+molPFqEgWu
	pBZH6QozOg7cw1q8hJoinJ5vqYjiT7E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MLqHNiG4;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE6B043E6E;
	Thu,  2 Jul 2026 21:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9790E1F000E9;
	Thu,  2 Jul 2026 21:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783026370;
	bh=BLtPouv7eTzT2uQvAh/J7SZwGEEh8mUIs2EK62lyYMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLqHNiG4jTmma0r/z+ODi+4wtFuUkemyhU31jRk1mdVXizhYqIKdcBvWtEe7oCXHY
	 VAXS0VjqDCoWF9CYda3W96GxclBPydKhQ1mXAAbrRsvoGO5z58Gx2SNGPTl61cP4o+
	 YjNucIClMnYAs1Qgtk1gGmlZTwvcDa2herfCwNATqffW2TXPn6iCXS3dzUhewHA4pw
	 9FfEFyrZ4Z7ik+fVzzllJr24CXzjiLxDbeEKPXL5GRqEq/N4ZCI1uexU+1ul67WW83
	 h6EXWhOh6MKVK0jR5KxQ1QPOD6E21g0JD5rYJDhiMz/SB0lPEp8DDeO50FfqJ68Ytw
	 TgSkeBsjFacJQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 3/8] mm/damon/sysfs: remove duplicated commit input validity check
Date: Thu,  2 Jul 2026 14:05:45 -0700
Message-ID: <20260702210551.95167-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702210551.95167-1-sj@kernel.org>
References: <20260702210551.95167-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8DCC640008
X-Stat-Signature: ejfss3hpjswz45jaggcruzqdzspomgs1
X-Rspam-User: 
X-HE-Tag: 1783026371-656546
X-HE-Meta: U2FsdGVkX1//i00egR5oVAKG3h0H5OyClTsUf9MtDTrQjT4cl4VVCGVsh4uUN25bLL4x/yTWodPX8VTpFr8irq2q0lTPAHNPm34ExI+O/RGTxyRkmjP4pYv87wq98aQwU2b97nURUFuqFmvHCEzAwmPqaF8TEDHwpxUTnlb6x9VmUH3+sIGv9k72XqxtRY0GVswcZHwFk2CfZQx3avM6DituV/Vb/CN7E854lpuDk2jbXMP2iYOtXrqW0ShmVLbRIOZFN3iufa3TgdZJ3rwF/F9ujgYaFr1oThDpt+9/54QgYac32id5qAoB+/AFd9N4xOhuYTRTMbzYVB4R+nIs6jTGYFjYeVm/HzLZTuMAg99GDHzibyiCmxZw3UTMONDnERmbS8cBCufq2lEX3ArHHRhDHvm8V+hudor4j4hVJDV9RcIiKVn8QrdI41tdSw4jm9Ocf33ghPKZMyrGhc1p7+oH1Zkiydt8bVKPtCYs5QECgwDCNndJETEaUoJ6MPUWCMYN77U40fp7QWuuZWDPlcec9cj4jYldmG7Zt1QyDl+ysHW9AsQgNE6q6yS/JgJPl/Fo03xnPNSLmCb5t8ZQKgtIGGtCOVCjXBKk5wdbcXE0c7WTNJs1sIxt7VVyK/c5B87F++x0x0PzO71VNBPF4c1T+DuIGjXG64/JL7scVoWYw8thGlkZaHzrl1wsuitllGbvHLCIBQMzi2i5/Vd2myQD2GwPnsjjmx0UvLliSVPfwYvQPXSJKMXsuM05NzRqEDXhKjC+GXjcUvQ8+fgv9ArrQ/TkX+J3WHn7nm4NhMyxfUY+8o1dSSLCkprUCoD7FES1ITp7jjCP2Om4L9FWy7IwVg9bq/hkflXJgiHvjp6bMmWZCyjFNJ/CaZW/pX1n+3S/zXf9lakC1xNV9mis/mhCF17K5cad3FytBSIzmcRVnM6VPsig5CtyVBhQwsyaTsOSPHfb9G4/lT1GxTM
 KLLTu+N/
 zf8f+mLt5JNQdoG1UYS4hVDhXaMy+MDopsXhF1kG6lS7IrRqttR35O/usEXR+ORSab96QHC2QYTw6InIS193RcINlTMUrGXiwqQ5+vlCtRE4AnuxXdYlYXGqcHEmroYBXkKoBFv3Xu0EWjl8yCMUybgZYmaflO997ADqdhIi4BN8gWBMlJFWQDb+cgCPINALh72Ei7gZkdt822awWCFMSyB19VASBr8uvMYAU+Rr1nKX0LUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface does parameters validation-purpose
damon_commit_ctx() calls for parameters update.  Now the same logic is
embedded inside damon_commit_ctx() itself.  Hence, the validation in
DAMON sysfs interface is just an unnecessary duplicate.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6710b6d019bf5..e666dddf1feba 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2098,26 +2098,6 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 static struct damon_ctx *damon_sysfs_build_ctx(
 		struct damon_sysfs_context *sys_ctx);
 
-/*
- * Return a new damon_ctx for testing new parameters to commit.
- */
-static struct damon_ctx *damon_sysfs_new_test_ctx(
-		struct damon_ctx *running_ctx)
-{
-	struct damon_ctx *test_ctx;
-	int err;
-
-	test_ctx = damon_new_ctx();
-	if (!test_ctx)
-		return NULL;
-	err = damon_commit_ctx(test_ctx, running_ctx);
-	if (err) {
-		damon_destroy_ctx(test_ctx);
-		return NULL;
-	}
-	return test_ctx;
-}
-
 /*
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
  * @kdamond:	The kobject wrapper for the associated kdamond.
@@ -2127,7 +2107,7 @@ static struct damon_ctx *damon_sysfs_new_test_ctx(
 static int damon_sysfs_commit_input(void *data)
 {
 	struct damon_sysfs_kdamond *kdamond = data;
-	struct damon_ctx *param_ctx, *test_ctx;
+	struct damon_ctx *param_ctx;
 	int err;
 
 	if (!damon_sysfs_kdamond_running(kdamond))
@@ -2139,17 +2119,7 @@ static int damon_sysfs_commit_input(void *data)
 	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
-	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
-	if (!test_ctx) {
-		damon_destroy_ctx(param_ctx);
-		return -ENOMEM;
-	}
-	err = damon_commit_ctx(test_ctx, param_ctx);
-	if (err)
-		goto out;
 	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
-out:
-	damon_destroy_ctx(test_ctx);
 	damon_destroy_ctx(param_ctx);
 	return err;
 }
-- 
2.47.3

