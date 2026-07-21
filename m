Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ECA8C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85CB66B007B; Tue, 21 Jul 2026 14:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80DF06B008A; Tue, 21 Jul 2026 14:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D6116B0093; Tue, 21 Jul 2026 14:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CFC36B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:35:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE0CE1602A2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:35:04 +0000 (UTC)
X-FDA: 85013635728.16.E42C759
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id D654BC0004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:35:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nuY2n+kt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784658902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z07iHwOcru2qSeXhXWPF7DB/0FLJbw0SRqcTvMT8pxg=;
	b=cnK3SfJPZ7T1dJ0ruIhh+Nu6Dtil8gLS86iJ/V5AUrExPInc29DV7zqDrlTLK+ucrLnVXO
	aZ5XDg/v0BZ57tGMI8V6RHxiEF2hi7T5C4p1A1aYe1NMCh5BZ8IOkSojswfUTso16Q4ycy
	EYgAsBgp2kvgUUODsKikhEbsyNdAUwM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nuY2n+kt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784658902;
	b=EJcf7jnwg9b0AW6W3SVhgfrGfVXvfiO+rMazQ+swi7nHXUs74nku8HMJFE+qmUH67AE3Rl
	FDXNcxRFshlLzBUhubv89Zp05ZqL52F6xq+vtp8y7qS0GhDF8U99ehPkgPSuH8raNv86vZ
	I7oFKsXqE0dFPELuobG9gBcxSMTA280=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1600d040e4so806135966b.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:35:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784658901; cv=none;
        d=google.com; s=arc-20260327;
        b=gjrYXBqO265REQj8i3M7qg+cYnpsQw9PGR6rRtrIRO2Z0DvMUfM67La4YMIZJ/94Px
         9vzqqSlIFj1D7cuobGjtWS9ZhL6OxsXzppje0cpenNqBLhWyq4ds1zLgOJkaqgIjkR46
         nt6xjddW6YaV5fszZxalp7mC2xo/qXRD1a8Y+JYgKj4++LJ1eZZY+4TRnZmOHbuDjeLg
         alr/9X2thtqs6Py8ikggp2m5HwGysjy+VZBRoHzggM0fPm0oSbJRyb4NAkFSQMo5pJxv
         FjbArr5/uGZpipd3f9XS8QiEbpk+xWJSDjgiUEtb8JiiAaQ+2/upe9yqiXSPtF3jk7y+
         RUCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z07iHwOcru2qSeXhXWPF7DB/0FLJbw0SRqcTvMT8pxg=;
        fh=aDEsf14Z7ChCB+peCXtKxx/tBpCUYdvF04sQ43qSjrE=;
        b=N5+osBO8ha43Ai4O4mtNHmp0t9rXFsKCAWwAcTlwfbilvfzlLUa6oqwZM4g1zMgc/d
         4llH4qdG1RctRxtp/euGLOf91MInBBoExmEy7x0gWqsJd9iQzRpzzEh6CrwkCG7b1WsW
         +I2fP3acRiF5qUmx5VtOkgR35qBArhJVKoEbZ+PeJyRf3WjQqdcthZ77tPpbEt83s3/V
         +KZ/W9lcTyIUXMNZJzv8FqP0DfDf6S0vfsfWEYSf19T8HW5wnpve8Wu09hfitzXSgohv
         acgvcGeEIrMiFSYC1RvEc14V+JP3BvV2rZ2b74h4d2eYRkrjh06EFkBrsYD63nzglncE
         Ea2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784658901; x=1785263701; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z07iHwOcru2qSeXhXWPF7DB/0FLJbw0SRqcTvMT8pxg=;
        b=nuY2n+ktTSGHxWm+V3AUxMjw8Yua+U2j4RA9vlQWsjzkpvDoBe0IgRhYmXObrdl4MQ
         En5BW9yjOB+OvhRKC5hTEda9QELaEvXqeq8UgQ8AlKEN82WKvkIxcJIyN1CzMI1ZkZ0/
         ZX8V8xejZPWLB0Rmt2aEie8hjUzNKNb5m/ftEEATT9vficXkqxqn0iMHIfDCVLIcf3uq
         skpr4hyV59cT/XlRDQk/MPqlgPaoWFAXPUbMTXKSXAgeaIwnUsfmtds4gGkD1VH7rx8m
         0I7g6ZZKGB9ApN1Zc2AN9v3xCWU36XrruNKyrUKslG1QoKO5y69vXRcLUku3wvsyNXmS
         TF7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784658901; x=1785263701;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z07iHwOcru2qSeXhXWPF7DB/0FLJbw0SRqcTvMT8pxg=;
        b=INbMoTB95s3Zfp909hc5EXCmAiSuo5uR4cq8JH2esBTLRUiG9ljHlij0+/ZduJzCA8
         qTLaW+UL9T9LPhqM+ebeNC9JQ7ICf8OeyysqwDYTytWS9sYlX5Sc8AIkj9bnQGWflSaS
         USGx+Y7LC0mL/cRUZ8fybC9C1KmoXnXaiReLrDwZPU2JYj0fjdQQHXjkucqEpCDctQ0Q
         MOHRVxRUW0f1vNmqoj56ZBBfD3vPZiq+PAKPH31GI94L4vdcc3YeuLqy79Oza2Bpv2a0
         wyQAtrb8vBtcYafiZrC+D67qYVgYU1B6Xs3KU1KNMLyHRXm7cH3wNcM1llcEMfpXQmQp
         8mHQ==
