Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CEE1090248
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F38C6B0518; Thu, 19 Mar 2026 11:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A7C6B051A; Thu, 19 Mar 2026 11:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DD46B051B; Thu, 19 Mar 2026 11:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2AE46B0518
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:57:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA8101DD5C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:57:59 +0000 (UTC)
X-FDA: 84563268678.14.B96239B
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf17.hostedemail.com (Postfix) with ESMTP id A8BC54000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:57:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=JVCDBSfA;
	spf=pass (imf17.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773935878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5AmYxxKHBGd/h651de89e6e2kJ78xirvBMwkGyS3mk=;
	b=49gVGQ6JWa5bjyRew0yXB9BFdUnl2XuHTSngt7VFJt5Hv5vDyIpRbOdhOeCLaCpf8uDUja
	liITKG1QEpPxPdrKYYYFLQGVJlG4bCCIboF7vPzlNzUgDnbwus2/jgwmWFo6qvNRY0RlTd
	qh6vY4tP2dSGTRHdcyJtkfZPs7xTT9U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773935878; a=rsa-sha256;
	cv=pass;
	b=AMrHqXQLwp3c9ex4GBsx363+XT2jcWg30G9DJO/2vA8CgzN47f8www8zzolF5JU2BcX4FS
	puS1MQuUAdFauC8HqK4UsYChJl0m7XNhuCJ1a23/ZcQLEX+smloTp7Zwi2INg4qKn28xPX
	2KHFFayE6pfbRntJNN/R4GGL3G8KRMs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=JVCDBSfA;
	spf=pass (imf17.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1773935866; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=GRatP3d9VlCUG70BsMCn+vXrEYY6ePXsuhRMhOrtaHeJIxDIlpbqqpV0uEeToDuih4Z/C2Eposf22r0wYxK1QAwO7fT5m6FFh8gETb10RzqRlx//aUszSy+VCgu7jUfc17GjK5x3hRTQPNC04Z0gAr+BSUe5pWw8EIdVqHRKDm0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773935866; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=v5AmYxxKHBGd/h651de89e6e2kJ78xirvBMwkGyS3mk=; 
	b=HLXvfFaBe1yN5XE8N/YilHHHLadNleS6Uyg7HhD3F6XuN6C5QdDu7g+wQvI2lTHsu/3V7NY92+6CDJFYDuzNkCuYQcTdXuoPp8syzgUzQSAx1X98o6hcvfXP3/nAjtBbN3BD8Qu11EasO+hIxexkIqfCVxhIX/nNevmi2E4VguI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773935866;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=v5AmYxxKHBGd/h651de89e6e2kJ78xirvBMwkGyS3mk=;
	b=JVCDBSfAiVHrSuC+3mrtKDb3s9WsLv/TB2XPrVOzeSSN3bIjQNnhGKx5KA8DEjE9
	MVazrdud5+ssU3Zsg9+mL8v/DxLSY/f0/X5BOfijQpY77Z0fG1V/ZrPr/F5Mgy/QgiH
	sASkwAYOBZ5TfTuBGSjxvLw+et6CioUMv4f3IV9Y=
Received: by mx.zoho.eu with SMTPS id 1773935864833351.06425221152233;
	Thu, 19 Mar 2026 16:57:44 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 1/4] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Thu, 19 Mar 2026 15:57:39 +0000
Message-Id: <20260319155742.186627-2-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319155742.186627-1-objecting@objecting.org>
References: <20260319155742.186627-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A8BC54000B
X-Stat-Signature: ubqd51nwko4n6pg8uxmwa87kux769zgy
X-HE-Tag: 1773935877-231082
X-HE-Meta: U2FsdGVkX19Z6apSrA7rwDgIoWio2HRlLN061giATAwWgScnyw4cOyINqQ1zWN9AWTFjQyizYEuT0I102kpJ4oDIdYo681hkXZA2W18P5c5MitnD1Bp6FvrSYMvBX6SSkfYrKBvfvReiKptYIHJ31EJVsJ0/Bw5nODjiFXDhPnhbLv77yQflKTUttWiyXgebR1euz20Q57ZhOZadIfv1zbdKsICJzdznEW5pSSDaI08TYfj5gB3Vm/oQiSB8UQRXwiSopptMnbwLQ+TOAPfRk8HpFuXcDvtdOC0ZncJV1e63tSksqM8xLOyy50LSp+VEiCSOusmz1e4U0fdKNBkOMOwxe+XVYmKfUBgjllDJwrHehseBZVWyMLSWCSS4AU0HKHJyhQMV4C+XR1uoBjVwEJ9L5Gi62QD6XD2+VV0NyePNYlqwF5e1zinCkC0F7ygO0T4dm+b5fwIuFcNP4b6WACzNq1sYz+eeuejwtVSvP1ff6q6Jhzt2xZZs/BA/gQJrkmfAvZ5myRwwOfOfMbcJLbaj3yBDwAwLhqvEpEB9y6QpQOnh3DpbyE0zGe43iLuF5uDaD5eh63o7r+6V8uP4qZniVIBoP95Uk1sQavQpi1/T1p5//DEQmargyJ9PCWHDDLZAj/QoYg1scAC7zWX5b7LL0ixQSwro4ItI+932zKS/Ins0xjGfpyw9dl2s0h7IrVrDtGXlnhX7iKFglrt/mvG5Qaadvdttls85QRH7C0zpoGSBz8IEr0AwVIk3OA+9Pd3/Nq3YeTZKBfWK3WVnB0FB2eTAXCEuZuHtf9syMDnBCmc9Co2jiAUSP34t0aFZSXCscKfJpucKOt6riSCx5PSgpkj+kt+q2ySFPEOjgxJc+7yvC9dfv5h7gQ9xr/C+NSD+mcGTtsIFmURaGkiIcrpfPbJ2Xse6hEyYhyIBFRM7+O565Eq6PH7etc9SlPvhOYI3jFMHn4jR1ixMJmF
 GIlClS9u
 eIScyuk0a0C+jJpnugIE8171RU+7CeJSn5PqId34tj+6gPTxbr8yVCFbwQDeT2Sb5eaKo+loub9LcB9J4/i+r9PJj2UK4PZv1Q6ZX31FfjKeZ5ONftub8h7Kb72rzGK+9J9lYIR+RaU4ls/TQOvb7NANAF1pSoNxx6h59OtCMt+seosebYFFO/vC/AYgR7BP6SHx1erYYg3QfQxacTMR/BiNYprdygBUTAre/OkEaov63MKmIh3n1akKphdw17NSs1mVjShg6DsTxifpsbjgOH/snQ5PCjIqj96YEN5S6MDSUvnHK6TF3EP2uCUf7HcaNReUP+p+Bh/QW+VP8K1rTtlJLu+3DuVcx6l04FG3eUXvInSyqVkvaX0e4l5IaZfnq3nBpTS0UqPoKnr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When damon_sysfs_new_test_ctx() fails in damon_sysfs_commit_input(),
param_ctx is leaked because the early return skips the cleanup at the
out label. Destroy param_ctx before returning.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 576d1ddd736b..b573b9d60784 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1524,8 +1524,10 @@ static int damon_sysfs_commit_input(void *data)
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
-	if (!test_ctx)
+	if (!test_ctx) {
+		damon_destroy_ctx(param_ctx);
 		return -ENOMEM;
+	}
 	err = damon_commit_ctx(test_ctx, param_ctx);
 	if (err)
 		goto out;
-- 
2.34.1


