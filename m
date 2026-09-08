Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3241C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE0FD6B008A; Tue,  8 Sep 2026 03:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90FA6B008C; Tue,  8 Sep 2026 03:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80626B0092; Tue,  8 Sep 2026 03:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFC7D6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:29:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 093E180427
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:29:54 +0000 (UTC)
X-FDA: 85189770708.09.6596F0E
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2080120003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:29:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ld/eHomq";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788852592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TKfQxZ3gyiwirNDj+FitYX1gJJkSzXez9jKvYCt/Fto=;
	b=d3UqEPLSCLLmbGh6sFh6/C5Zljwvg4NQ1tlzvrIGt6yOGkKD2dv8oM3qVGqA5/Bhs/tX6C
	SpQmzGiPozfdtphjYt9YEfep0pxrwmDo1fonqCZePoEZgbpYPKE8wEqI61Bhr9gKshZSpY
	630JIE3CjpH/7bW0H37aGvggUAqiMCs=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ld/eHomq";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788852592;
	b=XWjRmynlLzkGBQ4SPmDybcOnr2+WahZkeTWTm8RUfwAv9xwCAJssGQeDJSu5FhKeaj2aUy
	7D8baB1zBSyGw+HwWyofCZNMR5/PeWVPSms/JLRDl1hF7sE+z4VuNKKLs74Yovm5/VXZHG
	vkueTCS1mX9GnlRLkIHLgc2zhhhpV1g=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1670dad7a8so652500566b.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 00:29:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788852591; cv=none;
        d=google.com; s=arc-20260327;
        b=CGQUTQUN63+5A2jHqMSf9geBDyvdpshb0RPeV8leb7b5YuYLi5czwxUJmkMzlhLevB
         x1WuB/i03Uu4I5bEX8eX/G6SaqJr38tDbR1Xa1AMyp1wO6uuv8VBwZeB03rANYc3BfjQ
         2OgFbhUVk8Ii4jCqhTI8IsvD0kD+1vJBcqFtXwAnYXkA4P4EF1L3NFZDLUIBM3bDPC7Z
         /PwwIk8a13z9PfaKSPLkD/iEX9sBqz6Cfu4PnmZn947QqfVMt3uOAwT2/YZVdK2NL/78
         pLuG3q09qLoBdBVm5QD/fN5ZPZJ/ecQ7R1SgJiRIiKQGwM1CC0+Y12hJUlpsV7szWq0w
         VMzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TKfQxZ3gyiwirNDj+FitYX1gJJkSzXez9jKvYCt/Fto=;
        fh=UjORM2oiJGy1rpNbSZIZoXMcmn3EGuEOMCCdMJ/tHgE=;
        b=BaQNgmxYa/OuffY0bmGaTbDHc+hBv0uZVUzKSDJWheZz+5Msy6ptcwJZBoaEWYhfmj
         GbbQ95flx3C5jpTy3eQPKVQH+siGcMS9qcJ4d+/Ibb+Fzo/kgVECq0I54hAo1xFw/BLf
         PrwrvqE7umCoCTBGbjsgOf2M5siYG4KbRROoICPj2l/exZ/hvJSN91RQCPrmbM44MVC1
         YHrU8QYVx/XWJxqdu8yOIILmIAoPFgez+l+M2Yh45tQ5s4IDRd1OyX8jgm2x8VsY8IZG
         VPjzPsvLhmG1xQxkFZ2R+BduDj21tp+vVHWCn0wREZGMTavnlN71l2yPIDyRKx5URUHi
         P31g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788852591; x=1789457391; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TKfQxZ3gyiwirNDj+FitYX1gJJkSzXez9jKvYCt/Fto=;
        b=ld/eHomqiTrF5TpJOfJ7bSs4jxDT132hBtfPNdsSm3+2BjM3Xdalqe1KR4rFoG4G3j
         4zUl5Ft5s/9+3js6juQq/0UFFEHqE750GhoxPhudqmbRKl+ADoBELvMMywa3Q1YOUFsR
         wNeGJrRznxtXvknwrjFGG/Du6HhHy/BWYE/WqcZZVOPyC6HiU7wmlD8LQNy1M1vSj9H0
         AMdg8cQcEtCZANLwDrGB/WEB3O3B+hyl9Poj0bSWZQU2QJYXvbJ9WgzkhJm5ClVoNVXE
         tX+BU4r9WLBRBSZy+slBVU5nWE1cCLXOyBnla5y/x92g0AuwL6tNLca7a9jVTikf3yPS
         KHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788852591; x=1789457391;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TKfQxZ3gyiwirNDj+FitYX1gJJkSzXez9jKvYCt/Fto=;
        b=L134oWkl+G8T0cyv/8we99Boas8Qu9kuEbk0LofheioJ05aw1Bh+ywsEBb2QiR05Bz
         gnVAgVoTPgqwX0hGRfZYieOcYed7w1skcj5BDKNmOkbTUNcWztmhWdcd/aPFKLG3vfYt
         Xj8jE7u4BooRURM6+/trXWKfRIkE+SDI+72n7dkwYKUPykqv5IHkAeQb7XzaqrrCq0dR
         LvlONP0A17aDL0bWmXb95CiH40jhHepMwo08W2O6BHc09tQbZcE1Af9yMr5Sf+8nSmus
         MX3BfF+/1i+pR5gmPJvh9aqM3NevYHNhRCfNkdVPCj+T630464GFLL1d7IQGYqMOnSYg
         s0pg==
