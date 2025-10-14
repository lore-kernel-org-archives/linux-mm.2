Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11AB8CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 21:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55B528E014E; Tue, 14 Oct 2025 17:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532418E0090; Tue, 14 Oct 2025 17:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F238E014E; Tue, 14 Oct 2025 17:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35B8E8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:25:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6CC7160AD8
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:25:48 +0000 (UTC)
X-FDA: 83998001976.07.56EF071
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 31DA11C0002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:25:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M+B07t8n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760477147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QJcSs2MixD9Ddu+ViQQpliBg+ecuONXrJgOOzTDyEAM=;
	b=jYc6+lpZDhvHe0FJwvNJ+Cgpl5nXLn9sywTKAfSLOexAY8TLsgDvHnYU9DWgIf82u2GkQn
	9TZSMeneV8e6F8MpNyAJc3YmyVO9kJ71OCxLfGVBmMx0pzFG42ufC2Nj5XozlCHW3Y2Ug9
	4D7JSIkZE5noHEgAk/7p15qi6Qrmigg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760477147; a=rsa-sha256;
	cv=none;
	b=dmkwFyTD8H2LUWjOJFdslrHCTlTzXJKiTv8XXerqhlDlcbgJyqQbc7GtHzSocFYqZ20nXI
	oVKsyn6toRx/5KOZXiXxRo/vb4F6C3vB4y+VxgHEby2h2tHU1ZHSI2Yk+Pt5x04nF3XbKr
	tT0s69Upw5381CUVy0APMXVObndy4Fg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M+B07t8n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-27c369f898fso83849525ad.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760477146; x=1761081946; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QJcSs2MixD9Ddu+ViQQpliBg+ecuONXrJgOOzTDyEAM=;
        b=M+B07t8nlmsTAjol7gcHEw6hZiaFWRMCKbfkbu14pfx08hjPaBrYb9KSGeeCbxs/9i
         Is48LjaflRi0vVCy9H+4USDXfU+5FQt9vAaIIUkiT6naWg9QQnMDzoHye/SXhXN73nVU
         8bcYT725SCk7qr6PKtNF7ELFQgYtKxSqRh/1ZbmI4Cygi7nT5oGrE7EGd7ap3FB4sW6u
         8OyeFPEHq+EjaZhx2Mv8dO+5hj23f1Ub0NykTUL1XHOowjiwwWxoPpkA6Div6+RCWwN9
         46bpMQcF986Crrwcgd9S7C/sXmjFuOCwQ1XNAodqJd3sXmp/NmqS97CKpt6sFbJ5Xz1u
         +wNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760477146; x=1761081946;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QJcSs2MixD9Ddu+ViQQpliBg+ecuONXrJgOOzTDyEAM=;
        b=MDHckA6kytRJP4UfKQJ952Fc4cDORp2SBXIfiYbG20Z8/R0KG9lWAW3GRfK6jWj8Pl
         PZmfPRRbrznvPTQ22/wdXQJHXzLEx+ybx6sKGoaNU2JRfuw+UzHD0ULRftjqJ535+iAh
         uY3T6pUd1PmufiAo6YlTt13vtVV/6PTUqsbMXcp1LM9o0b0ZR89/eTZ+u0M572uhSew8
         UzU2SiXGEhERD0/bSzJSwutvM7qG2INQh7c4HvEWvMrozDtir9U/llcugjZLqahdA/yx
         2JsCPOkIiR6IDYZk+Bsjs71yaCF9Ak5hcxj0EDVgEcx93SL+0QVL2UHsEbMtaX7FfJeR
         vxqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpUO8bzgoHmy9et+f8DDhjbQoauAtyC3fceCNkCHoaVlSdyRZubbGOUYqGWlWjbzePXodreDKbjg==@kvack.org
X-Gm-Message-State: AOJu0YxH6X4GQz0bjBtDw2dD3O+G73PdaDjcqvXuIDXSDUryzFf9EBrT
	R8MitrT3dXtzvXvp9gDQO8DxWas/we6OUh4ANPVlE/oFIaS8XTb7ivD8
