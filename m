Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB83C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C19A6B029A; Tue, 18 Aug 2026 12:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999336B0488; Tue, 18 Aug 2026 12:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888EF6B0536; Tue, 18 Aug 2026 12:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB826B029A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:10:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3FA4160142
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:10:35 +0000 (UTC)
X-FDA: 85114878030.18.A3A25C6
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf04.hostedemail.com (Postfix) with ESMTP id 15FC240002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:10:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t45o4rDx;
	spf=pass (imf04.hostedemail.com: domain of 3-IOEagkKCG0eLcfYdLSfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3-IOEagkKCG0eLcfYdLSfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787069434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHrQKH+zHwT+WPXcscvHx+YAi87Fp0trF0xTLxVXA3U=;
	b=Wf/LQOx8TCe149tE7gZZwCGzwb+Tr/95srmdfzJDoE5IsICALHZbsvnaU6khIJPWwir9wZ
	MN4VBWFQkwHgFXbO73l/a+zZT/PO2fPUcav6Av2FEJ1LY/DkauSp8FF2PcnZt/E2SHQqhy
	XHMe0yHOtxypZIzlpgSc4ZzBCu05Ec0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t45o4rDx;
	spf=pass (imf04.hostedemail.com: domain of 3-IOEagkKCG0eLcfYdLSfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3-IOEagkKCG0eLcfYdLSfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787069434;
	b=ClqZntsb8L8fOc1aBBZ8Wh1I21Gm2MteeaqI/mLX8CyS67Pph6lb1+JvcrLnYHAddhf8oL
	GdvmFDli14RKyD1Nu3Xsrqh0DKIuLjIwnzlDDpXDaRpiSqOp45ZRBylJG6RJtufzjdswMa
	RPYExBvFL2OyC3VeEykc2U7PYMHLraw=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a3f8cbd9feso120206a12.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787069432; x=1787674232; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mHrQKH+zHwT+WPXcscvHx+YAi87Fp0trF0xTLxVXA3U=;
        b=t45o4rDxxg4BOgdUdnIDW76u4uXBFZazgLCf7iO9OY4sWAarjA/3DiQTg2LsbnOkTf
         PZ94oYQtFsAjc8vLzqbH5OHpi+KDYNS4by41H/+4g94i5tfyR7fYAUShadduFByjUZow
         D9zhqh8DmGAt5NVNC5tQaju45thT0p3zFeOd5RsfDfHeddR0ZCTIIgeMQMgd8VIL2sYx
         YFyCqgolj/SD9Kx3upNgmycFTj+y112L+DESVBTJZa8kOu+KyKSkbIty0KaK51Km43ZZ
         /Rtora5HPn+cGCJ2Nldz0Ogj7i1bqHbPWhfHpD8jzTAeEZPWY+AVzRXNsLNbvWtZ6Oux
         Xk4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787069432; x=1787674232;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mHrQKH+zHwT+WPXcscvHx+YAi87Fp0trF0xTLxVXA3U=;
        b=Ep19GferBSrzWMkbYUCTukL2v+cxzm4OLqKqOfSV04t3CerfR1CFQwkJABMGep02+x
         dTa4E5PIDURPQJO+Ab0IGkW1CN3O65zREYYYbyZ2hHQSGLqKw0KNCIhT+XO2OcobRKuN
         Var7576L2+bVOkB8BLHtvyfFhBExBHSrLh63Vgndae5aAMHtbbW4MXJDOR2yyy0EA4PH
         Ff1g7hn7XE7j6g/oG9Fgh+lLsB8iXoQd3jksXM0fIML+iwHu4PLnx/0SPeGOSUn9ILjN
         Qfv+kSLiglcTo7MXh+Ai9F2bpQN9aiNfEyKrCqE5qfMWaWkCM5642Jp7BnTvwr1D69OJ
         ty7Q==
X-Forwarded-Encrypted: i=1; AHgh+RrlikbNH/6nAebACdF81p+X01hD4NVS7BaznqXxxwKwNlT7eW1NAkio++XKfKJ2N/4d55oq1GcPJA==@kvack.org
X-Gm-Message-State: AOJu0YxPBOhJHd4bXADt6UPnRi6XqJ9XqjBWm/vQIKdgeBWc+SphnLah
	fdM+0XzxlkRaLyhIOnGnjreAPaQQL0K41eGIqwswlo76DTTzAtqlMLeHJt1C42I/CAVduM4+v7R
	Qw4nPqVkB9rMT3p5ydw==
X-Received: from edts26.prod.google.com ([2002:aa7:cb1a:0:b0:6a1:f410:2ec5])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:210b:b0:6a0:a4f5:f4eb with SMTP id 4fb4d7f45d1cf-6a3e0fed785mr5782524a12.4.1787069432349;
 Tue, 18 Aug 2026 09:10:32 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:10:31 +0000
In-Reply-To: <anssOQFNZ2LfihbU@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-6-tarunsahu@google.com> <anphyjFv3FhF61iB@google.com>
 <2vxzpkzo51wg.fsf@kernel.org> <anssOQFNZ2LfihbU@google.com>
Message-ID: <9huzo6ezv288.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live updates
From: tarunsahu@google.com
To: Sean Christopherson <seanjc@google.com>, Pratyush Yadav <pratyush@kernel.org>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 15FC240002
X-Stat-Signature: 7j1owzc1x83qa7iynn4xnrgi64pjh1fn
X-Rspam-User: 
X-HE-Tag: 1787069433-472456
X-HE-Meta: U2FsdGVkX1+NEx6dfuWn4AsCvwSUI7C2w4vpBnITp7AqgmDhBr3bM8SJHmtwfaSEGrkR5Qu8mdJJzNOnEzRpoMQDWSpeIkUvOJOYfQKFyYhGerWKPPFheChGeezMcYMCKHQDuAHpVvuu/X10vkgADWcfKHL74P+PDxqaashMN9e8vQB0+79bsJ3D0dVqQ9J85uyzQYyuLYMk1WofXSPMWowmnTL7Xdm1mI/hF48mvKgtyEm9a2q+aUWEMsyLK66XOn3GxZMG/3yEjqE0wuCpGDBjCKZ3TqpD2EnL/XblO2o9v81TF1lz6uDVx84oH/+1X1yAZFDr4JuqxDod7lmiRI8pcAKqkAR/EYbEKpH5nfsaEp/2o0u+3UNd/k4Fv5yeSfWn4i9+4yyxm5hGfefOUMyhPCQDskJ0qIIrai8g8hU9K24NKnehc9Gi6MCpTmXqGNlT8AtC1PleDUwRmQup0Hwrtj4WcuhBgL9EMa3KF6NUQ8GNCaOm086moMWVfwVGQa8LjbvL1Dspjr317xMjg54HhCyydhfqMzt/Pmkp03XQVp1D080Hn5trIVcxp8QDfdZWvfsqYBsUQW6oe7sgHpHm1bis1Qph122cHWHOPYNI6g+DgusfxGEirDeO/dBgg/drK49hO9hVUvlXTTz3xjUKx8y14laZsZUzbLTwB9B4BaTO3HS2tSgOmU66/xI3LBolqGAAHSTSRWVLCbIQRbU+aSMEMGuDXV8BVbcf9NAn8QlUJO4LR7ax0Q98wmdumS54N9jBpiRtdqi+O1A2kBcKMkioctk8RJ6zAwBwYi4XbrcvXtbL1IW7FBmHVatPvWfOuBk07uCzQKq4zoqNDIAksv4dkO3x0ZYxlFga8aAzPiSHrl7j209pDPajuY1yHPl5gFqqgZAjs2ol7zBakElANE7W2igQzadYcQ+f3ymwCK4qxDTgEAm2jtJZlVEXXDCFjGhfQNBZOORNUJf
 MZwnq94U
 rCaB0NMvAU/wvQCFjoQV5L8CGOoaCSvtmtADXKzD2oTOi7wvFyb5MOlQMH4PfoxvGZc+0wt+O1vtGkJFqY1YALFK2LFP06N/mKti8E3Qi5P62Yr//kAM8+J8mhpKELNxLWfKM1k1aNGocIIpUa6+2PdKQp3LqoRsfTWLLbvaE/4kG9IJajQ3mDMr7dAYZ9jY5UtT6Eotspp8mH1UPGbiIALHVUrZAr0UuDran/kzbITSpbxI6rzBES6zLE3li0JInWqqwdrSF+sZ5XKDI8yD2ZWto7YZNmtMkkHY4kNXDeJiCJB+o2VZajRq6efQj2Km6Mz+07mQLRMz5EJYlp/cMKqBZCqxv2oMpYkdGlw2nsN9E27khVnxurFesCRAg8ae/PekRZ1gFmEe3zC1UFZfoeW4Zl9Q5gzDSMoOAb1TU/6+LVYfzgBdokCQcR1aMkEWmNhpMLGFOWGSFB+uaN04EhAU6OLklxU3A9JBGA/3sN6DCotAjD4fbnmSS9eSvh10OGyQHk+XhU47r5MFTDnmHv5E9LutOp0HECWcM1FdD5PVUILYOuYgFOMa/HIb9Y8WGKUhHF7dJtFJwzWNY4LHRWFsrN8/SD4PQiu5idv1ZgbJlzzWDTomu3DIEDcX7NdMEG5p4DTKos3jITurpuFtZDMs2xcLvm6DwSgrdkqSxIoj9UIr3LG4FWC9FrwS6OsZnTKiDsBDjpKKMLa3eWEfWbbylaggsFdRM9RukCGqx0sLU/g1yCLbqKeMCjxlUN5LRrTjxY0+hl5JgwH+7pDQBASDu75Hcrp6negd3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Aug 11, 2026, Pratyush Yadav wrote:
>> On Mon, Aug 10 2026, Sean Christopherson wrote:
>> 
>> > On Tue, Jul 28, 2026, Tarun Sahu wrote:
>> >> Register a Live Update Orchestrator (LUO) file handler for KVM VM files
>> >> to serialize and deserialize VM state across kexec live updates.
>> >> 
>> >> Currently, Only VM type (e.g. arch.vm_type on x86) is preserved as part
>> >> of VM preservation.
>> >
>> > Why?
>> >
>> >> On retrieval, kvm_luo_retrieve() recreates the KVM VM file via
>> >> kvm_create_vm_file() and use an atomically incremented ID for the internal
>> >> fdname, as the final fdname assigned by userspace is not yet known during
>> >> retrieval. As this fdname is only used in debugfs infra, This will not break
>> >> any UAPI.
>> >> 
>> >> This infrastructure establishes the foundation for preserving guest_memfd
>> >> instances across live updates, and can be expanded in the future to
>> >> preserve additional VM state.
>> >
>> > Uh, why guest_memfd?  As much as I want to push guest_memfd adoption, it seems
>> > guest_memfd should be the _last_ thing we support, not the first.  As evidenced
>> > by the last two decades, it's very doable to have KVM VMs without guest_memfd,
>> > but it's rather hard to have VMs without vCPUs.
>> 
>> You _can_ preserve vCPUs today using KVM_{GET,SET}_REGS, they just won't
>> run in the background during the reboot.
>
> What about x86 CoCo VMs?  Which are quite literally _the_ reason guest_memfd was
> created in the first place.
>
>> This series can save you from dumping VM memory to disk if it is backed by
>> guest_memfd.
>
> Or to word it another way, one _can_ save guest_memfd, it's just
> slower.
>
>
> My point is that this series needs to provide a _lot_ more information about the
> bigger KVM picture.

Yes, I agree. I will try to layout the plan.

End goal of this series is to preserve VM memory which is backed by
guest_memfd. Not all VM are backed by guest_memfd. So preservation of
KVM (vm_file) is independent of preservation of guest_memfd.
But guest_memefd can not be preserved without preserving the KVM (vm_file).
So I agree to your suggestion:

diff --git virt/kvm/Makefile.kvm virt/kvm/Makefile.kvm
index d047d4cf58c9..e6f098498795 100644
--- virt/kvm/Makefile.kvm
+++ virt/kvm/Makefile.kvm
@@ -13,3 +13,8 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
 kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
+
+ifdef CONFIG_LIVEUPDATE
+kvm-y += $(KVM)/kvm_luo.o
+kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd_luo.o
+endif

Guest_memfd can't be created alone without struct kvm
(kvm_gmem_create() and KVM_GMEM_CREATE ioctl). This is how
guest_memfd has been designed. I don't want to break this design which
has been accepted upstream after lot of discussion.

So while LUO preserve guest_memfd's data, It just preserve the PFNs
value, few flags that belongs to the guest_memfd.

On restore side in new kernel, These PFNs, flags will be populated
to a _newly_ created guest_memfd. that is how preservation and
retrieval works. So To create this new guest_memfd, We need struct
kvm (vm_file). this vm_file must be the same VM which had this
guest_memfd in old kernel, So we preserve the vm_file, get its TOKEN
preserve with guest_memfd and during restore, we create the guest_memfd
with the same VM (vm_file/struct kvm).

I agree, I did not do good job explaining things in commit message. I
will make sure to update them in next revision.

> For those of us that are on the very fringes of live update,
> it's practically impossible to review because, to us, it seems very arbitrary.
>
> The part that's especially confusing is the saving of the VM type.  That comes
> straight from userspace, so it's super bizarre to automatically save/restore that,
> but nothing else.

Like, guest_memfd needs struct kvm to create itself. struct kvm (vm_file) needs
vm_type to create itself (kvm_create_vm() or KVM_CREATE_VM IOCTL). LUO
does not provde functionality to pass any subsystem specific arguments. So
vm_type needs to be preserved even though, userspace is aware about it.

So Why do we preserve only vm_type:  To keep things simple for this
series, As target is guest_memfd.

Currently I dont have discreet plan on what else will
,in future, be needed to be preserved. Which I agree not a absoulute right
way to approach. I will layout a rough plan on KVM side preservation.

Having this need for backward compatiblity: I responded here:
https://lore.kernel.org/all/9huzv797v45k.fsf@tarunix.c.googlers.com/



>
>> >> +KVM LIVE UPDATE
>> >> +M:	Pasha Tatashin <pasha.tatashin@soleen.com>
>> >> +M:	Mike Rapoport <rppt@kernel.org>
>> >> +M:	Pratyush Yadav <pratyush@kernel.org>
>> >> +R:	Tarun Sahu <tarunsahu@google.com>
>> >> +L:	kexec@lists.infradead.org
>> >> +L:	kvm@vger.kernel.org
>> >> +S:	Maintained
>> >> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
>> >
>> > NAK on taking changes through a different tree.  This is KVM code, period.
>> >
>> > In general, I'm skeptical of the dedicated MAINTAINERS entry.  It's extremely
>> > difficult to tell since this series is little more than a skeleton (either that
>> > or liveupdate is way simpler that I was expecting), but I suspect that maintaining
>
> ...
>
>> > E.g. the LUO APIs seem pretty straightforward; I assume the bulk of the complexity
>> > is going to be in knowing what to save/restore, and how, which is much more about
>> > KVM than it is about liveupdate.
>> 
>> I think it is fine if you want to take these changes through the KVM
>> tree, but I would like live update maintainers to be listed as reviewers
>> at least.
>
> Why not simply add a file pattern match to the LIVE UPDATE entry?
>
> diff --git MAINTAINERS MAINTAINERS
> index 8014b9f8253e..2eb57b22c37f 100644
> --- MAINTAINERS
> +++ MAINTAINERS
> @@ -15052,8 +15052,8 @@ F:      include/linux/liveupdate.h
>  F:     include/uapi/linux/liveupdate.h
>  F:     kernel/liveupdate/
>  F:     lib/tests/liveupdate.c
> -F:     mm/memfd_luo.c
>  F:     tools/testing/selftests/liveupdate/
> +N:     [^a-z]luo
>  
>  LLC (802.2)
>  L:     netdev@vger.kernel.org
>
>> At the same time, I also keep being (pleasantly)
>> surprised at preservation being relatively simple. For example, the code
>> to preserve a shmem file (via memfd) is roughly 600 lines, a big chunk
>> of which is comments. The code of course has some limitations, but it is
>> good enough for use in production.
>> 
>> For one, we care about ABI breakages and versioning. 
>
> Which is amusing to me because that implies KVM does not, and I would hazard to
> guess that KVM has the biggest ABI surface of any subsystem in the kernel by a
> country mile (though I'm probably wildly underestimating the effective ABI surface
> of filesystems).
>
>> The serialized state is a part of live update ABI and changes to it should be
>> ACKed by us. 
>
> Meh, "Don't break userspace" is a universal rule in the kernel, I genuinely don't
> see why liveupdate needs special treatment.
>
>> For another, how the file handlers interact with their dependencies can
>> affect the behaviour that VMMs observe. Those changes should also pass by
>> some live update eyes.
>
> Perhaps in the short term, but IMO, that's not a winning strategy in the long
> term.  From my perspective, that like saying the PAGE CACHE maintainers should
> review every usage of the filemap APIs, because how the APIs are used impacts
> the page cache and affects userspace-visible behavior.  There are myriad analogies
> like that throughout the kernel.
>
> Yes, liveupdate is new and shiny, but IMO for it to be successful and maintainable,
> it needs to be treated like any other core infrastructure in the kernel, not a
> special snowflake whose details are known only by a handful of people.  Because
> I think it's likely liveupdate goes one of two ways: either liveupdate becomes a
> very niche thing that is used sparingly throughout the kernel, or it becomes a
> broadly used feature that is supported by many filesystems and subsystems.
>
> If liveupdate is relegated to niche status, then it probably isn't going to see
> a significant amount of ongoing development, at which point the folks working on
> liveupdate will naturally migrate to other projects, and maintenance will largely
> be left to subsystem maintainers.
>
> If liveupdate is broadly used, then having a single group of people maintain
> every subsystem's usage won't scale, and maintenance will again largely fall on
> the shoulder of subsystem maintainers.  Which is totally fine and working as
> intended, because that's exactly what subystem maintainers are signing up for
> by merging support for liveupdate.

