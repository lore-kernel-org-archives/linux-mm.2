Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29490106ACED
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60E06B00A8; Thu, 12 Mar 2026 16:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1E9D6B00AA; Thu, 12 Mar 2026 16:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B03FD6B00AC; Thu, 12 Mar 2026 16:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 96C446B00A8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:53:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 447CEB9150
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:38 +0000 (UTC)
X-FDA: 84538612116.30.FD0C532
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 973DE1C0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=EfONuUy3;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eafNr9BwjJfwIWHhaZifojoDqJ10dT0nuYTLu1eoj30=;
	b=TrDKqiJRVNPZ3ncbty3LOewQoiT05Rmo/+saTn6Q3GioGctORehn2cB56sn+7Lw1MVGAyY
	pCc4N8OHN/4CUeyEf/TgQL9LPVn279kSbgk4uHoTNqlxV65JWLn1FItiaJ+IIKMn0U4Db+
	fWfn6fxA1sNnXPN21zsZt3oPttZ+Pvw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=EfONuUy3;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348816; a=rsa-sha256;
	cv=none;
	b=ggpIaTxhbnp+ZdPMxB73fCByTLnHSPF5tlGZeT1168ZsnHaoPkCAADJDB/6uR1HXMehMHj
	nunViWYtT9BL9Svuuxy9lRyjtqRqjmpU8ENdPuLMIKGp0tteGAGRmN9ePa/mixxeb0XAFp
	u2zbpiJgZpDe/y24pFzi85SssUAXBG8=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cd79e43da3so150171385a.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773348815; x=1773953615; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eafNr9BwjJfwIWHhaZifojoDqJ10dT0nuYTLu1eoj30=;
        b=EfONuUy3nHIbMWel8fBmmPRSdYLN07gjRy93bJUNMucfZ45KwHbCN+7vTnoHndq1V5
         Jjnj1FhYhrNurDilQzXvMPJHtocunoebIU/I0EwSk5qptXbMWRViXorp68EIqY7gRKvs
         5BtXZ6QwMHIlNtYjdLlnV6/r0cLmg2bq1Y0OARlSAsV8cgTJs7Z4EuU4EDRlKM2VAkoF
         6iJnPEpctdZSuY14nWHfm8qh5scP1qc3HkzkKdMhXed3fIJq6oXW5yLlqHPoUablRctI
         mwelnreWVwWt9FAU74sqCNQWWMdmNadcc/0DxTPLXj79ZgFb5Ww2l6ezkxBybVuUemIP
         IPKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773348815; x=1773953615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eafNr9BwjJfwIWHhaZifojoDqJ10dT0nuYTLu1eoj30=;
        b=B1hkTzJ8OQ5Z7b6cB5x2H0yzUzjGweA9XbKIlFzHUvt/DtPeWCI3LthiTEJfoHgxFV
         fm8576ZR6Zbijs6IYoI5IAmCJSVpn2EOvPQESD0T98lopCgFBDsY6vBtPrWvoD+/EAeR
         CJc7E3E1O8Ppn5eO6+89CCYz6g137pTe4en0XeQJx+tP1Sjej1FuK4P62jVCE3lzRHjW
         ZuTfQkqubuN3VK14/AexRUt/Z52q3S+spG66ALMTurETL7Cwikk+Ud9+G7aMwFTaEVxa
         ZMt5/VG+YN3k1fHYrGKDW2pC8BJYAsrZ+V+VxZGYN9ZyV6/e7kAa869D185deGdNJLdk
         24SQ==
X-Forwarded-Encrypted: i=1; AJvYcCXowSNbBXhi/lBTJhDxB/oLtyfNpCRS3JuM45zRR1ZGtWPSy6PG50YtwFLFUa0hgZ/bylxHJ0M8Wg==@kvack.org
X-Gm-Message-State: AOJu0YzFdFFwKx6RS3T8vgfhl5Tm6PbgMxC19Egtt1fmtiWOJLDsI+dF
	Inwk4Q1TChHGthawzWFpgXqGtZyIHms1WP8hSd1j43Atm17o8AU7RNqNP1mkL2mnKTE=
X-Gm-Gg: ATEYQzyJUrwcAUtOmM4onqGwbOStAQ0TnNRKUWPnKmhFz7SLULHetNfJG8sNvosO79v
	2aDHZz+y7/1mQgdp3r4mFjVCAEdQQFxvEDp+XZ6NbSVu8djeycRulrYqS7F+Fh7wtwLXaslkdFD
	Jfe/hEHbbpz34bXalBmV9Gzuokbty7OvrFQw9MDIooNKiDYXhZksWHJEI4mi447hA2WAGLlHy8w
	3LEekdAy61Gf1N7EJN1M5wzl230JqOwGvR8TMpt7V/YSRyG/DOl4NKBqgjb2w/tmN9bMPPhINAD
	gscz7HrZtLTyIHsdFO3QFUIMn4y+yDofcB1Vi40iZ1hoBNNR0M+e1QkXinVbN48tyABrHvJRKQp
	KJKbccS8xEDO1/2+52ign1ZAC2W1rAVjhIxz2XVcWBHQDCGBtUwyCzZnnK00T6zOuHk32h6JRUe
	XgRIqGWzbmQAhBiTGFZzu6Ow==
