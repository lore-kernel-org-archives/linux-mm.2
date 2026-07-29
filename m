Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E16BFC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0680C6B00C2; Wed, 29 Jul 2026 10:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012386B00C4; Wed, 29 Jul 2026 10:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7B06B00C3; Wed, 29 Jul 2026 10:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A85566B00C1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:03:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E8BD1206C0
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:08 +0000 (UTC)
X-FDA: 85041980856.17.5A050F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4D5981C0003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGotwCuT;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+iR0WBRty/9e25KNHH96FJIzOaYrwS/QZZkMmGIIoI=;
	b=H/bJyxPKxpBfCxcIqHWsuTkFeIbx5SWHIzQ9LAhjDuMyCaptzIkZp9REpupYE1mKe85Ydw
	HOPqMtNYpjAdzaF4ihHRsiZM7nWd70MA8Pu7fr/kaSQntkHkpTaCGb0HOx3/8ChtUUWXoV
	VftPXfKhVLS0Hhg0mlMzipIxllnF0D0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333786;
	b=eGRqs61bE6eKO0qAxO7Afw+7CZv4cHtC+h18biyh4SxYP1EirlhdDmr/Luy0/OeaYDgGXq
	lIbvNyQexcxHwHPAhI2Ph5UjTmUNbqotRHwmuDgL/v5uxwY2YmEPSDGFVAI8Gui1Dns0+J
	eFif7SsBqbvEKXebvuYTpAc6UTRKpP0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGotwCuT;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76A0C44415;
	Wed, 29 Jul 2026 14:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133121F00A3F;
	Wed, 29 Jul 2026 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333785;
	bh=Q+iR0WBRty/9e25KNHH96FJIzOaYrwS/QZZkMmGIIoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGotwCuTMr/A9gzQZQk424gPaV+hmbCOQp3w+Ut6BV4Gr0HPc5yvfsvtxqxAGV0rC
	 wRsvkdLzWnUa+uvnTw1OV7JsPI8wFi+uecx8qRT1e5PAPdZSyYq/9nhXq7txaeUNcM
	 2sosNv8QX/ammNh/f02KhOkH54INLtB7qCSeC7dyDZmydlkwIBrKS7UTv/aQbFIwZ7
	 7u9sZ2wHbVHjdGEPgs+KKk5+h29XNzcUmzEzfnWdUiuJlN/Dw6DwQXp865lGas5kEd
	 Xup4bnMauPSvWrAKHo/yWQ7n9iD9snPjLHcl7eylIQQEyE9pySM7rcFbJm7JK4144f
	 KAJgf0xu+NamA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 06/12] mm/damon/tests/core-kunit: extend set_regions() test for error case
