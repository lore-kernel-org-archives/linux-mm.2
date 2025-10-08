Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD023CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 20:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6668E001B; Wed,  8 Oct 2025 16:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0873E8E0002; Wed,  8 Oct 2025 16:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9308E001B; Wed,  8 Oct 2025 16:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA1438E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:54:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98A9511AC88
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:54:23 +0000 (UTC)
X-FDA: 83976150006.10.7491134
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7FD971A0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:54:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aNpYkMKZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759956861; a=rsa-sha256;
	cv=none;
	b=01LhDvpntpvC8hkzsZBSPabzqgIcPw11hr9C4qO2kEe1Ut44iVci7h5ALIEcAbQckBCSeQ
	xb12jDVSZSZA16canOg4c+xotERy4jIRNJaJnjjE7tBsbNe/qfuTrcECMQO2Yh6Tj4Djqa
	6t+mOaDjgGnm5D9FwgOpI/ys+5WdItM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aNpYkMKZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759956861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VzzKA6aKDepvaCMfSfxGkQcpjStESyFonwEwWa7HQEY=;
	b=mrqNIKzl6+ksDwfps2XL0mkOR/i7AY0Zm4EI0r65nf8AgrXMbBvO7DcH0GpFy+X8/2ATig
	Jv7ZQDOCDp84UDYawxTiOYBsS0tOvNqYF2HgWkkM79FOdXQTx95T3VdzI9TmMRwZVNtdGs
	DMYzk405JwNHoTjO41fvJYGfokycGbA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BD2543266
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE16C4CEF4
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759956860;
	bh=agL9NQjRm83/yHaWQQb9LP2YNW141HDrTz3t3n7+nWc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aNpYkMKZfCFMWJKhtFzH9ssZDk+h5QDwRDs6/raKHPcAjEdn5aAlINFU1ys/sGiE3
	 v0oOf3aZOVksaFkJyHY1P2B56MsfVxccy5i25BCfvczrn7YXWpCJKvQesr35u69+Sk
	 mbh7+wFiNRR6n4lZ3TETnyHaLccM8C43xfjOz5Datmuaqwvqh7kn+7j4OXcnYvoM5j
	 R+noBr0BQQK+dHuhCP6V0ldfVYyUkS5pXM5nJ4RxksOe0hbz8Uwc0hU1DwAwQbntoT
	 2sbikPEgHZCvPhlZK8ArXxkuNFD6+WFWLMn753uGqV1mLzXcMsmIENMnJ4uCDPnoiN
	 ppLiDdXRuMtew==
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6360397e8c7so393983d50.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 13:54:19 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy1Whbux58DoHVZ/jkuDxw1kUMep/arbOhNqYBZPJz0BzOsLuQE
	R5PWQl9U0iUaA4bJVzdXtjXKWLK69P98quY3wtXOZQ3Zu5nFpecWzUn5NpL/gqXJc3SQdoMgY3W
	oFFqbTkcv42hXidYQ+ho6qjWgs3mI1bi6HMbn/384nA==
X-Google-Smtp-Source: AGHT+IGXcPsre3jPnzCXfW/NrHxTfes0Zrdq4yHGtjhgwz7kNPMXwSCxT4ITZ6YQG7WRPEjbYGDlrMXAh/E7qHIvmVo=
X-Received: by 2002:a05:690e:2486:b0:628:2e16:6566 with SMTP id
 956f58d0204a3-63ccb6763d1mr4749241d50.0.1759956859230; Wed, 08 Oct 2025
 13:54:19 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 8 Oct 2025 13:54:06 -0700
