Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 919F1D39000
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 18:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05C456B0088; Wed, 14 Jan 2026 13:01:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033CC6B0089; Wed, 14 Jan 2026 13:01:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F856B008A; Wed, 14 Jan 2026 13:01:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D71BC6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:01:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92BB516059E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:01:17 +0000 (UTC)
X-FDA: 84331336194.17.A0C31AF
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6AF57C0018
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:01:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mN+uJ7wi;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768413675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDTsqchLttwh0cFXuiS3EpXCzVEnKRStuaHR3bDL9sU=;
	b=r2eRSsOPiXjYfiDaqSP+KQVNfObB9dYBhe4flda2kRKaJF/T6/BAnk0TDpktoKkO0LcRNp
	FAcVRt9zGv9P4N030z0o9MADwU5OPhfxKCAI/J4K0mpEaSEUflhl8Zm76msx1V5WZxNSrp
	51lr1Wq/RmhmabMhMBYj/zm3YB/q8Nw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mN+uJ7wi;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768413675; a=rsa-sha256;
	cv=pass;
	b=5D9Ga3AIV7VGrtmQJvGrdzp+69ZYovIpgZWBpQLZXYSwLy9lcPCxDsCRdjJ/+jWg/S433H
	RSIf8ztH2TVbPI0AGP2XNoKWaLbUXfdUv7TRvivQRUljR6CRFRFLij+qBeaquGRU/4Wdsl
	pfADS+QP37JVZSiWNNKsEX2bhYIUUpc=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5014acad6f2so6261cf.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:01:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768413674; cv=none;
        d=google.com; s=arc-20240605;
        b=H+5ipuY2KzcY9mfBfYzWV8I2jVCHWW8mjPDKETzEsyExeQfyG/l7RB26oeBoY5uJB3
         E8fPptt6tx+ejoQFEd402doAUePAVM7P+VBRxv872MNopePrraI3wW+YBUd66uvgoXQl
         Q/ssdYvo24VAqKBIYzUWPbCUa9QPW3U23S6L17LLCNHPaE6OuxfTehpwo7SLBaQEhPcs
         8VFXzFx049kxpkKPNsNt3Pr089mzLGooQ8nD75bURRWf54IC7kHCt+mVP5+oh5qq6CAd
         uAtTqDbRNi5KoHPqVLwkB70nqCjpCcq/Y375NFiQ2uT77LscGYik0FKBmGAsoLlgU0dN
         Rv2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KDTsqchLttwh0cFXuiS3EpXCzVEnKRStuaHR3bDL9sU=;
        fh=6eQVREuS/ju3xW0nTne3uMCGWCedKLESYcaBCOa9EgE=;
        b=dlwY3MiDJyKh6jbMmWBP1H87s0n2ULUOwRF0ga/7VtbsrWJ3rHWfMt57ZfCNS+VDIq
         roxFHNDEoTUNpXhzUKLAYDDgofWxNGinCJkJ87o9TGdVx/5GAZZJb766yqAErW+55FSX
         RUdSYhVReRm/zu8B6csrF2q4CTIQSdJEmVkqA6l2ThMx/hQ45XDCQUCC2WOetFbPy4W+
         QnRP8y6v0I3Cl5U/e+ynvsFTKYTM0TDRluKA7sjxd7I+em/UL4KF3MX0ct8A6D1sjJdq
         /JGlfKFmgCYbG38HdeBO9B3xWZhr4apS2lsyq8MSK2wROREd015LR6Wq++v9CzUkmADv
         bYZg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768413674; x=1769018474; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDTsqchLttwh0cFXuiS3EpXCzVEnKRStuaHR3bDL9sU=;
        b=mN+uJ7wi2aNDh8fWGY3bCBGPFdQgdZy+aA0KCHKSZvJL1FQxgUrd3lCbJs3LJ39Pyp
         HR6+L3fZ221Iwj4/JABIeqJRFuUi13ZV3ohqG8TWD52XVe3+r2G9I+4BrHm63CRbqMJu
         3lkV0UgL5GNQ8PY0j0eJPID/ZlXJC3z1opCTdQyFyXmGuzP7nk/ckbHksuW6iZeKVQij
         PVioGAT96JHNm/98J5qCFbFIkmbaJy4gbQosWdD+u92Vi4ViLjXkr3sYqoyYNABi497U
         iJ5tEAxszvx84lx89c7IomqeYsj0+NDddSGQ7O56g90DKkkSGPwcSLS4ZywnS+oI7qZK
         ZtkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768413674; x=1769018474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KDTsqchLttwh0cFXuiS3EpXCzVEnKRStuaHR3bDL9sU=;
        b=UmyfkZhxPRIMJeq04s2jJKXuRQa0Sa56bCoG5OdeXh/1Hb1ULZ8nYLL6GerSFIAkLV
         8Rs93a5Fdzd4YvPwiu0KV70K2KubigncFysJEtjd2/vQle0LeaXpaV0bBH3U7mmB3zpt
         rwt/EtTijBtR1/XVVt6M0sQPnJBlkBpwtkSP7vo3mZkDzluuJOo+xyb66Aoeec+5Tuar
         O+Z9cxD13RwdjcynlG0771ggK9KWd0hETWFzk9K1sXELoFaqMDDta9LhLKwcC3XP2lyk
         og06Gp0tIJFqm4iqXpBRwxV6mwDwFVcBTkWRdo4lkBVr/4KCoggnqNEqsqSZSogB2qPN
         kmzw==
