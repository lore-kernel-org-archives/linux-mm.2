Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0AF9D1BDD4
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 19:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A7A6B002A; Wed,  3 Dec 2025 14:45:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051D56B002B; Wed,  3 Dec 2025 14:45:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9FA6B002C; Wed,  3 Dec 2025 14:45:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA5366B002A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:45:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F86C1A07BA
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 19:45:53 +0000 (UTC)
X-FDA: 84179190186.08.E02DC48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C353840013
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 19:45:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RJbzG9Kz;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764791151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=McR/q0nrNyczVFb5w4PpkLwyRKrxYplFMieaV1iYV4I=;
	b=p+TI4TyYCpHbYL9W4bJ6KymKrcIGeZX6AX97CZoS0P2xSRs50ZRaKwKkakG2//HxQEwoTl
	Bk5txUob2GT9iZnESNNEBp3wpLOgszA1drojg7HYUGXa0AUoqSCZUOHJdjMG6stWoUl4q6
	Mq/cLxcY9NXxgpOuPyodWZt8EVFd0WY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764791151; a=rsa-sha256;
	cv=none;
	b=kjHh4g/FBQkYWBPl5IpgiebEv/4GDNk8Hj2AvVJ5vvBH8z0/flACR3mnQZU67eOgyywvMC
	KRCwEe89az+N6UfWLYN2CeUEGxN3130v33wQFxanTN1NexG6qSl59FxGbPDcrFYnYMGqXL
	c3oK7SU9wR4Pjai8IVMbx9X/1WBLq4M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RJbzG9Kz;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA06440B7C;
	Wed,  3 Dec 2025 19:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF83CC4CEF5;
	Wed,  3 Dec 2025 19:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764791150;
	bh=vkxqp0flOaunzJWApUWlsmuTw4iqR9L5WSt8ObioPfY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RJbzG9Kz8dgE0fDAOb6IxvZaIdwzFenvo9aaJTpV3loVoSdQTXr/Q/gv1KFtiUsBQ
	 m6wC2+vz2Bqr7+/xwKOyCcopT1SwxFgj+YG3zuGvEOIp3HzspB45TLfPAlBaMp56p2
	 BgGZlbgQY5isxP0V1K2/3VxF23rW9j50QhwkpR/rMU++RMCVekXE0f6bzVhp7yOA4V
	 SXVGqhM1g/OU1fVbFZhYvArR097WG4xiIeTa7oT5cUMdmfQ21S85DTp3ZG880bIasO
	 OTZX/xQKy60ADE7ZiEMuZt2Z49+KztJ5L4nDWZQ4IMWB6xP+vSMPuWD0dzmEUc3wuS
	 MZhEDc2E85GIQ==
Message-ID: <2b9272ab-8757-48ee-ad18-d0e38b3223d2@kernel.org>
Date: Wed, 3 Dec 2025 20:45:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Uschakow, Stanislav" <suschako@amazon.de>, Jann Horn <jannh@google.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com"
 <trix@redhat.com>, "nathan@kernel.org" <nathan@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
 Liam Howlett <liam.howlett@oracle.com>, "osalvador@suse.de"
 <osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local>
 <CAG48ez3paQTctuAO1bXWarzvRK33kyLjHbQ6zsQLTWya8Y1=dQ@mail.gmail.com>
 <a317657d-5c4a-4291-9b53-4435012bd590@lucifer.local>
 <CAG48ez0ubDysSygbKjUvjR2JU6_UmFJzzXtQfk0=zQeGMPwDEA@mail.gmail.com>
 <4ebbd082-86e3-4b86-bb01-6325f300fc9c@lucifer.local>
 <CAG48ez1JEerijaUxDRad6RkVm3TLm8bSuWGxQYs+fc_rsJDpAQ@mail.gmail.com>
 <2bff49c4-6292-446b-9cd4-1563358fe3b4@redhat.com>
 <0dabc80e-9c68-41be-b936-8c6e55582c79@lucifer.local>
 <944a09b0-77a6-40c9-8bea-d6b86a438d8a@kernel.org>
 <1d53ef79-c88c-4c5b-af82-1eb22306993b@lucifer.local>
 <968d5458-7d2b-4a8d-a2a6-0931cd87898f@kernel.org>
 <c798628d-9bce-4057-a515-8bc02457f370@kernel.org>
 <8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org>
 <A8EA24F8-7A13-472A-9AB0-C7125205C3D3@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <A8EA24F8-7A13-472A-9AB0-C7125205C3D3@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C353840013
