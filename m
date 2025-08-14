Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E20CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 06:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919639000F3; Thu, 14 Aug 2025 02:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89BD5900088; Thu, 14 Aug 2025 02:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744529000F3; Thu, 14 Aug 2025 02:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7EC900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:40:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F55583144
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:40:36 +0000 (UTC)
X-FDA: 83774414472.25.208589C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 86D3E16000F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:40:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gsugp3Tj;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755153633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=du3zfsORdvVjs9q/P+9kw8vHH6MGBwUxinGwAKW+wLI=;
	b=WoFcVkHkLx6vr+aFz8TpatFZWxlfjmtrN8BSR1wOB/wkZyNaAKSWGyyKZoAv7nSSRrEMdj
	keEOxavLXLlFmfUAb6JLh4qZImiw3070dLi2sBzHLowMhjMsYvSm+0RXSs4cRJFTEjLT8T
	6WFN4pDqLbL47VIBLYTqgVLhISHIedU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gsugp3Tj;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755153633; a=rsa-sha256;
	cv=none;
	b=oGcjwdXWbmT7xTcwo4ubj2fNjfs1HBM1zDmkophDriPw4ixJ6rDooclv2IERmecUW3qqpc
	Mm0VUECnRrsE+vF0jD2vIsNbU4iecsY6WmOe/QLtoIHkCQjGeDvqcXLN7OoNoBXgRrcth+
	VPENbp5gGI+pCxVuM8w60vJF/jmAyCQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755153632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=du3zfsORdvVjs9q/P+9kw8vHH6MGBwUxinGwAKW+wLI=;
	b=Gsugp3Tjhwz1eGsJZFjNfaaqdjJG2haL3Nhe7oJJ2PoiP/U8HiutN7FNIYvN14tLa79Sev
	DZm4W5bBUAnjCvV30VDGy5TGuVfvX1BqKc/ueqwEtZ1UAkSUDFSuRks0GhCNa4MOtRxRWL
	SCA1i1u7qjjRa5t4llTIT3qYOtWAbXo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-KGTmpYevMy-JIQ59Wjci4g-1; Thu, 14 Aug 2025 02:40:30 -0400
X-MC-Unique: KGTmpYevMy-JIQ59Wjci4g-1
X-Mimecast-MFC-AGG-ID: KGTmpYevMy-JIQ59Wjci4g_1755153629
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9e418aab7so224255f8f.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:40:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755153629; x=1755758429;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=du3zfsORdvVjs9q/P+9kw8vHH6MGBwUxinGwAKW+wLI=;
        b=hdLk039bfKD536JfH+pYRfA/gppcb2QIqt5Nw3MjwiOI74yBpIRuYv0bpqVbFIPveR
         mWue2O6R6W38o6x2jPj/c20LgivAssoDY2anCjj/Gymgrh4GbUm+MB8BD37Qyh3zsKNw
         iplxCSlfA2lqurLUHFlr7j5KliTH7uq9JqiIrO4AKS4S+WOJ+7WE/wmPVpUiCmuW8KQJ
         oX5gp0x6UgDXFOmMheVsvOfLcIwN690ZOEPYgQjdocYAAWE2yeGtso6caeTiyoczPRQS
         o+XlyKVOADj2UJ3igGYDQ74MflyZSmLyQR+iux/hf/bQcnyAB+SmKH36n3oAgMEhjHBE
         Ruqg==
X-Forwarded-Encrypted: i=1; AJvYcCVg+yV8x4kZ4CHqFuHTL10iSQ8GM2s7dvMaFgiJAEZB0X5Bhj2L8nkzRILSl5P5WkGYmpSWBfhEuw==@kvack.org
X-Gm-Message-State: AOJu0YwbYYGtutAro4Fn0Ng6GF7Ihig95PNa6KDwI/AHv44pD+2ozLRl
	BTJMlxxcavTFkE7K2kroJnUPqwlxRJX3kUC51Ffdcz5WYwp9cjrdKL+Px53SaRPDyUbipqdPPdG
	+Jl0mw12m35L0/NKvlbqcahKfBEaqJ3wPJhP2EK3BlNR+TAmpGoVe
