Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2028DCD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 14:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79056B0088; Fri, 19 Jun 2026 10:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A486B008A; Fri, 19 Jun 2026 10:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3EA6B008C; Fri, 19 Jun 2026 10:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 836ED6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:27:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6293D40427
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:27:19 +0000 (UTC)
X-FDA: 84896889798.17.135ED8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7643F140007
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:27:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=giXjF4dP;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781879237;
	b=1nHexhDvliXnBqJavqPT0sU/f0q146enyAF8qGVl2chGEGHt5mB5rZNGm6g5y8EbvMZMg+
	HAkFZI95VWcd5kDBGfQKhEzjt7ORqD/Yy8wXWFmjDcow+uxAXQkZ1xzJ1TwksSl1QUEbM1
	f5Sc17FvHt8KrmvOX3gzmDio8lMcTAo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=giXjF4dP;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781879237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvmmWMqqk4mhEEd2iTTFb0La55bI1ogNn7PI48Pfp9w=;
	b=qlW1xw70Qobs8qcZN5I5mmTH83aDx1FllwCSUaCMk9u+FUIb9oFEYr5k/+ry3x6fvojyXi
	5WtOJIfiWnFbXgr3JW0pf7fSnIDRxfoxt94g6piYlbJk/kJMy2frJYiU8pvAw0So69Mrdx
	tfpyYgiYI9yGQZqui2w75kxrTZ7E0Oc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26B08438BB;
	Fri, 19 Jun 2026 14:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045101F00AC4;
	Fri, 19 Jun 2026 14:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781879236;
	bh=yvmmWMqqk4mhEEd2iTTFb0La55bI1ogNn7PI48Pfp9w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=giXjF4dP8PaD3YUUoznlSm3gM8M8eSAXQDkGgo2+RIIBFUXRpWiJRU37xV7Vdreiv
	 CuDFLJ+5jW9wp7M6ZS9NCfaZ8ftOswsLYb2mlg55GNr80Tsr+fy3w9+WuU+4Hyp7wK
	 ZyJgrhNBfdFmiCRBaZ8SgfOp+Rzsn9UxFDH/WyIEvRAhWkavr+AA6IvlZfpMFgqS1J
	 pqVeA2DIWeAG27drb3rW9c8m6q+ioNu33E1/qdYgsB2CMTTl/AgZrZW5f4hETN2V65
	 7kymJK5GawcPL3WdH+X5m0el/EcnfUJqPIxvfnhb4sFayelf48zHHOaaX4YnvcC5hi
	 HUZsr6d9DvW4g==
Message-ID: <a0a3dd20-a255-42d7-aa83-5bffcaba3acc@kernel.org>
Date: Fri, 19 Jun 2026 16:27:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: __access_remote_vm with per-VMA lock
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dmitry Ilvokhin <d@ilvokhin.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
References: <20260616190300.1509639-1-riel@surriel.com>
 <CAJuCfpEKgiQDGXgCKrqnn7Wk5YrT8nr4-H88PVeEruSKjtY_CQ@mail.gmail.com>
 <dd66797a-6fc5-4c31-ac43-d767560f3029@kernel.org>
 <CAJuCfpEqz9t-x8abYD6idtHmi9t8p4YfDmnbkJ-ix4i=RMS4wg@mail.gmail.com>
 <603e002e-77f4-492e-9ad4-75572e18fc0b@kernel.org> <ajU3q1e6mpWsJ6Xa@lucifer>
 <c56f8fe6-9e06-4a65-9470-1fcd12189ed1@kernel.org>
 <CAJuCfpGifYo0iafNrMf4piG8eSb2FSjgVoPr4P-3YDabiwe_UA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpGifYo0iafNrMf4piG8eSb2FSjgVoPr4P-3YDabiwe_UA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7643F140007
