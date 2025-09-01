Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA821CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C018E0055; Mon,  1 Sep 2025 09:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8278E0008; Mon,  1 Sep 2025 09:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D613A8E0055; Mon,  1 Sep 2025 09:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C05758E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:43:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73BED13B217
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:43:51 +0000 (UTC)
X-FDA: 83840799462.08.56D831C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4D702A0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:43:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aaNBY+Wd;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqS2GRqBYqNxRqOzd74tRge4t4k/G8N0BFtPYQcSras=;
	b=7T4WO2eCeRZQnrAVbxaYowMbZA3i4jJGJfNU3N/uWCshnsScC1FzQ/kNVK7rp81Mh+nZOW
	IJcVlc4lvfTnwUcD+HRuCkXLxHDAa7FXkUe1YZ99R5Wt3rghku+uWPWOd0U066HAM+3En+
	3Alui/CeoPDrLrO9Ku73l3E/gSAMHII=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aaNBY+Wd;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734229; a=rsa-sha256;
	cv=none;
	b=opjPPENWCHnfA52cskSxFHTQUt0U/rFTz1Hn9QWNOVNWudCpkTleKgyjcOCD70K4sKra7F
	F6c3Q1mbABQsE54rUwfn0EkGfjWQZlpeAHyEFENv7h4zKZT8G3we9jgQmmYNde0LKYYqPz
	akfbEmvZ+tPl9+87loDVMxLhqOp4uw4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756734228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xqS2GRqBYqNxRqOzd74tRge4t4k/G8N0BFtPYQcSras=;
	b=aaNBY+WdfJihFCbU6t+kekweLqizA5v5K3LuFvpYPjEpPvXZ+5l2Mbziyk+RMQ55X2/nzu
	+a7nxsQcp2Bc2TVrd5y2KtGknyWmIPRvH/aVw0kFHkzRWnSTUbG9c9bc7MxYFLD1IOD6/t
	ft76FAzlADguwVK/uRwo5M22ZO+iRmg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-gnNw8tO2PzWJlpdY-xpvRw-1; Mon, 01 Sep 2025 09:43:47 -0400
X-MC-Unique: gnNw8tO2PzWJlpdY-xpvRw-1
X-Mimecast-MFC-AGG-ID: gnNw8tO2PzWJlpdY-xpvRw_1756734226
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b8b7d66adso6201895e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:43:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756734226; x=1757339026;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xqS2GRqBYqNxRqOzd74tRge4t4k/G8N0BFtPYQcSras=;
        b=s2aBIz7JnDa0MfSwQs2UASmPtjVJ+UDRfeX6kAm8H2Mvg+2gbuyQhR213F6UtmQNVU
         WB+l+7BDmgTaTrKm8aCgV8f2f9NfcfR0SNYooQkxcG7dm33olv//7HxbNcqZLtgME71z
         t4BT1HSOfLbOCnrMOcMYG5s6z/VZ6reCAPwZZXoCEwLFZ6DTGznvKYl94d7JJgYwGX3N
         QnVWSz027SD1v5icCHXcn5WWNcRxcaYR+oCmYD21yiEIWn5kyZQ27zB4A99sIlu+HnbW
         65LGRx948WML/7nNkqiZPn2UzgbqoH+/J8SDefThV+kquaaw7ceVOmVHNsa6V+Coelzu
         emkA==
X-Forwarded-Encrypted: i=1; AJvYcCV5jeXnm05D+RdWYttLCUmHIKRFl3E5nceNUZytIXzq6f9ljF1B1MA39uZBag8+Q4rhW2h0qSM5ZQ==@kvack.org
X-Gm-Message-State: AOJu0YxPzG/83ymQ0+60FT1XF3arEKnCq+Q+n1mr17oevnmkS8NYtTAh
	UBskQi28NqJ/loqxIrgGT86oNopp2J5R7uYXfggQWIzyrkcMw0QaUktv5BGPtEkivzQmy2v3HFl
	b86LvKKVvdY74vhYN+BkCY10GC5GCNUiO9QEiQow9nSSgMOUadZV2
X-Gm-Gg: ASbGncu2rEST4jlQCwjUTM9izt+5XghynltYkmlpH0nB5nKw2gSvD5yQutSj+JlmfMm
	/DiGcRhL4JgvV/APRzcClemjOiy2xmVuj56NznJYjN9Bh0u9x4yWrGQRjPlkQLJ4BWMsqDSJEnS
	rnzr09xTZAmQLzPUR826dhbV+S2fpxzFtuyIuxVN6eKP+O/aUqObHINWpzUxQl/yRegk8l4EY0p
	NuzhwRoY//BRsI3QjgslIcQ5FjWQ7O2SThCkFv+t7qUNVET+mxILmImVrN2Fzi6ZwV7Ypdm3v0I
	nEDWo4x5TjlzfzOv0PCLdpCKp/qoNwiY6HhNT2pYjrNYF56B5DUx5/SO8EluPiLEd9bX7HOEGQv
	XKWgt+slxtSoIvNauL93wf7r+2pNW7xJoF/8DMAzCR/hyuWJgkscDUqZ/wF+Ij9MuCnY=
X-Received: by 2002:a05:600c:4694:b0:459:443e:b177 with SMTP id 5b1f17b1804b1-45b8557a72cmr65263635e9.25.1756734226407;
        Mon, 01 Sep 2025 06:43:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYoZ0BPbL9v6uAJga/QA3m1S7cO7hcDA2K3cyp4xTbWqS8UlVJpDGlbGtewdsXMiEue3w9pw==
