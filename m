Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4CEC87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 05:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD6E8E0006; Thu,  7 Aug 2025 01:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD118E0001; Thu,  7 Aug 2025 01:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C328E0006; Thu,  7 Aug 2025 01:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 88E688E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:34:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37AB9BB895
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:34:34 +0000 (UTC)
X-FDA: 83748846468.12.54A6C61
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf10.hostedemail.com (Postfix) with ESMTP id 57C3EC000A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:34:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CtgUymzN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754544872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0q8hUrFupG27i8HWsQxxW/0Vdf5AjjEm/LYkQBdQCMY=;
	b=0P3FF4WL1whh61j/cGf6aN+4bBc+HctqPSZVYFBFwTovPkTCWqPrpLe2wngNiV6g7JRFRS
	xkpiPntxzKsOVhHp5Vnk4PN7wAOtkU1shjbXlZ5kdtSJO9LuIoa/ArsxhIGEVslcf7lSQ/
	YbkUoNJD1F+fAtyW8RnMhnPuy9tfENM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754544872; a=rsa-sha256;
	cv=none;
	b=tWTTllvsXhg2NQtC9TL4Z+lGq37Y+7tQlx/iR7AaYc6bvEdDxVguzTMukSRBTQ1bMFjzbP
	pDcnjDY4KaI6hbSf+pvWZbMzNKytoDz50NKyikHu/zyIA6LjNuyiqHD1zZmoSVyuMrp32Q
	2tWnUeOK8cYRDyfntWIFmz10so3sbTo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CtgUymzN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id B77D2A55367
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67844C4AF0D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 05:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754544871;
	bh=RiUS7KSgyHes9dhNZkvcCRdWhBjwo7hlSmrC0k9Zo6A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CtgUymzNh53kTukKYdQFncA2wzaaMlLvuoVQAf2wIuGou/soT396FVrzmfhXXfvu5
	 orf4Qea/PZy9rPI9+lXK2rp9QMUCYvtcewMbyfsA5zVjKM8x8ipRIIDj7TJzY4Gg3b
	 3aq7JIqUEuD348XKwscYCJc8CThXe0bTSSIfDT8BIMzpxjcumrK6qLzpWzux7h6Lxe
	 NHEXItQYbcio3/JqynER49PHFu3tqodFDQMZMO2kvXgstq7G3ztIv8UvqfqXsVrawK
	 iP1y6YZJTypg1+KR8NQ8YPSsyqzzrmWNuk8XvpPYqMtddGpEXej/3OOajy08fwvuHK
	 PvGCFeQ5QF82w==
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-458bf57a4e7so29635e9.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 22:34:31 -0700 (PDT)
X-Gm-Message-State: AOJu0YyyQIY+YpYi+Ow8WRXKNsP7BsNlqyUaQ7q2yzFB6eEnzZ2sbEco
	M1paD1Gga0eCOPq1e4juVq8kCyerQxZgCGciXd/FYnt+qSPftbYVNWOMqt16e2con9fI1n/oiiV
	ugRV3osCOr+ahwmHn/M9D5Q6+48oSk5/e9UtOgyut
X-Google-Smtp-Source: AGHT+IFIrjsa3bqiUdILHj0K82UG+gs0VXdeHKXr68Tr9yha8S6Xfrc88nTWNYBeV/BoCilZCd/fft4sfMojVba1RW0=
X-Received: by 2002:a05:600c:3148:b0:456:4607:b193 with SMTP id
 5b1f17b1804b1-459f0357255mr303415e9.7.1754544870120; Wed, 06 Aug 2025
 22:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250806161748.76651-1-ryncsn@gmail.com> <20250806161748.76651-3-ryncsn@gmail.com>
