Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB9E7CA5FCE
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 08:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB7C6B008A; Sun,  4 Oct 2026 04:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983EC6B008C; Sun,  4 Oct 2026 04:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84BC36B0092; Sun,  4 Oct 2026 04:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50A3C6B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 04:30:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC1FD1A09C0
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 08:30:51 +0000 (UTC)
X-FDA: 85284273102.03.7295ACF
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id CD682180006
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 08:30:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MdZlM91E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791102649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NAcZ9UORcMqy+n0FSKM9i6NTOn4Bc/uP4pDsbHInuFw=;
	b=6E9jBofk6Ii0RewQp8+DDPDBvZrWfrIGorlibF2Aco9UfKso1JLfkHZeSkMtNStHnRaynp
	ckaSbE2VaG59VmHk5/QIlT4p6AZ2K1lLBSgVwQmTwI/H4oV9mr4KciuPtY3RSKxR0eUBqY
	vOovf7tckWYblCDrJlt0hClVpPNBoXA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MdZlM91E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791102649;
	b=IKi8aaOhScyjuxo07I0yf98AaLQm0NrK8OM/NY1Rp4H1NvndkPQcngefg9W9hbXhJua9Kc
	zVa6zG7ilsDPUketGOxzIiJcrd7PKJ8nrj78RAqn9bygAQ2pMM00xj12qddVdnmLQ/PSXk
	F2E7b6LgVtb6PsGLB16F85Xb9CfETKk=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e576377715so548625ad.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 01:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791102648; x=1791707448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NAcZ9UORcMqy+n0FSKM9i6NTOn4Bc/uP4pDsbHInuFw=;
        b=MdZlM91EUtlnlAZnTXQETdxfUPaTLA8yDIyx3M5QZwLc4ZGfUNwoecVCD3+aAbB3Sd
         VJ7j1aDkaNu7rVytMSk8HqLrSvdhL7iM3WsVadw8O+UNzeYSxypIiOfUDIJF1b4qhCjZ
         eQVO/SyY9aV/8y7Fh8SqJZbKMcS66VTLELUuLhb6PKJC/H4CCgLW43J3mvWvkZFZJxxE
         UR7QpKX+HowqWbkcYfA4dWVKEJQrK/tBV5wIIse1lp4B68+Dzv9oeGQrLwusNoadXZ4v
         Uy3KE7tlVmtebMwDyitdgOWbxsp/sqvwlNqDw5DWdbLHW8fAiKek24WECDnCEI+qXhcx
         QAhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791102648; x=1791707448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NAcZ9UORcMqy+n0FSKM9i6NTOn4Bc/uP4pDsbHInuFw=;
        b=vn7NR190CU6TZ7FVTBlDD38fWjQrJro0Wb40j67tFRuVDBxbOXJ6eL6UP0/8ALqCf/
         FasoQHrJxaojZqCvZ63h+rn96uctr6UbdwCByF3mbHUHslJ55gSquMgBSIcjGcX7cEix
         vWq0BI0RJ3FzCn+z97lPXYr0Qvkm8yA4Cs2BCzmtTxqKN8PYE8ALBPFUPeEgHawS4llI
         vDy+/UnMQTEOT060jllouhylNebwIVPw57XgyXTq2dXlwVqafBGgGiQvqMKOECA8f0Qm
         eSaSgTHWDes2TzgSzSEc9G+H+t1SsXgNSWuTKY0JTynVpB92zBx+hJ33FHnw4dxDrVAm
         MdQg==
X-Forwarded-Encrypted: i=1; AKwUvBwwUknpKvd5m0d9Hzi+qPcG3114lGV8lbgFdsq6rykqy0f75az2xlEZoYYIENxUhF/gKFkYasgakw==@kvack.org
X-Gm-Message-State: AFq9FYKhSaqgIrInXxVwT5sdNnQ/ASbestsgFQQLX6LK6a8RceSWMpdY
	8YAAdRqscIt4DLWHM8sbMkyHrf4IIFvddcyJ9vlJF8L22bVyglGvMaB+
X-Gm-Gg: AYBFou2QAy7pj7WU18I848+j3kX8tOSY5Ee5S8jH/Bj9lbhoe3InbPj/dv9hs7uqTWA
	jXbH+RShYOuC2nxvnY2MQyHC75Fy5QzIsF/ffcm2Qzra0L/FwHFlgOcQqKflT4XJeiDLtvZlx0f
	VmJ4kHFT3KIclgFd5vaH6VnynNImiyBhzID/twuPBV8osssaHLZsk7AYmxmdKmMLaJrNnEDxVxc
	pB4IwKmbAmigclXHVsT8ZQyBwU+Rz/lV4d/4+uTVwsQ3ODEzEIb5TD1CDnj0GjEGCkLlFPbfUQ+
	6jsGaQiPopqrqGpHacivWdQmkPtjCR3LXAkDUGVyBmuYvAhuyGLqafD9S6QXArJrZ1mDI5aslBM
	gl2GOtrOlq8KdzZl7/kwuV79piISvhXfw6lo1HDqdIxKInNTgrnhLV9bokJv50lB7U1wIBYGMkn
	zJzrO3TQk/cPQS5FG9BEVuBSk8wp2qnBUiPHSBQBTTW3lhme5j9me5pKunz9mzab6nyHu1
X-Received: by 2002:a17:90b:2f88:b0:3a6:f90b:20c8 with SMTP id 98e67ed59e1d1-3a78764a8e6mr3115937a91.57.1791102647656;
        Sun, 04 Oct 2026 01:30:47 -0700 (PDT)
Received: from gmail.com ([185.220.238.43])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78e61386csm6130855a91.17.2026.10.04.01.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 01:30:47 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Gregory Price <gourry@gourry.net>,
	David Rientjes <rientjes@google.com>,
	Wei Xu <weixugc@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Honggyu Kim <honggyu.kim@sk.com>,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Jonathan Cameron <jic23@kernel.org>
