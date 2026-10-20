Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80DAA606A326
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=tKYFzY4J
Received: by kanga.kvack.org (Postfix)
	id 9A6156B04EE; Tue, 20 Oct 2026 11:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977A76B04F0; Tue, 20 Oct 2026 11:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0736B04F1; Tue, 20 Oct 2026 11:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 520886B04EE
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:05:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A4CB120209
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:05:06 +0000 (UTC)
X-FDA: 85343327412.29.5CD37DB
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id C2FD9180018
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:05:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tKYFzY4J;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of elver@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792508704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lb3dQxzYe9UirhfM8OejxWBOIBGt1sWP11aSKFWiA/k=;
	b=jm76bWN2AkAwZ64cU6qQW0fuJzby/gC3aCPyRh8Ms1C03K+fgYPBbnNpCUSfaG9w8pyVsI
	nEohX0V+ig6UjrxS7nQpPg1s2i9/MMz01ZuIzRl/BiRyThK3sR2ZI4QTlbScP7VCFd3Pr9
	hL8mYVpUbPZWchtHw4XEuRgiVEV2pos=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tKYFzY4J;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of elver@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792508704;
	b=Nmawwm5Rl1vUBQ1v/+7IsGiVWVIsuVYwn4YK/uBkDYWUsgHJmKzgJCEEXLtNTWvbu++Dlo
	0dgRKy4MA4QPpv01IIF9LpzHs4Cdq0hwetPV4JAXu7ViYLRTiJSfmUDB2EDcFArB/gjz3y
	vDBXi757XsOyaku+LbH+VXMHhrQHVWI=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c423b145922so343131466b.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792508702; x=1793113502; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=lb3dQxzYe9UirhfM8OejxWBOIBGt1sWP11aSKFWiA/k=;
        b=tKYFzY4JleYnXVEKs46cTYixWKvck1dUfN/f3g+e7Y6WAt24TZ58gEefQ3tdZAGN5t
         ANO1yG4lT1eilfAwqEqdZgal9mf95RshWjxn+rxQFvOqiXnlD2F1uziB4MyZTZpAHUZY
         nc+GwoO04Rdu1gNvBmHUh0EHGtdv4ML8sTieJKO4lTsePzh24ol2L8oVZg745VP9JVg8
         YzerZSsjwctLS0q3qW7kBHHLKACGEmlQ/Z20sf9XouFWjTbRwIoMrXJ/7OVj6DsyuheQ
         aQvFlm4UGhgRc5xtctZH84xcW523SNYv48HH+UNfuG0tLsFsjENK2mDAhDJCGBFTODQj
         Eqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792508702; x=1793113502;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lb3dQxzYe9UirhfM8OejxWBOIBGt1sWP11aSKFWiA/k=;
        b=RwUldtN1MVQeO2ZMODzOzfEA9gYdXz5UlAKjUrqDFIXtqiLnj82xMMcBOoaDBtcgUJ
         RWKUATlB+cpoMDwRLq8xsC/iOQGRNX2+EpTl5gVHVeTooCfyobnFBAbSZo/5xE0nb9w2
         R94y6CCrzualm7Jt6DEqYzaamn1IYR1dm6CCEw3lDmNfCoeK2q7kVkHdotWyJ/VjII6T
         MLYAbKYOseRbDcHasLYXDyZqU1/5UB3i82IiI1CJQgjSn1cDvXW66ZwuteoIKCbbryvR
         MUsDEWELKcWdJaeqxqaPNiLarcb836b4NBdUXOhX68ogFuGPTS38+sQ1Lu55yrY0hE/P
         KykQ==
X-Forwarded-Encrypted: i=1; AKwUvBzVraNi8wWfuGieHCnYbR/Q+eqE+FPP0ulj1FRx+AXZTJKn2ylrta3JPy/Z4pfgXll8YqYDioudMA==@kvack.org
X-Gm-Message-State: AFq9FYIzP7LvQpJqa7+ANCz1mav73/XI17RoUABa7jt5OzDUPGyNsGtN
	1dzeFcJMeruYSG+oX38TNvy1FTG9b7roSUMzgej09Wcj17TF0qOZzmdRp0M0S/8HWA==
X-Gm-Gg: AYBFou2egnhYFECkNAjrz3oJ2gBUWdAc1iq8bNLYsVPIJ8bFw5AdFB+kJUPNVvj2UTE
	WaC86gvBf6lwVG8jh4xah3tOwfvipvcHO79OJlhzHwowKRHaauuNFjcVP+1DPhnqo0Z4KcuWmtw
	4Oz4hBgGo3juR3BwU+feb4iULMPFIA6dheMmbAi5NjdGW7UfN9IpE8+ADQw7S/JvY+JL+99iwlo
	HpMR0K0McnNiZlmG1xXuMvZL/YwPjV2R+j7S/NeyTOs6vqWFQQwkFjrxrm9+37mwlYud4Rbm3io
	UMabaMRS+WO78dXHnEzAqnncYG9eWRMYBZAcWSb+35nG4upYAD925SLc+CGcAgiRARwsyndJ4rV
	mELriZYGSvP/Kz3djVJaZaKlfbw4JcEZgrM7EA6xewLo8SwlhsP/QHqnjiLot/54/f+Ak+jwge+
	FB7yxv3g1qKnEMftzXFgWjmAzVsq9c7kv5fNTnOEd1Czg/Y8k5znS6UtWClezrndYrZDdQkE7u7
	/nKgBVafu6l0/TuxO3JAUtPBoOTRyJI8pKsMfCgL14wxnfWKlSmlXk=
X-Received: by 2002:a17:907:c305:b0:c31:c767:adfb with SMTP id a640c23a62f3a-c4196aa9278mr828308166b.0.1792508700903;
        Tue, 20 Oct 2026 08:05:00 -0700 (PDT)
