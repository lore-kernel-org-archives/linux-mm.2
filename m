Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19CC1CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 18:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F2F8E00E8; Fri, 24 Oct 2025 14:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E764D8E00C9; Fri, 24 Oct 2025 14:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB3448E00E8; Fri, 24 Oct 2025 14:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA47A8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:19:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8801312A39C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:19:03 +0000 (UTC)
X-FDA: 84033819366.13.083B48A
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id BE3EEC0012
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:19:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=K3JaAMyq;
	spf=pass (imf22.hostedemail.com: domain of 3FMP7aAYKCNcL73GC59HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3FMP7aAYKCNcL73GC59HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761329941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdTxyUifw7MNQO0DnSkAJL4ChxKgMzzVSN+wxqVSJZ8=;
	b=B45UcYsGxJ4COS14jWk3oeJ+ZVJZTv8tT8ui+aaXVBNnLcjAwxt6D7FqT2lpZodGWmDiJX
	cxFZA49ehvbyytAzpJCXxd3CAX4136hjcW3bPcrAvPSaA2hnf8x+WhF33V4se3QnK3LT1x
	097l/UVKyDGR94cWmVmTCDtnrsoU/jg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=K3JaAMyq;
	spf=pass (imf22.hostedemail.com: domain of 3FMP7aAYKCNcL73GC59HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3FMP7aAYKCNcL73GC59HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761329941; a=rsa-sha256;
	cv=none;
	b=Zp4Wdo36cuWtzSnYQ9uKEdq6a9NNP3J5bSYKtn9lptBG3R5+9vPBwPvSVgNEr8pw8BtJxK
	I+JLLcVLpQiCcdN8UXg9n5h1CuSweZSqsD7p0KbA+ztSCI9NZ8CMqMbzQkGYZpgG+bqxmU
	hCsZr8YAMdqpEo9EIaeBbLqlgx38s2A=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb18b5659so1871234a91.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761329940; x=1761934740; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cdTxyUifw7MNQO0DnSkAJL4ChxKgMzzVSN+wxqVSJZ8=;
        b=K3JaAMyqc/+D1hB6BYrJ5a0PP+SsJhXgvLMPAdIeQnbS8LwZKdmxp7nbzPql6aD/Y/
         F6vMVup+lNSP/9sux8REn+ckT40YEU/AOYm5q5DeqQgWGFruuDXBEe9Zzx0EU+3iifb5
         rUWLcIf2+G2WAc21z4tvmEAw1tByx4XjkkzE/h4hZOyNGvI4IzUxJRWGQbfylKVoTlVZ
         ACrLElgLyIuA7k/nyjn2eUkd49naXx0K49v8CQ09tb7/OVk2MxBG0Bsb4TkDL0dAcavP
         nvIm4TcJRt8BIfRy9ibrybmMvPYJ9W3+NySZPADwrpT70/gm+kSJfatmxeGuDXnbhTv+
         VeTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761329940; x=1761934740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cdTxyUifw7MNQO0DnSkAJL4ChxKgMzzVSN+wxqVSJZ8=;
        b=PHn4YSPMqyk9OIRSOCqdi9qBb0CBYDMKxad4wDm3hO+HL1ek6/bOaKEsCzvbn9LIyb
         xc7inCOY5ZeHEOOCTbnHhn2343nXnIUpnurua5NH82shAy+P0tfRNdixiuzpDnYmskkN
         riI5oJ2nwrG+cwbrAFA5Gv0DoVIiCyY5oKdYE3hWdednuDgdZSRTMkwtTiCqYR2shQoZ
         L+RweuIjMGUo7b/w+3h2GPYSr3UgS1Y2gNYijVlcDgaZGEP7n5xkzVwGPYdSCMMBw03r
         LLxvhsS1BSicwPMeC+aoHsjw/kRyk531qDr0pd5cin6StmOgELmV564GbzXad2iX/WGU
         lITg==
X-Forwarded-Encrypted: i=1; AJvYcCUyssc3/azuIfHGih42+4uaC4eFpCHZr1UMAhk4pcyPsAcu3YMzhv20ZigjvvuYtqAMjT+/UK839g==@kvack.org
X-Gm-Message-State: AOJu0Ywy9EB+ClaibwqRyR+W1+1YMMprwFKv+OgkXGFILwGeO0bHihDZ
	jdnLsU2cZWR1E6iUHKcWNMY24Vq2jKzCXZESoEtr/oxbuW8QTJl+ckBvpTE3sSQyLfow76XTtZ+
	ft1DU+g==
X-Google-Smtp-Source: AGHT+IEwU7cgqhi7yxcDGgJmntbDXrYh2S5Lt4c3VipRpyfkwWodcxupSfQzFuZEDCpb4LtVbKjpe2rZJEE=
X-Received: from pjob9.prod.google.com ([2002:a17:90a:8c89:b0:33b:8aa1:75ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2247:b0:32d:e780:e9d5
 with SMTP id 98e67ed59e1d1-33bcf8e5f10mr38003967a91.22.1761329940388; Fri, 24
 Oct 2025 11:19:00 -0700 (PDT)
Date: Fri, 24 Oct 2025 11:18:58 -0700
In-Reply-To: <diqzldl0dz5f.fsf@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <727482ec42baa50cb1488ad89d02e732defda3db.1760731772.git.ackerleytng@google.com>
 <diqzldl0dz5f.fsf@google.com>
Message-ID: <aPvDEl0kGdZfcAD9@google.com>
Subject: Re: [RFC PATCH v1 16/37] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
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
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: BE3EEC0012
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9cajt71yunnyeipe7ueh4gp9kx9bt7ta
X-HE-Tag: 1761329941-260056
X-HE-Meta: U2FsdGVkX1+NR4Fmyeog3fPLXiGzMcG+09310uS+Ul29WmAvMGJW3sM2tP98+Epfai0CwQPazyoa6iwz5DJBHphrOCC5zenAkaWRoqAOreK24GiT7DzZtOmVnNYL7W6xBXmfl8ug1z7QX57ThsRgWDAGIN8NI3UmzUp5a5FJgM61qFc8xwHtRZ8AmyfnD9MCIp3TBplROKbr4OHcxHe9IjgEDF5wyamrjwsqr0YY6rD9EsO2ilXt2HKlCPnp+wLRe1vJR4WyN1uZL+Z4TsRL3/ekrdZHTxrcQpmnmovkwkMJ8bHJiRbSjCaBh80RbbajANcQrIYXjfmSbcBGHGjxq24a2Mive/zAzQ0l+Pt8RabGfiIWQxBmIQgUBBITOrbQa46NKdPu9DK510+gkTogeJKW8KiPvqcwRjnHb+LQNekWCeh0w2ptr563brot49vTYgEW0myoj7fXHz3zbn3iqH60oyEEgwHS99fs+F+uq9Z62PJbChlf4FffGUclkuzs/5EBovQRZY16uC6qDtWwOfdJMAfI545Nt2UN3AebQBlS4AL7rEanx3y4lBJ99PZtiUK/8/OWfl1RlEnZTqzbM/vIo/cfy0VvHZ3lq9om2+fgybvkrIYW2FBLg+OAJqDqJypoI5aNFIPczBN2SWTDSzMCaKjbftaL9JE9pf78b9hdTwdfdrbOd9mFMlX0aA3fvlY8O+euCy89S67Y7CXbnVryvsUFnFieXemcDYbCC2M1L1YkUSher6ZxsZS/lLaqzBKPvNHZ+BdI71tFxNDefDQ9ZG58E0/ILJieJISl1tdXCyhrjud+LC/JdaWZ3t8YY7IsmRAGOO1KEUsZBx1zBvH1to9N4SNy6s7LIWTqmLUDjVReItAdc1CFCAx2ctLwt4cLk85Qrv2sgXG4inkbQD0gOnM74mrMhGw8ycIMY6wMg+Oi0zhNJTQNep5mlMjqyMIgQl7aG2Vxacwey2Q
 sP0xE1VI
 i0Ztv+4PPmuV/StC1oe7yNayAz2vrMVx1xaOtqQWRccxY1fPEKZxldnvwk7DKVrgwePUJY477adapqGgnl62V8vHkDU8lxAs76VH8cxZijNFNMK/oAFMhIvGdgunfgvRhvgStKboB5b8Av+kgYRHPvZoOYwiuizepU9FnwBjsK8sZhvyg+YZtCb1t6YmYRDRRweqZWS0yy1Grqn+M3Pdn/XcoWRsk7OqjvWocLIC4b+CQdf+vy6HT0hKJbb4UaCHCtS5XuuQQCFTgcuBHEepnxgpbt3pucdBDAUt/owNf1eoacYq6cftKTdZLBOgcnC0gCVwHv1LN1UhQOyYba8mgnGt0xPV0uUUMKjZWL9FH39jB59rhrB48rjc4lo0oEw02aIWnmLxR84J50k3dFqLxxuCYzdHjJutLGS9NSrdoAjg4y9PEFMI5ijt6kjQKoIlGBbs5HfxIorA4HK10zBh4ejwrtJ2xGlX/L0igCsRMQduRdymjM1iASO9quYacPiUCHkleyyxuw4pW2ZUX86bV1uYR7xHd+aLuXOacXpU0WvhasGkOjP55lzcccw1cmmitADnxtqmclqETyjAMijPP6OQRz5AX0PPAKZJ6dw/8s2Ui+pMIyt4PB3f8y4mz0YYGxUATHk9lUlIjD99of3KKA38fdEhHLG5sP/LFDKvOTDFnaciSQhK3yfpU8XN5sNyr2CHnoQIuZ6AjI3CKPXwBntwxlpJgns8azhzP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
> > From: Sean Christopherson <seanjc@google.com>
> >
> > Accept gmem_flags in vm_mem_add() to be able to create a guest_memfd within
> > vm_mem_add().
> >
> > When vm_mem_add() is used to set up a guest_memfd for a memslot, set up the
> > provided (or created) gmem_fd as the fd for the user memory region. This
> > makes it available to be mmap()-ed from just like fds from other memory
> > sources. mmap() from guest_memfd using the provided gmem_flags and
> > gmem_offset.
> >
> > Add a kvm_slot_to_fd() helper to provide convenient access to the file
> > descriptor of a memslot.
> >
> > Update existing callers of vm_mem_add() to pass 0 for gmem_flags to
> > preserve existing behavior.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > [For guest_memfds, mmap() using gmem_offset instead of 0 all the time.]
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/kvm_util.h |  7 ++++++-
> >  tools/testing/selftests/kvm/lib/kvm_util.c     | 18 ++++++++++--------
> >  .../kvm/x86/private_mem_conversions_test.c     |  2 +-
> >  3 files changed, 17 insertions(+), 10 deletions(-)
> >
> > 
> > [...snip...]
> > 
> > @@ -1050,13 +1049,16 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
> >  	}
> >  
> >  	region->fd = -1;
> > -	if (backing_src_is_shared(src_type))
> > +	if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP)
> > +		region->fd = kvm_dup(gmem_fd);
> > +	else if (backing_src_is_shared(src_type))
> >  		region->fd = kvm_memfd_alloc(region->mmap_size,
> >  					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
> >  
> 
> Doing this makes it hard to test the legacy dual-backing case.
> 
> It actually broke x86/private_mem_conversions_test for the legacy
> dual-backing case because there's no way to mmap or provide a
> userspace_address from the memory provider that is not guest_memfd, as
> determined by src_type.

Yes there is.  This patch is a giant nop.  The only thing that the core library
doesn't support is mmap() on guest_memfd *and* the other src_type, and IMO that
is big "don't care", because KVM doesn't even support that combination:

	if (kvm_gmem_supports_mmap(inode))
		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;

I mean, we _could_ test that KVM ignores the hva for mapping, but that's a
different and unique test entirely.

I did break x86/private_mem_conversions_test (I could have sworn I tested, *sigh*),
but the bug is in:

  KVM: selftests: Provide function to look up guest_memfd details from gpa

not here.  And it's a trivial /facepalm-style fix:

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ee5b63f7cb50..23a8676fee6d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1680,7 +1680,7 @@ int kvm_gpa_to_guest_memfd(struct kvm_vm *vm, vm_paddr_t gpa, off_t *fd_offset,
        gpa_offset = gpa - region->region.guest_phys_addr;
        *fd_offset = region->region.guest_memfd_offset + gpa_offset;
        *nr_bytes = region->region.memory_size - gpa_offset;
-       return region->fd;
+       return region->region.guest_memfd;
 }
 
 /* Create an interrupt controller chip for the specified VM. */

