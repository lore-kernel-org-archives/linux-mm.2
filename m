Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A278F8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECA636B0095; Thu, 16 Apr 2026 05:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1A16B0096; Thu, 16 Apr 2026 05:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF1D6B0098; Thu, 16 Apr 2026 05:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDC0A6B0095
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:10:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72AEDE47C0
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:47 +0000 (UTC)
X-FDA: 84663848934.30.E0CE1FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE02C10000A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I4XXm2SO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+sTHRoUFH9gXlzIPRCP1CIP8oASHF6XrE0C6slZstjE=;
	b=65uOIDoAmH5wSP5BpGXSKXP8txm7PpHImEndclBGzcntkurb3T+JvXke56AQFSvIYmWrz/
	mcSgrys0nxyUpB9gBvxO325nw0AxihdjH4L57elfylSpLkGW0XIaECQB3ZDbldnWJ2Ieqs
	o2YxjQMu4fI85Vv5bXKrOnBXSUvshlE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I4XXm2SO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776330645; a=rsa-sha256;
	cv=none;
	b=KTIuSzsgbKf1cdXIUBmVvbLfoS2WMWBE3RzRnTW/Em3LlF9DkOOQNtKGWPojiIGki0J1G5
	7AqO52Xi+pCPTZKNEptsd0J4C7WvYd+nqe4uTEw8+9DbVuYAnUIJ8sQT3IbJWwUXIOr8HW
	2Co1Usr6M5gcYhNeWFAjHhmnJ3rNQGs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A65D943DE8;
	Thu, 16 Apr 2026 09:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FEBC2BCB6;
	Thu, 16 Apr 2026 09:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776330644;
	bh=b9Lg6+gdxq2yOwC2QG9xsnybmVAk9MArQJ5t2pzDwug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4XXm2SOm8tCAJZdc8cnqZau4KcBtMOyhZO3WR2iGbg05zVfsy29306JVaH/sdSNn
	 JpNu5O6d0rs6nih+5xTPjCDmy46Ii3NydgooZmNJI2mmampvPzPuAUIZ0c6YqCrZCj
	 5X7DkeiWOaWN9Kp5A3exH3O5NfXeqtOSdW/tMPrJRJ3LlQthomW9R4FRbSBqqjaUgc
	 6TG/+i6E9r30OY2jFZtxSPiGU8WGaKeEbYWcxW8BQl1m4u7D31h9Ng13w0HcnDbrf8
	 BhjE9BN7Giv2Kvqchf7AjjeRzPUq7sH2ljgploSXsHY8CklF1x0JK7apSUsdE5XAQM
	 8UQbDf5+XjvQg==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] mm/slab: make kfree_rcu_nolock() work with sheaves
Date: Thu, 16 Apr 2026 18:10:19 +0900
Message-ID: <20260416091022.36823-6-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260416091022.36823-1-harry@kernel.org>
References: <20260416091022.36823-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AE02C10000A
X-Stat-Signature: pntj38dfo1g6g8eddfc5uob4gzggqtmc
X-Rspam-User: 
X-HE-Tag: 1776330645-804325
X-HE-Meta: U2FsdGVkX18eZ7fk/XA2+pp9aWlE5gC5mixpO2BCxF25L1dzNUO/cu9xRYNq+YtYWfreUTuqWocT9FJBWV9T00l2KrdXpzO/LW8o2rakdJgkdOSwUsgc/CBBlOGCEc6VUwxXsaGCTg0oRE9Q1FpjR10FPU4Gj1RiIzzI3TXUNx50O8ZsO2vccKWbAslVKTrTocdLvRDVWdFYw2I1N+r8HaOs8tcV2NfO0Tx0RCTv/Dx1Q/jyVZaH9qwy+W1iPoTptxYw3iYQ9c9UoPMSXI0Z8kNyVoqjIkWp+9Ajt/f3QGWigIArjQfPV1bztGGN+FaSWfPCSX3ebUaxubWSpW+Wl8Lcg8AwRKe6kC9BUQa6TH6ojy+2szdsbkPZTotJn5RGsHgZn4mmmxBJgBucVucFjrbGcvoWqkplNlpgg5015rF9KJFQgRu/S4eMv1gGL2ignFqbKOBFZMPMUBpk7OpRx95gNzR+IbDM+c7RYI22rRn+tkN941CioQ8DLA55lDp7FSMpzDpjQZzB5NvV8H3OPOc09VZfVjfgRUg+elvlYuinxuY8kmTQ8cUMINOLCE/TuMXqqYPhy360k3DvKtZsPJ3HsWF6qrF6abHJny4gUS6+a9B6LV9DY7pCJp43lapnExZmblpJ5+OlrZytmevPl+5X5h3o0FPtgl2d16M86jSeirWA4GCYwrPJRS5i1fPukOivOk07HDo7dFk0CnnFStTTZvRjZaZxVog+wg/RnrLGRZPiflMeP7yj04nAO9x+eJrmwWQv9w9suPh5jTe+zqRaGJa/Fi8ov/kuzH8hM3YWWIWvBk35j/7OvO1g8WwVwENq9FugF9FGIU8j6xMMYS++IsE7OmxJ3LjX03uA4jR0Y2l9s77AhXCOZLOgYgk939Vu4s02iXJKxaznrp9LZ/fuBFv8rbpL3wr7Bt2rzvs2AUFkjMRC9VCxbzbdcdxWdRul8Zh95k8FfA28SIZ
 c0GjrHc3
 RJnA2JODUsdqA8N+u1ox13PVyWOhkN0WghoLgF5Hz1zeFHjSJLYHgN4kyJkap/nNWjif/I74flwb5bjBclsJZoy3WdH7Kgsk7oSQeoRULsrTnpd4tblPd7HwaJLuZy+HDrUUmt13hxAhSXE649ButIU48XS+nmwEQE6dEgXy6XBQwA48NcT0/hnD6358dyC5X/ccEMduT4uU++/lM5C9LMspaNmSNlKZL+e+bw46kwTlDFGCqj1bR7pHJoyHnlhlH9tSYhmOh89Q5RXxQSLbcNJAaSgqqED8tJq1J17RmuHKzTvwtNYG8aLfGAAlwGwc8212O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach kfree_rcu_sheaf() how to handle the !allow_spin case. Similar to
