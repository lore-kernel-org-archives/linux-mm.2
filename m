Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FFCC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 22:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E19E76B0352; Thu, 24 Jul 2025 18:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1AF6B0353; Thu, 24 Jul 2025 18:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2F416B0354; Thu, 24 Jul 2025 18:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C29846B0352
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:44:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F8E9160565
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:44:50 +0000 (UTC)
X-FDA: 83700639540.16.F96E854
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 876B912000A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:44:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DylumOjE;
	spf=pass (imf29.hostedemail.com: domain of 3X7eCaAYKCCQSEANJCGOOGLE.COMLINUX-MMKVACK.ORG@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3X7eCaAYKCCQSEANJCGOOGLE.COMLINUX-MMKVACK.ORG@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753397088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrK1nEYl8f9oxCi1PiXZSrMC6WHPAwC1TRayidWzx6U=;
	b=wVpoTkRek8vhelTLE3Gck0j/p9Nk944EX29F1GYYMrSEmYFQhDeo2PXxt26RtHnXmp8etj
	EF9k33GO6qo8H5wIVwNGPdKadlIRxjnknkXIcDnclNeV75IqQaMp3QPzQvn6CCQeAr/qk3
	VTUtvlJy9JmtbMwe0J19+3m+/nYzys4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753397088; a=rsa-sha256;
	cv=none;
	b=NcBlLXIxMnWM0Cx1HE7Ko1IodBJfo7ko7cQp+iUeZZyv7LJr6WNbHXx2z1vW+IxYPrsXjP
	CJ6iCUkM0+W7Stdy3Lr6g/1EgSLhyLpuwyHOA/DLYkweYkTcx3ChKfxx4FK/w0iP5YDdsq
	LVSEO36XNEWYhzMAs3WwBg52f34KASE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DylumOjE;
	spf=pass (imf29.hostedemail.com: domain of 3X7eCaAYKCCQSEANJCGOOGLE.COMLINUX-MMKVACK.ORG@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3X7eCaAYKCCQSEANJCGOOGLE.COMLINUX-MMKVACK.ORG@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31e3d563a53so2101757a91.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753397087; x=1754001887; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BrK1nEYl8f9oxCi1PiXZSrMC6WHPAwC1TRayidWzx6U=;
        b=DylumOjEaGcdJEmO14U6LvcIOlEvEBNpedVGYdae8jRKIYx90VpsCFv3iJpZWs+Tdy
         U/fSS4iQOJjBwtYtE9XwtA40UNrgfit0GxpKnJES+wrTCSjOWaCVKqFdcD6z7ljLqhPd
         1cC4zAZMq1+ZDNQ3rcGkQbvY9pOockr+HhJNdc8hJC5CwOzE1hbLozHYS+zMvOOSw0Kv
         FJjD+WAgrjNhctYeo9pXceBnk2aP+A1w9PcfdYAMQEqUgPeSmQBFGIj6/8NkCo7ZfbJz
         0/kqv5n0lT2jS7npv3QU+Pp0ABQgKRjeIYkcv6GtV5qyJPg/OHF591WZ1D2gdBLCpZJj
         gkBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753397087; x=1754001887;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BrK1nEYl8f9oxCi1PiXZSrMC6WHPAwC1TRayidWzx6U=;
        b=j2fvP7CGG3RlZIG/sdXrsleqYjfj3FNRTf9soeRgtaJFNpcZeVSoR+YrhiC4IlNOcO
         c2lkIAgbrYT4dHDRrQTBc5ZVTAClqVoHRwZwAoB5UDRpsPmrNmaWPKBYZhCjNrVMR1Q5
         d4WzcTcnjoJDRr4S1k/xafjSXaDxx1D8tmiW2DnoR/4bNQi+5DbMfwBCp/vsBi4sdXGX
         pfdEXhTQ00Fj7WmQaIoxVG89//tURTezTX5quH5+HagkkTBrF4siY6V3WFQ+fGVlcptb
         i7UDaSGs6yQtj0k8lfnMPJfpBURBAfK87Ily3pMri7O821vYDCvlmX7JrCNXqCtnQjUs
         Iesw==
X-Forwarded-Encrypted: i=1; AJvYcCWjYOXaizTBh3dImcbTsmxI9hqaL/HUYTMwyhX0+YLu8mQUhOYqmhEpoi1F6VfmhA7nIHlIzF3Nhg==@kvack.org
X-Gm-Message-State: AOJu0Yz17zGrEP49dY1bVyKVeqNCSz20yoZjiWs8Tm6r5vLIpkKKnFGQ
	vJfor6AE3sd5W+ZDlWZHjmGPCFl31i9Iu5t+IfIG6F3Hl4NCScbmbgoYoq/aGE97EkGm3a4emeZ
	2YTiARQ==
X-Google-Smtp-Source: AGHT+IGkiU3HYlKz/oDr9suUmMNrF5QXoOj0MoEs/x9E0W6ja+0hEb122R/Wpx0j3kxF2BD1pc55AGtEMgQ=
X-Received: from pjz5.prod.google.com ([2002:a17:90b:56c5:b0:31c:4c97:bf9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3809:b0:31e:4e36:bfcf
 with SMTP id 98e67ed59e1d1-31e507e729bmr10178567a91.30.1753397087358; Thu, 24
 Jul 2025 15:44:47 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:44:45 -0700
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
Message-ID: <aIK3XQ6rGEo4cQ4V@google.com>
Subject: Re: [PATCH v16 00/22] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 876B912000A
X-Stat-Signature: yd5goa5rensmge8qdofuygi4sjckohpa
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753397088-726292
X-HE-Meta: U2FsdGVkX1+xXovbrcbChXlYNPp97bgL5nGrUlZGafTd2UEHAavbgTN+fMfZI7z/lVO0EFO0mlsmRyw5jOK8py8ujj2HukDU4P9TBWfRm9B0TxpiUUc/OIPiWzzOWGRPaFgzXvnAWc3VfdleuLrPyy/pt8kpjIBhqOR+ZV6ni0+kr6PW/UK8TkxLkAqObpOeBMBXPRXXit2a5D8swBYvKqPpzZ9o3WSEbtVnqKFsMNO0CyyEuv7Dt45P3fHbOpYOLgpewnDrce7+gX9zJrK0NzQFWrFUYu5KhQjt182eLLkDimy9cyuvJsC5Ox+ZJgUhiKAGU+px5E1mp53oCbqtGHnWL0KaOZ0tltJc436to/GYmlPPf1XPGJ7QPpCS1ROizXQ3AJ/h6J88eB2mMCFjicKkbNb98t/xsDCaoIfRQJHiC3A3PIXIvnlc9HhnIpKJGfRPRJBe4qIKQGpu8rz/IocmafUMu1MMLiZ3RnBnF/45OIK/58zCCWSM14oKLOk6QuoHXQSFPKLsifFB/UjZmbkCPg4BOABfHnihc8b/og/c7IYnST6by7RwrYhYYrkm8aGahHjzOhW/K3scuD+NopUi9I7gETyyWS4TjhMBwoyiaKl5iLvBnRGb4doJ53w+/6HC68DormToYbQk2Bb3sps0I1MJmjG3dEoLkwFtHwTTqW47IH0oZvDNbNe09ZCLFQDjOhMe4h7UUrYNCMuu2B+GuojXZALgcQmoxSQAD/iKZ/wLrX58L0UVU1UMqzFlJEqk/7xxgNeaqUoEPIW/AUMXbded34Ih1RsLNCxzfIveVpZOylAYVopuYbug2vEig4NoyUKELlFrzmGjQmah0ZtOAx2sPvWGef0cFvmaDzACDH25BmKt4VFXdNakpD6qLlUjRBLw9i6eDv0XuxKQQawpSW8MdL3fQDWHtzcN84NEAqAYMVSJnp2UNF3FLjbC2PxLuYPH4MbiCA9uzxE
 LTAH7Z7E
 pTV9FSHWgdE/gyGnPOhbw6Of/k7YrSXEMCsBYE29i3Y31brOBaSK1VP9Imi/szqLm4nSZHJuOfBr+Qar/Vsa2LZrc3bqKG8ibk6NRnJi7lPh09nhMs0iNOjvoCJvopARTj7K0bWHx69DpFLGpDGUDALi0Sc+ceTvsWT12xf6WGXWJFNr76FBa6lLs3L62WcnMT19Ng0218ABQ1WNvWdtcmpijLSvKSgEZer0oZ+so9DdSxGZ37f0BxoP0RYU0jeD6FaoebXbvdUdW7fNhg1hwGjtQYt9FKCyB56GupP8MDAfnypFxjra4ExOf57vn+nqFLutH9JY/C6KtLWYhtIj2b0iCPaPHiQ9DkfttyfZXQsKmnPucb4RD0verftRmGo8p28dMmqTD6MG0wzzsrx+wkypOU7Y8e+Nl3zDWS3+czpeEbU+2PtkX34PaXtuUKWxaFhtVx7tO0fyimC2DwkDgODWlLfx+dL2pDMa4faSTjEgUtcjzan5NDAHsSUPDWI21CCmTe2U2RYP28nm9R0hrEkZV28MbxFhg8o9tsvySV9Yvo/q/GbvKRYn4lDR7AaqQfjp+6GS1dswy+ucsHdwuHQknHlqg80bCSNAnjKlUzuniRq1YQGq1+DWmTnHIUKCqJ3hPv9HjsU2i8f/NmFT7Yx5wo/X7aip2wU4jSjogt0nHqoPPKTRPpfsIwsBcpCQ0SPqWf82k5Z+GTcI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025, Fuad Tabba wrote:
> Ackerley Tng (1):
>   KVM: x86/mmu: Rename .private_max_mapping_level() to
>     .gmem_max_mapping_level()
> 
> Fuad Tabba (15):
>   KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GUEST_MEMFD
>   KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
>     CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>   KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
>   KVM: Fix comments that refer to slots_lock
>   KVM: Fix comment that refers to kvm uapi header path
>   KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds
>   KVM: guest_memfd: Add plumbing to host to map guest_memfd pages
>   KVM: guest_memfd: Track guest_memfd mmap support in memslot
>   KVM: arm64: Refactor user_mem_abort()
>   KVM: arm64: Handle guest_memfd-backed guest page faults
>   KVM: arm64: nv: Handle VNCR_EL2-triggered faults backed by guest_memfd
>   KVM: arm64: Enable support for guest_memfd backed memory
>   KVM: Allow and advertise support for host mmap() on guest_memfd files
>   KVM: selftests: Do not use hardcoded page sizes in guest_memfd test
>   KVM: selftests: guest_memfd mmap() test when mmap is supported
> 
> Sean Christopherson (6):
>   KVM: x86: Have all vendor neutral sub-configs depend on KVM_X86, not
>     just KVM
>   KVM: x86: Select KVM_GENERIC_PRIVATE_MEM directly from
>     KVM_SW_PROTECTED_VM
>   KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies iff
>     CONFIG_KVM_INTEL_TDX=y
>   KVM: x86/mmu: Hoist guest_memfd max level/order helpers "up" in mmu.c
>   KVM: x86/mmu: Enforce guest_memfd's max order when recovering
>     hugepages
>   KVM: x86/mmu: Extend guest_memfd's max mapping level to shared
>     mappings

AFAICT, I've run out of things to complain about. :-D

I say wait one more day just in case the peanut gallery comes alive, then spin a
hopefully-final v17 early next week.  Or holler if you want me to tidy things up
and send v17, most of the goofs that necessitate v17 are mine :-)

