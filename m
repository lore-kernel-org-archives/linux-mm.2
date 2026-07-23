Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A24BC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 20:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4E06B008A; Thu, 23 Jul 2026 16:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255B86B008C; Thu, 23 Jul 2026 16:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145F66B0092; Thu, 23 Jul 2026 16:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCF0C6B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:25:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 482A61C0110
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:25:44 +0000 (UTC)
X-FDA: 85021172208.11.C0091E2
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2752C0011
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:25:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=NY6399Bg;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784838342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IFF4yQtEVs6i5fdto4RrDVs1x4A+ievAa0eCNbUcchk=;
	b=bkkcIkKoaL4G10UQ5WC0n6UDcnQt1HDppv3mZpts2reVPnWFrCJgIZkb9XixgUm26vqGiY
	Wuh3yEHQ9W3JFIx1eEO7Ct9C4lMcBraAzLhiTVfxORxmeZUCE8IKIxVyhSuUuC4fvnQR43
	MeNcU40la+DsC15uNXT3RsVOj3QKzTQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784838342;
	b=iwdLRFSy4+0ZzFCX23LsFyyUIpVzRk1gevhByUhdazHkoN1MHY9hD3k1d++6kcpXXKKxVu
	7fkIqAVM22VO2ZjkxRwT23OcKLXX+6Lhkg+z4tT1kt+n2S7syeCHTv+gub69A6jm2TJHSE
	PGntm7GlRqY99PYs3YYgN2gQ9zBlNGg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=NY6399Bg;
	spf=pass (imf28.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e5b048375so89487685a.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784838341; x=1785443141; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IFF4yQtEVs6i5fdto4RrDVs1x4A+ievAa0eCNbUcchk=;
        b=NY6399BgBsrU2YinRJ2Rd4ySfVkz/3oDgNXxcUGbSmL87DnkYOkaO6LQwxcFrKGRbW
         TqGxm7PdjGC/QdLMyjXw+a0oSl15j6Iymin9/8eHV+wBoSppsG2i9Wzrvd/zMldbdK5Y
         eKNc/EZT24VwRBfM4I+HpQWlsIr8JR53Pz2teXivKtj4xgsKke9oVQm6juFP3rFfVxai
         f6knaQRYtDsESHsPkENI5RtAuPrJ+U9IY8XO8m/D0CyELw3GXWqvK2PCdwV6GncAxqUP
         H5jlaufruh4ZxX5xlgddMPbBp70zJR+sXOcSgl1LbVLbp0HnjQn8JX0A4OvmFTB3BhXk
         9x8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784838341; x=1785443141;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IFF4yQtEVs6i5fdto4RrDVs1x4A+ievAa0eCNbUcchk=;
        b=XwvDymSSqG2Prd0YnQTzMfF4Xz4cyI+3txgDfiTJ+byJNqqeUISxd0UMEXuXkWPYbc
         ZK6bnBhSbyaB48v7h9SdZO65DG4JyjXPfFHwKtEDWoQ47NzRfuyZjpPf1UILuuYvzkyw
         JG7sgmYUJ0JmfpMI1vWNwQkyi1uQyyCrtFMEeg4rZxwNNmHKkQyw+5XTChZzo0L4+yNM
         Nfa2i310IWMsT61Ou07o9bErUUlfzewWdoMVc/v+xsG0dxDr8/jMQggTb2SGN95Xe+ER
         pkMvzKfyZHm+U3KnI9HDDVWliM6iPWKMX/jVO00/kXZg1k7b9IKu6/Vq6hIzncVCQg80
         W3kg==
X-Forwarded-Encrypted: i=1; AHgh+Rox2J3cgw8Qw7+8nsXtp5qYpnjbAlH7MAGsSkbil2i5E7Tn5AVgbAi5wkUiHUbTNElLO6T1RZVKuw==@kvack.org
X-Gm-Message-State: AOJu0YwkeosJ4l56NnMvlGe4WT769XAWRlkrjAby4FRQAfxJXezuLtT8
	Ca/1lfqpp2UqMmy4vpsihkaSWqX+923SmY5igIVaLtf8wyy7O4FY4YVGbuqZUuvfK2E=
X-Gm-Gg: AR+sD12We2JCljHir+DIwp/SlcUEdmcPV4hcJUIZfIfbepefOC1wgT2sJP1Mlz7IWN1
	asm+plSedNqyPgfmScv+cr/fUdq3LaULN81+9LFvXKh1DdUGmQ8kEcUwwaYnUB3GOnEK9no3DkP
	yW090BLEp7G0neypsWvuCw0Du+0ykkBT054cuoHSwa2InKUKoloLCWf1bBdepst2o3dvLpWvP0i
	m77OXFCwP0HcxZ6+68nyU1wx+2zOWSV66V8zUNptpVbReRPobv1gRt7ju4wc1weR00Rro543Tbe
	/4VsgUWESSVvFJwQOmkiSU62fqbgqHpAvMQgPHSVRziPEg3CbImBIrhTNTBRHfsYJrSGgkuJyTB
	Vi+QmuduvmsPTCuSXpIQbMi6zgsO99WFMeXG4OztXyWoI+Pr5yp0pZ97MjgroqAlje2cUAVDnRv
	nG
X-Received: by 2002:a05:620a:4550:b0:931:3d2:6fd with SMTP id af79cd13be357-93103d226f4mr481862985a.43.1784838340842;
        Thu, 23 Jul 2026 13:25:40 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f6a0ab39sm506266585a.26.2026.07.23.13.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:25:39 -0700 (PDT)
Date: Thu, 23 Jul 2026 16:25:35 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
	youngjun.park@lge.com, roman.gushchin@linux.dev,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <amJ4v3QD2wym14ap@cmpxchg.org>
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260720164207.450685-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720164207.450685-3-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E2752C0011
X-Stat-Signature: chshz9npnomnu857wnagdmdnkjbma5xy
X-HE-Tag: 1784838341-581354
X-HE-Meta: U2FsdGVkX18YUFARpmlUor4TvveoAlZTHZBIWweS9sPSvRswapUkM2kOGrfl7zkkrkVD2ZcPvVqVqtTv5v0RK7GPV+K3qRnsrhPFE177ozL+3TqCRNTkLOcroTBtHuGzLKyXhKQChmNpCDkgFrMvwYq6LAgeUo0NmiTPL4U72LtNRliOfjoAVuVq1jv8jGyYVqwgsDHptjrfwAlbKDNXK3+vF6y359azDZX291mfWyF0QV7O/BHQB8BMcxc8/BdBIimruOIFy3EI/rgUlmsQDkrEd2kZWKCm8eMIUVEM32yQUpd8aaQUNTdyswdL3UxjZ+8ICHNHdxLoveg3Sjp+msLS8o8KTmzVOQU8xm17hewNT6rD400Nfs839Y1XXFG408FvzvsDb04eK86WKEIL+5xD3zqJGaZOxuuhj/eJPrVftzDdqf0l9yXJJNfaKLGWrvPTkQCOe3E4S/CMSqsptQj1AehA/jueNAiaQIPkG05j4t34FauOs2AqD/FL6ky8DHFJp0e0QBa1TFXZSsZmA28r21lk4GmRnXy6aM2zze0heal83LgdFcHgQzZOAjczQbG9UNirFSNi8iHWMiBSZVgx9qVavYpkhsQvPl4QMrTDL96ofC0URj3iF47WY0o4d2V3pUCDhKqW73qekRRrSBNf7FWw9KGBEv8WEcbbkVB5X8FPt4hD085iDYpuAyFkoiBIrJ/5g5eCjiAsXAm3r4J2FwWuQGgrhKbuHqQYlojOF/9UUGuFhht3V4acHtpMDRkb6fbUxtYzMjmHgPviwU/y2qCFPrlLxXuDxtsCbvpB28Det4Lk+zjUVTiwDZOHOM2ohbuWdSt3I899JB5EQ1khLDcT3IXByZlZqZf0VbdXMreneqkJJqt6G3AQ8gOR3wPO2fPN7ULX+/i6PKiTTIJGDi4f3WpCV6sivmg8RP0ctuNx1t8UpMi64YwfnLTt/Wz3L664lL2EN9jCq0Y
 hXYy++6G
 sVi4n/rtOgfza7nCz/dPTWw7vipiKyTGvNnyV7p3m7gvkTzYcr0bHeNMIcIUOuc8mudDijVD6HPXQnZ1PHeAW+Jq1C+UdDwWio0GB4/ILJeoMfgLtbkKGNNIrTGZoi5lSFfENdHA4ydlh5tyczQeq2BeADhATuF6m7hCsP6XTp8TMVFqXYVR63wDF5Okh6AOOel+/rrqpULRQNNRbyVRYvU8ZLzQ39ktywDAE1OfNU+MXlMz2+LvHr9MDnpr0JmLR7JMeqGQkM1by0gyocuksg6h2ODlL9tVRsIT7bi18hFSL0TeNjpBOPkt3ww3v3EL4bx9SfAEle76mQxAymCIl53agwU00yan/h7q5ZHQ69JijNzpjBl+xUgOUANG5Fn+acprQeIoqvM2Df96Ke+l3qArbIOwdzBXGpFPyCPak+lX8LW3IEx1taOfI4OhgjJvRgurN6AkDmo1SDZSZVEjjMTo0bRzXhf+6J1cy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 09:41:23AM -0700, Usama Arif wrote:
> The anon/file scan balance in get_scan_count() is driven by two scalars
> in struct lruvec, anon_cost and file_cost, accumulated by every reclaim
> producer under lruvec->lru_lock. The acquisition sites for cost work
> specifically are:
> 
>   - shrink_inactive_list() re-takes lru_lock at function exit purely
>     to call lru_note_cost_unlock_irq() with (nr_pageout, nr_scanned -
>     nr_reclaimed). One acquisition per inactive shrink.
>   - shrink_active_list() does the same with (0, nr_rotated). One
>     acquisition per active shrink.
>   - workingset_refault() takes the lock via folio_lruvec_lock_irq()
>     purely to record the refault cost. One acquisition per refault.
>   - prepare_scan_control() takes lru_lock just to snapshot the two
>     scalars into sc->{anon,file}_cost.
>   - lru_note_cost_unlock_irq() itself walks parent_lruvec and
>     re-acquires lru_lock on each ancestor to propagate the update,
>     adding O(memcg-depth) acquisitions per producer call.
> 
> This hurts because lru_lock is already a heavy contention point on
> memory-heavy workloads: every isolate_lru_folios(), move_folios_to_lru()
> and folio_add_lru() takes it. The cost work itself is trivial (two
> scalar bumps and one comparison), but it contends with and causes
> contention for actual LRU manipulation. The parent_lruvec() walk also
> multiplies cost-update overhead by memcg hierarchy depth.

vvv

> Replace the producer-side accumulators with a read-side accumulator fed
> from per-LRU vmstat counters. The old producer formula was:
> 
>   cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated
> 
> Reuse NR_VMSCAN_WRITE for reclaim-driven anon pageout submissions. It is
> already bumped by writeout() for the same successful outcome that fed
> reclaim_stat.nr_pageout. Reclaim does not submit filesystem folios from
> this path, so there is no file pageout term. Charge NR_VMSCAN_WRITE via
> lruvec_stat_mod_folio() and include it in memcg_node_stat_items so it can
> be sampled per lruvec and aggregated through the memcg hierarchy.
> 
> Add explicit PGROTATE_{ANON,FILE} node_stat counters for the remaining
> producer-local input. They are bumped from shrink_inactive_list() by
> nr_scanned - nr_reclaimed and from shrink_active_list() by nr_rotated.
> WORKINGSET_RESTORE_{ANON,FILE} already captures the refault IO that
> lru_note_cost_refault() used to bill.
> 
> Add a per-side struct lru_cost { count, last_rotated, last_io } to
> struct lruvec. In prepare_scan_control() the two monotonic inputs are
> sampled separately - rotated from PGROTATE_ANON/FILE, io from
> WORKINGSET_RESTORE_BASE + f plus (for anon) NR_VMSCAN_WRITE - and the
> raw per-side deltas are computed against cost->last_rotated and
> cost->last_io before the SWAP_CLUSTER_MAX IO weighting is applied.
> Extracting the deltas from the individual counters (rather than from a
> pre-weighted sum) keeps the unsigned modular subtraction bounded by the
> true per-counter growth, so a signed-long wraparound of any underlying
> vmstat still yields the correct delta on 32-bit. The weighted delta is
> folded into cost->count. Since one vmstat delta can cover many producer
> events between reclaim passes, halve cost->count on both sides until
> their sum is back within the lrusize/4 bound instead of halving only
> once.

^^^

This is a quite a bit of explaining the code, which is kind of
drowning out what's really going on. How about something like:

---

The balance formula for anon and file, respectively, is this:

    cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated

Instead of recording cost and running averaging logic directly when
these events occur, snapshot running vmstat counters once per reclaim
cycle and derive the balance from event deltas since the last run.

WORKINGSET_RESTORE_* and NR_VMSCAN_WRITE already exist and have been
accounted all along; PGROTATE_* are added for replacing the rotation
event callbacks.

This is overall cheaper and has fewer lock aquisition sites.

---

> Moving accumulation and decay to the reclaim side also improves the cost
> model across reclaim gaps. With producer-side decay, events that happen
> while reclaim is idle still age each other before reclaim ever samples
> the costs. If a workload refaults a large anon set and then a smaller
> file set before reclaim runs again, the later file activity can age the
> earlier anon activity out of the cost model. The new scheme observes the
> whole between-reclaim delta and decays anon and file proportionally, so
> the scan-balance history better represents what happened since the last
> reclaim pass.
> 
> A dedicated per-lruvec spinlock, cost_lock, serialises the delta
> extraction, the cost->count update and the halving loop against
> concurrent reclaimers in the same memcg+node.
> 
> Hierarchy aggregation is now implicit in the vmstat accounting. The
> producer-side parent_lruvec() walk and lru_reparent_memcg() cost splice
> existed only because anon_cost/file_cost were private lruvec fields. With
> the cost expressed as lruvec vmstats, rstat propagates the underlying
> counters through the memcg hierarchy and prepare_scan_control() consumes
> the same ratelimited rstat view as the surrounding reclaim heuristics.
> 
> NR_VMSCAN_WRITE is accounted at writeout(), so reclaim_stat.nr_pageout is
> no longer needed and is removed.
> 
> memcg-v1's memory.stat anon_cost/file_cost is now sourced from
> cost[].count instead of the removed lruvec anon_cost/file_cost fields.
> The reported values only refresh when prepare_scan_control() runs and
> are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
> they express is unchanged.
> 
> Under pure MGLRU the scan-balance signal itself is not consumed (both
> prepare_scan_control() and get_scan_count() are short-circuited on the
> MGLRU paths, and MGLRU's own type/tier selection comes from read_ctrl_pos()
> on lrugen->{avg_refaulted,avg_total,refaulted,evicted}, not from
> anon_cost/file_cost). NR_VMSCAN_WRITE naturally covers writeout from
> either reclaim implementation, and PGROTATE_{ANON,FILE} are bumped from
> evict_folios() so per-memcg observability of rotation-driven reclaim work
> stays consistent across both implementations.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Otherwise, looks good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

