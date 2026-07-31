Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA4ADC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 05:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79446B008A; Fri, 31 Jul 2026 01:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A7C6B0098; Fri, 31 Jul 2026 01:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940016B0099; Fri, 31 Jul 2026 01:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63CCE6B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 01:37:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF5D0A15AD
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:37:57 +0000 (UTC)
X-FDA: 85047965394.06.F17F098
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4EC6F1C0009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:37:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LRun6Wx1;
	spf=pass (imf20.hostedemail.com: domain of 3sjRsagcKCCcZIHOLSHJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--wfelipe.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3sjRsagcKCCcZIHOLSHJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785476276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SEgrncmXtZDPcOb6N9j9gD2FhTkkRdMPM7j7uOcSFqw=;
	b=VjzfzteS+B/a+OOGigY6e51lsdiT6aRXxejcIMwzRBHsG1COFVQ6KJdMd5YXfcIII3ArhX
	hQlB1+BuNZSSi+quI8rgY5wbfFBY3IObGDWytJWdwdswBDUOPscmLA9SbtekzDR+3LrzEE
	5K/2AeT2q9gLI329VXzNYN2f/7xcLjg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LRun6Wx1;
	spf=pass (imf20.hostedemail.com: domain of 3sjRsagcKCCcZIHOLSHJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--wfelipe.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3sjRsagcKCCcZIHOLSHJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785476276;
	b=vLYlhla9voROB75L+R0/Spx/5LkrBK3h9/RprpoR14SlscIBJWitKv6f31+eeiWhU78sRM
	Mrjjx0kDT4qhVUsTB2idbT70oBj8brrUOyYzeGQ0lWJvnX88azFNgRz53CW8WX3ao+AWpb
	zC014h1FmYuNDqGzzTjeOjx1e5riiI0=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cccfa32670so6924915ad.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785476275; x=1786081075; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SEgrncmXtZDPcOb6N9j9gD2FhTkkRdMPM7j7uOcSFqw=;
        b=LRun6Wx12QVc3lCsxWyGn/ElOQ8ypK+hrVEqNhwXSPKW1MLyuoXoXmo0KjwAGC41tz
         Jj028Jm5TujhsYZJ1+/sdZ0ECOjjp7bLPewXF8G5Dg5sxw/mEKSxK5fQUxBlhoOXJN32
         9RUa10r2JhEKFWVDv4HVyE3bKb47JzJCwuhLPICiE+tU6NX488TJaCL8QhZK7HzKkQKZ
         93w3KZQFZu7bzC5tgXmS/dw+Uh5wJD8N3mv7OOAy8521iAh/j7XdjQcJi8/p3FDQpggt
         XrHXTUW+G7wgA5AbabcIVSIACU0LueR4MB5rM7+Wf1TgYI+QwQXKzI3lA+x6RowQePHB
         ZPpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785476275; x=1786081075;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SEgrncmXtZDPcOb6N9j9gD2FhTkkRdMPM7j7uOcSFqw=;
        b=heA6xByiyHe+opgxaKFXWEJ+Nd8mm0S2xej5YaS5B0I94t2Mp+kiZw+ip46bjdp2EZ
         OSlFlG2+wUN7n8pC0HsdVZEr/XwmQsacSvPVj8ZBUNoGnethSKrqck9TyRCc2c+4LbF6
         3P09/gDvqOHiBeLxuW+yDUBNIG2HvI5gsv8Tdkkj51ipyWjwy48vqZ6VYYPCu1a46ASq
         a6+g0RQKsTEG+pFlFqX6uZpIn1oiuTtQcomoklgQkEDkEVdbtfgyAxdjtZ4oLN68sRE+
         +Xbfa7aYVK87OHgtOWHXYzdkaAY1vMmpZfbYfXvJ2e5t+XqyAGS3oxE574xb3cJ8FKFQ
         8oDA==
X-Forwarded-Encrypted: i=1; AHgh+Rr8ixP2a47MRmX+x79gHmaUHqU2NNQT+5r5uvS1zN6mWqdrZxGRJGKd/GKStfyNQ68lHX9fZrYLSQ==@kvack.org
X-Gm-Message-State: AOJu0YxjRm8sQ3zf/qKdb1HdAn/Vae1sh4LVQN4C8zrHkenn6crVbTEP
	Qu14XQ4pcVLnacargpPvnrI0nZhbpARqgitHp2Bk4DUJXsO+Xi9lDBLEg7OD/msVEY4xEBYVYi7
	eY4QUB3jy2w==
X-Received: from plbkc5.prod.google.com ([2002:a17:903:33c5:b0:2ca:cdc4:8da])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:904:b0:2c9:a5e9:c26e
 with SMTP id d9443c01a7336-2d046dac9e1mr6687825ad.13.1785476274623; Thu, 30
 Jul 2026 22:37:54 -0700 (PDT)
Date: Fri, 31 Jul 2026 05:37:06 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731053721.1412304-1-wfelipe@google.com>
Subject: [PATCH] mm: zswap: drop list_lru param from zswap_lru_add() and _del()
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EC6F1C0009
X-Rspamd-Server: rspam01
X-Stat-Signature: ti5gtxe9fuoxdmgboq15k4qgecg76sxi
X-HE-Tag: 1785476276-937733
X-HE-Meta: U2FsdGVkX1/zD1j90F4S7cnH76rJ0hwPo4y15GnmReJnAF6Hp6hU+28QWSTo15QZ+VpYLJ2Igbwq9I4xsfyFaHtB/Z7M/H8qVEUM4XtyHXyFCEOeMKVb+0gRH9WeTG3phWFfvGwGVqP917IE6r0y954X5VE3LCHQntL68ugxtz/jCxM+JJYCcKCSwKhbw3zB+IBt7EcYqVuFTibSom9oGNwjexK+XoTDi5HPrMuski+Ue0dnbrUUHe4ymbibwhFUUS5J6GUF65hhs+KwVfWgvt5RHYdY9/n6nykLkJCyRRPHaeboKjb3yapM6piroKfGRPPm7CTjfBlF1+DqD9hRLYzon4ZyQbdHkQ/LF4BAnnr61OY25BfZVkH5JX58OAP4/FcsmhaGzaYzFfpQu1mW5hGeORFa0JngUO3YmfZj34NdcfgAu77XAiiDX95qRBBosF0ny+7uK/l6HLH18NpZoOo2Hv8FNlPeCKw1vsXOP7Px6mBZx1pod54JmMz1z6jKJuln8QyXe99gthG5XY0NYLDcuyLBNFBGHWp+7i2qJIjolfHkzFTp5Zw5lD7xz5foYW6eM2SDkf7YmTL9RGGylWYgKPldbLNSRvU1Fl2MZKcPx5/8pNh97XGbk+XLOnXyfG0MrxgNUYuj76hBynzQKWkS0fEo5tvgkQ+vmfFwnSI8ZH38syLyA7jDYZtepjyrptFHGzdFLJrPDBObawpg/9A8hf3+l0AXZzd8AtK830uXrh2qvtdRLSOcrPSe6nlDckg1h8h8FjXgK/o4oW3pEtC2NTS7tikYdPB2qnr1Owb0Lplh2Ua/Q3zL//RiS3Il0lh9Dn46U7i9gzyLvLmKRGIyPAtDbQAigJDNlYhq+v+wIK2rA8yqvZJehjXF2aUVLaT8JbNbzHfDPYg+M4NootYkS00GuJEKcsRZ2PfvfPh9p/tqtfcU2ZZKbgn+OanOXGaSug3nsJwRb6U6E0j
 WKGgVsUv
 vZ4Rvk3eze2EuwIP1XNqP20Mdo04WE5GzlC3JU67c1fl3KqlnZfZPjqp7DFv2lZdbfnDM/UDM+EGMal7P0G6gMnsNEwO7LNqAbdP4HYLZcnl4igJxSxSQoqRsu52KnJz6q5m+tn71wvSvfij0oso+OyW8wwDj4AfHzUf5tNAG7GbypyWfjNpUFTmvVZ6TF3xx+WnK8WZyTOXFTWUProM+xoI6ZwXQlgtXe1rZL0mugTd8/v//FpLG348RqMIuXmxeyZYlOxEbOwkmuafGsp2YhaKJOan0q1Pa+N9o69WyVb3y1O6L8GsajlL76oHiHjm9oScWpspyVzb1OsfsLX4iuDW5rRuqcfKYWj/sWfSvVlz6HofeMWKeOqYPl7pZ9Yg8jlPzVWbi9fnP04NZSHxjokizyHoKaeIu4JZoPm2MBQ7YKlN78pFHHojFEMGRuLiKGYiCJmAR7wtKzawaw9ykYN/PzQRHGadaVod70ilJ5Jz79PFulo3KiuSRMkq5pM0N8r5NXDpRWqmR1Vr5/l5xryBh4pt3vFfUIJZ8B8EAHyuiqBdPGY5eJhGBXn079+BfT5EDN+7y5ReDPB8WPpp3tUxc0/omSkTLXqsPTMR0BLRXuQTYea420hQ9npAHa1iBnIhm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since zswap_lru_add() and zswap_lru_del() are only called with the global
zswap_list_lru, remove the redundant list_lru argument and use
zswap_list_lru directly.

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 mm/zswap.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3e..a810524c76217 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -665,7 +665,7 @@ static inline int entry_to_nid(struct zswap_entry *entry)
 	return page_to_nid(virt_to_page(entry));
 }
 
-static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
+static void zswap_lru_add(struct zswap_entry *entry)
 {
 	int nid = entry_to_nid(entry);
 	struct mem_cgroup *memcg;
@@ -684,11 +684,11 @@ static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
 	rcu_read_lock();
 	memcg = mem_cgroup_from_entry(entry);
 	/* will always succeed */
-	list_lru_add(list_lru, &entry->lru, nid, memcg);
+	list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
 	rcu_read_unlock();
 }
 
-static void zswap_lru_del(struct list_lru *list_lru, struct zswap_entry *entry)
+static void zswap_lru_del(struct zswap_entry *entry)
 {
 	int nid = entry_to_nid(entry);
 	struct mem_cgroup *memcg;
@@ -696,7 +696,7 @@ static void zswap_lru_del(struct list_lru *list_lru, struct zswap_entry *entry)
 	rcu_read_lock();
 	memcg = mem_cgroup_from_entry(entry);
 	/* will always succeed */
-	list_lru_del(list_lru, &entry->lru, nid, memcg);
+	list_lru_del(&zswap_list_lru, &entry->lru, nid, memcg);
 	rcu_read_unlock();
 }
 
@@ -764,7 +764,7 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
  */
 static void zswap_entry_free(struct zswap_entry *entry)
 {
-	zswap_lru_del(&zswap_list_lru, entry);
+	zswap_lru_del(entry);
 	zs_free(entry->pool->zs_pool, entry->handle);
 	zswap_pool_put(entry->pool);
 	if (entry->objcg) {
@@ -1461,7 +1461,7 @@ static bool zswap_store_page(struct page *page,
 	entry->referenced = true;
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(&zswap_list_lru, entry);
+		zswap_lru_add(entry);
 	}
 
 	return true;
-- 
2.55.0.508.g3f0d502094-goog


