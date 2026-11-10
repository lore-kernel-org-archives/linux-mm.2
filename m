Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E973F60A3809
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mXDQi6ec
Received: by kanga.kvack.org (Postfix)
	id 066E46B05B0; Tue, 10 Nov 2026 06:16:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017BF6B05B2; Tue, 10 Nov 2026 06:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F806B05B3; Tue, 10 Nov 2026 06:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C36F66B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:16:42 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFD631C41A0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:16:40 +0000 (UTC)
X-FDA: 85418956560.18.3BA198C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E10F1C000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:16:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mXDQi6ec;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLz9hx8CAp1ag+6v5+Dlodbc+flGm+0ULpgjqw2vC4M=;
	b=AKsf9aRikDsw+Lr7rctSS/YrQP4rWvX9PG3z9x54Xj8PhZkZui7lxUJtlMsaX8MKcq2zTu
	Yo54ccsZfj8c7d/8Pt3QGYsDt1XQBxYB8MAaG8iL/2OoA9BtQLW0IZ/hczfmRIfPFq7y78
	7yTVmGutAqAx0jXvaK+cVVbd8VIDcdc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mXDQi6ec;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309399;
	b=D8iYL8NVy/2IvfRlpLVnmKjXAOakxwuIGZgC9mRmFrkMMjTHE98pz5p2VQPzkeg6KHvu4X
	sxyEdqtT5FTGsOuZZ346b65FQAdGbABobi563/35pLD+aoewQJOS5B+D//eQMFiTwtSzoc
	fRXozhw87FO3myJQ2ItB1fseXIJC3Gs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2104345D0F;
	Tue, 10 Nov 2026 11:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4CB1F0089F;
	Tue, 10 Nov 2026 11:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794309398;
	bh=SLz9hx8CAp1ag+6v5+Dlodbc+flGm+0ULpgjqw2vC4M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mXDQi6ecbnU18RTWLLP+HEpdyPMnDu8kGFbryS2jkErxLQtO8bWbpB8cDvOlIsthk
	 nKDswTy0j41g09VOzZfNAk3sFmE1dAyL8kLrKYy13JFBcIykGKjC6dOBSOZd0IS2ax
	 wRkgYmCmyJq6KBkYW92eMZQGj+NLVzodTDm3yzeDpgSqURAgo70abus9Eex+sE5vfP
	 L5xVYJg0FOUChfCutdMQo9ZH0mTZI+3GLZtVa9U7Gy1ML1MHVR/Xk0/fBXbQaox7aZ
	 IHc8Hf44YW+wl0jVbzgjK9ZxL0CaSsab4Jj09ycECHK37fGVnYjFMLmbnOhC9kn8bX
	 IET8sHKwVmKog==
Message-ID: <c94d09e5-78df-454a-be27-f2208a39779a@kernel.org>
Date: Tue, 10 Nov 2026 12:16:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix mlock state loss when migrating
 PTE-mapped large folios
To: Wandun <chenwandun1@gmail.com>, hughd@google.com,
 akpm@linux-foundation.org, fengwei.yin@intel.com
