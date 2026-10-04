Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3ADCCA5FEC
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 09:10:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C286B008A; Sun,  4 Oct 2026 05:10:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC536B008C; Sun,  4 Oct 2026 05:10:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE946B0092; Sun,  4 Oct 2026 05:10:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2B5C6B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 05:10:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A98C160A9F
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 09:10:37 +0000 (UTC)
X-FDA: 85284373314.01.105F865
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 804CB180006
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 09:10:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hanemzs8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791105035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hn1knN0Ne9g7tVudusR3tVlb1NSZVYCjpb+Hy/EfMyI=;
	b=LafCjb58RqDsnD5KxKvJSjf9H/tVtr5Udg179lw+xYJmUzMAYLeqal2yXJfM6J67l4e5yo
	/jNy0u57PZm9FwMajDuG2Cwq8327NcPRrImLSsa+EuH4CPv7DKusZXfk1V48SftPtKLAhc
	K5d01wJPBirOlGbXaTUqPw/xgbezd08=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hanemzs8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791105035;
	b=OL6dwanNvV44Viqo+z7cU7fMVpiySLYj4cTDID/bNh69UkhW5sB0588UzWMT7ZChL7iYbS
	Fza8KqtwdC2egKaI+FpKc9s/1YAxGIETOPGaMqXBwIp9dy0rGm9s0g61ed9awqbgcCES5P
	5t4uVqfPwJgbAsoyQTmUIGIdWglOQ44=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-88c72646f03so343520b3a.2
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 02:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791105034; x=1791709834; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hn1knN0Ne9g7tVudusR3tVlb1NSZVYCjpb+Hy/EfMyI=;
        b=hanemzs8I3vs8nDpG8SqFAT9KxWCGd8GMIg9iS/yWmGut5MLz0sHfwtWIrsaKSldHr
         Iav6npHvJRUinxDiJcCeeTCxO4t+AQlXM6pJvaOO7vXjCFgsRpCpfmKCKYhCH4xdnT/e
         9a6FNuboywQ/FsZ79R6DtRhkiny4Z1sx7nqCrqEwk3g7sF0tWhbqYk+c4fJmy7hqE2QU
         bFC44K2UK2bzXuJPBfrffhqxEAn7F2BbxCWQPzcH3gOaJa5lrC7bu9Ra7ADy24Tmzk2m
         sAgqwcKimvwuqCuLfNrrzvQdJB32m8POHmfxDkwi2IrmjpQIWRMG4+wApmcG+567OV0w
         3A7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791105034; x=1791709834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hn1knN0Ne9g7tVudusR3tVlb1NSZVYCjpb+Hy/EfMyI=;
        b=Mjv0wrSopmNQL1vl2NeRZBhoNkj2KLtqgbHBhV8PTKqAPzt5pTwwMuywhCSNYsgiNg
         4K16EUfyuKFpTDz1+J2G1/Kh18/bir/OKn5VMnwpq0ZkSE8/DSf57Dv5jt76x83GFVNU
         X+Q2M81t3FZOf/0Ypqq+xvQghiY0DArpGxLAC8FWhZwE2PAH3hHxzOow5D2ycaqSwdBc
         v+JQiijJ+kXoW2n1DcfC1uIUxwyYwmv5n8aw0DK1rcTXZZJpRzkbMMFAIZZtUUQv4MKf
         T8HuiZp13L/STxERW97Z7hniwuIGlb51EQN3LFkS4nxAln9hi1N9KbNc98tDiF9G8LJ0
         EDZw==
X-Forwarded-Encrypted: i=1; AKwUvBx64Gr0Ezjm8al94ntIS/pXOa40kF/gx1o5dFkSw77hZeKSRaDJrz6tTUN8XKLfCQ/uOcv0PRAraw==@kvack.org
X-Gm-Message-State: AFuF++nUsH9fXoXcum57A0G6jW0paS33tR0RdNIP2mylHEyUCXV/Cqoq
	NpMCpVihrIw6+Xs0mzRTYOhoBC156kqqRIUgsuwjkeEc2CvCTnMHoelA
X-Gm-Gg: AYBFou3EwQD26NWtTFWQSHJh75BpXL97FPwItgu1/jPjquFTxvNbBoASDVnbDH5a3YP
	YwYQjOVR4e/AIktx5o0Upgd3R/q7hCJcy1dFi0DBTySzTZG5TT3MJvvaKxhC0VIc+vVAM0Z+xlY
	hIXUJW0XVQjxuztuO3VKJdmV6GdXYG4fcfu4Le1io6rbCekCQADVQfeZGUuTzecBw6DcrjchvlV
	Y0ijtXP6ukGsyk5UmJSA8vTueWPMUtavFqvwRjtrN17uf5XsN85eteNN98eT9yWY/UIQ9FkYt1P
	h7JqHShU18Ald4ngN6kIQSPE1M2owI84sPfAKVkp1JgfBaUZJfR1oB/WpR2uLKvkbmQm1NaCUOZ
	MZDXcrC6Zu6baugOaYTUlWBkhQ1uCqKjNWhg2EFSKhhquftX+yOvr3H5tIfm4fNRhXm2xdCniyo
	pMpIu140gsXCbFLDN/NJDkA4DMpMAsuSBx7uV0zhG8MFf0eel1/5eP3BSmjPsPLk/NPkh9
