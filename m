Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 080E3C5ACAB
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 13:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175286B0093; Fri,  7 Aug 2026 09:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C556B0095; Fri,  7 Aug 2026 09:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062176B0096; Fri,  7 Aug 2026 09:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2A5A6B0093
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:51:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B059403DB
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:51:00 +0000 (UTC)
X-FDA: 85074609480.18.E9C5078
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 89843160004
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:50:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bftfFwcV;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786110658;
	b=LMzidUrD2DQPyRJieojMCHY9yIXLMqnZWzqFar/m7De6dCyuq5UE0P9ogNKHHtXgpb69uZ
	eIdgdSFfLkspv3PraHz6xU6LTb51ASw1ad2ocRznDS+XwYLPMqlFRKJ4W20n9cvQ0fad52
	rGLbFPmY7nBvhdj6nnzsmLqnGkvZP5I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bftfFwcV;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786110658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qw5EXLRgG7MVbyyzo5Hfu/12GgcU/fQ9naW0jlMMCd0=;
	b=YEH8PHC2KwNWc2jRdbee5tcn0Zk92Gw5oTR6ZSInm95GTwDtyCsiflHEjLi6WtW9B4i8Ea
	B/I12qiy/1sedEh0i0tWMDBXb83GeUH0wVLoTZ3N3h0K5ZdepDrCGVdYdZ2wp9KFyUYv2O
	OlMtLAErAFv4++aY/FKIw/iHqXf7UOI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCD1643F53;
	Fri,  7 Aug 2026 13:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343681F00A3A;
	Fri,  7 Aug 2026 13:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786110657;
	bh=Qw5EXLRgG7MVbyyzo5Hfu/12GgcU/fQ9naW0jlMMCd0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bftfFwcV3aDHjtMAwILI5O79RrtunZvph2GfZ9MMZn6kCchr0mEVG/ybaswejvRLv
	 zlukEzJFtGZZeEBuRq2bouOGb9Md9UY4OzBhzrlTHCeJ8hnJZUHx31OveMSFd0WEo8
	 rytPjymjr0QPgGh7kEBi40uKhi3kytwMtwq4QfMFB1uMw+YtlNdyy3fb5bKX0u+u+A
	 SfIie0u/oyt6/TO3TDYcftfy7mMve8wXr9GFyWhWakLhp9E4HgylEkZK+glgFSYYJq
	 gytQRdLKrenFLW6NRiZI69kZ6tKkt0gh9M16PQvzC3cd40dRpfFij+/C6fgbpCIkSK
	 LPNLY9CjGjJqQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Fri, 07 Aug 2026 15:50:29 +0200
Subject: [PATCH RFC 3/5] mm/slab, kmemleak: handle kmemleak freeing in
 kfree_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-kfree_nolock_kmalloc-v1-3-ba993cbf7a60@kernel.org>
References: <20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org>
In-Reply-To: <20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org>
To: Harry Yoo <harry@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, bpf@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Dmitry Vyukov <dvyukov@google.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 kasan-dev@googlegroups.com, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
 Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-rt-devel@lists.linux.dev, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 89843160004