X-Gm-Gg: ASbGnctMrLfltDJY3odG+bLiunHBVQEKPTne5WCjcIRM1RGmajrOoYfHbfWRBuVAwoi
	qNbpkBQ5JwiKvjtxHKETu0Q1Km0B+1kgiU5pGm3TLoMyjgn54qohT+Af1DYhIi+ULyqZSS5lQjg
	FsSqoDIY2+FdpEIWhhdGTAAv3sUNqowCBKU7TDnTnGWjYT16QGSUtsKZpB1b2UwHne7XTbFPa2z
	/w+P/kIYCRXDasWgkF688JO/6x24n5gFpbz+4bitdO6IekMpQmBIvIZLDpAiEmko6KlhaqG9doF
	emVhWTBLhIE7sAIhp2Y8PmBA1dogEQAA2wyPWmPOTu6SftaF9PMD9eVtZwyEQ8clLf5AfAwYqFo
	5oHTAgFeKqhnuBCx11xkaECJm4t09qRBvTka+X2nJFoMszSJJa5Y1X7bIwv3KTBRFF/8UG2I=
X-Google-Smtp-Source: AGHT+IHm2e1raOsbTmENb3x5Xd6TCpwziKXblzgIgDqffemH81B8E878HilCMVF9PUA9s41E3nITDg==
X-Received: by 2002:a17:903:1b4b:b0:269:b6c8:4a4b with SMTP id d9443c01a7336-29027214ee7mr350403855ad.6.1760477145892;
        Tue, 14 Oct 2025 14:25:45 -0700 (PDT)
Received: from ast-mac.thefacebook.com ([2620:10d:c090:500::4:c3af])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f3de4asm174156995ad.92.2025.10.14.14.25.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Oct 2025 14:25:45 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@kernel.org,
	vbabka@suse.cz,
	yepeilin@google.com,
	harry.yoo@oracle.com,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org
Subject: [PATCH bpf] bpf: Replace bpf_map_kmalloc_node() with kmalloc_nolock() to allocate bpf_async_cb structures.
Date: Tue, 14 Oct 2025 14:25:41 -0700
Message-Id: <20251014212541.67930-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: f5qdf1mh8k33on49s4kauif77fkotzqt
X-Rspam-User: 
X-Rspamd-Queue-Id: 31DA11C0002
X-HE-Tag: 1760477147-228217
X-HE-Meta: U2FsdGVkX18PgtfSy/QWpVpH4Feg48ha0RRGk2i35/37oQRmiTz4bvcX3a2w6Jkl4QyA3+OeacOfgIp6Wfs5bRgN26Z0mFMoUPCvlGKsc6zPfCcNqcnuqHynG4W5TP5dhvvXNeUOQQ17hgJ73Dd04AvjFOXNPql8ymcbTZ4DejKelXaYEPR8ldOyKd9oCQYLMl9LRD8uvQfp0YsF3kLnScyXBCxY3XtNzYgBCNfnypC53rrD3dKLx8Tp9cC4KJ5y9pqEjlhxbtUo5AXrHjwAqTAlrodBXVwzh9rLVnhLtx0pJuLgdOZk7QPnBCudm3oSy4i2Y9z0qEyTeBprDtKOc3hw9f65l5eMP9eW4v8NISaYWmsD0KFvJMOyxfejflRYSBacfts+ZtQas7C29XkslDXNONer5z7E3QloKWRRhWyBxZgEwhcbRa8lBaFah/W86TuDlyXx98nMTj5Cmiv6KciONdScZ5DwvyEqIpGvHjz8LnINFZYLNdumULiok2rbTDRqJsGGrXapYvfdG1srYp3C0HK4BJhfCD7s9stwR2xYs7yHmhYQKR0PvPqT/U3QSw2SjrxP/HwgGs+rSusglUTbm2k7Tj3cjLTasBbJR3vnyFxDW5+e8bXBInaxw8b1fW4pDj5ILOwgxSXbtXPacWF9u9r90B01dU4TtCSXtDjok1yv9J2WgNseqSB0+ZK1bwrt4EcXL3vZGKz4ORmNDBdL6cuisRKIJojiXfimxLX+89RooIz0o/tgoAU3EaQWsM0WTYGy35StMUC4mSerEm0LQt0gSeudOtZCUwE61PKBDJC0uBAyQDyVJg1tg3+DLnJoO4kkbRlzie0gHU/RbbEDWx/K7DazWaYQpgHWkmfNgr05w2Ef5NNKXdxJChS5r/4+5ynEet4wELZJ0iIfdge9pY5gtL3WVa6u8d5aKCFmmiW8Rj3kIC4/hUhmUOtH2EFZ5V3lLHmS7QKuAyP
 ZmFwNuBU
 RIAXr4cngKICyhWChJ8w0iKXenFFSzczG3jcijmR+CP8RqjFF6cmdiPfwH5Oalm+D8QS5paBam9mL+ljneGMH4wgd4ah4/RvKAKxaSoT6zWmdQShRtVJf1MEV9i7xoo4fUIPpr7qRpruU/FA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

