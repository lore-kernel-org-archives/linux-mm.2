Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9578FD2F339
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC426B0093; Tue, 13 Jan 2026 10:27:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456596B0096; Tue, 13 Jan 2026 10:27:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BF46B0098; Tue, 13 Jan 2026 10:27:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1AFEA6B0093
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:27:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA9191AE13
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:34 +0000 (UTC)
X-FDA: 84327320028.14.FE8F8B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 27F3DA0011
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zk2ebu7+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768318053; a=rsa-sha256;
	cv=none;
	b=DOM4VvZkZZNDvUKNwP0tU4/Xrw8EpOZG9uNowm1BiC+S5SM+A4JJaOknU3fcVev0039HBw
	t36yNkhpObPE4U9v1/1o+LoMCIOg1kwmoa7miG9D23Yo33Bb+jcPLcF6doHsbmkshAFlbI
	pCkRM0XyF38YFgSFNAdEZWfcQqaP1NA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zk2ebu7+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768318053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yV3CItRgDxKlCZYlJA+TdKJFXxDP5njfte/e0To9jys=;
	b=xqaM6zPUiqdb5ZLVFZa+D6/zl8qOco5GqP42n/IxHv9hVounWALijLsz0Dqs/EAL574b8U
	thitva6zMPInHAQUJjPOZHSw8wGT4E1+fj9rPMRsPMpIBzy+V3GDnNEtJyZ9VpCo+8jTbs
	Q22qiwuST08BaNUkeTQtA5eNaNO6JBk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D38A44442;
	Tue, 13 Jan 2026 15:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01167C19422;
	Tue, 13 Jan 2026 15:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318052;
	bh=Ps1Llk1zn7k8iBguPu+c50Hh6cMt1or4lC99Uh+5urc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zk2ebu7+GAxnV8yJ3e1uSgG0okFBS2+bpqblZ/XsSuXKo3ZOACswlTS/P2AgCE88i
	 Tf8A1g6E1f6j0068Nqhxmr/AJhZSGngoDXYG5DI4eO92dx/edIzFSnx1UzF2uE9HCb
	 oEyIqtftImRHgSNsTgu8n8aOFkNCiBz4oKrSDTROyi05aPZJanwziQTd/8JkjyVdTf
	 45gWlqMgZCyL3BCLM0Z1VIqHHh+UFyhONN+y5f5hQK/iGQAk+ImdvyL7ab0QcCAHUo
	 WkRbzVUVrQYxD5Eea8XTJA0Ax+faZMBn5uVkBI1uUiLHCbAy2JfGE3axG5voYRLye9
	 YxnOY/FivKOHQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/11] mm/damon/lru_sort: support young page filters
