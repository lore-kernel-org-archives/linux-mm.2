Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F009CCAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 03:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46EE88E0107; Thu, 18 Sep 2025 23:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8828E0008; Thu, 18 Sep 2025 23:50:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E7658E0107; Thu, 18 Sep 2025 23:50:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5B88E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:50:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CDF5DC0550
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:50:04 +0000 (UTC)
X-FDA: 83904621528.14.B535F30
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id F15D9C0002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:50:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=brux3NOC;
	spf=pass (imf10.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758253803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDYs9OGpSFKUZZGueotNHOqsQDyScZ0e77VVTnkWHNA=;
	b=mzM8tXpnZVs0jx7NX7uyxrKPbqBiBPbK2PSBaYr96EYunFenbC4bUBvANfv2yeH0hDDRds
	HX4HldUJ3I0p7F5ZiBYeIuAMoj9LP+vaK92F3wL9Pd672KNEaFa0eov39uq24HH/1DTFQY
	T+qe7iYHEUkR8PnW4fmkRBvZDbGmb2I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758253803; a=rsa-sha256;
	cv=none;
	b=KhOqtoanboV2s7xKZ8zpJganwb8jD1b9qFMNm8vE5XfZMGEXszof/C/WCqLOrPv9ZlMbIG
	P+gn9BdXkGIKJPmu7AhZV+2PBRyBlPBQzJvC9ZwdDsNte5uPPtfiw61L2QiE2Rb2hrqYyr
	HRTD6WsNWQPNZNWFGsdNyW9QH6brsOY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=brux3NOC;
	spf=pass (imf10.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b523fb676efso1472790a12.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 20:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758253802; x=1758858602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZDYs9OGpSFKUZZGueotNHOqsQDyScZ0e77VVTnkWHNA=;
        b=brux3NOCcsHVYp7YVwzL2c5JgVEFt6UOwE/J2qRGHFR9orx3vqCDjcTEXZHpZKpXmD
         RZMLi/OePUzfn7pepNPp8lV4AQs1dA5YQ8HZHr6kHepsbNbDbWC7t4Nl5QCBo1UmnzS0
         1RgufKRVcaTa1SZfNneKyqMp6z1/6AtjJO1qB6/4YxFalAANDn/TvGczM0DDiL9NcT/X
         TOetnzGUOFBK1zgxM7B5W4e1ZTjccSdFjpAQgbaTtSHfHyk2V3BjAwVfkuRJSVa3/f7D
         GL75yf6jkt+V3l67WV1hC3x/NXJc/QZS6+SGIL/7jwDWrt7z1LvGjSydhMXaTUXjdrxr
         LrWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758253802; x=1758858602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZDYs9OGpSFKUZZGueotNHOqsQDyScZ0e77VVTnkWHNA=;
        b=ZkNicyJuRfQfUTVtba+C2Ldal8MSJjrXKfpGlyy1XNdJC7BzCmqSnS1UE5y9i0AZXP
         +StKlEIqPb2f0DDilC6C61Ph6uYS7TMKLoqcd5M9WdlvIZPi0QZFp3d43VUyT0we3Oyx
         UxryL5je5ZWIUj7Le3zvs8mX9v5fS4dGx8hCZL5XMO9rabpqv+qHYILmLkTElrPlrvU9
         BBX2vxe+oym4GXnuCLXfROM8qQ/aZ8Oq0e1WKMyTeKSvRMiZXfQxbyAcZSkwOYWkzwt3
         Vwn+q2ULsZxq9wXdiUBNiwM/STF7nbO6vjo6/bghBE+ZOSYMAu78yfXgx2JPW67v5tWm
         ooXw==
X-Gm-Message-State: AOJu0Yz0VK9jC1dh0Di7uOD4hJhYD2+uxR5EitxTWMxp7njd3DLbNqgG
	XDmbaTE+QrmgxA4bk8xghjsSyRA7N/ssXngq8SoBNBN9NKSqeBOgVUt4vQCwXLeTI14=
X-Gm-Gg: ASbGnctrSvq9w10pcFv+yiaaepZd/bSnojHFHwNfwgI2NQKmbQHm4762/+9A1aBpjad
	i3jeq+6IsTGBiMvMoRfdlwiR3EaYoIK/3Oz/Balil8h0sTMeDNm4JMrxam+Bd/RCdU0v7bi3xEl
	SulhtABSqTfR31mK8qOoWcqny7z6GOgwUt6eQh9IKlNScNqE/8adGTuptH9D4EF0teTGV1pXRYs
	15noOh4hkUw2R4ihP6i0tloXEShNKJhEAh8AOHecu/5RnT1CE06beZpr9I4pTdqCjoKedeUtqJ2
	cq08iPA3K/M0pLq2OcXTpaONFF0Eto/dShuw18dCGCB9o9imrHXBvIBN5FEMWVwZ0MPNQjtTMGo
	h+oahYNmvajK3IiMUZ0Z4QZV4Vo0ykfGw+5e3bEHbX89xJFlBLUqa6EgxLYpMTu8qvvzmRac=
X-Google-Smtp-Source: AGHT+IFwsSMJjHL+zbHQOwnU5q2n34Jm6lBoXue7BH/hv8fZoGm3UEzcsPvo+mERmOTWnPv00CgCYw==
X-Received: by 2002:a17:903:6c3:b0:262:661d:eb1d with SMTP id d9443c01a7336-269ba3c2c39mr19723955ad.1.1758253801748;
        Thu, 18 Sep 2025 20:50:01 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802de5e9sm39629235ad.72.2025.09.18.20.49.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Sep 2025 20:50:01 -0700 (PDT)
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
Subject: [PATCH 3/4] mm: thp: use folio_batch to handle THP splitting in deferred_split_scan()
Date: Fri, 19 Sep 2025 11:46:34 +0800
Message-ID: <3db5da29d767162a006a562963eb52df9ce45a51.1758253018.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1758253018.git.zhengqi.arch@bytedance.com>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F15D9C0002
X-Stat-Signature: 5zgp4xzj8bd8sz7k3jfndktfh6znx7hh
X-Rspam-User: 
X-HE-Tag: 1758253802-981323
X-HE-Meta: U2FsdGVkX1+xdVkpYRMjPyBYFBZl/bHWXhk9C9gyvtcEc4AOnMFdQIQMfWepffffq9AosHk88GdbaTkyk+ndwxsySnpygJJbnNIVEkHrpLHPcVTHtfEc4CVOcHfLBY1fTcOQd/HMeC8HLN9oYrpswGV7KFls01G3SJeOsUem03yCCrh7+m3qno2sEuayqkfgq+s2KJnFo85CjJ23TrumNUpMBmz1G5nBWfRHRKRZZRJXY3HlE63A4ZCa2z6c5JaXkY9dH+hAWNzaoOlQ3mJ1r8Fm65NhQodf8CDrpDoBwdPVFOYFm0C+wgg5JfUKirVvtuu/VdJj/EyVabMLEXS/66eI0d84nHOUmCJ9zv5FT26T8XmURHwkRCu07FsK43wJ8AnnDhKayaF9svPJ82NcLDHWrwuj+RUveYUjHAfSSxoHj2vnON9lYzbADtO3BZQiwbGj4qORtLpyIiVxclFqXyACHCAlMTIgYuL392m6frpf/YFiVZPiWPL0poThU+ITtbg2u9PorwRuY5VQ5KMbWbHj+MXe7zGnzgY2ZyD3IDIH3az2VnjQSfzHleM7X0/vbO5YulCt7fToN0CUCPWm+7cPxkdSbna9pFJxQaX25s1VxS3fza3soQNioBaoLeGBF/GXIWRDoaZR/foRDOZFR0UCmlWbS6hUXjGo60uvIrHCwbHRpO30yIUa+W+KYvk3YTeHXNlkmcv1CkeA5oQyoF/Up4tbFfLLKnnnAUjD4DH5g8GRALh9TQqABIU8a/bqvyiX8xkh2OuHSq0vxIC5uETRIanLipuxPd9AwqCLl9eZBD82n5VIC3WlETbk+hWpMrUypQ8Xu0d73OuXlKInD0K/XKfGmC8QnMlscsCza5U658PnNoANV+2dBOpJOVN3ayuGcfHh/a1aZb97dFFJ5EXLWDty8AUKKX2DK/UPcyIVazHfMI1qwBRtA8kYGj/DA60sccr0jacNAVZ0Mb+
 vP8nwirA
 z/f97+XiZIQPilD1tVpk4hzoU5vQZDgkajdLJmt9rmjbB2UhZbmq2kUI+Bf3cEbCgYNwPPqXX92jtLq9SKeTCh8szj5qHutamGdBvrjR2BCBK9AFK3uw1iJBF1QEA04iuVk/dXlcpTvKod+tyI2CifbkRdVj9y2nwSq9F4bSp9A0zW0bEJjKC2zFbzm1utnoWqfpHUDlSz2cMO7kdYj1JbpD0zcProdu3V+e8lyZgjrv1IAxpEUibAfWK1xLG+NdHJO0O7NmSd8qIerR+yqc4h0RyvKpopKcOtl/NrXuVi0h7UghVUNpXKMFId8ijtPaGufIQ
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
---
 mm/huge_memory.c | 88 +++++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 46 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d34516a22f5bb..ab16da21c94e0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3760,21 +3760,22 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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
@@ -4173,40 +4174,48 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 	struct pglist_data *pgdata = NODE_DATA(sc->nid);
 	struct deferred_split *ds_queue = &pgdata->deferred_split_queue;
 	unsigned long flags;
-	LIST_HEAD(list);
-	struct folio *folio, *next, *prev = NULL;
-	int split = 0, removed = 0;
+	struct folio *folio, *next;
+	int split = 0, i;
+	struct folio_batch fbatch;
+	bool done;
 
 #ifdef CONFIG_MEMCG
 	if (sc->memcg)
 		ds_queue = &sc->memcg->deferred_split_queue;
 #endif
 
+	folio_batch_init(&fbatch);
+retry:
+	done = true;
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
+		if (folio_batch_space(&fbatch) == 0) {
+			done = false;
+			break;
+		}
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
@@ -4229,38 +4238,25 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
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
+	if (!done)
+		goto retry;
 
 	/*
 	 * Stop shrinker if we didn't split any page, but the queue is empty.
-- 
2.20.1


