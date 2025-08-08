Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEB0C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 08:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0D796B007B; Fri,  8 Aug 2025 04:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBE566B0088; Fri,  8 Aug 2025 04:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D859B6B0089; Fri,  8 Aug 2025 04:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0FE76B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 04:22:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F395C1616A6
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:22:12 +0000 (UTC)
X-FDA: 83752897704.23.7DBB876
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 834C1160011
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:22:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="d0/90xtl";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754641330; a=rsa-sha256;
	cv=none;
	b=3PphVyiyJ0bMoF4waE/ax5U1Ef5k1ps97/Vy3y1VW1QFPJVaL6kfOKzGkl3ijKEtDPVzSM
	qO1xRtoYv/YTif36OM1OR/YJLV2gaWas8PXBvPMydgOk6t4/p8+hHpjcta8zKvT1NQHf4T
	IGGpJEmqEOx+clIww9xLo1zwlxux7vI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="d0/90xtl";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754641330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asuk224/PPNMuhgjRnxBWNPkkI+xuhI/SaO3IblWFFc=;
	b=V+2tg2Ihu4pytjqq/BtQ3iW0HmjpqNG/3OxFPLI8VyIPbvJbRSf49Zlx8CKDg9lL4UkCsF
	qtd+4y9r4noqiMRBhys/lBCMbTz4I+4EHBlSON590M64NElfmGyl+Y4ulUeTng4nAzxvPp
	Zsco0VRpJFYQN1wIXvyr+IhhAQDWSIs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754641329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=asuk224/PPNMuhgjRnxBWNPkkI+xuhI/SaO3IblWFFc=;
	b=d0/90xtl9fhMUsVvPqufZy1O4OraUPLqql/bAtJQ7Y+qn/yeAg6g89HUC/xRPft+HElmQB
	+WJOziqQ8nIvhIlAJLs0WRi5SqrntD0sMCuAudPaTyta13Ns3H3Z7qJ4ajPyiQcTGRhDHV
	6pqvNMDuupLlgvMIZf4wQrKMnjDfP+U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-6K3J7JpHORyedGfAKms8Tw-1; Fri, 08 Aug 2025 04:22:04 -0400
X-MC-Unique: 6K3J7JpHORyedGfAKms8Tw-1
X-Mimecast-MFC-AGG-ID: 6K3J7JpHORyedGfAKms8Tw_1754641320
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b79ad7b8a5so1118934f8f.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 01:22:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754641320; x=1755246120;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=asuk224/PPNMuhgjRnxBWNPkkI+xuhI/SaO3IblWFFc=;
        b=OM6POpnjgPW2c+6aiog/fDpeAmxTVW/pggLqoUC3o9vlixCk6ucky6TCAlfz3sKmvp
         sBUXNAmGeHtp/4Ha7MRZ+Icg2cftrHS1ozbxoBMBXXYSJo0XuPIupOimgCZpQLs7JHQ+
         tYH/UclYYd185Vs5EoarOFRtTLfIHKV0BM0d+LK/AbliqLTdR7UyaIV//mWi4B0l42ER
         b8L75zk74VEpylDtNPcYkz4Nn2Ahqe8z1ImQgQDybEZe63QL0H+EVKjUg7aUlKd9ws0A
         rXCKtneYhoWOlN7OS1wSeCJB5XRVSTWr5/Q2Pk93ghsgZPa0xRU7ArR6caqt6Yknmmjg
         KFlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJTUTR+wImBGMVd0UMaN6Y1+0efy0H2cpYX2HHoQ/25NcrLTZBuNAAo/AsD9lnbitYMqkoNH1oLw==@kvack.org
X-Gm-Message-State: AOJu0Yy08Y4aC/FRPb33L103uZgX1L+5aga88EntmBPMUZE2RRdS8AII
	xThp82smYkXMIIa/LzKZ1YWTScmE5j2Ki+X9xj3r2uhhDZiugArLeW+r3aT5Fw9EqHCJvRcAZr5
	6yVCX6SArhsJ4DgkApPp94HHeC48QiH2B3f9uoVAWRN76iVC2HoYu
