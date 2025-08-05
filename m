Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A43C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 09:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F132E6B0098; Tue,  5 Aug 2025 05:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEAF76B0099; Tue,  5 Aug 2025 05:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD9A66B009A; Tue,  5 Aug 2025 05:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA08D6B0098
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 05:50:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 614541A00EC
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:50:45 +0000 (UTC)
X-FDA: 83742234450.12.C159468
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id A9CE720009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:50:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yd0thsr1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754387443; a=rsa-sha256;
	cv=none;
	b=nrWA+lUg4JxyC5UYTLcFdpxNNPY2quX5CVsRiublizmGBa8Subl6GQ3y/Rz83psPMg8Dsc
	07vwwtXMEG9uVGISEMcfjOHgJySzowVoogwsc4YrjRbFtEMT6rmS9zuAZJC2yQAbFoP2JC
	Nz671KGbtLb9BLapn0+eHr1Lm9g+YS4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yd0thsr1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754387443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8EvQmYRofvOplbO2mSmEYQlZEwalBTIU+7aTAq0GsPY=;
	b=rhnxANOvr6vd8Q721lO3F2zw9+DtsoT5Z4lzvzax0yrUmAih8US+tMJpdBqWxU97N5UFEs
	IJoL9ceDkGWw2He3TlYRmKko6T4uidZgXdnxEyDvY4Gi7APEIIYCF7Is7xrMeXxGUda07E
	XlVBtelUiKwkswmE9bybYvqU7CqlSn4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754387442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8EvQmYRofvOplbO2mSmEYQlZEwalBTIU+7aTAq0GsPY=;
	b=Yd0thsr1U9eKloHcSya6XrKKs2Yru31lK9gR3t3q2r2EbUzxNOf62Oibr0GOPrqs4V/Uzr
	wRjxnfwPU7ThexIzfz4oeNIVmnfkkqgis9nJ5x4QEK6+XvSQWXpcj0WnQkLOApC6GbVJuj
	MQzaCM8RpEQOzy1RaWf63Gi9UEJJPGQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-RfKEoY-TPUisMEaisrtDyw-1; Tue, 05 Aug 2025 05:50:40 -0400
X-MC-Unique: RfKEoY-TPUisMEaisrtDyw-1
X-Mimecast-MFC-AGG-ID: RfKEoY-TPUisMEaisrtDyw_1754387439
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459de0d5fb1so12951215e9.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 02:50:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754387439; x=1754992239;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8EvQmYRofvOplbO2mSmEYQlZEwalBTIU+7aTAq0GsPY=;
        b=MRg666Xe4l9ZEKYv8Z7zme6KC4jaHio76a8zrmdx6jRGkl+j1bmCA/c+n75drujuSh
         TTn8A61eYDAm5ef64mRdTOnOLfkt/KagQRFplnVryjz8+EtA4bnOfmoq0QuYPfWVYIk/
         J99cvpyUHWSkVeFrSKqG4FXTOpWbZlGaZ2OBnO5RdgHSsY5Qd4l81mDd1shMZD1B2AaN
         pXJE3t2bEtYKzSvgMCuE+w7rdldidBkFV9L+p6pY6FODZSZZ2wNp9TajMcdPlPtEgiXw
         kXJuoimGfm62Hn3e312/80XrILZQC1IycVnTEW2PdNZcVvdEar8Ai3o9zg7ZXx+/tQMx
         jLgA==
X-Forwarded-Encrypted: i=1; AJvYcCUHCfntyCyDcZW6PyAfpYHSqIi4niVzDfsj9olhLdQm0KWku0uUtsKZdE4W5M0MvEIiX/wl+wS4ig==@kvack.org
X-Gm-Message-State: AOJu0Yy8O6W9r5p75i674Fs+wIevZohtrY9OEdKbXrkFCfZyGoxCUWXH
	z+rfBzIL3Gb6qGccKW4pQWZ1/fY49++/3il+FA0Zrz23+abqb/7c/PwwPVtRaqj6jk1TYfFo3CC
	xIEuk2Dxsz/YL/MIGfdTXFO15APzoWTxoW2wqFYKVjSVuTnAxLzh7
