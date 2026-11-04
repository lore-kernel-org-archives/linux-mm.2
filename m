Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D877606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rTWjp+h5
Received: by kanga.kvack.org (Postfix)
	id 2B22A6B05B7; Wed,  4 Nov 2026 18:30:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263366B05B8; Wed,  4 Nov 2026 18:30:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106186B05B9; Wed,  4 Nov 2026 18:30:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF87D6B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:30:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F6BB1408AC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:42 +0000 (UTC)
X-FDA: 85399033524.23.61EC463
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 73869140011
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rTWjp+h5;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793835040;
	b=t+uYL/Koq6LYxltBWxzhNAHZmkX3GFPDcRmMozJ7Ln15IyKHuK79UOnzM65ow/nMsGO/M0
	BJUDK3DYRDEobpRDiRSOVgVqrqv4ZKmhUvpF4tu27+xwjzb7y19Y8Qt26lQIz+eMnSJQb/
	juEGdBpVM9c9tk22X+LSZv5sYxiU7yo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rTWjp+h5;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793835040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggbUr+h/DO3QjP9CyAwIHdrs2V3aX4kc9gb+lFsYkgc=;
	b=MubkcphoJG2xPZ8cGKL44RCi8luIb46oZynwYRfNURP1MtVyL3ATmQ1iJ15PNJF8OmgL0q
	kL6F6Vey7T1l/CKeGp7JjinmacDvbxWJdGepzvWxW4huD+cvdbuI+niE4Ha1D+ect1LijW
	74Nbbe7LBhpyfNg47dpnt9xgksMoMPY=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b0d63f60bcso18738437b3.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835039; x=1794439839; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ggbUr+h/DO3QjP9CyAwIHdrs2V3aX4kc9gb+lFsYkgc=;
        b=rTWjp+h5sZPGZnm2ob9Bi1S6ukPwhCt9uy5HQDUjXm47qeqMDqQzdWO1V8rSKv31yT
         1FNi0IlqmTVrpm9fmhkSQZIfJzN1IlLq5eSQn92YSGiVnHffAIWA3AbLLQ8SilE7PBm9
         n22scqA2Y55ZW00Z01DMw4vl+UNaiUzyVcabYxMwGH8zlm6TeMVZq5ozs7lv7DOmlZrc
         1K4c2u4joZBx1riC9F9ksIz1XaQOS1qNA3LumyXjJQyk8YMLiQUHQLkfRErrMDd/VQwh
         D9IMINV/mUkQ6jdlKfXeyoYd3fcNFYNPYNT9fFMd7r7gov+M94lPAkUMoHzVFZLUTOAS
         AwHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835039; x=1794439839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ggbUr+h/DO3QjP9CyAwIHdrs2V3aX4kc9gb+lFsYkgc=;
        b=oZyjxl5n61eThCzaMXyrlkWonVmap07cZ/dqeSEDwHHdHeGwXbMlaHGO8ggzdrPBc1
         B6nBDpLPpRu+jLcJy1E8oOM/Wy/zQX0/Tl4mIkpfzyniDcXPaSdeko9Rn1wHaVmA/sXM
         xVDv+WV4jVnfWlFbgu6HpHPgGhOzw+FbJ4aNIvWZS1hbLUEMQGnM91To1R3SNI+qveKI
         hJbPvire8+uXg+Hc+pod7TecFWlJy5xShsLQQQYDSwIwK/qZ1RskpV8VbTL/sdmL/GpO
         A7dm4CWQeztqqorJXmqV4nokncLl5/PffxgtpEXg0YfbKuw45fBM0QhKluk0bHsAd0Wu
         kXRQ==
X-Forwarded-Encrypted: i=1; AKwUvByKfNDCKUvUHwEYws1TBZEkBJR98Mv0i5oE8MDn4yJ6FmR7IvpV8HsA+t9BJ2H9R+tN7eLMBtdoSw==@kvack.org
X-Gm-Message-State: APuU4Z/Uup2VnoJMl/LQWg29EdwGgGt4W5uLaCmRjTbkw8DUi6gDWc7y
	3xn43ZaCXVAfb+6Ek7Mlq+ENm4GRvNz/nzsPl4HL3SlgywDTWA5NyHVe
