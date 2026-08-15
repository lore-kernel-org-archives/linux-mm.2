Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D36C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 03:38:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92AEF6B032F; Fri, 14 Aug 2026 23:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ADC56B0334; Fri, 14 Aug 2026 23:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E386B0335; Fri, 14 Aug 2026 23:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 329776B032F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:38:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 702E11A01FF
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 03:38:18 +0000 (UTC)
X-FDA: 85102095876.12.6B1857D
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 857E2C0004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 03:38:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=osE4APB7;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786765096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=luVYJYWQOB0XY/tTpneISfB+TB1fZM2KMGuLqcIZEDI=;
	b=avidigBMlCrpoZlY7tIDbJz0Mm5PtCmV9oKy56pHoZVrCfjzQRJF1NP5t0ZhYciMqmumri
	+vgPL/iAr/NZZ3tVoG5FRgGPgS7vLcjQBd4fRhRyNeieTP1u0Q+wWrdVl1F5SvRnEYOdZX
	SJbrs0Hva1p0rFBcgdV69l+cqReeUrs=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=osE4APB7;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786765096;
	b=y2Ptq4UZK4nlXe9JqxtCjky0gPK4hUdrmfFsq/3LAHRpopdnHs510bormMepPPxvKSQo1K
	E61Lzv3yJb5fi8SSHWNLgjouzyleFkYWRijsZLVK68nt9AnszBgs24u7G8sTSKjsTMMVuH
	BUnnHiodYObDaqfKYB3pM8WfX1ynSu8=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c10e86e52so378421cf.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:38:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786765095; cv=none;
        d=google.com; s=arc-20260327;
        b=F44Dmo2TzySXHrvWwG2O8qKO1J3Xcft0M5z77bQVgsht0HhsKF8de1GmNgs7r7DiKz
         ZEMyazsIFKprqhkSLLCrujz8MTvUpm4PEuRWWrLWOfihVwdCwqkFaBpjOTk35FXnOvn8
         taNDgzlDmq2j3a+agjTNljdVnRD9A5dS07KgELWuOQupyVe1k1p1351fv4WgCjEMoKdm
         a0inKAOHL8uVRGynyKld8QG/HuCxrZo5DTIoaiYmds7/OMgKfL2wBuSiVnl4z7+mYbRi
         LukolCp3a1uLsYS8J0j/vmttQL3qL8WOcfgSofWlCGR0kW60cfGO2dBzo0HFZaHYBCp1
         YmzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=luVYJYWQOB0XY/tTpneISfB+TB1fZM2KMGuLqcIZEDI=;
        fh=r8J5esiCuBetDq9HLoADkNvVrQr+mKqr8t234LO84j0=;
        b=IN7CQLQRy2Vb2gUWXFTYUMkcuA+OjxQWrRuGyg6gMvjiC7NgOG1mTE+qP8iIqeHyBh
         DWbjgCqNeckNI2uT8bFv4cotJAat4Eo71hNLEHYzWAgdr2CyHiCZi+wVpIpUwlehq/uN
         WPGls/EWiuJFx9lv8d/OjBoT/xE8YdIlj31rB14tnrqMLhWXlqr8yLkXmpnGAZ2Fphfp
         yUrClm0rFHKfbxaFaEEFQNIZi4zqhwRHKfG0WYdTp+08+c3UlD8MDmUzbAP6gz+1VPPL
         bg8Wz4BgsMQTvSFDAinKVEoEv64UzrPSzcHo5Xwfv4+/bm7eQZzTlhTM7EQUmoX5qhHD
         kbNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786765095; x=1787369895; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=luVYJYWQOB0XY/tTpneISfB+TB1fZM2KMGuLqcIZEDI=;
        b=osE4APB7moxZMEcIPeP+CAbtAhmm5sVCcpC4LX6OlEOiHKf316T01L5Z2Ovkt0herg
         7whBzcwj42hv7WhM3qUn5dXJmg+ZqNMOlqzo2eWGKUpP/CtnHppQMgdS1Lp+RsVIfSQo
         HV+9BPK1RFpnAJ+DpaIo4ahPxkr4xKlg8NRvVyQkhrgeFbtuKAO8W69GqrScGR4W/+p1
         OShoAipIKmlYFsnZXTRI6cO0Hb8bLcthQRTQVUExOkDojAOGG4eT8w3hvnx6Lr9OrhVK
         xsfdpOjAwzARNqSJZeLJuVlkxP/b7s0CjiXX2izDEwXFVbJLAOvWKKNuSoj5w6UInD+O
         jwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786765095; x=1787369895;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=luVYJYWQOB0XY/tTpneISfB+TB1fZM2KMGuLqcIZEDI=;
        b=gmcnb0Toag67I7SPsAEo1bwCToRV8mbPSYy2I6Qd3p+/QiyeWqNwhfLUKoA7RhyMkr
         8J+T5JzxJO2pXqQo7d67iV6p8GwmXYZQcny3v6XSaE3t/M61PQ6ZdDexWiD1V/jNO9IH
         NDBmBioYfgyTD2DVMWvkRMOetCDU4TEtAx06EDs4TiEBFiiMbcKDZF66jQKmKTX8WTTS
         IYYF9Qf6QyIoV9OziLi4hswH1NZqKF7UgLR9Fc7QI1e0EUmS96k40fVwWgnyjUzUtXRT
         WGAUhjcRV80CAOmomrH1mS5NxKasLSlgXxp7/b1hIbRo2jZcYpa36vnogKs89h+ps+un
         rPHw==
