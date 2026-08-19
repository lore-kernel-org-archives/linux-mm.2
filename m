Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7246C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000206B00B5; Wed, 19 Aug 2026 05:53:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB516B00B6; Wed, 19 Aug 2026 05:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBB366B00B7; Wed, 19 Aug 2026 05:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B13E06B00B5
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 475481204E6
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:58 +0000 (UTC)
X-FDA: 85117557756.24.84EBD2B
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7224D180008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LRM7i4K3;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6Hg9s0CPg01GOWYZ58NmcFpF0VjmJuzkxO0BlFJkPg=;
	b=ZYM35+dKwStUrYcx1+DDjoKbnhuybAZuzsdZp+sD7p3Ik9yra9d9LUxbwAMXC1G/fevBzR
	cMkTbMGNE9D3gtW2nuy9SyknB4JZtvKhUO2w7DnD/wIIZA2JpKs2U9FJJ49OjztLw8xSJN
	BufYQyA3gmIeCj25mnSCivwWc5YSiUc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133236;
	b=sswHLhpoOJ04UiksF9ftKzFKtxff86UBpnFzgerJCYevkR7iNu0wTfpPmugqPDRlmKhAYC
	Vuajhd8bA+bEzoke1Ad14v7CXGgPEsrZfIWQlonRW7yIqKnseMlVlgBobNa/9tkgc/VmeO
	ixK21ByxAg6OSnefa0/yNABSP8SanVM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LRM7i4K3;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cacf197759so11011315ad.2
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133235; x=1787738035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q6Hg9s0CPg01GOWYZ58NmcFpF0VjmJuzkxO0BlFJkPg=;
        b=LRM7i4K3EUNWV1IBKu3owbzzZ+9WejoqyrnW3DiIK6GfWbBAAu3KU+/zF1s+gsmhj5
         miOIMyhBMax2oUKnOC5VREyzeqjEExOW1gb+kPJJxHFss2QENzzCenaJ3xVkwWlNvIlX
         HQpY0pLbd0TsTKHGd0v3KFqc6Y3aQCx3EV+Rzh2tUPG+jnMkP9/98ePTADFquuGxbzGC
         HN4bDUEY50iMMxtOIlvs0DXU4f37zdi0aCweKuIejJLCtliqG6/xminOkXGaeIBONEUY
         4P8iWktzushRBaSIKjnnoYsJxKAoE3tywjSwWE88wjBL38/YXsJc+0GhijrPWLx453ms
         VZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133235; x=1787738035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q6Hg9s0CPg01GOWYZ58NmcFpF0VjmJuzkxO0BlFJkPg=;
        b=PqcMGllH6KkTUF0ABd83kJWDMtvfglJrN520ejy6Y7xrfFOoSThKQNnsZgiLaNXxq0
         dlPSkv+6wXe4G8+8S0ANWgIkuElyKBbeZAjZfUY2g5ORAfQ4aUWiKNwIyxwDXWrvdSfn
         duKn+dt+Ski+5+uW3rrWAUTO3rGIZDNhcmA3F8KzkEqSNbhSj/aqsHVfo6kQ1oeBiw+8
         Mm+ChMDR0jv7fW2kbYgqnzsbhsBILH95OztcMqlaNcnGzrY0a/KP/1NanLikKqE6s3uI
         sh5Nlu9BJhMdVwoi7uclhxiQvfeJc3Bq5vOTNKE0AAJfmuFOn95t8A4EXbRQxxVRHH9x
         ofJg==
X-Forwarded-Encrypted: i=1; AHgh+RrwyldHfsWlXrojNzsa0I4WGA1DwyQzNaewAvICv6C3ljH57fZ3ehW8Ue5YRy3f6Y4oI915c2Xecg==@kvack.org
X-Gm-Message-State: AFuF++mFLQ2rdjNIjsy836WEpnNlYWsFNCR9G9i3zMB8MN8wurIJcoI5
	ZifTcTM0QR3gvm5MdSQCj4Rf1NKYuKchl2uPmmZWxBqdKUB3p3XyRp7Z5ifP6zlMu5Q=
X-Gm-Gg: AR+sD10uRGTO2VLzbPk1t1cCQsOx2dxDoEhbmId4jl9cqq3h9yNLQPrWhGHLtVsQTmE
	I9Nal5w9fdtqWDLQRMEQsrgs5FP1aVKs7cZIVoRXVz9jn342Okzfrf5hlsJLZWwRiOzYsxBTqV4
	x62gP0etG73IjX8nC/onbdDOmSSrcWjyQEnuD6CT/Ql8a2oKBXJG0wnCAEyoymtE9S6bG+O4f3h
	GDRZK5hrLCvLZIL0zZmWpEnMl300ozojj2PKNQkdsIA4HwuALgHjS+6invQXzpVLW77f2UFHgQd
	W61XoIgf/hvsr7BRbn9xDWnDw3+4JPeBuTNUEXSul+LuDeglgzmnoTjX6yCYAJk7v7DQSVSeQP8
	hSGla9TTrCP6dA35QpO4gRww/B+4qlb2TRR8w46H+EY6w3fqRlftfxbJkOdpadqSqKavDrjz4kW
	n7QMzf++3ogt2NIQkik74NE+hZzBGakXlwymnppFkCPRQ762IugmGJ4nwU8xIX1nJDRTgwaNPpI
	qGN2yPoxiR1g8ZhjMiwfukWQYw1Xs1FM9uw