Subject: Re: [RFC PATCH v3 2/9] mm/damon/core: replace the access report buffer with per-context rings
Date: Sun,  4 Oct 2026 16:30:24 +0800
Message-ID: <20261004083036.613169-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-2-0f00417b41bc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dmhaomnk5k6jt1jemkf4ued8ymwjyhuq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD682180006
X-HE-Tag: 1791102649-664902
X-HE-Meta: U2FsdGVkX1/FI33Dq/L3kKzJKJBqFKttwv7yGd+1Q6MOWruPfgnOr8wF5WJij53JWUQr1X+zJeRkMQs42qVZp1TAGDl+6i52FKt0Zli/po2YciJeEd9rgYZKx3x7Ak4wqIsATxTg5PFUGbQ4r9UQJ/7yzG/VRj23jOft+05M0AJmxkHIuBtdimRlg0QgEfTklrzKfcfMdAz8m/ls5fDdRSzw0ehgAKCMLbG/8m7vbsAj0J4MDvnzcfbeFbAmVB8bPOqxBP6Japfy603HjOunBq5p/gINEDyqUkPv79sA9lhyRhush3EQjnHi5+H4iOq3I0/liXoPCbJQEPdRW8Dlzi5uHssdM7UkAjZJnLbT9ZjXXRYrqaoj28z0xv2+/raBXHtv8PMVjea2iIajKhNRTLNUSXVABGjTCSVuljjTxE6m7yz15UgZ6dpweYackSSlj43LLnNOTzAwQAB5IxqChF2OEVWGDXRkYaOh8cRCrvWZIRo7TY/sQxvzFSK3aRiesSOoKzsRlnk7v84nuBMSsVU42R6EdWg0+XEXzdbOQB9eV1qzY0BB0iRL80c8yDEAaFNAZrGq2oOHmWR5ECNlPcjxPz6SZdy963e2R5OranMGcGWLROvMoadaTV/YjyLcjMeny1zQ0gAuozxQe1Jgvj8mIVF2Vi8ojVHaidSp4FFCuPhlN7GbCJ6GSrpQhxfPUfnecBebX/7Zov09gbHx8QtQb/TDKshpnLdcRtTuSv4tlgmZfTnJG/Achd0FY3/BnT2pCAdSim2xdvDJSAYCxEpvSD3MEV6MFhq1WIEd0HBbmU5gWQfNfdvv0to3w9H6epA865Fq8ehRjP4WKjhhn1PqILu9xtpPfYROIEDINrtrzBbBVvn5BC+NnBxBJxlcbEiMGQo6y8sK70JftqDlZO8ugFI0yuo41hlsRrN3Z4DniQ5WseUeIIMlRyFrT9fqPPn/rgSLGs4jnD98m6/
 VJdcHGkx
 gYcYTLZljZVJPJWcdPtl0OAtiwWhqCv+IQgoKWhdz1PKnSU/Z5VIORpFuPekNM5+XVGsZLRJ1jjmepfAUcTyO7JDcQ4uHWRUVxIgDTx/QZKsAwoh/+GWFCrSROUO0WdfEylBQnL+vrKsP97FXYGy8lDkQXcN+SuulyJ+p8iJuhtPmIs8S0gY5BPYmtGvu5aJogNKMBQEV+PmZOiAUNiNyZ9Rr+RzLIDPKtLutYk/mbN6pZVBkd74yRJD2gVzocpPfeAdV/2nZldBswHbchKItYJML9nU01ySnSY6prDerQnN/5GweSjB81+P6L4vFw0G5iEvT6QdwVnhDJQ8UmKqzl/205m5G/PShyk6oVIXuRVojt6hRwaSIT/4vVOBtp9CO1rJecJjCSPjo3u/Lc2UAbb5D8LysakV/tBwpwImsqi0146vfrVmO5JGETv8rYb0u1syLmCT5zrSjiR+Ixlhr6vai7fwdsnQNy8/y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 03 Oct 2026 14:07:55 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> damon_report_access() queues reports into the global damon_access_reports[]
