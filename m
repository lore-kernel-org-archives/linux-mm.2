Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8A1C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 14:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0FE66B009C; Thu, 31 Jul 2025 10:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE0D36B009D; Thu, 31 Jul 2025 10:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E206B009E; Thu, 31 Jul 2025 10:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 935C36B009C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:24:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E93814021D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:24:08 +0000 (UTC)
X-FDA: 83724779376.19.4FB2DB8
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7A5EA2000C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:24:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cWUUBcVM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753971846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaEPQlDrJ3xUdOaNniHVDx2+n9iGAETTjj86f/r2NQg=;
	b=CaRBma9tdGBJTOvN3YOIFlMKHaHuLYhp0t6ufXT/dbDGx2gLT9Kp84WCL19t1tiFFj002Z
	POBN7+cM5xnLDxeaU8w7HO+xPH0Tds2JfJbhmDN1uBHKk+wIa+v/rlrSJy6xGduF8KxqXK
	n+52rNMGMit2tJz7dTKLSJF2mFnh30s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753971846; a=rsa-sha256;
	cv=none;
	b=GewTzuvQbyR1zll12tcu5/+X5AXyu6Lui3CSuNTP2RP/gngNg9BPlxEaopLEtKmM32TxV2
	Swki3qWMumNFZGeCgiLTJjN1K/OvpMQKwRQQsrxKegg0/Zj9m8cJ8kZ7yBZ2dH1vC7Qusb
	1ABC4hfeb205xnJVAPoNxUHZ/esz6NY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cWUUBcVM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso405631cf.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753971845; x=1754576645; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CaEPQlDrJ3xUdOaNniHVDx2+n9iGAETTjj86f/r2NQg=;
        b=cWUUBcVMyIp3hsFhnEDcG4lMj20/P7ogZeXAb4qWdETgdY5xOT/QadAgsZDBpa9AK7
         +OIbiwz25BqeCXlb6/U3LVFxqtP+aootf3ajoqpouSzS6ltRyfIb/h/RZVdtN80ll7yP
         aOjhMCfHH0Z/9ZgOViqdzfmfiMt6mcu2vd59zufpjI4XAASGmwdN67z2y8CtsqGXjx5O
         XNeS/Oc/i4uHn3ykc7p5eGORMzdrXVNoMy2m49cy0hz6C5vJGHMTgTOIV3xPU1+jbeTs
         /k8h9/pVXmbpfjWYMrRXyaLEz1u7WGGoMKvrvc37wwlTQ3O7urPPLTthk6x0Yvur3W/i
         J69w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753971845; x=1754576645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CaEPQlDrJ3xUdOaNniHVDx2+n9iGAETTjj86f/r2NQg=;
        b=sUF/HLha23SmuT9vNUArlu6Pd1HgcIeFttXCwXrbWsBihemKUfy0vD1evmaqdYqJ4q
         8ivq58u3Fre5HhvzWGu+kM2Iius54BYqVdB9PlZFygXjspi+idWn/HOxtSeevva7UQAO
         j+9Jdjsa21QYR4Sl0IRGvSLQ4gi+pSOLn3wyp8HuB1z1TBT3VKEEb45i/nMqYbMP8vYZ
         dMeN2Y8KKVnHFyn5uhEm1aC0dNsk/Smgpu9OvyHO2CEyzWMrY416wWM8KTfAWh7wRbUD
         Q1SOTkLynzRgd/QPwu+tbkEP7jFwdYjM6P31i+5kGJ6IcIrrHI4tGRemz4gi3OKROb9O
         HCvw==
X-Forwarded-Encrypted: i=1; AJvYcCWYN4GFbN5DKO848DtI3mgdbqdvUEhr5wMXJJ7O+rHgWTodJqbkYKvJLJLt04jemcopT7EFMEp3IQ==@kvack.org
X-Gm-Message-State: AOJu0YzK1GGfSFOK2GTEzBBTVwy8vdUcBtvmiA81ovSS10hmS2HXJjhO
	NzlKBXVviEazm1jmpvNKN5SFYTjCG+2g5nOlM9oPdVK0q0sV9j5omX9Bn2rmq6BgLFlCr/VtH5l
	BKQMqyya6Tjmc9V9V9FfaRPyvgHX1/7waVj9e5vuV
X-Gm-Gg: ASbGncugE8+S5QguJtaK1klzuCdo/jfMkrlrEvE2JBTCNAFzoDHM8eQRsRfuNHHucLy
	hT+9iTm0QanoLPsVQwlqQYFjEXVTqcHYupLi/Lh8GSAMVDL9GHf+bqgT4bmxe2d+tDgyFJ8WOMb
	uJLUyJPmBFo2A63JbzXlgM1w2B6UPr8DbLl2zIeS3jmkErzFLfvVFX3U5MbXighmrnm5XVFGdx7
	IS0TwxA2hdc8CCClimX6RvIk5nrIQbFk47y0g==
