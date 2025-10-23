Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC9FCCCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453DC8E0016; Wed, 22 Oct 2025 21:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC6A8E0012; Wed, 22 Oct 2025 21:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D758E0016; Wed, 22 Oct 2025 21:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3A968E0012
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:25:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0EA514096F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:43 +0000 (UTC)
X-FDA: 84027636966.11.1F61BCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2E621180002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HM8SFIS3;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182742; a=rsa-sha256;
	cv=none;
	b=bxEMpFhTBO2+jZ270bphT45Pr8kbvbPJNTnEiMFmsOHSBKT6KuWrYBWyrcfD/zDFBHMAgl
	pedjBFqy8UkJyxMIjvI9m6aJuYEWAEjdk+XEyJ6lSTItjyfbS3V2sKnWLPLUZKiOBvWZCZ
	EfgMolAY11xNGtUwHPLs3cQjpW+FrJs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HM8SFIS3;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhgnbVdma+C1uN2sxR7Bem5A7NQgdVD3COKmQo4zXW4=;
	b=VD6WhkZprODyO5SlngA9uInkivJmZxsHdQwjAnJikUycmq8JtuWwuVjU8T24vTKI3QfjsO
	RrceL1er3z8OCtoPNxAvNLb0nvQxx5SpbG7GWjsG1Fl3COE2TUbo3c/WmHYZ2mDgvGCY5z
	wTB1wmiYfoFCY2LdSiaIBa0gE4e9s8Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 89CD360569;
	Thu, 23 Oct 2025 01:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC371C4CEE7;
	Thu, 23 Oct 2025 01:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761182741;
	bh=sIveTxFAmrzddRKi8UGGyF1J97Zrb1cqOFDFiER9cSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HM8SFIS37glHiSpFmmcjCYxkGIzcWJLAW1xXOKGA6QvV+lu7JWqE/pP/VgPmP49c1
	 ahyGOwmevRjt+r98YKnnHji/x5qUPLSP95ulLqbUr7LQaE2usaeQ2a7Y83tGITrAsZ
	 vsKqP6aVMRPcGiKwPl6N8P7BovPpJiEv1rfiEdqoqPZAm1K8PBvoDa2uwVwmDz/rQQ
	 j8dx444E5ElZgZI7wc9zeZAxwKL35uZ7csTMiR+e9bFEEA1JmH0GHRbb1IdxOe9rpz
	 ERIydzLaZ9sKGH/8hbTFm7Mx1Nv24LB+b6m2rXyXMBJmErGf9niof/gritKIxTl6s/
	 OCS7QhFL0mQYg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/9] mm/damon/sysfs: test commit input against realistic destination
