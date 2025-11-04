Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29BB4CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 03:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EDAD8E00E4; Mon,  3 Nov 2025 22:47:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5AD8E00DC; Mon,  3 Nov 2025 22:47:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5022B8E00E4; Mon,  3 Nov 2025 22:47:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3ECA28E00DC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 22:47:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BEF23C037F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:47:49 +0000 (UTC)
X-FDA: 84071540658.09.23A695B
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 04D2480004
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:47:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X1vQE1wl;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762228068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0pa7WeHz47MLgq+rdOSlkeWgaQxlJG3XLSzMhA+sBw=;
	b=7zbb4WOCIqSx1Z8BdS4Znmm/LOV+67CTiKa4N30+lMPS3yLWqp8k71LxorvCjWQXEKsj86
	9ohkYv/p8+tEJUIlTmRxr9FHV3Qxh380t+1/qyI0M8ufdlbEpGQTngIvQNpCImKPfXlDpp
	oriDQlVR7tc8JV28+Ac3NcRkUr2rHFo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X1vQE1wl;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762228068; a=rsa-sha256;
	cv=none;
	b=Q9R0wRMZE25AK9Z0GstpKWnr70q/inOXTCQoRSfSOv+m8Lsu7ZRXTRH17ioHfxAKyv3MO/
	zR+WnjdRI2NxPJ6qk6DtJ+aB3e/UmbqSLD/DXpGdY9qC44oWlOR/knb5FIP6goASGUY285
	iDtRCLBnwMZRy6mI0//+zRg61eMUmD0=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8a074e50b41so681962185a.3
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 19:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762228067; x=1762832867; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i0pa7WeHz47MLgq+rdOSlkeWgaQxlJG3XLSzMhA+sBw=;
        b=X1vQE1wlL+o2uMBgcp2/yAKr+R3LaD+f9YwM5dmTWiUfiDZWA7Ppma/tuoNhtFySxH
         RQM1PyHkPgI00wKh6zJotoCkJLgi+GowR3TGX9CMLlHkiNKCCuDbKpwNrK/qWvZO59Xv
         z022DBzwyMRZNgcKkKfE2ffLV321DNb6BvfjBCc0yZYOX742HLT3e+oOBM9oBARxMOfI
         GgqdTO+gV9a929YsuKJEsZHIX9HLeoi0pEq2Leb2wnQhvXxDbiblMsSoNgk6TUn/VjYs
         3UebIJTKE+3URrKd4oFh/rwMjENdBjQqBxAbEHuKtWk4zMgkCXVvmNwwAeBT+ZOdZVQd
         LPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762228067; x=1762832867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i0pa7WeHz47MLgq+rdOSlkeWgaQxlJG3XLSzMhA+sBw=;
        b=KluHX2oj6eT5QJxcijt2CzEeZsiOVDWmVqFOqvWBYjPF08rs5FbDuuQErDolTuy+ix
         OK73HSFlSV3tWErzifXgmOh2smp0+ueZo6JVafuxNHEvYMq5D+5jeERHyPSmxXWhorZ9
         JxfIQu9YtTCC0ul/jtiiABRXk1TIbS86GCFvGfYcElqE5As2fxx/HjIBtvoCfzEsX9tm
         lxA8qoyY4iUfy8PBjlHYocSO77C53bi2AqZFI88KNLFM22pDoPbGpUHBuV7gK7h+f/57
         6kU4m7qrFG4ijlJw9SzNWoF893lbXFzgYVjtA81wWI+KKdwACdxhzZL49SzTUw7IAZJH
         y/lA==
X-Gm-Message-State: AOJu0YxedIjwu9QoMGPKre1gMFFxGQlaTFS93NEaj91bDcpCr1hcnh/t
	WqWjuBn9TFki4dtyM2B2qSjo06cf36jS47tEn4vg2iWGwaVuriGJiF8oUpQkzTJyQqvQebRzRFz
	RlbAcNStCx5KBp9UqAKIjJIFBFyZIEwo=
X-Gm-Gg: ASbGncuZqJ68OBKj64ANSFvxQsG3buy+nBxF1XUJEOxNbopH8RIkx9EKyfQ/FeTyTRi
	e0OxClOQdRT1K483sM83bEMRW6cPcsK+UYZHL0pwWZnaGBYhHcVmmlWtw2j3Lf6GiIsRe5FQu84
	wyvlUvEJsHg8sMPVXDOC/+uopg1myX4J27hjSE2YnGiXEhWg12vChsSA4Z4omUQP48M8uUZZGpe
	7DU330gLMS4z5+B13cRcKEuI+90vT+9/p8iwCANa1lw/OzuSoG4xf4KIcT9HwV9zgeQfS4Tr7Vr
	FGy+iiXRiHNElQY2
