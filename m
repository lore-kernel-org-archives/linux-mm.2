Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B89F5CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 20:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227978E0006; Fri, 26 Sep 2025 16:09:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7C58E0001; Fri, 26 Sep 2025 16:09:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0523E8E0006; Fri, 26 Sep 2025 16:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E39E88E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:09:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B93FBB60F
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:09:17 +0000 (UTC)
X-FDA: 83932490754.27.BEB2A01
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 33D4A8000D
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:09:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M9tfvTMN;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758917355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ib0H/rihD2sgLLUp3Mw0vWL3Rv8TdCZCaNMZP5pfwcI=;
	b=hVUG8gvNaYe3PgzKUecvJsXDFPU/PzqOy6UBOZR2sHaQqqGca/wUBHMnk1kgL2A8xnUw4f
	lnYXoQX496sCoi2NzTvPJiWwIIRBlxHaUJnR0gzFbgHnnWucQk36dPE5HSunvhck7P51DK
	DWgPgeSK9QTrOucJLKLHcKofVOJdklk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M9tfvTMN;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758917355; a=rsa-sha256;
	cv=none;
	b=xhqi6pO3xEyQwA/2neWgIlBmR/q+g4iFraobqbweuauytpjyoUUxBUGX4SRvE/gVLpfxFq
	6//bV8pD53e8SgHgqXk+tmD0/VfnuAwNa0Bg3hj3oAJZb0ymhQ05XuNuhKmZMfnunF8TU6
	WnlLUxVZiH/yvwzftJDG4LR1xnQuC4I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758917354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ib0H/rihD2sgLLUp3Mw0vWL3Rv8TdCZCaNMZP5pfwcI=;
	b=M9tfvTMNuzDLwWHHMQFedYdSQ2FO3Sy4NBKuV1cIEwmRU3UFi1jUveL7/28WgjrYLE9DDF
	UPJtKM3EgnVCv9p45AbkZhAp/RIFm2UW9igtljHUcKpPIwj2m1qHGEhujltic1AreFEko7
	tbtKA+qa24nlqBatMml6N5IzKGeOlCE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-DwdhPcsqNRqCltJGkPU4JQ-1; Fri, 26 Sep 2025 16:09:13 -0400
X-MC-Unique: DwdhPcsqNRqCltJGkPU4JQ-1
X-Mimecast-MFC-AGG-ID: DwdhPcsqNRqCltJGkPU4JQ_1758917352
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e31191379so16799315e9.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:09:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758917352; x=1759522152;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ib0H/rihD2sgLLUp3Mw0vWL3Rv8TdCZCaNMZP5pfwcI=;
        b=oFTI1g8gy2cooDJkNwuQAmIGUv8XPuneHfLq+yKj9bWiNwukZAhRaPOtoi3ZYHzg8r
         ifyvNJZEzxPOF8mfFjgzTUo9I7O5gsXzRfKjZlMiWZcMrlSojJKBHgGD7hzohwrWtRc9
         T5VEPsce3W0aZg4quJJNTc8e6qyCJHTSluoEC9UD6iTn5Nfd5s+GOGuQjPEJcKMy1U3K
         JLyDRECwQFHAi12XR+98UdIxvOq6M/0jNNiF8Z9dZva/8UG6HVyU3YldBWN0Obf7fArZ
         ZNAV75iGzi7dxU3NkKTGdAerm/wo0YywE2ymoJvdCPSXBEDgzydgRJ9ta6wcff4eUzcm
         BwVw==
X-Forwarded-Encrypted: i=1; AJvYcCXInK4D6L1mkim+Yvu0khhnDwpQrno7PiNJLRAbftdmUunCI44AiaRgChz5E6XYRZMvwLvwjqRQYg==@kvack.org
X-Gm-Message-State: AOJu0YxDyabIvMU/Gq0vgKj8Mi8rCyqZ4ksXVnzEyftvL1E2B4pUjL9R
	HkYFPI7GlcYFt0ru8O2Uq/hh6UhaQ6Qlm5BNK2zLq886wgu4nZ3csKlbH1mRKMSFOZktc/UYl2a
	F2v63Zqmq7JFgF1bLBPvu2pSNgLI+Ae3mcETbxWIwvajGRh3ztJ+y
