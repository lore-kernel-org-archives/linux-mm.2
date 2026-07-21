Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F164DC4452D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8BC6B008A; Tue, 21 Jul 2026 04:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9A4B6B008C; Tue, 21 Jul 2026 04:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C7C6B0092; Tue, 21 Jul 2026 04:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72CBA6B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:15:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7897C03C9
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:15:28 +0000 (UTC)
X-FDA: 85012074336.01.D223CFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id ECEB7140009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:15:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n5k3iHYy;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784621727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6GIJgFDTy/vqDnytZl/JyP3muRYfZ+Zlb37RJw8cgk=;
	b=QmiVJOGXfSKYfB/89ox/Gmvr3Ra05HMB8OJJYi7D8JCAAuJmhO6zDuzX9Px43lNkJnVZQH
	Tt7b+1T0xZDxw7DBVMqB92br9NqyTRV6ETTZdxWAQZs2QGQuvY38YYsW2HjEPnXdaYtMRR
	BPTCPcgB187ycqFZmCNWswLp5jLbh5g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n5k3iHYy;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784621727;
	b=QrSRBXDPmbCK3py8zsw2aFCOUXEO/hhPuB3akex+i+B6npB9D/LYRPd70GXfvEDBrXyFlh
	AKtLGKlqGpv2Ls9T8tOp+0CGN+CCbDvsrfrj+Esg+gx0l2ho7z5nTEEAHhfsEXuhK4zfhP
	nrEsUgGp3vc7gDkDJX2p8lnX/Ddw1Vk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AF6B42E95
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E294D1F00A3A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784621725;
	bh=k6GIJgFDTy/vqDnytZl/JyP3muRYfZ+Zlb37RJw8cgk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=n5k3iHYyQ4x9VWvNLgqcIY1xEJ3XL0lAxNgb2qil6Kjo6K4Vyh2FgajRr06GhzgyC
	 AxTLIPiHqmyGxzVBzas/qYycNnq/eA7xeFzR7GPw4HTipIjJqgu8tVdjylkMgm7STt
	 mnidJQXNoVNic2s59h+6wCBIa5VDnENUT18OTcnudPQdpY+hsWzBDKtS5qf+UbkIcp
	 B0m92v7HH2GNgVfqeP8yQ2DD7aSKHY+Irbz2U/65GCZiSgXLl4Jw9QJjG5G84upptE
	 vw4y6xtNHoPvdH6RFcVfbEfm7idNwDs11VVQ/BE3SRILBuZs/dXlzGLxBgD7PfIdXz
	 zIv98HCEgOvrw==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8efcfdb2b43so111484616d6.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:15:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rovt551V5km78Ak8+T42DL8KXSojPzUqMDRuxGXrwNLTBhqHhwnchmq9F4oSmYjuYAQM3U+LU7z6w==@kvack.org
X-Gm-Message-State: AOJu0YwEK7ceK8y5wYok1Z8naJUtLldSfXjs6aiog3kyav36bFITMpTM
	c6//DPMSLvrQBgzrTiu6JKGut3eXRDyiA6NWrM/BYQlSYKN3tcVAwx0gW0+OWDwIIC8wxIxxjXS
	I84HL7yhc6Xykh2AEIr0ToPCgqLsxFmY=
X-Received: by 2002:a05:620a:a489:b0:930:b867:4c9a with SMTP id
 af79cd13be357-930b8675a97mr1453716485a.56.1784621725297; Tue, 21 Jul 2026
 01:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com> <20260717122514.51514-3-xueyuan.chen21@gmail.com>
