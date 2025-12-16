Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3072FD5C0C4
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 02:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942AF6B0005; Mon, 15 Dec 2025 21:44:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919B36B0089; Mon, 15 Dec 2025 21:44:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843556B008A; Mon, 15 Dec 2025 21:44:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 747EE6B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:44:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DF14B96F7
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:44:18 +0000 (UTC)
X-FDA: 84223790196.05.4EDADEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4B37A16000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:44:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uVTOulPI;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765853056; a=rsa-sha256;
	cv=none;
	b=TdJ0FwjCHmdgb2LcUnbt6b0/B9gxw//fkhVk+6eCJuGi09ZdmlKHnwbTaomPdFlO7CP4rR
	YY52eEwHURmM6f7Dw72+Xtz3RC3ETMmDPLNobMqXI0y4xbT+kd5kushqFsUTX+wFV2yFSr
	sX1cE1aux78kXR7y3Qa5QR1Exs7yqiw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uVTOulPI;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765853056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyh/yS3E9fP9fPHAv4dRKoDEZ5M2T/4sZgKddtuUXdY=;
	b=Y7oMRoRemy/62OJs95dAZAYGS4j3Iaxw5MsQiFYWq7BXojNrDK+lIX+dlUSjNWi5KJL2Le
	xfMU8rHB4YR+VFlYaQj4vahTZXBSWsIXubYYOQP5HNKr3q2FKnIf763WqB2WHYEsyMcfSr
	YXUIqyWpmeyjZ2/kLpPiEw4K3mpGM9M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7079C6011E;
	Tue, 16 Dec 2025 02:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A89C4CEF5;
	Tue, 16 Dec 2025 02:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765853055;
	bh=ASJNWfPG6p1NVFxDWaiLv8wu9ngB2Uk8IA5ptI/+6io=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uVTOulPIBAvE+m56YDfl18Mzw+PX5n7rt+OS8jl5WRyW32wjhR6NC3WnFqHj2Nbhp
	 0AnjffA0z4ksYxiI3xn91E8VipJ8KFb3pUGeutbAfwBDA5FGCFlJeKNGq3201/RYoh
	 tzavQfgMlGXW7r18pkqtiRwZ0+wvLJx8t4X5F/Kg=
Date: Mon, 15 Dec 2025 18:44:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 david@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
 konrad.wilk@oracle.com
Subject: Re: [PATCH v10 7/8] mm, folio_zero_user: support clearing page
 ranges
Message-Id: <20251215184413.19589400a74c2aadb42a2eca@linux-foundation.org>
In-Reply-To: <20251215204922.475324-8-ankur.a.arora@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
	<20251215204922.475324-8-ankur.a.arora@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B37A16000A
X-Rspamd-Server: rspam04
X-Stat-Signature: 3jqqj64xq9kj3pocto19cjr6izowso3k
X-HE-Tag: 1765853056-398130
X-HE-Meta: U2FsdGVkX18aoL+vYKYuS7OMDghyReqsbJuZXz4jXpY2apKK3ZxwFHp0a0zTJtk3NZafi/xXH7zHqtLRuiBXVHgqtfvxO+nVZW0vlsQLGv/8rB0XJNVujZaCHts7rLXqjgN1Z0S2J4AhHokh8XRIe2gxpFm5laWbk1eETtglFyFb/+OdoE4v4/0csPrelWwEGSa8Qb2dh6QjoQzgmzeEQe22nRaSVcxGWLr6cC+kbR8gRa8R2NgYPdNkqmGYC8oip1iBY1iOPCxvwN263x+elHAULyFAgi8N7523uSoz931eLJLXemYi9EWI+d8jT1SoR9V0Wd3CXWz6/AVa38/jeCAtzz+xoqYYUl12VqYEoZ2nep7fduvEEHpzjm0drVHdF11LePhMl/viJ5n8TZEmQdCf/2jkLVOzLYEYRXHUMzoqZaG9/njjYqxyXwRKZ/rUzXWr/TSei+uvAMqd4J3gVjDGY+qw7Pedg7clg/oX8hMobbnXF1CU228wjO12XmjxUq4s+FcRjXjGo7GIqAQ+gIjGPHYMk0sbt/oLJ4LNZO7461w3rLSs02lSnw8KdNqzZ1IghK229es2qtiPq5+8gKgHEogvR/kMY7eqOOISC/A678Yd/iNckR6ry/1l8Yiy5buvLs0VYPDYc+EwLupFkie9oltKTq0nwYdxsdo4rr3lQKOjRGMTn7XZS1jCLX+8pzuRSee9Y+t/H6yzJV/BoevIS16orXsJ4zRUTecq2UbMu5fqbCcoil64WIK2UJ7buCvxCAKz5S1YD8Er4eWeM0KOktfmNYCkJAOJlE4n2JfMv01Fw/uhafxWCONIHmq6sl3M+m6L+kXPHzcIURPTA/scksTI/aURcKWyPFUOMy+/RQK0lmCH5GpMAvJWEVZceEouPcfnZFWYTjFNFVPwuxuGVIaWsM8S0MgyaYZ/V2bhlLLnlQYgEhulVKmeZY1nf12hc8jssFe/1MWQF5U
 BKp59uD4
 kr5PmuREE5sq/6wJTrMiWKI908JIuA/Fo9NsUEFL9rBhnztGgycurnSXti0r9HEu4jGc67nklcrRlx/zRLuZCBALGiLOpWZNVBQU4SmhScnUjfsHU60gE3Yld/2jrF3/7rgU3TMWvtVY+EYu6czgduW4+BIfY9YFxl0F5RcdiEQDN9Wl5zb0WVZu4fSEIp9vC49fY6Y2LQiflk/TWCYORIJCR1uhlnd9syBpmnz3OQ0b3r6ga4Z906g7aziMVqTC/1AgHU9NdtXz1GxyvIY69j4w+f+v+Z2jGsJntnsULsIRztdpbf2RpS/Zfz9f+R3Gi9NsM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Dec 2025 12:49:21 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:

> Clear contiguous page ranges in folio_zero_user() instead of clearing
> a single page at a time. Exposing larger ranges enables extent based
> processor optimizations.
> 
> However, because the underlying clearing primitives do not, or might
> not be able to check to call cond_resched() to check if preemption
> is required, limit the worst case preemption latency by doing the
> clearing in no more than PROCESS_PAGES_NON_PREEMPT_BATCH units.
> 
> For architectures that define clear_pages(), we assume that the
> clearing is fast and define PROCESS_PAGES_NON_PREEMPT_BATCH as 8MB
> worth of pages. This should be large enough to allow the processor
> to optimize the operation and yet small enough that we see reasonable
> preemption latency for when this optimization is not possible
> (ex. slow microarchitectures, memory bandwidth saturation.)
> 
> Architectures that don't define clear_pages() will continue to use
> the base value (single page). And, preemptible models don't need
> invocations of cond_resched() so don't care about the batch size.
> 
> The resultant performance depends on the kinds of optimizations
> available to the CPU for the region size being cleared. Two classes
> of optimizations:
> 
>   - clearing iteration costs are amortized over a range larger
>     than a single page.
>   - cacheline allocation elision (seen on AMD Zen models).

8MB is a big chunk of memory.

> Testing a demand fault workload shows an improved baseline from the
> first optimization and a larger improvement when the region being
> cleared is large enough for the second optimization.
> 
> AMD Milan (EPYC 7J13, boost=0, region=64GB on the local NUMA node):

So we break out of the copy to run cond_resched() 8192 times?  This sounds
like a minor cost.

>   $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5
> 
>                     page-at-a-time     contiguous clearing      change
> 
>                   (GB/s  +- %stdev)     (GB/s  +- %stdev)
> 
>    pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*
> 
>    pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05%       +  5.2%	preempt=none|voluntary
>    pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21% [#]   +144.3%	preempt=full|lazy

And yet those 8192 cond_resched()'s have a huge impact on the
performance!  I find this result very surprising.  Is it explainable?

>  [#] Notice that we perform much better with preempt=full|lazy. As
>   mentioned above, preemptible models not needing explicit invocations
>   of cond_resched() allow clearing of the full extent (1GB) as a
>   single unit.
>   In comparison the maximum extent used for preempt=none|voluntary is
>   PROCESS_PAGES_NON_PREEMPT_BATCH (8MB).
> 
>   The larger extent allows the processor to elide cacheline
>   allocation (on Milan the threshold is LLC-size=32MB.)

It is this?

> Also as mentioned earlier, the baseline improvement is not specific to
> AMD Zen platforms. Intel Icelakex (pg-sz=2MB|1GB) sees a similar
> improvement as the Milan pg-sz=2MB workload above (~30%).
> 


