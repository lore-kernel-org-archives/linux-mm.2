Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B931CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 13:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B7D6B0098; Fri, 16 Oct 2026 09:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3886B0099; Fri, 16 Oct 2026 09:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508C46B009F; Fri, 16 Oct 2026 09:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36C176B0098
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:25:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFDD0C0391
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:25:29 +0000 (UTC)
X-FDA: 85328561178.25.6468739
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1FC5780011
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:25:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf30.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792157128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=YyM+kSZ/e+8UHZbq05peHGra4Pu7DISTxSgIMMwe69s=;
	b=PKD0W2qzxD50StCWW0SezJ+VA+tGmv5XRza3WbJS42cwhPcCOQCuIDuGlGrcJ3V5lW5yow
	R394bXmQtLCvrItEhQivioIiIZQyI7JZ5i64S913t53OrYKUEr4Ps4b53fzMSzPjDxKgqi
	CfxUY+V2kDZ7K3Jzxx9IF9I8IJx7zYM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf30.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792157128;
	b=YPenIANXRzu7v0av+80504gAxmufIUNqvo6QLQ0Dnk6ydx2ua1LpIALogiAo/xESA4pKVw
	MgtIS0Nswk7/K5D+OQZOBGgGJUGNRt+qWJuAXmz3EVuQXkXcvQ7UXsDI6TJ/anV8EHgwiG
	1jcRXKkmkTDjcZpVpA7kQG4HsNqZMcc=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xHhvr-00EzQh-2V;
	Fri, 16 Oct 2026 09:25:11 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1] mempool: fix min_nr exceeding the elements array after concurrent resizes
Date: Fri, 16 Oct 2026 09:25:10 -0400
Message-ID: <20261016132510.789715-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8d6ghxwo68esq7a653ghkcy7f31u9eqm
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FC5780011
X-Rspamd-Server: rspam08
X-HE-Tag: 1792157127-963131
X-HE-Meta: U2FsdGVkX1817HfAMJyZQDWAb5WTosOxGKpPr20d36QR+2CXUDccTYLRc0+AnbAll9PazZM/fI6CqZyZWGPwrI6m6XA84izjN8VqYLp76dBV7mC6zXO683enInP+xJbpO24+j8ZnVBYZqnd/amCkpBkyqcLkge92IiOWGB5SeF9KPqw6vCin7H4Z5NmuHwNxoBEiieKWjKF4uYWRHKqDkR9KrUSV12+svQk+8GAX+splXPqwEiCFOlfGu8QH/wmvbLqbhPKylHkYURwd7SveQZSaKGOBMugzlAtH3232QiP0HaHYF8Cxg8ujWqjLuRHKICQZwDjvie3O3zy1R3AYD07MO++0v7P83bFh8hQ+Q7bqV4O9rmjPkBLhxNIjdN/g0zonply5CUZ4Zq6QngaJC4on9ZsGLZcIVg3xn7ZSD4SqF9QmTf6E1n3e8AarPyCWhGXTF7w/Syn8/3PFyzlXPfIF9UCLyC24qz2XSJit55tI6XV1Gi96/VQrP3rGR1T1tNz6fXYDJK5aDw0KByeFzMuie193YeirTk1C4RUFeEDudOHkFxEAXY9/FHsi7VSDA7IdrWehXAuE6hYpU4YA5rmRoV+NGYkXwQ9siT7LVvps5/A+0zqgr8LKEkBRPU9End0MdtPk8vdyPYvEY2AP/GJpVFAeHHbMnbU2qbQ3gg8Lpfn1zg88h3a9Ilik4Bfrgk1rGlxC9j/dvryEKMM3z/KpY0iGUxq7AvXk5P45x83f5ZcshLlP+PhliMTQi8dhDeiivBjkvrrPdRaN8xmcJmIVGNgATDmhu7hRcV6esZe1qA7VwRF+bcLYTokGVVqpCVxMu3wTqmVOULNUcCJ3vGoraZ8RJllHPkMMlOaXdwJNu861SOXhua5ZWc85yHbsqd6HbaRyhlArYe6cYk3itNNZv2ombhgEAwAz0JRl3PmZ0IVdC4JxROsTElTVW+IKW6u6R0pImjqMUqka8sr
 X76mmXss
 ++nGAaIx5tS1X75HjjXDYwa8Hwv26U/jjYVt3twawvFhJqKFfpX++tAWLbe6Xjd6Rtxi3Fz4VzJRE89K9Nvlvf8CqdtPCmEXQBXSNJS8r60mjTJfmuo9Uiaf9HTIniXxaZYfi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mempool_resize() shrinks a pool by dropping pool->lock around every
