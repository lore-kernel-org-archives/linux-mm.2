Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570F6C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 06:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95BE6B0173; Thu, 24 Jul 2025 02:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E469B6B0174; Thu, 24 Jul 2025 02:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F1C6B0175; Thu, 24 Jul 2025 02:04:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BAB6C6B0173
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:04:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 656F2C02AA
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:04:45 +0000 (UTC)
X-FDA: 83698119330.13.75144C9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10638C0003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:04:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QtcTdTlf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753337083; a=rsa-sha256;
	cv=none;
	b=7loRJgru6w/DXrMbCanx4V4PfSV2BdH3a+UvZ50Foj/aVvQNnnwNt13xCOAFiIhGoMzUrt
	r67IcksB4ULDUtXayMpYeKAF92NT/OYN/ypXuSBQSUnoeNMrVDud/2sMrQOsPVZYrJOF2g
	8lb93QFrA3MuSII5drQn5QeGpUgjlLM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QtcTdTlf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753337083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccZ81ZlUeeRi2wfgmebHDybZVstxHsPhDJfQob29cPM=;
	b=FeGAbXUbZQ2GY+qIrZfqyVO1GOc1r+ri2g9WgwiC4OQCMGRuZPQCmwLGTUFkAV0HsOBUdu
	sUo2NVTZRIDCLgVIztWea+Ch9Vr000gd6jFHSNpr2tDctFGykdnROgO1CgDAhCZWggYoeE
	oMVZjXQvZSgONcCKVm6pRV0X3e/ZQUQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753337081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ccZ81ZlUeeRi2wfgmebHDybZVstxHsPhDJfQob29cPM=;
	b=QtcTdTlfMkU5YXnSbTjDEWv0bnbuwTFGWvjE5IrHKnwr3tBtFXKZm6uev/v25GJjk0vOzl
	DjjBF6wz0SmkgRrv2bZO3ltC/MjZdjlQNf34v7XCd8KHY15qrSVxKXdYI0tJxcIFkht0ze
	99J0mtCqMgcuwcblFaLJkOdn5zpcGTk=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-69mD6odGMP-KJd98s-DqRQ-1; Thu, 24 Jul 2025 02:04:40 -0400
X-MC-Unique: 69mD6odGMP-KJd98s-DqRQ-1
X-Mimecast-MFC-AGG-ID: 69mD6odGMP-KJd98s-DqRQ_1753337079
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-555024588e2so337798e87.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 23:04:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753337079; x=1753941879;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ccZ81ZlUeeRi2wfgmebHDybZVstxHsPhDJfQob29cPM=;
        b=EHk9jBmYZkN2WV6QEZUia/G9yd7rEIm7UJsCpeg7WGz7rOfNwrJmldVZxPTVlEmxNH
         lxVsCaGb6pm8ZW88hNtv0lYicuhH7Ec41TQPJ6sU8OHMn0YOwzQrlVGa5527z6x4mJxG
         FMWYl43CTURrh9ojNVX/73C2To4wnET1K94nqAloC6B5kf4DToMe55xFaYnAHq+3CGOL
         HX3zUO2UWH8mxio668qUAYD2WWAl+thVJ/AR46X5/Fk52zmOudEWPFl3267dn2KxsKgv
         qbcWiRvxJxbTtppZmnsW7piNA77cgbg+1i757tTaqxGmuhr9Xs60FLUOWaZcQyKDEIEM
         2+iQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1MVL+ZO64D6QXS4zp2mzKjMP8AXa1UGZHzihZH1TUr6M3tIBkv245OeFJPWe2weQ8rf93K+guOQ==@kvack.org
X-Gm-Message-State: AOJu0Yw6apvsN5H587uRYlzxWPHCDXdb+1CS6SxsZXv8weOafURqH55X
	kq3Dwy8nB97rOGjJMPzb0A088ik8iSyxCPPPob2hPRBI03aZedmWmxVdzKM+JVK+MCsmO5DZD/a
	f0O1uglTaUNTDEr0ZxWyGQySeqO/eSa6/pp0fVZaHEkcwxDKkqDw=
X-Gm-Gg: ASbGncsz173cnc6RGlmkRxwgZQ8/ANu/cMqXBbu4xXTSQXfO1hECRBXBWao2AduQDXw
	IhAw2S8dHff+IDGu50Y6jHmjPwfxEqeF9ddETgWwOpb8x32MjAkPjgl/IyasUWZMH/naDo8zS8b
	iYVHXmCczP1MxtZP9c2BjB40FkAEposK5qTAYlSoTTtn2Lrg/KGmW+yMgugFtxVjT2TKa7ojfbW
	vVj+47m7Pt+BT/vNKBhLzecFPNtnF2IFn15UTAUJTL2zdqKGOfdoXd8GZ91OoBpX7nvsmNfAXsA
	fjTnSzUBXAOHcTIHLD9Zp4Sg1sR09+YES+vZDU/hbGQlpCsYv0L+W+uFEkD9hIaqLw==
