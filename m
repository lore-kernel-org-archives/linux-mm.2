Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4022CC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A856B009F; Thu,  9 Jul 2026 10:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E696B009D; Thu,  9 Jul 2026 10:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96CA6B009E; Thu,  9 Jul 2026 10:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE7A76B0099
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 525781C7D01
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:09 +0000 (UTC)
X-FDA: 84969412458.25.D3518D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A6FD940004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a6W1hRdy;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605967;
	b=qOI54bexvABQhNc6dU5KBacTagFg0H6+oEhjuD0EJNuAmhySOvGdQSNMypGultoaB/nHDQ
	dDK3vEaB9rMDZqccgR4I081uH1wUe8aTeSHKcN0PS9pZ08748NiRvO348Q3vqroJnH/NsC
	1DoWnhOSYziXUQ8s4JiIK4T1PYSQ9XQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a6W1hRdy;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7ZtSpW2RnXSKPujLfG/ONrU6HhGNSKvAXYdnpd8R5s=;
	b=ctt3/xHfghdz1VYKR6LAVAKHRHoaqeQ1kkmCZkaDeqAYkKSwVMjHdd2lERcfyDgEZw4ZGl
	urXixG+aQFM18S38+vGxboVPl+KkQGqT3LryVqG41xRFwYpBpOQz+/gsIVxxgrxHn3STlc
	QfU330HhUaj94ZxoUo5UlQ+YPAuupNE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0062342B63;
	Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32401F00A3F;
	Thu,  9 Jul 2026 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605966;
	bh=J7ZtSpW2RnXSKPujLfG/ONrU6HhGNSKvAXYdnpd8R5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a6W1hRdyqWBuDMlJyNXHSFZ+nwUAdFWZUd8a6SVHWFk5dAvmXelrl0K/7J3L4Uroi
	 aZFvvcmjamabfjrofUoq6Y/tF1TuH6TRbaxuQnt+QtSrh5n5+frsNqhW8M7ng7Gshw
	 RZLyoUHCqdmrcnUwDhwbneAXwOtaJYx5TrarEYkBvYWmMbFL9SKlvT/NUw6L5pbjD+
	 46YRdelNH5WVUz6z4qQ3WcwvKhgSj4LO/zE0VFNm1ianeNXAJ5AlAczM6C+QwHHLLT
	 zoR31M5bKPh7CBXJj1vmtznhSgx479gpRDZQ2sV+E5OiWHyYRxYK1WPkADzz10kaK1
	 7ZlHTq/V9hTsQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 09/19] mm/damon/core: disallow probe_hits overflow on attrs only monitoring
Date: Thu,  9 Jul 2026 07:05:47 -0700
Message-ID: <20260709140600.90950-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A6FD940004
X-Stat-Signature: rpa3jdc5z574o5ioxnfihnkxkdsx334z
X-HE-Tag: 1783605967-617238
X-HE-Meta: U2FsdGVkX1+C8Yzqqjo4nqMBRG1IgANfqOz1M7IGgozePv1yJt5fCZ/rPkATXH7ylcwwX94LpjlK4WQsrq2UwhIpjFF6Y3d6DPykrtQv7zyypfswjyJ8n62Qj/iFKrAQtxJjK9Qr/NDxe00YU4BIstAxWNe+o0j+lZLpueGJEhhGoGl7iIFfbMbYrCaNOSl2Yfgkg9o5Wz4vEMepWvDrom2HrX17i09SAPvzUKzuSO+M61kViGWYlPwZucxj5+4SOAJ2SYv0FPxf5cDTQHkNN7Yff3LpOIbT5kywI8LjhpN5JaBuUZZkMh/SfQiPmIQ8raw6OuBEuuVCpqwntspHhvM/vHYzVo1scBJF+0+OHbl17r8LMylQGeegeftgByZ9pEk+Xfl2hEvusSoUr6LOQWXOG3e+eX1pdy6e0YhO3D0qHCCH/mZtTyBIA/XO5Tr2AavaxWgXHniUeVT3ZhZDwQwmT8H9Gx2vy123UGFxM9QYLokuLsNYGA/ls9Z1R520AUa8MSc7wkwLIycVQslp4U15BuMAvvHOa4LXZ7aAeO0u3kxzSss7ZBvyTuKCGqOvHJ4PBiEOTwNnCxVVRvjARWnQ8/uIqoarpgcD6vLnmO3b42BIwYn3dZOpyyvurd/z1BcnxH+l8TVkfqgZcS8FJRL3OQDpGfEw4Sur1WVxFKnTQ2aJaDux+Y4XD25szoia/BYix3H0kMxSRe58Zm037ap9LIka/tmSZ8S1Jd/2SasJuTliPrkMk7tjFMMyQivBKhzku1sWodVZR+xhU9Mggnh/igNemOARPpqOKIlHS5jELYW0ZsidnsaiYdT8XiszgD0icC8dLKI0qf7MUhPfGYYy6NsXAvheNnJwTTDHHp69GDUObFOXE8sTjyF3BhfIVZ2TlqDmPT5+39MkWPOn+X3pY0rmRvkSlIctgKSJWKClLyjBFcuICiGju5OjoeVynNK1DKtvjs6EhM2SJxU
 hpOrTJZe
 yASxVIVtN521eu175K2upzQpT6bUen5fjJZKiUwAad6gjsFGfHjshlNLCX5L/OR/XxFiCDHyuxWdww87TyWLxEuHXqE5txdiYz3JAa0ngij+e0HSZ0Ub4w2pCsNcOWYBJpCOOf89+tF9MtQ0V8VdlZUTkAqMNSf8VN7lTqmjUixbULPVjdkVvWqw3fcrcXFKArGgtU71c/p8xpz+5q8tA3fRlLQrSOk+EW8oPlBgXZQ1dC2mcykcN93fyQRPJ19w7Iw2Nhgz88wNbb7RadWK1+njh/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When any damon_probe->weight is set, DAMON will do only probe
monitoring.  probe_hits is 'unsigned char'.  It could overflow when the
aggregation interval is larger than the sampling interval times 256.
damon_as_probe_weights() always return false, so such overflow cannot
happen.  Even if it happens, it only degrades the monitoring results.

That said, the overflow is not intentional.  It is better to be
prevented as long as the cost is not expensive.  Disallow the overflow
by adding a validation logic on the core layer parameters validation
function.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7d49420ea26c4..4f1425e56950b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1332,6 +1332,19 @@ static void damos_set_filters_default_reject(struct damos *s)
 		damos_filters_default_reject(&s->ops_filters);
 }
 
+static bool damon_valid_probe_params(struct damon_ctx *ctx)
+{
+	unsigned long sample_interval;
+
+	if (!damon_has_probe_weights(ctx))
+		return true;
+
+	sample_interval = ctx->attrs.sample_interval ? : 1;
+	if (ctx->attrs.aggr_interval / sample_interval > U8_MAX)
+		return false;
+	return true;
+}
+
 /*
  * damos_commit_dests() - Copy migration destinations from @src to @dst.
  * @dst:	Destination structure to update.
@@ -1736,6 +1749,9 @@ static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 		}
 	}
 
+	if (!damon_valid_probe_params(src))
+		return -EINVAL;
+
 	err = damon_commit_schemes(dst, src);
 	if (err)
 		return err;
-- 
2.47.3

