Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3525606A333
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 22:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=Tf7mqOrk
Received: by kanga.kvack.org (Postfix)
	id 5ED616B00EF; Wed, 28 Oct 2026 18:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597766B05B1; Wed, 28 Oct 2026 18:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486666B05B2; Wed, 28 Oct 2026 18:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 234CB6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:12:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96E0C801CB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:12:53 +0000 (UTC)
X-FDA: 85373435826.07.D91DB10
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6B00F40004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:12:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Tf7mqOrk;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793225571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E156o5IaTei0VRN5zZ4yWq6/WZqYeNZwAw/ChZTmR7E=;
	b=aYJ+cF8K+Q2FjxBk58JighR+o4JFdEcNVlXrhYbwtqcjNcmElc5SDMeIKywYWERFEsfBQ/
	JGblC8fDyjc9vhKymYUn3WXiwtksJ2J0NxpPYvgTUuGmzZEnhBw2ggCdDv298RwpT8TRwe
	BzptihS+ezOji+66lnduHJX7U2VUXmU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793225571;
	b=zwPDZUmTEmImrLLyBDCNgqYtWFiAz6gTlAu8wCDQypZDgGZOlryCEo/E4SLgK5X4wqZFHv
	IVNl7CSY7qphwbxloJWDgu4u2VZ8pspl3rgkVduGlEaJ5bKfHVIgS9tFQ4LZpMP5YCqxzI
	HnEBQ10nor8HNQsMD8SIANs+x+QNvDE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Tf7mqOrk;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b0d63f60bcso13692327b3.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793225570; x=1793830370; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E156o5IaTei0VRN5zZ4yWq6/WZqYeNZwAw/ChZTmR7E=;
        b=Tf7mqOrkwAxSIzRWIMzUXQ8QpJU2mkh2IZLRgM652ztz9DKZNWOvuqwXhXrGaj7bOJ
         AyIZ976r2587RBYmhrd6UrEohW9KtZ8g5/H5jT5kvn7oLtl+IOG9K0um3ieOCxgHoN4J
         d7O5YZ7n0u4lw45ueQK3khkll3wm9cPKnCsiT03mYw2du2YIvB29t+BH2iDl8x02m96d
         7vX+BdcNNbVPqrwK7cEXTgNBd/T53jRzLjWvYFzOUoTQ10rzikIWhFZ8lJfIiO3D9Lz1
         4o43OU1AmPZBeTupbj1e2aVex7+jzd+rJIU4kbRwR2emXT0cx2/fjH1sBrH8C1hFQ8yo
         HHPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225570; x=1793830370;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E156o5IaTei0VRN5zZ4yWq6/WZqYeNZwAw/ChZTmR7E=;
        b=2v4JgJeIxBTe+lvjMQNVohdVh3yd8iVoaXM5hU2lLsYMGQvj4JuPc2Tkfyi3F6SCWP
         rEmEgZvWIGOlcdaz37QN/3IriGs5PDodPuqVGkRDJZ51kw8zN7qeZYrpFkk/qrChhpEN
         kBw5HjYiR0x6wxS8SPjZnzbfKPPGK//iTmcyHVT2aHVnon4OPGSQ5d7NzbvgYHm6BSWd
         tucRMOgoDGn/A/opu9NK/DO3/qxLgvAEN/0Cd4cIv6wqI6H/plfLKuSM04DvASKLlR+O
         4MHUno25jpyUduj4ZPzB0Xq2pXUZnTGfLjwOaMSfP9HTTgxjLNp6t7x1T1zT38hSEgya
         /0Bg==
X-Forwarded-Encrypted: i=1; AKwUvBxZwg9VsPUo5w1P+iK9j8u203NC+9NBsQ6V/7or2huxAVIFpWNZ9vbOjXSqiBcZft/fQrUkIurPfw==@kvack.org
X-Gm-Message-State: AFq9FYImrDGab0F4rPTd4RV3EbqHTikRGA6HpSOrqAAoqzTnMmC4GF2g
	ak3LOXxoWjQPTUX68yF8aDe+Dp6VfGMbiRwM9ZCkJrEzLcaqS1+5Yapb16YLiJSAMP4=