X-Gm-Gg: AYBFou2u08p+fJw0uXfgYpa4lFcV8/Js8WOCbc135iivK/w6k1qxJlcOVGVmwuy1kh6
	jCkK3xOM3ne5awZcT9MmXWXGOC3MZcovUVDE2oqFd71kS0iCYbGFppgThfRFaJ7UR+qhM4sm8Mi
	hbnNiahYHBceQyCVN0B5WxMS8PGDnVjeHgqJptOTlmIsOsXpBWW1Fn4xS73ddTjEmxhy5Pbm18d
	VAP4zUO0/ELHmZ2j3CpUam4EWjURbi9prINlaGetD7s8J6Ufn4IJeCpKBm0Y6eV5lwlR2xb2KCM
	DOxMf42Xym8CyM45oom3jY39JVL9jocR4H5k3ncxAARvfJjL6Uk4+FTSRJjDHmmGPl0AFq+YCQl
	kDWDuJrqbXXXEdLjgeuWwGURxam50n48bbZ9k3ihnuuy+vEELcjjzpidD+wltzR3DCIdLYL2RkC
	NHDJqbqJYZN4da01tR31AXKxh+1gzvPlM/DfYi4mi6v8gv2ymsb0nC8scPTgYPqPOSsax6dntPS
	nvWWwsGLiT3ZlLbAq9YCyT7jNs2Jv3EoarKbnhCNy6VMMDvP78A+Cb2Lw8B+D4Bw6KIB1a2Z7of
	SoVQVWgUbD5zSt8CjzsFP01FmEi+Hqi52h5DrnJCY7/QdcNnjF1QBPsoQac=
X-Received: by 2002:a05:690c:660e:b0:8b0:ad5b:d487 with SMTP id 00721157ae682-8b2b6594f19mr132717817b3.2.1793835039309;
        Wed, 04 Nov 2026 15:30:39 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b309bd35c7sm29091047b3.44.2026.11.04.15.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:38 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v8 7/7] mm/memcontrol: restrict memory stock to leaf cgroups on v2
Date: Wed,  4 Nov 2026 15:30:28 -0800
Message-ID: <20261104233029.3282438-8-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 73869140011
X-Stat-Signature: miajhrmeudi764ruthr9o4jwaa5mnnmf
X-Rspam-User: 
X-HE-Tag: 1793835040-490198
X-HE-Meta: U2FsdGVkX19DyY4fKJkBqQfLEJm1OuoFmzjOJAOBpvd6jlNCHPJb8d5EtQO0YxywLWfmfKOWgyJP1UuXlffZvYZxACG91L39EOd+EXKUjeIesv+LpbFt9VbtD1oDKaPmjfICBhc7fVZMsp1mHjThg6ZKmSL9HNF+d4m//ynFbYOiEZlBVHN2V9XBXNCsKro9MwEytaBbOynyRDYvnJIaLfrr8rJ1FXIuKqCL6bpjuC38f2mYXx+zjn0OrRh+KD52YijXTlGpc/8QoP2M8R3czGw6/57M9YfC9PKJJWtAbWsOmbJ+EGIJti88BqlBEP8sK+tF90BL/Vpt/Wpo9fHJ6R4I4RD87x77g1uhngOgmQV683AjeEFAVaa2ahkiJ6io4hNAQ9tex4LsFcgXI+cqFSkn00fUXeOfrgiiDtsB+uy8PX/OCyQp7bNgVUixfUHsTXVNGeEO8uQBGvjfHVQphi3XK8jtrbZzLSzxAoesAgFdWvAt2M1E4o4rqBhJB2qgLzuoiX//Zvaw7DEkzh8G3SGm+2ohbvSleSWezdTnJmHkL2/dX3c/0K3MKHDukbErPC6hnSyk2zaJHS3rcw6l5737AuG45ZXgw0rvbNYeflMMftMZgk1MdkqLqslJutXMcXidFbU2J50Qxc/GGbFRvDMNBGSMdIHVcRUGtPvyMMoE56Eyx5JdqU9otc7Ya2SI6LqfEUiT3Kqk1UIWUua636d5yp3W4Y+/niFih3/lJUfv2xJIPPxTJUUa5kN3PEqziT3XzlsGLXNROHD9c+6n1qSrPwf4CTDdtnGnI1Btu9m03F0I1lJuEtkytWvy9n3QFicP9gH99Fi6BPGg5WsCVcre4rdqEO6Z9B2UzfuIVrpWaBDGL2asBIQULCyUXcWvL1EJBd/nXMO3PTyWQPRZlgjpwdtiaUlM/blYdnCpkR9CuRGfdise9fTcwtVoZnk/FNN6GeZa2JlOlFMBy4A
 aAQfzgx8
 Lk1DMZMhsrglRhO1Nqnx6dxcfwwe9G3tZBtOGld2dnjUdMw9Ad/uweeK0A4IAuJZ02qVfR/4nF128ovWViITrCQhjbBT3oQd6j/t8vOoNJxO5OVfcilR20eNwe59zEnO6aCVJYqLhZr0kJseWKGmX0tD/nSjVM2TVcvC6W76M/pVi2shLbFamKKBxJwWEdbFZYfPkEnWt4cYP5VwqhaRBy51p+nGbfE1Gu6uLCS3I79W5Js7AZpsv4hZx6WOdD5QfONSCzR/fV9RJD702mbMuumQWj5hj+kZrPVdtyvdWWEUotr+wZR0dM3hGUPBEaMH1DvjVzhm/F+VlyD9W+cWFDllVnZhWQE2p03ernufQQAfvNx0wBti/ezRPgPXtOn4UovcueGGjUY7AcZl9X4nNdFQo5bKLshhzMxoRazeBOC93rKgumRk7PwOYfLO2gBQQp4XsNhmCZ5lPW7VCEqQQQeGCdXRkZz2xqoYvnDX2O5rofph7HNN7GWtnp5Ztb9bbcy4N8yND6neWJ9PnKIVaRQPdBA1U7lhMvj2e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In the old memcg_stock world, non-leaf cgroups in cgroup v2 were never
