Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E69EC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89BE56B0096; Fri, 11 Sep 2026 09:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B186B009B; Fri, 11 Sep 2026 09:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7603B6B0098; Fri, 11 Sep 2026 09:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9DE6B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:55:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98309140214
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:21 +0000 (UTC)
X-FDA: 85201628442.20.4E41E56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 114C040002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KV03SwfY;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789134920;
	b=T0fkbw0IFLhPXTsY7Pb5vRjX+Fm0a0pw3J9MCjGxuueOCOuaEpqnOdt8LUfDWljmj1ZE/q
	dsV7jB+hMrmxQmgEJa4+TTLZsxaP8VphfLoas4cqmBkQtq36MPKeIvNq6IZwkHDww8QFkE
	N5O9QSHsRrfNANi8Ivf2XsYGONw9L18=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KV03SwfY;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789134920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c05rFO8XMq4oV/KPD78qqBcGhHhl2uV7qApXR0TPJMU=;
	b=0dUIOtKbwdV031A07LROGJRm1UNn6s5OXG40kO9lSA+D8NCtpnKoXdi1RALrbQNZM+z8zt
	VrOWI+MC9M2pqBEVIIu77wQ2+u2b9jgvzkpw1s03gw2VUU1zQIFGXfHEyN+OUVbhEVwbSq
	aVGFEqV7U3p8ZvvBklCqljItI58BmhI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A23BA60A62;
	Fri, 11 Sep 2026 13:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0411F00893;
	Fri, 11 Sep 2026 13:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789134919;
	bh=c05rFO8XMq4oV/KPD78qqBcGhHhl2uV7qApXR0TPJMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KV03SwfYdnpbLX6lb4huunwxAG8GE1PiiEan5RCu1BqFex6/EsnT4uXH3BjNkj/rH
	 jnsjyc6W+hfCi68uYZkyyIe6lp/YQw3EFKdSkIZSRhGwqp2YeuPSe5mm+MN/v8o6bE
	 nGxw7It30650Xk8BB36trzRGaSrGv1M2ZHSPsRTUnfVNFeFm4kOo+yRmhy0N5QqxqF
	 oYJ2i5QIz8rxNNsecf+7lwcdzfc/I9Bm+ggGwrBOFY06KcDbvkv++nMCs2XQe/guXm
	 nRjmy7iZ6sViLCJrgj4iG1tEkB+6ligNxmlU+vUM64afXsw48a65ces2eN01jkOyy8
	 Q4iwmpFgzj45Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/7] mm/damon/core: extend probe_hits_wsum() for moving sum based calculation
Date: Fri, 11 Sep 2026 06:55:04 -0700
Message-ID: <20260911135510.96914-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911135510.96914-1-sj@kernel.org>
References: <20260911135510.96914-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 114C040002
X-Stat-Signature: tzoy488kz176jrf31pmoip9na1zytg7k
X-HE-Tag: 1789134919-579597
X-HE-Meta: U2FsdGVkX18gP2kePUZHGljH+s5HRgee9pU9nT90R31bosBqs1CWq5OLr9v7PAqyjxOlVbhk+hI71LDHlepE+f/WQL31M/XciC9ycZVBhSK0JzJ/akDEGKqe/A0suQWQl1tD99R5qGDMTf2/AVYK43U5gDfeaGHd3nKpxkvgeL0zm8+2qJW0huQqbcZvN47aQ4Aj0UWRPajBdgumSIGieOC8g06tIgXBe/guGB1CcIW37XNDd2N8+iy4/+/fc4DbG9M0yA5QCl51E4kF6KcZKhj6f1yGz9X2Dt0pMqGezMK8tPKBpMVBI1u87nhU7pqZK8fxBR3J1Yi/kTqWz0aKtGgOUrzEOJcZr8uTXJ8kb2ZBdur1thh9MiMCY5+AaFqfPGs46vpne5dVM8vA6kQ77qGSP9l10cR0D6KTv370CLaNIvv82gZwSEL+GOtGG2qBVsK/M3ITPr+YLEJHUcszR6ecG6/gUmTErDLFV1FF9Ojy1wh5WB6MmhaT+WXM3kob5QyM6XGD34VO/VTi/CxsQw7ZN81QMr5JPAhC1j+/ZdmFPm/1cxt+kVAsb9CmtyFro4HbMRfI09WREclpN39PRdn+7+PJ0nxCNcmq3knr7tCeoJQ/Pn9hdA3LE7bIy5cIeEgypaZfz9UjDgYVPd0IOFX/YSRKRuxxGY3wPqc54klo6+UMwGh2cbdfosoBoRek7MFCQwcBn0XMOYKvMtMFQPp7Uf2tQc1QXok0U7kx8xrqcDiU8IXpbk1asSW52PETFAemvom0BRJ2wztlhqnFf5hkU6rK0l2lB6TxJSxgVdifdyK/wwp0/RO0RlyLPa+blRylVGGzyePoFX757TBWoEVGBlz7DHB9XMdwkW16iTn4VTMK53Gw1wr6H/ukwt3dQO7kEpRc+mZiGHn0wXeHT/PT2hXoi0YDSsvY84e81XirCgD2liqqvOcG/Rmopclx8gtLfMdYsLcWM9EbKpL
 0nKNJRDF
 k7efWYyNskOdUSReKoehh2DXcVm09sN3UntGcdvF/O4BDfIqGYwmI0HlwsB16PlupYRozHH7gF2vy+xRADMrDKir5EWbkaKGA0FPUdl1udBLt8d1fadvLcmAOML7GAtNtNLlYXpfTap4e95YLZ7Ebs6hlXDpZycbOFR+JBbskyhxCy6YY3dJhU83PtLzB2ZJ68by1iipaxVnVVIgd5DW+8CWgHYyWF9C+b6za3vgh7QvCpqwB9ShNxvEmjcWs0RznIvG0RAyGQJgvyMR7lLE9qh8rcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_probe_hits_wsum() is being called only in aggregation time.  In
