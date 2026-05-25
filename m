Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ED7FCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627916B0098; Mon, 25 May 2026 15:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A9A6B0099; Mon, 25 May 2026 15:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42AA76B009B; Mon, 25 May 2026 15:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33DE86B0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:05:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E90E61201BC
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:13 +0000 (UTC)
X-FDA: 84806870106.24.CDFE792
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id 06537C0002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AQLasLL2;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779735912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnIw8YkeeVJF7u3zrXFA437o74mwG9/TEQ/6A3i13nY=;
	b=7ENMfvQ11/ovjGSPH9Ny8bnpJXBgWMHuUTKnaT0nxMK1Scy2zOVhNv+4aBAvNm9l2vR0XU
	pAW05VEp5Zr4q5lC+j918fRWGeFDcTDfrVPwGis5DI6xog86f14+H7xQChgbzTWp15zsUP
	4GWX+Qq8X5EgB9SHF7O/1iI1NmTT2ds=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779735912; a=rsa-sha256;
	cv=none;
	b=sNDZFbUwtXgaQoi30Pk3vdIiWCCTSJj3AiYyfv9g/uj89j5CoWiJYgP4L+nGmgKtI/tCrr
	Fk/e5evddk9A+oeU4U5Ww7hJElHprNMHaa/XazWhrtJxxeadJYTRlehFXCZA/zW7ofc8kd
	qRDZ9hGFwkZxc2E1U0jf2tEnsDG3iYI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AQLasLL2;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7e61da76fd9so1583604a34.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 12:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779735911; x=1780340711; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xnIw8YkeeVJF7u3zrXFA437o74mwG9/TEQ/6A3i13nY=;
        b=AQLasLL2+mN85kjm71UHCGoHiODvb9nWkifPVCCeOq6ok0Jln/wRi/7u71+NfHW+/k
         4rvAXKGvul6KUIkeBPww3KMakfPmQNlx0XD0xXdtmR4FaeFRW7WxWN19ug39gUtT4Wxz
         0n35rgdnfk9cjZqJ6jvvpkuWPTbg5bz8bjSu4eH/oQvU3ICNplm6jJMEY+AkZewwqAzR
         jAaBK5EWWn4oR1a0Zs7ZN8zeJ05u1tsRA4LZVRQzr4xvXEGaPeEeMP10EaImkVCzgHqf
         Ub+RK9INBUfQDe/Q6rWzOjW0IS1d05lW0OD2YY3LXb2xujNHIWYLnxl6J+otQanFdqUP
         fJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779735911; x=1780340711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xnIw8YkeeVJF7u3zrXFA437o74mwG9/TEQ/6A3i13nY=;
        b=HpSGYNkNcUyN4cYhORqRcXMNyXQR4H63MO0JcAd/VRYGaTn1fpTyDHOpMoZbWZa2Qo
         BV+KT6MwcaliskmfVYiF4ws0uEovg+S2jyJmqb3cCqd0ZqiQtTnPJ/jX8XQfPzlFPv23
         Rxeonql7NBPR84bR9pZR7SY4o2k+cJWgUr0JFvtkhPJRwJHmtzW20f6l0Ml7CTjObLxb
         waEH8pB029V1CHjeBZQFEJRJBUuYR84tCsmUO1hNkOoe4xMdlDQLR9wBuvhFMaC1Cc/p
         SGL61GiW4By4XhKoFuJGOHegKQTmi/ahlTosTEMVpF3YvvcZCPlCq2gGZPjdTPIkysUw
         s5Jg==
X-Forwarded-Encrypted: i=1; AFNElJ/xQ87bmrnIds3alDOZ4puqjzst+auHJIszcX3fHQGquWgWxQsLkizPuDV/SIHPPUb+wW305rvJwQ==@kvack.org
X-Gm-Message-State: AOJu0Ywc5YGlqCBA0vRLt7Cq0dikup32mrRjQb+KCj8OjSaETFccdew7
	osVH2DWmTGGHCXg0P87gRTYZK8P0CaDenso6drCSLtqy7gCy5JWqr1k2
