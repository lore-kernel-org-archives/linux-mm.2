Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BACEECDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8BB6B00B2; Fri, 26 Jun 2026 06:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757FA6B00B6; Fri, 26 Jun 2026 06:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F99D6B00B7; Fri, 26 Jun 2026 06:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 284646B00B2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:14:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B14FE1C2C6E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:14:25 +0000 (UTC)
X-FDA: 84921654090.15.BE1BB12
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf06.hostedemail.com (Postfix) with ESMTP id D8AEE180006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:14:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782468864;
	b=cwGw3rgoJyolDluE3KpN5NoqXmtXLcMJvgxTbIslPmQvQbiRoUviNzCJyTA7o4+zAdIkhq
	gydE9OoaDiZeSn/vEylXIw6dQhJe1UWrNZVq/PAFc8DIi1BV645YMvcwNIU60+eFjNi6CN
	OKudLU88nQtc1zishqSYX2IruWb5BkI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782468864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zNmutVevFROVWVFlOe8iAyV3H9Xxv4R/Io9gPw1gnEE=;
	b=UsO4u9HqFWfMOKaNbTnTu3p6kXPWLHkLoKMsts6jtAL4crMexQEt+y+NAdRmCFVllhKA7g
	Jh6zA+cAT3vzbJMmJ6Yne4KWlBzDChu2aVgwE/HNCX5WapoW8vzPbuQYnNlBwxvyQINKpT
	yEeKgyrgqcq6sZX3u0TNsqzgsXoAeqY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 8E7A61F749;
	Fri, 26 Jun 2026 10:14:18 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH v2 4/9] mm: percpu: Split memcg charging and kmem accounting
Date: Fri, 26 Jun 2026 12:09:31 +0200
Message-ID: <20260626101356.1599643-5-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626101356.1599643-1-alex@ghiti.fr>
References: <20260626101356.1599643-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEBI1JGbXlpiiDp14fkAsKfAN5fPZBM2Ab7MYJnFM3+SveTMVF6Fpqo1pIn6X+1iOtVOzIUV5Y0lYysvg8wUhEu6iechcA9ZS1suPyZBWm40kuX54tSMCypoKaVvhov2zRyofq7gzsMmi381Aww594HETMja5HFS74ld7NppEkUPFcpepMRwyMI5cA7mkGe/vhPQABef+NqYfMk9kxiJ6/r8++B4sCphBOA9I/gZUpooOC/H1BTNf8jBjGO3awTrxngcQpM8nhCbLDXRzq4VxFUibvIrp2s4IHqQiAqPfb6IAcP9PvJXxAvxWk/3kLhKU6wNMf25eg1lrylx+omoElrm+9k8AUXNsR9LuEljwhEZO5CZepnqnpconiTMzNoapXVpGqxlrGc4VEc5I7pJ4yiBGbRopN6X5l2gtBr/ckGNdX1ylQYWPDI7+nHCzZPMrd9grLmFEcq02EPr1NwjOUMhjNWxIn4dbhZimY4bviivQAoMQQQM+BpnEtrGN6S1r6NT5bRvjpbeFaT9ipEPOcag6CQhcOjMiMQEM0w/0mJUhRQDQVo4mhfV/i+bjV5vX4UyTkumQBH9kjYid93rIWA1Y67gyChPb208L75eKqxbKvPnXqa7qKsTjm352I7LBuLtVQttWyskJ/iauGmBBD4n6WoHXgV6vZn6KDELXTrgg
X-Rspam-User: 
X-Stat-Signature: maapazn7wd1w1t177fx1uqifjwnraq7t
X-Rspamd-Queue-Id: D8AEE180006
X-Rspamd-Server: rspam06
X-HE-Tag: 1782468863-580717
X-HE-Meta: U2FsdGVkX18BemUGrnEoC38TA2lz4hGmU+4nL3zBIzuvpVX9Eiuo4FFLC4JVzFHdw5QJ3IAu8FqP41XlKpb0rVF1H09gXBdYdUePEj7t6rVIdRxqKWILq/G/e5SYhAnio4U8VkIzqz7YcAJxqWe+sxKDYJKGpupEOGBYKmXSJ9BdZL2Y7d/p1yN7wUHIxUMUMfvEHlkPFBm8tXyNiXjRLWFgl6FJndHO0r7diyFiAYdpyT/CK8C/99lXidqTsKtmdJdNE0P6MYWjRK74//TCVQ6+1XiOnYCQInyGPQhJjZzehR3309SmPu6jAdqdlDjqmlYBdpOwXbzxx0IEuVPauRLDxfOAhf39bHXox271jWDSp5NxlImaz8jF2/8I7ExMPXGd3V2+VHCwZE22oeRGKUOEPKCt8pYbUxk9gWSBj2IgnPU5qBIpi4dlg6Q945iCw1XskyQ86IwpdOGvX9zcwk19YJDMiYtDeJS1uYzcJvKNyqIuzadb7qCtiyKUDmPyNNRWuN/k4NZe8cQKao+456BRZ5fOegcjUTm1lWonqdZ9g+pykec7L4o+rpZWO+S8Ew4yXqh4KJipjjTLYbXxZ5mdCwlvW73SbIAjn8IsrzYYqL/KzJ7Qo8w0Y7Az24Z3vK1Y9mXXW3aAuc2GKb5GxCFhnHUDMizfWKLuOlDjYyychq8H4rwCo1Ew+tM/XuvW4C89sFC29IoKBJ0lyGutFoC29K/0UAXE08hSniyiqZSpUqPnB7tZMdcE0XbOyJp8sRNEiJTsMlcwI0XqvwOGdWTq4XhfGnTGktgIEXpbEFKnSvoxwQjhGkO8OqeP1LR7ppN8dMtDAOhcKlZUeBSm7A7VokgN9JqMGTAzBcBVlNB9kiwtUWxLVjB6/pg5/30EBqtj4EYHXUToIf7haOA9zh7mc/AFjcX5X4dUa0ArGZleT6z+pPJddUnEohIUk8Inku3ragE/3kc3wP+ajHT
 4NOnny3O
 WoD1N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is preparatory patch for upcoming per-memcg-per-node kmem
