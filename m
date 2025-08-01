Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30436C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 15:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2B626B008A; Fri,  1 Aug 2025 11:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02FB6B008C; Fri,  1 Aug 2025 11:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918296B0092; Fri,  1 Aug 2025 11:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 814956B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:28:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDF771342B8
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:28:52 +0000 (UTC)
X-FDA: 83728571304.10.EAF4C57
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1E9E4C000E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:28:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ylBjNT0u;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754062131; a=rsa-sha256;
	cv=none;
	b=M/+akLTwIGGNVfWrKK8fy7/E644CMraGihOMyQUjVvm5gVztI2T1hj5OYRIugd769Os2sz
	QQ6KYHSk+rjJYHjlmnPEV5lDn4kwSjin4V3z/9G3YZoCQHDvfFjl6QekwW8AO4hhMLrr4U
	kDrV6cPPaXfoC55vovnw1M8d68SkVVc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ylBjNT0u;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754062131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKUaz7EOc6pAVsIf46qg1U45YzHIMBuAGqpgh/8GvhQ=;
	b=fgQIXmmW2CQJgdoNUVTWRnwPUl7AkQ2INXw88tF7v36m0EvuIBKMDB/ZS+Spvb+XF4bxRO
	/wdHQgphyusdAPioT5QjC0JyWVkNoIjZJeLFnfv5hU+xFGvcFId6gWJcC7eo5eDz3KEkTb
	gAdOQ/DBIOESah8aILtXorryWxtNOEc=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4aef56cea5bso192871cf.1
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 08:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754062130; x=1754666930; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AKUaz7EOc6pAVsIf46qg1U45YzHIMBuAGqpgh/8GvhQ=;
        b=ylBjNT0ufNeP8jQzLIWuqnGye+nGHP5KZBOibPe3jC/E9u+r70fWnEWLoI0Vltl6Z0
         BFaoYgAa1svovU11c4BPl+wJzh/2MnUK8UBirPRVDYKR/ySlGMHRx8PgPQxkid/JuMZZ
         Ep/CVII51mGQJQNrixVYiyXILN4zg+Pk/9wxi4HkPGk2NKwqZcoDo3qC09dUbegOkA6y
         xFtJY2YvLx127dmApfgX4K+yPteV4u7H6paKJRD+KNPCW3jHkNO9hlNlJdI49a7PP8Uw
         953TKOzJ0pmJuhHw2noiKq4RHNgIJZfUua9X44OMYhIrHKUY5PluchQnK+MllGDHI4QM
         AcLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754062130; x=1754666930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AKUaz7EOc6pAVsIf46qg1U45YzHIMBuAGqpgh/8GvhQ=;
        b=VfVlsCOkmb/Pj2G4vDkmkHGchpUt8ih7f2NEEzNrsevN5C9J6gClRjn8pJco8H5/5n
         BapPcktEbcv9keShT44SspWDmSSBgs5sKEaUl0+Ru/lZ6iqUXCgfcex9KDYN7UeJz6iN
         yaGQI30CHOw4AEfBCEQva+lkfW3NhBpLsVawO/5Vc2C/TXomJtomx9V6oiPfWKngmWaU
         kqa+ozNrd4MuCz8+7R3RF4lYot8e4qV6DUgiE9jAhOj1b7frBN3/Rgv1RgImcDKL7y/l
         dN6DDyY/DsHUUE+15tKbH70b5GX/UXqKDqv3PuG8UFqPh3kyM9TsYN2tr3xfumjazwRE
         ZL4w==
X-Forwarded-Encrypted: i=1; AJvYcCW51VKovvWVuI0dFO++f3KBJy+AV3q74bygZW3GVW9xDuB6y+5O9XsbVJoYU2oUZ7VIwdrJ1BWBRg==@kvack.org
X-Gm-Message-State: AOJu0Yzj0nHNYUEgZ++Po0XS934CNnuLFct/iyWQ15vKZCE1OGn1dmpS
	XLGIfozDdTjGOVeVMIA5xICqrQB5vvNONiJwMLCuBqZ9gkXQBylf3GfaZfZNYlfDdv4C4Kb4pyj
	QCD9uqzud5c5acUxtNKrvW4Du5F8yFCqpf94F74lceU5EyIHWkElSTXJbpF0=
