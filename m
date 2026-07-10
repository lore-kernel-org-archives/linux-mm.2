Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E73EC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BEB06B0096; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7A76B0095; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167236B009D; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3A516B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0163DA030C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
X-FDA: 84970969566.19.09B56E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6A79FA0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0hmnbHB;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWM9ulbAfG9bosKr1Xo0BbZMoQtsvPUcnEqaGbAY52s=;
	b=Y2GzPqVu2ZP1KFvnig84bzE8MKrtRDnrhFHpgz049yGer2is2UPAbIzIlOMPFxT52WeC1U
	CxL/atwBmpVWRwchMQvkCa4GIzSd6F1TBS1M2st+UT9bng3GzJlGkzEw28/oE9ZHPZ+Yoh
	7dLOYYMDWgwADWArwd+CFhTqcMsfxvg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0hmnbHB;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643041;
	b=fD2tZ1tXxSXp1EDoHPBe8DY38E5wIjO7V0qATJsECYTPkf1TfsJmim0LRCWeXwKNMXLP6E
	+JtVz8yEpIb3PpxpRwGkBhx64c2wo19eCxmc98dye2OexDMQdSBXh83zmmMJISYUilo4ZT
	g3PxQnqY5RMH9jbMLMrgBsDVS21ttdw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0044161387;
	Fri, 10 Jul 2026 00:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872A71F00A3F;
	Fri, 10 Jul 2026 00:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643040;
	bh=HWM9ulbAfG9bosKr1Xo0BbZMoQtsvPUcnEqaGbAY52s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0hmnbHBPEHzGx8A+oPtTkkPBrTG39LRjcnvRUfEvoczdjBCHtnSxb/6R9S5LQH6+
	 9JXrO1XzAr2ACSM5XaiQ2gc9bJej1WSruLpboI6WKxsA63rxIaMrkX7xyHIOkQLP39
	 ga7bwUHEfnbiIfQTfNUCEJ5hKEE7kkBVi9Mu6+Uab/zsQsOG+lbMQU/ZUKPVhZhgYB
	 aPSpFp/vLdAM8RI0oAVWcyzGWTlggcpe3VSzFeAs9QQQq30OpiOfIAkNDyvHDj2h5T
	 V1JwxwdGEKZ+SHw0LyDiH2OMa3aGhFr2x58orb5NSnh7cM9ZYsq6xQ9yVJJnciiLsU
	 vWiauJWMjCRGg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 06/19] mm/damon/paddr: respect return_max_wsum
Date: Thu,  9 Jul 2026 17:23:32 -0700
Message-ID: <20260710002349.111414-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6A79FA0002
X-Stat-Signature: dy4418e58sz9ngw3k11a41c5osciki9a
X-HE-Tag: 1783643041-103186
X-HE-Meta: U2FsdGVkX18Q9saAgy0fFEmITEXHkMxTE0cRXdQbAJwjLGOzYMcv3Nyv9YR93Vl15at5L3Gx2xS+OPKcqSA3m+ut5gyITbUzRc3kNFA+qD9j/8fFkSFBi5eLLvjvb7iOVWByzH6Fp4l93vSsKCKzGjUd6gjX6x7SyUrCFjZ9xCYDcJp/fcJpob77p6e00OT6xnl+xGzqykRLASqzdMQG0rEAJMrCUB43SxUqvWdNABiTyao0ff9aiB2Kc9edvg0/Mapbjre4jxzTG9tf04lt+ncUUqtLqh35PmP4qtezRh/OvOGP4oMygosYmNejERVnqlOKxKiAgB92BJGeaQ/63DirrsTSM4ES6pYhZ/0cXezQIgsY+Ma9WKAgUWQ7yw0JrrElawBeZHrX1WJwy8ud1baT8JyrOS8tN8BuMYJQmtR+tcGLQkQQO67IKNgNmj8rybySskbhRhk77ozENrlDWb/JvbuwEGknGHCHM/o9SAO0Tl/hoiwerK707ZzxwDqgy7BQP0UYIIidu/4A+IlIpHpDwG2UeyEc+qIPtLMcuHLOkMkh48j1kDJ/k/vFp+70x18tXEExf3Iu0PvHFdfhh+TWHkBuzsh2elLQ1wzNtQXvg/N8k+8pbd++rbFo7nY+SPYMc5Lz3pyoLFjAhKn/qXxV+tJO63tSqPVlspnx871wGQfetr6W961TV2sV+L05RUXXWbowuQFgQXml0qO4zNn750D+clbbBi0mn/dqinARE+BfUDHXukb/fOxEUrpR3KNMqLW+3mKPIAaft8vVtmls+TNZmobqe9z5XA3+TstjSf50VLl8PM60UA3RSo0MD/r7m4vhRLVufNnYF4ydtH5ekM3GqhMd3C8CPBwoKGimumYnGasAXHViqNRGfmNf259OKKN3I/bvScVCR3RFibq2DWig/7J8G8UXNCTLraEyy79dbIyJdM6GwZaRkrzhLRZsSPJuPLvclrEspIr
 vMWUOBVp
 h/VIMuDPvVI4eTSsJS0zPOmCJ5YtEH/al7CJ7xb1hDggU7ev5lDHDe01PRsb1oYm7x4ck0qTuWNtLehwB18TZsKMimNYS1KudQHpSLQLZ1UpDFSqIX/6NO1wTlEj0p4nReDTlQTShfC4MZbqLZkFda/1UzuVbqFqCMv+9XG0/hOtVBENpONeJQLc4wN/t4k3PFK0J5tbEY8aIIa7Fo57tiD1z9imdqBGLOVIIF/x3tjwc9E5vx8qEUV007qPEGAdlzk5IBlAN9Ai+nkn8IfD8ofB9tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_probes() ops implementation in DAMON_PADDR is ignoring
return_max_wsum.  Respect it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 3eba3564a31fc..b85f88a7a38f4 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -172,6 +172,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 	struct damon_target *t;
 	struct damon_region *r;
 	struct damon_probe *p;
+	unsigned int max_wsum = 0;
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
@@ -182,7 +183,6 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 			if (set_samples)
 				r->sampling_addr = damon_rand(ctx, r->ar.start,
 						r->ar.end);
-
 			pa = damon_pa_phys_addr(r->sampling_addr,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
@@ -193,9 +193,12 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 			}
 			if (folio)
 				folio_put(folio);
+			if (return_max_wsum)
+				max_wsum = max(damon_probe_hits_wsum(r, false,
+							ctx), max_wsum);
 		}
 	}
-	return 0;
+	return max_wsum;
 }
 
 /*
-- 
2.47.3

