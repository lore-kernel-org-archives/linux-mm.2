Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC13AC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 15:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A076A6B009D; Fri, 21 Aug 2026 11:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF246B009F; Fri, 21 Aug 2026 11:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3C56B00A0; Fri, 21 Aug 2026 11:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67C5E6B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:34:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1E37801A3
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:34:54 +0000 (UTC)
X-FDA: 85125674508.16.A167690
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf30.hostedemail.com (Postfix) with ESMTP id 31C0F8000A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:34:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rEqaaGga;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3G3CIagYKCHgoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3G3CIagYKCHgoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787326493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ti5oxrQTNw6Tr45mwB3Y4z0EOV4HeTrBLFVAFF1S+N4=;
	b=SpOqu2gQMPPj/+OzZPYVk+gSYKtNwRk0eZyxoJYzpH32MLZjJdcnhpxiw2YaFFPIR2M0jX
	Yj5tBUq1GDhutpzrwKRAE4kqL26KR7Z0Qs9S10e0FDFbuOnNTztTNn4uE9+EyU+Fn4WZIf
	equUI5/vWuNWc7VKr0L9b5/iVsA4kn4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rEqaaGga;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3G3CIagYKCHgoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3G3CIagYKCHgoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787326493;
	b=mnLJ2lYWrzO+tnVfA2poq9JHsyhs0I46CkugUt2P6FoBMv6uAsWhI5aArYhSv+Zz+xVtfi
	eVGSwxBO8lHcQ6VH7nV237XaxrZNyNAc6ARzpP58UurHmjVO6/HhL2vm4NFKIDhovkeHOR
	cdcHyTp2m5JFAPrAGoGYOZMuaCbdspU=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8484ba00601so1236456b3a.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787326492; x=1787931292; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ti5oxrQTNw6Tr45mwB3Y4z0EOV4HeTrBLFVAFF1S+N4=;
        b=rEqaaGga+q2FHBiqkvy3CUaBXELnR2HglXG6euTwWaOBDvVS/omqdWmtnGxRoV3n3C
         mkrHgNzPMZeN3gBEgitk/dmnl0pvD3lKLe5RceXUxJtyDyJuGA03frwuENyPlrrYKlyT
         iE5hkdFKCdkNWyehlfkdYiigadIWHqIXMWfdA4nqCao9H3xqp1UZZRAUHG47ZhX656tn
         jFxnpchOkJfUlDPEAQZXuUII5qhY/rCoLo0yXH2HgdcxENRFq883xYTTqLgdP1acDxXn
         yXavaYV0eeWVFGFJpwK3eXr798eE7R8++9NFJAtlVmuUex3oEeKkVP65io4yd6krG5R5
         uwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787326492; x=1787931292;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ti5oxrQTNw6Tr45mwB3Y4z0EOV4HeTrBLFVAFF1S+N4=;
        b=TrJvjw8/Cy1ZVpDTlz35N7FSZXTUupV+SHffvaWlvRaBqoMckZUnKkZCRbCckwj33J
         efUWKSQonNdEE44GmzkpedPyg8AAGnNqluDHTQOao8KwPUXFSwIjnrt3Ca4xa0oJLrpd
         8de/le0YV7ZPyd/+BmtokBNLee6+gJxXpzkvdNOg9gLTFmdo9xx9vDLLYERwN7RWJiR1
         nsTNZ+GtG+zWpdVs9Qndjb7oszhmrR9cuzQk7jlyadS7uuRfZRl5fMjLwkaUWjfx0rni
         vC2Mpc3xSo5neZKsE++LXqGo8KqZWobyqJdgrb56d4qk9ZbiBbay2Qfyg1yhPp2XehZW
         q1TA==
X-Forwarded-Encrypted: i=1; AHgh+Ro/rTATQFigU6jUb35R6MEooQpTL1gXah1xqr7myE6jvDeqvD+9FrtANcU2kPbuOzra4lEOzSLCPA==@kvack.org
X-Gm-Message-State: AFuF++nns3sNpu4De+K4XG4GHCv3p6MdHtAsTTxyjXM+Y9MFDc10ij08
	9334d34L02nIBMDPKoIZ3ps4gYHHkpLb95zRk2t2eEJfEhAHj3k5ZkJx4Wgd8vlZLSTlS+XofJ5
	F+jtucA==
