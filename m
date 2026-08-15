Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D6F1C5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 10:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53BF86B07C0; Sat, 15 Aug 2026 06:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5138B6B07C1; Sat, 15 Aug 2026 06:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428D76B07C2; Sat, 15 Aug 2026 06:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 073656B07C0
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:44:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C9FBA2BDF
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:44:06 +0000 (UTC)
X-FDA: 85103168892.05.9D6AF1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E5A5140003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 10:44:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kr/Tf5ck";
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786790644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHN97m9JW2ZgHxLPFLcOKL8ZOHela7pDZzqoNJfQP5E=;
	b=17IGHhx8Uch/2aFX3+Xiys7E2fCicdI6ufuBQrAP8EDGykGXHX+c1axwUwKCP8dtmJPAEe
	krkynkF5HRVMwSV1oMHB1QeqyvOWGRwn04H7nlf/9DJ1sz0KkCsrbulN3VfKtOdFY/f7pQ
	fwHDTw/2HAb5ab5GvIak6B150kwao78=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786790644;
	b=n09Fk17SZlCdAxfEfX7iS5R8TWwrmHzw4bbDvU620Q0bF1thT0VZ3T9D1SlVPTGLz7JJAi
	sJ8t+943c9ODmhJKa5vgARBZlZdw9bPYOw38cIR/rMCEJzDkMnjObyX5xGv28+OvxLOedC
	2gXSnPbeJ+ibC34Dou5BjSxoSWcqidQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kr/Tf5ck";
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E903F60008;
	Sat, 15 Aug 2026 10:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D271F000E9;
	Sat, 15 Aug 2026 10:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786790643;
	bh=EHN97m9JW2ZgHxLPFLcOKL8ZOHela7pDZzqoNJfQP5E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=kr/Tf5ckh5K3hOdAtZRNaMYJfcRPbGlwjMHHlS0bf7W+6jLe5uTUgjrP9S+5f/IC/
	 Ka/suzsag9pVo5MAFE5sUh0OdSOq15rVwKacT8p8g/2vLXGvNF6wyqDL/oQEHFwKNE
	 uW0VRb45EN4jcoJ7gWykJKxHTXlr/mPQcjZ/7sibTUOtZlTPD7FkwaCSvI56oP4lze
	 WYAMKxEpRdAEdaOxik7UE4xE+40VQZc/EdlggdhzMRACQMooZmNlts0xGE/K0+tEkl
	 Xm1O4rjqoZBEa8az6uvNKeelMuWGoGXGMg4E4Z8cRr209WzF2prepZEjHbJND/nln1
	 63kwlbLLevOoQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Tarun Sahu
 <tarunsahu@google.com>,  ackerleytng@google.com,  fuad.tabba@linux.dev,
  Andrew Morton <akpm@linux-foundation.org>,  dmatlack@google.com,  Shuah
 Khan <skhan@linuxfoundation.org>,  Jonathan Corbet <corbet@lwn.net>,
  david@redhat.com,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  sagis@google.com,  Paolo Bonzini <pbonzini@redhat.com>,  Mike Rapoport
 <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,
  linux-kselftest@vger.kernel.org,  andre.przywara@arm.com,
  michael.roth@amd.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  will@kernel.org,  vannapurve@google.com,  maz@kernel.org,
  fvdl@google.com,  kvm@vger.kernel.org,  oliver.upton@linux.dev,
  kvmarm@lists.linux.dev,  alexandru.elisei@arm.com,  skhawaja@google.com,
  aneesh.kumar@kernel.org,  linux-doc@vger.kernel.org,  David Hildenbrand
 <david@kernel.org>,  yan.y.zhao@intel.com,  kexec@lists.infradead.org,
  suzuki.poulose@arm.com
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live
 updates
In-Reply-To: <anyObKiZIhfok5mk@google.com> (Sean Christopherson's message of
	"Wed, 12 Aug 2026 08:17:00 -0700")
References: <20260728121138.1103610-1-tarunsahu@google.com>
	<20260728121138.1103610-6-tarunsahu@google.com>
	<anphyjFv3FhF61iB@google.com> <2vxzpkzo51wg.fsf@kernel.org>
	<anssOQFNZ2LfihbU@google.com> <2vxzik5f311e.fsf@kernel.org>
	<anyObKiZIhfok5mk@google.com>
