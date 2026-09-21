Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0157DC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F21C96B00E2; Mon, 21 Sep 2026 06:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9616B00E3; Mon, 21 Sep 2026 06:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E106F6B00E4; Mon, 21 Sep 2026 06:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEBED6B00E2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:23:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A35EA1878
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:23:22 +0000 (UTC)
X-FDA: 85237382244.05.3313BF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A44421C0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:23:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XtCjeKbB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789986200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cuztroE9B009/ngScnA4v/aPOnVqhUZhmfly2op/ylw=;
	b=ZNqRkf/kEKUP7Tu/nVeHqd18VRISh8yAk+TYgpj4yY0hoQODAuebfw6Nd1PIu5Q9B3t4v7
	oc/1VXn51afVKDyReIT4jlVxdTx4xsLSKZ3rWFXMy9Cd5wh2yj0HmpHeFSYJYuCeruVZuy
	WdsSxXoXEjhpxVYi/QmKA3cuiELAhvs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789986200;
	b=r2w04gq7BAnvyEhdjsabIvAazn4DvuzMrl5g9LX3CscOn8UHw/EET1okf165S1XaFtXh3M
	MK4QMBuDmpaMvI8FropBq8+0QIpMOC/5RIGR5O2j9nnP3uwT1iKKQkUvFzfWBo1m6ArdAz
	c2JQyheMuyd5IQr69lBtXqoy4xB9c9c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XtCjeKbB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E40ED600C8;
	Mon, 21 Sep 2026 10:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258201F000FF;
	Mon, 21 Sep 2026 10:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789986199;
	bh=cuztroE9B009/ngScnA4v/aPOnVqhUZhmfly2op/ylw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XtCjeKbBbwdrOYSNwSZpOoahoJnrEqa82MCYqCKqmKloTIf0sZp4TYx7Gx2rh1ZSt
	 ma7eDffRa0uxhKbkNhmG3howbtf2YPKu7IcfbYYVfeSqv8wEtqzLggeLV4OJO/a6V8
	 R0aUALt1x0gLNMc/w3uRLkHuNlkHqHeascMzgatTM/8o1PXtIi2cnhyCCl4G5t9X34
	 PBvRsCPyRUo3/ydRByO3SK28M4Cll3JrqkQ3WI6H8Hg1+GYRtyDGfqYIVKMXy6Kwcs
	 goLwr3uzs2HJ2sfMHzpss3xEK/47dBJ4z1OGTYmNFVN3oEFagD+Z6TQacB/nVPrpGZ
	 qNcFMAh+gqVmw==
Message-ID: <46914256-508a-4737-86b9-a43be7e628a7@kernel.org>
Date: Mon, 21 Sep 2026 12:23:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: usama.arif@linux.dev, hannes@cmpxchg.org, baohua@kernel.org,
 alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260916224437.1164512-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yhf7jt5yga9dhbqobirj5ibpwnknofmc
