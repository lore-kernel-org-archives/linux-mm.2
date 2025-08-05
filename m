Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F87C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAA6C8E0005; Tue,  5 Aug 2025 10:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D820D8E0001; Tue,  5 Aug 2025 10:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C987C8E0005; Tue,  5 Aug 2025 10:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9EB88E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:57:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72DD6133B44
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:57:32 +0000 (UTC)
X-FDA: 83743007544.02.C4A5161
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7F86118000A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:57:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sDgdTw1p;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754405850; a=rsa-sha256;
	cv=none;
	b=OUDLx3sKp6o2n5ljzvUn2JiqrW9CBxgA4Zr1XMQGpj8mW3g+23hnKkzpa8FvL7+aZKXsw8
	8czK2QW0m6gW5tMjXCoT3wML7CwpHRYr+Dfqk9lTXRBcPBQUCGGXESZ+azGdqKeUgcucxo
	PP2BAZO9OX3pk5xfN3potobwp7hOJ5I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sDgdTw1p;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754405850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UX5cs3lHqIbxrim0a3iEN5C2bHRmCjQDiyeRqDnGqIA=;
	b=2UrrBx0sLUNbZYscQD2CNziCae7uTUWwvCwn8QDnQXbTObMDKP8xkZGRrWPEKWNxTveO7r
	4pqLkOImRZtPP3mWDO9lXw1QOcA4ED56BcYkOgHHL9i/zU5XM7MOImefi/TDwgLzNgRpQ+
	WF1ucqS3xfoQTp8WABjTj4Xoki2zdyU=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b07a5e9f9fso440471cf.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754405849; x=1755010649; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UX5cs3lHqIbxrim0a3iEN5C2bHRmCjQDiyeRqDnGqIA=;
        b=sDgdTw1p7KsGDFylloecZb8HpgJbk2ndsLz2LkABMq0Ak/KrUvzh4kljzCg2rAMABD
         VPUIn6TowniYdncyBTXyY1rPiTWs5zjJVEHVLN70u5zyULCxPgy1dGbEQi68d0F3hurK
         bOTH6ISasriioimX4sxOs590LTaW0JjTSpTQLpIzvK5SQFx80xz4U77MoNq9N9wBg7mJ
         2Ihi1rsReRi3BzHm09cssh0Mzrckgb4uGFdb3mNgFK4/thJZ3HIKa8TeLQVrd4GsMd1P
         Vld2Hs8Wn26DhTeNLMqz4PIJWUlwXNJELgGHjFLlQJL9npd4hgA7Vgazv9dabXoP0X2J
         6kYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754405849; x=1755010649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UX5cs3lHqIbxrim0a3iEN5C2bHRmCjQDiyeRqDnGqIA=;
        b=BmkEXm61eMxlciZ88tQqYYPtXcsHif6HQ2359yfAn8xEbQ7p5RqpUW1VdLKfMqKaWl
         rAqrXBF5x4gdVUvT9JtZDYXlcQtONB3YzzASs03zw+mW5zF5kMAprGP5zXil0bN196+L
         tpeQZy5sRE2RDW297Zd+JrJu/03z9tdoeAYtMO52e81pUoE6JYRkSysAmeyNNJPYYZ4W
         FXJc86aBQmi85QkrGG79/LfcpHKE+A+X/hM3J9iEdAevVNieLU0l7nHmuvBdZRM3C/b3
         o6hQm5kFPT/zsOgMeavfjCq5gJlx2wWPxUd5b84NfjrlXUnxGcf25BMYchpq/6M4yohP
         u9+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWotwW2k/qwe2BoF0RwDu/yh30E/8ghqKgBfAic8iKVJiUrPHMXZp5zROYlNSJnMEb6PQ7idZ77Tg==@kvack.org
X-Gm-Message-State: AOJu0YwDOTNghFJx0TrFnXVCNykkfKyYtbOO00Ne8HSOQhSEcCZaXXgB
	1xZEpSt8vKI2n3c7T1HNEc+bT2MKUXWKfI/5CElo7MensX9CmH9PfHM3wW+0aMoEGcH696DYxyr
	so2Q41XQ/oY4WPjIzbRzhK9PFRWyGNqi9hjOc4oOU
