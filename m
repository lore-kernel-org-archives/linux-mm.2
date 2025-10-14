Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F41EECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A14D8E00DE; Tue, 14 Oct 2025 08:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5520C8E000D; Tue, 14 Oct 2025 08:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4411E8E00DE; Tue, 14 Oct 2025 08:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6118E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:44:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C88461608EB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:44:26 +0000 (UTC)
X-FDA: 83996688132.05.616745C
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id BA2AA100009
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:44:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BFER++VJ;
	spf=pass (imf14.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760445864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9oo6cb/h2//KSAhz8PhrLQfUB6XAbYAkngZFzEqMMVw=;
	b=wDXBUf3pxFUlmyi3CjhNPOH3WoQXOkmctG9kFBxw+NQF9nTbac+PEDERKwSDrxETGNu/Ql
	UTLOuFoOLphfkQ3tHklgjZ6eZTmFL5j21id+oqnu8/vD0sPqoySE52n57w0g0niOyU2bSj
	G9EKTvIdf1XlVrihr8XB7LurIM54sKo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BFER++VJ;
	spf=pass (imf14.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760445864; a=rsa-sha256;
	cv=none;
	b=0pPD5r59XaWqixIc/zBKzBTujD1CBa44SpBc+yvRgHoaP2Mn0ZUnCeWYf2tiA3A9D+QdTr
	n+SXdLvUZv/vPjNpYjOR1VcQJYmMQXS/0CQTfaXtL9nz3G1JlogNIZBT/Bd2YJxMn1B5nv
	zQ/yt+vz+dmvzBfA8cW/9HN2fVJE+HI=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-58120c35d47so994623e87.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760445862; x=1761050662; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9oo6cb/h2//KSAhz8PhrLQfUB6XAbYAkngZFzEqMMVw=;
        b=BFER++VJ7z8TbaerpSsjQarmpUCpUE7RkRrF0gbgVg9bGIb+QmhIHMTQnsCbyKTSIo
         zzxguIKItjhOrDz3vbekwmZv6AFQAAFmxEN/8BsVp8WBI+JrJJeX+ZjHXq+eTSSG9R8S
         Tk3j/LrcxUkUe90hHdlmY8Ns6FYIrkqY7BTB7yxnMv5WL2RuZHfvBT/KBdo7BcyyckOe
         1gTIzD+HeZ920jd2YCUO4ZFTv+x8T66DYdLvCZ3rFCjmLNrjY+m9mwKRPamLnroJKAPW
         Ua3CqDJKCOzekKH5ZFdnLgM879ADUg+z8WCwNqwI4h1e+SEjNA6Av9s1HJT5MZzRCvDM
         uA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760445862; x=1761050662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9oo6cb/h2//KSAhz8PhrLQfUB6XAbYAkngZFzEqMMVw=;
        b=AQFWPgebHUfpjm4byW+SYgzwYTGaUGu7byDy/9rzG5P5nuhu0T1UuhjKZWRcbf4Pvl
         RX7J2aPK5MSaXycJNBmxFPuSvkRorGmloN6U9w1oX73Ulh16do7KADhDYFlXaYjtqRdX
         u10RvGGRe31IuBEQ9df3FrxuqvOlu+pUYq3+LKCvGBBfCyqzdcgp9RH2Q0gXN1Mr366h
         6qY+3eKKhtOP0h/f8Z7sRfQ1acsHPXHMhtoy3ZbfkLgl6qkrJRSNm/zkj4q/vkEnV9+i
         NKK2utn1m4bIQzObx33rbQwugykHZhNhsMZznaK0m+o5uayxpiCKcGJZV3DWX1/chbpz
         HV1w==
X-Forwarded-Encrypted: i=1; AJvYcCUswSq//eDRu1oxTh+zv3tTt/lKmTYn4vjr2bems+/toLduegdMbcV60B9OYVBSZ4VYy7+QQuXeUQ==@kvack.org
X-Gm-Message-State: AOJu0YyjFSZDE5kfR7xvesFCRdRgxB9O5M+rlxCcH6WDYbvGkc8OrbRf
	cQq2FIlQozJ7AO4bfMKCqB7ReHZ4AqczR4BSNEXqB7OvYgdcL68BlZruiX+cKJgVdaWpfU+NBdu
	13HE1tQtpbiJek595q16kvrYKQptrALs=
X-Gm-Gg: ASbGncsksc+V0xa18uRMIuH0f3ifGkL06I6pJ8u3wJM3n/MBv4lMMG8z3133oJD3dao
	wYOcQgO/iDAbd+IuWPF7ZrRMZGEaBf+TJpd9jwwsAYj7/ElVPUMkWtSVrgNV+E0jgGguGvtOzAe
	eewwefhl1oCDG/4HQEMl/1lNt6GBLEJ9ag9fM02fuaXt1bozwWCc/N8nq1lJGpMwz/pEfOCQL2k
	6tHVFeBaqP4GgOO+5Fq1vmjfWOwrkjI060mwbCZ0FAQCHP7
X-Google-Smtp-Source: AGHT+IE6ZX1VGaVslNv8ZPr/UKniSljm0zQJqyI+Plq3kYLvNFNlsMtuo7K/t2++yV4p4PZdglaVsxwNfABC8vF2f6w=
X-Received: by 2002:a2e:beab:0:b0:36b:d9d2:7352 with SMTP id
 38308e7fff4ca-37609cebacdmr36927351fa.1.1760445862122; Tue, 14 Oct 2025
 05:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
 <20251014083230.1181072-3-zhaoyang.huang@unisoc.com> <87953097-a105-4775-88a5-9b3a676ff139@amd.com>
In-Reply-To: <87953097-a105-4775-88a5-9b3a676ff139@amd.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Tue, 14 Oct 2025 20:44:10 +0800
X-Gm-Features: AS18NWC91XO6vcqGgvJynO5q8vzT5cvKYOwtu3JK2ou4LVmpJ0_YPTlGMwJ6WAA
Message-ID: <CAGWkznGN7W-txq_G+xpZ6DtH_1DNorYc=CxqUjebo7qfB4Sxsw@mail.gmail.com>
Subject: Re: [PATCH 2/2] driver: dma-buf: use alloc_pages_bulk_list for
 order-0 allocation
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BA2AA100009
X-Stat-Signature: w6mzwiz5c8pa5zd3eff9mw4efuuckdrn
X-Rspam-User: 
X-HE-Tag: 1760445864-913384
X-HE-Meta: U2FsdGVkX1/FWE4f8PcEvQw+FMRmcr09P43Fy07MheUGLlXl2F8igGBNFSzHRjTnh+srC/sj+5N5/nOZ1UVJPkiUpsPZ1dOzykT7TZSYwQrzvcwXuW0p3DzBr20+pAWBXgnkFjgThMxIz7xOxURAMQMCuAM2SO2iMBIcGDo6Qxw4XghASN65ZbcLz5K+0U294ZGJVtsMbyih+tgWoRzswdMV1GnqtKk3qM9WJLAdkQ/qYc0dN51swJk5JTx5Vtb6QdXpqTXfhkQMoHD2pKQvQNc4WHV53IXPCTpZrqmn6IetitzxzL+Snx9leCpqvu8kcIc2DOoKAJJNQXC0B86F/wjgFfVxTQO0wvAa4kfZGBzwvNoLr1zQ3SkzkQ/cbP3m0YVg4P19OiIVM4wGAwG1WPUQFYK4fBr55lThlEk6mWdfFhh3w628PT0SygZd2N6+ZHh2DNpwzYQYHwfGBDYvPWdXuBLLnjFzo48HIsUpX5x8jydedwYacsJ6+vnjqN5TRnPDx8msU36c2Lzo0/lErldBvUgDqn++djnyGbOql8Q+S5XBLWCx014+5L3+IMy/ImV+7PFfYbQQTRnaApM4+94J4des5SGOUZ7opGS8ura7sUfNpwgi2Y9OBymgps7Y2o02+DJhWDmztXnxJtWJNZOlTsu7klgtFEByfndNp9HtFbqYj8pKrfdaH6DJzi1Bo6L/8egSyKM+vJoMaERWS3gb8aT66VLq/ozIM3Y4BBUfe5Ib6la1esZ5figQdeGOwtCC+dgbxCVkAYxoufRr2XlVakySWPHnlJE75NTvZw8jSwpjsndRWKeLYlaX/G89I3hAqHJPnCTyemDTvng6pGeP9DfiBYNqhR8cNHgQyLpWkP1F54JY87+lvgj4gb6yd/WxB2PkFRhUftaLTesnz/Y0nLT1flzPtMLtV/3qCK2hj/zqOd4NzDeOrlCI+2YctTvSnC+Q885A+O00c9r
 yaEw0qvO
 +/4w+Z0+TLvVseS8u+Qx1P8tHgmRIdh7VBOz6JB5kcBPQPS3wlvLxM5ej3YTaQT356p+ClUryrrSLRVsun3wc0szYFs4Of4geABewL02zdZyqG/QbbkMZV+HyNlNIDMrT9IjtPM2fhRbKJeS8joCzHD6fc+d6aPAhJyonHm9B5nI+mp1Crb0MSMm1Y9AfzGYuZdqD4hRo64eSMBodGTJXc7IgiMuCUcD746lV1bUT27XJ4Bl68rs/1AD+81ufyLp/TfiO6B2s5duq9dSLQa7+DWPXCAnqNHWMs5xc+VEF7zVisN3LfNUXFnsJwdBkq5z911942XjkL2icq4AlEnh32CAwDIQO2m1xh5pMv6ZegG/8+6+5OulskOkZDretUDjqE+iobm1D9Aghs4SjQqWCTPUNagWrwcLCw/1YayyI80+RkcCZL+SDfNz9WWi5NT2KhtdUoB+XvbLlDEBcPFZ2dDehoJT4b0ScXlikayU99hMYdvo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 7:59=E2=80=AFPM Christian K=C3=B6nig
<christian.koenig@amd.com> wrote:
>
> On 14.10.25 10:32, zhaoyang.huang wrote:
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > The size of once dma-buf allocation could be dozens MB or much more
> > which introduce a loop of allocating several thousands of order-0 pages=
.
> > Furthermore, the concurrent allocation could have dma-buf allocation en=
ter
> > direct-reclaim during the loop. This commit would like to eliminate the
> > above two affections by introducing alloc_pages_bulk_list in dma-buf's
> > order-0 allocation. This patch is proved to be conditionally helpful
> > in 18MB allocation as decreasing the time from 24604us to 6555us and no
> > harm when bulk allocation can't be done(fallback to single page
> > allocation)
>
> Well that sounds like an absolutely horrible idea.
>
> See the handling of allocating only from specific order is *exactly* ther=
e to avoid the behavior of bulk allocation.
>
> What you seem to do with this patch here is to add on top of the behavior=
 to avoid allocating large chunks from the buddy the behavior to allocate l=
arge chunks from the buddy because that is faster.
emm, this patch doesn't change order-8 and order-4's allocation
behaviour but just to replace the loop of order-0 allocations into
once bulk allocation in the fallback way. What is your concern about
this?
>
> So this change here doesn't looks like it will fly very high. Please expl=
ain what you're actually trying to do, just optimize allocation time?
>
> Regards,
> Christian.
>
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > ---
> >  drivers/dma-buf/heaps/system_heap.c | 36 +++++++++++++++++++----------
> >  1 file changed, 24 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heap=
s/system_heap.c
> > index bbe7881f1360..71b028c63bd8 100644
> > --- a/drivers/dma-buf/heaps/system_heap.c
> > +++ b/drivers/dma-buf/heaps/system_heap.c
> > @@ -300,8 +300,8 @@ static const struct dma_buf_ops system_heap_buf_ops=
 =3D {
> >       .release =3D system_heap_dma_buf_release,
> >  };
> >
> > -static struct page *alloc_largest_available(unsigned long size,
> > -                                         unsigned int max_order)
> > +static void alloc_largest_available(unsigned long size,
> > +                 unsigned int max_order, unsigned int *num_pages, stru=
ct list_head *list)
> >  {
> >       struct page *page;
> >       int i;
> > @@ -312,12 +312,19 @@ static struct page *alloc_largest_available(unsig=
ned long size,
> >               if (max_order < orders[i])
> >                       continue;
> >
> > -             page =3D alloc_pages(order_flags[i], orders[i]);
> > -             if (!page)
> > +             if (orders[i]) {
> > +                     page =3D alloc_pages(order_flags[i], orders[i]);
> > +                     if (page) {
> > +                             list_add(&page->lru, list);
> > +                             *num_pages =3D 1;
> > +                     }
> > +             } else
> > +                     *num_pages =3D alloc_pages_bulk_list(LOW_ORDER_GF=
P, size / PAGE_SIZE, list);
> > +
> > +             if (list_empty(list))
> >                       continue;
> > -             return page;
> > +             return;
> >       }
> > -     return NULL;
> >  }
> >
> >  static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
> > @@ -335,6 +342,8 @@ static struct dma_buf *system_heap_allocate(struct =
dma_heap *heap,
> >       struct list_head pages;
> >       struct page *page, *tmp_page;
> >       int i, ret =3D -ENOMEM;
> > +     unsigned int num_pages;
> > +     LIST_HEAD(head);
> >
> >       buffer =3D kzalloc(sizeof(*buffer), GFP_KERNEL);
> >       if (!buffer)
> > @@ -348,6 +357,8 @@ static struct dma_buf *system_heap_allocate(struct =
dma_heap *heap,
> >       INIT_LIST_HEAD(&pages);
> >       i =3D 0;
> >       while (size_remaining > 0) {
> > +             num_pages =3D 0;
> > +             INIT_LIST_HEAD(&head);
> >               /*
> >                * Avoid trying to allocate memory if the process
> >                * has been killed by SIGKILL
> > @@ -357,14 +368,15 @@ static struct dma_buf *system_heap_allocate(struc=
t dma_heap *heap,
> >                       goto free_buffer;
> >               }
> >
> > -             page =3D alloc_largest_available(size_remaining, max_orde=
r);
> > -             if (!page)
> > +             alloc_largest_available(size_remaining, max_order, &num_p=
ages, &head);
> > +             if (!num_pages)
> >                       goto free_buffer;
> >
> > -             list_add_tail(&page->lru, &pages);
> > -             size_remaining -=3D page_size(page);
> > -             max_order =3D compound_order(page);
> > -             i++;
> > +             list_splice_tail(&head, &pages);
> > +             max_order =3D folio_order(lru_to_folio(&head));
> > +             size_remaining -=3D PAGE_SIZE * (num_pages << max_order);
> > +             i +=3D num_pages;
> > +
> >       }
> >
> >       table =3D &buffer->sg_table;
>

