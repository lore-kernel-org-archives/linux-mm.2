Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 506F1CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 10:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6E38E0007; Tue,  2 Sep 2025 06:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968438E0001; Tue,  2 Sep 2025 06:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FF78E0007; Tue,  2 Sep 2025 06:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 70C108E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:34:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 204F586612
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:34:22 +0000 (UTC)
X-FDA: 83843950764.17.8BC7A96
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2004940013
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:34:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rzr3Bx7U;
	spf=pass (imf01.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756809260; a=rsa-sha256;
	cv=none;
	b=v8Y63lKQGSu7bo+K9CT07sP+/zHfzhEtWZR+wkgWSrPHU8NbiGJYriVUyHX19Hks3zwqLa
	Eug10pOj+2VJwxDfJGK1IqvZqEPEUoZFvoWWKb4qJYJKdNoP1Bl7h/17pRXnTJFvSVTKQ4
	7D/8QowWOdcfqNUMCB8nfkYAEo+Kot4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rzr3Bx7U;
	spf=pass (imf01.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756809260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4gr05sFl9E5mGpq0zxI24mI1hqeAukkuCMWxkJ3Xa7A=;
	b=ZEGaPKeJFo7sGvx6cCJIfyvwWClKm8EWGyWQ0CREmkOrNT/5cvvp7Bv3rIi1sGaJ8vGlge
	bsWfPUgJtAkqONVCUfcY8WWnfYXyeKK5FHCVgOa4COyQJExGPyzZstrkRYT6Fhww54USX7
	t15Yp9DsB7D4niICQa7dusK2sT057yo=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45b7d87b90fso35088875e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 03:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756809258; x=1757414058; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4gr05sFl9E5mGpq0zxI24mI1hqeAukkuCMWxkJ3Xa7A=;
        b=Rzr3Bx7UyolVKhk4/Zv5Lmn4WT4ttkGurmmv4LJEmqodXa7kaT0MivRBY+ViNxdyAc
         A4S2MsuRv2Zv73U1wJSsYUa7tVwYCh3VRd1fv1ujnuQQlAI/5chG8euW+lq+MibNpqQ5
         t8bFdPBXU6VGxMIiaASgJWtIH+Dx9IsTIXaSxULQNY/pUxu0L0gIz2Y1A/Eo9RPTbDxF
         23UlnhdY6PtoZ3Mquux9lwGslvs+LMixswEJy4Yt/xpqKmbj9TQ1w+YeLFEUbN+vFqtR
         p6StFIs52S6PM4I+RiLw7Kxxwd0M1RGHukUMksFUC4OSfjbesL/ndk1polimd+M08RfT
         u9xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756809258; x=1757414058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4gr05sFl9E5mGpq0zxI24mI1hqeAukkuCMWxkJ3Xa7A=;
        b=jIL2qPK1NWIFsCUnaSEQ7tF45GQD0/k2tzOr2Am0ynTPK6sNT5I2PQNQYxoeh4QQ6r
         sPsjQKf3t/ZDJ8fUH8Zv16W+hgcDu2BvfZ/AsJoyxecFxfuyrSrfY75JkVVAXqbBfCo3
         7vKEpiRzK2d9j3mPodLybkQmK2shKMah/LC0x9SgyDkuH8iJCCetZomlFFLp/NSzq4Mw
         mYwq/zGffxINQGyOBVmxaDFzJIJZhuHXa22Rv6curG0QYgrXcOkPFQI0QgS4AKXIhehw
         P1mVOPHxKEE9F2lMJ2/kUC1+Xd9pVeZnBp0kgvqyOJ1sSR2c4WOlfSWsjn9s42RTsbk5
         NoQw==
X-Forwarded-Encrypted: i=1; AJvYcCXiahpFtL4Dg3r3QL1lZc4xEvxtieq8+tKoPXmfv3BMaD4oMsSbcmlhq9IaroYNvGuhyoQA8nWTsA==@kvack.org
X-Gm-Message-State: AOJu0YyN4BviJy/Td8PMeGohyolLFAja1//9sivoiTgwMHUhyXW5Da/W
	engljc90bgKPkF4HVOFaNdIAxa4pg6wtoV3/epfi2sOzOGOheVGmraMb
X-Gm-Gg: ASbGncv4vAqCH/BOtQgCS5D9ZKQSZ9K6T8tFpqW+rYkCwhDd6oS+PI+PKsU4Wg+rqLW
	QAvZHNr2v6Zo6rnXcNDeIvEeNEHGM0pMr77GIplp9oko8YrXeOixDEgIkHX2IqsXbKPbzYG3CtG
	twL6EJfcU17NZPZf3WZO5aTn4lKio2kAnps+Bt+r41ZaYavmtvhrpBs2osGAMFKzTNkxxJ9QAVD
	AIhyXo+RaNSZE5iz1f0Zotg2nHektHbbOtScXecw46UVwagSs4zwIrPHajncVWizEb9bJrQ/23S
	lpppiJOtO/MOmMzjVWeMu2S19T+qIVBfd+baLqLhof7zAwiJJXxdV6ONNo8t1CrL7LLBaCqqjJ+
	uhKcpyNxAAZHl8hmefnehLE8MVq+gCOC77Drb9uK3kb5IeMzqTxDo/M6Fb45bXC+3oMWoCfXN0b
	uxQx/AK1As50Sam0BZ
X-Google-Smtp-Source: AGHT+IHr9wRTUh3+XFyRCz1Zu9zWA4/sbliCfxf1+3LDP5RehEXdAv+muRODoSoFjICHs5NQzhGYrg==
X-Received: by 2002:a05:600c:1389:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b85589e58mr99248955e9.11.1756809258185;
        Tue, 02 Sep 2025 03:34:18 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::6:2ee9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b813816desm103955815e9.4.2025.09.02.03.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 03:34:17 -0700 (PDT)
Message-ID: <17075d6a-a209-4636-ae42-2f8944aea745@gmail.com>
Date: Tue, 2 Sep 2025 11:34:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
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
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
 <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
 <bdbb5168-7657-4f11-a42d-b75cce7e0bca@lucifer.local>
 <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
 <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com>
 <c8c5e818-536a-4d72-b8dc-36aeb1b61800@arm.com>
 <2a141eef-46e2-46e1-9b0f-066ec537600d@linux.alibaba.com>
 <f34b5fcb-6a97-4d97-86a8-906083b53be6@redhat.com>
 <eb02c281-6d41-44af-8eaf-8ffc29153a3a@linux.alibaba.com>
 <286e2cb3-6beb-4d21-b28a-2f99bb2f759b@redhat.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <286e2cb3-6beb-4d21-b28a-2f99bb2f759b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2004940013
X-Stat-Signature: 96j4q5zjfuhyj9qgc3ip68bzraacz3ph
X-Rspam-User: 
X-HE-Tag: 1756809259-81475
X-HE-Meta: U2FsdGVkX1+wUQka8gfMa1eatJPovUnYDIWpqfInUnlWMQ8ClHkINjPrQVrPtFk0XbT1KfDmojtAwlFOIsmdKW6g1O/DSwU6EKmuLYQbdZUzfBw8DG88HqlIeLwPeYaWrp8GKejK682dx/0OD29xfzxAx1huwogXHLwOWmuAxAMIoPEHBW8WcWNhPII1sIrQdAyuU792p8kTLZBTqp3DhMmy1vKw3SsvSmq28QNW+wh6t+Ck2urWNA6cAjS2pzeNIAR8bodfdvijOyRCnB/ImKK6fGa+bA5us+9V4W3brshgA9WruSt984YUxpEDWRaYudhQ7R2PGdPFs4uWEdYYMTstvdRc2oSpMR47jYf9r/pC3eEJXHdQcbd7nt1nQt0tCpbTFUrzsmyPapHCNo2WK+GP4J1MnSHF/gqOqB+oLlVLyPe95UKGpAj+A+y6gkBAgpchSMKfykM5iQ2CT6GBbd8kPp4bw4Q78Cq2iaOBteTq2Yn++GlJjPaSR0do8AsV/ccw3hjGZxP9yddyVGzHLCWvr51c0Km99+W7u8//kAwUXzpGRxEU2YaHcr4ZB1nETVVM1xSdxJaHRVPU9yr0ZNSXCsRrwd9x2rfDbz5+igeUg76VYR0nkHnYKsBzfI7Wl3quczlJcujtXj4HSC8BH5PZ6zY/UnkHlPlta6/HWehFr9h3OxtpxTZn3vrwKfDeT6KSaaBfQNqV0FFZCDfpF+w0IcQ9HH2mzZYqKyhsLv+cxeNPm8tjUci/vOjSrYzu02HWLng/hQOr83jhNB9tZWtmZLG86DLapTtabKk82FGNE0Dnl0WCJzKNGdPvuFhwUBUBESY3rjVsbO6iSSQ8lC3qgdR8Y3t4zsRghEdGw/DkKL9+30hMUp+dsSWsu6KsmjOD9x/2nSASA9gQlLXU4dpu6CAJY1wlBFLsWSW/eDDBeSioRoWxritwjiny3z1VacQikTbPh+noBPCv8nG
 MGIYbxjP
 sZ8y5/pzThrp/HxfHL4u2+C5pz40rpBs+lXWDBFrhkk/DAhhfTVgkw44ByIRsq82+R9k2G+2BdXNwe822pzreaUIG5xklP+0qX8gQMzkkW0fooAlMeJ+VM+wkTCNJjoA/qO+Kx1snKqSWM4kjr3BpfGTm9MJSRBFJ0EPRsnXuYhwALHkFYNjzISJaqe2C4393uQjEIcBMtDoTGUlyhVureYtm+zwtGqUEnXN0W9OWTUbArthaBk6Dky2glrl4JTCBCo856fPAOow/T8m4eDY36RLePUp67qpuwQ0+bd+IOR05YXkA/KJ008Mwz7GQhzDZNnzHGwe/NnEkITEP+Wanj1WD6JDVNH0/ZPmwQBuoApDHpA7sI3eYTHBieU7cbV/YZnd15rkK8OnRElefzpwbrcWkTIs8KlRyHnlT84FA8kPLMDqSRegVkevsb+ZRgAJbKLSQnUep1LJvsccNN89mJQz9IKkEwrvmhPKLKMAviHVPBynQg3X4qcqTQ7SxSbcE1SeW5YUEHZSk1oyEhnO8VundSPr6oFi3FCeEPHkKocrVfjbccFAUAiCbVlSTpquES6CS5Bgkw3Dt0s+qYebniG5RHK92BOfwD1oA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/09/2025 10:03, David Hildenbrand wrote:
> On 02.09.25 04:28, Baolin Wang wrote:
>>
>>
>> On 2025/9/2 00:46, David Hildenbrand wrote:
>>> On 29.08.25 03:55, Baolin Wang wrote:
>>>>
>>>>
>>>> On 2025/8/28 18:48, Dev Jain wrote:
>>>>>
>>>>> On 28/08/25 3:16 pm, Baolin Wang wrote:
>>>>>> (Sorry for chiming in late)
>>>>>>
>>>>>> On 2025/8/22 22:10, David Hildenbrand wrote:
>>>>>>>>> Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1),
>>>>>>>>> but not sure
>>>>>>>>> if we have to add that for now.
>>>>>>>>
>>>>>>>> Yeah not so sure about this, this is a 'just have to know' too, and
>>>>>>>> yes you
>>>>>>>> might add it to the docs, but people are going to be mightily
>>>>>>>> confused, esp if
>>>>>>>> it's a calculated value.
>>>>>>>>
>>>>>>>> I don't see any other way around having a separate tunable if we
>>>>>>>> don't just have
>>>>>>>> something VERY simple like on/off.
>>>>>>>
>>>>>>> Yeah, not advocating that we add support for other values than 0/511,
>>>>>>> really.
>>>>>>>
>>>>>>>>
>>>>>>>> Also the mentioned issue sounds like something that needs to be
>>>>>>>> fixed elsewhere
>>>>>>>> honestly in the algorithm used to figure out mTHP ranges (I may be
>>>>>>>> wrong - and
>>>>>>>> happy to stand corrected if this is somehow inherent, but reallly
>>>>>>>> feels that
>>>>>>>> way).
>>>>>>>
>>>>>>> I think the creep is unavoidable for certain values.
>>>>>>>
>>>>>>> If you have the first two pages of a PMD area populated, and you
>>>>>>> allow for at least half of the #PTEs to be non/zero, you'd collapse
>>>>>>> first a
>>>>>>> order-2 folio, then and order-3 ... until you reached PMD order.
>>>>>>>
>>>>>>> So for now we really should just support 0 / 511 to say "don't
>>>>>>> collapse if there are holes" vs. "always collapse if there is at
>>>>>>> least one pte used".
>>>>>>
>>>>>> If we only allow setting 0 or 511, as Nico mentioned before, "At 511,
>>>>>> no mTHP collapses would ever occur anyway, unless you have 2MB
>>>>>> disabled and other mTHP sizes enabled. Technically, at 511, only the
>>>>>> highest enabled order would ever be collapsed."
>>>>> I didn't understand this statement. At 511, mTHP collapses will occur if
>>>>> khugepaged cannot get a PMD folio. Our goal is to collapse to the
>>>>> highest order folio.
>>>>
>>>> Yes, I’m not saying that it’s incorrect behavior when set to 511. What I
>>>> mean is, as in the example I gave below, users may only want to allow a
>>>> large order collapse when the number of present PTEs reaches half of the
>>>> large folio, in order to avoid RSS bloat.
>>>
>>> How do these users control allocation at fault time where this parameter
>>> is completely ignored?
>>
>> Sorry, I did not get your point. Why does the 'max_pte_none' need to
>> control allocation at fault time? Could you be more specific? Thanks.
> 
> The comment over khugepaged_max_ptes_none gives a hint:
> 
> /*
>  * default collapse hugepages if there is at least one pte mapped like
>  * it would have happened if the vma was large enough during page
>  * fault.
>  *
>  * Note that these are only respected if collapse was initiated by khugepaged.
>  */
> 
> In the common case (for anything that really cares about RSS bloat) you will just a
> get a THP during page fault and consequently RSS bloat.
> 
> As raised in my other reply, the only documented reason to set max_ptes_none=0 seems
> to be when an application later (after once possibly getting a THP already during
> page faults) did some MADV_DONTNEED and wants to control the usage of THPs itself using
> MADV_COLLAPSE.
> 
> It's a questionable use case, that already got more problematic with mTHP and page
> table reclaim.
> 
> Let me explain:
> 
> Before mTHP, if someone would MADV_DONTNEED (resulting in
> a page table with at least one pte_none entry), there would have been no way we would
> get memory over-allocated afterwards with max_ptes_none=0.
> 
> (1) Page faults would spot "there is a page table" and just fallback to order-0 pages.
> (2) khugepaged was told to not collapse through max_ptes_none=0.
> 
> But now:
> 
> (A) With mTHP during page-faults, we can just end up over-allocating memory in such
>     an area again: page faults will simply spot a bunch of pte_nones around the fault area
>     and install an mTHP.
> 
> (B) With page table reclaim (when zapping all PTEs in a table at once), we will reclaim the
>     page table. The next page fault will just try installing a PMD THP again, because there is
>     no PTE table anymore.
> 
> So I question the utility of max_ptes_none. If you can't tame page faults, then there is only
> limited sense in taming khugepaged. I think there is vale in setting max_ptes_none=0 for some
> corner cases, but I am yet to learn why max_ptes_none=123 would make any sense.
> 
> 

For PMD mapped THPs with THP shrinker, this has changed. You can basically tame pagefaults, as when you encounter
memory pressure, the shrinker kicks in if the value is less than HPAGE_PMD_NR -1 (i.e. 511 for x86), and
will break down those hugepages and free up zero-filled memory. I have seen in our prod workloads where
the memory usage and THP usage can spike (usually when the workload starts), but with memory pressure,
the memory usage is lower compared to with max_ptes_none = 511, while still still keeping the benefits
of THPs like lower TLB misses.

I do agree that the value of max_ptes_none is magical and different workloads can react very differently
to it. The relationship is definitely not linear. i.e. if I use max_ptes_none = 256, it does not mean
that the memory regression of using THP=always vs THP=madvise is halved.



