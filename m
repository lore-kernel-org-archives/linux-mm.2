Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16633CC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7904D6B008A; Thu,  2 Apr 2026 03:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7682A6B008C; Thu,  2 Apr 2026 03:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67E1B6B0096; Thu,  2 Apr 2026 03:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56DF16B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:19:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF27D5904A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:19:38 +0000 (UTC)
X-FDA: 84612765636.30.70524F7
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0A7BC4000E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:19:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kOdcQsB5;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775114377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvCjr3AFvpXbHbK+e8C3R/vbUbM9TuNUFtTfBmp/J94=;
	b=ow71WmwKZJeCOGFCXT+vqnhEQ1XxWweLj32oGKXNtnRQO6pIFFJ8C0I7EGjW9Nb5rjnXe1
	V/FBAKTqvtMwrN2275+LfqNEzkB4E8k5/GsckHKqoEHBoLDmP99WMVQ8kQm4E+CH2ildPs
	RR9Hz+86+5/IktepVIwo/Dx34MI2IHs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775114377; a=rsa-sha256;
	cv=pass;
	b=wM+nXJpqZfnws90nKzmGPf51vWOl8ZbBqi92pgJOyD1DXj0InSH0ArjLftM3bKZ8JcgUSW
	gAQIGcJtO9zRn2sMX04Y0RLcM5nZR56HKhL1sOUtvnVnIGqp+/apuk7UZRTFCuKXYIHjIm
	Bt5VuLuod+ybFeOQlzjPnl/CGzwx4+8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kOdcQsB5;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40974bf7781so1564612fac.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 00:19:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775114376; cv=none;
        d=google.com; s=arc-20240605;
        b=ZhyKTYdQOaJtWfrNwubbLhH8p5B+s7XuHgyGYA/2q12fvOb5pxb1e58xVYs3DDYmcl
         85l69tE/5rNxP6M3tChSjKK093Fw/9QlMhelBmRM/Cm9hSsXI4cZkmlza4VG8FV401UU
         UJbnaqJC53tIgahQ1VrB+wiZ63HiUF+oUElQ6iidcfna+X5KaDKTY7oFawWzXzr8oq8z
         1OLmRNS6TItYS2BHEHw0a5ektck5aMACWvAchgGMIl8VJYTl0jJTg9gOhdlRqadrsoyn
         6VvbYbQXDRImuHFbk37bu3lb9LDz//3sWLVTN4ZirT25GUxD4EG4Mi7c4MV7cAXaHb/g
         MTIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xvCjr3AFvpXbHbK+e8C3R/vbUbM9TuNUFtTfBmp/J94=;
        fh=INbvJ8wvILkMrZ0VbThRP2q0tfshw/D/U7ga+inz/rg=;
        b=LlvWf62MCVi8s9IlHwL2ZRj5xzNKTjJj4VuJplNB4OPGZeHov17sxNug2vMml1HE2N
         jcOdcPJuw3IiggJ8l4z4BlwJ355vPJ9a+jY1snAvCjwLikKVDv4O2sNOtOoZ2NK7vf6b
         dTd4NnyQ/RrESKamBV91uSnluh0W1XWt4ealY5q/BM/wjYF8cQQPJA71lhdmaaAtjUlU
         hK1QL+CRCGJvrxXioukfYIsfrFZRsuGnJop+4t7812DGp4vUYfW8i5LV0HBWeAjik2C9
         qb/j4u/HFC6JUii019noF6njOzN+jjXojxy4Qrt9kRS9Fjo5KGncqOTagiGAZBmrYzdA
         lxgw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775114376; x=1775719176; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xvCjr3AFvpXbHbK+e8C3R/vbUbM9TuNUFtTfBmp/J94=;
        b=kOdcQsB5Z07ztAbbsYcY/JQBMLJmto/kcMy+WVyXN7uQjJCpd/kTuXVRSfPFZB/eoI
         CNZZgLbLFZKHxC3FwNk7MscexyPaMqnQ68iNgbYhoZWtNLOvzvbqM6kYVOnQsyeznwPh
         frUWUdXC7uTSQKXcfjDEVM3IWbOOd/Ctl+lyxWmNyBUb+UG5gtgCIaiPsR0FeQkYGhaU
         a0o8ll7WlglRigkxrKL6hffsHvIO6yo/dWDnljzNBgzAGcONasefKcvz/r16fD1SERpW
         HRd02hzEaUR9za3FKHpTCGu1jxwr6BqvpruJSDSAr4MbfLcxlHrWQqI8WYZYsQr+SfZ3
         osFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775114376; x=1775719176;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvCjr3AFvpXbHbK+e8C3R/vbUbM9TuNUFtTfBmp/J94=;
        b=DS3hVuudkq5ARVNjTUo/gbpfLmu6+Y+ozhLYRAsdrXFyLpqx53kVdV/JJhxDNbz82e
         b/I6TvfppWeC/ZLhvQiEwqWY+VtFjmgIgwPQ3nmPw3td1I9tO+aPSNAokmpC70lcalVP
         A5h12QNy6C8U3rNMSFYm5XetBH6q0Jj36Ttxn1sTUq1vl0FqfmCn863tGpasIlDpoCNp
         92qQQAemPdnzOb6u/ynU5KxocMRfKsDbo9w5WU/r/e30X6+kb0KG7Pr1Bj55VvKBx6PC
         /2e5UkxwD/dz0YqzmCeds/zHGzgXkCL5MBuHoWZh9GICaFm++/P/bNH98U+pb6JbZqR+
         cTMA==
