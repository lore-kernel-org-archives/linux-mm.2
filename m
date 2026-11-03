Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0340F606A332
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 00:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Cblo++kO
Received: by kanga.kvack.org (Postfix)
	id 1CDC06B00EF; Mon,  2 Nov 2026 19:34:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17EE06B05B1; Mon,  2 Nov 2026 19:34:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D6B6B05B2; Mon,  2 Nov 2026 19:34:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C95AC6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:34:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57C671401C1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:34:30 +0000 (UTC)
X-FDA: 85391936700.08.072BFDF
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5E122C0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:34:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Cblo++kO;
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793666068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XRINIeGwYTp4FrvxpE2WlXAbCO4jFumeYsCTIBvLXl0=;
	b=cNccfDeban8JCqy9xj+O8SOljWDHUxkm7pbFNLYtGSv/s00XkMPj+78J+zQtA9yx3afo7G
	uQu3aatJANzxkshMas51Eu/dU3/wrw+uBebhJeX9aJbhI9PbGH9ZVj0JbxF9KZuChX1U/f
	zEwQh4lz6ZRfw723vbb6B+1wityNGtc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793666068;
	b=A8xe8YtJRJUvyWdf7nGj/b/DILO2Du+aIJ3Ip7nSdROZpg20CQD33vyIlVTBcuxnmEllGY
	m1nRNpX2N9dMQn5m0Alju0nf2QYcsRSWieSPuClyiNZXJRkohDwp0QGrSm69qDK57qS7ly
	YOez7YP35qFb3gqsaDG2MueG1yYbgrE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Cblo++kO;
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a208d93758so38134875e9.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 16:34:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793666067; cv=none;
        d=google.com; s=arc-20260327;
        b=jYQ6Z6w90vUYtD8/+iRFQ7fs8Dk4bi/1TkfC6jit0uTu80Oubh59yEDI5vFk1hrACK
         T7M14T7+19U9PFS63LT2uLSNrDqkhP8EcXwJIMcRRAw6cTyLbFyeJUC0+pZY4WsQ4fgV
         it9NPBsqkeoUOnOl49mAwAorOdKUNL1phui3Ycqz0MOcBRoazpmJsLtFEMJ4JSrTL7vc
         MAntf/A9FySKMuvJyWNWB4jkf1dCT8myqp9NRkvgA/Cewqrdx9s708zB3IsauHfcGh+3
         kgz+UaExzolwkGSxOAMv50SU+OoZ7/EuCfRH34RMRrS5geKIvnOm1oHVE9z/61gdtttx
         eQhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XRINIeGwYTp4FrvxpE2WlXAbCO4jFumeYsCTIBvLXl0=;
        fh=/gziYT8c9lQSH7+mALRpSZW4okFfDwT6Ik9/fLLRFLA=;
        b=sXVA8lSXnqHeMIpLtPafxFuMCA1j5I/d/XxGaqaV0D4wgfwNVLcXO52sql7CmoE5ww
         8vOudb22AWWbX3ohSQet+CWvFrixsoiuV+Peob5PZyHpT7EulLjadmwf0Wj7KDfGnhO1
         CbD+oibeGZ4nCcwBqjH1hnGibyB7w+b0rpabZqTN50Q01APpoqRa3Y7MEdpsY6yUeNfz
         xZqnBK9q2li7DLL3VybOcmVm2YNaPzZNLUkNLYVmZDnjhp8QtXhHTPz4XN5UCkzkSNyv
         DZb/ni2aEYxkU6dpZKS16g7cEFwo4TzqfEbVcAPmtXLu2F+sAyCE7MiG2lRycMHMvjPb
         TGcA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793666067; x=1794270867; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XRINIeGwYTp4FrvxpE2WlXAbCO4jFumeYsCTIBvLXl0=;
        b=Cblo++kOSnaIqFF9CGzW8onRRBJmvgW6I2KEQMtnvXZfXnr/3qxIJtZ7vXz1QkvtLL
         to3X0ydR3K810Jp3XysBdk8320HA5afU5S6x4f+qlmB7204J4DB5AQykn20U2sKw9p5y
         TzNIRoahtobD8p9p51MqHsDHbupl+O0WDFHRW23CoaRakxxBet44LJdlt6RmyGefGd1J
         OccD4Hxm0+ZGC55vPPUL3NyN9JlHN6zIeoH51Qksz0aSORDWwRhzXkYqESR2rQAB6pLy
         henz2d318AjXtJ2+6Rd/a2stZOGrmgFvkCL17cOoTS9+c4ArfjPTm3LWcgBP5oAKkiYb
         TwlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793666067; x=1794270867;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XRINIeGwYTp4FrvxpE2WlXAbCO4jFumeYsCTIBvLXl0=;
        b=PvN/5QujppobAyVdRlG4t4yztMERAc9RtUwdrvoXfW5wX91QMU0ob3on5pXp81ZGvU
         rYBfgf1U391WZ9Yja/eElGi9TVZWwty8yGWrGgetNMpeVu/1mzKWVYZTxrcaEb+pA/JW
         G8JWIDRjG7Aajo+x2awyB2dFVrne83EMXLAEetw8p+IB01ZwK9bz9YRgf7lQEfoFrBkm
         JSleW4K/CzEBQkBlMnUGDr5bsuT2MNw1ZcWYmCv+ZJ4Qs9PP0Kpj0zUIcOtOP6WHUGn4
         SC9ar39R3v277BaERdfjQYC92InnCXIqzCK646R83Awy8PhESKWIUWyOF+kHNShc7ZFM
         yZ4Q==
