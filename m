Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E47CD8C90
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 00:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA4076B0088; Sun,  7 Jun 2026 20:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E555E6B008A; Sun,  7 Jun 2026 20:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43BE6B008C; Sun,  7 Jun 2026 20:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C178D6B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 20:13:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E973922F1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 00:13:00 +0000 (UTC)
X-FDA: 84854820120.08.961A233
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id 91829A0010
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 00:12:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UnDYAKEW;
	spf=pass (imf25.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780877578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mk9k96LkPHvpgdEUvtD4skaKy3bLvJk/6TGCUK5JLAs=;
	b=NVFjaqcHtcIwSswBxjsv1FuuULOt3T48cC0EHANCQYIC+rvhWP4JdQ4Nfm/MPvgAlX80Vp
	Pl4opiYcx8gMxrcrJhq8QNKcbiixS3TS7NSYU7M8MuDyJzO6/fIiqfU8O5XKEsrI1AjFQq
	d6fSrvqghV+3dDYP2XslpwoqpevNiIw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780877578;
	b=WcfnaybgQixyPOpKOGMGieaClsCQ3UlVBFvia5q69xDlwpto/tcnaa4CjOyTsI3UxOC9n6
	3qZpSFfvC241ZdR9dqFkOUU0s8Gqf3ny055OewJsz01ETgb3hGpLiWhxpUPPq3sghedR+6
	rZJZlAww/eeW5IYL0u+lFT+/AodJ/v0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UnDYAKEW;
	spf=pass (imf25.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490aebf33e9so19944905e9.3
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 17:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780877577; x=1781482377; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mk9k96LkPHvpgdEUvtD4skaKy3bLvJk/6TGCUK5JLAs=;
        b=UnDYAKEWyXRRTN2b7fqPZdszwqGlYIC5xIkQ1DJmKMA6dzBD3k4jItdu3G/kOJDsm7
         10pDc8NHicotGxcCpC1vQTn5kz9+lf2blR8dvJO07C5s8n/iApGohWVWpTjmuKJzjzQw
         qZFKOseIRQtbqrLehLEjyvMjS8gToW0+5Fxkw12yvN1UeHtoi7UmNIBvmJlQHXVeV4IA
         nBdJpcy7HswK11l50WhGLkSkGkHOe6TEMEsFHFfTq/xDixtfcZrhiNjYUpGIePzSg7tY
         1HeFW5ZUDL2bK2szeLJXr5PUBasYl+87VdF8E0ApK++Jh3MMl+RlrPoDh8r8A4Wp4hlp
         ginQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780877577; x=1781482377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mk9k96LkPHvpgdEUvtD4skaKy3bLvJk/6TGCUK5JLAs=;
        b=T+W00IO0OucvRRf5hTizFKnQ1qNKtaNhjZdlh6TlwMeqI+0AZ36t70nsh9DF0NMaaV
         bHGPa6sU3aWvCBM5RxrW7A7/ZU5VWEmcnpJ93IcwtVvN3iEAwm3hTlmSt3GcN1/XrvkA
         SP7p2ZGnXIZNznlHLFX6K55QlUUpxqFhK/lBqyreXwoqKPMcRwzOtTnfR85gNv9FX+UV
         Jq53xNKbbK9Og6GgkSK2UZ0KQe4X5cVfxFhHi/xr77AVfWzfURS8X08UUhniGNlVkDp6
         gbz6WLGHWaBzRiP1ycoWMLsW4mdenApSzPv39pXV1OlS8BS77z3cSRUAN1+VxmB/DzfU
         FO1Q==
X-Forwarded-Encrypted: i=1; AFNElJ9HAK3algmuS2zhCXguSsprUC1p+He73XjGjyvE85Tj77VnS+pHbmRts5Xtk9/IVNF/tSDVzAxyfA==@kvack.org
X-Gm-Message-State: AOJu0YxVJB6DjHHQy8HG5UbYZm0+Cd0VsgFJUMgatfmoVJa7tdEDDdv5
	P4LRwuGpNOuX5neaLpZdeMfE0Q1vo+zOyaVb+74Ra+B/XJyEtE8134+Q
X-Gm-Gg: Acq92OHO4sqPqloYBkyRijir27NNH8dfwspd46wqGBd2nIp/LMhcFYrGccK2gFhQkwW
	i9FdzBFfNiiVWR9qtO6VmtY6yzOa2vHw/CMpvlMNkseWtcpqhB9DYHhPi2hgnuG+psDVsa3xg8t
	YWMPJho/6I6CnYalcvl1BI4NRaFtYBL6osBXcqZYayKlF0LNKBRqfJpC8sQL4Lq2EPSTOAjerPV
	aZAfmzqnIxgLGANvDxEZnCGbMX5c7FVGryxQhu1qphXt8kzGz3VC7U3lf3IHlmlASBbcN9Oxjvx
	5qIfS1ztf9uHEF/RLR+XamNdI15hol9+gqZdbcwti2CeFJWXSTUW5bpVbzI6EiyzWT1MTv/N18p
	kGjBk9dsF/F44LEGcs7UWBVkfB1ZW8bMvr5pfoZSbAEyAIZ/oPK00Bkrt3zGhcyHVy/CZTyU73y
	NFQKm+2EQBsBzFLulujNCsfaDfqr1JJJZg
X-Received: by 2002:a05:600c:19d2:b0:490:bb45:79da with SMTP id 5b1f17b1804b1-490c25af9a3mr225775285e9.13.1780877576663;
        Sun, 07 Jun 2026 17:12:56 -0700 (PDT)
Received: from user ([104.28.154.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cbfe4sm350959785e9.7.2026.06.07.17.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 17:12:55 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yahia <yahia.a.abdrabou@gmail.com>
Subject: [PATCH] mm/migrate: Add native folio functions
Date: Mon,  8 Jun 2026 03:12:51 +0300
Message-ID: <20260608001251.66847-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 91829A0010
X-Rspam-User: 
X-Stat-Signature: bjfncqak4zib3xjp8a6x4bqumyzt9qgm
X-Rspamd-Server: rspam08
X-HE-Tag: 1780877578-524152
X-HE-Meta: U2FsdGVkX18reNiYoml1I2eCdEAIXmsUm7jGZXXJn0nb93DuQcsiR/4Cs4Lb3t5ejboaHuamn8oSbJNLyxwGQwFmyn3BZB25uuHoiYvMDPdmJSziAW/TWRJXWRaB11HRYTeX3gKnKejDNIrAcLlaeG8SjgkK1In+Qt25Unp/Lvy4A4H9KzttdSs8mnWcEQn5WtJLCt/nKAFHPpZopSnkmJb4sqFlILalrP0sO0CLkn+AGAZeIuEXx3QDM7Hdh3RLk8PbML4+g+nL4mh7g1nNUwOjzGaiZSQKMLP+y3G9RaUsfHwjRiPve/o8MYu7TuMRubdYzWNHMfoesxt1BuZ13LBAm6LddLQAcggECCty1TN+YCYy2gwhjUDf7lXyqyZSS4HyfFia56dbTVzC5NUoTHYZtQRHlRwPmFHNGy3XzROuOTw1e/4T1Hn1a/cQQ5u0sdqwG9c2yyTYzI9rCOQC1DDLWfxZzhjRKq5KL3fA+Yl3Qc+8R1R/Vw3tIDsViqT3pJiNwyzQtvlJPmoslHN0m0Srr6+rA72CS3gWPrhfJiM2YhvdCVjAjB7KbjgM5rXWnhbUDzPMLnEUgPvB1thZIGSsfWBM3i4r4ZFKXqPqyuMULgNV1PR9A2UB5kq0tugCLSiKvRLSRpGQWZaQCl9UYisGjc4V8SF2Edng88UJciP1j5ZFo9iMZazfp8C4u3e1LQsxiljdyfRCGzXTzwimI3KH1lIWg+ytmdC9FZS6FOwytw+M/Xvc9PsKSKPIzRQy/hSxfun7yDbSarbF4p5JZu5/M6Dd1S2EiM3MlnGkUhr9Xt5eeesu19aJ3koIvNPEAPpqi07MFzWgBMaI/w1cRYJbcxWgsRRagaWbxy7Yre6GuqQi29t9J/Bd3fOu1YizqJIQE9c9Pf7zBUGdhWmLMAKjjacW0UiRSB+akhIe+M8uwl1JOVIBsOTw5A48UJ9zotc6wRmnvv/pmF8cSlB
 9dDfhufy
 oAfuOudX413QtRkP+DnNDJM0hmWGHSbURCIMN4iQ2yshIPHr9q2lHkC5eCdPgl5FP3M/rRAnqSRR6ZRBh3VDvnIgdlgW8+7CG9dZg8A8YVPdrYn7yIMu3+I+VYloTq3NXs4f9Jv9qvXUK5ncOmtVxWMyJMYvCmdz2RcUX7+GAOnl0EyMwUJWZLW1/xjp9fGg715o6RPUQ2WMyHJaXrN4+go4LBGAWdY8Llmo65NaeZsyLbZSwJGGix7jiHeTVO3WC3RvxcMew/cBhV51iQA1RuUMVDgU19lQnvMBiH26+ujomYRtOnevKaM4IOSvzEyI+b7/3dlaLd5eJAto3Q+0FNsYv5tGvNHcj2b+cbgwffRvdvC076AuYPADKRbIyGc7oq7uMVa6vpqpQdN0MsMCi1zMISvwyk2OmEq7f/qVEqouEUfJ5+7guMatm808/mRdbjgGUKXM1PB0ybusosnsI1mMS967Jh+rGoX81cBTF89eSnDMmI9h6/hiq/OGWxnJHFu74kVsL20Uw80M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

I aim provides in this patch to provide native
folio abstractions for page functions like movable_ops
by wrapping folio->page structure in the native page function

Signed-off-by: yahia <yahia.a.abdrabou@gmail.com>
---
 include/linux/page-flags.h | 7 +++++++
 mm/migrate.c               | 5 +++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..6776cf821edd 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1110,6 +1110,7 @@ bool is_free_buddy_page(const struct page *page);
  */
 TESTPAGEFLAG(MovableOps, movable_ops, PF_NO_TAIL);
 SETPAGEFLAG(MovableOps, movable_ops, PF_NO_TAIL);
+FOLIO_TEST_FLAG(MovableOpsIsolated, movable_ops_isolated)
 /*
  * A movable_ops page has this flag set while it is isolated for migration.
  * This flag primarily protects against concurrent migration attempts.
@@ -1139,6 +1140,12 @@ static inline bool page_has_movable_ops(const struct page *page)
 	       (PageOffline(page) || PageZsmalloc(page));
 }
 
+static inline bool folio_has_movable_ops(struct folio *folio)
+{
+	return PageMovableOps(&folio->page) &&
+		(PageOffline(&folio->page) || PageZsmalloc(&folio->page));
+}
+
 static __always_inline int PageAnonExclusive(const struct page *page)
 {
 	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
diff --git a/mm/migrate.c b/mm/migrate.c
index 8a64291ab5b4..817a8c0b84d9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -96,6 +96,11 @@ static const struct movable_operations *page_movable_ops(struct page *page)
 	return NULL;
 }
 
+static const struct movable_operations *folio_movable_ops(struct folio *folio)
+{
+	return page_movable_ops(&folio->page);
+}
+
 /**
  * isolate_movable_ops_page - isolate a movable_ops page for migration
  * @page: The page.
-- 
2.54.0


