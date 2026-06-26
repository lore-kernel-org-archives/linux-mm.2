Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78E23CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D4C6B0110; Fri, 26 Jun 2026 06:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206116B0114; Fri, 26 Jun 2026 06:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1422C6B0115; Fri, 26 Jun 2026 06:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E71BA6B0110
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:34:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 775381A03E2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:34:10 +0000 (UTC)
X-FDA: 84921703860.08.C249544
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf02.hostedemail.com (Postfix) with ESMTP id AB96680017
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:34:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782470048;
	b=JlLSzse0B4jUfS4+aqnNDX7PG4Jrnjye06rzRsRTb0DO7A+d9xTprua12G9FBPOa6JmUyM
	+3WyQ9QxfnhuYDFi1kwZ8OnlwbU57taLbMnECSEsBViPx5jiW8MW1y9WiiWXSzDwxM8F+W
	g1DS/T9XVCfiYw0aUy8xNxenDHiwKm8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782470048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yssedXzlapOOd0igp+sjs1tPmdImP/TdG96kJqU5CHg=;
	b=XItnES+4gxZCtk09Xjk0byHeG6fPgyFeKpiIGkh5UVHW/Zb9kEEru0QJn0E8Pj73hUPChi
	2rEj+n6ajktwRpfZn/H7vF3jbxLZxVrMoDj22SIMowWk9LuORAaGW1/cEyyCII9mIXMTSF
	SzKS5K5F64H4wUJ7+T22f8QJXAaE2tc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 35CA53EC65;
	Fri, 26 Jun 2026 10:34:01 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>
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
Subject: [PATCH v2 9/9] mm: zswap: per-node kmem accounting for zswap/zsmalloc
Date: Fri, 26 Jun 2026 12:20:58 +0200
Message-ID: <20260626102358.1603618-10-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102358.1603618-1-alex@ghiti.fr>
References: <20260626102358.1603618-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTG3h5G6t3FC2isZZGU/PT2pn+1paeiWOdgcvbFuD+1BKVsNu4saVvfuzt75aavMMcGzuV3jTmfiGGFoaK1beSakgFC7iEno5M78bKzolba0CnxXwUui8VjRa1yK6+WhcZ/aKsvWtdNWYdQgHkYc+meTm6yjPpGSSCaQ/cUZsVZjasBVRYNS5HCE4R0qp9cJZuPpvf7jxHkgnY4LdvAc8t5qsLJYCXTJKl501kxTLSYYWKNE5ufQVuz5upqkJLG0shbqvbT6RN7ik/pC7OXlu/GwZnn7PAXBL5PaAIvFrTlXRqOeQUW0BAvIJCUnr8re/L97syiX1fL4lPXMhmn2cVwrKlRN7SgVe3oX12fxoLpgCMiakunAF0nk7ZKlp4KV7lAyV9Av1/BDD7qQI0UD+tGTHnWIjwfXgb3VWkWC1vfMSQSTfjPuLaaFznyiH01XFnRH/+8/Il79IfAYhV813teP6pqb0tLfCzfBb2rseQ3ItD5QjdM52zAZrfUJEG8f6stkCHzzDO/uyzLPyjJJk5WnPzwnSPb2ym2c9iPwjEyOx/0VVV1BM2xGJP8TbWaMP7ZbXKW/HZJXEu0230c32PzvnJr1ezYLZ+XbYak7O1/XIQ4uGlicjMdcGOoJ8d+X7NurrBJkszb5Uu1NqYfo1vuyuyilJYRKxgyCO0VYmTE4NA
X-Rspam-User: 
X-Stat-Signature: j76o7gwpb5wk8o67477qi7j79bq3pbqi
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AB96680017
X-HE-Tag: 1782470048-464095
X-HE-Meta: U2FsdGVkX182jqfrQk6LbxTEAjLx4GTT6W1aPhpoiyLJG+0lZId21qjSEg/iKC5+JqxWtVoXIjf3hg5UOsYC2JuLDCOozsOCpYGp0sJj5vbvSw+VNsr9LrsTEYU+quc5W7d931DiwAbv7SFkbzRsoxnjGlM1Puqhc4rkji+ujzhwMGI6a5exrSVZ3+dq3RKd+8sIe7BabmWKqcoiVsiBBT1NEcCiR9wp+cxQEd99znJsW6JQRJ1kaOYvEth+bKr0ZB9TuTZUaheTHhs/PWL1jfI9p60w6VwhkGe8noU3qwRRxsOHxVAscoblE/Rve3fz5tYEtbQdgwpPIkZyyKEI6kmT/PTGhpKH5gnKXS7+/1fyRnu6OKnwhHfoaJRMTpnSwug/ZvyQ8iOcAprqAX8xNP8HG29Yx+2cXxZNDkuHQUmjX85y1R3lsaVqGkYkzCFGY1u2Y1szaHQkTs6wnWIOm81EuFeKy/eWijREeAUY5PEKzBMPynwPLX1esi/R1R+oqqEv2sAgjLMXQTJ737gUVRHDpILW3r/flVUUK+UcTFCTRPYxDkXQhez04fsAurIWVvvi2BbIxnDq4d1cmJeV3JG33I7bGgQlym8g5WCGYW++cWxBDQU33/4IhCvy3aJLEfv0jernnWwvU/uCSuCZQu0ZizVezRqFFoTBXorgASjySPKiQ68P0bDMgcJHw6JcKRNAHi+nikxoQtWc08x1VZr1k2shn4FDwruJOoBnqJCjye7GX2rmRlL4VBKMYiq4zGK/JJZ9RABlJsk6ZS7Ksbjy0Be1l5n05muM2gpgMhxbCdjq5OkVWRIqb69KfJYot+/HXvv5Co811QT1RANz9jfEiYzeIVYt7iJhJ7rb/6bJjmdo/4WeIxNWXPvioKgqzp6Ei7M3+0TQ1fGSGp9fVNfcr2aiSiwRXL7C/U9FO4cgok3W2q7RTMyBHBrdo9TLcGVCU7NObDrJ6pfOM9i
 Es20hvX2
 CmRVx553e0L/cq9MoncsN+IcA/aCiptzXerscFrjVhSxNEB8sHx//xaX3Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update zswap and zsmalloc to use per-node obj_cgroup for kmem
