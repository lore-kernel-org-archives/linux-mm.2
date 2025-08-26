Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC610CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 15:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9236B00A9; Tue, 26 Aug 2025 11:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0896B00AA; Tue, 26 Aug 2025 11:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AF686B015C; Tue, 26 Aug 2025 11:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2716B00A9
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:24:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B241B117460
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:24:32 +0000 (UTC)
X-FDA: 83819280384.16.D3601E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2BCBE4000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:24:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BsD9Bioj;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756221870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dRYmdfYPQDBHIeqCHeCxbojw8+BOvuY6ncQfuP6l7w=;
	b=UBxJJJgB0x+W05SrV5hB0KvkWdkjcdfn4Xh08T4W/8rZLJhux2QAUCd3Tw4N2eh2AIC+MF
	ZS7E04cTK0PjobNU0KEfJg7+IYkBgjReo2AlrwzcrCn+Qze+PHl8G9ZVvU/iKbHmMUeGBP
	QBcmganFHocO01QCP71gdXpjXsAzrEA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BsD9Bioj;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756221870; a=rsa-sha256;
	cv=none;
	b=bk7wOUUCViIsnDDUg3vwuczYovDzrDgqCedwinprYlxxppkSNXTdxcpvstgIXVaghvjfYj
	sSCMDq4L3UFotZ8jflH8gcP4HuXCJNF5edOZ2YJ8QitwMNoGs+HqFtmKqA1Kms+raNTJb8
	oBvZFICMm3+p+HjGRcG+J2asbELdAI0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756221869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8dRYmdfYPQDBHIeqCHeCxbojw8+BOvuY6ncQfuP6l7w=;
	b=BsD9BiojwOxEFeuZZZo0p9josyMGXEMznxdTFEIkWDzcfGGFmxZOw1VbfZhsgDbhOvKlhB
	K8LaA6mchO00t+JTLiQXPCorIq+mgsuON874Vm9SVprXaeEPtvfEclkXE8NZuRUp6tEGH/
	GU5WUVcwdWNt8cDd2EtvS1M6kH5ETJg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-wqHtl89gNIi8mo86twZZig-1; Tue, 26 Aug 2025 11:24:27 -0400
X-MC-Unique: wqHtl89gNIi8mo86twZZig-1
X-Mimecast-MFC-AGG-ID: wqHtl89gNIi8mo86twZZig_1756221867
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9dc5c2ba0so2212274f8f.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:24:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756221866; x=1756826666;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8dRYmdfYPQDBHIeqCHeCxbojw8+BOvuY6ncQfuP6l7w=;
        b=VKIsdW35AOiJCB7+3XsIoxL/gF3TUxySLIT9Q8eon4IROdK+y3fWy8oKJhTf/dka6Y
         jLdTn/PQLmLVPgHUB9GFUp8EJVVDCqdXpYCazOU8tsXBxkpwb2MQzCW5KEmdicj+HcHU
         M6+NZyc5/Q01GC9/R9I9BJZR3CUDvr0K1AptReZZh3qhNYQcI74LiVCJX9fQN6t14mOC
         DnobDN+E8qgvlrpea61oxDI0CcKgi0/aOgSdiE8zbpa5difPrXdsaeoj2E5W15oXJxlJ
         jkoKAqWegaloeHhlfnIiFNCBbJvKmH5NgdiDUrx/R8MgEu8aPdeA3OHOPG91IFjxNjaO
         qvtg==
X-Forwarded-Encrypted: i=1; AJvYcCWTpqOs4Fdj7sHEoHTlsDGUcTQeox1rJoS7Q/dReavt4YqI9b/vUrHrK36PmACT6xHebr9zGEMuAw==@kvack.org
X-Gm-Message-State: AOJu0YwAai4LFELuSgoM4xM9xjU4g8GQleg3nvoGS38Mg+ciqHNwABrL
	5U7IClfEoUa3VztaaLnH+QfNQfLRzVOeiT3ZiCsu+Zxp7gzSrC8r9GAA7K4/G5zZYRqP/79tlli
	yuONOhSnKYwEduYRJFyklElakDHs/UzEQ043PSd08thWRcocoEJUZ