X-Google-Smtp-Source: AGHT+IGOIVCFrSUGPZxgm5CFHiWVd9cq9GgBXRxZwbWr0M8xS7ROgHPlmVFJAjqv8pGjWXVr2hKxx8I/3dtQzmHBvdM=
X-Received: by 2002:a05:620a:448a:b0:8a4:40da:b8f9 with SMTP id
 af79cd13be357-8ab9b88036bmr1932468985a.76.1762228066783; Mon, 03 Nov 2025
 19:47:46 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com> <20251029-swap-table-p2-v1-3-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-3-3d43f3b6ec32@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 4 Nov 2025 11:47:35 +0800
X-Gm-Features: AWmQ_blJfTuoUvr32Du3u6wr18BZxK5VzePjdpb6Cvkx1_DpxqtXBlWvqOETAzM
Message-ID: <CAGsJ_4xsUwUH_VyeYaXHURqTS66Fbuxa00GTM5izwK-=Vg_20g@mail.gmail.com>
Subject: Re: [PATCH 03/19] mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 04D2480004
X-Stat-Signature: bwnq473cho1b6tht58sqfkm91c61i58a
X-Rspam-User: 
X-HE-Tag: 1762228067-787351
X-HE-Meta: U2FsdGVkX1/7IVrJ+hUhn1jmGJ8pinf6NYKXH6SlTFVaNirxuthycNRp9xmgVBEQr1jhnEh3SVoptPxs5tqTgdacioC4rfIoPWZCb5ake/vEzl5wCw46cz7RmfWSn0X3fDG5FBqHDZo+I+UAzeU861LqemJqi6wfV6xqpGKCEzqjfuTWiszMXtcTCBgaKVnz9GAfdtmK7vDpHM8YDMLPN2iXguPI5FhFmakBV0w2tSfzjI9DUSpuzbSe/lNB8v71zRDA5hRufmgrBVrl1RElf9A9/pquJbP5mehjERZAO40OBt3cJDlr+Qc1IkCLNL8m0eMHPrzM+MN/l4ikpuYC0mKd0Ke4YIVDBxjSrr5n3PsDUe+yBHx4Ru2dGkcCC6hhZ86WgprjolWXKYMTm3ice0zbaXL/8w+lfMa1qfQp4UnozT1WeOTCNtbfYc07hG/m/UxZmmUu77PIPN30BJ25ji7vkf0d5nrJ+d0pr/I3jXwXzJmMwvnH1e2xg6KJjsrxwWoWX+1Q4DWiaXUWAyN8MEFTJLTy4jQhTeTH2XubyuHZTdzaZjcUWsBkzifmhK37KUV02Rdz0svdHhLb/HdQNf0te6tiVm/8x8KOLqlOFaVxX0pxWIVAtGEGR7qKCckvRQrDnuqHBvoFe4hjYvFuUAY4VbLXJBb6ofnFZ+P2HMd/wdwG3q9PU3z1Q106AlX934vLMvUnNE+oKQVZjxacwpdn+E1sp/pC3LmpZsdgI5MCytEw57ECXDSJLjss72lvFdgUDmotl98rvAa1ieBcau77hleUU3uzAv1FaZiyn9WQdlTPeaEy1QJbrpMQUy/NEuHPYbbqJeBTyWPxyt6/euMkBp5qRKZ0PWxJGMptSIQ+qJuT4uUKI5WbERfEzjVWOn3iP3WXZYTi4i66u0YlWPYrNqlNUkldzljXZSi5y6CRBHsUFlN+thV1bPFa4MX+muKaZUwNfGaP9G9Y68R
 EvROhNUk
 V0k+jttR3n9jjA5Tv6bDC08Oec8QzmIYsWvKKSPauFVLWr2jr9JKqEvFUl5sAsWaMBmdf4GLHIE1hZmZjjJsTHxOBFYnSyn5D9HFgqDsWW0Hs/OY3NxUK/ONo8HUsqKdryT91LiG+1DCE/d3tZWBwGWP1QJeyZ4CMxM2cfk0azR1fwu8jHsfsq5oU4TWkN+LOq7q//6cYqaqOMd3pDq3u8kgE8VmitdtxdHs69IIlHnSKdJ1SU4GnpIniAdJuMPq+2BjNzkEPeVyp6Mq7uvh6p56TsTEW9QwG2qexzAX1o1WFCrK7MofHTUFOKDkId01s/tAsO0ZZRWlffVhPl65fPrY0xfMcdztZmPxhfwmr9f0fDXDxFefGf06bwlL1kWVuAETvHStG71huOc9Jidqr9td0E5CgBrz5qA3x0H+c74DuKf6oYOR2q8IpQ6o1SIuFrhJ9CpORe2QEmNo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 11:59=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Now the overhead of the swap cache is trivial, bypassing the swap
