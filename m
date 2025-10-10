Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD7D8CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 13:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121E78E0015; Fri, 10 Oct 2025 09:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ABEC8E0003; Fri, 10 Oct 2025 09:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8E2B8E0015; Fri, 10 Oct 2025 09:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD14D8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:58:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65092B84CB
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:58:36 +0000 (UTC)
X-FDA: 83982359832.19.3869AA0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id CD6EF80010
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:58:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xro7B+eF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760104714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LEYIasbZkmEM8Ri3PBQF32jJxd6nyxh9/AA4w/fO4vA=;
	b=ZCnG8XQ0ovniKgbI76A+vViB2ee9cKHtd5EgZ7lQEj27fP7xdXyx/agAx9Gml+NGXb9Eeu
	gpIcZe+uQftuj8sd8cREICP3QL7FUztamRvfLl1WoDUSsouVXhWR6TGToZ1duMvPI/uEj8
	zwxmUu9oOu28HHHU5QMWCMLFRchPsxg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xro7B+eF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760104714; a=rsa-sha256;
	cv=none;
	b=CvJfI/UTD6cUdSfTcXLNrSV3I//GXjFyc3/zYIYGh8vFDR2o59TIggp1sBzcnqkB1mQ/xD
	i4UhGVfvITorIIdDkdx+0CUDNlw05VlBn3CEHP6jGITDCEVrSv+YHswyO+qMLGS34dx92r
	8BpyEQ3d8shF4mMl6iNFZQqa7aPxTGM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760104713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LEYIasbZkmEM8Ri3PBQF32jJxd6nyxh9/AA4w/fO4vA=;
	b=Xro7B+eF/AyyLiFZIVuRiX5fwF93h7KzBahwKAtgyinvZKft005f7vEou4nzRjoCWZTbGP
	RXnfSTUeaHwyPLBsnQaKNxfY+AEwKARAmNRLf6WgpBkASn+WwE5Ufuks7Yfc/s8BzOONqI
	at1iaWfYXZGC+tzSAPCZD8DhhIcLtyk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-ukYeKLquNB-i7zwoMahB9A-1; Fri, 10 Oct 2025 09:58:32 -0400
X-MC-Unique: ukYeKLquNB-i7zwoMahB9A-1
X-Mimecast-MFC-AGG-ID: ukYeKLquNB-i7zwoMahB9A_1760104710
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e3e177893so13213355e9.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 06:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760104710; x=1760709510;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LEYIasbZkmEM8Ri3PBQF32jJxd6nyxh9/AA4w/fO4vA=;
        b=wSozq/xHhCkGnxCHe32ITKQ1JeIfZKpVUEj3XCX8T4IbyappzhJie/HTg0l2l7Sfcs
         8SZ3l3Lu4L40zZ4eDodPSpRXL4P/FZIVYDr7G7Q8iLZDYvQJnRuCWWRW2h/9IFR1UVQA
         5mATIorRK97TYdlaKLxN1X2klV/GyrmfSnGXQMstsCFcVll0bNoBiFLfbnPMVNyt3OOV
         9zXSIcODe6ecDFRV5GPf10/D3BlHsbPtePqpnyNCt6Rn9HnrY40OoMFwjx0L7BxZmoZP
         qWD9qpFG+vPSsnN4oO+657ctcJtBGdgGBF1V9pGtFkigta4OPWSVazmf+EshFGWNoMXk
         bYEA==
X-Forwarded-Encrypted: i=1; AJvYcCUTQPFT0zMzTT23dXBv2zZzlGy4e65BvGLd9FqZG9tEsqUinbW+wdx60EgtTIxhQ1m//bKH35EWqA==@kvack.org
X-Gm-Message-State: AOJu0YwPp5Mmr72WZvJpMbYb9D/SrkeZVfNuobAOgcxbh80lZTDYOCV1
	zOm+HpE1om93SLE4IGZdo4J/4fnTB8dG30A9C7dOjEsvaH9SfKDVdr2f0V0mMs73s21V5XzzBtP
	hEE9K9Z2QyW89BB2Hhs8JlFz0j5pUrlnMr+t5gWqckNrifJa8yLMC
