Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 210B5FCA17A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 19:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C10E6B0005; Mon,  9 Mar 2026 15:11:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC7F6B008C; Mon,  9 Mar 2026 15:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CAE56B0092; Mon,  9 Mar 2026 15:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5F16B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:11:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 955A016032C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 19:11:31 +0000 (UTC)
X-FDA: 84527468382.16.F8348FD
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf26.hostedemail.com (Postfix) with ESMTP id F1FE514000B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 19:11:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vFiXUTgr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773083489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4mG+t+RXYYFo6HmjRVakUrKTlFJ7ROOygeekLGG8TY=;
	b=0VLJudl0gWJDy0RBfOzX3re3wGmti4KGAWJqAG10l8qg4pkj2WAWCR188E9ZYuK5+PZG7X
	LadMN+YTAn3RNBUrN/mTKOQmFmVDuckVrWVU2NmslJWjJEHUjL1+7jRZoKI+GSAe1Dxk/P
	suJDjUSotgbIBEb9CMlBD988rmfpDOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773083489; a=rsa-sha256;
	cv=none;
	b=bWXCX2nszLknrWM3o1v8zhsFxMI44ENjFHr6gFKjoSa3zwq04fom0tAZw+wKHSHSF1NdcF
	02cg9/mmZSogrH8AsIg+DxLud6fhcyQB8jYLA6+2VY5rnrI+LMeYoaaH7uif/pO0nbPxH2
	iRaqCcrNMPcNtYegGVIBVVAEyRRXCSw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vFiXUTgr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
Message-ID: <a9404db2-d8de-440f-b407-fdc489b00f7b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773083485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t4mG+t+RXYYFo6HmjRVakUrKTlFJ7ROOygeekLGG8TY=;
	b=vFiXUTgrZJ1cpUYR+sGtEhO2tybjtnLZl7GWxczInonCmn9eljEUISVRbk75dWa1ua3QaN
	bMKjff7b8mf4Y5usYdQZy+en1dwCQsWWwi1+wTA2faaV/vB8ZDD4q/OAfIoHYtvL+XwZgJ
	7XEQQuneWtuvrQ6yFX370zPDrHyTRN0=
Date: Mon, 9 Mar 2026 22:11:20 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] mm/migrate_device: document folio_get requirement before
 frozen PMD split
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, linux-mm@kvack.org, mpenttil@redhat.com, balbirs@nvidia.com
Cc: matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <20260306104409.3915811-1-usama.arif@linux.dev>
 <c74e3941-f977-4b19-9d71-972bd9ed5c60@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <c74e3941-f977-4b19-9d71-972bd9ed5c60@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F1FE514000B
