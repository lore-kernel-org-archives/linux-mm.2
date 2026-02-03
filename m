Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6933DE8B383
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 23:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DC6F6B0088; Tue,  3 Feb 2026 18:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389E26B0089; Tue,  3 Feb 2026 18:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F246B008A; Tue,  3 Feb 2026 18:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0416B0088
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:14:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6371616064E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 23:14:22 +0000 (UTC)
X-FDA: 84404701164.23.AFFEF74
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 456CC80005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 23:14:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nQhOzPI1;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770160460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiR7TNZK1P4HTBCKAjANaMz2t8iMyhxXY6Q1DBG3It4=;
	b=GUJPVZcxDBQbArve+Qs1mnkPKNCtR43CMk8cUpvCqHthFbR2hcRFZnTSs0oqua4ywEOfri
	IBp4fZJjQYIVwgAkNCdYAn7ak2AUJGccp3D7gQ364Dc5QV2oo7gETq5x1iSCdx3eNtubw7
	jeKVXvDM8/t8ZN42Y16crNgSAcbuomY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nQhOzPI1;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770160460; a=rsa-sha256;
	cv=pass;
	b=jv09Q+Oc4Uvp9yaBnvl4IPuBr3WNC7BjW+vQ0j/IsuiA1zpnEktpYXkmEc8HIG7VxBS6uZ
	QbZXS74M13kTSGge3PpfLc8Z03JwzzKlAv1kCP3WqBFd6vZ8Btj3ySTGo12WEPEo59jdwE
	ZlJrHT927Mj0q4zdPDWNTpLvvbF7f2A=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4327790c4e9so3900657f8f.2
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 15:14:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770160459; cv=none;
        d=google.com; s=arc-20240605;
        b=dvupLOOQvv/Wtn9x+ihkz1cm2rYyYEaQm/YOR4g4FLveoXwQhIrrgO/2oT7/+2r4+e
         6J3L4dfqPkswzSQ7k9G5BQnOGFbx0CsnYuEcIpiIUPyfTvIn5KLs1zUafryJ5RoBSgXu
         FNBxkgYHHetDt8WBwk+zkDCPDdaS02+yR3MMDH4SPLhbxQ2u1uVqCrgVMe6mmGS9fx3F
         4r8EPxVlGuXxD4rzXy6Cc/OIBu6R3EWCpi7reGmBDZqm8+UckZAl8ChE5jWZeUU8KSHo
         Ri2og2rvS2ds8QifihictJIQqAvPjGlM+xHheyd6JLud+9MrB4LV9Lx1CaTXQZ6iHixE
         hWNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UiR7TNZK1P4HTBCKAjANaMz2t8iMyhxXY6Q1DBG3It4=;
        fh=SztZuuDvs3iK5HjqsP9g4ZICP3BRqZEuVy87nt0moPc=;
        b=LtpHIuOoJQyYiwNQ+6+oTMrIVfSG9mh+PiWBZZ5/6xXBIv4HAtubiS9xt5u8NEpGlE
         EK8KBtjBXSIX+JPU/qHvGkZGNioYyMxmceZmIbJInC1oMVy+quHKrqnluYJFgHECzmCf
         RqlKdAauYhLPHm8G9ZfN4UJYL+msFBuNMF55nSwYC4N/AJTadQE0ap7+ibs6RmAD3Ds+
         1cwNwztAAdaZ2fHAh5lUkzabjCkG+RtEJV1qMRqmwgaCEGKf5qV2IUGt9PbSirzwi1ae
         KQg3AgHUB0vJtapMt66p99TDyr6jsaPMMEZnfDFfDoZ6Bjy9lk7WSmdTYpKPKPeAVS0d
         +nrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770160459; x=1770765259; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UiR7TNZK1P4HTBCKAjANaMz2t8iMyhxXY6Q1DBG3It4=;
        b=nQhOzPI1VPCRLBldNa9LA9e0qY8ckaYGMgbhyxAZ5kjhp1EvFqBUl00GLf3Rx+mxfz
         UJ3FT+7h3mmXIhvUjVX5S5/IYRJxARIRQomwo/2KPrpmNxWkhz++Utc6CuZdihNVNQ+R
         fYvcwcJP0c+n3BMs0oSy8jZ5PIffTGQusa8euAs3Q3k2iweygF8I7BQUEdvA3vEJU+Ii
         u93Q/e0MiXTWthXcRw/lggbjH77sQBAfbyNVO/h+5r0DI5LTSHhWgdW4GfcK43DBWGYg
         wMK/kBnmQTlUl8zRQT/jWfO+EN/Qpt/w8/q7YS5uMrYSSb2XAWkmmZ1PJF7QnZy/enm7
         0eGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770160459; x=1770765259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UiR7TNZK1P4HTBCKAjANaMz2t8iMyhxXY6Q1DBG3It4=;
        b=Bo2GhtKO8NM27QVUARZ2XjZjq8pBbhzfNFjH1XMYJLreW5+1fJ5nOlpDz4yf/7nTEn
         2MnPSS4vEP6jLY/nT++ipHy3cu56hV+Rh7Ode4yvxiMlWjIFpdvzwcYQZ3TB+7S+qIvw
         Vg6v4lJ12TTfV2a4T8jaFLz7xEe+FzarPDFS9WbvW3rX899jXGdSKn+A0IGkQW0rQbyD
         jsPEqHuJJgQCu3YO5wtDybQtPMVjDbpQW2We0rLESSwB6DY4B6iXop4A1e0x9wOKfRXT
         twp2y2W0j640Z5Oc/YiOPJGIRf6k3rG6V1qfuVfr1X8hELDhgTeMJ8jAz1PtUvMnFe1y
         4FnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaLsQI8m7hUB9ZAKzQbO+0iQI4WF0pe9gcUGzJMwYLbFYTC8yq6jVLc3M0uBmkMYWV+eVnvrqJ/Q==@kvack.org
