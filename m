Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF01C61DD7
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD2E6B00A7; Sat, 29 Aug 2026 03:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E854B6B00A9; Sat, 29 Aug 2026 03:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D746F6B00AA; Sat, 29 Aug 2026 03:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB2EF6B00A7
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:48:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0AFAE1C21F5
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:23 +0000 (UTC)
X-FDA: 85153529286.08.E9EFCE4
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2024720002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=seryxQlH;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787989701;
	b=mHHB31Gr4b4Hfri9j6tzm38X9JiSKHdS65GTKr4wJMdhALWywtk6VKQ/qtb2gl0Me5yab1
	Op1ZTfDdvr+Ix2YDvAGNbfduk9fpGV405FenYX4oGGUCmpjrbfyBwsOYVnZZDWDzTHvZnD
	8AXvhnNE0ZODUxO+9PoSbcdwERpix6c=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=seryxQlH;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWapX60dJR+7QW79Phk5gItOGIsoVWovo6H2MZ5WZKI=;
	b=pt94FPFZ+19x23B1E+MyZ9daWilPvCAv3YPe3Lx0alPiHJtSC/pe/7R5S1hEvYLFZ0zL0I
	u0ebXQDHfQT+JG0dZlf1FiF3p+Ts+D34cz0RklQ3iTZJzg0rBF6WAFgAvsAkjmlHGs5D3C
	TeMN/F8HCoIME279n8m+9oowWZXtgBs=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c1c26d7e951so315901466b.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:48:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787989699; cv=none;
        d=google.com; s=arc-20260327;
        b=A6uutZ4neXrn5x+/SOJCZ3fRqjA3R/cNbEBQ/9/BZfGTkxQPz7aimX/LkyaI3HmKDN
         +Pu2fnFvntjilWehsvt/WnVW6tVF6Sf59kiozwIA4fSgY9QnSqyzJ/m0i5FhmftyMWyy
         5ITFXBiPReQpcgCb9efRm6ubOMvk+ch6krkvOdRJLkw1uVZmwHrmUb1XTudznxZim6w7
         SuRywLU/r1ojeE2TZMqPk/2VVwhUfrMGLWU+OYgKKtU6842PFDZ7MltGl0jEXHNQGwPS
         YJZRpki9/+07lRee+BnDlO7nvMnBO6JVF1ywvB075gnOSs7oi+BDSaCSu9mZDKoQklNu
         zCrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dWapX60dJR+7QW79Phk5gItOGIsoVWovo6H2MZ5WZKI=;
        fh=M3U06CuXaOIIY7qMb0QSr8jPpia2e0LkMWqSuX3fo7A=;
        b=knWOjyHLpOBv6ktpGRwViA7P6Dl+hELCBB0Ol7+gfMyi3HzNvMvMLC4VRfemVJl93o
         2aMe1zpajGxBoc1SN38xa5ki+wDQKq4MSpcZqdO7NHmLvrgpmIpq0LjnXHdSubb7P9m+
         af9R2KOUNGj141c3dDSMbqRdX7D2XM3gqIzzqu+rdY3Qn2rnDLi07gj0D6S2VRb8IvIM
         738Yl0C78srW0fCc0VwuklvFBQQOeF860gEKR9Zi/PFtsBEtBOXYEiCnyyVyUVL+q+3g
         iSg8hh+aBWl09OdgIT7L/+KFUgRh/O/0EH0CGyKKsu/fhGXDRAw5Gb5x98TP8VZnvqcb
         YGGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989699; x=1788594499; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dWapX60dJR+7QW79Phk5gItOGIsoVWovo6H2MZ5WZKI=;
        b=seryxQlHXqUd/iBKgOQiMAx84VMDxsaIrfDQpcHN5souI5QM/6jmuYfdOSrao8l+Pq
         gNvB1FVXZMLKanHyGucvXnRZScMx8F0RxpOw+qt+qHMOznNDoL5UWP0JPhMuBkmqDpGs
         UanMSWBlzgEyrcyYZSaDW9H0zuDFIWbs9xHB9N5EOCQEBiXypjJVFKq0gRgo0mRWBpaX
         DyNdUOYm4asJaBrirNnBhFDYP5YZR8A5KdAhuZ7+mBZxjld1kdLyPwbTBb/rrgfxd3I/
         aQv/UtxDRlfgAv6b/jNiBbnbJsAuhucncWzJdFGg0XVmX9nAbulk5abJFNT0ouiuIhZx
         SCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989699; x=1788594499;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dWapX60dJR+7QW79Phk5gItOGIsoVWovo6H2MZ5WZKI=;
        b=nGp5y+DIgSmUTTZFbZ6ujV3H75GGxbkSECp9SyVHlKYCIOIBTq/5msO21lTslfr3o6
         Yfj6e8hCPOAXqG4MpRtamOMmaGykDvPRa8kkng7/xEJ7kVwyuVyrFQATTYKzOjclHOhD
         3SrFssRREh12BZytu+LfZxn6sy9RrlDh+QvGa5w+pt6J+LaxcrK0rNDfV1fae5KcMJ0S
         rbgTew1a0Q44Pon4+0KlqQ/sO5JhniWBNUpaKfQ1hbZJZiHxkA/uSnqkJscN1CrIPo0L
         aFI/i4zLcBwEgeJRs3wZxm8ehiXG2HNVJOUKD9lrtOEqW8jUNKQuk7YjnPrtBVU44Dz8
         VB1Q==
