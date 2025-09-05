Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DCDDCA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 12:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF1A28E0008; Fri,  5 Sep 2025 08:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA26B8E0001; Fri,  5 Sep 2025 08:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943238E0008; Fri,  5 Sep 2025 08:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3738E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:39:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFB0183F23
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:38:59 +0000 (UTC)
X-FDA: 83855151198.29.D14C0FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5AE63C000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:38:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="b/MM0b5n";
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757075937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6snvWLEWnQ8R9SKAeGg2E7wEesWjYiyxgM50DESCJmU=;
	b=6sUY6EKGU+wqrvVreLfsxZBUAWqEVWG4KIQ+jouDNfG/hAec5uysmYrsd4S96Hdcut5yMd
	6vMneqtNXHIAwE0hEZECXYX1WTbHkxjfAKVQbZyuVS3vi0oTH3S7hW4wA3xyw7xdwgOMwd
	VBeiNLEoVNeAiTrWqoifwtgdmHaZ9Jw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757075937; a=rsa-sha256;
	cv=none;
	b=UIpAqSzw4iEQPm7CdGq9gc9B0P35qfNM1D7sBTssmuoOHlt1RJHxtkmQN/kTCmv88GU8Bk
	5G1Es9nKpt/7OFsDnOXk4hFcmGZzEji4X+1El+3I67tHT+rEFs0YrsuljVChozyeejXBqk
	OTNNRUNgxhv4iHbPtN/hfNIElvdViys=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="b/MM0b5n";
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757075936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6snvWLEWnQ8R9SKAeGg2E7wEesWjYiyxgM50DESCJmU=;
	b=b/MM0b5n3fSyG+r9B7cYKQsNHSwyVlZBQzRfJT5efwZ8W4i8XkjoUZYglg6YbPu0oorvyR
	HhvgEBaZsNrmgkarwyrJfZuPFe/fqwF+XDqn6Xg9fm7/ghpi2c1uuRyAAkdKUGTZzvaZiy
	KmTHrqUe2GRfzwENz6TQvEviM+zqS84=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-gegfcxmQOkqK5H6W38xPdg-1; Fri, 05 Sep 2025 08:38:55 -0400
X-MC-Unique: gegfcxmQOkqK5H6W38xPdg-1
X-Mimecast-MFC-AGG-ID: gegfcxmQOkqK5H6W38xPdg_1757075934
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e40057d90aso266738f8f.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 05:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757075934; x=1757680734;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6snvWLEWnQ8R9SKAeGg2E7wEesWjYiyxgM50DESCJmU=;
        b=svcHwm4EiMvPODiTRae9wyrl4uF0sP9jtQBoEkkMLUiAkzD1EoalfEGY0VA62eVeW7
         wbJNx1cTsdZhJf7WYDZlj77nbbRaj87zRN/qhx9GzUT1GLieVdQB3co96fFAoG6bxvuZ
         x9Hvn5ZR0OeLWrq9zTz6+lnsz79QpDN6T0jROwsEZSxirTTzVQh2aaxD8eU+sc8erO+0
         JHSRwz0a3Krx1P1tRCENd7EYhKXsrswaGQuOMSpb5vU3fCSN1Z9N9twyI/Pjo4ZL3GZy
         USX4TqoexkuisbddYEohVO/dohPG2xxWATH3h5CZufRrPMssBw0P8OLk6vMsFn6u/Dnv
         XD2Q==
X-Forwarded-Encrypted: i=1; AJvYcCW34i7aS76S52iveFMEbBPbAqt6OUoVGMlCeNAoN7M3dWirIkEFgBMHLRI/x/lN6XcWS89sAAgeEA==@kvack.org
X-Gm-Message-State: AOJu0YwU6CPzVIo3hUL85qw61ZFYeDW80uWwqGyMDKVT6P07x6xUpGuG
	eYBJzsmIolB1BGNw9WHZiiRfB3riBhgSFVgNmJ6QkXQIAqvJltwz+rbUpCsBEg8H7xsuQyWUiRT
	UqnJneM4cil5WlkCBk6dXyXrf+FHdBJ2NnPXHlblmZfYPcvEZABaJ
X-Gm-Gg: ASbGnctPFmanccqeD8/dPewo+ZymXpFX/jJUNfzXEp3CC7CRWSXmhydpaXl7FxNgfCb
	ypZ9KMVNs648F8Cy4QZcNbnq8R996LrJTZvH3kCIOymdqEcxwIJyh5+IiCWaM078oAAqavJhpN0
	IMr0jpXwMaYRLm94AknVuM/ScBzSRb+HzhzUu7E7sFCcnizdS9u4NapH2307G5SHjBns2Xva5c/
	a3ld9g7WO6z6VEqec2gM/VpyIUjw+FI+Tr+iZMiWbb08FMR68wtNxgF3EmRLmpFqTlF//tgSr7s
	ibRKsXR2yvpE/TZ3iRsAoolQ8z/lpz/HFnzpUfjR9aVt0V1Ms6+zUVtpDhTJuUIfULFn2xLgwQZ
	HbK3q6YLQVmYk5CTRUVfvZQeQ4SmbqU1Zk73vpYPnz+PaaMOcHUN/wnxf
