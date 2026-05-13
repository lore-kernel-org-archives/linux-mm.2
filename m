Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46ABBCD4F25
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 19:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3016B0005; Wed, 13 May 2026 15:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53A96B0088; Wed, 13 May 2026 15:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9428D6B008A; Wed, 13 May 2026 15:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 827156B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:35:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FC841C061E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:35:57 +0000 (UTC)
X-FDA: 84763401954.27.D89A1E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6E7F416000C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:35:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qG7ffT5K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778700955; a=rsa-sha256;
	cv=none;
	b=lUm15fH0pFo88DAce3PmKAd5EhLBs8YPS4yYdR8t1KW9G6/rNcm10s++eqQmoc4uUit33K
	49Lid/4npJfbmoGpjkQzEHplHR3cgtJGlSaHN92YcBqQaIkYiso8LWtTP8NiEZbf1eZKEg
	Ru18mwYDU89/X+Vz4ErSPuGv1Ag2THA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qG7ffT5K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778700955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUJTXc0o0/1rDEC/4WIkxzmo3huvYPpEw4ISygRGWTI=;
	b=in4Nz2eYE6yku41JRVLTGNkwDJW1b8aqj8zqSwQnep7IeoUK9erPiUCjNAR1ObTTWx8dqj
	dxkN1hiRqOpuNc3BC5F+tdSnuGd/qk5ApuVvam1LmYdumys/iQ3UiYvwKN0QNv2cUEgFuD
	c3rNjQr+ieFQorRWkMPHDr4FKbiXNaE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB98F60052;
	Wed, 13 May 2026 19:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1BADC19425;
	Wed, 13 May 2026 19:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778700954;
	bh=NmlmhJchdEEPAxfALJc7ddzIb6+LDxvUj3dXafADxGk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qG7ffT5K6SA1jvg4rw3t0icFPpAUNdco6mG4Ox3ShD78+OZIdQdZ/Ch482XtwYYdm
	 v789yre3HMwccaFoAhdtnGabe8nS/fLIuG2HLU8u1Kdif7PCseLLY6FHXlqtRrQL69
	 ICdciY2O914HyapHzMXutQGW9j7Y31MMwIxjnueGRyQlDfDoNaisPrQbIbt7llzBtk
	 luP4XXYqPgvLcGeJ+pITZ9szEY2J9Art9M9VYGVFFabLgT7MRj8xVq/nsmwu4DlIdC
	 7wMyHAWuPHa7gWgBK4HB5J0hTHNsZIz53fHPIWGIh2cTcDKO3eWDnytPqUjRh1Jb4T
	 owpQ+SKDt+T3A==
