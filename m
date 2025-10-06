Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B815CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A9D8E0025; Mon,  6 Oct 2025 16:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6124D8E0002; Mon,  6 Oct 2025 16:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527E28E0025; Mon,  6 Oct 2025 16:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4191C8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:08:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04F1A45856
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:08:26 +0000 (UTC)
X-FDA: 83968776654.30.BADDE9A
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1FD241C0004
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:08:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ud3DDy5J;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759781305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmmRVTJ6LWaGlBTe1WVKHlMgps6ILABVMan5EjARFG8=;
	b=Bxrwe7gOa9dncWTbwuYf9yfNOnptgS/3WOGQo2mxsN8Y3juwVjybsU7OiBHVmbqHvX90r6
	NTK2u+zcRpMCtTdjdd9bM8gIexsptPJFxBtPDJknHjWFkw0/dm8qwwZcClvb6CqQGc205M
	4mGEPdlLqVacOVjrocvO4m5EcfMts6k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759781305; a=rsa-sha256;
	cv=none;
	b=gFZuoMxRq7TgWpJ6Ep9MoV8D/VfUmRoqNW4cSjIOR03kxJsRgQiZx+dvlH5iWvfziduqua
	zghAdlVqUc+t3QQPkRWUT1n0oGFtUBjdh/MsUtVJPfkatMhXuWv0P6yextXs1Su/6BJ8a9
	pcUyKiUVgCcUaFmVmb7jO/12S3nssuA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ud3DDy5J;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b3dbf11fa9eso1000767266b.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 13:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759781303; x=1760386103; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vmmRVTJ6LWaGlBTe1WVKHlMgps6ILABVMan5EjARFG8=;
        b=Ud3DDy5JXYylUJ/OTyGE1yQ6zfgPEhMcHxAENcPhP7SHs5MPw61MpfgDbTpdfMxw6f
         lVA6Kp6quvzvVugty4RckIl0MvPYAj22tBN8TkFc2vTCqtMosA1SkzYMg8/N1Gd9PkGs
         g6Q3EiGYXsjejP0KNd9s/pjHkS6rcj3ZlApfnjzA55uGmemi67WKfZ9CozKNWi+mvCSM
         0v3ZIfIYfqUeHETaEy24SUt45oM6n4k2TTIqO24U2bVo8j6HD4XuflLHTOSHuoCr1S+o
         tukisTu/FGB7ouW8hwn4UxeGD/pisyh6Nyrum9zZag/Ub5nnkyy4QWZgFAAGe3zC4AUH
         dK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759781303; x=1760386103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vmmRVTJ6LWaGlBTe1WVKHlMgps6ILABVMan5EjARFG8=;
        b=aTVpQAclKwnSy65/Ddd7B/kqMkss3psrKOnNzhNI5q/mzHAzRaMoZ77c9Cu+xPiCE5
         RM2ntG61oERWn+RiXhIZZGSly+s2YpUcBrcS4vzqSHVnr4DB775tbjrKYyAoE94Ujbdx
         g6mKPL9CmrjnS3ey3QcoD8gHym/ABQb8S4KOah/WoGVmrSlFdDGNQkQvkAUGX6P/+1Kb
         13wn6SLQUzQqQYuMG6bazecPRcM/14JVa3BDiHYBFnVUSpZPMYZFthbOmpuKSeXnbd+8
         hR+K/ro5WzvVZyk9xQIi4+WumH1Lhqgb/DiBpxJoVXBTrUoDn6Lkqv9s+oD1u/DA5m/H
         X4rg==
X-Gm-Message-State: AOJu0Yz8mAw5HVXTCTl9zXR06Qr1nKtHgoVhqMJUz0IqVrVzZaJxlhiX
	b+a6CgNimKoV/dHitAw2huDjckEkcPqlPIDPcjsroYnUmtK1rXTNuFRhlpEBhzYzaYGTg49GFOT
	PVR/RnE6sV/HI8OurufZpYhsGZxwKLfH9HsYK7rc=
