Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28524606D810
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 10:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=goH6zX3k
Received: by kanga.kvack.org (Postfix)
	id 3619A6B05B2; Sat,  7 Nov 2026 05:31:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2876B05B3; Sat,  7 Nov 2026 05:31:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164446B05B4; Sat,  7 Nov 2026 05:31:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC1F56B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 05:31:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AD1AA3D82
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:31:17 +0000 (UTC)
X-FDA: 85407955794.26.C18D49E
Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	by imf06.hostedemail.com (Postfix) with ESMTP id 934DE180002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:31:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=goH6zX3k;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794047475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpCUv8SpWlf4Vxz+l8m++vebqQBTHUXPNB3+3E0LTf0=;
	b=DQ9EIUEp/V5iDlANFeacnFCUD9MznWv2M9vD6oBtdUG72SKY9qpolMxIYlJ9eViR+sbpZz
	tt8v1j0Q7hPJVGFziWBfORJwoVY5crIGoiiSkIdMpmun/PKBD+UN/rw7oMV67Oh5jXw9S4
	aWmhEvRzX7FXFwFuO64He4u27chqsuk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=goH6zX3k;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794047475;
	b=YURbzLKZIYM4cyQqxib9ERRhTCv8sAKZu0plq8TgZXQR5kSPZMTwuSu8tccaylDpBZAU7w
	i7MAv0IFX+8CtRBQmtgv5LM3auay6IWCx+HMuG5/ftMQRtJY3ro0yXINxBN9/Kwpd5gf7n
	ti7gnfKWdTTMKAffOSmjQKS37X2E75o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=M2NYD96+5Wc5vXUg80X/Ev4VTK5SZphvkdZaEd0yv3E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794047474; v=1; x=1794652274;
 b=goH6zX3kJULkGcSUTnu3iKuMNYYxmeK0jgaWApvpqaS7x10Lk93m6/LAmu+iGsuRwtQxgPVR
 mFIVBKn10uh1X5nrNqtEY0xlApw4fX6uXZYl2wlC7r34ktrGHmtlWVMDl73XfmS4ZpSkDNhQot6
 X6j/ha0BlJUM9KPInURyp70g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f6c06557ed320a8a;
	Sat, 07 Nov 2026 10:31:14 +0000
X-Mizu-Trace-ID: f6c06557ed320a8a
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/3] mm: gup: allow long-term pins of CMA-allocated HugeTLB folios
Date: Sat,  7 Nov 2026 18:30:46 +0800
Message-ID: <586d6c53ab7e4c64d6e89ad3cf0cf7e07dabbfaf.1794046188.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1794046188.git.zhengqi.arch@bytedance.com>
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 934DE180002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kgqa61wymxa1r3boaopu5wi413urppxq
X-HE-Tag: 1794047475-505125
X-HE-Meta: U2FsdGVkX19FgvnmoHQf0xjIP30pq9jgY8DsMhZRRlZ2LxsxzVf5El5VehhfF1ssZ4iWbhz3JMiaDwsR331+ay1qU2HW9moWRpmfz4vajjveEgFW/niVnQHviWFBr0oogr1SNtQzlb7qds3yWjFCVu26lmzqm/D7t0QYWOr+l4VubDHIdAqukI7gNgQK4hFpnxt2CUVpcs5BsgGUUAOlTHcUpL2YSWujzIJunGcZCJwlrKW1tCC4c90d/J23NVbpeToNAbn6TmNZNE52cAJ+wpGTVu0UHz/VzDqa+HkOD+m1ERajyqsBjc33G4S/vyg8dvQj1AAtf4zGmTQymRawwKdcxFFHMLCqCdcMDOLj0P+jPnpLuDZl7pf6AmpC3VSPzwt3oqi/brsJoBCHelsUxmwmL8VVdxOLl/iHwviS3WupJOwiFDbOpKii0gt9bfNwUGJ2dVuOxxM3l7CEyXxFE2ehCf4VKJNMv/t7vPPB3DIdVBbDGtIwOHyrmsy57sA7H9jM3lp00Gq3yEmSadU7mjkNxy/0F8QCv8M/LjP8Km2Ii4bcJyHbm2WQW9WsCjD2jBwRTW/r6uJ9Q+0WLva+v5VyNYwOK2Bew8tTMDSp5+cJ345sMSnE3IgL8XcPkyI7Qez6QLOKBw/B4Ryb8rYiRrcNPOkoB8HQ9kflOqMuxXr1313/pb+2V6g/v7oTIrQ2nMk2v6rB9vGAXHVP8Tzox/Wz/S7cdSQardYrsAvNVk7wlJ7FDdCNtfP9ODoXM+u/plgJa6KHNZmWYlLkC2ad8J0is4bWxmkf2jFxEZ3uZhMOdtKKs5GVvzojAtSvRvnvOU9vCenC5+0ve8Z6YB7Ob7dUm6NPIzIiEP37vR3LqqAUXB7x8Qisp9AO11yjYS7QndhEX5wEIuzwHaftPBa57WaNTf43H5fyW7y6tRLC5BhBpZc2mg8w14IyCtTlYP5cRaNztOmSxVDpxTSwb1a
 xo55KzOi
 qpvgYcRNfJtTL74yXa8R9sFHYAS4voG+QYKz22jqZlyEtdjkelFiEL4O8/YU00QHmMGwsKkJwUM+22r2rtl53RKgPqq1ijXGDzh6Gt1RRI6JgPxD/EUe9eDfHtonW9p2jEHnzNtC7Mfigl+fDvXLaBIgGSP0LujISq30RWOn2bVgxa8BCeEMmy6NBRVmCPM/7+MC/2pGaqrur4rrqzLUb4Qpjt5fblNIH4+UU9TwW+HxLBGUd2jmf9cHsDhdYKauAQZOg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
