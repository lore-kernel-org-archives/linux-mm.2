Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79937CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 09:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC6E6B008A; Wed, 17 Jun 2026 05:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56E4D6B0092; Wed, 17 Jun 2026 05:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482886B0095; Wed, 17 Jun 2026 05:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5426B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:14:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DA4D140374
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:14:46 +0000 (UTC)
X-FDA: 84888844572.10.653818B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BF5971C000D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:14:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hEZLU4Xb;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781687684;
	b=OFjnr8/M+DWqyS8XtNps8i2ohbObmkX4mcBzDFnj8RPPupBTzHhDuZk1aVCpSJTVlZWJtO
	hMZ4d68rbQLtNOLBAGBJ3KeytwNLlwz8948naLWClMh+TYV7tD7UQdA1iXfR8CZ27UfX9S
	0bnBUa42x+1tY1Hjt0YF3LaPX02qlvU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hEZLU4Xb;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781687684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fKXBcpbT3wLwi9JhWxjuhVZWKI5lCwWfmZAgCJnN0E=;
	b=KH+rHckOArYEXI0MlRjp7BQ3yL1+uOhPQaszM3li9EbT+KcSB/u/yB/niX0GyEETtTOfq9
	mmWQS2Hc8X1wnEM4WiEGNh+Y6/1xBQIb910/R9FwHPxNIGUYrtxDOW7QaOo78YB27YG9gI
	eNX4ja9XyW7I70kLxp5vvXbDSZQ4zO8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5D784016A;
	Wed, 17 Jun 2026 09:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7055F1F000E9;
	Wed, 17 Jun 2026 09:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781687683;
	bh=3fKXBcpbT3wLwi9JhWxjuhVZWKI5lCwWfmZAgCJnN0E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hEZLU4Xb0udckUVgZDE/f+YJNwkXc6aWaf7kb6rt4idC//umuNLhI6qCHnDikbWo4
	 6G1uPVjID2YNRGFfqlCIPr9UKl0rPva7ZJa4FSpsbgJVyf5oGmVZJKALILIuW2fZA7
	 OXYmLgP2njQYSAvDJ8H6v/0S0IStut0Il0DNPVEf3aDYSQZRtX3yi05QKfL7lvErQ7
	 HdsjsV1TE0Ycokhr2ZrQaYWcSqpho122YisVdhxFuapjts6XU+6PBJQcNzroe/fcke
	 3FbKKgSNRXTEC+d60usINRvtd6RHygYvH4zg7h3kHFgCur1+R4tL+g88d8mmRr9JPd
	 nhLamB/HDHEgQ==
Message-ID: <7e77c739-a279-4875-aa2a-e68430aa7404@kernel.org>
Date: Wed, 17 Jun 2026 11:14:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm: memfd with write notifications
To: Mattias Nissler <mattias.nissler@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Mattias Nissler <mnissler@meta.com>, linux-mm@kvack.org,
 Hugh Dickins <hughd@google.com>, "Lorenzo Stoakes (Oracle)"
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260603125521.1468362-1-mnissler@meta.com>
 <7b05bd27-2152-40c7-a777-390ded5defd9@linux.alibaba.com>
 <40381f8a-47e3-4f97-a9ad-f6f868fe0392@kernel.org>
 <CAERLvmQyOAvCN971uUx1PDqTXExOv-BHbNgo-oByaHavUmLgfw@mail.gmail.com>
 <ee858321-7407-423a-adca-caab5ad9e2b8@kernel.org>
 <CAERLvmSc6Z9JN-Ufc6_NJvuk4S8oLD-HfDdWS2k1JNo90vhjQQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAERLvmSc6Z9JN-Ufc6_NJvuk4S8oLD-HfDdWS2k1JNo90vhjQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF5971C000D