X-Received: by 2002:a05:6a00:14d0:b0:88b:af3d:2891 with SMTP id d2e1a72fcca58-88c628fca60mr3777134b3a.22.1791105033760;
        Sun, 04 Oct 2026 02:10:33 -0700 (PDT)
Received: from gmail.com ([185.220.238.43])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88b0ca7c6b7sm2374693b3a.44.2026.10.04.02.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 02:10:32 -0700 (PDT)
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
Date: Sun,  4 Oct 2026 17:10:21 +0800
Message-ID: <20261004091023.630362-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-2-0f00417b41bc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zd383ofqpeahh348rsatdb4g4pqs45yi
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 804CB180006
X-HE-Tag: 1791105035-807130
X-HE-Meta: U2FsdGVkX1/xJvB0o/COe1cJw39GJgxoOHo1Nc8NoHI0MDMg+Cz8K5/uRs99w9xDJdlfx2/BXCsEjqBBNzh/X+MjrhGZnUST+E0DZz2m3z1m0Pt8y2pHfwF/8/VbF/YrYNK+OQU8TW1FwYJ3xX8Ra7RAPCD87CVdAcxyQZsd05CEWcbjFL6/i5byNQNND8Lz76tRv23tjDQt5L5q2AJ9KMuXWvY0blWnXoY3kBwbo6SkeAosJgLHgSieDQjmLGGHywPMR2uYX6qEdzW0Ncq/F+2xTMPMJGcIMFItlDc04FyoEIRvoyfC/4YCu4gBXBksbbIXkAzgjvq3v7mIcz0H1zeniS/4kjkMOiDQmhI2zKZXdfhvSFKCpwtnzOKgQL7GOuTSLb7RIidZGZKHpuavBPF7mAikHVEnupHrXX7uxs0Q6M1R9yiruDTgzUiDaOIm9q8AYbmmn/a6HlJEC9wayRbqASDZXFNSSsPihs2NmD0ihxnYdlV4NWdouRkD/Zexr33a5mTcYLZoKt+1J808qX6j/+TSeZBIqw8noDPb0zs1/j0VAORf9Cd9+ykgu97DV8mg31m9oIJgNv3gEJ0lFhvBbX0JxyYGR9D5D3v9Ki21L4Tv2guBqAT0rPDSmw6NJhHp8QLxvMVG5cJa9Q8AHocGuy7oDShLHMK315IDEqtDhGQjJPnI4oNQtbdGqMuRgEcLrSse0bG5VSQRqeSPcmcnWKTbSwXEdDHJNJvBeaszBhFn75T9K85HacJXsVJWkHXVHLPNjRPbJrI0CE13II7MogjEETjZmAL/PRVtfz04qHgZWVuTTjKZETWgo/3hYDGfUTUvdkw623HDgcRYKyhxcW4kQkJ61W9R0rOdM5YKdwAT584EuFtLsd4fE2ho5gzZVLuWdIKtXn9ciRho6zESYtKYcIUU7ajQpVKdphSer+s1NP3A77l0fv3KSOIsinY/DdADtYKxH3ECYJ+
 TurVFVbz
 uOVA1PXiCJy5q4maHrZD1ejzTbJaIMauFU4Tm5c0S9fbsEDRoLMZedHyLP49NNjOZW1VMvx2DMtq6uqNkAxaZQD8aDVScUWeu9e8FrmLomLBswYpmRHqFrjxI4Dg0rmdx5oECOriJ8INepNMqzu8Z992sPGmK3OSuNCB/pfz7TDgG+lkB6q6/ID98EejreWF1hVPMlpWHaUd/3Z43lZ0hj/wzM6p+xfpOInRjlJw0Eh7PVMSfJSQF/M1KEyaNFEhM9KxHGtxhXyxK50CG/E0ulMxuUNgp2CvLUQBSfFSq9QAinvFiVVCy/NorsJPtpLiVcHUMmaKo9HLV7bkFJOkFFltxgEe1sTdSpczOzuKEi0o7fLMjHw3NG4lMLMz4YShx22AAYV4HsJNcc1K7u2R1roH+TmvmdhEap4w4Xyo2Jn/P5CDTReRsoFbx+ZyoSsPCxnPHa5reqPUc+nb1O0/XNA1BdvDz0IKlzLTq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 03 Oct 2026 14:07:55 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

[...]
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

Hi Ravi,
 
I noticed that ring overflow drops reports and updates an
internal counter.

Since hardware sampling is used as an access observation source,
could userspace get any indication that reports were lost during
an aggregation window?

Without such visibility, users cannot distinguish an aggregation
result affected by report loss from one collected without loss.
This may make it difficult to evaluate the reliability of the
observed access information.

Thanks,
Kunwu

[...]

Sent using hkml (https://github.com/sjp38/hackermail)

