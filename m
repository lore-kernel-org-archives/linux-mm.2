Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20FACC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19CD16B018D; Tue, 18 Aug 2026 12:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127136B018E; Tue, 18 Aug 2026 12:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F309A6B018F; Tue, 18 Aug 2026 12:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B87566B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:02:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AA3B1C01CF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:02:21 +0000 (UTC)
X-FDA: 85114857282.05.5AD9A2B
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf08.hostedemail.com (Postfix) with ESMTP id 799D6160012
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:02:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=No39rc8N;
	spf=pass (imf08.hostedemail.com: domain of 3CYKEagYKCHoqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3CYKEagYKCHoqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787068939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTu8rIIeaYeWexH+JKqzOvDmozZVoZIeVfoU7C4RXZA=;
	b=jT5gePkO4bDBw89DjJ/+ar+dFIdxzyZfxnRpHeocru8Nu5MeosWyIC56dlLvDt1Y8cjXIf
	pJ/tZkNL2Lyv3qUnGboJ0j0WhgCKVx4HRAzTdQuhXwiv+OVB11qwG2JXnf0q1usrAuey8+
	GoFdXYyQ7ZlXvj0w0cJdpl2PDXEm+Fs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=No39rc8N;
	spf=pass (imf08.hostedemail.com: domain of 3CYKEagYKCHoqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3CYKEagYKCHoqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787068939;
	b=h5Cdfguw23zWM0Fdwzw9QPCfGziKvdrT/5/n0xjPZVgk5IL32LBDceTe6t32emo4hmGVu+
	OAj5tcutc4ANI0YzNImjM4zWJOTlKNPjcmSkJEL+nT+6kq3mAWiWHLBvum068gF/QVCYVL
	KUlOehCh21b94XP0tBcw0+LrsjL+FBE=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb7049fa552so4398645a12.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787068938; x=1787673738; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hTu8rIIeaYeWexH+JKqzOvDmozZVoZIeVfoU7C4RXZA=;
        b=No39rc8NkobPCt/46+6NPusspaYXKS+MAoB8A/m48+5jITiapneL1HhTLdipSYhlEy
         qT6wdn2wg4/iibfWsXQBaYiu8i/dZiH1bagswHzSesExcwk7hZmmRLFnwn2QNQm2prHo
         zWRhuoy+/AN23yggzXu37nc7b8wgOZVbUmSQpJ+VXNx344XahARnRzC4at/jaRTQoLXm
         aFXBU3E+xnyNNovySqJLnnHK3Rz0jNrVin/62GBYbSRUWP8avchgLrgvjSewCjoyT4tx
         WkEcqAJDUZQLw8RzlNnmfvLn3qItd72X2RXciNEUIKKUkzTLhiiTIVoYa9r2B2I5mKLE
         M3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787068938; x=1787673738;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hTu8rIIeaYeWexH+JKqzOvDmozZVoZIeVfoU7C4RXZA=;
        b=RyhxJepINZwm/dBGZzebNQxqTgRr92ZD3g+ul2PmT7cdSHGfqVxTouC5kLLswPZYno
         7s39of2u5t75vdJHacHcuNcF6GAtD+A3l1I7fbm0bv81/kOc2AolYda/c3/xbEeqAOUq
         8KaSAW+WhgNZq1ny0bRuI7ki4mDfWDgFpOHoLEOzrXxOMlV4EqwspbmmHY77KQJ3jXCU
         R9pZREZyYOC8qE//LrnHEiuWPyWTCRNJY9oS2sIkNXJK6ZXQmakW/TjZPJP/MshV/O2g
         HMaBT6YSf3RCvrGUXGcDJxkFEbXkcy27fZBRfVwZOTHMb+uYu/Z45q85aLaikKiZ7DJG
         zALg==
X-Forwarded-Encrypted: i=1; AHgh+RpvTkXq23YDOLgIc4vSzbQR8oAJJYsF2GfR3FZ/VY2O5NiY0QSSzzrJAHUaRAolxe1SUg28bYGLXw==@kvack.org
X-Gm-Message-State: AOJu0YxK9NCSi3plvIdN54D3+7nSoW0AR1TIr2FkgacdKM+DSELSmIwD
	aoN4Jbslj31IwmoIOozQY9om9Zmfu69MZU6JX7hbrAgIjtnycQmj17XBfrJnMlhDQqCGJD4FdtI
	qV2I8IA==
X-Received: from pgvc22.prod.google.com ([2002:a65:6196:0:b0:cbf:d9a:2fcf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f99:b0:3c3:9df0:2d66
 with SMTP id adf61e73a8af0-3cc719fe453mr37508125637.6.1787068937949; Tue, 18
 Aug 2026 09:02:17 -0700 (PDT)
Date: Tue, 18 Aug 2026 09:02:17 -0700
In-Reply-To: <2vxzy0e3zgqz.fsf@kernel.org>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-6-tarunsahu@google.com> <anphyjFv3FhF61iB@google.com>
 <2vxzpkzo51wg.fsf@kernel.org> <anssOQFNZ2LfihbU@google.com>
 <2vxzik5f311e.fsf@kernel.org> <anyObKiZIhfok5mk@google.com>
 <2vxzqzjz1x5f.fsf@kernel.org> <aoMcqp0gr06YXAPU@google.com> <2vxzy0e3zgqz.fsf@kernel.org>
Message-ID: <aoSCCTTBn9D5hqzk@google.com>
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
X-Rspamd-Queue-Id: 799D6160012
X-Stat-Signature: n8z11qfc5xwmdocdakpukqpugto1huou
X-Rspam-User: 
X-HE-Tag: 1787068939-415820
X-HE-Meta: U2FsdGVkX1+xGL8lY1xVCtI6eR8KHeOL117ZHov34XHaI54gG8zKuMngr0HOkNlSqhGvKvhz0MwcE+AofPRA+KYSRWP4ng6yr7ehQepoCZ06D9hbNO1z4jHg+acpQGFZYtU8YNxf2n5xYwIf1AI1RjSyWNIZz4PSLiv/frjnEd+WyeuZuHSHQe5Td7Jr6ys1qix8HDn0mWVf1TsoUep4xI0sobbHuhYc59u87qCYVjxVpIqQuFy1hW6YO85JAZk9c89NBjVPMgctGoAY8n7ypWnGZ7v4KTfn3b9Ad2bSEkGhj2bCQoguKeAn++gnH2sQieQajUfrNdHsbO/0rViMrsWCz76In68ywoHAm1A1ihqTfNFhbiNcg2XSsHlw6VZiIbCIxD0NgSaHH2plosgHK7fgAbp8M9ECold/B86Wy0sEXowstf+axmCTn717y1kZ9cezpVpjgMGZdngwn7V+IU+PVQtsKBzvvvnv3pKoJVXA7m7NHXQ/sGLQzcvYv//AHtTg2n9vZXVGlB7NMBEA82xsGEaYZq6UScKE3ElTG6qD48GFq02tqGpoIRtOgv30IYo/Md+0J2H1lBXz3MSWCZEzHl4BcrnStEVmjehR28DAeceLhrBk0hN7syyTriw85aZI4aECYp5yjrw55WT9NQXqgUxEjVyYKPgRHVcA7CHhVt2d85vdfqd2vkHEIl8GwF/FXg1j6pmFgQq33EJ69N2qRIvduWKU/Rhu6DYTvuxAcRmfjKrg8ykyo+5QnGDALKHqyGTaHRCPGLxy8lfL/FbxLpXrcW1vfqJ1HzqJUX5EBS35yWosE6KY+5B4uDsXNWhMLlkJ+Wrl2VG7FDGM2ab6KKlR4ZSn/9+U0QfCcMnK/8QogMYGLxVRddIkpAN1qh73pE8AgIyqvX+DmwvCNzsYDHMtjsKOC/I0dvOMZaEzS9o7ZZFEGZoFaYc/8HS0RrcgupA8LSTmH3+snwC
 1+EW8nvQ
 dX4Dd1aVGtDoAswlU47CG2dAxNmT4vZ/Dx/hfCgj/byveEnfLXosnK+SilKJmS60orWwWmdui20Mdy/7wzoTUBGh9Xztv6fnzSTE3VSCweywcN5RMxl4MvzjmseZ88qyQ++EDPNt+F8wDGoR1POThgh1AzMn2nF6KIHACRecUXlpRrb4+Fr8XeO+olgpMJy7OzVKHsXSImxtzWW+GDcsG/w3PWGAEnflcT16bWcoQawYP/PUiGfyolzhClk/OU6jZ3usJHbosnk4Ty3UfN15FjtF9I7iahwouOd0w3FybDycjggwWz2dDuGnyMvMg9MKY+68QoeCjJDPwenZ+fVj8e2CqvKQU5gdq6mmk/+ozL+g70rm6JJURbU5bJ9QucxoJ/iFbtxiNJTBXOunGZcu29UZIftiNinV9KRSnjeoa0JkwmTtZLOd4m85DHODBJNdDRm4/iKwSW52LsSii5sY4JnrjzI1igdrvXUW9HDalCeLZ4nEx5UynzTxeUSd0YxgyAvErbVA2Ytu6fd0+2lXBHxgaI/aok4/pX/7KomufFEKr2rTNyDCd5PfGh3qcgXzQjSJtNIvLeAYx/sq0lOF02IRSjuRona3OEK+pjScMjHpUhLsB3fINgAFAOr+7XyEu9kNF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026, Pratyush Yadav wrote:
> Hi Sean,
> 
> On Mon, Aug 17 2026, Sean Christopherson wrote:
> 
> > On Sat, Aug 15, 2026, Pratyush Yadav wrote:
> >> On Wed, Aug 12 2026, Sean Christopherson wrote:
> >> > On Wed, Aug 12, 2026, Pratyush Yadav wrote:
> >> So with live update, we don't need to keep backwards compatibility in
> >> the ABI forever. Of course, it is good to minimize changes, but we have
> >> more freedom to change it.
> >
> > Ah.  So this is the heart of the disconnect.  I very strongly disagree with the
> > statement that live update doesn't need to support backwards compatibility.  I
> > can totally believe that the folks working on live update are ok breaking backwards
> > compatibility because their use cases are "fine" with such breakage.  And I can
> > also believe live update as an upstream kernel feature being developed by those
> > same folks is also ok with breaking backwards compatibility.
> >
> > But with my upstream KVM maintainer hat on, I am not ok with that.  I did not agree
> > to support a world where KVM is allowed to break backwards compatibility, so long
> > as it's done "carefully" or whatever.  If y'all want to deal with the resulting
> > complexity, that's fine by me, but you'll be doing it without KVM.
> 
> Let's step back a bit. I don't think backwards compatibility in the
> _ABI_ is all that important in live update's context. What is important
> is that our users are able to live update from kernel version X to Y.
> The line format the kernel uses to describe its state is an
> implementation detail. Our users never see it.

The rule is thou shalt not break userspace.  Whether or not the breakage is the
result of an explicit ABI change is irrelevant.

> The high level idea is that when you need to make a change to the ABI so
> the kernel can better describe the objects/resources/files it is
> passing, you create a new version of the ABI and allow transitions from
> older versions.
> 
> Say you make some changes and need an ABI version v5. You don't get rid
> of v4. You keep it around. LUO core will facilitate picking the right
> version for the next kernel. So it will be possible to seamlessly
> upgrade your kernel that speaks v4 to a new kernel that speaks v4 and
> v5. Now this kernel can start speaking v5 if its successor speaks v5
> too. And so on for going to v6 and v7, etc.
> 
> After a "reasonable" time given for upgrades, you deprecate v4. v4 has
> been around long enough and our users have had a chance to go to kernels
> speaking newer versions. That's when you remove the code for v4 from the
> kernel.
> 
> We can argue what "reasonable" means, but the core idea stays. 
> 
> It will still be possible to go back to v4 or earlier, but you'd need an
> extra stop along the way. And of course, vendors can keep a wider
> support matrix downstream if they see the need for it.
> 
> Does this idea of "backwards compatibility" sound acceptable to you, at
> least at a high level?

No.

It's probably fine for Google and other large companies that tightly control their
kernels and use cases, and have the resources to juggle the resulting complexity,
e.g. have kernel engineers on staff to track feature and dependencies, coordinate
and plan kernel upgrades, etc.

It's not acceptable for upstream, where downstream consumers often run a distro
kernel, have much more varied use cases, and don't always have a horde of kernel
engineers on staff to help them thread the needle you describe above.  And if
supporting live update as a general feature for all users of the kernel isn't
being factored into design considerations, then that needs to change, otherwise
this is all dead in the water.

I also don't see the point.  Maintaining a rigid save/restore ABI is annoying,
but it's not _hard_ (or at least, not _that_ hard), especially if there's a set
of well-documented best known practices that subsystems can follow, e.g. so that
individual subsystems don't need to learn painful lessons first-hand.  I genuinely
believe that maintaining the version hell you describe above would be more costly
in the long run than simply committing to full backwards compatibility within a
given subsystem.  I can imagine that enumerating what subsystems' information is
in the payload will require a different scheme, but for a given subsystem, I don't
see any reason to aim for anything less than full backwards compatibility.

