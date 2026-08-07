Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8AA3C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 13:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBACC6B0088; Fri,  7 Aug 2026 09:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92956B008A; Fri,  7 Aug 2026 09:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8336B0092; Fri,  7 Aug 2026 09:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8C126B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:50:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A5551C0DDD
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:50:46 +0000 (UTC)
X-FDA: 85074608892.22.6BBBB9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A214180012
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:50:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRqvRaU0;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786110644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EwPefllU6d1ZOhpuz2HmPQx5BKCFxUJHa6Nznn6LyRE=;
	b=FWv7ZCuPhfvVJ4rlmZIDn4dPwd94roTy13SD3OQ/gQ8iiMBpvoQZCNsWWr+5P22TXfjtfb
	rqUiUs425xxoKzCg0zoEg08HfDwOO2W9281p6rZLeZr7Ez7vempFzhELvmjVHsNbv5KrO1
	PProNNNO8U1+AfpefSpwLf6ZNDrDUwA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786110644;
	b=E2OmRDD+Xu6HS84Yq0wnKFZyhqJl4U2qsx3mHYMaFHqEOKwTLcfcyD+a4wN/9obQroS+59
	QMf8log3YWv4wdPsAxeH+qnoB4TtIMYRnFvHkNCv3r9KHYYbtV1ZftKoIA3DQmLuvOQKKZ
	D70KqDc/8vb6LEeDzK/nHhorVZ1HxKg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRqvRaU0;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C89DA41435;
	Fri,  7 Aug 2026 13:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9781F00A3E;
	Fri,  7 Aug 2026 13:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786110643;
	bh=EwPefllU6d1ZOhpuz2HmPQx5BKCFxUJHa6Nznn6LyRE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MRqvRaU0RAWLPqYnu2hVF4J5A/YLaMcCc9zGyL2HSxIqa/Mj0SL0oKlKbwt3k85om
	 /K+mY2Imhr15J0MQpohqmZx3hyI5PEo905yB/Iz/8GW23+RGf0MgL09nPRi/ZX4aCQ
	 Trxl3o2SIdim/srZsS61ZsLQcc67m5Oe8hHOAwiSkt02Ou6uM8FsSASn+yez70ZATR
	 N6FQ3VtTRJea/r6sSGDDFMCUJz76Mt6lR4H0cJeQq3OMQkbhrzJLLKULVBoysbLf+c
	 9kP9g90IN29MxfINOrWOUfpOVoqKYxH2oqKURDtpC+GxAE3HGVlr6SDAen7o2JOfdv
	 8v2yKob6okQxw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Fri, 07 Aug 2026 15:50:27 +0200
Subject: [PATCH RFC 1/5] mm/slab: cleanup deferred free handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-kfree_nolock_kmalloc-v1-1-ba993cbf7a60@kernel.org>
References: <20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org>
In-Reply-To: <20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org>
To: Harry Yoo <harry@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, bpf@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Dmitry Vyukov <dvyukov@google.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 kasan-dev@googlegroups.com, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
 Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-rt-devel@lists.linux.dev, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A214180012