X-Gm-Gg: ASbGncvXQJ1PDul+Vx6Fvm6mD/4QuIQNyqNrd0I3+54I/TXaWxitbJEb+5kPhp/LZuN
	0MAC5P5lUQ5spn4L/9U9suTZA9fMBaJA6Z9pCel4XqF+yS3s1ic9qGe55VZ+jWRUBBqEjLFjtL3
	Tn/VaNu4YQVvPRQ1cAGUUAfsF3u4+8kL3mh0o48FSQl4YQ37pn/7HlWB/RJcsmGodaEQqQ6wHyR
	k975t2/FNh+eG0CGxXBZlOnoTTPs9L6C0nYHod1KoRDMP7SCW0NTnQIuGvuBc2MbLobnpiuXuD9
	1DGj1mggI8ifIGiLS0Q223D8qyiDOkyQOXJ7/3NY5BywjtJdxOEKj4SVq2zxrJsDXJiQEIe33a8
	y3DY+rdUMiCDiVixcgHmuXay57pdKTMCfDxw3RKURdPxrPIBIKPIQEWLfJmQtV5txaEyJ
X-Received: by 2002:a05:600c:5290:b0:46e:394b:4991 with SMTP id 5b1f17b1804b1-46e394b4b1emr54828185e9.11.1758917351699;
        Fri, 26 Sep 2025 13:09:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNmDiaYasC7MFzibBACE1MH2JcQe6qYBv0mKRAkGRcQH1a13pl7qsNitna301n0FxceVAOrA==