__pcs_replace_full_main(), try to get an empty sheaf from pcs->spare or
the barn, but don't add !allow_spin support for alloc_empty_sheaf() and
fail early instead.

Since call_rcu() does not support NMI contexts, kfree_rcu_sheaf() fails
when the rcu sheaf becomes full.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab.h        |  2 +-
 mm/slab_common.c |  7 +++----
 mm/slub.c        | 14 ++++++++++++--
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index ae2e990e8dc2..d7fd7626e9fe 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -409,7 +409,7 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
 }
 
-bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin);
 void flush_all_rcu_sheaves(void);
 void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 void defer_kvfree_rcu_barrier(void);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index e840956233dd..46a2bee1662b 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1716,7 +1716,7 @@ static void kfree_rcu_work(struct work_struct *work)
 		kvfree_rcu_list(head);
 }
 
-static bool kfree_rcu_sheaf(void *obj)
+static bool kfree_rcu_sheaf(void *obj, bool allow_spin)
 {
 	struct kmem_cache *s;
 	struct slab *slab;
@@ -1730,7 +1730,7 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	s = slab->slab_cache;
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
-		return __kfree_rcu_sheaf(s, obj);
+		return __kfree_rcu_sheaf(s, obj, allow_spin);
 
 	return false;
 }
@@ -2111,8 +2111,7 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr, bool allow_spin)
 				IS_ENABLED(CONFIG_DEBUG_KMEMLEAK)))
 		goto defer_free;
 
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
-			(allow_spin && kfree_rcu_sheaf(ptr)))
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr, allow_spin))
 		return;
 
 	// Queue the object but don't yet schedule the batch.
diff --git a/mm/slub.c b/mm/slub.c
index 6f658ec00751..d0db8d070570 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5895,7 +5895,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
  */
 static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
 
-bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *rcu_sheaf;
@@ -5933,7 +5933,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 			goto fail;
 		}
 
-		empty = barn_get_empty_sheaf(barn, true);
+		empty = barn_get_empty_sheaf(barn, allow_spin);
 
 		if (empty) {
 			pcs->rcu_free = empty;
@@ -5942,6 +5942,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
 		local_unlock(&s->cpu_sheaves->lock);
 
+		/* It's easier to fall back than trying harder with !allow_spin */
+		if (!allow_spin)
+			goto fail;
+
 		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
 
 		if (!empty)
@@ -5973,6 +5977,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
 		rcu_sheaf = NULL;
 	} else {
+		if (unlikely(!allow_spin)) {
+			/* call_rcu() cannot be called in an unknown context */
+			rcu_sheaf->size--;
+			local_unlock(&s->cpu_sheaves->lock);
+			goto fail;
+		}
 		pcs->rcu_free = NULL;
 		rcu_sheaf->node = numa_node_id();
 	}
-- 
2.43.0


