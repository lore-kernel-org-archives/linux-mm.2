Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD91B1077613
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD086B0304; Wed, 18 Mar 2026 16:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B62D6B0306; Wed, 18 Mar 2026 16:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7606B0307; Wed, 18 Mar 2026 16:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 018066B0304
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:04:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B36355691B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:09 +0000 (UTC)
X-FDA: 84560260218.08.7E81F47
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC851C0013
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rzSUYtbG;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773864247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wkyoaYJiF0XNGZN3CfUoqSmkjjAgGEnloqZ+FNXRgI=;
	b=3z/Qa18rDJ9SqCQhwlz/iTEZVVifwEm/A/IBeIAYqIz6UbKTBwQqQH6B+ZPs4i3EsYDWxy
	mX9FwraT03hODiYxFx4kCbJcw2uWbJ70vdE7FJxQ40aflIvlXe2H7AYcvfU2qZCOyPLyFU
	8wJQv5Bbxu9oK3Nkj/t5y2UuBJcS214=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rzSUYtbG;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773864247; a=rsa-sha256;
	cv=none;
	b=l5UA8uJzcQXmz7FpwXvOsOnEcqx3W53qPpoXe6+G9B0rDQlSHdU2FvN/7/wBAohZAeFckQ
	zOr/gD7XKr+4NoAKQH/cVGnxuzwiqyYZQhLqFvjKIXrYPjPPlrRcq8b5x1pjhnpSGol1wW
	klIDwDuAPVpfMb4tAhyRnTmEcNYUF9c=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cd8347d9fdso43379985a.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773864247; x=1774469047; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2wkyoaYJiF0XNGZN3CfUoqSmkjjAgGEnloqZ+FNXRgI=;
        b=rzSUYtbGwbqvd3/xl0VAY6xGjEsg+ytDZFI8PdBOG6Tmp0QXssj3Vo79sRGezfHNV3
         cwSVUMisdY1OaXVfI0FlXi7Ddm89V52NMaS2Mg89HLgSljFxn5jnxqdTHqobzc1Lx/3U
         s3tzStzsh7nG0CtvmEzK1bkDYqWvXPpXT2omcY50XhvWlZ0MUMNI+AiLovV/E+JR48LB
         qbMMKv8raLZGk+v3AcrWcjCSRu1YsM7xa+cj6XZJwqZKgjwc8l7xwVtW4p4ANcVzIqYd
         KPGWL4w+niIP16BWdIeh0zuCQH+3jRX5s301xoSPNTdF/PqtAWMMmCaxZEKAvDwkmH8q
         rZXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773864247; x=1774469047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2wkyoaYJiF0XNGZN3CfUoqSmkjjAgGEnloqZ+FNXRgI=;
        b=Td4VY/uqgKMH6m3eLT3q6uwm/fGYortKCOVipL0Pl2j6Ed9MYXblJzxOrjohSJ5fZo
         bGqvAuN6e/2nC3T7TZxjcmG+gSOL5FnXOxpaTVcezmNuYUdIv8wB9N/F8RsgFuAuqDJ5
         80r1tHX1wWl6fPnGhLLEhIJmnaz806otMqCBhUD9298EdsqI9KMMZ4RU6cKCItZfO888
         INF6qdWSl/RwDY35IgzFeJ2FzOGZUURzChH9sCggf/sOcWek9EIm9/A+0WRVbAd9Z1Vg
         nr/leeLRlLkCt9OUvoOSbLBxl64thGqVN9GieWH/2o2C+IiM57Lrp0v2kDOAQGIQEe3N
         MIug==
X-Forwarded-Encrypted: i=1; AJvYcCXfEuccFUKny9ylGYCnzxUnUNl1kO9eCRmUlUluMMxO5Trx8dSSJd9//yjFLb5kQ+XyFC9txOydLw==@kvack.org
X-Gm-Message-State: AOJu0Yw4Fyf70uFYJAvdvAxpKz6OiTiqTKGSq26y/yqM6RQ8O8p/+YBC
	HUVnh+xyaWYszK4CZpkETi58WkWfWZAK3gXFZ18s4o3aTb1KrVSrrqtPYuyLJ/dbjTs=
X-Gm-Gg: ATEYQzyDAbVpUWfXqS8WewDP7J03UC/is+yJvcD7r2J/Vlol4/9OhiVDpBTw757+/qe
	PE5x4AV3O0rlQ4Jol2FvyRMfVCXDB3GcsXRpCUEOA+5yXEO6xLCZKuG3PwyCF8rIX5gQVR1V8sn
	6rdkL5UU9ZDtyojutguz1CO8u2HhsgEqVxzqBxXILRdSoWBIXW17kf78LbDiZVDOapYJihZUCkF
	jGstno/YiZ8+cbRN6d9PV7j7yKoqXc/tWDk2VjsMIjxTkH7NbPxVRRBw1DbX0lcY+m2dtRvjrdm
	L0QBn5iULlKEzv2B3adQipdgQUYSkfYSjvLq93X/c1fqYJqNTXR+cu6GWAh7P7Y04tX42uUhfZh
	KJRF087zetXOCi7IPxQCOkPEd46VQwQgx4Uljt2Q05cZtpDTuAO4E4MBWJ+GAOa8+tQPIP78Nyy
	7xoHGbbjaYv6rzSsVGAFUygA==
