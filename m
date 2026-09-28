Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90C52CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DAAF6B00A4; Mon, 28 Sep 2026 13:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D2B6B00A5; Mon, 28 Sep 2026 13:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8AB6B00A6; Mon, 28 Sep 2026 13:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6A986B00A4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:41:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EF33A5D73
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:55 +0000 (UTC)
X-FDA: 85263888990.08.A874860
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80733C0009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=drOa+lR6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 336a6aggKCHQkegklSXSYggYdW.Ugedafmp-eecnSUc.gjY@flex--smostafa.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=336a6aggKCHQkegklSXSYggYdW.Ugedafmp-eecnSUc.gjY@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1DJuPuQM9kSMFWHvWycx46i6Qw8Tz2JNB7c4R6pz+k=;
	b=Nr/Y4TmELo28BkhqSuWa18/dBjAkrAnYZMWYPSNExA/l9mhcTnuJQqYon4dkPhi1V2jgyU
	PAvUCgrbSjS0x+g9jbcqUAvDfHbvHJ2euESER6b6+w61l7wmNBLun1K89T3oJ6fq8/nmnk
	XDz+fv22uEhW33TtKx+O9tn/DoKlVEY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=drOa+lR6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 336a6aggKCHQkegklSXSYggYdW.Ugedafmp-eecnSUc.gjY@flex--smostafa.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=336a6aggKCHQkegklSXSYggYdW.Ugedafmp-eecnSUc.gjY@flex--smostafa.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617313;
	b=CksO+eqHaCxeYER7d6LvwlRkwsCdXIq7n6YxIO87jeM1jE5T3cSrGtKFjDyoAp/9Tnilti
	lpZt488O242PIXGsQJMe/E/mauVW3MD9dRBHGd0skivrdEj7ONtbOXUPpGp3/xLHolVR2q
	jhFjpuNygvLYU4nmsveatmozWWHC0Ac=
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so24282845e9.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617312; x=1791222112; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+1DJuPuQM9kSMFWHvWycx46i6Qw8Tz2JNB7c4R6pz+k=;
        b=drOa+lR6IeaBsK0kIe1Prbaa77JzT7GrVLWv8+pzt/oD7hvC51dIUxhX4IDfOP0cmp
         LA99NCi3Ct+0attT14M0ebIxzGSvSWRppeEFkQfjtcN5G49A8zf1LMmoSe1skMT/bT8n
         WOzICJUjtARS7f3Zceb5sYSO/u8eg6bOvdOQxPPcWffSfCInfLKSE9Hl9lH4ffCX7xFo
         2kGMNQ9pR4XhPTIi52OaSXpfpWW7iFgMdDsMdCZixGG2QSHIPHb7NW3n9/G7nNLWX4pU
         vV0wPmdUIReeaV1WFs9YuWUJndiuWkWBzNLvUwIP90zyAXMjyLCBsoJPp8/xam7yz/5k
         cJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617312; x=1791222112;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+1DJuPuQM9kSMFWHvWycx46i6Qw8Tz2JNB7c4R6pz+k=;
        b=otK0TyWAS40a3KMTFbbDwozVvHRtBgf/MSd5IN9rowBe6b+2k19ZZvX70cYpHD/PDG
         /6zk/SLXcg9rj5XFdJtGhVzt1MP7Lkp5qMmxl+9DC1CIjBg1k8XE0113W7hudLMG9pbh
         BAynpCe4sGWm5fR8yxxsWWItMHuwDk77hUysqKXiyZ1mZFhThXXGgXupod1mL8IRjO+o
         vZD054K/8hn2vUmaZCP3HWuUJtCMRKMEOZKDz8vjfJoStaj2tkBIyjlHmd49J67+J3zY
         7N4+/UDAJlX82Fyh4NzlSOTXWBMbmiF/DIgRYZFCA/zbDlCVl3kU4tzmTqyYLX+HQY3F
         UBjQ==
