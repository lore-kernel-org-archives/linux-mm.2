Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50BFAC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667526B008A; Thu,  6 Aug 2026 10:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F7C6B0093; Thu,  6 Aug 2026 10:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B0E6B008A; Thu,  6 Aug 2026 10:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 277296B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:42:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B7DD4079F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:42:26 +0000 (UTC)
X-FDA: 85071110292.25.8E3C271
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 20DE91C0016
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:42:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g+Xvb6jE;
	spf=pass (imf20.hostedemail.com: domain of clg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=clg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786027344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8GfkU9TTPckwMBwt43hPKDhEB5BQFXtyP1DfYP8FF4=;
	b=RMps/E66hkLTRv8qRSPxJBfxeLvSeMiAgUB7uzCm0+DAleWCp0pNzttR1mAoiOgF6U4mBh
	V0KOjPfj3f5dcCWdbdUCsai+qUVThn53WlsukCb9RFbbunIDK57doBiarR31ErpTpEWk0w
	qWJFwQg6gTvpBhsEkuJL3TX/7WSVPJ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786027344;
	b=zTChr6GsiCegiXPH7JiPEzvSf7C3Cy1HqoRj36G+xLIczbJGwEt0RuAzGv26VhEUIOqwmF
	UZcn1CT1voQ2M6K5mobylqhfsKQkEweEpM6fwegu0Rv3hpyzWU70bGCSZfsuPcu1ylWPMU
	UgwSEROOlME2DDBoYmxATwsuvxAlLWU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g+Xvb6jE;
	spf=pass (imf20.hostedemail.com: domain of clg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=clg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786027343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Y8GfkU9TTPckwMBwt43hPKDhEB5BQFXtyP1DfYP8FF4=;
	b=g+Xvb6jEBgLb/YSotnx+TtMYe+ViVMs8kL883xfeyPAsXS2E+vdabYkuoTh9jC9xxT3J/Y
	GbnFagxM/smo6jnV12a/Db9aCfJU/jp+UY6h5jJ3SxlkfF1QGtlS8yCV7D/p3M1sKyyPWA
	G4+qR0QRMavA+pVAr45wPxbLCBTwlHQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-aWt-nSkAOQmPdFX9ZTKiTQ-1; Thu, 06 Aug 2026 10:42:22 -0400
X-MC-Unique: aWt-nSkAOQmPdFX9ZTKiTQ-1
X-Mimecast-MFC-AGG-ID: aWt-nSkAOQmPdFX9ZTKiTQ_1786027341
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c15fff01a30so168951266b.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 07:42:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786027341; x=1786632141;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Y8GfkU9TTPckwMBwt43hPKDhEB5BQFXtyP1DfYP8FF4=;
        b=f57Mrel2uiWBxc6B7SEEaZNO45jhlZE5g8abKxdMpKtnB8HaZFOzxLZ/Y5PNpKHOYu
         uu3hFoAURxGNhlZeLdOIE13RrJbQIhEZW2kdoSPkj9b8roawfdQLJEWx0Ovjz0tyvV57
         zgD+drZ+6sRaIlKpC/740z0GOuribXIyC0DA0i69ePv2CHOHR4hkZRMbmcRhprSybfKS
         h1hCRUa+dmMkgdhDnL77XsSMNCRGlvwf3+TjNt7rOhp18axCXM54oqVzhrnRt00/WGVg
         ldrZr7e3+0fPtRH1WHHa226O9cHANS5S5FNsvc2e5IklXx/M8fXgDrDs8kZ4MNuFSm9H
         o0Mw==
X-Forwarded-Encrypted: i=1; AHgh+RoTRQxvmeoKkFkC+/0uLxddyd0AovYFBd7rrf6vOS0GULSkDHrU//BdqSXrQ+bs+5ZMs0wS6H8Aew==@kvack.org
X-Gm-Message-State: AOJu0YzODIVd9WqMs665w0OuGr2RGftBLuEEsSY2RdokHTbdRMm8DJem
	RPqa3JR/zmw1NAhn94lEXonYU05bkACC1o/DEKqxqEJfsGAX/FA8kwPIffNKuckFv9192H0mQc5
	EMeO/tsdN+nS3wqrMUPndFqx4TBbDCR2AT/nSuRALfZAl3PbN2ZbH
X-Gm-Gg: AR+sD13/ns9TUe8uHyEU/KBW3JjXpPpFJ5b9Wdom5pNGaZBDj3dTgDqwjpdkjZgPXE1
	kQqpOO2Thdpm08lwweCmCa+mD4DYxO/SYBB0IxOFmCoR31EjWLCr+g3BMMskto3kDZL+NxMiDml
	a1VfDkeQGuukwFDPHlIAjqIqJ+z5/w4EhuT/VJ54qCMbPX+2LT+JuLMnX41TpDf/wlK5OdCM4wU
	yv/s8MhYWzRqc22E8Pwwn7ldFMA2kypKJ1ZZUVk7v4QyGhkQY3qnswAR2qBtjjmhS1cL6TRXMv2
	BT9ajP62CnkFUDWwVg0aJ1KofHHXK30WhZDfw5TtXVMWpaKkkNNjrsotbV4/FLhw3nrdtBZNMZd
	FNAOCfYUBw4fa+gw4OsOzkhQVfKdZbQPfNRvVAZc=
X-Received: by 2002:a17:906:d181:b0:c16:1a00:3feb with SMTP id a640c23a62f3a-c2073365229mr81914966b.15.1786027340790;
        Thu, 06 Aug 2026 07:42:20 -0700 (PDT)
X-Received: by 2002:a17:906:d181:b0:c16:1a00:3feb with SMTP id a640c23a62f3a-c2073365229mr81911266b.15.1786027340246;
        Thu, 06 Aug 2026 07:42:20 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c20361312eesm272059666b.4.2026.08.06.07.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 07:42:19 -0700 (PDT)
Message-ID: <5b7e84f5-2007-458c-910f-7a6e1e3d3eab@redhat.com>
Date: Thu, 6 Aug 2026 16:42:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Peter Xu <peterx@redhat.com>, Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260805055544.1568534-1-clg@redhat.com>
 <0e52d0b4-064d-4602-8e7b-5744b05f24ea@kernel.org> <anSZpAjt84Pn7O_b@lucifer>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <anSZpAjt84Pn7O_b@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WmyK5nDgXH6Srox_vjynlqxu80AOgv7w4sZ7ByVf7Kw_1786027341
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 20DE91C0016
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wmye4rwzm9hyxey4eopo5hykqyzd1jhs
X-HE-Tag: 1786027343-865366
X-HE-Meta: U2FsdGVkX1+qJo8mCWDNzye26L0SYpDHezs7xLkgoRdvcmqKF++lf3I1owpo/5UKxwq/QAVFuGgqfUftQquK6ZPMrmMgeFBSOA/QLHtTptiyLGy6XVfSfyS+eWsnGWbJQX58aGDxCHS3b1ChwFdK9tqVg3PqmPfbyO2HZ18PBMtMUV6QSuqf1UVeDNkNdF06avnzsnX4cnBQZMIyb0ser66dzVn0xnDOwCRxyNG/hEV5S2PECVURAED8mNZEPMiDPIFA9Rhg5+zGXr/w/4qsVQGQNrexHE++KvWL9NxIGxuEy9viI76xLW0bb/aU8lCk1V4nN3lmoE7V2Kihcw/jANLiNGYu68KPjdHDhX4gZ9HA61D5QmbqjY+UQYKpEigRHK6bvPp8mlPfpELZT+npDNdgPUi7Z5kO5ninHwg75A7c6xa7warLUwZSFqhwo8+VzUkEds0CdCtJdCUAq/LPifBo5sZiGeUSU7YEwc4++ponSZ5oorRbTqg/VQQtdNzPGeW41SehnnKv0MPXAE7HfoCrZLTOL1lzAZYQIUQG9EvvqV3M99tgx9HSyzSswurcAwOOyANKb7igYq3ugf1BcbRRRyi9l8NUGMtTMK2593lD3knFCQV4x4zWDHaM9dLpj3XVqJE8Iwi7S931O+QZUT4c4ZlilFDzMqbQPL3PIbE1wdlX2BPuXIquAUjUf/UBLQRwUdKsP6YJ4Gi+1/icJuFR7f+KymjNi89Q2tuwEQgBS++Bd45jIu9971dlROi4paLz4oM/1WA0Xw0X4peK/WYcF1whMfnosj3F0CESPzgj/GVyUhVfplBw61S2O6TWs7JtZ4NTLtjNJVXZCy/dP7zDri4cV0NxcEhG+82KIRuVg0KpxztmnfXVRwGPe+FyZ1/6UxpTWtfgnmRFcgnLXDn3IiRAjHuzd1/PW5XPe5LK3L2TVJatIdKUnbxH+C06aCw3y6QTi0IVWo3r9Wu
 nXIGusfW
 XduCvzA4+10qcLSJgl7vbDfO2pecXoVwbN1eXPMzCW0q94mA/mKetp3bW+3eBNoiCRgX0JdBXdW282SOyHD8Fcbw0oZfxdEzjchNwdu2K2GuLNin37qCofomF9px4Z+L9hneOmHHKKXdIS8f8LF51N+Xxe8gkXeZugO8NDhWg36pTuCdMPAOt6Q/Mof9choWqU0dswSqrbzZ0Em7mzAQZMv1gOohLrRIQjojSP+5L5Z7IxLDvhLWa8l/zPnI0YMdf4PdAP0SfHBgDmfkda7/2743hZ1FklmvtSu+5N5KubNpfQ+tkaurfFD6yARR4jAFQFklrORsfcJ26Ya+lYr3RzAZsSRPO+rI9omePLhdXgUbCWAkdWiTl7T9FmClEioYkHUdtX33K43KnI4Qgh9WdNcseWRY0pYsnSpOGxsRPgR0CgV2VwZ0e5TdLh17YuKvwSgXywCAOaC4rzi+C86j5zdxCB/MbWl8TRifmbJNOiLxtYoEckhRRwd7XuKtSrt5YmXO3Jzu8U4ltt1bQ7w5zKYm95ZsYLYDCypv1L08nHj70Ll5oZHghARNt60o6IfREMxQ1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 16:28, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 06, 2026 at 04:26:20PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/5/26 07:55, Cédric Le Goater wrote:
>>> From: Cedric Le Goater <clg@redhat.com>
>>>
>>> The global THP sysfs policy (transparent_hugepage=never/madvise/always)
>>> gates the huge fault dispatch path in __thp_vma_allowable_orders() for
>>> all non-anonymous VMAs, including PFN-mapped device BARs (VM_PFNMAP).
>>>
>>> DAX VMAs already bypass this check via an early return:
>>>
>>> 	if (vma_is_dax(vma))
>>> 		return in_pf ? orders : 0;
>>>
>>> But "special huge" VMAs -- identified by vma_is_special_huge() -- do not
>>> get this early return, even though they share the same fundamental
>>> property: they map physical addresses directly into page tables and
>>> involve no memory allocation, no compaction, no splitting, and no
>>> reclaim. The THP policy has no meaningful effect on them.
>>>
>>> This matters for VFIO PCI passthrough of large-BAR devices such as
>>> NVIDIA H200 NVL GPUs (256 GB BAR each). The VFIO driver registers a
>>> .huge_fault handler (vfio_pci_mmap_huge_fault) that dispatches to
>>> vmf_insert_pfn_pmd/pud, and QEMU's vfio_region_mmap() aligns the BAR
>>> mappings for huge page table entries. Both prerequisites are met, but
>>> with THP=never or THP=madvise, __thp_vma_allowable_orders() returns 0
>>> before reaching the "trust huge_fault handlers" code.
>>>
>>> The result: each 256 GB BAR is mapped at 4 KiB granularity -- 67 million
>>> page faults per GPU instead of a few thousand PMD/PUD faults. On hosts
>>> with 8 GPUs (2 TB of BAR space), this causes VM boot times to degrade
>>> severely, with 99.98% of CPU time spent in the VFIO BAR mapping path.
>>>
>>> Configurations that trigger this:
>>>    - transparent_hugepage=never on the kernel command line
>>>    - The tuned cpu-partitioning profile (inherits network-latency, which
>>>      sets transparent_hugepages=never via sysfs)
>>>    - transparent_hugepage=madvise (the RHEL default), since VFIO VMAs
>>>      lack VM_HUGEPAGE and QEMU does not call madvise(MADV_HUGEPAGE) on
>>>      BAR mmap regions
>>>
>>> Extend the existing DAX early return to also cover vma_is_special_huge()
>>> VMAs. This is consistent with how vma_is_special_huge() is already
>>> treated for supported_orders (grouped with DAX). The mm/Kconfig TODO
>>> comment "Allow to be enabled without THP" also acknowledges this
>>> coupling is wrong.
>>>
>>> Cc: Peter Xu <peterx@redhat.com>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>>> Cc: David Hildenbrand <david@kernel.org>
>>> Cc: Alex Williamson <alex.williamson@redhat.com>
>>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
>>> Cc: stable@vger.kernel.org
>>> Assisted-by: Claude:claude-opus-4
>>> Signed-off-by: Cedric Le Goater <clg@redhat.com>
>>> ---
>>>   mm/huge_memory.c | 8 ++++++--
>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 58cabe6af33d031e48250e21db51506bc46c97b2..6dfef5500a054f09f9ece6df8bf7a0194624350f 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -139,8 +139,12 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>>   	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
>>>   		return 0;
>>>
>>> -	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
>>> -	if (vma_is_dax(vma))
>>> +	/*
>>> +	 * khugepaged doesn't collapse DAX or special huge VMAs, but page
>>> +	 * fault is fine. These map physical addresses directly — the THP
>>> +	 * policy is irrelevant for them.
>>
>> emdash in a code comment?

There are quite a few of these in the code in fact.

>> Then I spot
>>
>> 	Assisted-by: Claude:claude-opus-4
>>
>> and really have to shake my head.

It's a one liner. Good enough to raise the discussion no ?

> Ha, I missed that!

Me too. But, you have more to add to it anyway. It should be dropped.

> Well all the more reason for me to take over this patch... :)
> 
> At least the AI is acked here (appreciate that at least Cedric).

Yeah. Let's be honest. Even if I understand what is going on, Claude was
faster at digging through the code and connecting the dots than I would
have been on my own.

The AI behemoth dropped my accent though. Cédric it should have been.
I wonder why.

> I think the _actual issue_ is valid at least. The huge pfn stuff did seem to
> completely miss this aspect of things.

It's a real problem indeed and to cover mix of workloads, it it difficult
to address without a kernel patch.

Cheers,

C.


