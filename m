Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F31ACA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8398E0020; Mon,  1 Sep 2025 04:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBF738E0012; Mon,  1 Sep 2025 04:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC298E0020; Mon,  1 Sep 2025 04:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF7E68E0012
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:46:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5ECE085DDB
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:46:31 +0000 (UTC)
X-FDA: 83840050182.11.F232A16
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf07.hostedemail.com (Postfix) with ESMTP id AA4ED40003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:46:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="bmXl/6tW";
	spf=pass (imf07.hostedemail.com: domain of yangshiguang1011@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756716389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=25MhXLNm+7a14v6gcmGlJ6+jZMzm6fx0npG3qsB1wec=;
	b=4orMh65u9ivXsULX+HCjGuBln+oFLWi9xplYYsDyIqSbpDEraLfBwUiOnaJ75xnEpMXf38
	IvfBvKn5LTrUu0R/V1vPeAx0oiqQjQsT51m+dl5aZD+2aaEYIxC1OXzTDwwPc10V3btK/M
	o+ad93awh2U2YMqOJbX+c7F8sf5zWDQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="bmXl/6tW";
	spf=pass (imf07.hostedemail.com: domain of yangshiguang1011@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756716389; a=rsa-sha256;
	cv=none;
	b=yHYOvSvlZjMmEtI0ozLB0LfH1PDT1UYip6EhRe4p4T9p6Du30J4XU0oEKEhoz8BcN3nAn6
	PQPGSF2Jn/B2qLtKf0vAQqL5HVPtDA6gqX3ZCTrt3lsFuovu7dpaYrFjkSRABRPvc6lERl
	MZrNbcruXa3G5WzYKHw1WEX4S8IYAcA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=25
	MhXLNm+7a14v6gcmGlJ6+jZMzm6fx0npG3qsB1wec=; b=bmXl/6tW/cokMs+lIc
	SQM8o9S9qjiJn327ME7OIO2cbJ0HIqiAMySslj38AFpP/LfSAGCBYbdcaHSWyDoQ
	GD15i3HE088xZpTvY8KTUn5lndn/pjG02lVIJF/WRM4eKXO0WFOhFg2r1QXmxGDe
	NamFmBnm6M6VJCxpz9QhXlRXU=
Received: from mi-work.mioffice.cn (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wDXj+1YXbVoQg0oFw--.13402S4;
	Mon, 01 Sep 2025 16:46:18 +0800 (CST)
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
Subject: [PATCH v5] mm: slub: avoid wake up kswapd in set_track_prepare
Date: Mon,  1 Sep 2025 16:46:01 +0800
Message-ID: <20250901084601.96740-1-yangshiguang1011@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXj+1YXbVoQg0oFw--.13402S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jr43XFWkKF1UCFWkWryUWrg_yoW7KryUpF
	W7WFy3JF48AF1jvFWDCa1Uur1SvrZ3CrW8Cr43Wa4rua4Yvr48WFZrtFyjvFW5ArykuanF
	y3W09Fnagw4jqaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jnxhLUUUUU=
X-Originating-IP: [1.202.162.48]
X-CM-SenderInfo: 51dqw25klj3ttqjriiqr6rljoofrz/1tbiEAG75Wi1VZrtiQAAs5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA4ED40003
X-Stat-Signature: i1w6nmhrwhwcnjurt8wiwdkgjpkg3167
X-Rspam-User: 
X-HE-Tag: 1756716388-870821
X-HE-Meta: U2FsdGVkX18NoqBfO3BmUV0t/JZa9+x6XW2ttNWcfIdE+WlrktzAhgGI4PeLgP2VL9pGPekydmlH5yk1vQcnplUeO1eGz2OiFPsZKp4vfLbqmUyYP4dV3T8IxuQF7Ii1qDW4qMvXlLZIhQGYLEyWv39OSf+Le8aaqFs5PyPj6uRjlt6qWrt/knv0M1iy4fGQm1e+Dj4IuxvHRD+OKPtCLGFnW/xTrYiTXSWKOFrCJjUrxSujM7SaBfLRhu8ieD93VojwoNADikkaeaTW9H3bsT8T2Y47bgCLtvoHhywxK0bBebqwRl4L4W/zyfxitLlJCwi0ASfyP1Sv9KUeLFgqhcX72AGZSpWjZaVV6/Y/XRbdw8Ke8ezStSHsrcCnemoCw53/U90SH/2kEcYLIBcVGSzwfhznd20QDPf8ewQmuYPB4re19FHo5DFzsOhLuPSxzOSUEge1WVRDWqUcAC/C7S0a3QpY+Hke8buQeJEsCWNlfGGkM9rU2yateE8BEC6LJtEcVlAhppBnDDVammn+NB404LSUMKA+LXqPme8HfB87xnzL8m17jFmG4CgxILxxucDD/nCiwYJ5yaO4DvNvgksbRSwDgSwML3GvrdMmTeHQkaYhTG/RhdS6nO5dKDttILHj8XplflY0zuC8gr6QpmPnJ842pkO+Pg8QUZCSLGp4CYpQ+G2l3l1L5dZYN4Thu4b29xmY6bSqzU+LQ0RBLLjHVTt6hj0jmeWNn40pXPY1HOl24eGSsfhmluOA2BKLqTCwgD/xsNx6DAH3K+6APwASvn4A4RLWz9gFEG525mFEp9ad8etfnxjbFvsDRrSMnrA7INCgqcwVHAoo/M5TuxBwgPOm4koLQsdEqy3/lGF+mxdp3ChGtKUdkUFLzGdFmxXUjAZMFKjkubrEAaFbhcTHEBBfxbtDom3EaANldbKxK0r7vgdFjHR2nmZMQH70UltCaabIWMfT6FXTgUV
 8dBhz02F
 0pXK6MyIaXMnsAoQC6YRN+slE9yvu08QerWyDcdjuznihJVQ45HltXpkPsYKMyAiqvI7S4qfR3j7uFEy8Ct84YHrr1KRvVMSeg7VqB2QbgZTg8QevWI92Zef9ss/a2HxNGChiAn6GbSv82BvTz/DXiyma1puDS6IhuGCU8/4WQgN2ZmduwJExJYikxHlGkvwn48D0GC4/Mil/3ryngi0aFWB5sIhj3PJE1paR/o0yN5Q10guMkw4UEmxEVa4JpFlAjMDYKns5Tnb2Buvd/efmUMRqo5cYTfS7dvEhUQ5e/XPUggPGf9G/etABDL34+lzCoZxmptgReUXOIyy6ArjuqqAwUD47bINM87fxNpYLhh0mcTlxUiwlF9NbD9B5HeabyiRX0co+ZNHhEGz5LylKBlJ6GfAW9Ds2BZAv+pHUxd2ySpdDcdkHdkcYU7iyg3wYrykEKZP25thAHTvdZEb1yj2U5AcfRDLH+l/GgjvB1u1uHeKiYAeag4JfM5RTg+62l+f7gdBLjNiTX8Ej4k8AkypJH7I8gH0GsE1Jmi2vCHCA8W7dRIvie2m41tLcEUgG1eKh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yangshiguang <yangshiguang@xiaomi.com>

set_track_prepare() can incur lock recursion.
The issue is that it is called from hrtimer_start_range_ns
holding the per_cpu(hrtimer_bases)[n].lock, but when enabled
CONFIG_DEBUG_OBJECTS_TIMERS, may wake up kswapd in set_track_prepare,
and try to hold the per_cpu(hrtimer_bases)[n].lock.

Avoid deadlock caused by implicitly waking up kswapd by
passing in allocation flags. And the slab caller context has
preemption disabled, so __GFP_DIRECT_RECLAIM must not appear in gfp_flags.

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
v4 -> v5:
    Modify the patch commit.

[1]https://lore.kernel.org/all/20250801065121.876793-1-yangshiguang1011@163.com/
[2]https://lore.kernel.org/all/20250814111641.380629-2-yangshiguang1011@163.com/
[3]https://lore.kernel.org/all/20250825121737.2535732-1-yangshiguang1011@163.com/
[4]https://lore.kernel.org/all/20250830020946.1767573-1-yangshiguang1011@163.com/
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


