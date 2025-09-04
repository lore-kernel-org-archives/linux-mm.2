Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96238CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC368E000B; Thu,  4 Sep 2025 02:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93FB8E0002; Thu,  4 Sep 2025 02:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5C258E000B; Thu,  4 Sep 2025 02:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B269C8E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:20:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B8CA160A19
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:20:21 +0000 (UTC)
X-FDA: 83850568242.13.4A73500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id CC2C720006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:20:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HwtDmlMZ;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756966819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Kns6hWJsRB3qBZIeHTIjKWtgtYK0b1UK1mqxUChhNw=;
	b=Z5K1IJLjFiDE/d7C6aVUl1ISjyeTsaVM2M5mep17kLALAjHXCa6z5QWmfMKQTqhHTvXY0o
	aCPha+yC8tuKyENYpUyOHaZqpn7bR32B/ZhsenF8B8mME0GeddPtvBbbZDImN4rENu6EZR
	NaOYWqxeb9wxQAKSB3wSb8wT5Q+sqoo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HwtDmlMZ;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756966819; a=rsa-sha256;
	cv=none;
	b=6NuHlgD+1812qUHTtVAvJAmKI2zncAK970VOuX9GRWO4hXcchYdyuKnaKR67N1UbrbngIx
	ZBfHfnrwjkAC/MXT+082smC8ILSO7vj2zBEz/8/kJc/mzykpEw9fvW6LjJShVu+//9CdQd
	iv83nMsU4BlQY8j+oxMQ9KZe7SAU33k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756966818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/Kns6hWJsRB3qBZIeHTIjKWtgtYK0b1UK1mqxUChhNw=;
	b=HwtDmlMZvXJmbNsvcMbM0yUPPpdmvn3mRjk1Km3g9omU1to8JC7Oob/dYeup4ORLl96vXS
	4pY3JbV6nD5Ru0189MqWWFks87oKBmAjOwWLRoPieO6shkdjvv3zWwhc2ymVlNLDv3RVYU
	HP5+8TzhCnyVpQ0WVpZWCCMVyEcutKI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-0lMqjEwSMCy2ply1XF4u6Q-1; Thu, 04 Sep 2025 02:20:14 -0400
X-MC-Unique: 0lMqjEwSMCy2ply1XF4u6Q-1
X-Mimecast-MFC-AGG-ID: 0lMqjEwSMCy2ply1XF4u6Q_1756966813
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45dcfc6558cso3596935e9.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 23:20:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756966813; x=1757571613;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Kns6hWJsRB3qBZIeHTIjKWtgtYK0b1UK1mqxUChhNw=;
        b=uOC5jPknzmRMvXM3+SD9ww6aK8FQWAZAI6bV8o10//BYR77RYRks7Ydp+bzdQVtzSc
         dvoUE3PR6jgRSlg+f7NYTmKdYy3XVB0WN2EUhxrng3nA0GmjryT6VEYGAud/5cTF5ykB
         7OhvZ6mIJD5+vxbILG29DWP6WVN8zXzVtUpgypY0jqrr45ne+p30iBqd6AtytmA9VORQ
         PBY1PnVPjIX9JqHh/6ayVwo6M/y4C5NPx4SPHM6aHiC0Z1o6K/dJjQ515/+GMNLqqNnP
         r0ZD7G1FGXwwCPdOeKYJ2/3hvaFy/micrVP/d4+zGIFxwguy+6Sdr/CQ2F8mTKIhUFC1
         JN0w==
X-Forwarded-Encrypted: i=1; AJvYcCWw9YIjiZRtHMcFir1tLHVSdZYx7KmS43lKCTC3yyyfdoc57ObAyFe+/RlG0vK7MWqzcvz+ilj+fg==@kvack.org
X-Gm-Message-State: AOJu0YxRuzqEpW5UQwcguvq7y395H2WUsM2I7DUTbKgCLIWQrFvMXcor
	M3PuMuD7PNgMl+JIZ0AB3+As2TAa0g3UR/n6LF/vEhS/4x6ZLRYEOUREDZrYZNHnf+nAmE31+R7
	kJTijxfOrVof4BWoIBwzxHqtHsEJ4UUIimqCseG7Isdq8Cze1RubG
X-Gm-Gg: ASbGncu3+KNnV/l7bu6Mt656dYc53dWv4J1ZzNoNV9XdIqlC08bQULacPHGlTc3GH2g
	UZm7YI8ww4poQxiKBOV78PCCY3iyy1GktGuOd3DuSefUcH0sol3d329gLwDYHXvp+hD02E3zstZ
	NIb2d7ZT/8G0RnulWFh2VCkKg9hvFcDqEA+6nUlJ99F+IOiP87xxhi1ehoRlIaGn7VEiHrtqvSB
	bQ+m+s97U/2QXoU3fr2pi70dayzvgftaZg0VNYowRrh1adssIhlelVc1ntRCEerUJA6QDGwOdoz
	WFJMevf0Ki++SLXAyCpU12dE+hJif6WdI4I+UEpCEO4lRnL99Z0jmeHukZMNjIelAimqbz/VCwQ
	qgcgWI8KC6/pd1ls42FlGWwDyrqPl7ZlsYC8GYI+6wbWMjibgDhLBKBlt9GvLhp+0
