Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B05FFC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AACA6B0099; Mon, 31 Aug 2026 12:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8344F6B009B; Mon, 31 Aug 2026 12:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D48F6B009D; Mon, 31 Aug 2026 12:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 387186B0099
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:38:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7447A01C9
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:38:03 +0000 (UTC)
X-FDA: 85162121646.01.96FC18F
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id D070F4000D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:38:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NXqhm50M;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788194281;
	b=MBRmzt9zY2TZP3KwP+Rz07NdMmUutFqfaVxrwJMIm6DJUnt3VNquBDdS0OzBaA42Bt0hiK
	WOxg2vY0Qxc2IUZnx6/B5gqsSE4aTZyDr5PNXACiB57m+dLc52Qv/GHEkvaTWSi9BMRWpI
	JZGcG52BXlgo2/Udtn7InA+CfcRwies=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NXqhm50M;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788194281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQZlJ7zrV8AgxyRHbYvN1myWpv2l0XNczJpzFDxqb6c=;
	b=g+J62EyESL6aLr2PcjOzS84KcnDEUyPEkguEKxp1d3hpOnrYQfQ5kf3LzWw7uz6r5ztMdu
	L0dPT5QJiC4PmdSYngtNdQ6wOfW0DF58Z7JUIu7kejreORBr15NqHe47GFauaartLFGuty
	ZqX41n5Opnj6h457EDb9hulwM230tPs=
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6b12942ed04so1371786eaf.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194281; x=1788799081; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eQZlJ7zrV8AgxyRHbYvN1myWpv2l0XNczJpzFDxqb6c=;
        b=NXqhm50MNlo30FEz8Ah3pSCtwfR1kT2AwPvUikdx6YjmjPKmPrD2WbsFQryQWivC5B
         +zQ2joU7WfbYiH8gOORIYKX+M02ziW4nhF2Xm24bnFoGAAwQEbzcBjzWBwGYXHmRHrsX
         /rFAy3P63dsKtWxHR4S9gkE603nVK02JfJSTjZ/kkLXD7gUPhIh72dnvNEqPtbiZ2LWA
         ODsr2r688ZbP5A2l47Q5r570mQDZ3X86p90XZUAn175RSv6lrQapRgGh2+gDrubPZYBy
         iiRR8B5pT8l0kjKs5JdhpluGNDP9tVy9/7HWJ87E8TQAJZOhIsLUcyIGQgxw9wD2VpGv
         4ekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194281; x=1788799081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eQZlJ7zrV8AgxyRHbYvN1myWpv2l0XNczJpzFDxqb6c=;
        b=p7HJ0pCQZC6kBQui1BvyS3oM6CTWEKZpqsAZzMVXYE6bMRjxZi6x5WFSJwRx4a/c7/
         MADL+4N9DEzsvwYRsq3IQBl//cASp9gpOpVZP+0zh/f4JzbQnF9vPS24hNfFQekYONGS
         53IfR8ylJZAdFwwLelW5pr89f3Ql47mdDuaoqpdU5THbXJ8UyS3hhq7FZYrHLx4rJo8K
         lwYBGUa7SIojJfsY/rbtpGKeh5JH/V+du36vlIa/8li0EN7BX0O+8+AYYvDPikeZRmQz
         wltT+RQAOSaei/Mb2r5bvcFVLeAkvPYCw6NJS6k6GqXVzYKOxwO6/IlpdJCXj2ahQgW6
         vmhA==
X-Forwarded-Encrypted: i=1; AHgh+RoU6STmXl/6XlyCPgKeAQ3KPPsSZNdGp9Nqu6tRG8gUFgy6A2JPfUCkVCuwI7QgQPRp0BWZncUscA==@kvack.org
X-Gm-Message-State: AFuF++nB0SwnBqOuXUOmr3z441RA798McDKkNEcrOnYZtD0xcipmhjrJ
	MB4Od3W9v4RknLtt2r+G909X2B5kXT4JmeQk3xKWtKHyxbgN8pbuDN0BEZLVKw==
