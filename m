Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0252ECD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 20:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EACA6B00C5; Mon, 11 May 2026 16:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C24E6B00C6; Mon, 11 May 2026 16:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FF306B00C9; Mon, 11 May 2026 16:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2F86B00C5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 008621C015E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:29:23 +0000 (UTC)
X-FDA: 84756279048.03.2CDC698
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf05.hostedemail.com (Postfix) with ESMTP id 198C7100002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:29:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778531362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tAiH9diBI7J7uivFoRqoRbqhEHHHvTGkdnmEXAd5bXU=;
	b=AFIK9GaJGTZ/+ds/o+SMRFuw0yRskjXNj4lvy522WkE2U3jPZ4UGWnB1z04WqMLOQ7jkgR
	ufCnnGWgRBjHcLbaAYduSGVNITeE+JOyBWuU6VOAf3fIHYIcY98aYSMKmPX6L2JIfuGSNC
	XT4vs0zr62Dzhq7L1YTTq7R41hBb7+k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778531362; a=rsa-sha256;
	cv=none;
	b=aoEUAwUvUghq7sj3HdqPnUwJPrmcemDJhzUuxPSjnSVOeLQShG28mJ8s8zc40ghPEy7Pl3
	04ZX5H0nkEVOj/3POTjmEbFZVBTWMmufLyeZrwGeEg+doGcucImJ9yu07fA6m/rKLjhzdI
	CToPlxSTrw30ItL1uJk/OXke+RgcpPQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 62DDB3ECB2;
	Mon, 11 May 2026 20:29:17 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 7/8] mm: percpu: per-node kmem accounting using local credit
