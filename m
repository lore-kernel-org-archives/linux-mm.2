Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1481CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266A46B00A1; Mon, 11 May 2026 11:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23D826B00B1; Mon, 11 May 2026 11:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154C56B00E8; Mon, 11 May 2026 11:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 058126B00A1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:53:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B898401E3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:53:36 +0000 (UTC)
X-FDA: 84755584032.16.FAB939B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D895B80008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:53:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F8DWqg7r;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778514814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5DQl4N1aosxfGRItuAylVDVgj84JHcgHJS7Fak0Rwo=;
	b=c/nG9LZtZNvCGHu/VxXyS4TJBDkyfLM5N18mHCE8nn669wnRYT8T8CQab2VmUYLaKLodaN
	5v/ib1RhgfMlCor7CDyYKgClsP+l9XCZ3Q8XHgVy3l+vaZrTsgA22AS7fzrmEEy7Vsb2Es
	iDTEKlFlY8R0ZduQcSTaXqyCISpqMTw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F8DWqg7r;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778514814; a=rsa-sha256;
	cv=none;
	b=C/evSl6FVgUlO30aI5eQhKgmYyCTux1zkwAHIuXwJrLjGb368EfKgmeBYkAbQOjtW/dn8n
	VxFliaJECzVwNoIRHl904V70TV5eZhGMDi650zdpkK6LJkaSRG4dNj6zm6f35idTQbmCHa
	HEsFWKYgFbl/bHpJrAUn2e7TyjwlJIE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A8BE60103;
	Mon, 11 May 2026 15:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA717C2BCB0;
	Mon, 11 May 2026 15:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778514814;
	bh=SnAkfE24ca2jtyTZMDfreShDIAAPWeFO+kOTNCDv/TA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F8DWqg7rI3nnQzIVpolksEhrFcuOfoRLRo4DwLE0wdYu7zfm7gJCefP9avj2VvDNY
	 KVGYpZg9045/pEsr4UtSdGK5HavzTS+ibvxS6OYH8GHrcjbqSsHcjONr8mVjJ5KNAk
	 vsBnzMpc8TXTbMAaxCLyz4huBftufwbddNfS1NWalEs281F9xsmuGfdsIHLZXP5/QJ
	 qmxoX6x/AMggefDmFgmRtFWvIvG5Kwj+SjEswlLZJOkfMx191RoLwACg0h0yOJ7O9z
	 T8xN9KiLgjbJP2Uo4tCHqIR+hrPNPrb1mDM5rSrTIadrIXFG8ddj/xc0hlbc9Vlz1f
	 JANtLwqyhJdsg==
Message-ID: <98a16642-35b7-4cf9-9ee2-8de15e877920@kernel.org>
Date: Mon, 11 May 2026 17:53:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
To: Shivank Garg <shivankg@amd.com>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428155043.39251-2-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D895B80008
X-Stat-Signature: iq73kdwnd181m1jgag9kf5gwjep9o5id
X-HE-Tag: 1778514814-887224
X-HE-Meta: U2FsdGVkX18dnGzzpl6Oo1QXeG0xoBojgSMq1ZlXXlLZhAdcyiZIcLE0h5Prb8n5XY8pMitNBnYFvSa+CDqrkclqNjQPZLvrBU9eL6/EXrlbZGBiTxBWTwtGmknIcuEKJpn9cthJ1rJY1OEWkfljy/nPQH7Q/zIkhSUmx8OiVTDqAOsCk5aYFxizJver9EsMxtXrDxOnFeeXg6B1w4SKNqChdtYwv2G7zRo0RKMzPtCwlFpBjzhJBSPR3srcFlchfstzWIB7nQiABWiHr72CksJ6Nkme3N417R2aETf2oPF20b6JDBse5IQwOuh4qUDU1aRJvL3pdA8NTPNgy2BhzpiXk0KfEi5lPqOwJDFG9WK50qJJtP8osZbeRSLJzpNzCgELFCiW/pPE06Usg8yDdYAbbco6szavoVTBpjvBWcOvLdIA92Pw5yW3AmdKwvDHe6JF+5KMcTUE4vYrC8xsMrYCRcVHAZprG2R3iZdImKcCvqUaRcU4v8YikoVUtiDF/esLO5dFsAqYgPaDBX5+QQ3MaK8YFP9wQl9JJH+bcgqPyz4iGMyRq8mr5iABt6D5sjdxWodQszgdUQLY2XxwgYjzhHci1QsZ+r8aryoFJSscqyO15oOrDBfJzGndy6e9YVTjJ/fk/O8eJ2jg1Xcq9I85ZlsldJTAWmGaZNJh1fswx2FyE+SoX4ENMa7Ne/8BrvMDkPxZr6iyyk2cMtP6PJAaeP4W5DVAickusBMbknGfcLQLpZKj4ZMUORmZuERdlwJfDG0IQKdrNeD00VRPkb0l4sXNloZgQb0BFPfdhC+PjWGLBEKBASLjhcfLRp0/Xbwv10tIvUiPLrynUzVTTlXCVzh/el9KnFZT1Mtq2FgtaKFOc0i3skVf7zlfb7J6Q41TomUYVKuHfC+4nB3fldu6kJM/6tJBYLEqdqIfKxS0U4Vr/Wu8jZtAi61S0cAoEpN/DrJmWcC6xJvwHVm
 CG3imVIO
 R5/Cxyb9ti6N7vfm9KsGglLtOpKcxYN/jTWiW+qyxDhqwByspuS3ublTIjy8280rxvAf24Liwmjs/phocr3n9cIQ411k7TrIizZuxf5l/xawa4pISXOKsoLvi+IVtjk5TeGP2MLafKbIcxV0TJgIpVNV0gkMZc5DTOJIw/cZFZ8R8vUo2JZNJHbGfMz+qqOXkRQRmPLlox3hiv6BUvd25AwSC1Tlsd9uD/5cPc4jMYoz4LvrCYjI8EeK9hJy5WaAiAE97mYFJ7Fr+FQ6UW4dnVvknyk4y1ZCH1nA7bR5xnUnrWCxnaEzM7DP0Bq+gDALsQF4ycTprLsO+qSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 17:50, Shivank Garg wrote:
> This is the fifth RFC of the patchset to enhance page migration by

Ah, this is an RFC ...

... I suggest b4 for patch series management :P

That also explains why patch #7 is still in there.

> batching folio-copy operations and enabling acceleration via DMA offload.
> 
> Single-threaded, folio-by-folio copying bottlenecks page migration in
> modern systems with deep memory hierarchies, especially for large folios
> where copy overhead dominates, leaving significant hardware potential
> untapped.
> 
> By batching the copy phase, we create an opportunity for hardware
> acceleration. This series builds the framework and provides a DMA
> offload driver (dcbm) as a reference implementation, targeting bulk
> migration workloads where offloading the copy improves throughput
> and latency while freeing the CPU cycles.
> 
> See the RFC V3 cover letter [2] for motivation.
> 
> Changelog since V4:
> -------------------
> 
> 1. Renamed PAGE_* migration state flags to FOLIO_*. (David)
> 2. Use the new folio->migrate_info field instead of folio->private
>    for migration state. (David)
> 3. Fold folios_mc_copy patch in batch-copy implementation patch. (David)
> 3. Renamed migrate_offload_start()/stop() to register()/unregister().
>    (Huang, Ying)
> 4. Dropped should_batch() callback from struct migrator. Reason-based
>    policy now lives in migrate_pages_batch(). Migrators can still skip
>    a batch they don't want (size based policy). (Huang, Ying)
> 5. CONFIG_MIGRATION_COPY_OFFLOAD is now hidden and selected by the
>    migrator driver. CONFIG_DCBM_DMA is tristate. (Huang Ying, Gregory Price). 
> 6. Wrapped the SRCU + static_call dispatch in a small helper. (Huang, Ying)
> 7. Requir m->owner in migrate_offload_register(), SRCU sync at
>    unregister relies on it. Counters are atomic_long_t to avoid lock-order
>    issue.
> 9. Moved DCBM sysfs from /sys/kernel/dcbm to /sys/module/dcbm (Huang, Ying) 
> 10. Rebased on v7.1-rc1.
> 

[...]

> 
> OPEN QUESTIONS:
> ---------------
> 
> 1. Should the batch path run without a registered migrator? Patches 1-4
>    are self-contained and use folios_mc_copy() (CPU). I have several
>    options like making batch path always-on for eligible folios, or
>    giving admin an option to flip the static branch, or keep the gate.
>    I'm leaning toward always-on.

Hiding that detail from migrate.c sounds interesting.

> 
> 2. Carrying already_copied via folio->migrate_info vs changing the
>    migrate_folio() callback signature (Huang, Ying). I went with the
>    field for now to avoid touching every fs callback before the design
>    settles. Happy to revisit.
> 
> 3. Per-caller offload selection: Today eligibility is by migrate_reason
>    only. Some are latency-tolerant, others may be not. Is reason the
>    right granularity, or do we want a per-caller hint?

Isn't it sufficient to just do it based on the #folios or sth like that?

If someone migrates a handful of folios, latency is likely more important (and
batching less beneficial).

I'd assume when migrating many folios, batching could just always be done. Or
what's the concern?

> 
> 4. Cgroup integration: How should per-cgroup be accounted for different
>    migrators (e.g.: any accounting for DMA-busy time)?

Oh. Do we even have to mess with that?

> 
> 5. Tuning migrate_pages callers for offloading. For instance, in
>    compaction COMPACT_CLUSTER_MAX = 32 caps DMA's payoff for compaction
>    (V4 experiment).

Is that HW dependent?

> 
> 6. Where do batch-size thresholds live, and how are they tuned? Per
>    Huang Ying's split, that policy lives in the migrator. DCBM has no
>    threshold today. Open whether it should later be a per-migrator
>    sysfs knob or hard-coded; probably clearer once a second migrator
>    (SDXI, mtcopy) shows the trade-off.

Again, sounds like being HW dependent, no?


-- 
Cheers,

David