In-Reply-To: <20250806161748.76651-3-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 6 Aug 2025 22:34:19 -0700
X-Gmail-Original-Message-ID: <CAF8kJuMxnMP67GT9poH2eopOSJaXcnior47rEQGipmDCPuc5eQ@mail.gmail.com>
X-Gm-Features: Ac12FXwJ1IgtZ56cqLlvklOoOtpKEXAtVQDzpJTF-FJ8utQN16JVaoRrM7ujyB0
Message-ID: <CAF8kJuMxnMP67GT9poH2eopOSJaXcnior47rEQGipmDCPuc5eQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm, swap: remove fragment clusters counter
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eagoqe5msopb8ssju86d6hpsdk53zxfn
X-Rspamd-Queue-Id: 57C3EC000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754544872-552567
X-HE-Meta: U2FsdGVkX1/a8CVQdt72N3abPeNOkh64enFrty6vhAXRgiiFUieXjrNtsFfxdQ1ceUcYNKP6cwgPtD0c0PGJaefqKaUTbZGd3dOcPcyuF8Gvm7FILreyo/d6FgUQX0seN+wxniGAcy1EVd5QQsoXb4XHCC2zfzJoKUzBwFzR1hlYHFQkCPl5CJlEGMWUej1fi4O/N+NMT2sTm9GvbsyZyVTTickxEWGCq1j2XyJFdmfUy9W90dk4SzaGR1VWC1RcN29RgqPuhHVb4WbmC1e1UpHvdtVEYfypOFnOk4e7sun+jrrLcDK+M4RyJh6WBDU2DP/5VS5bboAxKNMHS4WBqJX1kvity1KRuuVWMvtTgKqP3FOpKglCMGk+9A8wx7Y2mT+BKNdCV23jA7ytoJL3k8aws3FCSFfR8r+3mcTcWYeCzp669UtVXGbrntOZrauKYn6pwoVbbAv/by4kuQOp7MoDaGi0AgTM3hBG0TA5atMsjn3Mi75s16SY+kNfYTKkcfdlH8eEUuTxpprL0m2/dW59K3E1Dg7KK/617lbVgBKKn2nVOJ1qHWBVMFE+IIUsAMnTv3dUWUvqn554p9Rt53axiL0b/zVaZtuK1Htbz0YjGw3sqaxdO+W2dbiiXjSlBOoggOARdudeYGJoN4KBFCExWH/wf/5s97YpwH8tWgtPllZVFkwH9TBWnpvoJcw2sZz+A9MSTnAOs0Ue75hrZu2mwze5kAh0jvcPLhcvI74PYh4CZY3rQ35fehfPzGTt2VKgXE4x3mndz5Wbp2Jv2GnNHbbfu4K5aicFAQunb8R0uUhK3cfhNJWWS5suZs9sxcLVqYSo5bKSkZ9R/GgCsJfFLAPVW5sssxPBOuRNRSQ+u6MQ9TWEw3UZg7kx+2LCWFARHCtwOMVjNIwr+0isRrpEqg+U5Rpco/QhYShQU8ueQYl0yeU4XWaewGL3EThmTfZq4leeZetXWWXdNEH
 HmtGS16V
 SZYkcMI9zYXpMnSWuhAzd8GSQHRIouLD8kjH4yJNjf8cYqseGWdsbn0PXwAtdBofFpPp6l7BolahzkfS9dK490Kzz9hK8kLquxVz5PqTPD0OTeRhEdUJVxbq/xw8Ahehos3RK2JWsJfUcK6J1PWh+GpdqWHzatGROQ09MEwzvqcfA0qxgn+2+sULec1i5aGk1qTM7UHxCiWHflgp9iEIOOr4aPlNEZA39Iojfzdrv+K3StBWAcSyw2Kl/4fpyGCD9dWFIcgXxY6xbTyiYX+6OcCN/qto2uqKgta2dZde02D2fKPnmoQ/uOLezL2rOLgAok7lrEJDrHFBlbD2535gRu2j6utlMxsK10zWGg537SvUfvoYUob54iQ33/4f3MY/b0TFY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Wed, Aug 6, 2025 at 9:18=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> It was used for calculating the iteration number when the swap allocator
> wants to scan the whole fragment list. Now the allocator only scans one
> fragment cluster at a time, so no one uses this counter anymore.
>
> Remove it as a cleanup; the performance change is marginal:
>
> Build linux kernel using 10G ZRAM, make -j96, defconfig with 2G cgroup
> memory limit, on top of tmpfs, 64kB mTHP enabled:
>
> Before:  sys time: 6278.45s
> After:   sys time: 6176.34s
>
> Change to 8G ZRAM:
>
> Before:  sys time: 5572.85s
> After:   sys time: 5531.49s
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/swap.h | 1 -
>  mm/swapfile.c        | 7 -------
>  2 files changed, 8 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 2fe6ed2cc3fd..a060d102e0d1 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -310,7 +310,6 @@ struct swap_info_struct {
>                                         /* list of cluster that contains =
at least one free slot */
>         struct list_head frag_clusters[SWAP_NR_ORDERS];
>                                         /* list of cluster that are fragm=
ented or contented */
> -       atomic_long_t frag_cluster_nr[SWAP_NR_ORDERS];
>         unsigned int pages;             /* total of usable pages of swap =
*/
>         atomic_long_t inuse_pages;      /* number of those currently in u=
se */
>         struct swap_sequential_cluster *global_cluster; /* Use one global=
 cluster for rotating device */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 1f1110e37f68..5fdb3cb2b8b7 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -470,11 +470,6 @@ static void move_cluster(struct swap_info_struct *si=
,
>         else
>                 list_move_tail(&ci->list, list);
>         spin_unlock(&si->lock);
> -
> -       if (ci->flags =3D=3D CLUSTER_FLAG_FRAG)
> -               atomic_long_dec(&si->frag_cluster_nr[ci->order]);
> -       else if (new_flags =3D=3D CLUSTER_FLAG_FRAG)
> -               atomic_long_inc(&si->frag_cluster_nr[ci->order]);
>         ci->flags =3D new_flags;
>  }
>
> @@ -965,7 +960,6 @@ static unsigned long cluster_alloc_swap_entry(struct =
swap_info_struct *si, int o
>                  * allocation, but reclaim may drop si->lock and race wit=
h another user.
>                  */
>                 while ((ci =3D isolate_lock_cluster(si, &si->frag_cluster=
s[o]))) {
> -                       atomic_long_dec(&si->frag_cluster_nr[o]);
>                         found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
>                                                         0, usage);
>                         if (found)
> @@ -3217,7 +3211,6 @@ static struct swap_cluster_info *setup_clusters(str=
uct swap_info_struct *si,
>         for (i =3D 0; i < SWAP_NR_ORDERS; i++) {
>                 INIT_LIST_HEAD(&si->nonfull_clusters[i]);
>                 INIT_LIST_HEAD(&si->frag_clusters[i]);
> -               atomic_long_set(&si->frag_cluster_nr[i], 0);
>         }
>
>         /*
> --
> 2.50.1
>
>

