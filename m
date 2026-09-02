Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 380A3C624DC
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 16:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C12D6B00D4; Wed,  2 Sep 2026 12:42:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299446B00D5; Wed,  2 Sep 2026 12:42:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AF276B00D6; Wed,  2 Sep 2026 12:42:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8C0E6B00D4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:42:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 663F11C1903
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:42:09 +0000 (UTC)
X-FDA: 85169389578.28.715F4BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 89F554000E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:42:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ng3r09yI;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788367327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zSCE6tfU3OOKoy1uKyUKYorlWK8V4jpcRy6mW/6lq08=;
	b=NqZTQaQ4MUekVvRrCj7cudldKHsoztY8NUoM2NHMq6HzFrc6zkvuleCuDjvqIBMWkSYXH1
	pBqOpEy+5YuKsUBPG1J/WQ4+Yzfa7UjTfJ3kzZEQeFcIXcpYYcKrFKfT1wBXrxzaGULEXX
	nqNhRjj6BVfppOv3unA3VG1U2lqUg8o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788367327;
	b=4zaiWrMz0ytQcW5NryBazQbQgSdTZY/6F9G4qJKHC1bP4UnhWR1x03J5vUpdKHYSlMUPSj
	sX/bcRFGetjvHY6B3EOzszeFLFwhRHF2LS5AjHvyG/OALuH0nFyECThoa7T9UKwJIktIEv
	J6dQ//QxcUdmB4ESeKp6hZ8Ao2bOYIY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ng3r09yI;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A854E42A79;
	Wed,  2 Sep 2026 16:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29581F000E9;
	Wed,  2 Sep 2026 16:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788367326;
	bh=zSCE6tfU3OOKoy1uKyUKYorlWK8V4jpcRy6mW/6lq08=;
	h=From:Date:Subject:To:Cc;
	b=Ng3r09yIN/Rg69sbbU68f2e0J4GvQ1H08DpuJmxeKXzHbL+jSRAM2+y1l0iv9NZZS
	 BLTnCyef/QPKJyaX8urjMUB3ZQJ7Ett0/vZ3CI4w2Px+SebIB5AAJOmsL9G8+3Bc7g
	 ObKFIVdoK6bWucxeLONqgE1gPYtG3AeZ1LXP9Eh5ZPofdWyjC+YCgJR3O+gJOZfZzh
	 0jL/RsNMOX3GVfYqq4vn8hApYwJEt5V9aqSW2qmYYBbgEbhsPz5BNCn4jEz9xQSWns
	 9Mzc4xD8T/6nD+xl2hufNb6VcCoBIZ10kL4RMkmQPLYcTPj1MuwJ/U0mTKo25p41Wn
	 JRCwfO2UKMIPg==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 02 Sep 2026 17:41:54 +0100
Subject: [PATCH v2] mm/slab: take n->list_lock in
 __slab_try_return_freelist() to avoid race
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-slab-fix-aba-v2-1-d1ece15a8417@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MMQvCMBBG/0q52YMYpRAnF3Hp4C4dLsnFHpS2J
 CVYSv67seP7Pt7bIXEUTnBrdoicJck8VdCnBtxA04dRfGXQSrfKKI1pJItBvkiW0LcqXExwxjN
 DVZbI9Tpy777yIGmd43bU8/m/Ai0vQvfs3LYaNeLjnq+WR+hLKT+ug6bejQAAAA==