unpinnable, causing unnecessary migration or pinning failures.

These folios already own their CMA bitmap ranges, and memory blocks
overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
HPG_cma to be pinned directly, including in ZONE_MOVABLE.

Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Cc: stable@vger.kernel.org
Suggested-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 include/linux/mm.h | 29 +----------------------------
 mm/gup.c           | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2d0b8a4c9974f..75dd40265d3f4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2975,35 +2975,8 @@ static inline bool is_zero_folio(const struct folio *folio)
 	return is_zero_page(&folio->page);
 }
 
-/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
 #ifdef CONFIG_MIGRATION
-static inline bool folio_is_longterm_pinnable(struct folio *folio)
-{
-#ifdef CONFIG_CMA
-	int mt = folio_migratetype(folio);
-
-	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
-		return false;
-#endif
-	/* The zero page can be "pinned" but gets special handling. */
-	if (is_zero_folio(folio))
-		return true;
-
-	/* Coherent device memory must always allow eviction. */
-	if (folio_is_device_coherent(folio))
-		return false;
-
-	/*
-	 * Filesystems can only tolerate transient delays to truncate and
-	 * hole-punch operations
-	 */
-	if (folio_is_fsdax(folio))
-		return false;
-
-	/* Otherwise, non-movable zone folios can be pinned. */
-	return !folio_is_zone_movable(folio);
-
-}
+bool folio_is_longterm_pinnable(struct folio *folio);
 #else
 static inline bool folio_is_longterm_pinnable(struct folio *folio)
 {
diff --git a/mm/gup.c b/mm/gup.c
index 2b405cce2ca5c..f41701c603500 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2216,6 +2216,37 @@ struct page *get_dump_page(unsigned long addr, int *locked)
 
 #ifdef CONFIG_MIGRATION
 
+bool folio_is_longterm_pinnable(struct folio *folio)
+{
+#ifdef CONFIG_CMA
+	int mt = folio_migratetype(folio);
+
+	/* These HugeTLB folios own the CMA memory, so they can be long-term pinned. */
+	if (folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio))
+		return true;
+
+	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
+		return false;
+#endif
+	/* The zero page can be "pinned" but gets special handling. */
+	if (is_zero_folio(folio))
+		return true;
+
+	/* Coherent device memory must always allow eviction. */
+	if (folio_is_device_coherent(folio))
+		return false;
+
+	/*
+	 * Filesystems can only tolerate transient delays to truncate and
+	 * hole-punch operations
+	 */
+	if (folio_is_fsdax(folio))
+		return false;
+
+	/* Otherwise, non-movable zone folios can be pinned. */
+	return !folio_is_zone_movable(folio);
+}
+
 /*
  * An array of either pages or folios ("pofs"). Although it may seem tempting to
  * avoid this complication, by simply interpreting a list of folios as a list of
-- 
2.54.0


