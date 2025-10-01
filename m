Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 731A8CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 08:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD358E0015; Wed,  1 Oct 2025 04:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84BF8E0002; Wed,  1 Oct 2025 04:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A737D8E0015; Wed,  1 Oct 2025 04:46:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94D858E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:46:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33AFABC1C3
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:46:02 +0000 (UTC)
X-FDA: 83948912964.05.D42183B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id DBF701C000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:45:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FiOH5k9N;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759308360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xr0ntD0Lx2RLbZNFRpn2nmw6riK5SBARL5A6hybnaV8=;
	b=roPxQJVegMyQVtXB3cynCj7LbuO7ef9eNYSuOy/0q33jrCOgzSSgVUPVYygvgrQP/ZkYtt
	nXaWrOaE9OXp40FMVhsM27BcFQ9dMl1U7EHwczf/dVBfbjd/JNFy/ISBetQk66cbyeK16m
	ToZeeub66k5WZQ7okPwJJ5NcmNxVCew=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759308360; a=rsa-sha256;
	cv=none;
	b=8XeNjaWf39Bjab6mmAwNFBsEu+++rAcrpz4Pd/mgGCt27m7lL9/EfC4tnG9mNrkzgg5y98
	vX3doEZjs2JkL6It+EpVJnYUvyD2nOhBDYvptIyFfUDCw1sUgfE+Apl7HDnylb+6SA44Uj
	sAX9xCVgYpuoWXldamLIj5isZfmPOpg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FiOH5k9N;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759308359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Xr0ntD0Lx2RLbZNFRpn2nmw6riK5SBARL5A6hybnaV8=;
	b=FiOH5k9NU3eIUCP4yIcTLij162zp3eyD0IpcFInLW0JTuwoonrJABb4KTXIY5/Dbejg7DD
	DPjqEDS0S+c/KMCBqxVgE7o0wa0/u3odFRo96f1nj4xffsT2fAxQyDZoz/dbspjtVeLPr7
	z3f3SIc4QGXbxL/21iwMK6covxhIihU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-158-uswJhLlfOJa_ua847RSwHQ-1; Wed, 01 Oct 2025 04:45:58 -0400
X-MC-Unique: uswJhLlfOJa_ua847RSwHQ-1
X-Mimecast-MFC-AGG-ID: uswJhLlfOJa_ua847RSwHQ_1759308357
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ee1317b132so5103804f8f.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 01:45:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759308357; x=1759913157;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xr0ntD0Lx2RLbZNFRpn2nmw6riK5SBARL5A6hybnaV8=;
        b=dFRUmZnT/ujtJnrF8Zq2WcJms8S/0+UcJJ7vNY35xjHqJNieIrSth0vigGgjcVMDc/
         YLgdPMalDFGLpg6I/Is304/SpqDI7t6IyXX1SiHmHNhumLrBZ5HZCI5+i4leY7nBic2W
         icVstUvGCN9IA+F4sS3C/3qny39K7lV5CX0NVhKUZEFqBUB3Ygw1aBonmtPRPeq1a1S9
         K8gGOwOTRIYGhLa+RVVta4dKvZTPRWZUc6OcjEp8fdyWIOSqlq6Wr9TAa+wQ7Jq7Fivh
         73+O5OwoD5NvwGiZs58vnWwhtsbKGc4YV1IzxfoplMHoFL8itxFL1sm2VgJuWREjdaJb
         FPIw==
X-Forwarded-Encrypted: i=1; AJvYcCXwR0A7kvcfDFGvU6xKNh8/z9LDpfrtciFzTgOLcTSpqxFTyglT7NmirR3TlBzcv/3saHfqsbziYw==@kvack.org
X-Gm-Message-State: AOJu0YxLUxnt9GsFAH7d6y7UeGadcKwCuvMCc//Qnk68LbhlmZWnmYUM
	9g5xy9bV/nXeRRj3D8yvUxDn0JrJtkRv5XC0M+PiivW6+LJ0dPCxYr7orz1s+U+Si9ywli/9z9M
	h2s5Otk8cLWvF/1i8kn4yIV8MdCRmOk7+wmE+b6T5nq2c+/HLEUYyV/otwlk+
