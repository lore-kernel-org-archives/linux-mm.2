Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D241CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7436B00C0; Thu, 21 May 2026 11:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156B86B00CB; Thu, 21 May 2026 11:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0449A6B00CD; Thu, 21 May 2026 11:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA9636B00C0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:03:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D6DC40651
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:52 +0000 (UTC)
X-FDA: 84791746704.14.7654522
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id B02B740003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=aTTclCja;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BH9Ib0oi5E8fnc2UPrjbKjmGT1EOdGnzHGNmtCTvMlI=;
	b=hEP0AX5RlGGkloDgTSiRq0t7DUttYzPP+TM0iVjFWyEQc2RCcbTkDkLMz3mxcId9ACrnKc
	n/ki7dyHVnKAYyRf0c+rGe0FNP4pl4VW21OC+Kkx5N1f/hoUlTJKQe2NUgW9eWLaOp+f5C
	153wwcPtaB3hBxRfMQOxpSItNLzPmGA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=aTTclCja;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375830; a=rsa-sha256;
	cv=none;
	b=Dsp6TIYUxU8lSJLsLBlRH22qKeSXcHc3CdR1IJDYBdIQZizR7eXMAVDI18YzWp+QNn7i2w
	FRueq3QxgMghKyfSbLEqbrbLFvMOOZ+HdBu0ILEXRWcZnMjQhfWbq7UA9jXcQeTYEugO4+
	J+FUHXBJxT2ObYMyOpRjESa4vvgrgzo=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ca12973e15so84532436d6.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 08:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779375830; x=1779980630; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BH9Ib0oi5E8fnc2UPrjbKjmGT1EOdGnzHGNmtCTvMlI=;
        b=aTTclCjasoUlqNn7z3qLf9LrYNAr9MlvzwEPMfNdl2T5RHr/hseyRLni+b95dJEt57
         HslZcn5169JYHj40STZq7SJXo/Qcr+t45t8AsYsyNHp1GF85Y8QV7mtU9zeKzAnX091j
         eMe0z9COX02FAIREIxxpaZPzset5W/30MBDfWWEKk3+y+35EPfZcjIuoqxR2JWwSjbxP
         1q3FRIzDJbgn0Ht5n/Irlq846teakpqFqwY8wgWKl2tdc4XZdvwIaOEPa7L5pY4cqFGt
         CHT2no0rCAP40I8fe+K5qBhV0K2L/MOCc7oWA6foyTwIKZQUcrWys1SjP9p6joJRWxQH
         Lz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779375830; x=1779980630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BH9Ib0oi5E8fnc2UPrjbKjmGT1EOdGnzHGNmtCTvMlI=;
        b=dCl8lAWYMmgUx4iNbKLE2JE9hFWkuQ6+BWxn6kUJSytrbPu3hZM8NximuCtxp1McOF
         Sc387IN93O3dtTITV3heNPEnnv3UTtZILuMotnBZ00IFTJMrrn3Q7lR0xVC0KbufIL0E
         PDjrA7BBYeY24J4+xfRtJu+i4oiCO8vmRbA5TNKeitDzXj2ue1f8IR2onqKcLTHr20bV
         Bkxle2BfsRjuvQMNZSEAwH1+xN1cIwsLQDn5O9o2JvztB1Ig2AOPe3jvAo/UWO9x3c4R
         NvGZa71ip9IDcV9Cu8Dv7IYQ5AhHAO732j481iE11bXNuy13WWEpNsTjzFrxQOlY6Dhv
         s+qA==
X-Forwarded-Encrypted: i=1; AFNElJ8jA4b5ZzstOVpdXY9f3iHwhBa2O4ECPXe777n0h+kHEChSGD3NtCh9dLbAnqKsvwSzdXVj6aTKyw==@kvack.org
X-Gm-Message-State: AOJu0YyYK6c8LhXwZ7HE2mnpNecwGsQK0iOAY6D73e3MHF25poaa52+l
	ujZ6a8QXLpyNtayE3URYJH11llyAk0KRNVKAq0/u114GmX+TdbqPnXgeN+zx9Aejs9I=
X-Gm-Gg: Acq92OHBo/W7HN4YmqnMP+Z9njGRFRQWxy0BJ7ZvPqqC5x2NZIeez/+ANOBMuOXLwZg
	u7ipLUyMyxARA41RnhLpubrZCsewaoSdB/ea55OmfRSgYFO6IS8c8RUrFwQxDOwA6QPCXRdwJoI
	4khMIvjfW90VZ0lnAge90sMldsOoWpqFOsARnDtuNXVv0zA+MwoX6WeclOdNfcgBkhS0nI58y3u
	ipRMgBZfjsmjMVw7tCxs83p0g8MvQKC8R8Oz9TW2d1IOHFVEucIdbgYYcWlEF7LHla+aqHSSiUn
	4/2rIarZGIK4Npuk2gU4uR73usmcLCugFUCxAimaNK8t/gOjrcEEo+MZLKg4XSWi5UQH5HZf4PG
	lzyxhxOso47G7nTzUdDXb3Qc4t0OFep1+Jd4IvALgjAj/IAQHjkBbVwnWzFOQQ9nUqpt5qtE6vS
	wwRCXsrSrxdsjGNG7sB7wbrMKWL9OcfWHt
