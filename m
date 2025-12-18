Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F5BD6ACDC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D956B0088; Thu, 18 Dec 2025 04:58:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B6F6B0089; Thu, 18 Dec 2025 04:58:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029E36B008A; Thu, 18 Dec 2025 04:58:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E11BB6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:58:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C597BE042
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:58:43 +0000 (UTC)
X-FDA: 84232142526.11.F0DF736
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id C8536C0003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:58:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MKg1sWXG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766051921; a=rsa-sha256;
	cv=none;
	b=mUDsq7lD7Iwecw3QPmoJa9/uF29OogOwdm9FqMfXYwqOOxdT+YSMuESFGj4IPq9OaKu7kV
	LPm1xNvQrf+WgvROAj/gpHRNP8vRqcXnHgAiQBsTvf6En4zihy1c9uWj7YyOUO1TVqGk/W
	Ovretdplp3+Dj31eAwvShYk5WJv5TkU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MKg1sWXG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766051921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJqr5UQpT+/Rn1WsDWLivxrIk71Gu1jMuCYfXi9rDLI=;
	b=T0skTc9dWV+YxoPozE6pySaKWa3rK4dhCkp7uFuRMDLofMadYa4GK5Mo/XoYGsWGkCi/Yl
	cowOAljbRRWPZNpDRLA/T/NQuhoqsbiNkN2BnC90SjsRhfu8wb6O1ZbcIvsvYcnL//AYCj
	vIYzJ4pAAGDm1h6ZrlKaLFCpg556jMw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FE4860010;
	Thu, 18 Dec 2025 09:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F74CC4CEFB;
	Thu, 18 Dec 2025 09:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766051920;
	bh=OuIUjwTgczqolcJsMdctj2jhlUiyGXVpFo8wseT8OZc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MKg1sWXG6lymtLHcZEwMaPS2j7tKBYpLHl0oVGxndnymilFB+8Q0JvzVRnY7L/p4Q
	 qEaq5FLH+eSQSNdhlhhN9L+GdNZhCMg4EHR0Bx4jNEmtVQU8+6qVSus+Gw0E5JC22B
	 LY/f6+590Vy7obu3xEQwHiA0raJA78mbQ5j/BUuTH7TLNZ54QP3ejxCtZOA30RYkP+
	 U6AbsHgzMkynTq6A/yK34R7DE75Syge/kFVGlgaCYs3e/E7pJqXuDwBb7TpCb8AUQ4
	 9a5ESPvLHENJR7M62gCzDUFUZYcaucVaTCOqIlVIvA1glNLK91DukxEwJKb0Fuuvi7
	 JTq6kB3jNfgjw==
Message-ID: <37c5dbc1-bd66-4124-987f-8983a06d576e@kernel.org>
Date: Thu, 18 Dec 2025 10:58:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: use end_folio to terminate anonymous
 folio remapping
To: Barry Song <21cnbao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
 linux-mm@kvack.org
References: <20251215004836.694-1-richard.weiyang@gmail.com>
 <CAGsJ_4w3535fwxa_WkkQLcfNjzRkJYbBJ0WfpYJ+v2hwovdvWA@mail.gmail.com>
 <20251215084353.nmznnnmcpcqo4ldy@master>
 <CAGsJ_4yPnv_G0vciNLabA_kn=0k=RP6kBpuD04btj3HM_zarTA@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAGsJ_4yPnv_G0vciNLabA_kn=0k=RP6kBpuD04btj3HM_zarTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C8536C0003