X-Received: by 2002:a17:903:4b48:b0:2bf:dd0:c8b1 with SMTP id d9443c01a7336-2d5fd432110mr63480745ad.0.1787133235251;
        Wed, 19 Aug 2026 02:53:55 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:54 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 14/17] mm/hugetlb: remove HUGE_BOOTMEM_HVO
Date: Wed, 19 Aug 2026 17:51:36 +0800
Message-ID: <20260819095140.17252-15-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: z3rdhwgqgmrhy76c6a98yrfjg47mm78y
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7224D180008
X-HE-Tag: 1787133236-404004
X-HE-Meta: U2FsdGVkX1+QgLAx6J+MpnMeIsrqHPHEvCOKp94UpIh1lz7yplhPZLwE0TgCSba6rXa3qj6w8F79GovlAe7Sfx/KVwMnj9PadLTlPY6xGMFkXLvJl7PkYd/2fB1qGyhRKQLonMaBXCnUaeTEUCIZROx1a3U1T5xeFPdXAWu7Oa1GsUNIOGXbQLw+sXwgekuiPQbW5WB/0+MclnZl6e8XHvVcQIPaYNAjdesLniM58WD1kE9Y93C1OcE9YJ0/YF9ZYvy27IPoXa37fc/GThJxJ0qrYM3Fdw3eX7132SFz4HtjfDzEJXMDjFoafxBignQxEhZlyBQ61kBJfpJ0rjjksdhSoQmb/6OflmBbhpXKbswLzgZk56pvjZ0DKWuDiFbW+ZFbkRDukO9N6efx2yewtT79xKtbOdsoOghHqew99UgTVP3AjW0GoDds2ar85FflaIfCY7zsTQyV6ROdLrxzWRaGtMVoV1kLGs4UDG/tOZwm7eLc5HE8ZEEymJ88m7bqNbkGq3sGpu0baIn/AL98nzsEUHUWecKnfFMKhtdap01ZeUTaX71Ff7uNEyZZi5SDNnvjiijpygL/BjXt7grrdaUGYG1sKZkCuUP0QrwHD17a4m1EF3Q+B3ilXWKUoAaIM7rhyiMMJCawM0JaaWKnajX2GFdXwy+48vrnaO5+VyjyCAGCszfMlRBiCQ+pGPnoFxVbaByOnFt7RC7aK+SpHE7h8MC7bCl4VTPUAaoV6TGi0tNQ/+Cbxa3YYhLuLUp/Iq3R9ZBx0LDjiWna1mli0BJpyXwvQHn5OHdi9T+ikW5ERWUrUacxSDqc88PUcGB9FIT5dRhMAQ+jzcr7KQldZSkhGW5eNVG5EaWWFA2MOYHxTjbH8pos66WoSAFBpWpL23hwUuWcP/o8wrAXN4sGSqBuGyIamrSnvGo0ShFG7/4sUXHx45m1gwIlNduZse/ZXgPQ2vd42rA4EByhmoY
 TExrFWEg
 ikgpXESj/e+4nNwT9t6YsWif3BFuGWbYzbrXfJoRJTHSIp3g5+GNSRQBru4+AoRS+fpJ3ecJCpz/b0JaLBSjgaro7Z5mPntMwIECWxLq5o1RXeoorHvkDhj1tzi7K+xrtVHJ0u/iKMEQ6WIH76dxFkx3Kv0PIF+TKCFXPTt7hu4fHAUHJIsljwHwKJ69mhZws4mnLWchXdZU6Lby6LQkwkGacoRFi0H1gFyH+BBKygbIe8hyeYAW0YuwanEXX+Ec3Ed+e88vJ76MiPEMnnukuEPAKBG3dwvw9LkGygzDbnrwOHZf0TVZwhiFbstXA92iS6Hk1f1wxbCVmpl6TW349i1He5xUrDyPCe+viLBRHNYuf8cyqs/mOYEKF2/fOJlPFDlBoVigdxtU6aNjjGoUSVQdIk5QF1CKq8E2l2nQM0Sc9u9ATOkKZv6aroHME4Inmn1xpgqZXzA0qdiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HUGE_BOOTMEM_HVO flag tracked whether a bootmem huge page had
already gone through the old early vmemmap optimization path.

Now that HugeTLB uses section-based vmemmap optimization, that state is
already reflected in the section order.

Remove HUGE_BOOTMEM_HVO and its helper, and use the section state
directly when deciding whether to mark a folio as vmemmap-optimized.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Use the order-based helper for the bootmem vmemmap-optimized check

v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h |  5 ++---
 mm/hugetlb.c            | 12 +-----------
 mm/hugetlb_vmemmap.c    |  2 --
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index fe28f98e1b22..3559041a5a57 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -675,9 +675,8 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_HVO		0x0001
-#define HUGE_BOOTMEM_ZONES_VALID	0x0002
-#define HUGE_BOOTMEM_CMA		0x0004
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fc579ba9ab39..ef41b82493f5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3196,11 +3196,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_HVO;
-}
-
 static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
 {
 	return m->flags & HUGE_BOOTMEM_CMA;
@@ -3292,12 +3287,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m))
-			/*
-			 * If pre-HVO was done, just set the
-			 * flag, the HVO code will then skip
-			 * this folio.
-			 */
+		if (vmemmap_optimizable_order(pfn_to_section_order(folio_pfn(folio))))
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 7293706b532f..a25adc474351 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -714,8 +714,6 @@ void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 		return;
 
 	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
-	if (vmemmap_optimizable_order(pfn_to_section_order(pfn)))
-		m->flags |= HUGE_BOOTMEM_HVO;
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
-- 
2.54.0


