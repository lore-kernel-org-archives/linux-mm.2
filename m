Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C45FFCCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 11:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A878E0005; Fri, 10 Oct 2025 07:53:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31868E0003; Fri, 10 Oct 2025 07:53:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B474F8E0005; Fri, 10 Oct 2025 07:53:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9CD8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:53:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0E741602B4
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:53:51 +0000 (UTC)
X-FDA: 83982045462.02.34D9E86
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id DCE92140003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:53:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e8i7CC21;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760097230; a=rsa-sha256;
	cv=none;
	b=Sfj/yWloHbrnogVLI9IsuJBI/kA52IlGeF3xTh5jyY2T36e9BkXqabDBg4MkadP8vD20UI
	rnJh6eSoq+tYYFJ+ZPpc0xBM60N1PLOl8rQF+dyt1Xz6ChKJD18u18RpQliS2zUzAXBH9y
	muX0IObglD0Q6PzuC3NbvgC5ShCUqGs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e8i7CC21;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760097230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ve5GXmWmpHi33tEgDSRm/w0MXIwLW/4OvMnLFhI0YcI=;
	b=GzCGDXFD1r6SlZ1BRWx1tPkt/NqO2Ydn1vk3Kgv/BVE723TccjFC1A9bK3Sh6vm8A/j5H5
	go/eRYND7Ts38MKqTsfuip8u4GrCcvHGzJEfSQ36VXmIE2popO8UvEE0SjwQXqapUF896Q
	YGVze77UmhkQF3L5uePdp9QB/DLIpqo=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3ed20bdfdffso1847061f8f.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 04:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760097228; x=1760702028; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ve5GXmWmpHi33tEgDSRm/w0MXIwLW/4OvMnLFhI0YcI=;
        b=e8i7CC21rrmzYPFOZTLV/Pfbl4hILVwiOxCYnsnlkRVI8GzTwqL+HXWkF5ATsJJsIe
         SzD8+9t/DtWgxgtRELesNkobV+7oMfUokmglCjMEfO1Mnx2Yn6QzLViSkqvV2boPmVBb
         LRHkkT+92Ousf8jVvKrv1EsZ65PB8SAsfkjsbrsZYYQtnRsT2zlZwlet+vplG6h45IkG
         Wob/wlIv86dRie+saw9X1AZ7XHHtJio3DW7imEjda3MogA6/8XexyVEQE4LLquAtEMGV
         xrDeCwUD66E0deZRe0mWrupioCo57aYWMxpCP6sSpgz1Kx0cS8FbEvsX6cv+gM2ScfQZ
         IqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760097228; x=1760702028;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ve5GXmWmpHi33tEgDSRm/w0MXIwLW/4OvMnLFhI0YcI=;
        b=BzFO44WEd/hC8mlq4tPn68jnGee5mPO+esl5FGNM9+aTq15nC/TV5ZL7gessozyX11
         UNY2uLyhFrD914aiXBuKTBk23Bz52fedpBzdi3PKqRft8WnWqlB28eR+ohPHNZg09RAK
         roOziOUA1+Wx1Zb9Q5Lhqljq+kX5Nsb0v2yYdj0nhqpNoyZuddsJe8umuI09k+Cyi0uC
         VVom/VKBVuouHySmmUK9aMoplreCxCY9nmkkRZz33SO445W80gng+c9KL4mFRpuI8m5F
         +N5ao0TzeYGptnQxGbBC2Jg0Q7NsiEo4EB8Gcvsuv/fSGd27ByD8seSGPoZVl26XbKeZ
         nrvw==
X-Forwarded-Encrypted: i=1; AJvYcCXI4/wXAyFgSZ+vG3sKhi+aBEgh9f8hq8K35XVLZQH2hOa/BsmTGRoyaTZ40vpDmshsknZf5f+k7w==@kvack.org
X-Gm-Message-State: AOJu0YwD1TkBEh5TZ10kdd3+wLSL2cWbwxuJ3Ya0iuI5Oa8qU2bckrG9
	QXbneg7h+vITEOZ0eucXv1Ktab6SZwUwMgXziJG1tItKZoLSnJg2mf29
X-Gm-Gg: ASbGncsv5Iiws9Ex5FztUIO4wR8QmgHG3Utfka1r+Rl8GW1D5jG0OcGn9IW1Oj4TTfj
	YuctGA+xE64VaTFcbvvCFo53e9TeBwY2UBSpi4VPxVOq5rbjNCW5ez9njeVzSfr8I702DfaxqEw
	Bi0ktadlyoWWeo1BQnEbtP6jVyu5CehWGUTOaO12KwJIE3leivXtlf5jea8Rj0a6b8euHUTgrOH
	wzscePa4aLkF/OTn/MwfOxZOuF3spn1iUWSeSQY44OmpvpAQ+37aWWOivoenzVoSuAnqxHL2iqK
	iyZlVsEsymYUsxtwVZjDOPyfr7bqe4qLXK2KJRvRt9gY+n+sPpnj1r57mJPbqZr3MsgDCoAucau
	evAylPwWBAapGaLNkFbM/MyATb2VfldXXzogi0Tyk+WNvxB4o9RvYsYRchZltC2oxOH1pzcIFID
	M/S1mvtgZCzVMnxHQeiEsx51DBmmeUj0/utTJoWfKiAHj7HS8=
