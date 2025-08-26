Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63B21CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 08:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C7E6B0177; Tue, 26 Aug 2025 04:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934C86B0178; Tue, 26 Aug 2025 04:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8710C6B0179; Tue, 26 Aug 2025 04:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67F8B6B0177
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:20:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 17008847DD
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:20:13 +0000 (UTC)
X-FDA: 83818211106.10.4BCC166
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf30.hostedemail.com (Postfix) with ESMTP id 142D480013
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:20:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oKSUGfzM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756196411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5qb1sBBxeGorHMHWQVVai+4xMA9ma3fz49qaUJb2LR0=;
	b=v1U7OanC/YXnmetcmVR8WlU/QAm+3ZfvfkDlmpdDPAALN8PXYhNpURRrLOj0A4tMA7yvCO
	iuI53uAqCnVIjZmBQhkYXMK1pQEYnF0YIadjzJKnLWf4RgjuHqbL0KZortJPeBT4TkjtNq
	oqI4cbS29x4stcYsLfX1r2qK0695oes=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oKSUGfzM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756196411; a=rsa-sha256;
	cv=none;
	b=RtNjQsInkfkyedinTYCjxRDMZ/dc1yO20h0IetHFTMxJ70Rqe2b4+MAVrTGjdOCpp3+ZTo
	bmuQKWY4KLJHrsVKYpF7gd0FU7Tb7DQuoZz+lZD9iugK77hrFEJqgfwRcOS5+Rufd1f9TT
	uyfmS8+2FEUvnDJfWxWvrmolGNDy24g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 2FC2E5C5E46
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753DBC116C6
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756196409;
	bh=sONuKki8B7TwWJ64reiC6mneIthkd8HsVY+Is145MIc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oKSUGfzMWHSaT+dHxVefkn5yvRO3lWoP1wYvSflK6QtQviyBA9S1sKEUU5boLItSv
	 Rt7Zu9KsM7t5axAyt4jja/yVYEWvWAGECiPMHlW++fvcFdvARRM7rBm2om5P+at7Bl
	 aaNZWBtT9OiI3v2wDwid1+Rz9DCshMQRU+i0gRgQAhtd4/6Wxy++xV+kPxSMYUHTMV
	 Q7a4nJuTcIoqb6Oi7rqhA9wtYkuhEnSFdVBZbNllBMtK3e+lnCbllPMoZ3tv0PQVq7
	 Ux6ajmGnrXLVminGBQ7te0wQqAywQjT5+dXfbThbJg+v5XWnRftO2Nezw75VrqXhuH
	 i3SRgXQrZhujg==
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d603acc23so41753127b3.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 01:20:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXxkzQjT8UltHDmiVNspVmY9s9LTp73HiQyAsa927amHcVX6h8zBI1eXAhOzJhFHj1dlwE94WTr/g==@kvack.org
X-Gm-Message-State: AOJu0YzYPVd4HtjgJepwSgDMcFDNs519MDvolSzfiTeDAATV28P9hoG9
	g5sSDLlsAjbpru7KxVpquUyXOp3HNZMoNDXFvhbs6N7v6jhChbzT3TtX00/bBbZk3Nuv8IB+fdX
	wVyfN525JqWAZt/SCb7kU2UD0QVCrir1rgsULnhS5rg==
X-Google-Smtp-Source: AGHT+IHhfA6toD9smW5R9Eqp3FwdYkE9zYj/5v7I/pPYUBkwflme2INXRlkFY6LnUaCPhnYcS6FDPoXOU1MLbVE8P1c=
X-Received: by 2002:a05:690c:74c7:b0:719:f1b0:5c29 with SMTP id
 00721157ae682-71fdc2b00efmr155584287b3.3.1756196408693; Tue, 26 Aug 2025
 01:20:08 -0700 (PDT)
