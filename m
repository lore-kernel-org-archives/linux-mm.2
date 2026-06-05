Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F151CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 20:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839076B0005; Fri,  5 Jun 2026 16:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA436B0088; Fri,  5 Jun 2026 16:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B15F6B008C; Fri,  5 Jun 2026 16:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57B686B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:05:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E98F8A02C1
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:05:07 +0000 (UTC)
X-FDA: 84846937854.07.A0F2B8D
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id DC9491C000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:05:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rcf139bX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780689906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETQ/gp71oQXS00v/q0CniX+rY+uk3xd7pEHCdqYInDI=;
	b=ZwnG9yNgryVVtJCR9nhMUpmrEOIsMEJrF5IwmVyDIyEshPN4IohZ9TJYZulJlU6CQ9rh7Q
	mrphAGtAtL1rjy0pMEkHia64HCD5N+v1j9CRMfgDa7jCw7U2RZlDWnfxWTRKUhLqOTWGbL
	xQ2vvvs/xkZ91gnUWR+0vcqlAN2p8/M=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rcf139bX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780689906;
	b=7vvtZmN9ux7NYkUKgLqjap6M+9NBRH7f1NdMstF0Ea1b+WbhtXFeIf7X4IybnZNpdxdtsO
	z65xruygflr/UcP1i7+33BseDMlkEigJq2I3pA5TAsUFG/IL8/8T0skMbXW3sLKS88l6b/
	Xl7/i+ytbQ/bLMHif6T4A+0ejPT0vgE=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-13810b63a1aso1180631c88.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 13:05:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780689904; cv=none;
        d=google.com; s=arc-20240605;
        b=VP67PD6j0Q3gQDb6pZcaPp8hsVgy3aHONIBjSgvMFyKPVk1S6DvkDp/GZXHyhEqM0g
         nBUaeQUSbexcyEnizOKppKU/o3axvQunmZV6o2pyt8O6zoeD7qxDrx4J5ImjkAGFDCJb
         lyHDBqbhLtpntVJ7zz2HKxD+BwkQkJNHIfCbMjtInpcn2ZK1Z6WKYX6W9FmL8spRUD+W
         qZP9A7abe+UMZYLOfbJmi7/4l+s5eBBinxIHz2QV4ClzCbCozf1xwfMswC7sKmSsWyTH
         dDZIA8gqFmqDc6DqUk/ZTwG4BaSlSBu6b7DfMUiB0smNEGvJCRmQeLtKGJgipWf1JcvT
         hMRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=ETQ/gp71oQXS00v/q0CniX+rY+uk3xd7pEHCdqYInDI=;
        fh=9ssZfOHyJbuBsJBHdc6+O9JOT2+tv9oCoP/osyeD5UI=;
        b=QAy1gAcv9iQbe/cnM4R1zvRjB1LhmocVx7S5Mr5PcwXRAF6qObQJ6fQg0GpVWipOMw
         s3RX4J0OglqgvHSm8Dxa+DaVUpWpywgp71cMsvfINV4XyuJuNf1HQV9UUub0jm7g+CnH
         7soVQfBMwbYgeAp3GRUVWU1FcmZAvlaM70NS/Nb54PsdBjxAKcB0BaY0fnBfqiyto0fW
         FZh4zTvjtAfiRFqX2sEfrIT6tHTjaaxKPGDpLLe6ufE5gsFS19B3yAfLwrPUMEvmj6ZM
         3ck+pi3V9fwixFQ2taknkjDf9VH9rFS6DHgI107SMKPWxxPnesioxRDB65zOOALREOT5
         OH6Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780689904; x=1781294704; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ETQ/gp71oQXS00v/q0CniX+rY+uk3xd7pEHCdqYInDI=;
        b=rcf139bXpQMf483bgRYhVXFwGhJ/15XT/efy+uFDfDE6yC1GS/BY/q+AHIAUoXL6PS
         p6zwT5uzfDMgCQgReqtaFaua7R1f2fJC7I476A+c41ZyAScBC76KghIhYNuYa+XBLzyV
         8iHUKbUaMe4hCg03hQhYa3hormMqzHgX9WTtAQCeEYO0MNvNjdO9B8d2DGbzF65wsXhD
         fYaR4NERvKhRolBUnNB0xKPu3IcUmsUl8Lx5OrSI5TcFjgPiIFyaVcKcmTj/8cdQcSWm
         9TiOq0E46X44heh7BeNHpHBk8gs+gvSPMHOmHPCkW2wJcHQJNH28ETitIMvSFnucmCpz
         UMGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780689904; x=1781294704;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ETQ/gp71oQXS00v/q0CniX+rY+uk3xd7pEHCdqYInDI=;
        b=XN72TmZuDjLRcUQ3tvY82aOV/p9zyv7vBRyZFSAaQLR3wtZc4IG+HsD3vaffFGqsMi
         N1WYJgiSRU0HQbiMv1l3aqdPeKr4T9HFMp7ZGxuDYwxqmzO7kDuHnbGO9vRQFaCaFCW7
         HViEGmMPGBtgep0IabvVeClEC0/aNKRjFTMPW5TebVgeUmpnKZPf9NPnnVa9c9gR6Wcn
         WGsRYbcWUPkTks+iJSur0/1BS05iEO8V8Jgx4EbKEaWrItPSoyj+qOEYCFiT71XLyst/
         YCTPzR1Pr6hW+FDDxEKMLsK2ztKwm+ZBkudQUhUGRAV0cG/wCfctNb67sIVBfZZJ7rbO
         ZPzQ==
