Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49F56CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 01:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66EE36B01A2; Sun, 31 May 2026 21:38:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61F416B01A3; Sun, 31 May 2026 21:38:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DE76B01A4; Sun, 31 May 2026 21:38:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7F06B01A2
	for <linux-mm@kvack.org>; Sun, 31 May 2026 21:38:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CE3AC1D9B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:38:17 +0000 (UTC)
X-FDA: 84829633434.13.4018C4D
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D49A40005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:38:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O9gqRt2C;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780277895; a=rsa-sha256;
	cv=pass;
	b=kyrtQ/gFnf2jQ446PCzXN7VK/8p2rvubFcfVmVUrT1z2IjSOQz8MDRkxNm6HEYK2jXozO4
	9H3693JhpEKnfXsbinFK/PXnh7TP7ZNWV89HnxRFHBGFRzZULWnxxRzya+aQf+EU2se7v2
	jo4hKcA+AFN1hkFiKiWZFWy3CVYq83M=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O9gqRt2C;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780277895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgYsJ4zwRmjUEPGslz88JKnXrEQneRt57PE56bneuCc=;
	b=1tZjjCscNjTKo8a+Yfyc9wGwT8yYrW55Fr105dnFHG4WyQyTb2Gv0mBLwcAgAf6VtfQv4o
	kJPxPmZ9qoyrVUeyigWWRJDVN1+uMKuFSJLYl89f8fvaNPOUBLQFrZdAyJQ2qQCLO62m+2
	Th+RpFULc86ON14n+gWpvFn9fLIvMRs=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-396779b9a7fso8029051fa.3
        for <linux-mm@kvack.org>; Sun, 31 May 2026 18:38:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780277893; cv=none;
        d=google.com; s=arc-20240605;
        b=T2co4QgXk4XUVIxhz+aLq2/DI63Yg4VXK77YwYSaQZcuviAFQhg9IvU2lXKc+HWd70
         v9jBTYJtTmXYnPFRMQrDqvs2IKwURvdw11MHLsrrBVZZnZbK8scwvxOFkJB5Q2bqo9Vj
         xrIwLT8GUdJYcxh+3kdraKT54lf+0wFEFnv/I9FEW6mvMiTysnhyxqKo+en6wkaLPqM2
         XIff/z/U3LZhal0ozskuyTEw5tYy05rNeh01l/ySBI8VkW+cIxZUgLNn1I9DBJADeAAC
         ei5+7tuCg7L/AQ6X/eJwOGYKYLhkTldlPGMslBJWlkHZYs9ppf9duL13jCYcASMSJSZv
         7BaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NgYsJ4zwRmjUEPGslz88JKnXrEQneRt57PE56bneuCc=;
        fh=X3AL8CDWGefanMUmSiiEh5N9Eq0VVno8JPNzltOLHXo=;
        b=ZoQiUk6BIiskLn+dwnB+HX4KJT7L6Yyi/IK0U/rKcbOOnW6M4Vss9VmBc1QvSqCSpv
         pvi3EVbuUP6Vzs7Kr7j1zCRgNfmz9XnvtOp9bk1WW5nUAhUACEWQZGl+F42wVc5WCz+l
         TLIpgfznw9weMs6L25WKMoyQIiUmWAPrDJ//6zAwYhHvAHprCH4YcEgQqwgl6XiGcrHS
         /hyswCtb+NS3sal9z/ghxs2s6Vd2o0nDI9BGWZ36ZlFmkuiGXiTA0P/gjXoRSNM38rGP
         1EFjX0LrQ4FLQeNGK7ktFf4w8q1+PjtXoYVeWmtUl5IEysYJJiLdrtHjTO7Ifgb02ya/
         OnKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780277893; x=1780882693; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NgYsJ4zwRmjUEPGslz88JKnXrEQneRt57PE56bneuCc=;
        b=O9gqRt2COjclwIGu1VtQwa5HJly/7Is0VvVAzL5JY+GNlr6fR1Rch/syU60FQFm3J3
         pFhT4QjtFHepWPX2AZg6YmljvlA50eZ2nkZ+pmmi8bcfdwQRN5bacVs0d0xBypVIVHqi
         GpOzmNGP7kI5ndFCT5ksj0LZW5I9usdDHPO8KJgxxgyiyNFoxhk1fK+UU6Zx0YgWUCOI
         JiVGwZkgeDWOqOAeAFRPjn3xMbEV3v4bEZaoek+twpBp8+KRomIPbNMfkfZj8tQEU1YU
         KOnUSLW9lhIfxZufrf2kL0W5QS5TbqRHdBguZoYiNiplHPbz8ReCnKBTmLmZ0hAq8Hqi
         FCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780277893; x=1780882693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NgYsJ4zwRmjUEPGslz88JKnXrEQneRt57PE56bneuCc=;
        b=c1zUb334eNgdpdF6kmu7J077FGO3yH8xJ4kOYPzjhZhJtfB6paDGCUE55S+y0kohe+
         vfw2GWxpkKlEnDqBdV5kloNVilsNsiJc5H0ZXXfH2iYxvQIZa/jsCfIuU95hyeKY2UmC
         kcpEoiKLhgATXYH0o0/a94o+c5LUEWQjhWtdrXVjq7sMUJZUTWcBd+BQNAXf1AN6P9CE
         HJxFWffmBXq6GxQvSktneDLrSZMbcbJAAq2AV04necAoR9eeF2+OvmwcE+p4srqcifjX
         MvGd7asl/GDKA80cysqDQVBMkEnUnQNGR27adF1TEfESGFNtvsWg09lcOAvZ46auYowT
         EsGA==
