Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952A0C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 15:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015A46B008C; Thu, 31 Jul 2025 11:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2FCE6B0092; Thu, 31 Jul 2025 11:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45376B0093; Thu, 31 Jul 2025 11:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D32D56B008C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:08:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 801E8114623
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:08:46 +0000 (UTC)
X-FDA: 83724891852.26.1DD7305
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 802EB120013
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:08:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=d5x1e64+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753974524; a=rsa-sha256;
	cv=none;
	b=oMD3QvMQC/dqFtQC5dqrlilG3Bfu4/z9opcDZoI5/bYLEDD4kzdlWT5E+ukXpxpn8b7ot6
	CYuHjNeoO8vJloRkfxHt+xGacl0fTy72t356cQd3Q+cjmzCwBiAxtXm5DMvTV+81oyR0wa
	Wn448Zw4FCtrBK9R7SBwaCQzpjEYPek=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=d5x1e64+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753974524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmMz7Y87iVAn/fXyg5XDVIpHc/uVHLJxWrjG1qWFlkA=;
	b=npUmDimrKrvH3baRcXA66ju5d+B86p3Svs7v355aQsv4JZxTDl5jMZ2FMXdf44xR5vEvC0
	hw0Dz5AbXzKwTB4wW9UaO6grspzJ82wdPJqsuxFCXjgXFSvakHWmqy4OtGTJdQ7KSL2x4I
	hOFFv5Urf3owpskx5DsxeYLHrtgMHlg=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61543b05b7cso13131a12.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753974523; x=1754579323; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zmMz7Y87iVAn/fXyg5XDVIpHc/uVHLJxWrjG1qWFlkA=;
        b=d5x1e64+FWS+VrWen6hU+EzfvT8bbErhPmyEDba8OV0kBwAY6VfIq7LU3KYzMUHQW7
         tq9x6JQnuqajl/kg558NDejJPLsZK4+Ny6hh4lJchF4UG0li16aMkpvmPL0fmoi21vyY
         VlSMiZnDr5n3AS0ccTfH9KH3cfw7mF/6bReUaAxX2+smvJJ0TK3N58j2lDC/TcdgF+4c
         wjZn8mQ1DIrFNrSIURyhakAWe+UEA7RVSvRdG1lugHUVzmUUDWNgQAivxkldzjkkPggw
         IuAvU6yM2HNdd7saJorPqlU2mIl2PJ/af5Idrv7mFV4YU7gjbyVzWLSdwrP9PMDHmb6i
         ly1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753974523; x=1754579323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmMz7Y87iVAn/fXyg5XDVIpHc/uVHLJxWrjG1qWFlkA=;
        b=NFCqKiyh0augAsydWuTfyv6xALp4VrYN5S2J1eeIyda9cl4neY2O89Q+pyvMRLzHgf
         BiBsHb4VwbUuSW+6agdHKydKFzN1d3aLnIo7LT5dxSrbcemVM4Sar/gxKU0Fq5rP7xnq
         yzvccKNF1soD0x9ozDH23ygB3zcmUNeU2i7vyZSG3Sm/AqAry+dKPYU+SPXScvIThX2y
         TtBDSU4tr4SN9lK3zivlqikO8bQ66IrRryvDYt6CAQdqUD3VwGGC1sgHwdV13j0hnK00
         1Kj63oaWjtF3W51CvV9wLGqpU8/XsknNhQfn/e4njKiPvrNpM+pPjfblBo/VTvm8iPnh
         kimA==
X-Forwarded-Encrypted: i=1; AJvYcCUUfmrIItf4pPDB7ICnUZn19MMNn+s681tC4+icandGDASfhnq1B3zSPpzAjQQe2ztsqaeDnTYJlg==@kvack.org
X-Gm-Message-State: AOJu0YwfIx/Tog18wqPlr5IqI1ZNZNssyERT/8McZDcvc7YzC/xk3LYK
	kCfaSovjMlrlwrDP5V8pvVE0SW0F3S9YrHh2nyG6LX8nB2dh3M6QlEJdaHPRl5oXYBInJwBjtGG
	enBFZA7Ex0Faa2AJXmvplOuu6PLAJkskWCJ6Kctz4
