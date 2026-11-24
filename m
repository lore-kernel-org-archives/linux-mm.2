Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BBF9606A331
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KPi+q1Tc
Received: by kanga.kvack.org (Postfix)
	id E75116B0750; Tue, 24 Nov 2026 10:30:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFEB76B0751; Tue, 24 Nov 2026 10:30:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6FE6B0752; Tue, 24 Nov 2026 10:30:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 872816B0750
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:30:36 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 097E1C0C11
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:30:36 +0000 (UTC)
X-FDA: 85470399672.17.0DB43DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 30C262000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:30:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KPi+q1Tc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534234;
	b=C7H1e5cH7UV3q6P9ILmSBhzbVKAVhc0d4ma5lf6Gx1z5j2LOrN9vy8SPxAWBt0ElpB/Orj
	eDurSa5bAHEhCDggkvO9eax/xQK7tE3Gyulr2xghQeRTERnLSzDHmqASLvk9A7UfOMGwl6
	GjQ9Rx39dn8X2bGhxQGKZD/GclAnwcU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VqeTp+8dmN7UADd/YQEmvCTwc4psl0zm6amATEWXmw=;
	b=t+h32FmlONrI7erOTbD2G5EHtUNNLngC6jIll5g7pRvFNTqfSY0+Udw2qj6VV3UUeYPXGc
	WHeju7uc1oXuf9wHXy1jXMYATYwPjVMc98E2da98beOE7l01bEbjtouICIaFsGHAWRU9Gs
	wQDe86btRWP+rO4+0/9dYlwL0WDmEIM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KPi+q1Tc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DBB662713;
	Tue, 24 Nov 2026 15:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5694C1F0093C;
	Tue, 24 Nov 2026 15:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534232;
	bh=7VqeTp+8dmN7UADd/YQEmvCTwc4psl0zm6amATEWXmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPi+q1TcfEnO+g4sjKqUzjApmnS260AuE8cvRp+z3Jf1sC/rkMlhbY946zPxyr2Q8
	 zEjWI32tTY3/z3BRWgfRyjUqRzcwpZMCIyfPKxbnxkrZS1FTx2/T9edFlRLU2aifb1
	 DOvBg+haxxeE/4u8Xlj4BInkEOUPHeyQ02JZFg1gOLxTu0ABbMUXCMYCxO+tJjmx2C
	 Qw6DwoxhDLaTIZhdGFuhN/XJHBGxMajQ95qz1fwcCrRDUgclS3fep3RVmUrgcl52P7
	 iDWzDk8QfAheox1gL+208oWfqXZB6BYFkPSHXvb1erOE85q2sT63oMqrmCSIMIQ2Zk
	 FCUDf094wV5+w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH 4/4] mm/damon/tests/core-kunit: add test for damon_call()
