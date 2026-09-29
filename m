Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50944CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F3F16B0088; Tue, 29 Sep 2026 03:00:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A46E6B008A; Tue, 29 Sep 2026 03:00:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36D586B0093; Tue, 29 Sep 2026 03:00:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9816B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:00:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02960A69C1
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:00:04 +0000 (UTC)
X-FDA: 85265900370.16.816070B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 28E40C0005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:00:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cRzXyvGm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790665203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=garVLKILVisEciTz6na9cNM+VbCJ4C79fMTVEKB5BtM=;
	b=Ig7NahUX31BJlvfo0zEqtcOL3aOTp8hwaYsOuGGRqBiQnke3HCDKOyfeOQ3iOPwccSjd5Y
	7oEzG/lxuZ79M/aKMEapkDq4AljD5xVpY+69q2Q61DlA2oaN+QtL1WvXlhp9K1sX+yHTu7
	vmW2iMWLe7KPwiw6lCQaYzVPtY/qHvE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cRzXyvGm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790665203;
	b=8ip7oi3nrKmZvLOo0cQnMEdvuYot2gPOocVlXuKp9yqK5QhFucJYvPZk5ZQSmql8aQZ5bw
	BwTFrqnhAeCjY+1CmCEpvUxOWeJ6ZOXkzcPH07F8E7oeVI7/vx3VXRy+CWyY0nR+o6ZDpc
	IhRPMbKxn0+D9lMV3lZmfyZplqzCLSw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8402441373;
	Tue, 29 Sep 2026 07:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719341F000FF;
	Tue, 29 Sep 2026 06:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790665201;
	bh=garVLKILVisEciTz6na9cNM+VbCJ4C79fMTVEKB5BtM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cRzXyvGmCyBIYI0SWfYTtYfVhD8T1cQV3c//l2q0FGGQDafbemFaxom7MsPZwsP10
	 y8ANSdigNd5CFFR9DdsLAImMKs5+yhX+HxfZe6kljUCLEVYvh0318w1AYSHfSvEaQu
	 O5cHlwhQevGMNMw4iBwtyxfr8Rd3KqkX3maoYbvhYsaAdYcTw8tyTfNVVZBQ0pvDFp
	 3nzaSX8z1lqQL0QPYdaR48zfLUNcmwaMxAzsv1cPuUAYMsnng+t4naDWVMqsHl7wMT
	 4JbWrFGlj+K1NlX/Yp2UUyZ/P913Bqy3odkr4GxUGCOYbmodwrMs5c+VsmLcBv79dG
	 /t75QpYItogPg==
Message-ID: <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org>
Date: Tue, 29 Sep 2026 08:59:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file
 mappings
