Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89121EE0AE8
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 21:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688766B008A; Sat,  7 Feb 2026 16:25:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C2E6B0092; Sat,  7 Feb 2026 16:25:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F11D6B0093; Sat,  7 Feb 2026 16:25:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7236B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 16:25:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93516D5E4E
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 21:25:41 +0000 (UTC)
X-FDA: 84418942482.22.AD42434
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CB32D80005
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 21:25:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GGFEabRW;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770499540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyNAXnAehtaLJyN55pHsjhdmj2dE6yYzXvVx/znfvwQ=;
	b=Tk8sytfHpmHwJ8bDfTr6L0MUyNGyq1EF4b6whp92/HmaaUke781/Adm2zMg91zdtTnIm95
	i/N0fyXqBmL5GB8Hx494jISot7JJ3ikrLQwb0LqpJ6ZfoYKHCWA44d9Hzbm1zXnnRlO03Z
	gdDuQRc1uRZWcLfcA30bBRpSLOD0frs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GGFEabRW;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770499540; a=rsa-sha256;
	cv=none;
	b=51qUNWQkS/QVYgxRHr2FML8SrdxIsqN7dIVQeBykCVXCgnpaT6HmAk9Oudjt/vpH8ekEfA
	0ZTJSQaLHrU04KvZdZ6cSUvbzgp6DmuIJeg1K0M9X7ZubuJAjSeeusxzto+TJof0GDxJ9i
	j/YuceWbIL/j0+Yejd6aKycNTkbrTkM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8473B40642;
	Sat,  7 Feb 2026 21:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BA2C116D0;
	Sat,  7 Feb 2026 21:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770499538;
	bh=eR2kc1dFLNt01z/eTQHHUqpkmv+ymUfHbEBpx9JIxIw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GGFEabRWsR0NmmRAYjKK0QnagsaLpG1VVhv/wQMslI79amhm14y7ppsKtm+3oR/JO
	 ALqWzvnhsTiDDdaiz60YTm87Ksz+E+TbsKhoF+bu5CbiWgKT+fJA9BP6s3/JrPpFZ6
	 c68j5J9nFq0GxjPkhGDC/tNSypWPWZ0/Kzl/V5/BCmiBe1KUEftCBAPt7PAyorRBXh
	 tTSIXpFyvvkeWfFFflYZ3qI+sIw+SkzK5aTotneLCQeF3LCtUeXag/2E7AEcfEJDBr
	 XLVhK5PhzgKICaHnCaoSkklm+XBuwhLsefpOKNI/YpX9UvHlgICuE6yvuTETC0HcWL
	 ojpZb7YuCu1LQ==
Message-ID: <412359f2-ecfb-498a-9717-f0a442abd3f7@kernel.org>
Date: Sat, 7 Feb 2026 22:25:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 11/17] mm/hugetlb: Remove fake head pages
To: Usama Arif <usamaarif642@gmail.com>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-12-kas@kernel.org>
 <907ff793-9b02-4a22-a85e-2873246f6402@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <907ff793-9b02-4a22-a85e-2873246f6402@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pes4tt1hsb9er7tuzrgx3cy1wnotazdy
X-Rspamd-Queue-Id: CB32D80005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770499539-821485
X-HE-Meta: U2FsdGVkX19TXyPFIu8Z+PJKWZJJo8Pv6sRBBBRLjYF7ofBuPqqlzg2N6gkuUS/Sr/Wf7BD25rrVs4HZawuBGkicio4+KC2HE4t+gK07p26MwaPnJrrQbyCXC0IjichpQTbkcDwmOVQPuG5eCzt3txMw2rM3jOWucL6A53OlYnmfEr/T/Cze5R3uuMGFvzF8GjQY5BbFQtiIPxg+AVXrDvpOTvQ9MP/ecDhGG8Kl2XAO3rO+FuUbo6wBJQx54lpnY20ucE7ytPcgl0AK10qk4NkUUyFyyUxycFYaZWBhmGmXNoD1Nnxw7KTY4za8dFIC4k6huASmf7zNkv3UoI9dxSf/9yleuRzr3Lkung52Z8rxm354/JwHCb1108tzz5HxcIqqkkga8FBMXjweV/eHOnUjoJMw7EYRyL9R/DbQ5vwN67f1JN7g6BZZICvzdwmpbj4go2yAxaKcaM1pywVNqj4Rn9ViRuliyHR+HsTNbaiLzo07GEV7MxHprcH4AcrnZmedp63idP6nfIDUmS1xtDI2ql+0I6sMUKLVaouPJV9XuxyNE9GhXemGqLtX5U0Dc8HQUfh8iG3+eDbMde9DIwvcTBgzbCvM1I+y1HHUFDu+qV2d1npS6DCbTO4Mw2LenSN3NU1RSULxQqb9f4NWRNpO2yRbi+xYyzx7sA/gBYBYya41YqpWw2Jrk47kb+No9ymLwMnDYw3PSEoT7pjC0DOEyhOvHRyVrD8i7eBVwKsjv7LeLIDHMnAsLP9A9dVzb99lqzCL75UstE0SOqRDh3DYt0MdtNrhrHcuBlfjBlok2vLdj8WKonrNlxCP4bngqaErfF1d7uLe0DLx3zvNJE3xPYsR/l3MS+/BBwZCgMesk2psN+q4FsjpG0sg7EjKSdrV397aEoLGQh9Y9WOI+fXRMBoxosgHHu6vQoBJE/DA2OLSn4GL0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/7/26 21:16, Usama Arif wrote:
> 
>> +
>>   int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
>>   				       int node, unsigned long headsize)
>>   {
>> +	unsigned long maddr, len, tail_pfn;
>> +	unsigned int order;
>>   	pte_t *pte;
>> -	unsigned long maddr;
>> +
>> +	len = end - addr;
>> +	order = ilog2(len * sizeof(struct page) / PAGE_SIZE);
> 
> 
> This doesnt work for ARM. For len = 32 (2MB contiguous-PTE hugetlb on arm64):
> ilog2(32 * 64 / 65536) = ilog2(2048 / 65536) = ilog2(0) which is undefined.

HVO should not be possible for that size, and we should never reach that 
point, no?

Remember that for HVO, the metadata must span at least two pages.

-- 
Cheers,

David

