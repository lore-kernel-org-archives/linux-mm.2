Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B983ACA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2265B8E0002; Thu,  4 Sep 2025 11:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6AF6B0011; Thu,  4 Sep 2025 11:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E878E0002; Thu,  4 Sep 2025 11:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB27F6B0007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:02:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F1B7C027B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:02:19 +0000 (UTC)
X-FDA: 83851883598.18.88AF20A
Received: from lankhorst.se (lankhorst.se [141.105.120.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id EFF7B4000E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:02:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lankhorst.se;
	spf=pass (imf27.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756998137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i9JpeMdGDbhK8fazUzUVJQYBYsV2BDfjJEzDTVjraZs=;
	b=hyrMcmLJR5F2JQ83s88wfe+srg6gYMxEkWYOqAb8Hq0NR2fcXQ97Q+W0XemCi8EFlQy/oW
	v5mIYYyz/9yTSPuMzLGggMYpKUBZtVOn8/Xdy/R4bHxXu+c68+FA8fmkzYfJN2fVs28WDD
	zR4U6yr7ij6EqWB2degHQKgxlgZuDbQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lankhorst.se;
	spf=pass (imf27.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756998137; a=rsa-sha256;
	cv=none;
	b=1L+jYoPmJ+r8Z61LNx0oHPEcCANU84LSKlObvdzHPVC8lEbPDLayhezw1nElrugdUzHKsT
	s4I7XI1g1KDickpUAIRySoGqwvoEzgaBAYcuDcdY5z9N82SfcFIKPP/zGQRFLWy3zy3PYF
	n37cjbK92sb6TKqD3/wi4C8C9DEqMSE=
Message-ID: <740924f6-e241-428d-beaa-630cad8c3e05@lankhorst.se>
Date: Thu, 4 Sep 2025 17:02:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] cgroups: Add support for pinned device memory
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 David Hildenbrand <david@redhat.com>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Maxime Ripard <mripard@kernel.org>,
 Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?=27Michal_Koutn=C3=BD=27?=
 <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "'Liam R . Howlett'" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Zimmermann <tzimmermann@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org
References: <20250819114932.597600-5-dev@lankhorst.se>
 <dc21e54c-d7ae-4d7e-9acb-6a3fa573b20f@redhat.com>
 <9c296c72-768e-4893-a099-a2882027f2b9@lankhorst.se>
 <b6b13ad22345bcdf43325173052614c17e803d00.camel@linux.intel.com>
 <776629b2-5459-4fa0-803e-23d4824e7b24@redhat.com>
 <da5885a94d89a2c0dece04e09182e832e8e40410.camel@linux.intel.com>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <da5885a94d89a2c0dece04e09182e832e8e40410.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EFF7B4000E
X-Stat-Signature: 6mnyahir936xi7ydjxd1q1utxsprc6kw
X-Rspam-User: 
X-HE-Tag: 1756998136-869436
X-HE-Meta: U2FsdGVkX1+ZidcvW3gXwDJsQ7BY7EtoN91k9JoeN4taIyc8g8uWSR3jW8Vdckf1GugJW5YwNadD6mS9PeIvl6EKgeTsUWTz7BCAB1w/5trizAQ39F26TxMPQllu6pDz+L22QTuR6hU2a3NGz8AZi0hd6bvMUaS+WjrEQCuTdS4rO7uYkXOn6dsp2wahqfvak8Tg6HFAwnpH3Xe3HYDEO1O0i5RgqHjWoc0bxmTRt1PyYTtHgZSHDlzGbo/g8d6NAwOUq7hDFemoO+NuAm7pA/y/b/pISnWOaWykb1NuZha0ImG2GDiagY5zlnseGZTrQGNNwZ6kDFHnnQT9LeelyEmugduRaXEaHwEg/BaLCRPi3NF+yPKcwMYrRzOjWOwzQoHNuW/EW0IpD4X5GnJY0ztqeUSI3QbaOYcNO61GB/SPjkwUddA7jGOyQ1qRQI9Z16ZrbJYMwUJ2QPaTkODHBmpXiBrEq3oR7iJA/LBGnOc3sqNwI9MMOAaM+YTxV47cC1RSnoLT9qdIr0OSzJN9y7lfGRgrKDS9pavmzczYp7jQOSWIbCNx6XBZAmeh3vBUkqIPwdjf46eQP/xoOMDi58mGxWuIGPcMI6wetbmGoc7FfZO3Ap2SFJhMwZSaCHgM1b6A2Em0CSLKY19FzApa+QcEPIxrGM3JWZdO/s/fqJxHweTeIMFh7t55vxKLsgqUA/Kx4Tz1HG2oWt57ucXNU8KGFSZoXLsmFA9Wzr4587OH4/WB3jFb46i7Q77dU9PsTLdZaz7ElgyqSioIRePmidkq9u5Rtf4I0wAxJkcjKtD+WDUvWQOlgCdkJ5Y8zmtpT0FLs2VYFLgmAJWmO0Y6FE10H2tQnkZTbdymgqX6m96nI4URbd6yzhWXLc+Et8gHxTW9kBRQ8DXTd3XUU5mjyvBjx2vvHalEMt8UT83grAUgVhwWdGCN0XkAvauLXo9PeNBbZylGmYce0BKObtb
 mhh5l+0P
 sNFk5DoGlt6BAsmodgGMR5mWBYnCeuzT6R7QKR8CDJ/BQvF45zuX4i3X6NzxyhfKwN1PgW/d0YJ7JtWAA6R0kF0N8wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

Den 2025-09-02 kl. 15:42, skrev Thomas Hellström:
> On Mon, 2025-09-01 at 20:38 +0200, David Hildenbrand wrote:
>> On 01.09.25 20:21, Thomas Hellström wrote:
>>> Hi,
>>>
>>> On Mon, 2025-09-01 at 20:16 +0200, Maarten Lankhorst wrote:
>>>> Hello David,
>>>>
>>>> Den 2025-09-01 kl. 14:25, skrev David Hildenbrand:
>>>>> On 19.08.25 13:49, Maarten Lankhorst wrote:
>>>>>> When exporting dma-bufs to other devices, even when it is
>>>>>> allowed
>>>>>> to use
>>>>>> move_notify in some drivers, performance will degrade
>>>>>> severely
>>>>>> when
>>>>>> eviction happens.
>>>>>>
>>>>>> A perticular example where this can happen is in a multi-card
>>>>>> setup,
>>>>>> where PCI-E peer-to-peer is used to prevent using access to
>>>>>> system memory.
>>>>>>
>>>>>> If the buffer is evicted to system memory, not only the
>>>>>> evicting
>>>>>> GPU wher
>>>>>> the buffer resided is affected, but it will also stall the
>>>>>> GPU
>>>>>> that is
>>>>>> waiting on the buffer.
>>>>>>
>>>>>> It also makes sense for long running jobs not to be preempted
>>>>>> by
>>>>>> having
>>>>>> its buffers evicted, so it will make sense to have the
>>>>>> ability to
>>>>>> pin
>>>>>> from system memory too.
>>>>>>
>>>>>> This is dependant on patches by Dave Airlie, so it's not part
>>>>>> of
>>>>>> this
>>>>>> series yet. But I'm planning on extending pinning to the
>>>>>> memory
>>>>>> cgroup
>>>>>> controller in the future to handle this case.
>>>>>>
>>>>>> Implementation details:
>>>>>>
>>>>>> For each cgroup up until the root cgroup, the 'min' limit is
>>>>>> checked
>>>>>> against currently effectively pinned value. If the value will
>>>>>> go
>>>>>> above
>>>>>> 'min', the pinning attempt is rejected.
>>>>>>
>>>>>> Pinned memory is handled slightly different and affects
>>>>>> calculating
>>>>>> effective min/low values. Pinned memory is subtracted from
>>>>>> both,
>>>>>> and needs to be added afterwards when calculating.
>>>>>
>>>>> The term "pinning" is overloaded, and frequently we refer to
>>>>> pin_user_pages() and friends.
>>>>>
>>>>> So I'm wondering if there is an alternative term to describe
>>>>> what
>>>>> you want to achieve.
>>>>>
>>>>> Is it something like "unevictable" ?
>>>> It could be required to include a call pin_user_pages(), in case
>>>> a
>>
>> We'll only care about long-term pinnings (i.e., FOLL_LONGTERM).
>> Ordinary 
>> short-term pinning is just fine.
>>
>> (see how even "pinning" is overloaded? :) )
>>
>>>> process wants to pin
>>>> from a user's address space to the gpu.
>>>>
>>>> It's not done yet, but it wouldn't surprise me if we want to
>>>> include
>>>> it in the future.
>>>> Functionally it's similar to mlock() and related functions.
>>
>> Traditionally, vfio, io_uring and rdma do exactly that: they use GUP
>> to 
>> longterm pin and then account that memory towards RLIMIT_MEMLOCK.
>>
>> If you grep for "rlimit(RLIMIT_MEMLOCK)", you'll see what I mean.
>>
>> There are known issues with that: imagine long-term pinning the same 
>> folio through GUP with 2 interfaces (e.g., vfio, io_uring, rdma), or 
>> within the same interface.
>>
>> You'd account the memory multiple times, which is horrible. And so
>> far 
>> there is no easy way out.
>>
>>>>
>>>> Perhaps call it mlocked instead?
>>>
>>> I was under the impression that mlocked() memory can be migrated to
>>> other physical memory but not to swap? whereas pinned memory needs
>>> to
>>> remain the exact same physical memory.
>>
>> Yes, exactly.
>>
>>>
>>> IMO "pinned" is pretty established within GPU drivers (dma-buf,
>>> TTM)
>>> and essentially means the same as "pin" in "pin_user_pages", so
>>> inventing a new name would probably cause even more confusion?
>>
>> If it's the same thing, absolutely. But Marteen said "It's not done
>> yet, 
>> but it wouldn't surprise me if we want to include it in the future".
>>
>> So how is the memory we are talking about in this series "pinned" ?
> 
> Reading the cover-letter from Maarten, he only talks about pinning
> affecting performance, which would be similar to user-space calling
> mlock(), although I doubt that moving content to other physical pages
> within the same memory type will be a near-term use-case.
> 
> However what's more important are situation where a device (like RDMA)
> needs to pin, because it can't handle the case where access is
> interrupted and content transferred to another physical location.
> 
> Perhaps Maarten could you elaborate whether this series is intended for
> both these use-cases?
Yeah, this is definitely for the latter case too.

It's a performance optimization for the generic case, and very nice
to have for the second case, to prevent unlimited vram pinning.
With cgroups, we would be able to limit the amounts of used memory there.

Kind regards,
~Maarten