Received: from elver.google.com (124.100.205.35.bc.googleusercontent.com. [35.205.100.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d80fb69sm6137590f8f.18.2026.10.20.08.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 08:04:59 -0700 (PDT)
Date: Tue, 20 Oct 2026 15:04:54 +0000
From: Marco Elver <elver@google.com>
To: Caleb Kan <calebkan1106@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Vlastimil Babka <vbabka@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>,
	kernel-team@cloudflare.com
Subject: Re: [PATCH RFC v2 10/11] stackdepot: share persistent stack prefixes
 with trie storage
Message-ID: <ateDFtLVwMByzZPG@elver.google.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
 <20260908-stackdepot-trie-v2-10-1996d5cef732@cloudflare.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-stackdepot-trie-v2-10-1996d5cef732@cloudflare.com>
User-Agent: Mutt/2.3.2 (2026-04-26)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C2FD9180018
X-Stat-Signature: ouyoq5jwgm8tbbqa1tpt66dkw9xpwn4k
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792508703-307188
X-HE-Meta: U2FsdGVkX1/e378V9awrcEIAUBEUnxnryYr/LrKY5az96vVMPODWLamO+Fc29Tbs+fJM8A7f12nY+5JviM8bEU6wP1lZ0g8NVxqQdGYg06z6cCLnuIfXBfcXXCIEOWAGV5oSlgJhaGExI3abl34v9He/1Rch9k7jEfeekc+ntHmTscb/zDcA1HmCSoC9QT5cEnejNtQvnfCpIKTfbPoCu8WaFV4Jc4NFDFe8M7K9iz5GCcbGCT4Nstnfvsg6bbWI8TNAjmak1GQ/6JrUVU84k1ZBLUK2nS8rQQxPBedX7Lf0kxnnPhGu+qsQ9jiyHlbKyMZq9XGH9ekQUnqO3Ol9GGFRiKTcySrOjmyuIvWwK+xdtd1CxSxAHjalGaSGKV/gwgAfT3qawwf6bXC0eIkO8Sc38IUZg9s9rk244NiTb0nkPp8yb9EyztjqNm0znoiNmZuG2f7KgjPd3q2HFRPiWhkO7gHLcM3yD2aYw5SdZmNworfFdUCWc4jXOmBNTMtHoj/DOeHGr0nJsbqbM1+icCj55B/SCbEy25Bnh7FYvNIIpjDz1wTiUl/qfooLNka1lOzi3NGzldW4ZCYbqVLrG74mz2qMTf05iowc4JlxCv6Gv6GJeIQajXiElCXX89F14xsxnmDbb7CsyHFNKcVVLO8+roUXM72RATmkpmtifydKDPUiKQWEsZBshH2FgWZkuJk66IRWqnrTyaL+JwlH7IrHZIssQE1F9QAGh5VeUY1YI6cjCSsIov8kxoHXq3s6uZIKs94mt6kAKaaCms7rnINcbiNNkZFb4LjSVZa6A3rsnzCiQPnmX1wW5/XJdiLvaHouJinOEw4D6h+IZosiV9vJ2NHEWlgcE51X9IkLVS8lzN0XnuCIr4+ojRQ765twD3LU6h7zPqHUgJ3QFvN+ZTZ5Vj5jvdps5NoU6FFTkbn6T8f1TkYMvkNZfqJ75ZcdrUiqBWkgf7WbgUacj5I
 x23CLQrc
 WIVsVkfeQBLTNdTYIA3/GchNL3bwhbeQ9Gp30JymFKEvPjdnJjGoymFRI0wjeVPTbCIUV/7YKb8eSGHMTyxtfVlNzUI/9xezvay23NgMcnjqL8zBqaQZdDvwF0meJUk96D3RJ5vVGgj+M/VJQ+7ybfCDGN1HGokGATNiqGlO64ZmAsNBQWuVUu5Ieq8I/J/o5J+TDhil7Yt8AMlpo1TO2s4FZrgVUqpggjrhLxe22EkvvX4lUfAIuhy784mvplaXFCNve/SPEXHJ1l+BSFA8VL7JrbU536JiAtOeW8iECNSc6svGUPZytRvEgLc8V3DlPxk/awVzySgq8kUfDCScvY/MnXE1u6+sdPJYSj8TtYKfvzDgcby+LPFcqqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Sep 08, 2026 at 02:13PM +0100, Caleb Kan wrote:
> From: Caleb Kan <ckan@cloudflare.com>
> 
> Stack depot's hash backend deduplicates identical traces, but stores every
> different trace in full. Persistent traces often share most of their
> frames, so this wastes memory and can exhaust the pool limit. Once the
> pools are full, a new trace returns 0 and later diagnostics can lose useful
> stack information.
> 
> Add an opt-in path-compressed trie for persistent records saved without
> STACK_DEPOT_FLAG_GET or STACK_DEPOT_FLAG_COUNTABLE. Store a run of frames
> in each node and branch only where traces differ. Insertion can descend
> through an existing path, split a partial match, make an internal node a
> stored trace, or attach a new suffix.
> 
> Encode dense stack IDs in pool-index values that cannot name a hash pool.
> A sparse side table maps each ID to the node where the trace ends. Fetching
> a trace follows parent links from that node. Stored traces and IDs are not
> recycled.
> 
> Use the architecture hooks from the preceding patch to store a frame in 32
> bits only when it can be reconstructed exactly. Keep all other frames at
> full width.
> 
> Allocate trie nodes and child arrays from contiguous runs of 16-byte slots
> in the existing order-2 pools. Each pool records an upper bound on its
> largest free run so the allocator can skip pools that are too fragmented.
> Search from a next-fit cursor first, then scan the whole pool so released
> holes and runs that cross the cursor remain visible. Record the exact
> longest run only after a complete scan fails.
> 
> A child array must fit in one pool. On a 4 KiB, 64-bit system, one node can
> have at most 1,024 children. An insertion that would add a 1,025th child
> returns 0, while existing traces remain valid. The largest node observed on
> a pre-production server had about 835 children.
> 
> Take the writer lock before the existing pool lock. Reserve everything
> that can fail before publishing a trace. Release unpublished node and
> child slots immediately, but keep registered pools, side-table space,
> stored traces, and IDs. When a node or child array is replaced, keep it
> until a later allocating insertion sees that its RCU grace period has
> ended.
> 
> An NMI save only looks for an existing trie record and returns 0 on a miss.
> Outside NMI, a save gets one insertion attempt when
> STACK_DEPOT_FLAG_CAN_ALLOC is clear or its GFP flags do not allow spinning
> on raw locks. The attempt uses only pool and side-table space already
> available. If spinning is allowed, take the writer and pool locks;
> otherwise try each lock once. Access to the side-table page cache also uses
> a trylock. The attempt does not allocate, retry, wait for RCU, or fall back
> to the hash backend.
> 
> Allocating saves try at most three times. One try can skip preallocation
> after seeing new_pool, then lose that pool to another save. A maximum-depth
> insertion can also need two new pools. Trie insertion failure returns 0
> instead of consuming hash capacity.
> 
> Extend stack_depot_fetch_into(), stack_depot_print(), and
> stack_depot_snprint() to support both backends. Keep stack_depot_fetch()
> hash-only because it returns a pointer to contiguous depot-owned storage.
> Print 16 frames at a time so stack use stays fixed instead of growing with
> CONFIG_STACKDEPOT_MAX_FRAMES.
> 
> The hash and trie backends share stack_pools and the configured pool limit.
> A pool used by the trie is unavailable for hash-backed GET and COUNTABLE
> records. Hash handles reserve pool-index values through
> stack_depot_max_pools, and trie handles use the remaining values for stack
> IDs. With 64 KiB pages, the default limit leaves no values for trie IDs, so
> stack_depot_max_pools must be lowered before enabling the trie.
> 
> Rename the persistent_count and persistent_bytes debugfs counters with a
> hash prefix because they do not include trie storage.
> 
> Add the stackdepot.trie_enabled boot parameter and leave it disabled by
> default. Initialize the trie root before enabling the static key. If no
> handle values are available for trie IDs or allocating the root metadata
> fails, leave the hash backend initialized at its configured capacity.
> 
> I collected stack depot state from four live KASAN servers using the same
> kernel revision, 4 KiB pages, and an 8,192-pool limit. The servers ran for
> 61 to 67 hours and remained active while the values were collected, so the
> figures below are rounded.
> 
>                                arm64                 x86-64
>                         trie off trie on      trie off trie on
> Run time (hours)              61      64            65      67
> Stored records              162k     87k          498k    217k
> Registered pools           2,630     925         8,192   1,940
> Pool budget used             32%     11%          100%     24%
> 
> The servers ran different workloads and stored different traces, so this
> is not a controlled comparison. Exact memory savings depend on the
> workload.
> 
> The trie figures came from RFC v1. That version did not insert a new trace
> when a save could not allocate, so RFC v2 may store more traces and use
> more pools than shown here.
> 
> On arm64, the final allocator reduced the median number of bitmap probes
> from 36,939,363 to 1,529,482 without increasing pool use. The first-fit
> allocator used a median of 1,101 pools, while the final allocator used
> 1,100.
> 
> I also pinned a benchmark to one CPU on KASAN-enabled arm64 and x86-64
> systems running the Linux 6.18.48 port. It inserted 32,768 distinct
> 32-frame traces. Within each group of 64 traces, 75% of the frames were
> shared, and all frames could be compressed. The insertion order was
> shuffled. The warm save-hit and fetch tests then repeated the same traces
> 32 times.
> 
>                          arm64 CPU ns/op         x86-64 CPU ns/op
>                          hash       trie        hash         trie
> Insertion                 777      9,417         792       11,269
> Warm save hit             945      1,287         623        1,012
> Fetch                     251        511         123          476
> 
> First insertion was about 12 times slower on arm64 and 14 times slower on
> x86-64. A warm save hit was 1.4 to 1.6 times slower, and fetch was 2 to 4
> times slower. All four runs completed without save failures or validation
> errors.
> 
> Signed-off-by: Caleb Kan <ckan@cloudflare.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |    7 +
>  include/linux/stackdepot.h                      |   23 +-
>  lib/stackdepot.c                                | 1600 ++++++++++++++++++++++-
>  3 files changed, 1616 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 68647ff4bdd2..b02bcbaef5dc 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -7449,6 +7449,13 @@ Kernel parameters
>  			stack traces. Pools are allocated on-demand up to this
>  			limit. Default value is 8191 pools.
>  
> +	stackdepot.trie_enabled= [KNL]
> +			Format: <bool>
> +			Enable trie storage for persistent, non-refcounted
> +			stack depot records at boot. Disabled by default.
> +			stack_depot_max_pools must leave unused pool-index
> +			values for trie handles.
> +
>  	stacktrace	[FTRACE]
>  			Enable the stack tracer on boot up.
>  
> diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
> index 7ff67c70d727..3126d17b9265 100644
> --- a/include/linux/stackdepot.h
> +++ b/include/linux/stackdepot.h
> @@ -151,6 +151,12 @@ static inline int stack_depot_early_init(void)	{ return 0; }
>   * access. This flag does not imply %STACK_DEPOT_FLAG_CAN_ALLOC and is mutually
>   * exclusive with %STACK_DEPOT_FLAG_GET.
>   *
> + * When trie storage is enabled, persistent non-refcounted saves use trie
> + * storage. Constrained callers first look up an existing stack, then make one
> + * best-effort insertion attempt without allocating. NMI callers stop after the
> + * lookup. Other callers that cannot spin use trylocks and fail if a required
> + * lock is unavailable. Trie failures do not fall back to hash storage.
> + *
>   * If the provided stack trace comes from the interrupt context, only the part
>   * up to the interrupt entry is saved.
>   *
> @@ -159,7 +165,7 @@ static inline int stack_depot_early_init(void)	{ return 0; }
>   *          this is the case for contexts where neither %GFP_ATOMIC nor
>   *          %GFP_NOWAIT can be used (NMI, raw_spin_lock).
>   *
> - * Return: Handle of the stack struct stored in depot, 0 on failure
> + * Return: Handle of the stack trace stored in depot, 0 on failure
>   */
>  depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
>  					    unsigned int nr_entries,
> @@ -176,6 +182,10 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
>   * Does not increment the refcount on the saved stack trace; see
>   * stack_depot_save_flags() for more details.
>   *
> + * When trie storage is enabled, this can return trie-backed handles. Use
> + * stack_depot_fetch_into(), stack_depot_print(), or stack_depot_snprint() for
> + * backend-independent access to the stack contents.
> + *
>   * Context: Contexts where allocations via alloc_pages() are allowed;
>   *          see stack_depot_save_flags() for more details.
>   *
> @@ -199,9 +209,14 @@ struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle)
>  /**
>   * stack_depot_fetch - Fetch a stack trace from stack depot
>   *
> - * @handle:	Stack depot handle returned from stack_depot_save()
> + * @handle:	Hash-backed stack depot handle
>   * @entries:	Pointer to store the address of the stack trace
>   *
> + * This helper returns a pointer to stackdepot-owned contiguous storage for
> + * legacy hash-backed handles. Callers that need backend-independent access to
> + * stack contents should use stack_depot_fetch_into(), stack_depot_print(), or
> + * stack_depot_snprint(). Passing a trie-backed handle is invalid and may WARN.
> + *
>   * Return: Number of frames for the fetched stack
>   */
>  unsigned int stack_depot_fetch(depot_stack_handle_t handle,
> @@ -270,8 +285,8 @@ int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
>   *
>   * Drop a reference acquired by stack_depot_save_flags() with
>   * %STACK_DEPOT_FLAG_GET. Calling this for a handle saved without
> - * %STACK_DEPOT_FLAG_GET is invalid; persistent handles are owned by stack depot
> - * for the lifetime of the system.
> + * %STACK_DEPOT_FLAG_GET is invalid; persistent handles, including trie-backed
> + * handles, are owned by stack depot for the lifetime of the system.
>   *
>   * The stack trace is evicted once the number of stack_depot_put() calls matches
>   * the number of successful stack_depot_save_flags() calls with
> diff --git a/lib/stackdepot.c b/lib/stackdepot.c
> index 66c5e8594566..33e475d94131 100644
> --- a/lib/stackdepot.c
> +++ b/lib/stackdepot.c
> @@ -2,9 +2,11 @@
>  /*
>   * Stack depot - a stack trace storage that avoids duplication.
>   *
> - * Internally, stack depot maintains a hash table of unique stacktraces. The
> - * stack traces themselves are stored contiguously one after another in a set
> - * of separate page allocations.
> + * Internally, stack depot has two storage backends. Refcounted entries and
> + * callers that request STACK_DEPOT_FLAG_COUNTABLE use the legacy hash table with
> + * contiguous stack records in stack pools. Persistent non-refcounted entries
> + * can use trie storage when enabled; trie nodes share common frame prefixes and
> + * are published through RCU children containers.
>   *
>   * Author: Alexander Potapenko <glider@google.com>
>   * Copyright (C) 2016 Google, Inc.
> @@ -14,13 +16,19 @@
>  
>  #define pr_fmt(fmt) "stackdepot: " fmt
>  
> +#include <linux/bitmap.h>
> +#include <linux/build_bug.h>
>  #include <linux/debugfs.h>
> +#include <linux/errno.h>
>  #include <linux/gfp.h>
>  #include <linux/jhash.h>
> +#include <linux/jump_label.h>
>  #include <linux/kernel.h>
> +#include <linux/log2.h>
>  #include <linux/kmsan.h>
>  #include <linux/list.h>
>  #include <linux/mm.h>
> +#include <linux/moduleparam.h>
>  #include <linux/mutex.h>
>  #include <linux/poison.h>
>  #include <linux/printk.h>
> @@ -36,9 +44,12 @@
>  #include <linux/memblock.h>
>  #include <linux/kasan-enabled.h>
>  
> +#include <asm/stackdepot.h>
> +
>  /*
>   * The pool_index is offset by 1 so the first record does not have a 0 handle.
>   */
> +/* Parsed before mm_core_init(); trie handle decoding assumes this is then fixed. */
>  static unsigned int stack_max_pools __read_mostly =
>  	MIN((1LL << DEPOT_POOL_INDEX_BITS) - 1, 8192);
>  
> @@ -54,6 +65,9 @@ static bool __stack_depot_early_init_passed __initdata;
>  /* Initial seed for jhash2. */
>  #define STACK_HASH_SEED 0x9747b28c
>  
> +/* Bound 64-bit print scratch to 128 bytes while amortizing trie walks. */
> +#define STACK_DEPOT_PRINT_CHUNK_FRAMES 16
> +
>  /* Hash table of stored stack records. */
>  static struct list_head *stack_table;
>  /* Fixed order of the number of table buckets. Used when KASAN is enabled. */
> @@ -63,18 +77,18 @@ static unsigned int stack_hash_mask;
>  
>  /* The lock must be held when performing pool or freelist modifications. */
>  static DEFINE_RAW_SPINLOCK(pool_lock);
> -/* Array of memory regions that store stack records. */
> +/* Array of memory regions used by both stack depot backends. */
>  static void **stack_pools __pt_guarded_by(&pool_lock);
>  /* Newly allocated pool that is not yet added to stack_pools. */
>  static void *new_pool;
>  /* Number of pools in stack_pools. */
>  static int pools_num;
> -/* Offset to the unused space in the currently used pool. */
> +/* Offset to unused hash storage in the current pool. */
>  static size_t pool_offset __guarded_by(&pool_lock) = DEPOT_POOL_SIZE;
>  /* Freelist of stack records within stack_pools. */
>  static __guarded_by(&pool_lock) LIST_HEAD(free_stacks);
>  
> -/* Statistics counters for debugfs. */
> +/* Hash-backend statistics counters for debugfs. */
>  enum depot_counter_id {
>  	DEPOT_COUNTER_REFD_ALLOCS,
>  	DEPOT_COUNTER_REFD_FREES,
> @@ -90,12 +104,695 @@ static const char *const counter_names[] = {
>  	[DEPOT_COUNTER_REFD_FREES]	= "refcounted_frees",
>  	[DEPOT_COUNTER_REFD_INUSE]	= "refcounted_in_use",
>  	[DEPOT_COUNTER_FREELIST_SIZE]	= "freelist_size",
> -	[DEPOT_COUNTER_PERSIST_COUNT]	= "persistent_count",
> -	[DEPOT_COUNTER_PERSIST_BYTES]	= "persistent_bytes",
> +	[DEPOT_COUNTER_PERSIST_COUNT]	= "hash_persistent_count",
> +	[DEPOT_COUNTER_PERSIST_BYTES]	= "hash_persistent_bytes",
>  };
>  static_assert(ARRAY_SIZE(counter_names) == DEPOT_COUNTER_COUNT);
> +
> +enum stack_depot_frame_mode {
> +	STACK_DEPOT_FRAME_RAW,
> +	STACK_DEPOT_FRAME_COMPRESSED,
> +};
> +
> +/*
> + * A trie node stores one run of frames that all use the same payload format.
> + * Architectures may compress some frames to 32-bit payloads; mixed raw and
> + * compressed input is split across multiple trie nodes so each node has one
> + * decoding mode.
> + */
> +struct stack_depot_frame_run {
> +	u16 nr_entries;
> +	u8 mode;
> +};
> +
>  static_assert(CONFIG_STACKDEPOT_MAX_FRAMES <= U16_MAX);
>  
> +struct stack_depot_trie_children;
> +
> +struct stack_depot_trie_node {
> +	/* Parent links let fetch rebuild a full stack from a node to the root. */
> +	const struct stack_depot_trie_node __rcu *parent;
> +	/* Children are RCU-published containers. */
> +	const struct stack_depot_trie_children __rcu *children;
> +	/* Non-zero when a stored stack ends at this node. */
> +	u32 stack_id;
> +	struct stack_depot_frame_run run;
> +	unsigned char data[];
> +};
> +
> +/*
> + * Child nodes are sorted by first frame and searched by insertion position.
> + * Existing child pointers are immutable. Writers may publish into unused tail
> + * capacity; other updates publish a replacement container.
> + */
> +struct stack_depot_trie_children {
> +	unsigned int nr_children;
> +	unsigned int capacity;
> +	const struct stack_depot_trie_node __rcu *nodes[];
> +};
> +
> +/* Retired children carry an optional node through their RCU grace period. */
> +struct stack_depot_trie_retired_children {
> +	struct list_head list;
> +	unsigned long rcu_state;
> +	const struct stack_depot_trie_node *pending_node;
> +	unsigned char data[];
> +};
> +
> +static_assert(IS_ALIGNED(offsetof(struct stack_depot_trie_retired_children, data),
> +			 1UL << DEPOT_STACK_ALIGN));
> +
> +#define STACK_DEPOT_TRIE_SLOT_SIZE BIT(DEPOT_STACK_ALIGN)
> +#define STACK_DEPOT_TRIE_POOL_SLOTS \
> +	(DEPOT_POOL_SIZE / STACK_DEPOT_TRIE_SLOT_SIZE)
> +
> +static_assert(STACK_DEPOT_TRIE_POOL_SLOTS - 1 <= U16_MAX);
> +
> +struct stack_depot_trie_pool {
> +	struct list_head list;
> +	unsigned int free_slots;
> +	/* Conservative upper bound on the largest free run. */
> +	u16 free_run_upper_bound;
> +	/* First physical slot considered by the next reservation. */
> +	u16 next_slot;
> +	DECLARE_BITMAP(used, STACK_DEPOT_TRIE_POOL_SLOTS);
> +};
> +
> +#define STACK_DEPOT_TRIE_POOL_FIRST_SLOT \
> +	DIV_ROUND_UP(sizeof(struct stack_depot_trie_pool), \
> +		     STACK_DEPOT_TRIE_SLOT_SIZE)
> +#define STACK_DEPOT_TRIE_POOL_USABLE_SIZE \
> +	((STACK_DEPOT_TRIE_POOL_SLOTS - STACK_DEPOT_TRIE_POOL_FIRST_SLOT) * \
> +	 STACK_DEPOT_TRIE_SLOT_SIZE)
> +
> +static_assert(STACK_DEPOT_TRIE_POOL_FIRST_SLOT < STACK_DEPOT_TRIE_POOL_SLOTS);
> +
> +static DEFINE_STATIC_KEY_FALSE(stack_depot_trie_enabled);
> +static const struct stack_depot_trie_children __rcu *stack_depot_trie_root;
> +static DEFINE_RAW_SPINLOCK(stack_depot_trie_writer_lock);
> +static bool stack_depot_trie_requested;
> +
> +module_param_named(trie_enabled, stack_depot_trie_requested, bool, 0);
> +MODULE_PARM_DESC(trie_enabled, "Enable stack depot trie storage at boot");
> +
> +#define DEPOT_POOL_INDEX_MASK ((1U << DEPOT_POOL_INDEX_BITS) - 1)
> +#define DEPOT_OFFSET_MASK ((1U << DEPOT_OFFSET_BITS) - 1)
> +
> +/* Retired fixed-size slots remain reserved until their RCU grace period ends. */
> +static LIST_HEAD(stack_depot_trie_pools);
> +static LIST_HEAD(pending_trie_children);
> +
> +/*
> + * stack_max_pools is the split point between hash and trie handle encodings.
> + * A handle with pool_index_plus_1 in 1..stack_max_pools names a hash-backed
> + * stack pool. Larger pool-index values cannot refer to hash pools, so trie
> + * storage uses that handle space to encode a dense stack ID. The side table
> + * maps each stack ID to its trie node.
> + */
> +static inline u32 trie_max_stack_id(void)
> +{
> +	return (DEPOT_POOL_INDEX_MASK - stack_max_pools) <<
> +		DEPOT_OFFSET_BITS;
> +}

With PAGE_SHIFT=16, DEPOT_POOL_INDEX_BITS is 13
(DEPOT_POOL_INDEX_MASK = 8191), which equals the default
stack_max_pools (8191). trie_max_stack_id() therefore returns 0 and
stackdepot.trie_enabled=1 always fails to initialize unless
stack_depot_max_pools is also manually lowered.

> +
> +static depot_stack_handle_t trie_handle(u32 stack_id)
> +{
> +	union handle_parts parts = {};
> +	u64 pool_index_plus_1;
> +	u32 pool_delta;
> +	u32 index;
> +
> +	index = stack_id - 1;
> +	pool_delta = index >> DEPOT_OFFSET_BITS;
> +	pool_index_plus_1 = (u64)stack_max_pools + 1 + pool_delta;
> +
> +	parts.pool_index_plus_1 = pool_index_plus_1;
> +	parts.offset = index & DEPOT_OFFSET_MASK;
> +	return parts.handle;
> +}
> +
> +static inline bool stack_depot_handle_is_trie(depot_stack_handle_t handle)
> +{
> +	union handle_parts parts = { .handle = handle };
> +
> +	return parts.pool_index_plus_1 > stack_max_pools;
> +}
> +
> +static u32 trie_stack_id(depot_stack_handle_t handle)
> +{
> +	union handle_parts parts = { .handle = handle };
> +	u32 pool_delta;
> +
> +	pool_delta = parts.pool_index_plus_1 - stack_max_pools - 1;
> +	return (pool_delta << DEPOT_OFFSET_BITS) + parts.offset + 1;
> +}
> +
> +/*
> + * Trie handles encode a dense stack ID. The side table maps that ID to a node
> + * pointer for lockless fetch and print paths, which can run from diagnostic
> + * contexts where taking a lock would be unsafe. Initialization installs the
> + * root; early initialization also installs the first directory and chunk.
> + * Additional directories and chunks are published lazily as stack IDs grow.
> + */
> +#define STACK_DEPOT_TRIE_SIDE_TABLE_CHUNK_SIZE \
> +	(PAGE_SIZE / sizeof(struct stack_depot_trie_node *))
> +#define STACK_DEPOT_TRIE_SIDE_TABLE_DIR_SIZE \
> +	(PAGE_SIZE / sizeof(struct stack_depot_trie_node **))
> +
> +struct stack_depot_trie_side_dir {
> +	/* Both the chunk pointer and each node pointer in it are RCU-published. */
> +	const struct stack_depot_trie_node __rcu * __rcu *
> +		chunks[STACK_DEPOT_TRIE_SIDE_TABLE_DIR_SIZE];
> +};
> +
> +struct stack_depot_trie_side_root {
> +	unsigned int dir_capacity;
> +	struct stack_depot_trie_side_dir __rcu *dirs[];
> +};
> +
> +struct stack_depot_trie_side_prealloc {
> +	/* Preallocated side-table directory page for sparse growth. */
> +	struct stack_depot_trie_side_dir *dir;
> +	/* Preallocated side-table pointer chunk for sparse growth. */
> +	const struct stack_depot_trie_node __rcu **chunk;
> +};
> +
> +static struct stack_depot_trie_side_root *trie_side_table_root;
> +static DEFINE_RAW_SPINLOCK(trie_side_table_cache_lock);
> +/* Zeroed unpublished pages; get/put transfer ownership under the cache lock. */
> +static struct stack_depot_trie_side_prealloc trie_side_table_cache;
> +static u32 trie_side_table_last_stack_id;
> +
> +/* Lock order: writer_lock -> pool_lock -> side-table cache lock. */
> +
> +static inline size_t stack_depot_frame_run_entry_bytes(enum stack_depot_frame_mode mode)
> +{
> +	if (mode == STACK_DEPOT_FRAME_COMPRESSED)
> +		return sizeof(u32);
> +	return sizeof(unsigned long);
> +}
> +
> +static inline size_t stack_depot_frame_run_bytes(const struct stack_depot_frame_run *run)
> +{
> +	return run->nr_entries * stack_depot_frame_run_entry_bytes(run->mode);
> +}
> +
> +static inline size_t trie_node_bytes(const struct stack_depot_frame_run *run)
> +{
> +	return ALIGN(offsetof(struct stack_depot_trie_node, data) +
> +		     stack_depot_frame_run_bytes(run), sizeof(unsigned long));
> +}
> +
> +static size_t trie_children_alloc_size(unsigned int capacity)
> +{
> +	size_t size;
> +
> +	size = struct_size_t(struct stack_depot_trie_children, nodes,
> +			     capacity);
> +	return offsetof(struct stack_depot_trie_retired_children, data) +
> +		ALIGN(size, sizeof(unsigned long));
> +}
> +
> +static inline unsigned int trie_side_table_root_index(u32 id)
> +{
> +	return ((id - 1) / STACK_DEPOT_TRIE_SIDE_TABLE_CHUNK_SIZE) /
> +		STACK_DEPOT_TRIE_SIDE_TABLE_DIR_SIZE;
> +}
> +
> +static inline unsigned int trie_side_table_dir_index(u32 id)
> +{
> +	return ((id - 1) / STACK_DEPOT_TRIE_SIDE_TABLE_CHUNK_SIZE) %
> +		STACK_DEPOT_TRIE_SIDE_TABLE_DIR_SIZE;
> +}
> +
> +static inline unsigned int trie_side_table_slot_index(u32 id)
> +{
> +	return (id - 1) % STACK_DEPOT_TRIE_SIDE_TABLE_CHUNK_SIZE;
> +}
> +
> +static struct stack_depot_trie_side_dir *trie_side_table_load_dir(unsigned int root)
> +{
> +	struct stack_depot_trie_side_root *root_vec;
> +
> +	root_vec = trie_side_table_root;
> +	if (!root_vec || root >= root_vec->dir_capacity)
> +		return NULL;
> +	/* Pairs with side-table directory rcu_assign_pointer(). */
> +	return rcu_dereference_check(root_vec->dirs[root],
> +				     lockdep_is_held(&stack_depot_trie_writer_lock) ||
> +				     rcu_read_lock_sched_held());
> +}
> +
> +static inline const struct stack_depot_trie_node __rcu **
> +trie_side_table_dir_load_chunk(struct stack_depot_trie_side_dir *dir,
> +			       unsigned int idx)
> +{
> +	/* Pairs with the chunk rcu_assign_pointer() in stack ID preparation. */
> +	return rcu_dereference_check(dir->chunks[idx],
> +				     lockdep_is_held(&stack_depot_trie_writer_lock) ||
> +				     rcu_read_lock_sched_held());
> +}
> +
> +/* Published capacity remains useful if insertion fails and needs no rollback. */
> +static bool
> +trie_side_table_try_take_cache(struct stack_depot_trie_side_prealloc *prealloc,
> +			       bool need_dir)
> +{
> +	bool taken = false;
> +
> +	lockdep_assert_held(&stack_depot_trie_writer_lock);
> +	lockdep_assert_held(&pool_lock);
> +
> +	if (!raw_spin_trylock(&trie_side_table_cache_lock))
> +		return false;
> +	if ((!prealloc->chunk && !trie_side_table_cache.chunk) ||
> +	    (need_dir && !prealloc->dir && !trie_side_table_cache.dir))
> +		goto out_unlock;
> +
> +	if (need_dir && !prealloc->dir) {
> +		prealloc->dir = trie_side_table_cache.dir;
> +		trie_side_table_cache.dir = NULL;
> +	}
> +	if (!prealloc->chunk) {
> +		prealloc->chunk = trie_side_table_cache.chunk;
> +		trie_side_table_cache.chunk = NULL;
> +	}
> +	taken = true;
> +
> +out_unlock:
> +	raw_spin_unlock(&trie_side_table_cache_lock);
> +	return taken;
> +}
> +
> +static u32
> +trie_side_table_prepare_stack_slot(struct stack_depot_trie_side_prealloc *prealloc)
> +{
> +	const struct stack_depot_trie_node __rcu **chunk;
> +	struct stack_depot_trie_side_dir *dir;
> +	struct stack_depot_trie_side_root *root_vec;
> +	unsigned int root;
> +	unsigned int idx;
> +	u32 id;
> +
> +	lockdep_assert_held(&stack_depot_trie_writer_lock);
> +	lockdep_assert_held(&pool_lock);
> +
> +	id = trie_side_table_last_stack_id + 1;
> +	if (id > trie_max_stack_id())
> +		return 0;
> +
> +	root_vec = trie_side_table_root;
> +	root = trie_side_table_root_index(id);
> +	dir = trie_side_table_load_dir(root);
> +	if (!dir) {
> +		if ((!prealloc->dir || !prealloc->chunk) &&
> +		    !trie_side_table_try_take_cache(prealloc, true))
> +			return 0;
> +		dir = prealloc->dir;
> +		prealloc->dir = NULL;
> +		/* Publish the zeroed directory before readers can load it locklessly. */
> +		rcu_assign_pointer(root_vec->dirs[root], dir);
> +	}
> +
> +	idx = trie_side_table_dir_index(id);
> +	chunk = trie_side_table_dir_load_chunk(dir, idx);
> +	if (!chunk) {
> +		if (!prealloc->chunk &&
> +		    !trie_side_table_try_take_cache(prealloc, false))
> +			return 0;
> +		chunk = prealloc->chunk;
> +		prealloc->chunk = NULL;
> +		rcu_assign_pointer(dir->chunks[idx], chunk);
> +	}
> +
> +	return id;
> +}
> +
> +static inline unsigned int trie_side_table_root_size_for_max_id(u32 max_stack_id)
> +{
> +	unsigned int top_size;
> +
> +	top_size = DIV_ROUND_UP(max_stack_id, STACK_DEPOT_TRIE_SIDE_TABLE_CHUNK_SIZE);
> +	return DIV_ROUND_UP(top_size, STACK_DEPOT_TRIE_SIDE_TABLE_DIR_SIZE);
> +}
> +
> +static int __init stack_depot_trie_init_memblock(void)
> +{
> +	struct stack_depot_trie_side_root *root_vec;
> +	struct stack_depot_trie_side_dir *first_dir;
> +	const struct stack_depot_trie_node __rcu **first_chunk;
> +	size_t root_bytes;
> +	u32 max_stack_id;
> +	unsigned int root_size;
> +
> +	max_stack_id = trie_max_stack_id();
> +	if (!max_stack_id)
> +		return -EINVAL;
> +	root_size = trie_side_table_root_size_for_max_id(max_stack_id);
> +	root_bytes = struct_size_t(struct stack_depot_trie_side_root, dirs, root_size);
> +
> +	root_vec = memblock_alloc(root_bytes, __alignof__(*root_vec));
> +	if (!root_vec)
> +		return -ENOMEM;
> +	first_dir = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
> +	if (!first_dir) {
> +		memblock_free(root_vec, root_bytes);
> +		return -ENOMEM;
> +	}
> +	first_chunk = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
> +	if (!first_chunk) {
> +		memblock_free(first_dir, PAGE_SIZE);
> +		memblock_free(root_vec, root_bytes);
> +		return -ENOMEM;
> +	}
> +
> +	root_vec->dir_capacity = root_size;
> +	RCU_INIT_POINTER(root_vec->dirs[0], first_dir);
> +	RCU_INIT_POINTER(first_dir->chunks[0], first_chunk);
> +	trie_side_table_root = root_vec;
> +	static_branch_enable(&stack_depot_trie_enabled);
> +	return 0;
> +}
> +
> +static int stack_depot_trie_init(void)
> +{
> +	struct stack_depot_trie_side_root *root_vec;
> +	unsigned int root_size;
> +	size_t root_bytes;
> +	u32 max_stack_id;
> +
> +	max_stack_id = trie_max_stack_id();
> +	if (!max_stack_id)
> +		return -EINVAL;
> +
> +	root_size = trie_side_table_root_size_for_max_id(max_stack_id);
> +	root_bytes = struct_size_t(struct stack_depot_trie_side_root, dirs, root_size);
> +	root_vec = kvzalloc(root_bytes, GFP_KERNEL);
> +	if (!root_vec)
> +		return -ENOMEM;
> +
> +	root_vec->dir_capacity = root_size;
> +	trie_side_table_root = root_vec;
> +	static_branch_enable(&stack_depot_trie_enabled);
> +	return 0;
> +}
> +
> +static int trie_side_table_get_prealloc(gfp_t gfp_flags,
> +					struct stack_depot_trie_side_prealloc *prealloc)
> +{
> +	unsigned long flags;
> +
> +	gfp_flags = gfp_nested_mask(gfp_flags);
> +	raw_spin_lock_irqsave(&trie_side_table_cache_lock, flags);
> +	prealloc->dir = trie_side_table_cache.dir;
> +	prealloc->chunk = trie_side_table_cache.chunk;
> +	trie_side_table_cache.dir = NULL;
> +	trie_side_table_cache.chunk = NULL;
> +	raw_spin_unlock_irqrestore(&trie_side_table_cache_lock, flags);

stack_depot_trie_save() pops both cached pages into thread-local
storage *before* taking stack_depot_trie_writer_lock. Under
concurrency, every other CPU that misses in trie_find_handle() sees an
empty cache, calls get_zeroed_page() twice, and then frees both pages
in trie_side_table_put_prealloc() because the existing dir (262k IDs)
and chunk (512 IDs) weren't full.

Worse: if get_zeroed_page() fails (e.g. GFP_NOWAIT),
stack_depot_trie_save() immediately returns 0 even when the current
dir, chunk, and trie pool already have plenty of free space. And while
a can_alloc caller temporarily holds the popped cache pages, a
concurrent !can_alloc caller crossing a chunk boundary fails because
the cached chunk was stolen.

> +	if (!prealloc->dir) {
> +		prealloc->dir = (void *)get_zeroed_page(gfp_flags);
> +		if (!prealloc->dir)
> +			return -ENOMEM;
> +	}
> +	if (!prealloc->chunk) {
> +		prealloc->chunk = (void *)get_zeroed_page(gfp_flags);
> +		if (!prealloc->chunk)
> +			return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static void trie_side_table_put_prealloc(struct stack_depot_trie_side_prealloc *prealloc)
> +{
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&trie_side_table_cache_lock, flags);
> +	if (!trie_side_table_cache.dir) {
> +		trie_side_table_cache.dir = prealloc->dir;
> +		prealloc->dir = NULL;
> +	}
> +	if (!trie_side_table_cache.chunk) {
> +		trie_side_table_cache.chunk = prealloc->chunk;
> +		prealloc->chunk = NULL;
> +	}
> +	raw_spin_unlock_irqrestore(&trie_side_table_cache_lock, flags);
> +
> +	if (prealloc->dir)
> +		free_page((unsigned long)prealloc->dir);
> +	if (prealloc->chunk)
> +		free_page((unsigned long)prealloc->chunk);
> +}
> +
> +static const struct stack_depot_trie_node *trie_side_table_lookup(u32 id)
> +{
> +	const struct stack_depot_trie_node __rcu **chunk;
> +	struct stack_depot_trie_side_dir *dir;
> +	unsigned int root;
> +
> +	root = trie_side_table_root_index(id);
> +	dir = trie_side_table_load_dir(root);
> +	if (!dir)
> +		return NULL;
> +	chunk = trie_side_table_dir_load_chunk(dir, trie_side_table_dir_index(id));
> +	if (!chunk)
> +		return NULL;
> +
> +	/* Pairs with side-table node publication. */
> +	return rcu_dereference_check(chunk[trie_side_table_slot_index(id)],
> +				     lockdep_is_held(&stack_depot_trie_writer_lock) ||
> +				     rcu_read_lock_sched_held());
> +}
> +
> +static inline struct stack_depot_trie_retired_children *
> +trie_retired_children(const void *ptr)
> +{
> +	return container_of(ptr, struct stack_depot_trie_retired_children, data);
> +}
> +
> +static bool depot_init_pool(void **prealloc);
> +
> +static unsigned int trie_pool_reserve_slots(struct stack_depot_trie_pool *pool,
> +					    unsigned int nr_slots)
> +{
> +	unsigned int start = pool->next_slot;
> +	unsigned int run = 0;
> +	unsigned int longest_run = 0;
> +	unsigned int i;
> +	unsigned int slot;
> +
> +scan:
> +	run = 0;
> +	longest_run = 0;
> +	for (slot = start; slot < STACK_DEPOT_TRIE_POOL_SLOTS; slot++) {
> +		if (pool->used[slot / BITS_PER_LONG] &
> +		    BIT(slot % BITS_PER_LONG)) {
> +			run = 0;
> +			continue;
> +		}
> +		run++;
> +		longest_run = max(longest_run, run);
> +		if (run != nr_slots)
> +			continue;
> +
> +		for (i = slot + 1 - nr_slots; i <= slot; i++)
> +			pool->used[i / BITS_PER_LONG] |= BIT(i % BITS_PER_LONG);
> +		pool->free_slots -= nr_slots;
> +		if (slot + 1 == STACK_DEPOT_TRIE_POOL_SLOTS)
> +			pool->next_slot = STACK_DEPOT_TRIE_POOL_FIRST_SLOT;
> +		else
> +			pool->next_slot = slot + 1;
> +		return slot + 1 - nr_slots;
> +	}
> +
> +	if (start != STACK_DEPOT_TRIE_POOL_FIRST_SLOT) {
> +		/* Keep holes and runs crossing the cursor visible. */
> +		start = STACK_DEPOT_TRIE_POOL_FIRST_SLOT;
> +		goto scan;
> +	}
> +
> +	pool->free_run_upper_bound = longest_run;
> +	return STACK_DEPOT_TRIE_POOL_SLOTS;
> +}
> +
> +/* Allocate at least @size bytes from one contiguous trie-pool slot run. */
> +static void *trie_pool_alloc(size_t size, void **prealloc)
> +{
> +	struct stack_depot_trie_pool *pool;
> +	unsigned int nr_slots;
> +	unsigned int slot;
> +
> +	lockdep_assert_held(&pool_lock);
> +
> +	if (size > STACK_DEPOT_TRIE_POOL_USABLE_SIZE)
> +		return NULL;
> +	nr_slots = DIV_ROUND_UP(size, STACK_DEPOT_TRIE_SLOT_SIZE);
> +	list_for_each_entry_reverse(pool, &stack_depot_trie_pools, list) {
> +		if (pool->free_slots < nr_slots ||
> +		    pool->free_run_upper_bound < nr_slots)
> +			continue;
> +		slot = trie_pool_reserve_slots(pool, nr_slots);
> +		if (slot != STACK_DEPOT_TRIE_POOL_SLOTS)
> +			return (char *)pool + slot * STACK_DEPOT_TRIE_SLOT_SIZE;
> +	}
> +
> +	if (!depot_init_pool(prealloc))
> +		return NULL;
> +	pool = stack_pools[pools_num - 1];
> +	/* Keep hash records out of this bitmap-owned pool. */
> +	pool_offset = DEPOT_POOL_SIZE;

depot_pop_free_pool() always allocates from stack_pools[pools_num - 1]
at pool_offset. When hash saves (page_owner COUNTABLE, KASAN GET) and
trie saves interleave, allocating a trie pool increments pools_num and
sets pool_offset = DEPOT_POOL_SIZE, permanently abandoning all unused
space in the previously active hash pool. Trie pools shouldn't be
placed in stack_pools[] at all (they also unnecessarily consume
stack_max_pools slots).

> +	memset(pool, 0, sizeof(*pool));
> +	pool->free_slots = STACK_DEPOT_TRIE_POOL_SLOTS -
> +			   STACK_DEPOT_TRIE_POOL_FIRST_SLOT;
> +	pool->free_run_upper_bound = pool->free_slots;
> +	pool->next_slot = STACK_DEPOT_TRIE_POOL_FIRST_SLOT;
> +	list_add_tail(&pool->list, &stack_depot_trie_pools);
> +
> +	slot = trie_pool_reserve_slots(pool, nr_slots);
> +	return (char *)pool + slot * STACK_DEPOT_TRIE_SLOT_SIZE;
> +}
> +
> +/* Release the slots for the byte count originally passed to allocation. */
> +static void trie_pool_release(const void *ptr, size_t size)
> +{
> +	struct stack_depot_trie_pool *pool;
> +	unsigned long pfn;
> +	unsigned int nr_slots;
> +	unsigned int slot;
> +	unsigned int i;
> +
> +	lockdep_assert_held(&pool_lock);
> +
> +	pfn = page_to_pfn(virt_to_page(ptr));
> +	pfn &= ~(BIT(DEPOT_POOL_ORDER) - 1);
> +	pool = page_address(pfn_to_page(pfn));
> +	slot = ((unsigned long)ptr - (unsigned long)pool) >> DEPOT_STACK_ALIGN;
> +	nr_slots = DIV_ROUND_UP(size, STACK_DEPOT_TRIE_SLOT_SIZE);
> +	for (i = slot; i < slot + nr_slots; i++)
> +		pool->used[i / BITS_PER_LONG] &= ~BIT(i % BITS_PER_LONG);
> +	pool->free_slots += nr_slots;
> +	/* A release can join at most two runs bounded by the old value. */
> +	pool->free_run_upper_bound = min(pool->free_slots,
> +					 2 * pool->free_run_upper_bound + nr_slots);
> +}
> +
> +static struct stack_depot_trie_children *
> +trie_pool_alloc_children(unsigned int capacity, void **prealloc)
> +{
> +	struct stack_depot_trie_retired_children *retired;
> +	struct stack_depot_trie_children *children;
> +
> +	/* Capacity counts child-pointer entries; allocation includes RCU metadata. */
> +	retired = trie_pool_alloc(trie_children_alloc_size(capacity), prealloc);
> +	if (!retired)
> +		return NULL;
> +
> +	children = (void *)retired->data;
> +	children->nr_children = 0;
> +	children->capacity = capacity;
> +	return children;
> +}
> +
> +static void
> +trie_pool_release_children(const struct stack_depot_trie_children *children)
> +{
> +	/* Capacity is immutable and therefore recovers the allocation byte size. */
> +	trie_pool_release(trie_retired_children(children),
> +			  trie_children_alloc_size(children->capacity));
> +}
> +
> +/*
> + * Return RCU-ready objects before allocating. Pending children are FIFO, so
> + * stop at the first incomplete grace period. A replaced node shares the same
> + * retirement cookie and is released with its former children container.
> + */
> +static void trie_drain_pending_children(void)
> +{
> +	struct stack_depot_trie_retired_children *retired;
> +	struct stack_depot_trie_retired_children *tmp;
> +	struct stack_depot_trie_children *children;
> +
> +	lockdep_assert_held(&pool_lock);
> +
> +	list_for_each_entry_safe(retired, tmp, &pending_trie_children, list) {
> +		if (!poll_state_synchronize_rcu(retired->rcu_state))
> +			break;
> +		children = (void *)retired->data;
> +		list_del(&retired->list);
> +		if (retired->pending_node)
> +			trie_pool_release(retired->pending_node,
> +					  trie_node_bytes(&retired->pending_node->run));
> +		trie_pool_release_children(children);
> +	}
> +}
> +
> +static void trie_retire_children(const struct stack_depot_trie_children *children)
> +{
> +	struct stack_depot_trie_retired_children *retired;
> +
> +	lockdep_assert_held(&pool_lock);
> +
> +	retired = trie_retired_children(children);
> +	retired->pending_node = NULL;
> +	retired->rcu_state = get_state_synchronize_rcu();
> +	list_add_tail(&retired->list, &pending_trie_children);
> +}

Every interior child insertion (pos < nr_children) allocates a new
power-of-two array and retires the old one via
get_state_synchronize_rcu(). Once a hot node has 512..1023 children
(8,232 bytes), two copies cannot fit in one 16,208-byte pool, so a
burst of N new call sites in one RCU grace period forces N separate
16 KiB trie pools to be allocated. Also,
stack_depot_trie_save_constrained() retires child arrays onto
pending_trie_children without ever calling
trie_drain_pending_children().

> +
> +static void
> +trie_retire_children_with_node(const struct stack_depot_trie_children *children,
> +			       const struct stack_depot_trie_node *node)
> +{
> +	struct stack_depot_trie_retired_children *retired;
> +
> +	lockdep_assert_held(&stack_depot_trie_writer_lock);
> +	lockdep_assert_held(&pool_lock);
> +	trie_retire_children(children);
> +	retired = trie_retired_children(children);
> +	retired->pending_node = node;
> +}
> +
> +static const struct stack_depot_trie_node *
> +stack_depot_trie_lookup(const unsigned long *entries, unsigned int nr_entries);
> +
> +static depot_stack_handle_t
> +trie_find_handle(const unsigned long *entries, unsigned int nr_entries)
> +{
> +	depot_stack_handle_t handle = 0;
> +	const struct stack_depot_trie_node *node;
> +
> +	rcu_read_lock_sched_notrace();
> +	node = stack_depot_trie_lookup(entries, nr_entries);
> +	if (node)
> +		handle = trie_handle(node->stack_id);
> +	rcu_read_unlock_sched_notrace();
> +
> +	return handle;
> +}
> +
> +/*
> + * Publish only after the node and its path are fully initialized and all
> + * fallible allocation is complete. Publication commits the path, so it cannot
> + * then be rolled back. Side-table mappings must precede trie topology
> + * publication that makes new or remapped nodes reachable from lookup.
> + * Published storage remains valid until RCU retirement; only descendant parent
> + * links may change meanwhile.
> + */
> +static void trie_side_table_publish(const struct stack_depot_trie_node *node)
> +{
> +	const struct stack_depot_trie_node __rcu **chunk;
> +	struct stack_depot_trie_side_dir *dir;
> +	u32 stack_id = node->stack_id;
> +
> +	lockdep_assert_held(&stack_depot_trie_writer_lock);
> +
> +	dir = trie_side_table_load_dir(trie_side_table_root_index(stack_id));
> +	chunk = trie_side_table_dir_load_chunk(dir,
> +					       trie_side_table_dir_index(stack_id));
> +	/* Pairs with trie_side_table_lookup(). */
> +	rcu_assign_pointer(chunk[trie_side_table_slot_index(stack_id)], node);
> +}
> +
>  static int __init disable_stack_depot(char *str)
>  {
>  	return kstrtobool(str, &stack_depot_disabled);
> @@ -147,7 +844,7 @@ static void init_stack_table(unsigned long entries)
>  		INIT_LIST_HEAD(&stack_table[i]);
>  }
>  
> -/* Allocates a hash table via memblock. Can only be used during early boot. */
> +/* Initializes hash and optional trie storage during early boot. */
>  int __init stack_depot_early_init(void)
>  {
>  	unsigned long entries = 0;
> @@ -221,11 +918,15 @@ int __init stack_depot_early_init(void)
>  		stack_depot_disabled = true;
>  		return -ENOMEM;
>  	}
> +	if (stack_depot_trie_requested && stack_depot_trie_init_memblock()) {
> +		pr_warn("trie storage initialization failed, disabling trie storage\n");
> +		stack_depot_trie_requested = false;
> +	}
>  
>  	return 0;
>  }
>  
> -/* Allocates a hash table via kvcalloc. Can be used after boot. */
> +/* Initializes hash and optional trie storage after boot. */
>  int stack_depot_init(void)
>  {
>  	static DEFINE_MUTEX(stack_depot_init_mutex);
> @@ -279,6 +980,15 @@ int stack_depot_init(void)
>  		kvfree(stack_table);
>  		stack_depot_disabled = true;
>  		ret = -ENOMEM;
> +		goto out_unlock;
> +	}
> +	if (stack_depot_trie_requested) {
> +		ret = stack_depot_trie_init();
> +		if (ret) {
> +			pr_warn("trie storage initialization failed, disabling trie storage\n");
> +			stack_depot_trie_requested = false;
> +			ret = 0;
> +		}
>  	}
>  
>  out_unlock:
> @@ -643,6 +1353,101 @@ static inline struct stack_record *find_stack(struct list_head *bucket,
>  	return ret;
>  }
>  
> +static u32
> +stack_depot_trie_insert(const unsigned long *entries,
> +			unsigned int nr_entries, void **pool_prealloc,
> +			struct stack_depot_trie_side_prealloc *side_prealloc);
> +
> +static depot_stack_handle_t
> +stack_depot_trie_save(unsigned long *entries, unsigned int nr_entries,
> +		      gfp_t alloc_flags)
> +{
> +	unsigned int attempt;
> +
> +	/* Allow one stale pool hint before the two pools a largest insert needs. */
> +	for (attempt = 0; attempt < 3; attempt++) {
> +		struct stack_depot_trie_side_prealloc side_prealloc = {};
> +		void *pool_prealloc = NULL;
> +		depot_stack_handle_t handle;
> +		unsigned long flags;
> +		struct page *page;
> +		u32 stack_id = 0;
> +
> +		handle = trie_find_handle(entries, nr_entries);
> +		if (handle)
> +			return handle;
> +
> +		if (trie_side_table_get_prealloc(alloc_flags, &side_prealloc)) {
> +			trie_side_table_put_prealloc(&side_prealloc);
> +			return 0;
> +		}
> +
> +		/* The hint may race; a missing page is recovered by the retry. */
> +		if (!READ_ONCE(new_pool)) {
> +			page = alloc_pages(gfp_nested_mask(alloc_flags),
> +					   DEPOT_POOL_ORDER);
> +			if (page)
> +				pool_prealloc = page_address(page);
> +		}
> +
> +		raw_spin_lock_irqsave(&stack_depot_trie_writer_lock, flags);
> +		raw_spin_lock(&pool_lock);
> +		printk_deferred_enter();
> +		trie_drain_pending_children();
> +		stack_id = stack_depot_trie_insert(entries, nr_entries,
> +						   &pool_prealloc, &side_prealloc);
> +		if (pool_prealloc)
> +			depot_keep_new_pool(&pool_prealloc);
> +		printk_deferred_exit();
> +		raw_spin_unlock(&pool_lock);
> +		raw_spin_unlock_irqrestore(&stack_depot_trie_writer_lock, flags);
> +
> +		if (pool_prealloc)
> +			free_pages((unsigned long)pool_prealloc, DEPOT_POOL_ORDER);
> +		trie_side_table_put_prealloc(&side_prealloc);
> +		if (stack_id)
> +			return trie_handle(stack_id);
> +	}
> +
> +	return 0;
> +}
> +
> +static depot_stack_handle_t
> +stack_depot_trie_save_constrained(unsigned long *entries,
> +				  unsigned int nr_entries, bool trylock)
> +{
> +	struct stack_depot_trie_side_prealloc side_prealloc = {};
> +	void *pool_prealloc = NULL;
> +	depot_stack_handle_t handle;
> +	unsigned long flags;
> +	u32 stack_id;
> +
> +	handle = trie_find_handle(entries, nr_entries);
> +	if (handle)
> +		return handle;
> +
> +	if (trylock) {
> +		if (!raw_spin_trylock_irqsave(&stack_depot_trie_writer_lock, flags))
> +			return 0;
> +		if (!raw_spin_trylock(&pool_lock)) {
> +			raw_spin_unlock_irqrestore(&stack_depot_trie_writer_lock, flags);
> +			return 0;
> +		}
> +	} else {
> +		raw_spin_lock_irqsave(&stack_depot_trie_writer_lock, flags);
> +		raw_spin_lock(&pool_lock);
> +	}
> +
> +	printk_deferred_enter();
> +	stack_id = stack_depot_trie_insert(entries, nr_entries, &pool_prealloc,
> +					   &side_prealloc);
> +	printk_deferred_exit();
> +	raw_spin_unlock(&pool_lock);
> +	raw_spin_unlock_irqrestore(&stack_depot_trie_writer_lock, flags);
> +
> +	return stack_id ? trie_handle(stack_id) : 0;
> +}
> +
>  depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
>  					    unsigned int nr_entries,
>  					    gfp_t alloc_flags,
> @@ -677,6 +1482,20 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
>  	if (unlikely(nr_entries == 0) || stack_depot_disabled)
>  		return 0;
>  
> +	if (!(depot_flags & (STACK_DEPOT_FLAG_GET | STACK_DEPOT_FLAG_COUNTABLE)) &&
> +	    static_branch_unlikely(&stack_depot_trie_enabled)) {
> +		if (nr_entries > CONFIG_STACKDEPOT_MAX_FRAMES)
> +			nr_entries = CONFIG_STACKDEPOT_MAX_FRAMES;
> +		if (in_nmi()) {
> +			WARN_ON_ONCE(can_alloc);
> +			return trie_find_handle(entries, nr_entries);
> +		}
> +		if (!can_alloc)
> +			return stack_depot_trie_save_constrained(entries, nr_entries,
> +							 !allow_spin);
> +		return stack_depot_trie_save(entries, nr_entries, alloc_flags);
> +	}
> +
>  	hash = hash_stack(entries, nr_entries);
>  	bucket = &stack_table[hash & stack_hash_mask];
>  
> @@ -763,6 +1582,8 @@ struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle)
>  
>  	if (!handle)
>  		return NULL;
> +	if (WARN_ON_ONCE(stack_depot_handle_is_trie(handle)))
> +		return NULL;
>  
>  	stack = depot_fetch_stack(handle);
>  	if (!stack)
> @@ -773,6 +1594,714 @@ struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle)
>  	return stack;
>  }
>  
> +static void frame_run_init(const unsigned long *entries,
> +			   unsigned int nr_entries,
> +			   struct stack_depot_frame_run *run)
> +{
> +	u32 payload;
> +	unsigned int i;
> +	bool compressed;
> +
> +	compressed = arch_stack_depot_frame_try_compress(entries[0], &payload);
> +	for (i = 1; i < nr_entries; i++) {
> +		bool next;
> +
> +		next = arch_stack_depot_frame_try_compress(entries[i], &payload);
> +		if (next != compressed)
> +			break;
> +	}
> +
> +	/* @i is the first non-matching frame, or @nr_entries if all matched. */
> +	run->mode = compressed ? STACK_DEPOT_FRAME_COMPRESSED : STACK_DEPOT_FRAME_RAW;
> +	run->nr_entries = i;
> +}
> +
> +static void
> +stack_depot_trie_node_frame(const struct stack_depot_trie_node *node,
> +			    unsigned int index, unsigned long *frame)
> +{
> +	u32 payload;
> +
> +	if (node->run.mode == STACK_DEPOT_FRAME_RAW) {
> +		memcpy(frame, node->data + index * sizeof(*frame),
> +		       sizeof(*frame));
> +		return;
> +	}
> +
> +	memcpy(&payload, node->data + index * sizeof(payload), sizeof(payload));
> +	arch_stack_depot_frame_decompress(payload, frame);
> +}
> +
> +static void trie_node_init(struct stack_depot_trie_node *node,
> +			   const struct stack_depot_trie_node *parent, u32 stack_id,
> +			   const unsigned long *entries,
> +			   const struct stack_depot_frame_run *run)
> +{
> +	if (run->mode == STACK_DEPOT_FRAME_COMPRESSED) {
> +		unsigned int i;
> +
> +		for (i = 0; i < run->nr_entries; i++) {
> +			u32 payload;
> +
> +			arch_stack_depot_frame_try_compress(entries[i], &payload);
> +			memcpy(node->data + i * sizeof(payload), &payload,
> +			       sizeof(payload));
> +		}
> +	} else {
> +		memcpy(node->data, entries, stack_depot_frame_run_bytes(run));
> +	}
> +
> +	RCU_INIT_POINTER(node->parent, parent);
> +	RCU_INIT_POINTER(node->children, NULL);
> +	node->stack_id = stack_id;
> +	node->run = *run;
> +}
> +
> +static void trie_node_init_slice(struct stack_depot_trie_node *node,
> +				 const struct stack_depot_trie_node *parent, u32 stack_id,
> +				 const struct stack_depot_trie_node *src_node,
> +				 unsigned int start, unsigned int nr_entries)
> +{
> +	struct stack_depot_frame_run run;
> +	size_t entry_bytes;
> +
> +	run = src_node->run;
> +	run.nr_entries = nr_entries;
> +
> +	entry_bytes = stack_depot_frame_run_entry_bytes(src_node->run.mode);
> +	memcpy(node->data, src_node->data + start * entry_bytes,
> +	       stack_depot_frame_run_bytes(&run));
> +	RCU_INIT_POINTER(node->parent, parent);
> +	RCU_INIT_POINTER(node->children, NULL);
> +	node->stack_id = stack_id;
> +	node->run = run;
> +}
> +
> +static unsigned int trie_node_match(const struct stack_depot_trie_node *node,
> +				    const unsigned long *entries,
> +				    unsigned int nr_entries)
> +{
> +	unsigned int limit;
> +	unsigned int i;
> +
> +	limit = min(node->run.nr_entries, nr_entries);
> +	if (node->run.mode == STACK_DEPOT_FRAME_RAW) {
> +		for (i = 0; i < limit; i++) {
> +			unsigned long frame;
> +
> +			memcpy(&frame, node->data + i * sizeof(frame), sizeof(frame));
> +			if (frame != entries[i])
> +				break;
> +		}
> +
> +		return i;
> +	}
> +
> +	for (i = 0; i < limit; i++) {
> +		unsigned long frame;
> +
> +		stack_depot_trie_node_frame(node, i, &frame);
> +		if (frame != entries[i])
> +			break;
> +	}
> +
> +	return i;
> +}
> +
> +static inline const struct stack_depot_trie_node *
> +trie_load_parent(const struct stack_depot_trie_node *node)
> +{
> +	return rcu_dereference_check(node->parent,
> +				     lockdep_is_held(&stack_depot_trie_writer_lock) ||
> +				     rcu_read_lock_sched_held());
> +}
> +
> +static inline const struct stack_depot_trie_children *
> +trie_load_children(const struct stack_depot_trie_children __rcu * const *slot)
> +{
> +	return rcu_dereference_check(*slot,
> +				     lockdep_is_held(&stack_depot_trie_writer_lock) ||
> +				     rcu_read_lock_sched_held());
> +}
> +
> +static inline const struct stack_depot_trie_node *
> +trie_children_load_child(const struct stack_depot_trie_children *children,
> +			 unsigned int pos)
> +{
> +	return rcu_dereference_check(children->nodes[pos],
> +				     lockdep_is_held(&stack_depot_trie_writer_lock) ||
> +				     rcu_read_lock_sched_held());
> +}
> +
> +static bool
> +trie_children_find_position(const struct stack_depot_trie_children *children,
> +			    unsigned long frame, unsigned int *pos)
> +{
> +	unsigned int left = 0;
> +	unsigned int right;
> +
> +	right = READ_ONCE(children->nr_children);
> +	while (left < right) {
> +		unsigned int mid = left + (right - left) / 2;
> +		const struct stack_depot_trie_node *node;
> +		unsigned long mid_frame;
> +
> +		node = trie_children_load_child(children, mid);
> +		if (!node) {
> +			/* Tail append may produce a transient lockless lookup miss. */
> +			right = mid;
> +			continue;
> +		}
> +		stack_depot_trie_node_frame(node, 0, &mid_frame);
> +		if (mid_frame < frame) {
> +			left = mid + 1;
> +		} else if (mid_frame > frame) {
> +			right = mid;
> +		} else {
> +			*pos = mid;
> +			return true;
> +		}
> +	}
> +
> +	*pos = left;
> +	return false;
> +}
> +
> +/* Initialize an unpublished container from a stable published prefix. */
> +static void trie_children_init(const struct stack_depot_trie_children *old,
> +			       struct stack_depot_trie_children *new)
> +{
> +	unsigned int nr_old = old->nr_children;
> +	unsigned int i;
> +
> +	new->nr_children = nr_old;
> +	for (i = 0; i < nr_old; i++)
> +		RCU_INIT_POINTER(new->nodes[i], trie_children_load_child(old, i));
> +	for (i = nr_old; i < new->capacity; i++)
> +		RCU_INIT_POINTER(new->nodes[i], NULL);
> +}
> +
> +static void trie_children_insert(struct stack_depot_trie_children *children,
> +				 const struct stack_depot_trie_node *node,
> +				 unsigned int pos)
> +{
> +	unsigned int i;
> +
> +	for (i = children->nr_children; i > pos; i--)
> +		RCU_INIT_POINTER(children->nodes[i],
> +				 trie_children_load_child(children, i - 1));
> +	RCU_INIT_POINTER(children->nodes[pos], node);
> +	children->nr_children++;
> +}
> +
> +static void trie_reparent_children(struct stack_depot_trie_node *parent)
> +{
> +	const struct stack_depot_trie_children *children;
> +	unsigned int i;
> +
> +	lockdep_assert_held(&stack_depot_trie_writer_lock);
> +
> +	children = trie_load_children(&parent->children);
> +	if (!children)
> +		return;
> +	/*
> +	 * Replacement nodes reuse unchanged descendant subtrees. Repoint their
> +	 * parent links before retiring the old parent so fetch never follows a freed
> +	 * node. Lockless fetches may see the new parent before publication, but the
> +	 * old and new parent chains contain the same frames and remain RCU-live.
> +	 */
> +	for (i = 0; i < children->nr_children; i++) {
> +		struct stack_depot_trie_node *child;
> +
> +		child = (struct stack_depot_trie_node *)trie_children_load_child(children, i);
> +		rcu_assign_pointer(child->parent, parent);
> +	}
> +}
> +
> +/*
> + * Split entries into runs, allocate and initialize each node once, and link
> + * adjacent nodes through singleton children. Both trie locks must be held.
> + * Failure walks the unpublished parent chain and releases local ownership.
> + */
> +static const struct stack_depot_trie_node *
> +trie_path_alloc(const struct stack_depot_trie_node *parent, u32 stack_id,
> +		const unsigned long *entries, unsigned int nr_entries,
> +		void **pool_prealloc,
> +		const struct stack_depot_trie_node **node_out)
> +{
> +	struct stack_depot_trie_children *path_children = NULL;
> +	const struct stack_depot_trie_node *path_root = NULL;
> +	const struct stack_depot_trie_node *last_node = parent;
> +	unsigned int entry = 0;
> +
> +	lockdep_assert_held(&pool_lock);
> +	lockdep_assert_held(&stack_depot_trie_writer_lock);
> +
> +	while (entry < nr_entries) {
> +		struct stack_depot_frame_run run;
> +		struct stack_depot_trie_node *node;
> +
> +		frame_run_init(&entries[entry], nr_entries - entry, &run);
> +		node = trie_pool_alloc(trie_node_bytes(&run), pool_prealloc);
> +		if (!node)
> +			goto err_release;
> +
> +		trie_node_init(node, last_node,
> +			       entry + run.nr_entries == nr_entries ? stack_id : 0,
> +			       &entries[entry], &run);
> +		entry += run.nr_entries;
> +		last_node = node;
> +		if (!path_root)
> +			path_root = node;
> +
> +		if (path_children)
> +			trie_children_insert(path_children, last_node, 0);
> +		if (entry < nr_entries) {
> +			path_children = trie_pool_alloc_children(1, pool_prealloc);
> +			if (!path_children)
> +				goto err_release;
> +			RCU_INIT_POINTER(node->children, path_children);
> +		}
> +	}
> +
> +	*node_out = last_node;
> +	return path_root;
> +
> +err_release:
> +	while (last_node != parent) {
> +		const struct stack_depot_trie_children *node_children;
> +		const struct stack_depot_trie_node *node = last_node;
> +
> +		last_node = trie_load_parent(node);
> +		node_children = trie_load_children(&node->children);
> +		if (node_children)
> +			trie_pool_release_children(node_children);
> +		trie_pool_release(node, trie_node_bytes(&node->run));
> +	}
> +	return NULL;
> +}
> +
> +static const struct stack_depot_trie_node *
> +stack_depot_trie_lookup(const unsigned long *entries, unsigned int nr_entries)
> +{
> +	const struct stack_depot_trie_children *children;
> +	unsigned int entry = 0;
> +
> +	children = trie_load_children(&stack_depot_trie_root);
> +
> +	while (entry < nr_entries) {
> +		const struct stack_depot_trie_node *node;
> +		unsigned int remaining = nr_entries - entry;
> +		unsigned int matched;
> +		unsigned int pos;
> +
> +		if (!children)
> +			return NULL;
> +		if (!trie_children_find_position(children, entries[entry], &pos))
> +			return NULL;
> +
> +		node = trie_children_load_child(children, pos);
> +		matched = trie_node_match(node, &entries[entry], remaining);
> +		if (matched < node->run.nr_entries)
> +			return NULL;
> +		entry += matched;
> +		if (entry == nr_entries)
> +			return node->stack_id ? node : NULL;
> +
> +		children = trie_load_children(&node->children);
> +	}
> +
> +	return NULL;
> +}
> +
> +static u32
> +trie_insert_path(const struct stack_depot_trie_children __rcu **slot,
> +		 struct stack_depot_trie_node *parent,
> +		 const struct stack_depot_trie_children *children,
> +		 unsigned int pos, const unsigned long *entries,
> +		 unsigned int nr_entries, void **pool_prealloc,
> +		 struct stack_depot_trie_side_prealloc *side_prealloc)
> +{
> +	struct stack_depot_trie_children *new_children = NULL;
> +	const struct stack_depot_trie_node *path_root;
> +	const struct stack_depot_trie_node *node;
> +	unsigned int capacity = 1;
> +	u32 new_stack_id;
> +	bool tail_append = false;
> +
> +	/*
> +	 * Reuse spare capacity only for a sorted tail append. Other insertions
> +	 * replace the children container without modifying visible pointers.
> +	 */
> +	if (children) {
> +		capacity = roundup_pow_of_two(children->nr_children + 1);
> +		tail_append = pos == children->nr_children &&
> +			children->nr_children < children->capacity;
> +	}
> +	if (!tail_append && trie_children_alloc_size(capacity) >
> +	    STACK_DEPOT_TRIE_POOL_USABLE_SIZE)
> +		return 0;

On 4K pages, STACK_DEPOT_TRIE_POOL_USABLE_SIZE is 16,208 bytes. When a
node reaches 1,024 children, inserting the 1,025th child requires
capacity = 2048 -> 40 + 8 * 2048 = 16,424 bytes, so every subsequent
insert under that node permanently fails and returns 0.

Because the trie is keyed from entries[0] (innermost callee) to
entries[nr_entries - 1] (outermost caller), all traces through common
leaf entry points funnel into single chokepoint nodes:
- All KASAN kfree/kmalloc tracks share [kasan_save_stack,
  kasan_save_track, __kasan_slab_free, kfree]; entries[4] is the
  kfree() call site. Once >1,024 call sites invoke kfree() or
  kmalloc(), all new call sites fail to record stacks forever (your
  commit message already saw 835 children on one node in a short test).
- As noted on patch 5, KMSAN's [KMSAN_ALLOCA_MAGIC_ORIGIN] and
  [KMSAN_CHAIN_MAGIC_ORIGIN] nodes hit 1,024 children and break KMSAN.
- Keying from entries[0] also branches at the leaf call site and
  duplicates the entire 20+ frame outer syscall/workqueue chain under
  every distinct call site. A call-stack prefix tree has to be rooted
  at entries[nr_entries - 1] (outermost caller).

> +
> +	new_stack_id = trie_side_table_prepare_stack_slot(side_prealloc);
> +	if (!new_stack_id)
> +		return 0;
> +
> +	/* Reserve replacement topology before the path, the final fallible step. */
> +	if (!tail_append) {
> +		new_children = trie_pool_alloc_children(capacity, pool_prealloc);
> +		if (!new_children)
> +			goto err_release;
> +	}
> +	path_root = trie_path_alloc(parent, new_stack_id, entries, nr_entries,
> +				    pool_prealloc, &node);
> +	if (!path_root)
> +		goto err_release;
> +
> +	/* Commit the stack ID before making the path reachable from the trie. */
> +	trie_side_table_publish(node);
> +	if (tail_append) {
> +		struct stack_depot_trie_children *tail_children =
> +			(struct stack_depot_trie_children *)children;
> +
> +		/*
> +		 * Publish the node before the visible count. Readers may transiently
> +		 * see NULL and miss; the writer-lock recheck prevents duplicates.
> +		 */
> +		rcu_assign_pointer(tail_children->nodes[pos], path_root);
> +		WRITE_ONCE(tail_children->nr_children, pos + 1);
> +	} else {
> +		if (children)
> +			trie_children_init(children, new_children);
> +		trie_children_insert(new_children, path_root, pos);
> +		rcu_assign_pointer(*slot, new_children);
> +		if (children)
> +			trie_retire_children(children);
> +	}
> +
> +	return new_stack_id;
> +
> +err_release:
> +	if (new_children)
> +		trie_pool_release_children(new_children);
> +	return 0;
> +}
> +
> +static u32
> +trie_split_child(const struct stack_depot_trie_children __rcu **slot,
> +		 const struct stack_depot_trie_children *children,
> +		 const struct stack_depot_trie_node *child,
> +		 unsigned int pos, unsigned int matched,
> +		 const unsigned long *entries, unsigned int nr_entries,
> +		 void **pool_prealloc,
> +		 struct stack_depot_trie_side_prealloc *side_prealloc)
> +{
> +	struct stack_depot_trie_children *prefix_children = NULL;
> +	struct stack_depot_trie_children *new_children = NULL;
> +	const struct stack_depot_trie_node *new_node;
> +	const struct stack_depot_trie_node *suffix_roots[2];
> +	struct stack_depot_frame_run run;
> +	struct stack_depot_trie_node *split_prefix = NULL;
> +	struct stack_depot_trie_node *old_suffix = NULL;
> +	unsigned int nr_suffix_roots;
> +	unsigned int old_suffix_len;
> +	unsigned int i;
> +	size_t split_prefix_size;
> +	size_t old_suffix_size;
> +	u32 new_stack_id;
> +	bool has_new_suffix;
> +
> +	new_stack_id = trie_side_table_prepare_stack_slot(side_prealloc);
> +	if (!new_stack_id)
> +		return 0;
> +
> +	/* Rebuild the child's run as newly allocated prefix and old suffix nodes. */
> +	run = child->run;
> +	run.nr_entries = matched;
> +	split_prefix_size = trie_node_bytes(&run);
> +	old_suffix_len = child->run.nr_entries - matched;
> +	run.nr_entries = old_suffix_len;
> +	old_suffix_size = trie_node_bytes(&run);
> +	has_new_suffix = matched < nr_entries;
> +	nr_suffix_roots = has_new_suffix ? 2 : 1;
> +
> +	/* Reserve fixed split topology before the optional new suffix path. */
> +	split_prefix = trie_pool_alloc(split_prefix_size, pool_prealloc);
> +	if (!split_prefix)
> +		goto err_release;
> +	old_suffix = trie_pool_alloc(old_suffix_size, pool_prealloc);
> +	if (!old_suffix)
> +		goto err_release;
> +	new_children = trie_pool_alloc_children(children->capacity, pool_prealloc);
> +	if (!new_children)
> +		goto err_release;
> +	prefix_children = trie_pool_alloc_children(nr_suffix_roots, pool_prealloc);
> +	if (!prefix_children)
> +		goto err_release;
> +
> +	if (has_new_suffix) {
> +		const struct stack_depot_trie_node *new_suffix;
> +		unsigned long old_suffix_frame;
> +
> +		new_suffix = trie_path_alloc(split_prefix, new_stack_id,
> +					     &entries[matched], nr_entries - matched,
> +					     pool_prealloc, &new_node);
> +		if (!new_suffix)
> +			goto err_release;
> +		stack_depot_trie_node_frame(child, matched, &old_suffix_frame);
> +		/* Children remain sorted by the first frame of each suffix. */
> +		if (old_suffix_frame < entries[matched]) {
> +			suffix_roots[0] = old_suffix;
> +			suffix_roots[1] = new_suffix;
> +		} else {
> +			suffix_roots[0] = new_suffix;
> +			suffix_roots[1] = old_suffix;
> +		}
> +	} else {
> +		new_node = split_prefix;
> +		suffix_roots[0] = old_suffix;
> +	}
> +
> +	/* Rebuild the old path as prefix -> old suffix and attach suffix roots. */
> +	trie_node_init_slice(split_prefix, trie_load_parent(child),
> +			     has_new_suffix ? 0 : new_stack_id, child, 0, matched);
> +	trie_node_init_slice(old_suffix, split_prefix, child->stack_id, child,
> +			     matched, old_suffix_len);
> +	for (i = 0; i < nr_suffix_roots; i++)
> +		trie_children_insert(prefix_children, suffix_roots[i], i);
> +	RCU_INIT_POINTER(old_suffix->children,
> +			 trie_load_children(&child->children));
> +	RCU_INIT_POINTER(split_prefix->children, prefix_children);
> +
> +	/* Publish IDs, reparent descendants, then replace and retire topology. */
> +	if (child->stack_id)
> +		trie_side_table_publish(old_suffix);
> +	trie_side_table_publish(new_node);
> +	/* Old and replacement chains contain identical frames during transition. */
> +	trie_children_init(children, new_children);
> +	RCU_INIT_POINTER(new_children->nodes[pos], split_prefix);
> +	trie_reparent_children(old_suffix);
> +	rcu_assign_pointer(*slot, new_children);
> +	trie_retire_children_with_node(children, child);
> +
> +	return new_stack_id;
> +
> +err_release:
> +	if (split_prefix)
> +		trie_pool_release(split_prefix, split_prefix_size);
> +	if (old_suffix)
> +		trie_pool_release(old_suffix, old_suffix_size);
> +	if (prefix_children)
> +		trie_pool_release_children(prefix_children);
> +	if (new_children)
> +		trie_pool_release_children(new_children);
> +	return 0;
> +}
> +
> +static u32
> +trie_promote_child(const struct stack_depot_trie_children __rcu **slot,
> +		   const struct stack_depot_trie_children *children,
> +		   const struct stack_depot_trie_node *child,
> +		   unsigned int pos, void **pool_prealloc,
> +		   struct stack_depot_trie_side_prealloc *side_prealloc)
> +{
> +	struct stack_depot_trie_children *new_children;
> +	struct stack_depot_trie_node *promoted_node;
> +	size_t node_size;
> +	u32 new_stack_id;
> +
> +	new_stack_id = trie_side_table_prepare_stack_slot(side_prealloc);
> +	if (!new_stack_id)
> +		return 0;
> +	node_size = trie_node_bytes(&child->run);
> +
> +	/* Reserve a clone and replacement children container before publication. */
> +	promoted_node = trie_pool_alloc(node_size, pool_prealloc);
> +	if (!promoted_node)
> +		return 0;
> +	new_children = trie_pool_alloc_children(children->capacity, pool_prealloc);
> +	if (!new_children)
> +		goto out_release_node;
> +
> +	/* Add the stack ID through a clone, then reparent before retirement. */
> +	memcpy(promoted_node, child, node_size);
> +	promoted_node->stack_id = new_stack_id;
> +	trie_side_table_publish(promoted_node);
> +	trie_children_init(children, new_children);
> +	RCU_INIT_POINTER(new_children->nodes[pos], promoted_node);
> +	trie_reparent_children(promoted_node);
> +	rcu_assign_pointer(*slot, new_children);
> +	trie_retire_children_with_node(children, child);
> +
> +	return new_stack_id;
> +
> +out_release_node:
> +	trie_pool_release(promoted_node, node_size);
> +	return 0;
> +}
> +
> +static u32
> +stack_depot_trie_insert(const unsigned long *entries,
> +			unsigned int nr_entries, void **pool_prealloc,
> +			struct stack_depot_trie_side_prealloc *side_prealloc)
> +{
> +	const struct stack_depot_trie_children *children;
> +	const struct stack_depot_trie_children __rcu **slot =
> +		&stack_depot_trie_root;
> +	const struct stack_depot_trie_node *child;
> +	struct stack_depot_trie_node *parent = NULL;
> +	unsigned int matched;
> +	unsigned int pos;
> +	u32 stack_id;
> +
> +	lockdep_assert_held(&stack_depot_trie_writer_lock);
> +	lockdep_assert_held(&pool_lock);
> +
> +	for (;;) {
> +		pos = 0;
> +		children = trie_load_children(slot);
> +		/* No matching child: attach the remaining path. */
> +		if (!children ||
> +		    !trie_children_find_position(children, entries[0], &pos)) {
> +			stack_id = trie_insert_path(slot, parent, children, pos,
> +						    entries, nr_entries, pool_prealloc,
> +						    side_prealloc);
> +			break;
> +		}
> +
> +		child = trie_children_load_child(children, pos);
> +		matched = trie_node_match(child, entries, nr_entries);
> +		/* A partial child match requires a prefix/suffix split. */
> +		if (matched < child->run.nr_entries) {
> +			stack_id = trie_split_child(slot, children, child, pos,
> +						    matched, entries, nr_entries,
> +						    pool_prealloc, side_prealloc);
> +			break;
> +		}
> +
> +		/* The input ends here: reuse a stack node or promote an internal one. */
> +		if (matched == nr_entries) {
> +			if (child->stack_id)
> +				return child->stack_id;
> +			stack_id = trie_promote_child(slot, children, child, pos,
> +						      pool_prealloc, side_prealloc);
> +			break;
> +		}
> +
> +		/* The child matched completely; continue with the remaining frames. */
> +		parent = (struct stack_depot_trie_node *)child;
> +		slot = &parent->children;
> +		entries += matched;
> +		nr_entries -= matched;
> +	}
> +
> +	if (stack_id)
> +		trie_side_table_last_stack_id = stack_id;
> +	return stack_id;
> +}
> +
> +static unsigned int trie_fetch_into(const struct stack_depot_trie_node *node,
> +				    unsigned long *entries,
> +				    unsigned int max_entries)
> +{
> +	const struct stack_depot_trie_node *cur;
> +	unsigned int total;
> +	unsigned int pos;
> +	unsigned int i;
> +
> +	total = 0;
> +	for (cur = node; cur; cur = trie_load_parent(cur))
> +		total += cur->run.nr_entries;
> +	if (max_entries < total)
> +		return 0;
> +
> +	pos = total;
> +	for (cur = node; cur; cur = trie_load_parent(cur)) {
> +		pos -= cur->run.nr_entries;
> +		for (i = 0; i < cur->run.nr_entries; i++)
> +			stack_depot_trie_node_frame(cur, i, &entries[pos + i]);
> +	}
> +
> +	return total;
> +}
> +
> +static unsigned int trie_fetch_range(const struct stack_depot_trie_node *node,
> +				     unsigned int offset,
> +				     unsigned long *entries,
> +				     unsigned int max_entries)
> +{
> +	const struct stack_depot_trie_node *cur;
> +	unsigned int end;
> +	unsigned int start;
> +	unsigned int total;
> +	unsigned int pos;
> +	unsigned int i;
> +
> +	total = 0;
> +	for (cur = node; cur; cur = trie_load_parent(cur))
> +		total += cur->run.nr_entries;
> +	if (offset >= total)
> +		return 0;
> +
> +	max_entries = min(max_entries, total - offset);
> +	end = offset + max_entries;
> +	pos = total;
> +	for (cur = node; cur; cur = trie_load_parent(cur)) {
> +		pos -= cur->run.nr_entries;
> +		start = max(pos, offset);
> +		for (i = start; i < min(pos + cur->run.nr_entries, end); i++)
> +			stack_depot_trie_node_frame(cur, i - pos, &entries[i - offset]);
> +	}
> +
> +	return max_entries;
> +}
> +
> +static unsigned int trie_fetch_handle_into(depot_stack_handle_t handle,
> +					   unsigned long *entries,
> +					   unsigned int max_entries)
> +{
> +	const struct stack_depot_trie_node *node;
> +	u32 stack_id;
> +	unsigned int nr_entries;
> +
> +	stack_id = trie_stack_id(handle);
> +	rcu_read_lock_sched_notrace();
> +	node = trie_side_table_lookup(stack_id);
> +	if (WARN_ONCE(!node, "corrupt trie handle %08x\n", handle)) {
> +		rcu_read_unlock_sched_notrace();
> +		return 0;
> +	}
> +	nr_entries = trie_fetch_into(node, entries, max_entries);
> +	rcu_read_unlock_sched_notrace();
> +	if (nr_entries)
> +		kmsan_unpoison_memory(entries, nr_entries * sizeof(*entries));
> +
> +	return nr_entries;
> +}
> +
> +static unsigned int trie_fetch_handle_range(depot_stack_handle_t handle,
> +					    unsigned int offset,
> +					    unsigned long *entries,
> +					    unsigned int max_entries)
> +{
> +	const struct stack_depot_trie_node *node;
> +	u32 stack_id;
> +	unsigned int nr_entries;
> +
> +	stack_id = trie_stack_id(handle);
> +	rcu_read_lock_sched_notrace();
> +	node = trie_side_table_lookup(stack_id);
> +	if (WARN_ONCE(!node, "corrupt trie handle %08x\n", handle)) {
> +		rcu_read_unlock_sched_notrace();
> +		return 0;
> +	}
> +	nr_entries = trie_fetch_range(node, offset, entries, max_entries);
> +	rcu_read_unlock_sched_notrace();
> +	if (nr_entries)
> +		kmsan_unpoison_memory(entries, nr_entries * sizeof(*entries));
> +
> +	return nr_entries;
> +}
> +
>  unsigned int stack_depot_fetch(depot_stack_handle_t handle,
>  			       unsigned long **entries)
>  {
> @@ -787,6 +2316,8 @@ unsigned int stack_depot_fetch(depot_stack_handle_t handle,
>  
>  	if (!handle || stack_depot_disabled)
>  		return 0;
> +	if (WARN_ON_ONCE(stack_depot_handle_is_trie(handle)))
> +		return 0;
>  
>  	stack = depot_fetch_stack(handle);
>  	/*
> @@ -813,6 +2344,8 @@ unsigned int stack_depot_fetch_into(depot_stack_handle_t handle,
>  	if (stack_depot_disabled)
>  		return 0;
>  	WARN_ON_ONCE(!entries || !max_entries);
> +	if (stack_depot_handle_is_trie(handle))
> +		return trie_fetch_handle_into(handle, entries, max_entries);
>  
>  	stack = depot_fetch_stack(handle);
>  	if (!stack)
> @@ -835,6 +2368,8 @@ void stack_depot_put(depot_stack_handle_t handle)
>  
>  	if (!handle || stack_depot_disabled)
>  		return;
> +	if (WARN_ON_ONCE(stack_depot_handle_is_trie(handle)))
> +		return;
>  
>  	stack = depot_fetch_stack(handle);
>  	/*
> @@ -851,11 +2386,53 @@ void stack_depot_put(depot_stack_handle_t handle)
>  }
>  EXPORT_SYMBOL_GPL(stack_depot_put);
>  
> +static void trie_print(depot_stack_handle_t handle)
> +{
> +	unsigned long entries[STACK_DEPOT_PRINT_CHUNK_FRAMES];
> +	unsigned int nr_entries;
> +	unsigned int offset = 0;
> +
> +	while ((nr_entries = trie_fetch_handle_range(handle, offset, entries,
> +						     ARRAY_SIZE(entries)))) {
> +		stack_trace_print(entries, nr_entries, 0);
> +		offset += nr_entries;
> +	}
> +}
> +
> +static int trie_snprint(depot_stack_handle_t handle, char *buf, size_t size,
> +			int spaces)
> +{
> +	unsigned long entries[STACK_DEPOT_PRINT_CHUNK_FRAMES];
> +	unsigned int generated;
> +	unsigned int nr_entries;
> +	unsigned int offset = 0;
> +	unsigned int total = 0;
> +
> +	while (size &&
> +	       (nr_entries = trie_fetch_handle_range(handle, offset, entries,
> +						    ARRAY_SIZE(entries)))) {
> +		generated = stack_trace_snprint(buf, size, entries, nr_entries, spaces);
> +		total += generated;
> +		if (generated >= size)
> +			break;
> +		buf += generated;
> +		size -= generated;
> +		offset += nr_entries;
> +	}
> +
> +	return total;
> +}
> +
>  void stack_depot_print(depot_stack_handle_t stack)
>  {
>  	unsigned long *entries;
>  	unsigned int nr_entries;
>  
> +	if (stack_depot_handle_is_trie(stack)) {
> +		trie_print(stack);
> +		return;
> +	}
> +
>  	nr_entries = stack_depot_fetch(stack, &entries);
>  	if (nr_entries > 0)
>  		stack_trace_print(entries, nr_entries, 0);
> @@ -868,6 +2445,9 @@ int stack_depot_snprint(depot_stack_handle_t handle, char *buf, size_t size,
>  	unsigned long *entries;
>  	unsigned int nr_entries;
>  
> +	if (stack_depot_handle_is_trie(handle))
> +		return trie_snprint(handle, buf, size, spaces);
> +
>  	nr_entries = stack_depot_fetch(handle, &entries);
>  	return nr_entries ? stack_trace_snprint(buf, size, entries, nr_entries,
>  						spaces) : 0;
> 
> -- 
> Git-155)

