Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9700CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 243868E0003; Thu, 23 Oct 2025 03:24:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2BC8E0002; Thu, 23 Oct 2025 03:24:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB778E0003; Thu, 23 Oct 2025 03:24:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED9A38E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:24:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F32C12998B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:24:35 +0000 (UTC)
X-FDA: 84028541310.12.06DE63B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1E9E5C0008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:24:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dqojjb2D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761204273; a=rsa-sha256;
	cv=none;
	b=eiBO44MfCk2zRCmlKpXaRRqvSi/0x8dQ7GOTD/7AVbYousSMiP/NzKnEGgcoDex5pCC+DD
	I8TPIQN1M6evF6c6YWF4bwsnfIhSqjvlYv5joCG1wC52SooV+E0lJQtvcF+1dHYwV6yI0J
	0wDC2HdFecLtoPo5UMwPEkODgabdJhw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dqojjb2D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761204273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=At4MrgAP9F7GQPooz+KssPb3r2AaqOOpWbjQGvPMAWQ=;
	b=7EOXTlHuca/iPd8aBm+7nb94Du+T4MiRRH1dCJmA42LGGUoK/6+ftpkuIsTbSLC9U6S9JJ
	ngUAauIWW/8F7MpurKGte1Vd42PYZ8/D1AOtWOrAo7fA4bsWxrrbh5rJ/mmwJS/MK2fsml
	MPJX/ChWjSTWfv3ivrkCP4HaSHZ9rvw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761204272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=At4MrgAP9F7GQPooz+KssPb3r2AaqOOpWbjQGvPMAWQ=;
	b=dqojjb2DnuAZCt76Q/UJRb6fhIVsLrVIkvYyhhqfluMPoUAvOkhs3deY3qpgRyRjqMMPON
	nB2hUHxssrJxA+mktnPjRq/SxCzJIg5k8U6sJC5CXgS5HKDZ45kUzcL9mRQo98FgjJ7Xpn
	IElo7fMBjjsyVTI8WxCOBQqWqVbJsQE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-DCXUaJHNO2qfsVhuIH219Q-1; Thu, 23 Oct 2025 03:24:31 -0400
X-MC-Unique: DCXUaJHNO2qfsVhuIH219Q-1
X-Mimecast-MFC-AGG-ID: DCXUaJHNO2qfsVhuIH219Q_1761204270
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42700160169so222237f8f.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 00:24:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761204270; x=1761809070;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=At4MrgAP9F7GQPooz+KssPb3r2AaqOOpWbjQGvPMAWQ=;
        b=DO5ZAg3WIdgktIeV+B3yy9hk2u4U8mG+kktojm8n48LGbijIADBiBqFiY3ktnXFp88
         SpfWDtpYfJwl6GV+WO+1cmQdr1lZ+2vd1jwUFnbytWCJDNOwO0SbaTL2hTU4OlByBswr
         cP4Z8eMrXt5HMB2jhboRrKNkT/tFmmYMnAS8o8Gk7akhdloZL440QuNjoKmSD5YX6VpO
         HsJemeaL91aam6XRvxNhi5oogXH5eBP9lz6hYnxG3VIoc8jfKhLx7KwBq8b/Gttiq1cA
         yZ8xExIyW2lqpZXdW/YonQ1nVvrIA0tv9yvrv5uTNq0oM7XAu5awsIyvtDcCyaD0bZW6
         YaLw==
X-Forwarded-Encrypted: i=1; AJvYcCV+SjnPHaSRiUZ7+NosUKMkv8jPqcnfDchjuS10paxKXhp7/x3IWJZi+S8Bha6/9FFafFGewQ+O8Q==@kvack.org
X-Gm-Message-State: AOJu0Yzcjp51KCEFjuottqwwETDsuTV+7Hh4hKBqC7BtlwLwz57z95pZ
	KomDRBjzr6He3tTcbHuJIzDEdihAXvCNRXUij5bOfDa+xZPxP7WWv9migjJ45iqTVDHs9nWMPl2
	a+qJ16Pbs4ZEU+1vRbuyd9QDqfV9Zpdxca005XDnppWn8bpYBQ7ig
