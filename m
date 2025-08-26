Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C701CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6126D6B00BF; Tue, 26 Aug 2025 10:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2CB6B00C0; Tue, 26 Aug 2025 10:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463CE6B00C1; Tue, 26 Aug 2025 10:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 309666B00BF
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:28:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC8E6551FE
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:28:29 +0000 (UTC)
X-FDA: 83819139138.27.115DB86
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3E4391C0012
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:28:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GI0tZpzw;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756218507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDLf7UHqP/kD/etWBqZtQZ0xB9/zj9AoNH0XrSAyLV0=;
	b=hG9yyigdWIFXuPl9UG8WUvcBdiiacF5wfHW9dAYzxrdlRtBTWOTlEwdM/aw/Aq+aI/domr
	Xac71n0ROUZ1f2FYJqlW4nj+NKP6oGkNfFyENxZsJULpJXQhFjQLbukSWJQHQXmQmosqTb
	Kf9lfQ9MKh5dxBlYXPHv42GlmKj3iR0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GI0tZpzw;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756218507; a=rsa-sha256;
	cv=none;
	b=A4AJ0bFkxMvuhBk/tfhi0rTiD0PH+Ftk9OU89kF9kUVVvVpovbI5Cu4wj8O2XUnrZJMe84
	6CMTHcuhEixOoTlJ+nndQVCUBI6sB2tlUPKy8MRS3uctMW/vdUn7QCTgin28kkObzAgRJW
	cguKlA1fGmray/VWx/1WHWPuBFJXV/o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756218506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qDLf7UHqP/kD/etWBqZtQZ0xB9/zj9AoNH0XrSAyLV0=;
	b=GI0tZpzwJ5DXViD5l+H4iX3lmJ9o+NoMFrRf1Pg3+1JwgoU8KCcr+vYehGaR9bUlmfDvjB
	Ekcar9RUgy+8bVvCaWV54dKLRyHflkM+bBWoV+fobwWzSQkwVBQjePPhLJoU4GPc9yPw62
	KDF73xmZOj/zc6/GBcAHrfwdWTMb8fE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-4tAy-QkJPCiQD21KJtHBcg-1; Tue, 26 Aug 2025 10:28:25 -0400
X-MC-Unique: 4tAy-QkJPCiQD21KJtHBcg-1
X-Mimecast-MFC-AGG-ID: 4tAy-QkJPCiQD21KJtHBcg_1756218504
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b627887c0so7159345e9.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:28:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756218504; x=1756823304;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qDLf7UHqP/kD/etWBqZtQZ0xB9/zj9AoNH0XrSAyLV0=;
        b=wpcoqcSMYkOZT7qewnzGM5cgvq08iQsb+jDtql6mFcf5mJi4wELGeQIagwGW3yZw6N
         5rXchQAPnar15RSSbGKXox50jCTl0vGIo2CKkYci/Xs2PL4XKz6BD9NoA/nP4xo+4/xw
         s+4+4fGBTUwJ2on01pixGDh9wMcEeva7jpkL78LeUHde9KuWZtCcUJm7LNAHIBr+Eb6v
         prT0oNX5cpSvQxogZb2edZcQ9m4bRefjdrGz+YasNbQNBhUVsSFj2hKjWfznUsoVWkPN
         b+8aba5zMrS+zWSWt1lBDdfQvV3e3GGRS1Z1ozHbMujrPhOZoCVMGuNnDNGi2gmBDZ3v
         pMcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrBc17oJaIBlzGWWNqSmPN9Xf+p2s//Z3q12hzXJhvHlSbKJGNIXHoFa8lno0Lzf6md1DMrCccSw==@kvack.org
X-Gm-Message-State: AOJu0YwWmTU6s/uTYTVTOOLOXpXNeqgRve6DLeWsqkn43snOQxR1gqkR
	4PLKZUpLTdmRbAElyfjc7ebValuMdeUVX9UwjgU4iRA6QLDQAQVOpaqYN+Dhca8O/oivMsvvvG6
	sMOHe0OSErdnoKXutWLnzxyCAQYAW5Bab/NTpy7MUlnMHSkvJmFB0
