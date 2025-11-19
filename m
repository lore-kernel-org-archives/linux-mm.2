Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07AADCF34C1
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 14:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E5D6B00B0; Wed, 19 Nov 2025 09:50:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645D76B00C3; Wed, 19 Nov 2025 09:50:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C226B00C8; Wed, 19 Nov 2025 09:50:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 409746B00B0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:50:45 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2C5B14026A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:50:44 +0000 (UTC)
X-FDA: 84127643208.06.9BB1701
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CCCC740011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:50:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JnYPV3Fp;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763563843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaltSG5V710R6lvNyS+8ek/TktD7xbJTLEIz+gJsgdM=;
	b=OavxhqF/iWe3L7ywviHk/yJuZce2YKpm7GOyV9/dQxDNtpPQ147J8G085a5kU3mVr3QbnI
	pGHbQiBqHeAnZHgWUZrH+htisPoXRIUDf73gAACswzzvW88D6yyKkZX+/N6/57p66gV0eH
	J82yz1DG1kNJGSWJdxdDsNfJanU9IJ4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JnYPV3Fp;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763563843; a=rsa-sha256;
	cv=none;
	b=Yrb9lKKtV7S3TkoqgySs+xhrB3+QLm/Qgd+8v1VrumNQ0SwcIPzzKqR+tBL3Cp/ck7MXsF
	lC1Ya9+qdGzIBiUUJXEl1imLuHBMkTbOM7XedDEPZtaoz0yMPZKXVB10qMYa0jBGznXcHR
	F4Ko1WjHhucA3XBMPOlIAJWgySGtvMg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B631543962;
	Wed, 19 Nov 2025 14:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C86C2BCC4;
	Wed, 19 Nov 2025 14:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763563841;
	bh=C7L8AD1VDWfDXe49RsbapDdAr0DeidInHjCfxQzy1oE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JnYPV3FpUp/k3neEOsCT4TUGUOABBLtEtTBds/BCvGaYmoDK1B4JQrHn0Og4hJQ1R
	 mm6DB6h1vGPMo1xuOGCf1Xoue3IeRUyKKHwIgiKGbDUr3MbM5SQqHIzfylTfBYrVfw
	 9S8cd9ZuFMUb+4C9K1EaoRy1PEtYb0a8ou4jtFxJ4B9sywPuwm/0BTV+4GDV7kQosk
	 LnB67sh8fYLMrKuz/NyvpA7GJYUvQLENHU7XrogKzCz5mDpAQW2+iIGGzQjsWzs61F
	 PHRrx02sFscN6Gm639nIgqpXzQtC1x+UtWuUOxk1Xuuv5E0NFDThxJUK9NXYTw1xbP
	 FkgIa/M/CkjMQ==
Message-ID: <2528b24c-6a14-4270-b1cb-f417ecee59c6@kernel.org>
Date: Wed, 19 Nov 2025 15:50:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when splitting
 shmem folio in swap cache
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
 <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
 <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
 <4f9df538-f918-4036-b72c-3356a4fff81e@kernel.org>
 <FA37F8FD-DDAB-43B0-9BEA-2AC25986767E@nvidia.com>
 <822641bc-daea-46e1-b2cb-77528c32dae6@kernel.org>
 <14253d62-0a85-4f61-aed6-72da17bcef77@kernel.org>
 <9C8CDE11-44B2-4C55-897B-A4F3FD695EB5@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <9C8CDE11-44B2-4C55-897B-A4F3FD695EB5@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CCCC740011