X-Gm-Message-State: AFuF++mHA4YrPSN/hsBPNeoKQG8cPYrGLGQKQ1GTkQTPrP/6F2eAT726
	OBPQAWwMXEl9k2qai4h2uSpjyGAVkG3lXZ9wkLkGqYQkcKZqcQkK16kQsT3XuPQ/tYIFPI1kvVl
	BYRUn1SQhjbSXvM9VZ8gtEg9bOrXHJBs=
X-Gm-Gg: AR+sD12E12HGRk+ow40/AgcAhslMfwf1ivcCqk2OpWNv3Zm7VEBvA6brwh/N3Ik8DRK
	5vzLpiAVMGBnIHVoDnaDLGtdsLSRrsjiSKZ/dj5m31UVaTNwkbo6wGYeApuP5kxQdSD5Iz7MZo8
	oNpHNN2qpVq1U62HRtfnPpt5Gv0qYDNES1eb0yVqzo6XzBfZVJk6lGULZ+Cwh5x3ptlsOFvkfNT
	U82/dnXmitruCddoXYza2kxTqUac+cMBiUzUUnxjIw1YK7qs8I22CIBETfaGuunsURSf2MbiBL6
	wtq4K7cMVHhHBfKGHu0/SkEYSRnulBNH6SSJnPpQOdrejLBYxAbNroV3x63aMM1fHtGszT9/QUN
	O
X-Received: by 2002:a17:907:d0a:b0:c25:32b0:e56c with SMTP id
 a640c23a62f3a-c2556bc8abfmr1111092566b.4.1787989699264; Sat, 29 Aug 2026
 00:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com> <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 29 Aug 2026 15:47:42 +0800
