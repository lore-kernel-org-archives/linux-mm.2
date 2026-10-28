Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C84606A33F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 19:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=W77n95gd
Received: by kanga.kvack.org (Postfix)
	id 9F6466B00EF; Wed, 28 Oct 2026 15:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CDAA6B05B1; Wed, 28 Oct 2026 15:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BCBD6B05B2; Wed, 28 Oct 2026 15:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6BF6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:40:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB2A9A026D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:40:20 +0000 (UTC)
X-FDA: 85373051400.10.C177F00
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECBE418000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:40:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=W77n95gd;
	spf=pass (imf24.hostedemail.com: domain of 3oU_iagYKCCgOYRMcYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--kuniyu.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3oU_iagYKCCgOYRMcYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793216419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9zpy3NAVqmZUXCspMHykAFp62eds2iCaDj7iI5VN0iY=;
	b=Wc6YNXWsZrezM9gaVoA56+DZ1y+LSeHDWmj+REVCBlrD9/lVsszjFfJjiZeDC2Ru0AsNA6
	UOZooKz1KqLObXJYT0+XzOpbEnaacZqYTCb/prvOCaEXs6YCOaoGyOTKCFquhZ/pnt1Pi5
	vgZ2khfWexhLTg1NuX5r8yx6DmwGU2M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793216419;
	b=Mq3BDOdkz05cQtFOtrwTIOJM674IGm1iviirNLdGh0RINfKDOQ0VBvd1f8MU7yf8yOTwQX
	DJjVHdwdHw6ehl8Kb6iyYU3n/JqptCm5IfhJfsCexc6Anr+0869KaSh3CK88/TCyoywO6w
	O8yChnh7HL9nduPaqJ4/Hd/4p5j0t3k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=W77n95gd;
	spf=pass (imf24.hostedemail.com: domain of 3oU_iagYKCCgOYRMcYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--kuniyu.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3oU_iagYKCCgOYRMcYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-89f84753b43so1055837b3a.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793216418; x=1793821218; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9zpy3NAVqmZUXCspMHykAFp62eds2iCaDj7iI5VN0iY=;
        b=W77n95gdRY+8t17p8WjC8KtrH6AmrGbBRV3hLw/9gHTdebWz7Z5+s4ojjfgHqJvHbi
         uytGMXDfbAzCoj73b5Xa4nsRGwGxxYVfmia+TtUY7SHq7lTK37DZMjHZQzUBZnAQsbt1
         2EL67gOTuqDZ8LEWqI15CdEjPH+YIc6aqmGqA2wG7k3kvqCkiWvybB+n/AcTuYQUWJN7
         tjQ6kDcQL4rBqALRS/QPo4qPk2dDInmcU6ZE7/FywG1B3dpkF8CgY+nL4HngAeShcMBw
         bc7V4D18Gll0KPDD7x+n8A1+xaxfYls9bQ0EoV4nTUn7tuDbOc8VsKGQjtUEtZq2hmVs
         489w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793216418; x=1793821218;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9zpy3NAVqmZUXCspMHykAFp62eds2iCaDj7iI5VN0iY=;
        b=YcUpFfc0s7WicKy5Pr0Ppnvt47cMDGCFWetQqHtIUs/wyQ3lJMZTjZEGWNo60cXpDu
         IS+g9bJYdXsEPDrbQM+2mEwuuQberNJAitRMhagNnPK3BzQdJgYYSaYVetYA4GYqBxaU
         qaDwetZHya0zRXxIbPZKoxPg/9vnHOiUkryBwgMbY53aNNPrURTEtrYzPVCQXMO2+Cx6
         ARnfRqTINUYzDU985tRgTX+sYe5HJHrfDW0l/3MIWwzyr522b2a21oFMlPW6XM/dyLxw
         ybKkiEQ/1ixqkEcJstll4T/69yPasBdrXaOH1LCiWE9/5WJ8WUaEhGlNHVgjZhDOaat9
         KJYQ==
X-Forwarded-Encrypted: i=1; AKwUvBw1YbP1A6ELUQDiXE9SUfpC9M7dvLr+iCJnhm/woF+A/VWKaRyNPnRQ2b2ySy4HN+KDU5UGXSOX6Q==@kvack.org
X-Gm-Message-State: AFq9FYI/F46o0kEYg3uJCfvJ2N+dm/uyl5wm4+hrEWWVwiGfTbq7YQDU
	wAbjj+bt0BDjTy9y42QsOHWUIIBMQKgEJMHVx4fSBhnx4QjCnHCvUdZUYQFDHFjrH6/ta/5A4Xb
	FTgingQ==
X-Received: from pfbih21.prod.google.com ([2002:a05:6a00:8c15:b0:8a0:3171:5410])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:428e:b0:89d:7f51:6485
 with SMTP id d2e1a72fcca58-8a6e3c6db35mr2370324b3a.8.1793216417420; Wed, 28
 Oct 2026 12:40:17 -0700 (PDT)
Date: Wed, 28 Oct 2026 19:39:19 +0000
In-Reply-To: <20261028194014.3671161-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028194014.3671161-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028194014.3671161-2-kuniyu@google.com>
Subject: [PATCH v3 1/2] mm/kasan: Detect double-free involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ECBE418000C
X-Stat-Signature: sdh31johz8thnbtqypnfqodujcjixf37
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793216418-627695
X-HE-Meta: U2FsdGVkX18JXOOtuH8QeH/j6epAY4omqsIoFwAO4uycxxU8jHUa1YQ54COm4kkHkBs8phNSpUnPB/OA7oUoOIkvJqBWiv5g0NEtp88vFs9Qn5VJS3bKVmPlKhijkEooc6/Iw8OL1zbp/NNZ/FO4rYQIbfu6genh5laqAiJYPraHqnveYwXP67T7XKZmXJ7/9N2AQ3epdBZpPsz9nUxEUkXweXPFzE08sPdLYLnYu3ez8WKGz9mZcQT8IK1IQa7GCMQZEZewjOgA9UAQ7J4B+AZuSEP+8Sq4xncOGdNvd/YrvtxvMjU5C6+CvnrZiHpbBeFmZuPb0PMty3U1QQwk5S7uzkOGFX9/jUa9DvJhyVEhrt9juqOSCedfaO9v+CKPJcicsjutzaELSyforKPyY9Zbh2w0Y3+2Lhu+1Vdr6RLwapMqBwUVT71iijWxYot96qRTLHFXCY6MDt3axyUJw7ZqwnptM5WTgZNfAG15RIVZCMX7g7ZtRtWvh6KX6dG4rYe5W1tWEACccmySJuCezNJZKanuz0oMwrZ/FeH/9QY4iRaLtN4t539fg31tw4uj78SPIu2eYu1X2TrCOXd0V8I/RfcfDmk4H50Qs4HXEF7F4HQaHv5uPf4VNX3j9UQze9M3NMAEvwFZ/cxbDfKpnI6Fd3of1uiT5LpJjfpHyv6XFnPzNE6ZA5kx8SpMeJwAIch7UcmPSJRhfPj1gJq4KKhvxdIiYVQ6G8m8NF8c9bmsa7P9ScQXjuZiccEIe7NeGCb4Njp5pbRyLNIOqnSW0LAKQ/PUUVYxaj+73yARLmXMx8lmX4q7mmo6F7JVAXig2RL3IpQUKSvHiONa15SzeYxdIh1n5tduydYkLhvxzpnnoCu/0MuTXKGR75OueWmVu4pMDgZWKn5LmzRU6+jlwMuqvFOiNAHVLPzmUmSul2xdy7/cInpYNmOHXuP3aQ87VJD+hdzVT+/dcXqSsnA
 +sQTmUsc
 z+gfq/nTwjZP5U7FhBi1IV7p7TsEY9q0RJsXQTiapN3hvSPBYRy7OmUjWQJltMe4+fJfaU+oU/PvXZLrhFYKRulLe1XOtsb2M1daxWh9Y6xBb4khIjEX9Y5QfWQ/8EO6n/iRv7UWhjM25fIXPcyI6sB/dVH3CryfTu0HsUdQIEZL9+ZqoAd1WRxu5d7O++luMuxrfPrk1GXlZW+RGcWzkgXwVJjbFo241hCdLqyJTfZM7+8o8O9u7VvWQIqkYVh8wr7cM+wMNdC5yIYKhLZ3Ljzd5sGWaHGY8hhjYn7pefv1W2gn1sCYurK459hOeTglhBygLJKnOYPB41W66Wr5KF6WjfLaNhf0nQxxKNa/ONKEhFnUInp3uFVMvlSxVw+U9xB5ItKb0Kb8fzEq8NnHsnWLASQDfXT4g4cUonCtBfzc0W1eiP5mlOguB18gUESKnJ+LpW4/AMMtFb5vuVSe+mEu2S88x8ZZDtEU8Mb5ank0EsAqQwQg2OQcHApMNpZW4uzLjxkXonfwx+5pBmSgOql374u4tRgVFEbHd5rFdlTxlX3MFSa9xZveVyuRnj5BryCZ6gCLypLCR7AwLD+bgKaivhz35j+vz1RHKD/DBydtzNjIe2kuqh8ElYQyfij10ZGD2UJxhUvqEFJ37A5sUMPfvQfxtyCrRuNMAsCAifj95l/n5Bg29dcbMawU20u134+M2ERP50LC6DDSFtFsj+kSuSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

syzbot reported a weird use-after-free splat. [0]

In the report, an object in the kmalloc-64 cache was freed via
rcu_free_sheaf() while it was still in use, even though the
object should always be freed with kfree() (in xfrm_hash_free()),
implying that the object was a victim of a double-free involving
kfree_rcu() somewhere else.

When kvfree_call_rcu() frees an object via kfree_rcu_sheaf() and
queues it into pcs->rcu_free, debug facilities are skipped, e.g.,
kasan_slab_pre_free(), kasan_record_aux_stack(),
debug_rcu_head_queue(), etc.

As a result, KASAN cannot detect the double-free at the call site.

If the object is still in the KASAN quarantine when the sheaf is
flushed, KASAN can detect the double-free in rcu_free_sheaf(), but
with no trace of the suspect.

Worse yet, once the object is evicted from the quarantine and
reallocated before the sheaf is flushed, rcu_free_sheaf() silently
poisons the live object, resulting in a false-positive use-after-free
report on the new user.

If __kfree_rcu_sheaf() simply calls kasan_slab_pre_free(), we
can detect the second kfree_rcu(), but only while the object is
poisoned in the KASAN quarantine after the first free:

  kfree()     --(poisoned)--------------------> kfree_rcu()
  kfree_rcu() -> rcu_free_sheaf() -(poisoned)-> kfree_rcu()

An object queued in pcs->rcu_free remains unpoisoned until the
sheaf becomes full and rcu_free_sheaf() runs after the RCU
grace period, so a subsequent kfree_rcu() or kfree() before
rcu_free_sheaf() cannot be detected by shadow bytes alone:

  kfree_rcu() -(unpoisoned)-> kfree_rcu() -> rcu_free_sheaf() (too late!)
  kfree_rcu() -(unpoisoned)-> kfree()     -> rcu_free_sheaf() (too late!)

These cases can be detected if we call debug_rcu_head_queue()
before kfree_rcu_sheaf(), but ODEBUG splat only shows the second
free.

To detect these cases with KASAN, we just need a 1-bit flag
to indicate the state, which can reuse an unused bit in struct
kasan_track.pid. (PID_MAX_LIMIT is 1<<22)

The bit is marked along with recording the stack trace when
deferring slab frees in kfree_rcu_sheaf() and checked in
check_slab_allocation() so that any double-free pattern above
can be detected immediately.

Link: https://lore.kernel.org/all/6ac959ee.70ed5d86.2ac85.007d.GAE@google.com/ #[0]
Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Tested-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
v2:
  * Add Fixes tag
  * Add kdoc for @after_rcu_delay of kasan_slab_pre_free()
  * Rename s/kasan_record_aux_stack_rcu/kasan_mark_rcu_free_pending/g
  * Add comment for __kasan_record_aux_stack()
---
 include/linux/kasan.h | 15 +++++++++++----
 mm/kasan/common.c     | 13 ++++++++-----
 mm/kasan/generic.c    | 17 ++++++++++++++++-
 mm/kasan/kasan.h      | 34 +++++++++++++++++++++++++++++++++-
 mm/slub.c             | 13 ++++++++++---
 5 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index bf233bde68c7..c1ac7971601e 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -180,10 +180,12 @@ static __always_inline void * __must_check kasan_init_slab_obj(
 }
 
 bool __kasan_slab_pre_free(struct kmem_cache *s, void *object,
-			unsigned long ip);
+			   unsigned long ip, bool after_rcu_delay);
 /**
  * kasan_slab_pre_free - Check whether freeing a slab object is safe.
+ * @s: Cache the object belongs to.
  * @object: Object to be freed.
+ * @after_rcu_delay: Whether the free follows an RCU grace period.
  *
  * This function checks whether freeing the given object is safe. It may
  * check for double-free and invalid-free bugs and report them.
@@ -193,10 +195,12 @@ bool __kasan_slab_pre_free(struct kmem_cache *s, void *object,
  * @Return true if freeing the object is unsafe; false otherwise.
  */
 static __always_inline bool kasan_slab_pre_free(struct kmem_cache *s,
-						void *object)
+						void *object,
+						bool after_rcu_delay)
 {
 	if (kasan_enabled())
-		return __kasan_slab_pre_free(s, object, _RET_IP_);
+		return __kasan_slab_pre_free(s, object, _RET_IP_,
+					     after_rcu_delay);
 	return false;
 }
 