X-Forwarded-Encrypted: i=1; AFNElJ9/oKiKD0kbyKqsfYbxdIE1YAbK3Tsud04GNPwIaF42tr1xrcpANziTFqnozzL9QwIMdClk3yUVPA==@kvack.org
X-Gm-Message-State: AOJu0YwDmgA0zdoqmh5MNeOwoR/9SHshFCujdS9qKwTPYqKuGwx/sx3Z
	NG9wdcMxaS4U2fmyK0qWtfi+gfKw5soZZ61VuUdxSeb/qQZnnDGwDqz44aI/bm8jhTP7oUUeQTJ
	YihiLkcPTo+cuY+XKBW00NBi589xlZHu//uag2VJ7
X-Gm-Gg: Acq92OFrAJHXj/fxKeoAj1iZi3sbU1K+evhcimKsSvdHX9UvK3TUKzkcVrsdWuWERom
	oT7X3k9byuE5ZN1QPvm5bl4nDheyLQPpRNEmM+fiHVg4Svj+2vOhDH8ErSbxtUmWq/23R/LBPvD
	aeDwTX+NpU+klFDcPQn/bQGen/63wNwpicIm3gVQREHiRVch9amTwIVIOiar19WB/Ye9kCTrD5V
	clY4CFzX/Ceq9D9nLXuZ7e6mC/tl0zcP7rb6RGyb8i1M6k2rmRq3a9SGK+UbHjK4Lpv/JNEik7Q
	vtt/9/WEJbn6TqffTZPkHYWXaDkDFzwlJ3KUkEJoXkfvDK6jwuBNdnuCo2mHAO1fChQ7RQAugRZ
	JlZFx
X-Received: by 2002:a05:7022:6a6:b0:137:8921:4fe1 with SMTP id
 a92af1059eb24-1380674296dmr2844699c88.37.1780689903477; Fri, 05 Jun 2026
 13:05:03 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 5 Jun 2026 13:05:02 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 5 Jun 2026 13:05:02 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <9huz33z06bu1.fsf@tarunix.c.googlers.com>
References: <cover.1779080766.git.tarunsahu@google.com> <9huzwlwnbgdd.fsf@tarunix.c.googlers.com>
 <ahmbVaCUcBrYK8qO@google.com> <CAEvNRgHsJbGz8k8vgCn_HSxeeQ8agEm4oBYQQ0+b3gFb-aVokg@mail.gmail.com>
 <9huz33z06bu1.fsf@tarunix.c.googlers.com>