X-Gm-Gg: ASbGnct7f4ib/44kLt5F8EKfClUNL1VaxNmay72E4VpCyzouPnuPT/RjEKIwbqpRoXN
	WsMBZkWI6vmH7B9DaH1g6d/XEM3v/Iq4K9upi+jwittT6N8je5fExsGy7T7OoLio20cL2noTVXl
	2w31WX00vwMrZztDudEuP0TThppaF5g7SL0/BJd7ntYoY/jo7Vn47oJXM5oL7z84MBzC3gSHA94
	89SklHYWC2k2lnu+vfi13OzbnWSBsbxpvADM/nQbvJBCbcn7WKC4LK0EOATo1UFV9oMDEVU2IQs
	8WJkVmTkIuPOGybeDXcj8XjdO23TZyjByb4eoxNE10saL6Q87JG0pYgLZo9/Fc72SY13x1n+NQ=
	=
X-Received: by 2002:a05:6000:200b:b0:3b9:1444:98b9 with SMTP id ffacd0b85a97d-3c5daefe1a2mr13028599f8f.20.1756218503616;
        Tue, 26 Aug 2025 07:28:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEesMYr8JzIEF1vgTN54nHPI7cUfVq8ZiROeIcQJ5cCobuevpeofHXLkn08AMqOsb8e/8JJcQ==
X-Received: by 2002:a05:6000:200b:b0:3b9:1444:98b9 with SMTP id ffacd0b85a97d-3c5daefe1a2mr13028514f8f.20.1756218502957;
        Tue, 26 Aug 2025 07:28:22 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c711211cdesm16359467f8f.37.2025.08.26.07.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 07:28:22 -0700 (PDT)
Message-ID: <d39e029a-8c12-42fb-8046-8e4a568134dc@redhat.com>
Date: Tue, 26 Aug 2025 16:28:20 +0200
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d4f8346d-42eb-48db-962d-6bc0fc348510@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 89Mte-UFyt29R7Iq17yYMryPzGHTeOQ8EEzFcYYVY1k_1756218504
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iam4oyzbmwr7sxfx3wm95zjgos8puzio
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E4391C0012
X-Rspamd-Server: rspam01
X-HE-Tag: 1756218507-437144
X-HE-Meta: U2FsdGVkX1+M+A00tU/15xIMsZC1IUMNTfaJnrCdViQOqlaRo1/61pi34IFduAS0pS6zX50Rya20HhE5JP03mrgItbaO38k20xp6v9FvH6G2EX/D6290JPD3v97Ekp/ji6y3zu0WabHlWToLRt/Q3EHH2jXKHomOuILMw2G7d45Si5z7BrvXV3JYPWlXKjvkKbL4EiRWt0yjgUKK8Wf6ci4vy1kyuXoh/iTZrMlPWYjVaecQFMDkLX8VuxwLllUllbksvTMKzQjP9naI/82mObq+T87hBMLaIDKGEoQv9PwsQqj8ExGse3pgo6DDxIt//9FpmtfbkLWt3khpwazEkLB8gEMfi537mhIDrlj2e2CDq9q4WpLlTS1sbOv4JTlK04V2/0irCDf30x/BmvW/l9NHvxEHotzkHzfxtInYOI88GZ1dXpq04KqFcghNMKuc0TcMeB/qZY8lct01INLwoPQUcpGgYlKGrBXyYpVxUJnrYjJLEk5KOkcl/34iF+LHUhJp8wbjl4MFCRNs+8T34WrgU8LWvxpnSgX9L8mY/JPhWN1HQXoFaI1A773wkQ/SRCwlvIyXb92Ymr64xhHYmD9SuR0N8Fn0CcLXIJcPQeCBLcIrEikkSHtcAAUMZ9WJvN051WEshaascaB8MEFycXNuKh77o7YWt5PSrxSR/ZSW8S8RezcGBnPOmyA2V4Vhuu01r4ZqQzdM0sngbEaWYaKBNAWW6Y6vFtdXJt3CfZBHco8O0jCh6WtuEttO8kUkqetAKq1x2xCdajdurNvBVnfeoWh6X0Mlsher2gG/8e0PnVNTinWmO7XkNOHYvrpiP4pxNCRN1SYx6jRhjYYNehm6i2ShseEnt8hf/I4rFSJP/xlj0VLZ4Q/5YXcU3EB7LEjeKRmiOy81D1lfdSwJNFrWf4hD4o0d3R7DiUksCmZilGpvcVWl86u30NxrBAEo/ONWlk8QnB9xb4QPL24
 BVmgPzD+
 dv0OiKC1RFMdiajfbS83xlnUJdx1sJYZBpW6SHeBB81u9x1WQg++RFiEqKRLkuIjB7y5NZTnxuV7ebnZ/AP1SfPzBbOqLnPxoBtZawETVGR1WTh/PB2X+YFgILHfkMymAd2E7uu1amac87b6epExkO1SawhObBZ7SjdYsYSrl/mw/MpQwz9ikrLEiu6VIgudGdp2Mf/hbYSL9SpvVuxHt0zYQqjfGkd6kVquUnEWlpjixIOIab5OUN5q7yWvnLPPYJLx9tpS071ljQT28/5m7OqlPif+rj2AZBun1/Q5kDGTRzY8dHJ0IKmoALCxuzt0vqh71LQwHdqIY+D6iqNOWziBbBAlT8frhWr0zWLKkc84NLpfeWbCGmLgXj/7JaXsGCLabBpDDseYxEGPpS40yPHwls526ldeGyTsyHcMl8BHmSTaqOQj97wXjHsODGiSxXIVkVuz+qUGvi/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 16:21, Lorenzo Stoakes wrote:
> On Tue, Aug 26, 2025 at 03:12:08PM +0200, David Hildenbrand wrote:
>> On 12.08.25 17:44, Lorenzo Stoakes wrote:
>>> We now need to account for flag initialisation on fork. We retain the
>>> existing logic as much as we can, but dub the existing flag mask legacy.
>>>
>>> These flags are therefore required to fit in the first 32-bits of the flags
>>> field.
>>>
>>> However, further flag propagation upon fork can be implemented in mm_init()
>>> on a per-flag basis.
>>>
>>> We ensure we clear the entire bitmap prior to setting it, and use
>>> __mm_flags_get_word() and __mm_flags_set_word() to manipulate these legacy
>>> fields efficiently.
>>>
>>> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> ---
>>>    include/linux/mm_types.h | 13 ++++++++++---
>>>    kernel/fork.c            |  7 +++++--
>>>    2 files changed, 15 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>>> index 38b3fa927997..25577ab39094 100644
>>> --- a/include/linux/mm_types.h
>>> +++ b/include/linux/mm_types.h
>>> @@ -1820,16 +1820,23 @@ enum {
>>>    #define MMF_TOPDOWN		31	/* mm searches top down by default */
>>>    #define MMF_TOPDOWN_MASK	_BITUL(MMF_TOPDOWN)
>>> -#define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
>>> +#define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
>>>    				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
>>>    				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
>>> -static inline unsigned long mmf_init_flags(unsigned long flags)
>>> +/* Legacy flags must fit within 32 bits. */
>>> +static_assert((u64)MMF_INIT_LEGACY_MASK <= (u64)UINT_MAX);
>>
>> Why not use the magic number 32 you are mentioning in the comment? :)
> 
> Meh I mean UINT_MAX works as a good 'any bit' mask and this will work on
> both 32-bit and 64-bit systems.
> 
>>
>> static_assert((u32)MMF_INIT_LEGACY_MASK != MMF_INIT_LEGACY_MASK);
> 
> On 32-bit that'd not work would it?

On 32bit, BIT(32) would exceed the shift width of unsigned long -> 
undefined behavior.

The compiler should naturally complain.

-- 
Cheers

David / dhildenb


