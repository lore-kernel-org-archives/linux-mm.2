Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F6C606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 10:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=HSm/n18A
Received: by kanga.kvack.org (Postfix)
	id 3EB586B05B3; Sat, 14 Nov 2026 05:42:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C19D6B05B4; Sat, 14 Nov 2026 05:42:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9A76B05B5; Sat, 14 Nov 2026 05:42:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 014C26B05B3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:42:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C4A18039E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:42:31 +0000 (UTC)
X-FDA: 85433385702.01.3435FDF
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id DA9DFA0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:42:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="HSm/n18A";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794652949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=99ZqQGXUzLhB02hNr3DGsqAO8D0mPds4zbqLAs61ubA=;
	b=TMBdOXHRnYrdiKL6mcKKDFF2AmJUB5FRrrZAjuc0zEgfnh9AZ/D576Gh0HlWoQdX33suYH
	zaIqfIUp6QAF4vNPej+cvlLepd8sidz7/fQMtF8gJo9RWmhU9rIOzjsCipghKpf329RSFR
	fwKxeHzVV2VhFUyJB10gSMXIYvUdfeQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="HSm/n18A";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794652949;
	b=Z2MVrJF13KEsC3CC+z/x6GMea11jLIF5dXCQBcwB8xM41plV44xvRUaMfay1z6GWopeE2i
	mMALZgYrmNQGGxgtKzRS+cKrgcmv0eHHmvdPA9rerJxMBT2yXLRS68RAtgT9KnEfZCsFLL
	GagJv1UprydbeBcVz7GEMYMIiABTQ9o=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-36dbde64409so2805917eec.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794652947; x=1795257747; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=99ZqQGXUzLhB02hNr3DGsqAO8D0mPds4zbqLAs61ubA=;
        b=HSm/n18Asgd9XwFWz1ONOAj/Sv+4TiPmMW0Gvx++7/AN4JFlz8imlhbBFHYTw/aXx1
         vk5X0fNidp0fPWfO14x1W/L9kwv2ZyVBiTUgkdHZ1MUH+MqTn97MUgS7Jit7xCRLcz6v
         Oam0jFrNT8P/sanMSc7LIyVPn2EY6+Au2q2PhH+BuXxhFLIBmZO982swGdycRSASNpPg
         XmYNEaxTUyhXr9+v5Yc/fY9mGDgvnOZOO+iznqXWJzx69Wq62roO5vcJ60OVTUP8saVY
         O0WD1U1yQsE9eS3noovzz0gP3vvhg2tiaKAifSUXasTUH2RpdG77k+Jup/t3d9yv5ddT
         oBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794652947; x=1795257747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=99ZqQGXUzLhB02hNr3DGsqAO8D0mPds4zbqLAs61ubA=;
        b=Act8R6XXyjMgiK2UHE9OcaBeW40vuboYl6TVvt5FjoTfv8cLO/i1iHxvIAhuF7IoZR
         su3ToZJI6n+X8R5TxwYml0f1N9v+dAMtI8IwJm+9diGpfjnvkV2gJIFlIhP6ZhDZnBxk
         4pqVf5MJ0TaXv9F8GjdShzru9Ar/otdQ6SnM8giONMYPAxaFn3/Su9MGm+UVOp9B3hZY
         3iFOqc30TCa6/uyjeGCWIxBHL0BNjalMO/6zrVxHxB9YJ2bI353AqDoiyciC9o+EjD0j
         Yg7p3cB2yOTD43FFUU1Wj7C1ZpF2pwxFtmaYlTx20B9W9O0tIQKQzEou9B0vblyy39bT
         cZqw==
X-Forwarded-Encrypted: i=1; AL+hErETHtA5V8QW+cdFpttYpeePo2wg6TuQMVBuG1yLVjIRuoZ7H65Tsptjip/n3O9WIwWXoHgU6rYW1Q==@kvack.org
X-Gm-Message-State: APuU4Z/YveNDXv7xlRKtIrnLKJjDqrahF5k3Zjgkts3VtsDsqoAcRh5A
	eeheuQWyKeZ3NTwMk6hgVn4jwO57AQUnEhskBht8PiWLFcEZKBupz7DPzhFlQNqGW8g=
