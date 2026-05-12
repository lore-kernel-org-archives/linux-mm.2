Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47551CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793896B0088; Tue, 12 May 2026 10:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744A46B008C; Tue, 12 May 2026 10:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633D06B0092; Tue, 12 May 2026 10:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E19C6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:49:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED5771C11E9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:49:23 +0000 (UTC)
X-FDA: 84759051006.23.1959882
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id E0B8A1C0012
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:49:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uv5kEAnj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778597362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9eMKwfG9wGO309ZVEQXdjdoVqLMWRmUPakAKUCaz6k=;
	b=VefnoFqa0Xf5fT4bvwPDK2a5PI9hvGt8XcrnSdTa4Pt57VG0G5Z2lRtzCsW7duZA6GPUON
	evdo7tVrmOmbM5OpVHaVhUUMuSq0M/P3c//bAUHZ9rRn86cF6OXIWNksvcXAPjtPZvj900
	QAgsRrDABwQQ6pek8sSUKTDK0kCQ6uQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778597362; a=rsa-sha256;
	cv=pass;
	b=xzGOHp8lzC6FnuS/K0JnI+zb0PS4z7bdal6v/xLNrfIAGOSpYxakCoWpFu9WY/h4HxSFXh
	cg4hY+jw90z1d8UD1hoRB68ezFvoik3TzIcSDaYqE8wQHcMWQ8brTgoPcnxXJ/RHrLud7v
	0FY1sS5XTlN+X2KMKf8eUEtrfQtmFiY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uv5kEAnj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-67c1e0229acso8703140a12.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 07:49:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778597360; cv=none;
        d=google.com; s=arc-20240605;
        b=ezUtzPvfSy9d7t4nYls16IlMLf4t+u1BhWNvfeMO08wFFKjmr3KMI2Fp3fDX0YI/Y6
         Kv6ZgDq/ocuZwcotV2wV2ZPX8NgaEscvI2fqAHjogbjr9WL+TnYMMdYPT9J/9UmPQTXb
         t/E2/Vh5RuTZRGx5kRM9We8GRsU6znh0OVFhnSNF9RC3NCtvZCajEcc335mCqepbMxSt
         WsOYShkMrAQlaMQXFfOd3lDD+wKjFpEWcY3f7QOoITDWBOPwd5N6pa7/3v/q5d91m1WG
         PYOmolUt0iCN+wganawxSRHnUE5AxMmh3r3aVoUm6ks9ibB/oQZR5hZ74Tgw5Siyg6N0
         TV7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B9eMKwfG9wGO309ZVEQXdjdoVqLMWRmUPakAKUCaz6k=;
        fh=HgvzTsTje9lnNmOaG67L9WazGxXHdaNiyuLClgLUnnw=;
        b=iDgY2x/gcewRnqvoLSrvueKRuWambc/uYcJAbgmkI/rxHU+Yz0wqaka0CkqlEiZ+Kk
         Paeg7rJyeVHFkpvkyNaNNqHthzp1evDtgxvCKJKoel7BPoeog2EaY3MyvMr5lVdIdODf
         2jJe4i/P/vKbt6523DU8nXLqNFRUUEft9Pt59cHKi0PWuy/E4o3EmqhWmggKR+j80D8F
         q9EHcL1ivZFl6s1ClyHzOEihvjgNqMy2fizCWlnAijvQB5hJgFoug/OR+lazdV4eJIim
         L6XCk3ag5JxqqyRIgSZWRF5Brp+NkTc6rg+P3JUDn437OgGRz7fvuixSLOcRiYitJ/7D
         AoGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778597360; x=1779202160; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B9eMKwfG9wGO309ZVEQXdjdoVqLMWRmUPakAKUCaz6k=;
        b=Uv5kEAnjtf4bosztR3e/1dxumRJMZ5wZvbgbOFWGleGhLroxFN2w/zRJkvom99vV3e
         mJbUvs2UgYT+4A4bKnitdCRXQLKx2fAywxtv/W9/WSbDf5ST5ZokvOj7GnK/u3mRmXdk
         MOCWQskzTIiKVJLjLHbGI99eJ34R+PlZWzgUhd6IkRkkNOncbsWKCsawAuYqdhEma1Xg
         IeAGO+AXkI9f4pU7pCzEPKEcQczgbflePyZq6mAOeMLCQZqStWY1yRo7wDpDVQKE9bk9
         FwU/ZzqlTH6NoT+qT5xKC/HfxLxvILNT2nIlKJ50RPuAZhzBF9d35aFiPoxzYRkFuR9h
         BHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778597360; x=1779202160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B9eMKwfG9wGO309ZVEQXdjdoVqLMWRmUPakAKUCaz6k=;
        b=CN1M/cspfgqRPVDAsyj4S8TZLe/CpRfFEPrewHZnXjR4Q4KMGjyAXx4rZ/9Z3DwwR/
         SiY1xPT5yN5ZYcVkKupBQLdrGV+z7RPHjcPJiU2SHEV376wtksY4OsFI575ueCdJOcKt
         gBXXwGXLc8s5xTkyB+oh6hzilkti85vqZBsiAC9BczuQ/LrUQaGApSyYnzvGk8Rir9mm
         Tu8fC+hyJuMH0OceCGAQ0HuK1TnG4tWvKA1H/ZkZkcZmdOV7tVkKGRhRs/JKO85xP3KA
         WPHsplGWljDJj1j1ZofZmokOfQ0ZsnUQ+hKwpq8u1FGdb8hWMfv+BGmxqjzG4gvGlL/L
         4syA==
