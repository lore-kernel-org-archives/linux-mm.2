Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 685D5CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3A66B00A5; Mon, 28 Sep 2026 13:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D906B00A6; Mon, 28 Sep 2026 13:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35D66B00AA; Mon, 28 Sep 2026 13:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A63596B00A5
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:41:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40E261C2484
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:56 +0000 (UTC)
X-FDA: 85263889032.18.066F3F0
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7A38E1A0007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wOt/ooFL";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 34aa6aggKCHYmgimnUZUaiiafY.Wigfchor-ggepUWe.ila@flex--smostafa.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=34aa6aggKCHYmgimnUZUaiiafY.Wigfchor-ggepUWe.ila@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLizaoNOz6hydwy+EEJKSgP0D8TbobflQ2CjOBToA3A=;
	b=QbiyXcVD9zPnCRxKNzWd8s8lO9UvwlytSH/Kmq89NMEfujDd3aAWyT8tCi/tY0ZbFsHE3+
	lUfIgnigmUWOAGIEN851WEaZYOzefcLLUkjvOgrSH0u26s9svN/f/MMDAlSs2ssItDHXyt
	xjZI1AQbIOWT9zxVZxzRsZ1rrKaQoWU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wOt/ooFL";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 34aa6aggKCHYmgimnUZUaiiafY.Wigfchor-ggepUWe.ila@flex--smostafa.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=34aa6aggKCHYmgimnUZUaiiafY.Wigfchor-ggepUWe.ila@flex--smostafa.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617314;
	b=N5WmeU81iDfyKypNVE+zDLFnP76tpJjsbOKvmc9IRwCaWhhIyubLmxK7wPgYPg9iincmry
	BzOOQuRDK+K/qajuUFZnv+Go/fPsBFrim/aGnjvgpvwWnCztBF/e2mwHfA61xlcfbW0mOz
	/C2dvI6Gv31DOfZfYPZssYIVJOXkwss=
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49ffdac5e6dso11570185e9.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617313; x=1791222113; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PLizaoNOz6hydwy+EEJKSgP0D8TbobflQ2CjOBToA3A=;
        b=wOt/ooFLUACWrx//ZjEeKLh44OVNiTgBuMEuZZUdSEirveEswjwU9DXJ4poKVcVig+
         5e+fI/ae7TBVI0pcFqUSbJSjLt6ver29n0MdOQr/PSeqXPsSf2/zuJHL1A9O21hA9JRV
         Sn0BmQGtz526MyjhrJZ3jh5Wbi52I8qhwuXMf1jtsrBspWWsboJbVUT0Nu5BsfrMAesU
         lEpZ+LtGCxXOiFtXj8Hd3sQKXxi4L7qOJ2dCYAntkPukT53i4CRFVqokr67PrZEjBjGa
         WtqYfYjhKP1tWi3v1R60p3ytLlere3YpLNPeJNJ9/mB88yi/SeXbfdsjnbQBdCtwkceL
         NwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617313; x=1791222113;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PLizaoNOz6hydwy+EEJKSgP0D8TbobflQ2CjOBToA3A=;
        b=OG/E7h9dZfWY4HXpdrDfx6pJYrHZ9UzbYd9vOMEHwAiqtDd/Hjt5eLyOKqvEy9BVGb
         0By5Ob/dhS5/R2c56QoHXNYlQwaUDtVA11JzYEROQsX9waip6z6S+XXyIuWQeyOZOZQ6
         r9TaPX66c1drNJje1FLE1rVCKmd0I7KG427H/dnE6tG0YwS0oZcaIAAMeArbtMYJSMeu
         rB+G5mDxhuJjQpKH1yExCBxhw7u8eeeDbx6Wxb9OuKuTbDUGINsA6LqsPT9iwh/HH29L
         WWduVbUNSFlEFDgTY8OaovOGuz8xg5wq+wQL50A804ABUrOU1xs8cmM5dQCLPp+mpBoY
         RVHA==
X-Forwarded-Encrypted: i=1; AKwUvByZXV8RskqgU26Sg11+OUlrvgFwHb4hVPsuU/27ccatxr3dwhwak1UpFAr5WuWclRPju+++Bp3YHA==@kvack.org
X-Gm-Message-State: AFuF++kfBV3RJ3EePoIj9AW5XIP9aFpuwVsXFtedlnazsXAtntWVKE5a
	htTTR45U17dgjkYlnXv13D9j9/ncAXhD3DXhqjPpVTAW1xG+/DsNYS4lUB2YGtiXqSGftw+/wzb
	tcIhGVC5QENhkGw==