MIME-Version: 1.0
Date: Fri, 5 Jun 2026 13:05:02 -0700
X-Gm-Features: AVHnY4L2Vz8Me8pcWVFAkqKnhq9-w0SZ89mR2JAxVASVs_8LCadd0XSvG-O3nmY
Message-ID: <CAEvNRgEQ8SbqOL3yAri2NO7BoPd=-tqura9O5MKq57m1OLwkGw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/8] liveupdate: kvm: Guest_memfd preservation
To: tarunsahu@google.com, Sean Christopherson <seanjc@google.com>
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
X-Rspamd-Queue-Id: DC9491C000C
X-Rspam-User: 
X-Stat-Signature: bciii8tycryzsa8dzg7i6gjti377zq9k
X-Rspamd-Server: rspam09
X-HE-Tag: 1780689905-170504
X-HE-Meta: U2FsdGVkX1/dTeRrYJfQJvBE1oSJh6cBY+XuX0YrQDJfrOZj+LqKMyfDLIvXBygUYp9XlnIjbdw9XtJCLvcVguMLV2apbEF/SKaqUzJXvs4ftZJedJlBGIhI7C5Wm5KSHcOvLoFwmsYqe7gvo0JAzPhAj+KL2MjJ6ciYP10ZwIBIeI4jjE84eypFxejyKblqANVOMCuoqBw7r5wVTg6zkWU5ODT2wwpDLLZ9eCvMPrTaE6Q+vMz6arfTLKdCOO0P9naydJ0jk7z/omRLeszJcTl1HWoQdaEPFXhdweWUG6RUfjT43TGi9JVm0Rr1iCp9pEERytADA/BNvvKfWHCYs6UPiCgjudQBN10tCUaGW+Ph/m0Y3s19JynqEycPhMFua1kV+zBTHwiJR9snKbV16dRD8aqZ/8uuLha9gilS9g0zXSwsg9sAyAzFEwKBIdiQw9XeEKvfFCtdEwIm3lbi/4C5nreDQKrs01D/flkwkLaFgFKHR8yxKc7XD+vYaJ8YC7ybbvqWjkc01zo/NF0ymuSqyO2pqYGh2dM1loToQUXAwiyOx8gnv2JkygKxHdM/gR8dxiaYd4smUgMXAlqSmu4+n57aBGFdMOUun7VInXS8ilYz9ZEuf5tLIhb76sQhN47D/hoOY+PCL/sSTaR1kVkRTjBkmzMlVr6kbxUEp6Gk1agsdRF0BNFx4x3CZp3Mpfa3gf9DBjHzy0CGelxyulwu0UHlA/DFI8qBmeVdtn7TVr+vhJyIetiaDYMLKzV0jaPpz99rkNAQbWW4Q+YXrV9Z5LFjGeKVwghwsXYdCwQplKdEd64W5/L6JmBGRh1dUQ1+JYfQbvKaH9E5VWLQwUF3ig/0WGs19PfIiYKyeayLf1WPtd34qRQf//Bq1US1t6ljc/J5MM/UmxcGk9/1F/srY2CkuFgWHxnwRkLOMLxdfrw/pvT8X8+xGtev4ZJs3Jh1wvqi+mgqCHCof+O
 JBDQry4i
 +gIb2uPE56JcMQ5UAqF5Ne0IplycGyoVkE6bX26jDKgFUsgpNawaHzut2UNv9wCWThycNLThtTPme8iDtMpeovaQQ0r/mG9YqJirn7DRf+BS7QpJuMg0ncWlxqRVDJh1yNnt8FJOnqUV5bwUmLr2SkafXuWLL12gUFHVw/HqnHWqo7QQptqZ9qAje8Q0y3w8WNiklRMRnbI+hmrjr5mSJUa38INATqCnoz56AW1BsK4w+8vLfFFGqa14jBQceMh1n2ZjAevOh/jUVM7Z6SMUIMED3D1fITngU9AfNUxnRwkbtzKkqoHciZg82fN3DLaIXzRYtiMbZrDdwGHj/cIgBYsG8kGREHDGMlhvQQhPpVM+WGY2/teKBY7bqbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tarunsahu@google.com writes:

> Hi,
>
> Ackerley Tng <ackerleytng@google.com> writes:
>
>> Sean Christopherson <seanjc@google.com> writes:
>>
>>>>
>>>> [...snip...]
>>>>
>>>> we have one open Question left:
>>>> 1. How to check guest_memfd is fully shared.
>>>>
>>>> [...snip...]
>>>>
>>>
>>> Given that lack of support isn't going to be limited to _just_ guest_memfd,
>>> simply disallow preservation if the VM supports private memory:
>>>
>>> 	if (kvm_arch_has_private_mem(kvm))
>>> 		return -EOPNOTSUPP;
>>
> This is a good idea, I have implemented it in V2 (sent it recently).
>

Will look at RFC v2 in a bit :) Thanks!

