Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D269ED6ACF1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463C46B008A; Thu, 18 Dec 2025 06:56:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4012A6B0092; Thu, 18 Dec 2025 06:56:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308DE6B008A; Thu, 18 Dec 2025 06:56:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22A6E6B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:56:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF88FBE3DF
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:56:23 +0000 (UTC)
X-FDA: 84232439046.18.1793BDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id EB7ACA000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:56:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SH1yVZEs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766058982; a=rsa-sha256;
	cv=none;
	b=EKbiRDYQ+BaL+rXHygpiUZ3cnNSHM9IyEnQxD1GeHtp914w2SogU1OYiJsnJlIaI52Vwq5
	cK2pFh0wfn6iEI/Mm78IGgKSp0FajSqspX1f6KkCcZ2KxpiC3+asTSBEyy1c1f2tG8he9D
	2B+sbzaLKg6IuijxnisFbCicDF+sPmk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SH1yVZEs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766058982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTIUBI4/JfQXhEKreKIC4VOhMWbv7RrEW+Y9QT1raAw=;
	b=xkiKoTVqJfsncOS6KMVsrZENobYnaVt25n8jwoMsHHmE+1RKbulNVv7RWyyyc0+o233qrP
	t8lewb7wt4jw/GvsozQCqvDv8Lwb5yPZbYxhBJYlQ48sn6HBvxlu6T4Q38WwYK89lTPs4k
	QnZgBI3on0iEOs3K0opvRIxiJVDkuUk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD4B3441AB;
	Thu, 18 Dec 2025 11:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DA6C4CEFB;
	Thu, 18 Dec 2025 11:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766058980;
	bh=U9HSv6I5Tdowt1XD6o6K9pliXywjMpAu/pt8W77KH4w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SH1yVZEs8FI4hdvxmw/PXkViYYNTQMUWE6mXIVEHz3RM2Wo9Y08wtDpK2VNctwxiT
	 Pa4HVeLxsVW1+oympIyLwyCfDq9MmJbgYiFAyMvQTNQAQWoTdzaW1gTm7yb17jtuN8
	 BaHbOlmirIPx+z5WrtwIMpG/UW7fpSxlfBFftbPEOqMnke1ne+P14AFtOLq6KiKLCS
	 1vPdWy2FhSyJJu/xHtGyYTwKUnnHxwrFmz2GHq3vdHq9yRBvYi+HP4ksRzSMC1wlMq
	 KGTbHIUChT8davyy2WatiTEahypykt+zNbl/LWsc66Nmh1Z2YI+gYV5A7lSIRoztGM
	 MI7IeOTDpLLOA==
Message-ID: <11a60eba-3447-47de-9d59-af5842f5dc5e@kernel.org>
Date: Thu, 18 Dec 2025 12:56:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
 <3a6ab69e-a2cc-4c61-9de1-9b0958c72dda@kernel.org>
 <02c3be32-4826-408d-8b96-1db51dcababf@linux.dev>
 <d62756d4-c249-474e-ae80-478d3c7cf34d@kernel.org>
 <4effa243-bae3-45e4-8662-dca86a7e5d12@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <4effa243-bae3-45e4-8662-dca86a7e5d12@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB7ACA000E
