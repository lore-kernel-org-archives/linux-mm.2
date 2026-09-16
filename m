Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9138C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 21:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6896B0095; Wed, 16 Sep 2026 17:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4780A6B0096; Wed, 16 Sep 2026 17:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2F96B0098; Wed, 16 Sep 2026 17:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 015866B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:06:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC7661A016A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:06:04 +0000 (UTC)
X-FDA: 85220857848.10.2DAABBF
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id 163AEA000F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:06:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RCOMhKKy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789592763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HaJwiI/6dGGbCvd8Rz5XOkB+OlzyBFXfmU7W/ZpuGJs=;
	b=QIW/vHbe47WKdXgdFOg5IBIdARDSdJX9lhGRkj5Y5ezfJhrVrFwsREZ70t+r9HFgRjHZPw
	ZRO/Nssd/FYGdBdlzzqp4S482LJ9s05klkikq5MRov93wqBJ6lSVHWLV2xcT8Lp6Vqp/bF
	H0FPZKlfkoApELOSggcdgKP6zwImN1s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789592763;
	b=b3kqp7nEhaqqCCyjFe0LtQNGzk4KAmzPFRdDIIkeca6vySwxV+mQHG3DRVD/2dl3NrNisR
	6afOkriGCK4maTEpI5sztBP9ByzjxY0EXv234M6lmeEPLxSSIlFrono74LvNWfBwBN3T4r
	STif4VtRWE8FXFz7QcZRlBKiqbikd34=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RCOMhKKy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-80638c24bedso67132a34.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789592762; x=1790197562; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HaJwiI/6dGGbCvd8Rz5XOkB+OlzyBFXfmU7W/ZpuGJs=;
        b=RCOMhKKyiYW/iFMONrf9N36sMlRI7pQKaEjyGk4pnPGhl3mAD6LkzQBLOwf3wZ3jGH
         6mk5V/A857Yk2882ZQ7ndGgj23FwV5k7dJQfWJi/XFfz9wNO5KdNkNRAjjA4kXGMY/Fm
         SjtiflbacQ12NCv41xlQZwQxNtSBSFEqERvYsLtdwm7UroU00e50HDY2a9j34H/NVIEw
         nwXc+YAbJL9FbFopwtgwP+DA7qVtBn/s0X7VwT0q+gVYk49VBKhEmnAQbYUupjq3juoP
         B4f0Pn6iZO3Q1IKCw1bERRdB6AimszS9IiF+tP2FwBkqBPWmeEcu/jWVtnAAsWTOLq6r
         1K6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789592762; x=1790197562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HaJwiI/6dGGbCvd8Rz5XOkB+OlzyBFXfmU7W/ZpuGJs=;
        b=0c1oWsgivZDuFUBREJMKOL0ThbfiR4SQwuZpLclw6LwFo5nxkErSPy+OWMnC4GVNdz
         EsceZOtqV6ipB3ik4h3zk3j76fVTlZIfBD6MwC+2haHxnPDrh1fGbaVeGp4DifVb6JB3
         BToe7wBWIfGipB5iKdW05KPbNibhm5p2Wcwsswt/Z0fvOzVvl0Tpq61r4hlPpUn3JiW4
         luR5wA6bayG6bCNMeB9H4OqT3Jxp6Shv4AaOKTHgaKuRYtJ31M60nW90bnYI13YodCTn
         sCBf2wAhslfCKw3zMJ2zdRrPC5Nm+iC6Tzbm23w1BE6PY4BI3JIPy5Rd8jzNGw7CjCyC
         eDcw==
X-Forwarded-Encrypted: i=1; AKwUvBwVlQGVd/UWmXv7xbM2h8sm7HAq6c3eQgJ1ZyIfnpPFElzDDx8Vvg5QvIvjRnsMYy0dmGcnNIO3OQ==@kvack.org
X-Gm-Message-State: AFuF++nwe9x9sFMHwZHF7UzBqrSSeahsbRJAjDEro0cilTTL2f4zz4+u
	lzFEquoIxc29YsdFuK/lZBOPJ9xn4JfHMqKZFFKAQv7BH3Avunbe8Q3o
X-Gm-Gg: AYBFou3Hbud1PLxD47NrpIEVDaLb0tSGx4K3d4n8BvUXKUgMyl5hXfBZiBpnGstFoPB
	VNA73SDiH2l0E/a2yPGgWEkZabAw521x2vgvti4Bp2xQZ9SDrnHi39H5m93OpKnCo2pBI5eLsis
	ttPfZ1vUW/36woiwjEmjWB6+8RitY8B5f0c4s8wd7btiEAwmg33OKvgJOpRPL525E1Z9HMVmT6Z
	yn4uJS3nx3asfx4++XbdDwK0hsBM79fFlANPB8tK8v9eDN+T7aWDdzEuYUEtKNt/OwQnTVpYcqU
	XIC1WgKjuj0jht0KQt98W4l9uxNLk19Q/d8Vs6ps14CWXhPVD2US0mZHpNzZNB2UBVxV0Qi1V3B
	AjzRtzWz3ghykNcBMN6OL1xUsZKckJlDW/rzivrkEgM3dpjX5cxEGR+PmzjVZ6/fzO55dmAmGaB
	TVXaBy2aGE/+CYkc/oGH9NFkokYxpBoWIE9i7JezMLEDg5lFFkaPNyRqbM1RTf81uEphuWCYur5
	+yp7jd5QK7wxF6wseNoE56y00shsw==
