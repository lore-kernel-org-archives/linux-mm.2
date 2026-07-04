Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE961C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D94D6B00C0; Sat,  4 Jul 2026 14:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B1F6B00C5; Sat,  4 Jul 2026 14:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0292F6B00C2; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE7986B00BC
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5011C1C34F3
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:50 +0000 (UTC)
X-FDA: 84951887580.13.FF09A5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B9D7A4000D
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T/haOgJ/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783188708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isbLDdt8/jxUzGPY4kLimLdStIBUZ8pOdQulONakjEY=;
	b=LDNNhbQfZYIEuisR+XQi8wK7WZMT2OzF5hem0uoYrJMkLxjSFdIuVQ0PgtXC/bYGI3sC01
	n7MLvFSEwrJZe2Fm/iK98FoHxPkQf4yv/erglx54BMWT87zoZF8fgfwBym5u6gzo0pwhY4
	hX5Ls5OEpHI4qvKN8MOPvvwdhSpKRDA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T/haOgJ/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783188708;
	b=NZKmCREJcQaxnkh8zh8r1XbRWBH5IMUj9e3FmHvQ2TQo7CfPhDMvKJ7sfHJdG16Qva7VTv
	BT2HHOh+vLngTpdtHQCKp58vAC+ENOASAJ07aquZjgqDMRADE8gRyA/hXWr/H5fPjG4XJj
	XpgxA2fvXUB61hepMcQgbFGbNWXd6PE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A65F043603;
	Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B541F00A3A;
	Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783188707;
	bh=isbLDdt8/jxUzGPY4kLimLdStIBUZ8pOdQulONakjEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/haOgJ/l3SlKVBE/gVy6f9J5cKDozc/xs37Jq2ygZ3Mz4EpluBsL3hj4PUWfL2bR
	 7y2yhvo4kMu0GxHhPL5G9n9vx8xEEssA24NKmDeMJLz71wIOrqhPNQSKMDLWI3fTps
	 VlKqmfxlfZ4yNjuoVthR3jrcNXPTjo8BC6eV8EZFlmYEphtBCqIA0Eeeil2rEb1zcL
	 WZfHCN3smoCfkiHiUYkSTyBcs18JInyhif/eCCxzG816SJo/7fr2/G2Kf8AQZQ8J5a
	 vG4K9h5ghicITtM4d863bsrWkMYjGnoFfIpnyHP1nPTfpfPJZUdiDSx1jdGiGPxrHD
	 Pc2qzjbXGfLlg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 09/11] mm/damon/core: stop ctx in damon_call() before reruning an error
Date: Sat,  4 Jul 2026 11:11:32 -0700
Message-ID: <20260704181135.132956-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704181135.132956-1-sj@kernel.org>
References: <20260704181135.132956-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B9D7A4000D
X-Stat-Signature: yt59wkcyrbnupsuhnzchdpwk3wypksez
X-Rspam-User: 
X-HE-Tag: 1783188708-609874
X-HE-Meta: U2FsdGVkX1+p2GIhEn1pAzIvZpY/644qWutREfshIuhJR6PhSgrcKlaBC71rf5SK017dTq999kOperLVZuG8Ty7SP0rjAzjRZcY+Qfz7rxmfpg//Elnul1+pb16zjke+JXpUepDASY0trwtKls4Kb6RVmqlKIrqotHEpSiWB00mRCzMJfXGImKfhH7ybSWdBHxtBztXnQHboz5QbHQBtY1iYlDCCTsrQm+1leOm0TqJKGY8vYNoK5gahyvHMVDegck1zWYYi5JH9Q2PBx51j8+Aq16bPwxKkPtn1I9hzAia5YBpUfsHHs8NV6IlDKpFzEKmTKxsER6BTOqEtnE9ExGWheWc0FAPryDQcK4qPEysiougGauQU9uNIOha8HCQrIN+i9XXZQcKwTTu2nqe5Eobyez9eWwLfnfCvFAQwIdJx/5OR/vGcMIqWOncsuh1npji5a0roQJc6UnEGuGrVndt+W4gW609AjcVg+PXwt2o25lg+dJO5leijDnOghGS0NrPQfY5HcFRpMHTYZ+sp+D/ydqtMcddoVgVfquT56lw0rcSS24Z1wlRcl2roz1e5N/CGsWSrAVrbBhkZcLniyOOfxsDYHpayxmb639LUjsgn/CvFwj0b5jypTjYr/I1YVsnjbQSCwQyTNpiwslo69IBhC/Rk6OAgxQ09YIB0b12N5Tb0GjRh4JWqCAt+0/MyeUE4xI/xxsexOHkVR+nDy9R0PZC6NWMVn1cBYr1QOc0fYxLJD7FtY7W/neKqddipwe0DoEPscvke9r5f1/s4Rbee5R5cM+ij6Xottl+90eEXm7oMbL2SXWXX2MdIdVs9azNdpT7lCYqGsgx3tCiHHWyVMf6jLCxKU87sHvF6Cm/hlu1VPlUVLKHgIr5nuchsSJgf5PZykI7llQyB+zsd0nMSaKA3WogBHmN/lwb9q1TRU1j/MiNh/QAHDsTVbdcnJn7ejn+EhEWiRSovH30
 ucSkaXnh
 vjVjCPpbsh2JgaV2RVhL1TUQefg2EQprtGg1Qvwf8/PYiZfvEi0TKteoLePohKQSlQtyJj1W7kJ08I6wqnwmK2sQdpdB43Z+EEdXS513smAr1MLILsRdi6oFMRAxvN7Z2keaUbAmYll+oFxwx6YKgKskSTuA0+Rgff2FJHb6H04sDq/4osP26GW6OyVzBnWnFFlwzMmrS2BeVic4y4oMtcMDEHuT8/Gui2OKL4OkCfKzHphcnqIZzXQss+hHfzmyHebYIprQVC0PBY9pr2ge7LOr4iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_call() failure makes the DAMON context to stop if it was running.
The stop is asynchronously done in kdamond thread, though.  The caller's
error handling should handle the race, too.  It is complicated and easy
to make mistakes.

Update damon_call() to ensure the context is stopped in the case.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 1a6c30ae91711..5f16d2e13ebf7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2009,6 +2009,8 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
  * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
  * wait.
  *
+ * When this function is failed, the @ctx is guaranteed to be stopped.
+ *
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
@@ -2021,7 +2023,7 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 	mutex_lock(&ctx->call_controls_lock);
 	if (ctx->call_controls_obsolete) {
 		mutex_unlock(&ctx->call_controls_lock);
-		return -ECANCELED;
+		goto canceled;
 	}
 	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
@@ -2029,8 +2031,13 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 		return 0;
 	wait_for_completion(&control->completion);
 	if (control->canceled)
-		return -ECANCELED;
+		goto canceled;
 	return 0;
+
+canceled:
+	__damon_stop(ctx);
+	return -ECANCELED;
+
 }
 
 /**
-- 
2.47.3

