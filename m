Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4F9EFD3776
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C156B00C5; Wed, 25 Feb 2026 11:34:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016586B00C6; Wed, 25 Feb 2026 11:34:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4DD6B00C7; Wed, 25 Feb 2026 11:34:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBC076B00C5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C55E8C1EA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:46 +0000 (UTC)
X-FDA: 84483527772.25.BB89EF0
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9902DA000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nOTnG2+6;
	spf=pass (imf15.hostedemail.com: domain of 3oySfaQgKCLwlcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3oySfaQgKCLwlcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5PV0mRurjScdHoadFixO8I03dLLk9ZHLW+ci+eIdSk=;
	b=n3lCOgqlci3N8SZrLoKsJoR1QEH5mFTd0wlNJHEXkmuWH+UbavL46ToV8aRiceUY62MjMg
	XA5v1UFS31lEDahMpcVCcSifTUrw8UqV5v6/BC5/lWtzTRW7TmbdAwx7Xy3uzWjaUZYTr+
	FboOxORSrMzUr89AFRSo1oxVLBmRhEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037284; a=rsa-sha256;
	cv=none;
	b=vbIlVbqtDCJ9f/mTZBuXJiM63tP8R2E53vlQJK4kKTFffY1LCn0R6lkzZmZZAHEqh0bTnJ
	krLJ9qCZj7c5VgkXb1fSqu+lf4w3x6BokTebvPEihhNYm8SRtXI8IkV06Wlx1urCLviMXN
	K2A6hTFzFNhGD+qhxkKYD/II/S88hEo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nOTnG2+6;
	spf=pass (imf15.hostedemail.com: domain of 3oySfaQgKCLwlcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3oySfaQgKCLwlcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-65fa61297e4so257117a12.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037283; x=1772642083; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F5PV0mRurjScdHoadFixO8I03dLLk9ZHLW+ci+eIdSk=;
        b=nOTnG2+6dqotf3zGtDS0EXKIh8QpapAcdahY7NiNF7mp5zWSNQwu1AyZeV7RSO3SYr
         /Baw9TKakSlE/p8pN8hUT64e/BR13jybfvya6GwYRd8opf+WMAWjAE6otS3aq8AFa6rk
         Phh9T0r51ptwjLp+Oo/Shzn8BK3XAVk2p0zpV0L5wAJEQyLmAJuYaP+r5TwXtWcS4Wrz
         58w3qyJgQEdfhVP4OQ1dKyYSbnBcwLt9BWVaczkTEd4VMXkc2dFUo8sgUQsr/E9Gfn/X
         sH9TodOE+rAk2F1nfkhIznOCjEudASGXuvJdfYJ1DikJVaEiIEEpuGK2UpCtgkaeQdZg
         dQ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037283; x=1772642083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F5PV0mRurjScdHoadFixO8I03dLLk9ZHLW+ci+eIdSk=;
        b=NQiaIARU9obzifGt+o/xuwXO4VP7M5+Y0yk9Mn3mnUqfwJeD3w0ZR5K+jC0IQiKVL9
         D+wAAiLtZzecSjiDCuie5gBBJhYw1qcfEIjjrmyiCOh7/hHTnCrzWzt63VhcFnCR62yM
         qoBIggDJq3C+NvEOniUbuO3+vFTkAUsKahn8qEY40At8863AZvBx1PJc8Qld7nQyAlBF
         iGfCC8JxYBH/YcyORbt7lLffvDccpC0voCUrbxkbST9dOzo1ErulYMj+K1ASzb0ajquY
         od6VpC89yJI6uHpNywcNzxxF2KhWg5CzlCkt3aTBWb52R3UkV4u1CMiJcNNl5kNHE3UB
         EzMA==
X-Gm-Message-State: AOJu0YwOya+l+QnNzpgy9mE3RvGKZMIQIN88JtsuRq3Ic6iXHE2cPFa+
	bw2rP4ZixCFQd3zqWsH7VNodfC/Y+g5RnA2RcQbidZFMbIzi+EQh8pPFZqaqJGLCaHRTcFJva/w
	evbvndq7j0IZEZQ==
X-Received: from ejbha21.prod.google.com ([2002:a17:906:a895:b0:b88:4922:9e97])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1c23:b0:b83:1326:7d45 with SMTP id a640c23a62f3a-b9351736393mr62821066b.32.1772037283008;
 Wed, 25 Feb 2026 08:34:43 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:31 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-6-e8808a03cd66@google.com>
Subject: [PATCH RFC 06/19] mm: introduce for_each_free_list()
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
X-Rspam-User: 
X-Stat-Signature: rfbc67frchyi5co97b9j4zn95rz45kuj
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9902DA000B
X-HE-Tag: 1772037284-858754
X-HE-Meta: U2FsdGVkX1+5o4CoUYixRvxH3KEbSCQPnHzjyW951sNq+9ku2qg9tb6EH+RKKRuy1F1QmITqGx9MChv+feN01W9kVK+2d33O2vnhZ+Kv9fzXjFqAA8MYDgVafSn13KxGWZuDk0cl8DFhg/Oz/J6hysnYu70lvk4va4tcAlu/sd0SWVGhMgVtrTvysyyiF7w8WjOJu/FobfLeb3pA+8j2Xh4Xs1wzsbxORMXNEHDlzxapbTeNr426LBlLbfstc8HgSsBYGpIpZEsuliT1i1aiF8pgGgGfDWgVdMV6Fz55EOtJfYCUq+6GNnasR5dext4hCiBRfiqAIreZuM6lV8P5N5ycJm8bxZA52P3ow7hkJDDR+djXP3RbhoVnBecsUXuf7tPOUEL12mywlhMR/7jULH2FupWZ1jMjZ1YSVfHCJin9Et/PomrQ2HXK+aOqEo3S7Vxl6ebJiOlt8uj9+XaRTcWTtWAtpOiKrHRXKQJcvY7+tKOk4aZzsOJWt8HuNpHjpKlxjzfAjy2jtCMUoYMGLFz+lkyZKGqDEXaMB+R718THm9Uwjqdoibji3AZBYXiBB30vcCmeELutAGW0XIfub0KdqgWQNkzIDdBs41YXQXt1AhqoO17iQ8VHAo3we5vd+/A0a1FqB6tLWpe5+3/3PibxLqFX7X6DpPqUrelItzA73c4AIxiZ+AIcSbp3r4PNa3uoFBQuLZ33PoXiBCkfX7M7kEVZKtsR6Iu1GUDQYHGlUhiqZRc5ZX0VyOUE+zHdK4vjZWwM5/2NDwuEMzmKT5QQqT5qewArFPSnbOVAMjpFMtmIpaXhcT13VKijj/dsnpQ+vwf94q/+AUkUWX84/ncOyZ9uGqzwxo5x9Xra4oUk4CvON+R0m68Rs0EG3BTLF5G+W3yGjXA+pNHIOF8KlrstLjqaGaaUrGfE7xeXJ7aRq6iLJ1uPD3jn8GZ9owyXU24YS8Fah+l4mlcO29y
 84iFk8MG
 dt2hdSDJQeng0gHT57X7Ek7nnByhz3BI6aX/scKrMsG0bz1PN04XPtrvLyz9CoFC87kLzaAr4Is8Qot6kFlr57XU5YoxeUVkooZb5sjCSmv/ylhDDuz9eaXfCMf0VcJ3E1nFZ/EPqi3sAzrycwF3ElTjlEslO69rOUdww1sMZE0gKReloUf1zJqC1gjXmcsoYJ28YUloGnTuMrD+TBuBo3mhuyxnEBo+lOCMGm63V0vPWNeuLwbLKBJyKw9yXbANrBokbavm1GqkD4NBscnalK4uJOdP/A8zyJVLHYeJk4LpvvFnG/8WKa/uOfHJjTgg+JbkH8fWFOlX+7x9hZSvA0ucjGUp8yvIyJJEKStGnmb7U2HeM3lDGgiDWJksr5J9f0pcwIHCyx0Ij6QhiktgmZV/W8PBNQL9TX6XKKEugFBB3EBiPzlxLhNXY6XSZyRN3N9FmLv7OThXn0RNpvpVEI1ZtQOpPAdGghVsVXNFEdmGOeumB+AUGcS40pT58ZYcS1Ss8VSwSv4fXF39TmpK2fE+eK2EtHlLlNyhzTICypZ3KNvLKSYM9XjWURuhEIfjzAITZsLp1Qqjhq3JYMdLwEImpIMlN/W8MOEYo9eEnSPkrPh+p1QBm1KRfL6a788+5TZKnQ6t5pnB5AqXKUFth5mHzcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Later patches will rearrange the free areas, but there are a couple of
places that iterate over them with the assumption that they have the
current structure.

It seems ideally, code outside of mm should not be directly aware of
struct free_area in the first place, but that awareness seems relatively
harmless so just make the minimal change.

Now instead of letting users manually iterate over the free lists, just
provide a macro to do that. Then adopt that macro in a couple of places.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/mmzone.h  |  7 +++++--
 kernel/power/snapshot.c |  8 ++++----
 mm/mm_init.c            | 11 +++++++----
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e51190a55e4c..fc4d499fbbd2b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -123,9 +123,12 @@ static inline bool migratetype_is_mergeable(int mt)
 	return mt < MIGRATE_PCPTYPES;
 }
 
-#define for_each_migratetype_order(order, type) \
+#define for_each_free_list(list, zone, order) \
 	for (order = 0; order < NR_PAGE_ORDERS; order++) \
-		for (type = 0; type < MIGRATE_TYPES; type++)
+		for (unsigned int type = 0; \
+		     list = &zone->free_area[order].free_list[type], \
+		     type < MIGRATE_TYPES; \
+		     type++) \
 
 extern int page_group_by_mobility_disabled;
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 0a946932d5c17..29a053d447c31 100644
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
index 61d983d23f553..a748fb6d6555d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1432,11 +1432,14 @@ static void __meminit zone_init_internals(struct zone *zone, enum zone_type idx,
 
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