X-Gm-Gg: AYBFou1aioAo4jhrd+tNomA9lQju8MQV5JXJMvtIx3odhjzFgQhxZg6a06hhNCxq+dN
	bcsjpY5Nc2ZYxCQXTokugek7/qWgLYIiMBinTNbg5iRvGgJT5b9tTl3DepujafB4ZvhS38c1UeS
	pwMaaiMqRFuOrN4Z03m3eDRuF5mSkWlLHFlgqYcUkYBLjb87Q2THFbdG3BhI3XOK73YVrDDAopL
	CpQlfO9alL4TPT73rj5c3UlR8eNC32mBr77vr04VV1jefsOCkrihCrcnFDNDbFJG2B01+88Yk5Z
	kkRgpGXrHTXPYyFT7H5J8nU38YlX2sTXvxsEo/rIwfjgg7eXmAIlmw1uoeponAIo3wtjwTyB1Ss
	FcJpxxin/c45ZIWmWjqXPPCI1NqcvbzeCgM+xPEnaQAw8JWze+DXbRXqTSegA9MsFauH6EcdGeV
	u0I3l8IuxWDEaSO5VIsAjWWuCQN/OS0bYqqbsyM5q5zo0ddCbmq63GMDt+lES/dHnQst7wQozfr
	tZs77Ou8ShBHPVd5LM4mEkT3sVkFCZ9hEHSP/CajYFN/f/522txWfPeGKNt50tnNGy0TCctKv7S
	hmkS1YfEEKV5pH0B8HjY77Li5XXL+r17OU/I4VphAP1zSBu2ViM3yYUVCcyd
X-Received: by 2002:a05:693c:414f:10b0:369:faa2:1fb2 with SMTP id 5a478bee46e88-37965f9c4e4mr5541101eec.8.1794652947179;
        Sat, 14 Nov 2026 02:42:27 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:9d36:3b30:f4a3:7b5f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795533170csm15772917eec.7.2026.11.14.02.42.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 02:42:26 -0800 (PST)
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
Subject: [PATCH 1/3] kmsan: encapsulate per-page metadata access
Date: Sat, 14 Nov 2026 18:41:47 +0800
Message-ID: <20261114104150.58424-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261114104150.58424-1-songmuchun@bytedance.com>
References: <20261114104150.58424-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DA9DFA0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fiqx5j581t5a5ydw6fdhh19mpbmypopk
X-HE-Tag: 1794652948-565760
X-HE-Meta: U2FsdGVkX19CMdkC3DSOivGcepS125IsT6SC6cmSta69t7oSRLyG1E61bRpfxkJ0wRGcWMGks9YK/mbdL2ZpZ3v6ergA9yaZUzixS35QcJlnXeSmN0R1c4uBH6jdEGAYi61cjsrt6rID0sstu7mg0RJ0fszcNz8ImT9+sfviey9HHg8vUtUYpcCL6bqCDv08ApQF4iHz6RnVXRtdreINenFPK250V8G02nkHl7i/eipf05c/HJKruId0zfOWrWsqDBJ8Y0SfHOGIc7GKpCPPoNrxTVoHxybXeAZxUIRH8xkrSjGecfI4NPXieCqSNp/AEb+jzjIdclmhyMu2kHidAdgFDf4STMp3vUu1ZyTZZg8ExlENAWTTWfOZeaMD/IgrZAabUtmD+QCCFm0WQvs+NQp0pLb7YS6tE27ocuyS5CtepIIwsBIwgThjJZdCjqfAWlnzlb76mzmHrzDu1d+Tbbac64oYvu6LGLNChEJMPtVoM7vCbBWQui1XWeYJhgc3dsAzMgKgVaQEJp7SqUg3CilxzRLnv7DP40rhnGdNUJCNagWwzsP/+TcsMRar1GCwVe6VRvez05Woh2Q96hhscbx5YmJP5WQyl1P33uPDaEl0K4RMuwXguzSJNW65MJiFg3IfVdNMsFrECkWVL8rzUE3xrToYc322MJ2UsFCLeixdgr1tOq3k+ifsrds1h32lzio55YBR14nxVaHjZjxFAqVuabryl0DuFUBjq+nnQREWBDJJnMjRMZscBPE6TSk9pRdah2bKaoYBqSzTKVFRXYc2ZjcuyiQXT0/GIy9i1E3wQ4QaHxokzuosLrxzYi6ptw0e8hdgjJ9+XClnrkhhIdm0F619BBvdlLHrCUddCu2wkS5C41eyIg05ok+OI0YEmY8pvTQWMoMQt+M1myU56LNOQPoGdx+ZI9r7tJMQrZ4pIA4DQ+42Lr7nEdwAtl0tPwqbqq8Pzpd+kd0IAJ8
 5RIqQDgh
 UmG/AlUDPi6I75zrV9i4DH6hZdFvWuFW0sdd8EGJ8h03DdvmtVqr/4BgC6cMYpAeys70076g+xqvN+ktVmdChVRKF0KIP+jQFc4auYOjMy8hzj2AQJ68ZRYQc5jsMP0GjIuLUgGxeRU7EEagGr93cMQSIPdR++iahrWYwe5cAmQunABOCZIi13695ijWJ14qvFTe/aFAnT9blafQG+Q3f5QsbKhh9mIk2aHQuO0txl8uQcLqOY16xp1iXKXQ7GTqoL8Pd2KeSb0euYKRgGc+ejNKl6wuHzcf29c/OS1iGnpl6ylXy84emlAtGm4uLRe4SXfT+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KMSAN accesses the shadow and origin page pointers directly through
