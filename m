Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79955C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 04:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78826B007B; Mon,  3 Aug 2026 00:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50ED6B0088; Mon,  3 Aug 2026 00:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E706B008A; Mon,  3 Aug 2026 00:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF1DC6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 00:46:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EF99405E4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 04:46:51 +0000 (UTC)
X-FDA: 85058723022.04.D09E55F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3B5C9140002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 04:46:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m/Pk1h1X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785732409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpeKUvVa0Z+BawXDonU/NOBv2XLfOdUJACza6QkXVjo=;
	b=WEMoWRZmhXCsfa2OuLvrU9BJ7r913Pz4QRUCy/X85EMU4zHDu/spnY7sy+4TZlcsBFSZaw
	NQq2qy4ddKBoR54bg1iDxiLvbN2Vbou0p3zaltaJEFxjsmh3qmRJRukAMrDXpOiaOuWIDI
	GZqg2jcCks3NfHTW7EACu4D4VvPDAIk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m/Pk1h1X";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785732409;
	b=GpSAQoOQZ3rRBBvMZqJtx2DgZ7fg39MzFaOBO1RwRwelW0FSI5v9o8Q1frwLG1XKnUKFat
	47DA9P9L2HntYqBWcyBs9ROsLBZ7GozXqr9M4932lYwa0foHodfVUD+WvKbsA/SkEckeMI
	6UA3AaAtexBkZTMib+N0aLa83t4GGf0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3624343FD1
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 04:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2101F00ADB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 04:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785732408;
	bh=gpeKUvVa0Z+BawXDonU/NOBv2XLfOdUJACza6QkXVjo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=m/Pk1h1Xs+eMYRn6D4r2xkCKiVlhkkkJbqJ/vkE1K5nZSUqwCGuPdRPsuaWv1ck+c
	 cUWRAcb7w+lEIMDRsL8OZwv73ElaUelBHryPSUcZaZzm2R/0SHAXhbiMikgOITG1gm
	 y3+6Y7qFhKy6JWYasSRjilLlbeGA39CWtK/X53t52Hoe8bPfO8y/qelmulGiFee4wQ
	 amhX/y4lDTOwDDraTO17xU0W8QAHC/BQLF7CUAHHS+3pfvLIxQhlhz+2Rnx67Hj41a
	 drJSqgtYhdQtHGqH/hR0ksk9vlzyo+u2DiAMwmPERSGwptjWMbebNyjs9iBx6sLFjN
	 5HstPr2FL4KRg==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e65e18969so176480785a.1
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 21:46:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrnLSLlqWGoJQiBAqB5SoGJTkAZetN6YAVA+eoTsypGx4SpYycjUTij5fGOiFVXWn7YQJ6eN54HPQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1aLbbd2MOZ4WbSOCKW1ckuGO1fYdzp0D3igF2JarhseUe4ouu
	n6QWMplRvn5OQmcyFdGimqKpcGLzFrSjV6l6m6lQRTdybXJZwEqc8CtvUlnr6HxSRnli6CJsw4z
	3t6EdutsmPjtsrH0Ux2Dw4DdN43A61n8=
X-Received: by 2002:a05:620a:4150:b0:92e:7075:941 with SMTP id
 af79cd13be357-93497456c97mr1774800785a.13.1785732407203; Sun, 02 Aug 2026
 21:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260731083843.37811-1-baohua@kernel.org> <20260731083843.37811-4-baohua@kernel.org>
 <9692264d-74a0-4a69-9d57-49a8c90cf41d@linux.alibaba.com>
In-Reply-To: <9692264d-74a0-4a69-9d57-49a8c90cf41d@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 3 Aug 2026 12:46:35 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yxJyOaNTfVWxeTH0PVED0fgExOod4ay3pRVYjFcf+BZg@mail.gmail.com>
X-Gm-Features: AUfX_mwilr5G3P3D0y7x2OCWQ7SaiFleSnxBdYCXy9-G-EW4Zg4KWTwZPJSqMRA
Message-ID: <CAGsJ_4yxJyOaNTfVWxeTH0PVED0fgExOod4ay3pRVYjFcf+BZg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/6] mm/mglru: improve readability of isolate_folios()
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, weixugc@google.com, yuanchu@google.com, 
	chenridong@xiaomi.com, zhangbo56@xiaomi.com, wangzicheng@honor.com, 
	lianux.mm@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3B5C9140002
