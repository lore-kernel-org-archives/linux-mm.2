Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D135D3514A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6188D6B0089; Wed,  1 Apr 2026 03:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA326B008A; Wed,  1 Apr 2026 03:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF8F6B0092; Wed,  1 Apr 2026 03:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3A16B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:10:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F18D91B861C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:10:24 +0000 (UTC)
X-FDA: 84609113568.17.078EB36
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id E07DF1C000C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:10:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Y/ULCIg1";
	spf=pass (imf18.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775027422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9IDtRLIbhkJax9pZlIS106eYJzTeVArPppd84gRGp4Y=;
	b=Qm06FxtZCnSoItPgz0P7AfP7B3P/2i+5OCidS5lf1jhxugkxDVIgEOZYjStDFZ9n4gTCKd
	nGytYHml8MNnCf9cf+YLzREjoGZ2/PE0n0nMAsQyYG0D0E4Vg6a3ueofhnZjkhX70uQ6F9
	QzYkToSTQ0Sv/fTNqtEfAPwvBRKpXu8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Y/ULCIg1";
	spf=pass (imf18.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775027422; a=rsa-sha256;
	cv=pass;
	b=DMndSB0UjK/ZJjfjvmx49Vmq58Rjac/FrKtoZzwtrn1a5nqs9E1zeGkbT4pg3l6vGqiOt0
	iiTtl7jVBae0M9m1H1d1Kag7yqQ4/Qgz9TipaB+NrO0VKWiyM4d5qQd71i2U+WrVI9tq43
	gFqB4R810CbypF6e6c2UDmQRPcCDab4=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-794719afcd4so34215487b3.1
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 00:10:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775027422; cv=none;
        d=google.com; s=arc-20240605;
        b=hFYv6ZZgwg7IvZNGlr5QZd/jIlRXcjTGpNQa8zWw9jK+1/UnxDabymKp+skdhOEPA9
         igEFyUd8ECRzcSg2NZpxkylthFGq20mLd/cxwoJyOgMQ48QWlwh83Zv1Rum/9enCgJcE
         Gabm9UZGPIyj52aHgkk8wmw/bl4EkzHSRf3s8J2cQLp0LTdfHN848r8BTspIJB6CLghC
         SN0vEenNizz+BD92YCd6WEN//0DTbyxXxo6Gn1GK4xgxcpekBeFRl6kPa363Qp1+BXc3
         CqcIKtFdnJ29u8Le5dI+yeKR+VtNJK7ha3BGyksBO2+a7NdH+eStuB/XRDS/qJvvoJoa
         /B5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9IDtRLIbhkJax9pZlIS106eYJzTeVArPppd84gRGp4Y=;
        fh=meCTCE3QK3nN8FShFKql4Amv3CoLb7sHyBqxuoDI6A8=;
        b=anKEA7nKwXK7R2v9dPjXDW4hpeEKAFx2bhWqBfk2fbG14DzW4786X1qOEqCGd8VQTx
         i/CKoLo9O6Aibq5LSl/nFdnowob3bK38pGK4Ff9dQqQSiNb61aMqRwVuXk/O3E+lLrV7
         HLtOPQuapZGlRO7WJd0cafMJ/BnEQxAUEUizOwx16eBQT+H4hHAYwLLUBKEnBBePb/KI
         9y1Akauv9VskhQM6FABhYAUKf1WvIGvYiY1uZ8a+5fKFTYJLpl+UjV29M2H1XzeoktXX
         Ksyd8qaDF5LOE3qGeGlvZuN+hD8JVJYAM7Mbd/vZbj2p/qRi8IJOhd1DztoQi7q7pAxe
         Y9/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775027422; x=1775632222; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9IDtRLIbhkJax9pZlIS106eYJzTeVArPppd84gRGp4Y=;
        b=Y/ULCIg1kQPb4Ot9IhRq2o0w0ZcTMMhDHagfRKH5fkb2DDaLPyvOYsia6g10Nalvo3
         qoIMr/9sZ/YUoRyGMC38+2XDjym3gLWopQQTHOKWdXDhslaVMBYyjOQadTyzaNP7sags
         M+VCWGp8AWFwItq13Z9uokKljnrtmt7syL0M5OribOmO+evL5o/bhO75GozRkoM9lOWc
         40OzdW8HEmgd2Ps5xYF5tW2jHOovDocXTXuqzgjLLr7MOQc6rPx6YOHJQaNVzYN1ViTE
         2spt++IB80/ZjZblwGuZ731y3kB5GTxQdX0iFjUbV3qP+nnp5hfJCJ8fXwKS63jsCgxu
         OdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775027422; x=1775632222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9IDtRLIbhkJax9pZlIS106eYJzTeVArPppd84gRGp4Y=;
        b=bzXmN1J/53uHU0kIJEfKPvx6TzQTFw+UXJs3pBUvOS2Wypt9V+TPTgkUkyYbWYkfbX
         +SB3H71Zsfc/z2ICGdD/Bfxjh3QAyWhJz2Wh53PTl6jHgH3kyOab7pDk7kT15bL8i1ic
         /8MZo1Nw0wClW+KUOWNGkEGqkEN6cEvpl9zjVBnlXmdJ1zNy20uFPQkSGnjvUjP9n5ym
         MppiGycZXyVQfSrWVDFI1Ax7Rr3cWAYCMjZmINJgFzTEMOVKbuwJfZn16xKdnt4kG0eb
         eOgi0YEr9nG1D2f1D1jrODZEek+pJRCOFMV6/2arV36GOgaCXxXZBU4coKTUKrHNVUqh
         SxYw==
X-Forwarded-Encrypted: i=1; AJvYcCUr/DRdZh9PP7y2UYuxU6vVi/YkxxB1uy3RhJdP7aTmI1lRIih4AGEWKGkDgNJ6LVSSy5B+Y1HovQ==@kvack.org
X-Gm-Message-State: AOJu0Yylwf3oGH9C7ADAOH9SQcEY94KwvEB1uwebGXxlu/PPdXv+W99x
	iStGUxUWsfAgznPIgJdYJwsWhUWHWxG1daK26Rwxp+ef1Dfh9mEf2fk43XHrK1KZkz9unf0jt9k
	i5cABoGy3W6lD4HI0Qhz28x2TN0Vtgcg=
X-Gm-Gg: ATEYQzxAtvFX6WSE+sgPzb3bqcqRLyfV8gS5xUVSGI4vyE0ETdT1iqjRcJ2q1tcY6CP
	fcyvMpxCZvZ7f5W4MrNUyi4phKB++o4TKu6AjpI5YzOie8m/D4+Z5J5/OHhalT847SPFHP6J/SF
	iu6TpQdmnNSOG/GtPbAuhvIiSt/i5APfDdgqk2Txo7A/sTNegTxKIqlPPnV3ahD8168UCsKPStr
	4iOZySX79UN7nyZ3QhaNzMaS4Jm8LdvFG7+JzL1mAi0bOS2w2bWLoPXEw5fZO7Ypm0o8K9821VA
	h6hoa4rEkb7cgLbfMK2jhBNw7ezQQcmbFt7xOA==
X-Received: by 2002:a05:690c:940d:b0:79a:8dd1:53b9 with SMTP id
 00721157ae682-7a212e17e61mr21518597b3.55.1775027421821; Wed, 01 Apr 2026
 00:10:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260330071229.14614-1-devnexen@gmail.com> <CAGsJ_4zpre2gUcYdZxY3s57=ESf_av59L+DNCYd0hZ3UtHNvSw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zpre2gUcYdZxY3s57=ESf_av59L+DNCYd0hZ3UtHNvSw@mail.gmail.com>
From: David CARLIER <devnexen@gmail.com>
Date: Wed, 1 Apr 2026 08:10:08 +0100
X-Gm-Features: AQROBzAvqftq4k998KUQk_SHQCSrieImEsgsOd3Jjv47f8RWBMv9DB5Ldgi70rc
Message-ID: <CA+XhMqw59iWLPQba5WSaF5Y7HKDgf3BjjBLn_X=w=g5tAk26-Q@mail.gmail.com>
Subject: Re: [PATCH v2] mm/page_io: fix PSWPIN undercount for large folios in sio_read_complete()
To: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, NeilBrown <neil@brown.name>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E07DF1C000C
X-Stat-Signature: jzcezezotxnau9chbxizf78ja5q3h4km
X-Rspamd-Server: rspam06
X-HE-Tag: 1775027422-577473
X-HE-Meta: U2FsdGVkX184IRHOi96dIQbm06si0e/sR5gAygB0C6NsIeW28Uc8FHy1v/WMjKpATE1WHhQ3UWfbvbmyktUfUYLOotApB0Hoz/jx5iB3DyTB4xAwlWvA+qQ2WpZUSgkFnEB4P9YbvRw7ZXKv1tekCyBbRjI5Lx4YWsdtPpSGTRMlMnCjLV8bl8fLLhWLYVu3vm8viLtgAbeAsVGgYEuTba4/CEKzWMDozrWGw+cLKoprH4GHVJaAlV8jg6WRYALRZLtWs5R28L0R+MymfN8gErAhZyJfYx8um98SLm9LdDJ/nNzinK3njQboFKc4hd5vY/ZT/0D8tjdx9U4cczvYRtPrpH4LK6ljjp0v+hlqCJLrSbWz1wYcLf1IpcjBJN7/0s9YbN5QsM/zNqp/he7A5rYTVBTpOLZE3Hn+dlLNpHETZFVUWwIWpyxF0+KuX2gH+EQQvYYGw176k9gKKO0UHdHpqyBnNUCnmiDCPgbLTEd5TQu4x6SIguV8A5ACp5WHgW3m0hvW8vAVq3JWuGYaXoUtrvVpn3T6Ody05R57ffl+9pBgOdwXJUho5hC6JdV8ZK+GaEgcyY4Yi5fymGS209bMWlz6S19xUZJd7P9pPvFNQLrJ+k8Eoz1XIRPpJijg/NcMCUtDbgwyBJ11CRkqrpqCzcTkrdUB+hS+IHQqfZjOjq9uGt9wXtERtbLoOk1fKct1t4HerOLLq7uX8CSBpRzY5edalbnsqISolr1FhibYG0eNefEwjR3V4o3QxiCxlfeyIg0YObZ582X2Vb6vYN0JujaGbRZwvjYIWYOva2XhpixNnbOQIxa6ArWMtZibI98hDbQOdDpzJl4WfLzPIHVX1bUxrCu3S+ki6lF0wQGZiLllXzBH/TzcrJSj8xZTAN0HSnPLh6x9hfmxiBH0s0fjuOP31BM2fK6EuroFoacx56XY9IxZjYSAEyR4c4NluOi3Z5f2lcPy04W+Wki
 BbYfNvdk
 7JqrdHeepL9Ks86PysM7khX07CT7vGEEHLeZJ55y6Qads3kAxM7SOkSMY6XygZ27iKpiKCHXtBnP/3I/GrlB3/Wug/OD6BwLFSB7yKFPULQ4OojQYMNv4EdgW5bp5PPtx47g17B35ZKwkETG/Q9Qf1tW3gIU1X3rzHYjVJLcBGmyF2FxGb3A7pv0lKs/taZbseFznvnmH/Ay0/Le0qh/pi6Syrh2z4qLfu2FjFEVj7N4isD93J71ll1AdwUEpKnK6xkZ143uiNBaBm/sJRZUxXUw9cxgSPzXNa6TkNolnuvZRga/1PNkuHhB+nJ6lBNxKTu9HcVpRH/axUOMazi4+T5Qd5dLvXhF1uk8b8BXBcYfKjq/UjZJMAumu5N2brLPTNlOWqPitEVU8EoBO4qYDBo/rT2uoNwyPpxA/v6Q12J9IiGagWaXegmkp/Q/ukFBhB00sHth5IgFd/FWTiUw8l2tfZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 at 23:33, Barry Song <21cnbao@gmail.com> wrote:
>
> On Mon, Mar 30, 2026 at 3:12=E2=80=AFPM David Carlier <devnexen@gmail.com=
> wrote:
> >
> > sio_read_complete() uses sio->pages to account global PSWPIN vm events,
> > but sio->pages tracks the number of bvec entries (folios), not base
> > pages. For large folios this undercounts compared to the per-memcg path
> > which correctly uses folio_nr_pages(), and compared to the bdev read
> > paths which also use folio_nr_pages().
> >
> > Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
> > count since sio->len is accumulated via folio_size(folio).
> >
> > Fixes: a1a0dfd56f97 ("mm: handle THP in swap_*page_fs()")
> > Signed-off-by: David Carlier <devnexen@gmail.com>
>
> The patch seems theoretically correct, but I=E2=80=99m wondering
> where we can swap in mTHP for filesystem-based swap=EF=BC=9F
>
> In both do_swap_page() and shmem_swapin_folio(), we check
> data_race(si->flags & SWP_SYNCHRONOUS_IO) before allocating
> large folios. Am I missing something?

=E2=96=8E The patch seems theoretically correct, but I'm wondering
  =E2=96=8E where we can swap in mTHP for filesystem-based swap?

  =E2=96=8E In both do_swap_page() and shmem_swapin_folio(), we check
  =E2=96=8E data_race(si->flags & SWP_SYNCHRONOUS_IO) before allocating
  =E2=96=8E large folios. Am I missing something?

  You're right, I missed that. SWP_FS_OPS is only set by NFS and
  SMB which have no bdev, so SWP_SYNCHRONOUS_IO can never be set
  alongside it. Large folios can't currently reach this path since
  both do_swap_page() and shmem_swapin_folio() gate mTHP allocation
  on SWP_SYNCHRONOUS_IO.

  That said, sio_read_complete() already calls count_mthp_stat()
  and the per-memcg accounting uses folio_nr_pages(), so the code
  seems written with large folios in mind even if the path is
  currently unreachable. Using sio->pages (bvec entry count) for
  a base-page count is still semantically wrong, but I understand
  the practical impact is nil today.

  Happy to either drop this or keep it as a correctness cleanup,
  whatever you and Andrew prefer.

Cheers !
>
> > ---
> >  mm/page_io.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/page_io.c b/mm/page_io.c
> > index 63b262f4c5a9..1389cd57ca88 100644
> > --- a/mm/page_io.c
> > +++ b/mm/page_io.c
> > @@ -497,7 +497,7 @@ static void sio_read_complete(struct kiocb *iocb, l=
ong ret)
> >                         folio_mark_uptodate(folio);
> >                         folio_unlock(folio);
> >                 }
> > -               count_vm_events(PSWPIN, sio->pages);
> > +               count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
> >         } else {
> >                 for (p =3D 0; p < sio->pages; p++) {
> >                         struct folio *folio =3D page_folio(sio->bvec[p]=
.bv_page);
> > --
> > 2.53.0
> >
>
> Thanks
> Barry

