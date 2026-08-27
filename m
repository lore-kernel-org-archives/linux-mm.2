Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE4A0C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44346B0098; Thu, 27 Aug 2026 19:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4F66B0099; Thu, 27 Aug 2026 19:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0ACE6B009B; Thu, 27 Aug 2026 19:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F35C6B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:31:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15861160223
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:29 +0000 (UTC)
X-FDA: 85148648298.09.FEA85E8
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6298218000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jLs3nIbt;
	spf=pass (imf24.hostedemail.com: domain of 3zciQaggKCPwwxizirwhksskpi.gsqpmry1-qqozego.svk@flex--stevensd.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3zciQaggKCPwwxizirwhksskpi.gsqpmry1-qqozego.svk@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787873487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lOzSmEZ51hzHprpWRTTa0ItgwWLWckqKQo+nDAEYGw=;
	b=gLxOsc5YG09ue37Zems1RUs0sJG24ob8EQ/sKM1iwUERQDsCcK+tzQ8EVmwnVee1yVJX7S
	gpD7HIS4N4tjuQoSeTB2/wYSzmv/SwJXeuJkxY4X5EpyiR7bJ0XX5b0AdzCpAtXgFrs7sX
	NmLOy6h/Nn+dii9KFUpatY+z2+MyUVw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787873487;
	b=WPjCnWir9kc49WTnmRR7v0sUzBA8yKqBmxd82NjmHCYPP1fMgPm49qd7oo92ZvMbxgDByI
	FACsEGoL8bpZRwDxfW7VgD8Vf4MunNSrplK2ppl7yrD6uScoFyiG/cCmnBvqJtvsq1EHXA
	IZrXUANLCwULA3cf/zqfJn7gF/DVcbk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jLs3nIbt;
	spf=pass (imf24.hostedemail.com: domain of 3zciQaggKCPwwxizirwhksskpi.gsqpmry1-qqozego.svk@flex--stevensd.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3zciQaggKCPwwxizirwhksskpi.gsqpmry1-qqozego.svk@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so468896a91.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787873486; x=1788478286; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/lOzSmEZ51hzHprpWRTTa0ItgwWLWckqKQo+nDAEYGw=;
        b=jLs3nIbtFmI84lbzhe4k+dktagoJbI0Je8L1EGqWN70Lgi4YcgTB6Juf6iT3MRZQhd
         64NkdhKMSlouGIVAZifkps4Sf4HUpVhcYKRHurYRE+rwaxQM/kE/dwHg0dt289Xe3ZeM
         TZaqvqWtSY1C0cnmtVgHx0IARbbBCcA5ymjGVZhmHAWom8KwL2k8eHnyq1qVFaL+rRnZ
         hLtq47RsKoloC5i61iW7cPeaXya0idn5nXfqMmbSJjDZz/1xhKKAx78cHhYgV4qv7mjC
         b/OT49J2kgvP+7t1o0+yYJjkfnkrhlLlY4ubasBbwtU+g/GE62txhG1mbzgZsinDEu7B
         PdkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787873486; x=1788478286;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/lOzSmEZ51hzHprpWRTTa0ItgwWLWckqKQo+nDAEYGw=;
        b=NmAQt2e2JViEzmjnUgLaY1Ew7cJvsZJFND4eJrbTMH0e9GPoo2NLDY1lFPgI36h9Qc
         lhfL78v0YqsH+fiEDKWBjt5eSMSPRTsfOVzKtAvsfnQJY062hxMl265SJEaPv75w/xou
         faiVbOu9Ps72V7ve/Fa/jE5cp+sXKRwwxvGIAkhAl6hONJn123Z6mSDaF9bk4RnG2qYG
         IEXAZVMzFehw8bHHXvteOIyhojY8VfAZRFk27yFLOKfiu0RTUPHkVDcrS3R4ORKmfbiU
         7ILX3EDV4sGzEATxgJSjJQnmU6TuSP3E9HiATIoLLc7XZJUEmammPISP8u9I4wOsR8kM
         HmUA==
X-Forwarded-Encrypted: i=1; AHgh+Rp0mIrczKjayPhL6o2a/hP3/EbpeRh9Njdziblcj5xhqVNW+nkIL28tpTLB4bLMKwffzYKordCovw==@kvack.org
X-Gm-Message-State: AFuF++lMTemXg7EKs3fux2kiotP8krGt4fFjz8y1TXWCPwH4bLDREKNC
	PE2AWJfw02Y0mGZ/7qgzvNIondWnY3n4T70mrWoVHOE6XHvEoJq1uI99iXyx0/qJZ3yiADiW/zD
	Yml0Bi7onTjNEeg==
X-Received: from dybud10.prod.google.com ([2002:a05:7300:f60a:b0:311:6ce7:736d])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:458b:b0:2d6:f3f0:3e7a with SMTP id d9443c01a7336-2d74dc2ade3mr36340345ad.3.1787873485885;
 Thu, 27 Aug 2026 16:31:25 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:29:43 -0700
In-Reply-To: <20260827232948.2520558-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260827232948.2520558-6-stevensd@google.com>
Subject: [RFC 05/10] fork: allocate reclaimable stacks with VM_SPARSE
From: David Stevens <stevensd@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
	David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6298218000A
X-Stat-Signature: d58ptteki6ypzywpcpfytsh4zoj97iu6
X-HE-Tag: 1787873487-838748
X-HE-Meta: U2FsdGVkX19n2qxbEfQYDUHO/wx4S/qFZn+wVhS8acX0yYPwDadFsAr7eqfmtOuEkQmyNa1PjLdyKChqXt1aPxGKtot9ZHuUaF7CPuHTgjFxbc3NaYPYKE9MvCNHDg29DYJSZ4zl6DolF0rT6NzhHGw2ua6XGqIx0RFoydl1074CPx5YcEwrM/kBgb+n2sjMQiOktt12WSzjEa1AGY63ZYnZXJJY2vdi6QgsxtObHR3ybBEV6bve4xeV/SrXmNJ+6YC/8R80INhrVvrhsTjcoCk5QD3w299/GtMCmOltXJqJEdivspM8IkDUIa0vu3FkHIvDemnNGuf1usQar9NXqd7r87Lxi6u9NoA/cOEHvbWKU/MlufRRZ3FDlyFHY3PBNkOKYkeEBrQXq11/qy3iUsVad9CAQpOTtSniAgHsbiAz0+eOJgh0SSJUD+9Ewoy1xWGdprpDnw+3S/3MyfZr7cRUrrj3Jsc4O0gaXIpHlzhoGl36rgD9356ODToI/X3eF775q4mfM8g4fkQb/pTQjM6MYV3pGFZrUyysifrmzkwjrZAYfj56IG1VPWTrZBn5i8kaS1wfjDq3JPdOtHGf/39RJaE0IOjiEokaK2JoEDBLlWcjpZNERwZ0nJC82nLLffga/KG8sJzhF2qWWB/02Z6Qp/15tPWIz/yYLqxDjr9YX84dRtqY/i3AkJcA+L9f6pSX3EjNCo9LEx5QmUdry5M8yUdoh5a606Da6RPxD8RemjEPhSFlzVVhLQ1+3bUYMHgTpxq8nzyMgnjPLKhbkFrIWEe0LpHXPvNN+d5mezZpJzFdCxCZQHZLSzF3KbdBONLuMCraXzwTPcJZgFSdKgsEoHZra4KeNIzzxkpIjfDbcDvqYdVx30lKEB7iCVMxJ/I/mB1n3QkDDgH6nQh1/w/I9NNVhuaTUyfQbmqJXREIfh/MbW01FkCnGPFurx7Y025wUI1+MDKSc6pLvan
 BOAKv1sD
 KZWlfNo0Rwys0keyEA1cknUEzlxaWtmw5Go66xRbEMIncTKrWycTr4bY7wdrWkWACruTpxBTw6WefsKL7h8kTikiEN78PaTsEs2NbLtDlylteSYVilow/GIU6VHOCLAppMoMQ32HdaYYKQD5Z0fx7Ore0jHCm4zf/iF5N8pji08tfpXMdt69rK+g1x7XPK8MyUzs1NgKLcgBzVevmmdkUrJvkD6gJJuD1h2nGyioq7JfcYcHUrp+ggst1upsz94bb4l2rydD7e39Us7PEDhpEEBlARJYMi/eiMrLh420NKB7i2PTBF/alAVlVn/+AbnnnF/HOnce3KlXmAZVyf9iW5M84VHwd7QQsRMYMlUhBefeN6dzCLlAVQfUQoyej1quUIi64TA8dG+cUZ+m5RhY+h03bu/40d7PFxObjd0JTn90LXn0Kc+djdqfhvT26mat34REcvY33FZpgoH+V0pIq6vx3HtUyur142G+eGRzm46glAk/lVaI8L7Y2SRGBk4599460rjZfUOCy//8n5sUp3mlbAZBoxO6t+8r+BAC7FVRwc8cWiZIS0jlkXJ4EKdavchUaoqZpsxU2gr2n5Nwjkm6XTIJO4khkLNZXoXELqIfN3Y0l2RYYVTVTjzvl3EkSBptNo1SYpC2jnoA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the pages of reclaimable stacks will not always be populated, we
need to set VM_SPARSE on their vm_structs to avoid crashes when
vread_iter sees a partially reclaimed stack. Note that stacks will only
be partially reclaimed when they are associated with a live task, so the
stack management and caching code in fork.c won't actually ever see a
partially reclaimed stack.

Directly managing the vm_structs instead of going through vmalloc also
requires doing the freeing of the stack on a work queue instead of in an
RCU callback. Previously, we were relying on deferred vfree work to move
much of the cleanup work from softirq to process context.

The fact that vmap stack pages are included in vmalloc's vmstat is well
known. We should continue that to avoid changing procfs.

Signed-off-by: David Stevens <stevensd@google.com>
---
 kernel/fork.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 10bd76f6dd20..6acad0038b78 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -267,6 +267,97 @@ static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 	return false;
 }
 
+#ifdef CONFIG_RECLAIMABLE_STACK
+static void free_vmap_stack(struct vm_struct *vm_area)
+{
+	int i;
+
+	remove_vm_area(vm_area->addr);
+
+	for (i = 0; i < vm_area->nr_pages; i++) {
+		mod_node_page_state(page_pgdat(vm_area->pages[i]), NR_VMALLOC, -1);
+		__free_page(vm_area->pages[i]);
+	}
+
+	kfree(vm_area->pages);
+	kfree(vm_area);
+}
+
+static struct vm_struct *alloc_vmap_stack(int node)
+{
+	struct vm_struct *vm_area;
+	int ret;
+
+	vm_area = get_vm_area_node(THREAD_SIZE, THREAD_ALIGN, VM_MAP | VM_SPARSE, node);
+	if (!vm_area)
+		return NULL;
+
+	vm_area->pages = kcalloc_node(THREAD_SIZE >> PAGE_SHIFT, sizeof(*vm_area->pages),
+				      GFP_KERNEL | __GFP_ZERO, node);
+	if (!vm_area->pages)
+		goto alloc_failure;
+
+	while (vm_area->nr_pages < THREAD_SIZE >> PAGE_SHIFT) {
+		struct page *page;
+		gfp_t gfp = GFP_VMAP_STACK | __GFP_HIGHMEM;
+
+		if (node == NUMA_NO_NODE)
+			page = alloc_pages(gfp, 0);
+		else
+			page = alloc_pages_node(node, gfp, 0);
+
+		if (!page)
+			goto alloc_failure;
+
+		/*
+		 * Non-reclaimable vmap stacks pages aren't charged against an
+		 * memcg until account_kernel_stack(), but they are added to
+		 * the node's NR_VMALLOC counter. Copy that behavior to avoid
+		 * confusing userspace.
+		 */
+		mod_node_page_state(page_pgdat(page), NR_VMALLOC, 1);
+		vm_area->pages[vm_area->nr_pages++] = page;
+	}
+
+	ret = vmap_pages_range((unsigned long)vm_area->addr,
+			       (unsigned long)vm_area->addr + THREAD_SIZE,
+			       PAGE_KERNEL, vm_area->pages, PAGE_SHIFT);
+	if (ret)
+		goto alloc_failure;
+
+	return vm_area;
+
+alloc_failure:
+	free_vmap_stack(vm_area);
+	return NULL;
+}
+
+struct vm_stack {
+	struct rcu_work work;
+	struct vm_struct *stack_vm_area;
+};
+
+static void thread_stack_free_work(struct work_struct *work)
+{
+	struct vm_stack *vm_stack = container_of(to_rcu_work(work), struct vm_stack, work);
+	struct vm_struct *vm_area = vm_stack->stack_vm_area;
+
+	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
+		return;
+
+	free_vmap_stack(vm_area);
+}
+
+static void thread_stack_delayed_free(struct task_struct *tsk)
+{
+	struct vm_stack *vm_stack = tsk->stack;
+
+	vm_stack->stack_vm_area = tsk->stack_vm_area;
+	INIT_RCU_WORK(&vm_stack->work, thread_stack_free_work);
+	queue_rcu_work(system_wq, &vm_stack->work);
+}
+
+#else /* !CONFIG_RECLAIMABLE_STACK */
 static void free_vmap_stack(struct vm_struct *vm_area)
 {
 	vfree(vm_area->addr);
@@ -305,6 +396,7 @@ static void thread_stack_delayed_free(struct task_struct *tsk)
 	vm_stack->stack_vm_area = tsk->stack_vm_area;
 	call_rcu(&vm_stack->rcu, thread_stack_free_rcu);
 }
+#endif /* CONFIG_RECLAIMABLE_STACK */
 
 static int free_vm_stack_cache(unsigned int cpu)
 {
-- 
2.55.0.897.gb25b4bd76c-goog


