Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF67C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155716B008A; Mon,  7 Sep 2026 17:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107086B008C; Mon,  7 Sep 2026 17:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C376B0092; Mon,  7 Sep 2026 17:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C74736B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:33:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 572D34030F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:33:44 +0000 (UTC)
X-FDA: 85188268368.21.F7A1F99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 64EB01C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:33:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lOVRiolU;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788816822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glAq2A+LGqvZtGRjj6Vu76wV2nQ2vOLPDIiLnUABgOs=;
	b=fLmCW/NhLiXFZuzSX29wlMtG5rAAl+Euo5LMXqFd31cO22++lSZZ3jrFuOkrYzZBeSQ70y
	wccNi2bv6HmFngtpZTcbnENL5wyey6SlvfOJeGdxuMmLnUoijq6w6JGrkILQUkYdIdCxDy
	fuQrWqwxWh1MR8miJL10A1zomFyqWl8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788816822;
	b=P0n7n6Cr5lw0Is9eoz7I1P+x8vUI+pVywfgbXnp3aeZ95TY7X3JRoD1P2vSjpOzy/DUeAS
	QgmmqY5r7jgLiZXiBdAUwCa09gdyUWKP1KJD4rPyVcfZe2q5uSVy5TH4fk7TC0NdyiemML
	a9Yw62Vo02w2lJPtS/UOm9Nv2VLqm/0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lOVRiolU;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DA11444E7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427CF1F0155F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788816821;
	bh=glAq2A+LGqvZtGRjj6Vu76wV2nQ2vOLPDIiLnUABgOs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lOVRiolUuJdBzdns21YNoLq99TXgsNsteg1DQ5906S5QpffjdDRQocBGaW+h7tWqH
	 IxCKdHubpL1oWVBW+C/a/JqhLHWGkMs/IUmx6GfhacRf1Q8mffLkeSGxtIp2oGFbid
	 hk1A4/1zdoUWVltg+bEURpJWWI35evHxTMltztyVVB4fuiFPUodfTVLQNn6/RzDG4E
	 dCKtEJEogMo2GRnip7ZBUKOeymrOctOFaGHYoR5t9jGQVbxJgBeBCB+Lkr3E2csErH
	 wf8kE3+qBr+ZpVTS0xfU+fQ7UeuFIBwN1bZos7RuU9UA9wlJwJv3OaPqUudWm851fU
	 +PyAleap8Hhig==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-90cd4631090so51591076d6.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 14:33:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxE/24n4WmGKMM2mLVQp/jsdtseXSfDIp8sMrjdF4gEYHKZOckkljqA0xUcUFzkPyggu8t/nwmrOg==@kvack.org
X-Gm-Message-State: AFuF++lM19OSWpjX/TIuBsFMZHL+SrSgy4/lbEIquCD96KUJun6F9/o4
	7dqFHRHUNPCyUT8+slkUgKVY/u3VlQk8A1jRH/4iag6o7GlmOWd7DUdYfJBdBdH10TTE1SfLfNt
	j9urlAtRHKR3NRBJB5vq2w48aoxRa4So=
X-Received: by 2002:a05:6214:1c0c:b0:8ef:1c10:65fa with SMTP id
 6a1803df08f44-9103458aa2amr276801976d6.8.1788816820552; Mon, 07 Sep 2026
 14:33:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260901054358.4049095-1-dev.jain@arm.com> <20260901054358.4049095-6-dev.jain@arm.com>
 <CAGsJ_4yigbhqkrnufJKC2+rW7StraQvD0gr=4HQkTjKGQ9siGQ@mail.gmail.com> <12efdc7f-ff82-412b-b79d-bff211d34218@arm.com>
