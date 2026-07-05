Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C90B2C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 15:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18DA36B00A3; Sun,  5 Jul 2026 11:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C89F6B00A6; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D776B00A5; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C04C86B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 485B440139
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:08 +0000 (UTC)
X-FDA: 84955174416.07.49419DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A66441A0005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mk/O8iFD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783266966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLtPouv7eTzT2uQvAh/J7SZwGEEh8mUIs2EK62lyYMI=;
	b=wBSa3RebLRxMoVJmljYF4Vb7sYodiPZquoehN6eC+d6EwYsvz4diwWRlaLsmNb2w+18D8h
	5KffGtbrTlLMaN/8+mQ/yZFYkrkLCx2lWECsFmqrw6gopboYVbziNKoF+qedTuHGAkNjKX
	KesNuao+0nhCTi+YlDUOOL7v82y9aso=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mk/O8iFD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783266966;
	b=jKpOC/XMK1kOueq6njUtV3zAk/ZoFAoxMn3IqJOB4O56tu8wgaGN2nqFF1DGih6MAGsO+K
	XvOOuOqX5kVyp65XymKhu4gRDuQAeOWLPdVCwt1RZ9k+KeyYiIUCNOrlp6cYP0hYA5K1Sd
	aNBRc3CQ0CiH09dXOTcmxvvCJWyUokQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E340B4371E;
	Sun,  5 Jul 2026 15:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCD61F00A3A;
	Sun,  5 Jul 2026 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783266965;
	bh=BLtPouv7eTzT2uQvAh/J7SZwGEEh8mUIs2EK62lyYMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mk/O8iFDdNVD0Yef/2LVjmu2HWYiuqOCV8S1zKGc6GFKRcbgyNdgz6eXfBGkeL7Nc
	 X6yz5iMICXoe8McGkuepKDBejOhRipUxq9vulFYOZvD2QpwxijDoRqznQDkSwSP9gq
	 Q+z24fSQqL7RetEpoSWcFZbXPKNkg6kbrvQHdH49AqVzDjj7AF59PhZvTSK63N9Qjf
	 JM85InUi/1PbiVO09FjsQ3tjJVBNdTL8svA64JNGGZj/4nxJsiBkADIIRqIrm5YDJs
	 9x595x+A0w2c6ZaPb7g7fw4GLwS2VdCxGl197rhSPgz5srcUauNaBQ/rk5pR1t5O0k
	 ImlIrpvGLcoYg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] mm/damon/sysfs: remove duplicated commit input validity check
Date: Sun,  5 Jul 2026 08:55:54 -0700
Message-ID: <20260705155600.96555-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705155600.96555-1-sj@kernel.org>
References: <20260705155600.96555-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A66441A0005
X-Stat-Signature: k6zqukukbujo9tgnetypi7oj6mj5pxjk
X-HE-Tag: 1783266966-771200
X-HE-Meta: U2FsdGVkX1/79zEhPrmIIcZKDQ64dyMD2LJuJzKsEXlws+O79m6pm/09YNC3U4fO9t8dSCWWxcpi27Fj2IlVH8/HsTT925W+dmbBZPgz31CZGf/ndRJsDv5lfWrmFYBMSxH0fu0YZrfaBqtdM1jtcoZCmmP+k2OmZw+QmGvFESaboTyePY0qQvnlg6gaS8x5yiurLfE/11h2s/SlC5bTXMVWo5SSsepvuUo8l37s3IyQWfVAURF2JZ/WmIeQnGmnYXjpAUobxQpPbfwRqk8Q8RWt+oner8dsXlWbD3zC9w2XWmwMVsoidIIfIhhYrBqMQfZIqTWsDjOzLQ7g5lbcrgMoUXd1QIXDPWZxOqnKpOXZCjKTSQUw13shS43eNo6H7E/DmFNOZtfhMCXtpDYqAO3ZhQ+2tEsu3OUbucTjEPJPHEWEbWuNeFCAU0mYtvCRsuakJ06RSV4QGvIUz6VNpxO+FfzFtU4C7AFnSkRRVq/7qajgvy5xIaI3MJFtokQ73qSRW2zHxVa7gZIFyxJTqXdPuLsCv347jK74ixDU94F8H34NsN2zDXTsvt7NbMXpOcQp4uHSVWVwE97mcFHfyqYmaMXpf0FfGUuouOe8s/UCdew1NssMN2bVhwGeAJt6qxfs7Z2MfVL5Vp94K09EqoB9vzwvlXiH1fgOt9RL9coa7xZqcXrltakGjKvuhChnEwtSr6U1mn1yNxDYG3u3FIWojVBz2DNv4NkIjGFpdN+di8ri6MK513B1EjqJEoUV+vzuJCFtByVU5Xv4Mj4nYI2SgwLKn578FAMhmo1ZWiDOVEbnzTFOCaF5jNqmzR3oHWKrHnBsjWg1KxO7pQzI3Ndi8J3ji0WHtGTD9mqtLoM9vbbp9MVzKV9o/tM44EZa1RKOjnm9pcXA2N0At9PV6r4sDf0cjWa9h66iHwGGVM73zDxG2kGmQ7DgzoF2PQfn6oKOhZO42Ss7+27tvMT
 Bh2qRnq5
 sc9G/2g4Alx9y9HMLURBXaQ9el3F0NtSl5O3hwOLDsSQzkji2wTUt4nz1ZySsTvdh2xMl8tajFlGIVtz2z0019w4OHm+tpGXb1fwH/CIegIGU46ITVDkbvpXfyEpYsXyv8H+dG6zCJJXfDdWlOXjrOOhod5+b8V42HOPepP0OHzBDqgsmtb1k64NOPIu5s6YXGjmZrX2xiP0SbHXDrq2W79iym0otZSvSfcw0baA5zA9yFWc=
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

