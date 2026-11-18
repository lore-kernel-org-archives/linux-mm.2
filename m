Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3BF606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SS02ieOm
Received: by kanga.kvack.org (Postfix)
	id 45CD36B05B0; Wed, 18 Nov 2026 10:04:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434FB6B05B6; Wed, 18 Nov 2026 10:04:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371416B05B8; Wed, 18 Nov 2026 10:04:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0CA6B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:04:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D6B71607D2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:04:10 +0000 (UTC)
X-FDA: 85448560260.18.351D74A
Received: from mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 09B0D140004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:04:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SS02ieOm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795014248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yfwtmuh15e5L/fsscSO213kl0aITGy03gz7OI2vHFYU=;
	b=KtfbwIyqLYgz/elfNiJ4U5dtUws0V/+aVk61zrJwveM2Cj3lrd9AO77xD+wNQr4bC7dxDo
	uP7USQeVNpOyvtI6k9OGj8UL7ZKR+dV7c6LF5go3vPl8suyfiQhiHVXKdrP0PMNGJbYPwv
	gkot6or/TLTpkgFI1IwD1BW1VYZi8oE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SS02ieOm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795014248;
	b=P1MRswzu8rhWjYkyrkq9BJOzz+TV98uSRjvDJsdZEKyNwd4INws5Q/AknBkyU63jfZexBl
	bWuCoCdMWZU3gvSdZ3ndmPbxlBa6yEmuG14vRe6LU/iga/A8HJ3KwfEvquEEenXgamVjBe
	4zLxn3tvk/A29vFnrSvUZv8X89bNrIs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XhbjaJ8im/VrH8GwiaavZ+shVr7GKVnu9JIrbTmImk8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795014245; v=1; x=1795619045;
 b=SS02ieOm8mSQdZMt8RfMzTwzPVp4tvbhfgGwPXrJkqiJLrnambkdgGaltn1zYpC2oDaZuE/l
 GMt19qiaiHln5apXEU+n4D8pM2WJ4HGSIDcs056wKodAg1ETMuJMGxhF1BEKXWA+iQFh760zj8i
 uobwQdeyeNh1lcdGLMnGu5g4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bb9e3daad670b11f;
	Wed, 18 Nov 2026 15:04:05 +0000
X-Mizu-Trace-ID: bb9e3daad670b11f
X-Migadu-Flow: FLOW_OUT
Message-ID: <45cca73c-9846-42a8-a505-65b90a7cd3c0@linux.dev>
Date: Wed, 18 Nov 2026 23:03:48 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm/page_ext: fix client data alignment
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 sashiko-reviews@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>,
 Muchun Song <songmuchun@bytedance.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Chris Down <chris@chrisdown.name>,
 David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Lu Baolu <baolu.lu@linux.intel.com>,
 Pranjal Shrivastava <praan@google.com>,
 Ketan <ketan.kishore@oss.qualcomm.com>, Mostafa Saleh <smostafa@google.com>,
 Sang-Heon Jeon <ekffu200098@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-3-songmuchun@bytedance.com>
 <sashiko-outbox-219498@kernel.org>
 <20261117114635.37d4c1f7f1b38cc4ce7fb886@linux-foundation.org>
 <F4EDF1D2-D02C-4339-AA30-422D576B735A@linux.dev>
 <20261117202136.9eb67013389f3bdefe9b3a15@linux-foundation.org>
 <11DE08A1-5F83-4BE2-B8C0-B426441A957A@linux.dev>
 <av2q4RAESvKh0chV@kernel.org>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <av2q4RAESvKh0chV@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 09B0D140004
