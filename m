Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECA29C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 12:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C864F6B007B; Thu,  6 Aug 2026 08:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C371C6B0088; Thu,  6 Aug 2026 08:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C896B008A; Thu,  6 Aug 2026 08:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD676B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:30:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02F0DC0721
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:30:47 +0000 (UTC)
X-FDA: 85070778576.28.66985F6
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4ACD3140011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:30:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of huangshaobo3@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=huangshaobo3@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786019446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Ouj9J9heuX03a/2HCyH8k2x/1kpO3Y0t07CcrIte77s=;
	b=UIfy+J6FELdcAEJbre5DNQ+CrKXyMI4+HO1w5crTPxACCpDAfGi/qVlfmeQ9QW6914xi89
	oWPY+kk439q3cO3Lb/5UY79Nm4vlAImjPmCluG/UElDiVpvqY4RX1jpi3KuhB0qtoqIfz9
	xrY1VafHWmVQ7zYMopS/tn4+ybPaqus=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786019446;
	b=Ko6HZreydw8R0Jy2jqVtdZXOAa0oOgRDX0LTLc4tKKxbKDuB1i7UZtg85ic5rOXjLrxesf
	nY6MpwR82f0bAiAYddoa+calbuilf5humyT1Qbcwae/tN33ONm1S5q8Xrwcv6o5RXjmFX5
	2sBydiRHd1ngDf9ntNVV9IZ2X8KUhFI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of huangshaobo3@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=huangshaobo3@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
X-CSE-ConnectionGUID: 0qp+6OErTomAYQ1cdvuP2g==
X-CSE-MsgGUID: UDbl5xJOSaSwGJUIb8TeLw==
X-IronPort-AV: E=Sophos;i="6.25,208,1779120000"; 
   d="scan'208";a="184784700"
From: sparkhuang <huangshaobo3@xiaomi.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
	<vincent.guittot@linaro.org>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>
CC: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, sparkhuang
	<huangshaobo3@xiaomi.com>, <stable@vger.kernel.org>
Subject: [PATCH] fork: reset pointer tag of vmapped thread stack before vfree
Date: Thu, 6 Aug 2026 20:30:20 +0800
Message-ID: <20260806123020.90869-1-huangshaobo3@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.237.8.165]
X-ClientProxiedBy: bj-mbx09.mioffice.cn (10.237.8.129) To BJ-MBX01.mioffice.cn
 (10.237.8.121)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4ACD3140011
X-Stat-Signature: yaxz7ni75pzzafdmahmwjdygzsdd4q4k
X-HE-Tag: 1786019444-129004
X-HE-Meta: U2FsdGVkX199l6zbHBuFzk3zp7AiPUYDxYf4lA8/mgIO9epNZSGhKCUbwxAS1GFJTA2QFLhpN9Mf21m3eag+ctCISCPWGXyQqYM1+h7HK9MDdQN5fJ4ifmgElgW+MddUJe3rJDBTs0InBXm5burZfYe3Qk3ZygV+Lllhqk0hHzf8CghUjmoFa5BI3HW8v5ify2K4BFrs5b3oOkyTHkIqqcGqRYxJqsz6D4en2MpiOSAlkYw6/5iOYtmpTaWLofa+7+em2xEBIWkZeNBB30PtDpZIVBvpe8TBp78eTf2ZRJe3Rs6bn0nYuST+T7aa0oIEo3pRengLn22AMNR5perV0V66iJwye3n5/1YsT9A494P9sudV81QjaMVPaVIEsWGZ0E/XILQwYgz0TnxSu1PzKNcsD56mab8AAA2vMmVgsgmvf7Da8w/Pl6nm4XqsKS6q1SQJD8kgTXdAhHKHZ6ZMqsEXGzfOG58dNzal275th/9bPeP4viYc3S80AGWlLK2jvZVIXIvil9cGYBZODv4ewzeknvQxaDkDT+4hacv2XFo40H3/ZGo2kpQR5eoJ4WshZcXJF81lhL9sJRavF/F+HXNhloasrRq5zKWA2JUFy6D3tcBk6aiCRacJQoG7jqJjglcjiKxwoZ2s7oULaRHdysn4U6ikK+8v2s+waUGL7GePrUrT4qsnqvzW8tpvhCFsiBlSHYdcyvsMsnpFCdnwXVE7yqsfw/hH/Fhnrh3dEvIUkkOd/d8HJfJVLiPrYvkC7f6RUpyIfIFluuq4IVWe9C0V+tfl3cId/tNYG3wwb5VICI0GTRV/G4B637GVvEznJU9GZkC8eJAnrrEdGpzf6bUsTrO/ADNvf4nQosLrpt0MKTx+1fQN/t4svXM9uMLh5ErqnTGyV3haWfnelTtX7HGJmTcJcSYCwiQP5LKTGIxI8rToJQthqLxnLP3/7ce3lsjfeIE0Kpk4HzP7udu
 0JRSnRC9
 13yNymQeoNlxbCw878U30yDl90NlUCjV+AKySPFK6rd3/27D7gGPrPc/w/ljfVCrDhppVXMebdt+Kft3wHXoi52ZCKugAYvzx0GrpL+/fX6SDGJ6JlHomzW2rhvv0I7PneNyNuZ7Zcbo9vvo5a7DflFHhQGNpiCpaMGXt+G1+ESgTJr16q5nMqrus0PE6DrkhfRPGYzHbRMfVzCSKMaQj65rIAebZVYOdWB+GrzhleK9rEECDlgCVAYA13bwH3mzZYMpd2ic38RBoKfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a thread stack is freed via RCU callback,