X-Gm-Gg: ASbGncu+Z4ZuUPqBOQryYK3+KDC6UGxvrmyqgM98Gvk9yZSgLJLzE7uAAEnWmMP60YI
	SQ+x8E1ehYT5VDJhxONu8gzQzm/PN+62aeXpvw+8kKMp8R5+aSTWt5v0/1ZnkpR+8EU6BK3IFTv
	rMbW/r593Xu1EhGoc8e08nGrybLcJHiPn0QWZGa+r3J4JYBAciDSbfEM637Zn0CLQ6fxzU5R0v2
	j4jhSbejUEYLEwsDCFjAMEDVgelB0up2MRMYchKfDDxAh/A6V8dtu5OGyINGuyKpcw3X1NDaeY3
	OgJaf1N4eg65u9uEbD1wfjQ7/N3Ad+uoSClhNPoL4th8wDETukk8Kf6UhbnAU5d1bd8Us13szOu
	1cwwdzfkOYUC8z+qETGx6l4v2SLr+GJiHjc1cVx7HQePS4H5W7Pi8/xRePE0NYNg/vfM=
X-Received: by 2002:a05:6000:220b:b0:3a4:e841:b236 with SMTP id ffacd0b85a97d-3b9edf934a6mr1553037f8f.33.1755153629282;
        Wed, 13 Aug 2025 23:40:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEuzHOhmRMBolwYD3ba0HOXKl2gUhu4r2blnmeUTx+XZ6xs0oqA7j73MqUnp9DNH4unTfJvA==