X-Received: by 2002:a05:6214:3a8a:b0:8bd:6baa:6a0c with SMTP id 6a1803df08f44-8cc6e31e7ffmr51218506d6.11.1779375829379;
        Thu, 21 May 2026 08:03:49 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc768b7032sm7149496d6.4.2026.05.21.08.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 08:03:48 -0700 (PDT)
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
Subject: [PATCH v4 4/8] mm: list_lru: deduplicate lock_list_lru()
Date: Thu, 21 May 2026 11:02:10 -0400
Message-ID: <20260521150330.1955924-5-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260521150330.1955924-1-hannes@cmpxchg.org>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4rjhfsa8nkejmkcd67dmp6upm6yxwpy4
X-Rspamd-Queue-Id: B02B740003
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779375830-216083
X-HE-Meta: U2FsdGVkX192JzEM/RiHjXQQ9/ifggdsAzAfuLxc2D86o4aP5i2nvKj0KD/nyV+F6Ls2hERXCKvlPPZ91L7FFEFpOZ1UfWaWELObv2RZGa/St12H7oqI5TAPdNzWocQfqJgkbGymGUuvWp8BbncFQZBTKInSrog+3B6GjicwSto65lUOQZtcYkU9lxuywmPeDxyXbrh+Sea3/qYmc3UsoS8H0cQ7VrSVQOlpoiCgIEBlBJGMM4pfiohysLsTpPZTcGGUY433GHQXcALkjEfWpvsxErfNQnHhrYRLHAYPggxe+/6QNreATxaPvjGJlXLPX5thYkRRuDriBv4iPl+B2MgF7gr9g492T9VOOh5W1FrduDcyqX6xhjsQ54ofiEkQplE4q9wjjcsYAVyv+KyxqLKmvc2klH+B0pYqV4R0unBL+iAtYcy648rC22nlS7O50OndhSgTjZSAm0OVUyjLdm2Nh5+pVMq7RT0T+tuawtY43XCwW4VVoElG97jE5dgOcFUhHeL+wXL9GAKYohRUc2oF5vInZEGXkMJyaTO82fJHdHDSvoLdgg0JMjqklta6LQaCMCSUU5dk3+2nCLZIK/HxaGYexUquGco2Lbfa93kVx/ZF69sIM7mBPJAHvWWcHRfGhhEy0Fi/Ktk+zercoJ6nwnNrArJIIG3KwGK2nc5t1AcdXdrNtnDLc2lKG/IMr81qrcCadfto7WAvyi5CENRN6WsdIg2TIDJFxvLvIQ9toPHwHP9MwTv7MwWC/Lj4YS/RpxdbdMUQuPqN8Bo6vAHuG0ghQN7XUc2x05+oDHuNZuSWEUH9GWZp/Iu3WyAwmkB+f+z0kAatIRaFzCshcMKBOmpVN4U5j0v+81N1Ufve2Xznm2kpauFHaBXiTxscSvXEtqQkmBjHuj93X4YuSHR6llz3JiW1Oz1VtbPaOPHqGlxePWIaP4E87VIHHf1Z2YyNYHD/tETBqgw+EXB
 CsVy0ACM
 LPzCuT6LPWtnhFRPHKlRWuPKhbNFjZ3KHuqIRxR5m2rz/kWa0CVxicTHBerdqAEzMNOZvf4X6DOOVJt1g2zDmGnl27wIKoqNLiEx1gqsLJk988JxZE+EsgNchQhbNr30JCJSprfccShj1j9JR2+XdzUK5vTaWEXFL8v+FBGzKsG+r1wJEd2nGc9vcpOf/zye/MEIeG8VNSC81wFuQFIJDHQrPlTrX3PCKvJZgodjXrOL/dC4zFqyojLi7wTrmbS02rjKG0w88SUECdtnRVx131mDAS5fecrT6kdLZ43R094gMdKY5otyAylVolejH3AlBZG+JaXj0z+9WxEmIMJkMpzkFEYkj0YFwYTCp1xsjYRwT/Yvvs+to4LpHG9dcImXt0lb8TUYyWP4iXCbKix/R+Wyk3otS7jVDEbnmeMnLRyvyjszxUQJAKelUuCmGKSR0kueovZkgNAhL/BsioCxTx8hts4GVu7l7ruqQkZB9Yd3luXWhmDU175/xaqycrNXphQ8pK8ZE9JYQuTE0qzisHhin/TDTLY5Hsm8X
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
---
 mm/list_lru.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 9da6fce19832..65962dbf6dda 100644
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
 lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 		       bool irq, bool skip_empty)
@@ -136,10 +136,7 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
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