X-Gm-Gg: Acq92OHrmnBtilAK5LywZvVMxJrzkG3uSER/RLC3c3FGUpNieDJmkZBo4Va1oBdOX/e
	/c/8Gi3tlUZyBa6ivdK/OMi09ScmARbRGQbUAMMMRYexnkpfENVzDypRPRrPqyLW+0qs1gZUpEY
	sKyj0oP50F0v0HbUvP4q0133MT49M42RqgGmrIAV2UGi6g+nVhjImSe0xwtODU/nwaRBAxPgjxT
	PdG1DGKw4EkjH+wPeTRUFpIFI0gwykPxeLgB8YsuBb9RcFnPn9R4ly7A63ftV6OU+8zZbN7Sr1x
	owp1w5i5NOYT4yRLP5PN/z1jd9iHuCiwTwZa9F4PnWRWOPH1XbxowyIsb5In3WsQ0bVDFBf9LzJ
	wm8nbjMoaH/wACN0NUytZK1FZhxpA+xXzhKtMLHfbQlVfc4kUJpVr2mFMeoh8pjhPrxb4K9fBFT
	ad1Do0OmQTDlGT/tVSSpMMOYHrVi7whOn2zl90/gM404moOhTHD00EMQ==
X-Received: by 2002:a05:6830:7187:b0:7d7:e045:b489 with SMTP id 46e09a7af769-7e5feeb9b7cmr9201550a34.12.1779735910946;
        Mon, 25 May 2026 12:05:10 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e60663fe79sm7729095a34.20.2026.05.25.12.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 12:05:10 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 7/7 v3] mm/memcontrol: remove unused memcg_stock code