struct page.  This spreads knowledge of the metadata storage across the
shadow implementation and makes changing that storage unnecessarily
invasive.

Introduce helpers that get and set both metadata page pointers together
and convert the existing users to them.  Keeping the pair together also
lets callers avoid duplicate lookups once the storage moves out of struct
page.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/kmsan/shadow.c | 86 +++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 29 deletions(-)

diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 0c88d89bf0d6..8922d1ba9a0a 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -20,29 +20,43 @@
 #include "../vmalloc.h"
 #include "kmsan.h"
 
-#define shadow_page_for(page) ((page)->kmsan_shadow)
+struct page_metadata {
+	struct page *shadow;
+	struct page *origin;
+};
 
-#define origin_page_for(page) ((page)->kmsan_origin)
+static inline struct page_metadata get_page_metadata(struct page *page)
+{
+	return (struct page_metadata) {
+		.shadow = page->kmsan_shadow,
+		.origin = page->kmsan_origin,
+	};
+}
+
+static inline void set_page_metadata(struct page *page, struct page_metadata meta)
+{
+	page->kmsan_shadow = meta.shadow;
+	page->kmsan_origin = meta.origin;
+}
 
-static void *shadow_ptr_for(struct page *page)
+static inline void *shadow_ptr_for(struct page_metadata meta)
 {
-	return page_address(shadow_page_for(page));
+	return page_address(meta.shadow);
 }
 
-static void *origin_ptr_for(struct page *page)
+static inline void *origin_ptr_for(struct page_metadata meta)
 {
-	return page_address(origin_page_for(page));
+	return page_address(meta.origin);
 }
 
