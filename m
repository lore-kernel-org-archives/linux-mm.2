Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61A4CCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9BBC8E0010; Fri, 12 Sep 2025 13:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A739A8E0007; Fri, 12 Sep 2025 13:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962718E0010; Fri, 12 Sep 2025 13:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86EE38E0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:53:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2564F1DEC74
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:53:32 +0000 (UTC)
X-FDA: 83881345464.24.BA1A773
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id D31298000E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:53:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c3PBUW6S;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757699610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWaQp0kZeJAdEBYzp9zyFZzreyIaLb6taNvlZ6KnZNg=;
	b=GCMKzmOLjCocESyNq5Yfw9H0aeJ5DABfoBmDgK0ExhI8MZ5slPUEY/mUg6xLfGQWbFAPY6
	eNUtjjUS8aG2e33Pyz3FbZNf6oYykOvKYogmKhqSWXTic98nYuAR34QzxyCCriuThBU5ng
	ul7gXdeWy1lpi2xRBLMcXcvjs2AiYGQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c3PBUW6S;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757699610; a=rsa-sha256;
	cv=none;
	b=HeuFQD0oaxs8Yw2wkPDsS3wjMAByO82c0i7Iofo7dXRZJy1hyqvpSEvnzp+HsByYro44dJ
	ryimy+ozTeZd2jTc5ko96t5/aaweWPcmh1LxCMZQSG3y53EA0A2AG45Bnm4VIrlQariatg
	e2a47Yf+02jBugfmaLs2vVOnX4IIBtM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757699609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GWaQp0kZeJAdEBYzp9zyFZzreyIaLb6taNvlZ6KnZNg=;
	b=c3PBUW6SvNIfGA/WxS+jlWLefUy6t1jXL7obEtFSTwnh3hUFOM8C9lf479B7pj3TymjKZn
	k1LzQu4sWHS/ghO1wgeylj5191z1KL4OAPR8HOkZ4blEc0rNW0cTnekJHWryaPrEGxzL06
	ldporLL1Tdwm+fJxSCGg03mQ2AUMDqY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-av4CHTQcPGKJXFUZyBvKtQ-1; Fri, 12 Sep 2025 13:53:28 -0400
X-MC-Unique: av4CHTQcPGKJXFUZyBvKtQ-1
X-Mimecast-MFC-AGG-ID: av4CHTQcPGKJXFUZyBvKtQ_1757699607
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45cb604427fso13700055e9.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:53:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757699607; x=1758304407;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GWaQp0kZeJAdEBYzp9zyFZzreyIaLb6taNvlZ6KnZNg=;
        b=PL1Ped284DZCJwY3bdLSVNojSr2fHGHCSgqp99+V96bAG2r7j+gpGV6+0bf4S9LtdT
         9+I7SDl1qFsd5i9XASvz96rukPCmFVU2BbCDnJFKFjbFED9M8QjnS7ssl2OFuiR/YMjn
         zMOTGjopuqA6m/h81jcW4KRdFWZxY83xLVC/x3Jac9SZO9RPIXBdsCbTwUaucacyFRnu
         DFaqaK56dVbl3/X008E7svAZFyBplOj4deJ5OllR1927Yqp2HNM4bD8BsuePY5Nq0dkt
         Buw+L+a1bcSDffaLHYkbdPqUd54SEekj/C9lhAcD5tBMvDSbFXB3rf5DhFlqdTDvYmfT
         BAsA==
X-Forwarded-Encrypted: i=1; AJvYcCVKAvHr0A5UQl5ceWny2tfAx9bXCqcMi3nDnJsXZMsYFGklNyH9Pu33WtY9a3NiXIOsgK9Ig2fJoA==@kvack.org
X-Gm-Message-State: AOJu0Yyxpn9peyudgIfX5rTTsKc9opkAU7tAsTf5RC91+dpOa5kdeK0x
	e+8x75Wss56UFD9CWNdMllbOaLEpU5VVjlM47ogPhMeV4fIoA1C7ZaIAV62ewDYSKholVaYIfMt
	Zd7t9avNjLyn9aYqxx8BdxjOfUX+YFsGy8DbxpcXqUtHUOlRf72q4
X-Gm-Gg: ASbGncv4iOCVxcB2WKsxjedFklPsO1y2ChaQLcIv+kGL/wulTNKwAAOA1hCzfbpOhNp
	OtjFVtSe78oF+Juj5CO5UmGZBlizINwR2H9Y9PrzN8+fjDcktzLufpYRLtn6EkoH8T8mZBsmxJJ
	aanVKMOMaajlp+3JuAE5j82o/UqqtOj1BuM9rF8R/w/njnxF9JHbogaXOjduaGZK7ir9c9TtUcw
	T2aox4scl4SuqGyTF3oToOohvDlHeDd4oDExxS3P98xxNoR5jvheeJMiEp5HJbcGXKSI41p6WDH
	2QdDkTdGnS9CNmF6xZPG6r1HNUl4sS+V435XoFjgps6o99NcBQwdxGNm/LJsCeSW6DhS/wg+zFz
	UOmdIH/4HGBqctW8S4HnWY2lF+nlQvvyIOFb2Bzr1w3CYzuEHff5+ALuEPo+wgGTr0Ng=
