Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8001EF43847
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1A86B0089; Wed, 15 Apr 2026 11:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82926B008C; Wed, 15 Apr 2026 11:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71C36B0096; Wed, 15 Apr 2026 11:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C17216B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:27:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 855648BB29
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:27:45 +0000 (UTC)
X-FDA: 84661170090.27.39E043B
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id A18F7A0012
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:27:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MMzwVmqH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of yintirui@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=yintirui@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776266863; a=rsa-sha256;
	cv=none;
	b=t9sfCmj/8xRHJ8R4BaAi4H9uOBx19e6iHIYHpvebAWubyLihb8+yUFNHLIyUMeQ/Aa3M3z
	pDN4gdgDILDTZglA5i81Q4Fc96mopgKkVRmSIxz4t7DAfyZ6i4yGfTqHOjhKaPIHZXXK+B
	o0GHL3yNvJVwupW81CqLvAsQqRwEWZQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MMzwVmqH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of yintirui@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=yintirui@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776266863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wPmlxegNR58V/H7yEEnR40syKnjm++PEkBAfISQyAVg=;
	b=eDW3jzCbL7p3MmUTh5ngIXcmQEYQhyfjL4sxy9f3OEBBIf0URMjl2svwENwefpgatD+c9S
	BSKEenztvJrJzKrid3pzgsjnB8olLdIyzW5FE2WN74AdrJxzq9hN6oXtPAypvpMmEcOxfv
	B9cThaZ78Aa5RwWSjv/z/JkIJsAcUcY=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35e563b0ee7so1871847a91.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776266862; x=1776871662; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wPmlxegNR58V/H7yEEnR40syKnjm++PEkBAfISQyAVg=;
        b=MMzwVmqHAfpYjMQ5MQI3px1QoZonQi/ttpLeyox/9hB1hu9hrlLFBqzOGyykizTPCK
         kdeFY8jNJ36bGNWW+KM1dML9OSkN5g9ZCQbg7AefaRHOcBeo17ABcSN+kdXa5QjsFfJo
         5bF3vYgAV02VHFH7hHEcti6pgAIwBMyiG8Uxv5uRh7phckJqw2UQ5YTm6twJi4Hgc51i
         u10o0aMYNz8ISOIl1IyW3qT3HoBbNedai93nRlbsHKXedF1iYRUrgInuAoDONqDxWPqL
         SKTFGioXw6BOInXGtEQpJ+Tk/2tJ3uKnfZpAK1KT9B1+lOGGGfn9L4tj/X/a3NYZH+hd
         BvJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776266862; x=1776871662;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wPmlxegNR58V/H7yEEnR40syKnjm++PEkBAfISQyAVg=;
        b=GU/EGwaQ3xVMFSYCbSdX3IvCg1FkSOnLydUbO9QiuQ7JBJzRsKNY7d8+8K9HnWWdTp
         eVSiPJSc3y3F5lsKxm7p2QQ+xBBSCXyTghqQ5EUw6rW8+8amONtvxKPGjCmCne0RUgM/
         rxSAiF7JRLw/nE4iDUVG5bYw2DolVluSSgG0jxH+e2INvN1p2pBOD1yurwIM/iMU/DV8
         qVA9AmffKAbmAOFSYeNGnqCKf9HnbrxPtko5+4xObuM2UreiURu8pgXS9w7TiJCemyYp
         zM6KLiNBjjeGhYqfRm4FyE4qsmfNOBlO7URRvwQDuPc+wTQGjxQdhFPEGXLlnAm+ZKtN
         3zRQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ahZCdsDMxvw4S2A1ZCJnlSZ9FRPCOytk/Ks7u3whZjsra0LabqDPQUtjyl61bhbeRR+IIkuua/g==@kvack.org
X-Gm-Message-State: AOJu0Yxe5+gTkaV4pS+GLUK33xW4OH8CN9LNJ43Ymq9jawcNGadf20s1
	1Y43QHoZdwdFoBUWfn6nzHwXXjAIEW9lX3K6y3CYyAzgNNiu6xOAeKTH
X-Gm-Gg: AeBDietuyeQfFq2CVwNcC9A46UYUZx2mtSOnbev51oXixjSk0TZFK2yIdC7j9DmFCPN
	peHEq6GFcusn5pIgyvsWjE4vY/BUtYoIC7nFHCa3v26jIS4cedV3fgls9rXsPIWpi+EPJkjLwXN
	tVLR0R3EzpSms0qZOlJJ/8rO6y4mw6aX14P0HLOdvqFvuLiMAlqLbX2PaQO+iNNZkJGjKdb3n12
	XVP+m4dPHPxHzIktEJPNQ86ynWYNUc7v65GAD9r+OYqSBTTOgrMBfduDf+CJ6aX92m2ExYQP5GX
	wceiOJv11Ifzwb62s5iLz65mLcL5va6ELDBLKP8R99izwgcZT3KwvAbaYi4cYFx9EmM8b3A23eq
	3zpXNFo6uc/LQSaJPoMV1iHPnH6NeloWhwcrhOcJyZsnIzpDU7e0Fkwnmp+z26pZ1NO+0GRtABS
	rR4bV+Cz9WvNeuKGH2dx1YVuINqISSRIBkSiQ1DZmspQQeeOxmjCw5tREUfM9g/WFSEK8KYlOYE
	8d+kf0kwcZNECOKvWwFL30g+/ZW+vTzD2yf+acTaFLX
