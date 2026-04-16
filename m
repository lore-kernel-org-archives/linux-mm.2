Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28343F8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750516B0089; Thu, 16 Apr 2026 05:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727416B008A; Thu, 16 Apr 2026 05:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6643D6B008C; Thu, 16 Apr 2026 05:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 575AD6B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:10:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 155A91A0821
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:34 +0000 (UTC)
X-FDA: 84663848388.20.9492C61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4961E140004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GQ4NTln5;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDGfH+lJNRSTtNSnA+DvLtJP6xHAemosEU5NCAjD+lM=;
	b=AsMxOWwxleuir9z+YIBDPdD4hR+BHEsJW3PL5jNa6x0+3E5eh7GyHPMcD28IMcnQVLKSVK
	IBme/aJbAyopY5WGnPqNbU+1El7HONrrdGU5NlMB29+aqn3GgU+lbUKZfnF5LIxUwfCwmW
	+cNbioZvQ4qOT8d3Fotn4ovku/m7Q7o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776330632; a=rsa-sha256;
	cv=none;
	b=bdJGDaDGKpQI2fSY3KVEXBzZybrfYEx8u6pEN0fnOtl+14dBIpNK2tEoTatwUWKbKoAGcm
	a0WdxBzExsHOFgb6EXQh8Z3CKzDsg7WsXKuQHeUBHSQfllXPyph37uR0ZwHeyOTcRQz8FB
	4/MvbrCpCAR61SlS6X0gAdP6KzjUlK8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GQ4NTln5;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 463DD42A96;
	Thu, 16 Apr 2026 09:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FB6C2BCAF;
	Thu, 16 Apr 2026 09:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776330631;
	bh=zNV6VnPICnds0zCze//et4wdPaHcOiXWxsaKS6jTJ5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQ4NTln5aCAT+pETrY8gZ/yefGmzBqE1aAnEpwGODKA995JOhDd0ELJabHQnetqUI
	 /6FO5NUk2RPPHjDUbAigpEeZVLAJfr8lEtvosfrs/siPxbikV/LusCL6GKuqgGoHJW
	 XTMibipKdMF+9sJNB6bFJQz71QhZ8Rn9Ltb3SiQXC8veLipOmp6/7D7A5+7OeAJcu0
	 YjV9m96Fnk3t2PQftb5V8O7v6w5mPnmvgoofa6GpuZznUBtrwLX1rngryu/CqwtQ4D
	 ntfGKgWmdHYe77NflmoS4eXcYj5C/6EeCX6KJ9yjxACd+8AxkFLxh63Uc1SL1dX/IN
	 NQTCvefUmi9lQ==
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
Subject: [PATCH 1/8] mm/slab: introduce k[v]free_rcu() with struct rcu_ptr
Date: Thu, 16 Apr 2026 18:10:15 +0900
Message-ID: <20260416091022.36823-2-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260416091022.36823-1-harry@kernel.org>
References: <20260416091022.36823-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4961E140004
X-Rspamd-Server: rspam07
X-Stat-Signature: n7m1k87sr9yku1urdw4jk6dzxx6bn1em
X-Rspam-User: 
X-HE-Tag: 1776330632-772474
X-HE-Meta: U2FsdGVkX19MIw9sfN023REf0LuUptiEe6y2i438Cvkrivm8D1sUWJeWA0esVPy/RqPs7ae3leVQmUGRYZ7BuGSTnJzxnUBSZq8YTj/F2BuHAq+6wbus/TdmTLtXerWLqMSgcO70yVm0LnwM63wtj0XapkrLKp+ZaWjmCBtcL8EDmzjljWFlQuvrhCWBtEJm6MdyW/0d0WPasWchMQ4vUEVQFI8d3iZVz2Yl9C6bosmpZUj3gVJEIaqipCbpJOjVsADlBmcxiXqxwwQHsNJKmiOgl0iUg+txGcIZ5t022pg0BG97aZ2FfB0JSng6Og38JbswWjtqc4hvmBh5P3m14esCsRXbuUATkp/y7F6poqeIvaX7V6heL7L66LAmI9OV2IyDykTPZg9SP6kL8fAWqNwJpcMj60MV7/im0fkVrKof6KihouHo9MVsm5ZyCJN+irLovMQVVB6pbj/wCJHYgC0IDsUn2dwp//1lY+L33V3ZYePpE663hvI40gyniLVjQn5QElyTiQlsO13hg3xb0jRi6MxLavehzaxpe7wSPtFPhsCUxV7xOnXRV9HEvsqdDwcwttlk/EsLVp/XRs1YhE6OyZdEZ1sTyiieY5Koj7br0NFF7BtZEX99Fc9Rv6P3Ec8puwmPaies25ip/DBTgoIUwHWP1Zzimdkkz6lT3TtAsmikeZ8nYcOdVgi9ly39nrReIu4AoRKuHRvBkAJKi9T2pjN7GcfQqrVJvSJohalQQXTgcLuE4mscQINFz0SBQlMRXXD4GxoBiclhYyxUMHSafOrzdPHrUs3r4kdLKJb1vM1WV+P4ZBh3EaDItJODGO67/W83XXRp3ShY1Zam9TxD671szdBPN8t9iHe6BDMnTGqpsq1EcgaMU5FIiuWJ66L08q1bPgMgVMRm2eDP1WfxdY6cNrnoJNrHHtuQSLHQCR1YYDwTUjiFKaefzFXlHqw7MqoVoBSziolq6RW
 svU9T1LB
 22DLR+/jiQRuxqeaCTZOqkdvgDxN/STLYbxlcWpQ/tU2ELJIE1EpRyyIpTBeB8vK6lmLNF5H9CjNe7fnyO18BPWGNzX0CiXomYUjbkvy1mzGPErG/3f1Wi4T4tubaQpQYcvUzvlj5DVxXwfs+x1rDVL0z16ay65MmWZE1Z5le/cdO605rBejWMkAW5Ri6NcHNkU7NPaB7rElojMJHVeTghFoWeC4A3/UBUTJ2moVOPIYTIBJ6FBTwgQvJDyM135NS1JllODGtos/eaJfuV2hGE3Bwrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

