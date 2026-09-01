Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC76BC624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8096B008A; Tue,  1 Sep 2026 14:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0796B008C; Tue,  1 Sep 2026 14:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEF236B0092; Tue,  1 Sep 2026 14:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE836B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:01:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F36C1A04E9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:01:24 +0000 (UTC)
X-FDA: 85165960488.26.3729334
Received: from mta0.migadu.com (out-161.mta0.migadu.com [91.218.175.161])
	by imf31.hostedemail.com (Postfix) with ESMTP id CB2E720009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:01:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q6d6LXw5;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788285682;
	b=q9Vh/9gYmzCM7Yjns4iK9h5Qb0TL7DjR6GDDNDstI3Coi7rzf2XuXyYyFMgwyw+cpIVvag
	5nH/sS0T+dlP+DwV+FhAuQsWdfVRBAM7g6iy4Yz0QmxoMQpUgfDWV/eD/HGh6estYvJQ3A
	+IGIw33ioqu3WCOSjq6dMRjWE6eaIpo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q6d6LXw5;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.161 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788285682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7pL/VhErMJQJZR+yiMVDUlqvytwoHX6RdOY2/5ueRvI=;
	b=q9zx8Xot+vLD18xRdJXr2FvIm5ggmvK7gMLfxBMJlILcdfcmaiSQ5J31ChI2J/XAe5FZPF
	RwB7cXc6+SHaPoBHewHJr8vg3S8ew5UfkWk0XOrqqkw1hD8qezkjCdqpeoOCcY52vuqX1t
	OyUNpiXutps+a+ZA4mmvtOpN7FKiDuw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nqYmKjd9b9ej6SRWcnIOWJeONPy2vtwt8S3/sMfIUtY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788285680; v=1; x=1788890480;
 b=q6d6LXw5C7LRW32fkzga2wLw7TSXkpXDll/8iUnvQEoZ14NRnxa41tilgeEnscAopuufaDKV
 Kde3G4BMAos8MOxMYnZy0mrzOmr4bEtRvzXCpqilDG5DZ2mKe66DWsRDQIaDaEQ527BwOvUUd0U
 tBY/fp83+1EuC7Zj3egqFu74=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id dc1bc49c649213e5;
	Tue, 01 Sep 2026 18:01:20 +0000
X-Mizu-Trace-ID: dc1bc49c649213e5
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] mm/mlock: use the IRQ-safe accessor for NR_MLOCK in __munlock_folio()
Date: Tue,  1 Sep 2026 11:01:09 -0700
Message-ID: <20260901180109.3797944-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: bfoixkmmusfeqmwc84cn1u61d8i5xcdm
X-Rspamd-Queue-Id: CB2E720009
X-Rspamd-Server: rspam06
X-HE-Tag: 1788285681-235559
X-HE-Meta: U2FsdGVkX1+GhtHhOo3soxwgObI0xredCnI/FIrLoyul7HUJSRUSw6raCWHsgjopXOA+njHuzk6IfTE5QCsjOmWRLKzMRjLEbAblgYmS1TZZP7rWqfTXDW/x1hw8JvFOa7l63EIeUWUe1j8kzcvnPx9TsxicYmw2IU3AdZ+TChYgkGicaGHh+F1tSdIv6xWCg0RGy4vh8a1xGWFtRI9xexwpKSNKh9kpDO6bYQPIXlFuIXQkwOiJVTEM78bwwqgJYLNXbH8itUL+AWK5jSOgyuRbZ5/OqdRA0WnP91vASTWfBwCMw63A56ylHyon76dlljrImEm8jUlac6Q3auUzLsv5aptss6+hxsYoAPslXr0ukXAfzc0enJJQH26UPORc1uA3ZEW1pBptN2YslAsfy5zRilc3VdCWYh1H+s2zA+5HTgHbSueIZ4RKuoEhtNqFIgRt8C09vyFjoHlX0+XIMuggRPrAsmVvFM8FBQyI+VckuYERvh39iSwL9CC/qN7azDRzV7nv6wv8D/xhTi2tpgTBg08ghtLC5GM9cpd5ViCH/PrNm/TqilaviebfSzsM8+oEzyIVXFMdww40JC5Q+IcNSy++wGVhGhukFLWyBurLsYqNZz/F79LDSPixgKmsAQdYl+oBaV89yUAbceMjDWmCAtdo1Z3spqAZ5UQ++yCeopyA1MlToavWg9REoE1wiqqYsQb75FdaWegGkL3TLQAFiae0asYFh8v17qBNr/Di/DxXF2nMOGLAJzZksNeNjK/T9fatCBX052JCJct9UMRvgj5L0pjzS6FtTSy1OaGU94fdUSnP8NpWccl7HBy6VfxNWE8hpmFdA0nO+2vZRXtKlpatU8ODEzn9u/nfKWuikH+fXEEzRZ9Pv6/VFy6VbdLNVdDUairHh8Tk7oO/nGzrEIeuDxTGKWivij1jFdN+NHk4pR8mR753fopW4KUL4uri4w/LQN6DGo/lJer
 rQnNMDFL
 7ZB+UmbbF4wPSdk/Yao/B+mxN06zlLbl+IYUoMHlzE42tdwRyDUH/9O0MWV5bTOozXJCZ4qp/5pc6gE+qA25p9sskG/4z/7oLCgmmOH4Ootq95OQaVpVseMgBqJ+FVcPuyxgJ7z2gy/wur72/FPSv+TtUwzIZzkuL4Kr+rk1RTEAyz08Yqu3yBJ8urL3Afw7UYEvKIigHghO+Gi+cGkYK2dW8U8rb0htkQaNT8M643nkh+lyIuOTMnUj0JA4QwKfNVSTrztq0pZtKol7aluSj8vvqYVFv1g5ggH39HQppJyMvBLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NR_MLOCK is updated from interrupt context.  __free_pages_prepare() clears
