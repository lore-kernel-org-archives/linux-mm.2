Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E97F9106ACEE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55ECD6B00AD; Thu, 12 Mar 2026 16:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383D06B00AE; Thu, 12 Mar 2026 16:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192926B00B1; Thu, 12 Mar 2026 16:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1B56B00AD
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:53:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C434DC186D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:43 +0000 (UTC)
X-FDA: 84538612326.27.F9A9F09
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id EED611C000D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qs9YxdUC;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+fNWmGr+tcL8ctiy45XUsI2tWZ66Zdo3aVc9uo+wjs=;
	b=nIDU3RI5ZJLyzR3t8+YYIbyvLJqbjc3W+e1vxRWtPU5Av/KHQgvGyUztFiYiBiTjW2TBGR
	cKTkZSeQ7URZoybeS5bZFn0gK0+W0h8Rp9UrrkX21CCmHzLzTXD4kOPDizJ8FJBQpvsSvb
	fWBy3uSm67MOBjopyR/lcwpCe+xQYQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348822; a=rsa-sha256;
	cv=none;
	b=nXzlEXeCV9sfW5vZ9ZiXr3kkrUp7SZAc/LKvKRDi2l8/UrBtotdXa5FGtaA5e4+nXsFDb6
	+l2VgKiX+pqIne5DqFI2DNla3ecrOmb2VsbokAOfZRn2jfXVckl6T7/HMvMx3iG/IUfQ6+
	9F2VblK5pHBclyGH1zgwwCVPSx2ipBQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qs9YxdUC;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cd7ecedf2cso151201585a.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773348821; x=1773953621; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+fNWmGr+tcL8ctiy45XUsI2tWZ66Zdo3aVc9uo+wjs=;
        b=qs9YxdUC/LjRj2xFZKSmsczpJ8B8vla+IjqnY4r6gHrK60L2SfvmZb8cq+9spHueS8
         MOaS7/ZNEyso645lyzvjqz6afqdfBmn8E6Br6chYOeUcPPhZJZNbbpv21E/BsFTIiO73
         keuj7tC22wIeXYYSGiyQOYxhFqWUVRIL7LKocArQFw/7iKBk7gExPGiZPdw3LHGP/Pz3
         uUf4eabX2U0r+n7EQxOT5SRa31JsV26fg6bxB99vxZVu/R3VvGLo9cfA2bm5ZmvXDFTp
         P6kxvA28Rb6/KI7RGoCD+KBpHsTJdR77gIW5ESIro7gVReUQjkRuo9JpBwzjaRhqwJqT
         X/5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773348821; x=1773953621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H+fNWmGr+tcL8ctiy45XUsI2tWZ66Zdo3aVc9uo+wjs=;
        b=Oji1+0kL7n90sbIKWFD5h68eZVIE8u7yw14g0YXC5yZK9MwZ5ExNyhtCpBSm51kHcB
         aIuVrZPe983LvAz2nUTZIEUB1jCEKXZ7aYRySuQeNS+2rE9wmhjcUhsBOghZ1PbNRedh
         uB5sx0pJSN18siKbQA2ulqS1d7M9l1Xoqc8Y7lHtP66uXtQKOntpHJ7fX+/04944kMxy
         T8mvoreq+4t2xzJbRwCc8YKqcqam2e+ob2YDNAz/DCBV2qGZeJ5f/6qwSQvuO2HsaTN+
         vO+LoEjyeAdXQLqrmxC71fojUtaI/l0DcEe/TB7c2cpBXdIYHuOQAYggOrhrwkgMFk7P
         HphA==
X-Forwarded-Encrypted: i=1; AJvYcCVXfN2gDMwA0ZlYmvPkLVhVQg+VH+1PXmEmGekSdMR3oMJaWwl7ULUVVzVS7X1zpizHhkffvvnYlw==@kvack.org
X-Gm-Message-State: AOJu0YwV3vpaDhWndjekrEd7HQE4nzw6pEadaHc5B8pmmEx9vgjZnxln
	G31cBWNvh19C0ecBcTjlnMncr5lpEB2WXxIph6VnYqVQpIOqWPD2jayW0JrYnR/vsQs=
X-Gm-Gg: ATEYQzyEjCCSEesog6khalvH6KkLx9tMJNBFdtk3Kj5bqC7zQdpkBkcYZ5k9g6ngY72
	qcAo3CH/jr0jGhZJYbMc/XhivBSef7LwPzbh3iv51GfxcHeSuwZZZy40gu7jvC75UPdwAQ4BHOK
	TDKHZAXyZekXzJ6qajiv04B348AlplGNu+AjpYbTUU317Dw+/abCuSHEm8hLWrSRVE/OlKuDrPq
	noSL42YvQrw+haJIoz17Gkc4UR3hV9FPSD6tduyhLJbxCwWwDibMlbDOdtL4Llt3e11n3nQVcwU
	0rFvY/O1QEQVfOcr2OCvNQX0gur91LXWoKtntqE+pvqHtns6ICeJqwSeGinJeOZ5aI08A9uqlD0
	JRd1QflptKzXX1mfJNJT+Z2rY7NFGZWDe1iDrtuqxUYobfuuVrLITYulbApveSA0u82GyldppeE
	DQOC4zFpqiukZ1Rk7Us/3zcA==