k[v]free_rcu() repurposes two fields of struct rcu_head: 'func' to store
the start address of the object, and 'next' to link objects.

However, using 'func' to store the start address is unnecessary:

  1. slab can get the start address from the address of struct rcu_head
     field via nearest_obj(), and

  2. vmalloc and large kmalloc can get the start address by aligning
     down the address of the struct rcu_head field to the page boundary.

Therefore, allow an 8-byte (on 64-bit) field (of a new type called
struct rcu_ptr) to be used with k[v]free_rcu() with two arguments.

Some users use both call_rcu() and k[v]free_rcu() to process callbacks
(e.g., maple tree), so it makes sense to have struct rcu_head field
to handle both cases. However, many users that simply free objects via
kvfree_rcu() can save one pointer by using struct rcu_ptr instead of
struct rcu_head.

Note that struct rcu_ptr is a single pointer only when
CONFIG_KVFREE_RCU_BATCHED=y. To keep kvfree_rcu() implementation minimal
when CONFIG_KVFREE_RCU_BATCHED is disabled, struct rcu_ptr is the size
as struct rcu_head, and the implementation of kvfree_rcu() remains
unchanged in that configuration.

Note that implementing a kvfree_rcu batching on !KVFREE_RCU_BATCHED is
against the purpose of RCU_STRICT_GRACE_PERIOD which is often used
to catch use-after-free bugs.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 include/linux/rcupdate.h | 61 +++++++++++++++++++++++++++-------------
 include/linux/types.h    |  9 ++++++
 mm/slab_common.c         | 46 +++++++++++++++++++-----------
 3 files changed, 81 insertions(+), 35 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 04f3f86a4145..3ca82500a19f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1057,22 +1057,30 @@ static inline void rcu_read_unlock_migrate(void)
 /**
  * kfree_rcu() - kfree an object after a grace period.
  * @ptr: pointer to kfree for double-argument invocations.
- * @rhf: the name of the struct rcu_head within the type of @ptr.
+ * @rf: the name of the struct rcu_head or struct rcu_ptr within the type of @ptr.
  *
  * Many rcu callbacks functions just call kfree() on the base structure.
  * These functions are trivial, but their size adds up, and furthermore
  * when they are used in a kernel module, that module must invoke the
  * high-latency rcu_barrier() function at module-unload time.
+ * The kfree_rcu() function handles this issue by batching.
  *
- * The kfree_rcu() function handles this issue. In order to have a universal
- * callback function handling different offsets of rcu_head, the callback needs
- * to determine the starting address of the freed object, which can be a large
- * kmalloc or vmalloc allocation. To allow simply aligning the pointer down to
- * page boundary for those, only offsets up to 4095 bytes can be accommodated.
- * If the offset is larger than 4095 bytes, a compile-time error will
- * be generated in kvfree_rcu_arg_2(). If this error is triggered, you can
- * either fall back to use of call_rcu() or rearrange the structure to
- * position the rcu_head structure into the first 4096 bytes.
+ * Typically, struct rcu_head is used to process RCU callbacks, but it requires
+ * two pointers. However, since kfree_rcu() uses kfree() as the callback
+ * function, it can process callbacks with struct rcu_ptr, which is only
+ * one pointer in size (unless !CONFIG_KVFREE_RCU_BATCHED).
+ *
+ * The type of @rf can be either struct rcu_head or struct rcu_ptr, and when
+ * possible, it is recommended to use struct rcu_ptr due to its smaller size.
+ *
+ * In order to have a universal callback function handling different offsets
+ * of @rf, the callback needs to determine the starting address of the freed
+ * object, which can be a large kmalloc or vmalloc allocation. To allow simply
+ * aligning the pointer down to page boundary for those, only offsets up to
+ * 4095 bytes can be accommodated. If the offset is larger than 4095 bytes,
+ * a compile-time error will be generated in kvfree_rcu_arg_2().
+ * If this error is triggered, you can either fall back to use of call_rcu()
+ * or rearrange the structure to position @rf into the first 4096 bytes.
  *
  * The object to be freed can be allocated either by kmalloc(),
  * kmalloc_nolock(), or kmem_cache_alloc().
@@ -1082,8 +1090,8 @@ static inline void rcu_read_unlock_migrate(void)
  * The BUILD_BUG_ON check must not involve any function calls, hence the
  * checks are done in macros here.
  */
