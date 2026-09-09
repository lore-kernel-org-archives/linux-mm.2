Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F34D8C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39106B0096; Wed,  9 Sep 2026 05:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0FC96B0098; Wed,  9 Sep 2026 05:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE886B0099; Wed,  9 Sep 2026 05:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD6DA6B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:39:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF923A016E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:39:29 +0000 (UTC)
X-FDA: 85193726058.22.01AA3AE
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3538C100004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:39:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lnHvTnRL;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788946768;
	b=spt47RFi3ew6P1XmnMJrghYLHO+CUEhF4Z/rNAwW+I3Q74EafTzQceR80iOfaGpbpgWB5R
	8M2DLMC0U1y0tp+V8/vq0ggL23UjWspdmvASyqpPv2fV+8ZgjiD5jUA4vujrN+BLWL+EKF
	MxdyDzae7zyyPH+dFMf9QXjyUsHVV4w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lnHvTnRL;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788946768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0zuAVjWjM0/S4ZIDkng7bHRKao4SeQxFnkO87c7tfhg=;
	b=woschnz2KX5HJEJAb95ArKbVi5BQaxLnL6OxyccW8CBzJxZjEZYvLHhTDXjnTQJOPHg4aW
	LpZreXA4dqa6o8E0wCojOYyzT9F7l36YkW2DCcaL7A57mdjtYEiyLAKPge3oSM1AkgtNN4
	2ZpVPs8Xy0Cu7cCzH7f9oPES0AuIcHM=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8565d77c277so73121707b3.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 02:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788946767; x=1789551567; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0zuAVjWjM0/S4ZIDkng7bHRKao4SeQxFnkO87c7tfhg=;
        b=lnHvTnRLCx7GLZWQdf65Moztk9v5c7qpwiqXeREJt2Ih16bQG9MrdEaYIOlNNuFyXK
         ijX8muxqff4aeg7UdrRukNldcsnmadfyhm1/PUODDkL4JZvko/15uHagchkJ87b1rbCe
         WquiCbbqklbjL6DzPbTIQRE1mM8NqF/ItUSDge/b8zI5jzNa5bUlAmSSTn/Dxaqcbr+P
         XySBMZ+btcidb7Nsua/TQ3yS3mRrEBNU2SNbZi54z60sXgGUju7m5f5V4CbKPIVrBVnN
         W1Dd+N35zhnhaOi6pymVik2WqqTELjJvmR8PnzJE0Eh3ddfZ5Fj51CDyKpJmdJPkZ/+1
         +Teg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788946767; x=1789551567;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0zuAVjWjM0/S4ZIDkng7bHRKao4SeQxFnkO87c7tfhg=;
        b=G9D3kE+k3GS9q1vVuyB6/8QhaCSzhH0IiIbLG5FISiBoSGvr3F3fWxvQvvCOuTXkky
         BS0wXIkrT3VPc7xLmqMyofDMuE9ruUDwMILeEzQbYau7Z4ym7xjcH43Zn4jEGt2KmML6
         2eZebD4CPCdCo4MPPn1YKjEdSFN4QkXkrlNNrkW17FdYirl7wE92ZkXjnRr1LNf+sKJX
         e9/5MvMtVwDb7h8PjxDjMahg0NjNbpvCRSUPPJnx5tSYAlDW/uoXrcjPP8GkbxStn5gA
         8Y19L0SQscwA6suw7JbJz+Vp2LczBHL/QMiECjqn5XxTxT7ACOprMtj41ss+zd2xdUu8
         lMnw==
X-Forwarded-Encrypted: i=1; AKwUvBx/sESWPSu9NjiPnqUF5XAJGHam8NFlVFCfl1XlLalVEt3Jj6k70rmJyseizJEcffVXyiiLsbMLtg==@kvack.org
X-Gm-Message-State: AFuF++kICbhTybavKt50wmZnZgWCVcjEhseaK8jNduAd/E51vEq3itSB
	1GxKHpuP1AweQGL7yU0tCxmtbAj7u5sOcUAZGVOO1948u3utNlbzRMAw8zvUeANbDA==
