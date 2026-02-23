Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0AA9EC1102
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 353BE6B008A; Mon, 23 Feb 2026 11:01:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3311A6B0095; Mon, 23 Feb 2026 11:01:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240366B0096; Mon, 23 Feb 2026 11:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 111CA6B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:01:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B78381B51D6
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:01:54 +0000 (UTC)
X-FDA: 84476187348.07.185A4A2
Received: from mail-qk1-f195.google.com (mail-qk1-f195.google.com [209.85.222.195])
	by imf30.hostedemail.com (Postfix) with ESMTP id 14AC380020
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:01:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GCyJWVHB;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.195 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771862513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LteDtGYRVDzNtl6BMvU4eGCDLJeRdYaj9DQgkFpHKvk=;
	b=l9Pb2y37lSFaMEOKkruFYwXnPPLoMZ+P2bkI+E2m1CaW3aAmzrPT01Bk4RRjHj30V6ftWj
	1+Omd2D5S1wZ6PMStkqdx/BtYZ1qVPrqzuw1iZCY2mo40jH6Z/Eo289dE0Oup45mopPEt0
	YpRjziZweB3Nq7zgf+amSTEccTRMEj8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GCyJWVHB;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.195 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771862513; a=rsa-sha256;
	cv=none;
	b=yD7vLjpaMMA/LhAQsrTFUGwTV+nvyLd1SDZvBPE/fTgTHhzALFv9BWJdJRoCL+qYL8Cupv
	t+F+d5W04ZoxyWh3a+72jXUTqrZHnlXvRWbtv5I8JrBMJKqHPCC9foIJKo+9NqC4AE7AO2
	t6gqHl5I7hMzvCkOqhfONqX/YdGlpiM=
Received: by mail-qk1-f195.google.com with SMTP id af79cd13be357-8c710439535so319982485a.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771862512; x=1772467312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LteDtGYRVDzNtl6BMvU4eGCDLJeRdYaj9DQgkFpHKvk=;
        b=GCyJWVHBcfXIAG7cPQu+WCg3Esga1HlOmuq4eQtzIXZi+j4ftf6Zvr2TOVlyketSVJ
         U3JcFHIC6UTVsQLuQZxsXrk92K7zn7Jo1NHq04fY4RjsXLvy58KK0XDZKvfK6Wc/Wy+0
         gFvXNoxR861vlngJijX8GVck+PsTuqQXrxEj0mQkY29SDp65mZFbL/T37cGywmmL3qDy
         LsIofu1sk8ydrvBiIALswYo5KtY3/4RPRqdVvRiJVvCfxQSg08UCSAS90igINfK5j2UP
         DXCcAKCZa/xgrL/dNzxaGt/X1fMXjn7eZvEqCKkH1RRNtS5lDFRayYTP6g4wSsesZIzQ
         3RqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771862512; x=1772467312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LteDtGYRVDzNtl6BMvU4eGCDLJeRdYaj9DQgkFpHKvk=;
        b=ieTRNt57sqXGkMIF2vTUpCe1cBmcG/H/3fTfIxJNjwr1KjCqzK6BTIFXCC4Co9AAsw
         I1vCXTfgTcMm7UfksPUJwU4jicrfsgykWza/j46e2UTURm+L5wweIMK9ejGyJn7tUudO
         xH9hX8Q9oY36muKvaYJ4gn9haDpDac3RkxWcQxokbzH0Es4TItv4uL7V2XtEXUWvYCYK
         l5x7/i052RXCUGgx/wOJQoSqH61x+SiwEYZSbBrYsmcgC2fW1hlBFWUJkNGHBly/ZGqo
         cNT3ASXsxCjJFexMW+5A0xA8VrBGwO9ciF+ySgQhzL4M02DAEMzg7f2ndFrZrRy1WMP5
         JNLA==
X-Forwarded-Encrypted: i=1; AJvYcCXYRmELMxBkrIxqvQAOj1Luoz9kBWsPeYPe+v3IL4XW+ixXMYsgTUA18qFQLmLxZp/B5kfNjl/g+w==@kvack.org
X-Gm-Message-State: AOJu0Yw+4j2BJxlmJr495/DzX3CxSqi42iTSDBKK/eJ6rrGA62xCbacY
	khTT5LTPvnQIX1FACtMZ/vZOXI4f//zi6aXMcTqah7jh8x0Ozt7q2H2XdU8cHxa+G9M=
