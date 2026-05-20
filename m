Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2395CD5BAB
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 18:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292266B00A4; Wed, 20 May 2026 14:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 269BA6B00A5; Wed, 20 May 2026 14:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7586B00A6; Wed, 20 May 2026 14:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7BA6B00A4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:38:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A941F160D45
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:38:38 +0000 (UTC)
X-FDA: 84788659116.01.7FD70DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id F3F10C0010
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:38:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OeP7kErD;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779302317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6e4oDBvRxPvtNdyfdL/0JuA1B/r6cjRvn2dqESw1JI=;
	b=IufI1FLvu8CBk2wXBQBOLBj7hB4e4gtdHIU2OM67MiHVrflFcPYikK91qO4VRFALzdCb7e
	gy+DBhazCICm3AGjIav/04aNiKF1f026nDGBs/7u+ognUVDfxE0ys7m8OCHmiYQl2hwdJ0
	fowCu9M1EPcCcYsKS6SFxRC9YA2KAeM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OeP7kErD;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779302317; a=rsa-sha256;
	cv=none;
	b=dJNOZGYNVHHoyLRh/NEpXvAar72HC0Ved1MSs9ZbDAPGi9It6eBYUPUwkBsnOfFgMkFXNZ
	J/XeQBEkbLYRWa4UdL+hTSWv/nIAK17kuRTR+rxJpryELz18r+MEBdIV80ItwAbdLjHiaf
	jNEX3emS9DfQmBK8K/XToYwnx0Jw09E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01E96445BB;
	Wed, 20 May 2026 18:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65FB1F000E9;
	Wed, 20 May 2026 18:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779302315;
	bh=P6e4oDBvRxPvtNdyfdL/0JuA1B/r6cjRvn2dqESw1JI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OeP7kErD5FN4x7H3jRQ0qLenYDpJZWNSC8tVoPmuXHTpwPTAQ48hShAKKEor0cmpn
	 otH8fOPqr5siqoGpZBoIrjd0DotVi3hInBPD+on2at+SCW4JUXmQ2K59y7Zi7Nb9+z
	 GDuDs7+CT+xCWf3lflOSuYnA/yBaBPfQQmM5VP/NG1ZzYpK5jEUv6wD97K9dHFMQG9
	 VqxokuhqSCrOe7MjFswSc4vITW1uDCKOGG1n8wA9mwCG3xIj8i8x7qtI21x+NoZf0E
	 MzjHqv1paEtjF8zEW5XeoEe6QpfC5Rk68G9rCR/B+xVKctkjhArQfZKZcshzMSYpQ7
	 fgqv9cwx0mSbA==
Date: Wed, 20 May 2026 08:38:34 -1000
From: Tejun Heo <tj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
	bpf <bpf@vger.kernel.org>, X86 ML <x86@kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot
 installs
Message-ID: <ag3_qpKObFOLKgbR@slm.duckdns.org>
References: <20260517211232.1670594-2-tj@kernel.org>
 <9ba50fd2-077e-4291-9276-9adb18186873@kernel.org>
 <agtuPrgIDNKSu2Oo@slm.duckdns.org>
 <2f02d90d-cdc9-48ef-abe3-99e00f22595f@kernel.org>
 <297658c4ae2d6e7103f5968efc936224@kernel.org>
 <04b03066-86d3-4c0b-b077-307fd0f3bc9c@kernel.org>
 <5590fd3d-dae1-4070-b52f-bc40982ac678@kernel.org>
 <agyZxmHoueGwBAQg@slm.duckdns.org>
 <CAADnVQJt0p7hSn2G074QZRh2LEdthy3RKYJ9j3w5yeJ-e8UQLw@mail.gmail.com>
 <fb889bfc-af0e-491e-a69f-38c2abf88d22@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb889bfc-af0e-491e-a69f-38c2abf88d22@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F3F10C0010
