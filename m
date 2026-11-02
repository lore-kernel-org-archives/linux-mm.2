Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF6D760A2601
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ideasonboard.com header.i=@ideasonboard.com header.a=rsa-sha256 header.s=mail header.b=UHDQAMEo
Received: by kanga.kvack.org (Postfix)
	id 967A56B00EF; Mon,  2 Nov 2026 05:18:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1076B05B1; Mon,  2 Nov 2026 05:18:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8AA6B05B2; Mon,  2 Nov 2026 05:18:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E69C6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:18:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDA4440C83
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:38 +0000 (UTC)
X-FDA: 85389779916.02.0F88C1D
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	by imf20.hostedemail.com (Postfix) with ESMTP id AECAD1C0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ideasonboard.com header.s=mail header.b=UHDQAMEo;
	spf=pass (imf20.hostedemail.com: domain of alen.karnil@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=alen.karnil@ideasonboard.com;
	dmarc=pass (policy=none) header.from=ideasonboard.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lpZ90INeQYUq16dedsAH/Wgug0RqJyGvbXv/2wUWNLQ=;
	b=6E0b2+RmRnY4Rtbkk3+fcoTT8ULkyMMCxBTPoCDw6SP4aJ5DvYM6zcHkowckGVcIFpa9R4
	bTu5igOCsZgrGLHBOG0y9yPA8WNhrX+YzWvz481dL76UfDqjmyYUv4wDSECPHyMobY4Xx+
	yynd6CKs73O3VY277JymW4WtU/WP1uY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ideasonboard.com header.s=mail header.b=UHDQAMEo;
	spf=pass (imf20.hostedemail.com: domain of alen.karnil@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=alen.karnil@ideasonboard.com;
	dmarc=pass (policy=none) header.from=ideasonboard.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614717;
	b=Yv2J6dILNWZb0cJA8OlFYZHU8CvvjY3vMZ/CvUSv7yYTusDvNPO/4GdD3RSjRD0gL5ZsAd
	spJf/kg1FZC5KYgNhmpol2Qm30V73Tnw6q4APRkw2KrckirfxoYx/VPlbgEtJ5eMozJpUC
	7B9YgjrHjcM8EzwPTaZ4YkFV+D/+01Q=
Received: from [192.168.1.71] (cpc89244-aztw30-2-0-cust6594.18-1.cable.virginm.net [86.31.185.195])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id A20FB1F36;
	Mon,  2 Nov 2026 11:16:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1793614577;
	bh=i4PQhdjKinZq1aHIBqDVNrllnVqCCI4FOFkaYs2FB1I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UHDQAMEoN3ahjMwFhp9xcCCmnHShIPMDla/RK7sOLKWo/l09JuTrpD/nykjM2Yy5d
	 LZ1RvHeg8aprTN7yWXFSOFRnm5j8iOy7ZnZkCx6xgtBykkGOZNtDhc4HO3vgIxufXj
	 NzfEOneTxWLWnx9v3f76FtEzKYWB9oZ9klfcabZ0=
Message-ID: <80f858a2-86a1-4b04-abbd-d30463aba1dd@ideasonboard.com>
Date: Mon, 2 Nov 2026 10:18:28 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/26] mm/fbatch: drain lru_add_drain() and _all()
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>,
 JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>,
 Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Content-Language: en-GB
From: Alen Karnil <alen.karnil@ideasonboard.com>
Autocrypt: addr=alen.karnil@ideasonboard.com; keydata=
 xjMEafxhCxYJKwYBBAHaRw8BAQdAXswEEnvxYiHXb8Q8GsSAuaLuXqJFs3kmsMI7EWF9EuDN
 NUFsZW4gS2FybmlsIChXb3JrIElvQikgPGFsZW4ua2FybmlsQGlkZWFzb25ib2FyZC5jb20+
 wpkEExYKAEEWIQT0whyXpTyoVtApVAlRzoJ78NRPngUCagGrrgIbAwUJBaOagAULCQgHAgIi
 AgYVCgkICwIEFgIDAQIeBwIXgAAKCRBRzoJ78NRPnkpDAP4kmtHsMfTtV6BC1z7GTb86BL2g
 9FC1EarGJDDzcafMGQEA6clsoXvRYjHPJexVebjmkI4bq1QM0X/L9Ffe0PfpdQbOOARp/GEL
 EgorBgEEAZdVAQUBAQdAsVoGZ4IK0EgJ8HU05PQKzK15jaCi/IEA/7Cw9ZzcBmwDAQgHwn4E
 GBYKACYWIQT0whyXpTyoVtApVAlRzoJ78NRPngUCafxhCwIbDAUJBaOagAAKCRBRzoJ78NRP
 nqYcAP0eh3LahCDsfNa8zsiK+8QzeujWPKhc5zDcIqrDI6xufwD+Mu9e202It54rNZb8UWEy
 V5OzTEy0JlsQfO6DYWIORwI=
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AECAD1C0005
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 44hyjerg6nixqaapndbc1oahaxnegz39
X-HE-Tag: 1793614716-156213
X-HE-Meta: U2FsdGVkX1+3CWjLOe5yk7awZOe1oX5bHWYjhyMnbgtpf9ST4Wh2YkbS3nnIFXYFemF2fq7wLi0z5upxqFAaKW0UrTP1j60z6+fJA7IWasc+HL5UNdMkewuck0AneKz5q8nhMWnqvI5+NsTmQJyp+dbpTKbNc9sWI3hCF3i4fPYIrQNqVFqJE06uWfHnlFgIbDReORuROGBusEHEo6jA5p57Yw4yoM07K8pkm4M+lv4eouLo/HLzCk34QbqOvtnadcMgLMrd65XzXlQM61fg/zjfnamgs5maSa1r7X39jfz0vyvsER9nAAbHZFFf14EzZR8mRTq7pDZzvtRRg6C7ohEhhm3YDZbgKd/mdkE5hBs8UU87oE7fKmYfrnZB5bMz5Qjijs/cEEIaZRbleKTwEjauahD56A9wRIkxg0dHtTckaoMFQE51YLgRK3kYkUmDs9R4h6WqQMdiRepEW1y6m/zA3rowuUPDIl6lOdGHE2Y/QyEUOqSxyoKv3D/xEFUx8fzQnzHIz5lOIzC2ci7evlo8Ju2GYOF+kNfoPatrQEHPRuPDvSi7GCZdG+9kKCr40XYMPawBGEVjIb4GQ2pd3t/yH7xAPh9JL6v0AOFzl1+9XPn5MCKL63j1dGgtkrJdNy/o0xDYR09SR6wkhgY4emg67oMrswmKb4tHmNtwJJ2eTwctpT7VIr8fqFNQfA9Akbd6gJVlYl3PBuwFMHi6pslOTzo9130enPxk7V0Bmkj1g1TEK0+V1dij4KGzkmIB6HRfHq/IB3u5gn5uT+KSW4LrsZm8rHHShx5CS2I+GI77+HVJXpNaI/X0bjdl6X0NmDyUNkKl0hHtG2FRRyiVNNhIRD2klKdijj8qJglGGg+euuTZs3A7YtuckUjB+XUrYtCs5yX/YTjvCLjKsSq4avuI+qSoOlTZO/rsHSe8D+3Iy3UpBfvOatzSWRu7jcUnSE3uHQwx0MbwlJTW98V
 xrJ352dY
 Hzw/nLzAePdou04wBbLGTKfaP2RNaCsQ5itHBUaGHYxOUj7muP2iRR9f/HD5lrwiA3d3lEeN8fMmUJw/A4inowIQHCBL3+YDs4eKBLT2fTIz+reQSJUjLvHyY50u24Bqpo1tlzPmZzju3zM2TCdLNQfZ7G4yPbkWXdJiT+zJTeCi05HDznxZ6Kmxv5squpVLwcrlkUfA9aEyTKkjpK9va6L6Gk8am9qUhY0EjZutPRRG6TEfiqw05YSHkgbgzorDFxkjNsX2ig50KjxJadBE0PpWaY1WPWb3Wgj1r80D+UVbSujL67Xxr+wC/xqdJN+ePrhbHsgWu9TsHkv2R3mdMja3PyW2AqoM9+B5vdPMHc08nmco3RggiV7CzIz4nE1E7299X1i65/4ZOqn76CKKxtuZtdlswVD7/d4XPfAKOaAGwJ+8QXQVbZXUBDJBM6e1p2M1JVoWxnLHwG2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Hugh,

On 09/09/2026 10:39, Hugh Dickins wrote:
> [PATCH v2 00/26] mm/fbatch: drain lru_add_drain() and _all()
> 
> This series was prompted by lru_add_drain_all() appearing in watchdog
> backtraces: not to blame, but blocked on an unresponsive CPU to run
> its workqueue. lru_add_drain_all() is a heavyweight operation, which
> we often hope to avoid by a much lighter lru_add_drain(); but even
> those local drains can aggravate the lruvec lock contention which
> per-cpu fbatches are intended to ease.
> 
> Now let the folios on the lru_add and other per-cpu fbatches remain
> there, isolatable, with PG_lru set and refcount unraised, just like
> when on an actual LRU. Then many calls to lru_add_drain() and _all()
> can be removed.
> 
> It's something I've wanted to do for years, tried several times, but
> only hit on a good way to do it a few weeks ago: now it's uncomfortable
> to watch others wrestling with the drainage, while I'm sitting on this.
> 
> The key idea came from the "if (!folio_test_clear_lru(folio)) continue;".
> If we don't mind missing to take an action on rare occasions, then maybe
> we won't mind taking an action on the wrong folio on rare occasions, so
> long as it is a folio consenting to PG_lru rules.
> 
> No new locking, but relies on folio_try_get() and folio_test_clear_lru()
> even on the lru_add fbatch; with use of bits not set in aligned pointers,
> and some try_cmpxchg()ing.  Speculative references to folios are already
> accepted: this adds another source of them.
> 
> Performance? You (and the bots) tell me. I'm considering this as a
> cleanup, to make life easier for developers. I expect that some loads
> will show improvement, but also expect some disappointments (perhaps
> I go too far against lru_cache_disable()? or not far enough).
> 
> The timing is not good: I'm taking three weeks off today; but it's best
> to get this out in the open early. If it's welcome in principle for 7.4,
> but changes needed, maybe someone else can step up to shepherd it
> through; otherwise, I can take it up again for 7.5.
> 
> Rebased and retested on Linus's v7.3-rc2 tree, after adding two mm.git
> dependencies which did not get into rc2, but can be expected in rc3:
> Shakeel's "mm/mlock: use the IRQ-safe accessor for NR_MLOCK in
> __munlock_folio()" and Ackerley's "mm/folio: EXPORT_SYMBOL_FOR_KVM(
> lru_cache_drain_for_folio)". Those two are now in mm-hotfixes-stable
> (e14a34548064 and 7891fbb9512f respectively: thanks to Andrew) as of
> mm-everything-2026-09-09-06-32, and the series applied and briefly
> tested over 09-09's earlier mm-everything, so I'm giving a hopeful
> but not entirely honest base-commit below.
Can confirm it cleanly applies and runs on 7.3 
('c03c1a14507dfaf8b856c2608f9ac216021fc222')>
> v1 posted on 24 August had 25 patches, with 26/25 added later:
> Link: https://lore.kernel.org/linux-mm/14a16945-529b-8bc0-ab38-3ea97e54e223@google.com/
> 
> 01/26 mm/fbatch: remove !CONFIG_SMP special case of folio_activate()
>    v2: added Ack from David, R-b Vlastimil
> 02/26 mm/fbatch: allow folios_put_refs() to skip xa_is_value() entries
>    v2: added Ack from David, R-b Vlastimil
> 03/26 mm/fbatch: temporarily disable lazyfree and mlock+munlock batching
>    v2: added R-b Vlastimil
> 04/26 mm/fbatch: lru bit set, no extra ref, while folio on per-cpu fbatch
>    v2: added comment on Bit 1 of page->lru.next per Kiryl and Matthew
>        READ/WRITE_ONCE smp_mb__before_atomic per 07/25 discussion with Kiryl
>        fixed (commented out) BUG_ON in lru_add_del_folio()
> 05/26 mm/fbatch: lru_add_del_folio()+folio_add_lru() after clear_lru()
> 06/26 mm/fbatch: fbatch_drain_lazyfree(onstack fbatch) before ptl unlock
> 07/26 mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize folio_activate()
>    v2: hunk in lru_add_del_folio() updated according to mods in 04/26
> 08/26 mm/fbatch: replace mlock_new_folio() by __folio_add_lru(,mlockit)
>    v2: updated 04/26 Bit 1 comment on folio_add_lru() to __folio_add_lru()
> 09/26 mm/fbatch: restore mlock+munlock batching, without extra ref
>    v2: rediffed around Shakeel's NR_MLOCK fix, fixed unknowingly in v1
> 10/26 mm/fbatch: remove several uses of mlock_drain_local()
> 11/26 mm/fbatch: remove migration's PAGE_WAS_MLOCKED lru_add_drain()
>    v2: conversely, use !folio_evictable() in isolate_migratepages_block()
> 12/26 mm/fbatch: remove percpu_pvec_drained and folios_put()
> 13/26 mm/fbatch: no lru_add drain to collect_longterm_unpinnable_folios()
>    v2: revert David's rc1 lru_cache_drain_for_folio() from mm/folio.c,
>        and Ackerley's EXPORT for KVM; but keep an inline stub in swap.h
> 14/26 mm/fbatch: no lru_add_drain() nor _all() for memfd_wait_for_pins()
> 15/26 mm/fbatch: remove shake_folio() shake_page() from memory-failure
>    v2: added Ack from Miaohe
> 16/26 mm/fbatch: remove lru_cache_disable() from NUMA folio migration
> 17/26 mm/fbatch: no lru_cache_disable() in __alloc_contig_migrate_range()
> 18/26 mm/fbatch: remove lru_add_drain() and _all() calls from various
> 19/26 mm/fbatch: vm/stat_refresh include lru_add_drain() on each cpu
> 20/26 s390/fbatch: no lru_add_drain_all() in s390_wiggle_split_folio()
> 21/26 block/fbatch: no lru_add_drain_all() in invalidate_bdev()
> 22/26 fs/fbatch: drop_caches invalidate_bh_lrus() not lru_add_drain_all()
> 23/26 fs,mm/fbatch: use invalidate_bh_lrus() not invalidate_bh_lrus_cpu()
> 24/26 fs,mm/fbatch: lru_cache_disable() keep off buffer_head lrus only
> 25/26 mm/fbatch: move lru_add_drain_all() declaration to mm/internal.h
> 26/26 mm/fbatch: drop reference inside the loop when draining
> 
>   Documentation/mm/unevictable-lru.rst |   2 +-
>   arch/s390/kernel/uv.c                |   1 -
>   block/bdev.c                         |   1 -
>   fs/buffer.c                          |  40 +--
>   fs/drop_caches.c                     |   4 +-
>   include/linux/buffer_head.h          |   8 +-
>   include/linux/folio_batch.h          |   7 +-
>   include/linux/huge_mm.h              |   6 +-
>   include/linux/mm.h                   |  18 --
>   include/linux/mm_inline.h            |  29 ++
>   include/linux/mm_types.h             |  14 +-
>   include/linux/swap.h                 |  23 +-
>   mm/compaction.c                      |  27 +-
>   mm/fadvise.c                         |  17 +-
>   mm/folio.c                           | 436 +++++++++------------------
>   mm/gup.c                             |   9 -
>   mm/huge_memory.c                     |  16 +-
>   mm/hwpoison-inject.c                 |   1 -
>   mm/internal.h                        |  15 +-
>   mm/khugepaged.c                      |  11 -
>   mm/ksm.c                             |  12 -
>   mm/madvise.c                         |   9 +-
>   mm/memfd.c                           |   6 +-
>   mm/memory-failure.c                  |  38 +--
>   mm/memory.c                          |  14 +-
>   mm/memory_hotplug.c                  |   4 +
>   mm/mempolicy.c                       |   7 -
>   mm/migrate.c                         |  13 +-
>   mm/migrate_device.c                  |   9 -
>   mm/mlock.c                           | 211 +++++++------
>   mm/page_alloc.c                      |   3 -
>   mm/rmap.c                            |   4 -
>   mm/shmem.c                           |   2 -
>   mm/truncate.c                        |  17 +-
>   mm/vmscan.c                          |  16 +-
>   mm/vmstat.c                          |   1 +
>   36 files changed, 388 insertions(+), 663 deletions(-)
> 
> base-commit: 7891fbb9512f127826e1d5dbf380ee212bd15eb0
> 
> Hugh

-- 
Thanks,
Alen Karnil


