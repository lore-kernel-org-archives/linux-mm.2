Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D592ACA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7B48E0010; Tue,  2 Sep 2025 16:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398748E0001; Tue,  2 Sep 2025 16:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25FEE8E0010; Tue,  2 Sep 2025 16:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0EB5D8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:23:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8F3116039C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:23:12 +0000 (UTC)
X-FDA: 83845434624.06.4EE4114
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id A617740005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:23:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZFDCG+0Z;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756844590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3kOiwL5zqleYtylmerMclyHJqoKO1uL5DJ0d9m4VY4=;
	b=Aupxez8r+dqObfePcmQZJbfsDxeoKp38NfHcKOjDktNBO8bbVkCSVQk6Fqsu+t3A0Po8kz
	YnTELMGnNNeFmaBS317J5L34mREjHKaRcokDJ1ynmmZ9G1ON0lSqjfaKo1llmBjmWRTXSk
	3t67r4nmrzXl3eQxlNSvyQ1EKy485lM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZFDCG+0Z;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756844590; a=rsa-sha256;
	cv=none;
	b=jV8NYWnEG4XivrgzlIQV/NK+JM+4zDWaRA2XN9JCZmgws65SGm7ZwMl0myBiRAQT4xK74g
	ZpbU8fX6kLODuhITiW0RKqtUOYovFzE7kDlTxTtKOqHYq0jb9ycQ3C5uGmn5gVulhgCwB+
	T2m781KbpuoEfYrR+BbDxCQcDpk4pSE=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45b86157e18so19519145e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 13:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756844589; x=1757449389; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e3kOiwL5zqleYtylmerMclyHJqoKO1uL5DJ0d9m4VY4=;
        b=ZFDCG+0ZbIJGh4RlIKCuWnSPWcQJ7LvV28OZ7xNYxi60s/toif4drDmq5WZA/LPWVk
         xjKwIQArld9ySDT/ejds0MpndH4iy5emDaKEnBpbtrffR69eZ/jJJUjPFvDF7upbCNKz
         jRs94F6Wjru2oR75/0pz8/7gbV9FY93STTSrU3JHwm6QbkZL7eHNbr1LgBoyKYPM6LeX
         RREIyO5aBG04cIwekXrO9qD/Z3IqIGQ/BQuwt3iYXLn7k/SAZ1AGqsUnlfSunWjRMczN
         aX4jPESRhEsg5rOEhshMWgqMNQ06Ba/dIATcIdfsRGdpzzKoQrcY1qpGrbBcbd1C/ryj
         B+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756844589; x=1757449389;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e3kOiwL5zqleYtylmerMclyHJqoKO1uL5DJ0d9m4VY4=;
        b=SLd0QM4qGJQfhp/I5zFhB8AsLANioczIu6GDGtpcsSbb6bJNRRzwG+1swgLkwz25i8
         l3LyT3IC026CFZSv0DAs2BGQxuMT+c3akZcxUh1epjNqxO4vHEsVZ/pIHRR2E+mcEZi4
         XZH1LWrH7dzXjYnUWYWp30Q7KWwdpLSBysxTZs3Hg/saP1BvV4HJyEwB5Azh8JFYQLTA
         VexIb9wgFyNHI1EBg7Li9ZqO4KT0ZAeESSP8EwRJKqml4EsP3VWY9pXiCUrbghuwq8Pp
         o9EX7hyEJAKG0YWY2Gef5yaa+OIbqIxhqia4wVgePBMtVbMz+yJcoZXCEXW7R//boHwh
         vLsQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/++LlO0TcF/jmOv3m2fm4Btf6D2+VANULGUA6R9X+6RGg1xeUHFUFBjDbuBUmPRFX5sxI4h5Fyw==@kvack.org
X-Gm-Message-State: AOJu0YxSMlgsQhjWWa8VNvkL4xVCVMZ/Fx/qt3bQYjgvm9SNfw5+rGhp
	RjY/GBs5y3RtoN54KU1fx4EjtGzvBQkPZBzwYhlxNOQZ4vlip0PvTygd