X-Stat-Signature: mua1myhtrwzqp8k7y6p5m8znghgutjid
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795014247-679044
X-HE-Meta: U2FsdGVkX18gz1GLcE+D3zRfOmWHvbQGzOuPFudLgqnpdu8cBQuXdkhTECPooGi6VXZxceSRuuLf8bDBgVrEtNjGIQm/kcFKaRD6iLjyWgw367jldpa+KPcW3k1mYmma+BDW0Bu47ifr10AZcAHkU9bEKvxiTuzo1SApWdZynkSiMpmThRwR0Ljh6A0340YW8swtZRLYxjvT6N0rML9u6lmCa8Zw2gcjtVal4UGTgCv9YxHCy5cP6q+AZDXSKYUyCd91DfkPO+iMw15LFmZbzBad52/SZfLjppP0NsQ7ROtmDC4hKhB8QrRfKeTUPpjcMspDhianOy3OwZZCjXQmXglH/jc73R+hPbqq/dklgkbM1lPKnHRFo5fc7WWXRBN8wS4P/p0z8miZP3qMYnvks3lPEQPbxyxgtGMDAERSctHVRP4+0c+zUhhmRT+cRpY71QnW+7rcxdgj84lCmNDRfu9TNM+ur9J1OXvKQgTq1EXgnCPI6+djlVYySem1L2uy5/OpLzuMrU34amICuFVv3LmGT9Xb/WDMS8YJi7tp7KgsOCags4TGvu6Vp/zV8ADhyBPlBgwHPckvpK6l1F2FxTaUG+Toa0pgQzvSH+mYWRRSksWGY+ootyv2Ap+UHTQzmvyL5s8FN50TG2BMtc/9d3Sl6OhD/D3Iwph378IjsdKuIiefeTPXMhpTLg1edAf2lzeNSpyZpl87jQXKSZxr6U0H+MmrGU+yfdAWy2jbyZmJJYTlh647ngZMUfEyB5legRQuf5lv6nbheCAWrFa26bLjQFjjdlJAPhEtzWS1Fdfw2ulOhTA40867zOGVlBYj17owPLDsviale+AXvAH25VB8re1esVfp/YJrdlTsG0BBh213nYNI1rC1eEVLGo36CN/u/dtiOLsefkGr4MU2ck4y4IdG0++dsvqeGvJ+DliXe1i/JEnmwmCf1sZpFF9Ph4pjlD6bkxToitsho8g
 +JrVv3aF
 OhiS0fIdIHkDUaO8NV2O13eP/X1TjClzsQfhMGxfk5Ry3iZ8QeIOE3LwyaUczOUoRQn48KtYmVKbXMzDXgJsTSUCv24iaW6YAOYQ6/0ZT3C/6mdY2/1RmTWiHJkZY6s+EQ11TN+HusxY1AbfXZZjkdv9FXc57gjKX7EeqF7yuAvUX25JcYb2Zvu/VkPHiXQ19Svp72NScB21M2VKp85W9K8Q/GOMypMBCdzbCwLJZvcCQCxwyKqDf19PoJsNrJoqxHGnqCxU+TZioB7veZGDpXOuKSINmcTJZHH0Gax+ThlntMfUsMlDOmr9YPN8jxpHB8eVvT9wd2B54R9dTswGXGyQdTdDwsETqyhrwwx84tOoHcPU4RO8vrdj6O8Zyj2IirCok
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/18 21:40, Mike Rapoport wrote:
> On Wed, Nov 18, 2026 at 01:39:04PM +0800, Muchun Song wrote:
>>
>>> On Nov 18, 2026, at 12:21, Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>> On Wed, 18 Nov 2026 11:49:58 +0800 Muchun Song <muchun.song@linux.dev> wrote:
>>>
>>>>
>>>>>>> +}
>>>>>> [blah blah]
>>>>>>
>>>>> Yeah, but the whole expression is quite reader-hostile, as min/max
>>>>> things often are.
>>>>>
>>>>> How about doing
>>>>>
>>>>> /* comment */
>>>>> if (this1)
>>>>> return that1;
>>>>> /* comment */
>>>>> if (this2)
>>>>> return that2;
>>>>> /* comment */
>>>>> if (this3)
>>>>> return that3;
>>>>>
>>>>> ?
>>>>>
>>>>> The code generation will probably be just as good and it's __init-time
>>>>> stuff anyway.
>>>> Something like?
>>>>
>>>> static inline size_t page_ext_data_alignment(size_t size)
>>>> {
>>>>         /* No client data means no alignment requirement. */
>>>>         if (!size)
>>>>                 return 1;
>>>>
>>>>         /* u64 has the strictest alignment required by page_ext clients. */
>>>>         if (IS_ALIGNED(size, __alignof__(u64)))
>>>>                 return __alignof__(u64);
> Maybe add a const local for __alignof__(u64)?
> No strong feelings about it.

Maybe better. I can give it a try.

>
>>>>         /*
>>>>          * A type's size is a multiple of its natural alignment, so its
>>>>          * lowest set bit is at least that alignment.
>>>>          */
>>>>         return 1UL << __ffs(size);
>>>> }
>>> Well I prefer it!
>>>
>>> The final bit-twiddle could be (size & ~size) but I'm not sure that's
>>> any clearer.
>>>
>>> We should have a handy helper for this operation but I can't find one.
>>> max_pow_of_two_factor() is close, but only works on uint.
>> How about changing the helper to
>>
>> #define max_pow_of_two_factor(n) ({					\
>> 	typeof(n) __n = (n);						\
>> 	static_assert(__same_type(__n, 0U) || __same_type(__n, 0UL));	\
>> 	__n & -__n;							\
>> })
>>
>> ?
>>


