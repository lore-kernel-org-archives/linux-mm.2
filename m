Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D88FFC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 03:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4BE6B0095; Mon, 24 Aug 2026 23:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555826B0096; Mon, 24 Aug 2026 23:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384E56B0099; Mon, 24 Aug 2026 23:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F05FF6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 23:46:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66CEFA02F3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:46:37 +0000 (UTC)
X-FDA: 85138404834.17.C7DF366
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf08.hostedemail.com (Postfix) with ESMTP id 78558160006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:46:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Zx/09C+f";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787629595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRlcPRMNOl1/3+8t2Vi1R75FQZIyLPc1MX6zX5XEEVk=;
	b=0Jx8OWVD9B50GnNyhtC2EaJYKoVLRR1cW9lnz7jOut6llK2OmlH0p+pgzRGDXmh6HYddt5
	J3+B2LQitLdjRTwkkX0KukU0vfh959Yxj7scgxSoIubtw9NLiBEACNF/pGzKNjsEpxQkkr
	ON9pkiWkQF4ojVWEWywAHkZDlF6b1Us=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Zx/09C+f";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787629595;
	b=OjQv6Om5NqdeV5bNUqtL0IUHz/4qvAMnt3k5tUZk6PHjmWah3v1G9azjEICJcBh0uxp/tL
	+jVnjY7kBtC12Mo4aFJgx7914lp7tv7P7v1JivHYOUHrwelXt0hxZW5T0d1JrCNJTxczah
	xaQ/MuY98EIfjIGV+YY8uYw1sxgFxr8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787629595; x=1819165595;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pAuHVptymQ0SSWCENqu+L5Le6YmITzmlBl28M1cNQjE=;
  b=Zx/09C+fI/HUrj86ClUnJnvtRHKBuolksW2Sst95fw+rF7yx+wk7RSZF
   H+QFAlB3ixpF8RApCjfImnWfDEmCTQD7oxA5LDjrWtUc/q1B2N6kcXvgT
   MnxufhwkI6iF/ks+HVBInnp5/8Pl+9PfZt4fkeBXkeoljnpfMmu4xP39M
   7vdNK0bKHovcjNJ8zPRywuMojDXfEOwxNPt++P5FhizT+hweREaTG1pX0
   Pe/RPHCcqMOS17w0WDpS/gPXY0frbxWSA8yCPTEze2nnWrEI9NpNjtt55
   AS54NIB9CJAae6uzN8iBZeS+vOidHbKhMw+cr6PR6VK2oqbMIpvXcaou0
   A==;
X-CSE-ConnectionGUID: KEGYV5BZTgaf+Jzk560q+w==
X-CSE-MsgGUID: liSdKmkYSPO0HZT3svIGBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="99253068"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="99253068"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 20:46:33 -0700
X-CSE-ConnectionGUID: j6vbUiTHQOuZr4Uc0EJ5Mw==
X-CSE-MsgGUID: aVjU1SuuSLqQW72KLuxDeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="263890983"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.119]) ([10.124.240.119])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 20:46:18 -0700
Message-ID: <54d1bd0e-c27a-4033-ab97-02cd9579a620@intel.com>
Date: Tue, 25 Aug 2026 11:46:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
To: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
 <a410cca6-0776-44af-8353-9b7375e2fd4e@intel.com>
 <CAEvNRgGvxMus6pp=xuDYOumH3Ge4oi0=YKjTaFykFHwXuzRDwg@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CAEvNRgGvxMus6pp=xuDYOumH3Ge4oi0=YKjTaFykFHwXuzRDwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 78558160006
X-Stat-Signature: sfqw1zkz81kygo1oegbyskoqh6uqej46
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787629594-132752
X-HE-Meta: U2FsdGVkX1+Aiq4dD8UZVFBIzsbpLK7NMf0ZIehNyHsaXmeF7GFafgKtY44dsFGAdHPJklvMm9yD5Z1oZcsoAIpKuUXFiAe0Izi+RgnKnaHmkuEC7/rBRJNoBkZ25SSQxyFM3WJRwJ4NFyMCuO91Wz8rYBZ8t3jxMUHwjGfxk4vDDxN1HFtkGftTqsR29IK9Le05D4o8ZzRUHwYslsjABbGRzHxoxg6E5OtFDk+AdTPhBmAdxe1ioLnuei68q4ruKB8+ZbOY+9V3fL47fe3jTN1e0BXkrxmK/+Za+UwZAdAhSlcmwMAootOvKcXK24/1l43F31d+6gp0OXkZYXIuvFvCqBvSycdBQ6bUlKnrSCl+FGWp9W7NPqMmwOdlsWcpGPItDH0fin16g9GJeDrzz2UG1AYdsiayGzQMXCCZhyeK1ARQ4zFxO6zeBaCLTsQt/FTERkm41cKyZZOx6LNsQyDSuldEY1qR+oGArdRK7Wv2mbjewu4mIsYk7MlLHx4CzubJJkSbiNtb5cGcDJ2WQQlFd6wgQFmpPUVAwaqSnmYOCwf5z2msYqH06dliT9HPZ8vI2LHiHaBOk+zFaKp2LoYs5LOv7m5TdcEZVSe8IlpdzKSwmXcjOQWvMhdTiGU4EH4t3CDi9CtB/5CNji4qqB0gO38LZla7wErR6YQy78IBpWZuSgtXxK9ZOSltZ1QcHyQlrUSMDaOl6IqzDzkGScXUQa6DCC43VqpW1rfixrfHKKl6Ks95dZXRDdgV3SPL4As0gZ/GrIrcT9l8824tPHWlczZUqW2urdFFHW5uYGiR84kA+5pfJJAliNGL/1/ZZKUDp58JQew8wML92ZhPwKQhxoG2dus51D2m9TfeDOjgGpgqqPTcnGFEeeHMS5oljEl6xfiXNNPSp+tN07C3k+Z1IRmwE6+eHVhW6LwIHe3qHUWqZ7rVpZVCV5Pj3gTE+YUFHv6UzAud0+zIeA/
 DqEFGYAw
 xd579ayPaRUv/Te4pPPDiHb+oRCeYwdSIcmS7zhYrlx407NIPNTMmzDsav8zC9MWdhVIFDBqgfRN4ZdvsYPjvQ2Namy4RpmSSqVYkkIgwOXLJxy4oh2isZNIU46n/IHY0pG1CKLWN59xJ7IQHKNoefimK5jj2HM5lH2swV7MCv54ZzhrHf3j/HoAn82vr1I43d5tL7mCDBPN6dUbh7JWijABCu/T1AmHNszOmOXIrGPb4PKWbcYNZrSkhG3PxURyQZLT15cAcWSNwj/6oTClcLUsu6h8WmvyVHWp6FD2LVUStuDY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/2026 10:45 PM, Ackerley Tng wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