X-Google-Smtp-Source: AGHT+IH+U7W48iIJwZXQgQOQ/vHHdTop5m5TFsH8fhOVp61+aOVc0QiEilGP1nFKe1yRkmhH6wUYo0aGLXGz+zulmMk=
X-Received: by 2002:ac8:7f14:0:b0:4a8:19d5:e9bb with SMTP id
 d75a77b69052e-4aef1c60a48mr2832411cf.13.1753971845017; Thu, 31 Jul 2025
 07:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250730170733.3829267-1-surenb@google.com> <20250731015241.3576-1-hdanton@sina.com>
 <CA+EESO4mkiedqVMCV3fEnB-xeBMKyct1_WA=YDFVbqSGU4F+6A@mail.gmail.com>
In-Reply-To: <CA+EESO4mkiedqVMCV3fEnB-xeBMKyct1_WA=YDFVbqSGU4F+6A@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 31 Jul 2025 07:23:54 -0700
X-Gm-Features: Ac12FXy9AeUURppfkgynMqQjKLG3IYh8hvItem-Sdjqlh2M8Jm5M7zE6NTKVTE4
Message-ID: <CAJuCfpGzazWVYzc9XXh+xTP9R7cMffiP2P4G5OJTQ0-Ji4xFEQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles a
 THP hole
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: Hillf Danton <hdanton@sina.com>, akpm@linux-foundation.org, peterx@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, 
	syzbot <syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eshz8cpspmn85f43fxwwgtf6ajamzi1c
X-Rspamd-Queue-Id: 7A5EA2000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753971846-297913
X-HE-Meta: U2FsdGVkX19baHgUpxPrIbcc4pYqFLLR/Iyx6Kcv2K3i9qO1eMyQUZEMrDdGy0J2S9Lhd/iJQazjKWgyCqsj4bzIvSS81oQ4PaQ4Q6n4hcJVOxvz0ibyHmfg4K5xS3Qtv56fV9mBdL6sY8skOjL6aiODzjwnBklJRQaDHCMYu6pxw+6noPoq18yU2Eu9p+cBLGzLMD+hxbm4PpAWOLYCwtqJJMSJgCN0aClixkQF+5YnA5XyqRZNJG3HyDVPUPSPFksPyxd6+KYcslv6SMdCKBYy/EVN48VxVUA//Amwh84iv0SOQhM2K1+8Ga4pSdrxFCoVyDr+Pj5ZHzQXkP2GpwJc40sKcputwYaHENdF5WRd3tnUU7Y+ARjueJekNKgCWNsl09/Eg1u52vQs0kBIq3jCCxArMPVhyZ1qPySYup9knUpc89c7a8fm2k38YZEAkLup7pL/DVaVmsR0mZoiQrCYRud3t/d1S4r9gTWvMaXoPptt4Mn91rotWVZ3/qR92ND7Dpsp3svd5ttVJu23+k+YYYt6xQ8K96CfYYQlvrOlmHIm4AhN6J+qklzCigoTwTY6Y6bAzqSN2XRJLVVoFjXqCT/KgRortCAnYKLscWwgJYLkM3Ig6d+MOuHiG3Hsc3tM+vO+Q565JvOcCQgIvmnAg6emI80NJOyY0Y6lW8praylZMlQOnbV6q8ybW3v+hiEYGlkrAm+pdxvv106cPxw+OSL/2jnB1jonqZNrPgewjraiL/357pG3WqKBOSxSfh35j1TPevK677w1Re5rOYW9tX4k39GYJ3bo/307XT9C6P1f7y/hmou+p79xqFybTZEResV1lOnnJ75j0fZyVrMiUD1ymoOUbcsaYGZcIpThMSMB2kVLoHevItsEtMWKnItrUzKuiG/RMbBVqeUZ0kyIl/O6jT4E9FBn3vfjmdBaB2m0f5tiAn/hYWu1WEMfZlZdB0u7u0ntRLyyrYQ
 mZqYDLvm
 OcAqIlk5RCVNKAmE6e3ufgsTHoPY9UruGBse50uV/r4pb2KqtqlZQDRfy7Fk7v+aayMzGvmhx7rtNskGhTyWywSgRX2bjaXbyab0KlaDbaPfK3ntefRf9QG5ZW7eV99OOJNaS8Kiqh8oSKRLePely2CA0qchzKKF3l7l7AaBhPotfeeAIqLmI9BIUHhknBc/tesYv2dWcaCSp0Cl72bvQF9bCyGf79Q8Ju6HpyUIUwZ76IJeGOSTMpWPBDZaTUuR2d1TSTayjTQ84h6LhKDXd+Gfiao0UIedQEwuog3GrbT/8pH79j8yJCJDArAMAxXi0W0s/JP8HqPQPrS0k7xw5ABbecgNAedFXtn311LqSXKxdaR1jTdbhoku4fN4/bmGnUNitxmdFmuKGRyky0Yh0oK8IBX61fFWURK5e5YVDufnKBshpJ9Td8Vete7R+8W/JagV6iot9ykvshLDq/XeApMfw1kfaKejPw8H/f2Sl7KyBBt0IkJg/IAfU/3lhGbCf9ma88wAfaGIYzGE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 12:35=E2=80=AFAM Lokesh Gidra <lokeshgidra@google.c=
