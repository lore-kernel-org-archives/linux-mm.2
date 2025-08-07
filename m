Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75309C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184E28E0002; Thu,  7 Aug 2025 13:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12F308E0001; Thu,  7 Aug 2025 13:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38CC8E0002; Thu,  7 Aug 2025 13:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4B518E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:59:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D5151A0B29
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:59:50 +0000 (UTC)
X-FDA: 83750724540.03.184FA7E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id A34E6A0006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:59:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hQqaTAx0;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754589587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wk6a/pPPJhrMqThE6QoVfYpodt1UgZPfr4F28Ot7H28=;
	b=0w9xXYCDbiyrlAhAHkNbw1yDMUYIi9DQ+nHPPiOs0KUKJE+yn4eSGtuElMKcrg/Xn1iMfu
	TTwmQi5FS8ZfOzx5igPzKNzDtv2oN2owTibS+YdcxiJ6OEwkRn84oSBWfWx0eHf1UE91/k
	PpjvWy0/Gsy4ma2EtPGkTOESfurtQZQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hQqaTAx0;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754589587; a=rsa-sha256;
	cv=none;
	b=fsLcLjJEdsP0dU8go35pCxXZiUJxPu1kBkff/xjX/SI4lnAolf8aiEhkbyJRFYG/arAumy
	bbU01MXS7Yh6IGnIbwSwr/X93sKk9opL7ajASuLe0RcIDmZkWO/XnGIxPGmBuYRqkiT2Dc
	H68gpobBL4fMpZ3fYFKBftjCb624kgA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754589587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Wk6a/pPPJhrMqThE6QoVfYpodt1UgZPfr4F28Ot7H28=;
	b=hQqaTAx0NhWH0BjXDNaPeuvefE9lgMb5F0wo5YiRnJd6PrFZocivuYhD0NbU7yrtqM8eht
	bmyrBrC7MhJytti3djrFgDrV5SI/COdg6wZ8CB6+cIyvdtr/cRRsQShztF6Y1VaMvJ3t4g
	EjfTYCFA5yVlYF+7I36Z2ChGygtqPYo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-o0DiFVwrN8GwntQ8AJwx-g-1; Thu, 07 Aug 2025 13:59:43 -0400
X-MC-Unique: o0DiFVwrN8GwntQ8AJwx-g-1
X-Mimecast-MFC-AGG-ID: o0DiFVwrN8GwntQ8AJwx-g_1754589582
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459e0f54c88so6884485e9.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 10:59:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754589582; x=1755194382;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wk6a/pPPJhrMqThE6QoVfYpodt1UgZPfr4F28Ot7H28=;
        b=FuJP/2feBlKPbXngYZ3DXZWx/O2wiVQkAl+EM1de/AZhY9TPGYm+iDmxDeoDZAc0nl
         g7dWqHLXS/IkOuhTijUq21+sXj5zzWuV++KyM3t++bhJxNsUPe4r2b5SengQdBSOSduc
         2e4RdoY71hve0hmJUBmGEGbkl/+MkPNKIK2hVGZpaNyIgDZ3ZSGrgLPqOp65u1YW3JLk
         5sQZiNXzjxPNGcT7LeHJMVs7eBKYIlPRIezezSYB9lju7KJ+BOjatxpMO+klvV5C8j1s
         ElWoBND6cVJASxHGHNOhQyh0wwoDdQdhGsInx17vLKfL/cOaGaCS78A1qWZWbi2f9bWU
         MPAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnIlhOkEQ/hhSGPrVuhgAoAZdkkFVZ9MLHsXi5hyuG2Uvcb20KiKGpBWb0CW2Ewgu8DokYycXVyQ==@kvack.org
X-Gm-Message-State: AOJu0YwZKL9aOg4SdSuDjPJCYTXdxH24dnbUhYTTmTdK4k0p75cDnvxM
	dONXiMKTwOxRWGv58ZhAulgFUSIk01+2a13A4ZnLt2AokwxizVstPb5P6WWHbw3Xh6oEm3jthnd
	VcTpPTC6I1qsfm/TAu21hDEDyaRIP3MaKI5E4E/P+6ggWJxvhlDWq
X-Gm-Gg: ASbGncuNUacr5UnJwidZNsnkTs2wmio/4Bs9CYGFwSuN8tvkZ91KkaueaLEBF4LYhvC
	/qSjRT8+mAWhfbESYxXyjpOswK8/4EjIep9lScRxk/Lncwgc6XYkTEP3Z4dXuawvT+BH2nB9s6l
	zk0dw4tYYHf3AZz2SougtNhVnSEo337XBoR93GJWqRwiO9KeQRy3ytA/ASa3K0xrREAB78ZmneJ
	RfwK7h+kjV9tYCIS4Z6BAnH18a1F4UTXnvgH0TloCk3n2MZWGeSPFruEEmfNYmUI+u+u2dqTZhw
	rBhR/k+ouNr4tj7/k1jG/jRMSxpqfhViOaVDEV4IZlfmcP2mLISBKmQVkngnBzZLSRkyRZMyxLH
	rVBzvBoEFmYVLLCGKRgGiueAuOGHfq4zs/UIqI/ZReAhe12F+8zD+RznfhGV38b7LzMs=
