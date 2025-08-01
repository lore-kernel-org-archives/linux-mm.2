Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB3AC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 14:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A956B0096; Fri,  1 Aug 2025 10:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3146B0098; Fri,  1 Aug 2025 10:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B1D6B0099; Fri,  1 Aug 2025 10:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A7C9F6B0096
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:13:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60D1AC0126
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:13:44 +0000 (UTC)
X-FDA: 83728381968.23.5D6EA55
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 02821180010
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:13:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="OO/u4c1/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754057622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbFv2TD7NDloKozndUcyagdfd/67A0nNkTyyQSYo1J8=;
	b=ZxsHwmldBFlOHFX7q8OIt5//gEupQ2/cEGtKYaqV8zZvcbJHdLcfphsKIWfXcX3SKJV3f+
	9ghPtTpTDWDEsFqZtLdmhSFEdg63yri7j+2C1vCB0k0lGiSK06byaozaSqScyR5UIqdlvw
	0TD6/d2kde0GMjtcnVtKhEjlw8wY3X0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754057622; a=rsa-sha256;
	cv=none;
	b=KZ0iehTy76YeAABkYCOvUIL7t0RBW9kVcjdYIY2qqu1a4x82FYLijYaQhbFySs4WPyqUCe
	g1Zq9ZFpGjxD9qgVjcTG2E8c3G+QHHjFLXXRRkcTvm5zJP9oTkhmUJ721eW5Ds5XhAIA7r
	nqPtLqa3LGG1UTIMYmCF5YaWIIlGYJ4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="OO/u4c1/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754057621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EbFv2TD7NDloKozndUcyagdfd/67A0nNkTyyQSYo1J8=;
	b=OO/u4c1/RIzkLtmdXN0ce4l3cJ06MNu20FIjmDV6+ceDyWVWlVndOy9e3eL7HoRPRylDDo
	FHpjdAqod+jWy++LNbshv0eydf8Uoic7cHnDUw7slTnpOxvJTvowD26BryiSC7hiibZnbV
	mEdlt2zchqhIBb05XGnKK/7SrmDXXRQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-ml_IQXyJMM-s8HWJNezHSA-1; Fri, 01 Aug 2025 10:13:40 -0400
X-MC-Unique: ml_IQXyJMM-s8HWJNezHSA-1
X-Mimecast-MFC-AGG-ID: ml_IQXyJMM-s8HWJNezHSA_1754057619
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b78a034d25so1666219f8f.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 07:13:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754057619; x=1754662419;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EbFv2TD7NDloKozndUcyagdfd/67A0nNkTyyQSYo1J8=;
        b=H2HLH04fR2fMDryCHLN4lZEdP2UBMV4ffyTseRLatpS3eWukeXcuAYvzwEVbRSJM/c
         KmzVkHNKILWRLJrp9qJotZNmfUabjLP0cvJRPmEb97AMJ3pqpWMXjJHc50gvUSRNUECN
         ADZ46oYc6zLuE4Lk+0btC54hYjScZ7ifAXEa0LZ02UTQ4mK/vTDGzmTVc6YVqoAf+KBe
         +QSwmrIzXi+7rSKkTZCia6mYPqMIPqN09aTdCjJrPQqnRyPnoVdiuLNdF/Ss6nPoKZRZ
         Pk16D+pVWRR9QPGxV45zwSkq/BPV8M4Q+IuYcVBgk7onU+5ZZYiyYjipr33JdMOnFas3
         ozsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZpXaxCeI3BJALucy62c3hftyBQSmxWyWCeGVgWGJq1v5J6mXYvzX8KuJcqiLS05NoeA6R9GmITg==@kvack.org
X-Gm-Message-State: AOJu0Yzw9XEqUP3Umi73jyK0cQlXoUDx62wduMhZoha49ssuYCJyavWv
	MD5IPDeQ/4aiTNUSgE35ykEKuiVRKpWhEeyrnP1XF6ydf3k02psnxmzyhCuPrlC2W25Q4ZuOFtW
	E5pfaUvRJR4AxHu5Uaou0sG/BEvwMXl6KjPPMUu1i74ASV6rK9Rwm