X-Gm-Message-State: AOJu0YyahodOofme7NvXn7PRUJtg+la/wvAQCdCJDjtqKW3CzlCC/xSj
	zXQK4NtcdiQK0LAl/jZp5yDaISrG5AqrNZsakIA5J7PxaC/OUrksuxNGCckPRemN8XH0QBeFACD
	l2msoDbhy/GjKzkhXv7mWYif5d7zOvIo=
X-Gm-Gg: Acq92OEAWBEmRrrnyBmlSBrXrXRWifJDKI5Z08P/7ZwRJL3XK7iUsCCuqdvDEgNeOE8
	VrjXl8levyXsBLjm11XLANjNhBmIzFAOTrPgm//xNv4ho2yocsZydfU/pXWsrYXdxHqnenUX7ze
	nCM/eN39TMMt5zbYnMziJwczK4fS+cj4Xi+EH/aQp6ezPUPC2S6/IBWrd66NQRP0lKpD0K3VM44
	Dn8jFpW3Eo0YFyW9uMAxNgupf3mUXnrKN0gc7bVodLpbsBIehOaz9taddnS5BNh+tU0osKBKZbO
	eWIrZoRL1RorkVipj9rjkvaqNu5PDWewLshVkCvb
X-Received: by 2002:a05:6402:2355:b0:672:be92:e913 with SMTP id
 4fb4d7f45d1cf-680cf83c072mr2060165a12.17.1778597359924; Tue, 12 May 2026
 07:49:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-2-2f23759a76bc@tencent.com> <CACePvbX3Bead1Ea+UJfUAq0e4JNJ0P+yN0=zf5rhdPsH8y9PUg@mail.gmail.com>
