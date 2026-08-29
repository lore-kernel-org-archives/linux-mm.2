Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D065C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 08:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186696B0088; Sat, 29 Aug 2026 04:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15DF86B008A; Sat, 29 Aug 2026 04:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074D66B008C; Sat, 29 Aug 2026 04:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2FD36B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:26:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52A6812066C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:26:35 +0000 (UTC)
X-FDA: 85153625550.14.BC4F86E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7896FC0004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:26:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VX3mGmcw;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787991993;
	b=Rkgo8L3SPgRpuvEcO0hL15BlDqsPfxOakQyiUYotNKikJFWlPp19mgVmo4w3WEIX0GHkzj
	o+5mTZ4Sd52fHCWFnF7QKm1+C1XaeCrzs4zin1MFj+9xcOTUkw5GW/E6yzY8Ti6AppzwJh
	jlPrJUrtRHdL25VOKjKBs6QRKr/1MVo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VX3mGmcw;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787991993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELz8WpSjJQ38zjegY/jVb779cX2lY7cfwp1pllayTUM=;
	b=vdTe3oLJB1KrUjwREwZ0xEfOjV87LZZB9KIA+tGUyPCAGDALCDJFFWVsGdtCV8fck3vb/o
	oz652zRxv1tD3K1M8CrE+j6JhklJQ9e1FHOS3JvDOLc5NEfcvQVCGZ66sq9K7dtmKQF8kt
	k7aucpoatkRXYkolAf1kMZ6dxR/yB9I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 627AE601FE
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C2B1F00ACF
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787991992;
	bh=ELz8WpSjJQ38zjegY/jVb779cX2lY7cfwp1pllayTUM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VX3mGmcwK3arZBZaxnK+cLQQYM75+vBP4n+6HcOqKFptpaZqeOC+MYXommfOyItgJ
	 swHsvPpCgTE3WvLmZqhHBwFNIZ/uOytolr4D8399ZL1UhHyeDsxIpRMgCp8oyTHKL7
	 1zWgFobF0P7xX0A1Nki6UMpR5fkwcDMbYhmnD7b4qwxRIJUpPOYseuQ2vOWQmdd5/H
	 /609oaOqp1k6M18mTaqFq4cV3HEx1yGp8BfaXdxs8TZFfa6c3vzs1BAzC9GcU5eNwN
	 wConOUZXx+3CQTdsLXtXjey8YgS6KgFfwQxfgmhRwnegQx0vNNVBHEim/4gG2fYB+S
	 1xmwww2NXkhvg==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-936dfd009d1so268950785a.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:26:31 -0700 (PDT)
X-Gm-Message-State: AFuF++lyKsR3pi0+LtgH4pQOIl5ZNLAqKik9G7M9aKLuIQt3Mbrkz/o5
	oxH3HXjdKN+2JmypuKZrAu2n9Yd94OvIS9mCqVBYWP4vXeVcTe0WDdu47YeKfVA8GM4A4DwjCa0
	wJ4tyd58Z0CMyJjzHWF3zHPgEcZwleLg=
X-Received: by 2002:a05:620a:2901:b0:92e:57ea:8c8b with SMTP id
 af79cd13be357-938ff9abf4fmr2092839685a.0.1787991991229; Sat, 29 Aug 2026
 01:26:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
 <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com> <CAMgjq7B7TFfBZLPorZEmg5y9u6TzFbYVQXZNC8+iztGtifmdKQ@mail.gmail.com>