X-Stat-Signature: 1b8rc7871tkcx6j4e1hsbpdt6syh5w43
X-Rspam-User: 
X-HE-Tag: 1773083487-328048
X-HE-Meta: U2FsdGVkX18P8yBeU/JKaG5v5eiBxZBCapQq5g2Ykj3Hydqksh/fRyJog2BNFOzchrvAQhnJz+EFnFAz6hP2dOL+Rk5zk3u2zfgw1JnwEw+Sw4e7qj+mDuG8sHuQN5cvtN8gnuRbm6w+Id3NlQF5cLi3sRwRaK1BlDtScoDJ2eRubisM0FwU6K+oFqFLxZOnKhxemGd4IFE9J8cO7tTDEtHSlRYs+Wm4YrvQe8ttEyyL+54d6zm1jTW9JAGonTpeI9K0q8CEYiU8RTH6fCq2egQvCSdUh4DC2QvpyR36J05soJfkBrhfMWrPY3B/PxS2Q4YzBCE794bQlR9yk/+HR/UikVeUpoGVZr1quBA10d+BUAz14ungtoceuVFuBMSofvaCPoGvag1xbX7kMFdsCh49casvUKkcbOXvT/5TEEX1SDH9Fj/slwQDI0d76KG52t05dP01nJAgavZPrOoXq/alvVumolhc+7wSshIlA0Mltt6XfzLjdFZMjDJlorqvB6xKnSgh6ngWt/4Smi6N58t+UiGDkploJm7baTDFzd05wJkhxXM/6A4Oef1X1Yr45fkI5oCQu26fmxkhZYCEPp8U3FZ5w03qVbRzJK+IfumoWmMaBgULJIq/uLBSSFNnIi8Krr0b8oaJFNQeID6lLaqbsFSkDiQNyCxuezq8otcgA3sDig5tJDGrqHeySK2R0rVYR75FXQd1WAXlRwGgM3E2G8DOac3zB1JBLj4OQmNc7bRBRe1oYHV91izmwBE7oiH3X6+4XD+UyDUVC5cMceAzdKitg/2n8XPqGN978IoeBKBR4FgDSAVF1zIpZ43zCPUlzXudZl/zQGnCUqojlLkSXKNHkzPlE5qfWVPezjUSNGUdpeMlpjmVrVgQ/xDKc5f6WHQFh4TN02NMtvFCTJ8pXDuJO1+lMmSBCWayK5DnPkpWW2fKMxrfX/KV8UgS7u2Cn5StTHrbemmq+wD
 naGCaoE2
 2aF88xJ5vGUyrIr6VMVx8Mv9oZSc+QuxjX7ai7rOeucC72+JZoOWOxZArY2eDvFi66vl73orhUp1qXfNR5ONwQJnhcs5u0nzotChvCBQh3aQhrAXZTIaF4zOSFj9oN5ZSJoQktgWFv4P/D+e1PTMspUpRYViXQGosDn/2ONqXc1G5aPMSZytTn5CAHxVY2Ulebhm4Trp4pFLDl1TF/8YJs02q6E0jYhm8FSL5qN5f/GA0EBRXE6aE224NtzpoT7t4cVBVCitEbTJaptFKxadpQHLG3Cv4iDt23+dz44i92OKshKwb6lEU/kB6r+v+R0lJuyq9Fip96MWNgwY7JUvTntlDaFXwyDaW9EFz7UZb52EkF5S2J5jj05FnhzNugBB8O3xmtHvkJcS4H7T1939J0HMgSDcFXSubsI9c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/03/2026 18:18, David Hildenbrand (Arm) wrote:
> On 3/6/26 11:44, Usama Arif wrote:
>> split_huge_pmd_address() with freeze=true splits a PMD migration entry
>> into PTE migration entries, consuming one folio reference in the
>> process.  The folio_get() before it provides this reference.
>>
>> Add a comment explaining this relationship and a VM_WARN_ON_ONCE to
>> catch an unexpected refcount != 1 entry state.
>>
>> Suggested-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/migrate_device.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 78c7acf024615..6fa2878848a7e 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -908,6 +908,11 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>  	unsigned long flags;
>>  	int ret = 0;
>>  
>> +	VM_WARN_ON_ONCE(folio_ref_count(folio) != 1);
> 
> Can't we have speculative references here? In general, asserting that
> the refcount has an exact value (besides 0) is often shaky.


I hope not at this point in code.

At this point, the folio is locked and unmapped (both done in migrate_vma_collect_huge_pmd()),
and the present PMD was set to migration entry. It is isolated from LRU in
migrate_device_unmap(). So the folio should not be visible to GUP or reclaim/compaction.
Only anon, non-swapcache folios should reach here. So it won't run into any folio_try_get
in page cache or swap cache.

The folio_get() done in migrate_vma_split_unmapped_folio() is consumed by
split_huge_pmd_address(), and folio_split_unmapped() expects a folio_reference
of 1 after this [1].

If its not considered good to assert a non zero refcount value, I can change the
warning to a comment, but I think refcount should be 1 at this point, otherwise
folio_split_unmapped will fail.

[1] https://elixir.bootlin.com/linux/v6.19.6/source/mm/huge_memory.c#L4137

> 
>> +	/*
>> +	 * take a reference, since split_huge_pmd_address() with freeze = true
>> +	 * drops a reference at the end.
>> +	 */
>>  	folio_get(folio);
>>  	split_huge_pmd_address(migrate->vma, addr, true);
>>  	ret = folio_split_unmapped(folio, 0);
> 
> 


