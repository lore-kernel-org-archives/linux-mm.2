Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CE51CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AF106B0098; Wed, 27 May 2026 16:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6880E6B0099; Wed, 27 May 2026 16:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5280A6B009B; Wed, 27 May 2026 16:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 458136B0098
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:48:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEABA401FE
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:17 +0000 (UTC)
X-FDA: 84814387434.29.25FD72D
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2CA63100008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:48:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VhVov2tp;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlbqhKiDqWS+kHnDvkCX36mrjE33rRvlYf46I/uZLtE=;
	b=TfvgNa+HZjFRQLlr5G+XrpkCtVvsAA1Lm7X1vcGPc28GIAF/9H6b07Sra2/AtbeNN4jVbC
	Y4JCjqf/fvFD7+GhvYRbNyrZwNR+Kd9SXGnF4/afrzDdRkgWj+aPFxry4PVmX7fsn7YmAl
	f4sm7K6m+00WT1cxih9huIu0zcgDLRQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VhVov2tp;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914896; a=rsa-sha256;
	cv=none;
	b=p/OFUiit6qAdWk4u6LylwzW2xrXY5mFJfzEsqvxxaYer0RyYqti82w7E0UVHzBoRKBvRMi
	34HYOBkRKW5buVN3TldQShTgfdYJ9OZSe+waS2mKBv+wx0s5zd4b/+3BpuYhVgolj7bHiL
	AJ+oqQcSngJZm/2KtN9jCteQ9dHDlCo=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51306c36c3eso132087861cf.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 13:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779914895; x=1780519695; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dlbqhKiDqWS+kHnDvkCX36mrjE33rRvlYf46I/uZLtE=;
        b=VhVov2tpncb9idDKk9MDlFfF/AEebRr6JNmnrPkYRH8o/XflACHbVGgSaA4oztqMoZ
         VdXYJdC2O61ABz7hlqkeub3UqxZeFowv5aNodR2nBuA33Hp/cpuXLspUbEQZZXeQ77nB
         prFRMMxhgXsOKntcE+dZeXUG+sXBefH7LCtgd/8m4PjxkQVCs2VdHpIyzwt2w+9pBMMK
         dbIlvXFrmFU9vB0O2HRHsFGdjZOTWI4baJ52fWmRg+DFEPQ0VKWkc85RmA6aqone5ZI1
         8XDrxU4+hQzgdrQYUCzyl8c8b/by3N5IkCuP/iESWZIflngvtE6lgmlH5LBJR3yKJe2G
         KfRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779914895; x=1780519695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dlbqhKiDqWS+kHnDvkCX36mrjE33rRvlYf46I/uZLtE=;
        b=gSt1ztBsBT9T6BMCLKiPFWoFPd203xhA+KCMBqFUktdmRpwpG+vSa5BUlfHMeWixkv
         aWELgmsFnxd52AaXm9nsz0S4r3DM8GYVUEZrOrsWuyz+/tx1VFvsTrkPnHrFkRYH0k2l
         jajGgAzgMmfbgXhaQ0K4OWzUUKIAOo1z2ACQJLtBN6waGLBkrDjL9Y1FdAu+fC3UyMo1
         WpcE2KDMAIhoddI2T/e9/tNI6IqlFxdO558SIF72Yp1GsKlM1gYVcr9LOu3+DzCLdn+M
         i5RQVQddKNIqRPpzGBzEsvc3W09pY/Oh5s0+E4nrVvh2IGsLcJE3/9GrZSYw52sd54Ga
         xhFg==
X-Forwarded-Encrypted: i=1; AFNElJ/Zx3usMCKt0tlLaO1Ak4jsvtH1DIgkEkQyrcKgwqC8ApWnO/eZyS1iQ0Jz/79h7Hm3VfFI6nNSZQ==@kvack.org
X-Gm-Message-State: AOJu0Yw4D/y+k+JXhr8jbAaGOovMwypieLf4t40+/ar0fauuSNKJHQ4b
	q8ez5Rk2FHAZQdhVpVVM6ToaE+ebn84h6WIEte7K0cDM1ZXNNjjC/hgtTP9LCC/ubd8=
X-Gm-Gg: Acq92OFr5bRxM/OEKgTVLQKM1SdE8d2A64kjYfWkVo+2EFWfCSgJUcq7+SRfs8ck+vH
	OdGRTXRHsDNJgvoTZd/e+aRoO399eFhUUe3AIVtdhUaRYPyo/TOQt7HjGORai4mnuwCX/sH5WTZ
	k0M06MS5FUHwuB4KswNIURCln3SVH+a+UjyFP/TpMmC6qleXmMRAmzuBedc1A7uEN5/JzSTycYs
	Ht5UlEz8EN6yqoIZq7wQjBAEtkCSCS3SiGt3/a6hL3fximrRUpkNhrG6/SB1z2aM3Kj13pVVECC
	65sBXigTj4XrbjwDKhJyrzLM9IPtMJ5h+/zTyK1684K+t51NGvLWW7n12FBKYBw0c1FRxhWwTo8
	WSO4n0gKVxkGVxKsA4UIvcwSnbH54AqoPwAJSMId67FZLSzwGmJHXbKZB9nE7IehtZ79tq8k+sK
	BKBgsjGgujcLD/CpYbGewZVXtkE/82q0nx
