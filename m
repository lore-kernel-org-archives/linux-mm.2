Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14294FCA180
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 20:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2A36B0005; Mon,  9 Mar 2026 16:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA516B0089; Mon,  9 Mar 2026 16:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB666B008A; Mon,  9 Mar 2026 16:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6886B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:23:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE970160369
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:22:59 +0000 (UTC)
X-FDA: 84527648478.24.899627F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 15F781C0002
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:22:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B7IXhROP;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773087778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ony86vlpWyV9HxJI36xrzExnDaWzxdFkE1yJ8v1zi6s=;
	b=l7c34/g5obrUhsw+00evlToN9pN828CqL7UWeMyZz2oPPxxjwWq63K3K6fMy2Q9EKt2Y/L
	9le1AWBDUK+XTriVOSEmReGwtTDZtCCBS6F7ezqUDPkKGDsYMPzKp8uja6oybx40/NtYMl
	rSqi8elLcAehYVHbIRCaPY0X/BfZyac=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B7IXhROP;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773087778; a=rsa-sha256;
	cv=none;
	b=6Ei7yYSM9Fepw68phLWRS8/MNV2vCq6AueGRple3nVhO3Sx/W+msFmAMsPD6Ch7xyQOpET
	qu/yHpVNGmXf01DvFVyjOovZmH9MRpBcQI8T4gJzz0LKyi04BnyXevrmezvj4jO5t6Si+Y
	v+YqWsMxjQxV1ZPU67urjuDJ+gER7QQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A50E60097;
	Mon,  9 Mar 2026 20:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D480C4CEF7;
	Mon,  9 Mar 2026 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773087777;
	bh=fSaRukjxWJ92UeSz7ouhJj6LJujaYf3lOtbd8VWs+TA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B7IXhROP5eZaXsujy91kFeFuniY2+1W+nwoEZozilAP2brfi+8rz1JbIlV6ol7P+p
	 V6t5pR+3rlrrkGCvtbFw9bEEbbZQBxsm7lmTJr7vcpBareDfr6A4WlSwQNc/UwIEiO
	 qnBl+RjBDaOPCF0hnKp0+P9NWjWc9zS9IvOE4KSGmx71BRJpo+kBm/PvY2sOalQtya
	 6XVS2O9/7+xXHk8awhoAnFPDfM5SRQUBzZ8F+p/WSAC8QFFZ477HgjcCjxQ/Vu6+sE
	 M5np1cHKF+kjVfZf97LZP0j4P84yuGzmpX+fX4034G+TyFdcVAR7OmnUD1OroDGCbF
	 XCZleASryZAJg==
Message-ID: <57cf14b7-e5cc-4298-9d56-978b855e3276@kernel.org>
Date: Mon, 9 Mar 2026 21:22:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: document folio_get requirement before
 frozen PMD split
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, linux-mm@kvack.org, mpenttil@redhat.com, balbirs@nvidia.com
Cc: matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <20260306104409.3915811-1-usama.arif@linux.dev>
 <c74e3941-f977-4b19-9d71-972bd9ed5c60@kernel.org>
 <a9404db2-d8de-440f-b407-fdc489b00f7b@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a9404db2-d8de-440f-b407-fdc489b00f7b@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15F781C0002
