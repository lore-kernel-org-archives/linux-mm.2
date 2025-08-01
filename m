Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C42AC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 16:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4226B008A; Fri,  1 Aug 2025 12:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C0F6B008C; Fri,  1 Aug 2025 12:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8B226B0092; Fri,  1 Aug 2025 12:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C945C6B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:41:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48197801BA
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:41:46 +0000 (UTC)
X-FDA: 83728755012.10.2CAE56C
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5648A18000C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:41:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tLpvukIs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754066504; a=rsa-sha256;
	cv=none;
	b=6wFdInmVrkeEfr9yQouaFUDjzYOZr8cJFw6MisKeiU+2PFJ4BYQjH+hTbNK7LjE2lR/uZ3
	J3R91tFNZ7RvY2q7AQOU3zPQ4za4slQSKNEE6F4YptFZIWd0D7Zsy2uXIgK9Iy0cT5EtmO
	p3iBhGYlJ39N0QXxTcjxUh0jEMormZU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tLpvukIs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754066504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aLimaLSF0lRymehoPqMxWNX91cMbYtFkQRKb1ah50F4=;
	b=g5Xs8J0cRejQwY8OJyC1h04GD6CvDSGDYhZL2vmbSUThfuyTmW7kHlecZ/Kq909b+dx3lo
	Etgk2ryGUNWM3j7wuBUJuQJt8LM+00iOcHdgdn2+9oN9GTUn+dt9q4cpHNyPBsidMMpKa0
	wcpZeRxl6vEUbG4cY0msVftTc+TDvpY=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ab86a29c98so1011cf.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 09:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754066503; x=1754671303; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aLimaLSF0lRymehoPqMxWNX91cMbYtFkQRKb1ah50F4=;
        b=tLpvukIsSHtqrKyXj6kA8xXLJBSyQ6gE7ho8uIOgaFMc8IuNb3ufLCZbXLL9lCwlgX
         YLLqDz9YrWjO/t/gp5SvS0lOWbSPXKtbzQvzNSpJdJ45ZD4mXp48lTNAy6AuMKoLuf/6
         61t+iPH+beROJV0nNgXuh97vDb8+Zf5f/X9+i1b8Pc+s185CDJXv2/wQFyZUBIBWBgtT
         MLhP71dShlBTuy/scDVYmyL1MJ693ixYKOeGTl/Ez6bINzVzuiWrxBir1WA5ZrL9BoCA
         hlxAeB4cbUPyRaz5q8v8LbSeVI2Cfn846pSsCjOUaoQPGizyQ/hKO00b0h0vdAHF5+MA
         S2uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754066503; x=1754671303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLimaLSF0lRymehoPqMxWNX91cMbYtFkQRKb1ah50F4=;
        b=w96g9pxg5rl6ecqwVtLRJSqbp1bHPmH3+d2O+Ef/h2NkDDIZNWpg4TmFCSzfy5bwLI
         P9nuq9LUkAw8L6G8IeemMwsmWsWPz1ObS76agfleHdHbu4jK+qoSoVwxrG1aF9NjgN8q
         npF4zwYwx6ISNr/qc7S/yTsWtd2uaaotIPMILu7/653J57Unb/Tl8L8hMCDNPqJ2k5PI
         RQ77eTuL0kkGxl3iAmF/jqV+ztTub5kGgk+xbC/p84PXck6QXbPONm2JnI3m3dLEAJxE
         V7rSJjQnKG2byBwNMK0EPhtXIHeDkEzp49jruPMeMhVsGIadZofJZSPp6BXT9TOG7EfX
         8E5A==
X-Forwarded-Encrypted: i=1; AJvYcCUP8VgDO5wZ/JDw2KUTjhdyJUBbqlW9zff2ccs3Pvcw93yNZgrbwmJ7SPSO3A3JWri88j1cA6Lo5g==@kvack.org
X-Gm-Message-State: AOJu0YxjbhXQN0dehbxedza9r8atHlPHpk3JWRfy2AK2hKdH9XfyE9vt
	aUnNFV8RgqKSyaejCYe/y0iF8Jxn9tUiEZPZywVzY1GI/Kqr8zQ5RgQXjCIxLPL1k3j7wN7wqNM
	oKQHlq+IMLpcKvo7d0fEhwKWhfLoUWHg7FmZYsGUa
