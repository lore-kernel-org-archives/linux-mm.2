Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B69FBCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2290E8E00D6; Fri, 24 Oct 2025 12:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8B08E00C9; Fri, 24 Oct 2025 12:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8AE8E00D6; Fri, 24 Oct 2025 12:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3FDC8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:41:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77CC54981D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:41:58 +0000 (UTC)
X-FDA: 84033574716.22.1C5DE1E
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id AE0D1140009
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:41:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ICUHkAKj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3U6z7aAsKCOgKMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3U6z7aAsKCOgKMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761324116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1RHFoPTdDvcwb/qkIe5JmQx1A2yObnl5+zva5BuXpw=;
	b=0hcliHuU2nllD5+H9GL4L2WcuV5yH0gq7Hfh8707rohTpL2JgudziGwJwqIYhJx19n3epM
	MQgmV6XH/MK58Fg+vczCn8GpIcuPIqVrX8TUKFDhzXVC8N9Qdwj6Vzody3uqVNBVHm0hXu
	/c1XYsaljX70t61sAhQ9eX4j4E2mK+0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ICUHkAKj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3U6z7aAsKCOgKMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3U6z7aAsKCOgKMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761324116; a=rsa-sha256;
	cv=none;
	b=MqtOes9Sm1vEAenIG9CFYrk3JVPZo9WYNQXFUtG+8I2buYXGbOa6qaNIGGLrEShQfrxipF
	75ZImarXHqHG+fF+KFyU7s5v4V8nJgBruWiJb7LSh1Y989h3mpuxH8/9gM37ZwOGV5YJsd
	y7adMmo6n4JDWIvkKmxiX36bKeSEGLc=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-290d860acbcso43870525ad.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761324115; x=1761928915; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t1RHFoPTdDvcwb/qkIe5JmQx1A2yObnl5+zva5BuXpw=;
        b=ICUHkAKjL+kI0gNHpv/LPqxXPuTUEhifPGwrFSaw3cC8rPfkeYHGVNwboUHYWbfZFr
         U3XLk3nnV7SnrRDKEFEhmXg38yyPqCpIJ6Pcwhe11YiQVZhdZPmkUBENDgGqYIMrkJ2k
         RRdBwkYRqaVb1vGpehuNOROpEtW19t+v9KiGJWuIHB1po2pZByzn5M14rRsJjirpGxDB
         FzK3vIe3aFG3iDyZMcvYVNv1o10trCskWjM6A9rZ8LknjgLfAE4qWqrCjbnOKwAYwiPR
         y10j3VVHHmhRqMUaS2HrVXh8lKbdW/vvUej/MvcRSfbRKrBaFsZO2lNxMUHZx7ZmftDN
         1ZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761324115; x=1761928915;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t1RHFoPTdDvcwb/qkIe5JmQx1A2yObnl5+zva5BuXpw=;
        b=SjmPDx6jB1bVtQuXTGkEqCVmFO5MFxtGjtowSsivdZmu3LUknVE4qZNOIQa33RJB4P
         OB+k7nesKVXsQsFvljoIDs+czY7/StOm4pn6ux+dsJ+LKIqwV6CNxWriWq9FNX3EKRWo
         TrS1AD7ATBLwRJC2/phc+AjMz9rLpWzE/nYM32dnZt+/7W13R/x+r+lFalW3DvNfAr8t
         ALuqX6CpE8kBWHNLo8JgcBP20m6PDlfOLGHcpU6WnXxc/S7gj1ii0IKcQ9qIbw55f+0G
         8eW5YIsaNTnPq3mMmKYRvDilX15C0ZBROzunROdvh/qq68t0hdOf4BHjdNSAgXX+QUfE
         yjYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkbxFizI0mfQ0XBY8GAyxN27ER7VC6qBrGTsdcXx8djf00M7fuHvwpOninusjZ46JElztqfI8tnw==@kvack.org
X-Gm-Message-State: AOJu0YyJkfwXwPwHr2XN60KrpvJ+c8jFD2+oMFcXXHNlm7ZyKjFVwMba
	1QWOy9WBrWLV9C5OclFyjubTe+Bgwu278DfIdtrNl4y3Kghl0NKjK/Q9d3TgUOOF1eua4Wj3Lw1
	zQl/OY+F8RSouUNO0bIjG61KX6A==
X-Google-Smtp-Source: AGHT+IEPuBDuGNsrppGmcrNT5qFipxZMZW83jV/EN44QaRv4+wQ0X1ZUm0/OOFjwazq9d0SG+iIXrpEvGj5fqDDiKg==
X-Received: from pjn8.prod.google.com ([2002:a17:90b:5708:b0:31f:2a78:943])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ea01:b0:267:d2f9:2327 with SMTP id d9443c01a7336-290c9cf2d88mr421610105ad.27.1761324115016;
 Fri, 24 Oct 2025 09:41:55 -0700 (PDT)