X-Gm-Gg: ASbGncu8MgcOyVyxygBXoHRdERheBMtaJRvl3cl+3qSn49i54FgKQxix3lP0qFc0wgL
	V870GURbIwUDBAcN6T6Ztq4+LxvPp1WHHtpRy2iDYarSfjRpZvcQHjaCYFSV+akkzmMDe3arkyi
	N/P6mg459k7rjNI9AFQBKXI7G88l7HqrbfnR23FvIR3LrCaJeJmpeINmoVJbyW0GpdMmEF7RTZG
	IZUakqIB0yPyMhdt2hUEjS1FVB8gi7knnGUyFwDxe0=
X-Google-Smtp-Source: AGHT+IEeK0yvKgA3yRX6cpZcTle/prdKxJd1FL6NEA99yvjPvuyT/DRTPlo4tjAqTzPUUdmSJQyo6pBhEUR417tWZxc=
X-Received: by 2002:a17:907:3f8a:b0:b2c:fa41:c1be with SMTP id
 a640c23a62f3a-b49c408771fmr1693598466b.61.1759781302586; Mon, 06 Oct 2025
 13:08:22 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-3-74860ef8ba74@tencent.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-3-74860ef8ba74@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 7 Oct 2025 04:07:44 +0800
X-Gm-Features: AS18NWBjexQzd2EnwnZsGO_L9oSPyUVK26LnGcJddL_wP6CJUXM0pYl52btN_7Y
Message-ID: <CAMgjq7DGy_ZmPqcqUO6s5BN381Zuee_g3KWjVqM3amLhpwE=2g@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm, swap: cleanup swap entry allocation parameter
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Ying Huang <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: uig67q4gz9wfc8fjjzuutchrm8smg33j
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FD241C0004
X-HE-Tag: 1759781304-246732
X-HE-Meta: U2FsdGVkX1996PSQH6L2DFhWQvPCY6MLczb11ArangYkGE2KMACM9/zBMGm/IYvyBDMN/xMgUZSZDZgm4u15AudDxWYwGERHYgek5FjXkhy2saBpNfJadvlD/mAxW7APnx0Rn9bmhJRciUEgyI4u9oFmKRyTTAbDCLjk+SeCGeUKH9ysDduT4BHdkqJZI92iobCi8W1c/WUDAw7vDMwz6OrA6fA9oHBCiQFpkbXlCeaZiFmJh0PqOyhXnAf6YqfWTQKZAym3QVAVYbQ/ZJibN5jytRn+go1p/RwwHPprzOQzv/mA3QjUytT2Ouu8QHIhTf55CR3WCzLEiHtdm5oDMsDKDxKN450Onc2e/c7hfaLwXa2/7wE7siydtbfCUcKoFniB8YwBYjftJJgjpd6CkOWQHchLb5I9JD7AlZQhTY0/JAnTpbYBzXVl8hE+tpLKXoTOdGSxGDvnkW8R8Ei9HVRPV0p81lLTeQPTdagy/O2TzpOPyDDq8S7wI0bjQWU89y7NKsQNQWwT/JdtSPyYovvxmakfh7+npsdswLaxmypGfsL84iRoTMCIWB87yv/pLAhRlPV8qXT0+v5cfVmVcf28a7BeDRJnjY2bGsYZV+shWf+TNVtwJgI2pzRGgi11mhZ4XNAbiYx87UqHEMSCCgTokvz3U3SD4HrTlXDjDSIfZCrsVa6ETjNi787EcPoULRVoX+/uky4KXFiUuXo1B138SFNLKT56GRT7ob29tN8K2Dcn4xFk6g0P4mZm9kmYeVBUj5PF/1twKlDAUpqPgV/Zm1HG0nM5qEM7ChoyP6UmSrxARLl/EXPIaKjAMby5EoMFjWnFnu0kyHRRtnDSnqnaqRX6JaQGTe3QSZ5pP39QWktKPKKB/59Fc4N/CiYIXcsfOsK8reCA1Z26wH/pHU70NEsxRF4mlAq8sqwrwGKcvu75c3PiTUha9aIPvJbw9QeXlF8Fy5duiRm/Yqi
 +qVudDdB
 nGbeQI08+CoeTwPHXllIaCxTNrmuZTRnzi56nF7DgB0UkW5RPatsRkSzjuvM14oBw8/C9wum07GDaGlAtDnSfDpgrqu8EBv7VYmJyLtlYbcblbnfeRTiauy6+7hAW4xARBOGkuRpb/t/YKEus9LK2mXUBuE7PT1aUJlP9U9NUwB88Oxlfth8sYz/yWfz1Vb5ynpEaukFO4NK9dVMklpjYLlVL5RBJxLxEMadDtwwKFTksAKW65DkA/bc7gFw3W/wY0UlQ2/5KCbjX06nmDjhaurQ++XwRN9cv2ZHc0jw5uva+8qiJJZjV4Mo9F23f12d8X986b6c7ZXbgWiE0/Rny6o7O+RzHqOf5ZFaTygYx+mjHKJQ6oV5oWCjX2MYB0MLAr0cRmnOe0t54cCuEFNgxZtnXpV4hcQIdQHiEiLV/ivJe54Cnv3XW6pLqtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 4:03=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> We no longer need this GFP parameter after commit 8578e0c00dcf ("mm, swap=
:
> use the swap table for the swap cache and switch API"). Before that
> commit the GFP parameter is already almost identical for all callers, so
> nothing changed by that commit. Swap table just moved the GFP to lower
> layer and make it more defined and changes depend on atomic or sleep
> allocation.
>
> Now this parameter is no longer used, just remove it. No behavior
> change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/swap.h | 4 ++--
>  mm/shmem.c           | 2 +-
>  mm/swapfile.c        | 2 +-
>  mm/vmscan.c          | 4 ++--
>  4 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index e818fbade1e2..a4b264817735 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -462,7 +462,7 @@ static inline long get_nr_swap_pages(void)
>  }
>
>  extern void si_swapinfo(struct sysinfo *);
> -int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask);
> +int folio_alloc_swap(struct folio *folio);
>  bool folio_free_swap(struct folio *folio);
>  void put_swap_folio(struct folio *folio, swp_entry_t entry);
>  extern swp_entry_t get_swap_page_of_type(int);
> @@ -560,7 +560,7 @@ static inline int swp_swapcount(swp_entry_t entry)
>         return 0;
>  }
>
> -static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask)
> +static inline int folio_alloc_swap(struct folio *folio)
>  {
>         return -EINVAL;
>  }
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 45f51745ad88..63092cc0b141 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1617,7 +1617,7 @@ int shmem_writeout(struct folio *folio, struct swap=
_iocb **plug,
>                 folio_mark_uptodate(folio);
>         }
>
> -       if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GF=
P_NOWARN)) {
> +       if (!folio_alloc_swap(folio)) {
>                 bool first_swapped =3D shmem_recalc_inode(inode, 0, nr_pa=
ges);
>                 int error;
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 732e07c70ce9..534b21aeef5a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1425,7 +1425,7 @@ static bool swap_sync_discard(void)
>   * Context: Caller needs to hold the folio lock.
>   * Return: Whether the folio was added to the swap cache.
>   */
> -int folio_alloc_swap(struct folio *folio, gfp_t gfp)
> +int folio_alloc_swap(struct folio *folio)
>  {
>         unsigned int order =3D folio_order(folio);
>         unsigned int size =3D 1 << order;

One trivial issue for myself, I better update the kerneldoc too...
sorry about this:

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 534b21aeef5a..0c2174d6b924 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1417,7 +1417,6 @@ static bool swap_sync_discard(void)
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
- * @gfp: gfp mask for shadow nodes
  *
  * Allocate swap space for the folio and add the folio to the
  * swap cache.

