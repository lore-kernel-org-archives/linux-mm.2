Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A6ACD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FD936B0005; Mon,  8 Jun 2026 17:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5056B0088; Mon,  8 Jun 2026 17:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3F86B008A; Mon,  8 Jun 2026 17:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA8C6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:52:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB9961A031C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:52:02 +0000 (UTC)
X-FDA: 84858093684.27.3F36400
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1008E140008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:52:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qg375DoF;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780955521;
	b=L50KGYGv+yoqOBzJGWdF1NTycOEkodQiXSUmlI6ir67vPrG5wXsAp7IUl/2Hn7dh+GNKOQ
	GV3UrasSwCIFjxB7xRKWPmpQAylLR+SKTwCaUEjgx0QICJfnhWh/j8Qi/CcBtMPzSRNTFU
	Bq93tPw+1B/SFf4lMl2/abA1JOvE//k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qg375DoF;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780955521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=saHarhH9VxFYDUSrZkblFzE37vMO//iE/VbgD3EThhw=;
	b=f1z4+IzEflyPgni6HdctXd9iKxauclnFkNNQfqGJqOLJMdocx+XaZ+to0GLGU7TRGLcC/Q
	rBxqyWLZLjoCAwL7MN7PK37OhhHyaXmEAWQywPpXQpwTB5HiLseeBzHz1g3CaRctj8i88C
	+1DCUIT/05+f6grcECrtgBPAWQdTY+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31E1A43AD0;
	Mon,  8 Jun 2026 21:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB4E1F00893;
	Mon,  8 Jun 2026 21:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780955520;
	bh=saHarhH9VxFYDUSrZkblFzE37vMO//iE/VbgD3EThhw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qg375DoFFhEadW+V8xhmo3ekB2jFKO7GMmLi7Gwez0nXKDA+A1Y9XOuuY+z3Xkbit
	 KqlO5YXh1q/2oeHbSmtXEigZXhU3d1opMtLY9BEKd1TepYdudwGXGUWydOXsKDqlW3
	 W259eVbUWBTuxXUTDxT/O5zdmBY3Cl6u5L8OdWJ2Zarwxq+WLg/6uEG4nW9hJWjQZ6
	 J2nx4byUBLafdaraV7qy4PM45xFm9x/X6g/2ojdx5MHLBzMNoeoaQ9WEbwvOoV/hbk
	 XGcAKv/Vpv/c7xnNSk3g6Jx5rSk3MaRqdKcn+NYfZhdwNAigezEDs8Cf9kkwIwuL6L
	 uu959XxiLYn3w==
Message-ID: <afb14c99-162c-4c36-b1ef-fe971678f6b9@kernel.org>
Date: Mon, 8 Jun 2026 23:51:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator for
 cache-friendly zeroing
To: Zi Yan <ziy@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer> <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
 <aicfERTP3H6AndOs@gourry-fedora-PF4VCD3F>
 <D1CF67EF-2CF1-45F8-9265-70A528C1CB01@nvidia.com>
 <20260608163257-mutt-send-email-mst@kernel.org>
 <BD0C8760-BC10-4BF0-9EE3-9B0DAF0D977A@nvidia.com>
 <20260608170348-mutt-send-email-mst@kernel.org>
 <DD2E08E8-1FD7-43E3-A2C8-B4435D3773D1@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DD2E08E8-1FD7-43E3-A2C8-B4435D3773D1@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1008E140008
