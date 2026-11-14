Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350F7606A33B
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 10:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=VjU+rMOQ
Received: by kanga.kvack.org (Postfix)
	id 571BD6B05B5; Sat, 14 Nov 2026 05:42:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549746B05B6; Sat, 14 Nov 2026 05:42:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463026B05B7; Sat, 14 Nov 2026 05:42:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 218336B05B5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:42:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 866E0A7B93
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:42:44 +0000 (UTC)
X-FDA: 85433386248.04.8076F65
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3914D120006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:42:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VjU+rMOQ;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794652962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLXm0HyVJe/uJeMVZwR1EneRdwmXhCI8DMdSCy58N3Q=;
	b=WJKnS90ZYvXrKtQ8U0ekKuu1UCjNyNdUFOQ3fkq8Hg6k9jVyf9+7VeWPswW/QFgp8i8qyh
	DP9zOF4AsFSts6dWCVMiPMd2hu/TCuqgRQ5cDTpbKD3skZzNfzmzw8eLPwm7cj5aFyXAet
	/bmY9qf62DcikdKQs/xFxIPxt/iKDGI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794652962;
	b=IhUNPGWr2QbynaAWdI5Bpsk2rnEjeDius3eEdKCD8Vs1COnXmx3WkIJKw3Ux+yOikOeOlL
	HhHTnynL0mjUuyE4SrvOqUsUbl1GbPvKgjXlMUX6wcO8oSxBJelEtpSDsgGVvR5ubQs2hE
	Tgs9XBJupcEcqOyA40/e+bOdrf1v+aU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VjU+rMOQ;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-33fb4680717so5372700eec.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794652961; x=1795257761; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZLXm0HyVJe/uJeMVZwR1EneRdwmXhCI8DMdSCy58N3Q=;
        b=VjU+rMOQQ+6Fc/J4KRsfcdod9ZhUiyZhkyFMSHp+/UDb4/n5sMaUUjkxrZ5QAXNUyE
         2P7h/11ajx3xrcsI8Yumg4d9W2pv6u+Yw3vgF2XmEaPP6qbVSfL8K1n00C9/ut4mb1NF
         NBKLD6y4FIIgUk0q/Xi5LufKeTzQOorwGNtnP3La7OVZ5B9n49yuUixgSk2AenxLCAmM
         Bas5H/pscc6ifi2wM3LkHA/C236ApExYUm4aaQSZhwAuD9VtyWirQG/+YGd3ENLEpCWu
         VEVDcgF6jShwflB6kf5bn+S1BEHo4Isk9rYEPqLAARxogNNuE3xJ3RQab+U2r0JhEGiH
         EYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794652961; x=1795257761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZLXm0HyVJe/uJeMVZwR1EneRdwmXhCI8DMdSCy58N3Q=;
        b=c6xwQSPzZvwapH5mvx4netefEnyf4OMMixdvv1kSG/aprZtjcND/gZ/bgwPkNfe69Q
         ZL1rW02jzZeTESgPLJBtCXVvmbkaogf6zTI8fbhQGBrNmdDJGevq7DwCeQP8fXebo9Mh
         C8vtdtScaEhRN21KjW1SKErWWJ92+gzIJ8jCDMZFaWzvM6j1wzhhfANe7jFO89+vGsQj
         Blz8VOb0r1qKVR8/05GmNPfu7a1HRI0ARYcjzJDtu06rBGQIsACrXAXZGUwKZq2Ms9zW
         Bp1CcURhDGL7nXoq0+8+OWO1KCYOhnYVS6Pjdwxx1fOjBzCdZd3WDwB4T51kP54+ViMu
         s3Dg==