X-Rspam-User: 
X-Stat-Signature: xso3sif8pjiecgqzc96fta6taqfo1jfn
X-HE-Tag: 1786110644-818877
X-HE-Meta: U2FsdGVkX19Tio1o6a+Ppxq2+MuncYhBTkeriuSuEMY+THatBgY/WjqfePYFEvYYdm8IdcCY6IZNYmacVLh4lWas5iyAH2De8fbvN2OcV6i4xkf4yL9nmkZzEqcooDqfKknOlz09+ZJSE3f/v/oRv3L/yFhr6t98yjZClIgkXCAbDsTKIKTI+uiGoMtxvOzU+ibi95UtS3AYuRbpJureyNZnFLWkJ5b9Hvr+dAU1mUsO6e9IMJCYKk3YaicWAhkJfF2aerpzuAXhSE8IZsaicrJeveuacNroyrhMMUyOXnyX6YizDLWj7k8YqiiwYRRJweCCNyTvH8JqQ4im9eMDOtctpmFYjHZlmbe5tOdg4Qb+DGQBPnUufcfD7b12zanMzEmn2y1b4QT8zyuzdeKvctHH+nfgWoFaLJt6QiSIEMDz1ZdJXstyA0fDWWlWqbOakUf1WVa97ZyRYo7wCZc/4gHNfWi/t6LerS+Nn2A45ziYgojLHn3DtTnX2mS48PQ4VUgl0q5y96naEPFsKQH8gkn31RsnCGL33khZ5euO/UZTso5Hh1JMwHk/EXJVvTgsye7sxdHXIxu82f1cUWt0AtzdYNp9F2ksGEKalEyqhnGyjeBhmNMl6FCgryGbDZOroBJnbNI7rBuVPmjz4L8WIO5r/fHtGgRi2/zgHiefTfRz81UbOmYmdqxZvEqd1NoViJZVMi8Nf8IFAejQztDlQpq3NFijse5zf0eQ6DD/r8iADErTqOB+VhmVsIxYDc8bs00vks5jE9La4nXAbXNyDvjsJbI/rB+/YD5o4KbVHJUnz1m4IKtKTzie/XdTaQTFSq7UyV9hCi2QX24woI6SS8LVY0sv7rTQ2QsJtPBkgh1yIHSdnD9jst/9uidGjxwulChnyUxjzg9OLJlE221T7tV/tuN/NYCtn+d7PiFG2AD+ea3tAb5WYqHLpqHY4QuJdztgP0CVM0VyfSj8Gpu
 W3plpnOi
 nS5eDbi8E46OJulH8XLTPau9FTzBOnPmGISgUfXrp3Qck+bma0VeljnP9gPEB5dj5Ygmxn3aOn7P016qN4/XzkwWgQRqXJ1TpJ3aw7UsWCbR1J9Va/SESlnFBOuX//Xev0w65z0md4jMyFCCdB2l3dh9g1XkUJxTQlomt/VcXHvNeLLZOT7d5Ll/JcKu0mfDZhpwtcjQjl2+RQmLCtWTHWKFPvjN0+0KE1Q7cdaR3hXgJzchFZUY2K9Suig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In deferred_percpu_work_fn() we have a bunch of single-use local
variables for the various llists. Remove them and access the lists
directly.

In defer_free() make it more obvious and documented what we are doing.
Also restrict guard(preempt) to only the necessary part.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b9aeb02a880f..044db93d64a0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6371,16 +6371,12 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 static void deferred_percpu_work_fn(struct irq_work *work)
 {
 	struct deferred_percpu_work *dpw;
-	struct llist_head *objs, *objs_by_rcu, *rcu_sheaves;
 	struct llist_node *llnode, *pos, *t;
 	struct slab_sheaf *sheaf, *next;
 
 	dpw = container_of(work, struct deferred_percpu_work, work);
-	rcu_sheaves = &dpw->rcu_sheaves;
-	objs = &dpw->objects;
-	objs_by_rcu = &dpw->objects_by_rcu;
 
-	llnode = llist_del_all(objs);
+	llnode = llist_del_all(&dpw->objects);
 	llist_for_each_safe(pos, t, llnode) {
 		struct kmem_cache *s;
 		struct slab *slab;
@@ -6403,7 +6399,7 @@ static void deferred_percpu_work_fn(struct irq_work *work)
 		stat(s, FREE_SLOWPATH);
 	}
 
-	llnode = llist_del_all(objs_by_rcu);
+	llnode = llist_del_all(&dpw->objects_by_rcu);
 	llist_for_each_safe(pos, t, llnode) {
 		void *head = pos;
 		void *objp = kvmalloc_obj_start_addr(head);
@@ -6411,21 +6407,27 @@ static void deferred_percpu_work_fn(struct irq_work *work)
 		kvfree_call_rcu(head, objp);
 	}
 
-	llnode = llist_del_all(rcu_sheaves);
+	llnode = llist_del_all(&dpw->rcu_sheaves);
 	llist_for_each_entry_safe(sheaf, next, llnode, llnode)
 		call_rcu(&sheaf->rcu_head, rcu_free_sheaf);
 }
 
-static void defer_free(struct kmem_cache *s, void *head)
+static void defer_free(struct kmem_cache *s, void *obj)
 {
 	struct deferred_percpu_work *dpw;
+	struct llist_node *llnode;
 
-	guard(preempt)();
+	/*
+	 * Place the llist node where the freepointer would be if we freed the
+	 * object immediately. That means we can write there safely, only need
+	 * to remove kasan tag first.
+	 */
+	llnode = kasan_reset_tag(obj) + s->offset;
 
-	head = kasan_reset_tag(head);
+	guard(preempt)();
 
 	dpw = this_cpu_ptr(&deferred_percpu_work);
-	if (llist_add(head + s->offset, &dpw->objects))
+	if (llist_add(llnode, &dpw->objects))
 		irq_work_queue(&dpw->work);
 }
 

-- 
2.55.0