X-Received: by 2002:a05:600c:8a1b:20b0:45d:d3a1:70dd with SMTP id 5b1f17b1804b1-45f21221e50mr29826105e9.35.1757699606573;
        Fri, 12 Sep 2025 10:53:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnvTRCdvZUrWLKVO8/YsaHIQ6vlWYzWujC55SFweNtk2eP8Jx1ikBkDI8/I9BWLAS+Y/KDYg==
X-Received: by 2002:a05:600c:8a1b:20b0:45d:d3a1:70dd with SMTP id 5b1f17b1804b1-45f21221e50mr29825535e9.35.1757699606102;
        Fri, 12 Sep 2025 10:53:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0157cc84sm36555805e9.7.2025.09.12.10.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 10:53:25 -0700 (PDT)
Message-ID: <ed784d6c-6c2a-4e0b-ad2f-e953bf310ce8@redhat.com>
Date: Fri, 12 Sep 2025 19:53:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
 <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
 <rapl4xr55zv2nq3jh5ulk4wvfyxa2kmbnnb4uram6q43y4cbwn@dv5m52ocyqne>
 <80c50bf4-27b1-483c-9977-2519369c2630@redhat.com>
 <7ri4u7uxsv6elyohqiq2w5oxv4yhk2tyniwglfxtiueiyofb3n@l4exlmlf5ty4>
 <59641180-a0d9-400c-aaeb-0c9e93954bf5@redhat.com>
 <c5bcecb8-13e7-4db5-849e-2120c69b2af5@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c5bcecb8-13e7-4db5-849e-2120c69b2af5@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uyspsqHs-Lbgy2Jmw1CCBcSU61cwvCNQAFSfAM5--fs_1757699607
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D31298000E
X-Stat-Signature: ogpbnctt5tqoajd41p5fncoxubn38pyc
X-HE-Tag: 1757699609-422244
X-HE-Meta: U2FsdGVkX1+gb2kGvtfO24R44tnXbAErDhckadklJcEA6dMoPXs2MyBiqOXZBufkj3q/6zWaz8fi5ZuAVN0c5QSU7+INwGXHWHOsNu4IPnhPMmPvZCxwQcZZZHDkjxm0Eh2Y9wCUdXFop+teG0RrnoliM6otW6n9e2Za6rtrKi2uwE6MtYmazAKw9y4TsbqmmH4PJkytWSVWD/jqKxYYk6OkiqO3SX4mGUJovUpo3zXIa/D9/+QQRvfKHetggBQLuvtTFqGHUT7NcecNdcnmubPeowtupzFkqMSLXfkcejvSebJ3x3x9O8oclUVfOojSWvkNEkpz+3706UDDeTMkD3njACpeSAo2bWVoNPV3bGopioN1u4qP4WzPfGEUr7kqQUzrkwylkyO8CZQGlpXMA45tuxnRpbLlzvKi+C4HcTMK0JXCmNpLpRQl1gqzCXXobrm3jhXmF3W+8KT6HGL5vV2KGkgpdBdviyRZS/gUhn4JwwhJr6kSEBlyzK4LkhbS5VVKx1UEoxynU8o+8VqKWkElLwEyqFp62mBsM4rrcLZHcOkmx7rIae24skU/AwKDlFBNXanRMqKeMjxihoIAFzyqw/CD/dT7ZOII2IWoaw4CNeUtPGOh6MQ/yl9ps/QYefWubOuoHiLYQMwAKn24pm30io7FQWGtdqjtOyQdW+gmJwgkTkSe1gmfrjfZ34NCX3PG7L81XsfmsG5IlXFarOYtZyCxpEg+NKGskxuTMUr2pdHkrdwaxebuuEEpxj3J8NpMWu9M2IlzMCwYx7e1ENi3ws4UYVFSrSzZNGKVpv775Qlo+P8JZrR0knt3OPbBxKADLDqtHarB09A01ZCjeEjLxsV4w73fWm7VfOjiDQoaejne4rY0YtuQr6Ec5vrgMzDO+xiHtlDn5anFEYDm764lsX9HboLY90rL8F56LywUETrhZ7ZUjgpifPnGlFgkohlHCjhTatIXZw32KPi
 0dEIEzta
 4ujhz6mAtOcdkoS0PYk1WkvZS+xbYmdp2eFzqWf5WBsZgWLehGGmkFm83KbXAKag1YfieTASSq0+SY5UylW2V2j0ZGpyJE8ThwPQ/nkbRm95tvKtln/rTFAu/ZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 17:51, Lorenzo Stoakes wrote:
> On Fri, Sep 12, 2025 at 05:45:26PM +0200, David Hildenbrand wrote:
>> On 12.09.25 17:41, Kiryl Shutsemau wrote:
>>> On Fri, Sep 12, 2025 at 04:56:47PM +0200, David Hildenbrand wrote:
>>>> On 12.09.25 16:35, Kiryl Shutsemau wrote:
>>>>> On Fri, Sep 12, 2025 at 04:28:09PM +0200, David Hildenbrand wrote:
>>>>>> On 12.09.25 15:47, David Hildenbrand wrote:
>>>>>>> On 12.09.25 14:19, Kiryl Shutsemau wrote:
>>>>>>>> On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
>>>>>>>>> The following series provides khugepaged with the capability to collapse
>>>>>>>>> anonymous memory regions to mTHPs.
>>>>>>>>>
>>>>>>>>> To achieve this we generalize the khugepaged functions to no longer depend
>>>>>>>>> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
>>>>>>>>> pages that are occupied (!none/zero). After the PMD scan is done, we do
>>>>>>>>> binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
>>>>>>>>> range. The restriction on max_ptes_none is removed during the scan, to make
>>>>>>>>> sure we account for the whole PMD range. When no mTHP size is enabled, the
>>>>>>>>> legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
>>>>>>>>> by the attempted collapse order to determine how full a mTHP must be to be
>>>>>>>>> eligible for the collapse to occur. If a mTHP collapse is attempted, but
>>>>>>>>> contains swapped out, or shared pages, we don't perform the collapse. It is
>>>>>>>>> now also possible to collapse to mTHPs without requiring the PMD THP size
>>>>>>>>> to be enabled.
>>>>>>>>>
>>>>>>>>> When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
>>>>>>>>> 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
>>>>>>>>> mTHP collapses to prevent collapse "creep" behavior. This prevents
>>>>>>>>> constantly promoting mTHPs to the next available size, which would occur
>>>>>>>>> because a collapse introduces more non-zero pages that would satisfy the
>>>>>>>>> promotion condition on subsequent scans.
>>>>>>>>
>>>>>>>> Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
>>>>>>>> all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
>>>>>>>
>>>>>>> BTW, I thought further about this and I agree: if we count zero-filled
>>>>>>> pages towards none_or_zero one we can avoid the "creep" problem.
>>>>>>>
>>>>>>> The scanning-for-zero part is rather nasty, though.
>>>>>>
>>>>>> Aaand, thinking again from the other direction, this would mean that just
>>>>>> because pages became zero after some time that we would no longer collapse
>>>>>> because none_or_zero would then be higher. Hm ....
>>>>>>
>>>>>> How I hate all of this so very very much :)
>>>>>
>>>>> This is not new. Shrinker has the same problem: it cannot distinguish
>>>>> between hot 4k that happened to be zero from the 4k that is there just
>>>>> because of we faulted in 2M a time.
>>>>
>>>> Right. And so far that problem is isolated to the shrinker.
>>>>
>>>> To me so far "none_or_zero" really meant "will I consume more memory when
>>>> collapsing". That's not true for zero-filled pages, obviously.
>>>
>>> Well, KSM can reclaim these zero-filled memory until we collapse it.
>>
>> KSM is used so rarely (for good reasons) that I would never ever build an
>> argument based on its existence :P
>>
>> But yes: during the very first shrinker discussion I raised that KSM can do
>> the same thing. Obviously that was not good enough.
>>
>> --
>> Cheers
>>
>> David / dhildenb
>>
> 
> With all this stuff said, do we have an actual plan for what we intend to do
> _now_?

Oh no, no I have to use my brain and it's Friday evening.

> 
> As Nico has implemented a basic solution here that we all seem to agree is not
> what we want.
> 
> Without needing special new hardware or major reworks, what would this parameter
> look like?
> 
> What would the heuristics be? What about the eagerness scales?
> 
> I'm but a simple kernel developer, 

:)

and interested in simple pragmatic stuff :)
> do you have a plan right now David?

Ehm, if you ask me that way ...

> 
> Maybe we can start with something simple like a rough percentage per eagerness
> entry that then gets scaled based on utilisation?

... I think we should probably:

1) Start with something very simple for mTHP that doesn't lock us into any particular direction.

2) Add an "eagerness" parameter with fixed scale and use that for mTHP as well

3) Improve that "eagerness" algorithm using a dynamic scale or #whatever

4) Solve world peace and world hunger

5) Connect it all to memory pressure / reclaim / shrinker / heuristics / hw hotness / #whatever


I maintain my initial position that just using

max_ptes_none == 511 -> collapse mTHP always
max_ptes_none != 511 -> collapse mTHP only if we all PTEs are non-none/zero

As a starting point is probably simple and best, and likely leaves room for any
changes later.


Of course, we could do what Nico is proposing here, as 1) and change it all later.

It's just when it comes to documenting all that stuff in patch #15 that I feel like
"alright, we shouldn't be doing it longterm like that, so let's not make anybody
depend on any weird behavior here by over-domenting it".

I mean

"
+To prevent "creeping" behavior where collapses continuously promote to larger
+orders, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on 4K page size), it is
+capped to HPAGE_PMD_NR/2 - 1 for mTHP collapses. This is due to the fact
+that introducing more than half of the pages to be non-zero it will always
+satisfy the eligibility check on the next scan and the region will be collapse.
"

Is just way, way to detailed.

I would just say "The kernel might decide to use a more conservative approach
when collapsing smaller THPs" etc.


Thoughts?

-- 
Cheers

David / dhildenb


