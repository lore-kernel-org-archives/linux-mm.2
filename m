Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3E74C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F60C6B008A; Thu, 17 Sep 2026 21:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7756B008C; Thu, 17 Sep 2026 21:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BEAD6B0092; Thu, 17 Sep 2026 21:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 258DA6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:26:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A481C1A0524
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:26:49 +0000 (UTC)
X-FDA: 85225143738.13.E9B4C2A
Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	by imf10.hostedemail.com (Postfix) with ESMTP id 72384C0008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:26:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SRrNqewI;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789694808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZgw48nQ6RrfHyMPZawE1rRcXu2urLNDx1tTguGkCs4=;
	b=lVlvmCgN4c3IZV3iNfu3/1/X0s4V315vZ2Mg1vhcakhgXhUPYHQESOmRbJ7A328Sns5pOP
	XLI/vrpWEB9veEdk8Bwp1WGn7jOyMTn15uWCwIeciONWKYmP65a7x2DAG00fLKcjZjYlKK
	gDheJ8COXjFHdzWO6VjAWxbtWkiEIkA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SRrNqewI;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789694808;
	b=zjXC9hDYutX//NchuW73d3nm0T+D1dIuvDEoOkDwQDeCkxAfg+s8998lcad3JnP7QLLEAE
	qHg5kiu4doL0XXmJrb7qz7ne6m4HpIMVSRAYkteyaE72Fj/YmOHe9SHw3oBv997OEMed9J
	b12yNU+MQql5hFU61NUxlI96FW8eqEw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oAXUSIcwbHVGGoUnEEnCx3HqkvSgoi10RnBttKf8Nkg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789694805; v=1; x=1790299605;
 b=SRrNqewI8RhBjZBR4vaR8VRxBo9X/LEEgzboE/AAj3BCNArHUKFRcZ1yF0Swv9wfVu45uBIv
 4243GhDL3+2dAmNJ8iSxLB3WMc8XNJgo08zoO3I0lkfgbs1tNulXC55xm2wjsipoaNDHs8QCFda
 bel5//SMyN1dYIDMWdTWPISg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1a7595a3d0729dc5;
	Fri, 18 Sep 2026 01:26:45 +0000
X-Mizu-Trace-ID: 1a7595a3d0729dc5
X-Migadu-Flow: FLOW_OUT
Date: Thu, 17 Sep 2026 18:26:44 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, xlpang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, chris@chrisdown.name, kasong@tencent.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: memcg: don't hand out large folios above
 memory.high
Message-ID: <aqx5kcqRrbkuay4i@linux.dev>
References: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>
 <20260915042546.279410-2-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915042546.279410-2-qinyuntan@linux.alibaba.com>
X-Rspam-User: 
X-Stat-Signature: yxhrekuzthbogbg4e67ooaga8wbyhkb4
X-Rspamd-Queue-Id: 72384C0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789694807-957433
X-HE-Meta: U2FsdGVkX19BcYphrHg+Mra3n2rLDXP8+YZU71umLdst0kZCm1vxw4IYm2yTobvIMKpWQ1FdI1KO99BuNEnIvGsdwK6VlEoODy/RvrnkgQOcmhAsYfIkODZG1E9FJoCcR06iqEmZev18Bu8xZ+2sfZF9C/JhrhYPtaYAmkOjbQfRgh7nIZgcQDvuLpn5GocmYt/MiqosEaGlRV3BDZfXyWX4Ey4umU+FELeC994Q13ErB8OVd9NKB9hQp6UJ24pzoyTemCbRL844S0pvFbU1fpMzfwPwRgArNFSxWRiqWkmYoZhkYULbtCqdHj5qJHlPUyUFnNYA/9ClY6hKb+wPW1HJLVQbxBHgp7pib+4A0vRGjB6IMOgzawG7C01wD9Tz3imCNPm0SPJ2x0SxeQayBVPGl3CKP/V5F0cFv1O9ctE43GXq5x1SVjrAOFAMr8Vpv/qJ7FoaYeAuQR4dEfHDU3GWTjhca0WhCZ9/+CJ/9+gW/Ql8PkEjhJD+TCUhPylijMO4YGnvfDv5VaU2wHVfpWM9qaiM5qDm1le3CHuDTuHbTtz2K5vrumzN7TTyCdDxSO2LV8JnLGCcTOXuL3xms3dtaQezX+5iCEEkEpLQG3OHd9XRtxQ/C/uo26a/oCtqMka15ZZNZLFRni4OuB0bIDyKtNEnce2GTDFsHN682Tqu20LnJSjgvEn6DCx73qlppMakBkJ6R/m+nsu6Ik/2o75ASCxbE3X8t5mrWW3iX/JlsvkKl4vhyEkclhzenb8+1oxM5asVyMb7UGDumb5kaxzeHT9L9f/fZ31+fTh0KHuq/sZmJr1ebUKJAlHVpJIZ6HfKehhMRmeqO7fFjRfETPaM1anhQPlwmyrXkRwvwdBx1e/389bibK2Nod/PwBbX3QOvEjmWP5MVM7abapPHjYLZ5s66Zykb/083UVsKmo0rmVtnWIqJ2zFgUImNna7YcKforHce8LHPBe5taEn
 LBViighr
 QhL3OVQhn0l+YgG1gpr06mupGJ/Kc0CcJgnStuhIB4kfCCxQFfWD2jeX43ZiQMoHQxL7mY4wYK1dx7tuXouljXWzFIQABUizCsl+Oaum66SfE7CrYg7+VBukyTKYz1wRgwrNsUwO2MxvNZU8tp059fEgTHAsroEIK32tZDkoQOnOJEZ/KMMqbP5MVhLaK8uDW3uUDJmpk2NLWc3/+TnI1nzedGuzDvv2i51wNL9ucbNtAJzcOruAtzbfwSMg2FbGUzxml/ma3wBcPOFDy4qscIe8SKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 12:25:46PM +0800, Qinyun Tan wrote:
> memory.high is enforced on return to userspace, and synchronously in

Over time I feel like this sync throttle for memory.high was a bad decision but
that is an orthogonal discussion.

> try_charge_memcg() for large overcharges, but only when the charge gfp
> allows blocking.  A populate loop - mlock(), MADV_POPULATE_*, any
> GUP-driven population - never returns to userspace, and large folios are
> charged with the THP allocation gfp, which does not allow blocking under
> the default defrag=madvise without MADV_HUGEPAGE, nor under defrag=defer.
> So neither runs: usage grows from memory.high straight up to memory.max
> with no reclaim and no penalty sleep.
> 
> mlock(200M) in a cgroup with memory.high=30M and memory.max=140M.  Of the
> 110M between high and max, the burst consumed:
> 
>   4K pages                       3M in 5s, then still throttled
>   THP, defrag=always             6M in 5s, then still throttled
>   THP, defrag=madvise          110M in 13ms, then OOM killed at 16ms
>   THP, defrag=madvise, patched   3M in 5s, then still throttled

I don't really like polluting non-memcg MM code with memcg internal details.
Let's first discuss the semantics we want here. Please tell why getting
oom-killed by kernel in the scenario you have described (mlock() larger than
memory.max) is wrong. How does throttling it will help? What can the external
observer (userspace oom-killer) do other than killing it? Or you are thinking
that the workload itself is observing itself and change the behavior (though
the big mlock one can't do anything).

What I am looking for is the real use-case you have for this case. Not
mlock()ing big chunk or creating a lot of unreclaimable memory and going over
memory.high. For example the reason I added the sync throttle in memory.high was
to implement a feature Google has in their internal kernel where a workload hits
its memory.max limit, kernel delays the kill for couple of seconds and during
that time, the node controller may decide to increase the limit based on the
memory situation of the memory. However even with sync throttle, we couldn't
reliably implement the alternative because applications there have thousands of
threads and there is threading library which keeps cloning more threads if it
observes threads getting throttled.

So, let's talk about some real use-case and then we can decide if throttling
makes sense here. If we decide to allow throttling in such cases, I would rather
do it in memcg code i.e. somehow inform memcg code that this is THP allocation
and can be throttled.

