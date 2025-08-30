Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A9ECA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 04:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A3356B0005; Sat, 30 Aug 2025 00:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453CF6B002F; Sat, 30 Aug 2025 00:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342DC6B0031; Sat, 30 Aug 2025 00:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B71A6B0005
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 00:05:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B02391A0A31
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:05:22 +0000 (UTC)
X-FDA: 83832084084.30.827ED40
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf06.hostedemail.com (Postfix) with ESMTP id DBC11180007
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:05:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756526721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6gyMoevd4cnRUfmne5cSJbJQJHEe5Ose/0+1TQx6ETY=;
	b=xmJtNBTwzrY1w1ZEYUkPe4G3g97UYRDaX5OvIpBkUyNOIIBOxBAWq147fTs5yvbm8kH+Hd
	YQlveicaHxTVbUiNXsSd6Jy1rr5H7FEArQabKlrkakSi+QKQhK7wm88oAfoNwLZdeQnTud
	WrZlzmObJarDjwej7cSAp/W53FVBUiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756526721; a=rsa-sha256;
	cv=none;
	b=U6e+ah9Af6vVSh6i8eQ4aW+0/xNFJHIIrasCUuDG05TlBRCiHOP089W4g6jfe6SVS3gQxa
	nsTTUlrLYkQ9tvJ0HckAfq3H9TlnRO6B+tSltS18y2anEebaQDSvtVtTmN3dG+gWL5zzDn
	Z10T8mfYKHvN2XLwn5SPkwmpCkYymqQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf06.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 30 Aug 2025 13:05:16 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 30 Aug 2025 13:05:16 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aLJ4fEWo7V9Xsz15@yjaykim-PowerEdge-T330>
References: <aKROKZ9+z2oGUJ7K@yjaykim-PowerEdge-T330>
 <CAF8kJuPUouN4c6V-CaG7_WQUAvRxBg02WRxsMtL56_YTdTh1Jg@mail.gmail.com>
 <aKXeLCr9DgQ2YfCq@yjaykim-PowerEdge-T330>
 <CAF8kJuM4f2W6w29VcHY5mgXVMYmTF4yORKaFky6bCjS1xRek9Q@mail.gmail.com>
 <aKgD7nZy7U+rHt9X@yjaykim-PowerEdge-T330>
 <CAF8kJuMb5i6GuD_-XWtHPYnu-8dQ0W51_KqUk60DccqbKjNq6w@mail.gmail.com>
 <aKsAES4cXWbDG1xn@yjaykim-PowerEdge-T330>
 <CACePvbV=OuxGTqoZvgwkx9D-1CycbDv7iQdKhqH1i2e8rTq9OQ@mail.gmail.com>
 <aK2vIdU0szcu7smP@yjaykim-PowerEdge-T330>
 <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DBC11180007
X-Stat-Signature: wsox7n81d8je8xuzphyesf8fcdzdcodw
X-HE-Tag: 1756526719-357277
X-HE-Meta: U2FsdGVkX1+MhysdlpKtPpn8LfPxuIz/B0Ama+WzbR5tLt5UbXqOEJRAxXKb4YVIxRyqQZgqVS6SERbFkSgsHeKRZnTn7XvkwZOQxzjYYWQ/jJANzZLppgVhCMfPD5bP7VUTnFtws/ANXCTXzApM7SD6by8X7RSGWVvTdTLeJ8BhoOCLf+66+uJIkBFs4x0wX6Zk0UiV2QzCx4BIPEaqdTNnYlrhM5QnWVFUM8H8jygrjQ6HAO8uq51+x0pEFdvtlaRWiIsQYmCRqmOKaAKL5arkGPhq508AGIe5+tQIenqN2oe/JK12FM9Wj9qSXzdp5nim4JthSvE170mEGIG9nrLbEboGks2v7fTzu2hQZEtkwAvw/5ZahFlt8rT2tcKGM/oTSaSwOj0862xot+4X2B11qbF9u36jVObCzTVaLscfqK7FzUHQvDoxC8ZfK4/eRH9GI7zViMnn3sDG4qlakjL1CQBX7GUX/gsP7ypVdmC5I2mIi2CbHl9VTHdy1dMw+PMsOWAgB0IaqvSkGA4m4VLJentK9kaVaI/9P1nZMpsWOHZh4X4B/ibBh9NY5PWaGa5z+S+Ka11RWCZU+BbIV0HRCGpPTWJWwCwv65sXMvQnR0u3TdGyEItPrhtmbHDbeTdgaYfZATAzln1lvpeSCh1gtW1gdMj/mWX8mXvqjBUrkAoZtERLV7h3+6rrlpJxDGarQiMzstfGplPrQbxyIZ+R1CHS969fO7EF9+82S62eYbOiSBYsVatSiAxVLCARoWJg8fuEW77wikLeSlS54M036FejDF6mK1+zGJhfKhmBka70OiFHTb1MEWRZAw9guoEcDHkAl/qV1cePpnXQy/23b93i3XNHSdSHTQe/PPRsQWC0Tli+tDQ5tslK2PJi+JbWdjWP/SOu/TvlUklQoqrsarvXtGymBO7VOgUk3lRDjQOk6I8azLtZHVg9zOi1y94LBRTCBnXqSJH8WXN
 Tfam7sec
 lYFQWdga0RBHeqBMQ1PiCcap/zluGCqw+89Cl42uFpew8U1zfa0gl8pp9w71u6Nsa8AlyRAZG4DZifJkTgUDGYMyX8qpqA0Ol7CNAo5v3z2ZjCx5PBr+LKmCsecP8XlMvuZlTJtA9FCUm877kL+rp+43wK2/77geZOB/a3feYdIqutzSatZq4U3jZD0k0HNFVdg+E6MWpHQqAFy/Hf8zOWSHCM+/13v9SK4UOzDmbCBRbl5dOAfUO2KZl4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chris,

