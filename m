Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13919CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 11:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3178E0003; Thu,  2 Oct 2025 07:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573BF8E0002; Thu,  2 Oct 2025 07:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43B2B8E0003; Thu,  2 Oct 2025 07:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3153A8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:21:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8DCDC0470
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:21:26 +0000 (UTC)
X-FDA: 83952933372.02.2BD88E6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6807BC0005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:21:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XDkZ24v9;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759404084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j0tbG0uETEop9BgEp09M58D45q7C5ew7mWN0UcZdxs0=;
	b=c4HteqiTzPz5Ptq+N9rsisJM2YE4bZSG9DwN36KZdwIzMzbdxXsvjEETivHrX5hXeCyQBd
	Kf9Y23SK99Cg5G5TxGtz9pOLIb2Yd+hUCo31pl8mA3wPZqAyAov+xUli/7QeRRyonhPl8X
	f5ru41NaGaQnuVbU9A4hTfyeMP+7040=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759404084; a=rsa-sha256;
	cv=none;
	b=JymB+H4XkHkk7DeSw1Dx5OAYrgpLRd5GQXBDnVnPrVw5NspGhzlMOlQJiINqPWsCtoOBzM
	ZOYEZBYMISLBbYXXYqhLim6pofHuNV0JTFIcMwGYOslyksQw0f7hUtNUc9WZ7w5kuOqTPd
	eLSsDdOTKvARjR/5/oOE3nPeGposHn0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XDkZ24v9;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759404083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j0tbG0uETEop9BgEp09M58D45q7C5ew7mWN0UcZdxs0=;
	b=XDkZ24v9hBHwLgPc2mHWu5BQgIZrE4xtj+WjwfPD23+qHZaFLCXHuxZOVLZFofudEobQ0H
	SZglRBLeMS63BpQk0jSvdJ8AjUUYL3Ou5pFseYRnDUsVG/cFgJ9x1k0OyxQnrBqf2keGPa
	vZXAnMnaxjVvnqj8nucqviJdCB2NDxE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-N2RVOj-kNvmcD1D35osu4w-1; Thu, 02 Oct 2025 07:21:22 -0400
X-MC-Unique: N2RVOj-kNvmcD1D35osu4w-1
X-Mimecast-MFC-AGG-ID: N2RVOj-kNvmcD1D35osu4w_1759404081
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e38957979so3332145e9.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 04:21:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759404081; x=1760008881;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j0tbG0uETEop9BgEp09M58D45q7C5ew7mWN0UcZdxs0=;
        b=NDmyr7JmWMlSOar2uBS5IK//JGHbz1/RD/drl3FxgnyHlwy+Y9xSudtpOJziY/dWMu
         rr6+dznWjkEHbo2C1qe2UX3hI4zB5tf8nBrzKc9N4BN8TDPu2NPCYNcgFCWsKDUfim1g
         2Fq/PRn+D9IWgx74DiSyEFN8ezokrbMzGj87vDSjcjaJWlVL2V0b+ybhqmrUVy5RdbBL
         obHJR6m53NkIMOYXY9VgoXIaCDezkJA+4N7VFfedaV48VpwJ6/w257xUI22xasAguLHH
         4yeTnp6R/K02A4DAokyDV3/hgtvWT80FbF+bIvUBytJ/aPBbTmD8TeIrWr0HaT7VikKk
         09MQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYlWeo78s8HTcJ+OYTxgvOSV0lukWqiUOtB16Dca4RrYlTZqc4Yq59GjkHL8uXxW4PJGvUY+u4fw==@kvack.org
X-Gm-Message-State: AOJu0YwyYzDydJwb2bc8JUOaFM1z/1NV7sDhKdHT85Oviux7WyliJ8+J
	E9tY2oFxosH7jTBzAgqocvMQDq0my6hR5ZVW9KVxxUquWbUpkbzLmko4oGVVxGK8hOEZ7DrwdwQ
	aLaneSDkZhk1DnjXC2XM+jbAfIbr07CoVSr4cNuk4D35oZAm208uk