X-Received: by 2002:a05:6000:178c:b0:3d7:f363:2f0d with SMTP id ffacd0b85a97d-3d7f363361dmr12009709f8f.28.1757075934208;
        Fri, 05 Sep 2025 05:38:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPRAo1/FEwKPT8167eG3CiF7EnCpIk1sO63oxm+Ap3csbu4tc3YQieqLS+bjZktZf+gj9E+g==
X-Received: by 2002:a05:6000:178c:b0:3d7:f363:2f0d with SMTP id ffacd0b85a97d-3d7f363361dmr12009660f8f.28.1757075933652;
        Fri, 05 Sep 2025 05:38:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4d:e00:298:59cc:2514:52? (p200300d82f4d0e00029859cc25140052.dip0.t-ipconnect.de. [2003:d8:2f4d:e00:298:59cc:2514:52])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3df4fd372c1sm9458282f8f.29.2025.09.05.05.38.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 05:38:53 -0700 (PDT)
Message-ID: <fbafc497-00c9-4612-8e9b-16d86770321d@redhat.com>
Date: Fri, 5 Sep 2025 14:38:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Usama Arif <usamaarif642@gmail.com>,
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
 <71d11a43-e9ff-46e5-988d-b39905e10f61@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <71d11a43-e9ff-46e5-988d-b39905e10f61@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kh0IMwN44p7FFmeNHUyKBtn70r034txlM4VH4Srd9kE_1757075934
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AE63C000A
X-Stat-Signature: ozon9umzj8ah3ht88okwmg5wszd1aw3m
X-HE-Tag: 1757075937-336902
X-HE-Meta: U2FsdGVkX1+74Sh39jCVdVNmkOte4iT8EawVIJUKXN4Hpke9dRtd7yWON0V3jg2tqoJbLqw9Hw5hTpMw9E9EKuMNXSTh/nnKPm9keoUQ3GZikx0daCz56Q9X1KCCFFEJmzADETUVlDjDN0/Vo/LeVvSqJ4PWXDdWHyfr7bngqQjfNsf9+rZPptIlxEKvrdPGiZDFGAQES1wzEZhm9WCHYKpNif7oicNbJLbrA6BTTzjfTA1R78hgwlqVUd0H6wyVNiH5qyVuC8HHN+aHUvAYEliuDuwwPFHm5XRAM3Ne1aXYofDs7EgIZNfRFb9G8xr2wV6gzuSc4hDq4zxtyWcMtDAixXmxzzAbaOAZ0MxD3nEHwsOuwFKd2ZVu8ZGY3PaA100dlm/qoeBMGVmVk6JnvzOblofv0fermUP1/JnDN5BhEaCrjBMAVsQVKrSP3KpbmGcbntrPQGUh19BaT45a0Wvas//Guzjip05exLoxSYKZVs6NQa/Q52vsxTKjqss+cXC94a/EPohfJKbBaSHreuK0d+XfnnwLveMdMSpGvOXcDqkO5+0bmCrdlo5hCCfX26j8yLPOsfX+yrELff72FbTDfrBzt6Tkk1m7TAD5mvvzMc0L5XKunjwY38u98kkVtHuOalMyNDVcxPLxJivdV2f9AarVQEfN4+pa/1BPrY6g/+0UF6i2/5V/Emvw/hf0pnGSdczmMWufiNDsPiEDbKFxrwSu9rvmw80CvYZWQMWbqfT26i99SHq1zRpnAQGnVBa0bufQP3rw3OSujdRtVV9BqMaxdxnrwqxCvjOXuKuAEPuRcuuN4J0sdW6f6+nJ3xIPfRRp4dBYLhcDyRrAM14bR9LJkPYtN6ASHclUVFGAtXZ7Ke9M/lNiInXbZIuAzgmLLRPiGsZN2HqF6y6dw4Vp1jsJ005Xr2HoCgmz6jGEE7A77oLyI9gVr2YXjQBr35YX+oxrs2iETifuKMj
 sAoYIUI8
 E1Fk2wKSdkPAud9od8SkuJP2eRW4xczi2CtL93GOJH+cLJeitRYANyrrWvuwKY4UqxlHLy57Odi0VNbHwozRYkxMnfRqVnGjzB8Ls/uRW7BpxjUvupgvHgefdglbJ3fURz3nFdiE7d5lpowqltIAx2DnUtr7Fbjh2fnpQb/NO41/VTmtFI9MT6uq2N9z3ZBj8Z+iBefLuAfMEiv87t0tUMesr4WJOVTcL7sYUwZkab88FYZrKV2Sc3Xffx6AP2Es3DrtOVPUFeNF0bgSFPRJ4lkwVRbt66h7DCG8mkT9k8dvKPVmgaTlIX9P8fFm/+IC7SQwduA3mTMlrMmvmvX3g8YsJJyiTSz0500HZ7Ubkmvo+NNgsldPIHAN8vS+KQN+4rrqKapq0Wi+/KZkUXiwlKTr0o+wEB1iD56poQ4/LrOouumVB1aGDZNFMa7n9LaAessQUCPuXiX3fp+SjBQGNLwRk0oefPHXGsY1ZRQEEnXFOv/oGNz3uo9vn3sbnDdgxf0eqHeOiNcBTZRIy40FQC/MX3oWTwCePeZrCjz8/oHzPdBo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 14:31, Usama Arif wrote:
> 
> 
> On 05/09/2025 12:55, David Hildenbrand wrote:
>> On 05.09.25 13:48, Lorenzo Stoakes wrote:
>>> On Wed, Sep 03, 2025 at 08:54:39PM -0600, Nico Pache wrote:
>>>> On Tue, Sep 2, 2025 at 2:23 PM Usama Arif <usamaarif642@gmail.com> wrote:
>>>>>>>> So I question the utility of max_ptes_none. If you can't tame page faults, then there is only
>>>>>>>> limited sense in taming khugepaged. I think there is vale in setting max_ptes_none=0 for some
>>>>>>>> corner cases, but I am yet to learn why max_ptes_none=123 would make any sense.
>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>> For PMD mapped THPs with THP shrinker, this has changed. You can basically tame pagefaults, as when you encounter
>>>>>>> memory pressure, the shrinker kicks in if the value is less than HPAGE_PMD_NR -1 (i.e. 511 for x86), and
>>>>>>> will break down those hugepages and free up zero-filled memory.
>>>>>>
>>>>>> You are not really taming page faults, though, you are undoing what page faults might have messed up :)
>>>>>>
>>>>>> I have seen in our prod workloads where
>>>>>>> the memory usage and THP usage can spike (usually when the workload starts), but with memory pressure,
>>>>>>> the memory usage is lower compared to with max_ptes_none = 511, while still still keeping the benefits
>>>>>>> of THPs like lower TLB misses.
>>>>>>
>>>>>> Thanks for raising that: I think the current behavior is in place such that you don't bounce back-and-forth between khugepaged collapse and shrinker-split.
>>>>>>
>>>>>
>>>>> Yes, both collapse and shrinker split hinge on max_ptes_none to prevent one of these things thrashing the effect of the other.
>>>> I believe with mTHP support in khugepaged, the max_ptes_none value in
>>>> the shrinker must also leverage the 'order' scaling to properly
>>>> prevent thrashing.
>>>
>>> No please do not extend this 'scalling' stuff somewhere else, it's really horrid.
>>>
>>> We have to find an alternative to that, it's extremely confusing in what is
>>> already extremely confusing THP code.
>>>
>>> As I said before, if we can't have a boolean we need another interface, which
>>> makes most sense to be a ratio or in practice, a percentage sysctl.
>>>
>>> Speaking with David off-list, maybe the answer - if we must have this - is to
>>> add a new percentage interface and have this in lock-step with the existing
>>> max_ptes_none interface. One updates the other, but internally we're just using
>>> the percentage value.
>>
>> Yes, I'll try hacking something up and sending it as an RFC.
>>
>>>
>>>> I've been testing a patch for this that I might include in the V11.
>>>>>
>>>>>> There are likely other ways to achieve that, when we have in mind that the thp shrinker will install zero pages and max_ptes_none includes
>>>>>> zero pages.
>>>>>>
>>>>>>>
>>>>>>> I do agree that the value of max_ptes_none is magical and different workloads can react very differently
>>>>>>> to it. The relationship is definitely not linear. i.e. if I use max_ptes_none = 256, it does not mean
>>>>>>> that the memory regression of using THP=always vs THP=madvise is halved.
>>>>>>
>>>>>> To which value would you set it? Just 510? 0?
>>
>> Sorry, I missed Usama's reply. Thanks Usama!
>>
>>>>>>
>>>>>
>>>>> There are some very large workloads in the meta fleet that I experimented with and found that having
>>>>> a small value works out. I experimented with 0, 51 (10%) and 256 (50%). 51 was found to be an optimal
>>>>> comprimise in terms of application metrics improving, having an acceptable amount of memory regression and
>>>>> improved system level metrics (lower TLB misses, lower page faults). I am sure there was a better value out
>>>>> there for these workloads, but not possible to experiment with every value.
>>>
>>> (->Usama) It's a pity that such workloads exist. But then the percentage solution should work.
>>
>> Good. So if there is no strong case for > 255, that's already valuable for mTHP.
>>
> 
> tbh the default value of 511 is horrible. I have thought about sending a patch to change it to 0 as default
> in upstream for sometime, but it might mean that people who upgrade their kernel might suddenly see
> their memory not getting hugified and it could be confusing for them?

511 is just what a page fault would have done, so I think it makes 
perfect sense. More than anything else, actually.

It's just not optimal in many cases.

-- 
Cheers

David / dhildenb


