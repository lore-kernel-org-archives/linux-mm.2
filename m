Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD6CC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 947356B008A; Wed,  6 Aug 2025 08:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E6B6B0092; Wed,  6 Aug 2025 08:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6B06B0093; Wed,  6 Aug 2025 08:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6EE8C6B008A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:41:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 209CA1601A3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:41:20 +0000 (UTC)
X-FDA: 83746293120.02.65ABEA0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id AC5E218000C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:41:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JQEf7Gh8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484077; a=rsa-sha256;
	cv=none;
	b=1HFEaZ1iN4ErzyUu5VyYL195fPWQvN4f+J3R+zzBWzhJseJ9pHlRy4/wZMErWsfDVamy+5
	E8WvXDlYwjhV3Ajn9qOBR3z/HVyDqmCHjlqTjdR5Rry3VQEg6hKYk+hJK6yVpBTO/5u27/
	j6CJH/aTDSUI8Oeqqy4m0cmVYfO2Hzw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JQEf7Gh8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xNoQ4aDHj9SPk2fwp55F4gpA4GyEXTfiEAYZw5++7XU=;
	b=767DicOQTprRUky9NzPLdp2a2T3Ty5VdkfT26UrESG1J7yXO85CEdAKJv0J8pjLBSnnJEP
	OCHZwadGq0TCKOJSj3KsTRqPGCI/arnmXqeE/THr+1hnIafTw/E5pbQ7YJ740+krkGYGzt
	OK/OHddkX4m56khdm97+V2BGbRtt1cA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754484077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xNoQ4aDHj9SPk2fwp55F4gpA4GyEXTfiEAYZw5++7XU=;
	b=JQEf7Gh852mLoiAI7CGYhnCg+HSIdGfpwkw2qA9xASHLL6udKESlEVRa+iYsqbUSGRscMV
	X9BUqjE6VebBvBZ8sOynt3YGQ6rfQWY3kW4oXhi+5DcPBtfVn0YwGko6JOF0p8/k7HKVmG
	ID38Cbw4IncbsroN6JOMA0070ECYUUs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-9P87yGxTN8aRaAgJ3lNshg-1; Wed, 06 Aug 2025 08:41:16 -0400
X-MC-Unique: 9P87yGxTN8aRaAgJ3lNshg-1
X-Mimecast-MFC-AGG-ID: 9P87yGxTN8aRaAgJ3lNshg_1754484075
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459d3abb2b5so13419815e9.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 05:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754484075; x=1755088875;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xNoQ4aDHj9SPk2fwp55F4gpA4GyEXTfiEAYZw5++7XU=;
        b=kNseio+wa6eNHPp/7QKmTmmdfofMPK398UlXOXI/47Q32Y60O2Q6k67HptgOPil0dP
         7gghIzGaKKag4JoaaBMiwEFj7/dYsh1fsIDuMKUSdi9X9QYzuZVTn/RIMShHdtZxNK4X
         8NWmM49mQbxeyoSqOyRI0vPX+uiUn+ClP75gXGqM/kz4BsG+yRb7ZyvVCGyt1gPwCpeI
         ob+fxMg2sMcYwlH8OhufqK6qK86x+Ak4VJaaF6zHymyhOSXorYRQEThqwPX4HMyD/tRO
         0vx+K5JUM/opjhFMI4lEM7ijrGEURa/y/NLhmmDKp9WOjWefgb7S2iY+3/6wcyIsf51A
         LuWg==
X-Forwarded-Encrypted: i=1; AJvYcCXWprkX8RlEXMQwB/VleBBgW3MU0n75XBfhIY4fVmNe2+6O9cPdE1Mrv55fVlsKPOl3f4sXtY5miA==@kvack.org
X-Gm-Message-State: AOJu0YwbC8ROrJzLo6+1sQYnVxGwMfemsrsnK39lTDg9l9bjpUILg2gP
	sdOsAgrnCkAbvZBncGzuf62ooYBaUlHvViYrG/ZrIV/NVkHFfoVA0+RILBBNnJbniQlj2HnTZUE
	DbU8ZSUpgdHtMsVljKimuunSzQE3L8GcEMf1mNEL+8uhFR8qLFs8o
