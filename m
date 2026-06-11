Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 817E1CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE9BF6B008C; Wed, 10 Jun 2026 23:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC12D6B0092; Wed, 10 Jun 2026 23:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE8C6B0093; Wed, 10 Jun 2026 23:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB366B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:20:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74DE21C162B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:20:58 +0000 (UTC)
X-FDA: 84866180196.17.CA17AB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7EC2C8000D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:20:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BhVThD56;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781148056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVcKi1f77qiMyC40ur3BSKKyG1bTa9PFXqX/bbrlf10=;
	b=b7SkpGz43KdfMnrYWU28wb2YCx0NmHfsc9PF9ty9dJMr8FG0CdhPHwZJG1qokUJRHa85WJ
	3FWRhu5eq9jDqoUXOgB1Ea1Pl459zgN/S58BUiLvLufQWhC3FBFByBj/AjMMlYRe+z0j0+
	ZcToSRpi0X2ZDpao07HQHLzseZXlgQA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BhVThD56;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781148056;
	b=sjY4O4cfYF0yAHia694+WmlLOlVMRjmxJc1Ld/OvvY4cblp6fqCyahwx6m8SATdUlDhGIv
	lwkNuGy9yri/T07eChcDzlRZG2Ic8BC6RKaVz06r2UeDvx5xEbkKm+KzUBJQtowG4k1FBe
	sGRRZ/5EayLFFvg1XTE4YvcLit4sOGc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD70C44244
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54731F0089F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781148055;
	bh=AVcKi1f77qiMyC40ur3BSKKyG1bTa9PFXqX/bbrlf10=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BhVThD567kQiLtZoLudCNoHzShhTG6V4B08Pod1f/FVNfP42bDaC607BK60i+cym2
	 mJQgbBBB1xiuvjMzKddNLPo7dADL8Ez8TnfpMTi6lyYCv+DIFWS+E4BrseqZl2FeXx
	 jwIpxJ+AaSwgKh5HqtvqjOCgblgbR0Vlvv/WEvE7kXO8OZhyWhvzxLdLnqUQsgpdbI
	 zSiJWp7vUBjNHLV4eGMKvqRARp6Ch8/LpW+APv4Thv9zyp7mi+lXzeIOjgsszj5L8j
	 oIzBkNyvCVLmN11FTaOrVn6SR5pYXLmmat0Ul77b3e0G0V1imtZWnrBdToX6USn44E
	 XO8hQNYM6lTqA==
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-66062a414fcso8339581d50.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:20:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/QcEU3YGnKEFVFpkgAamEW9tegG/TjcUvEI6C8PA80f4OvorPB7shZwOepS5GPIO+m22kwFly2fQ==@kvack.org
X-Gm-Message-State: AOJu0YzAK716OxGu0lgG0v27cGhtPu6GgZtEvBDy64XWtWg4lGVAjKKY
	54H5YRExbZ7kxKTF+RKgMQ4yWbldtzTEfX61NVHJHVyiY6F70cWyi7QIG4yKenAqUK2uSHpJTRv
	wNip06RGHv7GcIGk+X5BDhJKzG88ONyeC0nEttMUPIQ==
X-Received: by 2002:a05:690e:1515:b0:657:b16e:f63c with SMTP id
 956f58d0204a3-6626969d6b9mr929392d50.28.1781148055044; Wed, 10 Jun 2026
 20:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-3-hch@lst.de>
In-Reply-To: <20260601113449.3464734-3-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 10 Jun 2026 20:20:43 -0700
X-Gmail-Original-Message-ID: <CACePvbXVWF7-bPxOunPWHrTaK6OtxZRDWTZX-rtBU0COdbEb4w@mail.gmail.com>
X-Gm-Features: AVVi8Cco_f2nI5F8FsrOc2XjV-hP8PQkyMLgaIgMLj5GokFj9Am4pasNt_pg7NQ
Message-ID: <CACePvbXVWF7-bPxOunPWHrTaK6OtxZRDWTZX-rtBU0COdbEb4w@mail.gmail.com>
Subject: Re: [PATCH 2/8] mm: merge writeout into pageout
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, usama.arif@linux.dev, 
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7EC2C8000D
X-Stat-Signature: 8rmf965fscmgktdtm37r9sx3gumhxp6e
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781148056-139809
X-HE-Meta: U2FsdGVkX1+PvbnXOdDdOwIVvGLfztRhLie9YEqDGhL10WJwLdBIfLG28CxG2ruzKjUZxr0gHcL5I8VYiHnsu1vJTP2xLixANDsedHkdxQj6IDfbIVBduhP9UdB+/3u8L5CZ+u+981f0Fe0ReCEyR5x/a4PwQzJB+fZhJtPVtqbg/RdP01Mg0UViIKnbC4ukHMXXTKO5MYF1p8eFvooabUrtBH8Ju0Nm+2U5Xt5OSsSJM6hbRNnSICGlU7Xd6fJiE115HUB31OgwF2e8KrohJcfVTGlokjzCWm2o4fhoNEuQ7bqU0D7lfOzF9o5TJQRUZwzodfu7CHlyCvCYRqEsmKo5FXDOm1RV3VQSAs634dOnfH6yEkkJiTjsQ4OKabj16jqrUQvpCbHW+6zPY6nEM4462x/c2TAbbQMPo2jB5hfyUFYHSBUSrEM31KvydG0yrDvQbeSdAn72x6jqEfAi/wNdAkMBw7frnWTymunEsX+5q7K7nOPEqC3GUvwx/6uK90hOiarsF2oscUmp1+ZUQSw7ftEJj18c9aZsr81u7XUcUI1/u0h0SZOglQLJWpMv/etAlj1dRtGp0OeaqnEtWp58hDkCs0QAdbtRHnmjNOq2/zqC5iZNe04zXI+Cg9EZd0DXinD1/nYjDcEudOXLe2suRhN5yd3UaNqdLiTEGAiJJnhZYjmufDoooX/d+QEBSNBB5zm7azfFN5xXfbRYb/f3y65mcSlJXYjZNRVswiAtVtvY/85JC4nRTA0iiRVN6+5NdK5zP9zqVvkjjaHD8+uYdZr4eQXfcAEIsbUuYd1B55nyFEot9+vX6WAYW1AZyA8EHB7w+frdPolGJl7CU3Ne6EKSUQV/6J9+d/eNir7m8nSyQxbbhdEp0bE1iV6HfLdWgzzyeT3pUQ7HB6vq+oaaX6AqBbUo1vA918S6DPJUIz1j87quT74g3NKLQ1fJTl8DvsaA8P0ilJ8nULL
 Ca9LnOaR
 8eRy1na+40ioTvqqlmXNK8mkugKMz8md9BUOovKkWKLzZVKiB2JTkQ61rxWfoY4/8hyrZtgEouLCwBh2lUeGWOCpOw2SqtKFKU/9q8Lpd2SOm7iDB52+sdqbxch5Ba2c9SxWCHM/R1AUh779x0d+tG/ediYhUQaiYxG00LsRQHivLFnnzztWAIg6jT8vszqzaxDUFeVCbr+XXSCwjmjrB0gdDaxyDKoWYitzm6WwK+9x9eFLdHA3kLGpYurcIXl82FQsVI4+C39MS6TBMJVJIn3883vXytgnXvf7G0yrF3vi4IB1sQKB5Z4n4rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:35=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> writeout is only called from pageout, and a straight flow at the end, so