X-Received: by 2002:a17:90b:5548:b0:35f:c156:a82e with SMTP id 98e67ed59e1d1-35fc156ab7amr7386272a91.9.1776266862425;
        Wed, 15 Apr 2026 08:27:42 -0700 (PDT)
Received: from ?IPV6:2409:8a28:a78:79f1:759a:a9c2:ef40:55eb? ([2409:8a28:a78:79f1:759a:a9c2:ef40:55eb])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35fd20d0e78sm3732072a91.11.2026.04.15.08.27.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2026 08:27:41 -0700 (PDT)
Message-ID: <2987ed25-bba1-4218-a776-0bb98aa87bbc@gmail.com>
Date: Wed, 15 Apr 2026 23:27:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <41b1ff54-c120-42ae-8b74-54767abf3554@gmail.com>
 <fe357495-2e45-443a-93b4-52bf21d3bdff@lucifer.local>
 <c6748ac8-6dcf-41b5-a281-2f21069b1f2e@gmail.com> <adTb6_xqQoQqK74Q@lucifer>
 <2f29f66b-46db-4925-b922-4add61b633bf@gmail.com>
 <53d748d3-4150-4e7b-8c1f-4c58587e9183@kernel.org>
 <6125defb-3aa4-494c-abed-982be684f839@gmail.com>
 <6417587a-7e43-4615-9e2c-50a245842f59@kernel.org>
 <f7f26a91-5346-40d6-aee3-3b64c3249ac4@gmail.com>
 <6edde1e9-0f42-4dae-b0d1-3f2895f2111b@kernel.org>
From: Yin Tirui <yintirui@gmail.com>
In-Reply-To: <6edde1e9-0f42-4dae-b0d1-3f2895f2111b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A18F7A0012
X-Stat-Signature: k1sfqbb7xkeo14efuahxpfqazoz8mbby
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776266863-271854
X-HE-Meta: U2FsdGVkX18OSoguVqeNQHa8YMLV7CJuNugFn5osAaavZ3cej2Y+slieJ6wQdyOn1PJGhZoXfkAhovOTaEnUoFOtvnOGHJvqBdOwR/n21t7RXFs1UZ7wrmfjpUAALtv33hgV/vZAjBbyL482xh68HjJo6nR56RUwK/gKhcljpDwP9eZPDMShMHO88ouqkHozPjakEDL/FwrfvybUu0ETBBOLKDfYoaz6/i6EmcYAObNpJSiIbjieqmyEOsK0IUXDQ3TOX4yQXyXEYX0ey6EVJZKDcgNxQaXzgolBdC1wO5S8s/JyLYB8P4U1Uo8hd7601rtK+wt8Xdz83TtjoDNHSnQ38zB34tFHMbuxcE3nIXZkdJn+qQx8h6HXfX7V+ICrexcdjLTdUUy+JM+hCkWZ5qhD6vpJKRcav5r1J3Ikya4SLCzl+Ln5RVyO2hqo2afQFMAnDV9o3cJU1/Yx+hWE4f2J3uY4Pz2RYmT39K1HEs5GGQBHS9nNHqP4bOeXGnYWvgarxHN0cWXdDPcjqA6mHFsWt/nbDU/72N9pjpCcAk0tjt5co9x7w6mXv6mnJ+Lx0go8atW4CXKXp8lMXS9vwkvvOtCoGBGPxjuc3/X+Lz0i+X76CxAJs3VKVtO96GutuQ5+1MJzB5aZ57mfJfWa+hap0y29AUeneaPGfZkxt8/ACmXIMza0jWnrlOJ6d8Zil2Yc7uE+225Hm5TBbHGnt7dig5K8EYi26LErjnKyy/72ZgcB9WqGHKemN5EFOo0uj1UYQ2VLMtBdcmn6VlOQJV3FcDlXICASNFEvaGgPsRCLOpIoUQmQf0mEf9gFcvUeuuerwO5aLkj1DwxjX6suIla7+2WTvqs73XSwR9jl0UxSxHFxs998+P0W691/EbXGJ9Wmp5DOA5sCqsJtrqCW2Y2kCrWODbC3RqX4CP/vP7MZx4tG66asJCR/AWmJ0LVE1o5kya23sfbuE6oRpNp
 KZeSElYH
 PxtuL5JitfPAXB7YAe5s38j9CAtzmG9RpfSN1jCZnRABwOqaAsfAusMWv+mx42svYcEZr/2wymUQvdbyBIC42TZMJIqsTsKB6fim8638Pcv9FJ/zqJQ8FFv3AfOL7HXgq0HfYCbk+vQPlt3tIYDxpxOsLu4rX9VgXf6cpZX9GMNO88r6k8wHC5KlND4Tyrb7setQ0mmwIBcAcTIQTSH9CrRqmW7qMYxRycsAvt9adkQDzwdOdAAJR9TS2vVasgGr1VtXXJDdhUIV0+AVA0wkLUEOttmvTkkR2EuRLA/ZwPN4YdOZ1Mn/raHFd9rQs8PZTtM+XzsYXKFse+82jwW+DNJxgMD6MmYG7DlNPgAcMWXbQ2y++d2FiLMnzmOxvvBPwxU52X1NIvrWqOwheCIv7vI5ekbV4xe2A1+MiaqBGWeaZzIitW5dLyvDZaihcSxhJpNTMSU4i6/yvpL940VqHyuRVAgapxxX/9H+3CqtkQUcayth/Tst7YtxZ6I7Ygl/KkDCP1MSuvlwHupZIhryW0wF0TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 4/15/2026 4:13 PM, David Hildenbrand (Arm) wrote:
