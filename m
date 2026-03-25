Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6918109C036
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CBB56B0089; Wed, 25 Mar 2026 12:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3CA6B008A; Wed, 25 Mar 2026 12:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9DB6B008C; Wed, 25 Mar 2026 12:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECE7B6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:16:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4F70E0A14
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:16:34 +0000 (UTC)
X-FDA: 84585088308.23.A77B698
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 72E134001D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:16:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XQICvlRq;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774455392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdesG3FCbAJVDCjzINb0WPV8HWIuE46VHkVQSk+5ZBs=;
	b=GQuv065h8Sh+sNciV87n4sPr02yuEePDRPDkdPJhEvVdTrAFVsJnKNGXjOUoHtODvxY6VE
	iWbrlrSKInwoz0NIRyC09EMOy9ERv0IYlvARftIwok0n40lK8C5228cojcy2b1Nt90tpGj
	axabU72uHxoSE88oXQeHoWqqw1W8+40=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774455392; a=rsa-sha256;
	cv=pass;
	b=UVouQX1SU5WtG8U9bsJMqDJur3QHQzGJjPLzEG65qAbktyTwAPfiRLSGcPn9tv2AZvjIhz
	BLKue7om9fzxTij/Q2durRyA72RWmAP/cNXTOvC4jltzk8Zpk+9SKnFAzSLrGSvafSz5Cb
	aXYq4cwF78eBFhy7KCEw6MOIyfkUwhM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XQICvlRq;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-667acaeae82so10696442a12.3
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:16:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774455391; cv=none;
        d=google.com; s=arc-20240605;
        b=YcFrNwZUE0j9Kc3IwkEWka8oQguOutDjYVf7LhS+omKg3/VpHEfPsfJ2do3BI+csu+
         mIbfiXzPKLNYQfd5oWSUfA/fpqvrfBBlef4xu6GJrUnhtgEaxBn4Aj8WgDOna9YlXdBc
         u9Bs5VAfDn4vbX79Pj8pIOgiuuD2Ry1tJxSVnhvMD5WJcw1+UptLRi1Duf7spQPvnwyj
         vFCb3xHdnlwYLBsPFKM4dFDdv+kgXEZiTCJuIP0QoTITPq2f9+kkZb7ycrA0il1vcL1L
         KgdPzbVKKmr8gZaZh78nyk7w0mWsVoR7Vv0McBTJ8BR6ZNAgmfoE7VMOY1XH1qeSZzKW
         zHRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gdesG3FCbAJVDCjzINb0WPV8HWIuE46VHkVQSk+5ZBs=;
        fh=A7y+Pb9x4jmGUvk1cezYCw081hED5C5o7Ek+dA7IHjI=;
        b=ccQ+lFcM+7XBhrqAlGbIUGH/odetwrX2CIwOn8V4jCMBqnT0LDo1GWiiX3+veeD+IB
         5zlUMr/wq4e7NOgwegaGPiXJ5ZzMFU88mnPA4bRkWGYWJLoJfp2iZvznzzEG9nEBdabL
         KVxCbuLQcCAFzOrf6mEfKi2XtG52Bw2UFVkDzH8JzDW5Dufj3PFQtSCDKJggUicsC6TP
         tc7nSN9pfDq6QRHMZl/CuTAcQIgARcOihX/2RvjyKQsPjdiQcN2LP9c0mWth9xHmL2Le
         XJAOG9hV0JmDFFP0OVYRdMsRcNo83enFtIZVOIXnlqbR5lu/m1B6JvtjgvDzs8I29b89
         dL1g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774455391; x=1775060191; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gdesG3FCbAJVDCjzINb0WPV8HWIuE46VHkVQSk+5ZBs=;
        b=XQICvlRq/yqjX5kXEPLpPrykp8Uh51sfhW006b6HVgkUQJedgTJTgGGzzXWZW71U5A
         0mAYBqjZPx8mUfV7vdUsmbpVtxMjkQVUzhAK8OgRS0hc9hHbLl2BlKtFKX9R0pDcx3r2
         pmAUM7La9xjcPtRgIXM7Zsf5exY2fI0yWjkFtNgrVXtNFRDxjZnUMDDZK4nfyhht/ypK
         MJf/iRZlWl7Fn61G66EymAjSrEfnTkXCmCJqzEctGzMnBurJZeiUJNdeti629yO44kcX
         wfJ5PGTp9MZs54JHoCpb63QJLFiWZsyTg/0eAY5gI+eMNFfOtXnq4LBjRhz7emiYHs+L
         zDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774455391; x=1775060191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gdesG3FCbAJVDCjzINb0WPV8HWIuE46VHkVQSk+5ZBs=;
        b=gs7BD8EPq0irQu8xf7Y0qv0jJdjc4I47OTs7xol7XJJtl5eH94BFqaX2iItZSbhHtV
         D9lgvWQo07vbCZmhKDFceycAlJwVSprMrzy2Muu0SCnXmOx7Kcf+h8XOx4ji2qw0MTq9
         zXt9xSbzdwegQ7+62dDuUT1FO+vK4ZiIBpSD4YTYPv9pR7Q3dXQ4Aa7r6C9mpoahHwNN
         X7XyPAj6Ra1SGS29IzXJQfpEwBruFU1my6lsz7C9bq38mkZPVlhwhQoCnZGVUbEXii86
         R/jcnFeDne/2OH//NTReTKAm6JI00hZkaCy/0VGLN2w/hF0lArYmMqY+uMPYzjBoUcy4
         sLyA==
