Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A27CCD185
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 00:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D0F8E0027; Wed, 15 Oct 2025 20:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974FB8E000C; Wed, 15 Oct 2025 20:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1B78E0027; Wed, 15 Oct 2025 20:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD758E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:21:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D32261D9BA5
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:21:53 +0000 (UTC)
X-FDA: 84002074506.05.C1E3A2B
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id D84FF40005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:21:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WDVw1Psw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760574111; a=rsa-sha256;
	cv=none;
	b=OWOf5I2LozNlmVvkJ7ORCEm4qWeHfG7j6EU6rnGM2AJow3GTS3SiKwaL0q9Qxd4IgTlhtV
	nVSgkRy1afhiZUmzxMaugEH+f5Oqr7hM3O7sY5NYvynzHEFBZbjvYuFjdz2jGWZwtJtQlt
	MP3ENUuhmQo3WlJ6zhfkoxlRMDNvYKQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WDVw1Psw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760574111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+uYbmyg7U3B88BGBaRnrEy2BORWFbRru8RT/OdSqk4=;
	b=tGSSmtFodqcs1gQ8vF9dxHB2i/UKf+Rra2GCkTdef5fzIAPRJnKgc5V4GWOYKVmHqxEce+
	9sGR6HvRnkvs0uFF4xH5Nk6Wz1Yy9MMPAPfLHj5RXkL95R90vcZZ1eTU16qPPF45chQ85p
	y9VoQzSvn+SxRbOX/TNg9sZFZ/QsUYU=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-78af743c232so178731b3a.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760574111; x=1761178911; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q+uYbmyg7U3B88BGBaRnrEy2BORWFbRru8RT/OdSqk4=;
        b=WDVw1PswuvCmcCT5OcK0ssBPJ2LdiJ4GLfA1kqaKfczBLLZ6/LPCc3IomHhks6/eqy
         dMKswC8KjmxctrUFrW+0xEsVYS2+y3TDQuQdlJgj7QpgmAZoufIdvDcZtZzXTW9Qqz+T
         LmmVE7SLlp/hLIwxAwZavnANCyXcmn47KIM7klF3HgO0AVRyWcEFgl6aviCX9s6xm1YR
         wohCykQeWVbyYcDKFa66zGaeKP27PeHSTKPIBy1rRR1icr+rrs3rIDsbsKOKDdGlMJQ/
         M+B2bIHsSlHKqaQ79iRmckEUdV4UKcNDIXgcPbGdwv/A6yhWNLBXj3a3gh7rIViGwZf8
         GjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760574111; x=1761178911;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+uYbmyg7U3B88BGBaRnrEy2BORWFbRru8RT/OdSqk4=;
        b=FvocyrJymo+1llLNbVWZSFnHiV3eXv0czI3kfk1biyLLK73Y9C+97Q68KDyrgofkce
         +9EN0skU+Ibgkge1c3lZCUmv2mHEQDb+0DiBGxO0k/vJpjnPjLFtaBPKX3jqU0HzHYv3
         6WpMWcgxakXc2SsLH521Jo8DdGjieyVKoTsOHDdTkNQMdlcy9TwIZGesincZ23JczjYo
         GASg8dmldPs54eNTCCC12fHAz8wJCYtRTQr5pS3GcJz519sHJ/vJhg0BNwpMVbUd+MJS
         RGyiAjoySZJNSOUOMFDkj2s2V1GL1/FuToIQw3OFwkWAiLmj0aQCxYS/EugFbNvIhIDq
         RaJw==
X-Forwarded-Encrypted: i=1; AJvYcCW+dnKlCvqO/Kk2qHlAKRovQ8iocMK+SG3xxLJUihr53ptKXdmDvPK8SB/ah/Y6ovYM3Q5/XM3MMQ==@kvack.org
X-Gm-Message-State: AOJu0YwZO6G06F/9/HT0l4VcFZKjPSnWUJpiRkek5oVVQHaH8aOmXPtG
	ERMZU5JLrld+0gqZ3islGWZiPpRNXuqdad1jLVwVkOE+hjJ7hhc/L+l1
