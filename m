Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D6D8C9832A
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ABCD6B009B; Sat, 26 Sep 2026 22:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5833C6B009D; Sat, 26 Sep 2026 22:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1186B009E; Sat, 26 Sep 2026 22:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EDA76B009B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:55:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A0011A0981
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:23 +0000 (UTC)
X-FDA: 85258026126.04.CD2CBFF
Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id BF94A180006
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CLNVUrPY;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBlSYhutFVpa615i7UF023108ER8B6ja1OjBI94hgy4=;
	b=A11dj0wE5Yj/csWfk/Hr46zHuaGD7jZIenQDsKcFsyw2DnP8iL72NkZK1oioEWGI97IIU0
	lebP/RJbu5hX9r8r8z4Uje1Q5tndDpbdeZAb/zqYYGso/6cn3Bisw4Ln1mYWxs142zuTNq
	hLKWjtRv+y+a7J1MDjm8eDVbWy5zgto=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CLNVUrPY;
	spf=pass (imf16.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477721;
	b=xBJxCx93UHykwH2lz/CwOYP6LHMFpGyKo87F+t4UGXm9ZUbTy/VbgeKBJReRFyxI45kQZt
	aCpwePZ4+S4ilCG8WKoZqBAEwHd4+8HLDr6J/jXLPEsPFJkDo0mWHUtMSYCPsvPZA3NmXr
	zJs/rrop6HGsl6jiFAZZBHtZfkBXth0=
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a0bec20a6fso746232a91.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477721; x=1791082521; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WBlSYhutFVpa615i7UF023108ER8B6ja1OjBI94hgy4=;
        b=CLNVUrPYSWRr4uT1iNU1t59kqBMUov+vGFEWs9fHXJNli6f1IBribVbJ9eLebxxd8m
         z8GM0SDsq8h5Qm4GRbMF+iRxxTm/4O8VL6D7NjRi5FR1eqnPopCh1abi7zj/WNvQpwyP
         823l7cAT+sfPb7hxH7pwRd8eQk9gP7NV9QIFVKd93Ki/WJ0u5dKsojBQrJx8ZznZcrek
         jT9H2SxBECH4QfPzBnmFgqUTLe+eLnKi6l34wWVx3SHI0ziz6r0amdJDoJOrY2ufC5UQ
         +D42tBLovlP3Tz82g0Qhr15HbtjCtxsEhLAeJE13CoolRr/r816hZh6R2BaWZBLJ5VcU
         oiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477721; x=1791082521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WBlSYhutFVpa615i7UF023108ER8B6ja1OjBI94hgy4=;
        b=H1BM0gZ9YLOe7NTC5Jxmh+70VRhqPyu5edEKzpw4T6kbVQluFX+U/5PvYHXMYjen5a
         7NEd7vt0SpUzfKwZkDj7mRgYXOqVQP+Z1AS+yVxpV4MciyGVWEbR7LZln0XgOWsx/yYI
         aKW+9FRprhkfmZ8f/CgW0yV1jGvycNrrfTMGcoQJkYXD+PaXVHpPslDVEB7Io2Aj/E/x
         PdE5ex7+ajzdLg1G6rRKsKQZnsUKIQNst87DczOflL7yTxR6tLP7+zPwWrN7nicb+33T
         OwwGSmJUiKcWdvJQFd4OHcguI34d0tviUGFRCAIBwO1hqM2m+wGP9BQrqVWGDTzz0ukx
         YLVg==
X-Gm-Message-State: AFq9FYJHZXRjPq6mhiCEwlPE7S404uKTG/tV0ga75gOWzsWd1M0Aw5Ea
	UFBDp65D+UFXIG52LBTTT4VCHGtc47RPHR5mD5fwijk5abPtKhVtQjHaSWGFjn4jpMI=
X-Gm-Gg: AYBFou2oe5NXF2SNzpzP41aVlCoTq4LOB0jHeKxcCrSIPCWvAoD54LPT4cg1hkFrUlg
	di9rEvTX8OMxdMOM2jaTSkB0MCDDZ6MNDQ6QJQTNGVJ6kcQxl9y5EAknEmCE29UIqcJeoyTQhHQ
	uJxO9OWk9jo5nl4ix4XAL7/wGdpXREmjpFT/gUV9V+5WOP4BkV2fnnritYSm1nC1nUwKIcqylWi
	+Fe9lT9wN4qFTT4jJsOpBcOLIxzMlPYlgBioAZEiI63OVqftnG4gq9ReWUaXMq6CNevxpaYjolP
	BHkVmjoLqgp+7WUzqeclbUGiqbApqPb+SiSn82ZBwJ+nGvwcniit4Ol0d7hQp5LQyzx7bfpJOno
	ebsJgW28mKnNWlyfAzLhJOm/ZsZpKHZHUU9vOkPEreOkrW9C2l8HfFAwRvv/fDMfZsLRQBhpoGh
	yj/OUmix7v5auoJTFPdcdzVTnCLfMzKS6HItNYlPgT5B+x3DK8f7A7oYp0pnrpZZ5RZ4MKm2OzZ
	cbMwZyVOR+c8dhuwEX4
X-Received: by 2002:a17:90a:d64f:b0:3a0:e985:9ca2 with SMTP id 98e67ed59e1d1-3a0e985a241mr1295162a91.31.1790477720535;
        Sat, 26 Sep 2026 19:55:20 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:55:20 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 06/12] mm/sparse-vmemmap: set compound page order for device DAX
