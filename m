Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C0ECCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 22:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD708E0023; Fri, 17 Oct 2025 18:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD51B8E0008; Fri, 17 Oct 2025 18:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3BE8E0023; Fri, 17 Oct 2025 18:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAB558E0008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 18:15:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6808958428
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 22:15:11 +0000 (UTC)
X-FDA: 84009012822.03.F3E63AA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id CD6481A000F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 22:15:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XxzuRKIl;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760739309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p87jyAVhs2BuPZGE+8O/0+Webgsr4ZrQSN48o7Lfr60=;
	b=Vps8QTst8TE3YVNYRJR7Z7v70qPgf37vubnBWfz/7rbf+66hGVEYZl1G8C21h+wwFIgqsc
	7dr8pNA2IUBfo63IaksycwXTnqDE8VkxegGwai87zXRm84VSqHAqIlIB8MB0ATJjQ/4hqp
	0d2XXieiapix1wPaoH6+/3CMlLNL1pY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760739309; a=rsa-sha256;
	cv=none;
	b=a/e0Z0olQuPbF+9K98i2CnBo+rvWlyZIxjMLnb8yyTHrBGBrjZ29cQkRcCGyoF9k4L67cD
	kOQaCBR1gk6K3LOY0a/7pffwVYSG6I6nVkWisi9gyFETfK2deT7zvn09tObh7b89H0NB4J
	ZTP6A9YGHBz192/5IP9VGLUnqcGEeNU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XxzuRKIl;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760739308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p87jyAVhs2BuPZGE+8O/0+Webgsr4ZrQSN48o7Lfr60=;
	b=XxzuRKIl3TkMEEVxRz1kVUBwuG262o0DwC6XN+N33G5iX13jrkBwmPIsdINlQXncO1spLt
	g8pmTIPnA1oBZGuNmNKipnx+4DtJWRZKJ31mXtWiIM9498qNQq3qWQCVXoTld816LG4XvA
	c8Tt62LLmJT+DRVKKZTx8m8sjDJCa0s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-d5HDdlMxMk--sGHpr6dSvw-1; Fri, 17 Oct 2025 18:15:07 -0400
X-MC-Unique: d5HDdlMxMk--sGHpr6dSvw-1
X-Mimecast-MFC-AGG-ID: d5HDdlMxMk--sGHpr6dSvw_1760739306
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471148ad64aso10850965e9.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:15:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760739306; x=1761344106;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p87jyAVhs2BuPZGE+8O/0+Webgsr4ZrQSN48o7Lfr60=;
        b=ZNiA67bL8/hP14ZRMi2+7H9UgwCpMBokFDsXKxqvfXEsoEMr1HbWCWc9WsKjaeMkSh
         bXsvXOtnJZltZYo7yZuzlfEiAj+CtoKeNFBpdbjlOf1iX8AEuNM6LwAjnRrQLeEIgwgG
         ezdjf418PCwDG30LGIsM6a0HyWCU2eBbwVULShHBYu27i8rHfABC+JJhL/ALhwbJRamy
         DciUQVi+YczFc6Im4+a+K2fZQqiWHoorhMYtbodFRKnwU7oEtRxAP7QXUQupbd/8+m6b
         gv1omTcPTe7/5xN/mhNmjSRKKW/orx/XcNHDKQVUAsIZKT7F4a5kAuW8WODDwjb77d6y
         0qjw==
X-Forwarded-Encrypted: i=1; AJvYcCVUw8ifRSISm/50ZktXdtAWDnKIBWwJVt19qjneMCiKpkiLUquJV685gFBTd1Ukj35iku2XHqsHQw==@kvack.org
X-Gm-Message-State: AOJu0YyQ/sQFqmV3WjBkjC4FsPelfmIKGbpvZFOxElIXWj0+gnoGEJF8
	9CpYp8azZIOzBUY//IlejOAV8uBv/B9iZ3jUuJsn6kyN4+sOXfqYMX5Cut6pFJJHuuhhF7jG3N/
	ANlFY0an87T17YdyhIbjXWZqcdffuLo5FuVxQ9Wj5o/W0Abh5IJru