Date: Tue, 24 Nov 2026 07:30:20 -0800
Message-ID: <20261124153021.90142-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153021.90142-1-sj@kernel.org>
References: <20261124153021.90142-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 30C262000B
X-Stat-Signature: dibfxz6oqzwxkwamc87ips4zrgaohqqh
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795534233-897408
X-HE-Meta: U2FsdGVkX1/k9TOjo3lnHzwrqAua20zuureJew49qBfTw395sabmQolCmnYXVRB2I0RHJkPXbhn8AL1ZBwflf83ILtTWwOEwaN2IHiuuaRMt+vkaW/4ZJKCdOwdGpbOoe1ly8FEIXpzIKw5eW8+tfHyszGT6dvD6dwrgEYKQGfaHYe3WNHuyRNBC7lVCdaEnEiYmnOrHIhpCUlBPKHulosTV8NN4liY3hMETit5TZaDBRJE+wygc8M3vjZrvE6+Awqh+HBnzeX221Oq3ej9EFjREG7SBr+3yPV3kppic4ON2hgMrU37PEr5dMBaIr/0uq/GXBchOTwXpE9hwwCLlNVvPRk5nQmvUiegcENFRn5c5ed5ndGgHNpGULGOVgQrMIfiEkFJf6cvR4p6Jqzsm387ehTA/EHTWznDsA0UbCtuWiprWt6Daf2m6Rwk1MMjCFxOxAqh0qwNeiGZliixQ1Lf65CAtwA/nFaUDFkCxceyD77uNDeWl5hGIfgF614XWZxemQipoH3GKkIlp6YX7P8pgbIiqfJCPcll5E44BuZtxuCq0RO/0M8H2O4i22hXgm0NKK4pPpETDngM2/UWgl43tLj5igv2aRJhipjNz30NGq2x69lYxmo+xzLkzdbyNkeylXV7TQCRR1cppkbN9xYr6/9dFiocfD2Ogo0VtL+JP6S3+uzIRIGp+idYQ6W/KAZ8uhjEqBJs/w/AATKfTl98i57ah47iG9UQLZMiYwsK1++D+OhMpwSRHoEcrY4iX97H2t//QKmJ2TQOvq2Vy1LvwmQ13jF+KEEPwS4gGOxM3NoyIB+szJHuod/+XqkmaCd8oGcHnAiHXHx5zwcGmU4v7h5uJ5whQ6rO9fsHCnDFoCokwClOcn4otX/8eeoEv9U2fffF9CugtO3S3bOKAyT6jMLPkBM0KGOX7FtHUI3Lw3tIME+QPuQ3/GnULxj3fM9Xi8CRVhZ8HTJCJA+Q
 5MuIv41o
 LomAk5rVtgh6jr7JabPBHvy28Z6R7JOjXmFxgPYEcwq7q9aQkv8zwsNrYsnSgs1HWs9NDl4l8yhD2XSaOkX62Caro2mPznqcSZ0/AnENTeigMf2BGXIS15LVNIhFn7m10Q8UmJarO8qFTm5i0AvU7YNbqQ4j3pqiT6SxyO/O1k26nIP3NktxuC0uphO6vUjX1wPQIxKRd022r6vvP2krBZXmauvDkdi7Or5Z40QzfLhMuHpYp7m4LAW0fgz6pjzczk7E77D7zSGlyUDst5cYxSR3RbJ2E5PQkFIMFbIruc0OCWClg4VJ+RoytOqrLqoFsQiLj38pNk0syMVb7mFasQg1ekKpKur3w29WN4N0ZfyEP8yJNjjYr21IqT/Sir/eceakkWVbmJ3XQoErlemIyjq8wAzf8uZvgmC3rqsvFPUzIWnfXukLxj7LCue1oq/P0XJoueQsHG7nhipVWrXOIxpbpojQuxEuitIvOK7U3o/wnlnCcjMPulyWTxqMF+OjzsdygliRzoIBNJqYPD7OG2Gsf6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>

A newly allocated damon_ctx has call_controls_obsolete set, meaning no
kdamond is available to handle call requests.  damon_call() should
return -ECANCELED in that case instead of queueing the request and
waiting forever.  When call_controls_obsolete is unset and
damon_call_control->repeat is set, damon_call() should return 0
without waiting for kdamond.  Add a kunit test for the two cases.

Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/20261118063755.37749-1-saileshnandanavanam@gmail.com
- Collect R-b: from SJ.
- Rebase to the latest mm-new.
Changes from v1
(https://lore.kernel.org/20261117172219.26725-1-saileshnandanavanam@gmail.com,
 https://lore.kernel.org/20261117174834.29182-1-saileshnandanavanam@gmail.com)
- Merge the two tests into damon_test_call().
- Drop the list_empty()/call_controls.next expectations.
- Drop list_del() on the stack-allocated control.
- Post as a single patch.

 mm/damon/tests/core-kunit.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a27545602680a..4446574a35652 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -2724,6 +2724,27 @@ static void damos_test_sz_ops_filter_passed_last(struct kunit *test)
 	damon_destroy_ctx(c);
 }
 
+static void damon_test_call(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_call_control control = {};
+	int ret;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
+	ret = damon_call(ctx, &control);
+	KUNIT_EXPECT_EQ(test, ret, -ECANCELED);
+
+	ctx->call_controls_obsolete = false;
+	control.repeat = true;
+	ret = damon_call(ctx, &control);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -2771,6 +2792,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_esz_goal_temporal),
 	KUNIT_CASE(damon_test_last_region_quota_reset),
 	KUNIT_CASE(damos_test_sz_ops_filter_passed_last),
+	KUNIT_CASE(damon_test_call),
 	{},
 };
 
-- 
2.47.3

