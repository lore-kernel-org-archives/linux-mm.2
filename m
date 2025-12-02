Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50439D12669
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 19:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270386B000E; Tue,  2 Dec 2025 14:18:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA966B0010; Tue,  2 Dec 2025 14:18:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C19B6B0012; Tue,  2 Dec 2025 14:18:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E874A6B000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:18:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A8CE12B92
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:18:52 +0000 (UTC)
X-FDA: 84175493304.25.188CAF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 369CC1A000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:18:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=StBBzT7u;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764703130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQwD/pYqrsi4sYpQ8TGF7O25ya27vxW0VLWC8qCWQpk=;
	b=71o3eLIt27EHp0fImrQv12MABCGz2ekRJ9f4bcRMMAwaNJFo3dqOJOyAzfNbfVErHA2ZJC
	N3HRMmAMZxyRORkT/InKVyWBassSb0ehTdySTmatYKtg7GkMlXoyTTKOKkSulJdeY+mW92
	F2jLFZ/fzK4nxilCQRq65soWWgJc8J8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=StBBzT7u;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764703130; a=rsa-sha256;
	cv=none;
	b=d4e8CnKWE+URprYKUdqwLALSNaASzSM173ZwIx0WOuK3LqsB8ikskEcQKrk/q7tTGJ+dvI
	oaDIpVkplj2mCsaRMyWm+3dvdi3OVlupaYZyzHuRc85C1AuqClEP5ZUMVtsKW2AoFGXjSd
	RgsaIk3Lok7GcKMh98yJfim6bKekgr8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34C62601A3
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D3AC2BCAF
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764703128;
	bh=jgKhhBhPqNyJSN8q7mPkS5e4XHh3cadrSKodnAwrEos=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=StBBzT7uBqqd1FA/GQMnUOQj+AhHC+6w4fP+VPF8Fn/s1NVqk4h/NhbMJ0tgGbOV2
	 VeFFSu4eNT2fXdJJoKVrNllZb4XmYVIh0X5KURIjVlgrwFh4+AbLvD/HWdsUgLEqWq
	 lxMdbRslXbKVO5vWj0/LBEtCNHsiq0vn4fJVA9ovXsXhOuFMaCEEMxuw4zNwsp7uMT
	 vqjlrasGj0PFdLkgUi1EkUSeOKBgq58PlS7tGSHuvCMJAi7f9W1k573/ZN/KM9mVlz
	 Y9obnrRXuSmZA5EqCOjTPj7+VqTWdTaUE2V0Jqd1RiBvAgw5vOBgGhiR8sVwHYiHBO
	 uSJDXGy6yJJpQ==
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6420c08f886so7496803d50.3
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 11:18:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXDBACgLoMyquYF4gMoWHi/9pQSzFeDNuYgxrG8sKttS2xt3PlGtGvtBOXKRiVDdiF41gQp1F7X0g==@kvack.org
X-Gm-Message-State: AOJu0Yz/Z+YLZIBr88APlT47OI5OiQttT4kfUrcBq+T215NpIXEAa3RW
	daynwGfJYMyPg5Daw/EyLVi8b6KX56QLNPQLiKx/X3B/4O4KEWdVXmaSB0otGNEBl0mtnLFW65t
	wEKy3ocB3JO4+dI4u2M2Vb8i5qB44QfkeAaRjikyEtQ==
X-Google-Smtp-Source: AGHT+IEIB7sx5zppA3mWzsRPeEYVKlUaUJN189bAvMjD0J9PkHHOZ6ZDLi/4TcPxDGluwdX5eFc92ZpmYb0Gi5wSWxI=
X-Received: by 2002:a05:690e:e8c:b0:641:f5bc:68d9 with SMTP id
 956f58d0204a3-644352753e5mr422327d50.70.1764703127839; Tue, 02 Dec 2025
 11:18:47 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org> <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
 <20251124193258.GB476776@cmpxchg.org> <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
 <20251125213126.GB135004@cmpxchg.org> <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
 <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
 <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
 <7e44e8654eb0ed5e0f590b3d705b258772dadb57.camel@surriel.com>
 <CACePvbUSHYgit93ofjg6cMfb+CR9x6CZnMGh7Utb+zEzkOG75w@mail.gmail.com>
 <CAKEwX=MMgOb+7tDxPXDCcBxCEztvajDa0YfLBqgGuAr8GQ4s1A@mail.gmail.com>
 <CACePvbWV3STyCg0vYDXYg7asnxLTa4Jb5Fa59g7_QeTVxKV=ig@mail.gmail.com> <CAKEwX=MWU0An-Y3rwncSZ24h2Yb=RdzP7FaHr8uiAYx7MTFiAA@mail.gmail.com>
