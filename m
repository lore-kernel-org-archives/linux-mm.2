Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5988DCD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A580C6B00B8; Thu, 21 May 2026 11:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1A36B00BC; Thu, 21 May 2026 11:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4CF6B00B8; Thu, 21 May 2026 11:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78CF66B00B8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:03:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D77E1C1AAB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:47 +0000 (UTC)
X-FDA: 84791746494.26.39CF9EE
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 65A86A000F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:03:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=DyYYtZYp;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.167.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779375825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1cbAO2KW+lIj5NuloFoDpyrLcHnbVUzz5CiT+zyYy0s=;
	b=N8KMB3RyqIql6SiHucnAd3LwZ1E6bnY4O5LSV+VzRtSeqUN9ctpL7quDrWpZqCiBjPLSYK
	6E+VGqzaYRoXF5qYkg6LzVZO1LhsciUR+99I/jD2SA9ATPXlScvsMe7j9KfXowTq7nUFaq
	fFBikmwE8Ejh1e+PZZRp/+wRSQf3BcA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=DyYYtZYp;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.167.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779375825; a=rsa-sha256;
	cv=none;
	b=HCXgQo81iAnCe6/YXPUzZn5h4GVCx9BHADOKoqzcTWgniTi56ETMorHlc55L2GxrI58fD4
	JFbXYBELMiqcASINs4ZQQV0qZV6/+hpTcR1x5ntxIZ6h1tGO4NHafc45wvWtb+VfOfaNVr
	f2ub260Y6AVwe6nL3YUDtHcsqyRv14c=
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-485433a6889so128932b6e.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 08:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779375824; x=1779980624; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1cbAO2KW+lIj5NuloFoDpyrLcHnbVUzz5CiT+zyYy0s=;
        b=DyYYtZYpYMt2fDoryvewz6CsYN72pyxiKRWjk47BfAlnCXCrq16vZ/Ne+w/mdZDsch
         MIRPJF3JLCAyboQqxHaI9CELJ04IVif7H0AkYyam6StDUNeUbPJjXIfvM5iZr8EyxCsW
         xc6sikNtr/FjPlloHetNRScJFrlIra3khZmpneBO0kxS0foXFnLSNAuy7jiiC7HIrRC4
         3/zeaI6IHtU+zlTVmPDhNmDc9WmMAhrNFByJFAmmiuJ5Bbeh6Bq7bB6MGYc+9Sp6zl3g
         pJ7g5XD8ZqUEXWnVzDChjCg3rDha99PB3nNxnRybH4ZnpY12t4taGbaY4uPee9DdRwIq
         NIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779375824; x=1779980624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1cbAO2KW+lIj5NuloFoDpyrLcHnbVUzz5CiT+zyYy0s=;
        b=lXbtmEEfDDT807ntBAUsJcAjerM53f5Yp3CSTbuqVlDZq91kBh4qzF6mX9itzHq//w
         QJfmZ6X5yxPoOCM7AAS3tgRidNp048z9O6CQCmfIslhA/9zPbLYk6mlfl+2oTXLwzCm1
         xZsR8quZHa6nyS/ungLcehS5bsROhXIjEu24mYF+0uw5C6P7WcKZ/fT6zYtOr8sZHBs6
         OujMFe1AQXORLL4pmOx/WCPvTi94NwDklZAh30o8bLUR7BPxMYKzZNBhUVudKJCqZJIg
         wLWKkrtb8cGLazmZpFLNkJHMffHy2b54cCrm/hvkyyuQKcwiheSN16sIdKpR9WugqqCR
         aeXg==
X-Forwarded-Encrypted: i=1; AFNElJ+FML0Ye4aE8FPi/e49UFaQ78FkCgZTfsaprtbuh/hrw6TEnOt+io+CFmWuXdWBGbV+JO18CPO+9Q==@kvack.org
X-Gm-Message-State: AOJu0YwpXPYhCXA3DOx95DNbn51tU/dFqvbhAJvbF0ffEzWDvMxaExa2
	R6ZUKgSE84RGqi6rcWskxIqKnTEQaL4v82iCB55NTYCd4Fmh4s0RRR1z4ktapl4PoUk=
X-Gm-Gg: Acq92OGoM0h9CPtuzJCFHg/joI3SdBoTWrnEllsQ0eSkz4YZStrHPQ3GerRAbb5Kit7
	eAqk/W4jdzejp7HERuhBise+iFsBFjYvEDdPaM4PL/++a6+oKhfDdNwwd6MM7prx08ur+yVDGTo
	8q6OOC3vu3j9DHA0HfzIcHtVXiareXisyxnZe/jFlYy+a6du3Z710Fne9udS1XdHpIuAVgQ4D0K
	pKrfZuleedOSmNNUdn1Bo5Uxk3J1T7EqMult5ldyPQSlOsF2wdKpSC43sOZcUZtro16tl6ayAXv
	yKWRkrAtqDgQgpQ3rgOAgT6fCTCWJSFAKlNdAoIuPeU+VXPMhsBIVkqKfSy5gZzrKMDHOuYy1Me
	I6HEdMbBprRIGWYAIYiLeyh1Hd3rk2r6iJYGOt/tcZXA+CWfO+DwZu0C2C6r/4SYg+S0ygh2FW+
	KObckJjVDFyOhdkq7pZEcEkw==
