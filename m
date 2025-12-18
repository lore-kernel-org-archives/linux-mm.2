Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC9FBD711CC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 23:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0146B0088; Thu, 18 Dec 2025 18:38:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39DEE6B0089; Thu, 18 Dec 2025 18:38:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D2C6B008A; Thu, 18 Dec 2025 18:38:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1812D6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:38:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3D3A14034B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:38:55 +0000 (UTC)
X-FDA: 84234209430.14.A46B1A1
Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com [209.85.219.66])
	by imf23.hostedemail.com (Postfix) with ESMTP id D955C14000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:38:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZStK79u0;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.66 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766101134; a=rsa-sha256;
	cv=none;
	b=VKz94JFJlxzm81POl7+1E8wIDJv0LWGUDa9hfkQlAkMpiqxkjIjWrHurNbcO+89JlG8+m7
	j9mFoHuPLWqOeIIq4cb/0AOUmnV0Gnpgx/oUJw5HhgEpPXs7S+a8l10vRopcX1ECyhHJQG
	RZE2hZikDqOM7ASLnvWfCqS0On7mWIQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZStK79u0;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.66 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766101133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tvAQKocepJXlQomnlA1RqKzLy9CroMl6hVERKOjnKGA=;
	b=3zcTio4BlokCRn/YIBmrklPW/LJ9pv3Q9srkdVRbENjtJP42CEMPIUVdpsgoLN9HPelP6n
	UkIKDGdPV9QhNttYk7LfJZ7BSZh3zW+U/0WbINjkHTArWiLgWn/vBY6PTBAWmtsmTSXwtN
	V7Y/swBxDUdKBHJObDHyTZgJ2q/iY8I=
Received: by mail-qv1-f66.google.com with SMTP id 6a1803df08f44-88888d80590so15452236d6.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766101130; x=1766705930; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tvAQKocepJXlQomnlA1RqKzLy9CroMl6hVERKOjnKGA=;
        b=ZStK79u0iaPB3UrpmbhcfjwyBfFuHnXKX4J00rg7KD0b7ffEhdO17YsFbtoXaaWwCQ
         zt/JKjXosJmXPuT98jYZsy03+qwZ3959EeiurgsdlsHwQJxqCGQrivry7dsbEV0Qyp5d
         sfI1wOqp6TMNoXHhaGE0VNxkPvsVOAWI/oSdDCRtlc0u+vQk2AZwxXjVX07QllIJiBd7
         QWqoXISH3Gnlxw5Ys3zFy2FhaGtbVZJbxxF5scfapmmPm6Oi9qm4C+kQEkQ9YIUjiZRE
         b78dNZrzOhcomwpZGqUP1ya9iuT+UnB9RtoMUHSOXfW3YfhFcej37k1OGggW48ejQROu
         t7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766101130; x=1766705930;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tvAQKocepJXlQomnlA1RqKzLy9CroMl6hVERKOjnKGA=;
        b=TBRD5r6h8ZCfoOktSpVjh6OzWkakknMdnrSuOC1moBL6h5WFKSJONUcsW+kKsRQsLR
         Yp9i0cd62mjKR+RW133w4OBvQMMO9l0n5HojTdyx9Qs1RFUMljsneRi1KJ1calfcuhqX
         h5UF3km/3OV4IckxiYL2a+buFLEK4+LxKUyIJheKE0LzuJa4vwv732TYmnsjYmsEa6YT
         oM77qRBNx1Ov+BWgis3dPy23Yj+oO0iQS9ouPlZcAsMA5V9DNYImsV/LS1i/tyUskNdv
         ut8VAqy14kOSvwubBjdRKjdzCZK92isZMAH/k/kWFladd85HR+vBZiABEtWeJIutLZnG
         qkoA==
X-Gm-Message-State: AOJu0YxiV8H+rI0cQ/Ye+7SURE4rq3bVaV41YzjSN42IInIcN09N6KbF
	S9J/ElWTsF0pIA6nN/i1up6hq8ZMfdgduyxdF11AlZpG8zThiyM/ep9EhUyxaz+whRi1T2gVWbx
	USCwN
X-Gm-Gg: AY/fxX6t8VEakjvUw9BxLEec46v22Fz1VVrj4ToWcKs1j/TgsvXJdAw3ILaqSq/b1wl
	abS3EA3bKvTj7bC9AAtIB5rGSB2+Tu3NRiJy0c0YdNFZSPlNMnaYaxI0as58L3rCjyySQb0qmSF
	UB7klwWITbD1FnGLEaFwSzS4+iAgHVvLMD3c4P95oXWOBD2QezYeb4Hy0DDwLfCe98uvl4pFWGT
	K9CtB2dASpRqCGtQHbrBc3jbQnmLYa4t54xVE4/1ihq896cBDN+XDy/tbzgYGz3D8nU7mGBO3HP
	mY0QeFkiM7LgqxIC7SSoRzHB0IGsBdWiGY9ih7zDPxgtrGt05MROPYch3lEU61dye3BkHXGPGc2
	8TNWxaSSwjvBLKYpVlevwSuhahOZuPOdIUZ+83MWQU3O2XwTiq9FA1L9yTgjfGqQ8kMkRkCixE1
	6IaU/DtiM96A/9nDzyXcZhtpdowVovWkPqLC0JcC+aaqFaFnPHfYNBnoODQWZXZX6Qag5EsH/QM
	Is=
