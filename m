Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65295C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745046B0096; Thu, 27 Aug 2026 07:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C8D6B009B; Thu, 27 Aug 2026 07:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633E16B009D; Thu, 27 Aug 2026 07:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA7B6B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:31:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98AD81403E2
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:31:26 +0000 (UTC)
X-FDA: 85146833772.08.7AC0EAD
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id A94CEC000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:31:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XN5wXoZd;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787830284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yz47dSUy4kXSBaOTlf7K5VK4z0sPH8KYvLyhtCLiLsc=;
	b=DiVcVGTtUbhp6KSI02Ty6rE9CXJoNsxaF8jSJqvzKTT7jJGAlTAHpaGayAbXEbD3qqcLM5
	Z9QKbVfUC9ikXXkh1fzg1ifgsxHpy9jIZyj18mtnM/iLjcl9CvNLP1L3oWD+KM6HWzzRfZ
	rQeOaF+Z/OFkaE5olb/PtGHOiHC6hq8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XN5wXoZd;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787830284;
	b=cDK6l093QxiVLqr2gKjhwo/c//wxSK8OBm2BtcL8url0rBXD4lbJxQdmyYWQ+RoqpF7sYS
	uIUEaYtmpjyUNHrG3ndGzgqYE3xctCqYXW/8pvBS7AHPWzznIt9TDJFqAvIWCNL3kshGxB
	S/SRHF+h5dR+FhHa9MDvgajaHamVQB8=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a3fda88184so3297988a12.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:31:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787830283; cv=none;
        d=google.com; s=arc-20260327;
        b=qNJdJNWaZEtPgqsHnqsChJDWeUcDOXfakL8tshhaD/6slTmcyXFzpsCqZ7Ht+w6uSU
         LANcfmznBrXQjcvojzQYjQwAZySBSFFG9TZ0pzTwlo3l94f74hnjZ/hy20aQ6R0ZhmRW
         G9yDkPm7q2xWEBT6NFehL/FAcVqhCwh1CwsxJqMDymIUY+3vzdSEdbsxBA/kNiw7uYmS
         L51y2GHJz01hHtbZpOpBAXjlsuxWb4IiXcKeGPVhkr0HR7HDOStwsMqCMI90xPGmgl1U
         BbWmO3kXOvTLjw6zjBCX7qE+w3EFy1JqQuJv0+ezhuWxwjF3YtbT9r5oryz9YZoyw8iN
         Es6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Yz47dSUy4kXSBaOTlf7K5VK4z0sPH8KYvLyhtCLiLsc=;
        fh=iw1t0vyKRVxU0Rx2HYDx4+1CivvNMaFIk5V5xtOJBUY=;
        b=bTJLmm5wAQpOV/jaZwmwSMD417aX2OO2bTu7YcXVTXppxljgJ3khCCySOrNstJDEvT
         0FxgqBt/7znoBrYCfRYRn5tX8wD5cK7Ompb2Wmgj0OHuygPzYO307hFPfgXjWLCTZDB/
         WvXu4h7Rpo4o1rSBpCc68D4o2VMA+ExPcZwP0ouzAYWc5o+xTVajFjJttwYH5lX7tgtM
         3S8/RG2FMqmmlQEfUgNlbjrDJ5A8MgmQgQfpTmARFjnqeeiJpEEa6Ev/25r5UBFthTpi
         gTz0n1RGVXK6G9l4fQmM6z0wO1ROAeXPEdV8/H04HYoTnaq/D502xOE+kC1M5IWMz1of
         0A0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787830283; x=1788435083; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yz47dSUy4kXSBaOTlf7K5VK4z0sPH8KYvLyhtCLiLsc=;
        b=XN5wXoZd4YuzrUZTyLYQsYWsmOa0vjJoZoWL6jmz3RFxMZUBKWD7Apw8urtomYB7N2
         S8iQ+LwlrzZoecXIwOzeVtt+iXbSGm4qLCdMcgxKUdMZWJbRnS5/bI4Xl1NMEXoDWNEC
         gthTkxzf9thLPMsMeDZlQ59/AshnfzS6kSQFXZHnuVFn+eKLrQhgELmmbjITCg00hTYt
         S8Sqf01JzRmFuD5KtpMO5egKfuiLcNsQmYpHPaNBKBApBabpMOYqwUsSAZnCAyDKuRwl
         BJUCQnOCtZ375SP1BNxfnpYcropW3xdKKmVn84RVknvh4ooKj2F3qlcnzvAweTDeBD9u
         4XHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787830283; x=1788435083;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yz47dSUy4kXSBaOTlf7K5VK4z0sPH8KYvLyhtCLiLsc=;
        b=sw2YEIw3USl8hGoMg62X1meiqJWEbD5V39zoPvMoo8QuMXXbuyL+mv8VUZJAlspOh+
         9KxOqw6fllAA8ST1yNlZoexN4/tIj9qBzF1iFjgIxAIATJtg4bpZLESmdHoZhNTjO/23
         OvKvyiCjP5cKo715e52+8bMy9W9eJlKMV8kT0Eo8Z4ClLQrhbmINAjRO3NdeDVudQk/0
         m5c2LRwERfJ50ie19XaFZrBdbKT5JQfNasXSLjA5+/wAtOklSQOo9aEqflD293YDkJOM
         mkoN8zL9VmOghOFVI9lOmEPSnR7jjLffQyeyFaaFXAs+F0EVztlZL2nZ5UHrgBw0Ai+M
         Elhg==
