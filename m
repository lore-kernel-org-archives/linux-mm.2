Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 325A0606D82C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYQ/jJ6O
Received: by kanga.kvack.org (Postfix)
	id 1633D6B00EF; Tue,  3 Nov 2026 12:04:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B4C6B05B1; Tue,  3 Nov 2026 12:04:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052796B05B2; Tue,  3 Nov 2026 12:04:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7A0D6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:04:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60499160497
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:04:09 +0000 (UTC)
X-FDA: 85394430618.24.A3B94FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 80F814000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:04:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VYQ/jJ6O";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793725447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEnfqIn1d5BmxBfGTOzDtpPMnd7ZSc057uWCU5mMqxc=;
	b=vxjpdqulNgkdxz+94pLN5JvLpgMLgFHCdx3/zT5S8qKnaYiWP4Yt6qhRe+lsj/X/LKjDtp
	AgfqXKwB2CdpbzmwDlCD/XnwTvPgfhb9znroCQ5K0wqVgtDT7dCXONwQ14/W/0X+yV8UEy
	f8gn46eVT8U4CtkxQwBVLBFhFSmN6Q4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VYQ/jJ6O";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793725447;
	b=8Mv1BrD+sXCjCk5xxNnZnYjfRUhMcZ+aqXvqyHMNz31oJCrsBdF+x6/ROUoy33/83Hgtox
	oMyRATGvMfW2Noh4gnV4MNi2QXP40QwmzxcNH7RmNVuJdcSbLlm1DUklJlFFQpuprlIdps
	Bt94SrW6nMxcuu4JdzCkRBgtQbsDZSY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E336760416;
	Tue,  3 Nov 2026 17:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C21D1F000C1;
	Tue,  3 Nov 2026 17:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793725446;
	bh=bEnfqIn1d5BmxBfGTOzDtpPMnd7ZSc057uWCU5mMqxc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VYQ/jJ6OVQ6W1XY81dONcqltFtpUGJBaOQM0hKv7qY0ir4Sh4jNP4dSLNxeb3Bn24
	 3Gv3g//UQ3kMbSr3HY4r+ndXng9fr0XXATyj1QaloIIbhkEzR5HTkmrP4Vcse8kpo0
	 RTB2wy5BbMTchXYcF7zXOxaO2izeHvjallY/LhVKnRgY4MCXgiOreh4DHikVTYMIH7
	 xIrQkanKaPV9qzCyiorwidm/pPyKmNuKQzY8w74z8WHp2+YI54x87sOYTLGwXlsu6W
	 4akm0drymwFocuJZNvWJsm6RYg4z+p1f++nr8BKhQBJ+tBiXfTe4G0FjPzTupcUcSS
	 h6TlpN/m9hUIg==
Message-ID: <e610aa21-4d35-4d9d-8754-bbfdec57a9a5@kernel.org>
Date: Tue, 3 Nov 2026 18:04:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm/gup: break out gup_fill_pages() helper
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Christoph Hellwig
 <hch@infradead.org>, linux-mm@kvack.org
References: <20261102193026.3860700-1-riel@surriel.com>
 <20261102193026.3860700-2-riel@surriel.com>
 <df9c504e-e62a-40c0-a513-e8b8c758dd57@kernel.org>
 <3a7d12b52a5de61277842f2cca0dd90d42728135.camel@surriel.com>
 <856ed0da-d806-4f2e-95e7-f276f2408e8d@kernel.org>
 <4ffa2c82c538c12447d48fee2532f67c35f7eab7.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4ffa2c82c538c12447d48fee2532f67c35f7eab7.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 80F814000C