Date: Fri, 24 Oct 2025 09:41:53 -0700
In-Reply-To: <aPuXCV0Aof0zihW9@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
 <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com> <diqz4irqg9qy.fsf@google.com>
 <diqzy0p2eet3.fsf@google.com> <aPlpKbHGea90IebS@google.com>
 <diqzv7k5emza.fsf@google.com> <aPpEPZ4YfrRHIkal@google.com>
 <diqzqzuse58c.fsf@google.com> <aPuXCV0Aof0zihW9@google.com>
Message-ID: <diqzo6pwdzfy.fsf@google.com>
Subject: Re: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Steven Price <steven.price@arm.com>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org, 
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com, 
	keirf@google.com, kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, 
	shakeel.butt@linux.dev, shuah@kernel.org, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: AE0D1140009
X-Rspamd-Server: rspam03
X-Stat-Signature: cz8ofnpwg7cmgmhkbqczu88tk38oo1hc
X-HE-Tag: 1761324116-487287
X-HE-Meta: U2FsdGVkX19xEbecv/B69KoUR1S8iRcu5JWLYv+rulXHvGBqB/IdUTcJSGW21YAfXCGomzjMTgcBEwCM1QGSWLS/npt5z0/1H+JYsfuI4F8EDa13+dTwGKCPtugJfrnYfZwHteaGcjm2S0pBidANpbCjvUGiwXxrZM4CKYf84ub5liiFDgPhfFZIOYQ6I1KgHYlctCJ7SvL7PnRg/noBwdZfbFh6TYZZLjKz0/Hu/fxm3Y50rLdMuxX8Wh3AlchJgXUsTpcXG0RbwrgYUpETJFLjgUqHKusWoOU192rINiOTEG81Tkroa2HFK1v5ijnS3KWDnA1cbHl2+bFOskMezXM6iWLyHmym/Zf2rwHJGG0RpzrHN3Nh6YPqzNXKnVzpIberycmRSaACEW+kTHGaIaYpKBCgxxTEV9hH2vtytMk82q86MTTUZwSI9AzkpzVwGDP0BtCuy9AzXZGxmVB0aXBX7WoCIYfzY1kwuOxh96t4gPHq9oJ4Hi0wYnH5B0PCwrTUuMLWAuqPSAHotovDFC5e988Vbvij+mTK9aoLCxZIlyIR8foM9mINeSe+kovZmUlriRwcoYsabmPKVfzPYP265qdWZE66d9lqTUZADVLF+Q2iUVtES4SErypTd3k7+O/UmVGt+gpVePyh1yM+Bvkl+rFCa44L4Vm0LlD5ro6/6+5X5uw7H3WlxTUzTWNUsOKbc6z+gu9bzsddDmNOOAKRvW0lnPnfo/JzajRBhazTGECCh18lkRaFwUE2cyXlHBbylTVj7iAibdiW3BsE/8kPAtNANnr5zVwB1DEeLODVM6XSHwPl16dqy/Ff1fSiGirSPdaQD3j0okfxB3s6TKJQI9hu2CojRPLB99FMuJ2P8HvMz9G1/to119a+9wbB74xthydb6kuilXOWMvMAgM3vZb49oAA6sX1BeuslOfeV2RrtSFAjYn8EH2d2jXLqpczo7FRsBZx87IC6W1v
 x/JSFqOn
 1fcl63h2SGtBl0OpgkYu/vrqgtvNCFm4h+N/kZ1FVh0h/9q3VgWR369S5kHtXMV1i/sK60HEIGCMSM3u2yRKwGcMYVUlBwjV6BYgDVeo6cboPbtzyGovS3st24hRCWHu566VCLZHS0ruahTlQsRyYFH5oyXPTmxAPDXf459FvI24J/DkPNmx3UClxeScNMnEspxRbF8RPJbLmS/c7mzpSzRgQS7kRLwRYbjpgGsNNvVEfWhWz4ZTC8OSxC5mZ4wgxbB1OFOJVDrpCCoU6YVLtuh1uh09skhtuXy/vSLKNgxZUUEqsASCAndoJz3+rRue9KUr7AUas7nulXmvzbzFCLMTmclyG34A4pT9xZdSiPdoObnudyita3Q9v3yxdu4B+sJp0SXSA/3Ckx51fNBY7E2tOkKH0gYY0M7AGvHrmRH2F8w4ea9hxMbK6v6MJ3e4z9cjq829SQfUeTsUBAPXbrfAct9QWCJBMcxdSf6eLh+9MjGSuEVLgpgkTmJIG93GrxyMUOn9ZxDcD1NTf6jLQ332qLGk9QL4ylkdnIaHbGPmqhikZUc4fTkozXoFzxvct/FjTy45X8WgvZomxrCuuqpZoNU1uSj24N8n7jN8uKcTdxSY5FB03Lpz7O2WitrXnKEmkjKOE9m8PqY/bo7DNX5lLOeBUM2WlLfXXZtwDUQ3moIzKDxpp/4S69T/+LRA6ztD3BC098jG9VMyKC/nLgu5vtCPLhs5PAKEro5fzIKr2kpnJsUO6qz/DlssWB+GJnamt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Oct 24, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> >> 