X-Received: by 2002:a05:6512:2208:b0:554:fa07:c60 with SMTP id 2adb3069b0e04-55a513c213amr1911804e87.34.1753337078551;
        Wed, 23 Jul 2025 23:04:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnCw/KB+3dIXEoU6waww4AHDaUQMrgUdTBjRzH+fX3UUbcMIPvjmX7Jt0OS1gjnbZ536mDdQ==
X-Received: by 2002:a05:6512:2208:b0:554:fa07:c60 with SMTP id 2adb3069b0e04-55a513c213amr1911766e87.34.1753337077998;
        Wed, 23 Jul 2025 23:04:37 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b53b22ea7sm192788e87.43.2025.07.23.23.04.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 23:04:37 -0700 (PDT)
Message-ID: <368fa1c1-fccc-445d-bd22-0053fd2db29c@redhat.com>
Date: Thu, 24 Jul 2025 09:04:36 +0300
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
 <dad71615-0eba-4a8d-abfc-979fb815511c@redhat.com>
 <aIHLWnjzKWma1NLC@lstrano-desk.jf.intel.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <aIHLWnjzKWma1NLC@lstrano-desk.jf.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ST7d5kn6L_0AUArkjThdfPo0Z4LSVpSr1VEf41OOrRw_1753337079
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ah5jchox5hxifoo9kx1beesc97qnyhti
X-Rspam-User: 
X-Rspamd-Queue-Id: 10638C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1753337082-274202
X-HE-Meta: U2FsdGVkX1+uE7G9udZY5PCu4D9BSIgscVm21zU6rsj545cvxM4fEtfgjIZqaRZDNbjr5u4QvPcJ1YGdS2KzzGQzcSD2v2kl1Ubgyj4GgUVkZIf4ZMP+V/s9RiY5rTSGCv8t9z8luOjSTAGVQ0SIduGpkVZ4lq/x9wf3phesL6zqNONuz0Bj4qAMyOx5m5j72kj3qnw37pQ6U3Lqx+6FC6JpmzgwAsNWFPEbOFe3FT9PIR1z7M6ONxkEkO78yn+3O1Agf7Ia4JqydisouufaG8ZVygm/2x9wEydYdhIECf0dyAfo3fMkmNZVHezlKjQteqhFiPUNdcU8jGv/WASYQh5/Nlt2+dWeAh8qAPLVTvN0ZSJfYQiT5wZ8RyqzUxE0NwsPpyo1/ASUxB4fKm6e+56aIgXWyLgzFSzuxTB2Sp2px/L6MJudIVai3Wg6Yooy+1xIeWg+CP326dnyO3szvSEXBKRRG8DDx386m4Ukb42Sp6gGpY/n1gmFnr5teaLzjjvkSYJ9zihXShfOw0Ys0wx+MGo+eidOkC0SJjU+j9oiugWw3FKpQ3JjZHOdaMp9yQHqeRd0GlMrLT31Vjl+kyFWPKxKO/SL3HrsC/5vBCK32BboU5/s2SzR4zcav29NSizX/MPSLChVrhb/8jFnO6jaby1/VcZrOk8qJdsWGSkonnnif2Ga6LQMuQwDBAkzuOhtDT+moGSMFoc7bktBUXAs/DyX9LzIpQJx2uPK11iTNvSGtxG3s2kqjiHEa+ejxcno65VsNwvidpxBxPHfZf7tNAOaxYGQLzSGQzJXHjrMiMWsVRWaGiLNTwMgJdVgq9lvAhL1YgBDC2a90qIPOORw4HA8KK/BIj6x4gel5uiTM8lkhH0A04+6mDv6gg3F7e642vUrXxeae7Yf6zN/L1MkAQ0TxqxPebI0xix/MKDhamm6Vnb+HaqFLnDCRu/O2QFHlXapY+D5s8Z0GGN
 s0npmn85
 JoJQmJti8PcW00EnMh2rKdy+IMZZXi3UOhv/6/cijA4nXRu9ZWdNXQSfWqK5jOvSGM4sBS05E3YPvhv2XRP6rWGwxXZg+LpUOOXUpl8vuMzjLrCrV0BWdfAG87XDFmz9dNd9B/O9e9eUp+uVPCH/6ZR4cZqotjaXqjJ4nNMDtikXLel/2msFEyUxHGVYnyoYes6n+JnoTmu8jdUoeDrl8ONFrDAHTere+P4xrY2Hc2h9U/W2VgBjvQTsE2jEj2U7xxI3CO153wvFOZToU20xIwQOe5hzlRG9YJweczAvx62uKYPuP8q8wQ1fLw0nF5kj24MfJAt8tXDrVle6QnXf8hxEW+BpVq/c7bsR7wySZeUrOi61nMOhu7MaNwU3WvSCNBLnsMFqIWRqaJ8xh0BPKKc9dzmwM76iQkF+4FEY83zn6a14=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/24/25 08:57, Matthew Brost wrote:
