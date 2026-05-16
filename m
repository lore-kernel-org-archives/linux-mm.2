Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41438CD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 22:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB436B008C; Sat, 16 May 2026 18:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76BEA6B0092; Sat, 16 May 2026 18:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A6E6B0093; Sat, 16 May 2026 18:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 534746B008C
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:34:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D810C140459
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:49 +0000 (UTC)
X-FDA: 84774739098.23.772E756
Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	by imf15.hostedemail.com (Postfix) with ESMTP id E25BFA0008
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WMHjqawt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778970887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2FYJPYLSru7tpq4iL0KXNgZ0ilFNQRh0d+zdghJXVs=;
	b=a66wSBzeNH/lOcvZ2plTgXuZ5848hJdzuQM6yH8Mh4x3iZDvtfOPISecafONngHuHhTI0Q
	MZPPvjO4ZaB35ADVlzxBgDSrlVQ8CAanCYnyzK2RDJY2oRICNTmzD24T4LR0xzSqDn+E+v
	UtScpSNic70igpH5qRoanDkBhqXQlds=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778970887; a=rsa-sha256;
	cv=none;
	b=lAPIrFCHgtRisqBshturbDH+EwhcSE4ItT6cnOWTUUN8vx6Ue2HehlquodBXtA2QqG4VCP
	Ja0soFoCvU/uf4b83wZqU7cXkA+vP38Dy3XhzAof0qAz6meq0WvLXH46/sUve/dR/T4FtN
	D9sxuSzOpFK6/Iq+94iJjBIyKlNDfSY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WMHjqawt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-7bde9d73678so5541937b3.0
        for <linux-mm@kvack.org>; Sat, 16 May 2026 15:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778970887; x=1779575687; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2FYJPYLSru7tpq4iL0KXNgZ0ilFNQRh0d+zdghJXVs=;
        b=WMHjqawto2o0aYdjwZm4u3bdgnjLZ6FKkf02w9eVkAEMJhD3x25DRev7USi3Enh3GE
         cZ9aJpRqOB/UzSoFDIS8V2vSKMe8vMo7oigiUZCDLjEWUOnABySICODrEOVPt07N2x92
         4ZHEp+ed3afwDvN3oF5mLE+pzRa8wZxeoTyFdbbUWDl1sayWL1a9336ZGutQUHBSJyjL
         42BqweY6GKiPkZw8ppP0xetJpgRxibCwa0WGbAuG5bwwsfsOrUu6WrKWvykgzOue8rdo
         MA7Yu7Coy+aAF6C/6Ii+/UBvhO3e2peipkBaZ1RnejKWEhfwxiWiM0fwFnbpkagDmEaZ
         0CQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778970887; x=1779575687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R2FYJPYLSru7tpq4iL0KXNgZ0ilFNQRh0d+zdghJXVs=;
        b=jeb0nthpw2l8kcE4hL1ZlCyIQoy9Wynt0SefJ9cJC15GGNl9ODprDiUadQWd5bd+yj
         fV7jgEjly/KBxJjY09YeJG9joU8ob86T5xuZzeeziIH68shqQ9JS7YGy9GaBGFhI3XEM
         dxjcsp9BXGXVdgV6KCsg9wRp/kOCBE+mFGdUfxQg4icBeVA8mqpmS59yzZpgJUxU9t1+
         ng0KXKT8+/EI+14g9Cbc+QAphGBwdqggdGNAbi1H6UiI4fx9IdZLbQzdbD6dLsFaXG/0
         t7Evn5m84YiT2Ni1LhS1orHB+Mu3Rnaf+vP+vzuqdHU/CqqD3vR/7O0FAf86VztXfZP0
         rM/Q==
X-Forwarded-Encrypted: i=1; AFNElJ9R9cEbYrGeuQIBWZf9Hn15jZFREBint2s5SXazGNcixGVeL7FARwmLLppWZVQJGozms0QVQkBjig==@kvack.org
X-Gm-Message-State: AOJu0YzrjxpqQKMLbIKTggS/17zMO978Tr6numTvOhwL2Hb67PjZJtCN
	gO4/KOJN3f5G2gzRCYPJr747Lf5MeUTclo8yEQjzoTNOId8dNR43qbY=
