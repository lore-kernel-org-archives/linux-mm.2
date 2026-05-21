Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D056CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80E416B00BC; Thu, 21 May 2026 11:03:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF596B00BE; Thu, 21 May 2026 11:03:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ADEF6B00BF; Thu, 21 May 2026 11:03:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56F716B00BC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:03:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEB3EC2365
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:48 +0000 (UTC)
X-FDA: 84791746536.07.A3CA7BD
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1B021C0002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=iuqCcA4v;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vn9mXwqyXlTnHz6VCNHiXrEOY97snOle2kaY6Iy8PrM=;
	b=aVEi4i9kkZ/Wwbjnfp+uKBY7LQrk7EaCqrynJ6ZBnXNg7ntqbkcfwntYnCNtdMUbcVEN73
	n/s/pF6ogU9irnUsHZOUFP8DvHxlrS3fSO0LCFoDur7Yt5Jns7ErjZmbCU5y1WskmUk1Te
	XFavMCKSheDv8WkQ6+Hl8hjbXJIbekw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375827; a=rsa-sha256;
	cv=none;
	b=T6CZxishv+6824bYewg/Q64ExzMxkZXOBrROvxtXio1fJT+nV99UBfzpl74jXK0AclSzRZ
	3a4WI6OjAtGXQbgPOz8re69akaZO7CEsRaK8VMWtY+n6o5BKaHVVP7mph/ESQ6n2VPUKBR
	lUcuSvX9HNl4rTgIOU2zsCl8+CDNvDI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=iuqCcA4v;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-516389a9b70so67617731cf.3
        for <linux-mm@kvack.org>; Thu, 21 May 2026 08:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779375826; x=1779980626; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vn9mXwqyXlTnHz6VCNHiXrEOY97snOle2kaY6Iy8PrM=;
        b=iuqCcA4vzyOsNfPdaxw46we/1CLmfy3HqcUOcsv/RIdjSZOuv+4yIlerCU0DPVt1Cj
         8CUGYZWy8/c0OR/h8t4p/uVlkwytEjsDwQJVl9PvhcFKltdZu4GDVsi8089zpB9B2L5b
         qPVixuC1Y0QmgjIkFvRzZUfiPmfQWPAwTZLKmswwJX3WXQJFoueeNSSTkYGmx4/Sgdur
         rGecGag1JOdqJQGv/Gb0m3cNTxd60J8tFuP8PrMfF6P6xe1oLLyzYcOnudvK6WiFQLg5
         tc/vjYwef8FeSLN+Dze2gcTqsaklWWKAQ7J4YHGixoSm0ju7/LFdV9Wtj9JLohWXvE/N
         t67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779375826; x=1779980626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vn9mXwqyXlTnHz6VCNHiXrEOY97snOle2kaY6Iy8PrM=;
        b=gnmGKOUuEKgxTzYNLKtuVK0E6SC1HpBo5DbAFukpzbrkVbXp5F7wCGiovwn+dcNueN
         OkDjC/QyPd/sLq9KxV8I2ub6m2o4flam2mpoilXL/uOtge9t+vfYWkNN7Nyz5zj2Z1qX
         Aa59RiZGGa3clRvdkkoX2KdmxmeHnc+AHfHMhcY0MDQcv0PbZn16JTrF/WIC/AubeYUW
         YytVQl7Wb8/YIzBDpU1xCzZz/7bXIXCFgq5RlNwBOah42l0hfct4otewA+hGCDynkano
         lwqxy+1YRKyMh+H8zI0bNjlKglfomURlKuTw0Act+a3BQUJvhk9WGxCKi0i4gf63tg3i
         EdCw==
X-Forwarded-Encrypted: i=1; AFNElJ84wSFLGNFp8G1atcagIoA1YIWHyPQVmkkWy6bJB104Mn/dJOHnUZ5MVHtW7ZYHhnfPhQAl9d4B3Q==@kvack.org
X-Gm-Message-State: AOJu0YzODSzpXa5UOedTKRb5txysz2b2mPZR7Di2D4ksp16ipV9csheU
	tMXy66WRd/VAMtkpKI0qyymfkej16DxOkQKle58ebzN6GOyeadWb5p5kmq7tqGek9bw=
X-Gm-Gg: Acq92OGGdm0V15SQhtZelvwWgQnLe7HgOGoldAXscT2yVAG+AvuDL337tRzN+BlRdMV
	GSp338JZMQPBFRwLsIsIVzJYomilqzXO7VlpZaj+AcxVXF0ZTYpWS/QoROQtO0VgqnAzIA1p8O4
	HU/lhzTIO20vWKrrrsnqiTK5cWG2x7F/LiqOaPLV5cLc4QXu0dPkwfYFt9dT6p1z/9aR/ObaYFT
	y2M3Syhdhr687/18b8fDJo4LR5fr3TfLk3husX0dY9Z2PJe+kwVRxbHnYPm0hlCdpvFI0B8a3bz
	84DKr6onimW+Ux/frGlEiQnPqXXipnt01Pov46IUbx/lWqYVxZkdyk7tb5bAa98MZAEikLsrPKN
	pFdSztkjHcEOSpX9A/wMFoOwhmjLyoBJwRZKIkOI6R/kuqXBcXAJmi/I7ItejAjfxIsNp/sIi+m
	iHn0qedchhXL/k5ThS8ij9Ag==