X-Gm-Gg: ASbGnctXECxDFU0H77klt6ySv+ok3f4qCLwhzwqpt5ljgnbROK8BOnWbi2XSEB0SJRR
	R8M9gFRAuWVy23Y5hvkwJVilcMR0hlWzKSObhMqCu+X4ENjpQmTg658Ek1C5y/E3YDN9ztD/7HS
	Hq83wsaHoyp6I9ZqPT3T0O/h2k04qWD4m0m6of5haD2ZPpZqSisVsE1EjFlBi4rJcgETOnoacs0
	VijvUjboqDt4nzZEGC82tWR00q/2Nx+xplYVqmRG+l/U6dZhjekUpVaDwJVzbDAg3kKtzesTdzr
	n2Y4BHBnyhY2uMomMU+Lt8mYsJgxwBouW/nfqvjZXCUtrlQqA8u+LSLBg3TN/04K5au/PFUY+/7
	bpTxM+kcIkqOdV6j6U4iiCeT5NnkCyy1CA6hMvnqASeMUcBngJbaB42TDZxYvOpUN
X-Received: by 2002:a05:6000:40de:b0:3a4:e7d3:bd9c with SMTP id ffacd0b85a97d-3b900b4d2f8mr1814273f8f.17.1754641320144;
        Fri, 08 Aug 2025 01:22:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEG+1+z04MT4xAJEOP1A95xJRXKBLxpjZfGOz86i2ZXSuEMm1GH6Dnop2f24Zu0tNAkaU5Mow==
X-Received: by 2002:a05:6000:40de:b0:3a4:e7d3:bd9c with SMTP id ffacd0b85a97d-3b900b4d2f8mr1814221f8f.17.1754641319358;
        Fri, 08 Aug 2025 01:21:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:900:2e1e:d717:2543:c4d6? (p200300d82f2509002e1ed7172543c4d6.dip0.t-ipconnect.de. [2003:d8:2f25:900:2e1e:d717:2543:c4d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e58554f2sm123323195e9.12.2025.08.08.01.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 01:21:58 -0700 (PDT)
Message-ID: <864f2ef6-51bd-42f3-9988-16b5e94f05d9@redhat.com>
Date: Fri, 8 Aug 2025 10:21:57 +0200
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
 <c5567040-6f1b-46d1-890e-7dc6b0b46703@redhat.com>
 <156267ef-f834-4bea-9dc0-c8ad32d066b0@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <156267ef-f834-4bea-9dc0-c8ad32d066b0@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QiFvh8JMSbmP-lWRnGFt7Y3mdiNPEX924Z1GesbgLxw_1754641320
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u8thhbdr1ymuwoxgpnq9e8kbw4r3x6wq
X-Rspam-User: 
X-Rspamd-Queue-Id: 834C1160011
X-Rspamd-Server: rspam02
X-HE-Tag: 1754641330-661635
X-HE-Meta: U2FsdGVkX1/jGGWoTbxc6BZZ0KQ4JbNkX04Tslh+WHmcSqyeBzg4OETcNLqSosm9vWJvhYogR7xNp3Ja4w2omNuXafcqveo/SSRf6ZKSZrxrAgeHaDCH+GZtcE6vo2A21OFtpa2gKbRVUOBeEBdvLcBapC/onOw8T7lwGBt+InKST8X4+/GwoOw32jSCXSyNa3D9JSN2bYc93KeK9K1KopJedTf2811jZD1ybg6vVwVNSwDoet8/4dKHxQKaYOT9xvYxxIceKkSugzzoQDycYci88I/KdQ1IGHxoJ8dJH6OUv30NxmVDO3zLOwR/sHe4vi8QWjX8UIbNpCrUIQAq3k352GwIkkuvCopb+jNcnGuDjN1bffxiBGyTHTlTukLWONfCik3sYBq7IUAj8sBJ7hI6l/WFiru/LVi3ABKykeS4nefkcHq2jA75TJAi8vgVydyqar9zNRAp/bK8RJV6EgpS4aiXTAQ+h32WvKdHsGs4AuquPd1Mg8lcyB2xu6Fj22VnlieTraJs0AW1pE/LNQblLeZKj4R2SrtarNVojxmeUDuxLYOqt3RRXe4MRkFvyxapJMKM0KKOM6jEVAZfcWBQhltUOk68TMKeyNVlKzRlzAyDKblMIOuo0/F0dNa0ks/1CPP71IXDG8UpTOf6QxhmgHgHNg6wP+UYuI4FsJADv1c70Aezhb4lpMyYO0hvKXygEef8/9m/pB/F8+M69O1MveK9HLLTSjNSR8YkEVLfm15EItNr7jlVqJ7TSYFoz97nlO3uXkpihD99u6eCA/jdLejowcXUhVKFqoFYeJUC0FP0baJkwPEyp/qe2hwtu+j/ZL80hTKYfIHe9GFfVz92WluCiZWHaIm+YbHr9WdGlNUs6kZQ0hHNsDPRiG+x1RQMxeAVS3yFN+C5F2EvZRIBPbpCYzPvcFZO/4pCBX2qd9iU+TNnHs82jQPuzlrn0ZJ2NSnhGJJoDP1/iLg
 yPpBadD+
 dr0WozU9E1tjBsrg65zeCYOxE6ahqmC6DwgJpJs2VRlkSh/WOT0dLvosOEFmHZ0C2ug0FkZIgH8Ezj2x6J5FkuVtsT2DHSd8OA95bhu2Qe4daGaFX0IlSH4/tlJDaedTM4fy97hk+Ewh9e7tH4d/j/uhrAEOfKC3XeV+XGl6+irG1G1OksY71dm7FRyFBSO51zA7l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 13:13, Jinjiang Tu wrote:
> 
> 在 2025/8/6 20:41, David Hildenbrand 写道:
>> On 06.08.25 05:24, Jinjiang Tu wrote:
>>>
>>> 在 2025/8/6 11:05, Miaohe Lin 写道:
>>>> On 2025/8/6 10:05, Jinjiang Tu wrote:
>>>>> When memory_failure() is called for a already hwpoisoned pfn,
>>>>> kill_accessing_process() will be called to kill current task. 
>>>>> However, if
>>>> Thanks for your patch.
>>>>
>>>>> the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will 
>>>>> skip
>>>>> the vma in walk_page_test() and return 0.
>>>>>
>>>>> Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to 
>>>>> processes
>>>>> with recovered clean pages"), kill_accessing_process() will return 
>>>>> EFAULT.
>>>> I'm not sure but pfn_to_online_page should return NULL for VM_PFNMAP 
>>>> pages?
>>>> So memory_failure_dev_pagemap should handle these pages?
>>>
>>> We could call remap_pfn_range() for those pfns with struct page. 
>>> IIUC, VM_PFNMAP
>>> means we should assume the pfn doesn't have struct page, but it can 
>>> have.
>>>
>>>>> For x86, the current task will be killed in kill_me_maybe().
>>>>>
>>>>> However, after this commit, kill_accessing_process() simplies 
>>>>> return 0,
>>>>> that means UCE is handled properly, but it doesn't actually. In 
>>>>> such case,
>>>>> the user task will trigger UCE infinitely.
>>>> Did you ever trigger this loop?
>>>
>>> Yes. Our test is as follow steps:
>>> 1) create a user task allocates a clean anonymous page, wihout 
>>> accessing it.
>>> 2) use einj to inject UCE for the page
>>> 3) create task devmem to use /dev/mem to map the pfn and keep 
>>> accessing it.
>>
>> What is the use case for that? It sounds extremely questionable.
>>
> This case is only for test, and is strange indeed.
> 
> But considering another case, a driver may map same RAM pfn to several processes with remap_pfn_range().
> If the first task triggers UCE when accessing the pfn, the task will be killed. But the other tasks couldn't be killed
> and triggers UCE infinitely.