X-Gm-Gg: ASbGnct6tIc6uSAYW2p/m/mmU8JQ/9hApxWzUF348n1dqVvM4yv5tAyIdU4HlQgqL1x
	CF3dfsBvfpGGx2o8XRJCbZYq0DeKu1HLnFBrWz/3GU5RiHuu9KMBMphcDEvXvEdv2IqxlsYRh8J
	h9H43bFqJxOeRKCLnTSrDM4gaHI3buI6A7jtsr2BPeBvKfWOjzmVq6Ew8X9k/lRmc6DBjw8Pkop
	wlhhHRZyBq5Wg9BFHPIrkY5h+h1ses1WX0YEFJbVTWCHSEfmTs5ovEa8289U4KoFdrwx3RrxVT/
	rHVKatLDfFAl2H+WZbZ6eqh805YSEcNOGBAdWRslKPuRmmaCbyBPAFX9edGLWSX6lN+hTh3nw1U
	8nOWJhduX
X-Received: by 2002:a05:600c:6094:b0:45d:d88b:cca with SMTP id 5b1f17b1804b1-46e6125cf67mr49453275e9.1.1759404081330;
        Thu, 02 Oct 2025 04:21:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9kXStO64iOsQpfMLe9GoNnIJ31KbxzcIXm6pY0D7xqW25PKHRZJ8o1vkIeJ8Y3HEFf99Rvw==
X-Received: by 2002:a05:600c:6094:b0:45d:d88b:cca with SMTP id 5b1f17b1804b1-46e6125cf67mr49452915e9.1.1759404080827;
        Thu, 02 Oct 2025 04:21:20 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a2a808sm79601765e9.21.2025.10.02.04.21.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 04:21:20 -0700 (PDT)
Message-ID: <600f9ca1-580e-46c9-94ad-f9b4b8c3cf97@redhat.com>
Date: Thu, 2 Oct 2025 13:21:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Discuss] First steps for ASI (ASI is fast again)
To: Brendan Jackman <jackmanb@google.com>, peterz@infradead.org,
 bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com,
 tglx@linutronix.de
Cc: akpm@linux-foundation.org, derkling@google.com, junaids@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
 rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
 yosry.ahmed@linux.dev, Patrick Roy <roypat@amazon.co.uk>,
 Zi Yan <ziy@nvidia.com>
References: <20250812173109.295750-1-jackmanb@google.com>
 <44082771-a35b-4e8d-b08a-bd8cd340c9f2@redhat.com>
 <DD7S12CF1V9G.3KGT3KYBLZ7F2@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <DD7S12CF1V9G.3KGT3KYBLZ7F2@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Dw452J0sS8kGIA0_ZOdknzmYiW4AJjE-CPmOTJhsbNU_1759404081
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6807BC0005
X-Stat-Signature: 1qkbskb3yq1bwed8qbnp8pt1zba6gnpq
X-Rspam-User: 
X-HE-Tag: 1759404084-130909
X-HE-Meta: U2FsdGVkX1/xi4VbJXTWh6VUhbRC7sXw3EOokKdoXafhOqdUq9KUEOBmmLsdLzJbjL1uUKwYxefOHFJMSTnnyoNu3VtU1N2eo+ams+ytrpKqz9FQwmPn9xUmS5SDoS2ZX9+4dOmHD1kHqYGpexwXy89xrcDxYvTOSYmRodhAWcrOrEaFbyZxkdaKpfScvE0IkrVGulwHRK5Y7rIbVGd9U/oibCIeG/a7z34YmuSoxaTxVj3h/sq4vCNf/wGsls/X2voeNpEiAqcrfpXHdJCveOcpv8gygdT7Jxdz2+xBlZmwKPWETOzAzh+JQ2RuW2/sWXUMgjOFqtGqwKEEoikQnZgx+2F8N7kZQE77ANapJ6Gi2uwMrCBKzU0XSBPfnpE/unmduw98PSlhStvUika3C4YRV4OTb4R9csp/8w/T1c2y0Zji/bMXHcZR0yYg2DZ5W210rV8aFFa9A6HLJ+fDAlKFegzDfCC2fTeSjBSSdcHYmI7Wxk6oetphzE/P8elwk7Q5XW/FEWReuDokfRs3k8BCYFuT+rt/7gPfa+85xBtpVz49ZNJ+lBZGu3INiPJptH0odjccXkcjRXhakojoBG8srnvxq0qgKoNc3o0hvQhI7NstpYZD12qkxMR8gsx83eGWs0xtyGFH2lOJS3TPBTgBWral44jarV4KcDMxsapfKt6DxwIFEk9d9ybR0nKqTzK6f3aDCI0dQBe4yDPzF/p+AJkf1LfPRP6NQ3cUvpSexPJTn+3z1ua88yKd0ysGqI7N4SAQeR6IuBWUY8oQ6B6L82AsLDKgFZ+38NNBBT3CppWZG1EwkfjPRsJYPdDRP+ef12YomxrXY6kEwrH7CSV2fvQNGnzD6RWow6sLyrumeQPflBijsuuXjKjOMswOSNU4tOkl0IAFd0W0nX8gCmcymKDtNhPbPBsh34ABBoAUiMK1h3mqQhpVHTFsWlRQLuXchOnGDAGzXohW2aJ
 TPQL+bRT
 hZ4dr7nWcNaS70ILeL07MsZuEA5dIx+oehKzdRdkmbBSwwjkhD4qkDVGLrS83qt1Dk8o+g0u0vnJN1OiCIyOBkzurj3G51yJjqd2GaECaOiNTZ3XUXi2s/vJUl9vEUbdzGqIFrK+1BNj1hWCcOC47rFhV2LK06jWiZjk8BkKuR/qruS4j22IK/n61pZKgxPf3WDf5No1HIf0EJP4nvhNn2IQjZQww5ufEchq7UvBNxB1oDD7F4mO+zUCdUUxgahSLdiFQdqWCTV9XR+BRTWZppREpNwPWiIEXkWF5xCZrZ8ewKKd5GbBfnOk071f2pbb0Jfm4Rq4JjdH/rMAZyA7rzWNPRczK6VlqmM9uaku/xXkI7mL4N+ss7ADjpLTTdSdXMCBP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.10.25 12:50, Brendan Jackman wrote:
> On Thu Oct 2, 2025 at 7:45 AM UTC, David Hildenbrand wrote:
>>> I won't re-hash the details of the problem here (see [1]) but in short: file
>>> pages aren't mapped into the physmap as seen from ASI's restricted address space.
>>> This causes a major overhead when e.g. read()ing files. The solution we've
>>> always envisaged (and which I very hastily tried to describe at LSF/MM/BPF this
>>> year) was to simply stop read() etc from touching the physmap.
>>>
>>> This is achieved in this prototype by a mechanism that I've called the "ephmap".
>>> The ephmap is a special region of the kernel address space that is local to the
>>> mm (much like the "proclocal" idea from 2019 [2]). Users of the ephmap API can
>>> allocate a subregion of this, and provide pages that get mapped into their
>>> subregion. These subregions are CPU-local. This means that it's cheap to tear
>>> these mappings down, so they can be removed immediately after use (eph =
>>> "ephemeral"), eliminating the need for complex/costly tracking data structures.
>>>
>>> (You might notice the ephmap is extremely similar to kmap_local_page() - see the
>>> commit that introduces it ("x86: mm: Introduce the ephmap") for discussion).
>>>
>>> The ephmap can then be used for accessing file pages. It's also a generic
>>> mechanism for accessing sensitive data, for example it could be used for
>>> zeroing sensitive pages, or if necessary for copy-on-write of user pages.
>>>
>>
>> At some point we discussed on how to make secretmem pages movable so we
>> end up having less unmovable pages in the system.
>>
>> Secretmem pages have their directmap removed once allocated, and
>> restored once free (truncated from the page cache).
>>
>> In order to migrate them we would have to temporarily map them, and we
>> obviously don't want to temporarily map them into the directmap.
>>
>> Maybe the ephmap could be user for that use case, too.
> 
> The way I've implemented it here, you can only use the ephmap while
> preemption is disabled. (A lot about the implementation I posted here is
> just stupid prototype stuff, but the preemption-off thing is
> deliberate). Does that still work here? I guess it's only needed for the
> brief moment while we are actually copying the data, right? In that case
> then yeah this seems like a good use case.

Yes, that's my expectation: we only need access for a brief moment in 
time, when actually copying page content.