The following kmemleak splat:
[    8.105530] kmemleak: Trying to color unknown object at 0xff11000100e918c0 as Black
[    8.106521] Call Trace:
[    8.106521]  <TASK>
[    8.106521]  dump_stack_lvl+0x4b/0x70
[    8.106521]  kvfree_call_rcu+0xcb/0x3b0
[    8.106521]  ? hrtimer_cancel+0x21/0x40
[    8.106521]  bpf_obj_free_fields+0x193/0x200
[    8.106521]  htab_map_update_elem+0x29c/0x410
[    8.106521]  bpf_prog_cfc8cd0f42c04044_overwrite_cb+0x47/0x4b
[    8.106521]  bpf_prog_8c30cd7c4db2e963_overwrite_timer+0x65/0x86
[    8.106521]  bpf_prog_test_run_syscall+0xe1/0x2a0

happens due to the combination of features and fixes, but mainly due to
commit 6d78b4473cdb ("bpf: Tell memcg to use allow_spinning=false path in bpf_timer_init()")
It's using __GFP_HIGH, which instructs slub/kmemleak internals to skip
kmemleak_alloc_recursive() on allocation, so subsequent kfree_rcu()->
kvfree_call_rcu()->kmemleak_ignore() complains with the above splat.

To fix this imbalance, replace bpf_map_kmalloc_node() with
kmalloc_nolock() and kfree_rcu() with call_rcu() + kfree_nolock() to
make sure that the objects allocated with kmalloc_nolock() are freed
with kfree_nolock() rather than the implicit kfree() that kfree_rcu()
uses internally.

Note, the kmalloc_nolock() happens under bpf_spin_lock_irqsave(), so
it will always fail in PREEMPT_RT. This is not an issue at the moment,
since bpf_timers are disabled in PREEMPT_RT. In the future
bpf_spin_lock will be replaced with state machine similar to
bpf_task_work.

Fixes: 6d78b4473cdb ("bpf: Tell memcg to use allow_spinning=false path in bpf_timer_init()")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h  |  4 ++++
 kernel/bpf/helpers.c | 21 ++++++++++++---------
 kernel/bpf/syscall.c | 15 +++++++++++++++
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a98c83346134..d808253f2e94 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2499,6 +2499,8 @@ int bpf_map_alloc_pages(const struct bpf_map *map, int nid,
 #ifdef CONFIG_MEMCG
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node);
+void *bpf_map_kmalloc_nolock(const struct bpf_map *map, size_t size, gfp_t flags,
+			     int node);
 void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags);
 void *bpf_map_kvcalloc(struct bpf_map *map, size_t n, size_t size,
 		       gfp_t flags);
