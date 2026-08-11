Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD826C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7DB6B008C; Tue, 11 Aug 2026 10:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981016B0092; Tue, 11 Aug 2026 10:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD406B0093; Tue, 11 Aug 2026 10:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59B9B6B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:05:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AC7416046B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:05:49 +0000 (UTC)
X-FDA: 85089162018.07.1D17371
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8BFD18001A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:05:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OjTeityU;
	spf=pass (imf30.hostedemail.com: domain of 3OSx7agYKCNgM84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3OSx7agYKCNgM84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786457147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAJktWiCLBpTuTmwKXB+qiv4Wjmxms+UGlXDoh/JJdk=;
	b=4NtmX+2VWtK6FdxJAxuTo58xBxAa8gO6ooQS5ura7rRTaIu7w+9To1310bSO23oI++gein
	rDP0ZvAnUZPdt4Uhd5qZUt8wcJT4XkaEKJvyMRYUvo9QQNx/ZsaXank7MLDrjYMkSknjAP
	B+lLCseDyMa4TRZYhTVetMrZuwZJFYE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OjTeityU;
	spf=pass (imf30.hostedemail.com: domain of 3OSx7agYKCNgM84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3OSx7agYKCNgM84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786457147;
	b=VRa0PZiiS8fMBGPuxJTh4ymZCb6TgbDy7IQmcqpijoJNyLX02T4zjluepnhJVwKe6Tn/76
	JINVjwXzVxSSmmUdz7Q5dB59X5oYfFyjbr5wJUSU8YQ5Ztowlejpwhslc9hquaFO6vU/uc
	FhtqRNb9jAfNfP6AlUpyzEMwwfh1qkM=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cacf17c7e0so43989765ad.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786457146; x=1787061946; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iAJktWiCLBpTuTmwKXB+qiv4Wjmxms+UGlXDoh/JJdk=;
        b=OjTeityUpnmzuPOyb1IHSO/T3E93xOmOJa2u36kUajZFqd4UqYFNvI0CMVP7wsWi3L
         B3KqoaW7jMmd62lw4EkGKXxXsakj7pX+Hb4tXmuPSKURI5sZoWE7sRS+x+H7e9wQ/96W
         NsuK+1M/9jsjy9NTdL+0xI+jEDvtx7crsoeKNOh1mqtSlxJssELLHq9dZ+lDnXJMKOPu
         g3RhFMef6Xf6a+amDjDt9lYOzO5o0LUHt/xWw/YneTXicjxi+d2vC5e91lbBs+5dC9Vg
         CGOC+1mYuhnOqvTl/D0wj2N29tzyEdGT8IDZFhnWXruYDJ1bK5/OxWd1Je+hxHU9o3er
         UAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786457146; x=1787061946;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iAJktWiCLBpTuTmwKXB+qiv4Wjmxms+UGlXDoh/JJdk=;
        b=PTy4kE7O9urMq85FP8KYBAS++WgTwwV2YXP9Ruxf3x9cNu9ySsr8ARP2BpCmWWySrk
         jCTJiXmBX6V22ymPa++d88X71ITXnZAPcqHGHrh1S5Vgm/HvucNo4NCVKlURq1o5yjxQ
         8nwT0+ax3gk7kDaygJsN/uwSuWy7EpTabgERqq7wYsEwZyArR12JoGuBJmxLNgxC6XA6
         AKQH31RneYOtRO4XLNxiSvn2mCfLjsd1aXDrN5qCxdTWecw/qis21Rzrr9/3fKotTUZn
         adRc2QxQrZRrgFf0bvXCD7YPLX7mzQe62zRgZS1BdSa3PgPVs+FqyYfvnzphQMmCesXx
         R7bA==
X-Forwarded-Encrypted: i=1; AHgh+Rq7e8Iv6JmU+KW7uAMHJmmnqEZkn+FPHKeHmCQ9X8In5RLKq4kd3ifX4tD/AIRL2/zpQKmjR6kLXA==@kvack.org
X-Gm-Message-State: AOJu0YwdgDiNR1qZFEvtKTa3DKb+25xWtH7aUKKjPxPBzTKAH7dVYWx8
	9cbvLAwCAuUSBzBoxSgXVwAQMx/5YCqJj8IufgewtKg3Ka8U965sRGHE4/ZVVUjCibPWWH4Ht+/
	IXe+ZHw==
X-Received: from plok3.prod.google.com ([2002:a17:903:3bc3:b0:2cc:8fa5:7221])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f64a:b0:2c6:a012:6241
 with SMTP id d9443c01a7336-2d3177a171dmr43949945ad.6.1786457145880; Tue, 11
 Aug 2026 07:05:45 -0700 (PDT)
Date: Tue, 11 Aug 2026 07:05:45 -0700
In-Reply-To: <2vxzpkzo51wg.fsf@kernel.org>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-6-tarunsahu@google.com> <anphyjFv3FhF61iB@google.com> <2vxzpkzo51wg.fsf@kernel.org>
Message-ID: <anssOQFNZ2LfihbU@google.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8BFD18001A
X-Stat-Signature: nmj1e6g5ke8gt4gkbbdzo3i49wh98wpu
X-HE-Tag: 1786457147-496222
X-HE-Meta: U2FsdGVkX18d6Gch+7riRoH8+WUWWXhpzaHLHvbicnum83omPK/6tZ+YEL33b75u3vuWHPgWJThJPdYe0x8h6057quh1uW/rM2d0hHSrcrcrkpWDPYJDB4nH6dZ5hsy15yybuvOBbPmbomTCJhYlp4X3EnZ0K/Wl/tGenifjemm3ASCBURgDLb5HZv0NCl035Y3ebrgG5IZg+UkKIXJfk6H+jBgXGtaVV5SvNAk9UXi2w0c7Gyk9KjGwnp4nur1MdINLHQlfT0vDwUf6ZEZoOWMU37DsshESjgmHJXoI4RIN938B+n0beb2Jr8oNOmet4c6bzjcczBokR4lNOpHfPPJhOPpDv5z57Fubgsc+2XJ9oQYSvldDSf86b9jvA8Us3z2iH9INa0mVnB+ZQcHny7hAIjL5ifDf16xjusVQt3dxjqYVNs1wLZIyGbXra+npEj1Yx83v15HTb1YMIJwv710t92qmyL6G9JPnUSCj/apThVi/dNevkK+eYplb5Al1xS1JtBU+qqtjCFgqxGpVt4ikw811X2loCDFJj1thUlGdQ1yHxOWume1SdCsiUL6U3ybdMPuGIFL1uyKHU41Ak9mD0N5OrjUingITL8QnEM8luSotmIFfQlN++s1IWN9ayTjD2bOuwkGrafrmIT+O5ZI8/2TVNByWx4stx/qi2a3Erpk5rq62X1vAZrfHKFGkWcbgoCOXV+p0YePkYv+3lwDlQtcr9sEsBYejFphfHV3HkYydYH33johQV0b/8IZ/Voj2IczFpNEBrUjrgG2KGOyXSUHsGDQCoWnc6w6PnqswO9AL8UCBFjFO4FXNfBMstn3h6ZHCEhc8FMsf9eIBrwa77dryDTyg/XBjFnrmok1eHxk0T9kXZdZfoCIEZ55XGKoN5KtOfwhlkjAUqOwtCvhVQ0e+Pr/M0DZzkwC3l5G9t+FCYirFzyw82WafcVNkXEWuuDU6B5EILaL0p34
 anLgFMds
 ltPw1i55o5jviLmwbt265ZgCkL0N+lF55YyLUSyKl5bu8HwQLUb9EF8K9UiYAoBHu2n+HPNCr4c8CHI8hiQyLsthqssg2Lc3W8np7uAzyambJYydkbMVqOvQWqm+6g9IqNVSdJTUQVYNmV4yhu3c//e7Sb0LhOZhcqRvUxZAm7DcbdZP6/Fz0rBh4MKO+y3nCQRj7vEAKnx5Do33H+7uC/tlakt9MwH9YRu4ynSTVTpdNeRI7XkRZxw2p6Nw+X1LxGN/wJ+bZKyRrtnku6Xz0aL2VVGvBApPovHxs3zT/TZ/mcXmu6w7STpLQmilj96Wy7k7FebIP5vJ/ElXKj/wallyEOEbIfNmor60KzontY94ybI8Vo7+J97pTfNOV9e7tOOqZ7XM6rF18l6xbXcJJpJxuLw+HTdbXyEVzRR1e9+ilqaEFilSGysFC0EAkYIF5HbwF520DqZ2R6EPxMx4nlyHVs3Gt3CRkkH93qTMugTkw92jJTv34g4/LNxt7JCe03Iy8wUuwvKgT+PDiDwxCb2lUEtohjLBN845rKrBZH0lvPKDXhGr955tcs6BQR9WHAlKORtkjJspkfwxTU3RiLWThGSAgANYaxuPs0snI0907NEdB3lXADv3jg3vFGGPF9AsddsQrN88HzQs4HKKsPcJfD2zYy4EAeHlA6PtxbDQ+BLHcmh9YycXSAF2lpWxSlWgy/pmye6q8GEMFSTC4+KdhnbtRbYIjMLwx3cSIhXjtWjE/NXHcqkqDHwwcEOiRJIlK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026, Pratyush Yadav wrote:
> On Mon, Aug 10 2026, Sean Christopherson wrote:
> 
> > On Tue, Jul 28, 2026, Tarun Sahu wrote:
> >> Register a Live Update Orchestrator (LUO) file handler for KVM VM files
> >> to serialize and deserialize VM state across kexec live updates.
> >> 
> >> Currently, Only VM type (e.g. arch.vm_type on x86) is preserved as part
> >> of VM preservation.
> >
> > Why?
> >
> >> On retrieval, kvm_luo_retrieve() recreates the KVM VM file via
> >> kvm_create_vm_file() and use an atomically incremented ID for the internal
> >> fdname, as the final fdname assigned by userspace is not yet known during
> >> retrieval. As this fdname is only used in debugfs infra, This will not break
> >> any UAPI.
> >> 
> >> This infrastructure establishes the foundation for preserving guest_memfd
> >> instances across live updates, and can be expanded in the future to
> >> preserve additional VM state.
> >
> > Uh, why guest_memfd?  As much as I want to push guest_memfd adoption, it seems
> > guest_memfd should be the _last_ thing we support, not the first.  As evidenced
> > by the last two decades, it's very doable to have KVM VMs without guest_memfd,
> > but it's rather hard to have VMs without vCPUs.
> 
> You _can_ preserve vCPUs today using KVM_{GET,SET}_REGS, they just won't
> run in the background during the reboot.

What about x86 CoCo VMs?  Which are quite literally _the_ reason guest_memfd was
created in the first place.  

> This series can save you from dumping VM memory to disk if it is backed by
> guest_memfd.

Or to word it another way, one _can_ save guest_memfd, it's just slower.  My
point is that this series needs to provide a _lot_ more information about the
bigger KVM picture.  For those of us that are on the very fringes of live update,
it's practically impossible to review because, to us, it seems very arbitrary.

The part that's especially confusing is the saving of the VM type.  That comes
straight from userspace, so it's super bizarre to automatically save/restore that,
but nothing else.

> >> +KVM LIVE UPDATE
> >> +M:	Pasha Tatashin <pasha.tatashin@soleen.com>
> >> +M:	Mike Rapoport <rppt@kernel.org>
> >> +M:	Pratyush Yadav <pratyush@kernel.org>
> >> +R:	Tarun Sahu <tarunsahu@google.com>
> >> +L:	kexec@lists.infradead.org
> >> +L:	kvm@vger.kernel.org
> >> +S:	Maintained
> >> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
> >
> > NAK on taking changes through a different tree.  This is KVM code, period.
> >
> > In general, I'm skeptical of the dedicated MAINTAINERS entry.  It's extremely
> > difficult to tell since this series is little more than a skeleton (either that
> > or liveupdate is way simpler that I was expecting), but I suspect that maintaining

...

> > E.g. the LUO APIs seem pretty straightforward; I assume the bulk of the complexity
> > is going to be in knowing what to save/restore, and how, which is much more about
> > KVM than it is about liveupdate.
> 
> I think it is fine if you want to take these changes through the KVM
> tree, but I would like live update maintainers to be listed as reviewers
> at least.

Why not simply add a file pattern match to the LIVE UPDATE entry?

diff --git MAINTAINERS MAINTAINERS
index 8014b9f8253e..2eb57b22c37f 100644
--- MAINTAINERS
+++ MAINTAINERS
@@ -15052,8 +15052,8 @@ F:      include/linux/liveupdate.h
 F:     include/uapi/linux/liveupdate.h
 F:     kernel/liveupdate/
 F:     lib/tests/liveupdate.c
-F:     mm/memfd_luo.c
 F:     tools/testing/selftests/liveupdate/
+N:     [^a-z]luo
 
 LLC (802.2)
 L:     netdev@vger.kernel.org

> At the same time, I also keep being (pleasantly)
> surprised at preservation being relatively simple. For example, the code
> to preserve a shmem file (via memfd) is roughly 600 lines, a big chunk
> of which is comments. The code of course has some limitations, but it is
> good enough for use in production.
> 
> For one, we care about ABI breakages and versioning. 

Which is amusing to me because that implies KVM does not, and I would hazard to
guess that KVM has the biggest ABI surface of any subsystem in the kernel by a
country mile (though I'm probably wildly underestimating the effective ABI surface
of filesystems).

> The serialized state is a part of live update ABI and changes to it should be
> ACKed by us. 

Meh, "Don't break userspace" is a universal rule in the kernel, I genuinely don't
see why liveupdate needs special treatment.

> For another, how the file handlers interact with their dependencies can
> affect the behaviour that VMMs observe. Those changes should also pass by
> some live update eyes.

Perhaps in the short term, but IMO, that's not a winning strategy in the long
term.  From my perspective, that like saying the PAGE CACHE maintainers should
review every usage of the filemap APIs, because how the APIs are used impacts
the page cache and affects userspace-visible behavior.  There are myriad analogies
like that throughout the kernel.

Yes, liveupdate is new and shiny, but IMO for it to be successful and maintainable,
it needs to be treated like any other core infrastructure in the kernel, not a
special snowflake whose details are known only by a handful of people.  Because
I think it's likely liveupdate goes one of two ways: either liveupdate becomes a
very niche thing that is used sparingly throughout the kernel, or it becomes a
broadly used feature that is supported by many filesystems and subsystems.

If liveupdate is relegated to niche status, then it probably isn't going to see
a significant amount of ongoing development, at which point the folks working on
liveupdate will naturally migrate to other projects, and maintenance will largely
be left to subsystem maintainers.

If liveupdate is broadly used, then having a single group of people maintain
every subsystem's usage won't scale, and maintenance will again largely fall on
the shoulder of subsystem maintainers.  Which is totally fine and working as
intended, because that's exactly what subystem maintainers are signing up for
by merging support for liveupdate.

