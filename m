Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F86BCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C366B0099; Thu, 14 May 2026 10:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B890A6B009E; Thu, 14 May 2026 10:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918CE6B009B; Thu, 14 May 2026 10:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4686B0096
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32E8C4016F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:23 +0000 (UTC)
X-FDA: 84766207806.02.4F1FB1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8C29120010
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TwTHbYD0;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhzYqcVJqbDpGvIfYn8vQIqHs5lVBs0SfpRCkWa5OzQ=;
	b=Pr9H8qpen/pr0nixw32/+c/ccZNuqMivabjaxsgqeQyvbqbsr9/uRxJxV277MtA/oY52QI
	Ps7AzC/yLHcAGK6NmuUPTBtYRfP+H7vxDQJQIuPrcVbQfiuVRlODm1mmEk19L0OxCmlxUA
	stqbwyegWn3XERy4mWQwRX30qPttqSs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767761; a=rsa-sha256;
	cv=none;
	b=eoCj20swGGZVSJFbqXdv0JvCPLY9V98yFGMdZAQNcKYjOv/4iGlgu1UoC7JQ5DbFA1ehOx
	1bx8qtHNM7mg754KidMRHIuiUhIa2LR9otRuexQJuySU+tG0VwB/o3g542zwnRYH6Z9c2Q
	W1hfKZeayldzOW7N3M65OZqaJRKKDNM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TwTHbYD0;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 31A7360181;
	Thu, 14 May 2026 14:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3892C2BCC9;
	Thu, 14 May 2026 14:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767760;
	bh=rzjMv8caD4Lt/pj2/Puwk16Om6tdIYt4pV2QDp5f+Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TwTHbYD0GHARWC1RgNnGp1Xz90K/OzzCFZa5sFhLp0BnrB6O1hF4P75yI6JrM6jGL
	 YE5eYgwqsMQcdrieFDZ1nMbymu0ZSxBlPoP34Il6Kk1pjZqz7iDoec4Sq4MeROGm3y
	 ki99IrLSIu56dMBu4fji0P6BFnZoL2ds2HEvsaMiasGd783981K7srP/qqOqFjaUH9
	 6OKixbVsf5ZZeeHLqLCY3YofmbAqNin0aM+fkIG9nCKDn8tzxvFH/wsVUK+tvGViyU
	 oJNI/0elOF1oXbm9zXvfa8utm2EciLB+4h0zHFCIynsZz70N6xQKjiyqyKWDrCrP+8
	 NnqT4Og++DG+Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 08/28] mm/damon/paddr: support data attributes monitoring
Date: Thu, 14 May 2026 07:08:41 -0700
Message-ID: <20260514140904.119781-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A8C29120010
X-Stat-Signature: migbdddunf1o4kn6ccn7cphhojfj6axm
X-Rspam-User: 
X-HE-Tag: 1778767761-441172
X-HE-Meta: U2FsdGVkX19ItZpWDQ70NvP2fzI+t40p3KX3yalH5AfAmuXkOsS4JR+FdXpJjLIKNq2po068dj2O7TIHmB1cJYue9UHe4a2kutBmCzbi37++yAuiRwKT4GsVfMZtsYYW0h9ir9fxVnhC/cwmudJJtFIGUwr3oviCdqCEVGdFL2yQTpS5NUg3iYwpEvl+7mJu8D94b8el7zTB6zl6uODS9n3G1irGFeJDhBoS6aGLBqI+bHcIbhEHduUW3fbXH1/pl7bKNtNrBoepoguPmC1d9RiI4sWq9mJhdbSVwdDAJ5SBgSimHcCSCb9/b2vCa8nj9yTSUPA7P50n5aiC8EQWljepPPgM8oLrDGgSP01cxfKwDqvaMU+73cNdpvCEz8+/OPY1XgvRupwXlSXmhDGhcUttV4wJiGK39gT3yEDVNPg8abpWfLmKJxUrMBSwkVCAyqhy5txWJ+OCUF/t50UxKrnz0szhhtds3jNZbjevsGm/gnfq0mSOzRqqWqX5vRnWMr0ww9XDgaVggZLb8ox8+2kKvM3xkBz4psVC+jIDUZHQ4bOsOg8Cnl1wBDRyFKU1PKJHKh8tfvSZixFrshO53rO5IqK+i65goOXdCBArKh6p3HsqRcYq7oCvyGiqr1U/lqwTk7tGfMjOSVrsPm1QQPTRhpK0U/5mHoDFos2TigoBKcUE+B7y++Ki5O+bhtq7yVVZkzz5cAz+UY1kObPUUlm75EJbCsP9nFYM+q5HbtBGVwHI5dmN1v/6FA0kDE51GVx18yPt+fQ2YYIQtnchCoQmMjC39Rmujl5x2Z3Layz4v3iND/CkfTCLgGwlGTLkVq8e4bBZKWO46/4xr4z6NQOXiwOKxYbkGpnyd6Ok2tb6cF7mx/EjdSaFGXBADbGQBQw8x43Rrt8A0+l8QjjILd8HDZ7p44TnHm4xS36vWd+y+p+qUhfMQC9Hqn+W+xH4ke72NFwaqRPFC+z93gb
 35Pq1EdJ
 QfkOG/L2y/O/lgectHpRA/cZw0KnHNnPClxU5XfbZId0kVc2LJnjdj59idurf+8ZK+HT1fYB1FVhR8+JWVhJVcwx904qIK3OZi3qhRj+HHCKTps2prKPA9r27Q8ogNR1ndb90aFgItXDHCTO5IyylPn7MkZov3QSjldHErV0scjsALk/B+CRg1FnzTJYZw7m4hfCFhX3fY2ac9hatFIfXv57pcFq1gg57xFuS
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