In-Reply-To: <CACePvbX3Bead1Ea+UJfUAq0e4JNJ0P+yN0=zf5rhdPsH8y9PUg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 12 May 2026 22:48:43 +0800
X-Gm-Features: AVHnY4JdtaVoMXwP_A9u3LZ_KiSSDXJ3HTWun5ui6FrfOFhsETe7YmM2uJ8JsU4
Message-ID: <CAMgjq7A2EfY65NHbLtcAOPT8Ry0WPgiMJK92LuDMLjpKm3FdQQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] mm, swap: move common swap cache operations into
 standalone helpers
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E0B8A1C0012
X-Stat-Signature: gzejw4xfg69js1mmao9rapi73yzre5iu
X-Rspam-User: 
X-HE-Tag: 1778597361-739406
X-HE-Meta: U2FsdGVkX1+eBc93Ln1F+K/yuTuh38BUug4HejZyvAHUaLQ5Z8+5cQRduJ6JE2qwgE2vA4InlA8KXJqnCbbecCkI1Hif7WQoZ+5R04Cj2HH7CmO11vlCRLfHEPfSBhPjV4V7NhM0vFNze+oe6I1JbiSMOKymTN4bmBraallLBUqxbfrsbc2WEAiX1wk591JZxsWwqPIjSdoSX20qUd7VciJnnjDcoR/ANmBRLlV7gvWpENErZKCQI2xtmn/VbaY6RwtXsdC3OJfnr72tIKFjs2HYDoWXeL8cDTypVl8sAkjvVE8kmDOezErUs1grxfk4ZV72anfAHh0dqlOFUAq7riGXr30y/tbKBboM5HgoSCnqzEZfjtblN4LjO67tMe5Xiw+yKWFGAt5TeVap/pcgc5XvNTvkcOq5vbY2xbQuXTpF8O3Ms+/irwHXDGnmVrm6oyHN7ALc8rXakSCgKDBdRf8C9kEHhH4BUEeEDWbhjGFDbKYehLTyM0K5KyPnCEyQibm3+2ron+eBEAZFHYj4leKTfyX2WKqLfoJNA2SXpvbpCrXSw4PA5NJhfNhQo4Is5JGRrO+iEC5vqBTf7TadezVOFbC6zfGCuPTUhktn0SisNaXCaLEn/vqezJJISGZaQ77R81sVskUxA2DVqQQhWvdrmpHYQPUNVKQYnQSRoDGL74XsZDarXWU1V+QJTAF/wq4MEpXQe9A6/t7ytJJ31Krop0JSCSn4RumUWUZFRFYGaokLr0THv7ia3+TQ8y2NzsYELtGRFqsnYDhO2TcDcpLwe7DUkvF80F1ToZ5tA0uA7w6w1e8Yv5q7CfhwpzzIuqxJlleY6Va3jyiHQyXKt/iecOoji9AbT98eVJBgsNXrhOtUl/trKN1s1AtpzzSLkJ3a+3y6Si91jiB91q6zD1P2b+/VOYu4hNmuxsxHQAcRKUptzbUkm6UBOVolHa601hsDco2qVM3b3nlC/c+
 pm0QbJV6
 IZYnWP3kV4rSCk0ORmIb/LTS2Cx2yf0+OXY9YVC7nmhuwIt3TnSJ7n7Ko6d3vHX5HYwnmlgy39C1KEmIefjNsipg+rykipdd2RTXUd4E8dcT+pJtHXkP3S4lBXVKYdYqye1o0RCbVFT9mfTWiuGRtS+OU2ZzqTgTu5hXXRvWOZ3j8O4Ci7lPE0zvlj1YOcs2l1Vf7xY9zZo+102OSj5LDe/Q5GHC3N2DlzOvxFhxNr2kYLQHfeapGTxCoz+ct8WH0irHO92OggheEumLz9tCb7h9PgCNO/Z5kScsYLmpPXb5ghgvh+J5LcjotSbtJ1TD+rkehOsC/kDf5cL5w0lni//gF9Ecr35YJbJhYCnox20wgOjbe9SwAZCawCzo9OToBUnJFb1zqKBxrcUkvotUaRh0+A/bFDQn0PNgFr00JxHbSAQFmIxOuLZK4176YNSarV/gi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 6, 2026 at 10:46=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Apr 21, 2026 at 8:16=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Move a few swap cache checking, adding, and deletion operations
> > into standalone helpers to be used later. And while at it, add
> > proper kernel doc.
> >
> > No feature or behavior change.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Acked-by: Chris Li <chrisl@kernel.org>
>
>
> > ---
> >  mm/swap_state.c | 141 ++++++++++++++++++++++++++++++++++++++----------=
--------
> >  1 file changed, 95 insertions(+), 46 deletions(-)
> >
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 204a9499d50c..3da285a891b2 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -137,8 +137,42 @@ void *swap_cache_get_shadow(swp_entry_t entry)
> >         return NULL;
> >  }
> >
> > -void __swap_cache_add_folio(struct swap_cluster_info *ci,
> > -                           struct folio *folio, swp_entry_t entry)
> > +/**
> > + * __swap_cache_add_check - Check if a range is suitable for adding a =
folio.
> > + * @ci: The locked swap cluster.
> > + * @ci_off: Range start offset.
> > + * @nr: Number of slots to check.
> > + * @shadow: Returns the shadow value if one exists in the range.
> > + *
> > + * Check if all slots covered by given range have a swap count >=3D 1.
> > + * Retrieves the shadow if there is one.
> > + *
> > + * Context: Caller must lock the cluster.
> > + */
> > +static int __swap_cache_add_check(struct swap_cluster_info *ci,
> > +                                 unsigned int ci_off, unsigned int nr,
> > +                                 void **shadow)
> > +{
> > +       unsigned int ci_end =3D ci_off + nr;
> > +       unsigned long old_tb;
> > +
>
> Nitpick: Can add lockdep_assert_held(&ci->lock);
>
> Can check ci_end < SWAPFILE_CLUSTER and bail out on error.

Ack.

>
> > +       if (unlikely(!ci->table))
> > +               return -ENOENT;
> > +       do {
> > +               old_tb =3D __swap_table_get(ci, ci_off);
> > +               if (unlikely(swp_tb_is_folio(old_tb)))
> > +                       return -EEXIST;
> > +               if (unlikely(!__swp_tb_get_count(old_tb)))
> > +                       return -ENOENT;
> > +               if (swp_tb_is_shadow(old_tb))
> > +                       *shadow =3D swp_tb_to_shadow(old_tb);
>
> Nitpick: You can create a local variable for the shadow and assign it
> at the end. Because it is a pointer, the compiler can't optimize the
> store away.

This part will be reworked very soon but using a local variable here
is good for an intermediate commit.

> Chris


Thanks.