X-Gm-Features: AcwNN1VPg-XLWwgQTNShvKrK-YhiJ14GL2XJlZsGpzpk42yCs3IhhH0zUnSFR9I
Message-ID: <CAMgjq7B7TFfBZLPorZEmg5y9u6TzFbYVQXZNC8+iztGtifmdKQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ridong Chen <ridong.chen@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: cd6z9b83w1o3yx3d983itakqkhrsuotk
X-Rspamd-Queue-Id: 2024720002
X-Rspamd-Server: rspam06
X-HE-Tag: 1787989700-148393
X-HE-Meta: U2FsdGVkX18rPMXUd7D1hDSNtKGCTA8bFZSQn41L9X6w8AxzZjM7NmX5QiSFUxxDew+y5VYmwfN78hOlJ55S8dPJL0zw0UnRRR8pld11iIliF99YWFRdyThAa5vtyh9VK/AF3x4ddO4VWu5Wqqc5kU0Jwp4pv6crcnrJJ+faP9WPxSos/Efd/mz97Sa9OLjHKxGUKEHXgF5/pgkZtkNM2PtRBOMqU/lUxreQH7Ez4XvXHs1fnLHG1z7vu55PMvwadvF3rl0Hzvc4OBRD68ee+y6hSj9On/C9XRlhjavJGT7ko6LC9A40E6ocmsYpsxp2mIKuHudQ2lpRr9fN+ZnMv/LpFt3ZqauwUjO9nQ2t1psvMYMMZvoKWhX6++2hXdj0sNma1+6yvgWPsEDLwxgonyU3ZG4BaxTShX0U0Q7jfY4k3ITflAMPxfLsYBqKdKOZj+tuoU5ELsWm0XitAornLFlHf3zL7mybFfxHklbiie8l4aGZtZZ9vklnK5jhZzQWJch9BGCDsPHrZkGMP3NBP/awP0oeLnnW6G/x0jZ7yguvXfM4wCDqovkKPf5btPCTUWXDcqdc4Ai1mcqH/MAAN5aO1d87ENcrkERlRQzFxPKRh4ddOHUk6BWGHHLoPUDx6hRc7HTFUKDmolzqRiMjdrH2PLHGNVdhNeHlwZBly7L7mRzhoP9we92pI5gjUJoLDm6Wc/EM7Ec0aHxspeex+pGATFXwF2Wk9r+ToDLb7TwuZW63j/ULfzSIvDo7xNTaM3CBNo1gOLzBc/NU80EUgZuSpZkz0xPitZLUr1saeISqQ1PiLqlYnp1eRhqI6jH7V8kBLo14B5Bdw62ad3sLadatzn1Gn415iSVcm2SuKpkrx741Z1aRed87hEIBvkGr341AIZAPJUA/8ECoTv84YFIeAvELMaNfSsy3BO3y03nS9jz0goEypvm76e/lQlXyoA+IkbLNLmgOfunDlcB
 dp5piNBP
 GQiH1LZq0/WmtuVRo3Bq5VdghtfagpHCWBWlEmzXZnwidMXfbAe88EQAvwHRkMyNVEJHm+o8djA7FGRFf/J7efWUJDUThVRfXZPGqQN2kN6dhbPYFrWcOpWjsUetjuvyhSKsAYhK1+3KGkTkYUYUK7XAfDENGu+SZSCEInGC0pThhvH62v0J7fxl8gCi0ABLcpmQJuoLgSVt6b/qthj2E8ia2pfxGW49knD6KpS1AovKOelJK3RzODGzUhI+1y/dTOBv1VBRE/tEIgRaL9VnQsvTqrRZj/0rilNwBq/qXnWdLzEvnVW84t4NEuGH5SMYR0vduGtveh1q3KSL2VrU4VgQny66jzhQVCZl6pHj3FGorZuCYj/bXzqydCpUlCnpFtL3xgAbz559oNFYsrWTMVYsDgGn7rYT7dBK/TQt+1q1PFQXO2npI4Zn5KDszlvTRLmLc8oY6jH+dh/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 12:22=E2=80=AFPM Barry Song <baohua@kernel.org> wro=
te:
>
> On Wed, Aug 26, 2026 at 1:53=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Instead of doing bit ops on folio->flags.f, introduce helpers for
> > adjusting a folio's refs and generation info, making the code easier
> > to debug and understand.
> >
> > No functional change is intended: some combined atomic operations are
> > split into two, which only creates harmless transient states. There is
> > no measurable performance impact, and some paths even look slightly
> > better in the generated assembly.
>
> Hi Kairui,
>
> I like your idea. Overall, it looks good to me. With some cleanup,
> we might have the following:
>
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/mm_inline.h | 76 +++++++++++++++++++++++++++++++++++++++=
+++-----
> >  include/linux/mmzone.h    |  1 +
> >  mm/folio.c                | 19 +++++++-----
> >  mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
> >  4 files changed, 114 insertions(+), 43 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 621c8653d8f7..edfaf2661812 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bo=
ol workingset)
> >         return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
> >  }
> >
> > -static inline int folio_lru_refs(const struct folio *folio)
> > +/**
> > + * lru_gen_from_flags - Return the LRU generation number from folio fl=
ags.
> > + * @flags: folio flags
> > + *
> > + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Retur=
ns
> > + * -1 if the flags indicate the folio is off the list (e.g., isolated)=
.
> > + */
> > +static inline int lru_gen_from_flags(unsigned long flags)
> > +{
> > +       int gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> > +
> > +       BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> > +       gen -=3D 1;
> > +       VM_WARN_ON_ONCE(gen !=3D -1 && gen >=3D MAX_NR_GENS);
>
> Since `gen` is an `int`, it seems a bit odd to have
> `gen !=3D -1 && gen >=3D MAX_NR_GENS` combined here.
>
> Do you actually mean the following instead?
>
> VM_WARN_ON_ONCE(gen < -1 || gen >=3D MAX_NR_GENS);

Thanks for the review!

Yeah, thats's a better sanity check, will udpate it.

> > +}
> > +
> > +/**
> > + * lru_gen_set_flags - Set the LRU generation number to specified foli=
o flags.
> > + * @flags: pointer to the folio flags
> > + * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive=
.
> > + */
> > +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
> >  {
> > -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> > +       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS || gen < 0);
> > +
> > +       *flags &=3D ~LRU_GEN_MASK;
> > +       *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
> > +}
>
> It seems that we are setting the gen in the flags, rather than
> setting the flags themselves.
>
> The current name makes me think that the function is setting the
> entire flags field, especially since `lru_gen` is used as the
> namespace for various MGLRU functions, e.g.:
>
> void lru_gen_add_mm(struct mm_struct *mm);
> void lru_gen_del_mm(struct mm_struct *mm);
> void lru_gen_migrate_mm(struct mm_struct *mm);
> struct lru_gen_folio;
> lru_gen_update_size(lruvec, folio, old_gen, new_gen);
>
> However, this function only sets the gen bits in the flags.
> Maybe we could use a name that makes this distinction clearer?
>
> Could they be named as below, or is there a better naming option?
>
> set_gen_to_flags(unsigned long *flags, int gen);
> get_gen_from_flags(unsigned long flags);
>
> Or something like flags_to_gen() or gen_from_flags()?

