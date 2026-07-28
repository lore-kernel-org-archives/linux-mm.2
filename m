Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419AFC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34A46B009E; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF066B009F; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC856B00A1; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A07A46B00A0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 194C2A0229
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:57 +0000 (UTC)
X-FDA: 85036864794.08.E186ECF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8E7E7C0008
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oglScrxw;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211975;
	b=4ziW+tevxO0A2uJmD7CzSta0jLxUdqIweiL40wxhmg5TqnYlmkfAZcA2zCJoVz+qQ9ZRAi
	BTcdaf0o+AOQRWn6tvuiLDZV4O2QNw7YWa7VtGEIrHyHlf0iiQ+NcdQPy0qVaGMy/CiWdC
	cz4hEnL6n8rsAKEhEf29TjIs/yv2HgQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oglScrxw;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLFzt3EcCEm4IM9i5M5f2Ly9bLRqeWPD/3m4Jo0md2U=;
	b=Y2rrlnY2dmzSufbHcZO6n4a8M+Ol+e8x7ESb9I1e2tvUtw+GDmcDmiZghof+/d3C+IaakA
	Zlqzk5iNTqZLrffnOJvuIP4R2Ms3osc+ao3i08vr5dVogGHT74Z0z/CtbSRxOQ/zG9/5bz
	E/uaRno7L+LY3cpE6qXMRlBx53Bsmig=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 278A360A6F;
	Tue, 28 Jul 2026 04:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A365C1F00A3D;
	Tue, 28 Jul 2026 04:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211974;
	bh=dLFzt3EcCEm4IM9i5M5f2Ly9bLRqeWPD/3m4Jo0md2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oglScrxwVAH88y6Ax7Ax7nnGkpy9HeysXFQJDjpvqI5IlUIlekaEm1w+D89X0wbo+
	 78qaNFDrd5Bu6wYCq2Zo6xQv0qz0BHqSjTGf5CK5q4aHDYIa3Ub766rcZbtMwCqJLD
	 pv4RZcD2mI3Kb2snc/TrF7MDTGBchgaDC7FCgmcLQDV1YIwxnVqTJfl1JBUpYFEk2x
	 Qyxz6tPo6aDHVfPXjC1N1QCPrWtz2fkChF8U0Ky3T0AD7b9Qv4UDAPBv4pjaZmpJR3
	 r6JvlwMTGkah/JYwA34QKcw6KzXEYLC4ROhNuADZZ4iVBdv9FLFGdZKRoWieN2jn3l
	 0TkHeM0TtIqUQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 08/17] mm/damon/paddr: support damon_prep
Date: Mon, 27 Jul 2026 21:12:29 -0700
Message-ID: <20260728041242.187380-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8E7E7C0008
X-Stat-Signature: ei4jwx8c66yrkoqhst1hd6xcyqycg46m
X-Rspam-User: 
X-HE-Tag: 1785211975-836570
X-HE-Meta: U2FsdGVkX19W6x7lNUDZ1bRDdO68DvJfDD1rtFVyXDvz4tEBqZRe4lViNv9hdbC+DiDim9w/yHN9U6ldSr76KsgvfK3oRHgjXSBdIc1442TQdQ1tolsYHtXNb6lna6A5nU1aya5dQvAAYXtLi13fGKpEPSw91z3dFJ64j5JGcwJELKjQmoEIVsPf+06hdr7EZLE4G2j+K9UVBfrk71jzN/f0rulrSIU2W6t85SJpP8qiNicDcqyM5/GbpR3bUPk3T8Kwjv90JKKYa3uPiyvEZa1cbDdHpcc5Lsg587tASuiwtj1GKoT2HbLQfzdiKkO1aJiqh13wtLWDvJMP5oxbshrPK0pfAD7NBvtlwOVIGI5HNKBsdbr6Y8EyMeuVF3WLorcgfwdV0AxQDPZa+pjGx2tQAm1f8nhEE8Z7viJttlbTq5SP8dg618/alZlpBI/cfn3o9x02t9VNHWYTTDzaL2PbOaZfkcfNUyZvCIWnGzfaLGbyeccbb7dQF7x8IopcoXwvvFyHpKEAfFuZuT6JRZhKqUic8Gjat/4re07DCIBkvDdvYbt4Xk25FHvhkqv+ZcdmFAA3jXY1tUFV9YR8UMSW/Cqtp0UxC9sYps6gkCqbK7Qe9WCym9K7fSCzHiQoNJjjcvzfjH2P0C/oKHEAxj34ldcg37cfN4Om+HMrm5jQ3oSr6Va96OXZE9Aqp65Jm5hPnuMMAlE5OhPBPx2SwMEL5n11tvXWGPohY5xqxPFtdirC3JYv/pGFywkmx8Lcw1HblPx8E7E3NirqaFlat6bl8DXMaddzPdY3i/vg6dRqewoT42PF5aawQvumdrTc9totR64pLzHpB4IzikQDc9pAJEigX9yyOwNns68H+4d4XWiuTTewH7zp09Hw6QFUHrAcvdBtEAu+yrXhLHmztDoKajmmfAxGhbZ8bz9xhAumCJrKYj1lbSYzXyHbS+G6OW69V96BhdnoKyCR53T
 /F9WnMrp
 UQWsl2AxPUrka7+oI9Hb4XJ6Cihj8QU2dPVIQ4/NhBBWCl1gSNbM7L7lNwUOU9dzWst93B21m3DOm3Awyv+UYlEAAXcaLiwAKYlEGRdk32c37FUkeAo+v8momZb+NGP+/xRqIwfb11XgBX76yrzr9c2kOB0ntMq82ENKk4TOZPgowcyGW+66/TNGzGk1s6ojU/i5rwANuR4gwLjHcgN5NQDlYpBPI9Dn1y9N6IW+wswBBRyA4EZxNVdqKS6sv5MOTYFjIe+7jaaCFQm3SGmfPq2siEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement damon_operations->prep_probes() callback.  Support the only
existing prep action, DAMON_PREP_SET_PGIDLE in a way similar to what it
was doing for the access check preparation: unset page table accessed
bits and set PG_Idle flag.  Reuse the function for the access check
preparation.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5b307dcbb2a50..8fb71183b76c0 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -105,6 +105,40 @@ static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 	return max_nr_accesses;
 }
 
+static void damon_pa_prep_probes_region(struct damon_region *r,
+		struct damon_probe *probe, struct damon_ctx *ctx)
+{
+	struct damon_prep *p;
+
+	damon_for_each_prep(p, probe) {
+		switch (p->action) {
+		case DAMON_PREP_SET_PGIDLE:
+			damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr,
+						ctx->addr_unit));
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void damon_pa_prep_probes(struct damon_ctx *ctx, bool set_samples)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damon_probe *p;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region(r, t) {
+			if (set_samples)
+				r->sampling_addr = damon_rand(ctx, r->ar.start,
+						r->ar.end);
+			damon_for_each_probe(p, ctx)
+				damon_pa_prep_probes_region(r, p, ctx);
+		}
+	}
+}
+
 static bool damon_pa_filter_match(struct damon_filter *filter,
 		struct folio *folio)
 {
@@ -448,6 +482,7 @@ static int __init damon_pa_initcall(void)
 		.update = NULL,
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
+		.prep_probes = damon_pa_prep_probes,
 		.apply_probes = damon_pa_apply_probes,
 		.target_valid = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
-- 
2.47.3

