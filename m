Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DC4C44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092576B00BA; Fri,  3 Jul 2026 08:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36BB6B00BB; Fri,  3 Jul 2026 08:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F586B00BC; Fri,  3 Jul 2026 08:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD8FF6B00BA
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C41F1A0551
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:21 +0000 (UTC)
X-FDA: 84947403282.07.A697A7B
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3404C0006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rY29zB7P;
	spf=pass (imf28.hostedemail.com: domain of 30atHaggKCKAJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=30atHaggKCKAJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081939;
	b=0qiJUw7qg/69Kx3zp9AmTHhXTmNUkbDq/eYQw17GBw1cYCZ8hxMDWvngGPza6sQD21NPcD
	W9QhB4ts6oDG5EEgnkLTLKRAVGTfk2asq2aeROl6E0sZqczAeRMADQqN7avY0Z29AJTY8b
	yzbFaEs73R4/s3yp5stEL8gctAIbDCk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QxpluEDl6Bvs+YrJCKdo0lCaCsO0ieanT5jt0bN1dTA=;
	b=7HTlUTo51Ga9pOz71vP/kjyo5NthyAn+SCh+uDOK23EKpZPTxcLCeyJBcTjK4pbDTKc2VT
	g91eanu5z/0m4sslIVViP8xXzaDrjKDx/LEkpBhnCoTOOS6vj2AM+RcpV7Qexmeq01YNMj
	cd7J+PMDx7/W3nyp2XVoD+6/MirAIEU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rY29zB7P;
	spf=pass (imf28.hostedemail.com: domain of 30atHaggKCKAJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=30atHaggKCKAJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493b0a5e636so4775405e9.3
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081938; x=1783686738; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QxpluEDl6Bvs+YrJCKdo0lCaCsO0ieanT5jt0bN1dTA=;
        b=rY29zB7PH8H/67et1BqnN3zZORigl1MCEB71XO2t6xmjD1Outvs97rQFC1vUrnlxOn
         1CsJhoFOy8JIZZyvy2JjY6DG4rCXhJDk1cjG+L++ZAMX15nBAIpY37x+q71VWM2nGMkY
         CPX6ciz7Vj84W2mNryQUDBC7ts3lYNSEs5N/mw7R/yPQbqX1fs12u8nq2m2GoIokowPV
         l+hoWR3R5XR95vLKprZtuO9gP6dployI0/t+CZhaR6B0WuY4Zpz8o/J6rOAvcGhAajVi
         rzfS7E+FSviKiiC9Aivihv3ATdYO7mFh4iR5scMCmCly6iz/tegW1I31CQdJWN1qoqYS
         vwdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081938; x=1783686738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QxpluEDl6Bvs+YrJCKdo0lCaCsO0ieanT5jt0bN1dTA=;
        b=IeeRDJUEGIgwoBo55513eD7ZNxIfsspu3hicOp+HJj+9P1Pyin8eMsncQvByjHBU/c
         mG4Y+2BFM4jWjfcodekP49K0H1gtKJLEGLJwYhKiXxgjfFzAzFn9s9gweL1hTYM57dQq
         YTd2Yet6QTO45wgyXcwhSFy20+lBFrqHkaqsBNwS7/ODVvWbpXb79suB1BFSw/+ngiTq
         ln5cNE6N7SAI/sueZH+kpe6i1OKY+LdNFf3ebBQrZcS6SWcz6xCbu4TX2bNUmzolJyAQ
         gHUxwSEPbnqBpoEAemtT+Dsth3YScC9ybZ2YujFi1e0L8ZEYAjy21hf6cc9tTSRaQlGJ
         5Baw==
X-Forwarded-Encrypted: i=1; AFNElJ+MqFbSK2Gkx1tmPFwgsPsfzbvmdTQ2b3ENOS5g3N6M25aCQc6xhZb5n5vGp8Z13YVck1g2bq+HGg==@kvack.org
X-Gm-Message-State: AOJu0Yy74WrXB/h9lXph3hxfUCLiu+ue9MdP0a/Cs74gsvxH9arVHMYq
	4xBBMyMqGgMv7eA9RuLpA6UZuCN9TUmapA5BqqUgnBDdR8n2sQFXhOb1ogsN/CRoOgkGqj2SPKD
	fciqisk1iqA+JcQ==
X-Received: from wmqn2.prod.google.com ([2002:a05:600c:4f82:b0:489:1b01:386f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c1c:b0:493:c1a1:68f0 with SMTP id 5b1f17b1804b1-493c2b6e672mr171824055e9.20.1783081937799;
 Fri, 03 Jul 2026 05:32:17 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:41 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-1-c87b714e19d3@google.com>
Subject: [PATCH v5 01/18] mm/page_alloc: rename ALLOC_TRYLOCK -> ALLOC_NOLOCK
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
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A3404C0006
X-Stat-Signature: 36bjkprrn5oku176eu99y8y3agmg45ts
X-Rspam-User: 
X-HE-Tag: 1783081939-330167
X-HE-Meta: U2FsdGVkX18m29eifgJQbszl9GmlYPv5dxh3SpLY/NS2ukl1G0Gu9SLAOiSnFuL7FIlyF5xvzySpDNyGJ4Eoa56KlyAZekvbfCna3NFAQ+rmJvTdjWOpxmDlxgabRt7fO1miVOBOAplKsi90I/RGkbOAi/kdwuJ3klSKBjrbbDhxsHBpBNZ5ZycxejTSE1vOm5ChbU0dBhWXxYReXLvUCnu7KirwJt7aqiTSUpIdilU1EaGqwcQ/PYQ8ZPSL8kiMEz+ISek74d+Zd+RdZLjh1gzZXlqV14NI/GBivrIJE1L+so4ggtw4flklr3KGK11gS/WLuK6Ah2lUhjcvaIhkjWcJaspe4xWliZ/u6Cu68Vy7xp+ABym+xa4RN/njTL6dMm2WUIOksQGq6050PBZ4ByOTWFeAu0Mwy5Jy7jg3fTnLfvsLb6GT4atcY+BrejyIjABfldAC4yJ4UBxlKIo3exuI5pg8L92rdVHmvwC2EjVmtvVFERnVeoZgnNwjWJc+flWBdFsLIXv2zStVy/MsWp/2u7FP6ONq4g+6/oxl1nkuQpCZXBim2rOZlT4ZEdretDphRJUdgV0VJm0gIN1FKHJHite5RdMFiKIyC2/fXwRbxxh3Y4F0csImr9XPQiHv10DKBzKXGR+DYQsM0c9D1JFotRt+kkRUpt48PfE1pP8nURQhUnHMiXpxwRJpnjuzlNkdf9j8NkOP+zfFGNsNLMgGSduca9+F/815enxNqsEiwFE93OYWpEaTxo5lrjK5IWNNQPbzS0W0eWqlcR9dVmtSolIBjHqhdwMmnejJBG2azhDlr63ihkC1MJmYVOUyiPw81FIoKdUkwULJAGNwYaNKYa+sJWQ7MbYMaQ3NtixuITdDe4b2a2z9m3Ju6HAcl2hNlBqFPvwqcrbFszLF7QahOAQbFEmEmzW4iGtGLVX5jzVdXxzs2ltfn51Yp6DDz8uush2JKr6krNVaA3S
 elZE4q0R
 tSDI3OkBGQlKSToGFrUH2+gKuU34wXJhvsLLfZlpIG9WYrSuPodmk5VepGln05jDBJ4eUlWvChnGY4b4NaMN4zcqHTb+JayAx6e66AhoZl0Z6HLGl0CV9djCk/B0x54VBfaRCzr7TxsBi0PLeHxTuGXGz0YdRZm1kT4mqt8x6e28zlHcGxwIbtd3XT0bX+PY7xYTPqQBRLNUBqm9s58EGDEY8wrwuCwXJxvxle3EZnw+OMRWKab07awB8UywRx2xtYmf08npw7iVWbVH5MBLEqJLyQMFgzm+glc539/hYQV5LWOsRn0w1YTOKk1A7OrAsYQL0CrXEalWbtdj4GXz6Woj8KWJoK3gC9N5WxjZBprDUm+vcYQbpFF1erA0bwX8RlAdH1nmCEh8d243AiczVrmuRsyJO6+QIEOx/WMKivM9+VuJggW35RjPP5drG3aZJmj8hYBQwdqwwDJ8qmPD4/BMRNsO2+KPRm/59o9wLmP6p7S/i4Tan/2UxadinVOsvEzrz3uVAkvrQ+8mFJuQRlGD5zdgFdNeURDtksI4m2jmIfAtPE/R7ycNYlvuIIEqpbWufVGhflj54gQYdmdeFszoXY/b7jVPcKJAm1pyNZLuAewlW+grleVGgsJmWis5s5dI0MO+O+3Ao0mMUdwOy61vMbyT7Mod4FzVoGp5pgD5xLyAoRXdEJ8Ou9Dgys7hkrL7r0KsKdX5E5/0=
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
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h   |  2 +-
 mm/page_alloc.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index fa4fb69444ecd..a2b09a13735bf 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1480,7 +1480,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_NOFRAGMENT	  0x0
 #endif
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
-#define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
+#define ALLOC_NOLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 762d9b6bc792f..6004fe6583d47 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2530,7 +2530,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 	unsigned long flags;
 	int i;
 
-	if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
+	if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
 		if (!spin_trylock_irqsave(&zone->lock, flags))
 			return 0;
 	} else {
@@ -3218,7 +3218,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 
 	do {
 		page = NULL;
-		if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
+		if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
 			if (!spin_trylock_irqsave(&zone->lock, flags))
 				return NULL;
 		} else {
@@ -5059,7 +5059,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	 * Don't invoke should_fail logic, since it may call
 	 * get_random_u32() and printk() which need to spin_lock.
 	 */
-	if (!(*alloc_flags & ALLOC_TRYLOCK) &&
+	if (!(*alloc_flags & ALLOC_NOLOCK) &&
 	    should_fail_alloc_page(gfp_mask, order))
 		return false;
 
@@ -7804,7 +7804,7 @@ static bool cond_accept_memory(struct zone *zone, unsigned int order,
 		return false;
 
 	/* Bailout, since try_to_accept_memory_one() needs to take a lock */
-	if (alloc_flags & ALLOC_TRYLOCK)
+	if (alloc_flags & ALLOC_NOLOCK)
 		return false;
 
 	wmark = promo_wmark_pages(zone);
@@ -7896,7 +7896,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 */
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
 			| gfp_flags;
-	unsigned int alloc_flags = ALLOC_TRYLOCK;
+	unsigned int alloc_flags = ALLOC_NOLOCK;
 	struct alloc_context ac = { };
 	struct page *page;
 

-- 
2.54.0