X-Gm-Gg: AR+sD12gS+nimo9jKO8aGS6OVaj2/e/8jw42tHFctYCYGNMjCDslYPSriJJBm6t8vdf
	p2/4GDFJV9yQPW7GhJfJapmNwMO711+X3z0SmJZ9IMoYTKIAL23IShD4F459/uJLT1z4wZqpQOH
	2AYFdR9/g/uuHtpZQ0nUaab4BtQpSJfa7GKqbFIJEgqk7Qkfg/hzrTId0i+Sq8C+utSgAbypEu9
	hX749klRYtvHbGdVNsGOfqKYydsKnrNkP8gmdLQwCA2T+9lR18+oElhyERhKNDz64Fg6ywQHatJ
	zNqo/AqDw6POvOEET33MapUfQ3ngY1W0tQFpPE6HkdJiXQ4DHV9iKZa+jQk9dS7J8rW+5lOV5R7
	A4fmuAisnDiViS2xrmkD22cVnTcUSykxNJlKAu5L+kYFOdNmdezXXgzYBGmMXGVZ9dGDq904J+p
	8fRlrYTOZIqvyILbd56eS4ENtCR6IxLVslEdm6sUXxnuSscYWRiRdSEKdQ2Ub2XaMcWdDLO7M5G
	LWfWkMGB8swMEIBJFI=
X-Received: by 2002:a05:6820:4d04:b0:6b1:7289:fc89 with SMTP id 006d021491bc7-6b1c659cf28mr24365399eaf.8.1788194280716;
        Mon, 31 Aug 2026 09:38:00 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:25::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-468a4effec0sm10484590fac.12.2026.08.31.09.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:38:00 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: [PATCH v5 6/7] mm/memcontrol: convert memcg to use page_counter_stock
