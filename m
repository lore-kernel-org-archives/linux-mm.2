Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78FC4CAC58F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 07:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5818E0010; Mon, 15 Sep 2025 03:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8CDB8E0001; Mon, 15 Sep 2025 03:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3248E0010; Mon, 15 Sep 2025 03:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6FED8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:57:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 809EA1DF00D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:57:11 +0000 (UTC)
X-FDA: 83890729062.30.238B160
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 385B7180002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:57:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D7MbTvt8;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757923029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1c28EhTL7tG3KqgG16Uo9RE5dwVO0G0af+YuouslNs=;
	b=YcmgxNuEovBkLYd1WKEGkjUnS+BNXrqKD+UBM+Ydk95YZ46LX6LOg56c2SmttNv5xOsJnG
	KNPL1j+9wYRNLNnQpKFWIoOB5WyT77QOoLDHSWm+GLmgXi9ETeePiL3QSttSSMEpcMiJCW
	W1hjtZJEPglRoLvpQwHETxF4gY5oWbs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D7MbTvt8;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757923029; a=rsa-sha256;
	cv=none;
	b=rglfmyU3/yZQiuC9jIX/odQEQJWhQUahsdZ/PM1f6cyT2eZrkluV2Y/smEIz6PCLKtxjGW
	e10Hv17EJ5hb/s7kkC5wMSdbAmP+99Filu3cPJpQ75XrA5gsB3tQ2dP5uuSOVT0hJypOOD
	PBi+GLAswKERPDeY9xplRNn6pMgW20o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757923028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E1c28EhTL7tG3KqgG16Uo9RE5dwVO0G0af+YuouslNs=;
	b=D7MbTvt8ZRgb3H8pDuyMw2a6acWdV531DUDxWHA/JXE4kminvAcUUtQbMytpTbyIrR4IPO
	+yajyO8fOEC9/F+Zmc5MvpyEug5fbJyDjXMP5qRCb0xhZsnjHkXYZr6ixY7b26T6NYa7Oy
	ryFuwlSUuQ67p7gHEx8pKjARIV/0tz8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-8iNWMuspOX29iqY_nllHUA-1; Mon, 15 Sep 2025 03:57:05 -0400
X-MC-Unique: 8iNWMuspOX29iqY_nllHUA-1
X-Mimecast-MFC-AGG-ID: 8iNWMuspOX29iqY_nllHUA_1757923024
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b986a7b8aso28281735e9.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 00:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757923024; x=1758527824;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E1c28EhTL7tG3KqgG16Uo9RE5dwVO0G0af+YuouslNs=;
        b=Y9MzWEdU7MT+ZdaVJEbvCaJHoma+eHZVaUcRnX/ViKoMV9pH7rbV+RF/M9D+iYYMWf
         /qLXc3EVrJ/OYOLdfk3CNNQw/wUqqP4AHXWaAzg+nmIDt8eWoPwD/Ab2BI42PjH/HI5Q
         8BvcCTuBImaDtL6CYwoM99iETsvNnMhmLD6dNTcZd8wYSeZx72EiI4to1ciMfBWjemIv
         lHRS9GXXsV++IYq8MEEx9GbCLDgGLnXfzueAmMzonBVNvABm/jUqNPBf4DYlrXZtaKso
         F8Hdlj7dIevotLaqFYUfWHP+axWQOgD7OCEMmDSr3iLKvIVNs3hiFk8bwF+DnavMeSBj
         dFzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVw9oolWnq5kWswlfsPfs1sbdYVKSWYrFwgs1sRCtZzBHiJRb6n9aIFN+soloAs1oI4oUGnHD4uaA==@kvack.org
X-Gm-Message-State: AOJu0Yx/ofs37c5l4D86fEtm/73HlyCYCAFWEQcbhjQVct7BLFaQSk49
	Xk6kAtlXLBzWxHtvYPRKA/Dk/dgvhhBZVs87BMl5rXzc9sTugDSAmAyrLR0gzQNlezsdaNhrNLH
	C8IlN253Sb4CtyH9+qWGbxv0XLm6uuNoOTgnmuVoGEyoZCwDOh7c+