MIME-Version: 1.0
References: <uyxkdmnmvjipxuf7gagu2okw7afvzlclomfmc6wb6tygc3mhv6@736m7xs6gn5q>
 <CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=KqQcnbrMdg@mail.gmail.com>
 <aKC+EU3I/qm6TcjG@yjaykim-PowerEdge-T330> <CAF8kJuNuNuxxTbtkCb3Opsjfy-or7E+0AwPDi7L-EgqoraQ3Qg@mail.gmail.com>
 <aKROKZ9+z2oGUJ7K@yjaykim-PowerEdge-T330> <CAF8kJuPUouN4c6V-CaG7_WQUAvRxBg02WRxsMtL56_YTdTh1Jg@mail.gmail.com>
 <aKXeLCr9DgQ2YfCq@yjaykim-PowerEdge-T330> <CAF8kJuM4f2W6w29VcHY5mgXVMYmTF4yORKaFky6bCjS1xRek9Q@mail.gmail.com>
 <aKgD7nZy7U+rHt9X@yjaykim-PowerEdge-T330> <CAF8kJuMb5i6GuD_-XWtHPYnu-8dQ0W51_KqUk60DccqbKjNq6w@mail.gmail.com>
 <aKsAES4cXWbDG1xn@yjaykim-PowerEdge-T330>
In-Reply-To: <aKsAES4cXWbDG1xn@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 26 Aug 2025 01:19:57 -0700
X-Gmail-Original-Message-ID: <CACePvbV=OuxGTqoZvgwkx9D-1CycbDv7iQdKhqH1i2e8rTq9OQ@mail.gmail.com>
X-Gm-Features: Ac12FXxNgoR7PbdQwij3wHUVAMYghI2NtgP6p7nAs3QGQFBgR0Y0mJ6P0oIqaU8
Message-ID: <CACePvbV=OuxGTqoZvgwkx9D-1CycbDv7iQdKhqH1i2e8rTq9OQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
To: YoungJun Park <youngjun.park@lge.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com, 
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com, 
	Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@redhat.com>, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 142D480013
X-Stat-Signature: or98dzyygkthnfrtjzwu4ufnbs76eyu3
X-Rspam-User: 
X-HE-Tag: 1756196410-94835
X-HE-Meta: U2FsdGVkX1++ypyUzDgPgDc+Rr+Ivna4sVwS9e7csbSTUonOxSxOcy8mG7+AZb57pL36+9YXZ/toQHta3VAPOUAZZr78BhG4unqy7101a6P0rXN2AXGC7Kx4XBZp5favDRni5c46lhEw4rkWNBolomEmCDzkQOO8hUxisSwgT8bEhwBUxtaJjs5T/zoQDXniWHbPue53RU/PLX94CeRqyY1xTcaK6F1ZrRc8QowhrwJCOiluE63S8+iaKlY7ogxrrdllQgK6jZfH4/QZinJTkv2Z4ff3TTX1Q9PLm348qKNEj8UuUJ8vnjICmERD1tPIAsAJHEfl5J5G5HRApFK+csbr6oD2JuUyiDfRCBnaG9dBd3fK8mNLFv7Vy1DS9vwJSvZjx7G74a0wVuOFhmF7VnPRT8G0iCZCo/uNKqgI9E3JZvIKPm5cDOMZu8G+5RXjwYTVQGmhUvtdZwSKIzSCgNeOjVAgBx+0VjhQkHNhmFK1pst/0TEeV1Cx/xwXZDRfN4uUVNhzqNFXvtVrWcBoDYmYcKlXVKJ3TyYhEx+dGUqIP2B3ty5F0gahzQmH945wkbBtWz8ThByohIgg6PLKdRCp8LnQ7R+ORqK4R6vopsuMMgoLoBvX1FVZTC2zRHdYya/Zsvj0ySFz1r7ss7rXg3ZKLoa7DTZUzYylY9VWZSkE3PpQ+jtUC1p86HURnXOnjZ+vQ+ODPn69P4c50QNGTkGiQgTU7aHLMMPsxm54tb7fsx1sqvGMM9GfkF6SQjlo0+vnqQEpl54rSPSbhZ4dxtYG0jQhNH3aRc7LxMoDlzfV2wDdPWgdsoSld4zaWok3FQC++Gj+iUXzFq/15xe4RAPgUeRv2QXJTvXbLbPF89OJZlkGQjSJJnhetA89/Y4u/0w7jG6XDcZLNZ2BHmqxD6wVDJCc6dYxMt37f4OfJaK6i2pegBuzPS/7XcSC/dlln6tty7C5qJC/VYMwp0Y
 AUjiJcMY
 L8yPVCMy7KGBZ73Gj0/xATtwSZiYouw4j2NPX/4HvOwDNbWbNuZHmQ+UutRj92/pw0N9/+8iFW3Bin0MiNfVzIeDyQCAAGJtJUp4DWHEtr97f4pZCCMdJZ6UdTs+Wr7FcAQ3yAvFe5Fmpm0u49SG8bMQWchK13CogiQV3GkcATZ28RkPyEsM/nnNStihjZMRl8tHkRidmgs6XG1YpXpRCo4IkbsI9Q6vM/H/dsO4+5+WWYZMkH5pwt6ZGAtiQpEfMLsY5e70jXH2BM78psjDCUhkybbSPO9x7IkcMzhh+9WiP7XH92VNuWCdGdORRyXZeHJpBe1ziPkRnyEg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 24, 2025 at 5:05=E2=80=AFAM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> > How do you express the default tier who shall not name? There are
