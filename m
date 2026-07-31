Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91D5DC5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 13:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0976B0088; Fri, 31 Jul 2026 09:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490876B008A; Fri, 31 Jul 2026 09:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359076B008C; Fri, 31 Jul 2026 09:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 092CE6B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:03:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A78812039B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:03:22 +0000 (UTC)
X-FDA: 85049087844.07.F17C5CA
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 676BF40016
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:03:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q1mLPuGl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785503000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+eugezfVQYSMU5tvUvWbSgw3mM0uud+rXMj1ASY7rI=;
	b=E5Eam6z1BCPcoAFJ4clumSUvsFuY6BLPMlsBh9Rx6f0VWFRyaUfuwEY84xBhar3NVIEd9q
	GzUTIdSCWiPoepYWmEJ1B/d8wpwaNCQks00Mhh1Oy30UFJGjy4767PkSwTkeAlFX8cLTTE
	Dl/0BwiI01xnkpMREs2PSjnuZZH6V70=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q1mLPuGl;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785503000;
	b=p+FuP6FigHHqCphLAALBOZt7QspaqmYIQtfDKhbZX8+e+/THbM82y0mapciJC12a1VNKSK
	pTaEcqpAmPdW1P7FHdKE+jXztK3wHjs/baWhLDeI5UIrLog16eo/Zq974+bBJtzHgjpY9Z
	T4VLlw8IgJi9PTYRQKK/0KecrdyaYQE=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso1209812a91.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:03:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785502999; cv=none;
        d=google.com; s=arc-20260327;
        b=oGqbG3QbClAwYaETcDybPyZCSFlvusu6FsggB3131jZ7VweTe1Az8Nvnfe28esSNJA
         0Qg2dOQhYSDJ20SA91R5X22lSHGS7NBo55ZZB7lgrFD5Qfi3RiTYhQcGghnPWnoccG6N
         4B8Z9kkJj2MBB2tpIzSW9Vqu5Zk4hWVcBMpXR01McOBAGugxNLFqI8Q1B9I7iFeH6hDe
         82UX0GlPgM9XOEsFyafL3HIBzXOvNpt8vz/nCyKrhgm4K5/zzd39uCFT/c8whLGtyY5s
         ENlxOjJrGv6bUoJ21bYyjZFT5+aVxtEBUPriJZhTpHXnEw0n69l30NQP8ysoQ/ARHTAb
         vLhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=J+eugezfVQYSMU5tvUvWbSgw3mM0uud+rXMj1ASY7rI=;
        fh=ecYw9AMvOBto22FDZdK59dtFg9sX3W4rylxNVxAcu3M=;
        b=Plft68pIy7z6MY8mWKqSiLRGKuPbtyQ9aArDldiGVcDAO+bVxp/onVcO1x6ITZWz8L
         QcnQmqurjJhC33YivmIdXd5gRo+TuBfSiJZfvLGFQ5OIM3YFS9WlaLW4PNgG4dU9kEff
         i+KP/O+VWRFd8eOAs42NY1y/7oteWjiGVdt4c7ZMND7X7TzXMi4tSaN0DyS77/FTf6+u
         n12E9njfsx5tPJ0A0MM94RDIKhKyY1cqwj757SBMocJOwj5qFSE/Yg4QHgZ/db0xrJAz
         gtrXxdFOpw2gfZDDk+OQt0DOrExMD3iGhhDGIvbiD/B5v1CcvvOI0xnUTE89Nb0GO6Ds
         d2tg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785502999; x=1786107799; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J+eugezfVQYSMU5tvUvWbSgw3mM0uud+rXMj1ASY7rI=;
        b=Q1mLPuGlUQ+vRySbg4Xl4vAcAV+F7Y27TVTodtUwQuluG1b1BnrXnBW3S7+pFJZtKY
         Gcf2JrkNqg9/DKHHb6XjwUNjSxtThImqlJ8DECuGdJ2beX002/lZ/W6dpzB+nWv9yPvi
         4CwLX/EsuP6bDD2IHWt3lVAvsRtgl+3/WAlxgFtP2KMG2gRGGWRrQzFQKh0mcFZEZdeU
         FFzFM3tetNJxba818hUqQUG+NalqbwZNy8WhDE6f4sWAGlV/uxVCgb7cSx49fxYPnEqO
         VAcwc2NDOJCm6GcZt4CSSHqAKUmS2jXOfN7YvLhMM+7xWdp9Ih6QhYUSOZOPqwxzF/K7
         tgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785502999; x=1786107799;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J+eugezfVQYSMU5tvUvWbSgw3mM0uud+rXMj1ASY7rI=;
        b=Kp3L70JB3fSmjKBuGbpR4Jz56LPUegQYWGLghRsyy6q6rywIX1wRpO8q+Z8dGpaRFL
         5BbKkOFxmzR+tfjniuihnTiaDxNw4+M7g03YBFxQCGjHSSEccsSh1TPlT7jMOT0C9oSh
         XXc+0WTJGeAph1Rg6j2kjW+ar9iulyhxJFPXJPNkfQDcxuR9jmpz/s2Wnv0Rw5BdaO2b
         o6T9x0Inf89VAvPwjoRw9jLy9G6mUkFjU455mz43dudAMBUpELnDSpcaKriTjbP4bPzH
         ZRDWZWv6MYjdfB7gQ+4BbZ7TVnuOffxyN6LTub/mENL2v1CSk8v/wp8QrWkf+eFFdFYI
         7I6Q==