@@ -424,7 +428,8 @@ static inline void *kasan_init_slab_obj(struct kmem_cache *cache,
 	return (void *)object;
 }
 
-static inline bool kasan_slab_pre_free(struct kmem_cache *s, void *object)
+static inline bool kasan_slab_pre_free(struct kmem_cache *s, void *object,
+				       bool after_rcu_delay)
 {
 	return false;
 }
@@ -495,6 +500,7 @@ void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
 void kasan_cache_shrink(struct kmem_cache *cache);
 void kasan_cache_shutdown(struct kmem_cache *cache);
 void kasan_record_aux_stack(void *ptr);
+void kasan_mark_rcu_free_pending(void *ptr);
 
 #else /* CONFIG_KASAN_GENERIC */
 
@@ -512,6 +518,7 @@ static inline void kasan_cache_create(struct kmem_cache *cache,
 static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
 static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
 static inline void kasan_record_aux_stack(void *ptr) {}
+static inline void kasan_mark_rcu_free_pending(void *ptr) {}
 
 #endif /* CONFIG_KASAN_GENERIC */
 
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 7d21c4db68d2..4187606a88cf 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -68,6 +68,7 @@ void kasan_set_track(struct kasan_track *track, depot_stack_handle_t stack)
 	track->timestamp = ts_nsec >> 9;
 #endif /* CONFIG_KASAN_EXTRA_INFO */
 	track->pid = current->pid;
+	track->rcu_free = 0;
 	track->stack = stack;
 }
 