Date: Sun, 27 Sep 2026 10:54:35 +0800
Message-ID: <20260927025441.741633-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BF94A180006
X-Stat-Signature: amg9imw8w1qdfywqo9ny5mf565s4h4ka
X-Rspam-User: 
X-HE-Tag: 1790477721-634995
X-HE-Meta: U2FsdGVkX1+wPGtjh9jBnGwl/Q6CDqUkoD2fuW4H4By+RnkC7QWqCmP1sWUDRk9iMyqnZYVuAhoNprKX/cDOIJXibSq5F/UAPNBk5B93RgyDq8gYLu/p34u8JPX/jRf63QBO/t4cM8Y/JgULPdVftd94IA2HR/zUkGzh0cgYQHVcDsHb+ubvzM1TDYCtpZjDXG0Q1Ba+wMJvvvxvYm0RLTKhEUF5+3HDeR97cjr5S6vD7Xa3aiB4PTz3pzTGJHll/E6ckSyWK2HxzntnKvCrWupWqJPB46NOnVxXqwa7lGXcvCdF1ZYGwr2TjET67EZEXBokajwCw+Nax3g1EyZVxDEH/vXlc0x1nnasrUSi3FIA4tNXmSDZBo8O9o1r9Q6QoERHbHpqtY+iPVfWVZopFIp8YFvsNIxodXaqBzYnokU/lelEFAuYP1tk8XMnPj1s4jdw19tA0aPCy51oC/SkG8mGiPM7xBlbsygmZMJbeza/UunHFvsHpS+0j2rc/Dpj3bkIu1nixkoMAII/dgmz7uvObmS84sJtMrMT9HMPaIhh8hKyplE1X+CQ8bB1tvW7fPgf6MBhnUOR/EqA9UDof9h6Z6bHBytDhLn83E4AFaxAiJltVBOtE1/r9J+XdtOHSNh1nQn55/E9DUgB6Hn/wqIqC1TaN3MopLF/4Fyjv134OSL1JwFvQxlAraLYrvcgcV0mpf9ZUD3aW4uDNABDNqPfiYLGQy029lfESsL8Uh14gh1jnKsGIQn7GBOlay5OvK4AMozqMp3R5Lj2ABqCFQn1Pt//D3EV1rUiNXcrm+xWmdU1WfebE50zVABDjju+YQV5lZTgbjjxQMI9e7TULK+WZdj/LYBfJEYCouSmSagK74HslhjmNnZGPXeGDuOS23I8O0ZHP6j2kbu4PlsbymxE8sKsprIEHsfHbdQghKSFRuFsgzmWkAEjpAq+x/VG4u59gM6tb4N13qu0Tc/
 bITMP8k0
 aGe2rfC2JERq/uEUknUj0dX45IguBo3vhrNmIwm5EFR8+tHb+33CTLFGQLOC+B5PrkvSDsCM/3Q441DsuIWRV3SJ3JMOMzJxeTG5VzMD1YlTwE+4LsysZUiZHuv6jvmqrvIcI3mToCn8F04/tkZE0rwSBzorguKOf2v5AkJGb1L+BQ8e1Tq6z+iTxnxi1V2br+sJ9SEfmnyyAuvSWI/mLDql9VegiqceyXdZedtfxpkHNw/5tj+mPNQZ02weR3yWM5sYe2fx7TlGDjV3nMyQ0oiGGLzTv+oCeZiisXUuhfpjZPgCjPo9Vsse4Yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device DAX can use vmemmap optimization only when a full section is