Date: Mon, 11 May 2026 22:20:42 +0200
Message-ID: <20260511202136.330358-8-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260511202136.330358-1-alex@ghiti.fr>
References: <20260511202136.330358-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGZq0GkJau6RWVth2AkA6mXp5hevURRivnwJLaOUMsROukueZFeGriViT3+cCjdcQdQP0MXVJyz1fLtz5XFi7fYpUSG4G6HGJNwB7Iq+AffJ+iN70qPoWx4sPkTvS8S8edtNse4haP6xRwCWHJvcVy7zsnDElyg9ELyVKHPrzVc71knPq23qOqkwc4KIrg5BHucIt4/5JbUi95cV8eeMKs6lPZKscraThdxjN0ea9JVj3y6puOv/mj1bfUb5Bpth59ONuYJuZ08jwh3vLgdvYEWkwTPa3c1OOv3+xRvJspVD1HTOqkt57ReSG7Uxn9/R/VsgPJlS+GPzNYXtlpAG3mkrCAYVlQ1QLzc8PgqvLuSY/YkZhVxydEWjxIqmFuCf7lJAlhvSGQ8cfvdIDB7OU/HYVxTLOpB4JBfIt1eOof1Bdl5hHzsJ0ydLr/d7anp0g74eJqpy3sBXAJcopo2J1Otn7Rwa/xEdKRJx35MWolIDA0b64eBq37Rnd7MW+Ig66uhETjVl+B0j7xrMVx1N3dJJB1+ZxUEgyUIxUtOGnHEe2NAlYicb/tl+XECjEbEH/8kNJ4Di+XoiwwIIvIbhVUEqIAmqesGqMNXreRm0AvrwbAXYjre+Fz0ZtK7rtmNm5RRQDPwS95sy4JLDFpO4q7b3j0Pf/UQuowlA+wnxPrjmA
X-GND-State: clean
X-GND-Score: -100
X-Rspam-User: 
X-Rspamd-Queue-Id: 198C7100002
X-Rspamd-Server: rspam04
X-Stat-Signature: mappaa4bx96nzmp7cit77dpzi3h78tee
X-HE-Tag: 1778531361-108239
X-HE-Meta: U2FsdGVkX1/ILto/Q2yTcedGYYTSq9n/5MJ5lflxUO2KuV+/+ZkV6ksBa3//nbOqGOaimm5uQPjcIlZdsdJ11XBlturIfQ5raLVhR/afE+4CexU2vurtzwva3cr0qCzqkduXyu4Ub2I/nLII4yXqm+Xz+Xa/z/8nQg86+lNCFmw1sonLcr5HP+1nsT6ezGTfHqAJ0tp8+6U+By69uAmuAQdXQqR5LdvOxxCEMIjuoX0DIkx9rsuQEBXaQt/2AQippHnxkkPMfWUHCQnQPUqqNgA6TYY5v5WENxzeEbMcW0kTpCGBmO0fHN7g19hnf/co/LgcRVwPeKUV+S4ZOHsk+eBmFEV7BSMn98wB22nqlGF68bQlBIDhBgAXYnrrhgO1OrGgdCkecv/fl4fICQsgIyTHM7w2Qb4u4H4MCm4O7WuAh0ec0I0xrNfqZrmbDRvuQjqnr8fnyBfr2nc8OIK4KT6NO1m3nkc23RWgV4RyDMi8jhO4BX0MAH7iVtNTcMEGU5KD9p04kOHVye46/KAKT3HxGX5eAWr/4DbvVh8KW42gU+LUtqyKBHdQZUFgSumeL2QLpIvEC3wIt5MNzzdmu0LjkQxfo4JYAgKDD+wEGy4jxMQ304FWWR4fC0ptlx4eHvJ98khILA/ruR/sdaAc5ujoNTccVDE0nEbGVxkfETuQ1yYkyZl2m6tQiDwIgqm6dJnRGtQkjvYAns73M2XZwDzyXxKecAEa2pgzIO3vbCt0VhPtHpePhrW0eIc/G6r8OsMwOWoL+IdWl+d1TumwuJJGFoCwJb9ObgXumlz01HMeHCb7mFetf0D0eGU4xHKil0ThaSHQvMoEwSRLO4y0fhL2geBa75R1cVUGI5HRWW4UCUfWqIi9qPseuLYoF0md63GrmCH0nNcESb/b61Zrf9zMlOXBTPDpMhq8JrfVwoyRiZ3eWMSKg9FqGNtPBLLbzSG/rDJrBvr3N3GRAFN
 irj7Xvah
 71jPeSfiw2rEzxQS61W0S4lfAMaee71GTOGIPDtdIJiA7gowyT1Y57bs1epfe4owalSrNKWJG7S2/vrI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the memcg charging is decoupled from the kmem accounting, we
can't use obj_stock to handle the percpu accounting because our
precharged pages may get drained. That's a problem because we suppose
we have enough charged pages in pcpu_memcg_post_alloc_hook() and we cannot
charge more pages here because it may fail and would defeat the purpose of
the precharge.

So instead of using obj_stock, use a local per-node credit that fills
the same purpose whose surplus eventually gets refilled into the
stock.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/percpu.c | 88 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 76 insertions(+), 12 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 7c67dc2e4878..64b327fe3c26 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1614,6 +1614,16 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 }
 
 #ifdef CONFIG_MEMCG
+static unsigned int pcpu_memcg_nr_precharge_pages(size_t size)
+{
+	size_t total = pcpu_obj_total_size(size);
+
+	if (total < PAGE_SIZE)
+		return num_possible_nodes();
+
+	return PAGE_ALIGN(total) >> PAGE_SHIFT;
+}
+
 static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 				      struct obj_cgroup **objcgp)
 {
@@ -1626,8 +1636,7 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
-	if (obj_cgroup_precharge(objcg, gfp,
-				 PAGE_ALIGN(pcpu_obj_total_size(size)) >> PAGE_SHIFT))
+	if (obj_cgroup_precharge(objcg, gfp, pcpu_memcg_nr_precharge_pages(size)))
 		return false;
 
 	*objcgp = objcg;
@@ -1642,29 +1651,68 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		return;
 
 	if (likely(chunk && chunk->obj_exts)) {
-		size_t total = pcpu_obj_total_size(size);
-		size_t remainder = PAGE_ALIGN(total) - total;
+		unsigned int nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+		unsigned int precharge_pages = pcpu_memcg_nr_precharge_pages(size);
+		unsigned int pages_used = 0;
+		unsigned int node_credit[MAX_NUMNODES] = { 0 };
+		unsigned int cpu;
+		int nid;
 
 		obj_cgroup_get(objcg);
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				total);
+				pcpu_obj_total_size(size));
 		rcu_read_unlock();
 
