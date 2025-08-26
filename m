Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A30CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 08:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D1C8E00BE; Tue, 26 Aug 2025 04:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EC688E00A8; Tue, 26 Aug 2025 04:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08ECD8E00BE; Tue, 26 Aug 2025 04:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E35F38E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:58:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80F0C140678
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:58:57 +0000 (UTC)
X-FDA: 83818308714.05.750330C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0358B80008
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:58:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EHmDns9a;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756198735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u6DhMQqf4kE9o5bOd+TGyYyx2g/lhdZyacoVC48D9gw=;
	b=GKHf+8GeNjiWneT0W0y/6vzlQque1zO/VC8zN4V8OXcgFPOCNb0PK/2GffFjbUn8Zg+J0t
	5hchesJKrgJQeDhuvA/SU6q41cvXvFHIDdmI0L+GOScG0Ywyc3kwX77c+kO+8iMi2ARuha
	zPb0FXkcBSzYvJzk1abr7nOp6P0Nd/w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EHmDns9a;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756198735; a=rsa-sha256;
	cv=none;
	b=mOMlUfKqXA29EPd/XgwcKKfSKase/thJ92kBV4+mcjvzLgXVsoTrGCT+/8rxyuLHyRwOmg
	VIgVcO262eD5dN4sYXktuJXooj9uHZTPgDoHM5B34j5TzPFzCp3N5ZYb0EIPuFDq17O3cl
	uFBoz0Z8TQw8PIn95qv/2vO40b16ey4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756198734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=u6DhMQqf4kE9o5bOd+TGyYyx2g/lhdZyacoVC48D9gw=;
	b=EHmDns9aSBxFqIc4u7MORHODh+5Gf2p2XWutSi3jrHFjtfUsXtViFrSKvNg1om3sSo8voI
	Up646wzx1AtibqDIqUlnGJQ68hyxV5Lp5ni7lUWSCjBWnnKjN8da6vejUiqSttk0xUiEEF
	kYAZ5sZlk8M6ONi9P760ABSEUDkSqT4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-VvP3A6pSO3SUONQu2SpTiQ-1; Tue, 26 Aug 2025 04:58:52 -0400
X-MC-Unique: VvP3A6pSO3SUONQu2SpTiQ-1
X-Mimecast-MFC-AGG-ID: VvP3A6pSO3SUONQu2SpTiQ_1756198731
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0b14daso25601125e9.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 01:58:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756198731; x=1756803531;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u6DhMQqf4kE9o5bOd+TGyYyx2g/lhdZyacoVC48D9gw=;
        b=qW6x5rkBr9CuxvhxSKKKte+j0RntE3fAiONvCfElDw8fS1MrPgqMEegHZq3uZ6hRB9
         zNu2hhGuiX5rPd20g7O8Ts1Q6Lm5VKuKeMASeBb5eJzpYQjvAWz5jxGYrh+KDIlWhVJE
         1jMM4KRMIS0veE0j2adKYYbCuavHguOsm07IgCi4lOisqKzJWyzKA0YWiEBhH2T19PZd
         K/EEGmUo4CDapYtLCEiPJeGV0aluNMLh9gmwZxIc9bytnG4VSn9kh3ilntiegj/mfivG
         KE2FU3zSFNHx621Nlq5XXB/xncxDd06CkzLWSXoUIRjMzfdT0lTYeYe600J42gucsEJT
         WR2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXIf8B6cOUDaMNfOlL2LczcPiW6QNxtqzcbChb8GACmay0/IPKu0wZHX1dzTn2OBwbG2iAOeB14LA==@kvack.org
X-Gm-Message-State: AOJu0YyRJOHg2NuhwnGUEoHqFJ//3HFjacbbMKI6TUrqN+VNcp952dyo
	QQzchc4QIJEBhiJX2BwZwoKD+FaNCoJgD7J+xGGYyhnxwzv6xaOUmb46uvbE+Alha0yJjvu/w96
	40Hc2KvvLGDZdHVpKfhC/h+85sppFdxO2gLDSttDmPYKw88wwUd6v