X-Rspamd-Server: rspam03
X-Stat-Signature: 5hnxoh646yjoprk39ua1459x3o8613j4
X-Rspam-User: 
X-HE-Tag: 1766058981-441538
X-HE-Meta: U2FsdGVkX19+gUn7tS8hTUsgKUzy3/dVFU/DJ2H2KqQsRdYl1MoirqFT6B1y/bYrZSZspi17ihq4wCi4S8uvtQa0uZcWL07fjCoZmx/PbyLc6rATI+x4bJDoVR2Nki9x+RITKbT+blte2g8BEEti7kctRfdIBuQJFvUimhw5xq0hJz2Wf+V7IVd3YfSBsIFf+9O2Qb+admn6coG1d1YNgRekkMGHekJ4nrC+pwgwwP6NFPA444evjS8rBCEwVd9Bu09k3mCBB8i+mizEoQ/rOv+KHX49teQZi1KUF6IRuYUrxPwvP9NX95nQfToYGag7EfhyiwjD7aEct+qvSoEdU+2KSV+qlel3DN5By9K0HQhEG4noYg9ANmb1oT8nUL0arHjHLeRyxRGDPxZoYAG7CGfMKHNv45nOB479T9ZYztAKUy2geuylEBspIwWFD+ujuFK+uGssGsDfkWdHLoC5MHvpxcD5w4qDV0kCVxy3PTHaJqbaPIsBdHEc9lqs1ZP3wGYMz2OhXIh6NlNdKD4ySxLYNnzUpk/aLaGjRFUCXFojjcN9mFf39h/Frr25CNzPS9PYAtyD7xo9GVIkzDte58VSQGU+TN8PkM51RuchYsaoDiHfSJQu2KIgAfsN5Fqa+Bdpbk+V7gxx7E5Pv4OEcq6CIoCzCDPPksr/D50NitBS7nFXFHCcTId1HEYnffhiPKAhDFz/O4YdOOp/t7bmlx6dTxF+FmqnTHR039e9VZEUy5YsyQeNAO5Tv5/84A3scl59DYNWJuI5GXTBpQTBHX/P/MYO11HIy89zx9rePplkFGfAxSjDEn3krGQXH7uPyntPYfxZIoQgDk5OnsBtiCMSsJXHWuK9RX0o3Ge1Ndqvf8B+VrR71AWLxi3NZ8abEme3Ia6YB7kTtrK+Pj+4dUq/DLkfViJ9YHQ4NBD4+/khFfuVqk2wvydYvBF4sIeCAAQQjtFCsA1tsSIJwA6
 28QacYGV
 9NUEuqTtSiHb5jTFSkIVQD+5o16bHtAyKDTU0yUv3R6ee2IRGe45td6mFCDVHdx4Ao67LH2zaoHm8jhPHv+lKBWNILRgY1+tdzzjEU1G725ZUoqJ9A2yD4PA3u+REOvlgwaPAylZv8h8m4DYmatdcZQ/+DEuxYF4f9HHGTkvJaGAFNlW6yBKXIAdAk3zgGxwCt1xtDZdi/1Xd7/Q1GhDvpPq6XQWC/gRfUKPxZTCYUTu10WRxdI/SfJkLRA57Tg/M8f1bUjlSvIz5hNz9qR69ZRz4YG4JPt9CZHbtY7VJp6ZFkbndbw2aBX2SH5V4IPK26kvAS+atVpeUs5DAGwcpvVK/O92YCrEL8UMFtl2/CXOOEVvild2n8INqywrfSNE+CS1s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 12:40, Qi Zheng wrote:
> 
> 
> On 12/18/25 5:43 PM, David Hildenbrand (Red Hat) wrote:
>> On 12/18/25 10:36, Qi Zheng wrote:
>>>
>>>
>>> On 12/18/25 5:09 PM, David Hildenbrand (Red Hat) wrote:
>>>> On 12/17/25 08:27, Qi Zheng wrote:
>>>>> From: Muchun Song <songmuchun@bytedance.com>
>>>>>
>>>>> In the near future, a folio will no longer pin its corresponding
>>>>> memory cgroup. To ensure safety, it will only be appropriate to
>>>>> hold the rcu read lock or acquire a reference to the memory cgroup
>>>>> returned by folio_memcg(), thereby preventing it from being released.
>>>>>
>>>>> In the current patch, the rcu read lock is employed to safeguard
>>>>> against the release of the memory cgroup in folio_migrate_mapping().
>>>>
>>>> We usually avoid talking about "patches".
>>>
>>> Got it.
>>>
>>>>
>>>> In __folio_migrate_mapping(), the rcu read lock ...
>>>
>>> Will do.
>>>
>>>>
>>>>>
>>>>> This serves as a preparatory measure for the reparenting of the
>>>>> LRU pages.
>>>>>
>>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>>>> ---
>>>>>     mm/migrate.c | 2 ++
>>>>>     1 file changed, 2 insertions(+)
>>>>>
>>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>>> index 5169f9717f606..8bcd588c083ca 100644
>>>>> --- a/mm/migrate.c
>>>>> +++ b/mm/migrate.c
>>>>> @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct
>>>>> address_space *mapping,
>>>>>             struct lruvec *old_lruvec, *new_lruvec;
>>>>>             struct mem_cgroup *memcg;
>>>>> +        rcu_read_lock();
>>>>>             memcg = folio_memcg(folio);
>>>>
>>>> In general, LGTM
>>>>
>>>> I wonder, though, whether we should embed that in the ABI.
>>>>
>>>> Like "lock RCU and get the memcg" in one operation, to the "return memcg
>>>> and unock rcu" in another operation.
>>>
>>> Do you mean adding a helper function like get_mem_cgroup_from_folio()?
>>
>> Right, something like
>>
>> memcg = folio_memcg_begin(folio);
>> folio_memcg_end(memcg);
> 
> For some longer or might-sleep critical sections (such as those pointed
> by Johannes), perhaps it can be defined like this:
> 
> struct mem_cgroup *folio_memcg_begin(struct folio *folio)
> {
> 	return get_mem_cgroup_from_folio(folio);
> }
> 
> void folio_memcg_end(struct mem_cgroup *memcg)
> {
> 	mem_cgroup_put(memcg);
> }
> 
> But for some short critical sections, using RCU lock directly might
> be the most convention option?
> 

Then put the rcu read locking in there instead?

-- 
Cheers

David