X-Gm-Message-State: AOJu0YzAWaqf44iPlAPbPNyeVISW7LUYf62i+mBiEOWhwssDbF9bi1le
	aLTVsb3J7xyn/NCVc6O0I3IEWoiIZtDSq4ItTb/m00ENi/zjkmBoAmdNeZ1AT0ShGEL1YafHaH+
	E7ZYepIfhNL08YJXowig1ZbuDo1ID2tQ=
X-Gm-Gg: AZuq6aLYL1hZXa8sRdh9RrNXcZNXR3zMllL23N6s/4FjAtgbVOXTm/PfFYm4Y35lmo9
	D6UlKcOAPFNWIrXo9xgfN0T42O9PJOSfWX5NOCsAX2mASK2ubcSQlJ6IHYgjUPl3sUxDQizJY8L
	CLZFVnnSk0Pg1rEi5XEl0273M4YP+L+TbrRwQcSjfAo1z2V54USbdG0QB9hnXIz7vZ6al3QSquk
	L971WOfmPcMikyc/5iWENXUE+Zp1w5ZFSNiu5mWYdywXnj/be9PGBxjB0O2ysf8WdFZpyuTtycq
	YI5ADcTMnZZXwT5gg9U6WI0uSV+2ehYTUuxGbVdxfu8=
X-Received: by 2002:a05:6000:2207:b0:435:8f88:7226 with SMTP id
 ffacd0b85a97d-436180528fdmr1279419f8f.40.1770160458379; Tue, 03 Feb 2026
 15:14:18 -0800 (PST)