X-Gm-Gg: AYBFou2/QCVpnUHyieE5sXy0hw5Z3cF/1lo38tqDZYXVlb/ctcGbNuBUyjXP+r0wEPQ
	7AC3zI3J7iA4KxKhLY9m4v39IlIRTbsZMzdVDCTIi0WviOLbNYsmJ2+wo2/+BSgcw7Uk/lVwdty
	tQ6xZBei/iXAcVW7t8BkuYtl4y8/Njn+4Fe7uSq2yB6Y8mK4qwsLhmKhqIq7ojYd8OViKsHaRwm
	F2Y3B93e+EBX4fJkm8u4eFNMWPURhjrEeh0IOm3IOFJKncAafSOIsEjBy+JnT+ZFJS7DcoRTI7G
	5BlOSIFqPT7OHVWAFLoLQ+i0qWFUly+B3o4LJ6JBy2YUAL304vbZB8+94l8Dqx/cJMBeh2rB+uu
	oBo07e0EopuqpNfLNc8vYwVpDDZSLYtxPA9+e8s8XjtPFBMQ5ksxOsmGp76HQ31Dn/EMMStdp29
	y0CgqcuByxwHFnXYnmTjpHFRqfoUH8wyRKB3fyLBOFzAHxfvXD/PM801pW36eFoGrrGx3ElQ94M
	N7Jezs7EeBpvYl89mezn0yuEv/tmkXMFAet/wCsrzc1hAugIhGlcpVxzrE=
X-Received: by 2002:a05:690c:d84:b0:870:96e4:6709 with SMTP id 00721157ae682-87122985ba4mr131380887b3.9.1788946766316;
        Wed, 09 Sep 2026 02:39:26 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-87149316347sm108893927b3.15.2026.09.09.02.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 02:39:25 -0700 (PDT)
Date: Wed, 9 Sep 2026 02:39:08 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
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
Subject: [PATCH v2 00/26] mm/fbatch: drain lru_add_drain() and _all()
Message-ID: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3538C100004
X-Rspam-User: 
X-Stat-Signature: 3s5dq5u5q9azzgnnz6k3y75yrahmmhyg
X-HE-Tag: 1788946768-855070
X-HE-Meta: U2FsdGVkX19TPbpKjg5hkLYZa2yanmDc0ZC6jmkpzSHD5LsVJc2LxLJadT/ETHFfiJhVFY+JoryWhTRyqF1A6Bf+v7uskVcmS4CXrBw2ldyRrxLeCF86PnPhkcKRZgictErmt3gv3Pgk2CC2RxV66cyu1v1tH/YUwPH0HwFkzOIx3pqEq+Bp6UecxsWG2EI77CgkRSbmFdav5j1c5WRNk+uPe25DVOc0KlTr7bi4Ly1EQNkHx1H/DQVNNkpTIibTnjG1x5dyrNrIDLu7lrJ7iOEk2//87spulRuslcQ5PNRJ2M9wPaIT45S9F89kEvev714+k0Mb6tTIqOcNSbiMuOg2IORrZKGGFjfEfhRCVWWBVPTc7V9ItZcU64JkXx9gb0CKnywvMaPEgCQOar14O56gBrfb+y8WgvL1f33Xtn/lr2DRJwI8i3+x99zf5OQpjNyFFitbgvdlFERldSY3FbgcK9hvmc2xW10LnAwsV0JS1MXZBtlDiNXMoByHwaMoocm23a/4065zlbX5PKaw+rRdyDYItIW1ZqzS1CXhHqQJulUSOdfg7N89GAlwvt27Fos50du2Xm3L0JNzFk6eFIAuSycE1ez8zKsZJ7oYqANG4Xt4LJf6GvWj0Rk4tWE7g56MhZ+r/WayekD4wn2BChJdLO+4SO6sccaIxosWh0fb83Ofm7FIJVXQhn1+owOa2uipvs7CN11LuTy7BaUCE05WO1f8pEmFXmYtt8WPkoT2hDaMK3MUQ8nN0iLHH7kZ5klO/2HW1hRfYHs5wvcsx324betyP9lPVSd6JCynIGnNAqBs+rSgp44vimgV0HGj14kQsim4H1sj0K3cxe3OETiMYMioq3dPrR1Z5ANm9iGVjpvgWadGd15EpUdnuNbKIt8yC+lcNIO3I11o+eQ7BT3/gnH60KPIw6iroDM+ZgtAngK23vwjzUTVP16FUOf+huMluMHmL2moXIvl7D5
 o9PCHOCi
 APXk/YN8z+Ts9sAEDoCWYxZunCjnbT7rkmoqeIcrKKWVoQsixtErq+bB+xl42oYXf5/gL8IhfsIRSzCkZUMFmT3y8mb9RwNeX0bH9FJRloGFi9wMaBViUChYmjxtt4jtL5c/LNUVfJYDmUykNVAetlJpTKANyr6cdK608duet/ki0Z73GPaFwKKYgSCUJLGdynRaMMf4PjOtxKQ5ulEdAKDYpBQ5Rp0GGjvAK8iMYzz/e6Izp9hOdy3dKF+DM6NS3eKKwol3aKct7Anoog29Sza7/c/ue391DyqlnziacPGsu0i4uqUpw4fg+YzKr2wT+w52lAq6Oq4s/A+27SIdHyx5ouM+AE1ds/89M3nW7rw3N8oowGlE7ONwQ+3RWlf+zfoFhzWrnv3UszJMf0eUycXiy53ucYdYkkrVYWsa6FuCynGLDwDlPlWwG+0T82QrSsfsS7ttSBHWRMyyjpV+692i7NbNBhbFnFTktNgy1Q6Jm0JvhS3+VWSIRbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[PATCH v2 00/26] mm/fbatch: drain lru_add_drain() and _all()

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

