Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8272C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B4D6B009F; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD176B009E; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876BD6B00A0; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60FC66B009E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1CACC1AC3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:05 +0000 (UTC)
X-FDA: 84972993210.01.FE83EBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4D4CD20007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N2xx555d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MmLe9bOPXvyR7OHttIBw8WieSr9mwuKyL25YGhL6QA=;
	b=8oI80tUJAF93gDzSXPNEZXb0vME9OKMza+fYHp8HXOuuXi2CldORQXVNbFOzdL5NFwRizW
	AL9hYtobyEe22BmXCLXAaHGam7oDlZlmuqj5403l26GOLnkPNghov/J3RRRGgEVuiI4pww
	xW8LtQX7PtLkuSsvFhnTzFAR0yviBN8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N2xx555d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691224;
	b=RHMcktixVj3PFwC2uLwlDCPn9qOTkfHFozYeOXqvcDifxTWet7pV45gctAjgLp7weNkB+1
	6kJvPFrovSEs5zsiBcVJHDu6fwHtsVxNUtHMt+pbr/q1rSwdMlK5YQvUsTXiWjCxy7nJ+f
	KjNaEqK9wz8KoGjZtYY3dmTsCp1wYDg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E45EB60051;
	Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786D21F00A3D;
	Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691223;
	bh=0MmLe9bOPXvyR7OHttIBw8WieSr9mwuKyL25YGhL6QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N2xx555dFwRTDQ/8HpoGYjZjZIiG8+XH7Yr3Qkp+4vxUvr0Gk9mkQPeJadr4QLgPg
	 eU3B4GlgbZH8BPSfS8MyuN3y06Buv19uOd+LDdQ6btRatIBf5HxJAYa98mxnxvAPI8
	 U5T4nSZA3G7gKy2W4qI7iWrlWcsNFlz4IXrEb41gTR+CR/VtkzJSquoi9ixa8YWJKq
	 EuwPOIjlcBcbTWkd9tYFIpkNPnBcLK4AMN5RGkNIDlOhbFsoAKCkxnUmjfGp29zAK+
	 ZKRqtxGLvpBKM4kC60/vzYz+icswnvXcolIvTKi4K+/KwYK88YPXUeOtxmlZ22upC5
	 adOXKaKPp4UZg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/19] mm/damon/core: validate params for probe hits weighted sum overflow
Date: Fri, 10 Jul 2026 06:46:39 -0700
Message-ID: <20260710134651.18084-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4D4CD20007
X-Stat-Signature: 8uownhudm6qh57php1ueqgd6ojgpmags
X-Rspam-User: 
X-HE-Tag: 1783691224-212799
X-HE-Meta: U2FsdGVkX19smS6aY1UqjRo7meF5189//EHLHG68p34sVcUtcEy8sycvmWBn6pnOlUgzv2HM/yGHFyPWSdt7GE6EDYJwQQc88Pk6GLUstdFU+heggXv57XKJ+AUdrVRDXhTD+tf1LdX4PeIydw9YkQb87m+7d51jfSB30xbk8jMH5isJO++wO3kNNIgoAhufLYg2H3SqbMD0NVYC4G0j/1EOcDTOrzoi0wCENTbIDktD3h+naNJ7Rrs/pVlEQS0WH5+5JSU9cRhVcR77Z42rRfKiLO78D2xk+FDO5H6oikMMEixB8Hd5xZhKiYyvzLRposqWQzc66mXxrdsRGoGK7aFg7Ksabgj+TNUfDi5/SoTHba7JEKQKuh49V4v9wvh2A35CqlZbRPsYyLjnUz4vfYrlcQL8L9ytwv9CpScKo97PbyuRM7mZHpPvEAus1IA9e5RbakdL/nQfjQewLZX521ETTy4GouX4bLS6vie/Au3buKPnFUxXjpgOBx6W8QPgUDdWwNfkkr+07/RUuMEksS3kmkWhxL+p+8QUznEke7d/nUAchYglkab/Td4Xkkf6xMADS5sfkBd4xsEaSgtLiG2xRx1uV59RCVAQYfXYT4mSO9nUKyot5gY2WZ/tKrEpePgbQjPklGs18u0q8PJLedz8H5pHqLWLwhktveVW2JRHg455bvD6d9cj04dZquyXUHzkhyBoI30dACQyrgVsR+lxS4DihrVXj2IvDjpLy7eN0dKzwuop/s8IMZ4tirZMNRFd7YkNxygHxJfqfDeUqOs/8EQGHkEMVFR7xriaNCxkbjIYwyByPcLRqVYTV+jhER9sgd8VmzPa8ECKtUJnALU+3I4gTy/PsKGR8Av3s+Flnwusw+3tTb+F+ZkbifsOFSComy56KTVZtN42SwbT502zk3ESMLA5FtFzZceoPBuoGP1kZhOR6zb0U7xeL/pNJGjpT0Jbf7N0eWxgnJh
 ZHw+L44g
 NaohJtFP9UDFQW+h3JmwWWX3t1KSGqvGqP2Vs6SBVSg+Yk6BbsaLncKUwnse0D4DJ984YTNif3BuV6ZcuOunozsXGpzTMuhCUIcqKz928iel7KlbnpZmu6Y2vrTUDwm7H4jETZdpDzpA4v7hdRn5e+EtxvdcB8sz66ajhQfHLSyodmCeYzU6svkKFwM17ldLGD5f+ekUHc7B1Zfz3lPmjiGW/qJfurBM2r/mKdWcyDCTrFzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_probe_hits_wsum() could overflow in weird setups.  Users could set
the weight unreasonably high.  They could also set the aggregation
interval unreasonably high compared to the sampling interval.  Such user
setup is unlikely.  Even if such setup is used,
damon_has_probe_weights() always returns false, so the overflow cannot
happen.  The function may be completed in future, though.  Even if the
overflow happens, the consequence is degraded monitoring results for the
unreasonable setup. It is just a trivial user experience issue.

It is still better to be prevented unless the cost is expensive.  Avoid
the overflow by adding the parameter validation in the core layer
parameters validation function.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4f1425e56950b..a0e6a5129fbf3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1335,6 +1335,9 @@ static void damos_set_filters_default_reject(struct damos *s)
 static bool damon_valid_probe_params(struct damon_ctx *ctx)
 {
 	unsigned long sample_interval;
+	unsigned char max_probe_hits;
+	struct damon_probe *probe;
+	unsigned int wsum, wsum_to_add;
 
 	if (!damon_has_probe_weights(ctx))
 		return true;
@@ -1342,6 +1345,18 @@ static bool damon_valid_probe_params(struct damon_ctx *ctx)
 	sample_interval = ctx->attrs.sample_interval ? : 1;
 	if (ctx->attrs.aggr_interval / sample_interval > U8_MAX)
 		return false;
+
+	/* invalid if probe hits weighted sum can overflow */
+	max_probe_hits = damon_nr_samples_per_aggr(&ctx->attrs);
+	wsum = 0;
+	damon_for_each_probe(probe, ctx) {
+		if (probe->weight > UINT_MAX / max_probe_hits)
+			return false;
+		wsum_to_add = probe->weight * max_probe_hits;
+		if (UINT_MAX - wsum < wsum_to_add)
+			return false;
+		wsum += wsum_to_add;
+	}
 	return true;
 }
 
-- 
2.47.3

