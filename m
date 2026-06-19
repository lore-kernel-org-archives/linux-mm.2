Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B15CD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 03:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AC386B008A; Thu, 18 Jun 2026 23:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D406B008C; Thu, 18 Jun 2026 23:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8DEA6B0092; Thu, 18 Jun 2026 23:40:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7CBF6B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 23:40:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15AFC40315
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 03:40:51 +0000 (UTC)
X-FDA: 84895260702.17.6BEADBB
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 28A6E20002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 03:40:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qaug18ij;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781840449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZsT2A6vcJvvOIiYPu7Uwiedbr6l9fXs1eEHFyyaKQfw=;
	b=awveBDffzqo3ImBydwLR/YkkMP4m2c8039z7GrjtIk9LfvqmNvO7Pjat1zMyEcj/IWJvvy
	za6Q7RtxYtrpBb9tKHiOVR6TVI3YhgG5RVKmpeqD6YGKYv4xPR+qTt04iciTUTtM/KYhZs
	Eg2VNhbOMWqBu6crvoISb4JpAJNbjoc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781840449;
	b=cokTY/+AWPzFerE+OdxHqrt19pFo1ZrK+egJiThRvwIL5mYcQTy4A2l0pUeM19F6jF8Q0M
	Zj+xmqzejA7QviodC4j+8PZ2W7Ze0U/hg2GsEJrK3xqFomHmtTxSEpcqmJVin7ZteOmXKo
	rT2X0Gv4sgtONdfYXrdJWzg7uUO2qCs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qaug18ij;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-30c09f29b64so182784eec.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781840448; x=1782445248; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZsT2A6vcJvvOIiYPu7Uwiedbr6l9fXs1eEHFyyaKQfw=;
        b=qaug18ijYkyo5zYAYg/gANYsdnxeXPgYNQYGiZ8nPu5PyHAZIodYc1NJhds+sPVT60
         UlTONN3pKJmpXx85izK8IYbJsDSc3jV9c6OIue2nmx18ZVfbzwa9aIioYMYBMm++45kS
         MNx5N0YMdsazzKk4ll3TYaWDKjQYR2ajUwYph3JkNISv+Pw9bbCrS4Y1/jRZYhdhvO+o
         ZCEWSNyQWzojoVha+QgAtRN7HpCFq9XcMKmZcnOSZZ+JrAtqwb3g+IVThlbT3sAMLUpm
         g42KezBUkkEVeyzY6P/I+HHdnIp+qj/JVlEXhcxgqEj4fUV12De4khGYqDn5fBsvSyeL
         U9pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781840448; x=1782445248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZsT2A6vcJvvOIiYPu7Uwiedbr6l9fXs1eEHFyyaKQfw=;
        b=lgzz1gYdL/52EnNRqEfefjYvw9SNoLMCMtoQF6rxpaV/yarAB7twQiVNA7aZqPW+Ov
         muD9Zmdh523dgcQ7GjBFKLiNO6hUyCEv/h/wwqGp+j0otM+6sWvTRqK0zwgeT51rVjeW
         Eun+0WDhDI4zd1JkV/7c6yfplXlXA4paxLfYWcKu7OH/eYPkniodrDVuctV66ynMU0FF
         mf7MKUC0PnA2qjHMVVWPjcK2gDl2gpg8IyGhkyQQDGFAnnHr6kVp7y1L4+a4RxRREVlW
         NCQKFwoCuDSIaWzxNXGC2OhJtt56R74r3Rt6GW5/LkSKUQLTEY3GJiPQ50HrmYY2+BVu
         8uAw==
X-Forwarded-Encrypted: i=1; AFNElJ/GCafGCK08poY4xFpwYaMwZL+ke1BQoXzKYWBIETRiORbbgncfiZUSSYChOO6F7EZBnW9hOhpErg==@kvack.org
X-Gm-Message-State: AOJu0Yz+jp86QILbGtbEiK8vwGCgM2dmCUvyMrKb0r/ZlTsbF2E/UH+A
	x1j37hEIWWOlUMevt0LWkAh+0e4sKUhZugDA8Vzk0z9bBqfNEuXJgk+A
