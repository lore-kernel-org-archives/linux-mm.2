Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB18C79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 09:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018166B0088; Sun,  6 Sep 2026 05:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C776B008A; Sun,  6 Sep 2026 05:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFADB6B008C; Sun,  6 Sep 2026 05:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B94776B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 05:06:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 323544048A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:06:06 +0000 (UTC)
X-FDA: 85182755532.23.9661377
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4194A1C0002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:06:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CMKenUXL;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788685564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2FAXP4V+Cd6xM7XhYzDHUaRzuyzX1knyfPgLVsqqcWw=;
	b=oRPFiXOIDm3jLS0npNe090VwHnLwN7G39yULzz6FGPmMQFSnzrhLt2/OOLlN+7LRfE6O83
	+7M/YHncUTOHHwxwkpE6PLYJ9ysryRYQ5zQi/lprK4zCLwJCNRL4FE8hAX1D4X6RXU1Y/f
	yCPZ7tajvU1AgQTX1w18juH9bqQZdzg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788685564;
	b=0vrCMw/tyMQEMcG/aID5SFhTOlTjePzrywa8Pt4fatma7mFyXoruJl9ZteyjLST0tEP4b1
	nWqjPAcmboCZfKS0aBybkzM8+E0vjcS7pDjiJpYVvZmwpdkDF2U3WckukXM5e9mewk0++Y
	Rd4aIOsYxtjpon/RwkqAHh8Io441saM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CMKenUXL;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66FC843A1E
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459B81F00A3E
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788685563;
	bh=2FAXP4V+Cd6xM7XhYzDHUaRzuyzX1knyfPgLVsqqcWw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CMKenUXLXCCIEOj89UCR8qWkedc1FLATT5XkTebFY7x97yI1BCCpQnxFxr6n5vFD5
	 nqSERMDQp6+Y+5eiC27oR9nwUWvYElADWto0F4FLVUOnS2T+6V9ipFTelkz5Y93Qjo
	 xV+xxBd4vmRUurJ6Z92V9xZKe8K2HIQ+J94xM71sNDR9Jbkg9qiG9ov0g7URwwSY6N
	 Kx3NC9CWigdBbtRPTztyCdmFpxgrefy2w2HrMINMFcSsS2Foz+dXVAwwk9WluCg1Py
	 BkZhvmFnnIYB/xFSENMC+sR0OnVPPE8nJuZG+cFgmY34MhnHjzLA8V8jeDX2tCZ0Ww
	 K3ZvvexuUq5CA==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a0a4aa99bdso2923730a12.1
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 02:06:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwPtNAmdwISpk0Tx9XczMKJc/eaDJGfEcSHnNAmFlgpVm2VBbIfNH2178PzSf6WjmwO6AJqX1rp1A==@kvack.org
X-Gm-Message-State: AFuF++kiVWryiu/LWO7tjYGxvAPi/ut6X9vgDnWgRFligIdfPYHC/5h5
	D8yLdM1ofyKPfufaFq2l5xTOmPeHXICPlogQLGJLjYM8+7bJTPJ34g3t3MKwmTwG9faZDkmtlS3
	6mPZYY7rmreReHdHclYbtIoFsi7QOEsg=
X-Received: by 2002:a17:907:da4:b0:c26:1649:47af with SMTP id
 a640c23a62f3a-c26164955fcmr552326166b.37.1788685562112; Sun, 06 Sep 2026
 02:06:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260903215616.1456239-1-joannelkoong@gmail.com>
