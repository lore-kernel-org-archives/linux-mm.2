Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F756E9D827
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 22:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E12C06B0088; Sun,  5 Apr 2026 18:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75336B0089; Sun,  5 Apr 2026 18:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C64166B008A; Sun,  5 Apr 2026 18:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B128A6B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 18:54:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51E89E0250
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 22:54:52 +0000 (UTC)
X-FDA: 84626008824.07.A29A36E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id CBA444000A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 22:54:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U0aMKT9g;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775429690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=n4B/zdQikZt9oAfdOXcCF/bsM6aWoDAb+7LqD4fXasY=;
	b=ksPMgq+iVhqw86WJyL+u2XIrCgWjMR9QwbMbzaCYWZcaN8UBcVqDd5nmHfFUI83GM9dVGj
	FBoH4g6qoj28qZI/SZg7UaHu07Nyj8x55tunOSRsqzoR7mC1eYnCRpLZnp5wKM8Tv8KfCf
	fMmYS9bbp080+AZimVIGrFPmZNYEV1s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775429690; a=rsa-sha256;
	cv=none;
	b=dBde/3Vl+95G1VsSKV+C7wJGsHJG4f9zyhTjQSYpsspl/qkG1hrH26lu1OQDnIZ/XIWmZQ
	IYOcvpJ8vJX4GqxAFKf2OTGxmpXZJ9Atzb/ulz2gmHvQ5bvrLmb1mTdNBaxeI7KTKUH4np
	kqPJ8T2WhVdwDBhrhuf9qq5eoEuVXS4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U0aMKT9g;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 31F48600AC;
	Sun,  5 Apr 2026 22:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72609C116C6;
	Sun,  5 Apr 2026 22:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775429689;
	bh=uGhQilv6HZyt2+AVfLdJ6PyST+KHCobYzLvRtNH2bKY=;
	h=From:To:Cc:Subject:Date:From;
	b=U0aMKT9g8leGqzvSZQLfC6Cko+kdjQ5Htb8YAW3t7Z3IGPzJ5XQ0uNM7/yJAfqjmr
	 79KZ+hs6tROxELPB3xABOf5AKT0yfu60vic8lS/8OaiVKhvmaFem3Wd03JPxgfGH2J
	 0nIKyWWgnnMlmRNWV6KIAqFWktOhYR2JpDT+PTattN/UVTMeHffr85sq4feVplV++y
	 XpJUJZ23wgGUzdMCx+9nHAYUrFgkevazZT6pULyVS8mLw+jGQFH8B0YCrcCSbI2Jsg
	 khzRjeC9qAZD70UUT736Qxb1FC52L28g7TXP6TUtR7QcO8+a0IvYTLwLi5rJqI9Y8h
	 wwG79IK/pWJIA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/core: avoid time-quota permanently disabling scheme
