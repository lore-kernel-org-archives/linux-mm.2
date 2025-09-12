Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC6BCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7BB48E0021; Fri, 12 Sep 2025 05:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2BCA8E0006; Fri, 12 Sep 2025 05:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4D98E0021; Fri, 12 Sep 2025 05:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 772EF8E0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:36:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28E2013BA8B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:36:25 +0000 (UTC)
X-FDA: 83880092730.10.48ACA28
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id A2106180005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:36:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DVY9SEPw;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757669782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4KJZdY1MD+iAN7yxyMGS4DtOSEdOr2LuczyAdAae4g=;
	b=wbHGLtMuMjIeJEktNjtREx+I/GqETNe++jkNSUO5LfgBDnHUsjdOq1ou5/8WCwSsedaVMV
	GK6oXhHyRJWfLlKMZNHg7FL3SG9TKGKkMc1R6tOlu+7+vzaU30iBLc28PNXHvdD3iOSevC
	1phAbz9HF/hOlzzVqLh2D8mk8gfq5vo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DVY9SEPw;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757669782; a=rsa-sha256;
	cv=none;
	b=uNZgqL4vM1jLL5ANeyAld2xZXMUTvOkEfVTEsE35DiSRxyjXpRIOCkYf0VB65NLV6R0u/X
	er7N3pfc6I0lOmp7tJSw9IxU4pKzmZzmSqnSKuGRCePahpmRX8xrTddbnmA8gsVGVm2y+L
	+O2jHjfqaRYfgs5pyQwVKKP/rL0vluc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757669782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B4KJZdY1MD+iAN7yxyMGS4DtOSEdOr2LuczyAdAae4g=;
	b=DVY9SEPwFGTmzT6ffJylpI0tLbpzffjtOX8j/p4kgQjztrVNrg96cutieXGnISmxALvMny
	vYzXURzuPrv5L4e2GYgwqE6St2zDLNJ7eFD5q81W4Df0TKdR0yyaH2tkTo5Mkl2ii6Ry2b
	YIfbYXfl94mFp20pt+h2RLHt53B1JWk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-KzdmmUPiMWaRZ4I7D-5_5g-1; Fri, 12 Sep 2025 05:36:20 -0400
X-MC-Unique: KzdmmUPiMWaRZ4I7D-5_5g-1
X-Mimecast-MFC-AGG-ID: KzdmmUPiMWaRZ4I7D-5_5g_1757669780
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45decfa5b26so9551295e9.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757669780; x=1758274580;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B4KJZdY1MD+iAN7yxyMGS4DtOSEdOr2LuczyAdAae4g=;
        b=dXKe88XXSYuo4rcIPHRXwgez3/8RxV7aX2JK724DiDsR5x97MBYCfHeZ4IkTdjleQa
         uLIDDxf42V+S8DFodXXTUSLR2ywJQwRynqmzCm8mSAJsmSizjD8YArh4793tha860tVv
         fRv/RqgqSG8v2SaNhrR/naoeIQ1qyFSHCaPmJyBL77a4pTwlAufeek1SJVoOF8NVL7U8
         z89xWqtj23FllZ5fXFHiThbIU0cE/lBMgPUHtpphkkK4Rx0J7CadJszT6RKaidl17dDQ
         kTSAsvF3yU+AQibfnknglEPTI8mDY+S3DG7mTy0u+RU3W4MLpYAP94klZA0Uwd2OJRA4
         oWKw==
X-Forwarded-Encrypted: i=1; AJvYcCWUu8wpSGc26JqOLAjQl+Dm9xHsBGaMcvJT5pSaGmQXTm8f1EJ1amLp9GUdN3O6hYfGFog9jAs/0g==@kvack.org
X-Gm-Message-State: AOJu0Yz9CoUpvxqayxvqsWTnmKS6LbsbYwKQmTbWb72WGYDmTCimS0K+
	tzLnf6G9AihGGcOVhVRYB3SCwlYn9kSnq/y4+f/+FnQiiTK/68F+5Ukl1TYv51ORgVyEQu+1Jxy
	HFNKbVjCR0FKOj/SDkWKJ6a8F391+LV8oAn07yATbMU1say81FF/9YYc8SMA3
