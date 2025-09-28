Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E8CCAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 11:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74CE8E0007; Sun, 28 Sep 2025 07:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4BCF8E0001; Sun, 28 Sep 2025 07:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B088E0007; Sun, 28 Sep 2025 07:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BFBFF8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 07:17:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81BC6C0975
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 11:17:56 +0000 (UTC)
X-FDA: 83938409352.06.1DCD289
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id A640020013
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 11:17:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bVKOHZlr;
	spf=pass (imf13.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759058274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=REKRs8CKWU4LVKPgGJm+MTqNzgJQGfW7CB6Vx4pkWZs=;
	b=GGmJX56PLNtU7BOPgjHuu9p/+L7OHMTBuzy36hzcHaAANhAVPtR1mnG4V55zvX6CK/lv9z
	mLgKgaJCX514r8B7fLkPLDSDZN2wmXFyve8DRUSTUk/o7d45mzI+jmAnXjPLiUME8luJe2
	0f6E/vghx5GCZDBiCXkhXv3uHENE6oQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759058274; a=rsa-sha256;
	cv=none;
	b=CGn7hijqkAPlXyErY2eSN1iwon9UI+ccNhCnAbiHK3d4yOl5sbVqP8FDJsYBQKsXrZIuEq
	1XFBekIWFkNTACWJMdm31U4AtPGUW7TEB5XJLv9FtkT/O0vTjeIMcug9yD9xPIQNUkquw2
	YL2i0VEdnJ0y3C/SKvPw5Hx2iGPcaHI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bVKOHZlr;
	spf=pass (imf13.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7835321bc98so448675b3a.2
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 04:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1759058273; x=1759663073; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=REKRs8CKWU4LVKPgGJm+MTqNzgJQGfW7CB6Vx4pkWZs=;
        b=bVKOHZlrjfAgNrdRtnbp91Oph3kxid4wgYwD9Xy5/wXUmm/FcMntDGpnkWfxb88i0X
         8Yc16kGC/Pup2y0gpPGhn8b5yj5QdWbr7S31+3nhU0dpBMpP0sTDF21eI51tcn+dx6iH
         xggRUJNAkMWs/YL1SDiMyhcpfEL5YSbcIwFHidvfB74A/6eXvCo4fd9nJYvs0S8FYEUH
         DHXPAh0eOZ0fM4FX7WWYOGjAiRuHXH51Gz1+oUkFAUDwvI4Zb3FkSP3y8/CX7aqBoLPd
         bHrwnwVxV9QU0MjOQ/sBsKBjxW8lARUlhnetyz2hyGBUvUMLAepjJeRjBSTCKZxNi0L8
         yuxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759058273; x=1759663073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=REKRs8CKWU4LVKPgGJm+MTqNzgJQGfW7CB6Vx4pkWZs=;
        b=qSNJmrhBohfhLew8O/E3niBz+Zyyv4YXyA4VQlrHJ4L7rz6oBpUtSWMOjXVWYffb1a
         nmhHQUot+dZxXy20ojFXnFMl0gUxym+/bzabkNl7r++wsi2onYqaJ+07lL4syaOBAH2v
         YM+DtdF0SGDdYaA9LI06yRMFi3wdE4rCsChwW/KNdQTnpY84aEHYTmpHkIeQvZOwF6xF
         a7L+wz5yz9KjKoam4lbnLvqHufRIc9PVBX+KzEy1bKAReFYGpXquLRJA10VxWEPsNGHP
         6WeW7lIuDTILrBabyHvnXsPuXwzlbmB7/zGQUdJkxY5G7XwrAn/VwbzDqPKa6o2CigyF
         a75A==
X-Gm-Message-State: AOJu0YzRUZFIxiTloF82p3gB4Qc0KjHvZ76UJiCv66mq8oGm0uZAGcTp
	hbE7NBvzO84D32QdOG3Jsc5B0acsKmDc0TJTOuDNWzStbhRkWUP1rhUMpfpJnTwIVlY=
X-Gm-Gg: ASbGncvZ6zc1uirn7SaZqRwdzgnPOrQ/aqO73ihA0s+LIlD59jsUtGRCWS9FPlJ33DF
	ghnnNOeUBxDq5R53YZJkn3W4ohZOCU53lJBgnrV21KVDN0CtnfG3qEKLs45rpK7qn0pTvTHyzCQ
	M+rn+KJ6ELbohI1+2qhwO5C/Q8xNrnRij3Sp0Jh6ISWNz2tfTrz0WM78akbxKOW7tEWWd0pDWMG
	R4luIRC15Xuwt4Ob6eDvddKKXjDeLOqDYLHGcp6l7y9bS7Uc0J2fQsfJ8YB/muSXhkUJq5BRXa4
	dlVGWlrkb0vH+wZ6CTmMM2tL8+Gwzt/PzGO+w/84o8wVUPPNlL+o0JOicViK6HI7aLARJ3PbZQl
	qdUx0F0Jhwo9V4tsoytuAH/Ly+SqvG21OiZTFl9FQ0jCvYMxsI4cPEELehwOCZ9GW+Cw6iY+ak3
	O0
X-Google-Smtp-Source: AGHT+IGIIdlp+3ne4RMEMjmjf/O27EuwNrQ4psGtAD9bT7M8UEYwxZbaO2h7CkCYrbpbiJHcop3BUQ==
X-Received: by 2002:a05:6a20:734e:b0:2ca:1b5:9d4d with SMTP id adf61e73a8af0-2e7bf478afcmr17761831637.2.1759058273370;
        Sun, 28 Sep 2025 04:17:53 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([139.177.225.231])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c55a2c45sm8687451a12.45.2025.09.28.04.17.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 28 Sep 2025 04:17:52 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 3/4] mm: thp: use folio_batch to handle THP splitting in deferred_split_scan()
Date: Sun, 28 Sep 2025 19:17:01 +0800
Message-ID: <43dc58065a4905cdcc02b3e755f3fa9d3fec350b.1759056506.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1759056506.git.zhengqi.arch@bytedance.com>
References: <cover.1759056506.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A640020013
X-Stat-Signature: n8jtifsdxfbsmyajyb5r86xmrtsx6mno
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759058274-16839
X-HE-Meta: U2FsdGVkX19C2MdsBkhnzQrtQCreJEDFh58y2L2ko5sLGjV0EZ0S+X2jt0j2XkWV2qUbVyiOqdXMKWu9a6upeFoCP7NPkECPriO0+xj++GMK4Ntk+xySFtQWir+z0OFTdJoZv7mdBD16vnlUJP4H3te2pEXy7VqCR3CqHnKNEOpTP5y+k2eAYhxUaQGZnF0F9cBrMSKlzq7hDKhEH3ezwueds1ILv7AR2LLKai8RB6lEnfJZwWyyKXSIw9kPdQtAx4mzyuC0BQJjRncEZs59kMjUtILNAlVBncHTxOm1OEiyRDf17CLHVpqp0cwjCma1neuu/bTe3OnZvaOAssiRuhFKMR1XEw71UkT2h6lkOcFLP4TCHI2QrUCmxTZNwqAjI5PxQdb3/AK2dHsPdnyi7r4kAPjImDrLT3ennBwc6DHZmhaE+lE6q5KHjSdQ2KDXTPOYRA6qjgWOi7eumz8NodGg0NgGKuHP0hRMhKYosKDjamhMCWzx7+m1QI4wcLlY4eLCa8TZQGyzO9V4OamjHj/x955P5No1jdb26LoaOK4zkXZ1h2fViRwq/a7VKJzVmWuYdkAknVSZEweErbfUOU9LcKTol/FBwQsmrfQWFS6PNevyaC0Ghq1HXCNoEbQ8K6pixTgPdFztgtmX1TZTP+xFE3sWswvQAZervWgR7zNyjxuf2+VcRhHP+d50KeAIk4GUMGzNuLSQqkYX2ZKtGwWHVSLjbpAuKvKg7ZXKKAz2ZrKRkpkc64Hwmmx5/pB1fQK4ck141B5gYmgnEo7Exg5GBWYZJt/A+jorGnTWCLJeTP8VI+U8NaMmCnOO6Ue1Ix9nw7n64EffWhdXk59QpelbB92TGq1SubmYZV9QD+B7DXhwmzdLRU7+ZquIIBnqhpPJuO39M5UGqNGXSdLlLuPCNRzmkoCZOYNMsl+nUqNI0GCVoy+vPS+LXjZggu7bCDxpw654D+ejxxVc0uu
 FvRdP2v+
 gmPeIcaHH/FhZWxUyvqjU44EAsND/z+F0tQzid6a5o3ruRBklA9cAY140KMQ9OsbleBCmXSZaa6w+CbpTIMihIFMGerYd7nKLlOp8EcW6483/iqc1aX6QafYZ99pX6LoKdqKOs2ka0ng+MaNKw2Q2qan4oIPjynMAjfoEx/oFoEUp+hWZ9MtFJAe1VaFY+yrfQyataCxiwixZ3a1B35uWPFlrx5foGudzlLY/hjuxUQct3mWsy3s47ZR2sHpvXTD829Ze4X3OW7SLoGqAQwyPnZTTbKL+A1KNpA6x0WDFrw8OeH5ThbFuuCMS0QNIzLNGJzKokhf2S4fQz7OLsKG3NdLa1PxSKbCvMrW5PGBSmQrQhOE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

The maintenance of the folio->_deferred_list is intricate because it's
reused in a local list.

Here are some peculiarities:

   1) When a folio is removed from its split queue and added to a local
      on-stack list in deferred_split_scan(), the ->split_queue_len isn't
      updated, leading to an inconsistency between it and the actual
      number of folios in the split queue.

   2) When the folio is split via split_folio() later, it's removed from
      the local list while holding the split queue lock. At this time,
      this lock protects the local list, not the split queue.

   3) To handle the race condition with a third-party freeing or migrating
      the preceding folio, we must ensure there's always one safe (with
      raised refcount) folio before by delaying its folio_put(). More
      details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
      split queue not partially_mapped"). It's rather tricky.

