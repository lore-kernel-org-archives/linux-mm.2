Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED8BCAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 12:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC0A8E0027; Mon, 29 Sep 2025 08:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD39C8E0002; Mon, 29 Sep 2025 08:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B228E0027; Mon, 29 Sep 2025 08:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B33E18E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:08:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5691A16039B
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:08:27 +0000 (UTC)
X-FDA: 83942165454.24.0BD800D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 126614000C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:08:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XeGHCI2Q;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759147705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WiyXLvaLe86C4CnNbDWkghciau0ml4CvMCknlnsFgLs=;
	b=09kQIJQ2RG6UHW6RHAsuBRh/Rsof3XuOBj+SEApON9P+rvjISCMt2/hNLmh9TDOXZLMg2F
	EcKHH5uaoY3Y0m/p1KsUNjP/9yA3QlOjUylvS2mE5H+ZlyJns6tMXa/7lExcuV9Izb+MJS
	FEhoUKmbu5ZWqV4vVXAb7FcO3r2UEYQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XeGHCI2Q;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759147705; a=rsa-sha256;
	cv=none;
	b=NEO15S1Cvfsm/zjwr2P/4D+ePkcu+BTSXRaJtDLQ2ZfiVXXnYZZtrpVfmq1YEU7MDZf2y3
	Uvgp0WnFBB4lFcVXLvfJpX7nSMkW3dxylv6N8J7KWYrS1i46TRUXvpO5oxXmeIU9gD4brn
	likstRn4Alla8xdWJjz4apkQZiAxYGc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759147704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WiyXLvaLe86C4CnNbDWkghciau0ml4CvMCknlnsFgLs=;
	b=XeGHCI2Q0R02wnJAIZ5+hV3txj+LpfG+oCgaaFBU/rS9Up/9ji1jQR+5avZdljxqhc3Qox
	1mBuf/gYG90B2H8Rd4xjWWepGW4kfz6Ubg2lFW2dtXtqZFgIWPXXpNPGSxfIptAvii6USj
	Ps4BBcg7h0LcJvzQWv/mpcRmR7/LtG0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-ZQIkEwotPGmw151saJGUkg-1; Mon, 29 Sep 2025 08:08:23 -0400
X-MC-Unique: ZQIkEwotPGmw151saJGUkg-1
X-Mimecast-MFC-AGG-ID: ZQIkEwotPGmw151saJGUkg_1759147701
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so29018065e9.2
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 05:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759147701; x=1759752501;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WiyXLvaLe86C4CnNbDWkghciau0ml4CvMCknlnsFgLs=;
        b=hLow2nVFKreKOZQa5EipgKgKQy25PHquDlm79ZVbzbA5VXdSg98KiqjNu8nx/E1qF0
         39qrNhcU+IkL7UmYxJBsRTI+XG2v1rQxfnfYM2fuTDon3+PEZ2Zx2oCG8Hr9Z6Z7QyQl
         uXJ+Or038h386y/qiMkoLUpjPUilTNkBbzTDbXBMlpbKU7o7i9YisFnJJ7BkPFO95ySj
         +NbQqN5dw3EwY6QBEUFsrs1N5QuGra2QRKvMCp5Dd/UydoqWXaUB8OzsPijUAKCAmTym
         4N9kXWH/HS1jKegrsVPiuuSgT0zFKbWQJOnMqrtKYZhczyT5Tw/IoJhrpPWpqy/nYzV6
         9FAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZiOVbeMRJrus+RqrUWpn+XQBYFPiZzsRCE3SblGs8xNtTYtf3Q30OMPK/nFbiJp0Usmz++oA7WA==@kvack.org
X-Gm-Message-State: AOJu0Yz3EXLcF1T+/GXkbNV8tqpbVds9VsQloEX2eHA2OiU3zXH+5Rrc
	YTs0kz5NOo/h3VLPz8F3F7yphi8kc02GVQeNBmyW0SaWjq4NHKTeAWEiMGYyUoQNtKEVIxVQj+K
	TNPnfqoc2dKP0nN7QidVrAbz0bSLG+3vuc3oPDFI8n/w9D7inOpiy