Message-ID: <ea5063c9-9db1-4314-a8d0-c693de412b65@kernel.org>
Date: Wed, 13 May 2026 21:35:44 +0200
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
 <bbde0793-fd21-4a9c-b85d-f13d8b787c50@kernel.org>
 <1ce447ceea88bbe56c7d28654a51fc2856a7f986.camel@linux.intel.com>
 <65596f86-e6a3-48b0-aa3d-2e608964e29d@kernel.org>
 <c0b5b94dfb4d04a1319bfb110f326afd2c29d48b.camel@linux.intel.com>
 <d7cc273b-17a2-4b5f-af6a-0dc708c8cabf@kernel.org>
 <d5e310c7f4506ef373c705180b33b9d5b2645b1a.camel@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d5e310c7f4506ef373c705180b33b9d5b2645b1a.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tbo6cbh5ts4bee6xbc1eir3fkdwmdu9s
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E7F416000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1778700955-880971
X-HE-Meta: U2FsdGVkX1+VGs945FXra2qaSv7OowgiH3qz8Ynwv2yYXtGW7H/Qsx1toa1+kdpDUVW90pY7XnChZb9mJZmSJWzazMB3mdWOh30wftxRHpbPy8G8MgmX0ftYb57hsaqSLxzpMNLc6JuG3PWmFaNNPxjlNS4W7HRSZSE9Wj7frzskZ/y+0gLcG64nRQJRpJXjZ6KyIT5qEAykM8dkDsVKUmlrKLMEADf3HDJRURa7Xo/CpXq7Zj26BR6brJBJ6q4lRE6/7nG/SoG3aOYzIh05yzbDLR++FUbXZc2GSijpfI5gTa7g0RCxNBHFX0RcNLM7x3KZ7lqYUe7zduinClzy63WGNwjQux4wb6+76ApDsdt56Y3k5JfUIzonQxjoCZld/z2YssFvl0EdXQyMSDx2xDvkbm2rd4REQLS+OFNmCyXiNJPY/VH1PmrQTOGTxCttV9hsTiCVS4cfntmcSBz+eDnw3m9iphIdewpi8q3SPeICE+vPCgkkMuODudlaUbKokvTpFnJh6OJUWaaYNylCDeqisxxO9nokSOjB0D7/YYqeCxpcdW5QyzOBjnmXQII0HGhmjnPopkgX/Pccx5hdiXHDfCv21b5jgzs2t+luvnv9/lL0LOUReC+gj4qSW8zvXongGrINwVoubcyuAqhQni09N33sWip/IofE8Xi4OJ0SvZPfxw8Uk3VazjCHfREyuKzlfU8pTY7I3XiAkHnQ4Ev3a/G/19yQEnnP1rrHTsZWBAE6UYRPe1x41EN1HIDeFTallZmtZKikUW1FxmVPviiYj1/9Z/1l7LutSRXP8atB/aNHQ6V1c+xkYzw2v4lunmtTPCEo36G68yuYrmbYWs2EXFRMOQWDkwE5Qfa+T9Cg2DlUluuNbiKNiYvjIt7dL9I5OzDh+yFbkmb6f3ausEcRYfVW7oR/cw6HRa4jvnn58HYJWKSM3KH+N3RVEe+YRULG7pOYvDdzLv1HA4+
 MmeqxAzx
 k/fo3lgLsSfhcaGEPzTLmJ7LPo4ZzcUjcyuqW2LEYVx81kc453II8JeLwPEIujUj0HNBCjKH8qp3oR95VOjDmbc62kIfZISvo6jLbSfUE0YfGVq5e9/kPUfsgHvOgX7mAqvynI1BPeaFcViEes+/65VOKPF8m9MjnfVD8vIoCzsDF7rgmC44R0R0Zy98NYGIUoWH8BCMmQ43G8Rp0bi6/KvJFRT+rn+kjCuK/3SFe60N3vZPTs7N7bdnlag19Szhifolsx3WW9iLLr2GuWDmOGOKBhRP6rkag05sZ+GTtRBzhZH4JHJ0j8FIuxIepKDSMdqsMpr6NsRNLY7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 16:53, Thomas Hellström wrote:
> On Wed, 2026-05-13 at 13:36 +0200, David Hildenbrand (Arm) wrote:
>> On 5/13/26 12:37, Thomas Hellström wrote:
>>
>>
>>>
> [...]
>>> One alternative would be a single large sparse shmem object common
>>> for
>>> all DRM objects, with a range allocator, but that also got pretty
>>> ugly
>>> when I tried to implement that.
>>
>> Does not sound too crazy, though.
>>
>>>
> 
> Yeah, I stumbled on finding a reasonable idea to connect a shmem folio
> to the pool LRUs and the range allocator metadata.
> 
> Assuming a shmem folio is pinned using the memfd pinning interface,
> would folio->private be temporarily available?

I think shmem uses folio->private only when the folio is in the swapcache
(through folio->swap). So one has to protect against that.

So you're thinking of a model, where a shmem file is essentially fully "owned"
by a DRM object, and that owner could make use of folio->private as long as the
folio is prevented from getting swapped out? (e.g., longterm pinned etc)

-- 
Cheers,

David