In-Reply-To: <CAKEwX=MWU0An-Y3rwncSZ24h2Yb=RdzP7FaHr8uiAYx7MTFiAA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 2 Dec 2025 23:18:36 +0400
X-Gmail-Original-Message-ID: <CACePvbWZhz_2GkWhQSfq=VN2TJzY0FnyNZMkDhH0oY-Q7p5ohQ@mail.gmail.com>
X-Gm-Features: AWmQ_bmo-7gP7a5ilmuGTzatOnmFTCCHFs8mrJ1EddPx7qCj6AAE2iSfaU_6WoE
Message-ID: <CACePvbWZhz_2GkWhQSfq=VN2TJzY0FnyNZMkDhH0oY-Q7p5ohQ@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 369CC1A000D
X-Rspamd-Server: rspam02
X-Stat-Signature: de96dyt58hdxsn4o479dmc6kjuaa3ni3
X-Rspam-User: 
X-HE-Tag: 1764703130-515196
X-HE-Meta: U2FsdGVkX1/RyTJSeTlYugiu+i1AbCfbUCe287ttGqccqoeD84vAjbbfD5YMn9dWhhWaqgJ2kDwz/9DS8+kw5xOMEug3vDJN3tHeaBm9SHtZfUuWp2Fh07CcIIFuSg5DdomJ/Joy21uCpTxeXK7L7to5GKJOI4nxJ1k9PVw2aex9UEGknjBIVAheXDEBV5PtcXjx9YVopa+idE9yKdKOqe+mhw6NXNRl8HUI0V40SSKsTWFyP01I0PagaVZ9emrcU8WW4lxh/+wm4n5z1cjDwYTjDbTgrglhnGbOa9rX86Veqb29EUarn1hlGw0S7bHhCY0XUVqQA7lBu1ZuEePxDrE3S85kpl5aojisY6YDzx19cfcidx1ovrG9A07CsAzsVBCDwN9TCMww2BDWN+2h4RRu/0uRtZEGldL9AVCg0kqS00TJ6OTv/YRlLTvSLtlAyEPuJ4gKvv7neQV+TjgRKKNFONGZodZ9QGLkAblg8lJvNIAxyN6IEI5nYEgaeB308ke582c4j+ZXUsNCgh85H8f+NeTQXaOd7bvmTfUOZL0vEbaMzPijVeNKF/dbrOuc+wRuQC9Dqv8stGWMaCClQWRbKFcnLkXafXFtq7xKAq8PxTUSrRajbQY4KRKYxErhkp/fJC/p+CtY4062dJLyXn1uPrnE2xnHTBjKu34oiacbFG3egEolkuFJjhlXJo5/ko8cA/O9tOYTSgFyl8SYpkSTcz/cyBwzLKSq2zR4KIBAcxqymspWSjyRx2h8Qt14wBOIP2qKQqYsdzKWiKoqkM63NfDh+2h9jEP7teyfQB8p24UaJfbQxX2HGifhavBt/vDUbh1Mh5DgSMlTkfduguZQjL7vx9L5DaHbHWhgf4/TmCKAqvPl4j0Tuv77dA07izviQdKlX2bVfvs9ScgsFP8FHcvImwIhpF29mJCEPzSVaYTfLTo/qtV0Lv4dYWGUUeK9731bS4imn1gs4zm
 VP3xa30U
 RGenhrJ8Ffl/70bKhQAPUzUaKuwiAFtLy7OVcDc+yeJbo1KiQIgXoEh7i6dU9yh8CiX6ntsjvJYnpSjmEtK0kc5v+Ry0WWNMc7+Kg6n64emdhICm+nHur8SnpKLMeiHvNY//WeYxsdQA/lyt9IgTNu9BagDTXQ1ZPQ/XSFAI54Yeb6+GLRdYc5twR0NRL1euGM6mkSaLc9gU9Jy4uvsmBVyn8qWB+pcJCCn8mceguLL3czn55MXof38EBt6xhRwycoUwnlw8+v7f66JQVRAc2aKwX900aSZg50K7YTPdy/5EXwhCEy9UfTRmfRymAJjpGQlF+fV+rKrJ9GAJmrj1qb2SeepLs2yfiPHF083AgcqtvpZ5bNy6JmDT+N1pAtRc6eYcTyY/AZ46+/yM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 2, 2025 at 3:37=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Sat, Nov 29, 2025 at 12:38=E2=80=AFPM Chris Li <chrisl@kernel.org> wro=
