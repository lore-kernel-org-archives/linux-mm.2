Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C602C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 19:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A0C6B008A; Fri,  1 Aug 2025 15:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1EF6B008C; Fri,  1 Aug 2025 15:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7406B0092; Fri,  1 Aug 2025 15:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DADA6B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:30:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0271380409
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:30:17 +0000 (UTC)
X-FDA: 83729179716.02.87E9D95
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1E7A8180005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:30:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VKQN4TB6;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754076616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=twDNEhjIuV3P8FWkQWfYnM6bEXR/NJ1nyF/4WQ2JH/0=;
	b=bt9Q9nXqXiu3krEUwoo9OQn2eDB7kqmruUo58gkqWyfAKN1PKEp5nGkH73bavml3G04JjK
	HKBLwk3OWvEwS84zbDAZGeuUVIk+isiWhjMgbaZlArKxHeA7jpnaopwe49pmOM0QU5b3jz
	SHCGo/q9dM6q2UZ7m3C10+Kxqxi5REM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754076616; a=rsa-sha256;
	cv=none;
	b=LQ8txKu9khlN5huBv4OjzBeJOYiwDLfMuHb6nZUAn0wN0CoYRcJnDOaoKlJZnyQVgZ+SHL
	cwVcFBGN+BFPtqrOTogO4EFiKR+eUi1DYOr96CY2k57aUTKUZLiAsZfJnQb9dkofMnVw/9
	Zl13JvKnbUIxrnT+ksYxfvhsuFTIvpA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VKQN4TB6;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ab86a29c98so57711cf.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 12:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754076615; x=1754681415; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twDNEhjIuV3P8FWkQWfYnM6bEXR/NJ1nyF/4WQ2JH/0=;
        b=VKQN4TB6cyr7DnaIxeSm7zFYyixWzjXhWO4gQwRYwE93eZA3cSwd1SNgNcJgb7QNbd
         cUuMUZLzrehsPKs2kbZfbbHJ23jKcM6zlmUYhCSXTq7JcPIkezNrCfcEWXAwxPogsLKa
         IyCJMgjH8pK1t05coInD9fvJZynYRLpPEk3o8EmUUySBiPEA+GS175O+oCw8ooR3JdMn
         wrlNu04UCNnoC/6wLEAlaEGd1CMn5vyInJfADyA1WL0+JHzU3kay7+bhQ9/ESth2T1tW
         0QH+vHDkZOqmwrsYBLephoSjvGM/5mSknlC+We0MZKwmuI+SJeVuAAOcnTu2onfpLjA/
         ZQcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754076615; x=1754681415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=twDNEhjIuV3P8FWkQWfYnM6bEXR/NJ1nyF/4WQ2JH/0=;
        b=jJtI/bBn2hWgZRpp3VCimt2kp9KzgUOOEtDLCktQQ9TeFXD+gPe4qzBTnlqITbeMT+
         zE7rlKpJbEZMduwTf72dbOplKigVeFTc7dn7T6Gy0HO2+8ekLvP5/v2GWPMvDbyT6XBa
         J3j/nWBKnIUWMB23njEZdTxYqJoVl50Te5PHOdnnBlfluvpy2OWhCsYCtR7zmsDkyupW
         HIyFHEQtfav18oURozn8lDuPdB0Fn06EYy0JDoTc8s4toi18Ew0SIyc1E9i4wyADj5LW
         dLy9yaO347LmMgZF1ZsIaTUX8qbs0mWNOAIZEvKPW3BGYlPfiG+fi59UVQfLfvJU3o5/
         dQGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMutZImhu0VBBWO/1Ttz+2nwOSI272q0NPyU32s7vP+0YVtkkr8JEa+ms0Pt3E68mSxR57d46MOA==@kvack.org
X-Gm-Message-State: AOJu0YxMfBQe5xU+flZGBx/IAEZXrfx2Yaq5GxYtJdaMWI+obeF2gl1d
	PpgS3moftdbrnVhAWitsvgZ5x05zgcyakGocuOL4eeO9JX1eRzVXuobZYzytQjWWLWujrqgHruP
	bQ9+FVLbGeVDnP+aChpVMbzB3Gpu6ayrA6UhxroFO
