Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73028C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536756B0088; Wed, 23 Sep 2026 11:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7B26B008A; Wed, 23 Sep 2026 11:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FDB76B008C; Wed, 23 Sep 2026 11:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22B336B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:11:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 979A41A0789
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:11:54 +0000 (UTC)
X-FDA: 85245366948.15.8312B11
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6E02A160014
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:11:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bOu4yUj0;
	spf=pass (imf08.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790176312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2btTVDYltsgCYavYwVuiOIHeKZyL8Gt5tbLOPUFFJ0=;
	b=LrCMsOWInPR+8yTdgqQ/vuRPdKRPKJ9JZgQBg536gB8/iGgZw6VrIDKMzMCZApVltSAg3/
	LfXcoosevZhPcwYdRkk9Hhtkh+K/VAjTpLOodyeo41zavBZSt43XSrFln1zJz7SqSSv+kS
	HBwCSncpPxNBImyRUxCsc/85B+idtHc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790176312;
	b=NAMVMUgA/wGuSAWRqYK8EKH/ifIGYv9+ci6P0bdpUgE9/4mw3E6I63B/AhJAgRqMRMkYOG
	RObyJb38lAwMN1/9wXWLfM0v936xmtiXcNMXzLUx8O3rGh2PDkw60j0Qez/iTGqTvs++Dn
	HTuFw1cBTb/7arsvldj87ISTpwo1CZE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bOu4yUj0;
	spf=pass (imf08.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8C911A32;
	Wed, 23 Sep 2026 08:11:47 -0700 (PDT)
Received: from [192.168.4.158] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BF113F86F;
	Wed, 23 Sep 2026 08:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790176311; bh=0ZF92qlGhBT9ghFKBAdomT/d7B9mUVR6sojJo9EGm84=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bOu4yUj0Q/cyKCDPQmnlZSSfBzN2YZFcQ+BYeXIGsn3j2NxCyoWazWfOEchSwBK6z
	 p7crav7v88lmt9BsVnUEIn7iRY066xMU2EuJK+FPQ0L1X2J3RaUrkxZaBNckO20vz+
	 0TW+qGgaK5iTEA87RU/L+SeG35VjqNjOB4ZTOJt0=
Message-ID: <86fb3438-8028-49c5-9b4e-2a0970efb91d@arm.com>
Date: Wed, 23 Sep 2026 16:11:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Content-Language: en-GB
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
 Marc Zyngier <maz@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>, Thomas Gleixner <tglx@kernel.org>,
 Will Deacon <will@kernel.org>, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, Michael Kelley <mhklinux@outlook.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org> <arKsFofudnTYpXj1@arm.com>
 <yq5aik3w344o.fsf@kernel.org> <arOfD6syXOgQhZYA@arm.com>
 <yq5a5wzw2ree.fsf@kernel.org> <arOspFxWZ1DjgcAr@arm.com>
 <20260923130611.GF1540250@ziepe.ca> <yq5atsng10b2.fsf@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <yq5atsng10b2.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E02A160014
X-Stat-Signature: okkoi91to69ye7xdesiqubxgjm7khe5x
X-HE-Tag: 1790176312-133452
X-HE-Meta: U2FsdGVkX1+XhRzlOCrGbr7eIidDho85KW14BSz1xY7FEnuIcJbSK9rlC7thTPiOjQ+2KBLvoQu4RpOMGItDwQqcIkex//CJdflmfN+bAWx0FNNbyUpDVotZ5rHthOl1dXh/ervRu0MkNkGdf98Gj/5R+cOwc8M1ah8cbxsduhza8l6HimMpt80ZIY6IIBGZUm51uoZbZEDHJVBvrRTqolIg3EkAY9ihSUfTO4EEUFAzOKvKuIJf0Jbywu9gLfKtXqlyxwJuCYNJ3FGwunArqyteBzKGfIvdHYVYcRAjtxvK0M7RITHk8IPfN7Gury7zzFjYbOR1rIgTBvQdn8JMKgIfuk84Nq81zJvNqX7/Zt/hHNRKv5d1uOPdlnodZHj8jHNOAWUyLSUHVkDokGVyECPj/j5BEj0lZdaFiWzf1XrRx14nVt3vu2dblpr3N9TmRjcp0FI2gZP4JHZxjeQF6keZ8kIms2jgX7me8Fd33Ci+GU3W4ie8+6h/3ixyVfDb0eHDFlrOBzemqEvePhpVspkA4xvP3HsSCNEry3t8Eh9gILZRONYd+/EWaALiVW/uL7vdMrIae8aeazWLSuRvA8NEnjmxD6EiyC+Lrpch/pvGqewWr/txtDgCaS+rXVFI6XJkY7F/fj2BOUBDkDjAwmGbvsc/OcWRMjFb9DtY0QFTAi5kO9v4oKK5BhqqZ7DhkaThVlMrQ1b10R/hzNn7CgvMBfBRCYDQBcQ9ijBdok09i7tjnRvsyRCW04zNw6gNwzcQfWI8jYBe6mQXe5kaSMPqYyWlnwBeLXs8Y20++idLGxLeJqCAbNJz7GNzEfpPorV4J6EeOE9t6nY1KxxMhstiYgNTkUAKGjs9TJDCL9cQp8qxlsFG1FEXjoTw6KkHk0H5FogbfQUcyCanfFFbQYVD5K6ZPH8+ojZrmGVy1Vtn9ThE4rH7/XyBrezZddmH8JYf3Ym+KnCyt2uU/Z+
 qntWODqJ
 7yN95p64i3ZyMRMYYqyy6bWUhBNTo5ZCFIHkBaRcR0KTaysg5OyV2ionkm6zCgQvT3C2PXHirnEhbQiyTGDO4R+8YER5TohkGw5C5Th7s07Diesfl8Ng8uSiOJhUm1A28by7QJMNTm8Rt8vDIMUvN5e15JnHNnhIo04omgjFY4+R5rKiaibPcfbuGuMrC3idwwS33Vy7rNImVSCpKC/7/CmO81BWDSEo0JIFK2GJ1HN1AXJKMs7iQ8EALSbyaGW2LI2LqZNEWGmeXaT1IxkjOI/SRo5xdo0QLP5vy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc: Michael Kelley
On 23/09/2026 15:58, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
>> On Wed, Sep 23, 2026 at 11:40:36AM +0100, Catalin Marinas wrote:
>>
>>> The simplest is probably to always zero in the backend and ignore
>>> __GFP_ZERO to the allocator. But it's probably only marginally smaller
>>> than passing a CC_SHARED_ZERO flag down. Get codex to try this as well
>>> and compare the diffstat.
>>
>> For patch ordering I would convert to use the allocator first
>>
>> The semantics of the new API should be clear
>>
>> If you pass GFP_ZERO then the resulting allocated memory is zero
>>
>> Otherwise the allocator does Whatever The Arch Needs to not leak
>> private data out.
>>
> 
> ok
> 
>>
>> Once places are converted to the allocator lets go see what is left
>> and ask why it is left and what API it actually needs.
>>
> 
> I'm also considering requiring the address passed to cc_make_shared() to
> be in the linear map. This is currently required by both TDX and CCA,
> while AMD SNP appears to support vmalloc addresses. The only user of
> that vmalloc support is Hyper-V VMBus GPADL setup
> (vmbus_establish_gpadl()). How should the generic CoCo shared-memory
> allocator handle this?

This came up in the past and there was a recommendation to alloc shared
pages and vmap them ? I have lost track of it.

Cheers
Suzuki>
> -aneesh


