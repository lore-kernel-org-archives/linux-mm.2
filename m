Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B695260A6F53
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m0vzLjqY
Received: by kanga.kvack.org (Postfix)
	id BD6006B05B3; Tue,  3 Nov 2026 09:48:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86D16B05B4; Tue,  3 Nov 2026 09:48:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28026B05B5; Tue,  3 Nov 2026 09:48:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D58C6B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:48:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB4D540473
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:11 +0000 (UTC)
X-FDA: 85394087982.12.BD61B07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1646BA0008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0vzLjqY;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717290;
	b=hD0E8YiMelhpvInkpJdswcUI6UfRfT4GiEglitx4gNbbYgE4gbdktxoOGjkpIx5kzekzsc
	Ry8z+QkrDkPjiLnXYcpy27gf2vMXeCgeQHD2SqmhzZcbsOp0lyTMjyk+jySmq68fxTdoth
	kwsYFAiEbdzg0GNLyjY5x7m1j2SlCik=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0vzLjqY;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRYCAHukSEy8Nlux487+3bB9VsozJiJ3Md/iLi5A+o0=;
	b=r+cow/zPwsv4d+MxXxeLHhVV314mmqDC1QXDSRCD0Cjx8kDVBKSBicFYiECIp/2rTdfcvx
	p+lfyjvNhMsm76SS/XBLp1TJWWdCPe/rd06l2OcjMiAvp8s8s7f7+vIuo8DXzpD0MSZDPi
	41W8mGnOF3aJSZQORVFRxi8RalRaUyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BB33601FF;
	Tue,  3 Nov 2026 14:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DC81F00A1C;
	Tue,  3 Nov 2026 14:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717289;
	bh=TRYCAHukSEy8Nlux487+3bB9VsozJiJ3Md/iLi5A+o0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m0vzLjqYTpK1EbN/fTydMgFoS/z5nHZTsYBZsw1T5XJ9ViV+aI78cI5RkK+ePGR9T
	 1WWI9HMrFw6Sk1fwUk7QRcj84+uVSBjV98QC5uh7BUTDiHGCcfGwiT9bt6mxgeRedb
	 /hSsW/1uQTn2YAE1FIS6dxtPDQPD8N3pTFlw8gBwHeO4Ox3pMMUxDbEIhrKWDAAdLG
	 WscNxw671ntJftgHHJy39wS0Ii6wzberbnaK5b5f0eElTUQ54l88hQnN82ZpW8+SWJ
	 uECJS4SaGCainqrTUrVMh3t2VXvcc35Qk0mG7C/vz4QPAM3nRc6L9yj7/WiPwWGF7e
	 Z1inegJzbVciA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Tue, 03 Nov 2026 14:47:50 +0000
Subject: [PATCH for-next-fixes v2 1/5] mm/memcontrol: defer
 obj_cgroup_release() to irq_work
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-kmalloc-nolock-fixes-v2-1-19167cfe4779@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
X-Mailer: b4 0.16.0
X-Stat-Signature: yeuyopr51or7rjti1hc1hp7zpc4tjbta
X-Rspamd-Queue-Id: 1646BA0008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793717289-597464
X-HE-Meta: U2FsdGVkX189I7mHz5McRaOzSS2mDNTbdWGUaUeOBb2Iu4QzKeivi3Ix2HXUEDMRUdOLAQ3G78EwyDlFBV37R2hCVRV4/lOz8s2Rv8VSDzkayZZndARml42RNqSbdjeclyKLsNd6M4e5eqHFKDIfGq0xOrWN17GB9+j9WkjRVQAKq4OLB+bzMorXmj5/xAkH4WjJFI3eNOgBw91wxSTDBqrF7jpUOXKE4+U9+UOJPVAzHuh/HbgG/1dsOFGroKaixSib2VtEbDXekta+HIzqU67poa3qTJLvQP2SwDQG9qoFHHNvt2GIReK6+suCkxMU+yEKJPPTt4JbPxNbQzSgWdf4Zqouo6383yLVlsqWKDZRvMan0Vx2NkMapWrvN/jFkxdDrzvQ4dlxfHoy1NYrsMBX94aVf8rOaBebnodKWMC6oVAzGqklgUAN/qRkf9k7DgHgF2j6AAJle8VMx29/19DvheRHyUIRhrnaG9kokxNCvJrNqd+Cse16dDgpqy0slFhwhM+Z193jK1+gEJqXLsxpZdrbw9mWTEweS8L+ECCI/rAJQxFEFMgJr/PnwdT+iCh8Np9gFRVnCs7OjMsxqvL+bLmgVkGX0PU9qXEbqXYg1+unwSzih0QYbyh22YiIkYhxK6raQ7HJDMjtyP6e1UjDLywgm8NsmUVnAR0BJpr8ki8yly+7D6wcm4cyUcZ8N5CPuNIDLt8X/jBXPCPTst6FoiMwLvhdA9EYHcuOTkb92w6IcDd6XBqKufXGUw7+kWXYFslyC7mzo1AB8hjcHqRN3fMnbE3B7KEEifyY74jDqdGzq4uOUmgYGTw9Apn7Dn7D7Jp4uJ4u0d0ub0up9I5z/a/N/LGSjz/zk12rxH9OhXmKz+rXdgpFgmeWGX/eOMzBCTMWnAQmRPvgPR9tyVVJLq4JD81Yv14T0rVpQMMC6x/L5RCHHH5HuRPvybF2dIhafx9s0pxn+soBcWS
 zE4JJ2id
 InbggbVR7m68ndvPFUoTUx+oEIg1VEewN1KxiBnJOEk3j2HVm02R4i6gNhHxIUTjFFS34tarJUeA5ySeFkSAoUPQZsUHBas4l4lesASDfkNwPixVb08R8LEVve6xLFZ2ee2dJtlxuf0Fdx2+6PwyDiUNx3H684sq4a9u/Ul5B3TWTsvvv5rryvHNtLMg4lRhpYSlIn+AW6CItUGt3dYCjVudyxzUfWBIqLf0ZZWKXqcnTl3gulVA/T65HlM/NNT09z2m4hhEtz9KKb7d51NOMRyUAPGuv9lcBuqghDQWb4hTrXLGFecENzgbIPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

