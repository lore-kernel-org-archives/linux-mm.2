Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E39CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 177456B00AF; Mon, 28 Sep 2026 13:42:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D97C6B00B1; Mon, 28 Sep 2026 13:42:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC256B00B2; Mon, 28 Sep 2026 13:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C888C6B00AF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:42:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63166A3D86
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:04 +0000 (UTC)
X-FDA: 85263889368.27.B8D7E31
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf06.hostedemail.com (Postfix) with ESMTP id A6A9818000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HUD1GySE;
	spf=pass (imf06.hostedemail.com: domain of 36aa6aggKCH4uoquvchciqqing.eqonkpwz-oomxcem.qti@flex--smostafa.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=36aa6aggKCH4uoquvchciqqing.eqonkpwz-oomxcem.qti@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S18+bNUDQLF3l+YcVeHHvKuNDyoqJaJ7Bbt9+2o39Go=;
	b=Ax/4annARRIkxOPA9wT19MW3HQJoF5j4KU04PvhVRoqjoawAfCSpTCkwsTmWKHmEtKbSm/
	r3wmYyropKpdYFqHF2xzryJatzZerr/5ChcmFXj5OnB6J+zYdZj6EgzhsxDUXEKInTSCyF
	DjY+vBSVot+EgxOZ79IP/E0wzRVLDTU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617322;
	b=fygI1tOkf0aec4cWkA3czUHRJxKJkLtdOs2GLdft8mKbC9B9BsEkwTt+/G254CGjjhIDby
	xTrKo3iE99LK20GekiUxtpZcJfEl82tu0XdJvKrEagFdwBujNgNQQ+57xjsBx3gtfJZStw
	c0KC4JzxzuWCFqm4jCJsxMtjrMtpj3M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HUD1GySE;
	spf=pass (imf06.hostedemail.com: domain of 36aa6aggKCH4uoquvchciqqing.eqonkpwz-oomxcem.qti@flex--smostafa.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=36aa6aggKCH4uoquvchciqqing.eqonkpwz-oomxcem.qti@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a0032846d7so13804995e9.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617321; x=1791222121; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S18+bNUDQLF3l+YcVeHHvKuNDyoqJaJ7Bbt9+2o39Go=;
        b=HUD1GySEhqD2uOCMH2joasuP0jpIKtIpBsbU/78rbMghpAjZbO71l4BZnrzlJFAz/P
         kUjxG38kAxLmXmIqoUPpNYNAVc07eQIV8wYVw1A8mK7zOyDYyfBVCMUU1cYVZyG4iLS1
         oDx4JfXRfbCUj7mNAHb3PhC4w+pkmaCytQoanBJFZ9jDil2VNL+QOOltU+1qhRXQHszg
         VJ6Gp07/Xoo/FxqGpUir8d2RyJ6/03sUHZjI3OzJS8b2LgUnXApBJAf1BJPp/hCJic4u
         B+1ESKG31xJJtO4vdqU93WCs0K5PpaXbdxmMZEGBjVc/eX+NH2Qvu0ohLcDZj9zQ/xll
         m6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617321; x=1791222121;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S18+bNUDQLF3l+YcVeHHvKuNDyoqJaJ7Bbt9+2o39Go=;
        b=zxqXBxQ8bEkBkplxltF24CtiO4QIB5H0EmlaCJiOAGmZcObCFIO/sH+CyfJW+qK+PX
         ZSQtohNfZGXnN+l/++DSqfVXOrF/roepiJYaUdzUoYFa+yWhw2UVCbGv90K3jiPny51I
         zQQccRObipIbnDmH/QpLEKKjg92rQGamrFlQCMCWYZ+OLEuRNgRe8iX2ehECH5UwrjSI
         pPaKbB4w5kzpMtHAvccjey0MGxhvpxomm4voZNbFGntN+3mB0O2ivGzcAQwpYTGrjX8R
         tL2+V7UCRX9YL6zk560raYYggmVHNbh13IqNp7WDwo2NSJxRhyDSXabbWKM/iLrwp5y3
         FSNw==
X-Forwarded-Encrypted: i=1; AKwUvBzaxYQh8bl/CWlTDtMLHafXNvtbhjH5bAf7ttlnyQ2dOJZI4b8jbeAD8oGjhRqfaMUebvvfnNL4wQ==@kvack.org
X-Gm-Message-State: AFuF++mGzsroxe2DdoZckcLGuuOzefA89oCtwqRTqJzwZ38CJXp7PFHf
	5sff9K64y8K4mzP8qLiTvwZeX2xk2clx9GOA7Vwts0kB1RDpP/cdgxKyuRPT5DEsaecqs2neQBG
	KlxMoFPOA85ndSA==
X-Received: from wmoy19.prod.google.com ([2002:a05:600c:17d3:b0:4a0:507:52])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6990:b0:4a0:3c3:1ad4 with SMTP id 5b1f17b1804b1-4a003c31c71mr63736595e9.22.1790617321190;
 Mon, 28 Sep 2026 10:42:01 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:18 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-12-smostafa@google.com>
Subject: [RFC PATCH 11/15] fork: Move vmap stack freeing to work queue
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
	David Stevens <stevensd@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: kixj8cuaxz7qmkf45s3uz4s43z7q3sk5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A6A9818000B
X-HE-Tag: 1790617322-283539
X-HE-Meta: U2FsdGVkX1+rhgi5diRno9veqCGU3Q3if6Bi9kbF/M8IQMoXTIO59nPB7keiy0r9M75A+HoLKPrvn++ZGCQr/Y0n5ZorvoqxQ+1TC2JgG/BS0N4dRT99rBaZkJig7mgHys4e5us4m4mn8cOztLXWeX2vpVKl/YsWUAlkodyNL3MwqI3Um/0a5lPUWKW8UNwf2Wwj1Lb41WcmV0YhTi15x5y2/1SaowJVg88ZjaKo3amAV/XSWNjZlY7TmDH0yzGjeVOYMQzAu0P8HT/ikxUSWKANOPXb1S5oPdrUBJYDIS2ksnDsqcQZEWIKmzKfHxUhQ3QB4B/vWhS1Zwdx0uCbAUrBg4hYfJR1QNnR2qMQLLyfx11iDQF4e6RAJ+iZK7Bdo6wH40r9otRdpF0+KUK9Qv1QhtTXQwj1+X5wBacjduLK7yxTD3s3AmA/49iHZMAKCHrY2AoUFrbcUYwD7ryZNb6mhMGPZvmINMbhx9J8KmJK1vvT71+YuREbOdHYiFzmywa48VFWhOzfGlMtbxRTereRyayzqOjuTAyKjwmDPnuuYnX3sAVhrVUjHk8IuS1EGjRn+Co5ep46k/HMIOjTWxZMgsVCQ7cuS4gT4WhdMjgMZCrNWeVvi+q80Bp51/WcCDGDNUC8EEJxvjL5lvHsj17fXf+ainyLInVrSEEv/S1YuehacDjowwCa35kjxuvHAgbXe+OmHkz9HdfUWLO+ZvGreBJ2/Unz7vauAVVS/kajfmAU3QvPSgRp7r8HzfNYGHCl03pHZuazubBrfAe9CAy1k+GaQ2vASFdGrtGnntjPbMyHGPJ9D7dRw8A3SggooT9EhCOeR/fgyH0emoZulvO6L6ESGu6JQvRycrHDqEkILVuDEPSxofvGkTyy6kaA/FGXmo5meuNE+bbS3im+nmrwQnHUOBhOWaSJvhPf+mC63xYeVktH827/GJEm4Zvf1Z6zd/fM+L6z12bdrU8
 i8BTLBeu
 6fQzZ5f+P6r2gUKIoYsLtPTyHnn+CrP1DyUsoRT1GtFJrVPBPbPHoZftanokqBA01wvML/NlKIa7jKG3k78mDa28cIiiomiyAhg0P8jJDdwzw8bN/tcV/SLuAqqyLIEmGqfDNTS6+BjEURLzTvcd/QCTOuHaXRtW5vLl+scoaJIa+qj4koWohtMDz0MCE/4oE/pfKpk6/qn/gtZhuSM/3MFgcd9bqnJRxzvucSRGQAi/VvHsE87KxqGCwKSYkJAOGCyJDsZ4m5zWL023fK3xQ42NCc3J4eK+qq5kGaveM6vqE51zuY5TIkmC67sYOFHGE+IkMBCPGiYuX8W6N6h6PLTaJcQXP/GBDesDDwnyiopk1NzxbRndlKC9q/MdM5UwuEY+gZj9igth/cWZGFaT8QlABdaIdHlCENoRc+WDgWkejR1TzQbKIXmfX6iDa3HuKm2FxtiHKop+lGwyhp6YP6dy4bVwx3ulID4m8w7V1m70bwbU4UlkCf8scS7yEczz/rfoOUEIrXf97ALv4E6T45GVyVi5sBd6wSUxO5+AX5DNPIADvrtE504KJlgHqxc9tqYfEtsKDVRWvk0MlDcdU08r53Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Stevens <stevensd@google.com>

For vmap stacks not immediately released into the stack cache, free them
in a workqueue instead of via call_rcu(). In an RCU context, vfree
already schedules the actual freeing on the per-cpu system workqueue, so
this change only affects when exactly the second attempt to put the
stack into the stack cache occurs.

Moving freeing to a workqueue will allow for freeing partially
populated stacks in a sleepable context (for remove_vm_area),
rather than relying on vfree dispatching to a workqueue via
vfree_atomic.

Signed-off-by: David Stevens <stevensd@google.com>
[Use system_percpu_wq instead of system_wq as it is deprecated and
 update commit msg]
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 kernel/fork.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3f1c46d8f7ec..ca8e68882316 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -208,7 +208,7 @@ static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
 #define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
 
 struct vm_stack {
-	struct rcu_head rcu;
+	struct rcu_work work;
 	struct vm_struct *stack_vm_area;
 };
 
@@ -287,9 +287,9 @@ static inline void free_vmap_stack(struct vm_struct *vm_area)
 	vfree(vm_area->addr);
 }
 
-static void thread_stack_free_rcu(struct rcu_head *rh)
+static void thread_stack_free_work(struct work_struct *work)
 {
-	struct vm_stack *vm_stack = container_of(rh, struct vm_stack, rcu);
+	struct vm_stack *vm_stack = container_of(to_rcu_work(work), struct vm_stack, work);
 	struct vm_struct *vm_area = vm_stack->stack_vm_area;
 
 	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
@@ -308,7 +308,8 @@ static void thread_stack_delayed_free(struct task_struct *tsk)
 		vm_stack = tsk->stack + THREAD_SIZE - sizeof(*vm_stack);
 
 	vm_stack->stack_vm_area = tsk->stack_vm_area;
-	call_rcu(&vm_stack->rcu, thread_stack_free_rcu);
+	INIT_RCU_WORK(&vm_stack->work, thread_stack_free_work);
+	queue_rcu_work(system_percpu_wq, &vm_stack->work);
 }
 
 static int free_vm_stack_cache(unsigned int cpu)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


