Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D05CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 17:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97CE8E0003; Thu, 23 Oct 2025 13:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21B18E0007; Thu, 23 Oct 2025 13:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916898E0003; Thu, 23 Oct 2025 13:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC0C8E0003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:40:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30088160BF7
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:40:32 +0000 (UTC)
X-FDA: 84030093504.01.996E19A
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3AE2F40008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:40:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lStDVYpU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=shy828301@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761241230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smzdmE7oqDk8LuIhXOJODpEUrtL1Td6tLH8AoLayyPw=;
	b=g7eMEB46PXrsWyItoHsQEd4KlHXWXrrSz0m5KVoHPrT99C7lXqBgF/aTtz77qcF0jy4xlb
	IHHTKnRUuWJyrfzLLjqq3Rhw17Cm1IwJPZbMIa0StdUIlbOkDVyQ07flO2JSg8HK8zNBaa
	G9nfVKvCypkQNNq1sl4o95yEmcRihnU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lStDVYpU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=shy828301@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761241230; a=rsa-sha256;
	cv=none;
	b=ae/2ROnmgU4OeCr6pkRnC5kkwGTSlBoWUVgw6wPojDSZnoJjF3MteHZnYMVWRoQGgCwQrJ
	theRPIMX4s4gzSz79VUtTO46bsz3RcLktk8WbU6A3GdK5RuCyQRzvobnst3UBTW3W1Vt81
	A62KKpyAS4AEbaVNbHAVUwNDSJcdafs=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b4736e043f9so216956566b.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761241228; x=1761846028; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smzdmE7oqDk8LuIhXOJODpEUrtL1Td6tLH8AoLayyPw=;
        b=lStDVYpUe6FywDMwYOawjpOoD/N0aA7d4biezqYrTyb+eTloVmM0QmAjexItkDSvBf
         /5UX4wmQ2+oOgnOATl8ea6fWSgyV73ikju4VegV2433MnAWO3Xi1zS6yzmNm3LD4wq3C
         WvohXq41MS6z0ymR/rqIAQpzuA70ZKPHA7Qy/CsWLa7HZY0b09hZaS0sjMvvDhC7HTWP
         ZuPBOqVgu1Ow4+K1Ewp6mN4FfjP2fL7Mo2d4pNlotYZCN/4JMzQ3azI9vSqbkjarSOoz
         E8uyQPCyKdDkYKsNWt5unBST7JtchVQlAzg26fycsw0fVE3C40Ny+st7krVcsUSOxUza
         rkuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761241228; x=1761846028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=smzdmE7oqDk8LuIhXOJODpEUrtL1Td6tLH8AoLayyPw=;
        b=fXAEA3OPmmdC7noE7fc/YuXc1oScJIFVImawXCaRCo6IafjvuXGAFd+K+zgreVXk0x
         goiliRNO6OneCDPnkSuWWRIM1kDFgiqbqYTqQMrVYG7bQ+tSTbjn2Ak9rlZ3CQQ5+0NW
         m6VNPltvlIJdAYN9AQM6jYTuJYWGe7NghWmc6BBpBGmqAJ3PuHMk+gNJ3gPyf0Ao1bOI
         ZBp3DzmV0RhC0DpOSMuEz63+E3DaqrLit6QQSc4956TLJsMYF4WtoHOb4zfC/7QWAsdt
         zAW/1r+aTV+R7Zx73Wrq2uyfwxlpyDRsCb8tsxaI3b4IoO9d6c0TRmn4O6SyW8hayQDp
         y/aA==
X-Forwarded-Encrypted: i=1; AJvYcCUCLjVT52wJLHcOQX0kJm9fnIlKcvwXDYtoxa8ew6NmSO5MXMBrGEzKr6PA2KwbrgxwJdH45rNJYw==@kvack.org
X-Gm-Message-State: AOJu0YxaKgjvkJJ9x2t+NAqN7cjAZVkj7Y9Fk1GLSm7yqn+g38BaVKJS
	XGKSJC1HbFjsNVtoAXx2q8V2KAFciGbowPdBGch5eZ6wbCbG3hfhQWmy/41JG9DpFT61GC5lDpK
	6nfFTHyTBFEnvEn0bV5qf97bUs3NEZ2M=
X-Gm-Gg: ASbGncubXCY1QFpxXbOGucrZLgyoNyUYyb4EsofkdPj7Nw5dl5WhWGZACJuNlRIM6AN
	41FFbQtoM30CFk793iW35V3E3oh959Np6GIguV5p2TwMbIo5vjE6jqGIbblU3db8V/YXN8Hzgo9
	61DDvE9cZYUX1AKfOikgihK8dQMkv1lDfaGx8x1TcjHWKbQsTlCkxkUQ1PCIhOR7WJjUwaXzQwF
	dTop3I+MHlY75gW8W3aTxKXzji7Ox2OTfl/pU5pnPYwntrG9KW3+OtylAhYtrfQeackulQQmw==
