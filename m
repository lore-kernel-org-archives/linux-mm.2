Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D3DC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 10:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE2E6B0093; Mon, 10 Aug 2026 06:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE2F6B0095; Mon, 10 Aug 2026 06:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94EEB6B0096; Mon, 10 Aug 2026 06:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58F086B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:23:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD930160704
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:23:44 +0000 (UTC)
X-FDA: 85084973568.19.930B397
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2AD6480006
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:23:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="ir/ZsRJj";
	spf=pass (imf02.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786357422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BdyANCjCkJ+TfDWbmGMzYzdTHWuRlzmp/fLdKDSudAw=;
	b=t8vEx4DUOPzOm2TiFX9DopVyyss6Y8nX9CAPJDs41FEg1hDoqDshgTtLPlxat1TVUrgJrn
	6wxx8VBN4O+8qKYl0ZH+BO8bxfkhns849ckKfYlxh17E/iByXQHNLH9SxRdTfSDX5FHa5x
	FlDFYzBtHCur9dQ4v2pN0Jvo5MfA2lM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786357422;
	b=vu113BwI5y7VYOjINK2V3mVjN33xTYaof9z1InA4BghE+t/yQlT+yn2KUW4HOk5WTVTH7K
	KlauHMtz2tzVqkAwy/9xfShs3xQ2z6hQ3R/i0ZbjXX274jzk4RHvTQrElLkVPjwAo8eFrJ
	eFdi7tkHXYRWj7ZT9z2BCC62PngZ5Hg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="ir/ZsRJj";
	spf=pass (imf02.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-4518ad44e83so1009586fac.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:23:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786357421; cv=none;
        d=google.com; s=arc-20260327;
        b=HSWxml6V/0NHTPP01Xc371nrr2x00oEy3qt91wy1YA3kkVwrPCNwxmHVfHzmZcUIc7
         PS+SsFFtAR2RP6h4aPBlvwq1zlgHAazyLBlVA0f6aCrM6csof5CaaiQiAxloltAQBMl6
         31JFc3aXVy957G4cdcff2p43fvIk9vo09TcP44KYse8Elk5oo9n5A7hFPqsEeoDhgQRc
         astI0dFDiAtQ8I7h77APisHDKtmsddgzGdswKDtIC3dEJcEXRN7DcvhNg2hgd1ejqW8G
         OHIqg0/58kAwgZ203M8cSipHBM7RxxHS2NumVxM+oKY5GBUWZaOdeyH8ClfFLCNmxFgd
         mTEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BdyANCjCkJ+TfDWbmGMzYzdTHWuRlzmp/fLdKDSudAw=;
        fh=hHTq4QzmxLpGXddTjsIkUDmPrPAeHfP/xL4kqKQXZBI=;
        b=eocKC99Uaj8Qw1JlZK7FuIMdCk4n8N2ax3tOfl0dN2Wu32rG5ZY5imo52FmJURYzO2
         mVrwyOc5gVtzvoNuTK7Srdh20O6njJyOrJ84guNrnyWWGKuLcZht/u6NcaXWSqUeccyG
         e2qw7dxdUxzQa+qbRkfJ86Md18yrXaCxVaLEa8VDJeIagtPz6GbqhoqF3vpEDJZzSThf
         PpeZRfXXYH2gZOlBgvvT2Yjuwb1ECfVcPJk7iE7v58l7mTeYdcw0oS3tX/A+9K4qb9Ph
         QvaIM8WOIPEdOyJp5LKQa7VLWe3ztwScg4qdND3dySl3aVAP66iUaPXjmCDLHMNXmvnY
         zgZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1786357421; x=1786962221; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BdyANCjCkJ+TfDWbmGMzYzdTHWuRlzmp/fLdKDSudAw=;
        b=ir/ZsRJjM5JPgAr4i3N80TMu14HGDizXRNfBPvp2TQ9Nre86H/L0hY0lcjOt6B2jlN
         fhjkhsRK3+9wP+AkN7fJ0Vg7LTQ+31YfOLWSvnjqZKI0/1l1grXkPK3B1pfUfwu2J4pR
         GITdWjHgjFsiNLWcQVZ4VrDr09XBdxdDpqYTi5W1gX70i8un2McDlsaVUKpkuUJtnSZZ
         T9hEFcl34wzM+/Musvs6Stu6KICvAWwAahhgyU5ng0JSUy8AXD8ePGAECrOUNegP3I3E
         VlRJPtB9G5LJXsZqx6pus8U1qKi51UTVr+ECaiWTL29+nge+cDj+EZhz4KW9IRjsOKl+
         XNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786357421; x=1786962221;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BdyANCjCkJ+TfDWbmGMzYzdTHWuRlzmp/fLdKDSudAw=;
        b=Ka7KxQKe53cQbB0RUd5PLkyPL0ZoStf2JsbxpKX74BMYrwLY3NVZbAVnwj1hQEBxDJ
         VNb0gg6GFM4yuwbDiIVeNxhj82Fabtxjrwa9y1XEV/o/ItW+pqNhjvs0xKLD4fUEBaCa
         2f10ZrPWcGHWwdsuGXyGBRP2PfTy+5Qle3THMN8CkuJex8uOLmb5s0IHdkkgHSWl526S
         +QmUNlvMficLgovWyKqS12DJzLf183tPCYoh3GWstd8zgraQQAHsWIN+v94/7OsKk+qp
         dZ0ROswiiDO0oeuekwHOsM51aQSkkFce6sXspn++9pYlHBJ2jdAYyDZFk5J2klxzFcy3
         1Nrw==
X-Forwarded-Encrypted: i=1; AHgh+RrYaT7rFDrNQg1R4SOGEz6oMpXyT7vDiPXZ//bwba3mONQz+9SqV7HAotua81r9VlqSPrYiz9QKuQ==@kvack.org
X-Gm-Message-State: AOJu0YyPUMoKyaH2cFzkhZCpHP++f7YhyKxPt6fU3vZ4PB39PnZN7tOE
	jZmPMeq4LZ+iBHaQlMGYC+cD5FTXlmt9JuQ3N3K2ZR8Nj9gejTknAvg5TyOP/kxLPgbfS/3aRBw
	ujBuKBJ5yIJheQPYYrFWdDDI5XD+JuGF1q4LIOyoOXw==
X-Gm-Gg: AR+sD101BkVW/R55bs90qWig0QlMbkkxBu/Ddx2lW7Egn8q13UZiJgxOrTWMe6EGJ89
	HFedXgN6lM7EVKVTmMRxwvo9U1a6e9ayHPfUK7BFdY8imrreyBnC3RiHvwXzqAS4nkyBzaJyj2d
	lCzod08mUY7Q3ij+mHH+mMY4tQX3a8A2FWd54UQqstVj3AJGblkIxX9xUsyZI7JsRN7xkhmAS94
	bIuip7PSDKApd/irzVWqBZFFdyteNG8wzmdRpd7muZQJ+Ge03wCiDAdoWX04OoDISM7yyb7OmRk
	p8Acsjj00JNqrykECf1f5ENIKrbiBb3fU2d6fyZsn1/2TfI=
X-Received: by 2002:a05:6870:2d1:b0:456:b63e:658a with SMTP id
 586e51a60fabf-459e391213emr14978663fac.18.1786357420845; Mon, 10 Aug 2026
 03:23:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260608025043.88087-1-cuiyunhui@bytedance.com> <09ee2ea0-c93f-406c-b5af-1fe3a50c8989@kernel.org>
In-Reply-To: <09ee2ea0-c93f-406c-b5af-1fe3a50c8989@kernel.org>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Mon, 10 Aug 2026 18:23:29 +0800
X-Gm-Features: AUfX_my63ARI2eXUc2-yPXbYwqXPFzXgw_p2nJJNLFoZTC92nBcJ_eHY1Chb4zg
Message-ID: <CAEEQ3wm8kyDSScYsAMTf6jdEqnQzQSi1xykqH2Z7vvJzQNc8Jg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm/gup_test: fix race with
 PIN_LONGTERM_TEST ioctls
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, yang.lee@linux.alibaba.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2AD6480006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: y1aemeadtthwtbji8n985e3f8bfkg43r
X-HE-Tag: 1786357422-184480
X-HE-Meta: U2FsdGVkX18OU4eHMxv3AVsDaN8OwRQgFWhmppbQnPnpL+Y5cpIopAXyEK5LSJf6DacSVmwUvILd0ag9+4Sh2ISAWo+qh8NxiuejbCkfJbPXI/u2wCrrvss8Zlv3hHmqhcgX1vzMXjEYhBgUBuVB+gvhlq1Z4VJEj5GhhaDCxlmKFu9pMXVx118YgE7A/QF28y86mwx48D/iMnTQ2eSmc0oJG9e5fM+AK3y/jxJjT03YJvhdpV1zCogk68IoWf/Cg3ittuJwU53KK5MdhoHbUDN8XdUlHHCZPpERpndPTSaa5sNwnV3ZqPcmR+JP2Ezx7TGIYmReejQihejaRbX2vW3VbRoqiprSYA/w52fNaH96zzoAxk472Kf2xRXzN/Z1pEEeQwPakzDgbrU3x35BTuiHyDlkOu3Sp5YahGR7VquHxZV+9zGMkCME8Am3CVfLmyLkZxVBH6grZoc/Zip0dfdMy6GGiiudvIf2QWsObqxWbonIOdpXePYNWQG0KysEcvaPNjexBu/M1NIFIQ/Pr2KriTPN01m2FAMvCD7lrX+AKwpa3eupbrktW6tJEMCM3WmPvEo4IlOmbUTWyIhZ8HAFqrQb2vDkW9Zi0G/IfdTRVqFYcMI0eAX6pWc3U6La35i9qBAi2FLH1K6K7sid713Qr3TW+ZcKutZv6wwIQPiO7ushYZPzHAVzd0NR6Yhg7+ErFD22D2FGBzZWBI7W/UZfHqWufBv1UoPA0nct9yWzV8X/cn38BtTK2B5F3bQrZYzSAI2l5k5845Bn2E64gkBxrOHSvkcF7ZD+VdLz2Hl/agOw4pohFv8YOBOTOvijMjsDZ3AP9J8G5O5PcMnw9VywqeigLtepqfMDNFtD7cTMLGdwh7JQIEL8Ttggywl6MIlvbbjHIpKu+Yx6GT327laRCm2InCNO8R5gMTCB3UWZRZOapWe1BzgvHngFMVoWn2dlnnF7LfvIiDFmggb
 mytR5G+n
 j+TOIphxegwI8u3KAbnRLdmBY4MMlsHgZgcY1Z+z1yQwojtBlYO1TMh+9Fg62/wRoSg8ScLWxWUroQWUx00rmCkIlNO+iQzonWEyKrD9SJRPUiZfAofZoyOYT2pq5opfa11jryKambzneKh4OcLK/pjDaBnndw5z6ROwjHZ309LJp7Pyjwm+9hk0cASnE8hkOinxc8L3m3EWO1VTmNtDNhT395EBMARjKAgZ7WY7ox+oHqckDnu7p/dUqD6oKsa7JybLW6qFYiS4HqDY76/RnO3G/tWRgbMkafvUhyjF8jHUm0X+YEIYeWHVnvgXYrOZbrOqoYPvC/4VseV0l9qcy8G5vVMK8ZyES2hRf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Fri, Jun 12, 2026 at 3:36=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/8/26 04:50, Yunhui Cui wrote:
> > The PIN_LONGTERM_TEST helpers keep their state in global variables that
> > are protected by pin_longterm_test_mutex when accessed from ioctl().
> > However, gup_test_release() calls pin_longterm_test_stop() without
> > holding that mutex.
> >
> > This can race with PIN_LONGTERM_TEST_STOP and let two callers operate o=
n
> > the same pages array concurrently, corrupting the test state and possib=
ly
> > freeing it twice:
> >
> >  CPU 0                              CPU 1
> >  -----                              -----
> >  ioctl(PIN_LONGTERM_TEST_STOP)
> >    mutex_lock(&pin_longterm_test_mutex)
> >    pin_longterm_test_stop()
> >      if (pin_longterm_test_pages)
> >        kvfree(pin_longterm_test_pages)
> >
> >                                     close()
> >                                       gup_test_release()
> >                                         pin_longterm_test_stop()
> >                                           if (pin_longterm_test_pages)
> >                                             kvfree(pin_longterm_test_pa=
ges)
> >
> >      pin_longterm_test_pages =3D NULL
> >    mutex_unlock(&pin_longterm_test_mutex)
>
> Okay, thinking about this some more ...
>
> I think what's really required here is that we have two separate "struct =
file",
> because otherwise release() cannot race with unlocked_ioctl().
>
> Which is something we didn't expect when we added this functionality.
>
> I think the proper way to handle this is by moving the state to the
> "struct file", to actually cleanly allow concurrent usage.
>
> So instead, I think we should do the following (untested):
>
> From 29e3d6fe00c4bd843d11bb548efa89bca478436c Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Fri, 12 Jun 2026 09:22:25 +0200
> Subject: [PATCH] mm/gup_test: keep longterm pin state per file
>
> The pin longterm test currently stores its data globally, shared among
> multiple concurrent users of the interface (multiple open file
> descriptors -> multiple "struct file"'s). That makes
> the gup_test interface problematic to use concurrently: two users, such
> as concurrent selftest runs, can interfere with the same longterm
> pin state.
>
> While this has not been observed as a problem so far in practice, let's
> just handle it cleanly. There could be a way to trigger selftest
> failures by e.g., running the cow.c and gup_longerm.c selftests
> concurrently, but we usually run them sequentially. Let's add a "Fixes"
> tag to be safe.
>
> Fixes: c77369b437f9 ("mm/gup_test: start/stop/read functionality for PIN =
LONGTERM test")
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/gup_test.c | 93 +++++++++++++++++++++++++++++++++------------------
>  1 file changed, 61 insertions(+), 32 deletions(-)
>
> diff --git a/mm/gup_test.c b/mm/gup_test.c
> index 9dd48db897b9..16916056677e 100644
> --- a/mm/gup_test.c
> +++ b/mm/gup_test.c
> @@ -8,6 +8,12 @@
>  #include <linux/highmem.h>
>  #include "gup_test.h"
>
> +struct gup_test_data {
> +       struct mutex longterm_mutex;
> +       struct page **longterm_pages;
> +       unsigned long longterm_nr_pages;
> +};
> +
>  static void put_back_pages(unsigned int cmd, struct page **pages,
>                            unsigned long nr_pages, unsigned int gup_test_=
flags)
>  {
> @@ -204,23 +210,20 @@ static int __gup_test_ioctl(unsigned int cmd,
>         return ret;
>  }
>
> -static DEFINE_MUTEX(pin_longterm_test_mutex);
> -static struct page **pin_longterm_test_pages;
> -static unsigned long pin_longterm_test_nr_pages;
> -
> -static inline void pin_longterm_test_stop(void)
> +static inline void pin_longterm_test_stop(struct gup_test_data *data)
>  {
> -       if (pin_longterm_test_pages) {
> -               if (pin_longterm_test_nr_pages)
> -                       unpin_user_pages(pin_longterm_test_pages,
> -                                        pin_longterm_test_nr_pages);
> -               kvfree(pin_longterm_test_pages);
> -               pin_longterm_test_pages =3D NULL;
> -               pin_longterm_test_nr_pages =3D 0;
> +       if (data->longterm_pages) {
> +               if (data->longterm_nr_pages)
> +                       unpin_user_pages(data->longterm_pages,
> +                                        data->longterm_nr_pages);
> +               kvfree(data->longterm_pages);
> +               data->longterm_pages =3D NULL;
> +               data->longterm_nr_pages =3D 0;
>         }
>  }
>
> -static inline int pin_longterm_test_start(unsigned long arg)
> +static inline int pin_longterm_test_start(struct gup_test_data *data,
> +               unsigned long arg)
>  {
>         long nr_pages, cur_pages, addr, remaining_pages;
>         int gup_flags =3D FOLL_LONGTERM;
> @@ -229,7 +232,7 @@ static inline int pin_longterm_test_start(unsigned lo=
ng arg)
>         int ret =3D 0;
>         bool fast;
>
> -       if (pin_longterm_test_pages)
> +       if (data->longterm_pages)
>                 return -EINVAL;
>
>         if (copy_from_user(&args, (void __user *)arg, sizeof(args)))
> @@ -259,12 +262,12 @@ static inline int pin_longterm_test_start(unsigned =
long arg)
>                 return -EINTR;
>         }
>
> -       pin_longterm_test_pages =3D pages;
> -       pin_longterm_test_nr_pages =3D 0;
> +       data->longterm_pages =3D pages;
> +       data->longterm_nr_pages =3D 0;
>
> -       while (nr_pages - pin_longterm_test_nr_pages) {
> -               remaining_pages =3D nr_pages - pin_longterm_test_nr_pages=
;
> -               addr =3D args.addr + pin_longterm_test_nr_pages * PAGE_SI=
ZE;
> +       while (nr_pages - data->longterm_nr_pages) {
> +               remaining_pages =3D nr_pages - data->longterm_nr_pages;
> +               addr =3D args.addr + data->longterm_nr_pages * PAGE_SIZE;
>
>                 if (fast)
>                         cur_pages =3D pin_user_pages_fast(addr, remaining=
_pages,
> @@ -273,11 +276,11 @@ static inline int pin_longterm_test_start(unsigned =
long arg)
>                         cur_pages =3D pin_user_pages(addr, remaining_page=
s,
>                                                    gup_flags, pages);
>                 if (cur_pages < 0) {
> -                       pin_longterm_test_stop();
> +                       pin_longterm_test_stop(data);
>                         ret =3D cur_pages;
>                         break;
>                 }
> -               pin_longterm_test_nr_pages +=3D cur_pages;
> +               data->longterm_nr_pages +=3D cur_pages;
>                 pages +=3D cur_pages;
>         }
>
> @@ -286,19 +289,20 @@ static inline int pin_longterm_test_start(unsigned =
long arg)
>         return ret;
>  }
>
> -static inline int pin_longterm_test_read(unsigned long arg)
> +static inline int pin_longterm_test_read(struct gup_test_data *data,
> +               unsigned long arg)
>  {
>         __u64 user_addr;
>         unsigned long i;
>
> -       if (!pin_longterm_test_pages)
> +       if (!data->longterm_pages)
>                 return -EINVAL;
>
>         if (copy_from_user(&user_addr, (void __user *)arg, sizeof(user_ad=
dr)))
>                 return -EFAULT;
>
> -       for (i =3D 0; i < pin_longterm_test_nr_pages; i++) {
> -               void *addr =3D kmap_local_page(pin_longterm_test_pages[i]=
);
> +       for (i =3D 0; i < data->longterm_nr_pages; i++) {
> +               void *addr =3D kmap_local_page(data->longterm_pages[i]);
>                 unsigned long ret;
>
>                 ret =3D copy_to_user((void __user *)(unsigned long)user_a=
ddr, addr,
> @@ -314,25 +318,26 @@ static inline int pin_longterm_test_read(unsigned l=
ong arg)
>  static long pin_longterm_test_ioctl(struct file *filep, unsigned int cmd=
,
>                                     unsigned long arg)
>  {
> +       struct gup_test_data *data =3D filep->private_data;
>         int ret =3D -EINVAL;
>
> -       if (mutex_lock_killable(&pin_longterm_test_mutex))
> +       if (mutex_lock_killable(&data->longterm_mutex))
>                 return -EINTR;
>
>         switch (cmd) {
>         case PIN_LONGTERM_TEST_START:
> -               ret =3D pin_longterm_test_start(arg);
> +               ret =3D pin_longterm_test_start(data, arg);
>                 break;
>         case PIN_LONGTERM_TEST_STOP:
> -               pin_longterm_test_stop();
> +               pin_longterm_test_stop(data);
>                 ret =3D 0;
>                 break;
>         case PIN_LONGTERM_TEST_READ:
> -               ret =3D pin_longterm_test_read(arg);
> +               ret =3D pin_longterm_test_read(data, arg);
>                 break;
>         }
>
> -       mutex_unlock(&pin_longterm_test_mutex);
> +       mutex_unlock(&data->longterm_mutex);
>         return ret;
>  }
>
> @@ -371,15 +376,39 @@ static long gup_test_ioctl(struct file *filep, unsi=
gned int cmd,
>         return 0;
>  }
>
> +static int gup_test_open(struct inode *inode, struct file *file)
> +{
> +       struct gup_test_data *data;
> +       int ret;
> +
> +       data =3D kzalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       ret =3D nonseekable_open(inode, file);
> +       if (ret) {
> +               kfree(data);
> +               return ret;
> +       }
> +
> +       mutex_init(&data->longterm_mutex);
> +       file->private_data =3D data;
> +       return 0;
> +}
> +
>  static int gup_test_release(struct inode *inode, struct file *file)
>  {
> -       pin_longterm_test_stop();
> +       struct gup_test_data *data =3D file->private_data;
> +
> +       pin_longterm_test_stop(data);
> +       kfree(data);
> +       file->private_data =3D NULL;
>
>         return 0;
>  }
>
>  static const struct file_operations gup_test_fops =3D {
> -       .open =3D nonseekable_open,
> +       .open =3D gup_test_open,
>         .unlocked_ioctl =3D gup_test_ioctl,
>         .compat_ioctl =3D compat_ptr_ioctl,
>         .release =3D gup_test_release,
> --
> 2.43.0
>
>
>
> Can you review+test that change? Thanks!

Sorry for the late reply.
I tested your patch and it works fine for me.
Tested-by: Yunhui Cui <cuiyunhui@bytedance.com>

>
> --
> Cheers,
>
> David

 Thanks,
 Yunhui

