Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A9E0D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 23:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9B56B0007; Mon,  1 Dec 2025 18:37:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8812F6B0011; Mon,  1 Dec 2025 18:37:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797536B002D; Mon,  1 Dec 2025 18:37:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67F846B0007
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:37:47 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D60F896C8
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 23:37:44 +0000 (UTC)
X-FDA: 84172516848.15.6FADA8C
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 69E29180019
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 23:37:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bF4RAwyw;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764632262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP7ZbqclEiOa7hfSq2oUerultv3frnHHzxLDW9kt/KM=;
	b=TlqzQjuz0hSsiTUN7ND6LytEXPd08lX9MXxLz06YzFpzokDYKY1ymXEo8wCEK/F5WTxTYs
	S1cVhQQsqzLpWsbcArzKl0t045kgIDKsM8znq3jNSDWMxB/+LQct9x3hGNPvfEYcJU/4oc
	bcoanGPNlwTzQDfvDGR9JEdqiT1RkSA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bF4RAwyw;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764632262; a=rsa-sha256;
	cv=none;
	b=01ns4AjwUf4hI5K74mOEXkq4t7ISRSrAfARXaC6/KuJdztWSo0cFJSuTvzxbF8vzpMXv1b
	fhrN03WDqwE0BsFT0jY/mVsN/vQ+ODRK/7wlB65EbpUjIJyW42nS4RSHTkZvwrUWyv2JG2
	DyER8sRMQE8AnTOKEi2cXVNVGnpjj0c=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so55542055e9.2
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 15:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764632261; x=1765237061; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cP7ZbqclEiOa7hfSq2oUerultv3frnHHzxLDW9kt/KM=;
        b=bF4RAwyw+oLL0tCB10rdFfZBIzGFuOsNMfn2dE7lknoS670T1uCO3AYtRnpxEoLqF9
         JJhhGCIhub++2uNLiFkFj1tzXyhnLA7y0HVr5ubfinaIuapDPbyusiS1FJOLqJtzks7X
         DC/B4fVQ+h0FTfhTM1vAPAaz5nonfGPA7AGWoSZJ6g5hvbOJCIn+stY2Omjud06BiD21
         BSbDYFCtDroivFU0EwZe+52mAcIl4rp6jDVgCNgvt9rodf6qTUiyIhkxzeWBXVvOX8mG
         XFU3hB4IrIyztPZzssCaWTF+ZN4i7zoFCZ7GeH3YnfMeToQL77DEHIOY39BvML7Anchp
         X/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764632261; x=1765237061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cP7ZbqclEiOa7hfSq2oUerultv3frnHHzxLDW9kt/KM=;
        b=tMPzX68cit22dbSsTJOYUaFaywAE3ECak30LyU+ZRUjG1Fl4BRPL1jUC74g0l0uKIo
         PW0CjTYW8ZUUYNuzR+/YPNs/Chn3OmomiFrDcc5QidNqCnodpzChMcuHZYerV8xmEoet
         diSk7ddkQKx6k+TiixTHTUa2qnQ2vpWgmRNOo5+nkZBVUEXaj6bqH/qWei2yUcVv1h1x
         GlYq50OqD4HQN41EOS+5dvNpkzrdGAnhPJF0usxiPh/WUJiR1fFw439Gf8gRuXUib4Lm
         c7VY0WpjdQxx29KamBbxREV/GCKebz/6Z34aO8FRVXSLyPsAhGhBFB+YdujsYOv2ILr2
         uCeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNvvf4qMv0lxHj5PpEFUHAEoYEWRfHP6PWfcqGN2iaIPTdpZPn0abJ6OcIwYRgBCt48aMcw29gdA==@kvack.org
X-Gm-Message-State: AOJu0YxiZxpEaeBOHmrurWv3UNShrWWVnDOvmW+ZaJaPmHxLqkSdG9Tm
	ZhJZi+DP7tlFo74CDof0V0RoiIQKJiN11WnpUxcWbRjNuVX0OY1cQ0fB/AJXSjEzGZisB6HylT8
	GYP//KL9iUX0YWjPFPPl3qRWccOZCAh8=
