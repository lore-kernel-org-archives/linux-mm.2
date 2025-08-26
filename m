Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 745E8CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 15:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C264A6B02AA; Tue, 26 Aug 2025 11:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7056B02AC; Tue, 26 Aug 2025 11:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77C96B02AD; Tue, 26 Aug 2025 11:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90C306B02AA
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:53:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4FB361601C2
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:53:46 +0000 (UTC)
X-FDA: 83819354052.28.C03F408
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C5A0D2000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:53:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A5Dlq2GW;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756223624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+U14wXv0VhbfGH2miM5ngrvAv4bmmIvsTMUNtMccNUc=;
	b=cJ9xZb/7w2U4lE4uyUCLmXFRq6QyhsqXSOPEdiBdAVPEjfzZiG9/0UJ2RfvlIHIR7Ddah0
	esxB0PXuv7xR6cxo7pUnjYICyie+HDSds6I53txD0NU4ztPEizl6M9NfZ/PMabeb2WlFpp
	rn2PkJ64GXHfh1L560vwyGLv94fLkco=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A5Dlq2GW;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756223624; a=rsa-sha256;
	cv=none;
	b=DadCYMu8cQaFPEiXNAir2B8rz5U0O7KQlEfRE+RpP9Amf2T4j1xWkjYQvr2OacpFxLgeYQ
	QunnLFZoF8Gn1JqCeV61fC6I7K3wysPOZ+Tka2uKnOTJisuQhWuW60ZnMJwSyoS5DPbMk9
	KLtXa1xlM1m9yXpSZqrQaKZiZyRKFUA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756223623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+U14wXv0VhbfGH2miM5ngrvAv4bmmIvsTMUNtMccNUc=;
	b=A5Dlq2GW+ORpVuFEmP1VF3Zeib4UDYuxfS/4IjSp4NZEVVcyvUa4sEWkUNv62dHaFXO5pQ
	1S+LkxXkV2Xtgq+Wy1t2wxNx/tl0BFLalH480JCWQSqmXudC8iPK4UDn5KT2LoZDyR7Qig
	z3xEHK0Sh56NxBgnlkm7sd13qcegodU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-ZFebA8y9MIW9Tn9jAGVBFQ-1; Tue, 26 Aug 2025 11:53:42 -0400
X-MC-Unique: ZFebA8y9MIW9Tn9jAGVBFQ-1
X-Mimecast-MFC-AGG-ID: ZFebA8y9MIW9Tn9jAGVBFQ_1756223621
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b04f817so24476605e9.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:53:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756223621; x=1756828421;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+U14wXv0VhbfGH2miM5ngrvAv4bmmIvsTMUNtMccNUc=;
        b=aeIK0fc3+bktHiZn44tww1nE67nFz3NDDPtrnHxSEQR9ErsVHCiQjS1Pbfw2NWG6dS
         TgnAkUDFMezsnkhWsuBUf6G0dcXZ63sWQDP3VXyD75diWDCS8bux6z+w65hjWvjv+maI
         ALQI84zAKG4U1daw3eNPhMswh5whlT6ATDt3uEd/UHwasULca0mVwcpY0LLzgvvgoMw8
         en3yxsNnkL4Gq1rcHhW8SjcJc7wxJ6AmLgDW6zw3h1VHXugf67AK9o1S6cCeNDccGQwr
         AcWNpXco+uMrVkQQo38L1CDV0aUwz4whz0XJrG9MwdFs6kgWhgjf800kfS19mQTzF+DO
         cy4g==
X-Forwarded-Encrypted: i=1; AJvYcCVomx4Qt4QFCQODy8yKJR6tKRVV7zpbxotOtbRZSDujjadPeaeqYCYTLICzZ83iZEAZrYSsne78rA==@kvack.org
X-Gm-Message-State: AOJu0YwLCWJpYbC4TNdnP/5tGdXgfrtlfERWvlpnGURkKbtALgnmIuKm
	HruKUE6G0js1QqqLM7g7sZNiNDX3h0I7Jhkrf6lt6wCGlaDDNm2lGLji9Mr9JojURy2hAhTFf5M
	g5WDiDmdwoL9DBV//66hxkXnjWOUA9sTVadmFE0kTg4ha9517hWi+
X-Gm-Gg: ASbGnctiPKB9L5JvMjM1DA5RdEFnMh02SNpbtUDGxyIEUmvMw6AHaaA1lxALiFCAMMm
	VkcHNm28C10SYvC6wCzWu2tc6+A7GXf0/Ier9C7YnjNzawqyaB2V4sIiZPBeF7fSxPKIDY0aYaP
	mwiY3T9sSsrWIky1Yqq+Y7E/pn9v5fhVWdlF+2DjmxSLgqAYW7GUEtwZMkqv21qZbow03yoeS12
	wHGMTTNthp6l3YMBxvHH4RYKBjbRLrU4pycFPEEeogZu/zYSCrGRNz6WNMDg0EFW8cq1Ta35/k+
	hlmhG/2lm+7Ld4N2bhJOfF4iXqgvPaGLM/6pc1lygEFGiTjDthzVS81S6r/3Bkmh5/6Q+3tn