Date: Sun,  5 Apr 2026 15:54:38 -0700
Message-ID: <20260405225440.76827-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CBA444000A
X-Stat-Signature: 1eychsbes89nxmbrtf1ygx8tk5nahqq7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775429690-258848
X-HE-Meta: U2FsdGVkX193JR/QzgXt5QUjG29dfgkCEESPT9GOFt6JkUNbg6eFMEsCTLSfDP1mpsEAUPaduop8ngj8cfnsSzTa0MUrKttQPkVt3ioIkhw4fsI3/Dd7PJgBnuSw23ebgRsl4A5W0XA6D/JvSGg3OZQjCLD5Kj8AYyxUDQbnTao9wWWO+h5DUW3uC4b7ordyCmf8o5D0M8gsBIGemeRzOuodVeA0h3fhZPYUjdpQfMRWtJjzXFvI9Wsp5NAKOei8sAB+vlx/MFQPqKllu9IN9aEc94vlDcKAYDmFxKuMYN6iftYxMmY8VvT249Rq9e0hv099OQdN1gOJ3/ZIWU9pwpwjl4R/S4/yZ84JyndVqP6y0rxQmTKEcgWB/MToSsyO9ouAROQFRDZKuklUD+k7X8Sg45N4WcGI2RGs/xe9zPEOZpbefmpNmFPKAliaCnpfHGetIoXHgBJDIgjaNVjgLRyZGwYC+EUVmBulwXjnVNkXiHjzLhroyfahboA+u05yPFxQBU243uTWDJOp0T7Q09jf6H0Ljwqdm3esPkjQYGNm8tB6OkKZ9JzI6i2qo6Js8ECTXjJTreR9MU4cRLolsA01ULQhyRN3HAm34cu+0PsseOGx/VLeNwGbwCOETN3XH2drFyeDeM4I7/pWZ5BsD1Q9IN3gBfpAQ9AwFPdSq3OudEA0meJNgwEfTc2FXMwipBtSzq5bqfJN2V9lny7Dyn3jdicQTTBUS1yjckKmQaKEoOlBJmP/NGQx+njee+SD+xlNjBP/E03fpevve6ZqpWQD46pTIhXGZKibWPJ2+yu4QqWjyY+gLijkbvF1nWxfWBGsgPNGFkoJGrX3l8R2fMNkTnEP8GDt5MmS/BnIZ+Gqq/4oQV323jwCI8DOX6DJuoD217ERBKMlqgDJmq77NANJdxfu/mvCVUa3+XG+gHWIVT77ENJkh5HvCBdwN/o0UaGlVzrarba9M7RfWQB
 s9FNhNG7
 h3fo7ipnQGwQZHgWy3VhqkyOxv9+a/dUU+IKvp5kGVPVeCwleKQtTTZ73otWX6hi89xk7QY27cndbkOPOOvMACxCekSa73h4fXigC89QsKf3+HtsLfh5AOQ+BgC9xxFaUCRiCbwG3hUMQ9OrqngIK3UeM3JydCaNbXErL9KN0u+uTTyRV6DkaQpuMKP6NpV/9M4MJr1/Xrx8OMKasy5CyYD3dwdc/msOwfRb+rxdG8EawSMtRZ/fLDfap/QTGJGbTDlz2KCLDKbVkoHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the throughput of a DAMOS scheme is very slow, DAMOS time quota can
make the effective size quota smaller than damon_ctx->min_region_sz.  In
the case, damos_apply_scheme() will skip applying the action, because
the action is tried at region level, which requires >=min_region_sz
size.  That is, the quota is effectively exceeded for the quota charge
window.

Because no action will be applied, the total_charged_sz and
total_charged_ns are also not updated.  damos_set_effective_quota() will
try to update the effective size quota before starting the next charge
window.  However, because the total_charged_sz and total_charged_ns have
not updated, the throughput and effective size quota are also not
changed.  Since effective size quota can only be decreased, other
effective size quota update factors including DAMOS quota goals and size
quota cannot make any change, either.

As a result, the scheme is unexpectedly deactivated until the user
notices and mitigates the situation.  The users can mitigate this
situation by changing the time quota online or re-install the scheme.
While the mitigation is somewhat straightforward, finding the situation
would be challenging, because DAMON is not providing good
observabilities for that.  Even if such observability is provided, doing
the additional monitoring and the mitigation is somewhat cumbersome and
not aligned to the intention of the time quota.  The time quota was
intended to help reduce the user's administration overhead.

Fix the problem by setting time quota-modified effective size quota be
at least min_region_sz always.

The issue was discovered [1] by sashiko.

[1] https://lore.kernel.org/20260405192504.110014-1-sj@kernel.org

Fixes: 1cd243030059 ("mm/damon/schemes: implement time quota")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3bc7a2bbfe7de..12544c60531d3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2384,7 +2384,8 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
-static void damos_set_effective_quota(struct damos_quota *quota)
+static void damos_set_effective_quota(struct damos_quota *quota,
+		struct damon_ctx *ctx)
 {
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
@@ -2409,6 +2410,7 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
+		esz = max(ctx->min_region_sz, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)
@@ -2445,7 +2447,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(quota, c);
 	}
 
 	/* New charge window starts */
@@ -2460,7 +2462,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		quota->charged_sz = 0;
 		if (trace_damos_esz_enabled())
 			cached_esz = quota->esz;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(quota, c);
 		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
 			damos_trace_esz(c, s, quota);
 	}

base-commit: 8c08ea3625d4fa8c1c74b208c0c630fce76e14a9
-- 
2.47.3

