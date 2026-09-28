Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40DD7C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD136B0088; Mon, 28 Sep 2026 04:04:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E836B0093; Mon, 28 Sep 2026 04:04:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A466B0095; Mon, 28 Sep 2026 04:04:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 188966B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:04:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BC2B120131
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:04:56 +0000 (UTC)
X-FDA: 85262434992.09.106C17D
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf07.hostedemail.com (Postfix) with ESMTP id DAA1540002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:04:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=NPA53JfC;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf07.hostedemail.com: domain of clkernel@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=clkernel@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790582695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iA8KWlTOkdC/SiapUciFxb0KSa4O1WHpeMzrlBAya+8=;
	b=K6Q+XReuvuGUEq4isnBiILur1voJv+LX2PX2EMJ0bSs3CqYW9YkGUfoPpoVQU4vpubH7Qi
	1Eu5qWz0DEgwIRHXLtIYM8mTNbLnyCAwjfpHUj+MTqWYZpz95k7idMir7NC701a4yA9tWw
	p6eLM8tR1yYuvnVMLHDmuEK4jwX9Zj0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=NPA53JfC;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf07.hostedemail.com: domain of clkernel@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=clkernel@pm.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790582695;
	b=VmyWUcGwURdyng5xn0H6XWTDZoIaMgae0jdgD+ZROnFlCidjTr9kWsmxxJfLsLQGkTsxdZ
	5TMJYjMZeSjU8nwt131kpCmB+MiJgVT8yGd4Jxt9nzAdD8g+6cSdiZFep0EH6W/UU0zd0Z
	nKzEEANzvYwWYJj+yUH2UnU0kTacJHA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1790582691; x=1790841891;
	bh=iA8KWlTOkdC/SiapUciFxb0KSa4O1WHpeMzrlBAya+8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=NPA53JfCfJRyyScGmdroi6z9zp6Tk64L/aSjv67CGQh45ht7pgGvdQOmE613ToaBe
	 t1EOaAC4HNRAFiU/wZUAMosyVBRotTFWS1ctWq5zmXZFke7lUlMhy4Mqsv0Y7S9bam
	 SdvhylTe9doWnFyUsp9irltJNfjpVv75993jrs3KqWmHwh71PpEby/mAbb6PZ3v9L+
	 N7aFCvwV6+YISLVo95bH/r0sDHN7UQIVDWVgRBiZUuNbUNkN5B5D+iQJ31V1zkG3uz
	 hmTXLhW3wIzLgIZY5nU1Se5lPtLbgeay6R5dB/alHoZxH5v2sZ0lLHBz/442rHjY3u
	 JqqD0j5QoSFdg==