X-Gm-Gg: ASbGncvEVwC4+SXjc2QXNZ2GdnwMbluuS1UHCAfnDJN6e4kTr1pZiZ3a/WGTwtfURQ6
	i3qAuv3SacMkWaS5fAO3TuqHDZ0dr32qdqRrkSyK62XxaCuifLqb/5h7L6EnkjaL/YFdxoS9HJD
	RwsYUawg31QTXZh7g4HPiZNdzucvFkGcY55Hoya9Uoxdu3DFk1K1F3y1aZ9tMpSH+kR/NiK2tT8
	ZOxvqpc3Ur2suRepJIG0Y7dCeuHKhyH0P864oCzZg==
X-Google-Smtp-Source: AGHT+IHpZroMnR8gNbnJ6Hl9Azyb+Hb8r/YpRDMj/t8qAd1gcDSdLIfF7iA0Z5SXN0Jk5/1OoME3F4GcnV0AJtVw4OA=
X-Received: by 2002:a50:d75c:0:b0:607:d206:7657 with SMTP id
 4fb4d7f45d1cf-615ab47613amr78190a12.2.1753974522596; Thu, 31 Jul 2025
 08:08:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250730170733.3829267-1-surenb@google.com> <20250731015241.3576-1-hdanton@sina.com>
 <CA+EESO4mkiedqVMCV3fEnB-xeBMKyct1_WA=YDFVbqSGU4F+6A@mail.gmail.com> <CAJuCfpGzazWVYzc9XXh+xTP9R7cMffiP2P4G5OJTQ0-Ji4xFEQ@mail.gmail.com>
