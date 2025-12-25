Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35106E7AD4B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 23:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984CD6B0088; Thu, 25 Dec 2025 18:23:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943CC6B009E; Thu, 25 Dec 2025 18:23:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884D56B00A0; Thu, 25 Dec 2025 18:23:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 768226B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 18:23:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EA2A13BE97
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:23:22 +0000 (UTC)
X-FDA: 84259571844.18.025449E
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 74BE540002
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:23:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wK8SnNRU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766705000; a=rsa-sha256;
	cv=none;
	b=acaxKhOZlOHz2vKIig6h4csEMQryFheXSAj51MR8wBAwPfTUTfobHoPyoaz8Ics4ZNDG5h
	jdJ4gnGUoVwAMUwO5w4bjvViYvK5biWcFZpjyCpmfc1thgCbMft9MHEMz51Cr+VDHP9WzF
	8NxRs0lKAVjftwqw/y9JWwDBwfysQMQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wK8SnNRU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766705000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpBdbnOOzwb8ZbK7UEBGlSGeYSG5qka67j2LUFyR/ao=;
	b=VofpCEcXmG/diuEUETq8cTRdb5h1DEGjkfXy3PgmnE6M0SJnDQ59yrGUKVm5N3KnnUl1AM
	MQuMjAYLcj7xRGG6zJl3efij6RTurJobZKnaO7BtxaSPrXOeeLYplkgkr+yCKNbPguXe7S
	9dXGHyoP2TY6i4nbOmmI8KUbIWotjcw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766704999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UpBdbnOOzwb8ZbK7UEBGlSGeYSG5qka67j2LUFyR/ao=;
	b=wK8SnNRUM+obbgwNDLw8wPAU74br+bFne6Qn2KeZ5l2hSZ+3DWjbscYBBjXr68/7gdx1g2
	unc7D8bhz2pfNQaWQvFJ7/qahdnoD2wTfLWKgEiDURM3DvaSCnfvYNIhy2nJsNIFflmQ9g
	No/uUKzufd7eR+DI/Mz5Yv9RbchG2jc=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] memcg: remove unused mem_cgroup_id() and mem_cgroup_from_id()
Date: Thu, 25 Dec 2025 15:21:15 -0800
Message-ID: <20251225232116.294540-8-shakeel.butt@linux.dev>
In-Reply-To: <20251225232116.294540-1-shakeel.butt@linux.dev>
References: <20251225232116.294540-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 74BE540002
X-Stat-Signature: noun8tfokmmc1q5ei5j88i1marhrpon4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766705000-470501
X-HE-Meta: U2FsdGVkX1+WYhpIv1kAloShWcj6y6YvPhv+5EQCDKtXSdrWexGbqy4QDbH4T1Sd4Y4swVW3YtlpUQVVGaKF1nJmlZVB8n44YteQFO09yidryHhFOtD9WNpkIegRufUKUjGJWBF9vlUPaI2tRkPyGm836+vWOiPU1wTygwlMDT55BxjU9czNxZS520ETy5cqo6mpLqyW5WE//Q6CowE/i2kWZX3e3bieMYncgNLoYb63ayZT1zH4FudFZhrqLWxTUquKmHUsoZOFee+K3aQDfnmi3Gno4CARb3MmYA1HeVtCMRwkSlwrfqDLztwkiBG+ioZZAb38pR1tOWxnonpM+3C9K0kutdxBT4KFVA28jPCedNa+rSKJqDE0icKM4DQ82tihzUPDl8eIXTk6UHJkdSzO2nXsKEbDDfohJme5tjTNPx/9b9yhKUSkRlVmfClogPx5aSrBhzep2w9wFyBA+Qsn33g69U9+1BPiDyafM/01b/1gx9RJjm8GaA3lc/vdePYXbccl44Vnw8yKProaR5omQC76t2zD15gxdzaEGzwbUTNeHlwan8da58/rT+a0/LK6fPBbDZ9cWEdlJnikZtm/1rX//I/iDWKQR9sYBlqtMQMi9W6Pq37+6ME1fUnDtwRQQs3cmeJYPNPCLmipQ8m8wJ1GaSNooyfcpD4BrNKAeCphD/nzOOyR86+fDjLNfGxy+k5XQlOmuJsJkdRW4ow9qH/HP8nmiHiR/I0l8BQ+/aLPvRpDjrIpTd0qBydM851WvYRJchag5QhSHVDnYcd3j5n6ESIv971fbKG9mbue94tTpzPeE7ZDuEuBWlTyDRXHRG7KLPIXD9UNodveaaF2SDpweSnJCkpqnKbLCTEFhIyImncOMacSumrFEknmzq9k7rKHzoQ/kwBG+L6nl/PT4vmxB+JZO6CR5gsV4hICgpYsqgcOhFfUx3xhGP/h4lXMnnKGDyyROBsKCuK
 95KsBFtl
 C1RTKdIGHDwx5YzJQoqPFNb6R6MXhO9HQ8T5bqysldexmkJBsW79PhyfGoZgkj/UVavBluld0dbsp+aEo86Qh6y0itj8AqlkCtGMaWJ2Hfq0znfRsJmg0QWWRWxn9TBl9KeioxCY/ydKBqafjR67WQvXdaEiNJAXKgjxPWrk3iDqzP4vEoLLg7GDKgSMGiosdcbeS5tkBx00cq5mGUgSyEDxIZOOidt5YThrzM69thx/yYtAGaXmJe7mbQRX81f4w1jyncs24o5+FPL4Arsr7xXZxpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all callers have been converted to use either:
 - The private ID APIs (mem_cgroup_private_id/mem_cgroup_from_private_id)
   for internal kernel objects that outlive their cgroup
 - The public cgroup ID APIs (mem_cgroup_ino/mem_cgroup_get_from_ino)
   for external interfaces

Remove the unused wrapper functions mem_cgroup_id() and
mem_cgroup_from_id() along with their !CONFIG_MEMCG stubs.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 18 ------------------
 mm/memcontrol.c            |  5 -----
 2 files changed, 23 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c823150ec288..3e7d69020b39 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -830,12 +830,6 @@ static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
-static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
-{
-	return mem_cgroup_private_id(memcg);
-}
-struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
-
 static inline u64 mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
@@ -1282,18 +1276,6 @@ static inline void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 {
 }
 
-static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
-{
-	return 0;
-}
-
-static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
-{
-	WARN_ON_ONCE(id);
-	/* XXX: This should always return root_mem_cgroup */
-	return NULL;
-}
-
 static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 {
 	return 0;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ff2f9bd820c..ede39dde05df 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3615,11 +3615,6 @@ struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 	return xa_load(&mem_cgroup_private_ids, id);
 }
 
-struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
-{
-	return mem_cgroup_from_private_id(id);
-}
-
 struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
 {
 	struct cgroup *cgrp;
-- 
2.47.3


