Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6014AC53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8CDF6B00A4; Sun, 26 Jul 2026 18:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64796B00A5; Sun, 26 Jul 2026 18:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7ACB6B00A6; Sun, 26 Jul 2026 18:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACCB26B00A4
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FEFE1205D3
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:45 +0000 (UTC)
X-FDA: 85032356010.28.C741962
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7DE4BC000D
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bIRaIN95;
	spf=pass (imf28.hostedemail.com: domain of 37YhmaggKCPIdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=37YhmaggKCPIdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ef2S6P5pckpK+OADyKyUvRFbv0ogGYPuukLQrnlpMOg=;
	b=khltBUHlE6v0/Do75QI+lS4OzZkrpK0H44DN83GEzb8Rxt/WACswdQbWFhsFVYje78YZSw
	ulG+HwQXSc6bLNuZcvbiw8SVaVqR3rINsPTDsgVfcgQE2JK2Sl5wu287Zovn0wpZNOzX9C
	iAv/VUQWgevbVjOV1YpF+orrcRbOU0A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bIRaIN95;
	spf=pass (imf28.hostedemail.com: domain of 37YhmaggKCPIdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=37YhmaggKCPIdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104623;
	b=XTUIG4HvmVryOqa06vpGZ7xqzv/s7lBz97Qe2pt9TwDQv8uG61VADUnsGijgwF3gmGnDDs
	x0fEwnjMwyNf1zrE911BZrwqDFqzJlvpSmdjXaqV7CeTZf3xaxcFUJ/cK55Hxi/kT8cN2A
	BCWZsqon++HuOFOe5ehDjxo6nJE0UIg=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c15f0aea084so144895266b.0
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104622; x=1785709422; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ef2S6P5pckpK+OADyKyUvRFbv0ogGYPuukLQrnlpMOg=;
        b=bIRaIN95KfD/iU6t9eYB6J1OTsxLjXu08PM8mAf5EGu7LE0p9aOXUXsfgeEXS+vj5O
         XU+j6KNqHPZc2FqLDLgIfVrUfcvB1T6zzIzQjloHQqn4vLxoTPS4S/6UEoI5K+g8s7QX
         TpSuxwqCn08YKUsfepg1vkbgDBKbJ7nSi4cPSHwgsQq976cR6wN3ENMqzM60UcG/6PAJ
         YaStyyIof7lfOY9dhEsl/JvS9fjJu9rQJ6V8VvH+SgS30Tx4d3reb6j1NL8xKEYhq+Q3
         MqN5lOrgB0YZTWU8vURy74OFjZ6V9SXeKYZSVG0KWEjSwwBxvO+6fT3wK3PKZrpocVxu
         0tPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104622; x=1785709422;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ef2S6P5pckpK+OADyKyUvRFbv0ogGYPuukLQrnlpMOg=;
        b=M1kP7Cub11zRqg5jtAhDjFmxbnJ3US/smS0560B1EqTnwA1u9KOEUE2aFTtksEaw47
         t4Vjg9Z5LlabIJS5wrpWyNLcFMAcviG5xhOcbEyfF8K0FpR92oA3/v5TSHkDErjnKZys
         qCInNJLuS2y7mXpxi/h3G2OVY0M22IVwfiE77bAVCXNR4tFouTmHI1vAhXojHQzKM4JU
         /hAuQDB4TRVpvhTExSX43ftvEbyWET9ti7dSItFqD+8D/bLJHyrQ5uYBLn667gHptiRO
         VM38XSwfrz/pt9olIsK9xNkUkghhGVV7og+yq4LTpN1C8w9WfeDff0FgU3qH4PoYDYX8
         hR3Q==
X-Gm-Message-State: AOJu0YzdWn3hnhy/afKkT/ovDx59AGZ5OtoTtY1Y+qOQJLUxtuSTQDZS
	2trFjdUrlyksGVgI0T6bwQsoVtK8UVIBaku2nA7cy5atFchDODK1eYNxBWq1VA0yyuAy7awgjrO
	UdIEU93CU6k1LMA==
X-Received: from edwp25.prod.google.com ([2002:a05:6402:459:b0:69c:5fcd:d551])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:21c1:b0:69e:648e:2582 with SMTP id 4fb4d7f45d1cf-69fc11697f8mr2129720a12.20.1785104621946;
 Sun, 26 Jul 2026 15:23:41 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:48 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-15-6f5729aa9832@google.com>
Subject: [PATCH v3 15/26] mm/page_alloc: add support for freetypes with no freelist
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 7DE4BC000D
X-Rspam-User: 
X-Stat-Signature: c4w3r64go644qbyns9p5bk6wko9be17q
X-Rspamd-Server: rspam04
X-HE-Tag: 1785104623-724058
X-HE-Meta: U2FsdGVkX18bxJixdzQPY1zsxBBKn6Ygrc6Q8YMzS6Q1b30NaXUHGDubI3rBI9J2lWLu54mfDNoqFXeW0U9edYOaDbAKbZyLVF0SsVqiXhSi4BpLsheajQBc6+mrEDimulFKYUKqcaJjtFrAtohgf55Sr4aVmiPFvAT90R1W0/lPB3vutIn4VHAmB7OWnrP2AplTtFUVVKHXdbDqdU6fQ3Sr65LXUxaINjC0OvUYGiHDICUiHFL/DZDSCu91JiABaPLZagWUb5m5XmMfV4zuJhX62HBRuPfxbMlk5dsP2MORtn93tSP2h2gIr1JpJ9bqXjig9HOGU/MaeOGmla0M2TG6Ox4t5P2XbOGiiCRGsdAVu7Coz/FY4cjw55hS/ZJ9E2Acwh90Ctl+GlDnt0GV7X7aHxT33anrmjSBWQolzNeWfeVkghi5FeBUCcc9KaJSpaCKnpbgWU8QCMd75vRYNA/dt7jdfJCrLIAW5xjxHfU3dA79nJBa8oZhFU1WTP5ePuh8TjO46tTVNZcyMyJGD/kX4oyqQ+O2AFfxOdVIb/ZH+zDdebxos1VBMZF1DDa7RRpmGuJtRrNYXU/uUe0sR3dfKUMamy0GgPgCISmjPlZoi91VUwywqWKwCDcU2C9Q/R9P9N+rtL7Wzi6DTbaOIMZBrInDwYEV4HYOX4D42C/0t0mS1tjTxTk8jUBaNav4bjaJ9EsnbEC/76Z2MIO7XcV4CsdDMKl9f4JFzCejIdmBvwWe13RaN3eoVwOgsYVn+3X8uW4EgLZjAB/naDSRhJl+lDYm8tRxc8Qrr/pAMFE+NKa4fqtlOFTTD0xddBSeQglnDB1j5g47Kzuj5uwVjN61icVkP85kdnQ6kV5rCQowOZPa5wLRF0FSjHamqDfci0fJ2X993cHrkgORUgkn/zxpWZfc+BlT3w+YjPFVx7txkGvXx+tfg4hsMNxI8k07dVjqXnNkoAPqboEBeHY
 270im6Tw
 ywh59+m0lruC5cUA++gszdIzsEQu08XXfYgsF1IFbJtpmq1vVQEsElVjew7xjP5MaRTN8D+oBV2FpgKw/CvQk/kwax3woG5MU1lN3s58JLGUzbpD51IbJ80KLj4kGNK0ZAESj9jlMRZIuEBE8y7Q8WBT08gTjGhi+suML7p8Tmk8tVYoam5ionkfBbEO5v8s4habGStXlcaienXByxLKQzNfBHYDjJS1EIEgjNDgrcfbdooSix1UrJ3dlPClTWlMWt7Cs92Lif7VlTHRk4XIepIKX5GvykjiJ75ecWF7+1tv2TGAMJ28WSQ3AZo5p4LWLNdrRHceWu2FosQ9YVPy2RDYasFTuG+91Ey+pTixaLI1WAtVASc0ZdAcBo5PbMszn1Fies9buPux22UxYZDA7UNnSKB2yPbhtkvj0gjU8j8ovQmFJN//b+OPl8xbUPxNj13qHCQfIPHX9kdqInUmjk+P/Pz16l59mJFbZmLTqdzAxOYq0/9AgIy6bWKqKMMt6VTX29j8BFuUVytUp3+7j9UL+5/fv5GaBzcV5BY9YjDyvN7ZsWePhtTKAYNDCCb7t/TWs47wa9El0AAtqaie9Z85n0rUB7P/pKHEZAFygV/8cweDBwzMe82wHER7T/mI0TcDxTZ6DswlTYa0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Freetypes are currently just a wrapper for migratetypes, but in a later
patch they will gain flags. The theoretically possible space of
freetypes will thus grow, but many freetypes will not actually be used
in practice.

To avoid bloating structures that contain arrays of freelists, mark
freetype_idx() as possibly returning -1, and add handling of this case
to code paths that will look up freelists by freetype (unless those
paths "know" that they're operating on a freetype that has a
valid freetype_idx).

It never actually returns -1 yet, this is just introduced as a separate
patch to make review easier.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/freetype.h |  3 ++-
 mm/page_alloc.c          | 13 +++++++++++--
 mm/page_isolation.c      |  6 ++++++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/freetype.h b/include/linux/freetype.h
index b16dcd58e184c..3b0d44023b6a1 100644
--- a/include/linux/freetype.h
+++ b/include/linux/freetype.h
@@ -73,7 +73,8 @@ typedef struct {
 } freetype_t;
 
 /*
- * Return a dense linear index for freetypes.
+ * Return a dense linear index for freetypes that have lists in the free area.
+ * Return -1 for other freetypes.
  */
 static inline int freetype_idx(freetype_t freetype)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 60aedd0e78b54..4965019dc2286 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1963,6 +1963,9 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	struct free_area *area;
 	struct page *page;
 
+	if (freetype_idx(freetype) < 0)
+		return NULL;
+
 	/* Find a page of the appropriate size in the preferred list */
 	for (current_order = order; current_order < NR_PAGE_ORDERS; ++current_order) {
 		enum migratetype migratetype = free_to_migratetype(freetype);
@@ -2406,6 +2409,9 @@ find_suitable_fallback(struct free_area *area, unsigned int order,
 		 */
 		freetype_t fallback_ft = freetype_with_migrate(freetype, fallback_mt);
 
+		if (freetype_idx(fallback_ft) < 0)
+			continue;
+
 		if (!free_area_empty(area, fallback_ft)) {
 			if (ft_out)
 				*ft_out = fallback_ft;
@@ -3642,6 +3648,8 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 						bool force)
 {
+	freetype_t ft_high = freetype_with_migrate(ac->freetype,
+					MIGRATE_HIGHATOMIC);
 	struct zonelist *zonelist = ac->zonelist;
 	struct zoneref *z;
 	struct zone *zone;
@@ -3649,6 +3657,9 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 	int order;
 	int ret;
 
+	if (freetype_idx(ft_high) < 0)
+		return false;
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, ac->highest_zoneidx,
 								ac->nodemask) {
 		/*
@@ -3662,8 +3673,6 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 		guard(spinlock_irqsave)(&zone->lock);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
-			freetype_t ft_high = freetype_with_migrate(ac->freetype,
-							MIGRATE_HIGHATOMIC);
 			unsigned long size;
 
 			page = get_page_from_free_area(area, ft_high);
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index f81186431d3c3..e6bd227fbf1db 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -176,6 +176,7 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 	struct zone *zone = page_zone(page);
 	struct page *unmovable;
 	unsigned long check_unmovable_start, check_unmovable_end;
+	freetype_t ft_isolate;
 
 	if (PageUnaccepted(page))
 		accept_page(page);
@@ -189,6 +190,11 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 		if (is_migrate_isolate_page(page))
 			return -EBUSY;
 
+		/* Do not isolate unsupported freetypes. */
+		ft_isolate = freetype_with_migrate(get_pageblock_freetype(page), MIGRATE_ISOLATE);
+		if (freetype_idx(ft_isolate) < 0)
+			return -EINVAL;
+
 		/*
 		 * FIXME: Now, memory hotplug doesn't call shrink_slab() by
 		 * itself. We just check MOVABLE pages.

-- 
2.54.0