populated with a compound-page geometry. Record that geometry as the
compound page order in section metadata before populating the section, so
later vmemmap accounting and population decisions can use the section state
directly.

Clear the compound page order when the section becomes empty again. Also
reject partial additions to a section that already has optimized vmemmap
mappings. compound_nr_pages() determines how many struct pages to
initialize with a section as the smallest granularity. A section therefore
cannot safely mix optimized and ordinary vmemmap layouts.

Partial additions continue to use ordinary vmemmap population, so they do
not save vmemmap memory. Such additions are uncommon, and the lost saving
is negligible.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Update the subject and commit message to use compound page order
  terminology
- Use EOPNOTSUPP instead of ENOTSUPP

v2:
- Explain why optimized and ordinary layouts cannot share a section
  (suggested by Qi Zheng)
- Collect Acked-by from Qi Zheng
---
 mm/mm_init.c        | 15 +++++----------
 mm/sparse-vmemmap.c | 16 ++++++++++++----
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 97e0158d2aca..efffa8609b85 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1049,16 +1049,11 @@ static void zone_device_page_init_from_template(struct page *page,
  * of an altmap. See vmemmap_populate_compound_pages().
  */
 static inline unsigned long compound_nr_pages(unsigned long pfn,
-					      struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap)
 {
-	/*
-	 * If DAX memory is hot-plugged into an unoccupied subsection
-	 * of an early section, the unoptimized boot memmap is reused.
-	 * See section_activate().
-	 */
-	if (early_section(__pfn_to_section(pfn)) ||
-	    !vmemmap_can_optimize(altmap, pgmap))
+	const struct mem_section *ms = __pfn_to_section(pfn);
+
+	if (!section_vmemmap_optimizable(ms))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1144,7 +1139,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	memcpy(&template, page, sizeof(*page));
 	if (pfns_per_compound != 1)
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, altmap, pgmap));
+				     compound_nr_pages(pfn, pgmap));
 	pfn += pfns_per_compound;
 
 	/* Initialize the remaining head pages from template. */
@@ -1160,7 +1155,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, altmap, pgmap));
+				     compound_nr_pages(pfn, pgmap));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 2457ea2c6dca..ca2470e96a74 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -135,14 +135,14 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
-	const int order = pgmap ? pgmap->vmemmap_shift : section_compound_order(ms);
+	const int order = section_compound_order(ms);
 	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
-	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+	if (!section_vmemmap_optimizable(ms))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT) {
@@ -608,7 +608,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_can_optimize(altmap, pgmap))
+	if (pgmap && section_vmemmap_optimizable(__pfn_to_section(pfn)))
 		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
 	else
 		r = vmemmap_populate(start, end, nid, altmap);
@@ -827,8 +827,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	else if (memmap)
 		free_map_bootmem(memmap);
 
-	if (empty)
+	if (empty) {
 		ms->section_mem_map = (unsigned long)NULL;
+		section_set_compound_order(ms, 0);
+	}
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
@@ -838,8 +840,13 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
+	unsigned int order;
 	int rc;
 
+	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
+	if (nr_pages < PAGES_PER_SECTION && section_compound_order(ms))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (!ms->usage) {
 		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
 		if (!usage)
@@ -865,6 +872,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
 		return pfn_to_page(pfn);
 
+	section_set_compound_order_range(pfn, nr_pages, order);
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap, pgmap);
-- 
2.54.0


