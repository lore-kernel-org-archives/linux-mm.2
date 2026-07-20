Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8F54C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 18:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7ABE6B0095; Mon, 20 Jul 2026 14:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2BB06B0096; Mon, 20 Jul 2026 14:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5716B0098; Mon, 20 Jul 2026 14:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5621F6B0095
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:35:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D0977401DD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:34:59 +0000 (UTC)
X-FDA: 85010006718.16.B034AB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 08CD9C0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:34:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZiqkYHDV;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784572498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12wl43ytAtcYJQLm/kZ5324fHnyuY88/G9Pd9OM4gBc=;
	b=yKTJ8oR/mDbgG/x4wXv6NHmWGDNhA497GDQXBaP2l9gCFuMl0huqMWw8u+gmsjjjRodS5y
	3mNWwbdFiCw2GQiGzbxVMC0bxi+r6TB8A96DGfw2KQR/KOUduZvcX2YxjcDtceoYqP0k+G
	yDV+lz+SPlpORbg/w6Old6KJcxZkzlM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784572498;
	b=6Uga9F4juranBhhbtAwSLziGIDw1wdN7ZANU7STnWqF5s//pgAsN1o8gvSOmrnDtNO3TnZ
	564EkKuI8zqyYDw2JcR1zHOzyrHVgYhAEz4WiYE0mKRt2WPTbD8vglkh5+OmEeNGLQt1tQ
	ojJlvuhwn3wM03BTpoTqvqrIRX6teN0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZiqkYHDV;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AEF442D74;
	Mon, 20 Jul 2026 18:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DD11F000E9;
	Mon, 20 Jul 2026 18:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784572496;
	bh=12wl43ytAtcYJQLm/kZ5324fHnyuY88/G9Pd9OM4gBc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZiqkYHDVP2qkeVDecGOc/AL68ExHIOa+N9wf6zpElcuP8BjzityNR3fXpRouD6Ehq
	 SdhdP31mB10JONwQr43IdwScZQ0O9KA+2TbSs4W6g+buFus1/MlM8ZHq2/r01JZlM9
	 x7sClSPxNJzz/QvGIHJW2TFFLwGz+7DH1e8xjftrXWo+THqHwQo/1NyW/TLiNO3Mob
	 /ybNNXpfQVmyYt1dGckJaW1LhAkeXWYiZSJRhtLaLkwXbgcehTU18uwEXF7aDRKC5U
	 VuVs7WZtYZqcDvudkDPLsNWDkBan+T70HzWEq+a/NRI3WoVrCkG9e7VBh1ExQsde45
	 +F1UqfaKQKX/g==
Message-ID: <51810eba-2a60-49f9-b879-7f806546e600@kernel.org>
Date: Mon, 20 Jul 2026 20:34:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: move internal mempolicy APIs to new internal
 header
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>,
 Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Jan Kara <jack@suse.cz>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>,
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>,
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev,
 loongarch@lists.linux.dev, linux-nfs@vger.kernel.org, netdev@vger.kernel.org
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
 <alkLSzQvzT9zJbY1@casper.infradead.org> <DK05KUIDJVLZ.61UIWOL0K3OT@linux.dev>
 <al5gQgnBCjNCSD_4@casper.infradead.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <al5gQgnBCjNCSD_4@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 08CD9C0003