X-Gm-Gg: ASbGnctc7sgl/MtKUGWAQsMqv9qOAz+s38nz+BQ8HysmiELTSIEgDgZGKZV9bSrA+Rc
	YbicII2S20z2MPpAlgPW3myP/mf2voK620lAPXL8DWzzIGvxVbU/9uEFpFCBTKbbwibUqX/su63
	sSEtSOtmEeqXYkqrlXF9lpNUnjPILCnWTRTIPb5fnygViHwYhcT4CfGwHvwzwZsubNdZwxOY049
	N3lBQ==
X-Google-Smtp-Source: AGHT+IEpaLl/A+9aL/diYC+pE/kX9Ys6qSrIphoEP7QJcRER5WfcbYHZMpuH0caPX2vRoiH3NPCvKbvZRwD9xI3Pl5s=
X-Received: by 2002:ac8:5d94:0:b0:48a:ba32:370 with SMTP id
 d75a77b69052e-4aefe36d9fdmr6003651cf.10.1754066502880; Fri, 01 Aug 2025
 09:41:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250731154442.319568-1-surenb@google.com> <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
 <aIzMGlrR1SL5Y_Gp@x1.local> <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
 <aIzp6WqdzhomPhhf@x1.local>
In-Reply-To: <aIzp6WqdzhomPhhf@x1.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 1 Aug 2025 09:41:31 -0700
X-Gm-Features: Ac12FXypqQI2y88pBWYtFSUzrdqaOmVf2bSfcWinVsHrN_bkOmTXLjklNn0Swe0
Message-ID: <CAJuCfpGWLnu+r2wvY2Egy2ESPD=tAVvfVvAKXUv1b+Z0hweeJg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5648A18000C
X-Stat-Signature: ms4btq47q39dssyro79rstwf8s1a75pj
X-HE-Tag: 1754066504-780941
X-HE-Meta: U2FsdGVkX18XMVuzVMXrtD4FAzqF11NJwBUsEFghu8uwbDh8o33vkknyydbG4C6fD1/u/NXiRjQ4ONorZYedCdsD25h6wiI/tpmL40tRHJQzjUL/tSld54XKOvkk9jh2JDEQMAfv+AirqpKmYBDsX6BLLgth6I0k4zRytnYK+T620jCCdrm6C44Z6fFDN8hRNlwdM+58Ye0beOPCPzvrMElVnt7GOaxUVSOv/JtiJXnI/KPiuW3Jvrldb2rZOFCZkQQg/uYn6UZjxLKBJrvv8W4Hpm23Q8Wa8COCHMM8h1ETZ7x058/2/LsgwCqakUBmSRRjig8G1WT7yqNZEMcPJKcB3+xdnsnhJ6o2xVNWJ6nRJgJ093f3a2S4lZbZ4o1xuia5BKw9P0fZkR+i5yl5F03wcZODNEP4iZXZgHm0Bkc/BYyY7MFnnf30tispZrNaIgGun7MyZ4Kp0wVH2oGtSYJ+VgGGUaYNIUWD1SECJI0vZd4UWy928KhO+3QInNE91EAYbM+LBq5edhN9yiay35lsKfvyBwLM32qv+d6zUPrgTvy5yfP3Il8T1qXeJYRplw4aDGRHbBG1Q9MSY5aNXRAhPIcfcDTXef6SEo+RWp/QdZ9RJgUcxMm8OPaCfBEVCBdI9t0lcCBtto3lgbriKyG43yB6uhwG/p+tTusoGfk8aZ8mRMT1q9E0VedvMhj3ryS/QtrZk0St40IfU5Ayu9fo7FQr4c6BS6Auss03OIbPMeAfVlm3gF09x7sOYKGA/BKLXBIGTDB+Vm9Wpe/9qZ1zVqs2LrGOp7Hl3L2Zj4U/FE2PzvIM/TAiXHb8CMGGh3AbgYn7gT8aTV8Bw19SXnqrWJYxd0wmI+s4DVbX2NxzzG1jZWr88JuLqrxn/xLx7nWyfpdhIB5hzGEGbqfiWFxo2KXUGOOQg2kGk4rjnTAbhZC8tM0VdbbomF8px6x4J5Bnnp05yVDKqmKVFYV
 DcavbZeB
 +pBS9ke3MmAAguqpMFJfJjW/0Kx2l0qDPgp3YPT/Yp1j+EBKZHwadj3knseRRghqR63rGYRMIVv7c9ml58m1+UV3JEW/KakebwKq8tC8uz3NDznWJEszxvVwmbmOL6ZyiTFL4bDLXqHWKwldCEAgscAH1ZhTuakUOEgA2/lUzgZTa74Y5S2kYKjQKU1TSD2h0wEBuOOMsPzIj3/LEg7Z4QaMFlr2J9aLfDIyE68JCVgmVvaUfGYBAMdiWiYZbvKVWQVsQ1td7qjVXoLQIxW5c/TkuZ0VgNrUEtXiag+Qm5EsVe4LY2WGDXAT47AfopfQkpucjqCGZIc4QX1W9awPrMiBhMHDE+1ItbdkNGvCNqzLycE9dyBfenDQVp9TLzl4uQlojq8Me9lcGjybPV8sWcvobO79R+PKPz6zabWDl/gtGa18=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 9:23=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Aug 01, 2025 at 08:28:38AM -0700, Suren Baghdasaryan wrote:
> > On Fri, Aug 1, 2025 at 7:16=E2=80=AFAM Peter Xu <peterx@redhat.com> wro=
te:
> > >
> > > On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hildenbrand wrote:
> > > > On 31.07.25 17:44, Suren Baghdasaryan wrote:
> > > >
> > > > Hi!
> > > >
> > > > Did you mean in you patch description:
> > > >
> > > > "userfaultfd: fix a crash in UFFDIO_MOVE with some non-present PMDs=
"
> > > >
> > > > Talking about THP holes is very very confusing.
> > > >
> > > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES an=
d it
> > > > > encounters a non-present THP, it fails to properly recognize an u=
nmapped
> > > >
> > > > You mean a "non-present PMD that is not a migration entry".
> > > >
> > > > > hole and tries to access a non-existent folio, resulting in
> > > > > a crash. Add a check to skip non-present THPs.
> > > >
> > > > That makes sense. The code we have after this patch is rather compl=
icated
> > > > and hard to read.
> > > >
> > > > >
> > > > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.co=
m
> > > > > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.=
GAE@google.com/
> > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > ---
> > > > > Changes since v1 [1]
> > > > > - Fixed step size calculation, per Lokesh Gidra
> > > > > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, per L=
okesh Gidra
> > > > >
> > > > > [1] https://lore.kernel.org/all/20250730170733.3829267-1-surenb@g=
oogle.com/
> > > > >
> > > > >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++------------=
----
> > > > >   1 file changed, 29 insertions(+), 16 deletions(-)
> > > > >
> > > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > > index cbed91b09640..b5af31c22731 100644
> > > > > --- a/mm/userfaultfd.c
> > > > > +++ b/mm/userfaultfd.c
> > > > > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd_ctx=
 *ctx, unsigned long dst_start,
