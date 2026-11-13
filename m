Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2928606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=PSAwMuMY
Received: by kanga.kvack.org (Postfix)
	id DD8676B0666; Thu, 12 Nov 2026 22:35:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF116B0668; Thu, 12 Nov 2026 22:35:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC52D6B0669; Thu, 12 Nov 2026 22:35:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95E8C6B0666
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:35:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 797C016056A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:39 +0000 (UTC)
X-FDA: 85428681198.20.A7B598D
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3B156120005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PSAwMuMY;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xerMoqxyOI259DioKFmjqunoPjgI+nLHAnuHAtyHQXc=;
	b=ZQoLwxOFHycgBMmHnbBpo/tIYLpWtKXmZdpAPtD38UaL/iHo88eJ+yYqFwwXZkpKEkAwxn
	82CTiYpefmmGDS/cruHEd5YPvVls3D9JrURiD35wsMjkWGGCaVmDhVnvch+4Izzm/2JPpH
	DFxfNuK74nGrEWMaWBg8yCbrxDrc90Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540937;
	b=WujZFKojaLh+pHj/iAtYr8kJvDEer8gIl4J5Vp2DR6ttEgEsOeeLQsmog6cyGfHtDqmK4P
	PdKlaTrg94nkUlhsZUBSe00stthF5dLZ9CH1RYo3sg0L1eBw030XcVyEp/mo+SmSswWJrz
	znEEyn2fs9PwsnTEMy1BnEWv/oh3XRg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PSAwMuMY;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3712b6d9843so536421eec.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540936; x=1795145736; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xerMoqxyOI259DioKFmjqunoPjgI+nLHAnuHAtyHQXc=;
        b=PSAwMuMYZ+s68Q3N60uoW8SFW7isMITtCp/AvCBa+9zFFo5eC/yDXBp+XoiI7odfre
         AGCi2iZwafMH68Uarz7t+J6bT2hjOJEy7w4SoQ6V5SbIYChz+Fe9oZKFTULpZMj1pQ1e
         Dt0SnqPqN5s1JC0X8a18CcDqJXdatGjfQfGkyJpQgsQMzqgyBKoL0x5BLk6dD6S8c7IA
         +eWMIDNr1Y58y6yxPDQA/aKmngfK8T4wE02xP3mYbTJpqapeRP4gw6E6xD/ewaBv3tPi
         lCxi6+pix8KiLKtHQW7weOhTx/xiX1tqWVFhjbX62dCsenvRekLUDaMXfmBzVxehdBJg
         E99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540936; x=1795145736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xerMoqxyOI259DioKFmjqunoPjgI+nLHAnuHAtyHQXc=;
        b=ULJV2MOpw9EvOUOvF0bLMzVff6rF0mAMjmtU63+tuJJsSRVibU5VGv7mTsp333yRmH
         ew2wtkhGEJ6th+KkOj7rCcQSHGzpXsd2ytdrLeX+nzDmsZ/hn1sG74NLRL/7YRQ8UGHP
         Q+MkUZ7htZ3zYJkyFQYXnivU8QNF/9Pm1vxauoXN9BXULLmufLc1+qurB8eON3s4Ev+1
         65GmuzUkOJPCVTIeNJ0ytCZlCHueUcL+C8e2To9HYEAujqpWylIzugX52ztHeZmsMF37
         sQbVsXmxex4diHEEdOHuqzTa6bshIA7byAntnCNXwilrb8TpAFBEWMxntY8VRm0zpMST
         a/dQ==
X-Forwarded-Encrypted: i=1; AL+hErFsk6ntMjfMQn9h9ZrovN4PstGTfO9XjOrbLrQMek1bG8phevzIHeLboRRIoJVaNMyldXS02RmOfg==@kvack.org
X-Gm-Message-State: APuU4Z+dHrzdEC2tClRnPYg8YUcMA8Zj0wY0jMV8wqGipU2NbzQtoa/A
	Owg5on7iMR8IFTTnn0JA8gf3FCrUjCVMKezJfC74V59qd+IrLMEm70zLjOJx2qgTx+s=