X-Google-Smtp-Source: AGHT+IHn2tlBreoEmddv+JiS6TqCx02FNrvMqMBmV0I9RTHUdMUlU0kI2fV7B7cgbnpAoWde+7Zrxg==
X-Received: by 2002:a05:6214:5006:b0:888:8460:837d with SMTP id 6a1803df08f44-88d87af38b1mr21387706d6.54.1766101129641;
        Thu, 18 Dec 2025 15:38:49 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d997aef2esm6480556d6.32.2025.12.18.15.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 15:38:49 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	richard.weiyang@gmail.com,
	osalvador@suse.de,
	rientjes@google.com,
	david@redhat.com,
	joshua.hahnjy@gmail.com,
	fvdl@google.com
Subject: [PATCH v6] page_alloc: allow migration of smaller hugepages during contig_alloc
Date: Thu, 18 Dec 2025 18:38:04 -0500
Message-ID: <20251218233804.1395835-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D955C14000B
X-Rspamd-Server: rspam10
X-Stat-Signature: e8qdu7mq8i6az7hibhr6gffwhxoat5i1
X-HE-Tag: 1766101133-534238
X-HE-Meta: U2FsdGVkX1+1UyR1FCYdcDgrkn3AIQB5J4n20bADfGyaIf+qtGOJddQTsMVgba4JOdx5OehAQiYJmjdW79CJjxAB/rpj1aXH6LfhoLhshhonpoD6XDS9kV7atmWBpMWRqkSWbhR7G6hsBrr57MwJksRsOvp8llpIW/Z2/VXXDQ1JYn1Cit4U1lUwT5Lkv6dALMOM4YNl/BAAJr2C+eCb+x9rTaylCgkjx8varmv6q3P0mBe3tJYxY+Hz89qXsMslbjXNLjHTtjjvlniJhgcWQWmLSdmX504q3gWXOvpp0xbCMtWKbme6CVGzyvBPfXmZzoNGuJfZgeAfOvONUyCEsRfY3M4OqcAJ0Fjo4gsxD7m1RuaR4OBInIqNs0jCc8PzauNBKgOHkia8BbskQhqVyIqbTg2efI6SuJBa3W4F+RjiGttxEMrykuph80vZA65MbE8h7crLbRvWj59WMkqx3yZSBvU3f7zdmwPk50owyIJCMj9bLZ63/NKf3zyCCHnrnTP61fiFotWiq8UaPFUTpCoK5Q/9Fh4lp84+qOjFh8VPqH3J/q7hGGu4du5FeUYSBo6Ln2WuEn9DDgRl5C9izD1zjbgfUMUfoO54Na0n80y1ba9Te9wGTb/5RT2gRCVyz+sXkRxcElA/NW8dYYEnjoq+rnTi/t/Xr2+Bn538c97S3GyNz6YLecaoqOrRtI3FV25Uj3y+oTpdlbwY/9FKVZsAhTJD8lIkogPvKdNnXnBeeYlV0jD0obOcaXTFphi+pIKzo9F3FtEgfqNfZoJJQtdNbjx1Pmv+im+R5BnoHe17pYD6LLFvarAuoqaoH8IudEUlw5RGGSDs1Z4cdtjeegNnrtUpu/MEtOtw98trFvAtJ7irVO9sSpqM8Kpp6JuSSgspNwXZ4BRCYYSNsc2NJhpUtmpGPpjChqwJm5shOvkDER3U8WwunamFgNuwioWkYXrtYRMi4tn9duH2s9a
 PHHAmPR+
 23+TXDGj7fm4nE/DATIHJC5vBQAspR48Jwq4qgY+1DvPtJqRTVzJoKvKhF+3ZYItudcsF5976zuWBq0uCHt+cjQFVevFae6t2hDe88aoQkaJkh0HO4haadnDqHNFLjw3Sgqj0sZC2lMUYANCnwxei3H3uUspQ5yUDAML2gF3kj5PJQ/N4mWZsFtjBiMm0+YvBXjK4i5W4I0UfQRf7M1QxYl/FMUGTCEHoC1X55jDOz0KlVFrxVvsQOpD93+XOtNnWKw72648ouPmNPvXG6QsOXnYw8si7zkreSudtd9zNeDH/TD6G58kkmzbJZpeEuMf+cfyGQ9o+6/ApnzaFyBdzywPj10WmCCrFzuCFZPoXyUJByql4Y+2/1pQMVgPvx2hrbgA8RMqvmtiltziVaScpNb26KV6+WfC6z0AAjaqpSqD+H/opFD4Eu0rdyi5T+64IWoK3VQ69KJnybBij1Ao6jdVLmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We presently skip regions with hugepages entirely when trying to do
