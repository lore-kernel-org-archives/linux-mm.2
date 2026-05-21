Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFDF2CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74AE46B00CE; Thu, 21 May 2026 11:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4B96B00D0; Thu, 21 May 2026 11:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB146B00D1; Thu, 21 May 2026 11:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48A3F6B00CE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:03:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 065F28F183
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:56 +0000 (UTC)
X-FDA: 84791746914.15.E67A862
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1C06C40012
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=i+ojBVoe;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rR/PuWQM6I0Sn5LudGZTwz22IXjqotRj7EvDPtJsrZA=;
	b=iWwDM3Har0ip9uDHuopJsfsrJV4HGkWzFe1QiBEN86N9JaYJNseamCawpf+QHu51cRdSL+
	d0TVcp+UsajFmk+e5BTRKxZftAlSTi9adeAum+8+pJ7jEwzkS3aDWjf5T8UPT2BfNUqaE+
	hs21fo6JlKQ/JQU2N3JrnILSBYRxjVk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375835; a=rsa-sha256;
	cv=none;
	b=CodMBVptvjBf2r9/cNNxwtuNBsxZHYVhqGzSN8mUu11G+wVZLjLs6XP6sTmqsT3scSA8mS
	KzHZVVraw7xAeRVYc5fAI+t5OPmxf/cIE3vGtKwwQmpCcjA3zW8yORZfcPl8N/+i6AhJMF
	Fu+XpGbttSONUWninjxKzbxPCeDGKaU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=i+ojBVoe;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5102582e23eso49359171cf.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 08:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779375834; x=1779980634; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rR/PuWQM6I0Sn5LudGZTwz22IXjqotRj7EvDPtJsrZA=;
        b=i+ojBVoezi4s0XCoVC4zEoMDtTueROurHTSabnJd1HLhNc6tpRDqC+45MBYkyMSsA6
         KN/3UBzzv3yb3A89VLVlHEH2MVSLp6CEz5i7qQW8RTSQ1syHqyhUyBbZbIQnjcIbWiEC
         7OcT28uWHHUTAO41O1GXyrs0QJN1h0mKyfk5oib8V5IG6rO19fq4udJYhM448sEYaUlR
         YFXnPKNUpkW9TKlNxilyZcC7d8tO+qQNO8VIBFAqsu2kbg6m2IkhWtnoosgKr2GieUbG
         A+NwfEH7AZ2GV0W+BAivRf+n6Uio/c24Is8L5cjZ31ozTSiJoiVLED1yEQ5omZtX6ja2
         J5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779375834; x=1779980634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rR/PuWQM6I0Sn5LudGZTwz22IXjqotRj7EvDPtJsrZA=;
        b=s8OFjALcZd974wyH+HlweemD2e/plUafSUAmNo2iWrCz9lZ3AltIZ5ml5TtEIm33+2
         AoMa8XeaEylRCFFK4GGE8tiTmmxgX4UecXVj9nf8fgXEnW5gy7nJocGP/mDbcdcOlDh8
         tErwVlrffZWLVtj2Li9rBq1mLwNIQt+91Rtssi8kLOsJQxzjHP7GYcthS5rEgVLry02B
         z864ClucaI6wZjATfBkXs3kkBIc2lXSKoEZXpomscR14pIfmCJgMFdUYncYhdU7DK+L2
         YG1bcAhf14bg8uR5Tkvu2XP6pFDuyWFNZaLU0dWZGbGiFEbzEgilG2OCXzWwFG7dGMSc
         HIDQ==
X-Forwarded-Encrypted: i=1; AFNElJ96QJv5BmpmN9p55MyB3eDV8CKOsNAktmG1EWiNFLuzKC12MKQrjRRuflPFbtgUYz4++aZ71menzw==@kvack.org
X-Gm-Message-State: AOJu0YwF/pnCJSVwW7iqMn8VI69CDoYVZJSbFnUqodtguP1kGeA9z5mi
	DB0L5Ntm+wlgJ4wvvrNjzRIdQJd1u3AiniEwZZizBFe4k68DYYJf3O+6GzeEXNU1SJM=
