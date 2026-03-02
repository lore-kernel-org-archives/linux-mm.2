Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99078EB3632
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D07A6B00DE; Mon,  2 Mar 2026 16:05:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B846B00E8; Mon,  2 Mar 2026 16:05:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFD46B00EA; Mon,  2 Mar 2026 16:05:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4E7D6B00DE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:05:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3C76160309
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:05:30 +0000 (UTC)
X-FDA: 84502354020.02.294A49B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DE2A58000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:05:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PajeYYr1;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772485528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fx8N7Ac8066alznxMrnIzpEDCPJYnU4m3qohgl28gOM=;
	b=0f2fbTZgKxsbw4d3ybOlP2W6hQMI0AM/lQhV14CTqgY+3xoRW6fBqRNnLP4Jv1lP4t0Fr/
	Gwtt7PwDTo74CMuMqF/MEu+Jp06Li+wfU6DY2X7AkcpJHI/81t41rUAyk07b9D2Z/VO9jU
	DoEz6gXJM2tAhSerxSvv5b6bId58oWY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PajeYYr1;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772485528; a=rsa-sha256;
	cv=none;
	b=3HLWhTRJUIkov6/IeslghALraD1wQoMcAuADQ/RHwty9fBaSQm+9ByY+t1W7pbQg9S3Tpy
	05bfB1nfFQmkARwJt99e+MT6OMsZNkZZ9f/SzxPAsbAvbKUGz+tWH+C68MUqCIuWcdwXk9
	wm9HGc4S3YlwdDgPQIo80e9/wEJaDiQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 474E160127;
	Mon,  2 Mar 2026 21:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23C6C19423;
	Mon,  2 Mar 2026 21:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772485528;
	bh=h89XNXaj1TkaWpA1Vicn+nL+zeeXInCV5B7nSxg8NNw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PajeYYr1Kc6aiM3JJvpvK42VUHZXEIeVuvaNajlYIP7yA3W4InmoJw1lH4Kl0Xzx7
	 v/yZb11dt6qpWC21Ili1CQrdgKzEfHoAemRIFvNBU0RqVu8OPJK+EzMcdpPfr0Sa0x
	 mgLYp4fJ7gmqaLRkWlcc0oWjFUlmQWCDp7BvoCvei1sT9E5yfGub9/kR1/Tjt/bB5F
	 CpanlED/nTYvc9gyk+KsaHSigjUy901DgEFY7tBkkGNK8vghLmh08OkWw1/7mA4wzP
	 QQHFJQMkP2XtnBjGWdIxUUyJFZuW7SG6IuRuQ004Fuk5zh4113h6yIUtksCDsluGt7
	 ZYy5W03oGpznQ==
Message-ID: <4a08a249-211b-40b9-b6bd-7c54af2b9d15@kernel.org>
Date: Mon, 2 Mar 2026 22:05:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260225232708.87833-1-ak@linux.intel.com>
 <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org> <aaR4y-lCl7YPEcnX@tassilo>
 <af715d91-6d49-462f-9e9f-3a513ff2ef77@kernel.org> <aaX2B9Efh0dBed6c@tassilo>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaX2B9Efh0dBed6c@tassilo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DE2A58000B
