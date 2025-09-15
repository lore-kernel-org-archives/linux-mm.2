Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A75CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 08:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A28B68E0013; Mon, 15 Sep 2025 04:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF5E8E0001; Mon, 15 Sep 2025 04:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9159A8E0013; Mon, 15 Sep 2025 04:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DE0A8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:27:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 328CB1A0490
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:27:03 +0000 (UTC)
X-FDA: 83890804326.01.CBF6044
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id B054240003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:27:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=azBBD2E8;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757924820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOkOz3WdiNC5bwDlTrZChCE5OeKD1GsZABsLEQ1B1BQ=;
	b=CDlMzg+B0U8vsw9fFjIh6Dc12AexQI1SA9ZTEH9l2Y25hn+7QiTypwNnutRAlkpwR59Mnh
	8JyAqao3AwM9HHhggfvjXAOV/1Zqb6bItIWbHhuKbyqA9votKGDjvxOHgv1XuFyT4nAiPF
	sG/ph0vcPRevaBg8mrEOPY7QP0wjWzU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757924820; a=rsa-sha256;
	cv=none;
	b=aGhXk+7nsgmtvYjbBxNAoSi4B1rJve86NFBGLKMTzbtJ3y+h5F3afJehTkgV8ekYJ6fcXW
	ww3Dy2wDn41/6lSuwJ/sDSDw7CGtoVaPzChxxkZ26H6SE5a5uBafCp35q3MRyxVG31zFQ3
	6NdlsoDPASmnWwOHbnNO0GJpL0Ub2EA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=azBBD2E8;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757924819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DOkOz3WdiNC5bwDlTrZChCE5OeKD1GsZABsLEQ1B1BQ=;
	b=azBBD2E8ImLnJN3hdki3cshyoJqCX1UzkPg5ikl3gp43TPB7afrQT/Rx4zulvuP4z7dvvk
	B6lf2iceQnOIQPBh2KfnOsSMKsK2mFVtmbQmR7UfxpI7W3lfp4ZLka1cOzJea6Vpy/yp5r
	zIorUocH1jOlQakkPObggG0ztTCLrBw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-RO5BcKBbMbGPyK0wycWpQw-1; Mon, 15 Sep 2025 04:26:58 -0400
X-MC-Unique: RO5BcKBbMbGPyK0wycWpQw-1
X-Mimecast-MFC-AGG-ID: RO5BcKBbMbGPyK0wycWpQw_1757924817
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45ceeae0513so24460495e9.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757924817; x=1758529617;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DOkOz3WdiNC5bwDlTrZChCE5OeKD1GsZABsLEQ1B1BQ=;
        b=DFLS5fTewIlX48T9fyFO5NiAQadzpnUtf4fMdbif477kuPveFvixUyN1ITMo2VHSM2
         09fqQNooweUCLYw3FKIwgjdqalz02xRslo3wBvtvmB/NHASIQFfM0M33i1OpALPp4eJ8
         jqRmPSiYYflDK2+ElMqr+CjNrJStfXWtWrImZQZbawOHlNVyPZLJ7gX1A46T9t+65NVb
         OX3ayuVD8AfvGWWXm2/WJjPIHOhKvz3GMS6VysUoOEliMLtEXuZNq6G1kXTwH7F4N27N
         4rO322lRUJwTycFvwgC/n1HbUq3xWFuRrzx6yH6MGP/UvkHLvHcw4bLyY1yg3nvaacNj
         DLLA==
X-Gm-Message-State: AOJu0Yw01fS4N6ttA/VxeJShSKODvMrbhm0xFlP1sk6Awp1u8UkeTXa8
	0c58CxO1Rs15IuZKCP/UNSU3pkUbFaGDx3NugxefJW/JFWKardlvgfAfDW+IVUSHU9FFZ+vxv4j
	44TrZmQXeVLP4ShJ/xe3MeY4pMFTBxf5NW3AnEaiLYiLorfftEl5o
