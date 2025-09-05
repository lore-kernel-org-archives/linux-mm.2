Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33A95CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6793C8E0008; Fri,  5 Sep 2025 11:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651D88E0001; Fri,  5 Sep 2025 11:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53FF08E0008; Fri,  5 Sep 2025 11:28:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 433998E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:28:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBB9F1A02CE
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:28:37 +0000 (UTC)
X-FDA: 83855578674.17.71D8322
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id D2BF480007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:28:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AFHvWsrv;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757086115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHR+Mzoo8yNulXQmjP5YSZ3TGPx9n4WCY8ZjjWjytVE=;
	b=CfF0TWgZ36xvcb3Mcex1botMZEG+NZnxWVMz6zJREla/Kk8qvKM8qS1JGrMe1zMSNPUAqK
	fMaILNNGkCU6qbqofRCWP9IazUY/EcjklKJMu+WXTgietQdLJigjlC1MIdXEeXu/0aCDrd
	CdAPNR0jo9u+ATnkU8i+QhinUGGW6qI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757086115; a=rsa-sha256;
	cv=none;
	b=EpcESUXDXjNB6sTLDjE6sqkV5n1r82FU5aOIAkM3Pn7uMaVs2+dJJKtTnE0QLYjVdgfCy+
	LynWYPP/BPrJWTd2fT+bhgphCn5w51i25Jfekls2iGaxCKCvQfFta6ApK/LZL4LxJHKADX
	Sh1QHe72uMpe4rhkr2Cy+1El8xOcJ1k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AFHvWsrv;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757086115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zHR+Mzoo8yNulXQmjP5YSZ3TGPx9n4WCY8ZjjWjytVE=;
	b=AFHvWsrv3JoVrsMLcbAYdqUjkfU49XD8RfIXDUYpjYRU7aCmz9QiizTWGzIsAdEfE0aRH/
	637NtQdA4su46HqHozNHiWA7dal0nUsLRr35+9dPQVQfepAH6JPg7878BtAJpbN/mJQOZ4
	YA2Lnm9IW3WDv9wBO7+eVslJTO0p680=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195--r1r5Z0yOki7Dam7eFbAxQ-1; Fri, 05 Sep 2025 11:28:31 -0400
X-MC-Unique: -r1r5Z0yOki7Dam7eFbAxQ-1
X-Mimecast-MFC-AGG-ID: -r1r5Z0yOki7Dam7eFbAxQ_1757086110
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45cb5dbda9cso15215315e9.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 08:28:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757086110; x=1757690910;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zHR+Mzoo8yNulXQmjP5YSZ3TGPx9n4WCY8ZjjWjytVE=;
        b=GqtZzpnGsobZ1eNn8bfL3yomW8bRdk34JT9dzbfFCaYeBjtWXGkwr/GxZ/3zgyMNs0
         mKfdcSNhie4FCzX1rCFZiiuj7VWkKFXt/fyPj9+iIFe9LN5cUxS+vYwBaFpUjdz7lBWs
         vDtlJ7sx7onTmqw83I4SK/Nk6AV6/LnQaI3zBKtVNwjiSpzxKToZy3VNz2vyOp4dAAMH
         bRo0qb61H9wiwLwhl3TtVLHiFCSLr2e9TVr1jL0Tw0KLzaANmhfs8P0ez1iJZiFnC2nx
         KugDSduGoEM4H2Wu4C3X5Yyg4crQLovasN4Mayk6bXi2UIze5l2NjPJ2N3/gmOSsvXxb
         wvYg==
X-Gm-Message-State: AOJu0YzLDqo+VylWmPrjWpO0PWHmNVMbWdJMUZouNzrQvr7RFU9FzYly
	wQ3MEkDAjm90vnE8VUTuywA82JGnjOPGWaCwFQMxYwRlTUs0mFyPdT/CpuNUyYb0i03WWqfja97
	XT4yky0qvC8HtLhXDgYhMwWaLo6RzTqm4r/FYzT23y8vh+S3M03Iy