Date: Mon, 28 Sep 2026 08:04:45 +0000
To: linux-mm@kvack.org
From: clkernel@pm.me
Cc: axboe@kernel.dk
Subject: Re: [syzbot] [block?] INFO: task hung in read_cache_folio (6) (extid 9db0864859224b833108)
Message-ID: <731bdd5c-2835-43e6-9563-7ab7897d6810@pm.me>
Feedback-ID: 224698563:user:proton
X-Pm-Message-ID: 9b7e736b8bbaeacfed09246dfe019774754cc6ad
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: d9fumqh5no648o7ftkbebadqemm6wyrr
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DAA1540002
X-HE-Tag: 1790582694-81032
X-HE-Meta: U2FsdGVkX184vRCv3eZFxvbmLZ/VBIsAGJXU0yVjzdZR1k6/Xm34z6tKIR49O5o3W5a8A8QR2388OHgPucTevY8fK2WZkocZlIvqNBwTd/d2XrXFiy88D5Qvm/DLAILBh759p9YGeQR9kUWLnMaPHcrEME1irZWPdXDfvcLd0bQLNcMh+TprwshVvSGswldpfz2FjIpn1Z+x70BfASjfEMA+SEYD72Fg32KFe2lGk6lIp4QTEFYQwcZHpjUY2a3n07teHqbbhWz54Zg0PBhr72bHwub2fuJvuxczdZ31Sf9i40Ox72EvV7Lw26mvao07jWav3mVcG/cW6V7V/DulFkekPhOuD9TNaGESUdGkaIa/WiN+4Uq9TMaJBl1asGQdd0jcPHNI0WwsND2JtN2Lcq94nPgMZOVojXJ+2xUewcoYMX4bmltABGzIHDeb9SAR6X9wM/aGQGEOHrHkUF5adsuSJs0kKd2RnWQ9iRDjNIag2uqHH7o+LwozR2zCTRUCAZH5xWaZn/1qRezMEgMVOEn3VFrwtZrz8qClOlZ0Qt7y3AG0DRYHzYW8MGmjUPmigjYQ6AKxnIh3y6qEB+KjaSpS+aeLi5oDbsmP4oukziOffapafYDXuzhn6NH42usLMI3Er/jJqJO7oFHrH/j8IemP6iIBEt1aFAe4Jwni5NNfMB+0InBrV110vD1dVnTO8NyxUKxPuVfWryKF7iSby4LBRgJdX9oS8fiXJNuPqprmLcFlw7Efc9kxcTh7/qyEMbHrT6lLNwAaMz6//8XEg6NGbx9+4KVViL6cn61llZXlB3/t/amfAG7p93B0cTOPxlAcjbFziEKuzoMKiuc8uY4E4nVAbKlDWCEy4k83nmeowDUA2ZHVnW8MmpfNX+UToEU5RNhbwjulOkCl3e8g55cvzIJocHxLT6SX26zio6z9T9DqYezElym+5G8DanKA7yD3cqDAITzyTNVh8Ch
 qHumjnoF
 jn8D8U6Ty3xAZEJoepXBoYT3jyCvBod9J0/Nrgp71i65caCoarb3npGFi0MOzAWAz0XhS1lkjhffPq1oPpNFbwGW8imi4GO+OzM0BivofR5k0/O3lUecGYJ8g6psGxaLZM3pMHKb46DswZPwAEZpSJ2gJ7tfxDxqwMLxSv1eGzfkzUdRLj2lDtJzR3nauvMz56pnWVYmA+/fLYzRW664YDjhMomGxFwDiofbuyNRGkHqkAhTY6qFlrGUnIwIggeTMnxEEq51+36aNj+uBPR9RS3UADLCqMVlwJw5l8jpnVypcAsfR5F9C6CMwNWTyWvFCzrBXd3INXQDn5HY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 03 Jul 2026, syzbot wrote:
> syzbot found the following issue on:
> ...
> folio_wait_bit_common+0x6b8/0xa30 mm/filemap.c:1324
> folio_put_wait_locked mm/filemap.c:1493 [inline]
> do_read_cache_folio+0x23c/0x5a8 mm/filemap.c:4089
> read_cache_folio+0x68/0x88 mm/filemap.c:4139
> read_part_sector+0xcc/0x708 block/partitions/core.c:724

A second observation of the same wait site: on x86-64 servers we see=20
reader threads (a database reader in a busy server workload) parked=20
D-state in folio_wait_bit_common's io_schedule, entered through the same=20
folio_put_wait_locked -> do_read_cache_folio -> read_cache_folio path=20
this report shows. Observed on 7.0.0-30, 7.0.0-31 and 7.2.5, reproduced N=
=3D3.

Three measurements, per repro:

1. the pinned folio's lock is FREE while the waiter sleeps: a fresh read=20
of the exact pinned pages answers in 4-108 ms while the thread stays D=20
in the same wait;
2. each later lock/unlock of that folio wakes the waiter for one ~4KB=20
read: the blocked read's offsets crawl one page per unlock cycle (~one=20
page per 10 s under churn), so the syscall can sit in the same wait for=20
minutes to days;
3. the discriminator: read /proc/<tid>/syscall while the waiter sits=20
inside the wait, then dd the same page range fresh. The dd returns=20
immediately; the waiter does not move.

Root cause (established from source, then observed directly on a local=20
build; measured): folio_wake_bit() wakes the hashed folio waitqueue=20
through __wake_up_locked_key(), i.e. __wake_up_common(...,=20
nr_exclusive=3D1). The walk in kernel/sched/wait.c stops at the first=20
WQ_FLAG_EXCLUSIVE entry it wakes:

=09if (ret && (flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
=09=09break;

folio_wait_bit_common() queued every waiter with=20
__add_wait_queue_entry_tail(), so a non-exclusive waiter could sit=20
behind an exclusive folio_lock() waiter on the same folio. When the fill=20
completed, folio_end_read()'s wake woke the exclusive waiter and=20
stopped. The shared/DROP waiter behind it was never visited:=20
WQ_FLAG_WOKEN never set, although the wake itself ran. PG_locked was=20
already clear and the folio uptodate (so a fresh read of that page=20
answers through the uptodate fast path, measurement 1), and PG_waiters=20
stayed set, so the sleeper only ran when some later lock/unlock of the=20
same folio address reached the queue (measurement 2: one page per wake,=20
crawling until traffic arrived).

Same mechanism explains this report's hang: the waiters are the DROP=20
ones (folio_put_wait_locked), which drop their folio reference before=20
sleeping and re-lookup only after a wake that arrives late or never.

Observation on a debug build, same queue after folio_wake_bit() returned=20
(a read-only walk counting matching non-exclusive entries left=20
unvisited): 363 events per 10-minute run of readers racing=20
punch/fault/truncate churn under reclaim pressure on an unmodified=20
queue; 1 per run after queueing non-exclusive waiters at the head side=20
only; 0 after the same change at softleaf_entry_wait_on_locked (the=20
other non-exclusive enqueue on this queue).

The fix (mm/filemap.c, attached): queue non-exclusive waiters with=20
__add_wait_queue() (wait.h's own default head-side insert) and keep=20
exclusive folio_lock waiters on __add_wait_queue_entry_tail(). With that=20
order every non-exclusive full-match waiter is visited before any walk=20
break can fire, which restores the "wake all shared waiters, then one=20
exclusive" contract of nr_exclusive=3D1; exclusive waiters keep their FIFO=
=20
tail and their one-at-a-time wake. Same change at both non-exclusive=20
enqueue sites (folio_wait_bit_common and softleaf_entry_wait_on_locked).

One known sibling waits on a follow-up: __folio_lock_async's entry=20
(io_uring buffered reads with ki_waitq) enqueues non-exclusive at the=20
tail. Same class, unreachable from the workloads above.

Reproducer shape: threads pread a file while others block in folio_lock=20
on the same pages (hole punch, truncate, or mmap faults) under reclaim=20
churn. On an unmodified queue the waitqueue walk above counts the=20
skipped waiters within seconds. The harness, traces or configs are yours=20
on request.

The same change cherry-picks clean onto v7.2.6 (mm/filemap.o builds=20
there). Happy to send a [PATCH] for stable@ if the fix is wanted on the=20
7.2.x queue.

---
  mm/filemap.c | 16 +++++++++++++---
  1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f55..383701407843 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1294,8 +1294,18 @@ static inline int folio_wait_bit_common(struct=20
folio *folio, int bit_nr,
  =09 */
  =09spin_lock_irq(&q->lock);
  =09folio_set_waiters(folio);
-=09if (!folio_trylock_flag(folio, bit_nr, wait))
-=09=09__add_wait_queue_entry_tail(q, wait);
+=09if (!folio_trylock_flag(folio, bit_nr, wait)) {
+=09=09/*
+=09=09 * A non-exclusive (shared/DROP) waiter must queue ahead of
+=09=09 * exclusive folio_lock waiters: the nr_exclusive=3D1 wake walk
+=09=09 * stops at the first exclusive match, so a non-exclusive
+=09=09 * waiter behind one is never visited and never woken.
+=09=09 */
+=09=09if (behavior =3D=3D EXCLUSIVE)
+=09=09=09__add_wait_queue_entry_tail(q, wait);
+=09=09else
+=09=09=09__add_wait_queue(q, wait);
+=09}
  =09spin_unlock_irq(&q->lock);
   =09/*
@@ -1429,7 +1439,7 @@ void softleaf_entry_wait_on_locked(softleaf_t=20
entry, spinlock_t *ptl)
  =09spin_lock_irq(&q->lock);
  =09folio_set_waiters(folio);
  =09if (!folio_trylock_flag(folio, PG_locked, wait))
-=09=09__add_wait_queue_entry_tail(q, wait);
+=09=09__add_wait_queue(q, wait);
  =09spin_unlock_irq(&q->lock);
   =09/*


