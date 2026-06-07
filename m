Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 332EDCD8C85
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 00:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6BE6B0088; Sat,  6 Jun 2026 20:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77BE6B008A; Sat,  6 Jun 2026 20:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66866B008C; Sat,  6 Jun 2026 20:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B52DD6B0088
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 20:30:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A061405F8
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 00:30:59 +0000 (UTC)
X-FDA: 84851236638.27.7C1864A
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6BFEB40005
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 00:30:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TyDXpGcV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3v7skagkKCCIR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3v7skagkKCCIR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780792257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnUUCXZJSSezsNhIoSCoYnkWRzWUK1TZUzSaS2Q+eGY=;
	b=rJioP3Tr4ly3H1RW//9TecJB62DiPL4+nFqfpWKGUtbEm4pN8ecB0BP8rKXD9fcqstetP3
	kxN8njNumHwYEqTy2+K4puDxq+EiVGgrXLIRYnJXwifY1I+HD7y8l57NnHbuvQCMjnsIvD
	H663cnuPvyFtwA7R/+71o4gaeVi/zqg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TyDXpGcV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3v7skagkKCCIR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3v7skagkKCCIR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780792257;
	b=JA6biIsVds5r60ofERb4UUAlJwNcSUri5fSYhzfNjXqN/mP0cZPtiQmH3Edu72+2w0v5gc
	F7K8hPAUD8M0hR2Cdug4lbG0okorNu7HQjqyqOHFWnuw3icq5wdnz3JTX/1EaP//e6D91r
	wNebFKDY71MlUct7cKXzA5hirNjcg8A=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bf4ba05fd18so115086366b.1
        for <linux-mm@kvack.org>; Sat, 06 Jun 2026 17:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780792256; x=1781397056; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XnUUCXZJSSezsNhIoSCoYnkWRzWUK1TZUzSaS2Q+eGY=;
        b=TyDXpGcVXwV7S3gla9OgwyqIRKq5tOoYkXFF3njduBmECoKrFyTaX07i3jT2G0LQHj
         sYaLgShNnWugvJZSneAxApHp8KcRyulS9+hUPyquwbLKqXokIY3xt47LKsZU/fxaq56L
         1zCuZ1HUv4atyWZ6VB+iz5QOV4ee20NV1cYkZUQvKjNSvviPs+Ch9i0mq/JqipCzJ/N+
         LJD7o+VuOXP6mSpnr0LqoXZI3iU9unqiQiG2gdMYyKqEIvCHRghCwPDcfSL/4g7NCC/E
         ft0kzSNW9Lm4KfU9Dyhc9vylm/dJb+JH2BF44tVutxj7cgzpB2PCpqYOvJWW+ZW4Wfr4
         Xgew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780792256; x=1781397056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XnUUCXZJSSezsNhIoSCoYnkWRzWUK1TZUzSaS2Q+eGY=;
        b=osmcyhAkv1iCIstItlP8XdFTCYDgTRIWWdPHDvDILjRkFPkmfd74633afZ+SbxFhSj
         v+5qa2Ds0FnlwlQUHImKaAIgkNiFKcEwm6dAjLTi4Kc/PpZ5q4/0sxwl1U4zjH+64V78
         UF/KKlz1iAnzX1V4Hhae47uyhGrbPE95+04OlYTkotnxSfCzN0LNlH1qSYierwBnoSzA
         /uEi7NdH4MPW+de0OjMjapoVOHxBjF8twfccQ73DIn2T8gzM0HO0Mw3JI+00yUCObs3I
         QIRT98z1eAvjOi024g2heddd7ke6FKIvUT1rzXNHmUC23FByUSLmowLP28+433Lwio9m
         An2Q==
X-Forwarded-Encrypted: i=1; AFNElJ8xTc5fzEoDfjkomxXL4ZeCy5ZuHisBoRqTpx6hId0MReGwGp53BhXRZYe8HHCOfYVGjrVdkCyMqA==@kvack.org
X-Gm-Message-State: AOJu0YwsudEtIBrd4Gpp8n1gFert4p9xIFSyy/dmyOr3n2WQ8et5Hofq
	O7M3fZArBJt9hvovBaolgtLtQhKlesP13H2gJojNt5F6HzsdQ2vhq6Ddj7uDxBtqzEA8VWFkXIn
	5d0gFDrNv2OyXBWwT8w==
