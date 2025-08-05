Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D649C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 20:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98726B008C; Tue,  5 Aug 2025 16:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70266B0092; Tue,  5 Aug 2025 16:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5FDD6B0096; Tue,  5 Aug 2025 16:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B08FB6B008C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:39:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 721F113547D
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:39:51 +0000 (UTC)
X-FDA: 83743870182.11.6FA688A
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7DF0D20006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:39:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y7nxIa1b;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754426389; a=rsa-sha256;
	cv=none;
	b=BT99I4zw1v9wv2ESPZG0uEEroehqLSCo7n+akBHPe97L0mCcvkg5745UFEuRtzXlZiJvh1
	9st6F4w/I46OaMLXUT9lBDj2l6bj5Zn5MfNPoqX7L+RCTgOr5iubNnmMvdsVLYBJP1cX+O
	hDRljhIm1QcMoCCgMs8O/mryLEmSAto=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y7nxIa1b;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754426389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ws5wEIQrIgG6ywlUcYoKz9ceVNplzKwXzoUmtY/yv88=;
	b=untzikQ9Fx1kasBOcRI4uUD0X4tWLrKWgtnHa+Hubpqme98Y7zD+ApCNqbxIZZPxQoll+G
	3Cyv+L45XyfvmAd6QLg52e+B/nDhvVMSFUuAIcwSHOd0wtBvJXZZQWhh25UfVNOm77Z+VO
	sFY0ifbH0StLP3+EN/cQHHFdbGN87rQ=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso19831cf.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 13:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754426388; x=1755031188; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ws5wEIQrIgG6ywlUcYoKz9ceVNplzKwXzoUmtY/yv88=;
        b=y7nxIa1b185BVFduL25j+b4rEEsnMoaKdXmMEWts/uZyFLRzU4Y564p7j9LSwPRgS1
         rafyBnHd9yRs0LkFXickRKjvid4L6WSb80plpzaYTwN6XJULdkDN1oksmRwwTUuDvN3N
         GdkVtRpNhqhMm+Mv+WXoXgPSwfASQpOTNo16++XY1/v5bKp/mUO4Pv40bYb/RQ80kmcl
         GSpevIBawKtmiOPz7+n2X8QQLDSztqrYEnNou65db93HLSS31gAdEPl5moswZYHWB3eM
         tQY2rOXZTULElzvJIF9SxDDSfcjvinJJQ583VdeC6WxxO+3W2lTzK0Y+fJTndyeCbd7h
         5h0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754426388; x=1755031188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ws5wEIQrIgG6ywlUcYoKz9ceVNplzKwXzoUmtY/yv88=;
        b=GGFwhIlPw/F75Vhfg4pMIfQrOvM3nG00BEQUI1iFbucMurHDA3VJhDsBXTttXZZtU4
         LqWdlAGYic69DQPrRB7hFRMyAwiJMDTgtpcmGFmuBpWvARzR4rrbUqcRoMlPbihVJcGN
         GUD9beKJQnFr+SrtkaVSWnmqFeI344bNfIIImKzjMvs0yJPxFvpjXHXnELnlRCJIYWVj
         RQqLh2Uahc0oohzp/RAiit1v3CUSNneCAynOio9udMYEJINoMHMtQlitiYAGhToz6Amu
         6geHy3CfcEnK4c1Fejdp1J69v/U+gfrT8JZWcMpuRWX1xzwQnCWxp/V9bUMaBaC10hxn
         PMbA==
X-Forwarded-Encrypted: i=1; AJvYcCVnZbw/PyUE9/pQkft8aiTqbtY+iMdSH0fiVxLh4RQ5yBWyaubcA1LKL6R2yP/YR2zsDGEREEHeKg==@kvack.org
X-Gm-Message-State: AOJu0YzGIBskeKUFIpqBkfXM9Siv4N60/NdkhkzgxSw02IB4w3p8jERG
	hAdCefVGgkjyJJx0ATpJVzh5QRWxtCqpaKhhl2RdbIbVwIHks3wXO1FISJ7wZ4572HWWD+CDEaL
	9FpDx4tlUzS92tLTVk92AfPom3VHt4fBv86COgp3R