X-Forwarded-Encrypted: i=1; AHgh+Rqthj0x2EV65ICHA+dFy8yfEcw9ZI3PoWObQ4zHYj/tH52lHEiA5fiG5vrbQOAvZJegxZzH2fnjcQ==@kvack.org
X-Gm-Message-State: AFuF++lJ7ibIGFItqEbkAZRRy20Di6IqtcuSPs799TI5UbOn40xCiLKr
	uQ0bPb/NO4h1Yx/1/ycrlGAVzCb2yGD5L7o/K3ygxvlAp+QkTsSZaaG9KZPu9SAi0eiuVFQF0Y/
	78MWNwcUEUUPeky45j1wOda3F/nnF5OU=
X-Gm-Gg: AR+sD10MOQvuch7FVmKfLKEvBFY8TEZDIesGFCABkY6knh12zi3DpU0Bo0oMd+r5IZ1
	oJP12Um2EHHfYe31tDfy6A6RnuLx3FJHqB9j668gv+TFHGyECVUSQZORQX7/tyu0khSgAZG699I
	5BLAa/SGnhAXXk+o53oyh9IhAyHAj2zuYym84JA3gHDQa3yP4f5rrsdHHafVtoy9oDekfTRpj75
	8lVwjLQrQMhpXPwXr7QRwl72Wfk/qUU2CWyKcjFd902hcxjvli7FTcu8xe3j0SgkdzhuKT+GVIr
	EwrQ72f3ZprLa6WFu1m9KFbs17PtL5TvbdqY2CAP0XTdb4XIaG6s0b4ys4uvKASplUE9CqYbVK6
	Kdg==
X-Received: by 2002:a17:907:e915:b0:c20:f6d9:d8c7 with SMTP id
 a640c23a62f3a-c250c3805f6mr1422702966b.24.1787830282709; Thu, 27 Aug 2026
 04:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-2-baohua@kernel.org>
 <CAMgjq7AZtqdu-yJ3TSa9Zq=Cwuqv-NY+ptz3Qpive-iFXR6e0w@mail.gmail.com> <CAGsJ_4x1ckY2uFoOYq=Vw=d167u+-yVpt-TSWxju41ivth2iLw@mail.gmail.com>
In-Reply-To: <CAGsJ_4x1ckY2uFoOYq=Vw=d167u+-yVpt-TSWxju41ivth2iLw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 27 Aug 2026 19:30:46 +0800
X-Gm-Features: AcwNN1VPZegaGb-tyLAke5m9CfF5cIkWG45igFHDRcXdf1Z1eBzoBkFZQNcbqKs
Message-ID: <CAMgjq7BJGCdXYdK6PPuM0Ut=R0otvpWXPUeK6n4Nbh6YXiNK-Q@mail.gmail.com>
Subject: Re: [PATCH 1/6] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, chenridong@xiaomi.com, 
	david@kernel.org, hannes@cmpxchg.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bg1uupdq9fdpeczsc3jp8s6iambm9hpz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A94CEC000C