X-Gm-Gg: ASbGnctroiKVKdehDj40mT3zf5MnfGuPUIfJjYeW9d83pa9z3d0NbsyKZi4uMU4W85V
	wD6Ya3Zy1qv7QuM2+6Kl/R1ago8iheyjowgcoUrjwaNi6CdjIo5/T4t0XVMgKO1kCdFv8X+YRH9
	fEkVErzdtIwwN/2Bpw36eiS8h86FiIiARGw77BeDFoY2uJ/TKQHnfIVZI4BTkzgTHuMvV50l1qP
	LkSP9G2fLmVGFgka/H1v3GbCfluY8UvtJiQl2ANghMU7GCO1eWg6PzVGU/Zgm9hA9C5tEzJj0Il
	0cbBZz5HeNkvP5A6xCg1ozzGWefxo/nzkq38gmY6/H/wTkqJjqFzk3ez0iTohASIY7mQoL7BSJw
	Zt80v0Aah0Ur6ezPNk1oK4ktQ2ACqTZn79o1BROum1AtI4fE+MzC0fmirhIcGQpWQ
X-Received: by 2002:a05:6000:401f:b0:3b7:76e8:ba1e with SMTP id ffacd0b85a97d-3b794fe4fe6mr9647140f8f.11.1754057618878;
        Fri, 01 Aug 2025 07:13:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJTKNrIL7Q9PR+TZ1c1/4AnaNhnzCQk8bo5y4cNtdcfLm5Ah+gjARoH1ht5K9SxH9oWHUnAg==
X-Received: by 2002:a05:6000:401f:b0:3b7:76e8:ba1e with SMTP id ffacd0b85a97d-3b794fe4fe6mr9647105f8f.11.1754057618361;
        Fri, 01 Aug 2025 07:13:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:7500:5f99:9633:990e:138? (p200300d82f2075005f999633990e0138.dip0.t-ipconnect.de. [2003:d8:2f20:7500:5f99:9633:990e:138])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589ee628fcsm66571965e9.31.2025.08.01.07.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 07:13:37 -0700 (PDT)
Message-ID: <286466e3-9d1c-40a0-a467-a48cb2b657b4@redhat.com>
Date: Fri, 1 Aug 2025 16:13:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/userfaultfd: fix missing PTE unmap for non-migration
 entries
