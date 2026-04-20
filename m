Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF59F557F2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 09:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EFD36B00D1; Mon, 20 Apr 2026 05:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0DF6B00D2; Mon, 20 Apr 2026 05:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F0B6B00D3; Mon, 20 Apr 2026 05:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 648936B00D1
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:46:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6B881B8D8E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:46:10 +0000 (UTC)
X-FDA: 84678453300.19.095E104
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8B208120009
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:46:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=L1LwmNHa;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776678369; a=rsa-sha256;
	cv=none;
	b=NFkgRwshz7TdtEAT+EvjRPUaXYvghfE3jVPZPwU4TGuJsTre9igCYAt8w/gTOjgEe894B6
	zCwhZKDkp1K1pX6mPHwAr1n2MLahvjxoBqb1UF4F6kIMPOJe5MW14CMgAOI+in+IYHRw9U
	oifIptl6f/Rja8eu3yVFKFFXDiguwTI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=L1LwmNHa;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776678369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gg4pJCLunSYymMpSp/fxPYiT508sB8hvebIpSY6Jcko=;
	b=hMwARIh92Bnm+ZfY8VFDIMV77sezTbomPncOLuKlYKxPGZooxlauQm8dwyckHrzroGGIFF
	cTz4oIVa+DFdwpSnJz0fR8E89WmE97+RNOz2yKKrsq2Ne74wDdRoVWA+I4WMAWs7hNoFoS
	pGtrIK2jZxJ9c1I6KYsxMZOvQJguqUc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A81581516;
	Mon, 20 Apr 2026 02:46:01 -0700 (PDT)
Received: from [10.57.89.131] (unknown [10.57.89.131])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 82BA13F915;
	Mon, 20 Apr 2026 02:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776678367; bh=0LnwgCKSOKAxCSRRobCz2g3Fg7fEI4umGWE6lQbQdxI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L1LwmNHazBeqgP6sMtuBhEJMafYyFNM7jjZ0Qel4K/ytrAl+aBOWdqbirlIqrhu9E
	 t3l7UVo2nnaaHUWUcYmUCrdW7+wUVNPQY3UDCvHzMwNUFb4gY1NfZoFw0XGTHgLUHz
	 +9zhNRSNlLjUvCK43bQB6iqegMvA1nY9I+ygUsqw=
Message-ID: <1e2f1bdf-dca4-4b0c-90fa-d61a2552835f@arm.com>
Date: Mon, 20 Apr 2026 10:46:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/53] selftests/mm: make MM selftests more CI friendly
Content-Language: en-GB
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260406141735.2179309-1-rppt@kernel.org>
 <ee6bbac9-b375-4413-a771-6d32c7afda67@arm.com> <aeXvty_LE4v5XLq3@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aeXvty_LE4v5XLq3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: ibiw8tdhu719sod7wo6tyup3z48b9qx6
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B208120009
X-HE-Tag: 1776678368-257242
X-HE-Meta: U2FsdGVkX18sMq/atDiHm1Prcs8vgAzFajXRqIHbLo2MgdIobSnRqa18XfBBy+zEnIHhh/xmv8jYcGTLMnpxyJf2cRmv/KbO2ssT4glNn+kIuWJuy2uuLJQI5LxZ6QN0yYX2/xeUac30DBTuInEF5JW+jSqVo9wJnYEcVcVxVRHyjJ80Fl7fzGHloX5Wxx8YTcSC40xRgnxSZJdGdCPvF9Z8Y6h9+u6o5XNAQZ6+uYuGxZS2RLTWD3c/oqc9PX87c97dBOhhDopyesrOlNHPQZLqufj3QU+Ns1UXWWFsp5cXIMeW4J5Lx/QZ7rGHuN/DWmzijZYz+kvSZfmWr4EMzTLkFnXExgCmvomhVhJJdmDkRNnWqF7K8SPCR67gap81C7+JBuGIRtemGokU4GvnwL3imIEeDZ9GeT3GQvLpPPr14RE3WjACnxSpE9AmHc5dCPp6sq6oOMXu21fn462cuenDUBw2C55t3voMecBPvJouanU6qhra3NFFdz3TCpGkc0c09WtEaVOGUme6qIlvx0MNmhC+rVeVedwyNuBdkd4L4o/RjYuvqNcUOPAtv7bDw6Ie13O0K00M3fpqgtJ9sLqGmXAGKsEf3oMkL+g/lu9T6QLMQWt0KIhSo1nCsqO0rHgV6FQMt0tt8M+HvLWDHMvCwXZW5Wo9o1mO2bNGvg/mq8AA7nlgb5zsFq3+fsseJ2YuYwNd08acjuH0LXDL1WbcSOcWxYKlEmrukMU4j7rU5uT67AR8IdolWyNPZxRcB7zupPYzHjBkjP2ryg04LGIEAgh0zk0nnBXugptZ4JutayUqpHVSdgkUd2EF/ZOdQRJEtKtULS2+1k4txrh6NX2gechpcRHoxZ1MbzRNiFG8KO24GhYHmAmNvFoql3768waCocPaC/mdP0IPFD0qjLPxAyNzjp3go1yKx+Bf9CpTvY5IMJXYnDMHKO+2IrD7oD9nVh+J7aTeuFyFUhJ
 xBld3Ohw
 YTM44PbJ03VkW3SDLifwMyYFAbYWWu6z2iGZBGZ45BE6gdPOevTDVSlZsKlFDNTl/pAhNaCrIOFhEnhD0Azn2Td42G0bdfBlqUwK46mxuDfnZD7tdFeAFrRHinA2BjWBOoDRqCsni7MY5YMJG+FQVFv1p2fKQcjMXT9aUdHd27qW+ERtGYFnIwUR3z6KA5zorKZCBzVjum2/r3fXOCO0dELvIfE0pMS1WgSsk0lr2XhMYdUv7K0gY+YMyk8ehABlVYprxOcSYWeKHRVvmw893Y0yvRKCmxG238q6rjxtr8w4UadFzN14/y80i2CuypJupxH6AbOXFaXbgMn7gMvIYqifI7iQHexXrfigl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/04/2026 10:19, Mike Rapoport wrote:
> Hi Ryan,
> 
> On Mon, Apr 20, 2026 at 09:37:03AM +0100, Ryan Roberts wrote:
>> On 06/04/2026 15:16, Mike Rapoport wrote:
>>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>>
>>> Hi,
>>>
>>> There's a lot of dancing around HugeTLB settings in run_vmtests.sh.
>>> Some test need just a few default huge pages, some require at least 256 MB, and
>>> some just skip lots of tests if huge pages of all supported sizes are not
>>> available.
>>>
>>> The goal of this set is to make tests deal with HugeTLB setup and teardown.
>>
>> Hi Mike,
>>
>> I haven't had a chance to review this series properly, but the intent certainly
>> seems extremely valuable!
>>
>> I thought I'd share some configuration magic that I always use when running on
>> arm64. Appologies if I'm teaching you to suck eggs...
>>
>> arm64 supports multiple hugetlb sizes and (at least in the past) the magic in
>> run_vmtests.sh only reserves for the default size. As a consequence, whenever I
>> run these tests on arm64, I always boot with:
>>
>> hugepagesz=1G hugepages=0:2,1:2
>> hugepagesz=32M hugepages=0:2,1:2
>> default_hugepagesz=2M hugepages=0:64,1:64
>> hugepagesz=64K hugepages=0:2,1:2
>>
>> Which reserves 2 pages of each supported non-default size in each of 2 NUMA
>> nodes, and 64 of the default size in each NUMA node. (This would need adjusting
>> if using a different base page size).
>>
>> My recollection is that this effectively overrides what the script was doing and
>> is sufficient to make all hugetlb tests run for all hugepage sizes.
> 
> My goal is to let the tests themself set up the right hugetlb configuration
> without forcing it neither in command line nor in the wrapper scripts.
> 
> On x86 I can run all the tests in a virtio-ng VM with two nodes and no
> kernel command line overrides. I suppose that should work on arm64 too.
> 
> There are some additional settings that such a VM would need to avoid
> skipping tests that presume swap or a real filesystem, but that's more of
> virtio-ng limitation.
> 
>> If it's possible to get this non-default hugepage size reservation logic into
>> the tests themselves, this will make the mm selftests much easier to run on
>> arm64 with full coverage.
> 
> That's what the second half of series do. E.g for cow tests:
> 
> https://lore.kernel.org/linux-mm/ee6bbac9-b375-4413-a771-6d32c7afda67@arm.com/T/#m62f23b835061449bc6249afacf993bb32ea11234

Ahh, excellent; you're already considering the non-default sizes. I'll get back
in my box :)

>  
>> Another observation is that "secretmem.enable" is currently needed on the
>> cmdline to enable secretmem so that the associated tests run. Not sure what can
>> be done to make that simpler?
> 
> Looks like you're testing really old kernels :)
> The secretmem default changed to "enabled" from 6.5 ;-)

Good to know; I created my scripts/environment pre-6.5, so that's just
historical baggage on my part, I guess.

>  
>> And there are tests that depend on having more than 1 NUMA node; I always run
>> under QEMU with 2 emulated NUMA nodes. I guess that's really just a property of
>> the HW, so nothing to be done from the test harness.
> 
> Right, test harness can't do much about it. It's either run in a virtual
> machines with 2 (or more) nodes or enable NUMA emulation in the kernel
> configuration and the kernel command line.

ACK

Thanks again for this improvement!

> 
>> Thanks,
>> Ryan
> 


