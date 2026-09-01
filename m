Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 050B3C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04EC16B0088; Tue,  1 Sep 2026 19:42:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0262B6B008A; Tue,  1 Sep 2026 19:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA55E6B008C; Tue,  1 Sep 2026 19:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE4706B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:42:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B84C80588
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:42:34 +0000 (UTC)
X-FDA: 85166820228.30.8FA0348
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2230A100005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:42:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahVsk5ab;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788306152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjwEru2BaocN4L4JOnAlUtxbfajrtGVgmkUYz0mgZkc=;
	b=VdDe0MX8swDz/zUz6OXxdwWjD8PhhAxjog0usdLgPVGajy9Bb2+iIfG56CIiAbxDhb16D8
	YWXLTz7WfFWe58EfmoBaCDZu7l7ng6g/67qF7oMeMmLgQfhCLAm1uWP6M1/AXenomktH40
	WXukNZQj/q4OwCWIFU1zYcKLVUKZzho=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788306152;
	b=hC1S5kp+S8vWHF5poXFg5AHE6vlXc9N+vFub35a7gVjXupkwM2VJSrephRmQTgouvgZnQi
	Lf4OzvrXMsCbpYIg4ELwJhLxyH4qwma+KEL0PAtc+vBKogqlelGNrnOLOWN5AiUCc07yd+
	6hDnnkQ7aAO2QdU3N6HcVVfAmy/GaxE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahVsk5ab;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3ECA74132E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D2F1F000E9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788306151;
	bh=GjwEru2BaocN4L4JOnAlUtxbfajrtGVgmkUYz0mgZkc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ahVsk5abrzmFa2pS9IiNOFAkAgZIO6VRkFSkjcpU2U7X9srVrCDBYinXUJsorILY6
	 zHPGD0M2coV1PSCGAv/sDgvpAl7dyoBoBxFICkCpzAhN8aCO8/ENUMfv9tP/C/XsXP
	 vzkvovUutVORbzIUwUDPEzV0QfDc8OnrHX6ms+vf3lXd+O5tTpL6h/dyITJ8NeKw7B
	 B1r8bQrkPvxu5chtsz9M9L019kl3WhSxxzb3IFFVbq1Y1t87c716monSkZ+jM9ZeGS
	 uunYjT7U6b5xW1/CRxRA/BPh4iPyHk1skZN2Apr9L1AsVVglZifuvdhMMeNTfwQBk/
	 mEd9IUGrr+01Q==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a5ded53570so658047a12.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 16:42:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqv/nrsxtC/x4xKPQISQTmZ17BrNszYXAZ4aY6IDR/VtOWcGXZGeDsFwYlnR9Gug8k7rybeiMpqrg==@kvack.org
X-Gm-Message-State: AFuF++ljEmAZmWYJxn+FRCJ4AsKSUIAqJrnCkJHC722TV5r1bvRmUda8
	kulhM+WohG92Qfh+c3aqwA8Q5ENbKrH5R3tRQU6C6l7t3PmYscv6QXTLAnSTApGmfwnh+BLAS7/
	F8oPAU9tl+vHRPQE8dmBB9/Ziaa2ON60=
X-Received: by 2002:a17:907:3f9e:b0:c25:32ae:a6e4 with SMTP id
 a640c23a62f3a-c25d5276c08mr47951766b.9.1788306150004; Tue, 01 Sep 2026
 16:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260901232834.22221-1-joannelkoong@gmail.com>