X-Forwarded-Encrypted: i=1; AJvYcCV4eEoUd1LJx23YhwqbsfZFKDS0uUx0qWpLLV/MozfW1lvPzX/AZFr7XNB6zF7JzjsroOf2Kmhemw==@kvack.org
X-Gm-Message-State: AOJu0YyGvfyei/Ctnwp/RPUUII/kiT+Sd/mvbQBvOFd0sPp16+LxfLIS
	v9gi4Sbe1xvqG2/Pr6MFisxt6raY57xJvuGxa9p5p3xm77kuFHi+iT4WblcEc7uC0lOJWHfmnB0
	rzWqa3jGFhKHZJIHGQeyx4Q/F5D3vLLN+NMyYgb9I
X-Gm-Gg: AY/fxX7Bm8NvMsjNsxFBhKmi4aCUu4ewknV/Jro57nbKHnw2bPse1UW5Xkfnr2CJTeK
	txTaAwup/XwTpzRNT8SFif7QQf9t39B0MFffmV3ruYR9sihFYrclvFeivXSF1NTxx9gr2eS8erw
	fjQ49bPfG6ImFHjpkg2DKLNv/sUC72glWFjXto6+GsZejkfa5mr5bIRhFwjb6S9gH4FBFdYf9n7
	SWnJrnn/EJujrahJnbR9RQJ2gDfD6uuNv0bU2DigCTxlllz5oYWyMY4KzBIsNZzcG487WpNvIGx
	uuVsWocry+OniGMGXVzXLfEAGw==
X-Received: by 2002:a05:622a:190b:b0:4ed:8103:8c37 with SMTP id
 d75a77b69052e-50148257b6fmr15030931cf.12.1768413673859; Wed, 14 Jan 2026
 10:01:13 -0800 (PST)
MIME-Version: 1.0
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <9b5a438237e4ea3b19a986a4f8fddb8848cba54a.1767711638.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpGcdZE_Qnm4c7MgyZfZr7fepXuJkc=6ucwUNwUo_JjU0Q@mail.gmail.com> <2808d8d8-e772-4210-ada4-2b39d30c7029@lucifer.local>
In-Reply-To: <2808d8d8-e772-4210-ada4-2b39d30c7029@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 14 Jan 2026 10:01:02 -0800
X-Gm-Features: AZwV_QhtRRztUvUhMt6-Y_uG10BKbcB2fxnrgvhz6T6kogsSj3PTiIy7Dr58sro
Message-ID: <CAJuCfpHN18or=x2jxUpEO+3XkfFo+NUB4DCB2SPk722uwLOAQA@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] mm/rmap: remove unnecessary root lock dance in
 anon_vma clone, unmap
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6AF57C0018
X-Stat-Signature: 5aknmhm59t1un941xz7hbm1cadznxwp5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768413675-923189
X-HE-Meta: U2FsdGVkX18eYKsWO617VV0vqzLwNaGrXuTCmLKCFXr1a6CEr5g6LxObvo+nZ2z0PTCAmd676cas19rTXxIQC9jwRKDEZ/qkz34nvDifH9s9DoNKjU6DEBHGg29Xt3L4PP4rE3MWTCUm8kKpRgrbYKxcV3E7z04jdShceOXRwbojcOuGdhKUqteUmWYfSM0N0JP1NDAFP/dxNBRrMHyVVQ4CChaV2PANH8Jym6a3r705McQTbo6OsM6E6VSgACLlT66LSeNY+8C7Td1JHEXFGHWdSW1PqeaIAMo7MdpvWDtFHuKA7Ra3VevPzFpHnuA5pEN13TsxWajmhg5zfDRCqPLmTzN0uTgV5/uw+1RLlOuDl8V+Y8V8y3EqyFcr8QmMsAgRzd7RM71Kctt9Cf268PXny3XMS4AJ0PFf5JuodwqEvKKIiBezWgYLR62OBz9MpVy9pkC3q4F4tOampUDyfqSf9h4BZNWyJRjqnI2emviCZkUHggzb8caBCRc9tD2OTkzPFjp6b93fdCq6et7AEFl9aN8/T+yq37eaB8oGOBRJfc0FS4dbDvb7nx7CdC1kjlWmEIL+uN7BGFGDbZh5v9pFMj8wZevBnCWF+oh2Tp122VGGT4pt8jKXvq3RUXvPc/Wiu3PUJ9ZldydVEMUzNpGOIXxa3HB3slzu0zPbWK4Npj6mEgzM6Cjo4bbiSdPdyLD5yxNLqoPHLdbUiFZ3+ZnQIsazNswccXG6tg9HAMgf1h3cDbOh9ihknNMvYWzFLFJKZio0m2vxL2GWkjczu/hBrxlglpsuvsKDupW+nH0dK8yUBaUHIcblfIrkSn0b+IIY0WPTrgYIGgTFHSrOGKJPU49hFoUBJh91YMfmUU+3O8OVMiz7hty+umsa0jiNhLIaX2712ifMeS9Jl01TBR+m8Y3lR/Ad/2TTuRsCQTRmhSbjxZ7x7D9Z15IdgVsKxRA9CZ9n0Z7Mor2kXD8
 JpCuBGlX
 fExTwt7tolh2EuvPBnvXALMkocGoVWfFaZTUqiWoRieLOB+7iiFhj8JymagIHl0TGoYy+y6xL8ygjPaC/pis4/oBPV4Myr86ZfwxT5wjxRklFP+PdKLEf3/U941XEWKd+onNVKJW1WLcDXBPjlUcrq49yF95Q4japbaj/pDLnExKX2yODy1wwt4GzyAy1G128Jeo4fP2kuC913cR59Di4OufwonhivyQJGTz5Et5mKuc7Yimn7e45YCGvWvzpTGsbsolrSpMvof6qWJXIgf2aD5GfIr6AO+gxN+IqejtladHFzM08GCvMFdFBzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 9:54=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Jan 14, 2026 at 08:55:58AM -0800, Suren Baghdasaryan wrote:
> > On Tue, Jan 6, 2026 at 7:04=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > The root anon_vma of all anon_vma's linked to a VMA must by definitio=
n be
> > > the same - a VMA and all of its descendants/ancestors must exist in t=
he
> > > same CoW chain.
> > >
> > > Commit bb4aa39676f7 ("mm: avoid repeated anon_vma lock/unlock sequenc=
es in
> > > anon_vma_clone()") introduced paranoid checking of the root anon_vma
> > > remaining the same throughout all AVC's in 2011.
> > >
> > > I think 15 years later we can safely assume that this is always the c=
ase.
> > >
> > > Additionally, since unfaulted VMAs being cloned from or unlinked are
> > > no-op's, we can simply lock the anon_vma's associated with this rathe=
r than
> > > doing any specific dance around this.
> > >
> > > This removes unnecessary checks and makes it clear that the root anon=
_vma
> > > is shared between all anon_vma's in a given VMA's anon_vma_chain.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > ---
> > >  mm/rmap.c | 51 +++++++++++++++------------------------------------
> > >  1 file changed, 15 insertions(+), 36 deletions(-)
> > >
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index de2cbe860566..6ac42671bedd 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -232,32 +232,6 @@ int __anon_vma_prepare(struct vm_area_struct *vm=
a)
> > >         return -ENOMEM;
> > >  }
> > >
> > > -/*
> > > - * This is a useful helper function for locking the anon_vma root as
> > > - * we traverse the vma->anon_vma_chain, looping over anon_vma's that
> > > - * have the same vma.
> > > - *
> > > - * Such anon_vma's should have the same root, so you'd expect to see
> > > - * just a single mutex_lock for the whole traversal.
> > > - */
> > > -static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *r=
oot, struct anon_vma *anon_vma)
> > > -{
> > > -       struct anon_vma *new_root =3D anon_vma->root;
> > > -       if (new_root !=3D root) {
> > > -               if (WARN_ON_ONCE(root))
> > > -                       up_write(&root->rwsem);
> > > -               root =3D new_root;
> > > -               down_write(&root->rwsem);
> > > -       }
> > > -       return root;
> > > -}
> > > -
> > > -static inline void unlock_anon_vma_root(struct anon_vma *root)
> > > -{
> > > -       if (root)
> > > -               up_write(&root->rwsem);
> > > -}
> > > -
> > >  static void check_anon_vma_clone(struct vm_area_struct *dst,
> > >                                  struct vm_area_struct *src)
> > >  {
> > > @@ -310,26 +284,28 @@ static void cleanup_partial_anon_vmas(struct vm=
_area_struct *vma);
> > >  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct=
 *src)
> > >  {
> > >         struct anon_vma_chain *avc, *pavc;
> > > -       struct anon_vma *root =3D NULL;
> > >
> > >         check_anon_vma_clone(dst, src);
> > >
> > >         if (!src->anon_vma)
> > >                 return 0;
> > >
> > > +       check_anon_vma_clone(dst, src);
> >
> > check_anon_vma_clone() was already called 4 lines above. I'm guessing
> > this was accidentally carried over from the previous version?
> >
>
> Yeah I don't know why this is here, in the tree it isn't, maybe Andrew no=
ticed
> and elided? :)

I noticed when reviewing later patches that you remove this extra call
in one of them. That's why the current tree is fine.

>
> But yeah the check above is correct so current in-tree state is correct.
>
> Thanks, Lorenzo

