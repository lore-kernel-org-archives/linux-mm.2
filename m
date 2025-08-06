Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75096C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 03:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03A2C8E000A; Tue,  5 Aug 2025 23:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011D28E0001; Tue,  5 Aug 2025 23:39:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E912B8E000A; Tue,  5 Aug 2025 23:39:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA5F78E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:39:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66AEB114F7B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:39:05 +0000 (UTC)
X-FDA: 83744926650.17.B0CE207
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 72DE8C0007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 03:39:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZC1gHqqn;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754451543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pT8gPUg++PGfeMd5QsLj4CoRRQLdIXbXj3kUkk+1RlU=;
	b=CJCqqEikEiaDxHkyssaTX4VYBdYOC7MuWs6W/HrzWiwF1pGBwbmXUeXLthpNAhFYiDPbF6
	kz9vIedcHVywh6k+axVaKqKEyLAuhuJAp+xTlYp/m6lA5536Sc4SpHIGeDl7WIAGaap25Z
	AxAK4Ep4guf7FfjkdYce/KJoXFfrEyw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZC1gHqqn;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754451543; a=rsa-sha256;
	cv=none;
	b=M7SKtri3JYET+4Snlo2ca4nljSv5BPqkOKDrxVKLOH2MLoFpx6hbG74BrRGpNoNInktD/c
	bhntmjC0mNEyrYJS4txH6pI7FBN5JksV3KxvCloMtIZKyLeUC8GEhNZDqHi0wCyRq9ErQN
	j/ADLRW4v6Odb3xxkJahzeu3JMMQA/Q=
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3322e4ac12cso42966631fa.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 20:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754451542; x=1755056342; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pT8gPUg++PGfeMd5QsLj4CoRRQLdIXbXj3kUkk+1RlU=;
        b=ZC1gHqqnmTFYixlQwY2nrwwDgNC2LmKeGKVBwKraslMqaUHkZiahwyfJB2+Uw7HVG1
         2/pDnI1fMycpTHgikJ26hTzKzQ56disK5Ol0F1UmyHI4CET58QOXYJzqKALXHqJ/do0F
         iVSgmszs2JV1X7jfWEFK4y0QDopafSYq2Q15yP284Cx+R83sSuANf2JvAIUkeUcqDVyE
         i3lMJWmJ6EUlSLyfZU+YNdGFhQ47fXuTZv65RXsYiQMlqNGm61xL/eWjhrBE28svZv1E
         ykT7spjqD8ZbsmuvT4TuERfYAgcLhwqJg0tisGtLhX6RtKRbCtZk1jGHng2+ytqcwaJI
         /drQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754451542; x=1755056342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pT8gPUg++PGfeMd5QsLj4CoRRQLdIXbXj3kUkk+1RlU=;
        b=aR1abqqeF/xCGUEKk9bEfbkNKjvSzQZbfwTRcL3tgnUjrQVyyC6rxa5udROSdkaYW8
         93rGJ2mdbIIztkcv451258c08sMyX2n2z3nkXgK6Cs+tu3t7hYsvOCw8OYIMc1SnlbK1
         19sZHbx2+KhzzA3Ap9hgxCZneF6xqF45hmHCn5Bs01DRlZCS6CpsHnfzcfVbvJb4/djV
         k+IJVzM0CszvmwRZ0s4zC9zMe+pUdYi+cI/FIsTPbq6OoBJkNTLFd4o7yESWw9L7d6uh
         P7z1XWswcZ5Zw9M5K3QKyIMBvzo75dUOU+Vstza841Ikop8WWpm5NzdMB0v968ID3vIB
         UN5w==
X-Gm-Message-State: AOJu0YxGKZ51SM8AndyD1kZcriv/4hM3KFEn9Ie/2RCEM0pwk86xvcnb
	/OJnkWVFLA7P72/CRND9kFyGAn6IsFkc3P7g2UO8THsN+i0peUA6kB9s0E5k8KroIPs7AQaFFDt
	YFQ341c1f4ZxgW/SYkEqY032lcxHoJwE=
X-Gm-Gg: ASbGncso9LB9zkETUAPcD+68t48Jo2gj+ZB8Jwbycx6CV0Z9Wg+435e/MRGyRGSoFtI
	9I0Pm58cvOvKdGNzufS77hNNN5RDUzLOJPDe7oZa3MRtUNY8iuyGxtzSPX69q0fHilVb6okU6Op
	H5aWqK/FhARXmdofModm7/+WqZbarEvIRPHh/Mk9EoFKIs6dt1Im+lQRwi+gMHA3PlW+GVnowhP
	I5doYU=