Date: Mon, 31 Aug 2026 09:37:50 -0700
Message-ID: <20260831163752.2193337-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: scy7kfyd64teb376spi94qp6kcjk3zsm
X-Rspamd-Queue-Id: D070F4000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1788194281-408384
X-HE-Meta: U2FsdGVkX1+xKJcnUbBbVdK8C+KESx5A49G1mTGo9Cf4y+GyKYoO9PUWZN7ZjSXa8lTP/YhfqPGrSKClR6KMDF+l/wI9+V3ImL4tH8MMBvQemGvClddzz9TR85EqGxPp+F6M5w7hNyv1/K6FZdJ/ZPrOTpjSxEXMM3h0r5t6PU5KhQ5GsxK//e2KhDwbM/dRrP3Idr7dSJq3SqKRh3Qz1CG6Qw9o458AXSCiluQbB7KyILbmZKkLtmY2IHzyhEm0TkAW+3cztrcMbkUneYmXhlPOXFK5mIwQumHApP5s7HzaIxJR7LeLZCEj/neN2jaXiEP8ZDDrFa2gGPUspTCqbYAHxdZWcuY8jSaXl/jnfUOuSWvzkM4+E9GplCsiyTxJIVQrs2ugRr/jyMg6snZKsHNbP//yY8GzvaUn2MhSRgEaZD4NaP5SW5wq4SsJttF7BBwnF685qptKJ9XRDg/JiFgl0G1V3Y+S4nkdZnpeY2ekCNp+XC48ECOoLk7oei2Db+vp1dvJtgTZPt249J5VM9M0VvtJQrk7fk2rG4y8JL5DcojI3JO1nOt9UXhAyTrbEPMQ4vis3h8QM3K7FiB51VT4F8Y9i3QiCNTF9kaLk/wDzH9U7o68gDmcsjdDy0CI304CzrmUbblZe+mxIm4iYF1xAcCWPxeChzgpuOJ190ezOEnjzcpTTEGvdna1PKHgPQoOscibP5KOpGRjtwxKq+PJCDVK8fWNo3ScwLdhwZA1P1nXKev+xLF8rZFrjfa5IATs0eDjTK+Y4Lez1v/wsJXgN9WH9SdlG3mbe5Eha21snQgiLn8TX/Kb/XEDS59QVrbyFfM5bbFFlRFx+/8Gvqi16NG0pCqnRRz0Xrdd/pgZwzynDN+CsRWtu7l4FFg5gZtX11PZJrLnkXCirh8wd0cdpz2EsdG4Y5rZuMmn0lpQsSP8lXf1STOITO4/LRkHS6CCAh9QDcBAuIom5YR
 UTVZdQZ3
 DTT7uDpoC3+EvPWN2ZOuj+q6ZJs/qgVFr2VoyhA8lR8jmM1h2ZsFc5xktFvzMpQ2Ov+KnGSxK6keOEU5YXz1OPW2cBa0WfTLxMGOe+AFj7QQ3OoNifn2DmPZZk2OIH/PpZXwMGlyTYm2g7JN2EU398tzYFJ+FK/jdNkL7UBP+Cy0wcno7yYQLaM1Y1VGz0P45coVQ/0L4hzHcHw7iWoORny0QXIzk+lypPUDwgNY78XThcsNQ0QSIB4pEMvxbPp6sewZ2WmxRCFXUzrSNtisZN8ICfvcu0y0NPeZe1SdT7FGvbwG232SoY8PfFDr6ujLDaK77UwUvbUYH5aMdaZkZ/hZTDO3pXEekJO/VdHVmc8FsU3FcK1PMQ9NQyz45hLE7hFvvxb5581EJ1EqAT+Dca6hUOts8l3v6IIb1FQfl5CxYMjnLh80jJoDpKL+gtW0n/KSF5gaHhoeVyJoBy2C92o7IOqE4vMQjsiPVnGAUy4ZOxwegg/TfyBD0DYq0U7dz1Ft4NTUiIk6bWpSfuslRWbEw1BlnoQpJSbu3AxR3WMqC+2FYC2r32Fzfu+wYQRft2z7fODtUmvLuZNd0mMfGnS0YWEC8ibcHYdpRPansoRLlA+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that page_counter transparently handles stock usage and refills,
switch memcg to use page_counter_stock. stock is allocated per-CPU for
every non-root memcg, which is 16 bytes per-cpu per-memcg and allocated
with GFP_KERNEL_ACCOUNT.

The !allow_spinning special case in try_charge_memcg goes away. It
clamped batch to nr_pages so a charge would not have to refill the stock
and potentially do an expensive flush. We now refill with a trylock
and retry the exact size if the greedy charge fails, so a non-spinning
caller is never made to wait or fail early.

Also, while we no longer have a 7-memcg cap, it also means that each CPU
can now cache an unbounded number of pages. System-wide, pre-charged but
unused memory goes from NR_MEMCG_STOCK * batch * ncpus to nr_memcgs *
batch * ncpus.

We can also now drain stock on isolated CPUs as well, since draining is
no longer a per-cpu local operation.

This leaves one user-visible change for legacy cgroup v1 (memsw).
Because the stock becomes private to the memory page_counter rather than
shared by memory and memsw, memsw.usage - memory.usage no longer equals
swap usage. Userspace programs using the legacy cgroup and deriving swap
usage using this method can underflow. The next patch gives memsw its
own stock, narrowing this to a transient drift.

With all of these changes made, also remove all newly unused memcg code.
obj_stock is untouched and is still needed. FLUSHING_CACHED_CHARGE and
the memcg_wq are preserved so obj_stock can use them as well.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 285 +++++-------------------------------------------
 1 file changed, 30 insertions(+), 255 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 71410084fa7fc..5678486cc55b0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2027,35 +2027,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
 	pr_cont(" are going to be killed due to memory.oom.group set\n");
 }
 
