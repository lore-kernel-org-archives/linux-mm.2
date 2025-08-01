Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BFAC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 17:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3D16B007B; Fri,  1 Aug 2025 13:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484786B0089; Fri,  1 Aug 2025 13:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372CD6B008A; Fri,  1 Aug 2025 13:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 251146B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:14:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B7C1113E24
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:14:00 +0000 (UTC)
X-FDA: 83728836240.09.8EDE8D6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 512B44000B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:13:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E4bFfPKG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754068438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UapQRB4TdH6jPVjzlLlw/CIcbZ+SS127yBars+dasnY=;
	b=7HapIIaqjA8wjIx3B10obslR2CvT2uOqy45shjZK4rLzygss2yeaq9/rFnSnQvOmpm/ffA
	09z3kGfvK7yxZBh5mlYHxMfGSqQMMWbyCWhu6mkJjrxhGR6cCiaRZUinbqRJxZJmcJnhCR
	Boorc/Ro6zerncVS8l2mzEGxb1k7yRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754068438; a=rsa-sha256;
	cv=none;
	b=kgNW+UKrLkgyMYL7Ah9AuSWwB/rTHNEAEObJCFgS0dFsNRs8b+akvcnqXAWA2Qa2vyGMPg
	PnUrpdcTm+Auibs2gfK5YDEAULx5DeAGnh+b7a17gEHn1PCqJdSN4Y/znCWP1X2VxDriMU
	NvODnj3qGP18mIYex4FXI5EXmDqWkA0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E4bFfPKG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754068437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UapQRB4TdH6jPVjzlLlw/CIcbZ+SS127yBars+dasnY=;
	b=E4bFfPKGADA5XJIVWQDJfLrojC5d6uX81nDf3B5VpmMlLH9zgmLwky9qScNY4l05gIOosj
	S39gQPof8EVukt7EvljDPsAYC0zlxSbbPaMxUcHdxaPmRcZEsE4QCT0lCqJ11qOHKLMwPw
	cnbgxw2yf/DzcUr9OH+kk2OZYh+frxg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-KF_qO0G3MOizA9mCJC99UA-1; Fri, 01 Aug 2025 13:13:56 -0400
X-MC-Unique: KF_qO0G3MOizA9mCJC99UA-1
X-Mimecast-MFC-AGG-ID: KF_qO0G3MOizA9mCJC99UA_1754068436
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ab684d3b55so50821131cf.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 10:13:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754068435; x=1754673235;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UapQRB4TdH6jPVjzlLlw/CIcbZ+SS127yBars+dasnY=;
        b=sLRNSpjfW+dcVfYGrpEOlgKlkDtG7NjvtWfsatk9BmspZAXJeFBw4IwU2sARlmulPm
         CvQUuMwRJKm0+kPQcSh2wLIEpgSmnl1Z0GkH/NmPcOhm3qjDyMrk66q0nD9oU3ZIIcWK
         mX0NrHfxDemym78vbNYyPXaqz1Ng4kPi5lFhtrvUAd5QkkJxoIppu/tOUHuZXHjRcWea
         J7npEjjF9U6UIZke/01kBf+/s0AiTnRigIN+/hE8Jn8LGcN5MkarWgxWtRZkOYrKSduf
         ZVz5vT/gkDXeWu0UBPtCuQ94uKHOH07PA1iCLxSBkAA2p8C1mKSo3oyqQHxOetjx0kBm
         1C3g==
X-Forwarded-Encrypted: i=1; AJvYcCWpg9fKYjQEYD2Wqs2knOrqss/8OUyVMMf4j2YVR41IlKJVops4+23TlMVqkF7iDy0sQDMka/M7Wg==@kvack.org
X-Gm-Message-State: AOJu0Yz05pjySQSJw1P5vxwtWIjjgekhuxoqTCt09PdTPiBx+vytm3PE
	On7gTX1UBVxfpd64e18qE3L+INKTgXDslcOY/yGRrG45uBMde5LnUmpgNxbaM4LX15/QzbSGp08
	mGnhXNCGXvsvV9ZTy53q6AV9pz3Iw+6UuNh2Nj+iCJzRCNB2sNQKx
X-Gm-Gg: ASbGncvlnFxDfz1NXE2YbSp9gDho2WKqctVRGotC0d9kZFOaumztZHQK1ZBwLWRDpeH
	D1mCHA21EmNWNTT811y7pD6xjKsBDTfb19+6ipQBcArtZkzMvrpDWg2pm8wm3TETilXvAnxcxsL
	i8nsLeVKyivCmSpjhqHM39OmgiIe3hjzeFgJO5lFUokEkFStwxFKXMm5zE5aWIl8APZKYRIdhS2
	IifkLKJ4JeAA/rKdERKtPc0EAibL0fTMGgjsxH4PHiex6Qsq7d4Ay79ooA62FfQycgVELfd70nr
	ydidd59WAnhx3myfq/dKvVdlVGop1pXi
X-Received: by 2002:a05:622a:a953:20b0:4af:36a:a60f with SMTP id d75a77b69052e-4af036aa957mr25038541cf.21.1754068435405;
        Fri, 01 Aug 2025 10:13:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8+K6i2QRol52KGBLA9S6CAT2dneVBlknXiG0f/LH2d8sJO8oI3hxjPNdTh/rQMWdVl3tj8g==
X-Received: by 2002:a05:622a:a953:20b0:4af:36a:a60f with SMTP id d75a77b69052e-4af036aa957mr25037891cf.21.1754068434728;
        Fri, 01 Aug 2025 10:13:54 -0700 (PDT)
Received: from x1.local ([174.89.135.171])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeebde17fsm22954801cf.1.2025.08.01.10.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 10:13:54 -0700 (PDT)
Date: Fri, 1 Aug 2025 13:13:42 -0400
From: Peter Xu <peterx@redhat.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
	aarcange@redhat.com, lokeshgidra@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
Message-ID: <aIz1xrzBc2Spa2OH@x1.local>
References: <20250731154442.319568-1-surenb@google.com>
 <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
 <aIzMGlrR1SL5Y_Gp@x1.local>
 <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
 <aIzp6WqdzhomPhhf@x1.local>
 <CAJuCfpGWLnu+r2wvY2Egy2ESPD=tAVvfVvAKXUv1b+Z0hweeJg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJuCfpGWLnu+r2wvY2Egy2ESPD=tAVvfVvAKXUv1b+Z0hweeJg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u_fYO-lDOvoFuhlJgnRIWO7tiOfTSHbD-Xd8qkQXP3c_1754068436
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: okkkorneka78feyth7njssu5s54wgkjc
X-Rspamd-Queue-Id: 512B44000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754068438-145034
X-HE-Meta: U2FsdGVkX18suKHvGfHaEwcqW70XsM+qytGcyD/Ea+8I+JFRw9mzPqcHZ6txaAH/u5KAt6/DLCNknlumawU61Tk7hx41GlN5RDrfxbW+YeJWzIzWEGSpUvRghRMScR6/N6/r8AwaHURSUY0BY6XQW5NHJu/QQ7ebZ7V4+vVZIPGFoDmpwqIaHSCxfFq9hGpnMNtvYw0QBJK3iiKlgIrjC227vD7WjHX45KkLqAdgRf1Y/TRNnSeJOcnxzBlobYVUdypQx0iZD1BB08hI5THmz0WSwmRiq5LlYf159ZPP5VTbimpdE75W7CUqUUsU9NGKZ3mQr2Ycu/SKAT+RRmcd6MxUtoJfwHycu8ZLip2TQO0o8tpi94N5DKK0Rb8x1HQeiH5EQl2lsDwa1uEj/z6eiAjCaIrsOCAn3MZtecrfEYBswdlO5Zza4+fAuknU2dxkdtltXNzDQhNSoesNsCA1Dh+0+ksS4uafeVooh6TMBjn85MB5c9AJAkFMqusSwV4CdwxPoQz8S8IbImX/J5wJybbeePjvSiaaCJSjbaPKHI7rLEaRQyxhg5qYYqhH+Qg9vFMAJSWAXBhLkAEkdg9HYyl6CA5NDtIDap2ZMI2yyHxN9xIMQBJ9mKELS0AcKAyvlyp2XC1rDxB8wxmRhDj7FSUXAC59scgtl5sd3GNXTMGmsbsy2EHHV36eQ7e5OnzU4iGP0X2cqAoMDaY1u4+dzGcvLqsxHrYafuS1cTTU3qgqEFaJxhGH6yN6UFXtpqilDy+WrqSGz4S5VNK146Uv9c+f1EPkZVrg9L/criHhS/a3d2009SDM5ix/+qgubqEMArOL0gUPmh106jkVbQLI5kPwr6l/TYCPWM1MbPLIdWxO6mo7kMDXAXs0bjxxJGUqAB+LHtnbka6lgnOBa6CoqVnT/9OYSTvD9avHpey92JeNWexX1zuioVoOKj/VeWiC/03A7/q3ob1qUvlO508
 b30s2feT
 lJ8aMrGC3NIqB7L9OZcar+7hCBPsPl0oui85kKgS66VOaDUlP6Ivh4o8hUihekdonIfONHHkobnd6QRx/ma2BgbmplFr3scCf8ldwtYXVwlzOzWJEw1qLn0/w4ETmamYlpoRkUp5CQ3is0dHjRzZzUwfoYvY9hSOJcUN1HZt/hh35MAPMhhdjMcurwxOHllIrBxH8VAv+jNhtSPnyxEWq5FIl19J5UHGSPDloi8GQMtfuEpYWYdu+CiYepWCn6SSxhmnTPxxOa8NghHTnJFkemjzL6UEkD0WpRBnmO1BKu7XX2Afq2DnD4dfHWiPbc5i7QLMtNonzuoRkYaiRTxn1Fpq0INDRVR8qHzu24QuIE+J0ZyNk+yW7FkibQVzVTjdCrhd79ORWHEkvjD+WsrWZejKtODFXYd9w/OLnfQbJIBExoUnIrXH/pN5kn/MP3diMO+4irCQyUkWLd5ruAJjwRDAzHQ2/y1ny+enx22cPwyrsq9fq2aIX28SRfk7qyu7qyBCSFCTGR8t2kdRb2Kr7rITpt1XnHpIvj9VahTWI0DuWYRtcS87g8WLlOBHY8rFUJRVEJhFw1F/wShu8i2+Xx130hUF4hZsaywidTKtvTyi52GrosL9Yb6i+o5Ao+AmEZV9/pPPj6dR+wSlHdVrHRlPSgvTDXkbzX7Qzuq0KuWm/zm76VYL9pvyh0Io26PJgSsH5lnSoT3e3LpJbwsCxGFQ3fA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 09:41:31AM -0700, Suren Baghdasaryan wrote:
> On Fri, Aug 1, 2025 at 9:23 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Fri, Aug 01, 2025 at 08:28:38AM -0700, Suren Baghdasaryan wrote:
> > > On Fri, Aug 1, 2025 at 7:16 AM Peter Xu <peterx@redhat.com> wrote:
> > > >
> > > > On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hildenbrand wrote:
> > > > > On 31.07.25 17:44, Suren Baghdasaryan wrote:
> > > > >
> > > > > Hi!
> > > > >
> > > > > Did you mean in you patch description:
> > > > >
> > > > > "userfaultfd: fix a crash in UFFDIO_MOVE with some non-present PMDs"
> > > > >
> > > > > Talking about THP holes is very very confusing.
> > > > >
> > > > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES and it
> > > > > > encounters a non-present THP, it fails to properly recognize an unmapped
> > > > >
> > > > > You mean a "non-present PMD that is not a migration entry".
> > > > >
> > > > > > hole and tries to access a non-existent folio, resulting in
> > > > > > a crash. Add a check to skip non-present THPs.
> > > > >
> > > > > That makes sense. The code we have after this patch is rather complicated
> > > > > and hard to read.
> > > > >
> > > > > >
> > > > > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > > > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> > > > > > Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
> > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > > Cc: stable@vger.kernel.org
> > > > > > ---
> > > > > > Changes since v1 [1]
> > > > > > - Fixed step size calculation, per Lokesh Gidra
> > > > > > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES, per Lokesh Gidra
> > > > > >
> > > > > > [1] https://lore.kernel.org/all/20250730170733.3829267-1-surenb@google.com/
> > > > > >
> > > > > >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++----------------
> > > > > >   1 file changed, 29 insertions(+), 16 deletions(-)
> > > > > >
> > > > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > > > index cbed91b09640..b5af31c22731 100644
> > > > > > --- a/mm/userfaultfd.c
> > > > > > +++ b/mm/userfaultfd.c
> > > > > > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
> > > > > >             ptl = pmd_trans_huge_lock(src_pmd, src_vma);
> > > > > >             if (ptl) {
> > > > > > -                   /* Check if we can move the pmd without splitting it. */
> > > > > > -                   if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > > > > -                       !pmd_none(dst_pmdval)) {
> > > > > > -                           struct folio *folio = pmd_folio(*src_pmd);
> > > > > > +                   if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) {
> > > >
> > > > [1]
> > > >
> > > > > > +                           /* Check if we can move the pmd without splitting it. */
> > > > > > +                           if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> > > > > > +                               !pmd_none(dst_pmdval)) {
> > > > > > +                                   if (pmd_present(*src_pmd)) {
> >
> > [2]
> >
> > > > > > +                                           struct folio *folio = pmd_folio(*src_pmd);
> >
> > [3]
> >
> > > > > > +
> > > > > > +                                           if (!folio || (!is_huge_zero_folio(folio) &&
> > > > > > +                                                          !PageAnonExclusive(&folio->page))) {
> > > > > > +                                                   spin_unlock(ptl);
> > > > > > +                                                   err = -EBUSY;
> > > > > > +                                                   break;
> > > > > > +                                           }
> > > > > > +                                   }
> > > > >
> > > > > ... in particular that. Is there some way to make this code simpler / easier
> > > > > to read? Like moving that whole last folio-check thingy into a helper?
> > > >
> > > > One question might be relevant is, whether the check above [1] can be
> > > > dropped.
> > > >
> > > > The thing is __pmd_trans_huge_lock() does double check the pmd to be !none
> > > > before returning the ptl.  I didn't follow closely on the recent changes on
> > > > mm side on possible new pmd swap entries, if migration is the only possible
> > > > one then it looks like [1] can be avoided.
> > >
> > > Hi Peter,
> > > is_swap_pmd() check in __pmd_trans_huge_lock() allows for (!pmd_none()
> > > && !pmd_present()) PMD to pass and that's when this crash is hit.
> >
> > First for all, thanks for looking into the issue with Lokesh; I am still
> > catching up with emails after taking weeks off.
> >
> > I didn't yet read into the syzbot report, but I thought the bug was about
> > referencing the folio on top of a swap entry after reading your current
> > patch, which has:
> >
> >         if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
> >             !pmd_none(dst_pmdval)) {
> >                 struct folio *folio = pmd_folio(*src_pmd); <----
> >
> > Here looks like *src_pmd can be a migration entry. Is my understanding
> > correct?
> 
> Correct.
> 
> >
> > > If we drop the check at [1] then the path that takes us to
> >
> > If my above understanding is correct, IMHO it should be [2] above that
> > makes sure the reference won't happen on a swap entry, not necessarily [1]?
> 
> Yes, in case of migration entry this is what protects us.
> 
> >
> > > split_huge_pmd() will bail out inside split_huge_pmd_locked() with no
> > > indication that split did not happen. Afterwards we will retry
> >
> > So we're talking about the case where it's a swap pmd entry, right?
> 
> Hmm, my understanding is that it's being treated as a swap entry but
> in reality is not. I thought THPs are always split before they get
> swapped, no?

Yes they should be split, afaiu.

> 
> > Could you elaborate why the split would fail?
> 
> Just looking at the code, split_huge_pmd_locked() checks for
> (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd)).
> pmd_trans_huge() is false if !pmd_present() and it's not a migration
> entry, so __split_huge_pmd_locked() will be skipped.

Here might be the major part of where confusion came from: I thought it
must be a migration pmd entry to hit the issue, so it's not?

I checked the code just now:

__handle_mm_fault:
		if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
			VM_BUG_ON(thp_migration_supported() &&
					  !is_pmd_migration_entry(vmf.orig_pmd));

So IIUC pmd migration entry is still the only possible way to have a swap
entry.  It doesn't look like we have "real" swap entries for PMD (which can
further points to some swapfiles)?

-- 
Peter Xu