X-Forwarded-Encrypted: i=1; AKwUvBzPUog3SY0v6SWCRtL1mp9ppygJ0kVBOSLsNW4CtcWJm5cjTuoi4084ax3ZxlAxsTZVhYie8WZPuA==@kvack.org
X-Gm-Message-State: AFuF++nJp0/ADxRdysO8CuGvS1mAUpotH/9/I4Dc+Y3rA+sOiHT0qnaC
	1o5G0xxoxdVp99ob8Zql54s6Q+3gvQ994sx2YtKxnBtNVybowllWUz8P3YhwB/Qko9HtYfQQzdY
	vnq77Q+qIGwWiR7YVs6dYZuJWWUZUWQM=
X-Gm-Gg: AYBFou33MrmUPAe5kOosVhSDwtuI74Br8+TmluMMar4k8WbByff4uzkbiQv+00svEtH
	ZyMnHM6QUSm/ic/y2ZByHG4SKQ0em45eQMKb6t2ddUZ+6ycNulwwY/idIfMUZboR/sLQbSY+mQm
	6Ei5ClKPY9lQhq21CuMVxxSpE5gVdQFa3Zsc523M6UFD/gwZ574ucpV2+vpFiEDGR6DNZIFTuFg
	lvZQgFIH86Xex3r1L40UF4n9SPSj/zOHMTJ8ZefZSag+I2aJIbEK5CLhYHXfVI+Tg1KKNRamtM8
	kHplmR25dLxPqd43f+DfZ488ivOLSpA4zgjNEHcfpi75sgwcVOcs5tsmrlMEd01SuukhOhpT987
	/yio=
X-Received: by 2002:a17:907:3f15:b0:c1c:2007:298e with SMTP id
 a640c23a62f3a-c260cb450c9mr1089341266b.24.1788852590630; Tue, 08 Sep 2026
 00:29:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260905-memcg-swapcache-stats-fix-v4-1-d3626d305d4f@tencent.com>
