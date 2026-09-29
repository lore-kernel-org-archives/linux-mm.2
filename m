Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B414CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41F76B009E; Tue, 29 Sep 2026 17:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19596B009F; Tue, 29 Sep 2026 17:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30446B00A0; Tue, 29 Sep 2026 17:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B49AB6B009E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4BEFA1A062A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:32 +0000 (UTC)
X-FDA: 85268151864.09.AEC2601
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf16.hostedemail.com (Postfix) with ESMTP id 58C98180009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DrDE5Pj2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3WDO8agoKCA00vynB8nv5ut11tyr.p1zyv07A-zzx8npx.14t@flex--nilayvaish.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3WDO8agoKCA00vynB8nv5ut11tyr.p1zyv07A-zzx8npx.14t@flex--nilayvaish.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CeEHtfAYQ81dX38UqxtJ4tymGYkKnxF/72M2lR/Oxw=;
	b=hWv9UJ4qXyDvoGli4B4BqEJu+hSw+V+YxfiwdOluYPYojPMCWkh/eBn/U1zDDDWSYhPUSn
	bWOWQm7iM0UBeNAQ76ydpWDMxSic7pwEc3W9rVRBL1jjTNTcOG1W4/DY10hMlB2N3AlqYv
	F6JmfFhqCy8GatZXzyV3N0yjHqNW+1A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DrDE5Pj2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3WDO8agoKCA00vynB8nv5ut11tyr.p1zyv07A-zzx8npx.14t@flex--nilayvaish.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3WDO8agoKCA00vynB8nv5ut11tyr.p1zyv07A-zzx8npx.14t@flex--nilayvaish.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718810;
	b=TyeOyh3Q2HiL8v43HliGNqrqn/6hMPvHaJR2rfITKtW3I4S1BFxpBVZsJyMSUUZo+vADUD
	VryecF6ix4wa5erjHOqfmfpP7a0yMK+VsHx8pvtY95HAnppDQFncXUx3LsnPhrFStdhG8q
	0HBcYKTZcJ3pRjnd62q0YYiDa4jcmxI=
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30c0d568830so9298510eec.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718809; x=1791323609; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5CeEHtfAYQ81dX38UqxtJ4tymGYkKnxF/72M2lR/Oxw=;
        b=DrDE5Pj2h8vmcQsGkXHRSR5Q9UioFnTiSMpSUJ3CnJUHNcM4rZxuuXuVX409JkfV/g
         7P13MGqVlaWXfw3FYrjL3tpxieLkyY9kMVS0WkCU6rcRRbp/T8TkNqSHszBfzioCccSG
         sef3HcZVF//yyUIG6/8GxNrgLmfX5kX42e6yPcWkSb5NYI/g6qSVq0qhY0SPJnTswqOG
         fA0YHn8zpnkgTbhLODGGdDmL9ZK2rUMEJlfjqBaxpYElzRQD1nCHQech/loUBOkUUIsw
         oISVPQzRCu+1oF4gpr3sYmXmrlg3wEiQf7JVcazBZM/Iv9j0Ii5bzCMy8uZ8Vf+SvuRw
         mSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718809; x=1791323609;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5CeEHtfAYQ81dX38UqxtJ4tymGYkKnxF/72M2lR/Oxw=;
        b=da/xEnYtcOattFCAt3ay4UUj5eqJUPmMdprOXtHGHxsm9Yn4CzjqE82w/aQ0OTGwie
         M6JOMNcG74yYsorpz0+FME5t8jvoOaGPQLATR6w9ROodmBP9IN0p7hDKYFnnpgQvyHCZ
         lQQ/fdSbJ9mLk/wfMLQXbMPqnhbdgSZzthJNJzaEQ9yWQ43RfNIbBJR+Ik03bCinwH5f
         Plsrc7lM1E7iLS4LC80PFM3+fpLcGRdpfpKidr9k3UaBngYHVWN/vcndV/h7Tic/659H
         Ml4MFaNEPdiOOeLD/KJM6OT6la+wNudLskWPAVPb3vpY9eB3/Qx0etM6svEjpfLv6d51
         XH6A==
