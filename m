Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8869BCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3DAC8E00B2; Fri, 24 Oct 2025 11:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15A08E0042; Fri, 24 Oct 2025 11:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B4A8E00B2; Fri, 24 Oct 2025 11:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B1E798E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:11:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E0D1BE68A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:11:10 +0000 (UTC)
X-FDA: 84033345900.08.130D10C
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6A1868000E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:11:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nUuiy+JE;
	spf=pass (imf30.hostedemail.com: domain of 3Cpf7aAYKCHUlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3Cpf7aAYKCHUlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761318668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8S1KonkShBOqtsinZhRSshiH2hzjBvvVn7bRME6LIQ=;
	b=Je9kMVd4Bj23iBA+aYcINgSxFt6QqYDMR3Selrx0u5LJVdJsNWL/DTj5IgfvmQ7rSZhPcc
	nSgmaJzy8V5A0cMk1EPZOuxuzh/jcUI4nJrQJwyv89J595oeePeUcUCQQlPLgvhwBa4M3g
	fg20dLDGuCnB1FEyir1HtLIWTXbdDMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761318668; a=rsa-sha256;
	cv=none;
	b=gEhMvrF079PEO6bFcyy147gpn0JusTZnRpsNY+GyvYKTS+8+0GyLG+pLmDHzcE3JQVt8Y1
	SfL3/TLMBVmA4G+u2uqxAEf8zWkDpoDOCOM9fjYVv63pc5ab9Q/RjKVzEGN5wRTO3DBMSz
	7YaPDORQIe9jNaTvikxFk8/28yU6nfE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nUuiy+JE;
	spf=pass (imf30.hostedemail.com: domain of 3Cpf7aAYKCHUlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3Cpf7aAYKCHUlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7a27ab05999so1193412b3a.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761318667; x=1761923467; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f8S1KonkShBOqtsinZhRSshiH2hzjBvvVn7bRME6LIQ=;
        b=nUuiy+JEUsK4qXqWdIX8VopA6o+BaC0rLuQI9ShvBUvyBUKSE+TF2TplUCqdFNZbnS
         yz/C2fq8PWMofQxOcSL6RCtIzFrOl5w5eTF+K9rcXRzowx+CUJ50CMZDfy3Sj14XxGF8
         vt/EjzplQlSnAMvB+Gvvlxuc0Ek9+vjgIeqWP3WNmWpyz0mFv0A2y3MXQjsUw0ulgkmD
         S/GF9aACOcsLD1R+KgLtj3LHXYu5X7KVm1oyE8uZZa5OZeV3MM/ffudBB+Z7OoWg1GJ9
         KPaf+gA2SB8m0ReQBczSE6nmIEv3aMD56i2hCl3T3HpkbpsrATVovd0MTrIynS7//GTU
         7pfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761318667; x=1761923467;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f8S1KonkShBOqtsinZhRSshiH2hzjBvvVn7bRME6LIQ=;
        b=m0MitbHBcob13uB56srw1qEoh1t7VxHE473KDIr5u29wmtKUF4qEwzS5LryWGiLDfJ
         NiGcb2hHVsYoB0ZR2ntfGVWRliGLyjhMr6hzb0VwrjVZdZeJ+lH2hRexZTgiYoz1iBU4
         24bGTqol9XqKGhWDkEa/ki+uRvsZl0oVl5MZKVrAFQhd882J1CLwCEVM071bSZXj5rHJ
         Cbdv9eMrcCUff8qfJS/2sdAb77+1N0MpMolCcRE4tHt0h8ydLOq4WITrxflZfBOLOpSH
         d1QrapfCEGAWbrUBjXC3UWWLxqEVroV3hIr63PsSUZ86CnQH+H1HT4r1FYLvAJTpRVq6
         aLkQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7tW2a4IBFjPZvqvh/NGSQ0HE2KCQJseSKupmHVDqGtqr/NDbj1B4IRyKpQlC7UbhKsTt0vH/A5w==@kvack.org
X-Gm-Message-State: AOJu0Yyl5vuEDm7EW/40mi/s1KfZGUxMDgj4JylWha/7B8sm8gA86nJW
	lbsncW4QOFk9m4FHkQ30vOba0z3lbwxnujtQSmZmTAHTZdmz0wlcnMEJyiqI/3s/Q9EZlnuSaxv
	zdQbXRw==
X-Google-Smtp-Source: AGHT+IFmiZvDW9+VEv8fXtsDHeyqGJSro010YRSFD/DT0a4vYVNsrLONxsLbwaaV3B5ySTybgRqQQLvhvsY=
X-Received: from pjbgg11.prod.google.com ([2002:a17:90b:a0b:b0:330:b9e9:7acc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a11c:b0:33e:779e:fa7f
 with SMTP id adf61e73a8af0-33e779efbf6mr1848603637.1.1761318666959; Fri, 24
 Oct 2025 08:11:06 -0700 (PDT)
Date: Fri, 24 Oct 2025 08:11:05 -0700
In-Reply-To: <diqzqzuse58c.fsf@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
 <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com> <diqz4irqg9qy.fsf@google.com>
 <diqzy0p2eet3.fsf@google.com> <aPlpKbHGea90IebS@google.com>
 <diqzv7k5emza.fsf@google.com> <aPpEPZ4YfrRHIkal@google.com> <diqzqzuse58c.fsf@google.com>
Message-ID: <aPuXCV0Aof0zihW9@google.com>
Subject: Re: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
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
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam05
X-Stat-Signature: fypzanb9mb8fgknpo4ekauueiwqywg3a
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A1868000E
X-HE-Tag: 1761318668-122103
X-HE-Meta: U2FsdGVkX1/BNHZqLEwJ/Qo4YALtNmxJkSHU/5JhJgPrkdpULmiadVwRQVD7EOaSKSBut+jd1xuWO2QYAsu5YgbtBl/5E9Lt1Pzbxh4fesi+KPqDMuKWYOaykC21XitFxJEOHoFErrWIYDmpq1VnnSovdtKyYxQabmGnbGXP3T+ism1P1zX9AZ6eFkPRI5hgC+j0LLSw5DGJNhqvdBuDoehJ/rr/y3co8NCGw3MNibPRjOHgJwyWSbCO3pMXBuNpRMq/NEW9NtI6DripM+Ke8KlYPZ70ix7zHbU10zcJEIZul7atJzuaM4twBoEo5rAUEPf6U7D0S+XnApKKrnEcmpA+JkaG5Q/qNu677P1CZ7dxfIKRA550jOCAmPLb1waRocxJETs1hu4hYji+jM24013BRrVRZ0cO5AlazqznQ84ShwOc6LAdqUHix9AMY85vreTl0gHvhT/1sptp11HyvGt1q4ydji1Z7WY6iGCOx68ArMa/X71WeT+lKZyLi++RTGDQOfoFwbgj/QpqdHu3pax69oXmmivM/nG6DdyrxLbE1Wvwfmso7N6e1D9ICm/pBz4DnvmZP/nUsOCVQY7iHKht4V0eFLNtLw4fCMgKJWC2mCl+Nrwv3OpQYAlhCSYmM4rYM0e0/JLfGf+QfoDUk0CAiomB3dZ/stvfdca/i7oZ3+uMcFCVE/k+9VV8/bqS4UAQQ+8EQgrvQA7xhnBL08R2uhzbcNdad+xXMdUD4Qn2Y5RCqrT8bzYbUvDmX80NWxHjMNSHm7I+hKl9xUYcHL5QIbrg/umJ3J5RWVxMJa2eCYeCBQZNJDaciN0JypyhT1M+DaBJ3tzmJxyJEUOSfzo/vC47TapUMO968NiIFghuhGlvWhKFXCnD1uRGJIK6/qTOev2HMgGKAL+u+KJhT16ppvlTBTGpi6e2SSsC84WpSI9sNqOnRMCl+/W4u8CzrwAdNiLa+vC2c+dXmOu
 1iqXqFle
 DKbO6TN/10e0m9YfhHGBDFPY4+NetsTzjm1MRmPL8qs37kTDTomMhIkeE5h0AJpoE75VoYP0R0wpcZzSsc7jKSK7xb6gPsAvIYh7/cfeYW1tSFLJeokKDkUVtN3rhfAZ5iN/sBeHa69iyI8MttLzLIxkdn8SMU8LxSqg2Ue3KdoewEfOTDeXuRAxgEB/tp0OGYuXX6cnmhuugvh4myett4UfMsmR8FUvo+WfmItkrsHolTgn1R/jUbqN46d2ZE+fXcdIWxTupCp5zdGOWhKPCUubpzA+bmYuaLOo+R/K0lnfa+hab5NqA1++OiyW8WrgtvkkV4TtGPliibA0UCPiM45dZ6VfSG7jmvEv68+N3K1jfCZGx61LHEav4dEiCVwP1MZ777gmHDsfMM1hzvqLpbExUTsQdyqNgGzvbo+nDnikeWglAAHoanIDqaePJQYJqbXuyUAYOgrg3xzT7gTZUGgrb7+Z3E1BpRKSoxA62HzeapaNSmG10w7fR4VS7wD8Vh/+fbi6pLyws2GXkvPsYT2b9QmUjm6f4jtCxIBTe/OBbrp/LgrxpEk58Yj/1K8wXxxjHu66ApysEdTCI++oeIaWNa55gqq6OZwksdTAo/Zaq2iXhihRFfVusYk3Xu+ECIT39mtB16BAI8M8rBHAYvLC/G26kjrlu7nfOCrFD5uoE2i4CH66vzaGuVSbf8vTBxEaR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> >> 
> >> [...snip...]
> >> 
> 
> I've been thinking more about this:
> 
>   #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>   	case KVM_CAP_MEMORY_ATTRIBUTES2:
>   	case KVM_CAP_MEMORY_ATTRIBUTES:
>   		if (!vm_memory_attributes)
>   			return 0;
>   
>   		return kvm_supported_mem_attributes(kvm);
>   #endif
> 
> And the purpose of adding KVM_CAP_MEMORY_ATTRIBUTES2 is that
> KVM_CAP_MEMORY_ATTRIBUTES2 tells userspace that
> KVM_SET_MEMORY_ATTRIBUTES2 is available iff there are valid
> attributes.
> 
> (So there's still a purpose)
> 
> Without valid attributes, userspace can't tell if it should use
> KVM_SET_MEMORY_ATTRIBUTES or the 2 version.

To do what?  If there are no attributes, userspace can't do anything useful anyways.

> I also added KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES, which tells
> userspace the valid attributes when calling KVM_SET_MEMORY_ATTRIBUTES2
> on a guest_memfd:

Ya, and that KVM_SET_MEMORY_ATTRIBUTES2 is supported on guest_memfd.

>   #ifdef CONFIG_KVM_GUEST_MEMFD
>   	case KVM_CAP_GUEST_MEMFD:
>   		return 1;
>   	case KVM_CAP_GUEST_MEMFD_FLAGS:
>   		return kvm_gmem_get_supported_flags(kvm);
>   	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
>   		if (vm_memory_attributes)
>   			return 0;
>   
>   		return kvm_supported_mem_attributes(kvm);
>   #endif
>   
> So to set memory attributes, userspace should

Userspace *can*.  User could also decide it only wants to support guest_memfd
attributes, e.g. because the platform admins controls the entire stack and built
their entire operation around in-place conversion.

>   if (kvm_check_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) > 0)
> 	use KVM_SET_MEMORY_ATTRIBUTES2 with guest_memfd
>   else if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES2) > 0)
>         use KVM_SET_MEMORY_ATTRIBUTES2 with VM fd
>   else if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES) > 0)
> 	use KVM_SET_MEMORY_ATTRIBUTES with VM fd
>   else
> 	can't set memory attributes
> 
> Something like that?