X-Gm-Gg: ASbGnctJNUJd4Osg5xbPYL7/PvHlXyywO4z0K0qd84mxfGMScVRlGwRpLeOYkkgiC7W
	lPtxQ6sV2TLmEvuHSvV7hRxbwGWh31p1uVuYnWQ9nND0k6/Bvhs1qlpEatcU9cdthRwfjVpI5iK
	5JNGyZbYmZKg1bj6+WnN3T/S5b89UIBkIvyERcykdD/5XVZWQVgKrZejnJM4m3HE5Dsn0yV5cbc
	0xhictFOT+oWCDDG9T5El3V0p4s7tfObZjX3ryzT7u7BjWS7WaE0yDA50Fhm+MLIaYNN2MXVL4D
	7i99Zc+dW2mRcJ/MHwugfZy/c/QaBTYj7a0lIVXBdVVMP897PsvWiVzXr/nBfs317WzG+0HNFBb
	we7VY/5C9t3BTMsUYPjrDThy4+Zcu5/zTm2SndnMdZVLxKS4Dn3WhrUnSGZW945qd/bA=
X-Received: by 2002:a05:600c:4685:b0:45d:d56c:4ab5 with SMTP id 5b1f17b1804b1-45f211c9c97mr126496515e9.5.1757924817367;
        Mon, 15 Sep 2025 01:26:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGN1DM7yP8PhfCzjWZ9Dwje6g6p9l3Cy29bqjvWMRINux8uSA0FK773/CqfdwbnoCUo+w9Ykw==
X-Received: by 2002:a05:600c:4685:b0:45d:d56c:4ab5 with SMTP id 5b1f17b1804b1-45f211c9c97mr126496175e9.5.1757924816857;
        Mon, 15 Sep 2025 01:26:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0372aea2sm172099325e9.7.2025.09.15.01.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 01:26:56 -0700 (PDT)