te:
> >
> > On Sat, Nov 29, 2025 at 12:46=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> =
wrote:
> > >
> > > On Thu, Nov 27, 2025 at 11:10=E2=80=AFAM Chris Li <chrisl@kernel.org>=
 wrote:
> > > >
> > > > On Thu, Nov 27, 2025 at 6:28=E2=80=AFAM Rik van Riel <riel@surriel.=
com> wrote:
> > > > >
> > > > > Sorry, I am talking about upstream.
> > > >
> > > > So far I have not had a pleasant upstream experience when submittin=
g
> > > > this particular patch to upstream.
> > > >
> > > > > I really appreciate anybody participating in Linux
> > > > > kernel development. Linux is good because different
> > > > > people bring different perspectives to the table.
> > > >
> > > > Of course everybody is welcome. However, NACK without technical
> > > > justification is very bad for upstream development. I can't imagine
> > > > what a new hacker would think after going through what I have gone
> > > > through for this patch. He/she will likely quit contributing upstre=
am.
> > > > This is not the kind of welcome we want.
> > > >
> > > > Nhat needs to be able to technically justify his NACK as a maintain=
er.
> > > > Sorry there is no other way to sugar coat it.
> > >
> > > I am NOT the only zswap maintainer who expresses concerns. Other
> > > people also have their misgivings, so I have let them speak and not
> > > put words in their mouths.
> >
> > You did not mention the fact that both two NACK from zswap maintainers
> > are from the same company. I assume you have some kind of team sync.
> > There is a term for that, called "person acting in concert".
>
> I mean, Yosry pointed out issues with your approach too. Yosry is from
> your company, no?

I don't know who's interest Yosry is representing on this issue.

> > What I mean in "technically unjustifiable" is that VS patch series is
> > a non-starter to merge into mainline.
> > In this email you suggest the per swap slot memory overhead is 48
> > bytes previously 64 bytes.
> >
> > https://lore.kernel.org/linux-mm/CAKEwX=3DMea5V6CKcGuQrYfCQAKErgbje1s0f=
ThjkgCwZXgF-d2A@mail.gmail.com/
> >
> > Do you have newer VS that significantly reduce that? If so, what is
> > the new number?
> >
> > The starting point before your VS is 11 bytes (3 bytes static, 8 bytes
> > dynamic). 48bytes is more than 4x the original size.
> > This will have a huge impact on the deployment that uses a lot of
> > swap. The worst part is that once your VS series is in the kernel.
> > That overhead is always on, it is forcing the overhead even if the
> > redirection is not used. This will hurt Google's fleet very badly if
> > deployed. Because of the same jobs, the kernel memory consumption will
> > jump up and fail jobs. Every body's kernel who use swap will suffer
> > because it is always on. The alternative, the swap table, uses much
> > less overhead. So your VS leave money on the table.
> >
> > So I consider your VS is a non-starter. I repeatedly call you out
> > because you keep dodging this critical question. Johannes refers to
> > you for the detail value of the overhead as well.  Dodging critical
> > questions makes a technical debate very difficult to conduct and drive
> > to a conflict resolution impossible. BTW, this is my big concern on
> > the 2023 swap abstraction talk which our VS is based on. The community
> > feedback at the time strongly favored my solution. I don't understand
> > why you reboot the community un-favored solution without addressing
> > those concerns.
>
> I reboot the VS work because I have not seen any indications that your
> design could solve the problems I believe are principle for any swap
> architectures: dynamicization of swap space, efficient backend
> transfer, to name 2.

So no new number and no new date yet.