X-Gm-Gg: ASbGncvD7lPA9yvk8Nb1CzAldYIPMryvyhlYboNCoYRn781D0ncgzFKFtZ6ENQFyXaX
	0h5xm7iaDPDaOPkWV91dPUbhiPZyaB8H94gI6caniOlqM1vwHdbwNcaLuWg67cQR7e0Ds4yKwUc
	Zv+Bz7UvcHGcvRyNQFJlBMpoD3LM5kJGpfqkWnBzl5AnpIcEEhUmeZjK7AwRQS/vfcZgJDUaxGp
	ClK7YKVVHxFbsNVFMgbYwq0wVyN1I2YkXV5fvQQAld8+WIHEIK/1F4yMMQO25tZ24xMhttzJ/L+
	IPd5arkpbbaiNcmdFzonc4+Q48lw5ZmK6ugwQM2ivzyioJG8fKipRRRvss0zqBr4j1FcDVV20qC
	Cq0s=
X-Received: by 2002:a05:600c:a02:b0:46e:4499:ba30 with SMTP id 5b1f17b1804b1-46fa9b052f2mr90432435e9.30.1760104709633;
        Fri, 10 Oct 2025 06:58:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEse5ldLt16BHRXFtd10184if9N85CZAf63QTUmHLNC+64OInDijdM7G+ww/Yy2nxhi/mPqcw==
X-Received: by 2002:a05:600c:a02:b0:46e:4499:ba30 with SMTP id 5b1f17b1804b1-46fa9b052f2mr90432215e9.30.1760104709142;
        Fri, 10 Oct 2025 06:58:29 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb483bcf9sm49010515e9.6.2025.10.10.06.58.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 06:58:28 -0700 (PDT)