X-Gm-Gg: AZuq6aI26GFb2e9xAk49AwCBU/SyYhestwhZWfdn/IzZKNA+6PjjiYfcF57YXr7LO7a
	UTAi0XIALBnQuGoXgT4ucztaw47A14bcdcH6TYFl/geawm6zHWukLBdhYG27wks4ad9k1zMglTP
	2eRB4Bm7apNv059IPrMbRhYESEBZad/R98/2Q9Ev2nG0CtKZ2snTP416nGwSPLmL6BdsbIKD+X2
	lp2ySdfbXS3Rp9AOr4gyCeZ4LC7lS8CWZ/w0CpVq9wRsYHYFThmWZ6JSOLojoItVah1fZwVhfNI
	NSxgLXFiJ2XiZ1yv8ayHTvrt0+6aeItsw/X8i1/dQyVoxVlXHKtuOTCwx9jG1/UhIbmNTuCZZLa
	yvLiuXvfVzxhkJfLAF2YYnQSYagRJBZCVkzeceanMa4lMfGV2ZbKPWXBRzj96d7/oufKIDtFp4A
	EDRcqReVo3TJmufp86P+UrUw==
X-Received: by 2002:a05:620a:1714:b0:89b:9b75:f5f1 with SMTP id af79cd13be357-8cb8ca65b1dmr1104819285a.53.1771862510373;
        Mon, 23 Feb 2026 08:01:50 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb8d0614fbsm842409585a.17.2026.02.23.08.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 08:01:49 -0800 (PST)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm: memcontrol: switch to native NR_VMALLOC vmstat counter
Date: Mon, 23 Feb 2026 11:01:07 -0500
Message-ID: <20260223160147.3792777-2-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260223160147.3792777-1-hannes@cmpxchg.org>
References: <20260223160147.3792777-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 14AC380020
X-Stat-Signature: 8wqc5zhop9iy88hsk55heqro13q1xacg
X-HE-Tag: 1771862512-29188
X-HE-Meta: U2FsdGVkX1/UG1zQ5U6zKByQwklZTOVPn/HU403N66COO+W9t2Nx2/pUVCOYJrPhyBaY1pCmFX78DPTK0lFl9oF5ZnFGBsBJWd36HM2Npe6VsuUjYmV4Xc0mRuHdNQ0hVZ2Rg8LaMa8UkyoYyXJcBxGEOWd085MJe6v0JKGVDetPaCD5tXae0L9RHbU44u9KmPcaOzLFdnwO7IZh295mr8XDghcVc63b3qWCtBuRWm9CRQgNbIknOUPzN4+FM6vs4h9LLDhYO7RIhwolwR+duD+RFwHwOsX+WvVaWUGMrEy4HPlL+HmOzylj+Jg3wO9VcnZJbq1QM4cAGxaeclySdlwRAGEmqOxcv7LTPhQDeSTuOl6iLQRN9wgmv7o5N/flTmLhI8H5q2SMdwYKoDkr+VAgtZAiOiBL59oPLcmqOmh3DDL+rsuThhW8hStAWJKu9g1Fc2qwXSVj4gkvJqVT3elxXPFy27pP/PxeaLUg2LjkUW1WXowBw/mlYU5KnrqXi4n/NtRrnKJ+YC5VhMQ1Yg0xbHcN6KREHYJXP/0vOVBEf74aH/YTrIVFfBeE6S5Zti0vfeqYdcIsxWhJd8Px/cUeaPi4tBAOJgC2mwCIWO1/ggSqlrTSLmpM8Xo1PJmx8C+eVTZkd5LAABmr5sO5lWG4u7FNz43/XRkv4nvhrp3Bi3vtkYXPFdnxnjFem6t+Dn/SONBz8sT5iuQWdJjAFRmQae12kL0UHIjDs+py1r7Pa/WY2yNuG2bJKH8rb4ktfM3pjMBlttO7JbrYCUwfqQXwKM6Zp3jpfRIYIb6cUwkU53wgdd3QBuPWdGYVLk3HJv/GM+UYdduMe7JJ2IXDD3kGerQS3khZvI//M+QKhR77CnXvyXi1SM1A3PAT65otqi87MyZW5qbRW0OocVWd1FfhG2Vt+M2xOAUvY5Pjn4i3htd9iRMo+q4tXTl7UV+iARcmVXsfpTgZHLwAUoI
 r578XwDA
 pgs/9EbWEigFq/4n5vMxdZPVxcGAjd7d9zWdlrHNRyj3vpvH5r03ZdfvJvsgBqQQHyhaTiUvlTCCfaiqeddmleVcgwcNZWPBJjtRScE0F9F9z40/jbqCA8fZndl0QdVbqV+E6ADC3fuFY5eo1oDKnRqt53tikBNgJGGceCB2Jt5mmZS/cM89Nk0h75fYu5qAXsovQ0ff9DWGqIaBEOh0nieQ8K5Q8l3+QhPPyYj8ip1nicx3rNzkXx/VIrLXdlZEAK0x2hWD+1c/sYkpr7ErXN/zvyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Eliminates the custom memcg counter and results in a single,
