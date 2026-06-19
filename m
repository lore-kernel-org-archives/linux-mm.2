Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AADFBCD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 15:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D6E6B0088; Fri, 19 Jun 2026 11:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6D76B008A; Fri, 19 Jun 2026 11:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5126B0093; Fri, 19 Jun 2026 11:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF296B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:08:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 846851C4ED4
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:08:13 +0000 (UTC)
X-FDA: 84896992866.17.24431E3
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 697EC140011
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:08:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qh7gWxbs;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781881691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3TBSgUEjRp+WV8w5lLZ9cfqTQGtaJprvjprmWubE8A=;
	b=J7pwXOMfRchp1leOa6154Wyl0kGO/QdPqGiMaHl5qaOvJrD6nQ+tQUGKoBdvt2q10iVkqc
	uekL658AhRv1IFgt8zUacQo57nlXPCWad9/962AujUhxCiDEXJ0CvdMNak5a7FM/WOn6CQ
	NBuVKyODzwy9KCV9ze9dl2GJxEXBhTE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781881691;
	b=v7PazChIlGKRExIPXSkuGCscOTKp5MhSKN8ApQvvQlwvAtO0FB4qZtmG5sUWF/QlJP76Uv
	kbSRuxDoqOTjKvl0MFyrAjrGHkHZzJUTr2M9JvnC8JESJuHzadlmPUN+7I+ETjr2LVQ642
	gyMlozMJz/uFbvyYIXU4gT5BjPFhVV4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qh7gWxbs;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-69605f796b8so8665a12.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:08:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781881690; cv=none;
        d=google.com; s=arc-20260327;
        b=c9DHVE3ByrzOS08fD8lqCEyZKeFjuTEMLEXzIOYcTYMp37nrXI4m1L127jlGpSK3kb
         K6jroCOY0wYshIBlIh0PDxw8gfKtRiNJN1irSqxuNjOy6xWTjILCRIHBUY0TPhgMZiDK
         9VeqipU86vVA19d5LwvO2IXnwi9n3h4zq53UlQOb8JoBNm67zJYVdZ1jn/2WmPDLl1yv
         IVwsJB+Y/52/huFgee0pYQ4yHGYz+nDJAWJV+K0+axICYDgBc9LMs7DjMRvBehebAiSm
         1XZY90e6OlUzYa5cCY3zkhI8mGhtJQEvBN5OqWtVnPH2qdn+C+OQs2NJ9XmRLuLmN2vt
         Uqow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+3TBSgUEjRp+WV8w5lLZ9cfqTQGtaJprvjprmWubE8A=;
        fh=xu48ds0pkHgnDg3RrRlp4jkRedX/UVZ8KH1JdFXRGuU=;
        b=f4rd7W4jkiZCMxi1N9eUHnhH/uompsidT2JdU9mw3hINoZaoHDMCtfp6dTwhMZge0h
         Lh0Rv1iGo4nVt3iZER0XNbp8IoUoHVgkNCvxJ+4m1EXygXOocz0hd4FR0KHuPYIPvErF
         34D1fHMktINxaBLPbv0HZEjSwBfwznJTt/PXkUYlP/Jn467niKyLCKQzbnB9KCRwW2KT
         P1t1IhFe3EeAn/LQ4eJojj+jUDqIfyjq09lYhpCxn0J9YLyiT4FuIMOgt/uASHlrospu
         qdxnEmfzbf++8RGBqfLUBwPKdmsCAqcabmZ2Zp81Xxv3X/oDtR/w9sPOoRL6dCj77KNi
         N1Gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781881690; x=1782486490; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+3TBSgUEjRp+WV8w5lLZ9cfqTQGtaJprvjprmWubE8A=;
        b=Qh7gWxbsi61ds/oU7cYS7XpL0GniN0dVv/HlVB97bnYTVBXqsskOvV3ecxRq694Br3
         cH6T2/8OSB+j2sCKlqpUIwGWXCooh5QRgkEvsyEeoy9KjQRBZ/xJwZwYt8f+0QvNJBbh
         x7y8jvT5eWi51m6ImDdD3PPrMlZharfPH4Wus5Usj4N9qZ0ZRcnexg6NyvquhkzRB5fW
         O5db7+8jVC4Lw/m7x92foNBV6UmRE94wgxZ5wm+TkLM9iJVFA9POoRQMLbZ/W1qzm8VJ
         Bny48JFS54Dp37GQgg9nm+kfYYwZGjRfrJ/qKg9rLrCDVnviKAG6r6VqH9PKOnrtC/5j
         PlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781881690; x=1782486490;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+3TBSgUEjRp+WV8w5lLZ9cfqTQGtaJprvjprmWubE8A=;
        b=lS06c90DHItxvu4jXP76gDZzOVrMYbho8DDADDMetmq+420G2kQ4WdoS0vBU3XnStU
         +ce8jtmjwXAr0V+s9J6UoKpI2o5UHXaf4sAgGrXgcJFPtZKNJVOeHNATncM1z3mDiXdW
         vUjf6rgZfTaz1fESqHAUe3/QBjV4F4MvvEsmTzX1b83zWLyFMqAIj1Eqzkh39bt3zL03
         9CfKThJ/kv0Y4rOX4Knl1tLHXInNrWM3pjKwAxCeJ5dlby067MYYuP8bSMN6eTbAr7gz
         foFS82RW/VkLSlWzkvToU5eI9OP8nzUWaMEVH/JX/EDcs5C4SrXX7bpknlB0leC5IrpV
         150Q==
