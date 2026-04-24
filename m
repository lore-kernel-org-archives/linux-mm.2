Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 266B5FED3E6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914B66B008C; Fri, 24 Apr 2026 14:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EA5A6B0092; Fri, 24 Apr 2026 14:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8004B6B0093; Fri, 24 Apr 2026 14:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0886B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:51:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 106068A43A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:51:41 +0000 (UTC)
X-FDA: 84694343202.05.1649295
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 22D274000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:51:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I73QB/Yo";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777056699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MORKsTImeIr4TjVhGEtdBn2NHX8NEyxGoKMvYtvEHs=;
	b=zFuWEw659/4DAcf+JN2gPUTmYfOONFU6fzOmE/PxP2gs0Zpr9HgMwhaLHPvYuSVLqHXj1S
	ljrmH0XrSdaNxvab/pQW8bS41l1ennijM1j7hu07Cg5yfn1l1xZNA0A33FDGqJPxntGvAH
	SqlUbjDRMoZmv12d0yl79VHSg52dgaA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I73QB/Yo";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777056699; a=rsa-sha256;
	cv=none;
	b=Qphu0+ChMeK7pL1WD+sKdpNYk1ZBcaNZrdrJ31yz38LL5xRSoA6UQ9sUF0Y+xKZFbiMYFq
	X0dMxeX9Ct/I9XXlgjDhWS1NCw0Delz/0KAQ9ee2CjvxBfNedde4i2V7gnbGj0mAfUt3pS
	Yq3npNIwFeU3M9uwpm+iZ/S+0qUVfsQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EAC4E41B6B;
	Fri, 24 Apr 2026 18:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EC2C19425;
	Fri, 24 Apr 2026 18:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777056697;
	bh=+gfjjzK2HjGlwyfcUBpjGFMM8VknhFJmUXv7rsRO1Tw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I73QB/YoKiHDxTJYDQAZJJqd6DpiWso0Fv34A29QLEdUDh4e/9DIMBxEx6bjkHaME
	 eSOcJ/kr8JheEFprhBsRAIYwP8ui81DS4Ec2MhWcAb3LTduz/Mw0tHH74Ypekkq31f
	 tWzmRP1hbVGBek3ZImYupzEnyAgFtJkj8scXdz6NeXJZg3Emc4SM0scKvVwyE5Yvn8
	 q6eVKd8YZlneyt/S+2klo8xFuk/s+iumOQMZw7M0YDjTBpq/xwQiLotDxKofUq2cRB
	 aBUac+XxaFCMgRvSsJ+dlJnmUsVyLaWjS4/TIqP4CQ5v7roQrj8+LPbMHANxYsjaaB
	 wpq3Yb5wx3O0g==
