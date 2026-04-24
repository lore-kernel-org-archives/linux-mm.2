Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2211AFED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DECB6B009E; Fri, 24 Apr 2026 15:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F22D6B009F; Fri, 24 Apr 2026 15:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346396B00A0; Fri, 24 Apr 2026 15:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 139C76B009E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:17:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D12141402A4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:02 +0000 (UTC)
X-FDA: 84694407084.12.7205B79
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0A20F80002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mwaIodzg;
	spf=pass (imf02.hostedemail.com: domain of 3q8HraQgKCDQijUlUdiTWeeWbU.SecbYdkn-ccalQSa.ehW@flex--stevensd.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3q8HraQgKCDQijUlUdiTWeeWbU.SecbYdkn-ccalQSa.ehW@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/N+N4eCtpYxHixfaIFLv9JBOjdUyGT3kJeE3HTW8Oq0=;
	b=zdISV6Kc9mJL2F5wxE+SNV1lR8SkVqnKb83ylSDLZv9TdEbH4A7c7Y/yxvEiRbadFVfmKh
	G17VP8XcArt+UVipHC76EMaLM7wL3B/ZzP/Mkdej+Vn1GV66ELVCBZjwN+MID2ZQBuSqag
	JOJeGcjPOPX9SebHSaJ8Gs088cWUyCE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mwaIodzg;
	spf=pass (imf02.hostedemail.com: domain of 3q8HraQgKCDQijUlUdiTWeeWbU.SecbYdkn-ccalQSa.ehW@flex--stevensd.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3q8HraQgKCDQijUlUdiTWeeWbU.SecbYdkn-ccalQSa.ehW@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058221; a=rsa-sha256;
	cv=none;
	b=vJa1WXb6DUds7R17ZC+sY7CtQnI9OkdB9RMGAUY3bE1x59DQAzU1Qct78UmS2bKzBaAfQQ
	T2kxJHg7B0FCFRAMpRGCBYFfF0BlDzGWboxrBzExiSzXWIJNoTen9Eu78JiYOpFQlVOmmA
	ej2ffRXs34BFjBOZAHh+F3Grfemp92k=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2bdf6fe90a9so11988006eec.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058220; x=1777663020; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/N+N4eCtpYxHixfaIFLv9JBOjdUyGT3kJeE3HTW8Oq0=;
        b=mwaIodzgD8AL7wVIbsRoQXgpRHgpu4wMmBHs0AI8haUuY+gS3+i7PYn2yTfxutjUg4
         UvColAB+MzpP7QxJ29YmdY98Bb3Ys/I0xu5hGCu4xbMGR+fm1EkPZfHcHhK23OOE5MjC
         OBUXfXkQscIQb5IZnfafDefFVh/b3IDtnSeDrU7k46B2gF3R5Hlwvh41KTTau0zaXW8C
         ZnEuzYCFUkNPZcXlMG7jk7zYQihv35aP5RGPD6LlEXVpeRl3EKEVKXbWm0ISW5N2DuVu
         yISYU+mEV4HT7ZVJxu7A1EPl75NfuKqfmOtfPE6Vckiwy0Pp8b63AlDQR1W5yTheEmhD
         LBgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058220; x=1777663020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/N+N4eCtpYxHixfaIFLv9JBOjdUyGT3kJeE3HTW8Oq0=;
        b=qb7/LPFK3Zlp2ujwS7KlP1pteIBc1QTd9TGWd9ujcrOhwCIoRow0NklZa38AqofsDK
         QCE/YWReLbA9JIWc2FtRh4MJhZG0Wf1mDXkw3cn3LMVvAzxHROCHSE8rSZhjoDf/g1iA
         cnl0YTLie8Ww7DJnjfclcUtwQoSXqkv7V59xQniQ6aEFRa+cXlxLWvqGheH5beiQjjNP
         3t/XZMcbp3XmGYABypqiAO218QE+3/zYHqUa67KsWWrU9djCqFUuxYwhbXbX+SycqrLP
         eLOrt2tR5+XBM3cZ0bagNo3ljcT1dIKu0Fpn381CYR1HZAnbT5cie8gIn1UCtgx2tI9i
         fjfg==
X-Forwarded-Encrypted: i=1; AFNElJ9a/dPJ9G2w26dTNxxh8yMW0YXZuJO2Gm4IBkRmUXT6I0zo63Hfxp9UOoTySb0pCnMgXU7+Wp054Q==@kvack.org
X-Gm-Message-State: AOJu0Yx/0WtlrVfTszoji+X9gziX0wA4HA3k8j0POyuMHrD1MG7yyHrC
	3nzw0kade24Py5FvBal5w4D7+0AAbrXUpzXDPTqJ4PI2pC8h/5+svKQ0Tk1+QD3KaWWeYmodcsT
	5muZpC2BD4npw3A==
X-Received: from dly15-n1.prod.google.com ([2002:a05:701b:204f:10b0:12a:83c5:a16f])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:50d:b0:12a:747e:5b5c with SMTP id a92af1059eb24-12c73fa3af3mr17422533c88.24.1777058219493;
 Fri, 24 Apr 2026 12:16:59 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:49 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-7-stevensd@google.com>
Subject: [PATCH v2 06/13] fork: Move vmap stack freeing to work queue
From: David Stevens <stevensd@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A20F80002
X-Stat-Signature: yddp3z7g4ay7e9s7inexaina31hmjk4f
X-HE-Tag: 1777058220-221822
X-HE-Meta: U2FsdGVkX1+1SlJrXo/DD4apKYtrvo6Ou/lfIPyvxOYSMbIx34zoRY3hRWbkKDbNv45ihnhSBZo2HzDPrWOqY52BhOOwLJjH8SZd6Znbjjnavnlq/wz2kQTBgU6eCtXCz6xZju4ycb99ZKBwA6k3cC3RREb2rEGqpVPW/N6U5lBsAvroexzx8yF5DoopXikzs79fKWrATWESAiP28YYis75IIG12WsHJpv4y2x98BUGX1CjRxd1sLYlZ6dt0GDpirTbZUx9eXHj8D64galkKW309+ig4FcCgDoR7CkEIOWNRqjWiK3fKtOr+BGkI4Y9JK7sJDin6f559TQaX9Cq+2L490rJOV8UnPdLgqHVtgUYSZh+dX+8KH5OYiJ7mIlNW6UQEbw+5oNmU3Cf/5lmqAYU2IwWSOcM6YKdF9guWj9hoEWTn1LBIMJrfhdP/5JPoolf0bfYC76P9SGT57WGLhkN06WWrSo/l03tuZNvquxMsKuvfpuRz9O9j8iDWzs1wI0AW7MlEa67OWEd5BOK6udOgW8cikO3CcM43C1Ona1LK/6xJaWN5BoYyew6WF4Nwrl9M7ggIcxPVSNVc5ymzxJx2A5pn5Plj6SFsMmhKbO17iLgLw7qQvLmHveGWrKOQ5FzjhzIDpI+PuSDCX+ma8/xc2eNHwCy04Vaw98B5iAwMx8o4seDrHISYEWnyIsmLN4T0J2ctGrBqWZEa0qOw7kKrNlEYVewzbPIVJcOcCGl0NB7L9Qmw0DPKKzMpIDBJlI2EFU7Te6hVZU0TRyQ/90IfC/Ta+FLQpVHQpEwSOOisjX1nwzbGAtjYS/gTaOVnE6rYWIFo6Qxws5ex2HvudBnhvHDSgwhICO4nGhTk6+77MBoleQvcP3toWuiH/xMShHSCJS4Dss0OmIBfrQeagevOd03RmhpmvJhgayX34nevjvk//eyqbrFeb8Z0XViTVrlVcOsgAEn625TjN3F
 xQhZe9dI
 yRHo6mOvMhPuLm6GfETV8V0zmqrSIML92MaNjXHYoUf/WTS3CLInCYcn614CDjLT+XbCrXG/petxOVzhvKM8nIDsFyS5jx3LUjRcFCNvp++oRvQleqHvnAaROqR6oce62qDoOm3xsUfHUwkWLIR2YKG/nxa+tNPL/g9LtP1GLcQ/1YdOU6SYkOC8/ZLTSYeHQUc2Ryq3sX7xrciPYQ5bs70gAyZCGbe1Rh7CXGsq0XWUO6gg07SGseXND7kSDsEhuBZ0YctHemDPURcndDRi7xlGh9DSjsNiudcD0LkivMguwwJ/DQdw+FlHjr8TtRL2gRvIV3tG1OWUaXGpM3tep7nZ/zJBzhERWd1plQvDevPHxjBh+Owc+zDZcgMHtI/xAtktx4mB0hLQarQ27PjrZahQuSgLpGoM3X7pyLwrcrO2Ipq16QihKYjgA9whOPObKo6vIUxyNCxr0B7ynvAa7D3nt3zkjBbWby4b741vFFmo/X8jpgY3F6QUaJaSAcQsh7jCG0vVp/qOsetgM6vpIJimU9edE04CdtWSfes85uF3uTSHShZYR4mKyU5YqBJ2DKY6MExTF17kTDHZOXa4TpO8tIJrSRRjtTBY0Td/Vz2sVYILvoQybbmHrVGk6szK+zt1OcTPoE1N6yL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For vmap stacks not immediately released into the stack cache, free them
in a workqueue instead of via call_rcu(). In an RCU context, vfree
already schedules the actual freeing on the per-cpu system workqueue, so
this change only affects when exactly the second attempt to put the
stack into the stack cache occurs.

Moving freeing to a workqueue will allow for freeing dynamic stacks in a
sleepable context (for remove_vm_area), rather than relying on vfree
dispatching to a workqueue via vfree_atomic.

Signed-off-by: David Stevens <stevensd@google.com>
---
 kernel/fork.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8bf32815f422..01e0bf4f4b02 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -205,7 +205,7 @@ static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
 #define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO)
 
 struct vm_stack {
-	struct rcu_head rcu;
+	struct rcu_work work;
 	struct vm_struct *stack_vm_area;
 };
 
@@ -284,9 +284,9 @@ static inline void free_vmap_stack(struct vm_struct *vm_area)
 	vfree(vm_area->addr);
 }
 
-static void thread_stack_free_rcu(struct rcu_head *rh)
+static void thread_stack_free_work(struct work_struct *work)
 {
-	struct vm_stack *vm_stack = container_of(rh, struct vm_stack, rcu);
+	struct vm_stack *vm_stack = container_of(to_rcu_work(work), struct vm_stack, work);
 	struct vm_struct *vm_area = vm_stack->stack_vm_area;
 
 	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
@@ -305,7 +305,8 @@ static void thread_stack_delayed_free(struct task_struct *tsk)
 		vm_stack = tsk->stack + THREAD_SIZE - sizeof(*vm_stack);
 
 	vm_stack->stack_vm_area = tsk->stack_vm_area;
-	call_rcu(&vm_stack->rcu, thread_stack_free_rcu);
+	INIT_RCU_WORK(&vm_stack->work, thread_stack_free_work);
+	queue_rcu_work(system_wq, &vm_stack->work);
 }
 
 static int free_vm_stack_cache(unsigned int cpu)
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


