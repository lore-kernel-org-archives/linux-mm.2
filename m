Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0C95CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 11:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9368E0011; Tue,  9 Sep 2025 07:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0899A8E0001; Tue,  9 Sep 2025 07:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C4B8E0011; Tue,  9 Sep 2025 07:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0D3D8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:55:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5162B1A049C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:55:10 +0000 (UTC)
X-FDA: 83869555980.08.7F10F8D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 618CA1C0006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:55:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TeG50QHd;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757418908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOh5IdHecYmXNJFyfTY+5ofA8ReFnlDB1RFePKgZiG8=;
	b=TbzdGIm911rKIgl926IaWtrxABXv3JzDWsSlO6pEwMz1/snX1NleY8RihVcxdA0RRIP08E
	VVMNDQIIxSajmvtjSB2BjVJ2tKVwqGzpHP+jGjSkWy3VQ639RqnMFNMzr+Ay/vOtJrolUr
	Z+RokdTMzA6iYXYmc5IPMx5FCOAMtQQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TeG50QHd;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757418908; a=rsa-sha256;
	cv=none;
	b=YMtIa6qgCvn/H9KEQokJrv5rxZSNVV3kF9fKuot/Dnqn9MExK45793z4FQF3emrx+bdEWL
	w4UpBY0Jm3VwEwEF13TOUhFW0XLUJ+vFVw8m8/4w36B2QrQ2cGM2IrVA1b8mPEZdwUha/J
	jumBiOQHcHTxvFQZkv0MK8EEYBmDs/E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757418905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wOh5IdHecYmXNJFyfTY+5ofA8ReFnlDB1RFePKgZiG8=;
	b=TeG50QHdfQmlrDtNV7kIrTfhhxbITLcjscvi0ij4ixwB4EIZGcFrProR6cw9fQfpGzPy7e
	UTXEvKHWmGFtbOB5wXCKC+wmkrJhWXErmYdF+1BTY5B40LJv6CAvYZ0a+kTLsAr72z13Nb
	tMDDazEBrc3AzL2EyIYSYXp0Pn9EOEM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-YZ2cRulrM4OHMh_wp8Wqtg-1; Tue, 09 Sep 2025 07:55:04 -0400
X-MC-Unique: YZ2cRulrM4OHMh_wp8Wqtg-1
X-Mimecast-MFC-AGG-ID: YZ2cRulrM4OHMh_wp8Wqtg_1757418903
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e067ef24aaso2834835f8f.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 04:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757418903; x=1758023703;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wOh5IdHecYmXNJFyfTY+5ofA8ReFnlDB1RFePKgZiG8=;
        b=g7JYxKP/V+MEcj7xqMwqPSIYEcEtoAK9GScA7+13eQPr1q5fAulE0PCQc/M9sgzsSb
         uOHikWYZgHquFClGkRvGNMBQqdWlWklXHK+EiucbDb1r+qix+VFgN5t/lVItP5xkJNOA
         gRxqlijdZcY9AFWIgjnF9taGkoq58hb3F6nwKTRMVtOEfNnoYj5AyAs0BrKBnvy7CQxl
         G4+ik682OFsrPGMeSy25Y6Va/XLjpCWhCt2uNDkBaBk7Bva9FWt8aLrrVPBGCg90UqBU
         ttoFULPKlqSrLzsE9uaafQM2Uuknxjm2DWrJzpPjwk8PvY++/+0GE7qPzmJjAc3Cb53A
         yo6w==
X-Forwarded-Encrypted: i=1; AJvYcCUUkpCdTHa2T7wJhCEWY//rGkrrM0L860YeEU+x29RBf8D+ZCQ3lFzmqO4CQC2zw29xsWHgDcphJQ==@kvack.org
X-Gm-Message-State: AOJu0YwfTs3O6pN0BhH0rSGbF2xxZiYcmFLLlRnbmkwdslYBC8D1FCzB
	JRoU6NPmXwD3khAeWbUTwx3s6yc4ZE8+d+aR3mqVsw2E8P+Iii8IW/xm0mPjV5YZvYeR6wq9oTr
	2YTXKJZM5GTWc/ywLPnVUxt4lT22Uj4bLSLdEcrptIUbc3hNt0wleUUmzjPcz
X-Gm-Gg: ASbGnct1f/74FgyJVqm0bnfY391alTT9ReoN4IzAfmceT5xvtdcoid6uggJJOUE7BJ/
	hkrLtVciw3Lmn6ZgLatXdOYYUAmPceVlREViob/6P97hTBkScjqUXaN23ec4kBTa5QXa7XvF9ZV
	DQn0nUuHaVlYLE5MOOqSfW2xCaAGlgVx+TSgp1bxxPDhC5GasdSoPM32CNpatgWV/W10AYqWnbE
	yX2lRJK71KSLBOv/ND1aJtgAJfCV/nC7zT04/7cPgMk0qbVV/w56cn+u3NA3/0emJVecCQiapnq
	Aj08fPeLv/II41Q80MHIs7Xnxz/EmuKpsGvlhnFNdcihE6A+9aQAyGR4Khi7iQ2nLGu988K0WMN
	jT/05xt2GXIDb/rysL4P3NSxxQgqJ9+wFuYDtFHtHRTjNfdu00z3WGtdEIsdKVoDTkAw=