accounting.

Percpu allocations charge memory before knowing which NUMA nodes the
pages will land on. So we need to decouple the memcg charging from the
kmem accounting:

1. In the pre-alloc hook, obj_cgroup_precharge() reserves pages for
   memcg limit enforcement without updating kmem stats.
2. In the post-alloc hook, obj_cgroup_account_kmem() accounts kmem
   and places the sub-page remainder into the obj stock after the
   allocation succeeds.

Because of that decoupling, we must not rely on the stock in the
precharge function and always charge the necessary pages that will
be accounted after the allocations happened. That means we may
temporarily overcharge the memcg but the obj_stock draining will get
things back to normal.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/memcontrol.h |  4 +++
 mm/memcontrol.c            | 50 ++++++++++++++++++++++++++++++++++++++
 mm/percpu.c                | 15 +++++++++---
 3 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..8f419ee54510 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1704,6 +1704,10 @@ static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
+int obj_cgroup_precharge(struct obj_cgroup *objcg, gfp_t gfp,
+			 unsigned int nr_pages);
+void obj_cgroup_unprecharge(struct obj_cgroup *objcg, unsigned int nr_pages);
+void obj_cgroup_account_kmem(struct obj_cgroup *objcg, unsigned int nr_pages);
 
 extern struct static_key_false memcg_bpf_enabled_key;
 static inline bool memcg_bpf_enabled(void)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3bcc20e72914..480fba12a217 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3536,6 +3536,56 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 	refill_obj_stock(objcg, size, true);
 }
 
+/*
+ * obj_cgroup_account_kmem - account KMEM for nr_pages
+ *
+ * Called after obj_cgroup_precharge() when the allocation succeeds.
+ * Accounts KMEM for nr_pages on the objcg's node.
+ */
+void obj_cgroup_account_kmem(struct obj_cgroup *objcg, unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	account_kmem_nmi_safe(memcg, nr_pages);
+	memcg1_account_kmem(memcg, nr_pages);
+	rcu_read_unlock();
+}
+
+/*
+ * obj_cgroup_precharge - reserve pages without KMEM accounting
+ *
+ * Reserves page counter credits for limit enforcement. Does not update
+ * KMEM stats or the per-CPU obj stock, because precharge decouples
+ * the page counter charge from KMEM accounting (which happens later
+ * per-node via obj_cgroup_account_kmem).
+ *
+ * On failure, use obj_cgroup_unprecharge() to release the reservation.
+ */
+int obj_cgroup_precharge(struct obj_cgroup *objcg, gfp_t gfp,
+			 unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	css_put(&memcg->css);
+
+	return ret;
+}
+
+void obj_cgroup_unprecharge(struct obj_cgroup *objcg, unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
+	css_put(&memcg->css);
+}
+
 static inline size_t obj_full_size(struct kmem_cache *s)
 {
 	/*
diff --git a/mm/percpu.c b/mm/percpu.c
index b0676b8054ed..01c87e39d366 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1625,7 +1625,8 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
-	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
+	if (obj_cgroup_precharge(objcg, gfp,
+				 PAGE_ALIGN(pcpu_obj_full_size(size)) >> PAGE_SHIFT))
 		return false;
 
 	*objcgp = objcg;
@@ -1640,15 +1641,23 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		return;
 
 	if (likely(chunk && chunk->obj_exts)) {
+		size_t total = pcpu_obj_full_size(size);
+		size_t remainder = PAGE_ALIGN(total) - total;
+
 		obj_cgroup_get(objcg);
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				pcpu_obj_full_size(size));
+				total);
 		rcu_read_unlock();
+
+		obj_cgroup_account_kmem(objcg, PAGE_ALIGN(total) >> PAGE_SHIFT);
+		if (remainder)
+			obj_cgroup_uncharge(objcg, remainder);
 	} else {
-		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
+		obj_cgroup_unprecharge(objcg,
+				       PAGE_ALIGN(pcpu_obj_full_size(size)) >> PAGE_SHIFT);
 	}
 }
 
-- 
2.54.0


