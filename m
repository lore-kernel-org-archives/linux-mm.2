Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E96C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BF446B0099; Tue,  1 Sep 2026 14:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296CA6B009D; Tue,  1 Sep 2026 14:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15E236B009E; Tue,  1 Sep 2026 14:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFA1A6B0099
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:29:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B5AD1C21DC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:29:14 +0000 (UTC)
X-FDA: 85166030628.21.26E26E9
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id CC56940010
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:29:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="qggSTP/b";
	spf=pass (imf12.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788287352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tup5QvhrUxBuHbOp/mUBjVWrl1apXEgoVpX9q/lsPY8=;
	b=qJvE6yGOanLGJqC1bRdW/C/TUa8wawNpbygqzsIj9xcd6L/MfiytqTeeb8dyIYcAHJou7X
	h/6RsPXMfgYQJB9sjni/N+Dbf96JxK3uoXn0BEF8/sz2RfED+/Zp1fKvFapL0IzHLgJpGT
	AFeZ4pmYF2phjYMnKg65Vw/zOXFiggg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788287352;
	b=jnuRBycKysxGFIdN34sgVxgbTTeSt4UGk+jHUyDd7N2mZDcYa0swynzpWwh3Q2oewr0GPd
	dSCEuv8ZdySsT7Zw1a/BEDmev4/viSurXeJeiNcJVthVQk8T8yEMVUqAsEFMSLkY3RxlC9
	wGoR6spO2GvbnJ2TgCKU4vfrCo3sAsY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="qggSTP/b";
	spf=pass (imf12.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788287351;
	bh=Tup5QvhrUxBuHbOp/mUBjVWrl1apXEgoVpX9q/lsPY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qggSTP/bMcWpRasG0WnaP9ws1YJFtVdzjObT99OSRwUR65maTBgJBaqTOQbc0wDeL
	 25QqSwuqF/o9a+SL8TEJBKSUiAxdk+MbcNlDACdQ+9N6JHsHeDThh8N/Wp/FmRu2sY
	 1Qwi/Bh+MvObtuU9Xt7CHHgq5+e4MGXlVSRPAQR2KE66n8bnwbXbG5lz5aq/fF71LQ
	 GaLUslwndIoe4WqGLpRYkP//V8t6vrVPKiocXYPyq1xESgzxyGl7wNA23o6WCons/D
	 9lIZ6nPcfP8LZl7OYaG8cLoQVBn9IN5QmlDsFxZwiOkO4QY4X9vx7tnkR4HROZwP6l
	 cscrNHFYhbIrA==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hZDsM00XdzW6M;
	Tue, 01 Sep 2026 14:29:10 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Josh Law <objecting@objecting.org>,
	linux-mm@kvack.org
Subject: [PATCH v21 6/6] lib: inline percpu_counter_tree_items_size with boot-safety sentinel
Date: Tue,  1 Sep 2026 14:28:51 -0400
Message-ID: <20260901182857.26690-7-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
References: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC56940010
X-Stat-Signature: s3ox6usienqnqwfh5p7ohx9e3qwyp11z
X-HE-Tag: 1788287352-70323
X-HE-Meta: U2FsdGVkX18Nzufd2AZ+XVkhCoOeycSQUcxN/aICo2JhxHgfHmQh0DjuGlNy/v0awJ97qRkoxnmCirmipG99dcmJq/YihqYpTEFpJh0i2eYjzIw9Y4IlSEyw9eeQZG2FcwaW/vhm5KOK955L/vtJIgLLAxRYGZYJ3gOsb76/R1ZmyXmvOfrqVUGFdqNXC1J9Q8KMGrN5y+KzEhfDEpz1MNBC0qKJiAwcckuQP0yebsD4ez9eBRdlgZvkqfH+F/QLBja3xyPe431gVVxhi1pJS6UGWsisCJ70bUqsZAlsqKWQXzmoQrkxTjqf3sqfvl0LAs92NDILagNtbNzvrIcT1dBnnaZRoDKrmWxOAxOMUqhEcZ/d1qLsmInz9ytl5cEXwhcWJjiF3c1EmantopFtRATu49uMrvdLjmOzSJxlw7GCGdibB2Bt8WFCNrYkWJSff5lVKWgrEvzeW0LUCZfBZsD2UmARUJRRbqWL2KEieseTf9dfRjUYGOFX9PkHiU63DbGEaqo/5MchtCII3J9aMpj25ySm+bZI9dMlwCShhHvX+NKCBUjuZXj47yewJjySMzdw//QJuLmQsYwBmBhl8wWlIjqr/TkGMSmIuph5fqdFRk+NY8Dznwiv0Hi4xGg2Q6O6Sh6DBkrm9YlwCGDG0aqzKYy+cCLV56x2wB7/ZGiDrZJLng1sGRq04xnWvYyb3SsbwxR1bKEGZCnxkFsmdPLNLrgRugGfYVpQBf9xjhOcDvoSmaHIwplf+gIX7c8rYf0Q8+vTlAl4EeeURnq7cor+toiF1YyRxbNqYcJ+hkH283tHROUh3khK8sh/QpZS1HzAR5CgCUeUhzZlxzngCnzxpCOIvmX1SkIBr9Y0G5tgKgiF7SAa8CciQeNvM1r39aRrVJrbg5vX4FhHoB3+8xmk2Jgo6FWHkgFADgIYcy6ork4V8G2DeETJLKWgckluKNhm/MVx4P/fQFUhY6X
 iJERa2Rj
 I96jv4rgA6Sji0DjlXYBMt4RscpBFuo0g8JRIhdWhZC58PhUxLL0XuoB1C5vnQAWhPxUb6k05TWeTNCV6kIrgA2dPsrHL3iB6+MIRcQuR0Y/3C/AqF9qmpXphlD8LwubSEcYFjd7HQrKL1S4TsIpkp0DIz5QmFDSEH2IP1fAmwyu9jvIvkN8QedQKqg3YeiYFq8FVkaq/GNIsaySBK5Ccig5AoYf1nN2YXbEuKzahkAwHz5FBoBRDupHfi6Q8TOcYhaoOJDvU0is0G5ygVK21rhqtahq1gSlDF7sBGOZlXXyBk2LbAERysl5NW8Soldj8YyJ8aexaDvB68M2KXFJVn4MPlH75RBnr8c1pBIYhY5LZxacEdJC7m30IM8TUBu4ZukQdCP0qgyDMdyw4M3wQkZSmYfAUOfGvqpSDDRdrYOK2/gvSDWA34UdQnHUcP0HFBUs95cvdQs1Yp6j4+uwv+0hi2z10Sv5f8eEw6IF3eP0FLdyCnWqH/t9CzOgAKj84uWIuqMoLkpQ0oY/30u72d3NZ0rCISUTPUrvNMLlUW9AL8fVwxWYP5bBMVsgVDuQ3CM2pZ7/WYO6WXwY5HDyuzzl1uSM0Uf4GAPTOtAi8fnu4H+WNeN9KyJipRbEW46AS20YCaJvw/LUyShkpqK72OE1UKft/e+iUSWz6hMmDhnbKvZrjAcFPWACxHYu5TM/o4LI4va6tq+yPQD9T3HmYSHsYb6XViNFaWBNxoMc9Q93/AvPTcYXWLuLrGxg2jaOLaGNDLM3yRkzVtqINVQr2R8drEhN/CT/uu74Qq78UoucPCudUl7Qhzh4IQDqQsD0I6ikutrjNeG0ppliCDM+4JxkVKJOH31p5um2PZaE//QzRdj7EiA0Li0+9UU3XPrFQ/s8b1LgF/nLKLLuEMkm0m0fF3GMbOjlAkLl0WqpKIXQz3AYHP/8+m1SffGfXOCsRJZk6Te+8vIGzEDhrpk/RUSxHDddj
 kK0RkxPc
 7nQpoiyknqMzXhcCCM9SQJuUeGP2e42wHn0DxB5+GqJ/otPw+xZ2yGmlE5Vc4yuQL3hbNgU8iYgILe+AVCxMfQTm7Y76hlZVnJvgaix2W7okCi99igdxq51QzSo49hdLPw+8myP4g64D3GE4GHBcDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the out-of-line percpu_counter_tree_items_size() function with a
static inline that loads the __ro_after_init variable
__percpu_counter_tree_items_size directly. This eliminates a function
call on paths that compute mm_struct flexible array layout offsets.

Initialize the variable to SIZE_MAX as a sentinel value, and add a
WARN_ON_ONCE check in the inline accessor to catch any accidental use
before percpu_counter_tree_subsystem_init() sets the real value based on
nr_cpu_ids. An early misuse would produce an absurd offset that triggers
the warning with a stack trace pointing at the offending caller, rather
than silently computing wrong memory offsets.

percpu_counter_tree_subsystem_init() sets the variable to the runtime
value immediately after deriving counter_config from nr_cpu_ids,
before calculate_accuracy_topology(). After boot, __ro_after_init moves
the variable into read-only memory.

On !CONFIG_SMP, the existing inline returning 0 is unchanged and
requires no sentinel.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Josh Law <objecting@objecting.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
---
 include/linux/percpu_counter_tree.h | 19 ++++++++++++++++++-
 lib/percpu_counter_tree.c           | 24 ++++++++----------------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
index 3e8a820e2d1d..4095acdc879b 100644
--- a/include/linux/percpu_counter_tree.h
+++ b/include/linux/percpu_counter_tree.h
@@ -101,7 +101,24 @@ struct percpu_counter_tree {
 	} approx_accuracy_range;
 };
 
-size_t percpu_counter_tree_items_size(void);
+extern size_t __percpu_counter_tree_items_size __ro_after_init;
+
+/*
+ * percpu_counter_tree_items_size - Query the size required for counter tree items.
+ *
+ * Query the size of the memory area required to hold the counter tree
+ * items. This depends on the hardware topology and is invariant after
+ * boot.
+ *
+ * Return: Size required to hold tree items.
+ */
+static inline
+size_t percpu_counter_tree_items_size(void)
+{
+	WARN_ON_ONCE(__percpu_counter_tree_items_size == SIZE_MAX);
+	return __percpu_counter_tree_items_size;
+}
+
 int percpu_counter_tree_init_many(struct percpu_counter_tree *counters, struct percpu_counter_tree_level_item *items,
 				  unsigned int nr_counters, unsigned long batch_size, gfp_t gfp_flags);
 int percpu_counter_tree_init(struct percpu_counter_tree *counter, struct percpu_counter_tree_level_item *items,
diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
index 5c8fc2dcdc16..cfa5b04e05d7 100644
--- a/lib/percpu_counter_tree.c
+++ b/lib/percpu_counter_tree.c
@@ -653,22 +653,9 @@ void percpu_counter_tree_set(struct percpu_counter_tree *counter, long v)
 }
 EXPORT_SYMBOL_GPL(percpu_counter_tree_set);
 
-/*
- * percpu_counter_tree_items_size - Query the size required for counter tree items.
- *
- * Query the size of the memory area required to hold the counter tree
- * items. This depends on the hardware topology and is invariant after
- * boot.
- *
- * Return: Size required to hold tree items.
- */
-size_t percpu_counter_tree_items_size(void)
-{
-	if (!nr_cpus_order)
-		return 0;
-	return counter_config->nr_items * sizeof(struct percpu_counter_tree_level_item);
-}
-EXPORT_SYMBOL_GPL(percpu_counter_tree_items_size);
+/* Initialize to SIZE_MAX to catch early boot misuses. */
+size_t __percpu_counter_tree_items_size __ro_after_init = SIZE_MAX;
+EXPORT_SYMBOL_GPL(__percpu_counter_tree_items_size);
 
 static void __init calculate_accuracy_topology(void)
 {
@@ -697,6 +684,11 @@ int __init percpu_counter_tree_subsystem_init(void)
 		return -1;
 	}
 	counter_config = &per_nr_cpu_order_config[nr_cpus_order];
+	if (!nr_cpus_order)
+		__percpu_counter_tree_items_size = 0;
+	else
+		__percpu_counter_tree_items_size = counter_config->nr_items *
+			sizeof(struct percpu_counter_tree_level_item);
 	calculate_accuracy_topology();
 	return 0;
 }
-- 
2.43.0


