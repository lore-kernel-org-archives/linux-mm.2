Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189DAC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2AD06B018D; Tue, 18 Aug 2026 09:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02526B018E; Tue, 18 Aug 2026 09:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16EC6B018F; Tue, 18 Aug 2026 09:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7A036B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:43:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25690801F3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:43:27 +0000 (UTC)
X-FDA: 85114507254.24.5F7B9A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 533B980008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:43:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CNqkvMTJ;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787060605;
	b=0DSnaY9hz/eq3eYOaYCCVrijSinVPdAt7AotE7bnp2XyCEsfBYVEMFBQzdrd9atSxExFnZ
	3Y23CJ16OLMs089NY2vjlaV60s6I7AQjKl8Z9ocYxJf5wpt+RW1VZ29lnAV0WqCIyXC+xt
	Bwq5659bsZY/7jgKo+BpRPouimuYyYA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CNqkvMTJ;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787060605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCaPyvw2iFSAtJp+/S0lPXfdeu+F7EyJ6au4lKiWYEc=;
	b=qkCxQEJ/Q1SbkD7mnN1jSDyVTLHIJ5Eum5Wpfzsgqp/so6rMRAnIKA61ZZtuamD7vqUgu1
	sa6Q+WK7kB//x5ohJJ9SPa+1eBivjWThYuQHGB06OQsPv7j4Ll2D2tGFA+E0h1CaQQF4vp
	Y8NNpJolPLSqIB2APZXmdVnAp8i3v0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58DE6436AF;
	Tue, 18 Aug 2026 13:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0CB1F000E9;
	Tue, 18 Aug 2026 13:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787060604;
	bh=nCaPyvw2iFSAtJp+/S0lPXfdeu+F7EyJ6au4lKiWYEc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=CNqkvMTJLXNXiEeYKsDcJ5vMCl9APuMbVQIu0B3nogx96ycdVcxhEfA8Y935rOFQB
	 DwbNjFOYTMnBcvSeBREzeVOMYq7oUx9+JWYNVQm4Q0PKS+TKPkUhGIwiw2tE5w+5Ve
	 LAEdg6oApkQLyaWE+1c4QN377ZwYbBFYC0UH/Ok81z64U3FaYuILqh5ogSr2NI8qW5
	 Ege/V5Ma8jQasI6rRqF3rtGgJBIUlCgSKy5x8PZPaKbx9kzGG3jWEalwW+u9kH3QZa
	 hA+6ZSEFatqG59DQNkEy9P9hX2+kEigKQsIcMrgm1kYnd9bXj74pxxwXASSs+5JduV
	 qiO3xv/HZavsA==
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
In-Reply-To: <aoMcqp0gr06YXAPU@google.com> (Sean Christopherson's message of
	"Mon, 17 Aug 2026 07:37:30 -0700")
References: <20260728121138.1103610-1-tarunsahu@google.com>
	<20260728121138.1103610-6-tarunsahu@google.com>
	<anphyjFv3FhF61iB@google.com> <2vxzpkzo51wg.fsf@kernel.org>
	<anssOQFNZ2LfihbU@google.com> <2vxzik5f311e.fsf@kernel.org>
	<anyObKiZIhfok5mk@google.com> <2vxzqzjz1x5f.fsf@kernel.org>
	<aoMcqp0gr06YXAPU@google.com>
