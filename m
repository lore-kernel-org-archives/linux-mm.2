Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30102CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FBAB6B00BF; Wed, 20 May 2026 11:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937DD6B00C0; Wed, 20 May 2026 11:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825F26B00C1; Wed, 20 May 2026 11:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63CCE6B00BF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 219801402CA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:05 +0000 (UTC)
X-FDA: 84788110890.27.5A449FA
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id 17B6C180004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JS7U779I;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LP/AzFvTKoIDyrXjf92uY+voMQvTqKcRBE5XC1e952Y=;
	b=7n8kUFrd8qCJc9F/4Ukqa3EY2hIxOJKQ9uH7lc36udzP2cMn4RfilS6WGHI3T6fhbMIbkU
	i/s7Dm54eiY0rU6pGOKHH2XImcuO6jo3p2+Z9xzW4E0WdsI2tWVTJK7lFoUmy9bC98VM40
	7AgnxqbhNutzRP9CZcnkKrFuPOLYAkY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289263; a=rsa-sha256;
	cv=none;
	b=Nn7nU6a10CZDLZ4EzYJtFEvKb0efxqQLu0j2R9fUh1HD5+Utp7u2nCrndvMxA39/rpvbB6
	O9qZXBqtm/0HZXFADrAjmohDSKjHHafVwJ4Y8MrI1EOTicOT5dlcGb8FqoQN1HMlcMWK5Z
	kMeB/cplLVSeQZ8Q1OXp+gUNsDqXC8M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JS7U779I;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LP/AzFvTKoIDyrXjf92uY+voMQvTqKcRBE5XC1e952Y=; b=JS7U779IELjaE2QGCB0k/b0Vx5
	QPIc1MtZFEDE+nVd1Y87prVHr2R+SVew+KMU3yQIgfGF6fC8om3IjfKmUYrAtLVxupOX/v5UmJ+pA
	kqTdyCcjnhGY1PNprycURjqSXYthGmuy6FHwZlh3T0D3y7JxKBdgzftKggPxMHW8kLaQNI0K9yefB
	phBymDjMe/UEk+hgL5Ht0l+2hDTdBRFVN4PfnWFAqk7oCtRwFD8Ac9+2GS6hW7Vl6NNLr7uRig7wA
	C/HTbM3dMd5kVrrkov6RAXStqcYpSUTgHzchPOPMgn4gdS99Z92m2VNmbzxNdD43lkF/bbxh71muN
	8AqbBAeg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-3tUc;
	Wed, 20 May 2026 11:00:28 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 32/40] mm: debug: prevent infinite recursion in dump_page() with CMA
Date: Wed, 20 May 2026 10:59:38 -0400
Message-ID: <20260520150018.2491267-33-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 17B6C180004
X-Rspamd-Server: rspam04
X-Stat-Signature: 695qdnsyjabektpyna6i51djaihr98yg
X-HE-Tag: 1779289262-234504
X-HE-Meta: U2FsdGVkX1+e80iqzP2uHq/RH8a2tcoeAmkc/+Qbu43u/JaP3S4sOoS2VrIJT5k+S/4IGT6yMIIBJAv9cCuT7tdnCPg8vWu7sskbWMdrVDvPEtqeGoE8POswekQMrp+ggvHn1r65e2YKtZRWfjLfEM6CO6JcM4QoLk6TxDperLjsluAIJD6h2paGhwlOZxHKuxgIqv6WzIImd8KcDavT5cyJz8QGz5UpTfd03zMJQkEv7zgodIXqmFA/4edMrUi2lTSIN0qE4p82WOP1iDd4Ljmmr6Waw5tYYemMRuh/5bmluLOfus3NBYZ1qLtZcXD3iFbhedPl/UMthvMNj2S32p9AL5nfilrdyz3u16meLEODWhYz0XEpCahwuAemWVMf88qN1TBIhlzj7brtKiJySGasCidPfuz3LM4nc2rPxP+hiLO94dwcYRxtC+ZUUE4KdZWRTJWNHx/vkTZt8jpjfkj3SivCgcldmSwnYmjOcRUNR/cYrujrSc0h90UpMaLTHhvGC646I9y1T4skO1HPBSS7J4PBgColJF7Xh8rcoNKyKStSgmnsIUZfsnOkLEXrBha7Y3q0T1B9m4+Ssj2CgA0UqSfusoWSHmaOnrgfatRUZEQQKsO57IZDiXjMVJVxgLUp0ZJIYqf0cIfsPmBeynkN0EXzNfAAYqCLZg7ugmMjnbCu26qJYr7phTLlb+ZowwwZ8R/oaQtnJoOv4KcHgflGf82atS96XFg1f1aOLqVqfmYUF/ZNewiGbBORZ74UMQUsL/Tq601saMzy3bZhmoKwPVmgakx2Pf4RvRj/AevlEnCcnxHZKLh2mc1VrU5tSdx+4xW24OWsBFuq9hFR13Bpmrt6kgGS4ngyJCoebmyIBJwn80h73TKL2Mt7DF0HhUhJOHngCR7s5OyGIAnuBl+aatKO6nnuASapp5WOO5IoSwcWtQuEo9a9PMoDViDoB6rpUzWX6fAFjZCEVrQ
 5NIP7uvB
 QJZGM3MKPJIOaLbw2xPWEvYegco+nBP5Ci4UGDfL9QTJdmnzPf1jLGJh5YPGmf54KMNFaxKGSUeViTs7q3nkM8XnM8X8LJ+T5RjA/f+a7BVcGCwNwCt+ZkUbjuNaoATLYPgAh6P9vFNIa6K7QnhNdlUyeSJMrowVO3mYEDeHgGagowClx1KkqMQ/CtW5Zn+iASCidhQxv4wM6JgzhtRqEdhP9sn7BaxWQu7FvEVDYKYeSL+ljd/+1NihjvfQoF/8LiDvIJWrn/U/VebHPFidGtnV+3vXgPhrfJjsZj67Fh+qWjMH0bxrUj6kdB3pOGf221/mL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dump_page() calls is_migrate_cma_folio() which expands to