@@ -231,7 +232,7 @@ void * __must_check __kasan_init_slab_obj(struct kmem_cache *cache,
 
 /* Returns true when freeing the object is not safe. */
 static bool check_slab_allocation(struct kmem_cache *cache, void *object,
-				  unsigned long ip)
+				  unsigned long ip, bool after_rcu_delay)
 {
 	void *tagged_object = object;
 
@@ -242,7 +243,8 @@ static bool check_slab_allocation(struct kmem_cache *cache, void *object,
 		return true;
 	}
 
-	if (!kasan_byte_accessible(tagged_object)) {
+	if (!kasan_byte_accessible(tagged_object) ||
+	    kasan_check_rcu_free(cache, object, after_rcu_delay)) {
 		kasan_report_invalid_free(tagged_object, ip, KASAN_REPORT_DOUBLE_FREE);
 		return true;
 	}
@@ -259,17 +261,18 @@ static inline void poison_slab_object(struct kmem_cache *cache, void *object,
 
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
 			KASAN_SLAB_FREE, init);
+	kasan_clear_rcu_free(cache, object);
 
 	if (kasan_stack_collection_enabled())
 		kasan_save_free_info(cache, tagged_object);
 }
 
 bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
-				unsigned long ip)
+			   unsigned long ip, bool after_rcu_delay)
 {
 	if (is_kfence_address(object))
 		return false;
-	return check_slab_allocation(cache, object, ip);
+	return check_slab_allocation(cache, object, ip, after_rcu_delay);
 }
 
 bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