> On Thu, Jul 24, 2025 at 08:46:11AM +0300, Mika Penttilä wrote:
>> On 7/24/25 08:02, Matthew Brost wrote:
>>> On Thu, Jul 24, 2025 at 10:25:11AM +1000, Balbir Singh wrote:
>>>> On 7/23/25 05:34, Francois Dugast wrote:
>>>>> When the PMD swap entry is device private and owned by the caller,
>>>>> skip the range faulting and instead just set the correct HMM PFNs.
>>>>> This is similar to the logic for PTEs in hmm_vma_handle_pte().
>>>>>
>>>>> For now, each hmm_pfns[i] entry is populated as it is currently done
>>>>> in hmm_vma_handle_pmd() but this might not be necessary. A follow-up
>>>>> optimization could be to make use of the order and skip populating
>>>>> subsequent PFNs.
>>>> I think we should test and remove these now
>>>>
>>> +Jason, Leon – perhaps either of you can provide insight into why
>>> hmm_vma_handle_pmd fully populates the HMM PFNs when a higher-order page
>>> is found.
>>>
>>> If we can be assured that changing this won’t break other parts of the
>>> kernel, I agree it should be removed. A snippet of documentation should
>>> also be added indicating that when higher-order PFNs are found,
>>> subsequent PFNs within the range will remain unpopulated. I can verify
>>> that GPU SVM works just fine without these PFNs being populated.
>> afaics the device can consume the range as smaller pages also, and some
>> hmm users depend on that.
>>
> Sure, but I think that should be fixed in the device code. If a
> large-order PFN is found, the subsequent PFNs can clearly be inferred.
> It's a micro-optimization here, but devices or callers capable of
> handling this properly shouldn't force a hacky, less optimal behavior on
> core code. If anything relies on the current behavior, we should fix it
> and ensure correctness.

Yes sure device code can be changed but meant to say we can't just
delete those lines without breaking existing users.


>
> Matt


--Mika


>
>>> Matt
>>
>> --Mika
>>
>>
>>>>> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
>>>>> ---
>>>>>  mm/hmm.c | 25 +++++++++++++++++++++++++
>>>>>  1 file changed, 25 insertions(+)
>>>>>
>>>>> diff --git a/mm/hmm.c b/mm/hmm.c
>>>>> index f2415b4b2cdd..63ec1b18a656 100644
>>>>> --- a/mm/hmm.c
>>>>> +++ b/mm/hmm.c
>>>>> @@ -355,6 +355,31 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>>>>  	}
>>>>>  
>>>>>  	if (!pmd_present(pmd)) {
>>>>> +		swp_entry_t entry = pmd_to_swp_entry(pmd);
>>>>> +
>>>>> +		/*
>>>>> +		 * Don't fault in device private pages owned by the caller,
>>>>> +		 * just report the PFNs.
>>>>> +		 */
>>>>> +		if (is_device_private_entry(entry) &&
>>>>> +		    pfn_swap_entry_folio(entry)->pgmap->owner ==
>>>>> +		    range->dev_private_owner) {
>>>>> +			unsigned long cpu_flags = HMM_PFN_VALID |
>>>>> +				hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
>>>>> +			unsigned long pfn = swp_offset_pfn(entry);
>>>>> +			unsigned long i;
>>>>> +
>>>>> +			if (is_writable_device_private_entry(entry))
>>>>> +				cpu_flags |= HMM_PFN_WRITE;
>>>>> +
>>>>> +			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
>>>>> +				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>>>>> +				hmm_pfns[i] |= pfn | cpu_flags;
>>>>> +			}
>>>>> +
>>>> As discussed, can we remove these.
>>>>
>>>>> +			return 0;
>>>>> +		}
>>>> All of this be under CONFIG_ARCH_ENABLE_THP_MIGRATION
>>>>
>>>>> +
>>>>>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>>>>>  			return -EFAULT;
>>>>>  		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>>>>
>>>> Balbir Singh


