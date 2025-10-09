Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51203CAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 02:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6770F8E0011; Wed,  8 Oct 2025 22:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6269A8E0002; Wed,  8 Oct 2025 22:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C7F8E0011; Wed,  8 Oct 2025 22:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4334B8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 22:57:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E11755BB03
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:57:13 +0000 (UTC)
X-FDA: 83977064346.06.085EE30
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf12.hostedemail.com (Postfix) with ESMTP id E098D4000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:57:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=seYYx03h;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759978632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnDaONb6FN618EW5I46/MhGF+FSL1m5oZv89+qdE5Bc=;
	b=H7r+atZuKcFzgV7EM1dHUsSqLIrxU5gP5pYUgvV3yBltu55Z4uC6bhZBsJ0fl4Vd6zv4at
	vbbPxNYDbherQqEuQwTAYOKrP5R59BtGw1n7sBU9UWO12HsG4ZlyKaj/6atMS3ZvQEVNI8
	OOHhNzp15sfiv6cBJD3ly7ukS11QV1E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=seYYx03h;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759978632; a=rsa-sha256;
	cv=none;
	b=NWAy/2Ry8D8zIv7SuaJOqbQaoCOsk8OzFk+OJdOd21Cr9+Gl+H4haPA7RwLEbbGPoqrkGq
	i9zfZN8rGmaTKB5nbDjLBUnaMSLKbqpK2nV0JxHses/7ykd847eADZIYSoHzfYvnguBv/U
	LxBuHkqdw0EmnvtLux5t2X6Wu5OpKfc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759978627; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=GnDaONb6FN618EW5I46/MhGF+FSL1m5oZv89+qdE5Bc=;
	b=seYYx03h2ISf1i3m3qf0FkP4VEFCqGqKSamca/M6ChUDu7B8xi0tt20arf8MATOvo+x4hv7lMyy5bn3/Kzjtf/CLVfxENf7igJe0GvcJ2YMEmFo2GtKZl/oUptRxceFU+TWkFx14bYrc4EchxislBiclOdIDd5N7nVnUCGrqKlk=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WphApVS_1759978626 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 10:57:06 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Brendan Jackman <jackmanb@google.com>,
  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,
  Suren Baghdasaryan <surenb@google.com>,  Vlastimil Babka
 <vbabka@suse.cz>,  Zi Yan <ziy@nvidia.com>,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [RFC] [PATCH] mm/page_alloc: pcp->batch tuning
In-Reply-To: <20251008193642.953032-1-joshua.hahnjy@gmail.com> (Joshua Hahn's
	message of "Wed, 8 Oct 2025 12:36:41 -0700")