X-Rspamd-Server: rspam10
X-Stat-Signature: tmmkfdj6h11o4pugi3y36sqdksqr97uz
X-HE-Tag: 1766051921-766398
X-HE-Meta: U2FsdGVkX1/ulPk0k6jAl/kGxiT3x/SGssB7Ro3593nMcohJCjOaCxZu9YYgyzp5EQqzvsjd+wr6ZMtps4bLf2Tz2v4I8DAUX27qJMJAhd1/kBnobE7IyMeDCNFJyJOrO2BeKrT3aBLUmjOhJsstMqIfojhlWDtic9rzr6E6Pe4GsEgrLG5NsAChQaa0o99oYCEX9BgOaKEXBotgWO7lYzMhB0rupYJ0+GYz5tOLIrhnhmwj19ymL8gilQDkWvukHjUnHnDeZ/2ekGmjFLyFHJIQb56oMGWvDJFSAIzzDTw2sLQQYjj471nrfZ8D+ADXpDnQYlhS/8dgS99OUo1FaJG5SzdYtCBIcV9Yi9FFpeK2TNUGRGZRX3X+Qqq81o9cFOEgxVFHBh+E25PYztjcmzYBj7CRO3d/LVNOYTjqWUoNPkarVHB/Vs+WP24kba7KT93Y7yyGq1bcZyB1AE2P2tstHL0ifb8milL9/gjj/XVU8IolYPRY+FSlBQUON/ZL2rbbycns09337qbvPS76f2GoTGXOghXmLfBImxTu6KT4TuB8hRGuQ9HPPFujMXkmJsSV+p+EflADI83h9uiMntcIYhIfNJ7xtWmTgZYFcidUBfpkLHWLuuO2sLopXb1LToqqIje5FsGg8WkSs0B1VHlsZ8tPScQ6vwBOCLu9bgsB54WMlqK32F9+xmaEDr3iARTgtu5NUfPhFrxZoqqeOhCsFP3jE9VlhqBM7fFr4beplE05rLggPD/mN71FS9QJv4lz511qjepU+/2jMOjmKcxIOjZNJ/YlErmfVd+OcEAyUYMmV7pr07ESWNWCK9HORxD6lsPZn7eE/E+lYv4JFgiMYxb5SEWbA4HfjjzVWt7n+w9WMZBDvs7XEv6gzR5BFMxM6rp2MrAG3EqDP8urMlcPjtuoyLRbaNWeQeY7A+O0nDjgAk4tEcrEWuSdsShgLF/tV+1u++iYxvKYZr+
 DpFBn6YC
 n+LIBPD9qFRr/8hHD7z6kOp/wiANf58AxHtHq0mpll1g6NhnPmZKwqe3q2NqXA54o6uxjJEO+3QSavR4S532hZcgOajZOnIYWsdcH2h2PAw8Dtsy+1G/JX8SYqX5Rjcb+MB6AenbbAOoj8R1LGPYqpAkKVukalxWZyZ0lr8AMNqinUO8XMFUVS6KPSrfoiT0kG4rayrohuf50bbjj5s3Cj2hCtmzD44ksUT6hag/QvEfBANlUZqmaB2S9Z/b3w5bxHmqaL0dSf1wKyewDvs+TRDFR5qr2YyUAwEi9AwGrpnX82haS2QHNdv6Yd5JJX2S1+IPfdCIKSr7ThCdXg8YboUiEtXSr8PrXkM3gkMtNFnNZcrcelskya6FHGmo9Dhf2pGXvmRH4DwkDPeVIPIbLLIUuVrAeOfeK3j7XuxuJh1WaKcjNB4K+V2xLSs/XMDcTZbbG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 10:15, Barry Song wrote:
> On Mon, Dec 15, 2025 at 4:43 PM Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>> On Mon, Dec 15, 2025 at 10:31:15AM +0800, Barry Song wrote:
>>> On Mon, Dec 15, 2025 at 8:49 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>>>>
>>>> After splitting a large folio, it is necessary to remap the resulting
>>>> anonymous folios.
>>>>
>>>> The current implementation determines the end of the remapping process
>>>> by counting the number of pages that have been processed.
>>>>
>>>> Since the final folio in the sequence, end_folio, is already known and
>>>> tracked, this commit refactors the remapping loop to leverage end_folio
>>>> as the termination marker.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>
>>>> ---
>>>> v2: move folio assignment in loop
>>>> ---
>>>>   mm/huge_memory.c | 13 ++++---------
>>>>   1 file changed, 4 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 40cf59301c21..fe812d9c7807 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -3423,20 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>>>>          return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>>>>   }
>>>>
>>>> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
>>>> +static void remap_page(struct folio *folio, struct folio *end_folio, int flags)
>>>>   {
>>>
>>> Do we actually see an improvement in readability or performance?
>>> The existing code feels a bit more readable to me; nr is clearly
>>> the number of pages :-)
>>>
>>
>> Hi, Barry,
>>
>> Thanks for your review.
>>
>> Currently end_folio has been used in __folio_split() and
>> __folio_freeze_and_split_unmapped() as a termination marker. So continue to
>> use end_folio here as a termination marker looks consistent and improves
>> readability to me.
> 
> In both cases the variables are temporary, and they look fine within their
> own self-documented contexts.
> 
> Now that we’re crossing two functions in the context of remap_page(), this
> doesn’t seem to be the case, though.
> 
>>
>> But yeah, this is my personal preference. If it is not the case, I am fine to
>> keep as it is now. :-)
> 
> I personally find the existing code clearer, but I’m also okay if
> others like your new approach more.

Me too. Well, the existing code could be cleaned up
* nr -> nr_pages
* remove i and subtract from nr_pages instead

probably more ... :)

-- 
Cheers

David