X-Gm-Gg: ASbGncu7m43r4wB42FYFrCF8oMvcxCJATUTOBOYZAwJmsbOBq/e/tAX+lC1cBZ/2Y9W
	IQSJn27wLHdFd2dBalX8FhVV2uMhoIHbzEmixuqlXRv2p2MLWJzwhB3BxwSsVxDEJsHD/DYXwJD
	KGt6Fc9XE7YvKft77mALG42soQxeMkUNGvs7iWGteWRY5oIczXdzd9IDPzNsA+RkdHNPbMAL+GE
	kJ2tUxjrvqYfNv5IyuInSXfg//h5ckU4jMUN2h4y4dWfnorsgKMOHPC+Wq1KSYaa2toSaeJ+YjT
	9zi7MlqJRiKIGRrpeMLJhp3mkdCniWd/DoT5VMhaIjLx5++p1E07/GOByl/dwHK0Heaw+AKCMV4
	0QRbvXBifM487Muoae6va8dNH0vGXLkCwGShHRrcUwzEg3EU0psae7mYzepdm1VkXlsCUokCEah
	lH7YxbJSqh5notu8/FqwfkdesoYSc=
X-Received: by 2002:a05:600c:4e89:b0:45d:dc85:c009 with SMTP id 5b1f17b1804b1-471178a236cmr39238255e9.10.1760739305659;
        Fri, 17 Oct 2025 15:15:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJgtzXHc65CCqPCrsxYTy/FGHHoInqVbQf9Pu97ZUWTn7m80M3tFIb6Fx8eayPacnZBj7iXQ==
X-Received: by 2002:a05:600c:4e89:b0:45d:dc85:c009 with SMTP id 5b1f17b1804b1-471178a236cmr39238055e9.10.1760739305218;
        Fri, 17 Oct 2025 15:15:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce56csm1338836f8f.50.2025.10.17.15.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 15:15:04 -0700 (PDT)
Message-ID: <3a2db8fc-d289-415b-ae67-5a35c9c32a76@redhat.com>
Date: Sat, 18 Oct 2025 00:15:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: KVM/s390x regression
To: Balbir Singh <balbirs@nvidia.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Liam.Howlett@oracle.com, airlied@gmail.com, akpm@linux-foundation.org,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, dakr@kernel.org, dev.jain@arm.com,
 dri-devel@lists.freedesktop.org, francois.dugast@intel.com,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, lyude@redhat.com,
 matthew.brost@intel.com, mpenttil@redhat.com, npache@redhat.com,
 osalvador@suse.de, rakie.kim@sk.com, rcampbell@nvidia.com,
 ryan.roberts@arm.com, simona@ffwll.ch, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-next@vger.kernel.org