From: David Hildenbrand <david@redhat.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
 aarcange@redhat.com, surenb@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250630031958.1225651-1-sashal@kernel.org>
 <20250630175746.e52af129fd2d88deecc25169@linux-foundation.org>
 <a4d8b292-154a-4d14-90e4-6c822acf1cfb@redhat.com> <aG06QBVeBJgluSqP@lappy>
 <a8f863b1-ea06-4396-b4da-4dca41e3d9a5@redhat.com> <aItjffoR7molh3QF@lappy>
 <214e78a0-7774-4b1e-8d85-9a66d2384744@redhat.com> <aIzAj9xUOPCsmZEG@lappy>
 <593b222e-1a62-475c-9502-76e128d3625d@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <593b222e-1a62-475c-9502-76e128d3625d@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cNz3k_cFIily3im-eSHZdtiVGSg-h2WmJ_WtnLqFxaY_1754057619
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 02821180010
X-Stat-Signature: cuy9yxerci3gtbi6ofc3b1wxb6wzsw6p
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754057621-93873
X-HE-Meta: U2FsdGVkX18ZCdWZ3Mvw9d9yyGpUJgRwDPcwOqu96hkkqQjGWg1cqYDKc+xiHWOvytyHsyOCKaY8k1/z5pl8n2o4OZ8+zcB/MzAUFrp+L6Qp/XiDB23/7uCgS5R0s78e8mMvRPHCy6/y2mkDOsIwkwQIcD2sm6PN2WE+r6oPSBBwCWIV7U4s1acDdrYrnCqpFvJESrsUieuwF3kWl9MMpDy28lCyKswfsW1pAk69RaIV4J43tITNmK+NdO4bahbmgANeeCnMbY6Xn+GhhilolBElciRYZZ3FioHbH1lloTcudMlsD8H+cb7bC8Bu5Fs7+4L4cYKubZvbmIBn5TGr25jfg6TZhLs9yv+AA11RqQIhP5ELMP+kVKfkvcwuH+CH6KnB9XnQnfe8NTjsU4ZH9R1Po17x4717KpPIUIJu0G4I9qkmJPtLmuP5yNqRVXf+3IvdTb/lzavHjhifa3SNgjerW80ATF6WGYwhimPiUP/QCk5X7fCSgObtWOcMQrCZmlR3b7M1nAOjXiKDLXs9BXY9+eOWTPQoCQ0twoKNaPk7VLcrCd8gUlFBWh+JJ9jCWdD5bFYDrIJT90FB3kHVrj17zIywQlaJQi9UiRx4SV3PhYI9+XYASK62I9V5r1OCfAWhEgCSHCDyp3N9dN+PoCp6ROa6aZEDwYTkl3eT+bChz049sB6YjIkq4IPiSzoAurggc5cDWgImEFMTJz9qF7mhlszoGjBALNpO4spAPGaQnK51BJRASJep1+nMXdCTCHSkktaB1ThY932hELfmIMCng+ttJWsbAmNe8G2i4RVUBAvvFH/CAEqwsGEUUT7aO1Bcao2CjRSbkASqjDH3VEfFwD3UkA3BFmrf749EONxC03uvVHUOxSQSuJ5WfXaRLSLiaQIISkPnZ3j8/Uff464ypeOHo1ZVcQVCWl7R4mx1GRAmd0jC/Ztyh/n8S4RNgAOqHGP5zE1FN5hKA3z
 vEoRmlTo
 NKEmA3FCY/3DQREW3tsiO3FZJKiu/GGGkrIxRiaBzFgOgpE2EogCUbA62i29P8cr1RrX1eGIcppZz5YjS+3Z3IhFb68EwuWWAi7mJ07yC+bxn0OyTN1v0wrR5I68ePat5+FPQbIsJMjN+m8hHaHRkxJA9f7N/Woz9YDwiu5YDQaKC7EgQEOZIVJ7mChG/4mcppE0XuuT2VqQvp7KPQNI64BxfEHF3ErEYAM+GUziLkkWnIsq2yHyB/YDD+sGpl6/PSBJQo9y5ksj6pjEAgq6AfPi4q2CDzstPSN6il4bjYVHd+qaAdCGEam8nMdkYFMaxYd2CxTcraBJANz73aL7eknGppIaJ7LSNiUGWjuXNJc9pVbjPMDN06yG+dmj1xRazb5sgu5oz8Tn6LF+gBi2wSEFoBcP1iFGj4foTCoGtwe0wxJFE3u2QH9MlXpVmXkB4wp4Ctw6Op2hctinjMSXHJ5lJL7HjO6BDKUKA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.08.25 16:06, David Hildenbrand wrote:
> On 01.08.25 15:26, Sasha Levin wrote:
>> On Thu, Jul 31, 2025 at 02:56:25PM +0200, David Hildenbrand wrote:
>>> On 31.07.25 14:37, Sasha Levin wrote:
>>>> On Tue, Jul 08, 2025 at 05:42:16PM +0200, David Hildenbrand wrote:
>>>>> On 08.07.25 17:33, Sasha Levin wrote:
>>>>>> On Tue, Jul 08, 2025 at 05:10:44PM +0200, David Hildenbrand wrote:
>>>>>>> On 01.07.25 02:57, Andrew Morton wrote:
>>>>>>>> On Sun, 29 Jun 2025 23:19:58 -0400 Sasha Levin <sashal@kernel.org> wrote:
>>>>>>>>
>>>>>>>>> When handling non-swap entries in move_pages_pte(), the error handling
>>>>>>>>> for entries that are NOT migration entries fails to unmap the page table
>>>>>>>>> entries before jumping to the error handling label.
>>>>>>>>>
>>>>>>>>> This results in a kmap/kunmap imbalance which on CONFIG_HIGHPTE systems
>>>>>>>>> triggers a WARNING in kunmap_local_indexed() because the kmap stack is
>>>>>>>>> corrupted.
>>>>>>>>>
>>>>>>>>> Example call trace on ARM32 (CONFIG_HIGHPTE enabled):
>>>>>>>>>     WARNING: CPU: 1 PID: 633 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
>>>>>>>>>     Call trace:
>>>>>>>>>       kunmap_local_indexed from move_pages+0x964/0x19f4
>>>>>>>>>       move_pages from userfaultfd_ioctl+0x129c/0x2144
>>>>>>>>>       userfaultfd_ioctl from sys_ioctl+0x558/0xd24
>>>>>>>>>
>>>>>>>>> The issue was introduced with the UFFDIO_MOVE feature but became more
>>>>>>>>> frequent with the addition of guard pages (commit 7c53dfbdb024 ("mm: add
>>>>>>>>> PTE_MARKER_GUARD PTE marker")) which made the non-migration entry code
>>>>>>>>> path more commonly executed during userfaultfd operations.
>>>>>>>>>
>>>>>>>>> Fix this by ensuring PTEs are properly unmapped in all non-swap entry
>>>>>>>>> paths before jumping to the error handling label, not just for migration
>>>>>>>>> entries.
>>>>>>>>
>>>>>>>> I don't get it.
>>>>>>>>
>>>>>>>>> --- a/mm/userfaultfd.c
>>>>>>>>> +++ b/mm/userfaultfd.c
>>>>>>>>> @@ -1384,14 +1384,15 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
>>>>>>>>>    		entry = pte_to_swp_entry(orig_src_pte);
>>>>>>>>>    		if (non_swap_entry(entry)) {
>>>>>>>>> +			pte_unmap(src_pte);
>>>>>>>>> +			pte_unmap(dst_pte);
>>>>>>>>> +			src_pte = dst_pte = NULL;
>>>>>>>>>    			if (is_migration_entry(entry)) {
>>>>>>>>> -				pte_unmap(src_pte);
>>>>>>>>> -				pte_unmap(dst_pte);
>>>>>>>>> -				src_pte = dst_pte = NULL;
>>>>>>>>>    				migration_entry_wait(mm, src_pmd, src_addr);
>>>>>>>>>    				err = -EAGAIN;
>>>>>>>>> -			} else
>>>>>>>>> +			} else {
>>>>>>>>>    				err = -EFAULT;
>>>>>>>>> +			}
>>>>>>>>>    			goto out;
>>>>>>>>
>>>>>>>> where we have
>>>>>>>>
>>>>>>>> out:
>>>>>>>> 	...
>>>>>>>> 	if (dst_pte)
>>>>>>>> 		pte_unmap(dst_pte);
>>>>>>>> 	if (src_pte)
>>>>>>>> 		pte_unmap(src_pte);
>>>>>>>
>>>>>>> AI slop?
>>>>>>
>>>>>> Nah, this one is sadly all me :(
>>>>>
>>>>> Haha, sorry :P
>>>>
>>>> So as I was getting nowhere with this, I asked AI to help me :)
>>>>
>>>> If you're not interested in reading LLM generated code, feel free to
>>>> stop reading now...
>>>>
>>>> After it went over the logs, and a few prompts to point it the right
>>>> way, it ended up generating a patch (below) that made sense, and fixed
>>>> the warning that LKFT was being able to trigger.
>>>>
>>>> If anyone who's more familiar with the code than me (and the AI) agrees
>>>> with the patch and ways to throw their Reviewed-by, I'll send out the
>>>> patch.
>>>
>>> Seems to check out for me. In particular, out pte_unmap() everywhere
>>> else in that function (and mremap.c:move_ptes) are ordered properly.
>>>
>>> Even if it would not fix the issue, it would be a cleanup :)
>>>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>
>> David, I ended up LLM generating a .cocci script to detect this type of
>> issues, and it ended up detecting a similar issue in
>> arch/loongarch/mm/init.c.
> 
> Does loongarch have these kmap_local restrictions?

loongarch doesn't use HIGHMEM, so it probably doesn't matter. Could be 
considered a cleanup, though.

-- 
Cheers,

David / dhildenb


