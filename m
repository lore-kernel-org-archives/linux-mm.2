Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC65C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 06:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8DC6B0088; Mon, 31 Aug 2026 02:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA116B008A; Mon, 31 Aug 2026 02:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0980A6B008C; Mon, 31 Aug 2026 02:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D59746B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:07:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E4CA16020D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:07:32 +0000 (UTC)
X-FDA: 85160532744.10.C1708E6
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id A837D18000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:07:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mjNZORoV;
	spf=pass (imf24.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788156450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZKewmGq0J9WH8blhf/djGi6qD4AnbzKIdeFzMaSw4w=;
	b=pElBXwVRWQYS8fsdfU3HC/HBG0fdYr20+WRLYblcRjkNQf//9Y/2qyZl0iAX45myt/O8Eq
	tt7upKj+w0BznCVAXtI5SegNjDMy2ytfAJYB97dQ7uqDfRBPnLlfjL6/q1LYq4eTNdASRs
	fo/NBqXZhT24CC2Ua8FsZzJlQTgkKS0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mjNZORoV;
	spf=pass (imf24.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788156450;
	b=uY49WCuxMonjrHjO57rZ+Ry2e4QaqTI0XqQD7yusQOOrbSZgDw8DPiorxYenJhA0Nz50bX
	nY/0xettmYJuxGZE9JSEiBGD9/DbLvSa5iPfdDzxwVcYk1F+LliAUmGSV60YYMzDPVzX91
	cjC6QDNsDgUVUHmOpzRxFi0FK42tqxw=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d7195706f1so29859685ad.0
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 23:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788156449; x=1788761249; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hZKewmGq0J9WH8blhf/djGi6qD4AnbzKIdeFzMaSw4w=;
        b=mjNZORoVx91n9I8tC2ncJmsj7+2kzsecHvdehq+9kszw743MqwwI1TIzPPOtMRsP62
         NqGjGulBiIGwZ9YFYfwDDwdUsfQW9PaiB0m7LGvbaWEtsO+MOAzjD7tqMzaGXrCSDBdy
         3AQ1gcYhnj68B5jGbsEZm5+64t25BeGp8H0vUEOxaWQdDCruPXykm5TnXEIXIvrHpMH+
         U33IGnRU6EpmoKqbucFgC6VcMWdve4mIZrjfF/MO8G4ecDXA0cZQvU3tJzINw9LQp414
         YSVJ1AsFQTeS9Xb0ShshEFWPnUhcoy4rVFN5cAImMCpK9i9b7+v9XIvsTtOH+sy2P3yC
         BkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788156449; x=1788761249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hZKewmGq0J9WH8blhf/djGi6qD4AnbzKIdeFzMaSw4w=;
        b=MmT9kviJaoQJePEubwFms5hRIxICAlp2zXNQ9DiSNvIi0GRXtGKWjnsEQr3gYA6zfb
         1dEOuMrP0jbl7M5TRYFrE1m0M5yq9D4sMGGpOodVORA2jnzPUk1012TmkgjjxJhDph9W
         bxi+o1vh4+TNhY3IZmjwG2ClNDZVlIX6+z+LV/zj6kl/bCgvBkXzR8T76KTYV99fjxDg
         4UrYKZpTUzTHTODd7zU6OFR3JbnWnol/PQ0vGfpQDB/C4qYr9cnC34COceyyZbzrh/D8
         f3I5taaKTL08mrpVXrxGasxXKQiexj4XBOGgMyvTstoz2OHO4OGRQUn4cYT20Oaa2Qop
         GYSQ==
X-Forwarded-Encrypted: i=1; AKwUvBwz4Syyk5lCoJ0NoIDjrk/TjZnicU6gediFRHFfxS9W17F/t9Ch1zoddHn5FZBgAB7k8MizD71CxQ==@kvack.org
X-Gm-Message-State: AFuF++nNP0t+41mCj8BZsF7f3EoyLX7YprwayDTcRINa6HHzSHtXwV+D
	0QYImiI6TZI8qgaKAy/KA7Uu9uveKvtAEkjWknDdvzcmba6a9n6vcW+V
X-Gm-Gg: AR+sD13u8uYw/u4OHoJGWifoyyHes9o+TbjgMxyGRrS/bAFtqpRRcJnfQPjBATgGQC1
	FpyMt6FiLX46D+F1ux8P4/le607V8st4Ep6cjS3VIR9EOsaoeLXfg89dVOdJBSAvouGRUiUkv9/
	AstySHb+w+3E5XwnXaje6b0/3jSGePXHIRoVsJCw7FpRNpk5vRLyA/9L7O9Xy9AVOPtPGG3B+Sf
	81t09R5eWwXu/7PZj25wXxYTTm6v733ve0HGtC3zjmfHz5xgcDFQo6OFOYHO8aSb3tLoh26vsiM
	36E/X5lnsYI3y6H8vxElxzudy3YlC2SqYnU/Fe+ILzpSA3l/rW1HAwZg+3NhXkAXlWyh4jQ3HCy
	cg6b5xzll9ADl1ewkVqcwIljLInOfG9ad3qZyouGAVx1I1dprplzaC7XU4Bo/asZHqOP2tMemxI
	T58Vx7UiqvVzkUFCA65anx0plZA/RnkMFn1tfEzZHNdPtY6CbJBI020mqXgfKZkUThfSLmRpNW/
	nYO4Ky0Fg==
X-Received: by 2002:a17:903:3d07:b0:2d8:d4d7:f055 with SMTP id d9443c01a7336-2d93fa78359mr17270765ad.22.1788156449332;
        Sun, 30 Aug 2026 23:07:29 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:21dc:72d0:980a:8660:dfa9:a9cc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d7598c3da2sm29795255ad.82.2026.08.30.23.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 23:07:29 -0700 (PDT)
From: ThangNN99 <ngocthang2710.1999@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	ThangNN99 <ngocthang2710.1999@gmail.com>,
	syzbot+acf142088e0182172e58@syzkaller.appspotmail.com
Subject: [PATCH v2] mm/slab: don't use kfree_rcu sheaves on PREEMPT_RT in kvfree_call_rcu()
Date: Mon, 31 Aug 2026 13:06:32 +0700
Message-ID: <20260831060633.6831-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831053846.107974-1-ngocthang2710.1999@gmail.com>
References: <20260831053846.107974-1-ngocthang2710.1999@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m487bfxmkmedxkfru7rh5nywz9dzzgad
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A837D18000A
X-Rspam-User: 
X-HE-Tag: 1788156450-935472
X-HE-Meta: U2FsdGVkX1/HIEve+PqwD/QhSbOsohQQWAhAF/Nt6SbZlABr0UwU5QoRbW80gi6sHVUOa/WusfmtHbafcOj9B5B0CUrufWLN+IZEX843CRKzdMYOLRC0IB4w/TeYOiJPX7nXb/4XQjrbeJg9/RF180e9bueUJp3kEiMn3c3rREBKhzT1cbUtqeSyU1S0pPdlZ1lMwzW8D10jybZTJ0iCNiOIdBCWDg2dZkWTWV9MAnqx4GMWxyM4Vcv3x8qLVU7ZkB2RyPuDGP5NKOUhPSMcxCqJ21ZDBIU9xE3TcjKJSkrpcuMcyIXlCGgXrV4/xTOzE9y//gAiuSr8MVXRroMl1sE7pBzz51gOOL6JiWDNFQ+XZynUAnqwdiu3LJmusNtTKD7XJfm1IlGC+OooESFd7oW5HPmVqrUhbG0Mv4psCDB+uS8mZAcCVQ5ZCGPbvf7cYWMVarDMFkBrC0e3bfYg/q2DtLI8fgNLowBUAlVTwIEDO/GrP5YCVZhAkfyIpryGNqXMI+TLlLA6jtrudlaFjJggHevG3PTjz4SkftnZQNwdC93Z4D/+4FFFuAU+6lkCRuQdYtts4ze6EYQd6o4EQAQeqqudsW4Hh2pBoEIdZo2sOmXOWsDIrxISi973t0L2EpSGOLKdEsE43WomIvGAY8zZdIsw/yYAaULq4ttE4+xrK0CHzUMhIjyn97LN2b1URdxivlcn0Toa0v2PS+0GnRAcqM4s8csNlkHqpk7xdgRUwLK7KXvtxIHkuGcYEGYFjqZTkwYc8WOQ1PtX1pinyeD7jajmuJfa8FUi2KsQeXjYymcSqz9mUwsuXFIqKPC2KZgIZHaCyRPbsHBAJeROw4bO1FlV0ZZfe2fmqSvohQUkKaLW32VDatl13HCdKb7lCRoiKbgQszTybz2bnit0KR10aTODTudRmKQe77iIzNnv2l4bYwkUuTAmbBA29CrSMUWsFQS85tAC0q36MJm
 IyPcFEAe
 4T4VD8f6G6KQClSTHXVZ50z80g2jFX6QE2vjnBfj6was5VCKgGx+lObXJ4zfQvYQlebOb4fDnV0nnHAFuRoMRhBA0bEU9UChKzR7RPPyJpF6dn1li0fkxq6glQws1maAMiSXU4vyd/v7d8KBBGx1hx23R+tDgZ3xWdwncNqCJVjPhBqBSWehJ4ylyWSHXAz03aIh1zDwujKqR1JI2e7aj+v2EYjdjJqTgQSk4r6rH3eSB5unOMZTKf0V/mOA0iOw5zreuuwQjVZgpaNWulnGtm9CqDgfWtT8iAFED2/eNIFK34BiXEWr5sg9LzyZJJ+yUsno+p4I9mAypDEiGxMYRm+zyJZecIjBx4j/9jig05de1CPT7uvt5KZM55XU1Ywxkjjf53CmAlBy1EoUYdfF4urwrwXyhzOQKySs9kOG3RHZlpQ5t9+q43jDZIlGvziRijRCvrg/sg0SUHaRVu/JzNN6BSgAg6VY/w8w/79lcwajeG+zKJ8V4lV6p/1yTPncj9TwRl7itd7kb4uIxOP94Jn+dmJsQ9HogOLaiWldfNlO1nl1Am4GX2gDjsgHlOTvwhyWLRXf0yDd4p+CiybUEtHwnHSzC+oC2PYuzbt8zJDxqt400Cyf2hDF95xnRIzzKGYcDuN/x5VrSoU6z+Sdv1vgPi1vlYIeCa7cRxZSIVnWWS0qzjawwib4fR5jllGmfXdKJvYHAPqJkRckAczrwc/yO7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reports a possible circular locking dependency between
&p->pi_lock and the per-CPU kfree_rcu sheaf lock (_T->lock) on
PREEMPT_RT:

  __balance_push_cpu_stop()               [holds p->pi_lock, raw]
    select_fallback_rq()
      cpuset_cpus_allowed_fallback()
        set_cpus_allowed_force()
          kfree_rcu(ac.user_mask)
            kvfree_call_rcu()
              kfree_rcu_sheaf()
                __kfree_rcu_sheaf()
                  local_trylock(&s->cpu_sheaves->lock)   <- _T->lock

set_cpus_allowed_force() uses kfree_rcu() instead of kfree() here
specifically because it can be called with p->pi_lock (a raw
spinlock) held, and plain kfree() may sleep under PREEMPT_RT.

Commit 2a8bb29ec9b2 ("mm/slab: allow kfree_rcu_sheaf() on
PREEMPT_RT") made kvfree_call_rcu() try the sheaves fast path on
PREEMPT_RT too, since __kfree_rcu_sheaf() only trylocks there and
so cannot itself block. True, but the sheaf/barn locks it trylocks
are also taken as regular, blocking locks elsewhere, so lockdep
still records a lock-class ordering cycle against any raw spinlock
already held by the caller, which is what syzbot caught.

The plain kfree_rcu()/kvfree_rcu() API gives kvfree_call_rcu() no
way to know the caller is in such a context, so keep it
conservative on PREEMPT_RT and skip the sheaves layer there,
falling back to the existing raw_spinlock_t-protected krcp list,
which is always safe to nest under another raw spinlock. This
restores the pre-2a8bb29ec9b2 behavior of kvfree_call_rcu().

kfree_call_rcu_nolock(), added later in commit 3bc999d944b3
("mm/slab: introduce kfree_rcu_nolock()"), is untouched by this
patch. Note it would not be a safe substitute here either: it still
reaches __kfree_rcu_sheaf()'s local_trylock() on &s->cpu_sheaves->lock
unconditionally, so a caller already holding a raw spinlock would hit
the same lockdep ordering cycle through that path too.

Reported-by: syzbot+acf142088e0182172e58@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=acf142088e0182172e58
Fixes: 2a8bb29ec9b2 ("mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT")
Signed-off-by: ThangNN99 <ngocthang2710.1999@gmail.com>
---
v2 (per automated review on v1):
 - Corrected commit message / comments: kfree_call_rcu_nolock() is not
   a safe alternative here either, since it still trylocks the same
   &s->cpu_sheaves->lock unconditionally.
 - Removed the now-unreachable CONFIG_PREEMPT_RT branch inside
   kfree_rcu_sheaf() left over by this fix (it can no longer run,
   since kvfree_call_rcu() already skips calling it on PREEMPT_RT).

 mm/slab_common.c | 20 ++++++++++----------
 mm/slub.c        |  6 +++---
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index b19ba1b31484..3de1eabe6c77 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1667,15 +1667,8 @@ static bool kfree_rcu_sheaf(void *obj)
 {
 	struct kmem_cache *s;
 	struct slab *slab;
-	unsigned int free_flags = SLAB_FREE_DEFAULT;
-
-	/*
-	 * It is not safe to spin on PREEMPT_RT because the kernel might be
-	 * holding a raw spinlock and slab acquires sleeping locks.
-	 */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		free_flags = SLAB_FREE_NOLOCK;
 
+	/* Callers on PREEMPT_RT never reach here, see kvfree_call_rcu(). */
 	if (is_vmalloc_addr(obj))
 		return false;
 
@@ -1685,7 +1678,7 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	s = slab->slab_cache;
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
-		return __kfree_rcu_sheaf(s, obj, free_flags);
+		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
 
 	return false;
 }
@@ -2034,7 +2027,14 @@ void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();
 
-	if (kfree_rcu_sheaf(ptr))
+	/*
+	 * Callers may hold a raw spinlock here on PREEMPT_RT (e.g.
+	 * set_cpus_allowed_force() with p->pi_lock held), and the sheaf/barn
+	 * locks are also taken as blocking locks elsewhere, so trying them
+	 * here creates a lockdep-visible ordering conflict. Skip sheaves on
+	 * PREEMPT_RT.
+	 */
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
 		return;
 
 	// Queue the object but don't yet schedule the batch.
diff --git a/mm/slub.c b/mm/slub.c
index f9b56cb439e7..1e8bad7a018e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6088,10 +6088,10 @@ static void rcu_free_sheaf(struct rcu_head *head)
 /*
  * kvfree_call_rcu() can be called while holding a raw_spinlock_t. Since
  * __kfree_rcu_sheaf() may acquire a spinlock_t (sleeping lock on PREEMPT_RT),
- * this would violate lock nesting rules. Therefore, kvfree_call_rcu() avoids
- * this problem by passing SLAB_FREE_NOLOCK on PREEMPT_RT.
+ * this would violate lock nesting rules. kvfree_call_rcu() avoids this by
+ * bypassing the sheaves layer on PREEMPT_RT.
  *
- * However, lockdep still complains that it is invalid to acquire spinlock_t
+ * lockdep still complains that it is invalid to acquire spinlock_t
  * while holding raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a
  * spinning lock. Tell lockdep that acquiring spinlock_t is valid here
  * by temporarily raising the wait-type to LD_WAIT_CONFIG. Skip the lockdep map
-- 
2.43.0