X-Gm-Gg: ASbGncugrEP5hwQRc5722vXtotLNtmUWHxWbkD6InaSMzSgyk0TxU1hO5gmOqXonX/1
	ujcG4BHpaAf2CJqNDMqrQOOyOkhcreIVDXt0KQeCya3JKAGaDxs3xiLYmc2OqRhOcwJAHlrtI2K
	Vo7lEuMe3t2PBIfzVsJlTbGzg9zm8p555tGdsyFtZqFN0JKhleyL/v/PqygAWfpjLX3eEpOqRVE
	ZTv7QC9MQT2MgMVXELugb4NcaYFnqZvBgGxlb4Hp3UEiTLr1N5XAT78ReOiUgPRhwUZD3Hq83xH
	XSC4GvDrBxwtmseqaIrrzu+VRFf6N7IrTUJ17okk5O63Fs23cqdRRc0FzJDEExD0ObMSRhzX6E1
	B62wzKOQDZJ/YNgbPVaMAO9SHLQtTf2k=
X-Received: by 2002:a05:6000:4202:b0:426:d82f:889e with SMTP id ffacd0b85a97d-42704d74dc8mr17413744f8f.14.1761204269960;
        Thu, 23 Oct 2025 00:24:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBeaZeBjNlT5I0rpSARhRSXau88x2Xc7FXWiFhfLb1011+8VdGMBFcPxLi9mgKNY+vLoBXcQ==
X-Received: by 2002:a05:6000:4202:b0:426:d82f:889e with SMTP id ffacd0b85a97d-42704d74dc8mr17413724f8f.14.1761204269544;
        Thu, 23 Oct 2025 00:24:29 -0700 (PDT)