X-Forwarded-Encrypted: i=1; AL+hErGz7FZOUESpyXKNjRukttxmBL/sHY4ky+t4EHLkTdYWVrsfzA3QCJBuoTVpWwiDBe95Zv5E+d6Siw==@kvack.org
X-Gm-Message-State: APuU4Z/GjemzjDq1L+WxMIChpyDuaSSELc8VMuQ8GUZgePz6/3adwpk4
	ybw+uS6fAftxwAG0j+qVdTNRAuB8PY4tVvq9qucOvnYsU2nQqC2XoozTaX7xqgS1l5M=
X-Gm-Gg: AYBFou0KKd/YFbop+UndeXMfpK3wZXZhdaBJzC/Xojs8AcyyZQuxnmhmhJik6HiMvHK
	I+1akRjLYKS1zTzgbBUq5H6JZff4UNabMz5nUO70A4im2SUkZXswDFKdMbdTutz52/kfz4RU25E
	RBdsPi9Y3BpKM12kLMocJ4OsGWXIwv/5QAjRJizEqUzL2MvRggHTxkTWN2zlpECKZSnVOYeI0mb
	5hSsPLgm9CuTgMs10UJXQsDdkvVg2yGvzvBuSrufHfUBB70M9yCNOwdQqG1oKYjm0Gl+sjcYre1
	HvSmHRzwrDGR8jcV+FRZvNHyYLvMhp0aO+ma+JjYnAXgY8D/dsz61oNxyElW7RWpu2CxyH59BvB
	bWz83owEpDCDKtvrZh2TKEeDJ1voZ8+GIi3nHibqUPD98mQlACoOOSwyMS28MQATZhWk1o7I0x6
	bKaXYGqEOJLjEOQW0TcDGesiYTBj/rqADz1mAKlixR3hI3nn1ScI/RHNZisdO76yrZVUUUsPXtI
	W5Y3h+iXPDZ3z4z0IWNvPNYKV2Ycmc9or47k15O6fo0QtcP03UmsG7LgCd+YDsOGnwJWlmcTMkB
	wWQqoTw2zJlEGYVEJdfUfz9ZFnftOEFmb1ymAzRtlM1Rh44ateeQnRIhklI4
X-Received: by 2002:a05:7300:b099:b0:375:3df0:722a with SMTP id 5a478bee46e88-379676f8cdamr5161245eec.28.1794652960640;
        Sat, 14 Nov 2026 02:42:40 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:9d36:3b30:f4a3:7b5f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795533170csm15772917eec.7.2026.11.14.02.42.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 02:42:39 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Mostafa Saleh <smostafa@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Usama Arif <usama.arif@bytedance.com>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 2/3] mm/page_ext: support early allocation for SPARSEMEM