free_fn() call and, once the pool holds no more than new_min_nr
elements, stores new_min_nr into pool->min_nr.  new_min_nr was only
compared against pool->min_nr before the lock was first dropped, so that
store assumes nothing changed meanwhile.  The kernel-doc allows
mempool_alloc()/mempool_free() to run while a resize is in progress and
the grow path also copes with concurrent resizes ("Raced, other resize
will do our work"), but the shrink path does not: while its lock is
dropped another resize may shrink the pool below new_min_nr and a third
one may grow it again to a size between the two, replacing
pool->elements with an array of exactly that size.  Storing the stale
new_min_nr afterwards leaves pool->min_nr larger than the elements
array.

Interleaving on a pool with min_nr = curr_nr = 10:

  CPU A: mempool_resize(pool, 8)
    takes the lock, 8 <= 10 so it shrinks: remove_element(), drops the
    lock, calls free_fn() and is preempted there
  CPU B: mempool_resize(pool, 3)
    completes: curr_nr = 3, min_nr = 3, elements still has 10 slots
  CPU B: mempool_resize(pool, 5)
    completes: elements = kmalloc_objs(5), min_nr = 5, curr_nr = 5
  CPU A: retakes the lock, 8 < curr_nr (5) is false, stores min_nr = 8
    while elements has 5 slots

Every later mempool_free() sees curr_nr < min_nr and add_element()
stores the returned element at elements[5], [6] and [7], past the end
of the 5-slot kmalloc allocation: a heap out-of-bounds write, i.e. slab
corruption, a KASAN report, or a crash in whichever unrelated object
sits next to the array.  The invariant that breaks is that pool->min_nr
never exceeds the size of pool->elements; every other path that changes
min_nr or elements keeps it.

An in-tree caller can hit this: fs/smb/client resizes the global
cifs_req_poolp from cifs_demultiplex_thread() (grow, when a TCP session
is created) and from clean_demultiplex_info() (shrink, when one goes
away).  The two are coordinated only through the atomic
tcpSesAllocCount, so mounts and unmounts racing on one client run the
resizes above concurrently; pool->free is kmem_cache_free() there and
the window is a preemption inside it.  The other callers
(block/blk-zoned.c, drivers/s390/scsi/zfcp_erp.c) serialise their
resizes.

The shrink path has stored new_min_nr unconditionally since
mempool_resize() was introduced, while the grow path has always
re-checked pool->min_nr after reacquiring the lock.

Re-check new_min_nr against pool->min_nr under the lock before storing
it.  If a concurrent resize has shrunk the pool below new_min_nr in the
meantime, keep that resize's min_nr (and whatever array it installed),
as the grow path already does; otherwise the store is unchanged.  The
elements the loop has already freed stay freed, which is right either
way because the pool's limit is now below new_min_nr.

Found by formal verification of mm/mempool.c against the kernel binary.
Reproduced with a userspace build of the affected functions in which the
free_fn() callback drives the interleaving above: before the fix min_nr
ends at 8 with a 5-slot array and the next mempool_free() writes past it
(AddressSanitizer heap-buffer-overflow); after the fix min_nr stays at 5
and the element is handed to free_fn().  Not reproduced on a running
kernel, where the window is a single preemption inside free_fn().

Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

 mm/mempool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index cb74e718b2c6..95533e2975ce 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -378,7 +378,9 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
 			pool->free(element, pool->pool_data);
 			spin_lock_irqsave(&pool->lock, flags);
 		}
-		pool->min_nr = new_min_nr;
+		/* Raced, the array may now be smaller than new_min_nr */
+		if (new_min_nr <= pool->min_nr)
+			pool->min_nr = new_min_nr;
 		goto out_unlock;
 	}
 	spin_unlock_irqrestore(&pool->lock, flags);

base-commit: 90201351a862182bdabfc1ad1c97b1e1b6ed5931
-- 
2.53.0