-static bool page_has_metadata(struct page *page)
+static inline bool page_has_metadata(struct page_metadata meta)
 {
-	return shadow_page_for(page) && origin_page_for(page);
+	return meta.shadow && meta.origin;
 }
 
 static void set_no_shadow_origin_page(struct page *page)
 {
-	shadow_page_for(page) = NULL;
-	origin_page_for(page) = NULL;
+	set_page_metadata(page, (struct page_metadata) {});
 }
 
 /*
@@ -124,6 +138,7 @@ struct shadow_origin_ptr kmsan_get_shadow_origin_ptr(void *address, u64 size,
  */
 void *kmsan_get_metadata(void *address, bool is_origin)
 {
+	struct page_metadata meta;
 	u64 addr = (u64)address, off;
 	struct page *page;
 	void *ret;
@@ -142,28 +157,36 @@ void *kmsan_get_metadata(void *address, bool is_origin)
 	page = virt_to_page_or_null(address);
 	if (!page)
 		return NULL;
-	if (!page_has_metadata(page))
+	meta = get_page_metadata(page);
+	if (!page_has_metadata(meta))
 		return NULL;
 	off = offset_in_page(addr);
 
-	return (is_origin ? origin_ptr_for(page) : shadow_ptr_for(page)) + off;
+	return (is_origin ? origin_ptr_for(meta) : shadow_ptr_for(meta)) + off;
 }
 
 void kmsan_copy_page_meta(struct page *dst, struct page *src)
 {
+	struct page_metadata dst_meta, src_meta;
+
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
-	if (!dst || !page_has_metadata(dst))
+	if (!dst)
 		return;
-	if (!src || !page_has_metadata(src)) {
+	dst_meta = get_page_metadata(dst);
+	if (!page_has_metadata(dst_meta))
+		return;
+	if (src)
+		src_meta = get_page_metadata(src);
+	if (!src || !page_has_metadata(src_meta)) {
 		kmsan_internal_unpoison_memory(page_address(dst), PAGE_SIZE,
 					       /*checked*/ false);
 		return;
 	}
 
 	kmsan_enter_runtime();
-	__memcpy(shadow_ptr_for(dst), shadow_ptr_for(src), PAGE_SIZE);
-	__memcpy(origin_ptr_for(dst), origin_ptr_for(src), PAGE_SIZE);
+	__memcpy(shadow_ptr_for(dst_meta), shadow_ptr_for(src_meta), PAGE_SIZE);
+	__memcpy(origin_ptr_for(dst_meta), origin_ptr_for(src_meta), PAGE_SIZE);
 	kmsan_leave_runtime();
 }
 EXPORT_SYMBOL(kmsan_copy_page_meta);
@@ -171,19 +194,18 @@ EXPORT_SYMBOL(kmsan_copy_page_meta);
 void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 {
 	bool initialized = (flags & __GFP_ZERO) || !kmsan_enabled;
-	struct page *shadow, *origin;
+	struct page_metadata meta;
 	depot_stack_handle_t handle;
 	int pages = 1 << order;
 
 	if (!page)
 		return;
 
-	shadow = shadow_page_for(page);
-	origin = origin_page_for(page);
+	meta = get_page_metadata(page);
 
 	if (initialized) {
-		__memset(page_address(shadow), 0, PAGE_SIZE * pages);
-		__memset(page_address(origin), 0, PAGE_SIZE * pages);
+		__memset(shadow_ptr_for(meta), 0, PAGE_SIZE * pages);
+		__memset(origin_ptr_for(meta), 0, PAGE_SIZE * pages);
 		return;
 	}
 
@@ -191,7 +213,7 @@ void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 	if (kmsan_in_runtime())
 		return;
 
-	__memset(page_address(shadow), -1, PAGE_SIZE * pages);
+	__memset(shadow_ptr_for(meta), -1, PAGE_SIZE * pages);
 	kmsan_enter_runtime();
 	handle = kmsan_save_stack_with_flags(flags, /*extra_bits*/ 0);
 	kmsan_leave_runtime();
@@ -200,7 +222,7 @@ void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 	 * to just fill the origin pages with @handle.
 	 */
 	for (int i = 0; i < PAGE_SIZE * pages / sizeof(handle); i++)
-		((depot_stack_handle_t *)page_address(origin))[i] = handle;
+		((depot_stack_handle_t *)origin_ptr_for(meta))[i] = handle;
 }
 
 void kmsan_free_page(struct page *page, unsigned int order)
@@ -238,8 +260,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 		goto ret;
 	}
 	for (int i = 0; i < nr; i++) {
-		s_pages[i] = shadow_page_for(pages[i]);
-		o_pages[i] = origin_page_for(pages[i]);
+		struct page_metadata meta = get_page_metadata(pages[i]);
+
+		s_pages[i] = meta.shadow;
+		o_pages[i] = meta.origin;
 	}
 	prot = PAGE_KERNEL;
 
@@ -289,10 +313,12 @@ void __init kmsan_init_alloc_meta_for_range(void *start, void *end)
 		page = virt_to_page_or_null((char *)start + addr);
 		shadow_p = virt_to_page((char *)shadow + addr);
 		set_no_shadow_origin_page(shadow_p);
-		shadow_page_for(page) = shadow_p;
 		origin_p = virt_to_page((char *)origin + addr);
 		set_no_shadow_origin_page(origin_p);
-		origin_page_for(page) = origin_p;
+		set_page_metadata(page, (struct page_metadata) {
+			.shadow = shadow_p,
+			.origin = origin_p,
+		});
 	}
 }
 
@@ -302,7 +328,9 @@ void kmsan_setup_meta(struct page *page, struct page *shadow,
 	for (int i = 0; i < (1 << order); i++) {
 		set_no_shadow_origin_page(&shadow[i]);
 		set_no_shadow_origin_page(&origin[i]);
-		shadow_page_for(&page[i]) = &shadow[i];
-		origin_page_for(&page[i]) = &origin[i];
+		set_page_metadata(&page[i], (struct page_metadata) {
+			.shadow = &shadow[i],
+			.origin = &origin[i],
+		});
 	}
 }
-- 
2.54.0