In-Reply-To: <CAJuCfpGzazWVYzc9XXh+xTP9R7cMffiP2P4G5OJTQ0-Ji4xFEQ@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Thu, 31 Jul 2025 08:08:30 -0700
X-Gm-Features: Ac12FXxDR_jDXV2_itlIrHvfQvtXRY2GLBRhyzMxKRUo0_JmXQBqs2eQDyu-PXM
Message-ID: <CA+EESO7axBaw7zWhG=Asuu3d5mR+QMw=cht64xdGdJGi7URhsg@mail.gmail.com>
Subject: Re: [PATCH 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles a
 THP hole
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hillf Danton <hdanton@sina.com>, akpm@linux-foundation.org, peterx@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, 
	syzbot <syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 802EB120013
X-Stat-Signature: 7u9hmsxeynrx9zk68errgkiis1x48igu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753974524-741943
X-HE-Meta: U2FsdGVkX1/Zq+tVtvouxsYJB79nftcqFZBU1eOpICSGk3yLB0lJd/+a2IsoiUBNWAQrNAY0uoLzsnYRWRqSnaMbgYRP+a5qHeEWc1mevqlG6h+ILCXUyPis6FzsWeez0OT9yjoU9nY7xiLePyy9l5/QgtYajIR+c+ZTkU2KG0QGxiLKN8CBRzXX/1mr38rULUcBmt//++jylJmA/NZtQfenbzvwBACYZkB5u6InSjay69uaX9pO1KzrRz39/3dSboFY5i46GB2uWUiwfKjknECZpHzQdinAscY4Q0eEyx3EXGLxVzk+g3vrz1UN4WnlA1KOO/ZEESlHdvW+Cm9yYobKxGjJ/Xi61zJMoYUb5a5wp/SF4klYVK1dev7Ep6UPuFTJ005/C6OTmX9Le5mjb0q0+GXSnuOLJz2MnYc4YRV/qAR6NwbyIHiMy5sPbLYExEsdUv/5rHQcjLsLHqQNYl7E96umaJ0dhQzVSd5iB9/SgI6ir8bM8EorOS350sh7qhZOLznK9J5pqTw+SzLwLdlAGOExIRcZHPl0X+Cg7fnswPDdpkNCCS3XGK8mwH/oKLM0b1FB2qJjFbXaAXwXt8VslaVc6PC87X1DFkOwSAMsYdthRvinVmgvLd+Ak4PgARfHy9+waoZNfmCdVjvkvrhJep6EjBg+kpK/r7pRign+iQJ1eiDmTW8L1waoW/4ls7Vz2wPrzE7idC3zAWVNat13EAirB3XhgzzFTRBRUy+IYfW0Or7yTfq5WKyit8h405Yw/HKAf5ITSyOEUUFN5bxQiVT0E+La+mgY2rbqaMpXHbeIzjrl3dVy4K8qxzfqHpwdRl0XyUT7dMv3rA2fLRVrSBJotkHC97ZUZ2sGT21jsZTWhBlEozWu2o4VusSAeT54G14IMjQsW2LZP6D2Wcd87lbY+8YqyL3Os3PuwjxCF6BUySJY9hGXXCZFOZkYvMQxTHntjsul9AGff7R
 NwRPntRs
 1HNvnD8Vbw1weLgtTzAOESg8dr0p+fJ4i9r0F0RVWRrBzkY+LVfcQcKDNXLfcnDEBwYN3o+BxEHBfe12odj7ldYEge0F6SemDTguCRZlZCoObbLvweNRoxoy4SwmFpsMIbG8Lis1aWSUDvkEggKXBesEwfffsBhJlNbHMrKSKUetMZgredgykGPl/3lOHHOnsd3zlQWnrU4q+wldt6DM/T0hdEua11aZws19NeUsjzjyw5uA+f9IiY5qXFXbgIISbv/ijOOx2C7Soe/eI7JqPnB9hKUo67xCd0oTdlwjUosTmO07WMi5Aln/qQ+UhLDLrxc3kHhdS9Kdi2is5TlzgceX5/O+Ko2l64GdfU73MNwmK9rcpZIoWAOrp0MNg1sAuWYLeBtnzCPidjSuQTZZbigcMrOo5VGpgsz+8C2GhUanFSPjFPTiLg9fTz/JCDLcDDCPo+komQnjsILzYGc6oZpnTszNGQ/EU0tVppLvzc6pVPpryjwAeuv+4tGvmPrHkvL2lw385qWmz80Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 7:24=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Jul 31, 2025 at 12:35=E2=80=AFAM Lokesh Gidra <lokeshgidra@google=
.com> wrote:
> >
> > On Wed, Jul 30, 2025 at 6:58=E2=80=AFPM Hillf Danton <hdanton@sina.com>=
 wrote:
> > >
> > > #syz test
> > >
> > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> > > encounters a non-present THP, it fails to properly recognize an unmap=
ped
> > > hole and tries to access a non-existent folio, resulting in
> > > a crash. Add a check to skip non-present THPs.
> > >
> > Thanks Suren for promptly addressing this issue.
> >
> > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@=
google.com/
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  mm/userfaultfd.c | 38 +++++++++++++++++++++++---------------
> > >  1 file changed, 23 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > index cbed91b09640..60be8080ddd0 100644
> > > --- a/mm/userfaultfd.c
> > > +++ b/mm/userfaultfd.c
> > > @@ -1818,27 +1818,35 @@ ssize_t move_pages(struct userfaultfd_ctx *ct=
x, unsigned long dst_start,
> > >
> > >                 ptl =3D pmd_trans_huge_lock(src_pmd, src_vma);
> > >                 if (ptl) {
> > > -                       /* Check if we can move the pmd without split=
ting it. */
> > > -                       if (move_splits_huge_pmd(dst_addr, src_addr, =
src_start + len) ||
> > > -                           !pmd_none(dst_pmdval)) {
> > > -                               struct folio *folio =3D pmd_folio(*sr=
c_pmd);
> > > +                       if (pmd_present(*src_pmd) || is_pmd_migration=
_entry(*src_pmd)) {
> > > +                               /* Check if we can move the pmd witho=
ut splitting it. */
> > > +                               if (move_splits_huge_pmd(dst_addr, sr=
c_addr, src_start + len) ||
> > > +                                   !pmd_none(dst_pmdval)) {
> > > +                                       if (pmd_present(*src_pmd)) {
> > > +                                               struct folio *folio =
=3D pmd_folio(*src_pmd);
> > > +
> > > +                                               if (!folio || (!is_hu=
ge_zero_folio(folio) &&
> > > +                                                              !PageA=
nonExclusive(&folio->page))) {
> > > +                                                       spin_unlock(p=
tl);
> > > +                                                       err =3D -EBUS=
Y;
> > > +                                                       break;
> > > +                                               }
> > > +                                       }
> > >
> > > -                               if (!folio || (!is_huge_zero_folio(fo=
lio) &&
> > > -                                              !PageAnonExclusive(&fo=
lio->page))) {
> > >                                         spin_unlock(ptl);
> > > -                                       err =3D -EBUSY;
> > > -                                       break;
> > > +                                       split_huge_pmd(src_vma, src_p=
md, src_addr);
> > > +                                       /* The folio will be split by=
 move_pages_pte() */
> > > +                                       continue;
> > >                                 }
> > >
> > > +                               err =3D move_pages_huge_pmd(mm, dst_p=
md, src_pmd,
> > > +                                                         dst_pmdval,=
 dst_vma, src_vma,
> > > +                                                         dst_addr, s=
rc_addr);
> > > +                       } else {
> > > +                               /* nothing to do to move a hole */
> > >                                 spin_unlock(ptl);
> > > -                               split_huge_pmd(src_vma, src_pmd, src_=
addr);
> > > -                               /* The folio will be split by move_pa=
ges_pte() */
> > > -                               continue;
> > > +                               err =3D 0;
> > I think we need to act here depending on whether
> > UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES is set or not.
>
> Hmm, yes, I think you are right. I thought we would bail out earlier
> if !UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES but I think it's possible to get
> here if the PMD was established earlier but then unmapped.

That makes sense too. My thinking was that the
!UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES check above is only when !src_pmd,
which means the src pmd-page itself isn't present. However, the case
where pmd-page is present, but the pmd entry is not; continuing
skipping the hole even when user cannot tolerate src-holes would break
the userspace logic.
>
> >
> >            err =3D (mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES) ? 0 : -ENO=
ENT;
> >
> > Also, IMO, the step_size in this case should be the minimum of
> > remaining length and HPAGE_PMD_SIZE.
>
> Ah, ok. I think it matters only for incrementing "moved" correctly
> because otherwise the functionality is the same.
>
Right. Returning an incorrect "moved" value to userspace can break the
logic, possibly causing data corruption.

> > >                         }
> > > -
> > > -                       err =3D move_pages_huge_pmd(mm, dst_pmd, src_=
pmd,
> > > -                                                 dst_pmdval, dst_vma=
, src_vma,
> > > -                                                 dst_addr, src_addr)=
;
> > >                         step_size =3D HPAGE_PMD_SIZE;
> > >                 } else {
> > >                         if (pmd_none(*src_pmd)) {
> > I have a related question/doubt: why do we populate the page-table
> > hierarchy on the src side [1] (and then also at line 1857) when a hole
> > is found? IMHO, it shouldn't be needed. Depending on whether
> > UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES is set or not, it should either
> > return -ENOENT, or continue past the hole. Please correct me if I'm
> > wrong.
>
> I thought about that too. I think it's done to simplify the logic.
> This way we can treat the cases when PMD was never allocated and when
> PMD was allocated, mapped and then unmapped the same way.
>
Makes sense. Thanks for clarifying.
> >
> > [1] https://elixir.bootlin.com/linux/v6.16/source/mm/userfaultfd.c#L179=
7
> >
> > >
> > > base-commit: 01da54f10fddf3b01c5a3b80f6b16bbad390c302
> > > --
> > > 2.50.1.552.g942d659e1b-goog