X-Gm-Gg: ASbGnct9AB6cygg3VC9GSkPuDeomjxKGTju9KN7WFd2Ya/RhXCXbGPOkNBLH+1mmCo8
	batKFj9EjnaA3M+geo/BuGtHnc197j2xB3Bna0l3zO0n+9tP4nedaTjE77JBxm878Sueu1/kxyP
	VuHf9Xx13/GKdcPTBoXYNrK6QGCSadxDYo9s4npmmelighpv5f3PUhWH1QnHotWuBsMQxbdyKgp
	8dkhuZ8iFV1xYE40pUMuMgUB7tK0wIxlU8=
X-Google-Smtp-Source: AGHT+IGJz6lFXVxVdLxtOYGPbfOs+p+cwbfDc9Hr4tq8znJjmVLXS2URnxtlM7GxjpvFbqbJihK6yqO34DNYKLHSJ4U=
X-Received: by 2002:ac8:5d49:0:b0:4ae:e478:268d with SMTP id
 d75a77b69052e-4af13199dd2mr477631cf.5.1754076614621; Fri, 01 Aug 2025
 12:30:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250731154442.319568-1-surenb@google.com> <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
 <aIzMGlrR1SL5Y_Gp@x1.local> <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
 <aIzp6WqdzhomPhhf@x1.local> <CAJuCfpGWLnu+r2wvY2Egy2ESPD=tAVvfVvAKXUv1b+Z0hweeJg@mail.gmail.com>
 <aIz1xrzBc2Spa2OH@x1.local> <CAJuCfpFJGaDaFyNLa3JsVh19NWLGNGo1ebC_ijGTgPGNyfUFig@mail.gmail.com>
 <aI0Ffc9WXeU2X71O@x1.local>
In-Reply-To: <aI0Ffc9WXeU2X71O@x1.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 1 Aug 2025 19:30:02 +0000
X-Gm-Features: Ac12FXwqbmtzOOF0OpEWd-6TjRB4swEi2Z6oN7xIU_JaZp9vQNVpQvwwBAnRsUI
Message-ID: <CAJuCfpFSY3fDH36dabS=nGzasZJ6FtQ_jv79eFWVZrEWRMMTiQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1E7A8180005
X-Stat-Signature: 8apcjs4cx75pr4a5sqegsttuzfbntawa
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754076615-37934
X-HE-Meta: U2FsdGVkX1/CNJSFxL2PeszHs/IXaNIFXsto3CYegLw25upmdM5sTXUZBvxFondFE4KT6HZn3tm6SxyMbjeao15Usj9UEhZM5yJbb0lqGG1vwg87ZdqWYcsg1QqQ0q5e/5/6OfGMo64gT/yRqb8X0G34mlNbFE+vJV0/5FUrdGd3eaNwJFQVtiGNi2EsrpO7LZ+unBd2YAlnNhgAc2DZFcUrR9K6ctM3PMl20tSmhqRy2UKr4XMp4C/pVQfW+5N1qzB1f/t0Ey/GE8ST1Hoh1pY+zdwCkfXHq0hob6fx/0so2CeJswDgO1kI3eJTclgk9JSAXj5wS7CpD+H8nuwM/wJeZSurITPmAVDyb3HHk2ClhZcO00vtn9acAqGTs48Q3xmyIKRDCcdyXQS7/o6Zkh8K+AVIRAcx2J+33xfkd426xlQj9QZUH4e4YGyzr5aD1kZveXlYDOhNRxfuX0/H6CsRMYWgaECwj1LmgPWTbYSoxFHMA7PqqCRt+ug9XqRzPHAKCmzkhb07jmTCV2EZdNvROdYdqKH35eOS8L65hC6g2QUU+3RrUUAU2jhnbJiUK1S60Y3O/SlWd+07wT9rd9nFRn7mwd3q14ooLlNaiDCdZmzw8Is7RPh9xHeif8KShPamK6410pBQ6J90DVyKLvtHYmxlp14eslq8LqD+Z4lnMdLLYuFYjlw2YauVKxFYHuB8JloIzj1eiD2VeH8p1jphjLehkXo8ldYA63vgSA5JOoBEHtdzZGUOYo56vrkXgCHnGedgoCcPZ5PtSV+gZcFojpCQieTLoebPRhfpciVYQFVETF09H2Lzh8q3EfR7YP0H2swOLJeiTch1jyRPFk4mT5EM+ksW0CMJuUQycAv9yaxLOefBWMLzxzDVtEbCL0ZkKYX06imCf//R+Ogm9VZPrT6vv8zd4bT/5bo8cFQN8Tpvb3zWvWLOOGJicFKZuz1RrExwyi8F6ISqwS4
 kThObroN
 rJSn9U0EKX1sVa4UgxgijzEx8fUYhbiWmyNUjKhbBT6s5bJ3OtoEPv2y1die1MgcLGTUz7Z/3BhHNvJl+uzp5Dq7eY8UI3B+119zbvMXfPK0aysXxXZY0MzT0CvMQpRcWeSTL8VkqvJqJL4n0Jq/AAiBZOp3O+Pu7xLn3Cwa0yOCDmgD11rneI4N2A7+c2vwItcoXRGzKXbkWURdnEbcQJWQtQrrBno/p8nrnoRU2gmPYQ5Z4vdGT6jGopBM1YxEzVy9qRVCksRdclyofUhAqL/PTYZ/+BjxIfWpK6NuBzuox12/+rHQSYZj2d2SwQnEh0Hz4Hq2x6BV2leGgqaufyOWQq0KGXWBpCdorQt/5HSd4U4ioUHRtQt7QN1dGBjwhDFx9b601KrHalzZqVjjjA7kNGNaDDSjr7jJMCawx2bZbnLE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 6:21=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Aug 01, 2025 at 05:45:10PM +0000, Suren Baghdasaryan wrote:
> > On Fri, Aug 1, 2025 at 5:13=E2=80=AFPM Peter Xu <peterx@redhat.com> wro=
te:
> > >
> > > On Fri, Aug 01, 2025 at 09:41:31AM -0700, Suren Baghdasaryan wrote:
> > > > On Fri, Aug 1, 2025 at 9:23=E2=80=AFAM Peter Xu <peterx@redhat.com>=
 wrote:
> > > > >
> > > > > On Fri, Aug 01, 2025 at 08:28:38AM -0700, Suren Baghdasaryan wrot=
e:
> > > > > > On Fri, Aug 1, 2025 at 7:16=E2=80=AFAM Peter Xu <peterx@redhat.=
com> wrote:
> > > > > > >
> > > > > > > On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hildenbrand w=
rote:
> > > > > > > > On 31.07.25 17:44, Suren Baghdasaryan wrote:
> > > > > > > >
> > > > > > > > Hi!
> > > > > > > >
> > > > > > > > Did you mean in you patch description:
> > > > > > > >
> > > > > > > > "userfaultfd: fix a crash in UFFDIO_MOVE with some non-pres=
ent PMDs"
> > > > > > > >
> > > > > > > > Talking about THP holes is very very confusing.
> > > > > > > >
> > > > > > > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_=
HOLES and it
> > > > > > > > > encounters a non-present THP, it fails to properly recogn=
ize an unmapped
> > > > > > > >
> > > > > > > > You mean a "non-present PMD that is not a migration entry".
> > > > > > > >
> > > > > > > > > hole and tries to access a non-existent folio, resulting =
in
> > > > > > > > > a crash. Add a check to skip non-present THPs.
> > > > > > > >
> > > > > > > > That makes sense. The code we have after this patch is rath=
er complicated
> > > > > > > > and hard to read.
> > > > > > > >
> > > > > > > > >
> > > > > > > > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > > > > > > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspo=
tmail.com
> > > > > > > > > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693=
ce.0050.GAE@google.com/
> > > > > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > > ---
> > > > > > > > > Changes since v1 [1]
> > > > > > > > > - Fixed step size calculation, per Lokesh Gidra
> > > > > > > > > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLE=
S, per Lokesh Gidra
> > > > > > > > >
> > > > > > > > > [1] https://lore.kernel.org/all/20250730170733.3829267-1-=
surenb@google.com/
> > > > > > > > >
> > > > > > > > >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++----=
------------
> > > > > > > > >   1 file changed, 29 insertions(+), 16 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > > > > > > index cbed91b09640..b5af31c22731 100644
> > > > > > > > > --- a/mm/userfaultfd.c
> > > > > > > > > +++ b/mm/userfaultfd.c
> > > > > > > > > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfau=
ltfd_ctx *ctx, unsigned long dst_start,
> > > > > > > > >             ptl =3D pmd_trans_huge_lock(src_pmd, src_vma)=
;
> > > > > > > > >             if (ptl) {
> > > > > > > > > -                   /* Check if we can move the pmd witho=
ut splitting it. */
> > > > > > > > > -                   if (move_splits_huge_pmd(dst_addr, sr=
c_addr, src_start + len) ||
> > > > > > > > > -                       !pmd_none(dst_pmdval)) {
> > > > > > > > > -                           struct folio *folio =3D pmd_f=
olio(*src_pmd);
> > > > > > > > > +                   if (pmd_present(*src_pmd) || is_pmd_m=
igration_entry(*src_pmd)) {
> > > > > > >
> > > > > > > [1]
> > > > > > >
> > > > > > > > > +                           /* Check if we can move the p=
md without splitting it. */
> > > > > > > > > +                           if (move_splits_huge_pmd(dst_=
addr, src_addr, src_start + len) ||
> > > > > > > > > +                               !pmd_none(dst_pmdval)) {
> > > > > > > > > +                                   if (pmd_present(*src_=
pmd)) {
> > > > >
> > > > > [2]
> > > > >
> > > > > > > > > +                                           struct folio =
*folio =3D pmd_folio(*src_pmd);
> > > > >
> > > > > [3]
> > > > >
> > > > > > > > > +
> > > > > > > > > +                                           if (!folio ||=
 (!is_huge_zero_folio(folio) &&
> > > > > > > > > +                                                        =
  !PageAnonExclusive(&folio->page))) {
> > > > > > > > > +                                                   spin_=
unlock(ptl);
> > > > > > > > > +                                                   err =
=3D -EBUSY;
> > > > > > > > > +                                                   break=
;
> > > > > > > > > +                                           }
> > > > > > > > > +                                   }
> > > > > > > >
> > > > > > > > ... in particular that. Is there some way to make this code=
 simpler / easier
> > > > > > > > to read? Like moving that whole last folio-check thingy int=
o a helper?
> > > > > > >
> > > > > > > One question might be relevant is, whether the check above [1=
] can be
> > > > > > > dropped.
> > > > > > >
> > > > > > > The thing is __pmd_trans_huge_lock() does double check the pm=
d to be !none
> > > > > > > before returning the ptl.  I didn't follow closely on the rec=
ent changes on
> > > > > > > mm side on possible new pmd swap entries, if migration is the=
 only possible
> > > > > > > one then it looks like [1] can be avoided.
> > > > > >
> > > > > > Hi Peter,
> > > > > > is_swap_pmd() check in __pmd_trans_huge_lock() allows for (!pmd=
_none()
> > > > > > && !pmd_present()) PMD to pass and that's when this crash is hi=
t.
> > > > >
> > > > > First for all, thanks for looking into the issue with Lokesh; I a=
m still
> > > > > catching up with emails after taking weeks off.
> > > > >
> > > > > I didn't yet read into the syzbot report, but I thought the bug w=
as about
> > > > > referencing the folio on top of a swap entry after reading your c=
urrent
> > > > > patch, which has:
> > > > >
> > > > >         if (move_splits_huge_pmd(dst_addr, src_addr, src_start + =
len) ||
> > > > >             !pmd_none(dst_pmdval)) {
> > > > >                 struct folio *folio =3D pmd_folio(*src_pmd); <---=
-
> > > > >
> > > > > Here looks like *src_pmd can be a migration entry. Is my understa=
nding
> > > > > correct?
> > > >
> > > > Correct.
> > > >
> > > > >
> > > > > > If we drop the check at [1] then the path that takes us to
> > > > >
> > > > > If my above understanding is correct, IMHO it should be [2] above=
 that
> > > > > makes sure the reference won't happen on a swap entry, not necess=
arily [1]?
> > > >
> > > > Yes, in case of migration entry this is what protects us.
> > > >
> > > > >
> > > > > > split_huge_pmd() will bail out inside split_huge_pmd_locked() w=
ith no
> > > > > > indication that split did not happen. Afterwards we will retry
> > > > >
> > > > > So we're talking about the case where it's a swap pmd entry, righ=
t?
> > > >
> > > > Hmm, my understanding is that it's being treated as a swap entry bu=
t
> > > > in reality is not. I thought THPs are always split before they get
> > > > swapped, no?
> > >
> > > Yes they should be split, afaiu.
> > >
> > > >
> > > > > Could you elaborate why the split would fail?
> > > >
> > > > Just looking at the code, split_huge_pmd_locked() checks for
> > > > (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd)).
> > > > pmd_trans_huge() is false if !pmd_present() and it's not a migratio=
n
> > > > entry, so __split_huge_pmd_locked() will be skipped.
> > >
> > > Here might be the major part of where confusion came from: I thought =
it
> > > must be a migration pmd entry to hit the issue, so it's not?
> > >
> > > I checked the code just now:
> > >
> > > __handle_mm_fault:
> > >                 if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
> > >                         VM_BUG_ON(thp_migration_supported() &&
> > >                                           !is_pmd_migration_entry(vmf=
.orig_pmd));
> > >
> > > So IIUC pmd migration entry is still the only possible way to have a =
swap
> > > entry.  It doesn't look like we have "real" swap entries for PMD (whi=
ch can
> > > further points to some swapfiles)?
> >
> > Correct. AFAIU here we stumble on a pmd entry which was allocated but
> > never populated.
>
> Do you mean a pmd_none()?

Yes.

>
> If so, that goes back to my original question, on why
> __pmd_trans_huge_lock() returns non-NULL if it's a pmd_none()?  IMHO it
> really should have returned NULL for pmd_none().

That was exactly the answer I gave Lokesh when he theorized about the
cause of this crash but after reproducing it I saw that
pmd_trans_huge_lock() happily returns the PTL as long as PMD is not
pmd_none(). And that's because it passes as is_swap_pmd(). But even if
we change that we still need to implement the code to skip the entire
PMD.

>
> IOW, I still don't understand why below won't already work:
>
> =3D=3D=3D8<=3D=3D=3D
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 52d7d5f144b8e..33e78f52ee9f5 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1880,13 +1880,15 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, u=
nsigned long dst_start,
>                         /* Check if we can move the pmd without splitting=
 it. */
>                         if (move_splits_huge_pmd(dst_addr, src_addr, src_=
start + len) ||
>                             !pmd_none(dst_pmdval)) {
> -                               struct folio *folio =3D pmd_folio(*src_pm=
d);
> -
> -                               if (!folio || (!is_huge_zero_folio(folio)=
 &&
> -                                              !PageAnonExclusive(&folio-=
>page))) {
> -                                       spin_unlock(ptl);
> -                                       err =3D -EBUSY;
> -                                       break;
> +                               if (pmd_present(*src_pmd)) {
> +                                       struct folio *folio =3D pmd_folio=
(*src_pmd);
> +
> +                                       if (!folio || (!is_huge_zero_foli=
o(folio) &&
> +                                                      !PageAnonExclusive=
(&folio->page))) {
> +                                               spin_unlock(ptl);
> +                                               err =3D -EBUSY;
> +                                               break;
> +                                       }
>                                 }
>
>                                 spin_unlock(ptl);
>
> =3D=3D=3D8<=3D=3D=3D
>
> Likely I missed something important..  I'll be afk for a while soon, I'll
> also double check (maybe early next week) on the reproducer.
>
> Thanks,
>
> --
> Peter Xu
>