consolidated accounting call in vmalloc code.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h |  1 -
 mm/memcontrol.c            |  4 ++--
 mm/vmalloc.c               | 16 ++++------------
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 67f154de10bc..c7cc4e50e59a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -35,7 +35,6 @@ enum memcg_stat_item {
 	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
-	MEMCG_VMALLOC,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 129eed3ff5bb..fef5bdd887e0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -317,6 +317,7 @@ static const unsigned int memcg_node_stat_items[] = {
 	NR_SHMEM_THPS,
 	NR_FILE_THPS,
 	NR_ANON_THPS,
+	NR_VMALLOC,
 	NR_KERNEL_STACK_KB,
 	NR_PAGETABLE,
 	NR_SECONDARY_PAGETABLE,
@@ -339,7 +340,6 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_SWAP,
 	MEMCG_SOCK,
 	MEMCG_PERCPU_B,
-	MEMCG_VMALLOC,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
@@ -1359,7 +1359,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
 	{ "percpu",			MEMCG_PERCPU_B			},
 	{ "sock",			MEMCG_SOCK			},
-	{ "vmalloc",			MEMCG_VMALLOC			},
+	{ "vmalloc",			NR_VMALLOC			},
 	{ "shmem",			NR_SHMEM			},
 #ifdef CONFIG_ZSWAP
 	{ "zswap",			MEMCG_ZSWAP_B			},
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a5fc7795aafd..8773bc0c4734 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3446,9 +3446,6 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
-	/* All pages of vm should be charged to same memcg, so use first one. */
-	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
-		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
 	for (i = 0; i < vm->nr_pages; i++) {
 		struct page *page = vm->pages[i];
 
@@ -3458,7 +3455,7 @@ void vfree(const void *addr)
 		 * can be freed as an array of order-0 allocations
 		 */
 		if (!(vm->flags & VM_MAP_PUT_PAGES))
-			dec_node_page_state(page, NR_VMALLOC);
+			mod_lruvec_page_state(page, NR_VMALLOC, -1);
 		__free_page(page);
 		cond_resched();
 	}
@@ -3649,7 +3646,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			continue;
 		}
 
-		mod_node_page_state(page_pgdat(page), NR_VMALLOC, 1 << large_order);
+		mod_lruvec_page_state(page, NR_VMALLOC, 1 << large_order);
 
 		split_page(page, large_order);
 		for (i = 0; i < (1U << large_order); i++)
@@ -3696,7 +3693,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 							pages + nr_allocated);
 
 			for (i = nr_allocated; i < nr_allocated + nr; i++)
-				inc_node_page_state(pages[i], NR_VMALLOC);
+				mod_lruvec_page_state(pages[i], NR_VMALLOC, 1);
 
 			nr_allocated += nr;
 
@@ -3722,7 +3719,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		if (unlikely(!page))
 			break;
 
-		mod_node_page_state(page_pgdat(page), NR_VMALLOC, 1 << order);
+		mod_lruvec_page_state(page, NR_VMALLOC, 1 << order);
 
 		/*
 		 * High-order allocations must be able to be treated as
@@ -3866,11 +3863,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 			vmalloc_gfp_adjust(gfp_mask, page_order), node,
 			page_order, nr_small_pages, area->pages);
 
-	/* All pages of vm should be charged to same memcg, so use first one. */
-	if (gfp_mask & __GFP_ACCOUNT && area->nr_pages)
-		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
-				     area->nr_pages);
-
 	/*
 	 * If not enough pages were obtained to accomplish an
 	 * allocation request, free them via vfree() if any.
-- 
2.53.0


