Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB3C2105D99A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E63206B0088; Tue,  7 Apr 2026 22:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13ED6B0089; Tue,  7 Apr 2026 22:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02856B008A; Tue,  7 Apr 2026 22:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE7B86B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:33:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 663B6160A0E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:33:59 +0000 (UTC)
X-FDA: 84633818598.17.93FBDA1
Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5EEAA18000B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:33:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HOPf1mwR;
	spf=pass (imf06.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775615637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHlbK/BsBx2bsBdFDlq8m41PA5eMLpW+4eYLKAyppzY=;
	b=h+b8lyN15F/62tYKsJ0eLCe16p4bsJwydciRrG1i7BJ2WNZSrFMi8qwg/7yuP5Ya/n2XpI
	qyVnbaxrGJjxwvznvlmpCI9Wih9QFWZz2Y5uCe3oIRx7KqxnYzWFnN3Y4MkQiU2nTSMo3Z
	rTK1GZyuKIZbmTxSux/IAY5vEjd8Vy4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HOPf1mwR;
	spf=pass (imf06.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775615637; a=rsa-sha256;
	cv=pass;
	b=j5hEykwB/qqytwrvEa8yNKBs8trVA0g+FQ3jBOquqXLHDgwWtnbf0cUw9X97BO+L04NihW
	8ej7CPR9dbgbOe8H1boN+vHT4uPSQq2k6bfw+Xf3QjSIHWBk1i3PWzJqjdzo1dyyyjoBrR
	N/nFStVwPI4g+awe/nTiacLRQZCx06s=
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-1274204434bso452015c88.1
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 19:33:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775615636; cv=none;
        d=google.com; s=arc-20240605;
        b=gVUpgvMjwiT62Ef4IkithkGH9OdPpFtLWf2upOkc+SAtkhck9/Cf0gZiBHU2hNfIbW
         U0njIESs7JA+TBF/c3N1cyT2Pk8WvIx1TNdxXIcU5yC/Te311V+YLXUFW9i7YbDoGK4R
         9hZhd+Mp/XVV31EJGEidXoc/XFLCmrxxO/ZktEf1W04geWCrM0YDJ7y4TGJKcLDmUYvk
         jS4MovTwgQpitwJFXYtko/w13KSgvrSYJ9czQ7Lhaa7/ofDy8tsYP6egSmsO0akMvmb4
         sXoP8xQBtghXOm4KwbYk210gy19BpmhJkzKHhsIignmwQVSmKB4x8a4cg1E6SSd54rnT
         UexA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pHlbK/BsBx2bsBdFDlq8m41PA5eMLpW+4eYLKAyppzY=;
        fh=n43KJJ2vakC9wcECozSkn4PerpQ8flNhbfwIJVsH+Ys=;
        b=MWXFJGilmfOKW3zh9f3nrP5QtumChQA3Dh63BsIBimPPtxgD4BkQaz551OdU8/pEqG
         YXXIHiX+OJ0a++QjD1sZkOPL98UHJpWxIJuWC3e4HEdCC7V/TC/vv1n6U1cnmhoD1d+e
         26binKVCXtRXQkOErWRXtBMJUjz2Vv+6eSXv2CrC4AtWa+RpI9PedN0k2WpDp61hZ33O
         ZmXqouMYOxrcn6ZDwV4nIgcdIFwxLxJ0MpmWdxnQwbXQh6wEOkNDnBn0tDvwYvti1iOt
         ETinB0vNfXzfhRC25Ofwv0xWe2WaIJ0q2tofNYXZRmeO25w9+5Mgm1YW3B635cRYVezh
         gvQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775615636; x=1776220436; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pHlbK/BsBx2bsBdFDlq8m41PA5eMLpW+4eYLKAyppzY=;
        b=HOPf1mwRS1M+lvbU8Dt7IW5LaIqa8rEhIzqqY71d1iGg25illM32THI3bSLePCnm+t
         zhzGQWsBcL/sMjiBMe+x7Rjca/bcs6WXP0VwgmeEdBvKv8dwAqGVnT1a0O2LcL6OhXie
         k2GLoMQkPYqO0Z8sbYogt8jbWgd6bSW0zkzPkdUgqeJAQU6Z/c7paEBrPJYuTfC7wxZU
         LY+Zi8uwXtIrv8yVtsCQ1HIyw+cnrykpPW0WHtyvgTvAs3v25N6BWTK41scUAnQNVk47
         r863hqONB1GoRXhYuqW+oYyGxCwrSS1neZdsJ+r1d7hZwauWlenw9zL0O6/fP59Gw5tY
         bIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775615636; x=1776220436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pHlbK/BsBx2bsBdFDlq8m41PA5eMLpW+4eYLKAyppzY=;
        b=cvJHbKu/fs/K10UxfugzT0Ngu29X9Y3oRIY1+rCoezJBWm2WxyYmNYZOh5qR1Cu5jP
         MQHRMGrdxsvRXv8g9z3bPMIQ5fIEPG4XXdnfHHM4ACQBt4jMI4yDo4pqdD4JRV92xFMY
         wl4l2I+luXcVTb4utPf4taiNQ+8Gtbw5ogG1ECzdSLahB555iNGtILrSl3WecK7d2qXw
         rKjj7pC42capvH2x2e4C2q6P8NPEf478y8AFdtzb7gvJITI7IENsuzJyziOxYLhZKMhS
         eo4ibFz9jDhxd98A/zHuV6GbWULIAJB7hzW4rJFNdkAf86z6eqDODR/52V0GiVCoDCZa
         fW8w==
X-Forwarded-Encrypted: i=1; AJvYcCWuS5WV4kIo+PnUgYiEAUtAAQchQS+aoo/wmHB87E4lbcbtmZXIG5wUKbA9ytzcuxEAPYJNXNAJLQ==@kvack.org
X-Gm-Message-State: AOJu0YwwZmd41VVPp8OdXfWB6qWX0yByiXEj4010sHfi5ILF93UsnPLK
	7g/65lAe0ZyN0YlTvCfr3QZK7U54adp6IFJBgXJxHkQumk601qycKD/GvlBymLu6dRPn3KVCrIH
	Ngp5xerYed9m+cuQn60lnFMlaQGdHmw==
X-Gm-Gg: AeBDiet9Kz0vQSitwFVWv12TGg4mPMyidZOF+3p1suOIfChpSMWXCzbt2Zm2AWgFHn/
	aIFm/Evt0A6wjKSKrHsNDR4PsEcb8MVjwqcGj/op2Xru0Az0Hzaup8Xst8xBdODsc+qpMhwIims
	vCz+EVFMfoZU8mWjGkGNuA0NsAwTlBKSB38aRn6mkntUBs/OS4EFxO+HAn/Z7+3GRYM83XJWBBw
	rYkNIWk81GZef47LKBUGh/dAS2ROXbHSOYPivM/QBt8+OAGhTFBvSpmCCon5jq29/nHfHOxWWDv
	F52yPDtFZaIbHv7Mlw==
X-Received: by 2002:a05:7022:60a1:b0:128:ceac:6db4 with SMTP id
 a92af1059eb24-12bfae11275mr7059978c88.6.1775615635809; Tue, 07 Apr 2026
 19:33:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260407001310.78557-1-sj@kernel.org> <20260407160546.52220-1-sj@kernel.org>
In-Reply-To: <20260407160546.52220-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Tue, 7 Apr 2026 19:33:43 -0700
X-Gm-Features: AQROBzB51dj7-apCsQJ1K1CEdPrKZ_udnrigOM_8d5fSjl2af8KxTgRvnKk80zw
Message-ID: <CALa+Y17YnrOe=UXWBMKJ1U6seKJuauDqAdTDYo1cCYnrP_vSFg@mail.gmail.com>
Subject: Re: (sashiko review) [PATCH v6 1/1] mm/damon: add node_eligible_mem_bp
 and node_ineligible_mem_bp goal metrics
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5EEAA18000B
X-Stat-Signature: 1ck6bnbs7bjirowp8114c4osyb1ao1cn
X-Rspam-User: 
X-HE-Tag: 1775615637-290744
X-HE-Meta: U2FsdGVkX1/w3REezj7D7Rn2Kv0OeTnoU0JU74b1kJ7LFVEQTgX72mX77JWV63C8JtecsMiMWiF1xPebyrwxBjOApBBwIEgPQ3jJ0kFTWATb51WaR6eU3JCTqhY0SacIQ4uL/7sn/44m0fWAjzi/tvUyIV0IalxJSdMw4hmDTQ1+wvdWJKQUlBJDPxyb67aT80Mxdtc6TB5EELyA3zOsFCY4h9Ezt2wm83az38HEWQ9dB73bBk5pe2gdNbXi48RKhA5u63PGN7T8xjZdy01/I1ePVwfxLF2jhHXauQxTKDuXTAVe+ocpRfKp6y0z9uI6jC9LOZ7xv8wVnNOccwCrLQzUu6QND4bE81QQu7gqlmF4oS2D0qC3v58hrZxfU4eZgE+W7Vy+2Q+XrHjN7diU9iIW6lFfRhNAgiOCgS85qGThSUOIAtN8IeadCddTk7jbupq5jhD1n6IDjHNsqoTUu5h6bM/lA9aZdwhDhHH2QYqYlK/RbR8hDKdTa6vmMg/KuXcPufVBI4LT1Lwv8ap8j/1Zm2f31z999YK/h5TJnbdzUM+QQF/TlTQdHILAs0cwmQhBsJaLaJ9KUyHn4dCbWL0yucjtqyX9XNQUU5J16Wcwvp9cyP/oMWCADAACVScQnKKPY03jwjhwy8AUqIW7eQc9eUxG9xTti5g/PboYCYMbkb7ECQ3sF+wtfozwJuqSpkL0zjTv2lWsSBDsQOZNk/QIcsY3NfURdi75tGB8V3RPzDeYiZdkQ32odm3Fb58a7/lk7MASWIP2EmW4bscb/8DV2+ao09r82iVe5oKCX0xJ9maRBGdz7W5V0FinSFUus6WRHfpzt66AUgOxSjBsASewarvHwU4vg17460vq52P5SSOpLcfhEFJoV/DhMzefJ7HQilCsyUbTZ2jl9Dt44zSZjswPy5FTg1NVNXjOZ0bPzYJ6kYoU5D6xudVSI+84eZJ087KQluFfCNYndce
 dTFHnFL4
 FQkni9Nz0pSnctPHtBOTDuoDT/IoH7eFgeg7421Rin5NaqnqV9DCytxqb4J2sy2e0a4RmEXazaWLfFIGbKWGBl6xBN11Wt53LTCL3UHDKOYqukXb6cLPezzTiDSHEBQ3r9SHmUDGlNmLw+xQblALlh1+OZu3GzW6Ejk2rlaOzldO3pE2DoFu+YPcRMCrF9tEZDqx7gkngOgOMJy23JE/5CPIVpWyL0db7dQ8kC/F+mDAz7a/oui2BTrmmraIYyoye+3SbXb9rfrfuJELQz0xmELEcrhJCP4vMtvPJT/Z16PprCnCoO+orm63zVpGP56bFRAw0pv4btsMaJc49o+EQu+6tDTBCRW3QlzHfg+tSIxWSnS7ZQ1GoKemnLDAiacLFK1ksxs2b+isPJ7ZNjAXHOf9i/JaJb4vu79wdyDsWUjhzr0YTlS2Rp9He7VusYvpe8PiY0dlZ7TTpyB003TCtCmqbsKptaInSGiPn4p+GWVRMzVhApUHGkRyZIvpULbSIluc/OInRMHr0ipELdXm/fqSRdwX7It8a+aunIiaBUG0U8MDOZm9fx5RWzf3U+hf7SvlGse5+eH49Icv6D0MNkwfql1dIY41Q0Xfng0vf7MfogeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 9:05=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote:
>
> Adding another thought at the end of the mail without cutting the previou=
s
> unrelated questions, so that Ravi can answer all my questions at once.
>
> On Mon,  6 Apr 2026 17:13:08 -0700 SeongJae Park <sj@kernel.org> wrote:
>
> > On Mon, 6 Apr 2026 12:47:56 -0700 Ravi Jonnalagadda <ravis.opensrc@gmai=
l.com> wrote:
> >
> > > On Sun, Apr 5, 2026 at 3:45=E2=80=AFPM SeongJae Park <sj@kernel.org> =
wrote:
> > > >
> > > >
> > > > Ravi, thank you for reposting this patch after the rebase.  This ti=
me sashiko
> > > > was able to review this, and found good points including things tha=
t deserve
> > > > another revision of this patch.
> > > >
> > > > Forwarding full sashiko review in a reply format with my inline com=
ments below,
> > > > for sharing details of my view and doing followup discussions via m=
ails.  Ravi,
> > > > could you please reply?
> > > >
> > >
> > > Thanks SJ, providing your comments on top of sashiko's review is very=
 helpful.
> >
> > I'm glad to hear that it is working for you :)
> >
> > [...]
> > > > > +static unsigned long damos_calc_eligible_bytes(struct damon_ctx =
*c,
> > > > > > +           struct damos *s, int nid, unsigned long *total)
> > > > > > +{
> > [...]
> > > > > > +                           struct folio *folio;
> > > > > > +                           unsigned long folio_sz, counted;
> > > > > > +
> > > > > > +                           folio =3D damon_get_folio(PHYS_PFN(=
addr));
> > > > >
> > > > > What happens if this metric is assigned to a DAMON context config=
ured for
> > > > > virtual address space monitoring? If the context uses DAMON_OPS_V=
ADDR,
> > > > > passing a user-space virtual address to PHYS_PFN() might cause in=
valid
> > > > > memory accesses or out-of-bounds page struct reads. Should this c=
ode
> > > > > explicitly verify the operations type first?
> > > >
> > > > Good finding.  We intend to support only paddr ops.  But there is n=
o guard for
> > > > using this on vaddr ops configuration.  Ravi, could we add underlyi=
ng ops
> > > > check?  I think damon_commit_ctx() is a good place to add that.  Th=
e check
> > > > could be something like below?
> > > >
> > >
> > > I plan to add the ops type check directly in the metric functions
> > > (damos_get_node_eligible_mem_bp and its counterpart) rather than in
> > > damon_commit_ctx(). The functions will return 0 early
> > > if c->ops.id !=3D DAMON_OPS_PADDR.
> > >
> > > That said, if you prefer the damon_commit_ctx() validation approach t=
o
> > > reject the configuration outright, I can implement it that way instea=
d.
> > > Please let me know your preference.
> >
> > I'd prefer damon_commit_ctx() validation approach since it would give u=
sers
> > more clear message of the failure.
> >
> > >
> > > > '''
> > > > --- a/mm/damon/core.c
> > > > +++ b/mm/damon/core.c
> > > > @@ -1515,10 +1515,23 @@ static int damon_commit_sample_control(
> > > >  int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
> > > >  {
> > > >         int err;
> > > > +       struct damos *scheme;
> > > > +       struct damos_quota_goal *goal;
> > > >
> > > >         dst->maybe_corrupted =3D true;
> > > >         if (!is_power_of_2(src->min_region_sz))
> > > >                 return -EINVAL;
> > > > +       if (src->ops.id !=3D DAMON_OPS_PADDR) {
> > > > +               damon_for_each_scheme(scheme, src) {
> > > > +                       damos_for_each_quota_goal(goal, &scheme->qu=
ota) {
> > > > +                               switch (goal->metric) {
> > > > +                               case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_=
BP:
> > > > +                               case DAMOS_QUOTA_NODE_INELIGIBLE_ME=
MPBP:
> > > > +                                       return -EINVAL;
> > > > +                               }
> > > > +                       }
> > > > +               }
> > > > +       }
> > > >
> > > >         err =3D damon_commit_schemes(dst, src);
> > > >         if (err)
> > > > '''
> > [...]
> > > > > > +   /* Compute ineligible ratio directly: 10000 - eligible_bp *=
/
> > > > > > +   return 10000 - mult_frac(node_eligible, 10000, total_eligib=
le);
> > > > > > +}
> > > > >
> > > > > Does this return value match the documented metric? The formula c=
omputes the
> > > > > percentage of the system's eligible memory located on other NUMA =
nodes,
> > > > > rather than the amount of actual ineligible (filtered out) memory=
 residing
> > > > > on the target node. Could this semantic mismatch cause confusion =
when
> > > > > configuring quota policies?
> > > >
> > > > Nice catch.  The name and the documentation are confusing.  We actu=
ally
> > > > confused a few times in previous revisions, and I'm again confused =
now.  IIUC,
> > > > the current implementation is the intended and right one for the gi=
ven use
> > > > case, though.  If my understanding is correct, how about renaming
> > > > DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP to
> > > > DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP_COMPLEMENT, and updating the docum=
entation
> > > > together?  Ravi, what do you think?
> > > >
> > >
> > > Agreed, the current name is confusing. How about
> > > DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP_OFFNODE?
> > >
> > > The rationale is that this metric measures "eligible memory that is o=
ff
> > > this node" (i.e., on other nodes).
> > >
> > >  I think "offnode" conveys the physical meaning more directly than "c=
omplement".
> > > That said, I'm happy to go with "complement" if you prefer.
> > > both are clearer than "ineligible".
> >
> > Thank you for the nice suggestion.  I like "offnode" term.  But I think=
 having
> > "node" twice on the name is not really efficient for people who print c=
ode on
> > papers.  What about DAMOS_QUOTA_OFFNODE_ELIGIBLE_MEM_BP?
> >
> > But...  Maybe more importantly...  Now I realize this means that
> > offnode_eligible_mem_bp with target nid 0 is just same to node_eligible=
_mem_bp
> > with target nid 1, on your test setup.  Maybe we don't really need
> > offnode_eligible_mem_bp?  That is, your test setup could be like below.
> >
> > '''
> > For maintaining hot memory on DRAM (node 0) and CXL (node 1) in a 7:3
> > ratio:
> >
> >     PUSH scheme: migrate_hot from node 0 -> node 1
> >       goal: node_eligible_mem_bp, nid=3D1, target=3D3000
> >       "Move hot pages from DRAM to CXL if less thatn 30% of hot data is
> >        in CXL"
> >
> >     PULL scheme: migrate_hot from node 1 -> node 0
> >       goal: node_eligible_mem_bp, nid=3D0, target=3D7000
> >       "Move hot pages from CXL to DRAM if less than 70% of hot data is
> >        in DRAM"
> > '''
> >
> > And the schemes are more easy to read and understand for me.  This seem=
s even
> > straightforward to scale for >2 nodes.  For example, if we want hot mem=
ory
> > distribution of 5:3:2 to nodes 0:1:2,
> >
> >       Two schemes for migrating hot pages out of node 0
> >       - migrate_hot from node 0 -> node 1
> >         - goal: node_eligible_mem_bp, nid=3D1, target=3D3000
> >       - migrate_hot from node 0 -> node 2
> >         - goal: node_eligible_mem_bp, nid=3D2, target=3D2000
> >
> >       Two schemes for migrating hot pages out of node 1
> >       - migrate_hot from node 1 -> node 0
> >         - goal: node_eligible_mem_bp, nid=3D0, target=3D5000
> >       - migrate_hot from node 1 -> node 2
> >         - goal: node_eligible_mem_bp, nid=3D2, target=3D2000
> >
> >       Two schemes for migrating hot pages out of node 2
> >       - migrate_hot from node 2 -> node 0
> >         - goal: node_eligible_mem_bp, nid=3D0, target=3D5000
> >       - migrate_hot from node 2 -> node 1
> >         - goal: node_eligible_mem_bp, nid=3D1, target=3D3000
> >
> > Do you think this makes sense?  If it makes sense and works for your us=
e case,
> > what about dropping the offnode goal type?
>
> Now I recall I suggested the offnode metric because I suggested to run a
> kdamond per node.  That is, having one kdamond that monitors only node 0 =
and
> migrate hot memory to node 1, and another kdamond that monitors only node=
 1 and
> migrate hot memory to node 0.  And I suggested to do so because I knew it=
 is
> suboptimal to run DAMOS schemes with node filter.
>
> We made a change [1] for making that more optimum, though.  The change is=
 now
> in mm-stable, so hopefully it will be available from 7.1-rc1.  So I belie=
ve the
> single quota goal metric should work now.  Ravi, could you share what you
> think?
>

Yes SJ. I think we can make it work with single goal now that the
below commit is part of mainline. will give it a try and post an
update.

> [1] commit e1ace69c33ec ("mm/damon/core: set quota-score histogram with c=
ore filters")
>
>
> Thanks,
> SJ
>
> [...]

