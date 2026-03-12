Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5743E106ACED
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B626D6B00A6; Thu, 12 Mar 2026 16:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37FE6B00A7; Thu, 12 Mar 2026 16:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9EF6B00A8; Thu, 12 Mar 2026 16:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA996B00A6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:53:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45CE61B7E48
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:34 +0000 (UTC)
X-FDA: 84538611948.27.C1431AC
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6F3FF4000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=bo90t1Eo;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aqbg0K2IsgJ/qrqREwPFlBusaMsCq6IazOmM3TBzhTA=;
	b=G9mJWAFUQLWykKqGRHeA53vOOZZs/s/YsuMSYGrd6yM8i+1S4VAv5ZlKKAjxXs1fpNZF+i
	v78wu6KgH3vjONqYuYsXpLEA1Y5UtzrqnDtsB7xHVFQCxb+AWxXbGnjVboOgLBh93+1EUz
	VcUyaPOr/6JFhwDdOxamGiuvU5XRvEM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=bo90t1Eo;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348812; a=rsa-sha256;
	cv=none;
	b=XfxY8wr/kF44Ip//EMWX7cCZ9V/sviRYWZN6rdzHCZNGavqeknaS9xfvWgi9SOoSJgvaME
	cx0f5wbP/Ri6ZfBrSzyy2MWwuzpFqoHPFRZhGjmUWyVORLYMjjLgUeKZBFMeJKBcpTrcnw
	M+FkfpF3YQ0lAFunEsHGYSBjR4qcB/E=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-89a465bd7edso11375366d6.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773348811; x=1773953611; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aqbg0K2IsgJ/qrqREwPFlBusaMsCq6IazOmM3TBzhTA=;
        b=bo90t1EoljYFUtC49qy03Aq6wt2qHzsccBA8K2IfmdbBkDqzjsJN03S8c9tC63K50i
         mffrSxYttKtHohJ74D23fbyLB6sAfl+JLycvFs8R7gWAHRbs4Ev7hHTsrAre5hbXf3PE
         Te0EeXdJFaUBORila3opH8lLMvl+uag5K6yapKKNoklGhbQUDG33KUyZsFGTziu4cuhz
         6Rpmvx0C4CZo20jz3CFEGrc3owyWVg+FiIgxHVEbW5Gas6sGo7RQL9EjryYILx9piZtx
         66m2bGp2Z3hj2AwceD3yzzFiyqxq9/5rvjc784hFTq3nf4XT4ZN6RVGj9IQKxTXUBdJY
         QxVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773348811; x=1773953611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Aqbg0K2IsgJ/qrqREwPFlBusaMsCq6IazOmM3TBzhTA=;
        b=MHbuh9kHD4lUbuVhYOTS+Z4BnM9Y/LNbGTsDuc2aosnuRbUZtDIUPWe46UAR76u0cg
         3GauPZhp3bqhAoxu+U1o3nnMxqxTb7ibInTeoFbovgO8PzerL7j/3jz4xUGVyXzAjctQ
         cMuEhL5FOpRW0v4bKJ6+Xx8MFISP+fD8nOqAocWtNs5/vak+IdymxwVDuF0P3axuUJul
         ybjpRgolKKrZ0fhGzh7Ju7pdigRX7Gu3yH/ZBdXcrPJDaz+aZyzP4Hx7q17e9Qm5Su7S
         ghVLT1q0WqBb6IiWssbBuRK7FNJ1Cb+iwToIsGRia9K4NmPxDyBXJhk5AMH9s4BNo0GX
         Ckaw==
X-Forwarded-Encrypted: i=1; AJvYcCVTGwidKjKjZ38k6wS1LNxP7eTcPFVkAuinfRnO+gSnVEKTVSC6+tDSjKwXUP6uWwvLaDh59zux8w==@kvack.org
X-Gm-Message-State: AOJu0YwikPDCTDIQAz+zsGml8NLdSK57pupRXTvP8mywPsX6U6rfyGn6
	ykcrrtigLes0KbLiRaAOjgOi2StJqkXPCKBUSgynwukrzifA600GQECFglujh7Z1wEE=
X-Gm-Gg: ATEYQzyWbCEDLeDZ92erESPHiegdJqjgO19GzivvbD0Kqcgg9m4fdeBW+tzG1ZoG1uq
	8YkzIUhgiSkldjgE4CRw0UbtYJLlR72kgtcy/nqpHw1NrENJXBkxv6YaK0RTowDm8fJ3nTgsxod
	jnwQm9OxJHPMI4vkF9TT5Aoor8xKI7Z7mOD+NQXKofGAcK578rQcU2P0KoGPzVWjqMKWEmDgbIm
	qAmzBxmOYrQcgUgSYM8+FY11z4ZUibr8N8D+JdXDItudyweJIjTba17+L4ZVT5RRYlNqynsyrNk
	pAGvkM0Qj0SB1BbqJHZC68IN5fcVtetBq5NQ6UfsJBDtc5jAokgfLkHsnISJgafnYFi73RJD3fF
	NDphRon1Lshi4gymNCdDJRh+3FiaO5eOCBaWn9RPP1IfdbTvJhVJcWjszxdCOaKx8uVqQ0StDFc
	X5Zmblj5mvuOr+jDZxU2C9Xg==