X-Received: from pfdc3.prod.google.com ([2002:aa7:8c03:0:b0:84c:2e88:693d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:14d4:b0:84a:2fff:cef9
 with SMTP id d2e1a72fcca58-851f9f84b8emr10555555b3a.13.1787326491490; Fri, 21
 Aug 2026 08:34:51 -0700 (PDT)
Date: Fri, 21 Aug 2026 08:34:50 -0700
In-Reply-To: <2vxzy0dzy4gn.fsf@kernel.org>
Mime-Version: 1.0
References: <anphyjFv3FhF61iB@google.com> <2vxzpkzo51wg.fsf@kernel.org>
 <anssOQFNZ2LfihbU@google.com> <2vxzik5f311e.fsf@kernel.org>
 <anyObKiZIhfok5mk@google.com> <2vxzqzjz1x5f.fsf@kernel.org>
 <aoMcqp0gr06YXAPU@google.com> <2vxzy0e3zgqz.fsf@kernel.org>
 <aoSCCTTBn9D5hqzk@google.com> <2vxzy0dzy4gn.fsf@kernel.org>
Message-ID: <aohwGv6TRqPg9Dwx@google.com>
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live updates
From: Sean Christopherson <seanjc@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>, ackerleytng@google.com, fuad.tabba@linux.dev, 
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
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Queue-Id: 31C0F8000A
X-Rspamd-Server: rspam07
X-Stat-Signature: gh7kyirrrieq6oqu89w4rc1ccz8p998f
X-HE-Tag: 1787326493-974073
X-HE-Meta: U2FsdGVkX183Szy4jnoIoFC3LFS0misEottTTk18gbKsL8dSQIB7m9/O6ZFlirMPuUkC7UBP6nrdUfLN47buRScU4hT1JmiFvwmBl9Aqh1KGMeodTfhQGgMExZRU9j7hKA1QEtg8mmbrZL9biFQmG3awU2nwm+nXwFBU+ZLKmU1kyprqVoq/aUI7Z42ldqccOamHJw5s3BfHzUxXbAVn9WK21yCMTHkrMK5T/gqvGytjg17g5JNIbPIiYbRNKx5eYOEfEBHjj/dAculdzIG0AQurOmCeEmbNfTKod7l2lEfD2izbhAywPghx0xTd83kn+UmykyetTFu0nHxD3m9FDmz7cKnEFUZWFdcanm0WWeFScuWJDjW02XNl5IZbsmswMgJUJ9hi1sPh14MJ/IIipy/C1Lq5AdOoGdxSrl8tKYct6ogI0OUaKmEb3dqDKziyMDi4jUMX1wMMcfz6qyS/85wqkiAv//MxlrXHaze3Lx8u88rsISabJ23c+dvGCoS6KWmPcxfnmJ/zNkdBrBSAWAnihBZGSDY8SmbODod4Why+t7vmOfqYUJZSE98gRtZshScUsCf/52hPkJs3JdFCIpOzLih9eG4EWkXzg3ZFb5agF7wpzQQ2Rj4uCQ9fC8OdSJXyeVqP6dLyb0voZD19CukMVBsnFTzTu68c7KAR3PaXEbKR/9moscMrcQhBeuiopxTUvGmSzKbbA4ng/Z/iSM1x74/EgVTNhDK/7jQa0h4EJT9iYBc0GQbgw4z6y1muWP9UurufSgUomKIxdWhk87DVkQc0Cm6UTMz646u08UfQ5x1sH1Fjms8L/rErGZ512hJxiKr81cCwfmef8AZcj51uu28spNdtnRmbk8zva9NESQ6AY7XbZsqwVa/vlShfZ9LxY3mlFi/yQfYpu5SkCdv3fYyx9AM+AELrs3V5neZ4TPtZn50RFtLpRzJHcIXpDjU64RdxRKVgQarq2op
 xwiUjU9H
 B19MWg41PESx3bkUCq0b9t0AvhQiDq61Dpu4HncVwtP6ttkmFaJNsisq0FJUf0nW7+kxVwW4kW7qCq+EnhWLVZdYCMP3TEDOWVs/xC//8lD17SVK7qJ3CwhxNLmLEjQiuXFJF3YPE699MncyfMv+IeCkNXAig6CDIjQVexLiV0ic35zJxYkuF/GdJ/IKc4MAdMRF9EtjoawiSqvL/Ihhq9nZtGtdviy1tk0fl43demZXucTGMgjX3eLMdJ2zOH57ktyb6nZOgrcJsC+4CJDABnuCfO+TKwPcrsyYUNtoYuxOwMAPHx5WNAGVkV7LC56Tcf+YEert5kzirF8FU9xylzpvEypC18AhHDjSzIo1wxxr/S5FHXNpmMTP3O+wZCKbAIz2TNltigb6nZVjQI1uaxueBPIAqOcXL8pmiC1mf3m1M/mrZ3ygmEI+/rduN1ycrYAdRfpqOjbrKmAkWc7SMKhQ1nVryEJS7N7Q50fdV0tPtxrnVLBTSFV+Rg4DWI366Srx0Fik/0qTBzLA5tl+whuVM7XQrTdqDJNiTmwGvZOHJ9dY+8dJlyNXZPFJunA71n+xagubtQ1qAo2cdP5AfFC6ycuOY3WElb6TetseSzM752fdyyHUyKEIlvfPLeow7v+jE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026, Pratyush Yadav wrote:
> Hi Sean,
> 
> On Tue, Aug 18 2026, Sean Christopherson wrote:
> >> Does this idea of "backwards compatibility" sound acceptable to you, at
> >> least at a high level?
> >
> > No.
> >
> > It's probably fine for Google and other large companies that tightly control their
> > kernels and use cases, and have the resources to juggle the resulting complexity,
> > e.g. have kernel engineers on staff to track feature and dependencies, coordinate
> > and plan kernel upgrades, etc.
> >
> > It's not acceptable for upstream, where downstream consumers often run a distro
> > kernel, have much more varied use cases, and don't always have a horde of kernel
> > engineers on staff to help them thread the needle you describe above.  And if
> > supporting live update as a general feature for all users of the kernel isn't
> > being factored into design considerations, then that needs to change, otherwise
> > this is all dead in the water.
> >
> > I also don't see the point.  Maintaining a rigid save/restore ABI is annoying,
> > but it's not _hard_ (or at least, not _that_ hard), especially if there's a set
> > of well-documented best known practices that subsystems can follow, e.g. so that
> > individual subsystems don't need to learn painful lessons first-hand.  I genuinely
> > believe that maintaining the version hell you describe above would be more costly
> > in the long run than simply committing to full backwards compatibility within a
> > given subsystem.  I can imagine that enumerating what subsystems' information is
> > in the payload will require a different scheme, but for a given subsystem, I don't
> > see any reason to aim for anything less than full backwards compatibility.
> 
> Let's say for argument's sake that we commit for a fully stable
> backwards compatible ABI. Even then, you have to deal with multiple ABI
> versions.
> 
> Live update's ABI is more complex compared to KVM's save/restore ABI.
> For the KVM save/restore uAPI, you are largely describing architectural
> state like CPU registers, etc. These things don't evolve as fast and
> more or less stay the same.

Right, because nothing meaningful has changed in any architecture in the 20+
years since KVM has provided save/restore support, whereas guest_memfd looks
nothing like it did when it was introduced three years ago.

> Live update needs to describe the state of kernel objects. These are
> more complex

LOL, you might be the first to claim x86 virtualization isn't all that complex.

> and evolve faster.

The speed at which things change doesn't automatically mean we shouldn't strive
for backwards compatibility.  Yes, providing backwards compatibility requires
additional care and planning, and over time *might* lead to an ABI that is
difficult to maintain.  But IMO, that just makes it all the more important to
get the design right the first time, not that we shouldn't even try because it's
hard.

> For example, say you merge guest_memfd preservation today. Some time
> later, someone comes up with a more efficient data structure to track
> the folios in the file. You _have_ to make a backwards-incompatible ABI
> change to use this data structure.

Only if those details bleed into the ABI/contract.  I actually have a concrete
KVM (well, virtualization) example for this.

Intel's VMX architecture disallows direct memory accesses to the VMCS, and instead
requires software to access the VMCS via dedicated ISA, using architectural encoding
numbers to reference VMCS fields.  I.e. VMX decouples how data is stored in memory
(the data structures) from the ABI/contract with software (VMCS field encodings).

This allows Intel to optimize the data structures to be more efficient and performant
for each microarchitecture based on the features and properties of each uarch, all
without breaking backwards/forwards compatibility with software.

My favorite esoteric example is AR_BYTES packing.  For Haswell, Intel added an
optimization in ucode to allow saving/loading segment register state in a single
uop (IIRC).  The optimization was especially valuable for virtualization as it
shaved cycles off the VM-Enter/VM-Exit hot paths.  A key piece of the optimization
was it required the AR_BYTES metadata to be stored in 16 bits, but existing CPUs
stored AR_BYTES using 32 bits in an "unpacked" format.

Fortunately, because the in-memory representation was decoupled from the contract
with software, Intel could pack AR_BYTES into 16 bits for Haswell+ and pack/unpack
the data on VMWRITE/VMREAD, so that the format presented to software remained
unchanged.

Does VMX's decoupling of the in-memory represntation of a VMCS have downsides?
Absolutely.  Most notably, it incurs extra complexity (in software and hardware)
to achieve comparable performance to directly accessible data structures (AMD's
VMCB and Hyper-V's eVMCS) for nested virtualization.  And I'm sure it has placed
contraints on Intel's designs, and obviously introduces complexity into the
overall system by adding a layer of indirection.  But IMO the VMX architecture
has been a huge win overall for Intel.

> Or say you add a new memory backend (like the HugeTLB patches in
> flight). That likely will need a different ABI to describe the state of
> the guest_memfd.
> 
> So you will end up with multiple ABI versions that aren't always
> backwards compatible.

No, you end up with *features* that aren't backwards compatible.  I can't imagine
anyone will argue that we should never add new features because then we can't
rollback to an older kernel.

But adding a new feature shouldn't break the existing ABI.  E.g. adding support
for HugeTLB in guest_memfd shouldn't prevent rolling back to an older kernel when
the HugeTLB functionality isn't being used.

Using AMD's VMCB and Intel's VMCS as examples, literally every major new AMD/Intel
uarch extends the VMC{B,S} in some way, but without fail it's always done in a way
that is backwards compatible with existing software.  I.e. AMD and Intel ship new
features, but existing software continues to work, and VMs continue to be migratable
across CPU generations[*], with the obvious restriction that migrating a VM using
a feature introduced on generation N to a generation N-1 CPU isn't a smart idea.

[*] There are exceptions.  E.g. Intel removed MPX, and so VMs with MPX can't be
    migrated to newer CPUs.  Migrating between CPUs with different MAXPHYADDR is
    sketchy (and simply not done by some CSPs) because neither AMD nor Intel
    virtualizes MAXPHYADDR.  But those exceptions are absolutely Big Deals that
    undergo significant scrutiny, from all parties involved.

> If you refuse that idea too, then KVM live update will be dead in the
> water for a different reason. It will be damn near useless because it
> can't keep up with an evolving subsystem.
> 
> Now once you get multiple ABI versions and you can seamlessly go from
> old to new one, say you have a version that was superseded 5 years ago.
> It would be completely reasonable to say that this version is old enough
> and no one should be going from a 5 year old kernel to a modern one.

LOL, Google literally does this.  Granted, the extreme cases only happen for
stragglers, and I think we do force VMs to bounce through a "middle" kernel in
those cases, but I doubt Google is the only company that runs frankenkernels
for an absurd number of years for a variety of reasons.  E.g. 4.4 LTS was officially
supported for 6 years, and I'll bet dollars to donuts people ran it for much longer
than that.

> So you deprecate this ABI. Deprecating old unused uAPIs is not unprecedented.

When there are provably no users, or we can convince existing userspace to migrate
to an alternative.

> I think we are better off formalizing this deprecation period from the
> get go.

Why?  What does it buy us?  Because all I see is potential abuse and an excuse
for not spending time getting the designs right.

> A somewhat tangential example is BPF kfuncs. My BPF program that works
> in kernel X might not work in kernel Y because the kfunc has changed or
> been removed.
> 
> The argument they make in kfuncs.rst is that kfuncs "provide a kernel
> <-> kernel API, and thus are not bound by any of the strict stability
> restrictions associated with kernel <-> user UAPIs".

BPF's documentation isn't arguing anything, it's merely reiterating Linux's
long-standing policy that there is no such thing as a stable kernel ABI (in upstream).

> For LUO as well, this is a kernel -> kernel API.

Stating the obvious, I disagree with this.  As I said before, if this is the
stance LUO wants to take, then so be it, but my NAK stands.

> Users can also still do a regular kexec or reboot. They just won't get the
> performance optimization of LUO.

The amount of time, energy, and money poured into minimizing VM downtime on live
migration suggests the overwhelming majority of LUO's targeted users aren't going
to take kindly to this stance.

> Regardless of if you agree with the last bit about deprecating old
> versions, ABIs evolving with the subsystem is a ground reality of live
> update and it would be foolish to think we can do with only
> backwards-compatible ABI changes forever.

I never said the ABI is immutable, I said it needs to be backwards/forwards
compatible.