Date: Sat, 15 Aug 2026 12:43:56 +0200
Message-ID: <2vxzqzjz1x5f.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: nsads4ui6yaognk6yjigqgpsyo5gpb97
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E5A5140003
X-HE-Tag: 1786790644-852372
X-HE-Meta: U2FsdGVkX191b9mtgLN4D7JXxFGq/4yUUvKvS8WRmVWSWbpY7lTI1trBGXyuHIVR0VYc+T6i3svAksx5GENDVzt57VTHFv41/f2UvPUgEdeQ/9Weu/3/GXc5nn3IVGV2bgLDS5SZF4L4/sQpFpLNyjeyDRqwFoGIr1Hi69rpWioUSKwWSDRKyWceT9tZMsPUCBmAzQTUfU4dJ+HVGG0biFPaJwOL0+D2sYQ2EY1eLGS4oSNzxz9PDp7yMQ/8WbMAOsNPw3PzPnQuX+wM8iypiC5FR6WcnOAL/NIZdtmGTrBAd0agMkKvcSVB0DmjlEpLbb+La88+k8WUkxQXRTJzu8ljnzjlqAPuUUaVk+fvrsxyDjR8bhFdANCcpC47eKsy1KC/q9eIdXqkkpr/Ft7z2VJjzsMp6htn3Nd934U8BBqRt/9nUXT1Xr7Ea2vkMCwLcuN1u9aE/HNeNFTsW5Y7uavV2KCDb/Vol+l22XTUB3CNER0/vxJQPNX/rbI/JlMJyi3ZEaVgCudRQ9SQ1tn5y+OcgdXqN0UZBuUM/BCrrA2f4P0pyHKrZiuVWY/KEZAAmctgtxXYk0P4Wl+VkBXpLq64BQ3RqhePHi29uFETqCkSbpQjV86qUO8E3h3krAZJH1ZFsSfzbPVy05DwJL6TdtKXwtXaK1QaP+A9NOjO7yuX2ziSPEBGOQFwYxq/GXxWOKWjL4nRKJ2/euzKktA4w3hCo9/bXq3YX08j4mR/hyPkhtYALs9kmfFua+e0uZii1ho28qPM8q5ZmQCkaMxtaue4QLED1Y8gVlDBHzx1vLsCKiQBuzWeiSRlkMMpZ7bJUxTjBROmwaFdu++oGQ4UlkhQUSgje+uFPCNDklRPjXrFerX/c/PODaezJ4Bvpg5DkZ0S+BFzqEcyrti3LAgcWbr4UYdanoqR+f8Yu2Ox2vStGuJLhKw6Tmkc+zOmavAMpuUt5s91kAf0GAEoUg4
 zWcpxkbg
 aJN6UixZ6L57nxXwS249+AksLeqxZUw56wXRlmi9X9krcbFAcXwFY4r0Y1Tia7mryKobB21dNKf/7o7kgXC+j10RmMPdgMX1mMpdc8K2aS22NgFoN1g/1plc+bEy58RaxUS7CuN2aGGXil5Uc4YEpnvI8oQScQpN749hoj1apApy2yV2n372Q8fO0R5axG7YzUv1giU7ahHEk6m1JYBLGJUpu0tqI3OAO4vw4k+C/UgkbEvLIKC9dVhL4ukHYXF+xWfK7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12 2026, Sean Christopherson wrote:

> On Wed, Aug 12, 2026, Pratyush Yadav wrote:
>> On Tue, Aug 11 2026, Sean Christopherson wrote:
[...]
> But that's all beside the point.  What I'm saying is that SNP and TDX *must* use
> guest_memfd, whereas guest_memfd is optional for all other VM types.  And so adding
> LUO support for guest_memfd without even sketching out a plan for CoCo VMs feels
> backwards.
>
> I'm not necessarily opposed to gradual guest_memfd support, but there needs to be
> a clear plan of how all of this is going to fit together.  It doesn't need to be
> perfect, and I'm sure we'll make mistakes along the way, but I want to at least
> try not to paint ourselves into a corner, especially with respect to the ABI.

Right. I think landing shared guest_memfd is the first step. It is
simple enough and doesn't need to preserve the more complicated
architecture specific things like secure EPT, etc. The CoCo support
can build on top of this.

There is work underway already for an RFC of TDX live update, but Tarun
knows the details better than me so I'll let him fill in the details for
the next version of this series.