X-Received: from ejri14.prod.google.com ([2002:a17:906:698e:b0:bec:674f:724a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:94c6:b0:bd5:27b7:adaf with SMTP id a640c23a62f3a-bf372933d1emr494159766b.33.1780792255269;
 Sat, 06 Jun 2026 17:30:55 -0700 (PDT)
Date: Sun, 07 Jun 2026 00:30:54 +0000
In-Reply-To: <CAEvNRgEQ8SbqOL3yAri2NO7BoPd=-tqura9O5MKq57m1OLwkGw@mail.gmail.com>
Mime-Version: 1.0
References: <cover.1779080766.git.tarunsahu@google.com> <9huzwlwnbgdd.fsf@tarunix.c.googlers.com>
 <ahmbVaCUcBrYK8qO@google.com> <CAEvNRgHsJbGz8k8vgCn_HSxeeQ8agEm4oBYQQ0+b3gFb-aVokg@mail.gmail.com>
 <9huz33z06bu1.fsf@tarunix.c.googlers.com> <CAEvNRgEQ8SbqOL3yAri2NO7BoPd=-tqura9O5MKq57m1OLwkGw@mail.gmail.com>
Message-ID: <9huzldcrxkch.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v1 0/8] liveupdate: kvm: Guest_memfd preservation
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>
Cc: axelrasmussen@google.com, mark.rutland@arm.com, skhawaja@google.com, 
	Mike Rapoport <rppt@kernel.org>, sagis@google.com, Jason Gunthorpe <jgg@ziepe.ca>, 
	Shuah Khan <shuah@kernel.org>, corbet@lwn.net, dmatlack@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, vannapurve@google.com, 
	Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, aneesh.kumar@kernel.org, 
	vipinsh@google.com, Alexander Graf <graf@amazon.com>, David Hildenbrand <david@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6BFEB40005
X-Stat-Signature: dmdqeb9wiq9q7rzrok5rmd9io9ggo8o9
X-HE-Tag: 1780792257-581740
X-HE-Meta: U2FsdGVkX1/y3btbJNqdruxGGkDznuYEIbDk28NOCqoMeR1X/VBx0vB4PIjlhZXyGO1XYXWaODH+ps+QFui615LIlG4CNBEdLQhQkxmewBXIjMDOvTzYwXowNegp8B6d2Ch4zcvs/SpD2ATRGHb//bakP5hGvHmNwI+Z0/eSUvaI9o4tsTw9xADzeR9WhFn3dqtHA3KGKWOcRbA0xHsiDn0v0YbobKA5VtuaxD5/5nOF9HAHk+OXVhqEw0mBrBYh9nZugZrycjPkv+618efkE2b/zR7JtuSSGTkW8M96uROCtMKEdUSwOJ1H4/DT86NYUSY3GPGv3pqdsIRSSiXa5yoVgLCjABKyRHJMX4QXUB7wgM5wMQZ1LR/+0IlUnIaHxfcP0iMUEhVXlC47ylE4btNugjS3fLhUyCOgs/B7z9Zom7g94x+s2EiLPNtIV/chXQiemoqxDWZ91tAQcWgRcP/M2A/K4wpqWOBzK+oTiiMQkA1CZxDZX/jHGC4qCIlivkbVkI83AX7D1w4nb7Bq1or/IT4foNCngzf5kgwH8npIFNuf/siuu7/P9eVA6nq+hdzSbY8ARu61a0FsgdQaxYh2iPrXGoXvWQgifdet7+31ehn1p8hhZ1dM1jMXlEoEf21LzPi7AV6zlzYJwZtD9pXXEWwHpGa4SJo7Fc2tnmQS5GEcEADOrlbycZSPFC53YjhHS6B+FZ0EH/Wx/JKNKo5yN+gEtRLUbQSwxFjkB9UVhrIlB/VRT9kkebaSyLT7W7AvlH6jBGYl2QfOfchwFHsGnRTB7xDlFA429fzswuK4X9p+p/Eqg/wzsRyL6MVd07W1qNwEULx3WGzQHdJJb91iW0KQi6Zb8h6slNBnAvFNCbiLeEK719+TZmuhbmVcVQCzB4poDCMcyRz5nf+hySeDbjrvWwVGOnFDM+94lr5K5/SrPGc2ZQJ32LYQs2zqFTyGUQGodZfdxtdTtEp
 mz+NoSkl
 rON6iCok3PBzXDnMYZJBylahhWdNuerylEfSKDfCQab62dggkUB6ob9mlVKtZLq75a+iahMUHBdC2THbTeO6rU7r5sqEuZPBcpIuvWAxARzYfSBzLPJOvHPLFDADj0uvR1Pv2MxYR2xEONhD3jruCmfuNFmDc1//Rx4pzfsOA1DsKedfHmxrKJH7ad7KEo+xvBUw7TXRxtQHVUH4TfQnTSr0+ecuT9jgVS/+JKiFmSHBz3a4HpSoilorbafAlifaCqwZN5fMEmYZIByNp0h3sZZBk0aK0hkPhCkNdX6lbxSRr3E5e4yeOk4B4lgJGvo9t3eaiNp0aRMXj7MTvUyKbZvMH8HDTYtbdaqkwhAZFxMoLrznUiXh3PIvXQg9SyLhw1XKxQQx2i5QU5Mav7eGKdCB+puKZqJ6DTI3ttqAyW9X27Hu6b3xtK5cAY8r2NKhleUxrXK7668IVfF8usejk6zZnuIDOD0+q9/5EDN9iJzR/+3FeIFeNlOJ9KEQwp8+TQ6A0fPMpHF22b87gPfw2IgZ2HlSB3fvJ7c+W3mK6cNdsGkKiq00SrXos1KfIU3+bPdc/kjBVg+3O3ksTgzK7TndQvQMuRjuN/gr3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi,

Ackerley Tng <ackerleytng@google.com> writes:

> tarunsahu@google.com writes:
>
>> Hi,
>>
>> Ackerley Tng <ackerleytng@google.com> writes:
>>
>>> Sean Christopherson <seanjc@google.com> writes:
>>>
>>>>>
>>>>> [...snip...]
>>>>>
>>>>> we have one open Question left:
>>>>> 1. How to check guest_memfd is fully shared.
>>>>>
>>>>> [...snip...]
>>>>>
>>>>
>>>> Given that lack of support isn't going to be limited to _just_ guest_memfd,
>>>> simply disallow preservation if the VM supports private memory:
>>>>
>>>> 	if (kvm_arch_has_private_mem(kvm))
>>>> 		return -EOPNOTSUPP;
>>>
>> This is a good idea, I have implemented it in V2 (sent it recently).
>>
>
> Will look at RFC v2 in a bit :) Thanks!
>
Thankyou.