X-Received: by 2002:a05:600c:a44:b0:45b:7f72:340 with SMTP id 5b1f17b1804b1-45b8557c68cmr152914405e9.25.1756966813453;
        Wed, 03 Sep 2025 23:20:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPd0rXLF1G8Plk44b3e9xT11/wFgwo+l2p4mc4KgQdNa5fplSYWtyLUXyqnxiB/dWXvg4FEw==
X-Received: by 2002:a05:600c:a44:b0:45b:7f72:340 with SMTP id 5b1f17b1804b1-45b8557c68cmr152914155e9.25.1756966813008;
        Wed, 03 Sep 2025 23:20:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b81a9e971sm278712005e9.18.2025.09.03.23.20.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 23:20:12 -0700 (PDT)
Message-ID: <8fbec487-b696-48ea-a449-411ec74ad378@redhat.com>
Date: Thu, 4 Sep 2025 08:20:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] filemap: optimize order0 folio in filemap_map_pages
To: Jinjiang Tu <tujinjiang@huawei.com>, willy@infradead.org,
 akpm@linux-foundation.org, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com
References: <20250903084223.1653192-1-tujinjiang@huawei.com>
 <3c283054-b14e-4f36-966f-78cf3bc0f3af@redhat.com>
 <f5dd70ab-c610-4142-be57-1fa311672b5e@huawei.com>
 <407a9aae-43b9-456b-b626-4eec55909dee@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <407a9aae-43b9-456b-b626-4eec55909dee@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3lhPxBjFNuVxnKoDoSgx73BYxq13raChZbEd7B1CTS4_1756966813
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CC2C720006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: c1ru91385x73ofugs9q69t95hndmjux9
X-HE-Tag: 1756966818-614743
X-HE-Meta: U2FsdGVkX18pcod4aFwkqwQoZxJTn/L6nOZ+XTUyp8AjA8z6SMvasQeIc4QmMQXWab7R0Frc35feF9/JXk4ZSbiBtD27ZZVy1KiskBe2Jkfq9KC7uf0k2cGKjpE5ztCFBMQfXdYeZkOIMAxNUp3UH3HcUWnUckNNOatMEVMICp1JoOhkjbAnwU3yVPibnAuFiPbiFhwV3J2GAXrL4Jz1g3yopVmyWTH0nEi6iQnnyB/ZOan0eNUEd4ZZigmDBfvegqCWl4o5dUaQ2LqN0Lh2O/7y5ek5h3LHog1cldYYLvcTYu98kF0OLEMU64DHdXpJPK1lCzqL6j3XB/xV2GPcAJ0tOuTj/di9LUgxvnJeiGUeI8jFjHbbWx9ZQR1367kUmKoyYGFusJa0CaH7XXkYYO+zrGL8KSBCJ+y93LuuIJwIgS/Hv5Oq1fMxSW+EDtEEVNKTlvDilfwDISgz1oNyy+S+RSOH/RL9cMzRyT0gvd5FGvBzcpB0aN23cUjnlkTedRcmD2S+Qk+RxlmOCLkWRF76/UP1IfGsMifzU9mqvGwn5PhL8ucOzpVIZI/d35S0qT0P2WsDAoBE4BXZcOGXfFy3O8wopgKGsLPR/FMAm0Mx9bOHzcGh8iEI7LmjMqzEGININspBOGioTUl072HaVMcwVO1R1VMgGnWC6e5CabvlSy/X9zouxlwDiY3DjGhZWvn+F81SrQP53hD9Ah/xrFbXLleDXMQlFsjWr3TW9xrPXqthBJrxLl1Qs9Ltx+yexww6wekWc9Pm2GLy9WfZVuvmcds1Z1DUjYSBExWG8mPwxzDF9wN61ydSiqpG1y7oKOy64yUrLLRdtx4vDMrevje9ugTcOoh1kLq9m/dvCazlR1nyYagmRfnK5GAcOkItBQM/xX2fEQVAYeyMqvg3XXMk8Ta4tdMTZtsQAgNJIWk8DOBgCBO14GdXcNXLJLO38ffIFJpKf0DiFvP4EKm
 Ur0ybobC
 Yuv2tI2VMQrUj+It7I5CICeexJZtuxG7gGdbjaTTb7GMWom7OXyGZXmTUaAxj9eQfebkErgfB1Q9b8O9dwihOAqQPWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.09.25 03:06, Jinjiang Tu wrote:
> 
> 在 2025/9/4 9:05, Jinjiang Tu 写道:
>>
>>
>> 在 2025/9/3 17:16, David Hildenbrand 写道:
>>>> +++ b/mm/filemap.c
>>>> @@ -3693,6 +3693,7 @@ static vm_fault_t 
>>>> filemap_map_folio_range(struct vm_fault *vmf,
>>>>       }
>>>>         vmf->pte = old_ptep;
>>>> +    folio_put(folio);
>>>>         return ret;
>>>>   }
>>>> @@ -3705,7 +3706,7 @@ static vm_fault_t 
>>>> filemap_map_order0_folio(struct vm_fault *vmf,
>>>>       struct page *page = &folio->page;
>>>>         if (PageHWPoison(page))
>>>> -        return ret;
>>>> +        goto out;
>>>>         /* See comment of filemap_map_folio_range() */
>>>>       if (!folio_test_workingset(folio))
>>>> @@ -3717,15 +3718,17 @@ static vm_fault_t 
>>>> filemap_map_order0_folio(struct vm_fault *vmf,
>>>>        * the fault-around logic.
>>>>        */
>>>>       if (!pte_none(ptep_get(vmf->pte)))
>>>> -        return ret;
>>>> +        goto out;
>>>>         if (vmf->address == addr)
>>>>           ret = VM_FAULT_NOPAGE;
>>>>         set_pte_range(vmf, folio, page, 1, addr);
>>>>       (*rss)++;
>>>> -    folio_ref_inc(folio);
>>>> +    return ret;
>>>>   +out:
>>>> +    folio_put(folio);
>>>
>>> We can use a folio_ref_dec() here
>>>
>>>     /* Locked folios cannot get truncated. */
>>>     folio_ref_dec(folio);
>>>
>>>>       return ret;
>>>>   }
>>>>   @@ -3785,7 +3788,6 @@ vm_fault_t filemap_map_pages(struct vm_fault 
>>>> *vmf,
>>>>                       nr_pages, &rss, &mmap_miss);
>>>>             folio_unlock(folio);
>>>> -        folio_put(folio);
>>>>       } while ((folio = next_uptodate_folio(&xas, mapping, 
>>>> end_pgoff)) != NULL);
>>>>       add_mm_counter(vma->vm_mm, folio_type, rss);
>>>>       pte_unmap_unlock(vmf->pte, vmf->ptl);
>>>
>>>
>>> I think we can optimize filemap_map_folio_range() as well:
>>>
>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>> index b101405b770ae..d1fcddc72c5f6 100644
>>> --- a/mm/filemap.c
>>> +++ b/mm/filemap.c
>>> @@ -3646,6 +3646,7 @@ static vm_fault_t 
>>> filemap_map_folio_range(struct vm_fault *vmf,
>>>                         unsigned long addr, unsigned int nr_pages,
>>>                         unsigned long *rss, unsigned short *mmap_miss)
>>>  {
>>> +       bool ref_from_caller = true;
>>>         vm_fault_t ret = 0;
>>>         struct page *page = folio_page(folio, start);
>>>         unsigned int count = 0;
>>> @@ -3679,7 +3680,9 @@ static vm_fault_t 
>>> filemap_map_folio_range(struct vm_fault *vmf,
>>>                 if (count) {
>>>                         set_pte_range(vmf, folio, page, count, addr);
>>>                         *rss += count;
>>> -                       folio_ref_add(folio, count);
>>> +                       if (count - ref_from_caller)
>>> +                               folio_ref_add(folio, count - 
>>> ref_from_caller);
>>> +                       ref_from_caller = false;
>>>                         if (in_range(vmf->address, addr, count * 
>>> PAGE_SIZE))
>>>                                 ret = VM_FAULT_NOPAGE;
>>>                 }
>>> @@ -3694,13 +3697,19 @@ static vm_fault_t 
>>> filemap_map_folio_range(struct vm_fault *vmf,
>>>         if (count) {
>>>                 set_pte_range(vmf, folio, page, count, addr);
>>>                 *rss += count;
>>> -               folio_ref_add(folio, count);
>>> +               if (count - ref_from_caller)
>>> +                       folio_ref_add(folio, count - ref_from_caller);
>>> +               ref_from_caller = false;
>>>                 if (in_range(vmf->address, addr, count * PAGE_SIZE))
>>>                         ret = VM_FAULT_NOPAGE;
>>>         }
>>>
>>>         vmf->pte = old_ptep;
>>>
>>> +       if (ref_from_caller)
>>> +               /* Locked folios cannot get truncated. */
>>> +               folio_ref_dec(folio);
>>> +
>>>         return ret;
>>>  }
>>>
>>>
>>> It would save at least a folio_ref_dec(), and in corner cases (only 
>>> map a single page)
>>> also a folio_ref_add().
>>>
>> Maybe We can first count the refcount to add, and only call folio_ref_{add, sub} once before return

I'm not a fan of that, because I'm planning on moving the 
folio_ref_add() before the set_pte_range() so we can minimize the number 
of false positives with our folio_ref_count() != 
folio_expected_ref_count() checks, and I can sanity check when adjusting 
the mapcount that it is always >= refcount.


-- 
Cheers

David / dhildenb