X-Gm-Gg: ASbGnctZlnOYdxg52eBwIEYd5H8ht8N4sNVUv1g0KMJlO7VD4AKfhB3+FAs9eNE+PSA
	kC8HsdBTeiwzWfta+lmwAU7pnA+irWdkXuWWE7JDd2FBV5QFe2dimUn3IyOF+mEEWcEdK3ZFN7i
	QYocZsIDT85tGfFRXjHtdP2+6YkEiSeOstRaV+NtMhgWGagjPbo6OQTcyDhyOHM6vIxsEZNP4ez
	pnv8hSU03RGB9rvmu2cE6mDxEqRRt4LdQ/olA==
X-Google-Smtp-Source: AGHT+IF+teQNuR14ehmgtvK0of52GqQHhCvAg/4XHVLVi6NVhtxwyDJNIbdEdTYfPwlm7CziAZ1u+5p/EohwBYVT+A8=
X-Received: by 2002:ac8:5a09:0:b0:4a6:907e:61ca with SMTP id
 d75a77b69052e-4aefe562a19mr5749921cf.12.1754062129703; Fri, 01 Aug 2025
 08:28:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250731154442.319568-1-surenb@google.com> <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
 <aIzMGlrR1SL5Y_Gp@x1.local>
In-Reply-To: <aIzMGlrR1SL5Y_Gp@x1.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 1 Aug 2025 08:28:38 -0700
X-Gm-Features: Ac12FXy4jpkgwpCin0s1nae7ReBsAmBb3y90QLsWZVUvuEg44PA4Y4G1UBm27Jc
Message-ID: <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6f4ca5hsgytyn88sn76k7h3qkqzy5prq
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E9E4C000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1754062130-801409
X-HE-Meta: U2FsdGVkX1/7ofSmDANfB8aYOfwHojK+hObDrLMJ41lQmzm3XGeBXSNZDK7k4l4x/jjuRbH0ZhUKpzVB/GkVvwL6aSvQdgArhiWNEM7jGBoUtmf0MolYOoQ+3NwGLtpcgawdze56w/j2vTptkt4lacNyPML6C6t6pm8pwylF8eyI+3RuO01NjeuKksAfgMLMaQsAaw2cFx6rX37cG1O/OyMFIb26P//OAnHz4Zse6ILlyECZRFArbU4H84HOZx19cLHmbxLvjvnjPKdgFuXfk05sL/Gn/cQcy235+Am4BINhKoURLDROcHAIv+2/tAk1wjKqdIcTkeSmc/M8RXGEBHNucQmd/myHK/nF0GVrthtO1MBKOIauoIgmC0jyrn2Dxsv0NuoEb1rnWSDcMFVnJAKlkrylY/FUA5Q45ujsChyWnIKayfdKhz0YjFDT7jGXE2KpdTpOU91mY9RSzGhq4o/T7AHPuDjpxtwyzUpYFHkbrrRJYfQLcWhiysly6qdS0JiO8ZP2MvRXuq13mIWSscnfeBBu99tIX/wRO21Rbsw0fXSspVnXxVkRKD3H9ZsR9cfVjkcVl6J/8QVF8mO1Iu9PFCk02nK7PCtc+gtUU+WhpC6WlgAsIC9qQn5aU2vCBKY1lKafVyS9Ylvs2zG3ePOsIbN8yz4Q0H0UXzqd6xNELeUK/vozl0OScb1VD1JpK0i0N3vkCH0uu3K3UScSoBwIvEDwgUKv36gFqFe4+n4FB415/wBQ2hJH4Hgtus0K6k8KHX6Y/EvCeMZeBfeHgvl46aY6RED++NCoAwtjPq9fQzlsYBsuG4YDkIcE7J40RJeiUE1GcDipe2IuF2jOSjHjjTshme3zc+hae3avFu/d9BPLzPnWVLT4LSYbL79U0teMo+H4Gt+yk6hES7NX4i0OMy1vCTtkCFerJrKQfzgRUxhmndbn08HBp5v8RPNRqB3pDSp9pNz9qPZjEVl
 Muh8AfbQ
 3+363kR5Dl1o1wEe7VVJg2302t3bnHh+592Y6pO3VEU+wN1HP3MkFCxxvKoh7e0LS41+fs5CZRCBKmFfqQ28XlAqSa3/1hXj6gzhMd4tY+qRMiUE5+LrYrus7NqisMvNLOGjdAD4FdwujGbfM8fzQxSIUiwUQOVX2ftpbBIm74RB8AVqR+SU8quBd43V+g8nrU24X7VcXertuEpWMJTdAConi4ze8Kr4nnmNlcxFO4TJ9tnTrYwGqSE/J0G1HKrJ3awxjA9Hnsxy0NLxr3twFzczOvK+71HC05w+DT7iNNXlMX46V93yk2rICLJ0TUeknT11i/u6Vnl4KoaqofrgaVvNyF2fDZoWSBkQIZaC2E+iKT2HkNnw6+VL+4Ifst6BGGk7ooCyjn5LK3j2netwtJ96itJH82PqKz0qeMDxaKd40djQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 7:16=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hildenbrand wrote:
> > On 31.07.25 17:44, Suren Baghdasaryan wrote:
> >
> > Hi!
> >
> > Did you mean in you patch description:
> >
> > "userfaultfd: fix a crash in UFFDIO_MOVE with some non-present PMDs"
> >
> > Talking about THP holes is very very confusing.
> >
> > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> > > encounters a non-present THP, it fails to properly recognize an unmap=
ped
> >
> > You mean a "non-present PMD that is not a migration entry".
> >
> > > hole and tries to access a non-existent folio, resulting in
> > > a crash. Add a check to skip non-present THPs.
> >
> > That makes sense. The code we have after this patch is rather complicat=
ed
> > and hard to read.
> >
> > >
> > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@=
google.com/
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > > Changes since v1 [1]
> > > - Fixed step size calculation, per Lokesh Gidra
> > > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, per Lokes=
h Gidra
> > >
> > > [1] https://lore.kernel.org/all/20250730170733.3829267-1-surenb@googl=
e.com/
> > >
> > >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++----------------
> > >   1 file changed, 29 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > index cbed91b09640..b5af31c22731 100644
> > > --- a/mm/userfaultfd.c
> > > +++ b/mm/userfaultfd.c
> > > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd_ctx *ct=
x, unsigned long dst_start,
> > >             ptl =3D pmd_trans_huge_lock(src_pmd, src_vma);
> > >             if (ptl) {
> > > -                   /* Check if we can move the pmd without splitting=
 it. */
> > > -                   if (move_splits_huge_pmd(dst_addr, src_addr, src_=
start + len) ||
> > > -                       !pmd_none(dst_pmdval)) {
> > > -                           struct folio *folio =3D pmd_folio(*src_pm=
d);
> > > +                   if (pmd_present(*src_pmd) || is_pmd_migration_ent=
ry(*src_pmd)) {
>
> [1]
>
> > > +                           /* Check if we can move the pmd without s=
plitting it. */
> > > +                           if (move_splits_huge_pmd(dst_addr, src_ad=
dr, src_start + len) ||
> > > +                               !pmd_none(dst_pmdval)) {
> > > +                                   if (pmd_present(*src_pmd)) {
> > > +                                           struct folio *folio =3D p=
md_folio(*src_pmd);
> > > +
> > > +                                           if (!folio || (!is_huge_z=
ero_folio(folio) &&
> > > +                                                          !PageAnonE=
xclusive(&folio->page))) {
> > > +                                                   spin_unlock(ptl);
> > > +                                                   err =3D -EBUSY;
> > > +                                                   break;
> > > +                                           }
> > > +                                   }
> >
> > ... in particular that. Is there some way to make this code simpler / e=
asier
> > to read? Like moving that whole last folio-check thingy into a helper?
>
> One question might be relevant is, whether the check above [1] can be
> dropped.
>
> The thing is __pmd_trans_huge_lock() does double check the pmd to be !non=
e
> before returning the ptl.  I didn't follow closely on the recent changes =
on
> mm side on possible new pmd swap entries, if migration is the only possib=
le
> one then it looks like [1] can be avoided.

Hi Peter,
is_swap_pmd() check in __pmd_trans_huge_lock() allows for (!pmd_none()
&& !pmd_present()) PMD to pass and that's when this crash is hit.
If we drop the check at [1] then the path that takes us to
split_huge_pmd() will bail out inside split_huge_pmd_locked() with no
indication that split did not happen. Afterwards we will retry
thinking that PMD got split and leaving further remapping to
move_pages_pte() (see the comment before "continue"). I think in this
case it will end up in the same path again instead (infinite loop). I
didn't test this but from the code I think that's what would happen.
Does that make sense?

>
> And it also looks applicable to also drop the "else" later, because in "i=
f
> (ptl)" it cannot hit pmd_none().
>
> Thanks,
>
> --
> Peter Xu
>

