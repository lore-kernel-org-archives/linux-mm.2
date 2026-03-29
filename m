Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE74F3D60A
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 14:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 555C26B0092; Sun, 29 Mar 2026 10:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5064A6B0095; Sun, 29 Mar 2026 10:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41CE66B0096; Sun, 29 Mar 2026 10:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3223E6B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 10:31:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7DE758FDF
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 14:31:15 +0000 (UTC)
X-FDA: 84599338110.19.74A25A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 935444000E
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 14:31:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E7jVCyjp;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774794673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/FH4BhilzNyfHQbcR9R+Ip0BSnorHXilofJaXjzXGs=;
	b=sGkLvnPk+GQb6QK2M1VJQDBVaMvWR/54LHoGrjoKRriqE2OJaEZoYaT3MYRA3uWy7L5VPj
	veMe8jbAll0wDeKo/mHZZppyr5/T5a6pynh7axnJgn97yXfXoYFQlROveGtt9VJqXZF9XI
	2TXyzTm/CKNpZdyosjFmTdVq++NemTc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774794673; a=rsa-sha256;
	cv=none;
	b=EgMX3p15We4vLVIG4zNyfzpVLGK2Ri0HKih1nDhPeRxvdpqOqzxC8+aoWshTp3nnepK1l2
	/J4HY9GN54p4JvSryC3zS26F/2vJh+JZdCBcjd1+5aSv6V5lBh43EXB3VY1NBY2jvXFlSd
	u6XmIPtTX7K+Ue7MLvYgITe5N/rjhC4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E7jVCyjp;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6478D44406
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 14:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4510CC2BCB2
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 14:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774794672;
	bh=gOpgjIOBOuUI6gsz7QgjI6lzYRGnDEdBHDus1vVt2V8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=E7jVCyjpeNP7LDzIApxMOCfueFpNZCok2XoE6+t/mFqvRHUAkeD93QpUK3qT1RvgS
	 DD+f5xmhVQYqNmcawKf8wi3eV/uvt7i81gJQ7ESk839Z6/v5slxzUyKM+adUfyL+6r
	 yO7G1sCBRTrz3LnnEuU/QzrCA/KeVz0nN9SXyCkblfV02oeG/1x8064Olsas3VzpfJ
	 pE8NSnCH6A23EnDhwYF4Te4gxl5egUQ7dqv3+YCB59i0ELOJaB/w7XzDEYCK47ADJl
	 RhnCA8r2xM6UCqqVEWVObbSQL0Ql0TwE6GAikLwhNbXYY7qlN8s6oh+d4GUwACLjVs
	 GZC89SnqLRwTw==
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-65009bfdcfdso1634010d50.2
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 07:31:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWgH3QTfL/wRiEMaPzgEZK1nq6BsyycD+FLtdWiTSYEYSRs4fJWzYmnqe0j36R8bmY6uOqJF04yjg==@kvack.org
X-Gm-Message-State: AOJu0YxpBpdTciwBu0MxDsL+P5S+Pnlp3VjplrvQumVQZ/3w6QP6RyFq
	IHC9koFYm4chma0xDQoAFrcmKdxPG22YSjfy6TSUIfbMQpbzKGVqnHn7yWVPOMK/zNBeSf9+B3q
	Gt8H3cPkc6nFqGva8TlXtxmZ4bsQDaci+CPwYzePHuQ==
X-Received: by 2002:a05:690e:488a:b0:64e:f106:60ee with SMTP id
 956f58d0204a3-64ff73ee1dfmr6543367d50.55.1774794671487; Sun, 29 Mar 2026
 07:31:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260328075812.11060-1-21cnbao@gmail.com> <20260328075812.11060-2-21cnbao@gmail.com>