We can use the folio_batch infrastructure to handle this clearly. In this
case, ->split_queue_len will be consistent with the real number of folios
in the split queue. If list_empty(&folio->_deferred_list) returns false,
it's clear the folio must be in its split queue (not in a local list
anymore).

In the future, we will reparent LRU folios during memcg offline to
eliminate dying memory cgroups, which requires reparenting the split queue
to its parent first. So this patch prepares for using
folio_split_queue_lock_irqsave() as the memcg may change then.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 84 ++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 46 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0ac3b97177b7f..bb32091e3133e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3781,21 +3781,22 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct lruvec *lruvec;
 		int expected_refs;
 
-		if (folio_order(folio) > 1 &&
-		    !list_empty(&folio->_deferred_list)) {
-			ds_queue->split_queue_len--;
+		if (folio_order(folio) > 1) {
+			if (!list_empty(&folio->_deferred_list)) {
+				ds_queue->split_queue_len--;
+				/*
+				 * Reinitialize page_deferred_list after removing the
+				 * page from the split_queue, otherwise a subsequent
+				 * split will see list corruption when checking the
+				 * page_deferred_list.
+				 */
+				list_del_init(&folio->_deferred_list);
+			}
 			if (folio_test_partially_mapped(folio)) {
 				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(folio_order(folio),
 					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
-			/*
-			 * Reinitialize page_deferred_list after removing the
-			 * page from the split_queue, otherwise a subsequent
-			 * split will see list corruption when checking the
-			 * page_deferred_list.
-			 */
-			list_del_init(&folio->_deferred_list);
 		}
 		split_queue_unlock(ds_queue);
 		if (mapping) {
@@ -4185,40 +4186,44 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 	struct pglist_data *pgdata = NODE_DATA(sc->nid);
 	struct deferred_split *ds_queue = &pgdata->deferred_split_queue;
 	unsigned long flags;
-	LIST_HEAD(list);
-	struct folio *folio, *next, *prev = NULL;
-	int split = 0, removed = 0;
+	struct folio *folio, *next;
+	int split = 0, i;
+	struct folio_batch fbatch;
 
 #ifdef CONFIG_MEMCG
 	if (sc->memcg)
 		ds_queue = &sc->memcg->deferred_split_queue;
 #endif
 
+	folio_batch_init(&fbatch);
+retry:
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	/* Take pin on all head pages to avoid freeing them under us */
 	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
 							_deferred_list) {
 		if (folio_try_get(folio)) {
-			list_move(&folio->_deferred_list, &list);
-		} else {
+			folio_batch_add(&fbatch, folio);
+		} else if (folio_test_partially_mapped(folio)) {
 			/* We lost race with folio_put() */
-			if (folio_test_partially_mapped(folio)) {
-				folio_clear_partially_mapped(folio);
-				mod_mthp_stat(folio_order(folio),
-					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-			}
-			list_del_init(&folio->_deferred_list);
-			ds_queue->split_queue_len--;
+			folio_clear_partially_mapped(folio);
+			mod_mthp_stat(folio_order(folio),
+				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 		}
+		list_del_init(&folio->_deferred_list);
+		ds_queue->split_queue_len--;
 		if (!--sc->nr_to_scan)
 			break;
+		if (!folio_batch_space(&fbatch))
+			break;
 	}
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 
-	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
+	for (i = 0; i < folio_batch_count(&fbatch); i++) {
 		bool did_split = false;
 		bool underused = false;
+		struct deferred_split *fqueue;
 
+		folio = fbatch.folios[i];
 		if (!folio_test_partially_mapped(folio)) {
 			/*
 			 * See try_to_map_unused_to_zeropage(): we cannot
@@ -4241,38 +4246,25 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		}
 		folio_unlock(folio);
 next:
+		if (did_split || !folio_test_partially_mapped(folio))
+			continue;
 		/*
-		 * split_folio() removes folio from list on success.
 		 * Only add back to the queue if folio is partially mapped.
 		 * If thp_underused returns false, or if split_folio fails
 		 * in the case it was underused, then consider it used and
 		 * don't add it back to split_queue.
 		 */
-		if (did_split) {
-			; /* folio already removed from list */
-		} else if (!folio_test_partially_mapped(folio)) {
-			list_del_init(&folio->_deferred_list);
-			removed++;
-		} else {
-			/*
-			 * That unlocked list_del_init() above would be unsafe,
-			 * unless its folio is separated from any earlier folios
-			 * left on the list (which may be concurrently unqueued)
-			 * by one safe folio with refcount still raised.
-			 */
-			swap(folio, prev);
+		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
+		if (list_empty(&folio->_deferred_list)) {
+			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
+			fqueue->split_queue_len++;
 		}
-		if (folio)
-			folio_put(folio);
+		split_queue_unlock_irqrestore(fqueue, flags);
 	}
+	folios_put(&fbatch);
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-	list_splice_tail(&list, &ds_queue->split_queue);
-	ds_queue->split_queue_len -= removed;
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
-
-	if (prev)
-		folio_put(prev);
+	if (sc->nr_to_scan)
+		goto retry;
 
 	/*
 	 * Stop shrinker if we didn't split any page, but the queue is empty.
-- 
2.20.1