X-Gmail-Original-Message-ID: <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
X-Gm-Features: AS18NWDV4-kH86tXLtXJeQUM8aNsKlZYE7T0tTk3LlA5GEJjYTJActBrpZqaAP8
Message-ID: <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm, swap: do not perform synchronous discard during allocation
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7FD971A0002
X-Stat-Signature: jzkcqfw485w1yqf89uapn99qi7ynp71s
X-HE-Tag: 1759956861-802316
X-HE-Meta: U2FsdGVkX1/WHRvkR0+pZrEGiQzYOs6IrzGPVGdif6YLyXR48qowxzAWcCtgOQKNK3ZBHJF1/QBxYSD4Un+r0sK4vmknCMV8LBkpsjggID+IrxeZFLkDFzSxt3pxfKmwQIuSkLfO+OIGmmhd8POHH5j+ZMnKKxVHH7WLR0YD4s5UApllUtZmZcf4NImuFNj+QsKZJtn8oGOFW2tKI8uKUgGg/2koSw0G8fq+J6cL2ApYFNOWkKUQvJcojIceLVnEKmszZrvRs/J7wxDDZAuQFDsr9SDDAO5XThY/m1Y8IL7KSp2g0pKhFoxM3FIKmOcqeLyeyMtvd3IXT85UqsQbsltqL7DQXlQ9bNDaIuG1L1CQi/sxKzRuHFuiElWBsWmYr7P7lSLoSbyXo5N/hFWm+1VKf0BlGgQlIXouiIPKpRQ7O3SevarEtAKwnzka+wpE6bUtMkoOYjoVWZb/U3E7n8m/+u+RdYC02/Yj0EUV+tUqtsnw8se40Eys96OLi4Ci6cCrJV5KXVTJ25f2TqLtzv4+LqFNqaRGIEcvKWmfEUjx2SXVoJfa4ik79gkw3FNXrI24e2tBUbHvUlsRIEzemV/NNJHPumVydG8zMGlIQ8xnfoFYHDd9q9TfKIuneNwG+uaBvbOSp+1Zvzj9Lt7VtyJmAixq7M14rXn7LXxHcEFUpLAY+4i17+jTm5+DnGbAanA5IXi522B1daq/YP6i976pV9XzkrxL0iC/j5KDNtMLzKN91+JCDnM7AvzeZPmJDpNnMM3U9+5tu6yXL/TwAPDUVGR9b+uQ+jY+eMTgX9a7JO1bgwELIRWhwFjHT5yyVvU9FK/BnbSy7ba6qtk+q1piHv+M3mc5GNoVi4YfWS3hMZNVnJLvWcubOb2iZSGShhp5ATFiwkx5/5Z6NuE9GymdcO8KiXz+Ej56i1ZDESAaJjps3WWzhe9lFJZzbXKtFlIc/gmcJTYphz9MIXe
 XzyzJKzU
 tXIcPnCeJXtB/C5zDJ2cGNwGe9D2B70aFGeWG+hJxMeeyMS6B89TW0X3KFwW67OLESl8/2jeMuJ4747RWXY3lUv6lnkHlHAP+2YbVLTlZK16FX8BTrqGeZ9S/de4C0Fj8sMVLhCBPeszg8S5tXRgkTIZl7re5x6MUVkkKAgQT9SDYBBdX15Tr19/kkEhI1632PqjkxGppBWEEFQMQyDV0vPhoeiDLezGljWtf+tOqGIKYc4d0C4ic11MXDDdhJjk2y8/FVpaLFj/FnSpdc3paEhhlbYE8pgzVe7kyiAK3QGs29n5gGBnGYv/Ar6XM3SYgklZT/NfnAw4+trm62xmxtPvlKLLoewgZcz3/K7ggAXIiiIQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

First of all, your title is a bit misleading:
"do not perform synchronous discard during allocation"

You still do the synchronous discard, just limited to order 0 failing.

Also your commit did not describe the behavior change of this patch.
The behavior change is that, it now prefers to allocate from the
fragment list before waiting for the discard. Which I feel is not
justified.

After reading your patch, I feel that you still do the synchronous
discard, just now you do it with less lock held.
I suggest you just fix the lock held issue without changing the
discard ordering behavior.

On Mon, Oct 6, 2025 at 1:03=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> Since commit 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation
> fast path"), swap allocation is protected by a local lock, which means
> we can't do any sleeping calls during allocation.
>
> However, the discard routine is not taken well care of. When the swap
> allocator failed to find any usable cluster, it would look at the
> pending discard cluster and try to issue some blocking discards. It may
> not necessarily sleep, but the cond_resched at the bio layer indicates
> this is wrong when combined with a local lock. And the bio GFP flag used
> for discard bio is also wrong (not atomic).

If lock is the issue, let's fix the lock issue.

> It's arguable whether this synchronous discard is helpful at all. In
> most cases, the async discard is good enough. And the swap allocator is
> doing very differently at organizing the clusters since the recent
> change, so it is very rare to see discard clusters piling up.

Very rare does not mean this never happens. If you have a cluster on
the discarding queue, I think it is better to wait for the discard to
complete before using the fragmented list, to reduce the
fragmentation. So it seems the real issue is holding a lock while
doing the block discard?

