Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E4C8CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767106B008A; Mon, 22 Jun 2026 06:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E676B008C; Mon, 22 Jun 2026 06:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BF66B0092; Mon, 22 Jun 2026 06:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38DC26B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:01:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA05D405F0
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:45 +0000 (UTC)
X-FDA: 84907106970.27.934F1B5
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id CDED0100004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ImtwPm1Z;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3BQg5aggKCFI3uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3BQg5aggKCFI3uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UneJ0hQ9IswDca+FJXWZCL3Fj/wq6Co0/EBHWSTe0wU=;
	b=5uuaOULA7/S3JOaxtLrfZ5Hp0SOd2gt7o1cab8ztlJpLM3HevskUhJ5dc/O/GBNCW0tPc9
	W5rNRfBJ3fWcmdS57coFOWMRrSGgDosqGktqw68hpqT6GCq1xnrRzZeWRktbHfPLOAlM/P
	HViWJnnpG9TPwY7Ikb/sSIHlV03OnJ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122503;
	b=TyOJotJgW1X3gPJ4bhB2uUMYuK5V+6ho7ocZXsIs77F6eHbibKWeqUH6rxldo9nDbVBOPG
	jhz6QWYmxVLNFWkt1hbU40xQOX0f+cWpgnAxQQWK4WUBhCYofe48kC/yP6171EPgmhsopY
	3yzO1nmuv2q7IDpwkJ/Y5d3AvDVqKiQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ImtwPm1Z;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3BQg5aggKCFI3uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3BQg5aggKCFI3uw46u7v08805y.w86527EH-664Fuw4.8B0@flex--jackmanb.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6960fb32b73so3714503a12.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122502; x=1782727302; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UneJ0hQ9IswDca+FJXWZCL3Fj/wq6Co0/EBHWSTe0wU=;
        b=ImtwPm1ZZkf7/tWBMW+cOtOLa/aTkIN9OiBe5VkIHYAMOdoWFENxDxh938zmHKZ6nb
         nEnSpDxYY88Q1PzCxqHj4eVlf0/1ChGrEX8NMcZe78gKAxVAW0ogNsBubC5nAeTA6nca
         nguqJCKwjq6COjvYG6RWLdEh4GTo+y5lNq1L2Bde2800xwqs50SOkgsflFj1wdaYRpCj
         d8omJU8vJxf9+eGACPs1PP0wd/soVWf6GuZjnOsT4cXl/++lDFwM7yNV0Cp9opNHZJZ8
         7jomPCV6BgKO7lnXaYacm8SNe4M6RVTdPHkcVXHTzOq5iapNd4Vy8OA9cq9hWN+UKBfc
         LUjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122502; x=1782727302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UneJ0hQ9IswDca+FJXWZCL3Fj/wq6Co0/EBHWSTe0wU=;
        b=jt6R1CuirbaUpgOBRJrVp1W4Qx/c3lVP/U+dV6Zoz3KXNqpbOazsIMuX9I+1vpbbUa
         D5bR4eNmDYTl0E9p2HrNdF+3qIPixncnFa8ZVvDpWWnlwKl86a6pKZgnk5iIGkyq9SM3
         M/3s4r4jXNZnBrHqDGafV3Kry4hfuR+bdb5NGTFP1KNJwW07NOWgCZd/ga7wO8pmIKlv
         W13qGf2Sy+F7kB30vI6+faHZovJw72N3D7d6UhpE90nZG0VNHCY+wtJ0VacrrOh5zvvE
         goFjbqslfLjKG9YaD9Sg1O00s1itfaNLcrOIlWod/xKLYObeJ9OrR04CrpTTKe7n9WX9
         Khmw==
X-Forwarded-Encrypted: i=1; AFNElJ+Hr6PWwgPJwaNktYti045crcYUKD554v+uL1Mv2H4pMAnqIaCabp0GkGWnYJeYaiGTabn8xVDDag==@kvack.org
X-Gm-Message-State: AOJu0Yx44GdufpQ8VsjdUNOUwY8HI0tcgeNdQa1PoarSq/Ik/BIqImR0
	eGeS6OdXRqAflcYYYrXVVGAuBorXq/Dp3wLL/jnvi6KtOM9Vvx/ciJQ/xWNeeUcGGDV8seAyItX
	+JqrfykFrB9ouCQ==
X-Received: from edsn17.prod.google.com ([2002:aa7:c791:0:b0:695:c3e8:f517])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:400f:b0:697:be39:606f with SMTP id 4fb4d7f45d1cf-697be3960f5mr844476a12.11.1782122501844;
 Mon, 22 Jun 2026 03:01:41 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:28 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-1-31f31367d420@google.com>