> > > > >             ptl =3D pmd_trans_huge_lock(src_pmd, src_vma);
> > > > >             if (ptl) {
> > > > > -                   /* Check if we can move the pmd without split=
ting it. */
> > > > > -                   if (move_splits_huge_pmd(dst_addr, src_addr, =
src_start + len) ||
> > > > > -                       !pmd_none(dst_pmdval)) {
> > > > > -                           struct folio *folio =3D pmd_folio(*sr=
c_pmd);
> > > > > +                   if (pmd_present(*src_pmd) || is_pmd_migration=
_entry(*src_pmd)) {
> > >
> > > [1]
> > >
> > > > > +                           /* Check if we can move the pmd witho=
ut splitting it. */
> > > > > +                           if (move_splits_huge_pmd(dst_addr, sr=
c_addr, src_start + len) ||
> > > > > +                               !pmd_none(dst_pmdval)) {
> > > > > +                                   if (pmd_present(*src_pmd)) {
>
> [2]
>
> > > > > +                                           struct folio *folio =
=3D pmd_folio(*src_pmd);
>
> [3]
>
> > > > > +
> > > > > +                                           if (!folio || (!is_hu=
ge_zero_folio(folio) &&
> > > > > +                                                          !PageA=
nonExclusive(&folio->page))) {
> > > > > +                                                   spin_unlock(p=
tl);
> > > > > +                                                   err =3D -EBUS=
Y;
> > > > > +                                                   break;
> > > > > +                                           }
> > > > > +                                   }
> > > >
> > > > ... in particular that. Is there some way to make this code simpler=
 / easier
> > > > to read? Like moving that whole last folio-check thingy into a help=
er?
> > >
> > > One question might be relevant is, whether the check above [1] can be
> > > dropped.
> > >
> > > The thing is __pmd_trans_huge_lock() does double check the pmd to be =
!none
> > > before returning the ptl.  I didn't follow closely on the recent chan=
ges on
> > > mm side on possible new pmd swap entries, if migration is the only po=
ssible
> > > one then it looks like [1] can be avoided.
> >
> > Hi Peter,
> > is_swap_pmd() check in __pmd_trans_huge_lock() allows for (!pmd_none()
> > && !pmd_present()) PMD to pass and that's when this crash is hit.
>
> First for all, thanks for looking into the issue with Lokesh; I am still
> catching up with emails after taking weeks off.
>
> I didn't yet read into the syzbot report, but I thought the bug was about
> referencing the folio on top of a swap entry after reading your current
> patch, which has:
>
>         if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
>             !pmd_none(dst_pmdval)) {
>                 struct folio *folio =3D pmd_folio(*src_pmd); <----
>
> Here looks like *src_pmd can be a migration entry. Is my understanding
> correct?

Correct.

>
> > If we drop the check at [1] then the path that takes us to
>
> If my above understanding is correct, IMHO it should be [2] above that
> makes sure the reference won't happen on a swap entry, not necessarily [1=
]?

Yes, in case of migration entry this is what protects us.

>
> > split_huge_pmd() will bail out inside split_huge_pmd_locked() with no
> > indication that split did not happen. Afterwards we will retry
>
> So we're talking about the case where it's a swap pmd entry, right?

Hmm, my understanding is that it's being treated as a swap entry but
in reality is not. I thought THPs are always split before they get
swapped, no?

> Could you elaborate why the split would fail?

Just looking at the code, split_huge_pmd_locked() checks for
(pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd)).
pmd_trans_huge() is false if !pmd_present() and it's not a migration
entry, so __split_huge_pmd_locked() will be skipped.

>  AFAIU, split_huge_pmd_locked()
> should still work for a migration pmd entry.

That is correct because the above mentioned is_pmd_migration_entry()
check will pass.

>
> Thanks,
>
> > thinking that PMD got split and leaving further remapping to
> > move_pages_pte() (see the comment before "continue"). I think in this
> > case it will end up in the same path again instead (infinite loop). I
> > didn't test this but from the code I think that's what would happen.
> > Does that make sense?
> >
> > >
> > > And it also looks applicable to also drop the "else" later, because i=
n "if
> > > (ptl)" it cannot hit pmd_none().
> > >
> > > Thanks,
> > >
> > > --
> > > Peter Xu
> > >
> >
>
> --
> Peter Xu
>