I think having lru_gen as the prefix is a good idea actually since the
header here is a very generic one, the word "gen" could be used my
many other subsystem or drivers, gen_to_flags sounds too generic..
While lru_gen is a very specific MGLRU thing.

How about just rename it lru_set_gen_flags / lru_get_gen_flags? And we
will have lru_set_refs_flags / lru_get_refs_flags below.

>
> >
> > +/**
> > + * lru_refs_from_flags - Return LRU referenced / access count from fol=
io flags.
> > + * @flags: folio flags
> > + */
> > +static inline int lru_refs_from_flags(unsigned long flags)
> > +{
> >         if (!(flags & BIT(PG_referenced)))
> >                 return 0;
> >         /*
> > @@ -155,11 +187,40 @@ static inline int folio_lru_refs(const struct fol=
io *folio)
> >         return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
> >  }
> >
> > -static inline int folio_lru_gen(const struct folio *folio)
> > +/**
> > + * lru_refs_set_flags - Set the LRU referenced / access count to speci=
fied folio flags.
> > + * @flags: pointer to the folio flags
> > + * @refs: referenced / access count number, between 0 and LRU_REFS_MAX=
, inclusive.
> > + */
> > +static inline void lru_refs_set_flags(unsigned long *flags, unsigned i=
nt refs)
> > +{
> > +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> > +       BUILD_BUG_ON(LRU_REFS_MAX !=3D (LRU_REFS_MASK >> LRU_REFS_PGOFF=
) + 1);
> > +
> > +       *flags &=3D ~LRU_REFS_FLAGS;
> > +       if (!refs)
> > +               return;
> > +       *flags |=3D (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGO=
FF));
> > +}
>
> Similar to the above, maybe we could use more descriptive names?

And here we have lru_set_refs_flags?
>
> > +
> > +static inline int folio_lru_refs(const struct folio *folio)
> >  {
> > -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> > +       return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, =
0)));
> > +}
> > +
> > +static inline void folio_set_lru_refs(struct folio *folio, unsigned in=
t refs)
> > +{
> > +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(f=
olio, 0));
> > +
> > +       do {
> > +               new_flags =3D old_flags;
> > +               lru_refs_set_flags(&new_flags, refs);
> > +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_fl=
ags));
> > +}
> >
> > -       return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>
> [...]
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 73a81b4a3e16..9ee9f8dc6805 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *folio,=
 const vma_flags_t *vma_flags)
> >         if (!folio_test_referenced(folio) && !folio_test_workingset(fol=
io)) {
> >                 /* Activate file-backed executable folios after first u=
sage. */
> >                 if (is_exec_file_folio(folio, vma_flags)) {
> > -                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, =
BIT(PG_workingset));
> > +                       folio_set_workingset(folio);
> > +                       folio_set_lru_refs(folio, 0);
> >                         return true;
> >                 }
> >
> > -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_re=
ferenced));
> > +               folio_set_lru_refs(folio, 1);
>
> We have quite a few instances of folio_set_lru_refs(folio, 1) and
> folio_set_lru_refs(folio, 0). Do these values have any special
> meaning? Could we add wrapper helpers to make the code more readable?
>
> `1` just means `PG_referenced`, right? Could we add a comment or
> changelog description to clarify that `1` actually means `refs =3D 0`,
> but `PG_referenced` is set?

Right, I introduced a LRU_REFS_REFERENCED in a later series. Now a
comment could be good enough, as in fact PG_referenced is already kind
of a unstable page flags under both MGLRU and CLRU. For MGLRU it only
mean the refs count is larger than 1 so using a strict 1 here seems
even cleaner, but it still keep getting cleared in many places. As for
CLRU, the flag keeps getting reset when a folio is activated leading
to an under-accounted value from smap and other components. So
sanitizing its usage is a long-term goal.