X-Google-Smtp-Source: AGHT+IHow1VR8JQAE5q6qgDSicvmCI1LUGpLgKgoz/cgPgRgNpbdkUQD3/ZXHjoZ0VycRm0yeeZH7AQnSl5smGqMZo0=
X-Received: by 2002:a17:907:3f87:b0:b3c:3c8e:1896 with SMTP id
 a640c23a62f3a-b6473b52634mr2763877966b.42.1761241228124; Thu, 23 Oct 2025
 10:40:28 -0700 (PDT)
MIME-Version: 1.0
References: <20251023030521.473097-1-ziy@nvidia.com>
In-Reply-To: <20251023030521.473097-1-ziy@nvidia.com>
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 23 Oct 2025 10:40:15 -0700
X-Gm-Features: AWmQ_bn3zq0uDKg6ko2JiMC7FRwDGgYYe7WpkCFUwmKJwPnSL1F1mC_HQ9WgH9I
Message-ID: <CAHbLzkqf37UpnFmQ_yZqZmWAa5X72JgFHsyUUBcyP6Pn9c3YyQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio
 is split to >0 order
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com, 
	kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org, 
	nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Wei Yang <richard.weiyang@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AE2F40008
X-Rspamd-Server: rspam03
X-Stat-Signature: 81w4y1opnocfw11mt9pxn96whs3ntfxo
X-HE-Tag: 1761241229-734041
X-HE-Meta: U2FsdGVkX19R9vWgjN4yg7wCzayIOa8Dvx6XgSXiMmEWddbLs/kXdEgepIc59RRiPu3emZdZbWOVYqsvmR2nn7H30r1zVW6hpqX5CmK2GI2CoFLSh0Da4md73yFAT+6I8hPcYdIoBh6T2P85QdMk6HsLtfWWVIj1g3OH0wmhGvzqirNjhFVX7D4Dox4UuPcXzrmNVB48zg5aucDyYGIT/b6M0+5bpcupTD+SYkhv70HaqOgsyWCKAGE5t14b4mTutJq3IGesTvZ6kdP2j00TI33LXGMNw6mVCOmRTCYnAsRapdDKpaXhUtsthCdzP6X7mHKbcMRv+JgHI4w8FfYEYDh/s0cxvczFsvppeKitONdKGCw9nM4UrsEhPAaNZZFrwcIFiuOGkKtROHkzQSSvOJcTdxL07OlmcktvzJ0Xemeotu71SEV5mGrThLi6b1X6H38TMc0mYzyLYuDFEqHx1CENxMIUq31rKlV+gwRy4Q9ZRiETBsLoVXgIfdN9bNh/dLqgamEhjKWP/QTW5meCTbQBtJxjF8ZXzkCi70CPzPxEphu76CuPu0P/Tt6rOHYBmMbzMFnhAyyuFYjgJHowPOnw9LA01zIqgmgfKNYnQ/v7xg4CpaIQOybHs1cSSG0IWp3ie4staFACju6PHvaNsKE7Z8Wo1d36cegGzmpVsznhaT36KVg6nij55JOLUyK358LljdF2eji7ayiElkSQcJMaXEdSmFwCU80QGpSy3XbtJsNOzRBMUzWMkEcM3xW1quSoaENfg9sCwDSUiVDGG9SWT864j4Y1MzL2i752h1RTmSy/PweZ1wP/jygKbEclFcOEbJiTNr8k86gjOw9LL14G99VaNirK2mNyHbliMO9NbPM/23Mfiy698T47akjxpiTF/r1CF7QNChMGHe1I94h8gllZTNrke/bevks27WQlXnxkwWrHA+F62Ok5r3K0B+Nx7KoFuzV9Gq9eMSI
 FTBwT6iD
 TlYuLcmCQvlN1Ku1ng5ebw7NuHAldngOQqXbSzZCd55eTTBF2/O+6q4N4y+Bg0VvlPUmUvQq/m+YZndOvK5AA2OmriFbaMiP5ktickxNLzdLEAd+cHKTAJrG0PxuCABegGmmNlY2WJIClR2/hu9nZt/UidTGdv/hYwmEyzFJhwnvb4l0Zmcird/9uIUF9lq4VwLkMBOB3cL2VqLBOzRUWj5PuegbgC5LAXuiElJtMjg4zDiDvGQUn6Pofc6uYUXnI76SpmBPk5gRJR8wVw5jUcJT4oalNecvbwQmDb/J7ij5sFSmXk4J8rmai25/inMNItNQLa1qkj0VaHxGiFUiUNTsq8GHAyd6WEX+Ybc+bEy+CXcnE1obsuvnOeKfad3uiDuQKtQmvLA4XsO7VC0do1tFj2ulN253P81DVlqGFeMGviB0RmZj+7+DCnMqwEcz8+i6RINxotfF4yorFwglPTYx8kJ+l6Za1ZnWqOLQ29NYk6afz/jZ95gaEqspL4HEWm4LS9y+9NQULDDVDBxIaM6rWavYycS+LjMfpkyjusPN534HqJGTuHfmOYfcJl9ZFX4Q72WrIMoiJ+/C+XutTu93xU47JJCe3XKAz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 8:05=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> folio split clears PG_has_hwpoisoned, but the flag should be preserved in