X-Google-Smtp-Source: AGHT+IHsXGyGUJgVXz0ORzGntp6Fic3WHYvB2TK+Q4dKvGuhyzAZu9fH59b5KbN+KiLfkQOaaFGi+w==
X-Received: by 2002:a5d:64c5:0:b0:3d2:9cbf:5b73 with SMTP id ffacd0b85a97d-42666ab9929mr5654537f8f.6.1760097227913;
        Fri, 10 Oct 2025 04:53:47 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5? ([2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5dfc43sm3722424f8f.36.2025.10.10.04.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 04:53:47 -0700 (PDT)
Message-ID: <fb33f2e1-b0fb-49b5-a804-2239ae517aaa@gmail.com>
Date: Fri, 10 Oct 2025 12:53:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/hugetlb: create hstate_is_gigantic_no_runtime
 helper
Content-Language: en-GB
To: SeongJae Park <sj@kernel.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com,
 Andrew Morton <akpm@linux-foundation.org>, shakeel.butt@linux.dev,
 linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com, kas@kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20251009191149.57652-1-sj@kernel.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20251009191149.57652-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9jh4xse7o3q6pwgd73asgxjec1t4hsss
X-Rspamd-Queue-Id: DCE92140003
X-Rspamd-Server: rspam09
X-HE-Tag: 1760097229-368648
X-HE-Meta: U2FsdGVkX195HpPejPQKA8Fa1GHWX83af0Nq5BD2tt9LVfs1qcNF3X3Ntk32ryN65pDvdeJGs90ilcUIoSoKjW9+cFj2QVk/sk7c4HZECi80xE+Q5LhtjqP/2H9s62WOMtvIuF2ptUMnRVA2CHJdMNC62zOi+VRApU9kdbt3BEN4PkOOvL01uGlLrCg9mO8d1ofHD1xzu/CqX9fhS+dvQyWbAqKqZkWf1vQJwmUqLhRsUs+YWuQQsz+z6VYT9dGQ1qwczuseyABuTk5C6+l0fUMd7YxO6uPO8Opxa8BwjtxsN4KBAw7RIAkE1mnB3+qiDk1KdfGiiH9elvvYqKp9rRxZA2QitcPzRVkb3Diy44w6SctfB7Mt9lcf4VPJzd96oFVcYUtzcZcSPWxrIC/OGuzd82oHqnQm9S5pGxIJMWvmdJLL8IPvNQkSRKV5NuaP6VNwJnYNGDbege1dSOUDChgKIgjuicH3IIqFvEKS+yQN/UBRA6rMVn9GiNFBWElp6aMzj0UKuYK3EXP0a7tO3DtoRtbsqRlYXdME2pHb+qZ81QzKSsOBSz/Dbn5LQxZmQC9PwpfkJNpuxb1xZf0I0cNN1zqlcJN6CL1qhtCgo/J3XIm1e5ehJAM1QSH/7AbLQLhK39UCYlZIT+53GhrprQnOmpJJJWUSMwHVKyNZtjDXJHaJzK+0hkHn7FuZ1vDWodb8ST2qxMYkKBWabpptV+jm9eHvgZSi4Cc+0SoK8cHNbUHDzT6+MzOIvv/IHPsf7OrbZ0V9dXogXTm8sQgNXElF/f4Q+K3icMOx4290TsMFP8KlqnaxBbfx1Q/pBH5iC/0R9P/62wQgk1f94WMHPJ5IbqujlUS8gZfVJBIYAf/HR0c36MbP2eu59RDLss+m6ITOdO976TkjEiJ8oJiRuGQyR0HQYUcgwvhqiY/gO7TzSTZjGWEJB5E1HeJqpCBqWxIq7y6zs/5kT9cvjCq
 z+aswd31
 1/VpUkgVeGOraRIRInzgE33W632079zBBYVHYQ2uoE6nI3Q8KdAxZhGQ2BfJnyGH57cI1dbQFK1oozn9wdjl2KVQiuxv00BIg4h/6cQaAc6+xKKmzHkZxc3QUoMuefRQY1gryzhZA9mL76kj1S8S6kaeh3uXPksPc4mha1rJJD+Bfj/4ESlyes54sdSjnWu2LYZFMxZVriZVQRUOq0FiHq5jzJG5HWSI8M1z6T2Qjs6PqYGKAOIH3R8ko5NZnR7bieKkzLj28ph1RxA4Cbrqmg6SwJCca6He+PlM1sNzhS4mfi9Wuta/vTFVtLesfGwnUBZNU6EpReIfZXmcgoJ9oL1gjjZ1qAYkb/zFZPoj42PxaphFFDEyVXu8a1O33MePFzdjdL2muJHY71X5BBCEvO+O/aCXse5Nh1bEUDA+kZiN66XdqdX4XilZdV42Yx19wvM901w1icX7PnO9fRkNye4LV2GhbILRlJMukA0ZC3SIFWXys1C5fZqNVNXuT+Hcve6OKxJi86uy3o0uX/D77neB0yFezoeZcudARdFYmfVorIeBz+AHenKuaalZx529EPsSpU/t9uHQYE7TTzr0wuaEf9Pjno4mpFuBO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/10/2025 20:11, SeongJae Park wrote:
> Hi Usama,
> 
> On Thu,  9 Oct 2025 18:24:30 +0100 Usama Arif <usamaarif642@gmail.com> wrote:
> 
>> This is a common condition used to skip operations that cannot
>> be performed on gigantic pages when runtime support is disabled.
>> This helper is introduced as the condition will exist even more
>> when allowing "overcommit" of gigantic hugepages.
>> No functional change intended with this patch.
> 
> The change looks good to me.  I have a couple of trivial comments below.
> 
>>
>> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>> ---
> 
> I think adding a change log since v1 here, or adding a cover letter with it
> would be nice.
> 

I thought everything needed for the change is there in the commit message for patch 2,
and the first patch was trivial, so didnt add a cover letter. The change from v1 was
trivial as well.

>>  mm/hugetlb.c | 21 ++++++++++++++++-----
>>  1 file changed, 16 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index c07b7192aff26..e74e41386b100 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -134,6 +134,17 @@ static void hugetlb_free_folio(struct folio *folio)
>>  	folio_put(folio);
>>  }
>>  
>> +/*
>> + * Check if the hstate represents gigantic pages but gigantic page
>> + * runtime support is not available. This is a common condition used to
>> + * skip operations that cannot be performed on gigantic pages when runtime
>> + * support is disabled.
>> + */
>> +static inline bool hstate_is_gigantic_no_runtime(struct hstate *h)
>> +{
>> +	return hstate_is_gigantic(h) && !gigantic_page_runtime_supported();
>> +}
>> +
>>  static inline bool subpool_is_free(struct hugepage_subpool *spool)
>>  {
>>  	if (spool->count)
>> @@ -1555,7 +1566,7 @@ static void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
>>  	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio_rsvd(folio), folio);
>>  
>>  	lockdep_assert_held(&hugetlb_lock);
>> -	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>> +	if (hstate_is_gigantic_no_runtime(h))
>>  		return;
>>  
>>  	list_del(&folio->lru);
>> @@ -1617,7 +1628,7 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
>>  {
>>  	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
>>  
>> -	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>> +	if (hstate_is_gigantic_no_runtime(h))
>>  		return;
>>  
>>  	/*
>> @@ -2511,7 +2522,7 @@ static void return_unused_surplus_pages(struct hstate *h,
>>  	/* Uncommit the reservation */
>>  	h->resv_huge_pages -= unused_resv_pages;
>>  
>> -	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>> +	if (hstate_is_gigantic_no_runtime(h))
>>  		goto out;
>>  
>>  	/*
>> @@ -3725,7 +3736,7 @@ static void __init hugetlb_init_hstates(void)
>>  		 * - If CMA allocation is possible, we can not demote
>>  		 *   HUGETLB_PAGE_ORDER or smaller size pages.
>>  		 */
>> -		if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>> +		if (hstate_is_gigantic_no_runtime(h))
>>  			continue;
>>  		if (hugetlb_cma_total_size() && h->order <= HUGETLB_PAGE_ORDER)
>>  			continue;
>> @@ -4202,7 +4213,7 @@ static ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
>>  	int err;
>>  	nodemask_t nodes_allowed, *n_mask;
>>  
>> -	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>> +	if (hstate_is_gigantic_no_runtime(h))
>>  		return -EINVAL;
>>  
>>  	if (nid == NUMA_NO_NODE) {
>> -- 
>> 2.47.3
> 
> It seems the new helper could be used for three more cases.
> 
> On mm-new:
> 
>     $ git grep gigantic_page_runtime_supported mm/hugetlb.c
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:           if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (write && hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> 
> After applying this patch on top of mm-new:
> 
>     $ git grep gigantic_page_runtime_supported mm/hugetlb.c
>     mm/hugetlb.c:   return hstate_is_gigantic(h) && !gigantic_page_runtime_supported();
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (write && hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> 
> I'm curious if you are planning to do the conversion later, or there is a
> reason why this patch is keeping those as is but I'm missing.
> 

Yeah what you said in the followup email. I think should be ok now as Andrew has added v2
to mm-new.

Thanks!
Usama
> 
> Thanks,
> SJ