obj_cgroup_put() can be called from any context.
__memcg_slab_free_hook() puts a per-object reference on
every accounted free, and draining a per-cpu objcg stock slot puts
the cached reference. When it drops the last reference,
obj_cgroup_release() takes objcg_lock, frees percpu memory
(pcpu_lock, via percpu_ref_exit()) and calls kfree_rcu(). Each of
these can deadlock when the current context interrupted a holder of
the respective lock.

Defer the release to irq_work. llist_add() and irq_work_queue() are
NMI-safe, and the irq_work runs in a context where acquiring a
spinlock is allowed.

Add a separate llist_node instead of reusing the list/rcu union
because the list stays linked until the deferred release. struct
obj_cgroup grows from 56 to 64 bytes, but both are served from
kmalloc-64, so no memory is additionally consumed.

Closes: https://lore.kernel.org/20261001044056.75079-3-kmehltretter@gmail.com
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 include/linux/memcontrol.h |  2 ++
 mm/memcontrol.c            | 27 ++++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..4d5c634daef8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -185,6 +185,8 @@ struct obj_cgroup {
 		struct list_head list; /* protected by objcg_lock */
 		struct rcu_head rcu;
 	};
+	/* Used to defer obj_cgroup_release() to irq_work */
+	struct llist_node release_node;
 	bool is_root;
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a05d9a8baa1b..c53147a88580 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -147,9 +147,8 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 		memcg_uncharge(memcg, nr_pages);
 }
 
-static void obj_cgroup_release(struct percpu_ref *ref)
+static void __obj_cgroup_release(struct obj_cgroup *objcg)
 {
-	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
 	unsigned int nr_bytes;
 	unsigned int nr_pages;
 	unsigned long flags;
@@ -190,10 +189,32 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 	list_del(&objcg->list);
 	spin_unlock_irqrestore(&objcg_lock, flags);
 
-	percpu_ref_exit(ref);
+	percpu_ref_exit(&objcg->refcnt);
 	kfree_rcu(objcg, rcu);
 }
 
+static LLIST_HEAD(objcg_release_llist);
+
+static void objcg_release_workfn(struct irq_work *work)
+{
+	struct llist_node *head = llist_del_all(&objcg_release_llist);
+	struct obj_cgroup *objcg, *tmp;
+
+	llist_for_each_entry_safe(objcg, tmp, head, release_node)
+		__obj_cgroup_release(objcg);
+}
+
+static DEFINE_IRQ_WORK(objcg_release_work, objcg_release_workfn);
+
+static void obj_cgroup_release(struct percpu_ref *ref)
+{
+	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
+
+	/* The last put may come from a context that cannot take spinlocks */
+	if (llist_add(&objcg->release_node, &objcg_release_llist))
+		irq_work_queue(&objcg_release_work);
+}
+
 static struct obj_cgroup *obj_cgroup_alloc(void)
 {
 	struct obj_cgroup *objcg;

-- 
2.54.0


