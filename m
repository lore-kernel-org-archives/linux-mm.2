Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C58CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 13:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4678E008F; Fri, 24 Oct 2025 09:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47BAF8E0042; Fri, 24 Oct 2025 09:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36AE28E008F; Fri, 24 Oct 2025 09:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 242848E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:23:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEEFB12A235
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:23:50 +0000 (UTC)
X-FDA: 84033075420.04.4FAE376
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 393AB180004
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:23:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IAYgAPEv;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761312228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9pZe05cqV5Y1PIBh8vBXPAYdFpy0cqXi9nRKa9E+n1Q=;
	b=YcmX9BsyUaG2YXphUUZM1Rd/oNbpG86ZeNwO3dfRQkrbxUU/VG216rU+uYAHj1rOUQ2mS5
	8XstYCR5NfNX19BNmKWeQZn/F3cocFSg8mjV3EQFPTLgOf4z980OSyx2+UuSRjVO6z8Hwr
	TXLeetTkEEzKVCpjWDImnQKgEIlJq6Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IAYgAPEv;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761312228; a=rsa-sha256;
	cv=none;
	b=hJg0Z6L6WFdpM4leQZEVfXGLAD2WMT6/Ce7iBeC6DGn5kpsnU7qyJ28CUpiiqIBS1E2/+D
	wPWoUAD+5gPMRXfBBPLljcBAqtJdcuVO5+y0quvVFpwgfbDiKG+j0bbRWNiSk6lDE0d2BG
	pq8io95w/R9O8baPOdwYciKSAcJeKos=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761312227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9pZe05cqV5Y1PIBh8vBXPAYdFpy0cqXi9nRKa9E+n1Q=;
	b=IAYgAPEv1Dr1TGuqQEfALk1LI+okOYojmP15gMelwyx7L7rmeUjlI62pEm3iyGNIIV9oPK
	5SaYNfisaTE+PedtTAJlGziw/Jnb4zWgC3x4Kzk/JlvioGGlcMM+t3n3sUAqT3/lPFbfKl
	UCxSW/cIZ/PRPrUIr0ADXqIG4Ib3LJQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-LPruBXw3P3e2Qa_WO11WDw-1; Fri, 24 Oct 2025 09:23:44 -0400
X-MC-Unique: LPruBXw3P3e2Qa_WO11WDw-1
X-Mimecast-MFC-AGG-ID: LPruBXw3P3e2Qa_WO11WDw_1761312223
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47113dcc15dso11591575e9.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761312223; x=1761917023;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9pZe05cqV5Y1PIBh8vBXPAYdFpy0cqXi9nRKa9E+n1Q=;
        b=tqLX53rdpXE27otxnL77iHuW7pL2A+UD2KngwdoKUlhpzKuHqdhwSZxuO28wbOkzUN
         HdM6Ig2OXRKmpt1GJm3kpONUaWvN61V6WMCddgle/nG06PbwrAhne5qCfhQ8DUwEDayI
         Qc33BFT9K9RwH54vzcfmnP9mYvUAdmy2PJsnFTQ1mZy6npriSGXHKqhK2SWv3X9gNwBP
         /vWf2eFRWnC/ggY+FivfYZbFFq0Dv0xhFojCz/qRNCX2AV7jzdeVoom3EHEwWmhVxrQY
         PJLQ8ujn7JkGvbgSlnJfyPyNoggZd5w1UbiEzVL32iMpyycjmD/NIbvpzcsytaQD1zhD
         4dqA==
X-Forwarded-Encrypted: i=1; AJvYcCWGi/gRetSFGaxkGkp0nCcV5R1F+/olO8W0cdrXAs59qVRwrmwhdF9I6l3mDxMtmzw9y8go9bzDtw==@kvack.org
X-Gm-Message-State: AOJu0YzN4536EIwdvXH7qk0ghLpmz6xqOi7627vDfvumqmSTSfPKbd1Q
	gOeXrHg0uaq6upa1Af2zcaVKd4KWAYs/w9+spWpxJcrmRSNW1NyiyeH27D6XMOiPG+4CIk6bu89
	VDHvC15AOUelL9gAd4zvm8FCZGF6YjFMgVQQ2IL+zlPcLWvy7mtAA