X-Received: by 2002:a05:6830:a1d0:10b0:805:5bf7:4ab with SMTP id 46e09a7af769-80c4bd14b16mr715864a34.1.1789592762077;
        Wed, 16 Sep 2026 14:06:02 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c466a2dcesm1019834a34.11.2026.09.16.14.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:06:01 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v6 5/5] mm/memcontrol: add stock to the memsw page counter
Date: Wed, 16 Sep 2026 14:05:51 -0700
Message-ID: <20260916210552.891730-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
References: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 163AEA000F
X-Stat-Signature: ywo64frmn1bcc97rciug9ddgbbxbbucm
X-HE-Tag: 1789592762-678240
X-HE-Meta: U2FsdGVkX18gUGUMELME6lXcrwzOrSV1EUh1lcs34fXe8JA4UX9MWTPc8jAt3F7lhBJ5tFzrhjkmJflZF4y/ThqqnvUnP0fnbbx12pYiTEnd0nRcjU+94WsQfQHB/zxlypaSa0+IycU7ezFGlYTVjrt0rdr2g/kO38+exSSUObxI9+843ufVMHtZcyg9lVjNROXgCu420GJ7zsk79jHjcCpLjTIRXAUbwlS+1WzGXylaFv7QyGgyIhmTumwIEpDYQn65MqmaSbkAVyjUhEMRiFpF0Zzahy8nreF5UIPAJV4bmO4niRv7mxBiw8eGrwTyOU8yR979DZD5NXM2tCWmMet2z3n5ZWJkSxke6xBZ2JLbBx07NE7Iwi5WLH87hsccdinx+l+uR4o0oRO767LzHS/bL5M7KcipupSM0PknIxtmYRaerI7o84M97FFJ61PcgpZUoKrMuaj7WoiZc3lUKN3vWepxip9aP6M/u2pnJWNucGxhcbP0nIpA1CTz/8O9B49OStEfMKRMnMrOEg1X7ASI/aiAxtGPYB0TSeI87KBlsl8xsa6OdRORns/JLNfmqSF80a26Lafy5qbAvNWS/DAqbrZZEAzqvYYTc1AA7sul9iMtOlxWLS5gSUUqTx2oeF+n5YX61TrI9R38lfS3lYX8A4BxwTek4DpZKNFDJg5qquESEyeP9GoLlrwmikKjiyu1zL5JT0iSb+63mO4STQcZV6VAWWGsa1drObJEbeqk9emvaOFpYPH5urnAhiAys5/WGGbeGcy8lzMoyPzOAsiTeSL1GhHm0kdZ9/reUrerAKguKIXOzt+ttasKAFmj4Vy+lxg4G2rvjtgB9gTzSgzWGrJQtz7lFMTMEhQLRvhrVa0PDfsMQRjEfmu8yvRM+0iDQyLFEdd2kfcRH4a1mf5ViyonsxH+8Igt+yK0c/UJyMo65vk0ApjfEs+aN20RIDJ/mE49vmxXBFDw9Ck
 ZYGZP11N
 RpvpPxW/1KZhyk808gyyqw1dn5MOP4Fn0L5Onbn7y9nO6RRIFbY2Nu/uAfR5OAt37x9t661+04MkjTFSQ0EDG5fKLVKtzYIHhnqg06A4Ykc5hNW6h4i3vLN4n92XKwfzuOXNKAqY48RnfqIukh032nMsCf3zkeLHXTFgZUNAkPlE4rTVBOTHyKcb/3zZ0+DrKDWFkR76qeJshvMO1VIPS7SZUloPiwLZDN7KsBvu+rsmbKC6vgVJDck58jzEfcmuNmNFqrgs8sZhsXJehp+NRs5dLiJW3nEzWuxY9sIX/82/d/nNGrN+6lZCQc5UBy1RZa7tfDU3ezG9beIO1Yz7ju1TDU4QFmatEkkj0peL9PGUNg8t9qGllE+nbm9dPqRVdGlAP6duxS5KtTWt35u4uv+ciJa1e/7GUEFt80CM7mv30loEtWtDD3tXbLcmBAlIDp8kuwY0sdylnGhdXkwqZzBVtLQacPe0UxL7gJ+NEUA1OQyFgPDddTAU72EUHAfvzZ25j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Attach legacy memsw page counters to their own seven-slot per-CPU