-/*
- * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and their
- * nr_pages in a single cacheline. This may change in future.
- */
-#define NR_MEMCG_STOCK 7
-
-/*
- * Watermarks for a charge stock slot, in the spirit of pcp->high and
- * pcp->batch: MEMCG_STOCK_HIGH is the high watermark at which a slot is
- * trimmed, and it is trimmed down to MEMCG_STOCK_LOW rather than emptied.
- */
-#define MEMCG_STOCK_LOW		(MEMCG_CHARGE_BATCH / 2)
-#define MEMCG_STOCK_HIGH	(MEMCG_CHARGE_BATCH)
-
 #define FLUSHING_CACHED_CHARGE	0
-struct memcg_stock_pcp {
-	local_trylock_t lock;
-	uint8_t nr_pages[NR_MEMCG_STOCK];
-	struct mem_cgroup *cached[NR_MEMCG_STOCK];
-
-	struct work_struct work;
-	unsigned long flags;
-	uint8_t drain_idx;
-};
-
-static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
-	.lock = INIT_LOCAL_TRYLOCK(lock),
-};
-
 /*
  * NR_OBJ_STOCK is sized so the entire hot path of obj_stock_pcp
  * (lock, accounting metadata, nr_bytes[] and cached[]) fits within a
@@ -2103,52 +2075,6 @@ static void drain_obj_stock(struct obj_stock_pcp *stock);
 static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 
-/**
- * consume_stock: Try to consume stocked charge on this cpu.
- * @memcg: memcg to consume from.
- * @nr_pages: how many pages to charge.
- *
- * Consume the cached charge if enough nr_pages are present otherwise return
- * failure. Also return failure for charge request larger than
- * MEMCG_CHARGE_BATCH or if the local lock is already taken.
- *
- * returns true if successful, false otherwise.
- */
-static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	struct memcg_stock_pcp *stock;
-	uint8_t stock_pages;
-	bool ret = false;
-	int i;
-
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock))
-		return ret;
-
-	stock = this_cpu_ptr(&memcg_stock);
-
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		if (memcg != READ_ONCE(stock->cached[i]))
-			continue;
-
-		stock_pages = READ_ONCE(stock->nr_pages[i]);
-		if (stock_pages >= nr_pages) {
-			stock_pages -= nr_pages;
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (!stock_pages) {
-				css_put(&memcg->css);
-				WRITE_ONCE(stock->cached[i], NULL);
-			}
-			ret = true;
-		}
-		break;
-	}
-
-	local_unlock(&memcg_stock.lock);
-
-	return ret;
-}
-
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	page_counter_uncharge(&memcg->memory, nr_pages);
@@ -2156,51 +2082,6 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 }
 