thread_stack_free_rcu() calls vfree(vm_area->addr).  In RCU callback
context (e.g. from rcu_nocb_cb_kthread with BH disabled, or from
RCU_SOFTIRQ), in_interrupt() returns true, so vfree() routes to
vfree_atomic().

vfree_atomic() uses the freed memory as llist storage by calling
llist_add((struct llist_node *)addr, &p->list), which writes 8 bytes
to the address being freed.  With KASAN SW_TAGS enabled,
vm_area->addr carries a random tag assigned during allocation by
kasan_unpoison_vmalloc().  If the shadow memory covering this region
has been set to KASAN_TAG_KERNEL (0xFF) — e.g. by
kasan_unpoison_task_stack() using task->stack, which was already
reset to 0xFF by kasan_reset_tag() at allocation time — the shadow
byte (0xFF) no longer matches the pointer tag on vm_area->addr,
and the write in llist_add triggers a KASAN invalid-access report:

  ==================================================================
  BUG: KASAN: invalid-access in vfree_atomic+0x90/0x150
  Write of size 8 at addr c2ffffc0a8f70000 by task rcuop/7/75
  Pointer tag: [c2], memory tag: [ff]

  CPU: 5 UID: 0 PID: 75 Comm: rcuop/7 Tainted: G S      W  OE
  Hardware name: XiaoMi Xring_o1 UDP PHONE (DT)
  Call trace:
   show_stack+0x18/0x28
   __dump_stack+0x28/0x3c
   dump_stack_lvl+0xac/0xf0
   print_address_description+0x7c/0x25c
   print_report+0x70/0x8c
   kasan_report+0xdc/0x13c
   __hwasan_store8_noabort+0xe8/0xf8
   vfree_atomic+0x90/0x150
   vfree+0x220/0x298
   thread_stack_free_rcu+0x3c/0x4c
   rcu_do_batch+0x308/0xaf0
   rcu_nocb_cb_kthread+0x33c/0x708
   kthread+0x364/0x3cc
   ret_from_fork+0x10/0x20

  The buggy address belongs to a 8-page vmalloc region starting at
  0xc2ffffc0a8f70000 allocated at copy_process+0x1ac/0x12e4

  Memory state around the buggy address:
   ffffffc0a8f6ff00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
  >ffffffc0a8f70000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                      ^
   ffffffc0a8f70100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ==================================================================

The tag on tsk->stack was already reset to KASAN_TAG_KERNEL (0xFF) by
commit c08e6a1206e6 ("kasan, fork: reset pointer tags of vmapped
stacks"), but vm_area->addr still carries the original random tag.
This is the same class of bug that was fixed for shadow call stacks
in scs_free() by commit 528a4ab45300 ("scs: Release kasan vmalloc
poison in scs_free process").

Fix it by resetting the pointer tag before calling vfree(), so that
vfree_atomic()'s llist_add write uses KASAN_TAG_KERNEL (0xFF), which
makes KASAN bypass tag checks for that write in all modes (SW_TAGS,
HW_TAGS, and Generic).

kasan_unpoison_vmalloc() is not needed alongside kasan_reset_tag():
in HW_TAGS, __kasan_unpoison_vmalloc() is a no-op without
KASAN_VMALLOC_VM_ALLOC (only KASAN_VMALLOC_PROT_NORMAL is passed);
in SW_TAGS and Generic, the 0xFF-tagged pointer already bypasses
shadow checks, so the shadow state is irrelevant.

Fixes: 0f110a9b956c ("kernel/fork: use vfree_atomic() to free thread stack")
Cc: stable@vger.kernel.org
Signed-off-by: sparkhuang <huangshaobo3@xiaomi.com>
---
 kernel/fork.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index f0e2e131a..2fd6fd25c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -280,7 +280,19 @@ static void thread_stack_free_rcu(struct rcu_head *rh)
 	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
 		return;
 
-	vfree(vm_area->addr);
+	/*
+	 * Reset the pointer tag before vfree(): in RCU callback context
+	 * vfree() routes to vfree_atomic(), which writes to the freed
+	 * memory as llist storage.  Resetting the tag to KASAN_TAG_KERNEL
+	 * (0xFF) makes KASAN bypass tag checks for that write in all modes
+	 * (HW_TAGS, SW_TAGS, Generic), avoiding a false tag-mismatch report.
+	 *
+	 * kasan_unpoison_vmalloc() is not needed here: in HW_TAGS it is a
+	 * no-op without KASAN_VMALLOC_VM_ALLOC, and in SW_TAGS/Generic the
+	 * 0xFF pointer already bypasses shadow checks.  This mirrors the
+	 * intent of the fix in scs_free() (commit 528a4ab45300).
+	 */
+	vfree(kasan_reset_tag(vm_area->addr));
 }
 
 static void thread_stack_delayed_free(struct task_struct *tsk)
-- 
2.34.1