X-Received: by 2002:a05:622a:150:b0:509:3098:819a with SMTP id d75a77b69052e-50b1486333dmr64714801cf.44.1773864245907;
        Wed, 18 Mar 2026 13:04:05 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b134ad438sm28515831cf.10.2026.03.18.13.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 13:04:04 -0700 (PDT)
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
Subject: [PATCH v3 3/7] mm: list_lru: move list dead check to lock_list_lru_of_memcg()
Date: Wed, 18 Mar 2026 15:53:21 -0400
Message-ID: <20260318200352.1039011-4-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318200352.1039011-1-hannes@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC851C0013
X-Rspamd-Server: rspam07
X-Stat-Signature: omhr9j7mr3ttjqy5qenrncj8gquuzp39
X-Rspam-User: 
X-HE-Tag: 1773864247-748274
X-HE-Meta: U2FsdGVkX1+JdNdOwHHp4yhqyDl4a6TpHVO/hp+pIEbIID0gWbBfpByS7iW+oFne3mK0lE0aytwLzOzn2Zu7LFOnBAOKkf0KNnDdDWmgWI2u9zaGqfcZ+I336Uhpaz8SStZzO9AcxW/Og2ruTtEjercmBYdHvoDOVP5Wbn5uJoqE2jv29mtd43kvl78DxbNY7iUmT2vbGEpOhn01rczU7PZFvtiYNGgqYJ5YFgngnjAiMmc++Pox9Ccdsup4lAcvw+gPlQ/dANNi6C6HLFBQ0LG+KrGIxhOSjmluQAIcubXdKSOdwLt2jsE884hSM72RolQQnNJ1sPCHaIZH4FYdk/lQF15f/f8cUZ4GscDDSaqyXPn6M0DFTDW1bY21dLuxVJZKag07gMO3+9afr6X+LI0snoWRCyBy4soKISmfpLguRszgxXmJwyHqO/sTAP/E9LPwDHejXA20xyLcvFc7j/G8E/a5nDLzz7Gc1PEuEeUX1ioIZxYD++v+M8zOPACc4bNw9q+ixhZFAHhvxTlSoCkVdXXrQD3hKUpyMrFtK6yq/Ay/ddsvJpbL72BiDUm6N2GwrRV2c12sqvC6Z0z2MdnxoDfHn5wVrl4gDK7q5wszLSokAC/cMmIXtK4+YoQDxjJJy8tLz1p6kqnFowEGkXanYxYQ36UAxJbxzfLeLbhm6glIOI5RvuKsWw084BxyQSdZ6eYytdJUTv6BUGRm+d7Vv9HpiRmcZR01xifnuRW3qx0iCWcbyjt6du4tyF4rUEdHsALsfqMs0Xro5qtr8JT3p+ixqnlNevXvpT94BI9+mEZeyUsUr+CvahmP7j6S4XL1h0ccEYrfwc+hhO8Oy05CxLh9aio+8zVYS1MkvffK65bSk63SspeOnpkdLIPW1aNyeBs0DmPKFUIR1+0VcIM5DP/mrLkdTEwFY7ZAAySYNchghnVFJUrnkqNumZVowigChUflVcvmcAX8bTC
 ikAcMXPM
 zbkBfvJDEBM6T3z5ejIo0Lp+teUFLqtU9Sf9ztGbFG2v8KGdoCY0YPhF+oUnMqviX5wr5xIBhHWLc9EK7dZQmPkKv1e0y7sw6D95NumMUtpje6vTFhI4TmbVKY0SWCi6sntsE/gQE649sg7+rAvg9P5gF6qJgOUkKMtpqzJSQ1Qr3pSR62Gmlfu6NeRU+12uOcTELSNyflgtgSS59oZXLVr/BNC7MonlIg5jf9LOZJZCpQ3rT3Mdep4yYJseXPaJpx0x9ETfM1tuhg+fCMTkGhtWfeh189S3QH918a9ZPf5LShqxnwrz1yTfQgS206q4CbDjBpDRPp8/z7a7/7Z1Txxnc3wPhmhZ/L61P6oZgOIIfZVRKivi1Fc8TWkugwOxQLICFwDIUtXvphsrem1qFt00XrBtGKCwFEFiZdgdnlmTMemkCvJcQtZzY/Qr4I/zh+RNJC341zTQO2AA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only the MEMCG variant of lock_list_lru() needs to check if there is a
race with cgroup deletion and list reparenting. Move the check to the
caller, so that the next patch can unify the lock_list_lru() variants.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
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


