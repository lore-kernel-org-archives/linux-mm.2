Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D68EACA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 19:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D20B6B0027; Wed, 27 Aug 2025 15:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA126B0029; Wed, 27 Aug 2025 15:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F025A6B002A; Wed, 27 Aug 2025 15:01:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DF8BB6B0027
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:01:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D0095B704
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:01:59 +0000 (UTC)
X-FDA: 83823457158.25.D5A64A7
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6ECC2140008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:01:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZvLhO3Ks;
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756321317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qx38UWXoqdVI6iyQIcZ9OO1CNYdFs0IqSGSl393RoCg=;
	b=cgib7K9vbMFRk9kAOnmjHWlRWpAn9Iy9WJwBik2uuz6dxPp4S7TobvHk9g6mzN4MTwqCC4
	pBmhHN/9r72DnpMB6WU+RhYLeULhmyMQuO4NWUOBQLMQJ02R03/hlBEB9ibxtDWwhNYBkR
	iswk6zv5tLZQVow7Dfbd75eDupNX1zU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZvLhO3Ks;
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756321317; a=rsa-sha256;
	cv=none;
	b=7c0aZjzY75rnCGeStF56Spfd0RgdGQEKcZmhTaVZhp4uPHkWGb6ha1XfmDG3WE/oAQAxO4
	VL9iUMR0355efyGTqQ0iV9Rv5ukxszZS+4Gr4Ok67CuKOV0QelxWfKbO4d6fM4pMo0FDdx
	VNRRNCH0qYGezkFkQQGQ9jouzdGZ8gQ=
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-523905eba4aso29224137.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756321316; x=1756926116; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qx38UWXoqdVI6iyQIcZ9OO1CNYdFs0IqSGSl393RoCg=;
        b=ZvLhO3KsyRK+GhBL1WyTtAmZl2Da5DgMsO57Rt0ga+3RkPZT3LM+4r0PRfaKyiP/iG
         nhA1+tqJB9/G1LK+0HxJCgm0MCIN1r8ISwGDc6Kb9O7PhLybYyt4Nhq9Oii+mJdaUlJZ
         ImXrNR+/8uUzFT4l7+nlebFNnYt3aYi6kAN2BN6jrJZJu0hNdC52hsvmrGlNOclwNYFQ
         H1uG+a9yH03eYByanBJOt69mqwrt1cV7pd/r2ycPbPDBSk6Jn1JWJmfMcqU10tsWilA/
         VA3u+dbiadQ7FMj5kcGs1RFdxB4vYYOb0UtkAH7pZCHjQqILQgNJfe9JxnaPUNBxB6F8
         lTJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756321316; x=1756926116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qx38UWXoqdVI6iyQIcZ9OO1CNYdFs0IqSGSl393RoCg=;
        b=XKAg0M5T/MaDWMWmugb5BgtNm4LJfDtEWH4m6KubwePZQuIVsWtEAxZku8yv5SMXWm
         4FYvAEateAu7O/O3VR8w2RzXdHMRiOuqKMpvavifnxGodP9T1sCYChsQOYO+aJ/p14BL
         CfItoQ37t4JlVLoYcNuIJzfWO70Sm8fSVsdjnC6ApVjB7q7mvdC5dC6pG7Sz6KMfuk+d
         mu/J2bgLk0ePeDSp/HNZke3YY6PPyrCz26CcpJxgjl+pIZI9lvQXx6TDq/qiO77E3mhs
         w6KGHkQS3RIsVGG71Vf0Alk3HBdBqaJdfPNEY9JpFLCK4uCvMc3+F+okpw9J6i4cG4c0
         x9kg==
X-Forwarded-Encrypted: i=1; AJvYcCVP7/bUYRHuY3ZaJlh1kNiB8pyUAKC3GcXc/sQGOjUw+QX+TLXqfKKmv5Ue2rE6cyp6CkUhBkONTw==@kvack.org
X-Gm-Message-State: AOJu0YxlJODV2PZChA4xQPUPIjE4CgMg7S4LywfLPjASubgBwSxcUmYH
	gZ/SAET25sWruEwcrZ5jeBN8PzeRPxtpPrSSP7wuu9h4cOWqdUkmHL2p6ZqvwwWmuDsjY1aLu/v
	1IHe4RSs9MO8iqI4pE35PYs3ee9605NY=