X-Gm-Gg: ASbGnctPpO6tISGa4zoBYJf2Vq8um614C2yAEs7dkubYiAM8DJTG2lkWnUjQD0E50ye
	xywTD0FcDdNDmN6QhI7NWa8RDNQMO4X+ZZMq12UkXPFgSGlZVi4wlxWr5046ZaD1qEstRfryIlO
	be9l/N725iAvNaOILLhybwnVzW9U0e9J85NXJ/0eHHCQa7fZHJNC7LrEKdBOfdnte3omOhZA220
	Sc0B28/Q4GMoTgp3Kjf3vWAN/9PH+1uK5Ku8Q==
X-Google-Smtp-Source: AGHT+IEO5RjyJPBcejQNz+/dM8q4vLV7T8XoZnm6OVzQbz8FuEh/yyd5U9jM33WrDfMKtpHtJjSRQbhCn4c3noHSsXM=
X-Received: by 2002:a05:622a:38b:b0:4b0:8318:a95 with SMTP id
 d75a77b69052e-4b0904dbb54mr1100971cf.8.1754426387835; Tue, 05 Aug 2025
 13:39:47 -0700 (PDT)
MIME-Version: 1.0
References: <aIzMGlrR1SL5Y_Gp@x1.local> <CAJuCfpEqOUj8VPybstQjoJvCzyZtG6Q5Vr4WT0Lx_r3LFVS7og@mail.gmail.com>
 <aIzp6WqdzhomPhhf@x1.local> <CAJuCfpGWLnu+r2wvY2Egy2ESPD=tAVvfVvAKXUv1b+Z0hweeJg@mail.gmail.com>
 <aIz1xrzBc2Spa2OH@x1.local> <CAJuCfpFJGaDaFyNLa3JsVh19NWLGNGo1ebC_ijGTgPGNyfUFig@mail.gmail.com>
 <aI0Ffc9WXeU2X71O@x1.local> <CAJuCfpFSY3fDH36dabS=nGzasZJ6FtQ_jv79eFWVZrEWRMMTiQ@mail.gmail.com>
 <aI1ckD3KhNvoMtlv@x1.local> <CAJuCfpHcScutgGi3imYTJVXBqs=jcqZ5CkKKe=sfVHjUg0Y6RQ@mail.gmail.com>
 <aJIXlN-ZD_soWdP0@x1.local> <CAJuCfpFzP_W8i8pwL+-Uv-n+2LixgFrzqn2HsY_h-1kbP=g3JQ@mail.gmail.com>