X-Received: by 2002:a05:600c:64c3:b0:459:e39e:e5a5 with SMTP id 5b1f17b1804b1-459ede945a6mr45490615e9.5.1754589582465;
        Thu, 07 Aug 2025 10:59:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFn0NJBCGt4/Rk/NEdnJWnNlQiQuizOhALHDnhgSLWYNhieS2DmpQ+fxa0tiLbFyO8ObvlS7w==
X-Received: by 2002:a05:600c:64c3:b0:459:e39e:e5a5 with SMTP id 5b1f17b1804b1-459ede945a6mr45490405e9.5.1754589582034;
        Thu, 07 Aug 2025 10:59:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f49:bc00:12fa:1681:c754:1630? (p200300d82f49bc0012fa1681c7541630.dip0.t-ipconnect.de. [2003:d8:2f49:bc00:12fa:1681:c754:1630])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8e0b2d2fasm17231775f8f.50.2025.08.07.10.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 10:59:40 -0700 (PDT)
Message-ID: <8416922c-4198-45cf-b5c2-dc39587bbf68@redhat.com>
Date: Thu, 7 Aug 2025 19:59:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>
Cc: kernel test robot <oliver.sang@intel.com>, Dev Jain <dev.jain@arm.com>,
 oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Bang Li <libang.li@antgroup.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, bibo mao <maobibo@loongson.cn>,
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
 Lance Yang <ioworker0@gmail.com>, Liam Howlett <liam.howlett@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yang Shi <yang@os.amperecomputing.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
 <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 35vMfbeC4KTwTbhmOnNRtloVA92PafwMmxRAQZydD8c_1754589582
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ycok39y8ri9dzwq1uohyg9stygyj9cw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A34E6A0006
X-Rspam-User: 
X-HE-Tag: 1754589587-450571
X-HE-Meta: U2FsdGVkX18EXcWzpnXxw4LT7C58ab/SN4+6IhTOOVZalhDrIywH8pE58eSwi75bvR/kxcWhn9251SFVV6sAWbU2U5hV2bg7jgAADJAhpfTTTz6POodGZ4EsC0Zg1tbkcUedWG+1L76UZ0bi4i5qbF6S1rIgIMboaiBGot1ATmJ7TwpqgUsP8EFXG9C+wbIMI8LXKLVLnKAPlqKCdXOplq4TNAuozZAjG9/sngUKJ+XFdJaeWdwwDDB+BAv8E+J0/aSE85dwOuKHyS3Kbi02BIq7pnmhbPPasvntyULY05iZKkGy9gDKR9GTlS+h25gQ2wWvFfA80IeNBgxe0jFRWDWzlbTX8Lt2yNyBZdM6GMxaMEHemg7ggFh9/sAR5HdKHI6iDWDwR1HjzMo4t3j5uxs1vzMsaqufd868bIlU2TygBXHV0Sd1fgNwfR5NEoipso1XH/21wG0XYlGz1Wd+8jBeOYvTCkIPgcVjAEsWkQ7tFqV2V/oNaCsIrv4gWufpcA2zS4bTUlptqTiLavW33pHSY6LKpAOlWICHUBhUdPnOK1J/ialoJzFyuAxYBbtMi+jo9RKycZvw3XM5cPJxA8IWnLLRbvnZxrZcB1DoYtonERwN3dOVbVkJABcwVh5LUaAvZfu3pqUQCpKE865f9Ip5U8ZtFjJlp41UL5W8+ib7vC/EuqdXqKyXj4s9j62O5nAo2SNtgOC6+bm1/8Dd681TyHRrbImNAFsQM8yd5mK68b3Qb+yO9yuTGUaZD6GeqTSNV8OhJVZR621GJUdQtUPLFDcbfyQSsfbtud2MucbJJbUsxEVK9owyezR9+bsZGbfS6KhdygZl9rjmHvoWi1SIYl7PdeHl2nt/4IJ8PuzhtGx4pD04WYQOwPgoEyuI6POf8U7whgPCuTVZe0YqJcYP8vJB1wyTDTcoY8GUXiupNcYH/P7CBkGfBwfwPxXPIqv9EUWnRgswEffxNSG
 8F286NWf
 RqmpzEzeWkxrsxwA2up4tgH9AF4cKZoyi1URSX16oKlL+5GeGBJsfHB+gt2OPFoi5xoFHzwHqJ0ShwXx8tGMIAmeh4ZAtkWtlEdlSlRC0Lxl0BYOgnCSS3b6cSTbk4yjFWpgejfKUwyFaag8/XtwXjLS3qmGfq7sb5qULxH+YX0gZw3duDVxX+9wkEaTXaaAqphJpqTWpl7E3CWOw6DCobUrrNmH2WcPSxmlen+iRTaZnbm3OFRN1FUc3bIuqM790icWPTjQ+Fx/R0Ut/Fv2BI0vpYkPw7XpVT3qC6KluKB7SfN4A5bq8whQuToSs3JR+M+gnNBHSpy/JEGxX5SrX3jTFsuCljDcAEZQyEs+wM/vajgxmJAarEV5c/eajeBtrdXr+j2shSp29zQp46zDnm4Icj8fqGdf+BwTQirYeHz/XGPz540bar7cYylwYEpworJhiHZ3E0prGTPxIvmuvWVfM+kPklASn6Guq3munPjcrmb1FNiYe0CHJHmEEsPSVNLcZObiy/c1QxqfTkWLkbVQ7svgEbgqPzyHAOQBkCakhodv+GuO46LTAY7lm9xSxtm/a4shRnZk6OPQ+MgPHq24nosjhkXziW7UvznpVoHVgwRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 19:41, Lorenzo Stoakes wrote:
> On Thu, Aug 07, 2025 at 07:37:38PM +0200, Jann Horn wrote:
>> On Thu, Aug 7, 2025 at 10:28 AM Lorenzo Stoakes
>> <lorenzo.stoakes@oracle.com> wrote:
>>> On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
>>>> 94dab12d86cf77ff f822a9a81a31311d67f260aea96
>>>> ---------------- ---------------------------
>>>>           %stddev     %change         %stddev
>>>>               \          |                \
>>>>       13777 ą 37%     +45.0%      19979 ą 27%  numa-vmstat.node1.nr_slab_reclaimable
>>>>      367205            +2.3%     375703        vmstat.system.in
>>>>       55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.KReclaimable
>>>>       55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.SReclaimable
>>>>      559381           -37.3%     350757        stress-ng.bigheap.realloc_calls_per_sec
>>>>       11468            +1.2%      11603        stress-ng.time.system_time
>>>>      296.25            +4.5%     309.70        stress-ng.time.user_time
>>>>        0.81 ą187%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>        9.36 ą165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>        0.81 ą187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>        9.36 ą165%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>        5.50 ą 17%    +390.9%      27.00 ą 56%  perf-c2c.DRAM.local
>>>>      388.50 ą 10%    +114.7%     834.17 ą 33%  perf-c2c.DRAM.remote
>>>>        1214 ą 13%    +107.3%       2517 ą 31%  perf-c2c.HITM.local
>>>>      135.00 ą 19%    +130.9%     311.67 ą 32%  perf-c2c.HITM.remote
>>>>        1349 ą 13%    +109.6%       2829 ą 31%  perf-c2c.HITM.total
>>>
>>> Yeah this also looks pretty consistent too...
>>
>> FWIW, HITM hat different meanings depending on exactly which
>> microarchitecture that test happened on; the message says it is from
>> Sapphire Rapids, which is a successor of Ice Lake, so HITM is less
>> meaningful than if it came from a pre-IceLake system (see
>> https://lore.kernel.org/all/CAG48ez3RmV6SsVw9oyTXxQXHp3rqtKDk2qwJWo9TGvXCq7Xr-w@mail.gmail.com/).
>>
>> To me those numbers mainly look like you're accessing a lot more
>> cache-cold data. (On pre-IceLake they would indicate cacheline
>> bouncing, but I guess here they probably don't.) And that makes sense,
>> since before the patch, this path was just moving PTEs around without
>> looking at the associated pages/folios; basically more or less like a
>> memcpy() on x86-64. But after the patch, for every 8 bytes that you
>> copy, you have to load a cacheline from the vmemmap to get the page.
> 
> Yup this is representative of what my investigation is showing.
> 
> I've narrowed it down but want to wait to report until I'm sure...
> 
> But yeah we're doing a _lot_ more work.
> 
> I'm leaning towards disabling except for arm64 atm tbh, seems mremap is
> especially sensitive to this (I found issues with this with my abortive mremap
> anon merging stuff too, but really expected it there...)
> 
> On assumption arm64 is _definitely_ faster. I wonder if older arm64 arches might
> suffer?

Are we sure it's not also slower on arm64 with small folios? I would be 
surprised if it isn't.

-- 
Cheers,

David / dhildenb