X-Stat-Signature: 8u7ikybc4x5d8ru33tigtajt96bry1x5
X-HE-Tag: 1779302316-514599
X-HE-Meta: U2FsdGVkX1/UEHJzOQjc1NIWOHpSVSZuDfi9EPDV069I2fno7/NUp9nygNVse2l3RDLOdKwveoKXOf26ju+NQOOs/ATwHBfP53kdwr1X1VsGCm71Er/hbNp5CROTiLl8mVFDtijGGsZqog0/pduy/5H8cZ6gVftI7BYdwa3Nm9xJAC98pnj+74yFUUzbXd44idVQ6J56vdM4FWlvl4vwpQtvjEEgL8s7dtnjZqkcbxrN3q/RpFHxCjRTezPqkYxjve65a02Hd8eWNYhNpJRrB5ctpnT4CZqZ4Tz6FT/Qx5eokCcqFnrnTGwJ98IDLk4n91Tz2qYpy1Y8yEh6yRi8MGw6wQO5VzvxkKj7y4iuz3cAGc29GSJE+jMRxxClHxVEVsQCOomU3bgtnlfzGtFukr74bAi3vCmUcccVFz9zezkMinrcRJgOOQda/KCn36ogYhKiGrhl7IfS5h86+p7URCMFrBQ/lBH/2HcebEZpsu1g91XHfesneOgpYyS8KxoDUGQMHtXXocPHFMSDTiGdE046Egj+zbc0KRUlq6AfbhcsA2yJR/IcMc8j4cVH0F7JF0qKWollvSFD1sdvCyjd6T5del5HasPTbxsBY6/g6Sh1iJgm/DWWK+PFQRqN/76QWDdY7fxuZA4hg8ExfkuObBT7oLxfa4+jE1P28uLame1mBor3zYeWSzInOoYtTQlnzJUWGYO+Tp5M45GE+WdeWnZDb7O2+ChfvTFR5rSsxY7Y/j9LkUvPoxcG2eqgJ++w5oQUaQ3A954Nrj14UXSdjYqHc55E9Qm40rRjAsOckM8ZIgTq6fO1TcZr3RGzONoIhxSIAWu5DhgPqM477zEv+gfKp1+6fe+GQMdxDnqTaA5ZMzufApHOVVBMLR2uJliKX51oHzCAQwb/1hl8E0iZbfpv/76VCMctzFvF/9EFVMQUTwrQmloF1YX7S3Qe/Xs2rJV6r7MIzeK8Pyhmaos
 RPphgARq
 9DdwaxcXWtbiapMvkkpMJR5PTBfy2KSGud5W/sHPjL5qK5MKi67ciWn27a8Dhg48jTqOKPbGadxNyPlVdwejuYmLBzR2j9SkM+VzyrEjKUheGS0Wa6tGcIUJC9lB/DSdhtNYt9MxVXQwIMVmHPA5Luy8B0Op9JgVkXUVpMXm8ZHjDiZs1R4P0mpv6VSdLKKMsGrV9R7DhCa5AWXbptBVGz+rB+YtcCq4eYNBm8yYXODop0GWrJQYM7aAms2pqy8OIahndvDbqaweT3YJQ8SHknZt3WRhUKq0vmU0R4R7i/mHI2C+RukYc6OCrX+beFC6tvQ6GExF3PYAAAng=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 10:41:15AM +0200, David Hildenbrand (Arm) wrote:
> And that should be carefully documented.

Will do.

> > The fault handler has to install _some_ page and let kernel continue.
> > Scratch page or arena page doesn't matter. Potentially different CPUs
> > will see different page. It's not a concern at all.
> > bpf prog is buggy, but the kernel will continue to work without a glitch.
> > bpf runtime will disable and unload misbehaving prog.
> 
> Having one page table walker overwrite a scratch page on race is just rather ...
> questionable locking design, that just screams for problems long-term, really.
> 
> At least in apply_range_clear_cb() one could similarly switch to
> ptep_try_install() to at least have both these paths handle races in a
> reasonable way. (having to handle when ptep_try_install() is not really implemented)

Hmm... wouldn't that be more confusing on apply_range_clear_cb() side?
Whether it maintains the current behavior (if collide with scratch, try
again with scratch as the original value) or flip the behavior (fail if
scratch), that extra logic is spurious, and those tend to confuse people as
they force asking why it has to be that specific way. If the goal is
documenting the subtlety, wouldn't a detailed comment serve the purpose
better?

> Anyhow, the documentation of ptep_try_install() must clearly spell out that this
> must be used very carefully, and only in special kernel page tables, never user
> page tables. There are likely other scenarios we should document (caller must
> prevent concurrent page table teardown somehow, and must be prepared to handle
> races if other code is not using atomics).
> 
> To highlight that, we should likely consider adding a "kernel" in the name, like
> "ptep_try_install_kernel()".
> 
> I am also not sure if "install" is the right terminology and whether it should
> instead be "ptep_try_set()". (set_pte_at is the non-atomic interface right now)

So, ptep_try_set_kernel()?

> Further note that last time I talked to Linus about arch helpers, he preferred
> 
> #define ptep_try_install ptep_try_install
> 
> over __HAVE_ARCH_PTEP_TRY_INSTALL

Will do.

Thanks.

-- 
tejun