X-Gm-Gg: AfdE7cm6ONy6s6HygVF8F4bxj2HVPLHCaqew8zA5Vsi0pVzkEmWFS2ZBpm36YGCggD6
	MJqf2GrXmep838dWZrRu47m9tVC9dwBByuccLYr502Kbdw4jfgV0lygiYSgpaAR9pQ8Lf9rlu0u
	dXIciTe5CAkrqQ00mJAFpkQxXTNew/peR6haKlPoRDGLEizp1MCHKoJ3nGID5dT+ZwIrM3ZMM7Y
	PmMU45270iA89D70el5ycaagD3sp0cjPwjM84f2GoW/y3zYLq/zAT+cxEW+HEN6JXue3hbGE5fz
	8VLXIt4b8OIutQBoVDxKCpxnAutpcE2eMQYp7vlggocTTgJEhhXok7liMJxTLEQ/B0hlSlu4WM6
	pS1PL1QB8o47z1q6gLvQuTDxFkThI3FSY17yJJCP3plhl99EsLq+mFbspDz2+3DfBw+cgGy2gCc
	mXt3SYZ8AmPON8s1jSkLbPRNs=
X-Received: by 2002:a05:693c:3110:b0:304:56fc:775 with SMTP id 5a478bee46e88-30c07a0f2d0mr1157147eec.21.1781840447613;
        Thu, 18 Jun 2026 20:40:47 -0700 (PDT)
Received: from localhost.localdomain ([104.28.158.91])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c06d6766fsm1973267eec.29.2026.06.18.20.40.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 20:40:47 -0700 (PDT)
From: Wang Lian <lianux.mm@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	daichaobing@sangfor.com.cn,
	gutierrez.asier@huawei-partners.com,
	kunwu.chan@gmail.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	npache@redhat.com
Subject: Re: [RFC PATCH 0/6] mm/damon: Add mTHP-aware collapse/split with ARM SPE feedback
Date: Fri, 19 Jun 2026 11:40:39 +0800
Message-ID: <20260619034039.35643-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260619014707.9297-1-sj@kernel.org>
References: <20260619014707.9297-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 28A6E20002
X-Stat-Signature: de8dg886dr8i6nzdctozm68z74dmwris
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781840448-391808
X-HE-Meta: U2FsdGVkX1973Y3n5cMdlhdPrLIoZ205pm8XXmzkGBjEg89InEAB6MsRsrzy7TxJ+gORlu6Oo7jNtw52T0hxCte6ApqrFLTqyYcxSdY8HEEOOs97TcjuE31Fqj/UabPjrg7xBFJPPW4F/9uENHNA8FZPuwTTEOQeHA1MUYSxkwCj+Lqi5wTpPwScoMNy9JhqkvVuwewCH5OoLMS9RqH7BQcfKYVT3xQr8HR3iNptH8Rpf/Ml9FjrvXZKOFDguB1sLNRPGkXd8bcC3z5AbpL8xlJmFpIuVa7VWhmokAXLNhwCgNbl7KjT+EEOMiE/X07Mgoe9Of2tFhXSoiJep1qBowvdnCS2VUufSbqgnn1NnkVt6YYXm0jY1yM+BYFoB8MLgqYEq3QbNIWvu26Uv5xtiVO8FtMyM6BqwcQZjNWYzaMzY3Wnvn2G0JUIpJtnZW+WGTWCcYXtCLu1BT/1KwY4XrKdsmvxrLJ+BwwjbJnaoq3G2zICOHPvCkZ9Qzm6mjeacghgSlMVshdpmOMGzr6IlQcKL48BsTo7d21lPbYi6ESTAuEIg4PYzcyyGvkTW7JOmgWLw7YO/CHqfsu3QXmo6tTxE/USJRvdYuR0bfHo1Nw32PiQWL9nG/Bdr/8XA2j/Ju33c2lgo3ms9NP3OC1pQ+WlhvIsXyxzTgFl49cDNKNEUdyxgxUDvXzwGzJ7AKTWKoQYwJpFv+n3usWJ8K9prxf3mYGolyfjBNiqU+QIdg4MdOjfdLZRsxNmmcn37ywgbmX/CYuTqEkLo6baysXmBFZ418zQkM04UN1vbeC67cznYt3qgAyQZ4kOwcdUjb8VW6rHnr1eKgAVk/PS7FkPpclTIyvLy/a0eIpdWFBb473yFpAU9ffd7xx0NgiwmZWsY1HhiGz1JxOgL+CsqPBIULyQEqYNQyw9OeASulPaTFIpsZURClAi6+rXNztE8Q3yWZqsrno5qMYYWKVq4Yc
 x0ospFx0
 iH20XwlwV3rRKazKvDE6P1g+QZK0ZUq46qbqKohQb24EIEiBbUQZP97FOT31LL8SnhABKjsOb7/2PK4WSUkd0aOv91PiQabcFPpnS8nzxZ1pDsGdQkznnKe7SnJZhD656kwkHbZmJYfEVqWfSvwlglWgE0EnzeUDbFym21VS8GERplVeMTbdCT9gQ0UkQm0t1o89krxyZWDbWEjRkmiWdpjYDW21dCSv2OX0CyUDsiyD5Pn+L3hVxhFlOVeSc1wx6lxyudzeZb685WQPGiZqaSFRsqtnnefRz7g5C95KXrIz+mgekYftDvs5Riu5iwD1NM0CpCxpL/uQXD9hQ5ExtpLS+PT0B/uAHT+g154AvOuTf9H6eE42wJJ0X1eclm1qYJoGK8wMgcJpHLLuemkvzP4koeb9771juNX/De6SiyXcTPnxundrJYVM8bD7DsfbIAs4s3DSaz/D9l8gwm9/NIwx/pZVtzemqQl6/Au9OOqi+vu+nhqRCcd4Qng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