get_pfnblock_migratetype(&folio->page, pfn).  That helper resolves
the pageblock via pfn_to_pageblock(), and on !CONFIG_SPARSEMEM
configurations pfn_to_pageblock() reads page_zone(page) to compute
the per-zone pageblock_data offset.

When dump_page() is invoked on a page whose zone is not initialised
(unavailable PFN ranges, very early boot, or a poisoned struct page),
the page_zone() dereference returns garbage and a downstream
VM_BUG_ON_PAGE in dump_page()'s own consistency checks fires.  The
BUG handler then calls dump_page() on the same page, which re-enters
the same code path, hits the same BUG, and recurses until the kernel
runs out of stack.

Guard the is_migrate_cma_folio() call with pfn_valid() and only
resolve page_zone() once that has succeeded; only then run
zone_spans_pfn() before classifying the page.  dump_page() can now
safely report on pages without a meaningful zone, and the "CMA"
suffix is only printed if the page is genuinely in a CMA pageblock.

Found by: dump_page() called from a VM_BUG_ON_PAGE in early boot
hitting a page in an unavailable range, recursing until stack
exhaustion.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/debug.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/mm/debug.c b/mm/debug.c
index d4542d5d202b..e233520b009c 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -73,6 +73,7 @@ static void __dump_folio(const struct folio *folio, const struct page *page,
 {
 	struct address_space *mapping = folio_mapping(folio);
 	int mapcount = atomic_read(&page->_mapcount) + 1;
+	bool cma = false;
 	char *type = "";
 
 	if (page_mapcount_is_type(mapcount))
@@ -112,9 +113,24 @@ static void __dump_folio(const struct folio *folio, const struct page *page,
 	 * "isolate" again in the meantime, but since we are just dumping the
 	 * state for debugging, it should be fine to accept a bit of
 	 * inaccuracy here due to racing.
+	 *
+	 * Guard the is_migrate_cma_folio() call with pfn_valid() and
+	 * zone_spans_pfn(). The macro calls get_pfnblock_migratetype()
+	 * which calls get_pfnblock_flags_word() which has a VM_BUG_ON_PAGE
+	 * for !zone_spans_pfn(). If that fires, dump_page() recurses
+	 * infinitely. Call page_zone() only after pfn_valid() to avoid
+	 * dereferencing uninitialized zone data during early boot.
 	 */
+#ifdef CONFIG_CMA
+	if (pfn_valid(pfn)) {
+		struct zone *zone = page_zone(page);
+
+		if (zone_spans_pfn(zone, pfn))
+			cma = is_migrate_cma_folio(folio, pfn);
+	}
+#endif
 	pr_warn("%sflags: %pGp%s\n", type, &folio->flags,
-		is_migrate_cma_folio(folio, pfn) ? " CMA" : "");
+		cma ? " CMA" : "");
 	if (page_has_type(&folio->page))
 		pr_warn("page_type: %x(%s)\n", folio->page.page_type >> 24,
 				page_type_name(folio->page.page_type));
-- 
2.54.0