Message-ID: <a5e0fd97-6215-4fb1-983f-6b2daf2f726a@redhat.com>
Date: Mon, 15 Sep 2025 10:26:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
To: Lance Yang <lance.yang@linux.dev>, Dev Jain <dev.jain@arm.com>,
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
 <e40f3eaa-7c94-49ab-bc39-e0e3ed56e163@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <e40f3eaa-7c94-49ab-bc39-e0e3ed56e163@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AO-03RQq8b-qGArOqmfCc6um6k6Bx23G5wrtPzeixcg_1757924817
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4q9h54nnr8pq1j4rbyhi6u66neu6oqda
X-Rspam-User: 
X-Rspamd-Queue-Id: B054240003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757924820-842926
X-HE-Meta: U2FsdGVkX1+75ytJBABu+3TOteqrEBeDnJC3qxJKqjZ6ZGU7XwAqUtm1jTrfHZo1orsyqd6uaxfFi2bOyM72gVUPGGiuZu7Npq4aCQpkwxR/F+lugqQN4h9YCNTOCOqWTBlsX3dgSWpwp7e0vJ5XMr2zrCdiiyGVz75+1mdFUBfFrE/KlOC0liUQPxfWr9huhEDduDSRN/3xPS+a6IlychEfv9gz6RI+Q1SASy6cC0IepNs8N2FdlVCS7Zc9Yh4FST1VZ4kdyQ0J1uSgVJQxIYBhhNtppXReS7HQ6C8VLsH20piYdPmyDY8UsWCn9TniBNUn/JZvfgUMvNXYC7zdoojsB2fYUeQtt3sQ8znVWu5wCkKMG8p2wwAJn25IMU1yJ0j/5M3/+0q6oE2FxgsT3vkVo88IM8BM65/J/MBfCVnF6AWz4Sn4FGszmbzcJLjHlBQAvlzjo6CuE68eGNYTwtlnSkJSaO+XYaXWlg/hESzTYf7asg4UJvfsB3mdhI7RA6DM41601/fIhqXqUnQ38Eg9CPF3ZCR8wXAlydSnfsDPQmJmKvVrXeNWL8CEvx9dwudYa5bJoFmynsIi5tf1eH0WTTWZxTJS6v6dMGPGDOtA+/mGU3uoht0oH8C+VKbLLYRh7MCOca6Qh75rxqtI57JUxNhNSs/UDjqXceb3rgY263gOay5vN0fEvCsKdXBKgWK1DkTE6u/PVNRbc9gF7k3JZ4dxJ1f6sJ0cVcI/ur/tETlckfGEV2nSlxkwUSpeZqWGf/DdsxKkEE7uBa3vFTz81ceJgXFOl927I7iIT90v5h3d2XwJecBHYUY7oBy+JlNEaFG42JyQUW2pJ+ey9HaM9agfGpUWQAVm7nCq3VRY3NusSXXpNwJIjWOyg/3ltzr+OPN2jPUZ4Q7mfyYFbwb9GKmYdVsMJqR5E5HOpngmSRCs9UjYr6N5E19RZPqa2YKze7ieYFFeyUkiFa0
 aIeiIfaw
 8SVg0belpS7MPfOEdO8EtkSXwasFDbUr2ApcyzPK68koCGUxl1hAZWqI4+HdcFpSxBXsJ3ovjvVBQ8EpWEDigXNsERPwBrm7C1XzHYZQ/UhFHI2CkQlYsU4tUV7SGXMyyCKUV3hbD79as1mNZqVn7XMrjiSaglXb8a+x2vv5ZixsT/JTLXBWUYgNAAtSqKE28s3lC9IImW52W+3A4yZYvdcjMv2ZOHBqGi60ly0MDKO8YdEYzXfn/scrVDsjyEPEkbj1tdNnNNqjUUqXqUG0J+XEG/uBBZPoFmOUnn5dHK+5K3dY0E8q4V3vGZ2EGVqRGuvbMGdh3OLRPytLPgvIW+woJ1ezQsIsdG6U8HTrmscmwIq+/99Z1gs5wtppPcMXgvWUwTfTQY9hE3aF057AB4YLTfjyIu/6XzYc2ZZqQ/7/Hr4ZOUH7409H6wenvPbSzrpupkVRF0R+QylhcvwISis6i9OJfFY9zyEM8aIDhcIV6UWuBIChYZqffq9QfgKR1dMfLOicwyeDOLe3LkLQi7+9iR3bE28B+5mp8RmP5DeE7I+MdgdLW3Z0+4jMpYJ6chwfgAhylcK7HqIiin6tWeVzm7GJ+uJxxkX/h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 10:08, Lance Yang wrote:
> 
> 
> On 2025/9/15 15:56, David Hildenbrand wrote:
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
>>>>>>         slot = mm_slot_lookup(mm_slots_hash, mm);
>>>>>>         mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>>>>         if (mm_slot && ..) {
>>>>>>         }
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
>>           spin_lock(&khugepaged_mm_lock);
>>           slot = mm_slot_lookup(mm_slots_hash, mm);
>> -       mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>> -       if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
>> -               hash_del(&slot->hash);
>> -               list_del(&slot->mm_node);
>> -               free = 1;
>> +       if (slot) {
>> +               mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot,
>> slot);
>> +               if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
>> +                       hash_del(&slot->hash);
>> +                       list_del(&slot->mm_node);
>> +                       free = 1;
>> +               }
>>           }
>>           spin_unlock(&khugepaged_mm_lock);
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
> 
> Ah, good catch! We could indeed get NULL in that case ;)
> 
>>
>>
>> It is rather weird to leave the flag set in case mm_slot_alloc() failed ...
> 
> Perhaps the MMF_VM_HUGEPAGE flag should be cleared if mm_slot_alloc() fails?

Clearing might also be nasty with concurrent readers that expect that 
it's setup.

It's all rather nasty here, because we simply swallow allocation errors 
essentially and silently end up not scanning that MM through khugepaged...

-- 
Cheers

David / dhildenb


