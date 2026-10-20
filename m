Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1740E606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 06:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=EgkdXkAR
Received: by kanga.kvack.org (Postfix)
	id 167706B0410; Tue, 20 Oct 2026 02:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140C06B0414; Tue, 20 Oct 2026 02:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0565F6B0416; Tue, 20 Oct 2026 02:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D09A26B0410
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:48:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BD1340847
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:48:18 +0000 (UTC)
X-FDA: 85342075476.08.C7EB466
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 85E3CC0002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:48:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EgkdXkAR;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792478896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3Gw4C6d+cgZHvQCxnDAyJZCCrWKpRWiNstAmvZcl4I=;
	b=mUQOeJ10MDXnB3U8MnbSeaCLoawUlxMJPw0OOg2a8cF9st4Ls6EqORUv1ksek1SZueGkXr
	ceZirFJNeDsy0ZKqXsk6tRCetsgxtANpzGBGtL/AHf7mMFsMqF+zr7VF7g7DsXSNdFR+zz
	vMWG7KDUZAqSp8bzA8cYpsEBpOtCYFs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EgkdXkAR;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792478896;
	b=SM7WLxd0es9t/7q/DQWl5NoVH8av+6fqw1Z0SXr3Ne5OlrQK/Tq3ZJF+kk0bZXGZMU5EgB
	7Zb64R3YfzECyXCKIRMa7RsJJdxItJCyyCnpBGQvp3GpKqhaSvfV8Q66qtPUKOZgZug6Yc
	fXYUBWd1Vi0fphxTnEIzKrLfAsXnSbw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23D261595;
	Mon, 19 Oct 2026 23:48:12 -0700 (PDT)
Received: from [10.164.19.55] (unknown [10.164.19.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 91B2D3F7D8;
	Mon, 19 Oct 2026 23:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792478895; bh=aYYGnkNV3bcqHzLEEf22D04oPGihf8ZUUTG5EXgXVKY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EgkdXkARiPYv2Q1yTzLgHYb6CbRVmx9K8avmQlFKvUvokkbsFc+/5/4FCpnGY0vA7
	 H6em7VkIAk6kFq0ir70z8Na1VW55BCsAD/DuSNjvrPT0HtlIFr1lL5N2G7NIcH4jVr
	 v+cHL5eJ+a5qTryJXovQTH0dZrf6pgY23+nqtzn8=
Message-ID: <0aae72c3-7f46-4236-8cbb-d3e6f3c66e62@arm.com>
Date: Tue, 20 Oct 2026 12:18:06 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/4] mm: compaction: target mTHP order for
 proactive compaction
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, david@kernel.org,
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, ljs@kernel.org, liam@infradead.org,
 rppt@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 kasong@tencent.com, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, zhaonanzhe@xiaomi.com,
 lipengfei28@xiaomi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Bo Zhang <zhangbo56@xiaomi.com>
References: <8e54025a-03da-4cba-bae8-1604463c7622@arm.com>
 <20261019150315.2018934-1-zhangbo56@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261019150315.2018934-1-zhangbo56@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 85E3CC0002
X-Stat-Signature: yj7m8hi5fbzmyw4xu1khxwhp8qr5fd47
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792478896-806663
X-HE-Meta: U2FsdGVkX19ydcJ1SzigwS8tN3SqrnvDN2RqWE6BLumbLbCRlacDGcM0N45yNfUNrgEbXdxJabbIRfIvu1fIHGvsE/vG8OoG9MRDrNBwianssVg/qVr/aGps2WXvJTCj2b/OaQAsuuf1NVGpQ5+FkzbQuO0sHF2Zzufjs8PjK1v1IgiMaOWN4Q+uCF/CzPBz/xazmER/OmgWyHbkRG2HlFnO10BPZg52RSXfRZQo/IDy1agL5SalYBvSsxxISe1dzYb1r3/wDVexS4ga+FQ9D1W+XzpfbnaBkCNJXIt1P3d4I9H1NB5CCAPtHp6k5rRCvgeMBR94Z5Q8E3BaCVeYpBZp+tbJuaJzGjhqoB4Jpk/BXMBJ8bmZbhC4Ipc8B63ohO2YhmSi7hBbguiNFowJ+vHpEklz9ZlFExKJ4/6AHUwmGBCJKKOVp6nI/fKtKdh16zpvwnihaw/vqOXwx8R9AgqkdXXusGXe3Z3OY9CJA2yyK6OjwtdOasQKwYh59Hmsr4JpcLWedciou7zZsYcNCo7BC+oTeT+tKDke8exAaYQceLRRamyX6nNDaQaagDIp05AODTwF1Mm/otX92unbO57nTlkpknZZENZDk3KXBYVxBrSSV8TgrzMc+Euo8xa8xQQBqOCXbfW5HZFXFmbo5wWptvoeHNqf0cuDi2S0p7Zw1BeCHaI8ldC4jL5Fz/06b5ESfshPR4ts1iZCgi1KsDRzmO1jkXRWhBA2yTy2NmehWy3N/mXpcIjW+qdztAy5EkHlc4dTPtOkRYyTRIPxmksPPzZQVIdm7F2mCvcR6PrlRX/q30k8a/D1oOQd4l1secIHSN3uN1FcCivRARf7TH/EnQsGIoKbQenctSizq1/0lbk/TOPkeb1QDyzPvwx98B1ASSuu6fVtmj5UUHtgiw92+fwR6ClMj3BlbfwyhlbTqnliqAFgbkhVINgtfpNLWwwK1rAMQ8/Y8Uljbt0
 2J3WdgjS
 dNoLJpMKY5OhDu43Um/WK7b8H/1hke1TfXkKCdgf6ylyDVYQ2wjX0QxPRIw3JcG5wFLpnokP+skONkznlhn6rja3BdBXljRp2PJi8/PLUxBopkSQXZ6zrhFNSsFhAQBcED2V/BWpRTdEp3wDHulhHum2qn54Chav/hxn+RrymgGsGLB+hk4i2UNs1EI9c2fKFzL1i0QOhE3NY+3/i+OWXG3Yfh82+/mitFb6HRp6y4NfMAwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 19/10/26 8:33 pm, Bo Zhang wrote:
> On 19/10/26 1:42 pm, Dev Jain wrote:
>> I wonder if this function should be left alone?
>>
>> compaction_proactiveness, as I understand is given as a sysfs knob to
>> ensure that the user can control how much power they want to invest into
>> compacting. So suppose the value is 20, and the highest mTHP order is
>> only 2. This gives wmark = 90 * 2 / 9 = 20. So, even if 80% of the memory
>> can serve order-2 allocations, we will still perform compaction for
>> order-2. This seems "extremely proactive" :)
> 
> Thanks a lot for looking at this closely, and you are right that the
> scaling factor is the weakest part of this patch. I called it out as an
> open question in the cover letter and I don't have a solid theoretical
> basis for the linear order/COMPACTION_HPAGE_ORDER form.
> 
> What pushed me towards scaling the watermark at all was the opposite
> problem on the measurement side: without any scaling, the order-9
> threshold is essentially never reached for a small order, so proactive
> compaction effectively never runs for order-2.
> 
> I instrumented fragmentation_score_node() for order-2 on an 8G,
> data=journal kernel-build workload and sampled it at ~100ms. On the
> unpatched kernel the order-2 score looks like this:
> 
>   order-2 score (unpatched, same workload):
>     mean      17.3
>     p90       47
>     p99       91
>     max       100
> 
>   fraction of time the score exceeds a given threshold:
>     > 90 (unscaled, the current order-9 wmark):  1.0%
>     > 20 (scaled down to order-2):              27.2%
> 
> So with the current (unscaled) watermark, the order-2 score crosses the
> trigger only 1% of the time, which in practice proactive compaction almost
> never fires for order-2.