Date: Wed, 29 Jul 2026 07:02:46 -0700
Message-ID: <20260729140253.87753-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729140253.87753-1-sj@kernel.org>
References: <20260729140253.87753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4D5981C0003
X-Stat-Signature: 19ss6trhnfoc73ik6qhgj7tybzfg6zn6
X-HE-Tag: 1785333786-905112
X-HE-Meta: U2FsdGVkX1/fLLMNfh83ERqr8ytGFbMJka5Bri071Q4U9jR8OQg6Pe4urboV6Fk0VLj3TM7JtXD0aUEOkuxgU8yZn2jg5Gjth3IFxAv5KTysEi4m4ui2V9cM/1hdcG1Nk73aiq3rPs7RQSS0BlzWRROpRx2vbjbAybacJYnyCYp/uy0ELWAuJE7wWv+Mtu/RhP03h9zVOJvUeSOf5RrWBybzOtSlhSQS41birSNHecS6PFxLCxg3GWXraybSlDovozhm7c0K/mgXbRLPMF0Pbt3lEA7h3m5QrD0ycCiJo5mt9iChElbbK5iVIxn3bhTLXIkv0U//UkZ66jJETRokqwovOfiZMBk/BsVGuSzfdMQdTz798NOrNiAvr4rMB7XTBFCF61YgW9iYAK207Tj77pMIP9gwR1TKsO5ntQrXiIXXF3OfOCFYC3+cGBZ6B2Q0kx+5hshBUSg6Gzna7wHzdT/mZy//W0A0WMLEuBzLNtV0EPknoaMlxwIEiiqit5+aPHVnFviw9DkgKg7ft5NEz6dNejvSjBYuuu7T2r+wYCttQeZozj8olZQWGoqRDlZKseE6mlEkPYL33mxZeSX7HQ0JiYPFPkL46Fvd1EW/QN+CiKf+XFJg063p3K09+PaNKTK4wXu0oWukb2BkvnbWoWHPwf4Kn4WNlubZgp2iQxwq6odrG/sQNxsOY7zXgrZoNWboyLVSGraQdgoSa1/9Y65deBsT+CsAuFIY2roK68oyt3etmoQYcyejdkD6FYx1hzd6us+v4gbywJqUfhtxvx7vCviovJLffg/r7hcFIin46NfwTyQKUrSF1DEpn1e8D+hE52AuIlMqHVbyCwcSwPMVCACSUTYIBsaN+Zpvkqr/cEv+nTxWnGQJN/yiUWE++Ynq9GPHymLJmsfrOfmf5hSpE3zoJsQ+rpry4nOXAeZxn7rO5F1ACVulucJPiYMl4g6TmtSDUUHE5xP2RZJ
 koys58sS
 GeHT1I/M1JYKR4u3XW3aaW+dKsvHXF2sfjffG/1a04XdkwH/Z/K5VIrVViRYnd3HGrYc7xDG0NxihAmmAYA3ZNl0pe1ULbItYuIg8oPBqGgo4WSIvb4Vkx/qq4+xsvWYfZqqBKdslTxsM2JYktkWGj0K9L0nRuk9qBXTq4gl+DnafCxuzJbHhP1LJEL0bOAOHndyZvOVjHVus9t1M/DiBLfUJ5HnPPtVwyaOejIVbN6EoQpdYm+VGjkiPbxhb8u2or4yzILlvj1jxq/tP+p48P3yi7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_set_regions_for() is designed to test only success-expected
damon_set_regions() calls.  Extend it to cover error-expected calls,
too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4a536d41cdb2d..befc1196d6d60 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -463,11 +463,12 @@ static void damon_test_set_regions_for(struct kunit *test,
 		struct damon_addr_range *old_ranges, int sz_old_ranges,
 		struct damon_addr_range *new_ranges, int sz_new_ranges,
 		unsigned long min_region_sz,
-		struct damon_addr_range *expect_ranges, int sz_expect_ranges)
+		struct damon_addr_range *expect_ranges, int sz_expect_ranges,
+		int expect_err)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	int i;
+	int i, err;
 
 	t = damon_new_target();
 	if (!t)
@@ -481,7 +482,8 @@ static void damon_test_set_regions_for(struct kunit *test,
 		damon_add_region(r, t);
 	}
 
-	damon_set_regions(t, new_ranges, sz_new_ranges, min_region_sz);
+	err = damon_set_regions(t, new_ranges, sz_new_ranges, min_region_sz);
+	KUNIT_EXPECT_EQ(test, err, expect_err);
 
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), sz_expect_ranges);
 	if (damon_nr_regions(t) != sz_expect_ranges) {
@@ -510,7 +512,7 @@ static void damon_test_set_regions(struct kunit *test)
 			(struct damon_addr_range[]){
 			{.start = 5, .end = 15},
 			{.start = 15, .end = 25},
-			}, 2);
+			}, 2, 0);
 	/* Un-intersecting regions should be removed. */
 	damon_test_set_regions_for(test,
 			(struct damon_addr_range[]){
@@ -523,7 +525,7 @@ static void damon_test_set_regions(struct kunit *test)
 			1,
 			(struct damon_addr_range[]){
 			{.start = 18, .end = 23},
-			}, 1);
+			}, 1, 0);
 	/*
 	 * Holes should be filled up with new regions.
 	 *
@@ -544,7 +546,7 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 8, .end = 16},
 			{.start = 16, .end = 24},
 			{.start = 24, .end = 28},
-			}, 3);
+			}, 3, 0);
 	/*
 	 * New regions should be able to be appended.
 	 *
@@ -566,7 +568,7 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 0, .end = 4},
 			{.start = 4, .end = 15},
 			{.start = 25, .end = 40},
-			}, 3);
+			}, 3, 0);
 	/*
 	 * New regions should be able to be inserted.
 	 *
@@ -589,7 +591,7 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 0, .end = 15},
 			{.start = 25, .end = 40},
 			{.start = 44, .end = 50},
-			}, 3);
+			}, 3, 0);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
-- 
2.47.3