MIME-Version: 1.0
References: <20260113034645.2729998-1-senozhatsky@chromium.org> <wb2shm35vigisxnokcp3pw3yzu32kezo3ox2v3xu2u5lnxo45n@ktccxxzg2vsc>
In-Reply-To: <wb2shm35vigisxnokcp3pw3yzu32kezo3ox2v3xu2u5lnxo45n@ktccxxzg2vsc>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 3 Feb 2026 15:14:06 -0800
X-Gm-Features: AZwV_QinXQsM5zVNHfO-e3aAKsCOExB_61tE37X5sLCoExIgt96ev14_6SOisL0
Message-ID: <CAKEwX=MRz7dL5=cP=4QN6uTgUJLh-xCt_zpfxytqZkYdycUN5w@mail.gmail.com>
Subject: Re: [PATCH] zsmalloc: introduce SG-list based object read API
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j3oae7u9g3bp8opmazgyexy5bkkuicxm
X-Rspamd-Queue-Id: 456CC80005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770160460-188971
X-HE-Meta: U2FsdGVkX18yx6T1m9Wa2Lr3hALovowEkEjGP02LB32yQ/r87SG15ovHn6/3f4PQGOolR8R3Jyo1TZ8xdtZJv8p3VoQMf+BnJF1bhBRdbkyVOBPtSouaUIdPqXWpGQfDMxjKd1sIJxWbS7E4tEb/a8dBXOIiTP3tqkUlt//g3+FV0Bmi7Q15X3bXe5Ce4+yk3TutXNuM8RYsqOpO1siECVYZMrPdhXNiAJCT3aznNZDOoDXrInvpql1Gc+cfRGsj3DsaSd41Cvp54LkrBbURLE7iBqp4CnHjnHNRHtHsz3OSjDf7NU2LbuTwTmTmdadv3sMs89nTmAP+x1NoN+OElzpAh9UM75h06MzUXfDz3QTxKCcNEXUmkAj9EA20eLJRlbPbGzwAEwyyyNWRBZJsnwlxkTHMCYtIkUp+5rRxEI6MJhjw09qg9RhPCwcRdT2YO3WFfhpir/QdppWrd5yy2fUCvUKWmbwSMBA+/qPqTc1NwHDPWNn7Ta8+yv7uisyYYMngBR730MwHkhpfHaR8u/A0s6CjvT6EXfMtidExAZjci5vikOlpX5dM7SwxxIKbozr3e8BwBVuEqLKazAtXmUQt1LUn0hIsdKOnvTWd1bVOmyRW/IlyUv7IIHawC1Wi87m2hFoZsbO06JUOthTTDp42SaOTDNtgMQOdPihkObj90VRlDfwm972Xg+kY3GPMkIVrNryxg9EK9/lga2NUUz4Dw6PvVLpqxT+csaZa7im0xAJR8jvPBYn+4gOzM92gknyZ/mYO6gULvsBrrPd2QAymgHCwFKeLTeSZ9YVbxJzfu9wOQUtAbgUlfjU6rmAPo+5Y2ePFJNFopZgH1shCh8P2RsaeVo2ERvq2GxDziHxfJWt8VXvQvokNRuD23H4Ng4eh6pvzEZHHaSVNaU8g6IsuZU3NbxMg+XOBHJtIXfOcNZgTa3aLMWMNuBDV2+2sbXdWk4X+VpMppOy7JYu
 iCnuXXhR
 we0PUnHEMBW18y5BvtVVpwaNY2nkNia0QuZQ8uH/8reFk/Ad9GQve5lW6yaQPNPvTgSm0O8TUm50kWrWUSAty4uGORs+01er8SS7uqCUX01fbcrO+kwYaKx/4x6lxwSbSsf9iOiJZh0s4Lqp5Tcq4KYmaE/9Six8iYLKwqo6r3aZX/mLFoLgjB6//9DTIyEXq7R08OXIjvl3jaOikjAnoAdJEMww5Se2qz1usthOS83dzSRueZM458rtZPdXWZ+psU2gFTKqeTWs7FoebxkcHW73rottLao61oiFJxcOx6bBEiSbNfF+4bcBnstV/5xYZ6TfllsdP3dnp7IvMVRjXcpZGMshYgwI+AWonAftGz+lV36/9MJTKheEjBgIACi3+lJpNnvL/jq7erS92/KhmsDq0qVRxylbPsIyI5LTqujDmS/HNNXl/e9f0lImGgBVyNja1ekQbSE8oL600FgFSDiIInA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 11:53=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev=
