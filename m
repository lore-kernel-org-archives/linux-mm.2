Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E627BCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D70D8E0012; Wed, 24 Sep 2025 11:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AEAF8E000E; Wed, 24 Sep 2025 11:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CE98E0012; Wed, 24 Sep 2025 11:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26E2E8E000E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:52:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D12671608F1
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:52:22 +0000 (UTC)
X-FDA: 83924585724.25.5F3D809
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7177C8000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:52:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b6Z91fIS;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758729140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzVixmsYq6hZpBtrPyWTw9f2SWf0I2tYU6xFVpkJp/M=;
	b=kUr4WvXGcoWYc/RB23j5utZEc4Pu/KyoZJfVASKbYLdoQHTBNoKAHJvJxW7FAGWfav1Rk/
	Xn0v0qzpf0tvwKEXIEaDveFjA2cBMSs7Iqp8jBbpVhKKD6vGT4eWu1W7Exns5V8keacDL0
	ez1K5OyvH+s5gJ5lGUOEkfmjM2dTmbg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b6Z91fIS;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758729140; a=rsa-sha256;
	cv=none;
	b=zTwjTS44I9s3wCnJu3sdxSwzRpAF4nZ4w64svojVy1zzp4F18sjMBn4AcUG3FgQBj4VAsb
	moSlDjN30w0BjN/SPCqT6+NnFyxIs7j+wG2DG9zjllNNJ0bUmfiPRKtQsfiKLKHv1o36B6
	B1U9io06YMvQNejjtOTwGm6WjXtxK1I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758729139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XzVixmsYq6hZpBtrPyWTw9f2SWf0I2tYU6xFVpkJp/M=;
	b=b6Z91fISeIdURY45PqM4lMh+5hrPOsh1HpKBNT3oR5TGLOqFXQhTtQJRwnT5NLo6EVatDA
	P0awvTpk+J43tTZzUe4cWz01nxYNgaYTDtf090ks0aaCgeuq3xN+lM29U2H3lbxu0qzyvH
	uZRjJ2hLA4o0bFfe0hvr3RBfWRBp+bA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-HhRBOpaXMheKh1lUQbyt1Q-1; Wed, 24 Sep 2025 11:52:18 -0400
X-MC-Unique: HhRBOpaXMheKh1lUQbyt1Q-1
X-Mimecast-MFC-AGG-ID: HhRBOpaXMheKh1lUQbyt1Q_1758729137
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e1ac7110eso17519195e9.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758729137; x=1759333937;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XzVixmsYq6hZpBtrPyWTw9f2SWf0I2tYU6xFVpkJp/M=;
        b=aWk0kjk6RyinjhADwZh8r7EbugAWBts68qYaLFy6tKNq36qys2vFCVGllc7fS688m6
         T8Aky6uAtxtQwLM49ey/ViAdCgleqlNaZ/p2cGa1umdE4Nb6GkSCj1CSpzIw7MNzx5Rc
         PfyF6jWhdJUT2i4/SobnWr6wuPsYPNzQog+iICshPNFPQtzE7+yBzgGT72JXiVlXMJp7
         +rRcVHqejAU6NhVw1UNc8qcWSurxYGZtHIxM8y1fzl249dVMfglyRL0dihLUZTZx1BTg
         5mjNRSAAsLkbi4rR/NdWgk7ppdYi6BBnyoY3WEjA68wVroO9CehdH021mkFgg/7A79m8
         8CVw==
X-Forwarded-Encrypted: i=1; AJvYcCV1w0RrdrKOLxm4hN55bKRa3ZkhUj1fdoIQtaANpESl1l4e2dhVSfjIM57qjn8URZo6qX13jKhBcA==@kvack.org
X-Gm-Message-State: AOJu0Yyoina8tXJ5ZO1tHE6aonml9BNcThjrhI/7PoS5MOiJZCJLKVOr
	pwknpnj+LlmxnUG5WVPq8QveaTIiK8dhfqrdzZXAqErAaiMQ06wO9QdKg1s0pHJCkMLmVWPhiA7
	GUQLdRokaEf4JSb5JhsWddkib/nymYivCF+sOf5Pau3HOax69+Qe7
X-Gm-Gg: ASbGncvWFxyx02cw5qsv3GJPXtgWFVHTiJVeMg7p5umlTKwLK5BaeuyWv8IRPs9Ej2P
	O9Bk3albo3VEkoe12v/d3L4rKf//sLSHzV/SHcoylackFyFzmDp3Xy+EHB6nSXvmLh3uesvVKbn
	JqZpDi6LDXCnruTmk1k8KfjaeIE1TBxnZeX+Q3XsFYPFjDTh83iN85AwLARd6S0Zun6P+DOTNLR
	CaKH+3hqKlar88afGQ+FKpXuZ6BDOvHNtDwoWZ59QZoYLggrmo7kQvDL0bMfEOvBfEHyRCIVeSC
	gQhJmXqdFLULDJAMiJTmPc5OWh19e8Pha81AiBc+9T8FisrBizHhPVheiQUPqFucnaS3ENWBqs3
	T93pohKXmgD6KxhAAA6lBEwqaN6R/FmHei8KcuJ6O6qO3KpU2Cti9gecWrq5FTt1B+w==
