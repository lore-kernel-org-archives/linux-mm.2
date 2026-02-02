Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5501E7DEEE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 14:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D28F6B00B4; Mon,  2 Feb 2026 09:34:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3808C6B00B5; Mon,  2 Feb 2026 09:34:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2633B6B00B6; Mon,  2 Feb 2026 09:34:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1267E6B00B4
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:34:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C105F1B072C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:34:25 +0000 (UTC)
X-FDA: 84399762090.14.C339A13
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id A484A2000D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:34:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=iMfs4579;
	spf=pass (imf13.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.178 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770042863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rEpZFSBYqwbJS4DeyzeYZz+QE0lrvN7gNdYGjxP8Jmw=;
	b=1vxlCQtzWzlDPLpmPJb7M13d9M+U89z8Ktupg/t4ZTkFXvdWAhs4geCfM6GjzQ4ebALAag
	sOga1lOgmgemAw6LJNSFQpkKdK+wr7dWYQhkBj1ltP6xEt6zhuwpoRKw86Fipwaf2Ve0bj
	VGbbMGAzp0cpofWe2ICsO8ilPVGXjdI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770042863; a=rsa-sha256;
	cv=none;
	b=AxSQ11jAHjVeCw5Kw+ScErkRcTTdeNuPL/MXWcJGle+0+3h5OFk/LeTj69X4viOeKrz3JN
	OaNGrnogAi4cQAjgdxPdYHVAyFGhgcJBTZ6/NqlFeH/T2vDwjshK68e1n7dMyTttpkYZCP
	h7WTetG+CuIxolRpHTaKu0N8wcUUSMQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=iMfs4579;
	spf=pass (imf13.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.178 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-45c92df37fdso2082351b6e.3
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 06:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770042862; x=1770647662; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rEpZFSBYqwbJS4DeyzeYZz+QE0lrvN7gNdYGjxP8Jmw=;
        b=iMfs4579F/3DV7HpeTziS1ecLvwtz1JlqyF7bumVtFR7TAu41IA0mcA0okt8+6WkJj
         cyi+T+mjRGsDFLtX2FzQ35uvVHcw2lpJ09we6AifEUntPuvnwdqVu/clKUTQhFvGAZe9
         cDzK3BxxKw1bZPOD5jpEhsnZkacAINq2XtgIUoxeg/IKwSKDI7Q/M2P7IrG/WwxDBYux
         a28z/D+RVN2vCyEJ5VsPtZ3FH/54xB8jmQr+eA/NMCGt/VI27TrAhDU0xEATGoXW1JBq
         tw7EQJRhhGLlmmJUUg82ThbRrk3eug59lMG7OEwcAXSeyQO/y21r0uqAbRfENw1lr0Wg
         NvVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770042862; x=1770647662;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rEpZFSBYqwbJS4DeyzeYZz+QE0lrvN7gNdYGjxP8Jmw=;
        b=b/D1OUmg2A5PCqr4ZbZjmM9iPLDVHUCbEpl7Ngc/Sql0edxaaZX48+k0ZPvCtGkWDt
         FFoypnppMUcFEiZijL5IBSox/UCHjPX7kdGRAF439JVWNvm4XqMIHtQ9ddrI72UUsRtL
         c/i/mTczgVCET95+1FguZqizQjtxFo9r0kfmnkqcQmvbK8iieOq8bGhq/G68nBsY/ikC
         xAadQ9YVeAK6KLDbbOU4rUfAvzLfU+6OHa+b3oWurE+tT1aluPaNtUdyWD8R9NehOVMG
         NENcee/5qa9Li0ag0kCXH2RT/EGsf3KshwaMSk333bBpM6m94AejtOftm0siB7ckvEh5
         8DdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrL5vDhSGTvRY5rwsyLy3lZ4Gk324H2KW+d8kI1bQhoBOl2sclHr9kDSNfbT1/hY34B9HP0vXezg==@kvack.org
X-Gm-Message-State: AOJu0Yz4Fs15hyggDlg0CbMnybKwWU9+COQjQiPDwsKB/qD5euG8GweL
	dO8i7QNjmwOgrB45cUJB3kCm9QSfiyxK7rFbTxCJmEUdEhelUrRvY6kOfhV0H4UvtFg=
X-Gm-Gg: AZuq6aKKnn8dQjKWBia5cCQp2ToVvfOdYBUIo+Xvb6xD5t+BX3/IQK8RFtcbFg2zuxq
	HX3MXeVgKxEDsUwRml3u8LYOKXdKpwrkANeH5B21xT1zyjhbev3iJ3IkDiQtDtNviRxnFrpSU/U
	DDD9X+KKv0r0epkKl9wHCUQ6MODVLUCCkvsSTki1OLu26wcZD5S9ZCrVoiUBiV3mg37zdfsGhY2
	POoerkUGSxM4992COeGrFunef7W04Vnt/42FXy3uaYL/ZDmzndTHDlmtqr5PYsHT2K8Q+YufUkU
	bVlcyjf8jZCN85Icc9LB9MnJWCjHn8roCspAYYG+8xTtTH6PH02C1EPiKuiaOtM0/lg8wi4m9oz
	gQMTd9tGxkjGUdIkq0jjkiRS+nL1vLzRHbBdBCRjmKytbqRXkb6mnRRiepLYe4jCfxnM9JBpF0s
	KMXVnWXvgqcGZ48u3buDQFqMBVR9BfvYhwX8o4u7SanYgpHl08P6oWhSi4MI/X/mblfeJamFvJj
	YUe2Cjl
X-Received: by 2002:a05:6808:11c5:b0:450:7df:e90b with SMTP id 5614622812f47-45f34d19f40mr4776909b6e.52.1770042862407;
        Mon, 02 Feb 2026 06:34:22 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4095751ea47sm11310436fac.15.2026.02.02.06.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 06:34:21 -0800 (PST)
Message-ID: <01839e70-5a71-4969-ad5f-2495754250e1@kernel.dk>
Date: Mon, 2 Feb 2026 07:34:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Introduce IORING_OP_MMAP
To: "David Hildenbrand (arm)" <david@kernel.org>,
 Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org
References: <20260129221138.897715-1-krisman@suse.de>
 <62d5954b-8ad5-4674-986b-c1168771429b@kernel.org>
 <f6098b6a-6283-486b-8167-b77c8d2e7880@kernel.dk>
 <6a351a3a-861a-4b93-8d8a-c0f5b87c258f@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6a351a3a-861a-4b93-8d8a-c0f5b87c258f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A484A2000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 3r69a95kh9dc1icgtaprgkoxk4trka63
X-HE-Tag: 1770042863-291081
X-HE-Meta: U2FsdGVkX1+laipvLWdNALYdOIgByaBbMW7K21bJ4+tRbrzaUs/i6x1hkESKa/b/3UIsg9RCL2nRetaSRVjO+6VYg8kWx0HOxrN7gyX59FTEuPqBuX3E2sxQ+ndjg99q2kRZOydUTUR3MmnlnXza8ZdJppzVZlGJEDrloKhQ5HrYbRQg0FClQSPG8r0GAJYxTn03Ey2Ov4Rzp4ln91pnayxq1nIp9aK/8i4pZv+eFFA375xsCMkIcvYn17qduuZ3TpsRa5zflTA8jALF7SR6gynOvaq7QSSsr9XsuivuEKyXjy8K80BoNz+K5Gp4aE90NNEcQqPVIqh695vDtLUEtAyaZYlm22joZ62jrSDAFUvOKBZuuuMcv/aBEbv9Hk5ghNRzEj4MItZ8cr9Lu12F9PmCowqswfYQsc3V+R635jcDQ3NtxoQ43aq2miGmfNy6b2wmGJ2lQ9rCeM6dFasDDpXXEbvPpAz3uYFkcvApXmTgLNv4pYop/4fBa6FkO7AJsQM/VCs1GgcECg7mQc4shHvls1MuuK2/+0HZzVx0vPpp+rkDovGH/uUl3mBvJmlhIe1HUqKDnN9lsXZ0/CGSDJuqn5iLJMeRWxSWRu2J3/oQQJaF6d+MD03BSGzleGanAwiBgLpO9pb4NnC1+TmnP9LzlwH22W17mUWmpLCLiPyslio26ELJOcs3WdR5TFYD/jfosN0cSpEQfff5QiBwc6nBno8FjGg6e6N9eDfaQJeL7drvXIjENA3Z8UErY6Lc2H9IizMn8KZXeYyjsHBKFN+8Eja5o9Ty7WJY5O2q/ziqxsbXPEBLpF4LbARkCLsRL+dO8cXjFC2S/QVxd2oLxx287DG/pSPuicYCHUkqn9SvzA7J3dY47HXuKc+YRXZS0meotkOXhG3GSfvqDFWETWh3Z5KmH1id6mZjGVQt6ojS6oNFYEzkRI8Dh5yDEgRj3ZGjcods0yvkufflrYR
 jSoSqScL
 JEjeY7d2UF51v8t8w1KI2GMrBHar6u54Kz2sNTb1gR4Tq4GUR2RhhtM3El6XB9S/epFP9DtEolDvGMmUk7EJzZVK/hju9Mwog6EIZ6v0KWf/2BDpUDz3iXe+VCU4df+7KR005HyrSudyFEpN1rLPpmJVM1TyEY5JaxDXkxV5G/Az8uUI5mnefLvTsAY64aCWyjYEXVql3U8AA6fd8febXgCBVLOLVdXhaWvjCbjd//X32AFgdRKWFKlX9eFDJZUMGJaIlVfkmvyJbxu5l0dZPt2dNQ3iJJPxZlCtFq7q1n8L3Ne5OP9esPOdQG9eZekRLLIPXJXTgeI0xnwblUzZ+j7Gx+MxLrI0qHn0txpjp6MOdPxI+x1b3eGZN9QygC7pFA08lQBN8JhxPzKr6PwTenfAetHScBf10YDPoc0H+NPV6biqwazwKe23fMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 2:02 AM, David Hildenbrand (arm) wrote:
> On 2/1/26 19:16, Jens Axboe wrote:
>> On 2/1/26 10:46 AM, David Hildenbrand (arm) wrote:
>>> On 1/29/26 23:11, Gabriel Krisman Bertazi wrote:
>>>> Hi,
>>>>
>>>> There's been a few requests over time for supporting mmap(2) over
>>>> io_uring. The reasoning are twofold: 1) serving as base for batching
>>>> multiple mappings in a single operation 2) supporting mmap of fixed
>>>> files.
>>>>
>>>> Since mmap can operate on either anonymous memory and file descriptors,
>>>> patch 1 adds support for optional fds in io_uring commands.  Patch 2
>>>> implements the mmap operation itself.
>>>>
>>>> Note this patchset doesn't do any kind of smarter batching in MM.  While
>>>> we can potentially do some interesting optimizations already, like
>>>> holding the MM write lock instead of reacquiring it for each mapping, I
>>>> wanted to focus on the API discussion first.  This is left as future
>>>> work.
>>>>
>>>> liburing support, including testcases, will be sent shortly to the list,
>>>> but can also be found at:
>>>
>>> Just a general question: why do we unlock each syscall individually,
>>> and not in some intelligent way, all syscalls at once? :)
>>
>> The hard part isn't enabling all syscalls at once, that could be
>> trivially done with an IORING_OP_SYSCALL and the SQE carries arg0..argN.
>> And for any nonblocking/simple syscall, that would Just Work. 
> 
> Right, that's what I had in mind.
> 
>> The
>> challenge is for syscalls that block - the whole point of io_uring is
>> that you should be able to do nonblock issues with sane retries. The
>> futex series I did some time back is a good example of that - you modify
>> the existing syscall to expose the waitqueue mechanism, which you can
>> then use to wait in an async way, and get a callback when some action
>> needs to be taken.
>>
>> If you just allow blocking, then you're blocking the entire io_uring
>> issue pipeline. Which was exactly my main complaint on this patchset,
>> see the review reply to patch 2.
> 
> Makes sense. I was wondering whether that could be optimized
> internally in the stream of IORING_OP_SYSCALL.
> 
> But likely that would make it more tricky to optimize.