X-Gm-Gg: ASbGncsaLvooNXuGWG6uWZzxh55jUcR5tQEPXndB3va1sshkNSrOMA3M0UbPvevrIZp
	CQVv8f6NmREUl2ksDZZnnk8RS2sZKqKnIJdrFxe/mpHJqMQlCT8hxS+ApgUMoCqnd2mbGz97sR8
	VQFwjHCwtO66c63rMJPwJFKXRUuH9e7XLWryE3qByfTWNiLHUYEjCcrk7IUm7Wl1dJm2zNoIfYR
	NUr9sEddVW/L4eXeVzI30KReeivunEhrY//S3hwASTQO/kQnbdkLcHqo1/obWz5j4rAvtdUfu7T
	F90haRaRXY9mmwrEh4ZnV01vAh19ZkSD7ZIfiDxlddv++SgUE+bMtZOhMIhojkXMLu7GqTcPCJ8
	TKe6hm+JrhygqfHM2rjErIW58UTBtIEVaTeRgGscOcwrTUMnasdmaNY49BBQS9LG7WUE=
X-Received: by 2002:a05:6000:2410:b0:3e4:64b0:a75d with SMTP id ffacd0b85a97d-3e7659db640mr1861334f8f.30.1757669779722;
        Fri, 12 Sep 2025 02:36:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEffTnkjpwSgdIokrJRdi0r1dJ0It77LZ+hWwe5tws1dme1LH9tLiMm17T34HzdwjxEeiy8uw==
X-Received: by 2002:a05:6000:2410:b0:3e4:64b0:a75d with SMTP id ffacd0b85a97d-3e7659db640mr1861304f8f.30.1757669779279;
        Fri, 12 Sep 2025 02:36:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607e2fd7sm5942242f8f.63.2025.09.12.02.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 02:36:18 -0700 (PDT)
Message-ID: <37816bb5-97f8-4c05-84ed-9a81cfc5c755@redhat.com>
Date: Fri, 12 Sep 2025 11:36:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] resource: Improve child resource handling in
 release_mem_region_adjustable()
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
 linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20250911140004.2241566-1-sumanthk@linux.ibm.com>
 <0ab2cb14-ba8e-4436-b03d-9457137f492a@redhat.com>
 <aMPluIk8EnOuIWbi@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aMPluIk8EnOuIWbi@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TD74axAXUB1MpKGSaGmue9wEGaKdbf8ChglFot3kVt0_1757669780
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A2106180005
X-Stat-Signature: itedt31jkmjyu6khubj5sr3qz5u133ha
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757669782-152100
X-HE-Meta: U2FsdGVkX1/pfDE/Eo9WQqeQCI0BTRFtrGIcR18nMIMcXTOn4mfTo6ynb4WKxklWV9Ka1y2JmukQy5j5IcSSk6UAC6evmYmfC2r+KCuX+DUIP0btkDz7B5skgJcU8SU6l6ZULTa67178bDFGOH9L0ZSsz5dFxg1TWSxR/w96baIxZi2G1sc5BRVdg3h8N2kVOg96/sRcOL8JLUNLT25x4tn94DvptkH8OSkTwqrgnqNrn1XDkTSiT3bedhabxUlpDZiwxh1ccPT0MQ1L63/4+P4LguzDGNJxMUfxZInk9Gid1eiy8v6KcL9AhMuvMCWIDI5R3rY8C2VfPaCAmpg+JcX/LVw+vA1AMTXMotgJh1FL+/vMvnGXcgDM3IbDovxM9eT7eKPrYQBeEOkJXo0gzv/LorD1rllWGHrCyJB7udm6l/GJlAn6sDhZgwlAP3F8nVxpvTUucbUh6zGrXzkGcz9kZbbtqA5Gt9dQMePRSezoH6vcGJStPn83pQGuY5fIzVGZWNXW7IEBFWQ93X5SL3fUoVZ3Zg7tk9F3ovGfVPT9uH/PekNFcIAbCVv7N2RGBZfI3v0R76C9cJbfZi+nIASVLz/QOTRBon1hwK4TZnqdzOkBzjhuoAo6/0Q9U5kNTBzYQsnGnKSS4sys7dT/Ne/bj3M+nZdKcoRDgmjKaNxzyKEqdb13ZAM6tLjsG7cVXrsJCQWwQE0QrH9OjltNABXA16hO4hgzZ9Ur3mUIsHt3kpr9ktUjMkjvoyoW+h+HzBHdawcjhelZ5HjUxxjOPzX/8Aw83SZA/rhcnzDwox15S6+Ei0gnpKWvGQha5vJDiuOm96TpxSy/rVLHH1oLO7iB271RUR0bylMIr+Kwvw2tXoZh0Z1cdWfzWNEocoNCMWZTfATZ0r/UP2xP4BWl4pHShRfC5SgJx0RgpoQ9tREownNOB7o7lRSVMOR4CVhT18VoW2Srqdd954GsSLv
 m5s1ciBq
 jYb5Ol1BojDCrM9kbKLUYso+nnQYLYUDxn85ZAutwiY93EP4k+XWfVv14Fx/UH1W7lroz0n7uz4efQcyn+LBLErFUbn9VXSRufwO34vmxamTmcV0qci83PDIkIz9U8GUAgQUPpL9Ne8AXOKVnVAEyfzME3TJ/N1MP5uaDO9qjhXxBxdnGk4Fk/H5/1or48KkSrDroSlJdb3zHDVTuSzedkc8mDBo14qHfDePXr9T4jQyEfVaBNG51bZ4ZVbdg6pXUzcFauwt8PXM8eywoCvt2Oyb2g+aEJxl7qE1TXQ/aaze2KcV+e1Ky39Du2FCaFQlZkyKF09BNLQb6UgJ4kGQMVYmgExt0LxpQyBYuwKHjlxptBqgEfcPNOWEa/+y9UhHy6k6Bsva6ZOhs7qxhODvDtbEHAO0UQ+82b1Ic/6VUZiSf2tWggEyKX/GC6s83oFlcdBfTzCRfmJOrl3xNkBOVFZGr40Ww+Xz/71i4hC28jgHs2hRbTNuHkj5x4f1XnF12+fkNTNiuKnYiJ3E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> Hi David,