X-Forwarded-Encrypted: i=1; AFNElJ+G4gVXLu5p1mJq7ePblOW/OtD2tjOUsenIe3Y86gLhdoXtiMi9sunvNM8L9G1XLHnE1v/NoYggJg==@kvack.org
X-Gm-Message-State: AOJu0YxVT9Gs5sQAxFtdHlu+yc6cnR6mfhMTHjyVX75VJth0aPZ2kqNN
	4NTquRtdL2aRiz4TfdBtgcjBsl7zXqmj/HVxV/0SCIgD+n4HNj8iM1dK8vBMVIzLLIOAjXEpuF/
	Mpm3CbxyfA/XF6TzdodHplYCAyTTlaA6gqpG0jfNg
X-Gm-Gg: AfdE7ck9tYZbZoxIzNCS6JYnqsMvAgBHQuY4OQ6p6UZl5pKBglnM+g7nNz6Cqd9U9yc
	W3Vxv9ZeHKDDtHmBEVrMc64h5MJ23cxNtajNYMd5zCCe+RYJU6XAS0onuG5anf9ZZRiypv083Au
	8jGv7+8Ny3jl9sghegROKvfNB2Q3eWLxn3YPxvaGsqdrlNWXgCb/DzPEIy76vDt3EU5vxiQMYaN
	3aFh4mZoE5a5LDzhwWlOoYA8FPBRso0Z1H8BZ4t67FYEYVtfhEmwdvq1NlChQyjS7hl83Y=
X-Received: by 2002:aa7:d4c7:0:b0:695:46d9:11d6 with SMTP id
 4fb4d7f45d1cf-697217024cfmr48401a12.6.1781881689183; Fri, 19 Jun 2026
 08:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260616190300.1509639-1-riel@surriel.com> <CAJuCfpEKgiQDGXgCKrqnn7Wk5YrT8nr4-H88PVeEruSKjtY_CQ@mail.gmail.com>
 <dd66797a-6fc5-4c31-ac43-d767560f3029@kernel.org> <CAJuCfpEqz9t-x8abYD6idtHmi9t8p4YfDmnbkJ-ix4i=RMS4wg@mail.gmail.com>
 <603e002e-77f4-492e-9ad4-75572e18fc0b@kernel.org> <ajU3q1e6mpWsJ6Xa@lucifer>
 <c56f8fe6-9e06-4a65-9470-1fcd12189ed1@kernel.org> <CAJuCfpGifYo0iafNrMf4piG8eSb2FSjgVoPr4P-3YDabiwe_UA@mail.gmail.com>
 <a0a3dd20-a255-42d7-aa83-5bffcaba3acc@kernel.org>