To: =?UTF-8?B?5aSp54u8?= <rockeet@gmail.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>
References: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
 <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org>
 <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org>
 <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4cojpy59g513e75p6witqeem9ofaeq7t
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 28E40C0005
X-HE-Tag: 1790665202-234690
X-HE-Meta: U2FsdGVkX19W9KO+/Co7/T7Prfbm+cHTkfeFJ1UbOoUiaB5w2kfOt4aAMp1asGqDc8+Z/kIXvgy0q8sKUqE7QuRvjCROsTD12yfjPQQpiyvF3G81+eZytsLyStebnrga+AUR1XDl+lUkE09Shx9gnseGKV4aMUvgaIBMmpT7+g/NCMAeWBwkUN1vHcIAjZl4V/cuCgLr21JhpdYcZ6cxKoi4AoHaf1FL/B+Aq0DR6FzW5pcED+bsM/sVkNcJe5ck9Hi6aeOXS0bGRrOTzrDszUoJlkHUZxh+I+SVSXVWh09j+aXgOR5qPHCDtWyqfEnLTL6QMwnV/jluhibt1kMqf0jQ7Fooiiy8kggdanAxBD4fa5NxtYRY/EOqIaqwEe5NpV+Z2Ye30G+FqPm5BNoVyCJ27+Jv0H1w5vFhzp/u3ukThBvQRupDgCoHXppWGv2GjgBh1RN0ueVW7+VJzz5SgqsUnpXmJ5pYHn6WilRwFwMTNNj3yba8B29ciLBIc35jDPIiac1bV1oaJ+5EdCZ/dDK2tbmtTiYATIMdmiBMPKNsQRNsL/8EofvaH3j9lWKtRoece4VlsOY6zPTzL+s8Qt6gFbfo0OmugewqWtn7wC7Y8TNzmrU9kjwDL69bSlldv7CfPCnAV1eP/TOInkdy/eM2Ll3KI0dXyjhMiGNcEWxWokklkIh1fsh1+IjjrTaAxMP1BSdhJ83+IpORyzVOdbDw/bRc5CLm2Kt9ck2+DqTRB0z6e/qGaiVCL+gh9xZXeD2veiUrA137m9+Lcxroykx1F6fUf72QROVbHV7zfNSmt5d4Bk7si6a+mWk9LMqywwI+KEogT4ga0Fgczw7O4hfzz6ZU8ZktRhm5BTuwbXEMIF3hLVGSZr3TQuJPyHdOQEJof2tFG8v16V4NxvX/XQ9Fc3MEkIZemtVySbr2GYHHCDYcGk59zCecc1UUHUCDUo0tr/bLH9yyCoz0NHa
 u50i/VlX
 nmlmM2zH1p4H/jVdrGKZOA51eWjWR9UbvFqrRCt3ZFeLzTSnWi2HgWZvOyip23QyKLhctDgpEzMAhVS/+H0znqbZ5UE1T68CWKgybKcTYjvQCFswF8VYqRVna/3LtZO2qpeEmq/4bJCzvNz75DYgAeIuUYE8qJ/FYP5+Az0tajaWJTsQQvHuiX6U1SgV7kZuTkmMUhXvAllmyPxb5S0xiuMkk7GSAeG0ccc/3ScO1Pond9G5W3Che5Nvb43+mT+5F6OEwSpic6fX8N00Ey/D92RSLLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 06:06, 天狼 wrote:
> Hi David,
> 

Hi,

>> What is supposed to happen if the process crashes when updating the
>> MAP_SHARED region halfway through?
> 
> The data structure survives an interrupted update through its
> application-level copy-on-write and lock-free concurrency design. A
> file-backed MAP_SHARED mapping preserves the latest userspace writes after
> the process dies, even if they have not yet reached disk, provided the
> kernel remains running.
> 
> This does not depend on preventing writeback. Deferring writeback is purely
> a performance optimization, not a correctness requirement.
> 
>> It would be helpful if the use case + data structure would be explained
>> in a bit more detail.
> 
> The data structure originally used uint32_t offsets instead of pointers to
> reduce pointer overhead. On that basis, we implemented lock-free concurrent
> reads and writes, obtaining crash safety for free at the same time. We use
> a file-backed MAP_SHARED mapping to turn that capability into an actual
> feature that survives process crashes.

Ok, thanks. Just be sure: you really need an actual file on disk. Shared memory
/ shmem / memfd is not sufficient?

>> What exactly is the problem with writeback here? Unnecessary I/O? Is
>> writeback the problem or actual reclaim after writeback?
> 
> Unnecessary I/O. Reclaim after writeback is not the problem I am trying to
> address.

Ok.

> 
> During construction, background writeback can write intermediate contents
> that the application will soon overwrite. Those repeated writes waste disk
> bandwidth. Delaying writeback would avoid that waste where possible; it is
> not required for correctness.

Understood.

> 
>> In a fuse server you can in theory delay the writeback request.
> 
> Thanks for the suggestion. That sounds like a possible way to experiment
> with delayed writeback. The feature I am requesting would make this
> advisory behavior available to applications using ordinary file-backed
> shared mappings.
> 
>> So fadvise would be an option. However, this "defer mode" is really odd.
>> It sounds more like you would want to have a custom policy there [...]
> 
> madvise is not the only option, deferring writeback for the entire file
> would also be acceptable.
> 
> The application only wants to indicate that it is still modifying the data
> and would prefer background writeback to happen later. The kernel would
> retain control over the actual timing. Memory pressure could override the
> hint, and explicit synchronization would keep its normal semantics.
> 
> The hint should also expire automatically when the owning mapping or handle
> is released, including on process exit.

Ok, so while you are updating the large mmap'ed file concurrently, you don't
want writeback to go crazy, because you know that you will modify the memory
immediately anyway.

Let me CC some more people.


-- 
Cheers,

David