X-Gm-Gg: ASbGncte4y5pasf0rQd6WxE4LedWr4LUHBSEVmKA8xSFQoydvW6Sf7onpYlyD7E4V6u
	zBsw8H2zW/tfyalCMsjifWfazlOPFa/LTVATBkZt++AyrnYAm4U1OU5eHfwqbxD50FhCb36SisZ
	AZ23xarwYL7xC/WsT5a7Q1lPKbmzBDBk1yYYr3aK/oPEK9YR6jTuZPc5hfeqCUcIGBHRupKeaw9
	Cte5OFKVJ6zGBLCPbVWxgr05cJZ4uE2WJTIilTJ6973GQlIN5VUl818lwkwP+OncHasSUOkkWLK
	uUNy9+HAiocSYXYG28lQsR1+R9IZxhsssUivGtiLZxPnezPCnYYkuFyNPOQq+0j11yksCQrJwjv
	tdDG9g14pC1Y2Y5qStusoEXPuKi9m5UO3gnF4yg3xMmF8szfNz9s2GuM+B6IeMUKWGePyIKam3O
	nrtVvsE06QBfSbhlmuYV6UtTKLDAk=
X-Received: by 2002:a05:600c:1d9b:b0:46e:38f7:625f with SMTP id 5b1f17b1804b1-471178771b6mr180789635e9.10.1761312223053;
        Fri, 24 Oct 2025 06:23:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtGsLBVTNfj/FZoaJq9YDf0YbzbT70oZVwx4vja/yfyCx4XWjsWfYr2kPeTBeEcFsrMCFiZA==
X-Received: by 2002:a05:600c:1d9b:b0:46e:38f7:625f with SMTP id 5b1f17b1804b1-471178771b6mr180789265e9.10.1761312222639;
        Fri, 24 Oct 2025 06:23:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898ec1dfsm9461004f8f.43.2025.10.24.06.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 06:23:42 -0700 (PDT)
Message-ID: <af4414b6-617c-4dc8-bddc-3ea00d1f6f3b@redhat.com>
Date: Fri, 24 Oct 2025 15:23:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/13] mm: enable lazy_mmu sections to nest
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-8-kevin.brodsky@arm.com>
 <2073294c-8003-451a-93e0-9aab81de4d22@redhat.com>
 <7a4e136b-66a5-4244-ab07-f0bcc3a26a83@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <7a4e136b-66a5-4244-ab07-f0bcc3a26a83@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7B6bi2NCtpY0gfr2ITPEYmg-VjPGQ1yIkGaIecmWivM_1761312223
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k3ysg6nhme4zhjcpyw78wjeawi4ezcmi
X-Rspamd-Queue-Id: 393AB180004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761312228-870565
X-HE-Meta: U2FsdGVkX19uUMvOvwchjbaa8aHnRzST48fZoO/U0+56t+XJMKrwzfi085y42tnDFrgfiOjWWNpwXZKW20ts9IWMyxgMHP/4LOYON579QHr6f1QE3WpZfdCPtnFG70XerSZmoEZio0DQVTy3SuMJcGNIi14zzRAfxu8uAurP29GpBFVYsaTvRcG1ShKu6YaArSBizMzTdK9vTBjwiKDK9rauYX5il4h21RvnR4DMb/FJWG7p0lDbfbe1/8+gPOoqou7MLvTPxUyh3OnvYoSpxDaLTmFhtCvVcZskhM59mOvy8OL8YcvmYdpBNf3sSoA7ElMJH3IUshfdT88ph6V6pIlSRaHJtRLGeu9ZDyBdzptH0mhaWyeHZZ+naUtEO7fc4YQX8xh0j+RwSSeEnhxbl0cw3aRXNIJWmCvHCvMh62iWXAWh+adgKoUEu9U5R5lNe2FwQLFUdUW10ElrkBQfzhLG50ggRHqbell32qKUAqJFxj3y9lBJUllmFPIip1UbHOGGgpMHwdbzBLNkPuR3l5ixaxnI2m6fJZBDWePH3V5B0qw/ss+Vvh68NNdaQgzaLFDNwLp1Rn6+gHcN4tgLCEd0MgwpvrVpQuWjh5Py3lM3KFTJukEldpuHpknr9e3LhJqdQ96+YElXFjzT4w7OByAdGw4av6W30PYVo17DsyK2TsTBwuJZfBxp0PK6b3HHLYD0Vyj6XKzurRp5guZ/IR/f0GVGZvtb3BN2PNbdJ0E1dusnK8Rq20QxXn4poFRnlpe3X3eq3gdglx9m2QJ52rN9qAbguHOthgRiLJiqfUZedDg7FfaKNyS+Zecwn1DkY8N+4mXnNGyx489YL3+h2z07SxyKHlakSJAHE1xOR2FmTHSyfIHL1CxQLeapBoAFasZsC18Cjl8NXCdnO6xPanEiFhnW7eMAlRlXVgBNZ+G/wfJIxU9c81cFH2Vw4vixxClnIa3jWkXRBqiRDds
 XFMOLUBs
 QQzKv831iniTNz7fOzz0yeqW3eLSf6UCQ1L3Z2BQqnZeEucko6OMWKwdBpmnd4LsDbFTRWKA6XaeKrpqr4pQ8kdqQPRwmColXVEz/PjDbbtMdh69sAR/bKpB3/FiYNoPMRhNog8ARaTzLr4qzXMUwvFuHDL9MQuOH/2KakHEfE65ergzabSls950LNB7EzLPkGeySVzXh+XDls0t2skNfzZYsFls5YjBzGmfx5HbCymbP4/RKXH++XocLpp1t+Og20MZdkv7O4ddZoZLKI5NWiEsWcav/WT6hHjEzxrrXwgJRPhCzKswFbV1yTufLZlGgmSCt7XjDf12nhkmwXuANIHUGQo0fxTDE73RNmRFQhL0/yXoJ6gnedXFKHYTmJ6D5+DpMwcRsPe+yofihq3r4i6Z1lqkqFGAGhwEYS0/6Qrgyxb5OgEpQrk8J44fF5+pip29dBScUAYYNBTnb1b8Xtng+QQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> + * currently enabled.