X-Gm-Gg: ASbGncuejZkPovnMdplx07KOjqdTTD+JrOjGiewjH08fPTHwHWgoVizk856gpFT3hIv
	3gXXr61wsxl5Y9R88dxpDdBp9lw8poBXXM/O+SvQq4qvP3a2383jEjkiokCT+HR0WfSAigyq2oF
	Q7gkc6zYKmTmjPVBzdD0lIPEwl/U4f7g0nFNQOSWdGb+uwQ/aActaVHqYO7zdhGMJ+hgaJQXLwP
	WG+hd3QSYFl4bvb+DygPZ7LWRLKEizQ00v+Bv3OhaX0plaBPp0MW0F1lW/J1xcnewTtLxsIg8Vw
	krobRDG7nnt7gcT38nlKpyujxLhq6fPruc8p1B7GC5C3OzuQsiYTJlazkVxtPnLMfEEugOCcnwM
	6kDeBcsR3sn3XK8fWN49BGZhQYcgZxxyMX8chgu2wPxUkvCexERNS+mkt1WrUfShrrQm1DawwMg
	PqXd3P1OYxM2Y7+vznyCbO+MRXF7T7jz4k
X-Google-Smtp-Source: AGHT+IFJoepWNlU4+NBSNDZxjoH+m9KoM5DtxMqbC0OMbJN+YNUJKDrPJWuArAGQancBO2mZtAQxFg==
X-Received: by 2002:a05:6a00:4b01:b0:77f:1550:f3c9 with SMTP id d2e1a72fcca58-793859f34b3mr38869276b3a.12.1760574110523;
        Wed, 15 Oct 2025 17:21:50 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1151:15:b813:d910:1b7:5928? ([2620:10d:c090:500::4:c263])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d0966d7sm20056806b3a.40.2025.10.15.17.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 17:21:49 -0700 (PDT)
Message-ID: <e102f50a-efa5-49b9-927a-506b7353bac0@gmail.com>
Date: Wed, 15 Oct 2025 17:21:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] memcg: reading memcg stats more efficiently
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: andrii@kernel.org, ast@kernel.org, mkoutny@suse.com,
 yosryahmed@google.com, hannes@cmpxchg.org, tj@kernel.org,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 kernel-team@meta.com, mhocko@kernel.org, roman.gushchin@linux.dev,
 muchun.song@linux.dev
References: <20251015190813.80163-1-inwardvessel@gmail.com>
 <uxpsukgoj5y4ex2sj57ujxxcnu7siez2hslf7ftoy6liifv6v5@jzehpby6h2ps>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <uxpsukgoj5y4ex2sj57ujxxcnu7siez2hslf7ftoy6liifv6v5@jzehpby6h2ps>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4snmwp36t6xib1cciac4xodkouxguaue