In-Reply-To: <CAMgjq7B7TFfBZLPorZEmg5y9u6TzFbYVQXZNC8+iztGtifmdKQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 29 Aug 2026 16:26:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z0f=gN58BgneY8GMyOPk+T-D9kY99Fo5FA1MKx2sADyA@mail.gmail.com>
X-Gm-Features: AcwNN1Vh8SvUhrDJHT68EhT8q8n0BxzVKAvDoklCBhtG9RXuinmOYLs_SOCYxYw
Message-ID: <CAGsJ_4z0f=gN58BgneY8GMyOPk+T-D9kY99Fo5FA1MKx2sADyA@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: Kairui Song <ryncsn@gmail.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7896FC0004
X-Stat-Signature: 1kg4jmrjfcc4srxmq413bfcjhtsb61hc
X-Rspam-User: 
X-HE-Tag: 1787991993-169878
X-HE-Meta: U2FsdGVkX1/qGGjRuOe4aVEy5RJYn3oqqIgLHFe7syJKwXXgLwuNZRl4UbXTLdcC4VB+8sSRye3LYPOWnddFXknSjiAQHeVSJt0xlYwRM0CisHd9z7iZqJigCym6GJfOC5yTwE73+XJHzNJy64n+UbZ1RqEG7EKppupnEOS66HvnnGUhKAoRZ4296xDK0eRO4KxKM8qwENSYOcTKAd7NIGeUz8a2ezrH8OyY+NcG4vhUj7tMrXJeauaV0Ekv/xQvV1NlHJlmX0L8eUKis6Di4qxaMuy0FodbpdNU4ujF2OWkGHnuEG99EjHr2JFDs5Wu8Bc2XYrLMUOdhJ/AG3SdPTUD3DD2xUyOeVW4fw7GcjyJsciq79nJDETiryT9AW0kvKa9HVWUIwGcpWTFnJa7bL1xRRdnxC4o9LC5OnzN8W1b1XBZlh3NEqjDrJlAL2P4jCgC3BnSGJ1pfcPj9H/H/fE7bQAl0RZTlLoM2vmVQ2k4HlwxU32V5mShy1j2A6S7FUNEv9QBRGUbu2B7jiIQev9IFgL7ov0M0+qeBD4qhr6SOak2vChMHB5iju/sx1Jad5fQqp9nGX/aZnXA8e25Owj4IzYdH989T2xhnDttaG3eG3Km1JpKYCAJBXHgp9wl1NWxumSvhJWkicZAVIBU+T6xKDLFKRdWld0sdlr2rPfDrrvF3FNV4i9Sbu4vwlGimH0/Guvy/pTRYrklGKN/3F7BfOWOKNU+++6iBq8MFD7Av1F4uXOBK5k72zZ8e32Ee7TC1y1JQjqb2Je6FbE7CVohoGC2nBDa8ew7cxecGo4InvsLeOPLOsgtMLae7Q0IZa1xI3HD44lp5g2XJYDYoaFFRr1YX9hfW8neX1hCLiaajkm8sFET3CimNYJTQcnTTLNenARleP5SYS7P5jVmsVCDiCK4tzJS9VAjsgXrE0vtLtekIYzg34W829sPdqOy+oDubyGLjiLG8qLGkLi
 b1sv8DQP
 yEoEaI3d1ofLX/PaEUiVwFNJgzzzZ1rBSO7QvOlAh+CAFGG5EXYRavDnULNC3HLFkt/ZMrx/C+gk2dTjlytKSJ/Vaa6jlunmnUsiSje8JpA2w1aEicRCbRb/KcWopPiXS3BguV4rY6UPDQ1SoKfNtuKxCqvMEn3pGf8xEUIYqEe1d+BQ3BnghuqfRujzW/ZTGgWfjkYBl5nImnyaofC7D5qpV3n4mLL+eC7NBfTqo0m5EtJzjj+KiXU2czPC98QTkfKfxXAC4JduOnmttFky7zcVsSMcXt4MEqr2xrEIQnZrv/unhdloT3d5MZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 3:48=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
[...]

