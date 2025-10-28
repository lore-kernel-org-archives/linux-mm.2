Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 060CECCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5395780174; Tue, 28 Oct 2025 12:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA198013F; Tue, 28 Oct 2025 12:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1CF80174; Tue, 28 Oct 2025 12:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25A138013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:12:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7F861A0508
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:12:18 +0000 (UTC)
X-FDA: 84048015156.11.546CDAB
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 99550140007
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:12:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xeW+RZdi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=almasrymina@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761667936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qxRI++0kUA4C88E54g3jys1xp+GEI9qFS2ZGVb0fFIA=;
	b=aPZv4/EoMr959ugy52V935Wv5/ODkcyN5UfvUr3bGofE71qSCb67EPe78UmmGEBSC+na27
	xPPsR2GxSsJ5dIH3Y/ib2+v2Fn2pxgPgNaWySHJ6YWo94nyRfFMYhy8Db+/n9jNsGZeibz
	DfDRsT5vg1sZQ7K7JZYlE+sEpEJe72Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xeW+RZdi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=almasrymina@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761667936; a=rsa-sha256;
	cv=none;
	b=r5loZFbllJAL5EcqVQYxYGYeqIS6Na6RpOMFXfcnE19k/oUthcJ1N/sGoKPW3OSxH9XBdy
	O0jNY4lvo38HEHkNgNlNDrfHTNPOdFOpAWKgwNVuJV94K1PhGB/59OwCyE7rOZlOcDiNU+
	1jYY1jdi0iNJTRelt7R08vbHgY294yg=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-58b027beea6so9390e87.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761667935; x=1762272735; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qxRI++0kUA4C88E54g3jys1xp+GEI9qFS2ZGVb0fFIA=;
        b=xeW+RZdiQQoZEpFYTZMdbx2nw6ZUH/94uioDIBd628PSP/vl5Jl9AzFO7RGBgd2tSL
         xceYdeQqpPskn5gvovYapFY9Kut+RNDbodgdH2hqlFnJ7kCF4sEx9oK5IzUCScffraIo
         f9EowqUNDPCm2IVZmGAK59x7ctDZRr729kcuYuBKS5Er2IcALjnUnOE9cFkR4wCZAvyd
         NI/WDrPTIvMPXmGG4Kq/PLMzf5Elyz+wwXeVD1cA18P3F+/mQELN3BvjX51sKHHxSxd/
         k9Xaj8KAq9u5jvtpFjkoAy3hb2tuL5S5UI+Zrt6Y80H8V0ezEP4WHNoV5qY0ZTW29xJh
         CXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761667935; x=1762272735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qxRI++0kUA4C88E54g3jys1xp+GEI9qFS2ZGVb0fFIA=;
        b=Z1ttJahui6nIgjwwRBJbaBQV1lF6H9z+ubxjjlXGDLOdtp66gcNIU3NwmmFTOuW313
         N5z2C8KjQT0k6f9qW88crJsOCu7K2q3SiJhY9PF1j6GFXuBw2+/Whzfg0kxu6zLNkVhn
         pcJXhzM1dyWlxCmaq/xjDJEZBXHMHfBMgawh4UfUfDWS/v3hwCo8AGrmwTfe/YNcygtE
         guaciRY+yin+aPUEd5dbHxSe1u9BGO/nvFXOJLO3C4yjUQrj0i7PP/b7kBne6Kekwmk3
         xpgV0AD/l7WnKik+l5TR/0C9yDWjSwnBioj4yGMP98sQ7J7HZr5qAPioG+uJt5ZjjOq8
         oxLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlaGD4l4EbW1nQW3Syy0EKXgZRcyuQJgQKSkg8eZKBf0XSFb3ncXzRLEFYWJZaiwK2zS6RMtyfDw==@kvack.org
X-Gm-Message-State: AOJu0YxvQnuIcrqqtJHaXH+4smPlyh8kFVxkSuY3CJC2YZs1ZhI/8VMo
	AAwdViORITylz88qDlHmSXThP9KuH4EWnBW+Lpz1t9qU5Iqhkly4bZUUwXYpgfP2IixfAAU0ALS
	aG2OIJj9CpUim0tK391FTVI86vPizGf6zLbQXC1XL
X-Gm-Gg: ASbGncv4BxROJ3SMrYg7KAaeHi6L3L0hri/c2WLiIE+W8pVq/KqBtFy1VAScq9kii0p
	Hp0FpI9j2P6SrAKuSA3mwpZU364l2O6SB0zfCXb/2b9uVUBbN9jsXSNr+if4eo/JXsmGfaolBYf
	6KSUR0SUShxAy2SO4IY4CPrZT/eM3N132DS7BvLEixNK+XsZneANxDpw26cCkSeI69Mc6ZWEvHi
	b2w8v1+eFx7/GINZy6vXChjzEehofsy15leUP1ZbiClWyOzdDxnU+Dns1acA+GwIXAPAcmesSg0
	rCMZgiF3IJFdgqbJ/+rmncM83g==