accounting, attributing compressed page charges to the correct
NUMA node.

But actually, this is incomplete because it does not correctly account
for entries that straddle pages, those pages being possibly on 2 different
nodes.

This will be correctly handled by Joshua in a different series [1].

Link: https://lore.kernel.org/linux-mm/20260311195153.4013476-1-joshua.hahnjy@gmail.com/ [1]
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/zsmalloc.h |  2 ++
 mm/zsmalloc.c            | 11 +++++++++++
 mm/zswap.c               | 19 ++++++++++++++++++-
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 478410c880b1..30427f3fe232 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -50,6 +50,8 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len);
 
+int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle);
+
 extern const struct movable_operations zsmalloc_mops;
 
 #endif
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 83f5820c45f9..17f7403ebe77 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1380,6 +1380,17 @@ static void obj_free(int class_size, unsigned long obj)
 	mod_zspage_inuse(zspage, -1);
 }
 
+int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle)
+{
+	unsigned long obj;
+	struct zpdesc *zpdesc;
+
+	obj = handle_to_obj(handle);
+	obj_to_zpdesc(obj, &zpdesc);
+	return page_to_nid(zpdesc_page(zpdesc));
+}
+EXPORT_SYMBOL(zs_handle_to_nid);
+
 void zs_free(struct zs_pool *pool, unsigned long handle)
 {
 	struct zspage *zspage;
diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..466c6a3f4ef3 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1438,7 +1438,24 @@ static bool zswap_store_page(struct page *page,
 	 */
 	zswap_pool_get(pool);
 	if (objcg) {
-		obj_cgroup_get(objcg);
+		struct obj_cgroup *nid_objcg;
+		int nid = zs_handle_to_nid(pool->zs_pool, entry->handle);
+
+		/*
+		 * obj_cgroup_nid() returns a borrowed RCU pointer (no
+		 * reference), so the returned per-node objcg may be freed
+		 * (kfree_rcu) before we use it. Pin it with a tryget inside a
+		 * single rcu section; if it is already dying, fall back to the
+		 * folio objcg (held by the caller) so the charge still lands on
+		 * the right memcg, just without per-node attribution.
+		 */
+		rcu_read_lock();
+		nid_objcg = obj_cgroup_nid(objcg, nid);
+		if (nid_objcg && obj_cgroup_tryget(nid_objcg))
+			objcg = nid_objcg;
+		else
+			obj_cgroup_get(objcg);
+		rcu_read_unlock();
 		obj_cgroup_charge_zswap(objcg, entry->length);
 	}
 	atomic_long_inc(&zswap_stored_pages);
-- 
2.54.0