X-Forwarded-Encrypted: i=1; AKwUvBz4NmV5VYouLcjDYiNzaJ0rNpRLYP3q3kln1anp4+UuvV90A/HXIn/SlnUfuGij36jgwmeJ8xxvaw==@kvack.org
X-Gm-Message-State: AFq9FYKqU5VfhtTjqf0ZONqqb2/BIQT+MdVJNVrM8wBnS9B6/pVOvgqH
	EWMSSMy0OaYQhYk+PB8FU/rc1y0PC3KSBm2VL5PzSSB9ZmegD/xPp9y3M0woYUn2RGBUSwTs9l4
	lVaIZ+nFHPnbI1wr4Nw5O3ILb90LMDFo=
X-Gm-Gg: AYBFou1C1Skis+4GTvQcqDEyqtrQDLOWI5D18n2y8v3RFjSRORgJ/hh7+w0NrvAIwLr
	3JOG+jtq0RI0wMoIIlYpPB2BGO9ImnOJvBxUbF+AOdcckRk9Pz92AwLMwo2TEEVQOVA65rMvWks
	aN1b/QqNagkuUxQEtHInIuYojdoCR4cQhuyav+SpZYXnTWPoECsTv7PbGARBRtDvaIxvsBf5SY0
	TlSZPB2w8eRL1sFupKbLO/wkjsx+4nXoHxdCks7v6BUSGKKGJ4cL0PBh4csy953utlVkPGEE6sz
	zguWRitarnoZ3wcgf0tfm3w06NQDxhJdErmHPklJz8+pXi3GcOeeL1dhHnonq/m6bnvE4EHH2ug
	OzpCp7hAcIvo7SIt3d8KlnJaqvpZaLkqqPwoq63EQMEJJPrEXFPzpPOBSOhBOWOraJJsl7u6if5
	tdxOPsMvl9l6RcwP3XGg==
X-Received: by 2002:a05:600c:83c5:b0:4a1:f377:5c75 with SMTP id
 5b1f17b1804b1-4ac19329ea4mr232160515e9.33.1793666066806; Mon, 02 Nov 2026
 16:34:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
 <20261102225030.2743129-3-joannelkoong@gmail.com> <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
In-Reply-To: <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 2 Nov 2026 16:34:15 -0800
X-Gm-Features: AclHuK-wLxIuA5jPEmYu8qdZs5cxSk24od2LIZMBLDhfUz5W71RVH8v1q8qN5MA
Message-ID: <CAJnrk1bv-P_TQztAGiHYdfg=5hbj4GREML2M0Uxp5oC1R9J-Mw@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm: memcg: read root lruvec LRU stats from the
 node counters
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7u69ccj3ayzszeg6nke1dgk45415b68b
X-Rspamd-Queue-Id: 5E122C0002
X-Rspam-User: 
X-HE-Tag: 1793666068-185858
X-HE-Meta: U2FsdGVkX19T1q7QxrlRy2IiTVi/pzD7U/Gja/lWxxum1rAx9caTrstEKuQ8qDnij7ipNDSE+HIkiZskybeNLxJ3rwsUYDqER6PX99T5BYYQ8nN7if/QT9+AbGP0P/kZ6rFnRJP1Fnma1PIm+G5St0uUAc1hGdggzvHAAA4LFnW88EQh+xu6vhXrUxb0KrPFsvNB+r7svIFmgqIF4nv72wEP3wAZZbJ3MSgN+dKPcDEkF4uWhD2JTDKxq/6OoEAOEbo5ycXj9dDEH6tItu2Ez4hKTbFXoto9+LlOMAAYVJi6WPrSHtKnQe04NYDv6xWzmks0eANTnyaGdFaMd/ToNRZnqUweLFMebXEiCsHQ7tRrXjJeq3rdMD+hvcz+95XoZBJPZq4UBzDJTasKW+21zHG2TZFcl4ntF9ZmBqaJjPqqzvNf5prsGfeQ1eFDKzMYwCN+3VWMglrdmxNyCL2Xm74KNuRAC4LOn4Sx/MxPOXwHo7p+eu/zzpOHraYljG287MQaKtOYJnboLU48cWWzb7LJXjyxF0hs6mv8CvYEHW4w2HEJLxILFJJOiKfUSD1zY6KJ93LGfE6y30V+32KGVruCnvUrWqT9zn1pFMuye7x00GgEYRR4/7tXtr6ps8QjTqp310GhbD1wUJ8Eh8sjdYWphVwSh7DH5J0phWVlITFdb+5UC+jOYkFMNu+LDu0Rodga2z5FCXSI0E49JATMRaubsCK7DHtQcXHE2+gNprdabbhyewucGvX6MdyoTqXcfVVkokSQV4JpnW8uFU+M/cfgAy3DZZhabF/YQpBzuX2ZR0agmaBS16hys4NT3NhP8wa5iNoYmqbSs+cH1OeTzjPTP5tw3SN0+Lr7cYCrV1jLhop9T1ZO64qEzh1HKF4kTOC0p55ibAt+GUtiVFtrynIJ29Z+HjeEelp88I0TKPimGrLR/K5ywgGeQFNeHmflFeefWpi+xLgmeDs+C93
 X6wXVk5d
 ESMCP//uQG0fF2QXOjMontb1pV800mXr7eNx2Gc55+K6K3LZL6jGCZenUy36nkxdB5Hjr0ro/gCtOwG3OHerYX0qpglGx6ZmfA92w3dZM9xgwNwQpkkSp25J2zTrbPko1r1MwZCWa9Pn35o0tUUDELRNzrFvDvDEw079qImmO0tuJZ4NxHhVhEPFgKciB29f95CYaq04TBjLh6gjAbJYU2LTU2TCGMLdpM3Q/mXR0Toi1ybre4drM9m2HFrMn/VSjTedCbbFG/plmfIrvedGupLu4ga+aP0pPpnjYwiLX2jaA25YWUFIAbqZs4LC2QGO7M90eh+Qd18EZPEtqUd/5YRD3siQMV/XmWXqlqd7xjUol/GvAG+r0pCJKclJTjOs6QmK4NLVxfaSdOS/65b1M1Lu8NQB1GLGL905lHutACViwHys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 3:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index ac6c43ea8c5a..938843346571 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(const struct=
 lruvec *lruvec,
