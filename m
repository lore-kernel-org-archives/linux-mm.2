Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50B2DCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 569FE8E002E; Mon,  1 Sep 2025 09:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541B08E000F; Mon,  1 Sep 2025 09:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A758E002E; Mon,  1 Sep 2025 09:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29F658E000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:05:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD1551DA5CD
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:05:12 +0000 (UTC)
X-FDA: 83840702064.26.CF07487
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id C21984001C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:05:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QqMmSdBH;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756731910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nkmkczn0wVW4LucuKT4jBlhxibrNt+qcDHWFcXh7zw=;
	b=fRYwdRosTkXwxWcdMIf6KLblHvN6HZe/Bi/EtSZiZ2m+alF0Jh/Eqn0yj1/w5cjBtt0Rdo
	YWPAwQGfXghtJ0KygcLV8oTKIH8l2cYMi1Tt7/5yVjFxH8Be/gnVZijLUzv6FmNHCYYPdn
	RVROVz8tMcpydlOlFbyY+rltfFDx0b8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QqMmSdBH;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756731910; a=rsa-sha256;
	cv=none;
	b=m83U0IcCaD8ciCAijBy2O+aJMU16jDZNRXnj+iqRpXEV0tOzUFD+5pnfabVNB39KAAOnaD
	U851ViWpmt4PfTqiZeBeL/GiFL4PVJ/1pGQPddSUJNWz/IFuOYdnFtxbmEjQXHVeO4SqUz
	FwmKd54sFzcfrEFOE1MJINNIEn6UCbY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756731909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8nkmkczn0wVW4LucuKT4jBlhxibrNt+qcDHWFcXh7zw=;
	b=QqMmSdBHchO76rIWeljNyxR8xwxGeS55M6gaqPZCV5warE1OAweQwCitawoGF3l8vIsCBr
	RI3XWKuvAxtdsYnuhkeuBBgNOPaGoaW8dQp3tgy8GGg+GFuxQlrzSfEdDN39upc0HJ9/Wm
	BbpbJ02QkmBUmESqibldOTRbt4ybmV4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-S60pwav1N1CQtXzKHTd9ag-1; Mon, 01 Sep 2025 09:05:07 -0400
X-MC-Unique: S60pwav1N1CQtXzKHTd9ag-1
X-Mimecast-MFC-AGG-ID: S60pwav1N1CQtXzKHTd9ag_1756731906
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b467f5173so42310825e9.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:05:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756731906; x=1757336706;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8nkmkczn0wVW4LucuKT4jBlhxibrNt+qcDHWFcXh7zw=;
        b=tYlq+res8dVgrKB6pjmGDwpR1FlfbxnEocTtpE2qJ32XqCI14VSgp0nVu7wFmh/JWs
         mbe3lO3oLlVrXOBpdXzaiqmYcNq4mkidGoGYRk/c6LIPMnT8INLz9eqfwLiX8hdiW+1T
         yf7gHOFV0EqxcvrqvsaX+Ts0LTSSV1zO0ab/kVdKEUnFDMe1P/H5TU/XPFbmN0JcWQn/
         qJsSOyX+MN74CWR6PzLBmPX4cR9XDWJyq00pkbfAte/YQvmclBkUSKN0pR9vrRkRqLYq
         W71rvcA5cRf/QISQaQSWF5WQLAPLCaGrYQ1FSuxUjYDAbJrafxWAExhJQeo9+G6LGZn5
         NePA==
X-Forwarded-Encrypted: i=1; AJvYcCWF7u/jpGI/YATKuiZSF5GwDAih9uDjM46o6sITjghYiLP1GD7AgEFO2HM9apTkP5ILn1Fc8fHUSw==@kvack.org
X-Gm-Message-State: AOJu0YwSa18LR4bvNwn4mMIJzYrnB9X5VODQSZUc+k598mkkalJpUGFv
	AvjidVjhqgDMTLZyR0HJPuleaEcmORi0MxWQEnLAHrlzNXD3aQ2P7Ajf0P7Tt7pB9HcB+tlvS7c
	PnRqI/0m6wARq79RsiNvrPFtwAdg8LIYTGWa+EGefjc5hbtrA8wPO