Message-ID: <b289b4f8-391b-4748-b8e6-0acb0b21b0c0@kernel.org>
Date: Fri, 24 Apr 2026 20:51:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
To: Matthew Wilcox <willy@infradead.org>, "Michael S. Tsirkin"
 <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 virtualization@lists.linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, linux-fsdevel@vger.kernel.org
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aeu5P1bZW3yEH54t@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aeu5P1bZW3yEH54t@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 22D274000B
X-Stat-Signature: cw9ah5cwjzgq8cfsx9519g6tftkdw8ex
X-HE-Tag: 1777056698-438829
X-HE-Meta: U2FsdGVkX18ZV1MognbuFF5mNPU11PxXqPp7mlVKF9FTCWkMs1vORMyQYxCyKXr6lPohbCSmjC7SqjCq3g7aUzVgUqjLxF75cNcB34uVXJkUJgP9JJLDum1QhacrkYZJ02R8PRNXZvX1s6WQ2UoaDLBgVIaIynyKb0rKtD+lReoTqvR68AEz5mXHJ3PVXc+h5Kmnn+rw7IhICzb9VyMlen/HPuGZANwfleGZibRUinQ65zfTGcqwPPvu4Nz6rTwENvqsC6EqFi0/OsxZbDi26kD+bsYznxVFM17hFkEt+S9PcxadhxztCTLpc6lSl/kiK3AKUDI/2aU6nav3KNdqYKzLY1XB6s9fH1uSR8ENPWwkuH4nVG4OozefYpeWT85WsrIswfUqstj9TxFyEvway18UMzBQID13ErkWoJfufxOeeNI7wtyGi0Znq7+Ubu3WJAIBqXbh2fP46CQl3BRU3eXQDvbcX1Y46IZ8OquSlLsFHpVYulPp96TYLymA/XdBkDJ7R50WHbexhnkCWqanzEQrHDQgTFZMxQEqSry4zkEP6eogn8dVyryz5rTxfVD65pZduU6Qfkci6aEwD1WLWEs8GIrMb8ucJOgKzEZiIn1LHDKtAtAJu4U4nrDkTIsk9p0lS2saa7vSit0bf3HgLQyz+yjyOnGib47X42Ej5cQpFTEnRmTPOLwf8LFBIx7LBteFireu98juQF3/W7jAX04/B5v2W6//e3l5SaMRNuYFnFZb47/WyIKU0JWvlvFvgUpN3UgBYHEN3AWeAe2xOhx9y5U6BRoiN23ojInsF67W37RujipW+y61dO4Pp8vxDDVgSOW0l2BHEcf7TnK3XgOCoh9hA5Kua6K+9kAzQSX5SrN8Osye5KAcWzph3NH5yVpFkchfO1HjthKX23c4+MuoNKZdmrDUscwzdy7kg6aWN2IYQn4utv9HJY4pEFZ0jNJV4TvOMGBSw6kelHz
 oRafPir4
 apNswa0xaLrz5KnZ16qWv86K100sQRgZQ+DmkfnvPxg78L4SYfm7oRZvAeyw9ByTslBbcieZ5dG1lFgF9AiH4y5ckBmRUHfkbNsy+90U1stzQ+8o6iXE9daF0c+TMqxzDORRWfFulyENGbZdeSwnlXTR1mPyySddEA7x9UpDT0xHUpD9ba7JYe9CjXLR1LtMaYvC0kUWfkLX6pndCMcDnKGtwI/LxDoM/P5MWhD0Hf8jsf+JWQL7Af8eUmBqSQyoYpyB3HzQGZ1HYkshmOwjzjIIyTDcwkVMkccwwuNfTSXdSA7p+gP176uI2qcNhCWzUzluVhI7XOyBNqxxhYHZEff0d6EsZ1lq+K76b2qxYUDagkter2BfKBc7CR8K3mz97TRT8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 20:41, Matthew Wilcox wrote:
> On Tue, Apr 21, 2026 at 06:01:10PM -0400, Michael S. Tsirkin wrote:
>> Thread a user virtual address from vma_alloc_folio() down through
>> the page allocator to post_alloc_hook().  This is plumbing preparation
>> for a subsequent patch that will use user_addr to call folio_zero_user()
>> for cache-friendly zeroing of user pages.
>>
>> The user_addr is stored in struct alloc_context and flows through:
>>   vma_alloc_folio -> folio_alloc_mpol -> __alloc_pages_mpol ->
>>   __alloc_frozen_pages -> get_page_from_freelist -> prep_new_page ->
>>   post_alloc_hook
> 
> I don't like this.  I think we should instead lift the zeroing from
> post_alloc_hook() to the callers of __alloc_frozen_pages().

I don't think so. In particular how zeroing optimizations are related to buddy
details (tag zeroing, kasan unpoisoning, init_on_alloc/init_on_free, now
pre-zeroing).

> 
> I don't understand why you want to remove the double-zeroing of memory
> when the user has asked for zero_on_alloc.  They asked for stupid things,
> let them bear the cost.

That's not how the world works :)


-- 
Cheers,

David