X-Gm-Gg: AYBFou3G/PTTJoCQFX1cmZDQrxWSZ8PSE9Lncnt/CxKV0nc9cHfRvuapU0o4hRNjqcW
	kUvUjPsevoObLQjJ7UiFIPFYYed5LwZSiSgwuzqt65tBynuD5nZ4C3G2Yod5bPcA3nxmiQzDWJY
	WkDlERx7uvDPILTKc6z1FoVrGUIkH7gdQeSxpJNLd2g8Rdgc4Jl0CVaTEIrsS6To0UgTyPtJig+
	pJDVwwE541rDKM4mCTnO+ugVaJTBB5ft2a6x+e0a3E36+r8e7go8h01HiHx6lZxR/XJ8CPosVKF
	zigTZr0iavCEYq3v+XXyHLXasOSwYMFrvQZ/Y4R0631z+PNahVge8yRMjsDL3lwvDADtM+8aF9n
	PcZ0eCBjHbqUXFSRaozTKluhtbMDIMFneDjuItPkP+tjFasgabZ0HuiptGDuMgvdc0LHJKunkBg
	/wtE4nOkYfRUXriw5KRDoRb1quG09h0ZlsZvInoDp9ZA5jNcDlhxMHjIarpnvsXHBBJQ1qxRR6e
	GGMl+Zsm81PSyrrE3h5t1g/lgIuGD17wUgx4PCjY+wPxYi4Z8Yyad3OqfWTyxU5UkjkrN3YOP6H
	lqBu6wSBLycbvqzKMuzV9J5D2hum
X-Received: by 2002:a05:690c:9e:b0:891:faab:ff1e with SMTP id 00721157ae682-8b1b595b1fdmr25465837b3.4.1793225570125;
        Wed, 28 Oct 2026 15:12:50 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b19e5b40e0sm36335447b3.26.2026.10.28.15.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 15:12:49 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:12:45 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	akpm@linux-foundation.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: memcontrol: fix NULL pointer deref from
 high_work_func() on dying memcg
