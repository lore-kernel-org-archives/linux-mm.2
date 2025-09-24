Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4727CCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9916F8E0014; Wed, 24 Sep 2025 11:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942538E0012; Wed, 24 Sep 2025 11:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859818E0014; Wed, 24 Sep 2025 11:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7A48E0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37C8A1608CE
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:18 +0000 (UTC)
X-FDA: 83924454516.22.5AB9C4D
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8654D40005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jnMVG0va;
	spf=pass (imf07.hostedemail.com: domain of 3fgfUaAgKCCsQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3fgfUaAgKCCsQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTuaOxSTe3tk5TxQgOGSdVxjdMn4okuwwVefzm7d4xQ=;
	b=65hsow0I7F9IVdjfoZp+0LIFZtNgHnAB/cUdjdgdhkunQqAjeJ54fWxBNpZpr3+g24sojP
	gDI5riU6bsBZO4SvlvcWunSd5u33Ylnvg4JF3ywBnuFJhsRksnLpojmeB8gLHJQ986YWpn
	dxdXGVFGzHnlUVqklZ1j/c+uz6CkF+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726016; a=rsa-sha256;
	cv=none;
	b=ce975yM0DLwLLwLoXgNN94qix0xZW1zbsnCj5fkSJMAh4tbe7wd8QULiK4L5HGJC+dDaL6
	g5+GwT/pEpPAkBurhX6dfKOsiQwhyt3Wq1n+ifuJtAky/jr5FVFqIMzX8unfuUxoOiLG4V
	vL6QKMcpSrzHn+0kZw7sIiVb40jK4rU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jnMVG0va;
	spf=pass (imf07.hostedemail.com: domain of 3fgfUaAgKCCsQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3fgfUaAgKCCsQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso30366895e9.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726015; x=1759330815; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WTuaOxSTe3tk5TxQgOGSdVxjdMn4okuwwVefzm7d4xQ=;
        b=jnMVG0vaBMmtMlsKJdJaxBuPkICq/dW1KgsHDzpl+gIav5u7KVhtkFAG1UfTwQvC/7
         dScT0xikq74uI4WZOioVmPwif27I2WLQBw6mz9331thMoJGT+oAkJ+2+BmmwgLnyZQVk
         pKWgk1IWl9vcaB/TVdo+CdXKNIHyAqI61yCerQ1FgiYBSaEYDg201G/L0odL85qrmbkZ
         pjTkXKgdaGHevxUPkDjkh0yoDW3TP67G0LkOZpRrKlIOl59zbQa/8fQUr8FBW8fFNo/Y
         KTEAnjRiNBjN8jrLlT8lnluS9vW/Yp46BDaHWzkuMsm5FPXuQJKpYGi6YvnpmEYWm+x0
         GL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726015; x=1759330815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WTuaOxSTe3tk5TxQgOGSdVxjdMn4okuwwVefzm7d4xQ=;
        b=TgHZxUazy9j96vZBDApxt3FF/e/ays5Nu7t5e6vT8k9Q5e7bcV5Nc3Cl09u0Zgc2dy
         vimtkkeLUkPd55fjr0Fyw5+YB2rGJM6nh7beSCNzz2446YRbvs9ykgRtkCgWrCi7a9Ha
         m1yIhl/tVlXDVdiaYaZgVRkCWs3zqJnRS/ZWXbE9LD5xFJrkfxYP0Ax6XcDTbF1ZvzEi
         kEn7G+6OqnaKk92k04IH0aiUJpEbDfXzV/kWVRndQ/ktvncyNvfhDFPNfgcDCfq8jBcT
         CoZfeR7QO3BOKjKKcv+Qz6nuMxeNKJStbz+yUtft+4Noz9dqvdlCF2dwlKbM5Zh9WvIK
         1Zaw==
X-Forwarded-Encrypted: i=1; AJvYcCXCrT32NCVwENimDFCB5Qz2oE2rNjs7XKUy/HBmdpygk7S1Mmz2w1RwoS8NWbMU45oZDZU2eYOPjg==@kvack.org
X-Gm-Message-State: AOJu0YxLTdywfxQjULfRuNzfSt3f8yp998d7lZvvrYPFTE2mckhWGLQF
	kbxnHwpEYV7+HzB/+FAmO+ajwu342ZPO1+S8tztrXFi04EkIdnUtpv33jfPd5smjnWwXJl4OGij
	WZV5bbnPzhKttAw==
X-Google-Smtp-Source: AGHT+IGt9WJr9xVKvOK+GVvGrHodYbNw3zG+dtfOGTSv7cY+ZO1ThruN4S0CmXEkR5GVWAqvIrk4jx4s1l+ufA==
X-Received: from wrvw4.prod.google.com ([2002:a5d:5444:0:b0:3eb:7d34:3d1d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5d07:0:b0:3fe:1d64:1871 with SMTP id ffacd0b85a97d-40e4911408fmr239735f8f.43.1758726014660;
 Wed, 24 Sep 2025 08:00:14 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:42 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-7-2d861768041f@google.com>
Subject: [PATCH 07/21] mm: introduce for_each_free_list()
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8654D40005
X-Stat-Signature: z3s99zjuyzynomyi8pu7dnpk6y1ofeuk
X-Rspam-User: 
X-HE-Tag: 1758726016-105653
X-HE-Meta: U2FsdGVkX1+ydQ6ojc8CpDGVtuzjFrqkyBHr+uhqgobi6pwlAutw4G7Gi9mOCJjw+juVI/tygdPQKToo+9GhqAuM0aysQ75lANjk+M00pMVPmxo+3iQQYkr0/AbtEhS9JACwjMhX9jKMyg6glo/lGlxvw7jRB6JpyIrMUupcTBbVMrWh8aAcuFURnx1wK5os/HqjQDk/L78G5d5IWZGmvKQBIooChT/HN/1lpxtAnxaxydpgnjYmei8AED9zm3EAyB2c9Qy4Qs8XimYrDqyBB8CGdMt0qWMqidB65Bbw0oFnuyQWQhuOcoiEJ33xEmAyOcf/tuu1HLIRJ80qMOpDKbQJkkRJ1wTJmPQZtUBv1Ld+Zj/zZo02e3KaRLW74/hmGcv/prnaBzFmuWDH/wNWRrCU8HxFT+23rVSAhQiqUx8vTT+1wcZ8VM/T/D4daZkk7lgLndLaTWfqtyIlP24sg+ijjRrN0PEvvg7CuDn9iR0TDaCAMWplV5hjTEkyNw25WcnZIpiQeDF1euIWMBYWie+mrSwKYbd8RC3/9reW6hg4jiLZ2pMoXP89VJT4EW2EAyzNcqOaVokwUQCf8p75p6drN21HGbvzz1TAecdpFEiWV7jVmg5PNNb2E7rqJwe9FK9nkrt84pQ93RJSlx9ceFILRrdUvAh/pnJj72I0Vc2kfTHkoUswbJEHK//Yua3DMgyhxJbUgoxtMFV7nvbTAEBYnjcB+RQv+1oCbyACfya4EwDVN2+wdf4pEknoVZacN0v8cNI8tgLuYLEgwvCp7twROcfYipyNm1GPF10MRo4ac1vyE1UW+gJCurn8hjXBC/250s9LyPLmFTj6Gh27Pn1Key/bh+WTpepLb8onQ67AEUeE9Pc3nSewZKWYv88uGEkhHR8MFoxIIoaRDSrN7gC2nngFOPjDdD2ZWeRVbuvpFSfkn3PinxLqY5BDkMta8YXtTrXVJf8mS6ACVty
 3attGxNp
 1QTK8f/zoAmGepZxn75fxE5Y2GssOGqDIIkj6ha+zoFwfQ8QzosP6JWjlrrfScTUeeqctrCikrvuKZ93IB6W4rKbboSAqihVRJ/N39YCwMvKrxeZUxbvbPa1J1UJtxp14i6TS+bmKgtIkcKRNZTnnq7Nu3Appg9fUvHFnGgouqX4t1Zy1WqJal2nhCCE1LQHcyVmuompJFdYS0jUDMuTkoUkeQ+pBrOzSzHzHiajH4NJtnPGgliY3cgBheKrTtDq8+FSJMgbiEAhj1G8Bh6wUS/e4T9O9j8zJoIAG3KiRKsotbcaF5pxdfzRF6yf5m0PnFqYRBExT1ngoTrmELTdq2QL/RctykV7ZfPM8ed75HuJ/O3Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 include/linux/mmzone.h  |  9 ++++++---
 kernel/power/snapshot.c |  7 +++----
 mm/mm_init.c            | 11 +++++++----
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c57250782a464a9583c6ea4867f4ffdab..02f5e8cc40c78ac8b81bb5c6f9af8718b1ffb316 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -123,9 +123,12 @@ static inline bool migratetype_is_mergeable(int mt)
 	return mt < MIGRATE_PCPTYPES;
 }
 
-#define for_each_migratetype_order(order, type) \
-	for (order = 0; order < NR_PAGE_ORDERS; order++) \
-		for (type = 0; type < MIGRATE_TYPES; type++)
+#define for_each_free_list(list, zone) \
+	for (unsigned int order = 0; order < NR_PAGE_ORDERS; order++) \
+		for (unsigned int type = 0; \
+		     list = &zone->free_area[order].free_list[type], \
+		     type < MIGRATE_TYPES; \
+		     type++) \
 
 extern int page_group_by_mobility_disabled;
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 645f42e404789286ffa751f083e97e52a4e4cf7e..40a7064eb6b247f47ca02211f8347cbd605af590 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1244,8 +1244,8 @@ unsigned int snapshot_additional_pages(struct zone *zone)
 static void mark_free_pages(struct zone *zone)
 {
 	unsigned long pfn, max_zone_pfn, page_count = WD_PAGE_COUNT;
+	struct list_head *free_list;
 	unsigned long flags;
-	unsigned int order, t;
 	struct page *page;
 
 	if (zone_is_empty(zone))
@@ -1269,9 +1269,8 @@ static void mark_free_pages(struct zone *zone)
 			swsusp_unset_page_free(page);
 	}
 
-	for_each_migratetype_order(order, t) {
-		list_for_each_entry(page,
-				&zone->free_area[order].free_list[t], buddy_list) {
+	for_each_free_list(free_list, zone) {
+		list_for_each_entry(page, free_list, buddy_list) {
 			unsigned long i;
 
 			pfn = page_to_pfn(page);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 3db2dea7db4c57c81f3fc3b71f0867025edda655..9554b79d0946a4a1a2ac5c934c1f80d2dc91b087 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1435,11 +1435,14 @@ static void __meminit zone_init_internals(struct zone *zone, enum zone_type idx,
 
 static void __meminit zone_init_free_lists(struct zone *zone)
 {
-	unsigned int order, t;
-	for_each_migratetype_order(order, t) {
-		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
+	struct list_head *list;
+	unsigned int order;
+
+	for_each_free_list(list, zone)
+		INIT_LIST_HEAD(list);
+
+	for (order = 0; order < NR_PAGE_ORDERS; order++)
 		zone->free_area[order].nr_free = 0;
-	}
 
 #ifdef CONFIG_UNACCEPTED_MEMORY
 	INIT_LIST_HEAD(&zone->unaccepted_pages);

-- 
2.50.1