X-Received: by 2002:a05:620a:40d3:b0:8ca:3d7c:e767 with SMTP id af79cd13be357-8cdb5b5f305mr157157385a.52.1773348821047;
        Thu, 12 Mar 2026 13:53:41 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda1fbcc5fsm465928085a.4.2026.03.12.13.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 13:53:40 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/7] mm: list_lru: introduce memcg_list_lru_alloc_folio()
Date: Thu, 12 Mar 2026 16:51:54 -0400
Message-ID: <20260312205321.638053-7-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312205321.638053-1-hannes@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EED611C000D
X-Stat-Signature: m4uh9q69bcmd9hiaynye18pmnz35qojy
X-Rspam-User: 
X-HE-Tag: 1773348821-524977
X-HE-Meta: U2FsdGVkX195LFt7yhwFfcfRoiEa61VbHw/ey1yS3TKWrC8Eff/GZ3dM3kzpWEELMcsNNNVcp5vybyc9TxCvON9B9cRI8HZIFegRA648xzTS5nPw/VagTxYz8wu1kkQ0gqrl5fvqSXe3egenVl7tm5AIYf5N5kdlj0+1QpX63jdcAAvCcAbqiZVWZ0qliSYXm40HeWvBl1WIi1NVl003F9yYP4EDxmnKmRTXQ2AfsSEhvlWn6VO3zCNA52xgF8NfMopB44XzAuuW/ufH6AEdj64zJnV1wZFULQsvefOdHrrFjmHTPXVuZ9rT3z+Adtc555Y6Mg4Gin39z+k34cKwRELJ0/DsZHKrCfsqZj+jTSZw31U0qVSPJCV8uQQpc1csbUo2+U5im7APOsFFvhtkIbqZMi5p5sftlcsjcnTcbmbCS0V4BrDB2xQ0Jd44613tHuoTN2496rXaVY4hmqgWvaaRVRYtXjDtzt90eMq4bbmW6XBZm6UEJALSLfPyA+UOA5k672JFzItvTVT8cOPDxvcXGZNa1EsE4i9rQeltsHfRuH1wnBT0w7igxm8nQBleJM4x+wb+JqKC4ApjZZ71u84i0chMh9IOg5sPrYWyoAx8lT0ntXp1I2ZI4q1mLWNSU/viYQgwTRPXtIBF0/YFYDDStEO3kgIxT8/1WDs3HGTwc1NtENXxAGKkKIQB4pcMl5hHTROBsaA32+VBojBQSmmvRrrdNe7sIGN6GgjIlTldr9Wtc8lLQMxCoIxBJZabvnmdgZUD3YAfjYqJG7bHs2/6IxRxP5TrGx6iZT3rbN2SND0SkvmkxfBTvRoMRBCnMrSKHlyFauZ5PUoEcLpzO5aJSSVFDBDltLikO8VVUsOkwsJH8nY4dimRhMuhBcPtuLmdJENsNh3FWcx9S6kW0Wmnna/ycUUkspSBjOQMDzBInkrfw3EvP1tVJCnVQ1FMgJcYPrAT6XvNebC1nVB
 7gCEHqAT
 +rsxyzkJQpc54+L0FjneMDlCLY/VsbP8Mh3ndSHp/4B9Q8t1/LSC8crL7+NvOesSk6CuwpqvpC2gioeRD+hxYW3umh1wyQLeiMIKxvh5Xx043hACOAeB5apROBC3+qrXrqgdLMXdScfDQszUagxmi+TBjqHG0rJMzTbnJDU8W7JSz5be62c1eR+SW51UF0gVt6Y7V+onVfNVhx9UAiQwn+3sktB8uNOOv/bJLOuLa3tET1VfmxnWraH0l+8qvu2hIWv+YCFZeggGOQxWAtIJRiRXQ8lhu/AfQm6+nk0HSXsB/SsqZXqSPw1ZtijQfU/JXvYiT8VmzSq7RF6+bEtE0pLh1AAU579ioI+L/X0Njm1rdjXbicENCxQNZkkWE9nkk7kaNbRaq4tG2d5uXGbeNK5URWXaxkikaAE477u+GgchJ0bTkf2gV9zQDYoASHiAoH9IK4KkjhtE/AbD/sT02dhk2Bg==
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

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/list_lru.h | 12 ++++++++++++
 mm/list_lru.c            | 39 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index 4afc02deb44d..df6bd3c64b06 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -81,6 +81,18 @@ static inline int list_lru_init_memcg_key(struct list_lru *lru, struct shrinker
 
 int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
+
+#ifdef CONFIG_MEMCG
+int memcg_list_lru_alloc_folio(struct folio *folio, struct list_lru *lru,
+			       gfp_t gfp);
+#else
+static inline int memcg_list_lru_alloc_folio(struct folio *folio,
+					     struct list_lru *lru, gfp_t gfp)
+{
+	return 0;
+}
+#endif
+
 void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
 /**
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 779cb26cec84..562b2b1f8c41 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -534,17 +534,14 @@ static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
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
@@ -585,6 +582,38 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 
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
+int memcg_list_lru_alloc_folio(struct folio *folio, struct list_lru *lru,
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
2.53.0