X-Stat-Signature: r9wssm8if1r66k8cwrqinzxq6oj7i57z
X-Rspam-User: 
X-HE-Tag: 1763563842-907951
X-HE-Meta: U2FsdGVkX19954IJGU3EMDiUDsE+9PSnysqaI1UV3R7wpsswMGfmV+33Tv8p8Fhbn0L1XdJG2Z+Mr+VOdkNj1YLYcpo7gjrzTnER/04xVYSoGe4iL1qn5jz44BwdeSDXynG+f+z0cFh8Wl8tvWGjHrp1an1orecutzUHrOWmgoBuiPrBJpYuCL9fqjRDmilX82AdWKwqraNfUN4MON82AzUn5dyXHiqtSdowJsEUM5lVXrBrGrBOTH+KLLDCLOBWzqOa2N+xsvyFBbd713QWPeuoXqvFBu+RC9GmqxV50UC8LDIc2vjXw7QvhoqkQHy3RSKnmdo3WXikIjjQ5odCeIAwEOMM4GYlWxb5YTeVKebkvvcbdaZ1WnQsPptZc+XZbllSgD+GLt7BGmlsEIAridrPuJVqAAM7R0ZayTWxKgXDUCJXm0HOZ+FOlbXkmVh7nEIqiUv3QmYRSKELNHlisyDMHMtD/i4VHtU9Ew0DJrstGPQERSGj1vJhdgiiGZiHGFG9DkgNnzBO+1A+eB4lKKMRWjvlI8pO8KXci7ko0p38naIlu6w2qRQtO6sS9DUJ/RkTEbWiPToFhfQNDzNmtEjdY4Hduikzeh3MwvhzUaY66b8cB3dlA8rG/Sf1Rlwe2OjCgVIFdMFC092LWLhA6tAy2nx3EpUxS+GftZxaHaR4ceSxUC2Lt/QgXIFB4q3MNGO/BqjZbhjlfNBhaEqWdO/g3yN6tNv2YsVar0rKtFxdUA0nZP9lSDmdR6oWI39hZ3AF+MiYlHaybrelgR7PabHptfGt8jUkXsnpDYwydrtimNnH3FYu1jlYWcMOkaRjrVoEx7s/W3Sqh+kQaZ5Dv4zJRTVnPCBePSPUvDYtAxyYgFZZO33mzbRRnci8xlk0VnPNcPxAoomHnNy+7MxkLekf/T0jAmKaP+FY37iibj0Dz7Sis44re7vB1Y+PipMST6A0MBa7x8YRM7h6mOi
 EZqSIc/s
 qqIH6vxEiV597kv4WaEcF36czGrFwdhSLXq9NOztOX7JD+dipnEHwNqAb/apZBc8G9y6U9wDNvpvUMLfFFbKb4OZb9b9F3eGsWhNBckUguId9dkSs6f10crU0if8nEnMZJ5+cxURXgzSY/jCMXS5wzuMIoHEFS6e3UpvJ4GTII6of7RZ38IGaFL6RlBQPeUXVOQND/BYZWeM/2KV0rvy3EgesBipy/yu94hlhAmDDaFbCIrNZkkCv0KaWmveXMX67M8cTtO4n2Ccvn98j3B4CZGh98MXR3aCfZlbuZ5wFHal1aoey+6wkutPSQhj6eYBFeBmrQpDVIXPMIkQcqvNYoYFXIhma0QxYROzRzOygtlZoO+nK8JylWp/vvVinBBoiNU3S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.11.25 15:48, Zi Yan wrote:
> On 19 Nov 2025, at 9:46, David Hildenbrand (Red Hat) wrote:
> 
>> On 19.11.25 15:37, David Hildenbrand (Red Hat) wrote:
>>>>> Given folio_test_swapcache() might have false positives,
>>>>> I assume we'd need a
>>>>>
>>>>> 	folio_test_swapbacked() && folio_test_swapcache(folio)
>>>>>
>>>>> To detect large large shmem folios in the swapcache in all cases here.
>>>>>
>>>>> Something like the following would hopefully do:
>>>>>
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index 2f2a521e5d683..57aab66bedbea 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -3515,6 +3515,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>>>            return ret;
>>>>>     }
>>>>>     +static bool folio_test_shmem_swapcache(struct folio *folio)
>>>>> +{
>>>>> +       VM_WARN_ON_ONCE_FOLIO(folio_test_anon(folio), folio);
>>>>> +       /* These folios do not have folio->mapping set. */
>>>>> +       return folio_test_swapbacked(folio) && folio_test_swapcache(folio);
>>>>> +}
>>>>> +
>>>>>     bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>>>                    bool warns)
>>>>>     {
>>>>> @@ -3524,6 +3531,9 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>>>                                    "Cannot split to order-1 folio");
>>>>>                    if (new_order == 1)
>>>>>                            return false;
>>>>> +       } else if (folio_test_shmem_swapcache(folio)) {
>>>>> +               /* TODO: support shmem folios that are in the swapcache. */
>>>>> +               return false;
>>>>
>>>> With this, truncated shmem returns -EINVALID instead of -EBUSY now.
>>>> Can s390_wiggle_split_folio() such folios?
>>>
>>> [noting that s390_wiggle_split_folio() was just one caller where I new
>>> the return value differs. I suspect there might be more.]
>>>
>>> I am still not clear on that one.
>>>
>>> s390x obtains the folio while walking the page tables. In case it gets
>>> -EBUSY it simply retries to obtain the folio from the page tables.
>>>
>>> So assuming there was concurrent truncation and we returned -EBUSY, it
>>> would just retry walking the page tables (trigger a fault to map a
>>> folio) and retry with that one.
>>>
>>> I would assume that the shmem folio in the swapcache could never have
>>> worked before, and that there is no way to make progress really.
>>>
>>> In other words: do we know how we can end up with a shmem folio that is
>>> in the swapcache and does not have folio->mapping set?
>>>
>>> Could that think still be mapped into the page tables? (I hope not, but
>>> right now I am confused how that can happen )
>>>
>>
>> Ah, my memory comes back.
>>
>> vmscan triggers shmem_writeout() after unmapping the folio and after making sure that there are no unexpected folio references.
>>
>> shmem_writeout() will do the shmem_delete_from_page_cache() where we set folio->mapping = NULL.
>>
>> So anything walking the page tables (like s390x) could never find it.
>>
>>
>> Such shmem folios really cannot get split right now until we either reclaimed them (-> freed) or until shmem_swapin_folio() re-obtained them from the swapcache to re-add them to the swapcache through shmem_add_to_page_cache().
>>
>> So maybe we can just make our life easy and just keep returning -EBUSY for this scenario for the time being?
> 
> Exactly, also an easy backport.

Okay, let's do that then.

@Wei can you send a v2?

-- 
Cheers

David