X-Gm-Gg: ASbGncvfH+TJhGsnQXtPVYlP6dNgCnBQKC/PAoIQl57t814TOjBNB/48hAAyiKpNWV6
	cBmHhv7m5DTRlLHsC+j/OX1sOREf2cA85pICE1zklHWAucgQkeRuxRsDNh6aQJAwoAkwDwS1CcF
	0vQPkFYZVr4PUMK4t2wwh7y+Is1OexT1TDDmC4x5P14Wotd5g876aA02aApB7ghLZW59/hvrXlD
	+gxmaBVyQeSEPVPm4NfXeNLkRsqQhExij07XLaNMFgqTQzS
X-Google-Smtp-Source: AGHT+IGLZKNoZY1g7Z4NbMCRTteQccrBt8PcIwP4mJ0WIiz5tnPREzcYXyX50zdXotguGwk86Au/Hdop0F1jHsOFKmo=
X-Received: by 2002:a05:622a:180b:b0:497:75b6:e542 with SMTP id
 d75a77b69052e-4b084f11753mr4011031cf.10.1754405848822; Tue, 05 Aug 2025
 07:57:28 -0700 (PDT)
MIME-Version: 1.0
References: <aIzMGlrR1SL5Y_Gp@x1.local> <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
 <aIzp6WqdzhomPhhf@x1.local> <CAJuCfpGWLnu+r2wvY2Egy2ESPD=tAVvfVvAKXUv1b+Z0hweeJg@mail.gmail.com>
 <aIz1xrzBc2Spa2OH@x1.local> <CAJuCfpFJGaDaFyNLa3JsVh19NWLGNGo1ebC_ijGTgPGNyfUFig@mail.gmail.com>
 <aI0Ffc9WXeU2X71O@x1.local> <CAJuCfpFSY3fDH36dabS=nGzasZJ6FtQ_jv79eFWVZrEWRMMTiQ@mail.gmail.com>
 <aI1ckD3KhNvoMtlv@x1.local> <CAJuCfpHcScutgGi3imYTJVXBqs=jcqZ5CkKKe=sfVHjUg0Y6RQ@mail.gmail.com>
 <aJIXlN-ZD_soWdP0@x1.local>
In-Reply-To: <aJIXlN-ZD_soWdP0@x1.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 5 Aug 2025 07:57:17 -0700
X-Gm-Features: Ac12FXyAM_EgbCxyw_Y-VGO-izFJUCqFoQ6tTjGFrNOoAZicqFMbU-6OO5r2W8c
Message-ID: <CAJuCfpFzP_W8i8pwL+-Uv-n+2LixgFrzqn2HsY_h-1kbP=g3JQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7F86118000A
X-Stat-Signature: 7h1dsmty3sew8khbkh1exbxfu6je9j14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754405850-155956
X-HE-Meta: U2FsdGVkX1+BH+gu4t9nO1aY9+BEjaHxuShYHDFqmhvUhlRsAboa0uNmP5qKYZFZQT7j995xrN691Ku+NZqF1v14/9Lv+BW+P/ZU6+qTyVopV3k0CcS0b3LEqajfwIDCDHEoJF1jk1JLKKeOTRS7O+ZEY6zDvQhypWQDshUvCfk1scyNSGCIeGlRsGJO5oUmV8grLfE5GerWFdmJoyxOE/k4Oc2pP0bHV8yuVN4p0V8JP2btfVU2ttabWOg64LtHesGluz90rMhQGkYT4qPONhE7JFc5U/oqfWe42K0G5HxF3CHAHe51kVlxSHzDaXL7sgQkSQSoKKBrlo/smzfgk+9ke6zk+J6zsFuI8pz5i7yMf+QqrPvqORkkUDLcTvRsQS16XnJmWnNfIH/quDs5LrOR9c8I2I8453ZLpIrKfoTzQH+Iw9XZLWHqh5slxGtvw9LcLOGCUkDGa5PfxqzB7Gx15u3gx4lNi7EPbl07UtVE6Mc2r0r3LB1YpMdeW+JkIv2F+BzUabQZVWNQn6ElUpuClO1HRY9rnmF1CNMhL+30ORSKQEICKqbd4VOxCPi2olSkvoajgLN76/7aEPB3CNfFNW9WbFOBa7IY7X5hxTIuBluvCJFyRPvjTuan+uxXQt1quY/ptii3rgrXL4rzFNTPVnBvtwvuDIAypqS5uEuPNbI0kBipAdd5/L+Hk8GoRiSG9XvOgy4M0xeAdrwRSJW+At08YR/7kkVrUgHrS1uyUFQWY7P5yWnop3GQcmKCrjDu9TRje0Za0QYTu/ryh2nR5re0PHOnMzE+3PoxPEGfl/rqMcRJEyMnNyxd3g8sl3md1rYlGsJ+OUA7gN9l9oKFpPNoZr2Tf36UGYBczDQrfzDzfEDEhbE3RmsRUzRz0+yxf44x/Df92Tjq3zqsbqjdVjZ9AAJcvVaCoiRPtZuLG27XBpfAFlDOMbSxDdhdh7ULcJl0xZ+NSpLNRRZ
 LrTXxC0g
 L9SpqNAPEMuhtNgnE2Nu7BT43X+X4HtTIG9w3kS/QF0Q6DrBd91mUf8ynTJsnX7m4rJJFH99QmZZGBxs9tyHUigOKJ3WuM0EWNQDQgN2uumEDeglcoIqGWjeDR93w9+B3OXLUahrZ8zXcHLymuVtybMr9h0VYSqfW6WofJ5B/maDYEQOcOiR0KK8D1Mbg5mTRA9YxHrLF18XMGHbjA2R5kU0PssfqKfGC8aDcS8thvnUG3PsI29TV44+sRz770Ssmzhf7FzSCuuSY1rtRs9jNNYRisckad1uKxRvyUPDsQ5hv7Cv6tmFwGIyjtyAWK018IHor6902Hfa9hh/GOzAxtxf4EBSJYZLZN4NSKYG++FevoyPAAiNjXL4xr4ahcu/vPuk6aQtTtjEEdjzGZungioamLWO0jH6Tqo/fDZZ0cKyJljp5O99+mbzUplimsm+6JyGSb97tAqXxI00DZ0loaYofM1xV2hvJa/iVtp0Qhfoebok=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 7:39=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, Aug 04, 2025 at 07:55:42AM -0700, Suren Baghdasaryan wrote:
> > On Fri, Aug 1, 2025 at 5:32=E2=80=AFPM Peter Xu <peterx@redhat.com> wro=
te:
> > >
> > > On Fri, Aug 01, 2025 at 07:30:02PM +0000, Suren Baghdasaryan wrote:
> > > > On Fri, Aug 1, 2025 at 6:21=E2=80=AFPM Peter Xu <peterx@redhat.com>=
 wrote:
> > > > >
> > > > > On Fri, Aug 01, 2025 at 05:45:10PM +0000, Suren Baghdasaryan wrot=
e:
> > > > > > On Fri, Aug 1, 2025 at 5:13=E2=80=AFPM Peter Xu <peterx@redhat.=
com> wrote:
> > > > > > >
> > > > > > > On Fri, Aug 01, 2025 at 09:41:31AM -0700, Suren Baghdasaryan =
wrote:
> > > > > > > > On Fri, Aug 1, 2025 at 9:23=E2=80=AFAM Peter Xu <peterx@red=
hat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Fri, Aug 01, 2025 at 08:28:38AM -0700, Suren Baghdasar=
yan wrote:
> > > > > > > > > > On Fri, Aug 1, 2025 at 7:16=E2=80=AFAM Peter Xu <peterx=
@redhat.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hilde=
nbrand wrote:
> > > > > > > > > > > > On 31.07.25 17:44, Suren Baghdasaryan wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > Hi!
> > > > > > > > > > > >
> > > > > > > > > > > > Did you mean in you patch description:
> > > > > > > > > > > >
> > > > > > > > > > > > "userfaultfd: fix a crash in UFFDIO_MOVE with some =
non-present PMDs"
> > > > > > > > > > > >
> > > > > > > > > > > > Talking about THP holes is very very confusing.
> > > > > > > > > > > >
> > > > > > > > > > > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_AL=
LOW_SRC_HOLES and it
> > > > > > > > > > > > > encounters a non-present THP, it fails to properl=
y recognize an unmapped
> > > > > > > > > > > >
> > > > > > > > > > > > You mean a "non-present PMD that is not a migration=
 entry".
> > > > > > > > > > > >
> > > > > > > > > > > > > hole and tries to access a non-existent folio, re=
sulting in
> > > > > > > > > > > > > a crash. Add a check to skip non-present THPs.
> > > > > > > > > > > >
> > > > > > > > > > > > That makes sense. The code we have after this patch=
 is rather complicated
> > > > > > > > > > > > and hard to read.
> > > > > > > > > > > >
> > > > > > > > > > > > >
> > > > > > > > > > > > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uA=
BI")
> > > > > > > > > > > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkalle=
r.appspotmail.com
> > > > > > > > > > > > > Closes: https://lore.kernel.org/all/68794b5c.a70a=
0220.693ce.0050.GAE@google.com/
> > > > > > > > > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.=
com>
> > > > > > > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > > > > > > ---
> > > > > > > > > > > > > Changes since v1 [1]
> > > > > > > > > > > > > - Fixed step size calculation, per Lokesh Gidra
> > > > > > > > > > > > > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_=
SRC_HOLES, per Lokesh Gidra
> > > > > > > > > > > > >
> > > > > > > > > > > > > [1] https://lore.kernel.org/all/20250730170733.38=
29267-1-surenb@google.com/
> > > > > > > > > > > > >
> > > > > > > > > > > > >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++=
++++----------------
> > > > > > > > > > > > >   1 file changed, 29 insertions(+), 16 deletions(=
-)
> > > > > > > > > > > > >
> > > > > > > > > > > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > > > > > > > > > > index cbed91b09640..b5af31c22731 100644
> > > > > > > > > > > > > --- a/mm/userfaultfd.c
> > > > > > > > > > > > > +++ b/mm/userfaultfd.c
> > > > > > > > > > > > > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct=
 userfaultfd_ctx *ctx, unsigned long dst_start,
