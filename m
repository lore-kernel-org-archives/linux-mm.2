Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50605C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48BAC6B0088; Mon, 27 Jul 2026 11:57:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43BBF6B0098; Mon, 27 Jul 2026 11:57:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379076B009B; Mon, 27 Jul 2026 11:57:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 115ED6B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:57:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91B62400C8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:57:20 +0000 (UTC)
X-FDA: 85035011040.24.D0F7887
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id BFD2A4000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:57:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=t8c2gWz+;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785167838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsjdjJOss8ZPRd2OUIRraaCz1T4f5WbswiL+iOMIAm4=;
	b=xjb5nEyWHOcFszrBVAvkzPsRtboFQdy1n2lV/0SGebrIikrort6t3E96OklJtPpPgqfrN6
	AeuTlD3tu90Q0B7f0zKF1ZjLjxx0Kd5FYHfoldjlI4LUhDMvzgSdSPCHFaa9m++rilZJxQ
	umVM/VHoAc03Cr2jAd5kbSjY/rU9L7c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785167838;
	b=FkzdXmVuyzDTIJKQLkSercghDtYX9ZKLTaVt5vHV+xIUC+2FqT/P7bjQBHZNt1Zg4tTu95
	/ONF7gEfLfqtOa/9fKAVLRcnN3qhGqoIn7Bokqye+wVAeow6kZJ6oOIesIILYTQh2zSQ+c
	UMgDljl1eBk9C/jtvRUl18ZBubPx+Ds=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=t8c2gWz+;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e4fd65b2bso161846885a.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785167838; x=1785772638; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tsjdjJOss8ZPRd2OUIRraaCz1T4f5WbswiL+iOMIAm4=;
        b=t8c2gWz+qrNmRACUAGA/mioXXSWL387UryeskuFKqCIO7LCZVbGPWMp5cc8yyAngG7
         YivV7zaF5URWSxthPEgbvjERWbT5i+6bHO5GXOiAVmswCrzNOsgtkj4uJ/Np3kWEKfsR
         bg0sKWFO2UREQPT7jV2XFATNQ5q5t/cwN586We94nse439Hwijf8NdfkSX4h03zwqcGc
         Ir0plLlIn+W6QevS9XkXjqj0SVVU/I9Jg3FzmgwlvWqBR+puF222jzxWJSsbnYhaW8j4
         CdpiAVE08RHRsjPmO4cNZPgc1kVNQMw2G2VO/eFMfdn5Lh5PV+WVciShuxFRhbDx15S1
         xkVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785167838; x=1785772638;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tsjdjJOss8ZPRd2OUIRraaCz1T4f5WbswiL+iOMIAm4=;
        b=Cf94Wk6qyZ17zPAJ+HnW1SOdArLsbbW67ahLHMKMnkh2yF+lELQHQnvy6sT2SH+XJU
         QvZs1iSZwiqwMY0RjKRaagVoYB+r41aDdUumMk/1TrtYde3lP5OcgY1fla2xbTL5j/Md
         B6TXJIA1D2x8nWpZmoqIy/Z+c/zzeftKPB00v80Cj8KqmEs4d/BIEcMHaRQEr6Rot51e
         8X2Yn5pdZWpoB4lLx3f9FYOoQ7hrejlpvOeWx/eWyBA4d5g0OSeEHr65lZhAUjoBU6tA
         NoiB6dfQBks9pVYWZfP5Jn68bCgHcn9/3mLVspwLXozAb49k5YvMa4cHdA9uKnzTc+SN
         2HCw==
X-Forwarded-Encrypted: i=1; AHgh+RokA1R7grWrCQ7040PRKDFgU2Ho7wdRsVsO9XEgBrF3hemuONhdrWvd/v4hsseRDm/Ef3Nmrlhp/w==@kvack.org
X-Gm-Message-State: AOJu0YyHLLHg/b7twCRUDVn+XMIUXRvvvlAiIMt5HWTGLvhW6u7Niykw
	IHXBQWdpKLeSPWcM0woLAHMnxOeZz72dFZWCSp7RIaFE0zNE6WyEu2KMcU7fUQ4r/jM=
