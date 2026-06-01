Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83805CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD31D6B0390; Mon,  1 Jun 2026 08:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A36316B0391; Mon,  1 Jun 2026 08:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5B46B0392; Mon,  1 Jun 2026 08:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77A486B0390
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:50:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A239A0668
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:50:28 +0000 (UTC)
X-FDA: 84831327336.01.C7CB902
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5DC0512000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:50:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRzWzLox;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780318226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiO5RIOjFIjhX80InovlNJiMWsaq00sNfFpnk2xz4IU=;
	b=g3FvjSkpQ9El2A3KEgYUwr4rYvDws4VrbdKhRn8IZq7Qh/VhwfTZ5BVu19+MKi/JvNZWeu
	8jqMvJrzMVhWnc3LCLF2pHAKKJlAJhFf50Ml+HyThJk/Hyzmi/3jVYiZgyZjifOzsZJv2o
	NYS74H86gpXdMUFvFAZEVejC/hQm2X4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRzWzLox;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780318226; a=rsa-sha256;
	cv=none;
	b=nl1gR98yOLNKmFyelToYdP3xiU0umKBJSEQgCGjcVGSKcWYoFqwGiRPVohYyVkUyZYy0n1
	TAJzKS8VdApTatkUD6sDGmFNH5X1Mmu5Jqm6l5hnG9eEbSzO5FXnRkYN4gWq3g9wrmAmsF
	uGdHcb/2AuDDpyTGZAb4mjacjNynWbg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C988D60018;
	Mon,  1 Jun 2026 12:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50B81F00893;
	Mon,  1 Jun 2026 12:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780318225;
	bh=NiO5RIOjFIjhX80InovlNJiMWsaq00sNfFpnk2xz4IU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iRzWzLoxQbdLcwQM9CdEweJdKhVuPzgfMWkbGxgQp03XaBS6MW1UO2dMb1zXTv8gf
	 Lc37QA55GKb4mm3qFObJW4zQf7Pz9qC7xV6ikZyYxHWeXlpofGZ8kKZRfyHkVJtovX
	 c2ZkuL1UYH+UTxuATU7dzZzfpA6IEKpFDWOB6hVdJaxSbAlTvcO0HpBEBh4M1IOiWK
	 xME9N7IGEufKWMYRgGc4BLlvBFLWjK3g3gy4mJixcfwwu9iob8jkrzwNnj/CAUTDZA
	 b3Bt2jxBtQkY2ceqVr80cx5EueZj8hSqFEYX6B+N8EfmU7ZAiX0ieACScg+Y4VnUDc
	 WH8lM0xfD2KIA==
Message-ID: <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
Date: Mon, 1 Jun 2026 14:50:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mark Brown <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
 <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
 <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
 <20260601113831.GA25535@lst.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260601113831.GA25535@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i7fdptubbg7q715xoi71458jm6wejkji
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5DC0512000F
X-HE-Tag: 1780318226-156293
X-HE-Meta: U2FsdGVkX19gPWijGMkFdg0IK1tOrJrsnVfuyOXZAcaNAfDB1lYmvj3DugVD9EE9yANLsMEe9zXlnMluiAGwIkrG+Z1E2DQgD2hX/OEqATFSMhohN0Pgkx2RkfbmcABNtPXs4PPdWUnX4gGNVxSMLj/3U27ZF6ra6bO41MjKungLr6Q0QkyYhV9E5sx2pZ1ukHdxAnEl3YtI5IrChG2kt4xrvEd6rsDHaB0XNTmkpe6RvUXlDeC+OiKMHqBgv6KCbyGQ9B24ZOREUHAAcce2yju1uPBONg7Pl/mZVxj4rJ+KA/bDtdE+jvQoFdCRc2vXDoF64VX9Qg5PWwiuqw70qvfhIiabEtCQFB/1opLKykDADlumdYCubdMl1mL+fym7W754IzCTC4RZ478TaFFeqYrmmRJSD4iv0AtxZik7sy477sw4njmZ+j+XoZooNTrVhwQsg0ds3EN17kiHEU7zU/RU0qROiRybYZSUu1Ie2za4EAXmuh9Hm8YVxX/eO7PUKs60n5LGXlp24rzlHn4ZKD46qiX2026Jp+CTdJedt43EJacinSD+XokOyfNmdTtkh3xABUWd+RuZC1M52ZpSKYrAIAmA7fqpe05gruDxWG4iMDLmIoxHt3+/vuKUO4dK4QnYyDvGixrYW4WHh4aOtqi4QjakcJaVESVHCFc4R6Dlc1HVkdllknst1RiZjHZvXhSFz5NahXx+YmYk4UCKhI8J2/QavaPiy2/AXJUe0pIxH6j6tN382J6HedUtoWBWJIYGMEXeTzldzqPQ2FvCZ2Su/8DG41GFpb13b1jwpb/DnQBphBA4iwkXPfsK22+EqJgyT1SrcxMZXLniE5f1bycoxmsSLlvDIQzHdqtJYWKWkarIdwj30JKOzW+q6/4H9ofzHc0n0rWSOaTwgWNkC0FNua2VcpxKRC5GhVxFrjaYiP/lUKOpd6l74AMYT7UpHBGFlwGADKJxT2QxbrF
 4D+VnegW
 GLEiS3QjoDyzI+ErK8HH35rHMP/fFqSKYkwDNmMVt+3Jm83zQAda02Td8vhTj6rMoTiG27a4G/DcwDsTX6uCIxa53mZ26LK44iwSfUUyDVh2MkGH9jqQHGs8xwIKutzB+dErv7WZz2jwsCd9YUzyqVoUqYtI3I7x256n5Jp1Ud2H9XptH2YUETyf9VeMS3tfdQsK8qnUaCMnKeyuCFuduO+c8TSTSOy/i55C4V5OjYsvIo3lRQl2AVW1C4hyjGvjrfzgqGXTT9U6RUmWca8IQcEtTEvkHk4vDFIceP+ph0h8Sl7RlCZuXu/z5JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 13:38, Christoph Hellwig wrote:
> On Mon, Jun 01, 2026 at 10:16:30AM +0200, Vlastimil Babka (SUSE) wrote:
>> > kmem_cache_alloc_bulk() returning 0 was considered a success in that case.
>> > 
>> > Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing the
>> > user sounds fine to me.
>> 
>> Would it be wrong if we just returned true for size of 0? Would something
>> else break?
> 
> I don't think it is wrong per se, but it feels like the wrong kind of
> API.  I.e. I don't think the MSM caller actually wants this, as they'd
> also do a zero-sized kvmalloc.

If p->count is 0 then indeed there's a zero-sized kvmalloc so p->pages ==
ZERO_SIZE_PTR but then nothing breaks because nothing tries to dereference it?

msm_iommu_pagetable_prealloc_cleanup() has a "if (p->count > 0)" branch so
it seems it's considered possible. But then the rest of the functions also
seems working fine, i.e. kmem_cache_free_bulk() of zero size does nothing,
kvfree() of ZERO_SIZE_PTR does nothing.

It seems to me kmem_cache_alloc_bulk() returning true for size == 0 fits
naturally in this world and is less likely to result in a gotcha?