> merge the two functions.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/vmscan.c | 63 ++++++++++++++++++++++++-----------------------------
>  1 file changed, 29 insertions(+), 34 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e8a90911bf88..d7303eea1265 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -612,45 +612,14 @@ typedef enum {
>         PAGE_CLEAN,
>  } pageout_t;
>
> -static pageout_t writeout(struct folio *folio, struct address_space *map=
ping,
> -               struct swap_iocb **plug, struct list_head *folio_list)
> -{
> -       int res;
> -
> -       folio_set_reclaim(folio);
> -
> -       /*
> -        * The large shmem folio can be split if CONFIG_THP_SWAP is not e=
nabled
> -        * or we failed to allocate contiguous swap entries, in which cas=
e
> -        * the split out folios get added back to folio_list.
> -        */
> -       if (shmem_mapping(mapping))
> -               res =3D shmem_writeout(folio, plug, folio_list);
> -       else
> -               res =3D swap_writeout(folio, plug);
> -
> -       if (res < 0)
> -               handle_write_error(mapping, folio, res);
> -       if (res =3D=3D AOP_WRITEPAGE_ACTIVATE) {
> -               folio_clear_reclaim(folio);
> -               return PAGE_ACTIVATE;
> -       }
> -
> -       /* synchronous write? */
> -       if (!folio_test_writeback(folio))
> -               folio_clear_reclaim(folio);
> -
> -       trace_mm_vmscan_write_folio(folio);
> -       node_stat_add_folio(folio, NR_VMSCAN_WRITE);
> -       return PAGE_SUCCESS;
> -}
> -
>  /*
>   * pageout is called by shrink_folio_list() for each dirty folio.
>   */
>  static pageout_t pageout(struct folio *folio, struct address_space *mapp=
ing,
>                          struct swap_iocb **plug, struct list_head *folio=
_list)
>  {
> +       int res;
> +
>         /*
>          * We no longer attempt to writeback filesystem folios here, othe=
r
>          * than tmpfs/shmem.  That's taken care of in page-writeback.
> @@ -674,7 +643,33 @@ static pageout_t pageout(struct folio *folio, struct=
 address_space *mapping,
>                 return PAGE_ACTIVATE;
>         if (!folio_clear_dirty_for_io(folio))
>                 return PAGE_CLEAN;
> -       return writeout(folio, mapping, plug, folio_list);
> +
> +       folio_set_reclaim(folio);
> +
> +       /*
> +        * The large shmem folio can be split if CONFIG_THP_SWAP is not e=
nabled
> +        * or we failed to allocate contiguous swap entries, in which cas=
e
> +        * the split out folios get added back to folio_list.
> +        */
> +       if (shmem_mapping(mapping))
> +               res =3D shmem_writeout(folio, plug, folio_list);
> +       else
> +               res =3D swap_writeout(folio, plug);
> +
> +       if (res < 0)
> +               handle_write_error(mapping, folio, res);
> +       if (res =3D=3D AOP_WRITEPAGE_ACTIVATE) {
> +               folio_clear_reclaim(folio);
> +               return PAGE_ACTIVATE;
> +       }
> +
> +       /* synchronous write? */
> +       if (!folio_test_writeback(folio))
> +               folio_clear_reclaim(folio);
> +
> +       trace_mm_vmscan_write_folio(folio);
> +       node_stat_add_folio(folio, NR_VMSCAN_WRITE);
> +       return PAGE_SUCCESS;
>  }
>
>  /*
> --
> 2.53.0
>