In-Reply-To: <20260903215616.1456239-1-joannelkoong@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Sun, 6 Sep 2026 02:05:50 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN7wAx6nin7m37hF-FfvwkLAH6UazfLNowKsqx+yCTjxg@mail.gmail.com>
X-Gm-Features: AcwNN1VVMxwmqoyjO_JhcvjsijdjCfwV_McCiPZvZqBjYTcCxh_B7OEp0XzlfiE
Message-ID: <CAO9r8zN7wAx6nin7m37hF-FfvwkLAH6UazfLNowKsqx+yCTjxg@mail.gmail.com>
Subject: Re: [PATCH v3] mm/memcontrol: skip non-hierarchical memcg-wide stats
 when v1 is unavailable
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4194A1C0002
X-Stat-Signature: esro46kk19xao9x4r3n1o9ch7eui1dhy
X-HE-Tag: 1788685564-847229
X-HE-Meta: U2FsdGVkX1+CtDIBVZemixpaSjDoxY1c3U41s/HfqlA/sKftMApdLGtmngTdBCXepRJ+Bum0wALNSjYpsVhwh6HvVrGs3uZ4185IW1aO1OjezyhDyhkx3ha2bhtSUd43aFQ0e7YfH4a7aqRVGtnkGjAXsvXkIChSGsqdQ7oaDlx/qGoSwcLMyEfAfXqeFowHS029ffqOlKji4L9x8LpY/Si4fkYSfcT5i6SXiZDqiUTrmaOY2KfeticcWu0MTeXZlbKc1KMVkbN0tSDuY7Y1cVIMjMWvtbBzk7EC9QNzuTNV65PdJ9Ir39a7WBsz+P8nePdaQxOibAfs5q2q/gzpkf6VdvIxxRRaMMfUjylH9qg2kTEv71WR0z6csKcIS1D4cfqNr6eVJst5U4w+wGnbeWxg48R7veU4DBpaSSz/R8Nh/Fi3Pni7l8ECyUZmN+IB8hif+O7cFyW8HgF5dt2PWW37f2SRX2YFA7g2aXmsXFOuz3Blxd1Rh3pVssHl7zIHBtGlwJT3ycpDSqQtN/0y3V4PAJB3tPNjuILp9xXQcw2S+LQyqg5jleX/l1EE3877k0jwD78TcOZ4nRWUdL+WOHDiC3ioIjTawDDNesTeYUu/5orwAn6UktZ++XMNFml9MGm6C5j5HsgGtT9DywcgBuDrKMBXoaHXVxrX2AEDtFiEDLUnnFZDNR6Lahr02Aimkrzca8BSKkHt6fcpbZCwJvTW/gcRkBunDhID89HiV4vTjVwuCtpBextTBLkQpRJ3YwA3ESenNAniGVF9MWvnTpo8ourLELI2R0pEAZWCW+I5Wfcs1u9D6wHWWeGhEdubWRGj9A6gYOZ9FN4ARekpud1sI7ItcDPndLkk1bgK2Hwi46cgN1Ea746G5eTKIZ4WGk/m4flQ6r7frOOmhh4/O/87F1YZYkmvhF7Vswn+m/DiSFVh/f8lWy46rNbN7XSqCwK1BJyjh0lVUN7s+EZ
 fP0EPSf7
 E0INtQYfRqVC4v4MYaQnBpRPLVYoVB6nBOFP0Q0nzyd0t0gVIZbSUpHjuTE3GjXB8c/GHtXWQxZkirzUwGmzPhUzJYkEhBT9U0BLdfIqS4Uiqku6r/nbQfMsKw4Gnv7zhGUIovDpfiFya9GFWMopAP0yjTUzq8tt4XT6gtnK9wD5QmaQgiZ3xbtE0m8RxnJ3hUpbcAnPh9e50N8TPvMAYepUXq0xwDIlR28tkeQ1LWKkoCDLMv3lNQOWkzO/YmQY4AWm6HXx6fbHkuknRR6REEZKKxNEqxgvtsL+K8FXz52NfkvS4huAK/MZyn5zgMVcKG72IX1jrOtGHwmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 2:56=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
> and event alongside the hierarchical one. The only readers however are
> the legacy memory.stat and memory.numa_stat, and reparenting on offline.
> All of them live under CONFIG_MEMCG_V1, and their accessors
> (memcg_page_state_local() and memcg_events_local()) are already compiled
> out with it. This means on a CONFIG_MEMCG_V1=3Dn kernel, memcg_vmstats's
> non-hierarchical arrays are written to on every rstat flush, despite
> their values never being read / accessed.
>
> The same holds when the kernel does support v1 but the controller has
> been blocked from v1 hierarchies with the boot param
> cgroup_no_v1=3D{memory,all}. A v1 mount is refused in that case, so the
> legacy memory.stat can never exist and the arrays are just as unread /
> unaccessed.
>
> Compile out the non-hierarchical memcg-wide arrays if CONFIG_MEMCG_V1 is
> not set. If it is set but cgroup_no_v1=3D has blocked the controller, ski=
p
> updates on the arrays.
>
> This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
> read-modify-write of ac->local[i]. Nothing else accesses state_local or
> events_local, so those cachelines were getting pulled in solely for the
> writes and they are separate from the ones the loop is already walking.
>
> On an 80-cpu x86_64 machine with 500 cgroups each running a workload that
> dirties anon, file, dirty/writeback, slab, kmem, mlock, and reclaim
> counters, timing mem_cgroup_css_rstat_flush() in-kernel in TSC ticks per
> flush showed roughly
>
>                          before   after    delta
> memcg-wide aggregation   1231     1180     -4.1%
> overall flush function   2452     2397     -2.2%
>
> These numbers are from taking the median of 70 samples, one per 20s
> window on each kernel. The 95% intervals observed on the two deltas are
> [-5.41%, -1.76%] and [-4.53%, -0.14%]. The values above include the
> timing overhead itself, so only the delta is meaningful here.
>
> Counting the items that actually changed, a median of 1.5 of the 77
> memcg-wide items (57 state + 20 events) had a non-zero per-cpu delta at
> each flush, which means the benchmarks above are with one or two fewer
> cachelines pulled in per flush. The count is low because the benchmark
> reads memory.stat in a loop to keep the flush rate up. For cases where
> flushes are triggered only by the 2s periodic worker, more changes will
> have accumulated between flushes, so more cachelines are skipped and the
> per-flush saving should be larger.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

