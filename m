Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 920F0C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 15:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D0F16B010C; Wed, 12 Aug 2026 11:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680346B010E; Wed, 12 Aug 2026 11:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FB76B0113; Wed, 12 Aug 2026 11:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 259A86B010C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:17:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBBABC03E4
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:17:04 +0000 (UTC)
X-FDA: 85092970368.22.12A8081
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0D18EA0016
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:17:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rrNKrpOg;
	spf=pass (imf15.hostedemail.com: domain of 3bY58agYKCNYK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3bY58agYKCNYK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786547823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97wksvVZ+thl5LcpXUGbBxNzodsfrcBWwlOTdvF+br0=;
	b=uW1Oh2koSdivpa2nxBsQEhgaG5qnQ2f5Iae6KG6GGdA3xRYqBu3ij7/69ht5+UGBHoFbTi
	RVjY4M93iJkEM8gwWj0HZbeckRA7Xn1TCCT83j+sFUC/z17JWTwEdE66FwslXgd2d3BLAr
	Ty8UHMsavWJCofe28DzTYysPmp0cAEw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rrNKrpOg;
	spf=pass (imf15.hostedemail.com: domain of 3bY58agYKCNYK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3bY58agYKCNYK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786547823;
	b=HugYp52l8CLlUIEj0JJLvHRB3FTiXGn+vExu+x1TQewj7ZUEqRrYVJqGVCcGr+anvMznjl
	CxOt0yHuwz3gbRChlIblrUNFEgrIw9afUJqrwbo8WdM/t3uvt2gFSiPqJ7RnCwDJueFuj/
	S67en5Hl35Vad+jcE8FVSgbM37/6oJg=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84859a64079so1425814b3a.3
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786547822; x=1787152622; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=97wksvVZ+thl5LcpXUGbBxNzodsfrcBWwlOTdvF+br0=;
        b=rrNKrpOg0iK2w7w8TIZ6t7pK98ux9XjVSdkxXA2N6acRwY0yHggaLj0Bpdb0+gU3Us
         LZPU8q7lYBD4EmsQgsqMSGFEwgQvf5MZApAUpk76FBaX0d5OlBMk9INpIbJcRyVv3Ifa
         0UMm5kh5owYxJTMXGJcIP4gUMt6wQQLqpLYHccrM2Znckjbem8JELFFfBM7PUzImwXDJ
         XekxIp5jq6CaAjMfy0tIDWbV0w2TgVR2ydjJR1XXBG3fVdBozWVaAZ/tHE4Cyzo9fdKz
         I4dlHYUrwNXeH4JBlhl5TymPyZw+DTeSLb116CKaSzYXN5X7WG6gK4WocUPSIYeeZH7b
         4Xgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786547822; x=1787152622;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=97wksvVZ+thl5LcpXUGbBxNzodsfrcBWwlOTdvF+br0=;
        b=A9zv7/KW91ww91xm4eBhCcwvgMp+V2YMO7RkvGMPaMpRx/4o807gI9lxJLG/opgEYf
         t0AHGIruIut/yp8/FLqWjMi4YJD/8yFP651RfseqToXnXBOsC0eeOvD6mXcKBnAv/v1R
         cwyG7KvRiyo4vH8F33NguntBus4dFCPprWvmQSVy3AGANAaZ2FP4XC0DSSthl70s6JLX
         fycKEviX+KNiMLXCnS4ihjx8KQLJCTbo75L8oNr82W+bGd73zM8wvHaVspfzs6jBVnp8
         hkShB2jTmEIXvp+HU9rdVzd4joPs1A6/CMdMnECGFwZCUWndZ+YDZNdfVb7vkCIKKx/8
         Ktig==
X-Forwarded-Encrypted: i=1; AHgh+RrkLdX3KRgZrBHU/bwfDR1WcJwu3RCCsqdw8QZUZF1AsO9l9UC6zoS99y/fSzp/sCYqL/kpCLYMjw==@kvack.org
X-Gm-Message-State: AOJu0YyeXr315GQ9CWuReUabDLRR0Gd0CSOoD7uhQudqnCslVvsfCc9G
	7lvYu+IKAaiBWwTzokAnb+eEa1rb9TUvr7jMAd5/MZU7TU8uz4QQ1cmbulmyMCyiowKvfxy6uyY
	ift4sew==
X-Received: from pfbcv13.prod.google.com ([2002:a05:6a00:44cd:b0:847:7f5d:6b90])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4fc5:b0:845:4cb5:2343
 with SMTP id d2e1a72fcca58-84fb551821bmr6172462b3a.19.1786547821109; Wed, 12
 Aug 2026 08:17:01 -0700 (PDT)
Date: Wed, 12 Aug 2026 08:17:00 -0700
In-Reply-To: <2vxzik5f311e.fsf@kernel.org>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-6-tarunsahu@google.com> <anphyjFv3FhF61iB@google.com>
 <2vxzpkzo51wg.fsf@kernel.org> <anssOQFNZ2LfihbU@google.com> <2vxzik5f311e.fsf@kernel.org>
Message-ID: <anyObKiZIhfok5mk@google.com>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0D18EA0016
X-Stat-Signature: s6e8br93tonjugzfu7cq9n9f4s61wn86
X-Rspam-User: 
X-HE-Tag: 1786547822-843895
X-HE-Meta: U2FsdGVkX1841ria2gHbM711Y8DjKj4uDtfrGI/g5jRYKFKj1mr3+iRT9/4w6ed8b9s82TWq/jkqzfgm+6W9nL2DrxR/n4YM4rlJMYy0Nq1DtoFMKbsYimzkj5OSKmsJ4OGnIDqvfU8m1gp10y0peVSltcs++M+aM88VTuI9BE2Ynzuh26Eg+ip9rIeDldTGpk+t0mexajr/A2Ore8ybgGN3NIuMRmTJDS+bfsbJMgzOpS2puEmk86Kl1zX3mGNR5SBY/Hc6Vxlu2gi/xNz5fQI8HQR3dT8N55sa6GAdUmZfoAwcZrBB9CNzfUox3DTGPZqYKgn1GUe5kyF1QWscKHjnGH+7r/dnxLiph+FpZC3dM4MWTVfvwiVRQnsYhR+zKoR5bpWNufAmgl5aH+32Dj8s/3Kf1BPMEeihVTEG4/IRRU1Ec62uCq4AL5cyTzFpSVcC2zl/fpZTm4v6HK0QRNeEGoc0Ca3see6A0hKmNrs1JkE06BzGcOfsc2IRqXuHzRQ8ezZ+fwqf9Mq/pR9O5oU3w1qsYOqjH+Ul1Yyyz2URqPSAeUJU3qX2tUnzvbRrRKfV9ftea2Iv849ECrVRKqqy4H/tl4DmT7SklaMx1wh3JgVRjQhHUrFThuIz3Nx5t2Pw+yOU6njiB4aObGOF8qfqiND723mZywkEOX9rcFeEMBOdAypsqxhBERWX/gsHfQ9urZ80pmlB9GURSPezPT4FAz4MHVEcenOaVp9lVRl3nbN6uBGzjKnUU8BFDlOPsJOToYTJDTYDOmW9hudlqaQtUYpc9x6HqqMYXLV4yx7rxteqHEX+bK1/SUNs4cHA4jr8mjrGlLydRoF9Bm0btSpVRe/YBOIi4xfEdhZ+k2zVfphFzJqN1kU8F1YAkQtuU7GscyZwnYJaAPcmHU/fn1R9seOABuTOIwpyu9HDHp/rIs9pEKFM9t+I5RZaVgeeXz54PYzwEAcG2/KhKg2
 djpj5lpp
 WsLGbScVNN6RsDCXWssmKBbxgHYmb1kTW6dQV+qQwGt+atmStQLfLlFNGSypXYzaM1C910ULAUcbwp6JlJpUt789ziy3M01bYXZ78sXmz3jbYdBnmsEZmxA6aontXsw4MIrZu0uO5CrSip18a3iyBDOkeGgMUBWYrf3xedyWlYnGqT9064v0xuLnaJ/0++FnIvn2revk97aW3SeNqpFkd9yKHCYKooQd5olDUKqSeKmvIiT+an7xa9HDawSURJLm9SD3+Tn5x77BELlovKlYyAL5B/M7EsLM3pN/ILJt4fA0/YIuHvtdDwcwKvimv4/erYbbb+jB42gGoGErfKojSd6toKeFaCNBD5rxcVsIU3VnOPCn81jNbXI+ivlKE7xw6NticvfJQw+5HHZRZXU42UhRrs6weJ2pO7voNpIqkAFlZxhCjVE9sL6jIAURKmvILLIZl8iRJ5SHNsqHGNZTxcXfRGLg1kKDCZr0PrIn7Zg954fD0IsmfeG1iAYzESikUdp6gVzITRO4a8s3cUuTqXX4w4BJ5PErWJDdTkM8c7WBYV3fOZ9YX3JIIqrJ5nSbV7a4zJ4V45N16UJsc5WqxbZ2gPpyt7wSztdmplRyfFRkbJi9SMMU0tU6ROygcNzITRNZ1vWKkj2jzffB+bqI50FAf3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026, Pratyush Yadav wrote:
> On Tue, Aug 11 2026, Sean Christopherson wrote:
> 
> > On Tue, Aug 11, 2026, Pratyush Yadav wrote:
> >> On Mon, Aug 10 2026, Sean Christopherson wrote:
> >> 
> >> > On Tue, Jul 28, 2026, Tarun Sahu wrote:
> >> >> Register a Live Update Orchestrator (LUO) file handler for KVM VM files
> >> >> to serialize and deserialize VM state across kexec live updates.
> >> >> 
> >> >> Currently, Only VM type (e.g. arch.vm_type on x86) is preserved as part
> >> >> of VM preservation.
> >> >
> >> > Why?
> >> >
> >> >> On retrieval, kvm_luo_retrieve() recreates the KVM VM file via
> >> >> kvm_create_vm_file() and use an atomically incremented ID for the internal
> >> >> fdname, as the final fdname assigned by userspace is not yet known during
> >> >> retrieval. As this fdname is only used in debugfs infra, This will not break
> >> >> any UAPI.
> >> >> 
> >> >> This infrastructure establishes the foundation for preserving guest_memfd
> >> >> instances across live updates, and can be expanded in the future to
> >> >> preserve additional VM state.
> >> >
> >> > Uh, why guest_memfd?  As much as I want to push guest_memfd adoption, it seems
> >> > guest_memfd should be the _last_ thing we support, not the first.  As evidenced
> >> > by the last two decades, it's very doable to have KVM VMs without guest_memfd,
> >> > but it's rather hard to have VMs without vCPUs.
> >> 
> >> You _can_ preserve vCPUs today using KVM_{GET,SET}_REGS, they just won't
> >> run in the background during the reboot.
> >
> > What about x86 CoCo VMs?  Which are quite literally _the_ reason guest_memfd was
> > created in the first place.  
> 
> I don't know much about the history but I thought these days guest_memfd
> is used for more than just encrypted memory. I have seen talk of it
> being used for non-confidential VMs. For example these patches [0][1][2].

It's getting there, but it's all still very nascent.

> The CoCo parts can follow, but IIUC guest_memfd is being used to back
> guest memory on non-CoCo VMs too.

Not using upstream code, though there are most definitely folks using guest_memfd
in production with out-of-tree patches.

But that's all beside the point.  What I'm saying is that SNP and TDX *must* use
guest_memfd, whereas guest_memfd is optional for all other VM types.  And so adding
LUO support for guest_memfd without even sketching out a plan for CoCo VMs feels
backwards.

I'm not necessarily opposed to gradual guest_memfd support, but there needs to be
a clear plan of how all of this is going to fit together.  It doesn't need to be
perfect, and I'm sure we'll make mistakes along the way, but I want to at least
try not to paint ourselves into a corner, especially with respect to the ABI.

> >> > E.g. the LUO APIs seem pretty straightforward; I assume the bulk of the complexity
> >> > is going to be in knowing what to save/restore, and how, which is much more about
> >> > KVM than it is about liveupdate.
> >> 
> >> I think it is fine if you want to take these changes through the KVM
> >> tree, but I would like live update maintainers to be listed as reviewers
> >> at least.
> >
> > Why not simply add a file pattern match to the LIVE UPDATE entry?
> >
> > diff --git MAINTAINERS MAINTAINERS
> > index 8014b9f8253e..2eb57b22c37f 100644
> > --- MAINTAINERS
> > +++ MAINTAINERS
> > @@ -15052,8 +15052,8 @@ F:      include/linux/liveupdate.h
> >  F:     include/uapi/linux/liveupdate.h
> >  F:     kernel/liveupdate/
> >  F:     lib/tests/liveupdate.c
> > -F:     mm/memfd_luo.c
> >  F:     tools/testing/selftests/liveupdate/
> > +N:     [^a-z]luo
> >  
> >  LLC (802.2)
> >  L:     netdev@vger.kernel.org
> 
> This would list us as maintainers of kvm_luo.c and the tree as liveupdate.git, 

It would list both "LIVE UPDATE" and "KERNEL VIRTUAL MACHINE (KVM)", as KVM would
still cover the files via "F:	virt/kvm/*".  And my read of MAINTAINERS is that
N: and K: entries are "secondary" if the files/scope is covered by an F: entry.

E.g. arch/x86/kvm/vmx/tdx.c is covered by "KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)"
via "F:	arch/x86/kvm/*/", and also by "X86 TRUST DOMAIN EXTENSIONS (TDX)" via
"N:	tdx" (or maybe "K:	\b(tdx)"?  I haven't bothered to check which one
triggers).  And while I don't think there was ever any formal discussion, AFAIK
everyone reads the situation as KVM still being the primary maintainer/tree for
that code.

> both of which is something you're saying you _don't_ want.

No, what I don't want is a dedicated "KVM LIVE UPDATE" entry, because I think most
people would read "F:     virt/kvm/kvm_luo.c" and "F:     virt/kvm/guest_memfd_luo.c"
as being more precise than KVM's "F:   virt/kvm/*" and thus would read things as
"KVM LIVE UPDATE" being the primary maintainer.

In other words, I'm more than ok with LUO being looped in on KVM LUO changes and
having the authority to object to problematic changes, but I'm not ok with LUO
taking primary ownership of KVM code.

I realize there's more than a bit of nuance in my interpretation of N: and K:,
but again my experience with TDX is that so long as the maintainers are aligned
on expectations, it's a non-issue in practice.

> >> At the same time, I also keep being (pleasantly)
> >> surprised at preservation being relatively simple. For example, the code
> >> to preserve a shmem file (via memfd) is roughly 600 lines, a big chunk
> >> of which is comments. The code of course has some limitations, but it is
> >> good enough for use in production.
> >> 
> >> For one, we care about ABI breakages and versioning. 
> >
> > Which is amusing to me because that implies KVM does not, and I would hazard to
> 
> No, it doesn't. What I'm saying is I care about changes to the _live
> update ABI_. Just like you probably care about changes to KVM ABI but
> not so much about BPF for example.
> 
> > guess that KVM has the biggest ABI surface of any subsystem in the kernel by a
> > country mile (though I'm probably wildly underestimating the effective ABI surface
> > of filesystems).
> >
> >> The serialized state is a part of live update ABI and changes to it should be
> >> ACKed by us. 
> >
> > Meh, "Don't break userspace" is a universal rule in the kernel, I genuinely don't
> > see why liveupdate needs special treatment.
> 
> Ironically enough, you miss my point. I'm not talking about userspace
> ABI. We all know not to break that. I am talking about live update
> _serialization ABI_. See the stuff under include/linux/kho/abi. This
> series also adds things there.

No, I understand exactly what ABI you're talking about.

> This is ABI between kernels. It needs to be stable-ish so you can move
> from one kernel version to another. At the same time, unlike userspace
> ABI, it can change.

Uh, yeah, so KVM has been managing such immutable ABI for practically its entire
existence.  KVM's save/restore uAPI has exactly what you're describing: serialization
ABI that needs to be backwards and forwards compatible between different kernels
in order to support both upgrade and rollback scenarios via live migration.

KVM also has immutable ABI between itself and guest kernels, including implicit
"ABI" in the form of not changing guest-visible behavior.

> Today we don't have any rules and let you change things freely as long as you
> do a version bump. But at a later point, the plan is to add some stability
> requirements to the ABI so you can actually upgrade the kernel across major
> versions.
> 
> So at least for ABI changes, there should be an explicit ACK from the
> live update group.

I don't entirely agree.  I get where you're coming from, and I 100% agree that
the more eyeballs on changes that may affect ABI, the better.

Where I have problems with the above is that it doesn't account for the nuances
of save/restore across different kernels.  The literal format of the serialized
data is the most obvious form of ABI, but it's absolutely possible to change ABI
without changing the data format.

E.g. say there's a flags field in some serialization structure, and flags X and Y
are mutually exclusive in current kernels.  If a future kernel relaxes that
restriction for whatever reason, then the effective ABI has been broken because
state created and saved on new kernels can't be restored on old kernels.  And
this is not a theoretical concern, KVM has run afoul of this a few times (though
thankfully very rarely).

I don't think it's reasonable to expect LUO maintainers to gain enough expertise
in each subsystem to be able to ensure changes are forwards and backwards
compatible.  The only way I see LUO being successful in the long term is to get
subsystem maintainers/contributors to understand *and buy-in* to the LUO model
and rules, so that each subsystem can largely be self-sustatining.  I.e. setting
yourselves up as literal gatekeepers will help prevent blatant breakage, but it's
less likely to help guard against more subtle breakage, and in my experience,
subtle breakage is by far harder to detect and more painful to deal with.

Somewhat of a side topic: in my experience, using monotonically increasing version
numbers is a horrible way to enumerate features/content.  So for me, allowing
KVM's LUO ABI to change with a verson bump is probably a non-starter.  I.e.
whatever gets merged needs to be more future-proof than "we'll deal with it later".