X-Forwarded-Encrypted: i=1; AHgh+RoaItF5j9WEkpfmJuMEyF+Ise9k1CWszoVSF9bBtvWf99z60LYlSbGsLH+rMESIwSwwylidnES3mw==@kvack.org
X-Gm-Message-State: AOJu0Yw1GACW/3NZdi2Pt9brKCBisTvMcyGm8dv+gvC0314cAseh2I05
	0APHvEOxHWdNuPFRVM02dEg+Qat8zMi+gYUPLefqS5sBXmKqQxpTSbgMEPfALhg8o9ss1WW16+z
	O7jOD0uiBvmLBS8XQ2OQF0ZpIf3sbdXuSIizYGh/s
X-Gm-Gg: AR+sD12KVvkmZiIVD2LsSAX5LEOFysGlYWnvJrNJrpqjLvq+a2sz/VqGAmwriG8luuY
	1MkhG7qDihcq4cFeasLI4XRCGMD9ZHU8VTKgXFSFlCUhpe5hz3OAR83dkWbDvew7e3Y5CMqlOc4
	fI59hE0oWJeTD9YWMA6pRNlG2Y1ZoQfdK7t8M12Y7UuXR1xTkeYd5r1d6HbtuumEfJ5RbqkrVRM
	QCpMnso6y8ZHrgW9XYyDB9bXpOoc7an8woFV/0vjvjd83JzJP+mTcQ94j3OEqLbLB1J+pPjX9vA
	c0AI89OuL/KWxSxnE6BHj4SYcz43KxCHrhfiRUW4Pgc=
X-Received: by 2002:a05:622a:578e:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-52d86192a1emr30633361cf.1.1786765094873; Fri, 14 Aug 2026
 20:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260803113944.3694290-1-praan@google.com> <20260803113944.3694290-2-praan@google.com>
 <2vxzqzk338y2.fsf@kernel.org> <an2skkjrNXBTFagK@kernel.org>
In-Reply-To: <an2skkjrNXBTFagK@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 14 Aug 2026 20:38:03 -0700
X-Gm-Features: AcwNN1XrGQyskIqu-lIjMZBTlBvDbp-7AMsoC0-TI6TqDyvNpYGgAf_q-RSalo8
Message-ID: <CAJuCfpF-A1DeRmg1i7rNyTaFT3_0H+Rqsy6yQRUct4Z79xGtHw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kho: Introduce a helper to init high order pages
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, Pranjal Shrivastava <praan@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 137e9kgptuyzqwet6myo7dx6bi3pdpto
X-Rspamd-Queue-Id: 857E2C0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786765096-126942
X-HE-Meta: U2FsdGVkX19R0eujIhH6iQckYdTY2v/f+Y1Yokk/1zlwuWJda79XQBnGhiO4zDnbb5lQ+B+w809yHuuYCFnE+plyDozQ+qKVtJ0Os8e59sfTCfGtcLi+KCILK04H34DjndDL5zBl/2SpfFf9x6mai3CRX5jUGSEk+wUcaG88E4pIiU6Z581k08yG5zq/LDUC4ef6RWiMaYPdx4G+rwq+E8s16flHbjrDuIuzgxAnC9V+H70wdtn8J5FgZ57eIRo5VWpz5AfSlOgJqCp97KURy+BSfN9HRjjP+juDONPmcB3Kn+fHXAqShcN3AUEPSUYJEtewDLs1IiYXSZBKOiqUjdpm5lLQ3UaYWd3jv1st6Xlt+WgGIz9l9wb9D7K3aK8hUZjK6tKw0bhDu1Kkmiq1+BA5Ai/xRSBQNUkpOSFSrzGsUewcL5jl/65xaIbtJLbbY01IgW7Pbl4P4GH6PHta6mnKycX2HKSPEW9kT4ed2ifyV1p/BnXbdFunjs1DBegSzcH4/yD6emid4RnL58rCXVpczWi8dQ0nNEwewbrJetjwhQe65UDurSAJMeMoQ4KpGGfXjKRh2TOi8jYZadj0Ka3F+rwBcJXtSv4HpLIus6LeOebPfZpKStalO2L9XVFj5sjmrTl3buyATXiYBB8o3o/nLfWj7qSmAB+lrC56Nb1kXco5bUQSGggFbS40Wcn2a6rGdTLKwZcl96owJ8dYn8AtmdB+vNglPQSCyvs9aBpmi5FUJ+bbJ5CIbqn2F8rLW1swPOWbd8GoxClIPgg+7mzak340Z9f9KohkIs0cymPoErbYxyEXU36RWU12rMfMoyJsmIfhEk/Oxuh2mVlNWG9rHzn+HWBs5pn+osJjZmK2GpKVPk2Q7pkfiAQyuUr8Xm0dE71bCkbdJ4JWF2SQp0xlFoa9lVaCDFGpC6oiHf+jgYumPIKq3OPHDwkg169VIAFPwUGbmjSXafYup8F
 qmzrG6pi
 W9CzINkHYZ5b4ulKV1NkhkMkMuKABALeXZn1U7XSOMDU9G9i0a3Kcb0SJoguDzK2+3fUlmqttxSTF2koFaL+MjYjZz+bJgQRJ8wgM1rw7pdP5v790qOp89ygW7mQfGUw32VNygcrh1zBI5/j4m6DDe50Xx6+93FS0Yw/VWzKY8GJgboOzYBJfB2uaPUWsHbitL7xoFyZObB/oqu8O5VTte3srWA/CeNr/cruLrWRCFSqqwLb875JWrCbE90Hz2aa5nhKc4CBSQSR+H7Wosz2+ou6m/BPwr/KdVgOU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 4:38=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> (added Suren)

