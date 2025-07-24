Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0058C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65CC58E0002; Thu, 24 Jul 2025 01:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60DF96B01F8; Thu, 24 Jul 2025 01:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5238F8E0002; Thu, 24 Jul 2025 01:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC006B01F7
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:46:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB7261D9AEF
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:46:20 +0000 (UTC)
X-FDA: 83698072920.06.DA95619
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id B70CC80004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:46:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Xzy/nMRo";
	spf=pass (imf02.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753335978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNwMJnsrlfjHIfnx8+XyAkalOotEMNE2AFm+hZ9zED0=;
	b=lV+M53w6giNThUHWj/AiMuikXoha7PVDpL4FFruBCSZKKwLGRqkClS2PxRyBuxrdfHU+Vs
	Ec1J7VuInIAFLHFSVC2g9Vosh7aHptcEpXnVulVjtTD6hjtA729XmUgECtWVPXfMEveNyt
	WhCWYOszKsi6YYNdBSVFrwB3jGZmHO8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753335978; a=rsa-sha256;
	cv=none;
	b=xOuZ6bPWKkGwK686ok19EP/Gn1ufanaWDKVFZcRsUkmTKmzKOByE1qfvXcX9hN0aqFu6aw
	zwXfPWdofGVOKucf++aQynHolr1s3+VyDSOJH2PLofxlUPDzeNR20TfSpMxieZsjv9PJTW
	RFBJExAEHjCY1t0Mmcfxo9fYzze8nNQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Xzy/nMRo";
	spf=pass (imf02.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753335978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UNwMJnsrlfjHIfnx8+XyAkalOotEMNE2AFm+hZ9zED0=;
	b=Xzy/nMRohmCJsOKUEnHVPxffWP5ptKUWTzNCkHDM92bMnHc5yVp5daEmT8VfPavABXBHvf
	4yAJ9v6Y7AMN90RI+DE4m2hCjCeen3Ia9iEsLM+5kpeZsbaqyHiUGVVEDthngqG4K5ntA9
	fUfkgCtBEFuJEh1L14dAwc/bYeDAXY8=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-_5Dg--r_Pcy8o3KuoT-bQw-1; Thu, 24 Jul 2025 01:46:14 -0400
X-MC-Unique: _5Dg--r_Pcy8o3KuoT-bQw-1
X-Mimecast-MFC-AGG-ID: _5Dg--r_Pcy8o3KuoT-bQw_1753335973
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-32cbc4a763eso1995751fa.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 22:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753335973; x=1753940773;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UNwMJnsrlfjHIfnx8+XyAkalOotEMNE2AFm+hZ9zED0=;
        b=S7avcPqDCRGJfqFUtNQFI+SeKPHpn/mx5ZCx0eMmKl9Sn6jv+munAKiATjpFxLnRSg
         zcbunE4jpa+VdX2ViM1Dujqs23oENe8mHiYfCGxtuENI8gw/eAAqmtZyxnWzjERgO4xF
         z7EKB0h35ulbeQqmt1vwCqcigGlkgRTgqG8vnrb+w4gDiJLDVc1rbR0pUmo6fLC14lYq
         I60LWYh65MoZF25ohdIXkvrk0qx4+unm7AM+Om7xsu97yIiku38R3dUcBS69uEb3TMlS
         8fMAjUqeuB4DEeiaxyJYkKrDnuuZKHjIjzeYvxpinJzyDMW2O5QE8TH6aMv/6e6UfjLt
         X6AA==
X-Forwarded-Encrypted: i=1; AJvYcCX2Xubry0LANLP0x17uaEm5yQQ/foe7+98k06b+IwVsA6/yusZIHNsCVoDJittPf6iuS8FuWPcmWA==@kvack.org
X-Gm-Message-State: AOJu0Yx6O/CQD8nwkS4Yt3XiGN3VxOjxLTE4jhIlRaw+Kxt6I2E4EuGe
	vGWkbXXyXV1r+lj8PLzNV76B6KROEjELzC2taFg7relg0LYX9YhBoW6ZISD8HoNzcPSKjtgyO6K
	pN9btH+jGDmfazqJOzQ5EEe+lC+CmCqMaOzPF6kP4xzrc2BXqhxE=
X-Gm-Gg: ASbGncuDsOV/rXaTNp3fEeptHas8rpJiXczR5wPx9vtTtOfhkUKE9h6L8B5I387tLb+
	jxr5cEXIgKeUlV4S8khJnBwyWyNR9We/dSkXVhuwTgVZDGHvoBorNXC/s+buYUIQTQvLTbiShZy
	n1uAfRCps7AdYZwTbORwYymFMZvlVndntBFI035/eQVU9Cefo3u6KNjQV372s0/TO1ryhU4JYJB
	Ws3CwIqpGqNA+Sn7HvaQx9I95RJpWnOR1k0peuprMTVCxg3lha2W09KAb8nosPDsxG8PY8eYkFf
	2o6XRUkBr0+ZE44uWJ8jJNGi/IShz3df7nw8y34m5pX0maVj7kUrfCyC/XgmwUsdCg==
X-Received: by 2002:a2e:b88f:0:b0:32b:a7d2:a8b1 with SMTP id 38308e7fff4ca-330dfcf9563mr17781701fa.12.1753335973025;
        Wed, 23 Jul 2025 22:46:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVuWN3kjiXBLdFUiaycJpmnxFsCty+fYD0fmCcRFhmov/er61nqrT1/bUmvuEMXStaMCRkdw==
X-Received: by 2002:a2e:b88f:0:b0:32b:a7d2:a8b1 with SMTP id 38308e7fff4ca-330dfcf9563mr17781521fa.12.1753335972491;
        Wed, 23 Jul 2025 22:46:12 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-331e079336bsm1708151fa.32.2025.07.23.22.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 22:46:12 -0700 (PDT)
Message-ID: <dad71615-0eba-4a8d-abfc-979fb815511c@redhat.com>
Date: Thu, 24 Jul 2025 08:46:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: Do not fault in device private pages owned by the
 caller
To: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>, airlied@gmail.com,
 akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dakr@kernel.org, david@redhat.com,
 donettom@linux.ibm.com, jane.chu@oracle.com, jglisse@redhat.com,
 kherbst@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lyude@redhat.com, peterx@redhat.com, ryan.roberts@arm.com, shuah@kernel.org,
 simona@ffwll.ch, wangkefeng.wang@huawei.com, willy@infradead.org,
 ziy@nvidia.com, Balbir Singh <balbirs@nvidia.com>, jgg@nvidia.com,
 Leon Romanovsky <leonro@nvidia.com>
References: <9ae3e014-c7d0-4d58-af0e-925bcd9e4cfd@nvidia.com>
 <20250722193445.1588348-1-francois.dugast@intel.com>
 <023ab16d-f3af-487e-a7ce-929bf7b2fe3e@nvidia.com>
 <aIG+gqY2YRqBeKlh@lstrano-desk.jf.intel.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <aIG+gqY2YRqBeKlh@lstrano-desk.jf.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MX5S3mUsxYjcbPzrUVvyCsTM-5XqKp0PJOjHafaCQpQ_1753335973
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B70CC80004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: jb5orzu8padiifiy4h89riupwu774noz
X-HE-Tag: 1753335978-130678
X-HE-Meta: U2FsdGVkX18CV2sN8VyWIEZIGPU8TkaEoCodxBSHtiTeB3e5jTO0BZBoRl0bDg+OAy9Hoy9lTpXRp8qyYPyHH5lmG+ANcqG7x8YW+BRB0y7DHzontOifVWv9XVAgDQj2cFx+DLDY7KM4H6qKL14n72s8ygm13ZagUCUc2uO/Wmk5+8gNjgYMGx+Y7JLIxwThmuQsnReouVH/1/e1C2oThbXRI5SGOJOhy9r6ZkW77i+FEKo4pNRJLidmbqgijh82v9HE6DvpK6ocDtVzJmlL4054GFk6BTfhDRhP1Zu3Sop3ch+jeUj8ZoVDAvuY6Mawg/NOF2pkthP5QIFobrW78qWjK1GHfvYXje6+RkyjB2lpBRuOFp9lUmJQcaJHJ4AEaXRhC5i8+JMSyg3c4iXTxc4aI9QSsxv/ogK0JhXThgoO57yMj+VGsi/sVaMhAilP+YuiWhrQWPeOXuI3kCLKx08kTQHnewkibOBkYXv3Jgfhq/og25Dxv6RkQDtMSWmte1lMT8PT0UUUgawITUs+aos4WVyhjU7ymWD+Auch7FUHDMhl2uqCEdaGjPw6B3xgCwILXzhxUNC0KixrPCbFv0RHCs9wTQoQ+f5CeCRJHMO9JsJ/dPm9KM6KDBfKo2ulRrhIbGYdMKgmkXeLH5sG8Tqd4YmvO2sQKevx0742w38kqEzT6muhkqT6beU49R5q+fP3OA5LC+BQKPbtP6oqT7rWY5FoaCQKCEmliZ70Nlmpxe90A7sBIdA+Mnfek1Md9kFJNDpu2YzLzhW+bPjsIpGZSfptTBXyV7A7+cWwAFNe9Qco1enCSxWgRAnSM/OZco+6Hoopiyf0lYD7s+/BvTR7BkCI/qiAVcKXM6iisXZNzNg3ZgDc9bhHLN87XJJbZty9HveoRgyBB8eIV3qYpToKcbO42kKKOVqZxIliX/vgKIhDlgwT4ixEqIyQmuRM5aUms+uj2YlRbigFiAv
 MQzwp6UH
 MUcys
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/24/25 08:02, Matthew Brost wrote:
> On Thu, Jul 24, 2025 at 10:25:11AM +1000, Balbir Singh wrote:
>> On 7/23/25 05:34, Francois Dugast wrote:
>>> When the PMD swap entry is device private and owned by the caller,
>>> skip the range faulting and instead just set the correct HMM PFNs.
>>> This is similar to the logic for PTEs in hmm_vma_handle_pte().
>>>
>>> For now, each hmm_pfns[i] entry is populated as it is currently done
>>> in hmm_vma_handle_pmd() but this might not be necessary. A follow-up
>>> optimization could be to make use of the order and skip populating
>>> subsequent PFNs.
>> I think we should test and remove these now
>>
> +Jason, Leon – perhaps either of you can provide insight into why
> hmm_vma_handle_pmd fully populates the HMM PFNs when a higher-order page
> is found.
>
> If we can be assured that changing this won’t break other parts of the
> kernel, I agree it should be removed. A snippet of documentation should
> also be added indicating that when higher-order PFNs are found,
> subsequent PFNs within the range will remain unpopulated. I can verify
> that GPU SVM works just fine without these PFNs being populated.

afaics the device can consume the range as smaller pages also, and some
hmm users depend on that.


> Matt


--Mika


>
>>> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
>>> ---
>>>  mm/hmm.c | 25 +++++++++++++++++++++++++
>>>  1 file changed, 25 insertions(+)
>>>
>>> diff --git a/mm/hmm.c b/mm/hmm.c
>>> index f2415b4b2cdd..63ec1b18a656 100644
>>> --- a/mm/hmm.c
>>> +++ b/mm/hmm.c
>>> @@ -355,6 +355,31 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>>  	}
>>>  
>>>  	if (!pmd_present(pmd)) {
>>> +		swp_entry_t entry = pmd_to_swp_entry(pmd);
>>> +
>>> +		/*
>>> +		 * Don't fault in device private pages owned by the caller,
>>> +		 * just report the PFNs.
>>> +		 */
>>> +		if (is_device_private_entry(entry) &&
>>> +		    pfn_swap_entry_folio(entry)->pgmap->owner ==
>>> +		    range->dev_private_owner) {
>>> +			unsigned long cpu_flags = HMM_PFN_VALID |
>>> +				hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
>>> +			unsigned long pfn = swp_offset_pfn(entry);
>>> +			unsigned long i;
>>> +
>>> +			if (is_writable_device_private_entry(entry))
>>> +				cpu_flags |= HMM_PFN_WRITE;
>>> +
>>> +			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
>>> +				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>>> +				hmm_pfns[i] |= pfn | cpu_flags;
>>> +			}
>>> +
>> As discussed, can we remove these.
>>
>>> +			return 0;
>>> +		}
>> All of this be under CONFIG_ARCH_ENABLE_THP_MIGRATION
>>
>>> +
>>>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>>>  			return -EFAULT;
>>>  		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>>
>>
>> Balbir Singh