X-Forwarded-Encrypted: i=1; AKwUvBxEMhJJALuWYy269njk40A5YsiOaT0Is2P8EsDEluWMjUam0fyjxMW0jlnAaXnlIdV/fTcTOo4sMQ==@kvack.org
X-Gm-Message-State: AFq9FYKhBIhH2Srm6fiRWu6Cf6JfaQaF8I73504awDOzLoY8aAPaDL+u
	G/6TIeamnvzI/bvOrCiX0Wu8rnrwJVnr0X4VIv9FlCaI99zq+24Xj2jf2voQQlm3MiZ/B3UToxh
	j4plGGcj8IvZ5OSZKkYHcDA==
X-Received: from dyox34.prod.google.com ([2002:a05:7300:7fa2:b0:339:75cd:ba34])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:e109:b0:342:3bf4:77fe with SMTP id 5a478bee46e88-34c62a54248mr735000eec.11.1790718808576;
 Tue, 29 Sep 2026 14:53:28 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:52:00 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-10-nilayvaish@google.com>
Subject: [PATCH 09/15] mm/migrate, vmscan: use folio_page() for movable_ops helpers
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 58C98180009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: kwn7mnwskgfdww4zow6b8oxd5p84s3hn
X-HE-Tag: 1790718810-852844
X-HE-Meta: U2FsdGVkX1+UPVmZn4HksPYSwQqK/OpU3cSiKSkvnf5RUBA9SXCURSaS8H0rTV0RQpDD+5TPxs7U2wIrQANleNymj0eBKGaB8IvSMAsFiXVkjPGRlNUSoFcHkQ5bTJQEOsQCJfyyaGKtHWprttedoOcxg+TCuhzCXN3X1Z9Uz+QnLDwyYEv1HgXaU0KxqB7KcTh+6X2nC3nQ9bNUSJzy8IIFNA/BcjzSciOAzNpY65dde+j0uGCIq8fcwoYJLv+n/Weu9skEwjkKJYOrc8DBomb7RVDHETDbKXzOabko+eeAg/w2qqui0XVLi0q/JsJwPJ8M/RR1SmEEw/N8m/OKmkCNFfUF0yV/p509Rcn7upoY0XeC2pGLiTDOY3BSOcpRCKAUeSNt5DiX/xWmuEBuKlFyunPPvtgUs8hg0wpECH1by3Jz5bCQ8WR69dZ3dFGmvKnvDhZUTe/1OWfowE+yXbAzfKBMbuIDcpbZv9vIeCcJ8hKD1FAvTclVY6ISq+BSK+g0Z8Gg1wKdHTnXemONeh4xmFHa7PQ2K+2a2meS9jMmtXFaoNuQ6dhCHkTW4GgFDn1UPIRd3rktBsIGu9nQTgJH0eqcNn4v903ovrpsgCuDhMx+K+uBaBetZFAbkYAXNC+p+kmO3Ek4mhVK3TKyJ7+IwObrk8Qku2C/UmT3wdr8dxaeId1dU9MGSHM8JUAEDGdntkU3nML/DRChi/kQ7yynD3GtsLW9DcOY+gX3KHtZJe0kBucasnRmPlffgqsMyDF1ae7YGWAuVvkbw4OIVtfXdKu27j8GJK6VwI8z0PKLV7QA+bN4TVEBYa6QP5rUWuF54xMnSmP210cKGaI6SQFr3yStA+3g0Dlv3t8+kVqGZ1NUkw0QJo0GplCUY5mDwA9mtqWD4Qc5uT0+grz2T9f3qRCAXfLB7GjB0z6FxTwqwE/5eXV8Mx5URDXhEwmd6u8y3gRywYdRsJ4SgR1
 K0WiYBaj
 t3BwM77JFX+OC0vHoDS/9U1M27gQornahoWbCJkmkW2b9CU2z9SlTbW7WB5d4oQ2qDrCQSonubyb2ZGIW0zPaWYjarwlvVqdmXBZCHkRTU6CXgze3+hWasD/oFb5Xbp3pAwWrXfcBFT6tUCF7LwSuwmQP/qf57gwGDwp1g0QYRHIPC5NY37WqiFqHPGcc5uf5/fOcR1W9Ij9pT3kHqj3b4OlSXp1nW82Wl3tQVJO/BZDiM8kEE23h/EYAgE9t0blzF0yteRNj/Vtn6dPGGGviSTl72m2ug+SzZh1hY9W7JR911y+E71/SfFBFGVRVs82HrWaRZFRjC+lXjNl8O5lHzZOB61W+fCbRRu/3hKouUMHsKrbLYAHEhyCZiUN9jnzQK3xArmi9IloKekrnnAW/RdmiHYnPtp4iI7x8PHixwERXPFWTYF2gI9Jk7aLrma6++4r0+VOkCxczZ/pTHpOjIftLgg7Nyqq1W7k7eP/hJqE6ME+Tj+zP0qHgc3axhhqHlIbMtD7MYr4rkOm3oDjFvKYHtkiNlLkL1Z3+MtwPwk+bdk1BI3uzawShlImfecvtCP/AHVk6pQTl84lppQqAMSEZzuw1DT+4t4ukKS1Kn9NvYaBWcEtJYvtz9TA7SVLhjbYDXBp01g+2nroGSxK1aawiug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Replace direct &folio->page, &src->page, and &dst->page uses with
