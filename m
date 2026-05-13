Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD045CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4C96B0005; Wed, 13 May 2026 05:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45EC76B008A; Wed, 13 May 2026 05:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF6C6B008C; Wed, 13 May 2026 05:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB906B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:30:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5F5E1407D5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:30:36 +0000 (UTC)
X-FDA: 84761876472.18.1C7E120
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B25D5180008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:30:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+fkX5Hu;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778664634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xx9cpDkBlSzZWL5ZFWCPwAXlhpyLyKXAvyc1/ZTsqJc=;
	b=4VeX2h2Ggcpq1xB0Z1L21qd/BNqDQKrfXpb7Yw0bGtUk/hWbQmruK4tyb6j0CLYAyN9zaT
	bL8SAgUgPLb9+aQ1u6yRymiBbQT1VVzG3nIEQFfpTGIeb6AeaUS8RhTXpV8hhHle+rQiSU
	fV9Pvpsl9IHuymkC7MPf534848Gcd0A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+fkX5Hu;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778664634; a=rsa-sha256;
	cv=none;
	b=8dX5mPkz6lkYMYFPRrEooZdC+p5j3FXrg4zYjbCwgBqPsgyVlEUSBsHXF+Iksd23cwhoaw
	f8zyLATeQXtfmW8eT34FHbQmQbmPhcZugkKCsSKqNtz30N7Cx6sEU0X9ALSPRbeDD/7Mw9
	BmyEQMQMfQrBjJHjaQrfn8UTjimp/Ao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91D2F42D87;
	Wed, 13 May 2026 09:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BF4C2BCB8;
	Wed, 13 May 2026 09:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778664633;
	bh=jqpWcTvsVENQMjHz/cvx8R37HUe7D5wGYNm7WLuXu64=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=N+fkX5HuWU74GLq2SjvCq5yUEPpsyBsbrjcDBijXbdz/cVz7WKrvzEdJFKwbwx3Z4
	 s2OZyXU6O8g1bYpgFzglIUV2Q5Iqm7JMyKyhaHvUR3m1UaRDJNuattBlC9+w715ssT
	 ynt8/BLUKAphUvaEaTK/DYTdjdJafyP3oM1H+aSiVSvfv4d9HTZeJkjg5ShrMm6mrn
	 qJIZEFDOrNLN6y2AygIu8KkKNzdrxqiOQS+lg9Z+gp3tl08y/WVpYXGX5K8mScaLgm
	 NuZ3thX/xIu8ckkfxEG1Nw2/dQsVntoH/tkoXKCt9xcdw/u85fHnro2s3361TZoS5T
	 QBAAo75hHyYhw==
Message-ID: <683399e9-eb3c-4aeb-ace3-670aa43247ed@kernel.org>
Date: Wed, 13 May 2026 11:30:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 intel-xe@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
 <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
 <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
 <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
 <68705cec43ab43088327b21c9d9318036fb2a255.camel@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <68705cec43ab43088327b21c9d9318036fb2a255.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kdhtxu5pmwh5do1ue4xwkb67pw9ryfwf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B25D5180008
