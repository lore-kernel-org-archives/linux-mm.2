Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F9F7CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C29D8E0010; Thu, 23 Oct 2025 12:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A4F8E000D; Thu, 23 Oct 2025 12:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5632C8E0010; Thu, 23 Oct 2025 12:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 458148E000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:14:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E54CE129B7E
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:14:40 +0000 (UTC)
X-FDA: 84029877120.30.89FDB59
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6083440008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:14:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WYSwDUhq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761236078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0dhmDMYo3HiSSPV4Zrtr3RDrc7RUUpux3gluKAN+yE=;
	b=oBLV6uO6CzpdXSt7RxEftRDNRS4uq58W26tiuUA4LVcIQRwM7frId0he9UQJDxDXJsXtGW
	AgloWSKoFPnCCXcgygEAsBjobzP3vMfKxHl7VvqNrJgaRIAJqzgf/WPffvRDLh1W3io8Av
	UKqKv+x32xPL7AEpnWPtjwXKZHCJo3g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761236078; a=rsa-sha256;
	cv=none;
	b=23V48ZyWTseVqOfBxnUnw6ZWuxpUCslDdWwBNqu7qshGLGmOBohHWHPqqmETYCffO3Qjcx
	jlZPl0HNghcy/NnfgbndZkaa4eDvXgnHGaWR8TErbmvprU19WA0dCQlYAFV61L7B6pvyMJ
	32LImTpMYNVUWMWjdHp7a1IMVgvav8w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WYSwDUhq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761236077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k0dhmDMYo3HiSSPV4Zrtr3RDrc7RUUpux3gluKAN+yE=;
	b=WYSwDUhqbAqzEUi3BCCduvXMMUVRN3vQn+TwKyCyZpWiL6FfmajkIOejZGXAq4EEtPglzz
	VEv1ExJ/GjBljkoOb4eQ1lBe7c2wENRPcIDzZUi/I/ohv/qXCEnHI0NoZ0MiwBODXH1ZEa
	1YH00/uhduAA+u23mWxe+7QP40fsVwU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-4COly8K7Myuhvlsm3urdfw-1; Thu, 23 Oct 2025 12:14:36 -0400
X-MC-Unique: 4COly8K7Myuhvlsm3urdfw-1
X-Mimecast-MFC-AGG-ID: 4COly8K7Myuhvlsm3urdfw_1761236075
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-427027a2095so618039f8f.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761236075; x=1761840875;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k0dhmDMYo3HiSSPV4Zrtr3RDrc7RUUpux3gluKAN+yE=;
        b=e1qvA9gKeLkHF+u02BbMhT+xo4ZQj+H8mpXTn0EsT2UuP8IGsS2Xbj6nYznvMg74iC
         0zl692c52WAQDnABiH4EjKQYtT2Q4U2pyt0PyE7EHu1Qa0usdyGQml1svjCXVMPMTuPs
         Vuoi/1bHlfYfGkdKLA2GesNIJHYNbvGGppvcBAYnThdIN5hyoGtvBPGx4FntzGx0bP5z
         T9dlLvwWMUubov2znKDmfNaA2xwVGzwRKWmW9TiDKdquCZQoFs+/qAO9kAr8v3M8WnQe
         6tUFQcWDvFm2J+GJuGbZr32UHa3fo00dQfV3PIGdvq5Vk9ALyWFP2Vl8U6MEHVRsCR15
         d5oQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKVBrVjTRcI+inNCsn3lg3Dn4tVdBp4aEyO94JqQ6BeWfRKWOjpAFxtKTfQ2EpdGEmppKh1cD28w==@kvack.org
X-Gm-Message-State: AOJu0Yw2+M1As+Mvof7eC4dhAmFms3fa+UN1VJDYsWEM7gj9msJy0u2a
	KWuLvMlIHJBtwhqgfZ3RRIcKmJ4zDH/PSOqkmmlqhikum2Mrcqh3LrNBQU0Zi6xJDFV+1BXg/+Q
	fNNcug9WuBVI+AxPp6xJJNQZ+ESdZgYexb2U6/qOC3EfsiT5SwkKu