X-Received: by 2002:a05:6000:220b:b0:3a4:e841:b236 with SMTP id ffacd0b85a97d-3b9edf934a6mr1553015f8f.33.1755153628813;
        Wed, 13 Aug 2025 23:40:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3e00:9fca:7d89:a265:56f3? (p200300d82f443e009fca7d89a26556f3.dip0.t-ipconnect.de. [2003:d8:2f44:3e00:9fca:7d89:a265:56f3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac036sm49649765f8f.15.2025.08.13.23.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 23:40:28 -0700 (PDT)
Message-ID: <871ed36d-796c-46ae-a522-89ce9a0fb5b1@redhat.com>
Date: Thu, 14 Aug 2025 08:40:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: fix infinite UCE for VM_PFNMAP'ed
 page
To: Miaohe Lin <linmiaohe@huawei.com>, Jinjiang Tu <tujinjiang@huawei.com>
Cc: wangkefeng.wang@huawei.com, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, xueshuai@linux.alibaba.com, ziy@nvidia.com,
 osalvador@suse.de, linux-mm@kvack.org
References: <20250811043323.899130-1-tujinjiang@huawei.com>
 <c39474a9-31b2-7df8-8ce8-229f706b05de@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c39474a9-31b2-7df8-8ce8-229f706b05de@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7M-4Radm76yFYdmbpXf-hvVIqmRWGfmzHMo1TUOmXRA_1755153629
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 86D3E16000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8zjkfe3fngjnida49tak8638msaatg8k
X-HE-Tag: 1755153633-585832
X-HE-Meta: U2FsdGVkX19qziVT4UKiCNfidMzZA46Zh7BzlmzCXQI62T/frTNgc4xdnjlTD16VW5iax9nOyYDHP0OkTmAo0ksFuYFG/AzjPcw8KKp+tr3fdem2xMGQJKySKZoGqDnnDNa6ogivdltU9OIwPWX6WfaXUqIspA5g8cr+8FEJ/SvAQrhqaWTx2yLEeyvTp+Bru/jvSwadYGhcnAbPuSSnpVuYFXeLmMXXXZi3ISPcNCkhI2o6NLbTjeeEdtZP5KptY4Q7C8raq5H/66Sq7W6156wgmj4/J6S7Y9N92VoxmJjnhFd/ZxDzQgf9DY4Ke81BZO5HgIOd/WudJQ/BETs/3O87VY0F5sJrwaC1vb26ZTM3tpKyIT0aqmQa8q/v+KNS8WV02HNWFWgryM+OQigeAAmdbbglL+weEEeW94SK4GdFTPhaImnGIuiccIhh1ZbrpE5UE8xHi2AMkbt4ne+zpSRQz3U/4MPyytEeb0PAzxhI3jPNxmygYYAe4krdMxhCtnd3CLsrX39b6yQXHW0JHNXKUUv7PKgwZ5+QIPBLyaKIQOqj/SWjA15A55CAYLGkNmeafBawGhWZWnvvEMObT6WEBeIIzrV992E9/7VYlm2lQZaks6P/RuJ901N6DykqAqZCjatpbmhIdbJt1+uuu5MIzd9K9b5V3lH9f3AM+U8IROEtxcqZvB6q1U8MZmhOR+h1QQzt3sJr2Fnpcsr/Oc8x/wkR80ANr/sG8F/xibbFmTRdusZIFDmu/M4l3HBHjMDAy5nPNOQTiQsxUVWcmZMCIzu4Q5jJE2OEz6rDUTvu4guV1ypL69JZwphPiTOM2/e9DZJapCTuWO63ekSsKJ/VxemNegvuwgHEGrNTUDqKRHYAk2ZjRgyQQIXB66RWymFG6ZDFXItbdPNPf23fNEqOw09Ctee061s6tMj7eLdilXPMZNbBhktmtLUZYCe8hxNbBJvHnFWnLZjGSFD
 1A1g6JiU
 lWUVMmFYCdnq/KO41MjnJgRiaf5p/xMj9/SK1/UuHPkqutXXWOTbxKbK4+iV89oiAtBMSGb0A/MC4FUpdp15k6zrK98LtJqStVVz4t8TqCHZWMq4XMI47xGo9fJWZp6aKqDClFuooH6iCG3lSWip7eJ+CknP8YZWlh2iLfl9iZV0PHDOhWTLoOxn1XT1ITX/BElv5Sz/+8kZn6jJkTZ7T10A4qtKMaBP2KRj1p2tnstK28tVGgJ42kgBwOeoPcN5L1jV0oSra+OVHhp5e2aPyq1Z5TQFrRN1NVc/HpdVucHqcgxl5rC6o5MpwqM9/VHDJz7oCIT1O/9taVs0VRGVD74q5JDXHqa+WZqU5An0NgfgtMum8dN4uZQVi/qnM+61mUZ3DnDom1ej5PSbcCS7CqEjCWs04GabqdS/dc5mtB9EqtxiFFgp5J1UVQ5fUoU5pWgYSCCnSWa48w3fy34suqxY/+g72yGYvhR3v6VEt4hc6XioRH960aG2QzRUbB13eZ4z3pJZECVq+wF523sJB4UIXw2CVvR+FMyuwKCEHc8D+Kgq/KnXzcEQgmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 04:01, Miaohe Lin wrote:
> On 2025/8/11 12:33, Jinjiang Tu wrote:
>> When memory_failure() is called for a already hwpoisoned pfn backed with
>> struct page, kill_accessing_process() will conditionally send a SIGBUS to
>> the current (triggering) process if it maps the page.
>>
>> However, in case the page is not ordinarily mapped, but was mapped through
>> remap_pfn_range(), kill_accessing_process() wouldn't identify it as mapped
>> even though hwpoison_pte_range() would be prepared to handle it, because
>> walk_page_range() will skip VM_PFNMAP as default in walk_page_test(). As
>> a result, walk_page_range() will return 0, assuming "not mapped" and SIGBUS
>> will be skipped. The user task will trigger UCE infinitely because it will
>> not receive a SIGBUS on access and simply retry.
>>
>> Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
>> with recovered clean pages"), kill_accessing_process() will return EFAULT.
>> For x86, the current task will be killed in kill_me_maybe().
>>
>> To fix it, add .test_walk callback for hwpoison_walk_ops to process
>> VM_PFNMAP VMAs too.
>>
>> Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes with recovered clean pages")
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>> Changelog since v1:
>>   * update patch description, suggested by David Hildenbrand
>>
>>   mm/memory-failure.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index e2e685b971bb..fa6a8f2cdebc 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -853,9 +853,16 @@ static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
>>   #define hwpoison_hugetlb_range	NULL
>>   #endif
>>   
> 
> It might be better to add a comment on why below hwpoison_test_walk is needed.
> It looks somewhat weird as hwpoison_test_walk simply return 0.

Agreed.

/* We also want to consider pages mapped into VM_PFNMAP. */

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


