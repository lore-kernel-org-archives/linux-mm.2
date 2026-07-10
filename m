Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05A6DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEB9B6B0099; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B8F6B009D; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15726B009E; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 949686B009D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0ACCB8D323
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:04 +0000 (UTC)
X-FDA: 84970969608.26.27C579B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 73FE14000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHhIGjxQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7ZtSpW2RnXSKPujLfG/ONrU6HhGNSKvAXYdnpd8R5s=;
	b=A+FOAxHcsLYmQgjr0x26i80vvfUXe0vduKyF/03qWCZcPc0OSjvJ1349oD50m9E4GpfsP7
	U80mHRWE3iheSLVHBccpGoN/vFNt5mYzKlbgPYKdk+kKPzDy2R//LOtbwu1tzbNQPb/GB9
	ZSNE2zNASJ6oXeXL9h8CAB/t7r21hXI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHhIGjxQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643042;
	b=MG9k7E06FsnyTeWB6GN+jHHesoNcPBj7DmxUHIaiSPmk3GSShztA1WUL2osKATmdOTHmbs
	BYOVE49j+iaGt5Hei/wg2WZzrGVzypjGKY8hkI7aijt9hRrsWR67KRsa06Ed1p1S3MryUI
	Jlc/rQKCkPUIDo08FwnX5bo2LO5ogjU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2331450CE;
	Fri, 10 Jul 2026 00:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CFE1F00AC4;
	Fri, 10 Jul 2026 00:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643041;
	bh=J7ZtSpW2RnXSKPujLfG/ONrU6HhGNSKvAXYdnpd8R5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eHhIGjxQ/SBTQe5GOFzJmg5SSu76kqF82hukxoUyNj9heJzJYpOp83k5Vv9QdBxP7
	 Pmk+0dNKugklMrqYnicNpAOgZbLlkiaXSHtuIFDrt7C69Uf5TYT/QjTF5aWxAdTZL/
	 rzSoc036QhS9VedxsWAzsy0sZkpFwmagwUl0TPEDxGfILG6J391E8nC+AuWUweYb28
	 T3Mt1uIRzWMgqlg3zI7TAp6k4tz+fewkGxnIXsN+FoYUFM8Ff5HYj6K5bmtYC0L048
	 9GlBQ6rebhzaVzP2N/PXD+PVkdLhpBbuGP1tanG4g9XxaMjHHbp5pvp7oZvwDlPhic
	 JEI3igjw8YT1g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 09/19] mm/damon/core: disallow probe_hits overflow on attrs only monitoring
Date: Thu,  9 Jul 2026 17:23:35 -0700
Message-ID: <20260710002349.111414-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 73FE14000B
X-Stat-Signature: 1x9dtx1wycz3pzf748fmwioyozm5doab
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783643042-484742
X-HE-Meta: U2FsdGVkX1+qi5/FSSKcAPICYMoRBsXgEWQ6Wj5gCR9X41M/PwZcvZ5eO+ebxo2W8iFlFtIfIRhqXve10fS3kcOHlrHCIpOve9/AatvscgCNbzym2FphFR1cHGxP2QcIazOCPqQG0qzPyWlEHU0WrqvI9JF/3dHQKMcx6KVZU76NdcODsSOKnTz87LZF8U0MjQuyyP/oz0bWdZAYsUPGmEDNER2A4cvTlhmzc/8RpcEecRClYCX0W5oIaLQ5ETwrwl4XyquGwOKSBGCKWYrt552hJEJqO30uZPwdv+rVwnMLdduNN1t9/zg/y0lmdb/LzvMUOcZdJ4aPPNYR69snVyjspzUMY9qx0h4U0TBMgVkYSMssYnOhLuUzch/KAc4e27aQh3rU3v70xc9P3HCVFYbYUvBg6Bj4CcMfxpRgOhpe8QVwoeMl/Uq8uLSFK5px04BMX6kSGJ2TgUdCXeuNlODYUMYLK8xGWYSJanEPY7egCabEWEjV65cGwoRYLRqZXVDnBoi3TTiKqslY21q3d5c5rZ0HJpR6YSvscCctCNOT8IutwISRFzdn74p5Ygu9U3DzJKEQdqXUWmPe+eAKQErt3X5qQdxPQ5PLs2wga7s1+rUj3G9Sk78DuYBE2LM41jGxwc9nsrFTW7wtl+fnSmb25GahpfYsfDyDSGOvQucaXLUiEcdZWealOz4RlnrohLW9cWc5vTv4fTueIzR00y6/GFlC79in15N22mQdI/Szl8WQDFxVr22Slnur/EE1TT5G+jRvpLL6qS60x0sJZmdFaoeufodLYI4UnrdV33UO6tSRfexk8XdnuW1T0qXT2AeK6nhL5pkmPFXSyXG+Z23VNJP3XvLFAfISmtnV5ZPIhd46aX5cDJSbPWr187x+fbAEhaC2T3Sysdo8l6NRXUx4TMuXg1CdV0+gaKDYBC2bJi2avR2ze5K2I1sDVylSCS0ALMSBh+I8EDtegqd
 96yeCGZb
 N+81T6x5nmHkRELcSFo4LW2785XJ9W4sCGJBK87rqNFi9vItRTTuVqgImN5u0wUpKu+PfGQbHlcuwsO0jQMreqdZDSGNH05aZQgj0ggUZitBYInKdaSFDy4gxk3iN6V1T30Qni2YwHbhos4iXAA2tGBrfQyiZ1cVh92setBhQlmiJvV2tL9c5Hk30r9SVkSip+NXgQjAgpcH+RlHP4pDSKiJ/+Lk3IhB9Kj9fK1Ru4gWGNOba/E6TYcU0zuNf5txVuVonwsNG/Ac+bxGiQYhN7cTMFw==
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