Yes, the "anon page" example is confusing though. We really just want to 
test here if the PFN is mapped. And I would agree that your patch is 
correct in that case.

For memory poisoning handling you really need a "struct page". 
struct-less memory is only handled in special ways for DAX (see 
pfn_to_online_page() logic in memory_failure()).

So what you describe here really only works when a process uses 
remap_pfn_range() to VM_PFNMAP a struct-page-backed PFN.


Likely your patch description should be:

"
mm/memory-failure: fix infinite UCE for VM_PFNMAP'ed page

When memory_failure() is called for an already hardware poisoned page,
kill_accessing_process() will conditionally send a SIGBUS to the current 
(triggering) process if it still maps the page.

However, in case the page is not ordinarily mapped, but was mapped 
through remap_pfn_range(), kill_accessing_process() would not identify 
it as mapped even though hwpoison_pte_range() would be prepared to 
handle it, because walk_page_range() will skip VM_PFNMAP as default in 
walk_page_test().

walk_page_range() will return 0, assuming "not mapped" and the SIGBUS 
will be skipped. In this case, the user task will trigger UCE infinitely 
because it will not receive a SIGBUS on access and simply retry.


Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to 
processes with recovered clean pages"), kill_accessing_process() would 
return EFAULT in that case, and on x86, the current task would be killed 
in kill_me_maybe().

Let's fix it by adding our custom .test_walk callback that will also
process VM_PFNMAP VMAs.
"

-- 
Cheers,

David / dhildenb