X-Gm-Gg: ASbGncshVk1d/ux51PzajEBNXPSBVjZlJ9POjljx2EBcvgvdBqwrj2Mrn3Tbfrj5MHX
	Cra07N1nh6Gp+apxw3qi+1gRoPYo8TQbLcb/qRUrjgf3HTK31/XEO8EElQlhnu7WsCKS2X0Ct9o
	lagCYEnW9cKu1rOBpj1wUddGYl5+ZSr2A5mnBgp3uJOidr8A/JjF6OCikrwc4A08PLACVtcFkQy
	2BrH3vfSvH6x8cdgbMoOdc2+u2aKluMKSsBPpq7oVtg5s/8C055TRLQlIHaQ9mlmhW76lhB8Z0F
	2lkQinFX9ZG/7OVBwactdxNmV7V1aMsuZlT401ZBvvB2rQRLKuKrbDe3tkKNwOFS5ncYY3ztGAn
	dcdrMv4R1OPjGslOgf8pmvFvLRoIMgipRFDBQv5tktSYB0kyOJqLAI5ZDKyBu7avvf2k=
X-Received: by 2002:a05:600c:4f8e:b0:453:8bc7:5cbb with SMTP id 5b1f17b1804b1-458b6b3d9f1mr71627005e9.25.1754387438969;
        Tue, 05 Aug 2025 02:50:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLeifPtR1jHyiiqnkqcPBfkmNNIKxJIA7SboZGUI3MCfaovha7/rwiu27Nn8VFzBIljWpyig==
X-Received: by 2002:a05:600c:4f8e:b0:453:8bc7:5cbb with SMTP id 5b1f17b1804b1-458b6b3d9f1mr71626655e9.25.1754387438529;
        Tue, 05 Aug 2025 02:50:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e075805csm34786315e9.4.2025.08.05.02.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 02:50:37 -0700 (PDT)
Message-ID: <5ac2ec58-3908-4d0e-a29b-8b4d776410e3@redhat.com>
Date: Tue, 5 Aug 2025 11:50:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix the race between collapse and PT_RECLAIM under
 per-vma lock
To: Qi Zheng <zhengqi.arch@bytedance.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>,
 akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 "Lai, Yi" <yi1.lai@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>,
 Lance Yang <ioworker0@gmail.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>