X-Forwarded-Encrypted: i=1; AKwUvByO1WEh2x7Y+Q64vZ+MJ900zPklJYyCA8axraP1FWehNXYxr5xwU3dDokbo90PyheZN+35EwhaQag==@kvack.org
X-Gm-Message-State: AFuF++lVl+HIgMAmxc1mSp2K21/2skluNcFpz4An3iRFCNqrZZMrVfEr
	KDpMLg59QHasbH3MIyT69b0aBUTs9vnwe4jrsnQwAj57DNkhoPxfUZgolJir8NqU553TE3+LULP
	n7kmRj4QFPGVY8g==
X-Received: from wmbhn25.prod.google.com ([2002:a05:600c:a399:b0:4a0:146:71bc])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:83c4:b0:49f:c331:39e4 with SMTP id 5b1f17b1804b1-49fe66ca101mr236728135e9.7.1790617311982;
 Mon, 28 Sep 2026 10:41:51 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:11 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-5-smostafa@google.com>
Subject: [RFC PATCH 04/15] fork: Separate vmap stack allocation and free calls
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	David Stevens <stevensd@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: okbqfh56bcdy9fjx1p31fb99g5bd388j
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 80733C0009
X-HE-Tag: 1790617313-929089
X-HE-Meta: U2FsdGVkX18vDDLxmGEU+sPq9lA0b/2xNgczEwDSYV+RkPnz/Ci92jmdn+wGjZYbtuY8H/CfMjkx/nOsHCHlTeN5vxEb5pj3wrqGhgrvp/unta7y1S3e+kky7uN+p8HJwW087XEfX0hQOjL689hSze0YTfJVXD57zrK7EP02LpJnUBCPfVe45h/jLRjTLL8LQDbJ3hOdoixXZJhbgJ2VG4MqMF6l73VHI4qm3RD5V3ByH3kg96H35WYHoUlHM0cwXSqTgJLxq1wNu+0zL7ZcYei3+ELN/PCK8KkJgDElIgaM2YoPdKAAkd65R7BgL14ytDKo1zkbX33YSAr/1LTsTVMFPlOE/qv3lhTUFDxdRtYjUY1ovyg+TSVFhgpQ0K1cBUf1Cwuj7x825U1m2mF+u/pid4PRcEGd+hABgHgeVWdB72eNKZKndDFXa45kaTO6TIAL2s8ZNl9w8jNL5fj07YcFQsHc0UKaQjaOLsOJnsTvbpqs0U8uYgyAuHFyj8XNEloTZjKe62AV64gczaWtBoa2sLfgHic0Gbhdw5mQWtmQhmLR5PLdVH67rtbIFzuQyR9ZU1jff2S67V6OKweePL45pnP1meEmvR0lkTdXgBsfYXojeiG5TZM7Ae5349aU2r5fGRlByxK7PkYS2BciI1bJ2wCI2tFFSZQA2peU/O+bvXCFm/Ap5IQlw3AoHvfqreb3+If1ICofc2qRd03QAzXY7AfOWyeIEO876l2hHpgKl3QPNwj1Lu48kOOYCL/YJSrTKhh50z+XTDU/xTGn0XZGdIk4Wg1MWqAvA87vGWWNeABbMgIPIev8xf6JklL5zHWyr5erB6TG4/TqV7MRcN+iMz/wPt52BFpcmrwWtcviSSg4khAWfsqoPvzVWbJHDTC1F7IUzCW9rTF37sPAo3CFnVUIKKgMFx0CTniD1ZOAxoZul/cO7Q9T4bX3K4zTaJCljBvJX+oXtCMQ6Js
 FhAPcMU9
 IAu6+ro9U7x2SSgJ0nZAzLP+cfJHx88eK4VO1DkQJxnURUEPpXouWWdYINRnhYXFWQQim2t/R06AgCi1W73OG73+NPqGScCw6lqCpqqadMTrSjFzOs4I34JGsSmTk5oChKz0rle3mogoFFnBXod7zW3madUqtQsoSeUokoHy/4hNSZWNZwhD5EBUPyj/WMYoP+bGuJIEJQXfOgOq/3StnT2gNJgASOjBc9gvsKTbAFJ1l8kwLBCLKPrXXo99A/CBQoN0V+3ladc5CcLjbv7canQBbd3SyUdVEidOqD1E0vu1nnYW7cnqE+yvj2CPx0gBYp0KBLm9FzkgiHun+gq0CVK/NneW2wIZQtS33HAcsKzDmXZ2faNb6CheqUqDLR+TLIvOE7G4NOfvbg6M1pkksjYVQ6AxbFTUUsnbo/PohRN+ErHcR1gtJDTBKeimtcBX9ftY7DQTo6SwG4bwp3YaoKICY3OEjfjR2T3+LV/qvZf4tQj4PGyh7I+NnCCzyXSoHRHf2cMMwyZt0dPniC0R0e/f2DiTxPwKiscZ/ferRc54Fo+rdwqvoLxV5aw+cY36oYpl+8GW5npwklIwbpYqImCay5EFyLz3NLNNOS/gbybzRAbLYFpbBnwQxSAPTfVH4ysateRYOrYFgg3p2fXCttoA3y40W2PTFAkUM0myPkyCGfwMBHp8XGDBUzzLY+0PAkdND1IHowFjdF1unZbVkZtR/NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