X-Rspam-User: 
X-Stat-Signature: qi6h8dh5qd4fmzxayhi5iad9ytm7upcy
X-HE-Tag: 1781687684-815892
X-HE-Meta: U2FsdGVkX198YRN/KUTzKmgOPXqrFTNmrWcHhdMOjdc4IGoloc4lmcXgvoBUNmBCYBzmwEpVItwIqjkMHdNhVoSLlPgM0tTVpLiT8tLM64YuRMw2UIC7D9zP3hunqvc5nqBHATf1qxci9fwVNyI1L1EOC6YobA5XRC7g5PSpYotjsHUsULklLKIsaAkftRsudGxPxVjiKGPAgYPaM6rCSt86KNSXVNgLljgNHMsnU7RjSO7jGXaNWHV0PIH54N/y6NEZy+9h7BsMrEgcUfiWys46a2I9uO2ZP7hOrFSLoa5/2ZFDpGUhdt9KUfguyGhxJKIAXqANcF2Y6wwW9KGN9MPBTXIqeduTiN+zS8CRacFIY4TOHWM4Xjk/H/oh4D1YLBk4i8k7WXBx1NapzSzTlBdp4KzO5tkOe1iNlW/GUykhqOkuJ7ycdObKKbMhteZ79qD1uQSyoD5XjSfMH54a7g/yGLa3MwQqUDRz3puEdMckazLQtXYw9wjmjgHxMES9CjjRVbWqv3VzhBQ2R5ZpSdAxBq4QG8hY+aABTwI5R658MBKrLwnl/ErbtHiCCfSxvGHBjJoBCC68EdRNcVM9ajKSoBaL/sBudv+bz95Bz4Uwo8qtjYdT3eAgYPI8IqJ1NFxNoSy1XnuWjXdywJMpo2Js3aUhlWxzvV4miGh1UTEYMRKAodrfpEKShoDNfrK9P0FDONjnMEpUpTrvmxhx/Ab1lXPhMtaUGlBtQg8Z3HueMmKHhNvnFb9Cp54c7u0hvuLygd/BMtzebSLDQFk/LgpZ8ifOrW5AHsHT2uwRQihVjdlFqSGWLRTZQE6mDOV17yQ2+cl7H01jjFW4FKxTSTye/DsAIkrPMnlt5+Y3xFlo7/z07xIKFtxWoQ3IwumuT7VReZQP0IKCBzukHnzQKnta/m5glyu8tuVA233BZ7EmDc/+HXDZpIPyxRAFheidqGT+uqwnfuA0jjoMcHa
 np5ZNfm4
 0/4hj+3Ff6+V8uYU76dy+BgVD5gQunWFdzUoEC8MYE+VJCHd5cnNtepz3WUbQbUCn5WlZn7/SR26q7uStnBf3ArBLeI0aIQyS7mZKqmc8G5Cuxr0HRAtcTlKJKeF1WtjUoxpgrJjEZPoiAaUQswiA3PkzafE2NnJW6P07FLSZkoUt7GeVLIrGv6mmDyjtK6OZYWmkp3++xEixv6ZXqfdaWdRewlyh6qAbwsMa2y+DKa+Dj/LQ9nawCQi46lZFJSzsVxjR0iVc6CoU1R1sLb0N04ZaSkeu3CO1IIVtgqn7/CAiUbw89SbGF5Ow6hBfaWnKDD59KJO1LbZqGUg7O/9kZxdWanBawzQ4ZIuKob5DXWfG0azvNA26fY3dZCE8RM5VN9q4xcEvESv0bkZWkDGW3W22adpGM8Zjr0kiLhnojhbUxt2oDeTdokbSTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/16/26 13:32, Mattias Nissler wrote:
> On Tue, Jun 16, 2026 at 10:20 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 6/16/26 10:02, Mattias Nissler wrote:
>>> On Mon, Jun 15, 2026 at 7:43 PM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> Thanks for bringing up that context. So this is mostly dirty page
>>> tracking? I reckon you'll need a way to learn which pages have been
>>> written, rather than just a notification if any page in the region
>>> gets hit?
>>
>> Yes, for QEMU to use it as replacement for uffd targeted at multi-process setups
>> (i.e., vhost-user), I think you'd need something similar like uffd, but on the
>> file level, and less uffd-like :)
> 
> This was probably a bit tongue-in-cheek, but if I may ask, what
> aspects of uffd are problematic?

Heh, there are several.

Let's ignoring the implementation-wise issues that people keep complaining
about. Two (related) problems I am aware of:

1) User-space handling

Right now you always need a user-space handler that POLLs for events to handle
them. For each event, you have to context-switch to user space, sometimes a
couple of times. Scalability problems (many threads faulting at the same time,
in-kernel locking) was raised as a problem in the past.

2) Blocking nature

If you look into the details of the history of UFFD_USER_MODE_ONLY +
/proc/sys/vm/unprivileged_userfaultfd, the problem is that userfaultfd can block
at various places, some of them possibly being able to hurt the kernel.

We inherently rely on user space to make progress.

Using BPF[1] could avoid both problems in some scenarios, but there are
certainly use cases where you would still have to block.

[1] https://dl.acm.org/doi/10.1145/3672197.3673432

> Obviously it being process-scoped is
> a major mismatch for your use case, but are there any other challenges
> you have in mind?

Right, that's a conceptual thing: userfaultfd protects VMA ranges, not file
ranges. To emulate protecting file ranges, you have to protect all mmap's in all
involved processes.

Obviously, things like read() or write() instead of mmap() cannot be handled by
userfaultfd.

> 
>>
>> But in general, protecting/unprotecting file ranges (read-only, read-write),
>> notifications on access, notifications when filling holes etc.
> 
> Do you need notifications to be synchronous (stopping the faulting
> process) or is asynchronous (firing a notification and
> write-unprotecting automatically) sufficient?

Most use cases I am aware of need to be synchronous. Only some could be relaxed
to asynchronous handling.

With postcopy live-migration, you really have to place the page with the right
content before the faulting thread can continue running. You cannot just place
zero-filled pages. Similarly with CRIU.

With VM background snapshots, you really have to save away page content before
un-protecting and modifying the page.

For electric fences[2], it might be sufficient to just detect "wrong page
accessed" asynchronously. But it doesn't really work on files.

Protecting unplugged virtio-mem memory in VMs from re-access  (sparse memory
regions where some parts should no be accessed by the VM) could likely get away
with asynchronous handling, but similar to electric fences, synchronous events
might be better to debug the "what did actually do something wrong".

I assume garbage collection similarly requires synchronous notifications (but I
would suspect that this is usually anonymous memory).

There are some upcoming use cases around working-set tracking [3]. IIRC,
asynchronous handling is usually fine (or not requiring a notification at all
and instead inspecting the accessed-state).

[2] https://gitlab.com/efency/efency
[3] https://lore.kernel.org/r/20260529172716.357179-1-kas@kernel.org

> 
>>
>> uffd gives you that of course, but at the cost of the kernel
>>> having to perform more bookkeeping. Trying to wrap my head around what
>>> a good trade-off for complexity / user space API could be.
>>
>> Yes. For a simple doorbell mechanism (IIUC your proposal correctly), it feels
>> rather odd to embed it like that in memfd.
> 
> So what you have in mind would operate at the file level, but work for
> any kind of file?

VMs with file-backed memory usually rely on shmem/hugetlb/memfd (+guest_memfd in
the near future). Other file systems are uncommon.

For CRIU, I could imagine that other file systems could be reasonable, but I
don't know enough about how they handle files.

> 
> Btw. thanks for bringing a different perspective to this conversation
> to help explore the design space, this is exactly what I was hoping
> for.

Sure! I guess my main point is: most use cases I am aware of would need
synchronous handling (and have ways to fix it up, like userfaultfd). For a
simple doorbell, this might not really be what you want.

-- 
Cheers,

David