X-Stat-Signature: whg1ejgrcnx5q3hr59ysbnckwahyoxs3
X-HE-Tag: 1764791151-167387
X-HE-Meta: U2FsdGVkX19sXcEW4MMz091NCBiQ3vOsyrec2xlKubGbpLfWjwg7WRUtd6A1qeTnE1ygNj/sI+h18jH1f8STUsaqusj6j271K89HvVtacIF7WtisfLWThrEn6rdk3qAqGcrY0RFeqsaavi2xsbYDxC9DpkywIai94pbh8yvQF5EI7U821BhZn8siTs4OI9SG+7OAAsTV2wvMS8FTuM1N8LHnMTu2obE/5VRtrDN3z/oy9qtB4a8t8+xwA8y+7l8lllaLueIKNJ4GyzGO8/oqM97VHur42YlujKAXolYp8GCXYCB5VolgjQhg8tVJGLgruXcz2zaWSf0pri3B2vjePEm/Aj7syN9EuoK7TlOnuv0gs7+bzZ0WWBB1PrnEFF7DW7v3agNONwD1o2yWgMGrMOc1is4D+00SaXCaxyPRA7dumlM7PDH5itUehcmedPFvgCUqoz4WY1nor7Hlcb5vPy1LkjScijs2nVT3BIcFdTgOmAj8SawPOu6zkmUL1QxPiJf1yLJmu/2CGr3wCDAQvWGr/Pu1rlLQmD265WiOB2pQEc3JFb2Fmx6wk93tSAnhFBnA2TIQhVnOnUiNM+ug8qepmqsWC6ydfENAc33dVPgQpEz3OCjNYZVO+UGIsm3bNDoeSgoBN0+bqLuiDRGuJZt+kE3SWFvdlrIk2GJx71Bexu7OibL2wFyB8apbmOuz+Qxn4aj3fKuGlEbH+AgvthhLRAkIJOtbWQbur0XlTV18DXoWSFvJaVny2M62a1+BafXxGfbLBQ/o7IFu1YNWq+IpMpwhon43TognGWnEPjzY8u61VN349anF+KjtWLyJ6zN/iCuhUht5sPXZMhIvZp/Pl3aey2K9zjW/7TUrQoJGUO6hSlyuhwfYZ2K9eoUGy0c5uPW2vpFXEUtMs0+SeJTErooewh4zATviElZqYIB60ZLlP4n2g3SyJ8A6v6WyKezlKwmCnp7NRQXPNTU
 WcIsdxfo
 DitAf1zYe6NjiHLoWmSmsICcRrtuJdZlSIYFfEFvr8z0CaRVeNQgvK7/mrV66AUQAdTtO5aVCZURHcsI2Ef7hxQNNqJTPkiMxQ3SVvcDtf58gblseohkYtYjF758avi0q590iaIwc2aTmKKzanF+YCyY47EHzGB2UJtVC8T08gV4d0XDhusILjmouNinC2Vc/sNKyLWOmZ/Y1SgkeIXuDVPD/HCTHZ0F7UyYVHPXd4paICOoM4eFg7hT/Ngve70jS6DmggMAD+i6Fv7M2yZajdUVg1Ia9FLiH94jxWmAcGPflhoez0VVjRvaLgBWwPHCD+2woeOn4Ysuad//RXLQPt0RE7FQcYhDvCDJOJioFGzWTxTFI5uXnYPQoMi/hglkS95Wf5aEU96pzhoOf91+BmPKxGUQSaAwZda5B67FThE0ZlJ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/3/25 18:22, Prakash Sangappa wrote:
> 
> 
>> On Nov 20, 2025, at 7:47 AM, David Hildenbrand (Red Hat) <david@kernel.org> wrote:
>>
>> On 11/19/25 17:31, David Hildenbrand (Red Hat) wrote:
>>> On 19.11.25 17:29, David Hildenbrand (Red Hat) wrote:
>>>>>>
>>>>>> So what I am currently looking into is simply reducing (batching) the number
>>>>>> of IPIs.
>>>>>
>>>>> As in the IPIs we are now generating in tlb_remove_table_sync_one()?
>>>>>
>>>>> Or something else?
>>>>
>>>> Yes, for now. I'm essentially reducing the number of
>>>> tlb_remove_table_sync_one() calls.
>>>>
>>>>>
>>>>> As this bug is only an issue when we don't use IPIs for pgtable freeing right
>>>>> (e.g. CONFIG_MMU_GATHER_RCU_TABLE_FREE is set), as otherwise
>>>>> tlb_remove_table_sync_one() is a no-op?
>>>>
>>>> Right. But it's still confusing: I think for page table unsharing we
>>>> always need an IPI one way or the other to make sure GUP-fast was called.
>>>>
>>>> At least for preventing that anybody would be able to reuse the page
>>>> table in the meantime.
>>>>
>>>> That is either:
>>>>
>>>> (a) The TLB shootdown implied an IPI
>>>>
>>>> (b) We manually send one
>>>>
>>>> But that's where it gets confusing: nowadays x86 also selects
>>>> MMU_GATHER_RCU_TABLE_FREE, meaning we would get a double IPI?
>>>>
>>>> This is so complicated, so I might be missing something.
>>>>
>>>> But it's the same behavior we have in collapse_huge_page() where we first
>>> ... flush and then call tlb_remove_table_sync_one().
>>
>> Okay, I pushed something to
>>
>> https://github.com/davidhildenbrand/linux.git hugetlb_unshare
> 
> For testing had to backport the fix to v5.15. Used top 8 commits from the above tree.
> v5.15 kernel does not have ptdesc and hugetlb vma locking.
> 
> With that change, our DB team has verified that it fixes the regression.

Great, thanks for testing!

> 
> Will you push this fix to LTS trees after it is reviewed and merged?

I can further clean this up and send it out. There is something about 
the mmu_gather integration that I don't enjoy, but I didn't find a 
better solution so far.

I can try backporting it, I would likely have to try to minimize the 
prereq cleanups. Let me see to which degree this can be done in a 
sensible way!

-- 
Cheers

David

