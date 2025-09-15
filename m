Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6147CAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 08:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F94B8E0012; Mon, 15 Sep 2025 04:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1088E0001; Mon, 15 Sep 2025 04:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BFA18E0012; Mon, 15 Sep 2025 04:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09E168E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:25:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B013B1DF002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:25:52 +0000 (UTC)
X-FDA: 83890801344.06.12C9B51
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5E2B71A000D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:25:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GfmISfmU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757924750; a=rsa-sha256;
	cv=none;
	b=1TZEm5sl2yt4oulBEvOzQh29IRo6eYU57bDPSTaJl2OHm/ZQw3ivJn8gIwpE8WaQN91lFn
	CXRUjMwBM5qN3LTAUb3daCMK0bN7aya1AEfL01iNzrAUxltFs4v/JSX/y2Q3n6KnOKxlJv
	w+AG5g9C9ObpQ4QDIQk8JI8Y3ZW386E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GfmISfmU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757924750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I2kGV0oZJjfYgnyz162S7DyuGUQTbMuhetRrBY/FaIA=;
	b=vAQrRgxB/YUQTDLq0jjEUS13mUsXJ1UYS7c8TqtRtA9sarYIzLwoTLiSoJrbgbJCr4lzm6
	n7AoTFQIcHeww8Kojjwet0lCqNnTNvPcFpDPpoDuvRezrPvyR+GIbXDe/lSlkApBOtIxLR
	AZo5jxBmjptXRo+/sXfPNhAbtBUs4iQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757924749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I2kGV0oZJjfYgnyz162S7DyuGUQTbMuhetRrBY/FaIA=;
	b=GfmISfmUkWcnDZQmJx2DdXOt+WAWQMGM8jYP9TNeNaEalDxXA+iCgYmIP/agavKawkVoh1
	VA7atNf/wbH8eV67Gjtgo7LKGhOnPWycmmU6ZJOmaB4hIOgMoFUFcfM8JCe5FrYgP0Uv2b
	idGtLVz0h3XQievRhnsnkCnx/LpnaI0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418--uypecJ8PICQlvS-HK_K9A-1; Mon, 15 Sep 2025 04:25:48 -0400
X-MC-Unique: -uypecJ8PICQlvS-HK_K9A-1
X-Mimecast-MFC-AGG-ID: -uypecJ8PICQlvS-HK_K9A_1757924747
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3eaed4aea75so426172f8f.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:25:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757924747; x=1758529547;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I2kGV0oZJjfYgnyz162S7DyuGUQTbMuhetRrBY/FaIA=;
        b=Rjcd/IgTY9zb36xXTk6E6GSFIQVDhzC8yMPx7Y83rXHfGz488QOERztTGeWYLDOzKl
         EFke9+QFei2RRyrQ3WvN1RG5B3nFVyI5jrSVZ4hLCFVJEH8vCU5UvCAUdORChrlff9i0
         2ZDWMMnM0eE9wUMLGV0qTz3+4V5fRYL58Nr8s0OiWgEhxSWfK+vt/0reqWayMFzpj6ht
         gU1WV33Inju4rAxtbaBLLtIahDyv56TeC7yGLnr9hQ1ODaUFhBxR/dKDO5eqKtutdQvC
         CZgj3bZ8dZSXoXZOSURMPdF+yPN1mJ3oHVXL7Js2aLoJ/jdDz1eZO+piCNeIzFJ0U9qA
         C/nA==
X-Gm-Message-State: AOJu0YwpEu7Rh466Uhil2LXB4COGoPnZypdxx3uZZcBHgK6aABN+4awu
	LTYsGaPojaNn9k3jjhnSel5+lSHy7IaAY0S37Mk6yCKQUswjY4M8nZEUaEfc1Q+Q5J9UPbmLtiD
	U31BB+RCm3P1HqNEfRKmOkAGfJl/T4ekKEYE//5cYFj/p2Zx6zEnT
X-Gm-Gg: ASbGncsKetRFE79KOyxWijvC2OTw8PNEfZ9S3ODb3toii/Ane6xM0uZpYfmXGArvCxi
	9hZr0WgdvYBZHBJ36eqpmwbcoQ/7LR2FIt12DaeWAeAmOeBbh5BvAMk0ts9/hJiLdY6255/1u/M
	qGR1JP+Gl3c3qFjTpKsPdsh4wo32gQDmCxp2O9Wb128jh3VW7puX1cz9nczshfQUoi6VN4EztiY
	DWSbbUoC2Ru53C1faJCkKTPhICGVUJYpRBXKgzYWdnlWAFj6AnLjgx4qscxwxRljkuU0ovyES0h
	1JjnUPeW7IueobYEWsXVRg9LM13vo9Mgb2y7T1HCwA0c3fFPCbL6xfe0MDAPjMh/VpxD2EWH00S
	bMlc80bwWRZn0LdNgmI+hCn1CyBr2/9fdp8lr1m1EPhwBVBhPt77Q80uld39d8rIiXHM=