X-Google-Smtp-Source: AGHT+IHBglAwtqm4z8yQjqRQOQCSCAmCv05JxtHTKVaBxejjFoGIwClaEp5JLlQx8mxDV/3A3dGBJkVF8V5tSxeBUcc=
X-Received: by 2002:a05:651c:e0b:b0:332:8187:f837 with SMTP id
 38308e7fff4ca-333814040f2mr2549651fa.27.1754451541451; Tue, 05 Aug 2025
 20:39:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250804172439.2331-1-ryncsn@gmail.com> <20250804172439.2331-3-ryncsn@gmail.com>
 <CAKEwX=PkJdz3Um9j4m2bPahN9NbQpn7QnOvEAxDdWUHTqSvchg@mail.gmail.com>
In-Reply-To: <CAKEwX=PkJdz3Um9j4m2bPahN9NbQpn7QnOvEAxDdWUHTqSvchg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 6 Aug 2025 11:38:25 +0800
X-Gm-Features: Ac12FXzGr6EunkglBI1a6aoXX9TZJeqjSvqs_Z6HQHT5Ue_7xnXoMTR827GcYFQ
Message-ID: <CAMgjq7CSRrjLYF=7ckieNsAhDX_Fqp0OkHxrGHB0gQG7=_RdOA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm, swap: prefer nonfull over free clusters
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: daujufmczk49eu8b3hrw7bd9tfaj4u3w
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 72DE8C0007
X-Rspam-User: 
X-HE-Tag: 1754451543-866934
X-HE-Meta: U2FsdGVkX1/ERiQRch/XzNtkl5EdWDCTeTp98dOHgYikNSXVyV6Ti6bL2G6MQgOO9Q+iOcPN4lfHksw92Zk/v9CNypwwbe15oPqIQZGsGSKfmj8NM0a+W07jkY2sPbeye3yIPBkRYXKhsSwMqUK7kbLowazuTSKMRB1+PIo5tTyhiF7zrkxJO/6f2jGBcZCOfpHUc8tapS6h9FmxhAgXNbMvQuQYq1iUqkQkpWqaVV22xtvHv/PG1tIMiFWWrPKRBFMonAV5wuEUYneW4socQ7epvHg43xLELX/1t3q+VBotNbKX72gVShkFHvJsMTzU5iwfjxUz6WOI34uAbVYxTQGi6A3J+2pkyYnVoy9hEBike/vUGJ/ORNoyq39vma+O1lmU576AlBU88sv37wpEBRaT4cHYusPT+zCm8rnPlw1T8Ga9wEmqjuXH7CMgEced5jGAQvPAqteVYUH0vbZy2lf4oyYG3/FRDvsD8BVSnzSFd/v8oS2GaOsCGLKNnq1A4JPCnZpiGJTJ6a/jDu2mqhRIlXEvSLH63F4k5934fymQibUmrhur0NoJyN2Mm143x+i+e1tj6n54WtKNz/lFW/+OCk43A6rr66vi/kCHiuGk7C2xWgKJNw5s8nSh+bVwgIz1iMUpXxdqVo25uXoTT/y96WllxRhBu5jyy+XWpo6cFr+BEocPWV6s7TMTNbQ1Bd6j1aacD8y8EUeZ6vGxNTD0ktjUVnnunREG7qj0MVRDX8rQufgema8jaR6zwThghLUtC0IDLl3JNw7DQwqn+0fUaeNxZrxnPPNvTQr8P3JMp2cdGghogPeopb9I+vktUwZVRirBVwSmRWZSGXu1UR7Q3Yea6bzvIpPlQcUeNTbyOxDhwPhjT787DUQkNT8DB8e3bElW6eGnyj8RNtovExTUeJ1F44IhEcU9aRIhF+Lk42VBS0a59PwMM0HykTqOTBPkckVAvF53ZR/m3Pc
 cWlJ2Vfh
 CVNNci0FDU/zUY1UzQ1O7FcBWfVAo3UwW9LMnw4AIg3HjYPSNSraFa55FBRxuaoTFssxMVOr+r6DBgchwRb+z0QtBSc6lgvogAcdCFgvJrixzUDz2hp1+nA5xNOLUKR1xPaTw7hzVKyIiVwKw34Cb7PUIxUxCPwuT8vOrJ/ptcOguts0Xj/u5kBf5qTE32tkVn37t6Xv0W6Jd5CsoqPbOG2h62JtT/kB/on1O0z7XPJ8K2aQipVKxY1zb9Ja9Co+XdZNHjMPWVGliFW784ywSDdtRcOfrh4Tv5x4ppugpP9Gt4ibhzv3BpYG8qTtS+Vy4q6DFABb/H/wENbTchJMAoIASp60IwXS8kCbUpLdD/oSSbMJ8MqggnVyn9wkFVHrvzLCQGUOYpRYoPOwuh4O19lB6o6Qcw4/eabD/2p0kxuZaqOcXf6xzo+g//lypUKVa4p5Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 8:06=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Mon, Aug 4, 2025 at 10:24=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > We prefer a free cluster over a nonfull cluster whenever a CPU local
