Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBABC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6286B00B3; Sun,  5 Jul 2026 12:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67B36B00B4; Sun,  5 Jul 2026 12:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55D06B00B5; Sun,  5 Jul 2026 12:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 957066B00B4
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:01:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A169C047F
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:56 +0000 (UTC)
X-FDA: 84955189032.08.FE345D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 82FBE40012
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H7tYCkxH;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783267314;
	b=hV/cva50sARQkaynDKn+JLvSn+23t1IfO4A+/yq66aFnfDC1BDsYP2fQbqeaJZo3PduW13
	tEqOg8WlThnuSB9AiR7MK+li8D6FGfBXllBCBkc7LuRZHr2tUuFRulSJyASvXX1nKhUNlL
	6T4X+b8jLR/LLDYvwSV9yn8FS6Y+vxA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H7tYCkxH;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783267314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/jrLjscVUQeC5WNYbMxUpcBegD3KHrAD9D5l1ftK2k=;
	b=jC1slf+T/JzM5kzUgDOasCDS+EsO0SDUdrRXYCeqS9z0381ijPSDv2HHwwd9f7huBxl1Nv
	xR4xthcJi0NO4Wc2cXcT2niJCU7AhuTu8XLGyEDUEi5iQF732DjfLNysJtYIvuncyeb7y9
	oeNrK4vciRKhHetWgnwvLONlpynyPLU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8CA643C10;
	Sun,  5 Jul 2026 16:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DC21F00AC4;
	Sun,  5 Jul 2026 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783267313;
	bh=T/jrLjscVUQeC5WNYbMxUpcBegD3KHrAD9D5l1ftK2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H7tYCkxHr2G/yFxI2q7qBK2oZe2gwO/jCTeRnC2uC9RITAognzUvh4xOmaiuUy/SK
	 SGfMukrW69CKjVyZpUTBAhsBMEUogrH4H9hQlmX9Ikh/mCcatM1U/BGsWyPvKUHCra
	 rZiU3xw8l25YtqLE+nfujY8QIIFBDCn/jTPl5HpLZvSGon5XJNFaYJhSWbQau7rnPm
	 bjAZzrZ8zpXqbM63njuyMtbSxL+23/zSNk84VTyzeAlwKYF+B5RALBf4filf78aDDs
	 rt7e5MleckMDy5KB/v7NCZ0ZeJtpKCFHuFIPaRULVTxrwUVDtFFgy0Jgodq/EtLV3E
	 cKAVrYkPbaHCQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 05/11] mm/damon/reclaaim: ignore damon_stop() return value
Date: Sun,  5 Jul 2026 09:01:32 -0700
Message-ID: <20260705160142.97308-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705160142.97308-1-sj@kernel.org>
References: <20260705160142.97308-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82FBE40012
X-Stat-Signature: abmtjme9c1d9yu3wtxu4ozpnjay7mjmo
X-HE-Tag: 1783267314-210548
X-HE-Meta: U2FsdGVkX188k+UJIxuSLpffR8TptDOjAYakF052NmcFMt2IjVkezHA+o6RvkB3rlsZHoCtLnu5hEUJYD4zTua/7ANiZhYeaPzpouI8sJ8cz49OP8en1cGZIi7YftX3CiHrqh5iFg4ssKODQjFc2aW+7J6NsnBs4oOG1ypbi6QRbT2S0OzjxEcbNL0G74GUH9GRuZ92Elj8V6t8WryO2lLZA/LXautqWpNeRjpjESasyh/c2k6gnDu0tzFhOj7Il88SyG8gb7bJSvic88/nghSY434oPiU0YD0tegepoRfq0pLVHbzRKNYAW8yyIZuMtEz3YBoGTTndneYSydISiYpsjkPaLBu5ZyZksMwnPWNwR7bwd6uvTaf6d9psEDX5K12wEhniuVw0hgX7J8zg7J6FS0WFF239ePTW7vLeHa33/JflB1DX5YxM8sDRY2nEXU0jimQG63qr3fhe2Dpgb/V7UkLmVpYp5VG8pOeLNiRQ9csZPmYawj2K8waNtqeSnTy1FpE57ApQCz6tU021si4ulEdon5VHJ0OfI4afJXhsf3LN9yjdObfSdBikEMNikTbKq2WBBtB2hbiDl+U9qk/coJjG/qQE7lehRX3/vMaQyXgoYRZoFXg9kdmiMJew1kjphR0o70bvHXG0qGb53FylvpGhNGeBfETqWuhUDRByFuGXCqNyIkGYnTDovxPff9FKvOiWoojSbJsSov13XgIEYU3vd/uq+oR8VY7xXZFO21P9jWnYwrCIlz77xsCXNtzfIvPiIyjn7MpmmJm+gCVGy6U3jalF9PRDLu2qg0BfbM6cHGyytyj6ZgW0H+esO9gkZwXz4YO8P7UagOaFHa6Nv4FmS5zDNctH0Rk4z6ieaZWMXCrRgW7HVkV53mSPHSj+ikf8kaUaN9eTrFR1SEIILVUaJHQvJpaaFtAjz3pomP2UoK+ctAsWuBCJmnS9adznF0FJxux2S00Whq8j
 I73WBuyE
 QzdlJx6QXLVxgE2sEbTW1vd8g76LXd/qLI1NdJiVbYQn5stj9iG9VX8emP4QNsLLrjki2GgBTED8ET2OkMwncmTruCDnGBBaspn+ttwZWFwNLg7IoS4QP0D1s1gRKwoGeeXNqWFRMdlKETaUWRBoK2bhl5orRm11E2jw8u4PHTA1PoJvVyVNj9Vsjo8uIpRX7wADSeBfQn1xHJsPh2c6O6vNOBLaEtLD8469fvV+EgYFVrJ66VlZXYyAuhMkYvMQ/Oqm3kha3IJGpEumiZfTzfG7KFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() return value is guaranteed to be 0.  Ignore it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 6469b25cc34f9..09e941d75f67d 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -332,8 +332,10 @@ static int damon_reclaim_turn(bool on)
 {
 	int err;
 
-	if (!on)
-		return damon_stop(&ctx, 1);
+	if (!on) {
+		damon_stop(&ctx, 1);
+		return 0;
+	}
 
 	err = damon_reclaim_apply_parameters();
 	if (err)
-- 
2.47.3