X-Forwarded-Encrypted: i=1; AJvYcCXyeO2Cn4iaju1T8gMjv2Y5AYStzKxSVZsp7pVG205hCkmrTLhSz/ZqRpnwfdkw4p4/5I2wBjdEhQ==@kvack.org
X-Gm-Message-State: AOJu0YxYuVN9qVD0R+A7abdP3PPcW3czAc7Ur8sdWsH6vW7dXkg8ljNO
	LNye9r53tVHxp2TelTETPvm1wmc0WeuCY+LHY/1ub5nXIl5x9WP+Bvd567mhuf1Hjj0CIygfSV5
	rAMN44HCbEeoLEVPTdXjrhU1tbgl+I4MsBw7TCPJTRw==
X-Gm-Gg: ATEYQzxm5DQT1mMZ+h1nvE2z42Gb8FAZTjJ8svZPLX3UMN5lyMRlEyTP31TpWVB7EV0
	mobud5uNp1Xy41mIF4NLEqxRNZvbFtCOwx+4Imzt78vWw5PzLvtWJKZ8Rv/LQkA4oLqOAcql7c6
	UCDMITzOdxZ6NoD1SHRNVOaoF/kyIHxZo0FcIWrsHo1XkBjL/CAK6hBNM2/mNFYWh6MIcXz89PA
	ID+eB9G9bLdJHQ45PSpjo6kgglXNWFpPPvjHSBWCvQCnlTB8iDbRW10quQbGwhNRbEIwyS+p6TI
	+MSGyFb7oh1OlCp6YhFl4zprDZQHhXB9ZW4Dfw==
X-Received: by 2002:a05:6402:458d:b0:668:57f8:cb86 with SMTP id
 4fb4d7f45d1cf-66a82672c4dmr2605591a12.22.1774455390316; Wed, 25 Mar 2026
 09:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260323203145.148057-1-pasha.tatashin@soleen.com>
 <20260323203145.148057-2-pasha.tatashin@soleen.com> <acP_6wY_HVMyTLHk@kernel.org>
