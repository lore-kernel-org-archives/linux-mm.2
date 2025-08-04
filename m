Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C36C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 14:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A6286B00BF; Mon,  4 Aug 2025 10:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47DF06B00C0; Mon,  4 Aug 2025 10:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393D56B00C1; Mon,  4 Aug 2025 10:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2711F6B00BF
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:55:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C04AA1405F2
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:55:56 +0000 (UTC)
X-FDA: 83739374712.19.533B337
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id D8A911C0013
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:55:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qaxdRf2R;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754319354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+o4Ch4o9Xv3jFhugflhfWPbhl3HCtAtjAIB2DUrZ25A=;
	b=D2gUboUZlFCVXpdafFLHXSiJsjQZEOEaHYIG8ZtTfvWx/MIol75wEf/4phoTd0m3cEAPbp
	aTEaGRmFeQKK2kP/jWwnCp6SMTmQy8xg4iS6+RytOPz4s9EHGXkg4+dom+nbrascjm2xlt
	5kaURJH3joDOn/I95ddgiX17M77/QrQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qaxdRf2R;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754319354; a=rsa-sha256;
	cv=none;
	b=nvXQKhPWcDzMzxhBeD7P6GZn7ZKqwtom+I/EbcDzxJA+xMo36XTWX3Vlwz6T9+OmNreSb3
	Sm/X48aIlkPxpuJgAmZ8YBluPw05f/Rzi25cRbQvWC+HovHk4Lol2Gk0I+4xNPmyUW7qQM
	LeU9r/25cbIKe17j3USu1O7kW1DSUkw=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b0673b0a7cso496051cf.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 07:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754319354; x=1754924154; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+o4Ch4o9Xv3jFhugflhfWPbhl3HCtAtjAIB2DUrZ25A=;
        b=qaxdRf2Ry9DOxtG+Pm8vEjW/E2LP3t33+vFjt5muUV7dClZCqm7mtZvcWIZPf60S4q
         ugJ5v0/sqB4qKVteCi6MIipkMAusN7byMwmfqYrXFNTwMhSOloDGKq0UpBqWR1IA1eVN
         xsZw/vhUMVTYDe+K7ZMSqtzE5o/aFmkGvNIogaeg1J+aXLZ5d8/SxC11LyOuQdFPHkwW
         wT51LnEYXCM4JDBEoYNS9F5MSyR5jfS7JQ6FWwNfzBCxp18QSJguez+857HyF6J0m+t7
         7SkPZ8/rLmclw72QbfQTtIuc6/SW8xpOz7fkq8taHjRzxg3RNTf7J4gURb5XmYCGlH6t
         1p5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754319354; x=1754924154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+o4Ch4o9Xv3jFhugflhfWPbhl3HCtAtjAIB2DUrZ25A=;
        b=unaZ89vHyHDvAu6U8ZQjJmhdxjtrtQxUAX3flpkTGpz0zP3drb74Jv6AchW4NQ2E3R
         qiX7djBWo9g/w4a48Rh+CAcmNl9OpdBmzEytrliO7gRX71J8uS6ox+o40iTcJqpuwX+z
         PrManMfL7nWDpb8AMLCgidMkBy1V9V2PyOA/xWYWlXCfJt4WJtMV5HGM1jr3pTyWsWjX
         Iq+y8+loU6aVWLhnveORxKdVUBaukqbP2d5jURM7iH97kpjBImy+CTPRkRHQKZUzFwn7
         KB6WldGE3WTKz6DU1WEemLgcbUfm26x9t5YsDDRbOA6/LTlj1Kw2yesqNKWsW7ej23cl
         VMHg==
X-Forwarded-Encrypted: i=1; AJvYcCULG+AAO8qAs+Gva84PhGu8Ncnr0bmjutt7nxBBAHoJWHSij4Z//ZLK948QMkWJVhAtvLjoeHQ+0Q==@kvack.org
X-Gm-Message-State: AOJu0Ywrw+V6PmDVYXGltj9P5gswJmhOQjyGjX+8IAG4ID4C2zovT920
	PlRFyDgecE15CZVdekR89KqxuESJEm1gCRC4QjTGRpGnkbZ7kgS8tAACkjyiOPo22IznktTIOr5
	v/UIVfUY1InTgXVzpyRuey+/Yomv8fr2VJ7PI0l8h
