Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2FD0606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 06:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x3kAHXJq
Received: by kanga.kvack.org (Postfix)
	id A593F6B00EF; Wed, 18 Nov 2026 01:38:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A3F6B05B0; Wed, 18 Nov 2026 01:38:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB136B05B1; Wed, 18 Nov 2026 01:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66DD16B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:38:12 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA03D1405DD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:38:11 +0000 (UTC)
X-FDA: 85447285182.05.EB9E14A
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id 26B67180007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:38:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=x3kAHXJq;
	spf=pass (imf24.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794983890;
	b=b/zFQXBF7/kGIp6VMJjgbBUZN3csV5RoGQOoVxQvLPgB7VPLniCsBsOPr11yKeA7HLPN3m
	DAXsMnoLO+gZXguhoVl8VjnNyvcWHotkmgnLOt3mAN+kS7xnlVW9eSyZ3QYOZM9Mi7Ljl0
	bdhNaH2ByMFm0wMH4fmEwmv5EE0xVdQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=x3kAHXJq;
	spf=pass (imf24.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794983890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M1+qMsPy6fKyAjck+GZTx88ZCCPsYdHAFPCNWYPe8pw=;
	b=Ik4dc7n10mjyu/CtCnsWOXJR6I+Gvp4SHnmcovVRs1Y64FR2mKiyPD5yDX9i42FquY3ocR
	+wEUKHDWdSCtGuZ+OZhYo79RLa3s8S4sO/8OU9G6YR1Ffvo+DuqxmdRWtRDOLDjZqgtn8j
	hriLFDTyHSUa4AGV1Nu3axHEpZqJ8ks=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-382b463a972so42969eec.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794983889; x=1795588689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=M1+qMsPy6fKyAjck+GZTx88ZCCPsYdHAFPCNWYPe8pw=;
        b=x3kAHXJq1A6gl/8sHTLo+UjhpaSQRHv5AxrzpHtjFNBzHQWZT6euKN0x1oCXi4WFf3
         SVsOj5w2pf6VaMdJcTaTx95qgVhknm+lk4PLhs2ac6nYdLBmFH5pvzO3/ZV19n7b5JWD
         FvRUJVUtEJieMZAdvuB0YO/7J3U6ritm7f3JhPfchNswAhL4MW6WZS+4aXgRhuYWGEsZ
         EMYqpEKT1NkZZvcHAXO2hvsCe7Pla98k9XWuBLFRm13VHMbcSXW+1/O1wu0Fxge40M4l
         jxJd3C2BwwlA6K0qvGGzQ4+RCOOX74m7X7sK+HiccOqSQVn+8X5lWnFuRE0LrypfJnra
         SBeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794983889; x=1795588689;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M1+qMsPy6fKyAjck+GZTx88ZCCPsYdHAFPCNWYPe8pw=;
        b=KZqmibO5vzCvRNlXNw5o+MzpH4cRKPsdG5bhctCo8F+DELmoCzq71GWw5LpMSE5Cxg
         +CWPmb2DDp47MdzD5OzqqdWhSLL5dyQgonjh5nAQ/eTEZ+1zknEg2cBiqfls93a0i22J
         y1mu2gA2KJ5rbCKYYm/iQShOE2EfON/H4ggCubeZGoVdVwQqkqk14CjHplL3bvMNZ3Gi
         CE0L7kfA1LMI6LFG2992chzGMrLjnKvBy+3dJlTM2azd6cf3IfdjU6WI4RZJKyaxAfKF
         /heUrok/Vm2PrH9XvxuuXPSQYir/tJfzqPAJm5xg91DTxz4oY/3JXjD2rG2r2eD2UHyJ
         SdIA==
X-Forwarded-Encrypted: i=1; AL+hErHFoXQ7I6qp2G9SnWBYicUsJDlqgIZs2mNWXCRQ+M8LYxrs8ZeDzsXe4klHJnRDxHLjeSgStuHAfg==@kvack.org
X-Gm-Message-State: APuU4Z9apxF70OwrITAoqIvBMNHZ2/bmx0yCGCC0i/ISrEXssWdTde1u
	m/GFs6bQxjNCaczevmaY7eM/Dm3GnT0BcKIQPKV1wcmMu2vAmycSEhYt
X-Gm-Gg: AZFdTZcCIixDNJZTJIyjitXk85n1/nwsyJPe9acwO/KJqnJ3t7YAgzodWzKvl3mhi9n
	cGoMT3HT8bPoRtEXcJT6Wmk+jjPriGAOZFcedCqb26KF7Hm91QmtawEoPqGT+PgIAHyTKD9MSoG
	hTj8wcS2asJoG4f/oXmHvpIi4jVMZT34eDwFgsFiwYmkUzAaH5GQ5P69X1AESCOd1RY/mLnZfs2
	VcuhLqZurFg5uqN9FSXopD03f97rytyICkO1VG57k76DEVgqjvZIMcZSN5mehnyRPhFc+M3/J/y
	jhYh/vqNEyV56tB9zDYzBBKIxFCwdiEZ3tIBL3LjAAc8P9Hh4Wf5l9AyjmOamYN90hkarIwU+Mp
	RvENKCUjEFiA+Qh2EAVuMmJiJvWBi7JAG2NgGyBkTzwFiIwD/949sOpnbZZslEqS97O0a7wm4QN
	18apMOHgkmNc1p0IMiIB2fzVIgJcq/S8ihV1JKkbaKp9t0bbbEfbjW+T2726qSUDCr48Wtb/IpK
	iN8p6jvXYKHmFMHtSnPEnzRt0cS126ujtX74YlWAWSEs7p8YDxgueIrk5aTuPvJxvYlECMwoRnN
	5ZhwC/6KAddUEYfSVljcEeHKgDk7RB2iPILRmnGNMs5KAHmb2aoHyMl4e/EYa6wA+J4+oomEoA=
	=
X-Received: by 2002:a05:7301:52c8:b0:381:dc3c:4c19 with SMTP id 5a478bee46e88-3827aed7177mr2606013eec.0.1794983888747;
        Tue, 17 Nov 2026 22:38:08 -0800 (PST)
Received: from localhost.localdomain ([27.59.52.137])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a63059e3sm6423069eec.5.2026.11.17.22.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 22:38:08 -0800 (PST)
From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Subject: [PATCH v2] mm/damon/tests/core-kunit: add test for damon_call()
Date: Wed, 18 Nov 2026 12:07:55 +0530
Message-Id: <20261118063755.37749-1-saileshnandanavanam@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 26B67180007
X-Stat-Signature: u64981dauuwrfwyw97wxpajssih6obp9
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794983890-598733
X-HE-Meta: U2FsdGVkX183plh6htGg6aBdLXN/bcq0eS1WileZmGBTHHnd+PPVR1HpNtpWmsXaU+KHudMc7X4k9G1sgZRY6gbsDj4h9BsP8NLmGCozX7ktddyQkaAB7F5GuClFYiIwVNtMs6KNb7JSknYFowfWaFr4AmCwpZ97bnCbyy9A5Rge7DV7QA2AXNuJFlrZza9nrzVgZcTzxJob0qlh0ZHk5b2eOAw9ov5PKPD+C0PvXD1r0qFAfrKLcLzwWETxg9ESOvr8Hz9To5DLn6z6VrQjjpHLwUcM3YYJgYIDv6IhdqKkOPGsUvk/sTA/sjelJNzvM6p/ZZwsAigf3vOHk+XlhkNr5omkikZEtH6t8iAbWSqWdmM16BqpxFDfMJsht4qrUWAvrfjAoKOW7D5LMmN9kE0ljq+BiAKPlcvNxQk50FOoskOSNzwzjTvMcN1hOixohGLJcHk2Gg/nBB6PKShJiy1FW5e+p6YCCi2MRxaDp/WdZEX5W1lBbnpZMEF/WI8CzR25ATOqMGQu+XSX9wz9Cp4HixI6KcZbTpd51WACKKCuHhM28eXT2w55OyCkgRHx/LyiWjYV3fh+52hh4dRrNtYStEJQ35wyGYnoLzPYWgjjoheybFUsyRNVzc1pU/dSfYPAQ2Noh55LrHW3VTXHrzWjOTAgECg/xpXo65+NO5tgj8nG5MHd0y7dK6Z1VUxh3G+TnqrognAbWiyp/VeV58SGw7XFBue8M71ZZjAIjDut7YhoFzhL1x2IcjMp/FU5/ATi+h9YloLhbq5mNaZhOS2zSKGx0LSx6ynfdvdLkyQnO1CN93o3m06fdRgPMpMIhMZP13MDgnLMrMdWt5FLHuozqm1kwsIcOSVllbDI+Jyha6Yg6hVD3lSVrsSuDDOubV+y3yqZz+0fzD00ENaNKKkUEFwdpKL7ru3T1qJUO/lZ8xaXtpSBVM5e06hpdLdxUwrxwx1hEhv+JO6THmj
 y/e0VTqL
 kjXIssq8zL47MAUgjmSUHgUni5bNuSMOj+eNA8dYQuguLNSj810lejx3yU+6ESqINDMunW103jlpSG0nBbB6D3p63QGT/qPk+0VHWncgkTvqKkFCsly3YgwaIeeAV7SuuTGz4OIhDCwR2J0izbxhCFx4tJlm8sb9N03zWxzo3BlrGnio/OmfRjhPLY5G9Hnqs28PkKaxb24zUId59YIdT1hdAnzmfroGxEhBxbioHW997Ucv8FrCfWbQhkxG3wRtCOkLUG1ar5WYmB3skK5xoapB9oltFaBpD+OPDJh8bNCuef+B+ARFfPxPg1xKTs01KMP+h26TyKNrFNP1hCAYGElE5i7L2XKNtiWJL3mtuMHQxDNBHWCHeyhyyQCU3K2bozK93dtqyGwqIv48ESecEpdwVuemJNajBjZt/leLn+RTGzqLnSO/8clsU8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A newly allocated damon_ctx has call_controls_obsolete set, meaning no
kdamond is available to handle call requests.  damon_call() should
return -ECANCELED in that case instead of queueing the request and
waiting forever.  When call_controls_obsolete is unset and
damon_call_control->repeat is set, damon_call() should return 0
without waiting for kdamond.  Add a kunit test for the two cases.

Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
---
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
index 43e2f950f8ff..228cb044d1dd 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -2481,6 +2481,27 @@ static void damon_test_last_region_quota_reset(struct kunit *test)
 	damon_free_target(t);
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
@@ -2525,6 +2546,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_rand),
 	KUNIT_CASE(damos_test_esz_goal_temporal),
 	KUNIT_CASE(damon_test_last_region_quota_reset),
+	KUNIT_CASE(damon_test_call),
 	{},
 };
 

base-commit: 20eef29b7c8465ac98d7dd6d6f2ac07a8d8056ca
-- 
2.34.1