X-Rspamd-Queue-Id: D84FF40005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760574111-426031
X-HE-Meta: U2FsdGVkX1+IKJ1qhV1NxwGZ9L1krYV/Es0xQGiGCq8WC9qlnkGHb8WY+zwBu9Kw49qVoL3PUv5/jk+8lap4H7MdYOgrs/jS0VtrCCdrO0YcW9qtTvH8Bi9sJWWrYazNEOrap+9ijsXozgA4n1bpD3UGZM70pyDNuNYTcZLGh6NZ9CKJqJCx1UYGb6W+1H657H5lNJ0Zd2nWr+eMY2rwPb+KDhTGkNgVHMJ83+595VkYp+oPIJA3aF2jZ25H+4SZnhvKYVAmYVqwzEMlMrzC9umNm1+3b7QlZHR9fw5mY6o4IVK+0MLmIL1kZLyr+2JPhBp6R24m3KNppIbGX3v6MXkt/OvIaBcRtCdsUU25jV+s3CiZSXzLJgdeBq5y8c4CwlyNXCUu0FeorQyHVHr2wmT0hPizSiCqRRg+ksimYwP57/dQ8yi4gZuCjfR5hrcXYZmOk2+iO10zMKbzuBN9ivCO26TiEzCTfICnrSvegVapaeR0oUtuMErmQD13zgtLNgherHF7nPjNCarH24D8IbxUP+W08CWTTmQ9ELWDTVVbxXGTo5gn/rqx16LZAoy670efobHhwHMy1Bog9DOys6nnc+2MLrEc+6tEvvt6B5MA4v9kMxg4MkDWbPY5h1dR67py/KZVyMbfYf3kIM97b4axb5Tz8xz0R93wDm+4UX2XN2L+4eJ+mXREbcTSPcRqevzWQnrHYagspKbrLnEpGBbMA+meB1EROgwLqKzMagVSPSH4ZSjDBQPaN7XbYz55yqblxdpJ3wGW8ins2vYhu/XLl0Y1jvghfh+P8gnD7dat4Vr6zXSkNbNftYjYoVVxyGNuOe0xKm27FCEHhdUKL/mJ8qQDZeGJwm1EmF3Ihz70l+LYQksp2jAmudISKgL11cIeo7GJ+PLbHLReBudwxWppAzrVXbh89I/7nYYRH0iZgxDPTG5XNMm4gDE/LzeOFiCO5copkYy9VVGo0Mw
 /1OSvGPI
 AdePMs85518pxzTgcXU5gNeGXSVTZCe9DOMKzRjS4/ew4uvvq+guN6nw/sCSpCEGEeAgs01DwBJnIw5W0tXUYpL+8M7OUEwszhf+eRCn3b0mDCF7dX9BMEaYY918ZrokIT74S0ETFZumFL6DU4R0TCx3wL0qdlEnUlAESisc6e2U8t76Qrnf6/olTUQWznBvbM/nv8Fm+tqwYyzzotVcEaEX4+6FB9/zvzpTtScleXoegqCTDpPqunBIsIGKYBFwjdcb2lTqpmLdpQEA7Ab5kwM6bmH9WfvDtuvVByYfAZI4ae8cxL/go699FThOI1r/+D36ZmEF7MBwKC1HQ6pWVjMC+hdzIFgiL2Ddy9U0FGqu8S+o85oU6tYi83TQyrNqtJZ7NkiFIsPcijSEtIWeLkU2z/3WYIfYl3B5NFobSJlXwjYtV5tZE3GUE6FXdTub2nGOkb0Q19n7ppIPI1g9wTS9vnyTF45pk/gpoQwsfI7aN7dRfpqaLiIAy8knmiB8HA6tZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/25 1:46 PM, Shakeel Butt wrote:
> Cc memcg maintainers.
> 
> On Wed, Oct 15, 2025 at 12:08:11PM -0700, JP Kobryn wrote:
>> When reading cgroup memory.stat files there is significant kernel overhead
>> in the formatting and encoding of numeric data into a string buffer. Beyond
>> that, the given user mode program must decode this data and possibly
>> perform filtering to obtain the desired stats. This process can be
>> expensive for programs that periodically sample this data over a large
>> enough fleet.
>>
>> As an alternative to reading memory.stat, introduce new kfuncs that allow
>> fetching specific memcg stats from within cgroup iterator based bpf
>> programs. This approach allows for numeric values to be transferred
>> directly from the kernel to user mode via the mapped memory of the bpf
>> program's elf data section. Reading stats this way effectively eliminates
>> the numeric conversion work needed to be performed in both kernel and user
>> mode. It also eliminates the need for filtering in a user mode program.
>> i.e. where reading memory.stat returns all stats, this new approach allows
>> returning only select stats.
>>
>> An experiment was setup to compare the performance of a program using these
>> new kfuncs vs a program that uses the traditional method of reading
>> memory.stat. On the experimental side, a libbpf based program was written
>> which sets up a link to the bpf program once in advance and then reuses
>> this link to create and read from a bpf iterator program for 1M iterations.
> 
> I am getting a bit confused on the terminology. You mentioned libbpf
> program, bpf program, link. Can you describe each of them? Think of
> explaining this to someone with no bpf background.
> 
> (BTW Yonghong already explained to me these details but I wanted the
> commit message to be self explanatory).

No problem. I'll try to expand on those terms in v3.

> 
>> Meanwhile on the control side, a program was written to open the root
>> memory.stat file
> 
> How much activity was on the system? I imagine none because I don't see
> flushing in the perf profile. This experiment focuses on the
> non-flushing part of the memcg stats which is fine.