Hi!

> 
> I am working on the item related to the last discussion -  dynamic
> runtime (de)configuration of memory on s390:
> https://lore.kernel.org/all/aCx-SJdHd-3Z12af@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com/
> 
> I came across the problem when I tried to offline and remove the memory
> via /sys/firmware/memory interface.

Ah, that makes sense. Sorry that I didn't immediately connect the dots 
when seeing your name.

> 
> I have also modified lsmem (not yet upstream) to list deconfigured
> memory, which currently appears as offline. An additional "configured"
> column is also introduced to show the configuration state, but it is not
> displayed here yet (without --output-all).

Worth mentioning in the patch description, otherwise it's confusing.

> 
>>> 0x0000000150000000-0x0000000157ffffff  128M offline               42
> 
> True, this will not be shown with the master lsmem, since the sysfs
> entry is removed after deconfiguration.
> 
>> Do we need a Fixes: and CC stable?
> 
> It will reference commit 825f787bb496 ("resource: add
> release_mem_region_adjustable()"). Since the commit already states
> "enhance this logic when necessary," I did not add a Fixes tag.

So if this cannot be triggered yet, all good and no need for Fixes:.

I was assuming that maybe this can be triggered with ppc dlpar, so I was 
concerned.

> 
>>> Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
>>> ---
>>>    kernel/resource.c | 44 +++++++++++++++++++++++++++++++++++++++-----
>>>    1 file changed, 39 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/kernel/resource.c b/kernel/resource.c
>>> index f9bb5481501a..c329b8a4aa2f 100644
>>> --- a/kernel/resource.c
>>> +++ b/kernel/resource.c
>>> @@ -1388,6 +1388,41 @@ void __release_region(struct resource *parent, resource_size_t start,
>>>    EXPORT_SYMBOL(__release_region);
>>>    #ifdef CONFIG_MEMORY_HOTREMOVE
>>> +static void append_child_to_parent(struct resource *new_parent, struct resource *new_child)
>>> +{
>>> +	struct resource *child;
>>> +
>>> +	child = new_parent->child;
>>> +	if (child) {
>>> +		while (child->sibling)
>>> +			child = child->sibling;
>>> +		child->sibling = new_child;
>>
>> Shouldn't we take care of the address ordering here? I guess this works
>> because we process them in left-to-right (lowest-to-highest) address.
> 
> __request_resource() adds the child resources in the increasing order.
> With that, we dont need to check the ordering again here.  True, here we
> process the child resources from lowest to highest address.
> 
>>> +	} else {
>>> +		new_parent->child = new_child;
>>> +	}
>>> +	new_child->parent = new_parent;
>>> +	new_child->sibling = NULL;
>>> +}
>>> +
>>> +static void move_children_to_parent(struct resource *old_parent,
>>> +				    struct resource *new_parent,
>>> +				    resource_size_t split_addr)
>>
>> I'd call this "reparent_child_resources". But actually the function is
>> weird. Because you only reparents some resources from old to now.
>>
>> Two questions:
>>
>> a) Is split_addr really required. Couldn't we derive that from "old_parent"
> 
> old_parent->end points to old end range before the split, so I think it
> doesnt tell where the split boundary is, until __adjust_resource() is
> called. Hence, split_addr was added.

Makes sense, that's also where the sanity checks happen.

Worth throwing in a comment for the function telling that lower was not 
adjusted yet.

-- 
Cheers

David / dhildenb