X-Received: by 2002:a05:600c:4ed0:b0:459:dfde:3323 with SMTP id 5b1f17b1804b1-45b517cfb81mr136206265e9.27.1756223620417;
        Tue, 26 Aug 2025 08:53:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSFZHuF3ZmBgbb1DmR6AWyXPp01fHC/E5LsiIPukWcFbvko5eip1UQdcjgn0D15hklxp1KaQ==
X-Received: by 2002:a05:600c:4ed0:b0:459:dfde:3323 with SMTP id 5b1f17b1804b1-45b517cfb81mr136205695e9.27.1756223619755;
        Tue, 26 Aug 2025 08:53:39 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c711211cc8sm16703127f8f.36.2025.08.26.08.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 08:53:39 -0700 (PDT)
Message-ID: <49df1a2a-7c5b-4ada-98b8-8d7871fd7228@redhat.com>
Date: Tue, 26 Aug 2025 17:53:36 +0200
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
 <e91f7a38-3b17-4a0c-aedb-8b404d40cf59@redhat.com>
 <9e7f5149-afb7-4e94-b231-78876c41a438@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9e7f5149-afb7-4e94-b231-78876c41a438@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YoBtbUvsKKBT9amKbbDctsQg40HBjQW7fv8b1HrY3yw_1756223621
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C5A0D2000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: y4z3xudxq778yq5p3j738gbm8uwq7mqj
X-HE-Tag: 1756223623-103537
X-HE-Meta: U2FsdGVkX1/a50GkVJLkY0Yh4R4F6N9ELdnCDx2RbbHajCtH6DuYazvGgpBgOwtfGkLA2ibIQhUszdXQveih9Y7yGCKCCUimBi5/99ShHBWGSYATFmouKeBdDUVyINmAMgFFGS6Nqi9EIQEVb6dVrl7kdcfUMZAKiVyxP9/PvIIJ5Lc4jj3dec68n6NPZ1D7deflGRm5hDsSs695fkKMy8aH3PTyVqpD5Fe9DPTnu6VC0fqDAnkOFBGyYf7ycHZKrevSDEJ4a9nr9eSFUraQ9E6huFDymmB5eCrme88m1SoZjTYdT2XSrLBegWVlPZKKqkWT4cN19Wf+S+rRaUuPtOnn740+Z2pJVz0Q70OQSmqv3lpt9emUb2IITyH1DbnqTv4+g3ZH6ZqkQffRhqYnOGaYNTObLtbC0b4jwKFv0WYyOJ5s8OjF6xdfuOsaTgCwlzUOhP15BT6Gkq70e9r8PxUZnQ/C5gkBENWq5pvQzXlIzzjzzQlq1yf9Ah3VoECewPyFD1UwO9JaWp48QG/rZrgvByRwb/e0WkDKL1Mq36RdlWYgQOU0nOC1qlSuz0QhkJ+U9+XTUrueYsi30UK22q7/HL2pUw88VIm8MzCPSzHYTFIKJoTZ8iNQhnb51i3uIVbn+qh+dphd66tcxEQgKEaIx4cKuxa8biTwLXSPToHHokQieNzOGGzgHab5K7RqvP2w5G7SZwwToazKIWVumRgge2GKY0kWYuLsQGpvqhIggd6fGg//Mg8uIp9kGW33Olu5S/mazdExL0lMmsnyfxfHTAlQ+okBqhF5ft9p46uExC7ik/l9Kk5XrxEluMIZlP+wg8x6wnH6WE4ncahbEnuAv2klWfJhSOYZbihbfLsgpWItDadNn1gvTheJ9qA3Qx7UtYf27shR+ButBVu5IEv0xNCbbeP3WZGc6NI0d9C89AQd8Ib5Z7q8/UDBkDrJjWSO2h8F46mGw67E3BF
 veWAYzvH
 DDCVY87+X48i1YTZwLNEAQY8dSMw2TEw0E7Ko0E1+frPnC6X2COxtwxN9nV9NIIaN51B76I11k3yJ/Eg+XLliwTpFyj6gU4dT+vjx4RxP/Eyk6Ndf4Rd1Fqt8xzVuGFUSdksi6bvcCAUpmiizo1tZYYHVyLXn1Qg/7WCfPuRIo4Xb3lKDIOhkN7Jtw0NxvKweonG90fg13AUCFbcQNxUQ8dTEBU86P1hcTSixuWfxsWzJt2/3jsYCBJJdSUNB5YXCCV6/oiqeOLkpZ9wB07iP2BNJ2mmG1sJ9LzzB4Cn/ro/d/d6kGRaj0h3ygUSKm1w+m6BuLXSEo1u9H1N5kI9R6ps+UH7hGklEaRbTozuAUUU4D9rz/In3uOnt7Xw4aGDU9GjATCvSiontUP6ot4GOVupjq+Rmpnimb2thKwrZW5ZjYjsghBjWnpCq2hdeZAmZLMubppgbLQUOFq4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 17:39, Lorenzo Stoakes wrote:
> On Tue, Aug 26, 2025 at 05:24:22PM +0200, David Hildenbrand wrote:
>> On 26.08.25 16:32, Lorenzo Stoakes wrote:
>>> On Tue, Aug 26, 2025 at 04:28:20PM +0200, David Hildenbrand wrote:
>>>> On 26.08.25 16:21, Lorenzo Stoakes wrote:
>>>>> On Tue, Aug 26, 2025 at 03:12:08PM +0200, David Hildenbrand wrote:
>>>>>> On 12.08.25 17:44, Lorenzo Stoakes wrote:
>>>>>>> We now need to account for flag initialisation on fork. We retain the
>>>>>>> existing logic as much as we can, but dub the existing flag mask legacy.
>>>>>>>
>>>>>>> These flags are therefore required to fit in the first 32-bits of the flags
>>>>>>> field.
>>>>>>>
>>>>>>> However, further flag propagation upon fork can be implemented in mm_init()
>>>>>>> on a per-flag basis.
>>>>>>>
>>>>>>> We ensure we clear the entire bitmap prior to setting it, and use
>>>>>>> __mm_flags_get_word() and __mm_flags_set_word() to manipulate these legacy
>>>>>>> fields efficiently.
>>>>>>>
>>>>>>> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>>>> ---
>>>>>>>      include/linux/mm_types.h | 13 ++++++++++---
>>>>>>>      kernel/fork.c            |  7 +++++--
>>>>>>>      2 files changed, 15 insertions(+), 5 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>>>>>>> index 38b3fa927997..25577ab39094 100644
>>>>>>> --- a/include/linux/mm_types.h
>>>>>>> +++ b/include/linux/mm_types.h
>>>>>>> @@ -1820,16 +1820,23 @@ enum {
>>>>>>>      #define MMF_TOPDOWN		31	/* mm searches top down by default */
>>>>>>>      #define MMF_TOPDOWN_MASK	_BITUL(MMF_TOPDOWN)
>>>>>>> -#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
>>>>>>> +#define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
>>>>>>>      				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
>>>>>>>      				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
>>>>>>> -static inline unsigned long mmf_init_flags(unsigned long flags)
>>>>>>> +/* Legacy flags must fit within 32 bits. */
>>>>>>> +static_assert((u64)MMF_INIT_LEGACY_MASK <= (u64)UINT_MAX);
>>>>>>
>>>>>> Why not use the magic number 32 you are mentioning in the comment? :)
>>>>>
>>>>> Meh I mean UINT_MAX works as a good 'any bit' mask and this will work on
>>>>> both 32-bit and 64-bit systems.
>>>>>
>>>>>>
>>>>>> static_assert((u32)MMF_INIT_LEGACY_MASK != MMF_INIT_LEGACY_MASK);
>>>>>
>>>>> On 32-bit that'd not work would it?
>>>>
>>>> On 32bit, BIT(32) would exceed the shift width of unsigned long -> undefined
>>>> behavior.
>>>>
>>>> The compiler should naturally complain.
>>>
>>> Yeah, I don't love that sorry. Firstly it's a warning, so you may well miss it
>>> (I just tried),
>>
>> Upstream bots usually complain at you for warnings :P
> 
> Fine, but it's not a static assert and they can be delayed.
> 
>>
>>> and secondly you're making the static assert not have any
>>> meaning except that you expect to trigger a compiler warning, it's a bit
>>> bizarre.
>>
>> On 64 bit where BIT(32) *makes any sense* it triggers as expected, no?
> 
> It's not a static assert.
> 
>>
>>>
>>> My solution works (unless you can see a reason it shouldn't) and I don't find
>>> this approach any simpler.
>>
>> Please explain to me like I am a 5 yo how your approach works with BIT(32)
>> on 32bit when the behavior on 32bit is undefined. :P
> 
> OK right I see, in both cases BIT(32) is going to cause a warning on 32-bit.
> 
> I was wrong in thinking (u64)(1UL << 32) would get fixed up because of the
> outer cast I guess.
> 
> This was the mistake here, so fine, we could do it this way.
> 
> I guess I'll have to respin the series at this point.

Let me think again: assuming someone would mess up the BIT() thing and 
convert back to 1 << NR, your variant would catch it on 32bit I guess.

So given I was primarily confused by the "u64" when talking about 32it, 
no need for a full resend of this series just to clean this up.

-- 
Cheers

David / dhildenb