X-Received: by 2002:a05:6214:1c41:b0:896:fa50:4c0c with SMTP id 6a1803df08f44-89a81f5282emr14261866d6.53.1773348811497;
        Thu, 12 Mar 2026 13:53:31 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65c0d327sm42509556d6.22.2026.03.12.13.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 13:53:30 -0700 (PDT)
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
Subject: [PATCH v2 1/7] mm: list_lru: lock_list_lru_of_memcg() cannot return NULL if !skip_empty
Date: Thu, 12 Mar 2026 16:51:49 -0400
Message-ID: <20260312205321.638053-2-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312205321.638053-1-hannes@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F3FF4000B
X-Rspamd-Server: rspam08
X-Stat-Signature: 4mizp5cx8d9p1by7wa3cjrq8cq56um8j
X-HE-Tag: 1773348812-240300
X-HE-Meta: U2FsdGVkX18DvogDDXwfJ9O8c9xxcocpr1BKC1r3ZTi/xFuOfc539AWeUj9+AVx1vL0vSTB+6OGaGO2t/g10x3Jp2o9r2fVh88MI/CPyjkHKJUc0dSEaz8q/OEDzqI40rL6DrhJ2OoOMLUYL9+qRBQRdsMLKhdzK3BWgjy/FlIALXxJk1n9d+UbC6zofWpwmGzwjTuUZbDltzg+a8mF+ZR32f5UacZYThMWdigoorC0Orh9+h5gvgNPQr5lXpK+Lqa47A6SwLPrK4WX/e99Bm8i/ojMC350SwdbSMZStEw8ymGGIYIbfUMCaSVF5JGLSGEw1O6cSR80brzS7NuY6vGJqyvG8IJJASCEiyrJUqidSI7fc7r8KSgYepBcX3YrHHRJELJo3+S+9eUoVFflRnXtXS9RC2pVhKXZ8vPWBkWiGKbkSTNw52j/jV5M2jX3xwOiRuVsIutdll+JZFRKeaP7PYnW3p/mbz14JqiUGuMEJsvumQ50pQSu1Wl/rxRqZ2iIdXoXEbNVnAw57jR0l6Db/tQr3PkrjoLoSc7mJCAI4Klj/SPx2JTPAE4R8RTeTnVuaf7c0jFntBs0STZgf1eiw/mB8lmbvZfpoC+ARE7Sebjw8+ndfnTEuKG3XhqGdxyBum3j0+pY2eztFJ+GdNpQfFF6fGbcT32TwMfix2SmHWwo/Dm7Lai7M5vVSJXdWTEf8ATTxBpdntr7lORl432CKuTKxLivsV0fSGD8svNdNu1vlpSxbuXoabrdEGd6ZByHp/3nX2rEy0D734fkKJZIBs4PdBrOsm2lDQTLCQjQIdbkINCyk7fXv3H3oitc8LV6hnLztz65MKFu1MpDIC6xB/Le5dRT03OYyZtQ9XPsbjrvzXbMy0LuDm2dMM317P0L8qja8Sgb12rpx+aZiMQ1IdalkajHS8bkCiap6m/2hmKsZDmeGO4s3/CkTJim4iEOe+Izgxq2z5IAe41m
 cowTwIv+
 Uq7M4Hc0MK/tlG+OsSISd1F01T7RT542l9H5Q+2PJ+rPcj6Xa+xmqyouMyD7+yXlkMymzZ47pEmhUHCeyZDUv4ukLdlUeaTak/CVLs0h4y7wfQ5JSzqvjVZ9sH6vWMBS7WEEXzLE+/T20GN3ahwNeWD+8fXs3TsDB0c7xs6mc6DITdLUT50CAweM3gqMDJIxNmmcU3zHq57feN5AaofI8AX3VRYdi4RGvzXtf9MhGUAsDnqCIY7K8pVnL/HOTXWsr/nV020QJmnairW2x+Lehf4lVorIXyzkjXnzFxhPyIOpOBaZJzBApdBmyfKk8pJmfDXgCkjtKtsnV+1tQW7lyzNKIs7BS/Mh9COLpj0oMFVrZthHQx7E/Wp/lm8IF9om20MmLL4mNDVSbtDSe0eRWs8dl9tX6EcuhWiGVyvCCI2DendF/aTYRPbG+y/cuvG5GfFMte4BVI9kpARawdYrruHpf2FDMlmjCH8Gt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

skip_empty is only for the shrinker to abort and skip a list that's
empty or whose cgroup is being deleted.

For list additions and deletions, the cgroup hierarchy is walked
upwards until a valid list_lru head is found, or it will fall back to
the node list. Acquiring the lock won't fail. Remove the NULL checks
in those callers.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 26463ae29c64..d96fd50fc9af 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -165,8 +165,6 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 	struct list_lru_one *l;
 
 	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
-	if (!l)
-		return false;
 	if (list_empty(item)) {
 		list_add_tail(item, &l->list);
 		/* Set shrinker bit if the first element was added */
@@ -203,9 +201,8 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 {
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
+
 	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
-	if (!l)
-		return false;
 	if (!list_empty(item)) {
 		list_del_init(item);
 		l->nr_items--;
-- 
2.53.0


