Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40DDDD38FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71E576B0005; Wed, 14 Jan 2026 12:21:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC046B0089; Wed, 14 Jan 2026 12:21:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CBA56B008A; Wed, 14 Jan 2026 12:21:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48E836B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:21:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8C8559690
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:21:15 +0000 (UTC)
X-FDA: 84331235310.14.CA06114
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF699140007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:21:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ddus0Bli;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768411274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DppfwVeNWCPmc+Z/D19y3ZxPHqX7M7yRhFW5MUBTB8s=;
	b=XW1W0/IZVT2kRIWYmzofTLje2SKeX81vZBddTzQYfMvNbC2TwendqiXAlN0Bkr1p83+JWR
	qr15jwY1K/CRDhDH3RMG0riyVMF1CHvLrVGChVVWtyWWkYEQ/0aYwGMsFo6+I5/oSSB1wg
	Hby75ND6ULdxgR3rNZM6WhBURFQtRPI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ddus0Bli;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768411274; a=rsa-sha256;
	cv=none;
	b=UoMm0LLt1GPm9rmSe2pOb/FbhDmwwtbe1IkH5c2vMTcUR1M24thvl1JTlcG3tcV6kwGUOx
	kDWd8izvT2wn+mCeIH/YiMBZ0WNIT6+tOCbYZhDjobRyWvq5tPYN1JH25uE6HGGUA8aHXL
	ngY9540Do1AJU4FDr/PMRPuw5rz/vNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02F5840A82;
	Wed, 14 Jan 2026 17:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F336BC4CEF7;
	Wed, 14 Jan 2026 17:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768411272;
	bh=nzZHWwI/LMcCcmwovIGTrQywTmeUJC5M4eStVFatUWI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ddus0Bli4Zql4tMJELVicNDcYCQwA5j8bHIzckIlNGhqxtkoYtb3cD/rrVfXl+4wO
	 ov+bB3FEg1iKRnXrBrYdDJ1tXqfu+vSIboxVdWdq1uBAsOYoPyJWubxV6habusbrtl
	 v1H5xoReHacVSVut5suv12jYP/6+90Ea/ze+2MLnGCrR8VEyfIXnXvgyJhI8jD1UPy
	 0ktvsMcTeZCCTQpyf7Y4Jv28YFcXQSm+AmuuS2IG3WcfrGFIitmM44HekyKqlJJisK
	 WWXuptVe8lkTEImyVzBWmo/fjSH9cE7BvxsNWGWVGzSaZBPMy9HSyipfj1FlNQ3kUD
	 gDOerTB+br6gg==
Message-ID: <9daa39e6-9653-45cc-8c00-abf5f3bae974@kernel.org>
Date: Wed, 14 Jan 2026 18:21:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, fvdl@google.com, joao.m.martins@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 muchun.song@linux.dev, osalvador@suse.de, raghavendra.kt@amd.com
References: <3d8398f1-0130-4d3b-ac54-d23877811747@kernel.org>
 <20260114113635.97621-1-lizhe.67@bytedance.com>
 <97413239-2bdc-456f-8511-65fb9f1e301c@kernel.org>
 <CAGudoHGb1w92gn89BBuMQOmvcVZkwvt8CK8hFtGg3xmHphmiEw@mail.gmail.com>
 <d9fbc00d-182b-4463-b718-73c2f0eef3a0@kernel.org>
 <1edfe356-8334-42d2-9d68-7c5bf21a01db@kernel.org>
 <CAGudoHEyxsPnJ2M+LWkPEb94L2Xp0iqH6O==hCUZE1woLzZB0Q@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <CAGudoHEyxsPnJ2M+LWkPEb94L2Xp0iqH6O==hCUZE1woLzZB0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s87cfakfcoyq8nn1kqt5dz1aeydui4gh