>> Below, I have mentioned a detailed analysis. Please let me know your thoughts.
>>
>>> Makes sense. Tarun this was the other option that I was suggesting when
>>> we discussed offline.
>>>
>>> I think (?) it is possible to create a fully-private guest_memfd for a
>>> non-Confidential VM, and even after conversion lands, for both
>>> vm_memory_attributes=true and vm_memory_attributes=false.
>>>
>>> In that case, your preservation series can still preserve memory tracked
>>> as private by guest_memfd but not used as private, right?
>>>
>>> I don't think anyone will use this combination before guest_memfd
>>> write() support lands, we just need to make sure there's no kernel crash
>>> or corruption in this case.
>>
>> IIUC, currently, private memory definition is where cocovm with HW based
>> private memory is supported. Which is directly checked by
>> kvm_arch_has_private_mem and this return false incase ARCH does not
>> support it in HW (SEV/SNP, TDX).
>>
>> So about the combination where a guest_memfd is tracked as private but
>> not actually private. (Created without the INIT_SHARED flags). Even
>> though kvm_arch_has_private_mem is false.
>>
>> In this case the luo will preserve the guest_memfd. But it will not
>> preserve any attributes, because
>> 1. during creation, we dont populate any attributes, so by default
>> guest_memfd memory always considered to be shared. (Even though no
>> INIT_SHARED is passed). Conversion to private IOCTL will fail as
>> kvm_arch_has_private_mem check will fail for non-COCOVM.
>> for COCOVM,
>> presevation will not be supported and conversion to private memory will
>> be succeded. (No corruption and kernel crash in this case)
>>
>>
>> ==== WHAT IF CONVERSION SERIES LANDS =========
>>
>
> I think there are quite many cases to consider if we consider both
> before and after conversion series lands. For preservation, shall we
> assume it will go after conversion? :) This way we can avoid discussing
> some cases.
>

