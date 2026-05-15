Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BFCCD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70F16B0093; Thu, 14 May 2026 20:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4AE56B009B; Thu, 14 May 2026 20:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25596B0093; Thu, 14 May 2026 20:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9771F6B0096
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62A35160D6F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:51 +0000 (UTC)
X-FDA: 84767809182.25.9CCF214
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id CCA3A4000C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c305JDKt;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38OFEi7YU1bFmKwgPFTeQoBwE0H1tp/0UHZINzizQAc=;
	b=iQQ3GeAUA+9HyGM4NgBtSrkyUbokxGjt+TJkWMgSPsv1Yxw6wVgShbihzIXZ1MrELSm1UL
	VGacsOO/KzGMk529yYcbxCP+Fwu0dB62h1zoxk/emYBG/3cxUkheJXGtOaPlThNO8W0d1/
	AE67EMs0U+9sTQbuQDJ3EkIpzUemWD4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c305JDKt;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805889; a=rsa-sha256;
	cv=none;
	b=wJaTzWINtpsb3AXht6bCBzDh39gn+kE6JGd9mArUTjnGkuQGWaseGs568CNWlGmq9NEIDf
	AyjOkErHeRDnQ6JkWM59skA66Z3vNZcvjVknAi0YHNl3TV7Mg0UxE0Ao1B24aF/fzJEruC
	uTY6dNtEougHgwHxujWKwv1wwEBz/Fc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58C8F61143;
	Fri, 15 May 2026 00:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFBCC2BCF5;
	Fri, 15 May 2026 00:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805889;
	bh=XJz1lrbnCSIcGGsCp292XxEMr77UR12PQX3+0VG2CCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c305JDKtdZwckegZOgZqdHs3w1vbcaGR12vM+XkFcV/Er2btR8k1MWJwb9fycDBus
	 ripuud6obkSso8KB9L4rSdbxUEDoijhQ6ZQeEqY7YkHEqa1o9sDGYm3/7OXwEQd5M/
	 klXv1oHXsyymGwYXMeJmZfgjmdFxBUuoLBeE7ayixMTskUWotEKil8awTg7GmD/HL8
	 caBK+U7g8N1zokS88daF3Ki3bb7nfJHPHVbLiAjmo7CbsEtVyd3jzfx21Q+/b+6zu1
	 YEiwad+2vF1SGqiCWjsk5T1QsmG3UHSgSjFk/MLFNqTB8SgI4hVOkRH7Ky0PmEsbhs
	 eJT+LlfRL+QuQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 08/28] mm/damon/paddr: support data attributes monitoring
Date: Thu, 14 May 2026 17:44:09 -0700
Message-ID: <20260515004433.128933-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCA3A4000C
X-Stat-Signature: znuw1nt6d4gwxhf8a6ghbt1fjxin8hub
X-HE-Tag: 1778805889-251771
X-HE-Meta: U2FsdGVkX19AVSWbIxA6I5AKfyIv3N/MM2l7ELcMx4C9gbDLQzkoGyoxi9tEZeBM7d/9CMuDH1f5s/PqbbYWlWVBeabqW+nD8a4PfX+bbx4TUKoV6YdkmEWB2hg9fYGdqwsnDjdhTwDZg2fKLF41E/0+EhkmI+DrLnhxGdyQ82yk/2hVGSyXA4y2sXK8WifgRGFI2lgB43E4TSkDhd/xa8o8sfLz3B7tSGrQhWPP87JXjwnwGA8+hfntnSJFARD1xx/0Q7Ngf30jYW2PeSL3/hF1oMHAqHZzRG6WFdXJpRK1aL/T3IyVqvUMmmdTS8YqRyqZMR6MVE/bIwPQVGgtsXg27CyshKPrmI9F3zZnCFs8qy4+hkH01b044tDeU5vSs4sjwS7uUNnmalUZide2ToZstW5BBTyzIM5QylgUdOlIXTfTGBzfccZ/cankiQqNJ5hKpkgDsmzalNUzfgISBqJfFCyE3E5IQei+qFglgbGe92eaL2BVBzP723YOrGP+rgEKK7bWxON0QRtfldPZTDl9St8KGpkUborXsjsELp0ac7gL0VuDv35BscKrY5uLNXd9oOwFXAHXcXDJULJVzA7pEltqN2iB3NhGCDdI9drQXmvBry3coyhboE9qGBlV7WSz0avilm+jVQenlYXI+08gjB9b2731vKlaBquzS4OnigDRxbOsrm6uecZMkYOEknfXz23XB6811m70ovvbA5Qi8PGuWiaT1T6YFyUFBomtyvTEnFWPtU+Hhr4x5MnwrDxwedksPUxUj2VY6g03YBtIndnf1WST7IBoKhswZrSpebjR+ZTnR45h+VfS19AEe1VgIgDgjaQr8VWa3cK7WLAR5cuVj87slhs/Xoak7MONfLh6aj5KtClgtR8NuMYIUkHmYsDr90qQXU3Ztu8iSdQsyD2kEO27qXMUzE36jJSqluST4xBWF8x9vjLPrNNO6vjA0ZHL0YDGCxaYIZi
 0feudGQK
 mcLZnnobpCOhdNrneO/o5bueewrPp6XHqtm4wdu+0Kt+NkVYOEyMyiVQT8fGqBqcrzL94qXDvOyvCNBeg2TTM/Lo+zd243hXCueLIIFe/LbVxlVd/4taWLO9T39AJEouF+8ke1CRjx6w0Og9xabYlcS8G1MPgkp+hl//46s78fV7JPSFOAnJLKoFuoyxH2ZPshdk6WgvyI1cQg6Kwq7L9dzQB8I3P+IABiwob
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
index 5cdcc5037cbc1..493bcca8ff104 100644
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

