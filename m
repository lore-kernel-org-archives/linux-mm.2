Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 508BFCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 12:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A84F8E0006; Fri,  5 Sep 2025 08:31:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980148E0001; Fri,  5 Sep 2025 08:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895AB8E0006; Fri,  5 Sep 2025 08:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77C678E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:31:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F1DA1DAC0D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:31:30 +0000 (UTC)
X-FDA: 83855132340.09.9760A59
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id E266A140012
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:31:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lF9Po5N8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757075488; a=rsa-sha256;
	cv=none;
	b=oY6gL+3Idx7CjboR0AIGRsiugL469tpl5iFtjtKTksDNCo7uIb5J758NtGIjHmMSgxw3jV
	+lmJwueI5fmomMgUXGhRaHoTddQuGSizA13RmYojkN5gZe5ZGKzU24ViAPZi4aEop5cb8m
	j1kIWcLOsWNc7N/jgpVdMAKbjnvotB8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lF9Po5N8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757075488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHonkD4Us1QO9Yt7U0Xd3LOspvgSrKo2EvCfpECpyzg=;
	b=vCZtpNLW7LuI440n0Qvou+v9F3AGagtWN/um2x1wOQ+IZ4GSA7Ps31X4DrJyHzpFz/cGNn
	Pe6ZMNmJTQYkxBI/84qcYd0wSns6pSShYaFJeFMmiKZgJkB4QxKJFiTRDvpoFvXoyk0/QT
	7EcVFvfh1sB4Dmqf81SokdqKJtyJ/cM=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45b83ae1734so12462835e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 05:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757075486; x=1757680286; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kHonkD4Us1QO9Yt7U0Xd3LOspvgSrKo2EvCfpECpyzg=;
        b=lF9Po5N8NgQ36uQiFjcYjWvsZXG0U7E+4EHqiVJBs0+Ex31154E2mUYiI6pI025Fjb
         tAVf+AXOhU3ms4O78kD+AHvrRA2vU8wXi4+OzNqL7I+qH0OafYaF2fwF/F9HnsZoTltW
         u5u9J/iscGtfigyrMEqjgoAB2kYZAX0CsXOltqpHU39NXa5jWi8cDjV6dkYcbRzImKuV
         7AduxAcvyXNFbUZ8n8Fpm7ePQOoGmXWQkM9TGRBexzbCwZTbgs5OTTVBHlbjTZEeXIHK
         jc5GbA+aDMas6ihVwCRgsGpBimNTAtapigxTCJ3qzRfEsA+RfdV8uK4Z37P82UVePnnT
         ll/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757075486; x=1757680286;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kHonkD4Us1QO9Yt7U0Xd3LOspvgSrKo2EvCfpECpyzg=;
        b=C6MdsF5owIZqHK6s6wpz+JTS0Djb6eAxSQMfb+tTVftUnFSTNfOXXCbYsX8aMEp8JA
         OZhnSiCMmsRrxux/L3grMoDxjSB0q6HsGFt8ly3D6dtqSE5zVoUG4EqLViPReu01uIQn
         ifRj6ozMyGDqLSJBqgkQSN3Di9QOx4qXfpZ1xh5OkipWNuMcnR69dthZW6xMvK3Cr8Gm
         Y6Qzv5QtcDSLa68uVqmsrj8rGniI3YlfA9e+F9R3wpa6wJmGLfWH1AYs8a7vRnqViz6M
         OL4Ce1ADkVWnHKplqhBgOuxIsXLwvGurrxpGlkPic7CzttKwxV5DBLTaSGtsS4sEyreP
         iAjw==
X-Forwarded-Encrypted: i=1; AJvYcCXuWPOkBtm7uLcR+2iIZg92/rz05GWrSIUmmNwZJaD6VSMf7xVgL8ADXW8inSaFOngJ7EODBDPQXg==@kvack.org
X-Gm-Message-State: AOJu0YwT1TlROHv0PHgWHkmN0Tmr3KSQmhFUw77dKV2JN8JzGbiANKtl
	gQoCzOn2Js6bJVTYN56aIiSNXN5TVF8n90K0NxVbd3kZPo54V7XyvRow
X-Gm-Gg: ASbGnctMNSlVQUg+1CAeYsKg8yewSNTs1ssB2XIt0/kOdll9d9rqdlg7kdgKZFYDD3G
	1tMJzibX1TdVnqKpILAQiwWnn03DhQ7FDjDly8VCdwrnIDxpgHC2AgBHA3sMz9vFiFYLMsQT1U0
	dgLNFDfGhpAN2HNbRghQ9jpob99xeSHxytZN9qSgkl1mgpfRpkJmIH5u4i4CFi6m3FmAF9X3C6O
	efKnnxssTQpo1cQ0Xvx4anQGXIG1sLr+DvgU7oX6DkzMiqncv9lWAeBXKBg/Cq23J3pMtw+kpnC
	ktOHmxC+dK6bLZAK9D4n24CoC4QTQK6BjS025g8FYQ8kIG6/3x+jH7OUdSxBas7QfCiMU1kUxNV
	7YGvPGUVZwUgF2IcJz5DsaCrbZu8XClev6YlkVlVTKHKOSqhsCrUUZgDgnonbj4Pj9BNfvB0=