Thanks!

>
> On Wed, Aug 12, 2026 at 12:54:45PM +0200, Pratyush Yadav wrote:
> > On Mon, Aug 03 2026, Pranjal Shrivastava wrote:
> >
> > > The current KHO restoration logic assumes all multi-page blocks are
> > > split into independent 4KB pages. Break out a helper to prepare for
> > > supporting high-order non-compound pages.
> > >
> > > Extract kho_init_high_order_page() to handle the refcount pattern
> > > where only the head page is refcounted. Use the helper for folio
> > > restoration that requires a similar refcount logic.
> > >
> > > Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> > > Signed-off-by: Pranjal Shrivastava <praan@google.com>
> > > ---
> > >  kernel/liveupdate/kexec_handover.c | 29 +++++++++++++++++++---------=
-
> > >  1 file changed, 19 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/k=
exec_handover.c
> > > index 4834a809985a..e836efd98795 100644
> > > --- a/kernel/liveupdate/kexec_handover.c
> > > +++ b/kernel/liveupdate/kexec_handover.c
> > > @@ -357,6 +357,24 @@ int kho_radix_walk_tree(struct kho_radix_tree *t=
ree,
> > >  }
> > >  EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
> > >
> > > +/* For physically contiguous pages. */
> > > +static void kho_init_high_order_page(struct page *page, unsigned int=
 order)
> > > +{
> > > +   unsigned long nr_pages =3D (1UL << order);
> > > +
> > > +   /* Head page gets refcount of 1. */
> > > +   set_page_count(page, 1);
> > > +   /* Clear head page's codetag to avoid accounting mismatch. */
> > > +   clear_page_tag_ref(page);
> > > +
> > > +   /* For high-order blocks, tail pages get a page count of zero. */
> > > +   for (unsigned long i =3D 1; i < nr_pages; i++) {
> > > +           set_page_count(page + i, 0);
> > > +           /* Clear each page's codetag to avoid accounting mismatch=
. */
> > > +           clear_page_tag_ref(page + i);
> > > +   }
> >
> > That's sneaky...
> >
> > The patch _almost_ looks like pure code movement, but then adds this
> > little change. I'm not saying this is intentionally sneaky or anything
> > of the sort, but these kind of things are easy to miss during code
> > movement and should get a patch of their own or at least be called out
> > in the commit message.
> >
> > I don't know how page tags work, but IIRC when the change was originall=
y
> > added by Ran, he said that we don't need to clear the tag for tail
> > pages. That held true for folios, does it not hold true for non-compoun=
d
> > high-order pages?

Yeah, only the head page is tagged with number of pages of (1 <<
order), so the rest of the pages don't have tags to be cleared.

> >
> > > +}
> > > +
> > >  /* For physically contiguous 0-order pages. */
> > >  static void kho_init_pages(struct page *page, unsigned long nr_pages=
)
> > >  {
> > > @@ -369,16 +387,7 @@ static void kho_init_pages(struct page *page, un=
signed long nr_pages)
> > >
> > >  static void kho_init_folio(struct page *page, unsigned int order)
> > >  {
> > > -   unsigned long nr_pages =3D (1 << order);
> > > -
> > > -   /* Head page gets refcount of 1. */
> > > -   set_page_count(page, 1);
> > > -   /* Clear head page's codetag to avoid accounting mismatch. */
> > > -   clear_page_tag_ref(page);
> > > -
> > > -   /* For higher order folios, tail pages get a page count of zero. =
*/
> > > -   for (unsigned long i =3D 1; i < nr_pages; i++)
> > > -           set_page_count(page + i, 0);
> > > +   kho_init_high_order_page(page, order);
> > >
> > >     if (order > 0)
> > >             prep_compound_page(page, order);
> >
> > --
> > Regards,
> > Pratyush Yadav
>
> --
> Sincerely yours,
> Mike.

