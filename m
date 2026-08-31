Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4A4C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0336B6B008C; Mon, 31 Aug 2026 07:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26EB6B0092; Mon, 31 Aug 2026 07:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15CE6B0095; Mon, 31 Aug 2026 07:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BEBF66B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:37:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6C94C0446
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:37:35 +0000 (UTC)
X-FDA: 85161364470.27.209DAAF
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 266D3140007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:37:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k4G9jLSw;
	spf=pass (imf23.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788176254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FAhbWor4DKGsX3doFWg/6nm52AV3PsoJHNom3kwfce8=;
	b=C8nEJGX3+Xo7WB3By4Hgzo70JgkDhF/nTaPOuVI7jhU0XX2E2N0n1g6uwDlGFk3WHRufSL
	FZDiZEifn3Gya0fRaTkTqxSi9H47r/xH3XDIx8rBUF1aOY3x81N4m9ePZYoE8A06rnUnGP
	JxigI73uWCLzBfXAPb0Wxk7fLn6YNQc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788176254;
	b=jYHmy/VtLICAzF1gHGMi2IigOVu+ArE+fUXo1rxIJTV4nmGGyRm1CX7LRwHrx/+TCL/fqH
	vH/B0GJs1Gpj3NpMSg1xZbFM0nhxErcsOSGDDw1aAvQqUjtuKCXhCUbgMGtGvviL9GGbDi
	mUsoFovEysF6WqQoP28RcBasTl9f6+A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k4G9jLSw;
	spf=pass (imf23.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc1cc97b84bso2971772a12.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788176253; x=1788781053; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FAhbWor4DKGsX3doFWg/6nm52AV3PsoJHNom3kwfce8=;
        b=k4G9jLSwGDBsDAcheaSt+20wQixwJamB7xq5vRe575ZJW6dcnLHFDB+nkn0YCe7iU8
         sbh5xCTGOp6+fPlCwYFgYQ46jzPx05V2JkMlLM6Ch08pltRlwqj/P5BX+0KZr6Ps/abV
         hG3JxeccxecdoKNTwb5R7hV7ujEcP8nPB4qIuYUDDzGny2XSaNSFki8an9456Mz2ofFZ
         8h0jkIHeegk267z7XSQPMR5Ikj4Fewwz07zEhvoRFNNidM6siPVGrIefNivSRZEvJVWD
         bULPfkCtY2LPKsVloi8WmP53D7oCZcVZUDiHteZMQJh5CUwHcTovXT3libZbN/pY9svV
         c3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788176253; x=1788781053;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FAhbWor4DKGsX3doFWg/6nm52AV3PsoJHNom3kwfce8=;
        b=KqpdfPqPhCXNmfYXcgC935P/+PWKdoUOt4c0dqRrZ7hncYK6QMuipFsviBPzNjlFE6
         bQFpG4ishGYlJdixi/xlBQpnUAQhyqqYHuvsYuwCbBOa+lxwbH4/OWvI7Su+UMAQB9bj
         Jp4FjkhsGGMB6jSVOk7CjYeMSq4ihMtUZ2oRSn5oRfbo4KI8CpjHkqa/L0vOa3q5TyUt
         wE0iX6X+1MD0hGprD8tJK/g71L5v4rzQWW8JlWqrwiOmovAtOe5LGU69kjAmGy0GfY8x
         frgqixFUzI+jjZpBlr0ASakaWYCv4YONKEJlVCn5xpxKYJvIHlD26tbbQ5Rh/VeoyTdz
         QbEw==
X-Forwarded-Encrypted: i=1; AKwUvByjEfA7GDubfBn9ZB7xdQSmTXIwl/9miIyvUPcZTcXe4Wsn6XtvJH57VsUPS77IX2ZnHczdmVCXCQ==@kvack.org
X-Gm-Message-State: AFuF++kofvt8UQ4vbgFCSkAgma2+fiAQvjfCT4u71xagG+Bo20AWTGGt
	mA/JTxy+cPXH4DpNyavSZOw4wh32fmDFc1SIxEkciqoyp6PDRLP2u4AF
X-Gm-Gg: AYBFou3nootfV/feXs+vLxE3Y2a/UwR8I3XLmnduxbqHn/39dPDVVi1DGOuLF4VYRaj
	FZXeOMDKRmGojToCpkM7doUOrR6hF5RI6GMlvGOd1Kux4++ZB2JLLwnYh9Wnhv9gXUKARsNRpOe
	0NxDJ7sVARqIEWO/Dq8V5OiekHGc5J68ey3SEnsaiiwyTx7k4SS3WmAFCgX2j7OQZNxSWlHMMAv
	qSd1vWnccvf5PGxw/4lrukggeA10lqrHiSzmalLNvkV995YbXB8aTE9C8BVXfSb2TxbQ8RL6933
	lFRiPGp/WC+GV/26aXaPo7MzYKBwH60IIEDqAz22EAPqY3IJw25jZ/RZCVAueF1fUcOMFGGdluB
	RDRIFWmlIerW0DkWHmqD7ZAcUtgAuuW9+VTS4jkiaWmmdIptZ9kKuISFOMvin9FW7AMHhR9qFuV
	GMuimPG/cEXBx13m9dYtqGdTlLPDMZnypv+rfaBLxgef2AL3hbxPfr+T+HuhECec1c4IFCzUJf/
	D9vN3vVGNotcBi6
X-Received: by 2002:a17:90b:1dcb:b0:398:dcf6:d40e with SMTP id 98e67ed59e1d1-39907db4f46mr132089a91.17.1788176252810;
        Mon, 31 Aug 2026 04:37:32 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396ddc08266sm17197591a91.11.2026.08.31.04.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 04:37:32 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Mon, 31 Aug 2026 19:37:35 +0800
Message-ID: <20260831113735.3349-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 266D3140007
X-Stat-Signature: fo77b4hfbcbsjpoiimihemhjmp7yqqcs
X-HE-Tag: 1788176253-399352
X-HE-Meta: U2FsdGVkX1/0H77m6xN8NlKNRET2UbG9TXErcz5jP2zHIfKMDmg5HYkoH+eGyTVTAAAxOPtZZFj7tAqddXhO9WC6fN7ekcnnAcv8S6TfaKYnGRSAEUNyNpVAomt1qsz1d4AlbB+eGO+hkL9VNDghgsEHJrpNwkm2Zjn1g6hAHjrCpI2bloNXUb6PNmXWpGR8bCDF6rF4G6fVYd+6IYXbzeqgTLBdbItgW4h4446B92ay98lNQm22DiFYGtUkl577xIblWRBaxpisIfXMpNo2xYqPN2lbQeyxqfnB5qNA6YlLuuqSXkxGr0n+kXu4lwTL11p9y/cuGYY21/RDH10LT2Y7ygPm2M38ndAarQEO/ksmyo4+Gaf1WeDc7wnWn6i1QZqU2b48pZXMzbU8JPsTcS7KmaBaz3ENzluBcVPK8FDjtcBHha3Au9AK6MvST6HZzJFGeb9W1e/xumb/Q+T9tVIbXTG4gTPrM+Qy07zoAo+q4u18em0NGK/hiCxFeIqk86hXOJRkfRBv7LxHS4Z0mIG3dbRWOBqILQJ8awg+itT8M8Ns7hM/lomn8DKut1N2jExWXFaEPiMJUdCbEZo+0TcqTmtYqI4sWdIEMtpzm6Xl5GFmT1f/vA87GDDyWwuzrDYjeS9tJgBJ+ZmLlAaINCMUXNOcheHGgCKguTlARrnK0FqyQ//bgRv5AvTmcBIvluKVTjX7NMg3QmJM+yOpbh484Z9OgGRNhB8alKClK7O2jOe6W1IpqCgFLBaOYTc+yvCmxXNRFsDZlSBV3CocDzxPzeOO7LIMbvgRviUONG5jiRywaxZY3L1X38ehvYCyhLnwtobsIaSyIGBOl9PqtndXkYFrgjhpaWiQR0Pur3MfIIW3kiLVU6ip949dvy6jREr8QVGf7fWqjLwjGosFCEtad55oDSUE5I6k19M94B9FlyBK/mhOdtLg9huVKk/9925LAPCMAtmVE5D9+SL
 dF3r3RM8
 62P6AIzCKE9W+Zsz5GawWSj91lQafESUaJv/JVQ9cdpPrMF2viBzN0ssA2QOZGp3MDzEZ7/XXC0MLxo1vp7XtlDJ4xXiMHJrajUKf7tPlkpCtRw6uTHX0OL0hy0RNcXc4B6r4oFzy46ySxsEjq1GEnhiSUx+nZ3rQW7qU66IyJ2dqymbOlAD2ljmcyAP3KaPCWzXKNauwA3OPUIyNJRdpTgMr6zGvkWu/+R5FqfDKHAN87feWWLMbL53E4L0IBnS3SouNDFjZC58eVmeGxMESp6YgR5R04+nuchTJbptIwvy0LEdK8eEGo73V4/gcaQVlQ4ETrhVndPVOf3Dsw3mhcRDIwzaVzwimghgdCeZ5B39omXWqGYNEJJjzNTmSdFwjXongn0EkiQCSQUYJCsUziuR+Otbvi3N7juIB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 50585192bc2e ("mm/damon/schemes: skip already charged targets and
regions") introduced a minor issue that causes the last region to be
skipped before it is processed.

Example:

    1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
    2. Quota is configured to process only 100 bytes per window.
    3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
       addr}_from is saved at (Target, 100).
    4. Window 2: The loop reaches R2.  Because R2 is
       damon_last_region(t), the old code unconditionally returns true,
       skipping R2 entirely and resetting the charge_{target,addr}_from.

    Result: R2 is permanently skipped even though it has never been
    processed.

Add a test to prevent this regression in the future.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/tests/core-kunit.h | 43 +++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4a536d41cdb2..90b0fda34fba 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1632,6 +1632,48 @@ static void damon_test_rand(struct kunit *test)
 	}
 }
 