In-Reply-To: <acP_6wY_HVMyTLHk@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 25 Mar 2026 12:15:53 -0400
X-Gm-Features: AQROBzBAMaBv6yy_H3sc1rFwDSbkGqaJ8neT4FLiAwZOaJsWHcMPguK5VNMeOp8
Message-ID: <CA+CK2bDNu4+eR1FPOeaN+rZf1GWkiFHCaHwvS8wCKUPJkmWKOg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] liveupdate: prevent double management of files
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	dmatlack@google.com, pratyush@kernel.org, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 72E134001D
X-Stat-Signature: itmypkh34iok38e6yy53dd18o15giwte
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774455392-558870
X-HE-Meta: U2FsdGVkX1/RRJdLJWiCaLD/GTRqyA/o4jIGqU9vw2WsuFXnCsSJtTxw9lmfHHz6dFMq4TSbtjWq6yZfjF/PXXxgrbtEiVoBAObC9VOq9dlIJS7vymDFNRWFRSPRqG+SA5Z4Of90J8uWLTi3uA7KHbqVn5M4Yq6+5N5mWBsdfq34gYKPJzJg/nXLs0WPtEfG2i2LnL5X9EQToFhGOaosKU2CYFj3X9HbIOQq0gzGKXjAnUnJLbUjYATYvbUSs5ebxT9HNNVD7G5Q4eOMlFrqn33fuLwfDNhnv33Sx2rvtzoP/Fp1Xn/HCb7WLPdSGbM2tQm+44l6oqrX1qoPctjzQ5E68aX+eePhEa7mL08QqvHVI3evkjnQ8Ws3G8RerkBRFkXpcrbS6lRKgRUyBTlmU+73P8OPzLTGZKMn1dUkPomVzI/H7hLhRmxgzh8DaMRB9fD8WGRL1CNGLO9dCp/OSQTxz/D6ke290ahWDyq0A2ZJ/EttdCgducVbspOXSFfrU7fXHBAntJUCzD8aEDd2XozqWC/WT5IXmqYjyVWj0vComCHY8egDwNeCVKLMFpfgh1WbFcCXB1l6391XY83Ce8XZcH3mI77m3epSYYu3lU96+KQKelc85lBLPVgerrkVU2sTVzYtwdx/ehZT+N8BWrtAjdoTZTq+T0VPF4b01cmVol9B59Aykk4rXTe1oTR8mComD+wDr8Hb0+tMfjTtVqaGD4CTgAW+1K+cbHuFhDivyOCWqsL+DhP3nSw0pdCwc/5mXIcFL//S6/fz55HMfpnjHX2Q4VijpYpYkbliCkGNSwy1QW1SvMC2q4esQEv6objYsLEFXCh9lCCTxwPcRtIrIXNLq3xTmbxXIsRY04BRvJOMNeYkGjCg2NoSn1o4Wxkh2Nk6jNFGqbQfkIOQX7oduXkRlsSzFvmWu0xMwlhOWMs3kem4zTwuOd87XrenLD+L8zo9RScJeIDAr0L
 jGPeVdn3
 w/58iz2ot4QrT5lz5axf04Th67dUc3bjwf7pA4PnvRSVs1lfYToTZ3qb1Eqs4zX2Mbf6ZnXFxYe7elpCo1vZ/R545qWJxpl9sbfB/iPja/xwX1F8LvQMm20VE459UOyEtlwKnAXGa8SL2wc/RFwfb6J/vEOoLV1vlB+3Vhx8USAxswTIf/UhU8LwfgH7QSzOB61JVaWyKeKE88xJPE2fTl/FF5bN2fCvKFFSH6UUQXv0p61OTINE51ybBS9XKFxN9I8WtcnuNAfhWYEO1sw8i0+23Kh1XNKyEvBqKx9GRwiJUlXzduH+uryquvC7Hnph+WVkl93gI76Tno/vXvBKhH4wKl+HeJIYvWOFA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 11:32=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Mon, Mar 23, 2026 at 08:31:44PM +0000, Pasha Tatashin wrote:
> > Currently, LUO does not prevent the same file from being managed twice
> > across different active sessions.
> >
> > Use a global xarray `luo_preserved_files_xa` to keep track of file
>
> Do we really need _xa suffix?

I liked it, because `luo_preserved_files` is a little too plain, and
not self-descriptive. Anyways, I can change it.

Pasha

>
> > pointers being preserved by LUO. Update luo_preserve_file() to check an=
d
> > insert the file pointer into this xarray when it is preserved, and
> > erase it in luo_file_unpreserve_files() when it is released.
> >
> > This ensures that the same file (struct file) cannot be managed by
> > multiple sessions. If another session attempts to preserve an already
> > managed file, it will now fail with -EBUSY.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/luo_file.c | 17 +++++++++++++++--
> >  1 file changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.=
c
> > index a38ea4975824..5f48c3c8c561 100644
> > --- a/kernel/liveupdate/luo_file.c
> > +++ b/kernel/liveupdate/luo_file.c
> > @@ -110,11 +110,15 @@
> >  #include <linux/sizes.h>
> >  #include <linux/slab.h>
> >  #include <linux/string.h>
> > +#include <linux/xarray.h>
> >  #include "luo_internal.h"
> >
> >  static DECLARE_RWSEM(luo_file_handler_lock);
> >  static LIST_HEAD(luo_file_handler_list);
> >
> > +/* Keep track of files being preserved by LUO */
> > +static DEFINE_XARRAY(luo_preserved_files_xa);
> > +
> >  /* 2 4K pages, give space for 128 files per file_set */
> >  #define LUO_FILE_PGCNT               2ul
> >  #define LUO_FILE_MAX                                                 \
> > @@ -249,6 +253,7 @@ static bool luo_token_is_used(struct luo_file_set *=
file_set, u64 token)
> >   * Context: Can be called from an ioctl handler during normal system o=
peration.
> >   * Return: 0 on success. Returns a negative errno on failure:
> >   *         -EEXIST if the token is already used.
> > + *         -EBUSY if the file descriptor is already preserved by anoth=
er session.
> >   *         -EBADF if the file descriptor is invalid.
> >   *         -ENOSPC if the file_set is full.
> >   *         -ENOENT if no compatible handler is found.
> > @@ -277,6 +282,11 @@ int luo_preserve_file(struct luo_file_set *file_se=
t, u64 token, int fd)
> >       if (err)
> >               goto  err_fput;
> >
> > +     err =3D xa_insert(&luo_preserved_files_xa, (unsigned long)file,
> > +                     file, GFP_KERNEL);
> > +     if (err)
> > +             goto err_free_files_mem;
> > +
> >       err =3D -ENOENT;
> >       scoped_guard(rwsem_read, &luo_file_handler_lock) {
> >               list_private_for_each_entry(fh, &luo_file_handler_list, l=
ist) {
> > @@ -289,11 +299,11 @@ int luo_preserve_file(struct luo_file_set *file_s=
et, u64 token, int fd)
> >
> >       /* err is still -ENOENT if no handler was found */
> >       if (err)
> > -             goto err_free_files_mem;
> > +             goto err_erase_xa;
> >
> >       err =3D luo_flb_file_preserve(fh);
> >       if (err)
> > -             goto err_free_files_mem;
> > +             goto err_erase_xa;
> >
> >       luo_file =3D kzalloc_obj(*luo_file);
> >       if (!luo_file) {
> > @@ -323,6 +333,8 @@ int luo_preserve_file(struct luo_file_set *file_set=
, u64 token, int fd)
> >       kfree(luo_file);
> >  err_flb_unpreserve:
> >       luo_flb_file_unpreserve(fh);
> > +err_erase_xa:
> > +     xa_erase(&luo_preserved_files_xa, (unsigned long)file);
> >  err_free_files_mem:
> >       luo_free_files_mem(file_set);
> >  err_fput:
> > @@ -366,6 +378,7 @@ void luo_file_unpreserve_files(struct luo_file_set =
*file_set)
> >               luo_file->fh->ops->unpreserve(&args);
> >               luo_flb_file_unpreserve(luo_file->fh);
> >
> > +             xa_erase(&luo_preserved_files_xa, (unsigned long)luo_file=
->file);
> >               list_del(&luo_file->list);
> >               file_set->count--;
> >
> > --
> > 2.43.0
> >
>
> --
> Sincerely yours,
> Mike.