X-Gm-Gg: ASbGncsmx7L0FOxLqgfHtuGZEz2wgo0i0H3OS/Zoe8ouN2JUlMbwaFaP4+/WzOLW3or
	TmCu9owsxNzj3UeaWfyMrVuuZWr5z2a0UGxCF/amrNVVUOxYs1mstSxotFgIU6a0U1vrELBlh5Q
	Pjy4DR2d0uRQaTQtKm8/+r/5Zu8R71JcE9S4EGZQf5fiGeppIUCDYSzmB9zalsl10bnBORslhzX
	jvTfDX/D+7xuE5OLB7WabGW6vialA9kwA==
X-Google-Smtp-Source: AGHT+IGaKXoBp6diyWdwn+F/VLVCj4USDEs2VYPNP1DiZFcQBwDCkT+oUUbJ65kcAdN6+X/Hmc0O9YUxXFlqM7focFw=
X-Received: by 2002:a05:6102:50a5:b0:525:471f:de14 with SMTP id
 ada2fe7eead31-525471ff0d8mr1366211137.13.1756321316158; Wed, 27 Aug 2025
 12:01:56 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20250826131210eucas1p21a27a684042f37080b7a19599f479b7a@eucas1p2.samsung.com>
 <20250826130948.1038462-1-m.szyprowski@samsung.com>
In-Reply-To: <20250826130948.1038462-1-m.szyprowski@samsung.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 27 Aug 2025 12:01:45 -0700
X-Gm-Features: Ac12FXz4JdHEq3lRdfP2RTbVkNM0wK4qpK2_HAT_D7su7wtYRZ2mk-qsAVSKcWs
Message-ID: <CAJnrk1Z3xD-rOoB8T9=AFjVXx30FRoPv_qECEEBPisz1XSRt8Q@mail.gmail.com>
Subject: Re: [PATCH] mm: fix lockdep issues in writeback handling
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Miklos Szeredi <mszeredi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pqxme7bkdju6serd4mko5x14yuq61jat
X-Rspam-User: 
X-Rspamd-Queue-Id: 6ECC2140008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756321317-54165
X-HE-Meta: U2FsdGVkX19j67VBcQuu4Ha7cGvdJcntnflhup3Ynd6ZxBusOHB1amKKHg62f9ZgD3nWh37dRGab48Y/TV4AEgMGoeK8O6upC2ziWSHokjhC3tihaIEn9HNyLprCRTsc7a4/C6gnEgrKTs8iNFwy8FOEO82HymFFhcqT2aWD65mwrkfLyUbGwV4bRg/tIPgt+2SqRur+4eSpZR0i/BVoobRUZ8zlA6htIgzvVBv0tTlgLZxPHtBMzA3f46RaVj/hYWlcqm5oqpfmxCZ/JjnBnTvKvzXlPizRw0A43xVrfim8sDubwx0irvMQx1KOFhBzr/8UxI0c59ZAxCCZ6vXG/Ds+Az6RuGKcwGeQG5fLFmJyxyKbUxA7dhRiP7Ezzo+XEt269ySPLcGFdZfLCPTn7pAc39PokU9PDfXzpFe1ijfsOCcac9fsoE9XyDQ1eAvUEY1LO9XV8g+pWO5ZXh02VAluDMmXabdveNAHLSufkEm2yw74IaaDUZMcSIAt9rdHOdiyDo/fhmWTZFBIyuHEzoL520gcOYPsfyUQvh6F2/gjnaNH++riHBjN0OG/pYSwTfnU9m3/DeqQm4B6lVNNpLpi4KXZnmt/mcGUta3KQO2t2eGHvVavCs4yqpStWZTqsbQZQitpCAfXj+21MN1/MngCNVx2NHlUuPpmAb3H0u0x7Q2uAodwiYgcU9bAwcv8bexRKEaAfuxcKapuy9aao/HlS+MnXr9XxmO5ap3nesm6Het0dH16Zh3CptyP3w6G6kIgv/Ci6yMEefyALpgKpjBaud1ADrUmTfS0pnISfvg/s1bGEBRtohZqicwbCP//khbaal7HYvt+RkPBIj4ITu2FD8iAr2OoiBKR33/5AXfFc/+5zkAfv9xEexp2R4flTTvunWkmsKel7dDkgP+iC8pV2kBD5GAFgP6DlKtIWefjLGDzh+giUjHuTqEA+z1IbJ+r64yPatAuf/jAWuE
 pwFqjWzG
 IAybCdrKFicJdbWGgp1AvSNF+DMV9GIpG1nmY5yQgYmD9+CAGpJCpRBbVGpJ+OYiujWRJGFw/x7nWFV9OrIEqL33nK/lyNLcI66ED2Hg3ng8kwwlqXpokoBryQBdTtGBHA95bPdf4hUWlWpvCy7ERVcetTk3+eH107whfS701U6hrAGX+YL4wYx2qarTKytm6gwCWs6R6yXr+SNsQpG9XClIZyxkn/146WqBHgfeO6kmSSXm7o0C2/OimsS142EprUQi9xmifTMRhj4hsCZb87iLRyBqqUTp0CttXbjKhd7n4+OFJPkcS7lD7IKv3U5s4jCYb707WbFGDA/pLJTfgKEphQThYa4Wetdku968r7pPfGDd4nWOJbrFMCuhS6WqF95WdI1KcW9+OT6cGJV7HoRQFng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 6:12=E2=80=AFAM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> Commit 167f21a81a9c ("mm: remove BDI_CAP_WRITEBACK_ACCT") removed
