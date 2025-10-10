Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82570CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E31AF8E000C; Fri, 10 Oct 2025 11:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09BF8E0003; Fri, 10 Oct 2025 11:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8058E000C; Fri, 10 Oct 2025 11:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9F7D8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:37:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68A0513A9F8
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:37:30 +0000 (UTC)
X-FDA: 83982609060.09.EFAA15A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id DD24740014
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:37:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MAwtAWAR;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wmLWKW9t16i6VLVLjtKNffWO7KYK1nHcjxaQ5h8uMc=;
	b=r/mVJuUySfVcqyp3WEZNEQGBajZWvQmOlMNpLSPgAiZdzIFacFZeu5nVEhVXi9b3lsrANj
	msvGH2Hd5xqA4LEP41DWmUWK7azST3vRjovVw39X2yHY8MCNC3QClPoargyTU5+CZ6C8vQ
	2L6rFq9SHwZbsNhTfJgaBVhB29BCADU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MAwtAWAR;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760110648; a=rsa-sha256;
	cv=none;
	b=ZE/tWD4RtHUSOtD0oapG/WHMAkJMiaQkoseVC+RHkM7gzRlgtAVb8wi0lfR5YFLNhX0fSe
	7Ie1+j3XtMg9XHTyaDFx9FBFvRxc2supHe0toxpR3QQ1mDaD6G5Z1WeB+snEdcnVjUihLd
	Z1Kc+Lg85vJQNozvVA9MpoQNOmEX7cg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760110647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0wmLWKW9t16i6VLVLjtKNffWO7KYK1nHcjxaQ5h8uMc=;
	b=MAwtAWARZYN1tjZjw1Mgp6KrtPE8rFVeYBw3CRgXlcgF1laDNJyR6R9EDFzqziVw3EFu7P
	ekljgVRjlFL49SH3gYos0BgjojUBWPsJF53+YlWDoAnFlNBVrglgnn2odK89garxKNCHhT
	9Q3OsG27lqvljmfWl+ibrEFitTz+EVg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-A6oq9Eo4Nx2CLPlIn3__yw-1; Fri, 10 Oct 2025 11:37:26 -0400
X-MC-Unique: A6oq9Eo4Nx2CLPlIn3__yw-1
X-Mimecast-MFC-AGG-ID: A6oq9Eo4Nx2CLPlIn3__yw_1760110644
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso17763275e9.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760110644; x=1760715444;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0wmLWKW9t16i6VLVLjtKNffWO7KYK1nHcjxaQ5h8uMc=;
        b=GXlR1dn9usP0fOv2nbj7PzOTqgPeFvpjNjtQu9inNJxEPDgbySo4fXh6251ejq9d6M
         Oz4ZgVd9YiD/ZiFOdA2ZVvNVJR+dbhU7PwhJH08CgE8JDr5QUhswSDAPyW/5vx+NgBnm
         KawXORshgMCZAwvxaiXv3jB5Mf0qJpVEapYua3zyieKEjhUdkxS0ALhpD6Htv13EeVHb
         XAKHMYpw1ETPMGDl0DAPLM0ftjlfH7XOp5Fh6dND5/vfVk5n8q9gQqPex3jgYx7OWoBQ
         EaOdGtoP+gK97cMOIfj96NfiqeDqNPfAnTcJFgyopbGzUOtLY7DLC4hZ4QQH9/wOIpFl
         AfOA==
X-Forwarded-Encrypted: i=1; AJvYcCXy+CgBcLmIBGCawnWz5JofYXoH8RCwhdgfnd1r1N6Z5/0LuQOO7n8n8lUre9PFpqMP2L0ZfFr3uQ==@kvack.org
X-Gm-Message-State: AOJu0YwzW/2mwFdVOCGVFJJ37e3WJk66xJ5+3UD3rxonAird8Y8Hfuys
	Okxz7nM8KCFUN+GcvNZ4t+wimfXhtw1A2WV5NalwM8qD1jPIYxBeH1DYqpLJuiWPCLd5hUY7LcV
	ov4upm3Lk5ewrqYiJ7BrqTGM26xOV9OsKp/jtHzx3TPKIERIiv8IJ