X-Gm-Gg: ASbGncuFnvpRJHnaPDlrl/mhkqf2HCT9f/fWnaJL5pRshSJAjGQxhpDQwiaIJF6RhP4
	0zAGLhLexrvK0wvuzCkAuzkXRu44Rjni6X/2CNomAD1H1OS0FoZ1/RPHlSrE48T+temBPdgwaG+
	5XXn2VwrHgq8tHhtIVJEdfqAkT2T+gOJZrLQzVVySlA4ZDlNmD25m3Q/T8e74o/wd4W5LcMJsV6
	B8K/B+KIijYqLI2DnTHDvhI/8hcgEHubrsaPnEdtBNi9JgU0Jx4e2gz9yk95CAf/dJcWnIGYHVO
	lUq3qw==
X-Google-Smtp-Source: AGHT+IEQbQ9gyZw7wMLB+eo3fesqrxdJ82VmlbEDiYijnVFPvUBBEd1ibGaj7s2qLmKXqcTd46py0cU3iTqb7Imu+VE=
X-Received: by 2002:a05:6000:4028:b0:42b:3366:632a with SMTP id
 ffacd0b85a97d-42e0f355caamr28867517f8f.39.1764632260500; Mon, 01 Dec 2025
 15:37:40 -0800 (PST)
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
 <CAKEwX=MMgOb+7tDxPXDCcBxCEztvajDa0YfLBqgGuAr8GQ4s1A@mail.gmail.com> <CACePvbWV3STyCg0vYDXYg7asnxLTa4Jb5Fa59g7_QeTVxKV=ig@mail.gmail.com>
In-Reply-To: <CACePvbWV3STyCg0vYDXYg7asnxLTa4Jb5Fa59g7_QeTVxKV=ig@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 1 Dec 2025 15:37:29 -0800
X-Gm-Features: AWmQ_bmY-E0atU6ZCpQAKM6PHN3hn2f5QW-MBVFKJKjtfFxGR2IobANYTB8JXaA
Message-ID: <CAKEwX=MWU0An-Y3rwncSZ24h2Yb=RdzP7FaHr8uiAYx7MTFiAA@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 69E29180019
X-Stat-Signature: co7trimpoc94zg18fxjzjua4mj6i59qk
X-Rspam-User: 
X-HE-Tag: 1764632262-581908
X-HE-Meta: U2FsdGVkX197FQ1dhRiLKqKkKtZLfDNbMrl5s30Ru6VwKVCjXOfbQc8HKdlYwq+l7SiXDuqcpqF9GUNBu3fS5pxJ/PEkfdzO2/wg6tkRXBoYPkDavgx8xdEZGASgLYRRURTZLnIpgamCi+Pk9X1XD/P0SGw2dcp9133+EAueAo00oRhYgK1ShHBNL5lScQVZvr27Z6m0iWcl9TYw3ZdP7RDkJdJJ4vsIxhjb5zd24NPdV/+SgFtWL0q0qHXmlQllDewLPRJml75iGIRgTCZW9mXv6ZF1hyPTmY8nbVye6zqW84gnUSEqxE4t5eJbmRBBtr9jXkh6GgKGLz4VXcL6RhxJUR93tGegMUZOhLMte+0p5sGYfxlRK3Z7bwR8YhMYoClAFW8ezToj7tkafg5JHjLfN/Kx8xr94sWUp+l5fu4iuqKu+zBSJb2zvJCzPs6iZvaTgFHZBm0oIebMLsBDQa2EWeFc8ZYi5Mw6fSLuM8p3GU8J3/k5MOZQbC+Z2Jv/EnPc0P3XshIfo0jbK2yzkOHeQ2plFOLbk/tqJpwl+Vz7XVXJsZbbukIw3eq5D4WjWKLHcaIKSA/+yQsDU0wp39WVccv3Lj2PqZNnr1ywET+AsfCjOcpq7aVTSqZAhWk/+tfG9Rdhq+8UJCfYsoDKXgfNdGjHqr6t4B7mSzGOL7LY1gUShMevRcjLFq46uhs25OFkwyuLLkPwIFxMDT5lISmAUoJOeqQZhUW8PVH1L29kg6fe2OpINAllslGC4KSimEGmIke+6C+3CjVi/JHiqOkDJjbVcm2gnhCvi53ivDVjgVqKwKfmpVpd0QUjicVpw8NjMJdXwNdbKCTTi20XUzMPrSrdOhDn8tpz5F7PvrxzVlfbyKUPwUaC/ztZr+Mi8CFiEDdU5uEX+DGJMlDW4cI6UWFWuuMQwQjQ9opcmVqzn1MlAJmYccK8Rm41hScTm/JdzT7SX6ZiwAj7BH3
 6Jg5y9Kl
 fbo4ygUk3IdKHTZj1cHSzi5A5MMtl1lPXVDQ1DMATpMEekZ5we8BNqM1aGQNTW/vZIty3UjA4rxJf42H6f+9P//U0tJPuanepGkC7JVorlYO5ifDzgMFtNauJVaxvr8DfjDTqBnR9zmdRASS3+6TKGPnmo945v7i5AiXCbTBL1IM7klVHHOWmUl8v6oBACB+V12yeSbAc1IAlYwbLmeBHbxC1dg/UEZO0NiKG6UlWQdg5w37uFUWGbpaQyGZO4RJLS0qUHMOxwSx+2QeQ0qRHDT+mJpFh7OW79rrWBbMKxaSckXXzCuIX0KUwfRoWQ4act+WIfPBwrJlUgn3Tk7qfcuRcAm29NRm6f8hzblybaJwB8FVspbZNIYpuvWZoLAhzgy3lHYBKqlar1ZBJPuWUUnOPW0WzUHchmm2hn6iBSboBmNIEIWiJV28qMtCZdZAgF/2kRNY+KiwxfDzbpcvQn5JRwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 12:38=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Sat, Nov 29, 2025 at 12:46=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> >