Date: Wed, 22 Oct 2025 18:25:26 -0700
Message-ID: <20251023012535.69625-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023012535.69625-1-sj@kernel.org>
References: <20251023012535.69625-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zkmwtzrjepw7a86gbkie8g3enbnqy88h
X-Rspamd-Queue-Id: 2E621180002
X-Rspamd-Server: rspam09
X-HE-Tag: 1761182742-955000
X-HE-Meta: U2FsdGVkX1+5h3RKv+LCt3qrIZ52rMDYJpBGq0HV5cKvnqx8VkgWuRAt037995x8mNBGdgwKAO0ms8OL4eQVMIQ3UowoWYHfbaSnN+PNAb/r7tA8xNtEaheFv/KQSv2jr8UUDuSpELCMA681OULIcNlsIbYOGkFHHMQDfY+l6bgdK6DPx20WWwqEFWuQHae2rDg2Lvf1oX0/1UcO2UnrCCUsEmycMmOV7zHJYYQxtnH9fCZ5n7Ot0PJFDimjDeoETDvv18mRIAzg8sqIM5fWjWaj+8Xn7fpwcLk1YwTF/w86SOo4w7lZhhVIfpaY0oWE96Q48W6ngiqqZDb5U1UghYkgWI3NQSiGyOTHMrDT8JowRXJHQhtQ5SA6sqqv6J6WMFcQvZUBacOd5gl2P4+NyxDTtgWdO61+B6LBO6fWwRRYX+YruLC1VwEyHP9tiw28Ge52cC/LsbSQDDyijnhzpt7forustrZykYTce3TVxFFZD4JKGlQIz4FsMWZ+QOxPNd70jS/jO05XIT/HdAQ/rmvrgN6xKzom8iNH6P9OrIH5bkFl7hJ1aTBsum3SJJlu+QcCJ+92lQTXgNNyjxvAjpE4mz+PfmolHMrZMXc2LkJ93nXxDD60xgWSo8XRJ7Jz8fwSlVBi2Sgo2L6U5ZdxpAXv7YIcin/0Xeim/v18tdCw7qI6d/c8jOHnhyuWSTgqpL+0Li/LfdGmlbrf70LZy7YtNN/HlVDul5XM8ZH34Q2NbTBHh9brOH5WMnAt/5q8tjyG3GMzbRCrzSVQzKBBmXskeJnNovLO2GmOujaneYWUBZ69EuTMYJ6PGodHWok67hOwfMQIPED6u8uoW5fn2ainqYpJzoVUjDFeujl+Y0ijIWVnUm1T28EXus7+LsU6LDtUwFVeGPMDW8CxCaAlqWLibyk9XGFIa7RSqoXWGnnlbOU8zeRrBAF03IrNeDVEEWhEexXPwr/h0+HeiTv
 gz7KULx2
 4ay+fKIEIRNwh0Q5koALuq2cY4oviPZs4J8VEk6V4Y21LNDRUEXyFFAdEjGYa1mrRuqOBN0FkIj5Q0wCuroOYND4llh2x6SpA/xxmSwL17W0/e75wnfeGFL+8fI9XnZdIUQ/4ksEPu7uJ1LpR01giQGnfBVwDAjXeRhhnxZDxg3EGuFccCkN8drfriRWRYu+Kwj5y7hXaM1QdiUtIyGyAZs6pk389A2h+KH1FbCR4Egs9BUKGMiKhw2qPkqsgFS9e+XOV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface tests if given online parameters update request is
valid, by committing those using the DAMON kernel API, to a test-purpose
destination context.  The test-purpose destination context is
constructed using damon_new_ctx(), so it has no target, no scheme.

If a source target has the obsolete field set, the test-purpose commit
will fail because damon_commit_targets() fails when there is a source
obsolete target that cannot find its matching destination target.  DAMON
sysfs interface is not letting users set the field for now, so there is
no problem.  However, the following commit will support that.  Also
there could be similar future changes that making commit fails based on
current context structure.

Make the test purpose commit destination context similar to the current
running one, by committing the running one to the test purpose context,
before doing the real test-purpose commit.

Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Bijan Tabatabai <bijan311@gmail.com>
---
 mm/damon/sysfs.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ccfb624a94b8..0fe6ea68d311 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1451,6 +1451,26 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 static struct damon_ctx *damon_sysfs_build_ctx(
 		struct damon_sysfs_context *sys_ctx);
 
+/*
+ * Return a new damon_ctx for testing new parameters to commit.
+ */
+static struct damon_ctx *damon_sysfs_new_test_ctx(
+		struct damon_ctx *running_ctx)
+{
+	struct damon_ctx *test_ctx;
+	int err;
+
+	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return NULL;
+	err = damon_commit_ctx(test_ctx, running_ctx);
+	if (err) {
+		damon_destroy_ctx(test_ctx);
+		return NULL;
+	}
+	return test_ctx;
+}
+
 /*
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
  * @kdamond:	The kobject wrapper for the associated kdamond.
@@ -1472,7 +1492,7 @@ static int damon_sysfs_commit_input(void *data)
 	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
-	test_ctx = damon_new_ctx();
+	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
 	if (!test_ctx)
 		return -ENOMEM;
 	err = damon_commit_ctx(test_ctx, param_ctx);
-- 
2.47.3