stock. Charge, refill, drain, and hotplug handling now operate on the
memory and memsw banks independently.

Factor the common drain scheduling into schedule_stock_drain() now
that both stocks use it.

Keep the existing direct memsw rollback when the memory charge fails,
ensuring that failed allocations do not replenish the newly
attached memsw stock.

The separate banks can hit, contend, evict, and drain independently,
so their raw counters can temporarily drift by their cached amounts.
The previous patch preserves the user-visible cgroup-v1 invariant by
reporting memory.memsw.usage_in_bytes as the larger raw value.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 62 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1a209ad535540..7d5b2539c5699 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2056,6 +2056,13 @@ static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memory_stock) = {
 	.base = &memory_stock,
 };
 
+#ifdef CONFIG_MEMCG_V1
+static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memsw_stock) = {
+	.lock = INIT_LOCAL_TRYLOCK(lock),
+	.base = &memsw_stock,
+};
+#endif
+
 /*
  * NR_OBJ_STOCK is sized so the entire hot path of obj_stock_pcp
  * (lock, accounting metadata, nr_bytes[] and cached[]) fits within a
@@ -2160,12 +2167,30 @@ static bool schedule_drain_work(int cpu, struct work_struct *work)
 	return true;
 }
 
+static void schedule_stock_drain(struct page_counter_stock_pcp __percpu *stock,
+				 struct cgroup_subsys_state *root_css,
+				 int cpu, int curcpu)
+{
+	struct page_counter_stock_pcp *pcp_stock = per_cpu_ptr(stock, cpu);
+
+	if (test_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags) ||
+	    !page_counter_stock_flush_required(pcp_stock, root_css) ||
+	    test_and_set_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags))
+		return;
+
+	if (cpu == curcpu)
+		drain_local_stock(&pcp_stock->work);
+	else if (!schedule_drain_work(cpu, &pcp_stock->work))
+		clear_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags);
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
  */
 void drain_all_stock(struct mem_cgroup *root_memcg)
 {
+	struct cgroup_subsys_state *root_css = &root_memcg->css;
 	int cpu, curcpu;
 
 	/* If someone's already draining, avoid adding running more workers. */
@@ -2180,21 +2205,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 	migrate_disable();
 	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
-		struct page_counter_stock_pcp *memory_st =
-			per_cpu_ptr(&memory_stock, cpu);
 		struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
-		if (!test_bit(FLUSHING_CACHED_CHARGE, &memory_st->flags) &&
-		    page_counter_stock_flush_required(memory_st,
-						      &root_memcg->css) &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
-				      &memory_st->flags)) {
-			if (cpu == curcpu)
-				drain_local_stock(&memory_st->work);
-			else if (!schedule_drain_work(cpu, &memory_st->work))
-				clear_bit(FLUSHING_CACHED_CHARGE,
-					  &memory_st->flags);
-		}
+		schedule_stock_drain(&memory_stock, root_css, cpu, curcpu);
+#ifdef CONFIG_MEMCG_V1
+		if (do_memsw_account())
+			schedule_stock_drain(&memsw_stock, root_css, cpu, curcpu);
+#endif
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
 		    obj_stock_flush_required(obj_st, root_memcg) &&
@@ -2221,6 +2238,11 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	stock = per_cpu_ptr(&memory_stock, cpu);
 	page_counter_drain_stock_fully(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
+#ifdef CONFIG_MEMCG_V1
+	stock = per_cpu_ptr(&memsw_stock, cpu);
+	page_counter_drain_stock_fully(stock);
+	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
+#endif
 
 	/*
 	 * A drain work queued before the CPU went away is executed by an
@@ -2524,8 +2546,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 retry:
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter, false,
-				     NULL)) {
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter,
+				     may_batch, NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 		goto reclaim;
@@ -3004,7 +3026,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_refill_stock(&memcg->memory, nr_pages);
 		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, nr_pages);
+			page_counter_refill_stock(&memcg->memsw, nr_pages);
 	}
 
 	css_put(&memcg->css);
@@ -4108,6 +4130,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		memcg->memory.stock_css = &memcg->css;
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
+		if (!memcg_on_dfl) {
+			memcg->memsw.stock = &memsw_stock;
+			memcg->memsw.stock_css = &memcg->css;
+		}
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
 		memcg->memsw.track_failcnt = !memcg_on_dfl;
@@ -5735,6 +5761,10 @@ int __init mem_cgroup_init(void)
 	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memory_stock, cpu)->work,
 			  drain_local_stock);
+#ifdef CONFIG_MEMCG_V1
+		INIT_WORK(&per_cpu_ptr(&memsw_stock, cpu)->work,
+			  drain_local_stock);
+#endif
 		INIT_WORK(&per_cpu_ptr(&obj_stock, cpu)->work,
 			  drain_local_obj_stock);
 	}
-- 
2.53.0-Meta