-#define kfree_rcu(ptr, rhf) kvfree_rcu_arg_2(ptr, rhf)
-#define kvfree_rcu(ptr, rhf) kvfree_rcu_arg_2(ptr, rhf)
+#define kfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf)
+#define kvfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf)
 
 /**
  * kfree_rcu_mightsleep() - kfree an object after a grace period.
@@ -1105,22 +1113,37 @@ static inline void rcu_read_unlock_migrate(void)
 #define kfree_rcu_mightsleep(ptr) kvfree_rcu_arg_1(ptr)
 #define kvfree_rcu_mightsleep(ptr) kvfree_rcu_arg_1(ptr)
 
-/*
- * In mm/slab_common.c, no suitable header to include here.
- */
-void kvfree_call_rcu(struct rcu_head *head, void *ptr);
+
+#ifdef CONFIG_KVFREE_RCU_BATCHED
+void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr);
+#define kvfree_call_rcu(head, ptr) \
+	_Generic((head), \
+		struct rcu_head *: kvfree_call_rcu_ptr,		\
+		struct rcu_ptr *: kvfree_call_rcu_ptr,		\
+		void *: kvfree_call_rcu_ptr			\
+	)((struct rcu_ptr *)(head), (ptr))
+#else
+void kvfree_call_rcu_head(struct rcu_head *head, void *ptr);
+static_assert(sizeof(struct rcu_head) == sizeof(struct rcu_ptr));
+#define kvfree_call_rcu(head, ptr) \
+	_Generic((head), \
+		struct rcu_head *: kvfree_call_rcu_head,	\
+		struct rcu_ptr *: kvfree_call_rcu_head,		\
+		void *: kvfree_call_rcu_head			\
+	)((struct rcu_head *)(head), (ptr))
+#endif
 
 /*
  * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
  * comment of kfree_rcu() for details.
  */
-#define kvfree_rcu_arg_2(ptr, rhf)					\
+#define kvfree_rcu_arg_2(ptr, rf)					\
 do {									\
 	typeof (ptr) ___p = (ptr);					\
 									\
 	if (___p) {							\
-		BUILD_BUG_ON(offsetof(typeof(*(ptr)), rhf) >= 4096);	\
-		kvfree_call_rcu(&((___p)->rhf), (void *) (___p));	\
+		BUILD_BUG_ON(offsetof(typeof(*(ptr)), rf) >= 4096);	\
+		kvfree_call_rcu(&((___p)->rf), (void *) (___p));	\
 	}								\
 } while (0)
 
diff --git a/include/linux/types.h b/include/linux/types.h
index 7e71d260763c..46c3cfe08f50 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -249,6 +249,15 @@ struct callback_head {
 } __attribute__((aligned(sizeof(void *))));
 #define rcu_head callback_head
 
+
+struct rcu_ptr {
+#ifdef CONFIG_KVFREE_RCU_BATCHED
+	struct rcu_ptr *next;
+#else
+	struct callback_head;
+#endif
+} __attribute__((aligned(sizeof(void *))));
+
 typedef void (*rcu_callback_t)(struct rcu_head *head);
 typedef void (*call_rcu_func_t)(struct rcu_head *head, rcu_callback_t func);
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..85c9c2d0620e 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1265,7 +1265,7 @@ EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
 
 #ifndef CONFIG_KVFREE_RCU_BATCHED
 