X-Rspamd-Queue-Id: EF699140007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768411273-939426
X-HE-Meta: U2FsdGVkX1/0Y2EYffTFqgrNbPu7jIDpTsnfLQ0s6ETBFWOII/FvJd9z1Ze4NNgGx0ctCOww7ElRH7gNWqN9NJSCca3Ssx6JIWumVtbl6jXNTdob8aVd68gLg0UOcX3r6G1EiBp28lFxOunx07MBe2aMBJIWG7nfcA5V+6tIs2MclxwozRewHdR+aJHq4e9HyMOanM+kjJsBi9Z1vPKxLiyRJgjIDsSePt+D553UE222v/sCQeVWYyJEVZptKCDfgKRwJxn02tCuQykocD3EVCGSVJAMB+uatGpQVV7wcBdtxaFYu+jkcpa4IUZ5FsUTZMD5b6e0IYnQ0yol+L5Xs8nCvPcIitbkRzoCikybVUVjZm/2Q4gaSf+N880XiV7nV2oznKOFsxjw7jSfa81dphx6jFSQHMzyyc1V+uKsUFzJRcO8IKK5GS8UlYZvI3E0aQlpm4Mtc59rdmQHNhoEfr+J+a6AvcqtdqzLgaoOw8QrM0ig6EfE+/QH5OSZJmZqNISv9NfuKLyDbrViO6qovDazvDnq8eBdyUGyhoXINv4douGA/6WalBG6qyG/hYJbdtYaDL/4qoYQCuaYeNqfAFYaVjMpFrqWJxDDMDBZQaJurArX4NmzVVMtGSD3OQGbgK7RqVK+cCmT79VsiJBzJTLl+uTuubCvcfbvQXvIAQ85vzpxVKhasKxcGw0Nf0Tm8iF5qSwM3xvxCXG6j4Qf2qndaX50YAVfw6R8V1XBAeGh17hlL59+XdVoix1s1hKkJqVAO7kzI9iEfyUaZ2ojEwXzGfXCm00z617/jnoaqBKCxsQm3S5LJTTq5vDu2D5T/VraZLHbMpkccBWDSmT22J68LPbVZWmDoIoM1ysyP3OZj2ixmBVSpgM3xolDvepdx6cl7ARW2CX8sb/FcSR9kHLEQM0hdDE8jAkzeeA5adAR8VIp14XA83Mq7cU4v7h+TNjsYsiFlBEmNGp8e0i
 xZknK/lp
 kQa6uLCwfXnuPfNYOuXm5ZIRRPL987SL/oyQmfuchsSjx8SMyYFZ1NMInlA90wB6DRhu+w2llrOp717Y8b3mvLm5KPaKuv4j/wmCapUu0czd3fCvr8PoaogKYRKWtExinsqNtzZlCn18f6ASD0bRsYfuJW6UrtkQAPMw0CkveyFofAhUaIDwseObExuKa7we6tfXUkBHF3ASQWqYMSXM52FJ13iqC+/4e5URB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> But again, I think the main motivation here is "increase application
>> startup", not optimize that the zeroing happens at specific points in
>> time during system operation (e.g., when idle etc).
>>
> 
> Framing this as "increase application startup" and merely shifting the
> overhead to shutdown seems like gaming the problem statement to me.
> The real problem is total real time spent on it while pages are
> needed.
> 
> Support for background zeroing can give you more usable pages provided
> it has the cpu + ram to do it. If it does not, you are in the worst
> case in the same spot as with zeroing on free.
> 
> Let's take a look at some examples.
> 
> Say there are no free huge pages and you kill a vm + start a new one.
> On top of that all CPUs are pegged as is. In this case total time is
> the same for "zero on free" as it is for background zeroing.

Right. If the pages get freed to immediately get allocated again, it 
doesn't really matter who does the freeing. There might be some details, 
of course.

> 
> Say the system is freshly booted and you start up a vm. There are no
> pre-zeroed pages available so it suffers at start time no matter what.
> However, with some support for background zeroing, the machinery could
> respond to demand and do it in parallel in some capacity, shortening
> the real time needed.

Just like for init_on_free, I would start with zeroing these pages 
during boot.

init_on_free assures that all pages in the buddy were zeroed out. Which 
greatly simplifies the implementation, because there is no need to track 
what was initialized and what was not.

It's a good question if initialization during that should be done in 
parallel, possibly asynchronously during boot. Reminds me a bit of 
deferred page initialization during boot. But that is rather an 
extension that could be added somewhat transparently on top later.

If ever required we could dynamically enable this setting for a running 
system. Whoever would enable it (flips the magic toggle) would zero out 
all hugetlb pages that are already in the hugetlb allocator as free, but 
not initialized yet.

But again, these are extensions on top of the basic design of having all 
free hugetlb folios be zeroed.

> 
> Say a little bit of real time passes and you start another vm. With
> merely zeroing on free there are still no pre-zeroed pages available
> so it again suffers the overhead. With background zeroing some of the
> that memory would be already sorted out, speeding up said startup.

The moment they end up in the hugetlb allocator as free folios they 
would have to get initialized.

Now, I am sure there are downsides to this approach (how to speedup 
process exit by parallelizing zeroing, if ever required)? But it sounds 
like being a bit ... simpler without user space changes required. In 
theory :)

-- 
Cheers

David