X-Received: by 2002:a05:622a:134d:b0:50f:c5d3:a191 with SMTP id d75a77b69052e-516d429f541mr332100001cf.13.1779914895147;
        Wed, 27 May 2026 13:48:15 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51706af4fd2sm52466431cf.25.2026.05.27.13.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 13:48:14 -0700 (PDT)
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
Subject: [PATCH v5 5/9] mm: list_lru: deduplicate lock_list_lru()
Date: Wed, 27 May 2026 16:45:12 -0400
Message-ID: <20260527204757.2544958-6-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527204757.2544958-1-hannes@cmpxchg.org>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 85ikfekp8kykhz3c45s34f8q3iaag4wd
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2CA63100008
X-HE-Tag: 1779914895-507256
X-HE-Meta: U2FsdGVkX19yS38KsCIwRs0G+5Sc7sIUgw7nsj+tA5J9qHKMTQk4Pj1LNDbXV7Yv2KClf2dIWzKRZAQVC+xc5AsulJGc4AI8pzY/eoFBfNia6hgSipqJ8HF/ziY386D09tsLTqPARi37H9Rbgi2BP8vUI68gv5y4fRt+GrPhYoIcDvXozo6IA1M1g/70YiIDMf/oqsct7jdka+8FtPMct6wUH9EQcrnr96NP0QSwPcxWCSL+JmAd4LegPuMmQRoSsHjN/bluU5ukZfxLPMe9bDYuQhXRkJrzrkML6l3Dnco09kFbnxeKCn2SXgH41HQTVmAc93+IyqvizrbmfipulR9dMMbd5V3xY1j99S5+W050bBJssrly0fIy5adL9wKM6pLB3TwCI7PuQW8CMogB+aMLFEhOOpe5JnysVfJwpQvwsCKSrH1Q/Inpn5ci9qe61LnPVZASpfHMyhGGwLqJkLGiLduzEIz1A2rjy7b4OYdCrJq0qmFb2X1w6zT0jvAOOI1SXJ86CMObNpQYMqL7U8a/tJq+oRnMiVS7Tk40UDvXbFq1iN1/3vzanPD8N5NtqWhe51YavFUn1TzKERak+TeuzpCFJUmdt4k1+i1mPzoGRef+7Z4aC8Mqu3mgl3+8yW6mWgFBUsUPbRgJ0H9hgtuYs2fPe9eHtSu+kgrxp/vAdWrS0zlwmmMCM9t8eahvj2dIsZ7zNd7GK5CI4Wk3rTP33yfEaIYrtfoPiA09vtgxw2KPaNcHq4tLNmdhf1mW7E0fpNtej0RH/UuJvuDDugs/qaXRGvd+r4pHfCJ/tl4sEkiPVsFHYJUgm8Msv2DCPh1t7yWe/c8U82TUPJtZuUdPSCoqN0v8RxbVtS4sdiEqWZ5duRgVdbqzs0Tut/37KlEO1zXyaskEdyxZi/IHLwv/j5A9m9Egzms/8cxaDeMQLzWnX7Og6tKIvREGTs0G/ear0wT4NEtJFr9GuHS
 0zHBB5hd
 qoWkPSZOIhV2gtHlJwROXRSqQgYE2+Ri959kEGza456tg/SFIjcXT8CBTkjq+gU6DzboR+qbBw4RMAtDc71lPtxzPsPWgGVmamCIJlTdZk+HKq6zdE2fbn1JBQTAAISch5yG3OOil0f5RYpkPckwn1pQUCHmY4r9+fQtpG+SMtK/GsHewwN9aMa76Vds+L2N4MfRuUzB4wpdZR3y9rw36Hd47Xkd3HPtz8rrWmPkKYId9TYLMlVvpOOXsu/EhPdcTHQbLQCaEFbrzJTheQu5g8awBIPvFnIgmDdo/ShJfm5YL+R8vKcuzIWeBMYmK2gw03wCSxzIR1lnbKv98mtOzSTVsIzJo0Nw1+W29YtDEMZO8uas3lfSjHguYwE6JWum33MBjaMFyaJ7rFncJNgctBttBAIqLrzDggAxq1MqpX/9UsZIx/TWM3WwHOI35gIFhZM/4SojbkFjB+hZtZkqAcweDnUfYF9fpHOG/dUFe5+7CgILNpBm58933NX/Fk/khBUVCz5cP7bE57K6ytfsQOx3VkdACkGhozhhhMkP6+Uz5QlBHRhGW4a5Yasir/33Z2Y/ddNaVcJAw39HScUniM6VJSheAzXRsEbnT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MEMCG and !MEMCG paths have the same pattern. Share the code.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 mm/list_lru.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 7d0523e44010..fdb3fe2ea64f 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -15,6 +15,14 @@
 #include "slab.h"
 #include "internal.h"
 
+static inline void lock_list_lru(struct list_lru_one *l, bool irq)
+{
+	if (irq)
+		spin_lock_irq(&l->lock);
+	else
+		spin_lock(&l->lock);
+}
+
 static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
 {
 	if (irq_off)
@@ -68,14 +76,6 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 	return &lru->node[nid].lru;
 }
 
-static inline void lock_list_lru(struct list_lru_one *l, bool irq)
-{
-	if (irq)
-		spin_lock_irq(&l->lock);
-	else
-		spin_lock(&l->lock);
-}
-
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 		       struct mem_cgroup **memcg, bool irq, bool skip_empty)
@@ -136,10 +136,7 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid,
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
-	if (irq)
-		spin_lock_irq(&l->lock);
-	else
-		spin_lock(&l->lock);
+	lock_list_lru(l, irq);
 
 	return l;
 }
-- 
2.54.0