In preparation for the partially populated stacks, separate out the
__vmalloc_node and vfree calls from the vmap based stack allocations.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[Fix a bug in original patch: free_vmap_stack(vm_area->addr)]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[Add missing free_vmap_stack conversion, fix typos, rebase]
Signed-off-by: David Stevens <stevensd@google.com>
[Resolved conflict in alloc_thread_stack_node(), update commit msg]
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 kernel/fork.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 473878d7f62f..3f1c46d8f7ec 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -272,6 +272,21 @@ static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 	return false;
 }
 
+static inline struct vm_struct *alloc_vmap_stack(int node)
+{
+	void *stack;
+
+	stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN, GFP_VMAP_STACK,
+			       node, __builtin_return_address(0));
+
+	return stack ? find_vm_area(stack) : NULL;
+}
+
+static inline void free_vmap_stack(struct vm_struct *vm_area)
+{
+	vfree(vm_area->addr);
+}
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
@@ -307,7 +322,7 @@ static int free_vm_stack_cache(unsigned int cpu)
 		if (!vm_area)
 			continue;
 
-		vfree(vm_area->addr);
+		free_vmap_stack(vm_area);
 		cached_vm_stack_areas[i] = NULL;
 	}
 
@@ -336,14 +351,14 @@ static int memcg_charge_kernel_stack(struct vm_struct *vm_area)
 static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
 	struct vm_struct *vm_area;
-	void *stack;
 
 	vm_area = alloc_thread_stack_node_from_cache(tsk, node);
 	if (vm_area) {
 		unsigned long offset = 0;
+		void *stack;
 
 		if (memcg_charge_kernel_stack(vm_area)) {
-			vfree(vm_area->addr);
+			free_vmap_stack(vm_area);
 			return -ENOMEM;
 		}
 
@@ -364,15 +379,12 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		return 0;
 	}
 
-	stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN,
-				     GFP_VMAP_STACK,
-				     node, __builtin_return_address(0));
-	if (!stack)
+	vm_area = alloc_vmap_stack(node);
+	if (!vm_area)
 		return -ENOMEM;
 
-	vm_area = find_vm_area(stack);
 	if (memcg_charge_kernel_stack(vm_area)) {
-		vfree(stack);
+		free_vmap_stack(vm_area);
 		return -ENOMEM;
 	}
 	/*
@@ -381,8 +393,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 	 * so cache the vm_struct.
 	 */
 	tsk->stack_vm_area = vm_area;
-	stack = kasan_reset_tag(stack);
-	tsk->stack = stack;
+	tsk->stack = kasan_reset_tag(vm_area->addr);
 	return 0;
 }
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