X-Received: by 2002:a05:6808:2221:b0:467:1941:1f0d with SMTP id 5614622812f47-4852eb590aemr1685571b6e.11.1779375823781;
        Thu, 21 May 2026 08:03:43 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516cce102f7sm8647231cf.22.2026.05.21.08.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 08:03:42 -0700 (PDT)
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
Subject: [PATCH v4 1/8] mm: list_lru: lock_list_lru_of_memcg() cannot return NULL if !skip_empty
Date: Thu, 21 May 2026 11:02:07 -0400
Message-ID: <20260521150330.1955924-2-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260521150330.1955924-1-hannes@cmpxchg.org>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jg31drk99t37h3cuauxpwttsfm3dg5cx
X-Rspamd-Queue-Id: 65A86A000F
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779375825-216556
X-HE-Meta: U2FsdGVkX18jad4ptIAbM3Jjj2FSu/JqAsk4nWRbUJDCFyrm4UQUa3bxxKL1WNhZ7d9a0ckwNRFYQRoCl9n7yTaOHjg7K2jAisXjn4nxi5Xltn0xQFrCxN6FVM0/ArRF27GizG/6lOJiSlViaznMWXiX+eOnGkJp3Xs8kc85SiF//iQWreEo6gWWxI3uwbyP5PvC8vgGciIMZ6Dgb0ACLstaR/z5AXtQd0hJNTkX5Xv03AHM08kq+F548iBtLGkeiLQ4LNj4hvhUQCA3ICJXyrdP84B71obj5a5j7yWU/y1oo0GckCLJbkF+gOFPpjwCQsGCkPLjYuvDvwQZ7Eupm/dbpHOL3qHH/OUh8zLhp1FgsPWc9U9Vgko9je8Jc8TYHk9AZPl3TCQqcx3fHxrEVbQemmlhXzw3UxsQt6Q0buiSd9HpR83TgV0Cs6s3ub2yHUu//ARJY7ikiblfipTrMTakQgvokPtxREknGRDKOcbYKg00QtWk7llHIlfy0IEgVdiEIehhKbXKSz/d628iC6XfpyC1SVwQQoI9T9WEzaKOx/kQ0DJS4m1kx+Z9yKE159ehw3ekhsIP0RjBz60D1cCGuVTfcHhUhdmdWbuyTYUSEU90pqGFtNtcucGk8mCyJeJmiL08TYuY784Ib56Rij7Ta/34Qp8ziPDyurwGTfewqpahyNrO0XTr3/E4u6zU0OHU+ra+ESGzy7EJxGoAwxWFavYFt18SX6H2I+FXiI1GqWljJGslds1SzauNOoAKlpzi2NDa7NueajH9riOt3hAfq5JvfIfGIUq+adKt4tJzWEasligXetlarx/SAdnZj9X43uao/NZWgkWYQexK23sM865sdSnKKutq70bzqq6Ed/d61x22QBdypJbvaDPSf+aPRY9cU2EWd3TuMA4G5MXDaJChzC2hz7SSZ/6M0W6wX+zfszpe7ynBT2YiMFsZl7oD/cPvatKD6YS9BJJ
 42WkLaN7
 XfhM8NPiU3uugSaPYKUTTrziTNJufBXAMIXrJaYz5dGUFBpTwFhY3axxXzShntsSb8KaHa5sw+bEN2ANKmqOGWc8e7PeL0CafVd8tML8qloo6YSDSAmoAyQC30L/LzoCk/b56wXLCiJ09Uf0r83y8Aen6MiI5Q86AnjWth/6slyOf6ndcUAALaabs25r1ljRSN/LGDHVi9mdtY34RNI3IledAzSNPMfmfS+BZCIJS+xY5zIdTWDqBkGxGWRC5+Z5/BLbEcy5Q7dbg+rMgKvH9uNK/mwu8cJUhvg7sGsGr7gVdK8MhBfBrz1L74VXdgFf3q0mdU3hdyBs4N7JEO82VuJZYzxWtXfok+o0pu6uin3KuR5Qwetox9IgLF/mjVCayUz9ZFBjvnAu9YV+jL4w/3xnf8xFgsTuG+MplmlzoXLYASJw1/Wer27IdlRwkovhZ4FJmwxiem3sZ2DDLIahd/Y1VdVaQp8B5QC2BbScvtxbeJavkc3+Gry+FqWqYhYX+fnsbWEfh++td/+7IKpLtVoVm7IL2qZ2csnw8+drl7YAJXjoLR13g2fjQLqMExNzIjfGfVAWFcoDzQwg=
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

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index dd29bcf8eb5f..d3619961a7ac 100644
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
@@ -204,9 +202,8 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
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
2.54.0


