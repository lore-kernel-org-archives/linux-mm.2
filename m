Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8F03C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719796B0152; Wed, 12 Aug 2026 09:45:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1996B028E; Wed, 12 Aug 2026 09:45:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607846B028F; Wed, 12 Aug 2026 09:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2BC6B0152
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:45:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B30B2403FC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:45:42 +0000 (UTC)
X-FDA: 85092740124.29.43BE7FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1C8924000B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:45:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LpJEWQYD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786542341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2D2UytTyVCCTSaKgj888w4OMsi/TDP+60oG0TxSPgjk=;
	b=Zgw8thtx37iBLA4BlCEpJugRcwVdFhjNDRQNQRCBAwXTBh1w5CBbG5fP7QFJVsKSW9Yx5h
	cfDNVs+GmLpQS65XbOiFuJVlrVOM58IcaBufidOhs1r3w2A1O3tahjcWpx5DOe9NC/qbRA
	Zk7JhF5kMKY6EJXq3W/8XD+Ks5YXMjs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LpJEWQYD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786542341;
	b=Fr6HC3BKcxul3Q5kwsBX96K6zmdPGresnvJFgNsAhg3LKIj+/1/BMyiPrQ5GLKv3P4Dn9R
	poBedu46LRGDcMDZigYZajpK3bEM5AMsKsTpKL5zYAqoHm80rBHnKg3YIzKHq8KADJrp8v
	bWQ5PPMWfo+AwJZNcMZsOfENFqCDs0k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F04A60A92;
	Wed, 12 Aug 2026 13:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD88A1F000E9;
	Wed, 12 Aug 2026 13:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786542340;
	bh=2D2UytTyVCCTSaKgj888w4OMsi/TDP+60oG0TxSPgjk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=LpJEWQYDUauNRIazj3NboFIQsYaibbSbmybL0dWgwYglieJ7fo+1PRVn6tKMTC4YC
	 ICBXKfukOcSlb0pehHMISA5A5FHghk/9aQujs1dn5GSC7C7yz6v8MuSz56k8KuRVpu
	 ds0OkgiHG549Zr3jwkrWxwr5izFu8E+ueexMQ7dNkKaM3dWCdGPouNDTKchvi8vitt
	 aWNTY0v2KYMHUGtpCGpzqaO5kIOrG0s9sAQD4wwZA/U3tSN85Qzb+5l4iKBgAH6btw
	 lBcwrGDiExL5oX69DuBZPs3Lr7DkA41Bn6bpJBgQw3RHdrvl9bRk/uV2a5X23I9r/z
	 nS0M4nA93r+LQ==
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
In-Reply-To: <anssOQFNZ2LfihbU@google.com> (Sean Christopherson's message of
	"Tue, 11 Aug 2026 07:05:45 -0700")
References: <20260728121138.1103610-1-tarunsahu@google.com>
	<20260728121138.1103610-6-tarunsahu@google.com>
	<anphyjFv3FhF61iB@google.com> <2vxzpkzo51wg.fsf@kernel.org>
	<anssOQFNZ2LfihbU@google.com>
Date: Wed, 12 Aug 2026 15:45:33 +0200
Message-ID: <2vxzik5f311e.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: t5epqr1maonyfiirgfhn8jrpsw9w1aaw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1C8924000B
X-HE-Tag: 1786542340-965197
X-HE-Meta: U2FsdGVkX18lKwJxj2jTXgAJIzzpWIF5fT0gBmunEuxT9oaWPnzOsz4VfgoifklUTLmgREUvLeX8slxg+5vRFuf2iXkGSbgbkzbKa0rkZEEgWzNq03oJP3tiquhtAt25MZOm6r2+jsQaNqYoeX/rdrOLVlQ6WKbD2UqoIBsHhkDi/+aasgdbRl68kixuT/XNzCfwE8hAUzSIRWS2iTqi/bt/HlKh8bvOe0S3fukHgd9Bb24XWstx7jwj86s3UP/3On6jxf92o6qqdyhGISunP8PYd5SrVqxkP+zvIiKmyfM4VyWX4ET09go6G3bl6qZ3H2pd+yzYALMSYlf1S1iqf1OgjZdjCKTM1ExTUY83TJ5bbXL4evd+tcJesnaxy2CHcP3lE+wsBcEPuF50Qit0nXqhZgx5W9alrDUyoqLTcYT++gYo2oqj0i9A6z9R6vn34dG0ytCkoNbqoMvzih7PwAcBeXk17c8bboT78YHetpUhBEkc++bqtC9eanJYndPyZgRi32IK/NsrZJ0yAc13e15RFQmUHuNQ9q104Fw54HSZG5cKV/qPHdR59KYTDDY3AS2RulD3TRiLMmyV9IoewCQH+ibXGSSAXQsGSspQREGVQ2KWa4T81zy0287EOkxN1e3WuFCe7ja1TzVpbArpC0GVJA4sFabjN5KdCMUNJ9ldaRx38m6i5zUjrOIAhh8ih7Y9vqrX/7Ol/CRxlk3OzXI3xWmdpVXPVi5J4pzcTQN1e2Jh1dz5t2CXYKtZ/d5j7V2QuxVBgorIA+gDXJiVL4zPwu2TmzfTx6R907sNoIRbB5nVenfP+j+FbiIX9XQsYgJ+RwhenK4aK5GBkE616F1bdIPPPvv0YVZ0lDMhBsbVIDDfL94NiBLq+MXmc1bKG0zdiG6uAbHN/Bkh1DduFOhA2icKbvsFMmdGd1GrD9wGWFOTMZ/RFL53MICpL6giEMqvbGKb5VTrqiHp4RU
 4yg/ktlK
 lLWpbKGpnGe5BBD4Z0CBQktkG1/s5GjAV2MPp9V5bpPK7kBrGlhLrX6Jz+IJPqxqwaBShEi4rHqWO3DbZ3zrasvWg36cJkOEPf74CFtFLbnZ3kjY5lb+UmFC0NKYhOz64DHMGGV6zsmBLVhHZ7UNBKLg9GRMUQra+73lTF8g3DlEyC5KaBt3cULwl0/gPWyhgbxUcq5XJCkzvwN/QQ1MHSMJZfqGvuQV2OcDhgXqy87AfZ3JiNNRB+GqwwiYUsxw2swcUGBMmJsuWVK3e9ZgzVKkDlJYzq9JQ/i3AadIv4RJLczZVRQChe5VHEXY57F3XmJm7DkoxmYAGpta6Od7LEU1YCEcyC11m459ZVi+tydZi8ihZ29gSUSdeX041hy57NVaNjCPhP+X92TAPjOXi6LFrcAiSwitG82iPeo07G4YU1Sw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11 2026, Sean Christopherson wrote:

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