@@ -544,7 +547,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 
 	slab = page_slab(page);
 
-	if (check_slab_allocation(slab->slab_cache, ptr, ip))
+	if (check_slab_allocation(slab->slab_cache, ptr, ip, false))
 		return false;
 
 	poison_slab_object(slab->slab_cache, ptr, false);
diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index 2b8e73f5f6a7..3532a41ce966 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -533,10 +533,13 @@ size_t kasan_metadata_size(struct kmem_cache *cache, bool in_object)
 }
 
 /*
+ * Records an auxiliary stack trace for the object at @addr and, if @rcu_free
+ * is set, marks the object as pending an RCU-delayed free.
+ *
  * This function avoids dynamic memory allocations and thus can be called from
  * contexts that do not allow allocating memory.
  */
-void kasan_record_aux_stack(void *addr)
+static void __kasan_record_aux_stack(void *addr, bool rcu_free)
 {
 	struct slab *slab = kasan_addr_to_slab(addr);
 	struct kmem_cache *cache;
@@ -552,10 +555,22 @@ void kasan_record_aux_stack(void *addr)
 	if (!alloc_meta)
 		return;
 
+	if (rcu_free)
+		alloc_meta->alloc_track.rcu_free = 1;
 	alloc_meta->aux_stack[1] = alloc_meta->aux_stack[0];
 	alloc_meta->aux_stack[0] = kasan_save_stack(0, 0);
 }
 