X-Received: by 2002:a5d:5f82:0:b0:3e7:42ae:d3dd with SMTP id ffacd0b85a97d-3e742aed713mr7769530f8f.53.1757418903196;
        Tue, 09 Sep 2025 04:55:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+ZfFXrc3J/ZXb10wuImf1IN/WN2zT9Bnd5gvpLTDU+4GYxL8KyTu1AXUf0+6BD7rUQ8++xA==
X-Received: by 2002:a5d:5f82:0:b0:3e7:42ae:d3dd with SMTP id ffacd0b85a97d-3e742aed713mr7769489f8f.53.1757418902733;
        Tue, 09 Sep 2025 04:55:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e75223898csm2497249f8f.39.2025.09.09.04.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 04:55:02 -0700 (PDT)
Message-ID: <e521b1f4-3f2b-48cd-9568-b9a4cf4c4830@redhat.com>
Date: Tue, 9 Sep 2025 13:54:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
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
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
 <d23ea683-cca4-4973-88b1-4f6fd9b22314@redhat.com>
 <ca2054ad-b163-4e61-8ec4-6f2e36461628-agordeev@linux.ibm.com>
 <e7acb889-1fe9-4db3-acf4-39f4960e8ccd@redhat.com>
 <2fecfae7-1140-4a23-a352-9fd339fcbae5-agordeev@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2fecfae7-1140-4a23-a352-9fd339fcbae5-agordeev@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8QNR8K9M6L85Xp8REoGv-EEDZF_-vUPOrRy3ACJ08I4_1757418903
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ukpxqpx9tukfah8qc5fhfuqfpgnxn9si
X-Rspam-User: 
X-Rspamd-Queue-Id: 618CA1C0006
X-Rspamd-Server: rspam04
X-HE-Tag: 1757418906-465419
X-HE-Meta: U2FsdGVkX1/5Wi1KqOsBR0LCi/5zg8wnSm7yf/OV8QclDF7d2hh0b7erHLuhBdw7/hf2j3y1uw39Q77SDb4kCd5toQ6TvD9oIfiDKCzc1gRh+C/YOf69Bs1lEOicIiyQgz4oof/OHtTMpLO72n1QKE0qEW8esp/sqVYzxMPcBJsICGjqhEUeoeCmn4BYCQbhf+xyqziBL6LEKZQK7OwPRbKJWvH9d9kr310a4wMGBG9hPubPz4ae9aJ0lyIDmNwLMyTEpGbWt1B1h4GI8WFWzY+jdMhROK52rIF4/kYqOzQUVfA/0jzbDNZXYwQABS6gTDltDDEju+ijITku89x61i3u9rOld3pwrnNLAgqKpN4CuSMLGC0+xCjzNImAQmh858I425Y3rNpVCEpTpElarvT6/PIG73MKdVHwVE8QyXcY1BxmSLc0a/WmWjsUto3m+3kux33SJGZELKPBSPHxC59ls90CbZfDBIpAKsNG0m/301X9XIwmAuR+Nq9ljSmM8uypU/zvsQpd7HIph7QxefzHTrul/Eojaw+xnPzMuKz5R7MyM+ZahBQajPvI6UTnZWCirZhtPjASZm2qIXPZblTp+sGOLdo0NXevjL+5l+OWq2s4nguxnQYOte+mn1NDeDti8oCJbB2dhYtg1c5maK//Jjqz5A0p81pXtk2+auji8O8hL3fu/eUQNo3akoO38jtKiiGxjzNy1nKnaOCiVsUhkiaaE98dGlb1q9gPB3QpGJcOf7ZK//4axCXoASLc2S31zUUxCc/OE1aanzZw1BXmyAyWNpHe+XCKd8ee1Jbd3C+/N/1hqiLxmRcuiOHY5HmL329WH44ldwrCFCWWEha1HoQimDccAyjPTKoYBOFoEYlP/5M8cy4HkVxP11z9AutpiMehkV+HPV9w2KLGUrJT8xF55kAiSKci1R85ZjRBLHU7xkXcAEHWl3vBDKLtBAfQhXlf+4WhneoywpX
 NDYDI9jP
 zewW/mhLi+SOcE6hmlf13TEDDqfzfZf8yvjTFBGFrqY56i6iSui0nPGq+SYggwR21hN/hLdfEunLaifXKeZoiOeMssH8BCY9OPYSfEP3qCF91b8qgdK9zJaDSik232WBCpAn5itU9fx9R4r6jrZMsrRZj9YOlHieph5Sz6ARqTXXAM2IjRpeZ9nUVp41qetklj8r8uf/AWo9gSYy+e7/PaHnxrAHac8OQ27/SrvMOqt8hCwhDPUtTskbc4+lkU26vua9eG7tCrOlNuGXzF5I9dYpdo1zhTAr0EjB1Cqod7VSOEfnAWY7URfyRYIoiyWe++XKe7JiSdbr2wf/Aq4ZZIsq9ipQP6LHIi6251v45l7aScwx+yQu0DOO8hwKraa4pM79x2rMH6Asb4gp978H8UET/RnZqIZQDyUf+8HkC9s8FgfipsXRxRGAsaeyQxg08s/rOUnuKWb42iu5wWxSAiGfy4XI//pIvRY0Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 13:45, Alexander Gordeev wrote:
> On Tue, Sep 09, 2025 at 12:09:48PM +0200, David Hildenbrand wrote:
>> On 09.09.25 11:40, Alexander Gordeev wrote:
>>> On Tue, Sep 09, 2025 at 11:07:36AM +0200, David Hildenbrand wrote:
>>>> On 08.09.25 09:39, Kevin Brodsky wrote:
>>>>> arch_{enter,leave}_lazy_mmu_mode() currently have a stateless API
>>>>> (taking and returning no value). This is proving problematic in
>>>>> situations where leave() needs to restore some context back to its
>>>>> original state (before enter() was called). In particular, this
>>>>> makes it difficult to support the nesting of lazy_mmu sections -
>>>>> leave() does not know whether the matching enter() call occurred
>>>>> while lazy_mmu was already enabled, and whether to disable it or
>>>>> not.
>>>>>
>>>>> This patch gives all architectures the chance to store local state
>>>>> while inside a lazy_mmu section by making enter() return some value,
>>>>> storing it in a local variable, and having leave() take that value.
>>>>> That value is typed lazy_mmu_state_t - each architecture defining
>>>>> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is free to define it as it sees fit.
>>>>> For now we define it as int everywhere, which is sufficient to
>>>>> support nesting.
>>> ...
>>>>> {
>>>>> + lazy_mmu_state_t lazy_mmu_state;
>>>>> ...
>>>>> - arch_enter_lazy_mmu_mode();
>>>>> + lazy_mmu_state = arch_enter_lazy_mmu_mode();
>>>>> ...
>>>>> - arch_leave_lazy_mmu_mode();
>>>>> + arch_leave_lazy_mmu_mode(lazy_mmu_state);
>>>>> ...
>>>>> }
>>>>>
>>>>> * In a few cases (e.g. xen_flush_lazy_mmu()), a function knows that
>>>>>      lazy_mmu is already enabled, and it temporarily disables it by
>>>>>      calling leave() and then enter() again. Here we want to ensure
>>>>>      that any operation between the leave() and enter() calls is
>>>>>      completed immediately; for that reason we pass LAZY_MMU_DEFAULT to
>>>>>      leave() to fully disable lazy_mmu. enter() will then re-enable it
>>>>>      - this achieves the expected behaviour, whether nesting occurred
>>>>>      before that function was called or not.
>>>>>
>>>>> Note: it is difficult to provide a default definition of
>>>>> lazy_mmu_state_t for architectures implementing lazy_mmu, because
>>>>> that definition would need to be available in
>>>>> arch/x86/include/asm/paravirt_types.h and adding a new generic
>>>>>     #include there is very tricky due to the existing header soup.
>>>>
>>>> Yeah, I was wondering about exactly that.
>>>>
>>>> In particular because LAZY_MMU_DEFAULT etc resides somewehere compeltely
>>>> different.
>>>>
>>>> Which raises the question: is using a new type really of any benefit here?
>>>>
>>>> Can't we just use an "enum lazy_mmu_state" and call it a day?
>>>
>>> I could envision something completely different for this type on s390,
>>> e.g. a pointer to a per-cpu structure. So I would really ask to stick
>>> with the current approach.
>>
>> Would that integrate well with LAZY_MMU_DEFAULT etc?
> 
> Hmm... I though the idea is to use LAZY_MMU_* by architectures that
> want to use it - at least that is how I read the description above.
> 
> It is only kasan_populate|depopulate_vmalloc_pte() in generic code
> that do not follow this pattern, and it looks as a problem to me.

Yes, that's why I am asking.

What kind of information (pointer to a per-cpu structure) would you want 
to return, and would handling it similar to how 
pagefault_disable()/pagefault_enable() e.g., using a variable in 
"current" to track the nesting level avoid having s390x to do that?

-- 
Cheers

David / dhildenb


