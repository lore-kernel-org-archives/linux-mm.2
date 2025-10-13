Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1B2DCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0210E8E004B; Mon, 13 Oct 2025 09:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14098E0049; Mon, 13 Oct 2025 09:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDB7A8E004B; Mon, 13 Oct 2025 09:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C40488E0049
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:22:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C87D1403CC
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:22:29 +0000 (UTC)
X-FDA: 83993155218.01.2319B0D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9BAFD100011
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:22:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cpM304xg;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760361747; a=rsa-sha256;
	cv=none;
	b=MYKNsoiKmtCxutMiPwzz0xdX56MwYSwqky0+OvAulwRQmtWo5o3WzRR7d8O0mtcoYvTZa0
	YPYMru9IKu83guwiorQMYaae3yt7eMd8n7H9XubwIBiYquW1IK+rLf3G2FF8ypIErDH9ey
	Itxr9tt/c+kM2bJycU1ZRb62cfkucbQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cpM304xg;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760361747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0KkflN3MIv6NkWLO58LEoqRVvjmRV/CHPyFSmhS+M8=;
	b=lRWTNwMEuXFDT09Ya9wmHOasv2100Vxq8xZYaqSXPJedWXvlbx9lWjZGHDqiI8ZL6wfZHN
	12AzcWR5ATMxRQXGroqTkpQQQFCBlSxjqWkmooDvbm3Sq7XfqNR/l/IXjqgfB7XuJiXJJg
	3iQsrUzQzmeBvz+BjZD88dEZ4R1TGh0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760361745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z0KkflN3MIv6NkWLO58LEoqRVvjmRV/CHPyFSmhS+M8=;
	b=cpM304xgy/8z7aSnpdJcdtWVU9IhaxFZjAXIlmpI5V9CRLJ2oWHVSZrGCDPRH78+REA6XI
	FLmaUMFWBQ2npSUg1X4zjlUZt1VTXYyuukTKP5Bzc/EuE+Y/+xxRHFQi7WsmEKwB7FDV0e
	+EhKphfErG0+TYjANxvKB/D+ljfCSJk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-4bVFUqOzP8mrJKvn5HH4Bw-1; Mon, 13 Oct 2025 09:22:23 -0400
X-MC-Unique: 4bVFUqOzP8mrJKvn5HH4Bw-1
X-Mimecast-MFC-AGG-ID: 4bVFUqOzP8mrJKvn5HH4Bw_1760361742
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e32eb4798so21391335e9.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:22:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760361742; x=1760966542;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z0KkflN3MIv6NkWLO58LEoqRVvjmRV/CHPyFSmhS+M8=;
        b=uOt6L+waPVJYpFix11w99CuswndXw+t66MB4WOUdzadN+H7LhdstSE4PYYwUUrnP59
         d2hfoFtIn520R6qCK4NAn7GyL5a2faKteaThWIURpht177sd9n774WLQjpmblEuoz3Oa
         5P4Z8gZNQkALe8X16iqirkihp4a3pPr0XJt4bRT4eGSJz2SaFYoFPFSyiwUqNiOVB9VY
         gwS+g2eWPzt0FhZvpJ7vPvfRSHQUVL5GGnpxRt/2bZdy2KaH8HbO8IdqLTEKquwj9boK
         J6ttaxIDh8INQ5xmdRI1cjAkYyIoBRI/gZhNlviXWn4ylsISlwW/9jNnRHPy4qgIWnRU
         ou0A==
X-Forwarded-Encrypted: i=1; AJvYcCWGzoZpkMEBadDTQBp0rsQFVAoUKE5V/wZkkmZmLYHrMCDVZ4e6mA1k6wUrI+w5B7SxQ3uLPC9Tng==@kvack.org
X-Gm-Message-State: AOJu0YxgaxEeRWcz7WePN+Ooqpgfh9Qwt2Q/cbVFk6PiLz8z3OgNZVT+
	3oxUESlKpE2Rl0x1tYYf4R9SVhzz3nW6HQWaSQg8If5iis7W7sfJfw7rRJqjrFzXFtZi2pXACuN
	sZ2e/oEy3J2WNw3zbiTeKiJpjXewIP+IBqtU/gmy7EB8HnLxOhuBj
X-Gm-Gg: ASbGncu/V8/YkqWLvhMWQb0y6v4aByToLSHMYmtS/xFzzajXfC4EVFZkq4naENg2jk8
	uHkdRDzdKgA6UBQsMawUEt27uC64V9cw4W07ntt7FbqW73ztBVLXk/KKQpr0ZokC9vJ5+SPq4Di
	sBicuDdRDNMEZVb2E0Btivba5eKCWMeCFB18ZPjPjObqnrm4VOH/jIFpHRM1sIQdhZinp8xuurY
	p39rJjtski9w1bunpcTo2Kt+orqnZWVvjpQm0IrNPAYbXFcI84ZWEBweG37NPE9q3katMBc0jyp
	HkKBV002NlTW92i7maIShnEb9pLkbokHnucmiYtt2HV9ABoIeOF1plTYm6HSyD0DRIahC5BTFsg
	RDys=
X-Received: by 2002:a05:600c:c096:b0:46e:2cfe:971c with SMTP id 5b1f17b1804b1-46fa9b937e1mr97710055e9.0.1760361742507;
        Mon, 13 Oct 2025 06:22:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5rdzWNSycD4oczVz0gUzgmEZCFNszd1maDs9/YNTUGTmr+LgQ4fp2tcaZl3hCCXTDOyiyJQ==