X-Gm-Gg: ASbGncuLyC6jTlCZdRAcqeT5XBhYpiUjtVLjOsV4LwDVXStJ08PqRmkHjkG2CMJJ9sq
	OT3HiP5PwFkFKkSBRvYUOuBgxOZFmasI9WkfOleNVfRP/JUFJWx/+2SWz0P1/RM1ZI289A89Di2
	r3HCoP4XPCQnh3n9r3wQgKC5qaUoweseLjDoXnGDpEt6uohrxyxncyz7HQRND7GO/zYqPV69cxU
	uDm882Eqwt4/FnKLLCW0UMik2ZWfaofOGbfatFYc+bTeI9CzKurYz/oVtN1F/6aIgHklwv1f3Oh
	7INT9Zp2rGy7gqZU6hSWhMcL9uPx6Kzr8/7SvMtVtoTAHLtKuOuu8rsnDqQekuqGx80v7x29Vw=
	=
X-Received: by 2002:a05:6000:178a:b0:3c8:9438:8b93 with SMTP id ffacd0b85a97d-3c894388fa3mr7039284f8f.60.1756221866156;
        Tue, 26 Aug 2025 08:24:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7tUX8+axqOYguUOQKRRwlbVCfKARwI+7junufYEnF30XOVYwqq/xeCLNzXlGq7X6f4v1Ocg==
X-Received: by 2002:a05:6000:178a:b0:3c8:9438:8b93 with SMTP id ffacd0b85a97d-3c894388fa3mr7039200f8f.60.1756221865437;
        Tue, 26 Aug 2025 08:24:25 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70eb7eed5sm16180834f8f.18.2025.08.26.08.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 08:24:24 -0700 (PDT)
Message-ID: <e91f7a38-3b17-4a0c-aedb-8b404d40cf59@redhat.com>
Date: Tue, 26 Aug 2025 17:24:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/10] mm: update fork mm->flags initialisation to use
 bitmap
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Kan Liang <kan.liang@linux.intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
 Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <9fb8954a7a0f0184f012a8e66f8565bcbab014ba.1755012943.git.lorenzo.stoakes@oracle.com>
 <73a39f45-e10c-42f8-819b-7289733eae03@redhat.com>
 <d4f8346d-42eb-48db-962d-6bc0fc348510@lucifer.local>
 <d39e029a-8c12-42fb-8046-8e4a568134dc@redhat.com>
 <1743164d-c2d2-44a1-a2a9-aeeed8c13bc8@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <1743164d-c2d2-44a1-a2a9-aeeed8c13bc8@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mtbhKZius-8J6enxZNJyGaVTiVafgr4_lBBWfONO1VE_1756221867
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2BCBE4000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: pd7br3to6otatg3ics9sj7tu4so5whke
X-HE-Tag: 1756221869-465137
X-HE-Meta: U2FsdGVkX1/o0M7n/5cOSwOaGTVKYgR67HPvCd0XETaa1rlrtEzpsyoUqMpZKJXvsPL1eA+0Jjniw1cyc4WjVwCMFVWCxDwewkq8H3tTDW2alTww/0HZ9J81L1ZpwtoOISlvWvLOCBc8TkB+GGt1KNZ2DPm2NdHEWeLSx/lLFh9Wajc8McN7FN3cJeYmLhLjLR1MM0NJ1SfyF++cddWBKopSWzzozg9M4bD3uW7nMcR03Ck7zr7Eo4MKbKkUrubdCMeKfPF+UzKDDmluxoFPurG2W4UpFA6xSwe4TsO/2aTA01hUkvub+j6DmXAWBNYQoMh/L/52j+q/bUg8HtWIdPYDQ0d4rrxoSInyGYrFQWHMXo69LVAMUi3GEFI6RF36G2F7lTeQW4eUYEIM7+kMsxEsbo2y10TGyT1LYui3e216h9pb5JmJyZdo8nc/VLhR089cPieZePN35s3wGYN2KdZxepnlNsJMSxXFX+nYUW5WTHpac3EsRlb762X6YuvzGrl5xUxohCcDeaFpPPOPIEq931RoNvffxBefdkKZNiKV7vCS98rHvtmbCGpkUjupphM9NoirESXKNGUEx62yFpqzgayxjqToNwSYj+hDDBU+Xy5F5Y16rOnK3i7qmLJFBbdKpDUZgZoHTJjUHRaCf7adpDY1SZ7S97PvjLT7vWEPf2KO639BMA06ItHuGZehTkQtlIXeJ85NBn3NrAY6Wq3Bqy9m4WTBigJmwDlgmR3YTlS0ntkLcfd9ZhVy2cRwy9cVtfe7ng7mlntW4aHuhgnmBZph3CoLQzWmsqJanyi0gKtiZBw7bn1/KE5+JT+ki4JqFtfdQJe836slR9rZ/Q/5D+UIMhtIl7yEhCFmU71og2HTDIbZzu6jtfY9N1FFCyweWF6pnvMVE7ie4B7LPEqUktVCLO8OedW4DeIF0lvCHuukPFsl89izK0ZKVmnzJ+3rAJoqcuPYtPM+c4W
 pldsSQu1
 aYzdn3lCDrjQG3DamZMnm/QZpjVxZ4uaxgu1v5LVBnGtMa5My2a2CUi9a1di3avC4+CCPE/L7zN7t5hVRkiTrYykk57irUQaudtZyALei1+q0s2BynSWq/qt4aqqFNCpJ1FPOU3Cj47/dbQ84zUDb7R0Y8EfEhJOjj5SojIvYdQ3JLxV0p18D0v8/MmBNl9ivIOCbdSJhlW8iCcoXMBQ3ZOnDsHaa2z8uFM2O366baRG+2BlB0ot5eRayMmtkMejGTngKzV0CCSZL2tSSr/xtT87IxzSm6Y9m/BVVLAtZ5D4qTBSp+4S3hUnJ8sLDdKq5u04CLBzVZO+zxHGxuMoiXKZ7y3U1FJdnQtA+68HDUniSQavJECb52ej3+3RpooahWv6NgmKNNqjIfSPnUlZMHT2cVFtmP21pm+Sz2GBdTCkJc75XDs/iCwhyjuy5D1RSX6GAlIVU8Di/Iqw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 16:32, Lorenzo Stoakes wrote:
> On Tue, Aug 26, 2025 at 04:28:20PM +0200, David Hildenbrand wrote:
>> On 26.08.25 16:21, Lorenzo Stoakes wrote:
>>> On Tue, Aug 26, 2025 at 03:12:08PM +0200, David Hildenbrand wrote:
>>>> On 12.08.25 17:44, Lorenzo Stoakes wrote:
>>>>> We now need to account for flag initialisation on fork. We retain the
>>>>> existing logic as much as we can, but dub the existing flag mask legacy.
>>>>>
>>>>> These flags are therefore required to fit in the first 32-bits of the flags
>>>>> field.
>>>>>
>>>>> However, further flag propagation upon fork can be implemented in mm_init()
>>>>> on a per-flag basis.
>>>>>
>>>>> We ensure we clear the entire bitmap prior to setting it, and use
>>>>> __mm_flags_get_word() and __mm_flags_set_word() to manipulate these legacy
>>>>> fields efficiently.
>>>>>
>>>>> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>> ---
>>>>>     include/linux/mm_types.h | 13 ++++++++++---
>>>>>     kernel/fork.c            |  7 +++++--
>>>>>     2 files changed, 15 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>>>>> index 38b3fa927997..25577ab39094 100644
>>>>> --- a/include/linux/mm_types.h
>>>>> +++ b/include/linux/mm_types.h
>>>>> @@ -1820,16 +1820,23 @@ enum {
>>>>>     #define MMF_TOPDOWN		31	/* mm searches top down by default */
>>>>>     #define MMF_TOPDOWN_MASK	_BITUL(MMF_TOPDOWN)
>>>>> -#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
>>>>> +#define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
>>>>>     				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
>>>>>     				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
>>>>> -static inline unsigned long mmf_init_flags(unsigned long flags)
>>>>> +/* Legacy flags must fit within 32 bits. */
>>>>> +static_assert((u64)MMF_INIT_LEGACY_MASK <= (u64)UINT_MAX);
>>>>
>>>> Why not use the magic number 32 you are mentioning in the comment? :)
>>>
>>> Meh I mean UINT_MAX works as a good 'any bit' mask and this will work on
>>> both 32-bit and 64-bit systems.
>>>
>>>>
>>>> static_assert((u32)MMF_INIT_LEGACY_MASK != MMF_INIT_LEGACY_MASK);
>>>
>>> On 32-bit that'd not work would it?
>>
>> On 32bit, BIT(32) would exceed the shift width of unsigned long -> undefined
>> behavior.
>>
>> The compiler should naturally complain.
> 
> Yeah, I don't love that sorry. Firstly it's a warning, so you may well miss it
> (I just tried), 

Upstream bots usually complain at you for warnings :P

> and secondly you're making the static assert not have any
> meaning except that you expect to trigger a compiler warning, it's a bit
> bizarre.

On 64 bit where BIT(32) *makes any sense* it triggers as expected, no?

> 
> My solution works (unless you can see a reason it shouldn't) and I don't find
> this approach any simpler.

Please explain to me like I am a 5 yo how your approach works with 
BIT(32) on 32bit when the behavior on 32bit is undefined. :P

-- 
Cheers

David / dhildenb


