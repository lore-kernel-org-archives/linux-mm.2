Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0943CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9EC96B00C4; Thu, 21 May 2026 10:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01816B00C5; Thu, 21 May 2026 10:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BD146B00C6; Thu, 21 May 2026 10:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7201A6B00C5
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FAC4120356
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:42 +0000 (UTC)
X-FDA: 84791673204.11.2F528BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A9B72120010
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TNydnoB6;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITBL4yRv8OcoOU4P8OrL5kgNMtEVib2v8kU4r8mcDLE=;
	b=qVwpv6jtsKi8LzcUOtCgsa+3VIgXUslsfbhPU8wqma4IRRHNdP/1MpgejkLxqOyzF/YIpF
	W6PHNCa8Fx3HbiZWXTnIy0TPAGi6rPJhCiNpMUp4Kc5Wz+u0SU++CRIZ9KK433n0kE8TU+
	saIWKcRePYtorUXwrMF5fiH3v61WfR4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TNydnoB6;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374080; a=rsa-sha256;
	cv=none;
	b=19o3qdh0xzak248fgjeYdH929J2aJuR2ZJ+e/GsJ1QceWSPC8WbSSoNKazf3sABICQy3co
	AZwaG0Lc3UJIBd/LEp6lc3ZCKoTEznz9/am7JMf3BUSAwZU3LrOd22l6/kG/fqJ2wd82fI
	QDIYD42yxL8jAxM9Q/QxFkB7jGZvm6k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 04C5F409AC;
	Thu, 21 May 2026 14:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EC71F000E9;
	Thu, 21 May 2026 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374079;
	bh=ITBL4yRv8OcoOU4P8OrL5kgNMtEVib2v8kU4r8mcDLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TNydnoB6sIKWld1N3SMAnA8lttU37d6YABnmMJ4mfPU3329lt4Qoz5v3C//EYGJYK
	 drNbHedORmv86s+wMfzB+ODgCSqMNAuPxiOXsWALdW5IwhNAnNI/SNqz1Jfb1/zJMT
	 MEj4wegqn0OEFFqjzfbP9PZdjhd5w9BkR4SiSGqTNFjxYlkgcC6YB1gdq+8aCffDL2
	 365RMt3j7MwJvi/JAemUvRX/nVyEqe8JSvBA7Ch1ZXwIVwfxZrhHSE4u2bwZ9Yrrmy
	 kj0+3Ukw8DcPKg+lWQsbTGkd/sHUIZe0YbcJWvRCN+VcYt94XiVvY1jP38MriuIs0c
	 47QU+G1IFAA0Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 07/14] mm/damon/core: hide damon_destroy_region()
Date: Thu, 21 May 2026 07:34:17 -0700
Message-ID: <20260521143428.83157-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A9B72120010
X-Stat-Signature: 9w5ef7kb4b7pgak9y5xq9kx36ekj6z9q
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779374080-241527
X-HE-Meta: U2FsdGVkX19QyihHN4AwGWoaAzDs/u//brefvL7Cym9RvlNvdIiadLaRsvtXSMFIZOf6N1/F2Ap56Hz5h2nBWOkbxGiQANHAZ9Prw1JP+yqENlyUKpqfy/LtoZKqZkV1G5YKPhm/gbPnRpnSjPuinrXYDoA8wUExGwec13fFZuw2ADk0rgZEKUXC9fSacCuQw47uIQxsLjm1jh4R1NOEdtNl3ESCzLZtAKLgjSzxST7nKO8rdRhOZQ8QcEP2rzFDmjT7Tx+ruj+PsFbzTCnYmCqWRv8XYF2XQ9rEsNMPAQKfPZhC2I4wuu7cJUBBJtthK5FafycK8sdnL21owF0JqTV5iJrp9FjkMY/umFlJcCv8X9ehXu6IEfdsucy+1RPBkzKoxPgyvUtK3Z2w8rImE/4c+cU4uR90BKApjRiD6IibElhojRRRvDbt+w5NjReSLxJaj8SVZDXm/3GdIF5raVtlnIsd0MHPTLK6fcPTxDi28g0efsMbGqoiOGETTZmXVS6trsn7SBhUE6Z3EK+fYnMoDRV6fNIbXhBvyPZKxIbrzW/UfxwpHeox9uWySAeEwzAoH+1O+HiFVUQwGwB4HJbdjNKf7zqsPjXhhL3QuLFaB54P5t/cMQJabiYGxHkENRlKjUCV26eVJYJ3CegTBJuzRBaqbPpVZyYh/U4U1l8F34WAKzLqLx67ElGbhaLtES+9TpApmY7J5uq+zsX73mzCgXF389B6pyOqqYT9PeYokYF+nfJ1k/3icfKRGXdvvuK0M9cAAPiiG9wy1EWucmMmExWYj2cHRnm6bsj77R3ShyEa12i0gdQr8ptBecHmrjh9MuFVnCU0cMJZHPK9OYOggVoacCeB0lRQmwhV/QLBrPfKKpUpVTHAuai2oWcswLby7J/A15ggiWOCvkPwJfbwEi5C6dP9q2MYl7NhVWuym12jzQD0r4r6ltZwg0AaZ7o+qZbfSPDpuG+q2WQ
 rD8HbH9X
 3jqr1FMxe8eFXVlUwyimwpL5OhLFiaUP0ZrW0fvgLPDGsL9OIbsGk3kGRYt8vSB2l/SN2iqKeov6SJScUVRebxqlD0cNrdFNYKbL8Z0P5k1Es9Q0L0GlEAwaCsBB1nh/JxWRK6HtHmCmIYhZuuRj58Jlk2YKnYalDy0TNtfCLqtq7acFOkDoiyAbKBz4vq6kQcXEZ7b+l187HdCqBx2tXjc9blm2zggaE6augLlfkdxTviec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_destroy_region() is being used by only DAMON core, but exposed to
DAMON API callers.  Exposing something that is not really being used by
others will only increase the maintenance cost.  Hide it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 1 -
 mm/damon/core.c       | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3acca7deb1693..638ee65f88dcb 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1013,7 +1013,6 @@ void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
-void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
 void damon_update_region_access_rate(struct damon_region *r, bool accessed,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 53b4bdd27b39d..8a9202937781c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -291,7 +291,8 @@ static void damon_free_region(struct damon_region *r)
 	kmem_cache_free(damon_region_cache, r);
 }
 
-void damon_destroy_region(struct damon_region *r, struct damon_target *t)
+static void damon_destroy_region(struct damon_region *r,
+		struct damon_target *t)
 {
 	damon_del_region(r, t);
 	damon_free_region(r);
-- 
2.47.3

