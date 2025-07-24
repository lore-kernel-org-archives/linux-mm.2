Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37928C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 17:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7D58E00A3; Thu, 24 Jul 2025 13:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77E78E007C; Thu, 24 Jul 2025 13:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940588E00A3; Thu, 24 Jul 2025 13:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1D58E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:40:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81945111A9F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:40:48 +0000 (UTC)
X-FDA: 83699873376.23.53F3812
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0DF74140013
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:40:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NKkVTN8c;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753378846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PnBhIOhkNgjsPUOGU68ShalsAx1zsEf3moa4hYO0HfY=;
	b=8lXvRasqzu7rtAXeNMRqphFagu5mG9tKCCv2RijQor6B/zhqdQ3r4r7R/jyqA5Clma4lLE
	KSl0R17VAv3bH6aNAX4OWtMLZgzu9taUk3qhQPrNKDZGgTECYSzOz+dC4jx6SriVgPJWeY
	KyEe/BlQEwHCQDws5BLaxd8C1PRWnyQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NKkVTN8c;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753378846; a=rsa-sha256;
	cv=none;
	b=m3Mgeltl//lRpWMawNfMFJQkp8ciwF/q0fAyl95+JkPDO0s0+E70iP7k0q8QSTvODt1ONl
	HYEFV5vEVmYMrYU5H9/g0H6Z5wQlzbYunjzbZul1zvkAQYcP7lUrx11TAuu9P365h5w8vf
	kezr4OtMkLUi6NesFCIt4Ie6oAVmq1A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753378845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PnBhIOhkNgjsPUOGU68ShalsAx1zsEf3moa4hYO0HfY=;
	b=NKkVTN8cQDF/jQZ7grd9/8W4T+SIEVphNEOXMbfPvYBTSccxZ/+bpNs+/0WfardOKxo3wX
	bibrOJH9naJMA4lhuB9/fPgunIwVnM10Nm3Wpenio6bmR+vQb8GsLRcV+2n//UlM4cszJg
	Av+xMLlu9fr/Py6eVNumGck/MtvW/fc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-SbbshKY2Ody0YP8J2WK9Ng-1; Thu, 24 Jul 2025 13:40:41 -0400
X-MC-Unique: SbbshKY2Ody0YP8J2WK9Ng-1
X-Mimecast-MFC-AGG-ID: SbbshKY2Ody0YP8J2WK9Ng_1753378841
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso7621865e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:40:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753378841; x=1753983641;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PnBhIOhkNgjsPUOGU68ShalsAx1zsEf3moa4hYO0HfY=;
        b=L6aYl7KjLO12NXucClHUnjmdLO2jEpPY7uNnYB7mY+ESV6NIpou+kDcthjISXi/NPH
         7KuLASao2Y66KNBJ+e0ALA5VGFqghpTbSMiPmfmQJTOMkzKsIzpQuFlNeGjgQbe9dUxW
         w+aTnydTReDNlsbVbWkHWYZHdwnzQwU81T5aY4MwxYCAYF1fTAZNYhwuiFiNnt/HiMml
         tEGKNGc1u5Z5V/gBVyfZYW8TPPt5oeW5UwhMx5w9fay9QEgrpteOKjygGm62oxQhZ5c9
         JFmDHwH5lSlgCx2G5J4RX2QNZ5dpTedLfDzP84ayo1+WqeTRdbcWfzo00p3LuwYGQ7Nc
         G4Dw==
X-Forwarded-Encrypted: i=1; AJvYcCXjKr9IEFCgRWLzKsHXM1Z3X6NzMyo3liAFZZyN+1XFEUmEgpWgWqJMMlbyC3TRiTX56J+3L9xbAA==@kvack.org
X-Gm-Message-State: AOJu0Yzs6Pqki13S/rPmJC9Ov6xUU8tJxN4JIgQVIXchtGn8omAMXAV5
	E+5MBIW7AOXhtSp+qUwgHjlXpyhqmOQykoiZBkA2lMDHWG1/Gz5bwq284hsU0ZKRmvEidEmk0gD
	NrEco2MNOV8z8bla2p5huauMeeIz+7EJc/ZUnzE47HOovi3kbjjxP
X-Gm-Gg: ASbGncuDmycXOZ9rHvlN61d2U1KNNxfk6qOcyaRgdciJcHEVac4GtoioQvemehF6C1z
	9CJ5C26TtyE6A5wsmHvHTCEq77q1hfMjADHA/8e7lqDJFPafC1WMc06oh3l1BlwTUuF0isg1IS/
	GkSbxgCPCnEX2WNUkHBOX+DJzAFaV0HAUNHTctOG6rweld1KD+GJ2oF/+8zm3ZcNM0ywK1y8zCq
	dboPFFWfEGMorEap3LOdq/GdfakFlGjjcZgx26NF2/+W4s8yifhpsC1RDg9IIJJbiHj5eWfUVzw
	u0NXe7vYDYDAaAd58vGDBlqdxqZn9GZ/4mMkXnhy86V1y5X3UGMmb8xFSWo/Kn9qAm3fo6U=