In-Reply-To: <20260901232834.22221-1-joannelkoong@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 1 Sep 2026 16:42:17 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOTd5HjbDfMXuh+VHLGCAkHwyKx4CV-rjgBuxTpEZ6THw@mail.gmail.com>
X-Gm-Features: AcwNN1VLQyfDp7XP9T9t8iAAeQ-yNELmTvSOCFEKyDLZtzmygwMEeQQ_pzGaRBY
Message-ID: <CAO9r8zOTd5HjbDfMXuh+VHLGCAkHwyKx4CV-rjgBuxTpEZ6THw@mail.gmail.com>
Subject: Re: [PATCH v1] mm/memcontrol: drop non-hierarchical memcg-wide stats
 in non-v1 kernels
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2230A100005
X-Stat-Signature: f6n1bnj76hwuz4ptb597srnprt9j7ia4
X-HE-Tag: 1788306151-343740
X-HE-Meta: U2FsdGVkX1+r2otHm23+2Cz7ii9s6c0wBOUZ7g7vVbP6aMVM6ZC7Lr70nD1PlQTmpZsT9twGG4UwgTsurW9b1Q3wbcvNMdrE27ePDXR4I8tY+OD+VHd02LX+SI8VfbM0WmW8LS/KPAS5kBTXqNM1moOuuMmRLHavScADMmUtkNtaM/pk1lnRanwHTyyl+Flk+aICnvEPRX9+jCP+3Dm1cY4WE14nePSB4MyzhJYtZnMouzgYTRSN8UDt8H/QnfJJ9JXYpGcRLjUVKRjrzM6MdqqQzgEiSBG88eZ4Ts0xPHv/GM/QZo+ynOTyPnbgPBiEdRavl+DpqZPKMSs/23LyyL2Qk3nrjiZBpGs4INWysoCLG9fuOeAt7hOPdqR/bhj0Bss0nvflAMi39MmzqiaqvkigLyEwu5zSrGXu6n14ykYN1StHFh+o/T4pwyeBd2YVGE1ur9EzUYDL74rwM/iMuvPbeP3uDCqtwK7Xp2mO6HSkIACjt9X+GQSBEmqwc9UfHEOBoTpUwAI3ZvgStkawVKN45w+MV4QBQz6SezpXHoKQFSqlxL29Q1Q7pMqTgQ97jqfS45AsowvFVAF6S0thAHkBPaLfA3M05LemJTN9oJU+KVMdZXKkKNXJFIu5I4yeOL4zhL48V40B7WlNudhQeGFOm3k3Yjv0NtSbw2luotohTsz1/nr40LuMAzny1LfrrQasWUFyIWX0+gWM26nCIP2zKiZ3R/GY1F6HZYwUL8PpoJvsXiRUqpeUDd/yYWMuEzp5xxQ8PXyMnGnCW2o4Hi8G4ouPKphb7por4rDfikaPatnzsHa+S0AZu8GbKbu4cVq+ferY5YIlUKCmNNseazsVIApqiyK/psc4efhRC7QZWj5YMT3P6B6rkYgDG/+r+I/ICsa4ZDp0bbqjiH0kzSh3HPEC4ww1o72fpuDVegQ7xHLNHl60dHySk4GwHmoZw/51BKkQkPIEV3ZSGQq
 8OYoUjXX
 zJ/QcN/ILPzRnY6wMOmfTuxImXioyNefKEZr/5bISGiWvex0AxUUSUIEcWn0pu6rKQOc87tGGfKhSq3hIkno/H8YDa6GCgstflfvduQkL81ioXHOhIZ0PZRqzjYXfAKlwChzSAd3PHcCc1+WwiZkZAjoUN2Ik8DX3nxojSWvCuuUdNGoCx/hHAUVPyNPW1DZ9Jmd75DsRQOfTHDi7qHhlOJiY/a/h705wCUU00UwcM+yKMm2k2MbqJEZAJ7mXXWwLo8OklmsXDZmCc8aQnQN2dY4KrdIZJ8G6nHkKk1X6DbrIeA6/mXHludyxTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 4:32=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
> and event alongside the hierarchical one. The only readers however are
> the legacy memory.stat and memory.numa_stat, and reparenting on offline.
> All of them live under CONFIG_MEMCG_V1, and their accessors
> (memcg_page_state_local() and memcg_events_local()) are already compiled
> out with it. This means on a CONFIG_MEMCG_V1=3Dn kernel, memcg_vmstats's
> non-hierarchial arrays are written to on every rstat flush, despite
> their values never being read / accessed.
>
> Compile this out and only carry the non-hierarchical memcg-wide stat
> arrays if the kernel actually supports v1.
>
> This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
> read-modify-write of ac->local[i]. Nothing else on a kernel with
> CONFIG_MEMCG_V1=3Dn accesses state_local or events_local, so those
> cachelines get pulled in solely for the writes, and they are separate
> from the ones the loop is already walking / accessing.
>
> On a 80-cpu x86_64 machine with 500 cgroups each running a workload that
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
> Please note that the per-node lruvec array is left unchanged, as that is
> not v1-only (count_shadow_nodes() needs to read
> lruvec_page_state_local() under CONFIG_MEMCG rather than
> CONFIG_MEMCG_V1).
>
> This adds no functional changes to kernel builds with CONFIG_MEMCG_V1=3Dy=
.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  mm/memcontrol.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 42 insertions(+), 7 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7ce50bccf126..b98b2d68c62b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -675,9 +675,11 @@ struct memcg_vmstats {
>         long                    state[MEMCG_VMSTAT_SIZE];
>         unsigned long           events[NR_MEMCG_EVENTS];
>
> +#ifdef CONFIG_MEMCG_V1
>         /* Non-hierarchical (CPU aggregated) page state & events */
>         long                    state_local[MEMCG_VMSTAT_SIZE];
>         unsigned long           events_local[NR_MEMCG_EVENTS];
> +#endif
>
>         /* Pending child counts during tree propagation */
>         long                    state_pending[MEMCG_VMSTAT_SIZE];
> @@ -687,6 +689,32 @@ struct memcg_vmstats {
>         atomic_long_t           stats_updates;
>  };
>
> +/*
> + * The non-hierarchical memcg-wide counters are read back only by the le=
gacy
> + * memory.stat and by reparenting on offline, both of which are v1-only.
> + */
> +#ifdef CONFIG_MEMCG_V1

Can we query the boot parameter instead of the config option here?
IIUC this should work even if v1 is only disabled at boot.