In-Reply-To: <20260905-memcg-swapcache-stats-fix-v4-1-d3626d305d4f@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 8 Sep 2026 15:29:14 +0800
X-Gm-Features: AcwNN1WWN5Imx29M9KWwho3-Z5IQKifWJ1tJ__QZC48lfB_vyWmh-z7xUMM4azM
Message-ID: <CAMgjq7B8ALDN1wUvFeJhPnkg8R7w6G=KzbGeO6BnCGMh_cVWJQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm/memcg: clear folio memcg after changing per memcg stats
To: bingfangguo@tencent.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: e8pes3f7fh86w1mb746by33gizgfgfoa
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2080120003
X-Rspam-User: 
X-HE-Tag: 1788852591-360921
X-HE-Meta: U2FsdGVkX197nLGbjz6Nd+XwqTomt7PCYFXTbANVCWoW/j2zuUgjPH75Dhv8/pyg0rzaW0dkUhuj7eZsoOacw2n0DDsXHlE+57RLyDlbtr+f3L4HWpJCb8g+OuudH9UIeeAoooWBgI6z7rBNxsV0BHVP83Vrp9EK9WqCTOCsS9zKAgIw+3MEI+8sqvGHGCiL5TEI2uW5R4Ry27a6U1xFYxBtpgyTmHaoCkw5l29XvfGI25viPCf/no2I1JdGWDqPXDNgu5aGkUZWFAyhsCGq9JjbSgyKTsZZkMS98rcdoWEnRdw+mu5sq9iiEsXNlJdKswMZNBO+hIklzQ2lnHAkt1ImBCaZIYb0z/nWJEO+w7AcMltRQ+1DtnH6V8/NmvbmwFmZ+e4fkNXOP3ZDDBwdw2QPM9qNf3KLP7itZZqXQTQ3OWDKG5/6868XPSpFCNuq+vk7KEpLpiOs8wZnx0QaN2i3/Jf1cTOM3wPGtohZ3gIZGDZG96CiECuSz5SYnDBVnewAl/ZljuRk2lBqfIEA85L4kf0PXhWKLzWbvUVViyv6SH//0vNc821tgw6nseqG2CPkS6XEUDNZmEY+Fw1ne7mBefplCt0k9DKKZAD0PtUTalFP3sdH7/pj+OsVRjuIu35AJTDhq0XZK78+fK4htOaFsO9CnHH+8i4AeJr98bXX7gnNCSobVCB8Kz24Ttvv80m/5uPX912dUwA2UeY3nGXd5oLZaWzfl7BW6hmYbq4ZPfuxH/ve1RzWRVDe4ZI2oWezPuF53q3o5NWblicN65N3VXdLBOSvnHQpvqDTCeXrIATNwmAje0GvwD1MTliGCl8eNangqGAxJhBbNtRvZpv7I/0oxhSyDua+SML8ebLh4PigVWg+fuL4cGLl5+c+s83dPR6WZfULFVN/xr8O1uO74Jj63cQnqjeVF5bmVolcSHvwGJzfBzwFMxx4U1n+3uwmLwQDwcKMR9wGKy7
 0sxIqF1B
 2Hj8KHTcHWn4f8wX2EZuJ7vX9nyUt4aqpqh2ieZHT5ogO4GKYqQYPVsXQRpL0nHO4i0Z9hyxV2dw9JRUubr6G6ePbELFn48qF4PLSiEg4nw+eijmWTK5c5vGukDpPNzuukra+5KDMpw/d+eVw6Yqg4Mvjyp1mwQkzu9SZfbriRKdmyo0WF9A/6PMbFf4Ml3rIXZQJAmzhtdXiV60rvaY4pV0nfEpK6o8TOILNFv9qJ39iuMOkNXlRQrvafXAXj/95+VSzPKNKVtyofZafWHyuAy6KFNZflTpXxoQCf1XFE8/dkpNpKjUN1tL7u20qEWtZe9TVWWahaP5q3iBYti2+Jf+gEAa1pJuet3XIgCWmSXr7oBE/au51k0UTy7sTbOP81FXxScOeDJnYK95aVlxgxeR7ZPli3X+urXs2ai9CFQrMmgcUmPsSL721l8z4H6vbKykFOkUZp05+2sE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 6, 2026 at 3:34=E2=80=AFAM Bingfang Guo via B4 Relay
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>
> From: Bingfang Guo <bingfangguo@tencent.com>
>
> I notice extremely high swapcached count in the per memcg level
> memory.stat when running tests with cgroupv1 setup by swapping pages in
> and out.  It seems that the counter never gets decreased so the value is
> rather useless and confusing to users reading it. So I think fixing it
> so that the value can reflect the actual swapcache usage correctly could
> be helpful.
>
> __memcg1_swapout() transfers the memsw charge of a folio to its swap
> entry and clears folio->memcg_data as part of that.  In the vmscan
> swapout path it runs before __swap_cache_del_folio(), which then
> decrements the swapcache stats through lruvec_stat_mod_folio().  Since
> folio->memcg_data has already been cleared, folio_memcg() returns NULL
> and the NR_SWAPCACHE decrement only updates the node-level counter
> instead of the memcg's lruvec, leaking the per-memcg swapcache count.
>
> Move the __memcg1_swapout() call into __swap_cache_del_folio(), after
> the NR_FILE_PAGES and NR_SWAPCACHE updates but before
> __swap_cache_do_del_folio() removes the folio from the swap cache.  This
> keeps the stats attributed to the folio's memcg while still recording
> the swap cgroup with a valid folio->swap.  Add a swapout parameter so
> the plain swap_cache_del_folio() path is left unchanged.
>
> Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize=
 layer")
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---