References: <20251008193642.953032-1-joshua.hahnjy@gmail.com>
Date: Thu, 09 Oct 2025 10:57:05 +0800
Message-ID: <87ms60wzni.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: E098D4000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 57kgdh5e41bam6p9jgke77ub8mpu6kxi
X-HE-Tag: 1759978630-802827
X-HE-Meta: U2FsdGVkX18YbfVidae4of228uZ6xEpISqk8tvmw1EFSwpIRB1eSbu6v8BFrUEIfyJKRIGrl0AmkoTBB4VnOaWOILhK+wptGdGrPugxaxGUu/vhA9yf83sYzFFGG8iXVCjtXY9N29XerELOmYuLpPkMi5TFZvFev5VrCtI0a6HOSCXupOh+NO4JfIqOARQf2kX3Zf7ns6qsY7GkremrpS4hMseNjAONGYGr5VcMF2cWuYHag6dU09mLWFzmcRnhU8LIhoy//9WD2hyuSi0KAg0ih5EuFZKrlB8otLQo44klfwirhzTSL+aZbUPrKBYVN3aXmWgRQFt1dnsgI50cB8GaZnI/ZnrMsn6SIFEpt6CTLugmzrNfS2iRA51bmpkwDz4EZYP5ENWrTT9MjORBnIcabnz8SVC8TAcb+RqqHQVjRMKPGzHTHWeJGpsx+k4Kb65grZmtC9qdEr9P0I/vKrdxVYUdf3JSVyaLEi2ZMyTL5Fh8P670+78EypkcxZFx9Wtwu/bZBH9ezCBNROcqGvwvbHSeuEX/E93Gmo6a5NgAOmQ8ICVbVpByrR9VpefPZlXa1V6perTqx6zp2TcYX6lt+kUAucop825HzMH301iWIOU37G34NjesfuqfRoof1pij4U3qkWrO48Ht4YAR0G/gxJzvM+7hN/XSy6Oo5uytvmSTjtQyY9zFDe/Vaxn5mODt4SNhwc3DXeKyV7dQPm7JwBt1UtkZoZUAJx3sVVuU5CI4srgVXvdvwKXXN7D0Js4ch9xtNnPpfxCYUQhNADWgj+0Nv7A5O6iIR2vuNSnEOSCwMrDWAtHYmyMhScIwv7f4Gc1Is62ZSJDDddbOZJA+ZHrinCm4MI5HzHmaMiJf6qscgKtFf0Na+ac/kv1XDPvY3xO7qom+HalNVsfpIHLr3L1ojDuXf8mpMr55uV12nSD9yuellqBkpV7cpZMoUrXasuwMKwZcMMUib2MB
 PYXHLaqJ
 rfpJsPVoua9Oay7CcSqttMAivbm/JrniBkYVeGIDonojwydI1OFwgQGhT4DjbD9Q8nS8zDgme0vbKuysf4JnSW+0XsehXDvFVfKfowrZlDtikuwX7MPgasWxWoXSKIZHdbAtgqhseS9t+tO/bDPeR05JJHIqpT4Hyoij1S6Ji/admoCzreOdyWKuOA1PrUfVsnclwTRQ0mkI19j+vYRcTvoytsgqMeW9i970WwjF6IzES8fPkPPqCpx7/GV24NMCgzw1yV5qBOdazCLoPxF4XoKwskPDdkC7riBYpAn7k10QOt5DirADFxEI2v/eBQSmLeoovGIZE6hF36xadpxLEMRBD6XTK5KVt4MKliVyZcFSONY6LtM4bBObQU/weUiyt99/WnGN2a4HBF7UF/JqRBcE9DOPbxzJkh06jaJgYCGL/Q9o5ppRgOlD5Nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Joshua,

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Wed, 8 Oct 2025 08:34:21 -0700 Dave Hansen <dave.hansen@intel.com> wrote:
>
> Hello Dave, thank you for your feedback!
>
>> First of all, I do agree that the comment should go away or get fixed up.
>> 
>> But...
>> 
>> On 10/6/25 07:54, Joshua Hahn wrote:
>> > This leaves us with a /= 4 with no corresponding *= 4 anywhere, which
>> > leaves pcp->batch mistuned from the original intent when it was
>> > introduced. This is made worse by the fact that pcp lists are generally
>> > larger today than they were in 2013, meaning batch sizes should have
>> > increased, not decreased.
>> 
>> pcp->batch and pcp->high do very different things. pcp->high is a limit
>> on the amount of memory that can be tied up. pcp->batch balances
>> throughput with latency. I'm not sure I buy the idea that a higher
>> pcp->high means we should necessarily do larger batches.
>
> I agree with your observation that a higher pcp->high doesn't mean we should
> do larger batches. I think what I was trying to get at here was that if
> pcp lists are bigger, some other values might want to scale.
>
> For instance, in nr_pcp_free, pcp->batch is used to determine how many
> pages should be left in the pcplist (and the rest be freed). Should this
> value scale with a bigger pcp? (This is not a rhetorical question, I really
> do want to understand what the implications are here).
>
> Another thing that I would like to note is that pcp->high is actually at
> least in part a function of pcp->batch. In decay_pcp_high, we set
>
> pcp->high = max3(pcp->count - (batch << CONFIG_PCP_BATCH_SCALE_MAX), ...)
>
> So here, it seems like a higher batch value would actually lead to a much
> lower pcp->high instead. This actually seems actively harmful to the system.

Batch here is used to control the latency to free the pages from PCP to
buddy.  Larger batch will lead to larger latency, however it helps to
reduce the size of PCP more quickly when it becomes idle.  So, we need
to balance here.

> So I'll do a take two of this patch and take your advice below and instead
> of getting rid of the /= 4, just fold it in (or add a better explanation)
> as to why we do this. Another candidate place to do this seems to be
> where we do the rounddown_pow_of_two.
>
>> So I dunno... f someone wanted to alter the initial batch size, they'd
>> ideally repeat some of Ying's experiments from: 52166607ecc9 ("mm:
>> restrict the pcp batch scale factor to avoid too long latency").
>
> I ran a few very naive and quick tests on kernel builds, and it seems like
> for larger machines (1TB memory, 316 processors), this leads to a very
> significant speedup in system time during a kernel compilation (~10%).
>
> But for smaller machines (250G memory, 176 processors) and (62G memory and 36
> processors), this leads to quite a regression (~5%).
>
> So maybe the answer is that this should actually be defined by the machine's
> size. In zone_batchsize, we set the value of the batch to: 
>
> min(zone_managed_pages(zone) >> 10, SZ_1M / PAGE_SIZE)
>
> But maybe it makes sense to let this value grow bigger for larger machines? If
> anything, I think that the experiment results above do show that batch size does
> have an impact on the performance, and the effect can either be positive or
> negative based on the machine's size. I can run some more experiments to 
> see if there's an opportunity to better tune pcp->batch.

In fact, we do have some mechanism to scale batch size dynamically
already, via pcp->alloc_factor and pcp->free_count.

You could further tune them.  Per my understanding, it should be a
balance between throughput and latency.

>> Better yet, just absorb the /=4 into the two existing batch assignments.
>> It will probably compile to exactly the same code and have no functional
>> changes and get rid of the comment.
>> 
>> Wouldn't this compile to the same thing?
>> 
>>         batch = zone->managed_pages / 4096;
>>         if (batch * PAGE_SIZE > 128 * 1024)
>>                 batch = (128 * 1024) / PAGE_SIZE;
>
> But for now, this seems good to me. I'll get rid of the confusing comment,
> and try to fold in the batch value and leave a new comment leaving this
> as an explanation. 
>
> Thank you for your thoughtful review, Dave. I hope you have a great day!
> Joshua

---
Best Regards,
Huang, Ying