No, I dont prefer to make any assumption and try to make both the series
independent of each other. Landing any of the series first should not
break another. I am keeping this goal.

>> In this case, we have two scenerio
>> 1. kvm->attributes
>>    In this case, Every logic remains same as above.
>
> This is the vm_memory_attributes=true case.
>
> Since kvm_supported_mem_attributes(kvm) returns 0 when
> kvm_arch_has_private_mem(kvm) returns false, the vm's mem_attr_array
> will always say shared for any vm where kvm_arch_has_private_mem() is
> false.
>
> So yup, preservation doesn't preserve attributes but that's also
> effectively preserving always-shared attributes, so all is good.
>
>> 2. gmem->attributes
>>    if INIT_SHARED: memory is initially shared and no entry in maple tree, and if
>>    kvm_arch_has_private_mem returns false (non-COCOVM), this will just
>>    fails any conversion request. hence preserving the guest_memfd wont
>>    have any problem (fully shared case).
>>
>
> Yup, preservation doesn't preserve attributes but that's also
> effectively preserving always-shared attributes, so all is good.
>
>>    if INIT_SHARED not set: memory is initially private, and there is an
>>    entry in maple tree, marked the memory as private. During conversion:
>>    A. To private: it fails as kvm_arch_has_private_mem return false.
>>                   Preservation is safe and there will be no problem. as in preservation
>>                   we dont preserve any attributes, but on retrieval, when a new gmem
>>                   file is created, identical entry to attributes will also be assigned
>>                   as INIT_SHARED flag is not set. So we wont have any issues in this case.
>>    B. TO shared: it passes, and update the maple tree. preservation will
>>    not be preserving the attributes with current patches, and it will
>>    also allow the preservation as kvm_arch_has_private_mem is false. So
>>    in this case, on retrieval, we will lose the data regarding the
>>    private vs shared (non-cocovm). So if host want to access the shared
>>    memory, it will try MMAP and which will fail in new kernel (which was
>>    successful in old kernel as conversion happened). But I dont see any
>>    kernel crash or corruption.
>
> Perhaps it should be this way: the process of preserving should first
> freeze further conversions, then check for private/shared status, and if
> private, return error to userspace.
>
> I haven't looked at RFC v2 yet, but IIUC this is kind of in line with
> the other issue where we freeze allocations:
>
> + When preserving, freeze further allocations, preserve all pages that
>   are already allocated. If there are pages that weren't allocated, too
>   bad - allocations are frozen until unpreserve.
> + When preserving, freeze further conversions, preserve all shared
>   pages. If there are private pages, fail preservation.
>
For this series, I am strictly focusing on fully shared guest_memfd. And
any guest_memfd that supports or will support conversion to private will
not be allowed for preservation with this series.

Freezing the conversion, is requirement for guest_memfd that will
support private mapping. At this point I dont want to include this in
this base support. We will look on this when we will work on
preservation of private mapping.

> This way, there's no loss of any private/shared state, since only shared
> pages are preserved.
>
>>    This is an issue with only non-cocoVM support with conversion series
>>    having the gmem attribute enabled without INIT_SHARED flag. I am not
>>    sure, if there will be any user for this very soon (is it SW_PROTECTED_VM ?? ).
>>
>
> So if a non-CoCo VM does use an all-private guest_memfd (didn't specify
> INIT_SHARED) (don't think anyone will use this before guest_memfd
> write() support), it'll just always fail preservation unless before
> preserving everything was converted to shared.
>

yes, Also
We will never know if everything is converted to shared unless we walk
the maple tree, But for this base support, we dont want to depend on
conversion series, So depending on INIT_SHARED flag along with
kvm_arch_has_private_mem check makes this series immune to conversion series,
INIT_SHARED makes the initial mapping shared, and
kvm_arch_has_private_mem avoid any further conversion which is also true
before and after conversion series.

WDYT? V2 does not have INIT_SHARED check, it has only
kvm_arch_has_private_mem. I can comment there to be updated in next
version, if we are aligned on this.

Thanks.

