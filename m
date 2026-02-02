Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5A5BE73149
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 09:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3A86B0088; Mon,  2 Feb 2026 04:02:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092086B008C; Mon,  2 Feb 2026 04:02:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB5876B0092; Mon,  2 Feb 2026 04:02:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8B7F6B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:02:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81AF05C343
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:02:54 +0000 (UTC)
X-FDA: 84398926668.19.8A35A56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 93714140007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:02:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Btpq+oJB;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770022972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nJrv0ICyunYK0VJ8PahnQemBx3iryf4nnfBDoL2CVE=;
	b=CMWM2p968WYn9SLRTxe9iM/xuX4XJBWPwiTQSuCyzSrGqMUwTjg7jchhyUwS5Cik/o93lX
	ohCNoA1++hxUXICSMDlJtqYjnqL3ITJ8+kQr1IVnRyHjti3xu6wjRMglFp9W4HjYhDuGau
	gjtfyO4a+38oDb7f74Gkvg0H3ykxsy0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Btpq+oJB;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770022972; a=rsa-sha256;
	cv=none;
	b=gyBZK6wLxb/Rfo0fgrSwRIy3VQJa114IV6TyfF4lGdg/AkIFU8dBMEQWckTQihXZNrAuMs
	OH2RXQCLKhBl9oayDQvq7qqnlcvpUGBH2ruEFHeyr0AwGi0yArVWz/tFNWl+E+9+D1JMDu
	deRBJxdvPJk3xAo8rCtXrzgvRy76x2A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80D6340B6B;
	Mon,  2 Feb 2026 09:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515F8C116C6;
	Mon,  2 Feb 2026 09:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770022971;
	bh=6j1ZpGt2g4uuvqHwtQRJNYj0lwJKgK4ExU1TQ3VHi/c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Btpq+oJBkPITKqEYcgC7ez2wQ8Rj7i3zu9kPXVLICcDlub0utCEWZ1+j+DZjVxfAH
	 wYHeg2A3jXM5BDZDhPncK1sVioLddsDgLjcIYHtaed2GYYXObSziMt0VCu4PjdD0Zz
	 HE/uJOuSA6rCA5gwcWVOLMcTa7Yyj55YUjAIAwS8H8oF+aSilz5pc5pkoW4Culq4t7
	 4fyJ5cjvRgt3fajg2o5RfVoikecsumqmyLF1932xJYAqNSx63ig9LtpLoNgNTsBrSo
	 mXeKIoClI88if7cbpoUlZuGfT7BXkOQKYDQ3sRCkk6n7FCIrJeggzvgd5YKUeaAxVi
	 hDg/YKL8opKDw==
Message-ID: <6a351a3a-861a-4b93-8d8a-c0f5b87c258f@kernel.org>
Date: Mon, 2 Feb 2026 10:02:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Introduce IORING_OP_MMAP
To: Jens Axboe <axboe@kernel.dk>, Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org
References: <20260129221138.897715-1-krisman@suse.de>
 <62d5954b-8ad5-4674-986b-c1168771429b@kernel.org>
 <f6098b6a-6283-486b-8167-b77c8d2e7880@kernel.dk>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <f6098b6a-6283-486b-8167-b77c8d2e7880@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 93714140007