Date: Mon, 25 May 2026 12:04:54 -0700
Message-ID: <20260525190455.2843786-8-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
References: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: wg6he4or5fbo5pjmkcpgzicqa4c9bifd
X-Rspamd-Queue-Id: 06537C0002
X-Rspam-User: 
X-HE-Tag: 1779735911-979623
X-HE-Meta: U2FsdGVkX182RXRprxzoMoFdI+fSKcuGHEBz3j848YvohJc2jc46lm5s6HTuBkfsu4A7i5t7lNrKbOddhDoe5O+Z0BbsRA7SnujRWNq1GgJDhGFaK1lFVX/wc6NFwk3LaDoPyOHDzxACXMfkwYkjcP49eD5+9JUXj+n61IbJXy7sbBlwSyEdPBJummLuBJ4mQ3O7L/UEcp63iRWXw0PzmBjRjhijDLTPpLY2uxWIFV6ojtN2fYCx61q4p1xLcAPU0sSHQeDZMwfW7fmhNv6nxfGsWRsVylcr9iQZVuZy74z/zaGnrCbqsKKnsdNZjcOc+jUlkJYi6pWZmTCWuXHVhox3HHFXSlvT6eoaiL5gAJsG0nYlKsAAwCdHgd+yz5AwTxy7t4lEc4LAXKvyOc0qSIvYgdo/jlE8u7QuTyhLR3hxG1kJQyXc5rACxqD0vocQwS40bf0ycf2H9VnnllnBBXw3Y1gZg+RzMTgOKEB+mT80UwHeDTuj88rlacnYDHQG0WeNtWQeY+PFZYYvfHe9k5kAkdefXgbaeDObdmLpAsR5GQlu+l/sPTQul6WRPvcy/pJO1m97y+oLpQoWyoAfTD7S64pPVB38icY/GqeBo4fAdvsBwhN8dQL0FgmDy+UDFQiDRzlM3UN6FnVRVegXXMesdHz/DH9EyqUmcMs0Vg5gErAQkGEsHTg/2vq2GBzkszuvB/gQuMipJnAcP+CEtf6jjEFhEWNPWVSppcX3DkGn1Gyi2hZsnganWD6h5GHB8lHM6bVZ3OYZCjpxq0A+9xmjgpE8ojglDwlWNV2JOzxNPUPLhic4dWrQTnt2P24RF3ekEkbzIngMzXLN+IKcFO7w3M5qtxxyBHMAYBycSCM2o815l7d1EcUsbQE9HKbPR4HFtx8gtMYCf62N3KYmsd0rr67xOBGPNG7WqB3dShdr/0FWJiYlPbmw5J2z6DTkIkNz4/6Iim8FkeX4LCD
 nG28zdBR
 7vN335UWdbYLfrhwAKdId4Bw1ot0umZOPiyrY12bOnywRMHTpqadR/rXl6hg8V4Bj9WB/D/f7ooOcCK852sglyRcKxJqaBS3gFwolnNrzM+AmA0uZVMsH+s0XcGKoAFmfa49J7sqlaLtD1h1mO5kTylM260HaD2T5w1DX2/N9tNcfNC/OaTyzoPYLgGJf/I5uQQJZGHO2yjSTeyDCE1k9mGWrfcQxGbSVr2H1rUt3NLxENQnEy4jpowsptX9dnbeGKyhH+toji9xmJRni7L6cVIkb6BIQllTcfd9BkfQpvdeixY2k7HzU5DwBzekg1SJ9mSiFbB4t4ASlYygdl/3WUBvGtIYc+RNcPW0Gv55q9nNgAo/eymN5LgXFmPdxqysZwoIxCAjp9jGsvhsDz0gAj0CE3eiLE8sWu88LYLxXlSxs/UT8UnW1Esv3QC3PMFsoCZ9t4RpkjPn/Vu82Qqk620+EKMcbC0lzfKCsX1CWg3egvRxe5Fc/4ymPG/0YW6bN7ifrUaawYtg7g3pfJn3eAKACDfyHsGBucGDiNZwPeviXQUUgJYHv7NYjAvblVRznLQ1z/wi44vs6THv1MM+E/0GcaPUotVCuS9oHYqDJZXDK8xWXc++FOsXkXSluia2St/2tsLrWjMvvy5if0cHQTBRPSMxHvzp0lEWT4tTox1Xrh0NDNAiCUJfuoxX62LXuSsef
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all memcg_stock logic has been moved to page_counter_stock, we
can remove all code related to handling memcg_stock. Note that obj_stock
is untouched and is still needed. FLUSHING_CACHED_CHARGE is preserved
so that it can be used by obj_stock as well.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 186 ------------------------------------------------
 1 file changed, 186 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 64b82f1782720..5319219d0dcb5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1998,25 +1998,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
 	pr_cont(" are going to be killed due to memory.oom.group set\n");
 }
 
-/*
- * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and their
- * nr_pages in a single cacheline. This may change in future.
- */
-#define NR_MEMCG_STOCK 7
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
 
 /*
  * NR_OBJ_STOCK is sized so the entire hot path of obj_stock_pcp
@@ -2056,47 +2038,6 @@ static void drain_obj_stock(struct obj_stock_pcp *stock);
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
-			WRITE_ONCE(stock->nr_pages[i], stock_pages - nr_pages);
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
@@ -2104,51 +2045,6 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
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
@@ -2165,88 +2061,6 @@ static void drain_local_obj_stock(struct work_struct *dummy)
 	local_unlock(&obj_stock.lock);
 }
 
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	struct memcg_stock_pcp *stock;
-	struct mem_cgroup *cached;
-	uint8_t stock_pages;
-	bool success = false;
-	int empty_slot = -1;
-	int i;
-
-	/*
-	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
-	 * decide to increase it more than 127 then we will need more careful
-	 * handling of nr_pages[] in struct memcg_stock_pcp.
-	 */
-	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
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
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (stock_pages > MEMCG_CHARGE_BATCH)
-				drain_stock(stock, i);
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
 static void schedule_drain_work(int cpu, struct work_struct *work)
 {
 	/*
-- 
2.53.0-Meta