X-Gm-Gg: ASbGncuG43/qmfaPpatw2KRXQZjw/8BJyGfnGCfg8NC1wij9y3/9G65JqAto30RVT1P
	/2O5O6LL6aamTfTreA9QjhqsLLQodmPFfa0g+Cy+IQRmdRDt7HcT79BN1xYn7EaIY8auorJUvpf
	azTTG0pC6xGfDibEeWkfJ8JUaxyS/t91HvLbQLKCUhjTfCuIK2hIBtxm1G7RJv58m5Y3G7FIFau
	C2xuMSQk3mghJYCnzvAHsctvTpY7u6ppyCLCUaUCCITKHwuL58pBLzxGn7MN9oVpanp2iKTEqi0
	7yMf7qfBYyBMtfySmHHQ4+wP8/5zXJcWV4EuT8cZSi7kVlnCPR5QTRfHU7P8KcKqOAcJ3KaYFpY
	36Hn7ECFc
X-Received: by 2002:a05:6000:25c4:b0:3e3:e7a0:1fee with SMTP id ffacd0b85a97d-425577ed624mr2200426f8f.5.1759308356271;
        Wed, 01 Oct 2025 01:45:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4pP1TLeBKN7ypf0YrFZw3L0fhqOaWaDpHjVmV/CZgFRJismlBvTITJl01Mowv0PRJ6Yd8pw==
X-Received: by 2002:a05:6000:25c4:b0:3e3:e7a0:1fee with SMTP id ffacd0b85a97d-425577ed624mr2200388f8f.5.1759308355804;
        Wed, 01 Oct 2025 01:45:55 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb8811ae8sm25881853f8f.19.2025.10.01.01.45.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 01:45:55 -0700 (PDT)