Date: Tue, 18 Aug 2026 15:43:16 +0200
Message-ID: <2vxzy0e3zgqz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 533B980008
X-Rspam-User: 
X-Stat-Signature: 331s7i1n5bgttkdwnyr36xkf7og9eqx5
X-Rspamd-Server: rspam06
X-HE-Tag: 1787060605-611961
X-HE-Meta: U2FsdGVkX1+8lgi8So2putgU9fz8Y8xcdLB1gczlhWGaH5RfGgLtHcEz6sE9ooxDdv0gBxqnLM0wv8suBHiTED6k3+g8p7GmUQFzrn0VmfSOVPKTg7A+YF3/G0ca8o0PkDYr+Pt4tJRYC030MO56ppOcgDdKKnYNYaUSwMg7PaBxxr15Jzxpm9ilJXNRqoZyh0oQNCnwgErWNeb5uX9LsSFSkVwMFlHzLfQ9dvjgQiVe+zNr2Kx1SukMAHoKDEFaOQecEyZjxhHrFcz1PVXLs2HwWc4m3Q9GL93cM2OKtyDM/Pe3hWcTOm8V21zBHwApI/qaI4oQkVEoVy2iVQ0s5gVAIxHY6aCaH6i595l/0ZNVL3wTnEIYkLvUqhyvIbxUyeBb0+VU/YfXiKXYaiAjsqgi5dN5cCMJuGjiR3UwZORb6ZiZ8D2h7Y/aDvRGOn0VHL7nYkioQ0/eV0HeOUbG4NMKTgSgyzEVh7xTotTBiFbAdJYZtUnPbCJ482vzfMkbzuNpB0Jew9ZO+33H96gM3sx7TiC07smxysofMz0N8hmlRk1TkGyRP9k3z0ANZSoxALSNiBs9e5R5S3OT/qp97URyb+JN8dCoFU4BALshDMsptevnhK9jFQx946b0lirJoErTl+oYjb7t3lWwnA/cLwsNxgH8z1PPLGybul9YuhgV1iZyS694vxq+WxdMvgU2aG8/IQmBasfP2WN3IZ+yorI5ygMlxn/SfUXzp1b6uwkL1pB0og+cFxzZ4VSSQ//b4k/rfpJs2Z3KayzR4NCGfpWJXOJ0HvnNbf5gFyxA8so0F71nUvhC41MRoI6eEVSlS48HV1Sz/WJQp2joZ6YIedXachVJHKJisvzPvyqTzv1s67/bEFQfoZBXcIax/mnGQDaq8VgTzsv25nDDydymf6H4o6klqd9IIFHeeh7/wW1mPQrIN6qiNVToSNoH/hgH9ei68HyyJ3vjQkHTU5Z
 4JfIE2IN
 AGZ38YvTUHEWhzvt+okmr5PngNipT6W3OMlRCvDpYoxiu2yp7DFgd7o+ELRkNiPyy/u39ru9jhWcfkL0NaN0jRrZxnbyhte7mgD6uVFdVq7rWSk7MhHtaIkDVc3C9StIU9HWWEo4cPp+wRCMlxFZ/aO3B8BuLdKFAeXoIk9Y29Q9uZ8Dtgt7+neH2DOuG5LXJ2N5l3cdyZL5b3cGKCmRnklKd9Tuv9ZA3zXfDIwSMO4Hxmx0NoVt1cPf4ljBJTJY2V4Ww0v1rD2k8/kDICJ25IpLJeMknTOWw4zoz77Hr1qCW2WeHWwGndEOS1YDpLZvYamuOJq4D4WSx7Tq7Sv5iM1XJ+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sean,

On Mon, Aug 17 2026, Sean Christopherson wrote:

> On Sat, Aug 15, 2026, Pratyush Yadav wrote:
>> On Wed, Aug 12 2026, Sean Christopherson wrote:
>> > On Wed, Aug 12, 2026, Pratyush Yadav wrote:
>> >> This is ABI between kernels. It needs to be stable-ish so you can move
>> >> from one kernel version to another. At the same time, unlike userspace
>> >> ABI, it can change.
>> >
>> > Uh, yeah, so KVM has been managing such immutable ABI for practically its entire
>> > existence.  KVM's save/restore uAPI has exactly what you're describing: serialization
>> > ABI that needs to be backwards and forwards compatible between different kernels
>> > in order to support both upgrade and rollback scenarios via live migration.
>> 
>> I think there is a slight difference between KVM's save/resture uAPI and
>> live update's ABI. With KVM's uAPI, you need to maintain strict
>> backwards compatibility because userspace reads what you output. So if
>> you change the layout, userspace will interpret it wrong and might
>> break.
>> 
>> With live update, the ABI never gets to userspace. It is used to talk
>> between kernels directly. So if you do break that, your userspace keeps
>> working fine, you just might not be able to live update to the
>> incompatible kernel.
>> 
>> So with live update, we don't need to keep backwards compatibility in
>> the ABI forever. Of course, it is good to minimize changes, but we have
>> more freedom to change it.
>
> Ah.  So this is the heart of the disconnect.  I very strongly disagree with the
> statement that live update doesn't need to support backwards compatibility.  I
> can totally believe that the folks working on live update are ok breaking backwards
> compatibility because their use cases are "fine" with such breakage.  And I can
> also believe live update as an upstream kernel feature being developed by those
> same folks is also ok with breaking backwards compatibility.
>
> But with my upstream KVM maintainer hat on, I am not ok with that.  I did not agree
> to support a world where KVM is allowed to break backwards compatibility, so long
> as it's done "carefully" or whatever.  If y'all want to deal with the resulting
> complexity, that's fine by me, but you'll be doing it without KVM.