X-Received: by 2002:a05:600c:5290:b0:46e:394b:4991 with SMTP id 5b1f17b1804b1-46e394b4b1emr54827625e9.11.1758917351118;
        Fri, 26 Sep 2025 13:09:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f34:c100:5d3c:50c0:398a:3ac9? (p200300d82f34c1005d3c50c0398a3ac9.dip0.t-ipconnect.de. [2003:d8:2f34:c100:5d3c:50c0:398a:3ac9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a996d7dsm136681855e9.4.2025.09.26.13.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 13:09:10 -0700 (PDT)
Message-ID: <5d11b5f7-3208-4ea8-bbff-f535cf62d576@redhat.com>
Date: Fri, 26 Sep 2025 22:09:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
To: Will Deacon <will@kernel.org>, Patrick Roy <patrick.roy@linux.dev>
Cc: Dave Hansen <dave.hansen@intel.com>, "Roy, Patrick"
 <roypat@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
 "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-3-roypat@amazon.co.uk>
 <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com>
 <c1875a54-0c87-450f-9370-29e7ec4fea3d@redhat.com>
 <82bff1c4-987f-46cb-833c-bd99eaa46e7a@intel.com>
 <c79173d8-6f18-40fa-9621-e691990501e4@redhat.com>
 <c88514c3-e15f-4853-8acf-15e7b4b979f4@linux.dev>
 <aNZwmPFAxm_HRYpC@willie-the-truck>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNZwmPFAxm_HRYpC@willie-the-truck>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j6auaskj1DFsWYOE8O8V_Fw4HQR5mkmxFnfun7bCcx0_1758917352
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 33D4A8000D
X-Stat-Signature: d16g3dzfa51c3iu1qjdczyiehf6c3szp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758917355-514342
X-HE-Meta: U2FsdGVkX197I00RgNYm80xTowugrW2G8FAdz7aZiatUvberimVCTPzBmS1t3AWZZZczpcgvXmvcCgz3gnZW5Q0LjL6qb4IGRvwL+VopsirL8jJ5XF599mGt4ymPrwUSsJCmAXKryl4jmqmSXexAiVMKcD2J5lt0QcAKH7fCxUANqciVgHWRcN619Ix0aZP8sdAO40MAzSQ1EuX1/O7lsrXOzdhVRSSQeD6EwYAmtxRsQzyI4J7+GeT4Q5U+xqYCe1VLGSHk0PdVKZ+9KQNu1yngd5XNRrZ+PEw7HEMdTdkECYoch9D5vdgkrUCZiMQSQUkqeGojGIE00dDQ4N0VPnFR4VQa6TluQbfmuuQ4sa94DQK3aWWQe+l4TRZ4Lhx0u/AOcRbQSo4IBPKdbBAFbGo3YiaIj9Cz4CqTne1F60l0FQAutzyZIF+u0AP45vzX6OjMnCgSAfzIVtl6SgKx86/o3qz2Xg1tohKOxkD3whp76QLQ1Bv9iT/Seoaf55mwNSvFOrXwhkRRRcncXBCyn7+WPHypMDYQmeZ5y2AYR64u55kRe2DQzjYirFAi+ii37GTt9vPXBgafhZES0G/Mz3ielG3D+67h+4cXoNCFf8dX4TbOVITjetE4k+tc7LRK7C7quYI/BA77pYV0ojWamHpMK3DnF8oKwSUTdXdyrs5f32wTWodGB++AMLCxcUztQCAJHw5ShzenygLASufS3CrX+iu0IUgSPjXpIW/69nVClgWoRC57LkVwRqpVVnYQr8NAVbN2gwq7KhbYVClUU6p+oHPu3nQb7i2MzuZzh3u+eL17RmolwqDv2NTfoaYa+9dxnAmRnBTGsDfc1NiHFoQHzzdjnHcaoEDPHFVBFmoLPyBajhmw73NSsetoaPNCrFNRBRpZyr+r7uGSFVevouKYOolPuJ6bTkqTua4tkW1Z4J0lrFYnwU8IR8nN5qOCnkZ87oJjpVl7J7/MWbT
 UwGwQq1L
 lAgmXiyUn6QyYC3KAkVcJcEX2EdjDw2m5Fp5MUn1IU3eqHpvUa4LagGlDYFyhWOStQ8YkEzY114pHmDo5/YGs3rTsCStSFWOR1dq9V5GpU/dyB36w0J+YRTMBrSaWJ1sUl9NNw1JeB60kMpechjNyGqqQEJYmpO4FPZ5e3Ak4Pb7fiDzszkCAmsuyEAgkK73pt8qQTdSl1Z91jlPOr2NLXSRtz0ygaQqzsJiSLQ5YalOi/bgyqZOIvfH+psObc1Ypl5uENoZP4UMfVLflYAdAYT/OeRRe89BgRDbNfulbQTOFcaN4uoWe9bUQ7X90gC7kD06K6Ofhi6HmmwwD72EhDrJ9hzF9ZcLxdPLE9762UCKGRr7nKFCVGNREevBluCCH5N6aFL5fi+O0Hw7AliR31WkODXvT+OasklvSTFG0UvPJsQM8eh35Ap4oOlb8afhqnvx22DUO3tAKAhPJHAKiYaKP4OoB90i2DyB04Wv/iOzjikorggF4qccQvQo9qigYSBKSfs7WpgJ0IwnOrWRAL/eikqOI9O7ia6Y/+fJZpo7fqK68nx+LctxvN1dreM656x13uKTdnWSO/sdCKpT52pS+RQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.09.25 12:53, Will Deacon wrote:
> On Fri, Sep 26, 2025 at 10:46:15AM +0100, Patrick Roy wrote:
>>
>>
>> On Thu, 2025-09-25 at 21:13 +0100, David Hildenbrand wrote:
>>> On 25.09.25 21:59, Dave Hansen wrote:
>>>> On 9/25/25 12:20, David Hildenbrand wrote:
>>>>> On 25.09.25 20:27, Dave Hansen wrote:
>>>>>> On 9/24/25 08:22, Roy, Patrick wrote:
>>>>>>> Add an option to not perform TLB flushes after direct map manipulations.
>>>>>>
>>>>>> I'd really prefer this be left out for now. It's a massive can of worms.
>>>>>> Let's agree on something that works and has well-defined behavior before
>>>>>> we go breaking it on purpose.
>>>>>
>>>>> May I ask what the big concern here is?
>>>>
>>>> It's not a _big_ concern.
>>>
>>> Oh, I read "can of worms" and thought there is something seriously problematic :)
>>>
>>>> I just think we want to start on something
>>>> like this as simple, secure, and deterministic as possible.
>>>
>>> Yes, I agree. And it should be the default. Less secure would have to be opt-in and documented thoroughly.
>>
>> Yes, I am definitely happy to have the 100% secure behavior be the
>> default, and the skipping of TLB flushes be an opt-in, with thorough
>> documentation!
>>
>> But I would like to include the "skip tlb flushes" option as part of
>> this patch series straight away, because as I was alluding to in the
>> commit message, with TLB flushes this is not usable for Firecracker for
>> performance reasons :(
> 
> I really don't want that option for arm64. If we're going to bother
> unmapping from the linear map, we should invalidate the TLB.

Reading "TLB flushes result in a up to 40x elongation of page faults in
guest_memfd (scaling with the number of CPU cores), or a 5x elongation
of memory population,", I can understand why one would want that 
optimization :)

@Patrick, couldn't we use fallocate() to preallocate memory and batch 
the TLB flush within such an operation?

That is, we wouldn't flush after each individual direct-map modification 
but after multiple ones part of a single operation like fallocate of a 
larger range.

Likely wouldn't make all use cases happy.

-- 
Cheers

David / dhildenb