No new locking, but relies on folio_try_get() and folio_test_clear_lru()
even on the lru_add fbatch; with use of bits not set in aligned pointers,
and some try_cmpxchg()ing.  Speculative references to folios are already
accepted: this adds another source of them.

Performance? You (and the bots) tell me. I'm considering this as a
cleanup, to make life easier for developers. I expect that some loads
will show improvement, but also expect some disappointments (perhaps
I go too far against lru_cache_disable()? or not far enough).

The timing is not good: I'm taking three weeks off today; but it's best
to get this out in the open early. If it's welcome in principle for 7.4,
but changes needed, maybe someone else can step up to shepherd it
through; otherwise, I can take it up again for 7.5.

Rebased and retested on Linus's v7.3-rc2 tree, after adding two mm.git
dependencies which did not get into rc2, but can be expected in rc3:
Shakeel's "mm/mlock: use the IRQ-safe accessor for NR_MLOCK in
__munlock_folio()" and Ackerley's "mm/folio: EXPORT_SYMBOL_FOR_KVM(
lru_cache_drain_for_folio)". Those two are now in mm-hotfixes-stable
(e14a34548064 and 7891fbb9512f respectively: thanks to Andrew) as of
mm-everything-2026-09-09-06-32, and the series applied and briefly
tested over 09-09's earlier mm-everything, so I'm giving a hopeful
but not entirely honest base-commit below.

v1 posted on 24 August had 25 patches, with 26/25 added later:
Link: https://lore.kernel.org/linux-mm/14a16945-529b-8bc0-ab38-3ea97e54e223@google.com/

01/26 mm/fbatch: remove !CONFIG_SMP special case of folio_activate()
  v2: added Ack from David, R-b Vlastimil
02/26 mm/fbatch: allow folios_put_refs() to skip xa_is_value() entries
  v2: added Ack from David, R-b Vlastimil
03/26 mm/fbatch: temporarily disable lazyfree and mlock+munlock batching
  v2: added R-b Vlastimil