X-Received: by 2002:a05:620a:1a0d:b0:8ca:41af:32cb with SMTP id af79cd13be357-8cdb5bb05f4mr160267485a.77.1773348815504;
        Thu, 12 Mar 2026 13:53:35 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a6e736043sm29875566d6.10.2026.03.12.13.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 13:53:34 -0700 (PDT)
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
Subject: [PATCH v2 3/7] mm: list_lru: move list dead check to lock_list_lru_of_memcg()
Date: Thu, 12 Mar 2026 16:51:51 -0400
Message-ID: <20260312205321.638053-4-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312205321.638053-1-hannes@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 973DE1C0005
X-Stat-Signature: t555mjpezr74xf6p6h6rou1niudubd38
X-Rspam-User: 
X-HE-Tag: 1773348816-659251
X-HE-Meta: U2FsdGVkX19JTULyHJojuiJRvRS/1xp0Ag5lbppKiMjf7s4DDb9cux2G3VC+YY2fzWSGoodwQuC+V69v9+i3os9Ccn2lgsiJ+ddFFlgtnsdnJ1lsfXX10y6HVfgKGb9Jam5yeqcQbjRtw20w8lIbtfFTeAeDOS5LVmIkjwzcE/KDFy2ILm1aNJVYhp+6o6yK+Cl9DX+YCiY7MlPb637nR9+uD62clqe25qO6NVjkZIAp0PUkC5RPl4SvJqnX6K50xYFv00LEe8huPRY7VqAp3QdXwmZTPoPQE2m2w7B8UeljlHSlegWeyQmm11ui/P2yY3fQHJ1rn6U2FGIYizCx1HKKquwICQxDhW4aJw/PnawsEu1l/mv1uvXQqkGHVgxcwxz5jZeejQLyV18woiebVMS2S59ei82PDMA6SofGCRvkMxf6tn/soh0k3DywDfGNQv9esdyxWluDU1QkKTz6/kTIdhBZnZalvIsuAlLes9UlCo86E0++x2yQB8m2UlomugVwQEVQ26j3MnFcCNrtWNfnxYjyjLMNjDGnTxT8V8E5e322XMgtAfDyMZDtZ+biZgjcZpQD8zOHfw+ldIwqxM+Mc/VEXdRBaVRgJTQY3uo5ZB/+XA0bfrqLSCmaXcc7UsAP6s6mtJDHcPnvD0U8yk3zSkxBke4MQlzgMWScx0hTVWtBJf+2zgjthyKtF26zoPDdvKz2ics9hzZbvEJPdXor9XiTED8XcSOvxCwdjSoc2cFc4yZv+pT++aijJspf7njB40u4aZt0TpNlLmm90eQq1E7ehDQMOxATL+max27EK1kMz58p7tU6z+03rMvNvGvMPr+2qY128JIolRxFNAPwTtii1MvK5txAcc8PJBHmnZuZc532B60/TyFmjCbEXSqcinAcz7BtCs2KcQ+Zf/CV5AFRIGV6n3Y/s4/c/0gfQbkMgyWRF4PGXvuw2lKSakn8A60qP0MGdTFu0tA
 jC811gj1
 Y+J59W6C0jQb2RwYrWXNvb3ONXFiNvl/d3zeNDlmBvIfG4vugxZbmYa1wkWVBWtX+kyPjMF+k2RKXDsoLb7Rm/A0E7oUchzPO1Bj2Q79G0+93R+wW5mXkozIzjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only the MEMCG variant of lock_list_lru() needs to check if there is a
race with cgroup deletion and list reparenting. Move the check to the
caller, so that the next patch can unify the lock_list_lru() variants.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index e873bc26a7ef..1a39ff490643 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -68,17 +68,12 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 	return &lru->node[nid].lru;
 }
 
-static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
+static inline void lock_list_lru(struct list_lru_one *l, bool irq)
 {
 	if (irq)
 		spin_lock_irq(&l->lock);
 	else
 		spin_lock(&l->lock);
-	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
-		unlock_list_lru(l, irq);
-		return false;
-	}
-	return true;
 }
 
 static inline struct list_lru_one *
@@ -90,9 +85,13 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 	rcu_read_lock();
 again:
 	l = list_lru_from_memcg_idx(lru, nid, memcg_kmem_id(memcg));
-	if (likely(l) && lock_list_lru(l, irq)) {
-		rcu_read_unlock();
-		return l;
+	if (likely(l)) {
+		lock_list_lru(l, irq);
+		if (likely(READ_ONCE(l->nr_items) != LONG_MIN)) {
+			rcu_read_unlock();
+			return l;
+		}
+		unlock_list_lru(l, irq);
 	}
 	/*
 	 * Caller may simply bail out if raced with reparenting or
-- 
2.53.0