Date: Sat, 14 Nov 2026 18:41:48 +0800
Message-ID: <20261114104150.58424-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261114104150.58424-1-songmuchun@bytedance.com>
References: <20261114104150.58424-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dfepooxyf7gtpidifjhp6n6emxmm3pfg
X-Rspamd-Queue-Id: 3914D120006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794652962-176759
X-HE-Meta: U2FsdGVkX19+neZVdzWZCHLaiZ3i1bCYTe1vzbjqNUXLQkqqOuSIe5otT6zi2pCTlGVOvI3IL7Udeag0uUpTk7Od2nXnV8bi0i91GDbEqLHRX+EcpssjMYC5Mp4Vp9GQZG1gbHR4v30y4DFuSubWi3qEf6MEFAOVnJt+ddQ7cR2DgdmCWz3gZYWZKXvXu6MmbkSfM4M6m5UqNdexkvCJFbtVWq8bthITaXqdDkA/MA0L5oNyRbPzG38MD+HxRSsLYeghS0h63Vi4nk1O4YKqd2r4JLqkh/sCpg2lGic/MImOLQ5nrwR8iltN4q7T13AE5kyG3QXmNrwFVpGfgBmfbBFZHpvDqLzjurIS3kpuJSMKfcqXxdgbQb3VEAw0cNHZXBmkwFYox/1IhIx7RGN22KrcmfhHBMZaHI3rPlaW7erE3KadM5Pr112Ls6tmgjx98SGcve7RtauFvQyRMUSoX1Y/qPM6SAzTRWdIXCGKqpUihq1VRq2Vd+bDTi0vovi/t+Q4PXiu151Do7bAYSMPyLD6w1ozIwDkO9dqZHUh9ouMi2ajU6oZOiPzvURSGdcqo6O2f1hX6PdowQftfYo1MdmKk+mJhLTuZEU4oxFl9VttpoIk7S3h/JrPiJSlE5tEMfZpyrqyUeWI1w4tt8byBSPeROTuhNOo2RM4Eq8FDQIXqfY/xgZxaE26KjR0OhOKBlTzsGNTjx9tMioTogy6xkR9ydQuwvcBlHqlE1FS0gC4XysXdBGK+pX1YACvypO84aTjHbhUH0ucIm6YFfY/5UB/BpODj6U6XAxlprR9DD1JyAE2xHQrxMvuT95POoRzouQhFG4r/nqR+8TUUnaqF1H6TtxNO0kEqLC9PUsQ7kj13Z+T3eMZycn3ppkmHPa9AAruCQ1S/lmBEUwSt/bgUCbGszNzRa4plAm0FiMi610DR3n9sZ7DXDlhsro76OfSH0rDVCeNiUxacbKsbDj
 zQX4N153
 xugUYluM4oObYS4gm3OtVCiyNJXtfQ4wnBiOl2BJUrbQyTVrmIoUFxUQhODRyJmQQJ6tdPQ5JAv1pZX+PjQAeLRfVHDgGv8bgc28Jt4Y+M1gtAmRbBGppT8N+bq1iru5C5BY+lQmKn+XazRXXUFfNF0uQpOkAULhaVOTuKLC5vezvBsG/XzyM/V2M71cARQDGsMZQ1sNXd2oMzcioEG2ftK6X6gAbqhK2CJg0nHBUWkPH0FY6GI7JfhonIi0HTaQo5OtKYP52/LkezwjbxMiNuZzcrZUO3DikISjhyr6y3xsj+bPObG7uqlE+VCtXipySRpt5GApjz7jYLOy0LYnm9Po1s4k5na646F0hRDZ9i/2QyQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Moving KMSAN's per-page metadata into page_ext requires page extensions
to be available when kmsan_init_shadow() runs, before memblock is freed.
FLATMEM page extensions are available by then, but SPARSEMEM normally
allocates them later from the page or vmalloc allocators.

Add need_early so clients can request SPARSEMEM section backing from
memblock during page_ext_init_early(). Use page_ext_init() as the common
late path for client callbacks.

KMSAN starts requesting early page extensions in the following patch.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/page_ext.h | 26 +++--------
 mm/mm_init.c             | 11 +----
 mm/page_ext.c            | 99 ++++++++++++++++++++++++++++++----------
 3 files changed, 82 insertions(+), 54 deletions(-)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 79c53ec45dfa..3b66720ddb18 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -16,6 +16,8 @@ struct pglist_data;
  * @size: The size of the client data within page_ext.
  * @need: Function that returns true if client requires page_ext.
  * @init: (optional) Called to initialize client once page_exts are allocated.
+ * @need_early: True if the client requires page_ext during early boot,
+ *              before normal memory allocation is available.
  * @need_shared_flags: True when client is using shared page_ext->flags
  *                     field.
  *
@@ -27,6 +29,7 @@ struct page_ext_operations {
 	size_t size;
 	bool (*need)(void);
 	void (*init)(void);
+	bool need_early;
 	bool need_shared_flags;
 };
 
@@ -61,15 +64,10 @@ static inline bool early_page_ext_enabled(void)
 	return early_page_ext;
 }
 
-#ifdef CONFIG_SPARSEMEM
-static inline void page_ext_init_flatmem(void)
-{
-}
-extern void page_ext_init(void);
-static inline void page_ext_init_flatmem_late(void)
-{
-}
+void page_ext_init_early(void);
+void page_ext_init(void);
 