X-Received: from wmnb21.prod.google.com ([2002:a05:600c:6d5:b0:49f:e43f:afd1])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:83c5:b0:499:bf0e:95c8 with SMTP id 5b1f17b1804b1-49fe66c8623mr231494305e9.1.1790617313066;
 Mon, 28 Sep 2026 10:41:53 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:12 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-6-smostafa@google.com>
Subject: [RFC PATCH 05/15] sched/task_stack: Add helpers for stack high/low
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
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: m6js6qt6erx7fxbu6matzhkmdpybr7sd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7A38E1A0007
X-HE-Tag: 1790617314-699198
X-HE-Meta: U2FsdGVkX1+aTaePThtJ9uNHXSvYi2DO66Vt65k/7zYN4BWrO9JbW18bbSSRIsEV9F+6nE+8zO8YsgkIRLyW7K21F9cENLqKAhpXv1PRVM/DvP0TlqDgN0o5MmB5mp59aN7YybDLfYjTmGkGDGWZl/KLon7B8FBQWxEiHfpr1DPv3JRiKi40tt/vf+xLtkwmDn6yxnQFbONSh0p6SXnX0E+9PLpb/BpEIknCHq31FQalO4Y0zQ6vfkyVyMldThC1I2fNRwCAimTuUYYUDq8uDIDU1gVbA7pl6vCS2UKKMAJql+xwmHmpz6VHqfsqTcgA5FSn1+kz6/Agqu1f3NMcUY3wEiJQdDY0CUCkyo8PCN+xgBgLrKmBi2d8XljWCUSsVuo7M7aowNM3D1OIit7ZdaMsw+tMRI92DcbfM5qOweznNvmLH/ra9Wi56cGbLqwg+sZY9r3RO3hKcSC3LfA8jYYIPNP2cAO2bkR8sI+1KCMwsRCxrpfVEf4h8cghHhUwQgzFWLR5ktG5COzeVwn1K7JwDUxmYtIbTUCO412PdFJYHT+514tVEOOYUlC/RATof1fLD8wFbF9+iM/LKNtRv9tgXXrr9hKRYnM64DvJFNF4h6+bkWDe5jmpZpKtlm/juiv9dg34O7jm5yw7gmYVr0Y21axIo9ZF2fHddJB2xqhkVckOeebaGODYQCuwQ4E68FmmbvDbgQigmFZpwOZuE0FDR1wXfUJmD7ELY/WAZNUDi54Ht21t6wlzO+J+3ajFN+ePAKASa8GO1Xw6aig2KvizCBGWpOuQdTPznHl/RvQ7USVMcp3Z3vscQCVwEzqNaOfR0GFCmh6R2MByiKlD+odO5o84nc2cw1cPSRfVxfZAnPoTCz8CGx6tORXhVUsiFU8tAKJVlch2rD9OtXVvBmnTFcp7YADrvyKqs6lThPlMMy83P63XXKaQTACo92QZRphrl5ec8decWHaGf2C
 AUbh03C3
 cTslQF54Ar3nZkqDLRMfgnvYRfJ3pPP4tK7if3b5R18Ol2LrJJF6GADEp32lgpvzWujvZauavBOR+QW87pj9L8dgGcUKn3hk6HHDAvp5fYvXyVhPesqiiYQO52yfKKNjPelvbBIQaxu2lPxKAtX3/3My9rElrDh9Bc5qx3DK5CzD3iD+5Tb0s0NPCsS4oVIjxhXqpgjWOfQq/2RsvhKtpLe6AgdLme0BfIvis6hqfr1p1yWQKm9tBtiHToG1WW5c6/zRAgSLiOdIrd5eV3vp8Nh8KjpK1hThzc6UBKIvzyRu+kCMLMnd4ErUNtgi9RRXYlH9eY+8qqW8VRs4jq9/jYLzTa0123KIiDG7jp2PXTkkW2RB2CAT30BtRUxxVkn8GZ5rbCU5i0++naUYbhaEzON+sUPoOLBy+5YXiakX5lF2qmEVxrA3o2K5yRCkuda3VF7EoffOcwjIdk/f+UYXabJmOJMBz/khhvZi87NLc8e562EFbTJXprQJ8DtikVP+wx98ktYqwWqKH3COPF7Tz6OSV1h/nNRXhdse3YI0IwiZEzU9/YDVwhpOQc89l5JgJ4j7Vz0JURUut5eEiu5jXkzD7D6G0TWskirLXPdctDSnfSxl7BwYiBSci73KympU1Yw5aCiQljkdWNF4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Soon, memory mapped for a kernel stack can be less than THREAD_SIZE.