X-Stat-Signature: bj6zgx3dhggj4e499ai84rqxu4e3dcf5
X-Rspam-User: 
X-HE-Tag: 1784572497-981289
X-HE-Meta: U2FsdGVkX18GynUcBm1IukWUvyn4zEFhF4CHqBYYLW2urh3p+Z+KVyQBAspaUpJKMHVRd8ETbbWmX+8LbzSVnAItO/C5McQUwR2/i88qIofjZcjjAdeNTIuwFjm8/2nEY14buiQWfXXvCbZQZBtpjQgge+dDu5ma1FDt5bpwWKEWJr/VJ663XnFCOEcn/pOtGSIwYMMo3VkUywwN9HXwhUyBHe21WY7kXwx21WfcIsiqg7Exk4RyxYc1ruQ4SvqM5pWeNfEBhbTNqc96HZZBYAHwcykDjI1FhQvamAmg626UoJKbEmBttnKpQiOpHqgzjvkgyMKfdAquAFXpDRfUsfkXa8oee0xWMahFmciWeRtSpYAiHIVogO2Nf0weos70kukmMIuO616LfqqQt0vQpLUIN2p/vqwu4EuV9ltZbjzwAqNm8pKLcyXqSUuQFRUQ8sv0TQrP+D6Das0u0mSE8LHK/yRpkyQQx3QNt5TZYNMZPOF4I2B3wM2HgUsWc024lSywBe/hpY4UX2EStdePygr+LOfl6tkllhEGj+6BL/lySIbMCmOBKCSdUYo3VXi1DdZg0YM+DUJ8xH9HCYnRap4H8v0JJZoOANJhFyy6rN1SJLY1JfV50H1zDYXKcsGyhnAMLYgQNGL/Cltt6Gz+aKI8fWMuWY1hEzzF2Dq5J7n6PN7dBS6NyTSDN/4CuDCWC1fiE3us39JlDhNn43/LqvYNWDBfJ2uPjts7+QqHoSojHo//CGvek11fkxucQamhkoOGZeQYrUZOpmY5re63I/G0Pe+VXk1bqZhAsxdKOC8OtezQxQgBJYA+dGqV6mZgL7oKVEBIqyLxfZcu65efiDKlLOwwdGbFr1qK+2fT6bAz8FPxvzzutilVXsTAHvCak4BW9t4BAfPHpta9NehZzeN3fA+IJjyk5fT0+6LO2cj3z4n0rl23Mzfh2KVAEObPKEyZ0TQUVoWrqpYtoL2
 yf1KitzP
 HRza7rXxTXJZNRiVSCF+6Bp7YzXc18mJlX+op8O138NzlsdpdiGqiza26/H3qdCJw5aTu+uWi5TqtkzrxVU1BSmGKsqKM/siOyXjiGtxnAr0Z2im8Bs/+c+g1y7/Fnbaxwq4apWZk/MAwMeptMdwHqJwa5C4K9KuFqjvgUTsgAfg9d334nFmxc92ZQq1OO2mJpqmWTt3L5nN3cPsbF9m5JAg7bk9NlBDNouG6BhEiKmDmlySW8V7jU66twojtEhlefdyiTixQcPfW+vFQgV+2o2MhWMAPJwqSwOQ937x3clfZToH/VFjnnUtIjd7q74hbuEZagCP1QLrKigwrPTkIpSpAflpWyfGUhgsMginWJfQNspY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 19:52, Matthew Wilcox wrote:
> On Thu, Jul 16, 2026 at 04:57:37PM +0000, Brendan Jackman wrote:
>> On Thu Jul 16, 2026 at 4:48 PM UTC, Matthew Wilcox wrote:
>> > On Thu, Jul 16, 2026 at 02:30:10PM +0000, Brendan Jackman wrote:
>> >> There are no external users for this surface, reduce the scope.
>> >> -struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
>> >> -		struct mempolicy *mpol, pgoff_t ilx, int nid);
>> >
>> > Hm.  So what we're saying is that allocations which respect mempolicy are
>> > only for core mm and not for, eg, device drivers to do.  Is that really
>> > what we want to say?  I don't think so, because that's inconsistent
>> > with having just widened __filemap_get_folio_mpol to allow guest_memfd
>> > to specify a mempolicy.

guest_memfd is practically mm internal though, IMHO.

>> Yeah I agree, mempolicy definitely seems like a "public concept".  All
>> I'm saying here is this specific function doesn't have any external
>> users so it doesn't need to be an external header. 
> 
> I don't think that should be the metric for moving things to internal.h.
> To me, internal.h is a signifier that these interfaces should only be
> used by the MM.  Not that "all current users are within the MM".

Perhaps. It can be also useful to move them outside only when someone asks.

>> ... With the ulterior motive that I want to add a new parameter to it
>> that actually _is_ mm-internal. Namely, alloc_flags, so I can add
>> ALLOC_UNMAPPED to implement AS_NO_DIRECT_MAP, i.e. the next iteration of
>> [0]. So basically this is
>> about trying to extend the allocator without creating a GFP flag.
> 
> Yeah.  I'm not sold on the whole alloc_flags thing, but I'm too busy to
> sit down and think it through properly to get involved in a proper
> argument about how it should work.

Well it's basically a workaround for limited gfp flags space. So we can
extend it without making that a cost for everybody, as long as those that
need the new functionality are limited.

> My entirely unresearched and ill-considered opinion is that the __GFP
> flags should _be_ the ALLOC flags.  We shoudn't be translating GFP flags
> into ALLOC flags that are what the allocator actually uses, the

It uses both.

> translation should be done at compile time.  So if GFP_KERNEL and

That would assume the gfp flags are also known at compile time, which is not
always the case.

> GFP_ATOMIC need to be composed of different flags with different

The flags we are adding/considering to add are not about GFP_KERNEL vs
GFP_ATOMIC context, however.

> semantics, then we should do that, not invent a different set of flags
> that special people can use for special purposes.

Yep it's ugly and pragmatic, as usual. At least it's not immortalized as an
UAPI, so we can deal with exploring in a wrong direction and fixing it later.

>> So I'm envisaging if an external user arises for it later, we'd slap two
>> underscores on the beginning of the internal one, (with the alloc_flags
>> arg), and then bring back the public one as a wrapper.
>> 
>> Does that make sense?
> 
> We have a long history of people just moving stuff around in patches
> without knowing what the intent was if it should be moved.

I guess this patch is not critical to the rest, if that's an issue.