X-Gm-Gg: ASbGncs2GltfFW9urah/jL/2w9k8uVY4by5T3p44piPZFoYhMEM4QtgNBBSQTvDnS6w
	sAKBmFcHl1/tbXI513aDwW/t6exIe2VAzqJP1/AqE0Ulhy5BKY+Oxm5c3qJUovWJ4ZiZEeO/N6B
	emhaadH3Xrza8JUbiPVBLV673UCW5jypy0TsATUz9u2gFXZknKzueUI/Z6ch8XbziVOMvCjz0gV
	uGuhjRAc9phbFqceYOeBib5ar+IxVQ+aaW1k+ZrE5SzYR8VXZlYIzAF5l1q++a3vL19cdmVFbfG
	wfpBviuOzDqbX4xHnkBeGr5o+U6zbZvGpmvKl6ujz6lpXJ2+VqgJo8BjiZPEbHGUq4vW8zfR7L2
	1zAVircWaapV6shqbCnGp/VDg7rF5FdzgoVXnjz4C2FPKtL/Qc3aL4T2+OIWT/2ZX7Ja93E12An
	H6zk6rcI66sesIDP8MISvmHtFafdOZ
X-Google-Smtp-Source: AGHT+IEh5zVEDLWkkm40Gzc0xQdpKMazKhJsQrIOonj4uGsn8SXP4VX6pG/odlqnt8wetWFbUq75gQ==
X-Received: by 2002:a05:600c:4705:b0:45b:74fc:d6ec with SMTP id 5b1f17b1804b1-45b8553f1e8mr116428895e9.8.1756844588788;
        Tue, 02 Sep 2025 13:23:08 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23? ([2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b81a9e971sm211259005e9.18.2025.09.02.13.23.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 13:23:08 -0700 (PDT)
Message-ID: <ad6ed55e-2471-46be-b123-5272f3052e01@gmail.com>
Date: Tue, 2 Sep 2025 21:23:04 +0100
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
 <17075d6a-a209-4636-ae42-2f8944aea745@gmail.com>
 <287f3b64-bc34-48d9-9778-c519260c3dba@redhat.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <287f3b64-bc34-48d9-9778-c519260c3dba@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A617740005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: t7mifzw1mnupjxpriu386481e4mmysxn
X-HE-Tag: 1756844590-628930
X-HE-Meta: U2FsdGVkX18DS9ltlwZaWwm1DdDsOxOgo1LNF47Fp0BMGMlAsi4NuMvWu8WEvS4zjc98v5d5M0pDYEBTDf14k3KldBmM1YlJ8yTcit1+o34xjWb50G0UTOvVoUj6ZiCHhDcPkH588lCP9u7Cv/LHhsxY98OFwoBb6SB5YHTO+dkfdMwzWgA/fWRXEGq6+U3Y+yBt6uW/QPAQis3az65vTmn6UnHtnutLbEkVtDHe1MneXyvvQMfnoQ4EN6Yi7LInVvRyF5rF/zazUfDzuT2ob5KOzbZEw1dHXK3/0Eihh4RTItQVX9Pu9EhW+ZRzy+5fOO5B/+NEG8+Af7c2W4S8ptqv9mpVcOulcwuZQfj9fKBlfgjg76B3Wf/EqmnM25pow38hyvy2FRYievmAJ9ZAvlo1r1dSpPTdolCmw4lNT0cCFqHAhF3f8XL4bCm3aTDXP8gNuYyNeBRZOEIW/NjViHHwNWrYdweH83ErQtiiVZCoeF4GG6xwTjUN2ibFWtxb4h/XUXvyaLkWibFtUm55tDMufjqbn54GWIYzwkayY58mGxJmWlWBb9w/Gd5Cz2o9XIY5Ogq72gdcoXqZyGAZ0YcoMCcNdHfYbFopxscWuvdWTqqS+g258LCqQh4p6LJhFNvFwUhOdMyRGvcCNgb6xeFMsTNzsG9v8oU7/OQHYnHBBOR/vuhPztp0bhx9vHh7cn1WoyGj6Ttc8Yhs1cRDfA/KXIbVAZbzb/99G+Y+EufWWKLCdOVmMZyaSD6UV67yY+TXtmrs25tRORQ8o36vdS48hlS3r/sJ3TAY1fnNRT9ghJgjzN+oXznl9ZqjP83BaiGRlj/TgjTPPrncTGnvCRXLcAH+sCQWBI4s6CiXPqBoND9FCczr90tGbJhzKraL/Gu0AGGQm61He1q/nX2X6L0a85qFx5XNm9xvqAcAnDRWVbE2xB9wCc/qwbdjNqYFg9dXVYfBNBpwPUnemwC
 l3yNpNWY
 DCKD6M7HEB6hwOWS9l9pXam861iG9c/P0c+9eb32KBa8bm5aSuKu9rwTHos3Jq8QOAVMKOCuf303oSFgZvg8USgHqCoXuCBQhwrfUgXtP7Xj0QnLRjDL8Bm0BM0rsKlSfbm7eWMDadDp0L8cE+wzwGvGQXFgoLh9hmJQhZAd58DkEfcLgc+pIfYgjWGhYiIqLzkdbxZD1pZeMr6n0lvhoOVm5BWZtxNs2BTFL6EWtB7oDzufD5rwJLHJfUllhDIBqEhnUJqZ9yAuUVZ3OMNqV7aEsHnVZbxXZGl8Xrqs0b1YQUPThgiWVrBDJJtDVYjx5UWlzIm1ciy7jcP/H49blhzBpWvAHKHduR5QZlFhJyFQ4RL9nhHpD16APbnAKaLoJcYPNaivDEE98ubG0w47DGohHw5hJsu7Lr6rmMl4/kVJERkwPz3icxNvfQrzKd/kyIfXiK5HjhJcAgmrypwNJ+fkYCNSPiPgTM4hN2gjPNKnklc+SpuDHcQglKSEnm4NS0bvw7NFQausWJT07EnvAtwdFLZuCcPi9X5R15STwPztntBBHt1u5we1AxAsKL1tsoXjuAfbtElmhXcuQhKu8OIQXTsW2+ss34by7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/09/2025 12:03, David Hildenbrand wrote:
> On 02.09.25 12:34, Usama Arif wrote:
>>
>>
>> On 02/09/2025 10:03, David Hildenbrand wrote:
>>> On 02.09.25 04:28, Baolin Wang wrote:
>>>>
>>>>
>>>> On 2025/9/2 00:46, David Hildenbrand wrote:
>>>>> On 29.08.25 03:55, Baolin Wang wrote:
>>>>>>
>>>>>>
>>>>>> On 2025/8/28 18:48, Dev Jain wrote:
>>>>>>>
>>>>>>> On 28/08/25 3:16 pm, Baolin Wang wrote:
>>>>>>>> (Sorry for chiming in late)
>>>>>>>>
>>>>>>>> On 2025/8/22 22:10, David Hildenbrand wrote:
>>>>>>>>>>> Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1),
>>>>>>>>>>> but not sure
>>>>>>>>>>> if we have to add that for now.
>>>>>>>>>>
>>>>>>>>>> Yeah not so sure about this, this is a 'just have to know' too, and
>>>>>>>>>> yes you
>>>>>>>>>> might add it to the docs, but people are going to be mightily
>>>>>>>>>> confused, esp if
>>>>>>>>>> it's a calculated value.
>>>>>>>>>>
>>>>>>>>>> I don't see any other way around having a separate tunable if we
>>>>>>>>>> don't just have
>>>>>>>>>> something VERY simple like on/off.
>>>>>>>>>
>>>>>>>>> Yeah, not advocating that we add support for other values than 0/511,
>>>>>>>>> really.
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Also the mentioned issue sounds like something that needs to be
>>>>>>>>>> fixed elsewhere
>>>>>>>>>> honestly in the algorithm used to figure out mTHP ranges (I may be
>>>>>>>>>> wrong - and
>>>>>>>>>> happy to stand corrected if this is somehow inherent, but reallly
>>>>>>>>>> feels that
>>>>>>>>>> way).
>>>>>>>>>
>>>>>>>>> I think the creep is unavoidable for certain values.
>>>>>>>>>
>>>>>>>>> If you have the first two pages of a PMD area populated, and you
>>>>>>>>> allow for at least half of the #PTEs to be non/zero, you'd collapse
>>>>>>>>> first a
>>>>>>>>> order-2 folio, then and order-3 ... until you reached PMD order.
>>>>>>>>>
>>>>>>>>> So for now we really should just support 0 / 511 to say "don't
>>>>>>>>> collapse if there are holes" vs. "always collapse if there is at
>>>>>>>>> least one pte used".
>>>>>>>>
>>>>>>>> If we only allow setting 0 or 511, as Nico mentioned before, "At 511,
>>>>>>>> no mTHP collapses would ever occur anyway, unless you have 2MB
>>>>>>>> disabled and other mTHP sizes enabled. Technically, at 511, only the
>>>>>>>> highest enabled order would ever be collapsed."
>>>>>>> I didn't understand this statement. At 511, mTHP collapses will occur if
>>>>>>> khugepaged cannot get a PMD folio. Our goal is to collapse to the
>>>>>>> highest order folio.
>>>>>>
>>>>>> Yes, I’m not saying that it’s incorrect behavior when set to 511. What I
>>>>>> mean is, as in the example I gave below, users may only want to allow a
>>>>>> large order collapse when the number of present PTEs reaches half of the
>>>>>> large folio, in order to avoid RSS bloat.
>>>>>
>>>>> How do these users control allocation at fault time where this parameter
>>>>> is completely ignored?
>>>>
>>>> Sorry, I did not get your point. Why does the 'max_pte_none' need to
>>>> control allocation at fault time? Could you be more specific? Thanks.
>>>
>>> The comment over khugepaged_max_ptes_none gives a hint:
>>>
>>> /*
>>>   * default collapse hugepages if there is at least one pte mapped like
>>>   * it would have happened if the vma was large enough during page
>>>   * fault.
>>>   *
>>>   * Note that these are only respected if collapse was initiated by khugepaged.
>>>   */
>>>
>>> In the common case (for anything that really cares about RSS bloat) you will just a
>>> get a THP during page fault and consequently RSS bloat.
>>>
>>> As raised in my other reply, the only documented reason to set max_ptes_none=0 seems
>>> to be when an application later (after once possibly getting a THP already during
>>> page faults) did some MADV_DONTNEED and wants to control the usage of THPs itself using
>>> MADV_COLLAPSE.
>>>
>>> It's a questionable use case, that already got more problematic with mTHP and page
>>> table reclaim.
>>>
>>> Let me explain:
>>>
>>> Before mTHP, if someone would MADV_DONTNEED (resulting in
>>> a page table with at least one pte_none entry), there would have been no way we would
>>> get memory over-allocated afterwards with max_ptes_none=0.
>>>
>>> (1) Page faults would spot "there is a page table" and just fallback to order-0 pages.
>>> (2) khugepaged was told to not collapse through max_ptes_none=0.
>>>
>>> But now:
>>>
>>> (A) With mTHP during page-faults, we can just end up over-allocating memory in such
>>>      an area again: page faults will simply spot a bunch of pte_nones around the fault area
>>>      and install an mTHP.
>>>
>>> (B) With page table reclaim (when zapping all PTEs in a table at once), we will reclaim the
>>>      page table. The next page fault will just try installing a PMD THP again, because there is
>>>      no PTE table anymore.
>>>
>>> So I question the utility of max_ptes_none. If you can't tame page faults, then there is only
>>> limited sense in taming khugepaged. I think there is vale in setting max_ptes_none=0 for some
>>> corner cases, but I am yet to learn why max_ptes_none=123 would make any sense.
>>>
>>>
>>
>> For PMD mapped THPs with THP shrinker, this has changed. You can basically tame pagefaults, as when you encounter
>> memory pressure, the shrinker kicks in if the value is less than HPAGE_PMD_NR -1 (i.e. 511 for x86), and
>> will break down those hugepages and free up zero-filled memory.
> 
> You are not really taming page faults, though, you are undoing what page faults might have messed up :)
> 
> I have seen in our prod workloads where
>> the memory usage and THP usage can spike (usually when the workload starts), but with memory pressure,
>> the memory usage is lower compared to with max_ptes_none = 511, while still still keeping the benefits
>> of THPs like lower TLB misses.
> 
> Thanks for raising that: I think the current behavior is in place such that you don't bounce back-and-forth between khugepaged collapse and shrinker-split.
> 

Yes, both collapse and shrinker split hinge on max_ptes_none to prevent one of these things thrashing the effect of the other.

> There are likely other ways to achieve that, when we have in mind that the thp shrinker will install zero pages and max_ptes_none includes
> zero pages.
> 
>>
>> I do agree that the value of max_ptes_none is magical and different workloads can react very differently
>> to it. The relationship is definitely not linear. i.e. if I use max_ptes_none = 256, it does not mean
>> that the memory regression of using THP=always vs THP=madvise is halved.
> 
> To which value would you set it? Just 510? 0?
> 

There are some very large workloads in the meta fleet that I experimented with and found that having
a small value works out. I experimented with 0, 51 (10%) and 256 (50%). 51 was found to be an optimal
comprimise in terms of application metrics improving, having an acceptable amount of memory regression and
improved system level metrics (lower TLB misses, lower page faults). I am sure there was a better value out
there for these workloads, but not possible to experiment with every value.

In terms of wider rollout across the fleet, we are going to target 0 (or a very very small value)
when moving from THP=madvise to always. Mainly because it is the least likely to cause a memory regression as
THP shrinker will deal with page faults faulting in mostly zero-filled pages and khugepaged wont collapse
pages that are dominated by 4K zero-filled chunks. 


