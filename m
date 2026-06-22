Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CD57CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 15:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B356B00A2; Mon, 22 Jun 2026 11:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF37A6B00A3; Mon, 22 Jun 2026 11:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2FF46B00A4; Mon, 22 Jun 2026 11:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 743FB6B00A2
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:00:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D38E1A01D9
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:00:22 +0000 (UTC)
X-FDA: 84907859484.30.6127657
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5B44C1C0010
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:00:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lm7QAjZj;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782140421;
	b=XEzD9BZbJPCrK2GoXTOdq3an+QrEom1pnEdr9n3VSgGaApFY4Px5QrDoalWcOZ6+mStfvh
	Sa4IoH0qOrMWNgy8L+mnB/n8XTAAlu1Caz2AVRyPmett+x013outNEqM+/LB9BPtHm+lzb
	8OQ5ngPy5V0LROIBNRbMh2X/c5GRjGM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lm7QAjZj;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782140421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOJ7I8F4EO4YGKqeUHW4KddOImg3/9NrBeT3tUiiggU=;
	b=yNiS0DJzODq+wUhnHb8+hvWFUIDzUk+oiOIR39Zoxn9E0wkmsBHF0WQIdXhlfyH/saIh/z
	4Cj1LkaWe46AZGi0sE/ti3gF7JTo0/G5Ljnl3ZXz9Ifw7bACGXjFgG1of7r/+pv+vIHXcm
	xH5RX+X/PE3tPoSnfyL9xLOHNqv5eNM=
Message-ID: <fbad4ccd-33dd-4d5f-be34-254095e714b0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782140415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NOJ7I8F4EO4YGKqeUHW4KddOImg3/9NrBeT3tUiiggU=;
	b=lm7QAjZjJbNEjzhuKwp0t1Wo0hoKuz96n30Jj0Jga70Q2X+pdZe1co7PxyVG3oEUiCtdfb
	i/Jiv9p5E5Vq/0nSMaQDAQQ5WRo7gwjfD7sEQCSDBp2IL2ZVc5Mn8J4Fh4i+3LSrjIt692
	XXYWmHgWKSGT/dpiCjUyhvOmhiC/wkY=
Date: Mon, 22 Jun 2026 22:59:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check before
 return device-private pmd
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 sj@kernel.org, ziy@nvidia.com, balbirs@nvidia.com, linux-mm@kvack.org,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260622130651.23359-1-richard.weiyang@gmail.com>
 <ajk0N3Aekapljaoh@lucifer> <20260622142102.pcmr5pftshj5lvju@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260622142102.pcmr5pftshj5lvju@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sg745b8a5guwizznx6dxycufbzaeycab
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B44C1C0010
X-HE-Tag: 1782140419-97409
X-HE-Meta: U2FsdGVkX19npzfcAi8glV8nGLzOoe67KvEmH2H/USpw3grJB+nZpTDeQmsaPlVvWpeExcW3iJWdiEKlZossuh9groK+D+c7lMBhyXDoVI6exBUfgAUkb5fCVrVoxL1DtoHVtzpi8KxKyIbQLO24hyqMuPJ1rEVHja9NWaVtMGkSPDpPU7jEk3sqrC1P8TH3m28xnw+LhQdogW8nZa62nIo0o3hzdHwLfMsNG46pJYD9KPhkH52+bzvwkG2BvoU17/oB5EDo9rqKkudwPUO5jrc8ZCmTfLO8S+Rx3JJT52nVOwKWkBQHfKuFfcyaewGLZcDIyLWRVcWXhtrBk9mSYnokyklEtpnrsO9jnPkR5Obx4vI3sgJW66JcKw85AcYeIohmeFxkJfWeqr18SY1zHoIUQo6N4OsDcYdphD2bMsA69ys3xjTyZzNmjr56Mzvap4XH4GCXipC0MOxraNnL4JNfHnsOBhq3PQU9aDAvXl8R9vAK8ZcGK0IC/+2QQtwdy3U+x2kn9iQlePt/1E1yJAKHKPRJuiO/0asa7K/jBMA6/QEcYDdxOJkcNyIXeD3t2ErAz2zSiw3YV+aqHkHn5+IQC312brnuMmDHhp73EqSy0dPCW2u2BYs9YDO9o1YIQV0aRXNnwZsqtKN7QG6NBBAkUoCjqJSsZkuA8rTVtiL7954LkPBaqq8uTk/vuSVs6E8Hj8eH5RBw4t1ZS8nwMx1kzc81vddxpvg7/jDgU3vvk1GZ3uYzkA6tOo0V/LDS/s8IJz7/Ur0RpHA93WIDoyCsU9ql0+mNbMmLyjl/HB2UYW3hxnzE4KTz+cr8jW9FGAEP08hC85ButOXVvETzqv05iUrrPXfz373jlhll7+WQxLOS8ROHIv1TuDw3RX31/r45lMA/xvicB8H2//2m3RY4X60D4JGFISQXw2UV801OpXb9UwEgXFH5tahDdthVYEm2vnfRJEpkDq2We2Y
 iO7kkNP+
 QFMc/QxKBBXLJ1KAMyEnFZFoSizB9+RtoR2qdJibZaLuV52UpXdXpj3deY8vOKfwrPiF9rnoZTtmMuN3ZE0gdss7HSH6WREvbmo4BhH1xuDbzoiSy2P995dhmDnjz6jpemZ3L7ZNbeNHgzshaaYHEao7/lwkWzqYX5NbFG2E/V3bT/IXRNx08oid3zuM+XAZ8ZK5KvXJkw43MeyNpYhqHahUBqzkUJ59dHuuSrZTImULj5Ny0zRn0MMdKbXZKZCM3DODjCZdiXXUFWGcGbizLtlPFIoz1tb7p9fu+C563140ZVw57M+eMvTgeGPVhaAMASYRtD+HGbV9zvrtgajimYaGdC9w0NU4BX57vYEMYl7HiKlADtZVXyigXCRXUBeOf6p/V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/22 22:21, Wei Yang wrote:
> On Mon, Jun 22, 2026 at 02:46:40PM +0100, Lorenzo Stoakes wrote:
>> +cc Lance, linux-kernel
>>
>> Your subject line is 83 characters long and is way too detailed how about 'fix
>> device-private PMD handling'?
>>
> 
> Got it.
> 
>> You forgot to include linux-kernel@vger.kernel.org on the mail, lore seems to be
>> a bit broken atm but in general it's helpful to include that.
> 
> Got it.
> 
> So usually we send a patch to both linux-mm and linux-kernel? If so, I
> remember is later actions.

Yeah, please keep linux-kernel copied too. For MM patches, linux-mm +
linux-kernel is the right default, IMHO :)

>>
>> Also is useful to make this [PATCH mm-hotfixes] to make it really clear it's
>> intended as a hotfix.
>>
> 
> Got it.
> 
[...]
>> ----8<----
>> >From e6a3c1c782714ed831c4d46a14bb99226423bf59 Mon Sep 17 00:00:00 2001
>> From: Wei Yang <richard.weiyang@gmail.com>
>> Date: Mon, 22 Jun 2026 13:06:51 +0000
>> Subject: [PATCH] refactored
>>
>> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>> ---
>> mm/page_vma_mapped.c | 20 +++++++++++++++-----
>> 1 file changed, 15 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index 2ccbabfb2cc1..17dff8aab9f9 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>> 			/* THP pmd was split under us: handle on pte level */
>> 			spin_unlock(pvmw->ptl);
>> 			pvmw->ptl = NULL;
>> -		} else if (!pmd_present(pmde)) {
>> -			const softleaf_t entry = softleaf_from_pmd(pmde);
>> +		} else if (pmd_is_device_private_entry(pmde)) {
>> +			softleaf_t entry;
>> +
>> +			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> +			pmde = *pvmw->pmd;
>> +			entry = softleaf_from_pmd(pmde);
>>
>> -			if (softleaf_is_device_private(entry)) {
>> -				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> +			if (likely(softleaf_is_device_private(entry))) {
>> +				if (pvmw->flags & PVMW_MIGRATION)
>> +					return not_found(pvmw);
>> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>> +					return not_found(pvmw);
>> 				return true;
>> 			}
>> -
>> +			/* device-private pmd was split under us: handle on pte level */
>> +			spin_unlock(pvmw->ptl);
>> +			pvmw->ptl = NULL;
>> +		} else if (!pmd_present(pmde)) {
>> 			if ((pvmw->flags & PVMW_SYNC) &&
>> 			    thp_vma_suitable_order(vma, pvmw->address,
>> 						   PMD_ORDER) &&
>> --
>> 2.54.0
> 
> If we prefer this way, I will check and take it.

And +1 on Lorenzo's diff. Much cleaner.

Cheers, Lance