X-Received: by 2002:a05:600c:c096:b0:46e:2cfe:971c with SMTP id 5b1f17b1804b1-46fa9b937e1mr97709845e9.0.1760361742038;
        Mon, 13 Oct 2025 06:22:22 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb497b8fcsm186059275e9.2.2025.10.13.06.22.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 06:22:21 -0700 (PDT)
Message-ID: <1638fe08-b0f4-4dd0-99f9-366796b74ee2@redhat.com>
Date: Mon, 13 Oct 2025 15:22:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RFC PATCH] mm: convert VM flags from macros to enum
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>
Cc: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Ye Liu <liuye@kylinos.cn>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251011093054.886460-1-ye.liu@linux.dev>
 <809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local>
 <7ca0960f-9d1a-4ba4-b074-a6502578b82e@redhat.com>
 <d619784b-b967-4795-aad9-6e79d4191b83@lucifer.local>
 <dfc18351-bb77-4099-bcdd-eb2bd4f1bea5@redhat.com>
 <fa2d7db5-688c-4d04-abcd-a60f79a6bb7a@lucifer.local>
 <71803dce-3fa6-494c-a4b1-55d98fc4aadb@suse.cz>
 <bb9cd331-326f-4ddb-8848-60195e41f012@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <bb9cd331-326f-4ddb-8848-60195e41f012@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GR_OtYV8Zd_pu2YyTXHOeyZmApznNXqPbyTkVVIeVf8_1760361742
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gwrkhuo7n85ar58it5t94wg311679tsg
X-Rspamd-Queue-Id: 9BAFD100011
X-Rspamd-Server: rspam09
X-HE-Tag: 1760361745-923955
X-HE-Meta: U2FsdGVkX194PDfHs1yW/VoDQGeyaQdj1/5jzKzcHMvY9IJNhGSVl2v5Aa/CYKTQZR7tptHqJabS1GGZYyIPShPnS1On7KaLg+CrSd9a+Q/tzZbQ2JCueGjyvPpbpeK1sSRQ9MTxTFs71TjwMj6IuICvR+jnbO71cwLFGYgmtFtwPDgpZb7UB5Zqe4/vWjBqal/U2tkBU2cTERsOnl2Is97N8dSAghPuIgw0lkc1qHN26XGqbJlfM/SAf5KRl7vvmo2FO8aNVyqxqJISgqH/via4dKBsskLT06ov2oUMqGdxerI8g5HgWH5lQy2N6oMDRlSltrDUMic2rf9EsvS1qu4KmPqjqBrgGLIUz2pCfa/wskZB59dIXpnKwRV7pqGrQFeo3ccIl9WJI/CJfS3T5nK5KUoQA0LWSHshIq2j9bMgiVU1lmjcLB6B0LCATBDk3BmNBkSdeJKZulPwHA3sbKHDaltvHl+rmv38Xj4JR4NAUuwrJJ+zYmXHyyeozzWlDEDAE1vF1XUUGyUHVPzc0YvlDAdTRGqh+N9AKlOOnREo9gpOriiDIBXxfuktMaClXfBK/qqRkzno15E6Emrm08ASA+9VN9cG5DQWEslDQi9hMwVoVFAgAveA70sgRygnu2/YiIF1SSQTlvlVnDmQvmqrs9WqPIcN8Ytd9/EtVjlmf+4o21PvyJArtJU0xEsTwYtFfoI/3TinFpN1Jfu6bAUscm9h9kBWt91oykM0LSe+j5IuXCFRDpIdDSQ4rtVp0+zfZPEFSiOpDz5NTqRtD9DOTj/tAejiAkHFuGgLYpWKg+pezVYGV0XD61tmoFyBxd2nGOSy2BvkychtptdRdTYHmOpy7wC3dlch1XOcluc612mbyAQgnqXZfRM9BBKZ7lQ4uYcQfYebaQLignaWGCAAZ+YecotHcAbNSDvKP+vlV+mbyISg+ZWJMcCeFuFS0M8idCOmXmHXly8BTP0
 Kx8Bk1+c
 GdebIVZj/hR+xXxvS5usIegux9xGC7WpV9dhCUjcPxkTDqWN97hQArBHXLHgfWEcqRADCy3KmW7iq1PwF96K6Bsmng2jZnNly7UrEX4F+4tL409zCEzEjCntLFyeHVZPP7cvr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 15:19, Lorenzo Stoakes wrote:
> On Mon, Oct 13, 2025 at 03:07:18PM +0200, Vlastimil Babka wrote:
>> On 10/13/25 14:57, Lorenzo Stoakes wrote:
>>> FOLL_* flags are an anonymous enum, enum fault_flag is not used as a type
>>> anywhere, nor is vm_fault_reason. So those are both kinda weird as to why we
>>> even name the type (they're in effect anonymous).
>>>
>>> But also 'we do X in the kernel' doesn't mean doing X is right :)
>>
>> I think the example to follow could be GFP flags. Nowadays there's an enum
>> below it, and a layer that adds (__force gfp_t), so you could do similar
>> thing with vm_flags_t.
>>
>> However I'm not sure how compatible is that with Lorenzo's plans.
> 
> That's defining bit values in an anonymous enum so isn't really comparable.
> 
> But what it's doing, ultimately, in broad terms (other than the opaque bitmap
> type I'll be using for VMA flags) is what my changes will do.
> 
> And yeah, trying to do duplicate that is not really a good use of time and will
> conflict with my work.
> 
> Overall I think this change is generally unnecessary given that I'm about to
> radically alter how VMA flags are implemented, and actually will cause me
> problems.
> 
> But as I said before, I'm happy to prioritise the change that specifies the
> flags based on the bit numbers, I actually have it ready more-or-less.

Yeah, let's do that if you expect to have it ready soonish.

-- 
Cheers

David / dhildenb