In-Reply-To: <20260717122514.51514-3-xueyuan.chen21@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 21 Jul 2026 16:15:13 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xv2AGrLY2PBA77fZiqctPEt_ERcUXUvFOdOG72LD_usQ@mail.gmail.com>
X-Gm-Features: AUfX_mxDnJFvZOXGyq-1zLN4DNo65_cLn0W0QN8SJWGyzS-He2qedvUT5lVMyN4
Message-ID: <CAGsJ_4xv2AGrLY2PBA77fZiqctPEt_ERcUXUvFOdOG72LD_usQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/4] mm: distinguish large folio swap allocation failures
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baolin.wang@linux.alibaba.com, hughd@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECEB7140009
X-Stat-Signature: 7z4xct7ifgkgbub5z76qbm1g3dzteg55
X-HE-Tag: 1784621726-929435
X-HE-Meta: U2FsdGVkX19tiOLI+QDSB5jtgQFQuwvLqc0maCwbufuxVODgr6O8mD/pAt2jIE03wH9Vo6MGFfFHfApQgIxsoxxmL3MLNmEc1oYNCUDpYtFHcAtANakW97+JR2Ol86RA4DkG94xoENj4BqdfnHSaldTcevzn88U1x3rKGufz/6xuT+texfBPbRmGwCz/iGPrHzgl6Q+IwlsLJWtqI+Wmju6Mm9asztgr48x/mEE7D+xpy8n7Z1RUwx1eLz4p2mSf8pNpcRMYKhDL9Cr41Ljjrz7xJf1D3scwHZcllr25yXaG9CSTG1QcdbDSvXkk8gnbcZhDOgjI10xEO6NwITpbqG39vYsLJda2TrItKu7UiTIR7vsdXCrUTZ55TYsPSyRqIFHv69N5ylLLIueWfaAipgNxe3QO9F49JktdV+A23HEV7h4NsC9Y3x4W2qvwGxLdP1YVbkPW7f8PkxvASjIUAa46DXmODt5gRGiWPHmWTZc6uAKGAOeUIpiuV80FHkV3TOXxdQodP+l8Rl8MCfmZ3OeXToBatKFIEuX6ba1QQkMuY0TWTK4vSsH4nWF1uh/gm6qPnoWFHVSoC+GDZwFWzPs2laKxR9yI0cdDIs30CevRtBp9ipFLHUTZ7ZvdVPnPmk0z3TXyM0JXM7hjmIMZRsvznHwCKzt7Z0obKRT3kIM6hUnHgaQ5GZHLsgx6qg2SJLcTbQvVtCjX5dPrhztd4rCTQjBGR/1m4zvGVvjXUOX/+9+HDtzRJRaIb9SR4RaMz4LmDe8C7ZDAbt7+8lDky/Do6VSRKJvt8+1NkHCuvdULxc3Q1OL5lzcMmEmrHCjQo+u811LRCbaFAd7mMooqOqQVNjvZ/VFjhBqvDlI5k6Cr5Pdupalqo0nG7WENBxUqoGoK4DZygDL9LHTaFpsLNsB5eKJcOJ1tB7oFl7IMeSx+LdTW/NFVPCkXGT/pL9s4aqTre6QC0dBrFSQOKBd
 ohqyGAiR
 nuTukupdRAeWK9XBFiJx32FnNrnOL/PvqZ/Roef5xYAhxvFxnH9FVVGOw0sL1U5s5GKpsbj8t4GjVdsxwIqfTzECKc00O6BPmaQnX+I8wUIYyNCboUYQl8OkbWZ5KLgCHZjQT9C1Oqrxq9OAd7vNkgxUDtmAJjKgTzEjctq5wyt7ZftGmTwI4PHgJNqseE/qPgg4nw0XZV84Mq0w61FeGRXvomaOX9ycQCiYnVzFD2ubQjRuNh/tD/6zoaRnCWiNjxuPHu4uCDl3Nd/wQO8AeSRrSKBPTsUSAs/pOMhXjA80M3b3LzWr9YN6VjBK0t/p4SE8dRf2g0zR+a4LdDFNQtnQdA/3RGPWht4XsKVpsNtZXj4sk49lfE7KkLKG4iKNPyJLc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 8:25=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail.=
