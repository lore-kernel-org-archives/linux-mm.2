Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E70CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14792900142; Thu, 14 Aug 2025 07:17:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FC4900121; Thu, 14 Aug 2025 07:17:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CCA900142; Thu, 14 Aug 2025 07:17:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E4DB9900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:17:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF1DD59D83
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:17:28 +0000 (UTC)
X-FDA: 83775112176.02.E851864
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2836880009
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:17:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LhIyxLw3;
	spf=pass (imf30.hostedemail.com: domain of yangshiguang1011@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755170247; a=rsa-sha256;
	cv=none;
	b=xhEGb4etA4VrxKZzBVsqp7rNS277eCBPuJTS+P6FjbjYsk2JBw39CaTWF/xQAPpKMVL7BI
	fNCfayhKQ4irOd1E7eIAf6mh50rubVkHxG30vC5H8mz2wOqHQYgGjxkqYWqOYgoJVS+PyC
	3ieDX2TwxOOYk4qAJURC80TrM7+KHuo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LhIyxLw3;
	spf=pass (imf30.hostedemail.com: domain of yangshiguang1011@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755170247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=E02voVBQAU1rJD41PTsszXfus1cHekX350eLoFLGHrY=;
	b=3Mp6mg6G4P5lGW/7M2dhGXNdgX2u9It/Q2mhHW8DTc3x8QJ+DOTaw488nNw1/e9GUiT5YG
	miBgeK6hlO7gGoC8Nn2GJGf7Dg6ICDQjweKC+QyBe5F6YxYYktZhC7tM2/nH+VjhJt1YZ/
	+MoPRhDWvKkIwUSSDqpggkMn4fbVNTw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=E0
	2voVBQAU1rJD41PTsszXfus1cHekX350eLoFLGHrY=; b=LhIyxLw3gMDvP7o+qj
	XhM+eOjzEBncHGNWm1AsBj1VRIW/TTvyjIL/2fVEWorzr3XrVES85ckEnp9FjG6D
	YPGbw/nW34SQ9uKxI5Nw14/tCvPRKMCnEop03kYYkX4GAKTwuzEhGzR1QJWRv7QM
	1sJ9DdNyj86j/NryHBVaHa6sw=
Received: from mi-work.mioffice.cn (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wA3sla6xZ1ofjt8Bw--.11362S4;
	Thu, 14 Aug 2025 19:17:15 +0800 (CST)
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
	stable@vger.kernel.org,
	yangshiguang <yangshiguang@xiaomi.com>
Subject: [PATCH v2] mm: slub: avoid wake up kswapd in set_track_prepare
Date: Thu, 14 Aug 2025 19:16:42 +0800
Message-ID: <20250814111641.380629-2-yangshiguang1011@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3sla6xZ1ofjt8Bw--.11362S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jr43XFWkKF1UCFWkWryUWrg_yoW7XFyrpF
	W7GFy3JF48JryjqFWUAw4Uur1SvrZ3CrW8CF43Wa4ruFyYqr48GFW7tFyjvFWrArykuanF
	ka1UuFn3Ww4UZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jZTmDUUUUU=
X-Originating-IP: [1.202.162.48]
X-CM-SenderInfo: 51dqw25klj3ttqjriiqr6rljoofrz/1tbiSAWp5WidxSUN3gAAsH
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2836880009
X-Stat-Signature: ybh8ib9ck93hupo5sx14aroqu91ha76w
X-Rspam-User: 
X-HE-Tag: 1755170245-697753
X-HE-Meta: U2FsdGVkX1/rS0zv5SMu5kbc8fwXk6sU2VBeta2k+5z45Jja0N3+EgpMT1SQNKub8xR0MYkIVS9VSvySpZZCGO7AyaYaVQSi+9spKVHB5q0xsncsANmBlqMpKt+PWew45UfSNy1Dv3R9y/2QbFH0XSNLOpbNsS3HBmE5ScIAq43muRJmWCKmlS09DKc3hGkO/pvr1rVo4vWeU8f4lbLSM5T4daXg84w/jTCWCbIQwNWRSY3EIFVYn27j/7DiKhoQR+bM5K6hGGX4gDAthgbrGVO+uMozURxf4Fb/yGKbZzeMRgNTAV+JGil93YZdUd1Pds+uIWuiTWH2eemqMbFR+s4BClEzBLG/hHraDYtvIZsEXDEq9USxOUVrbvknZOIXKQe5mSmTyl2YiSrRryqdjNsLbaLt3ebNdvsNTE9XElVnriXlEfmcthouRILW/920ow42yfE8ddx8e0m62DgOrJmYC1cTvkEDf3pDB3AJjunjAZBsE5hSV2A8s7j2mX3vSXxN8rao1bfsOqwtSnzh78+s9xRNxIx0rT6IwacPVKcH3DH18em+WTxS5zTDvDQz461/+DXAH+glGBaSHbZuIb62LnMJuO1Pwx+Vf792qWVVd5b6LNeHQU/moZ2nUYYiTo3KyCijr1Ul9JNETT3QbouC/Ykdm7XNILoZ7nqvnz6e/J15dHQ8YPGeq8S+bm90JxOvSwke7gfgIDkUviHjUMFPumIl1KaVJ0b18e05Dgi8sPT8Q8goIRGZJ4/M4fJSy+ZmaFHy61VbNef/+gbvWAMztZp29lmxE7UG0s6VkxWeCOriCxkweixcbzcLUDB4zwdzNJKuZvNynTEge8FvWhf6WrScSdVd9Nr2cwNQEYWZ3nh7aZzHCBoRl2AygSPmHrfTqggtrVrlhH7Y0hb2EKeUIE/A72kh/YqHrYo41dXmn0p7JMMa0IXvS6fLqh4j9aiZ/shosIgVXJ/++WH
 yQV1YDE9
 NgnNkUDtMy0H3Y0tgkYm2pYkKx/Ec/IB1uvG1Xc1mpVCMuoHN9rH0OhQcnMF1ToVu7To/G2Tvogv4DAozMXPEJ3E5hP4t//RtJn3YzInqwkiCMAJyYZ8OTIci9tjBisueRLcszWd+i0o8bnMRPFlv2SR4Z/2wSQDCVzqViUyHF9dzJD7KpSPUzRRRM3qRNd9VA8Kg8SJ0CHWKwsG1PKggaRqE+AHH8MTa0VOId3zJzOJLq4/QPJw8E5+VCRShb4G34Vjd/WnVHdmq0VcHHdV+4Jla5zAEOe/LoxfBzOHk6r0AQuWszXxac17eVJEBt6eNKT2NvbiK7ZgbDX00Q5FqnboYGoJYiRTImDBcKAsfhlDJg+BwVhFAj7E+wxDoMj6o7oQHly7pwBWuwhJp086kE4Egexs2QqrNDWSdHKKeyi31Mo9jR4Sx5FVxf+0oiFTq/29SSlj2uml/oowlyBwGZpea8MyLEPAzDFG163X8zqZCiVE=
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

So avoid waking up kswapd.The oops looks something like:

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
---
v1 -> v2:
    propagate gfp flags to set_track_prepare()

[1]https://lore.kernel.org/all/20250801065121.876793-1-yangshiguang1011@163.com/
---
 mm/slub.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 30003763d224..dba905bf1e03 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -962,19 +962,20 @@ static struct track *get_track(struct kmem_cache *s, void *object,
 }
 
 #ifdef CONFIG_STACKDEPOT
-static noinline depot_stack_handle_t set_track_prepare(void)
+static noinline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags)
 {
 	depot_stack_handle_t handle;
 	unsigned long entries[TRACK_ADDRS_COUNT];
 	unsigned int nr_entries;
+	gfp_flags &= GFP_NOWAIT;
 
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
@@ -996,9 +997,9 @@ static void set_track_update(struct kmem_cache *s, void *object,
 }
 
 static __always_inline void set_track(struct kmem_cache *s, void *object,
-				      enum track_item alloc, unsigned long addr)
+				      enum track_item alloc, unsigned long addr, gfp_t gfp_flags)
 {
-	depot_stack_handle_t handle = set_track_prepare();
+	depot_stack_handle_t handle = set_track_prepare(gfp_flags);
 
 	set_track_update(s, object, alloc, addr, handle);
 }
@@ -1921,9 +1922,9 @@ static inline bool free_debug_processing(struct kmem_cache *s,
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
@@ -3878,7 +3879,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			 * tracking info and return the object.
 			 */
 			if (s->flags & SLAB_STORE_USER)
-				set_track(s, freelist, TRACK_ALLOC, addr);
+				set_track(s, freelist, TRACK_ALLOC, addr, gfpflags);
 
 			return freelist;
 		}
@@ -3910,7 +3911,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			goto new_objects;
 
 		if (s->flags & SLAB_STORE_USER)
-			set_track(s, freelist, TRACK_ALLOC, addr);
+			set_track(s, freelist, TRACK_ALLOC, addr, gfpflags);
 
 		return freelist;
 	}
@@ -4422,7 +4423,7 @@ static noinline void free_to_partial_list(
 	depot_stack_handle_t handle = 0;
 
 	if (s->flags & SLAB_STORE_USER)
-		handle = set_track_prepare();
+		handle = set_track_prepare(GFP_NOWAIT);
 
 	spin_lock_irqsave(&n->list_lock, flags);
 
-- 
2.43.0