X-Change-ID: 20260902-slab-fix-aba-d60f39fc9dee
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Hyunwoo Kim <imv4bel@gmail.com>, "Harry Yoo (Meta)" <harry@kernel.org>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 89F554000E
X-Stat-Signature: oncn4pebd5xo7u9iha7zww4azekrczg3
X-HE-Tag: 1788367327-696507
X-HE-Meta: U2FsdGVkX1+S8kY3YR+AC17UfMU1TquMqQhdGkuAnEgbTH/qbEpNwN258SczuvBoeY8bjBob2JOC0RFvR8MUvRk4mE1QBBgEhyxTeHg+1wkdHO9x3+5bU+6kDqWf/mmqGCW68VV2jIpcoPENN0ECJW+6SLjFjXQK6aEoZtjWo3p7gO1RiTzU0qVKYvL+lcEHo5XGWAT45WhLtE5RED6ge4ADEhdcncsYsjIY2+vsESb8VOONaOphAo5opt1QS/lhHEgNqyfM/XsrB2CqLpgqC5Xh5U5zSxbQYM20KnGRMqaV+ZwV1OvxhAISN0yxo3RmQ2+GmDFa7gr3jMR0zPZJEoqF//mO9kD87x2K6kJCpRqRHTSamGE8RkPswroZPusplxiBpuztyqNxKyKzXZmSIJK1gsmstqQLW4+ri5hKjdnnPj0iKEX6hT8HeamQmss5e+IPZDX90Z50gTQVh9gtOdRQOF/s1CV1Rpuee0NB9qKjqwUiDEtQ442XIgWdu9IhGv7GZ9XFSrEPhtZGxUxJft6COMDe2NNzCpwzISdl4XvhzSUkNfEiS1KiqGEfiSOBd35vaBMTG6kIFMEaVnFwRBlhWoKxbaV5wd36V2z5afPzRj7xBpnvqdRlZm/+8R+55tb5b/CI2iEbd4/s9GW9kthmF1pcaTpzpN3jHg+an1DrohI0aGlBstkMQNBJyDXRy2uAsavkVMbZJsbBUiDJvHdU5q29IO8rErm/h30jaybi8WL7IA02vdE6MgYL9jA+92+ZSdfaCkZyqWuI2xBiuNBNpX91UCSr0S82Ga5epW5zXDazNrUVDjAUtFxYVJP5aHgICfq+bm9qm8nlLEd9A7lg/xAyRuQyVmLlqZ4EWG2iFNsQkXGdhIiw0rAR54az+MRHSSIZUj/gQt2hpSoPnMrmwF0HrRBlm869sKV1lGcKtRzOIRcIkNn9M15zsQfdN+4fFHTHyoThJ9D9u/e
 JLLtocoh
 3Sew/SLs4lhQ408T4KIWbmcm+JQgrT8BPBTDW3ebLnmDeT8ePRQNXqzbOh+KUN3AnLDEkqI/WnWknNcS58JCsfXhp8kA9M5nZZ7HPlohBGHm0ML6osyV5yDFiUvfzA1O69sjdEcBCAZh9ZTHPBzY0gSr5sI1EqyBLnRAq+j+eoRFTOavYQM9jwGP5Di19CD6/HjrjXYHkTjRNAlBMpQK02OQYWqFr2FQI6r1C8bhvhB1cWeUhrl0h3d9CSX44mW0DaKrPCw415yV04izozc6u0LOZJKhHEw+ShBbQs3LR0q/cT2ylyOYXVNvuYMSf8LAFvgNP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ba7425312607 ("mm, slab: add an optimistic
__slab_try_return_freelist()") incorrectly assumed that nobody has freed
an object to the slab as long as slab->freelist is NULL and cmpxchg
succeeds.

However, as reported by Hyunwoo Kim [1], other CPUs might have freed
an object to the slab, insert the slab to the partial list, then
allocated an object from the slab, and be in the middle of removing
the slab from the list under n->list_lock.

Since __refill_objects_node() puts the slab back on pc.slabs
outside n->list_lock, it might insert the slab into that list while
the slab is concurrently being removed from n->partial.
This led to a list corruption, as reported by Hyunwoo Kim [1]:

  list_add corruption. next->prev should be prev
  (ffff888100000248), but was dead000000000122.
  (next=ffffea000416e410).
  kernel BUG at lib/list_debug.c:29!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 1 UID: 65534 PID: 144 Comm: poc Not tainted
  7.2.0-16172-gcf72cbb39da8-dirty #1 PREEMPT(lazy)
  RIP: 0010:__list_add_valid_or_report+0x80/0xd0
  ...
  Call Trace:
   alloc_from_new_slab+0x183/0x300
   ___slab_alloc+0x31c/0x890
   __kmalloc_noprof+0x3d4/0x800
   lsm_blob_alloc+0x2d/0x50
   security_msg_msg_alloc+0x26/0x90
   load_msg+0x1aa/0x210
   do_msgsnd+0x91/0x800
   do_syscall_64+0x109/0x5d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  ...
  Kernel panic - not syncing: Fatal exception

This is a classic ABA problem where cmpxchg succeeds but the state has
changed since __refill_objects_node() took the freelist from the slab.

As Vlastimil Babka mentioned [2], it should be rare to return more than
one slab (due to the racy read of slab->counters in
get_partial_node_bulk()). Therefore, instead of introducing additional
complexity, acquire and release n->list_lock twice in the worst case.

Return the slab directly to the partial list and hold n->list_lock
across the cmpxchg and add_partial(). This is similar to the initial
version of commit ba7425312607 [3]. This is enough to avoid the race as
the list manipulation is serialized by n->list_lock. While at it,
bring back unlikely() hint now that the condition is unlikely.

Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Closes: https://lore.kernel.org/linux-mm/apPa-cGLcyt90l-E@v4bel [1]
Link: https://lore.kernel.org/linux-mm/ae25c193-b95f-40c1-83b6-1c2546467e41@kernel.org [2]
Link: https://lore.kernel.org/all/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org [3]
Fixes: ba7425312607 ("mm, slab: add an optimistic __slab_try_return_freelist()")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
Changes in v2:
- EDITME: describe what is new in this series revision.
- EDITME: use bulletpoints and terse descriptions.
- Link to v1: https://lore.kernel.org/r/apPa-cGLcyt90l-E@v4bel
---
 mm/slub.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f9b56cb439e7..5cbbacb8ee32 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5684,6 +5684,8 @@ static bool __slab_try_return_freelist(struct kmem_cache *s, struct slab *slab,
 				       void *head, int cnt)
 {
 	struct freelist_counters old, new;
+	struct kmem_cache_node *n;
+	unsigned long flags;
 
 	old.freelist = slab->freelist;
 	old.counters = slab->counters;
@@ -5695,9 +5697,16 @@ static bool __slab_try_return_freelist(struct kmem_cache *s, struct slab *slab,
 	new.counters = old.counters;
 	new.inuse -= cnt;
 
-	if (!slab_update_freelist(s, slab, &old, &new, "__slab_try_return_freelist"))
+	n = get_node(s, slab_nid(slab));
+	spin_lock_irqsave(&n->list_lock, flags);
+
+	if (!slab_update_freelist(s, slab, &old, &new, "__slab_try_return_freelist")) {
+		spin_unlock_irqrestore(&n->list_lock, flags);
 		return false;
+	}
 
+	add_partial(n, slab, ADD_TO_TAIL);
+	spin_unlock_irqrestore(&n->list_lock, flags);
 	return true;
 }
 
@@ -7296,10 +7305,8 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 			void *head = object;
 			void *tail;
 
-			if (__slab_try_return_freelist(s, slab, head, count)) {
-				list_add(&slab->slab_list, &pc.slabs);
+			if (__slab_try_return_freelist(s, slab, head, count))
 				break;
-			}
 
 			do {
 				tail = object;
@@ -7312,7 +7319,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 			break;
 	}
 
-	if (!list_empty(&pc.slabs)) {
+	if (unlikely(!list_empty(&pc.slabs))) {
 		spin_lock_irqsave(&n->list_lock, flags);
 
 		list_for_each_entry(slab, &pc.slabs, slab_list)

---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260902-slab-fix-aba-d60f39fc9dee

Best regards,
-- 
Cheers,
Harry / Hyeonggon


