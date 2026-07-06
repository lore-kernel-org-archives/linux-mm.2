Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA81C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19116B00C5; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0916B00C6; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D2A6B00CE; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1D226B00C6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 461F01C7D72
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:41 +0000 (UTC)
X-FDA: 84958527402.17.D854E5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8DF5100012
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fz1H3HQh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r0kxycSRSEvbxy9pEgGpchLNtgv4/AHk+YSOYT0eb7k=;
	b=SnY64YWNKWGW80JuPRwXunYWawKlXyJmQ7XQENJuP4T8V5ru1Fk6kLZkVDT2asI+sEImWp
	pBXt/Gj0vli8LrZ9TR5LR41QasAxzxY/WTMMVOWmpRq2YfDkEWwO+0GjO/WiHQ4EQaOSpL
	vFnB04lC4yuVMARhyeeCGU4lAGFgP/8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fz1H3HQh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346799;
	b=YC3x/cetLxEa535KDPdkZV/oXrGBZwiswbh3u3/uH93khNtPgaaPsMWl7evxu65n/xIN5R
	z5Fqqioru35RxXZ3mXfRzrgySbQ3IvUzfmrqqtqMo1Cck4Zm2De13L6KgsQU0jJwuli0tg
	n2ZtYM+2W2sibklr5IcNQnILMr6XdCg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4704D600C3;
	Mon,  6 Jul 2026 14:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF4C1F00A3D;
	Mon,  6 Jul 2026 14:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346799;
	bh=r0kxycSRSEvbxy9pEgGpchLNtgv4/AHk+YSOYT0eb7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fz1H3HQh41ydM7hKyfjO1GXX+uKXdfQN2MNoCHhwxMU9GXYjTFwt7jL1Xn6FCrXi7
	 frNYTuzBC1Dy9pxuI79H92f4yBdSUzhM3QCNHpB5Sk/ZsO2mM8bbkQflO4AaUOMBmi
	 SKHFL4ib+Bp5R58zMqb2UMQ5qyORWolnSn+m2a0B10nTHqf4TTAX9eSqGy0Zoe5q6q
	 44444yDwo/I5+JKR4Y7ea5niffZ7XrPqgl5d0qL4Sfb2kzb1htXFD72mqHL1xMuVAy
	 4ubJjqmF01wlADyLN5Ol12f5gHQPlOiwHELMplVtOyYZHHTWMJKbzeoM5ddOabOofy
	 9iNI4Zf64A42Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/11] mm/damon/core: make damon_stop() never fails
Date: Mon,  6 Jul 2026 07:06:18 -0700
Message-ID: <20260706140628.87414-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706140628.87414-1-sj@kernel.org>
References: <20260706140628.87414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A8DF5100012
X-Stat-Signature: z46aobkwdesu61e3eambzp4iw49ngu7i
X-Rspam-User: 
X-HE-Tag: 1783346799-515488
X-HE-Meta: U2FsdGVkX1+wquM5L1cr1BI3HdRBqsDgmPvxroKqaCPIq3SWeur1Hy9ayI1Gu4XhAtbORCmdk3qVPdQ7dp39MBEh4ksgn4J0GA1nNCpQ0ldrUwlYzsvwIW464KcWftU0LpgvB4Ib+eHTZnJafGSzKSWVyGEcSz2YWSGwFsIvEEJTUWaynxPRa5pAfDDMM9s+72b+gG1rklT3plNEly8P9JsFOj0zM3VoCFOKXLKTDyPKV+r+41gXWoS4mRMVEM9j3aIgy5Vxgbe9a8uinXhiyxnIIx13fTwgaBesXxg6jWnUhAuQKm/RhxzUp4JVy2rnwef1MIP1nB8J+/DvZgXKtRdpFCz6GCutaTYu3VmUYj19weTrd6DNaN5GbyhYwU61rstvT6E5ztRdHFDbPfDAwpgDZ86WgH3it3CHgMxlLzuov/bJzOR6E/8ccezWNAxD25mLhw0vb7dM9L8tc1EliO07qlULr0xyLEwBeW8/ufe+YPceuGIqy58vmPp4onQizZPrsK++pV429gK+Gh79Cw0hPflsE8CT57v8iHvAAv6iogY6eFTdMvE6Vecc/Orcqo0AM+DGVGLszYjAZxE0/kmpopusJVizOlsYz2tSfGyQcxhkCNye/0rfGKKt08AuhtVEjVreTXdbEFqcsxhb3zdyNOoh9GsWScv+5GCafFEDcIKpdhEUWArgiLdUnuxN3Duq7UsTQRDFVGHwnT2tfTuSKxxsFgqLuRXCedooHSZve4mlohbHgXt7+HPlsI68eym/X2NFXUwt62hsejbWildPrhFT47eL1VWCfyHNgyJS4rSESj1IR7UeaqNwNFRViXkx5/Q3Ka6YB1V0NYxOwPOAw1a7ErROm4Jl1Jo5sTsT7Ym1dHSwk6jkFsKNu1RCl5DI1+arajENMlDWEvT9IfoO7QaKda+01vIcXulIp2baw4Y8QFNiT8I7937kfNkcO21WRnOrLUdDWE/rzN9
 +P+zNG0J
 Ac+2WwSjDIp7ryrRnAupsZ3Q9wEP8UO8VUrS2u1f0sXHch+rgkEPBZAQ8y+umJZFHxh7FVVpdChEsYeQze3jRAZkXhqxQJdw6pN0Evj3GcX3muwYRQqIoZAtMyIZ6V7O0fNHd+4wPvaSJ+QV66winOOMkn5XOL8q93box/S1ejXPCh6KysvfKoZo0R+sji7r7ofnPKUAYa9hJhn5pP5Ir5q3skKhAychz5VKUNJrz7sY9Ht3o8/W+TXLk0wG/yeJhyXQgL1eel4msljdUF2/sLJ8DaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() has no reason to fail.  It returns an error code only for
possible future changes that can make it fail.  Such a change has not
been made yet, and this only makes the error handling complicated and
confusing.  Ensure it returns no error.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d89a7f2faf350..84e400aa4e823 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1926,10 +1926,8 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 /*
  * __damon_stop() - Stops monitoring of a given context.
  * @ctx:	monitoring context
- *
- * Return: 0 on success, negative error code otherwise.
  */
-static int __damon_stop(struct damon_ctx *ctx)
+static void __damon_stop(struct damon_ctx *ctx)
 {
 	struct task_struct *tsk;
 
@@ -1939,31 +1937,24 @@ static int __damon_stop(struct damon_ctx *ctx)
 		get_task_struct(tsk);
 		mutex_unlock(&ctx->kdamond_lock);
 		kthread_stop_put(tsk);
-		return 0;
+		return;
 	}
 	mutex_unlock(&ctx->kdamond_lock);
-
-	return -EPERM;
 }
 
 /**
  * damon_stop() - Stops the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to stop monitoring
  * @nr_ctxs:	size of @ctxs
- *
- * Return: 0 on success, negative error code otherwise.
  */
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
 {
-	int i, err = 0;
+	int i;
 
-	for (i = 0; i < nr_ctxs; i++) {
+	for (i = 0; i < nr_ctxs; i++)
 		/* nr_running_ctxs is decremented in kdamond_fn */
-		err = __damon_stop(ctxs[i]);
-		if (err)
-			break;
-	}
-	return err;
+		__damon_stop(ctxs[i]);
+	return 0;
 }
 
 /**
-- 
2.47.3