X-Forwarded-Encrypted: i=1; AHgh+RpHdsjRK9uVLe6ZkXAOKn7MmncsxCaDejvavqp2GiXI65ncHodEKxEXCXwCbet1JAtldanvLVZaAQ==@kvack.org
X-Gm-Message-State: AOJu0YxrQkazkqvOLDfIpAFqfujTuCozJ+ZFuG7EkxTiPUJB04iaFpEi
	HExdAPyfxWN8nzP7JricuKwMMPQOOLlDjcYSzLhzUha8qG4qWsL9q2TkoRu5k1opWoEvLevFbt5
	wMzIXXLYqehVo9AF4znljWNakA3ZV4jk=
X-Gm-Gg: AR+sD11mrqxHmG9grDPd1uh8wWTk748V4i82trXp7nvxdzKni+bjXUbBkstMgXYDhPz
	pMvPROy7Xyat7VNoInUQLlyRf5lQDMX2dame5q5HtEK6bQMvH5+cgfab8IaYNVTdpYGtBhClAf0
	PIC+V1zIN4s0+Q0WzpYWpXBhQrQsDlwxbwqKIX4cdpkLjCXHBx4hBFbE90wZxbt1JcVKHQ4kB/z
	j3KIygA5XXWZhIsfqJXEsECe7TuNn2B01SPGa3PLY6ZhnmqAew5IFA1dTkKEi28O++EMMgEpTlH
	jAYRpMlWJP9R0FdqDnc=
X-Received: by 2002:a17:907:3e8c:b0:c15:dd1f:f2d with SMTP id
 a640c23a62f3a-c1c310a86bdmr32882966b.25.1784658901167; Tue, 21 Jul 2026
 11:35:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260713093350.2154226-1-hch@lst.de> <20260713093350.2154226-4-hch@lst.de>
 <alZ0fgRSy0RpHxcT@KASONG-MC4> <20260716121953.GA28985@lst.de>
 <CAMgjq7BLD+OV3OUcWZidkbKwmb3dCeLdAWP-BOpgRQSM3SLrSA@mail.gmail.com> <20260721053848.GA7538@lst.de>
