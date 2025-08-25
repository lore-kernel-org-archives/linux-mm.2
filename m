Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73CCCA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 12:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204F18E0016; Mon, 25 Aug 2025 08:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC458E0001; Mon, 25 Aug 2025 08:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1194F8E0016; Mon, 25 Aug 2025 08:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3BFB8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:18:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFAD0B92FD
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:18:51 +0000 (UTC)
X-FDA: 83815183662.15.9C244D9
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3D3FB100011
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:18:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=htDE4r67;
	spf=pass (imf05.hostedemail.com: domain of yangshiguang1011@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756124330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=enQjVH9CPVENIVsHk7gsCn5/5+hGNNH2XndDe1QIK7w=;
	b=kq/cUqCq11pWrhgkkdnwhGOmdO5GnSX16tSvVMGV8AL6JVVomIoVL7elbk2TK+8NRVDMKX
	RfBPIKZlqLL10OPbxwLZ8UENvzVdisM2vJ3dysctXcfxpyIG02U3L3xbO4vc83bmhIbbfZ
	TbB2vZvUb+cLR6pZgQrtoH1j0TazWa0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=htDE4r67;
	spf=pass (imf05.hostedemail.com: domain of yangshiguang1011@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756124330; a=rsa-sha256;
	cv=none;
	b=0V0QCS4ge0UqCIUzaW0xpQNnRcYs6nc/8uR2wGffgkt46bo/1/X8Dp+VMu/PZJyplsQ2mo
	U7SKoZKK3MApr/eHzUlpgOkbefZLIehmCfmL2HbJlnx+SMN39R235k8sDpZDW6eeen3eNP
	zVzZ16Vtn6P5IeSLGlSqUKd6Cr1C2UU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=en
	QjVH9CPVENIVsHk7gsCn5/5+hGNNH2XndDe1QIK7w=; b=htDE4r67TWRW8/4/23
	/qk3oo/CzwSXo0U2Fmra438wGVC795bfCZXAVAIaRY7dX8aio69L7Jf0x+eSTBc8
	6jYS9HXn+8Ln/d1RjYbMWF+WJkGUMSmc4DxPQRFWFFKuOx+q3GLj0QEfB482ZDpf
	qrSfHIurifvyA2n9H1bHX2weg=
Received: from mi-work.mioffice.cn (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wBHsTdyVKxoeChoDw--.61651S4;
	Mon, 25 Aug 2025 20:17:55 +0800 (CST)
From: yangshiguang1011@163.com
To: harry.yoo@oracle.com
Cc: vbabka@suse.cz,
	akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	glittao@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yangshiguang <yangshiguang@xiaomi.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] mm: slub: avoid wake up kswapd in set_track_prepare
Date: Mon, 25 Aug 2025 20:17:37 +0800
Message-ID: <20250825121737.2535732-1-yangshiguang1011@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHsTdyVKxoeChoDw--.61651S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jr43XFWkKF1UCFWkWryUWrg_yoW7CryfpF
	W7WFy3tF48AF1jqFWUCw4Uur1SvrZ3CrW8Cr43Wa4ruF1Yvr48GFW7tFyYvFW5ArykuanF
	ka109Fn3Ww4UXaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07juUDAUUUUU=
X-Originating-IP: [1.202.162.48]
X-CM-SenderInfo: 51dqw25klj3ttqjriiqr6rljoofrz/xtbBMRq05WisT9l87gAAs6
X-Stat-Signature: ndwwzqeob66en9xjmupkdayj4mcgwwau
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D3FB100011
X-Rspamd-Server: rspam01
X-HE-Tag: 1756124328-346490
X-HE-Meta: U2FsdGVkX1+iUyLj5augq7RSHDkqsKTU3M0iy9gvaJLt369zS+DdoGJD+/GMq/GYJekrGqS3a4OCTGQlrVV/x6/6sBBhM+6ZfMRqLEGdI3KfxNSqUiE7Rvgz7o35qWVdgvUbOYPszWooxWtj/BMMEpj1khQ98vfqeV/mlmAAA0c7xqNn6RtIunBFsXFdDDyqt0S5GJiK6phOoyWX7AfSVCzXqiRtvgl1mue3hBQWCr2emZS7cDvRdge8MI2Xst/lGEhUeYjdufXmdHq7AlE08DFEMMqjTT1gjssuEasyeoeeWSgk0EF8SwzdJ8oAtLH2ZVxlh0rQhlIKuPIHcxcOUXYgN+tYDELGgnnzrYBHtfh4YsPgoTxG8A97Nwe/g6eH7fmL8W8LgnINKPEvxxojNu5lxh4zfwe2igk0n0dfAD1iJx1N8afHWNU4XnLCq/spZjN8tiayLGqZRRNPkmBJRKUw1mIGR04WDXQeQHZYVJhqkTYx8rF0BdGum7E27fDT0XCac0OSynirCk8gkc8lAz9ZwrkGRpuV9MqY/nMgjlq8A83t4qaMfnQqjqImUtBbsoxQfpG2aJNVfqFNfnFxnai0PBuG000HhImeIJrw53z2fkr80CZJGZKRLiteQ7sRi9elk1yLd01FG4Oc6tgvp5zGgdZrMF6VOsqTInTgHOJNyHzVXptLa4ULW/rgpXL0Ru/MUeSBEgwoh5dBHqef6+aOAbde+smUce9wfvxlT0K1+9f5k2N4ceMEPaDOyBlplML5I2raOXJqvztHVa9hlxQTu4jguMuMrwMbko/wQ1DRgf+5rjR9fQ0yOm0+pCiDOZpbBRnwlwzyK8gDH7eci2QZacEMXnCINv8g7xfrOcDLbXtz/fEXYf1F63FzfiU9nSs2seL0yfWgLm+V9w6nFVWuFFAo8Fo8fwNdJimkC4it0G2gGZSndTEMQbR3/XSqGrx1fYIcRDvSXwjkKkQ
 TpvD9TpQ
 jL5nCkGaqE6QwvqJCUr8A+PSRu1pTLzJikC2Ai/8pw0pmoiwqD9py7/w6vHdM3L0oC8wdZlUuCzb0MnkJtgA08Htwio1P+O+hqAQkEWpbGmXPCYCRugppJW59JU2yW5qR6jRm6raabKU0hpQuXrVvLXbliwgYYR+V8xRpIHemn2u8CMHIAACs5YaEY2dij82s4zAVS80cddOuTpgN4rZvBBbz9eUmLqqFx9dkqJZmB48USvtq28tLBESv8MAmXcXtOEwTr568bWEgIm5lv631rIAp2lco0L9KXcQiDg/IK02tOn5CGc2UuGnSrFCJ4zdYu1yPjS1ohW9gEHXSMN9Gqu9m23VFBjcKyD2JmaSfYteueOKQ+C+6P9hNw8TWby9mjJGvumZNSq7lwXBm/FiCAEdKyPICRjbpkoh3OlgQk0PS6j2xvinruvsU/uq2wAOEHkorUXW1jcOKgFrvCEfHERwOoYESM3fNeeHNcdmfh/9pHFk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yangshiguang <yangshiguang@xiaomi.com>

From: yangshiguang <yangshiguang@xiaomi.com>

set_track_prepare() can incur lock recursion.
The issue is that it is called from hrtimer_start_range_ns
holding the per_cpu(hrtimer_bases)[n].lock, but when enabled
CONFIG_DEBUG_OBJECTS_TIMERS, may wake up kswapd in set_track_prepare,
and try to hold the per_cpu(hrtimer_bases)[n].lock.

Avoid deadlock caused by implicitly waking up kswapd by
passing in allocation flags.

The oops looks something like:

BUG: spinlock recursion on CPU#3, swapper/3/0
 lock: 0xffffff8a4bf29c80, .magic: dead4ead, .owner: swapper/3/0, .owner_cpu: 3
Hardware name: Qualcomm Technologies, Inc. Popsicle based on SM8850 (DT)
Call trace:
spin_bug+0x0
_raw_spin_lock_irqsave+0x80
hrtimer_try_to_cancel+0x94
task_contending+0x10c
enqueue_dl_entity+0x2a4
dl_server_start+0x74
enqueue_task_fair+0x568
enqueue_task+0xac
do_activate_task+0x14c
ttwu_do_activate+0xcc
try_to_wake_up+0x6c8
default_wake_function+0x20
autoremove_wake_function+0x1c
__wake_up+0xac
wakeup_kswapd+0x19c
wake_all_kswapds+0x78
__alloc_pages_slowpath+0x1ac
__alloc_pages_noprof+0x298
stack_depot_save_flags+0x6b0
stack_depot_save+0x14
set_track_prepare+0x5c
___slab_alloc+0xccc
__kmalloc_cache_noprof+0x470
__set_page_owner+0x2bc
post_alloc_hook[jt]+0x1b8
prep_new_page+0x28
get_page_from_freelist+0x1edc
__alloc_pages_noprof+0x13c
alloc_slab_page+0x244
allocate_slab+0x7c
___slab_alloc+0x8e8
kmem_cache_alloc_noprof+0x450
debug_objects_fill_pool+0x22c
debug_object_activate+0x40
enqueue_hrtimer[jt]+0xdc
hrtimer_start_range_ns+0x5f8
...

Signed-off-by: yangshiguang <yangshiguang@xiaomi.com>
Fixes: 5cf909c553e9 ("mm/slub: use stackdepot to save stack trace in objects")
Cc: stable@vger.kernel.org
---

v1 -> v2:
    propagate gfp flags to set_track_prepare()
v2 -> v3:
    Remove the gfp restriction in set_track_prepare()

[1]https://lore.kernel.org/all/20250801065121.876793-1-yangshiguang1011@163.com/
[2]https://lore.kernel.org/all/20250814111641.380629-2-yangshiguang1011@163.com/
---
 mm/slub.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 30003763d224..443411713e2f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -962,19 +962,21 @@ static struct track *get_track(struct kmem_cache *s, void *object,
 }
 
 #ifdef CONFIG_STACKDEPOT
-static noinline depot_stack_handle_t set_track_prepare(void)
+static noinline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags)
 {
 	depot_stack_handle_t handle;
 	unsigned long entries[TRACK_ADDRS_COUNT];
 	unsigned int nr_entries;
+	/* Preemption is disabled in ___slab_alloc() */
+	gfp_flags &= ~(__GFP_DIRECT_RECLAIM);
 
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 3);
-	handle = stack_depot_save(entries, nr_entries, GFP_NOWAIT);
+	handle = stack_depot_save(entries, nr_entries, gfp_flags);
 
 	return handle;
 }
 #else