In-Reply-To: <a0a3dd20-a255-42d7-aa83-5bffcaba3acc@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 19 Jun 2026 08:07:55 -0700
X-Gm-Features: AVVi8CceQv_0R_07S2ugTGidQIoXxeQ88n5cr18BjmWMfPEvC06zCx1NIVNdijk
Message-ID: <CAJuCfpHXAXNSXdaHu0Q90Jmc-rSg-49vKM7ByVZT9WU+dsyaXw@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: __access_remote_vm with per-VMA lock
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-mm@kvack.org, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 697EC140011
X-Rspam-User: 
X-Stat-Signature: m7q69fps477pmqqri9owmotkomspsujg
X-HE-Tag: 1781881691-757751
X-HE-Meta: U2FsdGVkX19fBXx1scRDufdQbdTC24IlbYJBiJWdVQZtJPUinsLd3ZD/rBqey7VQvBLd5XtGPs1gKK6sTZFSR5bX8y3cP+3kNpYJ1m7DSXeClk/Y/ZUc1atGpsSsHYauy/KYrIz7sVpO6T20NGublJfXrYDvO5By9bd5dAb+EXiA5JalMKkYdFy3941Q53J4Sqvuok8FWIq2J3BrjUDdKynKIog08eN2C8/GFErk6pm99zLxearimhAj4lVCHgK9TQxsvz/VHWTtJXoKqI2BgtiuYhtToR+J2634IxouZknt0msNSfQT/5z/BjbDTqwPFc8LFuCas36fGnQTFV72UI6NT0/8KN6cWQsUxKYL6r8lIHNeEcRT96o2znWiUsdIgQHi0CfV5bzYdi+TLGqFUjr886vuuqq7HsGG01kD4/TbYfMjlnBiVwiCQb+7fgY4yuZedCzHuN+TpDb/RafaL+uX93RJDHpJj1PUftVpnrmvgcvxZfiwV9K/sJvaS1uTfYcOUwUoYe+WqWQOKXWZWg+uXVvI0tdP4OpHUjQk0nDo69vtQe4Gdgo0uyXftokBJUdrwQBAck//OghtFdxV4Ns3L3yL5Xh7koFy9v2veWI4ytWswNRfgSAM32tjBesbB1m8MNXL9KIDjvIJcxi4Rqj0hFrchCiA6TAl9VfECvbuk8OPvYrJ8mvYWSF6+GOpXM0QGkWfYe/qwLTsfT+DNHss5+mnhC+9SRhSny6Xoxz3lGy7lOSdluSfNP+xH1UwwFC471aqN8+Se38n/QG69HGfE8As+JtRK4Njq5NtUrYTcDVEfIsGD2z1FFIwPH87U3LL4kcuiP0PyvHpCoXUbJWKYbV6W57kyB+FPRNpYzSYVmRxtSO33AgbJtzGsHjyufyz5w7xoM0fh2CtqK9uQ4JSNVy8ZtuaozedfyRoCrwssbjTr5Tx3rey9z/GjngkAo4YoZFjlMogh3yuTrP
 unxRm6yO
 wCNNaipF92hiaGdcUecVFkSAlwcBe8mNJa3b8yoqgwxiccT4E/t0o1v0i8IBrbrtZ/v45JfdnVmy0l/vUzgh8Q1hS/YbGJbbbXz7IyWxrq1gH3asTHohtqvE2KFblvApOV7UUkGBfmb7SdLP6K3BULfbN78SFH+dcBSEIdX2ypmRWA7bbF9qLojqSkjsCmfNXWXiHa5nz0nGU75Dh91DbnXk5Pq4xcEmn0gGCOI3AgXWkhX2hHMvOwixVkR6hBTmjjpfZVzecMW9LIWiKXajIzy/2pxGOfqMPXQiwTZO0OR8CR7TWlExFhCOj1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 7:27=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/19/26 16:19, Suren Baghdasaryan wrote:
> > On Fri, Jun 19, 2026 at 6:05=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >>>
> >>> Well I think a critical problem here, as pointed out by Suren, is tha=
t holding a
> >>> VMA lock means that the VMAs around you can change and in ways that a=
re quite
> >>> problematic.
> >>>
> >>> E.g. The moment you drop the VMA lock that VMA might get freed and th=
en merged
> >>> with something else, and the next VMA you consume is the same one you=
 just
> >>> partially walked, for instance.
> >>>
> >>> Now perhaps you could reason your way around this, but I'm pretty sur=
e there are
> >>> cases where you might actually miss VMAs due to races (Suren knows be=
st).
> >>>
> >>> And also without an mmap lock people can unmap and map new VMAs in th=
e range as
> >>> you go through which might cause weirdness as well.
> >>>
> >>> Really, unless you are dealing with a single VMA in the range, I susp=
ect GUP
> >>> needs to stabilise that whole range.
> >>
> >> Well, depends, really. It's not like a all GUP operation that target m=
any pages
> >> runs exclusively under the mmap lock that would prevent any VMA change=
s.
> >>
> >> With userfaultfd, for example, we drop the lock in between, to lookup =
the VMA
> >> again later. There are various paths where __get_user_pages_locked() i=
s
> >> instructed to grab the mmap lock itself, to even temporarily drop it i=
f the mmap
> >> lock was dropped.
> >>
> >> gup_fast_fallback() grabs some pages to then take the mmap lock. And c=
ontinue
> >> from the next address.
> >>
> >>
> >> So it really depends on the use case. I would actually be surprised if=
 there a
> >> lot of use cases that strictly must block concurrent mremap operations=
 etc.
> >>
> >> The important part is that you process each virtual page address reque=
sted
> >> exactly once. If the VMA was merged in the meantime, you continue from=
 that
> >> address in the previously-processed VMA.
> >>
> >>
> >> Some use cases might indeed want to stabilize the whole range. But I w=
ouldn't
> >> expect them to opt-in to using per-VMA locks.
> >>
> >> Just like with any other page table walker, we cannot just convert all=
 in one
> >> shot to use per-VMA locks.
> >>
> >>>
> >>> If we could find a way to have GUP fast-path the single VMA case sens=
ibly, then
> >>> that's probably workable?
> >>
> >> Right, that's what I said: start with a single-VMA interface that supp=
orts
> >> getting called with the per-vma lock or the mmap lock.
> >>
> >> If we have to fallback to the mmap lock (userfaultd? indicated back by=
 the
> >> caller), handle it in the caller of that interface for now.
> >>
> >>>
> >>> And I agree special-casing only one place but not others sucks.
> >>
> >> Yeah, we're not doing that unless inevitable.
> >>
> >>>
> >>> Perhaps we could find a way to get this improvement without it being =
quite so
> >>> 'tacked on' but without needing significant rework of GUP, but in eit=
her case I
> >>> broadly agree we need to improve the codebase as part of the changes.
> >>
> >> We shouldn't fear extending GUP in a reasonable way that makes everyon=
e out
> >> there profit ion the long run :)
> >
> > I do not disagree with the general premise of making existing
> > mechanisms work better rather than implementing parallel ones. I'm
> > just pointing out my findings so far when I moved in that direction
> > and I'm happy Rik posted an alternative simple way around large
> > refactoring and started this discussion. We should definitely try
> > reworking GUP to cause less contention. I just don't have enough time
> > ATM to drive that, but would be happy to help with the VMA-locking
> > parts.
>
> If we have a VMA-lock GUP variant, I guess supporting the write part woul=
d also
> be fairly easy?

I think so.

> Not sure how performance-relevant that is, though.

All the contention cases I saw or heard of involved reading.

>
> --
> Cheers,
>
> David