>
> >
> > The other part of the bad experience is that you NACK first then ask
> > clarifying questions later. The proper order is the other way around.
> > You should fully understand the subject BEFORE you NACK on it. NACK is
> > a very serious business.
> >
> > I did try my best to answer clarification question from your team. I
> > appreciate that Johannes and Yosry ask clarification to advance the
> > discussion. I did not see more question from them I assume they got
> > what they want to know. If you still feel something is missing out,
> > you should ask a follow up question for the part in which you need
> > more clarification. We can repeat until you understand. You keep using
> > the phrase "hand waving" as if I am faking it. That is FUD.
> > Communication is a two way street. I can't force you to understand,
> > asking more questions can help you. This is complex problem. I am
> > confident I can explain to Kairui and he can understand, because he
> > has a lot more context, not because I am faking it. Ask nicely so I
> > can answer nicely. Stay in the technical side of the discussion
> > please.
> >
> > So I consider using VS to NACK my patch is technically unjustifiable.
>
> I'm not NACK-ing the ghost swapfile because of VS. I'm NACK-ing
> swapfile because of the technical requirements I pointed out above.
> Virtual swap happens to neatly solve all of them, by design, from
> first principle. I never ruled out the possibility of another design
> that would satisfy all of them - I just did not see enough from you to
> believe otherwise.

That is FUD. (Doubt).  Do you notice that over half of the core swap
code in the kernel now is my design? Swap allocator, swap table. Soon
there will be more like swap.tiers. Code will speak for itself.

By the way, FUD can be universally applied to anything, so it is a
distraction for technical discussion.

Let's focus the discussion on the technical and stop spreading FUD.

>
> I don't believe a static ghosttfile is it. In fact, you CAN
> theoretically implement virtual swap with a ghost swapfile as well.
> The staticity will just make it operationally untenable. The next step
> would be to dynamicize the swap infrastructure, at which point we
> revert back to the original VS design.

Just a starting point. Can incremental change to dynamic size. I
believe in incremental landing improvement in the kernel.

> I see the same thing played out in your response as well, with the
> redirection entry, then frontend/backend swap space. It's starting to
> eerily resembles virtual swap. Or maybe you can clarify?
>
> > Your current VS with 48 byte overhead is not usable at all as an
> > standard upstream kernel. Can we agree to that?
>
> Sure, which is why I sent it as an RFC and not as an actual patch
> series pending merging :) Its main purpose was to demonstrate the
> workflow of how a feature-complete virtual swap subsystem might
> behave, in all of the code paths of the memory subsystem. I can then
> optimize the fields piecemeal, while weighing the tradeoff (such as
> lock granularity v.s lock fields memory overhead). You and Kairui are
> welcome to criticize, comment, and help me optimize it, as did Yosry
> and Johannes in the past.

We need a new VS number close to first principle value to reboot the
discussion. Because you care about competing with something designed
to run close to the first principle value.
Until then VS is just a prototype, not ready for production quality.

> > As we all know, using less memory to function the same is a lot harder
> > than using more. If you can dramatically reduce the memory usage, you
>
> I don't necessarily disagree.
>
> I would, however, would like to point out that the reverse is true too
> - you can't necessarily compare the overhead of two designs, where one
> achieve a lot more in terms of features and/or operational goals than
> the other.

Then the swap table is landing the kernel. The ghost swap file I
submit is much closer to the production quality. If you merge that
patch now, the kernel can have a swapfile that does not waste disk
space. It also performs well NOW. Google has been using ghost swapfile
in production for over 10 years. So you are right, you can't even
compare the two in the sense that VS is not ready. I want to focus my
time to spend on something that can land the kernel next. Ping me
again when your VS is at that stage.

> > likely need to rebuild the whole patch series from scratch. If might
> > force you to use solution similar to swap table, in that case why not
> > join team swap table?
>
> Because even with the current swap table design, the allocator is
> *still* static.

Can be changed, will be changed, it needs to happen after phase IV of
swap table. As a matter of fact, a lot of swap tables clean up
untangle to make it happen.

> I would LOVE to use the current physical swap allocation
> infrastructure. It just doesn't work in its current state.

Help reviewing the swap table phase II and phase III then. Make it
happen sooner.

> > We can reopen the topic again by then if you have a newer VS:
>
> Sure.

Now I will conclude the VS: It is not production ready and it has no
dates when it will be production ready. It is just red herring.

Chris