> > actually 3 states associated with default. It is not binary.
> > 1) default not specified: look up parent chain for default.
> > 2) default specified as on. Override parent default.
> > 3) default specified as off. Override parent default.
>
> As I understand, your intention is to define inheritance semantics depend=
ing
> on the default value, and allow children to override this freely with `-`=
 and
> `+` semantics. Is that correct?

Right, the "+" and "-" need to place in the beginning without tier
name, then it is referring the default.

>
> When I originally proposed the swap cgroup priority mechanism, Michal Kou=
tn=C3=BD
> commented that it is unnatural for cgroups if a parent attribute is not
> inherited by its child:
> (https://lore.kernel.org/linux-mm/rivwhhhkuqy7p4r6mmuhpheaj3c7vcw4w4kavp4=
2avpz7es5vp@hbnvrmgzb5tr/)
Michal only said you need to provide ways for child cgroup to inherit
the parent.
The swap.tiers does provide such a mechanism. Just don't override the
default.  I would not go that far to ban the default overwrite. It is
useful no need to list every swap tier.

BTW, Michal, I haven't heard any feedback from you since I started the
swap.tiers discussion. If you have any concerns please do voice out.

> Therefore, my current thinking is:
> * The global swap setting itself is tier 1 (if nothing is configured).
> * If a cgroup has no setting:
>   - Top-level cgroups follow the global swap.
>   - Child cgroups follow their parent=E2=80=99s setting.
> * If a cgroup has its own setting, that setting is applied.
> (child cgroups can only select tiers that the parent has allowed.)

That is too restrictive. The most common case is just the parent
cgroup matters, the child uses the exact same setting as the parent.
However, if you want the child to be different from the parent, there
are two cases depending on your intention. Both can make sense.
1) The parent is more latency sensitive than the child. That way the
child will be more (slower) tired than the parent. Using more tiers is
slower, that is the inverted relationship. Your proposal does not
allow this?
2) The parent is latency tolerant and the child is latency sensitive.
In this case, the child will remove some swap files from the parent.
This is also a valid case, e.g. the parent is just a wrapper daemon
invoking the real worker as a child. The wrapper just does log
rotation and restarting the child group with a watchdog, it does not
need to be very latency sensitive, let say the watchdog is 1 hours.
The child is the heavy lifter and requires fast response.

I think both cases are possible, I don't see a strong reason to limit
the flexibility when there is no additional cost. I expect the
restriction approach having similar complexity.

> This seems natural because most cgroup resource distribution mechanisms f=
ollow
> a subset inheritance model.

I don't see a strong reason to make this kind of restriction yet. It
can go both ways. Depending on your viewpoint, having more swap tier
does not mean it is more powerful, it can be less powerful in the
sense that it can slow you down more.

