Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48627C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 21:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DE6A6B008C; Fri, 28 Aug 2026 17:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6306B0092; Fri, 28 Aug 2026 17:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CBAB6B0095; Fri, 28 Aug 2026 17:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1890C6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:24:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F47F4057E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:24:31 +0000 (UTC)
X-FDA: 85151957142.06.AF2C7A5
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id AAA5940007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:24:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z4hPtbfv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787952269;
	b=ECaCTdn2+RKzmBcWHBdC7wjaDrRgdsKdrgx3ViFbKPXQc/0M+ipQFDm3Qso1IoE/FK3Q75
	66d7mw7j8yhXYw79GZQ9eu/3nv+nX77nE7sWpGkmcH8bHwCcmyBtGSLnCc1qqmHSIHdyEe
	HvOPi5lcbzhFLjsYIm6/dLHrDs+Vies=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z4hPtbfv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787952269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5bRhAW4BZGTRB4QS3OBjmnWX2zYNUF8sCy1+AA5KEE=;
	b=bIistADMJC6SVsLTj74H7b4Lt0LZ9I6fkjCQcMTcBjulWwu7cFxt81bFE47VEpzxFORqe5
	7VFGD26xUJnJL7PMK7nvRiY09qWDbuG8sn+DBR3spVglXz7TrMrI49zLnaNX01dzesoojw
	huX8znBZi/nCzcWv68ELmUfdYMqGJl4=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c10e86e52so32281cf.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:24:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787952269; cv=none;
        d=google.com; s=arc-20260327;
        b=B4ArBAUEaWGaNtFJe8glnC5VU2t+AJL+eAJ2vg5UxbP022JQuK7xvVDk1+i2YUZwGn
         +HzpbE0jvy//FXwxFbTneGbEOYqNsqYa27luEgwY/3hVtJGFAVHNw04XnwkfY/nOaVdp
         cYUTJcDyrghDbZ1G6z2lOFyFGi3dd8UFFnGBTHf69AF+1flX5n+9NuFiKfKfiZA1P+a2
         YSvw1+4kN8igybyoWR5Jd9/bShSz4prlxfkyRO/BCtjFULgBoIHiGr6OtFdCVDqTrpro
         7I4tjL1bb1mk2NobauOO2zFBTlgTH21vLkRFwlcFea9vJljLI53hs9v8hiWBPlINfxai
         NOtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q5bRhAW4BZGTRB4QS3OBjmnWX2zYNUF8sCy1+AA5KEE=;
        fh=YZNDvRfuJvxq9aozotQROrjH201aPPkaL3NmqKwCKeo=;
        b=CJSblIjnqxpIYmC5HHkORW1hcQMEk4irdQegacQwrgDIeOnu4kNKtbpKjnvcsfKNUe
         FOTu/VAA6zan9qvviEjuojd9oa771r70+mzjwH8WOKwvAB3apdHtEzfyOoF0RNjBxVBT
         YC8jWwlT6alNHgQpLOCSINJHnxb373ulGeJdoa6tSR/7MvetgSeftoMA47JzCoA+ssRS
         quMmXXyBMZo91ZB1oY5/JPEZEhvMd8z0dX0w+KQ/haOqtGtaolpl7/XPzToDF8QbU1yf
         7kjnJmOsrK1MKXQzNGC3ZkI0xM8Y+YS/KMrsPLZVfOr11ylbAgD0pvZRVmPZrbUPXDNM
         QV2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787952269; x=1788557069; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q5bRhAW4BZGTRB4QS3OBjmnWX2zYNUF8sCy1+AA5KEE=;
        b=Z4hPtbfvclJ8+RvluVr1TRRZnCFd3hR84E74MBb5cV03OLUIMT4qPLbnlGS3EwIMmg
         2aDFFgxh4wZ2fR2qrLfhDSs76WIQo3pzU2n6euBG8tAdKxzqkZqbwb4aZA36M7i2vL9v
         ylUf4FnkvmJIzUt0dqiI2u4CLH8XLP+5dqXW3Le0vf1hQyhwfNGCwM9iuebokNL8Pjf8
         52AQ1HBpD0gQPVundjbGgBtMh7P0BMI0kcKCFmkpIvWZ5mH77V0GX/sYVw/YcoOSKPtn
         Vkn8awlCDl79hsX+IusNFlpKGLKnw6LKHut1MluUBWjyQVmxkRXRkiKe6W1EWiw5T4sC
         hRbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787952269; x=1788557069;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q5bRhAW4BZGTRB4QS3OBjmnWX2zYNUF8sCy1+AA5KEE=;
        b=k7xQw9jEIR9LEG+QaQvCastEkURTkG1Q+OccXt+0nmwELyepemv2VLs5d38UcE9Smv
         IFWr3bw+OKPAnlPkLy2B8eIwR2YDOScVzyqwpk/1QWLqhMJk25NwdNe4tiylHhwufeVy
         o1abnaRHT1od/5wDznIm0OYgWR/J7q1qDu8Ryb054ivr6CNuVkSOJRpN1ZC+5ecn3t7b
         J0ke4VqXvFkIuDUGxNpegZsetFOfis4BK3h8Ax4945Sr4cQHsdxBMvtL8cn/0gGGEXQq
         FgJVrTbtH+bcDFMMOW+AQXX5OceeUgMwUpmSpN/vO/RT/3kxorBqSwe+Q+UTTAbi80Vu
         oPtw==