> > > > > > > > > > > > >             ptl =3D pmd_trans_huge_lock(src_pmd, =
src_vma);
> > > > > > > > > > > > >             if (ptl) {
> > > > > > > > > > > > > -                   /* Check if we can move the p=
md without splitting it. */
> > > > > > > > > > > > > -                   if (move_splits_huge_pmd(dst_=
addr, src_addr, src_start + len) ||
> > > > > > > > > > > > > -                       !pmd_none(dst_pmdval)) {
> > > > > > > > > > > > > -                           struct folio *folio =
=3D pmd_folio(*src_pmd);
> > > > > > > > > > > > > +                   if (pmd_present(*src_pmd) || =
is_pmd_migration_entry(*src_pmd)) {
> > > > > > > > > > >
> > > > > > > > > > > [1]
> > > > > > > > > > >
> > > > > > > > > > > > > +                           /* Check if we can mo=
ve the pmd without splitting it. */
> > > > > > > > > > > > > +                           if (move_splits_huge_=
pmd(dst_addr, src_addr, src_start + len) ||
> > > > > > > > > > > > > +                               !pmd_none(dst_pmd=
val)) {
> > > > > > > > > > > > > +                                   if (pmd_prese=
nt(*src_pmd)) {
> > > > > > > > >
> > > > > > > > > [2]
> > > > > > > > >
> > > > > > > > > > > > > +                                           struc=
t folio *folio =3D pmd_folio(*src_pmd);
> > > > > > > > >
> > > > > > > > > [3]
> > > > > > > > >
> > > > > > > > > > > > > +
> > > > > > > > > > > > > +                                           if (!=
folio || (!is_huge_zero_folio(folio) &&
> > > > > > > > > > > > > +                                                =
          !PageAnonExclusive(&folio->page))) {
> > > > > > > > > > > > > +                                                =
   spin_unlock(ptl);
> > > > > > > > > > > > > +                                                =
   err =3D -EBUSY;
> > > > > > > > > > > > > +                                                =
   break;
> > > > > > > > > > > > > +                                           }
> > > > > > > > > > > > > +                                   }
> > > > > > > > > > > >
> > > > > > > > > > > > ... in particular that. Is there some way to make t=
his code simpler / easier
> > > > > > > > > > > > to read? Like moving that whole last folio-check th=
ingy into a helper?
> > > > > > > > > > >
> > > > > > > > > > > One question might be relevant is, whether the check =
above [1] can be
> > > > > > > > > > > dropped.
> > > > > > > > > > >
> > > > > > > > > > > The thing is __pmd_trans_huge_lock() does double chec=
k the pmd to be !none
> > > > > > > > > > > before returning the ptl.  I didn't follow closely on=
 the recent changes on
> > > > > > > > > > > mm side on possible new pmd swap entries, if migratio=
n is the only possible
> > > > > > > > > > > one then it looks like [1] can be avoided.
> > > > > > > > > >
> > > > > > > > > > Hi Peter,
> > > > > > > > > > is_swap_pmd() check in __pmd_trans_huge_lock() allows f=
or (!pmd_none()
> > > > > > > > > > && !pmd_present()) PMD to pass and that's when this cra=
sh is hit.
> > > > > > > > >
> > > > > > > > > First for all, thanks for looking into the issue with Lok=
esh; I am still
> > > > > > > > > catching up with emails after taking weeks off.
> > > > > > > > >
> > > > > > > > > I didn't yet read into the syzbot report, but I thought t=
he bug was about
> > > > > > > > > referencing the folio on top of a swap entry after readin=
g your current
> > > > > > > > > patch, which has:
> > > > > > > > >
> > > > > > > > >         if (move_splits_huge_pmd(dst_addr, src_addr, src_=
start + len) ||
> > > > > > > > >             !pmd_none(dst_pmdval)) {
> > > > > > > > >                 struct folio *folio =3D pmd_folio(*src_pm=
d); <----
> > > > > > > > >
> > > > > > > > > Here looks like *src_pmd can be a migration entry. Is my =
understanding
> > > > > > > > > correct?
> > > > > > > >
> > > > > > > > Correct.
> > > > > > > >
> > > > > > > > >
> > > > > > > > > > If we drop the check at [1] then the path that takes us=
 to
> > > > > > > > >
> > > > > > > > > If my above understanding is correct, IMHO it should be [=
2] above that
> > > > > > > > > makes sure the reference won't happen on a swap entry, no=
t necessarily [1]?
> > > > > > > >
> > > > > > > > Yes, in case of migration entry this is what protects us.
> > > > > > > >
> > > > > > > > >
> > > > > > > > > > split_huge_pmd() will bail out inside split_huge_pmd_lo=
cked() with no
> > > > > > > > > > indication that split did not happen. Afterwards we wil=
l retry
> > > > > > > > >
> > > > > > > > > So we're talking about the case where it's a swap pmd ent=
ry, right?
> > > > > > > >
> > > > > > > > Hmm, my understanding is that it's being treated as a swap =
entry but
> > > > > > > > in reality is not. I thought THPs are always split before t=
hey get
> > > > > > > > swapped, no?
> > > > > > >
> > > > > > > Yes they should be split, afaiu.
> > > > > > >
> > > > > > > >
> > > > > > > > > Could you elaborate why the split would fail?
> > > > > > > >
> > > > > > > > Just looking at the code, split_huge_pmd_locked() checks fo=
r
> > > > > > > > (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd)).
> > > > > > > > pmd_trans_huge() is false if !pmd_present() and it's not a =
migration
> > > > > > > > entry, so __split_huge_pmd_locked() will be skipped.
> > > > > > >
> > > > > > > Here might be the major part of where confusion came from: I =
thought it
> > > > > > > must be a migration pmd entry to hit the issue, so it's not?
> > > > > > >
> > > > > > > I checked the code just now:
> > > > > > >
> > > > > > > __handle_mm_fault:
> > > > > > >                 if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
> > > > > > >                         VM_BUG_ON(thp_migration_supported() &=
&
> > > > > > >                                           !is_pmd_migration_e=
ntry(vmf.orig_pmd));
> > > > > > >
> > > > > > > So IIUC pmd migration entry is still the only possible way to=
 have a swap
> > > > > > > entry.  It doesn't look like we have "real" swap entries for =
PMD (which can
> > > > > > > further points to some swapfiles)?
> > > > > >
> > > > > > Correct. AFAIU here we stumble on a pmd entry which was allocat=
ed but
> > > > > > never populated.
> > > > >
> > > > > Do you mean a pmd_none()?
> > > >
> > > > Yes.
> > > >
> > > > >
> > > > > If so, that goes back to my original question, on why
> > > > > __pmd_trans_huge_lock() returns non-NULL if it's a pmd_none()?  I=
MHO it
> > > > > really should have returned NULL for pmd_none().
> > > >
> > > > That was exactly the answer I gave Lokesh when he theorized about t=
he
> > > > cause of this crash but after reproducing it I saw that
> > > > pmd_trans_huge_lock() happily returns the PTL as long as PMD is not
> > > > pmd_none(). And that's because it passes as is_swap_pmd(). But even=
 if
> > > > we change that we still need to implement the code to skip the enti=
re
> > > > PMD.
> > >
> > > The thing is I thought if pmd_trans_huge_lock() can return non-NULL, =
it
> > > must be either a migration entry or a present THP. So are you describ=
ing a
> > > THP but with present bit cleared?  Do you know what is that entry, an=
d why
> > > it has present bit cleared?
> >
> > In this case it's because earlier we allocated that PMD here:
> > https://elixir.bootlin.com/linux/v6.16/source/mm/userfaultfd.c#L1797
>
> AFAIU, this line is not about allocation of any pmd entry, but the pmd
> pgtable page that _holds_ the PMDs:
>
> static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned=
 long address)
> {
>         return (unlikely(pud_none(*pud)) && __pmd_alloc(mm, pud, address)=
)?
>                 NULL: pmd_offset(pud, address);
> }
>
> It makes sure the PUD entry, not the PMD entry, be populated.

Hmm. Then I was reading this code completely wrong and need to rethink
what is happening here.

>
> > but wouldn't that be the same if the PMD was mapped and then got
> > unmapped later? My understanding is that we allocate the PMD at the
> > line I pointed to make UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES case the same
> > as this unmapped PMD case. If my assumption is incorrect then we could
> > skip the hole earlier instead of allocating the PMD for it.
> >
> > >
> > > I think my attention got attracted to pmd migration entry too much, s=
o I
> > > didn't really notice such possibility, as I believe migration pmd is =
broken
> > > already in this path.
> > >
> > > The original code:
> > >
> > >                 ptl =3D pmd_trans_huge_lock(src_pmd, src_vma);
> > >                 if (ptl) {
> > >                         /* Check if we can move the pmd without split=
ting it. */
> > >                         if (move_splits_huge_pmd(dst_addr, src_addr, =
src_start + len) ||
> > >                             !pmd_none(dst_pmdval)) {
> > >                                 struct folio *folio =3D pmd_folio(*sr=
c_pmd);
> > >
> > >                                 if (!folio || (!is_huge_zero_folio(fo=
lio) &&
> > >                                                !PageAnonExclusive(&fo=
lio->page))) {
> > >                                         spin_unlock(ptl);
> > >                                         err =3D -EBUSY;
> > >                                         break;
> > >                                 }
> > >
> > >                                 spin_unlock(ptl);
> > >                                 split_huge_pmd(src_vma, src_pmd, src_=
addr);
> > >                                 /* The folio will be split by move_pa=
ges_pte() */
> > >                                 continue;
> > >                         }
> > >
> > >                         err =3D move_pages_huge_pmd(mm, dst_pmd, src_=
pmd,
> > >                                                   dst_pmdval, dst_vma=
, src_vma,
> > >                                                   dst_addr, src_addr)=
;
> > >                         step_size =3D HPAGE_PMD_SIZE;
> > >                 } else {
> > >
> > > It'll get ptl for a migration pmd, then pmd_folio is risky without ch=
ecking
> > > present bit.  That's what my previous smaller patch wanted to fix.
> > >
> > > But besides that, IIUC it's all fine at least for a pmd migration ent=
ry,
> > > because when with the smaller patch applied, either we'll try to spli=
t the
> > > pmd migration entry, or we'll do move_pages_huge_pmd(), which interna=
lly
> > > handles the pmd migration entry too by waiting on it:
> > >
> > >         if (!pmd_trans_huge(src_pmdval)) {
> > >                 spin_unlock(src_ptl);
> > >                 if (is_pmd_migration_entry(src_pmdval)) {
> > >                         pmd_migration_entry_wait(mm, &src_pmdval);
> > >                         return -EAGAIN;
> > >                 }
> > >                 return -ENOENT;
> > >         }
> > >
> > > Then logically after the migration entry got recovered, we'll either =
see a
> > > real THP or pmd none next time.
> >
> > Yes, for migration entries adding the "if (pmd_present(*src_pmd))"
> > before getting the folio is enough. The problematic case is
> > (!pmd_none(*src_pmd) && !pmd_present(*src_pmd)) and not a migration
> > entry.
>
> I thought we could have any of below here on the pmd entry:
>
>   (0) pmd_none, which should constantly have pmd_trans_huge_lock -> NULL
>
>   (1) pmd pgtable entry, which must have PRESENT && !TRANS, so
>   pmd_trans_huge_lock -> NULL,
>
>   (2) pmd migration, pmd_trans_huge_lock -> valid
>
>   (3) pmd thp, pmd_trans_huge_lock -> valid
>
> I thought (2) was broken, which we seem to agree upon.. however if so the
> smaller patch should fix it, per explanation in my previous reply.  OTOH =
I
> can't think of (4).

The case I was hitting is (!pmd_none && !pmd_present &&
!is_pmd_migration_entry). My original thinking was that this entry was
newly allocated at the line I pointed earlier but now I'm not so sure
anymore.

>
> Said that, I just noticed (3) can be broken as well - could it be a
> prot_none entry?  The very confusing part of this patch is it seems to
> think it's pmd_none() here as holes:
>
>         if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) {
>                 ...
>         } else {
>                 spin_unlock(ptl);
>                 if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES)) {
>                         err =3D -ENOENT;
>                         break;
>                 }
>                 /* nothing to do to move a hole */
>                 err =3D 0;
>                 step_size =3D min(HPAGE_PMD_SIZE, src_start + len - src_a=
ddr);
>         }
>
> But is it really?  Again, I don't think pmd_none() could happen with
> pmd_trans_huge_lock() returning the ptl.

That is true, in the pmd_none() case pmd_trans_huge_lock() returns NULL.

>
> Could you double check this?  E.g. with this line if that makes sense to
> you:
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 8bf8ff0be990f..d2d4f2a0ae69f 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1903,6 +1903,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, uns=
igned long dst_start,
>                                                           dst_addr, src_a=
ddr);
>                                 step_size =3D HPAGE_PMD_SIZE;
>                         } else {
> +                               BUG_ON(!pmd_none(*src_pmd));
>                                 spin_unlock(ptl);
>                                 if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_H=
OLES)) {
>                                         err =3D -ENOENT;
>
> I would expect it constantly BUG() here, if that explains my thoughts.

I'll add this and check.

>
> Now I doubt it's a prot_none THP.. aka, a THP that got numa hint to be
> moved.  If so, we may need to process it / move it / .. but we likely
> should never skip it.  We can double check the buggy pmd entry you hit
> (besides migration entry) first.

Let me log the flags of the entry when this issue happens. That should
provide more insights.
Thanks,
Suren.

>
> Thanks,
>
> --
> Peter Xu
>