X-Gm-Gg: Acq92OFo4caoqWBOfDsSMZEfevDMfaCzOPysM7BfpT3Jjfo7XLquH0GPS13pI+zFU5j
	vsKmeAQ3XYklFmRxuyiBDJmsSRmncmFt7RAaJEhkWltTVBD1vxPQGTTVbMI9iN6VtQgkdoK6OOM
	sNDg+dEz25OsZEDKMMR3kcFDrTyfoQZHs5AGwRQ/BEnkJxtoOl92tsCkdo9iKRrknjTdSzZ1Eyq
	vhSvXWsS+NSmRc9YT6qUi1culSPwGWopZL3ttg4RxdMpLrUa/MioS5m/Z/lK/houQmdqa0mZZZh
	Ia/bPT4wMK4P5gIACxvv0R+o3O5eWegvPlwrrJHb0TW8fGUhle3XoKR5KgSuGAwQBXHAos9UVrc
	WJ/4KswRTsweSY7jlJO4KXtSkMTetiY7ZghkalA0M2xEotxRZmGghnlBiYqOr5Oj4M/jM7XTF7C
	A2KRHWSRg/uaG1gVXLFSyn+3nA5IYx7I86
X-Received: by 2002:ac8:5e0f:0:b0:50f:b3d2:6ee1 with SMTP id d75a77b69052e-516c555a206mr43518571cf.31.1779375834075;
        Thu, 21 May 2026 08:03:54 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516ccba5ffdsm9168671cf.5.2026.05.21.08.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 08:03:52 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/8] mm: list_lru: introduce folio_memcg_list_lru_alloc()
Date: Thu, 21 May 2026 11:02:12 -0400
Message-ID: <20260521150330.1955924-7-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260521150330.1955924-1-hannes@cmpxchg.org>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C06C40012
X-Stat-Signature: yjeqewybe4pbiyfb57yishubzqp8ikja
X-Rspam-User: 
X-HE-Tag: 1779375834-486446
X-HE-Meta: U2FsdGVkX1/PKmFB0I8a10Z0Tq4ynkS5IzDysKh4Mzu1vnkIyrf34jtmb/M3gqmMmMkuml7YAETSGh08O7dJ6pzxDedVTOZbCuPhu0+2pB1NDtKfupnQhL7thnsGXzf9eOlxA3LAKdmUcn6eph/kVy7EZAp+t/sTmALRjhfQYe1nCCwC4/GjXp8SqMJGfIQz4eBY28S0q/kQ6k+6nov09hsXAiN79EG8wDqAKt/8h1X7SnJhyyIsYWcJ527MLlfZLIaAGr5ML6DV7bOIAqUETfH0PVrKJ9OFNySGyrs1E6Bwao4fTvlLKm2N9ZZrIdjrQ1dLjiq1GJcx7lL8LIprA1MXFteokCdhf/Bc+IkVPWtivnwr7OkCm0+bq6609oBzaIgyv/NsarY/9oyRQCX0IQN9HfW7CIozsOFojPHZ9ET+TQSryDP+gD79fGMKjqih/sdSvq04NFnpf+rfo8hgvKAVsJhlrgai5Qrr/r9XB7FuwrJt2ZufkMRxFfcw4UQmOCqh/gGqliABWFUWeEbwGdHZe0qH7df7KWLPo0gGbpTtRrrcYtxqZ5fL9wLBD883/pq/8k0vIy8eGZrOQMF/TH6yqwDmNP50kXXctp2gowzDtw/mDNIr1am6156DDjG06ssEg5N1WG0mCQcvO83LRTHrzmVat7cpvOOWFEdxt/m6OGedKV7vcJ+psZ+rjTGNWoC+w1Rg0gZt1uRLxM0tDGDBPzCi33ymLS9jyb1RxxMmTHioFv2jQO5TwlMjq1JmOZomTJ557ge8IJDObBT5wkH5se1vF79ITguLDZ/Bm+4E8xZaXcry5Kk944nkOpR5+fOW1AqWOwcEw9S62T1OmHEZbZ/d6puFVU+/7R8+nwFA2LIAxEjN+aACdIQGK3124Gi2MGPSx88hkLgXc9HR+TsYE+eMH/gFgnK0UBQoU7rHyhdYz6aDlqP9jMYDaS8jUvcGrc1qyHD0nBC5MRV
 qFPLZeEo
 +Gnl9geC5SfigiLHsx46FSa6+E8jHes7XDiT+x96LwOuHcd7xr6vspgzPJCL6dkvHcdHwiK4CwmKM6c32+G+0+q/ZgaZMB05BksgtHCaBqVJSsf57NEwz5V7AGxmTwLQ+ABf6HPltPXDHea+hTE5Cj5rCGUKxTtf2gP3dspWNzG7qOvTvVTxfgpvKnSMXFAc/E7tipItbSdT7rneXHsfhoKu5e/OxqUYbkvaa02k0E47zY8ixRLAr2xBom45r+9RQkid1WfodNkZ1+vUebfYfPgFwU/x++iOo7vUaQkGrRWjaPqFJMGDN36jbogru6zLLSNBe6jMlEFNGZZ1ohflL9S3ufh3HyDrLlRctUQGZ1P5xuDZZvODqzFpTISGETofe4AqGBmQwXApa2OpT1g2/3AHtpceP6pwbNsmibU9HdkaMyEPyGA/fe7hf28US6JeSOLuLsQ+3p8+yqvEm6kpcecvZ/895FsQT0kWCU4zo9psLt4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg_list_lru_alloc() is called every time an object that may end up