Subject: [PATCH v2 01/13] mm/page_alloc: rename ALLOC_TRYLOCK -> ALLOC_NOLOCK
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Stat-Signature: 5qqqkc1854ityirpqnq44kwnfbajw34b
X-Rspamd-Queue-Id: CDED0100004
X-Rspam-User: 
X-HE-Tag: 1782122503-518714
X-HE-Meta: U2FsdGVkX1++nJuwNS7KHHrYvPQSg8sH5nzoe6pXO40Fhnq0r0m+Jw1Wka4DoeBWyrPRZIkNjoQWBujd2j1pH/nR2q8UE5Udn5b6THHT2s7tVi8U0mKnmCNfNZAF/7eH5xL3gWnC8I5vZAnNzaWjgjURRMO7QuJQA3qZ/XQyYlCPTCDeTsqsvIa89UxCNhD+/G+7pjwa94P5+/2QPKuHzxYpz94C11huuCO7Whzsp7ByLG+iVhPzeA6bIZc7udnXzVk9Zpp1j5wX95wiSnPnQ3flq7CAnzwGjMdfzyW6/ndUHxtF6opSDwkMTiy3FsxE6ERDZTa6jCfb5l1j31c4avyHygDUTCVGGG2msYgQN4HTVR6PvsfLIKOUR50TnQp1XUG6+aHYVsNUG1oe26JmzpPQaAek/TVanIw2Z1ULAid1XYN0eXJIVeTzogle+YJgiQ2NDkQpoU8ReuptLimVt61919aryvEmMgfH0vmaOrQBACEZT3zEmWaV+dQgx24q/FvGwyY5VYMg0i+PoqfWBtYeszyPOyUIZUeGXXe3CJaqBXQerisfhGEfq2LIN6sQd8utmJ8K8P9BoBxJ0VLw0qzTeU5fo80U6wIfEg59J9ENeODyEwEEey87FjYjMj5aF2mKGR0c3bEFP8KtlB6wi9beoNHXumOeLzrqUxLaynQZk53jCAmw71arp16HGb0Xlo2IH8A/UWu+D2E1aWqFbYQ4RdsFeI9sCZSSHANpM83P0uyXrG+H1QlORDUIUu+uTgbw8MCaffw/NNk5J9CRSD/JddGeilTHCi8QGpxtCF8OdUZt7NyZWrvAkbpU1F8HfKsgvX63u21aXVpj1k5e8hmw8fqdRBM6uPlGXXFYs83eN85ZEx2f+C/blL7Etghm1pJ7z/B5wxFMaqdxNEgD0oggprsILsAtX6fvvy1lza8iteeM3DDxM82QtvJ6fmR7JLeo653Rx6nJYpkTg6x
 y6nhvpX/
 ODfFx6wt4qogkq8nMZ6NIMZA26S7J8HuCms0wJdD+MqLiXZfHNBShwlmJzw3idYk5c4S/tVV6LPY/sV2lS5YrSKBtIyfh1G9bSkKyoOVEIhkL2OXsrlU2s9K3Qg6hObkizOluwqvzOgCf47hI+wnRiYvw0DQkYY2ksSfGLGiArglQna6w525Vjx+IzHKke5shi9/K/IBt5mMdaM5sQt+z7YxDSprDkNmEr1FoKxh3wKueycOdyi8TJOvC8yO/LvMwkKInqQn0fdqg7m+d0dqhRWhMMaj4KAHzoeHg0AlLBzeODtV6qnVvUU28cFKSgJbSxRINzMHymr7aXwSG2b1+p9EaiGmYMi6GOAk9vhmYPg1cqjfBhnnAYvRnWGugdlbZzLXDWHKuiqoDv4RCQqS/SZZZT073bQfztjFaqaCBxpcy6moWGKHBCKJr/rLymAWScqH7I/IXutel9IL97vfOw/4J6y+0SIm9eFhPF0VR5Us1eDcHmK8NtSkm2hdVP0kIdkhVcbIcx7/RgqLBFBSTeLJQndmy6a4KIz0RJmoKXMO8G4hlMoW+VLKIfIeANR+irZ5l9Pw4OuSqR0W5eLSrEHjBNmKbBH10hg69/tdsvakVcsSwHR65uZt452fPUEa5d+VyxeZm7WuLuWo05vhydNi9ds/PsTERPYV561/jVxsCe7Lf8HAxa3ZWDY6iTWL+2sE1y5xgN6fuqXM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's confusing that the function is called "nolock" but the flag is
called "trylock", align them.

The function's terminology is more visible and has more mindshare so use that.

Suggested-by: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Link: https://lore.kernel.org/linux-mm/2399b3ad-4eac-4a14-94c3-27e9f07972a1@kernel.org/
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h   |  2 +-
 mm/page_alloc.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a20..1483a4fcdfce1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1475,7 +1475,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_NOFRAGMENT	  0x0
 #endif
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
-#define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
+#define ALLOC_NOLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0111cdbdb5321..6c4eb6908bd95 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2528,7 +2528,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 	unsigned long flags;
 	int i;
 
-	if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
+	if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
 		if (!spin_trylock_irqsave(&zone->lock, flags))
 			return 0;
 	} else {
@@ -3216,7 +3216,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 
 	do {
 		page = NULL;
-		if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
+		if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
 			if (!spin_trylock_irqsave(&zone->lock, flags))
 				return NULL;
 		} else {
@@ -5042,7 +5042,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	 * Don't invoke should_fail logic, since it may call
 	 * get_random_u32() and printk() which need to spin_lock.
 	 */
-	if (!(*alloc_flags & ALLOC_TRYLOCK) &&
+	if (!(*alloc_flags & ALLOC_NOLOCK) &&
 	    should_fail_alloc_page(gfp_mask, order))
 		return false;
 
@@ -7786,7 +7786,7 @@ static bool cond_accept_memory(struct zone *zone, unsigned int order,
 		return false;
 
 	/* Bailout, since try_to_accept_memory_one() needs to take a lock */
-	if (alloc_flags & ALLOC_TRYLOCK)
+	if (alloc_flags & ALLOC_NOLOCK)
 		return false;
 
 	wmark = promo_wmark_pages(zone);
@@ -7878,7 +7878,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 */
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
 			| gfp_flags;
-	unsigned int alloc_flags = ALLOC_TRYLOCK;
+	unsigned int alloc_flags = ALLOC_NOLOCK;
 	struct alloc_context ac = { };
 	struct page *page;
 

-- 
2.54.0