X-Received: by 2002:a05:600c:4694:b0:459:443e:b177 with SMTP id 5b1f17b1804b1-45b8557a72cmr65263415e9.25.1756734226016;
        Mon, 01 Sep 2025 06:43:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d64ba4ff83sm5013587f8f.4.2025.09.01.06.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:43:45 -0700 (PDT)
Message-ID: <d8640bd6-1a72-4969-86de-e63736af53d8@redhat.com>
Date: Mon, 1 Sep 2025 15:43:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Enable khugepaged to operate on non-writable VMAs
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 willy@infradead.org, hughd@google.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250901074817.73012-1-dev.jain@arm.com>
 <7towtl2pjubgdil4csn5rg3usbai5xvzz73wqkwj5b5awh2iim@wfvahykzjrlo>
 <9c3a2ecd-ceae-4e87-a6d7-6a7121ab7a15@redhat.com>
 <csqlc5ajszg6bybykeezkpcfqlx7nv5ochikrgttzrhqqjaxjv@y2hwbmqu4qfr>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <csqlc5ajszg6bybykeezkpcfqlx7nv5ochikrgttzrhqqjaxjv@y2hwbmqu4qfr>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jAd9rLvl1RlOP6Cu7t0Sf1PIDh0Z6gwbM7h0BrL6TDI_1756734226
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4D702A0006
X-Stat-Signature: 1bhqo85pdg1tizbeokz8kszhrgs64a3y
X-Rspam-User: 
X-HE-Tag: 1756734229-383367
X-HE-Meta: U2FsdGVkX1+jmlMsyZ8tPOHy9Ygkeza0in35Ctb8XEA7dwlhe7eaBj6fbGLIgxncRxtoxDJCHpEFoSbz/PPrmd7xqDi9x4jUn0rR8r8VgYkHGUzxjuaWOnTV6Jfg+QF/EtYXwZBOmKXcIccJHInuppLnO5otk10l+X7lxHnMXIksUVgP8KcMGW7MJq9gjfrRBr1in3jXS+2QNOdE3lTXijFpt6KnzJ1S8KH7GhPvQTrjFUBK587VdkRXJXTCZ1H9oXyQzJ5g6f5Kcrgr0sF5CGkeD1tgMFsCn7mDgKf2rHLC2+ItSr/sN5DcFhjsyRZQxBwH9PHr/mTFQ6svchJIontDLHDk3i6dnOErUcsUqdzcexaHVuN74MckgdM2u8ePF2Q2PO14BAkz8QdcT8uw05O1M80A2zWw7DpRxewmucUfJczIdFhEsQe32RpE+OApf4+aO1NzMNHaPoVLBqiBiRn2gYLt0fUuWEeRiVEcxN2Q28CiRFZ+uQUNDNxVguZwdxcTnEKVXFU9C/Vr4KqPscvUi0sVq7WuApnu8993nVTF+qhK/lpPe+EvNP3XRwP+f4mI25uHWoVe2Gx/177Sz8T8XhQ4m2bxysCLKimBw0IDUZZVyrVhTPD4VHtJkd8jBYNPz7uSf2A+97bJWzrfusHvj/ZPbYqZcuYJZc5Z7GukyPxNvAlmQK4Ntyf/72ogj8uBirFrqqoVT4LRM4vRuEHrmTFpbgWIiVrNhDuCth94ZCNA84tTKB7NcCyCvb5guuq8bqKWlKU/7xWnIvOgpHHje9uTTNUJUDTSColRDvEjTDmp2opLcEQuylTgl4lKPhIObg3vKoBXBilFVWzDH+hvT7pGbja81g/cxmF3v4ED32XsrbEj7ENUN6sjBjCCTu9H0HcER1uCu977IeLvBnwXAtLRSCL0Hia32oeCHDLAHZxWWufPyRNnT67ZiGKMtFwhAKjucseB8/UQgEj
 rvgdh3M0
 oK1WI0xrFku50OhQ0/cjnKMqWVz/g3Lej/8SHOuFuPIhGC59wXJdWjv8by5c3VD8M1F8UEkG0a8gsDZ+yMUQJFXdfUr+Q/alv9eiVPsE1t0OjAZV6cI5smDPZI7qvVBTRndk2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 15:15, Kiryl Shutsemau wrote:
> On Mon, Sep 01, 2025 at 10:32:34AM +0200, David Hildenbrand wrote:
>>
>>>> @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>>    			writable = true;
>>>>    	}
>>>> -	if (unlikely(!writable)) {
>>>> -		result = SCAN_PAGE_RO;
>>>> -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
>>>> +	if (unlikely(cc->is_khugepaged && !referenced)) {
>>>>    		result = SCAN_LACK_REFERENCED_PAGE;
>>>>    	} else {
>>>>    		result = SCAN_SUCCEED;
>>>> @@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>    		     mmu_notifier_test_young(vma->vm_mm, _address)))
>>>>    			referenced++;
>>>>    	}
>>>> -	if (!writable) {
>>>> -		result = SCAN_PAGE_RO;
>>>> -	} else if (cc->is_khugepaged &&
>>>> +	if (cc->is_khugepaged &&
>>>
>>> The only practical use of the writable is gone. The only other usage is
>>> tracing which can be dropped to as it is not actionable anymore.
>>>
>>> Could you drop writable? Maybe as a separate commit.
>>
>> I think we should just do it in the same patch.
> 
> Change in trace_mm_collapse_huge_page_isolate() interface doesn't belong
> to the same patch in my view.

We frequently adjust tracing code (which is specific to khugepaged in 
this case) in the same patch.

Anyhow, no strong opinion.

-- 
Cheers

David / dhildenb