Are we talking generically, or mmap/munmap/mremap? You could trivially
make IORING_OP_SYSCALL available and use it for everything, it'd just
require a basically all of those to be offloaded to io-wq internally in
io_uring. And that's not a great approach. The fast path for io_uring is
running the opcode inline, which means that by the time the syscall
returns, you have also posted the completion. If the operation can't
complete inline, then the next best thing is to have it be triggered
when it can complete, and then retry and post the completion. Think of
reading from a pipe - if the data is there, the read is done inside
io_uring_enter() when the read is attempted, and we're done. If no data
is available, the operation is queued. When data becomes available, a
retry is triggered, data is read, and a completion is posted.

For an old school kind of syscall "do this thing, and just block the
task until it's done" doesn't work that way at all. Running those in
io_uring would necessitate punting the operation to io-wq, which are
helper userspace threads for io_uring. As there's no way of knowing
whether syscallN will complete fast inline or block for 2 seconds,
io_uring has no other option than to offload it to io-wq. If it's a 2
second operation, that's fine, you won't see any difference in the
application, other than it can now do syscallN async in an efficient
way. If syscallN would've completed inline in 1 usec, then offloading to
io-wq is suddenly a big performance problem.

> The patch set says "serving as base for batching
> multiple mappings in a single operation", and I was wondering, why one wouldn't just also batch with mremap/munmap/ etc. in the future.
> 
> (BUT I am also skeptical whether holding the mmap lock in write mode
> longer instead of repeatedly grabbing it, allowing other operations
> that need it in read mode etc to make progress, is actually
> preferrable)

That's always a trade off - if the frequency is high, then a certain
level of batching makes sense. The good news is that you get to control
that, you can just batch more or less.

Outside of mmap locking frequencies, I suspect potentially nicer wins
might be around TLB flush reductions for this family of operations.

-- 
Jens Axboe

