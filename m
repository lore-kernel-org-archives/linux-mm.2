Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1807CC5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326506B008C; Mon, 24 Aug 2026 09:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE3F6B009D; Mon, 24 Aug 2026 09:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F566B008C; Mon, 24 Aug 2026 09:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB6A76B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:49:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7845E14012F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:49:55 +0000 (UTC)
X-FDA: 85136296350.11.B2D03B7
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id C18E520006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:49:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ePTnUCwz;
	spf=pass (imf13.hostedemail.com: domain of hughd@google.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787579393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wa1iTT9vjhUKkra9WxI7hECThksYL7WKs9jkspFydz8=;
	b=tcnOk+7/0d0lev9WeufTuS+M4WWP67I2SwWjTGmrx5SW7jcBRfIKflt5CBmI1fKW7Az19y
	77fokEapsnSltaPu7u2VCmabO5dneTWvPnV8axE8mge+7G2ih0VJ4V1ktmAjJS7w0+PLj3
	yFLc541bkz3nIzlHdusFRwfx2IK7+xM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ePTnUCwz;
	spf=pass (imf13.hostedemail.com: domain of hughd@google.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787579393;
	b=taZvPqyRAavTX5d5Kmc+nZTPRLPaU+2JCElRsl4Mjw8ult5Y/ixPg/vrYcNun6PoXlI41D
	Xa7rvgLC7JmjVVDIRNf1jOvxBEW9HHD1Cu15CwBCV7MDnIh8qgIP5bW8NsumQykIqiS1A7
	1ixN3BN+1tDfDBjsHvOSeikNo2LA7P0=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-836c718715fso32798537b3.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787579393; x=1788184193; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wa1iTT9vjhUKkra9WxI7hECThksYL7WKs9jkspFydz8=;
        b=ePTnUCwzLaa1JAXj0vue6bAJKgUXVHCAEJHP3hP9Rc3K7hxWI2PNFoywEsxhfD3c2L
         12U5x3Q5aiQYpz6v6nSNh7ROsLxo8TckKp3bStDUcXW1ldzqDpzJ+W8opHyjDAUamzhS
         SnzmcfQpFd9pcmEHACJOdrMpN0xfLqntauBigYdyhv/vOXOT1Eb5xPf4lfhEGZH5Wiob
         onycD2fofd42sAYGxnCMTVxn/M5Lg7yJOg+cEh9s0SNv6ZV7Fq0UoGCRa/qUB7dWfCSV
         SYC5Q4xdEgMJDj6/7VXXmUMXofQY3JrdQUf9Fc6tD0n3aydn7GiXN/Tm6JyxW/ZXbiV7
         shSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787579393; x=1788184193;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wa1iTT9vjhUKkra9WxI7hECThksYL7WKs9jkspFydz8=;
        b=UzSs7KSDqiAYAR3wcPv4Qpr3kGIADIPyW6W3jssfH9YwHR9ms4iKBMosnkAHoMlBzN
         OjR3lixqoO9e4JqU/ZIOhuzJy95lozetfFhtfFCyUmGkwB2KYQFNWkS38UJfGZkLtXba
         krmgT+JLSwHU8sxBjRwI2sgZ4OIJHUW/Ik5XbxJ5olBjgMngbqkU2rJ5jjnuiobL+5gA
         ijlcONya4/U4H9Vs+9U4n64zE90gEF6BUziIlz1O1UgX+s8x9ObqDzQe0BRUcnid4JZy
         JHQnZlz+B7TBa2Li+DWC0Hb7wuOCyY4amvgHl4KoR7UbTuqnPJXwYUBBofjdXD0+6gW6
         0NYQ==
X-Forwarded-Encrypted: i=1; AHgh+RpdR9pfNx6r1JI1QBs4gt1Y53TxH8J7Kv4jJmB5oplF/OwyHYe+dWAsuAOtEkfTK6fsqsrNx9dk/Q==@kvack.org
X-Gm-Message-State: AFuF++lnyh/t7LF838Y5k7Ufw9ECxwoNaXDJlmsh84R2S4NpHAqOr+cY
	CI1mDN4U8L2qQyO57JpUx5sbNW+gK73z9934Dp6OxGM84SHIKoMMEYMWZRCH7oHFhw==
X-Gm-Gg: AR+sD13fZCBebZR1jQh5O4mTi5d0lxNCkkS/nfd4qMcQchwQrapX25CIHX7RW4OxJEs
	FOWo4pn2IXWdE5SIpf2+SNOASDjc7UZHAKM+CHo8rxhMFiULiCpk+1FUVWMz2y494b+Gn6Cj+j+
	K3AHitOG5uH0rbWDlDD/OWZf6HS+jmABKlreVhxQgBUwcnjRxxc7F0KZMpb1uQQOQHPQl6dTllh
	RIAaI1u0v2ab1AGpbPfPP/lD30J50/VTQfgs5s2mhA+Kh5/q9U8ILnHz1VLm6llRTbWMwpA00RZ
	T1eOA0NHsvKwGcstg9MrI2yuMcZIMc8v2xPrWeRywTRLGLBu4GpwiT//zBQv5fPK9S4vHEfGPcM
	fVyQznkfBU/9PLE2uzd3frgCkm2yID3MD+9tq2BrRRiBzh03wLVNo2iG2OlniYhmAbvTAriyXAS
	x+yL9TuOUh0onEDIpkySLfHIXutisyIOEhJwtBl8kfiAnYU7oWQzI6RSFZwUOHKdUxXSPbshYM7
	Dsj2QK5svVvtJ7/q6UpVXiszzORbvzRcyZEyleJR8n5Pdj+
X-Received: by 2002:a05:690c:c602:b0:81e:ae6d:caed with SMTP id 00721157ae682-849f7262b93mr78114917b3.34.1787579392083;
        Mon, 24 Aug 2026 06:49:52 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84ca62f6ad5sm33495767b3.18.2026.08.24.06.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 06:49:49 -0700 (PDT)
Date: Mon, 24 Aug 2026 06:49:31 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
    JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>, 
    Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
    Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, 
    Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>, 
    Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 00/25] mm/fbatch: drain lru_add_drain() and _all()
Message-ID: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C18E520006
X-Stat-Signature: dffhjrmwunekzkk8unkuyf3fc9ma999q
X-Rspam-User: 
X-HE-Tag: 1787579393-2759
X-HE-Meta: U2FsdGVkX18EuCtD80svkesOLfskdDMSgxzZu1PXsy+7AZLqwJUMZJ8ZGwlnJdPNPZU/noKrneLuWC6g6tWnmmnXbPn94lkcWr7r/qxWyJxTsF4c8nyv60xcpQevA7XQvKKWs57KzCJcKNE2WfG9amyiGCD2gOpSey+c9kFkG06JqILI0scATdkBj3qRIS5jcdNpBdbPcn2TNzj0dpXrPmY6kQtggPcFb91fzI8o0iHb0FDUPq7q2z7W5zF+bQXQ3BURjtDqp7mRxkXi2j0+aY6e/b/mrZcZHeKv2kYkqSHT91I1nhiIMMr+9Dn/7TiH+lIA6KID/aPokGzXABKfyX9t2ElEeanU0YKYBvbpn6wMLuEra9QiJzFL054/Y3LT4GXWb6JLyBI88IBm/aInQW5mqUqQ2Z/3OjyOAnxIsSQMJmrVfW+F0B732wEp/2eemc74t7uWxzuoo8Mm4UoHRwcFkTk9xrAr42z3ATRaSHRXXFKWOc5ofqY7CF2orp5RHTsFe2YxHFm3qfMzC6CPb8zyrPw/GtTG1GJxWxr3Zn0zEpIoWQZqxnPT9tlQHXo/ysuiZmnZtaxzS9SwN3OWGqB0+CKn+i9qd0je55M3mulZvomiSFuHayrUMwHyVTvmrpXhODAjuuC5X1Mh/3GRKT0VirrQNT/RbiVhkhfvwgObZ7veujCYccpeoMoIvhq2L/akCOwrWYka6ruVixDj0EMiY7c1TGiTjs3Q6u2jdaRJEmdafMIHtGgtOhW0WpOqdbpQCQNPW8r81AfvZDtCaLUaK7c//QIsziANMzwU+7F+fCQD2UA5EYK/IcAg+fyHWlK8n/QZ+K0ume3MDsjwfj0VeTGs+n+WyLTfQp/J5whMnRHRQKlBwUinhwfizkpeu6AW5YVHyTw9TrY+brNSVoS4Fz6XJpya3v/zWrRsSNwN3xe7aL/NILT19jyyahGAcejU1qSiKutvsaidxtP
 f1nJfVuN
 4LMTInxw6uWXUSEb8pCEgtmKQ7dDXrmq1cko7/1p7FH70/5QAYcUdzaYP3V3NAj5k3pPuZl1y0Xw4uaiOKzEkReyq/GavYX/teJuDGrwX6WOPZopZ1etd1m9t7NwSbarSAJygcYga4jtHUx+OF++ebQZA8IxNc0vz07+JRjqPrpTGTenymAGWNVExZCUOUrWfY5yJzbZKhksSrYh6BVd8z0K6nup4yUTtpQ3pD+Ny+zV9ljK02pM2vid5pproPjp1DSwWUqGZk3XvLZjPqwU2qPRTq+67gSBw3hjFf45RkHC//yD0Yff+i0k/KRYa8QO0O9n0OlUszYT8v+ADk7nred9JOa29a3fN10Cq1+OlS2o9GsXtpVXUkOk5y5LCMagdwIO05iiW8aOLh6FQJ2u1vK3rAAyJAgv7+62B/TVxql4PEHICln1xi6UhmbgSjzCRuKb+LmlT0kHcQYGMVVsl2FUBQt6297T/y6Ji9P3rcNBgiw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series was prompted by lru_add_drain_all() appearing in watchdog
backtraces: not to blame, but blocked on an unresponsive CPU to run
its workqueue. lru_add_drain_all() is a heavyweight operation, which
we often hope to avoid by a much lighter lru_add_drain(); but even
those local drains can aggravate the lruvec lock contention which
per-cpu fbatches are intended to ease.

Now let the folios on the lru_add and other per-cpu fbatches remain
there, isolatable, with PG_lru set and refcount unraised, just like
when on an actual LRU. Then many calls to lru_add_drain() and _all()
can be removed.

It's something I've wanted to do for years, tried several times, but
only hit on a good way to do it a few weeks ago: now it's uncomfortable
to watch others wrestling with the drainage, while I'm sitting on this.

The key idea came from the "if (!folio_test_clear_lru(folio)) continue;".
If we don't mind missing to take an action on rare occasions, then maybe
we won't mind taking an action on the wrong folio on rare occasions, so
long as it is a folio consenting to PG_lru rules.

No new locking, but relies on folio_try_get() and  folio_test_clear_lru()
even on the lru_add fbatch; with use of bits not set in aligned pointers,
and some try_cmpxchg()ing.  Speculative references to folios are already
accepted: this adds another source of them.

Performance? You (and the bots) tell me. I'm considering this as a
cleanup, to make life easier for developers. I expect that some loads
will show improvement, but also expect some disappointments (perhaps
I go too far against lru_cache_disable()? or not far enough).

The timing is not so good: middle of a merge window is not a great
time to present new work; but I hope to be taking three weeks off in
two weeks time, so best to get this out in the open early, while I can
respond. If it's welcome in principle for 7.4, but too many changes
are demanded, maybe someone else can step up to shepherd it through.

Rebased and retested on Linus's tree of Sunday afternoon,
base-commit: 4352b8aee98005853aa63f57d6377282de17a33f
which includes the mm/swap.c to mm/folio.c renaming,
but not yet David's mods to mm/gup.c which conflict with my 13/25:
I'll reply to that one with an alternate patch to use once David's
two have gone in (reverting both of them and what was there before).

01/25 mm/fbatch: remove !CONFIG_SMP special case of folio_activate()
02/25 mm/fbatch: allow folios_put_refs() to skip xa_is_value() entries
03/25 mm/fbatch: temporarily disable lazyfree and mlock+munlock batching
04/25 mm/fbatch: lru bit set, no extra ref, while folio on per-cpu fbatch
05/25 mm/fbatch: lru_add_del_folio()+folio_add_lru() after clear_lru()
06/25 mm/fbatch: fbatch_drain_lazyfree(onstack fbatch) before ptl unlock
07/25 mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize folio_activate()
08/25 mm/fbatch: replace mlock_new_folio() by __folio_add_lru(,mlockit)
09/25 mm/fbatch: restore mlock+munlock batching, without extra ref
10/25 mm/fbatch: remove several uses of mlock_drain_local()
11/25 mm/fbatch: remove migration's PAGE_WAS_MLOCKED lru_add_drain()
12/25 mm/fbatch: remove percpu_pvec_drained and folios_put()
13/25 mm/fbatch: no lru_add drain to collect_longterm_unpinnable_folios()
14/25 mm/fbatch: no lru_add_drain() nor _all() for memfd_wait_for_pins()
15/25 mm/fbatch: remove shake_folio() shake_page() from memory-failure
16/25 mm/fbatch: remove lru_cache_disable() from NUMA folio migration
17/25 mm/fbatch: no lru_cache_disable() in __alloc_contig_migrate_range()
18/25 mm/fbatch: remove lru_add_drain() and _all() calls from various
19/25 mm/fbatch: vm/stat_refresh include lru_add_drain() on each cpu
20/25 s390/fbatch: no lru_add_drain_all() in s390_wiggle_split_folio()
21/25 block/fbatch: no lru_add_drain_all() in invalidate_bdev()
22/25 fs/fbatch: drop_caches invalidate_bh_lrus() not lru_add_drain_all()
23/25 fs,mm/fbatch: use invalidate_bh_lrus() not invalidate_bh_lrus_cpu()
24/25 fs,mm/fbatch: lru_cache_disable() keep off buffer_head lrus only
25/25 mm/fbatch: move lru_add_drain_all() declaration to mm/internal.h

 Documentation/mm/unevictable-lru.rst |   2 +-
 arch/s390/kernel/uv.c                |   1 -
 block/bdev.c                         |   1 -
 fs/buffer.c                          |  40 +--
 fs/drop_caches.c                     |   4 +-
 include/linux/buffer_head.h          |   8 +-
 include/linux/folio_batch.h          |   7 +-
 include/linux/huge_mm.h              |   6 +-
 include/linux/mm.h                   |  18 --
 include/linux/mm_inline.h            |  22 ++
 include/linux/mm_types.h             |  12 +-
 include/linux/swap.h                 |  14 +-
 mm/compaction.c                      |  25 +-
 mm/fadvise.c                         |  17 +-
 mm/folio.c                           | 375 +++++++++------------------
 mm/gup.c                             |  14 -
 mm/huge_memory.c                     |  16 +-
 mm/hwpoison-inject.c                 |   1 -
 mm/internal.h                        |  15 +-
 mm/khugepaged.c                      |  11 -
 mm/ksm.c                             |  12 -
 mm/madvise.c                         |   9 +-
 mm/memfd.c                           |   6 +-
 mm/memory-failure.c                  |  38 +--
 mm/memory.c                          |  14 +-
 mm/memory_hotplug.c                  |   4 +
 mm/mempolicy.c                       |   7 -
 mm/migrate.c                         |  13 +-
 mm/migrate_device.c                  |   9 -
 mm/mlock.c                           | 192 ++++++--------
 mm/page_alloc.c                      |   3 -
 mm/rmap.c                            |   4 -
 mm/shmem.c                           |   2 -
 mm/truncate.c                        |  17 +-
 mm/vmscan.c                          |  16 +-
 mm/vmstat.c                          |   1 +
 36 files changed, 344 insertions(+), 612 deletions(-)

Hugh