> cache is no longer a valid optimization. So unify the swapin path using
> the swap cache. This changes the swap in behavior in multiple ways:
>
> We used to rely on `SWP_SYNCHRONOUS_IO && __swap_count(entry) =3D=3D 1` a=
s
> the indicator to bypass both the swap cache and readahead. The swap
> count check is not a good indicator for readahead. It existed because
> the previously swap design made readahead strictly coupled with swap
> cache bypassing. We actually want to always bypass readahead for
> SWP_SYNCHRONOUS_IO devices even if swap count > 1, But bypassing the
> swap cache will cause redundant IO.

I suppose it=E2=80=99s not only redundant I/O, but also causes additional m=
emory
copies, as each swap-in allocates a new folio. Using swapcache allows the
folio to be shared instead?

>
> Now that limitation is gone, with the new introduced helpers and design,
> we will always swap cache, so this check can be simplified to check
> SWP_SYNCHRONOUS_IO only, effectively disabling readahead for all
> SWP_SYNCHRONOUS_IO cases, this is a huge win for many workloads.
>
> The second thing here is that this enabled a large swap for all swap
> entries on SWP_SYNCHRONOUS_IO devices. Previously, the large swap in is
> also coupled with swap cache bypassing, and so the count checking side
> effect also makes large swap in less effective. Now this is also fixed.
> We will always have a large swap in support for all SWP_SYNCHRONOUS_IO
> cases.
>

In your cover letter, you mentioned: =E2=80=9Cit=E2=80=99s especially bette=
r for workloads
with swap count > 1 on SYNC_IO devices, about ~20% gain in the above test.=
=E2=80=9D
Is this improvement mainly from mTHP swap-in?


> And to catch potential issues with large swap in, especially with page
> exclusiveness and swap cache, more debug sanity checks and comments are
> added. But overall, the code is simpler. And new helper and routines
> will be used by other components in later commits too. And now it's
> possible to rely on the swap cache layer for resolving synchronization
> issues, which will also be done by a later commit.
>
> Worth mentioning that for a large folio workload, this may cause more
> serious thrashing. This isn't a problem with this commit, but a generic
> large folio issue. For a 4K workload, this commit increases the
> performance.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/memory.c     | 136 +++++++++++++++++++++-----------------------------=
------
>  mm/swap.h       |   6 +++
>  mm/swap_state.c |  27 +++++++++++
>  3 files changed, 84 insertions(+), 85 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 4c3a7e09a159..9a43d4811781 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4613,7 +4613,15 @@ static struct folio *alloc_swap_folio(struct vm_fa=
ult *vmf)
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>
> -static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
> +/* Sanity check that a folio is fully exclusive */
> +static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
> +                                unsigned int nr_pages)
> +{
> +       do {
> +               VM_WARN_ON_ONCE_FOLIO(__swap_count(entry) !=3D 1, folio);
> +               entry.val++;
> +       } while (--nr_pages);
> +}
>
>  /*
>   * We enter with non-exclusive mmap_lock (to exclude vma changes,
> @@ -4626,17 +4634,14 @@ static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
>  vm_fault_t do_swap_page(struct vm_fault *vmf)
>  {
>         struct vm_area_struct *vma =3D vmf->vma;
> -       struct folio *swapcache, *folio =3D NULL;
> -       DECLARE_WAITQUEUE(wait, current);
> +       struct folio *swapcache =3D NULL, *folio;
>         struct page *page;
>         struct swap_info_struct *si =3D NULL;
>         rmap_t rmap_flags =3D RMAP_NONE;
> -       bool need_clear_cache =3D false;
>         bool exclusive =3D false;
>         swp_entry_t entry;
>         pte_t pte;
>         vm_fault_t ret =3D 0;
> -       void *shadow =3D NULL;
>         int nr_pages;
>         unsigned long page_idx;
>         unsigned long address;
> @@ -4707,57 +4712,21 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         folio =3D swap_cache_get_folio(entry);
>         if (folio)
>                 swap_update_readahead(folio, vma, vmf->address);
> -       swapcache =3D folio;
> -

I wonder if we should move swap_update_readahead() elsewhere. Since for
sync IO you=E2=80=99ve completely dropped readahead, why do we still need t=
o call
update_readahead()?

Thanks
Barry