X-Google-Smtp-Source: AGHT+IGHjnuV06Q110K/XiF/19HksKvviTMay1daMlenEI88sIR67s4zP4V81F71auWP2H80fovhcnl0+5UV0L8pGUg=
X-Received: by 2002:a05:6512:b84:b0:586:8e3c:9456 with SMTP id
 2adb3069b0e04-5930eed566dmr430517e87.0.1761667934253; Tue, 28 Oct 2025
 09:12:14 -0700 (PDT)
MIME-Version: 1.0
References: <20251023074410.78650-1-byungchul@sk.com> <20251023074410.78650-3-byungchul@sk.com>
 <CAHS8izME4W3ENXNXf4Cxegmk9xnRmKajpRMQ18L0=FGTFebeaw@mail.gmail.com> <64E18E02-727B-47C4-8849-486AB98CACD8@nvidia.com>
In-Reply-To: <64E18E02-727B-47C4-8849-486AB98CACD8@nvidia.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 28 Oct 2025 09:12:00 -0700
X-Gm-Features: AWmQ_bmxv3BL-tBNLLwsdAEGZyVMyLK1NK7F8-nJ_Ys_3boWKRkq5vfhkylVKmE
Message-ID: <CAHS8izNuSkxn1HZJ-1W_wa7QsQFE5yKUjbfSgKEzv9tLLOYveQ@mail.gmail.com>
Subject: Re: [RFC mm v4 2/2] mm: introduce a new page type for page pool in
 page type
To: Zi Yan <ziy@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com, harry.yoo@oracle.com, 
	ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org, 
	hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com, 
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch, 
	edumazet@google.com, pabeni@redhat.com, akpm@linux-foundation.org, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org, 
	ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org, 
	kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com, 
	baolin.wang@linux.alibaba.com, toke@redhat.com, asml.silence@gmail.com, 
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, 
	dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 99550140007
X-Rspamd-Server: rspam03
X-Stat-Signature: xsragob9odbzzbroyjyuwpu4hyj7o949
X-HE-Tag: 1761667936-465450
X-HE-Meta: U2FsdGVkX19OWlcS5U6nLxdaDikGqQNmHiiv0cGc0Iiszovp8QYZAgYH1K0WEYfEEDO0ian2rC+eIxy3faAZ4xvsDkxv/T7xmN+DU/RCRAjx6wnly+jw0W+vGGk1s2+6jeLer9Nd4n23EpaTTgsU2BiOPAZdWHChPjfhAw9MngWD2kVmOdKlAt6f8yET3ljuRIMaV1qOQmWjNJ8mrA/0r2aaKUPYTwnM2bbkQJ+lvyZRhuaOvCJ5/5m5llI+GfT6qVALgDc6Na6YclGYYhE/LEvJfe0tpzsgdIMJqCxFbv3UJyesmDvfqa9BT5uI3/ls8SctC4jpE4If6NOJM8dWMHxYDY+m3BnSCMT3UXsXTrSBiOAfvog4fKUtMBCUjzV5jwvg/C5IC9y+H2ivqYkHDggcIDrlUOqIYpEGfVrd4xBCg7LYwQybpG4ibhWESN1RfGBpG4IApb4J02jBK0nKtl/kHQs9TxfXmPxz1cPNp1SlGporMf7fXUXvrLaVjaSeNMSnt2iuADA/6J7hmhylu5RCwuicyBfuMzEQlJlwh1LXJg8hDqUTpuGqWwKfKfr1Tv13BO3HFqUJ0V//5ZZ/sYH+deG6WzsvDS8JUvu0ZVJ+DvZ5MmecWEak2J02aJ83zpW5tb765L/LyfzfeHL/hgcShgAgEawpl2ruUymus+0cDWtpmPCLr2m8ha6mTYC5NPsq630gNzk/t0aOOJTpKchePGImDyWPI0C/XKQ97dKRigRR/sF1Kuq0ftvRna0pgzKNqBpopbd+seaN8mnGq1z6F1fGGyEeJlaBdxCHD7jprAxQprJ9Smejqo8KxkoinOMl7jyWxwIlzcjB3mq8d3GRJoacI6Dwi9Hp2wb2YE41HZ29jhzkHSAlhLbEXBXTJQ+Rz+ObiJOldTjiLVA2nlCXkIm0xYZsvOG+S2LXEJtxhcQwQ63Vr4kf5GfVpWizo7Wf28sLDHNnpxee0tC
 QsHDo2iz
 sd35iUDCu3O94Ivz8f3aXm6dgrjQ9tGWshDEHLuX2YpVwQerzh7thaNtaRMZpNaRei1XagKdw8XwT8PCeTytob+STCdPgMSob+OCU5HOxt6vP84uVMNV5kxk02nv+0jzRndSer4MMwDnsIO9SvrWcf5+AQ5++7Boh9Nuy/hMJhZDCTtRIrQtn9DOAhBrKdGyW1+hgKBnkJWxhsacnX3VDlyh0L1P1USKibVjdYcaIsVogjn+AMJR5XHKSW8EFtse3p0sfeBIngrCmeEJuFLmOHBYJpP7EKW957Bia3iik9jmqn1UKTKuo3MvK5MS/1IkFQvK1FJ27JuecYG4xnxoSBylkAhxElQoORQbAuIwtzgjQcxA8O7Fwl7TWHXWevDt3htIGyy3+UO49RX8LooN5FQEWl1A2PMq6NieSEMfdGEJsGeDrtkBYCVnqRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 6:45=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 27 Oct 2025, at 21:28, Mina Almasry wrote:
>
> > On Thu, Oct 23, 2025 at 12:45=E2=80=AFAM Byungchul Park <byungchul@sk.c=
om> wrote:
> >>
> >> ->pp_magic field in struct page is current used to identify if a page
> >> belongs to a page pool.  However, ->pp_magic will be removed and page
> >> type bit in struct page e.i. PGTY_netpp can be used for that purpose.
> >>
> >> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(=
),
> >> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> >> ->pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> >> netmem_clear_pp_magic().
> >>
> >> This work was inspired by the following link:
> >>
> >> [1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@g=
mail.com/
> >>
> >> While at it, move the sanity check for page pool to on free.
> >>
> >> Suggested-by: David Hildenbrand <david@redhat.com>
> >> Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
> >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >> Signed-off-by: Byungchul Park <byungchul@sk.com>
> >> Acked-by: David Hildenbrand <david@redhat.com>
> >> Acked-by: Zi Yan <ziy@nvidia.com>
> >> ---
> >> Hi Mina,
> >>
> >> I dropped your Reviewed-by tag since there are updates on some comment=
s
> >> in network part.  Can I still keep your Reviewed-by?
> >>
> >>         Byungchul
> >> ---
> >>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
> >>  include/linux/mm.h                            | 27 +++---------------=
-
> >>  include/linux/page-flags.h                    |  6 +++++
> >>  include/net/netmem.h                          |  2 +-
> >>  mm/page_alloc.c                               |  8 +++---
> >>  net/core/netmem_priv.h                        | 17 +++---------
> >>  net/core/page_pool.c                          | 14 +++++-----
> >>  7 files changed, 25 insertions(+), 51 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/driver=
s/net/ethernet/mellanox/mlx5/core/en/xdp.c
> >> index 5d51600935a6..def274f5c1ca 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> >> @@ -707,7 +707,7 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdp=
sq *sq,
> >>                                 xdpi =3D mlx5e_xdpi_fifo_pop(xdpi_fifo=
);
> >>                                 page =3D xdpi.page.page;
> >>
> >> -                               /* No need to check page_pool_page_is_=
pp() as we
> >> +                               /* No need to check PageNetpp() as we
> >>                                  * know this is a page_pool page.
> >>                                  */
> >>                                 page_pool_recycle_direct(pp_page_to_nm=
desc(page)->pp,
> >> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >> index b6fdf3557807..f5155f1c75f5 100644
> >> --- a/include/linux/mm.h
> >> +++ b/include/linux/mm.h
> >> @@ -4361,10 +4361,9 @@ int arch_lock_shadow_stack_status(struct task_s=
truct *t, unsigned long status);
> >>   * DMA mapping IDs for page_pool
> >>   *
> >>   * When DMA-mapping a page, page_pool allocates an ID (from an xarray=
) and
> >> - * stashes it in the upper bits of page->pp_magic. We always want to =
be able to
> >> - * unambiguously identify page pool pages (using page_pool_page_is_pp=
()). Non-PP
> >> - * pages can have arbitrary kernel pointers stored in the same field =
as pp_magic
> >> - * (since it overlaps with page->lru.next), so we must ensure that we=
 cannot
> >> + * stashes it in the upper bits of page->pp_magic. Non-PP pages can h=
ave
> >> + * arbitrary kernel pointers stored in the same field as pp_magic (si=
nce
> >> + * it overlaps with page->lru.next), so we must ensure that we cannot
> >>   * mistake a valid kernel pointer with any of the values we write int=
o this
> >>   * field.
> >>   *
> >> @@ -4399,26 +4398,6 @@ int arch_lock_shadow_stack_status(struct task_s=
truct *t, unsigned long status);
> >>  #define PP_DMA_INDEX_MASK GENMASK(PP_DMA_INDEX_BITS + PP_DMA_INDEX_SH=
IFT - 1, \
> >>                                   PP_DMA_INDEX_SHIFT)
> >>
> >> -/* Mask used for checking in page_pool_page_is_pp() below. page->pp_m=
agic is
> >> - * OR'ed with PP_SIGNATURE after the allocation in order to preserve =
bit 0 for
> >> - * the head page of compound page and bit 1 for pfmemalloc page, as w=
ell as the
> >> - * bits used for the DMA index. page_is_pfmemalloc() is checked in
> >> - * __page_pool_put_page() to avoid recycling the pfmemalloc page.
> >> - */
> >> -#define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
> >> -
> >> -#ifdef CONFIG_PAGE_POOL
> >> -static inline bool page_pool_page_is_pp(const struct page *page)
> >> -{
> >> -       return (page->pp_magic & PP_MAGIC_MASK) =3D=3D PP_SIGNATURE;
> >> -}
> >> -#else
> >> -static inline bool page_pool_page_is_pp(const struct page *page)
> >> -{
> >> -       return false;
> >> -}
> >> -#endif
> >> -
> >>  #define PAGE_SNAPSHOT_FAITHFUL (1 << 0)
> >>  #define PAGE_SNAPSHOT_PG_BUDDY (1 << 1)
> >>  #define PAGE_SNAPSHOT_PG_IDLE  (1 << 2)
> >> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> >> index 0091ad1986bf..edf5418c91dd 100644
> >> --- a/include/linux/page-flags.h
> >> +++ b/include/linux/page-flags.h
> >> @@ -934,6 +934,7 @@ enum pagetype {
> >>         PGTY_zsmalloc           =3D 0xf6,
> >>         PGTY_unaccepted         =3D 0xf7,
> >>         PGTY_large_kmalloc      =3D 0xf8,
> >> +       PGTY_netpp              =3D 0xf9,
> >>
> >>         PGTY_mapcount_underflow =3D 0xff
> >>  };
> >> @@ -1078,6 +1079,11 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
> >>  PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
> >>  FOLIO_TYPE_OPS(large_kmalloc, large_kmalloc)
> >>
> >> +/*
> >> + * Marks page_pool allocated pages.
> >> + */
> >> +PAGE_TYPE_OPS(Netpp, netpp, netpp)
> >> +
> >>  /**
> >>   * PageHuge - Determine if the page belongs to hugetlbfs
> >>   * @page: The page to test.
> >> diff --git a/include/net/netmem.h b/include/net/netmem.h
> >> index 651e2c62d1dd..0ec4c7561081 100644
> >> --- a/include/net/netmem.h
> >> +++ b/include/net/netmem.h
> >> @@ -260,7 +260,7 @@ static inline unsigned long netmem_pfn_trace(netme=
m_ref netmem)
> >>   */
> >>  #define pp_page_to_nmdesc(p)                                         =
  \
> >>  ({                                                                   =
  \
> >> -       DEBUG_NET_WARN_ON_ONCE(!page_pool_page_is_pp(p));             =
  \
> >> +       DEBUG_NET_WARN_ON_ONCE(!PageNetpp(p));                        =
  \
> >>         __pp_page_to_nmdesc(p);                                       =
  \
> >>  })
> >>
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index fb91c566327c..c69ed3741bbc 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -1042,7 +1042,6 @@ static inline bool page_expected_state(struct pa=
ge *page,
> >>  #ifdef CONFIG_MEMCG
> >>                         page->memcg_data |
> >>  #endif
> >> -                       page_pool_page_is_pp(page) |
> >
> > Shouldn't you replace the page_pool_page_is_pp check with a PageNetpp
> > check in this call site and below? Or is that no longer necessary for
> > some reason?
>
> It is done in the hunk below this one:
>
> @@ -1379,9 +1376,12 @@ __always_inline bool free_pages_prepare(struct pag=
e *page,
>                 mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>                 folio->mapping =3D NULL;
>         }
> -       if (unlikely(page_has_type(page)))
> +       if (unlikely(page_has_type(page))) {
> +               /* networking expects to clear its page type before relea=
sing */
> +               WARN_ON_ONCE(PageNetpp(page));
>                 /* Reset the page_type (which overlays _mapcount) */
>                 page->page_type =3D UINT_MAX;
> +       }
>
>         if (is_check_pages_enabled()) {
>                 if (free_page_is_bad(page))
>
> where
> free_pages_prepare()
>   -> free_page_is_bad()
>     -> page_expected_state()
>

Thanks, looks fine to me then. I'm not extremely familiar with this
code so I won't give a Reviewed-by, but here is an ack, FWIW:

Acked-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina

