Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6742EC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 17:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58126B0088; Fri,  1 Aug 2025 13:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A9D6B0089; Fri,  1 Aug 2025 13:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7806B008A; Fri,  1 Aug 2025 13:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADEC36B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:45:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27F6116020B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:45:25 +0000 (UTC)
X-FDA: 83728915410.26.87305CA
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 427D114000A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:45:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GHOfpoSI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754070323; a=rsa-sha256;
	cv=none;
	b=1XcVFkbKwtt7JZ5jG9qKO8z32YJvo41mz1Xf43CUFq9vPzj1GwbAmvk75Ta1fkS+4ZUPNu
	7JN8hPr8n3yI3YM36+7Z3RvqPLtNtclzwibG3csdPafa2ZvT9erLz8X/Byj9JiO5COLI+w
	OBucVzqVpLqEqg7S1NzkAttBCLC3B7Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GHOfpoSI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754070323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7IQTebdaJ3TqvzAA9sQ8hmg2eU6dzDaIHSRdOARha0=;
	b=LrkjJzGxNARScZf5Kb5gwCJ9DEIaXGbLJ46g6TOooxERZI3nO2ZJkdyj456I90LDXbJucj
	zKt0lkJDUKj8aSm4nsYpKy0CjEP0PNr5Npx5m8S+GmTlGsjrV8c4S1E7KRxVSKkDt1B8+v
	9YLSsbvTV8guuc+Yh3NvObagqSc+U84=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso31301cf.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 10:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754070322; x=1754675122; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7IQTebdaJ3TqvzAA9sQ8hmg2eU6dzDaIHSRdOARha0=;
        b=GHOfpoSIbm5UXcJ6tfLJJyGXOMrJ21jQMCjTEFLbQ8jtZpO0+/h+5yj19fLP5kcx9W
         HAGCuOCdc+E0HVo5jyof8oxg8IW049JQArBzsefVDTGrF2Dl9oIhb0SxtWJIhsuzViyK
         T0bqNctlZphfjtMABOI9L7tN1hEYTm507LhyHnEcsVk4L4zXkbpqXSjGbhc8VxC0OWc7
         /gsj4nXLyW9L8QL5++u37rDpx2rj/+aMF5Jde1VqnB1RJ9dTMtyXUnMoTOOJBHnkhah7
         sm8HIAB5N1uaOc+1R6uMLGScA2ViR5mYIvVLFvxWTlNbN2r6PVCG7FL25qYQ5CE4bNb4
         gjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754070322; x=1754675122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i7IQTebdaJ3TqvzAA9sQ8hmg2eU6dzDaIHSRdOARha0=;
        b=XGDcWOPiDqaFphYJnppnXQXBLTmtGMGPe5sCFRGgtRtzZZIZ40Obe/uomfF11efk1a
         wGr9xC0ECla7qvRW2mQZmfLx4hKQLjFt0gyiUhBK76JiOpzd0vrABlEU1tam/XRG6Cg7
         t/OxxCGJqd+nJPd2tvcK9OC29AWebyda8oFBKzEpBA/ykXXVJK5mdGhD3/23zU9ofCsf
         MFBXdYQrBCLr1ZvhFUe+mpEIxCC8ypFKDZ0I8g/78bMEDJbVmvo4Pgr9SD3orwi5YP3w
         7/gylAaGkRS3DuMEsGtOj4o6owKZ4gFYlqwY7j0DxKZZou02FATiRGfAk+Pomh5AR7+l
         ttaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGpPLhrrlxU/FrATzZOIdHz4Xb+sTl93uB1ao9ur18PFYsACQC0NG6lSwEzlN0Jq+wSV0vYNKP5w==@kvack.org
X-Gm-Message-State: AOJu0YzEXYI4ILJUyFU/m2RxvO0jufFVrnxUJyyFi7c856cCK24WzE6Z
	UB7bWVI4UmYSTxeWLWg/QJk8SRO30VHR3JFxv6tKVYowVajFO5OcHarHodlclcql89HVpH5vufw
	JsBhrC7HpzVg+Jsx9+BFzbc3/BBYehdkoAr0nDTiZ
X-Gm-Gg: ASbGncvjQxej6avrdtkM5/57I5fbh9SYw12wT8/Zv4XNdoSd+8jMPow8RpdK8OZ38QQ
	1gk6nTmSKpdEbHWpN2U1CvNa3Eg9o9MTPwQo3/do/80IJewHR/liXq/Ffq0ZvsM3RKXpr6wWQ+d
	F3YFP3LN6rwu01PbOsnljYsxtSZKnznv4TL2pBq2mYfyvHYPd1ebrmUUkd+uEA4s5Z0ccgcruKN
	Az1t7M2mQfwJG+U0Yz3f/uG0kAW5g0JmWQ=
X-Google-Smtp-Source: AGHT+IE7jTp06+1/B/HvPXKXnzSMflRllAiRRQS5xDxthQyL5W90KUUmbib79VXEYr+Tf3jInm1VMds+8WcQQgIzQnA=
X-Received: by 2002:a05:622a:164b:b0:4a9:a4ef:35c2 with SMTP id
 d75a77b69052e-4af00895293mr5522311cf.23.1754070321651; Fri, 01 Aug 2025
 10:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250731154442.319568-1-surenb@google.com> <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
 <aIzMGlrR1SL5Y_Gp@x1.local> <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
 <aIzp6WqdzhomPhhf@x1.local> <CAJuCfpGWLnu+r2wvY2Egy2ESPD=tAVvfVvAKXUv1b+Z0hweeJg@mail.gmail.com>
 <aIz1xrzBc2Spa2OH@x1.local>
In-Reply-To: <aIz1xrzBc2Spa2OH@x1.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 1 Aug 2025 17:45:10 +0000
X-Gm-Features: Ac12FXwZOx_WXSa-qtibQWiRqYk9c7J105y71GpiIr-2l8CCMOLx2rXPFV1awyg
Message-ID: <CAJuCfpFJGaDaFyNLa3JsVh19NWLGNGo1ebC_ijGTgPGNyfUFig@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 427D114000A
X-Stat-Signature: i14uanktqfm1iqigp6ufwditestx8rnt
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754070323-790211
X-HE-Meta: U2FsdGVkX1+P+WibKhgIyLr0dwvD6aG9b/s/paOHiun7i9vgjNDTBhk5Iehnrs8ttrpSwb6SE7E9GStiJ3n998xfctesGxtaQ4Mcowt74s+n4FIrDjOEa1f1M+JpRR9r1FHFikAAX/2xc0R3FhJ6Q6YmssVwvfGuk8YTbk9Vr2TXynJU4bSDzRVWcGoywGjyvCOS08253X1FKdiuEpQj9YocxveDLr7XaB9rXZS2R9AD6gp1Qn9nu/oybyG7Lgt4Eo8SPwB3sI7MUrWHC35zGu/OvWf+cVL88hwJM0l09GUTe5IVVT6SCNn1qpT4VksQVUEyUJ8laSfUilGuzcpFD4iWecYDmPCFBOlZtJQvgNLBqTklKqSKd/WicZP7Wr2QkE+PLpQdtCcHQNDr25ye04ctEkQmyVoHo2z3Irau0/GhZxAiLaqc9qq4xitlbBVY391u8mUC3srj2U44eapPzx4TcBclt6g3+IoZvv3puJ9zhJ9GfLzXY+Neaeo6Exu7ZapCGQos790glaHH3LqS+hhzbkwWp2fVwywMENKxGpL2+yhGcBDpyGefEyDDHwh4WTvjwfU7dtf5nKg84B+GIvM1yhZYyxKzpt8m/7QWWnOZbwEJDvGrBN4pEqTWcXxvl1kMj9cCrn/0UnY+IFgvw3N7GYE6nYAGaUV2s4alETMEme2uWlLLi34bSs/kMuX7haBkh4AmIm4vCY6s/oFO84xXhP6RV6RLPh+vjXwnLMqB4lvYJlDSAAHPHSM19b6guxyuetJxkowxZpAjlR/6E64OUroruIyVE8GmO1Q9tn0XykyGGnpWEdyzQzWQ4MaG2XjAPyq3n4r2qr3rMN9MlKPDPCVbwVb92XBaBPOuVrAo0MJ5vzDJSSWQiJmbC5NtCIM+LGNeyqUdNbTJjbC3lo0uTdIHzT9Ce+pHUafEb8N2srVcuFq0oLZIwHbynVbaTnGMelk8ZUK4QzI8NHc
 TH8eCZqE
 oh0HhW7XnUAwqc+W3/ADCuoQSed9Y3HEh0l8+ZEngHzXBgk5HOwAxMOpDUC9PcciF9jai8a8VN7olPm3AjFw9lodohOobR16ZEuyMTWdNAUIgH+h9EE1b/PLYXFacILGlOTI9nk7FNcMScfqfx/tgtVGgvOQ+PlpjwWZ2sv0ZOifox5r+3jPeMagq09AbSoNTTs5bgfNeOH2zSd2jORDU56K20xjwYoFfInp/f2bAKjcKsrDWmxcNz1Yrbzy4kF9TGt0XXM9ydbmJJV02AUaUSamq0TbwzwnERzMoFInhiHyp08crnEO9kg0+9OQOkSDPFbnPJloIcv7bRY3rXVzO7tA8D5pD856VXsAtjWDXu8n6mas2qI9MnbPNaNRtskOsZtMrl1i2GzfRA+OsEuMMOr13VcNdf7dt6bzBBcb05BWmwaA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 5:13=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Aug 01, 2025 at 09:41:31AM -0700, Suren Baghdasaryan wrote:
> > On Fri, Aug 1, 2025 at 9:23=E2=80=AFAM Peter Xu <peterx@redhat.com> wro=
te:
> > >
> > > On Fri, Aug 01, 2025 at 08:28:38AM -0700, Suren Baghdasaryan wrote:
> > > > On Fri, Aug 1, 2025 at 7:16=E2=80=AFAM Peter Xu <peterx@redhat.com>=
 wrote:
> > > > >
> > > > > On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hildenbrand wrote=
:
> > > > > > On 31.07.25 17:44, Suren Baghdasaryan wrote:
> > > > > >
> > > > > > Hi!
> > > > > >
> > > > > > Did you mean in you patch description:
> > > > > >
> > > > > > "userfaultfd: fix a crash in UFFDIO_MOVE with some non-present =
PMDs"
> > > > > >
> > > > > > Talking about THP holes is very very confusing.
> > > > > >
> > > > > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLE=
S and it
> > > > > > > encounters a non-present THP, it fails to properly recognize =
an unmapped
> > > > > >
> > > > > > You mean a "non-present PMD that is not a migration entry".
> > > > > >
> > > > > > > hole and tries to access a non-existent folio, resulting in
> > > > > > > a crash. Add a check to skip non-present THPs.
> > > > > >
> > > > > > That makes sense. The code we have after this patch is rather c=
omplicated
> > > > > > and hard to read.
> > > > > >
> > > > > > >
> > > > > > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > > > > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmai=
l.com
> > > > > > > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0=
050.GAE@google.com/
> > > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > ---
> > > > > > > Changes since v1 [1]
> > > > > > > - Fixed step size calculation, per Lokesh Gidra
> > > > > > > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, p=
er Lokesh Gidra
> > > > > > >
> > > > > > > [1] https://lore.kernel.org/all/20250730170733.3829267-1-sure=
nb@google.com/
> > > > > > >
> > > > > > >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++--------=
--------
> > > > > > >   1 file changed, 29 insertions(+), 16 deletions(-)
> > > > > > >
> > > > > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > > > > index cbed91b09640..b5af31c22731 100644
> > > > > > > --- a/mm/userfaultfd.c
> > > > > > > +++ b/mm/userfaultfd.c
> > > > > > > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd=
_ctx *ctx, unsigned long dst_start,
> > > > > > >             ptl =3D pmd_trans_huge_lock(src_pmd, src_vma);
> > > > > > >             if (ptl) {
> > > > > > > -                   /* Check if we can move the pmd without s=
plitting it. */
> > > > > > > -                   if (move_splits_huge_pmd(dst_addr, src_ad=
dr, src_start + len) ||
> > > > > > > -                       !pmd_none(dst_pmdval)) {
> > > > > > > -                           struct folio *folio =3D pmd_folio=
(*src_pmd);
> > > > > > > +                   if (pmd_present(*src_pmd) || is_pmd_migra=
tion_entry(*src_pmd)) {
> > > > >
> > > > > [1]
> > > > >
> > > > > > > +                           /* Check if we can move the pmd w=
ithout splitting it. */
> > > > > > > +                           if (move_splits_huge_pmd(dst_addr=
, src_addr, src_start + len) ||
> > > > > > > +                               !pmd_none(dst_pmdval)) {
> > > > > > > +                                   if (pmd_present(*src_pmd)=
) {
> > >
> > > [2]
> > >
> > > > > > > +                                           struct folio *fol=
io =3D pmd_folio(*src_pmd);
> > >
> > > [3]
> > >
> > > > > > > +
> > > > > > > +                                           if (!folio || (!i=
s_huge_zero_folio(folio) &&
> > > > > > > +                                                          !P=
ageAnonExclusive(&folio->page))) {
> > > > > > > +                                                   spin_unlo=
ck(ptl);
> > > > > > > +                                                   err =3D -=
EBUSY;
> > > > > > > +                                                   break;
> > > > > > > +                                           }
> > > > > > > +                                   }
> > > > > >
> > > > > > ... in particular that. Is there some way to make this code sim=
pler / easier
> > > > > > to read? Like moving that whole last folio-check thingy into a =
helper?
> > > > >
> > > > > One question might be relevant is, whether the check above [1] ca=
n be
> > > > > dropped.
> > > > >
> > > > > The thing is __pmd_trans_huge_lock() does double check the pmd to=
 be !none
> > > > > before returning the ptl.  I didn't follow closely on the recent =
changes on
> > > > > mm side on possible new pmd swap entries, if migration is the onl=
y possible
> > > > > one then it looks like [1] can be avoided.
> > > >
> > > > Hi Peter,
> > > > is_swap_pmd() check in __pmd_trans_huge_lock() allows for (!pmd_non=
e()
> > > > && !pmd_present()) PMD to pass and that's when this crash is hit.
> > >
> > > First for all, thanks for looking into the issue with Lokesh; I am st=
ill
> > > catching up with emails after taking weeks off.
> > >
> > > I didn't yet read into the syzbot report, but I thought the bug was a=
bout
> > > referencing the folio on top of a swap entry after reading your curre=
nt
> > > patch, which has:
> > >
> > >         if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len)=
 ||
> > >             !pmd_none(dst_pmdval)) {
> > >                 struct folio *folio =3D pmd_folio(*src_pmd); <----
> > >
> > > Here looks like *src_pmd can be a migration entry. Is my understandin=
g
> > > correct?
> >
> > Correct.
> >
> > >
> > > > If we drop the check at [1] then the path that takes us to
> > >
> > > If my above understanding is correct, IMHO it should be [2] above tha=
t
> > > makes sure the reference won't happen on a swap entry, not necessaril=
y [1]?
> >
> > Yes, in case of migration entry this is what protects us.
> >
> > >
> > > > split_huge_pmd() will bail out inside split_huge_pmd_locked() with =
no
> > > > indication that split did not happen. Afterwards we will retry
> > >
> > > So we're talking about the case where it's a swap pmd entry, right?
> >
> > Hmm, my understanding is that it's being treated as a swap entry but
> > in reality is not. I thought THPs are always split before they get
> > swapped, no?
>
> Yes they should be split, afaiu.
>
> >
> > > Could you elaborate why the split would fail?
> >
> > Just looking at the code, split_huge_pmd_locked() checks for
> > (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd)).
> > pmd_trans_huge() is false if !pmd_present() and it's not a migration
> > entry, so __split_huge_pmd_locked() will be skipped.
>
> Here might be the major part of where confusion came from: I thought it
> must be a migration pmd entry to hit the issue, so it's not?
>
> I checked the code just now:
>
> __handle_mm_fault:
>                 if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
>                         VM_BUG_ON(thp_migration_supported() &&
>                                           !is_pmd_migration_entry(vmf.ori=
g_pmd));
>
> So IIUC pmd migration entry is still the only possible way to have a swap
> entry.  It doesn't look like we have "real" swap entries for PMD (which c=
an
> further points to some swapfiles)?

Correct. AFAIU here we stumble on a pmd entry which was allocated but
never populated.

>
> --
> Peter Xu
>