+#ifdef CONFIG_SPARSEMEM
 static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 {
 	/*
@@ -79,12 +77,6 @@ static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 	return next_pfn % PAGES_PER_SECTION;
 }
 #else
-extern void page_ext_init_flatmem(void);
-extern void page_ext_init_flatmem_late(void);
-static inline void page_ext_init(void)
-{
-}
-
 static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 {
 	return true;
@@ -205,11 +197,7 @@ static inline void page_ext_init(void)
 {
 }
 
-static inline void page_ext_init_flatmem_late(void)
-{
-}
-
-static inline void page_ext_init_flatmem(void)
+static inline void page_ext_init_early(void)
 {
 }
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2367af05570b..35cf799971c3 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2707,11 +2707,7 @@ void __init mm_core_init(void)
 	build_all_zonelists(NULL);
 	page_alloc_init_cpuhp();
 	alloc_tag_sec_init();
-	/*
-	 * page_ext requires contiguous pages,
-	 * bigger than MAX_PAGE_ORDER unless SPARSEMEM.
-	 */
-	page_ext_init_flatmem();
+	page_ext_init_early();
 	mem_debugging_and_hardening_init();
 	kfence_alloc_pool_and_metadata();
 	report_meminit();
@@ -2727,11 +2723,6 @@ void __init mm_core_init(void)
 	memblock_free_all();
 	mem_init();
 	kmem_cache_init();
-	/*
-	 * page_owner must be initialized after buddy is ready, and also after
-	 * slab is ready so that stack_depot_init() works properly
-	 */
-	page_ext_init_flatmem_late();
 	kmemleak_init();
 	ptlock_cache_init();
 	pgtable_cache_init();
diff --git a/mm/page_ext.c b/mm/page_ext.c
index b679a8c1f7d7..8578f52a32db 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -12,6 +12,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/slab.h>
 
 /*
  * struct page extension
@@ -135,7 +136,12 @@ static bool __init invoke_need_callbacks(void)
 		if (page_ext_ops[i]->need()) {
 			page_ext_ops[i]->offset = page_ext_size;
 			page_ext_size += page_ext_ops[i]->size;
-			need = true;
+			/*
+			 * page_ext requires contiguous pages, bigger than
+			 * MAX_PAGE_ORDER unless SPARSEMEM.
+			 */
+			need |= !IS_ENABLED(CONFIG_SPARSEMEM) ||
+				page_ext_ops[i]->need_early;
 		}
 	}
 
@@ -159,7 +165,7 @@ static inline struct page_ext *get_entry(void *base, unsigned long index)
 }
 
 #ifndef CONFIG_SPARSEMEM
-void __init page_ext_init_flatmem_late(void)
+void __init page_ext_init(void)
 {
 	invoke_init_callbacks();
 }
@@ -217,9 +223,8 @@ static int __init alloc_node_page_ext(int nid)
 	return 0;
 }
 
-void __init page_ext_init_flatmem(void)
+void __init page_ext_init_early(void)
 {
-
 	int nid, fail;
 
 	if (!invoke_need_callbacks())
@@ -262,11 +267,19 @@ static struct page_ext *lookup_page_ext(const struct page *page)
 	return get_entry(page_ext, pfn);
 }
 