folio_page(..., 0) when calling page_has_movable_ops(),
putback_movable_ops_page(), isolate_movable_ops_page(), and
migrate_movable_ops_page().

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/migrate.c | 20 +++++++++++---------
 mm/vmscan.c  |  2 +-
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f..b027c938d830 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -266,8 +266,8 @@ void putback_movable_pages(struct list_head *l)
 			continue;
 		}
 		list_del(&folio->lru);
-		if (unlikely(page_has_movable_ops(&folio->page))) {
-			putback_movable_ops_page(&folio->page);
+		if (unlikely(page_has_movable_ops(folio_page(folio, 0)))) {
+			putback_movable_ops_page(folio_page(folio, 0));
 		} else {
 			node_stat_mod_folio(folio, NR_ISOLATED_ANON +
 					folio_is_file_lru(folio), -folio_nr_pages(folio));
@@ -282,8 +282,8 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
 	if (folio_test_hugetlb(folio))
 		return folio_isolate_hugetlb(folio, list);
 
-	if (page_has_movable_ops(&folio->page)) {
-		if (!isolate_movable_ops_page(&folio->page,
+	if (page_has_movable_ops(folio_page(folio, 0))) {
+		if (!isolate_movable_ops_page(folio_page(folio, 0),
 					      ISOLATE_UNEVICTABLE))
 			return false;
 	} else {
@@ -1199,7 +1199,8 @@ static void migrate_folio_undo_dst(struct folio *dst, bool locked,
 static void migrate_folio_done(struct folio *src,
 			       enum migrate_reason reason)
 {
-	if (likely(!page_has_movable_ops(&src->page)) && reason != MR_DEMOTION)
+	if (likely(!page_has_movable_ops(folio_page(src, 0))) &&
+	    reason != MR_DEMOTION)
 		mod_node_page_state(folio_pgdat(src), NR_ISOLATED_ANON +
 				    folio_is_file_lru(src), -folio_nr_pages(src));
 
@@ -1308,7 +1309,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		goto out;
 	dst_locked = true;
 
-	if (unlikely(page_has_movable_ops(&src->page))) {
+	if (unlikely(page_has_movable_ops(folio_page(src, 0)))) {
 		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
@@ -1375,8 +1376,9 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
-	if (unlikely(page_has_movable_ops(&src->page))) {
-		rc = migrate_movable_ops_page(&dst->page, &src->page, mode);
+	if (unlikely(page_has_movable_ops(folio_page(src, 0)))) {
+		rc = migrate_movable_ops_page(folio_page(dst, 0),
+					      folio_page(src, 0), mode);
 		if (rc)
 			goto out;
 		goto out_unlock_both;
@@ -1903,7 +1905,7 @@ static int migrate_pages_batch(struct list_head *from,
 			 * If we are holding the last folio reference, the folio
 			 * was freed from under us, so just drop our reference.
 			 */
-			if (likely(!page_has_movable_ops(&folio->page)) &&
+			if (likely(!page_has_movable_ops(folio_page(folio, 0))) &&
 			    folio_ref_count(folio) == 1) {
 				folio_clear_active(folio);
 				folio_clear_unevictable(folio);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 91295070ca33..150ffeec3d47 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1709,7 +1709,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 
 	list_for_each_entry_safe(folio, next, folio_list, lru) {
 		/* TODO: these pages should not even appear in this list. */
-		if (page_has_movable_ops(&folio->page))
+		if (page_has_movable_ops(folio_page(folio, 0)))
 			continue;
 		if (!folio_test_hugetlb(folio) && folio_is_file_lru(folio) &&
 		    !folio_test_dirty(folio) && !folio_test_unevictable(folio)) {
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


