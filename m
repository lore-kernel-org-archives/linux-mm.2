Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4D4CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3487F8E00D9; Fri, 24 Oct 2025 12:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F8B68E00C9; Fri, 24 Oct 2025 12:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A648E00D9; Fri, 24 Oct 2025 12:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04ED08E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:48:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F1BB49A01
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:48:17 +0000 (UTC)
X-FDA: 84033590634.10.7197D30
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id 818B4C0011
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:48:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=v033FupG;
	spf=pass (imf22.hostedemail.com: domain of 3zq37aAsKCGcFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3zq37aAsKCGcFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761324495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0ZqooCPaM4r88VkiqaSJuwNdNXDKXHQHEd4a0Vhrkk=;
	b=baL5GyuxF71Hh4hOvDLLnBWvz5qiON5Xdq889aiBaQgaut13rYHt2KF+wqkmSUFhTCQ5bl
	8XFksW9tdGOoljtCNlp7FOquUaqwZD7OI1mqsiQCsO/2YJWaqHGUHwA1Abkyob+I7Y1ESe
	C8hUWl+t2sCe2fK1+063N+Tc8hQ9Aqo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=v033FupG;
	spf=pass (imf22.hostedemail.com: domain of 3zq37aAsKCGcFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3zq37aAsKCGcFHPJWQJdYSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761324495; a=rsa-sha256;
	cv=none;
	b=XUYE+0S1jLHC99Q+L95I937Z/sfsCB5LPUwCkBITQzY6KF5AOsnibMPkPGxF9fwAYWD3+2
	bKa8GP70IoF8udC2lBpCu8Srz8M1bPFP4MOGKjuXtPHcq7tomDJcyt6BGxqF9WtDAMh16/
	p3fhnQM4cYJhwn8OCZmUCoqT38kzk+Q=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-78105c10afdso2024245b3a.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761324494; x=1761929294; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N0ZqooCPaM4r88VkiqaSJuwNdNXDKXHQHEd4a0Vhrkk=;
        b=v033FupGkCWkC94WBDDdd593nmGkh+msCfNuNJIPo9TccGZKOQNe7XiAgi2B5Adzbz
         zJDIV9XDroE9MktSkhiRUW0PQxBY4Tei68TBxcOc06cbdmceqD4buPDObnwPC3O98YsJ
         zXBG2OW4nbFxUrhWCUeG8cxDXWIuAHKrHv1AFcx6kji/QjAbLXli/Q8XBo33C+x2pkId
         fAv1ssB0HdnltAlpMyD54OMWsVe4I00c9Q9BtpJQT22i74X7Df0d8EDXqvLov+TRC4yA
         P5iCOSJuteRYBZTOZZSJ6xeZ0hMkmzcBSrKcYtAP8KFDemTtErXdR718EROH980sEOH5
         z3rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761324494; x=1761929294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N0ZqooCPaM4r88VkiqaSJuwNdNXDKXHQHEd4a0Vhrkk=;
        b=EJHtg9cKZrYAaUWxNovPv6nyBcGkUFusBiTxii4zuj5tivljI7wP7c4YRM7ClKl8gv
         YfiOkn73dLzREAsW6KaeZ5K4zlMumkU4GWPAQvDuTLGECiTKxBmNp0DccaJQ4C6/CcoD
         D7ONYliP4cOJwnROdvqZIkSattH3+0jFbN/JN2W9HKmDpK0royrMHrG/HbckKS2/uKVJ
         XGvSrKdP4YBYynDJYgl6sj9pa4gF4G9hNBR7WGOB4JElu8V/MFgkndttDx1u05pgMh0v
         w44is0zFVMmg2/2EbbVW+kYGTVek7vI8yO/Lio17vfQ5lbyp8hAr4J3f+zuzisDAnJxl
         t4/w==
X-Forwarded-Encrypted: i=1; AJvYcCWvgPXweCp2/1iB9B6tgjODH5kNhZXZOknKecAS9Es711B0pQRTNyfLvL/WmjKuIFevCrY3AEQoGA==@kvack.org
X-Gm-Message-State: AOJu0Yw9J9vYs5rj4Kq26uUnGmfXlbhGK67SBT63JBV4bVxjfqAgfjYk
	i0hsOeURLTQv1+Xxh9MDhKxVQwnq3Yj8r8IUYAouVH7aFVefFhgqeB7nFTB0Lb6xqQ+dSV/1nDY
	8vAU+U9NIxjR79R7vPoz1ySkRvQ==
X-Google-Smtp-Source: AGHT+IEK36TdUsL0vlOCqmspe4caiObjbOIOsGdu4QEVuayy/5SWQrXbR3hmNgi0EJY8rePbH10nOdC3ZkaAHHoKBw==
X-Received: from pjyj23.prod.google.com ([2002:a17:90a:e617:b0:339:ae3b:2bc7])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:9988:b0:334:b8bb:b11d with SMTP id adf61e73a8af0-33dead4c65cmr3868140637.31.1761324494100;
 Fri, 24 Oct 2025 09:48:14 -0700 (PDT)
Date: Fri, 24 Oct 2025 09:48:12 -0700
In-Reply-To: <727482ec42baa50cb1488ad89d02e732defda3db.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <727482ec42baa50cb1488ad89d02e732defda3db.1760731772.git.ackerleytng@google.com>
Message-ID: <diqzldl0dz5f.fsf@google.com>
Subject: Re: [RFC PATCH v1 16/37] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, 
	mail@maciej.szmigiero.name, maobibo@loongson.cn, 
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org, 
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	peterx@redhat.com, pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, 
	qperret@google.com, richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, rostedt@goodmis.org, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shakeel.butt@linux.dev, shuah@kernel.org, 
	steven.price@arm.com, steven.sistare@oracle.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org, 
	willy@infradead.org, wyihan@google.com, xiaoyao.li@intel.com, 
	yan.y.zhao@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com, 
	zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 818B4C0011
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: y5qsbod6fi69sx6pbtp4b78xkq1p7rdb
X-HE-Tag: 1761324495-259122
X-HE-Meta: U2FsdGVkX187acIygGx0Hn6Q0117h+YthvK5JuhDxOaIsiQB0ROszLm2UUrSyuY9SaiYua0vFsjDsBMeg+ZO7l6dLpx21ttObHVoeYcgFSUCFgNAkkvuopvMcB7LI4fG3XfK2cyXW02cDQI5sU0xq6+VpiQj7cd3tTzEwIrdgJ8btP2Y0wRJBGVgdZKjp1CRjCC/sDwGUDbjAJVevcwTHcvPZiJt2qO3yJKSUTTuCSRPM0bbft8OcA0zR/euqml5+0H3+QBfe4djMIlO/dGT3uQXQPwzMhuEo56Fr2TuHsgN2Aj9czTfDyyArXC9QyhLXYpJBhO+zxjOcvfMMBKVPpIA74ylTtLw7K14Ktw4fjiQrqIrs+/PDSQYEU65MDmVF9/QVqIoJk/AqNavrUXXlq3caiiV9FXY8hGfXlIF8fxWcI+x6Sc8IoRSch4BmbeFUqeRlFQe3UKKvNYzTbXDlJTl3HpHz90Im6sW1/NmfYdRRATZ/5NLDWeDmFNsuIreS02w0uZF2oexbHHjubJfY1ZcZKaYfAIorxya3zfwsAyZ22i1rXLn5dSl838oWDE/l1A5hFzwHb7ULLOfxThq4oCNUoy+btPHlRfHjio//ou4ZkAy3339XHJX0EO+xwENICdTwX3u8UE9+s/wh/GB2+O3Q0BG3DFfUCZSiZ4SxFeYUrn/LVTAyZOnFXRTIW5kZ0vyNYPzunPwoioVaDDZ91aU5zzdTHWcH983dlq+OtYoyeMLt37T/SdZKCiQAfADL9IvMOPmCjCjEvRDQhLWAtWkSddckM0kPnn6hiHPPIDjI2lOeJbtP3ZRaWUMhKzMP0ZQv1ABY8pNjKp2jmjFfJMyynn584jNt8AQ1VEcIhX8DhhWxX81nXm8pwVcLuK2UuB6DBJOk5rY9cVNedzMQCeiLM34M+wgwSfuLoWLII0mYRlOsTwP0Q88ixbuedRwFOdaD5hJC9ccGklKvnr
 Cjvn3EAL
 2jq5MfrhclnPepY8Y1Amrr9Eq5TBmVjwsPgOBwdOAY5Amte5ULYLQppce4zG+EhWJ+kro5v70VcRlLE39s+7UVWJ+yjSkBOnk2+SKGzQ3PiSFBSc5f4CFLOuYo0hdDsSsBKxzxdFgfrXRvEsMFti+tObicHJOvcGsYX0wunl/akwcDU8Ke5t3zT6EdVjd6aFim7ErV69Liy8CXjsb8D2wP51EBA99uAGmZ81C+L6aXbRP3e295GY0WYoai80eHPzLXTD2ebAti1lIVI5jNozCJfZirpeb+MlpknfEqZjC2L+rMWNO1VTITnqQ1ILnVJ9fl0xig3y8gxVjzSxxlJRajFp3xrA/jqV77vOHd1q86yVeGdRges86FeUbeK3eMhUX1vzjmfG03CiLH7kXegqFlNZ9i+VGKp+3M0wiExNebaxNDOkl1gQoGYyqp9lbzPIckR9NiYfXavjZTlo0keLOGv7W7oHiORqcgZPwp84XuP+nK7OKN4cZAqIe8sWx6ThLCQNwCYE62N77PhHakMHoObHyDYXrZ6wVr/WQvEXcS6unjmrzJAoeEbUe6FyjFJo3rw1fySP6b46uSqJ2xi2jTltv/5S84fCWIdidx9NbfOZ4NObuZxVisezaULD5lDT3kvqRRMpqhYLCvOdfmCVUAz42E8P8oVSzg9k5nOJkFhABFMRdOe0IKFcpPNv5myIDeCvOh/+Rzjmshh4eSLTnp8F9PVyWA0BX0mjLhgADCngOOx2+QSKqgmVA1JTYqt6tdzOcTeZgndXmCck=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> From: Sean Christopherson <seanjc@google.com>
>
> Accept gmem_flags in vm_mem_add() to be able to create a guest_memfd within
> vm_mem_add().
>
> When vm_mem_add() is used to set up a guest_memfd for a memslot, set up the
> provided (or created) gmem_fd as the fd for the user memory region. This
> makes it available to be mmap()-ed from just like fds from other memory
> sources. mmap() from guest_memfd using the provided gmem_flags and
> gmem_offset.
>
> Add a kvm_slot_to_fd() helper to provide convenient access to the file
> descriptor of a memslot.
>
> Update existing callers of vm_mem_add() to pass 0 for gmem_flags to
> preserve existing behavior.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> [For guest_memfds, mmap() using gmem_offset instead of 0 all the time.]
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h |  7 ++++++-
>  tools/testing/selftests/kvm/lib/kvm_util.c     | 18 ++++++++++--------
>  .../kvm/x86/private_mem_conversions_test.c     |  2 +-
>  3 files changed, 17 insertions(+), 10 deletions(-)
>
> 
> [...snip...]
> 
> @@ -1050,13 +1049,16 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  	}
>  
>  	region->fd = -1;
> -	if (backing_src_is_shared(src_type))
> +	if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP)
> +		region->fd = kvm_dup(gmem_fd);
> +	else if (backing_src_is_shared(src_type))
>  		region->fd = kvm_memfd_alloc(region->mmap_size,
>  					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
>  

Doing this makes it hard to test the legacy dual-backing case.

It actually broke x86/private_mem_conversions_test for the legacy
dual-backing case because there's no way to mmap or provide a
userspace_address from the memory provider that is not guest_memfd, as
determined by src_type.

I didn't test the legacy dual-backing case before posting this RFC and
probably should have.

> -	region->mmap_start = kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
> -				      vm_mem_backing_src_alias(src_type)->flag,
> -				      region->fd);
> +	mmap_offset = flags & KVM_MEM_GUEST_MEMFD ? gmem_offset : 0;
> +	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
> +					vm_mem_backing_src_alias(src_type)->flag,
> +					region->fd, mmap_offset);
>  
>  	TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
>  		    region->mmap_start == align_ptr_up(region->mmap_start, backing_src_pagesz),
> @@ -1117,7 +1119,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>  				 uint64_t gpa, uint32_t slot, uint64_t npages,
>  				 uint32_t flags)
>  {
> -	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0);
> +	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0, 0);
>  }
>  
>  /*
> diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> index 1969f4ab9b280..41f6b38f04071 100644
> --- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> +++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
> @@ -399,7 +399,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
>  	for (i = 0; i < nr_memslots; i++)
>  		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
>  			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
> -			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i);
> +			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
>  
>  	for (i = 0; i < nr_vcpus; i++) {
>  		uint64_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
> -- 
> 2.51.0.858.gf9c4a03a3a-goog

