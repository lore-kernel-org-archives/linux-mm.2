Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D401606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 22:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Um6lHqXp
Received: by kanga.kvack.org (Postfix)
	id B1FD96B0909; Tue, 27 Oct 2026 18:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA95B6B090B; Tue, 27 Oct 2026 18:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971696B090C; Tue, 27 Oct 2026 18:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5620E6B0909
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:26:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE742C0B46
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:26:04 +0000 (UTC)
X-FDA: 85369840248.18.8C3BB8A
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C82A1A000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:26:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Um6lHqXp;
	spf=pass (imf19.hostedemail.com: domain of 3-SThagYKCCYMWPKaWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kuniyu.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3-SThagYKCCYMWPKaWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793139963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vBiYcRKTORXXYtOhYG5OQEAgLn21F+1WvFG/bC74L4=;
	b=7rfaP+RYZO1lIds3YZXg0HjkGZL2F7Faa+/srktg0DnZarnbhw0uWWctDThSvKJwl4seH1
	9MC+MZ56bE2+50e9Za+AvjBvIhQZYgsF170tvdQPIt0Ud9842cmMWbFnvrVxftSrZbcrNC
	niYKOwfq/1STMGJ6pQL1U90swigx9jo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793139963;
	b=Nf/aEcqKmuw/SnzYVA2JPVNUoI7LEixtpianjfMjm59tNQZtINfYoB6Boy4McvMH9POWUz
	i3Dga/y9wpOKa7R5cQxsL0vcsgIab+A2ms/JLjWIS6zOAlp3Fl9aO7MsMCWmy42loYu6H+
	I903GADSmFK8Qri/6Y3K7b08BgwMcXc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Um6lHqXp;
	spf=pass (imf19.hostedemail.com: domain of 3-SThagYKCCYMWPKaWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kuniyu.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3-SThagYKCCYMWPKaWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd60e4e8bc3so230252a12.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793139962; x=1793744762; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4vBiYcRKTORXXYtOhYG5OQEAgLn21F+1WvFG/bC74L4=;
        b=Um6lHqXp/q6z7wVyjiSwLbc0Ckbc8vsdei9rESaIwkXhqkTpt4iPPyYpGhkJsNaQps
         zFTaT78ghe4I9W6t5lj8GaPstKUxQ8o1d79Fny3Y89goRP4ZYu3jIqvVpM4YUHEmUWPN
         PFeLHbWO81hk5IGsDkgD68QQRdY64hxZfGIXftrRrxyNYDLqeR9SEaXNXU2sYjnfWje3
         32v+jkfDiYicDe0gcygw0qpjiMikqqnyN2lwaaNGchj3AkYhWiTwFNGAYQDUwMactGoD
         rqOOxX4VYFF8w9tpOQd9XCwzt7pilyVaABwdJfcvpWtsvrAZ+wLet0yPoyALgsnTsUuP
         kiqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793139962; x=1793744762;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4vBiYcRKTORXXYtOhYG5OQEAgLn21F+1WvFG/bC74L4=;
        b=d/JsYiL1nzcWj7czXDdmjwSlGNV2i1RdrhyVZAqsBUk9yzijAUinGNA+kmCnfmIF3p
         T83+svfMABp5uwa6mM/o8ovudeFVWeIdurNY7GNIWmr1WkoTHOa924CGJ5B5ll7hpiN0
         h+873Fv8286F9twj/Xt49K6MNI+sFRtc7LENyUfo6jggS3pg7QstFeHGEEYyTqfQmyLV
         x8c8KVNOajcieac2U0LwYoISivnfeLthHcvLheY4QlX9praoPee+eWPMRjAb4ZRkq9EG
         RnhKvFU8ytTxwdFewWAL8g44HTxB/cJchA8q+FnMAYEsicqG6tbFwAyrCwGh0yumzaf4
         E5AQ==
X-Forwarded-Encrypted: i=1; AKwUvByJZ3+0Oy9kkOBkpoFBc1qIdTVBQeFr/WO8LMX/aUbmSLudvRMBvgrinoaGfJ7k1bTily9eW0nZbg==@kvack.org
X-Gm-Message-State: AFq9FYI2nhn//9f1omz1uMzwQqMr3VhCZzuYt+fgvyshM97Ip14YLk3Y
	UxSxWVY8xCCrG60IM84zAzPmPCdExxA/WGPfZIY4qPVN6UMOxwA5D2NPh018zrzZB07699xIp7j
	JmSgTxQ==
X-Received: from pfbki39.prod.google.com ([2002:a05:6a00:94a7:b0:886:368d:9900])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7486:b0:3de:46cc:b63c
 with SMTP id adf61e73a8af0-3e9022f682emr507954637.11.1793139961713; Tue, 27
 Oct 2026 15:26:01 -0700 (PDT)
Date: Tue, 27 Oct 2026 22:25:45 +0000
In-Reply-To: <20261027222557.1072105-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027222557.1072105-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027222557.1072105-2-kuniyu@google.com>
Subject: [PATCH v2 1/2] mm/kasan: Detect double-free involving kfree_rcu_sheaf().
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
X-Rspamd-Queue-Id: 1C82A1A000D
X-Stat-Signature: bg3t6f5dmyxo6837nu14qh4hf6cwonqb
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793139962-800381
X-HE-Meta: U2FsdGVkX19n/OTyERxFxnjGzByygIWv4Oz8JsF8gFZuntGtbUI003iND1Tu21cGfFb7xJpuEN+RIufxW/C35eOJF2dvdgMEv8xYeurM7VGPnYWzv0sifuHDRsxeLBKtOsaL2/GH3E7i9TIfGjciEFkDQHjkSgVDx8MZodhjJn3twCgP8POq0lz6kQZ8Vzb3b/qOVTb//tUU1PFtUl51C6M2GXcEmet2W64gNCV15qcSoZgd/9A87xL9dMNRv5H6om5dCwf2RjwYB0Dfh8ferigR43SdQJKXTuuGEZXvTkHuhCFjSMvSCZLZRrnAnN34ZepywXVlnesZA6Ah/AM0/AqKGieD7Q/bOij70pZdsXhZ0lcpl+FbHg8P3kD5ctiAWbbdO5DB9u7ym7uQHju56KmyTrENUoly+V4Y7nFN1s7HREaMd3Foin/AHmlwQJoRZ6yxwPfw7RN2otIlLrIaaQjf/v6c/eCx5KzNi8oqRvvJ3zf5XYXw54zC77x0Kvxq3uEW3Y/+GjbstN4OCWpS3okz2sbFFhcC2KYBZk0WGmYol3XlwPplzIERYgs52qMmAVu4wDhp3ZSqpHqKqJ85wpFOWIjht9H7Gh1FuObFbLzDdYVdOyoLgeJYqbtaulsb7dC+2O4RSVfjMSXlqKX3TCvEtw60OvUh/hf/KY3fL+qXRMiaP4F3aNcR+BSyIdyVC5aZxoQcilPEIVKbYV1rEbfUBtWKpLaGmV3KDyW7R+XLhVsZECzx+fOQ7oMC6W5jwgEpMJUp+ecMV+NpqpbEMf++STwRGEWEwu3lc3J67dKLPlHNwTR9k1XboiHRW0Cy4lXsvJ+g7HzbAMEx5RNWXZ03eWyEdjMtOKjvZ+Ae2B21nKy1MP5eBmhmQ1FkTjyxa18cQSpTSrc4aBEPdS53yxCCXRxR2yrNL8qOEvysxZNCWjvGqK6Yt2hROyc1WH1Iwq2XTQXSa5azsLb6rjv
 +DmaHUiZ
 SX55KBnHoK7O4yafw2sPw3FwVZ97/8q5r9b5XLJ5/lIXk0cVy9vSIqe64JNDsIZCRPDXvzKC68H2ss3z7AIbWfqWeXL1Zs5piFEKJo3Rx9cwsoo6eRW/xo2sk2hfLP4GP/20dbppy0JSDtMu2qHesjqUZxQBKnG5J+a1CeOA6ji+QPZhhRUwMc6TDWWxw1olB5VJC8mniqjv3QhLTY+/UkVH1MwfUKcWd/pNePef1o3AbWDiH+GOG7Syhw/M0qatFMCBh5PIBkOB+BF1GIG7i0PE0DbYrfmUGsCUAMUJSdpE21FGFSZTjBdWJCOU5BtnxM6K3tXs8pc+WI6l7VUndUdnyWICrSlXakBEZ2b7Ft8qIK0LWMhPvyp8hqamgmbozR4MhYod+Njhni+0Jm3kbdKquwVx361D+yyssOneOTzkbv7QU0TLOgYRIFVMlyEftkpvE4UG6oPL0hdLStkAoWzXxLC8yA6ttAPO1EcspWKGihVo6oxCf454aiGOj4+KNzjcjDKx5wsC0HI+FcCEQLgOT4WY2WjqVRjCIpD6IJrOXn6zX83s49u2zFWFEyKfcsONeri8/2EK4sYIwfYXRz/X0KsWl5Sr+qWr+01vtGXHYPQJWzaU2p7b+CHkU6HHWg4QyK4gGOa4kAlrltz6lIdZe0yOiRBo9hJ4pCczvE/VOeU380uH1vwBqrA==
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
2.56.0.307.g5fe7bd680c-goog


