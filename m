Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E038ECD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D6C6B00B7; Fri, 22 May 2026 11:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9AED6B00BA; Fri, 22 May 2026 11:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B632E6B00B9; Fri, 22 May 2026 11:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4B0B6B00B7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 533EF1C06B5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:41 +0000 (UTC)
X-FDA: 84795468282.20.15D6F3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F4161A0005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkjD3l1C;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9HFBKYb5cdZ3muhhdyyxDCFvE0VgsBfb1xW7NVeIcwg=;
	b=QLTT3vMyVluSeN2/B6UTPsC/Lu5kzpLJ+b8Dvve+8IQin0RBxzeTS8Kb5ykadCTnrT5r15
	p3RcyzrAZb1g9lr9WBAMkMnI6pHSuyBUEYPY2XSk9z0qwyZtNvES1fSc7UU9/Fvq8ADsvw
	tLCXJT3peD2XOFGrD+4xKoroTkEWEd0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464439; a=rsa-sha256;
	cv=none;
	b=pjQPT1+gKUrIzIOovpb1Z0Xl5ApP8OEvt7DpwTp0+5dvA40swa9cPiYb67hUXL1Vsgt/TY
	2v7m8cmkA25C72GxECxLsor7dCn7ESxjeOCiMC4/4LnBi5G9O2zFlc1XwQWDWGRkfXNoCl
	49IJAdD87q0jIeSr7IifkYgMMfMvFSk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkjD3l1C;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4416B60204;
	Fri, 22 May 2026 15:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C1F1F0155E;
	Fri, 22 May 2026 15:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464439;
	bh=9HFBKYb5cdZ3muhhdyyxDCFvE0VgsBfb1xW7NVeIcwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkjD3l1CLAsGu8RBoARCpI5T334wRV3SRDm+apej1M6lh4NPpaUqLS7qgBxWPOfrG
	 iKlvJObdsx78z1KAdGCrCHztZ7C+OO7GXq90WN0Fg0TWbXumtw6+ni+ZjmLvGUiywy
	 n6mnM6AKrsa0Utoei959vTjort50kxjFfe670VgxQ879Z9UQDfjy6pHQiTlZOA2IiY
	 yRQmUTA6Ci//9qLhx05MEp5HrdF1/60/cZLNJI8sgECplUjrx5lcyhHsVl5LZJH5WU
	 +joPP1XPdAiwO52OcdH/XxL4hiKwh4j5BThaCRONA2zcGOt0O8l+nn5FBKFke7OXh5
	 X6Ffe828hAxmA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 12/14] selftests/damon/sysfs.sh: test monitoring intervals goal dir
Date: Fri, 22 May 2026 08:40:23 -0700
Message-ID: <20260522154026.80546-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: w45xsho4dm1ne63bottetaowd1njmimn
X-Rspamd-Queue-Id: 9F4161A0005
X-Rspam-User: 
X-HE-Tag: 1779464439-453863
X-HE-Meta: U2FsdGVkX1+ASVmqfNa62iidA9v71gL4ZjgWgMxudfuOY/kzXaDzIF+cpcHQ2/AhpkTOoTaZZFzbJk+joQjZiGcEsJjXWFXM8vfHunpVHP/JoYH+KrMkueFhhuCY7yE/QFxDX1ApaaNl23TxYsMkLfsQ0SMA1YldoruxCZxgwmbYnhrA+Pgkd9RVeZ6VxA+OsLBoSQiXtJPh/gnfWmjDu4A18bwCa9buMloHpt/SwVx/w1KInNaaSIWZPzVBP79csmyREP49lht2daO9Wd93dy5DB083V7loLplExYiLnkZJsc8PIszhfp80K4LdZRtJhcVhIdhUTR50SzdigAZyzxf6MKnmBqksVUEhrDS4RA5FWYZUhpjQMXEVrwloR6N/TOB5eiWAhLmM3nZAFya0ufmH+htWJE95fzXNZ5x8eRqmANRHdQxHElfrRyTvQZhhngVn28Br1D9SILGVK4Bs4g6m7RZYSSzoLtzOYw3vGibikZ8OyBBDcn70sMJiTdDJ6tdaNF5uWhHU1FHPhYt3Kvg+qG01w/78Hv2XW7bWmKQ6ZphobielN7vphUo1u5lbXdeT16xfJdlIur9WRlPEgrj+klSOaFf/pQoxroxL23MLQasq31JFzhbirlOz3zKRmCUsLtgY09751cbGyYiWWqk4PYFQBdDrRBQvxnSw0fFLH3HDx9NOEs1Fo4IiYFP8lkFymE8HlFspmH0vCjlsJjVkNs7X9HijWnNIG5iM9oQgc6+b8AWAhZdvzwUoc6+ov56pTYV1AiEbl88S2CnsHYJg1Q/1o3BVWIWiOiTtTmieMx3BwIb4yJXJhj2lMbByBAepVL93jeBOVagGGx5pTrOO0Oz0Rd/HNFHlVunFUXULE2E67dNglAVSWChsU4lOmVKTAdZ1+lSQM9+jq7e4bHtJG3KYAYYuCZWxpQUThofwmC6hj4Dg5liGdNCji1tW/Q0fajmI9p9Uzmlti+h
 uO5dbHTM
 nnFuD8aUFsjri9nrrv77pgU8yWqn/Rvb1qh/7mOkeQsB+SKLRWcff+H2CX9IuLtapy9lBlVaRBHhW7DTpovksbtCiRv+K9idqURWaQOxpNfvdb5kJl2HDWSK29sc37xOfk0I+3fEVqsreWzI3ScaAJEE1ubOKPaIV9lIH8W347Kwtq3aaBc33mhHwNf8oTSiI4G/dg31sX8NH0p60qel78/NNn0H1rwQxlTjWCWQcQMqR1QA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sysfs.sh DAMON selftest is not testing monitoring intervals goal
directory.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 1ac3e2ce8e448..b3418214ed358 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -282,6 +282,17 @@ test_targets()
 	ensure_dir "$targets_dir/1" "not_exist"
 }
 
+
+test_intervals_goal()
+{
+	goal_dir=$1
+	ensure_dir "$goal_dir" "exist"
+	ensure_file "$goal_dir/access_bp" "exist" "600"
+	ensure_file "$goal_dir/aggrs" "exist" "600"
+	ensure_file "$goal_dir/min_sample_us" "exist" "600"
+	ensure_file "$goal_dir/max_sample_us" "exist" "600"
+}
+
 test_intervals()
 {
 	intervals_dir=$1
@@ -289,6 +300,7 @@ test_intervals()
 	ensure_file "$intervals_dir/aggr_us" "exist" "600"
 	ensure_file "$intervals_dir/sample_us" "exist" "600"
 	ensure_file "$intervals_dir/update_us" "exist" "600"
+	test_intervals_goal "$intervals_dir/intervals_goal"
 }
 
 test_damon_filter()
-- 
2.47.3