future, it could also be used by DAMOS.  In this case, since DAMOS uses
its own apply_interval, it could be called in sampling time.  Then using
the not yet fully aggregated probe_hits could result in suboptimum
outcomes.  Extend damon_probe_hits_wsum() to get the weighted sum based
on moving sum to prepare the DAMOS usage.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 +-
 mm/damon/core.c       | 8 ++++++--
 mm/damon/paddr.c      | 2 +-
 mm/damon/vaddr.c      | 2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 9e84bdeb5616d..abb529771091c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1075,7 +1075,7 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 		struct damon_ctx *ctx);
 unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
-unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 06cf2ab7e97d7..50e0f9407db2b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -469,11 +469,12 @@ static bool damon_is_last_region(struct damon_region *r,
  * damon_probe_hits_wsum() - Returns probe hits weighted sum of a region.
  * @r:		region to get the weighted sum of.
  * @last:	if the request is for last-window aggregated probe hits.
+ * @mv:		use moving sum.
  * @ctx:	context of &r.
  *
  * Return: the weighted sum of probe hits of the region.
  */
-unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
 		struct damon_ctx *ctx)
 {
 	struct damon_probe *probe;
@@ -483,6 +484,9 @@ unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
 	damon_for_each_probe(probe, ctx) {
 		if (last)
 			sum += r->last_probe_hits[i++] * probe->weight;
+		else if (mv)
+			sum += damon_probe_hits_mvsum(i++, r, ctx) *
+				probe->weight;
 		else
 			sum += r->probe_hits[i++] * probe->weight;
 	}
@@ -3456,7 +3460,7 @@ static unsigned int damon_merge_score(struct damon_region *r, bool last,
 		struct damon_ctx *ctx, bool use_probe_hits)
 {
 	if (use_probe_hits)
-		return damon_probe_hits_wsum(r, last, ctx);
+		return damon_probe_hits_wsum(r, last, false, ctx);
 	if (last)
 		return r->last_nr_accesses;
 	return r->nr_accesses;
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 79195026b903a..5abfabaa339e0 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -208,7 +208,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 				folio_put(folio);
 			if (return_max_wsum)
 				max_wsum = max(damon_probe_hits_wsum(r, false,
-							ctx), max_wsum);
+							false, ctx), max_wsum);
 		}
 	}
 	return max_wsum;
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 7063356370c34..d5dde97b3cd0d 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -711,7 +711,7 @@ static unsigned int damon_va_apply_probes(struct damon_ctx *ctx,
 			__damon_va_apply_probes(ctx, mm, r);
 			if (return_max_wsum)
 				max_wsum = max(damon_probe_hits_wsum(r, false,
-							ctx), max_wsum);
+							false, ctx), max_wsum);
 		}
 		if (mm)
 			mmput(mm);
-- 
2.47.3