> Below, I have mentioned a detailed analysis. Please let me know your thoughts.
>
>> Makes sense. Tarun this was the other option that I was suggesting when
>> we discussed offline.
>>
>> I think (?) it is possible to create a fully-private guest_memfd for a
>> non-Confidential VM, and even after conversion lands, for both
>> vm_memory_attributes=true and vm_memory_attributes=false.
>>
>> In that case, your preservation series can still preserve memory tracked
>> as private by guest_memfd but not used as private, right?
>>
>> I don't think anyone will use this combination before guest_memfd
>> write() support lands, we just need to make sure there's no kernel crash
>> or corruption in this case.
>
> IIUC, currently, private memory definition is where cocovm with HW based
> private memory is supported. Which is directly checked by
> kvm_arch_has_private_mem and this return false incase ARCH does not
> support it in HW (SEV/SNP, TDX).
>
> So about the combination where a guest_memfd is tracked as private but
> not actually private. (Created without the INIT_SHARED flags). Even
> though kvm_arch_has_private_mem is false.
>
> In this case the luo will preserve the guest_memfd. But it will not
> preserve any attributes, because
> 1. during creation, we dont populate any attributes, so by default
> guest_memfd memory always considered to be shared. (Even though no
> INIT_SHARED is passed). Conversion to private IOCTL will fail as
> kvm_arch_has_private_mem check will fail for non-COCOVM.
> for COCOVM,
> presevation will not be supported and conversion to private memory will
> be succeded. (No corruption and kernel crash in this case)
>
>
> ==== WHAT IF CONVERSION SERIES LANDS =========
>

I think there are quite many cases to consider if we consider both
before and after conversion series lands. For preservation, shall we
assume it will go after conversion? :) This way we can avoid discussing
some cases.

> In this case, we have two scenerio
> 1. kvm->attributes
>    In this case, Every logic remains same as above.

This is the vm_memory_attributes=true case.

Since kvm_supported_mem_attributes(kvm) returns 0 when
kvm_arch_has_private_mem(kvm) returns false, the vm's mem_attr_array
will always say shared for any vm where kvm_arch_has_private_mem() is
false.

So yup, preservation doesn't preserve attributes but that's also
effectively preserving always-shared attributes, so all is good.

> 2. gmem->attributes
>    if INIT_SHARED: memory is initially shared and no entry in maple tree, and if
>    kvm_arch_has_private_mem returns false (non-COCOVM), this will just
>    fails any conversion request. hence preserving the guest_memfd wont
>    have any problem (fully shared case).
>

Yup, preservation doesn't preserve attributes but that's also
effectively preserving always-shared attributes, so all is good.

>    if INIT_SHARED not set: memory is initially private, and there is an
>    entry in maple tree, marked the memory as private. During conversion:
>    A. To private: it fails as kvm_arch_has_private_mem return false.
>                   Preservation is safe and there will be no problem. as in preservation
>                   we dont preserve any attributes, but on retrieval, when a new gmem
>                   file is created, identical entry to attributes will also be assigned
>                   as INIT_SHARED flag is not set. So we wont have any issues in this case.
>    B. TO shared: it passes, and update the maple tree. preservation will
>    not be preserving the attributes with current patches, and it will
>    also allow the preservation as kvm_arch_has_private_mem is false. So
>    in this case, on retrieval, we will lose the data regarding the
>    private vs shared (non-cocovm). So if host want to access the shared
>    memory, it will try MMAP and which will fail in new kernel (which was
>    successful in old kernel as conversion happened). But I dont see any
>    kernel crash or corruption.

Perhaps it should be this way: the process of preserving should first
freeze further conversions, then check for private/shared status, and if
private, return error to userspace.

I haven't looked at RFC v2 yet, but IIUC this is kind of in line with
the other issue where we freeze allocations:

+ When preserving, freeze further allocations, preserve all pages that
  are already allocated. If there are pages that weren't allocated, too
  bad - allocations are frozen until unpreserve.
+ When preserving, freeze further conversions, preserve all shared
  pages. If there are private pages, fail preservation.

This way, there's no loss of any private/shared state, since only shared
pages are preserved.

>    This is an issue with only non-cocoVM support with conversion series
>    having the gmem attribute enabled without INIT_SHARED flag. I am not
>    sure, if there will be any user for this very soon (is it SW_PROTECTED_VM ?? ).
>

So if a non-CoCo VM does use an all-private guest_memfd (didn't specify
INIT_SHARED) (don't think anyone will use this before guest_memfd
write() support), it'll just always fail preservation unless before
preserving everything was converted to shared.

> Let me know, If my understanding is correct. Should we add INIT_SHARED
> along with kvm_arch_has_private_mem check to make Above case 2.B.
> impossible in future for the current support of guest_memfd.

