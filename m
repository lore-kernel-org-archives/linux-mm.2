Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A500CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77DA8E0065; Mon,  1 Sep 2025 12:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4EC08E0002; Mon,  1 Sep 2025 12:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3DF28E0065; Mon,  1 Sep 2025 12:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBC2E8E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:01:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F7461DEFAB
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:01:34 +0000 (UTC)
X-FDA: 83841146508.26.8A2461E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9B61E40002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:01:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q5nF++vp;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756742491; a=rsa-sha256;
	cv=none;
	b=wGLw1aXhf9hx5QU4o4woJIlE5kA97A1wUBWpgDqq08z86iD1kaupxJJTEVX+yCR3YDIBuS
	cc6bfCWPVYqyqIGGHrLOgu5MtCm5bbGUsGN6gG3f/ymx1F+KsgMFqGVoTk0cMVHnLIw6Lf
	oa26397KgFEVIWYks8K0r1GQerWl4Wg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q5nF++vp;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756742491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KXUKsbSXTtUwZbZjkOPsj5/++NmTAFntDIxsCFBmAY=;
	b=npiAteIVbJmCo+bbs00pczilQgewUzbv6N/Nqag4cxxhZHwThGtk2OCsdqJuSY964IbElV
	OLtOrN99FTdE2ABxILwD06i4Br2GhcXMZsWAmuw+1TkeTVk61/Tx5LopB7Rc65ImpBzfSu
	nyU1hq/CZ5LK/WQ+feNODRGGRH77qSE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756742491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9KXUKsbSXTtUwZbZjkOPsj5/++NmTAFntDIxsCFBmAY=;
	b=Q5nF++vp/vdQIfjQD+iANLOPOrU9hRbuiL7Erfu2f5cIcFkCnulsLcw7jKSRwudc3rH3YP
	KFnzHwceHbSfKRUQbHe1io2Bqqltc4TnzOPt5snWAOffM0057GImAkwqyGlnPMXF747KXi
	S5sYUvqETK60c7vzCyEX9KeH+ZzH3ZA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-agZj6qMIP_SyrSG4DQ2GDA-1; Mon, 01 Sep 2025 12:01:29 -0400
X-MC-Unique: agZj6qMIP_SyrSG4DQ2GDA-1
X-Mimecast-MFC-AGG-ID: agZj6qMIP_SyrSG4DQ2GDA_1756742488
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3d3d2472b92so1023226f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 09:01:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756742488; x=1757347288;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9KXUKsbSXTtUwZbZjkOPsj5/++NmTAFntDIxsCFBmAY=;
        b=AQLSDQkb1cs5HounRZtXb9AOrYnjk/3BFEnKo8+uFfM2GlrapVDxbJOVOUMQvz8Uoy
         7V7IHj1a8kPuYg9T/DBhSj75YBcw1/ILuovlohhK1pJ41xTUltZenLZPT6Y6xoTvblT6
         HXUoRrM5LyGbB7lx+J6yligIX8hsTnpnlTHuOapxxSEWEm5GcmUFGLnICSxcPGDpG7Qi
         8yJDYqfLsdzV4oDOV4l39PDKYm5A71vE281E2s8xLtWJiW/P2RtjP/GeLrvlX9gFcv7Y
         7nbJN/ddCxrKszZEA4kTh/ciO5RDlH2suQQEI9YZrnj8Bz7muIo3EEYQCSwFYaxXQ91f
         7hjA==
X-Forwarded-Encrypted: i=1; AJvYcCVxL1sQQ7amEUdU8X4H4tTaVlbdnMdLP8Hhg6LyJhpNd44f90NFWhKdEK4fTGXS3+mFpxRWhv8dLw==@kvack.org
X-Gm-Message-State: AOJu0YyspHkPjm5Nm0so41WEux3mkx5vFvLSQ0t7yEHEatwWD4RlrBly
	Yg8PS/emrXpEgLpwxfBeUiTPi6H+lFFrw4Rp2X6+S1VXafLkhO/hb46SdrEmxifxQf7FvzC1jMS
	4V9XFbNHqwU0lygrevhYMLMsZQhL/+RgXeTl+Gg0juETq6SCba/yl
