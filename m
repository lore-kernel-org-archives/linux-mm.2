Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE5A4FD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723A76B00D3; Wed, 25 Feb 2026 11:34:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2F66B00D4; Wed, 25 Feb 2026 11:34:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E28B6B00D5; Wed, 25 Feb 2026 11:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 44D706B00D3
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:59 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 060E01C655
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:59 +0000 (UTC)
X-FDA: 84483528318.04.46EFE16
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id E0D02140014
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="AOGE/fmC";
	spf=pass (imf23.hostedemail.com: domain of 3rySfaQgKCMgxoqy0o1pu22uzs.q20zw18B-00y9oqy.25u@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3rySfaQgKCMgxoqy0o1pu22uzs.q20zw18B-00y9oqy.25u@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q51ijtBTrIsvjhX+iA1BrCEddMf5G3kZ1UUUAgabwFs=;
	b=8kZzG89r/iKrXC5n2eZSqq42TlxWeD3ciKsfbH9Ze3dAUbCKFP5+i4PAwF3JqHu+DwTQG7
	XOQIyC8P2nRARwGt/5HdkW3LyIfugPcQeyeTB8FFW95cdtdkMAAoz+p/I9cREkTzimjy84
	5o3FHqOuK2nPPR3yTaO487OM3ZgNU0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037297; a=rsa-sha256;
	cv=none;
	b=O5Yft1HpTF39n7o8YLXclRYx4Q2EGMbb6aZJVM/0ALCzi9bgrNG7IgXrIfj+NyqYjCP5Bt
	DVTtvc+pNv5bWhtDRjADazTD1ALjniM/SLaI8qDbfZ0Y3PqpVADT1+cMnNidzEwVggqX2n
	kA4WWPQ1e7080vE+naDAGTgtu1CBTT4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="AOGE/fmC";
	spf=pass (imf23.hostedemail.com: domain of 3rySfaQgKCMgxoqy0o1pu22uzs.q20zw18B-00y9oqy.25u@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3rySfaQgKCMgxoqy0o1pu22uzs.q20zw18B-00y9oqy.25u@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-65f75964cd2so1311610a12.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037295; x=1772642095; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q51ijtBTrIsvjhX+iA1BrCEddMf5G3kZ1UUUAgabwFs=;
        b=AOGE/fmCKfk4X11XVgTHlvPtgp1/GStOa9FpDKMo6/2FGfTiFMKHm22FZc1PYUt/44
         bXFoyGNIZtJuzN6oQE2Cac3vuYILvdSPtCGfaFPh7UtKcM2wGke4vIglp73+BTp1s+cl
         fnQg0/6BtBos1hlaOTzH4PbiUea3Z3u+Qu8O6LucvMpluEewsV4N5YwsiIF9cHGS/OXn
         3b+t37r9zeb7P5csfSbbDCUmEO9EqCf6gfp/0ji2SCgNtkkQx1nnMI0aghnRrDpDOd/o
         BenuV5z9bl2+KRGmrM9XNSUiiGdlUP1+V93bbi74QzIyvCeY3z5w+hDQnQaWwFwZvhbg
         dd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037295; x=1772642095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q51ijtBTrIsvjhX+iA1BrCEddMf5G3kZ1UUUAgabwFs=;
        b=hcQJ2TQ2XOAhWjVYoXWRvbtID0tDwtVL8Hf5TaWYnxITo8+/V0aw6njtMfqMasglal
         3OgVYtKqwGge9AVzds5upGCSfPhVRRxDWuV9ZaW0BnSR2DBl2nd6r0VeqESAGCRqM17x
         K1w/3i57ijYYiehkmcxAtpozjb7JFuP6Qi3vzP9KiSiQwdva2CXYJ2qiRkcr/XIAB/MI
         mVN7LnDbsgsSG1n9LSXO2SoLLyIVUnED2XmZXG5zAHZnukwVqA3QfXi1by1r0HN9/eUI
         ho1AMSg9Hf4b6NQIHnqCSk3pRzXVV38BQALW9opaOMD5qn0/5GfJx+sFR7933iJAgo5/
         tBNw==
X-Gm-Message-State: AOJu0Yw3EpZODI7ZJhtGl39GXd+ceFte/SUKFhL2HdjNPfwZn2Wrvq68
	A+kdo00e26U/KAbOip7sBDXpDGGwiPDfsICCrGVuQL8/SXPwhfB+QYtke8EWQY8mYCGrepTgheJ
	pR0ppfjPizEsz+A==
X-Received: from edsj15.prod.google.com ([2002:a50:ed0f:0:b0:64b:8031:e69a])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:848:b0:658:bf9f:75be with SMTP id 4fb4d7f45d1cf-65f7bb13cd0mr2490510a12.16.1772037295237;
 Wed, 25 Feb 2026 08:34:55 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:39 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-14-e8808a03cd66@google.com>
Subject: [PATCH RFC 14/19] mm/page_alloc: separate pcplists by freetype flags
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: E0D02140014
X-Stat-Signature: re18x3ufjxgxfnz6x1ahuthz91fbzw6s
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772037296-194337
X-HE-Meta: U2FsdGVkX1+QswaLq/7E+XKKNYw9o2Ds/oteSFaW+Zjq3S/CT4cdSrRU4aGD8XolcXdzxMfhsKG+Kbz/ZCYRYc+sYfyCuFIkaZqV9qoYZ9iSmbCkcIudUpScBKRoNN/cYFAXS+93LSvDz1lY18UniY7R9u50PT9ICS2LUeYma2oZty/0hPzk+8bxFCiERHum8Jzq09eWsmucsUrg5a+WzmHtyQb6VGiDr1w42YGOup/RYVkEkkXPIa/oaQWspZXx1wnStX+0Jp0Yp0abPH8W0uimH3QVtIhk7ibblUICyD6eD4jJ7dSKcNJJ63mA9ecaJGuzxOdQtiPKIKwzATdwnu+gFZiWKSN5h3M0tzK33/Zxz98o7zJY8lk9VdRX9ybKjOMijGYr9VdUv9gW4zZ5GpwS/EiJaDS/EgcZBBDaG0jY3LTchRZ4o9iRJDKqm63epsr64ygwA6e6qb3jxVfeL/uzo76mZpc3AopOqvDBjjfcKkfui4bx7hX5d0kWZPjER9heXZkGO/BX8noPeZUr1OibCSMaQjaiL3gdPffbT2qnHP2BfEvwyN2eIIMoiuM8VF1BIKshgC+SM9WqVbFqmtDM56J28a3UkPWotZUtW4kzx+rYg/ZnIiy+psXcaTTEmhmQdcOUTXd3NkBU/8XTg5pPflied+0YPbfI/BbS7m/BSDAqn65H6isYvwniZpKjXFPzJwBaRpvSfu1pfV+cBnu5sSowNTttdFbzV+zWDcPdAaqssxgtQZ3K1RByCWMfg+Pa0maR5kvON72m4K0iURPqCiPgcD8MGBIoCt2hjM8A/00cb6cez2tycTuD50FfgUJgl/CXY8tUC+Yl/mQUxOLwAV9m+kRY88ujr48ywn8M8i792IYHNB6ARgWNjOanTJqjrTw8sd2M8BPQegy49ZJ6zKEK5P82Fa1NVLer9CLh3uekNyBOuZ5ia10ec/LcMhRDN4j7cB1r5XxsgUd
 Zcq82usc
 VSX4FmJyy1aixi3SIXHlhA22Rfl2Zg4c+Eq1HWTJ/6hL3E+qxRNAepcL5ZUMl+gk+9KVGqJcbBOH7+5dQ9V5J/kOb6Tm7L5jmgt/g9yTM20hrFwJH+TYT94uupy0q/MIsEe//yRV2ZkaUoh/AWYVxo6HA7Tc3BpdseRHVsFMo9Dc4FM2kCYdYtZYnD7i5jzH+LWXpUq1257TZL6NrJQQdBT8YH2c2UaGk4bXv1A2qgs1n4DEtMW/77r88DThutB6yO0YF9EsBrzoUMo5XTSKaYY1KF6lOgdGpoV+AVAxb4ruIPRgM5lXYYzCcznv8XaJimSajaq/Xky1NjjHrHX0SMXWBYq0LvVLWHd3ZBX0tib8ighJdt2nKcJIptZTIITVKXeZyBxMMAm+XqR0ACZpHa3JHI/HypMmev7FKETX4v/4iN1rcnBnXBQPpE4XivinbE5JStGt8KqjjruC9jyj6jVPiU6dPDdYoO3IviWId3YEQZjzZgqW0kHQeBqQuPTFs7NMCBPG9Eh18t6NmDEioWx+PYnWc5YmU4V9TsqSTdT5TB7G0FTJkVcQbkPOOlv/k9e1rAhSC+oruyFbTdbfqtOWu5Fn3ZuGB8VOiCgyH+g0qeig2Kk/l5y8K62df7AbWhBwyryg8uYbHs0grPqaGJrTBOKRxxivq2nKbY1xaUjPmvaCs3GSCHEmZ9swIollUlzSl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The normal freelists are already separated by this flag, so now update
the pcplists accordingly. This follows the most "obvious" design where
__GFP_UNMAPPED is supported at arbitrary orders.

If necessary, it would be possible to avoid the proliferation of
pcplists by restricting orders that can be allocated from them with this
FREETYPE_UNMAPPED.

On the other hand, there's currently no usecase for movable/reclaimable
unmapped memory, and constraining the migratetype doesn't have any
tricky plumbing implications. So, take advantage of that and assume that
FREETYPE_UNMAPPED implies MIGRATE_UNMOVABLE.

Overall, this just takes the existing space of pindices and tacks
another bank on the end. For !THP this is just 4 more lists, with THP
there is a single additional list for hugepages.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/mmzone.h | 11 ++++++++++-
 mm/page_alloc.c        | 44 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 301328cbb8449..fc242b4090441 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -692,8 +692,17 @@ enum zone_watermarks {
 #else
 #define NR_PCP_THP 0
 #endif
+/*
+ * FREETYPE_UNMAPPED can currently only be used with MIGRATE_UNMOVABLE, no for
+ * those there's no need to encode the migratetype in the pindex.
+ */
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+#define NR_UNMAPPED_PCP_LISTS (PAGE_ALLOC_COSTLY_ORDER + 1 + !!NR_PCP_THP)
+#else
+#define NR_UNMAPPED_PCP_LISTS 0
+#endif
 #define NR_LOWORDER_PCP_LISTS (MIGRATE_PCPTYPES * (PAGE_ALLOC_COSTLY_ORDER + 1))
-#define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP)
+#define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP + NR_UNMAPPED_PCP_LISTS)
 
 /*
  * Flags used in pcp->flags field.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fa12fff2182c7..14098474afd07 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -729,18 +729,30 @@ static void bad_page(struct page *page, const char *reason)
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
-static inline unsigned int order_to_pindex(int migratetype, int order)
+static inline unsigned int order_to_pindex(freetype_t freetype, int order)
 {
+	int migratetype = free_to_migratetype(freetype);
+
+	VM_BUG_ON(migratetype >= MIGRATE_PCPTYPES);
+	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER &&
+		(!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) || order != HPAGE_PMD_ORDER));
+
+	/* FREETYPE_UNMAPPED currently always means MIGRATE_UNMOVABLE. */
+	if (freetype_flags(freetype) & FREETYPE_UNMAPPED) {
+		int order_offset = order;
+
+		VM_BUG_ON(migratetype != MIGRATE_UNMOVABLE);
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
+			order_offset = PAGE_ALLOC_COSTLY_ORDER + 1;
+
+		return NR_LOWORDER_PCP_LISTS + NR_PCP_THP + order_offset;
+	}
+
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		bool movable = migratetype == MIGRATE_MOVABLE;
 
-		if (order > PAGE_ALLOC_COSTLY_ORDER) {
-			VM_BUG_ON(order != HPAGE_PMD_ORDER);
-
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
 			return NR_LOWORDER_PCP_LISTS + movable;
-		}
-	} else {
-		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
@@ -748,8 +760,18 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
 
 static inline int pindex_to_order(unsigned int pindex)
 {
-	int order = pindex / MIGRATE_PCPTYPES;
+	unsigned int unmapped_base = NR_LOWORDER_PCP_LISTS + NR_PCP_THP;
+	int order;
 
+	if (pindex >= unmapped_base) {
+		order = pindex - unmapped_base;
+		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		    order > PAGE_ALLOC_COSTLY_ORDER)
+			return HPAGE_PMD_ORDER;
+		return order;
+	}
+
+	order = pindex / MIGRATE_PCPTYPES;
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (pindex >= NR_LOWORDER_PCP_LISTS)
 			order = HPAGE_PMD_ORDER;
@@ -2970,7 +2992,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 	 */
 	pcp->alloc_factor >>= 1;
 	__count_vm_events(PGFREE, 1 << order);
-	pindex = order_to_pindex(free_to_migratetype(freetype), order);
+	pindex = order_to_pindex(freetype, order);
 	list_add(&page->pcp_list, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
 
@@ -3490,7 +3512,7 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 * frees.
 	 */
 	pcp->free_count >>= 1;
-	list = &pcp->lists[order_to_pindex(free_to_migratetype(freetype), order)];
+	list = &pcp->lists[order_to_pindex(freetype, order)];
 	page = __rmqueue_pcplist(zone, order, freetype, alloc_flags, pcp, list);
 	pcp_spin_unlock(pcp, UP_flags);
 	if (page) {
@@ -5275,7 +5297,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed;
 
 	/* Attempt the batch allocation */
-	pcp_list = &pcp->lists[order_to_pindex(free_to_migratetype(ac.freetype), 0)];
+	pcp_list = &pcp->lists[order_to_pindex(ac.freetype, 0)];
 	while (nr_populated < nr_pages) {
 
 		/* Skip existing pages */

-- 
2.51.2


