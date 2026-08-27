Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF10C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D22D6B0092; Thu, 27 Aug 2026 19:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9D36B0095; Thu, 27 Aug 2026 19:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0986C6B0096; Thu, 27 Aug 2026 19:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D493C6B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:31:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 495A940217
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:25 +0000 (UTC)
X-FDA: 85148648130.01.C7191BF
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf18.hostedemail.com (Postfix) with ESMTP id 992681C0005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ES5yXGYy;
	spf=pass (imf18.hostedemail.com: domain of 3ysiQaggKCPktufwfotehpphmf.dpnmjovy-nnlwbdl.psh@flex--stevensd.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3ysiQaggKCPktufwfotehpphmf.dpnmjovy-nnlwbdl.psh@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787873483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRF3HmEVCSbkNryj4HHFEle4K2g8xeVsDlkdo6/RfiQ=;
	b=yEWsNQ3B3ytHO/GTUyJQIAV0m6oNbqvbE5KWSeuSJwhRAtqTgq/1PDXh0GCdHpVyy4fkFG
	d7gxIEgHdZwNAnLKS9yPb0PqyLuyhbqzqSFJ7Mv7GjSLCjjBu7Gh4dCbCgsWE963+dcrIS
	X9v0KxEsPYLyd3757QaKdGcMOn/x0Mg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787873483;
	b=XV1HBiLiBE3f2TxfT2RgEMILn6kUlGRHGXGb6r66tIs8Auox+lqB8IsfLbaoFAoI7wt5D2
	CwS+SNtIUAR+prYUKmO7nhJg3CRVHDV4v/ZwGQOVqhANK45gGY7SphPCTgpwtgg/kWziZw
	tvooISU1VVSwrgpLaw2WssXwZqieYCA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ES5yXGYy;
	spf=pass (imf18.hostedemail.com: domain of 3ysiQaggKCPktufwfotehpphmf.dpnmjovy-nnlwbdl.psh@flex--stevensd.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3ysiQaggKCPktufwfotehpphmf.dpnmjovy-nnlwbdl.psh@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca8aee88725so604561a12.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787873482; x=1788478282; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XRF3HmEVCSbkNryj4HHFEle4K2g8xeVsDlkdo6/RfiQ=;
        b=ES5yXGYyC1ctCKfFBB3a3g0dZ1cON6T42A7FFithfeTbxdl3St7Z0pPjD1EFkN96Z1
         XXkuF0bp1xaK97JOVbVBlTBcaGnOLW09VUaPX58KyONJLqwnMJD/yE3Vb65z9NaRLT86
         ptVrJpNyC8kpym0BFH01t7tQc6xcAESq1GGMWbIJTVbFw5Dt5pYUg8MNEWtF4LWxhuSe
         LBppAi0yIFdBy2PqY910WmhmGJ8dOxeK/sBnZlIcpgjqlk8cO8xaSbCs4Cds2dhGOW/N
         ERRSFCMLcOt0jI5QneksLdcrNE770PyEj2ekPz7GsR0lm4EOW+mNjSBMQeF22pzUIhxV
         Ohfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787873482; x=1788478282;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XRF3HmEVCSbkNryj4HHFEle4K2g8xeVsDlkdo6/RfiQ=;
        b=PrNax3ICdpBGAY2Xw+IWSkS5RMS8219siWU4QgNnhALMQaccXLTYp8rE7BPZTjQ+tM
         abJ1NJJQ9Do28kvEy/1QpCd62xCDtdGz0fij3idKKNhjOn5izCra/6YiYl0oLGul5cBr
         QI0BPI/l7KvC3DD4Fy95no951AdqeMrneEZGiUB+v5fZtTjn4kX4KlR1m+SYEzvJkx1A
         Esnl4U4QHca0fFcdeeZ87Weo0FcuSIX4xNyJIrAzhEMRlbatVZOUN6wDvziVaB+a56C/
         vdBeCwG0lUZhajc+fdOyvb4Ol6JbOgE0qxYCANWMHBoa4qof2LCZwDBkP64bxoOYZVLl
         hr9Q==
X-Forwarded-Encrypted: i=1; AHgh+RowoN2ND0SBKf04kz0zMx3gLR3+U+V/0DFVCo4ISl58BLHtyGJ2x4R47jrouSWotTRfOVzZI308Fg==@kvack.org
X-Gm-Message-State: AFuF++kxWXJsQdgzlYDViVgzHsGmXU2pbmpIhQP3GUoaWGehtNXjkAuO
	X0rw4eq2HHSszyN5n3OqXgYWuh62XjFvdXRYCZa8jaE9Y7AiHj3ioZrQTxorytm28DzxsgTwS7T
	wn7Z9guiSMuQ40A==
X-Received: from dyblf13.prod.google.com ([2002:a05:7301:a0d:b0:315:bf25:ce14])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:94c9:b0:3d1:be60:2816 with SMTP id adf61e73a8af0-3d268cf776bmr3404563637.10.1787873482070;
 Thu, 27 Aug 2026 16:31:22 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:29:41 -0700
In-Reply-To: <20260827232948.2520558-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260827232948.2520558-4-stevensd@google.com>
Subject: [RFC 03/10] fork: refactor vmap stack alloc/free into helpers
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
X-Stat-Signature: gf7ncihnyatc9b6ouep1u8tgep74n4pj
X-Rspamd-Queue-Id: 992681C0005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787873483-661587
X-HE-Meta: U2FsdGVkX19u+14Pd+ye8zng7WW4i6YV7/L1RAPW7BOssaHr6Y3ySyCj0Ymw+w4zLpba+d/9E4iFJfwWmjMbIseAL7nfSkmBnU6NaepqbkWhdaymFmFtud/BTo82oZWjuMbFNH5bbHJJtEn8TPn57GmIFeUw4VQ+Vt1hmN7xGXDpHLCINPOo875Pmv9SDTPtWmVxbQ6IX9UzgZz88M0RvmUmvP/fp0KvSOwiy1JbNaAKruy1plaewu1mAk9SZfE4Pi5DR0dexRzDYaSd5UsZTigZji2g/ISbBYzucpBA2L/QQ0Cfj9BOWaHdto1GuMIp5qGjn3h2SgKBwoKbHosIJu+KH3vW0/yXfhKYJmoXcVCChA2qQ6ZFJLpLyyjqx376vaM4QmVsg99O1U07rZcaNLwDHiRTD+kbTpo2xWTIkTiUYINdJoWrYj2yIO+bHR5+xmJUO33b1QtwEXy/MaZ1MwiWYreb481xiZ1zIpgosXT2SjKPAtep0U85kxpBFQ//naxHCxoQABoM7/lOCforsvTapMPonzR+Pb89vnuY/UH1dV4dutw/px1+krZj8397DZBgFknQD1zM4BvBlpdjCMbB4jzuviFkcKrpeGImywSUCE7croRKYBGmxqlCV/Icm2j+Hd4BzQFkYo3Lci218HQkvnffLi0f3RuOy9V55bVOBGdR97Y2eprVH0WG4LLEEmTkKj8XCyLWRnNODW04tpagMoCGB0jW0jvobdhCe3/n1wfyyeqP3Xitm3KB+5EUlcJXmfHOV8gW/nMJ3NkBGyW58Vi0wfijEthWcklzG8Mmo8nhLmZyt9UmMKvVNzP1PbxwQAT/1dM9zoOQew3zTFr43d6jr7Kuvs1UzjGwXfYid5uDwe5T3aZfvoLpmup1KJHVA2HNQY+QyaamHJXqwrzwC9Dmz6+lEbJVPic05ZaRfLvu/8ICRobWRxxCXbLkD1uKwqw0dgCpRJf/24C
 nzNIAXWJ
 QqRz8ydxC8jLe5ruQkk5C/LGbLXcTIgpuqj+ufczkl5O7N3u6N65b4Z5iIdshDFBepakcJ5YLe+egV1Bsc3YpiEAsOCiadV17YWJwocMJULoiFh4ENJVGXZCMxE08Kjs2JlH3AiqtL7epLwlywHYv3qT9HeNr2KuFUUpGt0W5tA6lo8OeB/eVKlvWtk4WmbiZhZanH4GxFMsC1OiM8852PKtBoB/XowmV/GhByjSBSO1gWGcx6n+6qFK/5C6Yjy4U7lPx24x45mFqkOUlikiYwflTd4tePkAaLjIaa3tYBslO6HF+4e5mm3BtYm2Ubiwhi4nUKqXO8kVnC59lcfCy+esNgYx1WoqfsmL9amUzikIfXIEUmX5PR9lcbwQKzQvDNzbU50imS6N3iSgDLG/1Oh+6gwhmb9T/tt9lipnoWH3ByTd64W/Gch9zRFdk6UW47n7X/ccCjBERnry0lm4zJGrt7+15DTlHSSg7tfdn/TNw0YhnyJLPLHIVXRL6wv5rEALS5FKqXeK5U62dcOZv3CRDAMpSNQ6j8ie+o7DdxqW90IIX0VOfP7ICJrOxIRdFR9uewZsqAPfEiuZt0Y0+7lXCYBHE/ryY/NUH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prepare for alternate implementations of some functions for reclaimable
stacks by creating helpers for allocating and freeing vmap stacks. Also
reorder some functions to consolidate the functions that will have
alternate implementations.

Signed-off-by: David Stevens <stevensd@google.com>
---
 kernel/fork.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index f0e2e131a9a5..10bd76f6dd20 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -207,11 +207,6 @@ static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
  */
 #define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
 
-struct vm_stack {
-	struct rcu_head rcu;
-	struct vm_struct *stack_vm_area;
-};
-
 static struct vm_struct *alloc_thread_stack_node_from_cache(struct task_struct *tsk, int node)
 {
 	struct vm_struct *vm_area;
@@ -272,6 +267,26 @@ static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 	return false;
 }
 
+static void free_vmap_stack(struct vm_struct *vm_area)
+{
+	vfree(vm_area->addr);
+}
+
+static struct vm_struct *alloc_vmap_stack(int node)
+{
+	void *stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN,
+				     GFP_VMAP_STACK,
+				     node, __builtin_return_address(0));
+	if (!stack)
+		return NULL;
+	return find_vm_area(stack);
+}
+
+struct vm_stack {
+	struct rcu_head rcu;
+	struct vm_struct *stack_vm_area;
+};
+
 static void thread_stack_free_rcu(struct rcu_head *rh)
 {
 	struct vm_stack *vm_stack = container_of(rh, struct vm_stack, rcu);
@@ -280,7 +295,7 @@ static void thread_stack_free_rcu(struct rcu_head *rh)
 	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
 		return;
 
-	vfree(vm_area->addr);
+	free_vmap_stack(vm_area);
 }
 
 static void thread_stack_delayed_free(struct task_struct *tsk)
@@ -302,7 +317,7 @@ static int free_vm_stack_cache(unsigned int cpu)
 		if (!vm_area)
 			continue;
 
-		vfree(vm_area->addr);
+		free_vmap_stack(vm_area);
 		cached_vm_stack_areas[i] = NULL;
 	}
 
@@ -338,7 +353,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 	vm_area = alloc_thread_stack_node_from_cache(tsk, node);
 	if (vm_area) {
 		if (memcg_charge_kernel_stack(vm_area)) {
-			vfree(vm_area->addr);
+			free_vmap_stack(vm_area);
 			return -ENOMEM;
 		}
 
@@ -356,15 +371,13 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		return 0;
 	}
 
-	stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN,
-				     GFP_VMAP_STACK,
-				     node, __builtin_return_address(0));
-	if (!stack)
+	vm_area = alloc_vmap_stack(node);
+	if (!vm_area)
 		return -ENOMEM;
+	stack = vm_area->addr;
 
-	vm_area = find_vm_area(stack);
 	if (memcg_charge_kernel_stack(vm_area)) {
-		vfree(stack);
+		free_vmap_stack(vm_area);
 		return -ENOMEM;
 	}
 	/*
-- 
2.55.0.897.gb25b4bd76c-goog