In-Reply-To: <20260721053848.GA7538@lst.de>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 22 Jul 2026 02:34:24 +0800
X-Gm-Features: AUfX_mz9vOuhnNDv9Cy_fhzmykr3825PX0roFLzjbkVVQJ-4XgKQBuVn3rQ2TXM
Message-ID: <CAMgjq7CR1-MDxvRwNpE=_WThLTZekq8c8TUdhuQH2-Q4FQiu8Q@mail.gmail.com>
Subject: Re: [PATCH 3/7] mm/swap: also use struct swap_iocb for block I/O
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D654BC0004
X-Stat-Signature: qq6fetg4j9xii4p6yykm8umnq8jjkefi
X-HE-Tag: 1784658902-863221
X-HE-Meta: U2FsdGVkX1/qKXu+lnk6zwtWo47FeKoQwb4QWdvTeldvwYbJe6o/zlkytT7G01dg0HC/otLM/Qri3LFaRQGnLD1ZTOkzobgz8PhCZg35sjooqVexWPj4VXkazFgzWO0itmcAxqA9k30bLIwihg8b/ii1Z/MT8R5CPHqLZI5XjwORH71NRnALKDk+ypxjoc8lJfIfKcKEIZxPtsvRhEmA6/gIROvvMKWENbXpHTODN8smekNbGeJZSMQthHC7qZdWbyQ/L/kMu0FUHFyDUqKs5dKqfP9otN4/Eb5jgHjInnhiOs7sAuqc4R1LAyN6wR53k3smS3fKGiCcWoSf3kv4z5O3tBFwiXICgEJUQ/lEMhhhZL2uuqNwd9UiUo+tJh0Aj6/DXh7poMnKrgN7lAUo4ShrOhootbksCKqEz2qRCshKGf8F8TAs1Ka+Vkgb3U4dNuNBu6Q6FLhgNavNSaXo4STLrThwSlVNxhbqZ0ZtjnV8gOu4xAz2mvswa3GmOiEPtgSNxQs4GSP9f4Br2B2Zq0CSE28ans6dFWDb0Gha4uRug7iqWL174Ebd8eH7MXEZnTUPKO08GwF9HOoLHZssS/K1dDnatGH8lENSrzrxyQAJhl1VaPCJfT26pOgOFRIeqDHXs3YtXMe9xJ7gCfD2UC3i8giKFFsMB7V9czFMHXoBuPfsi3r7wzmieuNTmdOdFWP7sGlGy88STlyjI34mMyPdbirIo+R4DHqGS5YJwimes+aw83+y6RtdvMbrIrj5iYXzfwjqlfM9sJKPLRo6d8QYmTqMBffinYJjqxzYWNQBi7H/d58lo3hT1WOgO1MxdmqKHoBUudpIFioogq4XCuKzsyXv4wYB1GiEGE/vhswab/GHJwxdoKdlhmRv1SDjsVIgNRhI3O1S/EkLQaa7Ew5f9TB+Yav73wU3IITLKphmAJ/s9DrfXMLOvohxFRZ42g0e+YRVB1FbyxCI9nM
 usWIfRP+
 hBiYHoA5qC0Jp1ZmmD/scJamS1B1KhMkpOTCmxdOLemnrT9SKlq0sOM2bfvxP2xMWTiEOZ2FQr9Fubm1xdF0/zOm2SeRtdf2jybcQlbFtVoTL9iWuY2bUUJPDn+cOPRm1pHShHEwWpTd2BcQlySa8D+GzFGQzdu0otfJ0aH+fPlc7BQEWQLUkbkJiGdZMXCglz92pX9AwyZBNqqIMdGfxWbxpIOBKCcZOJfva+iGG1673D6rwOxE7jzq2k7s9FnUeYakcm0+A+R2y5sfQs6luejtfQ5gLyUrxi92iHNeWam5VJ8JefARArcN6wZhxHw5U9jYeU+4O814nYMMb4H1ODrY+5WnBwjURT8jxSnq4OVIEaT0cuoQdJ7+2hLWJlqMCJfPk3CIbcMusG5E4nmE9/T9kDHuYbFQ0B2F56XgzsfMgUEq/CzIP52QG5EtqDdM+c6O2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 1:38=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Does this look good to you?  It has passed some basic zram sanity
> checking here:
>
> ---
> From 31c1466eacefb68d41848cfbb5dcd4f86073256a Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 21 Jul 2026 06:42:26 +0200
> Subject: mm/swap: revert to single-folio writes for synchronous swap devi=
ces
>
> Kairui Song reported that zram benefits from submitting each folio
> directly instead of batching up I/O because the classic LRU scanning
> benefits from clearing the folio writeback bit in the scan loop.
>
> Accommodate that by kicking off reads for synchronous devices for
> each iteration.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/page_io.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index e4fa7ffffe8b..c984a4023a65 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -358,7 +358,16 @@ static void swap_add_folio(struct swap_io_ctx *ctx, =
struct folio *folio, int rw)
>         }
>         bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(foli=
o), 0);
>         sio->len +=3D folio_size(folio);
> -       if (++sio->nr_bvecs =3D=3D ARRAY_SIZE(sio->bvecs)) {
> +
> +       /*
> +        * Write out the iocb if we filled it, or if the device is synchr=
onous.
> +        *
> +        * The latter is to work around expectations in the classic LRU c=
ode
> +        * which make synchronous clearing of the folio writeback flag in=
 the
> +        * reclaim path beneficial.
> +        */
> +       if (++sio->nr_bvecs =3D=3D ARRAY_SIZE(sio->bvecs) ||
> +           (rw =3D=3D WRITE && (sis->flags & SWP_SYNCHRONOUS_IO))) {
>                 if (rw =3D=3D WRITE)
>                         swap_write_submit(ctx);
>                 else
> --
> 2.53.0
>

Looks good to me, thank for the update.