> > > + * lru_gen_set_flags - Set the LRU generation number to specified fo=
lio flags.
> > > + * @flags: pointer to the folio flags
> > > + * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusi=
ve.
> > > + */
> > > +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
> > >  {
> > > -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> > > +       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS || gen < 0);
> > > +
> > > +       *flags &=3D ~LRU_GEN_MASK;
> > > +       *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
> > > +}
> >
> > It seems that we are setting the gen in the flags, rather than
> > setting the flags themselves.
> >
> > The current name makes me think that the function is setting the
> > entire flags field, especially since `lru_gen` is used as the
> > namespace for various MGLRU functions, e.g.:
> >
> > void lru_gen_add_mm(struct mm_struct *mm);
> > void lru_gen_del_mm(struct mm_struct *mm);
> > void lru_gen_migrate_mm(struct mm_struct *mm);
> > struct lru_gen_folio;
> > lru_gen_update_size(lruvec, folio, old_gen, new_gen);
> >
> > However, this function only sets the gen bits in the flags.
> > Maybe we could use a name that makes this distinction clearer?
> >
> > Could they be named as below, or is there a better naming option?
> >
> > set_gen_to_flags(unsigned long *flags, int gen);
> > get_gen_from_flags(unsigned long flags);
> >
> > Or something like flags_to_gen() or gen_from_flags()?
>
> I think having lru_gen as the prefix is a good idea actually since the
> header here is a very generic one, the word "gen" could be used my
> many other subsystem or drivers, gen_to_flags sounds too generic..
> While lru_gen is a very specific MGLRU thing.

Yes. The current problem is that `lru_gen` has been used as a
generic prefix for MGLRU functions. Here, however, we mean the
actual generation (`gen`), rather than `lru_gen` as the MGLRU
namespace.

>
> How about just rename it lru_set_gen_flags / lru_get_gen_flags? And we
> will have lru_set_refs_flags / lru_get_refs_flags below.

sounds good to me.

[...]

> > > +static inline void lru_refs_set_flags(unsigned long *flags, unsigned=
 int refs)
> > > +{
> > > +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> > > +       BUILD_BUG_ON(LRU_REFS_MAX !=3D (LRU_REFS_MASK >> LRU_REFS_PGO=
FF) + 1);
> > > +
> > > +       *flags &=3D ~LRU_REFS_FLAGS;
> > > +       if (!refs)
> > > +               return;
> > > +       *flags |=3D (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_P=
GOFF));
> > > +}
> >
> > Similar to the above, maybe we could use more descriptive names?
>
> And here we have lru_set_refs_flags?

sounds good to me.

[...]

> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *foli=
o, const vma_flags_t *vma_flags)
> > >         if (!folio_test_referenced(folio) && !folio_test_workingset(f=
olio)) {
> > >                 /* Activate file-backed executable folios after first=
 usage. */
> > >                 if (is_exec_file_folio(folio, vma_flags)) {
> > > -                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS=
, BIT(PG_workingset));
> > > +                       folio_set_workingset(folio);
> > > +                       folio_set_lru_refs(folio, 0);
> > >                         return true;
> > >                 }
> > >
> > > -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_=
referenced));
> > > +               folio_set_lru_refs(folio, 1);
> >
> > We have quite a few instances of folio_set_lru_refs(folio, 1) and
> > folio_set_lru_refs(folio, 0). Do these values have any special
> > meaning? Could we add wrapper helpers to make the code more readable?
> >
> > `1` just means `PG_referenced`, right? Could we add a comment or
> > changelog description to clarify that `1` actually means `refs =3D 0`,
> > but `PG_referenced` is set?
>
> Right, I introduced a LRU_REFS_REFERENCED in a later series. Now a
> comment could be good enough, as in fact PG_referenced is already kind
> of a unstable page flags under both MGLRU and CLRU. For MGLRU it only
> mean the refs count is larger than 1 so using a strict 1 here seems
> even cleaner, but it still keep getting cleared in many places. As for
> CLRU, the flag keeps getting reset when a folio is activated leading
> to an under-accounted value from smap and other components. So
> sanitizing its usage is a long-term goal.

Ok.

Best Regards
Barry