>
>> >> > E.g. the LUO APIs seem pretty straightforward; I assume the bulk of the complexity
>> >> > is going to be in knowing what to save/restore, and how, which is much more about
>> >> > KVM than it is about liveupdate.
>> >> 
>> >> I think it is fine if you want to take these changes through the KVM
>> >> tree, but I would like live update maintainers to be listed as reviewers
>> >> at least.
>> >
>> > Why not simply add a file pattern match to the LIVE UPDATE entry?
>> >
>> > diff --git MAINTAINERS MAINTAINERS
>> > index 8014b9f8253e..2eb57b22c37f 100644
>> > --- MAINTAINERS
>> > +++ MAINTAINERS
>> > @@ -15052,8 +15052,8 @@ F:      include/linux/liveupdate.h
>> >  F:     include/uapi/linux/liveupdate.h
>> >  F:     kernel/liveupdate/
>> >  F:     lib/tests/liveupdate.c
>> > -F:     mm/memfd_luo.c
>> >  F:     tools/testing/selftests/liveupdate/
>> > +N:     [^a-z]luo
>> >  
>> >  LLC (802.2)
>> >  L:     netdev@vger.kernel.org
>> 
>> This would list us as maintainers of kvm_luo.c and the tree as liveupdate.git, 
>
> It would list both "LIVE UPDATE" and "KERNEL VIRTUAL MACHINE (KVM)", as KVM would
> still cover the files via "F:	virt/kvm/*".  And my read of MAINTAINERS is that
> N: and K: entries are "secondary" if the files/scope is covered by an F: entry.
>
> E.g. arch/x86/kvm/vmx/tdx.c is covered by "KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)"
> via "F:	arch/x86/kvm/*/", and also by "X86 TRUST DOMAIN EXTENSIONS (TDX)" via
> "N:	tdx" (or maybe "K:	\b(tdx)"?  I haven't bothered to check which one
> triggers).  And while I don't think there was ever any formal discussion, AFAIK
> everyone reads the situation as KVM still being the primary maintainer/tree for
> that code.
>
>> both of which is something you're saying you _don't_ want.
>
> No, what I don't want is a dedicated "KVM LIVE UPDATE" entry, because I think most
> people would read "F:     virt/kvm/kvm_luo.c" and "F:     virt/kvm/guest_memfd_luo.c"
> as being more precise than KVM's "F:   virt/kvm/*" and thus would read things as
> "KVM LIVE UPDATE" being the primary maintainer.
>
> In other words, I'm more than ok with LUO being looped in on KVM LUO changes and
> having the authority to object to problematic changes, but I'm not ok with LUO
> taking primary ownership of KVM code.

Sure, that sounds good to me.

>
> I realize there's more than a bit of nuance in my interpretation of N: and K:,
> but again my experience with TDX is that so long as the maintainers are aligned
> on expectations, it's a non-issue in practice.

Yep, as long as we agree among ourselves I don't think the red tape
around which entry has higher priority matters much.

>
>> >> At the same time, I also keep being (pleasantly)
>> >> surprised at preservation being relatively simple. For example, the code
>> >> to preserve a shmem file (via memfd) is roughly 600 lines, a big chunk
>> >> of which is comments. The code of course has some limitations, but it is
>> >> good enough for use in production.
>> >> 
>> >> For one, we care about ABI breakages and versioning. 
>> >
>> > Which is amusing to me because that implies KVM does not, and I would hazard to
>> 
>> No, it doesn't. What I'm saying is I care about changes to the _live
>> update ABI_. Just like you probably care about changes to KVM ABI but
>> not so much about BPF for example.
>> 
>> > guess that KVM has the biggest ABI surface of any subsystem in the kernel by a
>> > country mile (though I'm probably wildly underestimating the effective ABI surface
>> > of filesystems).
>> >
>> >> The serialized state is a part of live update ABI and changes to it should be
>> >> ACKed by us. 
>> >
>> > Meh, "Don't break userspace" is a universal rule in the kernel, I genuinely don't
>> > see why liveupdate needs special treatment.
>> 
>> Ironically enough, you miss my point. I'm not talking about userspace
>> ABI. We all know not to break that. I am talking about live update
>> _serialization ABI_. See the stuff under include/linux/kho/abi. This
>> series also adds things there.
>
> No, I understand exactly what ABI you're talking about.
>
>> This is ABI between kernels. It needs to be stable-ish so you can move
>> from one kernel version to another. At the same time, unlike userspace
>> ABI, it can change.
>
> Uh, yeah, so KVM has been managing such immutable ABI for practically its entire
> existence.  KVM's save/restore uAPI has exactly what you're describing: serialization
> ABI that needs to be backwards and forwards compatible between different kernels
> in order to support both upgrade and rollback scenarios via live migration.

