Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BEBBFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E8766B009F; Sun, 26 Apr 2026 16:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672156B00A1; Sun, 26 Apr 2026 16:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A0B6B00A2; Sun, 26 Apr 2026 16:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7916B009F
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:59:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E7CFB1605D2
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:59:00 +0000 (UTC)
X-FDA: 84701921640.01.CD46280
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 353F9C0007
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:58:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S/0Ya48K";
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777237139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6ZETGQnPjY6Uf3kiCC5vRy6DqsA+OkOMkWekxry2xQ=;
	b=v/bPup7si5U52kHFcNTT8ZlQmiBlBY934mpI79vM+qFjYRdu4WIc14D3aQu02eNEL7cb+B
	Cl6D0QnfTxV8u3CtomHLkvWQvXm5hMjvJXVIqCzHqyttniNvtQq0GgMSpPhI/NH8SLTtZM
	tqyoEhad30JzmI7KRTaAAlxXip0Ofbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777237139; a=rsa-sha256;
	cv=none;
	b=nz2uFIJRujn2I16Sz1dz0sQ34YF7/+2zPgulxs9TnL9Tf25T51GVoslOGX0YXyE2xStw/O
	ICJIuBX4feC+7Gw3CF5nlwfrJsT+R/i8bmwHXgCfYL5Qcv2fapd4QHf1Xc/6AMQThQv6lX
	+rCBspaapPZGmBioDEFBrEO5MPw3cBY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S/0Ya48K";
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FEF44044E;
	Sun, 26 Apr 2026 20:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A56C2BCAF;
	Sun, 26 Apr 2026 20:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236757;
	bh=HJ0qb7oUAaoxmDsZao082N7cLDcGDLFu+2qQv2Gc5Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/0Ya48KYKkrK37e94LOhSRnzfxTxt14tjEDmMpyuAEmdpPr/MpPbp3Isb6DiSJlG
	 g023Jo+R7gYbNW7X5FYNE+ZkLLBl2BVuudJpdDT9G7/fdjtnr2YXsnfxAe1gX+fGVS
	 8iPf1vJepsINzLzdF1A7JjG/87G8eJwktjsszHJMtGh27ztaUdbdfm9E3X3e/QF3l8
	 iKi5CFIv+zuO6tMx9EAIYnp28uyWShjISOa5Ro7I3cafTL0JL2e4B39oB7Mcar64fu
	 i+8YqOLe/2oacF8dnDUBtGdKfRuASXeEekr5PlNfxqi+pQd9/fyxS9M1w773Vc9p6D
	 PZX8TQfQRSVxw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/19] mm/damon/paddr: support data attributes monitoring
Date: Sun, 26 Apr 2026 13:52:09 -0700
Message-ID: <20260426205222.93895-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 353F9C0007
X-Stat-Signature: tyu5jjxcr8yitpc3k6phgem7jq6c8sjo
X-Rspam-User: 
X-HE-Tag: 1777237138-147499
X-HE-Meta: U2FsdGVkX1+e7yhqT9g+pWG0jFPlZ21V9Kr00xT2uoZCo9wxPWRUlqgbWYa3MuuOEVweTBAs3EiWINbjNgAsgckAxrDJBPEtLnp9ZrLrcjG7aKrTbU+4R5dHkkk0mYkytZ8xPQyQj3jb9ha9jGtu5ezte/AhG3HWCOK9YtjWHRUIqaeA5fpPt7TVsH9/DU8z7C8H6HbA5QuKKdB/HlI48CX6TnXJ9i9ewWqbRce2/51bd0pRBM5+ZqA+ExlyItGaIB1rUGn2xokdHei7Z010ELGpX76HNoMBxP09SS6h098MPNGd9cXslds7UllTjMv4GAfDvM6sC40WxWgnKtnLark1dXgkZ5GvJi3TL5889rf5HxvLKYPyNxUqrY5oVCpiRspgX6VgAUnnAHTOu7hVxven14Yz0MK2OI2YNL1WlbqhczisTHOx9XqQMOsRKrjt8ZH9HD7T+yeRk0Y2shJVGU2+WhgfEf097vdX1zII09jjiiupetUZM7uOTLs9gpTOMnueJ6VbFK4GdJs2sn5QiA8MrecxN3YR29IT4AkAMAOmEdJKNgPhTYeBIIBUVE+Jw5z/UjQSKOysTKvKmG/C0xwB0zsgq3/6KupTrz2jOa6FkRUsbczi6i3kPF9LblPnH3purrtQbvjhVbjh8czFsmQNnOxH1Tt15TpyNpLmNRow1alOOKcgLULI2lUzloMouNWAAGXU+xw9O7x+adHxqKTRGpqTDLodsf93LIUK6r9YG4BxybXs2kkSj5y5+zXfXPxPHIJ+sYTpbyJIbr1FGug8G6dmTgykkUmlmWxC3VHxq86ntjITRvN5wR3hWvJ6dHzEl1HYHg5yQSDyoLErz4P1mIJ5Rn8SFnldaoWr0xhk+KvJJxox8o3XFnd/fdEF+aNMvobc3JcD3CQ4ERH84ztXEeAZhzn54suCqRnzWHoGCWoYsldiv2JFdd3OpcfQ9Vp0dZV9paG2HadGyk7
 p7PQB45H
 zcw/W1F/o5914GcMzUCmNzfHGmPfPI5c3skaVBvlTI6daeIjVcH/mU9iauYJrjaBilUeoMFpWxnMd0FJ7DTDE0Q/BH9xgaItnAlDKPg4flfw2xo+OHt/+2ZHt85njOLDSc8d2xh/yc5jzEQYNEDuxTAj7oaP6ErWJ9a8FoIlHDKlVlaHjGFRCv+yx38RFiAuUafC5AOs4s5d3gXaO6hpJlMZK1rKgDt6Ak+v7GRyZH0BC2RI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement and register damon_operations->apply_probes() callback to
support data attributes monitoring.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5cdcc5037cbc1..cacfbf774ca4f 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -120,6 +120,50 @@ static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 	return max_nr_accesses;
 }
 
+static bool damon_pa_filter_pass(phys_addr_t pa, struct damon_probe *p)
+{
+	struct damon_filter *f;
+	bool default_pass = true;
+
+	damon_for_each_filter(f, p) {
+		bool matched = false;
+
+		if (f->type == DAMON_TEST_TYPE_ANON) {
+			struct folio *folio = damon_get_folio(PHYS_PFN(pa));
+
+			if (folio)
+				matched = folio_test_anon(folio);
+		}
+		if (matched)
+			return f->allow;
+		default_pass = !f->allow;
+	}
+	return default_pass;
+}
+
+static void damon_pa_apply_probes(struct damon_ctx *ctx)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_probe *p;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region(r, t) {
+			int i = 0;
+
+			damon_for_each_probe(p, ctx) {
+				phys_addr_t pa;
+
+				pa = damon_pa_phys_addr(r->sampling_addr,
+						ctx->addr_unit);
+				if (damon_pa_filter_pass(pa, p))
+					r->probe_hits[i]++;
+				i++;
+			}
+		}
+	}
+}
+
 /*
  * damos_pa_filter_out - Return true if the page should be filtered out.
  */
@@ -371,6 +415,7 @@ static int __init damon_pa_initcall(void)
 		.update = NULL,
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
+		.apply_probes = damon_pa_apply_probes,
 		.target_valid = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
 		.get_scheme_score = damon_pa_scheme_score,
-- 
2.47.3