X-Forwarded-Encrypted: i=1; AJvYcCU/XAX48ueJhEHAQGocswPOp20ImNocZsviwvsVIG9xIANjfjYKflkiePrO0qEz8GSj69xFoBUTSw==@kvack.org
X-Gm-Message-State: AOJu0YzdErZFOlx426gVdgT+NOT8qDyPDZjTwwg9nSKGiGCnTPxsvrT4
	oXRjKcATLAHzWT811RrJ3fmpsBCmXvZlgJioLQcbIR6ej87fSm0KI9LJKtaxy5AcIixHLVGlDx2
	tY6SdnD4ZZpme7GFKxzJQeTs4JLxdZzo=
X-Gm-Gg: ATEYQzyWnJRvf97Nqs6HebrT7xGI5hmmX+ZnvLFufCsmAqr32Weg9kimygff4mQ9z8a
	cxAcGaflV4zF2zIn63cHBVZWM6C1USKVnminK45VgwubJoej3eyjR68qIwWHd2y/qXcAVlfgK0H
	5BxRmH99xBG9KQIIb0Y0m3kxPY70N96pYR0VHDO/XZezVUqE/+YFCmqYKk23zawroYqaYOja+Tq
	duDxdgroH0jmDrGufb7Orfoy4GJI9NpX4P0xV6daIDDqy/EV11sCYvK0NEemuUoKVrcVhUQLYIU
	inBTOenKenDex7SN8ZYnkX8cq9ZbLtid7Lw9IQ==
X-Received: by 2002:a05:6871:806:b0:3e8:8dcb:cdc7 with SMTP id
 586e51a60fabf-422f36e8954mr826261fac.20.1775114375886; Thu, 02 Apr 2026
 00:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260402061408.36119-1-devnexen@gmail.com> <20260402061408.36119-2-devnexen@gmail.com>
 <8b6d552e-cdf2-4472-ad26-62cbb575b0fc@kernel.org>