directly charged (except for reparented objcgs), since processes can
only live in leaf cgroups. This meant that stocking was exclusive to
leaf cgroups.

In the new page_counter_stock world, stock belongs to each page_counter.
To get parity with vanilla stock, prevent stock from accumulating in
page_counters once they have children. This makes sure that stock does
not get stranded in the hierarchy, unable to be used by processes that
actually charge. When a parent becomes a leaf again, re-enable stock.

Prevent stock from accumulating in non-leaf page_counters in three ways:
1. Clear the parent's memory stock pointer to make sure the stock cannot
   get refilled in the future.
2. Schedule drains for non-isolated CPUs that stock the new parent.
3. CPUs that are not drained due to either isolation or racing with a
   refill are cleaned up lazily. The next local stock miss on that CPU
   scans for any stock that has been disabled, and will drain its stock.
   Note that this happens under the local stock lock, but this is rare.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c   | 28 ++++++++++++++++++++++++++++
 mm/page_counter.c |  8 +++++++-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aac987ebaab6f..a7549fd06d93e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2185,6 +2185,22 @@ static void schedule_stock_drain(struct page_counter_stock_pcp __percpu *stock,
 		clear_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags);
 }
 
+static void mem_cgroup_disable_stock(struct mem_cgroup *memcg)
+{
+	struct page_counter_stock_pcp __percpu *stock;
+	int cpu, curcpu;
+
+	stock = xchg(&memcg->memory.stock, NULL);
+	if (!stock)
+		return;
+
+	migrate_disable();
+	curcpu = smp_processor_id();
+	for_each_online_cpu(cpu)
+		schedule_stock_drain(stock, &memcg->css, cpu, curcpu);
+	migrate_enable();
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
@@ -4308,6 +4324,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 */
 	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg->private_id_objcg, GFP_KERNEL);
 
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && css->parent)
+		mem_cgroup_disable_stock(parent_mem_cgroup(memcg));
+
 	return 0;
 free_objcg:
 	for_each_node(nid) {
@@ -4360,6 +4379,15 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	drain_all_stock(memcg);
 
 	mem_cgroup_private_id_kill(memcg);
+
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+
+		if (parent && !css_is_dying(&parent->css) &&
+		    atomic_read(&parent->css.online_cnt) == 2 &&
+		    !mem_cgroup_is_root(parent))
+			WRITE_ONCE(parent->memory.stock, &memory_stock);
+	}
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
diff --git a/mm/page_counter.c b/mm/page_counter.c
index e1feb2bd1e225..7a3b7cea0ff94 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -158,6 +158,7 @@ static void page_counter_drain_stock(struct page_counter_stock_pcp *stock,
  * Consume the cached charge if enough nr_pages are present, otherwise return
  * failure. Also return failure for charge requests larger than
  * PAGE_COUNTER_STOCK_BATCH or if the local lock is already taken.
+ * Drain disabled cached counters while looking up the requested counter.
  */
 static bool page_counter_consume_stock(struct page_counter *counter,
 				       unsigned long nr_pages)
@@ -176,12 +177,17 @@ static bool page_counter_consume_stock(struct page_counter *counter,
 	for (i = 0; i < NR_PAGE_COUNTER_STOCK; i++) {
 		struct page_counter *cached = pcp_stock->cached[i];
 
+		/* Drain any stock that is disabled but hasn't drained yet */
+		if (cached && !READ_ONCE(cached->stock)) {
+			page_counter_drain_stock(pcp_stock, i);
+			continue;
+		}
 		if (counter != cached)
 			continue;
 
 		stock_pages = pcp_stock->nr_pages[i];
 		if (unlikely(stock_pages < nr_pages))
-			break;
+			continue;
 
 		stock_pages -= nr_pages;
 		WRITE_ONCE(pcp_stock->nr_pages[i], stock_pages);
-- 
2.53.0-Meta