om> wrote:
>
> On Wed, Jul 30, 2025 at 6:58=E2=80=AFPM Hillf Danton <hdanton@sina.com> w=
rote:
> >
> > #syz test
> >
> > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> > encounters a non-present THP, it fails to properly recognize an unmappe=
d
> > hole and tries to access a non-existent folio, resulting in
> > a crash. Add a check to skip non-present THPs.
> >
> Thanks Suren for promptly addressing this issue.
>
> > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@go=
ogle.com/
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  mm/userfaultfd.c | 38 +++++++++++++++++++++++---------------
> >  1 file changed, 23 insertions(+), 15 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index cbed91b09640..60be8080ddd0 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1818,27 +1818,35 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx,=
 unsigned long dst_start,
> >
> >                 ptl =3D pmd_trans_huge_lock(src_pmd, src_vma);
> >                 if (ptl) {
> > -                       /* Check if we can move the pmd without splitti=
ng it. */
> > -                       if (move_splits_huge_pmd(dst_addr, src_addr, sr=
c_start + len) ||
> > -                           !pmd_none(dst_pmdval)) {
> > -                               struct folio *folio =3D pmd_folio(*src_=
pmd);
> > +                       if (pmd_present(*src_pmd) || is_pmd_migration_e=
ntry(*src_pmd)) {
> > +                               /* Check if we can move the pmd without=
 splitting it. */
> > +                               if (move_splits_huge_pmd(dst_addr, src_=
addr, src_start + len) ||
> > +                                   !pmd_none(dst_pmdval)) {
> > +                                       if (pmd_present(*src_pmd)) {
> > +                                               struct folio *folio =3D=
 pmd_folio(*src_pmd);
> > +
> > +                                               if (!folio || (!is_huge=
_zero_folio(folio) &&
> > +                                                              !PageAno=
nExclusive(&folio->page))) {
> > +                                                       spin_unlock(ptl=
);
> > +                                                       err =3D -EBUSY;
> > +                                                       break;
> > +                                               }
> > +                                       }
> >
> > -                               if (!folio || (!is_huge_zero_folio(foli=
o) &&
> > -                                              !PageAnonExclusive(&foli=
o->page))) {
> >                                         spin_unlock(ptl);
> > -                                       err =3D -EBUSY;
> > -                                       break;
> > +                                       split_huge_pmd(src_vma, src_pmd=
, src_addr);
> > +                                       /* The folio will be split by m=
ove_pages_pte() */
> > +                                       continue;
> >                                 }
> >
> > +                               err =3D move_pages_huge_pmd(mm, dst_pmd=
, src_pmd,
> > +                                                         dst_pmdval, d=
st_vma, src_vma,
> > +                                                         dst_addr, src=
_addr);
> > +                       } else {
> > +                               /* nothing to do to move a hole */
> >                                 spin_unlock(ptl);
> > -                               split_huge_pmd(src_vma, src_pmd, src_ad=
dr);
> > -                               /* The folio will be split by move_page=
s_pte() */
> > -                               continue;
> > +                               err =3D 0;
> I think we need to act here depending on whether
> UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES is set or not.

Hmm, yes, I think you are right. I thought we would bail out earlier
if !UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES but I think it's possible to get
here if the PMD was established earlier but then unmapped.

>
>            err =3D (mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES) ? 0 : -ENOEN=
T;
>
> Also, IMO, the step_size in this case should be the minimum of
> remaining length and HPAGE_PMD_SIZE.

Ah, ok. I think it matters only for incrementing "moved" correctly
because otherwise the functionality is the same.

> >                         }
> > -
> > -                       err =3D move_pages_huge_pmd(mm, dst_pmd, src_pm=
d,
> > -                                                 dst_pmdval, dst_vma, =
src_vma,
> > -                                                 dst_addr, src_addr);
> >                         step_size =3D HPAGE_PMD_SIZE;
> >                 } else {
> >                         if (pmd_none(*src_pmd)) {
> I have a related question/doubt: why do we populate the page-table
> hierarchy on the src side [1] (and then also at line 1857) when a hole
> is found? IMHO, it shouldn't be needed. Depending on whether
> UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES is set or not, it should either
> return -ENOENT, or continue past the hole. Please correct me if I'm
> wrong.

I thought about that too. I think it's done to simplify the logic.
This way we can treat the cases when PMD was never allocated and when
PMD was allocated, mapped and then unmapped the same way.

>
> [1] https://elixir.bootlin.com/linux/v6.16/source/mm/userfaultfd.c#L1797
>
> >
> > base-commit: 01da54f10fddf3b01c5a3b80f6b16bbad390c302
> > --
> > 2.50.1.552.g942d659e1b-goog