In-Reply-To: <20260328075812.11060-2-21cnbao@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 29 Mar 2026 07:31:00 -0700
X-Gmail-Original-Message-ID: <CACePvbWyGF5gXXMxnm3P+8Z6qzUfG+An2trKdGqgfcoo-gohqg@mail.gmail.com>
X-Gm-Features: AQROBzBV1PuwPWVv7UY-0ulcwF6-NRzOWI35UaV-Ns8SQW6BKj2GhrqiS2Z-pbE
Message-ID: <CACePvbWyGF5gXXMxnm3P+8Z6qzUfG+An2trKdGqgfcoo-gohqg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, bhe@redhat.com, 
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: hz6y3m776zyorbh45wm6ky45bn5jwz41
X-Rspamd-Queue-Id: 935444000E
X-Rspam-User: 
X-HE-Tag: 1774794673-653187
X-HE-Meta: U2FsdGVkX18v8Xkq7b59zm2mN3cAlMqhLWXud+T0dBpxplrDCdizfGxjNxAipLl1I+JwOJ9BDDAhiznJ6+NSKEB4a6WRX0c/i00BybD9XSMiApzOBlyoBQl6SP6lAssRCl1OPmWTvEM7qsd+sp8jRUXXemdP9R3/fPZRPrtaRgT1IrRkMiACyy/kZUe1gnnYtffshTHRCY1BF+QQmpfFH7cu/ZyTaNLqLnPbP81xa3WX03sYqQOMqc3OLz7xy7U5dKfccvnPpzK14eIZKi2qWzDUh3fKUwE2mUJnfl4tDnLR7HfCz5jxFJkeN4hsGbsExWLD5ZgtVmzvsezhXXDjWzFASFYUWApDLF5cBxPhm8mOXxVmdA42/ibkDam0v+AdK4X7DdXBY4u6hV55WV1qoUQJu3sdbBXB/mgoiTogy5Q5lAj5ZvgjPyRXSXPuJyTVdyw8qSSLr9gLFF2HINVRf2qnGKGu0YWQsWR3j27fIsI8SaHp2tEegN3O+21aK1YPJ39St+bGkQyuxUZDdX7aSa30ElwU/eEvb8gfIgsrBeDID2wxCAE9AQVyGoJqSzesdKIv/+HYL6vhKRFHxbrHhLX0+ftrkCA5rlcEu8taoXlADLajHQQNGz5ngj7WQYNUPSMKKhRtdvDlsZU25eSPABj5ME1/C0z8dXvLjrNCmmIDvGugRAezIlllCBilK2iniaWb/2SlmEdVLihVGDosJufiWHbY9IXiC4QBOCTv7b1rqhbPyUfnUd0JogL9gkiPV8UXs0I8N0tTh6GCwnFx17ln8+3pSEI1iLgc2HPiv4ac0psWoGdjXC5s9nTBZxjJGPEHZlMPRWYESV+tVfLuqhWyemgBB7Mnkm0BnUjAl0n9x9aiOeN+r+vmmoTWkQAAZr0UWA0pLCQIIt2s/dmIQJ5Q/1zi8ntZ1QJBzSrQniMInhXo+ZqNehAn65lxS2SJxW34TuBNzJUAC37MeUP
 kB8ktPr3
 ea/Hs9FrXqc1ZyOI4QDSfD0TEoGirqZIksMbPzxefy8JbBH8dojB5+rl4iv4ltYmObwIcIcOiBmdD0Adlnv1OmeX2bS9KeKwMiEXwE8yEllCwPZAngGFZmPGHIHxgIBVOJdl9kb+XZ10/3cIq1o9S1JZPSrxIGAGQO8JFQU1gLzWv74I3lVJPH/ebQzh4pENKeMopa4kbIDCdvMclWYgSQjHmlqfr7og9XGmmP3C63AhZpd/826FC9IKIFATk9TnUqz68hkkQbTyV7WNuAKZ0lYvFeKjNvXbfa9ZBoDl5beKxJzeoeXVcUwAtyuUB+5wZjdo9d56E7q7XPtqCYnwfStjW4lJFuQyT6A7CrDlApSswViTomEPzfbvwQr1PQpCjCjRfGvzfiy55y4NSeEFxxCLwautYh0tJbAS3j3Uu4TrkJ3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

Thanks for the patch.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Sat, Mar 28, 2026 at 12:58=E2=80=AFAM Barry Song <21cnbao@gmail.com> wro=
te:
>
> From: Baoquan He <bhe@redhat.com>
>
> Codes in mm/page_io.c are only related to swap io, it has
> nothing to do with other page io.
>
> Rename it to avoid confusion.
>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Barry Song <baohua@kernel.org>
> ---
>  MAINTAINERS                 | 2 +-
>  mm/Makefile                 | 2 +-
>  mm/swap.h                   | 2 +-
>  mm/{page_io.c =3D> swap_io.c} | 2 --
>  4 files changed, 3 insertions(+), 5 deletions(-)
>  rename mm/{page_io.c =3D> swap_io.c} (99%)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 16874c32e288..bb7c1031886d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16915,7 +16915,7 @@ F:      Documentation/mm/swap-table.rst
>  F:     include/linux/swap.h
>  F:     include/linux/swapfile.h
>  F:     include/linux/swapops.h
> -F:     mm/page_io.c
> +F:     mm/swap_io.c
>  F:     mm/swap.c
>  F:     mm/swap.h
>  F:     mm/swap_table.h
> diff --git a/mm/Makefile b/mm/Makefile
> index 8ad2ab08244e..a65ac900096a 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -75,7 +75,7 @@ ifdef CONFIG_MMU
>         obj-$(CONFIG_ADVISE_SYSCALLS)   +=3D madvise.o
>  endif
>
> -obj-$(CONFIG_SWAP)     +=3D page_io.o swap_state.o swapfile.o
> +obj-$(CONFIG_SWAP)     +=3D swap_io.o swap_state.o swapfile.o
>  obj-$(CONFIG_ZSWAP)    +=3D zswap.o
>  obj-$(CONFIG_HAS_DMA)  +=3D dmapool.o
>  obj-$(CONFIG_HUGETLBFS)        +=3D hugetlb.o hugetlb_sysfs.o hugetlb_sy=
sctl.o
> diff --git a/mm/swap.h b/mm/swap.h
> index a77016f2423b..161185057993 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -214,7 +214,7 @@ extern void __swap_cluster_free_entries(struct swap_i=
nfo_struct *si,
>                                         struct swap_cluster_info *ci,
>                                         unsigned int ci_off, unsigned int=
 nr_pages);
>
> -/* linux/mm/page_io.c */
> +/* linux/mm/swap_io.c */
>  int sio_pool_init(void);
>  struct swap_iocb;
>  void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
> diff --git a/mm/page_io.c b/mm/swap_io.c
> similarity index 99%
> rename from mm/page_io.c
> rename to mm/swap_io.c
> index 70cea9e24d2f..91b33d955e63 100644
> --- a/mm/page_io.c
> +++ b/mm/swap_io.c
> @@ -1,7 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - *  linux/mm/page_io.c
> - *
>   *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
>   *
>   *  Swap reorganised 29.12.95,
> --
> 2.39.3 (Apple Git-146)
>