However, many parts of the kernel assume it is.
Add new helpers for the kernel stack that can be called regardless of
CONFIG_STACK_GROWSUP or the kernel stack size:
- task_stack_low(): Lowest usable address on the stack.
- task_stack_high(): Highest usable address on the stack.
- task_stack_size(): The size of a task kernel stack, it is still
  THREAD_SIZE at the moment but that will change soon.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 include/linux/sched/task_stack.h | 56 ++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index 1fab7e9043a3..4a808f9c4631 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -13,6 +13,8 @@
 
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 
+static __always_inline void *task_stack_low(const struct task_struct *task);
+
 /*
  * When accessing the stack of a non-current task that might exit, use
  * try_get_task_stack() instead.  task_stack_page will return a pointer
@@ -30,7 +32,7 @@ static __always_inline unsigned long *end_of_stack(const struct task_struct *tas
 #ifdef CONFIG_STACK_GROWSUP
 	return (unsigned long *)((unsigned long)task->stack + THREAD_SIZE) - 1;
 #else
-	return task->stack;
+	return task_stack_low(task);
 #endif
 }
 
@@ -64,6 +66,53 @@ static inline unsigned long *end_of_stack(const struct task_struct *p)
 
 #endif
 
+/*
+ * Kernel stack layout, higher addresses at the top. task_stack_page() is
+ * the start of the THREAD_SIZE area, task_stack_low() => task_stack_high()
+ * is the usable stack.
+ *
+ * Case 1) Stack grows down: Only the top task_stack_size() bytes are mapped:
+ *
+ *   +-------------+ <- task_stack_high() = task_stack_page() + THREAD_SIZE
+ *   |    stack    |
+ *   |      |      |    task_stack_size() bytes
+ *   |      v      |
+ *   +-------------+ <- task_stack_low() = end_of_stack() (*)
+ *   |   may be    |
+ *   |  unmapped   |    THREAD_SIZE - task_stack_size() bytes
+ *   +-------------+ <- task_stack_page()
+ *
+ *   (*) Depending on CONFIG_THREAD_INFO_IN_TASK, end_of_stack() might be just
+ *       above it.
+ *
+ * Case 2) Stack grows up (CONFIG_STACK_GROWSUP): The whole area is used.
+ * No support for partially mapped stacks.
+ *
+ *   +-------------+ <- task_stack_high() = task_stack_page() + THREAD_SIZE
+ *   |      ^      |    end_of_stack() is the last unsigned long below it
+ *   |      |      |
+ *   |    stack    |    THREAD_SIZE bytes
+ *   +-------------+ <- task_stack_low() = task_stack_page()
+ */
+static __always_inline unsigned long task_stack_size(const struct task_struct *task)
+{
+	return THREAD_SIZE;
+}
+
+static __always_inline void *task_stack_low(const struct task_struct *task)
+{
+#if defined(CONFIG_STACK_GROWSUP)
+	return task_stack_page(task);
+#else
+	return task_stack_page(task) + THREAD_SIZE - task_stack_size(task);
+#endif
+}
+
+static __always_inline void *task_stack_high(const struct task_struct *task)
+{
+	return task_stack_low(task) + task_stack_size(task);
+}
+
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 static inline void *try_get_task_stack(struct task_struct *tsk)
 {
@@ -88,10 +137,11 @@ void exit_task_stack_account(struct task_struct *tsk);
 
 static inline int object_is_on_stack(const void *obj)
 {
-	void *stack = task_stack_page(current);
+	void *stack_base = task_stack_low(current);
+	void *stack_end = task_stack_high(current);
 
 	obj = kasan_reset_tag(obj);
-	return (obj >= stack) && (obj < (stack + THREAD_SIZE));
+	return (obj >= stack_base) && (obj < stack_end);
 }
 
 extern void thread_stack_cache_init(void);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


