Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 921BACCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 12:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9BA8004F; Mon, 27 Oct 2025 08:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1538000A; Mon, 27 Oct 2025 08:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC69A8004F; Mon, 27 Oct 2025 08:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC99B8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:51:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9DC3D1604F1
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:51:15 +0000 (UTC)
X-FDA: 84043879710.20.1BB66FB
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id CEEEE140008
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:51:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l9GhZ7TL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3wGr_aAsKCOEDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3wGr_aAsKCOEDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761569473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AyFD6g3VBvR49cMfgS8niFKClPpT1OiUWbHICnlNzwM=;
	b=j8kf1blTkoq4U2v1g96ZqDznoiT6M9ueuSAjLOlkZXYp5JcOyuhQSunTlgLiyFcJHmkKh7
	ae9jSES/fno4UoAzxyBc97MS54hK27vc2RuVxNePXLiaLZ0X3bmlQ8KuCYRHpYrwlTcU2x
	76ANaEgo7QsLVB8tON96c2LnLQ5BcMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761569473; a=rsa-sha256;
	cv=none;
	b=6QgIRqdfaw6/jiNOZekKIPLZxrMHadDs92c4hfyi8pXdLuvAhP+/8iZVaNfIOjz1VjbVrW
	Rqtd1C5Ndac1CaVkyJrdMIoD8mvF6FzAT9cxZGVyeExBUtBHVWi9L0ypGX8XIqNC6jOf3X
	moTrbp1rjMpv/ucp+n3cEiesRv7qDaE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l9GhZ7TL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3wGr_aAsKCOEDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3wGr_aAsKCOEDFNHUOHbWQJJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb18b5659so3784454a91.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761569473; x=1762174273; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AyFD6g3VBvR49cMfgS8niFKClPpT1OiUWbHICnlNzwM=;
        b=l9GhZ7TLeHGTNfzAiUnBcS6tZBHINCjlga3ee7/a3WePWVAkl6QYvUJODkRzD5sqFp
         PM5ZuxoaGnDVBNzhXaQYp661Cj+trnBbqQ/9M6IX7ynK4nOcN4OduXSnlHgzDo44E+Av
         GIxHoFEEejsVoZES5vwgS95KFooJCd9aOluIYN8e+zyFdU6Pi/OohTT7iZ4wuIxc0ASe
         SFg0/JabNhKVaDgRvGutb0vL+f4VClqsyddAk/39/fGEAt4TkhsjrEPBEuVR1TpMqqxp
         5VqS1a+EMe1fPxLunmTY+yd5AtnPUEhCjkKtTkgwcx1KcWq2C/1qbl1A/XoV4gCb/gvI
         vHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761569473; x=1762174273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AyFD6g3VBvR49cMfgS8niFKClPpT1OiUWbHICnlNzwM=;
        b=E/LdYbfsb+VJr6CTyJNAprjoL9JK48AeNMgKFnnCe9GunwMcN9xfdHqeSgKx+H/rxb
         z0CjqBZ3RmtKeJPHgqe9brcoy/erjcHduiEfhFyVgLtap2MVG12VgUczIgwXsqKWAEtJ
         v/ps/uHFl11+T45ODqyQ5Zw0fQ/r1VNM5SdDcXSRSMsZbUHf+IZWlndJfKWNXXHyUU01
         cfx2KVaGnrBQygkSsvNKI3gIyGyyYIDakcyjFIy9mekHtBz98ffrTZEAvGLzcBIeDCKi
         FvSHRjrv9WH/qB8MlRvEkpiFLVWoMd8n0iOzP1F+WKF4PSc4+4hgOxCGRx+/GQva6BIb
         +DCg==
X-Forwarded-Encrypted: i=1; AJvYcCWzR3FoBgXwCNijIAt3uR9uFwUT73NfLU3Ftc5cAzWLKFWSrkUssXzitvDSdFaausYRQGmUQEPCbQ==@kvack.org
X-Gm-Message-State: AOJu0YwO3d+2woM8cg/7NLrIu368It3YgVdr/QkiFf3VctVErMBqUmBb
	VK6L3O8pWj3+RLB9xKcdaJETlWwfZgfiYxMR0EYgv868xK9iHG4A8GwNnvlF/e0HGP8UTr0Irym
	8eBwCF4ExkKNlhfgdPfBMwT+NGw==
X-Google-Smtp-Source: AGHT+IHpzLMnxvGPeWk8f7xz/g/ATtWvyisZTfCa5aljb0u8eC/vwPSWrWHsFNePjKreSc0j11QMICkHErRNy2JiYA==
X-Received: from pjbcp12.prod.google.com ([2002:a17:90a:fb8c:b0:339:ee99:5e9b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d8f:b0:335:2eee:19dc with SMTP id 98e67ed59e1d1-33bcf8f94b6mr44662881a91.28.1761569472526;
 Mon, 27 Oct 2025 05:51:12 -0700 (PDT)
Date: Mon, 27 Oct 2025 05:51:10 -0700
In-Reply-To: <aPvDEl0kGdZfcAD9@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <727482ec42baa50cb1488ad89d02e732defda3db.1760731772.git.ackerleytng@google.com>
 <diqzldl0dz5f.fsf@google.com> <aPvDEl0kGdZfcAD9@google.com>
Message-ID: <diqza51cjyo1.fsf@google.com>
Subject: Re: [RFC PATCH v1 16/37] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
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
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: 1oapqp8jux8413sfffukxgxoj6ca3fq8
X-Rspam-User: 
X-Rspamd-Queue-Id: CEEEE140008
X-HE-Tag: 1761569473-40198
X-HE-Meta: U2FsdGVkX193GVFlUDW6kuu0R0UG9LhiyODg2eWnf6iBp+fmjfkvIqytz18GRRv1xhwljx4xkntbfTvvGiLLnBg5nmz7p6YlJluqfctaCB5hjVVRNX4RXRhiEx79xdncbbYgtjfrPyiPXmwShEoJuC3WrfalwfKL0Eo47PNqd0vHW8yoIag+7o8G5cPj4RSkbU1R8r0B3loN+BkD5s2sPmZnAPBsl2ZUTsairEyzlEgNr4bRduY537uRG+DMke7yxrb8fAuNmkMEuRx0wAdmXS/WTWx4gc/HzwcYw8F5saErJHmXGgZ0acZHMw0gWQyjrrynz1t7QRMQfiulGzbMDrB5Xz6EEPzRjhGzzhT9MqSFTfG42C3vPVGZHckgK2gmP0BUsCZlRZC/Iucwqw02zM5RovZdVSd+TqHPCbsM4mXtxQv7x9KeJlsu55e7omYGFJv3DUllgv325OZOz8BWnJ6stp+e9BEdWZT9e8goqDqwM34UHwiYta0uJCNbSaJtfSkkkH1qV0S9fSnLASayc7q6SWRSjsWkBtQQBQavntPrKttsB8dRfdn1es5jWcIjiUMhP5wRcy1Qad0YH1VFfSqYRqdSOqXcfOwHXkdHF+V9kRR1vQ0SYOVVyvY0SgWO7E2mQ29RwmSuPQ3XTNkDmIubA/RRVPAOdKv3xVmhxYRVgoPsrlDWMgBHhf8UmWLvkRw8zJHXyjfF2KP6QDwkm0ekDKtZNQ2EOIx9QD5RrGvU8wg0MVc+iaOzVWSD+L5NB7kRVDqBdsfbIPzPjOVW8OXD3rwTURi2eBGBPYL+GTGUgxCedIjOzsz7dSExZsSUzh2PflY1duFo5Y02+lk0ZDN0a1WSgNUi4bRCQPPAL91Czt31Qb/cow3oz9IDy+c2EIxb6zViKInxeu43nhMeY2KtrqLbpkWcJ1jvzwenlDsUG44Ypf4m2DkuzGfbzkPN2G5DsFcfAieNkTVWFEY
 K4yUUFyt
 azfH9vRWc/RaUqR0MFIZQiFFPZmwXe18vklsCaHR9DznXwnToIHMBLNVO8G9NRwgtNYodhCK8i97sO77lK8XWyhqPeC1Gf/cnO7j95viZ8JjR98QUhXsDkbxzMgXnlMoZHLKl84KjkdsUdbGN2KVa6v0XxCoSqp863a7SqzwxmFXVayUzt5KN/eMvJLsXPwjkyU1R7nCm8oV4G7nGN7qM5Kr6msLL89dN04m0T3p4Z8UNtULyn0LC1Z5zrxh7PQVCps0d9Lj/3CMQhXR7ONo3BavQMf1HtpzVA/CB4dZLCh61sRyTB9ncaOpJVvwrdIYjXscO2LSap7vL6tz5fWsVigzVJpH5llCpaex0hoj5jmiErPbXMl2D8PIFs2GwwP0hh5yyGjOS0iAfabMpB1c+8VL6d+GMNth0A6bbRTso8FMK83sk1rMohM0wVl8bzcV3W+mzZZq/6E6p/JZK6Cue+LF32dwSAaMLYelTaiEiM0oYyzpGTS26PqIGuhmuOS69zcZb2usaHJ1IZKhGy7I4dFrRgiX1po4rIoXh5X7+AobwDw7/0+LD/CP3U/92sGsEhG6UccFd33MLpuOjq63a2u7/+LfoskWjxP71MD0nY5Lg7wvUM/pHyQTpc5LjzOXZjyRENoZIy9i59sBh2X8uIT0iyHCtfaDC6dg5j7LokkS+HHmSVrZ1WU7/3cfBpPO1wzmOcJdeQlNrnsbwV7t6ITrd//xWyPOtCdyZegSqe2xqhFB2YQ8+7ti3yiym4kR7j2tyzj9+Q7ugSL4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Oct 24, 2025, Ackerley Tng wrote:
>> Ackerley Tng <ackerleytng@google.com> writes:
>> 
>> > From: Sean Christopherson <seanjc@google.com>
>> >
>> > Accept gmem_flags in vm_mem_add() to be able to create a guest_memfd within
>> > vm_mem_add().
>> >
>> > When vm_mem_add() is used to set up a guest_memfd for a memslot, set up the
>> > provided (or created) gmem_fd as the fd for the user memory region. This
>> > makes it available to be mmap()-ed from just like fds from other memory
>> > sources. mmap() from guest_memfd using the provided gmem_flags and
>> > gmem_offset.
>> >
>> > Add a kvm_slot_to_fd() helper to provide convenient access to the file
>> > descriptor of a memslot.
>> >
>> > Update existing callers of vm_mem_add() to pass 0 for gmem_flags to
>> > preserve existing behavior.
>> >
>> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>> > [For guest_memfds, mmap() using gmem_offset instead of 0 all the time.]
>> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> > ---
>> >  tools/testing/selftests/kvm/include/kvm_util.h |  7 ++++++-
>> >  tools/testing/selftests/kvm/lib/kvm_util.c     | 18 ++++++++++--------
>> >  .../kvm/x86/private_mem_conversions_test.c     |  2 +-
>> >  3 files changed, 17 insertions(+), 10 deletions(-)
>> >
>> > 
>> > [...snip...]
>> > 
>> > @@ -1050,13 +1049,16 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>> >  	}
>> >  
>> >  	region->fd = -1;
>> > -	if (backing_src_is_shared(src_type))
>> > +	if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP)
>> > +		region->fd = kvm_dup(gmem_fd);
>> > +	else if (backing_src_is_shared(src_type))
>> >  		region->fd = kvm_memfd_alloc(region->mmap_size,
>> >  					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
>> >  
>> 
>> Doing this makes it hard to test the legacy dual-backing case.
>> 
>> It actually broke x86/private_mem_conversions_test for the legacy
>> dual-backing case because there's no way to mmap or provide a
>> userspace_address from the memory provider that is not guest_memfd, as
>> determined by src_type.
>
> Yes there is.  This patch is a giant nop.  The only thing that the core library
> doesn't support is mmap() on guest_memfd *and* the other src_type, and IMO that
> is big "don't care", because KVM doesn't even support that combination:
>
> 	if (kvm_gmem_supports_mmap(inode))
> 		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
>

Makes sense.

> I mean, we _could_ test that KVM ignores the hva for mapping, but that's a
> different and unique test entirely.
>
> I did break x86/private_mem_conversions_test (I could have sworn I tested, *sigh*),
> but the bug is in:
>
>   KVM: selftests: Provide function to look up guest_memfd details from gpa
>
> not here.  And it's a trivial /facepalm-style fix:
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index ee5b63f7cb50..23a8676fee6d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1680,7 +1680,7 @@ int kvm_gpa_to_guest_memfd(struct kvm_vm *vm, vm_paddr_t gpa, off_t *fd_offset,
>         gpa_offset = gpa - region->region.guest_phys_addr;
>         *fd_offset = region->region.guest_memfd_offset + gpa_offset;
>         *nr_bytes = region->region.memory_size - gpa_offset;
> -       return region->fd;
> +       return region->region.guest_memfd;
>  }
>  
>  /* Create an interrupt controller chip for the specified VM. */

This works. Thanks!