X-Rspam-User: 
X-Rspamd-Queue-Id: A44421C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789986200-384314
X-HE-Meta: U2FsdGVkX18v1mun3n6D3pGUqguVEoq2H/6HAVVcwzDXGdZqcs65nYyOcVQ8sFX0wWY0CH3Y+8qdw3/EbOheWdZINF8urxF7yMArT26q4rSFPPbIIqNuiAOt1Dxyna4gd6bUtWO0NZrA9lLb3BL6QGBvkMfd51U5Z4O5zTyWiYvtIKYKX4SkEnWJ6m1+zmXvBgb4ni9ChjKIS/k5CT/FEpDl3qpQ9qUO6LrUoLALoqDmrs1eEv23J9HRIXePNe5vX26RC6Jbq7mJNoQNp07+XML6cURf4FxpDp6+1QU38mKuwcxbjHoBsrfMa0Lt0oWlogwl/ZLR9Z7cpGfwdeym0/sn3bwPeXWiKotfizINXqfJjt43ms4b6NpaBJu7i3PDhHvvcwGvZRWHsC00w8h0j1Es6TjrWIsZb40fjRPazwopHDrYECgL/RqgWgVzt+fGp2GaUz4EQVCCwMhewJ+gpVhVi5T5iHXn5D1Hpq4yp2OMFdUySuz8O0qimCPoRmVJLbRrlY5XsLFOQ6MbBw91HsIgakmIV3rBhdniuPms07jMzeiTnRs3LAQIQMy2sGmwMTTx2sitZK8IOS8S88aK6vvM6se5tK1Cv2790QfMbLwLJMXKSp7Dp97uJolK64lLo2eO7k39oduZ7zftMf45yVH6lX6F6PbviKQ/e8ms3z8ZnZ1aKndivamm84/6wMAuPu+B6RaKkYr4bMoTDjQqhlDeGZf7dc4u4YgLUxccv6eD81wzIYT30c9sfOZjLMRFd2hcwxPJsu1bz6ChiiZVAfNGZS42VceoeUqkTNXXalozNI65afln11z0UjYqBtOYECajPbvqR3YBL6rK3fOhHIMAC35HCePFLdNpqMumh3920hxnndC8rYv3nX1T2j/aPJBX8GiNl2FJihxXK1EyTPr3qgEIAZC7fSPCVYDVAVxWhGmg1ze/du7+c+/zBzVYdCBX1s0L/n7pSfWOba2
 f68J5ycx
 E2JGARPg5rbXAhKIbIxNE9gtKhgc7oMpzLlUd6b5v88KqQaJPR7V+PEbJ8UJwe00jV65C0DzC3rzgwoURhaH3SUo1wge43imkSOfnczfM8/LXRe2doIIxrqpUHcYKAFNmZTCFoGGiOkolLl7ESCIZ1WZ7SQiuYJ/Pmp+Ay+nTs4Lm1bCyEWNiL047Emzb7Sa0kwbQZRC6aCP4KZR4J6dQK6S0ib2a6YGWPI3vf7keBn/OYZ4L+8OcOG+7sAyLTu9xWD0b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 00:44, Joanne Koong wrote:
> PMD-sized THPs that are mostly zero-filled are reclaimed under memory
> pressure by the deferred split shrinker, but this is not done for mTHP
> folios. At Meta we would like to deploy 2M THP=always on arm64 with 64k
> base pages, as 2M provides the contpte benefits while the PMD size there
> (512M) is too big to use. However, 2M THP=always causes memory regressions
> unless the unused portions of those folios can be broken down and
> reclaimed.
> 
> v1 did two things. It scaled khugepaged_max_ptes_none down per folio order and
> it queued every anonymous mTHP folio. David objected to the scaling since
> collapse had already rejected proportional scaling as either letting the memory
> footprint creep or being confusing to reason about. David and Barry separately
> objected to the queuing, which adds list_lru lock contention on every anonymous
> fault, and hurts lower-order use cases such as Android's order-2-only
> configuration. Johannes suggested keeping khugepaged_max_ptes_none absolute and
> simply not queuing folios that could never exceed it, which addresses both.
> 
> Read as an absolute count, khugepaged_max_ptes_none also implies the
> smallest folio that takes part in underused splitting. A 2M folio on 64k
> base pages is 32 pages, so the knob has to be set below 32 for those to
> be queued at all, and any folio with no more pages than the value stays off
> the queue entirely.
> 
> Patch 1 makes thp_underused() folio-size aware. Today it only ever sees
> PMD-sized folios, so it assumes HPAGE_PMD_NR pages throughout. Patch 3
> breaks that assumption, so patch 1 generalizes it first. No functional
> changes are introduced.
> 
> Patch 2 keeps folios that can never be found underused off the deferred
> split queue, as suggested by Johannes. This changes/optimizes existing
> behavior. With the default khugepaged/max_ptes_none, PMD folios are queued
> today and then dropped again by the first scan without ever having been
> splittable. After this patch they are not queued at all.

I think we discussed queuing folios once the value changes and you would
actually be able to split some. Was there a good reason why that idea was dropped?

-- 
Cheers,

David