X-Forwarded-Encrypted: i=1; AHgh+Rr4U7OaukqY9/KVehwgwZn5IrKeqMa2AlsXm7/QYcvu3eYly51y4LU7d22s4L6APfD44UilaCBzNg==@kvack.org
X-Gm-Message-State: AFuF++k1nn5qF5bumELnl53/WLXhr95lxk41fE+mml4wk5rUKIy/JVtD
	cshfpyj7dRK4SRlr19Woxku9lzA42pjoNnyhWpafs2dF5a7xi1/RHVCOuBXvvLqC6FFHkWY2sq3
	EWUx6b8O5ACzDI4N6IfjqT6FnVlEZMYzPGtdp98g7
X-Gm-Gg: AR+sD10tzCaGWD8gD4YnVXiH3ZS7kMItgn0MaoIUROWlav5hbAYmgpZKsZ/b6fKqVVN
	FsF26pq/+u7Z/9Qse72rSNfbmfgP04VbhtNw4zuULmrbQ5/hWU0Fwev87vbv9qDr/BB8g0E21OF
	36L4ERPSJOv8rtaE1WJLwZtLPK1zxIs5wgu+VWQEoyKFfVs/QMWhEfrtfWn/MPgvX6xbjnvyqIE
	Y8rwu0fV9kDsbhsXf/BfZEuAMwabZ0H3Bk5EasKuavDG/hgFUmK5Pnhu9OLJ6z77cMfuvDV4UFe
	G0acfkzQy3iHa7joANVRRaKnAJKCsFJlVfrA053p9Ho=
X-Received: by 2002:ac8:58c5:0:b0:52d:9d62:6163 with SMTP id
 d75a77b69052e-52ff715f2cemr3483601cf.9.1787952267794; Fri, 28 Aug 2026
 14:24:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260811025157.1632867-1-riel@surriel.com> <20260811025157.1632867-2-riel@surriel.com>