> Thus, in my concept, there is no notion of a =E2=80=9Cdefault=E2=80=9D va=
lue that controls
> inheritance.

Then you need to list all tiers to disable all. It would be error
prone if your tier list is long.
>
> > How are you going to store the list of ranges? Just a bitmask integer
> > or a list?
>
> They can be represented as increasing integers, up to 32, and stored as a
> bitmask.

Great, that is what I have in mind as well.

> > I feel the tier name is more readable. The number to which actual
> > device mapping is non trivial to track for humans.
>
> Using increasing integers makes it simpler for the kernel to accept a uni=
form
> interface format, it is identical to the existing cpuset interface, and i=
t
> expresses the meaning of =E2=80=9Ctiers of swap by speed hierarchy=E2=80=
=9D more clearly in my
> view.

Same.

>
> However, my feeling is still that this approach is clearer both in terms =
of
> implementation and conceptual expression. I would appreciate it if you co=
uld
> reconsider it once more. If after reconsideration you still prefer your

Can you clarify what I need to reconsider? I have the very similar
bitmask idea as you describe now.
I am not a dictator. I just provide feedback to your usage case with
my reasoning.

> direction, I will follow your decision.
>
> > I want to add another usage case into consideration. The swap.tiers
> > does not have to be per cgroup. It can be per VMA. [...]
>
> I understand this as a potential extension use case for swap.tier.
> I will keep this in mind when implementing. If I have further ideas here,=
 I
> will share them for discussion.

That means the tiers definition needs to be global, outside of the cgroup.

> > Sounds fine. Maybe we can have "ssd:100 zswap:40 hdd" [...]
>
> Yes, this alignment looks good to me!
>
> > Can you elaborate on that. Just brainstorming, can we keep the
> > swap.tiers and assign NUMA autobind range to tier as well? [...]
>
> That is actually the same idea I had in mind for the NUMA use case.
> However, I doubt if there is any real workload using this in practice, so=
 I
> thought it may be better to leave it out for now. If NUMA autobind is tru=
ly
> needed later, it could be implemented then.

I do see a possibility to just remove the NUMA autobind thing if the
default swap behavior is close enough. The recent swap allocator
change has made huge improvements in terms of lock contention and
using smaller locks. The NUMA autobind might not justify the
complexity now. I wouldn't spend too much effort in NUMA  for the MVP
of swap.tiers.

> This point can also be revisited during review or patch writing, so I wil=
l
> keep thinking about it.

Agree.

> > I feel that that has the risk of  premature optimization. I suggest
> > just going with the simplest bitmask check first then optimize as
> > follow up when needed. [...]
>
> Yes, I agree with you. Starting with the bitmask implementation seems to =
be
> the right approach.
>
> By the way, while thinking about possible implementation, I would like to=
 ask
> your opinion on the following situation:
>
> Suppose a tier has already been defined and cgroups are configured to use=
 it.
> Should we allow the tier definition itself to be modified afterwards?

If we can set it the first time, we should be able to set it the
second time. I don't recall such an example in the kernel parameter
can only be set once.


> There seem to be two possible choices:
>
> 1. Once a cgroup references a tier, modifying that tier should be disallo=
wed.

Even modify a tier to cover more priority range but no swap device
falls in that additional range yet?
I think we should make the change follow the swap on/swap off
behavior. Once the swap device is swapped on, it can't change its tier
until it is swapped off again. when it is swapped off, there is no
cgroup on it. Notice the swap file belongs to which tier is not the
same as the priority range of the tier. You can modify the range and
reorder swap tiers as long as it is not causing swap on device jump to
a different tier.

> 2. Allow tier re-definition even if cgroups are already referencing it.

You can still swap off even if cgroup is still using it.

> Personally, I prefer option (1), since it avoids unexpected changes for
> cgroups that already rely on a particular tier definition.

Swap off and on already have similar problems. We can't change the
priority when the swap device is swapon already. We can go through a
swap off to change it.

Chris

