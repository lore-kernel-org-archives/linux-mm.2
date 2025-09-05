Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A28DCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 23:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B52808E000A; Fri,  5 Sep 2025 19:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27FE8E0002; Fri,  5 Sep 2025 19:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E598E000A; Fri,  5 Sep 2025 19:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5558E0002
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:46:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1130D1402CA
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:46:17 +0000 (UTC)
X-FDA: 83856832794.14.75EA597
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 58F7F40002
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:46:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YGiNFq5z;
	spf=pass (imf04.hostedemail.com: domain of 3Rna7aAgKCG0jPaPTWTYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--yepeilin.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Rna7aAgKCG0jPaPTWTYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--yepeilin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757115975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ka3pAMib8mg56UcIRiGYQOnsatMqr/ASQE3iJhG8eFo=;
	b=LxwjiWzmU/7s1vdaa9XQ3XDIZll+jwV4z4z3Z1xZy7VhF/Yy4k9lwtP429O8FiIKoeevGn
	eyjg7IwxP9mpJ8/fkq7cg6yQMuJ2/yCuEidNBeTkr8d8SG2KG6vpnXkVK9AGy0xkYDZqzz
	o8V4GfdIiAsMsXdeL4BCldl9VL49+TM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YGiNFq5z;
	spf=pass (imf04.hostedemail.com: domain of 3Rna7aAgKCG0jPaPTWTYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--yepeilin.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Rna7aAgKCG0jPaPTWTYRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--yepeilin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757115975; a=rsa-sha256;
	cv=none;
	b=sP18McJHrwetmGTrKbtD215grAcUP5Qmn3K/fM0hVhgtmDQwab6Ky40VRXGZt4Z8HFzjdD
	mkM9rDEYq+LNRvJbjs1RrEEX4+sNEJqux1v1ABnUtE36NNWzPUygNy41YOGmLEOc/dROgL
	/Kc50qXvpeabn7JJDNEXNZAx0sDORRM=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24afab6d4a7so51268205ad.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 16:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757115974; x=1757720774; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ka3pAMib8mg56UcIRiGYQOnsatMqr/ASQE3iJhG8eFo=;
        b=YGiNFq5zhjIhXiOI1WuhZp/KsqkFxCJ6gWvevqN6QX3ysfJNns4ahBfpd02aj4PsCH
         px2vPjZKxklbfOJPxDmAiIhZn/QIf5sSjpQgoDn/0bV4znXx/Zb2NYSLIjGqiKRHRBbr
         XXswiDpcPUH1AyrDwv7YxaDhiEXxVZcGGOaDBPqx5NQPu+vXOuEJdirJTWETZvrWYcoM
         /cOVhPnTUmPUAoaiCFsOLtTMcJod0/j8hV7btsisJD1KpoGeufD8MGM9MWRfU78NT5n3
         me03Cio7gr+VTw2qqR0K9yMaQDI/MTsp0vDqpr8OTxFF5MOgb/EiT2ZlxOluglOnj6VH
         gsJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757115974; x=1757720774;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ka3pAMib8mg56UcIRiGYQOnsatMqr/ASQE3iJhG8eFo=;
        b=Mmi/3cdBzmVGV5j2MlE9VQN3IrxhdaTvdiXGuWtWSckC9OqxAfNw4Tr94z9G5VPtlj
         2S6ol6ZkPoemB0blloADgwAiz6U5FxQdkF2cd965W3uxvAg21riVywSWkJRAgivQ1e/f
         5AfqRxnCVTWJVZb8un0xY6tjAFCoxLqfFXkOs5l9H61ldA31Kjz2AbVqpZMRmaovAZVN
         mgAOIFvdLi9xmMQkfN3fP2qymVpNz40Of7U4Lr6oJdjcGXBzNR8dKFJEN42ORWvMlVkZ
         l8Wbl67FvAEw3ptl27Xa3xWlkZ2JBmNo5G1q32Rgqupljvlw/W2svRSdgPw7icr0+Crb
         MWCg==
X-Forwarded-Encrypted: i=1; AJvYcCUXj6JWEABlbEOF4uLmqf0Cle4n9mTRLDE4Li6yfCRDGRCVKYznnnDxDgjKGJKrjdW6sjUu2mP0gw==@kvack.org
X-Gm-Message-State: AOJu0Yx5VqlUciBlxKBaQzJ3uqgc8DNoIYW/ltJS8feHdSW57QyDGgUT
	d1nEQKHn2OWb+2MK+1CQDQ19rk7ZkRRkGWbAZNOMyQRckr1mjE/Qi7I1N5QekT63zNTIEO/C6tt
	0T1xb9ZjEkxzkSQ==
X-Google-Smtp-Source: AGHT+IGrorJIHwVe08/3eXVVnnu3ROgHDFhtPU55HCU9Hj6LhTj/S95ofHRY3+PvYuo9S+ud8faNhgZS8ou1Bw==
X-Received: from plrp10.prod.google.com ([2002:a17:902:b08a:b0:243:31a:f8e2])
 (user=yepeilin job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:138a:b0:24c:9e2d:9a13 with SMTP id d9443c01a7336-25170772b3amr5276615ad.27.1757115974045;
 Fri, 05 Sep 2025 16:46:14 -0700 (PDT)
Date: Fri,  5 Sep 2025 23:45:46 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.355.g5224444f11-goog
Message-ID: <20250905234547.862249-1-yepeilin@google.com>
Subject: [PATCH bpf] bpf/helpers: Use __GFP_HIGH instead of GFP_ATOMIC in __bpf_async_init()
From: Peilin Ye <yepeilin@google.com>
To: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Peilin Ye <yepeilin@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Josh Don <joshdon@google.com>, 
	Barret Rhoden <brho@google.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 58F7F40002
X-Stat-Signature: 9rt76hf53k4ojwkgz1froms3wfoh3sqz
X-Rspam-User: 
X-HE-Tag: 1757115975-894091
X-HE-Meta: U2FsdGVkX19nJdPkFBGnvn8VNHf0n4cLUi9W3/9+XVhEzq6VxaLyEPtVcdMFvq8xFICWCBwTW7T7Qi7y5RaIjPc4w4OpsPgoj9vp9zjyK/HAOHS2V+AnenY9JM+J6PGSWrkdhP1PgMbFvJVcGcq5ISWFlNKgINAY94F7mL4i8lIgg+TUrXw8DvIS2hybEWzB+vK0RDlneO8H6Qm96UqpNjohA2783By1RVRp0xe4zRzHH48g8r54o/angWwMwR3bK0QxLrGbItBU8O4COWitiofYGniR0pAVdQVst2weKLYIfRTVOAWIsZWGorYura0YjBVErWNLmgWhn9RpLq3/djWBoTggbIKzWxkvPZNVslk94PcwhdrEjT5/nyrpWkjM3TLzWZDM2PifSeD+j0ypBMyhHzFF9mWgXXwPBs2K2JonUfyhsiyIiOBksHf49lEmAyAVZU0l3MbuswxeN/iLoFb0cqgRgMKCrQjuU/6waSbG5MK49Mgcz7RujfP56nMFQzbycr1Qkq8ZZnHFJsuSazviLMo7e8qgLfBKCyUaGbMW+qfTkTgTDGrCpDVeP0qfS67Mviq/7V/nUUH1RqEWe57fLocoOI5fcguwy896rY+V5K3tkxy490RnMFM2xx92Le7Bz2iD0TV4lZsVFI2RuHVfN5Shu2zGwCf3faKTvnv9b45mRzYCigymeLZJZZnaxRSyoGeWWidX5C9gzjFK/l941CF4EfUtwe2DNnlu53VzB4r/yhfnBlInzm+/a5c8uOLoSjuX3xGf8M66BkY8dZSDdM5vA8AhNMS0ztMDp7UFQhA3EbJCWfpBVbf8Wjwqct0e+oQ5M4gEu5lGK2TL6n97JBC91YWRd4HpoXcY5X0peDEfzL2eOBALXrQ/0/gwvfr9pRLyctCXpSSdkI1YN5X+n2ROlZCIXkQ9v58kCrIoFfDOq5jTF6luWgZWPCWRhrQvf6CN+q4dfo0U6wj
 uGwzctl2
 XghZUQwbL7u+mCqAGb/PKaPi8mAlA3enURxyXFMqjgU+jlTcT9iemrugO8SKAw98KEx3lNdBc0dheXyOlJFXZOJYsGO22wvTd5cyd08ACaMSjyT9n0Xf5zSpCHdUeUmAdKWmpETdwyFOdR64diaT4DrJKb8KMgHUG0SB+FTas8ghNBd1f+oWEMBvVBvoemG6r4MSQm7ncaIpcdec6GxasJUR23wEqirPIEwOLrs1yyLpOcHe3O0BHVDLmTo+PeyKaCKnlCvmt9FW1nALxxwa3xX6w0a/GAhfNV93X14JjIikzhyMIxdizlc+leL/1NVgnqkwzw7I43oyzYL8L5sbZ7ZMQ7TW/sovl5TOlV6SdwtHxA7x40aotCDIntEuRysm0W/jJR7XHT3x0yLVsIC4kakW8iwINhJm4KzJYVLluZ4au4nlMgzLnnfAceadAF1O54SSZM+GBOvrDWtDmOMiYHrVouDTQckjHMMdB02/ENCYsJEadbvZyMFLPpmb8AAFd+j9Mr2fGcUQxdoM/UCC63HWu4c74Gt7Zrk4IpKUDGnOYnkBKX95KLS1aFeJssZ9FoR2KLXcYhQ+1t+1NU6ZYpe60e1TjsZO4Bg4Tys3W4za2V9x6ttJy0naHavcpzAedIN/h6Y58AYgsq9GRbGGHmU7qvFxrAnyvGa5IUxdUod3I9HQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, calling bpf_map_kmalloc_node() from __bpf_async_init() can
cause various locking issues; see the following stack trace (edited for
style) as one example:

...
 [10.011566]  do_raw_spin_lock.cold
 [10.011570]  try_to_wake_up             (5) double-acquiring the same
 [10.011575]  kick_pool                      rq_lock, causing a hardlockup
 [10.011579]  __queue_work
 [10.011582]  queue_work_on
 [10.011585]  kernfs_notify
 [10.011589]  cgroup_file_notify
 [10.011593]  try_charge_memcg           (4) memcg accounting raises an
 [10.011597]  obj_cgroup_charge_pages        MEMCG_MAX event
 [10.011599]  obj_cgroup_charge_account
 [10.011600]  __memcg_slab_post_alloc_hook
 [10.011603]  __kmalloc_node_noprof
...
 [10.011611]  bpf_map_kmalloc_node
 [10.011612]  __bpf_async_init
 [10.011615]  bpf_timer_init             (3) BPF calls bpf_timer_init()
 [10.011617]  bpf_prog_xxxxxxxxxxxxxxxx_fcg_runnable
 [10.011619]  bpf__sched_ext_ops_runnable
 [10.011620]  enqueue_task_scx           (2) BPF runs with rq_lock held
 [10.011622]  enqueue_task
 [10.011626]  ttwu_do_activate
 [10.011629]  sched_ttwu_pending         (1) grabs rq_lock
...

The above was reproduced on bpf-next (b338cf849ec8) by modifying
./tools/sched_ext/scx_flatcg.bpf.c to call bpf_timer_init() during
ops.runnable(), and hacking [1] the memcg accounting code a bit to make
a bpf_timer_init() call much more likely to raise an MEMCG_MAX event.

We have also run into other similar variants (both internally and on
bpf-next), including double-acquiring cgroup_file_kn_lock, the same
worker_pool::lock, etc.

As suggested by Shakeel, fix this by using __GFP_HIGH instead of
GFP_ATOMIC in __bpf_async_init(), so that if try_charge_memcg() raises
an MEMCG_MAX event, we call __memcg_memory_event() with
@allow_spinning=false and skip calling cgroup_file_notify(), in order to
avoid the locking issues described above.

Depends on mm patch "memcg: skip cgroup_file_notify if spinning is not
allowed".  Tested with vmtest.sh (llvm-18, x86-64):

 $ ./test_progs -a '*timer*' -a '*wq*'
...
 Summary: 7/12 PASSED, 0 SKIPPED, 0 FAILED

[1] Making bpf_timer_init() much more likely to raise an MEMCG_MAX event
(gist-only, for brevity):

kernel/bpf/helpers.c:__bpf_async_init():
 -        cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
 +        cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC | __GFP_HACK,
 +                                  map->numa_node);

mm/memcontrol.c:try_charge_memcg():
          if (!do_memsw_account() ||
 -            page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 -                if (page_counter_try_charge(&memcg->memory, batch, &counter))
 +            page_counter_try_charge_hack(&memcg->memsw, batch, &counter,
 +                                         gfp_mask & __GFP_HACK)) {
 +                if (page_counter_try_charge_hack(&memcg->memory, batch,
 +                                                 &counter,
 +                                                 gfp_mask & __GFP_HACK))
                          goto done_restock;

mm/page_counter.c:page_counter_try_charge():
 -bool page_counter_try_charge(struct page_counter *counter,
 -                             unsigned long nr_pages,
 -                             struct page_counter **fail)
 +bool page_counter_try_charge_hack(struct page_counter *counter,
 +                                  unsigned long nr_pages,
 +                                  struct page_counter **fail, bool hack)
 {
...
 -                if (new > c->max) {
 +                if (hack || new > c->max) {     // goto failed;
                          atomic_long_sub(nr_pages, &c->usage);

Fixes: b00628b1c7d5 ("bpf: Introduce bpf timers.")
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Peilin Ye <yepeilin@google.com>
---
 kernel/bpf/helpers.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index b9b0c5fe33f6..508b13c24778 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1274,8 +1274,14 @@ static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u
 		goto out;
 	}
 
-	/* allocate hrtimer via map_kmalloc to use memcg accounting */
-	cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
+	/* Allocate via bpf_map_kmalloc_node() for memcg accounting. Use
+	 * __GFP_HIGH instead of GFP_ATOMIC to avoid calling
+	 * cgroup_file_notify() if an MEMCG_MAX event is raised by
+	 * try_charge_memcg(). This prevents various locking issues, including
+	 * double-acquiring locks that may already be held here (e.g.,
+	 * cgroup_file_kn_lock, rq_lock).
+	 */
+	cb = bpf_map_kmalloc_node(map, size, __GFP_HIGH, map->numa_node);
 	if (!cb) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.51.0.355.g5224444f11-goog