X-Stat-Signature: 3zoe4gag3o5pbet7p5tamk7iuxior54e
X-Rspam-User: 
X-HE-Tag: 1770022972-754941
X-HE-Meta: U2FsdGVkX19UOyuH2ppZMfrAvKprig9ckjEgUSvE4CRcg10H3Gg6FLcVGO6wTcQEXugD/t54dnT41311C4Y91saxx1Qw6ToX9Cg8DQl+42mNUcV3peGDeEmxOw3pITg6mPdxC7UjsXObeb3xVesle3SX7DLBTVc7HSE9qWm4VFBfSCnOVcBJQlMIlI3kyVkQkpj/3C0blcCOYBuUrOZldhnxGKXIaPRp6a4EF2yjYTDUVL+LkqFGnzHlTVV39sPvMA6D8LiSUf6TzRazhPnwBbJNVbJHWghmGiP1+4qr8b6oukrgUdfwcaApO3rqgHY7DZx4Il02FklCZWU3AcYuDgSFtLYz2YW9D81n8SSMkBpnlwcDukPMTz06mwENU2pRbi1ZB9kGR1y6kQgdqF8MyBa+TXju29l1k//LkbB5e02xS12J0iQ0qk2KiAl462JaXjdSMzuxwrEWl5wgA/1Mip6WOpNBe0BwTkl0+T/59vAO+xbiMWLiccfz0cMU9+NZuTZwyvkGKwHESCW+bNh2I7YNiBghEgsPIJ4wgLVJYRStiAR7X32nxiqH+Th6xZOfogZ2nNwqvBoYwCrS5jXKZvMWvZxrwzwOjBQL5rpGdnty5r014e8vU6mX7IlXQmGKwxJKNPclLEJ1GbqbTpt0QgR4kDjxHlcyB1tcGtMgy6HbZLSgsZ/wHQhHBjftyrJKHV1x4tnHg+7ouBM6Q+n5f4p+UefTOvVn4ZPHgCDxBQoTX3nRYDhhmXQqf6ZKz6VpFbuiej8kRq8jJLene3XPx4tynITd35PgTgVEMDGk6+VuhYgfa+b8pd6p95FX0IMCoExxV7CtbevUTi4sUL81E91YOoExkWAuuTYcstCdNT4Gu1mFu7Ymwx6l0DKxWsJEQTxIQfNcQ1m46E8C8ZPp16G84OxiVfQI0xzsriel6qVit3W26y76J6waECR/f1iJaf/OeOEzmewlmahhxzK
 zdU+i/Z3
 Qota5iVUo+qTcKEiCh7V8yFX5mpLkKwKZ9kj0DrYeLxrjyn3voTGc37hs7OFy2sqNa4bFGgIb1q9HB4SuqKl0OdtsVgJkZJT+wbgTt1WpdRe6AiXjUbRH2kQBQIAYWSuFjnZZS7u8pWAFmUs0ODwtRgAfcX6CvrJK9MfydDadViJvKn+A2w3laujVw/Pvcu5Ox0wB3K70yMAe9LOt7EtaSJU4/W9KZqBBz5rv6fPLxPQcdw1L3KQz9LN8JdwMndNVpi3ymJT/a5M4ek+5xze75OnCrIx2L7FXZm+/3Q7z/1aSHlRLZSs/ZAMuBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/1/26 19:16, Jens Axboe wrote:
> On 2/1/26 10:46 AM, David Hildenbrand (arm) wrote:
>> On 1/29/26 23:11, Gabriel Krisman Bertazi wrote:
>>> Hi,
>>>
>>> There's been a few requests over time for supporting mmap(2) over
>>> io_uring. The reasoning are twofold: 1) serving as base for batching
>>> multiple mappings in a single operation 2) supporting mmap of fixed
>>> files.
>>>
>>> Since mmap can operate on either anonymous memory and file descriptors,
>>> patch 1 adds support for optional fds in io_uring commands.  Patch 2
>>> implements the mmap operation itself.
>>>
>>> Note this patchset doesn't do any kind of smarter batching in MM.  While
>>> we can potentially do some interesting optimizations already, like
>>> holding the MM write lock instead of reacquiring it for each mapping, I
>>> wanted to focus on the API discussion first.  This is left as future
>>> work.
>>>
>>> liburing support, including testcases, will be sent shortly to the list,
>>> but can also be found at:
>>
>> Just a general question: why do we unlock each syscall individually,
>> and not in some intelligent way, all syscalls at once? :)
> 
> The hard part isn't enabling all syscalls at once, that could be
> trivially done with an IORING_OP_SYSCALL and the SQE carries arg0..argN.
> And for any nonblocking/simple syscall, that would Just Work. 

Right, that's what I had in mind.

> The
> challenge is for syscalls that block - the whole point of io_uring is
> that you should be able to do nonblock issues with sane retries. The
> futex series I did some time back is a good example of that - you modify
> the existing syscall to expose the waitqueue mechanism, which you can
> then use to wait in an async way, and get a callback when some action
> needs to be taken.
> 
> If you just allow blocking, then you're blocking the entire io_uring
> issue pipeline. Which was exactly my main complaint on this patchset,
> see the review reply to patch 2.

Makes sense. I was wondering whether that could be optimized internally 
in the stream of IORING_OP_SYSCALL.

But likely that would make it more tricky to optimize.

The patch set says "serving as base for batching
multiple mappings in a single operation", and I was wondering, why one 
wouldn't just also batch with mremap/munmap/ etc. in the future.

(BUT I am also skeptical whether holding the mmap lock in write mode 
longer instead of repeatedly grabbing it, allowing other operations that 
need it in read mode etc to make progress, is actually preferrable)

> 
>> I assume supporting arbitrary syscalls could be rather hard (or am I
>> wrong? :) ).
> 
> See above - it's both trivially easy if you ignore the problems, or
> somewhat harder as you'd need to refactor the underlying bits of that
> particular syscall first. For some of them, that's hard. Traditionally
> syscalls have been fully sync, they will just block and prevent the task
> from returning back to userspace until they are done. syscalls with
> io_uring is more involved as we simply cannot allow that kind of
> blocking.

Thanks for pointing that out.

-- 
Cheers

David