X-Rspam-User: 
X-Stat-Signature: 8zmewaijhqxp7pwu57b1osero4ssqn9x
X-HE-Tag: 1785732409-152818
X-HE-Meta: U2FsdGVkX1+cl9F+XwGaLAKH8iWamZZ7d4NNBdry4uA7rDUVYTTqES2xVOyhbdybGfAmn0F1Isu+LBqePomNDX6adB3U9UzLSuwa2tB0WD8EGh7AouG9BE57bfmRj3FbRizRZJn7ZNzheJ/IKkVGYdH8fExQuYzVo1JyaPTVs2XtDzVpkOI6a1+HGzJenldFtVERXjCD/8Rd4bnAs7Y2meiHIwY7xD8oBD3r5gZwoRiuYhCKZcJSYnDut32UXdf0ybdygdDe7PNn4tgEaqP5Sg0RS7rq0slOM0dnFmiubTPpsRzgnXnbaVrjaFCROVKRVB9BN7j+oZ114M9jhQ2InmhrNQeTqGZMUWS8AcTsaDuvQbkAlB3RQWPYDdlj/r3y6XaG37q0TOI1CyhUKiq/+iArUF9klMQP05xhUPX0+jqYj+Vw0AOhXtVmC12ASIjkxLFwRhte2yc+Tk+dbvfTUdlSb/lNk/t1lR70dkpky1b4Vxs/j+vM/hhdsN7XS0SXbyeuVOZno+YG8r7JzjTc/jC6iZsLCFk2W3EHbiNl72UmzfROwcLIUHC7EM6iFASJhUIDkDsDLkgZKLe7hyk+rxZD2gZjlnOkxePuNHWMSAbFXIYQROLRo4vfkXLV2BMl9vCj/TmKPhZ/zDBhZOSYQNK454XFhoeRL7hAOvyodDAVJ+EsOf4yvucLQJXODNFHw6NfkulQd5wahTAsLy2SWYiPcswkwJI851+cJbhTOBidztMED6bJbuzL00FKA8rvB9yf2Y/YzVkfGlH964airlCJfEZ2CGUrUtvFNH0DaHhNVjph81eao8aBKMybuehmxbiLJmz/62XBz+seaNLfeuFRll+TUSDJancDb1KLINtXv+iHjE5uTW3ltNXWYfixV3WWSmZxkefX+LnrinltGTtY8hWZXfNHL1i1QnY8PWFSku5cSfayFMF3Vbz2FA73nExeJ25He9O928p+HEi
 ucNZ5eUH
 42kxvXdYfeWzrj9qi8WRzsF9Q3Wb57y7/yaX82i2/nPCgIPIhaLRgHEt992ewGTSe2ZQfbkVxC5ikTABA0+AMTY4eqid4TUTdnMCAuwAY59fyRThBHK0CWIO5rj0uS77Csl2skSsmMLGGUew172brp1aWn8e32DQd52rkFmwPnKVDDrLs7x+1HAlNbi/BBIsKOqkbe5X7Z4P+99/+z1qmd0k/eWQKL7faGTaYWVO5Lxge+nRiA4XNyyiq3uUiJXOWCl6yRHug0dJ/c7v01hVWH+Px6+cd+4NwBS1xSdN3IZjoYkE1tfFeNk4Pc52RU08BFYGbhTnMNQJaT9gsWIeQYh5ZxrF4dsGE1mLi6wGrooh/T3bWanN58ekwr3pzI0wvQx3QtBDAHheC2JYxYRRXutB4McgD7x9HnbyCxNOBxgIma45Ge0nWzRxKdvKDvwFMRlV5Iap0TULZmiqMTxLK+/1piMbLi7na8mRn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 11:22=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 7/31/26 4:38 PM, Barry Song (Xiaomi) wrote:
> > From: Ridong Chen <chenridong@xiaomi.com>
> >
> > The for_each_evictable_type() loop in isolate_folios()
> > is misleading: it does not actually iterate over each
> > evictable type. Instead, get_type_to_scan() selects the
> > type to scan, while the iterator `i` merely bounds the
> > number of attempts.
> >
> > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
>
> Good cleanup. Some comments below.
>
> >   mm/vmscan.c | 47 +++++++++++++++++++++++++++--------------------
> >   1 file changed, 27 insertions(+), 20 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 31947fa60f18..0038f33aa318 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4828,35 +4828,42 @@ static int get_type_to_scan(struct lruvec *lruv=
ec, int swappiness)
> >       return positive_ctrl_err(&sp, &pv);
> >   }
> >
> > +static inline bool is_single_type_reclaim(int swappiness)
> > +{
> > +     return swappiness =3D=3D MIN_SWAPPINESS ||
> > +            swappiness =3D=3D SWAPPINESS_ANON_ONLY;
> > +}
> > +
> >   static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lr=
uvec,
> >                         struct scan_control *sc, int swappiness,
> >                         struct list_head *list, int *isolated,
> >                         int *isolate_type, int *isolate_scanned)
> >   {
> > -     int i;
> > -     int total_scanned =3D 0;
> > +     bool single_type =3D is_single_type_reclaim(swappiness);
> >       int type =3D get_type_to_scan(lruvec, swappiness);
> > +     int total_scanned =3D 0, scanned, tier;
> > +     bool tried =3D false;
>
> The tried' is a bit confusing. How about 'type_fallback_allowed'? Or
> other more readable variable name?
>
> In addition, the 'single_type' variable can be removed, and just
> initialize 'type_fallback_allowed' directly:
>
> bool type_fallback_allowed =3D !is_single_type_reclaim(swappiness);


Yep. It seems we can simply use type_fallback_allowed and drop
tried entirely:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1ffd96c87bc2..358388b49a70 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4840,10 +4840,9 @@ static int isolate_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
                          struct list_head *list, int *isolated,
                          int *isolate_type, int *isolate_scanned)
 {
-       bool single_type =3D is_single_type_reclaim(swappiness);
+       bool type_fallback_allowed =3D !is_single_type_reclaim(swappiness);
        int type =3D get_type_to_scan(lruvec, swappiness);
        int total_scanned =3D 0, scanned, tier;
-       bool tried =3D false;

 retry:
        tier =3D get_tier_idx(lruvec, type);
@@ -4861,9 +4860,9 @@ static int isolate_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
         * We are running out of the current reclaim type. Fall back to
         * the other type if allowed.
         */
-       if (!tried && !scanned && !single_type) {
+       if (type_fallback_allowed && !scanned) {
                type =3D !type;
-               tried =3D true;
+               type_fallback_allowed =3D false;
                goto retry;
        }