In-Reply-To: <20260811025157.1632867-2-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 28 Aug 2026 14:24:15 -0700
X-Gm-Features: AcwNN1WD4nMWnH_vAAvC-6nH870HRFxLAtQC4csfA8OjXMF11JErzAmHFOM2MwE
Message-ID: <CAJuCfpHwPj9DtcsiaN43ofWgur0_ATGEhqQBqzezYZRen6TC+A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/8] mm/gup: break out gup_fill_pages() helper
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: zkr3393jgohtbhyebaph78q7a6q3p5os
X-Rspamd-Queue-Id: AAA5940007
X-Rspamd-Server: rspam06
X-HE-Tag: 1787952269-85954
X-HE-Meta: U2FsdGVkX18dTTt6D9jktHuoMj8FDsmsLCraNK3qcwde5AWibWBahCRU2BNpqkvo/1j4YLECX/4WgeQdzyS9iLn8lToRwMYs2YVcs8cc/bcCAmKf3KXaumr7D0elmOgma2EmjbYOU184zgILFOfrt1CqCsVZUzy638QD/4L2kRpgL+kz6o1WYex8Eoxta/VDcT0nTDqddYt6jldNIShKjzMN4xZ5oyQAcXXJbFGy7m8VqlT0MDelo5wKzP33Shs2qX5AF20A+YjBObfQVDwCRELMc3K/q5dHl0zUgVLmd5qSEMNC60bRfg9BO9TkcXWYqEAzajMOO/D1IApx1yHhw1UDEylPHlbM0gynWHN2kljcqE4S1aBx4IAelGvKkwSJ49e4Te1eMXYUXPH/7S3CgSJ2ANjK13Kc18vFTB7/hd/Pnlg8KKrKN6r1yNc1+XQxak5dXmnE/+ptVxfdXQGgSa7ftYbcs6hhC0D4EpWFaoYprjrHu5CJ+VVTGz/xL7yjL9rS9lvmtuzkEqaLiuxlW/z3xJl85QRnFQOqHaPvMXnHhRXQ+THwfwJOvNbz2+w4bI9GS80NIYgy6g47IldgN5H6rcx23N9CXs8pp9mZEg0YXW4QIshbq7TlqJlBsDs04dcIPL854jQLxmxMZPcyv4E8B1hLZ/PIllD2+tpOtBypZZeT7ltPSG+UmbjEUL8psRyN5IBC6uz0gmWoTd90chh+ftOIZElUTpPTJxJVX+1wrmLSTrPfSGx2p1/jx41f1dydoEFsQQ7HYQJlR6YO8eROCtqyMUTlr4EtMCGanuGE1ksXM1WO0O4hwUsRzOYiyVrR2hecoGFAyTO2TAM+LDAYtvecucCuMW5jEEDlX6dPddivxIWVvDhPNsq4XS+K/HdkHUmU+yTnLgRHhXhJjXNrRVDBlI/sbE9Nw5m1Hz6uh8W4P9NnJI41ZNUSL70qoRgIG0hQMPwkDsmKhFQ
 V/TKHqTJ
 NKfTPI73Ypt1eG4rH3DiPoKmxXqYcAt3SxwmovU8T8FLi6mlctCCDyVU4ng7yWJ6lIuKO9pl9sPSkTmIQtrrGdTudltHA4nGJORpp2hFm7U1Y7u59cijxGxgmFxIl4tiuoAgO1HR1bdpgPjjTd6VpeaVn3f9NXGW9Sa798ZoYT9efCfaM2b9ArecG2hAl9hbpI66spIzrge3nOvGNCUVqBaJbHPoTf1JhhlTofzH1xFHCBhd0FbjmH5E3AzDyJEWe7yXj+Ao0rqeB8QF9NtrgaWMjTJZnFnutD0XA5LBpOF134/fgq5bkXL25a4B/fOgBPFwvounasM3prStW2+Mu9ShrkDygOOsvCrlumSXDOTYXJwD9w3yM1ymgxPjmeUzYyjay
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 7:53=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> __get_user_pages() fills pages[] and flushes each page's caches in an
> open-coded loop.
>
> Move it into a gup_fill_pages() helper, which the follow_page_mask()
> call chain can then use to fill its own pages[] slots.
>
> No functional changes intended.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Rik van Riel <riel@surriel.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  mm/gup.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 0692119b7904..7bb40be89529 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -633,6 +633,23 @@ static struct page *no_page_table(struct vm_area_str=
uct *vma,
>         return NULL;
>  }
>
> +static void gup_fill_pages(struct vm_area_struct *vma, unsigned long add=
ress,
> +               struct page *page, unsigned long nr, struct page **pages)
> +{
> +       unsigned long i;
> +
> +       if (!pages)
> +               return;
> +
> +       for (i =3D 0; i < nr; i++) {
> +               struct page *subpage =3D page + i;
> +
> +               pages[i] =3D subpage;
> +               flush_anon_page(vma, subpage, address + i * PAGE_SIZE);
> +               flush_dcache_page(subpage);
> +       }
> +}
> +
>  #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
>  /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
>  static inline bool can_follow_write_pud(pud_t pud, struct page *page,
> @@ -1461,9 +1478,6 @@ static long __get_user_pages(struct mm_struct *mm,
>                         page_increm =3D nr_pages;
>
>                 if (pages) {
> -                       struct page *subpage;
> -                       unsigned int j;
> -
>                         /*
>                          * This must be a large folio (and doesn't need t=
o
>                          * be the whole folio; it can be part of it), do
> @@ -1493,12 +1507,7 @@ static long __get_user_pages(struct mm_struct *mm,
>                                 }
>                         }
>
> -                       for (j =3D 0; j < page_increm; j++) {
> -                               subpage =3D page + j;
> -                               pages[i + j] =3D subpage;
> -                               flush_anon_page(vma, subpage, start + j *=
 PAGE_SIZE);
> -                               flush_dcache_page(subpage);
> -                       }
> +                       gup_fill_pages(vma, start, page, page_increm, pag=
es + i);
>                 }
>
>                 i +=3D page_increm;
> --
> 2.55.0
>
>