04/26 mm/fbatch: lru bit set, no extra ref, while folio on per-cpu fbatch
  v2: added comment on Bit 1 of page->lru.next per Kiryl and Matthew
      READ/WRITE_ONCE smp_mb__before_atomic per 07/25 discussion with Kiryl
      fixed (commented out) BUG_ON in lru_add_del_folio()
05/26 mm/fbatch: lru_add_del_folio()+folio_add_lru() after clear_lru()
06/26 mm/fbatch: fbatch_drain_lazyfree(onstack fbatch) before ptl unlock
07/26 mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize folio_activate()
  v2: hunk in lru_add_del_folio() updated according to mods in 04/26
08/26 mm/fbatch: replace mlock_new_folio() by __folio_add_lru(,mlockit)
  v2: updated 04/26 Bit 1 comment on folio_add_lru() to __folio_add_lru()
09/26 mm/fbatch: restore mlock+munlock batching, without extra ref
  v2: rediffed around Shakeel's NR_MLOCK fix, fixed unknowingly in v1
10/26 mm/fbatch: remove several uses of mlock_drain_local()
11/26 mm/fbatch: remove migration's PAGE_WAS_MLOCKED lru_add_drain()
  v2: conversely, use !folio_evictable() in isolate_migratepages_block()
12/26 mm/fbatch: remove percpu_pvec_drained and folios_put()
13/26 mm/fbatch: no lru_add drain to collect_longterm_unpinnable_folios()
  v2: revert David's rc1 lru_cache_drain_for_folio() from mm/folio.c,
      and Ackerley's EXPORT for KVM; but keep an inline stub in swap.h
14/26 mm/fbatch: no lru_add_drain() nor _all() for memfd_wait_for_pins()
15/26 mm/fbatch: remove shake_folio() shake_page() from memory-failure
  v2: added Ack from Miaohe
16/26 mm/fbatch: remove lru_cache_disable() from NUMA folio migration
17/26 mm/fbatch: no lru_cache_disable() in __alloc_contig_migrate_range()
18/26 mm/fbatch: remove lru_add_drain() and _all() calls from various
19/26 mm/fbatch: vm/stat_refresh include lru_add_drain() on each cpu
20/26 s390/fbatch: no lru_add_drain_all() in s390_wiggle_split_folio()
21/26 block/fbatch: no lru_add_drain_all() in invalidate_bdev()
22/26 fs/fbatch: drop_caches invalidate_bh_lrus() not lru_add_drain_all()
23/26 fs,mm/fbatch: use invalidate_bh_lrus() not invalidate_bh_lrus_cpu()
24/26 fs,mm/fbatch: lru_cache_disable() keep off buffer_head lrus only
25/26 mm/fbatch: move lru_add_drain_all() declaration to mm/internal.h
26/26 mm/fbatch: drop reference inside the loop when draining

 Documentation/mm/unevictable-lru.rst |   2 +-
 arch/s390/kernel/uv.c                |   1 -
 block/bdev.c                         |   1 -
 fs/buffer.c                          |  40 +--
 fs/drop_caches.c                     |   4 +-
 include/linux/buffer_head.h          |   8 +-
 include/linux/folio_batch.h          |   7 +-
 include/linux/huge_mm.h              |   6 +-
 include/linux/mm.h                   |  18 --
 include/linux/mm_inline.h            |  29 ++
 include/linux/mm_types.h             |  14 +-
 include/linux/swap.h                 |  23 +-
 mm/compaction.c                      |  27 +-
 mm/fadvise.c                         |  17 +-
 mm/folio.c                           | 436 +++++++++------------------
 mm/gup.c                             |   9 -
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
 mm/mlock.c                           | 211 +++++++------
 mm/page_alloc.c                      |   3 -
 mm/rmap.c                            |   4 -
 mm/shmem.c                           |   2 -
 mm/truncate.c                        |  17 +-
 mm/vmscan.c                          |  16 +-
 mm/vmstat.c                          |   1 +
 36 files changed, 388 insertions(+), 663 deletions(-)

base-commit: 7891fbb9512f127826e1d5dbf380ee212bd15eb0

Hugh