Thanks for the detailed feedback, and sorry for the late reply.

> I think you touch on a very important question that might trigger a
> big design change. Do we want to have a per tier swap.max? It will
> specify not only whether this cgroup will enroll into this tier or
> not. It also controls how much swap it allows to do in this cgroup.
> The swap.max will follow the straight contain relationship. I would
> need to think more about the relationship between swap.max and
> swap.tiers. Initial intuition is that, we might end up with both per
> tier swap.max, which control resource limit, it has subset contain
> relationship. At the same time the swap.tiers which control QoS, it
> does not follow the subset contained.
>
> Need more sleep on that.

When I first ideated on this, I also considered per-device max values,
with 0 meaning exclusion, to implement cases like a cgroup using only
network swap. At that time the idea was to give each device its own
counter, so setting it to 0 would imply exclusion. But this approach
would effectively require maintaining per-device page counters similar
to the existing swap.max implementation, and the relationship between
these per-device counters and the global swap.max would need to be
carefully defined. That made the design significantly heavier than the
functionality I was aiming for, so I decided to drop it. I read your
point more as a QoS extension, and I see it as complementary rather
than a counter argument.

> First of all, sorry about the pedantic, it should be "swap.tiers" just
> to be consistent with the rest of the discussion.
> Secondly, I just view names as an alias of the number. 1-3 is hard to
> read what you want.
> If we allow name as the alias, we can also do:
> echo zram-hdd > memory.swap.tieres
>
> It is exactly the same thing but much more readable.
>
> >    cg1/cg2: 2-4,6  > memory.swap.tie (ssd,hdd,network device, somedevice 2, assuming non-subset is allowed)
>
> echo ssd-network_device,some_device2 > memory.swap.tiers
>
> See, same thing but much more readable what is your intention.
>
> BTW, we should disallow space in tier names.

Ack—those spaces were only in my example; the implementation will reject
spaces in tier names.

I like the interface format you proposed, and I’ll move forward with an
initial implementation using the name-based tier approach, dropping
the numeric format.

> We do want to think about swap.tiers vs per tier swap.max. One idea
> just brainstorming is that we can have an array of
> "swap.<tiername>.max".
> It is likely we need to have both kinds of interface. Because
> "swap.<tiername>.max" specifies the inclusive child limit.
> "swap.tiers" specifies this C group swap usage QoS. I might not use
> hdd in this cgroup A, but the child cgroup B does. So A's hdd max
> can't be zero.
>
> The other idea is to specify a percentage for each tier of the
> swap.max in "swap.tiers.max": zram:30  sdd:70
> That means zram max is "swap.max * 30%"   and ssd max is "swap.max *
> 70%". The number does not need to add up to 100, but can't be bigger
> than 100.
> The sum can be bigger than 100.
>
> Need more sleep on it.

I don’t have additional ideas beyond what you suggested at now. Since swap.max
is defined in terms of quantity, my intuition is that tier.max should
probably also be quantity-based, not percentage. As I mentioned earlier,
I had also considered per-device max in the early RFC stage. The design
was to introduce per-device counters, but that added substantial overhead
and complexity, especially in reconciling them with the global swap.max
semantics. For that reason I abandoned the idea, though I agree your
suggestion makes sense in the context of QoS extension.

At this point I feel the main directions are aligned, so I’ll proceed
with an initial patch version. My current summary is:

1. Global interface to group swap priority ranges into tiers by name
   (/sys/kernel/mm/swap/swaptier).
2. Slow path allocation uses bitmask skipping; fast path uses per-cpu
   tier cluster caches.
3. Cgroup interface format modeled after cpuset.
4. No inheritance between parent and child cgroup as a perspective of QoS
5. Runtime modification of tier settings allowed.
6. Keep extensibility and broader use cases in mind.

And some open points for further thought:

1. NUMA autobind
   - Forbid tier if NUMA priorities exist, and vice versa?
   - Should we create a dedicated NUMA tier?
   - Other options?
2. swap.tier.max
   - percentage vs quantity, and clear use cases.
  -  sketch concrete real-world scenarios to clarify usage 
3. Possible future extensions to VMA-based tier usage.
4. Arbitrary ordering
   - Do we really need it?
   - If so, maybe provide a separate cgroup interface to reorder tiers.

Best Regards
Youngjun Park