Received: from [192.168.3.141] (p57a1af76.dip0.t-ipconnect.de. [87.161.175.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898ebf82sm2481947f8f.42.2025.10.23.00.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 00:24:29 -0700 (PDT)
Message-ID: <41f30998-e498-4c33-a4b4-99b9f7339fd7@redhat.com>
Date: Thu, 23 Oct 2025 09:24:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible regression in pin_user_pages_fast() behavior after
 commit 7ac67301e82f ("ext4: enable large folio for regular file")
To: Zhang Yi <yi.zhang@huaweicloud.com>,
 Karol Wachowski <karol.wachowski@linux.intel.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org
References: <ebe38d8f-0b09-47b8-9503-2d8e0585672a@huaweicloud.com>
 <20251020084736.591739-1-karol.wachowski@linux.intel.com>
 <0fec500c-52ea-473d-b276-826c0f4dd76f@huaweicloud.com>
 <43cc7217-93bc-4ee6-99d2-83d9b26eb31a@redhat.com>
 <610d89e2-6970-4924-824b-f27a2424979b@huaweicloud.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <610d89e2-6970-4924-824b-f27a2424979b@huaweicloud.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HCDOVOt1gda92la-9H5Q7DAvbaVEJSFssYjVXoZOmxc_1761204270
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E9E5C0008
X-Stat-Signature: ttg3bm4ef8aobtor6bxjfuhfewryhs5t
X-HE-Tag: 1761204272-751311
X-HE-Meta: U2FsdGVkX18TV/vFvU1JjxoGmhqkaYfkXyUVWZQucbJ1NtYDVlGt/P6U8fnIcQOGBWHLusZjLHeGgQunjxOktd01Ar9kMGis6vVjIzh4pi4TAqLgwUFHSZsAwKch4CRlEwKkexwxkRESWqPBrEgz5p8Se2x1S5ardQOTYhHhcDsrsRz9eNLlhZWwsDog2+QRBvI+7spVUWkjwsej0NXdSFUn+ongo+ORFLcsAKPNgyYEWldH8oy0gFsCY/zxAAHuxOGIU3ALeaWWzY8jhwqQh5hsvxz/yQeDC6FWPHPMJ3AHEVm41fWJIql5CslsOSXvKcf6vrfxQO1v/GpMeso7PB0TLPqHU0v7Iuc8KEtUjDQaXG02X/5o5LNvFfqkqOiwnuPlRqVKpww2n1FXMt4hRacVZpSYWV78AgrXQmUgTexv0FhxzEekjjfC3xW3z8uaoK6r+VnJ3/A/wcj9BgVXocG31FN1ZTZxOhISuWD+Od9x3bcTAzQKgObMrZjjrbVtudb+lLIbATjlz1zxm2klS9jyUqq1W28Qs5RxYlnY6ZZlKUOGhvlhcnb3pEyj7fV96lbUqm0chewuDcT+zYe9xKRjSmK+NLcDHO4jUA0586Ywj0nfLbUqvrwSiabMZIV7RUr/dHJMn/fuigt6juG89BjWCcxoyZLq8zBB5epSOqR+567oceso2CgzrZcwHdjCb8JxTZhyF7GnTljmNAE4jnu8MQQ7YRV3AsAfXXY+/CLTAobL9VpAjVpbxY71ae4xd+Zf27OUQUKnw//fTDe3PgdGK8MuE+rzTgR5JK+BsuJ2C/EGlFJul45IWjGtY1gSriu8T3NDzFSDpYkU/GK+8ArHc/SAVC2FObARbRffkroF+ZHR1HWEe2QqPW/Mbxm8J5ICIVMVR2DvqbgB8LlFGXfD+mGETrN31bA4fuiGwY68FJt6iOflT4WM+31jAiu2xk/8GGci4V64BHquUme
 N5YxQwPK
 QL7+GFLY/1NjLlaytVhF3WhR5c0dPFxS6e6gwvJuZYE+QtPALM00K6pZ+HI6EVc19BhCdU1aCgA/8v6ZQsnr/0sx+YKTyC8Jhsa5rRxzKcK0ZxgZoHbWHGIm1NsyMj350iKUwggio9y/44ebdS0eWeRWPiacSMgNxIMT9ziXsGBwQ84J4Nm0sK9ytEMTsA9g9vB7uGMsMo1jQOpxm+xLxkRuqhcOwgmZ3D7493wln4HIYIA37QbMgVGKU4VwZ0AYjgbKi2yF3pdr2tz802oWic6UBt7/PFU5Ye4oht25QFR/yeLvobexryl86FvRnS/CMiueaaxeDI5/oLDcwP2eZyvwVMZs8Bc1Rz/drZmYuuml3qhUc8RML/PYRZf2agPmWn6xAp9dke1Ym/SuuSjH1/go0Qcy5eio2qG8H+OXQTsmxWHwQ62UtwZdzZ/Ptsa/xwOS7StzVXGroxfuiNz1jR9c8WPbo+StcwM3y3TXDb+ZRMNdiTv+6J6+VE93bWrnP9qbMnnwpLievgPOvA3vN2YTdQKE0yLczxPIm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> __split_huge_pmd_locked() contains that handling.
>>
>> We have to do that because we did not preallocate a page table we can just throw in.
>>
>> We could do that on this path instead: remap the PMD to be mapped by a PTE table. We'd have to preallocate a page table.
>>
>> That would avoid the do_pte_missing() below for such faults.
>>
>> that could be done later on top of this fix.
> 
> Yeah, thank you for the explanation! I have another question, just curious.
> Why do we have to fall back to installing the PTE table instead of creating
> a new anonymous large folio (2M) and setting a new leaf huge PMD?

Primarily because it would waste more memory for various use cases, on a 
factor of 512.

> 
>>
>>>     |     handle_pte_fault()  //
>>>     |      do_pte_missing()
>>>     |       do_fault()
>>>     |        do_read_fault() //FAULT_FLAG_WRITE is not set
>>>     |         finish_fault()
>>>     |          do_set_pmd() //install leaf pmd again, I think this is wrong!!!
>>>     |      do_wp_page() //copy private anno pages
>>>     <-    goto retry
>>>
>>> Due to an incorrectly large PMD set in do_read_fault(), follow_pmd_mask()
>>> always returns -EMLINK, causing an infinite loop. Under normal
>>> circumstances, I suppose it should fall back to do_wp_page(), which installs
>>> the anonymous page into the PTE. This is also why mappings smaller than 2MB
>>> do not trigger this issue. In addition, if you add FOLL_WRITE when calling
>>> pin_user_pages_fast(), it also will not trigger this issue becasue do_fault()
>>> will call do_cow_fault() to create anonymous pages.
>>>
>>> The above is my analysis, and I tried the following fix, which can solve
>>> the issue (I haven't done a full test yet). But I am not expert in the MM
>>> field, I might have missed something, and this needs to be reviewed by MM
>>> experts.
>>>
>>> Best regards,
>>> Yi.
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 74b45e258323..64846a030a5b 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -5342,6 +5342,10 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>>>        if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
>>>            return ret;
>>>
>>> +    if (vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE) &&
>>> +        !pmd_write(*vmf->pmd))
>>> +        return ret;
>>
>> Likely we would want to make this depend on is_cow_mapping().
>>
>> /*
>>   * We're about to trigger CoW, so never map it through a PMD.
>>   */
>> if (is_cow_mapping(vma->vm_flags &&
>>      vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)))
>>      return ret;
>>
> 
> Sure, adding a cow check would be better. I will send out an official patch.

Thanks!

-- 
Cheers

David / dhildenb


