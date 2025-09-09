Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5269CAC58D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017A46B0006; Tue,  9 Sep 2025 03:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0A896B000C; Tue,  9 Sep 2025 03:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20906B000D; Tue,  9 Sep 2025 03:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE40F6B0006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:34:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 747B158B65
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:34:00 +0000 (UTC)
X-FDA: 83868897840.23.FDC6A10
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id C187E10000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:33:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757403238; a=rsa-sha256;
	cv=none;
	b=tulqoRzvuIuT7sEqEmOnQmmdph9IQAf4ffl9wcKynhFuxL3zmTrB2AWfGPk/ZtC3nZLMV5
	K9sAEv7mqSNsfRXEP8ySqwXGG0qrs+18xPybYj6130F8BcYsfMvlEOeASiJTgmbBGlGh3J
	2jViw76+SUf5JJ4ZL3zKqNXrLpR10HI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757403238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xfo+JrSURI1P7dLwRyl5aAO4JLhmS8r0oPjX61r45sw=;
	b=JhKww+/J+jEHpRgh8aGZr6kCbteWskGxndSymSEHh4AOTMdn1cOlbS6qC5H1AaOjCCWrNR
	T6IC7qcqI8otHcy2xdtMuDoDau5YHHNozRkSxA51SHQepCZc8cR15SmbhgivCQZbltmgqm
	iSyicZ6Vde5chMv8C63V4pKCervsOy0=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cLbFL17zTz3tZY4;
	Tue,  9 Sep 2025 15:35:02 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 403D7140123;
	Tue,  9 Sep 2025 15:33:53 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Sep 2025 15:33:52 +0800
Message-ID: <c4fa23a3-3674-4a82-b29c-ee3aae39d8a1@huawei.com>
Date: Tue, 9 Sep 2025 15:33:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: <jane.chu@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun
 Song <muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, Zi Yan <ziy@nvidia.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-10-wangkefeng.wang@huawei.com>
 <cfaf16a0-00dc-4624-b379-17d6b1b5ad02@oracle.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <cfaf16a0-00dc-4624-b379-17d6b1b5ad02@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C187E10000D
X-Stat-Signature: fimrxjhoh5uujhdsuh1bsy3ot5caqow5
X-Rspam-User: 
X-HE-Tag: 1757403237-107437
X-HE-Meta: U2FsdGVkX19CFuKEp8UliZk5MnZEeOmo4asgqpBlHxvTXz1hueLu8SJV5EuzncXfdjxsWpKzAOSB2d0PvC2SDdstBvXWZarNtEd2XpMiv5Fxfs8Yucfu1FK8fkB2Ymu92z1xiQPpqKoQsPiLHMtqpKTNBXHFn71WEYzlDKVpjPeKdvutQCe0jXUtFu8/ecXPKzCroZxYeeNmWxOXwPg2zlpEZ8EyzYTUp2mPI9t6lmi+7DAI7SHqd0PyFsZvXI8Mcd+wA9cNu35IXJT7jaJ3MJ/M5CtpXbmAb+aZWMtFlVwD720Vl9bTN3KwLx4GSiwAB1MHuaFgQq9PfXZbqmvunA2j7pDbvf/wKc60E1XPVu8ekpOHIlTfNfKGqy7fBGsWREP3Ttcd5scGuTq5Chjv/6BLij1ZHAFZ1/StbhvOZrxOYmE7jhGn5+mydq5WOB6V7vsmCuI1LFGE1ftxrHe8FKyRRwKJwDq9z8ZW6aVWO/Z+a9lzgKEAHWnYLdYXXzZlGQLKOjQQZI+Wf/CaxzqP1gQlxcohB7XxNAC9PpMbGwy8v3ZpfciW22ddjsNMRnKA3E59sCG80mPTTFjrKYU6/Z4PJoQ5XFGFok2Y8KSDdlSSSUj+hGFmDlSb5UeZLfG1dSWhLk2Uee4xwAf3Jtth9gNXjAPxhV7xGH6vlkJ7RYctWcLK1TiDFG083aJQU5Fc9h71fpbYl+3I2Uzuo+ckS2Kvm18jqooGy69/445VqN/UjNiDsbzeZytfBqvXXc99iavL6DRDpSMjtw85ayWphl7Ljwarqgb/UyoMVpyxWXBBi+cf6MQCYyMsuFIHwoXkFt4VkcRUrhiSLRqPKx6FD+E4sz5Y6J5Ub52lKIZL2Ol96zkYrW9jmkRlsC5weCpD3BYtQikPes48UqUxofeAhORkDjnxVsF1BCqFT6ofljI+LrfEIssy+qx7PP5XxN1PWlF0+Chr1uRm8CAgl9C
 JZWf7jMc
 pvKxfLE9p/4zQkPJ6/C1gLTUoZ/B9EkJ00gmNGWTP7nZr6ULxX9U4c6LtnTSStrmJWjc8GqAWg/VAJTACi9Rk6+UNWZP6YDMTtrRTt+2oCeSAAs3E/XMFk6dxX/ebXEJ+W1NFyNFRB750qCBihQKVUeUUD9C4nmSPIPnMqhK3Z+XupBB1yHorqRdYsqQqw/CmG+GZ/BjiZdGnAWZCXdlPijoy0wZcArQIteU7dDnYKSzsAk6isb/Jv1EpObZrzA4V9NM9SwrQm4lQybqJIH+WeW/CN25JKU82ZcORnsuCXG72INUodhZzxLtGFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/9 9:48, jane.chu@oracle.com wrote:
> 
> On 9/2/2025 5:48 AM, Kefeng Wang wrote:
> [..]
>> -
>>   static inline bool subpool_is_free(struct hugepage_subpool *spool)
>>   {
>>       if (spool->count)
>> @@ -1472,43 +1462,20 @@ static int hstate_next_node_to_free(struct 
>> hstate *h, nodemask_t *nodes_allowed)
>>           nr_nodes--)
>>   #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>> -#ifdef CONFIG_CONTIG_ALLOC
> 
> Why do you remove the CONTIG_ALLOC config switch?
> If it's not selected on x86, gigantic_pages_init() won't be invoked.

alloc_gigantic_folio() stub is useless, we have all stub function for no
CONTIG_ALLOC（CMA will enabled CONTIG_ALLOC), alloc_gigantic_folio()
will return NULL without CONFIG_CONTIG_ALLOC, right?


> 
>>   static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
>>           int nid, nodemask_t *nodemask)
>>   {
>>       struct folio *folio;
>> -    bool retried = false;
>> -
>> -retry:
>> -    folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>> -    if (!folio) {
>> -        if (hugetlb_cma_exclusive_alloc())
>> -            return NULL;
>> -
>> -        folio = folio_alloc_gigantic(order, gfp_mask, nid, nodemask);
>> -        if (!folio)
>> -            return NULL;
>> -    }
>> -    if (folio_ref_freeze(folio, 1))
>> +    folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, 
>> nodemask);
>> +    if (folio)
>>           return folio;
>> -    pr_warn("HugeTLB: unexpected refcount on PFN %lu\n", 
>> folio_pfn(folio));
>> -    hugetlb_free_folio(folio);
>> -    if (!retried) {
>> -        retried = true;
>> -        goto retry;
>> -    }
>> -    return NULL;
>> -}
>> +    if (hugetlb_cma_exclusive_alloc())
>> +        return NULL;
>> -#else /* !CONFIG_CONTIG_ALLOC */
>> -static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, 
>> int nid,
>> -                      nodemask_t *nodemask)
>> -{
>> -    return NULL;
>> +    return folio_alloc_frozen_gigantic(order, gfp_mask, nid, nodemask);
>>   }
>> -#endif /* CONFIG_CONTIG_ALLOC */
>>   #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
> The rest look okay.
> 
> thanks,
> -jane
> 
> 