X-Gm-Gg: ASbGnctRMxWatmdfJoptCx/KSHEwmmKoDy5adE/boxz0cMwQy97PpYtAycJudgIFAac
	roFoo6TyYTDzJ5xGdJHugCkiBKibnd9JbYYeXV8+P43z6ro6ijMhiLlDT1FcM/4eEKZNW5+doMp
	UJU0MsovhFWey/X72CweFV5yhbBCgvWWjqyJDzedEOLxaARURkHCbvJ3OoSILUGy+nJfHfXFObC
	1TJqU7TCHT1CN/0D8l8yf5FwgQVm1QMcdrSWxNOxRPqfg20r0/kK51toRmbVQJePpjBPaCPlngj
	xyTFBUlJiNmFqqLIYvpkPlh7Q2oSsBYMajTkv3KCcRYYY5UMSuf0ysPMpw2rH12WGcoqTlbnPg=
	=
X-Received: by 2002:a05:600c:1ca0:b0:458:be44:357b with SMTP id 5b1f17b1804b1-45b517ad7bdmr113969805e9.15.1756198730798;
        Tue, 26 Aug 2025 01:58:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkRVV8OyPG1Pbhuea+rJgkBQhSOF9aPJMsHRfaA+Ur2DmV8RJfbxcyluqwBzhfL8CgMGZuCQ==
X-Received: by 2002:a05:600c:1ca0:b0:458:be44:357b with SMTP id 5b1f17b1804b1-45b517ad7bdmr113969525e9.15.1756198730228;
        Tue, 26 Aug 2025 01:58:50 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b66bbcf19sm10026045e9.4.2025.08.26.01.58.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 01:58:49 -0700 (PDT)
Message-ID: <d3177175-86d6-437b-8084-9d3521161146@redhat.com>
Date: Tue, 26 Aug 2025 10:58:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Guaranteed CMA
To: Suren Baghdasaryan <surenb@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Cc: lsf-pc@lists.linux-foundation.org, SeongJae Park <sj@kernel.org>,
 Minchan Kim <minchan@kernel.org>, m.szyprowski@samsung.com,
 aneesh.kumar@kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 mina86@mina86.com, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <liam.howlett@oracle.com>, Michal Hocko
 <mhocko@kernel.org>, linux-mm <linux-mm@kvack.org>,
 android-kernel-team <android-kernel-team@google.com>
