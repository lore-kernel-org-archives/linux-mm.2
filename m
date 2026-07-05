Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65730C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1C06B00B4; Sun,  5 Jul 2026 12:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6505F6B00B5; Sun,  5 Jul 2026 12:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 566DB6B00B6; Sun,  5 Jul 2026 12:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC2C96B00B5
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:01:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6DA01C0487
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:56 +0000 (UTC)
X-FDA: 84955189032.20.54326AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5AEDC0010
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROAUPDnF;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783267314;
	b=dA3zAbNzqnyZc6fP8N3hLlB9uIImwxuPk/+4cNh+arkU8YNkf/24N/nckaIatHTko4E85P
	X10o7R5P9bQtPvEvA/U0YHHsvmPMty/Usk1q5M/HNSEEZAE02F5F3nzP9YrBoe5lH/VEow
	cEUgi72UCvDAbDXQObOz15uTj9+sTVA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROAUPDnF;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783267314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XifFyfJolobUF4kXii9SDmtvZzvIFxqywQe1D4fl4uA=;
	b=yT95lEvnTdPHdPsZYeK3lqJBVIvs8AJoKtLUpy07BmRie+7/+1jufSsIM4BPV7bMCbrqis
	xRyxMF7tKNBQCpJyreFY2PXT4BAeByWzZOM+Z6IlRofvgYqPlyrADA6yPSJocEidcwjMkF
	YUa2LgsqZVYz4mPxtcWDrmVgtS86800=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FE0F43C20;
	Sun,  5 Jul 2026 16:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E1D1F00A3D;
	Sun,  5 Jul 2026 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783267314;
	bh=XifFyfJolobUF4kXii9SDmtvZzvIFxqywQe1D4fl4uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROAUPDnF7g0SVKc8EEVwSnzosmZw/JCYYDGP+2yL4GZHCFn/CEjsT6WKOgsdKyfJG
	 1gFiY4VHLhDHqrDYFMTGv1G1Pnx8bIdV30W2Y+ep5A7sU4LYSYeZQioRr6kRczBfTo
	 q+3KKsd2uX3MqVJhWnaEgHJ9vJ7d81HZSUr+UYj3B4jlkXWLYF5yftLsRul+BSQQQe
	 behg0MoGVRcygHTV7U7lSsRMUJSq0Ni1LpV7jWyW3FL9ePZUOyFPTHpCoFy4iD9auC
	 /NuqYH4YDk7w1ycxwIgipgPvywioO6TxJT61autgeR9MfxQXIw7XpscQ95W3/EAvP9
	 QtFzJQ26E9PIw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 06/11] mm/damon/lru_sort: ignore damon_stop() return value
Date: Sun,  5 Jul 2026 09:01:33 -0700
Message-ID: <20260705160142.97308-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705160142.97308-1-sj@kernel.org>
References: <20260705160142.97308-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C5AEDC0010
X-Stat-Signature: q3fzzaaixpba8hk1a3ad164ynwqn5q5o
X-HE-Tag: 1783267314-169951
X-HE-Meta: U2FsdGVkX19b9mjDrAKu1anMFYvd9KAlGFNv07pKRFa9RiqzjJlpcnPT630zq+uK+SJv/eN66juj36C+2sLLHvpuxav0eVAlK7kFI+Vxb9RjgWaYrIRlsx3w14u6qcol/ANtuoKKRPOKCD/Omj30AIamgPLHbOxvsAxvmQOK01F5Lw4uDidDfOi7RPDYiBt7qOEILohoOON3D/6DEqfBAPj6UThHydP2l5jTasIwGSEK4BkrzssSGbp2mTjGcl7V88m0Hv5Ei+b9OrghzCIGQxbtPF62glSHpWOGQyuyVCf+oupZMyMrUX6ASXoJcPIxBUeNi4mLAKeEyI8QjHAe9e0zvHcV0Id35B3QfjuviogFNiZ21C3hHrlAzxB3xZcO0nIR0dWi8QIxvXcoa737ssl/G21nYdn3nHC1FJvtAwlg2xHp+p4I9xNa66PuQWRuCOzr0gsuE2Ud1yY6O8AbeyfUC1yiYlexPOS5dys8/Q6LnniNZFR8v+ON8CFhnC5EPuBp7tGAhA/cN6iKwcO39Af/Yq+lgvIPWMMtsZ/4s0pwWKk/GwSH01vMdAZww1LRczZCn8dUt8Kcu/ZZh4hkhG9Ms8IhQlQpEgPLy7/z0z3E2FuCOQA/RmEaHX9bZ7UjfuGjuJToBsMv2dqQsPZg1BwvveOEjT8LRzFnqjIg7mzB9RisaHqarxzkAzfRnNsZ7pjmUQz8G1cK60TaLhO6nKZg/KGmYci5Qf1w0Bjwq26uXT/eUXPnWUZF4+YYeG2osMlcRGKK5Ntvljh0inR8LITVuHrd+ULPLkgXIabbIFi+mRnuUmSFJNGMRNJjF77ryUKKGXOQ5XQKcDz0uiz5y+xDdJBM4U/CV+Y/4X2x0g6CFEM2rsARhuDOzJPUsFlrUj3c2RHXje6NNb7dWlM6QxE9rjdk5NTViswMVybrcO/GLvfHCa6eYcrcJPkSvaz0zeGVF4y1+ti0O3jKtcy
 HjcdRyVO
 2cqcTpdMahQu9YUFh1dBBb68zWO8koqxhR4uBjNdLVNliMfhQ/25NHp1Qq43JO2jNO53mS6HNnOtmG6Lvh27yK18SOX3OVve6vjgPDP7Oo1dTBbugL+/Xhp2BVOuQlgl0i6RkVoRv7SBdSqULw1T/COC7EyiazBT1KL+4gbRb2Kbghkjg5NwStTM1xSSCVZF+GUNy4NwPURwUQlMxyzkcWdVc8Y63GrM7/Y7f+gTInA1HXyooA4Fuk+gb+MrMIULqdpyTykj5xwSg02TGma2vSZnufQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() return value is guaranteed to be 0.  Ignore it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 2dd0cd0d26273..e8c389ad3226f 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -409,8 +409,10 @@ static int damon_lru_sort_turn(bool on)
 {
 	int err;
 
-	if (!on)
-		return damon_stop(&ctx, 1);
+	if (!on) {
+		damon_stop(&ctx, 1);
+		return 0;
+	}
 
 	err = damon_lru_sort_apply_parameters();
 	if (err)
-- 
2.47.3