X-Forwarded-Encrypted: i=1; AFNElJ8P8HYOt/8Oq7jGCREB7k4yb7lfEuwdtse8EQ7IqeaQ8M6mETXoggWc3zGfdgCytZUzH2EcFWK/iQ==@kvack.org
X-Gm-Message-State: AOJu0YxdzdY1u4WJBlreNWSJgtuRviD20azmxVg4UlffDAwmKFMbZbNF
	8gz/Slhlw1lZf76FHwQ1VVOrfz2ArNn6OzIT+e78aZbe02BlflXEtyZeT4wJx9KDz9Dw4NZKCHZ
	S272zp6kxW9trxJEz6FiTXOeMolvfFVI=
X-Gm-Gg: Acq92OG4ripVZysp0d4o8sXpaUfMwOd++3lzP1zgwwVLSBAprXFP/CGmorGELB1SBZ0
	Fsx2/yMAEWNLVksaujSwtW70cYe/1fUl8L8r2sOxQ/v/8+llwN/FY0rrsJIMTqC6xz4/BDroNq3
	Hgz+a/2RH+Y2hnxauxcEz+oPv0MdaNQ/BqkbliM1ByGIIuBzqxbpD8yyHZ3yx1ZuaqJWIOpprav
	I+20h7yE+Bj4vNHORLzsl0OlGQ+SYGQaWD9THcR+Y4Jx+tINSOMLKAQPfiRqCTbILGulVh4lneI
	DSUg1HjKIeZAeFRWPKW1ZGBiv1EbxUr+anU7m+sz73ZBC3g=
X-Received: by 2002:a05:6512:3408:b0:5a8:6e64:a932 with SMTP id
 2adb3069b0e04-5aa6092a8b2mr2100999e87.32.1780277893226; Sun, 31 May 2026
 18:38:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260531-zram-fix-partial-io-config-check-on-akpm-v1-1-eb085d98faea@gmail.com>
 <CAGsJ_4wB5XyUrPpg1O-pkySxo91RsHxaaUkR+Kt+heP4_OeeqA@mail.gmail.com>
 <CAJxJ_jgk8o12OYAi68JznpwKYTUJOUizp2PAZvNz2VdVGJWstw@mail.gmail.com> <ahzV6P4n2SICvh4R@MiWiFi-R3L-srv>
