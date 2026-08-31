Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79616C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7616F6B009F; Mon, 31 Aug 2026 10:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EBCF6B00A0; Mon, 31 Aug 2026 10:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628796B00A1; Mon, 31 Aug 2026 10:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 407436B009F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:26:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91828160162
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:28 +0000 (UTC)
X-FDA: 85161790056.12.8445367
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 08D3140004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ofv89aVI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++mDemjAm3frVYhBHw1yycvSVhXLn1wofYJdDWaaqD0=;
	b=SFyYTLuQ2A061Xa7kPCWlfpbIHEYWE1EOo8KHV76cF35yzb+JaSK1zv2i1CQqVepfuBwRR
	K6wcyirvB4skaQxvffYyvvenvUWjyFIx39tdKcRhWqfyKU2RxehH+nh/Ob65oMNs5vXNTM
	uB2fxapHagLt64KNwEQlU9E+wLcT7qQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ofv89aVI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788186387;
	b=XSuu9pM370o5hnmQciQST6C4tDSsubvGCM0D+xhayeFtL47hF3V49Z9deHTeqI3DuHs/qy
	NU9rhS4C1ZcdnQereszOduovHuZNiRDGHH6MMxeKqWg+fkuo1V3l9A+BBvRDQPDHIvYu9Z
	Bm9v5vM7KlLc+3xX8PxkaloAgxXCMIA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F5A7601DE;
	Mon, 31 Aug 2026 14:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C751F00ADF;
	Mon, 31 Aug 2026 14:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788186386;
	bh=++mDemjAm3frVYhBHw1yycvSVhXLn1wofYJdDWaaqD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofv89aVIYd0IbAdoYRts6tCrlsW/biaOf5xmsUAwpzPSRpgIs9Li1GKDDfQWI14Yb
	 nnk6MDzcjK6R/FR4tB182JY1qKk1vs1549StOht7tUz4YeFuUfI5tDZtBna2CypCHe
	 DGaLH/qRgrcC9PFGGGqARc8lR9t/QlmRJIASssB3Q4dKhmEjK+uwKCnACmz1E2yH++
	 mQFJWyWDCvdmRZbQgzbIFDjJxNzRl+TnuGvQClRTpbZDiNB4o8t6JDTkkuLDvvN+OE
	 6NOeWUCD05UHfY5cw5lGV9UEYz4qDnESis6u7yBZ2djBgHEi3AObxBKRtyjD0SDu2j
	 aWA/dW27t3FGA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Enze Li <lienze@kylinos.cn>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/7] samples/damon/mtier: add comment for struct region_range
Date: Mon, 31 Aug 2026 07:26:09 -0700
Message-ID: <20260831142611.77572-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831142611.77572-1-sj@kernel.org>
References: <20260831142611.77572-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1sgs3obemuz63je48i85pebppt1e8zkz
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 08D3140004
X-Rspam-User: 
X-HE-Tag: 1788186386-595335
X-HE-Meta: U2FsdGVkX1+lvKmXx2HPyImsB9U4V2/Xx/lLVn6ioZo/8Y/e6l3lDDrgJrpiKPB1FkDy9HgXiYPjC8oTSdLj4IwRgadCpjWbygpo9CVJ9fsE3ubO7ayH9J7rkiNdCcYbkfRc31yA9J0aSvYmgXO+emv1EwuTtKSl6ZWhiKYJl7ppYutLi2o+IoKEwP6KcZi7A4mIQycbQ9D2OmttCXfu/fL/5E13TlpH0MWLEUL/JAf+d2ZqNs5XyjyEA1tVShuQUxXXcZb76z0Zt4H+S8pPr/HevQ8XYUSvZyXskk9yjizu09BHJSTipGjwTCQjcsRcsXxJSAlY2a47V6AbwHOLbaNpGpHjt+PhRQmPErAQ3GK+6QzeFqsKgKExcasb4qTV3p3fEcsUtsYmPVOo0tCWD204Dmcu1xst/E1i5KmFSx/j6IGavmlzOFVd3WRHqvyUOccVyOTKes57zLP5HLHFyasTMdEFsPtrDVjwDEAmbkIgzeQaTtK4Fx4alBFudbm7r8wHHN1T+43wFrIz+Dj5EKBY9BQ/lZXg4BTLResbsCy0R9DxJnWtbB/Q5XICdk4jipXa2aPlJtPFVYlSszOA+RF6R7H7IdchqZrPFXSTMWAwqts9V/8biqwsX3PFvTM5W822gCOgWJ8GgUMwSQJTEcBEQ83568N458reNyBJilgrdEiiYYsoAkiN4P2fWFInTJidOqp4vtqj5U1J8lQVyfm19j1/AJQn1Rr0e9PPKUmtBMWoIjUM7Eftq9izZzxr/2jHRMHcBjiO8sJ7udfH5/DVTYSi31er0Fz5QEPTwfIDYchxzVkEjC0G24HlUeDSOoRjab/sJHixKbRqZcTVXLqLSb5YHUeHts2IXzQtr03l2pJl9jm5i1KcDsaDgowiPAi7cCuAboGg9yhMj8nIwbT7GGyNkHsWULqS0O0r4t4urX7kcNTq7OBRB8hofu+m25RRhGKfTB/SmT0zaly
 0DEgU5de
 GNg/7IPTq4zVWxO+AZ1M4Jul95iidhNoGeqnYJEp9OZ4WJu0j6UdVlmLELFSsrbqrH50wsuTGtaefX6jBSgdltq/goyt5OtYIMm5DPw2P6gaKDnmeLofQOnGIC3z+gIUAUKBmsuG940umaHuNZw+EkLE5wQGL4t//uOohj4uUWd+PjGSP4YUO5B1io+ghWwVGhAAJqv7p6ZnKlkqB546YjLTmGWSIti/pw1ug5ch1OxIHW6WEu5B7uwo+pvWxU1E+rC/0huyyAcf2aAYL9O0BjbvfNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Enze Li <lienze@kylinos.cn>

The mtier sample defines a local struct region_range using phys_addr_t
instead of damon_addr_range which uses unsigned long.  Add a comment
explaining the rationale: on 32-bit systems with more than 4GiB memory,
phys_addr_t will be 64-bit while unsigned long is 32-bit.

Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260721070756.54435-1-lienze@kylinos.cn
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 samples/damon/mtier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index d1123ebbfab90..bea45c87cc9be 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -52,6 +52,11 @@ module_param(detect_node_addresses, bool, 0600);
 
 static struct damon_ctx *ctxs[2];
 
+/*
+ * Use phys_addr_t instead of damon_addr_range (unsigned long) for physical
+ * addresses.  On 32-bit systems with more than 4GB memory, phys_addr_t will
+ * be 64-bit while unsigned long is 32-bit.
+ */
 struct region_range {
 	phys_addr_t start;
 	phys_addr_t end;
-- 
2.47.3