> BDI_CAP_WRITEBACK_ACCT flag and refactored code that depend on it.
> Unfortunately it also moved some variable intialization out of guarded
> scope in writeback handling, what triggers a true lockdep warning. Fix
> this by moving initialization to the proper place.
>
> Fixes: 167f21a81a9c ("mm: remove BDI_CAP_WRITEBACK_ACCT")
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

This LGTM. It reverts the initialization back to the lines where it
was originally initialized.

Sorry for missing this, I had assumed inode_to_wb() was just a
straightforward inode->i_wb pointer following and hadn't bothered to
look. I'll be more careful next time.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  mm/page-writeback.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 99e80bdb3084..3887ac2e6475 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2984,7 +2984,7 @@ bool __folio_end_writeback(struct folio *folio)
>
>         if (mapping && mapping_use_writeback_tags(mapping)) {
>                 struct inode *inode =3D mapping->host;
> -               struct bdi_writeback *wb =3D inode_to_wb(inode);
> +               struct bdi_writeback *wb;
>                 unsigned long flags;
>
>                 xa_lock_irqsave(&mapping->i_pages, flags);
> @@ -2992,6 +2992,7 @@ bool __folio_end_writeback(struct folio *folio)
>                 __xa_clear_mark(&mapping->i_pages, folio_index(folio),
>                                         PAGECACHE_TAG_WRITEBACK);
>
> +               wb =3D inode_to_wb(inode);
>                 wb_stat_mod(wb, WB_WRITEBACK, -nr);
>                 __wb_writeout_add(wb, nr);
>                 if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
> @@ -3024,7 +3025,7 @@ void __folio_start_writeback(struct folio *folio, b=
ool keep_write)
>         if (mapping && mapping_use_writeback_tags(mapping)) {
>                 XA_STATE(xas, &mapping->i_pages, folio_index(folio));
>                 struct inode *inode =3D mapping->host;
> -               struct bdi_writeback *wb =3D inode_to_wb(inode);
> +               struct bdi_writeback *wb;
>                 unsigned long flags;
>                 bool on_wblist;
>
> @@ -3035,6 +3036,7 @@ void __folio_start_writeback(struct folio *folio, b=
ool keep_write)
>                 on_wblist =3D mapping_tagged(mapping, PAGECACHE_TAG_WRITE=
BACK);
>
>                 xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
> +               wb =3D inode_to_wb(inode);
>                 wb_stat_mod(wb, WB_WRITEBACK, nr);
>                 if (!on_wblist) {
>                         wb_inode_writeback_start(wb);
> --
> 2.34.1
>