X-Received: by 2002:a05:622a:4296:b0:4f1:ab79:fb18 with SMTP id d75a77b69052e-516c54e89a9mr45144641cf.25.1779375825779;
        Thu, 21 May 2026 08:03:45 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516cce01aafsm8868781cf.21.2026.05.21.08.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 08:03:44 -0700 (PDT)
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
Subject: [PATCH v4 2/8] mm: list_lru: deduplicate unlock_list_lru()
Date: Thu, 21 May 2026 11:02:08 -0400
Message-ID: <20260521150330.1955924-3-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260521150330.1955924-1-hannes@cmpxchg.org>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1B021C0002
X-Stat-Signature: 4crhafyq4hketzpdnm34eshmwnf7hz1o
X-Rspam-User: 
X-HE-Tag: 1779375826-846947
X-HE-Meta: U2FsdGVkX1+0K7+QGhT2JC2zPoi1njg2QTwKim6uBhnAY1dUGnrz5UnhvVhej84nK8jSrmv92elNH6rroTkyh+o3m4H6iW8ZgVEephJZuKrsN1/I/qjKc6Hvl5akgTv7he0b6RuexjwFXsZkv56CLa9w1HzIPAJKVnkmOds+CeURyeIDTs1VNDV7fDdSDgAswqvwJ93koO6E9Guiikboj40RjypkdcS87oFU3NXXmEKyKAGBZtvSrBBBn2OCMd237th5InIg+dOHweNh5YZgiQ6w+Wdi9E2zXmVRuQnd16WcmlN0TX2qg4qzRLX7Ln18j8sMpyJZwdjTEGeyopAcFQ9TNgvOjzGMIQxVNB4ONW2RbqFHUlahN/hpin6m57aDjbmWqhWBvezY/scrkSZ+6HWL2vlRdJCPLmqTadWxrbXuUxZjNmRReXMvFBNsp+oGZgwQPseCxAmMZ5l/0L1S0re7SSEq45XMY0M8E957E0kkpJZRtKoFz5q9Lq/EuKAvhLtbSXCs+gDX+bPJ1a9rv0XUY00CX5R2XueEMY2UIbkChQ37N7aVPxaIigvX8SyPI1KOOhPfRsEA/fQAEVYVeCSJ6i1hVPfQWuyzEt7TQMA/qfmtGpPzdtVufe62Bb7UzNb8Q+qfqqOEeAcP03y3Jf4Abhfs7IZWuQMPt95z888eOqvcRHQylzkmR2IgAorH1R9Rs18dOrUfzL5az074mHKFo+f59hksy+iSmlrUxMEv9PidoAhSkFz3X7CZdoBqH1zZmzp1Pcrms/xoBXEZXHp4Dy2ZojToPcDl72OMkCVPXfdjYbEkylbtphQYnHW+jPhRhr4wpDLU9qk0px9zzkJKeSBXP+QKfQpiHyDgsshm5pNhHB9jSVkjWpH3/iY6dQE9V8aGanOMabvB9hIAlL5+3tcK3sIZrjln76A2FTGqV+JbXEXnPHWSImQz8BZcEJy0RJGZzvB4/3JEHWn
 XdEJMOrm
 twbGqhN8A678TXqDA7P/RtggE0f2gXoyL5htng5AQiK5w9ncjuK8ataElsV2z0mmWRwAkqednl4NayCt4Q1tSxEScMGvNewyIBJdocmUB//5Bj7W0vUFt3Xhny0Z1D802kTl11voqM8D9njmXrRXzcGxEasNuSEGV0bK2RIfAr6/Rp4MyqFAyflAS9MkYfucPynyF0bSZ3jaeWDjNbo6qF25ODw/aTTMZISYzybCeXiMhYl49plSjIPcuOKxKTYtXT0ESasQfPZH0lKaOrOsOztUEJSBOFxUJ74BrtV3e8n3fQjYTMmxX0kLcG3nA5uOkU7XBOAlVN/d5KLeqrLtg9Dmt5hzlcMVMGXKZNmO4zyQ6BkFBfwA12wF16mPHBKWNN49SRP2GmQTU64RYTw0QzKtS0epunXbmEy0DkkE4tE3le6uoxPvVcXrWGHJylbGbU9koGHunzgZXR1/QeYqmvnSsFlquMCzJdAr4sfcjJZjdlgU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MEMCG and !MEMCG variants are the same. lock_list_lru() has the
same pattern when bailing. Consolidate into a common implementation.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index d3619961a7ac..9a68177619bf 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -15,6 +15,14 @@
 #include "slab.h"
 #include "internal.h"
 
+static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
+{
+	if (irq_off)
+		spin_unlock_irq(&l->lock);
+	else
+		spin_unlock(&l->lock);
+}
+
 #ifdef CONFIG_MEMCG
 static LIST_HEAD(memcg_list_lrus);
 static DEFINE_MUTEX(list_lrus_mutex);
@@ -67,10 +75,7 @@ static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
 	else
 		spin_lock(&l->lock);
 	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
-		if (irq)
-			spin_unlock_irq(&l->lock);
-		else
-			spin_unlock(&l->lock);
+		unlock_list_lru(l, irq);
 		return false;
 	}
 	return true;
@@ -101,14 +106,6 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	memcg = parent_mem_cgroup(memcg);
 	goto again;
 }
-
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
-{
-	if (irq_off)
-		spin_unlock_irq(&l->lock);
-	else
-		spin_unlock(&l->lock);
-}
 #else
 static void list_lru_register(struct list_lru *lru)
 {
@@ -147,14 +144,6 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 
 	return l;
 }
-
-static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
-{
-	if (irq_off)
-		spin_unlock_irq(&l->lock);
-	else
-		spin_unlock(&l->lock);
-}
 #endif /* CONFIG_MEMCG */
 
 /* The caller must ensure the memcg lifetime. */
-- 
2.54.0