@@ -2511,6 +2513,8 @@ void __percpu *bpf_map_alloc_percpu(const struct bpf_map *map, size_t size,
  */
 #define bpf_map_kmalloc_node(_map, _size, _flags, _node)	\
 		kmalloc_node(_size, _flags, _node)
+#define bpf_map_kmalloc_nolock(_map, _size, _flags, _node)	\
+		kmalloc_nolock(_size, _flags, _node)
 #define bpf_map_kzalloc(_map, _size, _flags)			\
 		kzalloc(_size, _flags)
 #define bpf_map_kvcalloc(_map, _n, _size, _flags)		\
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index c9fab9a356df..c5f63f2685e9 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1215,13 +1215,20 @@ static void bpf_wq_work(struct work_struct *work)
 	rcu_read_unlock_trace();
 }
 
+static void bpf_async_cb_rcu_free(struct rcu_head *rcu)
+{
+	struct bpf_async_cb *cb = container_of(rcu, struct bpf_async_cb, rcu);
+
+	kfree_nolock(cb);
+}
+
 static void bpf_wq_delete_work(struct work_struct *work)
 {
 	struct bpf_work *w = container_of(work, struct bpf_work, delete_work);
 
 	cancel_work_sync(&w->work);
 
-	kfree_rcu(w, cb.rcu);
+	call_rcu(&w->cb.rcu, bpf_async_cb_rcu_free);
 }
 
 static void bpf_timer_delete_work(struct work_struct *work)
@@ -1230,13 +1237,13 @@ static void bpf_timer_delete_work(struct work_struct *work)
 
 	/* Cancel the timer and wait for callback to complete if it was running.
 	 * If hrtimer_cancel() can be safely called it's safe to call
-	 * kfree_rcu(t) right after for both preallocated and non-preallocated
+	 * call_rcu() right after for both preallocated and non-preallocated
 	 * maps.  The async->cb = NULL was already done and no code path can see
 	 * address 't' anymore. Timer if armed for existing bpf_hrtimer before
 	 * bpf_timer_cancel_and_free will have been cancelled.
 	 */
 	hrtimer_cancel(&t->timer);
-	kfree_rcu(t, cb.rcu);
+	call_rcu(&t->cb.rcu, bpf_async_cb_rcu_free);
 }
 
 static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u64 flags,
@@ -1270,11 +1277,7 @@ static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u
 		goto out;
 	}
 
-	/* Allocate via bpf_map_kmalloc_node() for memcg accounting. Until
-	 * kmalloc_nolock() is available, avoid locking issues by using
-	 * __GFP_HIGH (GFP_ATOMIC & ~__GFP_RECLAIM).
-	 */
-	cb = bpf_map_kmalloc_node(map, size, __GFP_HIGH, map->numa_node);
+	cb = bpf_map_kmalloc_nolock(map, size, 0, map->numa_node);
 	if (!cb) {
 		ret = -ENOMEM;
 		goto out;
@@ -1607,7 +1610,7 @@ void bpf_timer_cancel_and_free(void *val)
 		 * completion.
 		 */
 		if (hrtimer_try_to_cancel(&t->timer) >= 0)
-			kfree_rcu(t, cb.rcu);
+			call_rcu(&t->cb.rcu, bpf_async_cb_rcu_free);
 		else
 			queue_work(system_dfl_wq, &t->cb.delete_work);
 	} else {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2a9456a3e730..8a129746bd6c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -520,6 +520,21 @@ void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 	return ptr;
 }
 
+void *bpf_map_kmalloc_nolock(const struct bpf_map *map, size_t size, gfp_t flags,
+			     int node)
+{
+	struct mem_cgroup *memcg, *old_memcg;
+	void *ptr;
+
+	memcg = bpf_map_get_memcg(map);
+	old_memcg = set_active_memcg(memcg);
+	ptr = kmalloc_nolock(size, flags | __GFP_ACCOUNT, node);
+	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
+
+	return ptr;
+}
+
 void *bpf_map_kzalloc(const struct bpf_map *map, size_t size, gfp_t flags)
 {
 	struct mem_cgroup *memcg, *old_memcg;
-- 
2.47.3


