Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4BBC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FF86B00A5; Tue, 22 Sep 2026 06:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DFC96B00A6; Tue, 22 Sep 2026 06:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CF696B00A7; Tue, 22 Sep 2026 06:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 528A26B00A5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:20:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB7391C27B6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:20:28 +0000 (UTC)
X-FDA: 85241003736.17.18FB0A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0FCAA140003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:20:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EG8irrhl;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790072427;
	b=X7FYf+e0/eUMFuQ037VjXJQGeQBgAIe1z0QTzuUhTAlK90hMsZIgJ2xPCu6itqxFxprFV5
	l2jV3mY3s+ZhG3HwKHuwWqiVof1IKOqN81AHmhndGNzJ1SQ5k72tI2LO3Z9/N5uudcLyfY
	W/522neNlRC7mQdZEgvT865e4UEhVr8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EG8irrhl;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790072427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wWA54+thjo72RZTenAXavughrhfStRlphPd5wFtIuK0=;
	b=hJ8cb1dUlrdmMFn7N5IJInM4uWWNWL+JCaJjwoSr8ZTeuw80Oh4LuEjCxt7sxZ8Z8SqTys
	JcsB8mx93jNTW4Nuxe3HUZb8gFmsG1t8r4aB+ZCk0uRtLlSqieansF+LFbVbn6RYl3ILK3
	HoSqK3afaOGOmOXNXLNKYnWD/v/lPa8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FC9E419B7;
	Tue, 22 Sep 2026 10:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55571F000FF;
	Tue, 22 Sep 2026 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790072425;
	bh=wWA54+thjo72RZTenAXavughrhfStRlphPd5wFtIuK0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EG8irrhleE5tGp0cIzec1UDmMwg/NeWfH/qbHqYh3X2NcQG0P6D/1wL73MVMSQsOk
	 kIHQFMhrkHU1Mbd6HIxWWlpxfwmvYcco1naWatJJxl+Tdst/kyR/7LS4ngmKnyu3ZU
	 7+RqqevYl9vwRXJJ7fVX0VB8+29EE5ZE0sPkcgs8w/udNwBiols12ivEUDX4VTP/Bp
	 z5Np+m6N4bj6mxzF3UtaJu2XFnS01VT1HLTmi/x+9r2DV+cMhKZlDkK0UkIs5t9jYz
	 zcGjvrWGN3F+T1+ZYbtBBr1JGOa0KWTRCFxNQGXp/8RB2RurPahWQSUWREShdFexmb
	 7NtNg5XOP0nAA==
Message-ID: <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org>
Date: Tue, 22 Sep 2026 12:20:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback
 completion
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org,
 willy@infradead.org, jack@suse.cz, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org,
 chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu,
 hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260921152449.629486-1-alex@ghiti.fr>
 <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0FCAA140003