In-Reply-To: <8b6d552e-cdf2-4472-ad26-62cbb575b0fc@kernel.org>
From: David CARLIER <devnexen@gmail.com>
Date: Thu, 2 Apr 2026 08:19:24 +0100
X-Gm-Features: AQROBzC3KD1aWk6FV6Iao5V4nNpEMn7Eukrv9b-0wzpQvmgmeQqBzGsywf2XJRs
Message-ID: <CA+XhMqwZwjgeochTpBmC=PQfDXHxe5wqpQg2=_RJzPPoKG1+9A@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] mm/page_io: rename swap_iocb->pages to swap_iocb->bvecs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, NeilBrown <neil@brown.name>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0A7BC4000E
X-Stat-Signature: ymqneesrdc79yajij97p4auquxbkjp7b
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775114376-477687
X-HE-Meta: U2FsdGVkX1/sJmaaOdOp8A9xCMMj5W0ICHhluunrwjYegRKsL8H+Bp6oyTzl/Wlv6brKg6WEKlewDNzZ+x3oDHMLrUK1vcpT/s5Pvc4Q5s/7jZxtmx8xkwUJpL83WRuy7HqCw4hL8QP7w5CWoaO7kVUr2Gos6NZzMasQqFFQfEGyJK/VAYIvi8PagTYrGlZt2C8/EbTqoEhscshdYZM7YUoSCcfqrJi/E0yuY+f9Zh27pcjAGGLqzYLJYcR+nPcoOD1gWRY9EL/6LmuZtjS2+oKMe8cGGnbpwqgPuaPD/7ZClaow5wdRnno5H2QkX1vzWcFDps5a7lhF9rKWB4eK07xcC1JdOzdZYm9wIVutI328qyZyIUKKLijHea+O5Vqm9AgYGk9TZUvEdRPOv2lzDdZ2HEKxBxobRp8a+6D2r3Q9r1IIlrzs2YVheMzMj+6pTxPL5to/BOVqGEFW5M3xvlkF7oh/ionwCkbkEgwkpd+M/kn9VtdwItJeFlz+CxoqWRH/bscSSZbIe475yrE9hqhdcawyG84cUhdOLqNSc4V76bPICebnvhAnlQBVbIVBDj+Is3Swfpa2x31GIF9tBj+RWqmslkss6zdsalYRkUxbpLoBx+WEVCvEk7jOEApdBMX1USe6KmCEMh09e9lKWSLYdIebG/V+nFI4Imu64eKLI/78uTtDk91aMET42iGuY+zmDacp/gRTMhiJaXcZfSpFGepKj2/827buP/wcrOqDQde9fpewokfrfiNXg4rMAgkgKUbap91wJah0zi6SBFqESjsiGKEgha6lw+XW2SDJtXFWSeAbrRQr0qwt67Nruy3thytrLDq8sCbM25oxC3lxolpzk7RqzmWuCeGglRYYHuVM9ArtmdlIUQUi81u1/d4WrjIbM+xOhb4etcmN+84qFaHTxNHti+B6ZhOujRBxEfL9zjlVE+UNKFna8vaKTsLyZQTfZhDsbgdCW2w
 AvPcNwMK
 n5RBLOPWcU0kUxyQxeXQNL+or03F2CV4l9iAvafF+pQdBfz2GoWm2dMu0cCl1ola+seFIyA8cmanwZLpeQjtVQSKJfQ/29/bylsqB9jQMF0QfyIaB89pR3W7K+d6iPhSBUzGQrP7uDz6PeDQdwZBqnPVPwUnKFC+nUkUVNQrclwA2085WImaS/OMNKZxl+vnqQj50j1czkl1Km20KgY6QVX5Q2Fs5XZneUWu2F5YGFemogt6cqOviplF2Li+fZWmH53yCivttZPl8NA4YstOOqgpD04OcvdXQ7Xm2DSnY0TqRNfUdrfMrYbNXVFIWaRMwmaLoCoZZHCQxKEKROd9GkpoGhaWMpO8XY9kcUIZIg/VtaeQ3ihWXzUoH/HxLkuPwdrxBS1/amvzTwXlUyj+uTbQpLOjrQdIqw/Qs6MGZxnz984GE0Sbi8pGFPgPWnH8EzXZZe4AUYjguERY7ZJzfH83PSj+dE3MERsQn6IWrNk7Oeg/4O5/7XHBpv6VZ5xRZIQdhAF2bPOxROXOwyWWmMNnwteIn9YywOOrHeuqBXiyQf28=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I went for it initially but I thought I saw bvecs in a message :) but
I do not mind it is just naming after all, let s go for it.

On Thu, 2 Apr 2026 at 08:15, David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> On 4/2/26 08:14, David Carlier wrote:
> > swap_iocb->pages tracks the number of bvec entries (folios), not base
> > pages. Rename it to bvecs to accurately reflect its purpose.
> >
> > Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Signed-off-by: David Carlier <devnexen@gmail.com>
> > ---
> >  mm/page_io.c | 30 +++++++++++++++---------------
> >  1 file changed, 15 insertions(+), 15 deletions(-)
> >
> > diff --git a/mm/page_io.c b/mm/page_io.c
> > index 1389cd57ca88..e524cb821d04 100644
> > --- a/mm/page_io.c
> > +++ b/mm/page_io.c
> > @@ -327,7 +327,7 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
> >  struct swap_iocb {
> >       struct kiocb            iocb;
> >       struct bio_vec          bvec[SWAP_CLUSTER_MAX];
> > -     int                     pages;
> > +     int                     bvecs;
>
> bvec (an array of bvecs) vs bvecs. Hm.
>
> Wouldn't it be cleaner to have
>
>         struct bio_vec          bvecs[SWAP_CLUSTER_MAX];
>         int                     nr_bvecs;
>
> ?
>
> --
> Cheers,
>
> David