More or else, ya.

> In selftests there's this, when KVM_SET_USER_MEMORY_REGION2 was
> introduced:
> 
>   #define TEST_REQUIRE_SET_USER_MEMORY_REGION2()			\
> 	__TEST_REQUIRE(kvm_has_cap(KVM_CAP_USER_MEMORY2),	\
> 		       "KVM selftests now require KVM_SET_USER_MEMORY_REGION2 (introduced in v6.8)")
> 
> But looks like there's no direct equivalent for the introduction of
> KVM_SET_MEMORY_ATTRIBUTES2?

KVM_CAP_USER_MEMORY2 is the equivalent.

There's was no need to enumerate anything beyond yes/no, because
SET_USER_MEMORY_REGION2 didn't introduce new flags, it expanded the size of the
structure passed in from userspace so that KVM_CAP_GUEST_MEMFD could be introduced
without breaking backwards compatibility.

> The closest would be to add a TEST_REQUIRE_VALID_ATTRIBUTES() which
> checks KVM_CAP_MEMORY_ATTRIBUTES2 or
> KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES before making the vm or
> guest_memfd ioctl respsectively.

Yes.  This is what I did in my (never posted, but functional) version:

@@ -486,6 +488,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
        }
        guest_rng = new_guest_random_state(guest_random_seed);
        sync_global_to_guest(vm, guest_rng);
+       sync_global_to_guest(vm, kvm_has_gmem_attributes);
 
        kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
 
@@ -2319,6 +2333,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
        guest_random_seed = last_guest_seed = random();
        pr_info("Random seed: 0x%x\n", guest_random_seed);
 
+       kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
+
        kvm_selftest_arch_init();
 }
 
That way the core library code can pivot on gmem vs. VM attributes without having
to rely on tests to define anything.  E.g.

static inline void vm_mem_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
						uint64_t size, uint64_t attrs)
{
	if (kvm_has_gmem_attributes) {
		off_t fd_offset;
		uint64_t len;
		int fd;

		fd = kvm_gpa_to_guest_memfd(vm, gpa, &fd_offset, &len);
		TEST_ASSERT(len >= size, "Setting attributes beyond the length of a guest_memfd");
		gmem_set_memory_attributes(fd, fd_offset, size, attrs);
	} else {
		vm_set_memory_attributes(vm, gpa, size, attrs);
	}
}