References: <20250805035447.7958-1-21cnbao@gmail.com>
 <35417160-86bf-4580-8ae9-5cadd4f6401d@bytedance.com>
 <d73213ba-5ca0-451c-b82b-f590d10da6d7@linux.alibaba.com>
 <b594a315-8458-439c-b535-fc7f052a3fae@bytedance.com>
 <c6f9dacf-d520-4cc3-88ac-c5937916aa2c@linux.alibaba.com>
 <064cca31-442d-4847-b353-26dc5fd0603c@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <064cca31-442d-4847-b353-26dc5fd0603c@bytedance.com>
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: OHNOCeYaS0-n3UFki3AEQGe331wZc0CDBL3UM61tuW0_1754387439
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A9CE720009
X-Stat-Signature: uu1ez3pcaimho5xqjesdg861k7tdkgcp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754387442-711790
X-HE-Meta: U2FsdGVkX1/dCBySyszUILeOELEEEwNONZZl6epNMDZgtVbQps5Lij+8aKArcss+8eTho7YIiDdt4Smy6KVFntiLcCCiNIUN7v6ADS2bpXVfmOhNzECEUcQ0n243zpfika5RHmdYLIgnyQILksbou+EOyCtvt6l4Vi2xEYwBbFIIL/haSCYSkGCCjNeoo/98BgMNGqwXiFRYxfJEMTmpX/LQ/3QnwMpQmt2pMCysQgFZvks/y5PYT0bKIAfeyV15UWq0r87T15w6JTMc0seMtcoPklLoYzrc/6Wo02y5B7EV/kTohtnXy0wYhlCrfdKSMds9+YTWOXKzpPfKNBXYU4GqF5BzuhlpcsWS3AgWfKdI0b1udpa5DZYhb3V1jSfbZRhQXwhOelbY6FcMmNGSi2WgaCgdaW7x8RUBNOqPAD2c1lcVtkUGakh+0ssZSrVyxoT0ydUJuW74ln5fPUBNIQdre0ozl6PwmZE80Dwl8vLte2CeFlWeUE/ZmYnPN6+HjwlAKlqIj4M2k4903jeuHnsicLw54QoBYWfZO8bhwJLE0JvrBbNL37k69Um4SNuQeJJ4EThWYs41+Fc4dRpo8FBua6UX69e/l4iCFSijFZQtGekTTcPwhpyQw2X2zTH0BNBZq8qE6+wNVaeIjSCBg7rwt5cRsASvn1gnvz9d7WYASVxQGmbyLZVXeUijccZk5xu3LGOa/MEHmTwwyCUpdxfWRbarbakfLr8wl9LPc+SGrCcj0gvOxLXWsY8rpSFKA5S6pUEV6gDtikKaZ7GU8lV6MOFo+DOo7a3RvvGfmi2wh6KajZRG3um1OVkw/gsGmoxBaAFR2TBFGK4oH68dJOX4rszYZG5x1D/LQfP1OpWZv1L3h7XgMHavBn4tPuTaO63V6gSEzcq2MnkoDMdNiE0v+Lj/EsDGxjsIYvS6RfpXEBctBpWW8pEx79WLcn8S2OdUF/8uE+0EPwllYxD
 6oYM3am7
 w28g57cojaqK2fk3WLqWqRDWFIRRbKtwDTfX2eN/NlpWhVTwrsVHbqxd2kQW0KGrgdMP+IA0jYEoXVrfQpSSe1FWzzV4edMnm0JuB7lYvQA1eMXKkB+U11O0BAI0PXjHUnlynfLN5SCsRO6q1EOxrWBAtuMPJHNv7OEWHsAV9Ht2RUyarpxImIKlboFC70Rk++eCMeAXkiToWzOWZ63zGZB1Bpo6FF1LBRaxECrQa48iPn6nJtrk/trrXoy/B56sDu+NgtkZiQamLCPyT8a8SVgcw9xFAcxiMT3BbQA98h773xqHgDdjmTYtfLlAhOLt2W8QnMhCY5ExgUsO7tS8icLee7xIeCmmhaW9aeycmpX6PPVfidIQAaNpQbTtLR2a9RNfyG3o5ba8gK6QvsxPJOgxm5Pj4eKlJKCOPLt8dztuI/RIEMHrdPHLd/k4eiFHtgFRTj6DMJ8NxLykqi4581OnFY4Hz+D/6BYH1PAvyJZz5LBar+1ilqEVaT2kpjuSffeTGSK1K77w1LEE+b4VVau6p4iyF8aA9s9IGJcY88l0LD2zDom4ONjNu7Qbrc83HigmMzcYwe+GDxng2Bfxrqi1X7XjGEX5SWhYVfnHG599V7MPnPksQLYDkIrnbDWrHgyYewtQ6dKcUjouGhCSmt8YK8D1EHQ5DnCL5Au8c0B49bVmF+IR3YXm3zp4tbdnwNT+NuxhAeSOutCGnr6/69KFydAp78ar4VH7G9kelhWzwSC7475YQ3mpWCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 11:30, Qi Zheng wrote:
> 
> 
> On 8/5/25 4:56 PM, Baolin Wang wrote:
>>
>>
>> On 2025/8/5 16:17, Qi Zheng wrote:
>>> Hi Baolin,
>>>
>>> On 8/5/25 3:53 PM, Baolin Wang wrote:
>>>>
>>>>
>>>> On 2025/8/5 14:42, Qi Zheng wrote:
>>>>> Hi Barry,
>>>>>
>>>>> On 8/5/25 11:54 AM, Barry Song wrote:
>>>>>> From: Barry Song <v-songbaohua@oppo.com>
>>>>>>
>>>>>> The check_pmd_still_valid() call during collapse is currently only
>>>>>> protected by the mmap_lock in write mode, which was sufficient when
>>>>>> pt_reclaim always ran under mmap_lock in read mode. However, since
>>>>>> madvise_dontneed can now execute under a per-VMA lock, this assumption
>>>>>> is no longer valid. As a result, a race condition can occur between
>>>>>> collapse and PT_RECLAIM, potentially leading to a kernel panic.
>>>>>
>>>>> There is indeed a race condition here. And after applying this patch, I
>>>>> can no longer reproduce the problem locally (I was able to reproduce it
>>>>> stably locally last night).
>>>>>
>>>>> But I still can't figure out how this race condtion causes the
>>>>> following panic:
>>>>>
>>>>> exit_mmap
>>>>> --> mmap_read_lock()
>>>>>       unmap_vmas()
>>>>>       --> pte_offset_map_lock
>>>>>           --> rcu_read_lock()
>>>>>               check if the pmd entry is a PTE page
>>>>>               ptl = pte_lockptr(mm, &pmdval)  <-- ptl is NULL
>>>>>               spin_lock(ptl)                  <-- PANIC!!
>>>>>
>>>>> If this PTE page is freed by pt_reclaim (via RCU), then the ptl can
>>>>> not be NULL.
>>>>>
>>>>> The collapse holds mmap write lock, so it is impossible to be
>>>>> concurrent
>>>>> with exit_mmap().
>>>>>
>>>>> Confusing. :(
>>>>
>>>> IIUC, the issue is not caused by the concurrency between exit_mmap
>>>> and collapse, but rather by the concurrency between pt_reclaim and
>>>> collapse.
>>>>
>>>> Before this patch, khugepaged might incorrectly restore a PTE
>>>> pagetable that had already been freed.
>>>>
>>>> pt_reclaim has cleared the pmd entry and freed the PTE page table.
>>>> However, due to the race condition, check_pmd_still_valid() still
>>>> passes and continues to attempt the collapse:
>>>>
>>>> _pmd = pmdp_collapse_flush(vma, address, pmd); ---> returns a none
>>>> pmd entry (the original pmd entry has been cleared)
>>>>
>>>> pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl); ---> returns
>>>> pte == NULL
>>>>
>>>> Then khugepaged will restore the old PTE pagetable with an invalid
>>>> pmd entry:
>>>>
>>>> pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>>>>
>>>> So when the process exits and trys to free the mapping of the
>>>> process, traversing the invalid pmd table will lead to a crash.
>>>
>>> CPU0                         CPU1
>>> ====                         ====
>>>
>>> collapse
>>> --> pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>>>       mmap_write_unlock
>>>                                exit_mmap
>>>                                --> hold mmap lock
>>>                                    __pte_offset_map_lock
>>>                                    --> pte = __pte_offset_map(pmd,
>>> addr, &pmdval);
>>>                                        if (unlikely(!pte))
>>>                                            return pte;   <-- will return
>>
>> __pte_offset_map() might not return NULL? Because the 'pmd_populate(mm,
>> pmd, pmd_pgtable(_pmd))' could populate a valid page (although the
>> '_pmd' entry is NONE), but it is not the original pagetable page.
> 
> CPU0                          CPU1
> ====                          ====
> 
> collapse
> --> check_pmd_still_valid
>                                 vma read lock
>                                 pt_reclaim clear the pmd entry and will
> free the PTE page (via RCU)
>                                 vma read unlock
> 
>       vma write lock
>       _pmd = pmdp_collapse_flush(vma, address, pmd) <-- pmd_none(_pmd)
>       pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl); <-- pte is
> NULL
>       pmd_populate(mm, pmd, pmd_pgtable(_pmd)); <-- populate a valid page?
>       vma write unlock
> 
> The above is the concurrent scenario you mentioned, right?
> 
> What types of this 'valid page' could be? If __pte_offset_map() returns
> non-NULL, then it is a PTE page. Even if it is not the original one, it
> should not cause panic. Did I miss some key information? :(

Wasn't the original issue all about a NULL-pointer de-reference while 
*locking*?

Note that in that kernel config [1] we have CONFIG_DEBUG_SPINLOCK=y, so 
likely we will have ALLOC_SPLIT_PTLOCKS set.

[1] 
https://github.com/laifryiee/syzkaller_logs/blob/main/250803_193026___pte_offset_map_lock/.config

-- 
Cheers,

David / dhildenb