X-Gm-Gg: AR+sD11xEdZN4axwJGofSUUsAxjnDvYpRZvuXGe/wLQCVaOfOBMAyCSc04WqpDGR5Mr
	pkc4PdAiI/93gxmRzWHHl1N/AbbEpcQaRTjEKcYpycJDoIy40iPsjtsXcMWBlzaEG8IEqv/4q/1
	RLenEE9xn2MHJLxdb4wwUtdwik/rUs3ynGA0KW7X0/1swdzBnMNzKHO6Tb5BQzyj6BD6z1tOUqB
	kmbvziq/aO50ECAtzclXPL9DrHLaGEU2vsF3bpxYs8gdKb3HDn6EXdjzdbYVbPijoi6JxIXI7zE
	cFY6UTMkISOV0AJ7YbP9iMKW9uyldBu16svyiJcHxD0uUCL+12jCo94kGo5hklLwW5cWKY/P/v3
	N1wXGYSbIuvKeMWYGmYGv1m2TWILzJmYgHeI1lI8uBNgmBNoUaCG3w3UZLuH4+lIEsyx5Jfs27A
	2df9cA0nLMgaT11ucd3FqrS/rhRVRCX4xkyfARgNw0hSPOuWuh8lN95TzyEA==
X-Received: by 2002:a05:620a:3910:b0:930:fbdd:c242 with SMTP id af79cd13be357-932df67421dmr1063178185a.29.1785167837883;
        Mon, 27 Jul 2026 08:57:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de65239asm631205585a.32.2026.07.27.08.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 08:57:17 -0700 (PDT)
Date: Mon, 27 Jul 2026 11:57:11 -0400
From: Gregory Price <gourry@gourry.net>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, paulmck@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/migrate: report RCU-tasks quiescent states in
 migrate_pages_batch()