> 
>> Another, similar use case, would be guest_memfd with a similar approach
>> that secretmem took: removing the direct map. While guest_memfd does not
>> support page migration yet, there are some prototypes that allow
>> migrating pages for non-CoCo (IOW: ordinary) VMs.
>>
>> Maybe using the ephmap could be used here too.
> 
> Yeah, I think overall, the pattern of "I have tried to remove stuff from
> my address space, but actuonally I need to exceptionally access it anyway,
> we are not actually a microkernel" is gonna be a pretty common one. So
> if we can find a way to solve it generically that seems worthwhile. I'm
> not confident that this design is a generic solution but it seems like
> it might be a reasonable starting point.
> 
>> I guess an interesting question would be: which MM to use when we are
>> migrating a page out of random context: memory offlining, page
>> compaction, memory-failure, alloc_contig_pages, ...

In both context ^ would be an interesting point. Maybe we'd just need 
some dummy MM to achieve that, not sure.

>>
>> [...]
>>
>>>
>>> Despite my title these numbers are kinda disappointing to be honest, it's not
>>> where I wanted to be by now,
>>
>> "ASI is faster again" :)
>>
>>> but it's still an order-of-magnitude better than
>>> where we were for native FIO a few months ago. I believe almost all of this
>>> remaining slowdown is due to unnecessary ASI exits, the key areas being:
>>>
>>> - On every context_switch(). Google's internal implementation has fixed this (we
>>>     only really need it when switching mms).
>>>
>>> - Whenever zeroing sensitive pages from the allocator. This could potentially be
>>>     solved with the ephmap but requires a bit of care to avoid opening CPU attack
>>>     windows.
>>>
>>> - In copy-on-write for user pages. The ephmap could also help here but the
>>>     current implementation doesn't support it (it only allows one allocation at a
>>>     time per context).
>>>
>>
>> But only the first point would actually be relevant for the FIO
>> benchmark I assume, right?
> 
> Yeah that's a good point, I was thinking more of kernel compile when I
> wrote this, I don't remember having a specific theory about the FIO
> degradation. The other thing I didn't mention here that might be hitting
> FIO is filesystem metadata. For example if you run this on ext4 you
> would need to get the superblock into the restricted addres space to
> make it fast.  I'm not sure if there would be anything like that in
> shmem though...
> 
>> So how confident are you that this is really going to be solvable.
> 
> I feel pretty good about solvability right now - the numbers we see now
> are kinda where we were at internally 2 or 3 years ago, and then it was
> a few optimisation steps from there to GCE prod (IIRC the
> context_swith() one was a pretty big one for that usecase, I can't
> remember if any of the TLB flushing optimisations made a big
> difference).
> 
> I can't deny the risk that these few steps might be much harder for
> native workloads than VM ones but it  just seems like a game of
> whack-a-mole now, not a "I'm not sure this thing is ever gonna work".
> The only question is how many moles there are to whack...
> 
>> Or to
>> ask from another angle: long-term how much slowdown do you expect and
>> target?
> 
> In the vast majority of cases, we've been able to keep degradations from
> ASI below 1% of whatever anyone's measuring. When things go above that
> we need to grovel a bit, if anything gets to 5% we don't even bother
> asking.
> 
> But also, note in lots of these cases we're switching ASI on while
> leaving other mitigations in place too. If we had a complete "denylist"
> (i.e. the holes in the restricted address space) that we were confident
> covered everything, we'd be able to make a lot of these degradataions
> negative. So we might just be making life unnecessarily hard for
> ourselves by not doing that in the first place. The idea is to retrace
> our steps later and start switching off old mitigations and bragging
> triumphantly about our perf wins once we are totally certain there's no
> security regression.
> 
> So yeah I can't be 100% confident for the reasons I mentioned above but
> the target, which I think is realistic, is for ASI to be faster than the
> existing mitigations in all the interesting cases ("interesting" meaning
> we have to do kernel work instead of just flipping a bit in the CPU ).

Got it, thanks for all that information. I suggest you use some of that 
when moving forward with this projects, because it's much more important 
what the roadmap is than what is the current limitations.

-- 
Cheers

David / dhildenb


