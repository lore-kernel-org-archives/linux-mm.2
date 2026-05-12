Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5A7FCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148C46B00A0; Tue, 12 May 2026 10:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B826B0099; Tue, 12 May 2026 10:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71716B00A0; Tue, 12 May 2026 10:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2D8D6B0099
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 899801C0F12
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:03 +0000 (UTC)
X-FDA: 84759019926.15.2C1C7AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E171214000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p4ICceRA;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhzYqcVJqbDpGvIfYn8vQIqHs5lVBs0SfpRCkWa5OzQ=;
	b=XuxtFUKh5WvrANdIQZv2Pdh8BNCPFFHvZgSUdsFqt+IcaEFxjfbQ9jKbNWpb/BMhDAn+Kf
	dR4gn9a5ncFStGsCnhTOWgFQciPVQiBptm5xGt5gO9wej4GUHyR8DsSWzDpJumzzu7T3dl
	UoymyqcnyecBZscs4nk+/ymBiuUj40k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p4ICceRA;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596622; a=rsa-sha256;
	cv=none;
	b=kJWgSJ5Zan7hnP8p6FYACcjPHQrtiwYUAzmCnQitoxN5hd+53YoSTZ2MbGpr6qqaOBZCoh
	0THAyFzbnQfsmuu7tldsa479MnNGcGON7Gp6/+npdspa+lxymUauvyu00MlRXc1YhGIKCD
	FLnvYauqFvCq2sQ1IsQRbeEeHDSdzag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C8DA944A9B;
	Tue, 12 May 2026 14:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875E8C2BCB0;
	Tue, 12 May 2026 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596620;
	bh=rzjMv8caD4Lt/pj2/Puwk16Om6tdIYt4pV2QDp5f+Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4ICceRAbBffvDG9myKtbeCFfZMPjBeJhpxt40NJZFu8JcOfWccI1H5xfmFfVqlo/
	 wQHeO4Ujlv2DgLvLN+P5JtHVzOiPqwLPKW+yXXqi8soEVkfkagqyAXrpJUTyHdEtrh
	 f3Hpdz2yIbLx8ZIXPW79UCk/2pFIsRHyKtUxWLEaDrcyD686rW2BKQ9De4WjS3OR5o
	 oVEL7bKuBrGh5DEHh2xKzSHY/UZZeinXYafPw4SWBo4VzulEiXEQeW6Xh0qpmnUSGp
	 n57NMdQCq0g9jWpgqaJCrG/jfIvC90pXmkx9jj6w1Ef4M5yeJhd0Ljd2kOyaIZnB3D
	 uWs8X7p7PnbSw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 08/28] mm/damon/paddr: support data attributes monitoring
Date: Tue, 12 May 2026 07:36:23 -0700
Message-ID: <20260512143645.113201-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E171214000F
X-Stat-Signature: 88qoj6gjmxottucnmoskezob6kbyxc8u
X-HE-Tag: 1778596621-602995
X-HE-Meta: U2FsdGVkX1+RwtXOtdpt8hQ6JyYaEbL+LzdOtIXKJuZ1CtiF0MMLf/nQO49UKCgxrOzVYuoiN1fYqntUiAP7FixJXPmfhhboDnszv8GX6/Hm1kOAI6omXXgUdMERp6Dzeiz/j72Ggt2GC1y6jUWjfybpciqg9S3+EkESbxOIpOE8AWe3qFOTAimAApEh8XquCYDFmuxhgUE89TbNm2LoNlB9Uv2c4rtiTNtoNpKtuXJfp5IkuwW9rZwQxy+vXdA+YyIqxEwd34Nn804NIEWO8e7HB5tRJsCRpwT+rfKXHJhjajX4LC61tr26GOO2+kZ8P6U1e/KBz4OTzPWLJuwDdCBlb6qYpJ7WJlLmAmHskduqWMr7zi5oqgiv/VKI9HsUu6knmnr4pMUiCGqV5IVi00IIqaBjabwfhnr+GDoBPcJywPQPyHGZQhQ36LiEI+kzUGxf+sfelivlInn5ykSviv2+7bGM3wW9knDgOOntaoQmYr4Zo2PiKaIzGJYI72WhVR86lg4Ojs/h2QMWGXYs1AFzZX1sEDfZAU8SuuCyGpoq2kU7DdcIlvJWBJkPUjtySL1Qh8RpbycLgcOZInaAxyM2Ru4SwApy430s6akP9f4zGwG8BafS0B/KP5O6rcSJcXeWP0UjghKEDeVTrKBbwCRcwv2QMN4XI+cJ5s2Xve1PexqOX+S1A/6gVCAUSnmxQ0Gk9K32gDr5Zck2aKWXV0NwT15Kq1V9xNmpVf+PWqPCF6GosyBE7NDjqzVapVOgzq49XDc/NNfmKz5FHCNTGRg7OIPdU4flzDDsT9r7DmSN8SMpMqdeMaCGZ5FkDAgGAAXk5NB/QIi5xDnIUSiLoPWs4GLSqQ6XzMQbYs/GE5aA8TQNsOzoPA93qIeCCXhfYeK9Fq2ZGOPIfwaUD7dZv9pA88QnvMkNOtpmE0t8CXKfHXGWE+pD8EzaZJntLCp9Q1OplpCfNdQwO16sTaU
 WMP8+F5B
 cKWFUNzYlod9UW6atsd01gZpHpBCUagmgeCvWrJupNg9yRlXj2uTUdY1PCSF1v/ZXFku/Ytbdoyt/SKe85I+QvwWCZDFSJR6eKTecbapaty2eOgH6pnG1k4t8cyn071dJNtRR28PO4upZ9CyBzk2UHDfSPs78UbUu1m69VzdPIbHjNALKWSmp40bBobqYyxl1BEljMOX/EfYDNegqaQLHGw4k4/IcxwypsHQGrQej4lZbJOw=
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
 mm/damon/paddr.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index c4738cd5e221e..e60af2cbc1089 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -120,6 +120,67 @@ static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 	return max_nr_accesses;
 }
 
+static bool damon_pa_filter_match(struct damon_filter *filter,
+		struct folio *folio)
+{
+	bool matched = false;
+
+	switch (filter->type) {
+	case DAMON_FILTER_TYPE_ANON:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		matched = folio_test_anon(folio);
+		break;
+	default:
+		break;
+	}
+	return matched == filter->matching;
+}
+
+static bool damon_pa_filter_pass(phys_addr_t pa, struct damon_probe *p)
+{
+	struct damon_filter *f;
+	struct folio *folio;
+	bool pass = true;
+
+	folio = damon_get_folio(PHYS_PFN(pa));
+	damon_for_each_filter(f, p) {
+		if (damon_pa_filter_match(f, folio)) {
+			pass = f->allow;
+			break;
+		}
+		pass = !f->allow;
+	}
+	if (folio)
+		folio_put(folio);
+	return pass;
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
@@ -371,6 +432,7 @@ static int __init damon_pa_initcall(void)
 		.update = NULL,
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
+		.apply_probes = damon_pa_apply_probes,
 		.target_valid = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
 		.get_scheme_score = damon_pa_scheme_score,
-- 
2.47.3