> > On Thu, Nov 27, 2025 at 11:10=E2=80=AFAM Chris Li <chrisl@kernel.org> w=
rote:
> > >
> > > On Thu, Nov 27, 2025 at 6:28=E2=80=AFAM Rik van Riel <riel@surriel.co=
m> wrote:
> > > >
> > > > Sorry, I am talking about upstream.
> > >
> > > So far I have not had a pleasant upstream experience when submitting
> > > this particular patch to upstream.
> > >
> > > > I really appreciate anybody participating in Linux
> > > > kernel development. Linux is good because different
> > > > people bring different perspectives to the table.
> > >
> > > Of course everybody is welcome. However, NACK without technical
> > > justification is very bad for upstream development. I can't imagine
> > > what a new hacker would think after going through what I have gone
> > > through for this patch. He/she will likely quit contributing upstream=
.
> > > This is not the kind of welcome we want.
> > >
> > > Nhat needs to be able to technically justify his NACK as a maintainer=
.
> > > Sorry there is no other way to sugar coat it.
> >
> > I am NOT the only zswap maintainer who expresses concerns. Other
> > people also have their misgivings, so I have let them speak and not
> > put words in their mouths.
>
> You did not mention the fact that both two NACK from zswap maintainers
> are from the same company. I assume you have some kind of team sync.
> There is a term for that, called "person acting in concert".

I mean, Yosry pointed out issues with your approach too. Yosry is from
your company, no?

The issues I pointed out have all been technical, thus far. I never
even brought up Meta - I'm sure other parties have the same issues.