X-Google-Smtp-Source: AGHT+IHnlMwLin4RCPEC9ey4bGMrukJ3tHOz0H3ZwM/jse7eJzjGnYjTKutrVbK8gWD+JLEh2OHSYA==
X-Received: by 2002:a05:600c:4f0c:b0:45c:b6d3:a106 with SMTP id 5b1f17b1804b1-45cb6d3a2afmr84182015e9.11.1757075485900;
        Fri, 05 Sep 2025 05:31:25 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9bcda91dsm158752795e9.6.2025.09.05.05.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 05:31:25 -0700 (PDT)
Message-ID: <71d11a43-e9ff-46e5-988d-b39905e10f61@gmail.com>
Date: Fri, 5 Sep 2025 13:31:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Nico Pache <npache@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kirill.shutemov@linux.intel.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com>
 <c8c5e818-536a-4d72-b8dc-36aeb1b61800@arm.com>
 <2a141eef-46e2-46e1-9b0f-066ec537600d@linux.alibaba.com>
 <f34b5fcb-6a97-4d97-86a8-906083b53be6@redhat.com>
 <eb02c281-6d41-44af-8eaf-8ffc29153a3a@linux.alibaba.com>
 <286e2cb3-6beb-4d21-b28a-2f99bb2f759b@redhat.com>
 <17075d6a-a209-4636-ae42-2f8944aea745@gmail.com>
 <287f3b64-bc34-48d9-9778-c519260c3dba@redhat.com>
 <ad6ed55e-2471-46be-b123-5272f3052e01@gmail.com>
 <CAA1CXcCMPFqiiTi7hfVhhEvHs4Mddiktvpmb7dMe4coLDF0bgg@mail.gmail.com>
 <61afc355-1877-4530-86b7-e0aa2b6fb827@lucifer.local>
 <65ce71c1-72a5-415e-9059-027167abf129@redhat.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <65ce71c1-72a5-415e-9059-027167abf129@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E266A140012
X-Stat-Signature: mdzrtz65gmft7an86i4ad5wuwix4r1c3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757075487-332499
X-HE-Meta: U2FsdGVkX19zD46W90ZBAOexhI2SylH59gQ41ZYCVoIRRQ3b3ECaFdryx6R/wBmfzuHKN22YqntDlsWFym7bMcX5McBN8Fa9EjGmUOtxXG+7OtgVfIoPIvY+Zod37vmtxmH7SSlCWYedBEmJGCdfPpBVrLZDdslIlCW/TVtiNDFm9zANTLiztI0S3JWAmRe70BZ6l6Y6hDGV9BM1Mw7InoPpwp7yeiBGAH7YG5fvyC52cBnFblTLYMAWBEc08fgV3+OhcxXx+461q6Nkl/DPk9gmXAlLySYzcBUfMkX/fGWFetw6Mm4kIdRq8nngNqIxfHVrrHUeuqYxT4w9ljjcAO0rSZwWekaCpAxEtTCrqie7tm6KnSUnOhC8j/2GfSo/duRjHjRNC6sfJq8BRhVG0oEDUdQYv6Qp/rPJRdtidjH6NXR4qQZ/XUW1BohqpvDygJgSg/KPI/SX9tjkaJZ4VMBFKcQeVdHUr8bXErg1QTw+39rl/SOGAmPP6F2LKukEuzh1TPoSUa/MA6zFb1Tdgm9CP+IjQF2ToD2dVJeHcwMSrW86mBk5/GOHHl3xSfGiiWVRVx6RlndSHq5AGuq7phDCacyZY5Wqt3tIfqAtA4BZpO6/FdV4zYv+YHDaYNimnVgzjNUxPH0C1d+EteNWfaYj/Ngx+NT79dolz+zO3faaTCMwK6sya/wBY2vGAANna6s0xhdO4gOn481pd4u5luX6pAnu1Ra1+KX70uvnFYO2NO2tBpa+YV3uB0p3jgC2CJENgQ3xQFDRf2qD1HMazuWoW8FekY6pt1qCfIikeiyybmBc2+O4YFPAyiqLYXa+Jd4Ef1cNcuzbt1Mwng1z4py4PAjl17p842aw4mU9Yu7kUErpCjgcAJHKOEBHAAXeAHUNkhLw/1/flRIIS2DgYnZAwv6hR8phCZmU7sGCaCtJgVM1moOx4mLiMAdqI/0sCb3C98ZtmQEAZjSssgY
 w7Mr5O92
 hh2DSvxqjWHL9W5R4cgGoRL0GX4mGW0TQ9DLqYtrjtH58BB9k4xlv2bcEi801pfMQlK4g8a/ClKs+RfVO5ADBIiu14u54Pvj6kkGZZS8xnijKOypKcwZ3uNWoeKoL1dM/w8p1gS+VCSoghHrEUO7Pn/+5H1eXbch5yxGX/9dWtcYlwCohx0vR1qLsmZGH4MbZ++at9EbOKM2QyekKW+6jp+TtjNVosVooIZ7rADhEOfOqA2dED+BryuQxT7CJ6ofyJvxqMp0ZObENuPPjBZsSjgnFTDlnqyyHzwCe6JCrTboyAIE0jHxEeIEuKWWbktG9ZjDRQhQRblJ19fguYVK18yQbim4rZ95PujtJ+EPj3iwv7u/I63tuSl/3XJyTslKABOn76e5Ezid6m9Kq0XKHSspASngCglO10UJVlthqYWCG91IAy7+WrDOh4KunbWJL5OSEXNj5mLZUxukMngKnKOMPvmHALnhz6eUJR7vzEVm6//XYFtVCEe84I/EH9DZE2wXSM2Kke+ah+QO67DODspx8ogfQ0NP1STaxKGHxk9dSs/4SRjRd2qWz4oRDWo+ugSXqv5SdKZPzelKOIZ8ROGtHOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 12:55, David Hildenbrand wrote:
> On 05.09.25 13:48, Lorenzo Stoakes wrote:
>> On Wed, Sep 03, 2025 at 08:54:39PM -0600, Nico Pache wrote:
>>> On Tue, Sep 2, 2025 at 2:23 PM Usama Arif <usamaarif642@gmail.com> wrote:
>>>>>>> So I question the utility of max_ptes_none. If you can't tame page faults, then there is only
>>>>>>> limited sense in taming khugepaged. I think there is vale in setting max_ptes_none=0 for some
>>>>>>> corner cases, but I am yet to learn why max_ptes_none=123 would make any sense.
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> For PMD mapped THPs with THP shrinker, this has changed. You can basically tame pagefaults, as when you encounter
>>>>>> memory pressure, the shrinker kicks in if the value is less than HPAGE_PMD_NR -1 (i.e. 511 for x86), and
>>>>>> will break down those hugepages and free up zero-filled memory.
>>>>>
>>>>> You are not really taming page faults, though, you are undoing what page faults might have messed up :)
>>>>>
>>>>> I have seen in our prod workloads where
>>>>>> the memory usage and THP usage can spike (usually when the workload starts), but with memory pressure,
>>>>>> the memory usage is lower compared to with max_ptes_none = 511, while still still keeping the benefits
>>>>>> of THPs like lower TLB misses.
>>>>>
>>>>> Thanks for raising that: I think the current behavior is in place such that you don't bounce back-and-forth between khugepaged collapse and shrinker-split.
>>>>>
>>>>
>>>> Yes, both collapse and shrinker split hinge on max_ptes_none to prevent one of these things thrashing the effect of the other.
>>> I believe with mTHP support in khugepaged, the max_ptes_none value in
>>> the shrinker must also leverage the 'order' scaling to properly
>>> prevent thrashing.
>>
>> No please do not extend this 'scalling' stuff somewhere else, it's really horrid.
>>
>> We have to find an alternative to that, it's extremely confusing in what is
>> already extremely confusing THP code.
>>
>> As I said before, if we can't have a boolean we need another interface, which
>> makes most sense to be a ratio or in practice, a percentage sysctl.
>>
>> Speaking with David off-list, maybe the answer - if we must have this - is to
>> add a new percentage interface and have this in lock-step with the existing
>> max_ptes_none interface. One updates the other, but internally we're just using
>> the percentage value.
> 
> Yes, I'll try hacking something up and sending it as an RFC.
> 
>>
>>> I've been testing a patch for this that I might include in the V11.
>>>>
>>>>> There are likely other ways to achieve that, when we have in mind that the thp shrinker will install zero pages and max_ptes_none includes
>>>>> zero pages.
>>>>>
>>>>>>
>>>>>> I do agree that the value of max_ptes_none is magical and different workloads can react very differently
>>>>>> to it. The relationship is definitely not linear. i.e. if I use max_ptes_none = 256, it does not mean
>>>>>> that the memory regression of using THP=always vs THP=madvise is halved.
>>>>>
>>>>> To which value would you set it? Just 510? 0?
> 
> Sorry, I missed Usama's reply. Thanks Usama!
> 
>>>>>
>>>>
>>>> There are some very large workloads in the meta fleet that I experimented with and found that having
>>>> a small value works out. I experimented with 0, 51 (10%) and 256 (50%). 51 was found to be an optimal
>>>> comprimise in terms of application metrics improving, having an acceptable amount of memory regression and
>>>> improved system level metrics (lower TLB misses, lower page faults). I am sure there was a better value out
>>>> there for these workloads, but not possible to experiment with every value.
>>
>> (->Usama) It's a pity that such workloads exist. But then the percentage solution should work.
> 
> Good. So if there is no strong case for > 255, that's already valuable for mTHP.
> 

tbh the default value of 511 is horrible. I have thought about sending a patch to change it to 0 as default
in upstream for sometime, but it might mean that people who upgrade their kernel might suddenly see
their memory not getting hugified and it could be confusing for them?

