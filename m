Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FCCFFB5178
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 00:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7996B0088; Mon,  6 Apr 2026 20:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478646B0089; Mon,  6 Apr 2026 20:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E0D6B008A; Mon,  6 Apr 2026 20:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 287DC6B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 20:32:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63C3D8BF87
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:32:04 +0000 (UTC)
X-FDA: 84629882568.03.C071D89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E179B12000E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:32:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K8OxJqNe;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775521922; a=rsa-sha256;
	cv=none;
	b=JZPCtgJKr/S8eU+KpNMnvr1jLJvjwgswneAvqVHeftmnKfNdI3VX/Nfwuo4piKapOPtbV2
	AoYsN2drAZgSfjPudWCovoX7SmEQPgQql7k0/wSk9XRcxRxAf7tP9cf9webPXTTKBCarY4
	m20Dc8TUxWApomIo1vPgnGBQcLrjXsw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775521922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bUMGoXkRFT15JNTOW/uvSWNVn+NRpc4lafnHXJYsCP0=;
	b=J/eBbMp3GkhIPmPFfE5yggudSkk2StCH5Q5WFsWUsH/PDXcaG+4xSg/66ab0UjyJupUstB
	thN5BILRZIXrtZp29FfBRmtGpFV/IbEh7LsBBHWZeEg7gvIg6lvuMyquzEDM11C16bPQa8
	XZHQ4qRPH8hmR8qrMn4Ik4NaQTfOjYY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K8OxJqNe;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 59E0B60180;
	Tue,  7 Apr 2026 00:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B655AC4CEF7;
	Tue,  7 Apr 2026 00:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775521922;
	bh=e6PdU+sFU0K01P//31v0gwLstVAfukUiXGSZ4qXfxgs=;
	h=From:To:Cc:Subject:Date:From;
	b=K8OxJqNeSgov7VyfXY9BqhmgY42pYdzKPlHslDeqPUxlwNM/TjVJaGqePKlGmJ4Av
	 UfaTpT9bxMeoRe5e3nlVBkK3ijzjw0sDqaBXQPyKqB23y45VAnuLvBmMMOVWxjjjQS
	 5ds7sx1dXy+TfLi4gIw/WcZVqT8g0OPcrbLsl2VggE7gQUH5OxTXJas/Mp+AFBGCEV
	 okZ+PnW7XR/SMhrz2nqp0QQEHTSP0QJ90bqEvC/qpax2mwegf7KFBK7+svdNfl/7eQ
	 yVO8q27a6iXz27ioCEzC5Op0xLKJ0n0QSEqWRc5UxhIgqUrJyf3CrO0q/Yw5rp8Bas
	 8g1a+bPRuytIw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: disallow time-quota setting zero esz
Date: Mon,  6 Apr 2026 17:31:52 -0700
Message-ID: <20260407003153.79589-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E179B12000E
X-Stat-Signature: p8jwfr5uagybn5z99xsi4gsa8rkc4sm5
X-HE-Tag: 1775521922-848875
X-HE-Meta: U2FsdGVkX1/G1+JrEJpOwvMBRENMPqSYQQqBkpV8KNveJCyNn4Or8vMaP84C/sg9KyzGt8dgBjYNsj9RGyLSFbzAl06Nb8jFYGnaPnjmbEfL5aHHJw4q55mnzfv5OsnLt91wgiiC8c70m8iF7WF53WnXoagjiVqcQymkAcWC1w5Q2Baiv7sO4W1hvxV7q/JccslY6bxHvDaMUvHZU9n5y3HcCBK3P7oAG14mD0ZQ6g5lbDwSCa2Ku4NCeYwRGTzXOZpGTpXOQ85SLmNuduoujKvfBU7e5LL2zVFJH4QTdVP22CZGxmRax2baehy/BtS5bhXzVv6I/VcVecRcWX2yN5QI5EKuvbyQwY9zWaXQCG8SgrBjf+CyE1aAoDCk3am1vTbYFoRsWScFI7w/KmXR1MfHJUOYGvybajRIoCNq7b1KFNzso6JLLsB5z9q7jcuo2NDTY/nJxWR1VyoZwrLD7K65NkvTUdMYgUCO3I8JWwIw3FR3jb/VIeCavTyJlyTzBwOAMzYT6I6LiO0ja5U2pukO9iXor4GFjlCYhKda3CeHS/mfsS5aK1FK2l0O5PQ7zAMaiE3JR16OZEOcCf3iC4iaQSlLZJkqSwbhe/mIkgLUl9mGiDJyAMpQ4zagVqiNL3jzQ4j91ifeNb5SvmnkJ0mxP5jgCD9I9VChBd4H+C9mwAob5dTf1rc54MVgtx3y1JPfR8yIQ2xUfDmZ1zPoR2pgGb1hrsMg+eUTBELzWfY/jwMZPG0uiw5xpM3IiryeUWzwR8UVwK8kyJOreF9SwsEy+XrRcXTC0ewJu+pES4X8atv/tSNNQG3NslKGe3QD3Mn95a310p7Cx8nmP/zUgoBRaXvMu0zeYO+XmRFIW4EgpzujGmDJlXylmsnWJa/pqTBWub/TUic58aXjWOwdKObdisihhXaPkUDJn8qyQgET2PuY4Kn1y93EFVKehcYcivF8mAP+yDs7hSBe5YO
 f351JUDe
 V/Ek/ExVVJYgYbmZoeZqv/abihIgcAvL6HTLysjPijs1NdOSSIRxdwKLfvCQnKjFItZda+sBO7aYm4Q+QaBTzw7sd0piDREdr0ZiVDnM1vWRRffN4lVDoKHOASCTvsMaGQF6Ooyps0zjx99Rwjkzdxtn1d0UnyP/GEbOp1LkOw33k5g4oKn26iGh58176NsVama9R7rvKIIjaV1Ky/QFAjcFvKjXDCRzV91+CI2xfgGUlDK0A2bwHvW3Zc0F+/yw7oaE3PQeqctfuq15Wtwc9QrKsO9aoymqmd2BP65K+rIbJyyyXZxx2+dRLUQ==
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
Changes from RFC
(https://lore.kernel.org/20260405225440.76827-1-sj@kernel.org)
- Drop RFC tag.
- Rebase to latest mm-hotfixes-unstable.
- Slight wordsmithing of the subject.

 mm/damon/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3e1890d64d067..3703f62a876b3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2228,7 +2228,8 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
-static void damos_set_effective_quota(struct damos_quota *quota)
+static void damos_set_effective_quota(struct damos_quota *quota,
+		struct damon_ctx *ctx)
 {
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
@@ -2254,6 +2255,7 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
+		esz = max(ctx->min_region_sz, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)
@@ -2290,7 +2292,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(quota, c);
 	}
 
 	/* New charge window starts */
@@ -2303,7 +2305,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		quota->charged_sz = 0;
 		if (trace_damos_esz_enabled())
 			cached_esz = quota->esz;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(quota, c);
 		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
 			damos_trace_esz(c, s, quota);
 	}

base-commit: 7c554c59e5a8142c2aea9fd11afbb0fae8876244
-- 
2.47.3