X-Rspam-User: 
X-HE-Tag: 1778664634-689909
X-HE-Meta: U2FsdGVkX1/WFl4re1/VEcki8GvNGaNZF+jjozs9OVKRMfWXxCn5+/2EuJT8+zC1M20eCJ6YcG2KnavdDpPt7B1/BbYaX+R4/lua0DjDOW4KCYbnHEkNXGTNm2JQaxHYQI74Dh4rgrhsB+rvu2G4LqM/Snu9tTxYfp59GlC2RXQ2DizUNEXMVwduTDyM3qhGUJ4Zcnv6aUoMJj9joWIVgAb5qEYaSR31UaOXzOTXTiYFCBTvDqOmtmkwJ70nDhY5f2mMYLnJmKEbGLyoloxwSNuBgqJeHExC8DFaml2Qf7dDXYCW4YMoFMXHVHNmHmbRLS0rzfkmktzAt2khilkOtwPdB2mpDZSSLMeAENitpRZPrQvZ0YyE46X3/RerFLiXaxXUsLhXg0WbCGm0PgzZuntVYCkjDvmiYPtKYgrQ6dC0MG22RhDF5kYjT+1RLP1YUz+LBKN0yyvNe2zk+zybFxzbuFBHmD7uso5L3srZCfRzZiTYhMx4rCrnQYh/9m4Ns7aG8A+dKAqG+9EDgxIdkbA4moSQU39Aec7XhjZJu2e6gb8JTU7ejPZ6dcQp8+uq1+TeWhca2BzlDRc6E2yfFzfPrZHtjHYPwZJgLBAQKJ3HcjkfkTtKfiNixrd0oB6vH1TjmVmrSofrfpvZSUgwzTAG4M8u1BxZCl/5+Nma+O9LMfTbJ4u/2XggR4rbq2XIghCy9/DaphUf59xAxFd12IbBe4ektxzVAUbcYBRJ6+Cn4Et60+3ETh5p+DrNgt77qvMG7lZjCzGHj2zwDqgX+hnYLC7aCU44qTS2Kj/Ow6VTFG7rQAvR9SBPk14QYG8ybIIZs6Lvj0KLPfWQzM55+BnXpDIs9XFbXc9AjvG+l1ZkrpIkaXDVaEiLSLxqWF5lPyp2u3mqejxHgfH0inbMhC1QncYT9bSt+SVz/eIc0B89lptNcsOdk5UpjHKzmHqEYR3EzTSgNnmMSmlztvZ
 IOERKviv
 iYeP7ihoeV2mrEgdMPKGCXXwSbHD5Ilt+XJWQcwgUBYYhBxWvaMdkuk4slcFZL8OQrPnHmoxrUjgvhIXsc/kZerUEvEPREfNr3uSGHkbL2Y99NDo+g0HooDLpSgMkqkhABcqEY7Oo6Y3yE9KZnZQtlQmtQZK/NF+ad6Aoi2zK5V3uzFU3QO0tmGhp9Jyzd1MJK+CDX2/JC+/QUtOJYw4HzJbhVo8gUxicmv56k0La8uASXmPFReOROMxoZmKSLFlO01AxjsvwrIc/ThN6tzl/zp72Dyw2CDBpVRnRKHMECJoXMIoJ4KkTqOcUyBMIYiHvYRRZVTYeTI26wRM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

>>
>> Yeah but that is the requirement the HW has.
>>
>> I mean we can keep torturing the buddy allocator to give us 2M pages,
>> but essentially we want to get away from those specialized solutions
>> and has more of the functionality necessary to driver the HW in the
>> common Linux memory management code because that prevents vendors
>> from re-implementing that stuff in their specific driver over and
>> over again.
> 
> For the code at hand, if we insert an order 10 folio shmem will split
> it at writeout time but spit out a warning (if enabled) at the same
> time. For this particular use-case, I think it might make sense for the
> drivers that use direct insertion to cap the page-allocator orders to
> THP size (2M).

I think this just points at the bigger problem: shmem should be allocating
folios, not someone else on shmem's behalf.

> 
>>
>> Regards,
>> Christian.
>>
>>> c) You pass folio + order, which is just the red flag that you are
>>> doing
>>>    something extremely dodgy.
>>>
>>>    You just cast something that is not a folio, and was not
>>> allocated to be a
>>>    folio to a folio through page_folio(page). That will stop
>>> working completely
>>>    in the future once we decouple struct page from struct folio.
>>>
>>>    If it's not a folio with a proper set order, you should be
>>> passing page +
>>>    order.
>>>
>>> d) We are once more open-coding creation of a folio, by hand-
>>> crafting it
>>>    ourselves.
>>>
>>>    We have folio_alloc() and friends for a reason. Where we, for
>>> example, do a
>>>    page_rmappable_folio().
>>>
>>>    I am pretty sure that you are missing a call to
>>> page_rmappable_folio(),
>>>    resulting in the large folios not getting
>>> folio_set_large_rmappable() set.
>>>
>>> e) undo_compound_page(). No words.
>>>
>>>
>>>
>>> *maybe* it would be a little less bad if you would just allocate a
>>> compound page
>>> in your driver and use page_rmappable_folio() in there.
> 
> OK, yes it sounds like a prereq for this is that the driver actually
> allocates compound pages. It might be that the TTM comment about *not*
> doing that is stale, but need to check.
> 
> Would it be acceptable to export a function from core mm to split an
> isolated folio?

The point is: an allocated page, including an allocated compound page, is
logically not a folio. We have work going on to decouple both concepts completely.

We do have functions to split folios. But it should be given a proper folio, not
something that can currently be cast to a folio.

> 
>>>
>>> That wouldn't change a) or b), though.
>>>
>>>
>>>
>>> Good question.
>>> We'd have to keep swapoff and all of that working. For example, in
>>> try_to_unuse(), we special-case shmem_unuse() to handle non-
>>> anonymous pages.
>>>
>>> But then, the whole swapcache operates on folios ... so I am not
>>> sure if there
>>> is a lot to be won by re-implementing what shmem already does?
>>>
> 
> Still that would alleviate a) and b), right? At least as long as we
> keep folio sizes within the swap cache limits?

Let's hear from Christian what would be required for DRM to use shmem natively.
Maybe there would be a possible solution to have a custom shmem-like intnal
thing that can better deal with large folios.

-- 
Cheers,

David