X-Stat-Signature: kn9xke7uabtay59xdzb9k3o5cdeaj1qy
X-Rspam-User: 
X-HE-Tag: 1773087777-302977
X-HE-Meta: U2FsdGVkX1+Y8Sz6e3AwMtt4VEKyX7nvx5EiiiFv97i9SmY6PPCsxigfb+qqjqdg3VjWlNtKBuwE/1p8+IaDA2qPWyJneHs8UJHjCQGMGyfvh2ePxVvLa+z+1PiMoW63Ixd9T3GXgAhYpa3VorlPiPDFil5xWcsZLC7ZFZKpyiwrZenpzI6vHz0hcalT1OZenPily/2OoXIUsn56IldLbtdVOcNgS3fsuP8dZNw+bffkL25KrTbxIgWZXPuneULxSvc81NuHdxLuHQjkbmC3rBx0mdCMoHM8wzD6e+sfeVbW9Xc1oCiAZJ94fSZiF0eNXqbjRI26oLICIC1cBZ17guQ7p3g4bbj3yhyhUWv/miJnFJPeu7ARegK2H8mZm3sGnMg3V3G65QmWIb5UjwRjb/YFgybmpp4aGpUWeR/82XmahSc5+LvKgcUkKKOTzi/Wl2UUL+kyN5Bu/nF7uokGzqgqZFqLA3POTlyo2s5gK3TxrkEXH4JFZIT9xNt+ZTzXget3z8ruMLggyR6bWWFMipNuVYb8tR5TvLWy/tADKNGo3jhSIwSJTMUOvMGsDYv9eYQbCn3aDHXmj3TGs0yGjL2Ds2H/XVCqDm4jHqgLYvUmJ5yFPR0HJlIylVwmkPZuIHt0L6eVE9leM45e2yhMlNoZpEmPro5iAuvQrk2lTmeSk62okWQ9sLA6BtSSPeLBIFJNyFhfQ0pQN2AiHbQzh99t3SgDEy+NKi7sSbUDkIlrdjnKXW69YmCoiw8YpaC42OcCtmYyz6Phee+3kv94AZaBW1v4ydXhd4UGuLBk5A21lD6mjgWYCLHejzws2FWYXOmhqqRMURu0gUWN5rK99E43QMrUbBAFhzWiL2E8wqCEhzzzQksbmCZ9KZMBH0GVQXhb+MMI1NNRrUF1d3RkXv7wLwRYZ5iPFcv4h0MxxQeAU3gJiozOBb1GSTyQV0RyY74E23jbsWteLRdNYxD
 BvrFS38e
 /4Ih6t9Ps+mMmpYbrQmuZNsCV6CLrD9SokR+qk8EHNNKHGZHvtTudGjaH7BbS4L6Bjq50tfe4YqUaF/fZPYKpF5kPuy/+XBDlaykZNhUY3RzujOXTUGfn/cgeLH0GOJjSpzT5ikIRvUAVHlvtkezQJsY/20VTyc80O89xS/1YVai00UJJuyvY8f398cG/WIKHCLQfb92jYK5mj1pLZJK4x7RVNANL4Z6OP9166SJnzIct3r/iZj9PZbJnJ/I1fh2XXDvCuOcNFTHCh/Eu1WCorm0higeuaQYW1d2rzBQZt17u7mPKnymWsDtoueNNxRm301z2SEEAgys1my9Z1lYGGTCSMfb+kX+oO9goTvl1aU/Pb4PD4xjnO4LQU39ez5oe/aSOjHB9yD0ZT+bPGQ/XLFosOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 20:11, Usama Arif wrote:
> 
> 
> On 09/03/2026 18:18, David Hildenbrand (Arm) wrote:
>> On 3/6/26 11:44, Usama Arif wrote:
>>> split_huge_pmd_address() with freeze=true splits a PMD migration entry
>>> into PTE migration entries, consuming one folio reference in the
>>> process.  The folio_get() before it provides this reference.
>>>
>>> Add a comment explaining this relationship and a VM_WARN_ON_ONCE to
>>> catch an unexpected refcount != 1 entry state.
>>>
>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>>  mm/migrate_device.c | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 78c7acf024615..6fa2878848a7e 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -908,6 +908,11 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>>  	unsigned long flags;
>>>  	int ret = 0;
>>>  
>>> +	VM_WARN_ON_ONCE(folio_ref_count(folio) != 1);
>>
>> Can't we have speculative references here? In general, asserting that
>> the refcount has an exact value (besides 0) is often shaky.
> 
> 
> I hope not at this point in code.
> 
> At this point, the folio is locked and unmapped (both done in migrate_vma_collect_huge_pmd()),
> and the present PMD was set to migration entry. It is isolated from LRU in
> migrate_device_unmap(). So the folio should not be visible to GUP or reclaim/compaction.
> Only anon, non-swapcache folios should reach here. So it won't run into any folio_try_get
> in page cache or swap cache.

We have other pfn walkers that can just temporary grab a reference, to
immediately back off. So it's not very reliable to depend on that.

> 
> The folio_get() done in migrate_vma_split_unmapped_folio() is consumed by
> split_huge_pmd_address(), and folio_split_unmapped() expects a folio_reference
> of 1 after this [1].
> 
> If its not considered good to assert a non zero refcount value, I can change the
> warning to a comment, but I think refcount should be 1 at this point, otherwise
> folio_split_unmapped will fail.

Well, yes. folio_split_unmapped() will handle this gracefully (as
documented), without triggering a warning.

So best to remove the VM_WARN_ON_ONCE().

-- 
Cheers,

David

