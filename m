Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B79CC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2246B0095; Thu, 10 Sep 2026 12:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B136B0096; Thu, 10 Sep 2026 12:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202DB6B0098; Thu, 10 Sep 2026 12:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDF156B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:04:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22B54C0598
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:04:00 +0000 (UTC)
X-FDA: 85198323840.17.9787C10
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6451B40004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:03:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CGBrtP7N;
	spf=pass (imf12.hostedemail.com: domain of 37NSiagYKCH0tfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=37NSiagYKCH0tfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789056238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjpQmguvZKqFc40yaCCUF9DxHpcHtd3drRjNMUjWpE8=;
	b=bft5DcNG/Jr7+Bhq31XGYcxZVRYyqrcgcdJzv7i81GisMK/jzRMrMY0Sgss2hV7JDmXM3q
	uoUcWfM0HoVkOj2vbS9Hb1O6V6TsiYh2t8vUbQdfWj14QbOT0lI0S+F8ZZ7UojDLKxOcsH
	Z3qHyyatS20P6mRIWmqwCFjHLxNCZo4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789056238;
	b=HDhtl600ykEvaTIRwvv+bpHSWsE/BCBH4nrOGzdaL5zofimia8kkyuwqt6lrQcyffZIzWB
	Y8VMcFUKt0WE7612lLZD0Ee4flJn9NgfM5LP0Xh7qRamB7gJ5ukYpcsr7QXlOtT2BZpIBB
	yN+oxQeA6dTRy+YewfAQHaseXNJVln4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CGBrtP7N;
	spf=pass (imf12.hostedemail.com: domain of 37NSiagYKCH0tfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=37NSiagYKCH0tfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc4216aee8fso9686679a12.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789056237; x=1789661037; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PjpQmguvZKqFc40yaCCUF9DxHpcHtd3drRjNMUjWpE8=;
        b=CGBrtP7NtEcTqot1NFoRMXgeoI+jtJF2nYPbdU53ocGCn+IwkRgvLxNwBMP2zQhot1
         PCht0M555nPiFokY5K1G3XlF5SjrRBAnC3gyOra0Jw4aime0L+3Sk7i6W6xaSZX86eC5
         ewJUm5HJWuHrG/0zMjy77h+PPQe2oabh/wPUZGoovDsTsTY3Q1ilX2aQTJMkYj+LRq20
         JZkoRxYPPy/l44US/41ewMN3BLR4x4ZS/VVHxQl2/226Ed2fThp/yuMSTqxiCtFxDxI2
         e67FpCKC9BbEM/NkSHqihT6QWAMlS4aaYi7lV8R6qOIbdLs3k6Fq9cJRjhVPWc/uiSLj
         Q+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789056237; x=1789661037;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PjpQmguvZKqFc40yaCCUF9DxHpcHtd3drRjNMUjWpE8=;
        b=d9a4Gt7Y5V2/khn4/9CrXB4XZsfADHWVcBgZXB+y5jstCRZ2VgkiH91+5mcv2cV6wP
         Q64w7UTAmnkP4Fplaerd0juxluVVb75wfzcH6rZBXDV1m8fhJJaO9dYnCktzTyO/vArD
         xlh1vNWyG9A/Pvwb7wAlEvS+xUQh4a4w/UI/o09AgooZx3ygdjfoYu49ASdUT6KQSyE1
         +vLPCq4S24ZFjbHSnfxGG6gzeIwBW0rH4elQj+lIBJ54pWEGOvX62porqx9EV/PGdq96
         PpZKA8KaR7pn1vNDdBNFzJ63zij9J3vDcJF2SJFHAumoZgituPb1PbCPfXBV4ivylOvf
         tK/w==
X-Forwarded-Encrypted: i=1; AKwUvBxP7CQ1Dr94NsGuFxT3g48G0GsIaj8fuDPkQofkp5p+xCK+NM68tVCTEQRDMDIz76R2f5OxpNoLhg==@kvack.org
X-Gm-Message-State: AFuF++nxCt7ngztIK+HvngqwebqYlYRiOT0YaDrHj4CXggE6V+hcD1L3
	JawWOyxgw4BY4pA5KFMG3o93Xis6KqQ64Nq0/gqKMZaDCpLDlPzMHlF4MHcYFTM/dXtf4oABswJ
	VG28iOA==
X-Received: from pgmh20.prod.google.com ([2002:a63:5754:0:b0:cc4:3b01:7730])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4303:b0:3c3:7179:a640
 with SMTP id adf61e73a8af0-3dacbd6e061mr12520616637.3.1789056236336; Thu, 10
 Sep 2026 09:03:56 -0700 (PDT)
Date: Thu, 10 Sep 2026 09:03:55 -0700
In-Reply-To: <20260905011956.GA856309@nvidia.com>
Mime-Version: 1.0
References: <anphyjFv3FhF61iB@google.com> <2vxzpkzo51wg.fsf@kernel.org>
 <anssOQFNZ2LfihbU@google.com> <2vxzik5f311e.fsf@kernel.org>
 <anyObKiZIhfok5mk@google.com> <2vxzqzjz1x5f.fsf@kernel.org>
 <aoMcqp0gr06YXAPU@google.com> <2vxzy0e3zgqz.fsf@kernel.org>
 <aoSCCTTBn9D5hqzk@google.com> <20260905011956.GA856309@nvidia.com>
Message-ID: <aqLU653FXjJjhbop@google.com>
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live updates
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Tarun Sahu <tarunsahu@google.com>, ackerleytng@google.com, 
	fuad.tabba@linux.dev, Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6451B40004
X-Stat-Signature: jkkn3opfi4z4oj49bwxgzydpsps5sw8z
X-Rspam-User: 
X-HE-Tag: 1789056238-427666
X-HE-Meta: U2FsdGVkX18BYDpleOVT/m0L5hyfsLcSzpIBRd9mK61IO/wZFxNubcOOK3Tp8hDP0P5Yi5L4zw3i29G01D/SoBjkeSpZonkhtwVdW+JrGte+ZKAaGXElk3m2tTidTK/SIVR/R0+dhS7yGnebY3DAoCBMPuAvcJ84rBQyQBoAAAAj1SzhxFo6bA5M16EeEmn6OZZLdFbElONriTEx0T4OHNY7ZFxPJSu5moQsshBLZc2SaM2Eu8rMFQZ/RFJCttQEocEoeJFtAlI5CPRKfJfK9QSbquv0G61naWycCxNiZxP8EazLuWcMWTN9qSucSKHnwjsNTrhtJwFrNn9ib1zLPxI3MBBSgSHgqbffruA+GQw0XxK72vELLmkS4cGvbnMm/T6wojG2sA/joF52aoQJYPWwFeXZ/yJgpZGwLYOpt6UXdOAQxT3qOOL/Fza/LlsgwHOrYHLNgwqZ99u4H/M1v4Q6R+kvOP6vx+NETdikQQng73at9wE6mTvxoewsRiCuOJBggacRY3/bDgU2DzjP+JYSj8PN6qnRuAtfmwoQT+VTe4r1KR0En+CiJ5kFHXY1NRHYzUXrSiLmdfroHuvlV00B+5vo6C06sLUogJKMNrzs6u3KReBV/93dOqISpnD10QbyJG9b9mHQ9HLOft/wFS72Og5VJPJxm7b6rQfZQzAWDcAHhDr/9gSM8v3LG0Tsv2OenlrCykeg1tQ/XZ6Z5hdAU7c4FeV4/K6mI1aPHX0CZoUee4Nc3LE9T4ymIx8VLfnFz2CwlcOFHJsUPzVPdFo+qOrue5Btk7bFRKoO30YokPWuLcaRVS7CqHiVG0UsSu09TucoPrEl5fGnLW1D75yzT0Y0c2psR3Gj+f2v94Q72dkRQeTa7zq6LJlUp+UYiKzYTzhxZQ5cN8DTISBPEvqx229iQxFBkwqLjeEeIGmgOIcrpKOW2TMDaQAXeAymn4U8yOjBJEB/k4HmhKk
 xjKy1woO
 2qsSE2H9oazIwlMG8VqYpS0dZFOWpVFr00FI6wbQFYXOARSFfhAWD+EPjgH4nkc4liJ0MQgfZvBPvDLFjWZaaL/hBxC/O+NY4Lev5JlUqZPJj3KgZMkq4C2Qv+KJz618fSo0Wzzma0hNx9wTKgyDrHjX02kgdDYusWpurILRWirP8Ycz7QnyD/Np0N/JrXVJsyTPeBJ8obIoogH9qEa3OEV7ompkYp5YstMf+/voMebkJ7b9UIHPppBcpuwl3Jt14fjGL+KjXZqnOu4ZobI1GgXiey4YNGYGSyLWxtMn228vcs56sCXUa92lZJvOgi0nZYub7o89GbFwKd9bLMIML2Z63rC+/ADi2cgIb4llLTw/5zotu3J0bc/YUvl4dNPp1ullVR+w78EGSx2pTZV86K1m5WHthvmgYySqtw8uvi93NWPlmHuYS5ykSoYS5iXxA0LrVqW43HtLzu9FtTv6W4uUO5MLdGHmGqy8kSkdQD8v5ZYgwSyLisWaII4DtX3LzHiN3tYDqxKsMYsj8+Bc1GxkZR4Iq7IeoO32Rvf0mZVIT25a5/emQZ9bhgLscYSxUehI+JXZQRzzF0d+frunXR5rjSAnFLae4ub1Q81DK5FCSEXKar2w3NGsqRMmR4YIIJCZB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026, Jason Gunthorpe wrote:
> On Tue, Aug 18, 2026 at 09:02:17AM -0700, Sean Christopherson wrote:
> > The rule is thou shalt not break userspace.  Whether or not the
> > breakage is the result of an explicit ABI change is irrelevant.
> 
> I argued strongly for this simpler approach, I will write here the
> reasoning I gave.
> 
> Firstly, "live update" is not uABI per-say. It is not "userspace
> breaking", and it is not a "regression". It is an internal kernel
> mechanism to allow the kernel to self-upgrade. In the industry it is
> typical any of these hitless update/patch/etc schemes to only work
> between a few tightly controlled version pairs.
> 
> Asking upstream to carry a full matrix of every single version pair
> ever released is massive over-engineering and cost on upstream
> maintainers. Refusing to do this is not a uABI breakage, it is not a
> regression, it is simply a lack of a feature.
> 
> I think upstream should start by agreeing to only support forward
> going upgrades within a single stable branch. If live update becomes a
> success then maybe we could do from a stable branch to the immediate
> next stable branch too. I don't know.

From that perspective, what I am proposing actually goes a step further.  I'm
saying don't commit to supporting *any* specific versions in upstream.  Express
the feature requirements in the serialization payloads, and let userspace sort
out what kernels are compatible based on their actual usage.  The kernel may need
to provide additional discovery mechanisms, e.g. so that userspace can probe to
see what is supported, but discovery is usually fairly simple to implement and
maintain.

> This alone is already much more powerful than live patching.
> 
> The balancing issue here is the impact on the kernel subsystems
> adopting luo. Every time you change anything about the internal
> function of the subystem you now have to go test a massive version
> pair matrix to make sure everything works? No thanks.

No, the subsystem just needs to make sure that it serializes its data using the
defined ABI (where ABI here means the format of the payload and the meaning of
any flags in the header).  That should be *easier* for maintainers to handle than
trying to support arbitrary versions, because it eliminates subjectivity and
having to make judgment calls or remember magic version numbers.

> Luo is very invasive and a huge PITA at the best of times. It doesn't
> need to be even worse.
> 
> > It's probably fine for Google and other large companies that tightly
> > control their kernels and use cases, and have the resources to
> > juggle the resulting complexity, e.g. have kernel engineers on staff
> > to track feature and dependencies, coordinate and plan kernel
> > upgrades, etc.
> 
> Every downstream that wants to support luo is going to necessarily
> severely restrict the version pairs that can work. Like a RH type
> distro may only support it for 9.1.x -> 9.1.x+1 - they can carry the
> cost of figuring out how to manage their patching and compatability
> matrix on their own with the tools upstream provides.
> 
> > engineers on staff to help them thread the needle you describe
> > above.  And if supporting live update as a general feature for all
> > users of the kernel isn't being factored into design considerations,
> > then that needs to change, otherwise this is all dead in the water.
> 
> General uses can use upstream and do CVE upgrades within a single
> stable branch. That's good enough, lets start there. We don't need to
> boil the ocean.

We're in violent agreement on this point, I think we just disagree on how to
express compatibility.

> > I also don't see the point.  Maintaining a rigid save/restore ABI is
> > annoying, but it's not _hard_ (or at least, not _that_ hard),
> > especially if there's a set
> 
> I was told KVM had the smallest luo footprint of everything, so
> perhaps your perspective is different.

Only because KVM already has a massive ABI surface for save/restore.  If you
want to convince me that magic version numbers are the right approach, then show
me how KVM's existing save/restore support would be made "better" and easier to
maintain by throwing away all of KVM's save/restore uAPI and replacing it with a
versioning scheme.

> In other places luo becomes coupled to the internal datastructures of
> the kernel, we literally have to preserve lots of kernel memory
> utterly unchanged without any kind of serialization at all. 

Have to, or choose to?  I have a very, very hard time believing that it's infeasible
to define a serialization format that is decoupled from kernel internals.

> This inevitably creates restrictions on the evolution of the kernel in
> general if we can no longer change in-kernel architecture because it would
> make some data structure incompatible with a kernel 10 years old.

Only if the relevant subsystem defined a poor save/restore ABI in the first place.

> There is also a need for *downgrade*. Meaning the N+1 kernel has to
> strictly emulate the limitations and capabilities of the N kernel so
> it can be rolled back. Can you imagine the nightmare of trying to
> codify the feature progression for every single kernel release forever
> in some impossible scheme to enable this? Again, no thanks.
> 
> So, what upstream can reasonably do, that still provides real value
> without severely burdening every subsystem, is upgrades within a
> stable kernel branch only.
> 
> If some distro or CSP wants to do more, they can deal with it. They
> have a far, far simpler problem because they can exactly lock down
> their version pairs to a very small universe. They don't need a single
> kernel that can emulate 10 different releases of behaviors
> concurrently.
> 
> Jason

