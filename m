Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CBE8CD6E63
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682048E0012; Thu, 13 Nov 2025 09:03:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633498E0002; Thu, 13 Nov 2025 09:03:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548A18E0012; Thu, 13 Nov 2025 09:03:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 445CB8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:03:03 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E91415C03B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:03:02 +0000 (UTC)
X-FDA: 84105750204.13.192535C
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id E023640025
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:03:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O4i9Cqj4;
	spf=pass (imf07.hostedemail.com: domain of elver@google.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763042581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDQvj6UlQD63iPrmSZxS8C2tXksjrqLXDzCDe6b36Fk=;
	b=DiT0mxYICCg8Q7j3xT/HUZivkrxSXq+LeTDLCvDjaQWj9dBPXSIHozFVkrjOan5sjJ04NI
	h7VdnEfsSaB46fqv+FEf1CcrMGwUQVaCQ5t/w4PBItL6wvMtf/ZfH72yHv2AcTOsKpb6CX
	DHgGPiRNDfEOAuloR9qZo5Qivb4dOGA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O4i9Cqj4;
	spf=pass (imf07.hostedemail.com: domain of elver@google.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763042581; a=rsa-sha256;
	cv=none;
	b=r2DiokwSCsFWFVUzYgZ/P2LofnE4ZbTwgN2joCTIRBvGcFibNpPBHaggm7ScXCwB0BJy+l
	oJEiU1iOoQfHG52BWTbcBUBlvhCXobxn+f6HwAhtgSot5+cruTb5iBSpR6VD0zcwII6Mt/
	meDN3e4S21aviDVvbff6pwBebASdUmU=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-63fc6d9fde5so741840d50.3
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763042580; x=1763647380; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wDQvj6UlQD63iPrmSZxS8C2tXksjrqLXDzCDe6b36Fk=;
        b=O4i9Cqj4DoFxHWZM/W2HjYDbzQaNY1otR/PfMSzUJ53m1XGjaK6YyJclD5TOuLUNsP
         QXx1348Eog6rgXR86/Uuw5W7k6xa5/AmVzHwSYkGB2urnfUbPyUPtvH1xuu8qqPaL416
         4xyejHt2Z6NosGk8g4XLRgjYgL9v1f3v6M8W4gXrMqFmU1vZhKEtK9MeKwM0aJuIxNcu
         E1mD4XTCtmx0/Z4b/wv16F/tN8Y7voRz3s+hLz5Vcin1z3BLa5TVF2J4xfy6GUUsVdOi
         kvmToCIGBaOzRAMW3u3kwaVAipoSKZFh4P3DFMXinW06YNjtzPsxJ8rH1Er2B8wqugf+
         bMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763042580; x=1763647380;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wDQvj6UlQD63iPrmSZxS8C2tXksjrqLXDzCDe6b36Fk=;
        b=RttNhQFQ4YKRxzshXw5D2ZFXv2jN6KTc3CsHl4QPXvDxD/3TF7WKmUdQQdOadrg8BJ
         x7XQbuvC9Ga1KrPw17nDUt9lVGOkfRDsoRyG5lSZDEcBJvGs78m6GroC9Osjl5SGu3Ot
         5CYoXbK33jhjf0FWRCQ3N3Fnp8IZhhLTg0kHPRmdMf/jqtSKggjwTR8lXCWVpZkBAxu3
         YDLCrGpHDd/nBJTASavQSOD1KXP60mYvFiJ+B5nzbSzY4TBLOP0dbjUe8q4r/a9rqdTQ
         ZJgVmc4lIMGmHXkQIX4779V84j9Sy8e3HQ1OfkQNfLErQvVg8R8f0f92rKRl/o7v1Zi4
         5hAw==
X-Forwarded-Encrypted: i=1; AJvYcCUk7RPoySxUYODX/s6mEE9e+wPEeu06jZn/KOzV7d6S6sx+wN3/I8Lg+UL1J17qHfIQAeR3sR/7gg==@kvack.org
X-Gm-Message-State: AOJu0YzldsIrnUBZrNQ7ChH56yXParr0Bv5w8oFM7VbXWD75sGpxowJ0
	a/dOiWKwGHUITb1Pv1Ext9jk9mvImZlZnRh78pHaw8KlI01QxM1eNwQj6SShBgxt51ySRD0OlOI
	AcRzZyFK16nqyl3nwnYDKrydkyxKgrOEihyPhgzY1
X-Gm-Gg: ASbGncuA7IVLSvgOOMuk1a0gbTlu5dFuVwxMYcrOMcg0kAITlO41iBNri+MPgf2DqGJ
	CptETz8tvuMQ+pDd6qBwIEsCi8SV1tNdcolkuNddmZz9Wx1s6rhHrpqMM0nqd/ImyjUK563PoI0
	Yr38AzuhZKHojm1l2+tarAwvjc0cjh1fkZkrYxQIh6l8d0aPLzPslpOqKVAgqg83tZlPRoizJ3i
	2k9TPlCif0hfGp+FCCusBXSDrd9+CPV17GJxRpy2dJAMCTtGmlISPERLG3J7Hoeaql4Uqc3mlZ4
	yIJhy+ZUerdwmwBhkW/MqeyscNAMunae2Q==
X-Google-Smtp-Source: AGHT+IHt2jxP4iBwSSV+9dCwXgKuOGJsjPZeB263pmUb/X8tElOzGQmvzsyaT8AmaxAOqoWt4cXDoXbRku9u5VjOREE=
X-Received: by 2002:a05:690e:4257:b0:640:dd53:71b6 with SMTP id
 956f58d0204a3-64101b011f8mr5047415d50.34.1763042579544; Thu, 13 Nov 2025
 06:02:59 -0800 (PST)
MIME-Version: 1.0
References: <20251113000932.1589073-1-willy@infradead.org> <20251113000932.1589073-2-willy@infradead.org>
In-Reply-To: <20251113000932.1589073-2-willy@infradead.org>
From: Marco Elver <elver@google.com>
Date: Thu, 13 Nov 2025 15:02:22 +0100
X-Gm-Features: AWmQ_blhJPjd2aV442pt2egpwN6npTdDWrkyJEPpL0cKMnNAOIkOIqSIOWUamD8
Message-ID: <CANpmjNMF3RSEtLNKVf4m8wMk-O4-FkdPDbunAsZ_N=h+Rc2tZg@mail.gmail.com>
Subject: Re: [PATCH v4 01/16] slab: Reimplement page_slab()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E023640025
X-Stat-Signature: u53effmwy7rxs63kj658578q66qncznk
X-Rspam-User: 
X-HE-Tag: 1763042580-387042
X-HE-Meta: U2FsdGVkX1/pGDHAPUtcQAJMsVeHHJ7xYqr+X4YoCCcEb+5VxwMScSc7UTt3RVMVgpXiiLJRQ6Z9XxxE+dLcPfyjcQMyyxuANlgUmU0+IFwyfq/mZ6IQn4gT1L0vplLyHxhJbd8Up0lBLuEAbFbVhZPGx4UVaLHNWUxsePdy8hG89uqelsBiC3CgXH1n2tpxN07S8AVQn1+NMox1t4jzoG0YB1OevPxvu7H/dNEdZ9KIEIlfGwGV6HRAmY2E5kmb+Bhx+K5zQttcAjnodQtFE3kC2KbTASTJ+mf8J/7aYc2ROyCo5DHDdGAg0BFf9WmBpLkCKAdRdxemthEktNDFkbrB7cVqD3fjkoRL1RXmWJ9/VstVuMZ88baWvr84AEfoWoWQsp9OwSFpNhxWHxgTTeRSqla7g1MIsEgUcUg9UOc1faFVd2vTI+QWkHBPgexTVaDGzDGbvaCk7WknI/vqEW9ajRdio+e+nJmBSyRDkzmdz2cJw+gzokN/coFaM02fgP4bcCGHdFtSfslYsg+sXU8tp7wkfc+HuNi8YqOZuw9dOlWGQebKtTEQ3wnY0jSBxjhM/LqfCXd13cMp6MSuEsPQikdcUeSvSQX0rWtKt1zl8nNjlrut2GpY0NoITSFGJu7TwSELaFtH0PsYKAylW5CNH+pkunbH6j4tso0KJf6EVMYscBo4Fim/t3WwIzJ9gCwl8Gu5QQrKX774814hBXemmM8bvnrj8kWtdPafAdRv8Dw2BKJp/EXwstmbjr6bz/HtmRb5/Fhv4jjPMlako07wpEIxsra6lSfoTyTtBScIaEfpl4r6qHeAN1k7HHGsV+iX42vfGPJ0Z8MWN+KnRSvpat0iCGeFX7brtkXA72nOKdkp6I07rb1bHZg4/PGAtJuoVNWCzZNjUK0uvL4r3U/SMgRW9cq54kMhL+IIU0YXv1nsYpWzCdpW7Oh5Dy5wX+SggBJQG7DGRXLMSp/
 aH9fd25V
 wnr1kDAoSnFM2obl3R627kAZ1mOIzkmLBsrivXYQdgWxUwOhK3xVCR6YavxIrVaTuUbmbgI3VE3h9T6YDSl5MYplHYpZYr6udOGrYtFDnxi7254adqtmdMII4a9mvbv1IeaZjFY/v8IYfDbRon2iIIJqETsgLMyZY5hUY373/D02iej1zTxYnJsqKjhk4rXJ+Xy1vjHYB24wTTQPxwAZRnAerkzvMWVfSBCPmL19GL85NYOwTx825YkeszT23cQdDJtHNphnZhfB5AkT/YuUMQ360ACvTcb3R92raIfoWimkXoJAzTsKdjka7/ZMNsmbz5kq6IjbTGayreS/9EpFQ4Hfqpy7+UtlEvQ6A+L9fN4jorVc3VGJh5Zrv+TfnqjSFhdWb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Nov 2025 at 01:09, Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> In order to separate slabs from folios, we need to convert from any page
> in a slab to the slab directly without going through a page to folio
> conversion first.
>
> Up to this point, page_slab() has followed the example of other memdesc
> converters (page_folio(), page_ptdesc() etc) and just cast the pointer
> to the requested type, regardless of whether the pointer is actually a
> pointer to the correct type or not.
>
> That changes with this commit; we check that the page actually belongs
> to a slab and return NULL if it does not.  Other memdesc converters will
> adopt this convention in future.
>
> kfence was the only user of page_slab(), so adjust it to the new way
> of working.  It will need to be touched again when we separate slab
> from page.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: kasan-dev@googlegroups.com

Ran kfence_test with different test configs:

Tested-by: Marco Elver <elver@google.com>

> ---
>  include/linux/page-flags.h | 14 +-------------
>  mm/kfence/core.c           | 14 ++++++++------
>  mm/slab.h                  | 28 ++++++++++++++++------------
>  3 files changed, 25 insertions(+), 31 deletions(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 0091ad1986bf..6d5e44968eab 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -1048,19 +1048,7 @@ PAGE_TYPE_OPS(Table, table, pgtable)
>   */
>  PAGE_TYPE_OPS(Guard, guard, guard)
>
> -FOLIO_TYPE_OPS(slab, slab)
> -
> -/**
> - * PageSlab - Determine if the page belongs to the slab allocator
> - * @page: The page to test.
> - *
> - * Context: Any context.
> - * Return: True for slab pages, false for any other kind of page.
> - */
> -static inline bool PageSlab(const struct page *page)
> -{
> -       return folio_test_slab(page_folio(page));
> -}
> +PAGE_TYPE_OPS(Slab, slab, slab)
>
>  #ifdef CONFIG_HUGETLB_PAGE
>  FOLIO_TYPE_OPS(hugetlb, hugetlb)
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 727c20c94ac5..e62b5516bf48 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -612,14 +612,15 @@ static unsigned long kfence_init_pool(void)
>          * enters __slab_free() slow-path.
>          */
>         for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
> -               struct slab *slab;
> +               struct page *page;
>
>                 if (!i || (i % 2))
>                         continue;
>
> -               slab = page_slab(pfn_to_page(start_pfn + i));
> -               __folio_set_slab(slab_folio(slab));
> +               page = pfn_to_page(start_pfn + i);
> +               __SetPageSlab(page);
>  #ifdef CONFIG_MEMCG
> +               struct slab *slab = page_slab(page);
>                 slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
>                                  MEMCG_DATA_OBJEXTS;
>  #endif
> @@ -665,16 +666,17 @@ static unsigned long kfence_init_pool(void)
>
>  reset_slab:
>         for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
> -               struct slab *slab;
> +               struct page *page;
>
>                 if (!i || (i % 2))
>                         continue;
>
> -               slab = page_slab(pfn_to_page(start_pfn + i));
> +               page = pfn_to_page(start_pfn + i);
>  #ifdef CONFIG_MEMCG
> +               struct slab *slab = page_slab(page);
>                 slab->obj_exts = 0;
>  #endif
> -               __folio_clear_slab(slab_folio(slab));
> +               __ClearPageSlab(page);
>         }
>
>         return addr;
> diff --git a/mm/slab.h b/mm/slab.h
> index f7b8df56727d..18cdb8e85273 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -146,20 +146,24 @@ static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(freelist_aba_t)
>         struct slab *:          (struct folio *)s))
>
>  /**
> - * page_slab - Converts from first struct page to slab.
> - * @p: The first (either head of compound or single) page of slab.
> + * page_slab - Converts from struct page to its slab.
> + * @page: A page which may or may not belong to a slab.
>   *
> - * A temporary wrapper to convert struct page to struct slab in situations where
> - * we know the page is the compound head, or single order-0 page.
> - *
> - * Long-term ideally everything would work with struct slab directly or go
> - * through folio to struct slab.
> - *
> - * Return: The slab which contains this page
> + * Return: The slab which contains this page or NULL if the page does
> + * not belong to a slab.  This includes pages returned from large kmalloc.
>   */
> -#define page_slab(p)           (_Generic((p),                          \
> -       const struct page *:    (const struct slab *)(p),               \
> -       struct page *:          (struct slab *)(p)))
> +static inline struct slab *page_slab(const struct page *page)
> +{
> +       unsigned long head;
> +
> +       head = READ_ONCE(page->compound_head);
> +       if (head & 1)
> +               page = (struct page *)(head - 1);
> +       if (data_race(page->page_type >> 24) != PGTY_slab)
> +               page = NULL;
> +
> +       return (struct slab *)page;
> +}
>
>  /**
>   * slab_page - The first struct page allocated for a slab
> --
> 2.47.2
>

