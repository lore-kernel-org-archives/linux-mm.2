Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35869C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3425C6B00AA; Thu, 17 Sep 2026 01:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CB506B00AB; Thu, 17 Sep 2026 01:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1950D6B00AC; Thu, 17 Sep 2026 01:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5FFB6B00AA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:35:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6819B1C1B19
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:35:30 +0000 (UTC)
X-FDA: 85222141620.17.D9B0555
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 903C6A0004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:35:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sRFmYT6o;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789623328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LDe9JBY33kVRmTAOxxfbfg2OmHYv79TUa9VIuLFDDA=;
	b=OR4keSY6tpGDAbD34tfpa4C/x9QeOUeU17x6j7/KoXAlpMkYrq4dSi1p0v5wsn3qAKFZB2
	snVSmdIlxrkIZJsQrDp+N7qi5QUn1kl5vplub0QZHYwuVzBtzNDXtl1NBuSJ3Q/hau8UCM
	Au/j0HRI4OC07SoFCXyT3GfWOh+eWpc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789623328;
	b=X+VlUxFjXDoIhCvrpIGb013fW1kX9IgKZBb1ACMkOtaEwuTbEZMiD9DWloE0f+wEUa8cPe
	Th/3/nJHZ8j1m3ZqMpxo5EcZ319BpnAbA2E6RQ5UurZjlPbkLWJyr2JZObiDJKJ4+HTu9i
	2ZAFfJWUq9e6o4J/p7/kuNjOOsJxpE4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sRFmYT6o;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B216A417A8;
	Thu, 17 Sep 2026 05:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBF51F000FF;
	Thu, 17 Sep 2026 05:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789623327;
	bh=5LDe9JBY33kVRmTAOxxfbfg2OmHYv79TUa9VIuLFDDA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sRFmYT6oG5XNkNhzD4PX0oeq57NPguBwfSqG4ah+CHJSstWgg5SOHFilDgkzZK/RO
	 X3w+VcDuaWccad5MKLqlsNrO7mXkMPkKpLYmFafSeU50BpVU/e2z/OmI60wQNuRdBI
	 nboJ6Zxsil7L3eTvARfiCmr38fVTreIOGf7ruykg=
Date: Wed, 16 Sep 2026 22:35:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 jannh@google.com, pfalcato@suse.de, osalvador@suse.de, hannes@cmpxchg.org,
 raghavendra.kt@amd.com
Subject: Re: [PATCH v2 0/4] sched/numa: stop VMA scan filters from gating
 promotion
Message-Id: <20260916223525.65ae1628b1457a716efc298f@linux-foundation.org>
In-Reply-To: <20260911001826.2109390-1-gourry@gourry.net>
References: <20260911001826.2109390-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 903C6A0004
X-Stat-Signature: 75ssukurbsdut8yb78hz5ioyziicqp8i
X-HE-Tag: 1789623328-211668
X-HE-Meta: U2FsdGVkX1/iUmHFT6ZTtKoW6E5/szGDLYYehbB6JU4uBYsAhydCnqHIHivThz2MvDGLjuQUeduEme/64Mxp3+4w/gNX7+6Xr/rYDRDBc5bPXjlAI9ZYrQG7c5rILoeYfDelLtcWbKuWU4PgKdZYQECykrRt2ufGQfvwKebPvrPUUyu8YBpkZ4yd4xImAfD3W+dxEODLJ+gOoSRtqSEJnv9OPqC2VzKCNgcHAtHANuh8k3wBwY1Y6ofW3cR3RtJJD31yWycDVSkVV2FGQ8d4KruxuiS5qvPthnV13MQ6cJG4hL+gEAmO+Ct/2lsFkSzhnRQK8e98F6efPgkjZBncylTP+EydtgybEumLAH6aO/OXl13Gs5jg+k79F5gbcZqF+v/RNBa7Oah2mPqwba3ymu0o5udq/C+cnF4pZFOfgKWXc8wiFIVBwwKgZXq8lI9Fp59i/+l/3HkbryfP0dPSnqsaABiV0l2yL74euVZ30qAHZHPcKbN42pT/5kUgc1eT3TNATtjKHIgLheb0CMERMAq51FqkzkS2dRCjgxXMo9zBZ6253fnZAP53RVBrW3tM0AXlBN2aO0ESSft0GlwkXk4HN4Y/21OaCglV8TuBEBLrv5msJ1vTxfsDd8HtCkzBVwVHLmoa/X5GKzeeafr09POPbQs4fjtcMWcOMJexT4KvHWG+6Eg3jO5+UClShrQt93TBO23/vvlUzXM/W3EV7DEoJFAdoL1KZ9Y1UAgcqv5+EqJw5bhmtT7PZgI6x0YjuZdTNsnlGuuxHEPajgT9ALc9HAQ5w5idFi9nq3yTwVNDsqAfSqN7dszQ4uG4iinf3GFrWkBBdiImkSpMkgLgaw/PsXcWyRi/8Vtdsd90/+y2jtow+ti/l8HcPqE4yx3UGasRJbkHVq4ooWi5WU1V8LC+ULbFFim6FGhYfysPYnuC9VMbRFOc9M5i/80y3m+rzdKsjxEyxLGM4kGcoJ/
 KraHAAKM
 mG3qlmMpVTJ9rlah1LoNmDOF4QOISBeS0xQFenLnwjiupOm5V0BoC9bHs32MTmq46iEVMuWRUaHEy0vhb4WEAlS8ogy4I2bxfawx58wlqMJ0ZmSNDp3awvJYofsXNEWsu9vq9RcNkY6Wq1yw7o+12bFTFc7hX3UYIuA+q/n7lIqQfzSehmpZIonH5dCJ/9UrrubyCQ2nfCH+YQ3UR4JfBcGidCjy3+TyBR+zJlDUHEpp6sY/n6tdM4nvDe23q1WkkmOqVGAlaF2UlUXrBHZVHkt/0dZr/BXoXRod/QDBXjDq4gbT5W3uu8NpnaMttG8aVskONhulmx+yK2vcdQQkcOVEOb1vL0HRGIvCyicjgMHNRYopiBxw14mP0zR6GQsnclOFb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 20:18:22 -0400 Gregory Price <gourry@gourry.net> wrote:

> NUMA balancing uses hinting faults for both task placement and memory-tier
> promotion. Several filters designed to avoid unproductive socket-placement
> faults can also prevent promotion.
> 
> Read-only file mappings and VMAs without recent PID activity may never be
> scanned, while lower MM layers reject some shared folios. Hot memory in
> these mappings can therefore remain on a slow tier indefinitely.
> 
> Separate promotion-only scans from socket-placement scans.
> 
> MM_CP_PROT_NUMA_PROMO_ONLY carries that choice for one protection walk, so
> the PTE and PMD paths can restrict hinting faults to promotion candidates.
> Keeping this transient state in the protection flags avoids per-mm state and
> its associated lifetime, concurrency, and VMA identity problems.
> 
>   - Allow eligible shared folios to be promoted to a fast tier.
>   - Scan read-only file mappings and PID-inactive VMAs for promotion
>     without re-enabling placement sampling.
>   - Track the last placement scan separately so promotion-only scans
>     cannot postpone the existing placement-starvation fallback.
> 
> The series is ordered as follows:
> 
>   1. Add promotion-only NUMA protection walks without changing behavior.
>   2. Permit eligible shared folios to be promoted to a fast tier.
>   3. Scan read-only file mappings using promotion-only scans.
>   4. Scan PID-inactive VMAs for promotion and account for placement scans
>      separately.
> 
> Tested on a host with 768GB/256GB DRAM/CXL.
> Ran 2 ~430GB database workloads with large (>300GB) shmem VMAs.
> 
> Before change:
>   - 150-200GB/s DRAM bandwidth usage
>   - 40-45GB/s CXL bandwidth usage (maxed out)
>   - request latencies over 5ms (longer tails)
> 
> After chage:
>   - 250GB/s+ sustained DRAM bandwidth usage
>   - ~10GB/s sustained CXL bandwidth usage
>   - request latencies 800us-2ms.
> 
> Functional observation:
>   A 20 GB hash table VMA that previously remained entirely on CXL was
>   split evenly between DRAM and CXL after the changes - and tier
>   residency tracked hotness.  This was previously affected by the
>   stavation issue caused by the "unaccessed VMA" filter.

This seems very significant?

Why cc:stable and Fixes:?  Is this something which ran at these sorts
of speeds before the offending commits?