X-Gm-Gg: AYBFou2rB82SJcMcB1E1thCiLh1Lm6fCuGVgSjSqrpE8GwDsg8CUMUOx+y4qMAFf/Gy
	BweYDw/5rY3LxDZswH14ScfoEHC6yTLy8H1SI5Rt5EosbfQqXP8pk6ftcnHKYr7rFaQdGUyTVvX
	x7YQ5v19pNO7mPQUFqg1G5n7q42n72DiVMo7zM0XQLyDbnyiJO4YbC2XqXuLjiXtrKmw2oFXgNk
	vm2vQWopSFO2Cs+f1K5tutgbw5eM8V5YX7OwAFlHyhWSLKh40pwqQZprU+7UjV7W7no1yK2CIQR
	ttFUATP3+mign2kdJ/RNiSOhxhzDIeec3H/tRQIpaqspubNr+kvbykfXcjnPO+wNL6zZYdOmpWJ
	bIltR2DjKskvPxmRNURolUkceYZWSKqJQqVPZpXqD8+9u/gKKkwlnaSJzzmtwn89365V9ivmDEl
	DcOaEtg31c8BUVCAEW8ghIhLG0nBAuy0eA7Wb17Rncp+JMk5xdgYBaK+U6x++ef2uAUG3JSBS27
	b0I4CzVXxFToeFJ6E/TEgE9fSIa2UWheRvO8zTLfcgiWjBbgWo++girEpbv6m2R4HrIXs1t5IHu
	28/hi8XjAm/WkQhq43kxV2bBuQQIFPiCzGic/SE+x6Sx7OT89/7ax0zKz0Cl3qM=
X-Received: by 2002:a05:7300:cca2:b0:36e:371:8255 with SMTP id 5a478bee46e88-379603825bemr1048930eec.0.1794540935826;
        Thu, 12 Nov 2026 19:35:35 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.35.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:35:35 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 04/14] mm/mm_init: factor out common struct page initialization
Date: Fri, 13 Nov 2026 11:34:32 +0800
Message-ID: <20261113033442.62970-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: k6qx11fbz4xhime4gqef3tc6ydb9grr4
X-Rspamd-Queue-Id: 3B156120005
X-Rspam-User: 
X-HE-Tag: 1794540937-591663
X-HE-Meta: U2FsdGVkX18ZExYOFxUaTqpD6qLnLheWRXY68NdtNEwmjgLXB0V1TQir7ovssL0PmIbwqhJXg7hBSHTsSY7ENqDy9vM0ZlDpefJtaJ2NKw9MysgpRJAzTDB6HN5EdkSa5DQgT6Ph7n8GU16tB3URtfgF61mR7MJcTBYEYcHnE+vT6oP7UZ7H2VPJsiR/0JSuS1XhCOzu+XujGJv9xSaSP9uLOIM6CxrFP/wN0OZQTflajs/C0NmdjK106h+ChF9Bj3WnrOkXHrLkKb02/C052N5waepGxN3Mg2bEbLJEiGgcnptnkK3pXwDOBjGwxQjes4FfZKWslX6tpwuS5zq8FJTFQFV4bCoDH3zkEooKsRy27igP5zO8z9LqZ9NCw7jo/wG57EtYcrfaIT9lrO+XtR1jNajzO/2uole+9sd/Krs783/dCQDO6GeEsXF1FUNqEwXoy1uyH1p2cYjhYHE76ERDZYQwxMa9epyJbVxBg6BuwKsOuV5SdJe021rbUSRvSiJ2ngLWkqzN6Tpp8NqnURjVyE2Fcr2MYgCogUkONg8jUCzVHVx6urLyYUFcl4pPkPoPG1kyoYNdxgJHGw/3ZG8rYyoJKsYbOop4xUIKnjmG1+0Hr3/cJjkabRUjoqQd4W0YFepcHWTw9xk0Ei0ckjk8tjuo66+Gg1nV7b4yY8j+2yfuCBc4I0OkEiTyWNb/o0qJGD6U52I9VR18Yfhaaqfu7AqAX2PoOa7iO8bdFZjLeiP7HssAROavhHQl89skrDv4B0DTbV14AdMLaWmAIAfR4RzAyHK7D2gZlQ4+ynI3dOweVGmt7fI3bBxbH7p4AJDIjewCub7i4V1xiJ95q4LPHwZZth8EwITSRLBxokSrniK+WxprXC2BzI0tpohIAplqNkMYHCFqJzkID/F7jO4X8wrCCjruVDOjNonDIQF+oZHC2OGRSejuIPQOrgsdQItCEo1f52vUeL2ztUm
 nzg+EfuV
 ioSKg3V/pJ/iEi9ayaWRxZCTTp8b0/8LcdLoWVyKmEO3uoX/NmjntmEDxO1K0tD4uUuoorX3CDuhD2odnPxceQ71XEeSAjPBDojiARE1h6KAsoikKBnrVL6VuMT9ZIkSXqJRXEjQlU8HUciGAnW4t8f0/lM68Y3FI5evBbj4hXD9fQuJrAfdojmiTfVOBYefi9Ns6MxpcSyKfOVbzPpg1OcF87UnIb4VoHI7X5UIBgBsUaproOf5DUpX3YKl/2J0U593zYCizLqtnYyTKhZl8yk/BPMknM8E+BdPhKMtW5Q+jrXRfXqn356nraZ4oLlkeCcURZLtS2gg6DbLDH6SfMYV0NiWsSoZI8eKLkmHFMhMR/bE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Several struct page fields have the same initial values for every page in