X-Stat-Signature: xfhuqdrt5c6b7mafnfzmtrb4z8kcedmy
X-HE-Tag: 1790072426-260791
X-HE-Meta: U2FsdGVkX1+Xj4rZ+TUC5enWoSJu7XzJY47+/SP8W4/7925tRUPvf0YKzbGGWb6+9STyAj74LCjo3TDgmMsPLNJJGwgk5ggrCwTU3PuVQWgVyKMCIme2J34Xz8ONF8AbEO36gnjzhV+Uf4I5z2Z3IQ7OesL1QeUWz5tZUtMhDEWuMqA2WMZmhFLAoQMa6XwJb2HroC5r/7MHPS0ifqjbv0MHYVYxGFvhniR1r5TI/WlFGxeDDepjyOUAGxBJ8x7NkvT4U1jRgyFC1JhLmJFiy6GebddRdeqJLyzGSySu6iTF+weM+V22a8QjG6zkeP+CJCepaFawimG5PixvjFqnP64wu33QxSeN1DC3r1WA/l3yAiSZezOMrHOTlT/+rJmOXlaIqs/DVreBgnw1huvEw8rtUBT3f5xE2qjkp3PCAPUN8oa3J0JhQS7mrnKrUUEOqBIdZAvCZ8og0bD4Hfa+Qzpqh4tNcl0b4ICqhuhhrALAtIn7nvD9Oo0ObghhSzLbVn1gwDoy1C4JDmfmxTNu/2WWb1/Sv5fmy87dFsAHD/ReQt601yx8G3gXDODyfa3P8596gWuW1tmsBkEB/uV2B52jNRPQNoLiw9NS5uFZL2s/94XO1wHyvNZ2qf+H9NlgZIGr7du6v6C6VqwlUM4LxtaYk5V2oA76FKWppM3YO48ujEp519k9m9vFPllD9Iao1Fby6Hzp2Zyw4WLB1Ci/FFygRqEytBR/kUIVbU8rAlnVrInaDLnBFIywW3fqAMLWk3yAYWPhA+GNR/AM7h8VDm6LBpwyLBHvR0yDUg+nrJP85TJEXxHwPZtaqNVOqpsLQoGVfqgiLXqITJDdOsnBUtzZAbnspyHS5SwA1tL/qTodU/0zK58wLrISyzFMdQu8UOgBJtruEJsnvRrQu+bjXi6aPHA8jH6wByWrXqHsx9l5Mk1Zji755+DsZpPp59OGLXvWuHVlwMeAuqbipC9
 /mpZtdAu
 gnubllDP/APlInUqzhBIiqlyaxMkoHyLruqaxwEbFrtfnrD7NPE7udPpwqtcVmIATzYqwLc/7uF4YhjGOg9/TehrdI4q1DqAWyA6XRkXda+hMFr+NTCKFU47hBYv2P/XtWR7lVIjm3oUAhC9tonSb2GnqxFD/FyVWxEhSAT3PUYnPiA45vuuwiMqRjCrYNUFutNFcxFxjN57gEqFQNfoZB/d3H+FJ209B+RQYaSXsW8jvlio3tAzVVYetk17ChUKbluZke6N5Yr48H3sj51nB+f0pbiMQyor3u+H+SFUCCZWlR+Eqy1ZG5D/qtd4UMSgdb7UyaP+7h1TnZPXBnMRO2/7UMXlH6UEN5yCH6qb1bjdKSRb2N7Vxpe4XmfSBGZ+8JgyXuHrzcnAmBy80S7lospqekfeWcEABQIPKxnLRBS7vxXM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 23:56, Barry Song wrote:
> On Mon, Sep 21, 2026 at 11:37 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 9/21/26 17:24, Alexandre Ghiti wrote:
>>> On an asynchronous swap device MADV_PAGEOUT only marks the folio
>>> PG_reclaim and rotates it to the tail of the inactive list once its
>>> writeback completes, so the memory is not actually freed until a later
>>> reclaim scan removes the by then clean swap cache folio.
>> But we have the same behavior when just reclaiming memory ordinarily? It's added
>> to the swapcache and only the next scan actually frees up the memory.
>>
>> Wouldn't we memory we reclaim ... just gone, like in the sync case?
> 
> For synchronous I/O, such as zswap and zram, the memory is released
> immediately after sync I/O is done.
> 
> For asynchronous I/O, such as NVMe, the swapcache is currently
> expected to be rotated back to the tail of the LRU and wait for
> another scan. Alexandre once mentioned that when he tried handling
> async I/O the same way as sync I/O—releasing the memory once the I/O
> completed—he saw some regression. So, delaying the release until a
> later scan may allow swapcache hits before the folios are eventually
> reclaimed.

"may", do we have any evidence that this actually is relevant in practice?

We asked to reclaim memory. We wrote the memory out to disk. We unmapped it from
the page tables. We made the workload the could, access the page immediately
again suffer already.

We should just evict them as soon as possible to free up memory.

-- 
Cheers,

David