Message-ID: <7b1a7ee2-5e61-407e-babb-c2b7a264f596@redhat.com>
Date: Wed, 1 Oct 2025 10:45:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch mm-stable-fixup 0/2] mm_slot: fix the usage of
 mm_slot_entry()
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 linux-mm@kvack.org, kirill@shutemov.name, raghavendra.kt@amd.com
References: <20251001010651.10543-1-richard.weiyang@gmail.com>
 <f1218a6d-b1ec-460f-afbe-3f88f3cc44ea@redhat.com>
 <20251001083919.nuxs7jtv2rgyz4ud@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251001083919.nuxs7jtv2rgyz4ud@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P4qMTp5aU2wHcV87pR2C5JBJR8EO4qcebNFlcrtCFtg_1759308357
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DBF701C000B
X-Stat-Signature: chnep6fmu4f1k4nnne1ac53wajp7dw17
X-Rspam-User: 
X-HE-Tag: 1759308359-508228
X-HE-Meta: U2FsdGVkX1/PoYoI97VfB4vZTNX3QPicD7c1KDjg+R5lLPKXtXwdC3Jf/3BM+ymRk8l8Vv/lwvg5boYSK5ZNxi3hBAd7h2xmwCYQ+mZWGuSKbAp2WvblR1i0S0OqA5JYrxincyTyx49Ymu2cDmb6KBB33JzTLlo1AWb8kNZbq6SmE5pQ+E9CxD91YrjV5qw7f9F7w2unirofV03zaMn60654va2ko58V93nl3bVNxNjUeDptVkIZK6miD4yVEgUg4n+5ca75V5EkCVK3Xbj9w+lYtVFRIyHBIu8Ml9G8e9rbbTutgbuoBnPMI9c5JbwD32AIdiEaJbhcu7F59UA9f3UhbCOjjIttLTW2O+37yQ/RmnnjsXHnzajty0LcZxj9KwK+lhUYm97E6Ep45rWr/EG2IYKdY9ubmgOPJsiq9VljpdgfwZkqZQ3cW9KhfGAR+o8ftsu6knA4fXB01jY3dohvu15hkrdcJPhxJq2sDG5mqwKahlw82/pCJRy6NpAMsj2JTCxx8z98cGNeoX1muXb3549X6Ktm+ADDF05JkiFjsSQpvC1Trro9alYhayGntPClxa681nWRBHE3YXwiIigea0anAmW9J/MZVVksYO1DvqSRaC4YIsr4ZKLT/W9MS/Bb4hhRnuzuOKsx0uDXs12/SgRe6rvm8r5lG6lHqqDovBrhyYM0mDxzmOWaRYU/T3kUydTilUzQxvglpR95SlfbxwBwF75oOr1LM39vBdpzaSGxiS6V3ae2/byQSZjjFqC1+MLl7mQAAzp3fPhv71BrBmnWeHGa3f851exF3TilogDAwr1mM3WgzfoBmhsF3bbGHBbT/WZq9r9Ip8by0UYZlW3dGUuTD3Lj/5D+hxpOj1Yvq5jzKoKiTWOXyeHrhVnmz6ANRdP2h8j1czTNrKKY1YLqbCJTLClt3RUptv4uWuUKXdVKlAHJ/t8lsinNpsL4jn6/2zPFlP1rmxK
 Hn8mLQN7
 0DdBi8IyrYc9s7Z7E/2aoXuWGZZ6Bp6UVSWz9NRBDjUeSz1cdHunMlJIWgZR7DN86HLEq0RykLBqq+LAv+EvoO0J8zf1dDf1Xk8mylkEXaKBEBgdwIMMkg/FFMV/kC1dnMrR+/h8BPfHqeCMH0i0AYZdHa25jcwTpV3OGp3PwSwz0OhPOP3MuQH8ZIXzBSz1f1QWlgT/7b50LgQIFo1LrLeCp8Eigp1W6k2RNSlOpRqJs7vnTlp3gWf3SvkojcuGhAieJu4khaNUESQ6kh4sfGOwWLfePMbc+ha4q0gGevsr3GiEX5QZ8oqdhcorbYuh/mk09A9Tf2Y03UHG+mlqNS4iRE9PAWn2wcHSml0M7Mo6Bp1YCSs1jNtmBayAzKB7GpQMA9m+Rxi3JHeHfQ8LrIGoQxFE1Yp2yy5WY6qMM1dFtaXHbalCwZqApUPAZ65nCeY5W3xMdOHW+gvWX2aQu/V5K7tMx963hD+Nv/bKWwCZ6QCtjwIjcq26wQSnxwlUSc/m1ojJGk5ALP7/cAM104Pgc4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.10.25 10:39, Wei Yang wrote:
> On Wed, Oct 01, 2025 at 10:34:52AM +0200, David Hildenbrand wrote:
>> On 01.10.25 03:06, Wei Yang wrote:
>>> This is the fixup based on mm-stable.
>>>
>>> The base commit:
>>>
>>>      mm: swap: check for stable address space before operating on the VMA
>>>
>>> The reviewed version is at [1].
>>
>> I'm confused: why "fixup"?
>>
>> Usually fixups are applied on top of other patches (to be squashed in).
>>
> 
> Andrew mention he has merged v2 into mm-stable and ask for a fixup.

Ah, now I understand, some part is already in mm-stable.

In that case the patch descriptions+subjects have to be updated to 
clarify that these are only cleanups on top of the existing commits.

Then, also mention the merged commit in mm-stable.

E.g., for Patch #1

"
mm/ksm: cleanup mm_slot_entry() invocation

We got some late review commits during review of commit XXX ("XXX"). 
Let's reduce the indentation level and make the code easier to follow by
using gotos to a new label.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
"

E.g., for Patch #2

"
mm/khugepaged: use KMEM_CACHE()

We got some late review commits during review of commit XXX ("XXX"). No 
need to keep the old cache name "khugepaged_mm_slot", let's simply
use KMEM_CACHE().

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
"

-- 
Cheers

David / dhildenb