> So far, no issues have been observed or reported with typical SSD setups
> under months of high pressure. This issue was found during my code
> review. But by hacking the kernel a bit: adding a mdelay(100) in the
> async discard path, this issue will be observable with WARNING triggered
> by the wrong GFP and cond_resched in the bio layer.

I think that makes an assumption on how slow the SSD discard is. Some
SSD can be really slow. We want our kernel to work for those slow
discard SSD cases as well.

> So let's fix this issue in a safe way: remove the synchronous discard in
> the swap allocation path. And when order 0 is failing with all cluster
> list drained on all swap devices, try to do a discard following the swap

I don't feel that changing the discard behavior is justified here, the
real fix is discarding with less lock held. Am I missing something?
If I understand correctly, we should be able to keep the current
discard ordering behavior, discard before the fragment list. But with
less lock held as your current patch does.

I suggest the allocation here detects there is a discard pending and
running out of free blocks. Return there and indicate the need to
discard. The caller performs the discard without holding the lock,
similar to what you do with the order =3D=3D 0 case.

> device priority list. If any discards released some cluster, try the
> allocation again. This way, we can still avoid OOM due to swap failure
> if the hardware is very slow and memory pressure is extremely high.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation fast pa=
th")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 40 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 33 insertions(+), 7 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index cb2392ed8e0e..0d1924f6f495 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1101,13 +1101,6 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si, int o
>                         goto done;
>         }
>
> -       /*
> -        * We don't have free cluster but have some clusters in discardin=
g,
> -        * do discard now and reclaim them.
> -        */
> -       if ((si->flags & SWP_PAGE_DISCARD) && swap_do_scheduled_discard(s=
i))
> -               goto new_cluster;

Assume you follow my suggestion.
Change this to some function to detect if there is a pending discard
on this device. Return to the caller indicating that you need a
discard for this device that has a pending discard.
Add an output argument to indicate the discard device "discard" if needed.

> -
>         if (order)
>                 goto done;
>
> @@ -1394,6 +1387,33 @@ static bool swap_alloc_slow(swp_entry_t *entry,
>         return false;
>  }
>
> +/*
> + * Discard pending clusters in a synchronized way when under high pressu=
re.
> + * Return: true if any cluster is discarded.
> + */
> +static bool swap_sync_discard(void)
> +{

This function discards all swap devices. I am wondering if we should
just discard the current working device instead.
Another device supposedly discarded is already on going with the work
queue. We don't have to wait for that.

To unblock the current swap allocation.  We only need to wait for the
discard on the current swap device to indicate it needs to wait for
discard. Assume you take my above suggestion.

> +       bool ret =3D false;
> +       int nid =3D numa_node_id();
> +       struct swap_info_struct *si, *next;
> +
> +       spin_lock(&swap_avail_lock);
> +       plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail=
_lists[nid]) {
> +               spin_unlock(&swap_avail_lock);
> +               if (get_swap_device_info(si)) {
> +                       if (si->flags & SWP_PAGE_DISCARD)
> +                               ret =3D swap_do_scheduled_discard(si);
> +                       put_swap_device(si);
> +               }
> +               if (ret)
> +                       break;
> +               spin_lock(&swap_avail_lock);
> +       }
> +       spin_unlock(&swap_avail_lock);
> +
> +       return ret;
> +}
> +
>  /**
>   * folio_alloc_swap - allocate swap space for a folio
>   * @folio: folio we want to move to swap
> @@ -1432,11 +1452,17 @@ int folio_alloc_swap(struct folio *folio, gfp_t g=
fp)
>                 }
>         }
>
> +again:
>         local_lock(&percpu_swap_cluster.lock);
>         if (!swap_alloc_fast(&entry, order))
>                 swap_alloc_slow(&entry, order);

Here we can have a "discard" output function argument to indicate
which swap device needs to be discarded.

>         local_unlock(&percpu_swap_cluster.lock);
>
> +       if (unlikely(!order && !entry.val)) {

If you take the above suggestion, here will be just check if the
"discard" device is not NULL, perform discard on that device and done.

> +               if (swap_sync_discard())
> +                       goto again;
> +       }
> +
>         /* Need to call this even if allocation failed, for MEMCG_SWAP_FA=
IL. */
>         if (mem_cgroup_try_charge_swap(folio, entry))
>                 goto out_free;

Chris