...

> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 305877e1f4d7..38916ea96ac5 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -306,21 +306,28 @@ static void __swap_cache_do_del_folio(struct swap_c=
luster_info *ci,
>   * @folio: The folio.
>   * @entry: The first swap entry that the folio corresponds to.
>   * @shadow: shadow value to be filled in the swap cache.
> + * @swapout: whether this operation swaps out the folio.

This reads a bit strange, I think you mean "whether this folio is
being reclaimed after swapout".

>   *
>   * Removes a folio from the swap cache and fills a shadow in place.
>   * This won't put the folio's refcount. The caller has to do that.
>   *
>   * Context: Caller must ensure the folio is locked and in the swap cache
>   * using the index of @entry, and lock the cluster that holds the entrie=
s.
> + * If @swapout is set, the folio should be in reclaim path and IRQs
> + * should be disabled.
>   */
>  void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *=
folio,
> -                           swp_entry_t entry, void *shadow)
> +                           swp_entry_t entry, void *shadow, bool swapout=
)
>  {
>         unsigned long nr_pages =3D folio_nr_pages(folio);
>
> -       __swap_cache_do_del_folio(ci, folio, entry, shadow);
>         node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
>         lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
> +
> +       if (swapout)
> +               __memcg1_swapout(folio, ci);
> +
> +       __swap_cache_do_del_folio(ci, folio, entry, shadow);
>  }
>
>  /**
> @@ -339,7 +346,7 @@ void swap_cache_del_folio(struct folio *folio)
>         swp_entry_t entry =3D folio->swap;
>
>         ci =3D swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(=
entry));
> -       __swap_cache_del_folio(ci, folio, entry, NULL);
> +       __swap_cache_del_folio(ci, folio, entry, NULL, false);
>         swap_cluster_unlock(ci);
>
>         folio_ref_sub(folio, folio_nr_pages(folio));
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 245f68c75b28..29bced43b0ce 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -755,8 +755,7 @@ static int __remove_mapping(struct address_space *map=
ping, struct folio *folio,
>
>                 if (reclaimed && !mapping_exiting(mapping))
>                         shadow =3D workingset_eviction(folio, target_memc=
g);
> -               __memcg1_swapout(folio, ci);
> -               __swap_cache_del_folio(ci, folio, swap, shadow);
> +               __swap_cache_del_folio(ci, folio, swap, shadow, true);
>                 swap_cluster_unlock_irq(ci);
>         } else {
>                 void (*free_folio)(struct folio *);
>
> ---
> base-commit: b5529903123d9535bcf74386c1f4e185e8632dd9
> change-id: 20260828-memcg-swapcache-stats-fix-1beef3dc3afb
>
> Best regards,
> --
> Bingfang Guo <bingfangguo@tencent.com>
>

Other than that this looks good!

Acked-by: Kairui Song <kasong@tencent.com>

