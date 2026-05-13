Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D2A4CD4F39
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28E116B008C; Wed, 13 May 2026 08:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9D86B0092; Wed, 13 May 2026 08:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105FF6B0093; Wed, 13 May 2026 08:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E9BE26B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:35:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A99A3A0B43
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:35:19 +0000 (UTC)
X-FDA: 84762341958.16.55A1881
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id BE12218000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:35:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TDJYqEvv;
	spf=pass (imf16.hostedemail.com: domain of 3BHAEaggKCE0yprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3BHAEaggKCE0yprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778675717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4WWLXd62Tgfh1ZCpYAiYrTX8S2ssjZcjbx8zKPYKSN8=;
	b=EERZ8p9L/5jyupvmFxkfc0wdULw/xSMnE9vcOGR19kX0v8xbx/Mdt60fkV/jyWcETwc0Zc
	3fk46kOb/IcHBA65s8JWkUfoQMhPE0hJcHia90Cys305TLZ/dYj8HhCtl5nNieMaXHqL9S
	MCmlbBwPDn6akCl2Uv4UhN4Wh3sJi8A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TDJYqEvv;
	spf=pass (imf16.hostedemail.com: domain of 3BHAEaggKCE0yprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3BHAEaggKCE0yprz1p2qv33v0t.r310x29C-11zAprz.36v@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778675717; a=rsa-sha256;
	cv=none;
	b=NpxWTxcrjtEAcj8TPRY4ntRGBUIjZNd0X4dzv6aLlALdrO9m/uZLz4ZR/Z3OxFVLkeHGCI
	BLrRJnNcniENXJBuUYeJ9xyT5Hogkmni3vgFJOx+As/8vPIqu9aATN9k8eQM/zumdDTK2i
	Rm6A/USVtVNjvbyk9ckzDXEFb77AEl4=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fd0f1ef7dso4429055e9.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 05:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778675716; x=1779280516; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4WWLXd62Tgfh1ZCpYAiYrTX8S2ssjZcjbx8zKPYKSN8=;
        b=TDJYqEvv+Hzhmy8nTHNSYGp5hvdOMvVLtDsXbA5MosJbaYEIyZXylESRHF49lpOmaY
         1gkxT1IOj2pyjyQnT8oNIlD+fb+dERdu7o8QAOqvTbJdzba+NW1vfiMt1nyJnNWTR7uv
         9RwduMTZRoCYjqXeP3j+xq+siX8VynvVsXmGqfoZDSP3zST1lZNDwKv5pdIXp4xfQ4v4
         IUMA1Y8TSqrD7RJq3cgDyxsTAyCQ5V5Wcq2FPOZqV4yiCLYeGORen+RPXNeLpaJEKrUa
         jZD4s/2ZmVjO7MMBvPL2wd32BE6rgWPpCF5T2prIH8a6SA2mnwwjVXx9EeFkuUq19+D5
         ugTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778675716; x=1779280516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4WWLXd62Tgfh1ZCpYAiYrTX8S2ssjZcjbx8zKPYKSN8=;
        b=Ijj7A1tMJoDysCtVVYEBti9h4BOQUaT4HxWyUJVlU9XH0irQjRFHF0Fe6FnlZ6Grh+
         a06n2lspLn9oLClZWaMuNceYnCXG4SlKTDI/jZ8/U+une2JvA1eDCZD6ZOs7IsnI3Gid
         w+2ZV6la5LwgZtstMECSaPcKrez8FKbjhBxw/khvZdeZLv+C0c6qQdY8tLNKaGJTlwzG
         Rh9js4i1AsZrYkO0U/iG3zQJYOTIuho5wQpuEue+WoieE2O7ky22UA0vmWk3o8ZLueWT
         dn015Q8AmxBgzb5bwwbWBJSGzj8TQA5Ws7Xs4NpX+9gNfLXf9o8Rf7rDxNVfiMpFaeSh
         7xKg==
X-Gm-Message-State: AOJu0Yxi3mMe6prrmOfrxQQDMi/j5i6ZwrYY5WRsXcbDTXVqN7mbJ8Yk
	OVGhcSNkENvrY1inFjUF66Qr6+vSh2UJowG3l78bp3psCwEZjKEw2tWeLv/ruUmQWJX7L4Y4s2g
	1TaNJNP+rBho49g==
X-Received: from wmpj8.prod.google.com ([2002:a05:600c:4888:b0:48e:914f:1eff])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b86:b0:48a:563c:c8c5 with SMTP id 5b1f17b1804b1-48fce9ab28emr38271865e9.8.1778675716013;
 Wed, 13 May 2026 05:35:16 -0700 (PDT)
Date: Wed, 13 May 2026 12:35:13 +0000
In-Reply-To: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
Mime-Version: 1.0
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20260513-page_alloc-unmapped-prep-v1-1-dacdf5402be8@google.com>
Subject: [PATCH 1/4] mm: introduce for_each_free_list()
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: fatun49iwnk8dtintejestuzh35b7zpg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BE12218000E
X-Rspam-User: 
X-HE-Tag: 1778675717-887901
X-HE-Meta: U2FsdGVkX1/6cW3v2H3Uv0Zs//EWQD75jtv2hJaP3Fv+e6rkXCP3QehmCpo0AtLHZ6GBl7rQmbBJ9hXIyQBkHWA2BlCfzzjr/ymnv4Hjzr9UZsu6qvDWzQIDVO5MNwwrXOTxHbGfkyTNP+E1aRPo2fr1XcwohpWHcMys19+xWvFaWI4G4HX1ENfL6DaZCjHtrBWvHlfsJucFW/g3i9Qkqz8iiG5mnq/6wR9Hwd1wXBKTp/smrc1OtPzFcB8CaZ+7ytQ9sBsw8jUVKdRsHbqppux3dBr+6BYyy3cNWGkQ+9zSZTLQQFDerkQsquNlpjdveKu+4eqPmqzco3TMhLgIa1HJel3s52sKduQIedFI3Wc7QJG7J0fai0Q5M4s6rRRvM61z/d0uU3+hyFhcxCcdJVg+fZ/oE33HnL2FncvWY31vxPRmkG15wP8QgApURRwH5mIqFcfmVzmT8PokJ9WPsOHpc33PCh9NeMQ92u6707VWfStbCU9MzG/1G4KDjea3DiRKh2ZTBDZcBBOu+KhSX5GmRtwvVLnpFgeVrRfBDr5JcQ5bW9L/V/ZFo5jXBNcklIYNfZcM7/7YeuvDhkSGzqC4Pk9zfu+qF+SAJjWcmZ576mssl/2C4FfLI74ICulK1ksb0cELwY/gi9TFljUngcyC0ysXo2xBN/1HcY3n+lWvgvcCyf57Jf6PzKd1ZQ6TxHkPKmkwr2PopXFt5x7l5+OkrQYfcE26BZMlhRlHnQNq4Pyydgyh6W3P+nvqIUMsAHHcX3qsdQYyjqHqez7qveEfloHqVZ7A8uPhk9ZEVhcQUtEDzqCH5ug9p8PweHKWGqeYx+7mUBTo/dB5QEA+0QCYO49s4OAK87dEdbMaH0LiGKYfAuVqHTaJNgTShcbQGtPH+W5oQPz53fMiU43P9eW/KH/3VOfmO4ixmYrd0bvZ7kvKEKOqgsff0DOC3T9sXyNrrstv9HZ9/EBVebw
 7SFOBWD2
 BIeFuBsHMmEvrDDh53Tr/Skxx8px/LqxyQYoRHWXVCn5PEVHy4h0l4wMY0nWn89McV/DoTjig6ekfjeaU3AaJeNzJf0sjDeAHeeFWKBGoN8GOl0TZg0z9SMA17zuFOEGOZVjiANoh6O0vHa+w736B9fi2DWjWjGqFieEpgmpL7IkMIubxkbZRMxGHABwWFx+Fhmn949TQHdfYKNnhd9UIkvFGs09TvsKtA+v3pcOZKAJSMcVVU7QX2X0Jk4nvaOhvSzI5UhUVeHIeawGCxPr4L/VwzvTVRNqwNf0YN+qkSjM7q0ScodhH3wC4k8uLAJAdBPWogwISJOY/28/8BOVtAWAAy/qutMPs+sbY96TX62vpJ2fPDkOHHNkdr1+F4T1DOqzsXevDUUe7dcjpOXhLIDU1CnH5gUwYxfRPZ7vh1DA6SO62/2HpIMLCEyoSCcoZGDqUITvi0/YUu8SkB/WvfjixkSBI83D5nLJPI7zXR/0Vjj+JwTn6VgCsrP2ecy9DWfU9fw8ttDpRlZWHxm1lZEGeNIFODxC4DncAMpWl4Wtns+wUSDCi0bCvwfuwwq4FXuae348CS2PH4QxL9I90hJAP3wQIVW4s50yZHBRto8syfAG/uP7kM8s3kZEJiOyy6IkuVW/qZqZFgy3aG56IgNw0+h9DO4JnzZFkQ5GrpbII7QVWylQBKoYMMhFgws++9aDX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are a couple of places that iterate over the freelists with
awareness of the data structures' layout.

It seems ideally, code outside of mm should not be aware of the page
allocator's freelists at all. But, this patch just doesn't hide them
completely, it's just a meek incremental step in that direction: provide
a macro to iterate over it without needing to be aware of the actual
struct fields.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/mmzone.h  |  9 ++++++---
 kernel/power/snapshot.c |  8 ++++----
 mm/mm_init.c            | 11 +++++++----
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9adb2ad21da599354600b48b4f3f9a4158efa049..1331a7b93f33c67c6e07df1fd8c5e4504dc28e80 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -177,9 +177,12 @@ static inline bool migratetype_is_mergeable(int mt)
 	return mt < MIGRATE_PCPTYPES;
 }
 
-#define for_each_migratetype_order(order, type) \
-	for (order = 0; order < NR_PAGE_ORDERS; order++) \
-		for (type = 0; type < MIGRATE_TYPES; type++)
+#define for_each_free_list(list, zone, order) 				\
+	for (order = 0; order < NR_PAGE_ORDERS; order++) 		\
+		for (unsigned int __type = 0; 				\
+		     __type < MIGRATE_TYPES &&				\
+			(list = &(zone)->free_area[order].free_list[__type], 1); \
+		     __type++)
 
 extern int page_group_by_mobility_disabled;
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index a564650734dcdceda7193ca3c1bc6b347cc1ec8b..d933b5b2c05d453bbda93c728136fc2a76758fc7 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1244,8 +1244,9 @@ unsigned int snapshot_additional_pages(struct zone *zone)
 static void mark_free_pages(struct zone *zone)
 {
 	unsigned long pfn, max_zone_pfn, page_count = WD_PAGE_COUNT;
+	struct list_head *free_list;
 	unsigned long flags;
-	unsigned int order, t;
+	unsigned int order;
 	struct page *page;
 
 	if (zone_is_empty(zone))
@@ -1269,9 +1270,8 @@ static void mark_free_pages(struct zone *zone)
 			swsusp_unset_page_free(page);
 	}
 
-	for_each_migratetype_order(order, t) {
-		list_for_each_entry(page,
-				&zone->free_area[order].free_list[t], buddy_list) {
+	for_each_free_list(free_list, zone, order) {
+		list_for_each_entry(page, free_list, buddy_list) {
 			unsigned long i;
 
 			pfn = page_to_pfn(page);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index bd466a3c10c8e204dddd881c5334364e3d47d612..db5568cf36e12b6fe52854b274fc331d9b36cac3 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1429,11 +1429,14 @@ static void __meminit zone_init_internals(struct zone *zone, enum zone_type idx,
 
 static void __meminit zone_init_free_lists(struct zone *zone)
 {
-	unsigned int order, t;
-	for_each_migratetype_order(order, t) {
-		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
+	struct list_head *list;
+	unsigned int order;
+
+	for_each_free_list(list, zone, order)
+		INIT_LIST_HEAD(list);
+
+	for (order = 0; order < NR_PAGE_ORDERS; order++)
 		zone->free_area[order].nr_free = 0;
-	}
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	INIT_LIST_HEAD(&zone->unaccepted_pages);

-- 
2.51.2