X-Stat-Signature: b3h3pbzieuusdgxagabz88a83dxjzenc
X-Rspam-User: 
X-HE-Tag: 1786110658-820540
X-HE-Meta: U2FsdGVkX18e18nsF7cCHg8vqP8mLHNnoWH0KxIVdzUb6x02XDYRpk2ecLc/aEOku73CxxI58M3LdfnFJvrdjQiEzc7ab8dJznrUT9Q+7Qayzeq8LFxypP9NDbXLtvY20bkIqzehNi/1q9i0ksoIX8WZT3y2a1BjNFcAZ9Rr8fgJVhdplv7T/2PVjlAWcHjDuJg9fKMLMDlgR2wHDqe7pXSihYH73fpQLCkkHJOx0JaV2Gkfri9QUzeaYrsT5wu0lmG11OfExjIoLZmSyp6kphTCVIAk8GaFk9/qJwXdXA8ZJyQZJewmdDUdC6vdQFNSYyUIQVasktNu5AH0nnv3Us7UXM+MxV3NbXJ7CVMzA4+PblyXp6EqfzbSGt9OX7kunrMfLaeQpLk/wjLuoAs2an/3dzXVx3mO6qq3y/t7IQXX93tTs3PuGCSvaWvq0s6cHd0qHLyd1Lwnp7XNEXC2zsG54ciRH4V6HEknrSHrgZ/ipIxSMqAArnpdWn8eKK49CpO5Wo0UAm9nBvxokIzkZqSStJMJF28lwWR5IwmdKrnGzWEfg0dMMGVEOEcAQZxibdcJQA6GrmNWgSnGLkVTxpvExblzf2VmIWp0S162pJ8B4LQRkdwLIz3VxtNaJMNJvgpcD9xHPgMQuRVMa7jeqDr89Mq6mo/5Q982z7TOsaNkgTliao0oRdQj+Dp4HuZGg0hqaby1vwNCxtsSWEzld8oPMeuBiBHO4YFNoTH5P4B9gHAeg08ngD8AfwtJ3Bp6XzcQkT0gCEns2IvVOw0uG/mgbdT741v4EXPbknzRjJSscFqJBdsmwSiEoGJUpioFkup0f5pzDkrnOnNRPP2sbVP8eWaOU6TuXUVJlxEXjl3uOKOteyfALSQFp3Z0diWRG4psA3shim7LNpKyo7G9AzcyXQqrBtTvBjjyItqCV+VHVM2HhyocYckXPqUq0FZK/+fdTbpvSeK9liYXyHe
 cCJCO5yM
 2/K9XM6F3xej5vN1zrgYSMLUyNRTOdMUeZ93YVPjIlIW7vqINpYmE+t53RMka4HuntI3G5Sbr4L7cBYkwDBecSpx7dBuBkVAnPqIUBYyndnyLI4G3ostoEIy0Od5n88e4CBIWX/aunaIQfbMiTgxaEycUk//yHdtkkfOBNnWy69yUFHFSpJm1ygxz0QY1TkIVdGZ35dL5e1RiUHVEyU4JdQEJlPI3bA89nizNFSo9u01LmyLd7dFb0LgeY27hOjYoXEtzq/eP/16Ok7HNEvIPBwsbjNJ0ThTJEA0zRUE2zc8jPNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kmemleak handling is one of the reasons why kfree_nolock() cannot
currently handle kmalloc() objects, because calling kmemleak_free()
would involve spinning on its internal raw spinlocks.

Kmemleak is a debugging mechanism so we could simply defer all
kfree_nolock() to irq_work if it's enabled, and eat the extra cost. But
that would be unnecessary pessimistic. We expect kfree_nolock() will be
still mostly called on objects from kmalloc_nolock() that are not
registered in kmemleak so they still don't need any deferred freeing.

Thus introduce kmemleak_may_need_free() that can check if the object is
registered. This is done using __lookup_object() performed under a
raw_spin_trylock_irqsave(), which is safe to attempt from kfree_nolock()
(except from a NMI on a !CONFIG_SMP system). When that trylock fails or
can't be attempted, we however must assume the object might be
registered, and defer the freeing.

The ordering of kmsan/kasan handling and kmemleak is also different from
what kfree() is doing, but as explained in the comment, it should be OK.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/kmemleak.h | 17 +++++++++++++++++
 mm/kmemleak.c            | 42 ++++++++++++++++++++++++++++++++++++++++++
 mm/slub.c                | 34 ++++++++++++++++++++++++++--------
 3 files changed, 85 insertions(+), 8 deletions(-)

diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index fbd424b2abb1..52f75f10a9ce 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -22,6 +22,7 @@ extern void kmemleak_alloc_percpu(const void __percpu *ptr, size_t size,
 extern void kmemleak_vmalloc(const struct vm_struct *area, size_t size,
 			     gfp_t gfp) __ref;
 extern void kmemleak_free(const void *ptr) __ref;
+bool kmemleak_may_need_free(const void *ptr) __ref;
 extern void kmemleak_free_part(const void *ptr, size_t size) __ref;
 extern void kmemleak_free_percpu(const void __percpu *ptr) __ref;
 extern void kmemleak_update_trace(const void *ptr) __ref;
@@ -50,6 +51,14 @@ static inline void kmemleak_free_recursive(const void *ptr, slab_flags_t flags)
 		kmemleak_free(ptr);
 }
 
+static inline bool kmemleak_may_need_free_recursive(const void *ptr, slab_flags_t flags)
+{
+	if (!(flags & SLAB_NOLEAKTRACE))
+		return kmemleak_may_need_free(ptr);
+
+	return false;
+}
+
 static inline void kmemleak_erase(void **ptr)
 {
 	*ptr = NULL;
@@ -86,6 +95,14 @@ static inline void kmemleak_free_part(const void *ptr, size_t size)
 static inline void kmemleak_free_recursive(const void *ptr, slab_flags_t flags)
 {
 }
+static inline bool kmemleak_may_need_free(const void *ptr)
+{
+	return false;
+}
+static inline bool kmemleak_may_need_free_recursive(const void *ptr, slab_flags_t flags)
+{
+	return false;
+}
 static inline void kmemleak_free_percpu(const void __percpu *ptr)
 {
 }
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 7c7ba17ce7af..e3560ce82632 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1168,6 +1168,48 @@ void __ref kmemleak_free(const void *ptr)
 }
 EXPORT_SYMBOL_GPL(kmemleak_free);
 
