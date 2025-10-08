Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 439D0CCD185
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 09:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE92F8E001A; Wed,  8 Oct 2025 05:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FDDC8E0002; Wed,  8 Oct 2025 05:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D9C8E001A; Wed,  8 Oct 2025 05:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 729698E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:55:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31B7BB9ABE
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:55:48 +0000 (UTC)
X-FDA: 83974490376.15.918E1E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id BD0C61C0006
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:55:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qy3KgkXU;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759917345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQ29clC0/TFWvLCMfZ8wEzGTaNgPQ1DHzgT3FIwoSoU=;
	b=ugFxWywauqiMwjpg3J7t8EWbxarP71iqTvxj5vef+0aRNme/73qrFZikGiSG1O3rc/mgsP
	GslW44NP83zFdmT6xREJHDoIqIVU5pjKeOR3lLONz4BGObovciNsylJdU1SdFrWw39Ni88
	MvTxJwUAeWBuMtLdrbl+Yl9i1JBP0j8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qy3KgkXU;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759917345; a=rsa-sha256;
	cv=none;
	b=FA6QkSoDKdJATJsfT0v4iQn+2lGjRDmZdv50/6n9qfi/JzncK9FsmaqTXyHlANvxnAPyKV
	6YeOw6oim7lCgdXJ9Per76ZEPcziCXz0lHcjQr3VdcBYX3CpuQeP0KQ5ZNIUrUHU+WfIQy
	x0PTlE51GoSEmr6pCCbv0EuQ06OeXN4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759917345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qQ29clC0/TFWvLCMfZ8wEzGTaNgPQ1DHzgT3FIwoSoU=;
	b=Qy3KgkXUUcQNKeuBDHIHQ9z3ULjj8lXZxMyT4D7PeCDx63mDqnty/DYpQtqj10gK041Bc7
	wSIJXisnQn5QlReAigdFbavZW1OhpRIcEyEN/UCyZdCfNpQsNz/f6e6GhW16FX2OCBNbS7
	hbBswyfnkdAPQbc+AlFacske7YE5C60=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-JkO72rLWM7uRwYmurBkmxA-1; Wed, 08 Oct 2025 05:55:42 -0400
X-MC-Unique: JkO72rLWM7uRwYmurBkmxA-1
X-Mimecast-MFC-AGG-ID: JkO72rLWM7uRwYmurBkmxA_1759917341
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e3d43bbc7so28182835e9.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 02:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759917341; x=1760522141;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qQ29clC0/TFWvLCMfZ8wEzGTaNgPQ1DHzgT3FIwoSoU=;
        b=uQ6E8XhTLOYIzkB7Lk7f1RNaCmi7JSd8i40POs2cU372Q/e54rqbOmQT8tp1mD8ljs
         HcYq24Eiw0sw9SLy6uaR/9/Kam3UU6S54eTpiqLsPsBqe72UO+MT64lfREnw/3nS0KeH
         UQdfzlzVSO7bkycnjw3ISfHMkhP6q+ieRyOQGXuPbEL7hMhTWciiCmfr1iy1Hf9+GI0S
         gQfvgpxPSGt/aw4tE93MiEwG2gYQ71ER+jmIp6JwafCJdBbpwA67B85iOSHSvbL94VVh
         CJBRzElQbscekSEIMoCEhweZaAwVeT9C3/y5PKBMLdyc/owp1IVWtBD3Fd4N1q28TNmr
         +M2g==
X-Forwarded-Encrypted: i=1; AJvYcCUhmge/nlw8NDb8zCH4VkHyPlOxV57UP8rPtFA3LIT4bUyeUaT/Z23a8W39/HbU5yS+pU//cbEsIQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6SMXh5UjImFUigYu+6djHah4BEuXfhAAHBHa1U6ZUWGqNtqmX
	/vK9Q4RLQqHx8JqPs/+ohiJsYzsS5ITui9RuU0jxg0fOyxPVDwQRKmf1F07+mizkHySdQLiabth
	8kHZOCmCR1/srbqUTkT4K0yGo8iV6j6YaB3gBFAwgg4vCfSj5+Xm0
X-Gm-Gg: ASbGncteXLb9jW1zKxnQ8zX/QjiTiC44ShNfpjh51oct28c/aO7vQzaXez9D+neBftw
	Jt5d0Vovkxvuh/X3BNlR3GgR08pX1ccHywFOFxCixMnPRnY7bKWPRM7SQsgQP4GfHRHZ2lacMN+
	FvSYjYuy9LyEIY15/VglMuqcUIwYH240/1w0sShrjAOAngovX5gJ7Xl2JQrp85H3XVY/x6MpqAS
	wzE2fFiR/pkPd8EXpJqgVBRulGPRIbyJXCR1TDHhAE0Y/rkVLGT6wP+Z3eE8qtS5A6UVnR1SdM6
	yQjtHy6oG2LQfoIKzbw4xMIO0acs+osUyjUtfLUGxI8aNv+7qqz3uBKouD40farrmmTD8T4ZVKh
	dhM9yCKEx
X-Received: by 2002:a05:600c:314b:b0:46e:2109:f435 with SMTP id 5b1f17b1804b1-46fa9a966f6mr18962665e9.11.1759917341305;
        Wed, 08 Oct 2025 02:55:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHVbvCnS/+nknDxXVAnTpCPWqMkth9PG9V8qI8r+zdDjVpv3M+Im4veSBEwGQU2XfRWdXnoA==
X-Received: by 2002:a05:600c:314b:b0:46e:2109:f435 with SMTP id 5b1f17b1804b1-46fa9a966f6mr18962505e9.11.1759917340916;
        Wed, 08 Oct 2025 02:55:40 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9b622cdsm30801905e9.0.2025.10.08.02.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 02:55:40 -0700 (PDT)
Message-ID: <519c13e0-6b68-4987-8602-7b9ba47daee0@redhat.com>
Date: Wed, 8 Oct 2025 11:55:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/compaction: some fix for the range passed to
 pageblock_pfn_to_page()
To: Wei Yang <richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, vbabka@suse.cz,
 surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 iamjoonsoo.kim@lge.com, linux-mm@kvack.org
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
 <20251007182922.4a254daff78633b1452bdcc3@linux-foundation.org>
 <20251008023218.g53gm33vmrdt5nw7@master> <aOYYUwyt-v9ivU1g@tiehlicka>
 <20251008091301.44xerz33fmrgnjyt@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251008091301.44xerz33fmrgnjyt@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: M5EkiHHe-X9cEQACnq_24rm4fTd9Gh7HN9R5OgNEhRQ_1759917341
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cjxt997r7y5mbrewpdd8d9qatc1jqdxx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD0C61C0006
X-HE-Tag: 1759917345-257035
X-HE-Meta: U2FsdGVkX19C1gMjshVgE8rDY49b8ht5vSTQDPQvrhao4QzwIkasauDCYmZhkMde0L+Kj+0Sb20Lh9c2blDAJH2Vhdmdjfgvb/BXG+6Pqe2sla1mmhwnhAMNgA3+0cXQ8ULrsVvK1M1zsNBQoGDEsvv40UIC3/eqlKQgM0m2n61qyngMMUKdPmMV9ajsYKFLGhJogwEbCUoLRTnokV7+iRPFkQ9wpiTussA7CCrqIeP1ytc7+eOU61HriE3Gfo+H7XJmQYtj0BLAdZBATXkFdf0N+vS9WxVkgohJYgciIWLp903b8rcVXh2TBPNbgfe9DGVMcDc16mpWTCSmFRpE9pN5lh5vfmcMUluUSbhztpXJMqrmiKsUaUueDi63hp1CsMtmVOjNpcx72ZWnpX0xyGGrx4GySHamWsnXYv9qUafHEI8F0B+BsKXp3dqHvDu0FZEb2oHoBA/WII9MLUPARmmdj/+d97guM7J69OhjTT5ACZtHZwi5wJfodWb3mQxC10GaSE7tYIhQl0srqYs17V0zrwUtYbz9X5VxUBY5hmb5ci5SJ56EzqlK2j/f9tWwuYAtGT58759XHWkH5YMIOUVPyhp9O6KOIvSlOUqoMD2FnKOwagWeOvQZaA7jqdF32MNSrcSyCPt3YhloHU/FiGK3C0PqIoBf4v0i2f8Vi7t/4klXqhibdKZZnTKak+VlxKsmDGH7u6EeTHn+nL67gt6Mkm5lrDyp/SKi8bSo0yXCZY08KUL5W2ZhBkcCqFBhqQmRZa0n0JKuYq/KzBKU1fxXfb7UZrDrlj238lGWThVOAYUuL3RFH9CXY8dLVr37VTRzzzfDVRayNA0fqW76B4+0MePIgokApPxjPp0W3BzbmN9n0qoUs1zZjZSga0u9EnAY+O7JyQj8eaRznE00xIsIVhcOg3PSDR3cHKjKthuiY2XdkR3qnOkLIRf8BebECSvAF6RMHo8X3kRA9/T
 hd1Y01lF
 PqrKiEKScaOl3g6XHX3IIxIx6iarDZjLMPE+KaYVmIWjpbSvd3yEP55+EPhv6xlnejU6H3pHKu4VVfr0+3w+BINpnrrTGtGsmsXAssrJfi1XfyH313hmjCYe5KAu7pPQSYMmhX9c+wHUP2VMYe0WRK7wNx/eU9t0wLt2Eoe21HhPPzHZtUpFtnudEN2Pq+kIfbehk9cn5dXbh9I3es/I5euc0MTz3Q4Uu4j/eKoW2QHgrPxIYWQJbyU/iw4Z7qU6r2VKe0HGPEWegZo8Pw3XzQ4sLBbYxH6WRJosHyH9heCAuYxVapqtax2pPOqNp91gOVRQLGGCDLJglwHfAar71z/TxAvt5wnK0IahjLC0YgbOC6NxXp566Ag2rjsiPlf8kYux0wt52thPDGdPYqn3q+s4FCmS0WLv22ygZ4VTDu6ssOpDq0CVY45MgQPf4tOYaBqw5LVkAwm9WSaz72XhN4NB0hYMZCLng2kkd1lNmXgfYziX3LCZPR+iQ8EupyufmhZhj1itAn22vn+WkKfGcB+MERyoTw5sjrmFMPjQI/lhvvF/x5v5G1Pm87g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 11:13, Wei Yang wrote:
> On Wed, Oct 08, 2025 at 09:52:51AM +0200, Michal Hocko wrote:
>> On Wed 08-10-25 02:32:18, Wei Yang wrote:
>>> On Tue, Oct 07, 2025 at 06:29:22PM -0700, Andrew Morton wrote:
>>>> On Thu,  2 Oct 2025 03:31:38 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>>>>
>>>>> During the code reading of isolate_migratepages_range(), first spot the range
>>>>> passed to pageblock_pfn_to_page() is different from that to
>>>>> isolate_migratepages_block().
>>>>>
>>>>> This implies there is a chance that pageblock_pfn_to_page() thinks the range
>>>>> is in the same zone, but isolate_migratepages_block() will isolate range in
>>>>> two different zones. This is not what we expect.
>>>>>
>>>>> Then I found pageblock_pfn_to_page() has an optimization if zone->contiguous,
>>>>> this means even the range is across two different zones, it will think the
>>>>> range is within the same zone.
>>>>>
>>>>> So introduce two patches to fix it:
>>>>
>>>> What do you think might be the worst-case userspace-visible effects
>>>> of the bug?
>>>
>>> I don't see userspace-visible effect yet.
>>>
>>> Since I lack the knowledge of the consequence of isolating cross zone range,
>>> currently I can't tell the effect accurately.
>>>
>>> The worst case in my mind is we put some page on a different zone's freelist.
>>> But I don't totally understand the behavior now.
>>
>> Is there any actual problem to fix here then?
> 
> I don't see an actual problem in practice yet.

We should avoid talking about "fix" then. Let me take a look at the patches.

-- 
Cheers

David / dhildenb