>>> From: Sean Christopherson <seanjc@google.com>
>>>
>>> Stub in global variable to enable in-place guest_memfd private<=>shared
>>> memory conversion, which will eventually be exposed to userspace via a
>>> module param, and wire up the __kvm_mem_is_private() static call to the
>>> guest_memfd version when in-place conversion is enabled, i.e. when gmem is
>>> the sole authority on private vs. shared memory.
>>
>> I find this patch changes the default memory type for a @gfn.
>>
>> - When memory attribute is tracked per-VM, the default memory type is
>> always shared.
>>
>> - when gmem_in_place_conversion is true,
>>     - if the @gfn has no memslot, or the memslot where the @gfn locates
>>       doesn't have gmem bound, the default memory type is shared,
>>     - otherwise, the default memory type is determined by the
>>       GUEST_MEMFD_FLAG_INIT_SHARED flag.
>>
>> I think we should document this change.
>>
> 
> In a way it's not really a "change" since gmem_in_place_conversion is
> set up as false in this patch.

I agree. It is not this patch making the change but the patch allows 
gmem_in_place_conversion to be true.

> When it is enabled in a later patch, another way to see it is that the
> default remains "shared unless defined as private".
> 
> Before:
> 
> + no memslot, or memslot not bound to gmem => shared
> + memory is shared unless VM ioctl used to make gfn private.
> 
> After:
> 
> + no memslot, or memslot not bound to gmem => still shared
> + otherwise, ask gmem about status, which I think is already captured in
>    the module param concept.
>      + The very usage of gmem (without INIT_SHARED) is defining memory as
>        private, I think that is already documented elsewhere when
>        INIT_SHARED was introduced, that now the default is private.
> 
> So in summary, I feel that this has already been documented in various
> places. I'll also add the following in v11's "KVM: Let userspace disable
> per-VM mem attributes, enable per-gmem attributes", in
> Documentation/admin-guide/kernel-parameters.txt:
> 
> 	kvm.gmem_in_place_conversion=
> 			[KVM] Controls whether KVM enables in-place conversion
> 			support for guest_memfd and tracks the private/shared
> 			state of memory per guest_memfd instead of per VM.
> 
> 			If enabled (the default), KVM enables the

I think the default is disabled?

> 			KVM_SET_MEMORY_ATTRIBUTES2 ioctl on guest_memfd file
> 			descriptors and disables the legacy VM-scoped
> 			KVM_SET_MEMORY_ATTRIBUTES ioctl for private memory state
> 			tracking. Only the KVM_MEMORY_ATTRIBUTE_PRIVATE
> 			attribute moves to per-guest_memfd tracking; other
> 			attributes remain per-VM.
> 
> 			This parameter toggles KVM's in-place conversion
> 			capability support. 

I start to think that the term "in-place conversion" seems to read 
inaccurate. I think it is describing the shared/private conversion of a 
gfn, and in-place means when a gfn is converted between shared/private, 
the backend comes from the same gmem page, thus in-place. But KVM 
doesn't enforce the "in-place".

If "in-place conversion" describes the shared/private conversion of a 
gmem page, then "in-place" is redundant because the conversion a 
specific gmem page is always in-place.

>                       Whether a VMM uses separate backends
> 			or out-of-place memory management is determined by
> 			userspace VMM design.
> 
> 			Note, this parameter is only available when
> 			CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y. When
> 			CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set, in-place
> 			conversion is unconditionally enabled.
> 
> 			Default is Y (on).

I'm looking at the doc of KVM_SET_USER_MEMORY_REGION2, which reads

# When mapping a gfn into the guest, KVM selects shared vs. private, i.e 
consumes
# userspace_addr vs. guest_memfd, based on the gfn's 
KVM_MEMORY_ATTRIBUTE_PRIVATE
# state.  At VM creation time, all memory is shared, i.e. the PRIVATE 
attribute
# is '0' for all gfns.  Userspace can control whether memory is 
shared/private by
# toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as 
needed.