-void kvfree_call_rcu(struct rcu_head *head, void *ptr)
+void kvfree_call_rcu_head(struct rcu_head *head, void *ptr)
 {
 	if (head) {
 		kasan_record_aux_stack(ptr);
@@ -1278,7 +1278,7 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	synchronize_rcu();
 	kvfree(ptr);
 }
-EXPORT_SYMBOL_GPL(kvfree_call_rcu);
+EXPORT_SYMBOL_GPL(kvfree_call_rcu_head);
 
 void __init kvfree_rcu_init(void)
 {
@@ -1346,7 +1346,7 @@ struct kvfree_rcu_bulk_data {
 
 struct kfree_rcu_cpu_work {
 	struct rcu_work rcu_work;
-	struct rcu_head *head_free;
+	struct rcu_ptr *head_free;
 	struct rcu_gp_oldstate head_free_gp_snap;
 	struct list_head bulk_head_free[FREE_N_CHANNELS];
 	struct kfree_rcu_cpu *krcp;
@@ -1381,8 +1381,7 @@ struct kfree_rcu_cpu_work {
  */
 struct kfree_rcu_cpu {
 	// Objects queued on a linked list
-	// through their rcu_head structures.
-	struct rcu_head *head;
+	struct rcu_ptr *head;
 	unsigned long head_gp_snap;
 	atomic_t head_count;
 
@@ -1523,18 +1522,34 @@ kvfree_rcu_bulk(struct kfree_rcu_cpu *krcp,
 }
 
 static void
-kvfree_rcu_list(struct rcu_head *head)
+kvfree_rcu_list(struct rcu_ptr *head)
 {
-	struct rcu_head *next;
+	struct rcu_ptr *next;
 
 	for (; head; head = next) {
-		void *ptr = (void *) head->func;
-		unsigned long offset = (void *) head - ptr;
+		void *ptr;
+		unsigned long offset;
+		struct slab *slab;
 
+		if (is_vmalloc_addr(head)) {
+			ptr = (void *)PAGE_ALIGN_DOWN((unsigned long)head);
+		} else {
+			slab = virt_to_slab(head);
+			if (!slab)
+				ptr = (void *)PAGE_ALIGN_DOWN((unsigned long)head);
+			else if (is_kfence_address(head))
+				ptr = kfence_object_start(head);
+			else
+				ptr = nearest_obj(slab->slab_cache, slab, head);
+		}
+
+		offset = (void *)head - ptr;
 		next = head->next;
 		debug_rcu_head_unqueue((struct rcu_head *)ptr);
 		rcu_lock_acquire(&rcu_callback_map);
-		trace_rcu_invoke_kvfree_callback("slab", head, offset);
+		trace_rcu_invoke_kvfree_callback("slab",
+						(struct rcu_head *)head,
+						offset);
 
 		kvfree(ptr);
 
@@ -1552,7 +1567,7 @@ static void kfree_rcu_work(struct work_struct *work)
 	unsigned long flags;
 	struct kvfree_rcu_bulk_data *bnode, *n;
 	struct list_head bulk_head[FREE_N_CHANNELS];
-	struct rcu_head *head;
+	struct rcu_ptr *head;
 	struct kfree_rcu_cpu *krcp;
 	struct kfree_rcu_cpu_work *krwp;
 	struct rcu_gp_oldstate head_gp_snap;
@@ -1675,7 +1690,7 @@ kvfree_rcu_drain_ready(struct kfree_rcu_cpu *krcp)
 {
 	struct list_head bulk_ready[FREE_N_CHANNELS];
 	struct kvfree_rcu_bulk_data *bnode, *n;
-	struct rcu_head *head_ready = NULL;
+	struct rcu_ptr *head_ready = NULL;
 	unsigned long flags;
 	int i;
 
@@ -1938,7 +1953,7 @@ void __init kfree_rcu_scheduler_running(void)
  * be free'd in workqueue context. This allows us to: batch requests together to
  * reduce the number of grace periods during heavy kfree_rcu()/kvfree_rcu() load.
  */
-void kvfree_call_rcu(struct rcu_head *head, void *ptr)
+void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
 {
 	unsigned long flags;
 	struct kfree_rcu_cpu *krcp;
@@ -1960,7 +1975,7 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	// Queue the object but don't yet schedule the batch.
 	if (debug_rcu_head_queue(ptr)) {
 		// Probable double kfree_rcu(), just leak.
-		WARN_ONCE(1, "%s(): Double-freed call. rcu_head %p\n",
+		WARN_ONCE(1, "%s(): Double-freed call. rcu_ptr %p\n",
 			  __func__, head);
 
 		// Mark as success and leave.
@@ -1976,7 +1991,6 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 			// Inline if kvfree_rcu(one_arg) call.
 			goto unlock_return;
 
-		head->func = ptr;
 		head->next = krcp->head;
 		WRITE_ONCE(krcp->head, head);
 		atomic_inc(&krcp->head_count);
@@ -2012,7 +2026,7 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 		kvfree(ptr);
 	}
 }
-EXPORT_SYMBOL_GPL(kvfree_call_rcu);
+EXPORT_SYMBOL_GPL(kvfree_call_rcu_ptr);
 
 static inline void __kvfree_rcu_barrier(void)
 {
-- 
2.43.0