X-Rspam-User: 
X-HE-Tag: 1787830284-404387
X-HE-Meta: U2FsdGVkX1/lpWl3AT4R/NR5ejHGBqUHQRMPfnhNeIXoTYckWYWXPpxF8z6ByrTrh16QLZpBd9yWUS7Caw7/+Y0RWN/uyrHSwOH6YOyzvxpdaIUTMRYhHbFFt+j3jfFQHy20VrdeCK4vTcXPWUyAjL/d4/z7HMBKrFHx5vuR7/9tzUGPNywp9rAuYmRDK0G4GqQ5iFO/NDnb11XVL1qPKYftSU6fbw891rg5/dsEio5TQcNymsquZkrUGaY1aylSDYpexZwMMH5324qt0zmr+8DnvvEyzN/v9eU3eOtslZ5Ek3p3aYsNbb7ne++MeWbVXzZyty3n10S+PUmySHC5qhvMPvKCo6MaanAk302EBImcjySrJ288Asx116K2vdrqH9t9AdlYB8CiFyvedczRiiRAb+6dt9aXLUgSfzO2iVrB1VgGlrW0NYhPAKDzhfHjymbwDpYJG2iOXnra+ea/Ups5gSUzmrs34jirrRR8GMR7ydWCImKId0+vLN68kpGXUrpJQE8I5W2n2/GQ8hdOf0mOZQ1GkTXdVngir7iQBfAVuwo3CNxEuKl5DCZKf0zyaPqCT24nBWbS/94BhZxtxqOHwoyBCIN0P2irjGaHpSJ1wWLGT+dX2r24W16zMf/DFzloZAJrHqe+EuhXv/jeaCEsUmv1nX06IOgTa8W0+BQhf1nVsJTGDpYzEXP8ElKgdTNmbK3ODhO+LZbgv+FjgNxSZNowyBSAcLd1jWc1KG5noPn6wYJP8TC0qmYo7/0CnvMq0CgNFJqAuHKWdi03AHkcQoYD96qrQf8EkhmH/KxLazTeFFq1WQ1DiOrWkN7PtLu2xdV5h+yzkoI3tIpB0HwCx8cawZ4K/deE3Qap8VCj6A6JIysJZ04fOiCPDjGQaiJwNbBsEwZY7RsGNol8tonMYswJIm5HpZys1TsmI3/xNO1+k+zs8jFu0rAOQSpPCJCOKXbEeUq4xHeO/Lv
 WqKMUc0a
 fO9tSWuzy9cypRy/ZbGkhdQEQddlSiAptm7awaP2+qlOlDVgtLojOfK+MdHcqmRuL+Lr5qJQXAXq2vQRoCiurplpim0GnuSLds9iVCJMKLceoGRQwGZAQyN0OZllBL+/dU3FVmubp3iM84tpuzalG37biHM6pfJHYsPgApMoZxDs1UEuxald7eR2w9wygP3G7PqFvOEsGVvHi+5pKAV/9tUnQLmWXdkq0LyNljtktV3iUB2kgWwm6HW5VGC0bi0cRH8/5Rd2TpR1sNK/sSMyKYGr+rHwbBrMM8S7ON3FTmyf8gibofrDLX6eTvE7GO5o+RxLgMoeBYew8pDfkAVEpYoTyu6UDYTpOHst5bdErM9BrZVQV6LySvVlP5513xXby8Z+ePqN37VACRbuVatL8086TiTUpA421x1ZdguZxz2VBVO7uvmgOTEgkSf52+9n84HKg3c2f2JHaBKh+WhP+sCt0S+DMvt/DwBCpn/DkV+kecSOjFsZdGYyA+MEen1uoDgZakU6LJrr/MdF93VzzffqGawz/7bXXDg+pRH6bub8PHvCr1eI8Fxywvt1NokgAupJY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 7:21=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Thu, Aug 27, 2026 at 11:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > On Fri, Aug 21, 2026 at 7:09=E2=80=AFPM Barry Song (Xiaomi) <baohua@ker=
nel.org> wrote:
> > >
> > > Currently, folio_inc_gen() updates lrugen->nr_pages for every folio
> > > as it advances generations. Instead, accumulate the size changes
> > > and update lrugen->nr_pages in a batch after scanning the entire
> > > oldest generation, or when the scan stops because remaining reaches
> > > zero.
> > >
> > > Since we only move folios from the oldest generation to the second
> > > oldest generation, the active/inactive state cannot change. We can
> > > therefore skip __lru_update_size().
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > >  mm/vmscan.c | 46 +++++++++++++++++++++++++++++++++++-----------
> > >  1 file changed, 35 insertions(+), 11 deletions(-)
> >
> > Hello Barry
> >
> > Thanks for the patch!
> >
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index c1404a59523d..0d74fc00abd3 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -3296,20 +3296,21 @@ static int folio_update_gen(struct folio *fol=
io, int gen, const vma_flags_t *vma
> > >  }
> > >
> > >  /* protect pages accessed multiple times through file descriptors */
> > > -static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
> > > +static int __folio_inc_gen(struct folio *folio, int old_gen, bool *i=
ncreased)
> >
> > I feel the naming is a bit confusing, the __ prefix doesn't tell how
> > it differs from folio_inc_gen very well, maybe just name one
> > folio_inc_gen (the old gen could be any gen), another one is
> > folio_inc_min_gen (the old gen can only be min_seq), and with sanity
> > check in folio_inc_min_gen that expects get_nr_gens =3D=3D 4, and
> > lru_gen_is_active(min_seq) =3D=3D lru_gen_is_active(min_seq + 1)? This
> > could be a build-time sanity check instead of a runtime debug check.
>
> Thanks very much for your suggestion, Kairui.
>
> I tried splitting this into two functions, folio_inc_min_gen() and
> folio_inc_gen(). I tried a couple of approaches, but I think I=E2=80=99ll=
 give up
> on this direction.
> folio_inc_min_gen() and folio_inc_gen() share some common code while
> also having some differences. It=E2=80=99s hard to avoid ugly code duplic=
ation
> because folio_inc_gen() cannot call folio_inc_min_gen(). However,
> folio_inc_gen() can call __folio_inc_gen().
>
> The __ prefix currently indicates that we don=E2=80=99t update the LRU si=
zes in
> this case. The sizes can either be updated in a batch later or updated on=
ce
> by folio_inc_gen().
> Maybe we could add a comment to make this easier to read, or use a better
> name for __folio_inc_gen()?

OK, thanks for the explanation. Let's just keep the name then.