> wrote:
>
> On Tue, Jan 13, 2026 at 12:46:45PM +0900, Sergey Senozhatsky wrote:
> > Currently, zsmalloc performs address linearization on read
> > (which sometimes requires memcpy() to a local buffer).
> > Not all zsmalloc users need a linear address. For example,
> > Crypto API supports SG-list, performing linearization under
> > the hood, if needed. In addition, some compressors can have
> > native SG-list support, completely avoiding the linearization
> > step.
> >
> > Provide an SG-list based zsmalloc read API:
> > - zs_obj_read_sg_begin()
> > - zs_obj_read_sg_end()
> >
> > This API allows callers to obtain an SG representation
> > of the object (one entry for objects that are contained
> > in a single page and two entries for spanning objects),
> > avoiding the need for a bounce buffer and memcpy.
> >
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > ---
>
> I tested this with the zswap patch at the bottom, let me know if you
> want me to send separately on top, or you can include it in the next
> revision.  Either way, feel free to add:
>
> Tested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
>
> >  include/linux/zsmalloc.h |  4 +++
> >  mm/zsmalloc.c            | 65 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 69 insertions(+)
> >
> > diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> > index 5565c3171007..11e614663dd3 100644
> > --- a/include/linux/zsmalloc.h
> > +++ b/include/linux/zsmalloc.h
> > @@ -22,6 +22,7 @@ struct zs_pool_stats {
> >  };
> >
> >  struct zs_pool;
> > +struct scatterlist;
> >
> >  struct zs_pool *zs_create_pool(const char *name);
> >  void zs_destroy_pool(struct zs_pool *pool);
> > @@ -43,6 +44,9 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigne=
d long handle,
> >                       size_t mem_len, void *local_copy);
> >  void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
> >                    size_t mem_len, void *handle_mem);
> > +int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
>
> void? The return value is always 0.
>
> > +                struct scatterlist *sg, size_t mem_len);
> > +void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
> >  void zs_obj_write(struct zs_pool *pool, unsigned long handle,
> >                 void *handle_mem, size_t mem_len);
> >
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index 16d5587a052a..5abb8bc0956a 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -30,6 +30,7 @@
> >  #include <linux/highmem.h>
> >  #include <linux/string.h>
> >  #include <linux/slab.h>
> > +#include <linux/scatterlist.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/sprintf.h>
> >  #include <linux/shrinker.h>
> > @@ -1146,6 +1147,70 @@ void zs_obj_read_end(struct zs_pool *pool, unsig=
ned long handle,
> >  }
> >  EXPORT_SYMBOL_GPL(zs_obj_read_end);
> >
> > +int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
> > +                      struct scatterlist *sg, size_t mem_len)
> > +{
> > +     struct zspage *zspage;
> > +     struct zpdesc *zpdesc;
> > +     unsigned long obj, off;
> > +     unsigned int obj_idx;
> > +     struct size_class *class;
> > +
> > +     /* Guarantee we can get zspage from handle safely */
> > +     read_lock(&pool->lock);
> > +     obj =3D handle_to_obj(handle);
> > +     obj_to_location(obj, &zpdesc, &obj_idx);
> > +     zspage =3D get_zspage(zpdesc);
> > +
> > +     /* Make sure migration doesn't move any pages in this zspage */
> > +     zspage_read_lock(zspage);
> > +     read_unlock(&pool->lock);
> > +
> > +     class =3D zspage_class(pool, zspage);
> > +     off =3D offset_in_page(class->size * obj_idx);
>
> There is a lot of duplication between this and zs_obj_read_begin(). I
> wanted to create a common helper for them both that returns the zpdesc
> and offset, but we cannot do the same on the read end side as the unlock
> needs to happen after kunmap() in zs_obj_read_end().
>
> Putting parts of this code in helpers makes it a bit obscure due to the
> locking rules :/
>
> I wonder if we can drop zs_obj_read_*() and move the spanning logic into
> zram. Looking at zram code, seems like read_from_zspool_raw() and
> read_incompressible_page() just copy the return address, so I think they
> can trivially move to using the SG list helpers and
> memcpy_from_sglist().
>
> The only non-trivial caller is read_compressed_page(), because it passes
> the compressed object to zcomp. So I think we only need to handle the
> linearization there, something like this (completely untested):
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 61d3e2c74901..6872819184d9 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -2073,6 +2073,7 @@ static int read_incompressible_page(struct zram *zr=
am, struct page *page,
>
>  static int read_compressed_page(struct zram *zram, struct page *page, u3=
2 index)
>  {
> +       struct scatterlist src_sg[2];
>         struct zcomp_strm *zstrm;
>         unsigned long handle;
>         unsigned int size;
> @@ -2084,12 +2085,23 @@ static int read_compressed_page(struct zram *zram=
, struct page *page, u32 index)
>         prio =3D get_slot_comp_priority(zram, index);
>
>         zstrm =3D zcomp_stream_get(zram->comps[prio]);
> -       src =3D zs_obj_read_begin(zram->mem_pool, handle, size,
> -                               zstrm->local_copy);
> +       zs_obj_read_sg_begin(zram->mem_pool, handle, src_sg, size);
> +
> +       if (sg_nents(src_sg) =3D=3D 1) {
> +               src =3D kmap_local_page(sg_page(src_sg)) + src_sg->offset=
;
> +       } else {
> +               memcpy_from_sglist(zstrm->local_copy, src_sg, 0, size);
> +               src =3D zstrm->local_copy;
> +       }
> +
>         dst =3D kmap_local_page(page);
>         ret =3D zcomp_decompress(zram->comps[prio], zstrm, src, size, dst=
);
>         kunmap_local(dst);
> -       zs_obj_read_end(zram->mem_pool, handle, size, src);
> +
> +       if (src !=3D zstrm->local_copy)
> +               kunmap_local(src);
> +
> +       zs_obj_read_sg_end(zram->mem_pool, handle);
>         zcomp_stream_put(zstrm);
>
>         return ret;
>
> ---
>
> If this is too ugly we can even put it in helpers like
> linearize_sg_list() and delinearize_sg_list(), that take in the SG list
> and zstrm, and figure out if mapping or copying to the buffer is needed.
>
> > +
> > +     if (!ZsHugePage(zspage))
> > +             off +=3D ZS_HANDLE_SIZE;
> > +
> > +     if (off + mem_len <=3D PAGE_SIZE) {
> > +             /* this object is contained entirely within a page */
> > +             sg_init_table(sg, 1);
> > +             sg_set_page(sg, zpdesc_page(zpdesc), mem_len, off);
> > +     } else {
> > +             size_t sizes[2];
> > +
> > +             /* this object spans two pages */
> > +             sizes[0] =3D PAGE_SIZE - off;
> > +             sizes[1] =3D mem_len - sizes[0];
> > +
> > +             sg_init_table(sg, 2);
> > +             sg_set_page(sg, zpdesc_page(zpdesc), sizes[0], off);
> > +
> > +             zpdesc =3D get_next_zpdesc(zpdesc);
> > +             sg =3D sg_next(sg);
> > +
> > +             sg_set_page(sg, zpdesc_page(zpdesc), sizes[1], 0);
> > +     }
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(zs_obj_read_sg_begin);
> > +
> > +void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle)
> > +{
> > +     struct zspage *zspage;
> > +     struct zpdesc *zpdesc;
> > +     unsigned long obj;
> > +     unsigned int obj_idx;
> > +
> > +     obj =3D handle_to_obj(handle);
> > +     obj_to_location(obj, &zpdesc, &obj_idx);
> > +     zspage =3D get_zspage(zpdesc);
> > +
> > +     zspage_read_unlock(zspage);
> > +}
> > +EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
> > +
> >  void zs_obj_write(struct zs_pool *pool, unsigned long handle,
> >                 void *handle_mem, size_t mem_len)
> >  {
> > --
> > 2.52.0.457.g6b5491de43-goog
> >
>
> Zswap patch:
>
> From 8b7c41efce7635dd14db9586c3bb96c861298772 Mon Sep 17 00:00:00 2001
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Date: Fri, 16 Jan 2026 19:20:02 +0000
> Subject: [PATCH] mm: zswap: Use SG list decompression APIs from zsmalloc
>
> Use the new zs_obj_read_sg_*() APIs in zswap_decompress(), instead of
> zs_obj_read_*() APIs returning a linear address. The SG list is passed
> directly to the crypto API, simplifying the logic and dropping the
> workaround that copies highmem addresses to a buffer. The crypto API
> should internally linearize the SG list if needed.
>
> Zsmalloc fills an SG list up to 2 entries in size, so change the input
> SG list to fit 2 entries.
>
> Update the incompressible entries path to use memcpy_from_sglist() to
> copy the data to the folio. Opportunistically set dlen to PAGE_SIZE in
> the same code path (rather that at the top of the function) to make it
> clearer.
>
> Drop the goto in zswap_compress() as the code now is not simple enough
> for an if-else statement instead. Rename 'decomp_ret' to 'ret' and reuse
> it to keep the intermediate return value of crypto_acomp_decompress() to
> keep line lengths manageable.
>
> No functional change intended.
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  mm/zswap.c | 49 +++++++++++++++++++------------------------------
>  1 file changed, 19 insertions(+), 30 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 2f410507cbc8..aea3267c5a96 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -26,6 +26,7 @@
>  #include <linux/mempolicy.h>
>  #include <linux/mempool.h>
>  #include <crypto/acompress.h>
> +#include <crypto/scatterwalk.h>
>  #include <linux/zswap.h>
>  #include <linux/mm_types.h>
>  #include <linux/page-flags.h>
> @@ -936,53 +937,41 @@ static bool zswap_compress(struct page *page, struc=
t zswap_entry *entry,
>  static bool zswap_decompress(struct zswap_entry *entry, struct folio *fo=
lio)
>  {
>         struct zswap_pool *pool =3D entry->pool;
> -       struct scatterlist input, output;
> +       struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 e=
ntries */
> +       struct scatterlist output;
>         struct crypto_acomp_ctx *acomp_ctx;
> -       int decomp_ret =3D 0, dlen =3D PAGE_SIZE;
> -       u8 *src, *obj;
> +       int ret =3D 0, dlen;
>
>         acomp_ctx =3D acomp_ctx_get_cpu_lock(pool);
> -       obj =3D zs_obj_read_begin(pool->zs_pool, entry->handle, entry->le=
ngth,
> -                               acomp_ctx->buffer);
> +       zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->=
length);
>
>         /* zswap entries of length PAGE_SIZE are not compressed. */
>         if (entry->length =3D=3D PAGE_SIZE) {
> -               memcpy_to_folio(folio, 0, obj, entry->length);
> -               goto read_done;
> -       }
> -
> -       /*
> -        * zs_obj_read_begin() might return a kmap address of highmem whe=
n
> -        * acomp_ctx->buffer is not used.  However, sg_init_one() does no=
t
> -        * handle highmem addresses, so copy the object to acomp_ctx->buf=
fer.
> -        */
> -       if (virt_addr_valid(obj)) {
> -               src =3D obj;
> +               WARN_ON_ONCE(input->length !=3D PAGE_SIZE);
> +               memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, =
PAGE_SIZE);
> +               dlen =3D PAGE_SIZE;
>         } else {
> -               WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffer);
> -               memcpy(acomp_ctx->buffer, obj, entry->length);
> -               src =3D acomp_ctx->buffer;
> +               sg_init_table(&output, 1);
> +               sg_set_folio(&output, folio, PAGE_SIZE, 0);
> +               acomp_request_set_params(acomp_ctx->req, input, &output,
> +                                        entry->length, PAGE_SIZE);
> +               ret =3D crypto_acomp_decompress(acomp_ctx->req);
> +               ret =3D crypto_wait_req(ret, &acomp_ctx->wait);
> +               dlen =3D acomp_ctx->req->dlen;
>         }
>
> -       sg_init_one(&input, src, entry->length);
> -       sg_init_table(&output, 1);
> -       sg_set_folio(&output, folio, PAGE_SIZE, 0);
> -       acomp_request_set_params(acomp_ctx->req, &input, &output, entry->=
length, PAGE_SIZE);
> -       decomp_ret =3D crypto_wait_req(crypto_acomp_decompress(acomp_ctx-=
>req), &acomp_ctx->wait);
> -       dlen =3D acomp_ctx->req->dlen;
> -
> -read_done:
> -       zs_obj_read_end(pool->zs_pool, entry->handle, entry->length, obj)=
;
> +       zs_obj_read_sg_end(pool->zs_pool, entry->handle);
>         acomp_ctx_put_unlock(acomp_ctx);
>
> -       if (!decomp_ret && dlen =3D=3D PAGE_SIZE)
> +       if (!ret && dlen =3D=3D PAGE_SIZE)
>                 return true;
>
>         zswap_decompress_fail++;
>         pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %=
u->%d)\n",
>                                                 swp_type(entry->swpentry)=
,
>                                                 swp_offset(entry->swpentr=
y),
> -                                               entry->pool->tfm_name, en=
try->length, dlen);
> +                                               entry->pool->tfm_name,
> +                                               entry->length, dlen);

Just style change? :)

>         return false;
>  }
>
> --
> 2.52.0.457.g6b5491de43-goog
>

Looks like the new zsmalloc sglist-based API has landed in mm-stable.

With that, the zswap API conversion LGTM.

Acked-by: Nhat Pham <nphamcs@gmail.com>