> >         return x;
> >  }
> >
> > +static bool lruvec_is_root(const struct lruvec *lruvec)
> > +{
> > +       return !mem_cgroup_disabled() && mem_cgroup_is_root(lruvec_memc=
g(lruvec));
> > +}
> > +
> > +/**
> > + * lruvec_lru_page_state - read an LRU stat of an lruvec
> > + * @lruvec: the LRU vector to read from
> > + * @idx: the node_stat_item to read
> > + *
> > + * Like lruvec_page_state(), but for the root memcg the node counter i=
s read
> > + * instead. For stats that only track memory charged to a memcg (LRU s=
izes,
> > + * workingset, rotation and reclaim writeback counts), the root memcg'=
s
> > + * hierarchical value equals the node counter. The root memcg can just=
 read the
> > + * node counter directly instead of going through rstat, which require=
s
> > + * flushing. Flushing the root memcg flushes every cgroup in the syste=
m.
> > + *
> > + * Use lruvec_page_state() for other stats (eg slab).
> > + */
> > +unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
> > +                                   enum node_stat_item idx)
> > +{
> > +       if (lruvec_is_root(lruvec))
> > +               return node_page_state(lruvec_pgdat(lruvec), idx);
> > +
> > +       return lruvec_page_state(lruvec, idx);
> > +}
> > +
> > +/**
> > + * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() for delta=
 sampling
> > + * @lruvec: the LRU vector to read from
> > + * @idx: the node_stat_item to read
> > + *
> > + * See lruvec_page_state_monotonic() and lruvec_lru_page_state().
> > + */
> > +unsigned long lruvec_lru_page_state_monotonic(const struct lruvec *lru=
vec,
> > +                                             enum node_stat_item idx)
> > +{
> > +       if (lruvec_is_root(lruvec))
> > +               return node_page_state_monotonic(lruvec_pgdat(lruvec), =
idx);
> > +
> > +       return lruvec_page_state_monotonic(lruvec, idx);
> > +}
>
> Why not do this directly in lruvec_page_state() and
> lruvec_page_state_monotonic()? They already fallback to node stats if
> memcg is disabled, why not do the same for the root? Are there cases
> where the node stats are not the right thing to do?

Hi Yosry,

Thanks for taking a look at this series! I don't think we're able to
do this directly in lruvec_page_state()/lruvec_page_state_monotonic()
because I think there's still some places where the node stat and the
root memcg stat are not guaranteed to be equal.

The stat I was looking at last week was slab's NR_SLAB_RECLAIMABLE_B
and NR_SLAB_UNRECLAIMABLE_B where for those, the node counter value
can contain memory/stats that wasn't actually charged to any memcg,
which I think means for these cases, the node counter values can be
larger than what reading the root memcg rstat value would give. The
functions I was looking at were account_slab() and
memcg_slab_post_alloc_hook() where the logic adds every new slab page
to the node counter but the memcg stats only get updated if specific
criteria are met (eg the cache had SLAB_ACCOUNT set or the allocation
had the __GFP_ACCOUNT gfp flag set and the allocation was not from a
root memcg).

Thanks,
Joanne