X-Received: by 2002:a05:600c:3b1a:b0:43c:f8fc:f697 with SMTP id 5b1f17b1804b1-45868c8d67amr74577765e9.9.1753378840648;
        Thu, 24 Jul 2025 10:40:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHvjs0X1fA0kzcXhZ9W/oub8Movy4UXE750gEZ0unOi/Yu3rUYgc9Lka+eqlq8FUYlwpkRqA==
X-Received: by 2002:a05:600c:3b1a:b0:43c:f8fc:f697 with SMTP id 5b1f17b1804b1-45868c8d67amr74577455e9.9.1753378840060;
        Thu, 24 Jul 2025 10:40:40 -0700 (PDT)
Received: from [192.168.3.141] (p57a1acc3.dip0.t-ipconnect.de. [87.161.172.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4cacsm26765925e9.24.2025.07.24.10.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 10:40:39 -0700 (PDT)
Message-ID: <c69f0b21-1e67-4e1d-b56b-a5c1294e8b45@redhat.com>
Date: Thu, 24 Jul 2025 19:40:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] khugepaged: Optimize
 __collapse_huge_page_copy_succeeded() by PTE batching
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <kjveoiyczkjlm65d3agasjbtplezshwwjyudq4jbxhygcc7plm@dre33kse3y6g>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <kjveoiyczkjlm65d3agasjbtplezshwwjyudq4jbxhygcc7plm@dre33kse3y6g>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HrxBPN4u2gNQ1_1pZXY_woAlcE58rioArbA_h8CMz4c_1753378841
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DF74140013
X-Rspamd-Server: rspam06
X-Stat-Signature: wcdadmzyj171h189mjemeyjixgx6q4yu
X-HE-Tag: 1753378845-946154
X-HE-Meta: U2FsdGVkX19+fLKxhcWUWq1xpIWRSk6b7hZEMZrvTemk8bD2qj/S1lQi8RgHudyfbGwbwUnBqnwaeh2Ack+M7kRg3Kj9QCxS4DER2K6PRbUVlWwpaQdn9O2B8lzrSdfewSYTy277QLot0AngbltO3JSkus7hrkxWUKnMvvP25Biqi9N3gE4/tcbf8Kjvx9KJr32JenanPoU3P4JGDsTGBqDJOhEwQssj7tZE7hWCbm9gJq6OwxMEiYXvsCFnnNeuA1UwMe5i+TSfS0YTo8r7Rdh35SUNq+rcyugxY5AcC4hOrojLcqcZSfANbha6EBUk6zNQk+oWxszcd3sF1pdCxYfyV/RAlg5iRZSsVLoNZyh1dqOpxExjqu1HT9EpG/EiUmLFUTVUMG9OTjeRXxEG51iq8J0N5IZoQyUFY7yyNa7MKVvDGwH8YtXWNIxYar7NQEHqn/0U3sh9+mZhySbUyvd6kQHwK5/wEqRq85LMowIKjABH2+r24Ua5mplt7j7bqF3mG10RbjNOlrUiIpU0h/jUtotRu97TgH9mjuFMaw9rb5Fce8DnRypYYgQuNX+beItc7twbMs5srmh2b0ceV7SbExqYsLQ2+sUUBMSgM9WsI5p/A5NRORWfByJku4lnIEsrD94MJeB0flQLj/z70yECO8BCDrFo7j1VlkqDwPgT46ZUtjnnp+4v+m9Eei3lAL9h4eRB9LoW6NUYshizH2yfBKQBeI9kUIgQzmK9urnnS5HwH6jgq9OHDZs3apcOpry4yzOi5HzuQEFWuoGGB7sTsuIv4V08lbJ6UV5VzEZf3ZcRAph9kR/Affgo7ovMsA5R2WmDDvkh8m9+yB32GsDrtG5cyjLa7rL96DstTF8e5fndzK6h4mnuTdNicOm530CvhqettzgDnM94F+Iiw5ByudIjHUl5ts/zP/aNlgViMFiXY1KssQgjUczNvyVX4mVSkKpMB96GQNRabfJ
 Q9jwZYX8
 4Z8HURqOQAtpanN2gs548aYkWBdrLyDEP2fQihbb8RNCsIxxqw8ggueYUcI4/yus2svMP7VxrFtaUTB0nZSIs/abVKIodESlfsbJmRt/HI6h3BMpkwizw4FdWoIT5/4JnnlfZTqAlJCgk52hrBqU0M1OyqTg9ohDijoRjAMiky6ystxthXserCMmeIL/Q5jGAL0021XYB1mwKdlAxjcqMnpzCKW3/UqyEB7S3yjUk8WDpNpjzBTZYHNws4kUSsCl3k+kYJvxaTtXy2SHKS4yJCpavISFRWNPpWf8tnzSo813Z69CQlPsoJjfEoCp15XXUwylilQLKmezat8nBhn2RSELbGTBiN7w4KcYrkAkdZ5qDpBL+6YD2WGCWC5N376UqHfRArd/1c2+lV+YyEpWdEujDHBZzK9/q/WI5w8CX4KgWbk7XD3dx3qgOVZS+MLw3nhML11dgFLfZffEFmcCReHoN4Ul/ewGgcTw4P0D5lm9wRJZXQUO6ML4X0r7eGa358HdSPeXfN7P19PXRNJk+GS4lPICNabge6cNUR1EUDEnPcfzzi9AwWUstOX37F/d0Kv5o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 19:32, Lorenzo Stoakes wrote:
> Message-ID: <32843cfb-a70b-4dfb-965c-4e1b0623a1b4@lucifer.local>
> Reply-To:
> In-Reply-To: <20250724052301.23844-3-dev.jain@arm.com>
> 
> NIT: Please don't capitalise 'Optimize' here.
> 
> I think Andrew fixed this for you actually in the repo though :P
> 
> On Thu, Jul 24, 2025 at 10:53:00AM +0530, Dev Jain wrote:
>> Use PTE batching to batch process PTEs mapping the same large folio. An
>> improvement is expected due to batching refcount-mapcount manipulation on
>> the folios, and for arm64 which supports contig mappings, the number of
>> TLB flushes is also reduced.
>>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>   mm/khugepaged.c | 25 ++++++++++++++++++-------
>>   1 file changed, 18 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index a55fb1dcd224..f23e943506bc 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -700,12 +700,15 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>>   						spinlock_t *ptl,
>>   						struct list_head *compound_pagelist)
>>   {
>> +	unsigned long end = address + HPAGE_PMD_SIZE;
>>   	struct folio *src, *tmp;
>> -	pte_t *_pte;
>>   	pte_t pteval;
>> +	pte_t *_pte;
>> +	unsigned int nr_ptes;
>>
>> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>> -	     _pte++, address += PAGE_SIZE) {
>> +	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
>> +	     address += nr_ptes * PAGE_SIZE) {
>> +		nr_ptes = 1;
>>   		pteval = ptep_get(_pte);
>>   		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>   			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>> @@ -722,18 +725,26 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>>   			struct page *src_page = pte_page(pteval);
>>
>>   			src = page_folio(src_page);
>> -			if (!folio_test_large(src))
>> +
>> +			if (folio_test_large(src)) {
>> +				unsigned int max_nr_ptes = (end - address) >> PAGE_SHIFT;
>> +
>> +				nr_ptes = folio_pte_batch(src, _pte, pteval, max_nr_ptes);
>> +			} else {
>>   				release_pte_folio(src);
>> +			}
>> +
>>   			/*
>>   			 * ptl mostly unnecessary, but preempt has to
>>   			 * be disabled to update the per-cpu stats
>>   			 * inside folio_remove_rmap_pte().
>>   			 */
>>   			spin_lock(ptl);
>> -			ptep_clear(vma->vm_mm, address, _pte);
>> -			folio_remove_rmap_pte(src, src_page, vma);
>> +			clear_ptes(vma->vm_mm, address, _pte, nr_ptes);
>> +			folio_remove_rmap_ptes(src, src_page, nr_ptes, vma);
>>   			spin_unlock(ptl);
>> -			free_folio_and_swap_cache(src);
>> +			free_swap_cache(src);
>> +			folio_put_refs(src, nr_ptes);
> 
> Hm one thing here though is the free_folio_and_swap_cache() does:
> 
> 	free_swap_cache(folio);
> 	if (!is_huge_zero_folio(folio))
> 		folio_put(folio);
> 
> Whereas here you unconditionally reduce the reference count. Might this
> cause issues with the shrinker version of the huge zero folio?
> 
> Should this be:
> 
> 			if (!is_huge_zero_folio(src))
> 				folio_put_refs(src, nr_ptes);
> 
> Or do we otherwise avoid issues with this?

The huge zero folio is never PTE-mapped.

-- 
Cheers,

David / dhildenb