-/*
- * Returns stocks cached in percpu and reset cached information.
- */
-static void drain_stock(struct memcg_stock_pcp *stock, int i)
-{
-	struct mem_cgroup *old = READ_ONCE(stock->cached[i]);
-	uint8_t stock_pages;
-
-	if (!old)
-		return;
-
-	stock_pages = READ_ONCE(stock->nr_pages[i]);
-	if (stock_pages) {
-		memcg_uncharge(old, stock_pages);
-		WRITE_ONCE(stock->nr_pages[i], 0);
-	}
-
-	css_put(&old->css);
-	WRITE_ONCE(stock->cached[i], NULL);
-}
-
-static void drain_stock_fully(struct memcg_stock_pcp *stock)
-{
-	int i;
-
-	for (i = 0; i < NR_MEMCG_STOCK; ++i)
-		drain_stock(stock, i);
-}
-
-static void drain_local_memcg_stock(struct work_struct *dummy)
-{
-	struct memcg_stock_pcp *stock;
-
-	if (WARN_ONCE(!in_task(), "drain in non-task context"))
-		return;
-
-	local_lock(&memcg_stock.lock);
-
-	stock = this_cpu_ptr(&memcg_stock);
-	drain_stock_fully(stock);
-	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
-
-	local_unlock(&memcg_stock.lock);
-}
-
 static void drain_local_obj_stock(struct work_struct *dummy)
 {
 	struct obj_stock_pcp *stock;
@@ -2217,92 +2098,6 @@ static void drain_local_obj_stock(struct work_struct *dummy)
 	local_unlock(&obj_stock.lock);
 }
 
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	struct memcg_stock_pcp *stock;
-	struct mem_cgroup *cached;
-	unsigned int stock_pages;
-	bool success = false;
-	int empty_slot = -1;
-	int i;
-
-	/*
-	 * nr_pages[] is a uint8_t and a slot's count is capped at
-	 * MEMCG_STOCK_HIGH. Raising MEMCG_CHARGE_BATCH beyond 127 would need
-	 * more careful handling of nr_pages[] in struct memcg_stock_pcp.
-	 */
-	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
-	BUILD_BUG_ON(MEMCG_STOCK_HIGH > U8_MAX);
-
-	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
-
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock)) {
-		/*
-		 * In case of larger than batch refill or unlikely failure to
-		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
-		 */
-		memcg_uncharge(memcg, nr_pages);
-		return;
-	}
-
-	stock = this_cpu_ptr(&memcg_stock);
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		cached = READ_ONCE(stock->cached[i]);
-		if (!cached && empty_slot == -1)
-			empty_slot = i;
-		if (memcg == READ_ONCE(stock->cached[i])) {
-			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
-			if (stock_pages > MEMCG_STOCK_HIGH) {
-				memcg_uncharge(memcg,
-					       stock_pages - MEMCG_STOCK_LOW);
-				stock_pages = MEMCG_STOCK_LOW;
-			}
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			success = true;
-			break;
-		}
-	}
-
-	if (!success) {
-		i = empty_slot;
-		if (i == -1) {
-			i = stock->drain_idx++;
-			if (stock->drain_idx == NR_MEMCG_STOCK)
-				stock->drain_idx = 0;
-			drain_stock(stock, i);
-		}
-		css_get(&memcg->css);
-		WRITE_ONCE(stock->cached[i], memcg);
-		WRITE_ONCE(stock->nr_pages[i], nr_pages);
-	}
-
-	local_unlock(&memcg_stock.lock);
-}
-
-static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
-				  struct mem_cgroup *root_memcg)
-{
-	struct mem_cgroup *memcg;
-	bool flush = false;
-	int i;
-
-	rcu_read_lock();
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		memcg = READ_ONCE(stock->cached[i]);
-		if (!memcg)
-			continue;
-
-		if (READ_ONCE(stock->nr_pages[i]) &&
-		    mem_cgroup_is_descendant(memcg, root_memcg)) {
-			flush = true;
-			break;
-		}
-	}
-	rcu_read_unlock();
-	return flush;
-}
-
 static bool schedule_drain_work(int cpu, struct work_struct *work)
 {
 	/*
@@ -2325,34 +2120,22 @@ static bool schedule_drain_work(int cpu, struct work_struct *work)
  */
 void drain_all_stock(struct mem_cgroup *root_memcg)
 {
+	struct mem_cgroup *memcg;
 	int cpu, curcpu;
 
 	/* If someone's already draining, avoid adding running more workers. */
 	if (!mutex_trylock(&percpu_charge_mutex))
 		return;
-	/*
-	 * Notify other cpus that system-wide "drain" is running
-	 * We do not care about races with the cpu hotplug because cpu down
-	 * as well as workers from this path always operate on the local
-	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
-	 */
+
+	for_each_mem_cgroup_tree(memcg, root_memcg)
+		page_counter_drain_stock_async(&memcg->memory);
+
+	/* Hotplug races are OK; workers only touch their own cpu's obj_stock */
 	migrate_disable();
 	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
-		struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
 		struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
-		if (!test_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags) &&
-		    is_memcg_drain_needed(memcg_st, root_memcg) &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
-				      &memcg_st->flags)) {
-			if (cpu == curcpu)
-				drain_local_memcg_stock(&memcg_st->work);
-			else if (!schedule_drain_work(cpu, &memcg_st->work))
-				clear_bit(FLUSHING_CACHED_CHARGE,
-					  &memcg_st->flags);
-		}
-
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
 		    obj_stock_flush_required(obj_st, root_memcg) &&
 		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