I think there is a slight difference between KVM's save/resture uAPI and
live update's ABI. With KVM's uAPI, you need to maintain strict
backwards compatibility because userspace reads what you output. So if
you change the layout, userspace will interpret it wrong and might
break.

With live update, the ABI never gets to userspace. It is used to talk
between kernels directly. So if you do break that, your userspace keeps
working fine, you just might not be able to live update to the
incompatible kernel.

So with live update, we don't need to keep backwards compatibility in
the ABI forever. Of course, it is good to minimize changes, but we have
more freedom to change it.

The current idea is we change the ABI whenever needed. This is because
live update is still in development so we are likely to see a lot more
changes before we settle down into something that mostly works. At some
point, we want to start being more strict between incompatible ABI
changes. The current idea is that we would like to keep backwards
compatibility across LTS kernels. But none of that is set in stone yet.

That's why I would like to have an explicit ACK from the live update
group for ABI changes. I would like to enforce these compatibility
windows.

>
> KVM also has immutable ABI between itself and guest kernels, including implicit
> "ABI" in the form of not changing guest-visible behavior.
>
>> Today we don't have any rules and let you change things freely as long as you
>> do a version bump. But at a later point, the plan is to add some stability
>> requirements to the ABI so you can actually upgrade the kernel across major
>> versions.
>> 
>> So at least for ABI changes, there should be an explicit ACK from the
>> live update group.
>
> I don't entirely agree.  I get where you're coming from, and I 100% agree that
> the more eyeballs on changes that may affect ABI, the better.
>
> Where I have problems with the above is that it doesn't account for the nuances
> of save/restore across different kernels.  The literal format of the serialized
> data is the most obvious form of ABI, but it's absolutely possible to change ABI
> without changing the data format.
>
> E.g. say there's a flags field in some serialization structure, and flags X and Y
> are mutually exclusive in current kernels.  If a future kernel relaxes that
> restriction for whatever reason, then the effective ABI has been broken because
> state created and saved on new kernels can't be restored on old kernels.  And
> this is not a theoretical concern, KVM has run afoul of this a few times (though
> thankfully very rarely).

That's a bug, and should be fixed.

I am talking here about intentional ABI changes. As I mentioned above we
_can_ change the ABI, we just need to be careful about it.

>
> I don't think it's reasonable to expect LUO maintainers to gain enough expertise
> in each subsystem to be able to ensure changes are forwards and backwards
> compatible.  The only way I see LUO being successful in the long term is to get
> subsystem maintainers/contributors to understand *and buy-in* to the LUO model
> and rules, so that each subsystem can largely be self-sustatining.  I.e. setting
> yourselves up as literal gatekeepers will help prevent blatant breakage, but it's
> less likely to help guard against more subtle breakage, and in my experience,
> subtle breakage is by far harder to detect and more painful to deal with.

Outside of enforcing the ABI compatibility windows, I think this makes
sense.

In principle at least, though from my experience the maintainer appetite
to care about live update varies. The feeling I've got from MM for
example is more along the lines of "you break it, you buy it". Which is
also a valid model IMO. The person who wrote the live update code for a
subsystem is well equipped to understand these nuances.

>
> Somewhat of a side topic: in my experience, using monotonically increasing version
> numbers is a horrible way to enumerate features/content.  So for me, allowing
> KVM's LUO ABI to change with a verson bump is probably a non-starter.  I.e.
> whatever gets merged needs to be more future-proof than "we'll deal with it later".

As I wrote above, the compatibility model for live update allows
breaking ABI with version bumps. Userspace keeps working fine, it only
restricts the set of kernels that you can go to. So the "we'll deal with
it later" is not as harmful because our choices here are not permanent.

Also, there is work underway to allow transitions between versions [0].

But still, I am not opposed to a more flexible guest_memfd ABI. I think
we can reserve some space for feature flags to let us add things in the
future.

[0] https://lore.kernel.org/kexec/20260731215224.831696-1-loganodell@google.com/

-- 
Regards,
Pratyush Yadav