X-Gm-Gg: ASbGncs9FPjTkiRDNvzoPhvoIdhIVIL6dL4Ad/WtFDUfMr7FnHNpK8kSovF1UlfIkKE
	rR5URrZetLZmsuRZ/m8HOpK+8UaYO2cTr1+USueiHTHMi74w93VanonA3URPPW+L95SNlFdD9Gc
	aZuv7aaHVPVSUhGCRGjwCbjLreMK+xEwix07lHDAeb5/thFvgh39DXKA3YZh+2o3i0cszIQy7RM
	jUp0sfirr9UjAOJFdn7NYhBNJVsLtcLXBTd3w7nUup9fdTtHUJCV66Ct7oeC4SIqh47Wz5P+IZ1
	Z9ql/OLM+Xlak76DAehLQoa1MhynTqtpWveMqE+Gd0nShUPlYpTTdUowsld1do217oKar+ebl8k
	2o0ub37vhbIiL35aa5iFWJUiI8uEA0xtbpKbKjxR3bLOfGzFpkS1IkYN5Nx5gaxcte4Y=
X-Received: by 2002:a05:600c:4687:b0:45b:8e26:5f46 with SMTP id 5b1f17b1804b1-45b8ee17c88mr20110395e9.5.1756731906174;
        Mon, 01 Sep 2025 06:05:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWa3r7A8AggYrjdFt2+SHUMlSQVb9n+a5JUNiRtfjx+X+oCWa99HqvVm+upzvltHy+V7+Gdw==
X-Received: by 2002:a05:600c:4687:b0:45b:8e26:5f46 with SMTP id 5b1f17b1804b1-45b8ee17c88mr20109845e9.5.1756731905500;
        Mon, 01 Sep 2025 06:05:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fba9fbsm15296676f8f.50.2025.09.01.06.05.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:05:05 -0700 (PDT)
Message-ID: <c42eefd8-3239-4385-a313-9c2157728f8c@redhat.com>
Date: Mon, 1 Sep 2025 15:05:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: directly add pagesize instead of increase
 until page size
From: David Hildenbrand <david@redhat.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250830023102.14981-1-richard.weiyang@gmail.com>
 <E0C570E7-C4CD-4E41-9590-DDB64757CA2C@nvidia.com>
 <c89a9096-716a-4bbb-a911-99096ff8f0a0@redhat.com>
 <20250901125126.furb4fkgim7adzhq@master>
 <76079f7e-9874-41a5-ab00-9fa4765f8ee0@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <76079f7e-9874-41a5-ab00-9fa4765f8ee0@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bKf5GHlJpbldo9HyL7Kj06PZeUVkkJZj2z_k90e2Q5k_1756731906
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C21984001C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ffxwxxfkjxo5bmuhdw3qxadsgp7crofe
X-HE-Tag: 1756731909-918544
X-HE-Meta: U2FsdGVkX190zeBRf5lo8g7Xjhqk2U5w0U+1oaIod0+9NVdjiM7uAKifeQyQk5mLVRzSLKTGonZMNMo8xge0jYkyCI++YTMSQgE4DSkoKhjRktJg2iLJLJSdxXikhquoajc5N9ciPProrlZySH0oEpef6+KVZAexPhxUIs9lgMERvQuY0aHPLsx5kEKrmK8zLpd4UGPQKiPyK79QKsz9CpwdrE2wnmZMqhSXybBcJP3o3huy68DSIfA8N+B05z/ZINFtCWs8kWWeWJ4i7sddZ3f5/p3UOqtO/sOQdn4d/ORND7eC9oUr8lYIHmFF/S5Dhw26Q2m0CKwA2ylNb8Ai+L1ce6WyPV5oXj2AnpRr4xBKetc8or0OHPAKekGcGTuWF2G5hwTqXKXATgeP//W5MlHcO7tGU9fhEJ/MOlJK+gn0TjQeXW/un9Vj1YQWsUb1PxNrMb/M0NBDtqFKbHyAzAegbW1zlw82wtMUC1gDQVOQs36pYiInwyjqkoWdfpMaQvL6/WPJUGS9u8RQl8ch/qXX4lVh+N6NKUShrbjTP60RPYw7AA0Uk2VHPv9c/T3WeyqKR87wHCJ5ojXgnGegJjmdyzPCmscOZBICUiiACtZgY5SqAZ31oqTzhjPYo2Mf0dV1jmNP6EP5hIcyXRPxazJZSWwnl2hE38SqIar8xiftydchwc8jtA/t6QRzYTYhZG04bxAS5drY2t8Fvv9VCNCdWvByJxbmURLuil6HWHfEFsHQSC9tcY44/hzVMyXlPg0QyBkTgdfvByTkTuCKmojW0JdwA/OSFV/9UspbzC35RiLTHIhAy0xunnlEJb7U8yp6nX/EErZ092wcGXd2EWpxPAImYchDMfjJ57B1bhgyDV5UMo9JaTxw1xo4v1mFA/+tQUyr8qwvlBwsf4ioNMcs6ozbxj5JOXsjPik/mtlN9cPLd8gwP5fZfICkNDzUpb6HdDtBmCps7y6fZc1
 vTcya/3q
 XfQmc+7dwHv9mC6jw4XLhOlQUN0MTSVzm4RzpLtjV0NILpukrccOzj2llVteZ3Uvq6hapk3XY1z7tuQsZx7HJIvKcd3NTLdD4zgf2LyqWY61Bv8J96wapmlIO+2iiX/avnshHMzsWFmBzg0QxgxTHAy5s++MQgjK9o57c1TMs4LWYPtkT56cc4ZC/mfDyFHYjul7IeOXAf8u1LEYeyphS7xJpbtSz1meaCV00y8jgC0H/BD7kBFB5P9LYK/N14jSDt89xTxeVAzsTrIAuKL0951Y9o9XuEhpxfa7Bft/BTO2y5G+mviJEeK0F7Q1/qKPKF/Cropso7nl2JlkaJoddlpVWPFoopNLOmBVinZIRDPtpoF3tano1f81tTkiCawTBP11QaM9vz2FpVhpJ07/VcL4NVYwmUrUMOPWihrlaJLbKS/J2lnXCNdof6Ko5fg5JEsxusLmH5b0VukYk+FdwBsXPWL7W6jrcpnI4jq8LrURKMbnicLsykTFugditjKrpp0AzdYw8apNp9E1us4vXrfivy3piT7rOj07D1xIMZMZ+OM5JCUzT8h3h4mrTH0y6tppobQNxwPW3mVyuxDDIbxGSZN4v9v9HWap+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:54, David Hildenbrand wrote:
> On 01.09.25 14:51, Wei Yang wrote:
>> On Mon, Sep 01, 2025 at 11:32:11AM +0200, David Hildenbrand wrote:
>>> On 31.08.25 03:32, Zi Yan wrote:
>>>> On 29 Aug 2025, at 22:31, Wei Yang wrote:
>>>>
>>>>> The check of is_backed_by_folio() is done on each page.
>>>>>
>>>>> Directly move pointer to next page instead of increase one and check if
>>>>> it is page size aligned.
>>>>>
>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>> ---
>>>>>     tools/testing/selftests/mm/split_huge_page_test.c | 5 ++---
>>>>>     1 file changed, 2 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>>>>> index 10ae65ea032f..7f7016ba4054 100644
>>>>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>>>>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>>>>> @@ -423,9 +423,8 @@ static void split_pte_mapped_thp(void)
>>>>>
>>>>>     	/* smap does not show THPs after mremap, use kpageflags instead */
>>>>>     	thp_size = 0;
>>>>> -	for (i = 0; i < pagesize * 4; i++)
>>>>> -		if (i % pagesize == 0 &&
>>>>> -		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>>>>> +	for (i = 0; i < pagesize * 4; i += pagesize)
>>>>> +		if (is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>>>>>     			thp_size++;
>>>>>
>>>>>     	if (thp_size != 4)
>>>>
>>>> It might be better to add
>>>>
>>>> if (pte_mapped[i] != (char)i)
>>>> 	ksft_exit_fail_msg("%ld byte corrupted\n", i);
>>>>
>>>> instead to make sure mremap() does not change pte_mapped[] values.
>>>
>>> We do have a corruption check later in that function, so I think we can just
>>> keep it simple here.
>>>
>>> So this as is LGTM
>>>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>>
>>> As noted, we should just move from mremap() to mprotect() or sth like that
>>> which has clearer semantics.
>>>
>>
>> If my understanding is correct, we should
>>
>>      mmap 4 PMD_SIZE region with RW
>>      madvise and fault in to allocate pmd-mapped thp
>>      mprotect first page of each PMD to read-only to split to pte-mapped thp
>>      check whether the page is backed by pmd-order folio
>>
>> Is this the correct way?
> 
> Yeah, I would just mprotect(PROT_READ) the first page of each PMD. That
> will trigger a PTE-mapping of the THP reliably.

Zi Yan mentions that there is a reason we are using mremap in the other 
thread. So likely best to just keep it as is unless we can understand 
that it definitely can done simpler.

-- 
Cheers

David / dhildenb


