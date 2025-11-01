Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391AACCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908548E000E; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86BAF8E0012; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 694168E0010; Sat,  1 Nov 2025 14:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E80C18E000B
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B28461A020B
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
X-FDA: 84062853924.22.3882F24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CDD6040006
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q0pNGtMs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5It080ofLhmCHogcqPg9tmOAOOkJXOcDhAsKts2jYH8=;
	b=Z0o84vBsTb1qYc4uOnAx4CsWVvKqvlcvsEg8BbTkaYBopm0k8IyvYypXo50C81wcg0Hq80
	VBsZBcuk0dmQcrngDBa8PPPkvBvNVVZ7JBYXE9GswijFDoLvmAvfGT8tN3NHI+zGybokGX
	S+5M4YSkDQi0OcrB25qgVfnTogyx/VY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021240; a=rsa-sha256;
	cv=none;
	b=0/DJwry0dYkKWB4q4t9vYaXbHFWDfCcoz2ObUtAMsXtowGBjbJ+UWjjPmKVv/AehIJAP0o
	oDljTtFlbO6qLzD2L0larkhpxq/c52MteRYG1kcbhTGjOunD0zZ3zJC3HpIeMFI2qoBrie
	uGdywA6jdLaogga4KJxRlfFOzM1sbjM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q0pNGtMs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A14B4435D;
	Sat,  1 Nov 2025 18:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C2AC116C6;
	Sat,  1 Nov 2025 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021238;
	bh=57kC+8zBcKudPnCnx3LGmauWpC85FOLpVi+rp5j0Qcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0pNGtMsrufRK+kEJFJrtki3V3cJOp38O3M0vlm+UIv8hX31367RJuWecM0108LCc
	 v7XKC9Q62+gQVFmuxewnLt87M1IhTLf1nPSXBs1V5/QGIvm4u04sgxjysm1aQc2noh
	 LWyVKFH+7KvlCR8eZUWDkUzAakj+7QxSDvz6KtNjG11xXaxD/PMCNqApWPFB2BBkwM
	 Ga7qs2fUk3Lnsx5Qx/Am3lZkB2WM3nesVH/yZNeDCZhmouO4a/JIpKdsLA3U1sFgyZ
	 8iWbxO588pd6OoDf+OwoZHuIq9iq5K65b2C5Fki6kavJ493+CEKGwLhkrHCndTlUHW
	 OOZUbfIik8afg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/22] mm/damon/tests/core-kunit: handle alloc failures in damon_test_ops_registration()
Date: Sat,  1 Nov 2025 11:20:03 -0700
Message-ID: <20251101182021.74868-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CDD6040006
X-Rspamd-Server: rspam02
X-Stat-Signature: nfuz7e4x1z8dzfui6az4zfiywu4k1wn9
X-HE-Tag: 1762021240-670075
X-HE-Meta: U2FsdGVkX1+8ve2hegbXS1+0ISEHyoD+Pky4TmcY0kBEr6M0E7Nc1l0+BLxi27DnHZEwZ6hGm4t84bjyW7cdPfiuxHAYfjYh6K1W7C65MFO1TDi9SGgVNbN07K5gxZSvPEhNnDs4sn+XrXCDT13Q2ZBxkeimDdnp7988DP/mBlOVVmQ37SsiY1+dm5Dns7uA9PdyxdkOeJhrhxRVT5DN3JYdgnN7Tx9UBCwckyS/RybBNr/pthhDQ5aptWiNIigKZFb4shMsjm+oKcZ6srxWdXacusdxWk9fLd1Cd2yPC7SejcM5XLvU6u95ZwaDT/etvsYx06LXB3puLUdspmnd1GApQdicFbE6HM0Jpm1NJ1DVl6LNn/pRhTRQjE2JskUj0Hb1XW5PKidWtdZHARCXrg2EJ3YvAGYbFt+z97qwXEEraA7DueD5j+BrtY6byUfT6FlWCAFvB2AY1qAcRpBFjMRLEvacCUsU9ueZYeBMkFfBtQEOvkgvduM5Da/Eiq3e+SfgzWbTXu+8gsqZMrTqHBJNOKiZqpA2SNb3fEtSIZyUrdHYXNFp+E7Qb8wmInH5sGX9BJjOmYVUBlmeAPg8G221xR+VlYChmKh+vuy9l4IUkMuvn4JFvIVNPQ64c+Fvn9x6LpPpBg9q81jniJB88UtJaVKfEpN1v65y0Lu+EhZB9PP0tLQa09S28vq1lfEZUgLaFR2YoURiHTqft7x2/R6+RyxDc1prQ2cLJAuYABBiyacWDsr1at+bbjdWMPsukAAVrsP9YIiGTIwPAEfMu1EqVKxcJ1T+DsP9i+EhK8wY3dISGvxqYHsrZNedk8zoFMTYIzs3LKy6oCZArVG9awYQejKBEGxwMJR7kl5WpLhCaZb/hB0s/U0mg6jhxzMUh+UzgeTiuXr+YqrDROYiq2gZNLEkTvRNCwE5oEKT3Q3neFL2AgDtvYB7inW8ppJWaeZRQYm8tVToiNnIv1R
 NDBk6BaT
 AUW191MsV3DUg3j8EBfDy6lL5Xrt4aW13AW1CnW1QiA52gqlwWySRDqbwIIDkUiFic+nK5KNdaTrL4jAmUho8UXCddKpzPqf9ijVI7t1AtRRlIdbumBBYWT5KkIbHQxywp4754uuA8fFEJf24tOCKzIJDsHqgP/9fH2rYkwJs8OI1eTxlifJYO0qY4YQd2I1EqT6D2Gsm1ubB+Euk/D9xJZQTgY03hL/IDw3g565D0r1uqhyb6wFCRbyYdBCr92HgG0+GTiIpfWCtaT/mLnh2c1rMOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_ops_registration() is assuming all dynamic memory allocation
in it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: 4f540f5ab4f2 ("mm/damon/core-test: add a kunit test case for ops registration")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 10618cdd188e..96c8f1269f44 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -320,6 +320,9 @@ static void damon_test_ops_registration(struct kunit *test)
 	struct damon_operations ops = {.id = DAMON_OPS_VADDR}, bak;
 	bool need_cleanup = false;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
 	/* DAMON_OPS_VADDR is registered only if CONFIG_DAMON_VADDR is set */
 	if (!damon_is_registered_ops(DAMON_OPS_VADDR)) {
 		bak.id = DAMON_OPS_VADDR;
-- 
2.47.3

