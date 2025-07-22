Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 747D8C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128218E0006; Tue, 22 Jul 2025 11:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1006A6B00AE; Tue, 22 Jul 2025 11:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016308E0006; Tue, 22 Jul 2025 11:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E5DA96B00AC
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:31:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BF011A0465
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:31:46 +0000 (UTC)
X-FDA: 83692290612.23.A5CB8BD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf21.hostedemail.com (Postfix) with ESMTP id D32A71C0017
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:31:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N8lKJN4y;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753198304; a=rsa-sha256;
	cv=none;
	b=iYOib4pkTIVppwAEiVn6dkQcKgAYZQzqxbHiog7m4a1g8ey55uIyO6tnxHx4dh4ztmHY3k
	Hs+ZaHd8wrMvMkHuoty1sEajN1poeVC5CPOtpRLC+Pq2+KbaMIsTUZt9lnusUPih5idsY6
	TcgIV+GU+L0gukYGUn9x1JH9jSWb+l0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N8lKJN4y;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753198304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oWEgm21Us7QQ4Q7cw8X/XYO7TdjMR8G0w0KgAs4kUbo=;
	b=HtB8eSS+ZqdeRqjHygQCFBf9h94UJ5lfLaFIcu/PCkmeCUfSfOlJdeabEJRJw90ymvei41
	0Grt6q6Ely51KkiVwMebbP1VCJTDqsg3jS9I+4zK4apm3/eWNw7rOX8qtTCZeAOmFJ4zCF
	lbm3NraxOKSTXJrL45waLmeBiWNq17w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753198304; x=1784734304;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eMOvJum6/yj2AFgesWxtWNZbW5eBwagvx40YMuSBJSs=;
  b=N8lKJN4yOrqBa1dUAKVkHyt3m+lNNUGJ3wmrpmx5AVYbOTx6WI5bXOl2
   RVgacJrsx8KpG8UaQv0JlIldG4d4hFrwaVnlBQ2Dt34elfPUdmIQvqsdX
   uAAuvekursTavUWB50Ar3HisSRhgbq0lO93yVvIBsVc6lI6yJaO2ac40W
   rm8qCMWYq4T2EI5lGbIFhDJAhRf5J6aSkq4avKlupQSOhR64vclVFkjmv
   OAlxVWvVba1o0KInae4SVjzz0uJUeHZ2sTMEBxLk82trlVkzD6loLrGKu
   KWn+7H1RqbsibH/qOA+IVClgQG83ZTDrU7fF0q4rTc93VVYE5t+t/skhe
   Q==;
X-CSE-ConnectionGUID: NRlvMreJQ6OQzU0gbxU3Zg==
X-CSE-MsgGUID: CbTidWvTSOa0ttvaNlOOlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="59255552"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="59255552"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 08:31:36 -0700
X-CSE-ConnectionGUID: jwBETCkjRh2RI6ObMFZZ4g==
X-CSE-MsgGUID: nwHPGSaPTBCnDP5i0GeW2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="182888359"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 08:31:20 -0700
Message-ID: <13654746-3edc-4e4a-ac4f-fa281b83b2ae@intel.com>
Date: Tue, 22 Jul 2025 23:31:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
 <608cc9a5-cf25-47fe-b4eb-bdaff7406c2e@intel.com>
 <aH-iGMkP3Ad5yncW@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aH-iGMkP3Ad5yncW@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D32A71C0017
X-Stat-Signature: wjbiwsb5nbi56r8jrtx5ubs777schmxj
X-HE-Tag: 1753198303-455283
X-HE-Meta: U2FsdGVkX18UmlyLiqk/yYWRXPLE/wSpqTTL5wbMebMFjD/DHTD9tE/4U/8+Ryng7F6VR0DaP3IC9iJETO6okITZC8q0tDt5HYCZoIjwehpOL2Hhc0CB8AGBuoFIrPzKgVdDQiBVaRm5qG13J8oMUbNJa9cOwrvi4w2/880DQwXeI2qPJzGTqL8nNQb+OOJJl6wPPUNx8PVlBOGY1xUY+Wr5JX+Q7yOKG6vUrU/++z265paKIOfDXyXQ7NyEntr7bR5TGkT90wE8qO5S0tktFCipJkkrTCCJ9bIUcJKmixLKvwPMAUTwuidF4iVtvkUwFXfdgapPKYF4EaA5wdJpTIZSVw98466AsmBLU0ms8HVYcjpZKiCE1nV1OfBIznkjPGkYyoxJxQ6ujUA9hArOgsujppNGEQc0Ur1ixaomXNI5bDl/fWu7F+81kGMNXEEnhUFkvP22Ri4bCNZEnHpXdCcvMQQR4dfKS5BVK+Crw5R4F/gPrqZVGBP+EOS5cX/XpPb/66IX9e+xBhPJQ3lAPj/ES6DQp5TerIBPmGVT0z2iJL5VYIrnn4/7RKn9ji+IrZRwt6PwIgqoPWoN49wvPLwDrDjdLyJDWiOpf2mphOOnJhFB0EXOT2MqEmAIcxFjaymxISiLkkw+s8u3fuDysiDsYRi6vOYWIJHpX16Yu7Nuym5g0biF3P/u7fpsaWBfeoqVnQH3wUOkeL6JDVvq7pVchA3gkv00Ji2bknGkG3IT705iQ6LGPGJQThgwRjBogQ/gXc/YzRsjl+ZgY2VIYrPEorbGAhVPOW3buEAmx5dImZEy79Uyqj6AH55bgHIVH1l9YcpMfOBYcNUXb3b7UKwoO+oSmaT4NUNA+kApaD7nQ+VKEW0lKzk9fs77NFA9+nuuPVdHmy3tCqreuH0VQT76mnFBitSbdyFQzlh8iQDbr89jyFvyYaamK7nhnmsjMLbK1oO0E2xH8iFiebe
 GTL028y+
 rwh1bckHWcX2uNTutzeLDot9mjXDC6n20NrxzZoV93Bnnf8b88iAH5FXVJG4jb2Zztu6kSgAYTeVj0MrzS+cgBBtANaoQ1bIVkrbde2se9l3EBmy28Qa+NDJnKlZ5SLU3ulaSmfsPGk6tNYzJIMysXuzchx/XTabyllIT+jDAggrPN7/EEdeLtFd70UtryRcjvnFSckRENUgWvlF0zSLsxwBlbkHmwdjnFkdbDC2JIn3HiE3X1n1Gh3yZHUZrkLOnysxtSMOIeHqoXn32XuKb8TF8bhkn1Vb/xeKwyJ9Z4MFEVYIsJOGQiZAFtpMoMXtxZZ0bhVpIApVYrIBfYq9g6T2usidUq9YUs0cFkpk62MSSlrDcyP8J7BI4ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/2025 10:37 PM, Sean Christopherson wrote:
> On Tue, Jul 22, 2025, Xiaoyao Li wrote:
>> On 7/21/2025 8:22 PM, Xiaoyao Li wrote:
>>> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
>>>> +/*
>>>> + * CoCo VMs with hardware support that use guest_memfd only for
>>>> backing private
>>>> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping
>>>> enabled.
>>>> + */
>>>> +#define kvm_arch_supports_gmem_mmap(kvm)        \
>>>> +    (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&    \
>>>> +     (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
>>>
>>> I want to share the findings when I do the POC to enable gmem mmap in QEMU.
>>>
>>> Actually, QEMU can use gmem with mmap support as the normal memory even
>>> without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
>>> on KVM_SET_USER_MEMORY_REGION2.
>>>
>>> Since the gmem is mmapable, QEMU can pass the userspace addr got from
>>> mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It
>>> works well for non-coco VMs on x86.
>>
>> one more findings.
>>
>> I tested with QEMU by creating normal (non-private) memory with mmapable
>> guest memfd, and enforcily passing the fd of the gmem to struct
>> kvm_userspace_memory_region2 when QEMU sets up memory region.
>>
>> It hits the kvm_gmem_bind() error since QEMU tries to back different GPA
>> region with the same gmem.
>>
>> So, the question is do we want to allow the multi-binding for shared-only
>> gmem?
> 
> Can you elaborate, maybe with code?  I don't think I fully understand the setup.

well, I haven't fully sorted it out. Just share what I get so far.

the problem hit when SMM is enabled (which is enabled by default).

- The trace of "-machine q35,smm=off":

kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0x80000000 
ua=0x7f5733fff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#1 flags=0x4 gpa=0x100000000 
size=0x80000000 ua=0x7f57b3fff000 guest_memfd=15 
guest_memfd_offset=0x80000000 ret=0
kvm_set_user_memory AddrSpace#0 Slot#2 flags=0x2 gpa=0xffc00000 
size=0x400000 ua=0x7f5840a00000 guest_memfd=-1 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x0 gpa=0x0 size=0x0 
ua=0x7f5733fff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0xc0000 
ua=0x7f5733fff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#3 flags=0x2 gpa=0xc0000 
size=0x20000 ua=0x7f5841000000 guest_memfd=-1 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#4 flags=0x2 gpa=0xe0000 
size=0x20000 ua=0x7f5840de0000 guest_memfd=-1 
guest_memfd_offset=0x3e0000 ret=0
kvm_set_user_memory AddrSpace#0 Slot#5 flags=0x4 gpa=0x100000 
size=0x7ff00000 ua=0x7f57340ff000 guest_memfd=15 
guest_memfd_offset=0x100000 ret=0

- The trace of "-machine q35"

kvm_set_user_memory AddrSpace#0 Slot#0 flags=0x4 gpa=0x0 size=0x80000000 
ua=0x7f8faffff000 guest_memfd=15 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#1 flags=0x4 gpa=0x100000000 
size=0x80000000 ua=0x7f902ffff000 guest_memfd=15 
guest_memfd_offset=0x80000000 ret=0
kvm_set_user_memory AddrSpace#0 Slot#2 flags=0x2 gpa=0xffc00000 
size=0x400000 ua=0x7f90bd000000 guest_memfd=-1 guest_memfd_offset=0x0 ret=0
kvm_set_user_memory AddrSpace#0 Slot#3 flags=0x4 gpa=0xfeda0000 
size=0x20000 ua=0x7f8fb009f000 guest_memfd=15 guest_memfd_offset=0xa0000 
ret=-22
qemu-system-x86_64: kvm_set_user_memory_region: 
KVM_SET_USER_MEMORY_REGION2 failed, slot=3, start=0xfeda0000, 
size=0x20000, flags=0x4, guest_memfd=15, guest_memfd_offset=0xa0000: 
Invalid argument
kvm_set_phys_mem: error registering slot: Invalid argument


where QEMU tries to setup the memory region for [0xfeda0000, +0x20000], 
which is back'ed by gmem (fd is 15) allocated for normal RAM, from 
offset 0xa0000.

What I have tracked down in QEMU is mch_realize(), where it sets up some 
memory region starting from 0xfeda0000.

If you want to reproduce it yourself, here is my QEMU branch

   https://github.com/intel-staging/qemu-tdx.git lxy/gmem-mmap-poc

To boot a VM with guest memfd:

   -object memory-backend-guest-memfd,id=gmem0,size=$mem
   -machine memory-backend=gmem0