X-Gm-Gg: ASbGnctn4DSeW0StO33d8njjQu1zcWrQ664HH1Tgd4HIHcKru1hGEbZ3iYaDxOyg5+j
	7sbdO/yOVeBPJBQfJb5CETRryh8tIssULL0mIOiQSX2ZJAzkXsvRkIYLw9uHz5PD2vNJgKS0yYy
	vP/QpynumY/2+AcVIMpQ5Zd4ObFl4TevEM//qmsUHW+/6mpGolJSiGjI3xFCycxFC5p6H3Mm/ZP
	B5cum/Ddx1OIkNBbmOU+OsqWWQnmKRrgj1+ywS66tfJ3zwJdJVQRkLxAqeOHUFtMNt5el1h+wNR
	42GDZsxNhD90Sf30h2vrgErTfhV7vUWpcjYKE7B/3zh8iDEHhw1wVFs3Tp1IIhSOf5rTfqq8813
	KKSm0ZIamNbhM1rcjTLLNlfxTUsLkJw5RkPID/qq9SV2o/EyWQ228pDQmyj/+5ONxuec=
X-Received: by 2002:a05:6000:2389:b0:3e7:535e:986c with SMTP id ffacd0b85a97d-3e7657811f8mr8531021f8f.2.1757923024014;
        Mon, 15 Sep 2025 00:57:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8fcewFR1w4v8718PUAih9PAmU6/SHdNLxzJ6sJguAVJjIFGNHRLiOuWrh4rEGUvfsTBRECQ==
X-Received: by 2002:a05:6000:2389:b0:3e7:535e:986c with SMTP id ffacd0b85a97d-3e7657811f8mr8530990f8f.2.1757923023537;
        Mon, 15 Sep 2025 00:57:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e976b5dfdasm6277318f8f.4.2025.09.15.00.57.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 00:57:03 -0700 (PDT)
Message-ID: <a3ab662e-0b16-49c3-978c-0374fef5afef@redhat.com>
Date: Mon, 15 Sep 2025 09:57:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
To: Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, akpm@linux-foundation.org,
 chengming.zhou@linux.dev, npache@redhat.com, ryan.roberts@arm.com,
 xu.xin16@zte.com.cn, baohua@kernel.org, Liam.Howlett@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
 <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
 <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
 <20250915015722.z4w23d6ralc2y7mk@master>
 <daead4f9-aa50-41bc-901a-8dfbdbd896c5@arm.com>
 <20250915074614.tsezftgt2uks3l5z@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250915074614.tsezftgt2uks3l5z@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AvSZc-ztXJ2veB1Q3D3BVdt8b-VdY-ffYj2aA883yJE_1757923024
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 385B7180002
X-Stat-Signature: 14ahtyfu5toijdjcpo8dgibdcydjwnxf
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757923029-695767
X-HE-Meta: U2FsdGVkX18RQAV+43DkNKe3oN/+BhCuuSVigRo2l3qxeyNGtGrd1dORXqnife5yks/xXuCZLHOYCdn588s/0dU/0FKqGQfxlYK56FmBDMz+gpXNvvLNzIAohDwAIGHh0YxUDUvOoYGKagMU5DJonAf1vEygon5SYZAxFb3odJylLpZc/EYulC5SWy68hjAvllCFYu7LVYT25djjvIN74wrHMHUh5MUwr3Kik6kGrkF4q0B1aZhCS3UF5BvJkJLyJEMhI02tvSn46ZeSsOkQRPE4dG7feNaLuebagrdG/I7z3q/ET9QnjZ1JUhQMTxwn9sLubXufc61FZkkl7GgCRkVQ8VlX97bSfBTizSVU6khJ0jaV1ZudjcsVQByHB0bUJ8zsoe5nJ8awjLTHI51xZXegDYK/8muiRlU3HgMjlZIFO3BAXgxHVUUjqttCXyFkXrka0fAwAjhhdPemCs/ySt3p13AfCPqihk1JW8/Z0OB29rpVtaDAsM6JAJythAodMm7jfCJRpstNWhv4HuuG0nK+LU/k4ih4UBygHRXpwrpwOXnzuUS6qcgHv4YrSi0nBvGl2HmesSJ7bE24rc91qWUOBZ2mcGrXrVSlTg9bleZtqah16diVDa8v7kCIpZffaCHOrxXaDpQEmTvX2Xq9PTmVLzicUhUVIWVPTeHOCj4o5mDAPEkTb3+0TqVxGxOZHzYcSgaV8kGuTRH83iZY7YDX6YRG4qGNsfehEOsTPpFZ21Ij6q4b9Tq7nNrjFEhdskgirvjt4eXSKwSGuoGzO35v6Q9G2mI5kYDWECs+/jNkbcchHMxWBwWwI8l/JFWCY6V43l4zUp9joFa3JyeaB2RjFl+eZPo/JMyZo7wv4/YHPaRHQVF/2YBfGZK1CoT9pudb4LfG0x0jidyXLLhMuCef8FZ2P7AXNCow8rADSMye1rRb0pe8kLhuAcTnHA0maOjS4MIdo3BrfRBQtM9
 aohW5Ll4
 nmkIFd3TriC6DqFWkr0M0RAvF/kMgBHCCc/lMT3UTM8xHdhNGfpbjf7valzRsDONxaX3+xpen+3iIhKpfG4uhlQP8DNPWpytqs7oEb+g2pzy58izHaXGk1nn7YcKPvGp0Y4OHvEET1C7lpbTZfLL7ER2FNoJ54k3LETNTEFizD9u6ngKRG43H+k0Mhq71uJOKnvbpeDpMgmJkwVQ8582iTIfGRmAypC/ylq2GWGOhjMdQGd+kgA+f7stZc/B/jnb+ikrKDM0v7O/yoW24DKql5ard9E86Nm7E118+IVDTYualETqpm7t/580xX1OlM30Zi/AFtSoDxC5723SVy0v/evElQvvKoN5BmrmzP3hzLQlcNuLWI5KotFgMJOJZbk4IwitviTPK9MkOz2GkxyW5v5DeT1pbOF5SF5rdDz8qw2oqRvgBm6MjRsZhBd88jMGQSJU6fMCBuPHCP4lWWEWvDdmUXEx7uZGsomnzNR8QLn/u7sAu3GLirZZAZyK+t/VmsbPMwk4PPd35DK2ztBfQRGiIfn9fYkLfyUZ79yC+6NbpYIXm7+2/1fTfS91KWR3RBBunGCgD+KlYsqk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 09:46, Wei Yang wrote:
> On Mon, Sep 15, 2025 at 09:19:55AM +0530, Dev Jain wrote:
>>
>> On 15/09/25 7:27 am, Wei Yang wrote:
>>> On Sun, Sep 14, 2025 at 12:59:33PM +0530, Dev Jain wrote:
>>>> On 14/09/25 12:33 pm, Lance Yang wrote:
>>>>>
>>>>> On 2025/9/14 14:21, Dev Jain wrote:
>>>>>> On 14/09/25 5:30 am, Wei Yang wrote:
>>>>>>> When using mm_slot in ksm/khugepaged, there is code snip like:
>>>>>>>
>>>>>>>         slot = mm_slot_lookup(mm_slots_hash, mm);
>>>>>>>         mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>>>>>         if (mm_slot && ..) {
>>>>>>>         }
>>>>>>>
>>>>>>> This is only valid when mm_slot is the first element of its wrapper
>>>>>>> structure, otherwise a NULL slot would converted to a mm_slot with
>>>>>>> negative value. And current code thinks it is valid and continue.
>>>>>> Shouldn't you fix the code for the case when you can't find the slot
>>>>>> in the hashtable, i.e slot == NULL? Like, if (!slot) return.
>>>>> Right. For khugepaged specifically, the slot == NULL case in
>>>>> __khugepaged_exit() (only user of mm_slot_lookup) should probably
>>>>> be treated as a kernel BUG for new.
>>>>>
>>>>> But I'm not sure if the same logic applies to KSM ;)
>>>> I haven't seen the KSM analogue, but restricting the position of an element
>>>>
>>>> in a struct to make the code work should imply that the code is wrong in
>>>>
>>>> the first place :)
>>>>
>>> Ok, if so, I think this should be a patch with Fixes tag and cc stable? And it
>>> supposed to be two patches, since it fixes two different commit. Am I right?
>>
>> I don't think this is a fix which needs to be backported, the current code works.
>> What we need is a VM_BUG_ON() or a WARN_ON_ONCE() when slot == NULL, because that
>> just shouldn't happen, and then safely exit.
>>
> 
> You mean sth like this?
> 
> @@ -2940,7 +2940,7 @@ void __ksm_exit(struct mm_struct *mm)
>          spin_lock(&ksm_mmlist_lock);
>          slot = mm_slot_lookup(mm_slots_hash, mm);
>          mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> -       if (mm_slot && ksm_scan.mm_slot != mm_slot) {
> +       if (WARN_ON_ONCE(slot) && ksm_scan.mm_slot != mm_slot) {
>                  if (!mm_slot->rmap_list) {
>                          hash_del(&slot->hash);
>                          list_del(&slot->mm_node);

See my other reply, I think this can happen if mm_slot_alloc() fails.

-- 
Cheers

David / dhildenb