X-Gm-Gg: ASbGncv7h8OY4/M+MXYWs5TQraVadNcLsR4fIocWMx21rvONVKuq0S2uW0SmnSn93Jg
	rGJ7NB/Z9UZYHSLHiJmNchHsl/PniyaLoztyf1cf7BWoaxZkAJzXZ+0hF/AFfAyvdQM8gVQECFK
	G6vWS4J/w8HrOhYZl+3b+f9VTxomPQnOwn3LP4tW8/92IreKK1f7XRM2cuA6O7Y05+JKPbjau2R
	SMN+5URLyJWqUAgCaWkUxv2v58hH6b9vxX9XtO9X2l+UgulunApN0zBb5WW5tXm2fmB/6DCY2ku
	5D2/95MbNfZgU04lj+5uXm34/XREag/aUrPjCxNwA8RfJ8M2Z2ROoKbneDbvZ/2+XfRthAW+AZa
	pE1fFczjibWP+c4kMTzeoF2A2yQTrrCxwbAdwavwN+IiwvKp5opnHvtm2nGrP3N3oLeQ=
X-Received: by 2002:a05:6000:178a:b0:3c9:c3dd:768b with SMTP id ffacd0b85a97d-3d1df630a6bmr5137141f8f.57.1756742488155;
        Mon, 01 Sep 2025 09:01:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEzEQvljSTA/KNdb629lJ4MJiVNmGvi7Mpl8CIV3Qw1tBSmwV0ovgWsJFQnlRKaVY1P0u+PA==
X-Received: by 2002:a05:6000:178a:b0:3c9:c3dd:768b with SMTP id ffacd0b85a97d-3d1df630a6bmr5137098f8f.57.1756742487600;
        Mon, 01 Sep 2025 09:01:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fbb3ccsm16037064f8f.51.2025.09.01.09.01.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 09:01:27 -0700 (PDT)
Message-ID: <ef8b8fe0-be77-429c-a474-be7b7f8be587@redhat.com>
Date: Mon, 1 Sep 2025 18:01:25 +0200
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpFBgYrOsAD5JbuBOMUVJo7H5e_qDxjxPsqHH1SSQum9Xg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kiXUdoXlQHy1Sm4Wb7qpaMDoNnmUi5-j5SQbckzJA3U_1756742488
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B61E40002
X-Stat-Signature: ehyjc8ic4bqy1k3ujr7qo3gyzd35c5di
X-Rspam-User: 
X-HE-Tag: 1756742491-153881
X-HE-Meta: U2FsdGVkX19DAq184W8hkZvqDD16/SmlMeaQt+9yX7TtZc262v8WQGdJnx4Wlpooy5uXt4TmU/pISVFAx4VShWV3OQVJskxRjZFYXyOK/yRUF0X+6tnQr6NHLtKgluQMhqs3IJKbx5b956S91L7VFroHon7KbwJs5h7Hq4i1tlOhjO3K1W1zPbU7uxHglFcP+GutRX7jak5dUWFvTlWxqOZEk/b8/TWt+Nm+lVLWE+CVgRNrVJnVwArAJZESM94zF/zgRRMPaJxGTx5+LmKDQQBAukBP4UjhufvYbG0g/RqX3t5Epzwkj5s9xQSIYdY9SmQxd7W2WTr0DDJwGJUTJ2vCpNBPe8fgc1Yi9VxSbee/CaW7aI/WAWCjKJQ17pKdwXtKcZKl5jrYlPH66xBm91cK4XAqlRhO0/TsxK8D4Elw5L7qAUucKYToMGtXZJUeaaEmtTnlQH0UeqVR8PJ66/t4ZFdFSFYP5r3TaaTyebsvnqAoRugP+ZYvUJXaoCoVt/vr6BkbmulYHNlP6a1dYo2OV4SAmVB8+DlazuPGW6Pii+xnQMxbdybLZTc1lv/tbOR7k9LIVYoSdIy3JCbAaSWoZ2tuFqxhBV0DBx0gVx4gK5Tz5Wav86WLkAEUm5du2CvqYWe3i28EKke7gvo6fDvusQM4lvSxGfEeOxSIdRQ6EdD3tsRVZoaAsBrnUJzdl8bcuKwiO9/DJcYMYGBRC+UwmWuLCQ6GURs845DNv9vO5/I7k2XPfJC097nD5lAd9Bw9sr5ZTktwnILa3ZSFStT9FGl7R8B6+sFQbwjTyJz2DOThIUVLfG4wnPv33gZYJ7hLuljJfdP6FEEnSSfgEdPBxTmnSScWKgKIbceXpwnvjLp5eYJI+/qKRf5UxaUjXzUvG6MQ2gsoHUQdUg+r4KKuhThOeVLoDQ4qSXr4uk48SjF8zUoeHHDlANVYrqh30WiRfV2+klD70Lr9q4V
 ZCTcULJp
 n0t9BLkgzJm2TEpiS3Q2Pwin393lCnVVepni/ruw/+BKKANJe8cImCyyT3Ku9krm1l97r3IxjjGGmbFaxejTTK8zEnJPcByIuqRhTjBxg7Xu7A6Zql4+MtJG7pn3SBf+JCpiN2Nj1DyCb2Hcg8tm1ZLWpBF+JmW3u59WonB6UyxLplesZAlqMtV4U6pehOumkI5ftyhg3qXwVlmnrnE1COZnMya1/2EgpdmTC49XH3BT323zYMVY2jrj/hTHpu0abyeEzoFP/cd0aMylYn5DlTN0iWPj8yOOSa9clxOyEu2oaL0OHgwzyjNDTUCQMrY4psi4QSZb0l+rhLazPkIWl74s7S1yVyItTCpkjVyF6+CwKL3Oxbo3ANaxT7zNQmIC8EBQ2i3Jx1XhWA/f8PJbPqEJ/qzvPuD9Kpk5B2dY6VflHUfR4U/YXsuOy4ZyPpAY+3lp9P08t0NLeI8/PwqMoFnrFuHJP4Z5YXvtaUWA7aoqxY89HChWX5eG5iS8ZVH5MwqXQW/VNu1kh0uWWPszZjVwJGZxhU5LOj1lYKojZEN/uTGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 02:17, Suren Baghdasaryan wrote:
> On Tue, Aug 26, 2025 at 1:58 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 23.08.25 00:14, Suren Baghdasaryan wrote:
>>> On Wed, Apr 2, 2025 at 9:35 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>
>>>> On Thu, Mar 20, 2025 at 11:06 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>>
>>>>> On Tue, Feb 4, 2025 at 8:33 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>>>
>>>>>> On Tue, Feb 4, 2025 at 3:23 AM Alexandru Elisei
>>>>>> <alexandru.elisei@arm.com> wrote:
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> On Tue, Feb 04, 2025 at 09:18:20AM +0100, David Hildenbrand wrote:
>>>>>>>> On 02.02.25 01:19, Suren Baghdasaryan wrote:
>>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>>> I would like to discuss the Guaranteed Contiguous Memory Allocator
>>>>>>>>> (GCMA) mechanism that is being used by many Android vendors as an
>>>>>>>>> out-of-tree feature, collect input on its possible usefulness for
>>>>>>>>> others, feasibility to upstream and suggestions for possible better
>>>>>>>>> alternatives.
>>>>>>>>>
>>>>>>>>> Problem statement: Some workloads/hardware require physically
>>>>>>>>> contiguous memory and carving out reserved memory areas for such
>>>>>>>>> allocations often lead to inefficient usage of those carveouts. CMA
>>>>>>>>> was designed to solve this inefficiency by allowing movable memory
>>>>>>>>> allocations to use this reserved memory when it’s otherwise unused.
>>>>>>>>> When a contiguous memory allocation is requested, CMA finds the
>>>>>>>>> requested contiguous area, possibly migrating some of the movable
>>>>>>>>> pages out of that area.
>>>>>>>>> In latency-sensitive use cases, like face unlock on phones, we need to
>>>>>>>>> allocate contiguous memory quickly and page migration in CMA takes
>>>>>>>>> enough time to cause user-perceptible lag. Such allocations can also
>>>>>>>>> fail if page migration is not possible.
>>>>>>>>>
>>>>>>>>> GCMA (Guaranteed CMA) is a mechanism previously proposed in [1] which
>>>>>>>>> was not upstreamed but got adopted later by many Android vendors as an
>>>>>>>>> out-of-tree feature. It is similar to CMA but backing memory is
>>>>>>>>> cleancache backend, containing only clean file-backed pages. Most
>>>>>>>>> importantly, the kernel can’t take a reference to pages from the
>>>>>>>>> cleancache, therefore can’t prevent GCMA from quickly dropping them
>>>>>>>>> when required. This guarantees GCMA low allocation latency and
>>>>>>>>> improves allocation success rate.
>>>>>>>>>
>>>>>>>>> We would like to standardize GCMA implementation and upstream it since
>>>>>>>>> many Android vendors are asking to include it as a generic feature.
>>>>>>>>>
>>>>>>>>> Note: removal of cleancache in 5.17 kernel due to no users (sorry, we
>>>>>>>>> didn’t know at the time about this use case) might complicate
>>>>>>>>> upstreaming.
>>>>>>>>
>>>>>>>> we discussed another possible user last year: using MTE tag storage memory
>>>>>>>> while the storage is not getting used to store MTE tags [1].
>>>>>>>>
>>>>>>>> As long as the "ordinary RAM" that maps to a given MTE tag storage area does
>>>>>>>> not use MTE tagging, we can reuse the MTE tag storage ("almost ordinary RAM,
>>>>>>>> just that it doesn't support MTE itself") for different purposes.
>>>>>>>>
>>>>>>>> We need a guarantee that that memory can be freed up / migrated once the tag
>>>>>>>> storage gets activated.
>>>>>>>
>>>>>>> If I remember correctly, one of the issues with the MTE project that might be
>>>>>>> relevant to GCMA, was that userspace, once it gets a hold of a page, it can pin
>>>>>>> it for a very long time without specifying FOLL_LONGTERM.
>>>>>>>
>>>>>>> If I remember things correctly, there were two examples given for this; there
>>>>>>> might be more, or they might have been eliminated since then:
>>>>>>>
>>>>>>> * The page is used as a buffer for accesses to a file opened with
>>>>>>>     O_DIRECT.
>>>>>>>
>>>>>>> * 'vmsplice() can pin pages forever and doesn't use FOLL_LONGTERM yet' - that's
>>>>>>>     a direct quote from David [1].
>>>>>>>
>>>>>>> Depending on your usecases, failing the allocation might be acceptable, but for
>>>>>>> MTE that wasn't the case.
>>>>>>>
>>>>>>> Hope some of this is useful.
>>>>>>>
>>>>>>> [1] https://lore.kernel.org/linux-arm-kernel/4e7a4054-092c-4e34-ae00-0105d7c9343c@redhat.com/
>>>>>>
>>>>>> Thanks for the references! I'll read through these discussions to see
>>>>>> how much useful information for GCMA I can extract.
>>>>>
>>>>> I wanted to get an RFC code ahead of LSF/MM and just finished putting
>>>>> it together. Sorry for the last minute posting. You can find it here:
>>>>> https://lore.kernel.org/all/20250320173931.1583800-1-surenb@google.com/
>>>>
>>>> Sorry about the delay. Attached are the slides from my GCMA
>>>> presentation at the conference.
>>>
>>> Hi Folks,
>>
>> Hi,
>>
>>> As I'm getting close to finalizing the GCMA patchset, one question
>>> keeps bugging me. How do we account the memory that is allocated from
>>> GCMA... In case of CMA allocations, they are backed by the system
>>> memory, so accounting is straightforward, allocations contribute to
>>> RSS, counted towards memcg limits, etc. In case of GCMA, the backing
>>> memory is reserved memory (a carveout) not directly accessible by the
>>> rest of the system and not part of the total_memory. So, if a process
>>> allocates a buffer from GCMA, should it be accounted as a normal
>>> allocation from system memory or as something else entirely? Any
>>> thoughts?
>>
>> You mean, an application allocates the memory and maps it into its page
>> tables?
> 
> Allocation will happen via cma_alloc() or a similar interface, so
> applications would have to use some driver to allocate from GCMA. Once
> allocated, an application can map that memory if the driver supports
> mapping.

Right, and that might happen either through a VM_PFNMAP or !VM_PFNMAP 
(ordinarily ref- and currently map-counted).

In the insert_page() case we do an inc_mm_counter, which increases the RSS.

That could happen with pages from carevouts (memblock allocations) 
already, but we don't run into that in general I assume.

> 
>>
>> Can that memory get reclaimed somehow?
> 
> Hmm. I assume that once a driver allocates pages from GCMA it won't
> put them into system-managed LRU or free them into buddy allocator for
> kernel to use. If it does then at the time of cma_release() it can't
> guarantee there are no more users for such pages.
> 
>>
>> How would we be mapping these pages into processes (VM_PFNMAP or
>> "normal" mappings)?
> 
> They would be normal mappings as the pages do have `struct page` but I
> expect these pages to be managed by the driver that allocated them
> rather than the core kernel itself.
> 
> I was trying to design GCMA to be used as close to CMA as possible so
> that we can use the same cma_alloc/cma_release API and reuse CMA's
> page management code but the fact that CMA is backed by the system
> memory and GCMA is backed by a carveout makes it a bit difficult.

Makes sense. So I assume memcg does not apply here already -- memcg does 
not apply on the CMA layer IIRC.

The RSS is a bit tricky. We would have to modify things like 
inc_mm_counter() to special-case on these things.

But then, smaps output would still count these pages towards the rss/pss 
(e.g., mss->resident). So that needs care as well ...

-- 
Cheers

David / dhildenb