X-Stat-Signature: on4jw9ctc3ary5npdgpuexnerhkw5fdo
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793725447-842798
X-HE-Meta: U2FsdGVkX18c9PMjI3LWs+HmYz+TOxpuNNU+u+YJuf1ITZUBOyMpoxYJQJOGOr0LiPE4gs88H1LqoeWhzXU3633woQ+1Z3kxsuqE+mhPvQFqiSSa3ndy5Mba+jq5AD85i8Z5GxSPG/X/kQkCYACbvJZzaeoXPuh2q+fklIh2A7WJu49r/psACBw+nQp+kae+cV05gbeEtcZKsXkf+BZTW/Bi1ggMinAwVOZ5Ixk7NAuXh/1ZLFZUYiYCZT+EZHOhuGVtsYEv/JFd1h14PM/kqdNkmkWuO+L1vsyb3aYKv4h8ACzY8mvTbI3w0+6fwzOxuw1dzb2C7Bm5HOLffPG3nLJMWMQLlnS+H0mauYrF5UtUw3BRwHNZD0ZSYYOC7dqC2jxYyLD/tq82FgPxXAAxp4o7cYZJYTu3ZWLN1lgvegZsQ7UCF7TeOWrL+R09e6v5Mnmff/7nc1NX9zQniWqIT/BIGZKB5j9mdTeCmjqn6V9wsMlUBnXVZARsMI8NE2xfEXVJzNBDtVEAbR4hragCxdueoYPYjFK7EMtl1CTDC152JfC+8Jk8Gfql3Krz3gJyhq/dFjUBnCeWOenRE0KL+NHmh5t1GjmG+IahOa17fW8hkmAaruGb4lz57m7h9Yks4DOv8BNAXQlKpU9wn5mNt7UV+1E44d9VHsRGLNTmx0pOJTS0RimOMZjS1O2KJn/d9aitMOIRes6aSbZpEgrLw6Smdn+YUftM+FCtKBG4nyG0Lb0diXyKq2Ibj5+IGgEUs99vbXa0f6esCzqqxl0AprejY7n1rtgU2auM806NS6Zw4GzQIqgwdwbhbqjDbrYYnyIWUjO05/prFJYvtA+jPbYt3FIutp4Jl79P3IgbQDmio7ptAAYiH5VlgLgPS2/HHvwxGK1QMDBhA9NDQyP9U17X0rgC/KiAA/ceXPRhx67KnVz1lkUU62vD5aAivjj0613o2qYu+iReqzBIZNb
 d7G0n19z
 jYPshvt9qA83xszBMgdp3SdDVVfDpiMa3k9roYODolj6ezgVaEeh7vu7Gx9PjgV5h+D+7j4sc5MS+CUDAK7yEf6wXjEaKKPNL3y/agaNjG4PqwXIYSIcJ0sOjvge/pr0VV024LajluZQxz0sudJC9tBtkfFCTJyzK7nYbZRgR7ff2aBWj7OQMe7QZZZynKy92x2VK8mz8oRG32PgQGqky/gnrwuNg3ogdrh5s5JTy8obzbPm2/N1BHGcyRquEiDKpMhpQlTN4Ho70/dGYYsEy+BS5+DGt36LjH9KfCPHfGZZ9225rayg39hgUMWoHFLmexVZFiP6DDOOXwac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 18:00, Rik van Riel wrote:
> On Tue, 2026-11-03 at 17:39 +0100, David Hildenbrand (Arm) wrote:
>> On 11/3/26 17:29, Rik van Riel wrote:
>>>
>>> faultin_page_range() and populate_vma_page_range
>>> both call the GUP code with a NULL pages pointer.
>>
>> That's not what I meant. I know that we have GUP users without
>> pages array.
>>
>> In the code change you are performing the check is not required.
>>
>> That's why there wasn't one in the first place.
> 
> It looks like 2 of the 3 callers of gup_fill_pages()
> check for pages existing. The other does not.
> 
> Should we just have the check in this one place, and
> not depend on the caller?
> 

That should be spelled out in the patch description.

The change as it stands in this patch looks useless :)

Although trying to fill something that doesn't exist is a bit weird.

But if it makes the calling code nicer, sure.

>>
>>
>>>
>>> However, now we have a situation where:
>>> 1) Only a few oddball callers of GUP need the dcache flush, and
>>> 2) Those need to do their OWN flush after a write, and
>>> 3) The dcache flush is not needed for most other GUP callers.
>>>
>>> We could do two different things here to solve the
>>> asymmetry.
>>>
>>> Either we could add dcache flushing to 
>>> unpin_user_pages_dirty_lock(), and make sure all
>>> the callers that need to call that function, or
>>> we could move the cache flushing to the GUP callers.
>>>
>>> Then we have KSM, which uses GUP, and which would like
>>> to see the latest page contents...
>>
>> It's all very inconsistent. And undocumented. And error prone.
>>
>> Could we have GUP-fast also flush the dcache for consistency or
>> must that only be called with the PT lock held?
> 
> I think we could, but it does not look like any of
> them need it.

Sure, but it makes the code more consistent and from a GUP PoV easier to understand.

> 
> Out of the 83 callers of gup_fast, many DMA into the
> page, and the drivers do their own flushing. Also,
> flushing before the DMA write doesn't help.
> 
> KVM, Infiniband, and others pin the pages, sometimes
> for longer periods of time, and either flush around 
> their reads and writes, or run only on architectures
> where we don't need to.
> 
> The others access the page through the user's own
> virtual address, which again does not require a
> dcache flush.
> 
> Only a small number of slow GUP callers need dcache
> flushes.
> 
> It may make more sense to move the cache flushes
> all the way out into __get_user_pages() and away
> from the follow_page_mask() call chain, so we can
> maybe merge more of the helper functions between
> slow GUP and fast GUP.

That's likely more work, can you look into that?


-- 
Cheers,

David