-		obj_cgroup_account_kmem(objcg, PAGE_ALIGN(total) >> PAGE_SHIFT);
-		if (remainder)
-			obj_cgroup_uncharge(objcg, remainder);
+		for_each_possible_cpu(cpu) {
+			unsigned int i;
+
+			for (i = 0; i < nr_pages; i++) {
+				void *addr = (void *)pcpu_chunk_addr(chunk, cpu,
+								     PFN_DOWN(off) + i);
+				size_t page_sz = i < nr_pages - 1 ?
+					PAGE_SIZE : size - (nr_pages - 1) * PAGE_SIZE;
+
+				nid = page_to_nid(pcpu_addr_to_page(addr));
+
+				if (node_credit[nid] < page_sz) {
+					struct obj_cgroup *nid_objcg;
+
+					nid_objcg = obj_cgroup_get_nid(objcg, nid);
+					obj_cgroup_account_kmem(nid_objcg, 1);
+					node_credit[nid] += PAGE_SIZE;
+					pages_used++;
+				}
+
+				node_credit[nid] -= page_sz;
+			}
+		}
+
+		/* Return unused precharged pages */
+		if (pages_used < precharge_pages)
+			obj_cgroup_unprecharge(objcg, precharge_pages - pages_used);
+
+		/* Put leftover per-node credit into stock */
+		for_each_online_node(nid) {
+			if (node_credit[nid] > 0) {
+				struct obj_cgroup *nid_objcg;
+
+				nid_objcg = obj_cgroup_get_nid(objcg, nid);
+				obj_cgroup_uncharge(nid_objcg, node_credit[nid]);
+			}
+		}
 	} else {
-		obj_cgroup_unprecharge(objcg,
-				       PAGE_ALIGN(pcpu_obj_total_size(size)) >> PAGE_SHIFT);
+		obj_cgroup_unprecharge(objcg, pcpu_memcg_nr_precharge_pages(size));
 	}
 }
 
 static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 {
+	unsigned int nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	struct obj_cgroup *objcg;
+	unsigned int cpu;
 
 	if (unlikely(!chunk->obj_exts))
 		return;
@@ -1674,13 +1722,29 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 		return;
 	chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = NULL;
 
-	obj_cgroup_uncharge(objcg, pcpu_obj_total_size(size));
-
 	rcu_read_lock();
 	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
 			-pcpu_obj_total_size(size));
 	rcu_read_unlock();
 
+	for_each_possible_cpu(cpu) {
+		unsigned int i;
+
+		for (i = 0; i < nr_pages; i++) {
+			void *addr = (void *)pcpu_chunk_addr(chunk, cpu,
+							     PFN_DOWN(off) + i);
+			struct obj_cgroup *nid_objcg;
+			int nid;
+			size_t unc;
+
+			nid = page_to_nid(pcpu_addr_to_page(addr));
+			nid_objcg = obj_cgroup_get_nid(objcg, nid);
+			unc = i < nr_pages - 1 ?
+				PAGE_SIZE : size - (nr_pages - 1) * PAGE_SIZE;
+			obj_cgroup_uncharge(nid_objcg, unc);
+		}
+	}
+
 	obj_cgroup_put(objcg);
 }
 
-- 
2.54.0