>> >> [...snip...]
>> >> 
>> 
>> I've been thinking more about this:
>> 
>>   #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>>   	case KVM_CAP_MEMORY_ATTRIBUTES2:
>>   	case KVM_CAP_MEMORY_ATTRIBUTES:
>>   		if (!vm_memory_attributes)
>>   			return 0;
>>   
>>   		return kvm_supported_mem_attributes(kvm);
>>   #endif
>> 
>> And the purpose of adding KVM_CAP_MEMORY_ATTRIBUTES2 is that
>> KVM_CAP_MEMORY_ATTRIBUTES2 tells userspace that
>> KVM_SET_MEMORY_ATTRIBUTES2 is available iff there are valid
>> attributes.
>> 
>> (So there's still a purpose)
>> 
>> Without valid attributes, userspace can't tell if it should use
>> KVM_SET_MEMORY_ATTRIBUTES or the 2 version.
>
> To do what?  If there are no attributes, userspace can't do anything useful anyways.
>
>> I also added KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES, which tells
>> userspace the valid attributes when calling KVM_SET_MEMORY_ATTRIBUTES2
>> on a guest_memfd:
>
> Ya, and that KVM_SET_MEMORY_ATTRIBUTES2 is supported on guest_memfd.
>
>>   #ifdef CONFIG_KVM_GUEST_MEMFD
>>   	case KVM_CAP_GUEST_MEMFD:
>>   		return 1;
>>   	case KVM_CAP_GUEST_MEMFD_FLAGS:
>>   		return kvm_gmem_get_supported_flags(kvm);
>>   	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
>>   		if (vm_memory_attributes)
>>   			return 0;
>>   
>>   		return kvm_supported_mem_attributes(kvm);
>>   #endif
>>   
>> So to set memory attributes, userspace should
>
> Userspace *can*.  User could also decide it only wants to support guest_memfd
> attributes, e.g. because the platform admins controls the entire stack and built
> their entire operation around in-place conversion.
>
>>   if (kvm_check_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) > 0)
>> 	use KVM_SET_MEMORY_ATTRIBUTES2 with guest_memfd
>>   else if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES2) > 0)
>>         use KVM_SET_MEMORY_ATTRIBUTES2 with VM fd
>>   else if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES) > 0)
>> 	use KVM_SET_MEMORY_ATTRIBUTES with VM fd
>>   else
>> 	can't set memory attributes
>> 
>> Something like that?
>
> More or else, ya.
>
>> In selftests there's this, when KVM_SET_USER_MEMORY_REGION2 was
>> introduced:
>> 
>>   #define TEST_REQUIRE_SET_USER_MEMORY_REGION2()			\
>> 	__TEST_REQUIRE(kvm_has_cap(KVM_CAP_USER_MEMORY2),	\
>> 		       "KVM selftests now require KVM_SET_USER_MEMORY_REGION2 (introduced in v6.8)")
>> 
>> But looks like there's no direct equivalent for the introduction of
>> KVM_SET_MEMORY_ATTRIBUTES2?
>
> KVM_CAP_USER_MEMORY2 is the equivalent.
>
> There's was no need to enumerate anything beyond yes/no, because
> SET_USER_MEMORY_REGION2 didn't introduce new flags, it expanded the size of the
> structure passed in from userspace so that KVM_CAP_GUEST_MEMFD could be introduced
> without breaking backwards compatibility.
>
>> The closest would be to add a TEST_REQUIRE_VALID_ATTRIBUTES() which
>> checks KVM_CAP_MEMORY_ATTRIBUTES2 or
>> KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES before making the vm or
>> guest_memfd ioctl respsectively.
>
> Yes.  This is what I did in my (never posted, but functional) version:
>
> @@ -486,6 +488,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
>         }
>         guest_rng = new_guest_random_state(guest_random_seed);
>         sync_global_to_guest(vm, guest_rng);
> +       sync_global_to_guest(vm, kvm_has_gmem_attributes);

I ported this [1] except for syncing this value to the guest, because I
think the guest shouldn't need to know this information, the host should
decide what to do. I think, if the guests really need to know this, the
test itself can do the syncing.

[1] https://lore.kernel.org/all/5656d432df1217c08da0cc2694fd79948bfd686f.1760731772.git.ackerleytng@google.com/

>  
>         kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
>  
> @@ -2319,6 +2333,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
>         guest_random_seed = last_guest_seed = random();
>         pr_info("Random seed: 0x%x\n", guest_random_seed);
>  
> +       kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
> +
>         kvm_selftest_arch_init();
>  }
>  
> That way the core library code can pivot on gmem vs. VM attributes without having
> to rely on tests to define anything.  E.g.
>
> static inline void vm_mem_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
> 						uint64_t size, uint64_t attrs)
> {
> 	if (kvm_has_gmem_attributes) {
> 		off_t fd_offset;
> 		uint64_t len;
> 		int fd;
>
> 		fd = kvm_gpa_to_guest_memfd(vm, gpa, &fd_offset, &len);
> 		TEST_ASSERT(len >= size, "Setting attributes beyond the length of a guest_memfd");
> 		gmem_set_memory_attributes(fd, fd_offset, size, attrs);
> 	} else {
> 		vm_set_memory_attributes(vm, gpa, size, attrs);
> 	}
> }

