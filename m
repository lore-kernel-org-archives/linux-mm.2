Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C10CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357646B00AD; Mon, 18 May 2026 19:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6C16B00B0; Mon, 18 May 2026 19:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1AD6B00B1; Mon, 18 May 2026 19:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF1716B00AD
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E84C1A0A7E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:29 +0000 (UTC)
X-FDA: 84782164698.26.043FE62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C6922A0009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JTA9vo/O";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JzwuNP1BvbGngXCra/xOexWBcoSQjDJzD1TpyMd8Vyg=;
	b=mD542hMrn9wTB3IBZXlxvSVtvsMDPfAczVIu8ct4DyVE60DchF1yaQUVAWuV0qsu4URQyg
	IqVa8w9hHJIKwtJ5KCu7PFjPXp/Y8fkQ+fec5yi3KSSfSWRll0GlnWq9smHYoirdqKIlmw
	DCjEX8aVuYtsuz+QPGFMGO+Sod9mrsY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147687; a=rsa-sha256;
	cv=none;
	b=ipMlfL8ntTZPcQHwqJDxlRWTTty4CcpKlQ5RK5Ez1ANUKlr6PW7+eW5O1ypRMgIYouXCK+
	Xf/Mu/67x872SsF2gN8jD0te1mrVpBCF7Ke252gaeIHYdY8tdgJWAa2N3QL06lmANQCEQu
	+CNdlLLLwXgqileLKEt0oEIcYVflvTE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JTA9vo/O";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B35F344576;
	Mon, 18 May 2026 23:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDB3C2BCB7;
	Mon, 18 May 2026 23:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147686;
	bh=68XCaizJWpb0cvYPnjOEqbd/hx47Dw30XZpPcOn5Ze4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTA9vo/O0Xr5kznzHrfK+9YrtR3JWfTICJHBHiwShjW6hCG/dT20uJsCq5m/tawNn
	 iwMD6ihHE/CtmV7T11aplUeNxneg89abq9jdcoxRW0/ZfhxUIoY7DFjOQ810fYQ5NY
	 6OwxIRRH8U7bqrOyWa43q5JV3Rt5oqmZ9NHbysNdOoe3CI7fkpL07vjF81eq0NMcDH
	 qCM8W0G6d9VoDRj41HICy3O/9GmMAKZYY7fx1V2IfKOuxexCiUiwViKkhFDbC3JhIk
	 UmpKZxj2NWZ9Vnk1YLN4FVKXtVxaYIq3j0gVgqfeo/TGPbeQcZAOFWJL/OUr0I1wAD
	 0PLrySLWvYgXQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/28] mm/damon/paddr: support data attributes monitoring
Date: Mon, 18 May 2026 16:40:56 -0700
Message-ID: <20260518234119.97569-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6922A0009
X-Stat-Signature: xwkxz5suw81ic1rdst87kzmbiig5jqpc
X-Rspam-User: 
X-HE-Tag: 1779147687-998301
X-HE-Meta: U2FsdGVkX18i/CRc3cTMNST6WW1U13zrf0LddARQyRVhMSWyQP5FNnvGteQ4wWOlaJ+EuDPcj86fZFcsR1vb739oSYaSkeCdagGwrZL++49wt5EPFIqwVxQZCV8mePYWVHyyDAitALtXikikPivz06aFv3xM31h+2dt/vyCXr9LpPeNKdCw5TMF7SVH9Vavdmo9K3EU9rRJrnTdY6EFcGYuth7mFbuGkSnLyCwJllJxgcQLoYPJKLxV9+n0Im3OOPaAEaCCKV5EnKgpkgZdrWpN4q/q5gaa57qJ6AkSF58sJ6v2rfx1/SybQmvYhy0f5hd/hXoVAf5SWxGP+LYAyIWhhWksEkTYvUGleKgqoVxl8evW75vZuEGuiHkvNUveu6/p6dPyv+e1RqjltJz0VOlcoMcCrqY8mizZJYY6s+pj7WV1lzYxkLteEDieOi644bSw9PJ4CuoFfvcvJQ3MWotVxecN9d17cwKbW+HqmXD6tYGfdAA5Gr3nAQJHs6DtR8gMORk9NYFFvftWzdoVeg865fI2JBlAtdb3uVsHz+BAg2RWGnxOSMPh3HfF60FdFqox0lpyEPpdiyuuaoj7blwmCnCJVvxubjtlASnZfyPcm9KnktFfxzL2C4u/bHWb9tdoKKu4pe7ZJgsARTt+JcSTNvJjQ6pnVJAo0KNggOF81Dmi6B+sk1lfWQnzJWp6+W50am/Pl3n02bNqUIKra8oGpgbtonzGyb+2H1eCXNGBJJ27/e6mBilRibZ1Xtu3dtIKuXWvWXbUPekl9jwcEsIitWoZRN09Z5MX+NVVErQrcsaLAxBnBR32OYx1SxB6803DkFk9kOFjATAOqI5PIp9uACYgQcnPOrbbHqqqygBZXX/BC2C6nhKXBEONIwswVezCTP7UA9vNsUpL+crj+Dgya0s3gto5pQMk9Ji87EeuX20yUvU3muk6WBKDYvlcUPXm3Ykt+nSaHFAhuRgP
 oXpqCWze
 tRmAqIQ2I6O+C695PzOu6E7voUn4fRpitMNqhFO28G5OOoN3P0Kip99uW/3sjlQkCfwZI+4jU0V8tG2DtB1qpPE7XEfX5fF/Rk5ZbGZC7M0ZPpgmURXB1BcmYPz880HBCgK6kBzqMiActfwJWm38RMh/soatGZ2cb+iZM2dC6xYuGX1fdUJWGAQ+zIgCkMPpsMXwc9GE82qJT/A9jAKmhrx2j++0nBJiqyEhiPJ2EYB/l168=
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
index c4738cd5e221e..9997c5174ef1b 100644
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
+static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
+		struct damon_probe *p)
+{
+	struct damon_filter *f;
+	bool pass = true;
+
+	damon_for_each_filter(f, p) {
+		if (damon_pa_filter_match(f, folio)) {
+			pass = f->allow;
+			break;
+		}
+		pass = !f->allow;
+	}
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
+			phys_addr_t pa;
+			struct folio *folio;
+
+			pa = damon_pa_phys_addr(r->sampling_addr,
+					ctx->addr_unit);
+			folio = damon_get_folio(PHYS_PFN(pa));
+			damon_for_each_probe(p, ctx) {
+				if (damon_pa_filter_pass(pa, folio, p))
+					r->probe_hits[i]++;
+				i++;
+			}
+			if (folio)
+				folio_put(folio);
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

