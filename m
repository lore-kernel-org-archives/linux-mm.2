Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E69BDCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D2448E000E; Thu,  2 Oct 2025 03:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483098E0002; Thu,  2 Oct 2025 03:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34AAB8E000E; Thu,  2 Oct 2025 03:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D98A8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:56:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DAE51140372
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:56:58 +0000 (UTC)
X-FDA: 83952418116.10.D38F4D3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 81E63C000D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:56:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SCxL1rdr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759391816; a=rsa-sha256;
	cv=none;
	b=T+DYw2NpZv5r9WfWT2sg81jL0IvL09bpAhxo+E0qLmDpsjOVIFn7No97bw2gFmmiG109i6
	4uiH7tNdVIwOkB6obYDbfH+6Z5Fo1INa5r0NKfehhYgF4yQTvDoTWp/xjeSKG6EDNACGPm
	DoljyfhQDt4so8jyqn5M4gg7Z+belwE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SCxL1rdr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759391816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBw9R63HQvtuDzJNQ+NS4BV/i6L7vKHUx/j4Gcb/+Dg=;
	b=lDxWdkH0eY2MJX1XWHvc8DX2TNGLv4EWq/YYZWjMAOjgrN64PHB4IuXRB6g1BPiUQMYBVL
	drIsjlG7AaBIOdYH1MUKZ7VOJ0hGbY7AtEkmDKoCg0tSDA5eWWH7c9fWjLdpzcLCXk54yg
	mkXMLUfwaQDkm5/pZqOD2q9eNiBL8WY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759391815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eBw9R63HQvtuDzJNQ+NS4BV/i6L7vKHUx/j4Gcb/+Dg=;
	b=SCxL1rdrPyVbOlDvWtT7l7VYbQozS0TBN3wDXWABTJ7Sey3Ev6uuR3RsW7Q6IBnpmvJrDl
	pnd+gpqti69Azpto97iZMtMPEDWTPm2S4hFpINosu4N+am5ZKQNTssKNZjjaPZLjUl8UwL
	jGUMEtr01hRPmCgDWjFip39lNf4UvoU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-d78V4PWYP2Kyi_p1R9bNLA-1; Thu, 02 Oct 2025 03:56:54 -0400
X-MC-Unique: d78V4PWYP2Kyi_p1R9bNLA-1
X-Mimecast-MFC-AGG-ID: d78V4PWYP2Kyi_p1R9bNLA_1759391813
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-401dbafbcfaso427763f8f.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:56:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759391813; x=1759996613;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eBw9R63HQvtuDzJNQ+NS4BV/i6L7vKHUx/j4Gcb/+Dg=;
        b=V/lkXAVwRnUEZNCV6oJ3qtoxcHx3I6IdfLR+8O1CcfOSKgwGv7VKEp8Lj1wPXQwFC0
         VfQg/+rCqLFisvkPPmQ1gCSI0YhE2eeqSvT7f+mV9vwDq8bDrYL7Qty8uq2oN88BCQ/y
         ywyPRY72qm/20XahApC47EakCJniU/VH4ZEaMHyr5CUE9OqgEJ/Xh7xjM4F0CbnnkbBf
         6ORnJ8TajVCo//RrN4deem1qaDAh9HImUKtn2KncJPdF/LG3rd9Dx+l1xszkSlTyRc85
         OnfTRHTN21O/GDWBluqxxteB8qVu5RNbB1P8+s65UzFoQRDo+FQH4BICw+t5FCqJtRbY
         pmpQ==
X-Gm-Message-State: AOJu0YzMyx3mhKdtEM1ODVo1zsG2uHU1h+k/z0n4PPBLxrgzBwvB/sO/
	H+2g98PfpYOlbARkRJ+iS8+R/IwHWhd/pS1J2vcyLq9rbfzG9Ooe1O1nmfLbEZH1prd8kcO1ALz
	z6WxcY1YlVAh+pUArzfTO8nKhLKdTjvOl/mJ0XoLxuj0aRY5cmOfz
X-Gm-Gg: ASbGncvr64wVFmU7iw8Bv+4GZeezaRWuSsu/IdDNRm+DV11tqIAOZvsUsQoYLddKDL9
	8gmmQVRK6Th95QifhqOiShtVcu5yIEO7GU9kVkulR8mjWAVqjU0VYjPy8E8vSszMb9iHxkGH1T8
	amQm99JyC+anFFUjFqzFrLUsV+5URiTNoqJDzkICCoc5vk5PtP6SU2NmhiP/BYc20JwN5qakc7K
	7xKolHzB+yO6U2+CWbCk/b4QwbX2aKUK68Nzgx171lWqodRwLIB4wE3dEmsDAZryXAuVNFfs6w8
	vfXL0aCTYM4RHAqJF98/XsaRV4/rYtLHr10aYn84h2ukNjPYQ+NuhB+3RdbLCMaQvxX//xkfO4P
	9bryQjU1x
X-Received: by 2002:a05:6000:25c6:b0:3fd:bf1d:15ac with SMTP id ffacd0b85a97d-425577f3639mr5163932f8f.20.1759391813013;
        Thu, 02 Oct 2025 00:56:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEy1LI9WCACRzX9d3vk7wHRobkW9kOSrqZfjn7Fu1TDXxYiymF38310eNLF2WkIE6TT8I5AHA==
X-Received: by 2002:a05:6000:25c6:b0:3fd:bf1d:15ac with SMTP id ffacd0b85a97d-425577f3639mr5163916f8f.20.1759391812625;
        Thu, 02 Oct 2025 00:56:52 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f01a0sm2446294f8f.48.2025.10.02.00.56.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 00:56:52 -0700 (PDT)
Message-ID: <5589e161-653e-46f2-bc10-514158ccb1e9@redhat.com>
Date: Thu, 2 Oct 2025 09:56:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: always call rmap_walk() on locked folios
From: David Hildenbrand <david@redhat.com>
To: Lokesh Gidra <lokeshgidra@google.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com,
 jannh@google.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>,
 SeongJae Park <sj@kernel.org>
References: <20250923071019.775806-1-lokeshgidra@google.com>
 <20250923071019.775806-2-lokeshgidra@google.com>
 <61880ecc-7618-4688-af84-02f31e058aea@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <61880ecc-7618-4688-af84-02f31e058aea@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qEC9ZM8XqIvbtzF4IWjTGDoFj7KH2EeYq3xj6sL-3KI_1759391813
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 81E63C000D
X-Stat-Signature: nykzgn4uf66i3ebfx34choth15ey1max
X-Rspam-User: 
X-HE-Tag: 1759391816-408596
X-HE-Meta: U2FsdGVkX19y6k9u+41zEE6ejX9hEQi3618Skh/vP70OU0LPve328Y4Mpmng9woAEmhwlI1qOWg52C87hztG5eimZJis2VTp357A/jFkRN17SzPx6DaSHMjI+IJOjcx/FflMjVkXKKbffkz1/BA4KJrGZUqYUCACtfiuSSbC0mv4d3HfKFcixqMYK/3ZDjbfkVgr7rOb2Uw+i76oPBdJ4eW5PrO+oqsCBHwcVbNuBiCCOjRI5mNHBVLzMrTV2bhaJJxZ38O0x/VpoXRJtiouCCiYpjHNvkCaZOzwYMUO8AH68B3T1P7SzzmLGcHYPipmTmzaLw8Su3IbciVVQUyhj/iuSnt1mXa+XYhAA/GE9ggaA7Jw/GeK9giUltvevrQoPeyYr+uDl7SOEZHqlyVrdIE62bU8X6uO8ZTKEC8HtXWBOFVjZowbtHGbZ9Li+q7WIcT6dPPiqHi38YjjBd6SNOiyf+jwn2SKSFto0Wic38YT8+Iq8rlMNLnkMWcn//241fXyFuWwOv+7cAbNpsNv44pES2f/WGl+IqOruazhtwsAFuUBGbYPHm1eYzVttwC/PG7kaLgTTFfDyo7nNCV47HvcRmj8ReBwbxMpPuMFgUAazURD+CUKorXBRJ/JWGJ80tVtSzBlCtrcBtbpHtm73nLEuJaaGdxXTlTasKky+Ag/kEEcECYB0tj3RMPZETFXfD/OCi3MC1Kjj+ly8xNAkp60VepDCQS91x+PCVs+YoNemSqlZRc+Ggs9p7fG/tVUSbp9Ieu7VR5QHxJIWFb1rYQs6qOvm4Z5JpdGMKJYvy4rM+y6rfxviDE9Dvo+D3QQzEV2umlw48PdC6H9JVDztLVxdp5Y609v/ffOo7os7WYPiZrd2bTuDLHIk3tIFYjkJ6G7LWmgZWX+oP+kIXQgWhdMy14GI3z421ej/8NT7tRJFum/kXCA+ODBcS4s9P4K/Sbg93usIpiHz4ReCtG
 NXIYX/MH
 wXhEdr5SSshc2+s99qk8sz4OYaZXPzJWjfaHOaEyQk3CAhmcuUl7HiZ+LQ466L8e2JOPaX1EJVIJVkWAe7NoO83JxFJIQIxA6DrWKYe7Dvr8P8iUvnR4Ib8gyhqiANWO8psgDsnil+eXkc9GfNxgdC7Ns32N5FgbhS+Nq3gqjnj/pkOZCB5h6j8Opo2Rn6P3ujqJs7RoWj796wxjP6hDnGDGKnsXwKDumhp36x5YrEESLb+FsB/NmkdJ0+jNBWVs/34Ikd4zzD7cn/Bxk9TencV2//W13Q6j1lAQg505obcOSy66OqETx0xPIhr76z4Zn7eybHlnXHvsy0ymqVAPvA9DNJ7YboTscjI8TirHzpYYorquSuNg63OKlttB14KeR5jHrFt9KzfkxRz9VTB+WOM22NE/5cNBfy7M8gHyV4GUdfzs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>    
>>    static ssize_t page_idle_bitmap_read(struct file *file, struct kobject *kobj,
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 0bc7cf8b7359..fd9f18670440 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -489,17 +489,15 @@ void __init anon_vma_init(void)
>>     * if there is a mapcount, we can dereference the anon_vma after observing
>>     * those.
>>     *
>> - * NOTE: the caller should normally hold folio lock when calling this.  If
>> - * not, the caller needs to double check the anon_vma didn't change after
>> - * taking the anon_vma lock for either read or write (UFFDIO_MOVE can modify it
>> - * concurrently without folio lock protection). See folio_lock_anon_vma_read()
>> - * which has already covered that, and comment above remap_pages().
>> + * NOTE: the caller should hold folio lock when calling this.
>>     */
>>    struct anon_vma *folio_get_anon_vma(const struct folio *folio)
>>    {
>>    	struct anon_vma *anon_vma = NULL;
>>    	unsigned long anon_mapping;
>>    
>> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>> +
> 
> As raised in v1, I am not sure about device-private dax folios that are
> anonymous where we could end up here through
> memory_failure_dev_pagemap() and not having the folio locked.

As discussed in the v1 thread, we should be bailing out for 
device_private folios earlier, and IIUC, these are the only ones that 
can be anon. Likely there is still something shaky with anon folios 
earlier on that path, but that's not related to this series.

So let's see if this patch will reveal any unexpected surprises

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


