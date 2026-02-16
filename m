Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0696FE81A38
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67CA26B0089; Mon, 16 Feb 2026 10:18:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634456B008A; Mon, 16 Feb 2026 10:18:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5369D6B008C; Mon, 16 Feb 2026 10:18:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D00C6B0089
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:18:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C98FC13C2F0
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:18:25 +0000 (UTC)
X-FDA: 84450676170.25.318495C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 15C321C000E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:18:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t0Us5cZw;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771255104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhUXvoITQKnsnKWuOfTJ0XwZaycyXn7DWq6mlZt8uzw=;
	b=qO+Izxec7gOYZeTO+iYfsn7xczu0rfRK8LsItBOxLGkMqkNcQvYVMj7t6pt63I8KQ0mS9Y
	UgzHcPZ7wiQagwj0WwmUdoaMAyj61QpmxqNd2PN7iUpjhw0K4Ht8HxubDvbcRb9NWnB5nY
	Nq4/QFUeLFAyxHvwTqQyfqG+1+OKsww=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t0Us5cZw;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771255104; a=rsa-sha256;
	cv=none;
	b=KV6PbBxAd0EbLyXhlELI6Do65G118id2D3uwXMdT2k3xMWscR/kRwp7RXM7P9MJ/I2ZUwu
	DloEkwNW4IblA2F86nIhXWJjGVz8zOmnWgUkvPIL/2tUkpXBL1uVQG40o5mZ8ynAS/TFZq
	2G9PUaBIRkixz6UQmuPrbb0RNYAb6Hs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64EB76012B;
	Mon, 16 Feb 2026 15:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7413DC116C6;
	Mon, 16 Feb 2026 15:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771255103;
	bh=nuOCQrbydX5nDHo4AVpIsAFOyphGR2XiFnc7P7fdV4Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=t0Us5cZwUWMi6E3Ndvl33Y2COhgA2rBaEKXqrmtu2154fq32IfduuJ84dUpPAuRSh
	 AL9MtokRSDEK4HIf41OIvv87gIJtZ15mpUHu1rMGWpcI/H1a0R7CimkOkKfqqrvgb7
	 JcBje/bs3/QEI/LpqK+I6kyqYA3tlw0adK4+dEbZ53GsPqzGCQkf1Ez0poRKC6uCp4
	 YUOTDGfiDRyBVNO/OyjXdiWzBNuGTctC6qehl5Yv+8zSTipayTfiz9T4IxnKC6fhqx
	 UyylDmndFVAyHrX8T4rC0swNQilwPmzTshD7DBDICqQ9jp+EZvyVquoGzxwPx95Ib+
	 8YhbUipdTdMDg==
Message-ID: <324f3216-3643-43cd-8620-9253c831be87@kernel.org>
Date: Mon, 16 Feb 2026 16:18:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <db1fa367-0fd1-48a1-a58c-73e72cfbdc05@kernel.org>
 <CAOptpSMCDnnZFSiMrGwA4Kc5Zu=4-6giVbbzMa5UEEE2QzvtoA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAOptpSMCDnnZFSiMrGwA4Kc5Zu=4-6giVbbzMa5UEEE2QzvtoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15C321C000E
X-Stat-Signature: 95g6njzgkfkjiopps6ct9nxakr8hzqwa
X-Rspam-User: 
X-HE-Tag: 1771255103-579171
X-HE-Meta: U2FsdGVkX19Kfk7/00XXiWIGA7fmGrVuXQdcwW6SkH1kkrfg26NWoXqxgaVgGs9xheAvxDSaDfYPfduBG4jkhhGUJqvjReyimpB0oMt9dHjQoUbaVQWVnaP3k+Cl81r/n4GXe1kMMxeJB+Z4y9g3O4YX4WNMXAC8vjvPMOKn70G+1Xj0Hk2hDyAcEix3DrqCtqAr+q1VvjS/aeXpyJlb4QxPOiYHppQOGyrHZxrgQVCIr49yo+YkHYnicdDrYvaJCou9VHT8iIR8JmlCoQHFHgl8XECHDW1RezKfcXmhTt3iuz9QJsAtoJc4gY1Nxg7t77mr63YZ0qYLIz3mTwd2fZ9Mh2X/tDh7qouS2YxbvbJsOWk+Fl5OJ7c0jTDvWvKj8QiOBXVEVaj2ZkFa9c86pa18T903FsU1sfhwYlExfjEVvGr6DaZj5GTgpwS/Hgwe4UuER+VaPCNQzTEzP8nojrSZUIwdzgIgL23o1q1yqEnkllXShdYGGSRF2K4wUtPbGqLoVIGugxdUo60Gq7t0WPGkp4jcowYfVSFoGfQ8h6kH5O4Qalt0yn8MF03Hj/GTXuCub4sCI263jj56xmGWfPOppHOAZfUtwanDNRpj1AeMRFnDC6xRSf9KmLXKgsKzymhd1sVBRco8WCN+bFqQyLlYcRSRsm9tPDoQdkVhKiGmB2sY/PGylF3KtrpcAqbClOD9E5fet/BGjuv2peaQ7EIq3i7kXkgT7HvQvcQfVOe8yKODrYuQmDv6HdT5u5jc6Fv0TB3g1x1hGMv5ZUYbFHuBRd3EjoOlHa38PP4TCqkWqQy5hywuZenP9XVvNI+/PJ/wZYervJ3vekLfl6k2vHau1xeBJcWIs4Oj5Jd1JHrEXO68r8pxX+ywu3xOAhd3GGhDPbYJOZpguy3kuAHr0S7EX1gc3ORRo9u7H6bu6POpSvUotfgGC1XSzBfzxopj5gyZ+pnie1qgXIuwFaK
 +Is3kRVT
 aU1cOMraN7se5G55WXzDSe17vkNS6tHqzkonjR22xslAEOXWSGvu8mmawyb/tY/VpziEuX7Z73BJc7QmaUjrobkK0kNDQzUk1MycRXtr5iLpaY/qwYJlUhf/cv3vCM5epwsbwZyg3UYERW+Qhyk0e0w2WyKFyEJBPtY/Q6gfFWcI3EO0yWLhQgK2tBp0WPBMmDnToMkHIkbD7jhBbwEEI6Gsyl0ZKjISxn0qZnfZMNFnxhYVuV/pB2CYNL2hxzd44e+xvVRhKP51A/BM4tFz6pmS+0km7MYGqiJyEppKlUk7JqyDOrgdoNMBVaJJ52UijMhaeQa9FxDhXHhg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/16/26 16:10, Wenchao Hao wrote:
> On Mon, Feb 16, 2026 at 8:15 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/14/26 09:45, Wenchao Hao wrote:
>>> Add kernel command line option "count_zero_page" to track anonymous pages
>>> have been allocated and mapped to userspace but zero-filled.
>>
>> "count_zero_page" is rather sub-optimal parameter name. "anonzero_in_smaps" or sth like that?
>>
> Your naming suggestion is indeed better than mine. If this patch is still needed
> for further development, I will modify it according to your advice.
> 
>> Still wondering if there could be a better way to enable this dynamically.
>>
>> In particular, not using a core parameter.
>>
>> If you use a module parameter, you can just set on the cmdline
>>
>>          proc.anonzero_in_smaps=1
>>
>> And dynamically set/observe it in
>>
>>          /sys/module/proc/parameters/anonzero_in_smaps
>>
> Regarding the use of module parameters versus core_param, I think
> either approach is ok.
> Currently, the core_param I'm using also supports two modification methods:
> 
> 1. Command line parameter: count_zero_page=Y
> 2. After system boot, view or modify it via
> /sys/module/kernel/parameters/count_zero_page
> 
> It is true that this modification would be more appropriately placed
> in the proc module,
> which aligns with your earlier suggestion.
> 
> If there is a possibility of further iteration on this change, I will
> move it to the proc module instead
> of using a core_param
> 
>>>
>>> This feature is mainly used to debug large folio mechanism, which
>>> pre-allocates and map more pages than actually needed, leading to memory
>>> waste from unaccessed pages.
>>>
>>> Export the result in /proc/pid/smaps as "AnonZero" field.
>>>
>>> Link: https://lore.kernel.org/linux-mm/20260210043456.2137482-1-haowenchao22@gmail.com/
>>> Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
>>> ---
>>>    Documentation/filesystems/proc.rst |  5 +++++
>>>    fs/proc/task_mmu.c                 | 10 ++++++++++
>>>    2 files changed, 15 insertions(+)
>>>
>>> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
>>> index b0c0d1b45b99..573c8b015e39 100644
>>> --- a/Documentation/filesystems/proc.rst
>>> +++ b/Documentation/filesystems/proc.rst
>>> @@ -545,6 +545,11 @@ replaced by copy-on-write) part of the underlying shmem object out on swap.
>>>    does not take into account swapped out page of underlying shmem objects.
>>>    "Locked" indicates whether the mapping is locked in memory or not.
>>>
>>> +"AnonZero" shows the size of anonymous pages that have never been accessed
>>> +after mapping, and it can reflect the memory waste caused by huge pages.
>>
>> That's not correct. They could be read/written, but with zeroes.
>>
>>> +Implemented by scanning the size of zero-filled pages of the VMA. It
>>> +is default disabled, and enabled via cmdline param "count_zero_page=true".
>>
>> Probably best to keep it simpler:
>>
>> "AnonZero" shows the size of anonymous pages that contain zeroes. Zero-filled
>> pages can indicate memory waste caused by memory-overallocation with (m)THPs.
>> Availability is controlled through XYZ.
>>
> As with your earlier suggestion, if this change is to be iterated on
> further, I will update it according
> to your suggestion.

Let's wait first for other opinions. Willy doesn't seem to like it if 
there is no use case besides for limited experiments where you could 
just use the OOT patch, possibly.

-- 
Cheers,

David