I don't know much about the history but I thought these days guest_memfd
is used for more than just encrypted memory. I have seen talk of it
being used for non-confidential VMs. For example these patches [0][1][2].

The CoCo parts can follow, but IIUC guest_memfd is being used to back
guest memory on non-CoCo VMs too.

[0] https://lore.kernel.org/all/20250430165655.605595-1-tabba@google.com/
[1] https://lore.kernel.org/all/20260728-shivank-gmem-migrate-v2-0-269ac1f84e2b@amd.com/
[2] https://lore.kernel.org/all/20250828093902.2719-1-roypat@amazon.co.uk/

>
>> This series can save you from dumping VM memory to disk if it is backed by
>> guest_memfd.
>
> Or to word it another way, one _can_ save guest_memfd, it's just slower.  My

Sure. But making things faster is the entire point of live update.

Guest memory is one piece of that puzzle. Devices are another, and
that's why there is a lot of work going on with VFIO, PCI, and IOMMU
preservation. vCPUs are also a piece, but I think those will be the
hardest to live update.

> point is that this series needs to provide a _lot_ more information about the
> bigger KVM picture.  For those of us that are on the very fringes of live update,
> it's practically impossible to review because, to us, it seems very arbitrary.

That's valid criticism. This series should do a better job of laying out
the high level plan and where things fit.

>
> The part that's especially confusing is the saving of the VM type.  That comes
> straight from userspace, so it's super bizarre to automatically save/restore that,
> but nothing else.
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

This would list us as maintainers of kvm_luo.c and the tree as
liveupdate.git, both of which is something you're saying you _don't_
want.

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

No, it doesn't. What I'm saying is I care about changes to the _live
update ABI_. Just like you probably care about changes to KVM ABI but
not so much about BPF for example.

> guess that KVM has the biggest ABI surface of any subsystem in the kernel by a
> country mile (though I'm probably wildly underestimating the effective ABI surface
> of filesystems).
>
>> The serialized state is a part of live update ABI and changes to it should be
>> ACKed by us. 
>
> Meh, "Don't break userspace" is a universal rule in the kernel, I genuinely don't
> see why liveupdate needs special treatment.

Ironically enough, you miss my point. I'm not talking about userspace
ABI. We all know not to break that. I am talking about live update
_serialization ABI_. See the stuff under include/linux/kho/abi. This
series also adds things there.

This is ABI between kernels. It needs to be stable-ish so you can move
from one kernel version to another. At the same time, unlike userspace
ABI, it can change. Today we don't have any rules and let you change
things freely as long as you do a version bump. But at a later point,
the plan is to add some stability requirements to the ABI so you can
actually upgrade the kernel across major versions.

So at least for ABI changes, there should be an explicit ACK from the
live update group. For code changes, I'd be flexible if you'd prefer
that. More on it below.

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

I've heard kernel maintainers complain many times about people or
companies throwing code over the wall and not staying around to deal
with the mess it might make.

I'd like to avoid that with live update and help you maintain this. As
you've said, you are not as familiar with live update, and perhaps you
might not even be as interested in it. So why not let the people who are
help review the code?

Ultimately it is your subsystem so it is your call. And as I've said
before, if you want to take it through the KVM tree and have a veto I
think that is perfectly fine.

As an alternate example, with memfd_luo, the MM folks are rarely
involved and the maintenance and review is done largely by me because I
wrote that code. Mainly because the contents in memfd_luo.c are all live
update related and don't matter much to core MM or memfd. I have heard
similar desire for the HugeTLB live update work I am doing.

We can figure out what works best for KVM.

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

-- 
Regards,
Pratyush Yadav