+/**
+ * kmemleak_may_need_free - check if object is registered
+ * @ptr:	pointer to beginning of the object
+ *
+ * This function is called from the kernel allocator when an object should be
+ * freed but the caller context might be unsafe to spin on the internal locks.
+ *
+ * It will therefore only use trylock and thus might return a false positive
+ * if the trylock fails and the status cannot be determined.
+ *
+ * For objects that (might) need free, the allocator has to defer the actual
+ * freeing to a safe context.
+ *
+ * The assumption is that most objects freed from the unsafe context are also
+ * allocated in such context and thus are not registered in kmemleak, so it's
+ * unlikely the defered freeing will be necessary just because kmemleak is
+ * enabled.
+ */
+bool __ref kmemleak_may_need_free(const void *ptr)
+{
+	unsigned long flags;
+	struct kmemleak_object *object;
+
+	pr_debug("%s(0x%px)\n", __func__, ptr);
+
+	if (!kmemleak_free_enabled || !ptr || IS_ERR(ptr))
+		return false;
+
+	/* On UP, raw_spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return true;
+
+	if (!raw_spin_trylock_irqsave(&kmemleak_lock, flags))
+		return true;
+
+	object = __lookup_object((unsigned long)ptr, 0, 0);
+
+	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
+
+	return !!object;
+}
+
 /**
  * kmemleak_free_part - partially unregister a previously registered object
  * @ptr:	pointer to the beginning or inside the object. This also
diff --git a/mm/slub.c b/mm/slub.c
index 2d7648b96bfa..423b5bdb910b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6390,6 +6390,8 @@ static void deferred_percpu_work_fn(struct irq_work *work)
 		/* Point 'x' back to the beginning of allocated object */
 		x -= s->offset;
 
+		kmemleak_free_recursive(x, s->flags);
+
 		/*
 		 * We used freepointer in 'x' to link 'x' into df->objects.
 		 * Clear it to NULL to avoid false positive detection
@@ -6403,8 +6405,15 @@ static void deferred_percpu_work_fn(struct irq_work *work)
 
 	llnode = llist_del_all(&dpw->objects_kfence);
 	llist_for_each_safe(pos, t, llnode) {
+		struct kmem_cache *s;
+		struct slab *slab;
 		void *obj = kfence_llnode_to_obj(pos);
 
+		slab = virt_to_slab(obj);
+		s = slab->slab_cache;
+
+		kmemleak_free_recursive(obj, s->flags);
+
 		__kfence_free(obj);
 	}
 
@@ -6781,15 +6790,10 @@ EXPORT_SYMBOL(kfree);
 
 /*
  * Can be called while holding raw_spinlock_t or from IRQ and NMI,
- * but ONLY for objects allocated by kmalloc_nolock().
- *
- * In case kmemleak is enabled,
+ * but may defer freeing to irq_work() in some cases.
  *
- * obj = kmalloc(); kfree_nolock(obj);
- *
- * will miss kmemleak book keeping and will cause false positives.
- *
- * large_kmalloc is not supported either.
+ * Intended mainly for objects allocated from kmalloc_nolock(), but can handle
+ * also kmem_cache_alloc() and kmalloc() objects, except large_kmalloc.
  */
 void kfree_nolock(const void *object)
 {
@@ -6844,9 +6848,23 @@ void kfree_nolock(const void *object)
 	 */
 	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
 
+	/*
+	 * with kfree() the kmemleak handling happens much sooner, but for
+	 * defering we need to write llnode to the object's freepointer so
+	 * we should have it in the state when it's no longer treated as
+	 * allocated by kasan etc.
+	 *
+	 * defer_free will also reset the pointer tag, but it's ok to do a
+	 * deferred kmemleak_free() using the untagged pointer, because
+	 * __lookup_object() resets the tag anyway
+	 */
+	if (unlikely(kmemleak_may_need_free_recursive(x, s->flags)))
+		goto defer;
+
 	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, x, false)))
 		return;
 
+defer:
 	/*
 	 * __slab_free() can locklessly cmpxchg16 into a slab, but then it might
 	 * need to take spin_lock for further processing.

-- 
2.55.0