>
> What I mean in "technically unjustifiable" is that VS patch series is
> a non-starter to merge into mainline.
> In this email you suggest the per swap slot memory overhead is 48
> bytes previously 64 bytes.
>
> https://lore.kernel.org/linux-mm/CAKEwX=3DMea5V6CKcGuQrYfCQAKErgbje1s0fTh=
jkgCwZXgF-d2A@mail.gmail.com/
>
> Do you have newer VS that significantly reduce that? If so, what is
> the new number?
>
> The starting point before your VS is 11 bytes (3 bytes static, 8 bytes
> dynamic). 48bytes is more than 4x the original size.
> This will have a huge impact on the deployment that uses a lot of
> swap. The worst part is that once your VS series is in the kernel.
> That overhead is always on, it is forcing the overhead even if the
> redirection is not used. This will hurt Google's fleet very badly if
> deployed. Because of the same jobs, the kernel memory consumption will
> jump up and fail jobs. Every body's kernel who use swap will suffer
> because it is always on. The alternative, the swap table, uses much
> less overhead. So your VS leave money on the table.
>
> So I consider your VS is a non-starter. I repeatedly call you out
> because you keep dodging this critical question. Johannes refers to
> you for the detail value of the overhead as well.  Dodging critical
> questions makes a technical debate very difficult to conduct and drive
> to a conflict resolution impossible. BTW, this is my big concern on
> the 2023 swap abstraction talk which our VS is based on. The community
> feedback at the time strongly favored my solution. I don't understand
> why you reboot the community un-favored solution without addressing
> those concerns.

I reboot the VS work because I have not seen any indications that your
design could solve the problems I believe are principle for any swap
architectures: dynamicization of swap space, efficient backend
transfer, to name 2.

>
> The other part of the bad experience is that you NACK first then ask
> clarifying questions later. The proper order is the other way around.
> You should fully understand the subject BEFORE you NACK on it. NACK is
> a very serious business.
>
> I did try my best to answer clarification question from your team. I
> appreciate that Johannes and Yosry ask clarification to advance the
> discussion. I did not see more question from them I assume they got
> what they want to know. If you still feel something is missing out,
> you should ask a follow up question for the part in which you need
> more clarification. We can repeat until you understand. You keep using
> the phrase "hand waving" as if I am faking it. That is FUD.
> Communication is a two way street. I can't force you to understand,
> asking more questions can help you. This is complex problem. I am
> confident I can explain to Kairui and he can understand, because he
> has a lot more context, not because I am faking it. Ask nicely so I
> can answer nicely. Stay in the technical side of the discussion
> please.
>
> So I consider using VS to NACK my patch is technically unjustifiable.

I'm not NACK-ing the ghost swapfile because of VS. I'm NACK-ing
swapfile because of the technical requirements I pointed out above.
Virtual swap happens to neatly solve all of them, by design, from
first principle. I never ruled out the possibility of another design
that would satisfy all of them - I just did not see enough from you to
believe otherwise.

I don't believe a static ghosttfile is it. In fact, you CAN
theoretically implement virtual swap with a ghost swapfile as well.
The staticity will just make it operationally untenable. The next step
would be to dynamicize the swap infrastructure, at which point we
revert back to the original VS design.

I see the same thing played out in your response as well, with the
redirection entry, then frontend/backend swap space. It's starting to
eerily resembles virtual swap. Or maybe you can clarify?

> Your current VS with 48 byte overhead is not usable at all as an
> standard upstream kernel. Can we agree to that?

Sure, which is why I sent it as an RFC and not as an actual patch
series pending merging :) Its main purpose was to demonstrate the
workflow of how a feature-complete virtual swap subsystem might
behave, in all of the code paths of the memory subsystem. I can then
optimize the fields piecemeal, while weighing the tradeoff (such as
lock granularity v.s lock fields memory overhead). You and Kairui are
welcome to criticize, comment, and help me optimize it, as did Yosry
and Johannes in the past.

>
> As we all know, using less memory to function the same is a lot harder
> than using more. If you can dramatically reduce the memory usage, you

I don't necessarily disagree.

I would, however, would like to point out that the reverse is true too
- you can't necessarily compare the overhead of two designs, where one
achieve a lot more in terms of features and/or operational goals than
the other.

> likely need to rebuild the whole patch series from scratch. If might
> force you to use solution similar to swap table, in that case why not
> join team swap table?

Because even with the current swap table design, the allocator is
*still* static.

I would LOVE to use the current physical swap allocation
infrastructure. It just doesn't work in its current state.

> We can reopen the topic again by then if you have a newer VS:

Sure.