X-Stat-Signature: 616btwq6cbeqtgqq4u8dpfpi1wepnmj3
X-HE-Tag: 1781879237-14439
X-HE-Meta: U2FsdGVkX1+/kYfrUcDjRaECumqUtPq9nlgcQWNXoPN5dEhvtNSb4gkwm28KnQuvEdIEluN10y6cts+MfebxEzzYy53YtYylm5rIQAoNq3M7p2hT+HtVITUUTQwkW1lMnCkj6aBgKFpFFUE1B4R80j5/17gjjHlS2Fo9wPVrIMNqQzqxeXAaSh55f+QODJImyM/6FjBLgzQekGq3E58XVKw/TuybZRMVx6sl5hjCzxRE2AhrfnzuAhUVGdX2e1Dqrx7lzKWVOqr059TcSOOmuXgV9IKEJjWuRvP/WWbGgccCEkWi28re9Lwhbp1c+FgyUfNApHhqTByzhF7uER/c/eR85uznAFIaAeuL7zD5Bm9XaMjcivX0V1+SJ3FUdcgrIs//Wp3kYjxedAu9M0mqTBxkJ/d2q24S0rn0SAPfGW/TlvrYllstrr0nVv6ioMv3D0XIL2U53XuLazdK8qLPsPcm7f2iC06EY/iBwyJLdX9vHbXVgvnC8vDhBYYNYUTQyoKhNwJhMvwg3J2xYSZY2r1FQTDkOiCtsAwxZzxFR0Ixd0VRX/NstG4LIWr7udYvNx1BojQwqpzRSbbZrZSZNNjzePNhdlYX0tZRmRK0HbYPxaKR2Cofq+wJbbtOaltsywmTA3DGsBlPCV2PBS4MGJyVHw1zUFYM577WprDKoqCZjilHagmoJMgY1To0gxjddf4osWj/ozEd+VVN6i+98Q2nH2dp/Q9NLjBypQivg0pLKOdv4tfCpnrU1T+TAzJVc3m8s1Q7K2ss4SMU97m7rTyD8IX/6YzYKfqiPliylxaO6cXlfTSofOy6J/puMwQEgj0ydblhckTc00cAHPouibwdqj7tPpeh5Ixnl4kdGonZnGipKEFQ9pGqi3K327oUi1i04XElirRMZS8bla2/nxihk1EAKKcwfvP5olzx7mEneuRzX4lmEgec+lxSO/g4AOzJfyeSWcMgfkC15Z+
 dcOcTL5k
 VPJd76hnPeYf7BOsQSdo+hDpiLv2th5Pf2N2HOaoI87pGnLWElsnPA1cOlw2DZvJGIT4OD0syn53GSI8urDVZo+0Rk+0DEvYq4hUchBJNfSX6SVqlBxO0wTwzvRq7Ho5C2yhPvZSJ2GIEnHfUg7w3PCRHx2uQfVO/FwLfpwsY7xqXE35ukeWDdeNkvs8RmKz6XteSXGEXqPUXxUMkf19BAxh5N1V7tcxx3VrTx7qAZlLJzhGuHzy2D9Ocj9Vs65pqRj6XWcp8+4NQJQYdkgWaA4i46UmJHcsUDmqB0sGd5BDOEHAJ1EO4kTzA7rBefyWja5vtlD0A/ONKsF/NvSpWp5+xDwmgLYYW6g0Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 16:19, Suren Baghdasaryan wrote:
> On Fri, Jun 19, 2026 at 6:05 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>>>
>>> Well I think a critical problem here, as pointed out by Suren, is that holding a
>>> VMA lock means that the VMAs around you can change and in ways that are quite
>>> problematic.
>>>
>>> E.g. The moment you drop the VMA lock that VMA might get freed and then merged
>>> with something else, and the next VMA you consume is the same one you just
>>> partially walked, for instance.
>>>
>>> Now perhaps you could reason your way around this, but I'm pretty sure there are
>>> cases where you might actually miss VMAs due to races (Suren knows best).
>>>
>>> And also without an mmap lock people can unmap and map new VMAs in the range as
>>> you go through which might cause weirdness as well.
>>>
>>> Really, unless you are dealing with a single VMA in the range, I suspect GUP
>>> needs to stabilise that whole range.
>>
>> Well, depends, really. It's not like a all GUP operation that target many pages
>> runs exclusively under the mmap lock that would prevent any VMA changes.
>>
>> With userfaultfd, for example, we drop the lock in between, to lookup the VMA
>> again later. There are various paths where __get_user_pages_locked() is
>> instructed to grab the mmap lock itself, to even temporarily drop it if the mmap
>> lock was dropped.
>>
>> gup_fast_fallback() grabs some pages to then take the mmap lock. And continue
>> from the next address.
>>
>>
>> So it really depends on the use case. I would actually be surprised if there a
>> lot of use cases that strictly must block concurrent mremap operations etc.
>>
>> The important part is that you process each virtual page address requested
>> exactly once. If the VMA was merged in the meantime, you continue from that
>> address in the previously-processed VMA.
>>
>>
>> Some use cases might indeed want to stabilize the whole range. But I wouldn't
>> expect them to opt-in to using per-VMA locks.
>>
>> Just like with any other page table walker, we cannot just convert all in one
>> shot to use per-VMA locks.
>>
>>>
>>> If we could find a way to have GUP fast-path the single VMA case sensibly, then
>>> that's probably workable?
>>
>> Right, that's what I said: start with a single-VMA interface that supports
>> getting called with the per-vma lock or the mmap lock.
>>
>> If we have to fallback to the mmap lock (userfaultd? indicated back by the
>> caller), handle it in the caller of that interface for now.
>>
>>>
>>> And I agree special-casing only one place but not others sucks.
>>
>> Yeah, we're not doing that unless inevitable.
>>
>>>
>>> Perhaps we could find a way to get this improvement without it being quite so
>>> 'tacked on' but without needing significant rework of GUP, but in either case I
>>> broadly agree we need to improve the codebase as part of the changes.
>>
>> We shouldn't fear extending GUP in a reasonable way that makes everyone out
>> there profit ion the long run :)
> 
> I do not disagree with the general premise of making existing
> mechanisms work better rather than implementing parallel ones. I'm
> just pointing out my findings so far when I moved in that direction
> and I'm happy Rik posted an alternative simple way around large
> refactoring and started this discussion. We should definitely try
> reworking GUP to cause less contention. I just don't have enough time
> ATM to drive that, but would be happy to help with the VMA-locking
> parts.

If we have a VMA-lock GUP variant, I guess supporting the write part would also
be fairly easy? Not sure how performance-relevant that is, though.

-- 
Cheers,

David