X-Gm-Gg: ASbGncuWXb3ZwjdhzonfYmXqC1QbP5IpediwQF0YKwvu+wCeFu+5sAvM0HRtZd36gtb
	nML2XJw/zIOqobM/BQZ9393eg1V4dXdNgCZBLjjBOQMa02EJYiNHmnFu21qAghKVVJV0Ui0jmss
	TFIXlyoI9U3bUj4HigKxegDG4u6yzzdddAZbsXscUM7ZKzcFjPMODe0LBA5EN2d4/Q473MyJOZt
	/oJXg==
X-Google-Smtp-Source: AGHT+IFKQssWn3qgvBXRZt7wMF56KFZCHc+HFV9s6XYM81Jbizj7eogrXqsiKY3AhtiRnWHFCi1n05HdZ058bfjQ8PU=
X-Received: by 2002:ac8:5d49:0:b0:4a9:e17a:6288 with SMTP id
 d75a77b69052e-4af164545a3mr11164561cf.13.1754319353286; Mon, 04 Aug 2025
 07:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <20250731154442.319568-1-surenb@google.com> <d2b6be85-44d5-4a87-bfe5-4a9e80f95bb8@redhat.com>
 <aIzMGlrR1SL5Y_Gp@x1.local> <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
 <aIzp6WqdzhomPhhf@x1.local> <CAJuCfpGWLnu+r2wvY2Egy2ESPD=tAVvfVvAKXUv1b+Z0hweeJg@mail.gmail.com>
 <aIz1xrzBc2Spa2OH@x1.local> <CAJuCfpFJGaDaFyNLa3JsVh19NWLGNGo1ebC_ijGTgPGNyfUFig@mail.gmail.com>
 <aI0Ffc9WXeU2X71O@x1.local> <CAJuCfpFSY3fDH36dabS=nGzasZJ6FtQ_jv79eFWVZrEWRMMTiQ@mail.gmail.com>
 <aI1ckD3KhNvoMtlv@x1.local>
In-Reply-To: <aI1ckD3KhNvoMtlv@x1.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 4 Aug 2025 07:55:42 -0700
X-Gm-Features: Ac12FXwkRUWkV-jJnrAxc_KCFlt2tCP7J8Se807K09k1g_kAOLYNYQ8rg9aNU7I
Message-ID: <CAJuCfpHcScutgGi3imYTJVXBqs=jcqZ5CkKKe=sfVHjUg0Y6RQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] userfaultfd: fix a crash when UFFDIO_MOVE handles
 a THP hole
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: D8A911C0013
X-Rspamd-Server: rspam06
X-Stat-Signature: 7tfoyqeo8bnrwqx4f8a7gpsu6sd49pd5
X-HE-Tag: 1754319354-357927
X-HE-Meta: U2FsdGVkX1//4bhtkneyc7Vs3s6F3PyC/KG8pN0UQIGgskkEsoA3+IAuSdFC9UMufnB0J525khLH1wlt/hSISAC1v8kHp8qQTxx2+1RWxuzlPmoPKRtu+fXcANK7gQmQY2DiBMR3Y26h55Gs76sSmwsnisfcCWlAlJWwl+sc08EpNuer49t2z2V4IbAvAVznlCXQkVfiXzBTF4BXZwRQyjmwjeCCbcD6Nu2lHIGh/JzS65y359sZl6l8+ETkvnojC4fxWIqk4u6wSR48SJXhwmII8MpvApd9PUGFIIpeiK0HNQz0fAnAySrpFwS4+7W6fTmm7E5dpEaM99bU0C3ooyElKdrIVVg/Ae53C0F5UUYHNzmQW87mORwM44p2ckgh1BmHDYoypbxPOPPteuP9kEqM/mr2moTwPDnRwViMKjt0S27KppV6+h2JH8S2OL4yGtyOZSaF7hrNdWl3bFb5pc81bAuYbFFPBl3CB7etvu/7j0qJj97ygkbLb7sUPTQhAWCxe/tKejiMnvjW9N0OaOCqMykCGuu1FmymM9MFJfvK/7hwe4Gevtwuj5xzYsBhEjTdcxitvgcI5sdI27GAc/z1A1KcP+pBuYvCQm0BJs0mp8QyZ0F6zM5PgpTNZe9G0mbVSn98zQ7Qls4JkSIm+ZZx/qGkhqRCIzCuEQfJMko8loladIxe/1sC1obBy9jf/gXi8febFUetv7D7ssqzeegudMBnx7ODax8mM4mB3rPwTVqEUuLf5sTxdEe0mjGphxXpMjLIHZ0Ju889Y7EaRlFPdyyUcqw8f3pytTXX5oAqhqkNvKSiGwPRPBtU1TTibqGDanVqaCBcr/mQjZ39/7iVbl0bPDyjYWInaTydPYfuIluBCwPjmMtolhgNUMtWss6wwdPkBqf27BjCMW4bTDsYV04LyP29i1QTfS6sVNLbJL1IX1hhNOuTwll7IHNgX/87hwrFXWr6UzvNhyZ
 aTLOfzRv
 PHxDTVCV6b/6/h8cMiXcqcCOlWd14iZOzozT3C4NN1hbSLrM87TZ46o99Zo49NUqyxK5eWkw4//iiyQ97T0mHBgIfJvynACgI9FRkDeRnKmbB44HjDICM97hqqutCUEY8CXBH9tUVbQgiRVCh0IfjiHDmJ5L2RUtFfc9QCeo9uskciZ3o9JFQPeEfgzfGfhP4AV6LxBi67Rdqxj+NdemsWzC8cunEWyjTC6aWwzA7vTJP/iEaYwwVGvnAuIjMQbsWLbHDpNMlFjjelyYI48FPmbRAXcL2X1g90w5NBWsiopB6xOxae9u5EURVBzAj4NS3yQs3rHJIjKde2NlXQ2djwYJiV4PzAWT+Prh/iZ2uNAeIL64i0znOaffxHoDLfa0G2LDIJCnC3c9qJb4EUMqXhgUsXreklquzWyqyLcPiw97C82CorkrAHU2lSvU8ROYK6by4vPlx6CaLeuUV/KZ72HW6yfkmx7E0K22JNVAfYCbzxIw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 5:32=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Aug 01, 2025 at 07:30:02PM +0000, Suren Baghdasaryan wrote:
> > On Fri, Aug 1, 2025 at 6:21=E2=80=AFPM Peter Xu <peterx@redhat.com> wro=
te:
> > >
> > > On Fri, Aug 01, 2025 at 05:45:10PM +0000, Suren Baghdasaryan wrote:
> > > > On Fri, Aug 1, 2025 at 5:13=E2=80=AFPM Peter Xu <peterx@redhat.com>=
 wrote:
> > > > >
> > > > > On Fri, Aug 01, 2025 at 09:41:31AM -0700, Suren Baghdasaryan wrot=
e:
> > > > > > On Fri, Aug 1, 2025 at 9:23=E2=80=AFAM Peter Xu <peterx@redhat.=
com> wrote:
> > > > > > >
> > > > > > > On Fri, Aug 01, 2025 at 08:28:38AM -0700, Suren Baghdasaryan =
wrote:
> > > > > > > > On Fri, Aug 1, 2025 at 7:16=E2=80=AFAM Peter Xu <peterx@red=
hat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hildenbra=
nd wrote:
> > > > > > > > > > On 31.07.25 17:44, Suren Baghdasaryan wrote:
> > > > > > > > > >
> > > > > > > > > > Hi!
> > > > > > > > > >
> > > > > > > > > > Did you mean in you patch description:
> > > > > > > > > >
> > > > > > > > > > "userfaultfd: fix a crash in UFFDIO_MOVE with some non-=
present PMDs"
> > > > > > > > > >
> > > > > > > > > > Talking about THP holes is very very confusing.
> > > > > > > > > >
> > > > > > > > > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_=
SRC_HOLES and it
> > > > > > > > > > > encounters a non-present THP, it fails to properly re=
cognize an unmapped
> > > > > > > > > >
> > > > > > > > > > You mean a "non-present PMD that is not a migration ent=
ry".
> > > > > > > > > >
> > > > > > > > > > > hole and tries to access a non-existent folio, result=
ing in
> > > > > > > > > > > a crash. Add a check to skip non-present THPs.
> > > > > > > > > >
> > > > > > > > > > That makes sense. The code we have after this patch is =
rather complicated
> > > > > > > > > > and hard to read.
> > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> > > > > > > > > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.ap=
pspotmail.com
> > > > > > > > > > > Closes: https://lore.kernel.org/all/68794b5c.a70a0220=
.693ce.0050.GAE@google.com/
> > > > > > > > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > > > > ---
> > > > > > > > > > > Changes since v1 [1]
> > > > > > > > > > > - Fixed step size calculation, per Lokesh Gidra
> > > > > > > > > > > - Added missing check for UFFDIO_MOVE_MODE_ALLOW_SRC_=
HOLES, per Lokesh Gidra
> > > > > > > > > > >
> > > > > > > > > > > [1] https://lore.kernel.org/all/20250730170733.382926=
7-1-surenb@google.com/
> > > > > > > > > > >
> > > > > > > > > > >   mm/userfaultfd.c | 45 +++++++++++++++++++++++++++++=
----------------
> > > > > > > > > > >   1 file changed, 29 insertions(+), 16 deletions(-)
> > > > > > > > > > >
> > > > > > > > > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > > > > > > > > > index cbed91b09640..b5af31c22731 100644
> > > > > > > > > > > --- a/mm/userfaultfd.c
> > > > > > > > > > > +++ b/mm/userfaultfd.c
> > > > > > > > > > > @@ -1818,28 +1818,41 @@ ssize_t move_pages(struct use=
rfaultfd_ctx *ctx, unsigned long dst_start,
> > > > > > > > > > >             ptl =3D pmd_trans_huge_lock(src_pmd, src_=
vma);
> > > > > > > > > > >             if (ptl) {
> > > > > > > > > > > -                   /* Check if we can move the pmd w=
ithout splitting it. */
> > > > > > > > > > > -                   if (move_splits_huge_pmd(dst_addr=
, src_addr, src_start + len) ||
> > > > > > > > > > > -                       !pmd_none(dst_pmdval)) {
> > > > > > > > > > > -                           struct folio *folio =3D p=
md_folio(*src_pmd);
> > > > > > > > > > > +                   if (pmd_present(*src_pmd) || is_p=
md_migration_entry(*src_pmd)) {
> > > > > > > > >
> > > > > > > > > [1]
> > > > > > > > >
> > > > > > > > > > > +                           /* Check if we can move t=
he pmd without splitting it. */
> > > > > > > > > > > +                           if (move_splits_huge_pmd(=
dst_addr, src_addr, src_start + len) ||
> > > > > > > > > > > +                               !pmd_none(dst_pmdval)=
) {
> > > > > > > > > > > +                                   if (pmd_present(*=
src_pmd)) {
> > > > > > >
> > > > > > > [2]
> > > > > > >
> > > > > > > > > > > +                                           struct fo=
lio *folio =3D pmd_folio(*src_pmd);
> > > > > > >
> > > > > > > [3]
> > > > > > >
> > > > > > > > > > > +
> > > > > > > > > > > +                                           if (!foli=
o || (!is_huge_zero_folio(folio) &&
> > > > > > > > > > > +                                                    =
      !PageAnonExclusive(&folio->page))) {
> > > > > > > > > > > +                                                   s=
pin_unlock(ptl);
> > > > > > > > > > > +                                                   e=
rr =3D -EBUSY;
> > > > > > > > > > > +                                                   b=
reak;
> > > > > > > > > > > +                                           }
> > > > > > > > > > > +                                   }
> > > > > > > > > >
> > > > > > > > > > ... in particular that. Is there some way to make this =
code simpler / easier
> > > > > > > > > > to read? Like moving that whole last folio-check thingy=
 into a helper?
> > > > > > > > >
> > > > > > > > > One question might be relevant is, whether the check abov=
e [1] can be
> > > > > > > > > dropped.
> > > > > > > > >
> > > > > > > > > The thing is __pmd_trans_huge_lock() does double check th=
e pmd to be !none
> > > > > > > > > before returning the ptl.  I didn't follow closely on the=
 recent changes on
> > > > > > > > > mm side on possible new pmd swap entries, if migration is=
 the only possible
> > > > > > > > > one then it looks like [1] can be avoided.
> > > > > > > >
> > > > > > > > Hi Peter,
> > > > > > > > is_swap_pmd() check in __pmd_trans_huge_lock() allows for (=
!pmd_none()
> > > > > > > > && !pmd_present()) PMD to pass and that's when this crash i=
s hit.
> > > > > > >
> > > > > > > First for all, thanks for looking into the issue with Lokesh;=
 I am still
> > > > > > > catching up with emails after taking weeks off.
> > > > > > >
> > > > > > > I didn't yet read into the syzbot report, but I thought the b=
ug was about
> > > > > > > referencing the folio on top of a swap entry after reading yo=
ur current
> > > > > > > patch, which has:
> > > > > > >
> > > > > > >         if (move_splits_huge_pmd(dst_addr, src_addr, src_star=
t + len) ||
> > > > > > >             !pmd_none(dst_pmdval)) {
> > > > > > >                 struct folio *folio =3D pmd_folio(*src_pmd); =
<----
> > > > > > >
> > > > > > > Here looks like *src_pmd can be a migration entry. Is my unde=
rstanding
> > > > > > > correct?
> > > > > >
> > > > > > Correct.
> > > > > >
> > > > > > >
> > > > > > > > If we drop the check at [1] then the path that takes us to
> > > > > > >
> > > > > > > If my above understanding is correct, IMHO it should be [2] a=
bove that
> > > > > > > makes sure the reference won't happen on a swap entry, not ne=
cessarily [1]?
> > > > > >
> > > > > > Yes, in case of migration entry this is what protects us.
> > > > > >
> > > > > > >
> > > > > > > > split_huge_pmd() will bail out inside split_huge_pmd_locked=
() with no
> > > > > > > > indication that split did not happen. Afterwards we will re=
try
> > > > > > >
> > > > > > > So we're talking about the case where it's a swap pmd entry, =
right?
> > > > > >
> > > > > > Hmm, my understanding is that it's being treated as a swap entr=
y but
> > > > > > in reality is not. I thought THPs are always split before they =
get
> > > > > > swapped, no?
> > > > >
> > > > > Yes they should be split, afaiu.
> > > > >
> > > > > >
> > > > > > > Could you elaborate why the split would fail?
> > > > > >
> > > > > > Just looking at the code, split_huge_pmd_locked() checks for
> > > > > > (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd)).
> > > > > > pmd_trans_huge() is false if !pmd_present() and it's not a migr=
ation
> > > > > > entry, so __split_huge_pmd_locked() will be skipped.
> > > > >
> > > > > Here might be the major part of where confusion came from: I thou=
ght it
> > > > > must be a migration pmd entry to hit the issue, so it's not?
> > > > >
> > > > > I checked the code just now:
> > > > >
> > > > > __handle_mm_fault:
> > > > >                 if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
> > > > >                         VM_BUG_ON(thp_migration_supported() &&
> > > > >                                           !is_pmd_migration_entry=
(vmf.orig_pmd));
> > > > >
> > > > > So IIUC pmd migration entry is still the only possible way to hav=
e a swap
> > > > > entry.  It doesn't look like we have "real" swap entries for PMD =
(which can
> > > > > further points to some swapfiles)?
> > > >
> > > > Correct. AFAIU here we stumble on a pmd entry which was allocated b=
ut
> > > > never populated.
> > >
> > > Do you mean a pmd_none()?
> >
> > Yes.
> >
> > >
> > > If so, that goes back to my original question, on why
> > > __pmd_trans_huge_lock() returns non-NULL if it's a pmd_none()?  IMHO =
it
> > > really should have returned NULL for pmd_none().
> >
> > That was exactly the answer I gave Lokesh when he theorized about the
> > cause of this crash but after reproducing it I saw that
> > pmd_trans_huge_lock() happily returns the PTL as long as PMD is not
> > pmd_none(). And that's because it passes as is_swap_pmd(). But even if
> > we change that we still need to implement the code to skip the entire
> > PMD.
>
> The thing is I thought if pmd_trans_huge_lock() can return non-NULL, it
> must be either a migration entry or a present THP. So are you describing =
a
> THP but with present bit cleared?  Do you know what is that entry, and wh=
y
> it has present bit cleared?

In this case it's because earlier we allocated that PMD here:
https://elixir.bootlin.com/linux/v6.16/source/mm/userfaultfd.c#L1797
but wouldn't that be the same if the PMD was mapped and then got
unmapped later? My understanding is that we allocate the PMD at the
line I pointed to make UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES case the same
as this unmapped PMD case. If my assumption is incorrect then we could
skip the hole earlier instead of allocating the PMD for it.

>
> I think my attention got attracted to pmd migration entry too much, so I
> didn't really notice such possibility, as I believe migration pmd is brok=
en
> already in this path.
>
> The original code:
>
>                 ptl =3D pmd_trans_huge_lock(src_pmd, src_vma);
>                 if (ptl) {
>                         /* Check if we can move the pmd without splitting=
 it. */
>                         if (move_splits_huge_pmd(dst_addr, src_addr, src_=
start + len) ||
>                             !pmd_none(dst_pmdval)) {
>                                 struct folio *folio =3D pmd_folio(*src_pm=
d);
>
>                                 if (!folio || (!is_huge_zero_folio(folio)=
 &&
>                                                !PageAnonExclusive(&folio-=
>page))) {
>                                         spin_unlock(ptl);
>                                         err =3D -EBUSY;
>                                         break;
>                                 }
>
>                                 spin_unlock(ptl);
>                                 split_huge_pmd(src_vma, src_pmd, src_addr=
);
>                                 /* The folio will be split by move_pages_=
pte() */
>                                 continue;
>                         }
>
>                         err =3D move_pages_huge_pmd(mm, dst_pmd, src_pmd,
>                                                   dst_pmdval, dst_vma, sr=
c_vma,
>                                                   dst_addr, src_addr);
>                         step_size =3D HPAGE_PMD_SIZE;
>                 } else {
>
> It'll get ptl for a migration pmd, then pmd_folio is risky without checki=
ng
> present bit.  That's what my previous smaller patch wanted to fix.
>
> But besides that, IIUC it's all fine at least for a pmd migration entry,
> because when with the smaller patch applied, either we'll try to split th=
e
> pmd migration entry, or we'll do move_pages_huge_pmd(), which internally
> handles the pmd migration entry too by waiting on it:
>
>         if (!pmd_trans_huge(src_pmdval)) {
>                 spin_unlock(src_ptl);
>                 if (is_pmd_migration_entry(src_pmdval)) {
>                         pmd_migration_entry_wait(mm, &src_pmdval);
>                         return -EAGAIN;
>                 }
>                 return -ENOENT;
>         }
>
> Then logically after the migration entry got recovered, we'll either see =
a
> real THP or pmd none next time.

Yes, for migration entries adding the "if (pmd_present(*src_pmd))"
before getting the folio is enough. The problematic case is
(!pmd_none(*src_pmd) && !pmd_present(*src_pmd)) and not a migration
entry.

>
> Some explanation on the problematic non-present THP entry would be helpfu=
l.
>
> Thanks,
>
> --
> Peter Xu
>

