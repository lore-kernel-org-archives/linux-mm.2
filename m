Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A47A2CC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3CBF6B0089; Thu,  2 Apr 2026 02:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C15276B008A; Thu,  2 Apr 2026 02:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29EE6B008C; Thu,  2 Apr 2026 02:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4B046B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:17:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54B33160497
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:17:43 +0000 (UTC)
X-FDA: 84612609606.01.D7FFD06
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7475FA0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:17:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g2TsLGn7;
	spf=pass (imf15.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775110661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxoP++nGLbNLck2YTlksc13q8UFRTvJ8wOA5jMTO/9s=;
	b=DHK6PERQwXeK5hLuAd7u1zDsBET6nA/g3A2SGzRNFgCac9Eu0CFyyL+U/NVjqJkqVp+ZDH
	eDlbIRSoas8RkZmHXqkqQY3Y4ox1QS9XO9AIlris4pLnhkiBDlJHQjPY9BshwgH67xp3zI
	EJpMY8L58sfJT6vo1RhwWgdK1oDt3M0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g2TsLGn7;
	spf=pass (imf15.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775110661; a=rsa-sha256;
	cv=pass;
	b=AdnDj6f0/TufGZh4NS2x2aGhDFCg1iIBKy5hPArO/KKLClnVyg8ge92u8CxzHJhTUIUePl
	M0uCqiPkMRQiTLsR1djXukRw/sClq6ENicRvYfx/yEQspEJq+VpALT4KVKH1SK8ftX9ybd
	wWqsXw8d/j6k/Yd/+jN9ngFMckxZSEI=
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-41576c5c01cso296998fac.3
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 23:17:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775110660; cv=none;
        d=google.com; s=arc-20240605;
        b=eVMXZTxTW/855G4QRh7bGuoy9pb8pMovTjLT7udYsXiuOak+UTv9Ig5DcYMq2CyRsf
         VveKMZqJjSvqB8cH5fWA4/22AO+4OTp6XqX8sZjeLcuZnN9s5jwud42fQqrXY8dN1/An
         A44ND6330c12NpchqX21w8lP9hVsrBwsA1HcYRTYekWEszPJBcQL2OYN42C4kb4xqot8
         dgtZytIbL+MkPnhxzqcLyLO5Vti7nTsIKIrzGZph+LxW9Dwv9MN4Yr4h9kkl2pQAAjAK
         XMuFScy8x9/Vwd6eUb1SZZ7z2YDuafH3rjPebsU1ziSNy0CMHQadpADJJX9oL/HA2eKN
         fJ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SxoP++nGLbNLck2YTlksc13q8UFRTvJ8wOA5jMTO/9s=;
        fh=B+/MDl0SuB2YNu3dv9wFwN3JdHT3VAH1M5J5VHowT10=;
        b=M/9ClwUfzPtI3VB7C2qZrKkvEDkZChUAK59fKzlRj0M07I15iYGMFiMGsCEdeqUr+i
         52Q8v9NcY3FPcQJeYkHX+D0K0u5FH/Oxh1KjKsjrPy1+2CMbjaMvvZnVFWsgSO4FlUAq
         35i7VmQ7/uF229KZ3KLPdOTNAloPwP/n1vewElgXnLGWqLkE+1jWwGQf/zHt+wR5yofb
         gx0gxfjkJRJZaWSl4SFTGesqSxFHnWOGHSOXGTR+mJhqsfRUIjqQHQr/U0fKzBXm9S6P
         Aj4MF00tMrnykf4n4NNZ0SdXFuJhSreBSwFJ5BlRB0tOsuOAgkyg1srM1iKugwnn99lv
         zc7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775110660; x=1775715460; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SxoP++nGLbNLck2YTlksc13q8UFRTvJ8wOA5jMTO/9s=;
        b=g2TsLGn7bHyWro+dpVHqzjRxrQqN+H9GU18e1ovG3SGo5GrvzNhokOekJ/4W0tStHH
         DP+4ZkJg2vgl5YGBvnPzSNlboktHVF2hNlyLEVfYLBx2ZaXcMx5UJG84KqubjSNJm4WJ
         LJjZj6cKFGVo8ZP18CHCP2O5b7/OopYYaV3s9cz68lJSFXdXWXigArXe80D6+1iFf0mu
         1FBuqKf/liB0nxQq0ec//LW14+JCq++Drbx3/OqM2AZTZIDe52YPvUtmM9otPHBrSqg7
         5xRWFb6BQ447/fFi9mHdAYAy1qozW5vVqXbMiHzvDMxz91gEaYgPYcs38r1V63ZZOZe3
         emiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775110660; x=1775715460;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SxoP++nGLbNLck2YTlksc13q8UFRTvJ8wOA5jMTO/9s=;
        b=bX8IiPouLRGd6HKXGsv5c9ayAq3yS9snL2u/bRnhBep0jOUwNs7oYC/bRSfrbGx3Il
         mAwVKhO8CiKfeSp2CDzqVqMC91QYasrHu74TFoZ9s6Ia/qnIYltooMGxYoYB8ImvzXXr
         1Vlm3TESJ1HwWL8yPMhnNGnZx7v2XeI6XFlsxhT0DCZPm9XQ5K5IgyxBE0IzI+OJVmSB
         WZz33se2u0bOPH0qQjXvn4+bdy7LfEXiFLmoz3EgeF61CQrGtBejerCBWLAWg3JneUXE
         jBatCIVzbDceh/21/NHxE+BZ94JUUZ2L14ptd8N5/cUgMaZHqQTQJbXyJsgYJAzxIF8W
         mZdA==
X-Forwarded-Encrypted: i=1; AJvYcCXhjakRwalwTJa0ytUsN7BcZa1MJfXKwPQf+Cv+ILWOqggR8n/cNNDuINRxlCcLGiemx9jTdKYBHg==@kvack.org
X-Gm-Message-State: AOJu0YzwJpekX73zlp8/ss63c3BZoHEfiDTzL9eneKb8+1yOvcrfkcSh
	G6+2jnHVKQFG+8Syi9RiGuEuh6COKZ0o61WHnu0yBI88nvVaw5b0XVPZcTj5BLfbc4HT49Cmy2k
	dIC18fXKga8hz76I3hCYps7WJQm/vNCk=
X-Gm-Gg: ATEYQzzcj0VtJi2VOuNieKm+U3MjT4ZI+M9omsMc3M8zUgJiy0an8yB4oEL6ggilWcz
	lph036WN/1ke6vq5f8P9JNCfC73fT3llsqefWIIoR5sr30z9R6kaohdY+n68EpDEOoRESQd5Gee
	BghnkEwRHL/hyAHVKjmvxejL/pUSsNyf6WHAXgTlNb6JZxlV8qxJzlCuiX56eNJgpnQFUnLymkY
	N3rhIGoZG2ts7Bz23lT5W1ote+25Aa8Mx0Mox8GGns3RdeewHcZGYcXn8Gkz7h8h9GuoHbZA+8G
	q+/nb4Pabt6dsq3nCq4sjSn2lh/Xraf8Lrcftw==
X-Received: by 2002:a05:6870:d6a0:b0:417:51a0:23b1 with SMTP id
 586e51a60fabf-422cff84e39mr3914326fac.41.1775110660340; Wed, 01 Apr 2026
 23:17:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260402061202.35097-1-devnexen@gmail.com>
In-Reply-To: <20260402061202.35097-1-devnexen@gmail.com>
From: David CARLIER <devnexen@gmail.com>
Date: Thu, 2 Apr 2026 07:17:29 +0100
X-Gm-Features: AQROBzAbXudyDxpcERfyC4rHqEDDn7g3uBanUJ0KPo7KlpVh9HeLQvzV22k_ixg
Message-ID: <CA+XhMqwXe89x_QYjsbUtf7rdRt47tSGGGy-QnFBMsYJU-ohOxw@mail.gmail.com>
Subject: Re: [PATCH v4] mm/page_io: rename swap_iocb->pages to swap_iocb->bvecs
To: David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, NeilBrown <neil@brown.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7475FA0005
X-Stat-Signature: izreo88duphdzf9ei3a3b63ra14p96xr
X-Rspam-User: 
X-HE-Tag: 1775110661-864458
X-HE-Meta: U2FsdGVkX1+W/HjigmUnDkaavWxqQOqxvV5VFDJcbsw42hpxrn8TrMAo9x8IYN5yP+/4jKyZTo1okdZfEYlP1z8zufeJig03VR1CVSRgmf5AA/a1qjb/uT8ZtNsAJHw1q7TcnfxKheZnprw021i9jE4ox88LIod5GU5Wh9lrJubJzz69GrLMZSYiqp62GwKQya4DUoDg9OigRACKc0fKRNPF1i4wyFKaMg9zyi25B0RwcZqf7ecjFZC1iKS18kh0/stD/Pu0gkq4beP7uZiX+prffJNyvW9ysG+89gb+gTB0jaNhbdBa62q4UooJytnAxC/ZjYsJ4EWSv3f+wFTfCNVTM4FQJanK5QJ3re5UuEXZAjz/KvkgQTqGUHEPxaOu+xRt9V3+69EzdVHHiz/+MeCBRUYo0oZs6YuryvQAoWWzVrvNzpJ/tpntsYSgmecR2HkiHcBoSwg2k8WtF6b6ZIbkl3O0Vdjgtzmaz4Mfbx4ES9SnGOE4bq4auwEhYHB6NeGPdT2JdL/xUFAz4Kft3fSnc/4IkC7zwxM/Y0i3MX7YksXGCB4QC3fJLhsBpe5n2E7cWM3nbgFblad9huMZbgjM6J7lRdKoeIvZ41gqBwEtvRScVJ/7jSXTFchYJws5e1xApppVsnDIC4voOTTWEYkqdMWNpFtbW6U0ObYM+80jOy0fbp1fcOwXs+O3DQx39Tj00JQVWIkTJFjDAi88cdwFvuLTsujwsVo5xP/Ryw4YpkMEWWvqgAknyhY8FDe3c/iPtAfHT53wnBje/XLej+IEnlp/6FXd3LbLjSuOuqzx+CR3iqy1UwNHaewAiaZ0v7I0MUltlUI8m3x/fLsojbXgVcbjdIywBP8EVdTHhhxmFrgwwrLnUqnBMovyYRDB0tECaX99UUowyAKCt+7OCdyebg1Cgvygueiy1fEdgqaiAJKSiOaCCGExaQmelbJMSSJiPo8k4RreiLmsnZN
 sfwY9qJI
 yNLALzDxfgz/sTQ5oVJwp5PEL+YdXmMjHs0Xw7qUUK6DI6ZF5CZtcH3qXiLK6ZApMQaRbehsV5McozHYNqAJAEXYzflamupv4Eb2Rq7v8ax1vvKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

please ignore this one, I resent after. Cheers.

On Thu, 2 Apr 2026 at 07:12, David Carlier <devnexen@gmail.com> wrote:
>
> swap_iocb->pages tracks the number of bvec entries (folios), not base
> pages. Rename it to bvecs to accurately reflect its purpose.
>
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
> v4: renamed swap_iocb->pages to ->bvecs (Willy)
> v3: use sio->len for PSWPIN accounting
> v2: convert sio_write_complete() to folio APIs
>  mm/page_io.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 1389cd57ca88..e524cb821d04 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -327,7 +327,7 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
>  struct swap_iocb {
>         struct kiocb            iocb;
>         struct bio_vec          bvec[SWAP_CLUSTER_MAX];
> -       int                     pages;
> +       int                     bvecs;
>         int                     len;
>  };
>  static mempool_t *sio_pool;
> @@ -362,14 +362,14 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
>                  */
>                 pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
>                                    ret, swap_dev_pos(page_swap_entry(page)));
> -               for (p = 0; p < sio->pages; p++) {
> +               for (p = 0; p < sio->bvecs; p++) {
>                         page = sio->bvec[p].bv_page;
>                         set_page_dirty(page);
>                         ClearPageReclaim(page);
>                 }
>         }
>
> -       for (p = 0; p < sio->pages; p++)
> +       for (p = 0; p < sio->bvecs; p++)
>                 end_page_writeback(sio->bvec[p].bv_page);
>
>         mempool_free(sio, sio_pool);
> @@ -397,13 +397,13 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
>                 init_sync_kiocb(&sio->iocb, swap_file);
>                 sio->iocb.ki_complete = sio_write_complete;
>                 sio->iocb.ki_pos = pos;
> -               sio->pages = 0;
> +               sio->bvecs = 0;
>                 sio->len = 0;
>         }
> -       bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
> +       bvec_set_folio(&sio->bvec[sio->bvecs], folio, folio_size(folio), 0);
>         sio->len += folio_size(folio);
> -       sio->pages += 1;
> -       if (sio->pages == ARRAY_SIZE(sio->bvec) || !swap_plug) {
> +       sio->bvecs += 1;
> +       if (sio->bvecs == ARRAY_SIZE(sio->bvec) || !swap_plug) {
>                 swap_write_unplug(sio);
>                 sio = NULL;
>         }
> @@ -477,7 +477,7 @@ void swap_write_unplug(struct swap_iocb *sio)
>         struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
>         int ret;
>
> -       iov_iter_bvec(&from, ITER_SOURCE, sio->bvec, sio->pages, sio->len);
> +       iov_iter_bvec(&from, ITER_SOURCE, sio->bvec, sio->bvecs, sio->len);
>         ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
>         if (ret != -EIOCBQUEUED)
>                 sio_write_complete(&sio->iocb, ret);
> @@ -489,7 +489,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
>         int p;
>
>         if (ret == sio->len) {
> -               for (p = 0; p < sio->pages; p++) {
> +               for (p = 0; p < sio->bvecs; p++) {
>                         struct folio *folio = page_folio(sio->bvec[p].bv_page);
>
>                         count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
> @@ -499,7 +499,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
>                 }
>                 count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
>         } else {
> -               for (p = 0; p < sio->pages; p++) {
> +               for (p = 0; p < sio->bvecs; p++) {
>                         struct folio *folio = page_folio(sio->bvec[p].bv_page);
>
>                         folio_unlock(folio);
> @@ -559,13 +559,13 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
>                 init_sync_kiocb(&sio->iocb, sis->swap_file);
>                 sio->iocb.ki_pos = pos;
>                 sio->iocb.ki_complete = sio_read_complete;
> -               sio->pages = 0;
> +               sio->bvecs = 0;
>                 sio->len = 0;
>         }
> -       bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
> +       bvec_set_folio(&sio->bvec[sio->bvecs], folio, folio_size(folio), 0);
>         sio->len += folio_size(folio);
> -       sio->pages += 1;
> -       if (sio->pages == ARRAY_SIZE(sio->bvec) || !plug) {
> +       sio->bvecs += 1;
> +       if (sio->bvecs == ARRAY_SIZE(sio->bvec) || !plug) {
>                 swap_read_unplug(sio);
>                 sio = NULL;
>         }
> @@ -666,7 +666,7 @@ void __swap_read_unplug(struct swap_iocb *sio)
>         struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
>         int ret;
>
> -       iov_iter_bvec(&from, ITER_DEST, sio->bvec, sio->pages, sio->len);
> +       iov_iter_bvec(&from, ITER_DEST, sio->bvec, sio->bvecs, sio->len);
>         ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
>         if (ret != -EIOCBQUEUED)
>                 sio_read_complete(&sio->iocb, ret);
> --
> 2.53.0
>