+static void damon_test_last_region_quota_reset(struct kunit *test)
+{
+	struct damos s = {0};
+	struct damon_target *t;
+	struct damon_region *r1, *r2;
+	unsigned long min_region_sz = 10;
+	bool skipped;
+
+	t = damon_new_target();
+	if (!t) {
+		kunit_skip(test, "target alloc fail");
+	}
+
+	r1 = damon_new_region(0, 100);
+	if (!r1) {
+		damon_free_target(t);
+		kunit_skip(test, "region 1 alloc fail");
+	}
+	damon_add_region(r1, t);
+
+	r2 = damon_new_region(100, 200);
+	if (!r2) {
+		damon_free_target(t);
+		kunit_skip(test, "region 2 alloc fail");
+	}
+	damon_add_region(r2, t);
+
+	s.quota.charge_target_from = t;
+	s.quota.charge_addr_from = r1->ar.end;
+
+	skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
+
+	/* 'r2' is not processed, it should not skip */
+	KUNIT_EXPECT_EQ(test, skipped, false);
+
+	/* 'r2' is last region, it should reset charge_{target,addr}_from */
+	KUNIT_EXPECT_PTR_EQ(test, s.quota.charge_target_from, NULL);
+	KUNIT_EXPECT_EQ(test, s.quota.charge_addr_from, 0);
+
+	damon_free_target(t);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1664,6 +1706,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_is_last_region),
 	KUNIT_CASE(damon_test_walk_control_obsolete),
 	KUNIT_CASE(damon_test_rand),
+	KUNIT_CASE(damon_test_last_region_quota_reset),
 	{},
 };
 
-- 
2.55.0


