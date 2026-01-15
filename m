Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4173D44C63
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 15:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4363C6B00AB; Thu, 15 Jan 2026 10:20:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34DB36B00A8; Thu, 15 Jan 2026 10:20:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4C16B00AB; Thu, 15 Jan 2026 10:20:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3DB16B00A9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2DE714037F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:20:56 +0000 (UTC)
X-FDA: 84334560912.16.4FA46D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 006DFC000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:20:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=auUbi4LZ;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768490455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kuq5nt9VTXk7HKsgY60Z6aB/tFXRifZBfVvOzsTu+3c=;
	b=Sa7ZQTWP+sQqp3BrSeN70/Xuf3UmJUmfnLt326iwZznyvf588XFpKmAylf6Hy/hpNUsWBQ
	o+U+YuvK7933JDMPOoXd9IaQULG6GvL4ks34JmDOPIKqTZiVTPLX/Mbe1j0w2SsU1ms3IF
	OLclF+e81IRwjhwy9yMrK0Ael2AcPPA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=auUbi4LZ;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768490455; a=rsa-sha256;
	cv=none;
	b=EwuYv9dlIxBLmNiatG0RwtQzD7q0M4rOHtLk6YUrtTMFthy32IrWJNMc2jkqmrXriyJGGk
	YGTmD2z+13xX9vAv283MeJU42icykpOs4lA7yrjMWmaI5006T9RzNPK9nF7khLsfdwbqfO
	QMgIADRmYz9fW+usAwgUwGvX5QC1X+8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C66324431D;
	Thu, 15 Jan 2026 15:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DBCC16AAE;
	Thu, 15 Jan 2026 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768490453;
	bh=Ta8voQ7PwaIwWi/tca9PDpVSIdwL9VUNWSGlUVLCyN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auUbi4LZbcZY3XoZTmiuEBz9GFhg0i5IAadPhW3u5NPpvll+nU3nybYQhPjICRqrz
	 vIEAcLAnh+2xP+WIYwOc9F9r9eWVTY0Q6hZiR7MCIk9KyFf0AAX5/BmP4OihheV/Ge
	 JOWuHkr0tr8+AFb0hZYuKrBdyRiaSeR8HCrC9QJZQDDu7kK97Xe2cFgDe/bLc9AllJ
	 eqsZvxCYVxF8yaeHoF9eWXr6JotDIzOVgpoZSJOZq1gQdX5SmSVgWBFgHAGYDTbGoB
	 ksMlUXisqACVLlpzTEjbBMoZtFZIiTus8BEpVaCuBCeX1Qq6zyMkAkt+aJTovh2tXj
	 vVywYGXmuu72w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/5] mm/damon/reclaim: use damon_kdamond_pid()
Date: Thu, 15 Jan 2026 07:20:44 -0800
Message-ID: <20260115152047.68415-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115152047.68415-1-sj@kernel.org>
References: <20260115152047.68415-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4pjeyffmwtp8acrmzcdmbokor1gxn51i
X-Rspamd-Queue-Id: 006DFC000C
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768490454-457364
X-HE-Meta: U2FsdGVkX1859gBs1gGUpdtcPEQy5C+tZMOCxCVqdtz2fLVA4O6GbYQsIeitfLgZGP5RCDaefk63gZ4wzXfiF6ydZAQE2+VWSSbfUf5Eq51wq3ZTFkWloEMfxJ0TDKzw1e7jDEJIn3N6g6mravsVEB+WwXP4S+IoygZO7qrfkd566MicOaQWaAyHTxewZoSY9O3py55v6l/sBezHGn8PL5DVZwrH+53jvEq9QiPZ2b113D4w6sBntHWQhiSL+bEu/EliCZC2U5pLkSQ4aOeLnPPJxrDVd3Z7nK17ttKU2O7k3NEYdeKalp+ZQwbIoyqoyZtBVMpNKVl8mk7PaHIi+C9z/aeKZ0D7S/gxsiHZuWXVJBUJQyZQuIio5xWXDgu7znSxFbz7oJieP+79ns1CeGpscIeEW/eRc9kznbgVfAonUK0Gi5v7mmqVz3YaDQta6+gDprSYjDWqAAtItoiznIyXHmvPMxn/5Mjc+niqYCQx6tIxvKYL5CcET0XooZr1pq9gHh+M+hJZTDNy3Gmx71pTcuUNAQmUd90DjfwLBGmzZkQXMdwKcIWAuypuYM9nr1Eq3vUur6yNWYqdK28I3NyzT+Yvz5pAT8UNDE0oaVRZXiWM1JKOM9/S4oVowiGVz6E/i6bz1hpE7wq8ygVwuOtpjei0ehQRX6A5UpqAM5WoDmXNLfFuurQ9ZJZBnRBrcicKbzyX/db5D8ooKMChB9hpsigimY3eiFEs+H/LNe3CAbXvOrVVhahOqXLEkAFrPOgiMA4AqfYAT8kvpiWQVJYGHKdIPc8laWdNO++oZ9cRsbX5QMpPlJUAKZezdMW/YDAmfAUmJj3w5XFFELMCZgA0eaEcp8DdLlDuBCyQSPEajvJP91jZkUnYvMYvXBZx0iOEcLE4HTEcH7+TlaY9uaH7NexAnIt5DIXM6EbzRCgR7mKWnOEBM1OlkwQkN8g+eCfkSBKroiCXjw0HMA5
 myY7jX2/
 YdregJc0bbLVon/DW94rsgdI3TVyNGShmV7dlsvL1j2XEvSDJop6Dx3KhTZ9CEbNYaexGBnguF4foxLYcWOEVaHsI11Lp9F/rpaejsdAxeC5qlWaytd6BqOqOZsxFJG6dfMCJg5Fazyf9tQsQyd3mxAbk9hVsquS3sT1FQSanilJ1G+N4p/11yOqnNfslPtkkFaAwuZlKYmbDdfGGGhanlYjpKylVr29n9genGJCo49rWYXg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM directly uses damon_ctx->kdamond field with manual
synchronization using damon_ctx->kdamond_lock, to get the pid of the
kdamond.  Use a new dedicated function for the purpose, namely
damon_kdamond_pid(), since that doesn't require manual and error-prone
synchronization.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 8463a5a5032f..55df43e241c5 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -307,7 +307,9 @@ static int damon_reclaim_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	kdamond_pid = ctx->kdamond->pid;
+	kdamond_pid = damon_kdamond_pid(ctx);
+	if (kdamond_pid < 0)
+		return kdamond_pid;
 	return damon_call(ctx, &call_control);
 }
 
-- 
2.47.3