a stray PG_mlocked and adjusts NR_MLOCK, and a folio can reach it with the
flag still set from a bio completion handler:

  __free_pages_ok+0x6af/0x7a0
  <IRQ>
  __bio_release_pages+0xde/0x260
  __iomap_dio_bio_end_io+0x16e/0x1a0
  blk_update_request+0x14b/0x3d0
  blk_mq_end_request+0x18/0x30
  blk_done_softirq+0x49/0x60

The folio gets there like this.  A MAP_SHARED file mapping is mlocked, so
its page cache folios carry PG_mlocked, and an O_DIRECT write sourced from
that mapping GUP-pins those same folios.  munlock() then runs
mlock_vma_pages_range(), which clears VM_LOCKED before walking the page
tables to munlock each folio.  A concurrent hole punch reaches the folio
through the rmap (i_mmap_rwsem, not mmap_lock) and can land inside that
window: __folio_remove_rmap() -> munlock_vma_folio() sees VM_LOCKED
already clear, so it neither queues the folio on the mlock batch nor takes
a reference, and the pte it clears makes the pending mlock_pte_range()
walk skip the folio at its !pte_present() check.  filemap_remove_folio()
then drops the page cache reference, leaving the bio's pin as the last
one, released from the completion handler above.

So __zone_stat_mod_folio() here needs interrupts disabled, not merely
preemption, and __munlock_folio() has a path where they are not: when the
folio has already been taken off the LRU by somebody else the function
jumps straight to the counter update without taking the lruvec lock.  The
read-modify-write of the per-CPU NR_MLOCK diff can then be interrupted by
the softirq above, and one of the two decrements is lost, leaving Mlocked
in /proc/meminfo permanently overstated.

Use zone_stat_mod_folio().  mod_zone_state()'s this_cpu_try_cmpxchg() is
atomic against a same-CPU interrupt and retries, and on the path where the
lruvec lock is held its cost is negligible next to the lock itself.

The UNEVICTABLE_PG* events are deliberately left on the __ accessors:
they occupy different vm_event_states slots from the UNEVICTABLE_PGCLEARED
that __free_pages_prepare() bumps, and nothing updates those two from
interrupt context.

Fixes: 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/mlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index efa6716e4dfb..39215a3eab1f 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -141,7 +141,7 @@ static struct lruvec *__munlock_folio(struct folio *folio, struct lruvec *lruvec
 
 munlock:
 	if (folio_test_clear_mlocked(folio)) {
-		__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
+		zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
 		if (isolated || !folio_test_unevictable(folio))
 			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
 		else
-- 
2.53.0-Meta