com> wrote:
>
> folio_alloc_swap() reports most allocation failures with a generic
> negative error code. Reclaim cannot tell whether splitting a large folio
> could make progress or whether there is no backing space at all.
>
> Track the global free swap count around the allocation attempt and let th=
e
> memcg swap charge path cap it by the remaining hierarchical swap margin.
> Return -E2BIG for large folios when a smaller allocation might still fit,
> -ENOSPC when no swap space is available, and -ENOMEM when the failure is
> not helped by splitting.
>
> This only refines folio_alloc_swap() return codes. The reclaim caller is
> updated separately.
>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  include/linux/swap.h | 10 ++++++----
>  mm/memcontrol.c      | 10 +++++++++-
>  mm/swapfile.c        | 21 +++++++++++++++------
>  3 files changed, 30 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 7a09df6977a5..0695ac56457f 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -571,13 +571,14 @@ static inline void folio_throttle_swaprate(struct f=
olio *folio, gfp_t gfp)
>  #endif
>
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> -int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)=
;
> +int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
> +                                long *nr_swap_pages);
>  static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> -               swp_entry_t entry)
> +               swp_entry_t entry, long *nr_swap_pages)
>  {
>         if (mem_cgroup_disabled())
>                 return 0;
> -       return __mem_cgroup_try_charge_swap(folio, entry);
> +       return __mem_cgroup_try_charge_swap(folio, entry, nr_swap_pages);
>  }
>
>  extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int n=
r_pages);
> @@ -592,7 +593,8 @@ extern long mem_cgroup_get_nr_swap_pages(struct mem_c=
group *memcg);
>  extern bool mem_cgroup_swap_full(struct folio *folio);
>  #else
>  static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> -                                            swp_entry_t entry)
> +                                            swp_entry_t entry,
> +                                            long *nr_swap_pages)
>  {
>         return 0;
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1e10f493d2a9..7c9e7072fb39 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5472,12 +5472,14 @@ int __init mem_cgroup_init(void)
>   * __mem_cgroup_try_charge_swap - try charging swap space for a folio
>   * @folio: folio being added to swap
>   * @entry: swap entry to charge
> + * @nr_swap_pages: optional swap availability to cap by memcg margin
>   *
>   * Try to charge @folio's memcg for the swap space at @entry.
>   *
>   * Returns 0 on success, -ENOMEM on failure.
>   */
> -int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
> +int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry,
> +                                long *nr_swap_pages)
>  {
>         unsigned int nr_pages =3D folio_nr_pages(folio);
>         struct page_counter *counter;
> @@ -5495,6 +5497,9 @@ int __mem_cgroup_try_charge_swap(struct folio *foli=
o, swp_entry_t entry)
>         rcu_read_lock();
>         memcg =3D obj_cgroup_memcg(objcg);
>         if (!entry.val) {
> +               if (nr_swap_pages && !mem_cgroup_is_root(memcg))
> +                       *nr_swap_pages =3D min(*nr_swap_pages,
> +                                            page_counter_margin(&memcg->=
swap));

This looks a bit odd. Could we decouple *nr_swap_pages from margin and
have the function always return margin instead?

I don't think this function needs to care about the initial value returned =
by
get_nr_swap_pages(). While folio_alloc_swap() may depend on it, they're
different software layers, and we shouldn't couple them together.


>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>                 rcu_read_unlock();
>                 return 0;
> @@ -5509,6 +5514,9 @@ int __mem_cgroup_try_charge_swap(struct folio *foli=
o, swp_entry_t entry)
>                 memcg_memory_event(memcg, MEMCG_SWAP_MAX);
>                 memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>                 mem_cgroup_private_id_put(memcg, nr_pages);
> +               if (nr_swap_pages)
> +                       *nr_swap_pages =3D min(*nr_swap_pages,
> +                                            page_counter_margin(counter)=
);
>                 return -ENOMEM;
>         }
>         mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9174f1eeffb0..53a921ca099a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1690,12 +1690,14 @@ static int swap_dup_entries_cluster(struct swap_i=
nfo_struct *si,
>   * swap cache.
>   *
>   * Context: Caller needs to hold the folio lock.
> - * Return: Whether the folio was added to the swap cache.
> + * Return: 0 on success, -E2BIG if splitting the folio might allow swapo=
ut,
> + * or another negative error code if splitting would not help.
>   */
>  int folio_alloc_swap(struct folio *folio)
>  {
>         unsigned int order =3D folio_order(folio);
>         unsigned int size =3D 1 << order;
> +       long nr_swap_pages;
>
>         VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>         VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
> @@ -1706,7 +1708,7 @@ int folio_alloc_swap(struct folio *folio)
>                  * the caller should split the folio and try again.
>                  */
>                 if (!IS_ENABLED(CONFIG_THP_SWAP))
> -                       return -EAGAIN;
> +                       return -E2BIG;

We could also have the case where we're running out of swap space and it's =
not
worth splitting, even when THP_SWAP is disabled.

>
>                 /*
>                  * Allocation size should never exceed cluster size
> @@ -1714,10 +1716,12 @@ int folio_alloc_swap(struct folio *folio)
>                  */
>                 if (size > SWAPFILE_CLUSTER) {
>                         VM_WARN_ON_ONCE(1);
> -                       return -EINVAL;
> +                       return -E2BIG;

Similar to the above.

>                 }
>         }
>
> +       nr_swap_pages =3D get_nr_swap_pages();
> +
>  again:
>         local_lock(&percpu_swap_cluster.lock);
>         if (!swap_alloc_fast(folio))
> @@ -1730,11 +1734,16 @@ int folio_alloc_swap(struct folio *folio)
>         }
>
>         /* Need to call this even if allocation failed, for MEMCG_SWAP_FA=
IL. */
> -       if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap)))
> +       if (unlikely(mem_cgroup_try_charge_swap(folio, folio->swap,
> +                                               &nr_swap_pages))) {

As explained above, we shouldn't couple two different software layers.
don't use nr_swap_pages() as the initial value of memcg charge.

Best Regards
Barry