References: <20251001065707.920170-4-balbirs@nvidia.com>
 <20251017144924.10034-1-borntraeger@linux.ibm.com>
 <9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
 <c67386be-5278-411d-97e7-43fc34bf7c98@linux.ibm.com>
 <8c778cd0-5608-4852-9840-4d98828d7b33@redhat.com>
 <74272098-cfb7-424b-a55e-55e94f04524e@linux.ibm.com>
 <84349344-b127-41f6-99f1-10f907c2bd07@redhat.com>
 <c9f28d0c-6b06-47a2-884d-7533f7b49c45@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c9f28d0c-6b06-47a2-884d-7533f7b49c45@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Bsuk6JnuX1U2A30mn0ZU-WqZqi1N_Z11XRNtkjU0ogw_1760739306
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: yemkhfp981rt3co8dmuz7iodqca5dct8
X-Rspam-User: 
X-Rspamd-Queue-Id: CD6481A000F
X-HE-Tag: 1760739308-279384
X-HE-Meta: U2FsdGVkX1+ktp14ZELqJHViLHXDuJWKmv0BGrGTugQ98LdKX5XTxarSeG6Gf8Uk6Ss5raUOhto/VgZFRt8EUvJNBpvPz6+naNbuY7ep+3BYeRQGTx4RVXy2wWF8dlKIw3jVh9ZfzQLYE3XazjvDZvsLQU9Q25aIx7vcNRucWgxpWay8W4kWYpug41TdnviLWuxCnpL4xLQr5W9t8tdtnCr4lnRqBaQHyK6MBdnBhcVHSyvb9XaMLBcBhCGCIe8+nAvHpx1pHu4esaVv3slJJ5TKqNRrBRN/jRS4O8mMoHNg3skHLoUIaPkld8LOdUw2zoH1QuOeXigFN3pJ+HIHgz5CJtjk7xH4Ej+5L4vko3VLVFRVwbdpb1FN/ED1Lb7MXwBTRA1yjds4sbxuLEYO8Ncy2GP8DM8qO1l8VJWyqJar2Lpxm10cmBF6YtW5BcFifo0SkffpOmxS8FUob2dbx5RStWoAQDWELxgdmO7pDVXGlpHWw3kr1fKOMJabJHSQAEN9A3GtRh7N48IaYpMSJTGHSS7/WIYTgRcDSUoaidZLYzhbRQhgNuz2cc8Nmzw9qmEX6yzdfMV3akGFsC1QVoayMO8+1Gqas8XsWqHKG+5XfzOan6oIVIW1/cqqkugc5BH3NXHwVZsVEr+wCckehHTTv68aBgGMrCyQ6uN9irZrdXUw3S9XkyUfRLdcMI3sadwC5wfKBXUiqRdvizeipcJ/2YZ2Ft94OJIoNovDdrY88DfskhY1SJNDM5bIlNy5BRkbbqiLGve8gtPZxh0l9fgW7xrCCq+7RFuZr8BZc7Ph0eWFHMkpOr2qR3nviALDDnj2yfN7acQo8OaLGroZKZFTKkZTdbcGEjSpiUJ5aMQRZb5F9MlRgF9WKWQw4yAmMw1cETaxXjPDR1mkqQkqr7YUZkeEQAzwmn1eB9U7s+ER5A9/j4m8PKx8JQgb/8GbR0sGwyhi2w6q8GevTbS
 vPTlOX+U
 t+1ZT4KD54+oME8DMJR/gdfWbJSDfO3W2zJ3k60hCKKg+caBj1s3fN4QVsFnfR0n7KIz8/kFffCCfuxOx1RgtLtS9t2Sbw6yOiBrJ3oWiD5jTe7U4Sb83lxmkgXZ8tDkEuJagM7AKBD60F+0GSRFTbYtugFYE0dhyVsclq5I4wBa+NZqgQ2PyA2tlkAmgLOOpDSxP0lQo/e1tx+rIIIpH6v85ESejR68m5HffGlirXUJnjx8Y6fmps2k5yRalfoqtpbM8qShPDjFAzVgZwpc0xUPnu3mMasi8Q6oXiAmqi7kr5z5iW5iCHXlBdOKJNZFR8zcs6u41FGtakCYYULSCH9ELeZf9dQrU5JFRu6C5wPNS/ERIQIiUosBPRXLlAAhz004lj3cRgieh7vQ+yDIv5JAUzgSGPd/JOHIRaytbp9/8VcBMv4sfV0gsgIXJt7W+liJ3/tR8sMQWfU+t8vraQEuze9yWS74AbF1jerc5kUBjwtuN0HYga5ptwHNP3ABmVXyaInMs9oaoe3bGPsFRHSJFDSGbQKYVgXl04YSnrG128oHa26v9eKuKlFpjCnF8Mo+6EXowi00e5KRz1i9eTFecaqBtJrvsF5zYvXf9pCxlf1Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.10.25 23:56, Balbir Singh wrote:
> On 10/18/25 04:07, David Hildenbrand wrote:
>> On 17.10.25 17:20, Christian Borntraeger wrote:
>>>
>>>
>>> Am 17.10.25 um 17:07 schrieb David Hildenbrand:
>>>> On 17.10.25 17:01, Christian Borntraeger wrote:
>>>>> Am 17.10.25 um 16:54 schrieb David Hildenbrand:
>>>>>> On 17.10.25 16:49, Christian Borntraeger wrote:
>>>>>>> This patch triggers a regression for s390x kvm as qemu guests can no longer start
>>>>>>>
>>>>>>> error: kvm run failed Cannot allocate memory
>>>>>>> PSW=mask 0000000180000000 addr 000000007fd00600
>>>>>>> R00=0000000000000000 R01=0000000000000000 R02=0000000000000000 R03=0000000000000000
>>>>>>> R04=0000000000000000 R05=0000000000000000 R06=0000000000000000 R07=0000000000000000
>>>>>>> R08=0000000000000000 R09=0000000000000000 R10=0000000000000000 R11=0000000000000000
>>>>>>> R12=0000000000000000 R13=0000000000000000 R14=0000000000000000 R15=0000000000000000
>>>>>>> C00=00000000000000e0 C01=0000000000000000 C02=0000000000000000 C03=0000000000000000
>>>>>>> C04=0000000000000000 C05=0000000000000000 C06=0000000000000000 C07=0000000000000000
>>>>>>> C08=0000000000000000 C09=0000000000000000 C10=0000000000000000 C11=0000000000000000
>>>>>>> C12=0000000000000000 C13=0000000000000000 C14=00000000c2000000 C15=0000000000000000
>>>>>>>
>>>>>>> KVM on s390x does not use THP so far, will investigate. Does anyone have a quick idea?
>>>>>>
>>>>>> Only when running KVM guests and apart from that everything else seems to be fine?
>>>>>
>>>>> We have other weirdness in linux-next but in different areas. Could that somehow be
>>>>> related to use disabling THP for the kvm address space?
>>>>
>>>> Not sure ... it's a bit weird. I mean, when KVM disables THPs we essentially just remap everything to be mapped by PTEs. So there shouldn't be any PMDs in that whole process.
>>>>
>>>> Remapping a file THP (shmem) implies zapping the THP completely.
>>>>
>>>>
>>>> I assume in your kernel config has CONFIG_ZONE_DEVICE and CONFIG_ARCH_ENABLE_THP_MIGRATION set, right?
>>>
>>> yes.
>>>
>>>>
>>>> I'd rule out copy_huge_pmd(), zap_huge_pmd() a well.
>>>>
>>>>
>>>> What happens if you revert the change in mm/pgtable-generic.c?
>>>
>>> That partial revert seems to fix the issue
>>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>>> index 0c847cdf4fd3..567e2d084071 100644
>>> --- a/mm/pgtable-generic.c
>>> +++ b/mm/pgtable-generic.c
>>> @@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>>>               if (pmdvalp)
>>>                    *pmdvalp = pmdval;
>>> -       if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
>>> +       if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
>>
>> Okay, but that means that effectively we stumble over a PMD entry that is not a migration entry but still non-present.
>>
>> And I would expect that it's a page table, because otherwise the change
>> wouldn't make a difference.
>>
>> And the weird thing is that this only triggers sometimes, because if
>> it would always trigger nothing would ever work.
>>
>> Is there some weird scenario where s390x might set a left page table mapped in a PMD to non-present?
>>
> 
> Good point
> 
>> Staring at the definition of pmd_present() on s390x it's really just
>>
>>      return (pmd_val(pmd) & _SEGMENT_ENTRY_PRESENT) != 0;
>>
>>
>> Maybe this is happening in the gmap code only and not actually in the core-mm code?
>>
> 
> 
> I am not an s390 expert, but just looking at the code
> 
> So the check on s390 effectively
> 
> segment_entry/present = false or segment_entry_empty/invalid = true

pmd_present() == true iff _SEGMENT_ENTRY_PRESENT is set

because

	return (pmd_val(pmd) & _SEGMENT_ENTRY_PRESENT) != 0;

is the same as

	return pmd_val(pmd) & _SEGMENT_ENTRY_PRESENT;

But that means we have something where _SEGMENT_ENTRY_PRESENT is not set.

I suspect that can only be the gmap tables.

Likely __gmap_link() does not set _SEGMENT_ENTRY_PRESENT, which is fine 
because it's a software managed bit for "ordinary" page tables, not gmap 
tables.

Which raises the question why someone would wrongly use 
pte_offset_map()/__pte_offset_map() on the gmap tables.

I cannot immediately spot any such usage in kvm/gmap code, though.

-- 
Cheers

David / dhildenb