X-Forwarded-Encrypted: i=1; AHgh+RpFfaeAL6l8R9LLgEa7HHlRHosWBcdOq7J4r0w5Eg8Eyx7U3bjJg4UAnbqeoF6Jd2LIBFgujHyD4Q==@kvack.org
X-Gm-Message-State: AOJu0YyVjV9QzVmp5C9KcORhkkvlfuuJeKgDDvrP2NQMopZyoqVFRsGO
	m3cm/thScHN6n08k0eXry8vRHVTXKfC7PDoncyXMG2EI0d54U/Y6dMZwhHQ4jM8Ewd5IQTOutuZ
	pxsfSWtlSjEodmMH1YGdDiriDMy/actkO1B7W7/Bi
X-Gm-Gg: AR+sD12omBmXYdWWG0aQg6uRS6gcGf+V17p8XcWbVsH6SO79vDk3F+0I8addIJrBWJi
	l60z0tAFZSHf/zhzVGOo9B5qAfBzAc86Ki82d0mwEDI6vPfWy3t5twDZBPnLudlPj2Q48pIt0aj
	V7xBBGvTc8YRP6mHCeD/ow6AYRULjISOI34G+nU7R3w4d07hN4Glq30N6UM3DUxzbJIvkdmp4SP
	hx42+sddEUJDl2bmRVqTbMpJ3Y3OPmnNbcPG82YGC52qcMXcgy0KoiGxiUXZw4zHJQKbKN5QYg4
	Mpkk3Re2xR82vt/g5TyZ3QWfJaDLzaeWdgKp0+GrqVYv60QQgeFRIjQ337p4AGzv/nk9R3s5eJK
	E
X-Received: by 2002:a17:90b:1345:b0:38e:655c:6516 with SMTP id
 98e67ed59e1d1-38fb0e7d036mr2121478a91.0.1785502996836; Fri, 31 Jul 2026
 06:03:16 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 31 Jul 2026 06:03:15 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 31 Jul 2026 06:03:15 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <edc3566b-370c-41a0-a71d-2e4a0e1a94f7@kernel.org>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com>
 <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org> <CAEvNRgEUQSju2tW_1zMk2=QmveZNtmkjjCZdqVBgBD2JPh0k4Q@mail.gmail.com>
 <a823e3d2-8acf-49d9-a812-ac1bb2136d7f@kernel.org> <edc3566b-370c-41a0-a71d-2e4a0e1a94f7@kernel.org>