In-Reply-To: <12efdc7f-ff82-412b-b79d-bff211d34218@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 8 Sep 2026 05:33:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y7V40CnTTh=84=Ek6T3tPTyLXsUtgO81O1zyZpmQcbug@mail.gmail.com>
X-Gm-Features: AcwNN1W7wBndyQG2UgjXdfAU5SOq--TgDgMkAQm3YP67ZZN3rfn6CHCdxQXyE8c
Message-ID: <CAGsJ_4y7V40CnTTh=84=Ek6T3tPTyLXsUtgO81O1zyZpmQcbug@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] mm/internal: rename swap offset helpers to
 softleaf offset
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 64EB01C0003
X-Stat-Signature: pj5pudawp53watqarnb9feg8r7skt38c
X-HE-Tag: 1788816822-517314
X-HE-Meta: U2FsdGVkX1965eOifdI1M/LXB1ziK0IjPYxYCchAPZr/vLr8V9sDJatlTWQvfO6vpmRrjHHXYK6D/q3BJqVw9JQjNBW3JiUj32pcApYOb9Qv1EzFu65FztB5bB/JHXmS32pyPyTLOpTjEcRWbf88gMppacLfKIt0PPvYibpbS0kJVAS/1Jc0O1zUdnUrR226ySQgipi/dYbd35JQgNu6rr4Mf8I4bG+zYHqmvXHDSUKs1x9AJXFbCBUasT1w4KtdHTjBqzZmDl1Y7feJ3YtCB2v7iIZ021sbOEGMybTbL394h2vqoQ5C7gf+hLfZgVTqsVdsXWcPf3g+DqtLN7vxbuZh+/AHVqAHJCYaPAIczkob0Zt1JSl2ZnmusshaXhCfAx9AgCDG66XO8QxJeu0+IWW7ktZQbkDTgpQi9iuCgsb2+Hzy/LwfDpm6vsripErGMeg0LgjQoKO1wxRM7XdZbPYnyidXo0LCeOQ2c8DfWHW9YUVvFQ3ILm7s3RIsv8Qmy/U8/1AmGnE72/4/i80IbnhxjVzZMXjpkkCa/uvZM9u8BC4wArP5NO6RyC1owFq/dhloHBgSU5ErQNLSXepNRwLDtiuiTn9FJ1HB8g4fzPtm6+7kM8CWIVhORrLsCc7KFqpsA163UloEXhhkzleeCFlpowRF67MCbWu+eTu9uQxoAMr3g87/fNk7SZdvJzbXdvREjJFC0UVRPQX37mm+E7jURSRTrPbZ1h41Z6MOCEJjjp05U5URnvK7fzMlJu3eacnAY9BEF69S/0pctpI8J9sTzfpmMHsksPARSC9EKmDd/oaRrBMJ23qoKtNAhIfwQvTNjzt+VhcX0+EDHncsDYppuFXeI6AtUhwiKIYvAnU0g0B4Kn/TBK1vfRbcFq0+ADhyhRGlP/g2ZI+QMCW/CZbEnae2ktu1sbLgZYKolOP4dxjnVLM6tArFXSpGxAjsryMNN64dnEULUwRKO5w
 8OkoOrbd
 IcTeERGzqo6NTm187VFBvzLN78dzOcy7U6s6Q8KORqvoprhUzOp0+V9YYny5kTRrhGkhAKFp72rWkasEqZLOyiobPeKz0L94NHEpgY9QySbj/jdpMLLv/Z6+YsxhOfM8Jxs208MGt/v0rlaUuwWA6YNO1wXVAvLUFoNGIaBkavOaCIIwILwBwWFScej8RzKuA8qaN5kbhSok+3DFqMfkutCkeONTmJwR3g9aquN7wPDqVW4130nSb2lqgtAyMusgDflZbT36g+5CtdgqPYfNcjvAGFu3BF2qRbqRgTdHV/QupjnBQWVt8ha4ASnE7IYXa1TMlFSda1plPf0+B3yKkP/RRGeGr72IjVrtPFrkeXwhlDnBkC9vwWgVS/6N3Wd6skmgFvWfJGleGgzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 1:38=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 05/09/26 4:12 pm, Barry Song wrote:
> > On Tue, Sep 1, 2026 at 1:44=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrot=
e:
> >>
> >> In preparation for adding a helper to set softleaf ptes in one go,
> >> generalize the swap entry helpers shifting the swap offset by delta,
> >> for softleaves.
> >>
> >> Note that the soft-dirty bit, exclusive bit and uffd bit preservation
> >> will still work for non-swap softleaves, since a softleaf entry is
> >> constructed out of a type and offset, and those bits are ahead of
> >> the soft-dirty, exclusive and uffd bits.
> >>
> >> For example, for a migration entry, pte_swp_exclusive() will return
> >> false, as the exclusivity is encoded in the type itself
> >> (SOFTLEAF_MIGRATION_READ_EXCLUSIVE).
> >
> > I don't quite understand why you mention this. Is anyone calling
> > `pte_swp_exclusive()` on a migration entry? Shouldn't it only be called
> > when `softleaf_is_swap()` is true?
>
> You are right. I just wanted to emphasize the second paragraph - that the
> pte_move_swp_offset will also work for softleaf entries. But I think
> the third para confuses more, I'll drop it.

I would rather interpret this as meaning that
`pte_move_softleaf_offset` will also work for swap softleafs,
since `pte_move_softleaf_offset` will call some pure-swap
functions=EF=BC=9F

Would it be possible to use `if (softleaf_is_swap())` for
these cases to make the intent clearer? or we can
keep both pte_move_softleaf_offset and pte_move_swap_offset?

As `pte_move_softleaf_offset()` is getting a bit weird now,
a generic softleaf function has a lot of swap-specific code in it:

static inline pte_t pte_move_softleaf_offset(pte_t pte, long delta)
{
        const softleaf_t entry =3D softleaf_from_pte(pte);
        pte_t new =3D __swp_entry_to_pte(__swp_entry(swp_type(entry),
                                                   (swp_offset(entry)
+ delta)));

        if (pte_swp_soft_dirty(pte))
                new =3D pte_swp_mksoft_dirty(new);
        if (pte_swp_exclusive(pte))
                new =3D pte_swp_mkexclusive(new);
        if (pte_swp_uffd(pte))
                new =3D pte_swp_mkuffd(new);

        return new;
}

Am I missing something here?

>
> >
> >>
> >> Signed-off-by: Dev Jain <dev.jain@arm.com>
> >
> > Reviewed-by: Barry Song <baohua@kernel.org>
>
> Thanks.
>
>
> >
> >> ---
> >>  mm/internal.h | 29 +++++++++++++++--------------
> >>  mm/memory.c   |  4 ++--
> >>  2 files changed, 17 insertions(+), 16 deletions(-)
> >>
> > [...]
> >>
> >>  /**
> >> @@ -523,7 +524,7 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
> >>   */
> >>  static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t=
 pte)
> >>  {
> >
> > We might find a user for this in the future, in which case we might
> > want to rename `swap_pte_batch()` to `swap_softleaf_batch()`?
>
> That is what is being done here:
> https://lore.kernel.org/all/20260813-migrate-rmap-batch-v2-1-3c5424c555c7=
@amd.com/
>
> I don't have a strong opinion, I can also generalize this right now.

I don't know how you and Shivank are collaborating,
since you're both changing the same thing at the same time :-)

Hopefully, we can get one of yours into mm-new first,
and the other one can find a way to resolve the conflicts.

>
>
> >
> >> -       pte_t expected_pte =3D pte_next_swp_offset(pte);
> >> +       pte_t expected_pte =3D pte_next_softleaf_offset(pte);
> >

Best Regards
Barry