Date: Tue, 13 Jan 2026 07:27:11 -0800
Message-ID: <20260113152717.70459-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113152717.70459-1-sj@kernel.org>
References: <20260113152717.70459-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 27F3DA0011
X-Stat-Signature: hw6ikbi1pe4wmtr8gau6y8bno38whdcs
X-Rspam-User: 
X-HE-Tag: 1768318052-248166
X-HE-Meta: U2FsdGVkX1+rhs8i0KVJh2UpT3aQjDSPli1/mjwaFI7YwqK6Hw2Vqkk9+W7aacFrG27O5Wk7YmqkQGEgK/T7N1B2oRfKPbh9HCZaZvrmtftuWz6G9ZtxI3M3tWGpWxVt7l/J8vOcYL4hVAb5Dcxd/rAQ1TO5sA96zsQEc1nuAep935PBV+V08saqDVCRDtPDx/f5uHIkddF5kT+8/2Bjw/zeTNfdcVo/DQ8SyZ7FtFG6Sl2UzvpiULWfAdyOrMmfjpNuRMa3Zua+IBRO9I3fkXKKCFuSPiX7I773uc8uUM5CkqGmCGmLz53L0AcVLmiEsLIrqeQw2DUNfuScMC0K5DsMp2W5qUyew8sgEeMTWGUxpjEtdG7lr+AS5d09SqAbTiyPtBds6wp9fmoA7XGvHe7JWZAXJXndwlmrcBbGwZmgo5Bztcj6EI95mRRzu0HKl4cW6EZvX60B2mBR2eTDZT454ECmOzYdz6pDPwtIvEQ/zhjVzvnvw3TTH6p2ZGhAMUPlkn95+pyZ+WyX7tp9V1ymkH/co1dyyiji9hnG167pCns5eqdRETy4F3aBWW3s+qRREShS3j2yt9SM8Nl9x4TzkzpbkQ/EnsuS4u4BwfbXV1yFuFzUA7pUHWAVH1ag8aa1KIvdqhfWH9tqH/PeLp/HPPjs6ioZ/pC5JltXlbB95ed6nXDxwyESSEEqbqPNKQb4UAUxysNMyrEfkYKwTVjPScZlYBYAONJAIH4bKblbsKLeggiBUpXBjheUo0erXE5HYoqbtqQw2o6xLtcJJwyQhzPcDMnURbUlJuCRpCK1BVL+xWF0hDNlWy2xb++PQ6n1To/kPau8vhoCZolNr8iK8eQf5+x3eCerxLiGT0ygr4xnWqQvtBSkOhMZXj3C6luTsZ9MasFGRJqxy3i/i1myfHrIaIKYKQ8jAxXLnWZ1ccdz2+8zdacHS9vXL4GDPOgOI0Z4kYX6BPWqwr3
 S8O31HSF
 EAJBX6podEiVA49TFzrHGRBQ6EdXLACHNzHdWEQ0FcjofgEY4t0KVk9bqUtzpKyMMT/abgjyLB+LLaW0JW2vD3eJ1kcRFZzOih3Rg3PosT+AOI5W5PoBy1clQs49iEV/CKbXGkg1QoNCvAI4e3rxCmlEnIZkwwgD17PMS8qJxzZ6NAyz4B29ffiaO/aJR9YgldMU1c6+efqYNyAy/EsSXOKRdb9LFTbLhoewELPcNtV/QTlDbB9CELJdDc9lrcFm6slTUDUi3/Leey4fXzczJKKa5jzeAHLWKQvJUaVsRsGMdkDoAxv4vXnjG4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON monitors access patterns at the region level, and hence there
could be some page level mismatches.  A few hot pages could be located
in cold regions, and vice versa.  Young page filters can be useful for
doing additional page level access checks before applying some DAMOS
action.

DAMON_LRU_SORT is not using young page filters, though.  Add a parameter
for using it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index a74c4ec170a9..f1fdb37b9b47 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -41,6 +41,21 @@ static bool enabled __read_mostly;
 static bool commit_inputs __read_mostly;
 module_param(commit_inputs, bool, 0600);
 
+/*
+ * Filter [non-]young pages accordingly for LRU [de]prioritizations.
+ *
+ * If this is set, check page level access (youngness) once again before each
+ * LRU [de]prioritization operation.  LRU prioritization operation is skipped
+ * if the page has not accessed since the last check (not young).  LRU
+ * deprioritization operation is skipped if the page has accessed since the
+ * last check (young).  The feature is enabled or disabled if this parameter is
+ * set as ``Y`` or ``N``, respectively.
+ *
+ * Disabled by default.
+ */
+static bool filter_young_pages __read_mostly;
+module_param(filter_young_pages, bool, 0600);
+
 /*
  * Access frequency threshold for hot memory regions identification in permil.
  *
@@ -193,6 +208,28 @@ static struct damos *damon_lru_sort_new_cold_scheme(unsigned int cold_thres)
 	return damon_lru_sort_new_scheme(&pattern, DAMOS_LRU_DEPRIO);
 }
 
+static int damon_lru_sort_add_filters(struct damos *hot_scheme,
+		struct damos *cold_scheme)
+{
+	struct damos_filter *filter;
+
+	if (!filter_young_pages)
+		return 0;
+
+	/* disallow prioritizing not-young pages */
+	filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, false, false);
+	if (!filter)
+		return -ENOMEM;
+	damos_add_filter(hot_scheme, filter);
+
+	/* disabllow de-prioritizing young pages */
+	filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, true, false);
+	if (!filter)
+		return -ENOMEM;
+	damos_add_filter(cold_scheme, filter);
+	return 0;
+}
+
 static int damon_lru_sort_apply_parameters(void)
 {
 	struct damon_ctx *param_ctx;
@@ -240,6 +277,10 @@ static int damon_lru_sort_apply_parameters(void)
 	damon_set_schemes(param_ctx, &hot_scheme, 1);
 	damon_add_scheme(param_ctx, cold_scheme);
 
+	err = damon_lru_sort_add_filters(hot_scheme, cold_scheme);
+	if (err)
+		goto out;
+
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
-- 
2.47.3