X-Gm-Gg: ASbGnctjf9l093EVyVwQkEzNVAjQzejWwb73O78nupLD9Jzwg0du/K+U6qWzbO5x0Yc
	c8ohF7XXNJ7PCsG8hyt5VocC2lU4hWX35XbohgqBJFi1hhW9GmbXQ6jLwk/2u56igFmq6HCehMF
	B6pVj4pjCAtMe4tV5Xk7G/j3NFFKBW048sLoaWE/1Olhg1dNr2wOkUhJ6ZFGjwUXLxEBwv1etd+
	bPJ9+qjHs9pekvyKCWmP555hLLuDFpQ0xZlxhIp1Yoz9dB3SNzsL70Mu46PE4cDhlqeDMmjk8rz
	jm8nCMaE13EbV6F+QZaRMrQOLvgiO3Y/g6ld5OZiw6DwQUGEuAq0jCLyFikU/fdyEe99VW65QPD
	24ZjCc7CP5aodW8jwgq6yiEHJwYtGNqKP8qg65gjGr61QFXxb5u5so5Rhp0igxWdjzs3P
X-Received: by 2002:a05:600c:8b05:b0:46e:3e82:6551 with SMTP id 5b1f17b1804b1-46e3e826872mr95979955e9.2.1759147700742;
        Mon, 29 Sep 2025 05:08:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG33fiIdiXh2Apbgrxvp2qHDqZqgyu02SfE3Pyi3i8dLLAoQOztr9pyWiMkM+wl4qduG0BzsA==
X-Received: by 2002:a05:600c:8b05:b0:46e:3e82:6551 with SMTP id 5b1f17b1804b1-46e3e826872mr95979585e9.2.1759147700309;
        Mon, 29 Sep 2025 05:08:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f39:1500:c90f:7794:3c33:4164? (p200300d82f391500c90f77943c334164.dip0.t-ipconnect.de. [2003:d8:2f39:1500:c90f:7794:3c33:4164])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f53596sm10484755e9.7.2025.09.29.05.08.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 05:08:19 -0700 (PDT)
Message-ID: <69b463e5-9854-496d-b461-4bf65e82bc0a@redhat.com>
Date: Mon, 29 Sep 2025 14:08:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/rmap: fix soft-dirty bit loss when remapping
 zero-filled mTHP subpage to shared zeropage
To: Lance Yang <lance.yang@linux.dev>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 ryan.roberts@arm.com, dev.jain@arm.com, npache@redhat.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, usamaarif642@gmail.com,
 yuzhao@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ioworker0@gmail.com, stable@vger.kernel.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <20250928044855.76359-1-lance.yang@linux.dev>
 <b19b4880-169f-4946-8c50-e82f699bb93b@redhat.com>
 <900d0314-8e9a-4779-a058-9bb3cc8840b8@linux.dev>
 <1f66374a-a901-49e7-95c8-96b1e5a5f22d@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <1f66374a-a901-49e7-95c8-96b1e5a5f22d@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CZww3-iuQAsICEm7ETCJ93Co088_sphQgbUPPG6SQSI_1759147701
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 126614000C
X-Stat-Signature: dmmuwo7845618ti73i9qnxwp61zzjrwf
X-HE-Tag: 1759147704-339827
X-HE-Meta: U2FsdGVkX19t6Yz3lVgevgzcKJX+ap5GDHHacKUu7b/H6PuoNJnxsg2maxcfPd+lbMcrgJ/2avO/nVscxtjpqGokjq23oSSn7ngklpPCqGZZJZ1XnJdeLeCvkZtbmodYXb81ZYNQ0b/HBk93GFOEbkns15aFpEYeOZ4WWbK9nf9NyLt7kLwqCU61eMWaauNKJvcRR/vcitJLzw5HVkQs45k+oa7TDFWk4N2FpBHcYN3xPGWkd2CThZoThxGpw9++iMaC/j3WSsHs8P398LIzbtt3p+CL/q9ucJZagAmtEmyb+3HIBXoslrUIKefZbG0SpWvONTamHwsJ9Cw5ucuAFO52DKUu7E8080qtZq3gMtXukwYvxzOr5djfWhZk2hLwGcJv39VUCcmJmQJiei5Tf8TmzZlZMqDMtp9lY7AQBffnlhsFLektq5OG+vpj/vjl62ZMeyaoZ1JER338VpdIzYrj7HQ3eaNMfz9LcB9WHRc+w3C8+92cUzcbHpiOYkhchAECy9jCms03d9OrnGGRlCZocJf3uD6RZ4p2AOh3/7q3WSIMVQYLPEidAnqHOymfQaSPixeunzdztThE7ud21QUbllI01TbWyNvMMAYkGikdx5wQ++mD1n6IijY7dqYsctj3GH5hd7lZ4gW/+5eSDwCpI2+Sm/watYt1GBUGyYnGyZqAZbglKRnJRgyptdfz29OhTeKy/DUFuLkOmIaIOA9L6t6g4FFPb2J7Fem3kEiRaJPnekbfnqfeXJhTjmpC9SLJWrflvmzT1NEIf/ZHiwEvAiHdIn9RQOU8x5Af5SY66Obvv7E4evynBJzWZ8rARlo9XV3ZRv67xLRWfOcvfmVMGIO+8q1fFoiX0V3GFtlCiASJSGr/O0w6QcwEbX78hv/AqpszE4CWB+QscTnnBHOlbirCzpUCRUrOacc8VDTyijCMfKdZFgo+SROZoOVGIoZBpLxxaLCPwbMDHz8
 +s85+J5I
 fkmG1GNvvrynuOrVKTVM0DclgrZC3Go3sLbFNXBvzEVcSNEVz46QzqTu+MgFPuVIdsPagMl2lHmqlMtbXir+CCv51BpQU669rb25ajoTffBgxaco=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.09.25 13:29, Lance Yang wrote:
> 
> 
> On 2025/9/29 18:29, Lance Yang wrote:
>>
>>
>> On 2025/9/29 15:25, David Hildenbrand wrote:
>>> On 28.09.25 06:48, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> When splitting an mTHP and replacing a zero-filled subpage with the
>>>> shared
>>>> zeropage, try_to_map_unused_to_zeropage() currently drops the soft-dirty
>>>> bit.
>>>>
>>>> For userspace tools like CRIU, which rely on the soft-dirty mechanism
>>>> for
>>>> incremental snapshots, losing this bit means modified pages are missed,
>>>> leading to inconsistent memory state after restore.
>>>>
>>>> Preserve the soft-dirty bit from the old PTE when creating the zeropage
>>>> mapping to ensure modified pages are correctly tracked.
>>>>
>>>> Cc: <stable@vger.kernel.org>
>>>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage
>>>> when splitting isolated thp")
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>>    mm/migrate.c | 4 ++++
>>>>    1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>> index ce83c2c3c287..bf364ba07a3f 100644
>>>> --- a/mm/migrate.c
>>>> +++ b/mm/migrate.c
>>>> @@ -322,6 +322,10 @@ static bool try_to_map_unused_to_zeropage(struct
>>>> page_vma_mapped_walk *pvmw,
>>>>        newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
>>>>                        pvmw->vma->vm_page_prot));
>>>> +
>>>> +    if (pte_swp_soft_dirty(ptep_get(pvmw->pte)))
>>>> +        newpte = pte_mksoft_dirty(newpte);
>>>> +
>>>>        set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
>>>>        dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
>>>
>>> It's interesting that there isn't a single occurrence of the stof-
>>> dirty flag in khugepaged code. I guess it all works because we do the
>>>
>>>       _pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
>>>
>>> and the pmd_mkdirty() will imply marking it soft-dirty.
>>>
>>> Now to the problem at hand: I don't think this is particularly
>>> problematic in the common case: if the page is zero, it likely was
>>> never written to (that's what the unerused shrinker is targeted at),
>>> so the soft-dirty setting on the PMD is actually just an over-
>>> indication for this page.
>>
>> Cool. Thanks for the insight! Good to know that ;)
>>
>>>
>>> For example, when we just install the shared zeropage directly in
>>> do_anonymous_page(), we obviously also don't set it dirty/soft-dirty.
>>>
>>> Now, one could argue that if the content was changed from non-zero to
>>> zero, it ould actually be soft-dirty.
>>
>> Exactly. A false negative could be a problem for the userspace tools, IMO.
>>
>>>
>>> Long-story short: I don't think this matters much in practice, but
>>> it's an easy fix.
>>>
>>> As said by dev, please avoid double ptep_get() if possible.
>>
>> Sure, will do. I'll refactor it in the next version.
>>
>>>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>
>> Thanks!
>>
>>>
>>>
>>> @Lance, can you double-check that the uffd-wp bit is handled
>>> correctly? I strongly assume we lose that as well here.
> 
> Yes, the uffd-wp bit was indeed being dropped, but ...
> 
> The shared zeropage is read-only, which triggers a fault. IIUC,
> The kernel then falls back to checking the VM_UFFD_WP flag on
> the VMA and correctly generates a uffd-wp event, masking the
> fact that the uffd-wp bit on the PTE was lost.

That's not how VM_UFFD_WP works :)

-- 
Cheers

David / dhildenb