X-Gm-Gg: Acq92OH4d4FifGZDB6sLoZ/XFvnf220mPDOFj6aDvlFtqw6dUe8d78GXcvdiMjXF8iB
	W87wgth9AEDKl1cx7Du5/SI13IA9tgaWD+Eyg7TAcL+MbdG42CQ/+GGZcpnqDn2TolTItN9PW0K
	t5qg//w2t762vk590G1xcGvXX59ZQ22kIuldVQ2eNFSQFmH8Cgf6JCd80okg04ZlkY2TJU81sR8
	l6urJ9YMhJrf70WbVvxaR673mHVvI66gM1PnIE9zeuaipXcNV/iB5Ecr2EXYMXstU67GNxb9qWQ
	OgLnYzSHSJNePIOti/5Boes7jaTHC+qwd2nFhwnE6es2/JuC89lhx+ZX6XA/wAZZpQL36f25oNP
	p1A7Fqv81E9jRONZjp/2XBqOpbamW9CFIYRW8NRthdXXKMI1fgZFPDWaR3HB0Ejqq5r6StGGK0/
	guq2n+RuV3vKaOUbl/UAe7tSJbF5wiELFkCGYNLozgu19PECe3g/pK3u/0BA4BsMKo6aAlje0HV
	w==
X-Received: by 2002:a05:690c:f02:b0:7b6:dada:4017 with SMTP id 00721157ae682-7c949ac202bmr92155237b3.24.1778970886989;
        Sat, 16 May 2026 15:34:46 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc9d18dcddsm633357b3.49.2026.05.16.15.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 15:34:46 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	bharata@amd.com
Subject: [RFC PATCH 2/7] mm/damon/paddr: export damon_pa_* ops for IBS module
Date: Sat, 16 May 2026 15:34:27 -0700
Message-ID: <20260516223439.4033-3-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516223439.4033-1-ravis.opensrc@gmail.com>
References: <20260516223439.4033-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E25BFA0008
X-Stat-Signature: gcz3c84ioobzy6arzzc31ymdq7jn3ski
X-Rspam-User: 
X-HE-Tag: 1778970887-188028
X-HE-Meta: U2FsdGVkX1+rt4/N5izuy8LPmf1JmFvotreH7t3R1zABKJTVoT4dUo/2Pt8fkzoASczW/u058z50lCrPJrPA0bCAsDiinuIKH1Xgt+VZLkOTjhp1s+5AS7vpI0UJzkymyqB7cdODaURm/WF2NbdDsaGtSxT+UK98eGZzBL9dDWK0dOle1D9WwxVGUQLSpYTp6cgeurzECbWh3vLAqz41e/7h4PYPwnMYimfRbFD2gHsLUeKZs1URNhLHfrozE6/jndiuMbl6H9VhwYPn2KPZF4spirmN6tWpD4dCqfVhy3GB5T/dSPVA5aZVzQC6oTOSKYyhyujrq241StyKXlqwcPMCxMOh/RkzgZApwNCFOKSaO5SJlbHHrWYTcfqqwxpLxqQxLJd/Wgy/d9ktD7GgimR4D01Dn1V6ufBJ2SkVY4NV8Pl0cJQpd5Dx1ur9qTCPi77Bt1P2YrM/Qu+VzX6IneqZ4Yu5s/FwgOnWSC8kWfbE15F6VBQe2WUSaRYnt+e4K0mDXCTB7y7xcPCUBVB2WIgjKkWwVzdR1plY7g5od72IO8BfPoVTqmaqaR2BjSlYF9KXpQvy+AebJJKb6x8JtbcK5xNlr5uO3hIYPS1dxWggyEjeNHBY/J7IVQcS6O39b/0fI41A4Uib2pyXmYLqmmm9PsMp9aHHsUQBn1Mo4tTpHn5hRkIS+rh0l2FYcqsd70lMEuxu0t73EQdXResFXKf4PeliYgwF9xFc0ffgI7dwTRjlKEhqFTRQyRDl8vRxcB5F2dgAYumHPnwkJKv04tkBFoRThaEJXq02aUwftpvCOwwEx1pHxLGAXFl5O4lQ1zCLU0KqaeONm/HCDA5tB9Q6aSqkn3AKqK/8yUJCPp4xDFwhhtCifdGzt2dYhkZ2ajXnPhG4fv79XW7IPt4qAu3QDg6jg9GxRKS8fHu/U3qPjLjXC6CFABLJOY7wQ43Z4Ys7HI5wNpG36lBe8bf
 vxGLmlCh
 nOiUYxaPCXHQumLXszMAgAZaJ7a0TTpLtC4gGbNfdJcDbxIMKKB1jtLOPinwlajKPbH6mv1nbur1w5LYRyc+OhtBASwmCVTNz7WJT4BmhKSgh/im12vpaxqtyXH4HSgcYj/y6jAEJA8UVmiCJ7EhGwXBn1aznAk2JmRK1MH6ZWJOKY/wzsevOpP9gX6gJ5hSedYKepayNnTIoEyG0ufSmlVZtc/aavrFSONs9eRxVzq+uep87qxiaXSEiqLzLhROnqppwlCWwPNWm4XYVa2s4pcSa1Jsbhk7FGYqKC7hkVQhjvhX5zj2mjq7ZDulgrRCoREb1yTu+1U9YJUbKI0vwFgL+IDwvmVBiMEQ/5R8WFHFPZ8w3ls1EYuihbcQaJRr+VUkVUx8ulM0uYvKtyF39sh/mZAGp22fVEt3FwTIeYDCzJq4kyFsgrLFHkbfuj9Nw2eBQD90dGPp9stWHPMdXgGans3gy3IleKfTF8U4Bg1pVlMXmPeM28v+YEOmvY7mzj992DGfQECST1Gz43ELeahv2hwnZkR2qj5PvlJOhI3kxOcOj1Kkt8PiCYvOzdELP4UmomDiMRaOaFdGHpy2tXZawazeYXKvIZg4gwTUH0Y3mtRwuw0lBM5JlaMiCgvvo3ZR1Gx7dpzHUeXHrNBy+3rgxS6mPxUKz3oCMf/bKJmnqN8mbiTUmr0S8/tdRyhEKYu28
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove static qualifier from damon_pa_prepare_access_checks,
damon_pa_check_accesses, damon_pa_apply_probes, damon_pa_apply_scheme,
and damon_pa_scheme_score. Add EXPORT_SYMBOL_GPL for each.