X-Gm-Gg: ASbGncsUbvNM1WNu12sgWIo1fvEECIPLYsUSVu3Mz9vOLWZ1aneAd/zx/2MFVCxmXaJ
	0YWIYzz2qFfdLIILDWUTCJI3MzKb5TEo9Xre9EhkcCUUfkkGlisHd1n0Y7/RnLK87CEDxXC3m/X
	YfITzw+20bDSK8dtUWPYWudJFeKygl+LZCmwdqjmlGH1lOwqZEY8nb+L4dLjIXfHtLTiKTw9gma
	/7e48hkg6XV2MRs2lq267PkxqGSg9YotMay81g/9X6J+ip26mH2GQSpl4SOivyF+3GyX76jNGTG
	3q7NEIrVMgzdrpYROWoNmc5rZ/cBfPiSUqHNOaukxvEZ7rX34RHFLeqxLJJxtqkN4aP8WwS1K9b
	VDLKP125yzcFku+/OPZZ6KAwzuyhTK2roa706pmkzK5cVfwUe7hCVED0wWHu9TBWzOnY=
X-Received: by 2002:a05:600c:1d03:b0:456:18f3:b951 with SMTP id 5b1f17b1804b1-459eba92cb4mr7064245e9.15.1754484074731;
        Wed, 06 Aug 2025 05:41:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFu6NcdjvzoKzaXTehu0pcZWkEaHo70Um5tMvolF7jGyA+XrkKgT/XRDCIRElqKYD/QPOOcyA==
X-Received: by 2002:a05:600c:1d03:b0:456:18f3:b951 with SMTP id 5b1f17b1804b1-459eba92cb4mr7063875e9.15.1754484074317;
        Wed, 06 Aug 2025 05:41:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e587e154sm52227425e9.27.2025.08.06.05.41.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 05:41:13 -0700 (PDT)
Message-ID: <c5567040-6f1b-46d1-890e-7dc6b0b46703@redhat.com>
Date: Wed, 6 Aug 2025 14:41:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
To: Jinjiang Tu <tujinjiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: wangkefeng.wang@huawei.com, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, xueshuai@linux.alibaba.com, ziy@nvidia.com,
 osalvador@suse.de, linux-mm@kvack.org