> On 4/15/26 05:50, Yin Tirui wrote:
>> Hi David,
>>
>> On 4/15/26 02:15, David Hildenbrand (Arm) wrote:
>>> On 4/14/26 17:14, Yin Tirui wrote:
>>>> I did a quick tree-wide grep:
>>>> $ git grep -l "remap_pfn_range" | xargs grep -l "\.fault\s*="
>>>> arch/powerpc/platforms/book3s/vas-api.c
>>>> drivers/infiniband/hw/hfi1/file_ops.c
>>>> drivers/uio/uio.c
>>>> drivers/vfio/pci/vfio_pci_core.c
>>>> fs/proc/vmcore.c
>>>> security/selinux/selinuxfs.c
>>>>
>>>> It turns out there are two users of this "hybrid" approach in the kernel:
>>>> 1. fs/proc/vmcore.c: It pre-maps via remap_pfn_range() but registers
>>>> mmap_vmcore_fault().
>>>> 2. arch/powerpc/platforms/book3s/vas-api.c: It pre-maps via
>>>> remap_pfn_range(), but registers vas_mmap_fault().
>>>>
>>>>
>>>> How would you suggest we proceed here?
>>> How about we populate PMDs in remap_pfn_range() only if !fault?
>> Doing this would at most prevent VMAs with a ->fault() handler from
>> getting huge mappings, which seems to have little negative impact.
>>
>> But wait, dynamic huge mappings are actually created through ->huge_fault().
> If my memory serves me right, also fault() can nowadays install PMD
> mappings.
>
> For example, shmem only implements ->fault through shmem_fault()
>
> finish_fault() after __do_fault() takes care of that (mapping through a
> PMD if possible).


Ah, thanks for correcting my blind spot!


>> I did a quick grep:
>> $ git grep -l "remap_pfn_range" | xargs grep -l "\.huge_fault\s*="
>> drivers/vfio/pci/vfio_pci_core.c
>>
>> This is a false positive. There is no case in the kernel that mixes
>> remap_pfn_range() and ->huge_fault() on the same VMA.
>>
>> What if we use !huge_fault instead, disallowing remap_pfn_range() from
>> populating PMDs if ->huge_fault() is provided?
> I think we should just disallow any PMD mappings if we either have
> ->fault or ->huge_fault.
>
> I would assume that ->huge_fault implies >fault, but let's rather be
> save than sorry.


Agreed. I think I have a clear idea of how to handle this now.


>> Then, when we encounter a huge PMD, we know for sure whether it was
>> installed through remap_pfn_range() (needs a deposited pgtable) or
>> ->huge_fault() (no deposit needed, can be refaulted).
>>
>>> Then, if we have !fault, we know that the PMD is from remap_pfn_range()
>>> and has a disposed page table.
>>>
>>> Would that work?
>>>
>> So for Lorenzo's `has_deposited_pgtable()` helper, we could simply use:
>>
>> 	/* Huge PFN map without a huge_fault handler must deposit */
>> 	if (vma_test(vma, VMA_PFNMAP_BIT))
>> 		return !vma->vm_ops || !vma->vm_ops->huge_fault;
> As mentioned above, also considering vma->vm_ops->fault;


Will do.


>
>>
>> By the way, while auditing this, I noticed that
>> drivers/gpu/drm/drm_gem_shmem_helper.c calls vmf_insert_pfn_pmd()
>> directly from its normal ->fault() handler instead of implementing
>> ->huge_fault().
>> If we adopt the `!huge_fault` check above, this DRM driver would be
>> wrongly classified as needing a deposit. It seems that DRM driver needs
>> a minor refactoring to properly use ->huge_fault() to keep the MM
>> semantics clean.
> No, it's doing something that's allowed. If we call ->fault and there is
> not PTE table, it may insert a PMD.


Thanks for your clarification.


-- 
Yin Tirui