X-Gm-Gg: ASbGnctl0KiYK794b2eG9YSnHBELCxhOgiN+d0g2nvww2yOr8IhXPz8aEt4+3k6/bbC
	r1SbBtcdoNvmpIQW2eUqvdguGq5IDWDfgrVe0QTMs1GjtGwANDTilDjz5p0Jhi1KpCBtWQp1c4q
	Ejf0CKaZK6zeWVpawQe/cOgm2uoN8SN9PE3WY8Xgv75a93kWbqIfNLSkLadJ/vUUn2K7EHNPpGl
	6TA03KlCSA6Naj7N4RcgXcN//i7aNVYf1m6qsGnxQZ2mI9QflJTrLKEudFueLnMG242yGRVWvt1
	DW3MTTBd5sKwC2Pjal71zWHXZtVfzJyt2rUARymxfYX9BpummW2j7UnX/HPNyW6omfXGcSoe3go
	xUno=
X-Received: by 2002:a05:600c:6383:b0:465:a51d:d4 with SMTP id 5b1f17b1804b1-46fa9a8b48dmr91367515e9.6.1760110644318;
        Fri, 10 Oct 2025 08:37:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHiPcNQ4CxmCITio3IeNaVMwVq0+7+1t8ri8S+pRG3qNCixb7IwOLNlOHCUaSF8cLEq1P1s2g==
X-Received: by 2002:a05:600c:6383:b0:465:a51d:d4 with SMTP id 5b1f17b1804b1-46fa9a8b48dmr91367325e9.6.1760110643770;
        Fri, 10 Oct 2025 08:37:23 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5cfe69sm4872758f8f.32.2025.10.10.08.37.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 08:37:23 -0700 (PDT)
Message-ID: <5c3fc24c-dfbf-4d59-bda0-8726d2eaa78a@redhat.com>
Date: Fri, 10 Oct 2025 17:37:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Guaranteed CMA
To: Suren Baghdasaryan <surenb@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 lsf-pc@lists.linux-foundation.org, SeongJae Park <sj@kernel.org>,
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
 <d3177175-86d6-437b-8084-9d3521161146@redhat.com>
 <CAJuCfpFBgYrOsAD5JbuBOMUVJo7H5e_qDxjxPsqHH1SSQum9Xg@mail.gmail.com>
 <ef8b8fe0-be77-429c-a474-be7b7f8be587@redhat.com>
 <CAJuCfpG+bXMDzfDRAZwhTX2CNu+yA12PVVV6sWcbWvJAsKvUww@mail.gmail.com>
 <ddde064a-3297-4da1-bd2f-b3fbc2384e1f@redhat.com>
 <CAJuCfpGHZFmSV9ZDXc_CxxACzq-TjVudnCT3thn_Ok6S4nm3eQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpGHZFmSV9ZDXc_CxxACzq-TjVudnCT3thn_Ok6S4nm3eQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NLg0X8iVGUj9NHc50HUbxzySOyq6OSpEVsHwRJ-3wIQ_1760110644
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD24740014
X-Stat-Signature: j7nyjebty3qxyme4amrsmg6mbtbk17fr
X-Rspam-User: 
X-HE-Tag: 1760110647-116007
X-HE-Meta: U2FsdGVkX19iTTiyMPlpGCQJDNsxDLjQ7QXW1H7uvwkNcLeUg5ddBpBhzlkQLns/ZdENNBHRNbXBO8PgehNWhiGmlYzf3h6B5HxVZtOoRk88AOAcDAJ9Uakkqwj+rE3Utk9duOYyx4Oqdj1XjpTuoQdMJMmn0Jrxb1WithhhAdi+r8e8Q4vMlqZPAuJ+2F6Ts4Ngr6qa0bZcl0MdzdEuLlcWRLQbgmvS3V9E9eVkUOVeN2q6921QgRtM43WaBMJ1r1k759FbxwP1v1yVPSuf2PgXkZGnI/PYkOH3HY/4Rj121zGqU1tCFFWljiJ20jBD7skbpLsYP8K7ESY39dy+gsZH45Ash+G3asSnU0SO6Ki/HcZRYmEAFno1aDdH2gSdRmJ+BFzVVVGMzRSnl/MFaJFJBPjpJwPA+nop5tGDZBberbAQW+j26xzkQc3/722/NsjOxPpsrDX4bvFskAa0SRyEuNQVC8oD6XVcJq9lb4HRszja5g1ehBXBnR1RnB8PSkNTssPDZBrHGfer2OVLmj9h+kss6u26Gibiv6C3wvr+tl3IrlTh97r/M60F3z73Chd63uYUBurQC2GdR+/3O7X/iTr2XlwnFsZAJhVBUWL08lKiy0BSOw2nOBfRmyXB4jYBWUHblqwwYReo+XF5l0DuuoUzBoCquZVwDtWJZmzv0ZD4kBLTh1iCLgrmmCmTlMNMeQpWTy0DARq99VXwrQTjXkNH8Mli4UTOuepMTOqdm3EcOUAk7oxL6uDVdC0Z94D8IigeGjzCoCK5D0Ol2NCSQf3wHYkVwARl9fL7Yid4bDV9js2GK19jfngf76BnXOUnO8LNHNxyrGztY0fqWMcNmjrS0VjWY4vY+8QKkKmFRsQLLGINKrzln7PazayLPfZvePQCfNkVMnnA++r1qJaywjDsEmZK5DI32v8D9LHDMsB26lpR5889pknhTXQx785jP0YXKGPW979UYZM
 qE6pql4N
 0WloCyaHsBUEPuC1oFq5cyOq1mabngZRRlw9PnmKVIlTjuT4Qy9PwaP69trMfNVsp7qsT7cj3Um6lTqKn7cImTEa9GGr7QZcflQVusjTd6BjprWbLTnFj28x+XJ+JEXeQz4jccf2y4D98IyAGzrg2tvT/k4qw4xcWD0hDUI1fSZU5aRHMwmcVxDuHfQxGULYpNfbmyxdjeOUduMNNcd2PGtvtfDXcQN/nHDgvnBuoUqgfEfl1NHz4kLnW1F13R6cWV/ShWm4fjkPSr9SFapU9/KPNZ4XkTInatVcdBJEgrv0km8PgSC5hMTLJKHb6sstNWq5P1NtYH4+UGHjrWN2VT5qFc4HBMziI4jgaZ8f1Oqi6Z+WPwZuM64KNivTfXjinSLaOqA7MqkIHqwpIPo86Hks4G7XK3HvB9Xidaref9uP7VGZ7z0wjee/NFYcXXJ4GzG3ab2Zfr+M6JhAsCjgdM7vuVbRDgNwgGsoaqFTqH64xA2P9hQqjMXEdyoRi6XJTya3C10YtBASuaVmQTIC7E3RJ7WatQ0SLfMcOFEg7aeYo0RHG4rud+C8W9rAXN4UxNPOBySnZF8Dt1IRzXhTnhRuvHEhyuTcutXIzRo/Z0/HTvuupfsUa7Jqpul/WI6TaRWo5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.10.25 17:07, Suren Baghdasaryan wrote:
> On Fri, Oct 10, 2025 at 6:58 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 10.10.25 03:30, Suren Baghdasaryan wrote:
>>> On Mon, Sep 1, 2025 at 9:01 AM David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>> On 27.08.25 02:17, Suren Baghdasaryan wrote:
>>>>> On Tue, Aug 26, 2025 at 1:58 AM David Hildenbrand <david@redhat.com> wrote:
>>>>>>
>>>>>> On 23.08.25 00:14, Suren Baghdasaryan wrote:
>>>>>>> On Wed, Apr 2, 2025 at 9:35 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>>>>>
>>>>>>>> On Thu, Mar 20, 2025 at 11:06 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>>>>>>
>>>>>>>>> On Tue, Feb 4, 2025 at 8:33 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>>>>>>>
>>>>>>>>>> On Tue, Feb 4, 2025 at 3:23 AM Alexandru Elisei
>>>>>>>>>> <alexandru.elisei@arm.com> wrote:
>>>>>>>>>>>
>>>>>>>>>>> Hi,
>>>>>>>>>>>
>>>>>>>>>>> On Tue, Feb 04, 2025 at 09:18:20AM +0100, David Hildenbrand wrote:
>>>>>>>>>>>> On 02.02.25 01:19, Suren Baghdasaryan wrote:
>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>
>>>>>>>>>>>> Hi,
>>>>>>>>>>>>
>>>>>>>>>>>>> I would like to discuss the Guaranteed Contiguous Memory Allocator
>>>>>>>>>>>>> (GCMA) mechanism that is being used by many Android vendors as an
>>>>>>>>>>>>> out-of-tree feature, collect input on its possible usefulness for
>>>>>>>>>>>>> others, feasibility to upstream and suggestions for possible better
>>>>>>>>>>>>> alternatives.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Problem statement: Some workloads/hardware require physically
>>>>>>>>>>>>> contiguous memory and carving out reserved memory areas for such
>>>>>>>>>>>>> allocations often lead to inefficient usage of those carveouts. CMA
>>>>>>>>>>>>> was designed to solve this inefficiency by allowing movable memory
>>>>>>>>>>>>> allocations to use this reserved memory when it’s otherwise unused.
>>>>>>>>>>>>> When a contiguous memory allocation is requested, CMA finds the
>>>>>>>>>>>>> requested contiguous area, possibly migrating some of the movable
>>>>>>>>>>>>> pages out of that area.
>>>>>>>>>>>>> In latency-sensitive use cases, like face unlock on phones, we need to
>>>>>>>>>>>>> allocate contiguous memory quickly and page migration in CMA takes
>>>>>>>>>>>>> enough time to cause user-perceptible lag. Such allocations can also
>>>>>>>>>>>>> fail if page migration is not possible.
>>>>>>>>>>>>>
>>>>>>>>>>>>> GCMA (Guaranteed CMA) is a mechanism previously proposed in [1] which
>>>>>>>>>>>>> was not upstreamed but got adopted later by many Android vendors as an
>>>>>>>>>>>>> out-of-tree feature. It is similar to CMA but backing memory is
>>>>>>>>>>>>> cleancache backend, containing only clean file-backed pages. Most
>>>>>>>>>>>>> importantly, the kernel can’t take a reference to pages from the
>>>>>>>>>>>>> cleancache, therefore can’t prevent GCMA from quickly dropping them
>>>>>>>>>>>>> when required. This guarantees GCMA low allocation latency and
>>>>>>>>>>>>> improves allocation success rate.
>>>>>>>>>>>>>
>>>>>>>>>>>>> We would like to standardize GCMA implementation and upstream it since
>>>>>>>>>>>>> many Android vendors are asking to include it as a generic feature.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Note: removal of cleancache in 5.17 kernel due to no users (sorry, we
>>>>>>>>>>>>> didn’t know at the time about this use case) might complicate
>>>>>>>>>>>>> upstreaming.
>>>>>>>>>>>>
>>>>>>>>>>>> we discussed another possible user last year: using MTE tag storage memory
>>>>>>>>>>>> while the storage is not getting used to store MTE tags [1].
>>>>>>>>>>>>
>>>>>>>>>>>> As long as the "ordinary RAM" that maps to a given MTE tag storage area does
>>>>>>>>>>>> not use MTE tagging, we can reuse the MTE tag storage ("almost ordinary RAM,
>>>>>>>>>>>> just that it doesn't support MTE itself") for different purposes.
>>>>>>>>>>>>
>>>>>>>>>>>> We need a guarantee that that memory can be freed up / migrated once the tag
>>>>>>>>>>>> storage gets activated.
>>>>>>>>>>>
>>>>>>>>>>> If I remember correctly, one of the issues with the MTE project that might be
>>>>>>>>>>> relevant to GCMA, was that userspace, once it gets a hold of a page, it can pin
>>>>>>>>>>> it for a very long time without specifying FOLL_LONGTERM.
>>>>>>>>>>>
>>>>>>>>>>> If I remember things correctly, there were two examples given for this; there
>>>>>>>>>>> might be more, or they might have been eliminated since then:
>>>>>>>>>>>
>>>>>>>>>>> * The page is used as a buffer for accesses to a file opened with
>>>>>>>>>>>       O_DIRECT.
>>>>>>>>>>>
>>>>>>>>>>> * 'vmsplice() can pin pages forever and doesn't use FOLL_LONGTERM yet' - that's
>>>>>>>>>>>       a direct quote from David [1].
>>>>>>>>>>>
>>>>>>>>>>> Depending on your usecases, failing the allocation might be acceptable, but for
>>>>>>>>>>> MTE that wasn't the case.
>>>>>>>>>>>
>>>>>>>>>>> Hope some of this is useful.
>>>>>>>>>>>
>>>>>>>>>>> [1] https://lore.kernel.org/linux-arm-kernel/4e7a4054-092c-4e34-ae00-0105d7c9343c@redhat.com/
>>>>>>>>>>
>>>>>>>>>> Thanks for the references! I'll read through these discussions to see
>>>>>>>>>> how much useful information for GCMA I can extract.
>>>>>>>>>
>>>>>>>>> I wanted to get an RFC code ahead of LSF/MM and just finished putting
>>>>>>>>> it together. Sorry for the last minute posting. You can find it here:
>>>>>>>>> https://lore.kernel.org/all/20250320173931.1583800-1-surenb@google.com/
>>>>>>>>
>>>>>>>> Sorry about the delay. Attached are the slides from my GCMA
>>>>>>>> presentation at the conference.
>>>>>>>
>>>>>>> Hi Folks,
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>>> As I'm getting close to finalizing the GCMA patchset, one question
>>>>>>> keeps bugging me. How do we account the memory that is allocated from
>>>>>>> GCMA... In case of CMA allocations, they are backed by the system
>>>>>>> memory, so accounting is straightforward, allocations contribute to
>>>>>>> RSS, counted towards memcg limits, etc. In case of GCMA, the backing
>>>>>>> memory is reserved memory (a carveout) not directly accessible by the
>>>>>>> rest of the system and not part of the total_memory. So, if a process
>>>>>>> allocates a buffer from GCMA, should it be accounted as a normal
>>>>>>> allocation from system memory or as something else entirely? Any
>>>>>>> thoughts?
>>>>>>
>>>>>> You mean, an application allocates the memory and maps it into its page
>>>>>> tables?
>>>>>
>>>>> Allocation will happen via cma_alloc() or a similar interface, so
>>>>> applications would have to use some driver to allocate from GCMA. Once
>>>>> allocated, an application can map that memory if the driver supports
>>>>> mapping.
>>>>
>>>> Right, and that might happen either through a VM_PFNMAP or !VM_PFNMAP
>>>> (ordinarily ref- and currently map-counted).
>>>>
>>>> In the insert_page() case we do an inc_mm_counter, which increases the RSS.
>>>>
>>>> That could happen with pages from carevouts (memblock allocations)
>>>> already, but we don't run into that in general I assume.
>>>>
>>>>>
>>>>>>
>>>>>> Can that memory get reclaimed somehow?
>>>>>
>>>>> Hmm. I assume that once a driver allocates pages from GCMA it won't
>>>>> put them into system-managed LRU or free them into buddy allocator for
>>>>> kernel to use. If it does then at the time of cma_release() it can't
>>>>> guarantee there are no more users for such pages.
>>>>>
>>>>>>
>>>>>> How would we be mapping these pages into processes (VM_PFNMAP or
>>>>>> "normal" mappings)?
>>>>>
>>>>> They would be normal mappings as the pages do have `struct page` but I
>>>>> expect these pages to be managed by the driver that allocated them
>>>>> rather than the core kernel itself.
>>>>>
>>>>> I was trying to design GCMA to be used as close to CMA as possible so
>>>>> that we can use the same cma_alloc/cma_release API and reuse CMA's
>>>>> page management code but the fact that CMA is backed by the system
>>>>> memory and GCMA is backed by a carveout makes it a bit difficult.
>>>>
>>>> Makes sense. So I assume memcg does not apply here already -- memcg does
>>>> not apply on the CMA layer IIRC.
>>>>
>>>> The RSS is a bit tricky. We would have to modify things like
>>>> inc_mm_counter() to special-case on these things.
>>>>
>>>> But then, smaps output would still count these pages towards the rss/pss
>>>> (e.g., mss->resident). So that needs care as well ...
>>>
>>> In the end I decided to follow CMA as closely as possible, including
>>> accounting. GCMA and CMA both use reserved area and the difference is
>>> that CMA donates its memory to kernel to use for movable allocations
>>> while GCMA donates it to the cleancache. But once that donation is
>>> taken back by CMA/GCMA to satisfy cma_alloc() request, the memory
>>> usage is pretty much the same and therefore accounting should probably
>>> be the same. Anyway, that was the reasoning I eventually arrived at. I
>>> posted the GCMA patchset at [1] and included this reasoning in the
>>> cover letter. Happy to discuss this further in that patchset.
>>
>> Right, probably best to keep it simple. Will these GCMA pages be
>> accounted towards MemTotal like CMA pages would?
> 
> I thought CMA pages are accounted towards CmaTotal and if that's what
> you mean then yes, they are added to that metric in the patch [1], see
> the change in gcma_register_area(). I'm not adding the GcmaTotal
> metric because I think it's simpler to consider GCMA as just a flavor
> of CMA, as both are used via the same API (cma_alloc/cma_release) and
> serve the same purpose. The GCMA area can be distinguished from the
> CMA area using the /sys/kernel/mm/cma/<area>/gcma attribute, but
> otherwise, it should appear to users as yet another CMA area. Does
> that make sense?

I was rather wondering whether these pages will be part of /proc/meminfo 
MemTotal: so that totalram_pages_add() is called for them.

For ordinary CMA that happens in cma_activate_area() -> 
init_cma_reserved_pageblock() through adjust_managed_page_count(), where 
we also have the __free_pages() call.

If nothing changed on that front, then yes, it would behave just like 
ordinary CMA.

I should probably take a look at your v1, unfortunately that might have 
to wait for next week as I'm out of review capacity for today I'm afraid.

-- 
Cheers

David / dhildenb