Thank you for the thorough and thoughtful review.  Your feedback on the
x86 AF behavior was an important correction -- I'll address that and
your other questions below.

On Thu, 18 Jun 2026 SeongJae Park <sj@kernel.org> wrote:

> This makes sense to me.  I also agree this could caused the reported
> problem.  And this is a known limitation of DAMON.  My suggestion for
> straightforward workaround of this problem is, using 'age' information
> of DAMON for better identification of the hot memory.

Thank you for pointing out idle time percentiles [1].  We agree that 'age'
helps differentiate frequently-accessed from occasionally-accessed regions,
and it is a good workaround for many cases.

However, age operates at region granularity, which is still at or above
PMD level for THP-mapped memory.  When only a few 4KB subpages within a
2MB THP are hot, age tells us the region has been accessed recently, but
not which subpages are hot.  The split decision needs sub-PMD information,
which is what the SPE heatmap provides.

That said, combining age with split could be valuable: split only regions
that have been consistently hot (high age) AND have sparse sub-page access
patterns.  We will explore this.

> > On ARM64, this is compounded by the hardware AF mechanism -- the AF
> > is only set on a TLB miss.
>
> This makes sense to me.  However, I don't get how this is contributing
> to the problem.  Could you please elaborate?

The AF-on-TLB-miss behavior creates a second-order problem that directly
exacerbates the overestimation. 

When DAMON's mkold path clears the PMD AF, it deliberately skips the TLB 
flush to minimize overhead. If the dense working set fits entirely within 
the L2 TLB (e.g., 16MB workload using 8 PMD entries on Kunpeng 920's 2048-entry 
L2 TLB), subsequent hardware accesses hit the valid, stale TLB entries 
directly. The hardware MMU never generates a page table walk, so the 
in-memory PMD AF stays 0. 

Consequently, DAMON sees `nr_accesses = 0` and assumes the region is completely 
cold, making it impossible to naturally track the sub-page usage shifts. When 
sporadic/noise accesses later hit other parts of this "seemingly cold" PMD 
and trigger an isolated TLB refilling, DAMON abruptly sees the whole 2MB 
as hot. This binary oscillation (completely blind vs. fully hot) is what 
drives the massive overestimation under THP.

We confirmed this TLB-reach aspect empirically via our T1 test:
  16MB THP (8 PMDs, 0.4% of L2 TLB reach) -> DAMON tracks 0 accesses (blind)
  16GB THP (8192 PMDs, 400% of L2 TLB reach) -> DAMON tracks normally due to natural eviction

> > x86 is not subject to this specific blindness under similar
> > conditions.
>
> To my understanding on x86, same issue exists.  If TLB hits, Aceessed
> bit is not set, and DAMON shows it as unaccessed.  Am I missing
> something?

You are entirely right, and I was wrong on this point. I re-checked the 
kernel source and verified that x86's ptep_test_and_clear_young() does NOT 
flush the TLB. Even ptep_clear_flush_young() on x86 deliberately skips the 
flush as a performance optimization (arch/x86/mm/pgtable.c:486-502). The 
same optimization architectural behavior exists on PowerPC and RISC-V.

Therefore, both architectures are theoretically vulnerable to this stale-TLB 
blind spot under identical tightly-fit workloads. Our initial assumption 
was biased because T1 was only conducted on ARM64. We will reproduce the 
T1 setup on x86 to verify the exact behavior, and I will correct this 
claim in the v2 cover letter. Thank you for catching this mistake.

> Nice!  Asier was planning to do similar work in future.  I think you
> could collaborate to reduce unnecessary duplicates!

Great to hear! We would be happy to collaborate with Asier. I'll reach
out to him to coordinate our efforts.

> I'd suggest making the name simpler and consistent to DAMOS_COLLAPSE,
> though.  Say, DAMOS_SPLIT ?

Agreed. DAMOS_SPLIT is cleaner and fits the existing naming convention 
perfectly. Will rename in v2.

> So you implemented a debugfs interface?  That must be a nice approach
> for PoC.  But it may be difficult to be upstreamed as is.
>
> You could build a control plane that decides the exact address ranges
> to split, and directly feed it to DAMOS using DAMOS address filter.

The native perf event approach [3] aligns perfectly with our long-term 
Phase 2c plan, and we are highly interested in collaborating on it to 
eliminate the userspace daemon and debugfs bridge entirely.

However, since native kernel-side SPE handling is a long-term item, we 
will follow your pragmatic alternative suggestion for v2: use DAMOS address 
filters or user_input quota goals [2] to feed the split decisions from 
userspace cleanly. This allows us to upstream the core infrastructure 
(mTHP target_order for collapse and the new DAMOS_SPLIT action) first.

> Do you really need to khugepaged together, when you already have
> DAMOS_COLLAPSE, and anyway you are running DAMON for hugepage splits?

Excellent point. Running both concurrently on the same VMA introduces 
redundancy and heavy ping-pong effects. 

Option (b) is definitely cleaner: we will let DAMON handle both split and 
re-collapse decisions using its own access data. To make this robust in 
production environments where khugepaged is globally enabled, we will 
explore having the DAMOS_SPLIT path temporarily mark the target ranges 
(e.g., via a pseudo-VM_NOHUGEPAGE backing off mechanism) to prevent 
khugepaged from immediately undoing DAMON's work.

> > - The rbtree entry TTL (30s) and signal threshold (1/10 of peak) are
> >   empirical defaults subject to further tuning.
>
> I don't fully understand this part.  Could you please elaborate?

Since ARM SPE samples hardware accesses instruction-by-instruction, the raw 
data is highly statistical and noisy. 

The TTL (30s) defines the lifecycle of our per-folio rbtree tracking entries. 
Entries not updated within 30 seconds are pruned to prevent stale tracking data 
from corrupting split decisions after a workload phase change. 30s is selected 
to comfortably outlive DAMON's aggregation intervals while keeping the rbtree 
memory footprint tightly bounded.

The signal threshold (1/10 of peak) filters out the statistical sampling noise. 
Instead of treating any subpage with access > 0 as hot, the algorithm finds the 
peak access count inside the 2MB region and only marks sub-chunks with >= 1/10 
of that peak as genuinely hot. On Kunpeng 920, this specific threshold successfully 
reduced false-hot subpage classifications from ~50% to <5%. We plan to make 
these parameters sysfs-configurable.

> > - The ARM64 DAMON blind spot (WSS < L2 TLB reach) is a pre-existing
> >   hardware-MMU characteristic, not introduced by this series.  Setting
> >   nr_accesses/min=0 serves as an effective workaround for the split path.
>
> I don't fully understand this, too.  Could you please elaborate and
> enlighten me?

The blind spot creates an operational deadlock for the split infrastructure:
  1. WSS < TLB reach -> All THP entries stay cached in TLB.
  2. DAMON's page-table scan yields `nr_accesses = 0` globally.
  3. A scheme requiring `nr_accesses.min = 1` never fires -> DAMOS_SPLIT is never invoked.
  4. THPs remain unsplit -> WSS remains within TLB reach -> Loop returns to step 1.

Setting `nr_accesses.min = 0` and `max = 0` breaks this deadlock. It forces 
DAMON to evaluate these seemingly "dead/cold" regions. Once the split handler 
invokes, it checks the ARM SPE telemetry (which captures data directly from the 
instruction pipeline, completely bypassing the MMU page-table AF limitation). 
If SPE reveals a sparse access heatmap, the split is executed. Once shattered into 
mTHP/base pages, the TLB reach drops, natural TLB misses resume, and DAMON's 
standard page-table tracking fully recovers.


Thanks again for your guidance. The action items for v2 are locked in:
  1. Rename DAMOS_MTHP_SPLIT -> DAMOS_SPLIT.
  2. Drop debugfs in favor of DAMOS address filters / control plane.
  3. Correct x86 AF behavior statements in the cover letter.
  4. Coordinate with Asier on split/collapse unification.
  5. Implement back-off to prevent khugepaged ping-pong under Option (b).

Best regards,
Wang Lian

