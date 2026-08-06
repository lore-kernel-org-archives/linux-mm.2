Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E961C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 00:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D89E6B007B; Wed,  5 Aug 2026 20:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888D36B0088; Wed,  5 Aug 2026 20:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751C86B008A; Wed,  5 Aug 2026 20:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00CC86B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 20:43:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FA06C060F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 00:43:54 +0000 (UTC)
X-FDA: 85068997188.26.7A4D1D5
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf30.hostedemail.com (Postfix) with ESMTP id 68D1C80005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 00:43:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VGWOYUVk;
	spf=pass (imf30.hostedemail.com: domain of 3xthzagYKCKETFBOKDHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--seanjc.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3xthzagYKCKETFBOKDHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785977032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GW1XyS3pE1vmBMrFND4uaqlT60WFAOcGNZed7ARn/tI=;
	b=SxxCW1KhsgsuAtxZ5gQQi5ASwL+qCgQyxBhvgPr6vM80B5MbQVa0Gwadg/oaeKVmYiGTb8
	hvzGZda48RCVdhKjyFStlG4eegDyudzpWzF/2CeJr4a+nSx1FYuHnqrhH6i+LjErHWitsE
	9sR4OFo4m/6DvtsOp40oACsQoN/hJEY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785977032;
	b=AaMuRSLZTYVC8V1cwbqNTZrib+VJbDXU5SpwcsgaQysG3l9Z13NeYNc/pe3inJa2L7sEdZ
	2dKxge3qUxTYSxLHywRQ1DDPKfLus0Y87cYjIk8bI92+I+krtPaNEbfRV2nKMHJoPfaYS3
	g2Iqe81usTwfurTjp5xjyPMEWPP16o0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VGWOYUVk;
	spf=pass (imf30.hostedemail.com: domain of 3xthzagYKCKETFBOKDHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--seanjc.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3xthzagYKCKETFBOKDHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so1394037a12.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 17:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785977031; x=1786581831; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GW1XyS3pE1vmBMrFND4uaqlT60WFAOcGNZed7ARn/tI=;
        b=VGWOYUVkTdb1I6+H0jbByoB4akqmmDAus00OwsXgFQhOWLefXmWCVAdpX3I6u9Rydn
         i2PGRyRS8nTBhRgmw8I2ai3a4ENRhtbF+Qq/gpOE4TcXpxx+ZktqGMZLCrixhrAFivlD
         1xCRIBHcpyY5hUgwc3l/XFeDMByC9HRyN7agdqYHLFJetqH6H4JGT4JuKxbg2sJRfykW
         b6N4Puo2n756DfYpLXWYrNVIDUeVf9g5S19anbXHZR23H+1p+R4IgmaiaC8ldJsrUg9q
         r2Nk3lGamxTCUiHLIR+jlNtGqek0zI1BLXaaUSeSQWjAD99c0/xwObtozD7wybCH/5Ee
         +hJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785977031; x=1786581831;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GW1XyS3pE1vmBMrFND4uaqlT60WFAOcGNZed7ARn/tI=;
        b=RpOXADTWCufVUOFDhnTI4TbG4YuUk7iMC1XvruJ6/JGh/0gVWpEiHuC0Zl095fh8TY
         NOwNVyVyVyQadpHItbZo/bu3zWvn8dCnqqJ65YqZ6MvxEPZkyMoRFoJC+6B9VDzWxkfr
         pYhkoX5jyGSuttpmBXXQsX9a4Lav7azjOkN0nfsCTc7ht+1QM6KH3xheZwg43HJ6Tkab
         n2s3eAJaS0To3Y6U2LWjmz/ffo8rXMRA9YHrI+KQ8y86y7NUQdv24lZFu8CLOB9mO+PQ
         OIYYjQHCSUWSIwm0ma8g6kHrNHsOiEDwwP2WWgzCgRaXELgqghbYM1TmVZLhSo1iZbwe
         8Btw==
X-Forwarded-Encrypted: i=1; AHgh+RrqZEEv57cG7yNSzIgrTYgZZfHs6e59i6hE6qUyy2a6SE6bT64Xz6yZFErkwHSEhxVoKqBgFw1Miw==@kvack.org
X-Gm-Message-State: AOJu0Yz4bfdfUDxTzN1bHdaPBX7+YY9PoqaXcmlxGfkMpxJe9lmLIA21
	ybTdUCFJToJG5WApxv4yNFlv7G69EwrOBGS+BjJSGm2d6KHiW4+TnoeBzOZ77Fl5Lzt1mxxSXZD
	AWVx3oA==
X-Received: from pgki21.prod.google.com ([2002:a63:e455:0:b0:c9e:9c6:a85e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6112:b0:3b4:e4f6:4f15
 with SMTP id adf61e73a8af0-3cb85e9922cmr13235742637.5.1785977030773; Wed, 05
 Aug 2026 17:43:50 -0700 (PDT)
Date: Wed, 5 Aug 2026 17:43:50 -0700
In-Reply-To: <b9ad1a1d-c167-4adb-980b-90096515a363@intel.com>
Mime-Version: 1.0
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-3-35f9aec2aed2@google.com>
 <7dafaa90-f3d4-4be4-a5cc-472163f18040@intel.com> <CAEvNRgG3qXrG2ix2MEcyVo0GXaen-Pte4gFAwEN+9AY=VtGU5w@mail.gmail.com>
 <b9ad1a1d-c167-4adb-980b-90096515a363@intel.com>
Message-ID: <anPYxp-LMWaLDbMk@google.com>
Subject: Re: [PATCH v9 03/41] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 68D1C80005
X-Rspam-User: 
X-Stat-Signature: j67io93saqq4i7ikhx4s1ijy8qsfsgwc
X-HE-Tag: 1785977032-988461
X-HE-Meta: U2FsdGVkX1+HYlMbQw6Stdum8P/1Lhf/ZoTycQmiBOMrAwSrACiO/r6fHOE8SP3cITF7LKG0u6rpGllthITMuxtfpfLqJeqvDHyQUX/ur1pkYqWUtt2vi9DFIAt8i7awTtppz/UqPCeAKM0WprFOk1oGvwLbrduD8yF7J4rYB474MImhC90HR3e38uVOKU00ClpFRfOEUEES+GZNvbJJcQqikRkG7fQyetaq832gxHSu7mIfv1GzGc6Q/kSdJZjrjIOvgrhU5z1quGsRlYzeCGqWrj9vFRKhMvm6C8967kCxELnpnAs8s4RCzLGbK0kB8P5mGAzwAljVZw3LjeRUc5GF/o1FiL/Y5kNsjZuy9MvD8s+G9EovT08RpgLx5U0rkgJg/Mu7nBTQ5yW5duw660+RlpHMyt941Kdy57Zhrhl8xi4C0NKPhxKfHxbaddLwhepdAZCDBJgZw92MobVuA17rW7yYq+RW3f9b0j6hxlrkFWkQdVtVjm5Qa9jmiaPlu/19luO5xax6ZbfrWGhu1Hg1s66jmlnvFfMsxJdmF0UCU7Zi9m8WTj4DTJzC2uVS4OqYdTOSj+iYR+bimXSLXe5cjNk2UoGIw2G11QOQyEMOPIXDDs7xqK1IlLT4ENIVUopC0GFxCWY0qLzDPpghL/2Ku1dZciGK4UK+ADioZIU8FhkzI65yhXtP0m9IXGnI52JdhylWt/0CYPlogyQLh8M65T+4Cx+Tc6e0SqJ0MeMPrvFPuts8ElXoIrGHlcgzISguH9Fhdpakv3c86xGh1xzbS5N0SwhENNoYp+7kALGxnZaIQhHVpjHxDZHE/WUgC6FwUtnEag7X7iqTKHX/oX/9kDglzt2ekN4z0VsiXALoJzUURydtXEf8wAX/qsUaxiyH/xb6/B6r1XdmHMVgfR6dU0u8cN0s63iZZXKKuQB+yBs7eRRe0cFJ2T5bLbJtOQAHMRuBRIIbxgsTtwE
 ZYd9jhXR
 ldML2SxcpcQFV80Xafuo3uSHndA/okDrDLaAOlB/M9OyEK1KAZBPCQIxiPpfjJb+6/LQOK/6a/j/Ov3+wDmf1YrDT2C0DEuCyputDGUg67WJJbD2rJx+HVboOGtYY6KeIjVN4S5aGKBGWlLB4SqNK6VOPIIW83btAelhQcA/3zwq8DWtbuvBrGJocX9kE09jjJX19c/DWFOdyjoY4ORSFaDhMxc86FAARzLykuBekjQYpB23+7Qbyq//YsTU7pyEIbV6LVhFhQEHf9mAv9AkzlSIsUEFYCxSAKsybO5XPqdKFJPFb4xr4TLnBvF3STzv2GvrNmK6ofkadyvZqhot3wwyps3R8RxkBedxrWvcvQKsu7Ij/wveqpEp4e55XZ3WYmhEKvtbsaEcy4RSK4/PBe4liF7tX+rFwc9b1dPmk41XJebdN3TvXrHI47i/ii8KJ/FGSnn1qD67VS7VEcJydKszhYO5UmIm+81t9uHPccveRP5o1r/uDeu5t6zT0q7TJOri4lf4WEtW3aLXIIKm4k9hqWuVhgWuyZbICjmw9cw7VYIZlpTDfnWbn3ndzdruf0Y1CToBlbPAt+XoI0k6uAMAU8HjZ/1MYj4N2RMaz1rx2m13e65026kob0bpVoOYqe1Sf6H1DPoq0TGeqn04XC70Bxl0ghuVnNKB0ix9Q3/AYjUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026, Xiaoyao Li wrote:
> On 7/31/2026 4:34 AM, Ackerley Tng wrote:
> > I think another way to phrase this is that if we don't make this change,
> > say, on the foo architecture where there's no CoCo and no private mem
> > support, kvm_supported_mem_attributes() would return true for the !kvm
> > case, which is over-reporting.
> 
> Under the condition that the foo architecture enables
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> 
> > How about this, replacing the entire changelog paragraph above:
> > 
> >    Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE
> >    based on kvm_arch_has_private_mem being #defined. This improves
> >    reporting accuracy by not reporting support for
> >    KVM_MEMORY_ATTRIBUTE_PRIVATE when kvm_supported_mem_attributes() is
> >    called with kvm == NULL.
> 
> It doesn't help for the case where kvm == NULL, but help for the case where
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES is defined but kvm_arch_has_private_mem not.
> 
> sorry for being picky. I think we can say
> 
> This improves the reporting accuracy by avoiding the case where
> KVM_MEMORY_ATTRIBUTE_PRIVATE is reported when kvm == null even without
> kvm_arch_has_private_mem being #defined.

How about this?

Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
on kvm_arch_has_private_mem being #defined in anticipation of tracking
PRIVATE vs. SHARED state per-guest_memfd, not per-VM (to allow in-place
conversion).

guest_memfd support for memory attributes is expected to be unconditional
to avoid yet more macros (all architectures that support guest_memfd are
expected to use per-gmem attributes at some point), at which point
enumerating support KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory
attributes being supported by KVM at-large would result in a system-scope
check (NULL @kvm) over-reporting support on arm64.

> 
> >    Give architectures full control over overriding the default definition
> >    of kvm_arch_has_private_mem() by removing the coupling with
> >    CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> > 
> >    In a later patch, kvm_arch_has_private_mem() will be defined based on
> >    whether architectural features are compiled in, and made orthogonal to
> >    CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> 