These functions are used as ops callbacks by the IBS backend module (damon_ibs.ko)
which registers paddr_ibs operations.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/ops-common.h | 13 +++++++++++++
 mm/damon/paddr.c      | 15 ++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index 5efa5b5970def..0ec75276d985a 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -23,3 +23,16 @@ bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
 unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
 
 bool damos_ops_has_filter(struct damos *s);
+
+/*
+ * paddr ops callbacks, declared here so paddr-family backends
+ * (e.g. paddr_ibs) can reuse the paddr operation implementations.
+ */
+void damon_pa_prepare_access_checks(struct damon_ctx *ctx);
+unsigned int damon_pa_check_accesses(struct damon_ctx *ctx);
+void damon_pa_apply_probes(struct damon_ctx *ctx);
+unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *scheme, unsigned long *sz_filter_passed);
+int damon_pa_scheme_score(struct damon_ctx *context,
+		struct damon_region *r, struct damos *scheme);
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index fc2154b6221fb..5af4ac2a7ed4d 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -124,13 +124,14 @@ static void damon_pa_prepare_access_checks_faults(struct damon_ctx *ctx)
 	}
 }
 
-static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
+void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 {
 	if (ctx->sample_control.primitives_enabled.page_table)
 		damon_pa_prepare_access_checks_abit(ctx);
 	if (ctx->sample_control.primitives_enabled.page_fault)
 		damon_pa_prepare_access_checks_faults(ctx);
 }
+EXPORT_SYMBOL_GPL(damon_pa_prepare_access_checks);
 
 static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
 {
@@ -168,7 +169,7 @@ static void __damon_pa_check_access(struct damon_region *r,
 	last_addr = sampling_addr;
 }
 
-static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
+unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	struct damon_region *r;
@@ -184,6 +185,7 @@ static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 
 	return max_nr_accesses;
 }
+EXPORT_SYMBOL_GPL(damon_pa_check_accesses);
 
 static bool damon_pa_filter_match(struct damon_filter *filter,
 		struct folio *folio)
@@ -234,7 +236,7 @@ static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
 	return pass;
 }
 
-static void damon_pa_apply_probes(struct damon_ctx *ctx)
+void damon_pa_apply_probes(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	struct damon_region *r;
@@ -259,6 +261,7 @@ static void damon_pa_apply_probes(struct damon_ctx *ctx)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(damon_pa_apply_probes);
 
 /*
  * damos_pa_filter_out - Return true if the page should be filtered out.
@@ -542,7 +545,7 @@ static unsigned long damon_pa_alloc_or_free(
 
 #endif
 
-static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
+unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
 {
@@ -574,8 +577,9 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(damon_pa_apply_scheme);
 
-static int damon_pa_scheme_score(struct damon_ctx *context,
+int damon_pa_scheme_score(struct damon_ctx *context,
 		struct damon_region *r, struct damos *scheme)
 {
 	switch (scheme->action) {
@@ -595,6 +599,7 @@ static int damon_pa_scheme_score(struct damon_ctx *context,
 
 	return DAMOS_MAX_SCORE;
 }
+EXPORT_SYMBOL_GPL(damon_pa_scheme_score);
 
 static int __init damon_pa_initcall(void)
 {
-- 
2.43.0


