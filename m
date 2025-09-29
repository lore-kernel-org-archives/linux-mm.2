Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D1ECAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 10:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471FB8E0005; Mon, 29 Sep 2025 06:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449CF8E0002; Mon, 29 Sep 2025 06:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386258E0005; Mon, 29 Sep 2025 06:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26FC28E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:15:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C141113A508
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:15:47 +0000 (UTC)
X-FDA: 83941881534.19.0B4D2C2
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8C2EE8000D
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:15:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gzO39fAC;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759140945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0lDTfGg/6Uyqwfi6NmuvIilfdfFny0fXjAuu0Bjee84=;
	b=5sVjrOPn7BsALXciWZ5mq6F3+zii46dM/m4IwYIQK03KGl13vdu5HmnvVLvUVTOJJk82+j
	4XzootUPXYHJaFpROgTvkGyfWh6QBRscCtZCPr+4YBE2fv9ViKDZiH+VnfTj3aWy1uv/D9
	Ruz2s5kY5z3GOjCn/eoJX7wnrkSJWzE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759140945; a=rsa-sha256;
	cv=none;
	b=hCFs9Ti+Vmb1kYK9B/2HDHaRenmn06mJKLvHfyZy3frhc0LOBCWrK3QWf7DlXB7Rb716gs
	RF5/IcQAVOXqgQL7iC3b+r9DeLiQIF8R7ZbuEov+AKbaHFdXSd241ppC4yisuWZkHZSwA1
	FLq6nj/2hS92vijfO1a6ORfqhWVTxeg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gzO39fAC;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e88cbc23-16af-458e-9f5f-6b06eff0d8f5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759140943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0lDTfGg/6Uyqwfi6NmuvIilfdfFny0fXjAuu0Bjee84=;
	b=gzO39fACECb42zPXJwdyj6Jv27mioHJsXOtNOgcfJ+jWFO9VImd3+gUNkHtBP/obtV3B7B
	pFJMjkkPJqkUu67chDrlvcIkKpsNMrW9Bn08O92QVgLhNIqIFhRQ4VYEvvxjJgrjLaQWri
	YMHMpUqryT0WsiiYzr+1JRdaCwrF8G8=
Date: Mon, 29 Sep 2025 18:15:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/rmap: fix soft-dirty bit loss when remapping
 zero-filled mTHP subpage to shared zeropage
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 ryan.roberts@arm.com, npache@redhat.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, usamaarif642@gmail.com,
 yuzhao@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ioworker0@gmail.com, stable@vger.kernel.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, david@redhat.com
References: <20250928044855.76359-1-lance.yang@linux.dev>
 <2065263d-a2c0-437e-a096-695c6d17f97a@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <2065263d-a2c0-437e-a096-695c6d17f97a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8C2EE8000D
X-Stat-Signature: iz5xr9acfdx7ar9xdttgdbktsb7rrtpy
X-Rspam-User: 
X-HE-Tag: 1759140945-385866
X-HE-Meta: U2FsdGVkX19WyjacFUww1d2Aba+T4hpLGpBWlgpHVJYC6xzS/wd0omgbDo+BxGWiq4jDFDeNuf2TgV68GjrEGffKFDxVmSdVrzkBen6pgoendmiGOe+xw/DS96/z3iz005ldKAg5QXu5iFgpuGs9v2DRtiN3v06t7RLEsUqde1sR2n4udKVZyhJSZ3T6S0nfW9JiwDSD30DbmUUIIZnIe7HV1iVtSqLDaAGjXxsXANWctr7JMWqAvRmgVr/TzPwSpEoWgGxtYwSyYkigH4/aJW8lnoGYj6D95klEeSHClA699LemdssPsZ94+v8HaUaJD8xfysd/JwzB0sH58fsV/MuKJ/VvBlxUn0fXHidd82arJfstgbiyRhrhNEM7oNIKWsgRqqJT0ZLA7goit4eTWP60rjgS4ple8NXCQ/VzeOu6zMK81hE/X2aRdc8sljCTxYbdLcXAep9uGOOk91N+5eK21MoAZiq85no47BVHnUc7FkGfgHsJaWaxx8+fpR9fRv1dUxs7G1NY6RCifGmoxjNC6sB9SSaTP9zd9HiK1vn9vqHJenw98GGu9gOgmReSttOECv9M2GeCPN+POu2latuo+xANfPSpmc9ppFbLuhjy/aWUcHriAneWjPC+xWcK/nPdfcE1ThIP+wuOf9Yx93p2xHOhVrIgTEbTYpjYLKA+EMRgXJZzd44vXOtDaECQaEOpOT9Q9USJR4uAAhUpLO7gSM5RTIIrmadkmwEKGVD852HyINX9cfX+4LyWsRqegtZUnkVWMG4Lrzcu4inDcM52AY9WDruvG6JHexGbbFhKs2U/6dKBgLbctzbh6ZQqlZuys1grRKJiO48/8PokZBaElA+FO6MnaR5oM93wF7szu0dlRmIz2iLG7+di48hRbS7SXAvuLSGyfx3dvKb3zoYdZDG0O/dLxdacJzN260xfMxM37zOd8CD/qlxEAS7zPoosS/QLAAFpxSh4K7J
 m+dQAPIL
 Eclsid5Xu8wDQ+InawhdDVj8uzKLwcwL9ME5FIz6U5WcIgD0ZNQRKlFZ6HMwxQ1DCbZXVLsMJ6+xUpvEPzQyYqJ8vepqllcXCdCTzd9Ihn44ubab4PH3BY/NfSUYLWihKkr5MoE/tlnvxnWnfpZ6qr35DJiYRNxJgqiLaaUlhzLLRplGbFqaMNXyec4AIUkCWXZ1nZ5zJ8JD5cssCgEJNrpdVrkSM+Bh6GOu7PYqDQE2/376df+nj1/FjyMuezmBDibUDaJasO3Hqp4VUX4cPadWCBtyi6JvfYlJLP0qa14Vj8c12f6A/dh+E02ZbLkNT5brO0LPq+9vVTSs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/29 12:44, Dev Jain wrote:
> 
> On 28/09/25 10:18 am, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When splitting an mTHP and replacing a zero-filled subpage with the 
>> shared
>> zeropage, try_to_map_unused_to_zeropage() currently drops the soft-dirty
>> bit.
>>
>> For userspace tools like CRIU, which rely on the soft-dirty mechanism for
>> incremental snapshots, losing this bit means modified pages are missed,
>> leading to inconsistent memory state after restore.
>>
>> Preserve the soft-dirty bit from the old PTE when creating the zeropage
>> mapping to ensure modified pages are correctly tracked.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage 
>> when splitting isolated thp")
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/migrate.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index ce83c2c3c287..bf364ba07a3f 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -322,6 +322,10 @@ static bool try_to_map_unused_to_zeropage(struct 
>> page_vma_mapped_walk *pvmw,
>>       newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>>                       pvmw->vma->vm_page_prot));
>> +
>> +    if (pte_swp_soft_dirty(ptep_get(pvmw->pte)))
>> +        newpte = pte_mksoft_dirty(newpte);
>> +
>>       set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>>       dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
> 
> I think this should work.
> 
> You can pass old_pte = ptep_get(pvmw->pte) to this function to avoid 
> calling ptep_get()
> multiple times.

Good catch! Will do in v2, thanks.


