Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BDDEF4BB82
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 20:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EBA66B0005; Tue, 24 Feb 2026 15:27:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999686B0089; Tue, 24 Feb 2026 15:27:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B246B008A; Tue, 24 Feb 2026 15:27:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 700E56B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:27:46 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F267B139FED
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:27:45 +0000 (UTC)
X-FDA: 84480486090.12.B4A6E89
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6E52F160005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:27:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QdF5JmcU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=75l70SI6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QdF5JmcU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=75l70SI6;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771964864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOVN9jEJNG7Mu5+kNp6k/MarnsSgkp1B4MAgqDJQnJ8=;
	b=4Ov5lDFPtR8TyOc1nKk+pkcCCFQjqGotzV0rqVOnmOeWIiBPsUr+wJPw0T+yQs6HVv99bk
	Rh2Xwu/aFxvL5zfTt2puu3tOsSCX87oPpMFs3LN1O8m3M+IutZovu5oxpOPHvthA0T6u6G
	DVc8rn/BbLZWhHIx9km5YksfaC9UHU4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QdF5JmcU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=75l70SI6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QdF5JmcU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=75l70SI6;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771964864; a=rsa-sha256;
	cv=none;
	b=LECRCxJ2ePLwYiHqmWMqcULmRTZaJPTArdErw81Au7QVoqRrqKfU57RJUslnWj0Dm9jf2W
	aB77Xp9lNzeX6Am0Bo8+Tm98j9c4d963Wi4Zp13EKwUEN3XOilv6cKoAfH8UwM/xcg2Saw
	e1031sPXPoAaKK6HDYTJYPIc7/5YAx8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F28D15BD46;
	Tue, 24 Feb 2026 20:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771964861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OOVN9jEJNG7Mu5+kNp6k/MarnsSgkp1B4MAgqDJQnJ8=;
	b=QdF5JmcUywI6HU7zFokoNIDQjCsB+1OwTPucjKQFk/BZSdXPofHgdFS5rAyOWm/p8W2hJA
	FaJynrYMipbSNsw/YCXU/YuPNUOZx2mSASkLd33AESFQ5U/L5Y9D1p9/B187nPMjoj5HTZ
	2ebz/EIO1pjnlLVrJW8HBxM/2+hUODE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771964861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OOVN9jEJNG7Mu5+kNp6k/MarnsSgkp1B4MAgqDJQnJ8=;
	b=75l70SI6C5oE+J0ydi240x4Sxub2GMjdw/ByHj7pI9QFRaA5L9CxDZhnF+Zj9uswAGGaMV
	ynI7VFhcPiaKsNBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771964861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OOVN9jEJNG7Mu5+kNp6k/MarnsSgkp1B4MAgqDJQnJ8=;
	b=QdF5JmcUywI6HU7zFokoNIDQjCsB+1OwTPucjKQFk/BZSdXPofHgdFS5rAyOWm/p8W2hJA
	FaJynrYMipbSNsw/YCXU/YuPNUOZx2mSASkLd33AESFQ5U/L5Y9D1p9/B187nPMjoj5HTZ
	2ebz/EIO1pjnlLVrJW8HBxM/2+hUODE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771964861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OOVN9jEJNG7Mu5+kNp6k/MarnsSgkp1B4MAgqDJQnJ8=;
	b=75l70SI6C5oE+J0ydi240x4Sxub2GMjdw/ByHj7pI9QFRaA5L9CxDZhnF+Zj9uswAGGaMV
	ynI7VFhcPiaKsNBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA1C73EA68;
	Tue, 24 Feb 2026 20:27:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o9XjMLwJnmkNRAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 24 Feb 2026 20:27:40 +0000
