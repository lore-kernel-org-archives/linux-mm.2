Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B57F606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GUV2UKX5
Received: by kanga.kvack.org (Postfix)
	id A99736B05B0; Sun, 15 Nov 2026 10:10:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4A5D6B05B1; Sun, 15 Nov 2026 10:10:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9398E6B05B2; Sun, 15 Nov 2026 10:10:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69D526B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:10:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDCB240796
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:16 +0000 (UTC)
X-FDA: 85437689232.26.70FBFB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4EA0540009
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GUV2UKX5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794755415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGGUUoDWezoH61vuB7bjTkJkeuRE15lGC86Qhoj1cWA=;
	b=W0E9n1BG1CaToHQkG0/TctVsAxKX668b4xrqnBjtjzhlsHO8WCcCX4Ep65A5CAWHHPubif
	xpwa2iJ7TPrNxkZtZhhKs+StGzODbm1D7syMQXD8JEHUZX2qX8q1jw94dMzdhNyd6XwSlx
	3FSkxkY9vL3lavxRDA2PyaPtNzJ8i6w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GUV2UKX5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794755415;
	b=t0yQCy8ZPgxURGXdlnlsF0g4GC0XxjDG3efq+uIwbbv3msQpwKjO4rf9uKLNdS6G5327oO
	V80qT+Pahebmh8gG3EF0f2uSF2kRhW1FOGtAWo0ufnDKgC2iPezdlNZ1ZGSACwUjQ4k90F
	PCpgI1stLwBhFAa0TvByJr260Szo6HM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADCFC60230;
	Sun, 15 Nov 2026 15:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661A31F000C4;
	Sun, 15 Nov 2026 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755414;
	bh=eGGUUoDWezoH61vuB7bjTkJkeuRE15lGC86Qhoj1cWA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GUV2UKX52jTlvG4MAjLtGvc7d7oXopyJfi8DACbmtAXhwW1udGofbt5NBnG3SDEFG
	 5XZInAURePG9W6g0tk5IiMWhdLevavLPV9cNOsSwSdB+0IORQnZHqjRandZ48z47qt
	 cXcBfLzjo7U1IANXJ2gVCgMHZhTPR5ZlHIk7TsG2NwH/iAg9mgrSuYFSi8fRxAlp1T
	 FYUMoUTm6qYbgqG0fCwedVXp7wbnYceBjfTGFXsfHS7juNS0MfJWW5P13/IiBeTWHo
	 Ym2J6iZusW6c1Z3uCPC0Pog4/aA/Scp42cUA+HtwuPq6AxGAenVyWgdmSoZ0hcMAbf
	 dKcTr99T/EW0w==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:35 +0000
Subject: [PATCH for-next v3 1/7] mm/memcontrol: defer obj_cgroup_release()
 to irq_work
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-kmalloc-nolock-fixes-v3-1-9034dd4ecaab@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4EA0540009
X-Stat-Signature: nr53ysjgjm615eq3x19tkdph5rjzem15
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794755415-292654
X-HE-Meta: U2FsdGVkX1/zqxNWuBTliGrP3A/yQHdw4Cnlvwpw8VEUa8WoxLVeoYn3YERur+lSlzbz7FQPXg+RSlxT2tn46pJU5hoRpXyiCwmQr2ZN6+N2DGffS4Wv2KFnABPDyYhW7EuvnO3wNOS0a0ng9MaGG72lYMmegI/k8aQCKBCzKSkf915JvDGyWO3fHEyR8m9H8uHlzu91IRTT+Olf70N0t10VXOB04Dg2WYXvl9WTej7sNLVwCBN3q+kOAXCEnyqwT+YI+cJXgLNbi/f7R661UV6FLu0JMJa7XQ2VoxL1qmWn4sZ8V+/dq+Pr5k6Mk2Vdz2eU1IyaxpO4IvyG/FvE6u9CqRUNqaPCHsVr9x/zEb3ze6x35ip1yroPUj88a4mt6oPVmBsG3gJd51aoCFfJgjbjO+yEibLlleiyHAZUf7QVBr8a49o4jaivbCygBqfkYorcayMa35cY/ctRm73EV5KI2A2SVAPT26wFdQEtyaRsyPIx8NI8rcRNGGPeFKmfW9TOfKgN1VVfa1P2G+puI9o1rv0Qrakj6/wM+FyQCe1N0biyFXm4kqbzVoc57loNUoEv+xNBY+oKtuAO2GoneDHTlksALOp0HSarp1W79cAH6Tp8qy/CbqC0JyxFolWBM+is1FL+xc5S/MecFwc80A/kp7QBxMc3uDSNdpCFxcw+mBstDpwxaTW2YqcvHc8u+h+94aWFqJ9pzQYIFUl4EdMZOlR2vR6r8EV35irKxcEJzjDWeQqPfv1xJx0+5mxp16Y0RlYUwfuwHLcK01UF1tFMb6rHYiY7zrF6hzGqhnhXsQFzEv2ZeBVwvQtod0IFqHWEXh3xvxuityRkappshGpjUXzOT1HcHfFX35rvTNIQbpEBbo5yXQd0f4G6tTjAg/3MjS9zIL4hTTswWzmTqeDAURd+OWY2qQp5TqHxpC/vCRGBA7VTBmEiFgTyt0vHI1r4e3lgDnSsWl4tfnL
 pyVJlsL+
 F2aLUWNhAwQC+28KJRKnITlnA32ZcGYjm9ZgeW4klC9lA2uIUiD0QYKwr30dO8Cuwlhd93RH7KtYTgPlPancUOj2KkRDlsk4PWV3CzTg2RBRzzO2lO6PX3dCb5G8uUfWBd0WT0liOv15Jk/S21rCvo0W3n3szn1MpgMTmt3V+0A0tV88S0ACmdjLdTe1pcXmW/kWn9zKR3HTb2f+P3v44m0Acm9QGZiG02YCSkcklXoOWJuY0yahSz7EpDoJzWF6x8UVyGVtC6Ua+z1HNkEHlaWLY9/KXBhAKVGtV
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

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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