I get it, so the workload is rapidly allocating mTHP, and kcompactd does not
kick in time, leading to direct compaction (compact_stall) or fallback.

But I think this is a tradeoff with the current design in Linux and has nothing
to do with our mTHP usecase right? Even with PMD sized THP we may have the same
problem.

I think the uncontroversial bit of your patchset is the fact that currently we
migrate large folios just to free up a 2M region. To make forward progress it
will be great if you can find a workload which gets us an improvement without
the threshold changes and we could get those patches merged first.

I am saying that because the reason you keep crossing the 90% threshold is
due to the nature of the workload and that you set 32k mTHP to always. I doubt
on a real system you will cross the threshold this rapidly since mTHP would be
mostly "madvise" and that mTHP-requiring workload wouldn't be the only workload
running.

Given that, one thing that comes to mind is this algorithm - kcompactd wakes up, sees
that the threshold got crossed again, which means it woke up too late. So
it should manipulate the threshold or its wake up time. We need a signal to
say that the mTHP allocation is too abundant and we need background compaction
more frequently.

This algorithm may be in contradiction with the sysctl ... so instead of changing
the threshold, we could lower the wakeup time.

This is similar to how the pcp list changes its threshold if too much allocation
is happening.
> 
> That said, your example shows the linear scaling clearly overshoots in
> the other direction: a scaled wmark of ~20 can keep compacting while a
> large fraction of memory is already usable, which is not what the
> proactiveness knob is supposed to express. So I agree the current formula
> is not the right answer.
> 
> I'd appreciate your thoughts on the direction here. A couple of options
> I can see:
> 
>   1. Leave fragmentation_score_wmark() alone and instead make the score
>      itself order-aware / normalized, so that a given proactiveness value
>      maps to a comparable amount of work regardless of the target order.
>      This keeps the knob's meaning intact.

The challenge is the normalization algorithm, the problem is that there is
nothing we can deduce apart from the fact that
frag_score (order x) <= frag_score (order y) where x <= y.

> 
>   2. Keep scaling the watermark but with a floor / non-linear mapping so
>      it cannot collapse to a value that triggers when memory is clearly
>      sufficient.
> 
> I haven't settled on either yet and would rather hear which direction you
> think makes more sense before reworking it.
> 
> Also, thanks for the review on patch 4 -- good to know the
> costly/non-costly split seems like a reasonable compromise.
> 
> Thanks,
> Bo