on the list_lru is created. It needs to quickly check if the list_lru
heads for the memcg already exist, and allocate them when they don't.

Doing this with folio objects is tricky: folio_memcg() is not stable
and requires either RCU protection or pinning the cgroup. But it's
desirable to make the existence check lightweight under RCU, and only
pin the memcg when we need to allocate list_lru heads and may block.

In preparation for switching the THP shrinker to list_lru, add a
helper function for allocating list_lru heads coming from a folio.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/list_lru.h | 27 +++++++++++++++++++++++++++
 mm/list_lru.c            | 39 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index c79ed378311f..733a262b91e5 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -81,6 +81,33 @@ static inline int list_lru_init_memcg_key(struct list_lru *lru, struct shrinker
 
 int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
+
+#ifdef CONFIG_MEMCG
+/**
+ * folio_memcg_list_lru_alloc - allocate list_lru heads for shrinkable folio
+ * @folio: the newly allocated & charged folio
+ * @lru: the list_lru this might be queued on
+ * @gfp: gfp mask
+ *
+ * Allocate list_lru heads (per-memcg, per-node) needed to queue this
+ * particular folio down the line.
+ *
+ * This does memcg_list_lru_alloc(), but on the memcg that @folio is
+ * associated with. Handles folio_memcg() access rules in the fast
+ * path (list_lru heads allocated) and the allocation slowpath.
+ *
+ * Returns 0 on success, a negative error value otherwise.
+ */
+int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
+			       gfp_t gfp);
+#else
+static inline int folio_memcg_list_lru_alloc(struct folio *folio,
+					     struct list_lru *lru, gfp_t gfp)
+{
+	return 0;
+}
+#endif
+
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
 /**
diff --git a/mm/list_lru.c b/mm/list_lru.c
index df58226eea8c..4eeb4351c475 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -562,17 +562,14 @@ static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
 	return idx < 0 || xa_load(&lru->xa, idx);
 }
 
-int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
-			 gfp_t gfp)
+static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
+				  struct list_lru *lru, gfp_t gfp)
 {
 	unsigned long flags;
 	struct list_lru_memcg *mlru = NULL;
 	struct mem_cgroup *pos, *parent;
 	XA_STATE(xas, &lru->xa, 0);
 
-	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
-		return 0;
-
 	gfp &= GFP_RECLAIM_MASK;
 	/*
 	 * Because the list_lru can be reparented to the parent cgroup's
@@ -613,6 +610,38 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 
 	return xas_error(&xas);
 }
+
+int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
+			 gfp_t gfp)
+{
+	if (!list_lru_memcg_aware(lru) || memcg_list_lru_allocated(memcg, lru))
+		return 0;
+	return __memcg_list_lru_alloc(memcg, lru, gfp);
+}
+
+int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
+			       gfp_t gfp)
+{
+	struct mem_cgroup *memcg;
+	int res;
+
+	if (!list_lru_memcg_aware(lru))
+		return 0;
+
+	/* Fast path when list_lru heads already exist */
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	res = memcg_list_lru_allocated(memcg, lru);
+	rcu_read_unlock();
+	if (likely(res))
+		return 0;
+
+	/* Allocation may block, pin the memcg */
+	memcg = get_mem_cgroup_from_folio(folio);
+	res = __memcg_list_lru_alloc(memcg, lru, gfp);
+	mem_cgroup_put(memcg);
+	return res;
+}
 #else
 static inline void memcg_init_list_lru(struct list_lru *lru, bool memcg_aware)
 {
-- 
2.54.0