-static inline depot_stack_handle_t set_track_prepare(void)
+static inline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags)
 {
 	return 0;
 }
@@ -996,9 +998,9 @@ static void set_track_update(struct kmem_cache *s, void *object,
 }
 
 static __always_inline void set_track(struct kmem_cache *s, void *object,
-				      enum track_item alloc, unsigned long addr)
+				      enum track_item alloc, unsigned long addr, gfp_t gfp_flags)
 {
-	depot_stack_handle_t handle = set_track_prepare();
+	depot_stack_handle_t handle = set_track_prepare(gfp_flags);
 
 	set_track_update(s, object, alloc, addr, handle);
 }
@@ -1921,9 +1923,9 @@ static inline bool free_debug_processing(struct kmem_cache *s,
 static inline void slab_pad_check(struct kmem_cache *s, struct slab *slab) {}
 static inline int check_object(struct kmem_cache *s, struct slab *slab,
 			void *object, u8 val) { return 1; }
-static inline depot_stack_handle_t set_track_prepare(void) { return 0; }
+static inline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags) { return 0; }
 static inline void set_track(struct kmem_cache *s, void *object,
-			     enum track_item alloc, unsigned long addr) {}
+			     enum track_item alloc, unsigned long addr, gfp_t gfp_flags) {}
 static inline void add_full(struct kmem_cache *s, struct kmem_cache_node *n,
 					struct slab *slab) {}
 static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
@@ -3878,7 +3880,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			 * tracking info and return the object.
 			 */
 			if (s->flags & SLAB_STORE_USER)
-				set_track(s, freelist, TRACK_ALLOC, addr);
+				set_track(s, freelist, TRACK_ALLOC, addr, gfpflags);
 
 			return freelist;
 		}
@@ -3910,7 +3912,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			goto new_objects;
 
 		if (s->flags & SLAB_STORE_USER)
-			set_track(s, freelist, TRACK_ALLOC, addr);
+			set_track(s, freelist, TRACK_ALLOC, addr, gfpflags);
 
 		return freelist;
 	}
@@ -4422,7 +4424,7 @@ static noinline void free_to_partial_list(
 	depot_stack_handle_t handle = 0;
 
 	if (s->flags & SLAB_STORE_USER)
-		handle = set_track_prepare();
+		handle = set_track_prepare(__GFP_NOWARN);
 
 	spin_lock_irqsave(&n->list_lock, flags);
 
-- 
2.43.0