> buffer under a mutex, and kdamond applies them from there.  A perf-event
> overflow handler runs in NMI context and cannot take that mutex, and since
> the previous patch the buffer has no other producer.
> 
> Replace the buffer with a per-context, per-CPU SPSC report ring
> (ctx->perf_rings) that an NMI-context producer can publish into, and a
> kdamond drain that credits regions from each ring's pending reports.
> 
> NMI safety: the producer uses a busy counter to drop re-entrant reports on
> the same CPU, publishes with smp_wmb() before advancing the head, and sets
> a pending-CPU bitmask with smp_mb__before_atomic() so the consumer catches
> any report published between the bit-clear and the READ_ONCE(head).  The
> ring is allocated before the first PMU arm and freed after the last PMU
> release in damon_destroy_ctx(), so no in-flight NMI can reach freed
> storage.
> 
> The drain matches each report to a region by binary search over a
> per-target region snapshot built in ar.start order, the region-list
> invariant damon_credit_report_bsearch() relies on.  A credited region's
> access rate is incremented once per drained sample rather than once per
> aggregation tick, so a region that drains several samples in one tick
> reflects that instead of being clamped to the signal a lone sample gives.
> 
> While here, widen probe_hits[] and last_probe_hits[] in struct
> damon_region, and the damon_probe_hits_mvsum() return type, from unsigned
> char to unsigned int.  An unsigned char wraps at 256; a PEBS event at
> 5000 Hz overflows it within a single 1-second aggregation window.
> 
> Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> ---
>  include/linux/damon.h | 110 ++++++++-
>  mm/damon/core.c       | 625 +++++++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 642 insertions(+), 93 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 10582f669673..217299aa6c03 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -17,9 +17,19 @@
>  #define DAMON_MIN_REGION_SZ	PAGE_SIZE
>  /* Maximum number of monitoring probes. */
>  #define DAMON_MAX_PROBES	(4)
> +/*
> + * Sentinel value for damon_access_report.probe_idx: 0 means no probe
> + * attribution (matches zero-init of struct damon_access_report on the stack).
> + * Perf-event probe indices start at 1.
> + */
> +#define DAMON_PROBE_IDX_NONE	0
>  /* Max priority score for DAMON-based operation schemes */
>  #define DAMOS_MAX_SCORE		(99)
>  
> +/* Per-CPU SPSC ring: size must be a power of two. */
> +#define DAMON_REPORT_RING_SIZE	256
> +#define DAMON_REPORT_RING_MASK	(DAMON_REPORT_RING_SIZE - 1)
> +
>  /**
>   * struct damon_addr_range - Represents an address region of [@start, @end).
>   * @start:	Start address of the region (inclusive).
> @@ -66,14 +76,14 @@ struct damon_region {
>  	struct damon_addr_range ar;
>  	unsigned long sampling_addr;
>  	unsigned int nr_accesses;
> -	unsigned char probe_hits[DAMON_MAX_PROBES];
> +	unsigned int  probe_hits[DAMON_MAX_PROBES];
>  	unsigned int age;
>  /* private: internal use only. */
>  	/* List head for siblings. */
>  	struct list_head list;
>  	/* for age calculation. */
>  	unsigned int last_nr_accesses;
> -	unsigned char last_probe_hits[DAMON_MAX_PROBES];
> +	unsigned int  last_probe_hits[DAMON_MAX_PROBES];
>  	bool access_reported;
>  };
>  
> @@ -110,7 +120,15 @@ struct damon_target {
>   * @size:		The size of the accessed address range.
>   * @cpu:		The id of the CPU that made the access.
>   * @tid:		The task id of the task that made the access.
> + * @tgid:		The thread group id of the task that made the access.  A
> + *			monitoring target created for a process carries this id,
> + *			so it is the id a report is matched against.
>   * @is_write:		Whether the access is write.
> + * @probe_idx:		Index into probe_hits[] for the reporting probe; set by
> + *			the perf-event overflow handler so the drain can credit
> + *			the correct slot without a list walk.
> + *			0 is reserved (no probe attribution; matches zero-init);
> + *			perf-event probe indices start at 1.
>   *
>   * Any DAMON API callers that notified access events can report the information
>   * to DAMON using damon_report_access().  This struct contains the reporting
> @@ -122,11 +140,54 @@ struct damon_access_report {
>  	unsigned long size;
>  	unsigned int cpu;
>  	pid_t tid;
> +	pid_t tgid;
>  	bool is_write;
> +	int probe_idx;
> +	/*
> +	 * Owning context for a report (set by the perf-event overflow handler
> +	 * so the producer enqueues into that ctx's own perf ring).  NULL for a
> +	 * report with no owning context (probe_idx == DAMON_PROBE_IDX_NONE);
> +	 * such a report has no ring to feed and is dropped by
> +	 * damon_report_access().
> +	 */
> +	struct damon_ctx *ctx;
>  /* private: */
>  	unsigned long report_jiffies;	/* when this report is made */
>  };
>  
> +/**
> + * struct damon_report_ring - Per-CPU SPSC ring for NMI-safe access reports.
> + *
> + * @head:	Write index; updated by the NMI producer.
> + * @tail:	Read index; updated by the kdamond consumer.
> + * @entries:	Ring buffer entries.
> + *
> + * One ring per CPU, per context with a perf-event probe.  The producer
> + * (NMI overflow handler) writes to @head; the consumer (kdamond) reads
> + * from @tail.  Both indices are unsigned and wrap modulo
> + * DAMON_REPORT_RING_SIZE.
> + */
> +struct damon_report_ring {
> +	unsigned int head;	/* written by producer (NMI) */
> +	unsigned int tail	/* written by consumer (kdamond) */
> +		____cacheline_aligned_in_smp;
> +	struct damon_access_report entries[DAMON_REPORT_RING_SIZE]
> +		____cacheline_aligned_in_smp;
> +};
> +
> +/*
> + * struct damon_target_lookup - Cached, sorted region snapshot for one target.
> + * @regions:	Array of region pointers, sorted by ar.start (address order).
> + * @nr_regions:	Number of entries in @regions.
> + *
> + * Built once per aggregation tick by damon_build_target_lookup() so the ring
> + * drain can binary-search a target's regions instead of walking the list.
> + */
> +struct damon_target_lookup {
> +	struct damon_region **regions;
> +	unsigned int nr_regions;
> +};
> +
>  /**
>   * enum damos_action - Represents an action of a Data Access Monitoring-based
>   * Operation Scheme.
> @@ -874,6 +935,7 @@ struct damon_filter {
>   */
>  struct damon_probe {
>  	unsigned int weight;
> +	bool event_driven;	/* hits arrive via ring drain, not apply_probes */
>  /* private: */
>  	/* Preparation actions to apply to each probing memory. */
>  	struct list_head preps;
> @@ -1091,6 +1153,32 @@ struct damon_ctx {
>  
>  	/* @rnd_state:	Per-ctx PRNG state for damon_rand(). */
>  	struct rnd_state rnd_state;
> +
> +	/* Reusable drain-loop snapshot buffer (avoids per-tick kmalloc). */
> +	struct {
> +		struct damon_target_lookup *lookups;
> +		unsigned int nr_lookups;
> +		struct damon_region **region_buf;
> +		unsigned int region_buf_cap;
> +	} drain_snapshot;
> +
> +	/*
> +	 * Per-context perf-event report ring.  A perf overflow handler is
> +	 * armed by -- and carries a pointer to -- its owning ctx
> +	 * (damon_access_report.ctx), so its reports route to this per-ctx
> +	 * ring.  This gives full per-context isolation (two perf-driven ctxs
> +	 * never share a ring) and needs no cross-ctx ring owner guard.
> +	 *
> +	 * Allocated lazily when the first perf probe is armed
> +	 * (damon_ctx_alloc_perf_ring, from damon_perf_probe_setup) and freed in
> +	 * damon_destroy_ctx() AFTER all perf events are released, so no in-flight
> +	 * NMI can reach freed storage.  perf_rings == NULL means "no perf ring
> +	 * yet" and any perf report is dropped, so a build/config without a perf
> +	 * source simply never allocates it (lazy alloc = zero cost when unused).
> +	 */
> +	struct damon_report_ring __percpu *perf_rings;
> +	int __percpu *perf_ring_busy;
> +	cpumask_t perf_pending;
>  };
>  
>  /* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
> @@ -1209,11 +1297,12 @@ void damon_destroy_filter(struct damon_filter *f);
>  
>  struct damon_probe *damon_new_probe(void);
>  void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
> +bool damon_has_event_driven_probes(struct damon_ctx *ctx);
>  
>  struct damon_region *damon_new_region(unsigned long start, unsigned long end);
>  unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
>  		struct damon_ctx *ctx);
> -unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
> +unsigned int damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
>  		struct damon_ctx *ctx);
>  unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last, bool mv,
>  		struct damon_ctx *ctx);
> @@ -1298,23 +1387,30 @@ int damon_kdamond_pid(struct damon_ctx *ctx);
>  int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
>  int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
>  
> -void damon_report_access(struct damon_access_report *report);
> +bool damon_report_access(struct damon_access_report *report);
> +int damon_ctx_alloc_perf_ring(struct damon_ctx *ctx);
>  
>  int damon_set_region_system_rams_default(struct damon_target *t,
>  				unsigned long *start, unsigned long *end,
>  				unsigned long addr_unit,
>  				unsigned long min_region_sz);
>  
> -#ifdef CONFIG_ACMA
>  
> +unsigned long damon_get_report_overflow(void);
> +unsigned long damon_get_report_ring_full(void);
> +unsigned long damon_get_report_busy_drop(void);
> +unsigned long damon_get_samples_drained(void);
> +unsigned long damon_get_samples_stale_drained(void);
> +unsigned long damon_get_samples_no_region(void);
> +#ifdef CONFIG_ACMA
>  unsigned long damon_alloced_bytes(void);
> -
>  #endif
>  
>  #else	/* CONFIG_DAMON */
>  
> -static inline void damon_report_access(struct damon_access_report *report)
> +static inline bool damon_report_access(struct damon_access_report *report)
>  {
> +	return false;
>  }
>  
>  #endif	/* CONFIG_DAMON */
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 886e068e7844..4fd1db12bc49 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -22,8 +22,87 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/damon.h>
>  
> -#define DAMON_ACCESS_REPORTS_CAP 1000
> +/*
> + * Reports are fed to DAMON via a PER-CONTEXT per-CPU SPSC ring
> + * (ctx->perf_rings).  The overflow handler carries the owning ctx, so each
> + * perf-driven context drains only its own ring -- no global ring and no
> + * cross-context owner needed.  See struct damon_ctx.
> + *
> + * Each context's ring has its own per-CPU storage, per-CPU busy flag,
> + * pending cpumask, and overflow counter.
> + */
> +/*
> + * Report drops are counted per reason.  A ring-full drop means the consumer
> + * did not keep up with the producer; a busy-guard drop means an NMI nested on
> + * top of a same-CPU producer.
> + */
> +static DEFINE_PER_CPU(unsigned long, damon_report_ring_full_perf);
> +static DEFINE_PER_CPU(unsigned long, damon_report_busy_drop_perf);
> +static DEFINE_PER_CPU(unsigned long, damon_samples_drained);
> +static DEFINE_PER_CPU(unsigned long, damon_samples_stale_drained);
> +static DEFINE_PER_CPU(unsigned long, damon_samples_no_region);
> +
> +unsigned long damon_get_report_ring_full(void)
> +{
> +	unsigned long sum = 0;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		sum += per_cpu(damon_report_ring_full_perf, cpu);
> +	return sum;
> +}
> +EXPORT_SYMBOL_GPL(damon_get_report_ring_full);
> +
> +unsigned long damon_get_report_busy_drop(void)
> +{
> +	unsigned long sum = 0;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		sum += per_cpu(damon_report_busy_drop_perf, cpu);
> +	return sum;
> +}
> +EXPORT_SYMBOL_GPL(damon_get_report_busy_drop);
> +
> +/* Reports dropped for either reason.  Kept so existing users need no change. */
> +unsigned long damon_get_report_overflow(void)
> +{
> +	return damon_get_report_ring_full() + damon_get_report_busy_drop();
> +}
> +EXPORT_SYMBOL_GPL(damon_get_report_overflow);
> +
> +unsigned long damon_get_samples_drained(void)
> +{
> +	unsigned long sum = 0;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		sum += per_cpu(damon_samples_drained, cpu);
> +	return sum;
> +}
> +EXPORT_SYMBOL_GPL(damon_get_samples_drained);
> +
> +unsigned long damon_get_samples_stale_drained(void)
> +{
> +	unsigned long sum = 0;
> +	int cpu;
>  
> +	for_each_possible_cpu(cpu)
> +		sum += per_cpu(damon_samples_stale_drained, cpu);
> +	return sum;
> +}
> +EXPORT_SYMBOL_GPL(damon_get_samples_stale_drained);
> +
> +unsigned long damon_get_samples_no_region(void)
> +{
> +	unsigned long sum = 0;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		sum += per_cpu(damon_samples_no_region, cpu);
> +	return sum;
> +}
> +EXPORT_SYMBOL_GPL(damon_get_samples_no_region);
>  static DEFINE_MUTEX(damon_lock);
>  static int nr_running_ctxs;
>  static bool running_exclusive_ctxs;
> @@ -33,11 +112,6 @@ static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
>  
>  static struct kmem_cache *damon_region_cache __ro_after_init;
>  
> -static DEFINE_MUTEX(damon_access_reports_lock);
> -static struct damon_access_report damon_access_reports[
> -	DAMON_ACCESS_REPORTS_CAP];
> -static int damon_access_reports_len;
> -
>  /* Should be called under damon_ops_lock with id smaller than NR_DAMON_OPS */
>  static bool __damon_is_registered_ops(enum damon_ops_id id)
>  {
> @@ -288,6 +362,32 @@ static bool damon_has_probe_weights(struct damon_ctx *c)
>  	return false;
>  }
>  
> +/**
> + * damon_has_event_driven_probes() - return true if @ctx has any event-driven
> + * probes registered.
> + *
> + * Event-driven probes (e.g. perf-event IBS/PEBS) populate probe_hits[] via
> + * the SPSC ring drain rather than the apply_probes vtable.  Callers use this
> + * to decide whether to arm hardware sampling.
> + */
> +bool damon_has_event_driven_probes(struct damon_ctx *ctx)
> +{
> +	struct damon_probe *p;
> +
> +	damon_for_each_probe(p, ctx) {
> +		if (p->event_driven)
> +			return true;
> +	}
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(damon_has_event_driven_probes);
> +
> +/* Does @ctx drive (and thus need exclusive drain of) the perf report ring? */
> +static bool damon_drains_ring_perf(struct damon_ctx *ctx)
> +{
> +	return damon_has_event_driven_probes(ctx);
> +}
> +
>  /*
>   * damon_mvsum() - Returns pseudo moving sum value for a time window.
>   * @current_nr:		The value of the current aggregation window.
> @@ -353,7 +453,7 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
>  			left_window_bp);
>  }
>  
> -unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
> +unsigned int damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
>  		struct damon_ctx *ctx)
>  {
>  	unsigned long sample_interval, aggr_interval;
> @@ -979,7 +1079,6 @@ static struct damon_sample_filter *damon_last_sample_filter_or_null(
>  	return list_last_entry_or_null(&ctrl->sample_filters,
>  			struct damon_sample_filter, list);
>  }
> -
>  struct damon_ctx *damon_new_ctx(void)
>  {
>  	struct damon_ctx *ctx;
> @@ -1025,6 +1124,40 @@ struct damon_ctx *damon_new_ctx(void)
>  	return ctx;
>  }
>  
> +/*
> + * Lazily allocate the per-ctx perf report ring.  Called from the perf probe
> + * setup path BEFORE any perf event is armed, so an overflow can never observe
> + * a half-built ring.  Idempotent: a ctx with several perf probes allocates
> + * once.  The ring is freed in damon_destroy_ctx() after all perf events are
> + * released (damon_perf_probe_teardown), so no in-flight NMI can reach it.
> + */
> +int damon_ctx_alloc_perf_ring(struct damon_ctx *ctx)
> +{
> +	if (ctx->perf_rings)
> +		return 0;	/* already allocated for an earlier probe */
> +	ctx->perf_rings = alloc_percpu(struct damon_report_ring);
> +	if (!ctx->perf_rings)
> +		return -ENOMEM;
> +	ctx->perf_ring_busy = alloc_percpu(int);
> +	if (!ctx->perf_ring_busy) {
> +		free_percpu(ctx->perf_rings);
> +		ctx->perf_rings = NULL;
> +		return -ENOMEM;
> +	}
> +	cpumask_clear(&ctx->perf_pending);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(damon_ctx_alloc_perf_ring);
> +
> +/* Free the per-ctx perf ring.  Caller must ensure no perf event is armed. */
> +static void damon_ctx_free_perf_ring(struct damon_ctx *ctx)
> +{
> +	free_percpu(ctx->perf_rings);
> +	ctx->perf_rings = NULL;
> +	free_percpu(ctx->perf_ring_busy);
> +	ctx->perf_ring_busy = NULL;
> +}
> +
>  static void damon_destroy_targets(struct damon_ctx *ctx)
>  {
>  	struct damon_target *t, *next_t;
> @@ -1050,6 +1183,16 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
>  	damon_for_each_sample_filter_safe(f, next_f, &ctx->sample_control)
>  		damon_destroy_sample_filter(f, &ctx->sample_control);
>  
> +	/*
> +	 * All perf events were released by damon_perf_probe_teardown() in the
> +	 * probe loop above, so no overflow handler can still reach the ring.
> +	 * Safe to free now, before kfree(ctx).  No-op if never allocated.
> +	 */
> +	damon_ctx_free_perf_ring(ctx);
> +
> +	/* Free the reusable ring-drain region snapshot buffers. */
> +	kfree(ctx->drain_snapshot.lookups);
> +	kfree(ctx->drain_snapshot.region_buf);
>  	kfree(ctx);
>  }
>  
> @@ -2519,30 +2662,107 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
>   * damon_report_access() - Report identified access events to DAMON.
>   * @report:	The reporting access information.
>   *
> - * Report access events to DAMON.
> + * Report access events to DAMON via a per-context per-CPU SPSC lockless ring
> + * (ctx->perf_rings).  Producer is the local CPU (typically NMI from a
> + * hardware-sampling backend); consumer is the kdamond drain in
> + * kdamond_check_reported_accesses().
> + *
> + * The destination ring is selected by this_cpu_ptr(), i.e. by the CPU calling
> + * this function, not by @report->cpu, which is sample metadata used by the
> + * drain-side filter.  The two coincide for a sample delivered by an interrupt
> + * on the CPU that produced it.
> + *
> + * A backend whose PMU writes a record stream into a memory buffer instead of
> + * raising a per-sample interrupt, or one reading a device counter table, must
> + * therefore decode CPU N's buffer on CPU N -- for example by queueing per-CPU
> + * work with queue_work_on() -- rather than calling this function in a loop
> + * from one thread.  A single-thread loop puts every report in that thread's
> + * ring, which caps machine-wide capacity at DAMON_REPORT_RING_SIZE - 1
> + * reports per drain regardless of the number of producing CPUs, and does not
> + * satisfy the single-producer invariant if the thread can migrate.
> + *
> + * Context: any (NMI-safe).  An NMI nesting on top of a process-context
> + * producer on the same CPU would otherwise stomp the same entries[head]
> + * slot; the busy guard detects and drops in that case.
>   *
> - * Context: May sleep.
> + * If the ring is full, the sample is dropped and the per-CPU ring-full
> + * counter incremented; a busy-guard drop increments the busy-drop counter.
>   *
> - * NOTE: we may be able to implement this as a lockless queue, and allow any
> - * context.  As the overhead is unknown, and region-based DAMON logics would
> - * guarantee the reports would be not made that frequently, let's start with
> - * this simple implementation.
> + * Return: true if the report was queued, false if it was dropped.  A producer
> + * holding a single report may ignore this.  A producer decoding a batch out
> + * of a hardware buffer should stop on false and leave the remainder in that
> + * buffer for the next round, since a report released from the buffer but not
> + * queued here is not delivered.
>   */
> -void damon_report_access(struct damon_access_report *report)
> +bool damon_report_access(struct damon_access_report *report)
>  {
> -	struct damon_access_report *dst;
> +	/*
> +	 * Only perf-event reports (probe_idx >= 1) have a ring to feed: the
> +	 * global page_fault ring this dispatch also fed has been removed.
> +	 * A probe_idx == DAMON_PROBE_IDX_NONE report has nowhere to go and is
> +	 * dropped here rather than at each caller.
> +	 */
> +	struct damon_report_ring *ring;
> +	cpumask_t *pending;
> +	int __percpu *busy_pcpu;
> +	unsigned int head, next;
> +	int busy;
> +	bool queued = false;
> +	struct damon_ctx *pctx = report->ctx;
> +
> +	if (report->probe_idx == DAMON_PROBE_IDX_NONE)
> +		return false;
>  
> -	/* silently fail for races */
> -	if (!mutex_trylock(&damon_access_reports_lock))
> -		return;
> -	dst = &damon_access_reports[damon_access_reports_len++];
> -	/* just drop all existing reports in favor of simplicity. */
> -	if (damon_access_reports_len == DAMON_ACCESS_REPORTS_CAP)
> -		damon_access_reports_len = 0;
> -	*dst = *report;
> -	dst->report_jiffies = jiffies;
> -	mutex_unlock(&damon_access_reports_lock);
> +	/*
> +	 * A perf report must carry its owning ctx (set by the overflow handler)
> +	 * and that ctx must have an allocated per-ctx perf ring.  If either is
> +	 * missing (e.g. an overflow racing teardown after the ring was freed, or
> +	 * a report raised before the ring was allocated), drop the sample rather
> +	 * than touch NULL/freed storage.
> +	 */
> +	if (!pctx || !pctx->perf_rings || !pctx->perf_ring_busy)
> +		return false;
> +
> +	/* Pin to a CPU so the SPSC invariant holds for preemptible callers. */
> +	preempt_disable();
> +	busy_pcpu = pctx->perf_ring_busy;
> +	busy = this_cpu_inc_return(*busy_pcpu);
> +	if (busy != 1) {
> +		/* NMI nested on a process-context producer; drop. */
> +		this_cpu_inc(damon_report_busy_drop_perf);
> +		goto out;
> +	}
> +
> +	ring = this_cpu_ptr(pctx->perf_rings);
> +	pending = &pctx->perf_pending;
> +	head = ring->head;
> +	next = (head + 1) & DAMON_REPORT_RING_MASK;
> +
> +	if (next == READ_ONCE(ring->tail)) {
> +		this_cpu_inc(damon_report_ring_full_perf);
> +		goto out;
> +	}
> +
> +	ring->entries[head] = *report;
> +	ring->entries[head].report_jiffies = jiffies;
> +	smp_wmb(); /* publish entry before head advance */
> +	WRITE_ONCE(ring->head, next);
> +	/*
> +	 * Order the head advance before publishing the pending bit so
> +	 * that the consumer, on observing the bit, is also guaranteed
> +	 * to observe the new head.  cpumask_set_cpu / set_bit are
> +	 * documented as unordered RMW (atomic_bitops.txt), hence the
> +	 * explicit barrier.
> +	 */
> +	smp_mb__before_atomic();
> +	cpumask_set_cpu(smp_processor_id(), pending);
> +	queued = true;
> +out:
> +	this_cpu_dec(*busy_pcpu);
> +	preempt_enable();
> +	return queued;
>  }
> +EXPORT_SYMBOL_GPL(damon_report_access);
>  
>  /*
>   * Reset the aggregated monitoring results ('nr_accesses' of each region).
> @@ -4202,6 +4422,24 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
>  	}
>  }
>  
> +static unsigned int kdamond_apply_zero_access_report(struct damon_ctx *ctx)
> +{
> +	struct damon_target *t;
> +	struct damon_region *r;
> +	unsigned int max_nr_accesses = 0;
> +
> +	damon_for_each_target(t, ctx) {
> +		damon_for_each_region(r, t) {
> +			if (r->access_reported)
> +				r->access_reported = false;
> +			else
> +				damon_update_region_access_rate(r, false);
> +			max_nr_accesses = max(max_nr_accesses, r->nr_accesses);
> +		}
> +	}
> +	return max_nr_accesses;
> +}
> +
>  static bool damon_sample_filter_matching(struct damon_access_report *report,
>  		struct damon_sample_filter *filter)
>  {
> @@ -4229,6 +4467,11 @@ static bool damon_sample_filter_matching(struct damon_access_report *report,
>  	return matched == filter->matching;
>  }
>  
> +/*
> + * Decide whether a drained report should be dropped per the ctx sample
> + * filters.  A matching "!allow" (filter-out) filter drops the report; if no
> + * filter matched, the last filter's @allow acts as the default policy.
> + */
>  static bool damon_sample_filter_out(struct damon_access_report *report,
>  		struct damon_sample_control *ctrl)
>  {
> @@ -4245,73 +4488,276 @@ static bool damon_sample_filter_out(struct damon_access_report *report,
>  	return !filter->allow;
>  }
>  
> -static void kdamond_apply_access_report(struct damon_access_report *report,
> -		struct damon_target *t, struct damon_ctx *ctx)
> +/*
> + * Build a snapshot of the ctx's targets and their region arrays for use by
> + * the ring drain loop.  The snapshot buffer is reused across ticks, grown via
> + * krealloc only when a new high water mark is reached.
> + *
> + * The two-pass walk over adaptive_targets is safe even though krealloc_array()
> + * may sleep: target list mutation is funneled through damon_call onto the
> + * kdamond itself, so no other thread can mutate the list while kdamond runs
> + * this function.  Regions within a target are kept address-sorted by DAMON, so
> + * the snapshot arrays are directly binary-searchable.
> + */
> +static struct damon_target_lookup *damon_build_target_lookup(
> +		struct damon_ctx *ctx, unsigned int *nr_targets_out)
>  {
> -	struct damon_region *r;
> -	unsigned long addr;
> +	struct damon_target *t;
> +	struct damon_target_lookup *tbl;
> +	unsigned int nr_targets = 0, total_regions = 0, ti = 0, ri = 0;
>  
> -	if (damon_sample_filter_out(report, &ctx->sample_control))
> -		return;
> -	if (damon_target_has_pid(ctx))
> -		addr = report->vaddr;
> -	else
> -		addr = report->paddr;
> +	damon_for_each_target(t, ctx) {
> +		nr_targets++;
> +		total_regions += damon_nr_regions(t);
> +	}
>  
> -	/* todo: make search faster, e.g., binary search? */
> -	damon_for_each_region(r, t) {
> -		if (addr < r->ar.start)
> -			continue;
> -		if (r->ar.end < addr + report->size)
> -			continue;
> -		if (!r->access_reported)
> -			damon_update_region_access_rate(r, true);
> -		r->access_reported = true;
> +	if (nr_targets > ctx->drain_snapshot.nr_lookups) {
> +		tbl = krealloc_array(ctx->drain_snapshot.lookups,
> +				nr_targets, sizeof(*tbl), GFP_KERNEL);
> +		if (!tbl)
> +			return NULL;
> +		ctx->drain_snapshot.lookups = tbl;
> +		ctx->drain_snapshot.nr_lookups = nr_targets;
> +	}
> +	tbl = ctx->drain_snapshot.lookups;
> +
> +	if (total_regions > ctx->drain_snapshot.region_buf_cap) {
> +		struct damon_region **buf;
> +
> +		buf = krealloc_array(ctx->drain_snapshot.region_buf,
> +				total_regions, sizeof(*buf), GFP_KERNEL);
> +		if (!buf)
> +			return NULL;
> +		ctx->drain_snapshot.region_buf = buf;
> +		ctx->drain_snapshot.region_buf_cap = total_regions;
>  	}
> +
> +	/*
> +	 * DAMON maintains each target's region list sorted by ar.start.
> +	 * damon_credit_report_bsearch() binary-searches by address, so the
> +	 * snapshot built here must preserve that order.  If the region-list
> +	 * ordering invariant ever changes, this builder must sort explicitly.
> +	 */
> +	damon_for_each_target(t, ctx) {
> +		struct damon_region *r;
> +
> +		tbl[ti].regions = &ctx->drain_snapshot.region_buf[ri];
> +		tbl[ti].nr_regions = damon_nr_regions(t);
> +		damon_for_each_region(r, t)
> +			ctx->drain_snapshot.region_buf[ri++] = r;
> +		ti++;
> +	}
> +
> +	*nr_targets_out = nr_targets;
> +	return tbl;
>  }
>  
> -static unsigned int kdamond_apply_zero_access_report(struct damon_ctx *ctx)
> -{
> +/*
> + * Binary-search a sorted region snapshot for the region containing @addr and,
> + * on a hit, credit the report to @pidx.  Returns true if a region was credited
> + * (straddling reports that spill past the region end are rejected).
> + */
> +static bool damon_credit_report_bsearch(struct damon_region **regions,
> +		unsigned int nr_regions, unsigned long addr,
> +		unsigned long size, int pidx)
> +{
> +	struct damon_region *r = NULL;
> +	int left = 0, right = (int)nr_regions - 1, mid;
> +
> +	while (left <= right) {
> +		/* Avoid (left + right) overflow at large nr_regions. */
> +		mid = left + (right - left) / 2;
> +		if (addr < regions[mid]->ar.start)
> +			right = mid - 1;
> +		else if (addr >= regions[mid]->ar.end)
> +			left = mid + 1;
> +		else {
> +			r = regions[mid];
> +			break;
> +		}
> +	}
> +	if (!r)
> +		return false;
> +	/* Reject reports straddling a region boundary. */
> +	if (addr + size > r->ar.end)
> +		return false;
> +
> +	/*
> +	 * pidx is always >= 1 here: __kdamond_drain_ring rejects
> +	 * DAMON_PROBE_IDX_NONE (0) entries before calling this.  Ring
> +	 * probe_idx is 1-based, but probe_hits[] storage is 0-based to match
> +	 * all readers (wsum, mvsum, update, aggregate reset, merge).
> +	 * Convert here: probe_hits[pidx - 1].
> +	 */
> +	r->probe_hits[pidx - 1]++;
> +	damon_update_region_access_rate(r, true);

Hi Ravi,

Thanks for the updated version.

I have a question about the access count semantics with
hardware-sampled reports.

In damon_credit_report_bsearch(), each hardware report updates both
probe_hits and the region access rate through 
damon_update_region_access_rate.

Unlike page-table or page-fault based access checks, where an access
report is generated from a deterministic access observation, a
hardware-sampled report represents a statistical hardware event whose
frequency depends on the PMU configuration.

For the same workload, nr_accesses may therefore have different
scales when monitored with different PMU sampling configurations
(for example, PEBS at a given frequency versus IBS with a different
sample period).

Should we document this distinction, so that users configuring DAMOS
schemes with nr_accesses thresholds understand that the value depends
on the hardware sampling source?

Thanks,
Kunwu

> +	r->access_reported = true;
> +	return true;
> +}
> +
> +/*
> + * __kdamond_drain_ring - drain a per-CPU SPSC ring into region probe_hits.
> + * @ctx:		draining context (owns @ring for this run).
> + * @tbl:		pre-built sorted per-target region snapshot (shared).
> + * @ring_pcpu:		the per-CPU ring base (ctx's perf ring).
> + * @pending:		the matching pending cpumask.
> + *
> + * Each context's per-CPU perf ring (ctx->perf_rings) is drained by this
> + * loop, parameterised only by which ring + pending mask to consume.  The
> + * bsearch / straddle-reject / tid-filter / stale-window / sample-filter /
> + * probe_hits-crediting logic is shared by every ring this loop drains.
> + *
> + * Each ring entry carries its own probe_idx (set by the overflow handler), so
> + * no list walk is needed to resolve the probe_hits[] slot.
> + *
> + * A per-target sorted region snapshot is built once per drain (by the caller)
> + * so each entry is matched to its region via O(log R) binary search rather
> + * than a linear damon_for_each_region() walk.  Iterates the ring's pending
> + * cpumask to drain only CPUs with published reports.
> + */
> +static void __kdamond_drain_ring(struct damon_ctx *ctx,
> +		struct damon_target_lookup *tbl,
> +		struct damon_report_ring __percpu *ring_pcpu,
> +		cpumask_t *pending)
> +{
> +	int cpu;
> +	struct damon_report_ring *ring;
> +	unsigned int tail, head;
> +	struct damon_access_report *entry;
>  	struct damon_target *t;
> -	struct damon_region *r;
> -	unsigned int max_nr_accesses = 0;
> +	unsigned long match_addr;
> +	bool found;
> +	unsigned int ti;
>  
> -	damon_for_each_target(t, ctx) {
> -		damon_for_each_region(r, t) {
> -			if (r->access_reported)
> -				r->access_reported = false;
> +	/*
> +	 * Unified paddr/vaddr drain.  The address space of the monitoring
> +	 * target selects which address of the report is matched: contexts
> +	 * whose targets carry a pid are monitoring a virtual address space and
> +	 * match report->vaddr, the others match report->paddr.
> +	 *
> +	 * For pid-target contexts, filter by thread group id so entries from
> +	 * unrelated processes are not credited to the wrong target.
> +	 * damon_target_has_pid(ctx) gates this filter: it is false for paddr
> +	 * ops, whose targets have no pid, so paddr crediting is unfiltered.
> +	 */
> +	for_each_cpu(cpu, pending) {
> +		ring = per_cpu_ptr(ring_pcpu, cpu);
> +		cpumask_clear_cpu(cpu, pending);
> +		/*
> +		 * Pair with the producer's smp_mb__before_atomic() between
> +		 * the head publish and cpumask_set_cpu(): order the bit clear
> +		 * before the head read so a producer publishing between the
> +		 * clear and the READ_ONCE(head) is observed via the bit it
> +		 * re-sets, not lost as a stale-head drain.
> +		 */
> +		smp_mb__after_atomic();
> +		head = READ_ONCE(ring->head);
> +		smp_rmb(); /* pair with smp_wmb in producer */
> +		tail = ring->tail;
> +
> +		while (tail != head) {
> +			unsigned long stale_before;
> +			int pidx;
> +
> +			entry = &ring->entries[tail];
> +			/*
> +			 * Use sample_interval (not aggr_interval) as the
> +			 * staleness window: entries older than one sample
> +			 * interval are from a previous monitoring tick and
> +			 * should not inflate the current aggregation window.
> +			 */
> +			stale_before = jiffies -
> +				usecs_to_jiffies(ctx->attrs.sample_interval);
> +			if (time_before(entry->report_jiffies, stale_before)) {
> +				this_cpu_inc(damon_samples_stale_drained);
> +				goto next;
> +			}
> +			pidx = entry->probe_idx;
> +			/*
> +			 * Every entry in this ring is a perf-event report
> +			 * (probe_idx >= 1); damon_report_access() drops any
> +			 * DAMON_PROBE_IDX_NONE report before it reaches a ring.
> +			 * Reject only out-of-range indices (>= DAMON_MAX_PROBES)
> +			 * and, defensively, any non-positive value.
> +			 */
> +			if (pidx <= 0 || pidx >= DAMON_MAX_PROBES)
> +				goto next;
> +
> +			/* Drop reports rejected by the ctx sample filters. */
> +			if (damon_sample_filter_out(entry, &ctx->sample_control))
> +				goto next;
> +
> +			/*
> +			 * Select the address that matches the address space
> +			 * the targets of this context are monitoring.  A
> +			 * report that carries no address for that space
> +			 * cannot be credited.
> +			 */
> +			if (damon_target_has_pid(ctx))
> +				match_addr = entry->vaddr;
>  			else
> -				damon_update_region_access_rate(r, false);
> -			max_nr_accesses = max(max_nr_accesses, r->nr_accesses);
> +				match_addr = entry->paddr;
> +			if (!match_addr)
> +				goto next;
> +
> +			found = false;
> +			ti = 0;
> +			damon_for_each_target(t, ctx) {
> +				/* pid targets: match the reporting process */
> +				if (damon_target_has_pid(ctx) &&
> +				    pid_vnr(t->pid) != entry->tgid) {
> +					ti++;
> +					continue;
> +				}
> +				if (damon_credit_report_bsearch(tbl[ti].regions,
> +						tbl[ti].nr_regions, match_addr,
> +						entry->size, pidx)) {
> +					this_cpu_inc(damon_samples_drained);
> +					found = true;
> +					break;
> +				}
> +				ti++;
> +			}
> +			if (!found)
> +				this_cpu_inc(damon_samples_no_region);
> +next:
> +			tail = (tail + 1) & DAMON_REPORT_RING_MASK;
>  		}
> +		WRITE_ONCE(ring->tail, tail);
>  	}
> -	return max_nr_accesses;
>  }
>  
> -static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
> +/*
> + * kdamond_check_reported_accesses - drain the per-ctx perf report ring this
> + * ctx feeds.  Called from kdamond main loop after each sampling interval.
> + *
> + * Each context's per-CPU perf ring (ctx->perf_rings) holds event-driven
> + * probe (probe_idx >= 1) reports.  A ctx drains it when it has event-driven
> + * probes registered.
> + *
> + * The per-target sorted region snapshot is built once and shared across the
> + * ring drain (it is ring-agnostic).
> + */
> +static void kdamond_check_reported_accesses(struct damon_ctx *ctx)
>  {
> -	int i;
> -	struct damon_access_report *report;
> -	struct damon_target *t;
> -
> -	/* currently damon_access_report supports only physical address */
> -	if (damon_target_has_pid(ctx))
> -		return 0;
> +	struct damon_target_lookup *tbl;
> +	unsigned int nr_targets = 0;
>  
> -	mutex_lock(&damon_access_reports_lock);
> -	for (i = 0; i < damon_access_reports_len; i++) {
> -		report = &damon_access_reports[i];
> -		if (time_before(report->report_jiffies,
> -					jiffies -
> -					usecs_to_jiffies(
> -						ctx->attrs.sample_interval)))
> -			continue;
> -		damon_for_each_target(t, ctx)
> -			kdamond_apply_access_report(report, t, ctx);
> +	/*
> +	 * Build the sorted region snapshot once for this drain.  If the alloc
> +	 * fails, skip the drain this tick rather than falling back to a linear
> +	 * scan (a missed tick self-heals; a linear scan does not).
> +	 */
> +	tbl = damon_build_target_lookup(ctx, &nr_targets);
> +	if (!tbl) {
> +		pr_warn_ratelimited(
> +			"damon: target-lookup alloc failed; ring drain skipped this tick\n");
> +		return;
>  	}
> -	mutex_unlock(&damon_access_reports_lock);
> -	/* For nr_accesses_bp, absence of access should also be reported. */
> -	return kdamond_apply_zero_access_report(ctx);
> +
> +	if (damon_drains_ring_perf(ctx))
> +		__kdamond_drain_ring(ctx, tbl, ctx->perf_rings,
> +				&ctx->perf_pending);
>  }
>  
>  /*
> @@ -4360,7 +4806,10 @@ static int kdamond_fn(void *data)
>  
>  		do_prep = ctx->ops.prep_probes && damon_has_prep(ctx);
>  
> -		if (!access_check_disabled && ctx->ops.prepare_access_checks)
> +		/* Page-fault sampling installs its markers from this callback. */
> +		if ((!access_check_disabled ||
> +				ctx->sample_control.primitives_enabled.page_fault) &&
> +				ctx->ops.prepare_access_checks)
>  			ctx->ops.prepare_access_checks(ctx);
>  		if (do_prep)
>  			ctx->ops.prep_probes(ctx, access_check_disabled);
> @@ -4368,14 +4817,18 @@ static int kdamond_fn(void *data)
>  		kdamond_usleep(sample_interval);
>  		ctx->passed_sample_intervals++;
>  
> -		if (!access_check_disabled) {
> -			/* todo: make these non-exclusive */
> -			if (ctx->sample_control.primitives_enabled.page_fault)
> -				max_merge_score =
> -					kdamond_check_reported_accesses(ctx);
> -			else if (ctx->ops.check_accesses)
> -				max_merge_score = ctx->ops.check_accesses(ctx);
> -		}
> +		/*
> +		 * Perf-event probes feed damon_report_access() into the per-ctx
> +		 * ring; drain it here.
> +		 */
> +		if (damon_drains_ring_perf(ctx))
> +			kdamond_check_reported_accesses(ctx);
> +
> +		/* Page-fault sampling reports only the accessed regions. */
> +		if (ctx->sample_control.primitives_enabled.page_fault)
> +			max_merge_score = kdamond_apply_zero_access_report(ctx);
> +		else if (!access_check_disabled && ctx->ops.check_accesses)
> +			max_merge_score = ctx->ops.check_accesses(ctx);
>  
>  		if (ctx->ops.apply_probes) {
>  			if (time_after_eq(ctx->passed_sample_intervals,
> 
> -- 
> Git-157)
> 
> 

Sent using hkml (https://github.com/sjp38/hackermail)