@@ -2370,20 +2153,21 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
-	struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
+	struct mem_cgroup *memcg;
 	struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
 	/* no need for the local lock */
 	drain_obj_stock(obj_st);
-	drain_stock_fully(memcg_st);
+
+	for_each_mem_cgroup_tree(memcg, NULL)
+		page_counter_drain_cpu_stock(&memcg->memory, cpu);
 
 	/*
 	 * A drain work queued before the CPU went away is executed by an
 	 * unbound worker on some other CPU and clears that CPU's flag, so
-	 * clear the flags here to make these stocks drainable again once
-	 * the CPU comes back online.
+	 * clear the flag here to make this stock drainable again once the CPU
+	 * comes back online.
 	 */
-	clear_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags);
 	clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
 
 	return 0;
@@ -2658,7 +2442,6 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
-	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
@@ -2672,35 +2455,22 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
 retry:
-	if (consume_stock(memcg, nr_pages))
-		return 0;
-
-	if (!allow_spinning)
-		/* Avoid the refill and flush of the older stock */
-		batch = nr_pages;
-
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, batch, &counter, NULL)) {
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter, NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter,
-				    &nr_charged))
-		goto done_restock;
+	if (page_counter_try_charge(&memcg->memory, nr_pages, &counter, &nr_charged))
+		goto check_high;
 
 	if (do_memsw_account())
-		page_counter_uncharge(&memcg->memsw, batch);
+		page_counter_uncharge(&memcg->memsw, nr_pages);
 	mem_over_limit = mem_cgroup_from_counter(counter, memory);
 
 reclaim:
-	if (batch > nr_pages) {
-		batch = nr_pages;
-		goto retry;
-	}
-
 	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
@@ -2809,10 +2579,9 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	return 0;
 
-done_restock:
-	if (batch > nr_pages)
-		refill_stock(memcg, batch - nr_pages);
-
+check_high:
+	if (!nr_charged)
+		return 0;
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
@@ -3154,8 +2923,11 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 
 	account_kmem_nmi_safe(memcg, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
-	if (!mem_cgroup_is_root(memcg))
-		refill_stock(memcg, nr_pages);
+	if (!mem_cgroup_is_root(memcg)) {
+		page_counter_refill_stock(&memcg->memory, nr_pages);
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, nr_pages);
+	}
 
 	css_put(&memcg->css);
 }
@@ -4157,6 +3929,7 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
+	page_counter_free_stock(&memcg->memory);
 	lru_gen_exit_memcg(memcg);
 	memcg_wb_domain_exit(memcg);
 	__mem_cgroup_free(memcg);
@@ -4324,6 +4097,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
 
+	/* stock allocation failure is nonfatal; fall back to direct charges */
+	if (!mem_cgroup_is_root(memcg))
+		page_counter_alloc_stock(&memcg->memory, MEMCG_CHARGE_BATCH);
+
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
 	 *
@@ -5665,7 +5442,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 
 	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
-	refill_stock(memcg, nr_pages);
+	page_counter_refill_stock(&memcg->memory, nr_pages);
 }
 
 void mem_cgroup_flush_workqueue(void)
@@ -5719,8 +5496,6 @@ int __init mem_cgroup_init(void)
 	WARN_ON(!memcg_wq);
 
 	for_each_possible_cpu(cpu) {
-		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
-			  drain_local_memcg_stock);
 		INIT_WORK(&per_cpu_ptr(&obj_stock, cpu)->work,
 			  drain_local_obj_stock);
 	}
-- 
2.53.0-Meta


