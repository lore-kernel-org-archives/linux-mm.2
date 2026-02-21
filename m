Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D3BC61DEB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 19:36:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BB9C6B0092; Sat, 21 Feb 2026 14:36:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7246B0093; Sat, 21 Feb 2026 14:36:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513756B0098; Sat, 21 Feb 2026 14:36:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0FD6B0092
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:36:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0848C1A0456
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:39 +0000 (UTC)
X-FDA: 84469470918.10.DF3A7AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5FDD210000D
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MPXqH15g;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771702597; a=rsa-sha256;
	cv=none;
	b=SO9aksPhEGeiiLspUyuO46QdH79F+KlhoNhVHhxW/T6vOoxeryhk1AW3sR6hfE8zECFWSi
	Hh8INw1PGggi339qPEg9yhaPdk14J2cnDnXt0VWrGJcaXLhrqgu5Mjh8AIRupWoB7BElqB
	9r+7FBjqSEoxPUB0P1Mxfbvo3531Yx0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MPXqH15g;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771702597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nh537mh9VxdVE2vn3bAZt76FMllac3rVm6PQntVGhG0=;
	b=xFO8j61LsDJsHrovvDafcfXgLrjHF6SWSAWIcJA44cx1spcMi8SvjcHgsyq/1B7qsgbZfF
	jPIrSQ/tPAMx2b3cpCAXu4t8JXT6xs+OR8HqI7GMfWJskzeydUYdhuobpX9qMgbOhotKjP
	TnICDUCUR8V9rDCNGuk/nbnvMZqeQOk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80C84406B1;
	Sat, 21 Feb 2026 19:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5034EC19422;
	Sat, 21 Feb 2026 19:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771702596;
	bh=eOXf1CiFbFTK2Hv2twtoei0dTOZocW8a2ac1D/Nl1gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPXqH15gc0vWx1tPY2KW4rtGZ3xtY9TJnGEj5MuuopIAYrIOE3Gp/u3xC7iyoW5s7
	 rizkeOvY3ymuZr33ZOXgI9Vbpj4B06UP+pawVuVfELd/rJ6Cb/F2xcvbZVoZrwj9h+
	 xb2hgK+T/98uptk7AL482fkl10Z71jQCFeVsTlclwNamegApuoDKwNjzKOCIxJ9N4Q
	 P2CdS5fRyK3ijCp08GwtNlMdQ+Hj1ZwY46hycYwvF0IGVlWgQSaGuah1vbkLSkkhFC
	 zmn5Bk20/RjYZZI/hBv3bm3X+lCy/AvlmNmvpZ/SMDo/GxmybDfaWYKNAqIr/TUr5V
	 hz/2JUdRgX52Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/10] mm/damon/core: add damon_merge_regions_of() debug_sanity check
Date: Sat, 21 Feb 2026 11:36:23 -0800
Message-ID: <20260221193629.19332-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-1-sj@kernel.org>
References: <20260221193629.19332-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5FDD210000D
X-Stat-Signature: tqpyzeryfdemcc5ix1qme1jixd4y9xam
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771702597-278833
X-HE-Meta: U2FsdGVkX1+uH1U/qSb5wuKThPuLVLvKUC1iLuk8CLpd2hDkRbTmjTx7ggiQKI2ty7zwValCKcZhDqLEK/S3IQYeYVAVcPbbFXwvkzwHoplfqsXkj4nMPqONRuIwCyt+5q4lLhzCJtCBynaWEwNjBfCiDmL+JrmqsF1qVdRe6iZu3FN9bMHhHrwHwQ3za0Xt7oUcId7MODlz3W/JWrWfbuVFEbMs9gkGay3iIVPLxvoBq20o+kCmF8nCch6IbAko8/PuGjcT+vvB4wSNM+6Xj+FEt2BBDS3kf4jFZ01SI70dK2fzTQ3ILfBwX8SropMGHD6662H5NRCqddUOWfnJqs/1ip9tXjkErAHLWxkLyBP+mliZKv7+tMdAaGd88hS/lyQntH5OBW9ReyMtShpgfVM6DnN8Bnp/hc+mtWKN/7wpU6pidT0+58MjlPov0t0qj5xvhXqBdsCurBZ2yUruYmdyDgGNWMRPkH39LpNkfxpkr7rkvfEvZeujeHteEsQ0i/D+CNUfGvPeqy4cfX5C19leYFpgW+K+3xMUNA9/9xRoelgbchq7TFvGnZHPi3R8/jofrSsoSytIMrQkY8Ejc4V0+L1a+JL+O0EGMl3/qtSn5qyERw9xxLjUUQgBmg6TbjvDYIGsI4lYHaj5VLm/EUxqZ5wKJZys9RMyCoHDWiKCCv+bkwkgO6YHjO+BS6MydgwupgwjASKl1BV8TweaDzkoG7DeHSFhYHhPWV3h6i8XAwYorqomRskSNO3Z3wW+MteD1PU/ypwHZEZgyDzZ1YgIaAzx7+QCBtKQINrqxik67U2f24dTe6k11fVmrXOE7CfPon7B19F7EMa7MYL0rgqrAKq3KueQYOPexcUDZFIIky8b/fFx8hh7PPkc5wNzDhWLJms9hmoMCQkRnnEiR/37od26U+dKQ8Gf0YpikbHBfoiPtdvnHe1fIyPB0AuEl8kxg+ks5WqKNicHMHT
 3NhR+5/L
 YSh5FyVZ61+mzXF+976eElvZ4hC1f6rLetbjFaxRMx24KkTokhWzu5yHHlTBFWPiAJYXneDKZfEwO8pna0NIbpSJyZLGHOYw6QZ6nPR07+vKTtlWFOom47Tc9qu0XXpZVVzgCMaaKQ5q2iWmiC5N0Gif4Z1ztB/qKa7w8tDXbijdG75xr7Ev0WmFCvfF5wf+igoe2yXQ63jKZlNfQ4FhpWtzi5UZNbYcPRNCZGFhHimYnCogZeOzl4hfKChddxssVqsWO14COdHbzktZ6hCsHijW2pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_merge_regions_of() should be called only after aggregation is
finished and therefore each region's nr_accesses and nr_accesses_bp
match.  There were bugs that broke the assumption, during development of
online DAMON parameter updates and monitoring results handling changes.
Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 291a847a8c9bb..94be598cafef1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2545,6 +2545,22 @@ static void damon_merge_two_regions(struct damon_target *t,
 	damon_destroy_region(r, t);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_merge_regions_of(struct damon_region *r)
+{
+	if (r->nr_accesses == r->nr_accesses_bp / 10000)
+		return;
+	pr_err("nr_accesses (%u) != nr_accesses_bp (%u)\n",
+			r->nr_accesses, r->nr_accesses_bp);
+	WARN_ONCE();
+}
+#else
+static void damon_verify_merge_regions_of(struct damon_region *r)
+{
+}
+#endif
+
+
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -2565,6 +2581,8 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 		else
 			r->age++;
 
+		damon_verify_merge_regions_of(r);
+
 		if (prev && prev->ar.end == r->ar.start &&
 		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
 		    damon_sz_region(prev) + damon_sz_region(r) <= sz_limit)
-- 
2.47.3