> > cluster is drained to respect the SSD discard behavior [1]. It's not
> > a best practice for non-discarding devices. And this is causing a
> > chigher fragmentation rate.
> >
> > So for a non-discarding device, prefer nonfull over free clusters. This
> > reduces the fragmentation issue by a lot.
> >
> > Testing with make -j96, defconfig, using 64k mTHP, 8G ZRAM:
> >
> > Before: sys time: 6121.0s  64kB/swpout: 1638155  64kB/swpout_fallback: =
189562
> > After:  sys time: 6145.3s  64kB/swpout: 1761110  64kB/swpout_fallback: =
66071
> >
> > Testing with make -j96, defconfig, using 64k mTHP, 10G ZRAM:
> >
> > Before: sys time 5527.9s  64kB/swpout: 1789358  64kB/swpout_fallback: 1=
7813
> > After:  sys time 5538.3s  64kB/swpout: 1813133  64kB/swpout_fallback: 0
> >
> > Performance is basically unchanged, and the large allocation failure ra=
te
> > is lower. Enabling all mTHP sizes showed a more significant result:
> >
> > Using the same test setup with 10G ZRAM and enabling all mTHP sizes:
> >
> > 128kB swap failure rate:
> > Before: swpout:449548 swpout_fallback:55894
> > After:  swpout:497519 swpout_fallback:3204
> >
> > 256kB swap failure rate:
> > Before: swpout:63938  swpout_fallback:2154
> > After:  swpout:65698  swpout_fallback:324
> >
> > 512kB swap failure rate:
> > Before: swpout:11971  swpout_fallback:2218
> > After:  swpout:14606  swpout_fallback:4
> >
> > 2M swap failure rate:
> > Before: swpout:12     swpout_fallback:1578
> > After:  swpout:1253   swpout_fallback:15
> >
> > The success rate of large allocations is much higher.
> >
> > Link: https://lore.kernel.org/linux-mm/87v8242vng.fsf@yhuang6-desk2.ccr=
.corp.intel.com/ [1]
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Nice! I agree with Chris' analysis too. It's less of a problem for
> vswap (because there's no physical/SSD implication over there), but
> this patch makes sense in the context of swapfile allocator.
>
> FWIW:
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>

Thanks!

>
> > ---
> >  mm/swapfile.c | 38 ++++++++++++++++++++++++++++----------
> >  1 file changed, 28 insertions(+), 10 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 5fdb3cb2b8b7..4a0cf4fb348d 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -908,18 +908,20 @@ static unsigned long cluster_alloc_swap_entry(str=
uct swap_info_struct *si, int o
> >         }
> >
> >  new_cluster:
> > -       ci =3D isolate_lock_cluster(si, &si->free_clusters);
> > -       if (ci) {
> > -               found =3D alloc_swap_scan_cluster(si, ci, cluster_offse=
t(si, ci),
> > -                                               order, usage);
> > -               if (found)
> > -                       goto done;
> > +       /*
> > +        * If the device need discard, prefer new cluster over nonfull
> > +        * to spread out the writes.
> > +        */
> > +       if (si->flags & SWP_PAGE_DISCARD) {
> > +               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> > +               if (ci) {
> > +                       found =3D alloc_swap_scan_cluster(si, ci, clust=
er_offset(si, ci),
> > +                                                       order, usage);
> > +                       if (found)
> > +                               goto done;
> > +               }
> >         }
> >
> > -       /* Try reclaim from full clusters if free clusters list is drai=
ned */
> > -       if (vm_swap_full())
> > -               swap_reclaim_full_clusters(si, false);
> > -
> >         if (order < PMD_ORDER) {
> >                 while ((ci =3D isolate_lock_cluster(si, &si->nonfull_cl=
usters[order]))) {
> >                         found =3D alloc_swap_scan_cluster(si, ci, clust=
er_offset(si, ci),
> > @@ -927,7 +929,23 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si, int o
> >                         if (found)
> >                                 goto done;
> >                 }
> > +       }
> >
> > +       if (!(si->flags & SWP_PAGE_DISCARD)) {
> > +               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> > +               if (ci) {
> > +                       found =3D alloc_swap_scan_cluster(si, ci, clust=
er_offset(si, ci),
> > +                                                       order, usage);
> > +                       if (found)
> > +                               goto done;
> > +               }
> > +       }
>
> Seems like this pattern is repeated a couple of places -
> isolate_lock_cluster from one of the lists, and if successful, then
> try to allocate (alloc_swap_scan_cluster) from it.

Indeed, I've been thinking about it but there are some other issues
that need to be cleaned up before this one.