X-Received: by 2002:a05:600c:c4ac:b0:45b:868e:7f7f with SMTP id 5b1f17b1804b1-46e329f7c36mr3653495e9.17.1758729137098;
        Wed, 24 Sep 2025 08:52:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtIjjK5EmtNWj4tkdf++2VKpJZBRqmaieXYSJIlJmYT2U4IUZmCf1YtUJmt1dosqc2FgOgoA==
X-Received: by 2002:a05:600c:c4ac:b0:45b:868e:7f7f with SMTP id 5b1f17b1804b1-46e329f7c36mr3653175e9.17.1758729136675;
        Wed, 24 Sep 2025 08:52:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a996da2sm45549245e9.5.2025.09.24.08.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 08:52:16 -0700 (PDT)
Message-ID: <9b05b974-7478-4c99-9c4f-6593e0fd4f93@redhat.com>
Date: Wed, 24 Sep 2025 17:52:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DISCUSSION] Fixing bad pmd due to a race condition between
 change_prot_numa() and THP migration in pre-6.5 kernels.
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, stable@vger.kernel.org
References: <20250921232709.1608699-1-harry.yoo@oracle.com>
 <b41ea29e-6b48-4f64-859c-73be095453ae@redhat.com> <aNKIVVPLlxdX2Slj@hyeyoo>
 <6e4f6a37-2449-4089-8b3d-234ba86878e2@redhat.com> <aNPb3qVCZTf2xMkN@hyeyoo>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNPb3qVCZTf2xMkN@hyeyoo>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xDT8BT6zXUMjsnsPQYzIdCFF6fxd-tSHfDMQGUxmulM_1758729137
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7177C8000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: g9i5k7r4w5d6fdqphmxrupdmujn414wd
X-HE-Tag: 1758729140-885580
X-HE-Meta: U2FsdGVkX1/dz5K78IieAQSlbtG7mLU/RRD8oj6BwNR8Dl2V+Sq5nYh4dI+p+4hgb/STXoBBH7HR3soEZ8d6ryinOLfZPXPofUNPu+wVb8gLECZn6dD3ob83cg90TPv03TzxZ8fnJS1DFvsuC1gGPbteYuXBwUsEnnvrXP0d18KPC4vgoeHeM4lp+qkUrK3iCxAw8CMPVQNmDHec1+GYwMeBspOYjxdbPJQxNxV7WVKDPQ0lWAwSE5Hir8wyrQ/pcDxQGZP4HP8Xs5qGOTIaUTCD//xLD410sNS/MUNgyNZ4OjFsy2c+LNFsyWowInnoE/1DU2/U8qPnRVwX/toOlUiZqVJIrUnFl4OzRdIzaZlXpbb7Y3jrqeih4HDhwIm3ZBJ9/OA5H2KVbz+l1GQQS/Xbq/P/1HpDsuUYsx0qMze/w//ZELCjIu9yKVVtXCYOd/sr4vGO0E9FDMSogyzDeb0+SA+3e4e6vi1R/H9k5269zzM0JIhtZrEM/xAUBoOHbhOstwdmRhTjm6oAhH0hPonLlCnjtrbq6lFnX3Bt0CI2JwcDf9feuErgBjV2XWah1HcmFlVH2ej5siboXMByZXfZzJV8lLkzTYyVf+yHGiwLfymlo1RTZKG3anW+lHTJlX/WnjIeaQHPuc9/OI3mhzFJPn77zVLXel+SxblI6Mup/+tEBTQ3u7LaXoubAqtMsChbvdfz1f8EiSOiTOXJNTwPmCUKXDMjYXUgRbWC6BUA/CHpSLqw1uprG7vTOWeTPSLtvaEYaoSNAu5z2/0Gne/M3+iVk9rUK0EODMibMFc4OVQYPJmMOZgHiDk1HX1v68EamG1a6Kf09nAzTgqyJD1OEQEtNFnY5mLVMqS1snBnnSg533T7FRRu1vFtf8lgb2No/VHQDnduwU5LaQQr8MZFwXWqwop6eAFfnfZCnpxetyxxKLtgdcMZ9uNZ1gYufRYl2YyRL+dRUbXrcOh
 +YSvUOh4
 HBhEA/utgHQSCX8bFk0JUHw16J5FjF9fsUyDnROV2PQXZ2tudgBio79im0ber4Wc8Cd1xyQCLnc84TQMs6KFnVHd3CU5czFSbqwmUgiAbpwxZcwmGqknPnCOAJDke/R8H61mpFHIhtrOMdMQF49qDX1FRL30GWXq1YeS26Cm3K4XdxQXhI0uNBtWD6pdKcXQLuvY9+31ZUKeYs5Q9QKfF6qgk5XbclXruLaar8OE8/oZkYCJQ5q+A7cZum4t+xz1xPO5gSF22QgdFWbl5AfHwtYgIY2K4iJHQNs+AvrhVeOcMqAXmotgF34gvxnrZdCCPGtOFwT/h1vM/NOfA2+fpZMZgxW4X5YKUOdCNnUkLi5iMZOqRL1rOEhJmoGdkjlcJPMhftGtlMdAqdftyLMZjrri24yR5GTu8n0UGCxW1Nrh8j99ohGO8MiQdMPPRrdxITaSkwBh84Pv6I63z7WJJohdKDoiMp55JmzUa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 13:54, Harry Yoo wrote:
> On Tue, Sep 23, 2025 at 04:09:06PM +0200, David Hildenbrand wrote:
>> On 23.09.25 13:46, Harry Yoo wrote:
>>> On Tue, Sep 23, 2025 at 11:00:57AM +0200, David Hildenbrand wrote:
>>>> On 22.09.25 01:27, Harry Yoo wrote:
>>>> This is all because we are trying to be smart and walking page tables
>>>> without the page table lock held. This is just absolutely nasty.
>>>
>>> commit 175ad4f1e7a2 ("mm: mprotect: use pmd_trans_unstable instead of
>>> taking the pmd_lock") did this :(
>>
>> Right. I can understand why we would not want to grab the lock when there is
>> a leaf page table. But everything else is just asking for trouble (as we saw
>> :) ).
>>>> What about the following check:
>>>>
>>>> if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
>>>>
>>>> Couldn't we have a similar race there when we are concurrently migrating?
>>>
>>> An excellent point! I agree that there could be a similar race,
>>> but with something other than "bad pmd" error.
>>
>> Right, instead we'd go into change_pte_range() where we check
>> pmd_trans_unstable().
> 
> Uh, my brain hurts again... :)

Yeah, that's why I gave up faster than you trying to understand these 
horrible, horrible functions in the stable kernel :)

> 
> In case is_swap_pmd() or pmd_trans_huge() returned true, but another
> kernel thread splits THP after we checked it, __split_huge_pmd() or
> change_huge_pmd() will just return without actually splitting or changing
> pmd entry, if it turns out that evaluating
> (is_swap_pmd() || pmd_trans_huge() || pmd_devmap()) as true
> was false positive due to race condition, because they both double check
> after acquiring pmd lock:
> 
> 1) __split_huge_pmd() checks if it's either pmd_trans_huge(), pmd_devmap()
> or is_pmd_migration_entry() under pmd lock.
> 
> 2) change_huge_pmd() checks if it's either is_swap_pmd(),
> pmd_trans_huge(), or pmd_devmap() under pmd lock.
> 
> And if either function simply returns because it was not a THP,
> pmd migration entry, or pmd devmap, khugepaged cannot colleapse
> huge page because we're holding mmap_lock in read mode.
> 
> And then we call change_pte_range() and that's safe.
> 
>> After that, I'm not sure ... maybe we'll just retry
> 
> Or as you mentioned, if we are misled into thinking it is not a THP,
> PMD devmap, or swap PMD due to race condition, we'd end up going into
> change_pte_range().
> 
>> or we'll accidentally try treating it as a PTE table.
> 
> But then pmd_trans_unstable() check should prevent us from treating
> it as PTE table (and we're still holding mmap_lock here).
> In such case we don't retry but skip it instead.
> 
>> Looks like
>> pmd_trans_unstable()->pud_none_or_trans_huge_or_dev_or_clear_bad() would
> 
> I think you mean
> pmd_trans_unstable()->pmd_none_or_trans_huge_or_clear_bad()?

Yes!

> 
>> return "0"
>> in case we hit migration entry? :/
> 
> pmd_none_or_trans_huge_or_clear_bad() open-coded is_swap_pmd(), as it
> eventually checks !pmd_none() && !pmd_present() case.

Ah, right, I missed the pmd_present() while skimming over this extremely 
horrible function.

So pmd_trans_unstable()->pmd_none_or_trans_huge_or_clear_bad() would 
return "1" and make us retry.

> 
>>> It'd be more robust to do something like:
>>
>> That's also what I had in mind. But all this lockless stuff makes me a bit
>> nervous :)
> 
> Yeah the code is not very straightforward... :/
> 
> But technically the diff that I pasted here should be enough to fix
> this... or do you have any alternative approach in mind?

Hopefully, I'm not convinced this code is not buggy, but at least 
regarding concurrent migration it should be fine with that.

-- 
Cheers

David / dhildenb