Message-ID: <auJzXV3nnPZA5GSr@cmpxchg.org>
References: <20261028183537.605854-1-tjmercier@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028183537.605854-1-tjmercier@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6B00F40004
X-Stat-Signature: 3qtdu9jjngns8b49ascp9ks1d1hcdgbj
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793225571-888501
X-HE-Meta: U2FsdGVkX19i76smkC0Sc0WDjqBRpedUntL6/VEHkX9wDcmSVlhDYV5ZFguemLEogc0ZDWyekqeiiS9CtMbCGZW3Xcvg6cbwKWCUaNI1WGkSHPr8UKdJqzN8MAueNkB3H/K4efI2tm3/s9ah3hny0fKSoEdtRVZU5crCXxGiPc6Ggiv8Hw3EvBzD9z+mxBS38gVFu5pyUM1SnHoOO8J6WHGNktQM9Ddykz1/6MldV4/rRmyER7itB0dkRcGAHHkl7iy6A3LTfVMOrLXHxa6B7KIg6wUy+EghGeoYASF70G2llet4ZAr/33i/ABPNt47inRwU5oFuN/XtrpptywiZsnM2HsYdy7cm7/3aXrwovU4VaExGW47ME/7kKoJbd6Pk0LWr+CAWaMMgHuYRNLcSSS2p3uqQEBhxzj0RlehbDKHZ57yeXulabYULEuz5kH1x4tbGGde37ld0rG8M07ndJ/OIujyuVNoYLkWAvIHT5x/0gP76VEoIG1PPlT0fksZ8rJR+6Brk4qbawp3yFY4SdOABvmUyLgA3Bnh+Bmjf59RljHUx8iJZUiKBpFWtk4zt0cwMZo7zR3EjBFdhdjCbTk/lR7txTsLcdNkglH/ybpjmxx1OgbIRsiZ6uT3/DX1h+lF9KahnbwjFJgqlcjuFvfCqOnOmwpFw3keii+v3iSAgBH8rmPBoO5JktLFC+MN/7LPeXq/Guf/9++f1csuLEAvHCHg7iQucE0kkLFjRfQP0eCpZMQr+BAG8gTWGcgsfbGn35npGoafHl2bB2DdcZzl1zMMVKuFsD/7EJMG5eazafr72YXVzKa3teJ/QOTCtoDzyubkji62pOdwBXamUv8ZcpBusC3x6fBP8sxoa24LTsAzMVYguhd1MfZRN+C+LpWCWTye7itCA70cKsrK3FNCxLc6iMg3x99t93+URfLoBz9MdCciEma82ZWNdzxrDTPTSuNBp2sTc5zQ59EW
 vg9fzbID
 RoD9toUQrWkJCvk8Plx1gZ1+M9Ec6OysdyC/TvOb7pUv9+YZWq0sKxCjLDRwhP42z5HEj7Pn3EOZ9O3WfCkHeLzzAmq2JM9ojTbMa1DBfC8fOx9o6KfzA6h6c7VR/YhVCgR3XP3fyJyuonAFeojpuvmf6hpSXuE9Gjvbw+sZyGIYcUmclq7GZ+Y5oGaoIxikc5Z5bbcS+APuM47l0+yn5fFDFtNDrZsjI4qBc6Hq2GqVLQGpsjC4TCN5ykkuNBqBW++X88Zt/5eON9mvh/1wS5r2id2ycZZJKb149SCwnvkptuRtlD5m74ltj6MNHsN6PbEN4s+5CEbKKZsgyQhn9z81boeceBB4bjA/2J+txGEIsUHCFeBmJtBdvo7TnRyO8d9+0l51fzs1aNOUAabeMURQGFhjw/+ILlrQ9xoKOAYlV+cPBr6X6Tu9SCl6kIHf9+d3jwywbgn2mwbxzHsFNGP2NNMmrl/SdEnmeeI3IIvMtTq5Kkp2S0lzFb7EmZ6X34nqK6rQNcwjR/DYlav2oUZk6Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 11:35:37AM -0700, T.J. Mercier wrote:
> When memory.high is exceeded in non-task context, try_charge_memcg()
> schedules memcg->high_work without taking a reference on the memcg, and
> high_work_func() invokes reclaim_high() without pinning the memcg.
> 
> cancel_work_sync(&memcg->high_work) only runs at the end of teardown in
> mem_cgroup_css_free(), so high_work_func() can start or still be running
> reclaim_high() after mem_cgroup_css_released() or shrink_many() has
> called lru_gen_release_memcg() and unhashed lruvec->lrugen.list. If
> reclaim tries to rotate the memcg, lru_gen_rotate_memcg() dereferences a
> NULL pprev pointer.
> 
> With obj_cgroup reparenting, introduced in commit bf4f059954dc ("mm:
> memcg/slab: obj_cgroup API"), objects charged to a child memcg are
> reparented to its parent in mem_cgroup_css_offline() instead of holding
> a reference on the child until uncharged. Subsequent uncharges of those
> objects go to the parent, which can leave the child's memory use
> permanently above its high limit, so any later charge on the offlined
> memcg in non-task context schedules high_work.
> 
> This problem was first exposed when commit e4dde56cd208 ("mm: multi-gen
> LRU: per-node lru_gen_folio lists") introduced the memcg LRU, and was
> later widened from kernel memory to LRU folios when
> commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying
> memory cgroup for LRU folios") converted LRU folios to use obj_cgroup
> reparenting.
> 
> Fix this by acquiring a reference with css_tryget_online() in
> high_work_func() before calling reclaim_high(), and by resetting
> memory.high and swap.high to PAGE_COUNTER_MAX in
> mem_cgroup_css_offline() so that charges via references on an offlined
> memcg do not trigger high_work on the dead child or skip checking live
> ancestors in try_charge_memcg().
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 27 Comm: kworker/1:0 Tainted: G    B   W           7.3.0-rc5-g2bba28e98578 #284 PREEMPT(full)
> Tainted: [B]=BAD_PAGE, [W]=WARN <- Taint from lru_gen_rotate_memcg() VM_WARN_ON_ONCE
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
> Workqueue: events high_work_func
> RIP: 0010:lru_gen_rotate_memcg+0x1a3/0xe90
> Call Trace:
>  <TASK>
>  ? read_ctrl_pos+0x22f/0x3f0
>  shrink_lruvec+0x16cb/0x1b80
>  ? ret_from_fork_asm+0x1a/0x30
>  ? lapic_next_event+0x15/0x20
>  ? clockevents_program_event+0x2bb/0x6f0
>  ? lapic_next_event+0x15/0x20
>  ? __pfx_shrink_lruvec+0x10/0x10
>  ? __pfx_clockevents_program_event+0x10/0x10
>  ? _raw_spin_lock+0x84/0xe0
>  ? __pfx__raw_spin_lock+0x10/0x10
>  ? kasan_save_stack+0x30/0x50
>  ? psi_group_change+0x381/0x740
>  ? __pfx_sched_clock_cpu+0x10/0x10
>  ? save_fpregs_to_fpstate+0xc4/0x2c0
>  ? finish_task_switch.isra.0+0x1de/0xac0
>  ? __schedule+0xf62/0x42c0
>  ? __pfx___schedule+0x10/0x10
>  ? __pfx___irq_work_queue_local+0x10/0x10
>  ? shrink_node+0x626/0x31e0
>  shrink_node+0x626/0x31e0
>  ? ring_buffer_unlock_commit+0x11d/0x5c0
>  ? kswapd_clear_hopeless+0xa0/0x150
>  ? __pfx_shrink_node+0x10/0x10
>  ? 0xffffffffc0000095
>  do_try_to_free_pages+0x255/0x13b0
>  ? ring_buffer_unlock_commit+0x11d/0x5c0
>  ? reclaim_high+0x10a/0x1b0
>  try_to_free_mem_cgroup_pages+0x1f9/0x5a0
>  ? __pfx_try_to_free_mem_cgroup_pages+0x10/0x10
>  ? irqentry_exit+0xc6/0x670
>  reclaim_high+0x10a/0x1b0
>  ? __pfx_reclaim_high+0x10/0x10
>  ? process_one_work+0x5ff/0x1030
>  ? __pfx_high_work_func+0x10/0x10
>  process_one_work+0x6e2/0x1030
>  ? __pfx___schedule+0x10/0x10
>  ? __pfx_process_one_work+0x10/0x10
>  worker_thread+0x422/0xbb0
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0x2cd/0x3a0
>  ? recalc_sigpending+0x15c/0x200
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x368/0x590
>  ? __pfx_ret_from_fork+0x10/0x10
>  ? __switch_to+0x588/0xf50
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> 
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Cc: stable@vger.kernel.org
> Signed-off-by: T.J. Mercier <tjmercier@google.com>

Hrm, yes I suppose the work itself keeps the memcg allocated, but not
from going deep into the destruction sequence. I was briefly wondering
whether mglru shouldn't move its callback from css_released into
css_free, but I think your fix is more robust after all: don't send a
barely allocated memcg down the reclaim stack.

The _online variant of the tryget seems somewhat unnecessary. There is
no real harm in reclaiming an offline group - and it was the standard
way, before reparenting, to garbage collect an offline group with
lingering pages. With the updated Fixes, this would look odd in
backports to kernels without reparenting. The PAGE_COUNTER_MAX reset
would also cause reclaim_high to bail.

So I wonder if css_tryget() would be simpler and just as correct. But
no strong feelings either way:

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