-static void *__meminit alloc_page_ext(size_t size, int nid)
+static __ref void *alloc_page_ext(size_t size, int nid)
 {
 	gfp_t flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
 	void *addr = NULL;
 
+	if (!slab_is_available()) {
+		addr = memblock_alloc_try_nid(size, PAGE_SIZE, 0,
+					      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+		if (addr)
+			memmap_boot_pages_add(size / PAGE_SIZE);
+		return addr;
+	}
+
 	addr = alloc_pages_exact_nid(nid, size, flags);
 	if (addr)
 		kmemleak_alloc(addr, size, 1, flags);
@@ -274,7 +287,7 @@ static void *__meminit alloc_page_ext(size_t size, int nid)
 		addr = vzalloc_node(size, nid);
 
 	if (addr)
-		memmap_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
+		memmap_pages_add(size / PAGE_SIZE);
 
 	return addr;
 }
@@ -290,7 +303,7 @@ static int __meminit init_section_page_ext(unsigned long pfn, int nid)
 	if (section->page_ext)
 		return 0;
 
-	table_size = page_ext_size * PAGES_PER_SECTION;
+	table_size = PAGE_ALIGN(page_ext_size * PAGES_PER_SECTION);
 	base = alloc_page_ext(table_size, nid);
 
 	/*
@@ -317,20 +330,27 @@ static int __meminit init_section_page_ext(unsigned long pfn, int nid)
 
 static void free_page_ext(void *addr)
 {
-	size_t table_size;
+	size_t table_size = PAGE_ALIGN(page_ext_size * PAGES_PER_SECTION);
+	long nr_pages = table_size / PAGE_SIZE;
 	struct page *page;
 
-	table_size = page_ext_size * PAGES_PER_SECTION;
-	memmap_pages_add(-1L * (DIV_ROUND_UP(table_size, PAGE_SIZE)));
-
 	if (is_vmalloc_addr(addr)) {
+		memmap_pages_add(-nr_pages);
 		vfree(addr);
-	} else {
-		page = virt_to_page(addr);
-		BUG_ON(PageReserved(page));
-		kmemleak_free(addr);
-		free_pages_exact(addr, table_size);
+		return;
+	}
+
+	page = virt_to_page(addr);
+	if (PageReserved(page)) {
+		memmap_boot_pages_add(-nr_pages);
+		kmemleak_free_part_phys(__pa(addr), table_size);
+		free_reserved_area(addr, addr + table_size, -1, "page_ext");
+		return;
 	}
+
+	memmap_pages_add(-nr_pages);
+	kmemleak_free(addr);
+	free_pages_exact(addr, table_size);
 }
 
 static void __free_page_ext(unsigned long pfn)
@@ -444,14 +464,28 @@ static int __meminit page_ext_callback(struct notifier_block *self,
 	return notifier_from_errno(ret);
 }
 
-void __init page_ext_init(void)
+static int __init page_ext_init_sections_early(void)
+{
+	unsigned long start, end, pfn;
+	int i, nid;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid) {
+		for (pfn = start; pfn < end; pfn = SECTION_ALIGN_UP(pfn + 1)) {
+			if (!pfn_valid(pfn))
+				continue;
+			if (init_section_page_ext(pfn, nid))
+				return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+static int __init page_ext_init_sections(void)
 {
 	unsigned long pfn;
 	int nid;
 
-	if (!invoke_need_callbacks())
-		return;
-
 	for_each_node_state(nid, N_MEMORY) {
 		unsigned long start_pfn, end_pfn;
 
@@ -476,17 +510,32 @@ void __init page_ext_init(void)
 			if (pfn_to_nid(pfn) != nid)
 				continue;
 			if (init_section_page_ext(pfn, nid))
-				goto oom;
+				return -ENOMEM;
 			cond_resched();
 		}
 	}
+
+	return 0;
+}
+
+void __init page_ext_init_early(void)
+{
+	if (!invoke_need_callbacks())
+		return;
+	if (page_ext_init_sections_early())
+		panic("Out of memory");
+}
+
+void __init page_ext_init(void)
+{
+	if (!page_ext_size)
+		return;
+	if (page_ext_init_sections())
+		panic("Out of memory");
+
 	hotplug_memory_notifier(page_ext_callback, DEFAULT_CALLBACK_PRI);
 	pr_info("allocated %ld bytes of page_ext\n", total_usage);
 	invoke_init_callbacks();
-	return;
-
-oom:
-	panic("Out of memory");
 }
 
 #endif
-- 
2.54.0