In-Reply-To: <CAJuCfpFzP_W8i8pwL+-Uv-n+2LixgFrzqn2HsY_h-1kbP=g3JQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 5 Aug 2025 13:39:36 -0700
X-Gm-Features: Ac12FXxzsQACtigd5brOqZB9zjqDNyf6tanOF24PTphgmdFqFi0946_jGYxCbsM
Message-ID: <CAJuCfpFEf92gTR+Jw+1wcCcT0fEt-SP193NHzpyxVXJA=VAwng@mail.gmail.com>
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
X-Rspamd-Queue-Id: 7DF0D20006
X-Stat-Signature: 18r4w961ob5sah374eqo4hddeq5wij6f
X-HE-Tag: 1754426389-250219
X-HE-Meta: U2FsdGVkX19sr9qlzxopWZeWM28F9ArqggB/uk9TNClzhrgR+10rZRuTdP8MikHIC6mNFez121QsHjd9ybBYKqQ8fAE0q8n3dzKOLjhtsIQu1YruQIsQS+V62tND0AJDoam20p5j3v9rnjPF9QjM06Da+DQbFP+Zpzt8Zc1xbvxo7Dvk53mXEWvxXCO5bReBTFaP+xGm7R2yU5UDvNXrV6W50a/jNfge55YOgNsKO4PSJ5i2eY70DiH3frK1u/OU0zdlLdUPWp2aPDU+o/blIcvMobiICNlwuM27ZK3rGcnlG/DRU3Se720c0AscafgMGyow/mDOtmYzoYAWJuyT6sWhm+OUuPsLPbalAWiUAIroGrz5fdZTPtW2+GNnAmyZ6Gh/8M6y23aCedMjM+OPF8tI6+OChm03S2tz6HZYTNWSsXZdiVBE7ZZ4mqGTsMxoD2VsXyhlsb1M2lBRM771fN+xiJxhvXnAcP7G90RwKx0f7NO2e9II6VApucjhaEyJlUU1LbKDr0v9/pdyYIO6Jr2b+N3/fcbdjKBtVHyFKJ1lTSOj+0ld6hyUZ/HUpc65BRlGgJBHbCQ8mODklzLnnMUjCLfKxC7bHap+tWjYOiHp6WAwgEhLoUDttMTCgdVUCRbaJZjkOa3yQp/zBzCKZN7sivAczjRLodvwnVaet+aXJUR4jhIJgxevPLkraRb890lrNk6zL+monWSlVi+7mmpR/GNZCvFKkyIjbzOEwsXpvk1NFuE5KJBZGxhXbiKSjng8gLxr90FfbpTUkdvZst5fYtckBPf1eTN9oFkOJZd8HKT8TDwe1XhZ+bwCe1L92DLeJV07qjDIaNYCNAHo44kdIKSW6Va/PqUU5wrBtfzVr1cF39GmH5C3cAxXlDduNQAh2mWnvxk2c4wFcruVrYS+BfrxM1gzDXPu9ttKoWHmhC/RJv/oso+1KWNhvFbD0SLzAl9QUks0g9+PqoZ
 a7cmymax
 Cbmp3ampPsI/bsRbdYq8ZX8uGW8Ts1V9UVlSfhaJsHWFtYzBe3EgpZLk36T9zsjQ6i1ToXRnSfirP1kWoAMNxhhgpdqWUnrvF7jOY6inf2DP+Al4xXf7noz871romfOw4YE9MTwdA0lQNNybrpMGboc0N+I3VZFzYdFkpJoZcXEl8jywV3gS5BwKy/4YVRZxkeAQ/eyZOco7pb5FBoSVVG3vKqjUQJaON7oX+XU4QFkoy4GbVe5f9nM+jCyCQoCyJ9J0YAbA4J+zHCe33eP4VUFBvoxyoRGlhwaO8gYWt9U+bWedeAxtooLMUCCa35DH8PzItJ+YpaQUd2nJ8RX3OpU3Qc5rBXz5yjmWn0tK83LUH0zeBunQLaVrT7Th3kcO9x8NNgXOfxbsKLTLpos5+DAS6xtF7yZbIHDRIh5tpfae6iCRYJ0bXrRNPW4LmBTutmLA91GS8pw9DLtn0uWK9YAhrYkT6Bn4wDopBkik9NK1PxL4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 7:57=E2=80=AFAM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> On Tue, Aug 5, 2025 at 7:39=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote=
:
> >
> > On Mon, Aug 04, 2025 at 07:55:42AM -0700, Suren Baghdasaryan wrote:
> > > On Fri, Aug 1, 2025 at 5:32=E2=80=AFPM Peter Xu <peterx@redhat.com> w=
rote:
> > > >
> > > > On Fri, Aug 01, 2025 at 07:30:02PM +0000, Suren Baghdasaryan wrote:
> > > > > On Fri, Aug 1, 2025 at 6:21=E2=80=AFPM Peter Xu <peterx@redhat.co=
m> wrote:
> > > > > >
> > > > > > On Fri, Aug 01, 2025 at 05:45:10PM +0000, Suren Baghdasaryan wr=
ote:
> > > > > > > On Fri, Aug 1, 2025 at 5:13=E2=80=AFPM Peter Xu <peterx@redha=
t.com> wrote:
> > > > > > > >
> > > > > > > > On Fri, Aug 01, 2025 at 09:41:31AM -0700, Suren Baghdasarya=
n wrote:
> > > > > > > > > On Fri, Aug 1, 2025 at 9:23=E2=80=AFAM Peter Xu <peterx@r=
edhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Fri, Aug 01, 2025 at 08:28:38AM -0700, Suren Baghdas=
aryan wrote:
> > > > > > > > > > > On Fri, Aug 1, 2025 at 7:16=E2=80=AFAM Peter Xu <pete=
rx@redhat.com> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > On Fri, Aug 01, 2025 at 09:21:30AM +0200, David Hil=
denbrand wrote:
> > > > > > > > > > > > > On 31.07.25 17:44, Suren Baghdasaryan wrote:
> > > > > > > > > > > > >
> > > > > > > > > > > > > Hi!
> > > > > > > > > > > > >
> > > > > > > > > > > > > Did you mean in you patch description:
> > > > > > > > > > > > >
> > > > > > > > > > > > > "userfaultfd: fix a crash in UFFDIO_MOVE with som=
e non-present PMDs"
> > > > > > > > > > > > >
> > > > > > > > > > > > > Talking about THP holes is very very confusing.
> > > > > > > > > > > > >
> > > > > > > > > > > > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_=
ALLOW_SRC_HOLES and it
> > > > > > > > > > > > > > encounters a non-present THP, it fails to prope=
rly recognize an unmapped
> > > > > > > > > > > > >
> > > > > > > > > > > > > You mean a "non-present PMD that is not a migrati=
on entry".
> > > > > > > > > > > > >
> > > > > > > > > > > > > > hole and tries to access a non-existent folio, =
resulting in
> > > > > > > > > > > > > > a crash. Add a check to skip non-present THPs.
> > > > > > > > > > > > >
> > > > > > > > > > > > > That makes sense. The code we have after this pat=
ch is rather complicated
> > > > > > > > > > > > > and hard to read.
> > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE =
uABI")
> > > > > > > > > > > > > > Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkal=
ler.appspotmail.com
> > > > > > > > > > > > > > Closes: https://lore.kernel.org/all/68794b5c.a7=
0a0220.693ce.0050.GAE@google.com/
> > > > > > > > > > > > > > Signed-off-by: Suren Baghdasaryan <surenb@googl=
e.com>
> > > > > > > > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > > > > > > > ---
> > > > > > > > > > > > > > Changes since v1 [1]
> > > > > > > > > > > > > > - Fixed step size calculation, per Lokesh Gidra
> > > > > > > > > > > > > > - Added missing check for UFFDIO_MOVE_MODE_ALLO=
W_SRC_HOLES, per Lokesh Gidra
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > [1] https://lore.kernel.org/all/20250730170733.=
3829267-1-surenb@google.com/
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >   mm/userfaultfd.c | 45 +++++++++++++++++++++++=
++++++----------------
> > > > > > > > > > > > > >   1 file changed, 29 insertions(+), 16 deletion=
s(-)
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.=
c
> > > > > > > > > > > > > > index cbed91b09640..b5af31c22731 100644
> > > > > > > > > > > > > > --- a/mm/userfaultfd.c
> > > > > > > > > > > > > > +++ b/mm/userfaultfd.c
> > > > > > > > > > > > > > @@ -1818,28 +1818,41 @@ ssize_t move_pages(stru=
ct userfaultfd_ctx *ctx, unsigned long dst_start,
> > > > > > > > > > > > > >             ptl =3D pmd_trans_huge_lock(src_pmd=
, src_vma);
> > > > > > > > > > > > > >             if (ptl) {
> > > > > > > > > > > > > > -                   /* Check if we can move the=
 pmd without splitting it. */
> > > > > > > > > > > > > > -                   if (move_splits_huge_pmd(ds=
t_addr, src_addr, src_start + len) ||
> > > > > > > > > > > > > > -                       !pmd_none(dst_pmdval)) =
{
> > > > > > > > > > > > > > -                           struct folio *folio=
 =3D pmd_folio(*src_pmd);
> > > > > > > > > > > > > > +                   if (pmd_present(*src_pmd) |=
| is_pmd_migration_entry(*src_pmd)) {
> > > > > > > > > > > >
> > > > > > > > > > > > [1]
> > > > > > > > > > > >
> > > > > > > > > > > > > > +                           /* Check if we can =
move the pmd without splitting it. */
> > > > > > > > > > > > > > +                           if (move_splits_hug=
e_pmd(dst_addr, src_addr, src_start + len) ||
> > > > > > > > > > > > > > +                               !pmd_none(dst_p=
mdval)) {
> > > > > > > > > > > > > > +                                   if (pmd_pre=
sent(*src_pmd)) {
> > > > > > > > > >
> > > > > > > > > > [2]
> > > > > > > > > >
> > > > > > > > > > > > > > +                                           str=
uct folio *folio =3D pmd_folio(*src_pmd);
> > > > > > > > > >
> > > > > > > > > > [3]
> > > > > > > > > >
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > > +                                           if =
(!folio || (!is_huge_zero_folio(folio) &&
> > > > > > > > > > > > > > +                                              =
            !PageAnonExclusive(&folio->page))) {
> > > > > > > > > > > > > > +                                              =
     spin_unlock(ptl);
> > > > > > > > > > > > > > +                                              =
     err =3D -EBUSY;
> > > > > > > > > > > > > > +                                              =
     break;
> > > > > > > > > > > > > > +                                           }
> > > > > > > > > > > > > > +                                   }
> > > > > > > > > > > > >
> > > > > > > > > > > > > ... in particular that. Is there some way to make=
 this code simpler / easier
> > > > > > > > > > > > > to read? Like moving that whole last folio-check =
thingy into a helper?
> > > > > > > > > > > >
> > > > > > > > > > > > One question might be relevant is, whether the chec=
k above [1] can be
> > > > > > > > > > > > dropped.
> > > > > > > > > > > >
> > > > > > > > > > > > The thing is __pmd_trans_huge_lock() does double ch=
eck the pmd to be !none
> > > > > > > > > > > > before returning the ptl.  I didn't follow closely =
on the recent changes on
> > > > > > > > > > > > mm side on possible new pmd swap entries, if migrat=
ion is the only possible
> > > > > > > > > > > > one then it looks like [1] can be avoided.
> > > > > > > > > > >
> > > > > > > > > > > Hi Peter,
> > > > > > > > > > > is_swap_pmd() check in __pmd_trans_huge_lock() allows=
 for (!pmd_none()
> > > > > > > > > > > && !pmd_present()) PMD to pass and that's when this c=
rash is hit.
> > > > > > > > > >
> > > > > > > > > > First for all, thanks for looking into the issue with L=
okesh; I am still
> > > > > > > > > > catching up with emails after taking weeks off.
> > > > > > > > > >
> > > > > > > > > > I didn't yet read into the syzbot report, but I thought=
 the bug was about
> > > > > > > > > > referencing the folio on top of a swap entry after read=
ing your current
> > > > > > > > > > patch, which has:
> > > > > > > > > >
> > > > > > > > > >         if (move_splits_huge_pmd(dst_addr, src_addr, sr=
c_start + len) ||
> > > > > > > > > >             !pmd_none(dst_pmdval)) {
> > > > > > > > > >                 struct folio *folio =3D pmd_folio(*src_=
pmd); <----
> > > > > > > > > >
> > > > > > > > > > Here looks like *src_pmd can be a migration entry. Is m=
y understanding
> > > > > > > > > > correct?
> > > > > > > > >
> > > > > > > > > Correct.
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > If we drop the check at [1] then the path that takes =
us to
> > > > > > > > > >
> > > > > > > > > > If my above understanding is correct, IMHO it should be=
 [2] above that
> > > > > > > > > > makes sure the reference won't happen on a swap entry, =
not necessarily [1]?
> > > > > > > > >
> > > > > > > > > Yes, in case of migration entry this is what protects us.
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > split_huge_pmd() will bail out inside split_huge_pmd_=
locked() with no
> > > > > > > > > > > indication that split did not happen. Afterwards we w=
ill retry
> > > > > > > > > >
> > > > > > > > > > So we're talking about the case where it's a swap pmd e=
ntry, right?
> > > > > > > > >
> > > > > > > > > Hmm, my understanding is that it's being treated as a swa=
p entry but
> > > > > > > > > in reality is not. I thought THPs are always split before=
 they get
> > > > > > > > > swapped, no?
> > > > > > > >
> > > > > > > > Yes they should be split, afaiu.
> > > > > > > >
> > > > > > > > >
> > > > > > > > > > Could you elaborate why the split would fail?
> > > > > > > > >
> > > > > > > > > Just looking at the code, split_huge_pmd_locked() checks =
for
> > > > > > > > > (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd)).
> > > > > > > > > pmd_trans_huge() is false if !pmd_present() and it's not =
a migration
> > > > > > > > > entry, so __split_huge_pmd_locked() will be skipped.
> > > > > > > >
> > > > > > > > Here might be the major part of where confusion came from: =
I thought it
> > > > > > > > must be a migration pmd entry to hit the issue, so it's not=
?
> > > > > > > >
> > > > > > > > I checked the code just now:
> > > > > > > >
> > > > > > > > __handle_mm_fault:
> > > > > > > >                 if (unlikely(is_swap_pmd(vmf.orig_pmd))) {
> > > > > > > >                         VM_BUG_ON(thp_migration_supported()=
 &&
> > > > > > > >                                           !is_pmd_migration=
_entry(vmf.orig_pmd));
> > > > > > > >
> > > > > > > > So IIUC pmd migration entry is still the only possible way =
to have a swap
> > > > > > > > entry.  It doesn't look like we have "real" swap entries fo=
r PMD (which can
> > > > > > > > further points to some swapfiles)?
> > > > > > >
> > > > > > > Correct. AFAIU here we stumble on a pmd entry which was alloc=
ated but
> > > > > > > never populated.
> > > > > >
> > > > > > Do you mean a pmd_none()?
> > > > >
> > > > > Yes.
> > > > >
> > > > > >
> > > > > > If so, that goes back to my original question, on why
> > > > > > __pmd_trans_huge_lock() returns non-NULL if it's a pmd_none()? =
 IMHO it
> > > > > > really should have returned NULL for pmd_none().
> > > > >
> > > > > That was exactly the answer I gave Lokesh when he theorized about=
 the
> > > > > cause of this crash but after reproducing it I saw that
> > > > > pmd_trans_huge_lock() happily returns the PTL as long as PMD is n=
ot
> > > > > pmd_none(). And that's because it passes as is_swap_pmd(). But ev=
en if
> > > > > we change that we still need to implement the code to skip the en=
tire
> > > > > PMD.
> > > >
> > > > The thing is I thought if pmd_trans_huge_lock() can return non-NULL=
, it
> > > > must be either a migration entry or a present THP. So are you descr=
ibing a
> > > > THP but with present bit cleared?  Do you know what is that entry, =
and why
> > > > it has present bit cleared?
> > >
> > > In this case it's because earlier we allocated that PMD here:
> > > https://elixir.bootlin.com/linux/v6.16/source/mm/userfaultfd.c#L1797
> >
> > AFAIU, this line is not about allocation of any pmd entry, but the pmd
> > pgtable page that _holds_ the PMDs:
> >
> > static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsign=
ed long address)
> > {
> >         return (unlikely(pud_none(*pud)) && __pmd_alloc(mm, pud, addres=
s))?
> >                 NULL: pmd_offset(pud, address);
> > }
> >
> > It makes sure the PUD entry, not the PMD entry, be populated.
>
> Hmm. Then I was reading this code completely wrong and need to rethink
> what is happening here.
>
> >
> > > but wouldn't that be the same if the PMD was mapped and then got
> > > unmapped later? My understanding is that we allocate the PMD at the
> > > line I pointed to make UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES case the same
> > > as this unmapped PMD case. If my assumption is incorrect then we coul=
d
> > > skip the hole earlier instead of allocating the PMD for it.
> > >
> > > >
> > > > I think my attention got attracted to pmd migration entry too much,=
 so I
> > > > didn't really notice such possibility, as I believe migration pmd i=
s broken
> > > > already in this path.
> > > >
> > > > The original code:
> > > >
> > > >                 ptl =3D pmd_trans_huge_lock(src_pmd, src_vma);
> > > >                 if (ptl) {
> > > >                         /* Check if we can move the pmd without spl=
itting it. */
> > > >                         if (move_splits_huge_pmd(dst_addr, src_addr=
, src_start + len) ||
> > > >                             !pmd_none(dst_pmdval)) {
> > > >                                 struct folio *folio =3D pmd_folio(*=
src_pmd);
> > > >
> > > >                                 if (!folio || (!is_huge_zero_folio(=
folio) &&
> > > >                                                !PageAnonExclusive(&=
folio->page))) {
> > > >                                         spin_unlock(ptl);
> > > >                                         err =3D -EBUSY;
> > > >                                         break;
> > > >                                 }
> > > >
> > > >                                 spin_unlock(ptl);
> > > >                                 split_huge_pmd(src_vma, src_pmd, sr=
c_addr);
> > > >                                 /* The folio will be split by move_=
pages_pte() */
> > > >                                 continue;
> > > >                         }
> > > >
> > > >                         err =3D move_pages_huge_pmd(mm, dst_pmd, sr=
c_pmd,
> > > >                                                   dst_pmdval, dst_v=
ma, src_vma,
> > > >                                                   dst_addr, src_add=
r);
> > > >                         step_size =3D HPAGE_PMD_SIZE;
> > > >                 } else {
> > > >
> > > > It'll get ptl for a migration pmd, then pmd_folio is risky without =
checking
> > > > present bit.  That's what my previous smaller patch wanted to fix.
> > > >
> > > > But besides that, IIUC it's all fine at least for a pmd migration e=
ntry,
> > > > because when with the smaller patch applied, either we'll try to sp=
lit the
> > > > pmd migration entry, or we'll do move_pages_huge_pmd(), which inter=
nally
> > > > handles the pmd migration entry too by waiting on it:
> > > >
> > > >         if (!pmd_trans_huge(src_pmdval)) {
> > > >                 spin_unlock(src_ptl);
> > > >                 if (is_pmd_migration_entry(src_pmdval)) {
> > > >                         pmd_migration_entry_wait(mm, &src_pmdval);
> > > >                         return -EAGAIN;
> > > >                 }
> > > >                 return -ENOENT;
> > > >         }
> > > >
> > > > Then logically after the migration entry got recovered, we'll eithe=
r see a
> > > > real THP or pmd none next time.
> > >
> > > Yes, for migration entries adding the "if (pmd_present(*src_pmd))"
> > > before getting the folio is enough. The problematic case is
> > > (!pmd_none(*src_pmd) && !pmd_present(*src_pmd)) and not a migration
> > > entry.
> >
> > I thought we could have any of below here on the pmd entry:
> >
> >   (0) pmd_none, which should constantly have pmd_trans_huge_lock -> NUL=
L
> >
> >   (1) pmd pgtable entry, which must have PRESENT && !TRANS, so
> >   pmd_trans_huge_lock -> NULL,
> >
> >   (2) pmd migration, pmd_trans_huge_lock -> valid
> >
> >   (3) pmd thp, pmd_trans_huge_lock -> valid
> >
> > I thought (2) was broken, which we seem to agree upon.. however if so t=
he
> > smaller patch should fix it, per explanation in my previous reply.  OTO=
H I
> > can't think of (4).
>
> The case I was hitting is (!pmd_none && !pmd_present &&
> !is_pmd_migration_entry). My original thinking was that this entry was
> newly allocated at the line I pointed earlier but now I'm not so sure
> anymore.

Hmm, now I can't reproduce this case... I'm pretty sure I've seen that
case before but now I hit an occasional migration entry and that's
all. I must have done something wrong when testing it before.

>
> >
> > Said that, I just noticed (3) can be broken as well - could it be a
> > prot_none entry?  The very confusing part of this patch is it seems to
> > think it's pmd_none() here as holes:
> >
> >         if (pmd_present(*src_pmd) || is_pmd_migration_entry(*src_pmd)) =
{
> >                 ...
> >         } else {
> >                 spin_unlock(ptl);
> >                 if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES)) {
> >                         err =3D -ENOENT;
> >                         break;
> >                 }
> >                 /* nothing to do to move a hole */
> >                 err =3D 0;
> >                 step_size =3D min(HPAGE_PMD_SIZE, src_start + len - src=
_addr);
> >         }
> >
> > But is it really?  Again, I don't think pmd_none() could happen with
> > pmd_trans_huge_lock() returning the ptl.
>
> That is true, in the pmd_none() case pmd_trans_huge_lock() returns NULL.
>
> >
> > Could you double check this?  E.g. with this line if that makes sense t=
o
> > you:
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 8bf8ff0be990f..d2d4f2a0ae69f 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1903,6 +1903,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, u=
nsigned long dst_start,
> >                                                           dst_addr, src=
_addr);
> >                                 step_size =3D HPAGE_PMD_SIZE;
> >                         } else {
> > +                               BUG_ON(!pmd_none(*src_pmd));
> >                                 spin_unlock(ptl);
> >                                 if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC=
_HOLES)) {
> >                                         err =3D -ENOENT;
> >
> > I would expect it constantly BUG() here, if that explains my thoughts.
>
> I'll add this and check.

This check does trigger and I logged pmd_val=3D0x8b3714067 and I think
this is normal. _PAGE_BIT_PRESENT is set and _PAGE_BIT_PSE is not set,
so is_swap_pmd()=3D=3Dfalse and pmd_trans_huge()=3D=3Dfalse, therefore
pmd_trans_huge_lock() returns NULL.


>
> >
> > Now I doubt it's a prot_none THP.. aka, a THP that got numa hint to be
> > moved.  If so, we may need to process it / move it / .. but we likely
> > should never skip it.  We can double check the buggy pmd entry you hit
> > (besides migration entry) first.
>
> Let me log the flags of the entry when this issue happens. That should
> provide more insights.
> Thanks,
> Suren.
>
> >
> > Thanks,
> >
> > --
> > Peter Xu
> >

