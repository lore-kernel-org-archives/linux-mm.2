Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 644B8FB5173
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 01:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3356B0098; Mon,  6 Apr 2026 21:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6DB46B009B; Mon,  6 Apr 2026 21:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70C36B0099; Mon,  6 Apr 2026 21:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B4D6D6B009B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:05:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81A761B845A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:45 +0000 (UTC)
X-FDA: 84629967450.12.A7B96D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E9AFB4000A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CwkGFAQZ;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775523943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rdaam9BwVxK+HQPMM/xSyzd71ZxUQuLXDJfRzSuG9c=;
	b=SZ997dXH/nZf/5OUEOyQ7rptw74ZDDxgEFiaUADFURcGvDev211jEJSnfG7gNR2WyNZaK+
	lYxRsFLCw4eGp2UFvJa8NP2xw3TRK5zxDxZ6KrAXjdtlV+Z+IlDBouYppwi6Al+FrxhvK5
	JOHxiRh7xP4mjNTIoweBGU3B3m5YCgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775523943; a=rsa-sha256;
	cv=none;
	b=572/RPC3E6M+3wUDX2gKJFuxDzwCN6SrJuipNZVR6BsRMPvpVVZCDEvZGAh9n34r52VynC
	mCe16G6N0AeeL0ALTmkpIeroHOHeUZ+QszGQFv13kvbff5cNzfVipDETEmvnilhl90eLcZ
	PFAlp2QnMEJgymuxrrut4oar8pp2ED0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CwkGFAQZ;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FF7161334;
	Tue,  7 Apr 2026 01:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD864C19421;
	Tue,  7 Apr 2026 01:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775523943;
	bh=oBXW5uIN8lzshHczxlHFHeX8VLmiX/5T2Hz8N+WZ/sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwkGFAQZhiE2k1HNhGKP3cVgIFKS0tGi/CdixQ8n7LRSFm1QDHjfA7KDwGqaaaW9S
	 3rzXs/m6sK3LvyXQUb7weap+9k6h9cQPm+NmRRRWyo6PjF+YgYn8Ekl07x428cNiH1
	 tR1d7Hw4/s0dHtEtJ3Hc3B6tiK+P/IkVow4OWZDk2yS2/l+DcCIvYR2KW9EO+NlbDe
	 NaXADeplG24hgdyg9J8JzfZ3qptLGVHzCk9os9+Sl8wDsTQ9NkCa1d7l1EmLXf049H
	 RJ75H1UrJFZfNZKNXQPhSmFG8iuvliFQIVUKRrDj3fbDs83h8ILyYAXGAxNm2haB1c
	 QkRFaAqy47xig==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 07/10] mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
Date: Mon,  6 Apr 2026 18:05:29 -0700
Message-ID: <20260407010536.83603-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-1-sj@kernel.org>
References: <20260407010536.83603-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: hf18yf8t4xdrjj36ar3dm6y8gijzudu3
X-Rspamd-Queue-Id: E9AFB4000A
X-Rspam-User: 
X-HE-Tag: 1775523943-917285
X-HE-Meta: U2FsdGVkX18RWUGCN7sI4kpY9Rl6G9zl5ptsUi8YNV9nhBRy1FjIN8rmWk+n981LODQJhRLkElQkRmIdaqMsyuP/ON+dYoO7iQb33wPdoQpGXL1m5ijIIO7ejVbCI7vYTm353JYKHEzH8Az8J9VD+l9Mim9YPzyIlt3kDABtv6LvMPuPYuS0RolLT2FK9CY519BWshRNctmxtUFZiUAyJpTbYdHkTzhPkr8G9yb/m/VNISVpt3K/QWip+2kzD7GJLVVMyrRcJjAjAlYyLIrZ5eNhci73ATnyG08Qp+gtJ2YVyYR/UgtYQUKXp+frxLHhmTeEvmK/aYjVWWonZGObB3ppF6pIszyN/9Z9bAGqz8kqiopil+tphj+WU0HYMxZ3aRPIkCxw7Q7RVLIV1eFiXFfr8yKvvcZGM84bW16vdhoaTuPz1aD3Q2efLgDtLVkwB/GTdhs9UEPkvWZa7MkpsEhEft2hwbgwAxJ7OMZEBl0xVT/U5hHXyQ77QwMvt76bk3JqD4DjO/Zpg8UE3vqQL8EhPV1aLv9kaDzZyMNycO6qKcP4T12ozVWy3FniwLklvj98yNfhfsUBlmFupJ4k5URJQ3Lrr/sfL5s+otvK7SRgG0sRXghhKhcbX3prfmneZ35xScSIX5Dx80mWtCpJ6uRQfS2c+vM9gnGpXvmq19QKImUVr/8D23sZ0u2Yw2YhMtHnQ4OdJEWsOg/0DzyfRRxxsNBhb5JblAPvfUbpBrHEM9Y8vAYUhz+jeHKQEc3NU8PTxpyYDDmTcXKyaChOIN7wTxxYsMDq7tiyJuwfK710XWpcTOHLyWrYoTSCjnSCKkQWA8v92g5mFqDbIf8MYpCha4RMTr9v+voI6bL1y4an3/Z77/84p8OfwDBaUnnj7Jxdzk9UJKtJN3M8h5+ls2cXsQVz56uRS8LYonRb4uTiqX2fbsl/mKUX5PiMjQXQII4ljyW5earaFw/4FKr
 zSOOQL9p
 rR3yg+3mztm9qK7t8NdDsj+UQH+Bi/3aAKxbAajT2w0aU+/Uf4twCv2NqoMREcI6lF1/5jHoASfFu5A+gvETVGGi+Iax8oFW8AwrIPeoly6LcgXSp7oVNXSq12f/be9LPnXMDlAFHS5mXeoZz9lG8rFbcpF+dRzGJU6I2C3FwdhdWSuQNscKvSThI0bK+dyUJVMzi8x10HiKzF0M9IGI38E6fq51n/JugeanhomaGOmtG/KFiWdjMvGHwvCNsVsLPlyqn+BY3py3maVqS/Dc4umtVGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damos_test_commit_quotas() kunit test to ensure
damos_commit_quota() handles fail_charge_{num,denom} parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0030f682b23b7..1b23a22ac04c4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -694,6 +694,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 2,
 		.sz = 3,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+		.fail_charge_num = 2,
+		.fail_charge_denom = 3,
 		.weight_sz = 4,
 		.weight_nr_accesses = 5,
 		.weight_age = 6,
@@ -703,6 +705,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 8,
 		.sz = 9,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+		.fail_charge_num = 1,
+		.fail_charge_denom = 1024,
 		.weight_sz = 10,
 		.weight_nr_accesses = 11,
 		.weight_age = 12,
@@ -717,6 +721,8 @@ static void damos_test_commit_quota(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
 	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
 	KUNIT_EXPECT_EQ(test, dst.goal_tuner, src.goal_tuner);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_num, src.fail_charge_num);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_denom, src.fail_charge_denom);
 	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
 	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
-- 
2.47.3