X-Received: by 2002:a05:6000:2d82:b0:3e7:e100:404f with SMTP id ffacd0b85a97d-3e7e100418amr5276502f8f.40.1757924747205;
        Mon, 15 Sep 2025 01:25:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXG4MLDG0XBmBqs6/kohXteHKmdEZHlTYj8fIxTsuJOtiUyQKpO7RBi/7T4YoEacqYF51GSQ==
X-Received: by 2002:a05:6000:2d82:b0:3e7:e100:404f with SMTP id ffacd0b85a97d-3e7e100418amr5276474f8f.40.1757924746725;
        Mon, 15 Sep 2025 01:25:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e8f4d644adsm7899581f8f.52.2025.09.15.01.25.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 01:25:46 -0700 (PDT)
Message-ID: <e0d7d84e-8f4f-4029-987d-22f8da1aeb68@redhat.com>
Date: Mon, 15 Sep 2025 10:25:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
To: Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
 akpm@linux-foundation.org, chengming.zhou@linux.dev, npache@redhat.com,
 ryan.roberts@arm.com, xu.xin16@zte.com.cn, baohua@kernel.org,
 Liam.Howlett@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
 <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
 <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
 <62680957-e9aa-40ad-893d-885bd01e1117@redhat.com>
 <220cb3d6-d095-4656-bede-9fb8624f4e12@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <220cb3d6-d095-4656-bede-9fb8624f4e12@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HSz5g-BpYBKGjvKy6LotleAHBQTJ5qBG8BxedIhAMsQ_1757924747
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E2B71A000D
X-Stat-Signature: rsbjbf8dcr48zdmxr88s9kmiqaf4h3uh
X-Rspam-User: 
X-HE-Tag: 1757924750-118600
X-HE-Meta: U2FsdGVkX19nOc0+p3RKV6FX4cv2zWpx9mTY0bpUxtOTAFTw9/LoS1iatm8BCWKW60A8SnSiNdrIYAjmAcaPndsjF9Z6AA9Omhe47Bizcz1WQvhKESgzowFQzbv4pkrrmZL5PAu/ccgVG2WTIjNiAaqZaigjqubKm18fFANXTpEG37AEaahFUdg/cri3BMHXR6ap1lVLD+Pge62dTYXFb6d3QIc/6XBX/BSDuDRruIPYUSgerNLsgYQ+YujuDL1BUAxhCiz/gheEatKKLPdoUV//6+WPb7okk136gyfWrCk6ocF9OMO0+9G80P6vj7ymkd4fjbQoT56MfSnzSYJB0THjEL1qo1K8Z/xoPDH4Opsg64Vyo661gd5C1IY7g1Wpd2/WGZG4QtU1ba6C9MB+86sbmvgNniELOSt78mWIkecSjzTTj+pNoMdCCFzNELqGmMazUrkbuSvsPZMzyy3sCyEBAwaHGQZxVCQf4CKWo/rpBdctb4zTzgLr4sLOZcym0V445hDrVbtE705AEtQKQBw6vtw4rBh8S7R9VxAP91OlOava35Vqn0hnhWXTDJZf/8qSmK6faBbyfPa9tGuVyymhnbeb3cLKHWDJWs/HD06NHxLcvA/kXstkUxYDHpDRw1lwz8qMSqS8eC4R5dMBbunf7rEvL/MYblzVNH0SgwusSst2cOKWhDECUADH+Hl+rhEnwcEZToWHSYV1ofDm5e12f0ZYeE6uTmEYNjHcgNR78TRiE4kv3vZ7oDQaLMErXo1VK9Ohs/EZ/nn8JAB+udk1B7OVwwFBM/7Un8wRSB+nHOACAg9JxLuWwVOwTYZpKG7NVSwiIO6b5wazm9dtWf729hN2ZGN2rqjwJecbvWXAUMpuUc/zfXtYj2NNIbwBcRn8PTYoYKE11lreRL3g93YlheiLYPSh+jQ/Y4QwCToj2KSqth+5itp9LeEl2xefT6bSfuNVxgjx8lSyE0k
 JWW58x2f
 8Z3mTv5PYFfj/WdcfDAHZu9m0z20OhVBnVAh3N6SXCMhXxGDW9w/aL9mzv9qIvzNLTlgmYeByyFBZGiXa6UjzGuCIHvTDXeyAocBjkyvX12bhSet07jHnVOogqcqZRSNrUDytgMErZmtHzEb1RWqN9uIFjJn47mbiYX4OcWgAMUuFlw2BZjpVIuhfAgGdXjMol56STobvgW8YVFkg8OopBiYx99dPpwjcV6lmZATONk92KJsk3lQD2tnIPgOCFd+kiD/I26VIim82k0KyuJbEBb/wkYDDFgMyjD/jLFRNdQg7QQVuubKtE4Ji2nqHYp5xgMqiRmnpwnAni8h5clt/dnlZqBbADjzt69mHs6DGIMW5lz15BDXfpop3mNcoIFXafprrYruYxCAJNnisKbEKwxkfYUL0thGtpQ3dGIymOjO/+T70sBw07EmlDRR11SLd7e0io7QY/NZzKT5rUCrV9OcWaJoP8mLiyOR44JIvqM7kBF2Q8V76atK3WG2vIEkpTJ6Y5Bakq7W259PxhnzYAtte6jNtiUhQawblG7Q3p+ia2Xum2AbiZrpVvuft3RFpGLyMBxinqxLm43o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 10:11, Dev Jain wrote:
> 
> On 15/09/25 1:26 pm, David Hildenbrand wrote:
>> On 14.09.25 09:29, Dev Jain wrote:
>>>
>>> On 14/09/25 12:33 pm, Lance Yang wrote:
>>>>
>>>>
>>>> On 2025/9/14 14:21, Dev Jain wrote:
>>>>>
>>>>> On 14/09/25 5:30 am, Wei Yang wrote:
>>>>>> When using mm_slot in ksm/khugepaged, there is code snip like:
>>>>>>
>>>>>>         slot = mm_slot_lookup(mm_slots_hash, mm);
>>>>>>         mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>>>>         if (mm_slot && ..) {
>>>>>>         }
>>>>>>
>>>>>> This is only valid when mm_slot is the first element of its wrapper
>>>>>> structure, otherwise a NULL slot would converted to a mm_slot with
>>>>>> negative value. And current code thinks it is valid and continue.
>>>>>
>>>>> Shouldn't you fix the code for the case when you can't find the slot
>>>>> in the hashtable, i.e slot == NULL? Like, if (!slot) return.
>>>>
>>>> Right. For khugepaged specifically, the slot == NULL case in
>>>> __khugepaged_exit() (only user of mm_slot_lookup) should probably
>>>> be treated as a kernel BUG for new.
>>>>
>>>> But I'm not sure if the same logic applies to KSM ;)
>>>
>>> I haven't seen the KSM analogue, but restricting the position of an
>>> element
>>>
>>> in a struct to make the code work should imply that the code is wrong in
>>>
>>> the first place :)
>>
>> I agree. If mm_slot_lookup() returns NULL we just just handle that
>> cleanly like
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 6b40bdfd224c3..70a32d59d7d2f 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -488,11 +488,13 @@ void __khugepaged_exit(struct mm_struct *mm)
>>
>>          spin_lock(&khugepaged_mm_lock);
>>          slot = mm_slot_lookup(mm_slots_hash, mm);
>> -       mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>> -       if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
>> -               hash_del(&slot->hash);
>> -               list_del(&slot->mm_node);
>> -               free = 1;
>> +       if (slot) {
>> +               mm_slot = mm_slot_entry(slot, struct
>> khugepaged_mm_slot, slot);
>> +               if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
>> +                       hash_del(&slot->hash);
>> +                       list_del(&slot->mm_node);
>> +                       free = 1;
>> +               }
>>          }
>>          spin_unlock(&khugepaged_mm_lock);
>>
>>
>> If mm_slot_lookup() is not expected to ever return NULL, then a
>> VM_WARN_ON_ONCE
>> might be sufficient to document that this is guaranteed.
>>
>> IIUC, MMF_VM_HUGEPAGE might be set in __khugepaged_enter() in case
>>
>> (a) test_and_set_bit() succeeds
>>
>> but
>>
>> (b) mm_slot_alloc() fails
>>
>> In that case we could get NULL.
>>
>>
>> It is rather weird to leave the flag set in case mm_slot_alloc()
>> failed ...
> 
> Good spot! We should move the slot allocation line before the test_and_set.

You'll have to handle races differently then, and free the allocated 
mm_slot if the mm_flags_test_and_set fails I guess.

Maybe you'd want an early check if the flag is already set first.

-- 
Cheers

David / dhildenb