X-Stat-Signature: so6tthikig46g1n7cno5m3k5fzft1h7e
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772485528-272254
X-HE-Meta: U2FsdGVkX1/IvJX3L9xqTTyILLTzigUf3DFIOiI0tA1lFYBki1noKQAp1X20acZbuhzG3tXKTXxEVFmECFj2EgRT4dAKLP5X3y94r8Z7RShVtA4pgP9igogBCrqOaSghgEN4WpcKGXHwVV5K+5J1iyme2UhPX4GKJ+evaWElUrQBi9j7QLzDLwNrwimzj9I08vhVHgu1BoPfrAnUYuVWV6FUKZXARC9RIz8GQOhxi/8PqDT3B6GhZk1L9JLcUuNM0fOTRTC11hGQ6T6YQxsCs/3SgjsndRwQhkrQCbj2hF5HfCgT6aaD0lMmf+nIi4YxAOPEw0H1Eco+8PIo6vkjfedNPEFG92y7l0q7CWKQee1zctaIYexsqaWWk6uobPRIDj0veTCoCIAbgvmKr8cCfIxX0xN5jvStUq3ezV1urukM1oSrrByT1FoRXEofbu8jyPR7TTPrf+c5cmJhBQPrd1mn3Jzy5HBcOi30yHk11U4cdHx+yQKEykLnmZwHHefoUq9WqzJN2iK+3gyIcxe+/Ra+y1mYUw0iK0zZAKZautwLMYpPM1IORs7p3KFqLya2noe64DORWtizZeC49UFNafD3rATVG+vbq5a51V17riDRs1hQ6l0uk0mo5khJzi3HLt9AfDwNRXB+oFnYcklL9oGwDwypG7r6pOR31//oTrBD92DwTHJlW2PKSngEAP/qx3NXZaIzzX1nFY0uF9PgPohwf7PfUkBf1eRd6uUuBYmFqR+PNbSonaI7f937wkBT9GCaiJ0k46R/FOu23rsC7n9EIVcovPUP+rDJTodOBQTnEAYA48mEuWBSg4ZuXcQpbUyFeQSqMaULcOChTuIvoX/LgEN+PQNv7EMhOGaN8ryls8AShwtIszsqGcN3reXyiPm8UtiiXHmBDLiAbKUIEEFiiAiATYWClXr5c2icEsnz3YeZE5hbzcdGWrDTYgJQIxcbTdvMYnD7iibnt5g
 yZ5lq66U
 M452RUxT9Op0SFXAzn7OsqlzJsjXCaZ2NXvdHBkmathbGevOyRmL5hMCUmLOJWwGcpgxgmmhyobw7gJfrlDC6O3WUEnzjWJ7KRKolN76h8EoYg62SdyI+PYqUiHcOlDUTs+uKPnBbM4xF0HWhixCuURv0aOpMpImVzXAEk3SmNNXdENb1qG/KIq2zdMunvsRfylQWOri/yd2pLvJ9FhQV+1Rl1Q4dIi/32RCX3EmxaBjsGcYsDCbpei3iq4Kl5k7xdEGe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 21:41, Andi Kleen wrote:
>> Especially after reading 3340289ddf29ca75c3acfb3a6b72f234b2f74d5c I
>> ended up with he following conclusion:
>>
>> "KernelPageSize" tells you in which granularity we can mmap()/munmap()
>> etc. Simple.
>>
>> "MMUPageSize" tells us how this granularity is implemented (or emulated)
>> under the hood.
>>
>> The case we care about is when MMUPageSize < KernelPageSize. A process
>> might have to know that detail even when nothing is currently/yet
>> faulted in.
>>
>> Assume a process would perform an atomic that would cross MMUPageSize,
>> but not KernelPageSize. Depending on the architecture, atomics would not
>> work as expected in that case.
> 
> I thought most architectures don't support atomics crossing pages
> anyways. x86 supports it, but it's discouraged.

Right. And if your user space thinks it has "64k" pages, when it's
actually emulated through "4k" pages under the hood, that could be a
problem: user space could perform an atomic "within" a 64k page that
actually crosses two 4k pages. So it must be aware that mmap etc operate
in 64k, but the underlying emulation might be smaller.

I suspect (but don't know for sure) that ppc exposed it for such a
reason (maybe not atomic, but something else where user space might be
able to detect the difference).

It's not that common nowadays, but I suspect it might get more common in
the future again.

> 
>>
>> I'd expect other cases where an architecture might have to care about
>> the actual, smallest possible MMUPageSize it might be executed on while
>> running the program.
> 
> That's fine, they can use the min, or just the first match
> (which is always the smallest)
> 
>>
>> It's a shame we had to add MMUPageSize, but maybe it might resurface if
>> we ever support emulating 64K/16K user pagesizes on 4K MMUs.
> 
> Okay, so if I follow that correctly you're suggesting 
> to change KernelPageSize, not MMUPageSize. I can do that change.

Not at all. I'm saying that we leave KernelPageSize and MMUPageSize
alone, just as they are today.

Instead, if we want better statistics (and I think we want) regarding
how things are mapped, we should look into a better interface.

Ideally, that will tell you "how much" of a certain contiguous size is
mapped, if that contiguous size benefits somehow from TLB optimizations,
etc.

Similar to tlbmaps but easier to consume (and obtain, IIRC thpmaps
requires root permissions and has to jump through some racy hoops to
detect folio sizes) and easier to configure and extend.

-- 
Cheers,

David