contiguous page allocation.  This will cause otherwise-movable
2MB HugeTLB pages to be considered unmovable, and makes 1GB gigantic
page allocation less reliable on systems utilizing both.

Commit 4d73ba5fa710 ("mm: page_alloc: skip regions with hugetlbfs pages
when allocating 1G pages") skipped all HugePage containing regions
because it can cause significant delays in 1G allocation (as HugeTLB
migrations may fail for a number of reasons).

Instead, if hugepage migration is enabled, consider regions with
hugepages smaller than the target contiguous allocation request
as valid targets for allocation.

We optimize for the existing behavior by searching for non-hugetlb
regions in a first pass, then retrying the search to include hugetlb
only on failure.  This allows the existing fast-path to remain the
default case with a slow-path fallback to increase reliability.

We only fallback to the slow path if a hugetlb region was detected,
and we do a full re-scan because the zones/blocks may have changed
during the first pass (and it's not worth further complexity).

isolate_migrate_pages_block() has similar hugetlb filter logic, and
the hugetlb code does a migratable check in folio_isolate_hugetlb()
during isolation.  The code servicing the allocation and migration
already supports this exact use case.

To test, allocate a bunch of 2MB HugeTLB pages (in this case 48GB)
and then attempt to allocate some 1G HugeTLB pages (in this case 4GB)
(Scale to your machine's memory capacity).

echo 24576 > .../hugepages-2048kB/nr_hugepages
echo 4 > .../hugepages-1048576kB/nr_hugepages

Prior to this patch, the 1GB page reservation can fail if no contiguous
1GB pages remain.  After this patch, the kernel will try to move 2MB
pages and successfully allocate the 1GB pages (assuming overall
sufficient memory is available). Also tested this while a program had
the 2MB reservations mapped, and the 1GB reservation still succeeds.

folio_alloc_gigantic() is the primary user of alloc_contig_pages(),
other users are debug or init-time allocations and largely unaffected.
- ppc/memtrace is a debugfs interface
- x86/tdx memory allocation occurs once on module-init
- kfence/core happens once on module (late) init
- THP uses it in debug_vm_pgtable_alloc_huge_page at __init time

Suggested-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/linux-mm/6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com/
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 52 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 48 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 822e05f1a964..adf579a0df3e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7083,7 +7083,8 @@ static int __alloc_contig_pages(unsigned long start_pfn,
 }
 
 static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
-				   unsigned long nr_pages)
+				   unsigned long nr_pages, bool skip_hugetlb,
+				   bool *skipped_hugetlb)
 {
 	unsigned long i, end_pfn = start_pfn + nr_pages;
 	struct page *page;
@@ -7099,8 +7100,35 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 		if (PageReserved(page))
 			return false;
 
-		if (PageHuge(page))
-			return false;
+		/*
+		 * Only consider ranges containing hugepages if those pages are
+		 * smaller than the requested contiguous region.  e.g.:
+		 *     Move 2MB pages to free up a 1GB range.
+		 *     Don't move 1GB pages to free up a 2MB range.
+		 *
+		 * This makes contiguous allocation more reliable if multiple
+		 * hugepage sizes are used without causing needless movement.
+		 */
+		if (PageHuge(page)) {
+			unsigned int order;
+
+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
+				return false;
+
+			if (skip_hugetlb) {
+				*skipped_hugetlb = true;
+				return false;
+			}
+
+			page = compound_head(page);
+			order = compound_order(page);
+			if ((order >= MAX_FOLIO_ORDER) ||
+			    (nr_pages <= (1 << order)))
+				return false;
+
+			/* No need to check the pfns for this page */
+			i += (1 << order) - 1;
+		}
 	}
 	return true;
 }
@@ -7143,7 +7171,10 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 	struct zonelist *zonelist;
 	struct zone *zone;
 	struct zoneref *z;
+	bool skip_hugetlb = true;
+	bool skipped_hugetlb = false;
 
+retry:
 	zonelist = node_zonelist(nid, gfp_mask);
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(gfp_mask), nodemask) {
@@ -7151,7 +7182,9 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 
 		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
 		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
-			if (pfn_range_valid_contig(zone, pfn, nr_pages)) {
+			if (pfn_range_valid_contig(zone, pfn, nr_pages,
+						   skip_hugetlb,
+						   &skipped_hugetlb)) {
 				/*
 				 * We release the zone lock here because
 				 * alloc_contig_range() will also lock the zone
@@ -7170,6 +7203,17 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
+	/*
+	 * If we failed, retry the search, but treat regions with HugeTLB pages
+	 * as valid targets.  This retains fast-allocations on first pass
+	 * without trying to migrate HugeTLB pages (which may fail). On the
+	 * second pass, we will try moving HugeTLB pages when those pages are
+	 * smaller than the requested contiguous region size.
+	 */
+	if (skip_hugetlb && skipped_hugetlb) {
+		skip_hugetlb = false;
+		goto retry;
+	}
 	return NULL;
 }
 #endif /* CONFIG_CONTIG_ALLOC */
-- 
2.52.0