>>>     */
>>>    #ifdef CONFIG_ARCH_LAZY_MMU
>>>    static inline void lazy_mmu_mode_enable(void)
>>>    {
>>> -    arch_enter_lazy_mmu_mode();
>>> +    struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>> +
>>> +    VM_BUG_ON(state->count == U8_MAX);
>>
>> No VM_BUG_ON() please.
> 
> I did wonder if this would be acceptable!

Use VM_WARN_ON_ONCE() and let early testing find any such issues.

VM_* is active in debug kernels only either way! :)

If you'd want to handle this in production kernels you'd need

if (WARN_ON_ONCE()) {
	/* Try to recover */
}

And that seems unnecessary/overly-complicated for something that should 
never happen, and if it happens, can be found early during testing.

> 
> What should we do in case of underflow/overflow then? Saturate or just
> let it wrap around? If an overflow occurs we're probably in some
> infinite recursion and we'll crash anyway, but an underflow is likely
> due to a double disable() and saturating would probably allow to recover.
> 
>>
>>> +    /* enable() must not be called while paused */
>>> +    VM_WARN_ON(state->count > 0 && !state->enabled);
>>> +
>>> +    if (state->count == 0) {
>>> +        arch_enter_lazy_mmu_mode();
>>> +        state->enabled = true;
>>> +    }
>>> +    ++state->count;
>>
>> Can do
>>
>> if (state->count++ == 0) {
> 
> My idea here was to have exactly the reverse order between enable() and
> disable(), so that arch_enter() is called before lazy_mmu_state is
> updated, and arch_leave() afterwards. arch_* probably shouldn't rely on
> this (or care), but I liked the symmetry.

I see, but really the arch callback should never have to care about that
value -- unless something is messed up :)

[...]

>>> +static inline bool in_lazy_mmu_mode(void)
>>
>> So these functions will reveal the actual arch state, not whether
>> _enabled() was called.
>>
>> As I can see in later patches, in interrupt context they are also
>> return "not in lazy mmu mode".
> 
> Yes - the idea is that a task is in lazy MMU mode if it enabled it and
> is in process context. The mode is never enabled in interrupt context.
> This has always been the intention, but it wasn't formalised until patch
> 12 (except on arm64).

Okay, thanks for clarifying.

-- 
Cheers

David / dhildenb