Let's step back a bit. I don't think backwards compatibility in the
_ABI_ is all that important in live update's context. What is important
is that our users are able to live update from kernel version X to Y.
The line format the kernel uses to describe its state is an
implementation detail. Our users never see it.

The high level idea is that when you need to make a change to the ABI so
the kernel can better describe the objects/resources/files it is
passing, you create a new version of the ABI and allow transitions from
older versions.

Say you make some changes and need an ABI version v5. You don't get rid
of v4. You keep it around. LUO core will facilitate picking the right
version for the next kernel. So it will be possible to seamlessly
upgrade your kernel that speaks v4 to a new kernel that speaks v4 and
v5. Now this kernel can start speaking v5 if its successor speaks v5
too. And so on for going to v6 and v7, etc.

After a "reasonable" time given for upgrades, you deprecate v4. v4 has
been around long enough and our users have had a chance to go to kernels
speaking newer versions. That's when you remove the code for v4 from the
kernel.

We can argue what "reasonable" means, but the core idea stays. 

It will still be possible to go back to v4 or earlier, but you'd need an
extra stop along the way. And of course, vendors can keep a wider
support matrix downstream if they see the need for it.

Does this idea of "backwards compatibility" sound acceptable to you, at
least at a high level?

Now coming back to today's reality. We don't yet support this version
transition. I proposed the idea at LPC 2025 [0]. Logan Odell has taken
over the work since I have other things on my plate, but it is something
being actively developed. Logan recently sent some RFCs [1] for this
too, though TBH I haven't yet gotten to those patches. We also have
proposed a talk about this at LPC 2026, it would be great if you could
attend (if the talk gets accepted).

If you say that we should figure this version transition out and land it
upstream before we land the KVM code, I think that's a fair ask. I can
work with that.

But I think we first need to agree on the principles of the
compatibility model I described above.

[0] https://lpc.events/event/19/contributions/2049/
[1] https://lore.kernel.org/kexec/20260731215224.831696-1-loganodell@google.com/T/#u

>
> I totally understand that exploratory work and initial development is best done
> in private and/or in a small working groups.  But decisions that will significantly
> impact multiple subsystems need to be made *with* those subystems.  I mean,
> obviously it's possible to make a decision in a small group and then "publish"
> the result later, but then as is happening here, the community and subsystem
> maintainers like me may refuse to play ball if they disagree.

The design of live update was discussed and agreed upon in the open.
David Rientjes (and now Pasha) has been hosting the live update
biweeklies [2] from the very start of the project. The series is open to
everyone and notes shared for those who couldn't join. This meeting was
attended by a lot of people from different companies and different
subsystem backgrounds.

There have also been a microconference at LPC 2025 where topics around
live update in PCI, MM, VFIO, IOMMU, etc. were discussed, along with
presentations at subsystem tracks in other conferences.

Of course, it is impossible to get all maintainers of all subsystems to
attend these sessions or conferences. That's fine.

But I think it is quite unfair to say that live update is developed in
private or in small groups.

[2] https://lore.kernel.org/all/?q=s%3A%22%5BHypervisor+Live+Update%5D%22

-- 
Regards,
Pratyush Yadav

