Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 467D8CA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 02:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B8176B0028; Fri, 29 Aug 2025 22:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2674D6B0029; Fri, 29 Aug 2025 22:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A45A6B002A; Fri, 29 Aug 2025 22:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09C9D6B0028
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:10:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE251BC5FD
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:10:03 +0000 (UTC)
X-FDA: 83831793486.09.3EB396A
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0FFF280004
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:10:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=APFiyrNV;
	spf=pass (imf30.hostedemail.com: domain of yangshiguang1011@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756519802; a=rsa-sha256;
	cv=none;
	b=LE8r2QlN7UveB9JWEg8pIeLrYHpq3dwODJtaq+24sQIpa2hqE5vN6U0pRSXIaqSOdCcAE7
	hMmk9BfKpBEPqQxu9fpxvBfzLy6nw8CGGmU/PJNjgEAEF3UswZebJNJBA9Jm2yrK+SBBjd
	gBEQYxR4tgXjnHb6olVJrcNwX/vkPNE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=APFiyrNV;
	spf=pass (imf30.hostedemail.com: domain of yangshiguang1011@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756519802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ASv08vHQn45ozfOFbV1Do6M+K0ucRdNAA7jLQeJT/8U=;
	b=lqSS9mzzxZI1jF8/QS6m+WxWoMx4/la9jlwExzDZmSiQrUkWBQu6+L4dss+5iCJkNxhJ8g
	cXbq/7+9bxH7vPOEO206LxjfYopWLsMbiWD1+P04C86FViuLmBWgVyyKhBa9vUkY1EXh9V
	yvYQyWuZOVBzY0Aa1/b1ZFd6JMa1WzQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=AS
	v08vHQn45ozfOFbV1Do6M+K0ucRdNAA7jLQeJT/8U=; b=APFiyrNVb4c7aV6a8k
	JG6DpZhswdBvQZFZWTblA72C4RtACC2H6auLg3hjhN24bUppzpeZk+prPigeAez+
	2ev9W769XFd+KsWGLphG1sjIb1HQfYobxKScnwAV+c2vBRBfKyKgqJPt1G01mOCt
	6xZ0SHel2OFkyKc1C/0EVsk+U=
Received: from mi-work.mioffice.cn (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3tz1sXbJoSlsQFA--.37283S4;
	Sat, 30 Aug 2025 10:09:49 +0800 (CST)
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
Subject: [PATCH v4] mm: slub: avoid wake up kswapd in set_track_prepare
Date: Sat, 30 Aug 2025 10:09:46 +0800
Message-ID: <20250830020946.1767573-1-yangshiguang1011@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3tz1sXbJoSlsQFA--.37283S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jr43XFWkKF1UCFWkWryUWrg_yoW7tF4rpF
	W7WFy3tF48AF1jvFWUCa1Uur1SvrZ3CrW8CF43Wa4rua4Yvr48WFW7tFyjqFW5Arykua1q
	k3W09Fn3Ww4jqaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07ju0PDUUUUU=
X-Originating-IP: [1.202.162.48]
X-CM-SenderInfo: 51dqw25klj3ttqjriiqr6rljoofrz/1tbiSB655WiyUD3O3wAAss
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0FFF280004
X-Stat-Signature: xk19axnx4izmzjej3j86y1miq9r9gy6c
X-Rspam-User: 
X-HE-Tag: 1756519800-535687
X-HE-Meta: U2FsdGVkX1+xDbffW9/qhl6CyyE4JClljujsFSAL2LgHZEZmaobnVwQmURl55+yEVcKWabvqtIg4rnoiW1X6TMGVVWcuteBLwFV52KfLiedbubGwOxQPleYuvV6edVV93yYD+lHLn6yOWVtaZk73qRIVS5i3QvghoBdd+p1SJ7LoNFRn+Mn6shv7CsPFUv+MTz5X2feh0k4E8lJlOi1pMjStpf+fYVNygIZfpKtEuJVJNNVGR+HWQVW1Tstya1aoOX6lN4cXcqo91g+gcXDadKyWHCOC4AY4IeNAz0oHF3S4Xhm4Ql/xvmIwcKFj+UjvBKZP8ccNTU9b1+AVydYwl1+lvu3UwI8XVw2X1AQWAYZH9Sd2wUyckeKJEP8lRuF3GhXWmuXs/X6r78/wndPKGlyEd+5znPfE/UBCBq3sDmRzLUmNw/mGlLCl8ozzmenLnTCBgjItGlqVbYCtxhvR+pbPEmmO6+UbgvjLVEFG9X9qDPBQHsISTVK8wUDOwsNCSwchhXE5LvNrOv7AkY+NTWSarZqVQJBUYmncDtZ0O6lRqGzcg1sXjBr5bKD1KehtSo9tepPhA5p5W6kp88oFIBK/X/yar1zP+AjAwv2wK55EPAlfrGaefgct6p/V+DpCfduSQSS65fAVU10kiowpVTYSKxogNbNl3jL+bc41hEomkMAiQR/cYt/Wehte13iJYAKgT1SnW7A/DF/JSqbizJdGQ4vLVfkjt7R9JEmQnbqRKQrRuJCwQQd9Iev1/my77z2KcDUmB90eOveolzNptDTvTe7GIiXVqVSMvkBbVsFnKqrNrFnduJFQlbdN2gyu0QLRNxR4jW7wUwi11YCkCe7WUDUcVe6qhSTrVmgupjM4IPWVNJqWNr9uCeukPN3u9qQTlz4Qajnu20DczDstRBo8zCxWJ8l2zu+CQYfH/bf0ydbgzjZhbkWC2VtL/P5lvDVaDAW3wjTilbgtTps
 P2lPD7wt
 IyScBzFxaAZwHp2Surn2vAjdmEAbNC0FDxEETQ9YA4Yl171XN+318TFxZtpyv1YfI5wyo1hcAlhZ9KQV80pbmsx8e9R8uaDwDgDsvG3dmz6O3wGH6JY8cO9bM1+Kuf+PHjgTUM6h+vcZV+fs=
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
passing in allocation flags. And the slab caller context has
preemption disabled, so __GFP_KSWAPD_RECLAIM must not appear in gfp_flags.

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
v3 -> v4:
    Re-describe the comments in set_track_prepare.

[1]https://lore.kernel.org/all/20250801065121.876793-1-yangshiguang1011@163.com/
[2]https://lore.kernel.org/all/20250814111641.380629-2-yangshiguang1011@163.com/
[3]https://lore.kernel.org/all/20250825121737.2535732-1-yangshiguang1011@163.com/
---
 mm/slub.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 30003763d224..b0af51a5321b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -962,19 +962,25 @@ static struct track *get_track(struct kmem_cache *s, void *object,
 }
 
 #ifdef CONFIG_STACKDEPOT
-static noinline depot_stack_handle_t set_track_prepare(void)
+static noinline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags)
 {
 	depot_stack_handle_t handle;
 	unsigned long entries[TRACK_ADDRS_COUNT];
 	unsigned int nr_entries;
+	/*
+	 * Preemption is disabled in ___slab_alloc() so we need to disallow
+	 * blocking. The flags are further adjusted by gfp_nested_mask() in
+	 * stack_depot itself.
+	 */
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
@@ -996,9 +1002,9 @@ static void set_track_update(struct kmem_cache *s, void *object,
 }
 
 static __always_inline void set_track(struct kmem_cache *s, void *object,
-				      enum track_item alloc, unsigned long addr)
+				      enum track_item alloc, unsigned long addr, gfp_t gfp_flags)
 {
-	depot_stack_handle_t handle = set_track_prepare();
+	depot_stack_handle_t handle = set_track_prepare(gfp_flags);
 
 	set_track_update(s, object, alloc, addr, handle);
 }
@@ -1921,9 +1927,9 @@ static inline bool free_debug_processing(struct kmem_cache *s,
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
@@ -3878,7 +3884,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			 * tracking info and return the object.
 			 */
 			if (s->flags & SLAB_STORE_USER)
-				set_track(s, freelist, TRACK_ALLOC, addr);
+				set_track(s, freelist, TRACK_ALLOC, addr, gfpflags);
 
 			return freelist;
 		}
@@ -3910,7 +3916,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			goto new_objects;
 
 		if (s->flags & SLAB_STORE_USER)
-			set_track(s, freelist, TRACK_ALLOC, addr);
+			set_track(s, freelist, TRACK_ALLOC, addr, gfpflags);
 
 		return freelist;
 	}
@@ -4422,7 +4428,7 @@ static noinline void free_to_partial_list(
 	depot_stack_handle_t handle = 0;
 
 	if (s->flags & SLAB_STORE_USER)
-		handle = set_track_prepare();
+		handle = set_track_prepare(__GFP_NOWARN);
 
 	spin_lock_irqsave(&n->list_lock, flags);
 
-- 
2.43.0