Message-ID: <ddde064a-3297-4da1-bd2f-b3fbc2384e1f@redhat.com>
Date: Fri, 10 Oct 2025 15:58:25 +0200
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpG+bXMDzfDRAZwhTX2CNu+yA12PVVV6sWcbWvJAsKvUww@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7rRDtUtnEeLn779aUzKAwJ9ADyL80n578eJwD8QMUFk_1760104710
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CD6EF80010
X-Rspamd-Server: rspam03
X-Stat-Signature: dbp8td1cmm44etg1syfr3e65muske69f
X-HE-Tag: 1760104713-690016
X-HE-Meta: U2FsdGVkX18Omu0lwjJhNiI9g/gH0NoclqrVQVpmgHSMh4zGGRGIL3wbKBIFUozMdqghhdnZD9TfDeHfp2TQ/RI3VVDCLA+nnbLEvlSJ1EKpgX5ePa640/OrIqdGzIhI7naAjGgN5kZzV00kBR4sd60/KduXcvCNl6BDoKXVwcd6ilCcf0hXme6+JI2xcjpcZWE9qAibVQCUE1pJeeYXhx1vnprLXCrRhffU8andL33RB6G6I9zg8Nlo6BIeeLk3mMQeSqhyBybue4sGHRSVLhuGoeD7hrcFCg9PFrkaOse1svSSt098OgyI/F7zD7z2LVa6rg5i6czaogg4uzW/LJfx5luaKoYxYtFRAqGp+6BpxMSDXEkfnHjjaX510hB8ekDzfsIQFvCAg3F8an0nzI0Q0fLemHd8o2sguNXGuNA5XcbXye1Dbf9AtTf8IBhcVHEP+PL5zlImz7g8u8YFSd1pB1etbnN7hP5p3wL3HtrT0BEfZ2qdumegwpUCYOP+R5Etgl0RBwlXRk9cnafY9Bzy10o+9B650xKM1Qqpqql8tGEKMVAMFsC1P04/EpogXczj8yqbtnCMp0E0Pwx9JuneicN5sufpcHwdGJO78TuXPVQ/5uR/qkPqmBP46RBoBJBv/QgMC2pfMruCMev5BLWTWboglop3Kutl9f9B9W6KrCSt0npu4k/tkTI6WiyLwwndYUegL1KA+/mWF7Wul6/IgzAenlBFPExsr3q3GzDxLTnOTwKq/GZ5OH8TFoN88V6hXQ/PJiSG95ntG54e8nZjFShQxs+VNwFZVM2Dq9JLdGKTRVCdy1AvXEp2ydIslRtvy/FjKjESB44Tul2ndW9DkVAMhGidy63FETthWGC/cP0uvvUNr4jK2cbmFLc35xV4+/utlhFz3/Ndihb6f1DnUmIcLm+tpoRYZIGdI01rYq7hZ/8sNyPMrX1vOnkiKgWLskrSKk2fWaGAUBN
 jT6Ms5BH
 a4FdG/5qXCcjnfbLFq1l0s8vDSqzZ4UNWmt88pxK93o8qr4UqcwzyjuwJ+xoeOByxfhZqaUURWNEhcAhfcyBfjMCMbmEunrt25RNbCGNU2sj8MrOkdQnI/sN99JXIQHaWF7jOmcY9V0tBzACY2b0ylsrQid+lqY6I6qRGcVKtQYYFt5H/+LTvh4p246mXZJoPXl213Jr7o3kkw9Ids0JUHcC5FRCut32eqSvO3Z8s8PfAeoo7QcP5cA2tPLgKM5n9Cvk70C9uF2qd+1aZPQC9YfHv8VOzUALFLcUAqN6D6TXiaUupNJFEli5/IazflAcAfS8whV6LvWbPMiM8Q6f7ie8ERZa1eyS80Fr1EM1iXB1YNTCHrIY/7NVD3Tfekmn1IHJ2IXVAcx9+shMmbEIOSrVPlMORW/zGYijREzWiTlgNvX7+buiHKk5LKKARvnsEAQIzj8QH2aA635kn6gO74FrA3gpjXy9pDZ+d2aGLKR8srC4xzXFRWXqc0G8WqcBP8UhdP3ZsiFBHHhn0CxwCVQXqsFcm9jvjbDCsguNAdTCjT9dtcmSdL76IVCdQNEEoYuDEnWJ/nAZLrpBxVhkfP+tpH1ogOMr9k938YDVthRttj+rqvTF4BVrCvwRRXPIWTlM3mQQ9NMg0WxY367BA3M1C8sWNWKAYHoAJlURwTFqY+d8hoUdCX63VcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.10.25 03:30, Suren Baghdasaryan wrote:
> On Mon, Sep 1, 2025 at 9:01 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 27.08.25 02:17, Suren Baghdasaryan wrote:
>>> On Tue, Aug 26, 2025 at 1:58 AM David Hildenbrand <david@redhat.com> wrote:
>>>>
>>>> On 23.08.25 00:14, Suren Baghdasaryan wrote:
>>>>> On Wed, Apr 2, 2025 at 9:35 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>>>
>>>>>> On Thu, Mar 20, 2025 at 11:06 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>>>>
>>>>>>> On Tue, Feb 4, 2025 at 8:33 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>>>>>
>>>>>>>> On Tue, Feb 4, 2025 at 3:23 AM Alexandru Elisei
>>>>>>>> <alexandru.elisei@arm.com> wrote:
>>>>>>>>>
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> On Tue, Feb 04, 2025 at 09:18:20AM +0100, David Hildenbrand wrote:
>>>>>>>>>> On 02.02.25 01:19, Suren Baghdasaryan wrote:
>>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>>> I would like to discuss the Guaranteed Contiguous Memory Allocator
>>>>>>>>>>> (GCMA) mechanism that is being used by many Android vendors as an
>>>>>>>>>>> out-of-tree feature, collect input on its possible usefulness for
>>>>>>>>>>> others, feasibility to upstream and suggestions for possible better
>>>>>>>>>>> alternatives.
>>>>>>>>>>>
>>>>>>>>>>> Problem statement: Some workloads/hardware require physically
>>>>>>>>>>> contiguous memory and carving out reserved memory areas for such
>>>>>>>>>>> allocations often lead to inefficient usage of those carveouts. CMA
>>>>>>>>>>> was designed to solve this inefficiency by allowing movable memory
>>>>>>>>>>> allocations to use this reserved memory when it’s otherwise unused.
>>>>>>>>>>> When a contiguous memory allocation is requested, CMA finds the
>>>>>>>>>>> requested contiguous area, possibly migrating some of the movable
>>>>>>>>>>> pages out of that area.
>>>>>>>>>>> In latency-sensitive use cases, like face unlock on phones, we need to
>>>>>>>>>>> allocate contiguous memory quickly and page migration in CMA takes
>>>>>>>>>>> enough time to cause user-perceptible lag. Such allocations can also
>>>>>>>>>>> fail if page migration is not possible.
>>>>>>>>>>>
>>>>>>>>>>> GCMA (Guaranteed CMA) is a mechanism previously proposed in [1] which
>>>>>>>>>>> was not upstreamed but got adopted later by many Android vendors as an
>>>>>>>>>>> out-of-tree feature. It is similar to CMA but backing memory is
>>>>>>>>>>> cleancache backend, containing only clean file-backed pages. Most
>>>>>>>>>>> importantly, the kernel can’t take a reference to pages from the
>>>>>>>>>>> cleancache, therefore can’t prevent GCMA from quickly dropping them
>>>>>>>>>>> when required. This guarantees GCMA low allocation latency and
>>>>>>>>>>> improves allocation success rate.
>>>>>>>>>>>
>>>>>>>>>>> We would like to standardize GCMA implementation and upstream it since
>>>>>>>>>>> many Android vendors are asking to include it as a generic feature.
>>>>>>>>>>>
>>>>>>>>>>> Note: removal of cleancache in 5.17 kernel due to no users (sorry, we
>>>>>>>>>>> didn’t know at the time about this use case) might complicate
>>>>>>>>>>> upstreaming.
>>>>>>>>>>
>>>>>>>>>> we discussed another possible user last year: using MTE tag storage memory
>>>>>>>>>> while the storage is not getting used to store MTE tags [1].
>>>>>>>>>>
>>>>>>>>>> As long as the "ordinary RAM" that maps to a given MTE tag storage area does
>>>>>>>>>> not use MTE tagging, we can reuse the MTE tag storage ("almost ordinary RAM,
>>>>>>>>>> just that it doesn't support MTE itself") for different purposes.
>>>>>>>>>>
>>>>>>>>>> We need a guarantee that that memory can be freed up / migrated once the tag
>>>>>>>>>> storage gets activated.
>>>>>>>>>
>>>>>>>>> If I remember correctly, one of the issues with the MTE project that might be
>>>>>>>>> relevant to GCMA, was that userspace, once it gets a hold of a page, it can pin
>>>>>>>>> it for a very long time without specifying FOLL_LONGTERM.
>>>>>>>>>
>>>>>>>>> If I remember things correctly, there were two examples given for this; there
>>>>>>>>> might be more, or they might have been eliminated since then:
>>>>>>>>>
>>>>>>>>> * The page is used as a buffer for accesses to a file opened with
>>>>>>>>>      O_DIRECT.
>>>>>>>>>
>>>>>>>>> * 'vmsplice() can pin pages forever and doesn't use FOLL_LONGTERM yet' - that's
>>>>>>>>>      a direct quote from David [1].
>>>>>>>>>
>>>>>>>>> Depending on your usecases, failing the allocation might be acceptable, but for
>>>>>>>>> MTE that wasn't the case.
>>>>>>>>>
>>>>>>>>> Hope some of this is useful.
>>>>>>>>>
>>>>>>>>> [1] https://lore.kernel.org/linux-arm-kernel/4e7a4054-092c-4e34-ae00-0105d7c9343c@redhat.com/
>>>>>>>>
>>>>>>>> Thanks for the references! I'll read through these discussions to see
>>>>>>>> how much useful information for GCMA I can extract.
>>>>>>>
>>>>>>> I wanted to get an RFC code ahead of LSF/MM and just finished putting
>>>>>>> it together. Sorry for the last minute posting. You can find it here:
>>>>>>> https://lore.kernel.org/all/20250320173931.1583800-1-surenb@google.com/
>>>>>>
>>>>>> Sorry about the delay. Attached are the slides from my GCMA
>>>>>> presentation at the conference.
>>>>>
>>>>> Hi Folks,
>>>>
>>>> Hi,
>>>>
>>>>> As I'm getting close to finalizing the GCMA patchset, one question
>>>>> keeps bugging me. How do we account the memory that is allocated from
>>>>> GCMA... In case of CMA allocations, they are backed by the system
>>>>> memory, so accounting is straightforward, allocations contribute to
>>>>> RSS, counted towards memcg limits, etc. In case of GCMA, the backing
>>>>> memory is reserved memory (a carveout) not directly accessible by the
>>>>> rest of the system and not part of the total_memory. So, if a process
>>>>> allocates a buffer from GCMA, should it be accounted as a normal
>>>>> allocation from system memory or as something else entirely? Any
>>>>> thoughts?
>>>>
>>>> You mean, an application allocates the memory and maps it into its page
>>>> tables?
>>>
>>> Allocation will happen via cma_alloc() or a similar interface, so
>>> applications would have to use some driver to allocate from GCMA. Once
>>> allocated, an application can map that memory if the driver supports
>>> mapping.
>>
>> Right, and that might happen either through a VM_PFNMAP or !VM_PFNMAP
>> (ordinarily ref- and currently map-counted).
>>
>> In the insert_page() case we do an inc_mm_counter, which increases the RSS.
>>
>> That could happen with pages from carevouts (memblock allocations)
>> already, but we don't run into that in general I assume.
>>
>>>
>>>>
>>>> Can that memory get reclaimed somehow?
>>>
>>> Hmm. I assume that once a driver allocates pages from GCMA it won't
>>> put them into system-managed LRU or free them into buddy allocator for
>>> kernel to use. If it does then at the time of cma_release() it can't
>>> guarantee there are no more users for such pages.
>>>
>>>>
>>>> How would we be mapping these pages into processes (VM_PFNMAP or
>>>> "normal" mappings)?
>>>
>>> They would be normal mappings as the pages do have `struct page` but I
>>> expect these pages to be managed by the driver that allocated them
>>> rather than the core kernel itself.
>>>
>>> I was trying to design GCMA to be used as close to CMA as possible so
>>> that we can use the same cma_alloc/cma_release API and reuse CMA's
>>> page management code but the fact that CMA is backed by the system
>>> memory and GCMA is backed by a carveout makes it a bit difficult.
>>
>> Makes sense. So I assume memcg does not apply here already -- memcg does
>> not apply on the CMA layer IIRC.
>>
>> The RSS is a bit tricky. We would have to modify things like
>> inc_mm_counter() to special-case on these things.
>>
>> But then, smaps output would still count these pages towards the rss/pss
>> (e.g., mss->resident). So that needs care as well ...
> 
> In the end I decided to follow CMA as closely as possible, including
> accounting. GCMA and CMA both use reserved area and the difference is
> that CMA donates its memory to kernel to use for movable allocations
> while GCMA donates it to the cleancache. But once that donation is
> taken back by CMA/GCMA to satisfy cma_alloc() request, the memory
> usage is pretty much the same and therefore accounting should probably
> be the same. Anyway, that was the reasoning I eventually arrived at. I
> posted the GCMA patchset at [1] and included this reasoning in the
> cover letter. Happy to discuss this further in that patchset.

Right, probably best to keep it simple. Will these GCMA pages be 
accounted towards MemTotal like CMA pages would?

-- 
Cheers

David / dhildenb