Right, at the time there was no custom workload running alongside the
tests.

> 
>> and repeatedly read 1M times from the associated file
>> descriptor (while seeking back to zero before each subsequent read). Note
>> that the program does not bother to decode or filter any data in user mode.
>> The reason for this is because the experimental program completely removes
>> the need for this work.
> 
> Hmm in your experiment is the control program doing the decode and/or
> filter or no? The last sentence in above para is confusing. Yes, the
> experiment program does not need to do the parsing or decoding in
> userspace but the control program needs to do that. If your control
> program is not doing it then you are under-selling your work.

The control does not perform decoding. But it's a good point. Let me add
decoding to the control side in v3.

> 
>>
>> The results showed a significant perf benefit on the experimental side,
>> outperforming the control side by a margin of 80% elapsed time in kernel
>> mode. The kernel overhead of numeric conversion on the control side is
>> eliminated on the experimental side since the values are read directly
>> through mapped memory of the bpf program. The experiment data is shown
>> here:
>>
>> control: elapsed time
>> real    0m13.062s
>> user    0m0.147s
>> sys     0m12.876s
>>
>> experiment: elapsed time
>> real    0m2.717s
>> user    0m0.175s
>> sys     0m2.451s
> 
> These numbers are really awesome.

:)

> 
>>
>> control: perf data
>> 22.23% a.out [kernel.kallsyms] [k] vsnprintf
>> 18.83% a.out [kernel.kallsyms] [k] format_decode
>> 12.05% a.out [kernel.kallsyms] [k] string
>> 11.56% a.out [kernel.kallsyms] [k] number
>>   7.71% a.out [kernel.kallsyms] [k] strlen
>>   4.80% a.out [kernel.kallsyms] [k] memcpy_orig
>>   4.67% a.out [kernel.kallsyms] [k] memory_stat_format
>>   4.63% a.out [kernel.kallsyms] [k] seq_buf_printf
>>   2.22% a.out [kernel.kallsyms] [k] widen_string
>>   1.65% a.out [kernel.kallsyms] [k] put_dec_trunc8
>>   0.95% a.out [kernel.kallsyms] [k] put_dec_full8
>>   0.69% a.out [kernel.kallsyms] [k] put_dec
>>   0.69% a.out [kernel.kallsyms] [k] memcpy
>>
>> experiment: perf data
>> 10.04% memcgstat bpf_prog_.._query [k] bpf_prog_527781c811d5b45c_query
>>   7.85% memcgstat [kernel.kallsyms] [k] memcg_node_stat_fetch
>>   4.03% memcgstat [kernel.kallsyms] [k] __memcg_slab_post_alloc_hook
>>   3.47% memcgstat [kernel.kallsyms] [k] _raw_spin_lock
>>   2.58% memcgstat [kernel.kallsyms] [k] memcg_vm_event_fetch
>>   2.58% memcgstat [kernel.kallsyms] [k] entry_SYSRETQ_unsafe_stack
>>   2.32% memcgstat [kernel.kallsyms] [k] kmem_cache_free
>>   2.19% memcgstat [kernel.kallsyms] [k] __memcg_slab_free_hook
>>   2.13% memcgstat [kernel.kallsyms] [k] mutex_lock
>>   2.12% memcgstat [kernel.kallsyms] [k] get_page_from_freelist
>>
>> Aside from the perf gain, the kfunc/bpf approach provides flexibility in
>> how memcg data can be delivered to a user mode program. As seen in the
>> second patch which contains the selftests, it is possible to use a struct
>> with select memory stat fields. But it is completely up to the programmer
>> on how to lay out the data.
> 
> I remember you plan to convert couple of open source program to use this
> new feature. I think below [1] and oomd [2]. Adding that information
> would further make your case strong. cAdvisor[3] is another open source
> tool which can take benefit from this work.

That is accurate, thanks. Will include in v3.

> 
> [1] https://github.com/facebookincubator/below
> [2] https://github.com/facebookincubator/oomd
> [3] https://github.com/google/cadvisor
> 