Message-ID: <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
Date: Tue, 24 Feb 2026 21:27:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
To: Ming Lei <ming.lei@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>, Christoph Hellwig <hch@infradead.org>
References: <aZ0SbIqaIkwoW2mB@fedora>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <aZ0SbIqaIkwoW2mB@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: 5xqyfcuwds4rwyhbf19j4k1s5mk71tfq
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E52F160005
X-HE-Tag: 1771964863-177077
X-HE-Meta: U2FsdGVkX19CFgQx/2gqq6Q5S6vDrv5guY4t96vbySYIrL59Ao9bYIVjMgCVsAEDtD2RqNcOvzSp4gDzyeqRPlj/b36XsXX4cnK3Yd5EJNx6edhUoZ40+ybu9rzWQ58lvMVhjqSd7dL4ki8kPIcEENQk3bwQRR/geL0Ft6sNYBw0LRtZNRCkCFtRh8lXMr14sBUYcqu+oqUy7eT/58clok/SWKRLTq0wInESV6LJv+OJeu4PEDlE5bMK8FmO18LcckU4fI3HDK+xxxo3GZhwcByjMWc8MyWwHj/EFY6l6XXJyAxv447W0nXn5K17aOI1Bq71We6Wn+etnCd7aOSTpc6pA4xTJA9sozwIwDU9aC2HB4sKlzQvTxq1pINc04g/lWwriO6fCWyUzF6H+kzi3YOZIxrw/ykMnopmre5AQaXebB19EGEJsFP6DDGaCtDJnDrSi8lfJZYEpDIUh8K2MVwf79h4Mw7ZiIqnUxtGCaY8+xKftRLZLr9wP5rynLxN4zB/DTy/vGGdT+4bYKaqaP6yCAjyw4lJr3W1jhX+At4poQ9iK/minAPidHK7uSekd+9PeBve5inRQdfhqlBMjx9c5v4VHiWKZvFvoSY6y+j+r7hPj8NFKJMnrjt2JhPX8CSFHzyXOTHQSLPnXXVVTU51DL5jaqdbUenosmEBsw1fQWXbm89lBH3WAWRzFv9LufUYrQNjrFR6wK/iBetsMLkWlMOzqAda78MvCE870DEjiYxbYTgaQ2l14cO804RLu9U/U3Cc4XYSgm56klyti/GguhBCeuv0KJvI5K8xeJB74GQPgjYYqns7HzmN43B+bctb/065VizMqiZqYWVp+tBg8EiKKoSwqfb7r387PkChSVNqoyzN1sBHTt1UglfMrLdJg4XCmu8DvAl0y/6T1RmTQbkPtYy5wuCdUTDXCVVR6nzUhYPl2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 3:52 AM, Ming Lei wrote:
> Hello Vlastimil and MM guys,
> 
> The SLUB "sheaves" series merged via 815c8e35511d ("Merge branch
> 'slab/for-7.0/sheaves' into slab/for-next") introduces a severe
> performance regression for workloads with persistent cross-CPU
> alloc/free patterns. ublk null target benchmark IOPS drops
> significantly compared to v6.19: from ~36M IOPS to ~13M IOPS (~64%
> drop).
> 
> Bisecting within the sheaves series is blocked by a kernel panic at
> 17c38c88294d ("slab: remove cpu (partial) slabs usage from allocation
> paths"), so the exact first bad commit could not be identified.
> 
> Reproducer
> ==========
> 
> Hardware: NUMA machine with >= 32 CPUs
> Kernel:   v7.0-rc (with slab/for-7.0/sheaves merged)
> 
>     # build kublk selftest
>     make -C tools/testing/selftests/ublk/
> 
>     # create ublk null target device with 16 queues
>     tools/testing/selftests/ublk/kublk add -t null -q 16
> 
>     # run fio/t/io_uring benchmark: 16 jobs, 20 seconds, non-polled
>     taskset -c 0-31 fio/t/io_uring -p0 -n 16 -r 20 /dev/ublkb0
> 
>     # cleanup
>     tools/testing/selftests/ublk/kublk del -n 0
> 
> Good: v6.19 (and 41f1a08645ab, the mainline parent of the slab merge)
> Bad:  815c8e35511d (Merge branch 'slab/for-7.0/sheaves' into slab/for-next)
> 
> perf profile (bad kernel)
> =========================
> 
> ~47% of CPU time is spent in bio allocation hitting the SLUB slow path,
> with massive spinlock contention on the node partial list lock:
> 
> +   47.65%     1.21%  io_uring  [k] bio_alloc_bioset
> -   44.87%     0.45%  io_uring  [k] kmem_cache_alloc_noprof
>    - 44.41% kmem_cache_alloc_noprof
>       - 43.89% ___slab_alloc
>          + 41.16% get_from_any_partial

So this function is not used in the sheaf refill path, but in the
fallback slowpath when alloc_from_pcs() fastpath fails.

>            0.91% get_from_partial_node
>          + 0.87% alloc_from_new_slab
>          + 0.65% allocate_slab
> -   44.70%     0.21%  io_uring  [k] mempool_alloc_noprof
>    - 44.49% mempool_alloc_noprof
>       - 44.43% kmem_cache_alloc_noprof

And I'd guess alloc_from_pcs() fails because in
__pcs_replace_empty_main() we have gfpflags_allow_blocking() false,
because mempool_alloc_noprof() tries the first attempt without
__GFP_DIRECT_RECLAIM. So that will succeed, but we end up relying on the
slowpath all the time and performance will drop.

It made sense to me not to refill sheaves when we can't reclaim, but I
didn't anticipate this interaction with mempools. We could change them
but there might be others using a similar pattern. Maybe it would be for
the best to just drop that heuristic from __pcs_replace_empty_main()
(but carefully as some deadlock avoidance depends on it, we might need
to e.g. replace it with gfpflags_allow_spinning()). I'll send a patch
tomorrow to test this theory, unless someone beats me to it (feel free to).

Until then IMHO we can dismiss the AI explanation and also the
insufficient sheaf capacity theories.

>          - 43.90% ___slab_alloc
>             + 41.18% get_from_any_partial
>               0.90% get_from_partial_node
>             + 0.87% alloc_from_new_slab
>             + 0.65% allocate_slab
> +   41.23%     0.10%  io_uring  [k] get_from_any_partial
> +   40.82%     0.48%  io_uring  [k] __raw_spin_lock_irqsave
> -   40.75%     0.20%  io_uring  [k] get_from_partial_node
>    - 40.56% get_from_partial_node
>       - 38.83% __raw_spin_lock_irqsave
>            38.65% native_queued_spin_lock_slowpath
> 
> Analysis
> ========
> 
> The ublk null target workload exposes a cross-CPU slab allocation
> pattern: bios are allocated on the io_uring submitter CPU during block
> layer submission, but freed on a different CPU — the ublk daemon thread
> that runs the completion via io_uring_cmd_complete_in_task() task work.
> And the completion CPU stays in same LLC or numa node with submission CPU.
> 
> This cross-CPU alloc/free pattern is not unique to ublk. The block
> layer's default rq_affinity=1 setting completes requests on a CPU
> sharing LLC with the submission CPU, which similarly causes bio freeing
> on a different CPU than allocation. The ublk null target simply makes
> this pattern more pronounced and measurable because all overhead is in
> the bio alloc/free path with no actual I/O.
> 
> **The following is from AI, just for reference**
> 
> The result is that the allocating CPU's per-CPU slab caches are
> continuously drained without being replenished by local frees. The bio
> layer's own per-CPU cache (bio_alloc_cache) suffers the same mismatch:
> freed bios go to the completion CPU's cache via bio_put_percpu_cache(),
> leaving the submitter CPUs' caches empty and falling through to
> mempool_alloc() -> kmem_cache_alloc() -> SLUB slow path.
> 
> In v6.19, SLUB handled this with a 3-tier allocation hierarchy:
> 
>   Tier 1: CPU slab freelist         lock-free (cmpxchg)
>   Tier 2: CPU partial slab list     lock-free (per-CPU local_lock)
>   Tier 3: Node partial list         kmem_cache_node->list_lock
> 
> The CPU partial slab list (Tier 2) was the critical buffer. It was
> populated during __slab_free() -> put_cpu_partial() and provided a
> lock-free pool of partial slabs per CPU. Even when the CPU slab was
> exhausted, the CPU partial list could supply more slabs without
> touching any shared lock.
> 
> The sheaves architecture replaces this with a 2-tier hierarchy:
> 
>   Tier 1: Per-CPU sheaf             lock-free (local_lock)
>   Tier 2: Node partial list         kmem_cache_node->list_lock
> 
> The intermediate lock-free tier is gone. When the per-CPU sheaf is
> empty and the spare sheaf is also empty, every refill must go through
> the node partial list, requiring kmem_cache_node->list_lock. With 16
> CPUs simultaneously allocating bios and all hitting empty sheaves, this
> creates a thundering herd on the node list_lock.
> 
> When the local node's partial list is also depleted (objects freed on
> remote nodes accumulate there instead), get_from_any_partial() kicks in
> to search other NUMA nodes, compounding the contention with cross-NUMA
> list_lock acquisition — explaining the 41% in get_from_any_partial ->
> native_queued_spin_lock_slowpath seen in the profile.
> 
> The mitigation in 40fd0acc45d0 ("slub: avoid list_lock contention from
> __refill_objects_any()") uses spin_trylock for cross-NUMA refill, but
> does not address the fundamental architectural issue: the missing
> lock-free intermediate caching tier that the CPU partial list provided.
> 
> Thanks,
> Ming
> 