Cc: ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261109090846.1068409-1-chenwandun1@gmail.com>
 <fc3c1e68-9321-46bd-9f1f-4209bf5c6a7d@kernel.org>
 <dff3e90b-f03a-4dfe-8c53-fd65db20de1b@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <dff3e90b-f03a-4dfe-8c53-fd65db20de1b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5hn9tkgmqbhr45fsqjpmkfzu35rxdo8x
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: E10F1C000A
X-HE-Tag: 1794309398-614641
X-HE-Meta: U2FsdGVkX198a7qHR25O2S8dGkELAoZE6YTjMRayHKZbEJdSfCC9nrBRUoya1hKddgL3PBQxL4uUvoF+Ij1Qg5PZ/+uVWwbPOfsmdpkUg24wd6M7Q/AhA7NTr6BHtT2mNe3RjFVWogk85BpqH7r9DC+cHHiATjbHQ1cXJdox5P7P7ywcLusqnkbizSC8VKCmUA02P5jOL848nVD5pfLOAbw8Ufl8hu+LWRBLK5ZKDCpJTL4YwXHzhXF8DEfYDdrij2JWRUgz/2pYwZi5KpJ60y3n67YrcxqdjrdjD0h+gIVTKwQfzAb+s72KXWNJbZXm16FiIv/Ri9dlYJh5OFWYjM2eMYnvIN0zbkdcQMiOpnDIg5Ee6OT53L+0KNhLtpF8NfnJI9lisBVFcVSt9+aGpQSaVuY26Y2xbEL7OWufLHU1qIxhopkJEOM2Mramfc0bkIqn+Azf0La2ujsxFL6B5eMFMemW8jHdAavfrx+XsJSfVh4H29qco5vUFGG9gZz3WFmY4507HIBgCkC1bR7qPNeRf2fe2qqmjjLyFgJs7j8/xQy7G5hb1+ykqZVjeUCyK7jLj9YdE3w7Z9TFi40/0KUQSJI7S/SfriBE2lJk1MNPpwSv4mX9DcCJR+3JWY3MRxyo5CIGcyFrIAIdG76qezyMirbgSwHvssCMhnDE+d44dY+zaFLzldViGlNIlFZ/9hYKVPhN+ir9S+IbhbMXZlDvWIvsuPIg6K4Bm9/IBUGPmR25GpWk/6wO/7Ea8DyHxqbMDrCrtU02sGO/Wk2TCRUIyDPz1hFQ8IUN6pXqweuS6DmWgPXEYT44NXFYVWX2q5C8MKJmeBpkxM1UoZMrYEdP+WCc1tkVxKMQZPYKD1N7ry9OYJAAv37iDkVyufW4X4N+OKeh9mc7+e38TzKIObzDyUhLsdYfGwvX41yyv8kHZYKRLq+j7MEhe26DOqeEVOzvTjBaUBBPdr7D7iN
 4hmANaa4
 yW3LEAN2tSoDJW1HEE0EGhtFuNwkkPz22EFLR5v/qP+7wsePzsPawwS+qo0qOllvnKEsXLkznIXDMwbBnraeYd70s12gwYxXkijFhLcOvODObioWczQUrTKN2tuvWiN0r1sOXzDLz3iHVUmLrpJV5wxpL5pHlBX8rcHVgWBicxHYfaTx/wxV/XXwPxfW+pHr4Wd/l0lE9wiW4Rl670a3r9xan8kPGNW14pvEBd4o4WQCkFJyWir0uU2nL8d4JB+3clZDdM+Zcis8ucxNMS8SYRLI8EQbLvnZ0B7qXc1OBv7+fTI8FT0DW2HoqGmPAFGR+1GENsCzAjMImEfW21TVYUagBM2hut3BXCDflpcCTuifUDCOS9wPaWt7RCPvVfuLWZBhmliUd3afWWc8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 07:27, Wandun wrote:
> 
> 
> On 11/9/26 21:51, David Hildenbrand (Arm) wrote:
>> On 11/9/26 10:08, Wandun Chen wrote:
>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>
>>> try_to_migrate() clears PG_mlocked when unmapping the source folio.
>>> For PTE-mapped large folios, remove_migration_pte() restores one PTE at
>>> a time, but the rmap helpers only restore mlock for full-folio mappings.
>>> This leaves the destination PTE-mapped large folio without PG_mlocked.
>>>
>>> Restore mlock once all PTEs of the destination folio are restored under
>>> a single page table lock.
>>>
>>> Fixes: dc68badcede4 ("mm: mlock: update mlock_pte_range to handle large folio")
>>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>>> ---
>>>  mm/migrate.c | 10 +++++++++-
>>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 94033c222e04..140e291d4587 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -353,6 +353,7 @@ static bool remove_migration_pte(struct folio *folio,
>>>  {
>>>  	struct rmap_walk_arg *rmap_walk_arg = arg;
>>>  	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
>>> +	unsigned long nr_ptes = 0;
>>>  
>>>  	while (page_vma_mapped_walk(&pvmw)) {
>>>  		rmap_t rmap_flags = RMAP_NONE;
>>> @@ -446,9 +447,16 @@ static bool remove_migration_pte(struct folio *folio,
>>>  			else
>>>  				folio_add_file_rmap_pte(folio, new, vma);
>>>  			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
>>> +
>>> +			nr_ptes++;
>>>  		}
>>> -		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
>>> +		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
>>> +			if (folio_test_large(folio) &&
>>> +			    nr_ptes == folio_nr_pages(folio) &&
>>> +			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
>>> +				mlock_vma_folio(folio, vma);
>>>  			mlock_drain_local();
>>> +		}
>>
>> I have the recollection that the next try_to_unmap() would fix that up? Or is
>> that not the case?
> 
> It is the case, try_to_unmap() can restore it. However, until reclaim scans
> the folio, Mlocked in /proc/meminfo can remain undercounted, giving users
> a misleading impression that less memory is locked.
> 
> A similar fix was made in commit
> 	ab521b4142aa ("mm/rmap: improve mlock tracking for large folios").
> 
> and handles cases where an entire folio is added in one rmap operation.
> 
> However, when a PTE-mapped large folio is migrated, remove_migration_pte()
> restores PTEs individually, passing nr_pages = 1 to the rmap helpers,
> as a result, PG_mlocked is not set on the destination folio.
> 
> This patch handles that case once the full mapping has been restored,
> rather than waiting for try_to_unmap() to restore the mlock state.

Please revise the patch description pointing all that out :)

Note that ab521b4142aa wasn't a fix (no Fixes:) why should this one here be one?

-- 
Cheers,

David