X-Gm-Gg: ASbGncuZmpZPPCxWufi1EcOHrPslQ7PED/pxn1PlnwZDUBhdq1ThArukLV7A7opgl0U
	up1cm+QbL+Zz+0gM1p3tNAj+rt0QziXSU4KwmLE0GFNAbKc9LzZNqGbw/uwcJYMDw6r8VsyGJuP
	XO7hVszOsA2om0nXEOqJ+JfiXAVHFUppHaEqpMNrOXDrcTw195fJ7E1YqRTmc4FqZoWKq6qmeBX
	ylDIgUv9e5MjEKbgYbXXXYW0rKBX+dDySV7rUKniq4RF6SDcQnn4v45U5pkiQFvfav19or66HuT
	a3sDodfi5yIxiaocy8iBsZe2CjWdV/636txeLoJeuTNmuD6Nd4oEqJh1Y2j3f9WF180oBeI6tE7
	MZGrh4GLRqkBf08hDnHMTwBNNFB4IiuyzZLKJBqYpznDVbgqWiZtMwVon
X-Received: by 2002:a05:600c:4e8c:b0:45d:d2a6:ad8d with SMTP id 5b1f17b1804b1-45dd2a6afafmr54359825e9.29.1757086110209;
        Fri, 05 Sep 2025 08:28:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtLMs8butaEKsXzoDM4juQ8K5fxnCDzwwTeOVOy3INb+Tp9TofrU5ky0hka2Ygb32Q0f7LIA==
X-Received: by 2002:a05:600c:4e8c:b0:45d:d2a6:ad8d with SMTP id 5b1f17b1804b1-45dd2a6afafmr54359565e9.29.1757086109739;
        Fri, 05 Sep 2025 08:28:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd3aadbcesm60638375e9.17.2025.09.05.08.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 08:28:29 -0700 (PDT)
Message-ID: <aadf50b1-151b-41c6-b60c-5f1f2a4f2d8e@redhat.com>
Date: Fri, 5 Sep 2025 17:28:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
To: Usama Arif <usamaarif642@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>
References: <20250905141137.3529867-1-david@redhat.com>
 <06874db5-80f2-41a0-98f1-35177f758670@gmail.com>
 <1aa5818f-eb75-4aee-a866-9d2f81111056@redhat.com>
 <8b9ee2fe-91ef-4475-905c-cf0943ada720@gmail.com>
 <b56b43c1-d49d-4302-a171-9b00bf9cfa54@redhat.com>
 <8461f6df-a958-4c34-9429-d6696848a145@gmail.com>
 <3737e6e5-9569-464c-8cd0-1ec9888be04b@redhat.com>
 <3c857cdb-01d0-4884-85c1-dfae46d8e4a0@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3c857cdb-01d0-4884-85c1-dfae46d8e4a0@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mAkmQv3BhwB5gMI_7JK70XMMcgTuWYaZy-XCm-xfi1g_1757086110
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D2BF480007
X-Stat-Signature: q7m1ijzc1jpapd3ztzmwhf49pieq33uq
X-Rspam-User: 
X-HE-Tag: 1757086115-799464
X-HE-Meta: U2FsdGVkX18H+xG/pXujScW6aYyGCbu3lYbK5aK51yGom5Zk+Vg1M6RnLwGcSdBaomO/6H9FLMLvmK2ghAn/UBbUWx3agtceqdRcbrbZxVc8wYHUweUG/ha0DgsI3YW9+5T7JJGoQIhbNK/fJQ78PXg8CTYrSyv/yYOBm2EzKf9AOKiPmdTsk99Ep1F/rGHMzvHh3lAhnvTSnlNbJdVd5AvRdPiKP5XLLvmtLFE7wGGzMhIS/qmtMxp25AUAltcPdrqO0lG+4SQV9uOYejuVqRJrJtq52ofAooyF8vRMhY9i+DB+Qhb9atv5/JqeRTcGFPZAIJk5Lccsmx3VLqxuAav+0BbLyBEgtl9s4ZyQHeSzQ+lE2MYVI5dDoStxprX00ErJlImVaqYfbNjNinjrjQoO7uoRuawfetPIcK08Lv1oGxMxXvmP8+DDNdnMOGD96Mv5ZmurYAkJgPT5le9Qvgx7Hy/0zviR0WES1O1MrQQwUUV9SwJYilnoMyicSheDLfrxi888AI3XhImAI7n5pnPrlBd/Z1FLEH96k3tYpuRp+dZfXnK73yRxyqM3r6PrjMZiC0ekMCODRVTbQJbmy4GxI4wZTs3Nznr4oeA1mtgpA6zCPjaTgbJq3+dBYIFwJGXFsD4HM35/T7vMmYwrlPogbjpqirsrwzd25Z3AHOZ5UZzeVGnlMMzHFcsu6RTwtV4cPd48E5LLuvTFCXFMFAQ0YslEckMvyQ1OeyogofAq4xp+C4yryk2oyCiKNl4AqMYel+7OqD8XfSA4a8Yzd3112fMPqNc3E0u+lko2zo3KBJgWPmV5uJorBgzM4gZxvG4FuOYEXyHsN34hdvd346I7PbfLObdcVME2IDNAQS2tjEtoS3483q6TxO8F6LPrc+THOOuLouL+ggJrQoVrzMhAF2YvLoUTrlH/vfjjtNU3E1akkfavL4co4/nJvNZltuxpo7vD91LIUAV0FK9
 LY8tc3jy
 q2D/px5Xra51qNFHWwTRLjs4vlMhuTRguexHoz/10xjnqz37jVASlZDA2592B2RUF2sL9IoJgcIKJNUjFO4hOZEh77Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 17:16, Usama Arif wrote:
> 
> 
> On 05/09/2025 16:04, David Hildenbrand wrote:
>> On 05.09.25 17:01, Usama Arif wrote:
>>>
>>>
>>> On 05/09/2025 15:58, David Hildenbrand wrote:
>>>> On 05.09.25 16:53, Usama Arif wrote:
>>>>>
>>>>>
>>>>> On 05/09/2025 15:46, David Hildenbrand wrote:
>>>>>> [...]
>>>>>>
>>>>>>>
>>>>>>> The reason I did this is for the case if you change max_ptes_none after the THP is added
>>>>>>> to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
>>>>>>> so that its considered for splitting.
>>>>>>
>>>>>> Yeah, I was assuming that was the reason why the shrinker is enabled as default.
>>>>>>
>>>>>> But in any sane system, the admin would enable the shrinker early. If not, we can look into handling it differently.
>>>>>
>>>>> Yes, I do this as well, i.e. have a low value from the start.
>>>>>
>>>>> Does it make sense to disable shrinker if max_ptes_none is 511? It wont shrink
>>>>> the usecase you are describing below, but we wont encounter the increased CPU usage.>
>>>>
>>>> I don't really see why we should do that.
>>>>
>>>> If the shrinker is a problem than the shrinker should be disabled. But if it is enabled, we should be shrinking as documented.
>>>>
>>>> Without more magic around our THP toggles (we want less) :)
>>>>
>>>> Shrinking happens when we are under memory pressure, so I am not really sure how relevant the scanning bit is, and if it is relevant enought to change the shrinker default.
>>>>
>>>
>>> yes agreed, I also dont have numbers to back up my worry, its all theoretical :)
>>
>> BTW, I was also wondering if we should just always add all THP to the deferred split list, and make the split toggle just affect whether we process them or not (scan or not).
>>
>> I mean, as a default we add all of them to the list already right now, even though nothing would ever get reclaimed as default.
>>
>> What's your take?
>>
> 
> hmm I probably didnt understand what you meant to say here:
> we already add all of them to the list in __do_huge_pmd_anonymous_page and collapse_huge_page and
> shrink_underused sets/clears split_underused_thp in deferred_split_folio decides whether we process or not.

This is what I mean:

commit 3952b6f6b671ca7d69fd1783b1abf4806f90d436 (HEAD -> max_ptes_none)
Author: David Hildenbrand <david@redhat.com>
Date:   Fri Sep 5 17:22:01 2025 +0200

     mm/huge_memory: always add THPs to the deferred split list
     
     When disabling the shrinker and then re-enabling it, any anon THPs
     allocated in the meantime.
     
     That also means that we cannot disable the shrinker as default during
     boot, because we would miss some THPs later when enabling it.
     
     So always add them to the deferred split list, and only skip the
     scanning if the shrinker is disabled.
     
     This is effectively what we do on all systems out there already, unless
     they disable the shrinker.
     
     Signed-off-by: David Hildenbrand <david@redhat.com>

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index aa3ed7a86435b..3ee857c1d3754 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4052,9 +4052,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
         if (folio_order(folio) <= 1)
                 return;
  
-       if (!partially_mapped && !split_underused_thp)
-               return;
-
         /*
          * Exclude swapcache: originally to avoid a corrupt deferred split
          * queue. Nowadays that is fully prevented by memcg1_swapout();
@@ -4175,6 +4172,8 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
                 bool underused = false;
  
                 if (!folio_test_partially_mapped(folio)) {
+                       if (!split_underused_thp)
+                               goto next;
                         underused = thp_underused(folio);
                         if (!underused)
                                 goto next;


-- 
Cheers

David / dhildenb