Message-ID: <amd_roVfML1xvLEZ@gourry-fedora-PF4VCD3F>
References: <20260727-kcompact-v1-1-bdfefddd6874@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-kcompact-v1-1-bdfefddd6874@debian.org>
X-Stat-Signature: ee5n54eh87aua71cf99zy8z53qkjbpws
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BFD2A4000D
X-HE-Tag: 1785167838-645698
X-HE-Meta: U2FsdGVkX19f4VcE5XWLag2Zx6+raRFzxLfLpIosdq5feqcJQSULoT0SO9inqYkTtWwfUxhXDPN8LRJrEXWf1lV6Zb3tODSqc5MlJCpcm10udfXHiE/E0d/DmRAKkeEJ6/scub6XXY/iegHh6gOUv20CPU4r33DFpUmBW3GE77Jxa/jpJm04ROMtNN0lm6uAIC4wmJI80oVKcu3paxHocdP5g/JYW1kHF1zjbeB3LpdY8Uf629CHFRRfmNF4aiXcTrQIJixlYSuRWBeBTyo1yocSFUigvqd/MZpggpqPBio/7qkfRC2Clf3b4LqcU7CVEzMJ0oBp5j5bC2N54kRgi0MCdDmlG7RIzYSLhkrDX6Gnbsp/4iDUENY9odU+eEzg3AuACHfflz0I74g1ItQjRRpeOWNXo1sLicoq0t4BUMSGGPQvuTWY4RrZwnIH6IjIKBlx1nbOxxNkwmgwgPXMRMyuEMiY7dqICpBSIaHksTAkws/QWMajyL/z3B078twy9+B9RL04Bgv8yzzPyrPlSAn9aDOZ47HvMKQiBmRU/OkPneVsz5/cs1yJgN0IH7GBFCzkLpedslaRwrBlFGEG+VDtXufMHR8Mi0znnI6nmeE2g6frwyuRi1N+W9VWJ6LUj1QhXvzqlC8YWcsU1ot4hddLoNjDexBZdMtvRWJIjv2QmSuBjy8XK7AOa2TcbIJWD6Bc1pt3ZmtUnzs6iv8ZakqEI6iQhO2C5IyFwP83tQdqe0GTvcyax+JBKrikuqfr7SRfCEQew4I2oOuJ1qaCmbMk/sbtC34oTJD0IS1Q2rf+2N8+7jFCGPdt7wStWPptfNk6odxFgEbsiI9WiGCIjXr08OFxsQDReWlVnFLpxhqltGZovCoxeHc4TxyO0wPYOd9sYe+ZsHUZ8KvpIfKz/Xq0k+kAMxkUH+Meg1Gh60Z2k4cU2y0SvPMpbCYEajdMqeZJ8j7cy24SFKCblPc
 m0gcp/jf
 Oxm+4pgyS8R5s+RVABegpvsziqX/wfuRgkpsvXvgJQI6R7A7CIblnQOqhpVBeo/0juHQ5wPf00QtFCJQqtT6RU35E2V6BN3aIUvPQhpXlpew2b7j8c3EH4rp3LSWGIzA3QkOwU4gUXBGe+M5Uc/EDditmJApGGMjnzvtZW9KnFsYOUvHPqna9Zky0cHMA3lg+gohXjci5y1w75hMNBh2zXZ5Rsec0DLYDhdUISZXi5YDrgpEvz2lkuEUIE7PMtoXdD8ALC6//Ukfov5yngbNorCFZnHuBdpVVQx6TREkjj7spit75AwbaUoH2waPpl7RH4zfnMYy7cVOafXdiaRkOhgWchZfK4scHVEEDFhIRrOCClX6yRpDvUgqVbPoD6aYiLfpqimMtKEBmpNXo6MDtIBzDPcGU7n4Y9YXcmjX4Y0G6etkSZ9vauKwMPxI+SDkGKji1HUtgDeMu4gZFTI1E0zkGfVIj3GICKWHQO+N0DPEs3ntmcoUEc2ktbScCkJafAVQyChlZ7y/fVdEmFUbrZF/PFV0LadizQuhP4Cuc5+V/2SFVQyWh5RQMNupyQv4dDxDGjrsnjYLUxC0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 06:50:19AM -0700, Breno Leitao wrote:
> migrate_pages_batch() unmaps each folio before moving it, and every
> unmap runs the mmu_notifier invalidate callbacks.  On KVM hosts
> try_to_migrate() ends up in kvm_mmu_notifier_invalidate_range_start() ->
> tdp_mmu_zap_leafs(), which is expensive, so unmapping a large batch keeps
> the CPU busy for a long time.
> 
> The loop already calls cond_resched(), but on PREEMPTION kernels that is
> a no-op, and involuntary preemption is not a Tasks-RCU quiescent state.
> 
> A long batch therefore never reports a quiescent state, and the
> migrating task (e.g. kcompactd) becomes a Tasks-RCU holdout, stalling the
> Tasks-RCU grace period for minutes, which is common at Meta fleet:
> 
>   INFO: rcu_tasks detected stalls on tasks:
>   0000000055349ecc: .. nvcsw: 1157401/1157401 holdout: 1 idle_cpu: -1/56 task:kcompactd0      state:R  running task
>   Call Trace:
>    tdp_mmu_zap_leafs
>    tdp_mmu_next_root
>    gfn_to_pfn_cache_invalidate_start
>    kvm_mmu_notifier_invalidate_range_start
>    __mmu_notifier_invalidate_range_start
>    try_to_migrate_one
>    try_to_migrate
>    migrate_pages_batch
>    migrate_pages
>    compact_zone
>    compact_node
>    kcompactd
>    kthread
> 
> Use cond_resched_tasks_rcu_qs() so a quiescent state is reported even
> when cond_resched() does nothing.
> 
> PS: This has also been discussed at [1]
> 
> Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