+void kasan_record_aux_stack(void *addr)
+{
+	__kasan_record_aux_stack(addr, false);
+}
+
+void kasan_mark_rcu_free_pending(void *addr)
+{
+	__kasan_record_aux_stack(addr, true);
+}
+
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 {
 	struct kasan_alloc_meta *alloc_meta;
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index fc9169a54766..43d608899544 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -191,7 +191,10 @@ static inline bool kasan_requires_meta(void)
 #define KASAN_STACK_DEPTH 64
 
 struct kasan_track {
-	u32 pid;
+#define KASAN_PID_BITS const_ilog2(PID_MAX_LIMIT)
+	u32 pid:KASAN_PID_BITS;
+	u32 rcu_free:1;
+	u32 unused:32 - (KASAN_PID_BITS + 1);
 	depot_stack_handle_t stack;
 #ifdef CONFIG_KASAN_EXTRA_INFO
 	u64 cpu:20;
@@ -390,8 +393,37 @@ struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
 struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
 						const void *object);
 void kasan_init_object_meta(struct kmem_cache *cache, const void *object);
+
+static inline bool kasan_check_rcu_free(struct kmem_cache *cache,
+					const void *object,
+					bool after_rcu_delay)
+{
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (!alloc_meta)
+		return false;
+
+	return alloc_meta->alloc_track.rcu_free != after_rcu_delay;
+}
+
+static inline void kasan_clear_rcu_free(struct kmem_cache *cache,
+					const void *object)
+{
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (alloc_meta)
+		alloc_meta->alloc_track.rcu_free = 0;
+}
 #else
 static inline void kasan_init_object_meta(struct kmem_cache *cache, const void *object) { }
+static inline bool kasan_check_rcu_free(struct kmem_cache *cache, const void *object,
+					bool after_rcu_delay)
+{
+	return false;
+}
+static inline void kasan_clear_rcu_free(struct kmem_cache *cache, const void *object) { }
 #endif
 
 depot_stack_handle_t kasan_save_stack(gfp_t flags, depot_flags_t depot_flags);
diff --git a/mm/slub.c b/mm/slub.c
index 45e077c7526c..cbc51440b3d9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2722,7 +2722,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 	 * Give KASAN a chance to notice an invalid free operation before we
 	 * modify the object.
 	 */
-	if (kasan_slab_pre_free(s, x))
+	if (kasan_slab_pre_free(s, x, after_rcu_delay))
 		return false;
 
 #ifdef CONFIG_SLUB_RCU_DEBUG
@@ -2738,7 +2738,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 			 * We have to do this manually because the rcu_head is
 			 * not located inside the object.
 			 */
-			kasan_record_aux_stack(x);
+			kasan_mark_rcu_free_pending(x);
 
 			delayed_free->object = x;
 			call_rcu(&delayed_free->head, slab_free_after_rcu_debug);
@@ -6298,6 +6298,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	}
 
 do_free:
+	if (unlikely(kasan_slab_pre_free(s, obj, false))) {
+		local_unlock(&s->cpu_sheaves->lock);
+		goto out;
+	}
+
+	kasan_mark_rcu_free_pending(obj);
 
 	rcu_sheaf = pcs->rcu_free;
 
@@ -6338,6 +6344,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	local_unlock(&s->cpu_sheaves->lock);
 
 	stat(s, FREE_RCU_SHEAF);
+out:
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		lock_map_release(&kfree_rcu_sheaf_map);
 	return true;
@@ -6971,7 +6978,7 @@ void kfree_nolock(const void *object)
 	 *  -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
 	 * is double buggy and deserves to deadlock.
 	 */
-	if (kasan_slab_pre_free(s, x))
+	if (kasan_slab_pre_free(s, x, false))
 		return;
 	/*
 	 * memcg, kasan_slab_pre_free are done for 'x'.
-- 
2.56.0.313.g2479322e68-goog