X-Stat-Signature: yh5iikq8i6to5839h1kh4wdu3q3dkog7
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780955520-525559
X-HE-Meta: U2FsdGVkX19+YEGJ0xsblX62Qt8rCcMkrcOBgN9f8eAc3db9ukDCYn5QMrZuboLtcV3nlVGtKvZ9QwQmccZ/ez+mnssou3rZZ9LhgwAnjUIbPIXp/nTF5IHnKgSSo1+D8tTqRQ259uHAMp/QUBpF4mJiM4PqUQbp0yTX7156frjSsfZwbysBlxQtIEufwCuYOGQf0KWXV18dbUbv7wjo0h8bCfJ95OY0uhzxHDf9KIZzCRNX+VTgXhCQ6xLOV4TS/suLwy3t5Y8ZMaK6StJFrsD70fxAGaXJiW9oNlawzPyH/YMqs14tOOeVfE/j+AvzI218HnpQ11DwCmIBoGc0nhSDpH0uxU8T8m5H+FcWQ3rUrypQCjhJFwj5dhKmRzw29o/oJldqC6fuV5tEjVPYmUBhBjLr/d2Jz6oWvemv1lhY6nFikvarYbb6CVIp7c0+WE9R7OkJC7g2e/FGoqwtvV+fLUscAD7BaR3p1QEq3/B7zL+nnNj06/vcKSVXANp57gnHJB0WDBgfhSdTj5mji+53OWLUOux60kDNlxZ9zy3RRJ6S3eliWCIiek1tr5fgNfTiAYJ3If2sqWxZxMY38PbnppykxcFRpvl9Tff3OosOmte6PlolmshXyLDQ+mrBnXtlj9B71lv7qjEoAf757Mr2sgqaWgcTRpTnhw9tQkAWkVfx/JLB6wagoc1mPp7xzvuaWI9UP+VJXVOGklaxem3rBkgxHpSPDTAV+j8CJ+GDdnnB9BFERM36wdsum7/LQ2+OiIhf1rzNyy/C7x6+aCOSjQfN3iYR4U2v2nsNnWRUZ5VJeYMjGqUtIjpyeTSoxgN8mCDVeDlqaLIxV+AsBNv34+ELWxWR9GucCGXUHw9YpZD0kERVeF8XO6bgAO6bp6VHfRKr4SnN32JsvQUY2JUvDrMu8sxXLw/YFQLlqp7onQ+VNvwFQrOTBZZDstO7vJzVUVA0WqBJkCP6FIe
 AIaUtRx0
 uWV4iah761Y+5Mob6hnoxkZN6h0MoKEkhvrYdUQHKgzX9wvCYZjpDMSmy+1L62QTtsPMry+ZOOpOSD11nsXWK8dSx987BkA4XWvRzEBj6ves09FYlZ5mlxK0gF1L52IihIf/NzIvAWELaGOQBpDFXNX4DQnLDECk28yaNgufFc053cTOxLFZRdA0aSZhpQbHJk/tu2YT/HUdIYtXRkxfStwljQw24JdLVMVKBaOHvYAmBj/GdGli8LbrxgOtH03ZvDbvSKYunEOZdcas8MoRtpK7XgwALttc7hnKAwA7H6qLAQRyuyOUnZpLrTNwCgCP25V6l6kAX4Ez2yd6YUDqQZqX4KaubPq6AWHl1Hde0AuTQi4LCcSBspbNHY1V/7DRYAfyUWsOxIekAdgMjy4D2o45krFpK8hPC4ukaJyp+agAEiBqWl+bZYqjCIoDmsmKiTB1Jpk9x0eJ6yCcdLSQVv8HuSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 23:16, Zi Yan wrote:
> On 8 Jun 2026, at 17:04, Michael S. Tsirkin wrote:
> 
>> On Mon, Jun 08, 2026 at 04:40:15PM -0400, Zi Yan wrote:
>>>
>>>
>>> Change user_alloc_needs_zeroing() to only check address aliasing even
>>> if that can cause double zeroing for virtio.
>>>
>>> Best Regards,
>>> Yan, Zi
>>
>> Ah. I started with exactly that in v1/v2. It's a simple approach.

Simple, and hacky -> unmergable. I tried to push it into a different (no GFP
flags -> IMHO better) direction, but the patch set grew in complexity.

I kept telling to keep it simple (e.g., no folio_put optimization, no hugetlb
optimization, simple wrapper functions), and ideally we would have gotten a
better discussion with other folks here much earlier.

And I still do not consider providing an user address to selected interfaces
while centralizing zeroing a bad idea. The real question is how that could be
done in a cleaner way.

Or as Willy said, if we could move zeroing further out to callers, where they
can special-case. But given that KASAN and friends interact in their own way
with zeroing doesn't make that super straight forward as people might think.

>>
>> But mm maintainers said no, user_alloc_needs_zeroing is a hack and
>> I must not add to it.

I mean, I would hope that we can agree that our existing page/folio zeroing is a
mess and should not be extended by slapping more special casing on top?

Sure, we can try cleaning it up, but conceptually, zeroing happening at two
places in the callchain, with random optimizations to avoid double-zeroing is
just bad.

The fact that a vma_alloc_zeroed_movable_folio() that can be overridden by
architectures even exists makes me angry. user_alloc_needs_zeroing() is jsut the
tip of the ugly iceberg.

> 
> Got it. It sounds that you now get conflicting ideas. Maybe you should
> start a [DISCUSSION] thread that presents the high level idea of what
> you want to achieve and all the ideas you got from the reviews, so that
> people in this thread can have the big picture and come up a consensus
> before you send another version.
> 
> Thank you for patiently replying my comments, since those points
> apparently have been discussed in prior submissions.
> 

There was Willy's comment in RFC v3 [1], which had 19 patches. Unfortunately, he
no longer followed up to my initial push back and Michael's question later [2].

That would have probably been the right time to wait for more discussion.

RFC v4 had 22 patches with little replies.
v5 had 28 patches with little replies.
v6 had 30 patches with no replies.
v7 had 31 patches with little replies.
v8 had 37 patches with no replies.

[1] https://lore.kernel.org/lkml/aeu5P1bZW3yEH54t@casper.infradead.org/
[2] https://lore.kernel.org/lkml/20260426165330-mutt-send-email-mst@kernel.org/

-- 
Cheers,

David