References: <CAJuCfpEWVEqsivd7oTvp4foEho_HaD1XNP8KTeKWzG_X2skfGQ@mail.gmail.com>
 <7944006e-8209-4074-85da-14f5545cd8b6@redhat.com> <Z6H4qCZDthSpI3nN@raptor>
 <CAJuCfpHZFAH4YvzekBgL2Np9UE95tw6ueevxapFzLXpf8UeoqA@mail.gmail.com>
 <CAJuCfpFyJBf1PX_d6NKDVSgg3EhXcbebVCYjMMpti6d5VnAJwg@mail.gmail.com>
 <CAJuCfpGghAELOpAxcUrAsGt86th-faAdOebw0SfYesS0+2cGmg@mail.gmail.com>
 <CAJuCfpEXBMBTPB6j3OS9uaKT_NbyqivnpA35hRYRiPikgyO6AQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpEXBMBTPB6j3OS9uaKT_NbyqivnpA35hRYRiPikgyO6AQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Kvj7hZVkNttAsYKHnbJ3yN7wLd8nvPSHP4K2YGmlzJ0_1756198731
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ufpwaczboejqghrux3sksrxgwjfkudz5
X-Rspam-User: 
X-Rspamd-Queue-Id: 0358B80008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756198734-756744
X-HE-Meta: U2FsdGVkX1+ldfitAQ+2Rb2if2504nUEJWRwfyLyiAOeU47ZBbrQj3gQj3Y42ArvyT6b0t3C9kJ96X1CJnyRIydae2dn61LxydQeScxVzah8PQ35hFRpX3BY3vO24gaoVcMcgjcaKob+RGP/lx7XE4tdW2JpFbD50ORpCnrFX+lAYlFcYPcEftH/Q0MmwmQx5m4Fy/QVrF8G97/22/ywxk6hSIA9eCOxrVklWqquzfooFiPw11KzYoJIQck4XluclLK7s2UkwFYk5UQDUtvrBUiZDU+8M4xecm4p1+qSqbq6MWYzEcXbF2r5IvBv8gpipPU5pnjB6af301fQctFvqUcq1ojDjBn91C6A6BJpEDUTNt8xy4VMVVTM2dDQBQ7f2kXT8fFX5gsYsPsNXNJIDd8hVCiC/2AagQCJxXG+W7hk5QYLWks5KQjIhRtC6s/naNSgVMO1uV3p2layvpQlHhh2ersZ6vybeUxx8abHKyIbk65kKOkmQ8aHfwMd1JTVQqmhwJg5fl0r5r87N0Fn3D7VlUYlRd64mDNHdRGUejAo0OUxM7b/i8ioh2GFS5yKJ9UMb3xjovtByP41cMsc9J826QaMv37eQlBYmznUGXhb0OUAQ6OuXfRkJhr31Eo+peei89NFvR4z8I7qXFCbZTh2L89aLZCGgHUuL44i/iv/3NektDOt+fdoZ4GEDDPnb4UI4TmTINyXokOjeMBfdy29Sw0+C5+v1piXXlMuygxIwJp/IE4rRGdM2DZ/I55JCeiozOZT3rzJm8z7Wf4cdLb3OWkkP8I9i1sX/Z2XhP4LvSfPGrKnUQ6HNa7Kf6VWPCt1J0fynemJ840KurqUxBto6I+GuHq0qo0mB8sOPvCaEsADiRrHUzliwGckoriOS+DrXrEPHJ2m43XHuFyAo7i2FjPbolBd4yQm4Yx5A6DN30civksqYde7KWYtIZXIWLobNDnK9j5Dds76SNV
 IuzCBs0i
 GGhAbLIgtDNUWOZu5gFvcW8Cb42oIB+2PMptnDpZi8yETAHw2ne7Qvzr5fSqv5s0Mch0pNTI2LxpHdWGRKKXkmcCf2/4Xb2yi18N82XmXtjFss4Cc0jKXEQf7M7/a0iA7T6rKESVDuu3/IDqWPZm9oNgwFZhNedjgzARHaiPanZlTiRuFhMva+uDLskRDlXNYt7EwWAQpybdmx/UXAYOuGkpzeifb461OvB1H1GuNxd3u5Fd3yApiCb49Gj2ym+zeG54yRADqqfI0DIOkSzVob9bXEDHIRIOzvFMzYqG2x0JdzcN/zmOEpcvYD+0XEzH2yMB4ORd3X6RGaHX4nMazq0ERz/n9XhEYNNTBhNH8CjB6/2MAFvLfvbzduSGJnk9DfwDZatWHNk/oOrjqUVVrxdJuFnkUwGI8BZ8MjuFcWFzXPNjt0v/2TrTjLDup7NZmdty0D06XX0loO0c0K1JJlk3I/qsiJ+v+OdwrvgxtGxT4eKKAgX10FzcBRtdhMEsJbRMtB5WcxlUD7EmbRTXxGbU+9jLhtXkaqJpFGN1yApHxOWU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.08.25 00:14, Suren Baghdasaryan wrote:
> On Wed, Apr 2, 2025 at 9:35 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>
>> On Thu, Mar 20, 2025 at 11:06 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>
>>> On Tue, Feb 4, 2025 at 8:33 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>
>>>> On Tue, Feb 4, 2025 at 3:23 AM Alexandru Elisei
>>>> <alexandru.elisei@arm.com> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> On Tue, Feb 04, 2025 at 09:18:20AM +0100, David Hildenbrand wrote:
>>>>>> On 02.02.25 01:19, Suren Baghdasaryan wrote:
>>>>>>> Hi,
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>>> I would like to discuss the Guaranteed Contiguous Memory Allocator
>>>>>>> (GCMA) mechanism that is being used by many Android vendors as an
>>>>>>> out-of-tree feature, collect input on its possible usefulness for
>>>>>>> others, feasibility to upstream and suggestions for possible better
>>>>>>> alternatives.
>>>>>>>
>>>>>>> Problem statement: Some workloads/hardware require physically
>>>>>>> contiguous memory and carving out reserved memory areas for such
>>>>>>> allocations often lead to inefficient usage of those carveouts. CMA
>>>>>>> was designed to solve this inefficiency by allowing movable memory
>>>>>>> allocations to use this reserved memory when it’s otherwise unused.
>>>>>>> When a contiguous memory allocation is requested, CMA finds the
>>>>>>> requested contiguous area, possibly migrating some of the movable
>>>>>>> pages out of that area.
>>>>>>> In latency-sensitive use cases, like face unlock on phones, we need to
>>>>>>> allocate contiguous memory quickly and page migration in CMA takes
>>>>>>> enough time to cause user-perceptible lag. Such allocations can also
>>>>>>> fail if page migration is not possible.
>>>>>>>
>>>>>>> GCMA (Guaranteed CMA) is a mechanism previously proposed in [1] which
>>>>>>> was not upstreamed but got adopted later by many Android vendors as an
>>>>>>> out-of-tree feature. It is similar to CMA but backing memory is
>>>>>>> cleancache backend, containing only clean file-backed pages. Most
>>>>>>> importantly, the kernel can’t take a reference to pages from the
>>>>>>> cleancache, therefore can’t prevent GCMA from quickly dropping them
>>>>>>> when required. This guarantees GCMA low allocation latency and
>>>>>>> improves allocation success rate.
>>>>>>>
>>>>>>> We would like to standardize GCMA implementation and upstream it since
>>>>>>> many Android vendors are asking to include it as a generic feature.
>>>>>>>
>>>>>>> Note: removal of cleancache in 5.17 kernel due to no users (sorry, we
>>>>>>> didn’t know at the time about this use case) might complicate
>>>>>>> upstreaming.
>>>>>>
>>>>>> we discussed another possible user last year: using MTE tag storage memory
>>>>>> while the storage is not getting used to store MTE tags [1].
>>>>>>
>>>>>> As long as the "ordinary RAM" that maps to a given MTE tag storage area does
>>>>>> not use MTE tagging, we can reuse the MTE tag storage ("almost ordinary RAM,
>>>>>> just that it doesn't support MTE itself") for different purposes.
>>>>>>
>>>>>> We need a guarantee that that memory can be freed up / migrated once the tag
>>>>>> storage gets activated.
>>>>>
>>>>> If I remember correctly, one of the issues with the MTE project that might be
>>>>> relevant to GCMA, was that userspace, once it gets a hold of a page, it can pin
>>>>> it for a very long time without specifying FOLL_LONGTERM.
>>>>>
>>>>> If I remember things correctly, there were two examples given for this; there
>>>>> might be more, or they might have been eliminated since then:
>>>>>
>>>>> * The page is used as a buffer for accesses to a file opened with
>>>>>    O_DIRECT.
>>>>>
>>>>> * 'vmsplice() can pin pages forever and doesn't use FOLL_LONGTERM yet' - that's
>>>>>    a direct quote from David [1].
>>>>>
>>>>> Depending on your usecases, failing the allocation might be acceptable, but for
>>>>> MTE that wasn't the case.
>>>>>
>>>>> Hope some of this is useful.
>>>>>
>>>>> [1] https://lore.kernel.org/linux-arm-kernel/4e7a4054-092c-4e34-ae00-0105d7c9343c@redhat.com/
>>>>
>>>> Thanks for the references! I'll read through these discussions to see
>>>> how much useful information for GCMA I can extract.
>>>
>>> I wanted to get an RFC code ahead of LSF/MM and just finished putting
>>> it together. Sorry for the last minute posting. You can find it here:
>>> https://lore.kernel.org/all/20250320173931.1583800-1-surenb@google.com/
>>
>> Sorry about the delay. Attached are the slides from my GCMA
>> presentation at the conference.
> 
> Hi Folks,

Hi,

> As I'm getting close to finalizing the GCMA patchset, one question
> keeps bugging me. How do we account the memory that is allocated from
> GCMA... In case of CMA allocations, they are backed by the system
> memory, so accounting is straightforward, allocations contribute to
> RSS, counted towards memcg limits, etc. In case of GCMA, the backing
> memory is reserved memory (a carveout) not directly accessible by the
> rest of the system and not part of the total_memory. So, if a process
> allocates a buffer from GCMA, should it be accounted as a normal
> allocation from system memory or as something else entirely? Any
> thoughts?

You mean, an application allocates the memory and maps it into its page 
tables?

Can that memory get reclaimed somehow?

How would we be mapping these pages into processes (VM_PFNMAP or 
"normal" mappings)?

memcg doesn't quite make sense, I assume.

RSS ... hm ...

-- 
Cheers

David / dhildenb