References: <20250806020520.631203-1-tujinjiang@huawei.com>
 <1e63c37f-8eb2-865d-d3f4-9ef928f1a959@huawei.com>
 <35e24029-d58c-47e8-b5fe-e182f143ebff@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <35e24029-d58c-47e8-b5fe-e182f143ebff@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dm-uspGHTBvq_vKSAkASCMoq6waobzpijdvPTWZgfio_1754484075
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AC5E218000C
X-Stat-Signature: 4qqko5gqe3tmb3kih1mdh5wxhqsjrjhp
X-HE-Tag: 1754484077-161609
X-HE-Meta: U2FsdGVkX1+8j167qqU6E/7fSxyAKYvdZtdwVuGWwgOi+sXIxcwXbISwp5Cxn3NyxHrszE7YqW6vTBLz1MRMV8RRu46/hrwaC45dXkV0OCetwG10S5RjIukfOieu8ekjuPpER+7Sd4kKWIuCFARY4iKPnJgFs9THAtZX4lY0DlDHzgmmGYwanptRA6SuKz+F8y0ocZeHYUKIHT6aH08pEu2IKTGIMJ2U9/p+aObauq+OVUk8sltkqfhFkCX5NIjrOnkanU6URBW4AT5mTerd/EseWs0ZYdEeVJoUk8iF4O5ZBf/1va3UsmkmnFmxd0AtqPDCVARp9H1jvtngs9yST9HiNIMYnmkeetp0B++iDMRbqleA2N2vHuE/qnHl31Mvu8RSMOT+Vi8UrmhlS7tGqfjq4xu//mhJaN5nZwnuv/I3rYSdh3j6iBIUsDUhaUdXDBpXvXGxyCL1tvTuXgzsas3VvN6GxqpoYCLhCLEftJfdfZ0TdRagxrhcpYEtfKqcswHAwiEZmwPT+oMkxLgllyGqhQg3qRd1+65WnhZKt5oxyndVSQonKO/jhMXe4GEkgbqAT21R4F0ErASorOInWc/RYiDDesR9RTzUleogL0m8kuPeAczJ6KET7KMrZfpxWxS3KTv0e676tmQBooe6/Dqn64OkKXrm3utdzOD20gj46FsLTZzyR75JlFJMLMtOjFPVOZFro3b1Yxfk15av/VBD9/gvpZgHsSoaXHQ2OTalGoCxVO3vePuvxnVwn3FMNVwh15aeKYAjP6dBTTA8vAZ7xZbprIq6d0hyvkVRXHCmLAUheU/Eqh9TZnf33Y0NNi33mzZK04qJdziHY+IpZ7eqEU59fOwAbJT4gamP6Ck1cmCYNMv03afSFuXBdyob2SYyUp0vqLAyi3L20hxgyWbbK4MX7J0a9OMiHqchnPuwY3iaO9mLXGdcT2FkUmY/VUUAKgmmHRRd4HxCRWc
 BBPSIspv
 Vo73RPnCxy+5X7Y8v3tEF76K+wxfeiUzkxhvOmIVTxyiOZnpmIXplDYmujiQGsCnYp1N/KpJAN8h54ourrA+awsL6276gnHmhdDLmBY86hI808FWmcRCdajGG/G+VLrYqxs3ZvhceNqauzvRRzmerSmVJ1CrKvBvPHgMtkI8LhSkQ1ss4bEh2DD1HgymAKOTX2CVyZcJuvk7lAm9ZYWhWxEnjCwpr2JHkyKKO8z84YsbjvYYyQmcduZdqpCU6wHtITuVcY43ms1B4EN3LZrP1I4/fLVbnkGwp5LFkfOp4QZ7EWx/ZoPizujJ6GCdwaXrc6HFanTnZ3CTCH2ccjzkOJVvryFZvVNmlhRMuWapcoLyOTKDFI2NAWDWjaZ5GmEt3tEo55Qz/2WwsF07ilgWEx4+2tvw5mEMbe4AJm+84izaE5RmtflrADevvqA84qxNhnn83zJMX2H/2/JaWFu8IM8YiIaF9hWS7hF6FEUTz7uAowVjOyEHlN+WcKRzC5xLVCXmJovtMgz0ZI4uaO1/orQEe2wI9AJCJHhZLjpAEmAueBE4oGzvpk/y5UsobyFCVCs+cpMRxTZyQOOWyjxiOqtXUA32OjKJcORra
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 05:24, Jinjiang Tu wrote:
> 
> 在 2025/8/6 11:05, Miaohe Lin 写道:
>> On 2025/8/6 10:05, Jinjiang Tu wrote:
>>> When memory_failure() is called for a already hwpoisoned pfn,
>>> kill_accessing_process() will be called to kill current task. However, if
>> Thanks for your patch.
>>
>>> the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will skip
>>> the vma in walk_page_test() and return 0.
>>>
>>> Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
>>> with recovered clean pages"), kill_accessing_process() will return EFAULT.
>> I'm not sure but pfn_to_online_page should return NULL for VM_PFNMAP pages?
>> So memory_failure_dev_pagemap should handle these pages?
> 
> We could call remap_pfn_range() for those pfns with struct page. IIUC, VM_PFNMAP
> means we should assume the pfn doesn't have struct page, but it can have.
> 
>>> For x86, the current task will be killed in kill_me_maybe().
>>>
>>> However, after this commit, kill_accessing_process() simplies return 0,
>>> that means UCE is handled properly, but it doesn't actually. In such case,
>>> the user task will trigger UCE infinitely.
>> Did you ever trigger this loop?
> 
> Yes. Our test is as follow steps:
> 1) create a user task allocates a clean anonymous page, wihout accessing it.
> 2) use einj to inject UCE for the page
> 3) create task devmem to use /dev/mem to map the pfn and keep accessing it.

What is the use case for that? It sounds extremely questionable.

-- 
Cheers,

David / dhildenb