In-Reply-To: <ahzV6P4n2SICvh4R@MiWiFi-R3L-srv>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Mon, 1 Jun 2026 09:38:00 +0800
X-Gm-Features: AVHnY4KBs5581g5vn-ERqwgr_hYZsffeSZxDAcGCqEpflBR6h0FqURrT08-iJQo
Message-ID: <CAJxJ_jgx7vJNNYX=Cqk_D=7Vy6=D0BOVyju+NeaCip5L2VJgJQ@mail.gmail.com>
Subject: Re: [PATCH] zram: fix partial I/O config check
To: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D49A40005
X-Stat-Signature: m5uzf7sfwuqwy9nbracfxpkh4ujb6c5j
X-HE-Tag: 1780277895-572736
X-HE-Meta: U2FsdGVkX1+PD+XJK21Cg6M/Tof1H3hxqyq1bnRtGd2WTBnLG5RQrZp1bHvwZG5ijTq4bUVsSDfacnKj9nTFdf2YNGHEz+YmuSJg3gUp2jcQn1drou7eA2Ot+SAShk2aBmtcxZd/3NW35SVCGMe7P7lQVDyHKL8dBbP2A1ZfIWs/T2ud/eYsHE+QUlmldDFDUwDQNI4ejk77ic88Q11KlbrqfSDOcgD5boYb7EdypIa7D9u+T1do4Es/B2E5BMyFSz1s7bisRVZCbsNoA5P8olIVD9YrugDf9z/P0ppgrQzCbn7T2mjljcMzCh4kDvPPsgvG/pcN4reP0XaTkbusucl2y/uEvg4dcnseh5SXXUSQ6U7WWlqNkQ1cjwGW2B7iBQ9U2s0e+Q4vbzcd2Btww8Sr9y0+Lc5eYqG1B8gheGWKx9vHt6jPrX5XY7rTidzTQN7Wyph8Hh8/epyqt1JnUXjKkxrnABmxaCgefDmJ03ULXZ3YNpqSy1gztqIgctDoJ1UsMMGhWTGXovnNiJf+BaD5Y2nGcjcaHSMvK6U1Rjf5KD7I4qMFStbNnglyBZiT4VUoWIMNP6u+yA7GdbmXylhqSds9g5Emf5eevlWkywyaSn6JscYi1sLA3iA+2KgCDliSO/+pBES2QPCfVDuuUGLYjuP0xJz0qrjjuvRaEq7jd1m/MBON5u15TvHTefn3gWhxBx7I9Un+aZG1T3MG0XNjpvE1i+4Hby2aVS60XFYCM99s/K76U6O63/0083sCmL40JcI4v+525NcRQu1oJI6fvEw9veQs9OWc1uyDpNWsosORkMf6cfEFn6B755g/bxAoYMxkRGyz4wRyK2JTMwx0Y20q+zPZE/39ul1DZ50r4MfHAVVPCvV8pWNUD8J/3RdBupNOs5x/WZo0iONh0ZdeviFMbtvUihcbkiY4B47W1BUX1Z4M5SbJCrLuAgIWCBfINxki6PWbTkdcOSH
 YcwJJ0So
 OBQ3Xh0fF9SjWyHrXEZwP4rIGd/Y5zAXcDuiKUlflBi0neVDM4GuaJGeGverW+Iu3a4nTuJPWMg4XuNNQuBd1jsfSmcpIv2B+hKDfXCjgf1TA0rrcELVUpyJP6v/XWemDLcKQsruHXpFm6boL5a+5OnvH3qNKAXAX0S3XStxx/6J4Zm3iwoJmQyWErHPmphgIqOhx+OSoh9Lzpz7bz7R9Xr7qXjGd190OwUyLzx3mAdUv/9iEseFKmPcxDbToNmXjShamTxlCalx8rYxWDdUNOIJ9UIF1JbHHrd1/jZq46M1/x0Nu7v86IpL6hlvNVOdC6la+Mlw0Gr+r+4J5qWAPQzWwq4anuKlGqBC55Fnnm4tRZ7hHDcNZQvPUCXOVpYXdV8AftRS/uJ/x6QxuHTL1SF2Np63HUtVRCP8vSM3aYteszhsBFl8O8k7ch9HvW2MI96Qw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 8:44=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> On 06/01/26 at 08:25am, Jianyue Wu wrote:
> > On Mon, Jun 1, 2026 at 5:38=E2=80=AFAM Barry Song <baohua@kernel.org> w=
rote:
> > > > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zra=
m_drv.c
> > > > index 6e1330ce4bc1..72f89fd5572e 100644
> > > > --- a/drivers/block/zram/zram_drv.c
> > > > +++ b/drivers/block/zram/zram_drv.c
> > > > @@ -1510,7 +1510,7 @@ static int read_from_bdev(struct zram *zram, =
struct page *page, u32 index,
> > > >  {
> > > >         atomic64_inc(&zram->stats.bd_reads);
> > > >         if (!parent) {
> > > > -               if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
> > > > +               if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_ZRAM_PARTIAL_IO=
)))
> > >
> > > However, I don't see ZRAM_PARTIAL_IO defined as a Kconfig option.
> >
> > You are right. ZRAM_PARTIAL_IO is a local source-level define, not a
> > Kconfig symbol.
>
>
> How about removing ZRAM_PARTIAL_IO and use PAGE_SIZE to check?
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 07111455eecf..ca0c29482283 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -221,7 +221,6 @@ static inline bool is_partial_io(struct bio_vec *bvec=
)
>  {
>         return bvec->bv_len !=3D PAGE_SIZE;
>  }
> -#define ZRAM_PARTIAL_IO                1
>  #else
>  static inline bool is_partial_io(struct bio_vec *bvec)
>  {
> @@ -1507,7 +1506,7 @@ static int read_from_bdev(struct zram *zram, struct=
 page *page, u32 index,
>  {
>         atomic64_inc(&zram->stats.bd_reads);
>         if (!parent) {
> -               if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
> +               if (WARN_ON_ONCE(PAGE_SIZE =3D=3D 4096))
>                         return -EIO;
>                 return read_from_bdev_sync(zram, page, index, blk_idx);
>         }
>

Yes, that looks good. Thanks for the patch.
The synchronous backing-device read is only needed on PAGE_SIZE !=3D 4096
systems, where partial I/O can happen. On 4K systems is_partial_io()
always returns false, so this path should not be hit in normal operation.

Thanks,
Jianyue