X-Gm-Gg: ASbGncuvpPqW8c561+LyLDsYDDRclea9lX37dXnQvpw9dr06yg/fkFyMboG0O3+Ydo4
	hM7GKQgZiwqCzfG5yG1a4eipQUqMNiAaKVz6jRZLtFcauaY0lu0fX70YtINIEVzBjGdnT82j0On
	XK38APrInlXmjMrzt8iY324X9r2fzt71qwlutCLTMyQZVVA6a4unTBj6h+zuLBe9gb8qm9XdtiJ
	G61/Mo98O8aM6HygQCG3wwue4aGVXfxkhFQbD0l+ZxSsbIqWKW33c9YsSlWjUSxytm76BQPpl5s
	uoRv58X2LE73hO8sb+xhZRqEdGeTxlHCM5SoJGA7Qqp/NgxvnmiaECvGaGWvN0Nlw1ZPZIFDt8R
	5ocb1vzHzAO5Oz/16SBr7ouHcxEOsUyhSLeb960cH5cJsc+3X5Nz4MMYRunpVs1ufKWhvPSQbzj
	rJsgY0yyaV2D3g6v0e90u9t0p8FBc=
X-Received: by 2002:a05:6000:2389:b0:427:151:3db6 with SMTP id ffacd0b85a97d-42704d8e226mr18440192f8f.24.1761236074730;
        Thu, 23 Oct 2025 09:14:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMl8voI5z2PSFRyYE4kSrkNvMWAwhecqefVjAYNEcQcmIlYYmJhCc3BoVGRfcbppN1W9F1PQ==
X-Received: by 2002:a05:6000:2389:b0:427:151:3db6 with SMTP id ffacd0b85a97d-42704d8e226mr18440161f8f.24.1761236074258;
        Thu, 23 Oct 2025 09:14:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c427f685sm106391125e9.2.2025.10.23.09.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 09:14:33 -0700 (PDT)
Message-ID: <f0715f2c-ee27-4e13-84d0-5df156410527@redhat.com>
Date: Thu, 23 Oct 2025 18:14:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/shmem: fix THP allocation and fallback loop
From: David Hildenbrand <david@redhat.com>
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Liam Howlett <liam.howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Mariano Pache <npache@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 stable@vger.kernel.org
References: <20251023065913.36925-1-ryncsn@gmail.com>
 <774c443f-f12f-4d4f-93b1-8913734b62b2@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <774c443f-f12f-4d4f-93b1-8913734b62b2@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i_Nymn2kfGuLgLKD51q69arVRhlMF2VrA4egNnBLNeQ_1761236075
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6083440008
X-Rspamd-Server: rspam02
X-Stat-Signature: qzhsxe6p4s3rh1t9gwin1chtf4f9zaad
X-HE-Tag: 1761236078-455014
X-HE-Meta: U2FsdGVkX19OtbqiFsfiBtR64s+HTaSRYf+otzBotf6SpvIePTRTgHGBf/evj40tGSgpgEdRlH5SIT94CMLpNiaEFzA/jGODTcdT67/oJnsVvgglsvFt+nkt/E+8+64DojQMrzraTXcOJV38tayJkGoHvaLK3t6wPijwmAFKebRjGnfQlILOORY9AHgcvc/Fmg9pOR8jeNxP5/1T9/XvxSmOJim2NmHgnY87NbBVteKf1F/rSBuQze6zBcaSw9ReC1Z5vggP0u0hbNo9lwO2ECs1orzSQL91ea0/PNOM+zYKhz0O0e5zh/xtsaT7NE2Giq9oVW6LS2+jZytYzJ6mMwZ56CWkolkfVV5gQSOD/NoUkZWx/ab8IcSry3ZeU0jmj6wYbBaOhkwMnu5fG2hrwHnsXk/DTU10JeXLQcHptmJIr3GeuLDLhRv9Lrk7Qf2L86y9NJywid4SiOMh7bn4q6mOKYo8bnC8GU+eiGSG8SJbpSbBd/Z3CUPr8+VuAo1vkrRqoLRJxQVpfV8q0g2JN/gJhzmbUupfVxJmVrnDatzxsZ+dVtqiBr9y8VCUnlcRGOoUKmDZuR1msb/ZKkmd7f6xV+R1mPAHGk0iJLTwnAZt2PQRsCSewruYLqQ7CT/x5q0yS+HdDKAYRqjk05mzSL+q76vDhxfuR0zdyMdXcBQ3AYhbgGZpZDOAcxHLn69nWn3rcf4TpJGx1PE36/ArOXxdCdy6OCLjceSRkN45hZIsotL8sN3C27D7G7rTdVYNq+0g8GN4/VEXRQyjG7gWtVKn0QOEX/eej5w6gh2GDitoRTLqeOgRg1pNb65RW6CxRpTeeLnvZ2motuXoV9hrqcYM09erzkyNDbABC67/4NT3rfDeKU0M7f+OMEEpYq4Sjsme1LrHJse9pPHhC81jHRup6uFn2EBd6KH1wnbawEQWO8eh3jEGgTyw2NlXGWCcSC9xtzTcEqqeat0irYg
 Mrfqje8i
 +705n5boXe2rxygRWs6M/6Jfx1RhXDr8QmtqFjCeJo6x3KHdvYsYNLwQFWx+VKqbV5WbG/6FMN6DtxS5RJYvt9lCnYGhnTYnvbskDT/LDkN8JpLgoyGgd5g1Qeq058bvA9YxlErmL+EFw/3Alp1XTG3dPQSZdj1nEwYW0mmMaQRve61ZDWSru9oYneM7VqsWH5eAYfTr+s5mhoSFaSbXB2Go4Ha8nOyoE6Jp0tHiYMwLYJtsnMduypsJeQG/6bTO60xqpwIXEbACuRQu4yQFe339l5N/+a6HlrFdiXApYbd47KdyS0bx6QjIwo0Icx3ZNe0m8Lay1lfTuAWDx5Yn0eQpBk7mRc8+oJSuA2zPikI+Q5NQUGynUP67v2I2ZWGcTjoOFDQ1pwGjKz80lfP9XMmvNjVc9RkGwF1ZwRNAtPLcrvubG3WxrnnYti/ObfOG36Z3lNxsYq9EmlGdLkbM+hseGLDUHL7mCjJoBK/ZD9e8sDSsKLufDtTj/hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 18:13, David Hildenbrand wrote:
> On 23.10.25 08:59, Kairui Song wrote:
>> From: Kairui Song <kasong@tencent.com>
>>
>> The order check and fallback loop is updating the index value on every
>> loop, this will cause the index to be wrongly aligned by a larger value
>> while the loop shrinks the order.
>>
>> This may result in inserting and returning a folio of the wrong index
>> and cause data corruption with some userspace workloads [1].
>>
>> Cc: stable@vger.kernel.org
>> Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
>> Fixes: e7a2ab7b3bb5d ("mm: shmem: add mTHP support for anonymous shmem")
>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>
>> ---
>>
>> Changes from V2:
>> - Introduce a temporary variable to improve code,
>>     no behavior change, generated code is identical.
>> - Link to V2: https://lore.kernel.org/linux-mm/20251022105719.18321-1-ryncsn@gmail.com/
>>
>> Changes from V1:
>> - Remove unnecessary cleanup and simplify the commit message.
>> - Link to V1: https://lore.kernel.org/linux-mm/20251021190436.81682-1-ryncsn@gmail.com/
>>
>> ---
>>    mm/shmem.c | 9 ++++++---
>>    1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index b50ce7dbc84a..e1dc2d8e939c 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1882,6 +1882,7 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>>    	struct shmem_inode_info *info = SHMEM_I(inode);
>>    	unsigned long suitable_orders = 0;
>>    	struct folio *folio = NULL;
>> +	pgoff_t aligned_index;
>>    	long pages;
>>    	int error, order;
>>    
>> @@ -1895,10 +1896,12 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>>    		order = highest_order(suitable_orders);
>>    		while (suitable_orders) {
>>    			pages = 1UL << order;
>> -			index = round_down(index, pages);
>> -			folio = shmem_alloc_folio(gfp, order, info, index);
>> -			if (folio)
>> +			aligned_index = round_down(index, pages);
>> +			folio = shmem_alloc_folio(gfp, order, info, aligned_index);
>> +			if (folio) {
>> +				index = aligned_index;
>>    				goto allocated;
>> +			}
> 
> Was the found by code inspection or was there a report about this?

Answering my own question, the "Link:" above should be

Closes: 
https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/


-- 
Cheers

David / dhildenb