MIME-Version: 1.0
Date: Fri, 31 Jul 2026 06:03:15 -0700
X-Gm-Features: AUfX_myvtAX7kCr1AZOI0RcjaLMvHuuJT4jX9i2y3E3Aj03MfOs1jY1iA4ExW_o
Message-ID: <CAEvNRgEas_9BEV-cNxXu4_wQx8sR2M4_OaW6DEd4=fszALMV0w@mail.gmail.com>
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
To: "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "hughd@google.com" <hughd@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 676BF40016
X-Rspamd-Server: rspam01
X-Stat-Signature: pf61wtg7616i9og888sp4thze5d41u34
X-HE-Tag: 1785503000-704296
X-HE-Meta: U2FsdGVkX1+qUAErKIoKwHbIjTjOvAnWDHwIoToV2mU6zVXKwz/HyTXg82XTaoYyK1zQ5HDMKn4bTF5jyuiUULAtgTD81zMGoMdwWbg16C3EMxqXuqP9GqoE1tnrWmzXbzybuNaIGflQRAaY9PpMbWWRrGrlpaO8L2XFg2bEWCKS+5XXUUIy3790FC/z840KlqnFPxu9FZZeZG8fvHvzgUrRjsy6crVVUUaelMTkycIBUZi+A0cr8D7rXGhv+PDYY9trCIUu14Xf+vQ/5wJNIXFIklYGMFM62we/Jzg/QX4KbB1lqpqH35aLQgI0Zo5YOreEdg32koDzHVns7juVY3rcDJp9VtjqWRwtRaESgUnwEmcCIphrxGGRN2JYS38gl+RwJiPjEqTuDbqcBChvR1hyFRGSUrLcd2zd2lu90tYMaCUbT/ngJBG8BFmxpxqdq+FTGhOZgogstbgqNNZ61mvJrBfQOTYTrLvZl4MLk9sz30yb04OsMidOjmSGUFC9lwQWLARsYY8gIV7h6ZsORDc6o+pRXtPge8jyXf+e/cZ1QWKJlGStuGKLo1dnduknbPXChie1+RGRbjrEfy37ta1UUSMT7BEgKyMHOW+BS9Fqjz2MyNuCkLJpzkm0tdm313AUay0/+rtUrrnoxYWSzYMhfNbb7LdXRXABjN60aW7N5vyiHTYKjbOOu1uvCnRniLI8dHKN8mi0T56Yh985/C7LVw2nJ37pRmrg33x8RWBYDj2hwjS96N8WW2/oKMRv8RQKPSCwQrhJ13+sLDKRdTp84RhsRrjlLe+LRD8mIaqa2Pogwp5D0JkFLDh8poXpQ4LWZhthBR5GM48Wg06UKmE+Z/GuzEYNkf0nEX6CryvjJ7w7VQIN2fUOeE4oBU7/qQVLsmdxtGxxFBSlrloWlBLROfOIisWV6U9B60BjiWecfCVFmJUi/BLT2q5CRn3Nl7kZUSygqQcjVGzdw/9
 TgUPKfnV
 y9ocz7SNitZApN6LgROoU4UaJP6ZzAFyIfvBcRk+sEzGuD0iKjIoI/4/LXJDbJURrXM3DMlPl0aLtxmqpYaVijK/XiVjxjqxUEQ3XQWzaMRelCtxRqQcslDzIlJTUdtU9A7ypAS1Cl7Cf7J6vTw+UHHSpkS38ePrLEGystoIRwyXAbnVKjXp4Kk7ZEal5tA7JioY9tMldSPpn+v5j8sa9W4nHwTodX1GA98vC6hKoeEbipfBvclTbfLZRyQwFqlAz1l8gieh339oFJv3Db6WJLsJJG8Od0RSrzVdEjzv7dOT3YoBlEjG1GEEgLPMlKQpF3qegpc1ByBSdsDoOvD4//3Nbw0r9btG8bo6rRacXYdcTMynUUz6GBJFjHNQeaBXZQW3bEGUBJYcOYH+1xvSondso/h/5EXqnhkTTDnD5K4TL8n/2Ap1/pZGuJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 7/31/26 12:22, David Hildenbrand (Arm) wrote:
>>>
>>> I didn't really like this either, the drain_state thing is really
>>> awkward, but in both usages (collect_longterm_unpinnable_folios() and
>>> guest_memfd), there's an outer loop where if the draining happened on
>>> the local CPU before it should skip straight to just draining on all the
>>> other CPUs.
>>
>> Just nasty :)
>>
>>>
>>>> I was hoping that we could embed more logic in a helper. The history [1] of the
>>>> refcount check is rather sad:
>>>>
>>>> https://lore.kernel.org/all/c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com/
>>>>
>>>> ... primarily because of mlock() handling.
>>>>
>>>
>>> In the original code in collect_longterm_unpinnable_folios(), I couldn't
>>> find anything that handles folio_test_mlock(), so I was lost for a while
>>> until I realized mlock() doesn't add a refcount to the folio.
>>
>> mlocked folios in the mlock cache hold a reference as well.
>>
>>>
>>> Are you kind of proposing an optimization to
>>> collect_longterm_unpinnable_folios() by adding a check for
>>> !folio_test_mlock()? I hope we can put that in a separate patch series,
>>> I'm still hoping to get this series in for 7.3!!
>>
>> I was trying to avoid messing with the refcount for ordinary LRU cache pages.
>> mlock() should be a corner case for guest_memfd.
>>
>> Relying on the refcount just means that one unconditionally performs a lot of LRU
>> cache draining even though it doesn't make any sense.
>>
>>>
>>>> For guest_memfd(), would mlock() ever apply on a path where you need that check?
>>>>
>>>
>>> For guest_memfd, if a folio were mlocked, unmapping it would fail, and
>>> so the refcount on the folio would be elevated. The
>>> kvm_gmem_is_safe_for_conversion() check in the patch after this one
>>> would fail, correctly.
>>>
>>> I really wanted the caller of the lru_add_drain_progressive() function
>>> to control whether to do the drain (see below), which would solve the
>>> mlock problem by not assuming the use of folio_expected_ref_count() to
>>> determine whether to do draining.
>>
>> Again, the problem is that on *any* raised reference you would drain. I
>> was trying to limit the harm.
>>
>> [...]
>>
>>>> + */
>>>> +static void lru_cache_drain_for_folio(const struct folio *folio,
>>>> +		enum lru_cache_drained *drained)
>>>
>>> The main thing I wanted in the proposed version
>>> (lru_add_drain_progressive()), was to let the caller determine whether
>>> to try or to continue draining.
>>
>> Why?
>>
>>>
>>> I wanted the caller to have full control over whether to drain or not,
>>> so I didn't want to pass folio into the function. I thought the caller
>>> should first determine whether to drain, then call the function.
>>
>> Why?
>>
>> That's literally what the existing refcount check tries to do: figure out if
>> there are LRU caches.
>>
>>>
>>> This version assumes that the caller wants to continue draining based on
>>> something to do with a folio, and the folio may or may not be on the
>>> lru_add fbatch at all, which is a little strange to me.
>>
>> I really don't understand what you are trying to say.
>>
>> Draining only makes sense if something is on the LRU cache. And there are
>> better ways of checking that than relying only on even less precise refcounts.
>>
>> If someone wants to do an early refcount check to abort the overall
>> operation, that's fine.
>>
>>>
>>> Also, this version enforces a certain definition of "expected" number of
>>> refcounts on the folio. I guess in this case this definition works with
>>> guest_memfd, but guest_memfd doesn't support swap so the swapcache check
>>> in folio_expected_ref_count() isn't necessary.
>>
>> ?!
>>
>> That's why we have the universal definition of expected references and the
>> common helper.
>>
>> Because pagecache pages commonly don't support the swapcache.
>>
>>> Also, if the definition
>>> folio_expected_ref_count() changes, then guest_memfd is implicitly
>>> affected. Not sure if the "expected" definition is the same for all
>>> callers?
>>
>> It must, because that is used all over the place. The only thing it
>> cannot deal with is references held by the caller (which could be supplied
>> through and "additional references" parameter like we do elsewhere).
>>
>>>
>>> I guess if there was a function named
>>> folio_ref_counts_indicate_presence_only_in_the_filemap() instead of
>>> folio_expected_ref_count(), then it'd be the perfect function for
>>
>> You're not seriously proposing such an abomination I hope?
>>
>>> guest_memfd to use. The current definition of folio_expected_ref_count()
>>> also includes page table mappings, but in this check guest_memfd really
>>> wants to make sure that there are no page table mappings.
>>
>> You can just check early for mappings.
>>
>> Remember: this is about LRU draining, *not* about your final
>> "unexpected references" check.
>>
>>>
>>> This version folds folio_likely_lru_cached() into the check, and I
>>> adopted the check for guest_memfd because it'd help with huge pages,
>>> though technically guest_memfd is always 4K now so the check is also
>>> pointless.
>>
>> Who cares if we end up with a common usable helper? We have usless
>> checks *all over the place* in common helpers.
>>
>>>
>>> I tried a macro version of this where the macro caller can pass in a
>>> full condition, which would look like this:
>>>
>>>   lru_add_drain_while(folio_may_be_lru_cached(folio) &&
>>>                       folio_ref_count(folio) != expected_refcount,
>>>                       drain_state);
>>
>> Yuk.
>>
>>>
>>> but I thought that just created something people have to jump to, to
>>> first understand how the macro works, so I left it as an explicit while
>>> loop instead.
>>>
>>>> +{
>>>> +	if (!folio_likely_lru_cached(folio))
>>>> +		return false;
>>>> +
>>>> +	/* Try local draining first, if not already done previously. */
>>>> +	if (*drained == LRU_CACHE_NOT_DRAINED) {
>>>> +		lru_add_drain();
>>>> +		*drained = LRU_CACHE_DRAINED;
>>>> +	}
>>>> +	/* Try draining all CPUs next if still not an LRU folio. */
>>>> +	if (folio_likely_lru_cached(folio) && *drained == LRU_CACHE_DRAINED) {
>>>> +		lru_add_drain_all();
>>>> +		*drained = LRU_CACHE_DRAINED_ALL;
>>>> +	}
>>>> +}
>>>> +
>>>>  /*
>>>>   * Returns the number of collected folios. Return value is always >= 0.
>>>>   */
>>>> @@ -2266,9 +2316,9 @@ static unsigned long collect_longterm_unpinnable_folios(
>>>>  		struct list_head *movable_folio_list,
>>>>  		struct pages_or_folios *pofs)
>>>>  {
>>>> +	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
>>>
>>> I also considered an enum, but it would be another thing to export. I
>>> was thinking to have drain_state just be opaque to the caller and the
>>> only thing the caller needs to know is to initialize it to 0.
>>>
>>> Perhaps there's a better way to "make it opaque"?
>>
>> Putting an enum into a header is a problem in which universe? :)
>>
>> Ackerley, please stop making up stuff. Having generic helper is not a problem. Doing
>> checks in common helpers is not a problem. Putting enums in headers is not a problem.
>>
>> Your version is just bad.
>>
>> I can later try something that keeps the questionable refcount checks in place,
>> maybe that could do as a temporary solution until Hugh possibly finds a way to
>> remove the need for draining entirely.
>>
>
> And looking at it, the current folio_ref_count() in GUP is entirely wrong
> and always makes us drain local+all.
>
> Let me fix that first, which will also modify this code.
>
> I'd say, to unblock gmem we could have something minimal that I would clean
> up later, but I think the problem is that lru_add_drain() / lru_add_drain_all()
> is not exported, right?
>

My bad, I totally mixed up refcounting to drain with refcounting for the
safe conversion and didn't have a complete understanding of mlock().

The problem for gmem was that if there was an elevated refcount on some
folio in the range, it might be because the folio was in the lru_add
fbatch.

If it were in the lru_add fbatch, it would be fine to just drain the
lru_add fbatch and proceed with the conversion.

lru_add_drain() isn't sufficient since the conversion might be handled
on one CPU when the folio is on another CPU's fbatch, so I had to do
lru_add_drain_all(), but lru_add_drain_all() causes IPIs which are
expensive.

In an earlier revision I exported lru_add_drain_all(). My understanding
of the discussion at guest_memfd biweekly was that Sean didn't want us
to export lru_add_drain_all() now, and then end up exporting some other
function and unexporting lru_add_drain_all(). To avoid exporting and
unexporting, we then said we should refactor now.

Happy to go with your proposal too.

> --
> Cheers,
>
> David

