Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C85F10FCADC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 21:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0254D6B0005; Wed,  1 Apr 2026 17:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3ED76B0089; Wed,  1 Apr 2026 17:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E1E6B008A; Wed,  1 Apr 2026 17:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0B1E6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:05:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9633BB6FFE
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:05:01 +0000 (UTC)
X-FDA: 84611216802.11.2C6DDB3
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id C979C18000E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:04:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="b0H/XamJ";
	spf=pass (imf06.hostedemail.com: domain of 3eojNaQYKCBcF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3eojNaQYKCBcF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775077499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z2G9uSQqW1t77mVxoAaIkc05+KXCw20NeU1W0ypS1GQ=;
	b=l8tRjmKgOhfXh+AYony5S2SPbiJHYGRoaAz9iGKFwSKkslfWbfkivLZFmK2iOlD6FvPtNK
	TnUJrOnrf+C8TglH0XK52Qg4T8a5SNH9hiN0ZYrDawzjX2YC1PLAYKVIx0b3AEKyCr9ZLx
	6qQMD713n8wFKFC4NzVjDXdYsaDk26c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="b0H/XamJ";
	spf=pass (imf06.hostedemail.com: domain of 3eojNaQYKCBcF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3eojNaQYKCBcF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775077499; a=rsa-sha256;
	cv=none;
	b=IEb/+Ghq1V2j3FFWcG3zyqnzq3ZgxURS7EQDOzcjTcwdo7/mciLo86yFZrPwhzLsZiApeg
	t/f8KqhpPcmvla4Z0TGQjwM28tuUC7BBBeaRQ1B3F2H7erf8f5wbomRxSIg5/EcCNPMTkH
	G+grDyUTioYOtmIY/OE06E6ULV2/eps=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b2489af602so1125495ad.1
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 14:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775077498; x=1775682298; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2G9uSQqW1t77mVxoAaIkc05+KXCw20NeU1W0ypS1GQ=;
        b=b0H/XamJqozej1O3DdWZQdaEuEnd1QtWJ/0WHuLTsxMvjM4ca+KWszkljLL/0KFVY9
         zxC0QWWYjaZskJrwZsjEdizb4TW1c+F6JDyHvLVBu0zGUyDL3SmCHS9AjsqyQ6JCldp/
         XEq3ZDggvYs5O5X9F1gPmJgw/n5fBeNEI+cYk4GzSQk+b/N+vPFwWN7iIQi/7nuEC7DJ
         zj8Xr0lI2tV2SdD5RQwIJ+LtsUYelLKmENudb683oFMBCfgBN4q/cmcaFIIakx3QsS5p
         Ew6/x147FxSlF6QleqXs9p1yFSIbrWe1owgXnSbUgv6au4Qo9HcLVUsHoxm5EX16VrGo
         MMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775077498; x=1775682298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2G9uSQqW1t77mVxoAaIkc05+KXCw20NeU1W0ypS1GQ=;
        b=H/aLqg7UHyuvOawb/cY5wZ/MTF4WOZFIRrb1OFyan7jw2UayWbyCwFWX4rvc/4bHHR
         3Wxva4W/LGkL5qKGC3SqzChNQ4M6KXnHCCcbSRwExxyRdeGBoQxeh3nxtsFNlVRZotf7
         xfhk5zotTu5IkV/0JDfQ20gSg1hQHvoVtDabU9BjcSBB4POzMKRyTpcjj7+6lhcJeqxK
         6MC8Ye/gMJx7VoxR1U6n9I/a1RGYNWJjlHDWTIcaYD6NYoTPlWJ8SbU0P7if+3nabmLO
         NOwsgZ2QvBMmOWOspqHi6SqTOnMuIOy8f7c1lPRYkbWAXW8yasC63jiUduEOJC7hu7PD
         KEgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUT1H7BcVjk2weF1yhIroOnWMXSKj0AhiTzef/r4y/kwb+4DFbS4mqtv6GpqMzquE1e8p29TSdJ8Q==@kvack.org
X-Gm-Message-State: AOJu0YyG0Jen/QbrA51V6vrUD0p/GANVE8n+rZ6SJ/vfCfzOORnSW+kB
	JHY3oJr/02x9gzeRl+UtEG8kBvg4nOJm4FWHaD7/LbeFI6m10cN/DHHxVQCu4jCgiDiuZSVRy9N
	cHYv4Iw==
X-Received: from plhk15.prod.google.com ([2002:a17:902:d58f:b0:2b0:6c44:fc55])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c48:b0:2b2:4f43:b49a
 with SMTP id d9443c01a7336-2b2698a1054mr47624785ad.22.1775077498214; Wed, 01
 Apr 2026 14:04:58 -0700 (PDT)
Date: Wed, 1 Apr 2026 14:04:56 -0700
In-Reply-To: <cxmtst7txfodp6lo4ipue3trohx2ge7nkagkfzfixfdnlf5qlo@e3jw3tmbe272>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-8-e202fe950ffd@google.com> <cxmtst7txfodp6lo4ipue3trohx2ge7nkagkfzfixfdnlf5qlo@e3jw3tmbe272>
Message-ID: <ac2IeJNrrBuKtYn2@google.com>
Subject: Re: [PATCH RFC v4 08/44] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Queue-Id: C979C18000E
X-Stat-Signature: 9jt3n88dizsq839ropiggsxgez1hh43y
X-Rspamd-Server: rspam06
X-HE-Tag: 1775077499-94378
X-HE-Meta: U2FsdGVkX19BXLDj63sZ6h4K+2ikwGDIb/Z3cdFWaOexrjGLHG46U/RbBvLddL0a248WzXYyusXy1tPiHmkf7azDNK7cX6f12oaVE4YX9GoU07ZtmZwtH7sT7+k2ZcNuXnUIftf4U53YMWnwvNcZhjBRkIJLI2Rc9kpsc42rbFzGTR8+J5sk3ZWYq+zDfv9oWnqvd7wwm1mQeqOE9lPqk3HgkpPKSIt1Q5/EfN4v6p6yW6OFPkHTG2jJBAq+3534kG8eBh4Dxhd/LBPkZJU+5wqSHWjD1owdGVYFCLm1+vyfcRM5RFUV/2GDqr3isMW93IGzjpKy0f2V96eLHjo7L4UXIiPyl119AOETycTQxSi1QbJnPiyL2zTNSeveYvLY9p2bd2qFjOMf3Rfyxe9UjmRsg/sp9X2lATF9mkVSbXTCRf+pFRtGv/32Tn3QTyCUNx7X3Re5D+FmogDLB1yFW15hp/wgaQaKCIrFl2Bkrm75yZ0VUwJY0zWa03/Kto27VXO1xk5q6Swo6A/1ivpbeZjAL87Rnn4niDdMmkC/K0H+I2OZNr5JAtt/KE+MIDFHJlHpNK423Igo2ZhY4arzz/+Ltp8rSOIoNVt9iEsSjBhNTwXv9E3HhQOJfPCFgPyhNM/qIt9WwvWcbZUOE0Uiu5Pxxe7tRYBHFW7pb7GW1GcdBJ1mZ5xMjNj0TxkXpQBvvvV2MYEhDiFVD3RA9ns4Rvrds1cTfqJKJVl5R95dic0KABq2a4oUb4dDzVkz+01OgEOLVxgfNbHtFBtUmBQSFhY94tiGv1P+1xkLlQtOkiDSMLMA7QK8goDA5Yr37/kHn+8op8SoNvyYhY79fS8dkF81rvxfaL9qllKeVyfdl8ePxpJEVD+82v4A7dk1aTWC95WKKv6OQPbnJf9o2mtsC1FJh3smGMyZhWRD8jCvLGX5a4Af/ovuqxh6SFUeI/PhwNjA3oiJoNOl023WK81
 YPl4CQtU
 zhQ4ABI88L+7yIH0iVmNM9FDtlS9AWx+kOgn48HPsJJ5Sx+BATZRb52LDb/3vkj/i5i79cuMmA022SbK2GepT2mhDmU52OlPQTxLrqRFSnKbyIMOPf9hmHo4/mPct8bVKieyklf2dgb6f6qSc6MF8XpPrN7JBT6KmbasfNKx0wgzqTBJn0utHVphr/JCYeJ7R/aFmPrAWciMvSA8a16dT443uezbVNTPpTpaEjklivXYOe4QmSjyho4pQ78ShqmIs4LYqJQ6A8k6lRWMklu3t9cAHhR6wcRHCVt1kmKsqrX4K+IWk05vf1GylhwXSLjYSRq2SGclGGlaETL+JpmHZUHQXGaFTt8wri6xm3nZHNXFRke3p575NL3PHpRy0sovsb3xabKhIeNj7Ckbrkn90GjJsMMftSZtywEvup6I+NmHAcb9GZ5bggCjcDpk7c2scexAIY/f1JADVW+DH+zSuYJZ2a4nmHQW6lzQt2EYMAQ22b4ZHhfxgv+zIWW486HWrWgfx1iTsLA1a/L3+dYhnFNrfhCPQkCAKG0HOwK7/Lu9koRcEB4EccTAkqZ6bXLWcDgWUuM64BPSQIc9soNQYBYxTzghOAYmyrvlpJt9OVxBzKqOCijCjejNF0Uj3tzBclxV8fXrJoFRnxb1YKPTTNVBYB5dnbT1dRf/GRml6lTe+5r+hG3rMZEbwSh7H6JlcRGBQpR7ZsXvltJqiDzF2MeekjKTNQXiHoUou
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026, Michael Roth wrote:
> On Thu, Mar 26, 2026 at 03:24:17PM -0700, Ackerley Tng wrote:
> > Introduce a "version 2" of KVM_SET_MEMORY_ATTRIBUTES to support returning
> > information back to userspace.
> 
> Hi Ackerley,
> 
> Not trying to bikeshed below, but I'm working on getting related QEMU
> patches cleaned up to post soon and was working through some of the new
> uAPI bits, and plumbing some of these capabilities in seems a little
> awkward in a couple places so wondering if we should revisit how some of
> this API is defined...
> 
> > 
> > This new ioctl and structure will, in a later patch, be shared as a
> > guest_memfd ioctl, where the padding in the new kvm_memory_attributes2
> > structure will be for writing the response from the guest_memfd ioctl to
> > userspace.
> > 
> > A new ioctl is necessary for these reasons:
> > 
> > 1. KVM_SET_MEMORY_ATTRIBUTES is currently a write-only ioctl and does not
> >    allow userspace to read fields. There's nothing in code (yet?) that
> >    validates this, but using _IOWR for consistency would be prudent.
> > 
> > 2. KVM_SET_MEMORY_ATTRIBUTES, when used as a guest_memfd ioctl, will need
> >    an additional field to provide userspace with more error details.
> > 
> > Alternatively, a completely new ioctl could be defined, unrelated to
> > KVM_SET_MEMORY_ATTRIBUTES, but using the same ioctl number and struct for
> > the vm and guest_memfd ioctls streamlines the interface for userspace. In
> > addition, any memory attributes, implemented on the vm or guest_memfd
> > ioctl, can be easily shared with the other.
> > 
> > Add KVM_CAP_MEMORY_ATTRIBUTES2 to indicate that struct
> > kvm_memory_attributes2 exists and can be used either with
> > KVM_SET_MEMORY_ATTRIBUTES2 via the vm or guest_memfd ioctl.
> 
> The guest_memfd support for the KVM_SET_MEMORY_ATTRIBUTES2 ioctl isn't
> added until patch #10, and to scan for it you sort of need to infer it
> via KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES reporting non-zero (i.e.
> KVM_MEMORY_ATTRIBUTE_PRIVATE), so it's confusing to state that
> KVM_CAP_MEMORY_ATTRIBUTES2 means you can use the struct via a guest_memfd
> ioctl.
> 
> I think the above is trying to simply say that the corresponding struct
> exists, and remain agnostic about how it can be used. But if that were
> the case, there would be no way to know when KVM_SET_MEMORY_ATTRIBUTES2 is
> available in the first place, so in the case of KVM ioctls at least,
> KVM_CAP_MEMORY_ATTRIBUTES2 is advertising both the struct and the ioctl,
> whereas for guest_memfd it's only advertising the struct and not saying
> anything about whether a similar gmem ioctl is available to use it.

+1 to everything Mike said.

> Instead, maybe they should both have the same semantics:
> 
>   KVM_CAP_MEMORY_ATTRIBUTES2: *SET_ATTRIBUTES* ioctl exists for KVM that utilizes
>     struct kvm_memory_attributes2
> 
>   KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES: *SET_ATTRIBUTES* ioctl exists for
>     guest_memfd that utilizes struct kvm_memory_attributes2
> 
> In which case you would leave out any mention of guest_memfd here as far as
> the documentation does, and then in patch #10 you could modify it to be
> something like:
> 
>    4.145 KVM_SET_MEMORY_ATTRIBUTES2
>    ---------------------------------
> 
>   -:Capability: KVM_CAP_MEMORY_ATTRIBUTES2
>   +:Capability: KVM_CAP_MEMORY_ATTRIBUTES2, KVM_GUEST_MEMFD_CAP_MEMORY_ATTRIBUTES
>   -:Architectures: x86
>   +:Architectures: all
>   -:Type: vm ioctl
>   +:Type: vm, guest_memfd ioctl
>    :Parameters: struct kvm_memory_attributes2 (in/out)
>    :Returns: 0 on success, <0 on error

As discussed at PUCK, I think we should omit KVM_CAP_MEMORY_ATTRIBUTES2 and
vm-scoped support entirely until it's needed (which may be never).

> and *then* add in your mentions of how the usage/fields differ for
> guest_memfd/KVM_GUEST_MEMFD_CAP_MEMORY_ATTRIBUTES case vs. KVM ioctls.
> 
> This avoids needing to issue 2 checks for the guest_memfd variant vs. 1
> for KVM, but more importantly avoids subtle differences in how these
> similarly-named capabilities are used/documented that might cause
> unecessary confusion.