> after-split folios containing pages with PG_hwpoisoned flag if the folio =
is
> split to >0 order folios. Scan all pages in a to-be-split folio to
> determine which after-split folios need the flag.
>
> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
> avoid the scan and set it on all after-split folios, but resulting false
> positive has undesirable negative impact. To remove false positive, calle=
r
> of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs =
to
> do the scan. That might be causing a hassle for current and future caller=
s
> and more costly than doing the scan in the split code. More details are
> discussed in [1].
>
> This issue can be exposed via:
> 1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
> 2. truncating part of a has_hwpoisoned folio in
>    truncate_inode_partial_folio().
>
> And later accesses to a hwpoisoned page could be possible due to the
> missing has_hwpoisoned folio flag. This will lead to MCE errors.
>
> Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=3DcpRXrSrJ9V9=
Pm2DJexs985q4g@mail.gmail.com/ [1]
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Thanks for fixing this. Reviewed-by: Yang Shi <yang@os.amperecomputing.com>

> ---
> From V3[1]:
>
> 1. Separated from the original series;
> 2. Added Fixes tag and cc'd stable;
> 3. Simplified page_range_has_hwpoisoned();
> 4. Renamed check_poisoned_pages to handle_hwpoison, made it const, and
>    shorten the statement;
> 5. Removed poisoned_new_folio variable and checked the condition
>    directly.
>
> [1] https://lore.kernel.org/all/20251022033531.389351-2-ziy@nvidia.com/
>
>  mm/huge_memory.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index fc65ec3393d2..5215bb6aecfc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3455,6 +3455,14 @@ bool can_split_folio(struct folio *folio, int call=
er_pins, int *pextra_pins)
>                                         caller_pins;
>  }
>
> +static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
> +{
> +       for (; nr_pages; page++, nr_pages--)
> +               if (PageHWPoison(page))
> +                       return true;
> +       return false;
> +}
> +
>  /*
>   * It splits @folio into @new_order folios and copies the @folio metadat=
a to
>   * all the resulting folios.
> @@ -3462,17 +3470,24 @@ bool can_split_folio(struct folio *folio, int cal=
ler_pins, int *pextra_pins)
>  static void __split_folio_to_order(struct folio *folio, int old_order,
>                 int new_order)
>  {
> +       /* Scan poisoned pages when split a poisoned folio to large folio=
s */
> +       const bool handle_hwpoison =3D folio_test_has_hwpoisoned(folio) &=
& new_order;
>         long new_nr_pages =3D 1 << new_order;
>         long nr_pages =3D 1 << old_order;
>         long i;
>
> +       folio_clear_has_hwpoisoned(folio);
> +
> +       /* Check first new_nr_pages since the loop below skips them */
> +       if (handle_hwpoison &&
> +           page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages)=
)
> +               folio_set_has_hwpoisoned(folio);
>         /*
>          * Skip the first new_nr_pages, since the new folio from them hav=
e all
>          * the flags from the original folio.
>          */
>         for (i =3D new_nr_pages; i < nr_pages; i +=3D new_nr_pages) {
>                 struct page *new_head =3D &folio->page + i;
> -
>                 /*
>                  * Careful: new_folio is not a "real" folio before we cle=
ared PageTail.
>                  * Don't pass it around before clear_compound_head().
> @@ -3514,6 +3529,10 @@ static void __split_folio_to_order(struct folio *f=
olio, int old_order,
>                                  (1L << PG_dirty) |
>                                  LRU_GEN_MASK | LRU_REFS_MASK));
>
> +               if (handle_hwpoison &&
> +                   page_range_has_hwpoisoned(new_head, new_nr_pages))
> +                       folio_set_has_hwpoisoned(new_folio);
> +
>                 new_folio->mapping =3D folio->mapping;
>                 new_folio->index =3D folio->index + i;
>
> @@ -3600,8 +3619,6 @@ static int __split_unmapped_folio(struct folio *fol=
io, int new_order,
>         int start_order =3D uniform_split ? new_order : old_order - 1;
>         int split_order;
>
> -       folio_clear_has_hwpoisoned(folio);
> -
>         /*
>          * split to new_order one order at a time. For uniform split,
>          * folio is split to new_order directly.
> --
> 2.51.0
>

