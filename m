Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD845F89256
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D8246B0088; Tue, 21 Apr 2026 06:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1889E6B0089; Tue, 21 Apr 2026 06:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0775E6B008A; Tue, 21 Apr 2026 06:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC1666B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:50:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9999D13C06A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:50:21 +0000 (UTC)
X-FDA: 84682243842.16.849A520
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B10C9C0008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:50:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7syxLuv;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776768619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThEfuODLcbzJ1wNxjiJBmYpBKNFG+AIDMMAagNA0Olw=;
	b=VwQwvt0rYZ03tk6Qk4jrqZjj2SpBiGd+sEkPvMLHEy+BpLVpRNhbH4lPoCQ5Q70ezCqALc
	H7vO24s4j5AW0z0zhfx62WyDMbI3ZUoMwQAXlal49Jy3CC+bFx6dL5xKyp9lS2IBO4EqDP
	mafyuzlcodTUidiaHsykKqHO2vtaWEY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7syxLuv;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776768619; a=rsa-sha256;
	cv=none;
	b=0MK5VVAC2QtCJgFAdYdGlvphd9H2J4IF455ZM2dY9s6fEefDrhHFadMcJoqqXqYMLRIsVk
	7wz8+6flTTUlkRNzAkiYpgx/7fDe0f8Dm1xNe8ZCb/ahhdDILjzbwWK/uKXn5GDc3i8jrG
	epA8wLFWMrz/ySMo3xz3CbbJPdHvCeY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2430443B52;
	Tue, 21 Apr 2026 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFAAC2BCB0;
	Tue, 21 Apr 2026 10:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776768617;
	bh=ZJ6FHm5JKqX31spxia8p0zhN0JlHXITc3WqiAM8CzoQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R7syxLuvYtg+m30JSYJXnsOqtYyyUFsjAtuggT5S7ijiJdRQgGiHCRtxHkDeo4+i2
	 eBXJTrLKkGQJP+lEo3rQPShlzLMdi90h+TYf4hmh85RT1ZhWOkgrRBnmUoz9JN03bX
	 fR2bUoBAb7vGU+OCnn8W9ZRekapy+83BN7Z1YRRea7iqIwGL8Ebz202ampcRIuptRI
	 yqXBA9j44doKaID8KO953JvyJ3+eFWhzRcrE/DHah+S9GOqdXETXJWmtM0EDmewqkn
	 Gb9InXGdSoSnVEVQLaS1sjGLI94kzzoRkkkkTvwVbdJJVNL1dskwLavwF3z3DX4kEI
	 30Hl/ro2xyqTQ==
Message-ID: <4bdc66f2-1469-4b91-9935-74c3d3ca0ed9@kernel.org>
Date: Tue, 21 Apr 2026 12:50:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/18] mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev
References: <cover.1776689093.git.mst@redhat.com>
 <c199e47d-b2fd-42f3-9e50-c47c848dc72f@kernel.org>
 <20260420192037-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260420192037-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j1r3ocncchp8negrgjkmrzhmhgz5h798
X-Rspamd-Queue-Id: B10C9C0008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776768619-318383
X-HE-Meta: U2FsdGVkX1/d1+B3OOV7OZeljX4K5A4qUw4dIWisYuG6j264n5KdcGrh29qDLE8KEeHynRnFczdz6Y7IKel3psOMneLlEH3ACXx55mOiG93mEgGtK1aMydz996nD5fLMtXbQT1K63jFhccRZj7qgkZ09LNo3aPzAMtXIJ1pLKbUVwae5HdZqVWGCptPx8oOY3qrJByMSEErarcy/mtdolewAFrNZiZuBbNK2C+rNeXWdC0cH5rWqvWlZYyI+8OfWbC0o5Pmg2F7lZF9qc/81BLgV2BZFXot12lXwue3BImN70nsUijmHaWUUDHOtRKVEzjJhTpD+zo6VOUZ08F0itidlqvL0Yd/LJcjnf3nXY/gYZgFSGNTbnts30U9FtoAN/ZaPsRudk1aJxeHcSm1hZfUxQI0Hd43YDtyivx5pZj8AVyhSzPf2EKuAruCFe1kgTqO5nipkx5Ax3Ae3ViMKBYcXe57P3IHbqXVUFAagvClbUgwPogxWUUQquuiGEc3Zk7jTYD7xS43B5aXDWeRvekDw7VcFoqtrRYG/6QV0pVavYd5UYNNDDS9rdNA0Tk7tXhnTMefX9a6vS4VwmRqRd3CrLDKmk/ZCT0+worHUptPCox7wkoyw/pbNsJ4Y5O9ZrvZECvCkRRM2H9txFNk+e7tIv5sWVOzPIjFETffD86Tg8VWf53YUfnPtyXl6jV4MiYt8JyEBuEnnJPNw2HnvxhpIyV1lnCh9uCvdNa4aafWKXK9SDv6CHrkfZGjheDF57gvl5yMY/9HFEvMO9DbLbhbch3YOb9QE3Uh6j5zq4x3eUivAdfQmJ/Q9tV9gB1lWIu8M6f+yoNDB5UGJQOyzm7I7E9fYZGspNtT2laJ6uqcOwcMqD9BKY3rzb6uF4hvbtsknPIsBBd1IVd7kv5N3rTo68/WSHIKBS+bODGiw2Qu+K5k0WMbDTUe48szfHq71rQFj6qErCOqqNMGLHEY
 Y+nqLFTB
 3v4SwjiTFcnTD6SSEstWeUPjOPNYis8W+pC7+YE/3m6DaWHgFWJgz2/lhgwLfHS2f8uvKTP2TypMtW4j9oImcr4/xt6VJ9J1cT76UbSvjajFO6A3Ad2/z20RFoE9Wv+fPuW4uD9VRT8+CbOvrnS6mX1yKnRKvXiwjGR8vCZ1AXOky5YoQNDpoJfM1m34pf54WT/wWfzy4SylewTQ4twATbof1z2nklf6PUkLWTLloqe1xzvtRuHvwfCAub0mZmBn3dl/PU3nRWf1nlrFZYnUp8XOl0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 01:33, Michael S. Tsirkin wrote:
> On Mon, Apr 20, 2026 at 08:20:57PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/20/26 14:51, Michael S. Tsirkin wrote:
>>>
>>
>> Hi!
>>
>>>
>>> v2 - this is an attempt to address David Hildenbrand's comments:
>>> overloading GFP and using page->private, support for
>>> balloon deflate.
>>>
>>> I hope this one is acceptable, API wise.
>>>
>>> I also went ahead and implemented an alternative approach
>>> that David suggested:
>>> using GFP_ZERO to zero userspace pages.
>>> The issue is simple: on some architectures, one has to know the
>>> userspace fault address in order to flush the cache.
>>>
>>> So, I had to propagate the fault address everywhere.
>>
>> As I said, that might not be necessary. vma_alloc_folio() is the
>> interface we mostly care about in that regard.
>>
> 
> I'm not sure I follow what "might not be necessary". We need a fault
> address so zeroing can be effective wrt cache. Since you asked that it's
> done deep in post alloc hook, the address has to propagate all over mm.

Let's look at who ends up using user_alloc_needs_zeroing() or
folio_zero_user()

3 folio_zero_user() users are hugetlb that might get pages from another
allocator. In particular, mm/memfd.c even passes 0 as it doesn't even
have an address.

I don't think we particularly care about speeding up hugetlb zeroing at
this point when we already don't even care about optimizing for
user_alloc_needs_zeroing(). But it could be reworked later to optimize
zeroing in a similar way when actually allocating a folio from the buddy.

Now, for callers we care more about:

* vma_alloc_anon_folio_pmd() calls
  vma_alloc_folio()+user_alloc_needs_zeroing()+folio_zero_user()
* alloc_anon_folio() calls
  vma_alloc_folio()+user_alloc_needs_zeroing()+folio_zero_user()
* vma_alloc_zeroed_movable_folio() calls
  vma_alloc_zeroed_movable_folio()+user_alloc_needs_zeroing()+
  clear_user_highpage().


Other vma_alloc_folio() users neither specify __GFP_ZERO not use
folio_zero_user(), as they will be overwriting the data either way. Like
KSM when unsharing, for example.

I am saying we move "user_alloc_needs_zeroing()+folio_zero_user()" into
vma_alloc_folio(), by teaching vma_alloc_folio() to respect __GFP_ZERO.

user_alloc_needs_zeroing() will effectively go away as the buddy will
just handle that.


All of the above is what you do on gfp_zero branch already, so I think
you understood what I meant regarding this interface.


Anybody in the tree that would be using another folio_alloc() (or page
allocator) interface with __GFP_ZERO *would already be broken on other
architectures* where we would actually require folio_zero_user(), as
they would already not be using folio_zero_user().

But we don't really need the user address in many cases, like when
allocating a folio for the pagecache where we don't even have an address.

> 
> 
>>> A lot of churn, and my concern is, if we miss even one
>>> place, silent, subtle data corruption will result and only
>>> on some arches (x86 will be fine).
>>
>> Which would *already* be the case of you use folio_alloc(GFP_ZERO)
>> instead of magical vma_alloc_folio() + folio_zero_user().
>>
>> I don't really see how vma_alloc_folio_hints() -- that also consumes the
>> address -- is any better in that regard?
> 
> By itself, it is not. But the issue is propagating the address from
> there all over mm. If we miss even one place - we get a subtle cache
> corruption on non x86.

Yes. Like someone not using folio_zero_user() as of today.

[...]

> 
>>>
>>> Still, you can view that approach here:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git gfp_zero
>>>
>>> David, if you still feel I should switch to that approach,
>>> let me know. Personally, I'd rather keep that as a separate
>>> project from this optimization.
>> I'd prefer if we extend vma_alloc_folio() to just handle GFP_ZERO for us.
> 
> Pls take a look at that tree then. What do you think of that approach?
> Better? 

I primarily wonder whether we can limit the impact in patch #1 by
focusing on the vma_alloc_folio() path only.

For example, I don't think converting all folio_alloc_mpol() users to
consume USER_ADDR_NONE at this point is really reasonable.

(a) Focus on vma_alloc_folio(), where we already have an address.

(b) To implement vma_alloc_folio() that way, we might need some internal
    interfaces that consume an address.

For example, instead of changing all callers of post_alloc_hook() to
pass USER_ADDR_NONE, can we make post_alloc_hook() a simple wrapper
around a variant that consumes an address.

So isn't there a way we can just keep the changes mostly to mm/page_alloc.c?


> 
> I also note that we need a flag for free in order to implement
> balloon deflate as you asked. Here, I reused the hints.

Yes, but on the allocation path we do have a flag: __GFP_ZERO.

-- 
Cheers,

David