a zone. __init_single_page() initializes this state as part of its
per-page setup, while the shared vmemmap tail path open-codes only a
subset.

Factor the PFN-independent state into memmap_init_page_common() and use
it for both regular and shared tail struct pages. Keep section-, PFN-
and instance-specific initialization in __init_single_page().

This also initializes the last cpupid and KASAN tag for shared tail
struct pages consistently with regular struct pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Remove __meminit from memmap_init_page_common() so HVO shared tail
  pages can call it after init text is freed (reported by Sashiko).
---
 include/linux/mm.h  |  8 --------
 mm/mm_init.c        | 22 +++++++++++++++++-----
 mm/mm_init.h        |  1 +
 mm/sparse-vmemmap.c |  7 +------
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77b5d450fe45..2e182498898e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3022,14 +3022,6 @@ static inline void set_page_node(struct page *page, unsigned long node)
 	page->flags.f |= (node & NODES_MASK) << NODES_PGSHIFT;
 }
 
-static inline void set_page_links(struct page *page, enum zone_type zone,
-	unsigned long node, unsigned long pfn)
-{
-	set_page_zone(page, zone);
-	set_page_node(page, node);
-	set_page_section_from_pfn(page, pfn);
-}
-
 /**
  * folio_nr_pages - The number of pages in the folio.
  * @folio: The folio.
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5ce5a325021c..8d0b8faf3938 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -603,15 +603,27 @@ static inline void vmemmap_optimization_verify_zone(struct page *page)
 			page_zone_id(page));
 }
 
-void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid)
+/* Initialize PFN-independent fields common to pages in the same zone. */
+void memmap_init_page_common(struct page *page, enum zone_type zone, int nid)
 {
 	mm_zero_struct_page(page);
-	set_page_links(page, zone, nid, pfn);
-	init_page_count(page);
-	atomic_set(&page->_mapcount, -1);
+	set_page_zone(page, zone);
+	set_page_node(page, nid);
 	page_cpupid_reset_last(page);
 	page_kasan_tag_reset(page);
+	atomic_set(&page->_mapcount, -1);
+#ifdef CONFIG_ZONE_DEVICE
+	if (zone == ZONE_DEVICE)
+		__SetPageReserved(page);
+#endif
+}
+
+void __meminit __init_single_page(struct page *page, unsigned long pfn,
+		unsigned long zone, int nid)
+{
+	memmap_init_page_common(page, zone, nid);
+	set_page_section_from_pfn(page, pfn);
+	init_page_count(page);
 
 	INIT_LIST_HEAD(&page->lru);
 #ifdef WANT_PAGE_VIRTUAL
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 4478419f0bb9..9de9db31320d 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -109,6 +109,7 @@ extern bool mirrored_kernelcore;
 bool memblock_has_mirror(void);
 void memblock_free_all(void);
 
+void memmap_init_page_common(struct page *page, enum zone_type zone, int nid);
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
 void __meminit memmap_init_page_from_template(struct page *page,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 9b80dd7326f7..fd869617423a 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -212,12 +212,7 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
 		page = (struct page *)addr + i;
-		mm_zero_struct_page(page);
-		atomic_set(&page->_mapcount, -1);
-		set_page_node(page, zone_to_nid(zone));
-		set_page_zone(page, zone_idx(zone));
-		if (zone_is_zone_device(zone))
-			__SetPageReserved(page);
+		memmap_init_page_common(page, zone_idx(zone), zone_to_nid(zone));
 		prep_compound_tail(page, NULL, order);
 	}
 
-- 
2.54.0


